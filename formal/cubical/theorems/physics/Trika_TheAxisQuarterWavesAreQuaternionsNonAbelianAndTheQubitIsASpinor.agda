{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Trika_TheAxisQuarterWavesAreQuaternionsNonAbelian
--       AndTheQubitIsASpinor
--
-- TERM.  त्रिक · trika — a triad; here the three axis quarter-waves i, j, k.
-- A common Sanskrit word, no technical-source claim.  The physics (quaternion
-- gates, SU(2)/SO(3), spinor, Poincaré sphere) is modern; the compound and
-- the identification are built here, 2026-08-24.
--
-- THE READING (checked terms below).  Companion to `Mani_…`: one orb is a
-- single √NOT quarter-wave.  Waveplates on DIFFERENT axes are the three
-- generators i, j, k of the single-qubit gate group; together they generate
-- all of SU(2) (two non-parallel rotations suffice).  Their finite skeleton
-- is the QUATERNION GROUP Q8, and its two facts are the two facts of the
-- device's gate layer:
--   (1) NON-ABELIAN — `ij≢ji`.  The order in which a photon threads the orbs
--       is physical; that order-dependence is where computational power lives
--       (cf. `VeniYangBaxtara_…`, the braid).  This is what makes a network of
--       orbs — an इन्द्रजाल, Indra's net — universal rather than a single phase.
--   (2) SPINOR / DOUBLE COVER — `full-turn-is-minus-one`, `double-turn-returns`,
--       `minus-one-is-not-one`.  A full turn about an axis is −1, not 1; a
--       second full turn returns.  SU(2) double-covers SO(3): the Poincaré
--       sphere (physical polarizations) is SO(3)=S², but the qubit STATE that
--       carries the phase is the spinor above it — S³, the Hopf total space.
--       The orb remembers a single rotation as a sign.
--
-- WHAT IS CHECKED, exactly.  Q8 = Bool × B (sign × {e,i,j,k}) with the
-- quaternion product; then `i² ≡ j² ≡ k² ≡ -𝟙` (three axis quarter-waves each
-- squaring to the NOT/π element), `ij ≡ k`, `ji ≡ -k`, `ij≢ji` (a hard ¬), and
-- the spinor relations.  All by computation / `true≢false`.
--
-- NOT CLAIMED.  Q8 is the finite skeleton of SU(2), not SU(2) itself; no
-- continuum, no S³, no Fresnel coefficients are checked — only the group
-- relations the polarization gates obey.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Trika_TheAxisQuarterWavesAreQuaternionsNonAbelianAndTheQubitIsASpinor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

data B : Type where be bi bj bk : B
Q : Type
Q = Bool × B                      -- sign (true=+1, false=-1) × basis

signMul : Bool → Bool → Bool
signMul true  s = s
signMul false s = not s

bMul : B → B → B
bMul be y = y
bMul x be = x
bMul bi bi = be ; bMul bj bj = be ; bMul bk bk = be
bMul bi bj = bk ; bMul bj bk = bi ; bMul bk bi = bj
bMul bj bi = bk ; bMul bk bj = bi ; bMul bi bk = bj

bSign : B → B → Bool
bSign be y = true
bSign x be = true
bSign bi bi = false ; bSign bj bj = false ; bSign bk bk = false
bSign bi bj = true  ; bSign bj bk = true  ; bSign bk bi = true
bSign bj bi = false ; bSign bk bj = false ; bSign bi bk = false

_·_ : Q → Q → Q
(s1 , b1) · (s2 , b2) = (signMul (signMul s1 s2) (bSign b1 b2) , bMul b1 b2)

𝟙 -𝟙 i j k : Q
𝟙  = (true  , be) ; -𝟙 = (false , be)
i  = (true  , bi) ; j  = (true  , bj) ; k  = (true , bk)

-- three axis quarter-waves, each squaring to the NOT/π element −1
i² : i · i ≡ -𝟙
i² = refl
j² : j · j ≡ -𝟙
j² = refl
k² : k · k ≡ -𝟙
k² = refl

-- non-abelian: ij = k, ji = −k
ij : i · j ≡ k
ij = refl
ji : j · i ≡ (false , bk)
ji = refl
ij≢ji : ¬ (i · j ≡ j · i)
ij≢ji p = true≢false (cong fst p)

-- spinor / double cover
full-turn-is-minus-one : i · i ≡ -𝟙
full-turn-is-minus-one = refl
double-turn-returns : (i · i) · (i · i) ≡ 𝟙
double-turn-returns = refl
minus-one-is-not-one : ¬ (-𝟙 ≡ 𝟙)
minus-one-is-not-one p = true≢false (cong fst (sym p))
