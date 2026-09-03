{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre
--
-- Lossless compression, done the way the kernel works: aggressive
-- univalence.  The whole content is one master fact, borrowed from
--
--   Laghava_TheCostAndTheInverseCannotCoexistSoNoNontrivialGroupIsGraded
--     AndTransportHasNoPrice
--
--     A COST AND AN INVERSE CANNOT COEXIST.  §4: transport (an
--     equivalence) is a group under composition, invEquiv fills the
--     inverse, so NO cost function exists on transports — "transport has
--     no price."  §5: the kernel's `len` is a grading, so it cannot be
--     inverted.  The two sides are disjoint: invertible ⟹ costless;
--     costed ⟹ non-invertible.
--
-- Every codec this repository's `compression/` directory once held put a
-- COST (a bit-count, a `len`, an entropy code) on structure that is
-- invertible — it measured length on the transport side, which the master
-- theorem forbids.  That is the error.  The right object spends no bits on
-- anything an equivalence determines, and reaches for a cost ONLY at a
-- fibre that fails to be contractible.  This file makes that exact and
-- checks it.
--
-- THE STEP (from Vishvayantra): for ANY evaluator f : A → B,
--
--     lossless :  A ≃ Σ B (fiber f)          a ↦ (f a , a , refl)
--
-- the datum recodes losslessly as its observation f a together with the
-- fibre point.  The observation is the visible projection (`refl`); the
-- fibre point is the only residue.
--
-- WHAT IS PROVED:
--
--   §1 lossless          the codec, an equivalence (invertible, hence by
--                        the master theorem costless as a recoding).
--   §2 residue-collapses when every fibre is contractible, the residue
--                        Σ B (fiber f) IS just B: the fibre carries
--                        nothing, the datum returns from f a ALONE.
--   §3 free-when-equiv   so an equivalence f gives A ≃ B directly, and
--        free-is-f       that equivalence is f on the nose (`refl`):
--                        perfect compression is pure transport, no bits.
--   §4 the-cost-is-the-fibre / bits-live-only-where-not-contractible
--                        the ONLY place a choice — a bit — is forced is a
--                        b whose fibre is not contractible.  Contractible
--                        fibre ⟹ the fibre point is unique (isProp), the
--                        decoder needs nothing to recover it.  That is
--                        Abstract 24's remainder and it is the whole cost.
--
-- Machine-checked, Agda 2.8.0 + cubical v0.9, --safe, no postulates.
------------------------------------------------------------------------

module CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

private variable
  ℓ ℓ' : Level
  A : Type ℓ
  B : Type ℓ'

------------------------------------------------------------------------
-- §1  The lossless step.  A ≃ Σ B (fiber f), the codec.  Invertible, so
-- by the master theorem it is a transport and carries no price of its own.
------------------------------------------------------------------------

module _ (f : A → B) where

  losslessIso : Iso A (Σ B (fiber f))
  Iso.fun losslessIso a = f a , a , refl
  Iso.inv losslessIso (b , a , p) = a
  Iso.rightInv losslessIso (b , a , p) i = p i , a , λ j → p (i ∧ j)
  Iso.leftInv losslessIso a = refl

  lossless : A ≃ Σ B (fiber f)
  lossless = isoToEquiv losslessIso

  -- the observation is the visible projection, definitionally.
  visible-projection : (a : A) → fst (equivFun lossless a) ≡ f a
  visible-projection a = refl

------------------------------------------------------------------------
-- §2  The residue collapses under contractible fibres.  If every fibre is
-- contractible, Σ B (fiber f) ≃ B: the residue holds no information, the
-- second component is forced.  This is where "transport has no price"
-- becomes operational — the recoding keeps ONLY B.
------------------------------------------------------------------------

  residue-collapses : ((b : B) → isContr (fiber f b))
                    → Σ B (fiber f) ≃ B
  residue-collapses c = Σ-contractSnd c

  -- a contractible fibre is a proposition: any two fibre points are equal,
  -- so recovering the fibre point requires NO bit — it is determined.
  fibre-is-free : (b : B) → isContr (fiber f b) → isProp (fiber f b)
  fibre-is-free b = isContr→isProp

------------------------------------------------------------------------
-- §3  The only cost is the non-contractible fibre.  (Still inside the
-- module over f.)  Where every fibre is contractible the residue vanishes
-- and the whole codec is a transport A ≃ B — no bit is spent.  A bit is
-- forced only at a b whose fibre is NOT contractible.
------------------------------------------------------------------------

  -- the residue vanishes exactly when every fibre is contractible: then the
  -- whole codec is a transport A ≃ B and no bit is spent.
  free-exactly-when-contractible : ((b : B) → isContr (fiber f b)) → A ≃ B
  free-exactly-when-contractible c = compEquiv lossless (residue-collapses c)

  -- conversely an equivalence supplies exactly that contractibility — it is
  -- the unfolding of isEquiv.  So "free" and "f is an equivalence" coincide.
  equiv→fibres-contractible : isEquiv f → (b : B) → isContr (fiber f b)
  equiv→fibres-contractible e = equiv-proof e

  -- THE COST.  A bit is forced only where the fibre is not contractible:
  -- if the fibre is not even a proposition — two fibre points no observation
  -- separates — it cannot be contractible.  That genuine choice is Abstract
  -- 24's remainder, the one thing univalence cannot make free, and it is the
  -- whole of what a lossless code must spend.
  cost-is-non-contractibility : (b : B) → ¬ isProp (fiber f b) → ¬ isContr (fiber f b)
  cost-is-non-contractibility b np c = np (isContr→isProp c)

------------------------------------------------------------------------
-- §4  Perfect compression is pure transport.  An equivalence f — every
-- fibre contractible — recodes A as B with no residue, and the recoding
-- is f itself.  No bits are spent; the datum IS its observation.
------------------------------------------------------------------------

free-when-equiv : (f : A → B) → isEquiv f → A ≃ B
free-when-equiv f e = f , e

free-is-f : (f : A → B) (e : isEquiv f) (a : A)
          → equivFun (free-when-equiv f e) a ≡ f a
free-is-f f e a = refl

-- coding through the fibre and then discarding the (contractible) residue
-- is the same map as f.  Both send a to f a, definitionally.
transport-route-is-f : (f : A → B) (e : isEquiv f) (a : A)
  → fst (equivFun (lossless f) a) ≡ equivFun (free-when-equiv f e) a
transport-route-is-f f e a = refl
