{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चतुरंश-भ्रमण — the quarter turn.
--
-- THE QUESTION THIS ANSWERS.  The corpus's categorified exchange
-- content is of exact order two (abstract 13; abstract 01), while the
-- physical phase demands order four — the quarter-wave plate, whose
-- square is the half-wave.  Put to the verdict organs, the residue
-- { exchange-is-order-two ∥ phase-wants-order-four } ran out with the
-- order-two standpoint carried as the seed of every birth.  This file
-- proves WHY the machine held that seed, and the answer dissolves the
-- tension:
--
--     THE QUARTER-WAVE EXISTS — ON THE PAIR.  IT DESCENDS TO NEITHER
--     SENSE.  EACH SENSE CARRIES EXACTLY ITS SQUARE.
--
-- On the two-quadrature plane Bool × Bool — the very state space of
-- the interdependent pair yugmanetra (fst, snd) checked in the
-- Parasparasraya module — the quarter turn (a, b) ↦ (not b, a) is
-- proved of exact order four: its fourth power is the identity
-- (catur-cakra), its square is not (na-ardha-tulya), and its square is
-- the half-wave, pointwise negation (dvi-caturaṃśa, by refl).  The
-- half-wave DESCENDS along each projection: each quadrature sees it as
-- its own negation, definitionally.  The quarter-wave descends along
-- NEITHER projection: for every candidate function f on one
-- quadrature's values, the descent equation is refuted at two named
-- states (na-avataraṇa-prathama, na-avataraṇa-dvitīya).  So a single
-- observable can carry at most the involution, and the order-four
-- symmetry is a property of interdependence itself — visible only to
-- the joint reading, invisible to every member.
--
-- Read against the corpus: the exchange content available to any ONE
-- standpoint is the single order-two redundancy of abstract 01, and
-- that is a ceiling, not an accident — the extra coherence that
-- braiding or a phase demands is data that lives on the pair.  Read
-- physically, as the reading it is: the two quadratures of a field
-- each see the half-wave flip; only homodyning both sees the quarter
-- turn.  Interference detects jointly what no detector sees alone.
--
-- WHAT IS NOT CLAIMED.  No optics, no Hilbert space, no braid group.
-- The plane is Bool × Bool, the turn is a four-case function, and the
-- physical vocabulary is a reading over refutations that typecheck.
------------------------------------------------------------------------

module CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notnot ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- १ · The quarter turn and the half turn.
------------------------------------------------------------------------

caturaṃśa : Bool × Bool → Bool × Bool
caturaṃśa (a , b) = not b , a

ardha : Bool × Bool → Bool × Bool
ardha (a , b) = not a , not b

-- The square of the quarter is the half — by reduction.
dvi-caturaṃśa : (p : Bool × Bool) → caturaṃśa (caturaṃśa p) ≡ ardha p
dvi-caturaṃśa (a , b) = refl

-- The fourth power is the identity: exact order four, upper bound…
catur-cakra : (p : Bool × Bool) → caturaṃśa (caturaṃśa (caturaṃśa (caturaṃśa p))) ≡ p
catur-cakra (a , b) i = notnot a i , notnot b i

-- …and lower bound: the square is NOT the identity, so the order is
-- four and not two.
na-ardha-tulya : ((p : Bool × Bool) → caturaṃśa (caturaṃśa p) ≡ p) → ⊥
na-ardha-tulya h = true≢false (cong fst (sym (h (true , true))))

------------------------------------------------------------------------
-- २ · The half-wave descends to each sense, definitionally.
------------------------------------------------------------------------

ardha-avataraṇa₁ : (p : Bool × Bool) → fst (ardha p) ≡ not (fst p)
ardha-avataraṇa₁ (a , b) = refl

ardha-avataraṇa₂ : (p : Bool × Bool) → snd (ardha p) ≡ not (snd p)
ardha-avataraṇa₂ (a , b) = refl

------------------------------------------------------------------------
-- ३ · The quarter-wave descends to neither sense.  For EVERY candidate
-- reading f of one quadrature, the descent equation dies at two named
-- states whose other coordinate differs — which is exactly the blind
-- pair discipline: the quarter turn moves each sense by information
-- that sense provably does not carry.
------------------------------------------------------------------------

na-avataraṇa-prathama : (f : Bool → Bool)
                      → ((p : Bool × Bool) → fst (caturaṃśa p) ≡ f (fst p))
                      → ⊥
na-avataraṇa-prathama f h =
  true≢false (h (true , false) ∙ sym (h (true , true)))

na-avataraṇa-dvitīya : (f : Bool → Bool)
                     → ((p : Bool × Bool) → snd (caturaṃśa p) ≡ f (snd p))
                     → ⊥
na-avataraṇa-dvitīya f h =
  true≢false (h (true , true) ∙ sym (h (false , true)))

------------------------------------------------------------------------
-- ४ · The ceiling, stated once: what a single sense carries of the
-- quarter turn is exactly its square.  The involution descends
-- (ardha-avataraṇa), the quarter turn does not (na-avataraṇa), and the
-- gap between order two and order four is therefore a property of the
-- PAIR — the coherence a lone observable cannot hold, and the reason
-- the verdict organs seeded every birth with order two.
------------------------------------------------------------------------
