{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- दुर्नयः सामर्थ्ये — the symmetry readout is two-valued, therefore a
-- durnaya, and WHICH two seeds it identifies is computed, not argued.
--
-- दुर्नय: a naya that asserts itself by denying the others — Siddhasena
-- Divākara, *Sanmatitarka* 1.21, c. 5th c. CE.  Carried at ग्रेड·शब्द from
-- `SaptabhangiSamyoga`'s source list; no edition opened by me.  Nothing
-- below is claimed to be Siddhasena's.
--
------------------------------------------------------------------------
-- `Saptabhangi.दुर्नयः` proves that ANY `f : सप्तभङ्गी → द्विपद` identifies two
-- of the three seeds.  It has been read here as a fact about boolean
-- verdicts inside this machine.  It is a fact about every two-valued
-- instrument applied to a threefold situation, and the SYMMETRY GROUP is
-- one of those.
--
-- THE READING, stated first because the checked part is small and the
-- reading is what makes it worth writing.  For `f : A → B`, an automorphism
-- of A over B restricts to a self-equivalence of each fibre.  A fibre that
-- is a PROPOSITION — empty or contractible — has exactly one.  So the
-- conserving group is a product over the CROWDED points only, and it is
-- trivial for every embedding, no matter how much of B that embedding
-- misses.  `Aut_B(A)` therefore reads exactly ONE of the three census
-- coordinates: whether नास्ति occurs anywhere.
--
-- NOT CHECKED HERE, and named so it is not mistaken for checked: the
-- equivalence `Aut_B(A) ≃ Π_b Aut(शेष f b)` and its corollary that the group
-- is trivial exactly on embeddings.  That is the term this module is
-- waiting for.  `AtmasamataUpari_…` already carries the two poles (trivial
-- at `isEquiv`, all of `Aut(A)` at total collapse) and the interior is what
-- is missing.  Until it lands, §1 is a MODEL of the readout — a map
-- सप्तभङ्गी → द्विपद defined by the नास्ति slot — and every theorem here is a
-- theorem about the model.
--
-- WHAT IS CHECKED:
--
--   §2  the model merges स्यात्-अस्ति with स्यात्-अवक्तव्यम् (refl) and separates
--       स्यात्-अस्ति from स्यात्-नास्ति.  The identification is that pair and no
--       other.
--   §3  `Saptabhangi.दुर्नयः` RUN ON THIS READOUT reduces to `inr (inl refl)`
--       — the middle disjunct — by `refl`.  The corpus's theorem does not
--       merely apply; it COMPUTES the diagnosis.
--
-- WHAT IT SAYS.  A two-valued readout of the threefold must identify two,
-- and this one identifies **grasped-whole with missed-entirely**.  A map
-- that carries everything and a map blind to most of its codomain are the
-- same to it, provided neither destroys a distinction.
--
-- Which is the shape of every instrument the engine has.  Laghava is a
-- function ON the fibre (`NaturalMachine.Laghava`: no function of the
-- denotation computes the size), so compression measures crowding.  A
-- scalar gain is two-valued at any threshold.  A test list samples the
-- SOURCE, so it can witness confusion and never absence.
-- `YantraTantu_…§5` proves the engine has a meaning no term of its
-- vocabulary reaches (`अप्राप्यम्`), and §6 records that the invention
-- trigger fires on a crowding quantity.  This module says why that is not
-- a tuning error: the coordinate such a trigger would need is the one every
-- instrument of this shape merges away.
--
-- Symmetry as a naya is powerful and nothing here takes that from it.
-- Symmetry as THE criterion is the durnaya, and §3 prices it.
--
-- CHECKED: Agda 2.6.3, agda/cubical v0.5, this lane's .agda-lib,
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Durnayah_TheSymmetryReadoutIsTwoValuedAndComputablyMergesGraspedWholeWithMissedEntirely where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Saptabhangi

------------------------------------------------------------------------
-- १ · the readout.  सत् = the conserving group is trivial (no crowded fibre
--     anywhere); असत् = it is not.  One coordinate out of three.
------------------------------------------------------------------------

सत्≢असत् : ¬ (सत् ≡ असत्)
सत्≢असत् q = subst विवेकः q tt
  where विवेकः : द्विपद → Type
        विवेकः सत्  = Unit
        विवेकः असत् = ⊥

सामर्थ्य-पाठः : सप्तभङ्गी → द्विपद
सामर्थ्य-पाठः b with fst (snd (अन्तर्भाव b))     -- the नास्ति slot, and only it
... | आम् = असत्
... | न   = सत्

------------------------------------------------------------------------
-- २ · which pair it identifies, and that it is exactly that pair.
------------------------------------------------------------------------

सामर्थ्यं-मेलयति : सामर्थ्य-पाठः स्यात्-अस्ति ≡ सामर्थ्य-पाठः स्यात्-अवक्तव्यम्
सामर्थ्यं-मेलयति = refl

सामर्थ्यं-विवेचयति : ¬ (सामर्थ्य-पाठः स्यात्-अस्ति ≡ सामर्थ्य-पाठः स्यात्-नास्ति)
सामर्थ्यं-विवेचयति = सत्≢असत्

------------------------------------------------------------------------
-- ३ · दुर्नयः, run on it, COMPUTES the middle disjunct.
------------------------------------------------------------------------

दुर्नय-निर्णयः : (सामर्थ्य-पाठः स्यात्-अस्ति ≡ सामर्थ्य-पाठः स्यात्-नास्ति)
              ⊎ ((सामर्थ्य-पाठः स्यात्-अस्ति ≡ सामर्थ्य-पाठः स्यात्-अवक्तव्यम्)
              ⊎  (सामर्थ्य-पाठः स्यात्-नास्ति ≡ सामर्थ्य-पाठः स्यात्-अवक्तव्यम्))
दुर्नय-निर्णयः = दुर्नयः सामर्थ्य-पाठः

मध्यमः : दुर्नय-निर्णयः ≡ inr (inl refl)
मध्यमः = refl
