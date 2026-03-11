#!/bin/bash

# Target directory (use "." for current directory)
TARGET_DIR="."

# Find all .qmd files recursively
find "$TARGET_DIR" -type f -name "*.qmd" | while read -r file; do
    # 1. If 'draft: FALSE' exists, swap it to 'TRUE'
    if grep -q "draft: [Ff]alse" "$file"; then
        sed -i '' 's/draft: [Ff]alse/draft: TRUE/g' "$file"
        echo "Updated: $file (Changed FALSE to TRUE)"

    # 2. If 'draft:' is completely missing, add it after the first '---'
    elif ! grep -q "draft:" "$file"; then
        # This uses sed to find the first line containing --- and append draft: TRUE after it
        sed -i '' '1,/---/ s/---/---\'$'\n''draft: TRUE/' "$file"
        echo "Updated: $file (Added new draft setting)"
    
    else
        echo "Skipped: $file (Already has draft setting)"
    fi
done
