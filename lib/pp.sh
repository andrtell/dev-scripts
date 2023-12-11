#!/usr/bin/env bash

@pp-box() {
    local IN="$*"
    local LINE="$(echo " $IN " | sed 's/./─/g')"
    echo "╭$LINE╮"
    echo "│ $IN │"
    echo "╰$LINE╯"
}

@pp-color() {
    local -A COLOR_TABLE=(\
        ["red"]="\033[0;31m"\
        ["green"]="\033[0;32m"\
        ["yellow"]="\033[0;33m"\
        ["blue"]="\033[0;34m"\
        ["none"]="\033[0m"\
    )
    printf "%b" ${COLOR_TABLE[$1]}
}

@pp-error() {
    @pp-color red
    echo $1 >&2
    @pp-color none
}
