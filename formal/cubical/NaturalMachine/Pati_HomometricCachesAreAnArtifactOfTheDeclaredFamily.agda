{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Pati_HomometricCachesAreAnArtifactOfTheDeclaredFamily
--
-- àà¾àŸà (p) â” the working board.
--
--
--   rdhara, *Pgaita* â” also *Bhat-P*, also *Navaat* ("having
--   900", for its 900 stanzas, of which 251 are extant).  rdhara is
--   dated 8thâ“9th century; the dating is disputed and MacTutor gives
--   870â“930, so no single year is asserted here.  The same genre runs on
--   through Bhskara II's *Llvat* (1150).
--
--   *P* is the board â” and is itself a non- loanword, which
--   is worth saying in a repository whose file-naming rule asks for the
--   source language rather than for  specifically.  Calculation
--   was done on dust or sand spread over that board, the operation
--   called *dhlikarma*, dust-work.  A quantity is SET DOWN, used, and
--   then WIPED so the space can carry the next quantity.  What survives
--   a step is what the operator chose to leave on the board; what is
--   wiped is gone, whatever its mathematical existence.
--
--   That erase-or-retain choice is the stated hypothesis of this
--   repository's addition-chain cache lane, put plainest at
--   notes/ADDITION_CHAIN_PROCESS_MEMORY.md Â§4 ("The persistence
--   boundary": if the runtime discards every intermediate, both
--   histories become (6,{6}) and no probe separates them).
--   `ls notes/ | grep -i 'cache\|chain'` returns 22 files, but that is
--   a name match and not a subject count â” at least three of the 22
--   (TOOLCHAIN_SKEW_AND_COVERAGE, NATURAL_MACHINE_TOOLCHAIN_DRIFT,
--   SEED85_FORMAL_LANE_STATUS_WITHOUT_A_TOOLCHAIN) are about the Agda
--   and Lean toolchain.  No count of the lane is asserted here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS CHECKED HERE
--
--   notes/FLEET_BREAKER_PASS_2026_08_14.md Â§6.4 refutes the
--   recommendation of notes/EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO.md Â§5
--   ("compile exact cache histories to their profile quotient") by
--   exhibiting a HOMOMETRIC PAIR: two caches, both reachable from {1},
--   with equal distance profiles on the declared family T = {11}, which
--   one exogenous control drives apart.  That witness is stated there in
--   one paragraph of hand arithmetic and, as of this writing, appears
--   nowhere else in the corpus and has never been independently
--   checked.
--
--   Here it is computed rather than asserted.  d_C(t) is the least
--   number of adjoin-a-sum steps until t is in the cache; every bound
--   below is a finite Bool computation closed by refl.
--
--     C = {1,2,4,6}   reached by  1+1, 2+2, 2+4     (legality checked)
--     D = {1,2,3,4}   reached by  1+1, 1+2, 1+3     (legality checked)
--
--     d_C(11) = 2 = d_D(11)                          homometric at {11}
--     uââ C = C âˆ {10},  d(11) = 1                   control fires on C
--     uââ D = D,          d(11) = 2                   control inert on D
--
--   And one thing Â§6.4 does not say, which is the reason the witness
--   had to look like that:
--
--     d_C(3) = 1  while  d_D(3) = 0
--
--   so the family T = {3,11} separates the pair with NO control at all.
--   The general statement, proved in the companion note and not here
--   (it quantifies over all caches, which this finite module does not):
--
--     if C â–³ D âŠ T then Î”_T(C) = Î”_T(D) implies C = D,
--
--   because d_X(t) = 0 exactly when t âˆˆ X.  So every homometric pair of
--   caches has a separating element OUTSIDE the declared family, and
--   the nontriviality of the profile quotient is a statement about T
--   alone, never about the dynamics.  Both sides are instantiated
--   below: T = {11} where homometry holds, T = {3,11} where it fails.
--
--   No claim is made about optimal chains, about quantum memory, or
--   about the general dichotomy being machine-checked.
------------------------------------------------------------------------

module NaturalMachine.Pati_HomometricCachesAreAnArtifactOfTheDeclaredFamily where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; _++_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

------------------------------------------------------------------------
-- 1.  Decidable membership on a board

eqN : â„• â†’ â„• â†’ Bool
eqN zero    zero    = true
eqN zero    (suc _) = false
eqN (suc _) zero    = false
eqN (suc m) (suc n) = eqN m n

infix 6 _âˆˆ?_
_âˆˆ?_ : â„• â†’ List â„• â†’ Bool
x âˆˆ? []       = false
x âˆˆ? (y âˆ· ys) = if eqN x y then true else (x âˆˆ? ys)

------------------------------------------------------------------------
-- 2.  The transition rule: adjoin one sum of two values already on the
--     board.  `oneStep C` lists every value adjoinable in one step.

addAll : â„• â†’ List â„• â†’ List â„•
addAll x []       = []
addAll x (y âˆ· ys) = (x + y) âˆ· addAll x ys

sumsFrom : List â„• â†’ List â„• â†’ List â„•
sumsFrom []       C = []
sumsFrom (x âˆ· xs) C = addAll x C ++ sumsFrom xs C

oneStep : List â„• â†’ List â„•
oneStep C = sumsFrom C C

twoStepFrom : List â„• â†’ List â„• â†’ List â„•
twoStepFrom []       C = []
twoStepFrom (z âˆ· zs) C = oneStep (z âˆ· C) ++ twoStepFrom zs C

twoStep : List â„• â†’ List â„•
twoStep C = twoStepFrom (oneStep C) C

------------------------------------------------------------------------
-- 3.  Legality.  A board is a cache only if it was actually formed from
--     {1}: every operand of every step must already be present when the
--     step is taken.  This is the non-vacuity control â” an unreachable
--     pair of sets would refute nothing about caches.

Step : Typeâ‚€
Step = â„• Ã— â„•

legal : List Step â†’ List â„• â†’ Bool
legal []             C = true
legal ((x , y) âˆ· ss) C =
  if x âˆˆ? C
    then (if y âˆˆ? C then legal ss ((x + y) âˆ· C) else false)
    else false

run : List Step â†’ List â„• â†’ List â„•
run []             C = C
run ((x , y) âˆ· ss) C = run ss ((x + y) âˆ· C)

seed : List â„•
seed = 1 âˆ· []

------------------------------------------------------------------------
-- 4.  The two boards of FLEET_BREAKER_PASS Â§6.4

chainC : List Step
chainC = (1 , 1) âˆ· (2 , 2) âˆ· (2 , 4) âˆ· []

chainD : List Step
chainD = (1 , 1) âˆ· (1 , 2) âˆ· (1 , 3) âˆ· []

C : List â„•
C = 6 âˆ· 4 âˆ· 2 âˆ· 1 âˆ· []

D : List â„•
D = 4 âˆ· 3 âˆ· 2 âˆ· 1 âˆ· []

-- 4.1  Both are legally formed from the seed.

C-legal : legal chainC seed â‰¡ true
C-legal = refl

C-forms : run chainC seed â‰¡ C
C-forms = refl

D-legal : legal chainD seed â‰¡ true
D-legal = refl

D-forms : run chainD seed â‰¡ D
D-forms = refl

-- 4.2  They are distinct boards, and 3 is one separating value.

three-off-C : 3 âˆˆ? C â‰¡ false
three-off-C = refl

three-on-D : 3 âˆˆ? D â‰¡ true
three-on-D = refl

------------------------------------------------------------------------
-- 5.  d_C(11) = 2 = d_D(11).  Each distance is pinned from both sides:
--     not 0, not 1, and achieved in 2.

C-11-not-0 : 11 âˆˆ? C â‰¡ false
C-11-not-0 = refl

C-11-not-1 : 11 âˆˆ? oneStep C â‰¡ false
C-11-not-1 = refl

C-11-in-2 : 11 âˆˆ? twoStep C â‰¡ true
C-11-in-2 = refl

D-11-not-0 : 11 âˆˆ? D â‰¡ false
D-11-not-0 = refl

D-11-not-1 : 11 âˆˆ? oneStep D â‰¡ false
D-11-not-1 = refl

D-11-in-2 : 11 âˆˆ? twoStep D â‰¡ true
D-11-in-2 = refl

------------------------------------------------------------------------
-- 6.  The control uââ : X â¦ X âˆ {10} if 10 âˆˆ X + X.  It fires on C and
--     is inert on D, and it drives the profiles apart.

ten-adjoinable-to-C : 10 âˆˆ? oneStep C â‰¡ true
ten-adjoinable-to-C = refl

ten-not-adjoinable-to-D : 10 âˆˆ? oneStep D â‰¡ false
ten-not-adjoinable-to-D = refl

uC : List â„•
uC = 10 âˆ· C

uC-11-not-0 : 11 âˆˆ? uC â‰¡ false
uC-11-not-0 = refl

uC-11-in-1 : 11 âˆˆ? oneStep uC â‰¡ true
uC-11-in-1 = refl

-- uââ D = D, so Â§5's D-facts already give d_{uââD}(11) = 2.
-- Hence 1 = d_{uââC}(11) â‰  d_{uââD}(11) = 2: the profile quotient at
-- T = {11} is not a congruence for this control.

------------------------------------------------------------------------
-- 7.  The other side, which Â§6.4 does not state.  Enlarging the declared
--     family to contain a member of C â–³ D separates the pair outright,
--     with no control applied.

C-3-not-0 : 3 âˆˆ? C â‰¡ false
C-3-not-0 = refl

C-3-in-1 : 3 âˆˆ? oneStep C â‰¡ true
C-3-in-1 = refl

D-3-in-0 : 3 âˆˆ? D â‰¡ true
D-3-in-0 = refl

-- So d_C(3) = 1 and d_D(3) = 0: Î”_{3,11}(C) = (1,2) â‰  (0,2) = Î”_{3,11}(D).
-- The homometry of Â§6.4 exists only because 3 and 6, the whole of
-- C â–³ D, lie outside T = {11}.

six-off-D : 6 âˆˆ? D â‰¡ false
six-off-D = refl

six-on-C : 6 âˆˆ? C â‰¡ true
six-on-C = refl

------------------------------------------------------------------------
-- 8.  CONTROLS.  Everything above is `refl` on a Bool, so every negative
--     result is worth exactly what the enumerator is worth: if `oneStep`
--     returned [] then `11 âˆˆ? oneStep C â‰¡ false` would hold and mean
--     nothing.  These fix that.

-- 8.1  `oneStep` is not empty and not truncated: it reaches the extremes
--      of C + C from both ends, and reports the two values (9, 11) that
--      genuinely are not sums of two members of C.

oneStep-C-has-2 : 2 âˆˆ? oneStep C â‰¡ true       -- 1 + 1, the minimum
oneStep-C-has-2 = refl

oneStep-C-has-12 : 12 âˆˆ? oneStep C â‰¡ true     -- 6 + 6, the maximum
oneStep-C-has-12 = refl

oneStep-C-has-7 : 7 âˆˆ? oneStep C â‰¡ true       -- 1 + 6, a cross term
oneStep-C-has-7 = refl

oneStep-C-lacks-9 : 9 âˆˆ? oneStep C â‰¡ false    -- 9 is genuinely not in C + C
oneStep-C-lacks-9 = refl

oneStep-D-has-8 : 8 âˆˆ? oneStep D â‰¡ true       -- 4 + 4, the maximum
oneStep-D-has-8 = refl

-- 8.2  `twoStep` likewise: it reaches strictly past `oneStep`, and stops
--      where two steps must stop (max 2Âmax(C + C) = 24).

twoStep-C-has-9 : 9 âˆˆ? twoStep C â‰¡ true       -- 3 = 1+2, then 3 + 6
twoStep-C-has-9 = refl

twoStep-C-has-24 : 24 âˆˆ? twoStep C â‰¡ true     -- 12 = 6+6, then 12 + 12
twoStep-C-has-24 = refl

twoStep-C-lacks-25 : 25 âˆˆ? twoStep C â‰¡ false  -- out of reach in two steps
twoStep-C-lacks-25 = refl

-- 8.3  `legal` actually rejects.  This chain asks for 3 + 3 when the
--      board holds only {1,2}; if `legal` accepted it, the legality
--      claims in Â§4.1 would be certifying nothing.

illegalChain : List Step
illegalChain = (1 , 1) âˆ· (3 , 3) âˆ· []

illegal-is-rejected : legal illegalChain seed â‰¡ false
illegal-is-rejected = refl

-- 8.4  And `legal` rejects on the second operand too, not only the first.

illegalChainâ‚‚ : List Step
illegalChainâ‚‚ = (1 , 1) âˆ· (2 , 5) âˆ· []

illegalâ‚‚-is-rejected : legal illegalChainâ‚‚ seed â‰¡ false
illegalâ‚‚-is-rejected = refl
