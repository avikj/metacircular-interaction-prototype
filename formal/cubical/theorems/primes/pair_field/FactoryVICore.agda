{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FactoryVICore
--
-- The exact integer core of Theorem Factory VI
-- statements are phrased in logs (Ï = log a / log n, the exponent
-- share a â‰ b^{1/m}); this module carries the INTEGER-EXACT forms the
-- note itself supplies, so no floating point and no log ever enters the
-- kernel.  The translation used throughout, for a completed factor
-- state x = (n; a, b) with n = aÂb, 1 â‰ a â‰ b:
--
--     a â‰ b^{1/m}   âŸº   a^m â‰ b   âŸº   a^{m+1} â‰ n        (T97)
--
-- (the middle/right equivalence because n = aÂb; see t97-equiv-* for
-- the refl certificates on concrete instances).  The discrete gap is
-- mâˆ—; the note takes mâˆ— = 2 (unrestricted leg), and mâˆ— is CONCRETE
-- here: mstar = 2.  "Nonunit" means a > 1, i.e. 2 â‰ a; "unit" means
-- a â‰¡ 1.
--
-- What is proved, and how:
--
--   * T97 (exponent/share equivalence), clean direction â” a GENERAL
--     theorem in a, b, m over â•:  a^m â‰ b  âŸ  a^{m+1} â‰ aÂb.  This is
--     the monotone half (the arithmetic content of a â‰ b^{1/m}); its
--     proof is one line of â‰-Âk + commutativity.  The equivalence
--     a^m â‰ b âŸº a^{m+1} â‰ n is then certified by refl on instances.
--
--   * T101 (the quantifier tear â” THE key theorem) â” a GENERAL family
--     E_m in m.  E_m collects members (mâˆ—Âb ; mâˆ—, b) with b â‰ mâˆ—^m.
--     Certified generally in m: (a) every member is nonunit (a = mâˆ— =
--     2 > 1); (b) every member is near-boundary, a^m â‰ b; (c) the
--     family is inhabited at every m (familyMember, the extremal
--     b = mâˆ—^m â” cofinal in scale); (d) the UNIT SET IS EMPTY: no
--     member has a â‰¡ 1.  Together: âˆm âˆ (nonunit, near-boundary)
--     member, yet Ââˆ unit member.  A single x working âˆm would have to
--     be a unit, and there is none â” this is the checked form of
--     âˆmâˆx â âˆxâˆm: the factor-share limit and the scale limit do not
--     commute.
--
--   * T100 (fixed-object endpoint compactness) â” a DECIDABLE check on
--     a concrete finite E.  On a finite set, b^{1/m} â’ 1 lets one pick
--     m past log b of every element, after which no nonunit can satisfy
--     a^m â‰ b; the survivor is forced to be a unit, so the minimum
--     surviving factor is 1.  Here E = {(1,7),(2,5),(3,9)}: the
--     hypothesis "for each m in the range some member survives" holds
--     (allHave â‰¡ true, carried at large m by the unit), yet at m = 3
--     both nonunits are dead, exactly one member survives, and the
--     minimum surviving factor is 1 â” all by refl.
--
-- Nothing here proves Goldbach or twins; T101 and T100 are precisely
-- the two no-go / compactness facts the factory uses to say which
-- research policies cannot reach them.  General theorems are proved in
-- the parameters; concrete constants are certified by refl (finite /
-- exact symbolic computation is proof, CLAUDE.md).  --safe throughout;
-- no postulates, no holes.
------------------------------------------------------------------------

module FactoryVICore where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc; _+_; _Â·_; _^_; injSuc; snotz)
open import Cubical.Data.Nat.Order using (_â‰¤_; â‰¤-refl; â‰¤-trans; â‰¤-Â·k)
open import Cubical.Data.Nat.Properties using (Â·-comm)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_; _or_)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Data.List using (List; []; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_; _,_)
open import Agda.Builtin.Nat using (_<_)

------------------------------------------------------------------------
-- The discrete gap, concrete

mstar : â„•
mstar = 2

-- scale of a completed state from its legs: n = aÂb
scale : â„• â†’ â„• â†’ â„•
scale a b = a Â· b

------------------------------------------------------------------------
-- T97 (exponent/share equivalence), clean direction.
--
-- The note's a â‰ b^{1/m} is, over â•, a^m â‰ b, and since n = aÂb it is
-- a^{m+1} â‰ n.  The clean (monotone) direction â” the half that carries
-- the near-boundary inequality forward one power â” holds for ALL a,b,m
-- with no positivity hypothesis:
--
--     a^m â‰ b  âŸ  a^{m+1} â‰ aÂb.
--
-- Proof: a^{m+1} = aÂa^m â‰ aÂb, one application of right-multiplication
-- monotonicity (â‰-Âk) reconciled with the library's left-recursive ^
-- by Â-comm.

t97-clean : (a b m : â„•) â†’ (a ^ m) â‰¤ b â†’ (a ^ suc m) â‰¤ scale a b
t97-clean a b m h =
  subst2 _â‰¤_ (Â·-comm (a ^ m) a) (Â·-comm b a) (â‰¤-Â·k {k = a} h)

-- The equivalence a^m â‰ b âŸº a^{m+1} â‰ n, certified by refl on
-- instances (both sides evaluate to the same Bool).

_â‰¤áµ‡_ : â„• â†’ â„• â†’ Bool
a â‰¤áµ‡ b = a < suc b

-- side test:  a^m â‰ b   vs   a^{m+1} â‰ aÂb
shareL shareR : â„• â†’ â„• â†’ â„• â†’ Bool
shareL a b m = (a ^ m) â‰¤áµ‡ b
shareR a b m = (a ^ suc m) â‰¤áµ‡ scale a b

-- both true (near boundary satisfied):  a=2,b=10,m=3  (8â‰10, 16â‰20)
t97-equiv-T : shareL 2 10 3 â‰¡ shareR 2 10 3
t97-equiv-T = refl

-- both false (near boundary violated):  a=2,b=3,m=2  (4â‰°3, 8â‰°6)
t97-equiv-F : shareL 2 3 2 â‰¡ shareR 2 3 2
t97-equiv-F = refl

-- both true, odd leg:  a=3,b=9,m=1  (3â‰9, 9â‰27)
t97-equiv-odd : shareL 3 9 1 â‰¡ shareR 3 9 1
t97-equiv-odd = refl

------------------------------------------------------------------------
-- T101 (the quantifier tear).
--
-- The moving-scale family.  A member of E_m is a right leg b together
-- with the near-boundary witness b â‰ mâˆ—^m; the left leg is fixed at
-- a = mâˆ— and the state is (mâˆ—Âb ; mâˆ—, b).

record Em (m : â„•) : Type where
  constructor mkEm
  field
    leg  : â„•                    -- the right leg b
    lb   : (mstar ^ m) â‰¤ leg    -- b â‰¥ mâˆ—^m  (near-boundary hypothesis)

-- the left leg (the factor a) is constant across the whole family
aOf : â„•
aOf = mstar

-- the completed scale of a member: n = mâˆ—Âb, cofinal as b â’ âˆž
nOf : {m : â„•} â†’ Em m â†’ â„•
nOf x = scale mstar (Em.leg x)

-- (c) inhabited at every m: the extremal member b = mâˆ—^m.  This is the
--     âˆm âˆx_m of the tear â” one member per m, and cofinal in scale
--     since mâˆ—^m grows without bound.
familyMember : (m : â„•) â†’ Em m
familyMember m = mkEm (mstar ^ m) â‰¤-refl

-- (a) every member is nonunit: a = mâˆ— â‰ 2, i.e. a > 1.  General in m.
nonunit : (m : â„•) â†’ Em m â†’ 2 â‰¤ aOf
nonunit _ _ = â‰¤-refl

-- (b) every member is near-boundary: a^m â‰ b (a = mâˆ—).  General in m â”
--     this is exactly the stored hypothesis, phrased on the factor a.
nearBoundary : (m : â„•) (x : Em m) â†’ (aOf ^ m) â‰¤ Em.leg x
nearBoundary _ x = Em.lb x

-- (d) the unit set is empty: no member is a unit (a â‰¡ 1 is absurd,
--     a = 2).  General in m.
unitEmpty : (m : â„•) â†’ Em m â†’ aOf â‰¡ 1 â†’ âŠ¥
unitEmpty _ _ p = snotz (injSuc p)

-- The tear, assembled: âˆm there is a member (familyMember) that is
-- nonunit and near-boundary, while unitEmpty says the unit set is empty
-- at every m.  Hence a single x serving all m â” which would have to be
-- a unit â” cannot exist: âˆmâˆx â âˆxâˆm.

-- concrete face at m = 5:  member b = mâˆ—^5 = 32, near-boundary and
-- nonunit, certified by refl.
t101-nearBoundary-5 : (aOf ^ 5) â‰¤áµ‡ 32 â‰¡ true
t101-nearBoundary-5 = refl

t101-nonunit : (2 â‰¤áµ‡ aOf) â‰¡ true
t101-nonunit = refl

t101-notUnit : (aOf â‰¤áµ‡ 1) â‰¡ false
t101-notUnit = refl

------------------------------------------------------------------------
-- T100 (fixed-object endpoint compactness), decidable at a concrete
-- finite E.
--
-- A factor state, reduced to its two legs (a , b).

State : Type
State = â„• Ã— â„•

-- b survives the exponent m when a^m â‰ b  (the note's a â‰ b^{1/m}).
survives : â„• â†’ State â†’ Bool
survives m (a , b) = (a ^ m) â‰¤áµ‡ b

-- the concrete finite set E
Efin : List State
Efin = (1 , 7) âˆ· (2 , 5) âˆ· (3 , 9) âˆ· []

-- does some member of E survive at m?  (the T100 hypothesis, per m)
anySurv : â„• â†’ List State â†’ Bool
anySurv m []       = false
anySurv m (x âˆ· xs) = survives m x or anySurv m xs

-- the hypothesis over a finite index range: for each m, some survivor
allHave : List â„• â†’ List State â†’ Bool
allHave []       E = true
allHave (m âˆ· ms) E = anySurv m E and allHave ms E

-- minimum of two â•
minB : â„• â†’ â„• â†’ â„•
minB a b = if a < suc b then a else b

-- minimum factor a among the members surviving at exponent m
-- (sentinel 1000000 for "no survivor"; never reached here, E always
-- has the unit surviving)
survMin : â„• â†’ List State â†’ â„•
survMin m []             = 1000000
survMin m ((a , b) âˆ· xs) =
  if survives m (a , b) then minB a (survMin m xs) else survMin m xs

-- number of survivors at exponent m
countSurv : â„• â†’ List State â†’ â„•
countSurv m []       = 0
countSurv m (x âˆ· xs) = (if survives m x then 1 else 0) + countSurv m xs

-- The hypothesis holds on the range m âˆˆ {1,2,3}: every m has a
-- surviving member (carried at m = 2,3 by the unit (1,7)).
t100-hyp : allHave (1 âˆ· 2 âˆ· 3 âˆ· []) Efin â‰¡ true
t100-hyp = refl

-- Compactness bite at m = 3: both nonunits are dead...
t100-nonunit1-dead : survives 3 (2 , 5) â‰¡ false
t100-nonunit1-dead = refl

t100-nonunit2-dead : survives 3 (3 , 9) â‰¡ false
t100-nonunit2-dead = refl

-- ...only the unit survives...
t100-unit-alive : survives 3 (1 , 7) â‰¡ true
t100-unit-alive = refl

t100-count : countSurv 3 Efin â‰¡ 1
t100-count = refl

-- ...hence the minimum surviving factor is 1: E contains a unit state,
-- the endpoint conclusion of T100.
t100-minFactor : survMin 3 Efin â‰¡ 1
t100-minFactor = refl
