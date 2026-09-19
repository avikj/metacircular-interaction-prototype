{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FailClosedForgetsOnlyTheReasonForDistrust
--
-- `interactive/KernelProbe.hs` collapses two distinct situations into one
-- verdict on purpose â” "absence and failure share the same grade,
-- fail-closed" â” and grades CAPABILITY, not soundness.  The collapse is
-- exactly one-sided, and this says in which direction:
--
--   * the TRUSTING verdict determines the state completely;
--   * the DISTRUSTING verdict determines nothing beyond "not that".
--
-- So a fail-closed summary is free on the side you act on and total loss
-- on the side you do not.  That is what makes it the right shape for a
-- guard and the wrong shape for a diagnosis.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE SHELF SAYS, READ BEFORE WRITING
--
-- It probes with two modules â” a builtin-only `2 + 2 â‰¡ 4` under
-- `--no-libraries`, and the same under `--cubical` â” and prints
-- `KERNEL-PROBE agda=â¦ refl=â¦ cubical=â¦`, exiting 0 iff refl-capable and
-- 2 otherwise, "absence and failure share the same grade".  Its own
-- limit, in its own words: *"it grades capability, not soundness.  A
-- passing probe says 'this kernel checks this class of module'; it
-- certifies nothing about the axioms of any registered library."*
--
-- NOT PROVED HERE, and it is the shelf's own limit rather than a gap in
-- it: that capability implies soundness.  It does not, the shelf says so
-- first, and Â§3 does not try to bridge it â” a kernel accepting one true
-- statement is compatible with a library that proves a false one, and
-- nothing below models libraries or axioms at all.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- HOW THIS DIFFERS FROM THE PREVIOUS CYCLE, kept apart deliberately
--
-- `AFigureWithoutItsInputDecidesNothing` also ends in a one-sided test:
-- a mismatch refutes, a match establishes nothing.  The two are NOT the
-- same finding.  There the loss was accidental â” an INPUT the reader
-- happens not to have.  Here the loss is DELIBERATE and in the OUTPUT â”
-- the verdict is coarsened on purpose so that an ungraded kernel cannot
-- be trusted.  Same shape of one-sidedness, different cause, and the
-- design consequences are opposite: the first wants the input published,
-- the second wants the collapse kept.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module FailClosedForgetsOnlyTheReasonForDistrust where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; falseâ‰¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  The three situations the probe can be in, and the two-valued
--     verdict it emits
------------------------------------------------------------------------

data KernelState : Type where
  absent    : KernelState   -- agda not on PATH
  incapable : KernelState   -- present, refl probe fails
  capable   : KernelState   -- present, refl probe passes

-- fail-closed: only the third is trusted, and the first two are graded
-- alike ON PURPOSE
trusted : KernelState â†’ Bool
trusted absent    = false
trusted incapable = false
trusted capable   = true

------------------------------------------------------------------------
-- 2.  The trusting side loses nothing
------------------------------------------------------------------------

trustDeterminesTheState :
  (s : KernelState) â†’ trusted s â‰¡ true â†’ s â‰¡ capable
trustDeterminesTheState absent    p = Cubical.Data.Empty.rec (falseâ‰¢true p)
trustDeterminesTheState incapable p = Cubical.Data.Empty.rec (falseâ‰¢true p)
trustDeterminesTheState capable   _ = refl

------------------------------------------------------------------------
-- 3.  The distrusting side loses everything except "not capable"
------------------------------------------------------------------------

private
  isAbsent : KernelState â†’ Type
  isAbsent absent    = Unit
  isAbsent incapable = âŠ¥
  isAbsent capable   = âŠ¥

absentâ‰¢incapable : Â¬ (absent â‰¡ incapable)
absentâ‰¢incapable p = transport (cong isAbsent p) tt

distrustForgetsTheReason :
  Î£[ s âˆˆ KernelState ] Î£[ t âˆˆ KernelState ]
    ((Â¬ (s â‰¡ t)) Ã— (trusted s â‰¡ trusted t))
distrustForgetsTheReason = absent , incapable , absentâ‰¢incapable , refl

-- and what distrust DOES determine, which is exactly one thing
distrustDeterminesOnlyNotCapable :
  (s : KernelState) â†’ trusted s â‰¡ false â†’ Â¬ (s â‰¡ capable)
distrustDeterminesOnlyNotCapable s p q =
  falseâ‰¢true (sym p âˆ™ cong trusted q)

------------------------------------------------------------------------
-- 4.  The reading
--
-- Â§2 and Â§3 together are the precise content of "fail-closed": the map
-- to the verdict is injective over `true` and two-to-one over `false`.
-- A guard consumes only the `true` fibre, so it loses nothing it uses; a
-- reader diagnosing a red probe consumes the `false` fibre, and there
-- the verdict alone cannot distinguish a missing compiler from a broken
-- one.  Which is why the shelf prints `agda=<version|ABSENT>` on the
-- SAME line as the grade: the reason for distrust is carried beside the
-- verdict, not inside it.
--
------------------------------------------------------------------------
