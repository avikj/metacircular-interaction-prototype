{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.LineWorldTransport
--
-- The line-world transport criterion of `notes/ENCOUNTERED_WORLDS.md`
-- §3.5, WITH ITS HYPOTHESIS ON THE OBSERVABLE MADE PART OF THE TYPE.
--
-- SOURCE STATEMENT (`notes/ENCOUNTERED_WORLDS.md:121-124`, verbatim):
--
--   **Corollary (line worlds).** For `f = X+Y` and `E = {(a, sa)}`, the
--   tangent set is `span{(1,s)}` and `grad f|_L (t) = t(1+s)`.  So `E`
--   transports **iff `s != -1 (mod p)`**.
--
-- The audit `notes/FULL_READ_DRAW_5.md` §C2 records that the summary
-- message `workers/20260812T090934.276887Z--claude_ananta--0005.md` §5
-- dropped the two words "For `f = X+Y`" while its §5 Theorem was
-- quantified over ALL integral `f`.  Under that quantifier the corollary
-- is FALSE: for `f = X` the restricted gradient is `grad f|_L(t) = t`,
-- which is nonzero for every slope, so every line world transports and
-- the criterion `s ≢ -1` names the wrong set.  This defect has no
-- lexical signature — the false sentence contains no wrong word, only a
-- missing one — so the instrument for it is a type, not a grep.
--
-- THIS IS A MODEL, NOT THE FULL SETTING.  The full setting is `p`-adic
-- encountered worlds over an arbitrary integral polynomial.  What is
-- formalized here is the smallest finite model that still distinguishes
-- `f = X+Y` from `f = X`, at the single prime `p = 5` that the note
-- names ("at `p = 5` the failing world is `{(a, 4a)}`"):
--
--   * observables are the two linear forms the audit contrasts, carried
--     by their gradient coefficients `(c₁ , c₂)`;
--   * a slope `s` ranges over `ℤ/5`;
--   * `transports f s` is the note's own criterion, computed the way the
--     note's proof computes it: the restricted gradient value is
--     `g = c₁ + c₂·s (mod 5)`, and transport holds iff the target unit
--     `-u = -1 = 4` lies in `{ t·g : t ∈ ℤ/5 }` — decided here by FINITE
--     EXHAUSTIVE SEARCH over the five `t`, so every statement below is a
--     closed computation and every proof is `refl` (CLAUDE.md: exact /
--     certified symbolic computation is proof; no fitting, no sampling).
--
-- What the model does NOT claim: nothing about unbounded worlds, about
-- the tangent-set identity `T_E(x) = span{(1,s)}` (whose truncation
-- caveat the note carries from `notes/FINITE_MODEL_AUDIT.md` §3), about
-- nonlinear `f`, or about primes other than 5.  It claims exactly enough
-- to make the dropped hypothesis load-bearing, which is what the control
-- `NaturalMachine/Control/QuantifierDrop.agda` then exhibits.
--
-- HEADLINE TERMS
--   line-world-XY            the corollary, hypothesis explicit in the type
--   line-world-X             for `f = X` EVERY line world transports
--   dropped-hypothesis-false the quantified-over-all-`f` reading implies ⊥
------------------------------------------------------------------------

module NaturalMachine.LineWorldTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Mod using (_mod_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _or_)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- The modulus.  `p = 5`, the odd prime the note works out explicitly.

p : ℕ
p = 5

-- The target of transport: the unit `-u` with `u = 1`, i.e. `-1 = 4`.
target : ℕ
target = 4

------------------------------------------------------------------------
-- Slopes: `ℤ/5` as a five-constructor enumeration, so that "for every
-- slope" is a five-case exhaustive check rather than an induction.

data Slope : Type where
  s0 s1 s2 s3 s4 : Slope

val : Slope → ℕ
val s0 = 0
val s1 = 1
val s2 = 2
val s3 = 3
val s4 = 4

------------------------------------------------------------------------
-- Observables.  Only the two the audit contrasts; each is carried by
-- its gradient `(c₁ , c₂)`, which is constant because both are linear.

data Obs : Type where
  X   : Obs          -- f = X      , grad = (1,0)
  X+Y : Obs          -- f = X + Y  , grad = (1,1)

c₁ : Obs → ℕ
c₁ X   = 1
c₁ X+Y = 1

c₂ : Obs → ℕ
c₂ X   = 0
c₂ X+Y = 1

-- The restricted gradient on the line `L = span{(1,s)}`, evaluated at
-- the generator `t = 1`: `grad f|_L (1) = c₁ + c₂·s`.
grad : Obs → Slope → ℕ
grad f s = (c₁ f + c₂ f · val s) mod p

------------------------------------------------------------------------
-- Decidable equality on ℕ, and the finite search.

eqℕ : ℕ → ℕ → Bool
eqℕ zero    zero    = true
eqℕ zero    (suc _) = false
eqℕ (suc _) zero    = false
eqℕ (suc m) (suc n) = eqℕ m n

-- `attains g` : is `target` in the subgroup `{ t·g : t ∈ ℤ/5 }`?
-- Exhaustive over the five residues; this IS the note's proof step
-- ("the set of attainable values is a subgroup, hence {0} or all"),
-- carried out by finite verification rather than by the group argument.
attains : ℕ → Bool
attains g =
      eqℕ ((0 · g) mod p) target
  or  eqℕ ((1 · g) mod p) target
  or  eqℕ ((2 · g) mod p) target
  or  eqℕ ((3 · g) mod p) target
  or  eqℕ ((4 · g) mod p) target

-- The note's criterion.
transports : Obs → Slope → Bool
transports f s = attains (grad f s)

-- The right-hand side of the corollary: `s ≢ -1 (mod 5)`, i.e. `s ≠ 4`.
crit : Slope → Bool
crit s = not (eqℕ (val s) target)

------------------------------------------------------------------------
-- 1.  The corollary, WITH its hypothesis.  The observable is fixed to
--     `X+Y` in the type; there is no way to read this statement as one
--     about a general `f`.

line-world-XY : (s : Slope) → transports X+Y s ≡ crit s
line-world-XY s0 = refl
line-world-XY s1 = refl
line-world-XY s2 = refl
line-world-XY s3 = refl
line-world-XY s4 = refl

------------------------------------------------------------------------
-- 2.  The counterexample, as a checked term rather than an assertion:
--     for `f = X`, EVERY line world transports — including `s = 4 = -1`,
--     the one slope the dropped-hypothesis reading declares to fail.

line-world-X : (s : Slope) → transports X s ≡ true
line-world-X s0 = refl
line-world-X s1 = refl
line-world-X s2 = refl
line-world-X s3 = refl
line-world-X s4 = refl

X-transports-at-minus-one : transports X s4 ≡ true
X-transports-at-minus-one = refl

crit-refuses-minus-one : crit s4 ≡ false
crit-refuses-minus-one = refl

------------------------------------------------------------------------
-- 3.  Therefore the hypothesis-dropped reading is false, not merely
--     unproved: assuming it for all observables yields `true ≡ false`.
--     `NaturalMachine/Control/QuantifierDrop.agda` asserts exactly the
--     antecedent below and must fail to type-check.

dropped-hypothesis-false :
  ((f : Obs) (s : Slope) → transports f s ≡ crit s) → ⊥
dropped-hypothesis-false h = true≢false (sym X-transports-at-minus-one ∙ h X s4)
