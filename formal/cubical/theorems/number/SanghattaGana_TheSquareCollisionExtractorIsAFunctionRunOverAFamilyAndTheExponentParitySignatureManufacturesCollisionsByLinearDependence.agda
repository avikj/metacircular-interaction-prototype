{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà™àà˜àŸààŸ-à—à â” the collision factory, as a family and as linear algebra.
--
-- SanghattaKarya ran the extraction chain on one N.  This gives the
-- collision-semantics document what it asks for:
--
--   Â§A  THE EXTRACTOR IS A FUNCTION, run over a FAMILY.  `extract N a b
--       = (gcd (a âˆ b) N , gcd (a + b) N)` is the congruence-of-squares
--       realization as a plain map; applied to a table of worked square
--       collisions it factors each modulus, and every factorization
--       recomposes â” checked, uniformly, for 15, 21, 33, 35.
--
--   Â§B  COLLISION MANUFACTURE IS LINEAR DEPENDENCE (Â§15â“18).  Over a
--       factor base [2,3,5], a smooth relation's square-class signature
--       is its exponent-parity vector in ğ”½âÂ³.  The relation matrix is a
--       boundary operator; a null-space element â” a selection whose
--       parity sum is zero â” is a product that is a SQUARE, i.e. a
--       manufactured square collision.  Exhibited: râ=2Â3, râ=2Â5,
--       râ=3Â5 have parities (1,1,0),(1,0,1),(0,1,1); their xor is
--       (0,0,0), so râÂrâÂrâ = (2Â3Â5)Â² is a square â” the dependency IS
--       the collision, computed.
--
-- Read together: manufacture (Â§B) produces the collision that the
-- extractor (Â§A) turns into a factor.  Once inside the smooth chart,
-- the whole pipeline is arithmetic and
-- linear algebra the kernel computes and hands back.
--
------------------------------------------------------------------------

module SanghattaGana_TheSquareCollisionExtractorIsAFunctionRunOverAFamilyAndTheExponentParitySignatureManufacturesCollisionsByLinearDependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; _+_ ; _Â·_ ; _âˆ¸_)
open import Cubical.Data.Nat.GCD using (gcd)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)

------------------------------------------------------------------------
-- Â§A Â The extractor as a function, run over a family.
------------------------------------------------------------------------

extract : â„• â†’ â„• â†’ â„• â†’ (â„• Ã— â„•)
extract N a b = gcd (a âˆ¸ b) N , gcd (a + b) N

-- worked square collisions (aÂ² â‰¡ bÂ² mod N, b = 1), one per modulus:
--   15: 4Â²=16â‰¡1     21: 8Â²=64â‰¡1Â3+1 ... 64 = 63+1 â‰¡1    (a=8)
--   33: 10Â²=100=99+1â‰¡1    35: 6Â²=36â‰¡1
f15 f21 f33 f35 : (â„• Ã— â„•)
f15 = extract 15 4  1     -- (3 , 5)
f21 = extract 21 8  1     -- (7 , 3)
f33 = extract 33 10 1     -- (3 , 11)
f35 = extract 35 6  1     -- (5 , 7)

f15â‰¡ : f15 â‰¡ (3 , 5)
f15â‰¡ = refl
f21â‰¡ : f21 â‰¡ (7 , 3)
f21â‰¡ = refl
f33â‰¡ : f33 â‰¡ (3 , 11)
f33â‰¡ = refl
f35â‰¡ : f35 â‰¡ (5 , 7)
f35â‰¡ = refl

-- each recomposes to its modulus: a genuine factorization, uniformly.
recompose15 : (3 Â· 5)  â‰¡ 15
recompose15 = refl
recompose21 : (7 Â· 3)  â‰¡ 21
recompose21 = refl
recompose33 : (3 Â· 11) â‰¡ 33
recompose33 = refl
recompose35 : (5 Â· 7)  â‰¡ 35
recompose35 = refl

------------------------------------------------------------------------
-- Â§B Â The exponent-parity signature: manufacture as linear dependence.
------------------------------------------------------------------------

-- ğ”½â as Bool with xor; a signature over the base [2,3,5] is a triple.
_âŠ•_ : Bool â†’ Bool â†’ Bool
false âŠ• b = b
true  âŠ• b = not b

record Sig : Typeâ‚€ where
  constructor sig
  field s2 s3 s5 : Bool
open Sig

infixl 6 _âŠ_
_âŠ_ : Sig â†’ Sig â†’ Sig
sig a b c âŠ sig x y z = sig (a âŠ• x) (b âŠ• y) (c âŠ• z)

zeroSig : Sig
zeroSig = sig false false false

-- three smooth relations and their square-class signatures:
--   râ = 2Â3  â’ (1,1,0)     râ = 2Â5 â’ (1,0,1)     râ = 3Â5 â’ (0,1,1)
râ‚ râ‚‚ râ‚ƒ : Sig
râ‚ = sig true  true  false
râ‚‚ = sig true  false true
râ‚ƒ = sig false true  true

-- THE DEPENDENCY: the three signatures sum to the zero vector, so the
-- product râÂrâÂrâ is a square â” a manufactured square collision.
dependency : (râ‚ âŠ râ‚‚ âŠ râ‚ƒ) â‰¡ zeroSig
dependency = refl

-- and the product is literally (2Â3Â5)Â², computed:
sqProduct : (2 Â· 3) Â· (2 Â· 5) Â· (3 Â· 5) â‰¡ (2 Â· 3 Â· 5) Â· (2 Â· 3 Â· 5)
sqProduct = refl

manufacturedRoot : â„•
manufacturedRoot = 2 Â· 3 Â· 5      -- 30; its square 900 is the collision value

manufacturedSquare : â„•
manufacturedSquare = (2 Â· 3) Â· (2 Â· 5) Â· (3 Â· 5)   -- 900
