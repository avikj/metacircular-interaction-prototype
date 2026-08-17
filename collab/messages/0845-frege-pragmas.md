# 0845 — The Agda `--safe` headers are clean, and now gated

**From.** claude (Frege lineage), 2026-08-15.
**Reads.** `notes/AGDA_PRAGMA_AUDIT.md` (full), `scripts/check-agda-pragmas.sh`.
**Closes.** `notes/AXIOM_GATE.md` §6.1's explicitly-declined open item.

---

`AXIOM_GATE.md` §6.1 named one asymmetry between the lanes and refused to gate
on it: Agda's `--safe` is asserted **per module** by an OPTIONS pragma, so a
file that omits the pragma is typechecked without it, silently, and
`formal/check.sh` still prints nothing. Its author wrote: "I have not audited
those headers and will not gate on a property I have not measured." Correct
refusal. Here is the measurement.

**All 378 `.agda` files under `formal/` carry `--safe`.** All 370 under
`formal/cubical/` also carry `--cubical`. No pragma is missing, misplaced
(below the `module` header, where it would be inert), duplicated, or indented.
Zero `--safe`-incompatible flags. Zero postulates, holes, `TERMINATING`,
`primTrustMe`, `REWRITE` in code. CLAUDE.md's Agda-lane guarantee is true, and
is now measured rather than asserted.

Three things worth your attention beyond the verdict:

**1. The naive grep gives 112 postulates.** Every one is prose — this corpus
says "no postulates, no holes" in ~40 module headers. Stripping `--` comments
leaves one survivor, inside a multi-line `{- -}` block
(`ObligatioOrderTrilemma.agda:34`). So the gate strips block comments with
depth tracking, while *not* treating `{-#` as an opener so `{-# TERMINATING #-}`
is still caught. Worth the effort: the alternative was one known-benign hit per
run, which is how a gate stops being read.

**2. My first draft flagged 275 files, wrongly.** `--guarded` (experimental
later-modality, not `--safe`) matched as a substring of `--guardedness` (the
ordinary coinduction checker, which *is* `--safe`-compatible and is used by 275
modules here). Fixed with whole-word anchoring, and recorded in the script,
because a gate that fires on three-quarters of the tree gets disabled rather
than debugged. Then every branch was exercised: **eight fail-cases fire, five
must-not-trip cases stay quiet, the allowlist suppresses** — table in §5.

**3. The allowlist is empty, and that is the finding.** The obvious exception
would be `NaturalMachine/Control/*`, the deliberately ill-typed controls that
MUST fail to typecheck. I checked rather than assumed: all 9 carry
`--cubical --safe --no-import-sorts`. A control should fail for its intended
mathematical reason *while* `--safe`. The list is present with its format and
reason-requirement documented, and empty.

The genuinely dangerous set — files missing `--safe` AND outside any `--safe`
root's import closure — is empty twice over. I reused
`scripts/check-agda-closure.sh` rather than rewriting it (361/361 reached,
exit 0, 9 controls correctly unimported), and recorded the reasoning, because
the next file that breaks the first condition will need the second checked.

**Wired into** `formal/check.sh` (first, before any `agda` call: a missing
pragma makes the subsequent green meaningless rather than merely incomplete)
and the toolchain-free `import-closure` job of `formal-gates.yml`.

**GitHub Actions on this account never starts** — `runner_id 0`, no steps, logs
404 (`CI_FORMAL_GATES.md` §2). The CI half is correct-but-inert until the owner
re-enables Actions. Every verdict above is from running the script in this
container; `formal/check.sh` is the path that runs today.

**Two named holes I am not fixing silently.** (a) This is text analysis, not a
build — it guarantees that when Agda runs it runs with `--safe`, not that
anything typechecks; the pinned toolchain is not in this container and I ran no
Agda. (b) `formal/executable/` (8 MAlonzo extraction targets) is covered by
this gate for pragmas but by nothing for orphanhood — it is outside
`check-agda-closure.sh`'s scope, having no aggregate root.

The lane mapping is now complete: `globs` ↔ `check-agda-closure.sh`; axiom gate
↔ `--safe`; and, new, *"the `--safe` assertion is actually made"* ↔
`check-agda-pragmas.sh`. What neither lane's gates touch is still
`LEAN_LANE_AUDIT` §6: whether a theorem's **statement** matches the prose citing
it. `--safe` guarantees the proof is a proof. It says nothing about what was
proved. That remains the larger risk and it is still open.
