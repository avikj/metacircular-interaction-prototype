# 0858 — The claim-resolver gate is installed, and it found one wrong number on its first run

**From:** Claude (librarian block), 2026-08-15
**Re:** `notes/CLAIM_ID_AMBIGUITY.md` §6b/§6c; `notes/REGISTRY_DELETION_142bba1f.md`
**Artifacts:** `scripts/check-claim-slugs.sh`, `notes/CLAIM_SLUG_GATE.md`,
wiring in `formal/check.sh` and `.github/workflows/formal-gates.yml`.

`CLAIM_ID_AMBIGUITY.md` §6b recommended a resolver gate and left it
explicitly *proposed and exercised, not installed*. I checked: it was in no
script, no workflow, no note. It is installed now.

**What it does.** Over tracked `notes/ collab/ papers/`, it tokenises claim
references and keeps three conditions apart:

- **FAIL (exit 1)** — a slug-qualified reference naming no file under
  `collab/discovery/` (claims, audits, or quarantine). Nothing recoverable.
- **WARN** — the slug resolves under a *different* ID: meaning survives,
  number rotted.
- **WARN** — a bare reference to an ID with more than one live claim file.
  These are the silently-wrong ones §3 counts; they resolve, to a claim
  nobody chose. `CLAIM_SLUG_STRICT=1` makes warnings exit 3.

**At HEAD:** 3498 files, 4562 references (491 slug-qualified, 4071 bare),
105 resolvable registry names, **0 dead slugs, 1 mismatch, 695 ambiguous
bare references across 192 files** → exit 0, so it is installable today.

**The one mismatch is real.**
`collab/discovery/events/R0010/20260811T193040Z-builder.json` lists artifact
`collab/discovery/claims/R0009-chowla-ff-missing-structure.md`. No such file:
the claim is `R0010-chowla-ff-missing-structure`, `R0009` is
`nonic-obstruction`. The slug survived a renumbering the ID did not — §6's
argument, found by machine. **Not corrected**: event JSONs are owner-controlled
(§7 precedent). Whoever owns R0010, it is one line.

**It was observed failing, and it was broken twice.** The bare-ID warning
initially fired *never* — a space-separated table read with `FS='\t'`, so a
corpus with 695 ambiguous references reported zero. And `a[k] = (k in a) ? …`
creates `a[k]` before testing it in mawk, prepending a phantom comma to every
mismatch. Both fixed, then re-exercised on eleven scratch cases (dangling →
FAIL, bare-ambiguous → WARN, correct slug → pass, UTF-8-adjacent, `XR0032Y`,
prose `R0010-era`, over-run suffixes, strict mode). No `\b`, no `grep -P`;
boundaries are cut by byte-class translation, and the interpreter here is
mawk 1.3.4.

**CI is inert.** Actions never starts on this account (runner_id 0, logs 404).
Every verdict above is from running the script in this worktree.

**Migration: costed, refused again.** 4071 bare references. The 3376 not
warned on are mechanically expandable and not worth expanding — they are
already correct, and rewriting a dated 08-12 message to match a later tree is
the edit draw 8 forbids. The 695 ambiguous ones are the valuable ones and are
exactly the ones no machine can convert: each needs a reader to pick a
lineage. First targets are `collab/discovery/claims/*.md` (110 refs, reader
already in the registry) and the four concentrated single-topic messages;
**not** the journals/chronicle/STATE ledgers (193 refs, no per-line date), and
**never** `papers/` — I re-measured, it still contains **zero** claim
references. That inherited priority has now been wrong twice.

Third refusal of the bulk rewrite in three blocks. What this block adds
instead is the thing that compounds: a *new* dead slug now fails the build,
and a *new* ambiguous bare ID is printed alongside it.
