# The Agda `--safe` header audit, and the gate that keeps it true

**Author.** claude (Frege lineage), 2026-08-15.
**Scope.** All 378 `.agda` files under `formal/` at the commit this note lands
on: 370 under `formal/cubical/` (of which 9 are `NaturalMachine/Control/`) and
8 under `formal/executable/`. Every count below is from a run of
`scripts/check-agda-pragmas.sh` **in this container**, not from CI (§6).
**Method.** Text analysis of headers. No Agda was run; see §6 for what that
does and does not license.

---

## 0. Verdict

| question | answer |
|---|---|
| files audited | **378** (`formal/**/*.agda`, `_build/` excluded; none existed) |
| files with **no** OPTIONS pragma | **0** |
| files asserting `--safe` | **378 / 378** |
| files under `formal/cubical/` asserting `--cubical` | **370 / 370** |
| pragmas placed after the `module` header (so inert) | **0** |
| files with >1 OPTIONS pragma, or an indented one | **0** |
| `--safe`-incompatible or discipline-defeating flags | **0** |
| `postulate` in code | **0** |
| interaction holes `{! !}` in code | **0** |
| `{-# TERMINATING #-}` / `NON_TERMINATING` / `NON_COVERING` in code | **0** |
| `primTrustMe` / `trustMe` in code | **0** |
| `{-# REWRITE #-}` / `POLARITY` / `INJECTIVE` / `NO_POSITIVITY_CHECK` | **0** |
| files missing `--safe` AND outside the aggregate closure | **0** (vacuously) |
| is it gated? | **Yes** — `scripts/check-agda-pragmas.sh`, wired into `formal/check.sh` and `formal-gates.yml` |

**CLAUDE.md's Agda-lane guarantee — `--cubical --safe`, no postulates, no
holes — is true of every file, and is now measured rather than asserted.**

This is the boring answer, and it is worth saying plainly that it was not the
expected one. `notes/AXIOM_GATE.md` §6.1 flagged the per-module pragma as "the
one asymmetry left" and declined to gate on it for want of a measurement. The
measurement came back clean. That does not make the gate unnecessary — it makes
it cheap to install *now*, while the property holds, which is the only time a
gate can be installed without an argument about whose file goes red.

## 1. What the gap actually was

`--safe` is not a lane-wide property. It is an `{-# OPTIONS ... #-}` pragma,
per file, that must appear **before** the `module` header. Three ways to lose
it, all silent:

1. **Omit the pragma.** The file is typechecked without `--safe`. It may
   `postulate`, use `{-# TERMINATING #-}`, `primTrustMe`, or leave metas
   unsolved, and `formal/check.sh` prints nothing, because `agda` was never
   told to object.
2. **Place it after the `module` line.** Agda reads OPTIONS pragmas only in the
   file preamble; one below the header is an ordinary pragma block and does not
   apply. It *looks* right in a diff.
3. **Drop `--safe` while adding an incompatible flag** (`--rewriting`,
   `--type-in-type`, `--allow-unsolved-metas`, …). Agda would have rejected the
   combination; without `--safe` it accepts it happily.

Against (1) and (2) the repository's only defence was a header comment
convention and the prose claim in CLAUDE.md. Nothing measured either.

**The subtlety, and why it did not bite here.** A module lacking `--safe` may
still be safe in practice, and — more strongly — a module *imported by* a
`--safe` module is forced safe by Agda itself, since `--safe` propagates to
imports. So the genuinely dangerous set is files that are (a) missing `--safe`
**and** (b) not transitively imported by any `--safe` root. I computed (b) by
reusing `scripts/check-agda-closure.sh` rather than rewriting it: it reports
`361 modules on disk, 361 reached` from roots `Everything` and `NaturalMachine`,
exit 0, with the 9 `NaturalMachine/Control/*` modules correctly unimported.
Set (a) is empty, so the intersection is empty **twice over**, and I am
recording the reasoning rather than only the answer, because a future file that
breaks (a) will need (b) checked and the two scripts are the pair that does it.

## 2. The pragma census

Six distinct pragma lines account for all 378 files:

| count | pragma |
|---|---|
| 273 | `{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}` |
| 70 | `{-# OPTIONS --cubical --safe --no-import-sorts #-}` |
| 26 | `{-# OPTIONS --cubical --safe #-}` |
| 7 | `{-# OPTIONS --safe #-}` |
| 1 | `{-# OPTIONS --safe --guardedness #-}` |
| 1 | `{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}` |

The two non-`--cubical` rows are exactly `formal/executable/` (8 files:
`BalancedReweave`, `BoundedMinimization`, `ConsequenceFiber`, `FiberJewelNet`,
`RootedReweave`, `RewriteDynamics`, `InstalledRootedQuotient`,
`TheoremCompiledObservation`). These are MAlonzo/GHC extraction targets driven
by `machine/run-extracted-rewrite.sh`; they are non-cubical by construction and
import `Agda.Builtin.*` only. They carry `--safe`. The gate therefore applies
its `--cubical` check **by directory scope**, not by allowlist entry — an
exemption that follows from what the directory is, rather than from a decision
someone has to remember.

Three flags in that table deserve a sentence each, because "unexpected" is not
the same as "unsafe":

- **`--guardedness`** (275 files) is the ordinary coinduction totality checker
  and *is* `--safe`-compatible. It is not `--guarded`, the experimental
  later-modality option, which is not. My first draft of the gate matched
  `--guarded` as a substring and flagged all 275; the bug and its fix are
  recorded in the script, because that near-miss is the exact shape of a gate
  that gets disabled instead of fixed.
- **`--no-import-sorts`** (344 files) is a scoping convenience from the cubical
  library's own preamble. No soundness content.
- **`--lossy-unification`** (1 file, `NaturalMachine/LeakageCommutator.agda`) is
  a unifier performance option. Agda does not list it as `--safe`-incompatible,
  and the decisive evidence is structural rather than my reading of a manual:
  **Agda itself rejects `--safe` combined with any `--safe`-incompatible flag**.
  Every one of these 378 files asserts `--safe`, so any genuinely incompatible
  flag in a pragma is a compile error, not a silent hole. The flag list in the
  gate is therefore belt-and-braces — it turns a 40-minute-into-the-build
  failure into a one-second one, and catches the case where someone removes
  `--safe` and adds an unsafe flag in the same edit.

## 3. Postulates, holes, and the comment problem

CLAUDE.md claims none exist. **The claim is true**, and checking it was less
trivial than it sounds.

A naive `grep -rn postulate formal/ --include='*.agda'` returns **112 hits**.
Every one of them is prose. This corpus documents itself heavily, and roughly
forty module headers contain the sentence "no postulates, no holes" or a
variant. `grep TERMINATING` returns 4, all prose (`TransportDivQuot.agda:73`,
`RoughSplit.agda:57`, `MeanStandardRep.agda:101`, `ThresholdGenerationDichotomy.agda:55`
— each saying there are none). `grep primTrustMe` returns 1, likewise prose.
`grep -c '{!'` returns 0 outright.

Stripping `--`-to-EOL line comments removes 111 of the 112. The survivor is
`formal/cubical/ObligatioOrderTrilemma.agda:34` — the phrase "no postulates, no
holes" inside a multi-line `{- ... -}` block. So the gate strips block comments
too, tracking nesting depth across lines, while deliberately **not** treating
`{-#` as a comment opener so that `{-# TERMINATING #-}` still gets caught.

This is not fussiness about a single false positive. A gate that reports one
known-benign hit every run is a gate whose output people stop reading, and it
would have had to be silenced either by allowlisting a whole file (which would
then also hide a real `postulate` added to it later) or by rewording another
agent's prose. Neither is acceptable; parsing correctly is cheaper than both.

**Residue after stripping all comments: zero, across all 378 files.**

## 4. The gate

`scripts/check-agda-pragmas.sh`, shell, no toolchain, ~10 s on this container.
It fails if any file under `formal/`:

1. has no `{-# OPTIONS #-}` pragma at column 0;
2. has one **after** the `module` header (inert, and invisible in review);
3. omits `--safe`; or omits `--cubical` while under `formal/cubical/`;
4. names a `--safe`-incompatible flag;
5. contains, with **all** comments stripped, `postulate`, `{!`, `{-# TERMINATING #-}`,
   `NON_TERMINATING`, `NON_COVERING`, `NO_POSITIVITY_CHECK`, `POLARITY`,
   `INJECTIVE`, `REWRITE`, `primTrustMe` or `trustMe`.

**The allowlist is empty, and that is the finding.** It is present, commented,
and documents the two candidate exceptions that turned out not to need entries:

- `NaturalMachine/Control/*` (9 files) — the deliberately ill-typed controls
  that MUST fail to typecheck (`BUILD.md`) and that `check-agda-closure.sh`
  keeps unimported. These are the natural exception and the task anticipated
  them, so I checked directly rather than assuming: **all 9 carry
  `--cubical --safe --no-import-sorts`**, two also `--guardedness`. A control
  should fail for its intended mathematical reason *while* `--safe`; if one
  ever needs to drop the flag to fail the right way, the allowlist has a slot
  and demands the reason.
- `formal/executable/*` (8 files) — handled by directory scope, §2.

Per `AXIOM_GATE.md` §4: an entry without its reason should be deleted, the gate
allowed to go red, and someone made to look. The format enforces one reason per
entry; the empty list is the strongest possible version of that rule.

## 5. The gate can go red — thirteen branches, exercised

A green gate that has never failed is indistinguishable from a gate with a typo
in its regex. Mine had exactly that (§2, `--guarded`). So each branch was run
against a scratch copy of the tree with a probe module written in:

| probe | result |
|---|---|
| clean baseline | OK |
| no pragma | `NO-OPTIONS-PRAGMA` ✓ |
| pragma without `--safe` | `NO-SAFE` ✓ |
| `--safe` without `--cubical`, under `cubical/` | `NO-CUBICAL` ✓ |
| pragma below the `module` line | `PRAGMA-AFTER-MODULE` ✓ |
| `--rewriting` | `UNSAFE-FLAG` ✓ |
| `--guarded` | `UNSAFE-FLAG` ✓ |
| `--guardedness` (must NOT trip) | OK ✓ |
| `postulate foo : Set` | `CONSTRUCT` ✓ |
| `foo = {! !}` | `CONSTRUCT` ✓ |
| `{-# TERMINATING #-}` | `CONSTRUCT` ✓ |
| `primTrustMe` | `CONSTRUCT` ✓ |
| the same three words inside a multi-line `{- -}` block (must NOT trip) | OK ✓ |
| the same three words in a `--` comment (must NOT trip) | OK ✓ |
| `--safe`-only file placed in `formal/executable/` (must NOT trip) | OK ✓ |
| allowlist entry added by hand for a `NO-SAFE` file | suppressed ✓ |

Eight fail-branches fire, five must-not-trip cases stay quiet, and the
allowlist suppresses. No scratch edit touched the real tree.

## 6. Scope limits — say them, or the note overclaims

- **This is text analysis, not a build.** It says nothing about whether any
  module typechecks. That is `formal/check.sh` against the pin in `BUILD.md`,
  and I did not run Agda — the pinned toolchain is not installed in this
  container. A file could assert `--safe` and be red; this gate would still
  pass it. The two gates are complements: `check-agda-pragmas.sh` guarantees
  that when Agda *does* run, it runs with `--safe`.
- **It reads the first OPTIONS pragma per file.** No file has two (verified),
  so this is exact today; if a file ever grows a second one the gate reads only
  the first, and the `PRAGMA-AFTER-MODULE` check is what would catch the common
  version of that mistake.
- **The unsafe-flag list is a list, and lists rot.** Unlike the Lean axiom
  gate — which allows three axioms and rejects everything else, so it need not
  be taught new escape-hatch names — this check must be told what to fear. It
  is only a fast-fail convenience: the real guarantee is that Agda rejects
  `--safe` plus an incompatible flag, and all 378 files assert `--safe`. If
  Agda grows a new unsafe flag, the compiler still catches it; this script
  merely catches it sooner.
- **The construct scan is textual.** A `postulate` reachable through the
  cubical standard library, or an unsafe primitive under an alias, is invisible
  to it. `--safe` itself is what excludes those, and it is stronger than any
  grep — which is the whole reason `AXIOM_GATE.md` §6 concluded Agda does *not*
  need Lean's axiom-scanning analogue.
- **Reachability is `check-agda-closure.sh`'s job**, and it is unchanged and
  passing. `formal/executable/` is outside its scope (it has no aggregate root
  and is driven by `machine/run-extracted-rewrite.sh`); those 8 files are
  covered by this gate for pragmas but by nothing for orphanhood. That is a
  real, small, named hole, and I am leaving it named rather than fixing it
  silently.
- **I did not read all 378 files.** I read the pragma preamble of every one
  mechanically, the closure script, `formal/check.sh`, the workflow,
  `AXIOM_GATE.md`, and the specific files named in this note.

## 7. CI is wired and inert — as with the Lean gate

The check is a step in the `import-closure` job of
`.github/workflows/formal-gates.yml`, which is the toolchain-free job that runs
on every push, and a line at the top of `formal/check.sh` (first, because a
missing pragma makes the subsequent green meaningless rather than merely
incomplete).

**GitHub Actions on this account never starts.** Every run shows `runner_id 0`,
no steps, logs 404 (`notes/CI_FORMAL_GATES.md` §2; `notes/AXIOM_GATE.md` §5).
Nothing I wired has executed in a runner, and I do not claim it has. The CI half
is correct-but-inert and begins working the moment the owner re-enables Actions.
**Every verdict in §§0–5 is from running the script in this container.**
`formal/check.sh` is the path that runs today.

## 8. What is now closed, and what remains

`AXIOM_GATE.md` §6 left one open item: "a three-line grep that every module
under `formal/cubical/` begins `{-# OPTIONS --cubical --safe #-}` would close
that, and I did not add it — I have not audited those headers and will not gate
on a property I have not measured." That refusal was right, and this note is the
measurement it was waiting for. **The item is closed**, at ~150 lines rather
than three (the three-line version would have reported one false positive per
run and missed the pragma-position failure entirely).

The lane mapping is now complete on both sides:

| property | Lean | Agda |
|---|---|---|
| every module is built by something | `globs` | `check-agda-closure.sh` |
| nothing rests on an escape hatch | `lake exe axiom_gate` | `--safe`, per module |
| **that assertion is actually made** | n/a (whole-environment scan) | **`check-agda-pragmas.sh`** |

What remains is the larger risk both notes name and neither gate touches:
whether a theorem's *statement* matches the prose that cites it
(`LEAN_LANE_AUDIT` §6). No gate of this kind can reach it. `--safe` guarantees
the proof is a proof; it says nothing about what was proved.
