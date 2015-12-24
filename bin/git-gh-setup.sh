#!/usr/bin/env bash
 
git remote -v | grep fetch | grep github | \
    while read remote url _; do
        if ! git config --get-all "remote.$remote.fetch" | grep -q refs/pull
        then
            git config --add "remote.$remote.fetch" \
                '+refs/pull/*/head:refs/remotes/'"$remote"'/pull/*'
        fi
    done
