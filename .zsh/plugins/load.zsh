for plugin in ${PLUGINS[@]}; do
    local plugin_path="${HOME}/.zsh/plugins"
    [ -f $plugin_path/$plugin.zsh ] && source $plugin_path/$plugin.zsh
done
