export COLORTERM=yes
export CC=gcc
export PAGER=/usr/bin/less
export EDITOR=/usr/bin/vim

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"

alias ls="ls --color=auto -h"
alias lsd="ls -ldG *(-/DN)"
alias grep="grep --color=auto"
alias isc='osc -A https://api.suse.de/'
alias caff='caff -m yes'
alias git="hub"
alias facepalm="cat ~/.zsh/facepalm"
alias :q="facepalm"
alias :wq="facepalm"
alias weechat="WEECHAT_PASSPHRASE=\$(pass tampakrap.gr/rakim/weechat) weechat"
alias todo="edit ~/Documents/todo"

if type -p colorcvs &> /dev/null ; then alias cvs="colorcvs" ; fi
if type -p colorsvn &> /dev/null ; then alias svn="colorsvn" ; fi
if type -p colordiff &> /dev/null ; then alias diff="colordiff" ; fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi
if type -p colormake &> /dev/null ; then alias make="colormake" ; fi
if type -p colorgcc &> /dev/null ; then
    alias gcc="colorgcc"
    alias g++="colorgcc"
    alias cc="colorgcc"
    alias c++="colorgcc"
fi

fpath=($HOME/.zsh/functions/Prompts $fpath)

autoload -U colors; colors
autoload -U compinit; compinit
autoload -U promptinit; promptinit

prompt gentoo

setopt completealiases
setopt prompt_subst
setopt extendedglob
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
HISTFILE=${HOME}/.zsh_history
SAVEHIST=1000
HISTSIZE=1600

zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

autoload -U tetris
zle -N tetris
bindkey "^X^T" tetris

function cdl () {
    cd $*
    ll
}

function grt () {
    while [ ! -d ".git" ]; do
        cd ..
    done
}

if [[ $UID != 0 ]]; then
    PLUGINS=(git hg jump osc virtualenv keychain)
    KEYCHAIN_USER=(tampakrap 'Theo Chatzimichos <tampakrap@gentoo.org>')
    WORKSTATIONS=(canibus xzibit rakim virtuoso)
    KEYS=(0x9640E4FA29485B97 0xFFF3F17EA98D80F5 0xC9DA5BE037C3164C)

    for plugin in ${PLUGINS[@]}; do
        local plugin_path="${HOME}/.zsh/plugins"
        [ -f $plugin_path/$plugin.zsh ] && source $plugin_path/$plugin.zsh
    done
fi
