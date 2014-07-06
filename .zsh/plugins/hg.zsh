function hg_rprompt() {
    local PREFIX="%{$fg[green]%}[%{$reset_color%}"
    local SUFFIX="%{$reset_color%}%{$fg[green]%}]%{$reset_color%}"

    if [[ -d .hg ]]; then
        hg prompt --angle-brackets "☿$PREFIX<branch>$SUFFIX$PREFIX%{$fg[yellow]%}<tags|,>$SUFFIX<$PREFIX%{$fg[cyan]%}<bookmark>$SUFFIX>$PREFIX%{$fg_bold[red]%}<status|unknown>%{$reset_color%}%{$fg_bold[yellow]%}<status|modified>%{$reset_color%}%{$fg_bold[green]%}<update>$SUFFIX"
    fi
}

RPS1+='$(hg_rprompt)'
