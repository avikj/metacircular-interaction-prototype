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

module NaturalMachine.RepresentabilityIsNotEnoughForIndependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov ; Consistent ; HBL1
        ; W ; wtop ; wbot ; wg ; wng ; wneg ; wPf
        ; Wit ; witCon ; witHBL1 ; witProvesNegG ; witOmegaBad ; OmegaBad )
open import NaturalMachine.IndependenceNeedsAnInternalImplication
  using (Independent)
open import NaturalMachine.TheDiagonalLemmaDischargesGoedelFix
  using (HasDiagonal ; goedelSentence)

------------------------------------------------------------------------
-- NaturalMachine.RepresentabilityIsNotEnoughForIndependence
--
-- The previous module wrote representability down and asked, in its own
-- NOT CLAIMED block, whether anything satisfies it.  Something does:
-- the corpus's own four-sentence countermodel.  And that settles more
-- than inhabitation.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `Wit` — `GodelSeparation`'s countermodel, four sentences, with
--       `prov` constantly ⊤ — carries a `HasDiagonal`.  The internal
--       implication is the truth-functional one over the four
--       sentences, modus ponens holds by exhaustion, and the diagonal
--       fixed point at `¬ prov(−)` is `wg`.
--
--   §2  so `HasDiagonal` is INHABITED: it is not a vacuous record, and
--       the previous module's theorems are not empty.
--
--   §3  and the stronger consequence.  `Wit` is consistent
--       (`witCon`), satisfies HBL1 (`witHBL1`), now satisfies full
--       representability (§1), and PROVES ¬G (`witProvesNegG`).  So
--
--         consistency + HBL1 + representability  ⊬  independence
--
--       and any derivation of independence from those three, applied
--       to `Wit`, yields ⊥.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS UPGRADES
--
-- `GodelSeparation.noHalfTwo` refutes the second conjunct from
-- consistency, HBL1 and `GoedelFix`.  Someone could have answered that
-- `GoedelFix` is a weak stand-in for the real hypothesis — that a
-- theory which genuinely represents its own provability predicate would
-- not behave like `Wit`.  §3 closes that: `Wit` represents it, in the
-- full sense of §1, and behaves like `Wit` anyway.
--
-- The missing ingredient is therefore isolated with no room left for it
-- to be representability: it is ω-consistency, and `witOmegaBad` is
-- already in the corpus, exhibiting `Wit`'s failure of it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE HONEST LIMIT OF §1, STATED BECAUSE IT IS EASY TO OVERSELL
--
-- `Form` here is `Unit`: one formula, the only one the argument needs.
-- That is enough to inhabit the record and enough for §3, and it is NOT
-- evidence that `HasDiagonal` captures arithmetisation.  A structure
-- with one formula has no substitution, no coding, and no way to
-- express a diagonal for anything else.  What §1 shows is that the
-- record as written is satisfiable — which is exactly what was needed
-- to know that §3 is not vacuous, and no more.
--
-- A reader wanting `HasDiagonal` to mean arithmetisation should
-- strengthen it — a `Form` closed under the connectives, substitution,
-- a coding — and none of that is here or, on a grep of
-- `formal/cubical` for `Representab` and `Form`, anywhere in this
-- corpus.  A version phrased over a Gödel numbering function rather
-- than a formula type would evade that grep.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That `Wit` is a bad model: it is a correct one and §3 depends on it.
-- That ω-consistency suffices — the previous module derives the second
-- conjunct from it together with three internal rules, and whether
-- those rules hold in `Wit` is not asked here.  That any theory of
-- arithmetic satisfies §1's record.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The internal implication on four sentences, and modus ponens
--
-- Provable: `wtop`, `wng`.  Unprovable: `wbot`, `wg`.  `wimp a b` is
-- `wtop` exactly when provability of `a` entails provability of `b`.
------------------------------------------------------------------------

wimp : W → W → W
wimp wbot _    = wtop
wimp wg   _    = wtop
wimp wtop wtop = wtop
wimp wtop wng  = wtop
wimp wtop wbot = wbot
wimp wtop wg   = wbot
wimp wng  wtop = wtop
wimp wng  wng  = wtop
wimp wng  wbot = wbot
wimp wng  wg   = wbot

wmp : (a b : W) → wPf (wimp a b) → wPf a → wPf b
wmp wbot _    _ pa = Empty.rec pa
wmp wg   _    _ pa = Empty.rec pa
wmp wtop wtop _ _  = tt
wmp wtop wng  _ _  = tt
wmp wtop wbot i _  = Empty.rec i
wmp wtop wg   i _  = Empty.rec i
wmp wng  wtop _ _  = tt
wmp wng  wng  _ _  = tt
wmp wng  wbot i _  = Empty.rec i
wmp wng  wg   i _  = Empty.rec i

------------------------------------------------------------------------
-- 2.  `Wit` carries a diagonal
--
-- One formula, `¬ prov(−)`, which in `Wit` is constantly `wbot` since
-- `prov` is constantly `wtop`.  Its fixed point is `wg`: `wimp wg wbot`
-- is `wtop` because `wg` is unprovable, and `wimp wbot wg` is `wtop`
-- because `wbot` is.
------------------------------------------------------------------------

witHasDiagonal : HasDiagonal Wit
witHasDiagonal = record
  { imp        = wimp
  ; mp         = wmp
  ; Form       = Unit
  ; app        = λ _ _ → wbot
  ; fix        = λ _ → wg , (tt , tt)
  ; negProv    = tt
  ; negProv-is = λ _ → refl
  }

------------------------------------------------------------------------
-- 3.  Consistency + HBL1 + representability do not give independence
------------------------------------------------------------------------

witGoedelSentence : goedelSentence Wit witHasDiagonal ≡ wg
witGoedelSentence = refl

witNotIndependent : ¬ (Independent Wit wg)
witNotIndependent ind = snd ind witProvesNegG

representabilityIsNotEnough :
  ( (T : Theory ℓ-zero) (D : HasDiagonal T)
    → Consistent T → HBL1 T → Independent T (goedelSentence T D) )
  → ⊥
representabilityIsNotEnough f =
  witNotIndependent (f Wit witHasDiagonal witCon witHBL1)

-- and the ingredient that is left, named as a term rather than in prose:
-- `Wit` fails ω-consistency exactly, and the corpus already had this.
theRemainingIngredient : OmegaBad Wit wg
theRemainingIngredient = witOmegaBad
