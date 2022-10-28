# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
    extract
    fzf
    git
    timer
    vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration
TIMER_THRESHOLD=15 # display if exec time > this
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

export EDITOR='vim'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

SECRETS=$HOME/.access_tokens
[ -f "$SECRETS" ] && source $SECRETS

# aliases for better versions of some common programs
alias cat='bat'
alias ping='prettyping --nolegend'

# useful helper functions
function pip_update_all {
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
}

function ghpr {
    GH_FORCE_TTY=100% gh pr list \
    | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 3 \
    | awk '{print $1}' \
    | xargs gh pr checkout
}

function fzf-grep-edit {
    if [[ $# == 0 ]]; then
      echo 'Error: search term was not provided.'
      return
    fi
    match=$(
      rg --color=never --line-number "$1" |
        fzf --no-multi --delimiter : \
          --preview "bat --color=always --line-range {2}: {1}"
      )
    file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
    # shellcheck disable=SC2046
      $EDITOR "$file" +$(echo "$match" | cut -d':' -f2)
    fi
}

function build-this { docker compose build $@ }
function run-this { docker compose run ${PWD##*/} $@ }
alias test-this="run-this pytest"
alias watch-this="run-this ptw --"

# Init functions, must be last
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
