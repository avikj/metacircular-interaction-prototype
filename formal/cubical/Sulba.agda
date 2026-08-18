{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शुल्बम् — बौधायनस्य शुल्बसूत्रम् (~८०० ई.पू.) : कर्ण-राशिः ।  "दीर्घचतुरस्रस्य
-- अक्ष्णया रज्जुः पार्श्वमानी तिर्यङ्मानी च यत् पृथग् भूते कुरुतः तदुभयं करोति" —
-- अर्थात् कर्णवर्गः = पार्श्ववर्गः + तिर्यग्वर्गः (c² = a² + b²) ।  वेदी-रचनार्थं
-- कर्ण-त्रिकाणि (Pythagorean triples) दत्तानि : (३,४,५), (५,१२,१३) … ।
--
-- एतत् पैथागोरसात् (~५३० ई.पू.) पूर्वम् ; पैथागोरसः च देश-भ्रमणशीलः आसीत् ।
-- सर्व-त्रिक-जननम् : (m²−n², 2mn, m²+n²) — वलय-समिका (solve-सिद्धा) ।
--
-- (Baudhāyana's Śulba-sūtra (~800 BCE): the diagonal-cord relation
-- c² = a² + b², with Pythagorean triples given for altar construction —
-- before Pythagoras (~530 BCE), himself a traveler.  The triple
-- parametrization (m²−n², 2mn, m²+n²) is a checked ring identity.)
------------------------------------------------------------------------

module Sulba where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)
open import Cubical.Data.Sigma using (_×_ ; _,_)

------------------------------------------------------------------------
-- कर्ण-त्रिक-जननम् — (m²−n²)² + (2mn)² ≡ (m²+n²)² (सर्व-आदि-त्रिक-जनकः) ।
------------------------------------------------------------------------

पार्श्व : ℤ → ℤ → ℤ           -- m² − n²
पार्श्व m n = m · m - n · n

तिर्यक् : ℤ → ℤ → ℤ           -- 2mn
तिर्यक् m n = (pos 2 · m) · n

कर्ण : ℤ → ℤ → ℤ             -- m² + n²
कर्ण m n = m · m + n · n

शुल्ब-समिका : (m n : ℤ)
            → (पार्श्व m n · पार्श्व m n) + (तिर्यक् m n · तिर्यक् m n)
            ≡ (कर्ण m n · कर्ण m n)
शुल्ब-समिका = solve ℤCommRing

------------------------------------------------------------------------
-- उदाहरणम् — बौधायनस्य त्रिकाणि (refl-सिद्धानि) ।
--   m=2,n=1 → (3,4,5) ;  m=3,n=2 → (5,12,13) ।
------------------------------------------------------------------------

त्रिक-३४५ : (pos 3 · pos 3) + (pos 4 · pos 4) ≡ (pos 5 · pos 5)
त्रिक-३४५ = refl

त्रिक-५१२१३ : (pos 5 · pos 5) + (pos 12 · pos 12) ≡ (pos 13 · pos 13)
त्रिक-५१२१३ = refl

-- जनकात्: m=2,n=1 यथार्थतः (3,4,5) जनयति ।
जनक-३४५ : (पार्श्व (pos 2) (pos 1) ≡ pos 3)
        × (तिर्यक् (pos 2) (pos 1) ≡ pos 4)
        × (कर्ण (pos 2) (pos 1) ≡ pos 5)
जनक-३४५ = refl , refl , refl
