#eval "$(op completion zsh)"; compdef _op op

__OP_COMPLETION_FILE="${HOME}/.cache/op_completion"
if [[ -f $__OP_COMPLETION_FILE ]]; then
    source $__OP_COMPLETION_FILE
else
    op completion zsh >! $__OP_COMPLETION_FILE
fi
unset __OP_COMPLETION_FILE

compdef _op op
