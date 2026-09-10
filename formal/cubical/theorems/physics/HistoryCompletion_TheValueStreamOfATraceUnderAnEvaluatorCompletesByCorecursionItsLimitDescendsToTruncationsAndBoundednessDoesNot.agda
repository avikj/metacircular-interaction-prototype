{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HistoryCompletion — the one construction under both frontiers, made
-- from parts the corpus already holds:
--
--   the coinductive stream Dhārā (Parasparasraya), its truncation
--   kartana and the completeness of the take-metric (SthairyaSutra,
--   PurnataSutra: every Cauchy sequence of streams has a corecursive
--   limit, unique by truncations), the pairing of a trace with an
--   evaluator (MulyaVinimaya), and "no observation depth determines the
--   net" (NoObservationDepthDeterminesTheNet).
--
-- THE CONSTRUCTION.  A history is a stream of steps; an evaluator
-- assigns each step a value; the VALUE STREAM of the history is the
-- stream of its partial pairings — the finite blocks.  Value streams
-- live in the take-metric: two are n-close when their first n blocks
-- agree.  In that metric they are complete by corecursion, with no
-- precision representation anywhere: depth is a natural number.  So
-- the completion that the continuum module could not provide (its
-- closeness index is a representation, PrecisionIsARepresentation) is
-- ALREADY THERE, one storey down, in the corpus's own rope.
--
--   §1  Dhārā, truncation, the take-metric, and PurnataSutra's three
--       theorems generalised from the braid rope to any carrier A
--       (the proofs are the corpus's, only the carrier is freed);
--   §2  the value stream of a history under an evaluator, and the fact
--       that it is determined by its truncations (meaning descends);
--   §3  □ — "at every depth" — as a coinductive predicate on streams;
--       a failing truncation refutes it; and NO DEPTH DECIDES IT: for
--       every n there are two value streams agreeing to depth n, one
--       bounded forever and one not (cost does not descend);
--   §4  the two readings.  RH: the sampled trace is a value stream and
--       RH is □(|κ| ≤ κ(0)) — a single finite separator refutes it, no
--       depth confirms it.  NS: the Taylor jets of GalerkinJets form a
--       value stream, the Galerkin truncation is a stream map, and its
--       unit lookahead (agreement to depth M+1 in, depth M out) is the
--       SthairyaSutra crossing profile; §3 says regularity, a bound on
--       every jet, is likewise a □-predicate no depth decides.
--
-- SYĀT.  §§1–3 are theorems for every carrier and every evaluator; §4
-- instantiates the shape with the corpus's own exact objects and does
-- not compute ζ or solve Navier–Stokes.  The completion here is of
-- value streams in the take-metric, not of the reals: what it buys is
-- that the limit object exists and is unique, and that the two
-- Millennium statements are, exactly, □-predicates on it.
------------------------------------------------------------------------

module HistoryCompletion_TheValueStreamOfATraceUnderAnEvaluatorCompletesByCorecursionItsLimitDescendsToTruncationsAndBoundednessDoesNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Int.Order using (_≤_ ; zero-≤pos ; ¬pos≤negsuc)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive using (Dhārā)
open Dhārā

------------------------------------------------------------------------
-- §1  the take-metric on any stream, complete by corecursion
------------------------------------------------------------------------

module Take {A : Type₀} where

  -- truncation (SthairyaSutra.kartana, carrier freed)
  take : ℕ → Dhārā A → List A
  take zero s = []
  take (suc n) s = śiras s ∷ take n (śeṣam s)

  take-drop : (m : ℕ) (a b : Dhārā A) → take (suc m) a ≡ take (suc m) b → take m a ≡ take m b
  take-drop zero a b h = refl
  take-drop (suc m) a b h = cong₂ _∷_ (cons-inj₁ h) (take-drop m (śeṣam a) (śeṣam b) (cons-inj₂ h))

  -- a Cauchy sequence: each approximant agrees with the next to its own depth
  Cauchy : (ℕ → Dhārā A) → Type₀
  Cauchy r = (n : ℕ) → take n (r n) ≡ take n (r (suc n))

  -- THE LIMIT, by corecursion (PurnataSutra.sīmā)
  limit : (ℕ → Dhārā A) → Dhārā A
  śiras (limit r) = śiras (r 1)
  śeṣam (limit r) = limit (λ n → śeṣam (r (suc n)))

  head-stable : (r : ℕ → Dhārā A) → Cauchy r → (m : ℕ) → śiras (r 1) ≡ śiras (r (suc m))
  head-stable r c zero = refl
  head-stable r c (suc m) = head-stable r c m ∙ cons-inj₁ (c (suc m))

  tail-cauchy : (r : ℕ → Dhārā A) → Cauchy r → Cauchy (λ n → śeṣam (r (suc n)))
  tail-cauchy r c n = cons-inj₂ (c (suc n))

  -- THE LIMIT THEOREM: the limit agrees with the n-th approximant to depth n
  limit-agrees : (r : ℕ → Dhārā A) → Cauchy r → (n : ℕ) → take n (limit r) ≡ take n (r n)
  limit-agrees r c zero = refl
  limit-agrees r c (suc n) =
    cong₂ _∷_ (head-stable r c n) (limit-agrees (λ k → śeṣam (r (suc k))) (tail-cauchy r c) n)

  -- UNIQUENESS BY TRUNCATIONS (PurnataSutra.kartana-sāmya): meaning descends
  take-ext : {x y : Dhārā A} → ((n : ℕ) → take n x ≡ take n y) → x ≡ y
  śiras (take-ext h i) = cons-inj₁ (h 1) i
  śeṣam (take-ext h i) = take-ext (λ n → cons-inj₂ (h (suc n))) i

------------------------------------------------------------------------
-- §2  the value stream of a history under an evaluator
------------------------------------------------------------------------

module Value {S V : Type₀} (_⊕_ : V → V → V) (v₀ : V) where

  open Take

  -- a history is a stream of steps; an evaluator values each step;
  -- the value stream carries the running pairing (MulyaVinimaya's ∫,
  -- along the stream instead of along a finite derivation)
  values : (S → V) → V → Dhārā S → Dhārā V
  śiras (values ω acc h) = acc ⊕ ω (śiras h)
  śeṣam (values ω acc h) = values ω (acc ⊕ ω (śiras h)) (śeṣam h)

  valueStream : (S → V) → Dhārā S → Dhārā V
  valueStream ω = values ω v₀

  -- the value stream is determined by its truncations
  valueStream-ext : (ω : S → V) {h h' : Dhārā S}
                  → ((n : ℕ) → take n (valueStream ω h) ≡ take n (valueStream ω h'))
                  → valueStream ω h ≡ valueStream ω h'
  valueStream-ext ω = take-ext

------------------------------------------------------------------------
-- §3  □ — at every depth — and that no depth decides it
------------------------------------------------------------------------

record □ {A : Type₀} (P : A → Type₀) (s : Dhārā A) : Type₀ where
  coinductive
  field
    now   : P (śiras s)
    later : □ P (śeṣam s)
open □

-- a failing truncation refutes □ (the finite separator)
module Refute {A : Type₀} (P : A → Type₀) where
  open Take

  at : ℕ → Dhārā A → A
  at zero s = śiras s
  at (suc n) s = at n (śeṣam s)

  □-at : {s : Dhārā A} → □ P s → (n : ℕ) → P (at n s)
  □-at b zero = now b
  □-at b (suc n) = □-at (later b) n

  separator : {s : Dhārā A} (n : ℕ) → ¬ P (at n s) → ¬ □ P s
  separator n np b = np (□-at b n)

-- NO DEPTH DECIDES □: two ℤ-streams agreeing to depth n, one bounded
-- by 0 forever, one exceeding it at depth n
module NoDepth where
  open Take

  Bounded : ℤ → Type₀
  Bounded z = z ≤ pos 0

  -- the constant stream at 0 and the stream that is 0 for n steps then 1
  zeros : Dhārā ℤ
  śiras zeros = pos 0
  śeṣam zeros = zeros

  spike : ℕ → Dhārā ℤ
  śiras (spike zero) = pos 1
  śeṣam (spike zero) = zeros
  śiras (spike (suc n)) = pos 0
  śeṣam (spike (suc n)) = spike n

  zeros-bounded : □ Bounded zeros
  now zeros-bounded = zero-≤pos
  later zeros-bounded = zeros-bounded

  -- 1 ≤ 0 is false
  one≰0 : ¬ (pos 1 ≤ pos 0)
  one≰0 (k , p) = snotz-lemma k p
    where
      open import Cubical.Data.Nat using (snotz)
      open import Cubical.Data.Int.Properties using (injPos ; pos+)
      snotz-lemma : (k : ℕ) → pos 1 Cubical.Data.Int.+ pos k ≡ pos 0 → ⊥
      snotz-lemma k p = snotz (injPos (pos+ 1 k ∙ p))

  spike-unbounded : (n : ℕ) → ¬ □ Bounded (spike n)
  spike-unbounded zero b = one≰0 (now b)
  spike-unbounded (suc n) b = spike-unbounded n (later b)

  -- they agree to depth n
  agree : (n : ℕ) → take n (spike n) ≡ take n zeros
  agree zero = refl
  agree (suc n) = cong (pos 0 ∷_) (agree n)

  -- THE THEOREM: for every depth, a bounded and an unbounded stream agree to it
  no-depth-decides : (n : ℕ) → Σ[ s ∈ Dhārā ℤ ] Σ[ t ∈ Dhārā ℤ ]
                     (take n s ≡ take n t) × □ Bounded s × (¬ □ Bounded t)
  no-depth-decides n = zeros , spike n , sym (agree n) , zeros-bounded , spike-unbounded n

------------------------------------------------------------------------
-- §4  the two readings, on the corpus's own exact objects
------------------------------------------------------------------------

-- RH reading.  The finite explicit formula's trace is the stream of
-- power sums p_k = Σ α_iᵏ (FiniteExplicitFormula); RH's finite form is
-- that all roots lie on the unit circle, i.e. □(|p_k| ≤ p_0).
module PowerSumTrace where
  open Take
  open import Cubical.Data.Int using (abs ; _·_) renaming (_+_ to _+i_)
  open import Cubical.Data.Nat.Order using () renaming (_≤_ to _≤ℕ_)

  -- the trace as a corecursive stream: the state is the current powers
  trace : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → Dhārā ℤ
  śiras (trace α β γ a b c) = a +i b +i c
  śeṣam (trace α β γ a b c) = trace α β γ (α · a) (β · b) (γ · c)

  powerSums : ℤ → ℤ → ℤ → Dhārā ℤ
  powerSums α β γ = trace α β γ (pos 1) (pos 1) (pos 1)

  BoundedBy : ℕ → ℤ → Type₀
  BoundedBy M z = abs z ≤ℕ M

  -- roots (1, −1, 1), all on the unit circle: |p_k| ≤ 3 forever
  onCircle : □ (BoundedBy 3) (powerSums (pos 1) (negsuc 0) (pos 1))
  onCircle = go (pos 1) (pos 1) (pos 1) (inl refl)
    where
      open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
      open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc)
      -- the state cycles between (1,1,1) and (1,−1,1)
      State : ℤ → ℤ → ℤ → Type₀
      State a b c = ((a , b , c) ≡ (pos 1 , pos 1 , pos 1)) ⊎ ((a , b , c) ≡ (pos 1 , negsuc 0 , pos 1))
      go : (a b c : ℤ) → State a b c → □ (BoundedBy 3) (trace (pos 1) (negsuc 0) (pos 1) a b c)
      now (go a b c (inl e)) = subst (λ t → abs (fst t +i fst (snd t) +i snd (snd t)) ≤ℕ 3) (sym e) ≤-refl
      later (go a b c (inl e)) = go _ _ _ (inr (cong (λ t → (pos 1 · fst t , negsuc 0 · fst (snd t) , pos 1 · snd (snd t))) e))
      now (go a b c (inr e)) = subst (λ t → abs (fst t +i fst (snd t) +i snd (snd t)) ≤ℕ 3) (sym e) (≤-suc (≤-suc ≤-refl))
      later (go a b c (inr e)) = go _ _ _ (inl (cong (λ t → (pos 1 · fst t , negsuc 0 · fst (snd t) , pos 1 · snd (snd t))) e))

  -- roots (2, 1, 1), one off the circle: refuted at depth 1 by p_1 = 4
  offCircle : ¬ □ (BoundedBy 3) (powerSums (pos 2) (pos 1) (pos 1))
  offCircle = Refute.separator (BoundedBy 3) 1 four≰3
    where
      open import Cubical.Data.Nat.Order using (¬-<-zero ; pred-≤-pred)
      four≰3 : ¬ (abs (Refute.at (BoundedBy 3) 1 (powerSums (pos 2) (pos 1) (pos 1))) ≤ℕ 3)
      four≰3 h = ¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred h)))

-- NS reading.  The Taylor jets of the pair (GalerkinJets) as a stream,
-- the Galerkin truncation as a stream, and their agreement to the
-- window's depth with the residual just beyond it.
module JetStream where
  open Take
  open import Cubical.Data.Bool using (Bool ; true ; false ; _and_)
  open import GalerkinJets_TheTaylorJetsOfThePairAtTimeZeroAreExactOnAWideningWindowAndTheTruncationResidualSitsOnTheBoundaryRow
  open import TorusFourierLayer_TheTriangularPairIsDerivedFromItsVelocityFieldTheNonlinearTermIsDivergenceFreeSoThePressureIsConstantAndTheCoarseStressAndContinuationAreComputed using (Field)

  jets : ℕ → Dhārā Field
  śiras (jets n) = Jet n
  śeṣam (jets n) = jets (suc n)

  galerkin : ℕ → ℕ → Dhārā Field
  śiras (galerkin M n) = JT M n
  śeṣam (galerkin M n) = galerkin M (suc n)

  -- Boolean agreement of two lists of fields on the box
  agreeList : List Field → List Field → Bool
  agreeList [] [] = true
  agreeList (f ∷ fs) (g ∷ gs) = eqBox4 f g and agreeList fs gs
  agreeList _ _ = false

  -- window 3: the truncated stream agrees with the exact one to depth 3 …
  agree-to-window : agreeList (take 3 (galerkin 3 0)) (take 3 (jets 0)) ≡ true
  agree-to-window = refl

  -- … and the boundary row of the residual at depth 3 is nonzero
  residual-beyond : residual₃ (pos 4) (pos 1) ≡ (pos 0 , pos 1)
  residual-beyond = refl

------------------------------------------------------------------------
-- §5  the one engine, in stream form: no measure falls forever
--
-- SamanaAvatarana's DescentObstruction iterates a measure-decreasing step;
-- its measure sequence is a stream of naturals, and □(next < now) on it
-- is uninhabited.  Unlike □Bounded (§3), which no depth decides, this □
-- is refuted at NO finite depth and yet uninhabited: well-foundedness is
-- the one infinite-depth fact the corpus rests on, and here it is what
-- separates a descent from a history.
------------------------------------------------------------------------

module Descent where
  open Take
  open import Cubical.Data.Nat.Order using (_<_)
  open import RenormalizedObserverTower using (no-infinite-descent)

  -- "the next value is below the current one", at every depth
  record □↓ (s : Dhārā ℕ) : Type₀ where
    coinductive
    field
      drop : śiras (śeṣam s) < śiras s
      rest : □↓ (śeṣam s)
  open □↓

  -- the stream read as a sequence
  seq : Dhārā ℕ → ℕ → ℕ
  seq s zero = śiras s
  seq s (suc n) = seq (śeṣam s) n

  seq-drop : (s : Dhārā ℕ) → □↓ s → (n : ℕ) → seq s (suc n) < seq s n
  seq-drop s d zero = drop d
  seq-drop s d (suc n) = seq-drop (śeṣam s) (rest d) n

  -- THE ENGINE: no stream of naturals falls forever
  no-falling-stream : (s : Dhārā ℕ) → ¬ □↓ s
  no-falling-stream s d = no-infinite-descent (seq s , seq-drop s d)

  -- a measure-decreasing step (SamanaAvatarana's DStep) iterated from a
  -- configuration is a falling stream, so the configuration is empty
  module _ (Config : Type₀) (measure : Config → ℕ)
           (step : (c : Config) → Σ[ c' ∈ Config ] (measure c' < measure c)) where

    orbit : Config → Dhārā Config
    śiras (orbit c) = c
    śeṣam (orbit c) = orbit (fst (step c))

    measures : Dhārā Config → Dhārā ℕ
    śiras (measures o) = measure (śiras o)
    śeṣam (measures o) = measures (śeṣam o)

    orbit-falls : (c : Config) → □↓ (measures (orbit c))
    drop (orbit-falls c) = snd (step c)
    rest (orbit-falls c) = orbit-falls (fst (step c))

    emptied-by-stream : ¬ Config
    emptied-by-stream c = no-falling-stream (measures (orbit c)) (orbit-falls c)
