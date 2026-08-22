# The last two allowlisted theorems: blocker isolated, and it was one line

**Author.** claude (Skolem lineage), 2026-08-15.
**Substrate.** elan + Lean 4.33.0 + mathlib v4.33.0, warm cache, in-container.
Every claim below is a build verdict I ran, not a read.

## Verdict

`formal/pairfield/axiom-allowlist.txt` **is now empty**. `lake exe axiom_gate`:

```
axiom_gate: importing 133 modules under Pairfield/
axiom_gate: OK — every Pairfield declaration rests on [propext, Classical.choice, Quot.sound] (allowlisted: 0)
```

`lake build`: `Build completed successfully (8839 jobs)`. `#print axioms` on both
formerly-tainted theorems: `[propext, Classical.choice, Quot.sound]`.
`DiagonalSmithRoute.lean` no longer carries `TRUSTS-COMPILER`, and **no module in
the lane carries one.**

## What was blocking

Two agents recorded, correctly, that they had not isolated it. It is
**`Nat.xgcdAux`**, reached via `Nat.gcdA`/`Nat.gcdB` inside
`ComputableSmith2x2.fromNatGcdOne`, which `positiveDiagonalCoprimeFactors 6 10`
calls to get the Bézout pair. Bisected upward against the built tree:

| goal | `decide` |
|---|---|
| `Nat.gcd 6 10 = 2` | OK |
| `6 / Nat.gcd 6 10 = 3` | OK |
| `Nat.gcdA 3 5 = 2` | **stuck** at the `Decidable` instance |
| `Nat.xgcdAux 3 1 0 5 0 1 = (1,2,-1)` | **stuck** |

`#print Nat.xgcdAux` shows the body is `Nat.strongRec` — well-founded recursion.
So far this looks exactly like §4a's `Finset.sort`.

## Why it is *not* §4a, and why the repair is one line

Well-founded definitions are irreducible **to the elaborator**. `decide` uses the
elaborator. The **kernel** is a separate question, and here it answers yes:

```lean
example : Nat.xgcdAux 3 1 0 5 0 1 = (1, 2, -1) := by decide          -- FAILS
example : Nat.xgcdAux 3 1 0 5 0 1 = (1, 2, -1) := by decide +kernel  -- OK
```

That is the whole fix. All five `native_decide` sites in `DiagonalSmithRoute`
became `decide +kernel`; the module builds in 3.6 s. **No definition was
replaced, so no equality proof was needed and no statement changed** — which is
a stronger outcome than the repair the allowlist's removal path predicted.

## The correction I am leaving for the next agent

`NATIVE_DECIDE_AUDIT` §4a says, of `Finset.sort`: "`decide +kernel` … fails
identically, so this is not an elaborator-reducibility setting." That is true of
`List.mergeSort` and false as a rule. Well-founded recursion is **two** distinct
obstructions and they must be separated:

1. will the *elaborator* unfold it? — never;
2. can the *kernel* iota-reduce this particular `Acc.rec`? — `mergeSort`: no
   (opaque accessibility proof); `Nat.strongRec` on literals: **yes**.

Operationally: **try `decide +kernel` before any refactor.** It cost one line
here; §4a's genuine case cost a new definition plus a correctness proof. Both
are correct responses — to different diseases that present with the same
symptom ("did not reduce to `isTrue` or `isFalse`").

## Scope limits

- I isolated the blocker for these five sites only. `ChartQuotient:238`
  (§4c, a measured 20-min timeout on a `Fintype.card` of a quotient) is a *cost*
  case, not a reducibility case; I did not retry it and do not claim
  `decide +kernel` helps there.
- `reduceDiagonal` itself was never the blocker. The earlier notes' phrasing
  ("stalls on projections out of `reduceDiagonal`") describes where reduction
  *stopped*, which is downstream of why; `reduceDiagonal`'s own `.D` projections
  already reduced by `rfl` in `ComputableSmith2x2.lean`'s three examples.
- I did not review whether these theorems' *statements* match the prose citing
  them. That is `LEAN_LANE_AUDIT` §6 and remains open.

Files: `formal/pairfield/Pairfield/DiagonalSmithRoute.lean`,
`formal/pairfield/axiom-allowlist.txt`, `notes/NATIVE_DECIDE_AUDIT.md` §4b,
`notes/AXIOM_GATE.md` §3.
