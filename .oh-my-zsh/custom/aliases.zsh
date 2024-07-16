# aliases for better versions of some common programs
alias cat='bat'
alias ping='prettyping --nolegend'
alias lg='lazygit'

# useful helper functions
function build-this { docker compose build $@ }
function run-this { docker compose run ${PWD##*/} $@ }
alias test-this="run-this pytest"
alias watch-this="run-this ptw -c --"

alias awslocal="aws --endpoint-url 'http://localhost:4566'"

function ghprco {
    GH_FORCE_TTY=100% gh pr list \
    | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 4 \
    | awk '{print $1}' \
    | xargs gh pr checkout
}

function fzf-grep-edit {
    if [[ $# == 0 ]]; then
      echo 'Error: search term was not provided.'
      return
    fi
    match=$(
      rg --color=never --line-number "$1" |
        fzf --no-multi --delimiter : \
          --preview "bat --color=always --line-range {2}: {1}"
      )
    file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
    # shellcheck disable=SC2046
      $EDITOR "$file" +$(echo "$match" | cut -d':' -f2)
    fi
}

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
