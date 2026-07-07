#!/usr/bin/env sh
set -eu

COMMAND="${1:-build}"
IMAGE_REPOSITORY="${DOCS_TOOLBOX_IMAGE_REPOSITORY:-ghcr.io/docs-as-code-toolkit/docs-toolbox}"
BUILD_DIR="${BUILD_DIR:-build/architecture}"
SOURCE_DOC="${SOURCE_DOC:-src/docs/doc-001-arc42.adoc}"

usage() {
  cat <<'USAGE'
Usage: ./build.sh [build|validate|clean]

Commands:
  build      Validate, generate architecture fragments, and render HTML.
  validate   Validate and generate architecture documentation metadata.
  clean      Remove local architecture build output.

The script prefers a published docs-toolbox image tagged with the local
Dockerfile hash (df-<hash>). If that image is not available, it builds a local
image from the current Dockerfile so local Dockerfile changes are used.
USAGE
}

find_engine() {
  if command -v podman >/dev/null 2>&1; then
    printf '%s\n' "podman"
  elif command -v docker >/dev/null 2>&1; then
    printf '%s\n' "docker"
  else
    printf '%s\n' ""
  fi
}

dockerfile_hash() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum Dockerfile | awk '{print $1}' | cut -c1-12
  else
    shasum -a 256 Dockerfile | awk '{print $1}' | cut -c1-12
  fi
}

run_validate() {
  ruby scripts/validate-metamodel.rb --generate
}

run_build() {
  run_validate
  mkdir -p "$BUILD_DIR"
  asciidoctor \
    -r asciidoctor-diagram \
    -r asciidoctor-diagram/plantuml \
    --failure-level=ERROR \
    -a skip-front-matter \
    -a imagesdir=. \
    -a imagesoutdir="$BUILD_DIR" \
    -D "$BUILD_DIR" \
    -o index.html \
    "$SOURCE_DOC"
  echo "Built architecture HTML: $BUILD_DIR/index.html"
}

run_local() {
  case "$COMMAND" in
    build)
      run_build
      ;;
    validate)
      run_validate
      ;;
    clean)
      rm -rf "$BUILD_DIR"
      echo "Removed $BUILD_DIR"
      ;;
    help|-h|--help)
      usage
      ;;
    *)
      usage
      exit 2
      ;;
  esac
}

run_in_container() {
  ENGINE="$1"
  HASH="$(dockerfile_hash)"
  REMOTE_IMAGE="${IMAGE_REPOSITORY}:df-${HASH}"
  LOCAL_IMAGE="docs-toolbox-local:df-${HASH}"

  echo "Dockerfile hash tag: df-${HASH}"
  echo "Trying runtime image: ${REMOTE_IMAGE}"

  if "$ENGINE" pull "$REMOTE_IMAGE"; then
    IMAGE="$REMOTE_IMAGE"
    echo "Using published runtime image: $IMAGE"
  else
    echo "Published image for local Dockerfile hash not found. Building local runtime image."
    "$ENGINE" build -t "$LOCAL_IMAGE" .
    IMAGE="$LOCAL_IMAGE"
  fi

  "$ENGINE" run --rm \
    -e DOCS_TOOLBOX_IN_CONTAINER=1 \
    -e BUILD_DIR="$BUILD_DIR" \
    -e SOURCE_DOC="$SOURCE_DOC" \
    -v "$PWD":/app \
    -w /app \
    "$IMAGE" \
    sh ./build.sh "$COMMAND"
}

if [ "${DOCS_TOOLBOX_IN_CONTAINER:-}" = "1" ]; then
  run_local
  exit 0
fi

case "$COMMAND" in
  build|validate)
    ENGINE="$(find_engine)"
    if [ -n "$ENGINE" ]; then
      run_in_container "$ENGINE"
    else
      echo "No container engine found. Running locally."
      run_local
    fi
    ;;
  clean|help|-h|--help)
    run_local
    ;;
  *)
    usage
    exit 2
    ;;
esac
