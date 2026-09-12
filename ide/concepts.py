#!/usr/bin/env python3
"""Build the concept join table from agda-unimath's published concept index.

Route honesty: every entry produced here is a NAME-NORMALIZED CANDIDATE
(kebab-case vs camelCase folding). It is a proposal for the kernel-checked
alignment, not the alignment. The client labels it so.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
RAW = HERE / "store" / "concepts_unimath.json"
OUT = HERE / "store" / "concepts.json"


def norm(s: str) -> str:
    s = re.sub(r"[-_' ]", "", s)
    return s.lower()


def main() -> int:
    entries = json.loads(RAW.read_text())
    table: dict[str, list[dict]] = {}
    for e in entries:
        ident = None
        link = e.get("link", "")
        m = re.search(r"#concept-(.+)$", link)
        if m:
            ident = m.group(1)
        card = {
            "name": e.get("name", ""),
            "text": e.get("text", ""),
            "wd": e.get("wikidata", ""),
            "page": "https://unimath.github.io/agda-unimath/" + link,
        }
        keys = set()
        if ident:
            keys.add(norm(ident))
        if e.get("text"):
            keys.add(norm(e["text"]))
        # concept name minus parenthetical
        base = re.sub(r"\(.*?\)", "", e.get("name", "")).strip()
        if base:
            keys.add(norm(base))
        for k in keys:
            if len(k) < 4:
                continue
            table.setdefault(k, [])
            if card not in table[k]:
                table[k].append(card)
    OUT.write_text(json.dumps(
        {"route": "name-normalized candidate (not kernel-checked)",
         "source": "agda-unimath concept_index.json (MIT)",
         "table": {k: v[:3] for k, v in table.items()}},
        ensure_ascii=False), encoding="utf-8")
    wd = sum(1 for vs in table.values() for v in vs if v["wd"])
    print(f"concept keys: {len(table)}  cards with wikidata: {wd}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
