export VAULT_GITHUB_API_TOKEN=$(pass jobandtalent/github-token-jt-vault)
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export TF_VAR_github_api_token=$VAULT_GITHUB_API_TOKEN
export GPG_TTY=$(tty)
export GPG_AGENT_INFO=${HOME}/.gnupg/S.agent\=
