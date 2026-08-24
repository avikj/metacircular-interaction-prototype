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

{-# OPTIONS --cubical --safe #-}
-- emitted by machine/Sankalpa_… from a .sankalpa specification;
-- the laws below ARE the input spec, read as an algorithm.
module SankalpaYoga where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.List using (List ; [] ; _∷_)

Yoga : List ℕ → ℕ
Yoga [] = zero
Yoga (x ∷ xs) = x + Yoga xs

pariksa1 : Yoga (1 ∷ 2 ∷ 3 ∷ []) ≡ 6
pariksa1 = refl
pariksa2 : Yoga [] ≡ 0
pariksa2 = refl
