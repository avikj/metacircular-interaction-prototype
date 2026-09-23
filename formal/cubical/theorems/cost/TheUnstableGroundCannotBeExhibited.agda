{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheUnstableGroundCannotBeExhibited
--
-- The open item this thread has been carrying as "construct the
-- separating object or show it cannot be constructed", answered on the
-- second branch â” and a correction to the vocabulary the item was
-- phrased in, which matters more than the answer.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ITEM
--
-- `ExclusionRecoversGroundAtAPrice` proves two things that do not meet:
--
--   Â§4  a target descends through `q'` whenever it descends through `q`
--       â” for EVERY set-valued target â” exactly when `q'` identifies at
--       least as much as `q` does;
--
--   Â§9a a target descends whenever the two merely CO-EXCLUDE, provided
--       paths in the target are stable.
--
-- The gap between them is a pair `q, q'` that co-excludes and does not
-- co-identify.  Â§8 says such a pair needs a ground that is not stable.
-- So: exhibit one, or show that none can be exhibited.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `Â Â Stable A`, for EVERY type A, with no hypothesis.  Two
--       lines.  `A â’ Stable A` and `Â A â’ Stable A`, so a refutation of
--       stability refutes both A and its negation.
--
--   Â§2  hence no point of any ground can be shown unstable:
--       `Â Â Stable (Ground q x x')` for all q, x, x'.  The pointwise
--       separating witness CANNOT be constructed, and this is a
--       theorem about what is unbuildable rather than a report of not
--       having built it.
--
--   Â§3  and the residue, stated exactly rather than swept up.  Â§1 gives
--       `(x x' : X) â’ Â Â Stable (Ground q x x')`.  Getting from that
--       to `Â Â ((x x' : X) â’ Stable (Ground q x x'))` is a
--       double-negation SHIFT, which is not available here.  So the
--       Î -form of the obstruction is not refuted by Â§1, and Â§3 records
--       the implication that IS provable and names the missing
--       principle instead of hiding behind it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CORRECTION, WHICH IS THE LARGER HALF
--
-- This thread's standing state has said, in every cycle for a long
-- while, that `Â FactorsThrough` IS the fourth bhaga â” ààµà•àààµàà¯ â”
-- "proved".  That identification has never been earned and should stop
-- being asserted.
--
-- What is true: `Â FactorsThrough q t` says no single decoder expresses
-- `t` from `q`'s observations.  What ààµà•àààµàà¯ says, in the Jaina
-- account (Umsvti's ààààààµà¾à°ààààààà° and the commentarial tradition
-- after it; Samantabhadra and Akalaka on the seven positions): it is
-- what arises when ààààà¿ and à¨à¾àààà¿ are predicated SIMULTANEOUSLY
-- (à¯àà—ààà) of the same subject in the same respect â” not the failure of
-- some third thing to exist.
--
-- These are not the same claim, and the analogy has been doing work it
-- did not pay for.  Three things would have to be produced before the
-- identification is more than a suggestive name:
--
--   (i)   the two predications, as objects, with their respects;
--   (ii)  a simultaneity operation distinct from taking both in
--         succession.  What this corpus actually has, in the top-level
--         module `SaptabhangiNaya` â” read, not recalled â” is
--         `yugapat-empty : Â Î[ n ] (P n — Â P n)` and
--         `orderâ’yugapat-fails : Â (Order â’ Yugapat)`.  That is the
--         opposite of a simultaneity operation: it says the obvious
--         candidate for à¯àà—ààà is EMPTY, being a contradiction at one
--         à¨à¯.  So the distinction is not merely unused here, it is
--         unbuilt â” and three of this thread's modules have been citing
--         a `SaptabhangiNaya` that does not exist, with
--         a summary ("order â‰  sah") that is not what the real module
--         proves.  Both errors are corrected at their sites;
--   (iii) a demonstration that the simultaneous object is the
--         non-factoring, rather than merely resembling it.
--
-- None of the three is in this file or, as far as I can find, anywhere
-- in this thread.  Until they are, the honest statement is: `Â
-- FactorsThrough` is an obstruction to expressibility by one decoder,
-- and calling it the fourth bhaga is a naming convention that has not
-- been discharged.  A à¨à¯ that asserts itself by denying the others is a
-- à¦àà°àà¨à¯; a name that asserts an identification it has not shown is the
-- same failure at the level of vocabulary.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT Â§1 DOES TO THE DEFLATIONARY TEST
--
-- Thread (2) has been asking: is every absence in this corpus stable?
-- Â§1 says that question is ONE-SIDED.  It can be settled affirmatively
-- at any site where stability is provable, and it can never be settled
-- negatively anywhere, because `Â Stable A` is refuted for every A.  A
-- test that admits confirmations and admits no refutations is not
-- thereby answered â” it is a different kind of question from the one
-- it looked like, and the difference should be recorded before any
-- more cycles are spent looking for the counterexample that closes it.
--
-- The four corners, on the separating object.  ASSERTED â” refuted at
-- points by Â§2.  DENIED â” not claimed; Â§2 is about exhibition in this
-- type theory, not about existence.  BOTH and NEITHER â” not reached:
-- the Î -form residue in Â§3 is exactly where they would have to be
-- taken, and a double-negation shift is what taking them would need.
--
------------------------------------------------------------------------

module TheUnstableGroundCannotBeExhibited where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Stable)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_)

open import ExclusionRecoversGroundAtAPrice using (Ground)

private
  variable
    â„“ â„“x â„“y : Level

------------------------------------------------------------------------
-- 1.  Stability is never refutable
--
-- Both `A` and `Â A` yield stability, so a refutation of stability
-- refutes both, and the second application closes it.
------------------------------------------------------------------------

affirmationâ†’stable : {A : Type â„“} â†’ A â†’ Stable A
affirmationâ†’stable a _ = a

absenceâ†’stable : {A : Type â„“} â†’ Â¬ A â†’ Stable A
absenceâ†’stable na nn = âŠ¥.rec (nn na)

Â¬Â¬Stable : {A : Type â„“} â†’ Â¬ Â¬ Stable A
Â¬Â¬Stable ns = ns (absenceâ†’stable (Î» a â†’ ns (affirmationâ†’stable a)))

------------------------------------------------------------------------
-- 2.  So no point of a ground can be exhibited as unstable
--
-- The pointwise hypothesis of `coExcludeâ’coIdentify-stable` can never
-- be refuted at a point.  Whatever blocks the two theorems from
-- meeting, it is not a state-pair one could put on the table.
------------------------------------------------------------------------

noUnstablePoint :
  {X : Type â„“x} {Y : Type â„“y} (q : X â†’ Y) (x x' : X)
  â†’ Â¬ Â¬ Stable (Ground q x x')
noUnstablePoint q x x' = Â¬Â¬Stable

-- said in the form the open item was phrased in: the separating
-- witness, at a point, is unbuildable.
noPointwiseSeparatingWitness :
  {X : Type â„“x} {Y : Type â„“y} (q : X â†’ Y)
  â†’ Â¬ (Î£[ p âˆˆ (X Ã— X) ] (Â¬ Stable (Ground q (fst p) (snd p))))
noPointwiseSeparatingWitness q (p , np) = Â¬Â¬Stable np

------------------------------------------------------------------------
-- 3.  The residue is exactly a double-negation shift
--
-- Â§1 is pointwise.  The hypothesis actually used by
-- `coExcludeâ’coIdentify-stable` is a Î .  Passing ÂÂ through a Î  is a
-- shift principle; it is not derivable here and is not assumed here.
-- What is recorded is the implication that holds, with the principle
-- named as an explicit hypothesis so that nothing depends on it
-- silently.
------------------------------------------------------------------------

DNS : (X : Type â„“x) (B : X â†’ Type â„“) â†’ Type (â„“-max â„“x â„“)
DNS X B = ((x : X) â†’ Â¬ Â¬ B x) â†’ Â¬ Â¬ ((x : X) â†’ B x)

-- Two shifts are needed, one per quantifier, and both are stated as
-- hypotheses.  With them the full hypothesis of Â§8a is ÂÂ-established;
-- without them Â§1 stays pointwise.  Nothing in this corpus is allowed
-- to use this lemma without discharging `DNS` at the site.
Â¬Â¬StableGround-fromDNS :
  {X : Type â„“x} {Y : Type â„“y} (q : X â†’ Y)
  â†’ ((x : X) â†’ DNS X (Î» x' â†’ Stable (Ground q x x')))
  â†’ DNS X (Î» x â†’ (x' : X) â†’ Stable (Ground q x x'))
  â†’ Â¬ Â¬ ((x x' : X) â†’ Stable (Ground q x x'))
Â¬Â¬StableGround-fromDNS q inner outer =
  outer (Î» x â†’ inner x (Î» x' â†’ Â¬Â¬Stable))

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `Â`, `â’`, `—`, `Î `, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `âŠ`,
-- `no-barrier-claim : Â (Â (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not â” and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
