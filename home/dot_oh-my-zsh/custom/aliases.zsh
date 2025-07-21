# aliases for better versions of some common programs
command -v bat > /dev/null && alias cat='bat --paging never --decorations never --plain'
command -v prettyping > /dev/null && alias ping='prettyping --nolegend'
command -v lazygit > /dev/null && alias lg='lazygit'

# useful helper functions
function run-this { docker compose run --remove-orphans ${PWD##*/} $@ }
alias test-this="run-this pytest"
alias watch-this="run-this pytest-watcher --now --clear . --"

alias awslocal="aws --endpoint-url 'http://localhost:4566'"

function connect_to_workgroup {
  # Connect to a Redshift serverless workgroup.
  # Requires an active AWS session
  workgroup_name=$1

  aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')

  echo "Getting credentials for $workgroup_name in account $aws_account_id..."
  creds=$(aws redshift-serverless get-credentials --workgroup-name $workgroup_name)

  user=$(echo $creds | jq -r '.dbUser')
  echo "Connecting to database as $user..."

  connection_string="postgresql://${workgroup_name}.${aws_account_id}.us-east-1.redshift-serverless.amazonaws.com:5439/dev"
  PGPASSWORD=$(echo $creds | jq -r '.dbPassword') \
  psql $connection_string $user
}

function connect_to_workgroup_admin {
  workgroup_name=$1

  aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')

  echo "Getting admin credentials for $workgroup_name in account $aws_account_id..."
  creds=$(aws secretsmanager get-secret-value --secret-id "redshift!${workgroup_name}-admin" | jq -r '.SecretString')

  user=$(echo $creds | jq -r '.username')
  echo "Connecting to database as $user..."

  connection_string="postgresql://${workgroup_name}.${aws_account_id}.us-east-1.redshift-serverless.amazonaws.com:5439/dev"
  PGPASSWORD=$(echo $creds | jq -r '.password') \
  psql $connection_string $user
}
