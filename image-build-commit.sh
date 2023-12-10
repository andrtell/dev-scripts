#!/bin/env bash

deps() {
    if ! type -p $1 &> /dev/null 
    then
        echo "'$1' must be installed to run this script."
        exit 126
    fi
}

deps "podman"
deps "jq"

if REPO_DIR=$(git rev-parse --show-toplevel 2> /dev/null); then
    cd $REPO_DIR
else
    echo "Not a Git repo"
    exit 1
fi

if [[ ! -f "Containerfile" ]] && [[ ! -f "Dockerfile" ]]; then
    echo "Dockerfile not found"
    exit 1
fi

DEPLOY_FILE="deploy.json"

if [[ ! -f $DEPLOY_FILE ]]; then
    echo "$DEPLOY_FILE not found"
    exit 1
fi

if ! git diff-index --quiet --cached HEAD --; then
    echo 'Repo has staged files'
    exit 1
fi

if ! git diff-files --quiet; then
    echo 'Repo has changed files'
    exit 1
fi

if [[ ! -z "$(git ls-files --exclude-standard --others)" ]]; then
    echo 'Repo has untracked files'
    exit 0
fi

if ! NAME=$(jq -re ".name" $DEPLOY_FILE); then
    echo "\"name\" not found in $DEPLOY_FILE"
    exit 1
fi

if ! REGISTRY=$(jq -re ".registry" deploy.json); then
    echo "\"registry\" not found in $DEPLOY_FILE"
    exit 1
fi

GIT_BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
GIT_COMMIT_HASH="$(git rev-parse --short HEAD)"

REPOSITORY="$REGISTRY/$NAME"

IMAGE_NAME="$REPOSITORY:${GIT_BRANCH_NAME}_${GIT_COMMIT_HASH}"

pretty_print() {
    IN="$*"
    LINE="$(echo " $IN " | sed 's/./─/g')"
    echo "╭$LINE╮"
    echo "│ $IN │"
    echo "╰$LINE╯"
}

if podman image exists "$IMAGE_NAME"; then
    pretty_print "$IMAGE_NAME"
    exit 0
fi

if podman build --tag $IMAGE_NAME .; then
    pretty_print $IMAGE_NAME
fi
