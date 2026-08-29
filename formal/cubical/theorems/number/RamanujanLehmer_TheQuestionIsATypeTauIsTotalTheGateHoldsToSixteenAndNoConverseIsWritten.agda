{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्–लेह्मर् — THE QUESTION IS A TYPE, τ IS TOTAL, THE GATE
-- HOLDS TO SIXTEEN, AND NO CONVERSE IS WRITTEN.
--
-- Lehmer's question (1947), still open: is τ(n) ever zero?  Nobody
-- knows; the vanishing has been excluded to astronomical bounds by
-- other instruments.  This file gives the question the corpus's
-- two-layer treatment:
--
--   τ IS TOTAL HERE.  τAt n reads the n-th coefficient of the Δ
--   product truncated at degree n+1 — a complete definition for
--   EVERY n, no infinite object pretended, each value the finite
--   computation Ramanujan performed.  Coefficients ride as formal
--   differences (a , b) standing for a − b; τ(n) = 0 is exactly the
--   balance fst ≡ snd of the computed pair.
--
--   `LehmerQuestion` — the universal statement as a type: for every
--   positive n the pair never balances.  Open; a type, not a claim.
--
--   `lehmer-gate` — the kernel's signature on the window 1..16: no
--   balance, by one scan and its soundness.  The window includes the
--   first sign changes and the collisions of magnitude that make
--   the question interesting at small n.
--
--   `restrict : LehmerQuestion → gate` — one direction, by
--   specialization.  No term runs backwards; sixteen instances
--   license nothing universal, and the type system now says so.
--
-- The machine's kosha holds the Lehmer naya; this file upgrades its
-- witness from the fixed-degree table to the total definition with
-- the gate signed by the kernel.
------------------------------------------------------------------------

module RamanujanLehmer_TheQuestionIsATypeTauIsTotalTheGateHoldsToSixteenAndNoConverseIsWritten where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; suc-≤-suc ; zero-≤)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; eq?-complete ; loop ; loop-sound)
open import Ramanujan691_TheTauCongruenceInstancesWithTauDefinedByTheDeltaProductItself
  using (D ; dadd ; dmul ; toℤ ; d0 ; d1 ; dm1)

------------------------------------------------------------------------
-- §1  The Δ product at every truncation: τ total.
------------------------------------------------------------------------

Poly : Type
Poly = List D

takeN : ℕ → Poly → Poly
takeN zero    _        = []
takeN (suc n) []       = []
takeN (suc n) (x ∷ xs) = x ∷ takeN n xs

paddN : Poly → Poly → Poly
paddN []       ys       = ys
paddN xs       []       = xs
paddN (x ∷ xs) (y ∷ ys) = dadd x y ∷ paddN xs ys

pscaleN : D → Poly → Poly
pscaleN a []       = []
pscaleN a (x ∷ xs) = dmul a x ∷ pscaleN a xs

pmulN : ℕ → Poly → Poly → Poly
pmulN N []       ys = []
pmulN N (x ∷ xs) ys = takeN N (paddN (pscaleN x ys) (d0 ∷ pmulN N xs ys))

one-minus-q^N : ℕ → Poly
one-minus-q^N n = d1 ∷ mk n
  where
  mk : ℕ → Poly
  mk zero          = []
  mk (suc zero)    = dm1 ∷ []
  mk (suc (suc m)) = d0 ∷ mk (suc m)

pow24N : ℕ → Poly → Poly
pow24N N b = go 24 (d1 ∷ [])
  where
  go : ℕ → Poly → Poly
  go zero    acc = acc
  go (suc k) acc = go k (pmulN N b acc)

etaProdN : ℕ → ℕ → Poly
etaProdN N zero    = d1 ∷ []
etaProdN N (suc n) = pmulN N (pow24N N (one-minus-q^N (suc n))) (etaProdN N n)

coeffN : ℕ → Poly → D
coeffN _       []       = d0
coeffN zero    (x ∷ _)  = x
coeffN (suc n) (_ ∷ xs) = coeffN n xs

-- τ at n, from the product truncated exactly where n lives: total.
τAt : ℕ → D
τAt n = coeffN n (d0 ∷ etaProdN n n)

-- Sanity against the fixed-degree table: the total definition meets
-- the 691 file's values.
τAt-2 : toℤ (τAt 2) ≡ negsuc 23
τAt-2 = refl

τAt-8 : toℤ (τAt 8) ≡ pos 84480
τAt-8 = refl

------------------------------------------------------------------------
-- §2  The question, as a type.
------------------------------------------------------------------------

-- τ(n) = 0 is exactly the balance of the computed difference pair.
Balances : ℕ → Type
Balances n = fst (τAt n) ≡ snd (τAt n)

-- LEHMER'S QUESTION, 1947, open: a type, not a claim.
LehmerQuestion : Type
LehmerQuestion = (n : ℕ) → 1 ≤ n → ¬ Balances n

------------------------------------------------------------------------
-- §3  The gate: no balance on 1..16, signed by the kernel.
------------------------------------------------------------------------

leafL : ℕ → Maybe Unit
leafL m =
  rec (just tt) (λ _ → nothing)
      (eq? (fst (τAt (suc m))) (snd (τAt (suc m))))

scanL : Maybe Unit
scanL = loop leafL 15

scanL-ok : scanL ≡ just tt
scanL-ok = refl

leafL-sound : (m : ℕ) → leafL m ≡ just tt → ¬ Balances (suc m)
leafL-sound m h = g (eq? (fst (τAt (suc m))) (snd (τAt (suc m)))) refl
  where
  g : (w : Maybe (Balances (suc m))) →
      eq? (fst (τAt (suc m))) (snd (τAt (suc m))) ≡ w → ¬ Balances (suc m)
  g (just p) pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec (just tt) (λ _ → nothing)) pw) ∙ h))
  g nothing  pw = eq?-complete _ _ pw

GateSixteen : Type
GateSixteen = (m : ℕ) → m ≤ 15 → ¬ Balances (suc m)

lehmer-gate : GateSixteen
lehmer-gate m hm = leafL-sound m (loop-sound leafL 15 scanL-ok m hm)

------------------------------------------------------------------------
-- §4  The restriction.  One direction; the converse is the error.
------------------------------------------------------------------------

restrict : LehmerQuestion → GateSixteen
restrict lq m hm = lq (suc m) (suc-≤-suc zero-≤)
