{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡ø‡ï‡≤‡‡‡ ‚î ‡¶‡‡µ‡à‡ß‡Æ‡æ‡‡‡‡Ø ‡‡®‡‡‡‡ ‡‡‡‡‡®‡‡‡‡®‡æ‡ ‡¶‡‡µ‡à‡ß‡Æ‡ ‡‡µ, ‡‡‡ ‡ó‡‡®‡ ‡Ø‡ã‡ó‡ ‡
--
-- (the fiber of a twofold map is the twofold of its fibers, and so the
--  counts add.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, AND WHY IT IS THE ABSTRACT LAW THE CORPUS KEPT
-- INSTANTIATING WITHOUT NAMING.
--
-- Give two maps into one codomain, `f : A ‚í C` and `g : B ‚í C`, and the
-- one map they define by cases on the alternative,
--
--     ‡µ‡ø‡ï‡≤‡‡‡ = rec f g : A ‚ä B ‚í C,      ‡µ‡ø‡ï‡≤‡‡‡ (inl a) = f a
--                                          ‡µ‡ø‡ï‡≤‡‡‡ (inr b) = g b
--
-- Then for every target `c`,
--
--     ¬ß‡ß   fiber ‡µ‡ø‡ï‡≤‡‡‡ c  ‚â  (fiber f c ‚ä fiber g c).
--
-- The fiber of a case-map is the case of the fibers. The equivalence is
-- purely re-bracketing ‚î both round-trips are `refl` ‚î because `rec`
-- computes on `inl`/`inr` definitionally, so `f a ‚â° c` and `‡µ‡ø‡ï‡≤‡‡‡
-- (inl a) ‚â° c` are the same proof, only re-labelled.
--
-- The corpus already carries this law in three concrete disguises and
-- had not abstracted it:
--   ¬ `Virahanka_‚¶.agda`   fiber ‡‡®‡‡¶‡ (2+n) ‚â (fiber ‡‡®‡‡¶‡ (1+n) ‚ä fiber ‡‡®‡‡¶‡ n)
--   ¬ `AksharaDvaya_‚¶.agda` the same for the Bool mtr weight,
--   ¬ `Bhara_‚¶.agda`       the head-split of a weighted counting map.
-- Each of those is a fiber splitting into a laghu-summand and a
-- guru-summand ‚î Virahka's two-step recurrence ‚î and each proved the
-- splitting by hand. They are not literally instances of ¬ß‡ß (their
-- domain is `List`, not a bare `A ‚ä B`), but they are all the same
-- phenomenon: an alternative in the source becomes an alternative in the
-- fiber. ¬ß‡ß is that phenomenon with nothing else attached.
--
-- ¬ß‡® is why Pigala's numbers ADD across such a split. If the two
-- fibers are finite ‚î `fiber f c ‚â Fin m` and `fiber g c ‚â Fin n` ‚î then
--
--     ¬ß‡®   fiber ‡µ‡ø‡ï‡≤‡‡‡ c  ‚â  Fin (m + n).
--
-- This is ¬ß‡ß composed with the library's `‚ä-equiv` and
-- `Fin+‚âFin‚äFin`: the two receipts, chained, turn the twofold of fibers
-- into one flat count, and the count is the SUM. That `+` is where
-- Virahka's addition and Halyudha's row-sum come from ‚î not from any
-- arithmetic done on the numbers, but from the coproduct in the fiber.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ON THE NAME. ‡µ‡ø‡ï‡≤‡‡ is the traditional term, in Pinian grammar and
-- in Nyya, for a twofold option / disjunction ‚î the "either‚ìor". The
-- coproduct `A ‚ä B` is exactly that alternative, and `rec f g` is the
-- map that acts by which side of the alternative it is handed. Source
-- for the term: PINI, ‡‡‡‡ü‡æ‡ß‡‡Ø‡æ‡Ø‡ (~500 BCE), where optionality is
-- carried by ‡µ‡æ and ‡µ‡ø‡‡æ‡‡æ (e.g. ‡ß.‡ß.‡‡ ‡® ‡µ‡‡‡ø ‡µ‡ø‡‡æ‡‡æ ‚î "vibh means
-- 'or not'"), the grammar's device for a rule that splits into cases.
------------------------------------------------------------------------

module Vikalpa_TheFiberOfATwofoldMapIsTheTwofoldOfItsFibersAndSoTheCountsAdd where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber ; compEquiv ; invEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr ; rec)
open import Cubical.Data.Sum.Properties using (‚äé-equiv)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (‚Ñï ; _+_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (Fin+‚âÖFin‚äéFin)

private variable ‚Ñì ‚Ñì' ‚Ñì'' : Level

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} {C : Type ‚Ñì''} (f : A ‚Üí C) (g : B ‚Üí C) where

  -- the twofold map: act by whichever side of the alternative is given.
  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É : A ‚äé B ‚Üí C
  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É = rec f g

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡ø‡ï‡≤‡‡-‡‡®‡‡‡‡ ‚î the fiber of the case-map is the case of the fibers.
--     Pure re-bracketing: `rec` computes on the constructors, so each
--     proof carries across untouched and both round-trips are refl.
------------------------------------------------------------------------

  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É : (c : C) ‚Üí fiber ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É c ‚âÉ (fiber f c ‚äé fiber g c)
  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É c = isoToEquiv (iso ‡§≠‡§ô‡•ç‡§ó‡§É ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É)
    where
      ‡§≠‡§ô‡•ç‡§ó‡§É : fiber ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É c ‚Üí (fiber f c ‚äé fiber g c)
      ‡§≠‡§ô‡•ç‡§ó‡§É (inl a , p) = inl (a , p)
      ‡§≠‡§ô‡•ç‡§ó‡§É (inr b , p) = inr (b , p)

      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : (fiber f c ‚äé fiber g c) ‚Üí fiber ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É c
      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inl (a , p)) = inl a , p
      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inr (b , p)) = inr b , p

      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : fiber f c ‚äé fiber g c) ‚Üí ‡§≠‡§ô‡•ç‡§ó‡§É (‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É y) ‚â° y
      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inl _) = refl
      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inr _) = refl

      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (x : fiber ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É c) ‚Üí ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (‡§≠‡§ô‡•ç‡§ó‡§É x) ‚â° x
      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inl a , p) = refl
      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inr b , p) = refl

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡ø‡ï‡≤‡‡-‡ó‡‡®‡æ ‚î two finite receipts on the two fibers flatten to one
--     count on the twofold fiber, and that count is their SUM.  This is
--     ¬ß‡ß composed with `‚ä-equiv` and the library's `Fin+‚âFin‚äFin`.
------------------------------------------------------------------------

  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™-‡§ó‡§£‡§®‡§æ : {m n : ‚Ñï} (c : C)
    ‚Üí fiber f c ‚âÉ Fin m
    ‚Üí fiber g c ‚âÉ Fin n
    ‚Üí fiber ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™‡§É c ‚âÉ Fin (m + n)
  ‡§µ‡§ø‡§ï‡§≤‡•ç‡§™-‡§ó‡§£‡§®‡§æ {m} {n} c ef eg =
    compEquiv (‡§µ‡§ø‡§ï‡§≤‡•ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É c)
      (compEquiv (‚äé-equiv ef eg)
        (invEquiv (isoToEquiv (Fin+‚âÖFin‚äéFin m n))))
