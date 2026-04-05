# ---------------------------
# Base Image: Java + Tools
# ---------------------------
FROM openjdk:22-jdk-slim

LABEL org.opencontainers.image.title="docs-toolbox" \
      org.opencontainers.image.description="A lightweight Docker image for running Docs-as-Code pipelines in a fully reproducible environment — locally and in CI." \
      org.opencontainers.image.source="https://github.com/docs-as-code-toolkit/docs-toolbox" \
      org.opencontainers.image.licenses="MIT"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    pandoc \
    graphviz \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis
WORKDIR /app

# Flexible entrypoint – beliebige Commands
ENTRYPOINT []