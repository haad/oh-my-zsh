export CLOUDFLARE_HOME=~/.config/cloudflare

function lcfcdn {
  echo $CLOUDFLARECONFIG | xargs basename -a
}

function cfcdn {
  #local rprompt=${RPROMPT/<cfcdn:$(lcfg)>/}

  if [[ -z "$1" ]]; then
    unset CLOUDFLARE_API_TOKEN
    unset CLOUDFLARE_EMAIL
    unset CLOUDFLARE_HOME
    unset CLOUDFLARECONFIG
  fi

  export CLOUDFLARECONFIG=$CLOUDFLARE_HOME/${1}
  source ${CLOUDFLARE_HOME}/${1}
#  export CLOUDFLARECONFIG=$CLOUDFLARE_HOME/${1}.cfg
#  export RPROMPT="<k8s:$1>$rprompt"
#
#  export RPROMPT="$RPROMPT <k8s:$1>"
}

function cf_configs {
  reply=($(ls -1 ${CLOUDFLARE_HOME}/* | xargs basename -a))
}

compctl -K cf_configs cfcdn
