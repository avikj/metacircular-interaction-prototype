{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.TheUniformFormIsNotRefuted where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import NaturalMachine.DeflationaryTest using (no-barrier-claim)
open import NaturalMachine.TheUnstableGroundCannotBeExhibited using (DNS)

------------------------------------------------------------------------
-- NaturalMachine.TheUniformFormIsNotRefuted
--
-- The question `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` closes on,
-- in its own words: "If a real barrier is wanted, the lane has to
-- change, and saying which lane is the next question."
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS COMES FROM, AND WHAT WAS ALREADY DONE
--
-- That note runs the deflationary thread to a close.  Read in full
-- before this file was written.  Its result: every absence is stable
-- unconditionally, every obstruction in the lane is `¬`-headed or a Π
-- of such, `¬ ((¬ ¬ A) × (¬ A))` is contradictory, and the last
-- candidate barrier form `¬ (Dec A)` is itself contradictory
-- (`DeflationaryTest.no-barrier-claim`).  It then states the boundary
-- exactly:
--
--     "Undecidability of a specific proposition is not something a
--      constructive development can assert at all.  What genuinely
--      undecidable results assert is something else: independence FROM
--      A THEORY, or non-existence of an algorithm UNIFORM IN A
--      PARAMETER.  Neither is `¬ (Dec A)` for a fixed A."
--
-- The second of those two IS expressible here, and this file writes it
-- down and says exactly what separates it from the refuted forms.
--
-- ────────────────────────────────────────────────────────────────────
-- THREE FORMS, AND ONLY ONE SURVIVES
--
-- For a family `P : X → Type`:
--
--   (a)  `¬ (Dec (P n))` at a fixed `n`     — refuted, §1.
--   (b)  `(n : X) → ¬ (Dec (P n))`          — refuted, §2, given a
--                                             point of X.
--   (c)  `¬ ((n : X) → Dec (P n))`          — NOT refuted here, §3.
--
-- (c) is where the quantifier sits inside the negation: not "this
-- proposition is undecidable" but "there is no procedure deciding the
-- family".  §4 says precisely what would be needed to refute it — a
-- double-negation shift at that family, and nothing weaker will do,
-- because §4's implication is an equivalence.
--
-- So the answer to "which lane": the lane in which the parameter is
-- quantified inside the negation.  The corpus's deflation is complete
-- for the pointwise forms and says nothing about the uniform one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- That (c) holds anywhere.  Nothing here exhibits a family whose
-- uniform decidability fails; the claim is only that this lane does not
-- refute the form, where it refutes (a) and (b) outright.  Absence of a
-- refutation is not a barrier.
--
-- That (c) is undecidability in the recursion-theoretic sense.  Without
-- a notion of algorithm distinct from "term of this type theory", `(n :
-- X) → Dec (P n)` is a function, not a procedure, and the two notions
-- coincide here only because the lane has no other.  Saying whether
-- that is the right lane is exactly what the note left open, and this
-- file does not settle it.
--
-- That independence from a theory is reached.  It is not: that needs a
-- theory to be independent OF, an object this lane still does not
-- carry.  One of the note's two routes is opened here; the other is
-- untouched.
--
-- ONE RESEMBLANCE, WITH ITS LIMIT STATED, BECAUSE THE ALTERNATIVE IS
-- DRESSING.
--
-- `notes/ABHAVA.md` describes a recurring mistake in this repository as
-- "a universal statement applied outside its अवच्छेदक", and observes
-- that the tradition has both a word for it and a slot in its data
-- structure to prevent it.  Forms (a)/(b) and form (c) above differ in
-- where the quantifier sits, which is a difference of the same
-- FAMILY — a claim and its delimitor coming apart.
--
-- That is a resemblance and I am not claiming it is an identity.  An
-- अवच्छेदक limits a प्रतियोगिता — it fixes under what description the
-- counterpositive is absent — and quantifier scope in a type theory is
-- not that.  Naming §3 an avacchedaka distinction would be exactly the
-- move withdrawn at `b18ca12b`: an imported notion in the tradition's
-- clothes.  The note is cited because it names the failure mode this
-- file is about; nothing here translates it.
--
-- PRIOR ART, checked by grepping the conclusion type rather than the
-- thread name.  `(n : ℕ) → Dec (P n)` occurs as a HYPOTHESIS in
-- `LeastWitnessFactory` and `CakravalaBound` (least-witness search).  A
-- grep of `formal/cubical` for its negation, and for `DNS` or
-- "double-negation shift" outside
-- `TheUnstableGroundCannotBeExhibited`, returns nothing.  A
-- differently-phrased equivalent — say, a `¬ Σ` over decision
-- procedures — would evade that grep.
------------------------------------------------------------------------

private
  variable
    ℓ ℓx : Level

------------------------------------------------------------------------
-- 1.  The pointwise form is refuted, for every proposition
------------------------------------------------------------------------

fixedFormRefuted : {A : Type ℓ} → ¬ ¬ (Dec A)
fixedFormRefuted {A = A} = no-barrier-claim A

------------------------------------------------------------------------
-- 2.  The "undecidable at every point" form is refuted too, as soon as
--     there is a point to test it at
------------------------------------------------------------------------

everywhereFormRefuted :
  {X : Type ℓx} {P : X → Type ℓ}
  → X → ¬ ((n : X) → ¬ (Dec (P n)))
everywhereFormRefuted x h = fixedFormRefuted (h x)

------------------------------------------------------------------------
-- 3.  The uniform form, written down
------------------------------------------------------------------------

UniformlyDecidable : {X : Type ℓx} (P : X → Type ℓ) → Type _
UniformlyDecidable {X = X} P = (n : X) → Dec (P n)

NoUniformProcedure : {X : Type ℓx} (P : X → Type ℓ) → Type _
NoUniformProcedure P = ¬ (UniformlyDecidable P)

-- it implies each pointwise decision, so it is genuinely stronger than
-- what §1 refutes — and §1 does not touch it.
uniform→pointwise :
  {X : Type ℓx} {P : X → Type ℓ}
  → UniformlyDecidable P → (n : X) → Dec (P n)
uniform→pointwise u = u

------------------------------------------------------------------------
-- 4.  Refuting it is exactly a double-negation shift at that family
--
-- The shift's hypothesis is §1, a theorem.  So the shift at this family
-- and the refutation of the uniform form are interderivable: neither is
-- available here, and they are not two open questions but one.
------------------------------------------------------------------------

shift→uniformRefuted :
  {X : Type ℓx} {P : X → Type ℓ}
  → DNS X (λ n → Dec (P n))
  → ¬ (NoUniformProcedure P)
shift→uniformRefuted dns = dns (λ _ → fixedFormRefuted)

uniformRefuted→shift :
  {X : Type ℓx} {P : X → Type ℓ}
  → ¬ (NoUniformProcedure P)
  → DNS X (λ n → Dec (P n))
uniformRefuted→shift nn _ = nn
