#!/bin/bash
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
ROOT="${MATH_COLLAB_ROOT:-$DEFAULT_ROOT}"
CONFIG="${MATH_COLLAB_CONFIG:-$ROOT/collab/daemon/madhavi/config.local}"
RUNTIME="${MATH_COLLAB_RUNTIME:-$ROOT/collab/daemon/madhavi/runtime}"
LOG="$RUNTIME/watchdog.log"
LOCK="$RUNTIME/watchdog-lock"

mkdir -p "$RUNTIME"
stamp() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
log() { printf '%s\t%s\n' "$(stamp)" "$*" >> "$LOG"; }

if ! mkdir "$LOCK" 2>/dev/null; then
  log "exit: watchdog already running"
  exit 0
fi
cleanup() {
  for pid in $(jobs -pr); do
    pkill -TERM -P "$pid" 2>/dev/null || true
    kill -TERM "$pid" 2>/dev/null || true
  done
  rmdir "$LOCK" 2>/dev/null || true
}
trap cleanup EXIT INT TERM HUP

CODEX_SESSION_ID=""
CLAUDE_SESSION_ID=""
CODEX_SESSION_RECORD=""
CLAUDE_SESSION_RECORD=""
CODEX_BIN="/opt/homebrew/bin/codex"
CLAUDE_BIN="/Users/avikjain/.local/bin/claude"
CODEX_CONTINUE_PROMPT="Continue."
CLAUDE_CONTINUE_PROMPT="Continue."
CODEX_RESUME_ARGS=(--json -s workspace-write -a never)
CLAUDE_RESUME_ARGS=(-p --output-format text --permission-mode acceptEdits)
RESTART_DELAY_SECONDS=2
if [ -f "$CONFIG" ]; then
  # Trusted machine-local configuration.
  # shellcheck source=/dev/null
  . "$CONFIG"
fi

cd "$ROOT" || exit 1

session_from_record() {
  record="$1"
  [ -n "$record" ] || return 0
  case "$record" in /*) path="$record";; *) path="$ROOT/$record";; esac
  [ -f "$path" ] || { log "session record missing: $path"; return 0; }
  # Session records are flat JSON objects. Extract the quoted id without
  # reviving the retired Python substrate.
  sed -nE 's/.*"session_id"[[:space:]]*:[[:space:]]*"([^"[:space:]]+)".*/\1/p' "$path" | head -1
}

if [ -z "$CODEX_SESSION_ID" ]; then CODEX_SESSION_ID="$(session_from_record "$CODEX_SESSION_RECORD")"; fi
if [ -z "$CLAUDE_SESSION_ID" ]; then CLAUDE_SESSION_ID="$(session_from_record "$CLAUDE_SESSION_RECORD")"; fi

codex_loop() {
  if [ -z "$CODEX_SESSION_ID" ]; then
    log "codex disabled: CODEX_SESSION_ID is empty"
    return
  fi
  [ -x "$CODEX_BIN" ] || { log "codex disabled: CLI not executable: $CODEX_BIN"; return; }
  while :; do
    started="$(stamp)"
    log "codex resume: $CODEX_SESSION_ID"
    "$CODEX_BIN" exec resume "${CODEX_RESUME_ARGS[@]}" "$CODEX_SESSION_ID" \
      "$CODEX_CONTINUE_PROMPT" >> "$RUNTIME/codex.stream.jsonl" 2>> "$RUNTIME/codex.stderr.log"
    rc=$?
    log "codex exited rc=$rc started=$started; resuming same session"
    sleep "$RESTART_DELAY_SECONDS"
  done
}

claude_loop() {
  if [ -z "$CLAUDE_SESSION_ID" ]; then
    log "claude disabled: CLAUDE_SESSION_ID is empty"
    return
  fi
  [ -x "$CLAUDE_BIN" ] || { log "claude disabled: CLI not executable: $CLAUDE_BIN"; return; }
  while :; do
    started="$(stamp)"
    log "claude resume: $CLAUDE_SESSION_ID"
    "$CLAUDE_BIN" "${CLAUDE_RESUME_ARGS[@]}" --resume "$CLAUDE_SESSION_ID" \
      "$CLAUDE_CONTINUE_PROMPT" >> "$RUNTIME/claude.stream.jsonl" 2>> "$RUNTIME/claude.stderr.log"
    rc=$?
    log "claude exited rc=$rc started=$started; resuming same session"
    sleep "$RESTART_DELAY_SECONDS"
  done
}

codex_loop &
codex_pid=$!
claude_loop &
claude_pid=$!
log "watchdog active codex_loop=$codex_pid claude_loop=$claude_pid"

# Portable to macOS's system Bash (which has no `wait -n`). Provider loops
# restart their own CLI forever; waiting for both keeps the supervisor alive.
wait "$codex_pid" 2>/dev/null || true
wait "$claude_pid" 2>/dev/null || true
log "no provider loop remains"
