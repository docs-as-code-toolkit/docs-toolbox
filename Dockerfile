# ---------------------------
# Base Image: Java + Tools
# ---------------------------
# The official openjdk images are no longer maintained. Temurin is, and 21 is an
# LTS release that runs Gradle 8 and 9. The OS release is pinned too, so a new
# Ubuntu does not arrive unannounced with a rebuild.
FROM eclipse-temurin:21-jdk-resolute

LABEL org.opencontainers.image.title="docs-toolbox" \
      org.opencontainers.image.description="A lightweight Docker image for running Docs-as-Code pipelines in a fully reproducible environment — locally and in CI." \
      org.opencontainers.image.source="https://github.com/docs-as-code-toolkit/docs-toolbox" \
      org.opencontainers.image.licenses="MIT"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    asciidoctor \
    pandoc \
    graphviz \
    unzip \
    curl \
    python3 \
    nodejs \
    npm \
    fonts-crosextra-carlito \
    && gem install --no-document asciidoctor-diagram asciidoctor-diagram-plantuml asciidoctor-revealjs \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/docs-toolbox-serve /usr/local/bin/docs-toolbox-serve

# Arbeitsverzeichnis
WORKDIR /app

# Flexible entrypoint – beliebige Commands
ENTRYPOINT []
