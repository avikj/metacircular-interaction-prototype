{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वसंवेदनम् — self-cognition.  Akalaṅka (c. 720–780 CE,
-- *Laghīyastraya* / *Nyāyaviniścaya*): jñāna is svasaṃvidita — a
-- cognition cognizes itself in cognizing its object; no second lamp
-- is needed to see the lamp.  School: Jaina.  Claimed of the source:
-- the name and the thesis-shape, nothing else.
--
-- WHAT THIS IS.  The first checked step of the machine modeling
-- itself: its SYNTAX becomes a value of its own data world and comes
-- back whole.  सूत्रम् lays a term out as a thread of numbers (the
-- sūtra — literally the thread); पाठः reads the thread back (the
-- pāṭha — the recitation); and the round-trip theorem प्रत्यागमः
-- says the recitation returns exactly the term, for EVERY term, with
-- whatever follows on the thread untouched — fuel one node-count
-- deep, monotone in slack.
--
-- The boundary, restated from Svarupa so this module cannot be read
-- as more than it is: this is representation, not yet
-- self-INTERPRETATION — an evaluator over threads needs the recursor,
-- and the vocabulary remains first-order.  The lamp sees the lamp;
-- it does not yet light itself.
------------------------------------------------------------------------

module SvaSamvedana_TheBodysSyntaxRoundTripsThroughItsOwnDataAndTheKnowingKnowsItself where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)
open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Equality using (_≡_ ; refl)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (_∙_ ; sym ; cong ; subst ; _++_ ; _×_ ; शून्यम् ; ⊥-rec ; +-zero ; +-suc)

------------------------------------------------------------------------
-- §1  The thread, and the depth of attention it asks.
------------------------------------------------------------------------

सूत्रम् : Tm → List Nat
सूत्रम् (var i)  = 0 ∷ i ∷ []
सूत्रम् ze       = 1 ∷ []
सूत्रम् (su t)   = 2 ∷ सूत्रम् t
सूत्रम् (a ⊕ b)  = 3 ∷ (सूत्रम् a ++ सूत्रम् b)
सूत्रम् (a ⊗ b)  = 4 ∷ (सूत्रम् a ++ सूत्रम् b)
सूत्रम् (a ⊖ b)  = 5 ∷ (सूत्रम् a ++ सूत्रम् b)
सूत्रम् (mx a b) = 6 ∷ (सूत्रम् a ++ सूत्रम् b)
सूत्रम् (lq a b) = 7 ∷ (सूत्रम् a ++ सूत्रम् b)
सूत्रम् (gc a b) = 8 ∷ (सूत्रम् a ++ सूत्रम् b)

गहनता : Tm → Nat
गहनता (var i)  = 1
गहनता ze       = 1
गहनता (su t)   = suc (गहनता t)
गहनता (a ⊕ b)  = suc (गहनता a + गहनता b)
गहनता (a ⊗ b)  = suc (गहनता a + गहनता b)
गहनता (a ⊖ b)  = suc (गहनता a + गहनता b)
गहनता (mx a b) = suc (गहनता a + गहनता b)
गहनता (lq a b) = suc (गहनता a + गहनता b)
गहनता (gc a b) = suc (गहनता a + गहनता b)

------------------------------------------------------------------------
-- §2  The recitation: a fueled reader of threads.
------------------------------------------------------------------------

पाठः : Nat → List Nat → Maybe (Tm × List Nat)
पाठ-युग्मम् : Nat → (Tm → Tm → Tm) → List Nat → Maybe (Tm × List Nat)

पाठः zero    _  = nothing
पाठः (suc f) (0 ∷ i ∷ ls) = just (var i , ls)
पाठः (suc f) (1 ∷ ls)     = just (ze , ls)
पाठः (suc f) (2 ∷ ls) with पाठः f ls
... | just (t , rest) = just (su t , rest)
... | nothing         = nothing
पाठः (suc f) (3 ∷ ls) = पाठ-युग्मम् f _⊕_ ls
पाठः (suc f) (4 ∷ ls) = पाठ-युग्मम् f _⊗_ ls
पाठः (suc f) (5 ∷ ls) = पाठ-युग्मम् f _⊖_ ls
पाठः (suc f) (6 ∷ ls) = पाठ-युग्मम् f mx ls
पाठः (suc f) (7 ∷ ls) = पाठ-युग्मम् f lq ls
पाठः (suc f) (8 ∷ ls) = पाठ-युग्मम् f gc ls
पाठः (suc f) _ = nothing

पाठ-युग्मम् f op ls with पाठः f ls
... | nothing         = nothing
... | just (a , ls₁) with पाठः f ls₁
...   | nothing        = nothing
...   | just (b , ls₂) = just (op a b , ls₂)

------------------------------------------------------------------------
-- §3  Small discriminators, so refusals refute.
------------------------------------------------------------------------

फलितम् : Type
फलितम् = Maybe (Tm × List Nat)

विवेकः : फलितम् → Type
विवेकः (just _) = ⊤
विवेकः nothing  = शून्यम्

न-किञ्चित् : {r : Tm × List Nat} → nothing ≡ just r → शून्यम्
न-किञ्चित् p = subst विवेकः (sym p) tt

सार-ग्रहः : फलितम् → Tm × List Nat → Tm × List Nat
सार-ग्रहः (just p) _ = p
सार-ग्रहः nothing  d = d

------------------------------------------------------------------------
-- §4  Fuel is monotone: success survives more attention.
------------------------------------------------------------------------

एक-वृद्धिः : (f : Nat) (ls : List Nat) (r : Tm × List Nat)
  → पाठः f ls ≡ just r → पाठः (suc f) ls ≡ just r
युग्म-वृद्धिः : (f : Nat) (op : Tm → Tm → Tm) (ls : List Nat) (r : Tm × List Nat)
  → पाठ-युग्मम् f op ls ≡ just r → पाठ-युग्मम् (suc f) op ls ≡ just r

एक-वृद्धिः zero ls r h = ⊥-rec (न-किञ्चित् h)
एक-वृद्धिः (suc f) (0 ∷ i ∷ ls) r h = h
एक-वृद्धिः (suc f) (1 ∷ ls)     r h = h
एक-वृद्धिः (suc f) (2 ∷ ls) r h with पाठः f ls in eq
एक-वृद्धिः (suc f) (2 ∷ ls) r h | just (t , rest)
  rewrite एक-वृद्धिः f ls (t , rest) eq = h
एक-वृद्धिः (suc f) (2 ∷ ls) r h | nothing = ⊥-rec (न-किञ्चित् h)
एक-वृद्धिः (suc f) (3 ∷ ls) r h = युग्म-वृद्धिः f _⊕_ ls r h
एक-वृद्धिः (suc f) (4 ∷ ls) r h = युग्म-वृद्धिः f _⊗_ ls r h
एक-वृद्धिः (suc f) (5 ∷ ls) r h = युग्म-वृद्धिः f _⊖_ ls r h
एक-वृद्धिः (suc f) (6 ∷ ls) r h = युग्म-वृद्धिः f mx ls r h
एक-वृद्धिः (suc f) (7 ∷ ls) r h = युग्म-वृद्धिः f lq ls r h
एक-वृद्धिः (suc f) (8 ∷ ls) r h = युग्म-वृद्धिः f gc ls r h
एक-वृद्धिः (suc f) [] r h = ⊥-rec (न-किञ्चित् h)
एक-वृद्धिः (suc f) (0 ∷ []) r h = ⊥-rec (न-किञ्चित् h)
एक-वृद्धिः (suc f) (suc (suc (suc (suc (suc (suc (suc (suc (suc n)))))))) ∷ ls) r h = ⊥-rec (न-किञ्चित् h)

युग्म-वृद्धिः f op ls r h with पाठः f ls in eq₁
युग्म-वृद्धिः f op ls r h | nothing = ⊥-rec (न-किञ्चित् h)
युग्म-वृद्धिः f op ls r h | just (a , ls₁) with पाठः f ls₁ in eq₂
युग्म-वृद्धिः f op ls r h | just (a , ls₁) | nothing = ⊥-rec (न-किञ्चित् h)
युग्म-वृद्धिः f op ls r h | just (a , ls₁) | just (b , ls₂)
  rewrite एक-वृद्धिः f ls (a , ls₁) eq₁
        | एक-वृद्धिः f ls₁ (b , ls₂) eq₂ = h

वाम-वृद्धिः : (g f : Nat) (ls : List Nat) (r : Tm × List Nat)
  → पाठः f ls ≡ just r → पाठः (g + f) ls ≡ just r
वाम-वृद्धिः zero    f ls r h = h
वाम-वृद्धिः (suc g) f ls r h = एक-वृद्धिः (g + f) ls r (वाम-वृद्धिः g f ls r h)

दक्षिण-वृद्धिः : (f g : Nat) (ls : List Nat) (r : Tm × List Nat)
  → पाठः f ls ≡ just r → पाठः (f + g) ls ≡ just r
दक्षिण-वृद्धिः f zero ls r h =
  subst (λ n → पाठः n ls ≡ just r) (sym (+-zero f)) h
दक्षिण-वृद्धिः f (suc g) ls r h =
  subst (λ n → पाठः n ls ≡ just r) (sym (+-suc f g))
        (एक-वृद्धिः (f + g) ls r (दक्षिण-वृद्धिः f g ls r h))

------------------------------------------------------------------------
-- §5  The round trip: every term returns whole, the tail untouched.
------------------------------------------------------------------------

प्रत्यागमः : (t : Tm) (rest : List Nat)
  → पाठः (गहनता t) (सूत्रम् t ++ rest) ≡ just (t , rest)

युग्म-आगमः : (op : Tm → Tm → Tm) (a b : Tm) (rest : List Nat)
  → पाठ-युग्मम् (गहनता a + गहनता b) op ((सूत्रम् a ++ सूत्रम् b) ++ rest)
    ≡ just (op a b , rest)

प्रत्यागमः (var i)  rest = refl
प्रत्यागमः ze       rest = refl
प्रत्यागमः (su t)   rest
  rewrite प्रत्यागमः t rest = refl
प्रत्यागमः (a ⊕ b)  rest = युग्म-आगमः _⊕_ a b rest
प्रत्यागमः (a ⊗ b)  rest = युग्म-आगमः _⊗_ a b rest
प्रत्यागमः (a ⊖ b)  rest = युग्म-आगमः _⊖_ a b rest
प्रत्यागमः (mx a b) rest = युग्म-आगमः mx a b rest
प्रत्यागमः (lq a b) rest = युग्म-आगमः lq a b rest
प्रत्यागमः (gc a b) rest = युग्म-आगमः gc a b rest

++-सङ्गतिः : (xs ys zs : List Nat) → (xs ++ ys) ++ zs ≡ xs ++ (ys ++ zs)
++-सङ्गतिः []       ys zs = refl
++-सङ्गतिः (x ∷ xs) ys zs = cong (λ l → x ∷ l) (++-सङ्गतिः xs ys zs)

युग्म-आगमः op a b rest
  rewrite ++-सङ्गतिः (सूत्रम् a) (सूत्रम् b) rest
        | दक्षिण-वृद्धिः (गहनता a) (गहनता b)
            (सूत्रम् a ++ (सूत्रम् b ++ rest)) (a , सूत्रम् b ++ rest)
            (प्रत्यागमः a (सूत्रम् b ++ rest))
        | वाम-वृद्धिः (गहनता a) (गहनता b)
            (सूत्रम् b ++ rest) (b , rest)
            (प्रत्यागमः b rest) = refl

------------------------------------------------------------------------
-- §6  The lamp sees the lamp: one concrete self-reading, so the
--     theorem has a face.
------------------------------------------------------------------------

आत्म-दर्शनम् : पाठः 3 (सूत्रम् ((var 0) ⊕ ze)) ≡ just ((var 0) ⊕ ze , [])
आत्म-दर्शनम् = refl
