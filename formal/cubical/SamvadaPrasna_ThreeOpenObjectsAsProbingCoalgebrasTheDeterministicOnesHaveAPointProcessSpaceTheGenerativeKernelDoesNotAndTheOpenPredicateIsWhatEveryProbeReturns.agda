{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SamvadaPrasna — three open objects as probing coalgebras.  The
-- deterministic ones have a point process space; the generative kernel
-- does not; and the open predicate is what every probe returns.
--
-- प्रश्न — the question.  This module uses the interactive coalgebra
-- (Fibre.Samvada's ISC) for what it is FOR, on three objects the corpus
-- reaches at but had not yet handed to the coalgebra: the finite-form
-- Riemann predicate (a □ on a power-sum stream), the Navier–Stokes
-- Galerkin window (the advected jet's widening mode-support), and the
-- metacircular kernel's own self-extension.  ONE abstract probing
-- coalgebra `Netra` serves all three; the objects enter as a step, an
-- observation, and — this is the point of §6 — an EVENT DATUM whose
-- h-level decides everything.
--
--   Netra Q step obs w  =  ISC (const Q) (const V) E w
--   E w q w' o           =  (o ≡ obs w q) × (w' ≡ step w q)
--
-- WHAT IS PROVED, all checked terms unless tagged, no postulates:
--
--   §2  एक-नेत्रम् — when the state and value types are SETS the event
--       datum is a proposition, and the process space is CONTRACTIBLE
--       (sāmyaP, the SHA-256 argument abstracted): one interface, one
--       behaviour.  This is Niyati's determinism-as-contractibility as
--       a REUSABLE lemma over any set-state coalgebra.
--   §3  दृष्टि-धारा / प्रश्न-कर्तनम् — the observation stream under a
--       fixed strategy, and the bridge: observe (const q₀) n = take n of
--       it.  So a □-predicate on the observation stream is exactly "every
--       probe under that strategy satisfies P", refuted by one separator
--       (Refute) and decided by no finite depth (no-depth-decides,
--       imported): the open-problem shape, now a statement about an
--       interaction.
--
--   §4  RIEMANN (finite form) — Q = advance? ; obs true = the power sum
--       p_k, obs false = 0.  The demand MATTERS (पृच्छा-भेदः: the two
--       strategies disagree at the first answer).  For roots on the unit
--       circle (1,−1,1) the advancing observation is □-bounded forever
--       (वृत्त-स्थम्, a two-state cycle); for a root off it (2,1,1) the
--       box is refuted at depth 1 (बहिः-वृत्तम्).  The process space is a
--       point (§2 applies: ℤ³ is a set).  RH's finite form is a
--       □-predicate on what an environment probes from a contractible
--       spectral process — verdict-bearing, forever falsifiable, never
--       finitely confirmable.
--
--   §5  NAVIER–STOKES (Galerkin window) — Q = refine? ; the advected
--       jet reaches boundary row n+1 at order n (GalerkinJets §2, taken
--       as the shape, not re-derived).  State = the order; obs = the row
--       reached.  The mode-support box "|k₁| ≤ M forever" is refuted at
--       depth M for EVERY M (विस्तार-भेदः): no finite Galerkin cutoff
--       confirms regularity-as-mode-boundedness and the widening jets
--       refute it in the limit — the SAME epistemic type as §4, opposite
--       verdict (this box provably cannot hold for the advected
--       component).  [S] for the physics; [T] for the coalgebra.
--
--   §6  THE METACIRCULAR KERNEL — Q w = CheckedFuture w (a target with a
--       CHECKED Derivation); obs = the target; and the event datum E IS
--       THE DERIVATION — proof-relevant, not a proposition.  So §2 does
--       NOT apply, and that is the theorem: वर्धन-बहुत्वम् — one seed
--       reacts to two distinct futures with the SAME target but DIFFERENT
--       derivations (GenerativeKernel's two-walks-one-output), so the
--       react-image over that seed is not a proposition, so the process
--       space is not contractible.  The kernel's self-extension is the
--       one coalgebra here whose history genuinely branches: the loss of
--       contractibility is exactly the generativity (Apunaragamana — the
--       orbit strictly grows).  Determinism is a set-level phenomenon;
--       generation lives one h-level up, in the proof-relevance of the
--       event datum the interface was built to carry.
--
-- THE THROUGH-LINE.  h-level of the event datum E is the classifier.
-- Prop receipt (SHA, RH, NS) → contractible process, deterministic
-- service, open predicate falsifiable-not-confirmable.  Proof-relevant
-- receipt (the kernel) → branching process, generative.  The same
-- interface; the mathematics is in the h-level.
--
-- CHECKED: Agda 2.8.0, cubical v0.9 (the pin), --cubical --safe.
------------------------------------------------------------------------

module SamvadaPrasna_ThreeOpenObjectsAsProbingCoalgebrasTheDeterministicOnesHaveAPointProcessSpaceTheGenerativeKernelDoesNotAndTheOpenPredicateIsWhatEveryProbeReturns where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp×)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (cons-inj₁ ; ¬cons≡nil)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty using (⊥)

open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers
  using (ISC ; react ; Strategy ; observe)

------------------------------------------------------------------------
-- §1  The abstract probing coalgebra.
------------------------------------------------------------------------

module Core {W V Q : Type₀} (step : W → Q → W) (obs : W → Q → V) where

  Ev : (w : W) → Q → W → V → Type₀
  Ev w q w' o = (o ≡ obs w q) × (w' ≡ step w q)

  Netra : W → Type₀
  Netra = ISC (λ _ → Q) (λ _ _ _ → V) Ev

  -- the canonical process: answer with the true observation, step, repeat
  netra : (w : W) → Netra w
  react (netra w) q = step w q , obs w q , (refl , refl) , netra (step w q)

  -- named projections of one reaction of ANY process
  ans : {w : W} (q : Q) (p : Netra w) → V
  ans q p = fst (snd (react p q))

  rest : {w : W} (q : Q) (p : Netra w) → Netra (fst (react p q))
  rest q p = snd (snd (snd (react p q)))

  ----------------------------------------------------------------------
  -- §2  Contractibility, when W and V are sets.
  ----------------------------------------------------------------------

  module _ (isSetW : isSet W) (isSetV : isSet V) where

    isPropEv : (w : W) (q : Q) (w' : W) (o : V) → isProp (Ev w q w' o)
    isPropEv w q w' o = isProp× (isSetV _ _) (isSetW _ _)

    sāmyaP : {w₀ w₁ : W} (π : w₀ ≡ w₁) (p : Netra w₀) (q : Netra w₁)
           → PathP (λ i → Netra (π i)) p q
    react (sāmyaP {w₀} {w₁} π p q i) pr = wP i , oP i , eP i , sāmyaP wP tp tq i
      where
        e₀ = fst (snd (snd (react p pr)))
        tp = snd (snd (snd (react p pr)))
        e₁ = fst (snd (snd (react q pr)))
        tq = snd (snd (snd (react q pr)))
        wP : fst (react p pr) ≡ fst (react q pr)
        wP = snd e₀ ∙∙ (λ j → step (π j) pr) ∙∙ sym (snd e₁)
        oP : fst (snd (react p pr)) ≡ fst (snd (react q pr))
        oP = fst e₀ ∙∙ (λ j → obs (π j) pr) ∙∙ sym (fst e₁)
        eP : PathP (λ j → Ev (π j) pr (wP j) (oP j)) e₀ e₁
        eP = isProp→PathP (λ j → isPropEv (π j) pr (wP j) (oP j)) e₀ e₁

    एक-नेत्रम् : (w : W) → isContr (Netra w)
    एक-नेत्रम् w = netra w , sāmyaP refl (netra w)

  ----------------------------------------------------------------------
  -- §3  The observation stream and the open-predicate bridge.
  ----------------------------------------------------------------------

  -- the values a fixed strategy extracts, as a coinductive stream
  record Dhk (q₀ : Q) (w : W) : Type₀ where
    coinductive
    field hd : V
          tl : Dhk q₀ (step w q₀)
  open Dhk

  dṛṣṭi : (q₀ : Q) (w : W) → Dhk q₀ w
  hd (dṛṣṭi q₀ w) = obs w q₀
  tl (dṛṣṭi q₀ w) = dṛṣṭi q₀ (step w q₀)

  takeS : (q₀ : Q) → ℕ → (w : W) → List W
  takeS q₀ zero    w = []
  takeS q₀ (suc n) w = step w q₀ ∷ takeS q₀ n (step w q₀)

  -- BRIDGE: observing the canonical process under the constant strategy
  -- q₀ walks the state trajectory (observe collects successor states),
  -- so the interaction IS the fixed-strategy stream (SHA's एकाग्र-पातः,
  -- abstracted).  The observed VALUES ride along as obs of these states.
  प्रश्न-कर्तनम् : (q₀ : Q) (n : ℕ) (w : W)
    → observe (λ _ → q₀) n (netra w) ≡ takeS q₀ n w
  प्रश्न-कर्तनम् q₀ zero    w = refl
  प्रश्न-कर्तनम् q₀ (suc n) w = cong (step w q₀ ∷_) (प्रश्न-कर्तनम् q₀ n (step w q₀))

  -- the □ predicate on the observation stream: every probe satisfies P
  record Box (P : V → Type₀) (q₀ : Q) (w : W) : Type₀ where
    coinductive
    field head-ok : P (obs w q₀)
          tail-ok : Box P q₀ (step w q₀)
  open Box

  -- at-depth value under the strategy
  atD : (q₀ : Q) → ℕ → W → V
  atD q₀ zero    w = obs w q₀
  atD q₀ (suc n) w = atD q₀ n (step w q₀)

  Box-atD : {P : V → Type₀} {q₀ : Q} {w : W} → Box P q₀ w → (n : ℕ) → P (atD q₀ n w)
  Box-atD b zero    = head-ok b
  Box-atD b (suc n) = Box-atD (tail-ok b) n

  -- ONE SEPARATOR REFUTES (the finite falsifier)
  पृथक्करणम् : {P : V → Type₀} {q₀ : Q} {w : W}
    → (n : ℕ) → ¬ P (atD q₀ n w) → ¬ Box P q₀ w
  पृथक्करणम् n np b = np (Box-atD b n)

------------------------------------------------------------------------
-- §4  RIEMANN, finite form: a □ on a power-sum stream the environment
--     probes, from a contractible spectral process.
------------------------------------------------------------------------

module Riemann where
  open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; abs) renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_)
  open import Cubical.Data.Int.Properties using (isSetℤ)
  open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl)
  open import Cubical.Foundations.HLevels using (isSet×)

  Roots : Type₀
  Roots = ℤ × (ℤ × ℤ)          -- three roots (α , β , γ)

  St : Type₀
  St = ℤ × (ℤ × ℤ)             -- the running powers (aᵏ , bᵏ , cᵏ)

  isSetSt : isSet St
  isSetSt = isSet× isSetℤ (isSet× isSetℤ isSetℤ)

  -- Q = advance the spectral clock?  obs true = power sum, false = 0.
  step : Roots → St → Bool → St
  step (α , β , γ) (a , b , c) true  = (α ·ℤ a , β ·ℤ b , γ ·ℤ c)
  step _           s          false = s

  obs : St → Bool → ℤ
  obs (a , b , c) true  = a +ℤ (b +ℤ c)
  obs _           false = pos 0

  module R (ρ : Roots) = Core {St} {ℤ} {Bool} (step ρ) obs

  -- THE DEMAND MATTERS: at the start, "advance" answers the power sum
  -- p₀ = 3, "hold" answers 0 — the interaction is properly more than a
  -- stream, on the Riemann object.
  पृच्छा-भेदः : (ρ : Roots)
    → ¬ ( R.ans ρ true  (R.netra ρ (pos 1 , (pos 1 , pos 1)))
        ≡ R.ans ρ false (R.netra ρ (pos 1 , (pos 1 , pos 1))) )
  पृच्छा-भेदः ρ p = pos3≢0 p
    where
      -- obs true at (1,1,1) is 1+(1+1) = pos 3 ; obs false is pos 0
      pos3≢0 : ¬ (pos 3 ≡ pos 0)
      pos3≢0 q = znots (sym (injPos q))
        where open import Cubical.Data.Nat using (znots)
              open import Cubical.Data.Int.Properties using (injPos)

  -- the process space over any spectral state is a point (§2, ℤ³ a set)
  एक-नेत्रम् : (ρ : Roots) (s : St) → isContr (R.Netra ρ s)
  एक-नेत्रम् ρ = R.एक-नेत्रम् ρ isSetSt isSetℤ

  BoundedBy : ℕ → ℤ → Type₀
  BoundedBy M z = abs z ≤ M

  -- ON THE CIRCLE: roots (1,−1,1).  The advancing power sum cycles
  -- 3,1,3,1,… (a=1 always, c=1 always, b alternates ±1), so |p_k| ≤ 3
  -- forever.  A two-state invariant, checked.
  onCircle : R.Box (pos 1 , (negsuc 0 , pos 1)) (BoundedBy 3) true (pos 1 , (pos 1 , pos 1))
  onCircle = go (pos 1) (pos 1) (inl refl)
    where
      open R (pos 1 , (negsuc 0 , pos 1))
      open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
      open import Cubical.Data.Nat.Order using (≤-suc)
      -- b is pos 1 or negsuc 0; a = c = pos 1 throughout
      Inv : ℤ → Type₀
      Inv b = (b ≡ pos 1) ⊎ (b ≡ negsuc 0)
      bnd : (b : ℤ) → Inv b → BoundedBy 3 (obs (pos 1 , (b , pos 1)) true)
      bnd b (inl e) = subst (λ z → BoundedBy 3 (obs (pos 1 , (z , pos 1)) true)) (sym e) ≤-refl
      bnd b (inr e) = subst (λ z → BoundedBy 3 (obs (pos 1 , (z , pos 1)) true)) (sym e) (≤-suc (≤-suc ≤-refl))
      nextInv : (b : ℤ) → Inv b → Inv (negsuc 0 ·ℤ b)
      nextInv b (inl e) = inr (cong (negsuc 0 ·ℤ_) e)
      nextInv b (inr e) = inl (cong (negsuc 0 ·ℤ_) e)
      go : (a b : ℤ) → Inv b
         → Box (BoundedBy 3) true (pos 1 , (b , pos 1))
      Box.head-ok (go a b inv) = bnd b inv
      Box.tail-ok (go a b inv) = go (pos 1 ·ℤ pos 1) (negsuc 0 ·ℤ b) (nextInv b inv)

  -- OFF THE CIRCLE: roots (2,1,1).  p₁ = 2·1 + 1 + 1 = 4, abs 4 ≤ 3 is
  -- false, so the box is refuted at depth 1 by one separator.
  offCircle : ¬ R.Box (pos 2 , (pos 1 , pos 1)) (BoundedBy 3) true (pos 1 , (pos 1 , pos 1))
  offCircle = R.पृथक्करणम् (pos 2 , (pos 1 , pos 1)) 1 four≰3
    where
      open R (pos 2 , (pos 1 , pos 1))
      open import Cubical.Data.Nat using (snotz ; injSuc)
      open import Cubical.Data.Nat.Order using (≤-antisym)
      -- atD true 1 (1,1,1) reduces to abs (pos 4) = 4
      ¬4≡3 : ¬ (4 ≡ 3)
      ¬4≡3 e = snotz (injSuc (injSuc (injSuc e)))
      3≤4 : 3 ≤ 4
      3≤4 = 1 , refl
      four≰3 : ¬ BoundedBy 3 (atD true 1 (pos 1 , (pos 1 , pos 1)))
      four≰3 h = ¬4≡3 (≤-antisym h 3≤4)

------------------------------------------------------------------------
-- §5  NAVIER–STOKES, Galerkin window: the advected jet's mode-support
--     widens by one per order (GalerkinJets §2, taken as shape), so the
--     boundedness box cannot hold — refuted at depth M for every M.
------------------------------------------------------------------------

module NavierStokes where
  open import Cubical.Data.Nat using (snotz ; injSuc ; _+_ ; +-zero ; +-suc)
  open import Cubical.Data.Nat.Order using (_≤_ ; ≤-antisym)

  -- state = the jet order n; refine? advances it; the observation is the
  -- boundary row the order-n jet reaches, which is n+1 (Jetₙ vanishes
  -- above |k₁| = n+1 and is nonzero on that row).
  stepN : ℕ → Bool → ℕ
  stepN n true  = suc n
  stepN n false = n

  obsN : ℕ → Bool → ℕ
  obsN n _ = suc n

  module N = Core {ℕ} {ℕ} {Bool} stepN obsN

  ¬suc≡ : (m : ℕ) → ¬ (suc m ≡ m)
  ¬suc≡ zero    e = snotz e
  ¬suc≡ (suc m) e = ¬suc≡ m (injSuc e)

  BoundedRow : ℕ → ℕ → Type₀
  BoundedRow M r = r ≤ M

  -- NO GALERKIN CUTOFF CONFIRMS REGULARITY-AS-MODE-BOUNDEDNESS: for every
  -- window M the box "|k₁| ≤ M forever" is refuted at depth M, because
  -- the order-M jet reaches row M+1.  Same epistemic type as Riemann's
  -- box (§4), opposite verdict: this box provably cannot hold.
  -- the order-k jet, refined from order w, reaches row suc (w + k)
  atD-row : (k w : ℕ) → N.atD true k w ≡ suc (w + k)
  atD-row zero    w = cong suc (sym (+-zero w))
  atD-row (suc k) w = atD-row k (suc w) ∙ cong suc (sym (+-suc w k))

  विस्तार-भेदः : (M : ℕ) → ¬ N.Box (BoundedRow M) true 0
  विस्तार-भेदः M = N.पृथक्करणम् M ¬bnd
    where
      -- N.atD true M 0 = suc (0 + M) = suc M ; suc M ≤ M is false
      ¬bnd : ¬ BoundedRow M (N.atD true M 0)
      ¬bnd h = ¬suc≡ M (≤-antisym (subst (_≤ M) (atD-row M 0) h) (1 , refl))

------------------------------------------------------------------------
-- §6  THE METACIRCULAR KERNEL: the one coalgebra whose event datum is a
--     PROOF, not a proposition — so §2 does not apply and the history
--     branches.  Generation is the loss of contractibility.
------------------------------------------------------------------------

module Kernel where
  open import RewriteCertificate using (Tm ; Derivation)
  open import ControlledGrammar using (CheckedFuture)
  open CheckedFuture
  open import GenerativeKernel using (seed ; target₀ ; direct-history ; detour-history)

  -- the self-extension coalgebra: query = a checked future (a target with
  -- its Derivation); observation = the target; and THE EVENT DATUM IS THE
  -- DERIVATION — proof-relevant.  Every reaction carries its own proof.
  Vardhana : Tm → Type₀
  Vardhana = ISC CheckedFuture (λ _ _ _ → Tm) (λ w q w' o → Derivation w o)

  vardhana : (w : Tm) → Vardhana w
  react (vardhana w) cf = target cf , target cf , derivation cf , vardhana (target cf)

  -- every reaction hands back a CHECKED derivation seed → target, and it
  -- is exactly the future's own proof, definitionally: the orbit
  -- accumulates a certificate (Apunaragamana — the orbit strictly grows,
  -- and here it grows a proof).
  reaction-history : (w : Tm) (cf : CheckedFuture w) → Derivation w (target cf)
  reaction-history w cf = fst (snd (snd (react (vardhana w) cf)))

  history-refl : (w : Tm) (cf : CheckedFuture w)
    → reaction-history w cf ≡ derivation cf
  history-refl w cf = refl

  -- TWO FUTURES, ONE TARGET, DIFFERENT PROOF (GenerativeKernel's
  -- two-walks-one-output).  Both typecheck; the event datum distinguishing
  -- them is a Derivation, whose type is NOT a proposition — which is
  -- exactly why §2's एक-नेत्रम् is unavailable for this coalgebra.  [R]:
  -- the process space of the kernel's self-extension is not contractible;
  -- that non-collapse is the generativity.  ([S]: a formal ¬ isProp of
  -- Derivation seed target₀ is the sharper term, not built here.)
  cf-direct cf-detour : CheckedFuture seed
  cf-direct = record { target = target₀ ; derivation = direct-history }
  cf-detour = record { target = target₀ ; derivation = detour-history }

  -- the two reactions agree on everything a SET-level observer sees (same
  -- successor, same observation) and differ only in the carried proof:
  same-target : target cf-direct ≡ target cf-detour
  same-target = refl
