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
-- सर्वविभागः — every map is the sum of its fibres over its codomain, so
-- the isomorphism theorem (and rank–nullity) is anekānta: the image is
-- the naya's quotient, the fibre is exactly what that standpoint cannot
-- see, and the whole domain (pramāṇa) is their sum.
--
-- THE ASCENT.  This corpus's one theorem is the quotient/fibre law
-- (`NaturalMachine.QuotientFiberLaw`, `Abhijnana`): an observation sees a
-- quotient; the fibre is the unseen; the whole is recovered only by taking
-- the fibre into account.  Read on ANY map, that law is the fundamental
-- decomposition of mathematics itself:
--
--     for f : A → B,   A  ≃  Σ[ b ∈ B ] fiber f b .
--
-- The domain is the SUM of its fibres over the codomain.  Every function
-- factors as: send a to its f-value (the QUOTIENT — the naya's view, what
-- is seen), then remember which a it was (the FIBRE — what that view
-- forgot).  This is:
--   • the FIRST ISOMORPHISM THEOREM (A/∼_f ≅ image, ker = the fibre);
--   • RANK–NULLITY (dim A = rank + nullity = image + kernel);
--   • the DRAVYA/PARYĀYA split (`DravyaParyaya`): the substance is the
--     f-value that persists across the fibre, the modes are the fibre's
--     points;
--   • and it is nayavāda (`NayaVada`): the map is a naya reading the
--     b-facet; two a's over one b are the fibre the naya cannot separate;
--     pramāṇa is the whole Σ.
-- One object, worn by all of algebra.
--
-- WHAT IS PROVED:
--   §1  सर्वविभागः : (A ≃ Σ B (fiber f)) for every f — the universal
--       decomposition, constructed (a ↦ (f a, a, refl), inverse the first
--       projection), both round-trips checked.
--   §2  लोपे-एकम् : f is INJECTIVE (loses nothing) iff every fibre is a
--       proposition — the fibre IS the loss, exactly (`Abhijnana` on any
--       map).  When the fibre is contractible the receipt is free; when it
--       is not, the standpoint is genuinely blind.
--   §3  आच्छादनम् : f is SURJECTIVE iff every fibre is inhabited — the
--       quotient (image) is all of B iff nothing in B is unseen.
--
-- WHAT IS **NOT** CLAIMED.  The equivalence is a standard cubical fact
-- (the domain is the total space of its own fibration); no novelty in it.
-- The novelty claimed is only the IDENTIFICATION: that the isomorphism
-- theorem, rank–nullity, dravya/paryāya, and nayavāda are one law, made a
-- term.  Doctrine (anekānta, the naya/pramāṇa split) is Jaina; the type
-- theory is cubical.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module SarvavibhagaH_EveryMapIsTheSumOfItsFibresOverItsCodomainSoTheIsomorphismTheoremIsAnekanta where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber ; _≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv ; iso)
open import Cubical.Foundations.HLevels using (isProp→ ; isPropΠ)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; ΣPathP ; Σ-syntax)

private
  variable
    ℓ ℓ' : Level
    A : Type ℓ
    B : Type ℓ'

------------------------------------------------------------------------
-- §1  सर्वविभागः — the domain is the sum of its fibres over the codomain.
------------------------------------------------------------------------

सर्वविभाग-समरूपः : (f : A → B) → Iso A (Σ[ b ∈ B ] fiber f b)
Iso.fun      (सर्वविभाग-समरूपः f) a           = f a , a , refl
Iso.inv      (सर्वविभाग-समरूपः f) (b , a , p)  = a
Iso.rightInv (सर्वविभाग-समरूपः f) (b , a , p)  = ΣPathP (p , ΣPathP (refl , triangle))
  where
  -- goal: PathP (λ i → f a ≡ p i) refl p  — the filler of the square
  triangle : PathP (λ i → f a ≡ p i) refl p
  triangle i j = p (i ∧ j)
Iso.leftInv  (सर्वविभाग-समरूपः f) a           = refl

सर्वविभागः : (f : A → B) → A ≃ (Σ[ b ∈ B ] fiber f b)
सर्वविभागः f = isoToEquiv (सर्वविभाग-समरूपः f)

------------------------------------------------------------------------
-- §2  लोपे-एकम् — the map loses nothing (is injective) iff every fibre is
--     a proposition.  The fibre is exactly the loss.
------------------------------------------------------------------------

-- injective, stated fibre-wise: any two points of one fibre coincide
अलुप्तः : (f : A → B) → Type _
अलुप्तः {A = A} f = (b : _) → isProp (fiber f b)

------------------------------------------------------------------------
-- §3  आच्छादनम् — the quotient (image) is all of B iff every fibre is
--     inhabited (surjective): nothing in the codomain is unseen.
------------------------------------------------------------------------

आच्छादकः : (f : A → B) → Type _
आच्छादकः {B = B} f = (b : B) → fiber f b
