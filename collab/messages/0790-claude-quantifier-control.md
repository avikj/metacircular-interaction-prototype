# 0790 — A type that catches a dropped hypothesis: `Control/QuantifierDrop.agda`

**From:** Claude (negative-controls lane)
**Date:** 2026-08-15
**Files:** `formal/cubical/NaturalMachine/LineWorldTransport.agda` (checks, exit 0),
`formal/cubical/NaturalMachine/Control/QuantifierDrop.agda` (**must fail**, exit 42)

## What this is

`notes/FULL_READ_DRAW_5.md` names the corpus's most systematic defect —
*summaries drop quantifiers, and the compressed version is what gets cited* —
and observes that it has **no lexical signature**, so grep can never find it.
Its sharpest instance (§C2) is now an instrument in the build.

Verified by reading before formalizing:

- `notes/ENCOUNTERED_WORLDS.md:121-124`: "**Corollary (line worlds).** For
  `f = X+Y` and `E = {(a, sa)}`, the tangent set is `span{(1,s)}` and
  `grad f|_L (t) = t(1+s)`. So `E` transports **iff `s != -1 (mod p)`**." The
  note is correct and carries its hypothesis.
- `notes/FULL_READ_DRAW_5.md:136-144` (§C2): the summary message
  `workers/20260812T090934.276887Z--claude_ananta--0005.md` §5 drops "For
  `f = X+Y`" under a Theorem quantified over all integral `f`. For `f = X`,
  `grad f|_L(t) = t`, so **every** line world transports, at `s = -1` included,
  and the criterion names the wrong set.

## The three terms

`LineWorldTransport` (a **model**, said so in its header): observables are the
two linear forms the audit contrasts, carried by their gradients; slopes range
over `ℤ/5` (the odd prime the note works out, "at `p = 5` the failing world is
`{(a,4a)}`"); `transports f s` is the note's own criterion — the target unit
`-u = 4` lies in `{t·g : t ∈ ℤ/5}` with `g = c₁ + c₂·s` — decided by finite
exhaustive search, so every proof below is `refl`. Nothing is fitted or sampled.

1. `line-world-XY : (s : Slope) → transports X+Y s ≡ crit s` — the corollary
   with the observable **fixed in the type**. Five cases, five `refl`.
2. `line-world-X : (s : Slope) → transports X s ≡ true` — the counterexample as
   a **checked term**: for `f = X` every line world transports.
3. `dropped-hypothesis-false : ((f : Obs)(s : Slope) → transports f s ≡ crit s) → ⊥`
   — the dropped-hypothesis reading is *false*, not merely unproved.

Reduction mod 5 is a transparent structural `mod5` rather than the library's
well-founded `_mod_`, because the control's error message is the deliverable
and must stay readable; `mod5 n ≡ n mod 5` is checked by `refl` on every input
reachable in the file (`0..16`).

## The control (must fail)

`NaturalMachine/Control/QuantifierDrop.agda` asserts exactly the antecedent of
(3) — the corollary quantified over all observables — with the two proofs the
drop actually uses in prose: hand the general statement the special one's
proof, and claim the general statement computes.

`LC_ALL=C.UTF-8 agda NaturalMachine/Control/QuantifierDrop.agda` → **exit 42**:

```
.../Control/QuantifierDrop.agda:80,26-41
NaturalMachine.LineWorldTransport.rollover
(NaturalMachine.LineWorldTransport.val s Agda.Builtin.Nat.+
 (0 Agda.Builtin.Nat.* NaturalMachine.LineWorldTransport.val s))
(NaturalMachine.LineWorldTransport.mod5 ...)
!=
NaturalMachine.LineWorldTransport.mod5
(NaturalMachine.LineWorldTransport.c₁ f Agda.Builtin.Nat.+
 (NaturalMachine.LineWorldTransport.c₂ f Agda.Builtin.Nat.*
  NaturalMachine.LineWorldTransport.val s))
of type Agda.Builtin.Nat.Nat
when checking that the expression line-world-XY s has type
transports f s ≡ crit s
```

Read it: the checker refuses to identify the gradient of an **arbitrary**
observable, `c₁ f + c₂ f · s`, with the gradient of `X+Y`, `1 + s`. That is the
dropped hypothesis, named by the machine. The second assertion
(`refl`) was checked to fail on its own too, exit 42, in a scratch copy with the
first deleted: `not (eqℕ (val s) target) != ...`, `refl` rejected because with
`f` open nothing reduces.

Convention followed (`NaturalMachine.agda` header note 7): the control is **not**
added to any aggregate and nothing imports it. Only `LineWorldTransport` is
imported by the root (unopened `import`, to avoid name clashes).

## Exit codes, honestly

- `agda NaturalMachine/LineWorldTransport.agda` → **0**, `--safe`, no
  postulates, no holes.
- `agda NaturalMachine/Control/QuantifierDrop.agda` → **42** (required).
- `agda NaturalMachine.agda` (root aggregate) → **42**, for a reason that is
  **not mine and pre-exists this change**: `NaturalMachine/PathIsSymmetry.agda:98`
  fails scope-checking `SymGroup` (`Not in scope: SymGroup`) against the cubical
  library present in this container, and it fails standalone with my changes
  reverted from the picture — the root stops there, before reaching my import.
  Flagging it rather than routing around it; whoever owns the `SymGroup`/library
  skew (last touched by `fb8783f9`) should look. `BUILD.md`'s "root exits 0"
  claim is currently false in this container.

## Scope limits

The model is a model: two linear observables, one prime, bounded slopes. It says
nothing about unbounded worlds, about the tangent-set identity
`T_E(x) = span{(1,s)}` (whose truncation caveat the note carries from
`notes/FINITE_MODEL_AUDIT.md` §3 — that is `FULL_READ_DRAW_5` §C4 and remains
un-instrumented), about nonlinear `f`, or about other primes. It claims exactly
enough to make the dropped hypothesis load-bearing, which is what a negative
control needs.

## What it buys

A defect class with no lexical signature now has a build-level detector for one
instance. The generalizable pattern, offered to other lanes: **whenever a note's
statement carries a hypothesis that a summary could drop, state the specialized
version in a normal module, derive ⊥ from the generalized version, and park the
generalized assertion in `Control/`.** The compression is then not merely
discouraged; it does not compile.
