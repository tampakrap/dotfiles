export VAULT_GITHUB_API_TOKEN=$(get-token -t github-vault)
export TF_VAR_github_api_token=$VAULT_GITHUB_API_TOKEN
export GITHUB_TOKEN=$(get-token -t github)
export AIVEN_TOKEN=$(get-token -t aiven)
export CLOUDFLARE_API_TOKEN=$(get-token -t cloudflare)
export REMOTE_USER=admin
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export SAML2AWS_REGION=$(cat ${HOME}/.aws/default_region)
export SAML2AWS_PROFILE_SHORT=true
export JT_GITHUB_USER=tampakrap-jt
#export GO111MODULE=on
#export GOPRIVATE="github.com/jobandtalent"
#export BUNDLE_GEM__FURY__IO=$(get-token -t gemfury)
#export PATH="/usr/local/opt/python@3.11/libexec/bin:/usr/local/opt/libpq/bin:/usr/local/opt/node@16/bin:$PATH"

source $REPOS_GH/marcelobartsch/saml2aws-oh-my-zsh/saml2aws.plugin.zsh

old_saml2aws_login_wrapper() {
    old_saml2aws_login $1
    [[ $? == 0 ]] && source ~/.aws/old_role
    [[ -f ~/.aws/old_role ]] && rm ~/.aws/old_role
}

## The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/tampakrap/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tampakrap/Downloads/google-cloud-sdk/path.zsh.inc'; fi
#
## The next line enables shell command completion for gcloud.
#if [ -f '/Users/tampakrap/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tampakrap/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
