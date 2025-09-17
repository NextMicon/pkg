# Package

📦 Package Registory

[index](https://nextmicon.github.io/pkg)

## Registory Specification

1. [MUST] `https://<base>/index.yaml` - Registory index YAML file, listed all packages with their names and SHA256 hashes.
2. [MUST] `https://<base>/<package>:<tag>.tar.gz` - Download the specified package file.
3. [MAY] `https://<base>/` - HTML file listing all available packages with links to download them.
4. [MAY] `https://<base>/<package>:<tag>` - Documentation HTML for package.
5. [MAY] `https://<base>/<package>:<tag>/doc` - Extra recorces for documentation.
