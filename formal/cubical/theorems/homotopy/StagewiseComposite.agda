{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- StagewiseComposite
--
-- The two-valued composite-defect theorem, and its sharp boundary.
--
-- Setting.  For a type R of response values with decidable equality,
-- write ind a b : Bool for the indicator of a ≢ b.  A composable pair of
-- observer revisions produces, pointwise, a span (a , b , c) : R³, whose
-- two STAGEWISE defects are ind a b and ind b c and whose COMPOSITE
-- defect is ind a c.  The stagewise family DETERMINES the composite iff
-- there is a single decoder f : Bool → Bool → Bool with
-- f (ind a b) (ind b c) ≡ ind a c for every span.  This is the decoder
-- formulation: a rule that works for every span, not for one span.
--
-- HYPOTHESES, named in full (nothing else is assumed):
--   * R is an arbitrary type at an arbitrary universe level.
--   * R carries `Discrete R` (decidable equality).  This is the only
--     hypothesis; in particular NO set-truncation and NO finiteness is
--     assumed — `Discrete R` already forces `isSet R` (Hedberg), and that
--     is used nowhere below.
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  1. xorAddBool          For a b c : Bool, ind a c = ind a b ⊕ ind b c,
--                         where ind = xor is the Z/2 inequality
--                         indicator: exhaustive, eight cases by refl.
--     indBool≡ind         ... and that hand-written indicator agrees with
--                         the generic decidable-equality one.
--
--  2. threeFails          At three values additivity fails by COMPUTATION:
--     threeStagewise/     the span (t0 , t1 , t2) has both stagewise
--     threeComposite      defects true and composite defect true, while
--                         true ⊕ true = false.
--     ¬DeterminesThree    ... and no decoder whatever exists over a
--                         three-element type.
--
--  3. THE GENERAL THEOREM, both directions closed.  For (R , d) with
--     decidable equality, define
--
--       TwoValued R = every triple contains a repeat
--                     ((a b c : R) → (a ≡ b) ⊎ (b ≡ c) ⊎ (a ≡ c))
--
--     — the constructive rendering of |R| ≤ 2 for a discrete type.  Then
--
--       twoValued→Determines : TwoValued R → Determines R d
--       Determines→twoValued : Determines R d → TwoValued R
--       determinesIffTwoValued : the two implications packaged.
--
--     So the codomains over which the stagewise family determines the
--     composite are EXACTLY the ones with at most two inhabitants, and
--     over those the decoder is xor.  (Uniqueness of the decoder on the
--     reachable fibers is `decoderUnique…` below.)
--
--  4. Neither direction needs the cardinality of R to be finite: the
--     forward direction is the fiberwise argument and the backward one
--     produces a two-value repeat from an arbitrary triple.
------------------------------------------------------------------------

module StagewiseComposite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; predℕ ; znots)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_ ; fst)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import Cubical.Data.Empty as ⊥ using (⊥)

private
  variable
    ℓ ℓ' : Level
    R : Type ℓ

------------------------------------------------------------------------
-- 0.  Z/2, written as Bool
------------------------------------------------------------------------

-- Addition in Z/2.
_⊕_ : Bool → Bool → Bool
false ⊕ b = b
true  ⊕ false = true
true  ⊕ true  = false

infixl 6 _⊕_

------------------------------------------------------------------------
-- 1.  The inequality indicator of a discrete type
------------------------------------------------------------------------

private
  isNo : {A : Type ℓ} → Dec A → Bool
  isNo (yes _) = false
  isNo (no  _) = true

-- ind d a b = 1 iff a ≠ b.
ind : Discrete R → R → R → Bool
ind d a b = isNo (d a b)

-- The two facts about `ind` that every proof below uses.  They are stated
-- and proved WITHOUT `with`, so that no with-abstraction ever touches a
-- goal mentioning `d a b`; `Dec` is eliminated by its recursor instead.
private
  decRec : {A : Type ℓ} {B : Type ℓ'} → (A → B) → (¬ A → B) → Dec A → B
  decRec f g (yes p) = f p
  decRec f g (no ¬p) = g ¬p

ind-eq : (d : Discrete R) {a b : R} → a ≡ b → ind d a b ≡ false
ind-eq d {a} {b} p = lemma (d a b)
  where
    lemma : (t : Dec (a ≡ b)) → isNo t ≡ false
    lemma (yes _) = refl
    lemma (no ¬p) = ⊥.rec (¬p p)

ind-neq : (d : Discrete R) {a b : R} → ¬ (a ≡ b) → ind d a b ≡ true
ind-neq d {a} {b} ¬p = lemma (d a b)
  where
    lemma : (t : Dec (a ≡ b)) → isNo t ≡ true
    lemma (yes p) = ⊥.rec (¬p p)
    lemma (no  _) = refl

------------------------------------------------------------------------
-- 2.  The two properties, as types
------------------------------------------------------------------------

-- A decoder: one function of the two stagewise defects that returns the
-- composite defect, for EVERY span.
Determines : (R : Type ℓ) → Discrete R → Type ℓ
Determines R d =
  Σ[ f ∈ (Bool → Bool → Bool) ]
    ((a b c : R) → f (ind d a b) (ind d b c) ≡ ind d a c)

-- "At most two inhabitants", constructively: any three elements contain a
-- repeated pair.  For a discrete type this is the right rendering of
-- |R| ≤ 2 (it is exactly the failure of a pairwise-distinct triple).
TwoValued : Type ℓ → Type ℓ
TwoValued R = (a b c : R) → (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c))

------------------------------------------------------------------------
-- 3.  Forward direction:  at most two values  ⟹  xor is a decoder
------------------------------------------------------------------------

-- The Z/2 additivity law, in the generality it actually holds.
xorAdd : (d : Discrete R) → TwoValued R
       → (a b c : R) → ind d a b ⊕ ind d b c ≡ ind d a c
xorAdd d tv a b c =
  decRec
    (λ p → decRec (λ q → caseYY p q) (λ ¬q → caseYN p ¬q) (d b c))
    (λ ¬p → decRec (λ q → caseNY ¬p q) (λ ¬q → caseNN ¬p ¬q) (d b c))
    (d a b)
  where
    -- a = b, b = c: no defect anywhere.  0 ⊕ 0 = 0.
    caseYY : a ≡ b → b ≡ c → ind d a b ⊕ ind d b c ≡ ind d a c
    caseYY p q =
      cong₂ _⊕_ (ind-eq d p) (ind-eq d q) ∙ sym (ind-eq d (p ∙ q))

    -- a = b, b ≠ c: then a ≠ c.  0 ⊕ 1 = 1.
    caseYN : a ≡ b → ¬ (b ≡ c) → ind d a b ⊕ ind d b c ≡ ind d a c
    caseYN p ¬q =
      cong₂ _⊕_ (ind-eq d p) (ind-neq d ¬q)
        ∙ sym (ind-neq d (λ r → ¬q (sym p ∙ r)))

    -- a ≠ b, b = c: then a ≠ c.  1 ⊕ 0 = 1.
    caseNY : ¬ (a ≡ b) → b ≡ c → ind d a b ⊕ ind d b c ≡ ind d a c
    caseNY ¬p q =
      cong₂ _⊕_ (ind-neq d ¬p) (ind-eq d q)
        ∙ sym (ind-neq d (λ r → ¬p (r ∙ sym q)))

    -- a ≠ b, b ≠ c: the ONLY fiber where the sandwich A △ B ⊆ D ⊆ A ∪ B
    -- leaves room, and the only place the hypothesis is used.  With at
    -- most two values a ≠ b and b ≠ c force a = c.  1 ⊕ 1 = 0.
    caseNN : ¬ (a ≡ b) → ¬ (b ≡ c) → ind d a b ⊕ ind d b c ≡ ind d a c
    caseNN ¬p ¬q = step (tv a b c)
      where
        step : (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c))
             → ind d a b ⊕ ind d b c ≡ ind d a c
        step (inl p)       = ⊥.rec (¬p p)
        step (inr (inl q)) = ⊥.rec (¬q q)
        step (inr (inr r)) =
          cong₂ _⊕_ (ind-neq d ¬p) (ind-neq d ¬q) ∙ sym (ind-eq d r)

twoValued→Determines : (d : Discrete R) → TwoValued R → Determines R d
twoValued→Determines d tv = _⊕_ , xorAdd d tv

------------------------------------------------------------------------
-- 4.  Backward direction:  a decoder exists  ⟹  at most two values
------------------------------------------------------------------------

-- The engine: a pairwise-distinct triple defeats every decoder, because
-- the spans (a , b , a) and (a , b , c) share their stagewise summary
-- (1,1) and differ in their composite.
noDecoderAtDistinctTriple :
    (d : Discrete R) → Determines R d
  → {a b c : R} → ¬ (a ≡ b) → ¬ (b ≡ c) → ¬ (a ≡ c) → ⊥
noDecoderAtDistinctTriple d (f , eq) {a} {b} {c} ¬ab ¬bc ¬ac =
  false≢true (sym atCancellation ∙ atPersistence)
  where
    -- span (a , b , a): stagewise (1,1), composite 0.
    atCancellation : f true true ≡ false
    atCancellation =
      sym (cong₂ f (ind-neq d ¬ab) (ind-neq d (λ q → ¬ab (sym q))))
        ∙ eq a b a
        ∙ ind-eq d refl

    -- span (a , b , c): stagewise (1,1), composite 1.
    atPersistence : f true true ≡ true
    atPersistence =
      sym (cong₂ f (ind-neq d ¬ab) (ind-neq d ¬bc))
        ∙ eq a b c
        ∙ ind-neq d ¬ac

Determines→twoValued : (d : Discrete R) → Determines R d → TwoValued R
Determines→twoValued d D a b c =
  decRec
    inl
    (λ ¬ab → decRec
       (λ q → inr (inl q))
       (λ ¬bc → decRec
          (λ r → inr (inr r))
          (λ ¬ac → ⊥.rec (noDecoderAtDistinctTriple d D ¬ab ¬bc ¬ac))
          (d a c))
       (d b c))
    (d a b)

-- The theorem, packaged.  Determination over a discrete codomain is
-- EXACTLY the two-value condition, in both directions.
determinesIffTwoValued :
    (d : Discrete R)
  → (TwoValued R → Determines R d) × ((Determines R d) → TwoValued R)
determinesIffTwoValued d = twoValued→Determines d , Determines→twoValued d

------------------------------------------------------------------------
-- 5.  Uniqueness of the decoder
------------------------------------------------------------------------

-- On a two-valued codomain with two distinct elements every argument of
-- the decoder except (1,1) is realized, and (1,1) is unrealizable; so any
-- decoder agrees with xor wherever it is tested.  Concretely: a decoder
-- is pinned at the three reachable summaries.
decoderPinned :
    (d : Discrete R) (D : Determines R d) {x y : R} → ¬ (x ≡ y)
  → (fst D false false ≡ false)
  × ((fst D true false ≡ true) × (fst D false true ≡ true))
decoderPinned d (f , eq) {x} {y} ¬xy =
    ( sym (cong₂ f (ind-eq d refl) (ind-eq d refl)) ∙ eq x x x ∙ ind-eq d refl
    , ( sym (cong₂ f (ind-neq d ¬xy) (ind-eq d refl)) ∙ eq x y y ∙ ind-neq d ¬xy
      , sym (cong₂ f (ind-eq d refl) (ind-neq d ¬xy)) ∙ eq x x y ∙ ind-neq d ¬xy
      )
    )

------------------------------------------------------------------------
-- 6.  Two values: Bool, by exhaustive case analysis
------------------------------------------------------------------------

discreteBool' : Discrete Bool
discreteBool' true  true  = yes refl
discreteBool' false false = yes refl
discreteBool' true  false = no (λ p → false≢true (sym p))
discreteBool' false true  = no false≢true

-- The hand-written indicator on Bool: inequality IS addition in Z/2.
indBool : Bool → Bool → Bool
indBool a b = a ⊕ b

-- (1) The Z/2 additivity law, eight cases, every one by refl.
xorAddBool : (a b c : Bool) → indBool a b ⊕ indBool b c ≡ indBool a c
xorAddBool false false false = refl
xorAddBool false false true  = refl
xorAddBool false true  false = refl
xorAddBool false true  true  = refl
xorAddBool true  false false = refl
xorAddBool true  false true  = refl
xorAddBool true  true  false = refl
xorAddBool true  true  true  = refl

-- ... and it is the same indicator as the generic one.
indBool≡ind : (a b : Bool) → indBool a b ≡ ind discreteBool' a b
indBool≡ind false false = refl
indBool≡ind false true  = refl
indBool≡ind true  false = refl
indBool≡ind true  true  = refl

twoValuedBool : TwoValued Bool
twoValuedBool true  true  _     = inl refl
twoValuedBool false false _     = inl refl
twoValuedBool true  false true  = inr (inr refl)
twoValuedBool true  false false = inr (inl refl)
twoValuedBool false true  true  = inr (inl refl)
twoValuedBool false true  false = inr (inr refl)

-- Bool is determined, by the general theorem.
determinesBool : Determines Bool discreteBool'
determinesBool = twoValued→Determines discreteBool' twoValuedBool

------------------------------------------------------------------------
-- 7.  Three values: the counterexample, by computation
------------------------------------------------------------------------

-- A three-element type, defined here rather than imported so that the
-- distinctness of its points is a term of this file and nothing turns on
-- a library presentation of Fin 3.
data Three : Type where
  t0 t1 t2 : Three

num : Three → ℕ
num t0 = 0
num t1 = 1
num t2 = 2

t0≢t1 : ¬ (t0 ≡ t1)
t0≢t1 p = znots (cong num p)

t1≢t2 : ¬ (t1 ≡ t2)
t1≢t2 p = znots (cong predℕ (cong num p))

t0≢t2 : ¬ (t0 ≡ t2)
t0≢t2 p = znots (cong num p)

discreteThree : Discrete Three
discreteThree t0 t0 = yes refl
discreteThree t1 t1 = yes refl
discreteThree t2 t2 = yes refl
discreteThree t0 t1 = no t0≢t1
discreteThree t1 t0 = no (λ p → t0≢t1 (sym p))
discreteThree t0 t2 = no t0≢t2
discreteThree t2 t0 = no (λ p → t0≢t2 (sym p))
discreteThree t1 t2 = no t1≢t2
discreteThree t2 t1 = no (λ p → t1≢t2 (sym p))

-- (2) The explicit span (t0 , t1 , t2): both stagewise defects and the
-- composite defect are all `true`, by computation.
threeStagewise₁ : ind discreteThree t0 t1 ≡ true
threeStagewise₁ = refl

threeStagewise₂ : ind discreteThree t1 t2 ≡ true
threeStagewise₂ = refl

threeComposite : ind discreteThree t0 t2 ≡ true
threeComposite = refl

-- Additivity therefore fails at three values: 1 ⊕ 1 = 0 ≠ 1.
threeFails :
  ¬ (ind discreteThree t0 t1 ⊕ ind discreteThree t1 t2
       ≡ ind discreteThree t0 t2)
threeFails p = false≢true p

-- The companion span (t0 , t1 , t0): same stagewise summary, composite 0.
threeCancellation : ind discreteThree t0 t0 ≡ false
threeCancellation = refl

-- (2') Stronger, and the statement that actually matters: NO decoder at
-- all exists over Three — not merely that xor fails.
¬DeterminesThree : ¬ (Determines Three discreteThree)
¬DeterminesThree D =
  noDecoderAtDistinctTriple discreteThree D t0≢t1 t1≢t2 t0≢t2

-- Equivalently, via the general theorem: Three is not two-valued.
¬TwoValuedThree : ¬ (TwoValued Three)
¬TwoValuedThree tv = step (tv t0 t1 t2)
  where
    step : (t0 ≡ t1) ⊎ ((t1 ≡ t2) ⊎ (t0 ≡ t2)) → ⊥
    step (inl p)       = t0≢t1 p
    step (inr (inl q)) = t1≢t2 q
    step (inr (inr r)) = t0≢t2 r
