{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वस्थान — one's own station.  The graded fibre tower of the sum
-- spectrum (owner's three-multiplicity message), structural half:
--
--   level 0   frequencies s                    (the base)
--   level 1   pair-witnesses (γᵢ, γⱼ) over s = γᵢ + γⱼ   (the fibres)
--   level 2   relabelings between witnesses    (paths within a fibre)
--
-- SamyogaVyatikara separated the three multiplicities ALGEBRAICALLY
-- (V∞ − D counts level-1 collisions; §4 showed leg symmetry leaves both
-- invariant).  Here is the GEOMETRY under that: the leg swap is a
-- VERTICAL automorphism of the sum fibration — it covers the identity on
-- the base (γᵢ + γⱼ ≡ γⱼ + γᵢ, Brahmagupta's commutativity of dhana),
-- hence restricts to an involution of EACH fibre of the sum map.  A
-- relabeling moves a witness within its own station; it cannot move a
-- witness between frequencies, so it can never create or destroy a
-- collision.  That is WHY leg exchange never enters the cross term: it is
-- transport within a fibre, and interference counts fibres' sizes.
--
-- CHECKED (over ℤ pairs, the sum map σ (a,b) = a + b):
--   §1  swap covers the identity:  σ ∘ swap ≡ σ  (pointwise, +-comm).
--   §2  hence swap RESTRICTS to each fibre:  fiber σ s → fiber σ s,
--       an involution (swap² ≡ id, lifted to the fibre with its witness).
--   §3  the induced action on the base is the identity — the swap is
--       vertical, level 2 acts on level 1 over a FIXED level 0.
--
-- FENCE.  The weighted count (that |fibre| ≥ 2 with weights gives the
-- 2w₀w₁ interference) is SamyogaVyatikara's; the analytic tower over the
-- actual zeta frequencies needs ℝ and is the owner's reading.  This is
-- the exact skeleton: verticality, the reason the multiplicities never mix.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module Svasthana_TheLegSwapIsVerticalOverTheSumMapSoRelabelingNeverChangesACollisionCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; _+_)
open import Cubical.Data.Int.Properties using (+Comm)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd; Σ; Σ-syntax; ΣPathP)

-- level 1 over level 0: pairs and the sum map.
Pair : Type
Pair = ℤ × ℤ

σ : Pair → ℤ
σ (a , b) = a + b

-- the level-2 relabeling.
swap : Pair → Pair
swap (a , b) = (b , a)

------------------------------------------------------------------------
-- §1 · THE SWAP COVERS THE IDENTITY: relabeling does not move the
-- frequency.  Brahmagupta's commutativity, read as verticality.
vertical : (p : Pair) → σ (swap p) ≡ σ p
vertical (a , b) = +Comm b a

-- and it is an involution on level 1:
swap² : (p : Pair) → swap (swap p) ≡ p
swap² (a , b) = refl

------------------------------------------------------------------------
-- §2 · THE SWAP RESTRICTS TO EACH FIBRE.  A witness over s is carried to
-- a witness over the SAME s: level 2 acts within a station.
Fibre : ℤ → Type
Fibre s = Σ[ p ∈ Pair ] (σ p ≡ s)

swapF : (s : ℤ) → Fibre s → Fibre s
swapF s (p , e) = swap p , vertical p ∙ e

-- the restricted action is still an involution — on the underlying
-- witness, on the nose.
swapF² : (s : ℤ) (w : Fibre s) → fst (swapF s (swapF s w)) ≡ fst w
swapF² s (p , e) = swap² p

------------------------------------------------------------------------
-- §3 · VERTICALITY, STATED ON THE BASE: the frequency read off a witness
-- is unchanged by relabeling — the induced map on level 0 is the
-- identity.  So no relabeling ever creates or destroys a collision: the
-- collision count is a function of the fibre, and the swap never leaves
-- the fibre.  Level 2 cannot reach level 0.
induced-identity : (s : ℤ) (w : Fibre s)
  → σ (fst (swapF s w)) ≡ σ (fst w)
induced-identity s (p , e) = vertical p
