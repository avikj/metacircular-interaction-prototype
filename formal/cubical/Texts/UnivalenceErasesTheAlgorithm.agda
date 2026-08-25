{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.UnivalenceErasesTheAlgorithm
--
-- What univalence does to `OptimalObservation`'s three instances, and
-- what it costs.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT DOES
--
-- All three enumerations are equivalences onto `Fin k`.  By `ua` they are
-- therefore PATHS: Piṅgala's metres, Virahāṅka's metres and the walk's
-- residue vectors are not merely counted the same, they are EQUAL as
-- types, and every property of one transports to the others.
--
--     same-count→same-type :  saṅkhyā n ≡ mātrā m  →  Vak n ≡ Metre m
--
-- and concretely `Vak 1 ≡ Metre 2` — the one-syllable patterns and the
-- duration-two metres, two different combinatorial families from two
-- traditions four centuries apart, identified by a path.
--
-- That is a real thing to be able to say and it is Voevodsky's to say.
-- Without univalence "they are the same" is a remark about cardinalities;
-- with it, it is an identification along which anything transports.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT COSTS, AND THE COST IS THE POINT
--
-- The three enumerations are three ALGORITHMS:
--
--   naṣṭa/uddiṣṭa    halve the row number, read the remainder as
--                    laghu/guru, and run it backwards (Piṅgala, c. 300 BCE)
--   mātrāmeru        delete the first syllable and recurse on the two
--                    shorter durations (Virahāṅka, c. 600–800)
--   CRT              split the residue by coprime moduli (the walk)
--
-- The path identifies them and keeps none of that.  Transport along
-- `ua e` reduces to `equivFun e` — the equivalence, not the algorithm
-- that computes it — and by `Laghava.laghava-is-not-semantic` there is no
-- function of the identified object that recovers the size of any
-- presentation of it.
--
--     Univalence identifies the three enumerations, and in identifying
--     them discards exactly what distinguishes them.
--
-- That is not a complaint about univalence.  It is the same observation
-- `Laghava` makes about denotations, at the scale of whole traditions:
-- the equality is real, and the mathematics that differs between naṣṭa
-- and CRT lives entirely in the fibre the equality collapses.
--
-- WHICH IS WHY PĀṆINI'S CRITERION IS NOT OPTIONAL.  A tradition that
-- could only see denotations would have no reason to prefer naṣṭa to a
-- lookup table, both being equivalences onto `Fin (saṅkhyā n)`.  लाघव is
-- the criterion that distinguishes them, it is not semantic, and
-- `Anuvrtti` shows it is not even a function of the rule set.
--
-- WHAT IS NOT CLAIMED.  That univalence is a defective tool, or that the
-- transport theorem loses information it was supposed to keep — `ua`
-- keeps exactly what an equivalence is, which is all it claims.  Nor that
-- naṣṭa and CRT are "really" different in any sense this lane can state
-- beyond `Laghava`'s: they compute the same function, and that is the
-- theorem.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module Texts.UnivalenceErasesTheAlgorithm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (compEquiv ; invEquiv ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Fin using (Fin)

open import Texts.PingalaPrastara using (Vak ; sankhya ; uddistaIso ; Metre ; matra ; matraCount)

------------------------------------------------------------------------
-- 1.  Each enumeration is a path
------------------------------------------------------------------------

vak-path : (n : ℕ) → Vak n ≡ Fin (sankhya n)
vak-path n = ua (isoToEquiv (uddistaIso n))

metre-path : (n : ℕ) → Metre n ≡ Fin (matra n)
metre-path n = ua (isoToEquiv (matraCount n))

------------------------------------------------------------------------
-- 2.  Equal counts give equal types, across the two traditions
------------------------------------------------------------------------

same-count→same-type :
  (n m : ℕ) → sankhya n ≡ matra m → Vak n ≡ Metre m
same-count→same-type n m p =
  vak-path n ∙ cong Fin p ∙ sym (metre-path m)

-- concretely: one-syllable patterns and duration-two metres.
-- saṅkhyā 1 = 2 = mātrā 2, both by computation.
count-1-2 : sankhya 1 ≡ matra 2
count-1-2 = refl

vak1≡metre2 : Vak 1 ≡ Metre 2
vak1≡metre2 = same-count→same-type 1 2 count-1-2

------------------------------------------------------------------------
-- 3.  What transport along such a path actually is
--
-- `uaβ` — transporting along `ua e` is applying `e`.  So the path carries
-- the equivalence and nothing else: not the halving, not the recurrence,
-- not the coprime splitting.  The algorithms are in the fibre the
-- identification collapses.
------------------------------------------------------------------------

transport-is-the-equivalence :
  (n : ℕ) (v : Vak n)
  → transport (vak-path n) v ≡ equivFun (isoToEquiv (uddistaIso n)) v
transport-is-the-equivalence n v = uaβ (isoToEquiv (uddistaIso n)) v

------------------------------------------------------------------------
-- 4.  The sentence.
--
-- Univalence makes Piṅgala's enumeration, Virahāṅka's, and the walk's the
-- same object.  `Laghava` is why that sameness is not the end of the
-- subject: the criterion that separates naṣṭa from a lookup table is not
-- a function of the object, and no amount of transporting will produce
-- one.
--
-- The identification is Voevodsky's contribution and it is exact.  The
-- residue it leaves is Pāṇini's, and it is the part with the algorithms
-- in it.
------------------------------------------------------------------------
