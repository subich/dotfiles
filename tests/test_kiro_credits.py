import importlib.machinery
import importlib.util
import json
import sqlite3
from pathlib import Path

SCRIPT_PATH = (
    Path(__file__).parent.parent
    / "home"
    / "dot_config"
    / "tmux"
    / "executable_kiro-credits"
)


def load_module():
    loader = importlib.machinery.SourceFileLoader("kiro_credits", str(SCRIPT_PATH))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


def test_formats_credit_usage_for_tmux():
    module = load_module()
    response = {
        "usageBreakdownList": [
            {
                "resourceType": "CREDIT",
                "currentUsageWithPrecision": 1193.36,
                "usageLimitWithPrecision": 10000.0,
            }
        ]
    }

    assert module.format_usage(response) == "12%"


def test_fetch_usage_posts_profile_and_resource_type():
    module = load_module()
    calls = []
    expected_response = {"usageBreakdownList": []}

    def post(url, headers, body, timeout):
        calls.append((url, headers, body, timeout))
        return expected_response

    assert module.fetch_usage("test-token", "test-profile", post) == expected_response
    url, headers, body, timeout = calls[0]
    assert url == "https://codewhisperer.us-east-1.amazonaws.com/"
    assert headers["Authorization"] == "Bearer test-token"
    assert headers["X-Amz-Target"] == ("AmazonCodeWhispererService.GetUsageLimits")
    assert headers["Content-Type"] == "application/x-amz-json-1.0"
    assert json.loads(body) == {
        "profileArn": "test-profile",
        "resourceType": "AGENTIC_REQUEST",
        "isEmailRequired": True,
    }
    assert timeout == 5.0


def test_returns_fresh_cached_usage_without_refresh():
    module = load_module()
    cached_response = {
        "usageBreakdownList": [
            {
                "resourceType": "CREDIT",
                "currentUsageWithPrecision": 1193.36,
                "usageLimitWithPrecision": 10000.0,
            }
        ]
    }
    refreshes = []

    def post(*_args):
        refreshes.append(True)
        return {}

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (200.0, cached_response),
            write_cache=lambda _timestamp, _response: None,
            load_credentials=lambda: ("token", "profile"),
            post=post,
        )
        == "12%"
    )
    assert refreshes == []


def test_refreshes_stale_cache_and_writes_successful_response():
    module = load_module()
    response = {
        "usageBreakdownList": [
            {
                "resourceType": "CREDIT",
                "currentUsageWithPrecision": 1193.36,
                "usageLimitWithPrecision": 10000.0,
            }
        ]
    }
    saved_entries = []

    def post(*_args):
        return response

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (1.0, {"usageBreakdownList": []}),
            write_cache=lambda timestamp, saved_response: saved_entries.append(
                (timestamp, saved_response)
            ),
            load_credentials=lambda: ("token", "profile"),
            post=post,
        )
        == "12%"
    )
    assert saved_entries == [(400.0, response)]


def test_returns_stale_cached_usage_when_refresh_fails():
    module = load_module()
    stale_response = {
        "usageBreakdownList": [
            {
                "resourceType": "CREDIT",
                "currentUsageWithPrecision": 1193.36,
                "usageLimitWithPrecision": 10000.0,
            }
        ]
    }

    def post(*_args):
        raise OSError("network failure")

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (1.0, stale_response),
            write_cache=lambda _timestamp, _response: (_ for _ in ()).throw(
                AssertionError("cache write")
            ),
            load_credentials=lambda: ("token", "profile"),
            post=post,
        )
        == "12%"
    )


def test_load_credentials_reads_expected_sqlite_keys(tmp_path):
    module = load_module()
    database_path = tmp_path / "data.sqlite3"
    with sqlite3.connect(database_path) as connection:
        connection.execute("CREATE TABLE auth_kv (key TEXT, value TEXT)")
        connection.execute("CREATE TABLE state (key TEXT, value BLOB)")
        connection.execute(
            "INSERT INTO auth_kv VALUES (?, ?)",
            (
                "kirocli:odic:token",
                json.dumps(
                    {
                        "access_token": "test-token",
                        "expires_at": "2099-01-01T00:00:00Z",
                    }
                ),
            ),
        )
        connection.execute(
            "INSERT INTO state VALUES (?, ?)",
            ("api.codewhisperer.profile", json.dumps({"arn": "test-profile"})),
        )

    assert module.load_credentials(database_path) == ("test-token", "test-profile")


def test_cache_file_round_trip(tmp_path):
    module = load_module()
    cache_path = tmp_path / "kiro-credits.json"
    response = {
        "usageBreakdownList": [
            {
                "resourceType": "CREDIT",
                "currentUsageWithPrecision": 1193.36,
                "usageLimitWithPrecision": 10000.0,
            }
        ]
    }

    module.write_cache(cache_path, 123.0, response)

    assert module.read_cache(cache_path) == (123.0, response)


def test_returns_unavailable_without_cache_when_credentials_are_missing():
    module = load_module()

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: None,
            write_cache=lambda _timestamp, _response: None,
            load_credentials=lambda: (_ for _ in ()).throw(ValueError("missing")),
            post=lambda *_args: (_ for _ in ()).throw(AssertionError("HTTP call")),
        )
        == "Kiro unavailable"
    )


def test_post_json_decodes_response_and_uses_timeout():
    module = load_module()
    captured = {}

    class Response:
        def __enter__(self):
            return self

        def __exit__(self, _exception_type, _exception, _traceback):
            return False

        def read(self):
            return b'{"usageBreakdownList": []}'

    def urlopen(request, timeout):
        captured["request"] = request
        captured["timeout"] = timeout
        return Response()

    assert module.post_json(
        "https://example.test/",
        {"X-Test": "value"},
        '{"request": true}',
        1.5,
        urlopen,
    ) == {"usageBreakdownList": []}
    assert captured["request"].get_method() == "POST"
    assert captured["request"].data == b'{"request": true}'
    assert captured["timeout"] == 1.5


def test_main_prints_clean_unavailable_status_when_data_is_missing(tmp_path):
    module = load_module()
    output = []

    assert (
        module.main(
            database_path=tmp_path / "missing.sqlite3",
            cache_path=tmp_path / "kiro-credits.json",
            clock=lambda: 400.0,
            post=lambda *_args: (_ for _ in ()).throw(AssertionError("HTTP call")),
            print_output=output.append,
        )
        == 0
    )
    assert output == ["Kiro unavailable"]


def test_cache_excludes_unneeded_account_data():
    module = load_module()
    credit = {
        "resourceType": "CREDIT",
        "currentUsageWithPrecision": 1234.0,
        "usageLimitWithPrecision": 10000.0,
    }
    response = {
        "usageBreakdownList": [credit],
        "userInfo": {"email": "user@example.test", "userId": "test-user"},
    }
    saved_entries = []

    module.get_output(
        clock=lambda: 400.0,
        read_cache=lambda: None,
        write_cache=lambda timestamp, saved_response: saved_entries.append(
            (timestamp, saved_response)
        ),
        load_credentials=lambda: ("token", "profile"),
        post=lambda *_args: response,
    )

    assert saved_entries == [(400.0, {"usageBreakdownList": [credit]})]


def test_read_cache_rejects_malformed_credit_response(tmp_path):
    module = load_module()
    cache_path = tmp_path / "kiro-credits.json"
    cache_path.write_text(
        json.dumps(
            {
                "timestamp": 123.0,
                "response": {"usageBreakdownList": []},
            }
        ),
        encoding="utf-8",
    )

    assert module.read_cache(cache_path) is None
