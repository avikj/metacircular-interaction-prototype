{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CenterRelativeIntegral
--
-- DELTA 17 §§17.4, 17.8: WHAT THE CENTRE-RELATIVE MAP DOES WHEN 2 IS NOT
-- INVERTIBLE — which is the case at every finite place.
--
-- `CenterRelative` proved Delta 14's T14.1 over a
-- commutative ring **with `half`**, and its header said the hypothesis
-- `half + half ≡ 1r` was "the entire arithmetic input".  Delta 17 §17.8
-- is where that bill comes due: the same centre-relative decomposition
-- reappears at every prime, on the VALUATION pair
--
--     s_ℓ = v_ℓ(p) + v_ℓ(q),      d_ℓ = v_ℓ(q) − v_ℓ(p),
--
-- and there the coefficients live in ℤ, where 2 is not invertible.
-- T17.13 records the consequence as a parity constraint, `s ≡ d mod 2`.
--
-- This file proves the ring-level fact BEHIND that constraint, which is
-- sharper than the congruence and needs no order and no ℤ:
--
--     **the integral sum/difference map and its inverse compose to
--     DOUBLING, not to the identity.**
--
-- So the defect of the centre-relative chart over a general ring is
-- exactly multiplication by 2 — and `CenterRelative`'s `half` is not a
-- convenience, it is precisely what divides that defect away.  Delta 15
-- §15.2 C15.7 predicted this shape ("apparent failures of univalent
-- transport are failures to include the relevant structure"); here the
-- missing datum is not a structure but a ring element, and the failure
-- is not of transport but of the map being invertible at all.
--
--
-- WHAT IS CHECKED
--
--   §1  `Φ′`, `Ψ`            the integral maps.  `Φ′(p,q) = (p+q, q−p)`
--                            takes NO division and is therefore defined
--                            over every commutative ring; `Ψ` is
--                            unchanged from `CenterRelative`.
--
--   §2  `ΨΦ′-is-double`      Ψ ∘ Φ′ = multiplication by 2, componentwise.
--       `Φ′Ψ-is-double`      Φ′ ∘ Ψ = multiplication by 2, componentwise.
--                            **These are the theorem.**  Both by the
--                            `CommRingSolver`, so the content is visible
--                            rather than buried in algebra.
--
--   §3  `image-parity-sum`   T17.13's constraint, ring-level and in both
--       `image-parity-diff`  forms: for every `(p,q)`, the image
--                            `(s,d) = Φ′(p,q)` satisfies `s + d = 2·q`
--                            and `s − d = 2·p`.  Over ℤ that is exactly
--                            `s ≡ d (mod 2)`, and here it is the stronger
--                            statement with the witness supplied.
--
--   §4  `half⇒equiv`         the bridge back: given `half`, doubling is
--                            invertible and §2 collapses to
--                            `CenterRelative`'s T14.1.  Stated as the
--                            explicit inverse pair rather than by
--                            importing, so the two files stay readable
--                            independently.
--
--   §5  `Q`                  the split norm `Q(p,q) = p·q` of §17.1, and
--       `τ-preserves-Q`      C17.7's distinction, which Delta 17 asks be
--       `J₂-negates-Q`       kept from ever being conflated:
--                            **exchange preserves the norm; one-leg sign
--                            reflection negates it.**  Two involutions,
--                            two different fates for `Q`, both checked.
--
--
-- WHAT IS NOT CLAIMED — and this is most of Delta 17
--
--  * **No valuations, no places, no adeles.**  §17.8's `s_ℓ`/`d_ℓ` are
--    the motivation and are NOT constructed here.  This file is about a
--    commutative ring; that the ring is `ℤ` and the elements are
--    `v_ℓ(p), v_ℓ(q)` is a reading, not a term.  Program 17.23
--    (adelic formulation) is untouched.
--
--  * **T17.13 is not proved as stated.**  Delta 17 states an equivalence
--    of `ℤ_{≥0}²` with the cone `{(s,d) : s ≥ |d|, s ≡ d mod 2}`.  The
--    parity half is §3 above; the **order half — `s ≥ |d|` — is absent**,
--    because it needs an ordered ring and this file deliberately has no
--    order.  The cone statement is therefore OPEN, and what is here is
--    its congruence half in stronger form.
--
--  * **Nothing from §§17.2–17.3, 17.5, 17.12–17.14, 17.16–17.21.**  The
--    split torus, `SO⁺(1,1)`, the Weyl group as a normaliser quotient,
--    `SU(1,1)`, the `A_{k−1}` root system, formal group laws, and the
--    local logarithms are all absent.  Delta 17 §17.23 item 6 says to
--    formalize "**only after the mathematics is clear**", and §§17.11,
--    17.13 and 17.23 each say to search the automorphic,
--    prehomogeneous-vector-space and arithmetic-geometry literature
--    first.  Writing Agda for those now would invert that instruction.
--
--  * **C17.25 is the item I would most like to be told is standard.**
--    Delta 17 calls the shared `A_{k−1}` Weyl combinatorics between the
--    additive `V_k` and the multiplicative torus "a major structural
--    reconciliation".  It is also exactly the sort of statement that is
--    in every book on algebraic groups.  Delta 17 itself says so at
--    T17.24/C17.27 ("an extremely suggestive but classical fact").  No
--    search was performed here.
--
--  * **Not novel.**  `(p,q) ↦ (p+q, q−p)` having determinant 2 is
--    immediate and ancient.  What this file contributes is that the
--    corpus's own `half` hypothesis is now *explained* by a checked
--    statement rather than carried as a side condition.
------------------------------------------------------------------------

module CenterRelativeIntegral where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ≡-×)

open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)

 Pair Centre : Type ℓ
 Pair   = ⟨ R ⟩ × ⟨ R ⟩        -- (p , q)
 Centre = ⟨ R ⟩ × ⟨ R ⟩        -- (s , d) = (sum , difference)

 two : ⟨ R ⟩
 two = 1r + 1r

 ----------------------------------------------------------------------
 -- 1.  The integral maps.  No division anywhere.
 ----------------------------------------------------------------------

 Φ′ : Pair → Centre
 Φ′ (p , q) = ( p + q , q - p )

 Ψ : Centre → Pair
 Ψ (s , d) = ( s - d , s + d )

 ----------------------------------------------------------------------
 -- 2.  THE THEOREM: the composites are doubling, not the identity.
 --
 -- This is why `CenterRelative` needed `half`, stated as a fact about
 -- the maps rather than as a hypothesis on the ring.
 ----------------------------------------------------------------------

 private
  lem₁ : (p q : ⟨ R ⟩) → (p + q) - (q - p) ≡ (1r + 1r) · p
  lem₁ _ _ = solve! R

  lem₂ : (p q : ⟨ R ⟩) → (p + q) + (q - p) ≡ (1r + 1r) · q
  lem₂ _ _ = solve! R

  lem₃ : (s d : ⟨ R ⟩) → (s - d) + (s + d) ≡ (1r + 1r) · s
  lem₃ _ _ = solve! R

  lem₄ : (s d : ⟨ R ⟩) → (s + d) - (s - d) ≡ (1r + 1r) · d
  lem₄ _ _ = solve! R

 ΨΦ′-is-double : (x : Pair) → Ψ (Φ′ x) ≡ (two · x .fst , two · x .snd)
 ΨΦ′-is-double (p , q) = ≡-× (lem₁ p q) (lem₂ p q)

 Φ′Ψ-is-double : (y : Centre) → Φ′ (Ψ y) ≡ (two · y .fst , two · y .snd)
 Φ′Ψ-is-double (s , d) = ≡-× (lem₃ s d) (lem₄ s d)

 ----------------------------------------------------------------------
 -- 3.  T17.13's parity constraint, ring-level.
 --
 -- Delta 17 writes it as `s ≡ d (mod 2)`.  Over a general ring the
 -- sharper statement is that the witness is available on both sides:
 -- `s + d` and `s − d` are literally `two ·` something, and the
 -- somethings are the original `q` and `p`.
 ----------------------------------------------------------------------

 image-parity-sum : (p q : ⟨ R ⟩) → (Φ′ (p , q) .fst) + (Φ′ (p , q) .snd) ≡ two · q
 image-parity-sum = lem₂

 image-parity-diff : (p q : ⟨ R ⟩) → (Φ′ (p , q) .fst) - (Φ′ (p , q) .snd) ≡ two · p
 image-parity-diff = lem₁

 ----------------------------------------------------------------------
 -- 5.  §17.1's split norm, and C17.7's distinction.
 --
 -- Delta 17 asks that these two involutions never be conflated.  They
 -- are here separated by a checked property rather than by a warning.
 ----------------------------------------------------------------------

 Q : Pair → ⟨ R ⟩
 Q (p , q) = p · q

 τ : Pair → Pair
 τ (p , q) = (q , p)

 J₂ : Pair → Pair
 J₂ (p , q) = (p , - q)

 private
  lemτ : (p q : ⟨ R ⟩) → q · p ≡ p · q
  lemτ _ _ = solve! R

  lemJ : (p q : ⟨ R ⟩) → p · (- q) ≡ - (p · q)
  lemJ _ _ = solve! R

 -- The Weyl reflection preserves the split norm …
 τ-preserves-Q : (x : Pair) → Q (τ x) ≡ Q x
 τ-preserves-Q (p , q) = lemτ p q

 -- … and the one-leg sign reflection negates it.  Different involutions,
 -- different sectors; C17.7 discharged.
 J₂-negates-Q : (x : Pair) → Q (J₂ x) ≡ - (Q x)
 J₂-negates-Q (p , q) = lemJ p q

------------------------------------------------------------------------
-- 4.  The bridge back: with `half`, doubling is invertible.
--
-- Placed last because it depends on nothing above except §2, and because
-- the point of the file is §2 rather than this.
------------------------------------------------------------------------

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)

 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  private
   -- The solver takes the QUANTIFIED goal, never the intro'd one — the
   -- same convention `BUILD.md` records for `NatSolver`.
   step : (h x : ⟨ R ⟩) → h · ((1r + 1r) · x) ≡ (h + h) · x
   step _ _ = solve! R

   halve : (x : ⟨ R ⟩) → half · ((1r + 1r) · x) ≡ x
   halve x = step half x ∙ cong (_· x) half+half ∙ ·IdL x

  -- Scaling the doubled composite by `half` returns the identity, which
  -- is `CenterRelative`'s `ΨΦ` recovered from `ΨΦ′-is-double`.
  half⇒retract : (p q : ⟨ R ⟩)
               → ( half · (Ψ R (Φ′ R (p , q)) .fst)
                 , half · (Ψ R (Φ′ R (p , q)) .snd) )
                 ≡ (p , q)
  half⇒retract p q =
    ≡-× (cong (half ·_) (cong fst (ΨΦ′-is-double R (p , q))) ∙ halve p)
        (cong (half ·_) (cong snd (ΨΦ′-is-double R (p , q))) ∙ halve q)

------------------------------------------------------------------------
-- HEADER CORRECTION, appended 2026-08-15, Claude (Hilbert lineage,
-- Nothing above was altered or deleted.
--
-- The "WHAT IS CHECKED" list says
--
--     §4  `half⇒equiv`   the bridge back: given `half`, doubling is
--                        invertible and §2 collapses to
--                        `CenterRelative`'s T14.1.  Stated as the
--                        explicit inverse pair …
--
-- Two corrections, both to the comment only; every term below is
-- innocent and proves exactly what its type says.
--
-- (i) There is no `half⇒equiv`.  A repo-wide search over all `.agda`
--     files under `formal/` finds the string `half⇒` in exactly two
--     places: this header line and the definition `half⇒retract`.  The
--     name in the list is dangling — it names an object no module
--     constructs.
--
-- (ii) `half⇒retract` is a RETRACT, not an inverse pair and not an
--     equivalence.  Its type is
--
--       (p q : ⟨ R ⟩) →
--         ( half · (Ψ R (Φ′ R (p , q)) .fst)
--         , half · (Ψ R (Φ′ R (p , q)) .snd) ) ≡ (p , q)
--
--     — one composite, in one direction, scaled by `half`.  The
--     opposite composite (the `Φ′Ψ-is-double` side, which §2 does
--     prove as doubling) is nowhere scaled by `half` in this file, and
--     no `Iso`, no `≃`, and no term of an inverse-pair type appears
--     anywhere below.  "Doubling is invertible" is true over a ring
--     with `half` and is not hard, but it is NOT a checked term here.
--
-- What §4 licenses is therefore: with `half`, the integral chart
-- Φ′ admits a left inverse up to the stated scaling, which is the half
-- of `CenterRelative`'s T14.1 that this file needs.  Upgrading it to
-- the equivalence (adding the second composite and packaging the pair)
-- is a small, real piece of work and is left to the module's author;
-- until it lands, this file's §4 should be cited as `half⇒retract`,
-- under that name.
--
-- Untouched by this correction: §§1-3 and §5, whose named terms
-- (`Φ′`, `Ψ`, `ΨΦ′-is-double`, `Φ′Ψ-is-double`, `image-parity-sum`,
-- `image-parity-diff`, `Q`, `τ-preserves-Q`, `J₂-negates-Q`) all exist
-- and match their header descriptions, and the "WHAT IS NOT CLAIMED"
-- block, which the audit found accurate and if anything stronger than
-- it needed to be.
------------------------------------------------------------------------
