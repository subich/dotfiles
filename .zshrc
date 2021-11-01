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
    zsh-syntax-highlighting
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
function pip_update_all() {
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
}

# Init functions, must be last
eval "$(pyenv init -)"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
