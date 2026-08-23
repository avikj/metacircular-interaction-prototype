{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- निगूढ-अन्धता — hidden blindness.  Compound built here, 2026-08-23
-- (निगूढ, concealed; अन्धता, blindness); not a source term.
--
-- WHAT THIS ANSWERS.  Two of the transmission's "almost forced" next
-- constructions, taken in order:
--
--   DEPENDENT NOVELTY.  gpt-sankramana's probe
--   (DependentFillerFactorizationProbe, outside the aggregate) states
--   dependent descent — Desc_S(F) = Σ[D] Π (F x ≡ D (S x)) — and
--   obstructs it in the inhabited/empty case by one transport.  The
--   general form is proved here (भेद-बाधः): a blind pair whose fibres
--   are NOT EQUIVALENT — at any stratum, for any reason — already
--   obstructs descent, because descent forces the type path whose
--   pathToEquiv the hypothesis refutes.  The inhabited/empty case is
--   derived from it in one line (प्राचीनम्), so the probe's theorem is
--   an instance, credited, not rediscovered.
--
--   DESCENT DEPTH.  "Blindness can hide arbitrarily high" as ONE
--   INDEXED THEOREM.  For every n, over the blind base Bool → Unit,
--   the family
--
--       परिवारः n :  true ↦ Sⁿ⁺¹,  false ↦ Unit
--
--   (a) DESCENDS after (2+n)-truncation — both truncated fibres are
--       contractible (sphereConnected; the sphere is silent below its
--       charge stratum, AnantaraArpana's मौनम्), so a descended family
--       is CONSTRUCTED, ua of the contractibility equivalence;
--   (b) does NOT descend whole — Sⁿ⁺¹ ≃ Unit is refuted through the
--       corpus's own charge ladder: contractibility would climb the
--       truncation and the loop tower into AnantaraArpana's अनन्तरम्,
--       forcing isContr ℤ, i.e. pos 0 ≡ pos 1.
--
--   So the n-th member is invisible to every observation that reads
--   only strata ≤ 2+n and refuses descent at the next stratum: the
--   first failure moves up with n, unboundedly.  No fixed truncation
--   level is a sufficient sensorium for an unbounded higher world —
--   stated as the type निगूढ-अन्धता, one n at a time, checked.
--
-- SOURCES AND SCOPE.  The engines are the library's (sphereConnected,
-- Cubical.HITs.Sn.Properties) and this corpus's own (अनन्तरम्,
-- AnantaraArpana — πₙ₊₁Sⁿ⁺¹ ≅ ℤ read at the stratum above silence).
-- The descent vocabulary follows the probe's, restated here because a
-- --safe module cannot import a probe outside the aggregate.  NOVELTY
-- CLAIMED: none of the mathematics; the composition into the indexed
-- statement.
------------------------------------------------------------------------

module NigudhaAndhata_BlindnessHidesAtEveryDepthTheTruncatedFamilyDescendsAndTheWholeFamilyCannot where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; invEquiv ; equivFun ; isContr→Equiv)
open import Cubical.Foundations.HLevels
  using (isContr→isContrPath ; isOfHLevelPath ; isOfHLevelRespectEquiv)
open import Cubical.Foundations.Univalence using (ua ; pathToEquiv)
open import Cubical.Foundations.Pointed using (Pointed ; typ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots)
open import Cubical.Data.Int using (ℤ ; pos ; injPos)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.Sn using (S₊ ; S₊∙)
open import Cubical.HITs.Sn.Properties using (sphereConnected)
open import Cubical.HITs.Truncation as Trunc
  using (hLevelTrunc ; hLevelTrunc∙ ; ∣_∣ₕ ; isOfHLevelTrunc)
open import Cubical.Homotopy.Loopspace using (Ω^_)

open import AnantaraArpana_TheStratumAboveSilenceCarriesTheWholeChargeForEverySphere
  using (अनन्तरम्)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- §1  Dependent descent, and the general obstruction.
------------------------------------------------------------------------

अवरोहः : {X : Type ℓ} {O : Type ℓ'} (S : X → O) (F : X → Type ℓ'')
       → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-suc ℓ''))
अवरोहः {X = X} {O = O} S F =
  Σ[ D ∈ (O → Type _) ] ((x : X) → F x ≡ D (S x))

-- THE GENERALIZATION: non-equivalence of the fibres at a blind pair —
-- at ANY stratum, for any reason — obstructs descent, because descent
-- forces the very type path whose equivalence is refuted.
भेद-बाधः : {X : Type ℓ} {O : Type ℓ'} (S : X → O) (F : X → Type ℓ'')
  (x y : X)
  → S x ≡ S y
  → ¬ (F x ≃ F y)
  → ¬ अवरोहः S F
भेद-बाधः S F x y p ne (D , comm) =
  ne (pathToEquiv (comm x ∙ cong D p ∙ sym (comm y)))

-- the probe's inhabited/empty obstruction, derived as the instance.
प्राचीनम् : {X : Type ℓ} {O : Type ℓ'} (S : X → O) (F : X → Type ℓ'')
  (x y : X)
  → S x ≡ S y
  → F x → ¬ F y
  → ¬ अवरोहः S F
प्राचीनम् S F x y p seen absent =
  भेद-बाधः S F x y p (λ e → absent (equivFun e seen))

------------------------------------------------------------------------
-- §2  Two small engines for the ladder.
------------------------------------------------------------------------

-- a contractible type has contractible truncations, at every level.
पूर्णता : {A : Type ℓ} (k : ℕ) → isContr A → isContr (hLevelTrunc k A)
पूर्णता k (a₀ , contr) =
  ∣ a₀ ∣ₕ , Trunc.elim (λ _ → isOfHLevelPath k (isOfHLevelTrunc k) _ _)
                        (λ a → cong ∣_∣ₕ (contr a))

-- a contractible pointed type has contractible iterated loop spaces.
शून्य-चक्रम् : (m : ℕ) (X : Pointed ℓ)
  → isContr (typ X) → isContr (typ ((Ω^ m) X))
शून्य-चक्रम् zero    X c = c
शून्य-चक्रम् (suc m) X c = isContr→isContrPath (शून्य-चक्रम् m X c) _ _

------------------------------------------------------------------------
-- §3  No sphere is a point, through the charge ladder: contractibility
--     would climb into अनन्तरम् and force isContr ℤ.
------------------------------------------------------------------------

अन्धता : (n : ℕ) → ¬ (S₊ (suc n) ≃ Unit)
अन्धता n e = znots (injPos (isContr→isProp cℤ (pos 0) (pos 1)))
  where
  cS : isContr (S₊ (suc n))
  cS = isOfHLevelRespectEquiv 0 (invEquiv e) isContrUnit

  cΩ : isContr (typ ((Ω^ suc n) (hLevelTrunc∙ (3 + n) (S₊∙ (suc n)))))
  cΩ = शून्य-चक्रम् (suc n) (hLevelTrunc∙ (3 + n) (S₊∙ (suc n)))
                    (पूर्णता (3 + n) cS)

  cℤ : isContr ℤ
  cℤ = isOfHLevelRespectEquiv 0 (अनन्तरम् n) cΩ

------------------------------------------------------------------------
-- §4  The indexed depth theorem, over the maximally blind base.
------------------------------------------------------------------------

दृक् : Bool → Unit
दृक् _ = tt

परिवारः : ℕ → Bool → Type₀
परिवारः n true  = S₊ (suc n)
परिवारः n false = Unit

निगूढ-अन्धता : (n : ℕ)
  → अवरोहः दृक् (λ b → hLevelTrunc (2 + n) (परिवारः n b))
  × (¬ अवरोहः दृक् (परिवारः n))
निगूढ-अन्धता n =
  ( ( (λ _ → hLevelTrunc (2 + n) (S₊ (suc n)))
    , (λ { true  → refl
         ; false → ua (isContr→Equiv (पूर्णता (2 + n) isContrUnit)
                                     (sphereConnected (suc n))) }) )
  , भेद-बाधः दृक् (परिवारः n) true false refl (अन्धता n) )
