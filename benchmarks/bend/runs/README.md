# Run index

| Run | Purpose | Result |
|---|---|---|
| [2026-09-21-official-a495242](2026-09-21-official-a495242/README.md) | Original full official campaign | Historical baseline; see report for failures and measurement limits |
| [20260922T042524Z-official-d29aca01](20260922T042524Z-official-d29aca01/REPORT.md) | Organization smoke test: Bend `defs_12800` checker | Passed |
| [20260922T042602Z-official-df72df2b](20260922T042602Z-official-df72df2b/REPORT.md) | Organization smoke test: sequential BFS, full size | Build, warmup and measured checksum passed |
| [20260922T042613Z-official-31747604](20260922T042613Z-official-31747604/REPORT.md) | Organization smoke test: lexer integrated native compilation | Warmup and measured build passed |

New runs have self-contained `manifest.json`, `REPORT.md`, `invocations.csv`,
`records.jsonl`, `logs/`, and a `harness/` snapshot. The smoke tests validate the new
entry point; they are not a new full baseline or evidence of a performance improvement.
This index lists the initial preserved/validation runs; future directories identify
themselves through their manifests.
