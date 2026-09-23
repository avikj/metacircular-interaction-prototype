#!/usr/bin/env python3
"""Render the frozen Erdős Navigator SQLite corpus as exact Markdown."""
from pathlib import Path
import argparse
import os
import sqlite3

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "ERDOS_PROBLEMS_FULL.md"

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", type=Path, default=Path(os.environ.get("ERDOS_DB", "/private/tmp/erdos_problems.db")))
    args = parser.parse_args()
    db = sqlite3.connect(args.db)
    db.row_factory = sqlite3.Row
    rows = db.execute(
        "select * from problems order by cast(number as integer), number"
    ).fetchall()
    provenance = db.execute(
        "select source,url,as_of,synced_at,status,note from source_provenance"
    ).fetchall()
    lines = [
        "# Erdős problems: complete statement corpus",
        "",
        "This file is a verbatim rendering of the 1,217-record SQLite snapshot",
        "`/private/tmp/erdos_problems.db` from Erdős Navigator. The snapshot",
        "contains 1,179 statement texts; records 1180–1217 have metadata but no",
        "statement text in that frozen source. Statements and supplementary text",
        "are preserved exactly as stored, including TeX and HTML `<br>` markers.",
        "",
        "The statement source is the Erdős Problems site snapshot (as of",
        "2026-02-01 in the database provenance table). Status, prize, tags, OEIS,",
        "and formalization metadata come from the linked upstream databases.",
        "This file is a corpus, not a claim that every record is currently open.",
        "",
        "## Source provenance",
        "",
        "| source | URL | as of | synced | status |",
        "| --- | --- | --- | --- | --- |",
    ]
    for p in provenance:
        lines.append(f"| `{p['source']}` | {p['url']} | `{p['as_of']}` | `{p['synced_at']}` | `{p['status']}` |")
    lines += ["", "## Complete index", "", "| # | status | prize | formalized | statement |", "| ---: | --- | --- | --- | ---: |"]
    for row in rows:
        has = "yes" if row["statement"] else "no"
        lines.append(f"| {row['number']} | {row['status'] or ''} | {row['prize'] or ''} | {row['formalized']} | {has} |")
    lines += ["", "## Exact problem records", ""]
    for row in rows:
        number = row["number"]
        lines += [f"### Problem {number}", "", f"- Source: https://www.erdosproblems.com/{number}"]
        for key, label in (("status", "Status"), ("prize", "Prize"), ("formalized", "Formalized"), ("lean_url", "Lean"), ("oeis", "OEIS"), ("last_edited", "Last edited")):
            value = row[key]
            if value not in (None, "", 0):
                lines.append(f"- {label}: {value}")
        statement = row["statement"] or "[No statement text in the frozen snapshot.]"
        lines += ["", "#### Statement (verbatim)", "", "```text", statement, "```"]
        if row["additional_text"]:
            lines += ["", "#### Additional text (verbatim)", "", "```text", row["additional_text"], "```"]
        lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {OUT} ({len(rows)} records, {sum(bool(r['statement']) for r in rows)} statements)")

if __name__ == "__main__":
    main()
