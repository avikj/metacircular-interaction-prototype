{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RefutingLaghavaIsASearch
--
-- लाघव, and what it costs to say a measure does NOT survive an
-- operation on presentations.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS COMES FROM
--
-- The laghava thread has been carrying one sentence for many cycles:
-- cost is not a univalent invariant — it lives on the presentation,
-- which univalence discards.  `Laghava` proves the
-- instance (`size` does not factor through meaning) and
-- `Anuvrtti` proves another (`cost` is not a function of
-- the rule SET).  Both are stated as `¬ FactorsThrough`, and both are
-- PROVED THE SAME WAY: by exhibiting two presentations, `short`/`long`
-- and `abc`/`cab`.
--
-- That repeated shape is the object here, and it was CHECKED rather
-- than inferred from the names: `laghava-is-not-semantic` reduces to
-- `3≢5` applied to a chain through `short` and `long`, and
-- `anuvrtti-is-not-a-set-function` to `3≢2` through `abc` and `cab`.
-- Both proofs are three lines and both are a named pair.
--
-- What that repetition is evidence FOR is the question §2 answers in
-- one case.  It is not evidence that no other route exists — two
-- instances are two instances — and the claim below is only that the
-- route taken has a general shape, and that the shape is the Π/Σ
-- asymmetry that stopped the argument in
-- `WhereTheTowerCanStillBeThree` §5.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  a witness refutes invariance — trivial, one line, and recorded
--       because it is the direction that is always available;
--
--   §2  the converse is a SEARCH.  Over a two-element presentation
--       space it is available and the proof is the search: decide at
--       each point, and if both decisions go the wrong way, assemble
--       the invariance that was assumed absent.  ℕ-valued measures make
--       every such decision available, so the whole cost is the
--       exhaustion;
--
--   §3  and the laghava collision, re-presented as exactly that search:
--       `Laghava.short` and `Laghava.long` are the two points, the
--       operation swapping them preserves meaning and moves size, and
--       §2 recovers the witness from the bare refutation.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DISTINCTION THIS FILE IS ABOUT, AND WHAT IT IS NOT
--
-- Two things are being kept apart that the word "stable" would run
-- together, and the collision is in this corpus's own vocabulary:
--
--   ¬¬-STABILITY — `¬ ¬ A → A`.  Does NOT live on the presentation:
--   `Stable-↔` (WhereTheTowerCanStillBeThree §1) transports it along a
--   bare logical equivalence, with no univalence and no h-level.
--
--   INVARIANCE OF A MEASURE under an operation on presentations.  Lives
--   on the presentation by construction; `Laghava` proves it is not
--   recoverable from the meaning.
--
-- They are not one notion at two sites.  Nothing below derives either
-- from the other, and anekānta is precise about when the collapse is
-- licensed: agreement permits it, plurality blocks it, and here there
-- is plurality.  What recurs is a third thing — the Π/Σ asymmetry —
-- and it recurs because both statements are quantified, not because
-- the quantities are the same.
--
-- NOT CLAIMED.  That the general converse of §1 fails: no presentation
-- space is shown here to have an unrecoverable refutation, and the
-- four corners are not taken — this file asserts neither that the
-- witness can always be recovered nor that it cannot, and does not
-- reach the further two corners.  §2 says what buys it in one case.
-- Also not claimed: that `size` is the right measure, that laghava
-- means minimality of `size`, or anything about Pāṇinian practice
-- beyond what `Laghava` already carries.
------------------------------------------------------------------------

module RefutingLaghavaIsASearch where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; discreteℕ ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import Laghava
  using (Expr ; size ; eval ; short ; long ; same-meaning)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  Invariance, and the direction that is always available
------------------------------------------------------------------------

-- A measure survives an operation on presentations when the operation
-- does not move it.
InvariantUnder : {P : Type ℓ} → (P → ℕ) → (P → P) → Type ℓ
InvariantUnder {P = P} μ op = (p : P) → μ (op p) ≡ μ p

-- One moved presentation refutes it.  This is the direction both
-- existing laghava results use.
witness→¬invariant :
  {P : Type ℓ} (μ : P → ℕ) (op : P → P)
  → Σ[ p ∈ P ] (¬ (μ (op p) ≡ μ p))
  → ¬ InvariantUnder μ op
witness→¬invariant μ op (p , n) inv = n (inv p)

------------------------------------------------------------------------
-- 2.  The converse is the search
--
-- स्यात् — in the respect of a two-point presentation space, the
-- witness is recoverable from the bare refutation, and the proof IS
-- the exhaustion: ℕ makes each comparison decidable, so nothing is
-- spent except visiting both points.  Note where the work sits — not
-- in the negation, which gives nothing back, but in the reassembly of
-- the invariance from its two instances, which is what the hypothesis
-- is then applied to.
--
-- The two-point restriction is a HYPOTHESIS of §2 and not a claim
-- about presentation spaces.  Nothing here says presentations come in
-- finitely many kinds, or that a standpoint-space is enumerable; `Bool`
-- indexes two particular presentations in §3 and nothing else.
------------------------------------------------------------------------

¬invariant→witness₂ :
  (μ : Bool → ℕ) (op : Bool → Bool)
  → ¬ InvariantUnder μ op
  → Σ[ b ∈ Bool ] (¬ (μ (op b) ≡ μ b))
¬invariant→witness₂ μ op ni with discreteℕ (μ (op true)) (μ true)
... | no  n = true , n
... | yes pt with discreteℕ (μ (op false)) (μ false)
...   | no  n = false , n
...   | yes pf = ⊥.rec (ni assemble)
  where
    assemble : InvariantUnder μ op
    assemble true  = pt
    assemble false = pf

------------------------------------------------------------------------
-- 3.  The laghava collision, re-presented as that search
--
-- `Laghava.short` and `Laghava.long` denote the same function and have
-- sizes 3 and 5.  Index them by `Bool`; the operation is the swap.
-- Meaning is invariant under it, size is not, and §2 hands the witness
-- back from the bare refutation — which is to say the original proof
-- was already a two-point exhaustion, done by hand.
------------------------------------------------------------------------

pres : Bool → Expr
pres true  = short
pres false = long

swap : Bool → Bool
swap true  = false
swap false = true

sizeOf : Bool → ℕ
sizeOf = λ b → size (pres b)

-- meaning does not move under the swap …
meaning-invariant : (b : Bool) → eval (pres (swap b)) ≡ eval (pres b)
meaning-invariant true  = sym same-meaning
meaning-invariant false = same-meaning

-- … and size does, at both points.
size-moves : ¬ InvariantUnder sizeOf swap
size-moves inv with discreteℕ (sizeOf (swap true)) (sizeOf true)
... | yes p = ⊥.rec (snotz (injSuc (injSuc (injSuc p))))
... | no  n = n (inv true)

-- and the search recovers the moved presentation from the refutation.
laghava-witness : Σ[ b ∈ Bool ] (¬ (sizeOf (swap b) ≡ sizeOf b))
laghava-witness = ¬invariant→witness₂ sizeOf swap size-moves
