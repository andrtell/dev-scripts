#!/usr/bin/env bash

@git-is-repo() {
    if ! git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null; then
        return 1
    fi
}

@git-dir() {
    echo $(git rev-parse --show-toplevel)
}

@git-branch() {
    echo $(git rev-parse --abbrev-ref HEAD)
}

@git-hash() {
    echo $(git rev-parse ${1:-HEAD})
}

@git-short-hash() {
    echo $(git rev-parse --short ${1:-HEAD})
}

@git-has-staged() {
    if git diff-index --quiet --cached HEAD --; then
        return 1
    fi
}

@git-has-changed() {
    if git diff-files --quiet; then
        return 1
    fi
}

@git-has-untracked() {
    if [[ -z "$(git ls-files --exclude-standard --others)" ]]; then
        return 1
    fi
}
