export TFENV_AUTO_INSTALL=true

alias tf="terraform"
alias tf15="TFENV_TERRAFORM_VERSION=latest:^1.5 /opt/homebrew/bin/terraform"
alias tfdocs="terraform-docs -c ~/.terraform-docs.yml md ."
alias tfgrep='grep --exclude-dir=".terraform" --exclude-dir=".terragrunt" --exclude-dir=".terragrunt-cache" --exclude-dir=".git" --exclude=".terraform.lock.hcl" '
alias tfdiff='diff --exclude=".terraform" --exclude=".git" '
alias tfproviderslock='tf providers lock -platform=linux_amd64 -platform=linux_arm64 -platform=darwin_amd64 -platform=darwin_arm64'

tffmt() {
    terraform fmt 2>/dev/null || tf15 fmt
}
