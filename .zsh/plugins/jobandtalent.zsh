export VAULT_GITHUB_API_TOKEN=$(get-token -t github-vault)
export TF_VAR_github_api_token=$VAULT_GITHUB_API_TOKEN
export AIVEN_TOKEN=$(get-token -t aiven)
export REMOTE_USER=admin
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export SAML2AWS_REGION=$(cat ${HOME}/.aws/default_region)
export SAML2AWS_PROFILE_SHORT=true
export CLOUDFLARE_API_TOKEN=$(get-token -t cloudflare)
export GO111MODULE=on
export GOPRIVATE="github.com/jobandtalent"
#export BUNDLE_GEM__FURY__IO=$(get-token -t gemfury)
#export PATH="/usr/local/opt/python@3.11/libexec/bin:/usr/local/opt/libpq/bin:/usr/local/opt/node@16/bin:$PATH"

source ${HOME}/Repos/various/saml2aws-oh-my-zsh/saml2aws.plugin.zsh

old_saml2aws_login_wrapper() {
    ~/Repos/tampakrap/bin/old_saml2aws_login $1
    [[ $? == 0 ]] && source ~/.aws/old_role
    [[ -f ~/.aws/old_role ]] && rm ~/.aws/old_role
}

## The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/tampakrap/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tampakrap/Downloads/google-cloud-sdk/path.zsh.inc'; fi
#
## The next line enables shell command completion for gcloud.
#if [ -f '/Users/tampakrap/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tampakrap/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

connect_argo() {
    tsh login --proxy=$TELEPORT_PROXY
    tsh apps login argo
    argocd login --sso $ARGOCD_SERVER
}

connect_argo_glb() {
    export TELEPORT_PROXY=$(get-token -t teleport-glb) #"connect.glb.jobandtalent.cloud"
    export ARGOCD_SERVER=$(get-token -t argocd-glb) #"argo.connect.glb.jobandtalent.cloud"
    export ARGOCD_OPTS="--client-crt $HOME/.tsh/keys/$TELEPORT_PROXY/$USER-app/$TELEPORT_PROXY/argo-x509.pem --client-crt-key $HOME/.tsh/keys/$TELEPORT_PROXY/$USER --grpc-web"
    connect_argo
}

connect_argo_exp() {
    export TELEPORT_PROXY=$(get-token -t teleport-exp) #"connect.exp.jobandtalent.cloud"
    export ARGOCD_SERVER=$(get-token -t argocd-exp) #"argo.connect.exp.jobandtalent.cloud"
    export ARGOCD_OPTS="--client-crt $HOME/.tsh/keys/$TELEPORT_PROXY/$USER-app/$TELEPORT_PROXY/argo-x509.pem --client-crt-key $HOME/.tsh/keys/$TELEPORT_PROXY/$USER --grpc-web"
    connect_argo
}
