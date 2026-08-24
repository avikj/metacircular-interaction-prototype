-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तात्कालिकी गतिः — the prime charge is the tangent of the parity
-- character, and the jet is multiplicative.
--
-- THE COMPILE STEP OF THE TWIN BOUNDARY, checked exactly.  The twin-sieve
-- coefficient vector, for squarefree d,
--
--     κ₁(d)  =  Σ_{p|d} μ(d/p)  =  ω(d)·(−1)^{ω(d)−1},
--
-- looks nonmultiplicative — an arbitrary vector in the exponentially
-- large divisor space.  It is not arbitrary: it is the TANGENT at the
-- parity point z = −1 of the one-parameter phase family z^{ω(d)}, and
-- the pair (μ, κ₁) is closed under coprime multiplication by the
-- μ-twisted Leibniz law.  Executable form: the dual numbers ℤ[ε]/ε².
-- One prime contributes the jet unit (−1 + ε); a squarefree d
-- contributes (−1 + ε)^{ω(d)}; the value is μ(d) and the ε-coefficient
-- is κ₁(d).  Multiplication of dual numbers IS the twisted Leibniz law,
-- so the law is not proved separately here — it is read off, one
-- component of one homomorphism path (सङ्कलनम् below).
--
-- NORMALIZATION, the olympiad move, stated so it is not smuggled: only
-- ω(d) enters any of these quantities, so the object is normalized from
-- squarefree numbers to ℕ.  Disjoint union of prime supports becomes
-- +ℕ; "coprime multiplication" becomes addition of counts.  Nothing of
-- the (μ, κ₁) algebra is lost — that is what the closed forms prove.
--
--   घातः          (−1+ε)^n in the dual ring, by recursion
--   मूल्यम्        घातः n ≡ (μ n , κ n)      value and tangent, exactly
--   सङ्कलनम्       घातः (m+n) ≡ घातः m ⊙ घातः n     the jet is multiplicative
--   गुणकत्वम्      μ (m+n) ≡ μ m · μ n              (fst of सङ्कलनम्)
--   विकर्ण-नियमः  κ (m+n) ≡ μ m · κ n + κ m · μ n  (snd of सङ्कलनम् — the
--                 twisted Leibniz law, for free)
--   घन-रूपम्      κ (suc n) ≡ pos (suc n) · μ n    the closed form
--                 κ₁ = ω·(−1)^{ω−1}
--   μ-वर्गः       μ n · μ n ≡ 1
--   κ-वर्गः       κ n · κ n ≡ pos (n²)             the twin channel κ⊗κ of
--                 the four-channel state is a POSITIVE SQUARE — the
--                 diagonal of the (1,1) jet sector carries sign ε₁ε₂ = +
--
-- ON THE NAME.  तात्कालिकी गतिः — Bhāskara II, Siddhāntaśiromaṇi,
-- Grahagaṇitādhyāya, spaṣṭādhikāra (1150): the instantaneous motion of a
-- planet, the rate at the instant as against the mean rate over a day.
-- The term is used here for its literal content — the tangent of a
-- family at a point — and for nothing else: NO claim that Bhāskara
-- treated nilpotents, Möbius inversion, or sieve coefficients.  The
-- dual-number normal form of (μ, κ₁) was stated by the owner in this
-- session, 2026-08-23, and is checked here.
--
-- सहजन्म.  `Yamala_TheTwinChargeIsTheParityJet…` landed from another seat
-- within the hour, from the same owner message — the general machinery:
-- (Dual, ⊛) a commutative monoid, the conditional hom J(ab) = J(a)⊛J(b)
-- given the derivation hypotheses, and autodiff at ANY z.  This module
-- is its parity-point complement, neither subsumed nor subsuming: the
-- concrete μ, κ : ℕ → ℤ with the laws UNCONDITIONAL over the
-- ω-normalization (गुणकत्वम्, विकर्ण-नियमः from one homomorphism path), the
-- closed form घन-रूपम्, and the sign of the twin channel (κ-वर्गः).  Two
-- seats, one seed, two adjacent theorems — kept both, cross-referenced.
--
-- दोषलेखः, scope.  This module is the algebra of the state, complete; the
-- ANALYTIC question — whether the critical CRT boundary amplifies the
-- (1,1) jet channel, the renormalization inequality over scales — is not
-- touched, and no analytic claim is made.  The exponential ambient space
-- has been compiled to a two-channel exact state; the scale induction is
-- the open problem, named, not built.
------------------------------------------------------------------------

module TatkalikiGati_ThePrimeChargeIsTheTangentOfTheParityCharacterAndTheJetIsMultiplicative where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Int
  using ( ℤ ; pos ; negsuc ; _+_ ; _·_ ; -_ ; _-_
        ; +Comm ; +Assoc ; ·Comm ; ·IdR ; ·Assoc  -- ·IdR is the v0.9 PIN's name (Cubical/Data/Int/Properties.agda:1184).  A sibling flipped it to ·Rid (594dd6ba) for an older container; the repo pin is Agda 2.8.0 + cubical v0.9 and the whole physics spine (PinSn, πTruncIso) requires it.  Do not flip back — upgrade the container instead.
        ; ·DistR+ ; ·DistL+ ; -DistL· ; -DistR· ; -Dist+
        ; -Involutive ; pos·pos )
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- १ · the two channels, by recursion — μ the parity, κ its tangent.
------------------------------------------------------------------------

μ : ℕ → ℤ
μ zero    = pos 1
μ (suc n) = - μ n

κ : ℕ → ℤ
κ zero    = pos 0
κ (suc n) = μ n - κ n

------------------------------------------------------------------------
-- २ · the dual ring ℤ[ε]/ε² and the jet unit of a single prime.
------------------------------------------------------------------------

द्वयम् : Type
द्वयम् = ℤ × ℤ

_⊙_ : द्वयम् → द्वयम् → द्वयम्
(a , b) ⊙ (c , d) = (a · c , a · d + b · c)

infixl 7 _⊙_

बीजम् : द्वयम्                      -- (−1 + ε): one prime's whole contribution
बीजम् = (negsuc 0 , pos 1)

घातः : ℕ → द्वयम्                   -- (−1 + ε)^n
घातः zero    = (pos 1 , pos 0)
घातः (suc n) = बीजम् ⊙ घातः n

------------------------------------------------------------------------
-- ३ · मूल्यम् — the state IS the pair (parity, tangent), exactly.
------------------------------------------------------------------------

private
  1·  : (x : ℤ) → pos 1 · x ≡ x
  1·  x = ·Comm (pos 1) x ∙ ·IdR x

मूल्यम् : (n : ℕ) → घातः n ≡ (μ n , κ n)
मूल्यम् zero    = refl
मूल्यम् (suc n) =
  cong (बीजम् ⊙_) (मूल्यम् n)
  ∙ λ i → (- μ n , ( +Comm (- κ n) (pos 1 · μ n)
                   ∙ cong (_+ (- κ n)) (1· (μ n)) ) i)

------------------------------------------------------------------------
-- ४ · the jet is multiplicative: घातः is a homomorphism from (ℕ, +) to
-- (द्वयम्, ⊙).  Associativity of ⊙ is the only labour.
------------------------------------------------------------------------

⊙-Assoc : (x y z : द्वयम्) → x ⊙ (y ⊙ z) ≡ (x ⊙ y) ⊙ z
⊙-Assoc (a , b) (c , d) (e , f) =
  λ i → (·Assoc a c e i , द्वितीयम् i)
  where
    द्वितीयम् : a · (c · f + d · e) + b · (c · e)
             ≡ (a · c) · f + (a · d + b · c) · e
    द्वितीयम् =
      cong₂ _+_ (·DistR+ a (c · f) (d · e)
                ∙ cong₂ _+_ (·Assoc a c f) (·Assoc a d e))
                (·Assoc b c e)
      ∙ sym (+Assoc ((a · c) · f) ((a · d) · e) ((b · c) · e))
      ∙ cong ((a · c) · f +_) (sym (·DistL+ (a · d) (b · c) e))

सङ्कलनम् : (m n : ℕ) → घातः (m +ℕ n) ≡ घातः m ⊙ घातः n
सङ्कलनम् zero n =
  λ i → ( sym (1· (fst (घातः n))) i
        , ( sym (1· (snd (घातः n)))
          ∙ sym (+Rid (pos 1 · snd (घातः n))) ) i )
  where
    +Rid : (x : ℤ) → x + pos 0 ≡ x
    +Rid x = refl
सङ्कलनम् (suc m) n =
  cong (बीजम् ⊙_) (सङ्कलनम् m n) ∙ ⊙-Assoc बीजम् (घातः m) (घातः n)

------------------------------------------------------------------------
-- ५ · the two laws, read off as the two components of ONE path:
-- the homomorphism, conjugated by मूल्यम्.
------------------------------------------------------------------------

नियम-मार्गः : (m n : ℕ) → (μ (m +ℕ n) , κ (m +ℕ n)) ≡ (μ m , κ m) ⊙ (μ n , κ n)
नियम-मार्गः m n =
  sym (मूल्यम् (m +ℕ n)) ∙ सङ्कलनम् m n ∙ cong₂ _⊙_ (मूल्यम् m) (मूल्यम् n)

गुणकत्वम् : (m n : ℕ) → μ (m +ℕ n) ≡ μ m · μ n
गुणकत्वम् m n = cong fst (नियम-मार्गः m n)

विकर्ण-नियमः : (m n : ℕ) → κ (m +ℕ n) ≡ μ m · κ n + κ m · μ n
विकर्ण-नियमः m n = cong snd (नियम-मार्गः m n)

------------------------------------------------------------------------
-- ६ · the closed form: the tangent is ω·(−1)^{ω−1}, exactly the
-- κ₁(d) = Σ_{p|d} μ(d/p) of the twin boundary.
------------------------------------------------------------------------

घन-रूपम् : (n : ℕ) → κ (suc n) ≡ pos (suc n) · μ n
घन-रूपम् zero    = refl
घन-रूपम् (suc n) =
  cong (μ (suc n) +_) (cong -_ (घन-रूपम् n) ∙ -DistR· (pos (suc n)) (μ n))
  ∙ refl

------------------------------------------------------------------------
-- ७ · the diagonal of the four-channel state: both squares are positive.
-- For two legs the state is ℤ[ε₁,ε₂]/(ε₁²,ε₂²) with channels
-- (μ⊗μ, κ⊗μ, μ⊗κ, κ⊗κ); at equal leg-depth the μ⊗μ channel is +1 and
-- the twin channel κ⊗κ is the square ω², positive — the (1,1) jet
-- sector sits in the positive cone before any boundary acts on it.
------------------------------------------------------------------------

μ-वर्गः : (n : ℕ) → μ n · μ n ≡ pos 1
μ-वर्गः zero    = refl
μ-वर्गः (suc n) =
  sym (-DistL· (μ n) (- μ n))
  ∙ cong -_ (sym (-DistR· (μ n) (μ n)))
  ∙ -Involutive (μ n · μ n)
  ∙ μ-वर्गः n

κ-वर्गः : (n : ℕ) → κ n · κ n ≡ pos (n ·ℕ n)
κ-वर्गः zero    = refl
κ-वर्गः (suc n) =
  cong₂ _·_ (घन-रूपम् n) (घन-रूपम् n)
  ∙ लयः (pos (suc n)) (μ n)
  ∙ cong₂ _·_ (sym (pos·pos (suc n) (suc n))) (μ-वर्गः n)
  ∙ ·IdR (pos (suc n ·ℕ suc n))
  where
    -- (x·y)·(x·y) ≡ (x·x)·(y·y), commutative shuffle
    लयः : (x y : ℤ) → (x · y) · (x · y) ≡ (x · x) · (y · y)
    लयः x y =
      sym (·Assoc x y (x · y))
      ∙ cong (x ·_) ( ·Assoc y x y
                    ∙ cong (_· y) (·Comm y x)
                    ∙ sym (·Assoc x y y) )
      ∙ ·Assoc x x (y · y)
