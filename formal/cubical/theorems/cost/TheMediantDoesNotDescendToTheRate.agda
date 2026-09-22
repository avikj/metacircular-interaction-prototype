{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheMediantDoesNotDescendToTheRate
--
-- Whether `mediant` DESCENDS to the rate â” which is what one wants for
-- a CANONICAL between-rate rather than a truncated one.  The answer is
-- NO.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   sameRate                (1,1) â‰ˆ (2,3) â” the same rate, Â½, written
--                           two ways
--   theMediantDoesNotDescend
--                           `mediant (1,1) (1,2)` and
--                           `mediant (2,3) (1,2)` are NOT â‰ˆ-equal
--
-- In the encoding of this line a pair `(p , q)` denotes `p / suc q`, so
-- the two mediants are 2/5 and 3/7, and `2Â7 = 14 â‰  15 = 3Â5`.  The
-- refutation is the second half of `â‰ˆ`: `(3,6) âŠ (2,4)` unfolds to
-- `15 â‰ 14`, which is `14 < 14`, refuted by `Âm<m`.
--
-- **WHAT THIS COSTS, EXACTLY.**  Nothing already proved.  The density
-- theorem in `TheRatesAreDenseAndTheMediantSurvivesTheQuotient` was
-- deliberately stated with `âˆ_âˆâ` and elimination into a PROPOSITION,
-- and its own header says "the mediant never has to descend" â” the
-- witness is produced at the level of representatives and the
-- statement it witnesses is â‰ˆ-invariant on its own.  That design is
-- vindicated rather than merely cautious: the descent it declined
-- to assume is false.
--
-- **WHAT IT BLOCKS.**  Any `Rate â’ Rate â’ Rate` extending the mediant.
-- There is no such function by this route, so a CANONICAL between-rate
-- cannot be extracted from the truncated existence â” the choice has to
-- come from somewhere else, and the classical source is lowest terms
-- (Sternâ“Brocot / Farey, where the mediant IS canonical because the
-- representatives are). Lowest terms needs coprimality, hence the
-- kuaka line (`KuttakaValli.agda`).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY, AND THE STATEMENT IS OLD.  That the mediant is not a
-- function of the two rationals â” "freshman addition" depends on the
-- representatives â” is the standard first remark about it; Haros 1802
-- and Farey 1816 state the construction on fractions IN LOWEST TERMS
-- precisely because of this, and Stern 1858 / Brocot 1861 build the
-- tree on reduced pairs for the same reason. Nothing here is new.
------------------------------------------------------------------------

module TheMediantDoesNotDescendToTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (â‰¤-refl ; Â¬m<m)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import WhichThresholdStatementsDescendToTheRate
  using (_â‰ˆ_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (mediant)

------------------------------------------------------------------------
-- 1.  One rate, two representatives
------------------------------------------------------------------------

half  : â„• Ã— â„•
half  = 1 , 1        -- 1/2

half' : â„• Ã— â„•
half' = 2 , 3        -- 2/4

third : â„• Ã— â„•
third = 1 , 2        -- 1/3

sameRate : half â‰ˆ half'
sameRate = â‰¤-refl , â‰¤-refl

------------------------------------------------------------------------
-- 2.  â¦with different mediants
--
--   mediant half  third = (2 , 4)  =  2/5
--   mediant half' third = (3 , 6)  =  3/7
--
-- and `(3,6) âŠ (2,4)` is `3 Â 5 â‰ 2 Â 7`, i.e. `15 â‰ 14`.
------------------------------------------------------------------------

theMediantDoesNotDescend :
  Â¬ (mediant half third â‰ˆ mediant half' third)
theMediantDoesNotDescend (_ , h) = Â¬m<m h
