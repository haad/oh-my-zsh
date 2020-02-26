export AWS_SSM_HOME=~/.config/aws_ssm

function ssm {
  source ${AWS_SSM_HOME}/${1}

  aws ssm start-session --target $INSTANCE_ID
}

function ssm_instances {
  reply=($(ls -1 ${AWS_SSM_HOME}/* | xargs basename -a))
}

compctl -K ssm_instances ssm
