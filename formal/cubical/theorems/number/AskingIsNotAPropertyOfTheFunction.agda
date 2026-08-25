{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AskingIsNotAPropertyOfTheFunction
--
-- Whether a definition asks a decision is a property of the definition,
-- not of the function the definition computes.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT PROVOKED THIS
--
-- `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` states a criterion and
-- calls it mechanical:
--
--   "installed cognition reduces to `refl`; description needs a proof
--    from outside"
--
-- and its exhibit is `BhedaAvatarana.एकपदे : भेद (suc a)(suc b) ≡
-- गभीर (भेद a b)`, which is `refl`, where the same equation for a
-- `discreteℕ`-driven descent is not.  I read that note and this module
-- is what it made available.
--
-- The criterion is real and I am not disputing the exhibit — `एकपदे`
-- IS `refl`, I read the file (line 82–83).  What is proved here is where
-- the criterion lives.  It is a predicate on PRESENTATIONS, and no
-- invariant of the computed function can report it.  So it cannot be
-- checked by a type, and this is why `Jiva.agda` had to be read rather
-- than type-checked to establish that the lane is decisionless.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO PRESENTATIONS
--
--   peel  : ℕ → ℕ → ℕ     falls by structure, never asks
--   askℕ  : ℕ → ℕ → ℕ     `verdict (discreteℕ a b)`, asks once
--
-- `sameFunction : peel ≡ askℕ` (funext, twice).  They are one function.
-- `asks byStructure ≡ false`, `asks byDecision ≡ true`.  Hence the
-- collision, hence the obstruction.
--
-- ────────────────────────────────────────────────────────────────────
-- IN WHICH RESPECT EACH ASKS LESS — no ranking, both directions checked
--
-- `peel` asks less of the PROVER: its step law `peel (suc a)(suc b) ≡
-- peel a b` is `refl`.  This is the note's criterion, and it holds.
--
-- `ask` asks less of the AUTHOR: it is ONE definition, uniform in
-- `Discrete A`, and is instantiated below at both ℕ and Bool from the
-- same line.  `peel` is a case tree over ℕ's constructors and has to be
-- rewritten for every new carrier.  The step law `askℕ (suc a)(suc b) ≡
-- askℕ a b` is still available — `ask-step` proves it — but its proof
-- routes through `peel`, which is the honest form of the note's point:
-- not "the decided version lacks the law", but "the decided version's
-- law is a theorem where the structural version's is a reduction."
--
-- These two are incomparable.  A carrier with decidable equality and no
-- useful induction principle favours `ask`; an open term favours `peel`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- * NOT that `peel` and `askℕ` are the kuṭṭaka.  They are the smallest
--   pair that separates the two presentations; the kuṭṭaka's descent is
--   `BhedaAvatarana.भेद`, which returns a record, not a ℕ.
-- * NOT that the decisionless lane is thereby weakened.  `Anuvrtti`
--   already proved a presentation-level measure can carry information no
--   invariant of the denotation carries; that is the same shape as this,
--   and there it was the POINT, not a defect.  A property that does not
--   descend to the quotient is not a property that fails to exist.
-- * NOT that Agda can express "this equation does not hold by `refl`".
--   It cannot, and nothing below tries to.  `peel-step = refl` is
--   exhibited; the corresponding negative statement about `askℕ` is a
--   metatheoretic observation, stated as prose here and nowhere used.
-- * NO claim about the decisionless lane's Sanskrit vocabulary or its
--   sources.  This module cites `BhedaAvatarana` and the note, both of
--   which are files in this repository, and nothing older.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module AskingIsNotAPropertyOfTheFunction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  The decided presentation: one definition, every discrete carrier
------------------------------------------------------------------------

verdict : {A : Type ℓ} → Dec A → ℕ
verdict (yes _) = 0
verdict (no  _) = 1

ask : {A : Type ℓ} → Discrete A → A → A → ℕ
ask d x y = verdict (d x y)

askℕ : ℕ → ℕ → ℕ
askℕ = ask discreteℕ

-- the uniformity is exhibited, not asserted: the same `ask` at a second
-- carrier, with only its `Discrete` supplied.
discreteBool : Discrete Bool
discreteBool true  true  = yes refl
discreteBool false false = yes refl
discreteBool true  false = no true≢false
discreteBool false true  = no false≢true

askBool : Bool → Bool → ℕ
askBool = ask discreteBool

------------------------------------------------------------------------
-- 2.  The structural presentation: ℕ only, falls by constructors
------------------------------------------------------------------------

peel : ℕ → ℕ → ℕ
peel zero    zero    = 0
peel zero    (suc _) = 1
peel (suc _) zero    = 1
peel (suc a) (suc b) = peel a b

-- the note's criterion, at this pair: the step law is a reduction.
peel-step : (a b : ℕ) → peel (suc a) (suc b) ≡ peel a b
peel-step _ _ = refl

------------------------------------------------------------------------
-- 3.  They are the same function
------------------------------------------------------------------------

peel-diagonal : (a : ℕ) → peel a a ≡ 0
peel-diagonal zero    = refl
peel-diagonal (suc a) = peel-diagonal a

peel-off : (a b : ℕ) → ¬ (a ≡ b) → peel a b ≡ 1
peel-off zero    zero    ne = ⊥.rec (ne refl)
peel-off zero    (suc _) _  = refl
peel-off (suc _) zero    _  = refl
peel-off (suc a) (suc b) ne = peel-off a b (λ p → ne (cong suc p))

same : (a b : ℕ) → peel a b ≡ askℕ a b
same a b = go (discreteℕ a b)
  where
    go : (d : Dec (a ≡ b)) → peel a b ≡ verdict d
    go (yes p)  = subst (λ x → peel a x ≡ 0) p (peel-diagonal a)
    go (no  ¬p) = peel-off a b ¬p

sameFunction : peel ≡ askℕ
sameFunction = funExt (λ a → funExt (λ b → same a b))

-- the decided presentation's step law, available but derived
ask-step : (a b : ℕ) → askℕ (suc a) (suc b) ≡ askℕ a b
ask-step a b = sym (same (suc a) (suc b)) ∙ peel-step a b ∙ same a b

------------------------------------------------------------------------
-- 4.  Asking, as a predicate on presentations
------------------------------------------------------------------------

data Presentation : Type where
  byStructure : Presentation
  byDecision  : Presentation

run : Presentation → (ℕ → ℕ → ℕ)
run byStructure = peel
run byDecision  = askℕ

asks : Presentation → Bool
asks byStructure = false
asks byDecision  = true

------------------------------------------------------------------------
-- 5.  THE COLLISION, and the obstruction it forces
--
-- Isolated in the shape the corpus already uses, so that the general
-- lemma applies rather than a fresh argument being written.
------------------------------------------------------------------------

asking-collision :
  Σ[ p ∈ Presentation ] Σ[ q ∈ Presentation ]
    ((run p ≡ run q) × (¬ (asks p ≡ asks q)))
asking-collision = byStructure , byDecision , sameFunction , false≢true

-- routed through TranscriptDescent.collisionObstructsDecoder,
-- the same lemma that carries Laghava §3, Anuvrtti §4, CarryBorrowObservation
-- and OneLemmaFiveSites.
asking-does-not-factor-through-the-function :
  ¬ FactorsThrough run asks
asking-does-not-factor-through-the-function =
  collisionObstructsDecoder run asks {byStructure} {byDecision}
    sameFunction false≢true

-- the same statement in the elementary form, kept because it is the one
-- a reader can check without opening two other modules
no-invariant-of-the-function-reports-asking :
  ¬ (Σ[ f ∈ ((ℕ → ℕ → ℕ) → Bool) ]
       ((p : Presentation) → f (run p) ≡ asks p))
no-invariant-of-the-function-reports-asking (f , h) =
  false≢true (sym (h byStructure) ∙ cong f sameFunction ∙ h byDecision)

------------------------------------------------------------------------
-- 6.  The consequence for the decisionless discipline
--
-- `notes/DECISIONLESS_INDIC_CORPUS_INDEX.md` records that `Anekanta.agda`
-- "proclaimed 'no checking' yet used `discreteℕ`", was flagged, and was
-- kept out of the `Jiva` closure.  §5 says why that had to be caught by
-- reading and could not have been caught by the build: the closure
-- type-checks the functions, and asking is invisible to every invariant
-- of a function.
--
-- So the discipline is enforceable only at the site of the write — which
-- is exactly the conclusion `CLAUDE.md` reached for the Python ban, in
-- the same words: "enforced mechanically because prose failed", by a
-- hook, not by a paragraph.  A grep for `discreteℕ`, `Dec` and `Bool`
-- over a lane's own files is the check; a proof obligation cannot be.
--
-- I ran that grep rather than asserting it.  Over the eleven Lane-1
-- modules the index names, counting only lines that are not comments:
--
--   grep -n 'discreteℕ\|\bDec\b\|\bBool\b' M.agda | grep -v '^[0-9]*: *--'
--
--   BhedaAvatarana 0   LosslessReturn 0   Gati 0      Gurutama 0
--   GurutamaSiddha 0   Sthairya 0       Purnata 0   Bija 0
--   Yuti 0             Sadhyata 0
--   Anekanta 5         (lines 90, 227, 328, 361, 368 — the import and
--                       four `with discreteℕ`)
--
-- Every raw hit in the other ten is inside a comment: the modules discuss
-- the decision they do not take.  So the lane's own claim survives an
-- independent check, and the one module that fails it is the one already
-- flagged and already excluded from the closure.  That is the check
-- working — by grep, at the file, which is where §5 says it has to be.
------------------------------------------------------------------------
