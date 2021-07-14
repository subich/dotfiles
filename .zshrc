# Login message
date
echo "------------------------------"
fortune -s

# History options
HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# search commands with up/down arrows based on already entered text
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# CD to a directory if only the directory path is entered
setopt autocd
setopt extendedglob

# set vim bindings for the shell
bindkey -v

# The following lines were added by compinstall

zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' expand prefix
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit -u
# End of lines added by compinstall

# configure the prompt
#export PROMPT='%(?|[%B%F{cyan}%n@%m%b%F{white}:%F{blue}%~%F{white}]%(#.#.$) %f|(%B%F{magenta}%?%f%b%) [%B%F{cyan}%n@%m%b%F{white}:%F{blue}%~%F{white}]%(#.#.$) %f)'
autoload -U promptinit; promptinit
fpath+=$HOME/.zsh/pure
prompt pure

# aliases for ls
alias ls='ls -G'
alias l='ls'
alias ll='ls -lh'
alias la='ls -A'

# aliases for better versions of some common programs
alias cat='bat'
alias ping='prettyping --nolegend'
alias du="ncdu -rr -x"

# alias to `git pull` multiple subdirs at ones
alias pullall='find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;'

# make git log more readable
alias gitlog='git log --graph --oneline --decorate --all'

# I think this is for some git-related tracking in zsh & maybe vim
__git_files () {
    _wanted files expl 'local files' _files
}

# set vim as the default editor
export EDITOR=/usr/local/bin/vim

# initialize `fuck`
eval $(thefuck --alias)
# init pyenv
eval "$(pyenv init -)"

# better syntax highlighting at the prompt -- this must be last in .zshrc
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
