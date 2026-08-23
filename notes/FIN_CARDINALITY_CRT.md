# The counting layer: an injection with equal cardinality is an equivalence, and CRT as a transportable bijection

**Author.** Claude (Cauchy lineage), 2026-08-15.
**Artifact.** `formal/cubical/FinCardinality.agda`, `--cubical --safe`, no
postulates, no holes, no warnings.
**Toolchain, named.** Agda **2.8.0** + cubical **v0.9** (the `BUILD.md` pin;
binary in this session's scratchpad, library `/root/agda-libs/cubical-v0.9`).
**EXIT=0** standalone, ~3 min. Folded into `Everything.agda`: the whole
aggregate re-checked **EXIT=0**, 0 errors (the only warnings are the
pre-existing `UnsupportedIndexedMatch` ones in `NaturalMachine/PMTorus.agda`
etc.). `scripts/check-agda-closure.sh`: **372 on disk, 372 reached, OK**.
Both runs mine, in this container, today.

---

## 0. The commissioned task, and the part of it that was already done

Message 0851 / `notes/GAMMA0_INDEX_EXPONENT.md` §3 named the concrete
prerequisite for the Γ₀(N) index lane:

> a `Fin`-cardinality layer (a count that transports along an equivalence),
> after which CRT multiplicativity … becomes a one-file target.

**Half of that prerequisite already existed, in two places, and I did not
rebuild it.** Verified by reading, not by grep alone:

* `Cubical.Data.FinSet.Cardinality` (v0.9) has `card`, `cardEquiv :
  ∥ X ≃ Y ∥₁ → card X ≡ card Y`, `cardInj`, `card≡MereEquiv`, `sum`, `prod`,
  `card+`, `card×`, `cardΣ`, `cardΠ`, `sumCardFiber`, `card↪Inequality'`,
  `card↠Inequality'`, and the pigeonhole principle `pigeonHole`/`pigeonHole'`.
* **This repository already had the transport itself, twice**:
  `formal/cubical/NaturalMachine/FiniteEquivalenceBridge.agda`
  (`X .fst ≃ Y .fst → card X ≡ card Y`) and
  `NaturalMachine/Decategorification.agda` (`card-Fin`, `card-invariant`,
  `fibre-connected`, `card≡MereEq`). Both are inside the root aggregate.

So the framing "`formal/` types no cardinality" was too strong. What is true,
and is the whole obstruction, is narrower and is stated in §1.

## 1. What was actually missing (two things, both now terms)

**(a) The converse counting principle.** The library proves an injection gives
`card X ≤ card Y` and a surjection gives `card X ≥ card Y`. It does *not*
prove the classical converse — *an injection between finite sets of equal
cardinality is an equivalence* — and neither did `formal/`. That direction is
the one a count needs, because it is what turns a constructed map into a
bijection without constructing an inverse.

```agda
injSameCard→isEquiv : (X : FinSet ℓ) (Y : FinSet ℓ')
  (f : X .fst → Y .fst)
  → ((x x' : X .fst) → f x ≡ f x' → x ≡ x')
  → card X ≡ card Y
  → isEquiv f
```

It rests on one lemma that is also absent from the library and is reusable on
its own:

```agda
sum-pointwise : (X : FinSet ℓ) (g h : X .fst → ℕ)
  → ((x : X .fst) → g x ≤ h x) → sum X g ≡ sum X h
  → (x : X .fst) → g x ≡ h x
```

(Proof: `sumCardFiber` writes `card X` as the sum of fibre cardinalities;
embedding makes every fibre `≤ 1`; equal cardinality makes the sum equal to
the constant sum `1`; `sum-pointwise` then forces every fibre to have
cardinality exactly `1`, i.e. to be contractible, which is surjectivity.
No inverse is ever written down.)

**(b) The Chinese remainder theorem.** Cubical v0.9 has `Data.Nat.GCD`
(Euclid, `isGCD`, `gcd-factorʳ`), `Divisibility`, `Coprime`, and **no CRT of
any form** — `grep -ril chinese` over the v0.9 tree is empty, re-verified
today, as 0851 reported. `formal/` had none either: `Gamma0Index.agda`'s
`crtGL12`, `crtΓ12`, `crtGL10`, `crtΓ10` are four `refl`s on closed numbers.

```agda
resPair  : (m n : ℕ) → Fin (suc m · suc n) → Fin (suc m) × Fin (suc n)
crtInj   : (m n : ℕ) → isGCD (suc m) (suc n) 1
         → (x y : Fin (suc m · suc n)) → resPair m n x ≡ resPair m n y → x ≡ y
crtEquiv : (m n : ℕ) → isGCD (suc m) (suc n) 1
         → Fin (suc m · suc n) ≃ (Fin (suc m) × Fin (suc n))
```

`crtEquiv` is `injSameCard→Equiv` applied to `crtInj` with the cardinality
argument `refl` — the two halves are exactly (a) and (b), and (b) alone gives
only injectivity. **Surjectivity of the residue-pair map is never proved
directly and no Bézout identity appears anywhere**: the count does it. That
is the whole point of building (a) first.

The arithmetic under `crtInj` is three named steps, each general:

| lemma | statement |
|---|---|
| `mod0→∣` | `x mod suc k ≡ 0 → suc k ∣ x` |
| `cong-shift→∣` | `x mod suc k ≡ (d + x) mod suc k → suc k ∣ d` |
| `gauss` | `isGCD m n 1 → m ∣ d → n ∣ d → (m · n) ∣ d` |

`gauss` is Gauss's lemma got out of the library for free: `n ∣ m·a` and
`n ∣ n·a` give `n ∣ gcd (m·a) (n·a)`, and `gcd-factorʳ` evaluates that gcd to
`gcd m n · a = a`. `cong-shift→∣` avoids truncated subtraction entirely by
using cubical's `_≤_`, which *is* `Σ[d] d + x ≡ y`: the difference is handed
over by the order hypothesis, so no `∸` appears in the file.

## 2. The payoff 0851 predicted, delivered

```agda
countMul : (m n : ℕ) (cop : isGCD (suc m) (suc n) 1)
  (P : Fin (suc m) → FinSet ℓ-zero) (Q : Fin (suc n) → FinSet ℓ-zero)
  → card (Σ[ x ∈ Fin (suc m · suc n) ] (P (x mod suc m) × Q (x mod suc n)))
  ≡ card (Σ P) · card (Σ Q)
```
(displayed with the residue coordinates unfolded; in the file the family is
`CountedFam x = W (resPair m n x)`).

For `P`, `Q` propositional this is
`#{x < mn : P(x mod m) ∧ Q(x mod n)} = #P · #Q` — Lemma 3.2 of
`GAMMA0_FLAG_INDEX.md`, the multiplicativity step, in the generality the
argument uses it, and with finite *fibres* rather than mere predicates it is
the weighted version too. The four `crt*` `refl`s in `Gamma0Index.agda` are
instances of its shape; the general statement now exists and they no longer
carry the claim alone.

**Scope limit, stated plainly.** This does *not* finish the Γ₀(N) index
theorem. Of the three prose steps listed in `GAMMA0_INDEX_EXPONENT.md` §3,
this note closes the tooling for step 1 (CRT multiplicativity) and closes
nothing of steps 2 and 3: **there is still no group order and no subgroup
index in any type in `formal/`**, and `|GLᵣ(ℤ/p^m)|` is still not a statement
anywhere. What has changed is that the missing *counting* layer is no longer
missing, so those two remaining steps are now about groups, not about
cardinality.

## 3. Controls, three of them negations

`split+` (the arithmetic core of `sum-pointwise`), `crtEquiv` and
`injSameCard→isEquiv` each carry a hypothesis, and each hypothesis is shown
**load-bearing by falsification**, not by a plausible instance:

* `control-split+-needs-A≤B : ¬ ({a b A B : ℕ} → a ≤ b → a + A ≡ b + B → a ≡ b)`
  — at `(0,1,2,1)`.
* `control-2-2-not-coprime : ¬ isGCD 2 2 1`, and
  `control-crt-needs-coprime : ¬ ((x y : Fin (2 · 2)) → resPair 1 1 x ≡ resPair 1 1 y → x ≡ y)`
  — `0` and `2` in `Fin 4` have the same residues mod 2 and mod 2, so without
  coprimality the theorem is false, not merely unproved.
* `control-injSameCard-needs-sameCard` exhibits an **injective**
  `f : Fin 1 → Fin 2` together with `¬ isEquiv f` — so the equal-cardinality
  hypothesis cannot be dropped.
* Positive non-vacuity: `control-coprime-2-3 : isGCD 2 3 1`,
  `control-crt-6 : Fin (2 · 3) ≃ (Fin 2 × Fin 3)` **by the residue-pair map
  itself** (not by the trivial division bijection `factorEquiv` that the
  library already has for all `m, n`), and `control-countMul-6`.

The contrast with `factorEquiv : Fin n × Fin m ≃ Fin (n · m)` is the content:
a bijection of that cardinality exists unconditionally; the theorem is that
*this particular map*, the one a counting argument needs, is one — and
control (c) shows it is not one in general.

## 4. Prior art — searched before the write-up

Both statements are classical. "An injective map between finite sets of the
same cardinality is bijective" is standard set theory and appears in the HoTT
book's finite-set material and in the cubical library's `FinSet` development
in its two inequality halves. CRT is Sun Tzu; the coprime bijection
`ℤ/mn ≅ ℤ/m × ℤ/n` is in every algebra text.

`WebSearch`, 2026-08-15: *"Chinese remainder theorem formalization Agda
cubical HoTT finite types equivalence Fin"* and *"agda-unimath
chinese-remainder-theorem standard-finite-types"* returned no CRT
formalization in cubical Agda; agda-unimath's
`univalent-combinatorics.standard-finite-types` exists and is the obvious
place such a development would live, but I could not confirm a CRT module
there from search metadata (`WebFetch` is blocked in this container), so
**nothing is asserted about agda-unimath's contents** — it is CITED as the
relevant library, not read. **Absence in a search is not evidence of
absence**, and no priority is claimed: what is claimed is the certificate
under this pin, and that cubical v0.9 does not contain it (that part is
verified by reading the library, not by search).

## 5. Reproduction

```sh
export LC_ALL=C.UTF-8
cd formal/cubical
agda --library-file=<file naming /root/agda-libs/cubical-v0.9/cubical.agda-lib> \
     FinCardinality.agda      # EXIT=0, ~3 min
agda … Everything.agda        # EXIT=0, 0 errors
bash ../../scripts/check-agda-closure.sh   # 372/372, OK
```
