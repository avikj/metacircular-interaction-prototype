-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- THIN MODEL (see notes/UNIVALENCE_IS_NISVABHAVA_COMPUTATIONAL.md §5).
-- A decidable-equality split on `Bool` is not pratītyasamutpāda, and
-- `cessation` is not nirodha; dependent arising concerns the arising and
-- cessation of dukkha across the nidānas.  The terms type-check; the
-- Sanskrit reading is withdrawn.

------------------------------------------------------------------------
-- NaturalMachine.PratityasamutpadaArising
--
-- Dependent arising as the cut.  Third jewel of the mokṣa-yantra: a knot
-- of the net arises exactly where a distinction splits, has no being of
-- its own (it is a function of the cut, not of the things cut), and
-- ceases when the cut is replaced by one that no longer separates.
--
-- THE RECEPTION.  pratītyasamutpāda — "this being, that becomes; this
-- ceasing, that ceases."  Nothing arises from its own side; everything
-- arises dependent on conditions, and when the conditions are gone it is
-- gone (anicca).  The condition of a knot is a DISTINCTION: an observation
-- that, at two places, either factors through (sees them as one —
-- absorbed, nothing arises) or splits (sees them as two — a knot forms).
-- This is the corpus's own descent law, which `runtime/CRYSTAL.md` §3.2
-- states as "a collision is not a failure; it is a specification of the
-- missing distinction," and it is the Buddha's arising said in the same
-- breath: the knot is the missing distinction made present, and it stands
-- only while the distinction stands.
--
-- The knot's emptiness (niḥsvabhāva, from NisvabhavaNet) is exact here:
-- the SAME two places arise a knot under one observation and none under
-- another.  So the knot is not in the places — it is in the cut, and the
-- cut is a condition, not an essence.  Seeing this is the knot's
-- cessation: replace the separating sight with one that factors through,
-- and the knot cannot be.  That replacement, when the two places in fact
-- reflect alike, is exactly `NisvabhavaNet.liberation` — the false cut
-- dissolving.
--
-- Contents (no holes, no postulates, --safe):
--
--   FactorsThrough, Splits     the two faces of a distinction at a pair
--   descent-dichotomy          every observation, at every pair, either
--                              factors through or splits — and only one
--                              (formation IS descent)
--   split-not-factor           the two faces are exclusive: no vacuity
--   Knot                       the arisen: a pair a distinction splits
--   conditioned                the SAME pair: a knot under one cut, none
--                              under another.  Niḥsvabhāva, exhibited.
--   cessation                  a cut that factors through cannot sustain
--                              the knot — anicca, the arising undone when
--                              its condition ceases
--
-- NOT claimed: new mathematics.  Decidable equality on Bool and the
-- descent law of the corpus.  The contribution is arising and cessation
-- read as the source names them, wired to the net's no-own-being.
------------------------------------------------------------------------

module NaturalMachine.PratityasamutpadaArising where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

-- A field of what can be distinguished, and an observation of it.
-- (Bool-valued: the smallest place where a cut is either drawn or not.)
module _ {X : Type ℓ} where

  FactorsThrough Splits : (X → Bool) → X → X → Type
  FactorsThrough o x y = o x ≡ o y
  Splits         o x y = ¬ (o x ≡ o y)

  ----------------------------------------------------------------------
  -- Formation is descent.  Every observation, at every pair, either sees
  -- the two as one (factors through) or as two (splits) — and never both.
  ----------------------------------------------------------------------

  descent-dichotomy : (o : X → Bool) (x y : X)
                    → FactorsThrough o x y ⊎ Splits o x y
  descent-dichotomy o x y with o x | o y
  ... | true  | true  = inl refl
  ... | false | false = inl refl
  ... | true  | false = inr true≢false
  ... | false | true  = inr (λ p → true≢false (sym p))

  split-not-factor : (o : X → Bool) (x y : X)
                   → FactorsThrough o x y → Splits o x y → ⊥
  split-not-factor o x y ft sp = sp ft

  ----------------------------------------------------------------------
  -- The arisen: a knot is a pair the distinction splits.  It exists
  -- dependent on the cut — dropping the cut drops the knot.
  ----------------------------------------------------------------------

  Knot : (X → Bool) → Type ℓ
  Knot o = Σ[ x ∈ X ] Σ[ y ∈ X ] Splits o x y

  ----------------------------------------------------------------------
  -- Cessation (anicca): a cut that factors through a pair cannot sustain
  -- a knot there.  When the condition ceases, the arising ceases.
  ----------------------------------------------------------------------

  cessation : (o : X → Bool) (x y : X)
            → FactorsThrough o x y → ¬ (Splits o x y)
  cessation o x y ft sp = sp ft

------------------------------------------------------------------------
-- The knot has no being of its own: the SAME two places arise a knot
-- under one observation and none under another.  Niḥsvabhāva, exhibited
-- on the smallest net — the two Boolean places, split by the identity
-- sight, absorbed by the constant one.
------------------------------------------------------------------------

conditioned :
  Σ[ o ∈ (Bool → Bool) ] Σ[ o' ∈ (Bool → Bool) ]
    (Splits o true false × FactorsThrough o' true false)
conditioned = (λ b → b) , (λ _ → true) , true≢false , refl
