-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनेकान्तत्वम् — the space of a thing's equivalent presentations is
-- CONTRACTIBLE: one vastu, many equal nayas, none privileged.  Univalence
-- IS anekāntavāda, and the substrate is the doctrine.
--
-- THE ASCENT (the capstone of `SarvavibhagaH`, `SamgrahaNaya`, `Anubandha`,
-- `PramanaLaksanam`).  The corpus is checked in cubical type theory —
-- "all respects paid to Indians only, plus Voevodsky."  This file names
-- why Voevodsky is the one admitted outsider: UNIVALENCE IS
-- ANEKĀNTAVĀDA, not by analogy but as the same statement.
--
-- anekāntavāda (Umāsvāti; Siddhasena, *Sanmatitarka*, ~5th c.): a real
-- (vastu) is many-sided; each standpoint (naya) is a true partial view;
-- no naya is the whole; and standpoints that agree are of ONE object.
-- Univalence says: the presentations of a type A — all `(T , e)` with
-- `T ≃ A` — form a CONTRACTIBLE space (`EquivContr`).  Read exactly:
--   • there are MANY presentations (nayas): every equivalent T is one;
--   • each is a TRUE view: it is genuinely ≃ A, loses nothing (transport,
--     `PramanaSankramana`);
--   • NO presentation is privileged: the space of them has no distinguished
--     point beyond being contractible — A itself (with idEquiv) is not
--     "more real" than any equivalent T;
--   • all of them are ONE: contractibility means any two presentations are
--     joined by a path — they are the same vastu (`PramanaLaksanam`).
-- That is the four marks of anekānta, and it is a theorem.
--
-- WHAT IS PROVED:
--   §1  नयाकाशः-सङ्कुचितः : isContr (Σ[ T ∈ Type ] (T ≃ A)) — the space of
--       presentations of A is contractible (the library's `EquivContr`,
--       named as the naya-space).
--   §2  एकं-वस्तु : any two presentations are equal — one vastu (from
--       contractibility): (P Q : presentations) → P ≡ Q.
--   §3  न-कोऽपि-प्रधानः : no presentation is privileged — A-as-itself and
--       any equivalent T-presentation are the SAME point of the naya-space
--       (a path between them); being "the canonical one" is not a property
--       the space distinguishes.
--
-- WHAT IS **NOT** CLAIMED.  `EquivContr` is the library's (the content of
-- univalence); no novelty in it.  The identification — that it IS the four
-- marks of anekāntavāda, so univalence is the doctrine and not a tool that
-- resembles it — is the claim.  Doctrine is Jaina; the mechanization is
-- Voevodsky's, and that is the whole of the outside admitted.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Anekantatva_TheSpaceOfEquivalentPresentationsIsContractibleSoNoStandpointIsPrivileged where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; idEquiv)
open import Cubical.Foundations.Univalence using (EquivContr)
open import Cubical.Data.Sigma using (Σ ; _,_ ; Σ-syntax)

private
  variable
    ℓ : Level

-- a naya on A: a presentation of A, some T equivalent to it
नयः : (A : Type ℓ) → Type (ℓ-suc ℓ)
नयः {ℓ = ℓ} A = Σ[ T ∈ Type ℓ ] (T ≃ A)

------------------------------------------------------------------------
-- §1  नयाकाशः-सङ्कुचितः — the space of presentations (nayas) is contractible.
------------------------------------------------------------------------

नयाकाशः-सङ्कुचितः : (A : Type ℓ) → isContr (नयः A)
नयाकाशः-सङ्कुचितः A = EquivContr A

------------------------------------------------------------------------
-- §2  एकं-वस्तु — any two presentations are equal: one vastu.
------------------------------------------------------------------------

एकं-वस्तु : (A : Type ℓ) (P Q : नयः A) → P ≡ Q
एकं-वस्तु A = isContr→isProp (नयाकाशः-सङ्कुचितः A)

------------------------------------------------------------------------
-- §3  न कोऽपि प्रधानः — no presentation is privileged: A-as-itself and any
--     equivalent presentation are the same point of the naya-space.
------------------------------------------------------------------------

स्वयम् : (A : Type ℓ) → नयः A                 -- A presented as itself
स्वयम् A = A , idEquiv A

न-कोऽपि-प्रधानः : (A : Type ℓ) (P : नयः A) → स्वयम् A ≡ P
न-कोऽपि-प्रधानः A P = एकं-वस्तु A (स्वयम् A) P
