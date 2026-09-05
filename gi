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
        -u=*)
            push_upstream=true
            branch="${1#-u=}"
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

if [[ -z "$msg" ]] && [[ ${#positional[@]} -ge 1 ]]; then
    msg="${positional[0]}"
fi

if [[ -z "$msg" ]]; then
    read -p "commit msg can't be empty: " msg
fi 

git add . && git commit -m "$msg" && { 
    $push_upstream && git push -u origin "$branch" || git push
}

