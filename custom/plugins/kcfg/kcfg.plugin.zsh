export KUBE_HOME=~/.kube

function lcfg {
  echo $KUBECONFIG | xargs basename -s .cfg
}

function kcfg {
  if [[ -z "$1" ]]; then
    unset KUBECONFIG
    echo KUBECONFIG settings cleared.
    return
  fi

  #local rprompt=${RPROMPT/<k8s:$(lcfg)>/}

  export KUBECONFIG=$KUBE_HOME/${1}.cfg
}

function kcfg_prompt_info() {
  [[ -z $KUBECONFIG ]] && return
  echo "${ZSH_THEME_KCFG_PREFIX:=<}$(lcfg)${ZSH_THEME_KCFG_SUFFIX:=>}"
}

function k8s_configs {
  reply=($(ls -1 ${KUBE_HOME}/*.cfg | xargs basename -s .cfg))
}

compctl -K k8s_configs kcfg
