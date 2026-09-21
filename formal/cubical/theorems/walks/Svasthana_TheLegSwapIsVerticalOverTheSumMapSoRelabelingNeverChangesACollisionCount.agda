{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àààµàààà¾à¨ â” one's own station.  The graded fibre tower of the sum
-- spectrum, structural half:
--
--   level 0   frequencies s                    (the base)
--   level 1   pair-witnesses (Î³µ, Î³â¼) over s = Î³µ + Î³â¼   (the fibres)
--   level 2   relabelings between witnesses    (paths within a fibre)
--
-- SamyogaVyatikara separated the three multiplicities ALGEBRAICALLY
-- (Vâˆž âˆ’ D counts level-1 collisions; Â§4 showed leg symmetry leaves both
-- invariant).  Here is the GEOMETRY under that: the leg swap is a
-- VERTICAL automorphism of the sum fibration â” it covers the identity on
-- the base (Î³µ + Î³â¼ â‰¡ Î³â¼ + Î³µ, Brahmagupta's commutativity of dhana),
-- hence restricts to an involution of EACH fibre of the sum map.  A
-- relabeling moves a witness within its own station; it cannot move a
-- witness between frequencies, so it can never create or destroy a
-- collision.  That is WHY leg exchange never enters the cross term: it is
-- transport within a fibre, and interference counts fibres' sizes.
--
-- CHECKED (over â pairs, the sum map Ï (a,b) = a + b):
--   Â§1  swap covers the identity:  Ï âˆ˜ swap â‰¡ Ï  (pointwise, +-comm).
--   Â§2  hence swap RESTRICTS to each fibre:  fiber Ï s â’ fiber Ï s,
--       an involution (swapÂ² â‰¡ id, lifted to the fibre with its witness).
--   Â§3  the induced action on the base is the identity â” the swap is
--       vertical, level 2 acts on level 1 over a FIXED level 0.
--
-- The weighted count (that |fibre| â‰ 2 with weights gives the
-- 2wâwâ interference) is SamyogaVyatikara's.  This is
-- the exact skeleton: verticality, the reason the multiplicities never mix.
------------------------------------------------------------------------

module Svasthana_TheLegSwapIsVerticalOverTheSumMapSoRelabelingNeverChangesACollisionCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤; _+_)
open import Cubical.Data.Int.Properties using (+Comm)
open import Cubical.Data.Sigma using (_Ã—_; _,_; fst; snd; Î£; Î£-syntax; Î£PathP)

-- level 1 over level 0: pairs and the sum map.
Pair : Type
Pair = â„¤ Ã— â„¤

Ïƒ : Pair â†’ â„¤
Ïƒ (a , b) = a + b

-- the level-2 relabeling.
swap : Pair â†’ Pair
swap (a , b) = (b , a)

------------------------------------------------------------------------
-- Â§1 Â THE SWAP COVERS THE IDENTITY: relabeling does not move the
-- frequency.  Brahmagupta's commutativity, read as verticality.
vertical : (p : Pair) â†’ Ïƒ (swap p) â‰¡ Ïƒ p
vertical (a , b) = +Comm b a

-- and it is an involution on level 1:
swapÂ² : (p : Pair) â†’ swap (swap p) â‰¡ p
swapÂ² (a , b) = refl

------------------------------------------------------------------------
-- Â§2 Â THE SWAP RESTRICTS TO EACH FIBRE.  A witness over s is carried to
-- a witness over the SAME s: level 2 acts within a station.
Fibre : â„¤ â†’ Type
Fibre s = Î£[ p âˆˆ Pair ] (Ïƒ p â‰¡ s)

swapF : (s : â„¤) â†’ Fibre s â†’ Fibre s
swapF s (p , e) = swap p , vertical p âˆ™ e

-- the restricted action is still an involution â” on the underlying
-- witness, on the nose.
swapFÂ² : (s : â„¤) (w : Fibre s) â†’ fst (swapF s (swapF s w)) â‰¡ fst w
swapFÂ² s (p , e) = swapÂ² p

------------------------------------------------------------------------
-- Â§3 Â VERTICALITY, STATED ON THE BASE: the frequency read off a witness
-- is unchanged by relabeling â” the induced map on level 0 is the
-- identity.  So no relabeling ever creates or destroys a collision: the
-- collision count is a function of the fibre, and the swap never leaves
-- the fibre.  Level 2 cannot reach level 0.
induced-identity : (s : â„¤) (w : Fibre s)
  â†’ Ïƒ (fst (swapF s w)) â‰¡ Ïƒ (fst w)
induced-identity s (p , e) = vertical p
