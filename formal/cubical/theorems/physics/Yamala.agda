{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Yamala — the two-orb coupling is a SWAP; the entangler is its half.
--
-- TERM.  यमल · yamala — a twin, a paired couple; here the two evanescently
-- coupled orbs.  Common Sanskrit word, no technical-source claim.  Physics
-- (evanescent/frustrated-TIR coupling, SWAP, √SWAP) modern; reading built
-- here, 2026-08-25.
--
-- THE READING (checked terms below).  Bring two स्फटिक orbs close: the
-- evanescent tail of one whispering-gallery mode leaks into the other
-- (frustrated TIR), and an excitation can hop orb ↔ orb.  Full transfer is
-- the SWAP.  SWAP is lossless (an involution: a full hop and back returns)
-- and NON-LOCAL (its output on one orb depends on the OTHER orb's input), so
-- it is not a product of per-orb gates.  But SWAP by itself is not an
-- entangler — it merely relabels.  The entangling gate is its SQUARE ROOT:
-- √SWAP (half a hop) is universal with single-qubit gates.  And √SWAP stands
-- to SWAP exactly as √NOT stands to NOT (`Mani_…`, `VargamulaViparyaya_…`):
-- the root does not exist on the bare two-point label set, it exists only on
-- the ℂ-enrichment of the mode amplitudes.  So the tunable orb gap sets the
-- coupling fraction, and tuning it to HALF is what mints the entangler — the
-- seam where the Indra's net stops being abelian (`Bandha_…`).  The genuine
-- two-qubit controlled phase still needs the occupation-dependent
-- nonlinearity; √SWAP is the linear-coupling entangler.
--
-- WHAT IS CHECKED.  `swap²` — SWAP is an involution (full coupling returns),
-- so `swapEq` is an equivalence (lossless).  `non-local` — a hard ¬: SWAP is
-- not `(a,b) ↦ (u a , v b)` for any per-orb u, v.
--
-- NOT CLAIMED.  No ℂ, no amplitudes, no actual √SWAP (needs the enrichment),
-- no evanescent field, no nonlinearity — only that the coupling SWAP is a
-- lossless non-local equivalence on the basis.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Yamala where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

-- two coupled orbs; an excitation can hop orb ↔ orb. SWAP = full transfer.
swap : Bool × Bool → Bool × Bool
swap (a , b) = (b , a)

-- FULL COUPLING RETURNS: swap is an involution → an equivalence (lossless).
swap² : (x : Bool × Bool) → swap (swap x) ≡ x
swap² (a , b) = refl

swapEq : (Bool × Bool) ≃ (Bool × Bool)
swapEq = isoToEquiv (iso swap swap swap² swap²)

-- NON-LOCAL: not a product of per-orb gates — the output on one orb depends
-- on the OTHER orb's input.
non-local : ¬ (Σ[ u ∈ (Bool → Bool) ] Σ[ v ∈ (Bool → Bool) ]
               ((a b : Bool) → swap (a , b) ≡ (u a , v b)))
non-local (u , v , factors) = true≢false (sym u0≡1 ∙ u0≡0)
  where u0≡0 : u false ≡ false      -- swap(false,false) = (u false , _) = (false,_)
        u0≡0 = sym (cong fst (factors false false))
        u0≡1 : u false ≡ true        -- swap(false,true)  = (u false , _) = (true ,_)
        u0≡1 = sym (cong fst (factors false true))
