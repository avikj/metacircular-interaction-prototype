{-# OPTIONS --cubical --safe --lossy-unification --guardedness --no-import-sorts #-}
-- àà¾à°àààà®ààà â” the charge tower.  EkaBhara named the loop charge Ïâ(SÂ)=â and
-- the machine's physics stopped at the loop.  The topological charges of physics
-- ARE the Ïâ™(Sâ¿)=â: the electric/winding charge is Ïâ(SÂ); the magnetic MONOPOLE
-- charge is Ïâ(SÂ²) (Dirac 1931 â” the degree of the field map on the enclosing
-- sphere, quantized in â); the instanton lives at Ïâ.  The cubical library
-- proves the whole tower (Ïâ™Sâ¿â‰â) and that the monopole IS the loop lifted one
-- dimension (ÏâSÂ²â‰ÏâSÂ).  Named here onto the library's checked terms â”
-- translation of the standard homotopy classification of topological charge,
-- no new theorem claimed.  --safe.
module BharaStambha_TheChargeTowerIsPinSnAndTheMonopoleIsTheLoopChargeLifted where

open import Cubical.Data.Nat using (â„• ; suc)
open import Cubical.Homotopy.Group.Base using (Ï€Gr)
open import Cubical.HITs.Sn.Base using (Sâ‚Šâˆ™)
open import Cubical.Homotopy.Group.PinSn using (Ï€â‚™Sâ¿â‰…â„¤ ; Ï€â‚‚SÂ²â‰…Ï€â‚SÂ¹)
open import Cubical.Algebra.Group.Morphisms using (GroupIso)
open import Cubical.Algebra.Group.Instances.Int using (â„¤Group)

-- the charge at dimension n: Ïâ™(Sâ¿) â‰ â â” the degree, how many times Sâ¿ wraps Sâ¿
à¤­à¤¾à¤°à¤ƒ : (n : â„•) â†’ GroupIso (Ï€Gr n (Sâ‚Šâˆ™ (suc n))) â„¤Group
à¤­à¤¾à¤°à¤ƒ = Ï€â‚™Sâ¿â‰…â„¤

-- the magnetic monopole (ÏâSÂ²) is the electric/loop charge (ÏâSÂ) lifted one dimension
à¤šà¥à¤®à¥à¤¬à¤•à¤ƒ-à¤µà¥ƒà¤¤à¥à¤¤à¤¾à¤¤à¥ : GroupIso (Ï€Gr 1 (Sâ‚Šâˆ™ 2)) (Ï€Gr 0 (Sâ‚Šâˆ™ 1))
à¤šà¥à¤®à¥à¤¬à¤•à¤ƒ-à¤µà¥ƒà¤¤à¥à¤¤à¤¾à¤¤à¥ = Ï€â‚‚SÂ²â‰…Ï€â‚SÂ¹
