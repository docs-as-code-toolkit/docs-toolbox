# AsciiDoc Reveal.js Presentation Example

This example shows how to build a Reveal.js presentation from AsciiDoc with the
`docs-toolbox` Docker image.

## Build

Run the command from the repository root:

```bash
docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  asciidoctor-revealjs \
    -r asciidoctor-diagram \
    -a revealjsdir=https://cdn.jsdelivr.net/npm/reveal.js@4.5.0 \
    -D examples/presentations/asciidoc/build \
    examples/presentations/asciidoc/slides.adoc
```

The generated presentation is written to:

```text
examples/presentations/asciidoc/build/slides.html
```

## Including Project Sources

AsciiDoc presentations can reuse fragments from other repository files with
`include::`. This example includes the Level 1 PlantUML diagram from the
architecture documentation:

```asciidoc
include::../../../src/docs/arc42/05-building-block-view/doc-05001-level-1.adoc[tag=docs-toolbox-level-1-diagram]
```

The included source file marks the reusable block with AsciiDoc tag comments:

```asciidoc
// tag::docs-toolbox-level-1-diagram[]
[plantuml, docs-toolbox-building-blocks, svg]
----
...
----
// end::docs-toolbox-level-1-diagram[]
```

This keeps diagrams and other snippets in one source of truth while still making
them available for slides. Include paths are resolved from the source document,
so the path above is relative to `slides.adoc`.

## Offline Reveal.js Assets

The example uses the Reveal.js CDN for a small and portable demo. For offline or
customized slide decks, vendor Reveal.js in your project and set `revealjsdir`
to that local path.

One practical project-local pattern is to download an official Reveal.js release
into the project and reference it from the generated presentation:

```bash
mkdir -p examples/presentations/asciidoc/vendor
curl -L https://github.com/hakimel/reveal.js/archive/refs/tags/5.2.1.tar.gz \
  | tar -xz -C examples/presentations/asciidoc/vendor
mv examples/presentations/asciidoc/vendor/reveal.js-5.2.1 \
  examples/presentations/asciidoc/vendor/reveal.js
```

Then build with the local asset path:

```bash
docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  asciidoctor-revealjs \
    -r asciidoctor-diagram \
    -a revealjsdir=../vendor/reveal.js \
    -D examples/presentations/asciidoc/build \
    examples/presentations/asciidoc/slides.adoc
```

This keeps the toolbox responsible for rendering and the consuming project
responsible for the browser assets and their version. The `revealjsdir` value is
relative to the generated `slides.html` file, not to the source `slides.adoc`.

## Speaker Notes And Other Reveal.js Features

The generated HTML is static, but it can still use Reveal.js runtime features
such as fragments, slide numbers, themes, keyboard navigation, PDF export, and
speaker notes.

Speaker notes can be written in AsciiDoc with a notes block:

```asciidoc
[.notes]
--
Private notes for the presenter.
--
```

Reveal.js opens the speaker view with the `S` key. When opening the generated
HTML directly via `file://`, the normal slides may work, but the speaker view can
be restricted by the browser. Serve the example directory with a local web server
from the toolbox image instead:

```bash
docker run --rm \
  -p 8000:8000 \
  -v "$(pwd)":/workspace \
  -w /workspace \
  ghcr.io/docs-as-code-toolkit/docs-toolbox:latest \
  docs-toolbox-serve examples/presentations/asciidoc 8000
```

Then open:

```text
http://localhost:8000/build/slides.html
```
