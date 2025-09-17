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
echo "Generating README.md & index.yaml"
touch dist/README.md
touch dist/index.yaml
echo "pkgs:" > dist/index.yaml

# List all packages
for pkg in dist/*.tar.gz; do
    if [ -f "$pkg" ]; then
        file=$(basename "$pkg")
        hash=$(sha256sum "$pkg" | awk '{print $1}')
        echo "- [$file](./$file)" >> dist/README.md
        echo "  - name: $file" >> dist/index.yaml
        echo "    hash: $hash" >> dist/index.yaml
    fi
done
