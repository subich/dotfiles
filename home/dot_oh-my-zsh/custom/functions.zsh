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

function set_aws_profile {
  if [ -z "$1" ]; then
    local profiles
    profiles=$(grep '^\[' ~/.aws/credentials 2>/dev/null | sed 's/^\[\(.*\)\]$/\1/')
    if [ -z "$profiles" ]; then
      echo "No profiles found in ~/.aws/credentials"
      return 1
    fi
    local selected
    selected=$(echo "$profiles" | fzf --prompt="Select AWS profile (ESC to clear): " --height=~10)
    if [ -z "$selected" ]; then
      unset AWS_PROFILE
      unset AWS_DEFAULT_REGION
      echo "AWS profile cleared"
    else
      export AWS_PROFILE="$selected"
      export AWS_DEFAULT_REGION=us-east-1
      echo "AWS profile set to $AWS_PROFILE"
    fi
  else
    export AWS_PROFILE=$1
    export AWS_DEFAULT_REGION=us-east-1
    echo "AWS profile set to $AWS_PROFILE"
  fi
}
