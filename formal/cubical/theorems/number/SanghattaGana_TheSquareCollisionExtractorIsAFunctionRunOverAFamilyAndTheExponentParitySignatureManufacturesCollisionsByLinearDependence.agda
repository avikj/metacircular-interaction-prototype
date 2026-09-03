{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्घट्ट-गण — the collision factory, as a family and as linear algebra.
--
-- SanghattaKarya ran the extraction chain on one N.  This gives the
-- collision-semantics document everything it asks for next, at once:
--
--   §A  THE EXTRACTOR IS A FUNCTION, run over a FAMILY.  `extract N a b
--       = (gcd (a ∸ b) N , gcd (a + b) N)` is the congruence-of-squares
--       realization as a plain map; applied to a table of worked square
--       collisions it factors each modulus, and every factorization
--       recomposes — checked, uniformly, for 15, 21, 33, 35.
--
--   §B  COLLISION MANUFACTURE IS LINEAR DEPENDENCE (§15–18).  Over a
--       factor base [2,3,5], a smooth relation's square-class signature
--       is its exponent-parity vector in 𝔽₂³.  The relation matrix is a
--       boundary operator; a null-space element — a selection whose
--       parity sum is zero — is a product that is a SQUARE, i.e. a
--       manufactured square collision.  Exhibited: r₁=2·3, r₂=2·5,
--       r₃=3·5 have parities (1,1,0),(1,0,1),(0,1,1); their xor is
--       (0,0,0), so r₁·r₂·r₃ = (2·3·5)² is a square — the dependency IS
--       the collision, computed.
--
-- Read together: manufacture (§B) produces the collision that the
-- extractor (§A) turns into a factor.  The frontier the document names
-- — cheaply ENTERING the smooth chart — is untouched and unclaimed;
-- what is here is that once inside, the whole pipeline is arithmetic and
-- linear algebra the kernel computes and hands back.
--
-- SYĀT — THE CLAIM, EXACTLY.  §A for the four tabulated moduli with
-- their given collisions; §B for the exhibited three relations, parity
-- sum zero and the product a square.  NOT claimed: that the collisions
-- or the smooth relations were found rather than supplied.
------------------------------------------------------------------------

module SanghattaGana_TheSquareCollisionExtractorIsAFunctionRunOverAFamilyAndTheExponentParitySignatureManufacturesCollisionsByLinearDependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Nat.GCD using (gcd)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)

------------------------------------------------------------------------
-- §A · The extractor as a function, run over a family.
------------------------------------------------------------------------

extract : ℕ → ℕ → ℕ → (ℕ × ℕ)
extract N a b = gcd (a ∸ b) N , gcd (a + b) N

-- worked square collisions (a² ≡ b² mod N, b = 1), one per modulus:
--   15: 4²=16≡1     21: 8²=64≡1·3+1 ... 64 = 63+1 ≡1    (a=8)
--   33: 10²=100=99+1≡1    35: 6²=36≡1
f15 f21 f33 f35 : (ℕ × ℕ)
f15 = extract 15 4  1     -- (3 , 5)
f21 = extract 21 8  1     -- (7 , 3)
f33 = extract 33 10 1     -- (3 , 11)
f35 = extract 35 6  1     -- (5 , 7)

f15≡ : f15 ≡ (3 , 5)
f15≡ = refl
f21≡ : f21 ≡ (7 , 3)
f21≡ = refl
f33≡ : f33 ≡ (3 , 11)
f33≡ = refl
f35≡ : f35 ≡ (5 , 7)
f35≡ = refl

-- each recomposes to its modulus: a genuine factorization, uniformly.
recompose15 : (3 · 5)  ≡ 15
recompose15 = refl
recompose21 : (7 · 3)  ≡ 21
recompose21 = refl
recompose33 : (3 · 11) ≡ 33
recompose33 = refl
recompose35 : (5 · 7)  ≡ 35
recompose35 = refl

------------------------------------------------------------------------
-- §B · The exponent-parity signature: manufacture as linear dependence.
------------------------------------------------------------------------

-- 𝔽₂ as Bool with xor; a signature over the base [2,3,5] is a triple.
_⊕_ : Bool → Bool → Bool
false ⊕ b = b
true  ⊕ b = not b

record Sig : Type₀ where
  constructor sig
  field s2 s3 s5 : Bool
open Sig

infixl 6 _⊞_
_⊞_ : Sig → Sig → Sig
sig a b c ⊞ sig x y z = sig (a ⊕ x) (b ⊕ y) (c ⊕ z)

zeroSig : Sig
zeroSig = sig false false false

-- three smooth relations and their square-class signatures:
--   r₁ = 2·3  → (1,1,0)     r₂ = 2·5 → (1,0,1)     r₃ = 3·5 → (0,1,1)
r₁ r₂ r₃ : Sig
r₁ = sig true  true  false
r₂ = sig true  false true
r₃ = sig false true  true

-- THE DEPENDENCY: the three signatures sum to the zero vector, so the
-- product r₁·r₂·r₃ is a square — a manufactured square collision.
dependency : (r₁ ⊞ r₂ ⊞ r₃) ≡ zeroSig
dependency = refl

-- and the product is literally (2·3·5)², computed:
sqProduct : (2 · 3) · (2 · 5) · (3 · 5) ≡ (2 · 3 · 5) · (2 · 3 · 5)
sqProduct = refl

manufacturedRoot : ℕ
manufacturedRoot = 2 · 3 · 5      -- 30; its square 900 is the collision value

manufacturedSquare : ℕ
manufacturedSquare = (2 · 3) · (2 · 5) · (3 · 5)   -- 900
