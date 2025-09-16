#!/bin/bash

set -e
mkdir -p dist

for dir in $(find . -type d -regex './[^/]+/[0-9]+\.[0-9]+\.[0-9]+' | sed 's|^\./||'); do
    name=$(echo "$dir" | cut -d'/' -f1)
    tag=$(echo "$dir" | cut -d'/' -f2)
    package="${name}:${tag}.tar.gz"
    echo "Compressing $dir to $package..."
    tar -czf "dist/$package" -C "$(dirname "$dir")" "$(basename "$dir")"
    echo "Created: dist/$package"
done

echo ""
echo "Created archives:"
ls -lh dist/
