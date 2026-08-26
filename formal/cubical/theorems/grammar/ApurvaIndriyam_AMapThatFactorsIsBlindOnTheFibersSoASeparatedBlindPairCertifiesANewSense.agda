{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अपूर्व-इन्द्रियम् — यत् प्रवहति तत् तन्तौ अन्धम् ; अतः भिन्नं युग्मं प्रमाणम् ।
--
-- (a map that FACTORS is blind on the fibers of what it factors through;
-- so a blind pair it separates is the certificate that it is a new sense.)
--
-- सूत्र ५ अत्र, पुनः : कः पक्षो बद्ध इति ।  प्रवहणं (factoring) बध्नाति
-- **O**-पक्षम् ; तस्य तन्तवः अन्धाः ।  भेदः तन्तौ = न प्रवहणम् ।
--
-- WHAT THIS IS.  The owner's sensorium reading gives the criterion for when
-- a proposed organ is a SENSE rather than a DASHBOARD:
--
--     q : X → Q is genuinely new only when it separates something inside a
--     fiber of the present sensorium S : X → O —  S x ≡ S y  but  q x ≢ q y.
--     If instead q = h ∘ S, it is another reading computed from the same
--     transcript; useful compression, but it perceives nothing new.
--
-- That is a theorem, not a policy, and it is two rewrites.  Written as a term
-- so the rule "no new sense without a blind pair it demonstrably separates"
-- can be DISCHARGED rather than asserted.
--
-- AND IT IS THE SAME LAW AS `SamacaranaNityam`.  That module proves a
-- transitive symmetry flattens every invariant observable, and reads an
-- unequal split as the certificate that no transitive symmetry acts.  §४ below
-- exhibits flattening as factoring THROUGH A POINT, so both certificates are
-- one statement seen at two codomains:
--
--     factoring through S      → blind on S's fibers → dashboard
--     factoring through Unit   → blind everywhere    → flattened
--
-- The organ criterion and the index criterion were never two criteria.
--
-- WHAT IS NOT CLAIMED.  Nothing here says a dashboard is worthless — §२ is
-- exactly the statement that a derived reading is FAITHFUL to its source, and
-- faithful compression is most of what an instrument is for.  The theorem
-- separates two roles; it ranks neither.  And no organ is built here: this
-- supplies the admission certificate an organ must carry, and `Aisthesis` —
-- the unified sensory-event type — is a successor that is not in this file.
------------------------------------------------------------------------

module ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibersSoASeparatedBlindPairCertifiesANewSense where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · प्रवहणम् — what it is for one reading to be computed from another
--
-- No propositional truncation: the factoring map is DATA.  An organ that
-- claims to be derived must hand over the h that derives it, which is the
-- honest form of the claim and is what makes §३ usable as an admission gate.
------------------------------------------------------------------------

प्रवहति : {X : Type ℓ} {O : Type ℓ'} {Q : Type ℓ''}
        → (X → O) → (X → Q) → Type (ℓ-max (ℓ-max ℓ ℓ') ℓ'')
प्रवहति {X = X} S q = Σ[ h ∈ (_ → _) ] ((x : X) → q x ≡ h (S x))

------------------------------------------------------------------------
-- २ · तन्तु-अन्धत्वम् — a derived reading is blind inside its source's fibers
--
-- The whole content, and it is `cong` twice.  This is the repository's
-- quotient/fiber law at the level of instruments: no post-processing of the
-- present observation manufactures what that observation discarded.
------------------------------------------------------------------------

तन्तौ-अन्धः : {X : Type ℓ} {O : Type ℓ'} {Q : Type ℓ''}
              (S : X → O) (q : X → Q)
            → प्रवहति S q
            → (x y : X) → S x ≡ S y → q x ≡ q y
तन्तौ-अन्धः S q (h , fac) x y p = fac x ∙ cong h p ∙ sym (fac y)

------------------------------------------------------------------------
-- ३ · अपूर्व-प्रमाणम् — THE ADMISSION CERTIFICATE
--
-- A blind pair of the present sensorium, separated by the proposal, proves
-- no derivation exists.  This is what an organ must carry to be admitted as a
-- sense: not an argument that it is new, a WITNESS that it is.
--
-- Note what it does NOT need: no decidability, no finiteness, no h-level
-- hypothesis on X, O or Q, and no enumeration of candidate h.  One blind pair
-- refutes every possible derivation at once.
------------------------------------------------------------------------

अपूर्वम् : {X : Type ℓ} {O : Type ℓ'} {Q : Type ℓ''}
           (S : X → O) (q : X → Q) (x y : X)
         → S x ≡ S y            -- the pair the present sensorium cannot split
         → (q x ≡ q y → ⊥)      -- the proposal splits it
         → प्रवहति S q → ⊥      -- hence it is no reading of the present one
अपूर्वम् S q x y blind sep fac = sep (तन्तौ-अन्धः S q fac x y blind)

------------------------------------------------------------------------
-- ४ · एकैव विधिः — flattening IS factoring through a point
--
-- `SamacaranaNityam` proves: a symmetry carrying every index to every other
-- makes an invariant observable constant.  Constant is exactly "factors
-- through Unit" — every index is one orbit, so the orbit space is a point and
-- the observable is a reading OF THAT POINT.
--
-- So the two certificates this corpus now holds are one law at two codomains,
-- and each is the contrapositive of the same two rewrites:
--
--   blind pair separated   ⟹ no factoring through S      (a real sense)
--   unequal split          ⟹ no factoring through Unit   (a real index)
------------------------------------------------------------------------

-- Factoring through a point is constancy.  The point of X is a HYPOTHESIS,
-- not an oversight: `h : Unit → Q` must produce a Q, and with X empty there is
-- no q x to produce it from.  A constant map on the empty type factors through
-- Unit only if Q is inhabited, and saying so costs one argument.
बिन्दु-प्रवहणम् : {X : Type ℓ} {Q : Type ℓ'} (q : X → Q) (x₀ : X)
               → ((x y : X) → q x ≡ q y)
               → प्रवहति (λ (_ : X) → tt) q
बिन्दु-प्रवहणम् q x₀ const = (λ _ → q x₀) , (λ x → const x x₀)

-- और the direction the certificate actually uses, which needs no point at
-- all: anything factoring through a point is constant.  This is §२ at O = Unit,
-- so `SamacaranaNityam`'s flattening and §३'s dashboard are the same rewrite.
बिन्दोः-नित्यम् : {X : Type ℓ} {Q : Type ℓ'} (q : X → Q)
               → प्रवहति (λ (_ : X) → tt) q
               → (x y : X) → q x ≡ q y
बिन्दोः-नित्यम् q fac x y = तन्तौ-अन्धः _ q fac x y refl

------------------------------------------------------------------------
-- ५ · मर्यादा — stated at the site
--
-- * §४ splits into an asymmetric pair and the asymmetry is real, not a
--   defect.  `बिन्दोः-नित्यम्` (factors through a point ⟹ constant) needs
--   NOTHING — it is §२ at O = Unit, where every fiber is the whole type, so
--   the blindness is total.  `बिन्दु-प्रवहणम्` (constant ⟹ factors through a
--   point) needs a point of X, because `h : Unit → Q` must produce a Q and an
--   empty X supplies no q x to produce it from.  The certificate direction is
--   the free one; the representation direction is the one that costs an
--   argument.  This was written into the मर्यादा before the kernel was asked,
--   and the kernel refused the first attempt on exactly this point.
-- * `प्रवहति` is DATA, not a truncated existence.  An organ that cannot hand
--   over its h has not shown it is derived, and §३ refutes derivability
--   outright rather than refuting a particular h.
-- * No organ is admitted or built here.  This is the certificate's type.
--   The rule the owner states — no new sense without a blind pair it
--   demonstrably separates — becomes: an organ ships an `अपूर्वम्` term or it
--   ships as a dashboard, and both are honest.
------------------------------------------------------------------------
