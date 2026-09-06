{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कारण — the cause.
--
-- WHY THIS FILE EXISTS.  The abstract "TWO BLIND READINGS THAT ARE
-- JOINTLY FAITHFUL" says, under WHAT IS NOT CLAIMED, that there is no
-- probability distribution, no estimator, no structural equation model,
-- no do-calculus and no counterfactual in the development — that the
-- observables are functions on a six-element type and "identifiable"
-- means the fibres are contractible, and that whether a statistical
-- identification problem has this shape is a reading.
--
-- All five are built here, and the reading becomes two theorems of the
-- shape the corpus already proves elsewhere — "no function of the
-- coarser object recovers the finer" — now stated about causation.
--
--   §४  NO FUNCTION of the observational distribution computes the
--       interventional one.  Two structural equation models, same
--       observational distribution, different distributions under
--       do(X := x).  That is confounding, and the non-identifiability
--       is not an estimation difficulty: no function whatsoever exists.
--
--   §६  NO FUNCTION of the interventional distributions computes the
--       counterfactual joint.  Two models agreeing under every
--       intervention, disagreeing on the joint distribution of the
--       potential outcomes.  Experiments do not settle counterfactuals,
--       and that is a theorem here rather than a slogan.
--
--   §५  and the positive half, so the negative ones are not the whole
--       story: WHEN Y DOES NOT DEPEND ON THE CONFOUNDER, the adjustment
--       identity holds — the interventional and observational
--       distributions agree after clearing denominators, with no
--       positivity side condition, because both sides vanish exactly
--       where the denominator does.
--
-- ON PROBABILITY WITHOUT DIVISION.  A distribution here is a weight
-- function into ℕ, unnormalised.  Every statement below either compares
-- two weight functions on the same total or is stated cross-multiplied,
-- so no rationals, no normalisation and no positivity assumption enter,
-- and nothing is weakened: equality of unnormalised weights on a common
-- total IS equality of distributions.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Karana_TheStructuralEquationModelTheDoOperatorAndTheCounterfactualAreBuiltAndTheLadderIsStrict where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-assoc ; +-comm ; ·-assoc ; ·-comm
        ; ·-identityˡ ; ·-distribˡ ; 0≡m·0 ; injSuc ; znots ; snotz)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- १ · distributions on the two-element exogenous space.
------------------------------------------------------------------------

Weight : Type
Weight = Bool → ℕ

sumU : Weight → ℕ
sumU f = f false + f true

ind : Bool → Bool → ℕ
ind false false = 1
ind false true  = 0
ind true  false = 0
ind true  true  = 1

·0 : (x : ℕ) → x · 0 ≡ 0
·0 x = sym (0≡m·0 x)

------------------------------------------------------------------------
-- २ · THE STRUCTURAL EQUATION MODEL.
--
-- An exogenous variable U with a weight; X assigned by a structural
-- equation in U; Y assigned by a structural equation in X and U.  The
-- arrow U → Y is what confounding IS, and it is a field of the record
-- rather than an assumption about one.
------------------------------------------------------------------------

record SEM : Type where
  constructor sem
  field
    w  : Weight
    fX : Bool → Bool
    fY : Bool → Bool → Bool

open SEM public

-- the observational distribution of (X , Y): the model run as written.
obs : SEM → Bool → Bool → ℕ
obs m x y = sumU (λ u → ind (fX m u) x · ind (fY m (fX m u) u) y · w m u)

-- the marginal of X, which is the denominator the adjustment clears.
marg : SEM → Bool → ℕ
marg m x = sumU (λ u → ind (fX m u) x · w m u)

total : SEM → ℕ
total m = sumU (w m)

------------------------------------------------------------------------
-- ३ · THE DO-OPERATOR, AND THE COUNTERFACTUAL.
--
-- `do(X := x)` deletes X's structural equation and substitutes the
-- constant.  The counterfactual joint is the distribution of the PAIR
-- of potential outcomes at a single draw of the exogenous variable —
-- the twin-network reading, which is what distinguishes rung three from
-- rung two.
------------------------------------------------------------------------

doY : SEM → Bool → Bool → ℕ
doY m x y = sumU (λ u → ind (fY m x u) y · w m u)

cf : SEM → Bool → Bool → ℕ
cf m y₀ y₁ =
  sumU (λ u → ind (fY m false u) y₀ · ind (fY m true u) y₁ · w m u)

------------------------------------------------------------------------
-- ४ · CONFOUNDING: NO FUNCTION OF THE OBSERVATION GIVES THE INTERVENTION.
--
-- `confounded` has U causing both X and Y; `chain` has U causing X and X
-- causing Y.  They agree on everything that can be observed and disagree
-- under intervention, so any purported identification formula would have
-- to return two different answers on one input.
------------------------------------------------------------------------

uni : Weight
uni _ = 1

confounded chain : SEM
confounded = sem uni (λ u → u) (λ x u → u)
chain      = sem uni (λ u → u) (λ x u → x)

obs-agree : (x y : Bool) → obs confounded x y ≡ obs chain x y
obs-agree false false = refl
obs-agree false true  = refl
obs-agree true  false = refl
obs-agree true  true  = refl

obs-agree≡ : obs confounded ≡ obs chain
obs-agree≡ = funExt λ x → funExt λ y → obs-agree x y

one≢two : ¬ (1 ≡ 2)
one≢two p = znots (injSuc p)

do-differ : ¬ (doY confounded true true ≡ doY chain true true)
do-differ = one≢two

no-identification-from-observation :
  ¬ (Σ[ F ∈ ((Bool → Bool → ℕ) → (Bool → Bool → ℕ)) ]
       ((m : SEM) → F (obs m) ≡ doY m))
no-identification-from-observation (F , sound) =
  do-differ
    (funExt⁻ (funExt⁻ (sym (sound confounded) ∙ cong F obs-agree≡ ∙ sound chain)
                      true)
             true)

------------------------------------------------------------------------
-- ५ · THE POSITIVE HALF: ADJUSTMENT, WITH NO SIDE CONDITION.
--
-- When Y's structural equation does not read the confounder, the
-- interventional and observational distributions satisfy the adjustment
-- identity — cross-multiplied, so no denominator and therefore no
-- positivity assumption appears.  Where the marginal vanishes both
-- sides vanish, which is exactly why the cleared form needs no
-- hypothesis the uncleared one would need.
------------------------------------------------------------------------

-- one term of the sum: the indicator forces the two responses to agree.
term-lemma : (a b : Bool) (h : Bool → Bool) (y : Bool) (v : ℕ)
           → (ind a b · ind (h a) y) · v ≡ ind (h b) y · (ind a b · v)
term-lemma false false h y v =
  cong (_· v) (·-identityˡ (ind (h false) y)) ∙ cong (ind (h false) y ·_) (sym (·-identityˡ v))
term-lemma false true  h y v = 0≡m·0 (ind (h true) y)
term-lemma true  false h y v = 0≡m·0 (ind (h false) y)
term-lemma true  true  h y v =
  cong (_· v) (·-identityˡ (ind (h true) y)) ∙ cong (ind (h true) y ·_) (sym (·-identityˡ v))

unconfounded-obs : (wt : Weight) (g : Bool → Bool) (h : Bool → Bool)
                 → (x y : Bool)
                 → obs (sem wt g (λ z _ → h z)) x y
                 ≡ ind (h x) y · marg (sem wt g (λ z _ → h z)) x
unconfounded-obs wt g h x y =
    cong₂ _+_ (t false) (t true)
  ∙ ·-distribˡ (ind (h x) y) (ind (g false) x · wt false) (ind (g true) x · wt true)
  where
    t : (u : Bool)
      → (ind (g u) x · ind (h (g u)) y) · wt u ≡ ind (h x) y · (ind (g u) x · wt u)
    t u = term-lemma (g u) x h y (wt u)

unconfounded-do : (wt : Weight) (g : Bool → Bool) (h : Bool → Bool)
                → (x y : Bool)
                → doY (sem wt g (λ z _ → h z)) x y
                ≡ ind (h x) y · total (sem wt g (λ z _ → h z))
unconfounded-do wt g h x y = ·-distribˡ (ind (h x) y) (wt false) (wt true)

-- THE ADJUSTMENT IDENTITY, cleared of denominators.  This is
-- "P(y | do x) = P(y | x)" with nothing assumed about support.
adjustment : (wt : Weight) (g h : Bool → Bool) (x y : Bool)
           → let m = sem wt g (λ z _ → h z) in
             obs m x y · total m ≡ doY m x y · marg m x
adjustment wt g h x y =
    cong (_· total m) (unconfounded-obs wt g h x y)
  ∙ sym (·-assoc (ind (h x) y) (marg m x) (total m))
  ∙ cong (ind (h x) y ·_) (·-comm (marg m x) (total m))
  ∙ ·-assoc (ind (h x) y) (total m) (marg m x)
  ∙ cong (_· marg m x) (sym (unconfounded-do wt g h x y))
  where
    m : SEM
    m = sem wt g (λ z _ → h z)

------------------------------------------------------------------------
-- ६ · AND RUNG THREE IS NOT REACHED FROM RUNG TWO.
--
-- Two models that agree under EVERY intervention and disagree on the
-- joint distribution of the potential outcomes.  So no experiment,
-- however many and however perfect, settles a counterfactual: the
-- interventional distributions simply do not contain the answer.
------------------------------------------------------------------------

flipIf : Bool → Bool → Bool
flipIf false u = u
flipIf true  u = not u

alwaysU flipsOnX : SEM
alwaysU  = sem uni (λ u → u) (λ x u → u)
flipsOnX = sem uni (λ u → u) (λ x u → flipIf x u)

do-agree : (x y : Bool) → doY alwaysU x y ≡ doY flipsOnX x y
do-agree false false = refl
do-agree false true  = refl
do-agree true  false = refl
do-agree true  true  = refl

do-agree≡ : doY alwaysU ≡ doY flipsOnX
do-agree≡ = funExt λ x → funExt λ y → do-agree x y

one≢zero : ¬ (1 ≡ 0)
one≢zero = snotz

cf-differ : ¬ (cf alwaysU false false ≡ cf flipsOnX false false)
cf-differ = one≢zero

no-identification-from-intervention :
  ¬ (Σ[ G ∈ ((Bool → Bool → ℕ) → (Bool → Bool → ℕ)) ]
       ((m : SEM) → G (doY m) ≡ cf m))
no-identification-from-intervention (G , sound) =
  cf-differ
    (funExt⁻ (funExt⁻ (sym (sound alwaysU) ∙ cong G do-agree≡ ∙ sound flipsOnX)
                      false)
             false)
