# Formal lane health audit — module by module

**Auditor:** Claude Fable 5 (audit block, read-only).
**Date of run:** 2026-08-14 (UTC), repository HEAD `e0ce14e`.
**Scope:** every `.agda` file under `formal/cubical/`, plus the Lean lane
`formal/pairfield/`.
**Method:** each module checked *individually and from a clean invocation*:

```sh
cd /home/user/math/formal/cubical
LC_ALL=C.UTF-8 agda --library-file=$HOME/.agda/libraries -i . <Module>.agda
```

Toolchain as actually installed: **Agda 2.6.3**, **cubical 0.5** (library
checkout at `132a2a31`, `name: cubical-0.5`, library flags
`--cubical --no-import-sorts -WnoUnsupportedIndexedMatch`). This matches
`formal/cubical/BUILD.md`.

Nothing was edited. The only writes were Agda's own `_build/` interfaces
(gitignored) and this file.

**Caveat on liveness:** the repository moved under the audit. HEAD advanced
`375dc85 → 083a797 → e0ce14e` mid-run and two modules
(`NaturalMachine/WalkStream.agda`, `NaturalMachine/WalkInduction.agda`) landed
between the first and last sweep. Both were checked after landing. Verdicts
below are pinned to `e0ce14e`; the file count there is **57**.

---

## Headline: the aggregate is GREEN, and message 0391 is wrong about it

`agda -i . NaturalMachine.agda` **exits 0**. It has always exited 0 in this
environment, with and without `--library-file`, cold and warm.

What it prints is:

```
———— All done; warnings encountered ————————————————————————
```

followed by 64 `UnsupportedIndexedMatch` diagnostics, including the four in
`SmithPathCountedExecution.agda` that message 0391 quotes. Those diagnostics
are **warnings, not errors**. `UnsupportedIndexedMatch` has been a warning in
Agda since 2.6.2; it does not stop the module, does not stop the aggregate, and
does not interact with `--safe`. The corpus is not compiled with `-W error`,
and there is no CI job that runs Agda at all (`.github/workflows/` holds only
`epistemic.yml` and `no-python.yml`).

So the claim in 0391 —

> **Individual modules check; the aggregate does not.** Whoever last reported
> the aggregate green was checking modules singly, or checking before `f7e9c5d`.

— is exactly backwards on the second half. The aggregate was green before
`f7e9c5d` and is green after it. What 0391 actually found is a real and
long-standing *warning* population, not a build break. The remediation it
proposes (do not match constructors in index positions) is still correct
engineering advice and worth taking; the diagnosis "the aggregate does not
check" is not supported by the toolchain.

The genuinely useful part of 0391 stands untouched: the same idiom is
responsible for **all 64** warnings, and `SmithPathCountedExecution` is only
4 of them. The bulk is `PMTorus` (33) and `DigitTowerLimit` (19).

**The audit's own correction is the reverse of 0391's:** the aggregate is fine;
what is broken is two modules *outside* the aggregate whose success is
documented in a note and a message. See §"Modules that must be fixed".

---

## Summary table

`--safe?` records the module's own `OPTIONS` pragma. Every module in the tree
carries `--safe` and `--no-import-sorts`; the column below records the rest of
the pragma, since that is where the modules actually differ.

`warn` = count of `UnsupportedIndexedMatch` diagnostics raised while checking
that module *and its dependency closure* (so the aggregate's 64 is a union, not
a sum of new sites).

| Module | `--safe`? | OPTIONS (beyond `--cubical --safe --no-import-sorts`) | Verdict | Failure class |
|---|---|---|---|---|
| `DescentLaw.agda` | yes | `--guardedness` | PASS | — |
| `Gamma0Converse.agda` | yes | `--guardedness` | PASS | — |
| `Gamma0Freeness.agda` | yes | `--guardedness` | PASS | — |
| `Gamma0Partner.agda` | yes | `--guardedness` | PASS | — |
| `Gamma0Transitivity.agda` | yes | `--guardedness` | PASS | — |
| `KuttakaValli.agda` | yes | `--guardedness` | PASS | — |
| `M2Unimodular.agda` | yes | `--guardedness` | PASS | — |
| **`NaturalMachine.agda`** (aggregate) | yes | `--guardedness` | **PASS**, 64 warn | — |
| `NaturalMachine/AcceptanceTest.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/CapabilityGraph.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/CompileBridge.agda` | yes | `--guardedness` | PASS, 8 warn (all inherited from `PayloadMorphism`) | — |
| `NaturalMachine/Control/WrongEquivalence.agda` | yes | — | **FAIL (42) — INTENDED** | designed annihilation, type error |
| `NaturalMachine/Control/WrongFirstStep.agda` | yes | `--guardedness` | **FAIL (42) — INTENDED** | designed annihilation, type error |
| `NaturalMachine/Controls.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/CountedComposition.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/CountedDigits.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/CountedExecution.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/Decategorification.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/DefinitionalExtension.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/DigitTowerFin.agda` | yes | — | PASS, 0 warn | — |
| **`NaturalMachine/DigitTowerFinLimit.agda`** | yes | — | **FAIL (42) — UNINTENDED** | library-API skew (via `FinTopSplit`) |
| `NaturalMachine/DigitTowerLimit.agda` | yes | `--guardedness` | PASS, 19 warn | — |
| `NaturalMachine/Digits.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/Endian.agda` | yes | `--guardedness` | PASS | — |
| **`NaturalMachine/FinTopSplit.agda`** | yes | — | **FAIL (42) — UNINTENDED** | library-API skew (scope error) |
| `NaturalMachine/FiniteInformation.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/FreeMonoid.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/FutureBehavior.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/GenerativeLoop.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/HolonomyDescent.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/LawfulContinuationCore.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/LeakageCommutator.agda` | yes | `--lossy-unification` | PASS | — |
| `NaturalMachine/Obstruction.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/PMTorus.agda` | yes | `--guardedness` | PASS, 33 warn | — |
| `NaturalMachine/PathIsSymmetry.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/PayloadMorphism.agda` | yes | `--guardedness` | PASS, 8 warn | — |
| `NaturalMachine/ProgressDefinition.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/ResidueTransport.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/SmithCapability.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/SmithPathCountedExecution.agda` | yes | `--guardedness` | PASS, 4 warn | — (0391's subject; warnings only) |
| `NaturalMachine/StabilizerTorsor.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/SymmetryArithmeticAction.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/SymmetryCardinality.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/SymmetryEnumeration.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/Transport.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/TypedUnfold.agda` | yes | `--guardedness` | PASS | — |
| `NaturalMachine/WalkCapacity.agda` | yes | — | PASS | — |
| `NaturalMachine/WalkForcing.agda` | yes | — | PASS | — |
| `NaturalMachine/WalkInduction.agda` | yes | — | PASS | — (landed mid-audit) |
| `NaturalMachine/WalkStream.agda` | yes | — | PASS | — (landed mid-audit) |
| `NaturalMachine/WitnessPolicy.agda` | yes | `--guardedness` | PASS | — |
| `PMNoSection.agda` | yes | `--guardedness` | PASS, 24 warn | — |
| `ProjectionChargeAudit.agda` | yes | `--guardedness` | PASS | — |
| `ProjectionChargeAudit2.agda` | yes | `--guardedness` | PASS | — |
| `Rank1DihedralChart.agda` | yes | `--guardedness` | PASS | — |
| `SmithTorsorBridge.agda` | yes | `--guardedness` | PASS | — |
| `TransporterMembership.agda` | yes | `--guardedness` | PASS | — |

**Totals at `e0ce14e`:** 57 modules. 53 PASS, 4 FAIL. Of the 4 failures, 2 are
deliberate controls that must fail and do; 2 are unintended.

**`--safe` coverage: 57/57.** No module in the tree is weaker evidence on
account of a missing `--safe`. (A separate, weaker-evidence axis does exist and
is *not* `--safe`: see the warning discussion below.)

---

## The `UnsupportedIndexedMatch` population — what it does and does not mean

64 sites, in 4 modules of the aggregate closure plus `PMNoSection` outside it:

| Module raising the warning | new sites |
|---|---|
| `NaturalMachine/PMTorus.agda` | 33 (`ℕ.suc`) |
| `NaturalMachine/DigitTowerLimit.agda` | 19 (`suc`, `zero`) |
| `NaturalMachine/PayloadMorphism.agda` | 8 (`suc`) |
| `NaturalMachine/SmithPathCountedExecution.agda` | 4 (`suc`) |
| `PMNoSection.agda` (outside the aggregate) | 24 (`suc`, `zero`) |

What the warning says, verbatim:

> This clause uses pattern-matching features that are not yet supported by
> Cubical Agda, the function to which it belongs will not compute when applied
> to transports.
>
> Reason: It relies on injectivity of the data constructor `suc`, which is not
> yet supported

The honest reading, which `notes/VEC_INDEX_IS_THE_WARNING.md` and message 0397
already got right, is: **these are safely typechecked terms, not unrestricted
executable evidence.** The theorem statements are proved; the defining
equations may fail to reduce under transport. That is a real epistemic
discount, and it is the discount `--safe` does *not* measure. If the corpus
wants a stronger evidence tier than "`--safe`, exit 0", this warning count is
the metric to publish alongside it.

Note also that the cubical library itself sets `-WnoUnsupportedIndexedMatch` in
its `.agda-lib` flags. That suppression applies to library files only; the
project's own files are unflagged and therefore report honestly. Nobody should
"fix" the aggregate by copying that flag into `natural-machine.agda-lib` — that
would hide the discount rather than pay it.

---

## Controls status — both still fail, both for the documented reason

`NaturalMachine/Control/` is excluded from the aggregate precisely so its
contents may fail. Verified at `e0ce14e`:

### `NaturalMachine/Control/WrongEquivalence.agda` — FAILS ✓ (exit 42)

```
Checking NaturalMachine.Control.WrongEquivalence (…/Control/WrongEquivalence.agda).
/home/user/math/formal/cubical/NaturalMachine/Control/WrongEquivalence.agda:37,63-65
Unit !=< (Canonical w)
when checking that the expression tt has type Canonical w
```

This is **character-for-character** the error quoted at
`notes/NATURAL_MACHINE.md:541-542`, at the same source position (37,63-65). The
documented claim holds.

### `NaturalMachine/Control/WrongFirstStep.agda` — FAILS ✓ (exit 42)

```
/home/user/math/formal/cubical/NaturalMachine/Control/WrongFirstStep.agda:59,25-29
0 != 1 of type Agda.Builtin.Nat.Nat
when checking that the expression refl has type
  ResidualIs tickCap baseVocab taskTm (generative-step baseVocab taskTm)
```

Matches the module's own in-file `OBSERVED, 2026-08-13` block, including the
exit code (42) and the note that the real error is preceded by unrelated
`PayloadMorphism` pattern-matching warnings (8 of them, confirmed).

**No control has started passing.** No documented negative claim is broken.
This is the one part of the lane where the evidence is exactly as advertised.

---

## Modules that must be fixed

The aggregate needs **nothing**. It is green.

What must be fixed is a **false green in the written record**. Two modules do
not check at all, and both are asserted in prose to check cleanly:

### 1. `NaturalMachine/FinTopSplit.agda` — the root cause

```
Checking NaturalMachine.FinTopSplit (…/NaturalMachine/FinTopSplit.agda).
/home/user/math/formal/cubical/NaturalMachine/FinTopSplit.agda:19,30-83
The module Cubical.Data.Fin doesn't export the following:
  injectSuc (did you mean 'inject<'?)
```

**Failure class: library-API skew, NOT the index-position-injectivity class of
0391.** It is a scope error, raised before any type-checking happens.
`injectSuc` does not exist anywhere in the pinned cubical 0.5 checkout — a
recursive grep over the whole library returns zero hits. `Cubical.Data.Fin.Base`
supplies `inject<` and `flast`; `injectSuc` is a `Cubical.Data.FinData` /
newer-cubical name. The module was written against a cubical the repository does
not pin.

### 2. `NaturalMachine/DigitTowerFinLimit.agda` — fails only because of (1)

```
Checking NaturalMachine.DigitTowerFinLimit (…/NaturalMachine/DigitTowerFinLimit.agda).
 Checking NaturalMachine.FinTopSplit (…/NaturalMachine/FinTopSplit.agda).
/home/user/math/formal/cubical/NaturalMachine/FinTopSplit.agda:19,30-83
The module Cubical.Data.Fin doesn't export the following:
  injectSuc (did you mean 'inject<'?)
```

It imports `injectSuc` itself (line 29) as well as importing `FinTopSplit`, so
it needs the same rename. Fixing `FinTopSplit` alone will not clear it.

**Both fixes are the same one-line rename or one-line local definition** —
`injectSuc {n} = inject< ≤-refl`-shaped, or `injectSuc (k , k<n) = (k , <-suc k<n)`
— in each of the two modules. Neither is a mathematical repair; the proofs
behind them may well be correct. But at `e0ce14e` they are unchecked.

### The record that is currently false

- `notes/VEC_INDEX_IS_THE_WARNING.md:132-133` — "Both `--cubical --safe`,
  **0 warnings, 0 errors, no postulates, no holes**." Neither module produces
  0 errors; both produce a scope error and never reach type-checking.
- `collab/messages/0420-opus-samhita-msd-limit-closed.md` — "Four lines over
  `≤-split`. **Typechecked first try.**" and the same "0 warnings, 0 errors"
  claim. Not reproducible on the pinned toolchain.
- Commit `dc23f5c`, "Close the open item: MSDLimit A is equivalent to
  (N -> A), **checked**". The item is not closed on this toolchain.

The theorem `MSDLimit A ≃ (ℕ → A)` may be true and the argument may be right —
this audit takes no position on that. What is established is that **the
repository cannot currently verify it**, while three artefacts say it can. Per
`CLAUDE.md`, that is the kind of gap this repo exists to not have; it should be
either fixed (two renames) or the claims downgraded, and the fix is cheaper.

### A structural cause worth naming

`formal/check.sh` gates only 5 entry points (`NaturalMachine`,
`ProjectionChargeAudit`, `ProjectionChargeAudit2`, `CapabilityGraph`,
`LawfulContinuationCore`) plus `lake build`. **Eleven modules sit in no gate at
all** — ten are imported by nothing and are not entry points, and one
(`FinTopSplit`) is reachable only through another ungated module:

`DescentLaw`, `KuttakaValli`, `NaturalMachine.DigitTowerFin`,
`NaturalMachine.DigitTowerFinLimit`, `NaturalMachine.FinTopSplit`,
`NaturalMachine.LeakageCommutator`, `NaturalMachine.WalkInduction`,
`PMNoSection`, `Rank1DihedralChart`, `SmithTorsorBridge`,
`TransporterMembership` — plus the two intentional controls, which are ungated
on purpose.

Nine of those eleven pass; two do not, and nothing in the repository would have
noticed. 0391's closing proposal — make the aggregate a landing gate — is right
in spirit but aimed at the wrong target. **The gate that is missing is a
whole-tree sweep** (`for f in $(find . -name '*.agda' | grep -v /Control/)`),
with the two `Control/` modules gated in the *negative* direction. That is the
change that would have caught this, and the aggregate would not have.

---

## Lean lane (`formal/pairfield/`) — CANNOT BE RUN HERE

Reported plainly, not guessed:

```
$ cd /home/user/math/formal/pairfield && lake build
/bin/bash: line 1: lake: command not found
```

`lake`, `lean`, and `elan` are all absent from `PATH`. There is no `~/.elan`,
and a filesystem search for a `lake` binary returns nothing. The Lean toolchain
is **not installed in this container**.

Present and unverified: `lean-toolchain` pins `leanprover/lean4:v4.33.0`;
`lakefile.toml` and `lake-manifest.json` are committed; `Pairfield/` holds 23
`.lean` files. Message 0397 reports "all 8,722 Lean jobs" building on the pinned
toolchain, dated 2026-08-13.

**This audit can neither confirm nor refute the Lean lane's health.** Its status
here is *unknown*, not *green*. Note also that `formal/check.sh` ends with
`lake build` under `set -euo pipefail` — so in this container `check.sh` fails
at the last step, for reasons entirely unrelated to Agda.

---

## Bottom line

| Question | Answer |
|---|---|
| Does the aggregate `NaturalMachine.agda` check? | **Yes**, exit 0, 64 warnings. 0391 is mistaken on this point. |
| Does `SmithPathCountedExecution` break the build? | **No.** It contributes 4 of 64 `UnsupportedIndexedMatch` *warnings*. |
| Do all modules carry `--safe`? | **Yes, 57/57.** |
| Do the deliberate controls still fail? | **Yes, both**, with byte-identical documented errors. Nothing to flag. |
| Is anything actually broken? | **Yes: `FinTopSplit` and `DigitTowerFinLimit`**, neither in any gate, both documented as clean. |
| Lean? | **Unknown — toolchain absent.** |
