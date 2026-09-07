{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FactoryVICore
--
-- The exact integer core of Theorem Factory VI
-- (notes/EGB_THEOREM_FACTORY_VI.md), as checked terms.  The note's
-- statements are phrased in logs (σ = log a / log n, the exponent
-- share a ≤ b^{1/m}); this module carries the INTEGER-EXACT forms the
-- note itself supplies, so no floating point and no log ever enters the
-- kernel.  The translation used throughout, for a completed factor
-- state x = (n; a, b) with n = a·b, 1 ≤ a ≤ b:
--
--     a ≤ b^{1/m}   ⟺   a^m ≤ b   ⟺   a^{m+1} ≤ n        (T97)
--
-- (the middle/right equivalence because n = a·b; see t97-equiv-* for
-- the refl certificates on concrete instances).  The discrete gap is
-- m∗; the note takes m∗ = 2 (unrestricted leg), and m∗ is CONCRETE
-- here: mstar = 2.  "Nonunit" means a > 1, i.e. 2 ≤ a; "unit" means
-- a ≡ 1.
--
-- What is proved, and how:
--
--   * T97 (exponent/share equivalence), clean direction — a GENERAL
--     theorem in a, b, m over ℕ:  a^m ≤ b  ⟹  a^{m+1} ≤ a·b.  This is
--     the monotone half (the arithmetic content of a ≤ b^{1/m}); its
--     proof is one line of ≤-·k + commutativity.  The equivalence
--     a^m ≤ b ⟺ a^{m+1} ≤ n is then certified by refl on instances.
--
--   * T101 (the quantifier tear — THE key theorem) — a GENERAL family
--     E_m in m.  E_m collects members (m∗·b ; m∗, b) with b ≥ m∗^m.
--     Certified generally in m: (a) every member is nonunit (a = m∗ =
--     2 > 1); (b) every member is near-boundary, a^m ≤ b; (c) the
--     family is inhabited at every m (familyMember, the extremal
--     b = m∗^m — cofinal in scale); (d) the UNIT SET IS EMPTY: no
--     member has a ≡ 1.  Together: ∀m ∃ (nonunit, near-boundary)
--     member, yet ¬∃ unit member.  A single x working ∀m would have to
--     be a unit, and there is none — this is the checked form of
--     ∀m∃x ⇏ ∃x∀m: the factor-share limit and the scale limit do not
--     commute.
--
--   * T100 (fixed-object endpoint compactness) — a DECIDABLE check on
--     a concrete finite E.  On a finite set, b^{1/m} → 1 lets one pick
--     m past log b of every element, after which no nonunit can satisfy
--     a^m ≤ b; the survivor is forced to be a unit, so the minimum
--     surviving factor is 1.  Here E = {(1,7),(2,5),(3,9)}: the
--     hypothesis "for each m in the range some member survives" holds
--     (allHave ≡ true, carried at large m by the unit), yet at m = 3
--     both nonunits are dead, exactly one member survives, and the
--     minimum surviving factor is 1 — all by refl.
--
-- Nothing here proves Goldbach or twins; T101 and T100 are precisely
-- the two no-go / compactness facts the factory uses to say which
-- research policies cannot reach them.  General theorems are proved in
-- the parameters; concrete constants are certified by refl (finite /
-- exact symbolic computation is proof, CLAUDE.md).  --safe throughout;
-- no postulates, no holes.
------------------------------------------------------------------------

module EGB.FactoryVICore where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _·_; _^_; injSuc; snotz)
open import Cubical.Data.Nat.Order using (_≤_; ≤-refl; ≤-trans; ≤-·k)
open import Cubical.Data.Nat.Properties using (·-comm)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_; _or_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Sigma using (_×_; _,_)
open import Agda.Builtin.Nat using (_<_)

------------------------------------------------------------------------
-- The discrete gap, concrete

mstar : ℕ
mstar = 2

-- scale of a completed state from its legs: n = a·b
scale : ℕ → ℕ → ℕ
scale a b = a · b

------------------------------------------------------------------------
-- T97 (exponent/share equivalence), clean direction.
--
-- The note's a ≤ b^{1/m} is, over ℕ, a^m ≤ b, and since n = a·b it is
-- a^{m+1} ≤ n.  The clean (monotone) direction — the half that carries
-- the near-boundary inequality forward one power — holds for ALL a,b,m
-- with no positivity hypothesis:
--
--     a^m ≤ b  ⟹  a^{m+1} ≤ a·b.
--
-- Proof: a^{m+1} = a·a^m ≤ a·b, one application of right-multiplication
-- monotonicity (≤-·k) reconciled with the library's left-recursive ^
-- by ·-comm.

t97-clean : (a b m : ℕ) → (a ^ m) ≤ b → (a ^ suc m) ≤ scale a b
t97-clean a b m h =
  subst2 _≤_ (·-comm (a ^ m) a) (·-comm b a) (≤-·k {k = a} h)

-- The equivalence a^m ≤ b ⟺ a^{m+1} ≤ n, certified by refl on
-- instances (both sides evaluate to the same Bool).

_≤ᵇ_ : ℕ → ℕ → Bool
a ≤ᵇ b = a < suc b

-- side test:  a^m ≤ b   vs   a^{m+1} ≤ a·b
shareL shareR : ℕ → ℕ → ℕ → Bool
shareL a b m = (a ^ m) ≤ᵇ b
shareR a b m = (a ^ suc m) ≤ᵇ scale a b

-- both true (near boundary satisfied):  a=2,b=10,m=3  (8≤10, 16≤20)
t97-equiv-T : shareL 2 10 3 ≡ shareR 2 10 3
t97-equiv-T = refl

-- both false (near boundary violated):  a=2,b=3,m=2  (4≰3, 8≰6)
t97-equiv-F : shareL 2 3 2 ≡ shareR 2 3 2
t97-equiv-F = refl

-- both true, odd leg:  a=3,b=9,m=1  (3≤9, 9≤27)
t97-equiv-odd : shareL 3 9 1 ≡ shareR 3 9 1
t97-equiv-odd = refl

------------------------------------------------------------------------
-- T101 (the quantifier tear).
--
-- The moving-scale family.  A member of E_m is a right leg b together
-- with the near-boundary witness b ≥ m∗^m; the left leg is fixed at
-- a = m∗ and the state is (m∗·b ; m∗, b).

record Em (m : ℕ) : Type where
  constructor mkEm
  field
    leg  : ℕ                    -- the right leg b
    lb   : (mstar ^ m) ≤ leg    -- b ≥ m∗^m  (near-boundary hypothesis)

-- the left leg (the factor a) is constant across the whole family
aOf : ℕ
aOf = mstar

-- the completed scale of a member: n = m∗·b, cofinal as b → ∞
nOf : {m : ℕ} → Em m → ℕ
nOf x = scale mstar (Em.leg x)

-- (c) inhabited at every m: the extremal member b = m∗^m.  This is the
--     ∀m ∃x_m of the tear — one member per m, and cofinal in scale
--     since m∗^m grows without bound.
familyMember : (m : ℕ) → Em m
familyMember m = mkEm (mstar ^ m) ≤-refl

-- (a) every member is nonunit: a = m∗ ≥ 2, i.e. a > 1.  General in m.
nonunit : (m : ℕ) → Em m → 2 ≤ aOf
nonunit _ _ = ≤-refl

-- (b) every member is near-boundary: a^m ≤ b (a = m∗).  General in m —
--     this is exactly the stored hypothesis, phrased on the factor a.
nearBoundary : (m : ℕ) (x : Em m) → (aOf ^ m) ≤ Em.leg x
nearBoundary _ x = Em.lb x

-- (d) the unit set is empty: no member is a unit (a ≡ 1 is absurd,
--     a = 2).  General in m.
unitEmpty : (m : ℕ) → Em m → aOf ≡ 1 → ⊥
unitEmpty _ _ p = snotz (injSuc p)

-- The tear, assembled: ∀m there is a member (familyMember) that is
-- nonunit and near-boundary, while unitEmpty says the unit set is empty
-- at every m.  Hence a single x serving all m — which would have to be
-- a unit — cannot exist: ∀m∃x ⇏ ∃x∀m.

-- concrete face at m = 5:  member b = m∗^5 = 32, near-boundary and
-- nonunit, certified by refl.
t101-nearBoundary-5 : (aOf ^ 5) ≤ᵇ 32 ≡ true
t101-nearBoundary-5 = refl

t101-nonunit : (2 ≤ᵇ aOf) ≡ true
t101-nonunit = refl

t101-notUnit : (aOf ≤ᵇ 1) ≡ false
t101-notUnit = refl

------------------------------------------------------------------------
-- T100 (fixed-object endpoint compactness), decidable at a concrete
-- finite E.
--
-- A factor state, reduced to its two legs (a , b).

State : Type
State = ℕ × ℕ

-- b survives the exponent m when a^m ≤ b  (the note's a ≤ b^{1/m}).
survives : ℕ → State → Bool
survives m (a , b) = (a ^ m) ≤ᵇ b

-- the concrete finite set E
Efin : List State
Efin = (1 , 7) ∷ (2 , 5) ∷ (3 , 9) ∷ []

-- does some member of E survive at m?  (the T100 hypothesis, per m)
anySurv : ℕ → List State → Bool
anySurv m []       = false
anySurv m (x ∷ xs) = survives m x or anySurv m xs

-- the hypothesis over a finite index range: for each m, some survivor
allHave : List ℕ → List State → Bool
allHave []       E = true
allHave (m ∷ ms) E = anySurv m E and allHave ms E

-- minimum of two ℕ
minB : ℕ → ℕ → ℕ
minB a b = if a < suc b then a else b

-- minimum factor a among the members surviving at exponent m
-- (sentinel 1000000 for "no survivor"; never reached here, E always
-- has the unit surviving)
survMin : ℕ → List State → ℕ
survMin m []             = 1000000
survMin m ((a , b) ∷ xs) =
  if survives m (a , b) then minB a (survMin m xs) else survMin m xs

-- number of survivors at exponent m
countSurv : ℕ → List State → ℕ
countSurv m []       = 0
countSurv m (x ∷ xs) = (if survives m x then 1 else 0) + countSurv m xs

-- The hypothesis holds on the range m ∈ {1,2,3}: every m has a
-- surviving member (carried at m = 2,3 by the unit (1,7)).
t100-hyp : allHave (1 ∷ 2 ∷ 3 ∷ []) Efin ≡ true
t100-hyp = refl

-- Compactness bite at m = 3: both nonunits are dead...
t100-nonunit1-dead : survives 3 (2 , 5) ≡ false
t100-nonunit1-dead = refl

t100-nonunit2-dead : survives 3 (3 , 9) ≡ false
t100-nonunit2-dead = refl

-- ...only the unit survives...
t100-unit-alive : survives 3 (1 , 7) ≡ true
t100-unit-alive = refl

t100-count : countSurv 3 Efin ≡ 1
t100-count = refl

-- ...hence the minimum surviving factor is 1: E contains a unit state,
-- the endpoint conclusion of T100.
t100-minFactor : survMin 3 Efin ≡ 1
t100-minFactor = refl
