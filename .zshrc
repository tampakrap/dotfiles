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
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

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

eval $(hub alias -s)

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

SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_AWS_SYMBOL="☁️  "
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SYMBOL="🛠 "
SPACESHIP_JOBS_AMOUNT_THRESHOLD=0
SPACESHIP_PROMPT_ORDER=(
    #time          # Time stamps section
    user          # Username section
    host          # Hostname section
    dir           # Current directory section
    git           # Git section (git_branch + git_status)
    #hg            # Mercurial section (hg_branch  + hg_status)
    #package       # Package version
    node          # Node.js section
    ruby          # Ruby section
    #elixir        # Elixir section
    #xcode         # Xcode section
    #swift         # Swift section
    #golang        # Go section
    php           # PHP section
    #rust          # Rust section
    #haskell       # Haskell Stack section
    #julia         # Julia section
    docker        # Docker section
    aws           # Amazon Web Services section
    venv          # virtualenv section
    #conda         # conda virtualenv section
    #pyenv         # Pyenv section
    #dotnet        # .NET section
    #ember         # Ember.js section
    kubecontext   # Kubectl context section
    terraform     # Terraform workspace section
    #exec_time     # Execution time
    #battery       # Battery level and status
    #vi_mode       # Vi-mode indicator
    jobs          # Background jobs indicator
    line_sep      # Line break
    #exit_code     # Exit code section
    char          # Prompt character
)

prompt spaceship

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
compctl -g '*tar *.tar.bz2 *.tbz2 *.tar.gz *.tgz *.tar.xz *.bz2 *.gz *.zip *.jar *.rar *.Z *.gem *.rpm *.7z' + -g '*(-/)' extract

autoload -U tetris
zle -N tetris
bindkey "^X^T" tetris

function cdl() {
    cd $*
    ll
}

function grt() {
    while [ ! -d ".git" ]; do
        cd ..
    done
}

function multiline() {
    if [[ $1 == 'off' ]]; then
        switch='false'
    elif [[ $1 == 'on' ]]; then
        switch='true'
    else
        switch=$1
    fi
    export SPACESHIP_PROMPT_SEPARATE_LINE=$switch
    export SPACESHIP_DOCKER_SHOW=$switch
    export SPACESHIP_AWS_SHOW=$switch
    #export SPACESHIP_KUBECONTEXT_SHOW=$switch
    export SPACESHIP_TERRAFORM_SHOW=$switch
}

source $HOME/.iterm2_shell_integration.zsh
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

stty discard undef

if [[ $UID != 0 ]]; then
    PLUGINS=(jump keychain)
    WORKSTATIONS=(quasimoto rakim)
    KEYS=(0x9640E4FA29485B97 0xFFF3F17EA98D80F5 0xC9DA5BE037C3164C)

    for plugin in ${PLUGINS[@]}; do
        local plugin_path="${HOME}/.zsh/plugins"
        [ -f $plugin_path/$plugin.zsh ] && source $plugin_path/$plugin.zsh
    done
fi
