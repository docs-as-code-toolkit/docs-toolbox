#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
DTCW_DIR="$SCRIPT_DIR/.dtcw"
DTCW="$DTCW_DIR/dtcw"
CONFIG_FILE="showcase/doctoolchain/Config.groovy"
CONTAINER_DOC_DIR="/project"

usage() {
  cat <<'USAGE'
Usage: ./showcase/doctoolchain/build.sh [html|pdf|all|validate|clean] [local|docker]

Commands:
  all       Validate/generate toolkit fragments, then render HTML and PDF.
  html      Validate/generate toolkit fragments, then render HTML.
  pdf       Validate/generate toolkit fragments, then render PDF.
  validate  Validate metadata and regenerate derived architecture fragments.
  clean     Remove showcase build output.

Environments:
  local     Use dtcw local installation in $HOME/.doctoolchain.
  docker    Use dtcw docker mode with Docker or a Podman shim.

Default: all local
USAGE
}

ensure_dtcw() {
  mkdir -p "$DTCW_DIR"

  if [ ! -x "$DTCW" ]; then
    echo "Downloading docToolchain wrapper to $DTCW"
    curl -fsSL -o "$DTCW" https://doctoolchain.org/dtcw
    chmod +x "$DTCW"
  fi
}

prepare_podman_shim() {
  if command -v docker >/dev/null 2>&1; then
    return 0
  fi

  if command -v podman >/dev/null 2>&1; then
    SHIM_DIR="$DTCW_DIR/bin"
    mkdir -p "$SHIM_DIR"
    cat > "$SHIM_DIR/docker" <<'SHIM'
#!/usr/bin/env sh
exec podman "$@"
SHIM
    chmod +x "$SHIM_DIR/docker"
    PATH="$SHIM_DIR:$PATH"
    export PATH
    return 0
  fi

  echo "Neither docker nor podman was found on PATH." >&2
  exit 1
}

run_validate() {
  cd "$REPO_ROOT"
  ruby scripts/validate-metamodel.rb --generate
}

run_dtcw() {
  TASK="$1"
  ENVIRONMENT="$2"
  ensure_dtcw

  cd "$REPO_ROOT"

  case "$ENVIRONMENT" in
    local)
      "$DTCW" local install doctoolchain
      DTC_OPTS="${DTC_OPTS:-} -Dorg.gradle.jvmargs=-Xmx1024m -Dorg.gradle.workers.max=1" \
        DTC_CONFIG_FILE="$CONFIG_FILE" \
        "$DTCW" local "$TASK" -PdocDir="$REPO_ROOT"
      ;;
    docker)
      prepare_podman_shim
      DTC_OPTS="${DTC_OPTS:-} -Dorg.gradle.jvmargs=-Xmx1024m -Dorg.gradle.workers.max=1" \
        DTC_CONFIG_FILE="$CONFIG_FILE" \
        "$DTCW" docker "$TASK" -PdocDir="$CONTAINER_DOC_DIR"
      ;;
    *)
      usage
      exit 2
      ;;
  esac
}

clean() {
  cd "$REPO_ROOT"
  rm -rf build/showcase/doctoolchain
  echo "Removed build/showcase/doctoolchain"
}

COMMAND="${1:-all}"
ENVIRONMENT="${2:-local}"

case "$COMMAND" in
  all)
    run_validate
    run_dtcw generateHTML "$ENVIRONMENT"
    run_dtcw generatePDF "$ENVIRONMENT"
    ;;
  html)
    run_validate
    run_dtcw generateHTML "$ENVIRONMENT"
    ;;
  pdf)
    run_validate
    run_dtcw generatePDF "$ENVIRONMENT"
    ;;
  validate)
    run_validate
    ;;
  clean)
    clean
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage
    exit 2
    ;;
esac
