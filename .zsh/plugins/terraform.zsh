export TFENV_AUTO_INSTALL=false

alias tf="terraform"
alias tfdocs="terraform-docs -c ~/.terraform-docs.yml md ."
alias tfgrep='grep --exclude-dir=".terraform" --exclude-dir=".terragrunt" --exclude-dir=".terragrunt-cache" --exclude-dir=".git" --exclude=".terraform.lock.hcl" '
alias tfdiff='diff --exclude=".terraform" --exclude=".git" '

tffmt() {
    terraform fmt 2>/dev/null || /usr/local/Cellar/tfenv/3.0.0/versions/$(ls -rt /usr/local/Cellar/tfenv/3.0.0/versions | tail -n 1)/terraform fmt
}
