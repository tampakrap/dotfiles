export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpg-connect-agent -q /bye
