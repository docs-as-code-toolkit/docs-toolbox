# General Semantic Contracts

This repository delegates architecture documentation conventions, SDLC workflow
guidance, metadata rules, validators, generators, and reusable task skills to the
architecture-knowledge-toolkit.

Local repository evidence remains the source of truth. README prose, Dockerfile
instructions, workflow definitions, source code, tests, and reviewed
architecture records are evidence. AI-created architecture content is draft or
proposed until reviewed by the accountable owner.

For missing guidance, use the toolkit lookup order in `AGENTS.md`. Do not copy
the full toolkit rule set into this repository; keep this file as the local
semantic entry point and let the toolkit remain the maintained source.

Project-local facts currently supported by repository evidence:

- The product is a Docker image named `docs-toolbox`.
- The image supports reproducible Docs-as-Code pipelines locally and in CI.
- The Dockerfile uses `openjdk:22-jdk-slim`.
- The image installs Asciidoctor, Pandoc, Graphviz, unzip, curl, and Python 3.
- GitHub Actions builds and pushes multi-platform images to GHCR.
- Tags include a Dockerfile hash tag and, for Git-tagged commits, the Git tag and `latest`.
- The project is MIT licensed.

Architecture documentation in this repository is under `src/docs/` and follows
the toolkit metamodel. Generated files under `generated/` directories are
derived output and must not be edited manually.
