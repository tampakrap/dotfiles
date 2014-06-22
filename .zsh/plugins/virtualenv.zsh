virtualenv_prompt_info() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "ƿ%{$fg[yellow]%}[%{$fg[white]%}$(basename $VIRTUAL_ENV)%{$fg[yellow]%}]%{$reset_color%}"
    fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

RPS1+='$(virtualenv_prompt_info)'
