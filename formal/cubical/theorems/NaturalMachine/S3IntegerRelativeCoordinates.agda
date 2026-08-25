{-# OPTIONS --cubical --safe #-}

-- Exact coordinates on the augmentation-zero lattice.  Over ℤ the relative
-- plane is ℤ² via (a,b) ↦ (a,b,-a-b).  The radial intersection is the
-- 3-torsion kernel, which is then proved zero using integer torsion-freeness.
-- No integral direct-sum splitting with the radial line is asserted.

module NaturalMachine.S3IntegerRelativeCoordinates where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels using (isProp× ; isPropΣ)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; Σ≡Prop)
open import Cubical.Data.Int
  using (ℤ ; pos ; _+_ ; _·_ ; -_ ; isSetℤ ; ·suc→0 ; ·Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import NaturalMachine.S3IntegerPermutationModule

RelativeVector : Type₀
RelativeVector = Σ[ v ∈ ℤ³ ] Relative v

relativeFromCoordinates : ℤ × ℤ → RelativeVector
relativeFromCoordinates (a , b) =
  vec3 a b (- (a + b)) , solve! ℤCommRing

relativeCoordinates : RelativeVector → ℤ × ℤ
relativeCoordinates (vec3 a b c , p) = a , b

coordinates-from-relative : (q : ℤ × ℤ)
  → relativeCoordinates (relativeFromCoordinates q) ≡ q
coordinates-from-relative (a , b) = refl

third-coordinate : (a b c : ℤ) → a + (b + c) ≡ pos 0
  → - (a + b) ≡ c
third-coordinate a b c p = sym chain
  where
  chain : c ≡ - (a + b)
  chain =
      solve! ℤCommRing
    ∙ cong (λ z → z + (- (a + b))) p
    ∙ solve! ℤCommRing

relative-from-coordinates : (v : RelativeVector)
  → relativeFromCoordinates (relativeCoordinates v) ≡ v
relative-from-coordinates (vec3 a b c , p) =
  Σ≡Prop (λ _ → isSetℤ _ _) vectorPath
  where
  vectorPath : vec3 a b (- (a + b)) ≡ vec3 a b c
  vectorPath i = vec3 a b (third-coordinate a b c p i)

relativeCoordinateIso : Iso (ℤ × ℤ) RelativeVector
Iso.fun relativeCoordinateIso = relativeFromCoordinates
Iso.inv relativeCoordinateIso = relativeCoordinates
Iso.rightInv relativeCoordinateIso = relative-from-coordinates
Iso.leftInv relativeCoordinateIso = coordinates-from-relative

relativeSwap₀₁ : ℤ × ℤ → ℤ × ℤ
relativeSwap₀₁ (a , b) = b , a

relativeSwap₁₂ : ℤ × ℤ → ℤ × ℤ
relativeSwap₁₂ (a , b) = a , - (a + b)

swap₀₁-relative-coordinates : (q : ℤ × ℤ)
  → swap₀₁ (fst (relativeFromCoordinates q))
    ≡ fst (relativeFromCoordinates (relativeSwap₀₁ q))
swap₀₁-relative-coordinates (a , b) i =
  vec3 b a (lem i)
  where
  lem : - (a + b) ≡ - (b + a)
  lem = solve! ℤCommRing

swap₁₂-relative-coordinates : (q : ℤ × ℤ)
  → swap₁₂ (fst (relativeFromCoordinates q))
    ≡ fst (relativeFromCoordinates (relativeSwap₁₂ q))
swap₁₂-relative-coordinates (a , b) i =
  vec3 a (- (a + b)) (lem i)
  where
  lem : b ≡ - (a + (- (a + b)))
  lem = solve! ℤCommRing

triple : ℤ → ℤ
triple t = t + (t + t)

radialAt : ℤ → ℤ³
radialAt t = vec3 t t t

-- A point of the radial/relative intersection is a radial parameter together
-- with the proof that its radial vector lies in the relative plane.
RadialRelative : Type₀
RadialRelative = Σ[ t ∈ ℤ ] Relative (radialAt t)

ThreeKernel : Type₀
ThreeKernel = Σ[ t ∈ ℤ ] triple t ≡ pos 0

intersectionToKernel : RadialRelative → ThreeKernel
intersectionToKernel (t , rel) = t , rel

kernelToIntersection : ThreeKernel → RadialRelative
kernelToIntersection (t , p) = t , p

intersection-kernel-right : (x : ThreeKernel)
  → intersectionToKernel (kernelToIntersection x) ≡ x
intersection-kernel-right (t , p) = Σ≡Prop (λ _ → isSetℤ _ _) refl

intersection-kernel-left : (x : RadialRelative)
  → kernelToIntersection (intersectionToKernel x) ≡ x
intersection-kernel-left (t , p) = refl

intersectionKernelIso : Iso RadialRelative ThreeKernel
Iso.fun intersectionKernelIso = intersectionToKernel
Iso.inv intersectionKernelIso = kernelToIntersection
Iso.rightInv intersectionKernelIso = intersection-kernel-right
Iso.leftInv intersectionKernelIso = intersection-kernel-left

-- 3t=0 implies t=0 in ℤ.  The ring solver changes additive `triple` into
-- multiplication by positive three; the library's `·suc→0` supplies the
-- torsion-free step.
triple-zero→zero : (t : ℤ) → triple t ≡ pos 0 → t ≡ pos 0
triple-zero→zero t p = ·suc→0 t 2 (mul3 t ∙ p)
  where
  mul3 : (z : ℤ) → z · pos 3 ≡ triple z
  mul3 z = ·Comm z (pos 3)

radial-relative-parameter-zero : (x : RadialRelative) → fst x ≡ pos 0
radial-relative-parameter-zero (t , p) = triple-zero→zero t p
