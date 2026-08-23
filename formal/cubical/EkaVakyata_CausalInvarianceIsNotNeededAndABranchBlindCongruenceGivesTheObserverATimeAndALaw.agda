{-# OPTIONS --cubical --safe #-}
--
-- एकवाक्यता — construal as a single utterance.  In Pūrva-Mīmāṃsā, ekavākyatā
-- is the principle that statements scattered across a text must be construed
-- as ONE injunction where they can be: different routes through the corpus
-- must come to one reading.  Jaimini, *Mīmāṃsāsūtra*, with Śabara's *Bhāṣya*
-- (the sūtras c. 200 BCE – 200 CE, Śabara c. 5th c.); the principle is
-- standard in that hermeneutics.  The word is taken for what it names.
-- Nothing below is attributed to those texts.
--
-- WHAT THIS IS ABOUT.  A multiway rule — one state, many successors — is the
-- shape of a rewriting system, and the standard demand made of it is
-- CONFLUENCE: any two branches can be brought back together.  In the
-- computational-physics reading, confluence is what is called causal
-- invariance, and it is the hypothesis under which the observed history is
-- taken not to depend on the order in which updates were applied.  It is a
-- strong global property of the rule, and it usually fails.
--
-- THE FINDING.  It is not needed, and the thing that replaces it is a
-- property of the OBSERVER rather than of the rule:
--
--     if the observer's reading of a successor is determined by its reading
--     of the predecessor — the same reading in, the same reading out, NO
--     MATTER WHICH BRANCH IS TAKEN — then any two runs of the same length
--     from equally-read starts are equally read at every step.
--
-- The observer then has a deterministic law AND a well-defined time (the step
-- count), inside a rule that may branch without limit and need not be
-- confluent anywhere.  No confluence hypothesis appears in the proof, and
-- there is none to appear: `एकवाक्यता` below assumes only the congruence.
--
-- And the converse bite, as everywhere in this corpus: ONE pair of branches
-- the observer can tell apart destroys it — not the schedulers anyone tried,
-- every reading-level law at once.
--
-- This is the multiway face of `Anuvrtti_...`, which did the deterministic
-- case.  The step there was a function; here it is a relation, and the extra
-- content is exactly that the branch does not have to be chosen.
module EkaVakyata_CausalInvarianceIsNotNeededAndABranchBlindCongruenceGivesTheObserverATimeAndALaw where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using ()
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Sigma using (Σ-syntax; _×_; _,_)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ {X : Type ℓ} (R : X → X → Type ℓ') where

  -- a run of exactly n steps, with the branches it took
  -- Defined by recursion on the length rather than as an indexed family: a
  -- run of zero steps IS an identification, and a run of n+1 steps is a first
  -- branch and a run of n.  Cubical Agda does not accept the doubly-indexed
  -- match this proof would otherwise need, and the recursive form is the
  -- better statement anyway -- the branch taken is right there in the data.
  मार्गः : ℕ → X → X → Type (ℓ-max ℓ ℓ')
  मार्गः zero x y = Lift {j = ℓ'} (x ≡ y)
  मार्गः (suc n) x z = Σ[ y ∈ X ] (R x y × मार्गः n y z)

  -- the observer cannot see WHICH branch was taken: equal readings in, equal
  -- readings out, for every choice of successor on either side.
  शाखान्धम् : {V : Type ℓ''} → (X → V) → Type _
  शाखान्धम् {V = V} o =
    {x y x' y' : X} → o x ≡ o y → R x x' → R y y' → o x' ≡ o y'

  -- ------------------------------------------------------------- the law
  -- Any two runs of the same length, from starts the observer cannot tell
  -- apart, end in states the observer cannot tell apart.  The branching is
  -- unrestricted and no confluence is assumed.
  एकवाक्यता : {V : Type ℓ''} (o : X → V) → शाखान्धम् o
    → (n : ℕ) {x y u v : X}
    → मार्गः n x u → मार्गः n y v → o x ≡ o y → o u ≡ o v
  एकवाक्यता o blind zero (lift p) (lift q) e =
    cong o (sym p) ∙ e ∙ cong o q
  एकवाक्यता o blind (suc n) (_ , r , p) (_ , s , q) e =
    एकवाक्यता o blind n p q (blind e r s)

  -- ------------------------------------------------- and what breaks it
  -- A predictor at the level of readings: one function of the reading that
  -- gives the reading after any step, whichever branch.
  भाव्यम् : {V : Type ℓ''} → (X → V) → Type _
  भाव्यम् {V = V} o = Σ[ g ∈ (V → V) ] ({x x' : X} → R x x' → o x' ≡ g (o x))

  -- a predictor is branch-blind, so the two notions cannot come apart
  भाव्य-शाखान्धम् : {V : Type ℓ''} (o : X → V) → भाव्यम् o → शाखान्धम् o
  भाव्य-शाखान्धम् o (g , p) e r s = p r ∙ cong g e ∙ sym (p s)

  -- ONE branching the observer can see refutes every reading-level law.
  -- Two successors of ONE state with different readings is the sharpest
  -- case: the start readings are equal by refl, so no g can send one value
  -- to two.
  अभाव्यम् : {V : Type ℓ''} (o : X → V) {x x' x'' : X}
    → R x x' → R x x'' → ¬ (o x' ≡ o x'')
    → ¬ (भाव्यम् o)
  अभाव्यम् o r s d h = d (भाव्य-शाखान्धम् o h refl r s)

-- --------------------------------------------------------------- मर्यादा
--
-- WHAT IS NOT CLAIMED.  Nothing here says a branch-blind observer exists for
-- a given rule, nor that one is easy to find; `machine/DrshtiJala_...`
-- computes them for a deterministic rule and the multiway case is not done.
-- Nor is anything claimed about what such an observer's time is PHYSICALLY —
-- `मार्गः n` counts steps, and calling that a time is a reading, not a
-- theorem.
--
-- WHAT IS CLAIMED, and it is the whole of it: the global hypothesis is
-- replaceable by a local one about the observer, and the replacement is not
-- an approximation.  `एकवाक्यता` has no confluence premise in its statement
-- or its proof.
