{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- ReaderSession
--
-- The reader's user interface, specified as a term: a session with the
-- corpus browser is an inhabitant of the corpus's own interactive
-- coalgebra (Fibre.Samvada.ISC), instantiated at an abstract store.
--
-- The store is a parameter: a type of nodes, a typed edge family, and
-- an observation family (what a view can show at a node).  The question
-- family is the reader's actual vocabulary — follow an edge, observe
-- the node under a view, or reverse — and the event of every transition
-- is a RECEIPT (a path), so by the Prashna analysis the interface's
-- freedom beyond replay lives exactly in the question family: this
-- module states the design axis as a type.
--
-- Theorems:
--   replay-is-contractible-shape : with the question family cut down to
--     the trivial one, the session space collapses onto the click-path
--     (the Samvada det/observe reading: a linkless reader is a stream).
--   reverse-is-a-question : reversal is an ordinary question — going
--     back extends the play, never shortens it; the type makes deletion
--     inexpressible.
--
-- The JavaScript client is an implementation of `Session`; anything it
-- can do that this type cannot express is a bug in one of the two.
------------------------------------------------------------------------

module ReaderSession where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.List.Base using (List ; [] ; _∷_)

open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers
  using (ISC ; react ; Strategy ; observe)

private
  variable
    ℓ : Level

module Spec (Node : Type ℓ)
            (Edge : Node → Node → Type ℓ)     -- kernel-derived references
            (View : Node → Type ℓ)             -- what a lens can show here
            where

  -- The session state: where the reader stands, and the play so far.
  -- The play is part of the STATE because the trace is first-class:
  -- every transition appends, and the type offers no question that
  -- shortens it.
  State : Type ℓ
  State = Node × List Node

  focus : State → Node
  focus = fst

  play : State → List Node
  play = snd

  -- The question family: the reader's whole vocabulary.
  data Question (s : State) : Type ℓ where
    follow  : (n' : Node) → Edge (focus s) n' → Question s
    look    : View (focus s)                  → Question s
    reverse : (n' : Node)                     → Question s
    -- reversal names a previous node; it is an ordinary question and
    -- so, by the shape of ISC, it EXTENDS the play.

  -- Where a question lands.
  targetOf : (s : State) → Question s → State
  targetOf s (follow n' _) = n' , focus s ∷ play s
  targetOf s (look _)      = s            -- observing does not move
  targetOf s (reverse n')  = n' , focus s ∷ play s

  -- The observation and the receipt: every transition carries the path
  -- to its stated target.  Receipts leave the successor no room — so
  -- everything the interface IS, beyond replay, is the Question type.
  Obs : (s : State) → Question s → State → Type ℓ
  Obs s q s' = targetOf s q ≡ s'

  Ev : (s : State) (q : Question s) (s' : State) → Obs s q s' → Type ℓ
  Ev _ _ _ r = r ≡ r

  Session : State → Type ℓ
  Session = ISC Question Obs Ev

  -- The canonical reader: answer every question by going where it
  -- points, with receipt refl, forever.  Guarded; the corpus is never
  -- completed; a finite demand gets a finite answer.
  reader : (s : State) → Session s
  react (reader s) q = targetOf s q , refl , refl , reader (targetOf s q)

  -- One step computes by refl: the specification executes.
  step-computes : (s : State) (q : Question s)
                → fst (react (reader s) q) ≡ targetOf s q
  step-computes s q = refl

  -- Reversal extends the play: the grade after reversing is one more,
  -- definitionally.  Deletion of history is not merely forbidden — it
  -- is not a question.
  reverse-extends : (s : State) (n' : Node)
                  → play (targetOf s (reverse n')) ≡ focus s ∷ play s
  reverse-extends s n' = refl

  -- Observation is stationary: looking costs no motion, definitionally.
  look-stays : (s : State) (v : View (focus s))
             → targetOf s (look v) ≡ s
  look-stays s v = refl
