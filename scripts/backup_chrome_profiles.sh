#!/bin/bash

function ,chromels() {
    rm ~/Dotfiles/chrome-profiles.txt
    for profile in ~/Library/Application\ Support/Google/Chrome/Profile*;
    do
        email_address=$(
            jq -r '.account_info[0].email' < "${profile}/Preferences"
        )

        printf "%-35s %s\n" "${email_address}" "\"${profile}\"" \
            | tee -a ~/Dotfiles/chrome-profiles.txt
    done
}

,chromels
