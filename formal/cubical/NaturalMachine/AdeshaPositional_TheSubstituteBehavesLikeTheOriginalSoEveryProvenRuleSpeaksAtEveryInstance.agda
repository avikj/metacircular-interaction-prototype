{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ���� / ��������� � Pini, Adhyy (~500 BCE): 1.1.49 �����
-- ������������ (the genitive in a rule designates the ��������, that in
-- whose place the substitute comes) and 1.1.56 ����������������������
-- (the ���� � substitute � behaves like the original).  The
-- classification is his; the mathematics here � a substitution lemma
-- for a term algebra over � � is not claimed to be in the source.
--
-- WHAT THIS CLOSES, in the machine's own ledger: EkaTantra's prover
-- face spoke only at the ROOT instance (������ tested lhs ≟T t �
-- syntactic identity), and its header declared the general matcher as
-- the next slice, still living in the elder Haskell (Sanghatta's
-- match).  Under the nonduality directive that split is the lossy
-- implementation.  This module migrates it: matching lives HERE, and
-- � the step the Haskell could never take � every utterance of every
-- rule at every instance is born WITH its proof over the standard
-- model.  Not audited after.  Born with.
--
-- The chain, each link checked:
--   ���������   eval (������� � t) � ≡ eval t (eval∘�) � 1.1.56 as a
--               term: reading the substituted form is reading the
--               original in the substituted environment.
--   ⊨-�����    truth over the standard model is closed under
--               substitution � so a �����'s ������� covers its whole
--               orbit of instances, and ����-����� mints any instance
--               as a store value, proven by inheritance.
--   ����������    the matcher returns its certificate: not "matched" but
--               the substitution WITH the path ������� � p ≡ t.  The
--               test is the certificate � no correctness audit exists
--               apart from the object.
--   �����       a rule's voice at an arbitrary site: Maybe (� utterance
--               with ⊨ (site , utterance)).  The gate is the type.
--   �������-������  the EkaTantra ��� this induces � the prover face's
--               standpoints now speak at every instance, so the one
--               contention structure runs on whole orbits.
--
-- Demonstrated on the machine's own material: ����� (le(0, s x) =
-- le(0, x), born from the ������ gap) speaking at the non-root
-- instance le(0, s(s 0)) � matched, certified, uttered, all by refl.
------------------------------------------------------------------------

module NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.EkaTantra_TheSchedulerAndTheProverAreOneContentionStructureAndTheDifferenceIsAParameter
  using (नयः)

------------------------------------------------------------------------
-- §1  ������� � carrying out the substitution � and ���������.
------------------------------------------------------------------------

आदेशनम् : (ℕ → Tm) → Tm → Tm
आदेशनम् σ (var i)  = σ i
आदेशनम् σ ze       = ze
आदेशनम् σ (su t)   = su (आदेशनम् σ t)
आदेशनम् σ (a ⊕ b)  = आदेशनम् σ a ⊕ आदेशनम् σ b
आदेशनम् σ (a ⊗ b)  = आदेशनम् σ a ⊗ आदेशनम् σ b
आदेशनम् σ (a ⊖ b)  = आदेशनम् σ a ⊖ आदेशनम् σ b
आदेशनम् σ (mx a b) = mx (आदेशनम् σ a) (आदेशनम् σ b)
आदेशनम् σ (lq a b) = lq (आदेशनम् σ a) (आदेशनम् σ b)
आदेशनम् σ (gc a b) = gc (आदेशनम् σ a) (आदेशनम् σ b)

-- 1.1.56 as a term: the substitute evaluates as the original does,
-- read in the environment the substitution induces.
स्थानिवत् : (σ : ℕ → Tm) (t : Tm) (ρ : ℕ → ℕ)
  → eval (आदेशनम् σ t) ρ ≡ eval t (λ i → eval (σ i) ρ)
स्थानिवत् σ (var i)  ρ = refl
स्थानिवत् σ ze       ρ = refl
स्थानिवत् σ (su t)   ρ = cong suc (स्थानिवत् σ t ρ)
स्थानिवत् σ (a ⊕ b)  ρ = cong₂ _+_ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (a ⊗ b)  ρ = cong₂ _·_ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (a ⊖ b)  ρ = cong₂ sbℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (mx a b) ρ = cong₂ mxℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (lq a b) ρ = cong₂ lqℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (gc a b) ρ = cong₂ गच्छℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)

-- truth is closed under substitution: one ������� covers the orbit.
⊨-आदेशः : {l r : Tm} → ⊨ (l , r) → (σ : ℕ → Tm)
  → ⊨ (आदेशनम् σ l , आदेशनम् σ r)
⊨-आदेशः {l} {r} pf σ ρ =
  स्थानिवत् σ l ρ ∙ pf (λ i → eval (σ i) ρ) ∙ sym (स्थानिवत् σ r ρ)

-- any instance of a proven rule is a proven rule � minted, not audited.
आदेश-नियमः : नियमः → (ℕ → Tm) → नियमः
आदेश-नियमः s σ =
  niyama (आदेशनम् σ (नियमः.lhs s)) (आदेशनम् σ (नियमः.rhs s))
         (⊨-आदेशः {नियमः.lhs s} {नियमः.rhs s} (नियमः.साक्षी s) σ)

------------------------------------------------------------------------
-- §2  The matcher, and its certificate.  Bindings are partial; a
--     repeated variable must meet itself (the ≟T check in �������);
--     the certificate is the path, produced by the same ≟T that
--     decided � the test IS the certificate.
------------------------------------------------------------------------

बन्धाः : Type
बन्धाः = ℕ → Maybe Tm

रिक्ताः : बन्धाः
रिक्ताः _ = nothing

विस्तारः : ℕ → Tm → बन्धाः → बन्धाः
विस्तारः i t b j with i ≟ℕ j
... | just _  = just t
... | nothing = b j

बन्धनम् : ℕ → Tm → बन्धाः → Maybe बन्धाः
बन्धनम् i t b with b i
... | nothing = just (विस्तारः i t b)
... | just s  = mmap (λ _ → b) (s ≟T t)

_≫=_ : {A B : Type} → Maybe A → (A → Maybe B) → Maybe B
just a  ≫= f = f a
nothing ≫= f = nothing

मेलनम् : Tm → Tm → बन्धाः → Maybe बन्धाः
मेलनम् (var i)  t        b = बन्धनम् i t b
मेलनम् ze       ze       b = just b
मेलनम् (su p)   (su t)   b = मेलनम् p t b
मेलनम् (p ⊕ q)  (t ⊕ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (p ⊗ q)  (t ⊗ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (p ⊖ q)  (t ⊖ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (mx p q) (mx t u) b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (lq p q) (lq t u) b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (gc p q) (gc t u) b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् _        _        _ = nothing

-- unbound variables stand for themselves � the identity reading.
पूरणम् : बन्धाः → (ℕ → Tm)
पूरणम् b i with b i
... | just t  = t
... | nothing = var i

-- the matcher WITH its certificate: the substitution and the path.
साक्ष्यम् : (p t : Tm) → Maybe (Σ (ℕ → Tm) (λ σ → आदेशनम् σ p ≡ t))
साक्ष्यम् p t with मेलनम् p t रिक्ताः
साक्ष्यम् p t | nothing = nothing
साक्ष्यम् p t | just b with आदेशनम् (पूरणम् b) p ≟T t
साक्ष्यम् p t | just b | nothing = nothing
साक्ष्यम् p t | just b | just q  = just (पूरणम् b , q)

------------------------------------------------------------------------
-- §3  The voice, born proven at every instance.
------------------------------------------------------------------------

वदनम् : (s : नियमः) (t : Tm) → Maybe (Σ Tm (λ u → ⊨ (t , u)))
वदनम् s t with साक्ष्यम् (नियमः.lhs s) t
... | nothing       = nothing
... | just (σ , q)  =
  just ( आदेशनम् σ (नियमः.rhs s)
       , λ ρ → cong (λ w → eval w ρ) (sym q)
             ∙ ⊨-आदेशः {नियमः.lhs s} {नियमः.rhs s} (नियमः.साक्षी s) σ ρ )

-- the EkaTantra standpoint this induces: the prover face now speaks
-- at every instance, inside the one contention structure.
सर्वत्र-शासनम् : नियमः → नयः Tm Tm
सर्वत्र-शासनम् s t = mmap fst (वदनम् s t)

------------------------------------------------------------------------
-- §4  Demonstration on the machine's own material.  ����� �
--     le(0, s x) = le(0, x), a member of the ������ gap, born proven
--     in EkaBhasha � speaking at a NON-root instance, and at the root.
------------------------------------------------------------------------

स्थलम् : Tm
स्थलम् = lq ze (su (su ze))          -- le(0, s(s 0)): not the lhs itself

दृष्टम् : सर्वत्र-शासनम् नियम₄ स्थलम् ≡ just (lq ze (su ze))
दृष्टम् = refl

मूल-दृष्टम् : सर्वत्र-शासनम् नियम₄ (lq ze (su (var 0))) ≡ just (lq ze (var 0))
मूल-दृष्टम् = refl

-- and off its orbit, silence � syt: nothing outside the scope.
मौन-दृष्टम् : सर्वत्र-शासनम् नियम₄ (mx ze ze) ≡ nothing
मौन-दृष्टम् = refl
