export KUBE_HOME=~/.kube

function lcfg {
  echo $KUBECONFIG | xargs basename -s .cfg
}

function kcfg {
  local rprompt=${RPROMPT/<k8s:$(lcfg)>/}

  export KUBECONFIG=$KUBE_HOME/${1}.cfg

#  export RPROMPT="<k8s:$1>$rprompt"
#
#  export RPROMPT="$RPROMPT <k8s:$1>"
}

function kcfg_prompt_info() {
  [[ -z $KUBECONFIG ]] && return
  echo "${ZSH_THEME_KCFG_PREFIX:=<}$(lcfg)${ZSH_THEME_KCFG_SUFFIX:=>}"
}

function k8s_configs {
  reply=($(ls -1 ${KUBE_HOME}/*.cfg | xargs basename -s .cfg))
}

compctl -K k8s_configs kcfg
