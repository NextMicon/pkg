#!/bin/bash

set -e
mkdir -p dist

for dir in $(find . -type d -regex './[^/]+/[0-9]+\.[0-9]+\.[0-9]+' | sed 's|^\./||'); do
    name=$(echo "$dir" | cut -d'/' -f1)
    tag=$(echo "$dir" | cut -d'/' -f2)
    pkg="${name}:${tag}.tar.gz"
    echo "Compress $dir to $pkg"
    tar -czf "dist/$pkg" -C "$(dirname "$dir")" "$(basename "$dir")"
done

# Generate README.md
echo "Generating README.md"
cat > dist/README.md << 'EOF'
# Package Index

## Available Packages

EOF

# List all packages
for pkg in dist/*.tar.gz; do
    if [ -f "$pkg" ]; then
        file=$(basename "$pkg")
        echo "- [$file]($file)" >> dist/README.md
    fi
done
