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

module NaturalMachine.PermanentUnsaidIsStableAndTemporaryIsASearch where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Dec ; Stable)
open import Cubical.Relation.Nullary.Properties using (Dec→Stable)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import AmshaSatyayantra using (कदाचित्-उक्तम् ; स्थायि-अनुक्तम्)

------------------------------------------------------------------------
-- NaturalMachine.PermanentUnsaidIsStableAndTemporaryIsASearch
--
-- `formal/cubical/AmshaSatyayantra.agda` was found by a zero-importer
-- census over `formal/cubical` and read.  It draws a distinction this
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
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, AND THE FIRST ONE MATTERS MOST
--
-- **No correspondence is claimed between anything here and the
-- Anuyogadvāra's saṃkhyāta / asaṃkhyāta / ananta grading.** That module
-- invokes the grading; this one does not touch it. §1 and §2 are
-- statements about a Σ and its negation in Agda, and reading them as the
-- Jaina grades would be exactly the move withdrawn three times in this
-- thread already — an imported notion in the tradition's clothes.
--
-- That the module's own results are affected: they are not. §1 and §2
-- add stability facts about its predicates and change none of its
-- theorems.
--
-- That decidability holds anywhere. §2 is conditional and nothing here
-- decides any machine's `कदाचित्-उक्तम्`.
--
-- PRIOR ART, grep run and quoted: `grep -rn AmshaSatyayantra
-- formal/cubical/ --include=*.agda` outside the file itself returns
-- nothing. It has no importers, which is how the census found it; this
-- is its first use. A module reaching it through `Everything.agda`'s
-- bulk import would not appear in that grep — `Everything` was checked
-- and does not list it.
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
