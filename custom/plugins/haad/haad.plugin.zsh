# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
alias chs="cd ~/Desktop/chilli"
alias cra="cd ~/Desktop/chilli/cracz"
alias pix="cd ~/Desktop/chilli/pixel"
alias hub="cd ~/Desktop/chilli/hubhaus"
alias ras="cd ~/Desktop/chilli/ras"

#alias udu="cd ~/Documents/UDU/udu-ansible-setup"
#alias ib="cd ~/Desktop/chilli/ib"
#alias fre="cd ~/Desktop/chilli/freal-puppet-repo-rework"

alias gu="git-up"
alias gdc="git diff --cached"
alias gck='git cherry-pick'
alias gs='git show'

alias vu="vagrant up"
alias vup="vagrant up --no-provision"
alias vp="vagrant provision"
alias vd="vagrant destroy"
alias vst="vagrant status"
alias vs="vagrant ssh"

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
alias kbsh="kubectl run alpine-$RANDOM -it --rm --image=alpine:latest --env 'PS1=\h:\w\\$ ' -- sh -c 'apk --update add busybox-extras openssh-client curl bash; bash'"

function krun() {
    kubectl run my-$RANDOM --rm --restart=Never -it --image=${1} --image-pull-policy=Always -- ${2:-bash}
}

alias he="helm"
alias ko="kops"

alias drun="docker run -it --rm "

alias lock="pmset displaysleepnow"

alias mcal="gcal -q SK  -H '\e[34m:\e[0m:\e[32m:\e[0m'"

hab_multihop_tunnel() {

  if [ $# -lt 3 ]; then
    echo "Use hab_multihop_tunnel host user destination_port [local_port]"
    return
  fi

  host=$1
  user=$2
  dstport=$3
  lhost="localhost"

  if [ -z $4 ]; then
    lport=$[$RANDOM + 1025]
    chlport=$lport # Use chlport so we do not want to grab some used port on our way to server
  else
    lport=$4
    chlport=$[$RANDOM + 1025]
  fi

  echo "Running : ssh -TqaC -L ${lport}:${lhost}:${chlport} haad@hab \"ssh -CqaTN -L ${chlport}:localhost:${dstport} ${user}@${host}\"";
  reattach-to-user-namespace nohup ssh -TqaC -L ${lport}:${lhost}:${chlport} haad@hab "ssh -CqaTN -L ${chlport}:localhost:${dstport} ${user}@${host}" &
  procpid=$!
  echo "Forwarding local port $lhost:$lport to a remote server $host:$dstport"
  if [ $dstport -eq 443 ]; then
    url="https"
  else
    url="http"
  fi

  echo "Connect: $url://$lhost:$lport"
  echo "Stop: kill -TERM $procpid"
}

