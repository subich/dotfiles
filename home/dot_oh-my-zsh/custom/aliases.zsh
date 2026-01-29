# aliases for better versions of some common programs
command -v prettyping > /dev/null && alias ping='prettyping --nolegend'
command -v lazygit > /dev/null && alias lg='lazygit'

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

# Kill everything running on a specific port
function killport() {
  kill $(lsof -iTCP -sTCP:LISTEN -n -P | grep $1 | awk '{print $2}')
}

function _connect_to_redshift {
  local workgroup_name=$1
  local user=$2
  local password=$3
  local aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')

  echo "Connecting to database as $user..."
  local connection_string="postgresql://${workgroup_name}.${aws_account_id}.us-east-1.redshift-serverless.amazonaws.com:5439/dev"
  PGPASSWORD=$password psql $connection_string $user
}

function connect_to_workgroup {
  # Connect to a Redshift serverless workgroup.
  # Requires an active AWS session
  local workgroup_name=$1
  echo "Getting credentials for $workgroup_name..."
  local creds=$(aws redshift-serverless get-credentials --workgroup-name $workgroup_name)

  _connect_to_redshift $workgroup_name $(echo $creds | jq -r '.dbUser') $(echo $creds | jq -r '.dbPassword')
}

function connect_to_workgroup_admin {
  local workgroup_name=$1
  echo "Getting admin credentials for $workgroup_name..."
  local creds=$(aws secretsmanager get-secret-value --secret-id "redshift!${workgroup_name}-admin" | jq -r '.SecretString')

  _connect_to_redshift $workgroup_name $(echo $creds | jq -r '.username') $(echo $creds | jq -r '.password')
}
