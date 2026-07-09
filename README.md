# 🧰 docs-toolbox


![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Docker](https://img.shields.io/badge/Docker-ready-blue)
![Docs-as-Code](https://img.shields.io/badge/Docs--as--Code-Toolkit-blue)
> ![docs-as-code-toolkit-logo](https://docs-as-code-toolkit.github.io/docs-as-code/assets/logo/toolkit-logo_160.png)
>
> Part of the **Docs-as-Code Toolkit**  
> → [https://github.com/docs-as-code-toolkit](https://github.com/docs-as-code-toolkit)

<!-- image-description:start -->
A lightweight Docker image for running Docs-as-Code pipelines in a fully reproducible environment — locally and in CI.
<!-- image-description:end -->

Stop installing random tools locally.  
Stop breaking your CI builds.  
Just use the same environment everywhere.

Unlike ad-hoc setups, this image is designed to be **the single source of truth for your documentation toolchain**.

In the wider Docs-as-Code Toolkit, `docs-toolbox` is the reproducible rendering
runtime. It complements [docToolchain](https://github.com/docToolchain) and
similar publishing tools rather than competing with them: higher-level projects
can structure architecture knowledge one layer above publishing, then use this
image locally or in CI to render the derived documentation.

## 🧠 What this enables

- Reproducible documentation builds across environments
- Zero-setup onboarding for contributors
- Consistent toolchain in local and CI workflows
- Diagram rendering without project-specific host setup
- Reveal.js presentation builds from AsciiDoc sources
- Direct Asciidoctor CLI builds and Gradle/AsciidoctorJ builds in the same runtime
- A toolbox layer for projects that publish with direct Asciidoctor/Pandoc,
  Gradle/AsciidoctorJ, docToolchain, or similar pipelines

---

## ✨ What’s inside?

This image provides a ready-to-use toolchain for **Docs-as-Code pipelines**:

- Asciidoctor
- Asciidoctor Diagram with PlantUML support
- Asciidoctor reveal.js converter
- Pandoc
- Graphviz
- Common CLI utilities
- Static web server command for previewing generated sites and presentations
- Java runtime support for Gradle/AsciidoctorJ-based documentation builds

👉 Everything preconfigured to work together.

---

## 🎯 Why this exists

Documentation pipelines often suffer from:

- ❌ "Works on my machine"
- ❌ Different tool versions locally vs CI
- ❌ Painful setup for new contributors
- ❌ Hidden dependencies

This image solves that by providing:

> A **consistent, versioned, reproducible environment** for documentation builds.

---

## 🚀 Usage

### Run a command

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  asciidoctor -v
```

> 💡 On Windows, replace `$(pwd)` with the appropriate path syntax.

### Render AsciiDoc with diagrams

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  asciidoctor \
    -r asciidoctor-diagram \
    -r asciidoctor-diagram/plantuml \
    --failure-level=ERROR \
    docs/index.adoc
```

### Render reveal.js presentations

The image includes the Ruby `asciidoctor-revealjs` CLI. Point `revealjsdir` at a
CDN or at project-provided Reveal.js assets:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  asciidoctor-revealjs \
    -a revealjsdir=https://cdn.jsdelivr.net/npm/reveal.js@4.5.0 \
    docs/slides.adoc
```

For offline or customized slide decks, vendor Reveal.js in the project and set
`revealjsdir` to that local path.

Serve generated presentations through the toolbox image when browser features
such as Reveal.js speaker notes should run from `http://localhost` instead of
`file://`:

```bash
docker run --rm \
  -p 8000:8000 \
  -v "$(pwd)":/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  docs-toolbox-serve docs 8000
```

Then open the generated slide deck below `http://localhost:8000/`, for example
`http://localhost:8000/slides.html` when the presentation was written to
`docs/slides.html`.

A complete example presentation is available in
[`examples/presentations/asciidoc`](examples/presentations/asciidoc). It shows
how to build Reveal.js slides from AsciiDoc with the toolbox image, including a
small diagram rendered through Asciidoctor Diagram.

### docToolchain showcase

This repository also contains a runnable
[`showcase/doctoolchain`](showcase/doctoolchain) example. It verifies that
docToolchain can render the repository's architecture sources, which are
structured with the sibling
[`architecture-knowledge-toolkit`](https://github.com/docs-as-code-toolkit/architecture-knowledge-toolkit).

The showcase validates toolkit metadata, regenerates derived include and
traceability fragments, and then renders the assembled architecture
documentation to HTML and PDF with `dtcw`.

```bash
./showcase/doctoolchain/build.sh
```

The default path uses a local docToolchain installation managed by `dtcw`.
Container execution is available as an alternative:

```bash
./showcase/doctoolchain/build.sh all docker
```

### Use with Gradle / AsciidoctorJ

The image includes a Java runtime, so projects can run Gradle builds that use
AsciidoctorJ and its diagram module:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  ./gradlew --no-daemon build
```

### Use in scripts (example)

```bash
./build.sh <some action>
```
(assuming your project wraps the container execution)

This repository's own `build.sh` validates the toolkit metadata, generates
derived architecture fragments, and renders the assembled architecture HTML.
It first looks for a published `df-<Dockerfile-hash>` image and builds a local
image from the current Dockerfile if that exact image does not exist.

```bash
./build.sh build
```

### GitHub Actions (example)

```yaml
jobs:
  docs:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/docs-as-code-toolkit/docs-toolbox:latest

    steps:
      - uses: actions/checkout@v4
      - run: ./gradlew build
```

## 🧩 Typical Use Cases
- 📄 Generate HTML / PDF / Markdown from AsciiDoc
- 🖼️ Render PlantUML diagrams from AsciiDoc
- 🎞️ Build Reveal.js presentations from AsciiDoc
- 🧱 Docs-as-Code pipelines
- 📦 CI/CD documentation builds
- 👥 Onboarding without local setup

## 📐 Philosophy
This image follows a few simple principles:
- 🔁 Reproducibility over convenience
- 📦 Everything included, nothing assumed
- ⚙️ Same environment locally and in CI
- 🧼 No hidden magic

## 🔄 Versioning
- `latest` → most recent tagged stable toolbox image
- version tags → reproducible release builds
- `df-<hash>` → image built from a Dockerfile with that SHA-256 hash prefix

👉 Pin versions in CI for full determinism.

The `df-<hash>` tag is useful for local wrappers: compute the hash of the local
Dockerfile, try to pull that image, and build locally when the image is not yet
published.

## 🏗️ Architecture Documentation

This repository contains toolkit-compatible architecture documentation under
`src/docs/`.

The architecture documentation is dogfooded: it is generated with this
project's own toolbox image. `build.sh` computes the local Dockerfile hash,
uses the matching published `df-<hash>` image when available, and otherwise
builds the current Dockerfile locally before rendering the documentation.

Build it locally with:

```bash
./build.sh build
```

The output is written to:

```text
build/architecture/index.html
```

Pull requests validate the architecture metadata. Builds on `main` generate the
architecture HTML and publish it through GitHub Pages.

Expected GitHub Pages URL after the first successful deployment:

👉 https://docs-as-code-toolkit.github.io/docs-toolbox/

## 🛠️ Customization
If you need additional tools:
- Extend this image via your own Dockerfile
- Or fork and adapt it to your pipeline

## 🌐 Related Project
This image powers the following real-world project:

👉 https://github.com/dieterbaier/profile

A real-world example of a Docs-as-Code pipeline for personal branding.

## 📄 License

This project is licensed under the [MIT](./LICENSE.md) License.
