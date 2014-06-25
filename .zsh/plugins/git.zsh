# http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# Adapted from code found at <https://gist.github.com/1712320>.

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (/usr/bin/git symbolic-ref -q HEAD || /usr/bin/git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
    local GIT="/usr/bin/git"

    # Modify the colors and symbols in these variables as desired.
    local GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
    local GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
    local GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
    local GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
    local GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
    local GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
    local GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
    local GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$($GIT log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$($GIT log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    local GIT_DIR="$($GIT rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi

    if [[ -n $($GIT ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi

    if ! $GIT diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi

    if ! $GIT diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

git_rprompt() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "±%{$fg[green]%}[%{$reset_color%}%{$fg[white]%}${git_where#(refs/heads/|tags/)}%{$fg[green]%}]%{$reset_color%}$(parse_git_state)"
}

RPS1+='$(git_rprompt)'
