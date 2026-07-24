# Request focus events so zsh's line editor absorbs them instead of printing
# raw escape sequences when switching tmux windows.
if [[ -n "${TMUX:-}" ]]; then
    printf '\e[?1004h'
    # ZLE handles \e[I and \e[O as no-ops when focus reporting is active in
    # modern zsh (5.9+). For older versions, bind them explicitly:
    function _zle_focus_in  { }
    function _zle_focus_out { }
    zle -N _zle_focus_in
    zle -N _zle_focus_out
    bindkey '\e[I' _zle_focus_in
    bindkey '\e[O' _zle_focus_out
fi
