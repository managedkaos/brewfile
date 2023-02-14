#!/bin/bash
# Description: Check if uninstalled casks are still in Brewfile

echo "The following formulae are present in Brewfile and uninstalled-casks.md:"
echo "------------------------------------------------------------------------"
for i in $(cut -d\" -f 2 uninstalled-casks.md  | grep -vE "(\`|\#|brew)");
do
    if grep -qc "\"${i}\"" Brewfile; then
        echo "${i}"
    fi
done | tee /tmp/check.txt
