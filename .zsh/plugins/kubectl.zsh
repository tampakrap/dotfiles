KUBECTL=kubecolor

alias k=$KUBECTL
alias kctl=$KUBECTL
alias κυβερνήτης=$KUBECTL

compdef kubecolor=kubectl

#source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
#PS1='$(kube_ps1)'$PS1

alias kg='$KUBECTL get'

# Execute a kubectl command against all namespaces
alias kca='_kca(){ $KUBECTL "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Apply a YML file
alias kaf='$KUBECTL apply -f'

# Drop into an interactive terminal on a container
alias keti='$KUBECTL exec -t -i'
# Execute a command in a container
alias kex='$KUBECTL exec'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='$KUBECTL config use-context'
alias kcsc='$KUBECTL config set-context'
alias kcdc='$KUBECTL config delete-context'
alias kccc='$KUBECTL config current-context'

# List all contexts
alias kcgc='$KUBECTL config get-contexts'

# General aliases
alias kdel='$KUBECTL delete'
alias kdelf='$KUBECTL delete -f'

# Pod management.
alias kgp='$KUBECTL get pods'
alias kgpa='$KUBECTL get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='$KUBECTL edit pods'
alias kdp='$KUBECTL describe pods'
alias kdelp='$KUBECTL delete pods'
alias kgpall='$KUBECTL get pods --all-namespaces -o wide'

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'

# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='$KUBECTL get svc'
alias kgsa='$KUBECTL get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='$KUBECTL edit svc'
alias kds='$KUBECTL describe svc'
alias kdels='$KUBECTL delete svc'

# Ingress management
alias kgi='$KUBECTL get ingress'
alias kgia='$KUBECTL get ingress --all-namespaces'
alias kei='$KUBECTL edit ingress'
alias kdi='$KUBECTL describe ingress'
alias kdeli='$KUBECTL delete ingress'

# Namespace management
alias kgns='$KUBECTL get namespaces'
alias kens='$KUBECTL edit namespace'
alias kdns='$KUBECTL describe namespace'
alias kdelns='$KUBECTL delete namespace'
alias kcn='$KUBECTL config set-context --current --namespace'

# ConfigMap management
alias kgcm='$KUBECTL get configmaps'
alias kgcma='$KUBECTL get configmaps --all-namespaces'
alias kecm='$KUBECTL edit configmap'
alias kdcm='$KUBECTL describe configmap'
alias kdelcm='$KUBECTL delete configmap'

# Secret management
alias kgsec='$KUBECTL get secret'
alias kgseca='$KUBECTL get secret --all-namespaces'
alias kdsec='$KUBECTL describe secret'
alias kdelsec='$KUBECTL delete secret'

# Deployment management.
alias kgd='$KUBECTL get deployment'
alias kgda='$KUBECTL get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='$KUBECTL edit deployment'
alias kdd='$KUBECTL describe deployment'
alias kdeld='$KUBECTL delete deployment'
alias ksd='$KUBECTL scale deployment'
alias krsd='$KUBECTL rollout status deployment'

function kres(){
  $KUBECTL set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Rollout management.
alias kgrs='$KUBECTL get replicaset'
alias kdrs='$KUBECTL describe replicaset'
alias kers='$KUBECTL edit replicaset'
alias krh='$KUBECTL rollout history'
alias kru='$KUBECTL rollout undo'

# Statefulset management.
alias kgss='$KUBECTL get statefulset'
alias kgssa='$KUBECTL get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='$KUBECTL edit statefulset'
alias kdss='$KUBECTL describe statefulset'
alias kdelss='$KUBECTL delete statefulset'
alias ksss='$KUBECTL scale statefulset'
alias krsss='$KUBECTL rollout status statefulset'

# Port forwarding
alias kpf="$KUBECTL port-forward"

# Tools for accessing all information
alias kga='$KUBECTL get all'
alias kgaa='$KUBECTL get all --all-namespaces'

# Logs
alias kl='$KUBECTL logs'
alias kl1h='$KUBECTL logs --since 1h'
alias kl1m='$KUBECTL logs --since 1m'
alias kl1s='$KUBECTL logs --since 1s'
alias klf='$KUBECTL logs -f'
alias klf1h='$KUBECTL logs --since 1h -f'
alias klf1m='$KUBECTL logs --since 1m -f'
alias klf1s='$KUBECTL logs --since 1s -f'

# File copy
alias kcp='$KUBECTL cp'

# Node Management
alias kgno='$KUBECTL get nodes'
alias keno='$KUBECTL edit node'
alias kdno='$KUBECTL describe node'
alias kdelno='$KUBECTL delete node'

# SC management
alias kgsc='$KUBECTL get sc'
alias kdelsc='$KUBECTL delete sc'

# PV management
alias kgpv='$KUBECTL get pv'
alias kdelpv='$KUBECTL delete pv'

# PVC management.
alias kgpvc='$KUBECTL get pvc'
alias kgpvca='$KUBECTL get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='$KUBECTL edit pvc'
alias kdpvc='$KUBECTL describe pvc'
alias kdelpvc='$KUBECTL delete pvc'

# Service account management.
alias kdsa="$KUBECTL describe sa"
alias kdelsa="$KUBECTL delete sa"

# DaemonSet management.
alias kgds='$KUBECTL get daemonset'
alias kgdsw='kgds --watch'
alias keds='$KUBECTL edit daemonset'
alias kdds='$KUBECTL describe daemonset'
alias kdelds='$KUBECTL delete daemonset'

# CronJob management.
alias kgcj='$KUBECTL get cronjob'
alias kecj='$KUBECTL edit cronjob'
alias kdcj='$KUBECTL describe cronjob'
alias kdelcj='$KUBECTL delete cronjob'

# Job management.
alias kgj='$KUBECTL get job'
alias kej='$KUBECTL edit job'
alias kdj='$KUBECTL describe job'
alias kdelj='$KUBECTL delete job'

# Custom Resource Definitions
alias kgcrd='$KUBECTL get crd'

# Only run if the user actually has kubecolor installed
if (( ${+_comps[kubecolor]} )); then
  function kj() { kubecolor "$@" -o json | jq; }
  function kjx() { kubecolor "$@" -o json | fx; }
  function ky() { kubecolor "$@" -o yaml | yh; }

  compdef kj=kubectl
  compdef kjx=kubectl
  compdef ky=kubectl
fi

# kubectx / kubens
alias ktx=kubectx
alias kns=kubens
