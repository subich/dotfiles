# Request focus events so zsh's line editor absorbs them instead of printing
# raw escape sequences when switching tmux windows/panes.
if [[ -n "${TMUX:-}" ]]; then
    printf '\e[?1004h'

    function _zle_focus_in {
        # Re-enable focus reporting in case something cleared it
        printf '\e[?1004h'
        zle reset-prompt
    }
    function _zle_focus_out { : }
    zle -N _zle_focus_in
    zle -N _zle_focus_out

    # Bind in all keymaps so vi-mode switches don't leave focus escapes unhandled
    for keymap in emacs viins vicmd visual isearch; do
        bindkey -M "$keymap" '\e[I' _zle_focus_in
        bindkey -M "$keymap" '\e[O' _zle_focus_out
    done
    unset keymap
fi
