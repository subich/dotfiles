# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/stefan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export PROMPT='%(?|[%B%F{green}%n@%m%b%F{white}:%F{blue}%~%F{white}]%(#.#.$) %f|(%B%F{magenta}%?%f%b%) [%B%F{green}%n@%m%b%F{white}:%F{blue}%~%F{white}]%(#.#.$) %f)'
export EDITOR=/usr/bin/vim

alias ls='ls -G'
alias l='ls'
alias ll='ls -l'
alias la='ls -A'

alias cat='bat'
alias ping='prettyping --nolegend'
alias du="ncdu -rr -x"

alias gitlog='git log --graph --oneline --decorate --all'

source ~/.gitkey
__git_files () { 
    _wanted files expl 'local files' _files 
}
