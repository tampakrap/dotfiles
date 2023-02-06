export VAULT_GITHUB_API_TOKEN=$(get-token -t github-vault)
export TF_VAR_github_api_token=$VAULT_GITHUB_API_TOKEN
export REMOTE_USER=admin
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export CLOUDFLARE_API_TOKEN=$(get-token -t cloudflare)
#export BUNDLE_GEM__FURY__IO=$(get-token -t gemfury)
#export TF_VAR_production_datadog_api_key=
#export TF_VAR_production_datadog_app_key=

source ${HOME}/Repos/various/saml2aws-oh-my-zsh/saml2aws.plugin.zsh
