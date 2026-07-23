# Keep tmux pane titles in sync with commands launched from zsh.
# This remains accurate when terminal integrations place commands on a nested PTY.
if [[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]]; then
    autoload -Uz add-zsh-hook

    _tmux_pane_title_preexec() {
        local -a command_words
        command_words=("${(@z)1}")

        # Skip prefix commands (sudo, command, etc.) and env-var assignments
        local idx=1
        local skip_words=(sudo command builtin noglob nocorrect exec)
        while (( idx <= ${#command_words} )); do
            local word="${command_words[$idx]##*/}"
            if [[ "$word" == *=* ]]; then
                (( idx++ ))
                continue
            fi
            if (( ${skip_words[(Ie)$word]} )); then
                (( idx++ ))
                continue
            fi
            break
        done

        local command_name="${command_words[$idx]##*/}"

        # Resolve aliases to their underlying command
        local max_depth=10
        while (( max_depth-- > 0 )) && [[ -n "${aliases[$command_name]}" ]]; do
            local -a resolved
            resolved=("${(@z)aliases[$command_name]}")
            command_name="${resolved[1]##*/}"
        done

        # Skip anything that isn't an external command (builtins, functions, reserved words)
        if [[ -z "${command_name}" ]] || ! whence -p "${command_name}" &>/dev/null; then
            return
        fi

        tmux select-pane -t "${TMUX_PANE}" -T "${command_name}" 2>/dev/null
    }

    _tmux_pane_title_precmd() {
        tmux select-pane -t "${TMUX_PANE}" -T "${SHELL##*/}" 2>/dev/null
    }

    add-zsh-hook preexec _tmux_pane_title_preexec
    add-zsh-hook precmd _tmux_pane_title_precmd
fi
