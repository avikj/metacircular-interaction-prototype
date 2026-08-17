{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Rank1DihedralChart
--
-- R0032, kernel-audited.  codex-catuskoti's standing dissent (the
-- corpus's oldest: R0032 was author-proved and never independently
-- audited) is answered by a checker, not a reviewer: the rank-one
-- cell A = (2 0 / 1 0), D = diag(1,0) has stabilizer
-- S(b,e) = (1 b / 0 e); the chart U(k,s) = (k 1−2k / −s 2s) lies in
-- the transporter and reads back as (U₀₀, det U) = (k, s); the
-- stabilizer acts by the intertwining law S(b,e)·U(k,s) = U(k−bs, es)
-- (a pure ring identity — no sign hypothesis); the action is
-- TRANSITIVE with the explicit transporter S((k−k')s, s's); and it is
-- FREE with no integrality: b = b·(s·s) = (b·s)·s = 0.
--
-- Sign-ness enters only as s·s ≡ 1, exactly where R0032's prose said
-- "e ∈ {±1}".  Toolchain notes: literals appear additively (2k as
-- k+k); lemmas that would put a bare 1r under the solver instead
-- generalize the literal to a variable and instantiate at 1r, letting
-- ℤ's reduction (1r·x → x, first-arg literal products compute) close
-- the judgmental gap.
------------------------------------------------------------------------

module Rank1DihedralChart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (det)

open CommRingStr (ℤCommRing .snd)

Amat Dmat : M
Amat = (1r + 1r , 0r , 1r , 0r)
Dmat = dia 1r 0r

S : R → R → M
S b e = (1r , b , 0r , e)

U : R → R → M
U k s = (k , 1r - (k + k) , - s , s + s)

-- shared small lemmas -------------------------------------------------

private
  z+ : (x y : R) → 0r + x · y ≡ x · y
  z+ _ _ = solve! ℤCommRing
  z+' : (x y : R) → 0r + x · y ≡ y · x
  z+' _ _ = solve! ℤCommRing
  addBack : (a b : R) → a + (b - a) ≡ b
  addBack _ _ = solve! ℤCommRing

-- the stabilizer fixes the endpoint ----------------------------------

stabFixes : (b e : R) → mul (S b e) Dmat ≡ Dmat
stabFixes b e i = ( e11 i , e12 i , e21 i , e22 i )
  where
  e11 : 1r + b · 0r ≡ 1r         -- 1r·1r reduced; then a+0r reduces
  e11 = cong (1r +_) (·Comm b 0r)
  e12 : 0r + b · 0r ≡ 0r
  e12 = lem b
    where
    lem : (b : R) → 0r + b · 0r ≡ 0r
    lem _ = solve! ℤCommRing
  e21 : 0r + e · 0r ≡ 0r
  e21 = lem e
    where
    lem : (e : R) → 0r + e · 0r ≡ 0r
    lem _ = solve! ℤCommRing
  e22 : 0r + e · 0r ≡ 0r
  e22 = e21

-- the dihedral composition law ---------------------------------------

stabLaw : (b e b' e' : R)
        → mul (S b e) (S b' e') ≡ S (b' + b · e') (e · e')
stabLaw b e b' e' i = ( e11 i , e12 i , e21 i , e22 i )
  where
  e11 : 1r + b · 0r ≡ 1r
  e11 = cong (1r +_) (·Comm b 0r)
  e12 : b' + b · e' ≡ b' + b · e'   -- 1r·b' reduced to b'
  e12 = refl
  e21 : 0r + e · 0r ≡ 0r
  e21 = lem e
    where
    lem : (e : R) → 0r + e · 0r ≡ 0r
    lem _ = solve! ℤCommRing
  e22 : 0r + e · e' ≡ e · e'
  e22 = z+ e e'

-- the chart lands in the transporter ---------------------------------

inTransporter : (k s : R) → mul (U k s) Amat ≡ Dmat
inTransporter k s i = ( e11 i , e12 i , e21 i , e22 i )
  where
  e11 : k · (1r + 1r) + (1r - (k + k)) · 1r ≡ 1r
  e11 = cong₂ _+_ (·Comm k (1r + 1r)) (·IdR (1r - (k + k)))
        ∙ addBack (k + k) 1r
  e12 : k · 0r + (1r - (k + k)) · 0r ≡ 0r
  e12 = cong₂ _+_ (·Comm k 0r) (·Comm (1r - (k + k)) 0r)
  e21 : (- s) · (1r + 1r) + (s + s) · 1r ≡ 0r
  e21 = cong₂ _+_ (·Comm (- s) (1r + 1r)) (·IdR (s + s))
        ∙ lem s
    where
    lem : (s : R) → ((- s) + (- s)) + (s + s) ≡ 0r
    lem _ = solve! ℤCommRing
  e22 : (- s) · 0r + (s + s) · 0r ≡ 0r
  e22 = cong₂ _+_ (·Comm (- s) 0r) (·Comm (s + s) 0r)

-- the chart reads back: U₀₀ = k definitionally, det = s ---------------

detChart : (k s : R) → det (U k s) ≡ s
detChart k s = dGen k s 1r
  where
  -- at u = 1r the RHS u·s reduces to s judgmentally
  dGen : (k s u : R)
       → k · (s + s) - (u - (k + k)) · (- s) ≡ u · s
  dGen _ _ _ = solve! ℤCommRing

-- the intertwining law: pure polynomial, no sign hypothesis ----------

intertwine : (b e k s : R)
           → mul (S b e) (U k s) ≡ U (k - b · s) (e · s)
intertwine b e k s i = ( w11 i , w12 i , w21 i , w22 i )
  where
  w11 : k + b · (- s) ≡ k - b · s      -- 1r·k reduced
  w11 = lem b k s
    where
    lem : (b k s : R) → k + b · (- s) ≡ k - b · s
    lem _ _ _ = solve! ℤCommRing
  w12 : (1r - (k + k)) + b · (s + s)
      ≡ 1r - ((k - b · s) + (k - b · s))
  w12 = wGen b k s 1r
    where
    wGen : (b k s u : R)
         → (u - (k + k)) + b · (s + s)
           ≡ u - ((k - b · s) + (k - b · s))
    wGen _ _ _ _ = solve! ℤCommRing
  w21 : 0r + e · (- s) ≡ - (e · s)
  w21 = lem e s
    where
    lem : (e s : R) → 0r + e · (- s) ≡ - (e · s)
    lem _ _ = solve! ℤCommRing
  w22 : 0r + e · (s + s) ≡ e · s + e · s
  w22 = lem e s
    where
    lem : (e s : R) → 0r + e · (s + s) ≡ e · s + e · s
    lem _ _ = solve! ℤCommRing

-- transitivity: the explicit transporter between chart points --------

private
  sqK : (k k' s : R) → s · s ≡ 1r
      → k - ((k - k') · s) · s ≡ k'
  sqK k k' s hs =
    step1 k k' s
    ∙ cong (λ w → k - (k - k') · w) hs
    ∙ cong (λ w → k - w) (·IdR (k - k'))
    ∙ step2 k k'
    where
    step1 : (k k' s : R)
          → k - ((k - k') · s) · s ≡ k - (k - k') · (s · s)
    step1 _ _ _ = solve! ℤCommRing
    step2 : (k k' : R) → k - (k - k') ≡ k'
    step2 _ _ = solve! ℤCommRing
  sqS : (s s' : R) → s · s ≡ 1r → (s' · s) · s ≡ s'
  sqS s s' hs = sym (·Assoc s' s s) ∙ cong (s' ·_) hs ∙ ·IdR s'

transitive : (k s k' s' : R) → s · s ≡ 1r
           → mul (S ((k - k') · s) (s' · s)) (U k s) ≡ U k' s'
transitive k s k' s' hs =
  intertwine ((k - k') · s) (s' · s) k s
  ∙ λ i → U (sqK k k' s hs i) (sqS s s' hs i)

-- freeness: purely equational, no integrality ------------------------

freeB : (b s : R) → s · s ≡ 1r → b · s ≡ 0r → b ≡ 0r
freeB b s hs h0 =
  sym (·IdR b)
  ∙ cong (b ·_) (sym hs)
  ∙ ·Assoc b s s
  ∙ cong (_· s) h0     -- 0r · s reduces to 0r

freeE : (e s : R) → s · s ≡ 1r → e · s ≡ s → e ≡ 1r
freeE e s hs h1 =
  sym (·IdR e)
  ∙ cong (e ·_) (sym hs)
  ∙ ·Assoc e s s
  ∙ cong (_· s) h1
  ∙ hs

-- exhaustiveness: the chart covers the WHOLE transporter — and needs
-- no unimodularity: ANY integral matrix with U·A ≡ D is U(k,s) with
-- k = U₀₀ and s = −U₁₀ (whence det U = s automatically; s·s ≡ 1 is
-- exactly unimodularity).  Sharper than R0032's prose, which assumed
-- U unimodular before charting it.  This closes the audit boundary
-- stated in message 0003.

private
  fromSum : (x y w : R) → x + y ≡ w → y ≡ w - x
  fromSum x y w h = lem x y ∙ cong (λ v → v - x) h
    where
    lem : (x y : R) → y ≡ (x + y) - x
    lem _ _ = solve! ℤCommRing
  negNeg : (c : R) → c ≡ - (- c)
  negNeg _ = solve! ℤCommRing
  toPair : (c d : R) → d ≡ 0r - (c + c) → d ≡ (- c) + (- c)
  toPair c d h = h ∙ lem c
    where
    lem : (c : R) → 0r - (c + c) ≡ (- c) + (- c)
    lem _ = solve! ℤCommRing

exhaustive : (a b c d : R)
           → mul (a , b , c , d) Amat ≡ Dmat
           → (a , b , c , d) ≡ U a (- c)
exhaustive a b c d hU i = ( a , bEq i , negNeg c i , dEq i )
  where
  q1 : a · (1r + 1r) + b · 1r ≡ 1r
  q1 j = fst (hU j)
  q3 : c · (1r + 1r) + d · 1r ≡ 0r
  q3 j = fst (snd (snd (hU j)))

  norm : (x y : R) → x · (1r + 1r) + y · 1r ≡ (x + x) + y
  norm x y = cong₂ _+_ (·Comm x (1r + 1r)) (·IdR y)

  bEq : b ≡ 1r - (a + a)
  bEq = fromSum (a + a) b 1r (sym (norm a b) ∙ q1)

  dEq : d ≡ (- c) + (- c)
  dEq = toPair c d (fromSum (c + c) d 0r (sym (norm c d) ∙ q3))
