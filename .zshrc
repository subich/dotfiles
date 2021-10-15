# Path to oh-my-zsh installation
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
    command-not-found
    extract
    fzf
    git
    timer
    vi-mode
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
# vi-like keybinds
bindkey -v

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# display run time for any process over threshold
TIMER_THRESHOLD=15

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# aliases for better versions of some common programs
alias cat='bat'
alias ping='prettyping --nolegend'
alias du="ncdu -rr -x"

# init pyenv
eval "$(pyenv init -)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
