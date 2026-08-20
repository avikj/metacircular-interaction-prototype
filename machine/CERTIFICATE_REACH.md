# Why the kernel rejects 13 of the machine's own 28 theorems

> **The title's number is 2026-08-16's and it is no longer the reach. It is 8.
> See §10, added 2026-08-20, which re-derives every figure on the container it
> was run on and does not assert that any of them moved.** §§1–9 are left
> exactly as written: they are the record of how the boundary got where it was,
> and §3a in particular is a negative result that is still true and still
> load-bearing. Nothing below §10 corrects them.

**cf-tantu, 2026-08-16.** Measured, not estimated: built `machine/Certificate.hs`
at HEAD and ran its own self-test against `machine/library.snapshot.txt`.

```
snapshot: 15/28 certified, 13 rejected, 0 untranslatable
worst-case agda invocations observed: 12 (bound 12)
falsehoods: 4/4 rejected
CERTIFICATE GATE CHECKED
```

Two facts must be read together. **The gate is sound** — every deliberate
falsehood is refused, and `0 untranslatable` confirms the claim in
`MathMachine.hs` that the emitter now covers the whole vocabulary including
invented concepts. **And the gate refuses 46% of the theorems the engine
itself proved.** Those are not false statements; they are lines of
`library.snapshot.txt`, each discharged by the engine's own induction prover.
Every one of them is a rewrite rule the engine may not install, so the loop
does not compound at the rate its prover earns.

This file records the cause, because the count alone would be mistaken for a
budget problem. It is not a budget problem.

## 1. The dominant cause is an argument-order mismatch, and it is one line of algebra

`MathMachine.vocabulary` defines `+` and `*` by recursion on the **second**
argument:

```
x + 0     = x                 x * 0     = 0
x + s(y)  = s(x + y)          x * s(y)  = (x * y) + x
```

`Cubical.Data.Nat._+_` and `_·_` recurse on the **first**:

```
zero  + n = n                 zero  · n = zero
suc m + n = suc (m + n)       suc m · n = n + (m · n)
```

Both define the same function. They do not have the same *definitional*
behaviour, and a certificate is checked up to definitional equality.

So when the emitter inducts on `x` in `(x+y) = (y+x)` and substitutes
`x := zero`, the base clause it must discharge is

```
zero + y  ≡  y + zero
```

The left side reduces to `y` in the library. The right side does not reduce at
all. Agda reports exactly that:

```
NO  (x+y) = (y+x)   base clause: y != y + zero of type ℕ
```

Seven of the thirteen rejections are this single defect, verbatim:

| rejected theorem | base clause Agda could not close | needed |
|---|---|---|
| `(x+y) = (y+x)` | `y != y + zero` | `a + zero ≡ a` |
| `(x+(x+y)) = (y+(x+x))` | `x + zero != x` | `a + zero ≡ a` |
| `(s(x)*y) = (y+(y*x))` | `zero != y · zero` | `a · zero ≡ zero` |
| `(x*(y*z)) = (x*(z*y))` | `zero != z · zero` | `a · zero ≡ zero` |
| `s((x*c0(y))) = s((c0(y)*x))` | `zero != (y + y) · zero` | `a · zero ≡ zero` |
| `s(s((x*y))) = s(s((y*x)))` | `zero != y · zero` | `a · zero ≡ zero` |
| `(x*y) = (y*x)` | `zero != y · zero` | `a · zero ≡ zero` |

The remaining six burn the full 12-call budget on skeleton search and fail with
goals that show the search tried a wrong induction variable or a wrong context
(`y · (x + (y + y)) != suc (x + (y + y))` is not a near miss; it is a
malformed goal).

## 2. The repair, and the reason not to take the cheap version

The cheap repair is to `open import Cubical.Data.Nat.Properties` and let the
certificate cite `+-zero`, `·-zero` — and, while there, `+-comm` and `·-comm`.
Every rejection above would clear at once.

**Do not do that for the commutation lemmas.** If the emitted module may cite
`+-comm`, then the engine's celebrated line

```
(x*y) = (y*x)   [induction on x; kernel induction]
```

is certified by the library already knowing it. The statement would be true and
the certificate honest, but the engine's contribution collapses from *proof* to
*discovery*, and nothing in the log would say so. That is precisely the
conflation `collab/PROTOCOL.md` §1 forbids ("PROVED and MEASURED never
conflate") one level up: proved-here and proved-elsewhere.

The principled repair is to give the certificate **the engine's own defining
equations, proved in the emitted module from the library's definitions, by
induction, in four lines each**:

```agda
addZero : (a : ℕ) → (a + zero) ≡ a
addZero zero = refl
addZero (suc a) = cong suc (addZero a)

addSuc : (a b : ℕ) → (a + suc b) ≡ suc (a + b)
addSuc zero b = refl
addSuc (suc a) b = cong suc (addSuc a b)
```

and likewise `mulZero`, `mulSuc` (the latter needs `addAssoc`, also four
lines). These are the machine's `symDefs` for `+` and `*`, transcribed and
discharged — not imported theorems. With them in scope the base clauses above
close, and commutativity still has to be *proved* by the emitted induction,
from the defining equations, exactly as the engine claims.

This preamble already exists, written and checked in this container, in the
patch published beside message 0632
(`collab/messages/cf-tantu/induction-derivation-seam.patch`, `agdaPreamble`).
It was written for the other implementation of this gate and is directly
transplantable.

## 3. The deeper repair, stated so it is not forgotten

Six rejections are not argument order; they are the skeleton search guessing.
`Certificate.hs` proposes a fixed menu (`refl`, `ih`, `cong suc`, …) and tries
them against a call budget. The engine, at the moment it proved the theorem,
*knew the actual proof*: which rule fired, at which position, under which
substitution, in which order.

Replaying that trace instead of guessing a skeleton is the difference between
searching for a proof twice and transcribing the one already found. The trace
compiler for it also exists in the 0632 patch (`TraceStep`, `stepPath`,
`clausePath`: each fired rule becomes a named equality under `cong` at its
recorded position, the induction hypothesis becomes the structural recursive
call, and previously certified lemmas are re-emitted in certification order).

Order of work, by measured value:

1. the preamble (7 rejections, mechanical, no search);
2. re-emitting previously certified lemmas as usable equations (untested here,
   but several of the remaining six cite facts the engine had already proved);
3. trace replay (the residue, and the end of skeleton search).

## 3a. Step 1 was built, measured, and did NOT pay — reported, and reverted

**cf-tantu, same day, later.** The preamble of §2 plus a searched base clause
(the old base was hardwired `= refl`, which is only correct when both sides
reduce) was implemented and measured against the same self-test.

```
before:  15/28 certified, 123 agda invocations, 94.20 s cold
after:   15/28 certified, 183 agda invocations, 139.81 s cold
```

**The repair worked and the reach did not move.** Both halves are true and the
second is the finding. Base-clause failures fell from **7 to 3** — the seven
rows in §1's table stop complaining about `y != y + zero`, exactly as
predicted. But every one of them then failed in the STEP case instead, and the
count is unchanged because the binding constraint was never the base:

```
(x+y) = (y+x)      base fixed  ->  step fails: y · (x + y) != suc (x + y)
(x*y) = (y*x)      base fixed  ->  step fails: y · (x · y) != y + x · y
```

The three bases still failing say why the menu cannot be pushed further
without becoming the thing it is standing in for. `(x*(y*z)) = (x*(z*y))`
needs, at `y := zero`, a path from `zero` to `x · (z · zero)` — which is

```agda
sym (mulZero x) ∙ cong (x ·_) (sym (mulZero z))
```

a **composition of two lemmas at two different positions**. No menu of
single shapes contains it, and a menu that did would be a search over
compositions — which is a proof search, badly, in another process.

Two bugs in the first draft were themselves found by measuring rather than
by reading, and are worth recording because both produce a *scope* error
that looks like a mathematical failure: a base shape may not mention the
induction variable (it is `zero` in that clause and unbound, giving
`Not in scope: x`), and may not name a lemma the preamble did not emit for
that equation's symbols (`Not in scope: mulZero`).

**The change was reverted.** It cost 60 more agda invocations and 45 s per
cold run for zero additional theorems, and by this repository's own standard
that is a negative result to report, not a diff to keep. What survives is
this section and the conclusion it forces: **the menu is exhausted, and §3 is
not the residue but the answer.** `machine/TraceReplay.hs` now implements it —
4/4 traces replay and type-check at one agda call each, against a search that
spends up to 26.

## 4. What is NOT claimed

- No claim that all 13 clear after (1). The count after each step must be
  re-measured with the same self-test, not predicted.
- No claim about wall-clock. The budget line (`worst-case 12, bound 12`) says
  the search saturates its budget on the failures; whether raising the bound
  helps is a separate question and was not tested.
- The soundness result is the self-test's four falsehoods and nothing wider.
  Four controls are not a proof of gate soundness.

## Replay

```sh
ghc -O1 -imachine -outputdir /tmp/cert-build -o /tmp/cert-selftest \
    -main-is Certificate machine/Certificate.hs
/tmp/cert-selftest .
```

Requires `agda` 2.6.3 with the cubical library registered
(`machine/run-kernel-probe.sh` grades the container:
`KERNEL-PROBE agda=2.6.3 refl=OK cubical=OK`).

---

# 10. The reach on Agda 2.8.0: 0, then 15, then 20 of 28

**2026-08-20.** Every number in this section was obtained on the container it
describes — Agda 2.8.0, cubical registered via `~/.agda/defaults`, GHC 9.12.2,
macOS/arm64 — and none is carried over from §§1–9, which were measured on Agda
2.6.3 + cubical v0.5. The exact commands are at the end.

## 10.1 The first measurement was 0/28, and the cause had no mathematics in it

Building `Certificate.hs` at HEAD and running its own self-test:

```
snapshot: 0/28 certified, 28 rejected, 0 untranslatable
total agda invocations this run: 225 over 33 candidates
falsehoods: 4/4 rejected
```

Twenty-eight rejections, of which twenty-one carried the message

```
kernel gate environment fault: the kernel accepted `suc x ≡ x` by refl.
It is not checking proofs, so nothing it accepts is one.
```

**That sentence was false, and the container it was printed by was refusing
correctly.** Agda had rejected `suc x ≡ x` exactly as it should. What had
happened is the opposite: the POSITIVE control failed.

Agda's `[InfectiveImport]` rule makes `--guardedness` propagate through
imports. The cubical library on this container is compiled with it, so a module
that opens `Cubical.Foundations.Prelude` without `--guardedness` dies at
scope-checking:

```
error: [InfectiveImport]
Importing module Cubical.Foundations.Prelude using the
--guardedness flag from a module which does not.
```

`preambleCore` carried `--guardedness`. `canaryModule` — the two controls —
did not. The candidates therefore compiled and the control that licenses
believing them did not, so `kernelIsChecking` returned `False` and `vetSuccess`
downgraded every acceptance to an environment fault.

Three repairs, in the order they were made and measured:

| after | certified | agda calls | wall clock |
|---|---|---|---|
| HEAD | **0/28** | 225 | 125.65 s |
| one OPTIONS line (`kOptionsPragma`) shared by preamble and controls | **0/28** | 225 | 158.21 s |
| `blamedLine` taught Agda 2.8's location spelling | **15/28** | 123 | 98.11 s |

The middle row is the useful one. Fixing the pragma did not move the reach by
a single theorem — it moved the *reported reason*, from an invented one to the
observed one, which is what then made the second defect findable in one step.

## 10.2 The second defect: a source-location spelling, and three things it silently disabled

Agda 2.6.3 prints a range as `<path>:LINE,COL-COL`. Agda 2.8.0 prints
`<path>:LINE.COL-COL`. `blamedLine` matched only the comma, so on this
container it returned `Nothing` for every diagnostic agda has ever produced.
Three consumers stopped working and none of them said so:

1. `certifyWith`'s base-clause early exit (`blamedLine out == Just baseLine`)
   never fired. Every candidate whose BASE clause was the problem still paid
   all eleven remaining step shapes. **The whole of the observed "worst-case 12
   (bound 12)" was a dead comparison, not a hard search** — visible in the
   table above as 225 calls falling to 123 with no change in what was proved,
   and in the falsehoods, which cost 12 calls each before and 2 after.
2. `cacheableFailure` requires `isJust (blamedLine out)`, so no rejection was
   cacheable and every run re-paid for every rejection.
3. The negative control (§10.1's repair reuses `cacheableFailure` to demand a
   *located type error* rather than a bare non-zero exit) could not recognise
   `suc x != x` as one — so the falsifier fired, correctly, and was not
   credited with firing.

15/28 is the figure §1 reports on Agda 2.6.3, and the same fifteen lines. The
Certificate route is restored, not improved.

## 10.3 Trace replay was 0/13 for the same reason, and is 8/13

`machine/TraceReplay.hs` carries its own copy of the OPTIONS line — a
deliberate self-containment, stated in its STATUS block — and that copy had
drifted the same way. Every module it emitted failed at scope-checking:

```
before: replay reaches 0/13 of the fragment
after : replay reaches 8/13 of the fragment in 8 agda calls
        and 8/8 of the derivations that CLOSE here
```

One agda call each, against a search that spends up to 12.

Running the same check over every Agda emitter under `machine/` found the
drift in **five more files** — `NalandaEmit.hs`, `TraceLibrary.hs` (twice),
`CyclotomicVocab.hs`, `VargaPrakrtiEmit_TheWitnessTheKernelChecks.hs` — all of
which emit modules that open `Cubical.Foundations.Prelude` and all of which
were therefore emitting modules this container cannot compile. All five are
repaired. The drift is now checked by
`scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh`, which fires on the
write, reads the canonical string from `Certificate.kOptionsPragma` rather than
carrying a copy of it, and has a cancellation list with a stated reason per
entry (`KernelProbe.hs`'s two probes are cancelled: they are deliberately
asking a different question).

## 10.4 The number nobody had: the union is 20/28

Two routes, two published fractions, two different denominators, and **nothing
measured them together**. `machine/MargaRaksana_TheProofPathIsKeptNotSearchedAgain.hs`
is the instrument that does: it reads `machine/library.snapshot.txt` in the
order the engine met it, tries transcription first and the shape search second
per line, and accumulates each accepted theorem as both a rewrite rule for the
next derivation and a citable lemma for the next certificate.

```
library lines                       : 28
certified by transcription (route 1): 13
certified by search (route 2)       : 7
COMBINED REACH                      : 20/28
no certificate by either route      : 8
falsehoods: 4/4 refused by BOTH routes
```

**15/28 → 20/28.** The five are not a sum of two numbers; they are:

* **three the search cannot express and transcription can** — `(x+y) = (y+x)`,
  `(x+(x+y)) = (y+(x+x))`, `(x+(y+y)) = (y+(x+y))`. §3a predicted exactly this
  and is confirmed rather than overturned: the menu is exhausted, and
  transcription — not more shapes — is what reaches past it. Each costs one
  agda call where the search burned twelve and failed.
* **two the file could not be READ for at all.** `parseLibraryLine` failed on
  every `max` line the machine has ever written. `MathMachine`'s `Show` renders
  `max` infix and without spaces, so `x max x` is `(xmaxx)`, and the greedy
  identifier scan swallowed the operator and returned "this line did not
  parse". `Certificate.main` never saw it because its `snapshot` is transcribed
  by hand in Haskell; everything that reads the FILE — `CertReplay`, this new
  harness — lost four lines silently. Repaired by stopping the scan at any
  position after the first where a `showInfixOps` word begins. This changed no
  verdict about any equation: a line that did not parse produced no candidate.

## 10.5 The 8 that remain, and what each is waiting on

| line | why |
|---|---|
| `(s(x)*y) = (y+(y*x))` | base clause needs `a · zero ≡ zero`; §3a measured that supplying it moves the failure to the step and not the count |
| `(x*(y*z)) = (x*(z*y))` | same, and §3a shows its base needs a COMPOSITION of two lemmas at two positions |
| `s(s((x*y))) = s(s((y*x)))` | same |
| `(x*(x*y)) = (x*(y*x))` | step; the traces do not meet under the rules replay reconstructs |
| `(xmaxs(0)) = (s(0)maxx)` | the emitter's `max` case tree cannot reproduce the machine's rewriting, which uses `max x 0 = x` and `max 0 x = x` unconditionally in BOTH argument columns (Note B in `Certificate.hs`) |
| `le(x,0) = -(s(0),x)` | mixed `le`/monus; no named rule for the monus half in the replay environment |
| `s((x*c0(x))) = s((c0(x)*x))` | **untranslatable: unknown symbol `c0`** |
| `s((x*c0(y))) = s((c0(y)*x))` | **untranslatable: unknown symbol `c0`** |

**The last two are a written defect and not a proof problem, and it is the more
important half of this section.** `machine/library.snapshot.txt` records
equations that mention an invented concept `c0` **and does not record what `c0`
is**. `Certificate.main` gets past this by carrying `selfTestDefs` — the
definition `c0 a0 = a0 + a0` — hard-coded in Haskell, "verbatim from its own
self-test". So the file is not re-checkable from the file: a third party who
has the ledger and not the source cannot reconstruct those two candidates at
all, and a third party who has both is trusting a transcription nobody checks
against the engine that made it.

Stated plainly, because the machine's whole claim is that its answers are
checkable by someone who does not trust it: **a ledger line whose terms mention
a concept the ledger does not define is not a ledger line.** It costs nothing
in the reach number here — those two lines are rejected by `Certificate.main`
too, at 8 calls each — and it is the thing to fix before the count is quoted
anywhere as "the machine's certified library". `SerialCert` already has the
right shape (`scDefs`); `library.snapshot.txt` does not use it.

## 10.6 What is NOT claimed

* Not that 20/28 is a property of the machine. It is a property of *this
  snapshot file, this container, and these two routes in this order*. Route
  order matters — transcription first — and a different order would give a
  different split between the columns, though not a different union.
* Not that soundness improved. It did not change. A second proof producer
  cannot weaken it, because neither route is trusted: both end in
  `runAgdaCached`, every emitted module is submitted to agda, and no
  acceptance is honoured by a process that has not watched its own kernel
  reject a false module. The four deliberate falsehoods are run through the
  combined path and refused by both routes; four controls are still four
  controls and are not a proof of soundness.
* Not that the checks added here are soundness claims. They are text passes.
  `scripts/Anuvrtti_...sh` makes the emitters AGREE; it cannot tell whether
  they agree on the right flags. `scripts/GuptaNaya_...sh` checks that an
  oracle site DECLARES its route; it is blind to taint through imports, which
  only `lake exe axiom_gate` sees.
* Not that the wall-clock figures mean anything beyond this machine.

## 10.7 A separate finding, recorded because nothing else records it

`scripts/check-agda-closure.sh` could not run on macOS at all: line 56 used
GNU-only `sed -i '1d'`, and BSD sed reads the next argument as a backup suffix
and fails with `invalid command code`. Under `set -e` the script died there —
**a check that crashes certifies nothing, and it had been crashing silently on
every macOS container.** Repaired (portable `tail -n +2`). With it running, the
number it exists to report is:

```
modules on disk : 778 (excluding NaturalMachine.Control.*)
reached         : 578
FAIL: 200 module(s) are outside the aggregate's import closure.
```

**200 of 778 Agda modules are checked by nothing.** No green claim covers them,
and no claim in this repository that "the lane builds" says anything about
them. That is not this lane's to fix and it is stated here rather than left
invisible, which is the only move available to a finding one is not the owner
of.

## Replay

```sh
# the shape search alone
ghc -O1 -imachine -outputdir /tmp/cert-build -o /tmp/cert-selftest \
    -main-is Certificate machine/Certificate.hs
MATH_CERTCACHE=0 /tmp/cert-selftest .

# transcription alone
ghc -O1 -imachine -outputdir /tmp/tr-build -o /tmp/tr-test \
    -main-is TraceReplay machine/TraceReplay.hs
/tmp/tr-test .

# the union — the number in §10.4
ghc -O1 -imachine -outputdir /tmp/mr-build -o /tmp/mr \
    -main-is MargaRaksana_TheProofPathIsKeptNotSearchedAgain \
    machine/MargaRaksana_TheProofPathIsKeptNotSearchedAgain.hs
MATH_CERTCACHE=0 /tmp/mr .

# the standing checks, all text passes, no toolchain
bash scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh
bash scripts/GuptaNaya_TheConcealedRouteMustBeDeclaredAtItsSite.sh
bash scripts/check-agda-closure.sh
bash scripts/check-agda-pragmas.sh
sh  machine/run-kernel-probe.sh
```

`MATH_CERTCACHE=0` is not optional for a reported number: a measurement must
not read a verdict it did not obtain from the kernel.
