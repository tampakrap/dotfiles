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
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_PROMPT_ORDER=(
    #time          # Time stamps section
    user          # Username section
    host          # Hostname section
    dir           # Current directory section
    git           # Git section (git_branch + git_status)
    #hg            # Mercurial section (hg_branch  + hg_status)
    #package       # Package version
    #node          # Node.js section
    ruby          # Ruby section
    #elixir        # Elixir section
    #xcode         # Xcode section
    #swift         # Swift section
    golang        # Go section
    #php           # PHP section
    #rust          # Rust section
    #haskell       # Haskell Stack section
    #julia         # Julia section
    docker        # Docker section
    aws           # Amazon Web Services section
    venv          # virtualenv section
    #conda         # conda virtualenv section
    pyenv         # Pyenv section
    #dotnet        # .NET section
    #ember         # Ember.js section
    kubecontext   # Kubectl context section
    terraform     # Terraform workspace section
    #exec_time     # Execution time
    #battery       # Battery level and status
    #vi_mode       # Vi-mode indicator
    jobs          # Background jobs indicator
    line_sep      # Line break
    exit_code     # Exit code section
    char          # Prompt character
)

prompt spaceship

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
