#!/bin/bash
PATTERNS=("NOTE:" "TODO:" "FIX:" "console.info")
found_issues=false

files="$(git diff --cached --name-only)"

for file in $files; do
    if [[ ! -f "$file" ]]; then
        continue
    fi
    
    for pattern in "${PATTERNS[@]}"; do
        if grep -q "$pattern" "$file"; then
            echo "Found pattern '$pattern' in file '$file':"
            grep -n --color=always "$pattern" "$file"
            echo ""
            found_issues=true
        fi
    done
done

if [ "$found_issues" = true ]; then
    echo "Remove these notes or use 'git commit --skip' to skip."
    exit 1
fi

echo "Nothing to remove, good job buddy"
