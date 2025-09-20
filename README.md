# Package

📦 Package Registory

[index](https://nextmicon.github.io/pkg)

## Registory Specification

1. `https://<base>/index.yaml` - Registory index YAML file, listed all packages with their names and SHA256 hashes.

```yaml
pkgs:
  - name: ADC:0.0.0.tar.gz
    hash: c890b403a395b20bd2936f06c64b6ab757a7b86a7a4aebf8a48c2f659fdf2f5e
```

2. `https://<base>/<package>:<tag>.tar.gz` - Link to download package archive.
3. `https://<base>/` - HTML file listing all available packages with links to download them.
4. `https://<base>/<package>:<tag>/` - Documentation HTML for package.
5. `https://<base>/<package>:<tag>/doc/*` - Extra recorces for documentation if needed.

## Local Development

```
pnpm dev
```
