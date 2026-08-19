{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- `notes/` grepped.  **No tradition term is claimed and none is
-- invented.**  The abstract order-theoretic form used here — two
-- preorders, two antitone maps, one adjunction — is Ore's ("Galois
-- connexions", *Trans. AMS* 55, 1944), after Birkhoff (*Lattice
-- Theory*, 1940, §V); the module being audited already cites both.  I
-- have not established an Indian source for it and will not attach a
-- label I cannot defend.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT, AND WHAT IT FOUND AND DID NOT FIND.
--
-- Target: `TheSaturationClosureNeedsOnlyAGaloisConnection`, whose title
-- is a MINIMALITY claim and whose §1 is headed "The only assumptions:
-- two preorders and one adjunction".
--
-- **THE TITLE IS EARNED IN THE DIRECTION IT ASSERTS.**  All six of
-- `module Galois`'s hypotheses are consumed: `≼-refl` in `counit`,
-- `≼-trans` in `u-antitone` and `saturatedGivesFixed`, `⊑-refl` in
-- `unit` and `fixedGivesSaturated`, `⊑-trans` in `d-antitone`, and both
-- adjunction directions throughout.  Nothing is assumed and unused.
-- That is worth recording because the sweep's other findings have all
-- been overclaims; this one is not.
--
-- **WHAT IT DOES NOT SHOW IS THAT ITS PACKAGE IS THE ONLY SUFFICIENT
-- ONE**, and "needs only X" invites exactly that reading.  A reader who
-- already has antitone maps with a unit and a counit — the other
-- standard presentation, and the one a construction usually hands you
-- first — has no statement to appeal to.  §"WHAT IS STILL NOT CLAIMED"
-- there lists the min-plus instance, antisymmetry and tractability, and
-- does not mention the alternative presentation at all.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   FromUnitCounit    from `u-antitone`, `d-antitone`, `unit`, `counit`
--                     over two preorders: `galFwd` and `galBwd`, one
--                     line each, and then the ENTIRE closure theory by
--                     `open Galois … public` — antitonicity, unit,
--                     counit, triangles, `c`, idempotence, the
--                     fixed-point characterisation, nothing re-proved
--   RoundTrip         going out and back is the identity when the order
--                     relations are PROPOSITION-VALUED, by `funExt`
--
-- **AND THE TWO PACKAGES DO NOT NEED THE SAME AXIOMS.  THAT IS THE
-- FINDING.**  `galFwd`/`galBwd` are derived from unit/counit using ONLY
-- the two TRANSITIVITIES; the two reflexivities are never touched.
-- Going the other way, reflexivity is exactly what is needed —
-- `unit a = galBwd a (u a) (⊑-refl (u a))` and `counit b = galFwd (d b)
-- b (≼-refl (d b))`.  So the adjunction presentation needs refl to
-- produce unit/counit, and the unit/counit presentation needs neither
-- refl to produce the adjunction.  **The packages are interderivable
-- over a preorder and are NOT interderivable over a bare transitive
-- relation: one direction survives there and the other does not.**
-- `FromUnitCounit` still takes both reflexivities, because `Galois`
-- does and the point is to reuse it verbatim; the claim above is about
-- what its own two definitions consume, which is visible in their
-- bodies.
--
-- WHAT IS NOT CLAIMED.  Not that this is a NEW presentation — both are
-- standard and Ore has them.  Not that the min-plus instance is any
-- closer: the obligation named there is untouched here.  The round trip
-- is an EQUALITY only under the propositional-order hypothesis, which
-- is a real hypothesis and is not free; without it the two `galFwd`s
-- are both correct and need not be equal, and no claim is made that
-- they differ either.  No antisymmetry anywhere, so nothing is a
-- partial order and no fixed point is unique up to a path.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms where

open import Cubical.Foundations.Prelude

open import NaturalMachine.TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)

------------------------------------------------------------------------
-- 1.  The other presentation, and the whole closure theory from it
------------------------------------------------------------------------

module FromUnitCounit
  {ℓP ℓQ ℓ≼ ℓ⊑ : Level}
  {P : Type ℓP} {Q : Type ℓQ}
  (_≼_ : P → P → Type ℓ≼)
  (_⊑_ : Q → Q → Type ℓ⊑)
  (≼-refl  : (a : P) → a ≼ a)
  (≼-trans : (a b c : P) → a ≼ b → b ≼ c → a ≼ c)
  (⊑-refl  : (b : Q) → b ⊑ b)
  (⊑-trans : (a b c : Q) → a ⊑ b → b ⊑ c → a ⊑ c)
  (u : P → Q) (d : Q → P)
  (u-antitone : (a a' : P) → a ≼ a' → u a' ⊑ u a)
  (d-antitone : (b b' : Q) → b ⊑ b' → d b' ≼ d b)
  (unit   : (a : P) → a ≼ d (u a))
  (counit : (b : Q) → b ⊑ u (d b))
  where

  -- Only the TRANSITIVITIES are used here.  Neither reflexivity appears.
  galFwd : (a : P) (b : Q) → a ≼ d b → b ⊑ u a
  galFwd a b le = ⊑-trans b (u (d b)) (u a) (counit b) (u-antitone a (d b) le)

  galBwd : (a : P) (b : Q) → b ⊑ u a → a ≼ d b
  galBwd a b le = ≼-trans a (d (u a)) (d b) (unit a) (d-antitone b (u a) le)

  open Galois _≼_ _⊑_ ≼-refl ≼-trans ⊑-refl ⊑-trans u d galFwd galBwd
    public

------------------------------------------------------------------------
-- 2.  And the round trip is the identity on proposition-valued orders
------------------------------------------------------------------------

module RoundTrip
  {ℓP ℓQ ℓ≼ ℓ⊑ : Level}
  {P : Type ℓP} {Q : Type ℓQ}
  (_≼_ : P → P → Type ℓ≼)
  (_⊑_ : Q → Q → Type ℓ⊑)
  (≼-refl  : (a : P) → a ≼ a)
  (≼-trans : (a b c : P) → a ≼ b → b ≼ c → a ≼ c)
  (⊑-refl  : (b : Q) → b ⊑ b)
  (⊑-trans : (a b c : Q) → a ⊑ b → b ⊑ c → a ⊑ c)
  (u : P → Q) (d : Q → P)
  (galFwd : (a : P) (b : Q) → a ≼ d b → b ⊑ u a)
  (galBwd : (a : P) (b : Q) → b ⊑ u a → a ≼ d b)
  (prop≼ : (a : P) (b : Q) → isProp (a ≼ d b))
  (prop⊑ : (a : P) (b : Q) → isProp (b ⊑ u a))
  where

  open Galois _≼_ _⊑_ ≼-refl ≼-trans ⊑-refl ⊑-trans u d galFwd galBwd
    using (unit ; counit ; u-antitone ; d-antitone)

  open FromUnitCounit _≼_ _⊑_ ≼-refl ≼-trans ⊑-refl ⊑-trans u d
         u-antitone d-antitone unit counit
    using () renaming (galFwd to galFwd′ ; galBwd to galBwd′)

  fwdRoundTrip : (a : P) (b : Q) → galFwd′ a b ≡ galFwd a b
  fwdRoundTrip a b = funExt (λ le → prop⊑ a b (galFwd′ a b le) (galFwd a b le))

  bwdRoundTrip : (a : P) (b : Q) → galBwd′ a b ≡ galBwd a b
  bwdRoundTrip a b = funExt (λ le → prop≼ a b (galBwd′ a b le) (galBwd a b le))
