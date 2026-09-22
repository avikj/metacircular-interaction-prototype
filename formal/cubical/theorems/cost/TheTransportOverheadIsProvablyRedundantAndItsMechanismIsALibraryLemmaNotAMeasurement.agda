{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTransportOverheadIsProvablyRedundantAndItsMechanismIsALibraryLemmaNotAMeasurement
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Univalence, `ua` and transport are Voevodsky's and the cubical
-- library's ‚î the substrate this repository is checked in, which
-- `CLAUDE.md` explicitly exempts from the framing rule ("tools are not
-- frames").  There is no Indian source for this statement and inventing
-- a  label would assert a provenance nobody checked.  Checked
-- before naming: `.claude/hooks/priority-ledger.txt` (CURRENT header)
-- grepped first.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT.  `TransportCost` says:
--
--   "two separate questions remain, and **both are decided by execution
--    rather than by proof** ‚¶ (2) NO.  Native is flat in the number of
--    chained operations; the transported term is quadratic, **because
--    transport across `ua e` *is* `e‚ª¬ ‚àò f ‚àò (e ó e)`** ‚î a full round
--    trip through ‚ï per operation, and `valueC`/`digitsC` are unary."
--
-- **The sentence after "because" is not an explanation of a
-- measurement.  It is `Cubical.Foundations.Univalence.transportUAop‚`,
-- a library lemma, verbatim:**
--
--   transportUAop‚ : (e : A ‚â B) (f : A ‚í A ‚í A) (x y : B)
--     ‚í transport (Œª i ‚í ua e i ‚í ua e i ‚í ua e i) f x y
--       ‚â° equivFun e (f (invEq e x) (invEq e y))
--
-- So the mechanism was never measured; it was already proved, upstream,
-- and the module cites it while calling the result execution-decided.
-- `CLAUDE.md`'s rule applies exactly: *"No claim of the form 'measured
-- slope ‚âà x' survives if the slope is derivable."*  ¬ß2 below derives the
-- structure the slope comes from.
--
-- **AND THE BUILD STATUS MATTERS, so it is stated with its command.**
-- On the CONTAINER, `TransportCost.agda` does not typecheck at all:
--
--   cd formal/cubical && agda -i . NaturalMachine/TransportCost.agda
--   ‚í TRANSPORTCOST_EXIT=42
--
-- because it opens `NaturalMachine`, hence `Transport`,
-- whose first error is `Transport.agda:46,50-65` ‚î the same upstream
-- `solve‚ï!` import that fails the two aggregate gates.  So **its
-- `refl`s cannot be re-verified here**, and its answer to question (1)
-- ("YES.  Every `refl` below forces evaluation and typechecks") is not
-- currently checkable on this toolchain.  That is a fact about the
-- container, NOT a doubt about the claim, and NOT that module's fault.
-- **This module therefore depends on none of it** ‚î nothing below
-- imports `NaturalMachine`, and everything below is checked.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED, for an ARBITRARY equivalence and binary operation
--
--   T                   the transported operation
--   step                = `transportUAop‚`, named here so the mechanism
--                         is a hypothesis-free theorem in this file too
--   iterN / iterT       `n` chained operations, native and transported,
--                         against a fixed right argument
--   theRoundTripsAreRedundant
--                       `iterT n (e .fst a) ‚â° e .fst (iterN n a)`
--
-- **THAT LAST IS THE DERIVATION THE MEASUREMENT WAS STANDING IN FOR.**
-- Each transported step provably inserts `invEq e ‚àò e .fst` around an
-- argument that was already in `A`'s image.  On VALUES that composite is
-- the identity ‚î which is why the theorem holds and why the two agree.
-- On TERMS it is not removed, because nothing removes it: `retEq` is a
-- path, and a path is not a reduction.  So `n` chained operations carry
-- exactly `n` provably-redundant round trips, one per step, and the
-- quadratic in the audited note is that `n` multiplied by the cost of
-- one round trip in a UNARY representation.  Nothing was measured to
-- get here.
------------------------------------------------------------------------

module TheTransportOverheadIsProvablyRedundantAndItsMechanismIsALibraryLemmaNotAMeasurement where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEq ; retEq)
open import Cubical.Foundations.Univalence using (ua ; transportUAop‚ÇÇ)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)

module _ {A B : Type} (e : A ‚âÉ B) (f : A ‚Üí A ‚Üí A) (a‚ÇÅ : A) where

  ------------------------------------------------------------------
  -- 1.  The transported operation, and its mechanism
  ------------------------------------------------------------------

  T : B ‚Üí B ‚Üí B
  T = transport (Œª i ‚Üí ua e i ‚Üí ua e i ‚Üí ua e i) f

  step : (x y : B) ‚Üí T x y ‚â° e .fst (f (invEq e x) (invEq e y))
  step = transportUAop‚ÇÇ e f

  ------------------------------------------------------------------
  -- 2.  n chained operations, both sides
  ------------------------------------------------------------------

  iterN : ‚Ñï ‚Üí A ‚Üí A
  iterN zero    a = a
  iterN (suc n) a = f (iterN n a) a‚ÇÅ

  iterT : ‚Ñï ‚Üí B ‚Üí B
  iterT zero    b = b
  iterT (suc n) b = T (iterT n b) (e .fst a‚ÇÅ)

  ------------------------------------------------------------------
  -- 3.  Every round trip the transported chain performs is redundant
  --
  -- The two `retEq`s are the round trips: each cancels ON VALUES, by a
  -- PATH.  A path is not a reduction, so nothing here removes them from
  -- the term ‚î which is precisely why the chain costs what the audited
  -- note measured.
  ------------------------------------------------------------------

  theRoundTripsAreRedundant :
    (n : ‚Ñï) (a : A) ‚Üí iterT n (e .fst a) ‚â° e .fst (iterN n a)
  theRoundTripsAreRedundant zero    a = refl
  theRoundTripsAreRedundant (suc n) a =
      cong (Œª z ‚Üí T z (e .fst a‚ÇÅ)) (theRoundTripsAreRedundant n a)
    ‚àô step (e .fst (iterN n a)) (e .fst a‚ÇÅ)
    ‚àô cong (Œª z ‚Üí e .fst (f z (invEq e (e .fst a‚ÇÅ)))) (retEq e (iterN n a))
    ‚àô cong (Œª z ‚Üí e .fst (f (iterN n a) z)) (retEq e a‚ÇÅ)
