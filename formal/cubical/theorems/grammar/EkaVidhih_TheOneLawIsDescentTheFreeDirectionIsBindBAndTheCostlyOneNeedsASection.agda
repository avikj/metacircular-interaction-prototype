{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकविधिः — अवतरणम् एव सर्वम् ।  मुक्तो मार्गः बद्ध-b ; बद्ध-a च्छेदं याचते ।
--
-- (the one law is DESCENT.  the free direction is bind-b; the costly one
-- demands a section, and the cost is exactly the fiber.)
--
-- चत्वारः सिद्धान्ताः एकः — four terms landed in this corpus, and each was
-- called "the same law" in prose.  Prose is बद्ध-a: it fixes the conclusion
-- and leaves the reader to find the fiber.  Here the identification is a
-- term.
--
--   SamacaranaNityam  सङ्क्रमण-नित्यम्   — S = the orbit projection
--   ApurvaIndriyam    अपूर्वम्          — S = the present sensorium
--   ParimanaAndha     परिमाणात्-न-योगः  — S = |·|
--   TiryakTantu       म्यू-न-शेषात्      — S = the residue class
--                     शेषः-न-म्यूतः      — S = the Möbius sign
--
-- Five statements, one rewrite, and §२ below is the rewrite.
--
-- सूत्र ५ अत्र निर्णायकम् ।  `प्रवहति S q` says q descends along S.  §२ gives
-- descent ⟹ blindness on fibers, and it is FREE: no hypothesis on any of the
-- three types, no choice, no decidability.  §३ gives the converse and it is
-- NOT free — it demands a section of S, and §४ exhibits the failure when none
-- exists.  That asymmetry is बद्ध-b versus बद्ध-a, at the level of the law
-- itself:
--
--     bind b :  Σ[ o ∈ O ] (S x ≡ o)  = singl (S x)   — contractible, always
--     bind a :  Σ[ x ∈ X ] (S x ≡ o)  = fiber S o     — arbitrary; the cost
--
-- §५ is why this file exists.  On 2026-08-12 a claim of this corpus was
-- stated as an equivalence — *an index is unobservable EXACTLY WHEN a symmetry
-- acts transitively* — and its necessity half was refuted the same day.  §३
-- says the refutation was structural and not accidental: necessity is the
-- costly direction, the cost is a section, and no section had been supplied.
-- The day's largest correction and the day's law are one statement.
------------------------------------------------------------------------

module EkaVidhih_TheOneLawIsDescentTheFreeDirectionIsBindBAndTheCostlyOneNeedsASection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.Empty using (⊥ ; rec)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibersSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · द्वौ पक्षौ — the two bindings of one equation, at the law's own level
------------------------------------------------------------------------

module _ {X : Type ℓ} {O : Type ℓ'} (S : X → O) where

  वहनम् : X → Type ℓ'                      -- bind o
  वहनम् x = Σ[ o ∈ O ] (S x ≡ o)

  प्रतिबिम्बम् : O → Type (ℓ-max ℓ ℓ')      -- bind x
  प्रतिबिम्बम् o = Σ[ x ∈ X ] (S x ≡ o)

  -- The free side, with no hypothesis whatever.
  वहनम्-सदा-एकम् : (x : X) → isContr (वहनम् x)
  वहनम्-सदा-एकम् x = isContrSingl (S x)

------------------------------------------------------------------------
-- २ · मुक्तो मार्गः — descent ⟹ blind on the fibers.  FREE.
--
-- Re-exported rather than reproved: this IS `तन्तौ-अन्धः`, and naming it
-- twice would be the collapse §७ forbids.
------------------------------------------------------------------------

अवतरणात्-अन्धः : {X : Type ℓ} {O : Type ℓ'} {Q : Type ℓ''}
                 (S : X → O) (q : X → Q)
               → प्रवहति S q
               → (x y : X) → S x ≡ S y → q x ≡ q y
अवतरणात्-अन्धः = तन्तौ-अन्धः

------------------------------------------------------------------------
-- ३ · बद्धो मार्गः — blind on the fibers ⟹ descent.  COSTS A SECTION.
--
-- `h` must be TOTAL on O.  Constancy supplies its value only where a fiber is
-- inhabited, so the converse needs a chosen point in each — a section.  With
-- one, the derivation is `q ∘ sec` and the proof is one rewrite.
------------------------------------------------------------------------

अवतरणम् : {X : Type ℓ} {O : Type ℓ'} {Q : Type ℓ''}
          (S : X → O) (q : X → Q)
          (छेदः : O → X) → ((o : O) → S (छेदः o) ≡ o)
        → ((x y : X) → S x ≡ S y → q x ≡ q y)
        → प्रवहति S q
अवतरणम् S q छेदः छेद-नियमः नित्यम् =
  (λ o → q (छेदः o)) , λ x → नित्यम् x (छेदः (S x)) (sym (छेद-नियमः (S x)))

------------------------------------------------------------------------
-- ४ · छेदाभावे भङ्गः — without a section the converse FAILS
--
-- X = ⊥, O = Unit, Q = ⊥.  Every fiber condition holds vacuously — there are
-- no two points to be constant between — yet `h : Unit → ⊥` cannot exist.
-- So §३'s hypothesis is load-bearing and not bookkeeping.
------------------------------------------------------------------------

शून्य-S : ⊥ → Unit
शून्य-S ()

शून्य-q : ⊥ → ⊥
शून्य-q ()

-- Vacuously blind on fibers.
शून्ये-नित्यम् : (x y : ⊥) → शून्य-S x ≡ शून्य-S y → शून्य-q x ≡ शून्य-q y
शून्ये-नित्यम् ()

-- And yet no descent: h would have to inhabit ⊥ from tt.
शून्ये-न-अवतरणम् : प्रवहति शून्य-S शून्य-q → ⊥
शून्ये-न-अवतरणम् (h , _) = h tt

------------------------------------------------------------------------
-- ५ · तत्फलम् — the day's correction is the law's own asymmetry
--
-- The statement *unobservable EXACTLY WHEN a symmetry acts transitively* has
-- two halves and they are §२ and §३.
--
--   sufficiency — transitive ⟹ flattened.  This is §२ at O = Unit: a
--     transitive action makes the orbit space a point, every fiber is the
--     whole type, and blindness is total.  FREE, and it stood.
--   necessity  — flattened ⟹ transitive.  This is §३'s direction: it asks
--     to reconstruct a structure ON the index from constancy of a reading OF
--     it.  That is descent backwards, it costs a section, and none was
--     offered.  It was refuted the same day by an exhibit whose verdict is
--     constant with no transitive symmetry acting at all.
--
-- So the refutation did not correct an error of care.  It located the claim on
-- the costly side of the one law.  यत् मुक्तं तत् मुक्तम् ; यत् बद्धं तत्
-- छेदं याचते — what is free is free, what is bound demands its section.
--
-- मर्यादा.  §३ takes a split surjection.  A merely surjective S with untruncated
-- fibers needs choice to pick `छेदः`, and in this corpus that choice is DATA
-- to be handed over, not a background assumption — which is the same standard
-- `प्रवहति` sets by being a Σ and not a truncation.  §४ shows the hypothesis
-- cannot simply be dropped; it does not claim it is the weakest possible one.
------------------------------------------------------------------------
