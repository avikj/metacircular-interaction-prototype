{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BahuShakhaSetuProbe
--
-- The finite Born/refinement lane has proved the arithmetic of branchwise
-- weights and has now proved enumeration-independence.  Its remaining step 3
-- asks for a REVERSIBLE realization of a dependent finite refinement.
--
-- This probe supplies the exact computational/type-theoretic floor:
--
--   Micro = Σ[ y ∈ Fin (suc c) ] Fin (suc (k y))
--   Flat  = Fin (totalSum (λ y → suc (k y)))
--
-- `SumFinΣ≃` gives `Micro ≃ Flat`.  By univalence this is a universe path,
-- and transport along the path computes to the encoder by `uaβ`.  Decoding
-- recovers both the coarse outcome and the microbranch.  The coarse observer
-- on the flat register is `fst ∘ decode`, and its fiber over y is equivalent
-- to `Fin (suc (k y))` exactly—not merely equal in cardinality.
--
-- One generic lemma is made explicit because it is the bridge the claim
-- consumes: precomposing a map by an equivalence carries each fiber to an
-- equivalent fiber.  Since the current base is a finite set, the two round
-- trips close by `Σ≡Prop`; no path witness is silently identified without the
-- set receipt.
--
-- WHAT THIS REACHES.
--   * a reversible encoder/decoder for every dependent finite refinement;
--   * the universe path and the computation rule for its transport;
--   * exact recovery of the coarse label after encode/decode;
--   * the branch itself as the fiber of the flat coarse observer.
--
-- WHAT THIS DOES NOT CLAIM.
--   * no Hilbert space, amplitude, inner product, or unitary dynamics;
--   * no physical process implements this equivalence;
--   * no equality yet between the nested weight fold and the direct fold on
--     `Flat`—that is the Born coherence square now made well-typed by this
--     reversible carrier and by `KramaNairapeksya`.
--
-- TERM. बहुशाखा is carried from the checked branch-family module; सेतु is the
-- repository's ordinary word for a checked bridge.  The compound is built
-- here; no source is claimed for this mathematics.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- Not called checked until a route-bearing warm Nadi load answers.
------------------------------------------------------------------------

module ShakhaSetu_TheMicroSpaceFlattensReversiblyAndTheFiberOverEachCoarseOutcomeIsItsBranch where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Equiv
  using (_≃_ ; fiber ; compEquiv ; equivFun ; invEq ; invEquiv ; secEq ; retEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Sigma
  using (Σ ; Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.SumFin using (Fin ; totalSum)
open import Cubical.Data.SumFin.Properties
  using (SumFinΣ≃ ; isSetSumFin)
open import Cubical.Functions.Fibration using (fiberEquiv)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1. Fibers are preserved when the domain is changed by an equivalence.
------------------------------------------------------------------------

module _ {A : Type ℓ} {A' : Type ℓ} {B : Type ℓ'}
         (e : A ≃ A') (f : A → B) (setB : isSet B) where

  carried-map : A' → B
  carried-map a' = f (invEq e a')

  fiber-domain-Iso : (b : B) → Iso (fiber f b) (fiber carried-map b)
  Iso.fun (fiber-domain-Iso b) (a , p) =
    equivFun e a , cong f (retEq e a) ∙ p
  Iso.inv (fiber-domain-Iso b) (a' , p) =
    invEq e a' , p
  Iso.rightInv (fiber-domain-Iso b) (a' , p) =
    Σ≡Prop (λ z → setB (carried-map z) b) (secEq e a')
  Iso.leftInv (fiber-domain-Iso b) (a , p) =
    Σ≡Prop (λ z → setB (f z) b) (retEq e a)

  fiber-domain-Equiv : (b : B) → fiber f b ≃ fiber carried-map b
  fiber-domain-Equiv b = isoToEquiv (fiber-domain-Iso b)

------------------------------------------------------------------------
-- 2. Every dependent finite refinement is one reversible flat register.
------------------------------------------------------------------------

module _ (c : ℕ) (k : Fin (suc c) → ℕ) where

  Coarse : Type
  Coarse = Fin (suc c)

  Branch : Coarse → Type
  Branch y = Fin (suc (k y))

  Micro : Type
  Micro = Σ Coarse Branch

  flat-size : ℕ
  flat-size = totalSum (λ y → suc (k y))

  Flat : Type
  Flat = Fin flat-size

  flatten : Micro ≃ Flat
  flatten = SumFinΣ≃ (suc c) (λ y → suc (k y))

  encode : Micro → Flat
  encode = equivFun flatten

  decode : Flat → Micro
  decode = invEq flatten

  decode-encode : (m : Micro) → decode (encode m) ≡ m
  decode-encode = retEq flatten

  encode-decode : (z : Flat) → encode (decode z) ≡ z
  encode-decode = secEq flatten

  -- The equivalence is identity in the universe, and transport computes to
  -- the encoder—not merely propositionally to some unspecified map.
  refinement-path : Micro ≡ Flat
  refinement-path = ua flatten

  refinement-transport : (m : Micro)
    → transport refinement-path m ≡ encode m
  refinement-transport = uaβ flatten

  coarse-micro : Micro → Coarse
  coarse-micro = fst

  coarse-flat : Flat → Coarse
  coarse-flat z = fst (invEq flatten z)

  fine-flat : (z : Flat) → Branch (coarse-flat z)
  fine-flat z = snd (invEq flatten z)

  coarse-after-encode : (y : Coarse) (x : Branch y)
    → coarse-flat (encode (y , x)) ≡ y
  coarse-after-encode y x = cong fst (retEq flatten (y , x))

  --------------------------------------------------------------------------
  -- 3. The residual of coarse observation is exactly the branch.
  --------------------------------------------------------------------------

  micro-fiber≃branch : (y : Coarse)
    → fiber coarse-micro y ≃ Branch y
  micro-fiber≃branch y = fiberEquiv Branch y

  micro-fiber≃flat-fiber : (y : Coarse)
    → fiber coarse-micro y ≃ fiber coarse-flat y
  micro-fiber≃flat-fiber y =
    fiber-domain-Equiv flatten coarse-micro (isSetSumFin (suc c)) y

  flat-fiber≃branch : (y : Coarse)
    → fiber coarse-flat y ≃ Branch y
  flat-fiber≃branch y =
    compEquiv (invEquiv (micro-fiber≃flat-fiber y))
              (micro-fiber≃branch y)

  branch≃flat-fiber : (y : Coarse)
    → Branch y ≃ fiber coarse-flat y
  branch≃flat-fiber y = invEquiv (flat-fiber≃branch y)
