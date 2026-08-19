import importlib.machinery
import importlib.util
import json
import subprocess
from pathlib import Path

import pytest

SCRIPT_PATH = (
    Path(__file__).parent.parent
    / "home"
    / "dot_config"
    / "tmux"
    / "packages"
    / "copilot"
    / "executable_copilot-credits"
)


def load_module():
    loader = importlib.machinery.SourceFileLoader("copilot_credits", str(SCRIPT_PATH))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


def quota_response(percent_remaining=75.9):
    return {
        "quota_snapshots": {
            "premium_interactions": {"percent_remaining": percent_remaining}
        }
    }


def test_formats_credit_usage_for_tmux():
    module = load_module()

    assert module.format_usage(quota_response(20)) == "80%"


@pytest.mark.parametrize(
    ("output", "expected"),
    [
        ("79%", "low"),
        ("80%", "medium"),
        ("99%", "medium"),
        ("100%", "high"),
        ("120%", "high"),
        ("Copilot unavailable", "low"),
    ],
)
def test_selects_status_at_usage_boundaries(output, expected):
    module = load_module()

    assert module._status_for_output(output, lambda _option: None) == expected


def test_formats_package_colors_from_option_values():
    module = load_module()
    options = {
        "@copilot_medium_thresh": "70",
        "@copilot_high_thresh": "90",
        "@copilot_low_fg_color": "low-fg",
        "@copilot_medium_fg_color": "medium-fg",
        "@copilot_high_fg_color": "high-fg",
        "@copilot_low_bg_color": "low-bg",
        "@copilot_medium_bg_color": "medium-bg",
        "@copilot_high_bg_color": "high-bg",
    }

    assert module._format_output("80%", "fg-color", options.get) == "medium-fg"
    assert module._format_output("100%", "bg-color", options.get) == "high-bg"
    assert (
        module._format_output("Copilot unavailable", "fg-color", options.get)
        == "low-fg"
    )


def test_fetch_usage_uses_authenticated_gh_account():
    module = load_module()
    calls = []

    def run(*args, **kwargs):
        calls.append((args, kwargs))
        return subprocess.CompletedProcess(args[0], 0, json.dumps(quota_response()))

    assert module.fetch_usage(run) == quota_response()
    args, kwargs = calls[0]
    assert args == (["gh", "api", "/copilot_internal/user"],)
    assert kwargs == {
        "capture_output": True,
        "check": True,
        "text": True,
        "timeout": 5.0,
    }


def test_returns_fresh_cached_usage_without_refresh():
    module = load_module()
    refreshes = []

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (200.0, {"percent_remaining": 75.9}),
            write_cache=lambda _timestamp, _usage: None,
            fetch_usage=lambda: refreshes.append(quota_response()),
        )
        == "24%"
    )
    assert refreshes == []


def test_refreshes_stale_cache_and_writes_minimal_usage():
    module = load_module()
    saved_entries = []

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (1.0, {"percent_remaining": 50.0}),
            write_cache=lambda timestamp, usage: saved_entries.append(
                (timestamp, usage)
            ),
            fetch_usage=lambda: quota_response(),
        )
        == "24%"
    )
    assert saved_entries == [(400.0, {"percent_remaining": 75.9})]


def test_returns_stale_cached_usage_when_refresh_fails():
    module = load_module()

    assert (
        module.get_output(
            clock=lambda: 400.0,
            read_cache=lambda: (1.0, {"percent_remaining": 75.9}),
            write_cache=lambda _timestamp, _usage: (_ for _ in ()).throw(
                AssertionError("cache write")
            ),
            fetch_usage=lambda: (_ for _ in ()).throw(OSError("network failure")),
        )
        == "24%"
    )


def test_cache_file_round_trip(tmp_path):
    module = load_module()
    cache_path = tmp_path / "copilot-credits.json"
    usage = {"percent_remaining": 75.9}

    module.write_cache(cache_path, 123.0, usage)

    assert module.read_cache(cache_path) == (123.0, usage)


def test_main_prints_clean_unavailable_status_when_usage_is_missing(tmp_path):
    module = load_module()
    output = []

    assert (
        module.main(
            cache_path=tmp_path / "copilot-credits.json",
            clock=lambda: 400.0,
            fetch_usage=lambda: (_ for _ in ()).throw(OSError("network failure")),
            print_output=output.append,
        )
        == 0
    )
    assert output == ["Copilot unavailable"]


def test_rejects_invalid_remaining_quota():
    module = load_module()

    try:
        module.format_usage(quota_response("75.9"))
    except TypeError as error:
        assert str(error) == "Copilot remaining quota is invalid"
    else:
        raise AssertionError("expected invalid quota to be rejected")
