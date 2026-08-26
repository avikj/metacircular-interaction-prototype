{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विकल्पः — द्वैधमापस्य तन्तुः तत्तन्तूनां द्वैधम् एव, अतः गणने योगः ।
--
-- (the fiber of a twofold map is the twofold of its fibers, and so the
--  counts add.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND WHY IT IS THE ABSTRACT LAW THE CORPUS KEPT
-- INSTANTIATING WITHOUT NAMING.
--
-- Give two maps into one codomain, `f : A → C` and `g : B → C`, and the
-- one map they define by cases on the alternative,
--
--     विकल्पः = rec f g : A ⊎ B → C,      विकल्पः (inl a) = f a
--                                          विकल्पः (inr b) = g b
--
-- Then for every target `c`,
--
--     §१   fiber विकल्पः c  ≃  (fiber f c ⊎ fiber g c).
--
-- The fiber of a case-map is the case of the fibers. The equivalence is
-- purely re-bracketing — both round-trips are `refl` — because `rec`
-- computes on `inl`/`inr` definitionally, so `f a ≡ c` and `विकल्पः
-- (inl a) ≡ c` are the same proof, only re-labelled.
--
-- The corpus already carries this law in three concrete disguises and
-- had not abstracted it:
--   · `Virahanka_….agda`   fiber छन्दः (2+n) ≃ (fiber छन्दः (1+n) ⊎ fiber छन्दः n)
--   · `AksharaDvaya_….agda` the same for the Bool mātrā weight,
--   · `Bhara_….agda`       the head-split of a weighted counting map.
-- Each of those is a fiber splitting into a laghu-summand and a
-- guru-summand — Virahāṅka's two-step recurrence — and each proved the
-- splitting by hand. They are not literally instances of §१ (their
-- domain is `List`, not a bare `A ⊎ B`), but they are all the same
-- phenomenon: an alternative in the source becomes an alternative in the
-- fiber. §१ is that phenomenon with nothing else attached.
--
-- §२ is why Piṅgala's numbers ADD across such a split. If the two
-- fibers are finite — `fiber f c ≃ Fin m` and `fiber g c ≃ Fin n` — then
--
--     §२   fiber विकल्पः c  ≃  Fin (m + n).
--
-- This is §१ composed with the library's `⊎-equiv` and
-- `Fin+≅Fin⊎Fin`: the two receipts, chained, turn the twofold of fibers
-- into one flat count, and the count is the SUM. That `+` is where
-- Virahāṅka's addition and Halāyudha's row-sum come from — not from any
-- arithmetic done on the numbers, but from the coproduct in the fiber.
--
-- ────────────────────────────────────────────────────────────────────
-- ON THE NAME. विकल्प is the traditional term, in Pāṇinian grammar and
-- in Nyāya, for a twofold option / disjunction — the "either–or". The
-- coproduct `A ⊎ B` is exactly that alternative, and `rec f g` is the
-- map that acts by which side of the alternative it is handed. Source
-- for the term: PĀṆINI, अष्टाध्यायी (~500 BCE), where optionality is
-- carried by वा and विभाषा (e.g. १.१.४४ न वेति विभाषा — "vibhāṣā means
-- 'or not'"), the grammar's device for a rule that splits into cases.
--
-- NOT CLAIMED: that Pāṇini, or anyone in the tradition, stated the
-- fiber theorem below, or worked with fibers, coproducts or Fin at all.
-- The term names the SHAPE — a map given by a twofold alternative — and
-- nothing more. The mathematics (the fiber of `rec`, its equivalence,
-- the additive count) is homotopy type theory and originates here /
-- in the cubical library, not in any cited source.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Vikalpa_TheFiberOfATwofoldMapIsTheTwofoldOfItsFibersAndSoTheCountsAdd where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; compEquiv ; invEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr ; rec)
open import Cubical.Data.Sum.Properties using (⊎-equiv)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (Fin+≅Fin⊎Fin)

private variable ℓ ℓ' ℓ'' : Level

module _ {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''} (f : A → C) (g : B → C) where

  -- the twofold map: act by whichever side of the alternative is given.
  विकल्पः : A ⊎ B → C
  विकल्पः = rec f g

------------------------------------------------------------------------
-- १ · विकल्प-तन्तुः — the fiber of the case-map is the case of the fibers.
--     Pure re-bracketing: `rec` computes on the constructors, so each
--     proof carries across untouched and both round-trips are refl.
------------------------------------------------------------------------

  विकल्प-तन्तुः : (c : C) → fiber विकल्पः c ≃ (fiber f c ⊎ fiber g c)
  विकल्प-तन्तुः c = isoToEquiv (iso भङ्गः सङ्घातः निवृत्तिः प्रत्यावृत्तिः)
    where
      भङ्गः : fiber विकल्पः c → (fiber f c ⊎ fiber g c)
      भङ्गः (inl a , p) = inl (a , p)
      भङ्गः (inr b , p) = inr (b , p)

      सङ्घातः : (fiber f c ⊎ fiber g c) → fiber विकल्पः c
      सङ्घातः (inl (a , p)) = inl a , p
      सङ्घातः (inr (b , p)) = inr b , p

      निवृत्तिः : (y : fiber f c ⊎ fiber g c) → भङ्गः (सङ्घातः y) ≡ y
      निवृत्तिः (inl _) = refl
      निवृत्तिः (inr _) = refl

      प्रत्यावृत्तिः : (x : fiber विकल्पः c) → सङ्घातः (भङ्गः x) ≡ x
      प्रत्यावृत्तिः (inl a , p) = refl
      प्रत्यावृत्तिः (inr b , p) = refl

------------------------------------------------------------------------
-- २ · विकल्प-गणना — two finite receipts on the two fibers flatten to one
--     count on the twofold fiber, and that count is their SUM.  This is
--     §१ composed with `⊎-equiv` and the library's `Fin+≅Fin⊎Fin`.
------------------------------------------------------------------------

  विकल्प-गणना : {m n : ℕ} (c : C)
    → fiber f c ≃ Fin m
    → fiber g c ≃ Fin n
    → fiber विकल्पः c ≃ Fin (m + n)
  विकल्प-गणना {m} {n} c ef eg =
    compEquiv (विकल्प-तन्तुः c)
      (compEquiv (⊎-equiv ef eg)
        (invEquiv (isoToEquiv (Fin+≅Fin⊎Fin m n))))
