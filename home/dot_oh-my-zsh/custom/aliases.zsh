# aliases for better versions of some common programs
command -v bat > /dev/null && alias cat='bat'
command -v prettyping > /dev/null && alias ping='prettyping --nolegend'
command -v lazygit > /dev/null && alias lg='lazygit'

# useful helper functions
function run-this { docker compose run ${PWD##*/} $@ }
alias test-this="run-this pytest"
alias watch-this="run-this ptw -c --"

alias awslocal="aws --endpoint-url 'http://localhost:4566'"

function connect_to_workgroup {
  # Connect to a Redshift serverless workgroup.
  # Requires an active AWS session
  workgroup_name=$1

  aws_account_id=$(aws sts get-caller-identity | jq '.Account' | tr -d '"')

  echo "Getting credentials for $workgroup_name in account $aws_account_id..."
  creds=$(aws redshift-serverless get-credentials --workgroup-name $workgroup_name)

  user=$(echo $creds | jq '.dbUser' | tr -d '"')
  echo "Connecting to database as $user..."

  PGPASSWORD=$(echo $creds | jq '.dbPassword' | tr -d '"') \
  psql postgresql://$workgroup_name.$aws_account_id.us-east-1.redshift-serverless.amazonaws.com:5439/dev $user
}
