#!/bin/bash

function ,chromels() {
    rm /Users/Michael.Jenkins/Dotfiles/chrome-profiles.txt
    for i in ~/Library/Application\ Support/Google/Chrome/Profile*;
    do
        echo "$i";
        jq '.account_info[] | "\(.email) \(.full_name)"' < "${i}/Preferences" | \
            tee -a /Users/Michael.Jenkins/Dotfiles/chrome-profiles.txt
    done
}

,chromels
