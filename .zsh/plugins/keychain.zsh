if [[ $(whoami) == tampakrap && ${WORKSTATIONS[@]} =~ $(hostname) ]]; then
    eval `keychain --eval --nogui --quiet --timeout 360 --agents ssh,gpg id_rsa`
    gpg2 -dq --batch --yes ~/.password-store/various/nothing.gpg
fi
