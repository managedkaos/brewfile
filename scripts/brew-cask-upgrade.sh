#!/bin/bash
brew upgrade $(awk '{gsub(/"/, "", $2); print $2}' ./Brewfile.casks)

