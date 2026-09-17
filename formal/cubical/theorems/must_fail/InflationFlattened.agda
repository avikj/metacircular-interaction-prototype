{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- InflationFlattened
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md Â§7), in the pattern of
-- `Control/WrongEquivalence.agda`, `Control/WrongFirstStep.agda` and
-- `Control/QuantifierDrop.agda`.
--
-- WHAT IT ASSERTS.  Thm 3.5 of
-- HÂ(Î“,V) â’ HÂ(G,V) is injective for Î“ = G/N", i.e. enlargement ALONG A
-- QUOTIENT is not a repair â” as it is restated once the qualifier is
-- dropped: "symmetry enlargement â¦ is **not a repair at all**" (Â§2.8),
-- "widening *symmetry* cannot [kill]" (Â§3.5 Reading), "*refuted, not a
-- repair*" (Â§4 table), "proved to be no repair" (Â§5.5).  The audit
-- row keeps "along a quotient" and every other statement of the result
-- loses it.
--
-- WHY IT MUST FAIL.  Under the flat reading the theorem would cover the
-- OTHER enlargement, a subgroup inclusion Î“ â‰ G â” where there is no
-- canonical HÂ(Î“,V) â’ HÂ(G,V) at all, only restriction going the other
-- way.  On the model of `InflationVersusSubgroup`
-- (G = â/4 âŠ N = {0,2} = ker(G â  Î“), V = â/2) the map that would have
-- to exist does not: `res` is identically zero, so nothing splits it,
-- and `infl` â” the quotient theorem's own map â” is not a section of it.
-- `InflationVersusSubgroup.flattened-enlargement-false` derives âŠ from
-- precisely the type asserted below.
--
-- The two assertions are the two ways the flattening actually happens
-- in prose: (a) hand the subgroup reading the quotient theorem's map,
-- (b) build the "inflation" for a subgroup by precomposing with the
-- inclusion â” which is the direction error the word "enlargement" hides.
--
-- This is the instrument for a defect with NO LEXICAL SIGNATURE: the
-- flattened sentence contains no wrong word, only a missing
-- qualifier, so grep cannot see it and a type can.
--
-- It is NOT part of the checked build.  `agda` does not
-- import it, and nothing else may: the directory `NaturalMachine/Control/`
-- is excluded from the root aggregate exactly so its contents may fail.
--
-- OBSERVED, 2026-08-15, container toolchain (Agda 2.6.3 + cubical v0.5;
-- `formal/cubical/BUILD.md` pins 2.8.0 + v0.9, check OUTSTANDING),
-- `LC_ALL=C.UTF-8 agda NaturalMachine/Control/InflationFlattened.agda`,
-- exit code 42, error verbatim:
--
--   /home/user/math/formal/cubical/NaturalMachine/Control/InflationFlattened.agda:91,28-32
--   k0 != kÎ of type H2
--   when checking that the expression refl has type res (infl kÎ) â‰¡ kÎ
--
-- Read it: the checker holds the restriction to the SUBGROUP of the
-- inflated class (`k0`, zero â” restriction along N â â/4 kills
-- everything) apart from the class itself (`kÎ`).  The dropped
-- qualifier "along a quotient" is what the machine names, by exhibiting
-- the two things the flat word "enlargement" runs together.  The `k0`
-- case one line above type-checks, which is why the flattened reading
-- looks true if you only test the zero class.
--
-- (Agda stops at the first error, so the second assertion,
-- `inflation-along-the-inclusion`, is not reached.  Checked separately
-- by commenting out the first (same file, three lines commented out,
-- then restored): it fails at 97,50-56 with
--   Z4 !=< Z2
--   when checking that the inferred type of an application
--     Z4
--   matches the expected type
--     Z2
-- â” the inclusion `incl : Z2 â’ Z4` cannot be precomposed to push a
-- class forward; precomposition with an inclusion is restriction.)
--
-- If a future edit makes this file compile, the note's principal
-- negative has been silently extended to a reading its proof does not
-- reach, and the corpus has readmitted exactly the defect
-- `FULL_READ_DRAW_5` Â§D7 catalogued.
------------------------------------------------------------------------

module InflationFlattened where

open import Cubical.Foundations.Prelude

open import InflationVersusSubgroup
  using (H2 ; k0 ; kÎ¹ ; H4 ; Z2 ; Z4 ; infl ; res ; real2 ; incl)

-- (a) The quotient theorem's map, offered as the subgroup transport.
flattened-enlargement : (c : H2) â†’ res (infl c) â‰¡ c
flattened-enlargement k0 = refl
flattened-enlargement kÎ¹ = refl

-- (b) The subgroup "inflation", built the only way the flat word
--     suggests: precompose with the inclusion.  The inclusion points
--     into G, so this defines a map on G-elements only by type error.
inflation-along-the-inclusion : H2 â†’ (Z4 â†’ Z2)
inflation-along-the-inclusion c = Î» g â†’ real2 c (incl g)
