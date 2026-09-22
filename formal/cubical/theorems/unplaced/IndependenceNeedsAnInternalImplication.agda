{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module IndependenceNeedsAnInternalImplication where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; snd)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov
        ; Consistent ; HBL1 ; GoedelFix ; OmegaBad
        ; goedelHalfOne ; noHalfTwo )

------------------------------------------------------------------------
-- IndependenceNeedsAnInternalImplication
--
-- `GodelSeparation.Theory` is a record
-- with `Sent`, `Pf`, `neg`, `prov`; `Consistent`, `HBL1`, `GoedelFix`
-- and `OmegaBad` are defined over it; `goedelHalfOne` proves `Â Pf T G`
-- from consistency, HBL1 and the fixed point; and `noHalfTwo` REFUTES
-- the other conjunct from those same data with a four-sentence
-- countermodel `Wit`.  That is
-- one conjunct proved, the other conjunct's derivability refuted, and
-- the Ï‰-consistency failure of the countermodel exhibited
-- (`witOmegaBad`).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `Independent T s = (Â Pf T s) — (Â Pf T (neg T s))`.  A
--       definition, in the corpus's own vocabulary, with nothing added.
--
--   Â§2  the first conjunct is available: `goedelHalfOne` gives it from
--       consistency, HBL1 and the fixed point.
--
--   Â§3  and independence is NOT derivable from those data â” the
--       universally quantified implication is refuted outright, by
--       `noHalfTwo`, which supplies the countermodel.  So the gap is
--       exhibited, not merely unclosed.
--
--   Â§4  what closes it, stated as the hypotheses it needs.  Given an
--       INTERNAL implication â” a former `imp : Sent â’ Sent â’ Sent` with
--       modus ponens at the `Pf` level â” and the internal sentence
--       `ÂG â’ Prov(G)`, Ï‰-consistency closes the second conjunct in
--       three lines.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- What `Theory` lacks is a
-- CONNECTIVE FORMER.  It carries `neg` and `prov`, both `Sent â’ Sent`,
-- and no way to build one sentence from two.  `GoedelFix` is therefore
-- stated at the derivability level â” a pair of implications between
-- `Pf` statements â” where Gdel's second conjunct needs the
-- biconditional to be a SENTENCE the theory itself proves, so that
-- `T âŠ ÂG` yields `T âŠ Prov(G)` by modus ponens inside T.
--
-- One field, `imp`, and one rule, `mp`.  Â§4 measures that distance by
-- assuming exactly those two and getting the conjunct.
--
------------------------------------------------------------------------

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  The predicate, written down
------------------------------------------------------------------------

Independent : (T : Theory â„“) â†’ Sent T â†’ Type â„“
Independent T s = (Â¬ Pf T s) Ã— (Â¬ Pf T (neg T s))

------------------------------------------------------------------------
-- 2.  The conjunct that follows
------------------------------------------------------------------------

independenceFirstHalf :
  (T : Theory â„“) (G : Sent T)
  â†’ Consistent T â†’ HBL1 T â†’ GoedelFix T G
  â†’ Â¬ Pf T G
independenceFirstHalf = goedelHalfOne

------------------------------------------------------------------------
-- 3.  Independence does not follow from those data, with the witness
--
-- Any derivation of `Independent` from consistency, HBL1 and the fixed
-- point yields the refuted second conjunct by projection, so `noHalfTwo`
-- applies to it unchanged.
------------------------------------------------------------------------

independenceNotDerivable :
  ((T : Theory â„“-zero) (G : Sent T)
     â†’ Consistent T â†’ HBL1 T â†’ GoedelFix T G
     â†’ Independent T G)
  â†’ âŠ¥
independenceNotDerivable ind =
  noHalfTwo (Î» T G con d1 fix â†’ snd (ind T G con d1 fix))

------------------------------------------------------------------------
-- 4.  What closes it: one connective former, one rule, Ï‰-consistency
--
-- `Theory` has `neg` and `prov`, both unary.  It has no way to build a
-- sentence from two sentences, so the fixed point can only be stated
-- about `Pf`.  Assume the two missing pieces explicitly and the second
-- conjunct follows.
------------------------------------------------------------------------

module _ (T : Theory â„“) (G : Sent T)
         (imp : Sent T â†’ Sent T â†’ Sent T)
         (mp  : (a b : Sent T) â†’ Pf T (imp a b) â†’ Pf T a â†’ Pf T b)
         where

  -- the internal sentence Gdel's argument needs: from ÂG, provability
  -- of G â” which is the fixed point read INSIDE the theory.
  InternalFix : Type â„“
  InternalFix = Pf T (imp (neg T G) (prov T G))

  independenceSecondHalf :
      InternalFix
    â†’ (Â¬ Pf T G)
    â†’ (Â¬ OmegaBad T G)
    â†’ Â¬ Pf T (neg T G)
  independenceSecondHalf ifix notG notOmegaBad pNegG =
    notOmegaBad (mp (neg T G) (prov T G) ifix pNegG , notG)

  -- and independence, assembled from Â§2 and the above
  independence :
      Consistent T â†’ HBL1 T â†’ GoedelFix T G
    â†’ InternalFix â†’ (Â¬ OmegaBad T G)
    â†’ Independent T G
  independence con d1 fix ifix notOmegaBad =
      goedelHalfOne T G con d1 fix
    , independenceSecondHalf ifix (goedelHalfOne T G con d1 fix) notOmegaBad
