export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export COLORTERM=yes
export CC=gcc
export PAGER=/usr/bin/less
export EDITOR=/usr/bin/vim
export LESS=-R
export CLICOLOR=1
export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export HOSTNAME=$(hostname -s)
export GOPATH=$HOME/.go
export REPOS=$HOME/Repos
export REPOS_GH=$REPOS/github.com
export PATH="/opt/homebrew/bin:$PATH"
export BREW=$(brew --prefix)
export PATH="$HOME/.local/bin:$BREW/opt/python/libexec/bin:$BREW/opt/go/bin:$GOPATH/bin:$REPOS_GH/tampakrap/bin:$PATH"
export WORDCHARS=$(echo $WORDCHARS | tr -d "_-.=/")
export FPATH="$HOME/.zsh/site-functions:$FPATH"

alias ls='ls -Gh'
alias lsd="ls -ldG *(-/DN)"
alias dir='ls -l'
alias ll='ls -l'
alias la='ls -la'
alias l='ls -alF'
alias ls-l='ls -l'
alias o='less'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias rd=rmdir
alias md='mkdir -p'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias caff='caff -m yes'
alias diff='diff --color=always'
alias facepalm="cat ~/.zsh/facepalm"
alias :q="facepalm"
alias :wq="facepalm"
alias todo="edit ~/Documents/todo"

if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi
if type -p colormake &> /dev/null ; then alias make="colormake" ; fi
if type -p colorgcc &> /dev/null ; then
    alias gcc="colorgcc"
    alias g++="colorgcc"
    alias cc="colorgcc"
    alias c++="colorgcc"
fi

autoload -U colors; colors
autoload -U compinit; compinit -u
autoload -U promptinit; promptinit

bindkey -e

# History completion on pgup and pgdown
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[5~" history-beginning-search-backward-end
bindkey "^[[6~" history-beginning-search-forward-end

## Home and End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

setopt extendedglob
setopt prompt_subst
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

SAVEHIST=3000
HISTSIZE=3000
HISTFILE=${HOME}/.zsh_history

zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

function cdl() {
    cd $*
    ll
}

function grt() {
    local UPPER_PATH=""
    while [ ! -d "${UPPER_PATH}.git" ]; do
        UPPER_PATH+="../"
        [ `realpath $PWD/$UPPER_PATH` = "/" ] && UPPER_PATH="" && echo "WARNING: No Git repo found" && break
    done
    [ -z $UPPER_PATH ] || cd $UPPER_PATH
}

function grtm() {
    grt
    git swm
}

function ghc() {
    local ORG=${1%/*}
    [[ -d $REPOS_GH/$ORG ]] || mkdir $REPOS_GH/$ORG
    hub clone $1 $REPOS_GH/$1
    cd $REPOS_GH/$1
}

function load_plugins() {
    local plugin
    local plugin_path="${HOME}/.zsh/plugins"
    for plugin in $@; do
        if [[ -f $plugin_path/$plugin.zsh ]]; then
            source $plugin_path/$plugin.zsh
        else
            echo "ERROR: ZSH plugin $plugin not found"
        fi
    done
}

stty discard undef

PLUGINS_GLOBAL=(
    autosuggestions
    starship
    syntax-highlighting
    terminals
    tetris
)

PLUGINS_USER=(
    greek_shell_aliases
    gpg
    hub
    jump
    kubectl
    terraform
)

PLUGINS_PERSONAL=(
    op
)

PLUGINS_WORK=(
    direnv
    gcloud
    work
)

load_plugins ${PLUGINS_GLOBAL[@]}

if [[ $UID != 0 ]]; then
    load_plugins ${PLUGINS_USER[@]}

    if [[ $HOSTNAME == 'prhyme' ]]; then
        load_plugins ${PLUGINS_WORK[@]}
    else
        load_plugins ${PLUGINS_PERSONAL[@]}
    fi
fi
