{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module IndependenceNeedsAnInternalImplication where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov
        ; Consistent ; HBL1 ; GoedelFix ; OmegaBad
        ; goedelHalfOne ; noHalfTwo )

------------------------------------------------------------------------
-- IndependenceNeedsAnInternalImplication
--
-- What this lane would have to carry to STATE independence rather than
-- gesture at it — answered by writing the predicate down and finding
-- the one field that is missing.
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUESTION AND WHERE IT CAME FROM
--
-- `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` closes the deflationary
-- thread and leaves one thing open: a real barrier is independence FROM
-- A THEORY or non-existence of an algorithm UNIFORM IN A PARAMETER, and
-- "stating one requires a theory to be independent OF … objects this
-- lane does not carry.  `GodelSeparation` is the corpus's one gesture
-- at the first."  The uniform route was opened at `3b2e9756`
-- (`TheUniformFormIsNotRefuted`).  This is the other one.
--
-- ────────────────────────────────────────────────────────────────────
-- A CORRECTION TO THAT NOTE, ON READING THE MODULE IT CITES
--
-- The lane DOES carry the objects.  `GodelSeparation.Theory` is a record
-- with `Sent`, `Pf`, `neg`, `prov`; `Consistent`, `HBL1`, `GoedelFix`
-- and `OmegaBad` are defined over it; `goedelHalfOne` proves `¬ Pf T G`
-- from consistency, HBL1 and the fixed point; and `noHalfTwo` REFUTES
-- the other conjunct from those same data with a four-sentence
-- countermodel `Wit`.  That is not a gesture at independence.  It is
-- one conjunct proved, the other conjunct's derivability refuted, and
-- the ω-consistency failure of the countermodel exhibited
-- (`witOmegaBad`).
--
-- What was missing was smaller and more specific than "the objects":
-- nobody had written down the predicate `Independent`, so the corpus
-- had both halves of a statement it had never stated.  §1 states it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `Independent T s = (¬ Pf T s) × (¬ Pf T (neg T s))`.  A
--       definition, in the corpus's own vocabulary, with nothing added.
--
--   §2  the first conjunct is available: `goedelHalfOne` gives it from
--       consistency, HBL1 and the fixed point.
--
--   §3  and independence is NOT derivable from those data — the
--       universally quantified implication is refuted outright, by
--       `noHalfTwo`, which supplies the countermodel.  So the gap is
--       exhibited, not merely unclosed.
--
--   §4  what closes it, stated as the hypotheses it needs.  Given an
--       INTERNAL implication — a former `imp : Sent → Sent → Sent` with
--       modus ponens at the `Pf` level — and the internal sentence
--       `¬G → Prov(G)`, ω-consistency closes the second conjunct in
--       three lines.
--
-- ────────────────────────────────────────────────────────────────────
-- SO THE ANSWER TO "WHICH LANE", ON THIS ROUTE
--
-- Not a theory object: `Theory` is there.  What `Theory` lacks is a
-- CONNECTIVE FORMER.  It carries `neg` and `prov`, both `Sent → Sent`,
-- and no way to build one sentence from two.  `GoedelFix` is therefore
-- stated at the derivability level — a pair of implications between
-- `Pf` statements — where Gödel's second conjunct needs the
-- biconditional to be a SENTENCE the theory itself proves, so that
-- `T ⊢ ¬G` yields `T ⊢ Prov(G)` by modus ponens inside T.
--
-- One field, `imp`, and one rule, `mp`.  That is the whole distance
-- between this lane and the first route, and §4 measures it by assuming
-- exactly those two and getting the conjunct.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That `Wit` is a bad countermodel: it is a correct one, and §3 depends
-- on it.  That adding `imp` and `mp` yields Gödel's theorem for any
-- real theory — §4 assumes the internal fixed point as a hypothesis and
-- proves nothing about when it holds, which is a representability
-- question about T that neither this file nor `GodelSeparation`
-- addresses.  That ω-consistency is the only route: Rosser's is not
-- formalised here and is not ruled out.  That this reaches
-- independence in the metamathematical sense — `Pf` is a family of
-- types, and whether it models a proof predicate for any actual theory
-- is not settled anywhere in this corpus that I could find.
--
-- PRIOR ART, by grepping the conclusion type rather than the name: a
-- grep of `formal/cubical` for `Independen` finds only
-- `CachePathOrder.batchOrderIndependent`,
-- `M1SplitIdentity.corner-independent` and
-- `ObligatioOrderTrilemma`, all about order-independence of a fold.
-- No predicate of underivability of a sentence and its negation exists.
-- A version phrased as a `¬ Σ` over derivations would evade that grep.
------------------------------------------------------------------------

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  The predicate, written down
------------------------------------------------------------------------

Independent : (T : Theory ℓ) → Sent T → Type ℓ
Independent T s = (¬ Pf T s) × (¬ Pf T (neg T s))

------------------------------------------------------------------------
-- 2.  The conjunct that follows
------------------------------------------------------------------------

independenceFirstHalf :
  (T : Theory ℓ) (G : Sent T)
  → Consistent T → HBL1 T → GoedelFix T G
  → ¬ Pf T G
independenceFirstHalf = goedelHalfOne

------------------------------------------------------------------------
-- 3.  Independence does not follow from those data, with the witness
--
-- Any derivation of `Independent` from consistency, HBL1 and the fixed
-- point yields the refuted second conjunct by projection, so `noHalfTwo`
-- applies to it unchanged.
------------------------------------------------------------------------

independenceNotDerivable :
  ((T : Theory ℓ-zero) (G : Sent T)
     → Consistent T → HBL1 T → GoedelFix T G
     → Independent T G)
  → ⊥
independenceNotDerivable ind =
  noHalfTwo (λ T G con d1 fix → snd (ind T G con d1 fix))

------------------------------------------------------------------------
-- 4.  What closes it: one connective former, one rule, ω-consistency
--
-- `Theory` has `neg` and `prov`, both unary.  It has no way to build a
-- sentence from two sentences, so the fixed point can only be stated
-- about `Pf`.  Assume the two missing pieces explicitly and the second
-- conjunct follows.
------------------------------------------------------------------------

module _ (T : Theory ℓ) (G : Sent T)
         (imp : Sent T → Sent T → Sent T)
         (mp  : (a b : Sent T) → Pf T (imp a b) → Pf T a → Pf T b)
         where

  -- the internal sentence Gödel's argument needs: from ¬G, provability
  -- of G — which is the fixed point read INSIDE the theory.
  InternalFix : Type ℓ
  InternalFix = Pf T (imp (neg T G) (prov T G))

  independenceSecondHalf :
      InternalFix
    → (¬ Pf T G)
    → (¬ OmegaBad T G)
    → ¬ Pf T (neg T G)
  independenceSecondHalf ifix notG notOmegaBad pNegG =
    notOmegaBad (mp (neg T G) (prov T G) ifix pNegG , notG)

  -- and independence, assembled from §2 and the above
  independence :
      Consistent T → HBL1 T → GoedelFix T G
    → InternalFix → (¬ OmegaBad T G)
    → Independent T G
  independence con d1 fix ifix notOmegaBad =
      goedelHalfOne T G con d1 fix
    , independenceSecondHalf ifix (goedelHalfOne T G con d1 fix) notOmegaBad
