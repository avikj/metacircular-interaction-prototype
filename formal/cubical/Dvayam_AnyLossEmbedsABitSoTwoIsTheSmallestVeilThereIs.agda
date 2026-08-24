-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वयम् — यत्र किञ्चित् नष्टं तत्र द्वयं गूढम् ।
--
-- (wherever anything is lost, a two is hidden.)
--
-- ────────────────────────────────────────────────────────────────────
-- README movement 34 says every wall this corpus hit is the same size,
-- ℤ/2, because "ℤ/2 is the smallest possible fibre — the minimal hiding
-- — so the first obstruction any observation meets is a bit."  That is
-- stated there as a pattern over instances.  Here it is as a theorem, and
-- it is not about any of those instances:
--
--   **any failure of injectivity embeds `Bool` into a fibre.**
--
-- Given two points the map cannot tell apart, the fibre over their common
-- image contains an injective copy of `Bool`.  So there is no such thing
-- as losing less than one bit: the moment an observation confuses
-- anything at all, a two is sitting inside the fibre, and every larger
-- loss contains this one.
--
-- WHICH IS WHY THE FIRST VEIL IS ALWAYS BINARY — not as a coincidence
-- across the sieve's parity, the determinant's mod-2 residue, the odd H¹
-- class and the rest, but because a bit is the floor and everything else
-- is above it.  Movement 34's list is a list of things that hit the
-- floor.
--
-- RELATION TO `Parampara_…agda`, checked before writing this and cited
-- rather than rediscovered.  That module constructs `Bool → fiber …`
-- SPECIFIC to a concrete three-chain, as one half of an iso computing
-- particular fibres.  This is the general statement — any `f`, any pair it
-- confuses — and neither subsumes the other: Parampara computes fibres,
-- this one says every nontrivial fibre contains a two.  Its §६ counting
-- and this floor are the same fact at two altitudes.
--
-- WHAT IS NOT CLAIMED.  Nothing about any of the instances movement 34
-- names; none of them is touched here, and this theorem does not explain
-- why a particular obstruction is EXACTLY one bit rather than more.  It
-- says only that one bit is the minimum, and it says nothing about
-- cardinality, measure, or entropy — "smallest" here means: embeds into
-- every nontrivial fibre, and nothing finer.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Dvayam_AnyLossEmbedsABitSoTwoIsTheSmallestVeilThereIs where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

module _ {A B : Type ℓ} (f : A → B) {a a' : A}
         (सङ्करः : f a ≡ f a')          -- the map confuses them
         (भेदः : ¬ (a ≡ a'))            -- and they are not the same
         where

------------------------------------------------------------------------
-- १ · द्वि-न्यासः — the two points, placed in one fibre.
------------------------------------------------------------------------

  द्वि-न्यासः : Bool → fiber f (f a)
  द्वि-न्यासः true  = a  , refl
  द्वि-न्यासः false = a' , sym सङ्करः

------------------------------------------------------------------------
-- २ · न्यासः निवेशः — and the placement is injective, so the fibre
--     genuinely contains a two.  There is no losing less than a bit.
------------------------------------------------------------------------

  द्वि-निवेशः : (x y : Bool) → द्वि-न्यासः x ≡ द्वि-न्यासः y → x ≡ y
  द्वि-निवेशः true  true  _ = refl
  द्वि-निवेशः false false _ = refl
  द्वि-निवेशः true  false p = Empty.rec (भेदः (cong fst p))
    where open import Cubical.Data.Empty as Empty using ()
  द्वि-निवेशः false true  p = Empty.rec (भेदः (sym (cong fst p)))
    where open import Cubical.Data.Empty as Empty using ()
