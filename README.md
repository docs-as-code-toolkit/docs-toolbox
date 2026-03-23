# 🧰 docs-toolbox

![Docker](https://img.shields.io/badge/Docker-ready-blue)

A lightweight Docker image for running **Docs-as-Code pipelines** in a
**fully reproducible environment** — locally and in CI.

Stop installing random tools locally.  
Stop breaking your CI builds.  
Just use the same environment everywhere.

Unlike ad-hoc setups, this image is designed to be **the single source of truth for your documentation toolchain**.

## 🧠 What this enables

- Reproducible documentation builds across environments
- Zero-setup onboarding for contributors
- Consistent toolchain in local and CI workflows

---

## ✨ What’s inside?

This image provides a ready-to-use toolchain for **Docs-as-Code pipelines**:

- Asciidoctor
- Pandoc
- Graphviz
- Fonts & PDF tooling
- Common CLI utilities

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

### Run a build

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/dieterbaier/docs-toolbox:latest \
  ./gradlew build
```

> 💡 On Windows, replace `$(pwd)` with the appropriate path syntax.

### Use in scripts

```bash
./build.sh buildSite
```
(assuming your project wraps the container execution)

### GitHub Actions

```yaml
jobs:
  docs:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/dieterbaier/docs-toolbox:latest

    steps:
      - uses: actions/checkout@v4
      - run: ./gradlew build
```

## 🧩 Typical Use Cases
- 📄 Generate HTML / PDF / Markdown from AsciiDoc
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
- latest → most recent stable toolchain
- version tags → reproducible builds

👉 Pin versions in CI for full determinism.

## 🛠️ Customization
If you need additional tools:
- Extend this image via your own Dockerfile
- Or fork and adapt it to your pipeline

## 🌐 Related Project
This image powers the following real-world project:

👉 https://github.com/dieterbaier/profile

A real-world example of a Docs-as-Code pipeline for personal branding.

## 📄 License

This project is licensed under the [MIT](./LICENSE) License.