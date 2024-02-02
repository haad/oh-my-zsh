export VAULT_HOME=~/.config/vault

function lcfvault {
  echo $VAULTCONFIG | xargs basename -a
}

function cfvault {
  #local rprompt=${RPROMPT/<cfvault:$(lcfg)>/}
  if [[ -z "$1" ]]; then
    unset VAULT_TOKEN
    unset VAULT_ADDR
    unset VAULT_HOME
    unset VAULTCONFIG
  fi

  export VAULTCONFIG=$VAULT_HOME/${1}
  source ${VAULT_HOME}/${1}
}

function cfvault_prompt_info() {

  [[ -z $VAULTCONFIG ]] && return
  echo "${ZSH_THEME_CFVAULT_PREFIX:=<}$(lcfvault)${ZSH_THEME_CFVAULT_SUFFIX:=>}"
}

function vault_configs {
  export VAULT_HOME=${VAULT_HOME:="${HOME}/.config/vault"}

#  export VAULTCONFIG=$VAULT_HOME/${1}.cfg
#  export RPROMPT="<k8s:$1>$rprompt"
#
#  export RPROMPT="$RPROMPT <k8s:$1>"
}

function vault_configs {
  reply=($(ls -1 ${VAULT_HOME}/* | xargs basename -a))
}

compctl -K vault_configs cfvault
