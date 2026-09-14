{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Srotas — the hash is a truncation of one productive chain, the
-- chain forgets its past by refl, and the round layer is injective at
-- every depth.
--
-- स्रोतः — the stream.  The earlier decomposition of SHA-256 was
-- inductive through and through: Sthana inverted the sixty-four rounds
-- as a finite fold, Varga descended the hash to its classes, Sesa
-- completed it losslessly — every statement about a LIST of rounds or
-- blocks, every proof an induction.  This module redoes the
-- decomposition in the corpus's coinductive calculus — Dhārā
-- (Parasparasraya), the take-metric and its completeness
-- (HistoryCompletion §1, PurnataSutra), determinism as contractibility
-- of the run (Niyati) — where the primitive object is not the finite
-- computation but the endless one, and the finite hash is an
-- OBSERVATION of it.
--
-- THE ONE CONSTRUCTION.  For any step  s : S → A → S,  the chain
--     gati : S → Dhārā A → Dhārā S
-- unfolds the machine along an infinite input stream, by guarded
-- corecursion.  SHA-256 is this construction twice, at its two layers:
--
--     Āvalī  = gati roundStep   (the round layer: inputs are (Kt,Wt))
--     Khaṇḍa = gati compress    (the block layer: inputs are blocks)
--
-- WHAT IS PROVED, all checked terms, no postulates, no holes:
--
--   §2  स्मृति-मुक्तिः — the chain forgets its past BY REFL: the tail
--       of the chain from H is the chain from the stepped state, on
--       the nose.  At the block layer this is the Merkle–Damgård
--       length-extension property as a definitional equality: the
--       chaining value determines the entire future of the hash, and
--       everything SHA-256 ever loses, it loses into the PAST — the
--       fibre over the digest (infinite, by Parimana), never the
--       future.
--   §2  कर्तन-क्रमः / अन्त्य-गतिः — the depth-(length xs) truncation
--       of the chain IS the finite run, and its last entry IS the
--       fold.  Corollary अभिज्ञान-कर्तनम्: sha256ws m is literally a
--       truncation of the coinductive chain — the inductive hash is
--       one observation of the coinductive one, for every message and
--       every continuation of the input stream.
--   §2  कारणता — unit-speed causality in the take-metric: input
--       streams agreeing to depth n give chains agreeing to depth n.
--       The abstract-40 crossing profile ("every crossing 1-Lipschitz")
--       holds of SHA-256's own chaining, at both layers.
--   §3  एक-चरितम् — determinism is contractibility of the run
--       (Niyati's theorem, rebuilt for the open machine): the type of
--       productive executions of the chain from (H, inputs) is
--       contractible, by the same ∨-square that collapses a receipt
--       onto refl.  The hash has exactly one history forward.
--   §4  आवली-साक्षात् — the decomposition sharpened in the limit.  At
--       the ROUND layer a single truncation of positive depth, against
--       the same schedule, already determines the eight registers:
--       the round chain is injective at EVERY depth (by Sthana's
--       आवली-एकैकम् — the rounds are a permutation, so no depth loses
--       anything).  At the BLOCK layer no such theorem is possible
--       (Parimana: every fibre of the digest is infinite).  So the
--       loss keeps its one address in the limit: forward the chain is
--       deterministic and memoryless at both layers; backward the
--       round layer is exact at every depth and the block layer is
--       not — the difference is precisely the Davies–Meyer
--       feed-forward and the padding quotient, now stated about
--       infinite processes rather than finite folds.
--   §5  परीक्षा-स्रोतः — the receipt: the NIST vector for the empty
--       message replayed THROUGH THE STREAM — the head of the block
--       chain on the padded empty message is e3b0c442…7852b855, for
--       every continuation of the input, by the kernel computing.
--
-- Why this is stronger than the kernel-calculus reading: the
-- metacircular kernel analyses a finite derivation after the fact —
-- a walk that already ended.  The coinductive calculus holds the
-- WHOLE unfolding as one object: completeness (take-ext: the chain is
-- its truncations), causality (कारणता), and uniqueness of history
-- (एक-चरितम्) are statements no finite derivation can even type.
--
-- ŚEṢA.  A stream is the DEGENERATE case of an interaction — the one
-- where the environment has exactly one thing it can say
-- (Fibre.Samvada).  This module is therefore the trivial-query
-- fragment of the calculus; Sha256Samvada carries the hash into the
-- interactive coalgebra proper, and proves this module is its
-- demand-free collapse (एकाग्र-पातः there).
--
-- CHECKED: Agda 2.8.0, cubical v0.9 (the pin, via sh setup), --cubical
-- --safe, exit 0 — every theorem above including the computed NIST
-- receipt परीक्षा-स्रोतः.
------------------------------------------------------------------------

module Sha256Srotas_TheHashIsATruncationOfOneProductiveChainTheChainForgetsItsPastByReflAndTheRoundLayerIsInjectiveAtEveryDepth where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; map)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open Dhārā

open import HistoryCompletion_TheValueStreamOfATraceUnderAnEvaluatorCompletesByCorecursionItsLimitDescendsToTruncationsAndBoundednessDoesNot
  using (module Take)
open Take using (take ; take-ext)

open import Sha256
  using (Word ; word ; roundStep ; compress ; sha256ws ; pad ; blocks
        ; foldlL ; H0)
open import Sha256Sthana_TheSixtyFourRoundsAreAPermutationAndTheLossHasOneAddressTheFeedForward
  using (अष्टकम् ; आवली-एकैकम्)

------------------------------------------------------------------------
-- §1  Streams: cons and prepend (finite prefix onto an infinite rest).
------------------------------------------------------------------------

infixr 5 _∷ᵈ_

_∷ᵈ_ : {A : Type₀} → A → Dhārā A → Dhārā A
śiras (a ∷ᵈ r) = a
śeṣam (a ∷ᵈ r) = r

anvaya : {A : Type₀} → List A → Dhārā A → Dhārā A
anvaya []       r = r
anvaya (x ∷ xs) r = x ∷ᵈ anvaya xs r

------------------------------------------------------------------------
-- §2  The chain of any step function, and its calculus.
------------------------------------------------------------------------

module Yantra {S A : Type₀} (step : S → A → S) where

  -- THE CHAIN: unfold the machine along an infinite input stream.
  -- Guarded, hence total: nontermination of the hash's ambient process
  -- is a productive run of finite compressions, not a stuck definition.
  gati : S → Dhārā A → Dhārā S
  śiras (gati H xs) = step H (śiras xs)
  śeṣam (gati H xs) = gati (step H (śiras xs)) (śeṣam xs)

  -- The chain forgets its past BY REFL: the tail from H is the chain
  -- from the stepped state, definitionally.  The state is the whole
  -- memory; history enters the future only through it.
  स्मृति-मुक्तिः : (H : S) (xs : Dhārā A)
    → śeṣam (gati H xs) ≡ gati (step H (śiras xs)) (śeṣam xs)
  स्मृति-मुक्तिः H xs = refl

  -- the finite run: the list of successive states along a finite input
  krama : S → List A → List S
  krama H []       = []
  krama H (x ∷ xs) = step H x ∷ krama (step H x) xs

  -- last entry, with the start as default for the empty run
  antya : S → List S → S
  antya d []       = d
  antya d (x ∷ xs) = antya x xs

  -- TRUNCATION COMPUTES THE RUN: the depth-(length xs) truncation of
  -- the chain over (xs ++ anything) is exactly the finite run on xs.
  -- The inductive computation is an observation of the coinductive one.
  कर्तन-क्रमः : (H : S) (xs : List A) (r : Dhārā A)
    → take (length xs) (gati H (anvaya xs r)) ≡ krama H xs
  कर्तन-क्रमः H []       r = refl
  कर्तन-क्रमः H (x ∷ xs) r = cong (step H x ∷_) (कर्तन-क्रमः (step H x) xs r)

  -- and the run's last entry is the fold
  अन्त्य-गतिः : (H : S) (xs : List A)
    → antya H (krama H xs) ≡ foldlL step H xs
  अन्त्य-गतिः H []       = refl
  अन्त्य-गतिः H (x ∷ xs) = अन्त्य-गतिः (step H x) xs

  -- equal nonempty runs force equal folds (the last entries agree)
  क्रम-हरणम् : (x : A) (xs : List A) (s s′ : S)
    → krama s (x ∷ xs) ≡ krama s′ (x ∷ xs)
    → foldlL step s (x ∷ xs) ≡ foldlL step s′ (x ∷ xs)
  क्रम-हरणम् x []       s s′ q = cons-inj₁ q
  क्रम-हरणम् x (y ∷ ys) s s′ q =
    क्रम-हरणम् y ys (step s x) (step s′ x) (cons-inj₂ q)

  -- UNIT-SPEED CAUSALITY: inputs agreeing to depth n give chains
  -- agreeing to depth n — the chain is 1-Lipschitz in the take-metric,
  -- the crossing profile of abstract 40 at SHA-256's own step.
  कारणता : (n : ℕ) (H : S) (xs ys : Dhārā A)
    → take n xs ≡ take n ys
    → take n (gati H xs) ≡ take n (gati H ys)
  कारणता zero    H xs ys h = refl
  कारणता (suc n) H xs ys h =
    cong₂ _∷_ (cong (step H) p)
      ( cong (λ a → take n (gati (step H a) (śeṣam xs))) p
      ∙ कारणता n (step H (śiras ys)) (śeṣam xs) (śeṣam ys) (cons-inj₂ h))
    where p = cons-inj₁ h

  ----------------------------------------------------------------------
  -- §3  Determinism is contractibility of the run (Niyati, for the
  --     open machine: the environment feeds the inputs, the machine
  --     still has exactly one history forward).
  ----------------------------------------------------------------------

  record Carita (H : S) (xs : Dhārā A) : Type₀ where
    coinductive
    field
      now  : S
      here : now ≡ H
      next : Carita (step H (śiras xs)) (śeṣam xs)
  open Carita

  carita : (H : S) (xs : Dhārā A) → Carita H xs
  now  (carita H xs) = H
  here (carita H xs) = refl
  next (carita H xs) = carita (step H (śiras xs)) (śeṣam xs)

  एक-चरितम् : (H : S) (xs : Dhārā A) (e : Carita H xs) → carita H xs ≡ e
  now  (एक-चरितम् H xs e i) = here e (~ i)
  here (एक-चरितम् H xs e i) = λ j → here e (~ i ∨ j)
  next (एक-चरितम् H xs e i) = एक-चरितम् (step H (śiras xs)) (śeṣam xs) (next e) i

  -- THE THEOREM: one state, one input stream, one history — the space
  -- of productive executions of the chain is a point.
  ध्रुव-चरितम् : (H : S) (xs : Dhārā A) → isContr (Carita H xs)
  ध्रुव-चरितम् H xs = carita H xs , एक-चरितम् H xs

------------------------------------------------------------------------
-- §4  SHA-256's two layers, and the decomposition in the limit.
------------------------------------------------------------------------

module Āvalī  = Yantra {List Word} {Word × Word} roundStep
module Khaṇḍa = Yantra {List Word} {List Bool}   compress

-- THE ROUND LAYER IS INJECTIVE AT EVERY DEPTH.  One truncation of
-- positive depth, against the same finite schedule, determines the
-- eight registers: Sthana's permutation theorem, lifted to the chain.
-- No coinductive depth loses a bit at the round layer.
आवली-साक्षात् : (p : Word × Word) (ps : List (Word × Word))
    (st st′ : List Word) (r r′ : Dhārā (Word × Word))
  → take (length (p ∷ ps)) (Āvalī.gati st  (anvaya (p ∷ ps) r))
  ≡ take (length (p ∷ ps)) (Āvalī.gati st′ (anvaya (p ∷ ps) r′))
  → अष्टकम् st ≡ अष्टकम् st′
आवली-साक्षात् p ps st st′ r r′ q =
  आवली-एकैकम् (p ∷ ps) st st′
    (Āvalī.क्रम-हरणम् p ps st st′
      ( sym (Āvalī.कर्तन-क्रमः st (p ∷ ps) r)
      ∙ q
      ∙ Āvalī.कर्तन-क्रमः st′ (p ∷ ps) r′))

-- No analogue exists one storey up: at the block layer the same
-- statement is FALSE (Parimana — every fibre of the digest is
-- infinite; Sthana — the loss enters at the feed-forward inside
-- `compress` and the padding quotient before it).  What the block
-- layer keeps is the forward half of the calculus, and it keeps all
-- of it:

-- the digest determines the entire future of the chain — the
-- Merkle–Damgård length-extension property, coinductively: two
-- histories reaching the same chaining value have EQUAL futures,
-- as whole streams.
दीर्घीकरणम् : (H H′ : List Word) (bs : Dhārā (List Bool))
  → H ≡ H′ → Khaṇḍa.gati H bs ≡ Khaṇḍa.gati H′ bs
दीर्घीकरणम् H H′ bs h = cong (λ x → Khaṇḍa.gati x bs) h

-- the chain is its truncations (completeness descends to SHA-256):
-- all-depth agreement of two block chains is equality of the chains.
कर्तन-सर्वस्वम् : (H H′ : List Word) (xs ys : Dhārā (List Bool))
  → ((n : ℕ) → take n (Khaṇḍa.gati H xs) ≡ take n (Khaṇḍa.gati H′ ys))
  → Khaṇḍa.gati H xs ≡ Khaṇḍa.gati H′ ys
कर्तन-सर्वस्वम् H H′ xs ys = take-ext

-- THE HASH IS A TRUNCATION.  For every message and every continuation
-- of the input stream, sha256ws m is the last entry of a truncation of
-- the one productive chain from H0.
bls : List Bool → List (List Bool)
bls m = blocks (suc (length (pad m))) (pad m)

अभिज्ञान-कर्तनम् : (m : List Bool) (rest : Dhārā (List Bool))
  → sha256ws m
  ≡ Khaṇḍa.antya H0 (take (length (bls m)) (Khaṇḍa.gati H0 (anvaya (bls m) rest)))
अभिज्ञान-कर्तनम् m rest =
    sym (Khaṇḍa.अन्त्य-गतिः H0 (bls m))
  ∙ cong (Khaṇḍa.antya H0) (sym (Khaṇḍa.कर्तन-क्रमः H0 (bls m) rest))

------------------------------------------------------------------------
-- §5  The receipt: the NIST vector, through the stream.  The head of
--     the block chain on the padded empty message is the digest of the
--     empty message — for EVERY continuation of the input stream, by
--     the kernel computing the whole pipeline inside the coalgebra.
------------------------------------------------------------------------

परीक्षा-स्रोतः : (rest : Dhārā (List Bool))
  → śiras (Khaṇḍa.gati H0 (anvaya (bls []) rest)) ≡ map word
      ( 0xe3b0c442 ∷ 0x98fc1c14 ∷ 0x9afbf4c8 ∷ 0x996fb924
      ∷ 0x27ae41e4 ∷ 0x649b934c ∷ 0xa495991b ∷ 0x7852b855 ∷ [])
परीक्षा-स्रोतः rest = refl
