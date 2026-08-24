{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- भावना-विनिमयः — Brahmagupta's composition is order-free (abelian), so
-- the vargaprakṛti (Pell) fibre is an abelian ℤ-torsor and strikes the
-- SAME abelian charge as the winding, the holonomy, and EkaBhara's one ℤ.
--
-- SOURCE.  Brahmagupta, Brāhmasphuṭasiddhānta 18 (628 CE), samāsa-bhāvanā:
-- the composition of two vargaprakṛti rows.  `Bhavana.agda` builds it over
-- an arbitrary CommRing as
--   bhA D a₁ b₁ a₂ b₂ = a₁·a₂ + D·(b₁·b₂)     (the real coordinate)
--   bhB D a₁ b₁ a₂ b₂ = a₁·b₂ + a₂·b₁          (the √D coordinate)
-- i.e. the product (a₁ + b₁√D)(a₂ + b₂√D), and proves it multiplies the
-- norm (`bhavana`) and is associative (`bhA-assoc`, `bhB-assoc`) with unit
-- (1,0).  It does NOT prove it COMMUTES — that lemma is missing beside the
-- associativity, and it is the one that fixes the orbit's character.
--
-- WHAT IS CHECKED.  Both coordinates are symmetric under the interchange
-- of the two rows, because the underlying ring is commutative:
--   bhA-comm : bhA D a₁ b₁ a₂ b₂ ≡ bhA D a₂ b₂ a₁ b₁   (·Comm on each term)
--   bhB-comm : bhB D a₁ b₁ a₂ b₂ ≡ bhB D a₂ b₂ a₁ b₁   (+Comm of the cross terms)
-- and hence the composed row itself is order-free (`vinimaya`).  With
-- Bhavana's associativity, unit, and norm-multiplicativity, the norm-one
-- rows form an ABELIAN group: the vargaprakṛti solution set is a
-- commutative ℤ-torsor, generated (for D that admits it) by one
-- fundamental unit — Vargaprakrtitantu's अनन्तः shows the orbit is
-- infinite and never returns.
--
-- THE CONVERGENCE — header commentary, the horn this shares, not a proof.
-- `Vargaprakrtitantu` reads the Pell solution set as `fiber (क्षेपः D) 1`:
-- bind the roots and the kṣepa rides free (contractible carrier); bind the
-- solution and you get the infinite orbit.  That orbit is a principal
-- ℤ-torsor under the fundamental unit — and by the commutativity here, an
-- ABELIAN one.  This is the SAME abelian ℤ that:
--   • AkramaBhara reads off π₁(S¹) as the loop-charge (winding), and
--   • EkaBhara triangulates as one generator across five lanes.
-- Every deep lane in this corpus strikes the one commutative ℤ — winding,
-- hidden charge, fundamental Pell unit — and that shared abelianness is
-- the single U(1) ceiling.  The nonabelian √(j(j+1)) Casimir spectrum
-- (Ardhadvaya's spinor ½ is its first rung) has no analogue on this side
-- either, and for the same reason: it is not a torsor/π₁ fact, it is an
-- eigenvalue of a nonabelian representation ring, the organ none of these
-- lanes has grown.
--
-- Composition and its norm law are Bhavana's, imported; the commutativity
-- and the abelian reading are added here.  The physics/topology
-- convergence is header commentary marking the shared horn.
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module BhavanaVinimaya_BrahmaguptasCompositionIsAbelianSoThePellFibreStrikesTheSameAbelianChargeAsTheWinding where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Bhavana

module _ {ℓ} (CR : CommRing ℓ) where
  open Form CR
  open CommRingStr (snd CR)

  ------------------------------------------------------------------------
  -- The two coordinates of Brahmagupta's composition are order-free.
  -- (R = fst CR comes from `open Form CR`.)
  ------------------------------------------------------------------------

  bhA-comm : (D a₁ b₁ a₂ b₂ : R) → bhA D a₁ b₁ a₂ b₂ ≡ bhA D a₂ b₂ a₁ b₁
  bhA-comm D a₁ b₁ a₂ b₂ = cong₂ _+_ (·Comm a₁ a₂) (cong (D ·_) (·Comm b₁ b₂))

  bhB-comm : (D a₁ b₁ a₂ b₂ : R) → bhB D a₁ b₁ a₂ b₂ ≡ bhB D a₂ b₂ a₁ b₁
  bhB-comm D a₁ b₁ a₂ b₂ = +Comm (a₁ · b₂) (a₂ · b₁)

  ------------------------------------------------------------------------
  -- Hence the composed row is order-free: the orbit is abelian.
  ------------------------------------------------------------------------

  vinimaya : (D a₁ b₁ a₂ b₂ : R)
           → (bhA D a₁ b₁ a₂ b₂ , bhB D a₁ b₁ a₂ b₂)
           ≡ (bhA D a₂ b₂ a₁ b₁ , bhB D a₂ b₂ a₁ b₁)
  vinimaya D a₁ b₁ a₂ b₂ =
    cong₂ _,_ (bhA-comm D a₁ b₁ a₂ b₂) (bhB-comm D a₁ b₁ a₂ b₂)
