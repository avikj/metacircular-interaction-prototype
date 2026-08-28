{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt).  A benefit
-- coordinate and a cost coordinate are that same magnitude under the
-- two readings, and this line is about what it costs to turn one into
-- the other.  The sign rules are his; the cap, the adjunction, and the
-- per-coordinate refinement below are not, and no claim is made that
-- they are.
--
-- ────────────────────────────────────────────────────────────────────
-- `RnaDhana_TheCostFlipIsFaithfulBelowTheCap` closed the restricted
-- converse and ended with:
--
--   "The cap is still a single number shared by all cost coordinates;
--    per-coordinate caps are not modelled, though the one-sided
--    hypothesis suggests they would be the honest version."
--
-- They are modelled here.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Caps ds            a cap PER COST COORDINATE, as a recursive family
--                      over the direction list — benefit coordinates
--                      carry no cap at all, which the single-number
--                      version could not express
--   flipWithCaps       the flip against those caps
--   BoundedC           each cost entry is below ITS OWN cap
--   flipCapsIsSound    mixed dominance still implies product dominance
--                      of the flipped vectors — the bound plays no part
--   flipCapsReflect    and below the caps the converse holds, with the
--                      bound needed only on the DOMINATING vector, as
--                      before
--   flipCapsFaithful   so the two orders agree there
--   constCaps          the constant cap assignment
--   oneCapIsTheSpecialCase
--                      `flipWithCaps ds (constCaps cap ds) v ≡
--                       flipWith cap ds v`, pointwise on the nose — so
--                      the earlier theorem is this one at a constant
--                      family and nothing was lost by proving it first
--
-- **WHY THIS IS THE HONEST VERSION, IN ONE SENTENCE.**  A single cap
-- forces one number above every cost in every coordinate, so a
-- dollar-cost coordinate and a wall-time coordinate must share a
-- ceiling and are silently made commensurable; per-coordinate caps
-- require only that each coordinate be capped in its own units, which
-- is what a modelling obligation about incomparable objectives should
-- say.  The benefit coordinates carrying NO cap is the same point from
-- the other side: the single-number version had to pretend they were
-- capped too.
--
-- NO NOVELTY.  Nothing here is more than the earlier module coordinate
-- by coordinate; the only content is that the generalisation costs
-- nothing and strictly weakens the hypothesis.
--
-- SYĀT — THE CLAIM, EXACTLY.  Still nothing about how a cap should be chosen.
-- The Pareto and certificate lines still state their theorems with the
-- BENEFIT reading and inherit the obligation to flip; this module makes
-- the obligation cheaper to discharge and does not discharge it for
-- them.  `Caps` is indexed by the direction list, so a vector and its
-- caps cannot be mismatched — but nothing checks that the caps chosen
-- are above the costs that will actually be compared; that is
-- `BoundedC`'s job and it is a hypothesis, not a construction.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _∸_)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)

open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom ; flipWith ; ∸-antitone)
open import RnaDhana_TheCostFlipIsFaithfulBelowTheCap
  using (capReflects)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_≼_)

------------------------------------------------------------------------
-- 1.  One cap per cost coordinate, none per benefit coordinate
------------------------------------------------------------------------

Caps : List Bool → Type
Caps []           = Unit
Caps (true  ∷ ds) = Caps ds
Caps (false ∷ ds) = ℕ × Caps ds

flipWithCaps : (ds : List Bool) → Caps ds → Vec ds → List ℕ
flipWithCaps []           _        _        = []
flipWithCaps (true  ∷ ds) cs       (x , xs) = x ∷ flipWithCaps ds cs xs
flipWithCaps (false ∷ ds) (c , cs) (x , xs) = (c ∸ x) ∷ flipWithCaps ds cs xs

BoundedC : (ds : List Bool) → Caps ds → Vec ds → Type
BoundedC []           _        _        = Unit
BoundedC (true  ∷ ds) cs       (x , xs) = BoundedC ds cs xs
BoundedC (false ∷ ds) (c , cs) (x , xs) = (x ≤ c) × BoundedC ds cs xs

------------------------------------------------------------------------
-- 2.  Sound without any bound, faithful below the caps
------------------------------------------------------------------------

flipCapsIsSound :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  → Dom ds v w → flipWithCaps ds cs v ≼ flipWithCaps ds cs w
flipCapsIsSound []           _        _        _        _           = tt
flipCapsIsSound (true  ∷ ds) cs       (x , xs) (y , ys) (le , rest) =
  le , flipCapsIsSound ds cs xs ys rest
flipCapsIsSound (false ∷ ds) (c , cs) (x , xs) (y , ys) (ge , rest) =
  ∸-antitone c y x ge , flipCapsIsSound ds cs xs ys rest

flipCapsReflect :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  → BoundedC ds cs w
  → flipWithCaps ds cs v ≼ flipWithCaps ds cs w → Dom ds v w
flipCapsReflect []           _        _        _        _         _          = tt
flipCapsReflect (true  ∷ ds) cs       (x , xs) (y , ys) b         (le , r)   =
  le , flipCapsReflect ds cs xs ys b r
flipCapsReflect (false ∷ ds) (c , cs) (x , xs) (y , ys) (yb , b)  (le , r)   =
  capReflects c x y yb le , flipCapsReflect ds cs xs ys b r

flipCapsFaithful :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  → BoundedC ds cs w
  → (Dom ds v w → flipWithCaps ds cs v ≼ flipWithCaps ds cs w)
  × (flipWithCaps ds cs v ≼ flipWithCaps ds cs w → Dom ds v w)
flipCapsFaithful ds cs v w b =
  flipCapsIsSound ds cs v w , flipCapsReflect ds cs v w b

------------------------------------------------------------------------
-- 3.  The single cap is the constant assignment
------------------------------------------------------------------------

constCaps : ℕ → (ds : List Bool) → Caps ds
constCaps cap []           = tt
constCaps cap (true  ∷ ds) = constCaps cap ds
constCaps cap (false ∷ ds) = cap , constCaps cap ds

oneCapIsTheSpecialCase :
  (cap : ℕ) (ds : List Bool) (v : Vec ds)
  → flipWithCaps ds (constCaps cap ds) v ≡ flipWith cap ds v
oneCapIsTheSpecialCase cap []           _        = refl
oneCapIsTheSpecialCase cap (true  ∷ ds) (x , xs) =
  cong (x ∷_) (oneCapIsTheSpecialCase cap ds xs)
oneCapIsTheSpecialCase cap (false ∷ ds) (x , xs) =
  cong ((cap ∸ x) ∷_) (oneCapIsTheSpecialCase cap ds xs)
