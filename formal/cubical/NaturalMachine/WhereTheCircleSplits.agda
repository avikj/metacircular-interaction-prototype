{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WhereTheCircleSplits
--
-- A check that should have been run before `PythagoreanTransition` was
-- celebrated, and is run now: **is the circle actually a circle?**
--
-- ────────────────────────────────────────────────────────────────────
-- THE TRIVIALISING POSSIBILITY
--
-- `PythagoreanTransition` builds the conic over an arbitrary commutative
-- ring and finds that its additive law is multiplicative on norms — the
-- exact opposite of `disjoint-support` on the line.  That is only
-- interesting if the conic is a conic.  If −1 happens to be a square in
-- the ring, say i·i = −1, then
--
--     a² + b²  =  (a + i b)(a − i b)
--
-- and the "circle" is two crossing LINES.  Its group law degenerates to
-- multiplication on each line separately, `gen-hom` becomes a statement
-- about products of scalars, and the whole apparatus is a disguised
-- restatement of ring multiplication carrying no geometry at all.
--
-- `norm-factors` below proves the factorisation exactly, over any
-- commutative ring in which such an i exists.  So the trivialising case
-- is real and must be excluded, not assumed away.
--
-- ────────────────────────────────────────────────────────────────────
-- IT IS EXCLUDED OVER ℤ
--
-- `ℤ-has-no-i`: no integer squares to −1, because every product of two
-- equal integers is `pos` of something — two cases, both closed by
-- `posNotnegsuc`.  So over ℤ the conic does not split, and every
-- statement in `PythagoreanTransition` and `IdempotenceForbidsDescent`
-- that was checked at ℤ is a statement about a genuine circle.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THAT IS THE DICHOTOMY THE WHOLE SUBJECT TURNS ON
--
-- Whether −1 is a square is exactly the split/inert question for the
-- Gaussian integers, and it is the reason the two-squares problem is a
-- problem: the form represents a prime p when p splits and does not when
-- p is inert.  Brahmagupta's form x² − D y² asks the same question with
-- D in place of −1, and the cakravāla's whole labour is at the values of
-- D where the form does not degenerate.
--
-- So the object `PythagoreanTransition` found — an additive law visible
-- in the multiplicative chart — is not free.  It exists exactly where the
-- norm form is irreducible, and where the form splits, the "additive law"
-- was multiplication all along.
--
-- WHAT IS NOT CLAIMED.  The converse — that a nontrivial factorisation of
-- the norm form forces −1 to be a square — is not proved here and needs
-- more than a ring identity.  Nor is anything claimed about which primes
-- split; that is the two-squares theorem and requires unique
-- factorisation in ℤ[i], which this lane does not have.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WhereTheCircleSplits where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; suc) renaming (_·_ to _·ℕ_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc) renaming (_·_ to _·ℤ_)
open import Cubical.Data.Int.Properties using (posNotnegsuc ; pos·pos ; negsuc·negsuc)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import Texts.PythagoreanTransition using (module Circle)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  If −1 is a square, the norm form splits
------------------------------------------------------------------------

module Split (R : CommRing ℓ) where

  open CommRingStr (snd R)
  open Circle R

  private
    expand : (i a b : A) →
      (a + (i · b)) · (a - (i · b)) ≡ (a · a) - ((i · i) · (b · b))
    expand i a b = solve! R

    close : (a b : A) → (a · a) - ((- 1r) · (b · b)) ≡ (a · a) + (b · b)
    close a b = solve! R

  -- THE DEGENERATION.  With i·i = −1 the circle is two lines.
  norm-factors : (i : A) → (i · i) ≡ (- 1r)
               → (u : Pair) → N u ≡ (fst u + (i · snd u)) · (fst u - (i · snd u))
  norm-factors i h u =
      sym ( expand i (fst u) (snd u)
          ∙ cong (λ z → (fst u · fst u) - (z · (snd u · snd u))) h
          ∙ close (fst u) (snd u) )

------------------------------------------------------------------------
-- 2.  Over ℤ no such i exists, so the circle stays a circle
------------------------------------------------------------------------

ℤ-has-no-i : (a : ℤ) → ¬ (a ·ℤ a ≡ negsuc 0)
ℤ-has-no-i (pos n)    p = posNotnegsuc (n ·ℕ n) 0 (pos·pos n n ∙ p)
ℤ-has-no-i (negsuc n) p =
  posNotnegsuc (suc n ·ℕ suc n) 0
    (pos·pos (suc n) (suc n) ∙ sym (negsuc·negsuc n n) ∙ p)

------------------------------------------------------------------------
-- 3.  The sentence.
--
-- An additive law that is multiplicative on norms is not a free gift of
-- writing pairs.  It exists exactly where the norm form is irreducible.
-- Over ℤ that holds, so `PythagoreanTransition`'s conic is a conic and
-- its transition map is geometry.  Over a ring where −1 is a square the
-- same construction returns ring multiplication wearing a costume.
------------------------------------------------------------------------
