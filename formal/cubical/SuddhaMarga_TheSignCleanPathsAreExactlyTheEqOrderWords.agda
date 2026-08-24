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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शुद्ध-मार्गः — the clean route.  The CONVERSE of the blindness theorem:
-- a path of transports conserves sign exactly when EVERY step is Eq or
-- Order.  SamraksanaJala proved a Quotient anywhere kills sign; this
-- module closes the characterization — the sign-clean paths are precisely
-- the words in the two-letter alphabet {Eq, Order}.  Together they are the
-- machine's full statement of what can and cannot see parity:
--
--     pathPreserves ks sign ≡ true   ⟺   ∀ k ∈ ks, k ≡ eq ⊎ k ≡ order.
--
-- (First conversation-built term through नाडी, the warm conduit: skeleton
-- with holes, each hole answered by the elaborator at ~60ms, the kernel
-- speaking instead of verdicting.)
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module SuddhaMarga_TheSignCleanPathsAreExactlyTheEqOrderWords where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Sum using (_⊎_; inl; inr)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)
open import Cubical.Data.Unit using (Unit*; tt*)
open import SamraksanaJala_TheEdgeLatticeConservesByIntersectionAndSignDiesThroughEveryQuotient
  using (Kind; eq; iso; embed; quotient; implies; approx; refine; interp;
         dual; order; conjecture; Tag; sign; _⊨_; _&_; pathPreserves;
         onlyEqAndOrderCarrySign)

-- "every step in the word is Eq or Order"
CleanWord : List Kind → Type
CleanWord []       = Unit*
CleanWord (k ∷ ks) = ((k ≡ eq) ⊎ (k ≡ order)) × CleanWord ks

------------------------------------------------------------------------
-- §1 · SOUNDNESS: a clean word conserves sign.
clean→preserves : (ks : List Kind) → CleanWord ks → pathPreserves ks sign ≡ true
clean→preserves []       _          = refl
clean→preserves (k ∷ ks) (c , rest) =
  step c ∙ clean→preserves ks rest
  where
  -- (k ⊨ sign) & pathPreserves ks sign ≡ pathPreserves ks sign, since k ⊨ sign ≡ true
  step : (k ≡ eq) ⊎ (k ≡ order)
       → (k ⊨ sign) & pathPreserves ks sign ≡ pathPreserves ks sign
  step (inl p) = cong (λ j → (j ⊨ sign) & pathPreserves ks sign) p
  step (inr p) = cong (λ j → (j ⊨ sign) & pathPreserves ks sign) p

------------------------------------------------------------------------
-- §2 · COMPLETENESS: a word that conserves sign is clean.  The head must
-- itself carry sign (else the & is false), so by onlyEqAndOrderCarrySign
-- it is eq or order, and the tail follows by induction.
&-true-left : (a b : Bool) → a & b ≡ true → a ≡ true
&-true-left true  b p = refl
&-true-left false b p = Empty.rec (true≢false (sym p))

&-true-right : (a b : Bool) → a & b ≡ true → b ≡ true
&-true-right true  b p = p
&-true-right false b p = Empty.rec (true≢false (sym p))

preserves→clean : (ks : List Kind) → pathPreserves ks sign ≡ true → CleanWord ks
preserves→clean []       _ = tt*
preserves→clean (k ∷ ks) p =
  onlyEqAndOrderCarrySign k (&-true-left (k ⊨ sign) (pathPreserves ks sign) p)
  , preserves→clean ks (&-true-right (k ⊨ sign) (pathPreserves ks sign) p)

------------------------------------------------------------------------
-- §3 · THE CHARACTERIZATION, both directions in one place: the sign-clean
-- paths are exactly the {Eq, Order}-words.  Parity is visible along
-- identity and order, and along nothing else — the two-letter language of
-- sight.
signClean⇔cleanWord : (ks : List Kind)
  → (pathPreserves ks sign ≡ true → CleanWord ks)
  × (CleanWord ks → pathPreserves ks sign ≡ true)
signClean⇔cleanWord ks = preserves→clean ks , clean→preserves ks
