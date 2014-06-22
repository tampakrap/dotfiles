function hg_prompt_symbol() {
    hg root > /dev/null 2>&1 && echo '☿' && return
}

function hg_prompt_info() {
    (hg prompt --angle-brackets "%{$fg[gray]%}$(hg_prompt_symbol)%{$reset_color%}$PROMPT_PREFIX%{$fg[white]%}<branch>$PROMPT_SUFFIX$PROMPT_PREFIX%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}$PROMPT_SUFFIX<patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied()>") 2>/dev/null
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
function hg_prompt_string() {
    if [[ -d .hg  ]]; then
        hg_prompt="$(hg_prompt_info)"
        local HG_STATE
        local _state
        _state="$(hg_prompt_unknown)"
        [ -n "$_state" ] && HG_STATE+="$PROMPT_UNTRACKED"
        _state="$(hg_prompt_modified)"
        [ -n "$_state" ] && HG_STATE+="$PROMPT_MODIFIED"
        _state="$(hg_prompt_update)"
        [ -n "$_state" ] && HG_STATE+="$PROMPT_STAGED"
        [ -n "$HG_STATE" ] && hg_prompt+="$PROMPT_PREFIX$HG_STATE$PROMPT_SUFFIX"
        echo "$hg_prompt"
    fi
}

RPS1+='$(hg_prompt_string)'
