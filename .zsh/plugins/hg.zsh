function hg_prompt_info() {
    (hg prompt --angle-brackets "☿%{$fg[green]%}[%{$reset_color%}<branch>%{$fg[green]%}][%{$reset_color%}%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}%{$fg[green]%}]%{$reset_color%}<patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied()>") 2>/dev/null
}

function hg_prompt_modified() {
    (hg prompt --angle-brackets "<status|modified>") 2>/dev/null
}

function hg_prompt_unknown() {
    (hg prompt --angle-brackets "<status|unknown>") 2>/dev/null
}

function hg_prompt_update() {
    (hg prompt --angle-brackets "<update>") 2>/dev/null
}

# If inside a Mercurial repository, print its branch, tag, state and patches
function hg_rprompt() {
    if [[ -d .hg  ]]; then
        hg_prompt="$(hg_prompt_info)"
        local HG_STATE
        local _state
        _state="$(hg_prompt_unknown)"
        [ -n "$_state" ] && HG_STATE+="%{$fg_bold[red]%}●%{$reset_color%}"
        _state="$(hg_prompt_modified)"
        [ -n "$_state" ] && HG_STATE+="%{$fg_bold[yellow]%}●%{$reset_color%}"
        _state="$(hg_prompt_update)"
        [ -n "$_state" ] && HG_STATE+="%{$fg_bold[green]%}●%{$reset_color%}"
        [ -n "$HG_STATE" ] && hg_prompt+="%{$fg[green]%}[%{$reset_color%}$HG_STATE%{$fg[green]%}]%{$reset_color%}"
        echo "$hg_prompt"
    fi
}

RPS1+='$(hg_rprompt)'
