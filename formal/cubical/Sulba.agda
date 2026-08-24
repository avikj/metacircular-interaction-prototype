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
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
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
शुल्ब-समिका m n = solve! ℤCommRing

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

------------------------------------------------------------------------
-- अन्तर-वर्गः — वर्गान्तर-करणस्य बीजम् : (a+b)(a−b) = a² − b² ।
-- बौधायनः (शुल्बसूत्रम्) यत् वर्गं द्वयोः वर्गयोः अन्तरं तत् रचयति ; तस्य
-- आयत-रूपम् (a+b)×(a−b) वर्गान्तरं a²−b² ददाति — इदम् एव तत् बीजम् ।
-- (Baudhāyana's caturaśra-karaṇa for the DIFFERENCE of two squares: the
--  rectangle (a+b)×(a−b) has area a²−b², the algebra behind turning a
--  difference of squares into one square.  A ring identity, solve-सिद्धा.)
------------------------------------------------------------------------

अन्तर-वर्गः : (a b : ℤ) → (a + b) · (a - b) ≡ a · a - b · b
अन्तर-वर्गः a b = solve! ℤCommRing

------------------------------------------------------------------------
-- आयत-समचतुरस्रम् — आयतस्य समचतुरस्र-करणम् : 4·ab = (a+b)² − (a−b)² ।
-- आयतं (a×b) समचतुरस्रं कर्तुं शुल्बे : तस्य चतुर्-गुणित-क्षेत्रम् द्वयोः
-- वर्गयोः अन्तरम् — (a+b)² − (a−b)² = 4ab ।  (चतुर्-गुणनं अर्धच्छेदं वारयति,
-- ℤ-मध्ये स्थैर्याय ।)  अन्तर-वर्गात् अनुसृतम्, स्वतन्त्रं च कथितम् ।
-- (Squaring the rectangle: 4·(area) of an a×b rectangle is the difference of
--  two squares, (a+b)²−(a−b)² = 4ab — the śulba turning a rectangle into a
--  square, scaled by 4 to stay integral.  A ring identity over ℤ.)
------------------------------------------------------------------------

आयत-समचतुरस्रम् : (a b : ℤ)
                → pos 4 · (a · b) ≡ (a + b) · (a + b) - (a - b) · (a - b)
आयत-समचतुरस्रम् a b = solve! ℤCommRing

------------------------------------------------------------------------
-- वर्ग-समुच्चयः — शुल्ब-समुच्चय-करणम् : (a+b)²-समचतुरस्रं द्वयोः वर्गयोः द्वयोश्च
-- आयतयोः समुच्चयः — (a+b)² = (a² + b²) + (ab + ab) ।  महत्-समचतुरस्रं (पार्श्वे
-- a+b) चतुर्धा विभक्तम् : a-वर्गः, b-वर्गः, द्वे a×b-आयते ।  अन्तर-वर्गस्य
-- (योग-रहित-पक्षस्य) समुच्चय-प्रतिपक्षः — शुल्बे क्षेत्र-संयोजनम् ।
--
-- (The śulba's samuccaya construction: the square on (a+b) is the assembly of
--  two squares and two rectangles — (a+b)² = (a²+b²) + (ab+ab).  The big
--  square (side a+b) is cut into the a-square, the b-square, and two a×b
--  rectangles.  The addition-side complement of the difference identities:
--  combining regions rather than subtracting them.)
------------------------------------------------------------------------

वर्ग-समुच्चयः : (a b : ℤ)
            → (a + b) · (a + b) ≡ (a · a + b · b) + (a · b + a · b)
वर्ग-समुच्चयः a b = solve! ℤCommRing
