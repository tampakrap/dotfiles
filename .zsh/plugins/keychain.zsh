if [[ $(whoami) == ${KEYCHAIN_USER[1]} && ${WORKSTATIONS[@]} =~ $(hostname) ]]; then
    export ECHANGELOG_USER=${KEYCHAIN_USER[2]}
    eval `keychain --eval --nogui --quiet --timeout 360 id_rsa`
    gpg2 -dq --batch --yes ~/.password-store/various/nothing.gpg
fi
