# Apavartana — the price of an integer cut is a function on Spec ℤ, not a number

**Status.** One integer cut priced end to end, with a checked term. Nothing
measured, no constant fitted, no floating point. Checked module:
`formal/pairfield/Pairfield/Apavartana_ThePriceOfAnIntegerCutIsAFunctionOnSpecZAndItsRamifiedPointsAreTheApavartanaAndTheLevel.lean`,
`lake build` exit 0, every theorem's `#print axioms` inside
{`propext`, `Classical.choice`, `Quot.sound`}. No `sorry`, no `admit`, no
`axiom`, no `native_decide`.

**अपवर्तन · apavartana** — reduction of a pair by a common divisor. Brahmagupta,
*Brāhmasphuṭasiddhānta* 18 (628); worked in Bhāskara II, *Bījagaṇita* (1150);
serving the kuṭṭaka of Āryabhaṭa, *Āryabhaṭīya* 2.32–33 (499). NOT "extended
Euclidean algorithm." **Claimed of the source: only the sense of the word** —
the common divisor removed from a pair. Not claimed: that Brahmagupta stated
Smith normal form, worked over Spec ℤ, or proved anything below.

## Cited, not re-derived

- `notes/SESA_THE_ALIGNMENT_DEFECT_IS_A_FIBRE_AND_WHEN_IT_IS_MUTUAL_INFORMATION.md`
  and `formal/cubical/Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd.agda`
  (`शेष : fiber (g ∘ f) z ≃ Σ[ p ∈ fiber g z ] fiber f (fst p)`, checked): a
  receipt for a lossy map is its fibre, named exactly.
- `notes/CAUSAL_MEMORY_SPACETIME.md` Thm 7.1,
  `rank(AB) = rank(B) − dim(im B ∩ ker A)` — rank–nullity on `A` restricted to
  `im B`, so the alignment defect **is** a fibre dimension.
- `notes/SMITH_TORSION_BOUNDARY_MEMORY.md`: over ℤ the classifying invariant is
  the Smith normal form, not the rank.
- **Fenced.** This does not read as entropy. Linear rank functions satisfy
  **Ingleton**; entropies do not, so the rank cone is a proper subcone. No
  pairing with Ryu–Takayanagi.

## The object

The Γ₀ stabilizer identity `H · D · K ≡ D` in `formal/cubical/Gamma0Partner.agda`
fixes the diagonal endpoint

    D = diag(d₁, q · d₁)

with `d₁` the **apavartana** (the content both entries share) and `q` the
**level** left after it is removed. Instance priced here: `d₁ = 2`, `q = 6`, so
`D = diag(2, 12)`.

## The receipt in full

`D` is diagonal with `2 ∣ 12`, so it is already in Smith order.

- **Smith divisors** `d₁ = 2 | d₂ = 12`; `det D = 24 = 2³ · 3`.
- **`rank_{𝔽_p}(D) = #{i : p ∤ d_i}`:**

| point of Spec ℤ | rank | drop from `rank_ℚ = 2` |
|---|---|---|
| `(0)` generic | 2 | 0 |
| `(2)` — the apavartana | 0 | **2** |
| `(3)` — the level | 1 | **1** |
| `(p)`, `p ≥ 5` | 2 | 0 |

- **Cokernel as a group.** `ℤ²/Dℤ² ≅ ℤ/2 ⊕ ℤ/12`: free rank **0**, torsion
  `ℤ/2 ⊕ ℤ/12`, order 24, exponent 12.

**One line.** *The receipt is the function `p ↦ rank_{𝔽_p}(diag(2,12))` on
Spec ℤ, equal to 2 off `V(24)`, ramified at exactly two points — `(2)`, the
apavartana, where it drops by 2 because the prime divides both divisors, and
`(3)`, the level, where it drops by 1 because it divides only the second — with
cokernel `ℤ/2 ⊕ ℤ/12`.*

## The general statement this instance is an instance of

For `D = diag(d₁, q·d₁)`, `d₁, q ≥ 1`:

    rank_{𝔽_p}(D) = 2 − [p ∣ d₁] − [p ∣ q·d₁]

so the ramification locus is `V(d₁) ∪ V(q)`, and **the drop is 2 exactly on
`V(d₁)` and 1 exactly on `V(q) ∖ V(d₁)`.** The receipt separates content from
level: the apavartana ramifies twice as hard as the level, at the primes it owns.
Stated here, checked below only at the instance `d₁ = 2, q = 6`.

## Why this instance and not the exemplar

`YugmaPurāṇa`'s edge is the corpus's other exactly-priced cut, and it prices at
`ℤ/2`: one bad prime, one invariant factor, constant drop. A single number
suffices there, so it cannot show that the price is a function. Here the drop
takes two different values at two different bad primes, and the cokernel needs
two invariant factors. **A non-constant function on a ramification locus is not
a number.** That is the whole content of "over ℤ the price of a cut is a
function on Spec ℤ."

## What the term checks, and what stays prose

**Checked** (`decide`, kernel, no compiler trust): Smith order `2 ∣ 12`;
`det = 24`; `rankAt` at 2, 3, 5, 7 (`0, 1, 2, 2`); `rank_generic` for **every**
`p ∤ 24`; `bad_iff` — a prime is bad iff it divides a Smith divisor, so the
ramification locus is exactly `V(24)`; `drop_is_not_constant`; the bridge
`survives_iff : ((d : ZMod p) ≠ 0) ↔ ¬ p ∣ d`, which is what makes the count a
rank and not bookkeeping; `Fintype.card Cok = 24`; `∀ x : Cok, 12 • x = 0`;
`¬ ∀ x : ZMod 24, 12 • x = 0`; and `cok_not_cyclic : ¬ Nonempty (Cok ≃+ ZMod 24)`.

**Prose, not checked here.** (i) That `diag(2,12)` is the Smith normal form of
the Γ₀ endpoint under `GL₂(ℤ)` change of basis — immediate from diagonality and
`2 ∣ 12`, but no term says it. (ii) That `ℤ²/Dℤ² ≅ ℤ/2 ⊕ ℤ/12` as an explicit
quotient of `ℤ²`; the order-and-exponent theorems pin the isomorphism class
among abelian groups of order 24 (24 = 2³·3 with exponent 12 leaves only
`ℤ/2 ⊕ ℤ/12`), but they do not construct the quotient map. (iii) The general
two-parameter statement above, checked only at one instance.

**Open.** Build the quotient `ℤ²/Dℤ²` and its isomorphism in the term, closing
(ii); then price a cut where the free rank of the cokernel is nonzero, which
this one is not.
