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
export GOPATH=${HOME}/.go
export PATH="/usr/local/opt/python@3.11/libexec/bin:$PATH"
export WORDCHARS=$(echo $WORDCHARS | tr -d "/=-")

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
alias pass-uplus="PASSWORD_STORE_DIR=~/.password-store-uplus pass"

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

setopt completealiases
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
    while [ ! -d ".git" ]; do
        cd ..
    done
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
    hub
    iterm2
    starship
    syntax-highlighting
    tetris
)

PLUGINS_USER=(
    greek_shell_aliases
    gpg
    jump
    op
)

PLUGINS_WORK=(
    jobandtalent
    kubectl
)

load_plugins ${PLUGINS_GLOBAL[@]}

if [[ $UID != 0 ]]; then
    load_plugins ${PLUGINS_USER[@]}

    if [[ $HOSTNAME == 'madvillain' ]]; then
        load_plugins ${PLUGINS_WORK[@]}
    fi
fi
