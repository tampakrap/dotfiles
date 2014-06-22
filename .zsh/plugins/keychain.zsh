if [[ $(whoami) == ${KEYCHAIN_USER[1]} && ${WORKSTATIONS[@]} =~ $(hostname) ]]; then
    export ECHANGELOG_USER=${KEYCHAIN_USER[2]}
    eval `keychain --eval --nogui --timeout 180 id_rsa --quiet`
fi
