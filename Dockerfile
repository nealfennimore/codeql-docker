FROM ubuntu:20.04 as base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        vim \
        curl \
        wget \
        git \
        build-essential \
        unzip \
        apt-transport-https \
        python3.8 \
        python3-venv \
        python3-pip \
        python3-setuptools \
        python3-dev \
        gnupg \
        g++ \
        make \
        gcc \
        apt-utils \
        rsync \
        file \
        dos2unix \
        gettext && \
        apt-get clean && \
        ln -sf /usr/bin/python3.8 /usr/bin/python && \
        ln -sf /usr/bin/pip3 /usr/bin/pip


ARG CODE_LANGUAGE
ENV CODE_LANGUAGE=$CODE_LANGUAGE

# Install GO binary
RUN if [ "$CODE_LANGUAGE" = "go" ]; then wget -q -c https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O - | tar -xz -C /usr/local; fi

# Add cli user
RUN useradd -ms /bin/bash cli
USER cli

FROM base as source

ARG CLI_VERSION=2.4.4
ENV CLI_VERSION=$CLI_VERSION

# Install codeql-cli
RUN wget -q -O /tmp/codeql-linux64.zip https://github.com/github/codeql-cli-binaries/releases/download/v$CLI_VERSION/codeql-linux64.zip \
    && unzip -q /tmp/codeql-linux64.zip -d $HOME \
    && rm /tmp/codeql-linux64.zip

# Clone codeql repo
RUN git clone https://github.com/github/codeql.git $HOME/codeql-repo \
    && cd $HOME/codeql-repo \
    && git submodule update --init --remote

# Clone codeql-go repo
RUN if [ "$CODE_LANGUAGE" = "go" ]; then git clone https://github.com/github/codeql-go.git $HOME/codeql-go; fi

ENV PATH="/home/cli/codeql:/usr/local/go/bin:${PATH}"

# Ensure languages resolve
RUN codeql resolve qlpacks
RUN codeql resolve languages

FROM source as compiled

WORKDIR /home/cli/codeql

RUN if [ -d "$HOME/codeql-repo/$CODE_LANGUAGE" ]; then codeql query compile --threads=0 $HOME/codeql-repo/$CODE_LANGUAGE/ql/src/codeql-suites/*.qls; fi
RUN if [ "$CODE_LANGUAGE" = "go" ]; then codeql query compile --threads=0 $HOME/codeql-go/ql/src/codeql-suites/*.qls; fi

CMD ["codeql", "--help"]
