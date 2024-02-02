# Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%M%f' # no SSH
fi


local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
local current_dir="%B%F{blue}%5~%f%b"
local git_branch='$(git_prompt_info)'
local aws_info='$(aws_prompt_info)'
local kcfg_info='$(kcfg_prompt_info)'
local cfvault_info='$(cfvault_prompt_info)'


PROMPT="╭─${user_host} ${current_dir} ${aws_info} ${kcfg_info} ${cfvault_info} ${git_branch}

╰─$PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

ZSH_THEME_AWS_PREFIX="%F{red}‹"
ZSH_THEME_AWS_SUFFIX="›%f"

ZSH_THEME_KCFG_PREFIX="%{$fg[blue]%}‹"
ZSH_THEME_KCFG_SUFFIX="›%f"

ZSH_THEME_CFVAULT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_CFVAULT_SUFFIX="›%f"

}
