# Absorb tmux focus-event escape sequences (\e[I / \e[O) so they never print
# as raw characters. tmux injects these when focus-events is on and a pane
# gains/loses focus, but they only reach ZLE while the line editor is active.
# To cover the gap (command execution, prompt drawing), we also drain any
# pending focus bytes in precmd before the next prompt is drawn.
if [[ -n "${TMUX:-}" ]]; then
    # Request focus reporting once so tmux sends us the sequences.
    printf '\e[?1004h'

    # --- ZLE handlers (active while at the prompt) ---
    function _zle_focus_in {
        zle reset-prompt
    }
    function _zle_focus_out { : }
    zle -N _zle_focus_in
    zle -N _zle_focus_out

    # Bind in all keymaps so vi-mode switches don't leave focus escapes unhandled.
    for keymap in emacs viins vicmd visual isearch; do
        bindkey -M "$keymap" '\e[I' _zle_focus_in
        bindkey -M "$keymap" '\e[O' _zle_focus_out
    done
    unset keymap

    # --- preexec: disable focus reporting for noisy commands ---
    # Commands that produce heavy output (like brew) don't consume focus
    # sequences, so they print as raw escapes. Disable reporting only for
    # those commands; everything else keeps it enabled so ZLE stays responsive
    # if focus changes arrive between quick commands.
    typeset -ga _focus_events_suppress_cmds=(brew)

    function _focus_events_preexec {
        local cmd="${${(z)1}[1]}"
        # Strip path and resolve through aliases/builtins
        cmd="${cmd##*/}"
        if (( ${_focus_events_suppress_cmds[(Ie)$cmd]} )); then
            printf '\e[?1004l'
        fi
    }

    # --- precmd: re-enable focus reporting and drain any stale sequences ---
    function _focus_events_precmd {
        # Drain any focus sequences that snuck in during the brief window
        # between command exit and this hook firing.
        local byte
        while IFS= read -rs -k 1 -t 0 byte 2>/dev/null; do
            if [[ "$byte" == $'\e' ]]; then
                local seq
                IFS= read -rs -k 2 -t 0 seq 2>/dev/null || true
            fi
        done
        # Re-enable focus reporting now that ZLE is about to take over.
        printf '\e[?1004h'
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _focus_events_preexec
    add-zsh-hook precmd _focus_events_precmd
fi
