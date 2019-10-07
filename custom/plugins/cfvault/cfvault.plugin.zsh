export VAULT_HOME=~/.config/vault

function lcfvault {
  echo $VAULTCONFIG | xargs basename -a
}

function cfvault {
  #local rprompt=${RPROMPT/<cfvault:$(lcfg)>/}

  export VAULTCONFIG=$VAULT_HOME/${1}
  source ${VAULT_HOME}/${1}
#  export VAULTCONFIG=$VAULT_HOME/${1}.cfg
#  export RPROMPT="<k8s:$1>$rprompt"
#
#  export RPROMPT="$RPROMPT <k8s:$1>"
}

function vault_configs {
  reply=($(ls -1 ${VAULT_HOME}/* | xargs basename -a))
}

compctl -K vault_configs cfvault
