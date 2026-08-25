{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- the run, executed by the checker.  companion to
-- LosslessReturn_TheStepIsAConjugationAndNothingIsTouchedByIt.

module Calana_TheRunAndTheInvariantForAllN where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import SourcedProofs.LosslessReturn_TheStepIsAConjugationAndNothingIsTouchedByIt

आदि : विवेक
आदि = गभीर 0 0 7          -- शेषः = 7, carried and never touched

क्रम : ℕ → जाल → विवेक
क्रम zero    s = इदम् s
क्रम (suc n) s = क्रम n (पुनः s)

-- the run, computed by the checker: each is refl
पद० : क्रम 0 (बुन आदि) ≡ गभीर 0 0 7
पद० = refl
पद१ : क्रम 1 (बुन आदि) ≡ गभीर 1 1 7
पद१ = refl
पद२ : क्रम 2 (बुन आदि) ≡ गभीर 2 2 7
पद२ = refl
पद५ : क्रम 5 (बुन आदि) ≡ गभीर 5 5 7
पद५ = refl
पद२० : क्रम 20 (बुन आदि) ≡ गभीर 20 20 7
पद२० = refl

-- शेषः is invariant under the whole run, at every n, by structure
शेषः : विवेक → ℕ
शेषः (गभीर _ _ d) = d

अलोपः : (n : ℕ) (v : विवेक) → शेषः (क्रम n (बुन v)) ≡ शेषः v
अलोपः zero    (गभीर _ _ _) = refl
अलोपः (suc n) (गभीर a b d) = अलोपः n (गभीर (suc a) (suc b) d)
