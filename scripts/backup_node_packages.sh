#!/bin/bash

function listglobalnodepackages()  {
    npm list -g --depth=0 | tee ~/Dotfiles/global_node_packages.txt
}

listglobalnodepackages
