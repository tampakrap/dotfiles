if (( $+commands[kubectl] )); then
    __KUBECTL_COMPLETION_FILE="${HOME}/.cache/kubectl_completion"
    if [[ ! -f $__KUBECTL_COMPLETION_FILE ]]; then
        kubectl completion zsh >! $__KUBECTL_COMPLETION_FILE
    fi
    [[ -f $__KUBECTL_COMPLETION_FILE ]] && source $__KUBECTL_COMPLETION_FILE
    unset __KUBECTL_COMPLETION_FILE
fi

alias k="kctl"
alias k8s="kubectl"
alias κυβερνήτης="kubectl"
compdef k="kubectl"
compdef k8s="kubectl"
compdef kctl="kubectl"
compdef κυβερνήτης="kubectl"
