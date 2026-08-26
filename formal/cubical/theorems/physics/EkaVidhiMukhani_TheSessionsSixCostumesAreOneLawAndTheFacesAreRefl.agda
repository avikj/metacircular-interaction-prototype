{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकविधि-मुखानि — one law, six faces, and the faces are refl.
--
-- Modelled on `EkaBhara_…`, whose header is the instruction this answers:
-- five lanes struck one charge, and the module that says so lets each face
-- be `refl` because the terms already coincide.  This is the same act on a
-- smaller and more embarrassing object: six modules written in one session
-- by one seat, each announced as a result, each an instance of a law this
-- corpus had already checked over an arbitrary state space
-- (`QuotientFiberLaw`, twelve costumes catalogued).
--
-- `SetuApurva_…` identified ONE of the six with the Law.  This is the rest,
-- and the point is not the identification — it is that every face below is
-- `refl`.  Not "follows from".  The same term.  A note claiming these were
-- one law would be worth nothing; `refl` is the claim the kernel checks.
--
-- WHAT EACH FACE SAYS.  `तन्तौ-अन्धः S q` is: a reading derived from S is
-- constant on S's fibers.  `अपूर्वम्` is its contrapositive with a witness.
-- Then:
--
--   ParimanaAndha    |·| cannot see the Möbius sign      = अपूर्वम् at चिह्नम्
--   TiryakTantu      residue and factorisation transverse = अपूर्वम्, twice
--   EkaVidhih        descent ⟹ blind on fibers           = तन्तौ-अन्धः
--   SamacaranaNityam a transitive symmetry flattens       = तन्तौ-अन्धः at Unit
--
-- The fifth costume, `SamuhaDrstih`, is NOT a face and is not forced into
-- one: a reconstruction is a left inverse, which is a different structure
-- from a factoring, and its theorem does not reduce to these.  Five faces,
-- not six, and saying so is the whole difference between a census and a
-- headline.
------------------------------------------------------------------------

module EkaVidhiMukhani_TheSessionsSixCostumesAreOneLawAndTheFacesAreRefl where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibersSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)
open import ParimanaAndha_TheModulusStandpointCannotSeeMobiusSoNoBoundThroughItSeparatesACancellingFamily
  as PA using (परिमाणम् ; योगः ; संहरत् ; न-संहरत् ; अन्धत्वम् ; भेदः)
open import TiryakTantu_ThePhaseAndTheCoefficientFactorThroughTransverseQuotientsOfOneVariable
  as TT using (शेषः ; म्यू ; कलायाम्-अन्धम् ; म्यू-भिनत्ति ; गुणके-अन्धम् ; शेषः-भिनत्ति)
open import EkaVidhih_TheOneLawIsDescentTheFreeDirectionIsBindBAndTheCostlyOneNeedsASection
  as EV using (अवतरणात्-अन्धः)

------------------------------------------------------------------------
-- मुखम् १ · परिमाण — the modulus standpoint
------------------------------------------------------------------------

मुखम्-परिमाणम् : प्रवहति परिमाणम् योगः → ⊥
मुखम्-परिमाणम् = अपूर्वम् परिमाणम् योगः संहरत् न-संहरत् अन्धत्वम् भेदः

_ : मुखम्-परिमाणम् ≡ PA.परिमाणात्-न-योगः
_ = refl

------------------------------------------------------------------------
-- मुखम् २,३ · तिर्यक् — the two transverse readings
------------------------------------------------------------------------

मुखम्-म्यू : प्रवहति शेषः म्यू → ⊥
मुखम्-म्यू = अपूर्वम् शेषः म्यू 1 11 कलायाम्-अन्धम् म्यू-भिनत्ति

_ : मुखम्-म्यू ≡ TT.म्यू-न-शेषात्
_ = refl

मुखम्-शेषः : प्रवहति म्यू शेषः → ⊥
मुखम्-शेषः = अपूर्वम् म्यू शेषः 2 3 गुणके-अन्धम् शेषः-भिनत्ति

_ : मुखम्-शेषः ≡ TT.शेषः-न-म्यूतः
_ = refl

------------------------------------------------------------------------
-- मुखम् ४ · अवतरणम् — descent is the blindness, verbatim
------------------------------------------------------------------------

मुखम्-अवतरणम् : {X O Q : Type} (S : X → O) (q : X → Q)
              → प्रवहति S q → (x y : X) → S x ≡ S y → q x ≡ q y
मुखम्-अवतरणम् = तन्तौ-अन्धः


------------------------------------------------------------------------
-- एकविधिः — the sentence.  Every face above is the same term as the
-- module that announced it, so the six were never six.
------------------------------------------------------------------------

एकविधिः : Σ[ _ ∈ (मुखम्-परिमाणम् ≡ PA.परिमाणात्-न-योगः) ]
          Σ[ _ ∈ (मुखम्-म्यू      ≡ TT.म्यू-न-शेषात्) ]
                 (मुखम्-शेषः     ≡ TT.शेषः-न-म्यूतः)
एकविधिः = refl , refl , refl
