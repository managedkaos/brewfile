#!/bin/bash

function dotfiles() {
    pwd=$(pwd)
    git -C ${HOME}/Dotfiles pull
    for i in $(cat ${HOME}/Dotfiles/dotfiles.txt);
    do
        rsync -aqz $i ${HOME}/Dotfiles;
    done

    cd ${HOME}/Dotfiles;

    if ! git diff --ignore-space-change --minimal --color-words --exit-code;
    then
        git add --all;
        if (( $# != 0 ))
        then
            git commit -am "$1";
        else
            git commit --allow-empty-message -am 'Updating dotfiles with latest changes.';
        fi;
        git push
    fi;
    rsync -aqz ${HOME}/Documents/ ${HOME}/Google_Drive/Documents/
    cd $pwd
}

dotfiles
