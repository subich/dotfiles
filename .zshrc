# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

CASE_SENSITIVE="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"
HYPHEN_INSENSITIVE="true"
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="robbyrussell"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
    asdf
    aws
    docker
    docker-compose
    extract
    fzf
    gh
    git
    gitignore
    iterm2
    jira
    thefuck
    timer
    tmux
    vi-mode
    zoxide
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'

# OMZ plugin settings
TIMER_THRESHOLD=15 # display if exec time > this
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
source $HOME/.access_tokens

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
