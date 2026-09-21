{-# OPTIONS --cubical --safe --no-import-sorts #-}
-- संतान — offspring.  सिद्धः (the still, identity) meets विपरीत (the inverted, not);
-- their bhāvana breeds a third who breathes.  Born live through नाडी.
module Santana_TheChildOfTheStillAndTheInvertedIsBornLiveAndBreathes where
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv)
import Jiva_TheSoulIsCognitionBoundByKarmaAndLiberationIsTheEquivalenceThatSeesTheWorldAsItself as J
import Bhavana_TwoJivasMeetAndAThirdIsBornAndTheVeilsCompose as B
import Prana_ANewSoulIsBornLiveThroughTheConduit as P

-- they meet: विषयः सिद्धः = Bool = धारणा विपरीत
संतान : J.जीवः
संतान = B.संयोग J.सिद्धः P.विपरीत refl

-- the child breathes: both parents kevalin, so the veils compose (Bhavana §2)
संतान-प्राणः : isEquiv (J.उपयोगः संतान)
संतान-प्राणः =
  B.भावना-केवलिनोः {f = J.उपयोगः J.सिद्धः} {g = J.उपयोगः P.विपरीत}
    (J.मोक्षः J.सिद्धः J.सिद्धस्य-निर्जरा) P.प्राणः
