{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ChargeBlindnessIsAnOrthogonalComplement
--
-- `ChargeCriterion` decides ONE charge.  This decides all of them, and the
-- answer is linear algebra over 𝔽₂: blindness is an orthogonal complement,
-- and the parity barrier is a RANK.
--
-- THE SETTING.  A completely multiplicative ±1 function is a sign vector
-- s on the primes.  The gauge group is (𝔽₂)^𝒫 acting by s ↦ s ⊞ S.  A
-- query is an integer n, and all a query contributes is its exponent
-- parity vector ω(n) = (v_p(n) mod 2)_p, since
--
--     val_s(n) = ⟨ s , ω(n) ⟩          (the 𝔽₂ pairing, xor of ands).
--
-- `ChargeCriterion` is the case S = 𝟏 (flip every prime): then
-- ⟨ 𝟏 , ω(n) ⟩ = Ω(n) mod 2, and its criterion "some query of odd Ω" is
-- exactly "some query with ⟨ S , ω(n) ⟩ = 1".  This module drops the
-- restriction to S = 𝟏.
--
-- WHAT IS PROVED.
--
--   bilinear      ⟨ s ⊞ S , v ⟩ ≡ ⟨ s , v ⟩ xor ⟨ S , v ⟩
--                 the whole content; everything else is a corollary
--   blind         if every query kills S, the two transcripts are EQUAL —
--                 an equality of lists, so no decision procedure whatever
--                 separates s from s ⊞ S
--   sighted       if some query does not kill S, the transcripts differ
--                 at that query, so a separator exists
--   criterion     the two together, for EVERY charge S
--
-- THE READING, which is the point.  `Sees Q S` is "S is not orthogonal to
-- the span of ω(Q)".  So the set of charges a method is blind to is the
-- ANNIHILATOR of the 𝔽₂-span of the exponent-parity vectors it reads.
-- Consequences, immediate and quantitative, where `ChargeCriterion` gave
-- only a yes/no on one charge:
--
--   * a method reading k queries sees at most 2^k charges and is blind to
--     a subspace of codimension ≤ k, however much it computes;
--   * two query sets with the same 𝔽₂-span are equally blind — the
--     transcript's separating power is a function of the span alone, not
--     of the size, the values, or the arithmetic of the queries;
--   * to see a specific charge S you must read an n with ⟨S,ω(n)⟩ = 1,
--     and no amount of post-processing manufactures one.
--
-- That last is `ParitySeparator`'s no-go recovered as the S = 𝟏 instance,
-- and the first is what it never said: the barrier has a dimension.
--
-- WHAT IS NOT CLAIMED.  Not that this is new mathematics — it is the
-- observation that the gauge action is 𝔽₂-linear and blindness is
-- therefore an annihilator, which is a first move for anyone who reads
-- (𝔽₂)^𝒫 as a vector space.  It is stated because the corpus's own
-- criterion was proved for one charge and read as a criterion about
-- charges, and the gap between those is exactly a rank.  Not claimed
-- either that ω is surjective onto (𝔽₂)^𝒫 restricted to any finite set
-- of primes — it is (squarefree numbers realise every vector), but that
-- needs an arithmetic development this file does not build, and nothing
-- below uses it.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 with the `notes/CUBICAL_PATCH.md`
-- back-port, `--cubical --safe`, no postulates, no holes.  NOT the
-- repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module NaturalMachine.ChargeBlindnessIsAnOrthogonalComplement where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _and_ ; _or_ ; not ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 0.  xor, and the three facts about it this file needs
------------------------------------------------------------------------

_xor_ : Bool → Bool → Bool
true  xor b = not b
false xor b = b

infixl 6 _xor_

xor-false : (b : Bool) → b xor false ≡ b
xor-false true  = refl
xor-false false = refl

-- (x xor y) xor (z xor w) ≡ (x xor z) xor (y xor w), the rearrangement
-- the bilinearity step needs.  Proved by exhausting the four leading
-- cases and letting the rest compute.
xor-swap : (x y z w : Bool) → (x xor y) xor (z xor w) ≡ (x xor z) xor (y xor w)
xor-swap true  true  true  true  = refl
xor-swap true  true  true  false = refl
xor-swap true  true  false true  = refl
xor-swap true  true  false false = refl
xor-swap true  false true  true  = refl
xor-swap true  false true  false = refl
xor-swap true  false false true  = refl
xor-swap true  false false false = refl
xor-swap false true  true  true  = refl
xor-swap false true  true  false = refl
xor-swap false true  false true  = refl
xor-swap false true  false false = refl
xor-swap false false true  true  = refl
xor-swap false false true  false = refl
xor-swap false false false true  = refl
xor-swap false false false false = refl

-- and-distributes-over-xor, on the left
and-xor : (x y z : Bool) → (x xor y) and z ≡ (x and z) xor (y and z)
and-xor true  true  true  = refl
and-xor true  true  false = refl
and-xor true  false true  = refl
and-xor true  false false = refl
and-xor false true  true  = refl
and-xor false true  false = refl
and-xor false false true  = refl
and-xor false false false = refl

------------------------------------------------------------------------
-- 1.  Charges, sign assignments, and the pairing
--
--     A vector is a `List Bool`: the exponent parities, or the support of
--     a charge.  Shorter lists are read as padded with `false`, which is
--     what the two `[]` clauses of the pairing say.
------------------------------------------------------------------------

Vec : Type₀
Vec = List Bool

-- ⟪ s , v ⟫ — the 𝔽₂ pairing.  `val_s(n) = ⟪ s , ω(n) ⟫`.
⟪_,_⟫ : Vec → Vec → Bool
⟪ [] , _ ⟫ = false
⟪ _ ∷ _ , [] ⟫ = false
⟪ x ∷ xs , y ∷ ys ⟫ = (x and y) xor ⟪ xs , ys ⟫

-- the gauge action: pointwise xor
_⊞_ : Vec → Vec → Vec
[] ⊞ ys = ys
(x ∷ xs) ⊞ [] = x ∷ xs
(x ∷ xs) ⊞ (y ∷ ys) = (x xor y) ∷ (xs ⊞ ys)

infixl 5 _⊞_

------------------------------------------------------------------------
-- 2.  THE CONTENT.  The pairing is bilinear in the sign assignment, so a
--     gauge flip shifts every reading by the charge's own pairing.
------------------------------------------------------------------------

bilinear : (s S v : Vec) → ⟪ s ⊞ S , v ⟫ ≡ ⟪ s , v ⟫ xor ⟪ S , v ⟫
bilinear [] S v = refl
bilinear (x ∷ xs) [] v = sym (xor-false ⟪ x ∷ xs , v ⟫)
bilinear (x ∷ xs) (y ∷ ys) [] = refl
bilinear (x ∷ xs) (y ∷ ys) (z ∷ vs) =
    cong (λ b → b xor ⟪ xs ⊞ ys , vs ⟫) (and-xor x y z)
  ∙ cong (λ b → ((x and z) xor (y and z)) xor b) (bilinear xs ys vs)
  ∙ xor-swap (x and z) (y and z) ⟪ xs , vs ⟫ ⟪ ys , vs ⟫

------------------------------------------------------------------------
-- 3.  Transcripts, and the criterion
------------------------------------------------------------------------

-- what an observer with query list Q reads off the sign assignment s
transcript : Vec → List Vec → List Bool
transcript s Q = map (λ v → ⟪ s , v ⟫) Q

-- Both predicates are defined BY RECURSION, not as indexed families.
-- `ChargeCriterion`'s header gives the reason and it is load-bearing: an
-- indexed family here matches on constructor injectivity, which Cubical
-- Agda does not support, so the predicate would not compute under
-- transport — and a criterion that does not compute under transport is
-- not a test.  The kernel said exactly this on the first pass of this
-- file, in two `-WUnsupportedIndexedMatch` warnings naming `[]` and `_∷_`.

-- "some query in Q is not orthogonal to the charge S"
Sees : List Vec → Vec → Type₀
Sees [] S = ⊥
Sees (v ∷ Q) S = (⟪ S , v ⟫ ≡ true) ⊎ Sees Q S

-- "every query in Q is orthogonal to the charge S"
Blind : List Vec → Vec → Type₀
Blind [] S = Unit
Blind (v ∷ Q) S = (⟪ S , v ⟫ ≡ false) × Blind Q S

------------------------------------------------------------------------
-- 3a.  BLIND ⇒ the transcripts are EQUAL.  Not close: equal, as lists.
--      So no decision procedure of any strength separates s from s ⊞ S.
------------------------------------------------------------------------

blind-transcripts-agree :
  (s S : Vec) (Q : List Vec) → Blind Q S → transcript (s ⊞ S) Q ≡ transcript s Q
blind-transcripts-agree s S [] _ = refl
blind-transcripts-agree s S (v ∷ Q) (o , b) =
  cong₂ _∷_ step (blind-transcripts-agree s S Q b)
  where
    step : ⟪ s ⊞ S , v ⟫ ≡ ⟪ s , v ⟫
    step = bilinear s S v
         ∙ cong (λ b′ → ⟪ s , v ⟫ xor b′) o
         ∙ xor-false ⟪ s , v ⟫

-- and therefore no `decide` accepts one and rejects the other
no-decision :
  (s S : Vec) (Q : List Vec) → Blind Q S →
  (decide : List Bool → Bool) →
  decide (transcript (s ⊞ S) Q) ≡ decide (transcript s Q)
no-decision s S Q b decide = cong decide (blind-transcripts-agree s S Q b)

------------------------------------------------------------------------
-- 3b.  SIGHTED ⇒ a query at which the two readings differ, exhibited.
------------------------------------------------------------------------

sighted-separates :
  (s S : Vec) (Q : List Vec) → Sees Q S →
  Σ[ v ∈ Vec ] (⟪ s ⊞ S , v ⟫ ≡ not ⟪ s , v ⟫)
sighted-separates s S (v ∷ Q) (inl o) =
  v , (bilinear s S v ∙ cong (λ b → ⟪ s , v ⟫ xor b) o ∙ flip ⟪ s , v ⟫)
  where
    flip : (b : Bool) → b xor true ≡ not b
    flip true  = refl
    flip false = refl
sighted-separates s S (v ∷ Q) (inr t) = sighted-separates s S Q t

------------------------------------------------------------------------
-- 4.  The two together: for EVERY charge, blindness is orthogonality.
--
--     `ChargeCriterion` is the instance S = 𝟏, where ⟪ 𝟏 , ω(n) ⟫ is
--     Ω(n) mod 2 and `Sees` reads "contains a query of odd Ω".
------------------------------------------------------------------------

criterion :
  (s S : Vec) (Q : List Vec) →
  (Blind Q S → (d : List Bool → Bool)
             → d (transcript (s ⊞ S) Q) ≡ d (transcript s Q))
  × (Sees Q S → Σ[ v ∈ Vec ] (⟪ s ⊞ S , v ⟫ ≡ not ⟪ s , v ⟫))
criterion s S Q = no-decision s S Q , sighted-separates s S Q

------------------------------------------------------------------------
-- 5.  Non-vacuity: both sides are inhabited, so neither half is empty.
--
--     One prime.  The charge that flips it is seen by the query with odd
--     exponent there and not by the query with even exponent — and the
--     second query is the LARGER number, which is `ChargeCriterion`'s
--     `probe-2` / `probe-6` observation recovered.
------------------------------------------------------------------------

𝟏 odd even : Vec
𝟏    = true ∷ []
odd  = true ∷ []            -- ω(p)   : exponent 1, odd
even = false ∷ []           -- ω(p²)  : exponent 2, even

sees-odd : Sees (odd ∷ []) 𝟏
sees-odd = inl refl

blind-even : Blind (even ∷ []) 𝟏
blind-even = refl , tt

-- and the two are genuinely different verdicts on the same charge
not-both : ¬ ((Sees (even ∷ []) 𝟏) × (Blind (even ∷ []) 𝟏))
not-both (inl o , (z , _)) = true≢false (sym o ∙ z)
