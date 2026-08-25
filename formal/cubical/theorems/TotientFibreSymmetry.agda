{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Two theorems about the open item in
-- `notes/LEAKAGE_LANDINGS_WERE_ALREADY_NAMED.md` §4 / ledger row B4: whether the
-- totient-fibre collapse arises from a *transitive* group action (Theorem E,
-- msg 0250), with the group on the divisors "exhibited by nobody yet".
--
--   Theorem T (§3).  For ANY observation on a discrete type, a group acts
--   transitively on each of its fibres: the observational stabilizer itself.
--   So the exhibition asked for always exists, for every index whatsoever, and
--   an existentially quantified group separates nothing.
--
--   Theorem R (§4).  Pin the group to the chart the compressed object lives in
--   — the multiplicative chart, whose automorphism group is the permutation
--   group of the prime generators (`notes/ATLAS_OF_N.md` Thm 2.13(1), CITED) —
--   and the totient's stabilizer is TRIVIAL.  Not "not transitive": trivial.
--
-- §6 exhibits the obstruction at the point `notes/ATLAS_OF_N.md` predicts: the
-- unit is a fixed point of every chart automorphism, while φ(1) = φ(2), so the
-- fibre {1,2} is not contained in any chart orbit.
--
-- This module only *imports* NaturalMachine.SymmetryArithmeticAction (author:
-- codex-kleene, msgs 0326/0328); nothing there is edited.  It is deliberately
-- not imported by NaturalMachine.agda.

module TotientFibreSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Functions.Involution using (involEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Bool
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using ()
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import NaturalMachine.SymmetryArithmeticAction
  using (actObservation ; Stabilizes)

------------------------------------------------------------------------------
-- §1.  Orbits refine fibres.  (The easy half of "orbits = fibres", and the
-- half Theorem E's *sufficiency* direction uses.)
------------------------------------------------------------------------------

stabilizes-invariant : {X : Type₀} (observation : X → ℕ) (e : X ≃ X)
                     → Stabilizes observation e
                     → (x : X) → observation (equivFun e x) ≡ observation x
stabilizes-invariant observation e h x = funExt⁻ h x

------------------------------------------------------------------------------
-- §2.  Transpositions on a discrete type, built by hand so that `--safe`
-- covers them and no decidability is postulated.
------------------------------------------------------------------------------

module Transposition {X : Type₀} (dis : Discrete X) (a b : X) where

  step : (x : X) → Dec (x ≡ a) → Dec (x ≡ b) → X
  step x (yes _) _         = b
  step x (no _)  (yes _)   = a
  step x (no _)  (no _)    = x

  tr : X → X
  tr x = step x (dis x a) (dis x b)

  tr-a : tr a ≡ b
  tr-a with dis a a
  ... | yes _  = refl
  ... | no ¬p  = ⊥.rec (¬p refl)

  tr-b : tr b ≡ a
  tr-b with dis b a
  ... | yes p = p
  ... | no _ with dis b b
  ...           | yes _ = refl
  ...           | no ¬q = ⊥.rec (¬q refl)

  tr-fix : (x : X) → ¬ (x ≡ a) → ¬ (x ≡ b) → tr x ≡ x
  tr-fix x ¬p ¬q with dis x a
  ... | yes p = ⊥.rec (¬p p)
  ... | no _ with dis x b
  ...           | yes q = ⊥.rec (¬q q)
  ...           | no _  = refl

  tr-invol : (x : X) → tr (tr x) ≡ x
  tr-invol x with dis x a
  ... | yes p = tr-b ∙ sym p
  ... | no ¬p with dis x b
  ...            | yes q = tr-a ∙ sym q
  ...            | no ¬q = tr-fix x ¬p ¬q

  trEquiv : X ≃ X
  trEquiv = involEquiv {f = tr} tr-invol

  -- A transposition *inside* a fibre lies in the observational stabilizer.
  tr-stabilizes : (observation : X → ℕ)
                → observation a ≡ observation b
                → Stabilizes observation trEquiv
  tr-stabilizes observation h = funExt lemma
    where
    lemma : (x : X) → observation (tr x) ≡ observation x
    lemma x with dis x a
    ... | yes p = sym h ∙ cong observation (sym p)
    ... | no ¬p with dis x b
    ...            | yes q = h ∙ cong observation (sym q)
    ...            | no ¬q = refl

------------------------------------------------------------------------------
-- §3.  THEOREM T (trivialization).  Every fibre of every observation is an
-- orbit of a genuine group of symmetries -- the observational stabilizer,
-- which is a subgroup of Sym X by `stabilizes-id`, `stabilizes-comp`,
-- `stabilizes-inv` (already checked in SymmetryArithmeticAction).
--
-- Consequence for Theorem E: "there is a symmetry group acting transitively on
-- the value space" is not a property of an index.  It is a theorem about all
-- indices.  The criterion acquires content only once the group is *pinned to
-- the ambient structure* -- a field of definition, in the Galois sense.
------------------------------------------------------------------------------

fibre-is-an-orbit : {X : Type₀} (dis : Discrete X) (observation : X → ℕ)
                    (a b : X) → observation a ≡ observation b
                  → Σ[ e ∈ (X ≃ X) ]
                      (Stabilizes observation e) × (equivFun e a ≡ b)
fibre-is-an-orbit dis observation a b h =
  trEquiv , tr-stabilizes observation h , tr-a
  where open Transposition dis a b

------------------------------------------------------------------------------
-- §4.  THEOREM R (rigidity).  Pin the group.  In the multiplicative chart an
-- automorphism is exactly a permutation of the prime generators, and the
-- totient observation on generators is p ↦ p − 1.  Its stabilizer is trivial.
------------------------------------------------------------------------------

IsSuc : ℕ → Type₀
IsSuc n = Σ[ m ∈ ℕ ] n ≡ suc m

pred-inj : {j k : ℕ} → IsSuc j → IsSuc k → predℕ j ≡ predℕ k → j ≡ k
pred-inj (m , pj) (n , pk) h =
  pj ∙ cong suc (sym (cong predℕ pj) ∙ h ∙ cong predℕ pk) ∙ sym pk

totient-rigidifies : {X : Type₀} (prime : X → ℕ)
                   → ((x : X) → IsSuc (prime x))
                   → ((x y : X) → prime x ≡ prime y → x ≡ y)
                   → (e : X ≃ X)
                   → Stabilizes (λ x → predℕ (prime x)) e
                   → (x : X) → equivFun e x ≡ x
totient-rigidifies prime pos inj e h x =
  inj (equivFun e x) x
      (pred-inj (pos (equivFun e x)) (pos x) (funExt⁻ h x))

totient-rigidifies-id : {X : Type₀} (prime : X → ℕ)
                      → ((x : X) → IsSuc (prime x))
                      → ((x y : X) → prime x ≡ prime y → x ≡ y)
                      → (e : X ≃ X)
                      → Stabilizes (λ x → predℕ (prime x)) e
                      → e ≡ idEquiv X
totient-rigidifies-id prime pos inj e h =
  equivEq (funExt (totient-rigidifies prime pos inj e h))

-- The contrast that makes Theorem R a statement and not a tautology: the
-- observation the multiplicative chart *can* make of a generator -- that it is
-- one -- is stabilized by everything.  Floppiness and rigidity are properties
-- of the observation, not of the group.
generator-count-is-blind : {X : Type₀} (e : X ≃ X)
                         → Stabilizes (λ (_ : X) → 1) e
generator-count-is-blind e = refl

------------------------------------------------------------------------------
-- §5.  Non-vacuity, witnessed rather than asserted: two generators carrying
-- the primes 2 and 3.  The swap is in the blind stabilizer and out of the
-- totient stabilizer.
------------------------------------------------------------------------------

twoPrimes : Bool → ℕ
twoPrimes false = 2
twoPrimes true  = 3

twoPrimes-pos : (x : Bool) → IsSuc (twoPrimes x)
twoPrimes-pos false = 1 , refl
twoPrimes-pos true  = 2 , refl

twoPrimes-inj : (x y : Bool) → twoPrimes x ≡ twoPrimes y → x ≡ y
twoPrimes-inj false false _ = refl
twoPrimes-inj false true  p = ⊥.rec (znots (injSuc (injSuc p)))
twoPrimes-inj true  false p = ⊥.rec (snotz (injSuc (injSuc p)))
twoPrimes-inj true  true  _ = refl

swap-not-in-totient-stabilizer
  : ¬ Stabilizes (λ x → predℕ (twoPrimes x)) notEquiv
swap-not-in-totient-stabilizer h = snotz (injSuc (funExt⁻ h false))

swap-in-blind-stabilizer : Stabilizes (λ (_ : Bool) → 1) notEquiv
swap-in-blind-stabilizer = refl

------------------------------------------------------------------------------
-- §6.  Where the two answers part: the unit.
--
-- In the multiplicative chart a divisor of a squarefree modulus is a subset of
-- the generator set, and a chart automorphism acts by relabelling generators.
-- The unit is the empty subset, hence a fixed point of the whole group -- while
-- φ(1) = φ(2) = 1 puts 1 and 2 in one totient fibre.  So that fibre is not
-- contained in a chart orbit, let alone equal to one.
------------------------------------------------------------------------------

Divisor : Type₀ → Type₀
Divisor X = X → Bool

chartAct : {X : Type₀} → (X ≃ X) → Divisor X → Divisor X
chartAct e d x = d (equivFun e x)

unitDivisor : {X : Type₀} → Divisor X
unitDivisor _ = false

unit-is-fixed : {X : Type₀} (e : X ≃ X)
              → chartAct e unitDivisor ≡ unitDivisor
unit-is-fixed e = refl

-- Divisors of 6 = 2 · 3, with the generator `false` carrying 2.
divisor2 : Divisor Bool
divisor2 false = true
divisor2 true  = false

unit≢divisor2 : ¬ (unitDivisor ≡ divisor2)
unit≢divisor2 h = false≢true (funExt⁻ h false)

no-chart-symmetry-links-1-and-2
  : (e : Bool ≃ Bool) → ¬ (chartAct e unitDivisor ≡ divisor2)
no-chart-symmetry-links-1-and-2 e h =
  unit≢divisor2 (sym (unit-is-fixed e) ∙ h)

-- φ on divisors of 6, as the product of (p − 1) over the chosen generators.
factorPart : Bool → ℕ → ℕ
factorPart false _ = 1
factorPart true  k = k

phi6 : Divisor Bool → ℕ
phi6 d = factorPart (d false) 1 · factorPart (d true) 2

phi6-unit : phi6 unitDivisor ≡ 1
phi6-unit = refl

phi6-divisor2 : phi6 divisor2 ≡ 1
phi6-divisor2 = refl

discreteDivisor : Discrete (Divisor Bool)
discreteDivisor d e with (d false ≟ e false) | (d true ≟ e true)
... | yes p | yes q = yes (funExt (λ { false → p ; true → q }))
... | yes _ | no ¬q = no (λ h → ¬q (funExt⁻ h true))
... | no ¬p | _     = no (λ h → ¬p (funExt⁻ h false))

-- Theorem T applied to the very fibre the open item names: a group acts
-- transitively on {1,2} …
one-two-fibre-has-a-transitive-group
  : Σ[ e ∈ (Divisor Bool ≃ Divisor Bool) ]
      (Stabilizes phi6 e) × (equivFun e unitDivisor ≡ divisor2)
one-two-fibre-has-a-transitive-group =
  fibre-is-an-orbit discreteDivisor phi6 unitDivisor divisor2
                    (phi6-unit ∙ sym phi6-divisor2)

-- … and by §6 no element of the chart's automorphism group is such a symmetry.
-- Both facts are checked; the pair of them is the answer to B4.  The group
-- exists and is worthless; the group that would have meant something is
-- trivial.
