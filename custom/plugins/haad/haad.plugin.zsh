# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
alias chs="cd ~/Devel/chilli"
alias msch="cd ~/Devel/chilli/mschf"
alias pix="cd ~/Devel/chilli/pixel"
alias pixk="cd ~/Devel/chilli/pixel/kube"
alias pixg="cd ~/Devel/chilli/pixel/games"

alias labs="cd ~/Devel/chilli/labs"
alias sof="cd ~/Devel/chilli/softec"

#alias udu="cd ~/Documents/UDU/udu-ansible-setup"
#alias ib="cd ~/Devel/chilli/ib"
#alias fre="cd ~/Devel/chilli/freal-puppet-repo-rework"

alias gu="git-up"
alias gdc="git diff --cached"
alias gck='git cherry-pick'
alias gs='git show'

alias tf="terraform"
alias tfi="terraform init"
alias tfiu="terraform init -upgrade"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfv="terraform validate"

alias tfsls="terraform state list"
alias tfsmv="terraform state mv"

alias ku="kubectl"
alias ke="kubectl exec -it"
alias kgp="kubectl get pods"
alias kgs="kubectl get service"
alias kgd="kubectl get deploy"
alias kgi="kubectl get ingress"
alias kbsh="kubectl run alpine-$RANDOM -it --rm --image=alpine:latest --env 'PS1=\h:\w\\$ ' -- sh -c 'apk --update add busybox-extras openssh-client curl bash bind-tools nano; bash'"
alias kubsh="kubectl run ubuntu-$RANDOM -it --rm --image=ubuntu:latest --env 'PS1=\h:\w\\$ ' -- sh -c 'apt update; apt install --yes busybox curl screen nano telnet dnsutils wget gnupg2; echo defshell -bash > ~/.screenrc; screen'"

alias he="helm"
alias ko="kops"

alias drun="docker run -it --rm "

alias lock="pmset displaysleepnow"

alias mcal="gcal -q SK  -H '\e[34m:\e[0m:\e[32m:\e[0m'"

function krun() {
    kubectl run my-$RANDOM --rm --restart=Never -it --image=${1} --image-pull-policy=Always -- ${2:-bash}
}

function ru() {
  for i in *; do cd $i; echo "===> Updating Git repository at ${i}"; git fetch --all; gu; cd ../; done
}

function devrm() {
  export NS=default
  export OWNER=haad
  export CLUSTER=$(basename ${KUBECONFIG})

  if [ "x$(kubectl -n ${NS} get deploy -l owner=${OWNER} -l service=devel -o name)" != "x" ]; then
    export APP=$(basename $(kubectl -n ${NS} get deploy -l owner=${OWNER} -l service=devel -o name))

    echo "Cleaning deployment ${APP} on kubernetes ${CLUSTER}..."
    kubectl delete deploy/${APP}
  fi
}

function devsh() {
  export NS=default
  export OWNER=haad
  export CLUSTER=$(basename ${KUBECONFIG})

  if [ "x$(kubectl -n ${NS} get deploy -l owner=${OWNER} -l service=devel -o name)" = "x" ]; then
    export APP="haad-devel-env-$RANDOM"

    echo "Creating deployment ${APP} on kubernetes: ${CLUSTER} "

    cat << EOF | kubectl apply -n ${NS} -f -
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        environment: dev
        project: devops
        service: devel
        owner: ${OWNER}
        app: ${APP}
      name: ${APP}
    spec:
      replicas: 1
      selector:
        matchLabels:
          environment: dev
          project: devops
          owner: ${OWNER}
          app: ${APP}
      strategy:
        type: Recreate
      template:
        metadata:
          labels:
            environment: dev
            project: devops
            owner: ${OWNER}
            app: ${APP}
          annotations:
            cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
        spec:
          containers:
            - image: ubuntu:latest
              name: ubuntu
              command: ["/bin/sh"]
              args: ["-c", "apt update; apt install -y busybox curl screen nano telnet dnsutils wget gnupg2 vim git silversearcher-ag ripgrep; echo 'defshell -bash' > ~/.screenrc; screen"]
              env:
                - name: TZ
                  value: "Europe/Bratislava"
                - name: TERM
                  value: "xterm-256color"
                - name: SHELL
                  value: "bash"
                - name: PAGER
                  value: "less"
                - name: EDITOR
                  value: "vim"
              resources: {}
          restartPolicy: Always
EOF
  else
    export APP=$(basename $(kubectl -n ${NS} get deploy -l owner=${OWNER} -l service=devel -o name))
  fi

  echo "Connecting to shell runnning at ${APP} on kubernetes ${CLUSTER}...."
  kubectl exec -it $(kubectl -n ${NS} get pods -l app=${APP} -o name) -- screen -RRd
}



# hab_multihop_tunnel() {

#   if [ $# -lt 3 ]; then
#     echo "Use hab_multihop_tunnel host user destination_port [local_port]"
#     return
#   fi

#   host=$1
#   user=$2
#   dstport=$3
#   lhost="localhost"

#   if [ -z $4 ]; then
#     lport=$[$RANDOM + 1025]
#     chlport=$lport # Use chlport so we do not want to grab some used port on our way to server
#   else
#     lport=$4
#     chlport=$[$RANDOM + 1025]
#   fi

#   echo "Running : ssh -TqaC -L ${lport}:${lhost}:${chlport} haad@hab \"ssh -CqaTN -L ${chlport}:localhost:${dstport} ${user}@${host}\"";
#   reattach-to-user-namespace nohup ssh -TqaC -L ${lport}:${lhost}:${chlport} haad@hab "ssh -CqaTN -L ${chlport}:localhost:${dstport} ${user}@${host}" &
#   procpid=$!
#   echo "Forwarding local port $lhost:$lport to a remote server $host:$dstport"
#   if [ $dstport -eq 443 ]; then
#     url="https"
#   else
#     url="http"
#   fi

#   echo "Connect: $url://$lhost:$lport"
#   echo "Stop: kill -TERM $procpid"
# }

