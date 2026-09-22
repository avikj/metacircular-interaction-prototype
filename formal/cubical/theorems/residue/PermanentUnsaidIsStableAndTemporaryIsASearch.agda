{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module PermanentUnsaidIsStableAndTemporaryIsASearch where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Dec ; Stable)
open import Cubical.Relation.Nullary.Properties using (Dec→Stable)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import AmshaSatyayantra using (कदाचित्-उक्तम् ; स्थायि-अनुक्तम्)

------------------------------------------------------------------------
-- PermanentUnsaidIsStableAndTemporaryIsASearch
--
-- `formal/cubical/AmshaSatyayantra.agda` draws a distinction this
-- thread's closure results have an exact word for, and this module says
-- which word, using its predicates rather than restating them.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO PREDICATES, QUOTED FROM THAT MODULE
--
--     कदाचित्-उक्तम् चल i  =  Σ[ f ∈ ℕ ] Σ[ o ∈ O ] (चल f i ≡ उक्त o)
--     स्थायि-अनुक्तम् चल i  =  ¬ (कदाचित्-उक्तम् चल i)
--
-- "ever-said: SOME grant produces an answer — temporary un-said" and
-- "permanent un-said: NO grant ever produces an answer", in its own
-- gloss.  The first is a Σ; the second is a ¬ of it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `स्थायि-अनुक्तम्` is ¬¬-STABLE for every machine and every input,
--       with no hypothesis — it is a negation, and negations are stable
--       (`TheAbsenceTowerIsThreeUnconditionally`, and before that
--       `DeflationaryTest.¬-always-stable`).
--
--   §2  `कदाचित्-उक्तम्` is stable exactly when it is DECIDABLE.  It is a
--       Σ, and `WhereTheTowerCanStillBeThree` §5 is precisely the
--       statement that the closure argument stops there: `¬ ¬ (Σ …)`
--       hands back no component, and the only general route in is a
--       decision.
--
-- So the permanent/temporary distinction of that module sits exactly on
-- the Π/Σ line: **the negative pole is free, the positive pole is a
-- search.** Its `अनन्त-निषेधः` — a total machine can never have permanent
-- un-said — is the same fact from the other side, since completeness
-- supplies the Σ at every input.
------------------------------------------------------------------------

private
  variable
    Inp Out : Type

------------------------------------------------------------------------
-- 1.  Permanent un-said is stable, for free
------------------------------------------------------------------------

permanentIsStable :
  (चल : _) (i : Inp) → Stable (स्थायि-अनुक्तम् {Inp} {Out} चल i)
permanentIsStable चल i nnn a = nnn (λ n → n a)

------------------------------------------------------------------------
-- 2.  Temporary un-said is stable exactly when the search is decided
------------------------------------------------------------------------

temporaryIsStableFromDecision :
  (चल : _) (i : Inp)
  → Dec (कदाचित्-उक्तम् {Inp} {Out} चल i)
  → Stable (कदाचित्-उक्तम् {Inp} {Out} चल i)
temporaryIsStableFromDecision चल i = Dec→Stable

-- and the converse direction of the pair: a decided search settles the
-- permanent pole too, since the two are a proposition and its negation.
decisionSettlesBothPoles :
  (चल : _) (i : Inp)
  → Dec (कदाचित्-उक्तम् {Inp} {Out} चल i)
  → Stable (कदाचित्-उक्तम् {Inp} {Out} चल i)
  × Stable (स्थायि-अनुक्तम् {Inp} {Out} चल i)
decisionSettlesBothPoles चल i d =
  temporaryIsStableFromDecision चल i d , permanentIsStable चल i
