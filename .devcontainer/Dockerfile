FROM mcr.microsoft.com/devcontainers/javascript-node:1-20-bookworm

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        jq \
        less \
        openssh-client \
        ripgrep \
    && npm install --global lim @bazel/bazelisk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
