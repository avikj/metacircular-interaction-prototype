{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡æ‡∞‡‡ó ‡® ‚î the first tolled crossing of a one-way edge.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  The corpus's road network has, until now, carried
-- theorems only along two-way edges: equivalences, isomorphisms, and the
-- grade-three "two independent proofs that agree" channel of
-- `YugmaPurana_‚¶agda` ¬ß‡.  This module executes, by hand, the ROUTER'S
-- TOLL PROTOCOL for a genuinely ONE-WAY edge ‚î a lossy map, along which
-- nothing travels for free ‚î and carries one theorem across it.  The
-- protocol, in the order it is executed below:
--
--   ¬ß‡ß  THE EDGE.     `par : Valli ‚í Bool`, the length-parity of the
--       vall.  One-way and irreversibly so: infinitely many valls per
--       parity bit, no section chosen, none needed.
--
--   ¬ß‡®  THE TOLL.     A theorem crosses a lossy edge only on presenting
--       a descent witness: `FiberConstant par t` ‚î the toll-gate
--       predicate of `NaturalMachine.FiniteInformation`, IMPORTED, not
--       restated.  The traveller is  t = det ‚àò replay,  and the toll is
--       paid at `‡‡‡≤‡‡ï‡Æ‡` from `KuttakaValli.detReplay` plus one
--       induction (`sgnPar`) showing the sign is a function of the
--       parity bit alone.
--
--   ¬ß‡©  THE RECEIPT.  What the edge retains is priced: the fibre
--       quotient is EXACTLY ‚/2, by `YugmaPurana_TheValliRecoversIts-
--       LengthModuloTwoAndNoFurther.agda` ‚î its ‡‡ø‡‡‡®‡-‡¶‡à‡∞‡‡ò‡‡Ø‡æ‡‡ is the
--       coarse form (length determines sign) which the toll here refines
--       (parity already determines it, `‡‡‡≤‡‡ï‡Æ‡-‡‡ø‡‡‡®‡-‡¶‡à‡∞‡‡ò‡‡Ø‡æ‡‡-‡‡®‡‡‡æ‡∞‡ø`),
--       and its ‡µ‡ø‡‡Æ-‡‡‡∞‡‡Æ‡ is why no coarser edge than parity can carry
--       this traveller (`‡‡‡‡®‡‡Ø-‡‡‡≤‡‡ï‡Æ‡` below: the edge to the point
--       refuses it).
--
--   ¬ß‡  THE CROSSING. The decoder is CONSTRUCTED twice.  Directly:
--       `‡‡µ‡‡∞‡‡Æ‡ = sgnOf : Bool ‚í R` with `‡‡µ‡‡∞‡-‡®‡ø‡Ø‡Æ‡ : sgnOf (par v) ‚â°
--       det (replay v)`.  And through the toll gate itself:
--       `‡â‡‡‡‡‡∞‡‡‡Æ‡ : FactorsThrough par (det ‚àò replay)` via
--       `fiberConstant‚ífactorsThrough` (isSet ‚ paid, choice not), whose
--       computation rule `‡â‡‡‡‡‡∞‡‡-‡ó‡‡®‡æ` on states is REFL ‚î the decoder
--       computes, it is not merely asserted to exist.
--
--   ¬ß‡  THE NEGATIVE CONTROL.  The corpus's discipline: a gate that
--       admits everything certifies nothing.  `length : Valli ‚í ‚ï` is
--       refused at the same gate ‚î `‡®‡ø‡‡‡ß‡` exhibits the two-point
--       witness ([] against a two-step vall, same parity, lengths 0
--       and 2) on which FiberConstant fails, and with it FactorsThrough.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
--   ¬ This is ONE edge, crossed BY HAND.  The mechanized road-two
--     router ‚î the machine that finds the edge, computes the toll, and
--     schedules the crossing ‚î remains owed; this module is its
--     specification-by-example, not its implementation.
--
--   ¬ Nothing here is about the fibre of `replay` itself.  As
--     `YugmaPurana_‚¶agda` ¬ß‡ already insists, `replay` forgets far more
--     than length; the edge crossed is `par`, and the only traveller
--     ticketed is the determinant of the endpoint.
--
--   ¬ The toll-gate predicate is quoted from
--     `NaturalMachine.FiniteInformation` by import.  No definition of
--     FactorsThrough/FiberConstant is restated here; if that module's
--     meaning shifts, this crossing re-prices automatically.
------------------------------------------------------------------------

module Marga2_TheFirstTolledCrossingOfAOneWayEdge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; length)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots)
open import Cubical.Data.Int using (isSet‚Ñ§)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Functions.Image using (restrictToImage)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver using (solve!)

open import Gamma0Partner using (R ; M)
open import M2Unimodular using (det)
open import KuttakaValli using (Valli ; replay ; sgn ; detReplay)
open import YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther
  using (‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç)

-- THE TOLL-GATE PREDICATE, imported from the corpus's own toll office.
open import NaturalMachine.FiniteInformation
  using ( FactorsThrough ; FiberConstant
        ; fiberConstant‚ÜífactorsThrough ; factorsThrough‚ÜífiberConstant )

open CommRingStr (‚Ñ§CommRing .snd)

------------------------------------------------------------------------
-- ¬ß‡ß ¬ THE EDGE ‚î par, the length-parity, and why it is one-way.
--
-- `par` never inspects a quotient; it counts steps mod 2.  It is lossy
-- twice over: it forgets every entry of the vall, and then all of the
-- length except its last bit.  Both fibres are infinite.
------------------------------------------------------------------------

par : Valli ‚Üí Bool
par []      = false
par (q ‚à∑ v) = not (par v)

-- the parity is a function of the length (needed for the receipt in ¬ß‡©)
parOfLen : ‚Ñï ‚Üí Bool
parOfLen zero    = false
parOfLen (suc n) = not (parOfLen n)

par-length : (v : Valli) ‚Üí par v ‚â° parOfLen (length v)
par-length []      = refl
par-length (q ‚à∑ v) = cong not (par-length v)

------------------------------------------------------------------------
-- ¬ß‡® ¬ THE TOLL ‚î the descent witness for det ‚àò replay along par.
--
-- The traveller: t v = det (replay v).  The fare: prove t is constant
-- on the fibres of par.  Paid in two coins ‚î `detReplay` (the endpoint's
-- determinant IS the sign) and `sgnPar` (the sign is a function of the
-- parity bit; one induction, one ring identity per branch).
------------------------------------------------------------------------

-- the sign each parity class carries
sgnOf : Bool ‚Üí R
sgnOf false = 1r
sgnOf true  = - 1r

private
  sgnOf-not : (b : Bool) ‚Üí sgnOf (not b) ‚â° (- 1r) ¬∑ sgnOf b
  -- `solve!` is passed a goal with NO variables here, and the solver
  -- builds its environment as a Vec whose length must match: it reports
  -- `0 != 1 of type ‚ï`, which is a fact about the tactic and not about
  -- the ring.  Over ‚ both sides are closed terms, so they compute, and
  -- `refl` is both shorter and honest about why.
  sgnOf-not false = refl
  sgnOf-not true  = refl

sgnPar : (v : Valli) ‚Üí sgn v ‚â° sgnOf (par v)
sgnPar []      = refl
sgnPar (q ‚à∑ v) = cong ((- 1r) ¬∑_) (sgnPar v) ‚àô sym (sgnOf-not (par v))

-- THE TOLL, presented at the gate: det ‚àò replay is fibre-constant
-- along the parity edge.
‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç : FiberConstant par (Œª v ‚Üí det (replay v))
‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç v w p =
  detReplay v
    ‚àô‚àô (sgnPar v ‚àô‚àô cong sgnOf p ‚àô‚àô sym (sgnPar w))
    ‚àô‚àô sym (detReplay w)

------------------------------------------------------------------------
-- ¬ß‡© ¬ THE RECEIPT ‚î the fibre priced at exactly ‚/2.
--
-- Coarse bound, already on file: ‡‡ø‡‡‡®‡-‡¶‡à‡∞‡‡ò‡‡Ø‡æ‡‡ (YugmaPurana ¬ß‡ß) says
-- the sign is determined by the LENGTH.  The toll refines it: the sign
-- is determined by the length's PARITY, and the refinement recovers the
-- filed statement through par-length ‚î so the receipt is consistent
-- with the ledger it sharpens.  That the price cannot drop below ‚/2 ‚î
-- that no coarser edge carries this traveller ‚î is ¬ß‡'s ‡‡‡‡®‡‡Ø-‡‡‡≤‡‡ï‡Æ‡,
-- YugmaPurana's ‡µ‡ø‡‡Æ-‡‡‡∞‡‡Æ‡ read as a refusal.
------------------------------------------------------------------------

-- the toll implies the filed length-form of the law (‡Ø‡‡-‡‡ø‡‡‡†‡‡ø,
-- re-derived through the tolled edge rather than re-proved)
‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç-‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§®‡•Å‡§∏‡§æ‡§∞‡§ø :
  (v w : Valli) ‚Üí length v ‚â° length w ‚Üí det (replay v) ‚â° det (replay w)
‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç-‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§®‡•Å‡§∏‡§æ‡§∞‡§ø v w p =
  ‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç v w (par-length v ‚àô‚àô cong parOfLen p ‚àô‚àô sym (par-length w))

-- and the two receipts agree where both are issued: the crossing's
-- account of the sign matches YugmaPurana's, on every equal-length pair.
receipts-agree :
  (v w : Valli) (p : length v ‚â° length w)
  ‚Üí ‡§ö‡§ø‡§π‡•ç‡§®‡§Ç-‡§¶‡•à‡§∞‡•ç‡§ò‡•ç‡§Ø‡§æ‡§§‡•ç v w p ‚â° (sgnPar v ‚àô‚àô cong sgnOf (par-length v ‚àô‚àô cong parOfLen p ‚àô‚àô sym (par-length w)) ‚àô‚àô sym (sgnPar w))
receipts-agree v w p = isSet‚Ñ§ (sgn v) (sgn w) _ _

------------------------------------------------------------------------
-- ¬ß‡ ¬ THE CROSSING ‚î the decoder, constructed.
--
-- Twice.  First bare-handed: sgnOf itself is total on Bool, and the
-- decode law is a path computed from the two coins directly.  Then
-- through the imported toll gate, which types the decoder on the IMAGE
-- of the edge and hands back a computation rule that is REFL on states.
------------------------------------------------------------------------

-- (a) the bare decoder: parity bit in, determinant out
‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç : Bool ‚Üí R
‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç = sgnOf

‡§Ö‡§µ‡§§‡§∞‡§£-‡§®‡§ø‡§Ø‡§Æ‡§É : (v : Valli) ‚Üí ‡§Ö‡§µ‡§§‡§∞‡§£‡§Æ‡•ç (par v) ‚â° det (replay v)
‡§Ö‡§µ‡§§‡§∞‡§£-‡§®‡§ø‡§Ø‡§Æ‡§É v = sym (detReplay v ‚àô sgnPar v)

-- (b) the certified crossing: the FactorsThrough witness, minted by the
-- toll office from the toll.  Fee: isSet ‚.  Not charged: choice.
‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£‡§Æ‡•ç : FactorsThrough par (Œª v ‚Üí det (replay v))
‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£‡§Æ‡•ç = fiberConstant‚ÜífactorsThrough isSet‚Ñ§ par (Œª v ‚Üí det (replay v)) ‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç

-- its computation rule on states is definitional ‚î the crossing
-- COMPUTES; this line is `refl`, not a lemma.
‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£-‡§ó‡§£‡§®‡§æ :
  (v : Valli) ‚Üí fst ‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£‡§Æ‡•ç (restrictToImage par v) ‚â° det (replay v)
‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£-‡§ó‡§£‡§®‡§æ v = refl

------------------------------------------------------------------------
-- ¬ß‡ ¬ THE NEGATIVE CONTROL ‚î a traveller refused, as it must be.
--
-- `length` itself walks up to the same gate and is turned away: [] and
-- a two-step vall sit in ONE fibre of par (both even) with lengths 0
-- and 2.  FiberConstant fails on that two-point witness, so
-- FactorsThrough fails with it ‚î the gate is a gate, not a doorway.
------------------------------------------------------------------------

‡§®‡§ø‡§∑‡•á‡§ß‡§É : ¬¨ FiberConstant par length
‡§®‡§ø‡§∑‡•á‡§ß‡§É fc = znots (fc [] (0r ‚à∑ 0r ‚à∑ []) refl)

‡§®‡§ø‡§∑‡•á‡§ß‡§É-‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£‡•á : ¬¨ FactorsThrough par length
‡§®‡§ø‡§∑‡•á‡§ß‡§É-‡§â‡§§‡•ç‡§§‡•Ä‡§∞‡•ç‡§£‡•á ft = ‡§®‡§ø‡§∑‡•á‡§ß‡§É (factorsThrough‚ÜífiberConstant par length ft)

-- and the dual control, pricing the toll from below: the EDGE TO THE
-- POINT (forget even the parity) refuses det ‚àò replay ‚î [] and a
-- one-step vall land on determinants 1 and ‚àí1.  So the parity bit is
-- not decorative: coarsen the edge once more and the crossing dies.
-- This is ‡µ‡ø‡‡Æ-‡‡‡∞‡‡Æ‡ read as a refusal at a gate.
‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç : ¬¨ FiberConstant (Œª (_ : Valli) ‚Üí tt) (Œª v ‚Üí det (replay v))
‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§∂‡•Å‡§≤‡•ç‡§ï‡§Æ‡•ç fc = one‚â¢-one (fc [] (0r ‚à∑ []) refl ‚àô detReplay (0r ‚à∑ []) ‚àô eq)
  where
  open import Cubical.Data.Int using (pos ; negsuc ; posNotnegsuc)
  eq : (- 1r) ¬∑ 1r ‚â° - 1r
  eq = solve! ‚Ñ§CommRing
  one‚â¢-one : ¬¨ (Path R 1r (- 1r))
  one‚â¢-one = posNotnegsuc 1 0
