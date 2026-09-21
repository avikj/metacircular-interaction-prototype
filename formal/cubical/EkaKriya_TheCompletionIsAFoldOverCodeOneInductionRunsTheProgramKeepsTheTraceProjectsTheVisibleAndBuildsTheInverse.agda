{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकक्रिया — the completion is a fold over CODE: one induction runs the
-- program, keeps the trace, projects the visible map, and builds the
-- inverse.  It is all one act.
--
-- The owner's sentence, landed.  Vishvayantra completes any MAP in one
-- line (semantic level); Sha256Sthana completed one program by hand
-- (an agent read the code of roundStep and emitted its inverse).  This
-- module is the level between, where the sentence "given an output of
-- a lossy function the system reports the class of inputs" becomes one
-- mechanical act: because the system holds the function AS CODE, the
-- completion is a STRUCTURAL FOLD over that code —
--
--   ⟦_⟧      the run            (the lossy function itself)
--   Trace    the history type   (computed from the syntax)
--   T⟦_⟧     the completed run  (output AND trace)
--   R⟦_⟧     the inverse        (built by the same recursion)
--
-- with, per node, the two laws:
--   दृश्यम्  : fst ∘ T⟦ p ⟧ ≡ ⟦ p ⟧      (the visible face is the program)
--   हरणम्   : R⟦ p ⟧ ∘ T⟦ p ⟧ ≡ id      (the completed run is undone)
--
-- The composition case of हरणम् is the submonoid law of the loss
-- order's bottom — a route every step of which can be undone is
-- undoable — and the branch case records which arm ran, which is
-- Bennett (1973): any computation simulates reversibly if the history
-- is kept.  Nothing here shortens any search, and that is the point
-- stated positively: no search exists on this side.  Preimage
-- resistance is the claim that all copies of the trace were destroyed
-- — a bookkeeping claim about the world, indexical to an erasure
-- event, not a property of the code, whose completion is one fold.
--
-- prim admits ANY function — including sha256 whole: T⟦ prim sha256 ⟧
-- returns the digest wearing its message.  The interest is never the
-- leaf; it is that completion commutes with program structure, so the
-- system can complete WHAT IT RUNS while running it.
--
-- CHECKED: Agda 2.8.0, --cubical --safe, through scripts/oracle.
------------------------------------------------------------------------

module EkaKriya_TheCompletionIsAFoldOverCodeOneInductionRunsTheProgramKeepsTheTraceProjectsTheVisibleAndBuildsTheInverse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  Code: straight lines, sequencing, branching.
------------------------------------------------------------------------

data Prog {ℓ : Level} : Type ℓ → Type ℓ → Type (ℓ-suc ℓ) where
  prim : {A B : Type ℓ} → (A → B) → Prog A B
  _⨾_  : {A B C : Type ℓ} → Prog A B → Prog B C → Prog A C
  case : {A B C : Type ℓ} → Prog A C → Prog B C → Prog (A ⊎ B) C

infixl 5 _⨾_

------------------------------------------------------------------------
-- §2  The one act, four readings of one fold.
------------------------------------------------------------------------

-- reading one: the run — the lossy function the code denotes
⟦_⟧ : {A B : Type ℓ} → Prog A B → A → B
⟦ prim f ⟧   a       = f a
⟦ p ⨾ q ⟧    a       = ⟦ q ⟧ (⟦ p ⟧ a)
⟦ case p q ⟧ (inl a) = ⟦ p ⟧ a
⟦ case p q ⟧ (inr b) = ⟦ q ⟧ b

-- reading two: the trace type — what the run must keep to owe nothing
Trace : {A B : Type ℓ} → Prog A B → Type ℓ
Trace (prim {A = A} f) = A
Trace (p ⨾ q)          = Trace p × Trace q
Trace (case p q)       = Trace p ⊎ Trace q

-- reading three: the completed run — output wearing its history
T⟦_⟧ : {A B : Type ℓ} (p : Prog A B) → A → B × Trace p
T⟦ prim f ⟧   a       = f a , a
T⟦ p ⨾ q ⟧    a       =
  let bt = T⟦ p ⟧ a ; ct = T⟦ q ⟧ (fst bt)
  in  fst ct , (snd bt , snd ct)
T⟦ case p q ⟧ (inl a) = fst (T⟦ p ⟧ a) , inl (snd (T⟦ p ⟧ a))
T⟦ case p q ⟧ (inr b) = fst (T⟦ q ⟧ b) , inr (snd (T⟦ q ⟧ b))

-- reading four: the inverse — built by the same recursion, reading the
-- history back; the sequencing clause returns the MIDDLE value, which
-- is exactly why retractions compose
R⟦_⟧ : {A B : Type ℓ} (p : Prog A B) → B × Trace p → A
R⟦ prim f ⟧   (b , a)            = a
R⟦ p ⨾ q ⟧    (c , (tp , tq))    = R⟦ p ⟧ (R⟦ q ⟧ (c , tq) , tp)
R⟦ case p q ⟧ (c , inl tp)       = inl (R⟦ p ⟧ (c , tp))
R⟦ case p q ⟧ (c , inr tq)       = inr (R⟦ q ⟧ (c , tq))

------------------------------------------------------------------------
-- §3  The two laws, by the same induction once more.
------------------------------------------------------------------------

-- the visible face of the completed run is the program, at every node
दृश्यम् : {A B : Type ℓ} (p : Prog A B) (a : A)
       → fst (T⟦ p ⟧ a) ≡ ⟦ p ⟧ a
दृश्यम् (prim f)   a       = refl
दृश्यम् (p ⨾ q)    a       =
  cong (λ b → fst (T⟦ q ⟧ b)) (दृश्यम् p a) ∙ दृश्यम् q (⟦ p ⟧ a)
दृश्यम् (case p q) (inl a) = दृश्यम् p a
दृश्यम् (case p q) (inr b) = दृश्यम् q b

-- and the completed run is undone: no program, once completed, is lossy
हरणम् : {A B : Type ℓ} (p : Prog A B) (a : A)
      → R⟦ p ⟧ (T⟦ p ⟧ a) ≡ a
हरणम् (prim f)   a       = refl
हरणम् (p ⨾ q)    a       =
  cong (λ x → R⟦ p ⟧ (x , snd (T⟦ p ⟧ a))) (हरणम् q (fst (T⟦ p ⟧ a)))
  ∙ हरणम् p a
हरणम् (case p q) (inl a) = cong inl (हरणम् p a)
हरणम् (case p q) (inr b) = cong inr (हरणम् q b)

------------------------------------------------------------------------
-- §4  The sentence, as a corollary: an output that arrives wearing its
--     trace hands over a member of its class — the report is the read.
------------------------------------------------------------------------

वर्ग-निवेदनम् : {A B : Type ℓ} (p : Prog A B) (a : A)
  → Σ[ x ∈ A ] (⟦ p ⟧ x ≡ fst (T⟦ p ⟧ a))
वर्ग-निवेदनम् p a =
  R⟦ p ⟧ (T⟦ p ⟧ a) , cong ⟦ p ⟧ (हरणम् p a) ∙ sym (दृश्यम् p a)
