-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CayleyPairChart — Delta 21 §21.7 and §21.12, checked over ℤ
--
-- Delta 21 (owner, 2026-08-13) makes two structural claims about the
-- binary pair that are pure algebra, and therefore settleable rather
-- than assertable.  Both are checked here, with denominators cleared so
-- that the statements live over a commutative ring and the degenerate
-- points appear as explicit hypotheses instead of silent exclusions.
--
-- T21.11 (§21.7).  The Cayley transform x = (z−1)/(z+1) conjugates the
-- two involutions of the binary pair into each other:
--
--     leg exchange   z ↦ 1/z   becomes   x ↦ −x
--     sign flip      z ↦ −z    becomes   x ↦ 1/x
--
-- so — C21.12 — the whole involution story (split torus, Weyl
-- reflection, angular Jacobi coordinate, sum–gap inversion) is Möbius
-- geometry on P¹ and nothing more.  That is a simplification, and a
-- deflation: none of it was new geometry.
--
-- S21.19 (§21.12).  Fixed-sum and fixed-gap conditions are the two
-- linear forms L₊ = a+b and L₋ = a−b on projective direction space, and
-- the sum–gap duality is the one-leg sign involution a ↦ −a exchanging
-- them.  `sumGapDuality` below is that exchange, exactly.
--
-- Cleared forms.  Writing the chart as a RELATION x·(z+1) = z−1 rather
-- than a quotient costs nothing and buys everything: it is a statement
-- about ℤ, it needs no field, and the excluded points z = ±1 (which are
-- exactly the boundary C21.13 names) become the hypothesis of the one
-- theorem that needs them, `signFlipIsInversion`.
--
-- Note on the solver.  `1r` may not appear inside a `solve! ℤCommRing`
-- goal: ℤ's own reductions (z + 1r ↝ sucℤ z, z − 1r ↝ predℤ z) fire
-- before reflection, and the reflected expression then carries the
-- variable as a ring CONSTANT, so the normal forms do not match.  Every
-- lemma below is therefore stated with the unit abstracted to a
-- variable `e` and instantiated at `1r` afterwards — the idiom already
-- used by `Rank1DihedralChart.detChart`.  The abstraction is only legal
-- where the identity is homogeneous in (z, e); where it is not, the
-- unit is supplied by the library lemmas `·IdR` / `+IdL` instead.
------------------------------------------------------------------------

module CayleyPairChart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Int using (isIntegralℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R)

open CommRingStr (ℤCommRing .snd)

-- 1r-free solver lemmas ------------------------------------------------
--
-- Each is homogeneous in the abstracted unit `e`, so instantiating
-- e := 1r is the intended specialization and not a coincidence.

private
  scaleDiff : (β xi e : R) → β · xi - e · xi ≡ xi · (β - e)
  scaleDiff _ _ _ = solve! ℤCommRing

  negLeft : (x z e : R) → (- x) · (e + z) ≡ - (x · (z + e))
  negLeft _ _ _ = solve! ℤCommRing

  negDiff : (z e : R) → - (z - e) ≡ e - z
  negDiff _ _ = solve! ℤCommRing

  regroup : (x x' p q : R) → (x · x') · (p · q) ≡ (x · p) · (x' · q)
  regroup _ _ _ _ = solve! ℤCommRing

  -- the two cleared charts carry the SAME quadratic factor e² − z²
  sumFactor  : (z e : R) → (z + e) · ((- z) + e) ≡ e · e - z · z
  sumFactor _ _ = solve! ℤCommRing

  diffFactor : (z e : R) → (z - e) · ((- z) - e) ≡ e · e - z · z
  diffFactor _ _ = solve! ℤCommRing

  distSub : (k u v : R) → k · (u - v) ≡ k · u - k · v
  distSub _ _ _ = solve! ℤCommRing

  selfSub : (w : R) → w - w ≡ 0r
  selfSub _ = solve! ℤCommRing

  fromDiff : (u v : R) → u - v ≡ 0r → u ≡ v
  fromDiff u v p = addBack u v ∙ cong (_+ v) p ∙ +IdL v
    where
    addBack : (u v : R) → u ≡ (u - v) + v
    addBack _ _ = solve! ℤCommRing

-- the chart, as a relation ---------------------------------------------
--
-- `Chart z x` says: x is the Cayley image of z.  Over a field this is
-- x = (z−1)/(z+1); here it is the same statement with the denominator
-- multiplied out.

Chart : R → R → Type
Chart z x = x · (z + 1r) ≡ z - 1r

-- §21.5, T21.8: the compatibility tensor.  The additive root is the
-- multiplicative root displacement scaled by one endpoint — so there is
-- no basepoint-free identification of the two (C21.9).
compatibility : (xi xj β : R) → β · xi ≡ xj → xj - xi ≡ xi · (β - 1r)
compatibility xi xj β h = cong (_- xi) (sym h) ∙ scaleDiff β xi 1r

-- T21.11, first half: leg exchange becomes negation ---------------------
--
-- Exchanging the legs sends z to 1/z; cleared of denominators, the
-- claim is that the Cayley image of the exchanged pair is −x.  Note it
-- needs NO hypothesis: it is an identity, true even at the boundary.

legExchangeIsNegation : (z x : R) → Chart z x → (- x) · (1r + z) ≡ 1r - z
legExchangeIsNegation z x h =
  negLeft x z 1r ∙ cong (λ w → - w) h ∙ negDiff z 1r

-- T21.11, second half: sign flip becomes inversion ----------------------
--
-- Here the boundary is real and must be named.  If x' is the Cayley
-- image of −z, then x·x' = 1 — but only away from z² = 1, i.e. away
-- from z = ±1, which C21.13 identifies as the images of the interval
-- endpoints.  The hypothesis is exactly the degeneracy, not a
-- convenience.

signFlipIsInversion : (z x x' : R)
                    → Chart z x
                    → x' · ((- z) + 1r) ≡ (- z) - 1r
                    → ((1r - z · z) ≡ 0r → ⊥)
                    → x · x' ≡ 1r
signFlipIsInversion z x x' hx hx' nz =
  fromDiff (x · x') 1r (isIntegralℤ k ((x · x') - 1r) vanishes nz)
  where
  k : R
  k = 1r - z · z

  -- multiply the two cleared charts together: the product of the
  -- left-hand sides is (x·x')·k, the product of the right-hand sides
  -- is k itself.
  prod : (x · x') · ((z + 1r) · ((- z) + 1r)) ≡ (z - 1r) · ((- z) - 1r)
  prod = regroup x x' (z + 1r) ((- z) + 1r) ∙ cong₂ _·_ hx hx'

  fixed : k · (x · x') ≡ k
  fixed = cong (_· (x · x')) (sym (sumFactor z 1r))
        ∙ ·Comm ((z + 1r) · ((- z) + 1r)) (x · x')
        ∙ prod
        ∙ diffFactor z 1r

  vanishes : k · ((x · x') - 1r) ≡ 0r
  vanishes = distSub k (x · x') 1r
           ∙ cong₂ _-_ fixed (·IdR k)
           ∙ selfSub k

-- S21.19: sum–gap duality is the one-leg sign involution ---------------
--
-- Fixed sum tests the linear form L₊ = a+b; fixed gap tests L₋ = a−b.
-- Sending a ↦ −a exchanges the two hyperplanes, up to sign.  That is
-- the whole of the sum–gap duality, and it is one line.

Lplus Lminus : R → R → R
Lplus a b = a + b
Lminus a b = a - b

sumGapDuality : (a b : R) → Lplus (- a) b ≡ - (Lminus a b)
sumGapDuality _ _ = solve! ℤCommRing

gapSumDuality : (a b : R) → Lminus (- a) b ≡ - (Lplus a b)
gapSumDuality _ _ = solve! ℤCommRing
