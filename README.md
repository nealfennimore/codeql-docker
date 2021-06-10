# Docker CodeQL

Versioned [CodeQL](https://github.com/github/codeql) and [CodeQL CLI](https://github.com/github/codeql-cli-binaries) container.

See [CodeQL CLI Manual](https://codeql.github.com/docs/codeql-cli/manual/) for commands.

## Installation

```sh
# Using uncompiled base
docker pull ghcr.io/nealfennimore/codeql:latest

# Using compiled language (cpp, csharp, csv, go, html, java, javascript, properties, python, xml supported)
docker pull ghcr.io/nealfennimore/codeql:javascript
docker pull ghcr.io/nealfennimore/codeql:go
docker pull ghcr.io/nealfennimore/codeql:cpp
```

## Usage

### Shell

To drop to shell to work with codeql directly

```sh
docker run --rm -it \
    -v ~/code/db:/tmp/db \
    -v ~/code/src:/tmp/src \
    -v ~/code/output:/tmp/output \
    ghcr.io/nealfennimore/codeql:$CODE_LANGUAGE bash

# Then proceed to create database for the language:
codeql database create --language=$CODE_LANGUAGE --source-root /tmp/src /tmp/db

# Analyze source code and generate report:
codeql database analyze /tmp/db $CODE_LANGUAGE-lgtm.qls --format=sarif-latest --output=/tmp/output/results.sarif
```

### Database

#### Creation
```sh
docker run --rm -it \
    -v ~/code/db:/tmp/db \
    -v ~/code/src:/tmp/src \
    ghcr.io/nealfennimore/codeql:$CODE_LANGUAGE \
    codeql database create --language=$CODE_LANGUAGE --source-root /tmp/src /tmp/db
```

#### Analyzing Source Code
```sh
docker run --rm -it \
    -v ~/code/db:/tmp/db \
    -v ~/code/src:/tmp/src \
    -v ~/code/output:/tmp/output \
    ghcr.io/nealfennimore/codeql:$CODE_LANGUAGE \
    codeql database analyze /tmp/db $CODE_LANGUAGE-lgtm.qls \ # Analyze with default query suites
        --format=sarif-latest \
        --output=/tmp/output/results.sarif
```

