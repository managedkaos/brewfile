#!/bin/bash

# Check if filename argument provided
if [ -z "$1" ]; then
    echo "No input file given."
    exit 1
fi

input_file=$1
backup_dir=${PERSONAL_BACKUP_LOCATION}

while IFS= read -r line; do
    # check for empty lines in the file
    if [ ! -z "$line" ]; then
        if [ -e "$line" ]; then
            echo "Backing up: $line"
            rsync -ravzLK --progress --exclude="Workspace/Go" "$line" "$backup_dir/"
        else
            echo "Skipping missing file: $line"
        fi
    fi
done < "$input_file"
