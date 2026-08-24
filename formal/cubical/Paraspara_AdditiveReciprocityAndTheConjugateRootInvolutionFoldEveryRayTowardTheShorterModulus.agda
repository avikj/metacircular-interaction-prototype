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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परस्पर — mutual/reciprocal.  Two further exact symmetries of the
-- wall-orientation roots (companion to Ekamula), each a checked ℤ fact.
--
--  §1 ADDITIVE RECIPROCITY.  For coprime u,v with reciprocals ū,v̄,
--         ū/v + v̄/u ≡ 1/(uv)  (mod 1),  i.e.  uv ∣ (u·ū + v·v̄ − 1).
--     Checked as the two leg-divisibilities that compose (under
--     coprimality, fenced) to uv ∣ …:  u ∣ (u·ū+v·v̄−1) from v·v̄≡1(u),
--     and v ∣ (u·ū+v·v̄−1) from u·ū≡1(v).  This lets every ray be
--     propagated through EITHER modulus, so one always chooses min(u,v):
--     unbalanced factorizations reach a short-modulus estimate, only the
--     balanced interior is intrinsically two-sided.
--
--  §2 CONJUGATE-ROOT INVOLUTION.  Swapping legs negates the root:
--         root(v,v̄) ≡ − root(u,ū)  (mod uv),
--     because −root(u,ū) ≡ −1 (mod u) and ≡ +1 (mod v) — exactly the
--     residues of root(v,v̄).  The pair (u,v)↔(v,u) is thus an involution
--     on the modular-root space, and it is why the centered field is
--     REAL: e(akx)+e(−akx)=2cos(2πakx).  Checked as the two leg-
--     congruences of −root; the mod-uv equality composes them (coprime,
--     fenced).
--
-- Analytic consequence (owner's reading, fenced, needs ℝ): the causal
-- diamond L ≲ uv ≲ L², k ≲ uv/L < min(u,v), where u,v,k are all
-- genuinely incomplete; outside it, interval-kernel decay (uv<L),
-- completion in k (uv>L²), or completion through the shorter modulus.
--
-- Uses Ekamula's root, root-mod-u, root-mod-v.  Ring identities keep the
-- constant 1 as a variable (predℤ evasion, as in Ekamula).
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module Paraspara_AdditiveReciprocityAndTheConjugateRootInvolutionFoldEveryRayTowardTheShorterModulus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; -_; _·_)
open import Cubical.Data.Sigma using (Σ; Σ-syntax; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)
open import Ekamula_TheWallOrientationsAreSquareRootsOfOneBuiltFromFactorizationsByTheKloostermanReciprocal
  using (_∣_; root; root-mod-u; root-mod-v)

private
  genRecipU : (one u ū v v̄ k : ℤ)
    → (v · v̄ + (- one) ≡ k · u)
    → ((u · ū + v · v̄) + (- one)) ≡ (k + ū) · u
  genRecipU one u ū v v̄ k e =
    solve! ℤCommRing ∙ cong (u · ū +_) e ∙ solve! ℤCommRing

  genRecipV : (one u ū v v̄ k : ℤ)
    → (u · ū + (- one) ≡ k · v)
    → ((u · ū + v · v̄) + (- one)) ≡ (k + v̄) · v
  genRecipV one u ū v v̄ k e =
    solve! ℤCommRing ∙ cong (_+ v · v̄) e ∙ solve! ℤCommRing

  genNegU : (one u rt k : ℤ)
    → (rt + (- one) ≡ k · u) → ((- rt) + one) ≡ (- k) · u
  genNegU one u rt k e =
    solve! ℤCommRing ∙ cong -_ e ∙ solve! ℤCommRing

  genNegV : (one v rt k : ℤ)
    → (rt + one ≡ k · v) → ((- rt) + (- one)) ≡ (- k) · v
  genNegV one v rt k e =
    solve! ℤCommRing ∙ cong -_ e ∙ solve! ℤCommRing

------------------------------------------------------------------------
-- §1 · ADDITIVE RECIPROCITY (both legs).
reciprocity-mod-u : (u ū v v̄ : ℤ)
  → u ∣ (v · v̄ + (- pos 1)) → u ∣ ((u · ū + v · v̄) + (- pos 1))
reciprocity-mod-u u ū v v̄ (k , e) = (k + ū) , genRecipU (pos 1) u ū v v̄ k e

reciprocity-mod-v : (u ū v v̄ : ℤ)
  → v ∣ (u · ū + (- pos 1)) → v ∣ ((u · ū + v · v̄) + (- pos 1))
reciprocity-mod-v u ū v v̄ (k , e) = (k + v̄) , genRecipV (pos 1) u ū v v̄ k e

------------------------------------------------------------------------
-- §2 · CONJUGATE-ROOT INVOLUTION.  −root(u,ū) ≡ −1 (mod u), +1 (mod v).
negroot-mod-u : (u ū : ℤ) → u ∣ ((- root u ū) + pos 1)
negroot-mod-u u ū with root-mod-u u ū
... | (k , e) = (- k) , genNegU (pos 1) u (root u ū) k e

negroot-mod-v : (u ū v : ℤ) → v ∣ (u · ū + (- pos 1))
  → v ∣ ((- root u ū) + (- pos 1))
negroot-mod-v u ū v h with root-mod-v u ū v h
... | (k , e) = (- k) , genNegV (pos 1) v (root u ū) k e
