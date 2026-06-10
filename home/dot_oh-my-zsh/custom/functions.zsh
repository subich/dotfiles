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

function connect-to-workgroup {
  # Connect to a Redshift serverless workgroup.
  # Requires an active AWS session
  local workgroup_name=$1
  echo "Getting credentials for $workgroup_name..."
  local creds=$(aws redshift-serverless get-credentials --workgroup-name $workgroup_name)

  _connect_to_redshift $workgroup_name $(echo $creds | jq -r '.dbUser') $(echo $creds | jq -r '.dbPassword')
}

function connect-to-workgroup-admin {
  local workgroup_name=$1
  echo "Getting admin credentials for $workgroup_name..."
  local creds=$(aws secretsmanager get-secret-value --secret-id "redshift!${workgroup_name}-admin" | jq -r '.SecretString')

  _connect_to_redshift $workgroup_name $(echo $creds | jq -r '.username') $(echo $creds | jq -r '.password')
}

function set-aws-profile {
  local selected="$1"

  if [ -z "$selected" ]; then
    local profiles
    profiles=$({
      grep '^\[' ~/.aws/credentials 2>/dev/null | sed 's/^\[\(.*\)\]$/\1/';
      grep '^\[profile' ~/.aws/config 2>/dev/null | sed 's/^\[profile \(.*\)\]$/\1/';
    } | sort -u)
    if [ -z "$profiles" ]; then
      echo "No profiles found in ~/.aws/credentials or ~/.aws/config"
      return 1
    fi
    selected=$(echo "$profiles" | fzf --prompt="Select AWS profile (ESC to clear): " --height=~10)
  fi

  if [ -z "$selected" ]; then
    unset AWS_PROFILE AWS_DEFAULT_REGION
    echo "AWS profile cleared"
  else
    export AWS_PROFILE="$selected"
    export AWS_DEFAULT_REGION=us-east-1
    echo "AWS profile set to $AWS_PROFILE"
  fi
}

function connect-rds {
  local instance_name=$1

  if [ -z "$instance_name" ]; then
    instance_name=$(
      aws rds describe-db-instances \
        --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]' \
        --output text \
      | awk '{if ($2 != "available") print $1 " (" $2 ")"; else print $1}' \
      | fzf --prompt="Select RDS instance: " --height=~10 \
      | awk '{print $1}'
    )
    if [ -z "$instance_name" ]; then
      echo "No instance selected"
      return 1
    fi
  fi

  local instance_info=$(aws rds describe-db-instances --db-instance-identifier "$instance_name" --query 'DBInstances[0]' --output json)
  local engine=$(echo $instance_info | jq -r '.Engine')
  local host=$(echo $instance_info | jq -r '.Endpoint.Address')
  local port=$(echo $instance_info | jq -r '.Endpoint.Port')
  local secret_arn=$(echo $instance_info | jq -r '.MasterUserSecret.SecretArn')

  echo "Getting credentials from Secrets Manager..."
  local secret=$(aws secretsmanager get-secret-value --secret-id "$secret_arn" | jq -r '.SecretString')
  local user=$(echo $secret | jq -r '.username')
  local password=$(echo $secret | jq -r '.password')

  echo "Connecting to $instance_name ($engine) as $user..."
  case $engine in
    postgres)
      PGPASSWORD=$password pgcli -h $host -p $port -U $user postgres
      ;;
    sqlserver-*)
      sqlcmd -S $host,$port -U $user -P $password -d master
      ;;
    *)
      echo "Unsupported engine: $engine"
      return 1
      ;;
  esac
}
