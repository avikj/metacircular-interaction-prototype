{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡û‡‡‡‡û‡æ ‚î ‡®‡æ‡Æ ‡‡‡∞‡‡µ‡ ‡¶‡‡‡‡Æ‡, ‡ó‡‡®‡æ ‡‡ ‡® ‡‡‡‡Ø‡‡ø ‡
--
-- (the name was assigned already; it is the census that could not see it.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM, TEXT, DATE.
--
-- ‡‡û‡‡‡‡û‡æ is Pini's device of technical designation: a stra assigns a
-- name to a class of forms, and every later stra then operates by that
-- name and never re-describes the class.  ‡‡‡‡ü‡æ‡ß‡‡Ø‡æ‡Ø‡ ‡ß.‡ß.‡ß ‡µ‡‡¶‡‡ß‡ø‡∞‡æ‡¶‡à‡‡
-- (‡‡‡ and ‡ê‡‡ receive the ‡‡û‡‡‡‡û‡æ *vddhi*) and ‡ß.‡.‡ß‡ ‡‡‡‡‡‡ø‡ô‡®‡‡‡ ‡‡¶‡Æ‡
-- (what ends in ‡‡‡‡ or ‡‡ø‡ô‡ receives the ‡‡û‡‡‡‡û‡æ *pada*), c. 500 BCE.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS HERE, AND WHAT IS DELIBERATELY NOT.
--
-- `scripts/Abhijnana_‚¶sh --check` was completed on 2026-08-22: it now
-- emits a probe per lead and lets the kernel answer.  Of 17 STRONG leads
-- it turned 5 green.  **Four of those five are already published and are
-- NOT restated here** ‚î `matraOf`/`Metre` and `varna`/`Vak` in
-- `Chandomudra_‚¶`, `chargeOneProjector`/`chargeOneFiber` and
-- `value`/`Fib` in `Tantusandhi_‚¶`, which landed while this was being
-- checked.  Restating them would inflate a count, which is the one thing
-- a recognition pass must not do.  ¬ß‡ß is the fifth.
--
-- ¬ß‡® is the more useful half and it comes out of the DEATHS.  Nine of
-- the fourteen probed leads failed, and **five of the nine failed the
-- same way**: the written type is not `fiber f b` but
--
--     Œ[ n ‚àà ‚ï ] ((n ‚àà domain) ó (q n ‚â° v)),
--
-- the fibre of `q` RESTRICTED to a domain predicate.  The census has no
-- vocabulary for that at all, so it prices those edges at nothing.  ¬ß‡®
-- gives it one: such a type is the honest fibre of the restricted map,
-- and the passage between them is Œ-associativity ‚î an equivalence, not
-- a `refl`, and the gap is exactly the restriction.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE CENSUS THAT PRODUCED THIS, REPORTED WHOLE.
--
--   undecided one-way edges                     1056
--   fibre rows usable after detection             244   (of Upalabdhi's 475)
--   STRONG leads (source type AND map name)        17
--   WEAK   leads (source type only)              9209   ‚ê never probed
--   probed 17 ¬ GREEN 5 ¬ DEATH 9 ¬ SKIP 3
--
-- **A source-and-map match is a LEAD, not a hit: 9 of 14 died.**  The
-- deaths sort into four kinds and none of them is noise:
--
--   (i)   fibre of a RESTRICTED map ‚î five of the nine, and ¬ß‡® below;
--   (ii)  the same short name in two modules ‚î `Digits.value`
--         joined `CarryFiber.Fib` because both end in `value`;
--         different maps out of different `Word`s;
--   (iii) the queued map is a FACTOR, not the map ‚î `EvenQuery` is the
--         fibre of `sgn ‚àò Œ©` and the join saw only `Œ©` (Tantusandhi ¬ß‡©
--         names the composite);
--   (iv)  a bound variable read as a map name ‚î `Div Œ = Œ[ Œ∫ ‚àà ‚ï ] Œ[ d ‚àà ‚ï ]
--         (Œ∫ + d ‚â° Œ)` BINDS `Œ∫`, and `ChargePolynomialFinite.Œ∫ : ‚ï ‚í ‚`
--         is a different thing spelled the same.
--
-- Three leads were SKIPPED, not refuted: `PingalaPrastara.Chosen`,
-- `TypedUnfold.Lang` and `Gurutama.‡Æ` are JOINT fibres of
-- two or more observables, and a pair of equations is not an equation of
-- pairs until `ŒPath‚âPathŒ` says so ‚î ‡‡®‡‡¶‡ã‡Æ‡‡¶‡‡∞‡æ ¬ß‡© performs exactly that
-- passage for `Chosen`; the other two are open.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module Samjna_TheSemanticFibreCarriedItsNameAndTheFiveThatDidNotAreFibresOfARestriction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber ; invEquiv)
open import Cubical.Data.Bool using (Bool ; false)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma

open import DependentOptimizationFibration
  using (semantics ; SemanticFiber ; left-point ; right-point)
open import SieveFiber
  using (Vis ; q ; domain ; _‚àà_ ; Fibre)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡∞‡‡‡‡®‡‡‡‡ ‚î the semantic fibre IS the fibre of the semantics map.
--
-- queue edge:  Configuration ‚ü Bool
--              ¬ DependentOptimizationFibration.semantics
-- written at:  DependentOptimizationFibration.agda:36‚ì38, as
--              `SemanticFiber output = Œ[ configuration ‚àà Configuration ]
--               semantics configuration ‚â° output`.
--
-- The definition spans two lines, which is why the one-line grep the
-- recognition pass shipped with could not see it and the seven-shape
-- detector could.
------------------------------------------------------------------------

‡§Ö‡§∞‡•ç‡§•-‡§§‡§®‡•ç‡§§‡•Å‡§É : (b : Bool) ‚Üí fiber semantics b ‚â° SemanticFiber b
‡§Ö‡§∞‡•ç‡§•-‡§§‡§®‡•ç‡§§‡•Å‡§É b = refl

-- What the recognition buys, and it costs no transport: the host's two
-- named points of `SemanticFiber false` ARE two points of the fibre of
-- `semantics` over `false`.  The edge is therefore not merely undecided
-- but demonstrably non-injective over that value.
‡§Ö‡§∞‡•ç‡§•-‡§§‡§®‡•ç‡§§‡•ã‡§É-‡§¨‡§ø‡§®‡•ç‡§¶‡•Ç : fiber semantics false √ó fiber semantics false
‡§Ö‡§∞‡•ç‡§•-‡§§‡§®‡•ç‡§§‡•ã‡§É-‡§¨‡§ø‡§®‡•ç‡§¶‡•Ç = left-point , right-point

------------------------------------------------------------------------
-- ‡® ¬ ‡‡æ‡µ‡‡‡‡‡¶‡‡®‡‡‡‡ ‚î the fibre of a map cut down to a domain.
--
-- `SieveFiber` writes, at line 465,
--
--     Fibre v = Œ[ n ‚àà ‚ï ] ((n ‚àà domain) ó (q n ‚â° v))
--
-- and the probe `fiber q v ‚â° Fibre v` DIES: the membership conjunct is
-- not in `fiber q v` and no amount of unfolding will put it there.  The
-- kernel is right and the lead was wrong, but the death is informative,
-- because the written type is a fibre ‚î of a different map.  Cut `q`
-- down to the subtype the domain predicate carves out, and `Fibre` is
-- that map's fibre, up to Œ-associativity.
--
-- The same shape kills `SieveScaleTower.Fibre‚ ‚ ‚` and
-- `ChargeGradedPeeling.G`; those five deaths are one phenomenon.
--
------------------------------------------------------------------------

‡§Ö‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®‡§Æ‡•ç : Type
‡§Ö‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®‡§Æ‡•ç = Œ£[ n ‚àà ‚Ñï ] (n ‚àà domain)

-- projections, not a pattern match: `‡‡æ‡µ‡‡‡‡ø‡®‡‡®-q x` must reduce for a
-- VARIABLE `x`, or `fiber ‡‡æ‡µ‡‡‡‡ø‡®‡‡®-q v` does not unfold to the Œ below.
‡§∏‡§æ‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®-q : ‡§Ö‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®‡§Æ‡•ç ‚Üí Vis
‡§∏‡§æ‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®-q x = q (fst x)

‡§∏‡§æ‡§µ‡§ö‡•ç‡§õ‡•á‡§¶-‡§§‡§®‡•ç‡§§‡•Å‡§É : (v : Vis) ‚Üí Fibre v ‚âÉ fiber ‡§∏‡§æ‡§µ‡§ö‡•ç‡§õ‡§ø‡§®‡•ç‡§®-q v
‡§∏‡§æ‡§µ‡§ö‡•ç‡§õ‡•á‡§¶-‡§§‡§®‡•ç‡§§‡•Å‡§É v = invEquiv Œ£-assoc-‚âÉ

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡ ‚î what this leaves.
--
-- The recognition pass is now closed as an instrument: it emits probes
-- and the kernel answers them, so a lead can no longer be reported as a
-- hit by an instrument that never asked.  Its measured false-positive
-- rate on the leads it can probe is 9 of 14, and that number is the one
-- that decides whether it should be run across all 249 source types with
-- its 9209 weak leads.  On this evidence: run it, but only after the
-- weak key is sharpened, because a 64% death rate on the STRONG key is
-- the optimistic figure.
--
-- Open, in order of how much is already written: (a) the two joint
-- fibres skipped above; (b) the four other restricted fibres, which ¬ß‡®'s
-- statement covers verbatim and which are four more modules' worth of
-- imports; (c) death kind (iv), which is a defect of the extractor and
-- not of the corpus ‚î a Œ binder must never be offered as a map name.
------------------------------------------------------------------------
