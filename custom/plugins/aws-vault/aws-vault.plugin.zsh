function agp() {
  echo $AWS_PROFILE
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    echo AWS profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_EB_PROFILE=$1
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile>"
    return 1
  fi

  echo Insert the credentials when asked.
  asp "$1" || return 1
  aws iam create-access-key
  aws configure --profile "$1"

  echo You can now safely delete the old access key running \`aws iam delete-access-key --access-key-id ID\`
  echo Your current keys are:
  aws iam list-access-keys
}

#
# Open Google chrome authenticated
alias google-chrome-stable='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias firefox-stable='/Applications/Firefox.app/Contents/MacOS/firefox'
function avd() {

  if [[ -z "$1" ]]; then
    unset AWS_VAULT AWS_DEFAULT_REGION AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN AWS_SESSION_EXPIRATION
    echo AWS profile cleared.
    return
  fi

  local TOKEN="$(aws-vault login -s $1)"
  if [[ $TOKEN =~ "signin.aws.amazon.com" ]]; then
    local cache=$(mktemp -d /tmp/google-cache-XXXXXX)
    local data=$(mktemp -d /tmp/google-data-XXXXXX)
    local log=$(mktemp /tmp/google-log-XXXXXX)
    echo "Using cache: $cache data: $data log: $log"

    (google-chrome-stable --no-first-run --new-window --disk-cache-dir=$cache --user-data-dir=$data $TOKEN  && rm -rf $cache $data) 1>&2 2>${log} &
#    firefox-stable --profile=${cache} --safe-mode --private-window ${TOKEN}
  else
    echo $TOKEN
  fi
}

#
# Setup temp access keys with AWS vault
function ave() {
  local duration=1h

  if [[ -z "$1" ]]; then
    unset AWS_VAULT AWS_DEFAULT_REGION AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN AWS_SESSION_EXPIRATION
    echo AWS profile cleared.
    return
  fi

  aws-vault exec -d ${duration} $1 --
}

function aws_profiles() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9_\.-]*\).*/\1/'
}

function _aws_profiles() {
  reply=($(aws_profiles))
}
compctl -K _aws_profiles asp aws_change_access_key ave avd

# AWS prompt
function aws_prompt_info() {
  local aws_prof=${AWS_PROFILE:-$AWS_VAULT}
  [[ -z $aws_prof ]] && return
  echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${aws_prof}${ZSH_THEME_AWS_SUFFIX:=>}"
}

if [ "$SHOW_AWS_PROMPT" != false ]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi

# Load awscli completions

function _awscli-homebrew-installed() {
  # check if Homebrew is installed
  (( $+commands[brew] )) || return 1

  # speculatively check default brew prefix
  if [ -h /usr/local/opt/awscli ]; then
    _brew_prefix=/usr/local/opt/awscli
  else
    # ok, it is not in the default prefix
    # this call to brew is expensive (about 400 ms), so at least let's make it only once
    _brew_prefix=$(brew --prefix awscli)
  fi
}

# get aws_zsh_completer.sh location from $PATH
_aws_zsh_completer_path="$commands[aws_zsh_completer.sh]"

# otherwise check common locations
if [[ -z $_aws_zsh_completer_path ]]; then
  # Homebrew
  if _awscli-homebrew-installed; then
    _aws_zsh_completer_path=$_brew_prefix/libexec/bin/aws_zsh_completer.sh
  # Ubuntu
  elif [[ -e /usr/share/zsh/vendor-completions/_awscli ]]; then
    _aws_zsh_completer_path=/usr/share/zsh/vendor-completions/_awscli
  # RPM
  else
    _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
  fi
fi

[[ -r $_aws_zsh_completer_path ]] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path _brew_prefix
