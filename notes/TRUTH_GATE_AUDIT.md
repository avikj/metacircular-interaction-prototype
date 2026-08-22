# Hostile audit of the machine's truth gate (2026-08-16)

Target: the claim that "a candidate installs only if agda exits 0 on a
`--safe` module." Files: `machine/MathMachine.hs`, `machine/Certificate.hs`,
`machine/AgdaRewriteGate.hs`, and the runner scripts.

## Where the gate actually is

The live install path is:

    executeBoundedSearch → filterM (kernelAcceptWith (mInvented m) …) results
                         → C.certifyWith (certDefinitions invented) "." (eq, note)   [MathMachine.hs:1786, 1288]

`kernelAcceptLegacy` (MathMachine.hs:1304, the path that writes into
`formal/cubical/<modName>.agda`) is **dead code** — no caller. `AgdaRewriteGate.hs`
is a separate self-contained demo, not on the install path. So the whole gate
is `Certificate.certifyWith` → `runAgda` (Certificate.hs:483) → agda exit code.

The decisive design fact: **a candidate is never free-form Agda source.** Its
type is `(Equation, proofNote) + [Definition]` where `Equation = (Term,Term)`,
`Term = V Int | F String [Term]`. The Agda module is rendered by trusted
template code. So there is no "flag line" for a candidate to carry in the first
place — the answer to "does the gate parse/enforce the flag line" is that the
flag line is a hardcoded constant the candidate cannot supply.

## (1) OPTIONS injection — cannot disable --safe

`preambleCore` (Certificate.hs:310) emits, unconditionally and as line 1:

    {-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
    module Candidate where

Everything derived from candidate input appears at line 3 or later. Three
independent facts make un-safing impossible:

- Agda **rejects any OPTIONS pragma after the module header**:
  "OPTIONS pragma only allowed at beginning of file, before top module
  declaration" (verified). No candidate string can reach line 1.
- Agda 2.6.3 has **no `--no-safe` flag at all** ("Unrecognized option:
  --no-safe"); safety is toggled only by presence/absence of `--safe` on the
  committed first line.
- `--safe` blocks the escape hatches: `postulate` → "Cannot postulate … with
  safe flag" (exit 42); `{-# TERMINATING #-}` → "Cannot use TERMINATING pragma
  with safe flag" (exit 42). Both verified.

### The one real defect: `defName` is emitted unsanitized (defense-in-depth gap)

`agdaVar` is whitelisted to `xyzuvw` (indices 0–5) and `render` accepts only a
fixed symbol whitelist `{0 s + * - max le gcd}` plus supplied `Definition`
names — so terms and variables cannot inject text. **But `defName` is spliced
verbatim** into the module (Certificate.hs `preambleWith`/`prefixAgda`), in
three positions, with no character check. A hostile concept name containing
newlines injects arbitrary lines into `Candidate.agda`.

Demonstrated end-to-end through the real `Certificate.hs` code
(`scratchpad/Attack.hs`): a `Definition` named
`"g\n{-# OPTIONS --no-safe #-}\npostulate evil : … suc a0 ≡ a0\ng"` on the
false equation `suc x = x` produced a `Candidate.agda` literally containing the
injected pragma and postulate. The gate verdict was **`Rejected` (8 agda
calls)** — the injection lands after the module header (pragma ignored, `--safe`
still locked, postulate refused), and the false equation does not certify.

Impact: soundness holds today **only because `inventConcept` always names
concepts `"c" ++ show n`** (MathMachine.hs:1547) — a clean `/^c[0-9]+$/`. The
gate itself does no validation; it relies on that caller invariant. Recommend
`Certificate.agdaTermWith`/`preambleWith` reject any `defName`/symbol not
matching `[A-Za-z_][A-Za-z0-9_]*` (return `Nothing` → Untranslatable). Cheap,
removes the latent channel.

## (2) Module-name collision — not exploitable

Module name is the constant `"module Candidate where"`; the file is always
`<mktemp -d>/Candidate.agda` (fresh per call, Certificate.hs:487–489); agda
checks the file passed **by path**. None of these are candidate-controlled, so
a candidate cannot name itself after an existing module, cannot overwrite a
library file, and cannot redirect the check to the wrong file. No `Candidate*.agda`
exists in `formal/cubical`, so there is no shadow target even for the include
path. (The dead legacy path did write into `formal/cubical/`, but even there
the name came from `mktemp -u`, not from the candidate.)

## (3) Import injection — blocked by --safe infectivity

Imports are a fixed Cubical set (`Prelude`, `Data.Nat`, optional
`Data.Nat.GCD`), all `--safe`. The only way to add an `open import` is the same
`defName` newline channel; an injected import sits after the module header
(a legal position for imports, unlike OPTIONS), so this is the one injection
that could *parse*. It still cannot poison the candidate:

- `--safe` is **infective**: a `--safe` module importing a non-safe module is
  rejected — "Importing module … not using the --safe flag from a module which
  does" (verified, exit 42).
- Therefore any importable module is `--safe`, hence contains no `postulate`/
  `TERMINATING`, hence exports no proof of a false equation. The whole
  `formal/cubical/NaturalMachine` lane is `--safe` (every header checked; the
  `postulate`/`TERMINATING` grep hits are all in comments).

## Runner scripts

`check-natural-machine.sh` typechecks lane modules with bare
`agda NaturalMachine/$m.agda` and **does not pass `--safe` on the CLI** — it
trusts each file's own pragma line. For *candidates* this is irrelevant (the
emitter controls the line). For the hand-written lane it means CI's "PASS"
certifies "agda exits 0", not "agda exits 0 under `--safe`": a lane module that
dropped `--safe` from its header would still show PASS. Low risk (headers are
uniform today) but worth a one-line CLI `--safe` or a header lint.

## Availability (not soundness)

`runAgda` (Certificate.hs:483) applies **no timeout** and `defArity` feeds
`replicate (defArity d) "ℕ → "` unbounded. A pathological but `--safe`
candidate could make agda spin or balloon a signature. `kMaxAgdaCalls` bounds
call *count*, not per-call time. Not a truth-gate break; a DoS surface.

## Verdict

The core claim holds: **no candidate on the live path can install a false
equation.** `--safe` is locked at line 1 and un-removable, its escape hatches
(`postulate`, `TERMINATING`) are refused, `--no-safe` does not exist in 2.6.3,
and `--safe` infectivity neutralizes injected imports. The module name/file
path are non-candidate-controlled, so no collision or wrong-file check. The one
genuine finding is the **unsanitized `defName`** — currently harmless only by a
caller-side naming convention, and it should be validated at the gate.
