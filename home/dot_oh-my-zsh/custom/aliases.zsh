# Create an alias only if the program in the alias value exists
# Usage: alias_if <alias_name>=<alias_value>
function alias_if() {
  local cmd="${1#*=}"  # strip everything up to and including the =
  cmd="${cmd%% *}"     # take the first word as the program name
  command -v "$cmd" > /dev/null 2>&1 && alias "$@"
}

# aliases for better versions of some common programs
alias_if ping='prettyping --nolegend'
alias_if lg='lazygit'

# Use bat as pager and cat replacement
# https://github.com/sharkdp/bat
if command -v bat >/dev/null 2>&1; then
  export PAGER="bat"
  export BAT_THEME="Dracula"
  alias cat="bat"
  # alias cat='bat --paging never --decorations never --plain'
fi

# Setup eza, modern alternative to ls
# https://github.com/eza-community/eza
if command -v eza >/dev/null 2>&1; then
  alias \ls='command ls "$@"'
  alias ls='eza --icons "$@"'
  alias ll='eza -lh --icons "$@"'
  alias la='eza -lha --icons "$@"'
  alias l='eza -l --icons "$@"'
  alias lsd='eza -lha --no-permissions --no-user --time-style=relative --icons "$@"'
  alias lt='eza --tree --icons "$@"'
  alias lt1='lt --level=1'
  alias lt2='lt --level=2'
  alias lt3='lt --level=3'
  alias lt4='lt --level=4'
  alias lt5='lt --level=5'
fi

# useful helper functions
function run-this { docker compose run --remove-orphans ${PWD##*/} $@ }

alias test-this="run-this pytest"
alias watch-this="run-this pytest-watcher --now --clear . --"

alias awslocal="aws --endpoint-url 'http://localhost:4566'"
