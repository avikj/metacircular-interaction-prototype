{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NRectanglesCannotCoverSucNFoolingCellsEvenWhenTheCoveringIsOnlyAProperty
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`, and grepped
-- invented.**  The pigeonhole step and the fooling-set method are not
-- structures I can trace to a source in this corpus's traditions, and
-- attaching a  label to them would assert a provenance nobody
-- checked ‚î the mirror of the scrubbing the naming rule corrects.  Jaina
-- enumerative mathematics (*Anuyogadvra*, *Sthnga*) is combinatorial
-- and adjacent, and I am NOT claiming it as the source of this argument;
-- I have not established that, and saying so is cheaper than a citation
-- I cannot defend.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT FINDING.
--
-- `NRectanglesCannotCoverSucNFoolingCells` is titled as an impossibility
-- about COVERING, and covering is naturally a PROPERTY: a cell is
-- covered when SOME rectangle of the family is sound and contains it.
-- What the theorem there actually takes is different and stronger ‚î
--
--     (pick : Fin (suc n) ‚í Fin n)
--     ‚í ((i : ‚¶) ‚í Sound (rects (pick i)))
--     ‚í ((i : ‚¶) ‚í Covers (rects (pick i)) (r i) (c i))
--
-- ‚î i.e. a cover ALREADY EQUIPPED with a choice of which rectangle
-- serves each cell.  That is structure handed to the theorem, not a
-- hypothesis about the family, and the module's ¬ß"SYT ‚î THE CLAIM, EXACTLY"
-- does not mention it: it disclaims upper bounds, r_e, d_e, raw width
-- and the min-cover/max-fooling equality, and says nothing about the
-- shape of its own covering hypothesis.
--
-- **THE GAP IS REAL BUT IT IS NOT A HOLE ‚î IT IS A PRICE, AND THE PRICE
-- IS FINITE CHOICE.**  Two repairs, both here:
--
--   1.  Untruncated.  If the hypothesis is `(i) ‚í Œ[ k ] (Sound ó Covers)`
--       then `pick i = fst (h i)` and the rest is projection.  FREE ‚î
--       a Œ† of Œ already contains its own choice function.
--   2.  Truncated, which is the honest reading of "is covered".  If the
--       hypothesis is `(i) ‚í ‚à Œ[ k ] (Sound ó Covers) ‚à‚` then no
--       `pick` can be projected out, because the conclusion for a single
--       cell is not a proposition.  It goes through anyway, and what
--       pays for it is `finChoiceFin` ‚î choice over a FINITE index into
--       a propositional truncation, proved here by induction on `n` with
--       `fsplit`.  The final goal being `‚ä`, a proposition, is what lets
--       the truncation be eliminated at the end.
--
-- **AND THAT IS THE DIAGNOSTIC FROM ecb432c2 AND 53a06cc9 GIVING ITS
-- THIRD ANSWER.**  Ask what joins the two sides.  An implication assumed
-- has no inverse, so the converse is a search (53a06cc9).  A path given
-- has one, so it is free (ecb432c2).  Here the two sides are joined by a
-- TRUNCATION, and the answer is neither: it is free for a finite index
-- and unavailable in general.  Finiteness is doing the work, and it is
-- the first time on this line that anything has needed finiteness for a
-- reason other than the pigeonhole.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   finChoiceFin     ((i : Fin n) ‚í ‚à B i ‚à‚) ‚í ‚à ((i : Fin n) ‚í B i) ‚à‚
--   CoveredBy        covering as a property: a truncated Œ
--   cannotCoverSigma      the untruncated repair, by projection
--   cannotCoverTruncated  the truncated one, through `finChoiceFin`
--
-- Neither restates the old theorem: both END at it.  `pick`, `sound`
-- and `covers` are constructed from the hypothesis and handed to
-- `nRectanglesCannotCoverSucNFoolingCells` unchanged.
------------------------------------------------------------------------

module NRectanglesCannotCoverSucNFoolingCellsEvenWhenTheCoveringIsOnlyAProperty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Fin using (Fin ; fzero ; fsuc ; fsplit ; ¬¨Fin0)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ‚ä• using (‚ä• ; isProp‚ä•)
open import Cubical.HITs.PropositionalTruncation as PT
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers)
open import AFoolingSetForcesDistinctRectangles
  using (Fooling)
open import NRectanglesCannotCoverSucNFoolingCells
  using (nRectanglesCannotCoverSucNFoolingCells)

------------------------------------------------------------------------
-- 1.  Choice over a finite index, into a truncation
--
-- Induction on the BOUND, not on the element: `fsplit` does the case
-- analysis and `subst` transports along the path it returns, which is
-- the standing idiom here for avoiding a match in an index position.
------------------------------------------------------------------------

assembleFin :
  {n : ‚Ñï} (B : Fin (suc n) ‚Üí Type)
  ‚Üí B fzero ‚Üí ((j : Fin n) ‚Üí B (fsuc j)) ‚Üí (i : Fin (suc n)) ‚Üí B i
assembleFin B b0 g i with fsplit i
... | inl p       = subst B p b0
... | inr (j , p) = subst B p (g j)

finChoiceFin :
  (n : ‚Ñï) (B : Fin n ‚Üí Type)
  ‚Üí ((i : Fin n) ‚Üí ‚à• B i ‚à•‚ÇÅ) ‚Üí ‚à• ((i : Fin n) ‚Üí B i) ‚à•‚ÇÅ
finChoiceFin zero    B h = ‚à£ (Œª i ‚Üí ‚ä•.rec (¬¨Fin0 i)) ‚à£‚ÇÅ
finChoiceFin (suc n) B h =
  PT.rec2 isPropPropTrunc
    (Œª b0 g ‚Üí ‚à£ assembleFin B b0 g ‚à£‚ÇÅ)
    (h fzero)
    (finChoiceFin n (Œª j ‚Üí B (fsuc j)) (Œª j ‚Üí h (fsuc j)))

------------------------------------------------------------------------
-- 2.  Covering as a property, and both repairs
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row ‚Üí Col ‚Üí Bool) where

  ServedBy :
    (n : ‚Ñï) (rects : Fin n ‚Üí Rect Row Col M) (x : Row) (y : Col) ‚Üí Type
  ServedBy n rects x y =
    Œ£[ k ‚àà Fin n ]
      (Sound Row Col M (rects k) √ó Covers Row Col M (rects k) x y)

  CoveredBy :
    (n : ‚Ñï) (rects : Fin n ‚Üí Rect Row Col M) (x : Row) (y : Col) ‚Üí Type
  CoveredBy n rects x y = ‚à• ServedBy n rects x y ‚à•‚ÇÅ

  ----------------------------------------------------------------------
  -- 2a.  Untruncated: the choice function is already in the hypothesis
  ----------------------------------------------------------------------

  cannotCoverSigma :
    (n : ‚Ñï) (r : Fin (suc n) ‚Üí Row) (c : Fin (suc n) ‚Üí Col)
    ‚Üí Fooling Row Col M (Fin (suc n)) r c
    ‚Üí (rects : Fin n ‚Üí Rect Row Col M)
    ‚Üí ((i : Fin (suc n)) ‚Üí ServedBy n rects (r i) (c i))
    ‚Üí ‚ä•
  cannotCoverSigma n r c fool rects h =
    nRectanglesCannotCoverSucNFoolingCells Row Col M n r c fool rects
      (Œª i ‚Üí fst (h i))
      (Œª i ‚Üí fst (snd (h i)))
      (Œª i ‚Üí snd (snd (h i)))

  ----------------------------------------------------------------------
  -- 2b.  Truncated: finite choice pays for the missing `pick`
  ----------------------------------------------------------------------

  cannotCoverTruncated :
    (n : ‚Ñï) (r : Fin (suc n) ‚Üí Row) (c : Fin (suc n) ‚Üí Col)
    ‚Üí Fooling Row Col M (Fin (suc n)) r c
    ‚Üí (rects : Fin n ‚Üí Rect Row Col M)
    ‚Üí ((i : Fin (suc n)) ‚Üí CoveredBy n rects (r i) (c i))
    ‚Üí ‚ä•
  cannotCoverTruncated n r c fool rects h =
    PT.rec isProp‚ä•
      (cannotCoverSigma n r c fool rects)
      (finChoiceFin (suc n) (Œª i ‚Üí ServedBy n rects (r i) (c i)) h)
