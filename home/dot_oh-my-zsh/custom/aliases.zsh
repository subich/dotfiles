# Create an alias only if the program in the alias value exists
# Usage: alias_if <alias_name>=<alias_value>
function alias_if() {
  local cmd="${1#*=}"  # strip everything up to and including the =
  cmd="${cmd%% *}"     # take the first word as the program name
  command -v "$cmd" > /dev/null 2>&1 && alias "$@"
}

alias_if cat='bat' && export BAT_THEME="Dracula"
alias_if lg='lazygit'
alias_if ping='prettyping --nolegend'

unset -f alias_if

# Setup eza, modern alternative to ls
# https://github.com/eza-community/eza
if command -v eza >/dev/null 2>&1; then
  alias \ls='command ls'
  alias ls='eza --icons auto'
  alias ll='eza -lh --icons auto'
  alias la='eza -lha --icons auto'
  alias l='eza -l --icons auto'
  alias lsd='eza -lha --no-permissions --no-user --time-style=relative --icons auto'
  alias lt='eza --tree --icons auto'
  alias lt1='lt --level=1'
  alias lt2='lt --level=2'
  alias lt3='lt --level=3'
  alias lt4='lt --level=4'
  alias lt5='lt --level=5'
fi

function run-this { docker compose run --remove-orphans "${PWD##*/}" "$@" }
alias test-this="run-this pytest"
alias watch-this="run-this pytest-watcher --now --clear . --"

alias awslocal="aws --endpoint-url 'http://localhost:4566'"

alias kiro-resume="kiro-cli chat --resume"
alias kiro-resume-picker="kiro-cli chat --resume-picker"

alias resolve-conflicts="kiro-cli --v3 chat --agent git-conflict-resolver 'Resolve the current git conflicts'"
