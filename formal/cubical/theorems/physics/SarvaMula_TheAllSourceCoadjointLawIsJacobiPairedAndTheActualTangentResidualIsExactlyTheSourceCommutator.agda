{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- सर्व-मूल — the all-source law.
--
-- THE COADJOINT INTERTWINING IS JACOBI READ THROUGH A PAIRING, AND WHEN
-- THE ACTUAL TANGENT IS PUT IN ITS PLACE THE ERROR IS EXACTLY THE
-- COMMUTATOR OF THE TWO SOURCE TENSORS.  NOT BOUNDED BY IT — EQUAL.
--
-- `EkaSesa` computes the congruence `lyap L x` at the unit.  This module
-- computes it at a SOURCE TENSOR, and the answer separates into two
-- pieces of entirely different character.
--
-- PART ONE — the all-source law, in the paired form it is proved in.
--
--   The coadjoint action `M u` is defined against a pairing by
--
--       ⟪ M u w , c ⟫  ≡  ⟪ w , [ u , c ] ⟫ ,
--
--   and the source tensor is the trilinear form
--
--       π w a b  =  - ⟪ w , [ a , b ] ⟫ .
--
--   §1  π w [u,a] b  +  π w a [u,b]  ≡  π (M u w) a b .
--
--   This is Jacobi and nothing else.  The hypothesis used is Jacobi in
--   DERIVATION form — `[[u,a],b] ⊕ [a,[u,b]] ≡ [u,[a,b]]`, i.e. "bracket
--   with u differentiates the bracket" — together with additivity of the
--   pairing in its second slot and the defining equation of `M`.  No
--   antisymmetry, no bilinearity of the bracket, no group structure on
--   the algebra: `_⊕_` is an arbitrary binary operation and carries no
--   axioms at all.
--
-- PART TWO — the residual, in operator form.
--
--   Now suppose the same law holds as an operator identity in a ring
--   with involution,
--
--       lyap Mop (Π w)  ≡  Π (M w)         for every source w,
--
--   with every source tensor SKEW, `† (Π w) ≡ - (Π w)`.  Substituting
--   the actual tangent `Mop + Π u` for `Mop`:
--
--   §2  lyap (Mop + Π u) (Π w)  ≡  Π (M w)  +  bracket (Π u) (Π w) .
--
--   One `+ShufflePairs` separates the two summands; skewness is what
--   turns the second one into a commutator rather than an
--   anticommutator, and it is used exactly once.
--
--   §3  AT ITS OWN SOURCE the commutator is `bracket x x ≡ 0r`, so the
--       residual disappears and the identity `EkaSesa` uses is recovered
--       as a special case:  lyap (Mop + Π u) (Π u) ≡ Π (M u) .
--
--   §4  AND WHEN THE COADJOINT TERM VANISHES the whole tangent action is
--       the commutator:  Π (M w) ≡ 0r  ⟹  lyap (Mop + Π u) (Π w) ≡
--       bracket (Π u) (Π w) .  So the tangent can move a source tensor
--       in a direction whose entire content is a commutator — and
--       whether such a direction is itself a source is a question about
--       the image of `Π`, answered separately in `RiktaTantu`.
--
-- WHY THE TWO PARTS ARE NOT JOINED HERE.  Part One proves the law for
-- the paired trilinear form; Part Two ASSUMES it as an equation between
-- operators.  Passing from the first to the second needs a nondegenerate
-- pairing and an operator representing each form — that is a modelling
-- step, it is where a concrete space enters, and it is not carried out
-- anywhere below.  Part Two's `intertwine` is a hypothesis in the open,
-- exactly like `SamanaMula`'s `cov`.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 for any bracket, any binary `_⊕_`, any
-- pairing into any ring, and any `M`, satisfying the three displayed
-- equations.  §§2–4 in any ring with involution, for every `Mop`, every
-- skew `Π`, every `M` intertwining as displayed, and every pair of
-- sources.  NOT claimed: that any concrete bracket satisfies the Jacobi
-- hypothesis (it is assumed, not verified — no Lie algebra is
-- constructed here); that any pairing is nondegenerate, or that any form
-- is represented by an operator; anything about compactness, ideals, or
-- quotients, which enter only in `RiktaTantu`; and nothing about
-- solving, averaging, or lifting anything — there is no propagator and
-- no expectation in this file.
------------------------------------------------------------------------

module SarvaMula_TheAllSourceCoadjointLawIsJacobiPairedAndTheActualTangentResidualIsExactlyTheSourceCommutator where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring

open import LeakageCommutator using (IsInvolution)
import Vyatikrama_TheCommutatorOfASelfAdjointWithASkewAdjointIsSelfAdjointSoTheCrossSectorCurrentIsARealPairing as VY
import VahanaSamata_TheCongruenceAndTheDiffusionTermPreserveAdjointParitySoARealCovarianceStaysRealUnderCommonSourceTransport as VS

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- PART ONE · The all-source coadjoint law is Jacobi, paired.
------------------------------------------------------------------------

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  module _ (𝔤 : Type ℓ')
           (_⊕_ : 𝔤 → 𝔤 → 𝔤)
           (⟦_,_⟧ : 𝔤 → 𝔤 → 𝔤)
           (⟪_,_⟫ : 𝔤 → 𝔤 → ⟨ R ⟩)
           (M : 𝔤 → 𝔤 → 𝔤)
           -- bracketing with u differentiates the bracket
           (jacobi : (u a b : 𝔤)
                   → (⟦ ⟦ u , a ⟧ , b ⟧ ⊕ ⟦ a , ⟦ u , b ⟧ ⟧) ≡ ⟦ u , ⟦ a , b ⟧ ⟧)
           -- the pairing is additive in the slot the bracket lands in
           (pair-add : (w x y : 𝔤) → ⟪ w , x ⊕ y ⟫ ≡ ⟪ w , x ⟫ + ⟪ w , y ⟫)
           -- and `M u` is the coadjoint of bracketing with u
           (coadj : (u w c : 𝔤) → ⟪ M u w , c ⟫ ≡ ⟪ w , ⟦ u , c ⟧ ⟫)
           where

    -- the source tensor, as the trilinear form ⟨ a , Π w b ⟩
    π : 𝔤 → 𝔤 → 𝔤 → ⟨ R ⟩
    π w a b = - ⟪ w , ⟦ a , b ⟧ ⟫

    ------------------------------------------------------------------
    -- १ · THE ALL-SOURCE LAW.  Five steps, one of which is Jacobi.
    ------------------------------------------------------------------

    coadjoint-law : (u w a b : 𝔤)
      → (π w ⟦ u , a ⟧ b + π w a ⟦ u , b ⟧) ≡ π (M u w) a b
    coadjoint-law u w a b =
        (- ⟪ w , ⟦ ⟦ u , a ⟧ , b ⟧ ⟫) + (- ⟪ w , ⟦ a , ⟦ u , b ⟧ ⟧ ⟫)
      ≡⟨ -Dist ⟪ w , ⟦ ⟦ u , a ⟧ , b ⟧ ⟫ ⟪ w , ⟦ a , ⟦ u , b ⟧ ⟧ ⟫ ⟩
        - (⟪ w , ⟦ ⟦ u , a ⟧ , b ⟧ ⟫ + ⟪ w , ⟦ a , ⟦ u , b ⟧ ⟧ ⟫)
      ≡⟨ cong (λ z → - z) (sym (pair-add w ⟦ ⟦ u , a ⟧ , b ⟧ ⟦ a , ⟦ u , b ⟧ ⟧)) ⟩
        - ⟪ w , ⟦ ⟦ u , a ⟧ , b ⟧ ⊕ ⟦ a , ⟦ u , b ⟧ ⟧ ⟫
      ≡⟨ cong (λ z → - ⟪ w , z ⟫) (jacobi u a b) ⟩
        - ⟪ w , ⟦ u , ⟦ a , b ⟧ ⟧ ⟫
      ≡⟨ cong (λ z → - z) (sym (coadj u w ⟦ a , b ⟧)) ⟩
        - ⟪ M u w , ⟦ a , b ⟧ ⟫ ∎

------------------------------------------------------------------------
-- PART TWO · The residual, in operator form.
------------------------------------------------------------------------

module _ (R : Ring ℓ) (†_ : ⟨ R ⟩ → ⟨ R ⟩) (inv : IsInvolution R †_) where
  open RingStr (snd R)
  open RingTheory R
  open IsInvolution inv

  private
    A : Type ℓ
    A = ⟨ R ⟩

  lyap : A → A → A
  lyap = VS.lyap R †_ inv

  bracket : A → A → A
  bracket = VY.bracket R †_ inv

  --------------------------------------------------------------------
  -- A commutator of a thing with itself is zero.  Used once, in §3.
  --------------------------------------------------------------------

  bracket-self : (x : A) → bracket x x ≡ 0r
  bracket-self x = +InvR (x · x)

  module _ (U : Type ℓ') (Π : U → A) (Mop : A) (M : U → U)
           (skew : (w : U) → † (Π w) ≡ - (Π w))
           (intertwine : (w : U) → lyap Mop (Π w) ≡ Π (M w))
           where

    ------------------------------------------------------------------
    -- २ · THE EXACT RESIDUAL.  Putting the actual tangent `Mop + Π u`
    --     in place of `Mop` costs exactly one commutator.
    ------------------------------------------------------------------

    tangent-residual : (u w : U)
      → lyap (Mop + Π u) (Π w) ≡ Π (M w) + bracket (Π u) (Π w)
    tangent-residual u w =
        ((Mop + Π u) · Π w) + (Π w · († (Mop + Π u)))
      ≡⟨ cong₂ _+_ (·DistL+ Mop (Π u) (Π w))
                   (cong (Π w ·_) (†-+ Mop (Π u))
                     ∙ ·DistR+ (Π w) († Mop) († (Π u))) ⟩
        ((Mop · Π w) + (Π u · Π w))
          + ((Π w · († Mop)) + (Π w · († (Π u))))
      ≡⟨ cong (λ z → ((Mop · Π w) + (Π u · Π w)) + ((Π w · († Mop)) + z))
              (cong (Π w ·_) (skew u) ∙ -DistR· (Π w) (Π u)) ⟩
        ((Mop · Π w) + (Π u · Π w))
          + ((Π w · († Mop)) + (- (Π w · Π u)))
      ≡⟨ +ShufflePairs (Mop · Π w) (Π u · Π w)
                       (Π w · († Mop)) (- (Π w · Π u)) ⟩
        ((Mop · Π w) + (Π w · († Mop)))
          + ((Π u · Π w) + (- (Π w · Π u)))
      ≡⟨ cong (_+ ((Π u · Π w) + (- (Π w · Π u)))) (intertwine w) ⟩
        Π (M w) + ((Π u · Π w) + (- (Π w · Π u))) ∎

    ------------------------------------------------------------------
    -- ३ · AT ITS OWN SOURCE THE RESIDUAL VANISHES, and the identity
    --     the covariance evolution rests on comes back out.
    ------------------------------------------------------------------

    at-own-source : (u : U) → lyap (Mop + Π u) (Π u) ≡ Π (M u)
    at-own-source u =
        tangent-residual u u
      ∙ cong (Π (M u) +_) (bracket-self (Π u))
      ∙ +IdR (Π (M u))

    ------------------------------------------------------------------
    -- ४ · AND WHERE THE COADJOINT TERM DIES, THE WHOLE TANGENT ACTION
    --     IS A COMMUTATOR.
    ------------------------------------------------------------------

    all-residual : (u w : U) → Π (M w) ≡ 0r
      → lyap (Mop + Π u) (Π w) ≡ bracket (Π u) (Π w)
    all-residual u w h =
        tangent-residual u w
      ∙ cong (_+ bracket (Π u) (Π w)) h
      ∙ +IdL (bracket (Π u) (Π w))
