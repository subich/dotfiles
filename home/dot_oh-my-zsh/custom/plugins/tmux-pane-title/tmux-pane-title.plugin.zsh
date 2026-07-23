# Keep tmux pane titles in sync with commands launched from zsh.
# This remains accurate when terminal integrations place commands on a nested PTY.
if [[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]]; then
    autoload -Uz add-zsh-hook

    _tmux_pane_title_preexec() {
        local -a command_words
        command_words=("${(@z)1}")
        local command_name="${command_words[1]##*/}"
        [[ -n "${command_name}" ]] && tmux select-pane -t "${TMUX_PANE}" -T "${command_name}" 2>/dev/null
    }

    _tmux_pane_title_precmd() {
        tmux select-pane -t "${TMUX_PANE}" -T "${SHELL##*/}" 2>/dev/null
    }

    add-zsh-hook preexec _tmux_pane_title_preexec
    add-zsh-hook precmd _tmux_pane_title_precmd
fi
