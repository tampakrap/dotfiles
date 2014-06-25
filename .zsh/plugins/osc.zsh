osc_prompt_info() {
    if [[ -d .osc ]]; then
        local OSC_PRJ=$(cat .osc/_project)
        [[ -f .osc/_package ]] && local OSC_PKG="/$(cat .osc/_package)"
        echo "ƃ%{$fg[green]%}[%{$fg[white]%}$OSC_PRJ$OSC_PKG%{$fg[green]%}]%{$reset_color%}"
    fi
}

RPS1+='$(osc_prompt_info)'
