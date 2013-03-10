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
