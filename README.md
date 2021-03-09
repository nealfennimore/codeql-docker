# Docker CodeQL

Versioned [CodeQL](https://github.com/github/codeql) and [CodeQL CLI](https://github.com/github/codeql-cli-binaries) container.

See [CodeQL CLI Manual](https://codeql.github.com/docs/codeql-cli/manual/) for commands.

## Installation

```sh
docker pull ghcr.io/nealfennimore/codeql:latest
```

## Usage

### Database

#### Creation
```sh
docker run --rm -it \
    -v ~/code/db:/tmp/db \
    -v ~/code/src:/tmp/src \
    ghcr.io/nealfennimore/codeql \
    codeql database create --language=javascript --source-root /tmp/src /tmp/db
```

#### Analyzing Source Code
```sh
docker run --rm -it \
    -v ~/code/db:/tmp/db \
    -v ~/code/src:/tmp/src \
    -v ~/code/output:/tmp/output \
    ghcr.io/nealfennimore/codeql \
    codeql database analyze /tmp/db javascript-lgtm.qls \
        --format=sarif-latest \
        --output=/tmp/output/results.sarif
```