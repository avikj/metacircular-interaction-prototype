{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- स्वयं-भावेन्द्रियम् — TS 2.17-18 completed: BhavaIndriya showed an
-- eye BUILT FROM the body's attainment, but an agent still did the
-- building.  Here the attainment builds the organ: the machine reads
-- its own store, detects the algebraic shapes (commutativity,
-- associativity, unit — pure pattern-matching on its own नियमः
-- values), extracts the value-level laws FROM THE RULES' OWN
-- WITNESSES at point environments, and instantiates one generic
-- canonicalizer proven sound once over an abstract commutative
-- monoid.  The eye is a function of the store.  No agent builds
-- organs.  School named: Jaina; the mathematics is not claimed for
-- any source.
------------------------------------------------------------------------

module NaturalMachine.SvayamBhavendriya_TheBodyGrowsItsOwnEyesFromItsOwnRulesAndNoAgentBuildsOrgans where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false≢true)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (Σ ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (_≫=_)
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (समानः ; समान-आत्मनि ; उपस्थापनम् ; आत्म-मूल्यम्)
open import NaturalMachine.YugapadArpana_BothCoordinatesDescendAtOnceAndTheDoubleDescentBecomesSomethingTheMachineInvokes
  using (सम-विपर्ययः)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (तुला ; निवेशः ; क्रमणम्)
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (दृक्)
open import NaturalMachine.PurnaPramana_TheOneKnowingCarriesEveryOrganAsAParameterAndTheWholeInheritanceCrossesInOneAct
  using (यन्त्रम् ; सूक्ष्म-यन्त्रम् ; पूर्ण-प्रमाणम्)
open import NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot
  using (परम्परा)

------------------------------------------------------------------------
-- §1  Operator symbols, their meanings, their constructors.
------------------------------------------------------------------------

data कर्ता : Type where
  क⊕ क⊗ क⊖ कmx कlq : कर्ता

अर्थः : कर्ता → ℕ → ℕ → ℕ
अर्थः क⊕  = _+_
अर्थः क⊗  = _·_
अर्थः क⊖  = sbℕ
अर्थः कmx = mxℕ
अर्थः कlq = lqℕ

रचना : कर्ता → Tm → Tm → Tm
रचना क⊕  a b = a ⊕ b
रचना क⊗  a b = a ⊗ b
रचना क⊖  a b = a ⊖ b
रचना कmx a b = mx a b
रचना कlq a b = lq a b

रचना-अर्थः : (o : कर्ता) (a b : Tm) (ρ : ℕ → ℕ)
  → eval (रचना o a b) ρ ≡ अर्थः o (eval a ρ) (eval b ρ)
रचना-अर्थः क⊕  a b ρ = refl
रचना-अर्थः क⊗  a b ρ = refl
रचना-अर्थः क⊖  a b ρ = refl
रचना-अर्थः कmx a b ρ = refl
रचना-अर्थः कlq a b ρ = refl

कर्ता-≟ : (a b : कर्ता) → Maybe (a ≡ b)
कर्ता-≟ क⊕  क⊕  = just refl
कर्ता-≟ क⊗  क⊗  = just refl
कर्ता-≟ क⊖  क⊖  = just refl
कर्ता-≟ कmx कmx = just refl
कर्ता-≟ कlq कlq = just refl
कर्ता-≟ _   _   = nothing

शीर्षम् : (t : Tm) → Maybe (Σ कर्ता (λ o → Σ Tm (λ a → Σ Tm (λ b → t ≡ रचना o a b))))
शीर्षम् (a ⊕ b)  = just (क⊕  , a , b , refl)
शीर्षम् (a ⊗ b)  = just (क⊗  , a , b , refl)
शीर्षम् (a ⊖ b)  = just (क⊖  , a , b , refl)
शीर्षम् (mx a b) = just (कmx , a , b , refl)
शीर्षम् (lq a b) = just (कlq , a , b , refl)
शीर्षम् _        = nothing

चरम् : (t : Tm) → Maybe (Σ ℕ (λ i → t ≡ var i))
चरम् (var i) = just (i , refl)
चरम् _       = nothing

विभिन्नौ : (i j : ℕ) → Maybe (समानः i j ≡ false)
विभिन्नौ i j = go (समानः i j) refl
  where
  go : (b : Bool) → समानः i j ≡ b → Maybe (समानः i j ≡ false)
  go true  _ = nothing
  go false p = just p

विभागः : (a b : Bool) → (a and b) ≡ true → (a ≡ true) × (b ≡ true)
विभागः true  b p = refl , p
विभागः false b p = ⊥-rec (false≢true p)

निर्वारः : Tm → Bool
निर्वारः (var _)  = false
निर्वारः ze       = true
निर्वारः (su t)   = निर्वारः t
निर्वारः (a ⊕ b)  = निर्वारः a and निर्वारः b
निर्वारः (a ⊗ b)  = निर्वारः a and निर्वारः b
निर्वारः (a ⊖ b)  = निर्वारः a and निर्वारः b
निर्वारः (mx a b) = निर्वारः a and निर्वारः b
निर्वारः (lq a b) = निर्वारः a and निर्वारः b
निर्वारः (gc a b) = निर्वारः a and निर्वारः b

निर्वार-सत्यम् : (t : Tm) → निर्वारः t ≡ true
  → (ρ ρ' : ℕ → ℕ) → eval t ρ ≡ eval t ρ'
निर्वार-सत्यम् (var i)  p ρ ρ' = ⊥-rec (false≢true p)
निर्वार-सत्यम् ze       p ρ ρ' = refl
निर्वार-सत्यम् (su t)   p ρ ρ' = cong suc (निर्वार-सत्यम् t p ρ ρ')
निर्वार-सत्यम् (a ⊕ b)  p ρ ρ' =
  cong₂ _+_ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (a ⊗ b)  p ρ ρ' =
  cong₂ _·_ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (a ⊖ b)  p ρ ρ' =
  cong₂ sbℕ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (mx a b) p ρ ρ' =
  cong₂ mxℕ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (lq a b) p ρ ρ' =
  cong₂ lqℕ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (gc a b) p ρ ρ' =
  cong₂ गच्छℕ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')

------------------------------------------------------------------------
-- §2  Law extraction: the rule's own witness, read at point
--     environments, becomes the value-level law.
------------------------------------------------------------------------

सम-निष्कर्षः : (o : कर्ता) (i j : ℕ) → समानः i j ≡ false
  → ((ρ : ℕ → ℕ) → eval (रचना o (var i) (var j)) ρ ≡ eval (रचना o (var j) (var i)) ρ)
  → (x y : ℕ) → अर्थः o x y ≡ अर्थः o y x
सम-निष्कर्षः o i j ij w x y =
  let ρ₀ : ℕ → ℕ
      ρ₀ = उपस्थापनम् (उपस्थापनम् (λ _ → zero) i x) j y
      ji : समानः j i ≡ false
      ji = सम-विपर्ययः j i ∙ ij
      ρi : ρ₀ i ≡ x
      ρi = cong (λ b → if b then y else उपस्थापनम् (λ _ → zero) i x i) ji
         ∙ आत्म-मूल्यम् (λ _ → zero) i x
      ρj : ρ₀ j ≡ y
      ρj = आत्म-मूल्यम् (उपस्थापनम् (λ _ → zero) i x) j y
  in sym (cong₂ (अर्थः o) ρi ρj)
   ∙ sym (रचना-अर्थः o (var i) (var j) ρ₀)
   ∙ w ρ₀
   ∙ रचना-अर्थः o (var j) (var i) ρ₀
   ∙ cong₂ (अर्थः o) ρj ρi
  where
  open import Cubical.Data.Bool using (if_then_else_)

सह-निष्कर्षः : (o : कर्ता) (i j k : ℕ)
  → समानः j i ≡ false → समानः k i ≡ false → समानः k j ≡ false
  → ((ρ : ℕ → ℕ) → eval (रचना o (var i) (रचना o (var j) (var k))) ρ
                  ≡ eval (रचना o (रचना o (var i) (var j)) (var k)) ρ)
  → (x y z : ℕ) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z
सह-निष्कर्षः o i j k ji ki kj w x y z =
  let ρ₁ = उपस्थापनम् (λ _ → zero) i x
      ρ₂ = उपस्थापनम् ρ₁ j y
      ρ₀ = उपस्थापनम् ρ₂ k z
      ρk : ρ₀ k ≡ z
      ρk = आत्म-मूल्यम् ρ₂ k z
      ρj : ρ₀ j ≡ y
      ρj = cong (λ b → if b then z else ρ₂ j) kj ∙ आत्म-मूल्यम् ρ₁ j y
      ρi : ρ₀ i ≡ x
      ρi = cong (λ b → if b then z else ρ₂ i) ki
         ∙ cong (λ b → if b then y else ρ₁ i) ji
         ∙ आत्म-मूल्यम् (λ _ → zero) i x
  in sym (cong₂ (अर्थः o) ρi (cong₂ (अर्थः o) ρj ρk))
   ∙ sym (cong (अर्थः o (ρ₀ i)) (रचना-अर्थः o (var j) (var k) ρ₀))
   ∙ sym (रचना-अर्थः o (var i) (रचना o (var j) (var k)) ρ₀)
   ∙ w ρ₀
   ∙ रचना-अर्थः o (रचना o (var i) (var j)) (var k) ρ₀
   ∙ cong (λ m → अर्थः o m (ρ₀ k)) (रचना-अर्थः o (var i) (var j) ρ₀)
   ∙ cong₂ (अर्थः o) (cong₂ (अर्थः o) ρi ρj) ρk
  where
  open import Cubical.Data.Bool using (if_then_else_)

एक-निष्कर्षः : (o : कर्ता) (i : ℕ) (u : Tm) → निर्वारः u ≡ true
  → ((ρ : ℕ → ℕ) → eval (रचना o (var i) u) ρ ≡ ρ i)
  → (x : ℕ) (ρ : ℕ → ℕ) → अर्थः o x (eval u ρ) ≡ x
एक-निष्कर्षः o i u cu w x ρ =
  let ρ' = उपस्थापनम् ρ i x
  in cong (अर्थः o x) (निर्वार-सत्यम् u cu ρ ρ')
   ∙ cong (λ m → अर्थः o m (eval u ρ')) (sym (आत्म-मूल्यम् ρ i x))
   ∙ sym (रचना-अर्थः o (var i) u ρ')
   ∙ w ρ'
   ∙ आत्म-मूल्यम् ρ i x

------------------------------------------------------------------------
-- §3  The generic organ: one canonicalizer, proven sound once, over
--     an abstract operator with store-extracted laws.
------------------------------------------------------------------------

module जनकः (o : कर्ता) (u : Tm)
  (gc : (x y : ℕ) → अर्थः o x y ≡ अर्थः o y x)
  (ga : (x y z : ℕ) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z)
  (gu : (x : ℕ) (ρ : ℕ → ℕ) → अर्थः o x (eval u ρ) ≡ x)
  where

  तति : Tm → List Tm
  तति (a ⊕ b)  with कर्ता-≟ o क⊕
  ... | just _  = तति a ++ तति b
  ... | nothing = (a ⊕ b) ∷ []
  तति (a ⊗ b)  with कर्ता-≟ o क⊗
  ... | just _  = तति a ++ तति b
  ... | nothing = (a ⊗ b) ∷ []
  तति (a ⊖ b)  with कर्ता-≟ o क⊖
  ... | just _  = तति a ++ तति b
  ... | nothing = (a ⊖ b) ∷ []
  तति (mx a b) with कर्ता-≟ o कmx
  ... | just _  = तति a ++ तति b
  ... | nothing = mx a b ∷ []
  तति (lq a b) with कर्ता-≟ o कlq
  ... | just _  = तति a ++ तति b
  ... | nothing = lq a b ∷ []
  तति t = t ∷ []

  फलितम् : List Tm → (ℕ → ℕ) → ℕ
  फलितम् []       ρ = eval u ρ
  फलितम् (t ∷ ts) ρ = अर्थः o (eval t ρ) (फलितम् ts ρ)

  वाम-एकम् : (m : ℕ) (ρ : ℕ → ℕ) → अर्थः o (eval u ρ) m ≡ m
  वाम-एकम् m ρ = gc (eval u ρ) m ∙ gu m ρ

  फल-++ : (xs ys : List Tm) (ρ : ℕ → ℕ)
    → फलितम् (xs ++ ys) ρ ≡ अर्थः o (फलितम् xs ρ) (फलितम् ys ρ)
  फल-++ []       ys ρ = sym (वाम-एकम् (फलितम् ys ρ) ρ)
  फल-++ (x ∷ xs) ys ρ =
    cong (अर्थः o (eval x ρ)) (फल-++ xs ys ρ)
    ∙ ga (eval x ρ) (फलितम् xs ρ) (फलितम् ys ρ)

  तति-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → फलितम् (तति t) ρ ≡ eval t ρ
  तति-सत्यम् (a ⊕ b) ρ with कर्ता-≟ o क⊕
  ... | just p  =
      फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = gu (eval (a ⊕ b) ρ) ρ
  तति-सत्यम् (a ⊗ b) ρ with कर्ता-≟ o क⊗
  ... | just p  =
      फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = gu (eval (a ⊗ b) ρ) ρ
  तति-सत्यम् (a ⊖ b) ρ with कर्ता-≟ o क⊖
  ... | just p  =
      फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = gu (eval (a ⊖ b) ρ) ρ
  तति-सत्यम् (mx a b) ρ with कर्ता-≟ o कmx
  ... | just p  =
      फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = gu (eval (mx a b) ρ) ρ
  तति-सत्यम् (lq a b) ρ with कर्ता-≟ o कlq
  ... | just p  =
      फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = gu (eval (lq a b) ρ) ρ
  तति-सत्यम् (var i) ρ = gu (ρ i) ρ
  तति-सत्यम् ze      ρ = gu zero ρ
  तति-सत्यम् (su t)  ρ = gu (suc (eval t ρ)) ρ

  निवेश-फलम् : (t : Tm) (ys : List Tm) (ρ : ℕ → ℕ)
    → फलितम् (निवेशः t ys) ρ ≡ अर्थः o (eval t ρ) (फलितम् ys ρ)
  निवेश-फलम् t [] ρ = refl
  निवेश-फलम् t (y ∷ ys) ρ with तुला t y
  ... | true  = refl
  ... | false =
      cong (अर्थः o (eval y ρ)) (निवेश-फलम् t ys ρ)
    ∙ ga (eval y ρ) (eval t ρ) (फलितम् ys ρ)
    ∙ cong (λ m → अर्थः o m (फलितम् ys ρ)) (gc (eval y ρ) (eval t ρ))
    ∙ sym (ga (eval t ρ) (eval y ρ) (फलितम् ys ρ))

  क्रम-फलम् : (xs : List Tm) (ρ : ℕ → ℕ) → फलितम् (क्रमणम् xs) ρ ≡ फलितम् xs ρ
  क्रम-फलम् []       ρ = refl
  क्रम-फलम् (x ∷ xs) ρ =
    निवेश-फलम् x (क्रमणम् xs) ρ ∙ cong (अर्थः o (eval x ρ)) (क्रम-फलम् xs ρ)

  सज्जा : List Tm → Tm
  सज्जा []       = u
  सज्जा (t ∷ ts) = रचना o t (सज्जा ts)

  सज्जा-सत्यम् : (ts : List Tm) (ρ : ℕ → ℕ) → eval (सज्जा ts) ρ ≡ फलितम् ts ρ
  सज्जा-सत्यम् []       ρ = refl
  सज्जा-सत्यम् (t ∷ ts) ρ =
    रचना-अर्थः o t (सज्जा ts) ρ ∙ cong (अर्थः o (eval t ρ)) (सज्जा-सत्यम् ts ρ)

  नयनम् : Tm → Tm
  नयनम् (a ⊕ b)  with कर्ता-≟ o क⊕
  ... | just _  = सज्जा (क्रमणम् (तति (नयनम् a) ++ तति (नयनम् b)))
  ... | nothing = नयनम् a ⊕ नयनम् b
  नयनम् (a ⊗ b)  with कर्ता-≟ o क⊗
  ... | just _  = सज्जा (क्रमणम् (तति (नयनम् a) ++ तति (नयनम् b)))
  ... | nothing = नयनम् a ⊗ नयनम् b
  नयनम् (a ⊖ b)  with कर्ता-≟ o क⊖
  ... | just _  = सज्जा (क्रमणम् (तति (नयनम् a) ++ तति (नयनम् b)))
  ... | nothing = नयनम् a ⊖ नयनम् b
  नयनम् (mx a b) with कर्ता-≟ o कmx
  ... | just _  = सज्जा (क्रमणम् (तति (नयनम् a) ++ तति (नयनम् b)))
  ... | nothing = mx (नयनम् a) (नयनम् b)
  नयनम् (lq a b) with कर्ता-≟ o कlq
  ... | just _  = सज्जा (क्रमणम् (तति (नयनम् a) ++ तति (नयनम् b)))
  ... | nothing = lq (नयनम् a) (नयनम् b)
  नयनम् (gc a b) = gc (नयनम् a) (नयनम् b)
  नयनम् (var i)  = var i
  नयनम् ze       = ze
  नयनम् (su t)   = su (नयनम् t)

  खण्डः : (a b : Tm) (ρ : ℕ → ℕ)
    → eval (सज्जा (क्रमणम् (तति a ++ तति b))) ρ ≡ अर्थः o (eval a ρ) (eval b ρ)
  खण्डः a b ρ =
      सज्जा-सत्यम् (क्रमणम् (तति a ++ तति b)) ρ
    ∙ क्रम-फलम् (तति a ++ तति b) ρ
    ∙ फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)

  नयन-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (नयनम् t) ρ ≡ eval t ρ
  नयन-सत्यम् (a ⊕ b) ρ with कर्ता-≟ o क⊕
  ... | just p  =
      खण्डः (नयनम् a) (नयनम् b) ρ
    ∙ cong₂ (अर्थः o) (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = cong₂ _+_ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (a ⊗ b) ρ with कर्ता-≟ o क⊗
  ... | just p  =
      खण्डः (नयनम् a) (नयनम् b) ρ
    ∙ cong₂ (अर्थः o) (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = cong₂ _·_ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (a ⊖ b) ρ with कर्ता-≟ o क⊖
  ... | just p  =
      खण्डः (नयनम् a) (नयनम् b) ρ
    ∙ cong₂ (अर्थः o) (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = cong₂ sbℕ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (mx a b) ρ with कर्ता-≟ o कmx
  ... | just p  =
      खण्डः (नयनम् a) (नयनम् b) ρ
    ∙ cong₂ (अर्थः o) (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = cong₂ mxℕ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (lq a b) ρ with कर्ता-≟ o कlq
  ... | just p  =
      खण्डः (नयनम् a) (नयनम् b) ρ
    ∙ cong₂ (अर्थः o) (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
    ∙ cong (λ o' → अर्थः o' (eval a ρ) (eval b ρ)) p
  ... | nothing = cong₂ lqℕ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (gc a b) ρ = cong₂ गच्छℕ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
  नयन-सत्यम् (var i) ρ = refl
  नयन-सत्यम् ze      ρ = refl
  नयन-सत्यम् (su t)  ρ = cong suc (नयन-सत्यम् t ρ)

  दृग्जन्म : दृक्
  दृग्जन्म = (λ t → नयनम् (norm t))
           , (λ t ρ → नयन-सत्यम् (norm t) ρ ∙ norm-sound t ρ)

------------------------------------------------------------------------
-- §4  Detection: the machine reads its own rules.
------------------------------------------------------------------------

सम-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → (x y : ℕ) → अर्थः o x y ≡ अर्थः o y x))
सम-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd hd)) ≫= λ vi →
  चरम् (fst (snd (snd hd))) ≫= λ vj →
  विभिन्नौ (fst vi) (fst vj) ≫= λ ij →
  (नियमः.lhs s ≟T रचना (fst hd) (var (fst vi)) (var (fst vj))) ≫= λ pl →
  (नियमः.rhs s ≟T रचना (fst hd) (var (fst vj)) (var (fst vi))) ≫= λ pr →
  just (fst hd , सम-निष्कर्षः (fst hd) (fst vi) (fst vj) ij
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))

सह-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → (x y z : ℕ) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z))
सह-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd hd)) ≫= λ vi →
  शीर्षम् (fst (snd (snd hd))) ≫= λ hd₂ →
  चरम् (fst (snd hd₂)) ≫= λ vj →
  चरम् (fst (snd (snd hd₂))) ≫= λ vk →
  विभिन्नौ (fst vj) (fst vi) ≫= λ ji →
  विभिन्नौ (fst vk) (fst vi) ≫= λ ki →
  विभिन्नौ (fst vk) (fst vj) ≫= λ kj →
  (नियमः.lhs s ≟T रचना (fst hd) (var (fst vi)) (रचना (fst hd) (var (fst vj)) (var (fst vk)))) ≫= λ pl →
  (नियमः.rhs s ≟T रचना (fst hd) (रचना (fst hd) (var (fst vi)) (var (fst vj))) (var (fst vk))) ≫= λ pr →
  just (fst hd , सह-निष्कर्षः (fst hd) (fst vi) (fst vj) (fst vk) ji ki kj
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))

एक-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → Σ Tm (λ u → (x : ℕ) (ρ : ℕ → ℕ) → अर्थः o x (eval u ρ) ≡ x)))
एक-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd hd)) ≫= λ vi →
  निर्वार-चेष्टा (fst (snd (snd hd))) ≫= λ cu →
  (नियमः.lhs s ≟T रचना (fst hd) (var (fst vi)) (fst (snd (snd hd)))) ≫= λ pl →
  (नियमः.rhs s ≟T var (fst vi)) ≫= λ pr →
  just (fst hd , fst (snd (snd hd)) , एक-निष्कर्षः (fst hd) (fst vi) (fst (snd (snd hd))) cu
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))
  where
  निर्वार-चेष्टा : (t : Tm) → Maybe (निर्वारः t ≡ true)
  निर्वार-चेष्टा t = go (निर्वारः t) refl
    where
    go : (b : Bool) → निर्वारः t ≡ b → Maybe (निर्वारः t ≡ true)
    go true  p = just p
    go false _ = nothing

------------------------------------------------------------------------
-- §5  The birth: first commutative rule, matching associativity and
--     unit for the SAME operator, and the organ is born.
------------------------------------------------------------------------

सह-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe ((x y z : ℕ) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z)
सह-अन्वेषः o [] = nothing
सह-अन्वेषः o (s ∷ ss) with सह-लक्षणम् s
... | nothing = सह-अन्वेषः o ss
... | just (o₂ , ga) with कर्ता-≟ o o₂
...   | just p  = just (subst (λ o' → (x y z : ℕ) → अर्थः o' x (अर्थः o' y z) ≡ अर्थः o' (अर्थः o' x y) z) (sym p) ga)
...   | nothing = सह-अन्वेषः o ss

एक-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe (Σ Tm (λ u → (x : ℕ) (ρ : ℕ → ℕ) → अर्थः o x (eval u ρ) ≡ x))
एक-अन्वेषः o [] = nothing
एक-अन्वेषः o (s ∷ ss) with एक-लक्षणम् s
... | nothing = एक-अन्वेषः o ss
... | just (o₂ , u , gu) with कर्ता-≟ o o₂
...   | just p  = just (u , subst (λ o' → (x : ℕ) (ρ : ℕ → ℕ) → अर्थः o' x (eval u ρ) ≡ x) (sym p) gu)
...   | nothing = एक-अन्वेषः o ss

अङ्ग-जननम् : List नियमः → Maybe दृक्
अङ्ग-जननम् Γ = go Γ
  where
  go : List नियमः → Maybe दृक्
  go [] = nothing
  go (s ∷ ss) with सम-लक्षणम् s
  ... | nothing = go ss
  ... | just (o , gc) with सह-अन्वेषः o Γ
  ...   | nothing = go ss
  ...   | just ga with एक-अन्वेषः o Γ
  ...     | nothing = go ss
  ...     | just (u , gu) = just (जनकः.दृग्जन्म o u gc ga gu)

निष्पत्तिः : Maybe दृक् → दृक्
निष्पत्तिः (just E) = E
निष्पत्तिः nothing  = (λ t → t) , (λ t ρ → refl)

------------------------------------------------------------------------
-- §6  The organ is born from the store, and it sees — no agent in the
--     path from rule to eye to theorem.
------------------------------------------------------------------------

जन्म-अस्ति : inJust (अङ्ग-जननम् परम्परा)
जन्म-अस्ति = tt

स्वजात-दृष्टिः : inJust (पूर्ण-प्रमाणम् (निष्पत्तिः (अङ्ग-जननम् परम्परा))
  सूक्ष्म-यन्त्रम् [] 1 ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)))
स्वजात-दृष्टिः = tt
