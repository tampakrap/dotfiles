export TFENV_AUTO_INSTALL=true
export TF_PLUGIN_CACHE_DIR=~/.cache/terraform/providers

alias tf="terraform"
alias tfdocs="terraform-docs -c ~/.terraform-docs.yml md ."
alias tfgrep='grep --exclude-dir=".terraform" --exclude-dir=".terragrunt" --exclude-dir=".terragrunt-cache" --exclude-dir=".git" --exclude=".terraform.lock.hcl" '
alias tfdiff='diff --exclude=".terraform" --exclude=".git" '
alias tfproviderslock='tf providers lock -platform=linux_amd64 -platform=linux_arm64 -platform=darwin_amd64 -platform=darwin_arm64'

tffmt() {
    terraform fmt 2>/dev/null || /usr/local/Cellar/tfenv/3.0.0/versions/$(ls -rt /usr/local/Cellar/tfenv/3.0.0/versions | tail -n 1)/terraform fmt
}
