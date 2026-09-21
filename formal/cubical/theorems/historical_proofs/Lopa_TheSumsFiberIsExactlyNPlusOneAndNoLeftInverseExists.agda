{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡≤‡ã‡‡ ‚î ‡‡¶‡∞‡‡‡®‡ ‡≤‡ã‡‡ ‡  ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø ‡Ø‡ã‡ó‡, ‡ï‡ ‡®‡‡‡Ø‡‡ø ‡‡‡¶‡ ‡
--
-- (what survives is the sum; what is destroyed is the split.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TERM, ITS TEXT AND ITS DATE.
--
-- **‡≤‡ã‡** ¬ lopa, elision.  Pini, *Adhyy* **1.1.60**, ‡‡¶‡∞‡‡‡®‡ ‡≤‡ã‡‡ ‚î
-- "lopa is non-appearance" (~500 BCE).  The grammar's own name for a
-- licensed step after which something that was in the form is not in the
-- form.  Its companion **1.1.62**, ‡‡‡∞‡‡‡Ø‡Ø‡≤‡ã‡‡ ‡‡‡∞‡‡‡Ø‡Ø‡≤‡ï‡‡‡‡Æ‡ ‚î "when an
-- affix has been elided, the operations conditioned by the affix still
-- apply" ‚î is why the term fits this module rather than merely decorating
-- it: Pini's system does not merely delete, it RECORDS what the deleted
-- element conditioned.  ¬ß‡© below is that recording, as a fiber.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EDGE AND NOT ANOTHER.
--
-- `machine/Setubandha_‚¶hs` built the graph of the corpus's checked
-- identifications; every edge in it is invertible, so its gluing defect is
-- `machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs`
-- built the other graph ‚î 1054 one-way edges over 474 nodes, against 88
-- invertible edges over 120 ‚î and 1036 of those 1054 came back UNDECIDED
-- because no syntactic rule can name a fiber.
--
-- This is one of the ones that can be named, and it is the sharpest,
-- because the naming was ALREADY IN THE CORPUS TWICE and nothing had put
-- the two together:
--
--   `LosslessReturn_‚¶TransportGivesIt.‡Ø‡ã‡ó : ‚ï ó ‚ï ‚í ‚ï`, ‡Ø‡ã‡ó x = fst x + snd x
--   `PairsSummingTo.Pairs n = Œ[ ab ‚àà ‚ï ó ‚ï ] (fst ab + snd ab ‚â° n)`
--   `PairsSummingTo.pairsFin : (n : ‚ï) ‚í Pairs n ‚â SumFin (suc n)`
--
-- `Pairs n` IS `fiber ‡Ø‡ã‡ó n`, on the nose (¬ß‡ß, and it is `refl`).  So the
-- elision performed by addition already had its fiber counted, exactly, in
-- a module written for the metrical antidiagonal of Pigala's prastra and
-- never connected to the map whose loss it measures.  No module in this
-- corpus imports both files.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED.
--
--  ¬ß‡ß  fiber ‡Ø‡ã‡ó n ‚â° Pairs n.  Definitional; the identification is refl.
--  ¬ß‡®  fiber ‡Ø‡ã‡ó n ‚â SumFin (suc n).  The loss at n is EXACTLY n+1-fold.
--      Not "at least", not measured ‚î the equivalence is `pairsFin`.
--  ¬ß‡©  The three verdicts of `Avaccheda_‚¶` / `Fiberjala_‚¶`, all three
--      decided at this one edge, which is what makes it worth writing:
--        ‡∞‡ø‡ï‡‡‡Æ‡  NEVER ‚î ‡Ø‡ã‡ó is surjective, witness given.
--        ‡‡ï‡Æ‡    at n = 0 and nowhere else.
--        ‡‡‡     at every n = suc k, with two named histories exhibited
--                and their non-identity proved.
--      A two-valued verdict cannot say this; it would report "not
--      contractible" at every suc k and at ‚ä alike.
--  ¬ß‡  THERE IS NO TRANSPORT IN THE LOSSY DIRECTION, and this is the
--      content of road two rather than a gap in the module: no
--      `g : ‚ï ‚í ‚ï ó ‚ï` is a left inverse of ‡Ø‡ã‡ó.  Proved, not asserted.
--  ¬ß‡  The ‡‡µ‡‡‡‡‡¶ decomposition at this edge: (Œ n) fiber ‡Ø‡ã‡ó n ‚â ‚ï ó ‚ï.
--      The pair IS (its sum, which pair of that sum) ‚î ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø /
--      ‡ï‡ ‡®‡‡‡Ø‡‡ø, as one equivalence.
------------------------------------------------------------------------

module Lopa_TheSumsFiberIsExactlyNPlusOneAndNoLeftInverseExists where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; fiber)
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; +-zero ; znots)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd ; Œ£-syntax)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.SumFin using () renaming (Fin to SumFin)

open import PairsSummingTo using (Pairs ; pairsFin)
open import LosslessReturn_TheHandProofWasUnnecessaryAndTransportGivesIt using (‡§Ø‡•ã‡§ó)
import Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFiberFailingToBeContractible as ‡§Ö‡§µ

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î the fiber of the sum IS the antidiagonal.
--
-- `‡Ø‡ã‡ó x = fst x + snd x` and `Pairs n = Œ[ ab ‚àà ‚ï ó ‚ï ] (fst ab + snd ab
-- ‚â° n)`, so `fiber ‡Ø‡ã‡ó n` unfolds to `Pairs n` with no work at all.  That
-- the identification is `refl` is the finding, not a weakness of it: two
-- modules written for unrelated purposes had already defined the same
-- type, one as a loss and one as a count, and neither imported the other.
------------------------------------------------------------------------

‡§≤‡•ã‡§™‡§∏‡•ç‡§Ø-‡§§‡§®‡•ç‡§§‡•Å‡§É : (n : ‚Ñï) ‚Üí fiber ‡§Ø‡•ã‡§ó n ‚â° Pairs n
‡§≤‡•ã‡§™‡§∏‡•ç‡§Ø-‡§§‡§®‡•ç‡§§‡•Å‡§É n = refl

------------------------------------------------------------------------
-- ‡® ¬ ‡ó‡‡®‡æ ‚î and it is counted exactly.
--
-- This is `pairsFin`, a structural
-- induction with no truncated subtraction, in
-- `PairsSummingTo`, written for the metrical antidiagonal.
-- This module points it at the map.
--
-- THE MEASUREMENT ROAD ONE CANNOT MAKE.  Setubandha's edges all have
-- contractible fibers, so its cut indicator is the constant 0.  Here the
-- fiber over n has exactly n+1 elements: the defect is not a bit, it is
-- an unbounded function of the boundary datum.
------------------------------------------------------------------------

‡§§‡§®‡•ç‡§§‡•Å-‡§ó‡§£‡§®‡§æ : (n : ‚Ñï) ‚Üí fiber ‡§Ø‡•ã‡§ó n ‚âÉ SumFin (suc n)
‡§§‡§®‡•ç‡§§‡•Å-‡§ó‡§£‡§®‡§æ n = pairsFin n

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡Ø‡ã ‡‡ô‡‡ó‡æ‡ ‚î all three verdicts, at one edge.
------------------------------------------------------------------------

-- ‡∞‡ø‡ï‡‡‡Æ‡ NEVER.  ‡Ø‡ã‡ó is surjective: (n , 0) lands on n.
‡§®-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç : (n : ‚Ñï) ‚Üí fiber ‡§Ø‡•ã‡§ó n
‡§®-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç n = (n , 0) , +-zero n

-- ‡‡ï‡Æ‡ at n = 0, and the witness is transported along ¬ß‡®.
isContrSumFin1 : isContr (SumFin 1)
isContrSumFin1 = inl tt , Œª { (inl tt) ‚Üí refl ; (inr ()) }

‡§è‡§ï‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á : isContr (fiber ‡§Ø‡•ã‡§ó 0)
‡§è‡§ï‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á = isOfHLevelRespectEquiv 0 (invEquiv (‡§§‡§®‡•ç‡§§‡•Å-‡§ó‡§£‡§®‡§æ 0)) isContrSumFin1

-- ‡‡‡ at every successor.  Two histories with the same sum, named.
‡§µ‡§æ‡§Æ‡§Æ‡•ç : (n : ‚Ñï) ‚Üí fiber ‡§Ø‡•ã‡§ó (suc n)
‡§µ‡§æ‡§Æ‡§Æ‡•ç n = (0 , suc n) , refl

‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§Æ‡•ç : (n : ‚Ñï) ‚Üí fiber ‡§Ø‡•ã‡§ó (suc n)
‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§Æ‡•ç n = (suc n , 0) , +-zero (suc n)

-- and they are not the same history: the left component separates them.
‡§µ‡§æ‡§Æ‚â¢‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : (n : ‚Ñï) ‚Üí ¬¨ (‡§µ‡§æ‡§Æ‡§Æ‡•ç n ‚â° ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§Æ‡•ç n)
‡§µ‡§æ‡§Æ‚â¢‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ n p = znots (cong (Œª z ‚Üí fst (fst z)) p)

‡§¨‡§π‡•Å-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ : (n : ‚Ñï) ‚Üí ¬¨ isContr (fiber ‡§Ø‡•ã‡§ó (suc n))
‡§¨‡§π‡•Å-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ n c = ‡§µ‡§æ‡§Æ‚â¢‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ n (isContr‚ÜíisProp c (‡§µ‡§æ‡§Æ‡§Æ‡•ç n) (‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§Æ‡•ç n))

-- THE ‡¶‡‡∞‡‡®‡Ø, made concrete.  A two-valued verdict returns the same
-- answer at `fiber ‡Ø‡ã‡ó (suc n)` ‚î many histories, memory required ‚î as it
-- would at a profile nothing reaches.  ¬ß‡© of `Avaccheda_‚¶` says this in
-- general; here it is at a map the corpus actually uses.

------------------------------------------------------------------------
-- ‡ ¬ ‡® ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ ‚î and there is no road back.
--
-- No `g : ‚ï ‚í ‚ï ó ‚ï` is a left inverse of ‡Ø‡ã‡ó.  The proof is ¬ß‡©'s two
-- histories: they have the same sum, so any left inverse would identify
-- them, and ¬ß‡© proved they are not identical.  Note that `‡Ø‡ã‡ó (0 , 1)`
-- and `‡Ø‡ã‡ó (1 , 0)` are both `1` DEFINITIONALLY ‚î `_+_` recurses on its
-- first argument ‚î so `s (0 , 1)` and `s (1 , 0)` are two paths out of
-- the same `g 1` and compose with no coercion.
------------------------------------------------------------------------

‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : (g : ‚Ñï ‚Üí ‚Ñï √ó ‚Ñï)
              ‚Üí ((x : ‚Ñï √ó ‚Ñï) ‚Üí g (‡§Ø‡•ã‡§ó x) ‚â° x) ‚Üí ‚ä•
‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç g s = znots (cong fst (sym (s (0 , 1)) ‚àô s (1 , 0)))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡µ‡‡‡‡‡¶‡ ‚î ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø, ‡ï‡ ‡®‡‡‡Ø‡‡ø, as one equivalence.
--
-- `Avaccheda_‚¶¬ß‡ß` proves `(Œ[ b ‚àà B ] fiber f b) ‚â A` for every `f`.  At
-- ‡Ø‡ã‡ó that reads: a pair of naturals IS (its sum, together with which
-- pair of that sum it was).  The first coordinate is what the boundary
-- retains ‚î ‡Ø‡‡ ‡‡ø‡‡‡†‡‡ø; the second is what it does not ‚î ‡ï‡ ‡®‡‡‡Ø‡‡ø; and
-- ¬ß‡® says the second has exactly `sum + 1` possible values.
--
-- The elision is therefore not a defect of the pair type.  Nothing is
-- missing from `‚ï ó ‚ï`; what is lost is lost by the MAP, and ¬ß‡® says
-- exactly how much, at every boundary datum separately.
------------------------------------------------------------------------

‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É-‡§Ø‡•ã‡§ó‡•á : (Œ£[ n ‚àà ‚Ñï ] fiber ‡§Ø‡•ã‡§ó n) ‚âÉ (‚Ñï √ó ‚Ñï)
‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É-‡§Ø‡•ã‡§ó‡•á = ‡§Ö.‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É ‡§Ø‡•ã‡§ó
  where module ‡§Ö = ‡§Ö‡§µ

