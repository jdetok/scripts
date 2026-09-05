#!/usr/bin/env bash

msg=""
push_upstream=false
branch=""
positional=()

while [[ $# > 0 ]]; do
    case "$1" in
        -m)
            msg="$2"
            shift 2
            ;;
        -u)
            push_upstream=true
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            shift
            ;;
        *)
            positional+=("$1")
            shift
            ;;
    esac
done

if $push_upstream && [[ ${#positional[@]} -ge 2 ]]; then
    branch="${positional[0]}"
    [[ -z "$msg" ]] && msg="${positional[1]}"
elif [[ ${#positional[@]} -ge 1 ]]; then
    [[ -z "$msg" ]] && msg="${positional[0]}"
fi

branch="${branch:-main}"

# if no message is passed prompt for one
if [[ -z "$msg" ]]; then
    read -p "commit msg can't be empty: " msg
fi 

# run git commands
git add . && git commit -m "$msg"

if $push_upstream; then
    git push -u origin "$branch"
else
    git push
fi
