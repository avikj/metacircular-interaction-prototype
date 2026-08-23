# Goldbach and twin primes are two fibrations of one field — and the involution exchanging them destroys the positivity that makes them arithmetic

**Status:** machine-checked, `--safe`, exit 0, no postulates or holes, first
compile. **Proves nothing about Goldbach or twin primes.**

**Code:** `formal/cubical/PrimePairField.agda`.
**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14. Discharges Delta 23 §12.

---

## 1. What this is not

Delta 23 §2 writes Goldbach and twin primes as types. **Writing a conjecture as
a type is not progress on the conjecture.** `Goldbach` and `Twin` in the module
are *definitions* — restatements in dependent-type notation — and nothing here
proves, weakens, or bounds either.

`NATURAL_MACHINE.md`'s own standard is the one to apply: *an asserted
isomorphism is not transport.* The dual for this note is: **a definition is not
a theorem.** Delta 23 §14 says the same thing about itself ("None of this proves
Goldbach, twin primes, or their independence"), and §11 is blunter and correct:
*"Nothing in the current library yet supplies Θ."* That remains true after this
note.

## 2. What is content

Delta 23 §2 makes an exact, checkable claim: Goldbach and twin primes are
**"transverse global properties of the support of one dependent type"**, and §3
identifies the two foliations as the anti-diagonal (fixed centre) and the
off-diagonal (fixed gap). That claim is now checked, and it comes with an
obstruction the delta does not state.

Over any primality predicate — the structural results do not depend on how
primality is decided, so it is a parameter and no arithmetic is smuggled in:

```agda
PrimePair = Σ[ p ∈ ℤ ] Σ[ q ∈ ℤ ] ((IsPrime p × IsPrime q) × (Pos p × Pos q))
toCR x    = Φraw (p , q)          -- centre = p+q, gap = q−p
```

**Checked:**

- `fibreCentre` — the centre fibration is the first light-cone coordinate:
  `u₋ (toCR x) ≡ p + p`. Fixing the centre fixes `p+q`.
- `fibreGap` — the gap fibration is the second: `u₊ (toCR x) ≡ q + q`.
  These are `thm17-1-lower/upper` from `CenterRelative`, reused not reproved.
  So Delta 23 §3's two foliations **are** Delta 16's two light-cone coordinates,
  definitionally.
- `inCone` — every prime pair lands in the **open positive cone**, since both
  legs are positive and doubling preserves positivity.
- **`noSelfDualPair`** — for every prime pair `x`,
  `¬ InCone (J₂CR (toCR x))`.

## 3. The obstruction, stated plainly

Delta 16 Corollary 16.2: the one-leg reflection `J₂` carries the fixed-centre
foliation to the fixed-relative foliation. **That is exactly the exchange
Delta 23 §3 wants between Goldbach and twin primes** — sum slices to gap slices.

But `thm16-4` proves `J₂` cannot preserve the positive cone, and `inCone` proves
every prime pair is in it. Composing:

> **The involution that would carry Goldbach's fibration onto the twin
> fibration is exactly the one that destroys the positivity making them
> arithmetic statements.** No prime pair's image survives the exchange.

By contrast `exchangeStays` checks that the leg exchange `τ` — the Weyl
reflection — *does* preserve the cone, so it is an honest symmetry of the field.
The two involutions are not interchangeable, and this is precisely where they
part.

**Why this matters for Delta 23's programme.** §2 concludes the two conjectures
"are not separate curiosities". True, and now checked. But the natural next
hope — that being two projections of one object makes one reducible to the other
— is **blocked by a machine-checked theorem**, not by absence of effort. Any Θ
in the sense of §11 must therefore be a structure the *cone-preserving* symmetry
group sees, since the cone-exchanging one provably leaves the arithmetic sector.
That is a genuine constraint on Θ, and it is the first one the corpus has.

It also sharpens `FLEET_BREAKER_PASS_2026_08_14.md` §1.3's Gauss verdict: the
full similitude group of `Q = W²−R²` is dihedral of order 8, and the subgroup
that preserves the arithmetic sector is the index-2 kernel
`O(Q)(ℤ) = {±I, ±τ}`. **Θ must be an invariant of that kernel.**

## 4. Controls

The 2026-08-14 fleet audit found `CenterRelative.agda` was the only module in
the tree carrying its own non-vacuity controls. This module carries its own:

- `twin35` — the pair `(3,5)` under a two-element primality predicate;
- `centre-twin35 : centre twin35 ≡ pos 8` and `gap-twin35 : gap twin35 ≡ pos 2`,
  both by `refl`, so the coordinates compute;
- `twin35InCone` — §2's cone statement is about something inhabited;
- `twin35NotSelfDual` — §3's obstruction is about something that exists.

Without these, `noSelfDualPair` would be a true statement about a possibly empty
type, which is the failure mode `VACUITY_CERTIFICATES.md` names and which the
fleet pass found realised in `ObservationalClassCompiler`.

## 5. Rigor boundary

- **Checked:** every name in §2 and §4, Agda 2.6.3 + cubical v0.5, `--safe`,
  exit 0, no postulates, no holes.
- **Parameterised, deliberately:** primality. Nothing here decides it, and
  Delta 23 §12's `Prime_X` (decidable, bounded) is *not* implemented. Building it
  needs natural division, which cubical v0.5 does not obviously export; that is
  the first piece of real work if the finite approximants `𝒫_X` are wanted.
- **Not built:** the colimit structure of `{𝒫_X}` (§12's actual question), the
  charge certificates, and every chart in §11's table beyond the additive and
  translation ones. §11's Θ does not exist here.
- **No novelty.** The cone algebra is classical (`FLEET_BREAKER_PASS` §1.3:
  discriminant 4, class number 1). The type-theoretic packaging is routine. The
  one thing offered as new *to this repository* is the composition in §3 — that
  the Goldbach↔twin exchange and the cone obstruction are the same map — and
  even that is two existing checked theorems put in sequence.

## 6. On Delta 23's larger claim

§7 asks that a proof "emerge from a recursive process of representation
generation and univalent reconciliation". The honest report from tonight is that
the process ran, five times, and every time its highest-value output was
**identification and refutation**, not generation: one congruence found under
five vocabularies, eight refutations in one adversarial pass, three deferred
literature searches all confirming classical priority.

That is not a failure of the method — recognising that two things are one, and
that a claimed theorem is false, are exactly what §4's steps 4–7 call for. But
§10's diagnosis ("the sauce is the RECURSIVE MOVEMENT AMONG THEM") should be
held against the evidence: the movement has so far produced **boundaries**, and
Delta 23 §3's own thesis is that a boundary is a production rule. §3 of this
note is one such boundary, stated exactly. Whether it produces the next form is
not something a note can assert.

## 7. Successor seeds

1. `PROVE`: **Θ must be an invariant of `O(Q)(ℤ) = {±I, ±τ}`** (§3). This is a
   sharp, checkable constraint and it is the first the corpus has on §11's
   target. Enumerate what invariants that Klein four-group has on the pair
   lattice, and test each against the six charts of §11's table.
2. `PROVE`: build `Prime_X` decidably in cubical (needs natural division), then
   the finite `𝒫_X` and the structure maps `𝒫_X → 𝒫_{X'}`. This is §12's actual
   question and it is bounded work.
3. `DEMONSTRATE`: whether the cone obstruction has a Goldbach-side consequence —
   does `noSelfDualPair` say anything about the *counting* functions of the two
   fibrations, or only about the coordinates? I believe only the coordinates,
   and say so rather than implying more.
