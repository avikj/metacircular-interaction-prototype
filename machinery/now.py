"""Fail-closed validator and cost recomputation for the live session board.

The board is the marked section of `README.md` between `<!-- BOARD:BEGIN -->`
and `<!-- BOARD:END -->`.  It was `NOW.md` until 2026-08-13, when the human
owner directed that the surfaced state belong at the front door; this module
was retargeted by `opus-shesha`, mechanism unchanged and authored by
`opus-samhita`.

The board is bounded on purpose.  This module is what keeps it bounded: it is a
validator plus a measurement that recomputes itself, not a generator.  Nothing
here authors content and nothing here promotes anything.

    python3 machinery/now.py validate   # CI gate: bounds + schema, fail-closed
    python3 machinery/now.py stale      # blocks past the 24 h PROTOCOL clock
    python3 machinery/now.py cost       # recompute the orientation-path bytes

Design boundary, stated because this repository has an explicit rule against
building another dashboard (`FAILURES.md` F24): `NOW.md` derives nothing that
`collab/STATE.md` asserts, stores no mathematical claim, and has no authority.
It carries what a ledger structurally cannot -- who is awake and what they are
holding -- and it is capped so that reading it is never a budget decision.
"""

from __future__ import annotations

import argparse
import datetime as dt
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOARD_FILE = ROOT / "README.md"
BOARD_BEGIN = "<!-- BOARD:BEGIN -->"
BOARD_END = "<!-- BOARD:END -->"

MAX_BYTES = 8000
MAX_BLOCKS = 12
MAX_BLOCK_LINES = 14
STALE_HOURS = 24  # PROTOCOL section 2's own takeover clock

REQUIRED_FIELDS = ("heartbeat", "holding", "journal")
HEADING = re.compile(r"^## (?P<handle>\S+) — (?P<lineage>.+?) — (?P<origin>authored|derived)\s*$")
FIELD = re.compile(r"^- (?P<key>[a-z]+):\s*(?P<value>.*)$")

# The onboard skill's Step 1 mandatory reading path, in its stated order.
ONBOARD_PATH = (
    "notes/COGNITIVE_ORIENTATION.md",
    "README.md",
    "notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md",
    "notes/RESEARCH_SYSTEM.md",
    "collab/PROTOCOL.md",
    "collab/STATE.md",
    "notes/FOREST.md",
    "notes/DIRECT.md",
    "collab/FAILURES.md",
)


class Block:
    def __init__(self, handle: str, lineage: str, origin: str, line_no: int):
        self.handle = handle
        self.lineage = lineage
        self.origin = origin
        self.line_no = line_no
        self.fields: dict[str, str] = {}
        self.lines = 0

    @property
    def heartbeat(self) -> dt.datetime | None:
        raw = self.fields.get("heartbeat", "")
        for fmt in ("%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%dT%H:%MZ"):
            try:
                return dt.datetime.strptime(raw, fmt).replace(tzinfo=dt.timezone.utc)
            except ValueError:
                continue
        return None


def board_text() -> str | None:
    """The marked board section, or None if the markers are missing/disordered.

    Parsing only between markers is what lets the rest of README.md carry
    ordinary prose without its headings being absorbed into someone's block.
    """
    if not BOARD_FILE.exists():
        return None
    text = BOARD_FILE.read_text(encoding="utf-8")
    start = text.find(BOARD_BEGIN)
    end = text.find(BOARD_END)
    if start < 0 or end < 0 or end < start:
        return None
    return text[start + len(BOARD_BEGIN) : end]


def parse(text: str) -> list[Block]:
    blocks: list[Block] = []
    current: Block | None = None
    for i, line in enumerate(text.splitlines(), start=1):
        heading = HEADING.match(line)
        if heading:
            current = Block(
                heading["handle"], heading["lineage"], heading["origin"], i
            )
            blocks.append(current)
            continue
        if line.startswith("### ") or line.startswith("# "):
            current = None
            continue
        if current is None:
            continue
        if line.strip():
            current.lines += 1
        field = FIELD.match(line)
        if field:
            current.fields[field["key"]] = field["value"].strip()
    return blocks


def validate() -> list[str]:
    errors: list[str] = []
    section = board_text()
    if section is None:
        return [
            f"missing board markers {BOARD_BEGIN} .. {BOARD_END} "
            f"in {BOARD_FILE.name}"
        ]

    if len(section.encode("utf-8")) > MAX_BYTES:
        errors.append(
            f"board is {len(section.encode('utf-8'))} bytes, cap is {MAX_BYTES}; "
            "archive a stale block instead of raising the cap"
        )

    blocks = parse(section)
    if len(blocks) > MAX_BLOCKS:
        errors.append(f"{len(blocks)} blocks, cap is {MAX_BLOCKS}")

    seen: set[str] = set()
    for block in blocks:
        where = f"{block.handle} (line {block.line_no})"
        if block.handle in seen:
            errors.append(f"{where}: duplicate handle")
        seen.add(block.handle)
        if block.lines > MAX_BLOCK_LINES:
            errors.append(
                f"{where}: {block.lines} lines, cap is {MAX_BLOCK_LINES}"
            )
        for field in REQUIRED_FIELDS:
            if field not in block.fields:
                errors.append(f"{where}: missing required field '{field}'")
        if "heartbeat" in block.fields and block.heartbeat is None:
            errors.append(
                f"{where}: heartbeat '{block.fields['heartbeat']}' is not "
                "ISO8601 UTC (YYYY-MM-DDThh:mm[:ss]Z)"
            )
        journal = block.fields.get("journal", "").strip("`")
        if journal and not (ROOT / journal).exists():
            errors.append(f"{where}: journal '{journal}' does not exist")
        if block.origin == "authored" and "wants" not in block.fields:
            errors.append(
                f"{where}: an authored block must state a 'wants' -- a return "
                "that would change your next action"
            )
    return errors


def stale(now: dt.datetime | None = None) -> list[tuple[str, float]]:
    now = now or dt.datetime.now(dt.timezone.utc)
    out: list[tuple[str, float]] = []
    section = board_text()
    if section is None:
        return out
    for block in parse(section):
        beat = block.heartbeat
        if beat is None:
            continue
        age = (now - beat).total_seconds() / 3600.0
        if age > STALE_HOURS:
            out.append((block.handle, age))
    return out


def cost() -> dict[str, int]:
    sizes = {p: (ROOT / p).stat().st_size for p in ONBOARD_PATH if (ROOT / p).exists()}
    notes = sorted((ROOT / "notes").glob("*.md"))
    messages = sorted((ROOT / "collab" / "messages").glob("*.md"))
    return {
        "onboard_step1_bytes": sum(sizes.values()),
        "state_bytes": sizes.get("collab/STATE.md", 0),
        "notes_files": len(notes),
        "notes_bytes": sum(p.stat().st_size for p in notes),
        "messages_files": len(messages),
        "messages_bytes": sum(p.stat().st_size for p in messages),
        "board_bytes": len((board_text() or "").encode("utf-8")),
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("command", choices=["validate", "stale", "cost"])
    args = ap.parse_args()

    if args.command == "validate":
        errors = validate()
        for e in errors:
            print(f"board: {e}", file=sys.stderr)
        if errors:
            return 1
        section = board_text() or ""
        blocks = parse(section)
        print(
            f"README.md board ok: {len(blocks)} blocks, "
            f"{len(section.encode('utf-8'))}/{MAX_BYTES} bytes"
        )
        return 0

    if args.command == "stale":
        rows = stale()
        if not rows:
            print("no stale blocks")
            return 0
        for handle, age in rows:
            print(f"{handle}: heartbeat {age:.1f} h old -- archive to collab/chronicle/")
        return 0

    numbers = cost()
    pct = (
        100 * numbers["state_bytes"] / numbers["onboard_step1_bytes"]
        if numbers["onboard_step1_bytes"]
        else 0
    )
    print(f"onboard Step 1 mandatory path : {numbers['onboard_step1_bytes']:>9,} bytes")
    print(f"  of which collab/STATE.md    : {numbers['state_bytes']:>9,} bytes ({pct:.0f}%)")
    print(f"notes/                        : {numbers['notes_bytes']:>9,} bytes "
          f"({numbers['notes_files']} files)")
    print(f"collab/messages/              : {numbers['messages_bytes']:>9,} bytes "
          f"({numbers['messages_files']} files)")
    print(f"README.md live board          : {numbers['board_bytes']:>9,} bytes "
          f"(cap {MAX_BYTES:,})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
