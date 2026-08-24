-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- छन्दोमुद्रा — छन्दो मात्रामानस्य तन्तुः एव ।
--
-- (a metre is nothing but the fibre of the mātrā-count.)
--
-- ────────────────────────────────────────────────────────────────────
-- HOW THIS WAS FOUND, because the method is the point.
--
-- `machine/Lopa_…hs` grades every irreversible edge in this corpus and
-- reports 1045 of them UNDECIDED — no syntactic rule names a fibre.
-- Three of those undecided edges are
--
--     PingalaPrastara.Pattern ⟶ ℕ    « matraOf
--     PingalaPrastara.Pattern ⟶ ℕ    « varna
--     PingalaPrastara.Pattern ⟶ ℕ    « guruOf
--
-- and their fibres are DEFINED FIFTEEN LINES BELOW THEM, in the same
-- file, by name.  `PingalaPrastara.agda:55` says so in prose: *"`Vak n`,
-- `Metre n` and `Chosen n k` are its fibres over …"*.  No term said it,
-- so the census could not see it, so it reported the corpus barren at
-- exactly the place the corpus had already answered.
--
-- That is this repository's oldest failure mode arriving in its newest
-- instrument, and it is the same one that let a European name stand over
-- an Indian result for four centuries: **an instrument that cannot see
-- reports that nothing is there.**  The repair is not a better census.
-- It is to LOOK UP the answer before proposing to construct one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED.  Nothing is constructed; all three are `refl`.
--
--   `fiber f b` unfolds to `Σ[ a ] (f a ≡ b)`, and
--   `Metre n`  is  `Σ[ p ∈ Pattern ] (matraOf p ≡ n)`.
--
-- They are the same type on the nose.  Writing it down costs one line
-- and turns a prose remark into something a machine can join on.
--
-- §३ is the one that is not definitional and is the more interesting:
-- `Chosen n k` is the JOINT fibre of two observables at once, and it
-- equals `fiber ⟨ varna , guruOf ⟩ (n , k)` only after Σ-reassociation,
-- because a pair of equations is not an equation of pairs until you say
-- so.  That gap is exactly where a joint measurement differs from two
-- separate ones.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE PRICE HAS A CLOSED FORM ALREADY PROVED IN THE HOST.
--
-- `PingalaPrastara.matrameruIso : Metre (2+n) ≃ Metre (1+n) ⊎ Metre n`.
-- So the fibre of the mātrā-count satisfies VIRAHĀṄKA'S RECURRENCE — the
-- मात्रामेरु — and the receipt for that cut is not a bound or an estimate
-- but a named type whose cardinality is a sequence the tradition
-- tabulated.  Virahāṅka, *Vṛttajātisamuccaya*, c. 600–800 CE (the range
-- is H. D. Velankar's, from his 1962 edition; NOT "~700", which this
-- repository's own searched ledger forbids in those words).  The
-- recurrence is usually cited under Fibonacci's name, 1202, which is a
-- restatement and is named here after the source and as one.
--
-- The array whose row sums these are is Piṅgala's, छन्दःशास्त्रम्
-- ८.३४–३५, ~300 BCE, with the construction rule — अग्रिम-पङ्क्तिः
-- पूर्व-पङ्क्तेः पार्श्व-योगैः, the next row from the ADJACENT SUMS of the
-- previous — stated by हलायुध in the मृतसञ्जीवनी, 10th c.
--
-- NOT CLAIMED: neither Piṅgala nor Virahāṅka nor Halāyudha stated a
-- fibre, a type, or an equivalence.  What is claimed is that the objects
-- their pratyayas enumerate ARE the fibres of the counting maps, which is
-- a fact about the definitions in `PingalaPrastara.agda` and not an
-- attribution.  छन्दोमुद्रा is built here, not attested; छन्दस् and मुद्रा
-- are ordinary Sanskrit and no text is claimed for the compound.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma

open import PingalaPrastara
  using (Pattern ; matraOf ; varna ; guruOf ; Metre ; Vak ; Chosen)

------------------------------------------------------------------------
-- १ · मात्रावृत्तम् — a metre IS the fibre of the mātrā-count.
------------------------------------------------------------------------

मात्रा-तन्तुः : (n : ℕ) → fiber matraOf n ≡ Metre n
मात्रा-तन्तुः n = refl

------------------------------------------------------------------------
-- २ · वर्णवृत्तम् — and a syllable-metre is the fibre of the syllable count.
------------------------------------------------------------------------

वर्ण-तन्तुः : (n : ℕ) → fiber varna n ≡ Vak n
वर्ण-तन्तुः n = refl

------------------------------------------------------------------------
-- ३ · The joint fibre, which is NOT definitional.
--
-- `Chosen n k = Σ[ p ] ((varna p ≡ n) × (guruOf p ≡ k))` — a PAIR OF
-- EQUATIONS.  The fibre of the paired map is `Σ[ p ] ((varna p , guruOf p)
-- ≡ (n , k))` — an EQUATION OF PAIRS.  Those agree only through
-- `ΣPathP`/`ΣPath≃`, and the passage is exactly the content: measuring
-- two observables jointly is not the same act as measuring each.
------------------------------------------------------------------------

युग्म-मानम् : Pattern → ℕ × ℕ
युग्म-मानम् p = varna p , guruOf p

युग्म-तन्तुः : (n k : ℕ) → fiber युग्म-मानम् (n , k) ≃ Chosen n k
युग्म-तन्तुः n k =
  Σ-cong-equiv-snd (λ p → invEquiv ΣPath≃PathΣ)

------------------------------------------------------------------------
-- ४ · शेषः — what this leaves, and it is a method rather than a theorem.
--
-- Three of the census's 1045 undecided edges are priced by three `refl`s
-- and one library equivalence, because their receipts were already
-- written in the file the census read.  The join that found them matched
-- SOURCE TYPES against definitions of the form `Σ[ a ∈ A ] (… ≡ i)` —
-- there are 46 such written-out fibres in this corpus, and 11 of the
-- queue's 249 distinct source types have one.
--
-- A source-type match is a LEAD, not a verdict: the first one checked
-- (`MatraVarnaGuru.लघु-सङ्ख्या` against `Metre`) did NOT close, because
-- लघु-सङ्ख्या counts laghus and `matraOf` sums morae — different maps
-- through the same types.  Reporting the lead as a hit would be the
-- दुर्नय this apparatus exists against, so it is reported as a lead and
-- the ones that closed are here.
--
-- Still open in this file's own neighbourhood: `guruOf` and
-- `PingalaPrastara.uddista` are in the queue and are not priced here.
------------------------------------------------------------------------
