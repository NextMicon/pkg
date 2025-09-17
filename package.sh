#!/bin/bash

set -e
mkdir -p dist

for dir in $(find pkg -type d -regex 'pkg/[^/]+/[0-9]+\.[0-9]+\.[0-9]+' | sed 's|^pkg/||'); do
    name=$(echo "$dir" | cut -d'/' -f1)
    tag=$(echo "$dir" | cut -d'/' -f2)
    pkg="${name}:${tag}.tar.gz"

    echo " - $dir -> $pkg"

    # Package
    tar -czf "dist/$pkg" -C "pkg/$name" "$(basename "$dir")"
    
    # Documents
    mkdir -p "dist/${name}:${tag}"
    if [ -f "pkg/$dir/README.md" ]; then
        cp "pkg/$dir/README.md" "dist/${name}:${tag}/README.md"
    else
        touch "dist/${name}:${tag}/README.md"
        echo "# ${name}:${tag}" > "dist/${name}:${tag}/README.md"
    fi
    if [ -d "pkg/$dir/doc" ]; then
        cp -r "pkg/$dir/doc" "dist/${name}:${tag}/doc"
    fi
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
