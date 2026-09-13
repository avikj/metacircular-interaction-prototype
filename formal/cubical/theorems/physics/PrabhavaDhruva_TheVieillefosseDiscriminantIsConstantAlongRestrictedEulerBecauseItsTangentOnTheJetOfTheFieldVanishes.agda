{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रभव-ध्रुव — the flow's constant.
--
-- Restricted Euler is the local, pressure-Hessian-free model of a
-- velocity-gradient history under zero expansion: with Q and R the two
-- nontrivial invariants of the trace-free gradient,
--
--     Q̇ = −3R,   Ṙ = (2/3) Q²,
--
-- and it conserves D = 27R² + 4Q³.  The escaping Vieillefosse branch
-- lies in D⁻¹(0).  So local zero-expansion shear geometry can run to
-- infinity inside a conserved fibre, and local deformation theory alone
-- cannot kill a blow-up witness.  This file makes that conservation a
-- term, and it does so by the corpus's own derivation: the tangent of a
-- polynomial along a vector field is the ε-part of the polynomial
-- evaluated on the first-order jet of the field.
--
--   §1  THE JET OVER ANY COMMUTATIVE RING.  Pairs (x , x′) with the
--       dual-number product; the Euler derivation reads off x′; Leibniz
--       is a ring identity, discharged by the ring solver.
--
--   §2  THE FIELD AND THE DISCRIMINANT.  Time is rescaled by 3 so the
--       field is integral: Q̇ = −9R, Ṙ = 2Q².  The jet of the state
--       along the field is (Q , −9R) , (R , 2Q²).
--
--   §3  THE TANGENT OF D VANISHES.  D evaluated on that jet has base D
--       and ε-part 108·R·Q² − 108·R·Q², which the solver normalises to
--       zero.  Hence D is constant along the flow, and the branch D = 0
--       is invariant: a jet based at a zero of D is the zero jet.
--
--   §4  THE VIEILLEFOSSE POINT.  Over ℤ, (Q , R) = (−3 , 2) has
--       D = 108 − 108 = 0: an explicit inhabitant of the escaping fibre.
--
-- Read against Sphota: this is the reading "local anisotropic escape is
-- lawful," inhabited.  Its partner — global pressure realisability of
-- the same history — is the reading whose joint fibre with this one is
-- the obligation.  प्रभव (prabhava, source/origin of a flow) and ध्रुव
-- (dhruva, constant) are ordinary Sanskrit.
------------------------------------------------------------------------

module PrabhavaDhruva_TheVieillefosseDiscriminantIsConstantAlongRestrictedEulerBecauseItsTangentOnTheJetOfTheFieldVanishes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int.Base hiding (_+_ ; _·_ ; _-_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver
open import Cubical.Tactics.CommRingSolver.RawAlgebra using (scalar)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  ----------------------------------------------------------------------
  -- १ · The jet over R and the Euler derivation.
  ----------------------------------------------------------------------

  Jet : Type ℓ
  Jet = ⟨ R ⟩ × ⟨ R ⟩

  _⊞_ : Jet → Jet → Jet
  (a , a′) ⊞ (b , b′) = (a + b , a′ + b′)

  _⊠_ : Jet → Jet → Jet
  (a , a′) ⊠ (b , b′) = (a · b , a · b′ + a′ · b)

  pravāha : Jet → Jet
  pravāha (a , a′) = (0r , a′)

  -- a ring constant as a jet with no tangent
  sthira : ⟨ R ⟩ → Jet
  sthira c = (c , 0r)

  leibniz : (x y : Jet) → pravāha (x ⊠ y) ≡ (pravāha x ⊠ y) ⊞ (x ⊠ pravāha y)
  leibniz (a , a′) (b , b′) i = (mūla i , śeṣa i)
    where
    mūla : 0r ≡ 0r · b + a · 0r
    mūla = solve! R
    śeṣa : a · b′ + a′ · b ≡ (0r · b′ + a′ · b) + (a · b′ + a′ · 0r)
    śeṣa = solve! R

  ----------------------------------------------------------------------
  -- २ · The restricted-Euler field and the discriminant.
  ----------------------------------------------------------------------

  -- D(Q , R) = 27 R² + 4 Q³
  D : ⟨ R ⟩ → ⟨ R ⟩ → ⟨ R ⟩
  D q r = scalar R 27 · (r · r) + scalar R 4 · (q · (q · q))

  -- the jet of the state along the field (Q̇ , Ṙ) = (−9R , 2Q²)
  q-jet : ⟨ R ⟩ → ⟨ R ⟩ → Jet
  q-jet q r = (q , scalar R (negsuc 8) · r)

  r-jet : ⟨ R ⟩ → ⟨ R ⟩ → Jet
  r-jet q r = (r , scalar R 2 · (q · q))

  -- D evaluated on the jet of the field
  D-jet : ⟨ R ⟩ → ⟨ R ⟩ → Jet
  D-jet q r =
    (sthira (scalar R 27) ⊠ (r-jet q r ⊠ r-jet q r))
      ⊞ (sthira (scalar R 4) ⊠ (q-jet q r ⊠ (q-jet q r ⊠ q-jet q r)))

  ----------------------------------------------------------------------
  -- ३ · The tangent of D along the field vanishes.
  ----------------------------------------------------------------------

  -- the jet is based at D itself …
  D-jet-mūla : (q r : ⟨ R ⟩) → fst (D-jet q r) ≡ D q r
  D-jet-mūla q r = solve! R

  -- … and its tangent is zero: D is constant along restricted Euler.
  D-dhruva : (q r : ⟨ R ⟩) → snd (D-jet q r) ≡ 0r
  D-dhruva q r = solve! R

  -- so the escaping branch D = 0 is invariant: at a zero of D the whole
  -- jet of D along the field is the zero jet.
  śūnya-śākhā : (q r : ⟨ R ⟩) → D q r ≡ 0r → D-jet q r ≡ (0r , 0r)
  śūnya-śākhā q r z i = (D-jet-mūla q r ∙ z) i , D-dhruva q r i

------------------------------------------------------------------------
-- ४ · The Vieillefosse point over ℤ: (Q , R) = (−3 , 2) lies on D = 0.
------------------------------------------------------------------------

vieillefosse : D ℤCommRing (negsuc 2) (pos 2) ≡ pos 0
vieillefosse = refl
