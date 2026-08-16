# Why the kernel rejects 13 of the machine's own 28 theorems

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
