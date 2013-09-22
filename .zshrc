export COLORTERM=yes
export CC=gcc
export PAGER=/usr/bin/less
export EDITOR=/usr/bin/vim

if [ $UID -ne 0 ]; then
    export ECHANGELOG_USER="Theo Chatzimichos <tampakrap@gentoo.org>"
    eval `keychain --quiet --eval --agents ssh id_dsa`
fi

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"

alias ls="ls --color=auto -h"
alias grep="grep --color=auto"
alias isc='osc -A https://api.suse.de/'
alias caff='caff -m yes'

if type -p colorcvs &> /dev/null ; then alias cvs="colorcvs" ; fi
if type -p colordiff &> /dev/null ; then alias diff="colordiff" ; fi
if type -p colorgcc &> /dev/null ; then alias gcc="colorgcc" ; fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi

autoload -U colors; colors
autoload -U compinit; compinit
autoload -U promptinit; promptinit

prompt gentoo

setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
HISTFILE=${HOME}/.zsh_history
SAVEHIST=1000
HISTSIZE=1600

bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line
bindkey "\e[2~" overwrite-mode
bindkey "\e[3~" delete-char

zstyle ':completion:*' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# Adapted from code found at <https://gist.github.com/1712320>.

setopt prompt_subst

prompt_symbol() {
    git branch > /dev/null 2>&1 && echo '±' && return
    hg root > /dev/null 2>&1 && echo '☿' && return
}

# Modify the colors and symbols in these variables as desired.
PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
PROMPT_MERGING="%{$fg_bold[magenta]%}&%{$reset_color%}"
PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$PROMPT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$PROMPT_UNTRACKED
    fi

    if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$PROMPT_PREFIX$GIT_STATE$PROMPT_SUFFIX"
    fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "%{$fg[gray]%}$(prompt_symbol)%{$reset_color%}$PROMPT_PREFIX%{$fg[white]%}${git_where#(refs/heads/|tags/)}$PROMPT_SUFFIX$(parse_git_state)"
}

# Show Mercurial branch
parse_hg_branch() {
    (hg prompt "{branch}") 2> /dev/null
}

hg_prompt_info() {
    (hg prompt --angle-brackets "%{$fg[gray]%}$(prompt_symbol)%{$reset_color%}$PROMPT_PREFIX%{$fg[white]%}<branch>$PROMPT_SUFFIX\
$PROMPT_PREFIX%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}$PROMPT_SUFFIX") 2>/dev/null
}

hg_prompt_modified() {
    (hg prompt --angle-brackets "<status|modified>") 2>/dev/null
}

hg_prompt_unknown() {
    (hg prompt --angle-brackets "<status|unknown>") 2>/dev/null
}

hg_prompt_update() {
    (hg prompt --angle-brackets "<update>") 2>/dev/null
}

hg_prompt_patches() {
    (hg prompt --angle-brackets "<patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied()>") 2>/dev/null
}

# If inside a Mercurial repository, print its branch, tag, state and patches
hg_prompt_string() {
    local hg_where="$(parse_hg_branch)"
    if [[ -n "$hg_where" ]]; then
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
        local hg_patches="$(hg_prompt_patches)"
        [ -n "$hg_patches" ] && hg_prompt+="$PROMPT_PREFIX$hg_patches$PROMPT_SUFFIX"
    fi
    echo "$hg_prompt"
}

# Set the right-hand prompt
RPS1='$(git_prompt_string)$(hg_prompt_string)'
