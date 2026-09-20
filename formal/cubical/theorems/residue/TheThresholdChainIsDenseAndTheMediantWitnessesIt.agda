{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheThresholdChainIsDenseAndTheMediantWitnessesIt
--
-- "Density of âŠ is untouched" has been the last line of the NOT-CLAIMED
-- section of three modules on the threshold line â”
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone`,
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`, and
-- `WhichThresholdStatementsDescendToTheRate` â” and it is touched here.
--
-- The chain IS dense, and the witness is not constructed by a search:
-- it is the MEDIANT.  Between p/(suc q) and p'/(suc q') lies
--
--   (p + p') / (suc q + suc q')
--
-- and both halves of the betweenness reduce, after distributing, to the
-- SAME inequality that was assumed.  No case analysis, no ordering
-- lemmas beyond additive cancellation.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   _âŠ_               strict threshold order, p Â suc q' < p' Â suc q
--   mediant           (p + p' , q + suc q'), which is a threshold pair
--                     with denominator suc q + suc q' â” definitionally,
--                     since `suc q + suc q'` IS `suc (q + suc q')`
--   mediantIsAbove    (p , q) âŠ mediant
--   mediantIsBelow    mediant âŠ (p' , q')
--   thresholdsAreDense    the two together
--   âŠ-gives-âŠ         and âŠ refines the âŠ chain the other threshold
--                     modules use, so this is density OF THAT CHAIN and
--                     not of a relation introduced for the occasion
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY, and the attribution is worth getting right.  The mediant
-- and its betweenness property are classical: they organise the Farey
-- dissection (Haros 1802; Farey 1816) and the Sternâ“Brocot tree (Stern
-- 1858; Brocot 1861).  Nothing here is new; what is new to this corpus
-- is only that the threshold chain's density is now checked rather than
-- listed as untouched.
--
-- Also worth recording rather than mining: the mediant is the same
-- operation the vall/kuaka tradition uses when it forms a new pair
-- from two convergents â” `KuttakaValli.agda` and the convergent modules
-- on that line are ANOTHER IDENTITY'S here, and this module does not
-- enter them.  It is NOT claimed that the mediant is "really" the
-- kuaka's step; that would need the two constructions compared, which
-- is their author's to do.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheThresholdChainIsDenseAndTheMediantWitnessesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-suc ; Â·-distribË¡ ; Â·-distribÊ³)
open import Cubical.Data.Nat.Order using (_<_ ; _â‰¤_ ; â‰¤-k+ ; â‰¤-+k ; <-weaken)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone using (_âŠ‘_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

------------------------------------------------------------------------
-- 1.  Strict order on thresholds, and additive cancellation for <
------------------------------------------------------------------------

_âŠ_ : â„• Ã— â„• â†’ â„• Ã— â„• â†’ Type
(p , q) âŠ (p' , q') = p Â· suc q' < p' Â· suc q

<-shiftË¡ : (c : â„•) {a b : â„•} â†’ a < b â†’ (c + a) < (c + b)
<-shiftË¡ c {a} {b} h = subst (_â‰¤ c + b) (+-suc c a) (â‰¤-k+ h)

------------------------------------------------------------------------
-- 2.  The mediant
--
-- Its denominator is `suc q + suc q'`, and that is DEFINITIONALLY
-- `suc (q + suc q')`, so the mediant is a threshold pair with no
-- arithmetic needed to see it.
------------------------------------------------------------------------

mediant : â„• Ã— â„• â†’ â„• Ã— â„• â†’ â„• Ã— â„•
mediant (p , q) (p' , q') = (p + p') , (q + suc q')

------------------------------------------------------------------------
-- 3.  Both halves reduce to the hypothesis
------------------------------------------------------------------------

mediantIsAbove :
  (p q p' q' : â„•) â†’ (p , q) âŠ (p' , q')
  â†’ (p , q) âŠ mediant (p , q) (p' , q')
mediantIsAbove p q p' q' h =
  subst2 _<_ (Â·-distribË¡ p (suc q) (suc q')) (Â·-distribÊ³ p p' (suc q))
    (<-shiftË¡ (p Â· suc q) h)

mediantIsBelow :
  (p q p' q' : â„•) â†’ (p , q) âŠ (p' , q')
  â†’ mediant (p , q) (p' , q') âŠ (p' , q')
mediantIsBelow p q p' q' h =
  subst2 _<_ (Â·-distribÊ³ p p' (suc q')) (Â·-distribË¡ p' (suc q) (suc q'))
    (â‰¤-+k h)

thresholdsAreDense :
  (p q p' q' : â„•) â†’ (p , q) âŠ (p' , q')
  â†’ ((p , q) âŠ mediant (p , q) (p' , q'))
  Ã— (mediant (p , q) (p' , q') âŠ (p' , q'))
thresholdsAreDense p q p' q' h =
  mediantIsAbove p q p' q' h , mediantIsBelow p q p' q' h

------------------------------------------------------------------------
-- 4.  And âŠ refines the chain the other modules use
------------------------------------------------------------------------

âŠ-gives-âŠ‘ : (a b : â„• Ã— â„•) â†’ a âŠ b â†’ a âŠ‘ b
âŠ-gives-âŠ‘ (p , q) (p' , q') = <-weaken
