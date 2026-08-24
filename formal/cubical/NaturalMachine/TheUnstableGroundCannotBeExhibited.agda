-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheUnstableGroundCannotBeExhibited
--
-- The open item this thread has been carrying as "construct the
-- separating object or show it cannot be constructed", answered on the
-- second branch — and a correction to the vocabulary the item was
-- phrased in, which matters more than the answer.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ITEM
--
-- `ExclusionRecoversGroundAtAPrice` proves two things that do not meet:
--
--   §4  a target descends through `q'` whenever it descends through `q`
--       — for EVERY set-valued target — exactly when `q'` identifies at
--       least as much as `q` does;
--
--   §9a a target descends whenever the two merely CO-EXCLUDE, provided
--       paths in the target are stable.
--
-- The gap between them is a pair `q, q'` that co-excludes and does not
-- co-identify.  §8 says such a pair needs a ground that is not stable.
-- So: exhibit one, or show that none can be exhibited.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `¬ ¬ Stable A`, for EVERY type A, with no hypothesis.  Two
--       lines.  `A → Stable A` and `¬ A → Stable A`, so a refutation of
--       stability refutes both A and its negation.
--
--   §2  hence no point of any ground can be shown unstable:
--       `¬ ¬ Stable (Ground q x x')` for all q, x, x'.  The pointwise
--       separating witness CANNOT be constructed, and this is a
--       theorem about what is unbuildable rather than a report of not
--       having built it.
--
--   §3  and the residue, stated exactly rather than swept up.  §1 gives
--       `(x x' : X) → ¬ ¬ Stable (Ground q x x')`.  Getting from that
--       to `¬ ¬ ((x x' : X) → Stable (Ground q x x'))` is a
--       double-negation SHIFT, which is not available here.  So the
--       Π-form of the obstruction is not refuted by §1, and §3 records
--       the implication that IS provable and names the missing
--       principle instead of hiding behind it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CORRECTION, WHICH IS THE LARGER HALF
--
-- This thread's standing state has said, in every cycle for a long
-- while, that `¬ FactorsThrough` IS the fourth bhaṅga — अवक्तव्य —
-- "proved".  That identification has never been earned and should stop
-- being asserted.
--
-- What is true: `¬ FactorsThrough q t` says no single decoder expresses
-- `t` from `q`'s observations.  What अवक्तव्य says, in the Jaina
-- account (Umāsvāti's तत्त्वार्थसूत्र and the commentarial tradition
-- after it; Samantabhadra and Akalaṅka on the seven positions): it is
-- what arises when अस्ति and नास्ति are predicated SIMULTANEOUSLY
-- (युगपत्) of the same subject in the same respect — not the failure of
-- some third thing to exist.
--
-- These are not the same claim, and the analogy has been doing work it
-- did not pay for.  Three things would have to be produced before the
-- identification is more than a suggestive name:
--
--   (i)   the two predications, as objects, with their respects;
--   (ii)  a simultaneity operation distinct from taking both in
--         succession.  What this corpus actually has, in the top-level
--         module `SaptabhangiNaya` — read, not recalled — is
--         `yugapat-empty : ¬ Σ[ n ] (P n × ¬ P n)` and
--         `krama→yugapat-fails : ¬ (Krama → Yugapat)`.  That is the
--         opposite of a simultaneity operation: it says the obvious
--         candidate for युगपत् is EMPTY, being a contradiction at one
--         नय.  So the distinction is not merely unused here, it is
--         unbuilt — and three of this thread's modules have been citing
--         a `NaturalMachine.SaptabhangiNaya` that does not exist, with
--         a summary ("krama ≠ sahā") that is not what the real module
--         proves.  Both errors are corrected at their sites;
--   (iii) a demonstration that the simultaneous object is the
--         non-factoring, rather than merely resembling it.
--
-- None of the three is in this file or, as far as I can find, anywhere
-- in this thread.  Until they are, the honest statement is: `¬
-- FactorsThrough` is an obstruction to expressibility by one decoder,
-- and calling it the fourth bhaṅga is a naming convention that has not
-- been discharged.  A नय that asserts itself by denying the others is a
-- दुर्नय; a name that asserts an identification it has not shown is the
-- same failure at the level of vocabulary.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT §1 DOES TO THE DEFLATIONARY TEST
--
-- Thread (2) has been asking: is every absence in this corpus stable?
-- §1 says that question is ONE-SIDED.  It can be settled affirmatively
-- at any site where stability is provable, and it can never be settled
-- negatively anywhere, because `¬ Stable A` is refuted for every A.  A
-- test that admits confirmations and admits no refutations is not
-- thereby answered — it is a different kind of question from the one
-- it looked like, and the difference should be recorded before any
-- more cycles are spent looking for the counterexample that closes it.
--
-- The four corners, on the separating object.  ASSERTED — refuted at
-- points by §2.  DENIED — not claimed; §2 is about exhibition in this
-- type theory, not about existence.  BOTH and NEITHER — not reached:
-- the Π-form residue in §3 is exactly where they would have to be
-- taken, and a double-negation shift is what taking them would need.
--
-- NOT CLAIMED.  That no separating pair exists in any extension of this
-- setting (§1 shows none can be exhibited HERE, which is a statement
-- about this type theory and about exhibition, not about existence);
-- that double-negation shift is false (it is simply not available);
-- that the saptabhaṅgī cannot be modelled — only that it has not been
-- modelled by anything called that here.
------------------------------------------------------------------------

module NaturalMachine.TheUnstableGroundCannotBeExhibited where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Stable)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_)

open import NaturalMachine.ExclusionRecoversGroundAtAPrice using (Ground)

private
  variable
    ℓ ℓx ℓy : Level

------------------------------------------------------------------------
-- 1.  Stability is never refutable
--
-- Both `A` and `¬ A` yield stability, so a refutation of stability
-- refutes both, and the second application closes it.
------------------------------------------------------------------------

affirmation→stable : {A : Type ℓ} → A → Stable A
affirmation→stable a _ = a

absence→stable : {A : Type ℓ} → ¬ A → Stable A
absence→stable na nn = ⊥.rec (nn na)

¬¬Stable : {A : Type ℓ} → ¬ ¬ Stable A
¬¬Stable ns = ns (absence→stable (λ a → ns (affirmation→stable a)))

------------------------------------------------------------------------
-- 2.  So no point of a ground can be exhibited as unstable
--
-- The pointwise hypothesis of `coExclude→coIdentify-stable` can never
-- be refuted at a point.  Whatever blocks the two theorems from
-- meeting, it is not a state-pair one could put on the table.
------------------------------------------------------------------------

noUnstablePoint :
  {X : Type ℓx} {Y : Type ℓy} (q : X → Y) (x x' : X)
  → ¬ ¬ Stable (Ground q x x')
noUnstablePoint q x x' = ¬¬Stable

-- said in the form the open item was phrased in: the separating
-- witness, at a point, is unbuildable.
noPointwiseSeparatingWitness :
  {X : Type ℓx} {Y : Type ℓy} (q : X → Y)
  → ¬ (Σ[ p ∈ (X × X) ] (¬ Stable (Ground q (fst p) (snd p))))
noPointwiseSeparatingWitness q (p , np) = ¬¬Stable np

------------------------------------------------------------------------
-- 3.  The residue is exactly a double-negation shift
--
-- §1 is pointwise.  The hypothesis actually used by
-- `coExclude→coIdentify-stable` is a Π.  Passing ¬¬ through a Π is a
-- shift principle; it is not derivable here and is not assumed here.
-- What is recorded is the implication that holds, with the principle
-- named as an explicit hypothesis so that nothing depends on it
-- silently.
------------------------------------------------------------------------

DNS : (X : Type ℓx) (B : X → Type ℓ) → Type (ℓ-max ℓx ℓ)
DNS X B = ((x : X) → ¬ ¬ B x) → ¬ ¬ ((x : X) → B x)

-- Two shifts are needed, one per quantifier, and both are stated as
-- hypotheses.  With them the full hypothesis of §8a is ¬¬-established;
-- without them §1 stays pointwise.  Nothing in this corpus is allowed
-- to use this lemma without discharging `DNS` at the site.
¬¬StableGround-fromDNS :
  {X : Type ℓx} {Y : Type ℓy} (q : X → Y)
  → ((x : X) → DNS X (λ x' → Stable (Ground q x x')))
  → DNS X (λ x → (x' : X) → Stable (Ground q x x'))
  → ¬ ¬ ((x x' : X) → Stable (Ground q x x'))
¬¬StableGround-fromDNS q inner outer =
  outer (λ x → inner x (λ x' → ¬¬Stable))

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `NaturalMachine.DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `¬`, `→`, `×`, `Π`, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `⊎`,
-- `no-barrier-claim : ¬ (¬ (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `NaturalMachine.TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not — and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
