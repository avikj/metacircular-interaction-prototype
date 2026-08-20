#!/usr/bin/env bash
# Samvada — export Claude Code conversation threads, in full, to text files.
#
# saṃvāda (संवाद): "conversation, dialogue" — the record of an exchange between
# two parties, as used across the śāstric dialogue literature (the Upaniṣadic
# saṃvādas, e.g. Yājñavalkya–Gārgī, Bṛhadāraṇyaka Upaniṣad 3.6, 3.8). Nothing
# mathematical is claimed of the source; the term names the object (a recorded
# dialogue) per the file-naming rule in CLAUDE.md. The English half of the name
# is the gloss.
#
# WHAT IT DOES
#   Claude Code stores every session verbatim as newline-delimited JSON in
#     ~/.claude/projects/<slugified-cwd>/<session-uuid>.jsonl
#   This renders those into readable .txt (or .md) — every user turn, assistant
#   turn, thinking block, tool call with its full input, and tool result with
#   its full output, in order, with timestamps and a token-usage summary.
#
# QUICK USE
#   ./Samvada_ExportClaudeCodeThreadsToText.sh              # this project, all sessions
#   ./Samvada_ExportClaudeCodeThreadsToText.sh --all        # every project on this machine
#   ./Samvada_ExportClaudeCodeThreadsToText.sh --last       # just the most recent session
#   ./Samvada_ExportClaudeCodeThreadsToText.sh --list       # show sessions, export nothing
#   ./Samvada_ExportClaudeCodeThreadsToText.sh --all --combine --out ~/claude-export
#
# Dependencies: bash, jq. Nothing else. No Python (banned repo-wide).

set -uo pipefail

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PROJECTS_DIR="$CLAUDE_DIR/projects"

OUT_DIR="./claude-threads"
FORMAT="txt"
SCOPE="cwd"            # cwd | all | project
PROJECT_MATCH=""
ONLY_LAST=0
LIST_ONLY=0
COMBINE=0
WANT_THINKING=1
WANT_TOOLS=1
WANT_ATTACH=0
MAXCHARS=0             # 0 = no truncation ("in full")
SINCE=""
SESSION_MATCH=""
EXPLICIT_FILE=""

usage() {
  sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
  cat <<'EOF'

OPTIONS
  --out DIR            output directory            (default ./claude-threads)
  --format txt|md      output format               (default txt)
  --all                every project, not just the current directory
  --project PATH       only sessions whose cwd contains PATH
  --session SUBSTR     only sessions whose uuid contains SUBSTR
  --file PATH          render exactly this .jsonl transcript (skips all selection;
                       this is what a Stop hook passes as transcript_path)
  --last               only the single most recently modified session
  --since YYYY-MM-DD   only sessions modified on/after this date
  --list               list matching sessions and exit
  --combine            write one concatenated file instead of one per session
  --no-thinking        omit assistant thinking blocks
  --no-tools           omit tool calls and tool results
  --attachments        include attachment records (injected file contents,
                       system reminders, IDE context) verbatim
  --max-chars N        truncate any single block to N chars (default 0 = full)
  -h, --help           this text
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --out) OUT_DIR="$2"; shift 2;;
    --format) FORMAT="$2"; shift 2;;
    --all) SCOPE="all"; shift;;
    --project) SCOPE="project"; PROJECT_MATCH="$2"; shift 2;;
    --session) SESSION_MATCH="$2"; shift 2;;
    --file) EXPLICIT_FILE="$2"; shift 2;;
    --last) ONLY_LAST=1; shift;;
    --since) SINCE="$2"; shift 2;;
    --list) LIST_ONLY=1; shift;;
    --combine) COMBINE=1; shift;;
    --no-thinking) WANT_THINKING=0; shift;;
    --no-tools) WANT_TOOLS=0; shift;;
    --attachments) WANT_ATTACH=1; shift;;
    --max-chars) MAXCHARS="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2;;
  esac
done

command -v jq >/dev/null 2>&1 || { echo "samvada: jq is required (brew install jq / apt install jq)" >&2; exit 1; }
cwd_of() { grep -m1 -o '"cwd":"[^"]*"' "$1" 2>/dev/null | head -1 | cut -d'"' -f4; }

if [ -z "$EXPLICIT_FILE" ]; then
[ -d "$PROJECTS_DIR" ] || { echo "samvada: no transcripts at $PROJECTS_DIR" >&2; exit 1; }

# ---------------------------------------------------------------- selection --
# Match on the cwd recorded inside each transcript rather than on the directory
# slug, because the slug encoding is an implementation detail and has changed.

FILES=()
while IFS= read -r f; do FILES+=("$f"); done < <(find "$PROJECTS_DIR" -name '*.jsonl' -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null)
[ "${#FILES[@]}" -eq 0 ] && { echo "samvada: no .jsonl transcripts found under $PROJECTS_DIR" >&2; exit 1; }

HERE="$(pwd -P)"
SEL=()
for f in "${FILES[@]}"; do
  c="$(cwd_of "$f")"
  case "$SCOPE" in
    all) ;;
    cwd)     [ -n "$c" ] && [ "$c" != "$HERE" ] && continue
             [ -z "$c" ] && continue;;
    project) case "$c" in *"$PROJECT_MATCH"*) ;; *) continue;; esac;;
  esac
  [ -n "$SESSION_MATCH" ] && case "$(basename "$f")" in *"$SESSION_MATCH"*) ;; *) continue;; esac
  if [ -n "$SINCE" ]; then
    mt="$(date -u -r "$f" +%Y-%m-%d 2>/dev/null || stat -c %y "$f" 2>/dev/null | cut -d' ' -f1)"
    [ -n "$mt" ] && [ "$mt" \< "$SINCE" ] && continue
  fi
  SEL+=("$f")
done

[ "${#SEL[@]}" -eq 0 ] && {
  echo "samvada: no sessions matched." >&2
  echo "  cwd is $HERE ; try --all, or --project <path fragment>" >&2
  exit 1; }

[ "$ONLY_LAST" -eq 1 ] && SEL=("${SEL[0]}")

else
  # --file: render exactly this transcript. A Stop hook is handed the live
  # session's transcript_path; nothing else needs to be discovered.
  [ -f "$EXPLICIT_FILE" ] || { echo "samvada: no such transcript: $EXPLICIT_FILE" >&2; exit 1; }
  SEL=("$EXPLICIT_FILE")
fi

if [ "$LIST_ONLY" -eq 1 ]; then
  printf '%-38s %6s %8s  %-19s  %s\n' SESSION TURNS SIZE MODIFIED CWD
  for f in "${SEL[@]}"; do
    printf '%-38s %6s %8s  %-19s  %s\n' \
      "$(basename "$f" .jsonl)" \
      "$(grep '"type":"user"' "$f" 2>/dev/null | grep -vc '"tool_result"')" \
      "$(du -h "$f" | cut -f1)" \
      "$(date -r "$f" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$f" | cut -d. -f1)" \
      "$(cwd_of "$f")"
  done
  exit 0
fi

mkdir -p "$OUT_DIR" || exit 1
OUT_DIR="$(cd "$OUT_DIR" && pwd -P)"

# ------------------------------------------------------------------ renderer --
JQ_RENDER='
def clip:
  if ($MAX > 0) and (length > $MAX)
  then .[0:$MAX] + "\n    ... [TRUNCATED, " + ((length - $MAX)|tostring) + " more characters] ..."
  else . end;

def indentby($p): split("\n") | map($p + .) | join("\n");

def fmt_val:
  if type == "string" then
    (if test("\n") then "\n" + (clip | indentby("      ")) else clip end)
  elif type == "object" or type == "array" then
    ("\n" + (tojson | clip | indentby("      ")))
  else tojson end;

def fmt_input:
  if type == "object" then
    [ to_entries[] | "    " + .key + ": " + (.value | fmt_val) ] | join("\n")
  else (tojson | clip) end;

def result_text:
  if type == "string" then clip
  elif type == "array" then
    ( map( if .type == "text" then (.text // "")
           elif .type == "image" then "[image: " + (.source.media_type // "?") + "]"
           else tojson end ) | join("\n") | clip )
  elif type == "null" then ""
  else (tojson | clip) end;

def blocks:
  (.message.content) as $c |
  if ($c | type) == "string" then [{type:"text", text:$c}]
  elif ($c | type) == "array" then $c
  else [] end;

def render_block:
  .type as $t |
  if $t == "text" then ((.text // "") | clip)
  elif $t == "thinking" then
    (if $THINK != 1 then empty
     elif ((.thinking // "") | length) == 0
     then "[thinking: recorded by the client but its text is not stored in this transcript]"
     else "[thinking]\n" + (.thinking | clip | indentby("  ")) end)
  elif $t == "redacted_thinking" then
    (if $THINK == 1 then "[thinking: redacted]" else empty end)
  elif $t == "tool_use" then
    (if $TOOLS == 1 then
       "[TOOL CALL] " + (.name // "?") + "   (id " + (.id // "?") + ")\n" + (.input | fmt_input)
     else empty end)
  elif $t == "server_tool_use" then
    (if $TOOLS == 1 then "[SERVER TOOL CALL] " + (.name // "?") + "\n" + (.input | fmt_input) else empty end)
  elif $t == "tool_result" then
    (if $TOOLS == 1 then
       "[TOOL RESULT]" + (if .is_error then "  *** ERROR ***" else "" end)
       + "   (for " + (.tool_use_id // "?") + ")\n"
       + ((.content | result_text) | indentby("  "))
     else empty end)
  elif $t == "image" then "[image: " + (.source.media_type // "?") + "]"
  elif $t == "document" then "[document attached]"
  else ("[" + $t + "]\n" + (tojson | clip)) end;

def who:
  (if .isSidechain == true then "SUBAGENT " else "" end) +
  (if .type == "assistant" then "ASSISTANT"
   elif .type == "system" then "SYSTEM"
   elif .type == "attachment" then "ATTACHMENT"
   elif (.isMeta == true) then "USER (meta)"
   else "USER" end);

def stamp: (.timestamp // "");

def header:
  "\n" + ("-" * 78) + "\n### " + who + "   " + stamp +
  (if .message.model then "   [" + .message.model + "]" else "" end) + "\n";

if .type == "summary" then
  ("\n[thread summary] " + (.summary // ""))
elif .type == "system" then
  (if $TOOLS == 1 then header + ((.content // .toolUseResult // "" | tostring) | clip) else empty end)
elif .type == "attachment" then
  (if $ATTACH == 1 then header + ((.attachment | tojson) | clip | indentby("  ")) else empty end)
elif .type == "user" or .type == "assistant" then
  ( [ blocks[] | render_block ] | map(select(. != null and . != "")) ) as $bs |
  (if ($bs | length) == 0 then empty else header + ($bs | join("\n\n")) end)
else empty end
'

render_one() {
  local f="$1"
  local sid cwd branch first last turns
  sid="$(basename "$f" .jsonl)"
  cwd="$(cwd_of "$f")"
  branch="$(grep -m1 -o '"gitBranch":"[^"]*"' "$f" | head -1 | cut -d'"' -f4)"
  first="$(grep -m1 -o '"timestamp":"[^"]*"' "$f" | head -1 | cut -d'"' -f4)"
  last="$(grep -o '"timestamp":"[^"]*"' "$f" | tail -1 | cut -d'"' -f4)"
  turns="$(grep '"type":"user"' "$f" | grep -vc '"tool_result"')"

  local usage
  usage="$(jq -r 'select(.message.usage != null) | .message.usage
                  | [ (.input_tokens//0), (.output_tokens//0),
                      (.cache_read_input_tokens//0), (.cache_creation_input_tokens//0) ]
                  | @tsv' "$f" 2>/dev/null |
    awk -F'\t' '{i+=$1;o+=$2;cr+=$3;cw+=$4;n++}
                END{ if(n=="") n=0;
                     printf "requests %d | input %d | output %d | cache read %d | cache write %d", n,i,o,cr,cw }')"

  echo "================================================================================"
  echo "CLAUDE CODE THREAD  $sid"
  echo "================================================================================"
  echo "project     : ${cwd:-unknown}"
  echo "git branch  : ${branch:-unknown}"
  echo "started     : ${first:-unknown}"
  echo "ended       : ${last:-unknown}"
  echo "user turns  : ${turns}"
  echo "tokens      : ${usage:-n/a}"
  echo "source      : $f"
  echo "exported    : $(date -u '+%Y-%m-%dT%H:%M:%SZ') by Samvada"
  echo "================================================================================"

  jq -r --argjson THINK "$WANT_THINKING" \
        --argjson TOOLS "$WANT_TOOLS" \
        --argjson ATTACH "$WANT_ATTACH" \
        --argjson MAX "$MAXCHARS" \
        "$JQ_RENDER" "$f" 2>/dev/null

  echo
  echo "================================================================================"
  echo "END OF THREAD $sid"
  echo "================================================================================"
  echo
}

# --------------------------------------------------------------------- write --
if [ "$COMBINE" -eq 1 ]; then
  target="$OUT_DIR/claude-threads-$(date -u '+%Y%m%dT%H%M%SZ').$FORMAT"
  : > "$target"
  for f in "${SEL[@]}"; do render_one "$f" >> "$target"; done
  echo "wrote $target  ($(du -h "$target" | cut -f1), ${#SEL[@]} threads)"
else
  for f in "${SEL[@]}"; do
    sid="$(basename "$f" .jsonl)"
    stampname="$(date -r "$f" '+%Y%m%d-%H%M%S' 2>/dev/null || echo undated)"
    target="$OUT_DIR/${stampname}_${sid}.$FORMAT"
    render_one "$f" > "$target"
    echo "wrote $target  ($(du -h "$target" | cut -f1))"
  done
  echo "-- ${#SEL[@]} thread(s) into $OUT_DIR"
fi
