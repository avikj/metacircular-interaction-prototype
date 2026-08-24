-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- जीव-सन्तान — the thread of the living: identity through time is a
-- SECTION through a changing family of worlds, not equality of
-- snapshots.  The transitions need not be equalities; the worlds
-- themselves may change type (retyping, splitting, enrichment).  Yet
-- the biography is transportable: the section's value at any time is
-- generated from its origin by the transitions.  Change does not
-- annihilate continuity, and continuity does not forbid change.
-- (Owner's temporal-body message; the exact structure as a term.)
--
-- THE ZIGZAG.  Life having occurred means Mₙ ≠ Mₙ₊₁.  The union is
-- wrong (a correction may RETYPE an earlier claim).  So a transition is
-- a span
--
--     Mₙ  ←—  Cₙ  —→  Mₙ₊₁
--
-- with Cₙ the conserved world that transports lawfully across the
-- change.  What cannot cross is not deleted — its failed transport
-- becomes the transition fibre, and its FATE is recorded.  Here the
-- worlds are types Wₙ and the transition is a map τₙ : Wₙ → Wₙ₊₁ (an
-- equivalence, a refinement, a restriction — ANY map; W changes type),
-- which is one leg of the span with the conserved core as its domain.
--
-- THE JĪVA is a section jₙ : Wₙ with τₙ(jₙ) ≃ jₙ₊₁ — the coherence that
-- makes it ONE thread rather than a sequence of unrelated states.  τₙ
-- need not be equality; the ≡ below is the coherence witness, and Wₙ,
-- Wₙ₊₁ may be genuinely different types.
--
-- THE BIOGRAPHY THEOREM (§2).  For a jīva, the value at time n is
-- EXACTLY what the transitions generate from the origin:
--
--     jₙ  ≡  (τₙ₋₁ ∘ ⋯ ∘ τ₀)(j₀).
--
-- Identity through change is the recoverability of the whole biography
-- from the origin along the transitions — "a coherent capacity to
-- transport its own biography", as a checked path.  Proof: induction
-- through the coherence, the σ^-index shape of `VanaSetu`.
--
-- THE FIVE FATES (§3).  A single claim, under a transition, meets one
-- of five fates — the owner's anatomy of a lossless correction.  They
-- are the constructors of the transition fibre; the datatype is their
-- codomain.  FENCE: classifying a SPECIFIC claim's fate needs the
-- actual span maps and is not done here — this supplies the type a
-- lossless correction must land in, so that no claim silently vanishes.
------------------------------------------------------------------------

module JivaSantana_IdentityThroughChangeIsASectionThroughAChangingFamilyNotEqualityOfSnapshots where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Sigma using (Σ; Σ-syntax; _,_; fst; snd)

private
  variable
    ℓ : Level

-- a changing family of worlds, and the transitions between them.
module _ (W : ℕ → Type ℓ) (τ : (n : ℕ) → W n → W (suc n)) where

  -- THE JĪVA: a section with the coherence that makes it one thread.
  -- τ n (j n) ≡ j (suc n) — the transition carries this life's present
  -- to (a witness of) its next.  τ is an arbitrary map: the worlds may
  -- change type, and the ≡ is the only thing making the thread single.
  Jiva : Type ℓ
  Jiva = Σ[ j ∈ ((n : ℕ) → W n) ] ((n : ℕ) → τ n (j n) ≡ j (suc n))

  -- the biography generated from an origin by the transitions.
  chase : (a₀ : W 0) → (n : ℕ) → W n
  chase a₀ zero    = a₀
  chase a₀ (suc n) = τ n (chase a₀ n)

------------------------------------------------------------------------
-- §2 · THE BIOGRAPHY THEOREM.  A jīva's value at every time is exactly
-- what the transitions generate from its origin.  Identity through
-- change = transportability of the whole biography.

  biography : (J : Jiva) (n : ℕ) → chase (fst J 0) n ≡ fst J n
  biography J zero    = refl
  biography J (suc n) =
    cong (τ n) (biography J n)   -- τ n (chase … n) ≡ τ n (j n)
    ∙ snd J n                    -- ≡ j (suc n), by the coherence

------------------------------------------------------------------------
-- §3 · THE FIVE FATES of a claim under a correction (the owner's
-- anatomy of a lossless transition).  A lossless correction is one
-- whose transition assigns EVERY old claim one of these — nothing
-- silently vanishes.

data Fate : Type where
  transported : Fate   -- crossed unchanged (in the conserved core Cₙ)
  restricted  : Fate   -- survived under a narrower hypothesis
  refuted     : Fate   -- a new distinction invalidated it
  split       : Fate   -- one fibre became several
  unresolved  : Fate   -- its transport is owed, not yet known

-- a correction is LOSSLESS when it assigns a fate to every claim: the
-- future can still answer "what did the old world assert, and what
-- became of it."  The type of such an accounting, over a world Claims:
Lossless : {ℓ' : Level} (Claims : Type ℓ') → Type ℓ'
Lossless Claims = Claims → Fate

-- the five fates are genuinely distinct (a Fate is not a Bool: a
-- boolean "survived?" would merge restricted/split/transported and
-- refuted/unresolved — the durnaya the whole corpus refuses).  Witness:
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Empty using (⊥)

transported≢refuted : transported ≡ refuted → ⊥
transported≢refuted p = true≢false (cong tag p)
  where
  tag : Fate → Bool
  tag transported = true
  tag _           = false
