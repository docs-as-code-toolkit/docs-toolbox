# Project Agent Instructions

This project uses architecture-knowledge-toolkit for architecture work and
software-development-lifecycle tasks that are not described more specifically in
this repository.

Apply instructions in this order:

1. User instruction
2. This project `AGENTS.md`
3. Relevant toolkit skill or contract
4. Toolkit `general-semantic-contracts.md`

Use the toolkit for product clarification, arc42 documentation, ADRs, quality
scenarios, risks and technical debt, runtime scenarios, traceability metadata,
templates, validators, generated include fragments, issue slicing, issue
implementation workflow, commit messages, pull request reviews, post-merge
synchronization, and traceability reviews.

Toolkit source of truth:

https://github.com/docs-as-code-toolkit/architecture-knowledge-toolkit

Preferred local lookup order:

1. `$ARCHITECTURE_KNOWLEDGE_TOOLKIT`
2. `../architecture-knowledge-toolkit`
3. project-local recorded toolkit reference, submodule, vendored copy, or pinned path
4. the public repository above, preferably at a stable release tag or commit SHA

Before architecture or SDLC workflow work:

- inspect existing `src/docs/`, `metamodel/`, `templates/`, `scripts/`, and `skills/`
- verify referenced toolkit skill paths before copying or linking them
- preserve stable artifact IDs
- use AsciiDoc as the default architecture documentation format
- mark AI-created or AI-modified architecture content as `draft` or `proposed`
- set `reviewed: false` unless human acceptance is already recorded
- do not manually maintain generated fragments when a generator exists
- copy missing toolkit templates, schemas, validators, and generator scripts from the toolkit instead of inventing alternatives
