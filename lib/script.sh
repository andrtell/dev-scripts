#!/usr/bin/env bash

@script-needs() {
    local -a NOT_FOUND

    for NAME in $*; do
        if ! type -p $NAME &> /dev/null; then
            NOT_FOUND+=($NAME)
        fi
    done

    if [[ ${#NOT_FOUND[@]} -gt 0 ]]; then
        echo ${NOT_FOUND[@]}
        return 1
    fi

    return 0
}
