-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExtremalDescription
--
-- Two "shortest description" statements in this corpus, and the one
-- order-theoretic fact both of them are.
--
-- THE PATTERN.  Kolmogorov complexity is machine-independent only up to
-- an additive constant, and the reason is structural: the family of
-- machines has no maximum under simulation, so the optimum is a limit
-- of a family rather than a member of it.  Wherever the corresponding
-- family DOES have an extremum, the constant is not "small" — it is
-- exactly 0, and quoting a numeric optimum instead of the extremal
-- object is a category error that hides which cost measure was used.
-- Both sections below exhibit that extremum and prove it.
--
--   §2  `greatest-safe`   The greatest relation you may quotient by
--                         without ever losing an observation is
--                         `ForeverEq` (= N_obs = ⋂ₙ ker(P Tⁿ)).
--                         `NaturalMachine.ObservabilityQuotient` proves
--                         `ForeverEq` is safe (refines `InstantEq`,
--                         invariant under the step) and that `InstantEq`
--                         is NOT contained in it.  It does not prove
--                         MAXIMALITY, which is what the words "the
--                         maximal safe compression" in its own header
--                         assert.  Three lines supply it.  Consequence
--                         `safe-maximum-unique`: any two greatest safe
--                         relations coincide — the invariance constant
--                         here is 0, with no parameter to be hidden in.
--
--       `instant-not-invariant`  sharpens C19.13: it is *invariance*,
--                         not soundness, that `ker P` fails.
--
--   §3  `certifies→contains` / `contains→certifies`
--                         `notes/OBLIGATION.md` §5 Theorem O5(3) claims
--                         the minimum number of ORACLE BITS certifying
--                         soundness of a target set equals the MIN CUT
--                         of its repair network (Theorem O3).  It does
--                         not.  The set of certifying oracle-bit sets
--                         has a LEAST element under inclusion, namely
--                         `R` = the open obligations that reach the
--                         target, and the proof is two lines because
--                         "α is sound" IS "R ⊆ α".  `least-cost` then
--                         says the minimiser is the same for EVERY
--                         monotone cost measure.
--
--   §4  A four-vertex graph on which the min cut is 1 and the least
--                         certificate has 2 elements: `severing-works₁/₂`
--                         (one severing kills every contamination route)
--                         against `both-bits-needed` (no single oracle
--                         bit certifies).  A repair action is WORK; an
--                         oracle bit is INFORMATION; the min cut prices
--                         the first and O5(3) reads it as the second.
--                         The gap is unbounded: the same fan-in with n
--                         obligations has min cut 1 and least
--                         certificate n.
--
-- WHAT IS NOT CLAIMED.  Nothing here is new mathematics.  §2 is the
-- greatest-fixed-point characterisation of observational equivalence —
-- classical minimal-realization / bisimulation theory, and Delta 19
-- says so itself (S19.14, "do not reinvent it").  §3 is the 1-certificate
-- complexity of a monotone AND, which is textbook (Buhrman–de Wolf,
-- *Complexity measures and decision tree complexity*, TCS 288 (2002)
-- 21–43; attribution from a search summary, source text not read).
-- The deliverable is that both are now terms, and that O5(3) is false
-- as stated.  No min-cut algorithm is formalised here and none is
-- needed: §4 exhibits a valid repair of cost 1 and shows the empty
-- repair invalid, which pins the min cut at 1 by Theorem O3 itself.
------------------------------------------------------------------------

module ExtremalDescription where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

import NaturalMachine.ObservabilityQuotient as OQ

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 2.  The greatest safe congruence.
--
-- A relation is SAFE for the pair (T , p) when quotienting by it can
-- never destroy an observation: it must refine the instantaneous
-- observation (`Sound≈`) and be preserved by the dynamics (`Inv≈`).
-- Those are exactly the two properties `ObservabilityQuotient` proves
-- of `ForeverEq`.  `greatest-safe` says no safe relation is coarser.
------------------------------------------------------------------------

module _ {X : Type ℓ} {Y : Type ℓ'} (T : X → X) (p : X → Y) where

  Sound≈ : (X → X → Type ℓ'') → Type (ℓ-max ℓ (ℓ-max ℓ'' ℓ'))
  Sound≈ _≈_ = {x y : X} → x ≈ y → OQ.InstantEq T p x y

  Inv≈ : (X → X → Type ℓ'') → Type (ℓ-max ℓ ℓ'')
  Inv≈ _≈_ = {x y : X} → x ≈ y → T x ≈ T y

  -- The whole proof is that `obsAt (suc n) x` and `obsAt n (T x)` are
  -- DEFINITIONALLY equal — the bracketing `ObservabilityQuotient` chose
  -- for `iterT` — so one step of invariance is one step of induction.
  greatest-safe : {_≈_ : X → X → Type ℓ''}
                → Sound≈ _≈_ → Inv≈ _≈_
                → {x y : X} → x ≈ y → OQ.ForeverEq T p x y
  greatest-safe s i r zero    = s r
  greatest-safe s i r (suc n) = greatest-safe s i (i r) n

  -- `ForeverEq` is itself safe (their T19.11 / T19.12), so `greatest-safe`
  -- makes it the MAXIMUM of the safe relations, not merely an upper bound.
  forever-sound : Sound≈ (OQ.ForeverEq T p)
  forever-sound = OQ.forever→instant T p

  forever-inv : Inv≈ (OQ.ForeverEq T p)
  forever-inv = OQ.forever-invariant T p

  -- Invariance with constant 0: a greatest element of a preorder is
  -- unique up to mutual containment, so "which safe relation you compress
  -- by" is not a choice at all once you demand maximality.  This is the
  -- disanalogy with Kolmogorov's invariance theorem worth naming: there
  -- the optimum is approached, here it is attained.
  safe-maximum-unique :
      {_≈_ : X → X → Type ℓ''}
    → Sound≈ _≈_ → Inv≈ _≈_
    → ({x y : X} → OQ.ForeverEq T p x y → x ≈ y)
    → {x y : X}
    → (x ≈ y → OQ.ForeverEq T p x y) × (OQ.ForeverEq T p x y → x ≈ y)
  safe-maximum-unique s i u = greatest-safe s i , u

------------------------------------------------------------------------
-- 2a.  Sharpening C19.13's witness.
--
-- `ObservabilityQuotient.instant↛forever` shows `InstantEq` ⊄ `ForeverEq`.
-- With maximality that says something sharper and more useful: `ker P`
-- fails safety at the SECOND clause.  It is trivially sound for itself;
-- what it is not is invariant under the step.  So the defect in "quotient
-- by what you cannot see now" is precisely a failure of congruence.
------------------------------------------------------------------------

instant-not-invariant :
    ({x y : OQ.Three}
       → OQ.InstantEq OQ.step OQ.see x y
       → OQ.InstantEq OQ.step OQ.see (OQ.step x) (OQ.step y))
  → ⊥
instant-not-invariant i =
  OQ.instant↛forever (greatest-safe OQ.step OQ.see (λ r → r) i)

------------------------------------------------------------------------
-- 3.  The least certifying set of oracle bits.
--
-- `notes/OBLIGATION.md` §5: `L` is the set of open obligations, an
-- oracle assignment is `α : L → Bool` ("has this obligation been
-- discharged?"), and the target set `T` is sound exactly when every
-- open obligation that REACHES `T` has been discharged.  Write `R` for
-- the reaching ones.  Then:
--
--     Sound α   =   R ⊆ α                                       (by definition)
--     Certifies Q  =  ∀ α, Q ⊆ α → R ⊆ α
--
-- and the theorem is the Yoneda-flavoured triviality that a principal
-- up-set determines its generator.  It is stated here because the note
-- reached for max-flow/min-cut to answer it and got a different — and
-- strictly smaller — number.
------------------------------------------------------------------------

module Certificate {L : Type ℓ} (R : L → Bool) where

  -- `A ⊆ B`, as functions to Bool.
  Agrees : (L → Bool) → (L → Bool) → Type ℓ
  Agrees A B = (u : L) → A u ≡ true → B u ≡ true

  Sound : (L → Bool) → Type ℓ
  Sound α = Agrees R α

  Certifies : (L → Bool) → Type ℓ
  Certifies Q = (α : L → Bool) → Agrees Q α → Sound α

  -- Instantiate the universally quantified oracle at Q itself.
  certifies→contains : (Q : L → Bool) → Certifies Q → Agrees R Q
  certifies→contains Q cert = cert Q (λ _ h → h)

  contains→certifies : (Q : L → Bool) → Agrees R Q → Certifies Q
  contains→certifies Q h α hα u hR = hα u (h u hR)

  R-certifies : Certifies R
  R-certifies = contains→certifies R (λ _ h → h)

  -- Hence `R` is the LEAST certifying set, and therefore the minimiser
  -- of every monotone cost — cardinality, weighted audit hours, anything.
  -- The extremal object is the theorem; any number attached to it is a
  -- property of the chosen cost function and not of the corpus.
  module _ (cost : (L → Bool) → ℕ)
           (mono : {A B : L → Bool} → Agrees A B → cost A ≤ cost B) where

    least-cost : (Q : L → Bool) → Certifies Q → cost R ≤ cost Q
    least-cost Q cert = mono (certifies→contains Q cert)

------------------------------------------------------------------------
-- 4.  The counterexample to O5(3): min cut 1, least certificate 2.
--
--        o₁ ──┐
--             ├──▶ mid ──▶ tgt
--        o₂ ──┘
--
--   O = {o₁ , o₂} (both carry an open obligation),  T = {tgt}.
--   Unit costs: every discharge costs 1, every severing costs 1.
--
--   * Severing the single edge `mid → tgt` is a valid repair of cost 1
--     (`severing-works₁`, `severing-works₂`), and the empty repair is
--     invalid (`o₁⇝tgt`).  So the min cut of Theorem O3 is exactly 1.
--   * Every set of oracle bits that certifies soundness must contain
--     BOTH `o₁` and `o₂` (`both-bits-needed`), which are distinct
--     (`o₁≢o₂`).  So the least certificate has 2 elements.
--
--   2 ≠ 1, and replacing the fan-in by n sources makes it n ≠ 1.  O5(3)
--   therefore understates the external information required — the same
--   direction of error Cor. O2.4 warns about ("it errs by believing
--   claims too strongly"), committed one level up.
------------------------------------------------------------------------

data Vtx : Type₀ where
  o₁ o₂ mid tgt : Vtx

-- The dependency edges of the corpus.
E : Vtx → Vtx → Bool
E o₁  mid = true
E o₂  mid = true
E mid tgt = true
E _   _   = false

-- The same graph after severing `mid → tgt` (an independent re-derivation
-- at `tgt` of what it was importing from `mid`).
E′ : Vtx → Vtx → Bool
E′ mid tgt = false
E′ o₁  mid = true
E′ o₂  mid = true
E′ _   _   = false

data Reach (G : Vtx → Vtx → Bool) : Vtx → Vtx → Type₀ where
  done : {x : Vtx} → Reach G x x
  hop  : {x y z : Vtx} → G x y ≡ true → Reach G y z → Reach G x z

-- Before the repair both obligations contaminate the target, so the
-- empty repair is invalid and the min cut is at least 1.
o₁⇝tgt : Reach E o₁ tgt
o₁⇝tgt = hop {y = mid} refl (hop {y = tgt} refl done)

o₂⇝tgt : Reach E o₂ tgt
o₂⇝tgt = hop {y = mid} refl (hop {y = tgt} refl done)

isTgt : Vtx → Bool
isTgt tgt = true
isTgt _   = false

isO₁ : Vtx → Bool
isO₁ o₁ = true
isO₁ _  = false

o₁≢tgt : o₁ ≡ tgt → ⊥
o₁≢tgt q = false≢true (cong isTgt q)

o₂≢tgt : o₂ ≡ tgt → ⊥
o₂≢tgt q = false≢true (cong isTgt q)

o₁≢o₂ : o₁ ≡ o₂ → ⊥
o₁≢o₂ q = true≢false (cong isO₁ q)

-- After severing, `tgt` has no incoming edge at all.
E′-no-in : (x : Vtx) → E′ x tgt ≡ false
E′-no-in o₁  = refl
E′-no-in o₂  = refl
E′-no-in mid = refl
E′-no-in tgt = refl

-- A vertex with no in-edges is reachable only from itself.  This is the
-- invariant argument that replaces enumerating paths.
no-in→unreachable :
    (G : Vtx → Vtx → Bool)
  → ((x : Vtx) → G x tgt ≡ false)
  → {x : Vtx} → (x ≡ tgt → ⊥) → Reach G x tgt → ⊥
no-in→unreachable G h ne done = ne refl
no-in→unreachable G h {x} ne (hop e r) =
  no-in→unreachable G h (λ q → true≢false (sym e ∙ cong (G x) q ∙ h x)) r

severing-works₁ : Reach E′ o₁ tgt → ⊥
severing-works₁ = no-in→unreachable E′ E′-no-in o₁≢tgt

severing-works₂ : Reach E′ o₂ tgt → ⊥
severing-works₂ = no-in→unreachable E′ E′-no-in o₂≢tgt

-- The open obligations that reach the target.
Rgraph : Vtx → Bool
Rgraph o₁  = true
Rgraph o₂  = true
Rgraph mid = false
Rgraph tgt = false

open Certificate {L = Vtx} Rgraph

both-bits-needed :
    (Q : Vtx → Bool) → Certifies Q → (Q o₁ ≡ true) × (Q o₂ ≡ true)
both-bits-needed Q cert =
    certifies→contains Q cert o₁ refl
  , certifies→contains Q cert o₂ refl

-- …and, concretely, neither single bit is enough.  This is the exact
-- statement O5(3) denies when it equates the certificate with the min cut.
only-o₁ : Vtx → Bool
only-o₁ o₁ = true
only-o₁ _  = false

only-o₂ : Vtx → Bool
only-o₂ o₂ = true
only-o₂ _  = false

only-o₁-fails : Certifies only-o₁ → ⊥
only-o₁-fails cert = false≢true (snd (both-bits-needed only-o₁ cert))

only-o₂-fails : Certifies only-o₂ → ⊥
only-o₂-fails cert = false≢true (fst (both-bits-needed only-o₂ cert))
