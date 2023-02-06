alias k=kubecolor
alias kctl=kubecolor
alias κυβερνήτης=kubecolor

compdef kubecolor=kubectl

#source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
#PS1='$(kube_ps1)'$PS1

# Execute a kubecolor command against all namespaces
alias kca='_kca(){ kubecolor "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Apply a YML file
alias kaf='kubecolor apply -f'

# Drop into an interactive terminal on a container
alias keti='kubecolor exec -t -i'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='kubecolor config use-context'
alias kcsc='kubecolor config set-context'
alias kcdc='kubecolor config delete-context'
alias kccc='kubecolor config current-context'

# List all contexts
alias kcgc='kubecolor config get-contexts'

# General aliases
alias kdel='kubecolor delete'
alias kdelf='kubecolor delete -f'

# Pod management.
alias kgp='kubecolor get pods'
alias kgpa='kubecolor get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubecolor edit pods'
alias kdp='kubecolor describe pods'
alias kdelp='kubecolor delete pods'
alias kgpall='kubecolor get pods --all-namespaces -o wide'

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'

# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='kubecolor get svc'
alias kgsa='kubecolor get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubecolor edit svc'
alias kds='kubecolor describe svc'
alias kdels='kubecolor delete svc'

# Ingress management
alias kgi='kubecolor get ingress'
alias kgia='kubecolor get ingress --all-namespaces'
alias kei='kubecolor edit ingress'
alias kdi='kubecolor describe ingress'
alias kdeli='kubecolor delete ingress'

# Namespace management
alias kgns='kubecolor get namespaces'
alias kens='kubecolor edit namespace'
alias kdns='kubecolor describe namespace'
alias kdelns='kubecolor delete namespace'
alias kcn='kubecolor config set-context --current --namespace'

# ConfigMap management
alias kgcm='kubecolor get configmaps'
alias kgcma='kubecolor get configmaps --all-namespaces'
alias kecm='kubecolor edit configmap'
alias kdcm='kubecolor describe configmap'
alias kdelcm='kubecolor delete configmap'

# Secret management
alias kgsec='kubecolor get secret'
alias kgseca='kubecolor get secret --all-namespaces'
alias kdsec='kubecolor describe secret'
alias kdelsec='kubecolor delete secret'

# Deployment management.
alias kgd='kubecolor get deployment'
alias kgda='kubecolor get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubecolor edit deployment'
alias kdd='kubecolor describe deployment'
alias kdeld='kubecolor delete deployment'
alias ksd='kubecolor scale deployment'
alias krsd='kubecolor rollout status deployment'

function kres(){
  kubecolor set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Rollout management.
alias kgrs='kubecolor get replicaset'
alias kdrs='kubecolor describe replicaset'
alias kers='kubecolor edit replicaset'
alias krh='kubecolor rollout history'
alias kru='kubecolor rollout undo'

# Statefulset management.
alias kgss='kubecolor get statefulset'
alias kgssa='kubecolor get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubecolor edit statefulset'
alias kdss='kubecolor describe statefulset'
alias kdelss='kubecolor delete statefulset'
alias ksss='kubecolor scale statefulset'
alias krsss='kubecolor rollout status statefulset'

# Port forwarding
alias kpf="kubecolor port-forward"

# Tools for accessing all information
alias kga='kubecolor get all'
alias kgaa='kubecolor get all --all-namespaces'

# Logs
alias kl='kubecolor logs'
alias kl1h='kubecolor logs --since 1h'
alias kl1m='kubecolor logs --since 1m'
alias kl1s='kubecolor logs --since 1s'
alias klf='kubecolor logs -f'
alias klf1h='kubecolor logs --since 1h -f'
alias klf1m='kubecolor logs --since 1m -f'
alias klf1s='kubecolor logs --since 1s -f'

# File copy
alias kcp='kubecolor cp'

# Node Management
alias kgno='kubecolor get nodes'
alias keno='kubecolor edit node'
alias kdno='kubecolor describe node'
alias kdelno='kubecolor delete node'

# PVC management.
alias kgpvc='kubecolor get pvc'
alias kgpvca='kubecolor get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubecolor edit pvc'
alias kdpvc='kubecolor describe pvc'
alias kdelpvc='kubecolor delete pvc'

# Service account management.
alias kdsa="kubecolor describe sa"
alias kdelsa="kubecolor delete sa"

# DaemonSet management.
alias kgds='kubecolor get daemonset'
alias kgdsw='kgds --watch'
alias keds='kubecolor edit daemonset'
alias kdds='kubecolor describe daemonset'
alias kdelds='kubecolor delete daemonset'

# CronJob management.
alias kgcj='kubecolor get cronjob'
alias kecj='kubecolor edit cronjob'
alias kdcj='kubecolor describe cronjob'
alias kdelcj='kubecolor delete cronjob'

# Job management.
alias kgj='kubecolor get job'
alias kej='kubecolor edit job'
alias kdj='kubecolor describe job'
alias kdelj='kubecolor delete job'

# Only run if the user actually has kubecolor installed
if (( ${+_comps[kubecolor]} )); then
  function kj() { kubecolor "$@" -o json | jq; }
  function kjx() { kubecolor "$@" -o json | fx; }
  function ky() { kubecolor "$@" -o yaml | yh; }

  compdef kj=kubectl
  compdef kjx=kubectl
  compdef ky=kubectl
fi
