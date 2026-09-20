{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- JyesthaMulaMatra_TheGreaterRootAloneMisreadsANonSquarefreePrakrti
--
-- àµà°àà—ààà°à•ààà¿ (varga-prakti), `xÂ² âˆ’ N yÂ² = 1`.  Brahmagupta,
-- *Brhmasphuasiddhnta*, ch. 18 (Kuakdhyya), 628 CE, states the
-- àà¾àµà¨à¾ (bhvan) composition law and names the parts:
--
--   ààà°à•ààà¿    prakti       the multiplier N
--   ààà¯àààà à®àà²  jyeha-mla  the GREATER root, x
--   à•à¨à¿ààà à®àà²  kaniha-mla the LESSER root, y
--   à•àààà      kepa         the interpolator (here 1)
--
-- The cyclic method àà•àà°àµà¾à² (cakravla), which produces a least solution
-- for every non-square prakti: Jayadeva (~950, surviving only in
-- Udayadivkara's commentary *Sundar*), in full with worked praktis
-- 61, 67, 103 in Bhskara II, *Bjagaita*, 1150.  "Pell's equation" is
-- Euler's misattribution, ~1730; see notes/NOT_PELL_IT_IS_VARGAPRAKRITI.md.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS MODULE IS FOR
--
-- `collab/swarm/2026-08-14/swarm-0814-08-chebyshev-weight-pell.md` Â§3
-- gives a search-free test for whether a solution is the least one:
--
--   (x,y) is least  âŸº  for no prime p < B is there an integer u â‰ 2
--                       with T_p(u) = x AND (uÂ²âˆ’1)/N a perfect square,
--   where B = log(2x)/log(2+âˆN).
--
-- Its Â§8 leaves one item open, tagged PROVE:
--
--   "is the side condition `(uÂ²âˆ’1)/N a perfect square` redundant? â¦
--    the missing step is integrality.  If N | uÂ²âˆ’1 always follows, the
--    criterion becomes a pure one-variable root extraction with no
--    arithmetic side condition.  I could not close it."
--
-- IT DOES NOT FOLLOW, and the counterexample lies INSIDE the criterion's
-- own bound, so it is not repaired by tightening B.
--
--   prakti N = 28 = 2Â²Â7,  jyeha 127, kaniha 24,  p = 2,  u = 8.
--
--   127Â² = 28Â24Â² + 1;  Tâ(8) = 127;  28 âˆ 63 = 8Â²âˆ’1;  and (127,24) is
--   the LEAST solution.  B = log(254)/log(2+âˆ28) = 2.7872â¦, so p = 2 is
--   admissible.  The criterion with the side condition deleted answers
--   NOT LEAST on a solution that IS least.
--
-- Two further instances are carried so the phenomenon is not read off
-- one number, and so that it cannot be dismissed as a p = 2 artifact:
--
--   N = 45 = 3Â²Â5,  jyeha 161,  kaniha 24,  p = 2, u = 9, B = 2.6681â¦
--   N = 175 = 5Â²Â7, jyeha 2024, kaniha 153, p = 3, u = 8, B = 3.0500â¦
--
-- WHY, exhibited: the p-th root is not missing, it is in a LARGER order.
-- âˆ28 = 2âˆ7, so â[âˆ28] = â + 2â[âˆ7] has conductor 2 in â[âˆ7]; and
-- âˆ45 = 3âˆ5, conductor 3 in â[âˆ5].
--
--   8Â² = 7Â3Â² + 1                     (8+3âˆ7 has norm 1 in â[âˆ7])
--   8Â8 + 7Â(3Â3) = 127               bhvan, greater root
--   8Â3 + 3Â8    = 48 = 2Â24          bhvan, lesser root
--
-- so (8+3âˆ7)Â² = 127 + 48âˆ7 = 127 + 24âˆ28.  The root 8+3âˆ7 lies in â[âˆ7]
-- and NOT in â[âˆ28].  Its trace 16 is an integer either way â” which is
-- the mechanism: `T_p(u) = x` constrains the TRACE alone, and a trace
-- cannot see which order its element inhabits.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED HERE
--
--   ==refl, â‰from, and-fst/snd, Allâ‰, Allâ‰-sound
--                        a bounded universal quantifier WITH its
--                        soundness lemma, so a `refl` on the fold is a
--                        proof over the whole range and not a sample
--   sq-mono              m â‰ n â’ mÂm â‰ nÂn
--   target-mono          y â‰ Y â’ N yÂ² + 1 â‰ N YÂ² + 1
--   root-bound           a square equal to a target with y â‰ Y has root
--                        â‰ xmax, given (xmax+1)Â² > target N Y
--   least-solution       the generic statement: grid true + range bound
--                        â’ no solution with 1 â‰ y â‰ Y
--   âˆ-scan, âˆ-from       non-divisibility, certified once and reused:
--                        NÂn â‰¡ M with N â‰ 1 forces n â‰ M, so the
--                        cofactor search is finite and exhaustive
--   least-28/45/175      the three instances
--   vargaprakrti-*       the solutions themselves
--   chebyshev-*          T over â by its own recurrence, at the
--                        witnesses: Tâ(8)=127, Tâ(9)=161, Tâ(8)=2024
--   prakrti-âˆ-*          28 âˆ 63, 45 âˆ 80, 175 âˆ 63, so the side
--                        condition fails non-integrally, not merely
--                        non-squarely
--   lesser-1/2-not-in    at N = 175 the CUBE is the first power to enter
--                        the small order: 5 divides neither 3 nor 48
--   grid-is-live-*       KNOWN-FALSE CONTROL: widened to reach the real
--                        solution the same search returns `false`, so
--                        the `true` above is not vacuous
--
-- The complementary positive half â” a SQUAREFREE prakti makes the side
-- condition redundant â” is a three-line valuation argument, written out
-- in collab/messages/2093 and not formalized here.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, `agda <file>` â’ EXIT 0.  --safe,
-- no postulates, no holes, no TERMINATING pragma.
------------------------------------------------------------------------

module JyesthaMulaMatra_TheGreaterRootAloneMisreadsANonSquarefreePrakrti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; Â·-comm ; +-comm ; Â·-identityË¡)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-Â·k ; â‰¤-+k ; â‰¤-antisym ; â‰¤-trans ; <â‰¤-trans ; â‰¤-split
        ; pred-â‰¤-pred ; â‰¤0â†’â‰¡0 ; splitâ„•-â‰¤ ; Â¬m<m)
open import Cubical.Data.Int using (â„¤ ; pos) renaming (_-_ to _-â„¤_ ; _Â·_ to _Â·â„¤_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; trueâ‰¢false)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Agda.Builtin.Nat using (_==_)

------------------------------------------------------------------------
-- 0.  Boolean scaffolding: decisions turned into propositions
------------------------------------------------------------------------

==refl : (n : â„•) â†’ (n == n) â‰¡ true
==refl zero    = refl
==refl (suc n) = ==refl n

â‰¢from : (m n : â„•) â†’ (m == n) â‰¡ false â†’ Â¬ (m â‰¡ n)
â‰¢from m n q p = trueâ‰¢false (sym (==refl m) âˆ™ cong (m ==_) p âˆ™ q)

and-fst : (a b : Bool) â†’ (a and b) â‰¡ true â†’ a â‰¡ true
and-fst true  b p = refl
and-fst false b p = âŠ¥.rec (trueâ‰¢false (sym p))

and-snd : (a b : Bool) â†’ (a and b) â‰¡ true â†’ b â‰¡ true
and-snd true  b p = p
and-snd false b p = âŠ¥.rec (trueâ‰¢false (sym p))

-- A bounded universal quantifier, and the fact that its `true` really
-- means "at every point of the range".  Without Allâ‰-sound a `refl` on
-- the fold would be a sample; with it, the fold is a finite exhaustive
-- verification, which CLAUDE.md counts as proof.
Allâ‰¤ : (â„• â†’ Bool) â†’ â„• â†’ Bool
Allâ‰¤ f zero    = f zero
Allâ‰¤ f (suc n) = f (suc n) and Allâ‰¤ f n

Allâ‰¤-sound : (f : â„• â†’ Bool) (n : â„•) â†’ Allâ‰¤ f n â‰¡ true
           â†’ (k : â„•) â†’ k â‰¤ n â†’ f k â‰¡ true
Allâ‰¤-sound f zero    h k kâ‰¤n  = subst (Î» z â†’ f z â‰¡ true) (sym (â‰¤0â†’â‰¡0 kâ‰¤n)) h
Allâ‰¤-sound f (suc n) h k kâ‰¤sn with â‰¤-split kâ‰¤sn
... | inr kâ‰¡sn = subst (Î» z â†’ f z â‰¡ true) (sym kâ‰¡sn) (and-fst _ _ h)
... | inl k<sn = Allâ‰¤-sound f n (and-snd _ _ h) k (pred-â‰¤-pred k<sn)

------------------------------------------------------------------------
-- 1.  Order scaffolding
------------------------------------------------------------------------

-- `a â‰ b` for literals, from a witness the caller supplies
litâ‰¤ : (a b k : â„•) â†’ k + a â‰¡ b â†’ a â‰¤ b
litâ‰¤ a b k p = k , p

clash : (a b : â„•) â†’ a â‰¤ b â†’ b â‰¤ a â†’ (a == b) â‰¡ false â†’ âŠ¥
clash a b p q d = â‰¢from a b d (â‰¤-antisym p q)

sq-mono : (m n : â„•) â†’ m â‰¤ n â†’ (m Â· m) â‰¤ (n Â· n)
sq-mono m n h =
  â‰¤-trans (subst ((m Â· m) â‰¤_) (Â·-comm n m) (â‰¤-Â·k {k = m} h))
          (â‰¤-Â·k {k = n} h)

------------------------------------------------------------------------
-- 1Â½.  Non-divisibility, certified once and reused
------------------------------------------------------------------------

-- If N â‰ 1 and NÂn â‰¡ M then n â‰ M, so the cofactor search is finite.
âˆ¤-scan : â„• â†’ â„• â†’ Bool
âˆ¤-scan N M = Allâ‰¤ (Î» n â†’ not ((N Â· n) == M)) M

âˆ¤-from : (N M : â„•) â†’ 1 â‰¤ N â†’ âˆ¤-scan N M â‰¡ true
       â†’ Â¬ (Î£[ n âˆˆ â„• ] N Â· n â‰¡ M)
âˆ¤-from N M hN g (n , p) = trueâ‰¢false (sym q âˆ™ cong not r)
  where
    nbound : n â‰¤ M
    nbound = subst (n â‰¤_) p (subst (_â‰¤ (N Â· n)) (Â·-identityË¡ n) (â‰¤-Â·k {k = n} hN))
    q : not ((N Â· n) == M) â‰¡ true
    q = Allâ‰¤-sound (Î» z â†’ not ((N Â· z) == M)) M g n nbound
    r : ((N Â· n) == M) â‰¡ true
    r = cong ((N Â· n) ==_) (sym p) âˆ™ ==refl (N Â· n)

------------------------------------------------------------------------
-- 2.  The generic least-solution certificate
------------------------------------------------------------------------

-- the quantity under test: N yÂ² + 1, which a greater root must square to
target : â„• â†’ â„• â†’ â„•
target N y = N Â· (y Â· y) + 1

row : â„• â†’ â„• â†’ â„• â†’ Bool
row N xmax y = Allâ‰¤ (Î» x â†’ not ((x Â· x) == target N y)) xmax

-- y runs over 1 â¦ suc m
grid : â„• â†’ â„• â†’ â„• â†’ Bool
grid N xmax m = Allâ‰¤ (Î» y â†’ row N xmax (suc y)) m

target-mono : (N Y y : â„•) â†’ y â‰¤ Y â†’ target N y â‰¤ target N Y
target-mono N Y y h =
  â‰¤-+k (subst2 _â‰¤_ (Â·-comm (y Â· y) N) (Â·-comm (Y Â· Y) N)
                   (â‰¤-Â·k {k = N} (sq-mono y Y h)))

root-bound : (N xmax Y x y : â„•)
           â†’ target N Y < (suc xmax) Â· (suc xmax)
           â†’ y â‰¤ Y â†’ x Â· x â‰¡ target N y â†’ x â‰¤ xmax
root-bound N xmax Y x y wide hy p with splitâ„•-â‰¤ x xmax
... | inl xâ‰¤xmax = xâ‰¤xmax
... | inr xmax<x =
  âŠ¥.rec (Â¬m<m (<â‰¤-trans wide
                 (â‰¤-trans (subst ((suc xmax Â· suc xmax) â‰¤_) p
                                 (sq-mono (suc xmax) x xmax<x))
                          (target-mono N Y y hy))))

-- THE STATEMENT: a true grid plus a range bound is a proof that no
-- lesser root in 1 â¦ suc m solves the equation.
least-solution : (N xmax m : â„•)
               â†’ grid N xmax m â‰¡ true
               â†’ target N (suc m) < (suc xmax) Â· (suc xmax)
               â†’ (x y : â„•) â†’ 1 â‰¤ y â†’ y â‰¤ suc m â†’ Â¬ (x Â· x â‰¡ target N y)
least-solution N xmax m g wide x zero h1 h2 p =
  âŠ¥.rec (â‰¢from 1 0 refl (â‰¤-antisym h1 (litâ‰¤ 0 1 1 refl)))
least-solution N xmax m g wide x (suc y) h1 h2 p = trueâ‰¢false (sym q âˆ™ cong not r)
  where
    q : not ((x Â· x) == target N (suc y)) â‰¡ true
    q = Allâ‰¤-sound (Î» z â†’ not ((z Â· z) == target N (suc y))) xmax
          (Allâ‰¤-sound (Î» z â†’ row N xmax (suc z)) m g y (pred-â‰¤-pred h2))
          x (root-bound N xmax (suc m) x (suc y) wide h2 p)
    r : ((x Â· x) == target N (suc y)) â‰¡ true
    r = cong ((x Â· x) ==_) (sym p) âˆ™ ==refl (x Â· x)

------------------------------------------------------------------------
-- 3.  Chebyshev of the first kind, over â, by its own recurrence
------------------------------------------------------------------------

-- Tâ = 1, Tâ = u, T_{n+2} = 2uÂT_{n+1} âˆ’ T_n.  No norm-one hypothesis
-- enters the definition; the recurrence is a fact about â[X].
cheb : â„¤ â†’ â„• â†’ â„¤
cheb u zero          = pos 1
cheb u (suc zero)    = u
cheb u (suc (suc n)) = ((pos 2 Â·â„¤ u) Â·â„¤ cheb u (suc n)) -â„¤ cheb u n

------------------------------------------------------------------------
-- 4.  ààà°à•ààà¿ 28 = 2Â²Â7 â” the witness
------------------------------------------------------------------------

vargaprakrti-28 : 127 Â· 127 â‰¡ target 28 24
vargaprakrti-28 = refl

chebyshev-two-at-eight : cheb (pos 8) 2 â‰¡ pos 127
chebyshev-two-at-eight = refl

grid-28 : grid 28 121 22 â‰¡ true
grid-28 = refl

-- 14813 = target 28 23 < 14884 = 122Â²
wide-28 : target 28 23 < (suc 121) Â· (suc 121)
wide-28 = litâ‰¤ 14814 14884 70 refl

least-28 : (x y : â„•) â†’ 1 â‰¤ y â†’ y â‰¤ 23 â†’ Â¬ (x Â· x â‰¡ target 28 y)
least-28 = least-solution 28 121 22 grid-28 wide-28

-- the side condition: (uÂ²âˆ’1)/N is not even an integer, since 28 âˆ 63
prakrti-âˆ¤-28 : Â¬ (Î£[ n âˆˆ â„• ] 28 Â· n â‰¡ 63)
prakrti-âˆ¤-28 = âˆ¤-from 28 63 (litâ‰¤ 1 28 27 refl) refl

------------------------------------------------------------------------
-- 5.  ààà°à•ààà¿ 45 = 3Â²Â5 â” the second instance
------------------------------------------------------------------------

vargaprakrti-45 : 161 Â· 161 â‰¡ target 45 24
vargaprakrti-45 = refl

chebyshev-two-at-nine : cheb (pos 9) 2 â‰¡ pos 161
chebyshev-two-at-nine = refl

grid-45 : grid 45 155 22 â‰¡ true
grid-45 = refl

-- 23806 = target 45 23 < 24336 = 156Â²
wide-45 : target 45 23 < (suc 155) Â· (suc 155)
wide-45 = litâ‰¤ 23807 24336 529 refl

least-45 : (x y : â„•) â†’ 1 â‰¤ y â†’ y â‰¤ 23 â†’ Â¬ (x Â· x â‰¡ target 45 y)
least-45 = least-solution 45 155 22 grid-45 wide-45

prakrti-âˆ¤-45 : Â¬ (Î£[ n âˆˆ â„• ] 45 Â· n â‰¡ 80)
prakrti-âˆ¤-45 = âˆ¤-from 45 80 (litâ‰¤ 1 45 44 refl) refl

------------------------------------------------------------------------
-- 5Â½.  ààà°à•ààà¿ 175 = 5Â²Â7 at p = 3 â” the failure is not a p = 2 artifact
------------------------------------------------------------------------

-- 8 + 3âˆ7 again, but now it is the CUBE that lands in the small order:
-- the lesser roots of its powers are 3, 48, 765, and 5 divides only the
-- third.  So Îµâ(175) = (8+3âˆ7)Â³ = 2024 + 765âˆ7 = 2024 + 153âˆ175.
-- B = log(4048)/log(2+âˆ175) = 3.0500â¦, so p = 3 is admissible.

vargaprakrti-175 : 2024 Â· 2024 â‰¡ target 175 153
vargaprakrti-175 = refl

chebyshev-three-at-eight : cheb (pos 8) 3 â‰¡ pos 2024
chebyshev-three-at-eight = refl

grid-175 : grid 175 2010 151 â‰¡ true
grid-175 = refl

-- 4043201 = target 175 152 < 4044121 = 2011Â²
wide-175 : target 175 152 < (suc 2010) Â· (suc 2010)
wide-175 = litâ‰¤ 4043202 4044121 919 refl

least-175 : (x y : â„•) â†’ 1 â‰¤ y â†’ y â‰¤ 152 â†’ Â¬ (x Â· x â‰¡ target 175 y)
least-175 = least-solution 175 2010 151 grid-175 wide-175

-- 175 âˆ 63 for the trivial reason that 175 > 63 > 0
prakrti-âˆ¤-175 : Â¬ (Î£[ n âˆˆ â„• ] 175 Â· n â‰¡ 63)
prakrti-âˆ¤-175 = âˆ¤-from 175 63 (litâ‰¤ 1 175 174 refl) refl

-- the lesser root of the cube: bâ = bÂUâ(a), with Uâ(8) = 4Â8Â²âˆ’1 = 255
U2-at-8 : 4 Â· (8 Â· 8) â‰¡ 255 + 1
U2-at-8 = refl

cube-lesser-7 : 3 Â· 255 â‰¡ 5 Â· 153
cube-lesser-7 = refl

-- and 5 divides neither of the two earlier lesser roots, which is why
-- the cube and not the square is the first to enter â[âˆ175]
lesser-1-not-in : Â¬ (Î£[ n âˆˆ â„• ] 5 Â· n â‰¡ 3)
lesser-1-not-in = âˆ¤-from 5 3 (litâ‰¤ 1 5 4 refl) refl

lesser-2-not-in : Â¬ (Î£[ n âˆˆ â„• ] 5 Â· n â‰¡ 48)
lesser-2-not-in = âˆ¤-from 5 48 (litâ‰¤ 1 5 4 refl) refl

------------------------------------------------------------------------
-- 6.  KNOWN-FALSE CONTROL â” the search is not vacuous
------------------------------------------------------------------------

-- Widen the row until it can reach the real greater root and the same
-- fold returns `false`.  A search that could only ever say `true` would
-- prove nothing; these two lines are what make Â§4â“Â§5 informative.
grid-is-live-28 : Allâ‰¤ (Î» x â†’ not ((x Â· x) == target 28 24)) 127 â‰¡ false
grid-is-live-28 = refl

grid-is-live-28â€² : Allâ‰¤ (Î» x â†’ not ((x Â· x) == target 28 24)) 126 â‰¡ true
grid-is-live-28â€² = refl

grid-is-live-45 : Allâ‰¤ (Î» x â†’ not ((x Â· x) == target 45 24)) 161 â‰¡ false
grid-is-live-45 = refl

grid-is-live-45â€² : Allâ‰¤ (Î» x â†’ not ((x Â· x) == target 45 24)) 160 â‰¡ true
grid-is-live-45â€² = refl

------------------------------------------------------------------------
-- 7.  The p-th root, exhibited in the larger order
------------------------------------------------------------------------

-- 8 + 3âˆ7 has norm one in â[âˆ7]; 9 + 4âˆ5 has norm one in â[âˆ5].
root-order-7 : 8 Â· 8 â‰¡ 7 Â· (3 Â· 3) + 1
root-order-7 = refl

root-order-5 : 9 Â· 9 â‰¡ 5 Â· (4 Â· 4) + 1
root-order-5 = refl

-- Brahmagupta's àà¾àµà¨à¾ of a root with itself:
--   greater â¦ ac + N bd,   lesser â¦ ad + bc
-- and the lesser root comes out divisible by the conductor.
bhavana-square-7-greater : 8 Â· 8 + 7 Â· (3 Â· 3) â‰¡ 127
bhavana-square-7-greater = refl

bhavana-square-7-lesser : 8 Â· 3 + 3 Â· 8 â‰¡ 2 Â· 24
bhavana-square-7-lesser = refl

bhavana-square-5-greater : 9 Â· 9 + 5 Â· (4 Â· 4) â‰¡ 161
bhavana-square-5-greater = refl

bhavana-square-5-lesser : 9 Â· 4 + 4 Â· 9 â‰¡ 3 Â· 24
bhavana-square-5-lesser = refl

-- The traces are integers on both sides of the conductor, which is why
-- a trace-only criterion cannot separate the two orders.
trace-7 : 8 + 8 â‰¡ 16
trace-7 = refl

trace-5 : 9 + 9 â‰¡ 18
trace-5 = refl
