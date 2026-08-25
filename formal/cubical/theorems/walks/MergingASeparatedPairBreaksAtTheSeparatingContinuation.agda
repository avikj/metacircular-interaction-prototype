{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MergingASeparatedPairBreaksAtTheSeparatingContinuation
--
-- `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §28–30 states
--
--   "Theorem 28.10 (no free compression): merging projectively distinct
--    states admits a separating continuation — the global optimum
--    becomes wrong for some admissible downstream world."
--
-- §2 is that, with the separating continuation as an INPUT rather than
-- something asserted to exist, and with the failure located: the
-- compressed evaluation cannot agree with the original at that
-- continuation, on both merged states.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE PART THAT IS NOT A RESTATEMENT
--
-- §3: WHICH of the two states the compression is wrong about is NOT
-- determined.  What is proved is `¬ (A × B)` — the two agreement
-- equations cannot both hold — and NOT `¬ A ⊎ ¬ B`, which would name
-- the guilty state.  Getting from one to the other needs a decision,
-- and none is available.  So "the global optimum becomes wrong for some
-- admissible downstream world" is exactly right, and "wrong for THIS
-- state" is not something the argument gives.
--
-- HOW THIS DIFFERS FROM THE STANDING LEMMA, since it is close.
-- `TranscriptDescent.collisionObstructsDecoder` concludes
-- `¬ FactorsThrough q t` — a statement about decoders on the image, with
-- the collision supplied.  §2 takes the separating continuation as a
-- parameter, ranges over ARBITRARY quotient types and compressions, and
-- returns the failing conjunction at that continuation.  Same family,
-- different shape of conclusion: a located failure rather than a
-- non-existence.
--
-- WHAT IS NOT CLAIMED.  NOT Theorem 28.10 itself as that note means it:
-- "projectively distinct" there is defined by the projective
-- continuation quotient of §14–15, which is NOT modelled here; §2 takes
-- separation by a single continuation as its hypothesis and proves only
-- what follows from that.  NOT anything about w_lat, w_det, w_raw, the
-- chain of §20–22, §26's coding-theory calibration, or §27's rank-width
-- relatives — and that note's own flag stands: prior-art comparison
-- against rank-width, Boolean-width, trellis complexity and bond
-- dimension is REQUIRED before "continuation cut width" is claimed as a
-- new parameter, and nothing here bears on that.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MergingASeparatedPairBreaksAtTheSeparatingContinuation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  States, continuations, and what a compression claims
------------------------------------------------------------------------

module _ (State Cont Value : Type) (v : State → Cont → Value) where

  -- a continuation that tells two states apart
  Separates : Cont → State → State → Type
  Separates c s₁ s₂ = ¬ (v s₁ c ≡ v s₂ c)

  -- a compression: a quotient of states and an evaluation on it
  Agrees : {Q : Type} (q : State → Q) (v' : Q → Cont → Value) → Type
  Agrees {Q} q v' = (s : State) (c : Cont) → v' (q s) c ≡ v s c

  --------------------------------------------------------------------
  -- 2.  Merging a separated pair cannot agree at the separator
  --------------------------------------------------------------------

  noFreeCompression :
    (s₁ s₂ : State) (c : Cont) → Separates c s₁ s₂
    → {Q : Type} (q : State → Q) → q s₁ ≡ q s₂
    → (v' : Q → Cont → Value)
    → ¬ Agrees q v'
  noFreeCompression s₁ s₂ c sep q merged v' agrees =
    sep ( sym (agrees s₁ c)
        ∙ cong (λ x → v' x c) merged
        ∙ agrees s₂ c )

  --------------------------------------------------------------------
  -- 3.  But which state it is wrong about is not determined
  --
  -- The failure is located at the continuation `c` and at the PAIR: the
  -- two agreement equations cannot both hold.  Naming which one fails
  -- would be `¬ A ⊎ ¬ B`, and that is not what the argument gives.
  --------------------------------------------------------------------

  bothCannotHoldAtTheSeparator :
    (s₁ s₂ : State) (c : Cont) → Separates c s₁ s₂
    → {Q : Type} (q : State → Q) → q s₁ ≡ q s₂
    → (v' : Q → Cont → Value)
    → ¬ ((v' (q s₁) c ≡ v s₁ c) × (v' (q s₂) c ≡ v s₂ c))
  bothCannotHoldAtTheSeparator s₁ s₂ c sep q merged v' (a₁ , a₂) =
    sep (sym a₁ ∙ cong (λ x → v' x c) merged ∙ a₂)

------------------------------------------------------------------------
-- 4.  The reading
--
-- §2 is "no free compression" with the separating continuation handed
-- in: whatever quotient type and whatever compressed evaluation, if the
-- quotient identifies a pair some continuation separates, the
-- compression is not faithful.
--
-- §3 is the honest form of "for SOME admissible downstream world".  The
-- statement is about the pair at that continuation; it does not, and
-- constructively cannot without a decision, say which of the two merged
-- states the compressed model now gets wrong.
------------------------------------------------------------------------
