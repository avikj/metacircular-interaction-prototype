-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WitnessNumberIsThePotential
--
-- `TransportPrice` closed the anekānta thread with a theorem and a
-- deflation:
--
--     cocycle→coboundary : c p q ≡ c b q − c b p
--
-- every additive transport price is the difference of a potential, so
-- there is no path-dependence, no cheapest route, no holonomy — "all
-- the content is in the potential, a number attached to each standpoint
-- on its own".
--
-- That theorem says where to look and does not say what to find.  This
-- module supplies a potential: the witness number.
--
-- ────────────────────────────────────────────────────────────────────
-- THE NUMBER, AND THAT TRANSPORT DOES NOT MOVE IT
--
--     WitnessNumberIs law n  =  some length-n list refutes
--                             × no shorter list does
--
--     witness-invariant  : isSurjection f
--                        → WitnessNumberIs law n
--                        → WitnessNumberIs (reindex f law) n
--     witness-invariant' : the converse, same hypothesis
--
-- So along any surjective reindexing of the decoder space the number is
-- unchanged: its transport price is identically zero.  That is what a
-- potential looks like when you have one — the price between two nayas
-- related by a reindexing is 0, and every nonzero price is between
-- systems no reindexing connects.
--
-- ────────────────────────────────────────────────────────────────────
-- THE THREE THREADS, MET
--
--   anekānta      collapse is settled; the remaining question was price
--                 (`Anekanta`, `TransportPrice`)
--   deflation     every absence here is exact, and now measured
--                 (`WitnessNumberIsTwo`, `WhyTheSitesAreTwo`)
--   लाघव          is there a measure stable under reformulation
--                 (`Laghava`: not on presentations)
--
-- The witness number answers the third affirmatively for absences, is
-- the second's measure, and has the first's price identically zero.
-- The one place it does NOT go is लाघव's own question: it measures
-- absences, not presentations, and `Laghava` still answers that no.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT A COINCIDENCE, AND NOT A TRIUMPH
--
-- The price is zero because the number is defined by ∀ over the decoder
-- space, and reindexing does not change what is quantified over.  A
-- potential with identically zero price is the DEGENERATE case of
-- `TransportPrice`'s theorem, not a rich instance of it: it says the
-- nayas related by reindexing are all at one height.  The theorem's
-- content — that no additive price can do better than a potential — is
-- what makes that unimprovable rather than disappointing.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WitnessNumberIsThePotential where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ¬-<-zero ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Surjection using (isSurjection)

open import NaturalMachine.WitnessNumberIsTwo using (Refutes)
open import NaturalMachine.WitnessNumberIsInvariant
  using (reindex ; refutes-reindex ; refutes-reflect)
open import NaturalMachine.WitnessNumberIsUnbounded
  using ( Three ; t0 ; t1 ; t2 ; law ; triple ; three-refute
        ; no-pair-refutes ; no-single-refutes ; no-empty-refutes )

private
  variable
    ℓd ℓd' ℓx ℓ : Level

------------------------------------------------------------------------
-- 1.  The number
------------------------------------------------------------------------

WitnessNumberIs : {D : Type ℓd} {X : Type ℓx}
                → (D → X → Type ℓ) → ℕ → Type (ℓ-max ℓx (ℓ-max ℓd ℓ))
WitnessNumberIs {X = X} law n =
    (Σ[ xs ∈ List X ] ((length xs ≡ n) × Refutes law xs))
  × ((ys : List X) → length ys < n → ¬ Refutes law ys)

------------------------------------------------------------------------
-- 2.  TRANSPORT DOES NOT MOVE IT
--
-- The lists live in X, which the reindexing does not touch, so both
-- halves transport directly: the exhibited list by preservation, the
-- minimality by reflection.
------------------------------------------------------------------------

witness-invariant :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (f : D' → D) → isSurjection f
  → (law : D → X → Type ℓ) (n : ℕ)
  → WitnessNumberIs law n → WitnessNumberIs (reindex f law) n
witness-invariant f surj law n ((xs , len , ref) , least) =
    (xs , len , refutes-reindex f law xs ref)
  , (λ ys short r → least ys short (refutes-reflect f surj law ys r))

witness-invariant' :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (f : D' → D) → isSurjection f
  → (law : D → X → Type ℓ) (n : ℕ)
  → WitnessNumberIs (reindex f law) n → WitnessNumberIs law n
witness-invariant' f surj law n ((xs , len , ref) , least) =
    (xs , len , refutes-reflect f surj law xs ref)
  , (λ ys short r → least ys short (refutes-reindex f law ys r))

------------------------------------------------------------------------
-- 3.  So the transport price of the witness number is zero
--
-- Stated as the thing `TransportPrice` would call a price: along a
-- surjective reindexing, the number on one side is the number on the
-- other, in both directions.  There is nothing left for a price to
-- measure.
------------------------------------------------------------------------

price-is-zero :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (f : D' → D) → isSurjection f
  → (law : D → X → Type ℓ) (n : ℕ)
  → (WitnessNumberIs law n → WitnessNumberIs (reindex f law) n)
  × (WitnessNumberIs (reindex f law) n → WitnessNumberIs law n)
price-is-zero f surj law n =
  witness-invariant f surj law n , witness-invariant' f surj law n

------------------------------------------------------------------------
-- 4.  The number is realised: the three-standpoint system is exactly 3
--
-- `WitnessNumberIsUnbounded` gave the four facts; here they are
-- assembled into the definition, with the length bookkeeping done.
------------------------------------------------------------------------

three-is-three : WitnessNumberIs law 3
three-is-three = (triple , refl , three-refute) , least
  where
  least : (ys : List Three) → length ys < 3 → ¬ Refutes law ys
  least []                 _  = no-empty-refutes
  least (a ∷ [])           _  = no-single-refutes a
  least (a ∷ b ∷ [])       _  = no-pair-refutes a b
  least (a ∷ b ∷ c ∷ ys)   lt =
    Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred lt))))

------------------------------------------------------------------------
-- 5.  What this closes, and the one thing it does not.
--
-- CLOSED.  The anekānta thread asked what a transport between two nayas
-- costs.  `TransportPrice` proved every additive answer is a difference
-- of a potential; this exhibits a potential and shows its price is
-- identically zero along every surjective reindexing.  Between nayas so
-- related there is nothing to pay, and that is a theorem rather than an
-- observation.
--
-- NOT CLOSED, and it is the interesting residue.  Two decoder systems
-- NOT related by a reindexing can have different witness numbers — 2
-- and 3 both occur — so the potential is not constant, and the price
-- between such systems is not zero.  What is missing is a notion of
-- transport general enough to connect them, at which point the price
-- would become visible.  Named, not estimated: nothing here says such
-- a transport exists, and if it does not, the price question is empty
-- rather than hard.
------------------------------------------------------------------------
