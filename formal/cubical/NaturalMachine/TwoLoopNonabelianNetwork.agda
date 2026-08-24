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

{-# OPTIONS --cubical --safe #-}

-- Two based loops expose the exact boundary between noncommuting path order
-- and conjugacy-invariant observation.  Raw S₃ holonomy distinguishes the two
-- orders; the fixed-point profile identifies the resulting conjugate
-- three-cycles.  No trace, Hilbert space, or continuum claim is made.

module NaturalMachine.TwoLoopNonabelianNetwork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.SumFin using (fzero ; fsuc)
import Cubical.Data.Prod as P

open import NaturalMachine.FiniteGraphHolonomyGroupoid using (Connection)
open Connection
open import NaturalMachine.FiniteNonabelianHolonomy
open import NaturalMachine.S3ConjugacyObservation

-- Bouquet of two oriented loops at one vertex.
data TwoLoopGraph : Type where
  vertex : TwoLoopGraph
  loopA loopB : vertex ≡ vertex

-- The path-groupoid functor law fixes the ordering convention exactly.
two-loop-compose : (A : Connection S₃ TwoLoopGraph)
  → hol A (loopA ∙ loopB) ≡ hol A loopB S.· hol A loopA
two-loop-compose A = hol-comp A loopA loopB

two-loop-compose-reverse : (A : Connection S₃ TwoLoopGraph)
  → hol A (loopB ∙ loopA) ≡ hol A loopA S.· hol A loopB
two-loop-compose-reverse A = hol-comp A loopB loopA

-- If the two generators carry the adjacent transpositions, path order is
-- observable at the raw holonomy level.
ordered-loops-distinct : (A : Connection S₃ TwoLoopGraph)
  → hol A loopA ≡ s₀₁ → hol A loopB ≡ s₁₂
  → hol A (loopA ∙ loopB) ≡ hol A (loopB ∙ loopA) → ⊥
ordered-loops-distinct A hA hB p = noncommuting (sym chain)
  where
  chain : s₁₂ S.· s₀₁ ≡ s₀₁ S.· s₁₂
  chain =
      sym (cong₂ S._·_ hB hA)
    ∙ sym (two-loop-compose A)
    ∙ p
    ∙ two-loop-compose-reverse A
    ∙ cong₂ S._·_ hA hB

-- Simultaneous endpoint gauge change preserves both individual loop profiles.
IndividualProfiles : (⟨ S₃ ⟩ P.× ⟨ S₃ ⟩) → Type₀
IndividualProfiles gh =
  P._×_ (Fixed (P.proj₁ gh)) (Fixed (P.proj₂ gh))

simultaneous-profile-invariance : (k g h : ⟨ S₃ ⟩)
  → P._×_ (Fixed ((k S.· g) S.· S.inv k))
           (Fixed ((k S.· h) S.· S.inv k))
    ≡ P._×_ (Fixed g) (Fixed h)
simultaneous-profile-invariance k g h i =
  P._×_ (fixedProfile-conjugation k g i)
         (fixedProfile-conjugation k h i)

-- The product loop is a separate conjugacy observable; it must not be
-- confused with the pair of conjugacy observables of its factors.
ProductProfile : (⟨ S₃ ⟩ P.× ⟨ S₃ ⟩) → Type₀
ProductProfile gh = Fixed (P.proj₂ gh S.· P.proj₁ gh)

product-profile-gauge : (k g h : ⟨ S₃ ⟩)
  → Fixed ((k S.· (h S.· g)) S.· S.inv k) ≡ Fixed (h S.· g)
product-profile-gauge k g h = fixedProfile-conjugation k (h S.· g)

reverseCycle : ⟨ S₃ ⟩
reverseCycle = s₁₂ S.· s₀₁

reverse-cycle-no-fixed : Fixed reverseCycle → ⊥
reverse-cycle-no-fixed (fzero , p) = succNotZero3 p
reverse-cycle-no-fixed (fsuc fzero , p) =
  succNotZero2 (outerInject3 p)
reverse-cycle-no-fixed (fsuc (fsuc fzero) , p) = zeroNotSucc3 p

-- Both orderings are 3-cycles.  Their fixed-profile observations are equal,
-- even though `noncommuting` proves their raw holonomies unequal.
orderedProductProfileIso : Iso (Fixed cycle₀₁₂) (Fixed reverseCycle)
Iso.fun orderedProductProfileIso x = Empty.rec (cycle-no-fixed x)
Iso.inv orderedProductProfileIso x = Empty.rec (reverse-cycle-no-fixed x)
Iso.rightInv orderedProductProfileIso x = Empty.rec (reverse-cycle-no-fixed x)
Iso.leftInv orderedProductProfileIso x = Empty.rec (cycle-no-fixed x)

orderedProductProfilesEqual : Fixed cycle₀₁₂ ≡ Fixed reverseCycle
orderedProductProfilesEqual = ua (isoToEquiv orderedProductProfileIso)
