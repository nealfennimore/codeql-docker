FROM ubuntu:latest

ARG CLI_VERSION=2.4.4

RUN apt update \
    && apt install -y git zip wget \
    && rm -rf /var/lib/apt/lists/* 

RUN useradd -ms /bin/bash cli
USER cli

RUN wget -q -O /tmp/codeql-linux64.zip https://github.com/github/codeql-cli-binaries/releases/download/v$CLI_VERSION/codeql-linux64.zip \
    && unzip -q /tmp/codeql-linux64.zip -d $HOME \
    && rm /tmp/codeql-linux64.zip

RUN git clone https://github.com/github/codeql.git $HOME/codeql-repo \
    && cd $HOME/codeql-repo \
    && git submodule update --init --remote

ENV PATH="/home/cli/codeql:${PATH}"

RUN codeql resolve qlpacks
RUN codeql resolve languages

CMD ["codeql", "--help"]