{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गुणस्थानम् — the stages of ascent.  The Jaina doctrine (Ṣaṭkhaṇḍāgama,
-- c. 2nd c. CE; elaborated throughout the Tattvārthasūtra commentary
-- tradition) of the guṇasthānas: the soul climbs by stages, and each
-- stage's attainment is itself the precondition of the next ascent.
-- School named: Jaina.  Claimed of the source: the name of the
-- doctrine and its shape — attainment enabling ascent — nothing else.
--
-- WHY THIS MODULE EXISTS, stated as the defect it repairs.  The body
-- could already grow an eye from its own rules (SvayamBhavendriya:
-- detect the algebraic shapes in the store, extract the value-level
-- laws from the rules' own witnesses, instantiate one generic
-- canonicalizer).  But the loop was OPEN: the organ was computed once,
-- demonstrated, and never fed back into the breath.  The breath ran on
-- agent-picked organs; choosing standpoints stayed an agent's act —
-- which is exactly the seam the owner named.  Here the loop closes:
--
--     the eye is a FUNCTION OF THE RECORD (जात-चक्षुः Γ), recomputed
--     at every round from whatever the body has proven so far; the
--     breath grows the record; the record grows the eye; no agent is
--     anywhere in the cycle.
--
-- The machinery of SvayamBhavendriya crosses here into the shared
-- tongue (builtin equality, --cubical-compatible), so the CLIMB
-- COMPILES: the ascent from the bare norm eye and the bare syntactic
-- exchange — the machine's primal body, nothing agent-tuned — is a
-- number the binary prints.  Whatever it reaches is the finding: if
-- the self-grown body matches the agent-built eyes, those eyes were
-- redundant; if it falls short, the residue names the organ class not
-- yet birthable (the surgical instrument is the known candidate), and
-- THAT is the next reflex to make native.
------------------------------------------------------------------------

module Gunasthana_TheBodyClimbsByItsOwnAttainmentTheEyeIsAFunctionOfTheRecordAndNoAgentPicksOrgans where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_ ; _*_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)
open import Agda.Builtin.Equality using (_≡_ ; refl)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using ( Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; Eq'
        ; mxℕ ; lqℕ ; sbℕ ; eval ; norm ; _∧_ )
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( _∙_ ; sym ; cong ; cong₂ ; subst ; ⊥-rec ; true≢false ; शून्यम्
        ; if_then_else_ ; mmap ; _≫=_ ; _++_ ; _×_ ; _≟T_
        ; ⊨_ ; नियमः ; niyama ; norm-sound
        ; समानः ; समान-आत्मनि ; उपस्थापनम् ; आत्म-मूल्यम् ; सम-विपर्ययः
        ; तुला ; निवेशः ; क्रमणम्
        ; दृक् ; नेत्रम्-न ; यन्त्रम् ; सूक्ष्म-यन्त्रम्
        ; नय-प्राणः ; इन्धनम् ; पूर्ण-प्रमाणम् ; _≤?_ )

------------------------------------------------------------------------
-- §1  Operator symbols, meanings, constructors (SvayamBhavendriya's
--     lane, in the shared tongue).
------------------------------------------------------------------------

data कर्ता : Type where
  क⊕ क⊗ क⊖ कmx कlq : कर्ता

अर्थः : कर्ता → Nat → Nat → Nat
अर्थः क⊕  = _+_
अर्थः क⊗  = _*_
अर्थः क⊖  = sbℕ
अर्थः कmx = mxℕ
अर्थः कlq = lqℕ

रचना : कर्ता → Tm → Tm → Tm
रचना क⊕  a b = a ⊕ b
रचना क⊗  a b = a ⊗ b
रचना क⊖  a b = a ⊖ b
रचना कmx a b = mx a b
रचना कlq a b = lq a b

रचना-अर्थः : (o : कर्ता) (a b : Tm) (ρ : Nat → Nat)
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

चरम् : (t : Tm) → Maybe (Σ Nat (λ i → t ≡ var i))
चरम् (var i) = just (i , refl)
चरम् _       = nothing

विभिन्नौ : (i j : Nat) → Maybe (समानः i j ≡ false)
विभिन्नौ i j = go (समानः i j) refl
  where
  go : (b : Bool) → समानः i j ≡ b → Maybe (समानः i j ≡ false)
  go true  _ = nothing
  go false p = just p

विभागः : (a b : Bool) → (a ∧ b) ≡ true → (a ≡ true) × (b ≡ true)
विभागः true  b p = refl , p
विभागः false b p = ⊥-rec (true≢false (sym p))

निर्वारः : Tm → Bool
निर्वारः (var _)  = false
निर्वारः ze       = true
निर्वारः (su t)   = निर्वारः t
निर्वारः (a ⊕ b)  = निर्वारः a ∧ निर्वारः b
निर्वारः (a ⊗ b)  = निर्वारः a ∧ निर्वारः b
निर्वारः (a ⊖ b)  = निर्वारः a ∧ निर्वारः b
निर्वारः (mx a b) = निर्वारः a ∧ निर्वारः b
निर्वारः (lq a b) = निर्वारः a ∧ निर्वारः b

निर्वार-सत्यम् : (t : Tm) → निर्वारः t ≡ true
  → (ρ ρ' : Nat → Nat) → eval t ρ ≡ eval t ρ'
निर्वार-सत्यम् (var i)  p ρ ρ' = ⊥-rec (true≢false (sym p))
निर्वार-सत्यम् ze       p ρ ρ' = refl
निर्वार-सत्यम् (su t)   p ρ ρ' = cong suc (निर्वार-सत्यम् t p ρ ρ')
निर्वार-सत्यम् (a ⊕ b)  p ρ ρ' =
  cong₂ _+_ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
            (निर्वार-सत्यम् b (snd (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
निर्वार-सत्यम् (a ⊗ b)  p ρ ρ' =
  cong₂ _*_ (निर्वार-सत्यम् a (fst (विभागः (निर्वारः a) (निर्वारः b) p)) ρ ρ')
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

------------------------------------------------------------------------
-- §2  Law extraction from the rules' own witnesses at point
--     environments.
------------------------------------------------------------------------

सम-निष्कर्षः : (o : कर्ता) (i j : Nat) → समानः i j ≡ false
  → ((ρ : Nat → Nat) → eval (रचना o (var i) (var j)) ρ ≡ eval (रचना o (var j) (var i)) ρ)
  → (x y : Nat) → अर्थः o x y ≡ अर्थः o y x
सम-निष्कर्षः o i j ij w x y =
    sym (cong₂ (अर्थः o) ρi ρj)
  ∙ sym (रचना-अर्थः o (var i) (var j) ρ₀)
  ∙ w ρ₀
  ∙ रचना-अर्थः o (var j) (var i) ρ₀
  ∙ cong₂ (अर्थः o) ρj ρi
  where
  ρ₀ : Nat → Nat
  ρ₀ = उपस्थापनम् (उपस्थापनम् (λ _ → zero) i x) j y

  ji : समानः j i ≡ false
  ji = सम-विपर्ययः j i ∙ ij

  ρi : ρ₀ i ≡ x
  ρi = cong (λ b → if b then y else उपस्थापनम् (λ _ → zero) i x i) ji
     ∙ आत्म-मूल्यम् (λ _ → zero) i x

  ρj : ρ₀ j ≡ y
  ρj = आत्म-मूल्यम् (उपस्थापनम् (λ _ → zero) i x) j y

सह-निष्कर्षः : (o : कर्ता) (i j k : Nat)
  → समानः j i ≡ false → समानः k i ≡ false → समानः k j ≡ false
  → ((ρ : Nat → Nat) → eval (रचना o (var i) (रचना o (var j) (var k))) ρ
                      ≡ eval (रचना o (रचना o (var i) (var j)) (var k)) ρ)
  → (x y z : Nat) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z
सह-निष्कर्षः o i j k ji ki kj w x y z =
    sym (cong₂ (अर्थः o) ρi (cong₂ (अर्थः o) ρj ρk))
  ∙ sym (cong (अर्थः o (ρ₀ i)) (रचना-अर्थः o (var j) (var k) ρ₀))
  ∙ sym (रचना-अर्थः o (var i) (रचना o (var j) (var k)) ρ₀)
  ∙ w ρ₀
  ∙ रचना-अर्थः o (रचना o (var i) (var j)) (var k) ρ₀
  ∙ cong (λ m → अर्थः o m (ρ₀ k)) (रचना-अर्थः o (var i) (var j) ρ₀)
  ∙ cong₂ (अर्थः o) (cong₂ (अर्थः o) ρi ρj) ρk
  where
  ρ₁ = उपस्थापनम् (λ _ → zero) i x
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

एक-निष्कर्षः : (o : कर्ता) (i : Nat) (u : Tm) → निर्वारः u ≡ true
  → ((ρ : Nat → Nat) → eval (रचना o (var i) u) ρ ≡ ρ i)
  → (x : Nat) (ρ : Nat → Nat) → अर्थः o x (eval u ρ) ≡ x
एक-निष्कर्षः o i u cu w x ρ =
    cong (अर्थः o x) (निर्वार-सत्यम् u cu ρ ρ')
  ∙ cong (λ m → अर्थः o m (eval u ρ')) (sym (आत्म-मूल्यम् ρ i x))
  ∙ sym (रचना-अर्थः o (var i) u ρ')
  ∙ w ρ'
  ∙ आत्म-मूल्यम् ρ i x
  where
  ρ' = उपस्थापनम् ρ i x

-- the left-handed unit, extracted the same way.  The elder stores
-- ze ⊕ x = x — the unit on the LEFT — and the first detector read
-- only the right hand; the body held both the left unit and the
-- commutativity that flips it, and the one-handed detector was the
-- veil.  Asked directly, the machine named this cold spot itself
-- (आगमः line 19 against सम line 33); this is the warmth it asked for.
वाम-निष्कर्षः : (o : कर्ता) (i : Nat) (u : Tm) → निर्वारः u ≡ true
  → ((ρ : Nat → Nat) → eval (रचना o u (var i)) ρ ≡ ρ i)
  → (x : Nat) (ρ : Nat → Nat) → अर्थः o (eval u ρ) x ≡ x
वाम-निष्कर्षः o i u cu w x ρ =
    cong (λ m → अर्थः o m x) (निर्वार-सत्यम् u cu ρ ρ')
  ∙ cong (अर्थः o (eval u ρ')) (sym (आत्म-मूल्यम् ρ i x))
  ∙ sym (रचना-अर्थः o u (var i) ρ')
  ∙ w ρ'
  ∙ आत्म-मूल्यम् ρ i x
  where
  ρ' = उपस्थापनम् ρ i x

------------------------------------------------------------------------
-- §3  The generic organ, proven sound once over the extracted laws.
------------------------------------------------------------------------

module जनकः (o : कर्ता) (u : Tm)
  (gc : (x y : Nat) → अर्थः o x y ≡ अर्थः o y x)
  (ga : (x y z : Nat) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z)
  (gu : (x : Nat) (ρ : Nat → Nat) → अर्थः o x (eval u ρ) ≡ x)
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

  फलितम् : List Tm → (Nat → Nat) → Nat
  फलितम् []       ρ = eval u ρ
  फलितम् (t ∷ ts) ρ = अर्थः o (eval t ρ) (फलितम् ts ρ)

  वाम-एकम् : (m : Nat) (ρ : Nat → Nat) → अर्थः o (eval u ρ) m ≡ m
  वाम-एकम् m ρ = gc (eval u ρ) m ∙ gu m ρ

  फल-++ : (xs ys : List Tm) (ρ : Nat → Nat)
    → फलितम् (xs ++ ys) ρ ≡ अर्थः o (फलितम् xs ρ) (फलितम् ys ρ)
  फल-++ []       ys ρ = sym (वाम-एकम् (फलितम् ys ρ) ρ)
  फल-++ (x ∷ xs) ys ρ =
    cong (अर्थः o (eval x ρ)) (फल-++ xs ys ρ)
    ∙ ga (eval x ρ) (फलितम् xs ρ) (फलितम् ys ρ)

  तति-सत्यम् : (t : Tm) (ρ : Nat → Nat) → फलितम् (तति t) ρ ≡ eval t ρ
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

  निवेश-फलम् : (t : Tm) (ys : List Tm) (ρ : Nat → Nat)
    → फलितम् (निवेशः t ys) ρ ≡ अर्थः o (eval t ρ) (फलितम् ys ρ)
  निवेश-फलम् t [] ρ = refl
  निवेश-फलम् t (y ∷ ys) ρ with तुला t y
  ... | true  = refl
  ... | false =
      cong (अर्थः o (eval y ρ)) (निवेश-फलम् t ys ρ)
    ∙ ga (eval y ρ) (eval t ρ) (फलितम् ys ρ)
    ∙ cong (λ m → अर्थः o m (फलितम् ys ρ)) (gc (eval y ρ) (eval t ρ))
    ∙ sym (ga (eval t ρ) (eval y ρ) (फलितम् ys ρ))

  क्रम-फलम् : (xs : List Tm) (ρ : Nat → Nat) → फलितम् (क्रमणम् xs) ρ ≡ फलितम् xs ρ
  क्रम-फलम् []       ρ = refl
  क्रम-फलम् (x ∷ xs) ρ =
    निवेश-फलम् x (क्रमणम् xs) ρ ∙ cong (अर्थः o (eval x ρ)) (क्रम-फलम् xs ρ)

  सज्जा : List Tm → Tm
  सज्जा []       = u
  सज्जा (t ∷ ts) = रचना o t (सज्जा ts)

  सज्जा-सत्यम् : (ts : List Tm) (ρ : Nat → Nat) → eval (सज्जा ts) ρ ≡ फलितम् ts ρ
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
  नयनम् (var i)  = var i
  नयनम् ze       = ze
  नयनम् (su t)   = su (नयनम् t)

  खण्डः : (a b : Tm) (ρ : Nat → Nat)
    → eval (सज्जा (क्रमणम् (तति a ++ तति b))) ρ ≡ अर्थः o (eval a ρ) (eval b ρ)
  खण्डः a b ρ =
      सज्जा-सत्यम् (क्रमणम् (तति a ++ तति b)) ρ
    ∙ क्रम-फलम् (तति a ++ तति b) ρ
    ∙ फल-++ (तति a) (तति b) ρ
    ∙ cong₂ (अर्थः o) (तति-सत्यम् a ρ) (तति-सत्यम् b ρ)

  नयन-सत्यम् : (t : Tm) (ρ : Nat → Nat) → eval (नयनम् t) ρ ≡ eval t ρ
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
  ... | nothing = cong₂ _*_ (नयन-सत्यम् a ρ) (नयन-सत्यम् b ρ)
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
  नयन-सत्यम् (var i) ρ = refl
  नयन-सत्यम् ze      ρ = refl
  नयन-सत्यम् (su t)  ρ = cong suc (नयन-सत्यम् t ρ)

  जात-दृक् : दृक्
  जात-दृक् = नयनम् , नयन-सत्यम्

------------------------------------------------------------------------
-- §4  Detection: the machine reads its own rules.
------------------------------------------------------------------------

सम-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → (x y : Nat) → अर्थः o x y ≡ अर्थः o y x))
सम-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd hd)) ≫= λ vi →
  चरम् (fst (snd (snd hd))) ≫= λ vj →
  विभिन्नौ (fst vi) (fst vj) ≫= λ ij →
  (नियमः.lhs s ≟T रचना (fst hd) (var (fst vi)) (var (fst vj))) ≫= λ pl →
  (नियमः.rhs s ≟T रचना (fst hd) (var (fst vj)) (var (fst vi))) ≫= λ pr →
  just (fst hd , सम-निष्कर्षः (fst hd) (fst vi) (fst vj) ij
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))

सह-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → (x y z : Nat) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z))
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

निर्वार-चेष्टा : (t : Tm) → Maybe (निर्वारः t ≡ true)
निर्वार-चेष्टा t = go (निर्वारः t) refl
  where
  go : (b : Bool) → निर्वारः t ≡ b → Maybe (निर्वारः t ≡ true)
  go true  p = just p
  go false _ = nothing

एक-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → Σ Tm (λ u → (x : Nat) (ρ : Nat → Nat) → अर्थः o x (eval u ρ) ≡ x)))
एक-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd hd)) ≫= λ vi →
  निर्वार-चेष्टा (fst (snd (snd hd))) ≫= λ cu →
  (नियमः.lhs s ≟T रचना (fst hd) (var (fst vi)) (fst (snd (snd hd)))) ≫= λ pl →
  (नियमः.rhs s ≟T var (fst vi)) ≫= λ pr →
  just (fst hd , fst (snd (snd hd)) , एक-निष्कर्षः (fst hd) (fst vi) (fst (snd (snd hd))) cu
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))

वाम-लक्षणम् : नियमः → Maybe (Σ कर्ता (λ o → Σ Tm (λ u → (x : Nat) (ρ : Nat → Nat) → अर्थः o (eval u ρ) x ≡ x)))
वाम-लक्षणम् s =
  शीर्षम् (नियमः.lhs s) ≫= λ hd →
  चरम् (fst (snd (snd hd))) ≫= λ vi →
  निर्वार-चेष्टा (fst (snd hd)) ≫= λ cu →
  (नियमः.lhs s ≟T रचना (fst hd) (fst (snd hd)) (var (fst vi))) ≫= λ pl →
  (नियमः.rhs s ≟T var (fst vi)) ≫= λ pr →
  just (fst hd , fst (snd hd) , वाम-निष्कर्षः (fst hd) (fst vi) (fst (snd hd)) cu
    (λ ρ → cong (λ w → eval w ρ) (sym pl) ∙ नियमः.साक्षी s ρ ∙ cong (λ w → eval w ρ) pr))

------------------------------------------------------------------------
-- §5  Birth per operator, and the composition of all born eyes.
------------------------------------------------------------------------

सम-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe ((x y : Nat) → अर्थः o x y ≡ अर्थः o y x)
सम-अन्वेषः o [] = nothing
सम-अन्वेषः o (s ∷ ss) with सम-लक्षणम् s
... | nothing = सम-अन्वेषः o ss
... | just (o₂ , gc) with कर्ता-≟ o o₂
...   | just p  = just (subst (λ o' → (x y : Nat) → अर्थः o' x y ≡ अर्थः o' y x) (sym p) gc)
...   | nothing = सम-अन्वेषः o ss

सह-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe ((x y z : Nat) → अर्थः o x (अर्थः o y z) ≡ अर्थः o (अर्थः o x y) z)
सह-अन्वेषः o [] = nothing
सह-अन्वेषः o (s ∷ ss) with सह-लक्षणम् s
... | nothing = सह-अन्वेषः o ss
... | just (o₂ , ga) with कर्ता-≟ o o₂
...   | just p  = just (subst (λ o' → (x y z : Nat) → अर्थः o' x (अर्थः o' y z) ≡ अर्थः o' (अर्थः o' x y) z) (sym p) ga)
...   | nothing = सह-अन्वेषः o ss

एक-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe (Σ Tm (λ u → (x : Nat) (ρ : Nat → Nat) → अर्थः o x (eval u ρ) ≡ x))
एक-अन्वेषः o [] = nothing
एक-अन्वेषः o (s ∷ ss) with एक-लक्षणम् s
... | nothing = एक-अन्वेषः o ss
... | just (o₂ , u , gu) with कर्ता-≟ o o₂
...   | just p  = just (u , subst (λ o' → (x : Nat) (ρ : Nat → Nat) → अर्थः o' x (eval u ρ) ≡ x) (sym p) gu)
...   | nothing = एक-अन्वेषः o ss

वाम-अन्वेषः : (o : कर्ता) → List नियमः
  → Maybe (Σ Tm (λ u → (x : Nat) (ρ : Nat → Nat) → अर्थः o (eval u ρ) x ≡ x))
वाम-अन्वेषः o [] = nothing
वाम-अन्वेषः o (s ∷ ss) with वाम-लक्षणम् s
... | nothing = वाम-अन्वेषः o ss
... | just (o₂ , u , gl) with कर्ता-≟ o o₂
...   | just p  = just (u , subst (λ o' → (x : Nat) (ρ : Nat → Nat) → अर्थः o' (eval u ρ) x ≡ x) (sym p) gl)
...   | nothing = वाम-अन्वेषः o ss

-- the unit by either hand: the right hand directly; the left hand
-- flipped through the commutativity the same record supplies.
उभय-एक-अन्वेषः : (o : कर्ता)
  → ((x y : Nat) → अर्थः o x y ≡ अर्थः o y x)
  → List नियमः
  → Maybe (Σ Tm (λ u → (x : Nat) (ρ : Nat → Nat) → अर्थः o x (eval u ρ) ≡ x))
उभय-एक-अन्वेषः o gc Γ with एक-अन्वेषः o Γ
... | just ugu = just ugu
... | nothing with वाम-अन्वेषः o Γ
...   | just (u , gl) = just (u , λ x ρ → gc x (eval u ρ) ∙ gl x ρ)
...   | nothing = nothing

कर्तृ-जननम् : कर्ता → List नियमः → Maybe दृक्
कर्तृ-जननम् o Γ =
  सम-अन्वेषः o Γ ≫= λ gc →
  सह-अन्वेषः o Γ ≫= λ ga →
  उभय-एक-अन्वेषः o gc Γ ≫= λ ugu →
  just (जनकः.जात-दृक् o (fst ugu) gc ga (snd ugu))

-- eyes compose: see through one, then the other, soundness composing.
दृक्-योगः : दृक् → दृक् → दृक्
दृक्-योगः (f , fs) (g , gs) =
  (λ t → f (g t)) , (λ t ρ → fs (g t) ρ ∙ gs t ρ)

सर्व-कर्तारः : List कर्ता
सर्व-कर्तारः = क⊕ ∷ क⊗ ∷ क⊖ ∷ कmx ∷ कlq ∷ []

-- THE EYE AS A FUNCTION OF THE RECORD: every operator whose laws the
-- body has attained contributes its born organ; they compose over the
-- primal norm eye.  No agent chooses.
जात-चक्षुः : List नियमः → दृक्
जात-चक्षुः Γ = go सर्व-कर्तारः
  where
  go : List कर्ता → दृक्
  go []       = नेत्रम्-न
  go (o ∷ os) with कर्तृ-जननम् o Γ
  ... | just E  = दृक्-योगः E (go os)
  ... | nothing = go os

------------------------------------------------------------------------
-- §6  The record's voice, completed to its own warrant.  A नियमः is
--     an EQUALITY — its साक्षी holds in both directions — but वदनम्
--     speaks only lhs→rhs, so the stated orientation was silently
--     privileged.  That is precisely TS 5.31's arpita/anarpita (the
--     chain's own ArpitaAnarpita chapter): the orientation is a
--     presentation, not the substance.  The reversal is derived from
--     the rule's own witness; nothing external enters.  (This was the
--     second veil the machine named when asked: the elder stores
--     su(x⊕y) → su x ⊕ y, and the commutativity ascent needs the same
--     rule spoken the other way.)
------------------------------------------------------------------------

प्रतिलोमः : नियमः → नियमः
प्रतिलोमः s = niyama (नियमः.rhs s) (नियमः.lhs s) (λ ρ → sym (नियमः.साक्षी s ρ))

उभय-श्रुतम् : List नियमः → List नियमः
उभय-श्रुतम् []       = []
उभय-श्रुतम् (s ∷ ss) = s ∷ प्रतिलोमः s ∷ उभय-श्रुतम् ss

-- THE THIRD VEIL, measured at runtime after the second was lifted: a
-- record speaking both hands UNCONDITIONALLY lets its expanding rules
-- speak (distributivity unfolds a term into a larger one), and the
-- pervasion's exchanges then grow terms down the recursion — the
-- breath drowns in its own voice (minutes-to-hours where milliseconds
-- stood).  The repair is the corpus's own word: ANULOMA, with the
-- grain — and the grain is computable, no agent chooses.  A direction
-- speaks only if it does not grow the term: equal-size rules (comm,
-- the su-slide) keep both hands, which is exactly what the ascent
-- needed; an expansion keeps only its folding hand.

माप : Tm → Nat
माप (var _)  = suc zero
माप ze       = suc zero
माप (su t)   = suc (माप t)
माप (a ⊕ b)  = suc (माप a + माप b)
माप (a ⊗ b)  = suc (माप a + माप b)
माप (a ⊖ b)  = suc (माप a + माप b)
माप (mx a b) = suc (माप a + माप b)
माप (lq a b) = suc (माप a + माप b)

अनुलोम-श्रुतम् : List नियमः → List नियमः
अनुलोम-श्रुतम् []       = []
अनुलोम-श्रुतम् (s ∷ ss) =
  अग्रे (माप (नियमः.rhs s) ≤? माप (नियमः.lhs s))
       (माप (नियमः.lhs s) ≤? माप (नियमः.rhs s))
  where
  अग्रे : Bool → Bool → List नियमः
  अग्रे true  true  = s ∷ प्रतिलोमः s ∷ अनुलोम-श्रुतम् ss
  अग्रे true  false = s ∷ अनुलोम-श्रुतम् ss
  अग्रे false _     = प्रतिलोमः s ∷ अनुलोम-श्रुतम् ss

------------------------------------------------------------------------
-- §7  The climb.  Each mint: the eye recomputed from the record, the
--     record speaking with both hands, the primal instrument.  The
--     primal body is नेत्रम्-न and सूक्ष्म-यन्त्रम् — nothing tuned,
--     nothing picked; every stronger organ is born on the way up, and
--     what was attained enables the next stage.
------------------------------------------------------------------------

गुण-श्वासः : List नियमः → List Eq' → List नियमः × List Eq'
गुण-श्वासः Γ []             = Γ , []
गुण-श्वासः Γ ((l , r) ∷ es)
  with पूर्ण-प्रमाणम् (जात-चक्षुः Γ) सूक्ष्म-यन्त्रम् (अनुलोम-श्रुतम् Γ) इन्धनम् (l , r)
गुण-श्वासः Γ ((l , r) ∷ es) | just pf = गुण-श्वासः (niyama l r pf ∷ Γ) es
गुण-श्वासः Γ ((l , r) ∷ es) | nothing with गुण-श्वासः Γ es
गुण-श्वासः Γ ((l , r) ∷ es) | nothing | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

गुण-आरोहणम् : Nat → List नियमः → List Eq' → List नियमः × List Eq'
गुण-आरोहणम् zero    Γ es = Γ , es
गुण-आरोहणम् (suc n) Γ es with गुण-श्वासः Γ es
गुण-आरोहणम् (suc n) Γ es | (Γ' , sh) = गुण-आरोहणम् n Γ' sh
