if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    source $HOME/.iterm2_shell_integration.zsh
elif [[ "$TERM_PROGRAM" == "vscode" ]]; then
    source "$(code --locate-shell-integration-path zsh)"
fi
