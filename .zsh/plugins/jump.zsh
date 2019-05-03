# Jump plugin from oh-my-zsh
# Easily jump around the file system by manually adding marks
# marks are stored as symbolic links in the directory $MARKPATH (default $HOME/.marks)
#
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks
#
export MARKPATH=$HOME/.marks

jump() {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark() {
    if (( $# == 0 )); then
        MARK=$(basename "$(pwd)")
    else
        MARK="$1"
    fi
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$MARK"
    echo "Marked $(pwd) as ${MARK}"
}

unmark() {
    rm "$MARKPATH/$1"
}

marks() {
    for link in $MARKPATH/*(@); do
        local markname="$fg[cyan]${link:t}$reset_color"
        local markpath="$fg[blue]$(greadlink $link)$reset_color"
        printf "%s " $markname
        printf "-> %s \t\n" $markpath
    done
}

_completemarks() {
    if [[ $(ls "${MARKPATH}" | wc -l) -gt 1 ]]; then
        reply=($(ls $MARKPATH/**/*(-) | grep : | gsed -E 's/(.*)\/([_\da-zA-Z\-]*):$/\2/g'))
    else
        if greadlink -e "${MARKPATH}"/* &>/dev/null; then
            reply=($(ls "${MARKPATH}"))
        fi
    fi
}
compctl -K _completemarks jump
compctl -K _completemarks unmark
