# The two orphan checks are now scripts, and CI has never run a single step

claude (Babbage lineage), 2026-08-15. Full note: `notes/CI_FORMAL_GATES.md`.

Tonight's two audits found the same defect in two lanes: an aggregate that
did not reach its own tree. Both were seconds of work to detect and went a day
undetected, because the check lived in prose. Landed:

- **`scripts/check-agda-closure.sh`** — transitive import closure of
  `Everything.agda` + `NaturalMachine.agda`, no Agda needed. Fails on orphans,
  and fails in the opposite direction if anything imports
  `NaturalMachine.Control.*` (which must stay unimported, being deliberately
  ill-typed). **It fails right now, 357/359**, and the two survivors of the
  34 are exactly `DSONucleusMiddleAssociativityAudit` and
  `DSONucleusResidualAudit` — the two the pin sweep could not finish (41 and
  30 minutes, no exit code). They are unimported because nobody can afford to
  import them. I left that decision to their owners; the script will now keep
  asking.
- **`scripts/check-lean-globs.sh`** — guards the one-line fix
  `globs = ["Pairfield", "Pairfield.+"]` (present in the working tree,
  uncommitted, Curry's; I did not commit it). With the glob, orphans are
  impossible and no enumeration is needed; without it the script enumerates
  them and fails — 17 on a clean HEAD, where the audit said 21 and SEED-85
  said 16 then 13. The number moved again in a night. That is the case for
  the glob.
- **`.github/workflows/formal-gates.yml`** — both on push/PR (they need no
  toolchain), plus `lake build` behind `workflow_dispatch` only (~10 GB
  mathlib cache). Agda-under-the-pin stays manual: 75-minute Hackage build,
  no runner image has it.

**And the finding I would rather you read.** I checked the failing runs
instead of the badge. Every run I can reach across both workflows: `failure`,
~2 s, `runner_id: 0`, no steps array, `total_ms: 0` billable, logs 404. The
jobs are not failing — **they never start.** That is an account-level Actions
quota/disable, fixable only in GitHub settings, not in any file here. So the
workflow I just added is correct and **inert until the owner fixes that.** I
still think wiring it in was right: it is what starts working the moment the
account does.

Also: `git config core.hooksPath` is **unset** in this checkout, so
`.githooks/pre-commit` is not running either. I did **not** set it — that hook
also refuses commits off `main`, and several of us are on
`claude/collaborative-subagents-loop-*` right now; turning it on would block
you mid-flight. Owner's call.

Of the four layers CLAUDE.md credits with enforcing the Python ban, exactly
one is live in this checkout.

**Owner decision requested** (`CI_FORMAL_GATES.md` §4): `epistemic.yml` runs
`python3` three times. I did not touch it. The sharp point is that those three
lines have *never executed*, so this is not "a working check the ban would
destroy" — it is an unrun check in a banned language. Four options costed in
the note; my preference is (4), grandfather it explicitly as frozen legacy,
unless someone wants to pay for the port of 282 test files.
