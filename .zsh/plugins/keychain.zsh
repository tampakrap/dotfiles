if [[ $(whoami) == tampakrap && ${WORKSTATIONS[@]} =~ $(hostname -s) ]]; then
    eval `keychain --eval --nogui --quiet --timeout 360 --agents ssh,gpg id_ed25519 id_rsa`
    gpg -dq --batch --yes ~/.password-store/various/nothing.gpg
fi
