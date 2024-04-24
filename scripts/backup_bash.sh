#!/bin/bash

function bkbash() {
    for i in .bash_aliases .bash_completion .bash_functions .bash_profile .bash_ssh_aliases .bash_eternal_history;
    do
        cp -v ~/${i} /Users/Michael.Jenkins/Library/CloudStorage/OneDrive-Personal/Notes/scripts/my${i}.txt
    done
}

bkbash
