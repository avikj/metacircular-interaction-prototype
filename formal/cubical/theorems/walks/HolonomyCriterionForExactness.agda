{-# OPTIONS --safe --cubical --guardedness #-}

------------------------------------------------------------------------
-- HolonomyCriterionForExactness — a W-valued edge cochain on a connected
-- graph is a coboundary iff its holonomy vanishes on every loop; a
-- finite basis of independent cycles suffices to decide it.
--
-- The second stimulus, paid as theorems, in the corpus's discipline:
-- --safe, cubical, pinned library, every claim a checked term, every
-- statement universal (over every type of states, every group of
-- values).  Nothing bounded, nothing empirical.
--
-- WHAT IS PROVED HERE.
--
--   1. stokes          — the discrete Stokes identity: pairing the
--                        coboundary of a value-function against ANY
--                        walk telescopes to endpoint difference.  This
--                        is the sentence "value = ⟨ω,γ⟩" made a term:
--                        the trace is the chain, the evaluator is the
--                        cochain, and their pairing is computed by the
--                        boundary alone.
--   2. descent       — descent: the pairing of an exact evaluator
--                        depends only on the endpoints of the trace.
--                        Two traces with the same boundary are
--                        observer-indistinguishable IN VALUE — this is
--                        conservative semantic compression as an
--                        equation, not a slogan.
--   3. loopsVanishForExact      — exact evaluators have zero holonomy: every
--                        loop pairs to the group identity.  The B¹
--                        half of the reward classification.
--   4. oneLoopRefutesExactness    — the manipulation detector: ONE loop with
--                        nonvanishing holonomy certifies that the
--                        evaluator is exact for NO value-function
--                        whatsoever.  [ω] ≠ 0 witnessed by a single
--                        closed trace.  This is evaluative holonomy
--                        (Vision H) and reward cohomology (Vision F)
--                        as one theorem: irreducible path-preference
--                        IS a nonzero class, and the certificate is a
--                        loop.
--   5. observerLossless       — observer-relative losslessness: for every
--                        observer o : A → O, the state space is
--                        isomorphic to observation-plus-fibre.  The
--                        corpus's lossless completion, restated at the
--                        observer.
--   6. optionPreserved    — option preservation: an action with a section
--                        loses no option; every property inhabited
--                        downstream is inhabited upstream, with the
--                        transport receipt attached.
--   7. outputWitnessIsFree      — output-binding is free: the witness half of a
--                        proof-carrying description costs nothing on
--                        the output side (the singleton is
--                        contractible).  PCMDL's L(witness) = 0 there;
--                        all content lives in the input-binding fibre.
--   8. ℤGroupOn + priceOfTrace    — the whole apparatus instantiated at ℤ and
--                        RUN: the pairing is executable, holonomy is
--                        computed by normalization, the theorems are
--                        functionality, not commentary.
--
-- The group is NOT assumed abelian.  Stokes, descent, zero-holonomy
-- and the detector all hold for every group — the Wilson-loop reading
-- (SetuKsetra's telescoping) is the special case as much as the reward
-- reading is.
------------------------------------------------------------------------

module HolonomyCriterionForExactness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv.Base using (fiber)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int
  using (ℤ; pos; negsuc; _+_; -_; +Assoc; +Comm; pos0+; -Cancel; -Cancel')

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 0.  A group of values.  No commutativity assumed.
------------------------------------------------------------------------

record GroupOn (W : Type ℓ) : Type ℓ where
  field
    ε      : W
    _⊕_    : W → W → W
    ⊖_     : W → W
    gAssoc : ∀ a b c → a ⊕ (b ⊕ c) ≡ (a ⊕ b) ⊕ c
    gIdL   : ∀ a → ε ⊕ a ≡ a
    gIdR   : ∀ a → a ⊕ ε ≡ a
    gInvL  : ∀ a → (⊖ a) ⊕ a ≡ ε
    gInvR  : ∀ a → a ⊕ (⊖ a) ≡ ε
  infixl 6 _⊕_
  infix  8 ⊖_

------------------------------------------------------------------------
-- 1.  Traces, evaluators, and the pairing.
--
-- V is ANY type of states; a walk is any finite trace through them
-- (the complete relation: every step is a step — restriction to a
-- lawful step-relation is a substructure and inherits every theorem
-- below).  An evaluator (cochain) prices each ordered step.  The
-- pairing folds the evaluator along the trace.
------------------------------------------------------------------------

module Traces (V : Type ℓ) {W : Type ℓ'} (G : GroupOn W) where
  open GroupOn G

  data Walk (u : V) : V → Type ℓ where
    done : Walk u u
    step : ∀ {a} → Walk u a → (b : V) → Walk u b

  Cochain : Type (ℓ-max ℓ ℓ')
  Cochain = V → V → W

  -- the value IS the pairing
  ⟨_,_⟩ : Cochain → ∀ {u v} → Walk u v → W
  ⟨ ω , done ⟩       = ε
  ⟨ ω , step {a} w b ⟩ = ⟨ ω , w ⟩ ⊕ ω a b

  -- the coboundary of a value-function on states
  d : (V → W) → Cochain
  d f a b = (⊖ f a) ⊕ f b

  ----------------------------------------------------------------------
  -- THEOREM 1 (stokes).  ⟨ d f , w ⟩ ≡ ⊖ f(start) ⊕ f(end), for every
  -- walk in every type against every group.  The discrete Stokes
  -- identity; the entire boundary-computes-the-integral sentence.
  ----------------------------------------------------------------------
  stokes : (f : V → W) {u v : V} (w : Walk u v)
         → ⟨ d f , w ⟩ ≡ (⊖ f u) ⊕ f v
  stokes f {u} done = sym (gInvL (f u))
  stokes f {u} (step {a} w b) =
      cong (_⊕ ((⊖ f a) ⊕ f b)) (stokes f w)
    ∙ sym (gAssoc (⊖ f u) (f a) ((⊖ f a) ⊕ f b))
    ∙ cong ((⊖ f u) ⊕_) (gAssoc (f a) (⊖ f a) (f b)
                        ∙ cong (_⊕ f b) (gInvR (f a))
                        ∙ gIdL (f b))

  ----------------------------------------------------------------------
  -- THEOREM 2 (descent).  Descent: an exact evaluator cannot tell
  -- two traces with the same boundary apart.  The value factors
  -- through the homology class — conservative semantic compression.
  ----------------------------------------------------------------------
  descent : (f : V → W) {u v : V} (w₁ w₂ : Walk u v)
            → ⟨ d f , w₁ ⟩ ≡ ⟨ d f , w₂ ⟩
  descent f w₁ w₂ = stokes f w₁ ∙ sym (stokes f w₂)

  ----------------------------------------------------------------------
  -- THEOREM 3 (loopsVanishForExact).  Coboundaries have no holonomy: every
  -- loop pairs to ε.  The B¹ half of the reward classification —
  -- a reward of the form d f is semantics in disguise.
  ----------------------------------------------------------------------
  loopsVanishForExact : (f : V → W) {u : V} (w : Walk u u) → ⟨ d f , w ⟩ ≡ ε
  loopsVanishForExact f {u} w = stokes f w ∙ gInvL (f u)

  -- pointwise-equal evaluators pair equally along every trace
  pairCong : {ω η : Cochain} → (∀ a b → ω a b ≡ η a b)
           → ∀ {u v} (w : Walk u v) → ⟨ ω , w ⟩ ≡ ⟨ η , w ⟩
  pairCong h done         = refl
  pairCong h (step {a} w b) = cong₂ _⊕_ (pairCong h w) (h a b)

  -- exactness: the evaluator is the coboundary of some value-function
  Exact : Cochain → Type (ℓ-max ℓ ℓ')
  Exact ω = Σ (V → W) λ f → ∀ a b → ω a b ≡ d f a b

  ----------------------------------------------------------------------
  -- THEOREM 4 (oneLoopRefutesExactness — "the crooked has a witness").
  -- One loop with nonvanishing holonomy refutes exactness against
  -- EVERY candidate value-function at once.  This is the whole of
  -- Vision F and Vision H in one term:
  --   · reward cohomology  — a path-preference no state-potential
  --     explains is a nonzero class, and here is its certificate;
  --   · evaluative holonomy — a trace that closes externally
  --     (Walk u u) while transporting the evaluator nontrivially is
  --     manipulation, and ONE such trace is a proof, not a suspicion.
  ----------------------------------------------------------------------
  oneLoopRefutesExactness : (ω : Cochain) {u : V} (w : Walk u u)
               → ¬ (⟨ ω , w ⟩ ≡ ε)
               → ¬ Exact ω
  oneLoopRefutesExactness ω w nz (f , h) = nz (pairCong h w ∙ loopsVanishForExact f w)

  ----------------------------------------------------------------------
  -- Group consequences (from the axioms alone; still no commutativity)
  ----------------------------------------------------------------------

  invUnique : ∀ x z → x ⊕ z ≡ ε → z ≡ ⊖ x
  invUnique x z h =
      sym (gIdL z)
    ∙ cong (_⊕ z) (sym (gInvL x))
    ∙ sym (gAssoc (⊖ x) x z)
    ∙ cong ((⊖ x) ⊕_) h
    ∙ gIdR (⊖ x)

  invId : ⊖ ε ≡ ε
  invId = sym (gIdR (⊖ ε)) ∙ gInvL ε

  invDistr : ∀ x y → ⊖ (x ⊕ y) ≡ (⊖ y) ⊕ (⊖ x)
  invDistr x y = sym (invUnique (x ⊕ y) ((⊖ y) ⊕ (⊖ x))
    (   gAssoc (x ⊕ y) (⊖ y) (⊖ x)
      ∙ cong (_⊕ (⊖ x)) (sym (gAssoc x y (⊖ y))
                         ∙ cong (x ⊕_) (gInvR y)
                         ∙ gIdR x)
      ∙ gInvR x))

  cancelLeft : ∀ a x → a ⊕ x ≡ a → x ≡ ε
  cancelLeft a x h =
      sym (gIdL x)
    ∙ cong (_⊕ x) (sym (gInvL a))
    ∙ sym (gAssoc (⊖ a) a x)
    ∙ cong ((⊖ a) ⊕_) h
    ∙ gInvL a

  cancelInv : ∀ x c → x ⊕ (⊖ c) ≡ ε → x ≡ c
  cancelInv x c h =
      sym (gIdR x)
    ∙ cong (x ⊕_) (sym (gInvL c))
    ∙ gAssoc x (⊖ c) c
    ∙ cong (_⊕ c) h
    ∙ gIdL c

  ----------------------------------------------------------------------
  -- Trace algebra: concatenation, the single edge, reversal — and how
  -- the pairing respects each.  The pairing is a monoid map from
  -- traces to values, and (for a signed evaluator) sends reversal to
  -- inversion.  Nonabelian throughout.
  ----------------------------------------------------------------------

  _++_ : ∀ {u a v} → Walk u a → Walk a v → Walk u v
  w ++ done       = w
  w ++ step w' b  = step (w ++ w') b

  pairCat : (ω : Cochain) {u a v : V} (w₁ : Walk u a) (w₂ : Walk a v)
          → ⟨ ω , w₁ ++ w₂ ⟩ ≡ ⟨ ω , w₁ ⟩ ⊕ ⟨ ω , w₂ ⟩
  pairCat ω w₁ done = sym (gIdR _)
  pairCat ω w₁ (step {a'} w₂ b) =
      cong (_⊕ ω a' b) (pairCat ω w₁ w₂)
    ∙ sym (gAssoc ⟨ ω , w₁ ⟩ ⟨ ω , w₂ ⟩ (ω a' b))

  edge : (a b : V) → Walk a b
  edge a b = step (done {u = a}) b

  rev : ∀ {u v} → Walk u v → Walk v u
  rev done           = done
  rev (step {a} w b) = edge b a ++ rev w

  -- a signed evaluator: reversing a step negates its price
  Signed : Cochain → Type (ℓ-max ℓ ℓ')
  Signed ω = ∀ a b → ω b a ≡ ⊖ ω a b

  pairRev : (ω : Cochain) → Signed ω
          → ∀ {u v} (w : Walk u v) → ⟨ ω , rev w ⟩ ≡ ⊖ ⟨ ω , w ⟩
  pairRev ω sg done = sym invId
  pairRev ω sg (step {a} w b) =
      pairCat ω (edge b a) (rev w)
    ∙ cong₂ _⊕_ (gIdL (ω b a) ∙ sg a b) (pairRev ω sg w)
    ∙ sym (invDistr ⟨ ω , w ⟩ (ω a b))

  ----------------------------------------------------------------------
  -- THEOREM 5 (potentialFromVanishingHolonomy) — the CONVERSE, so the
  -- classification is an iff and the class is the whole story:
  --
  --   On a pointed connected state space, a signed evaluator whose
  --   holonomy vanishes on every loop at the basepoint IS exact — the
  --   potential is constructed, not postulated: the value of a state
  --   is the pairing along any chosen trace to it, and vanishing
  --   holonomy is exactly what makes that choice irrelevant.
  --
  -- Together with THEOREM 3/4: a signed evaluator is exact iff every
  -- basepoint loop prices to the identity.  Irreducible
  -- path-preference is PRECISELY a nonzero first cohomology class,
  -- and both directions are terms.  (Exact evaluators are signed
  -- automatically: ⊖(d f a b) computes to d f b a by invDistr and
  -- involution, so signedness costs no generality on the exact side.)
  ----------------------------------------------------------------------
  module Complete (u₀ : V) (connect : ∀ v → Walk u₀ v)
                  (ω : Cochain) (sg : Signed ω)
                  (hol0 : (w : Walk u₀ u₀) → ⟨ ω , w ⟩ ≡ ε) where

    potential : V → W
    potential v = ⟨ ω , connect v ⟩

    private
      loopAt : (a b : V) → Walk u₀ u₀
      loopAt a b = (connect a ++ edge a b) ++ rev (connect b)

      loopValue : (a b : V)
                → ⟨ ω , loopAt a b ⟩
                ≡ (potential a ⊕ ω a b) ⊕ (⊖ potential b)
      loopValue a b =
          pairCat ω (connect a ++ edge a b) (rev (connect b))
        ∙ cong₂ _⊕_
            (pairCat ω (connect a) (edge a b)
             ∙ cong (potential a ⊕_) (gIdL (ω a b)))
            (pairRev ω sg (connect b))

      stepSum : (a b : V) → potential a ⊕ ω a b ≡ potential b
      stepSum a b = cancelInv _ _ (sym (loopValue a b) ∙ hol0 (loopAt a b))

    exactness : ∀ a b → ω a b ≡ d potential a b
    exactness a b =
        sym (gIdL (ω a b))
      ∙ cong (_⊕ ω a b) (sym (gInvL (potential a)))
      ∙ sym (gAssoc (⊖ potential a) (potential a) (ω a b))
      ∙ cong ((⊖ potential a) ⊕_) (stepSum a b)

    potentialFromVanishingHolonomy : Exact ω
    potentialFromVanishingHolonomy = potential , exactness

  ----------------------------------------------------------------------
  -- THEOREM 6 (testsSuffice / exactFromTests) — the H₁ TEST BASIS.
  --
  -- Fix a basepoint and a chosen trace to every state (the spanning
  -- structure).  Each ordered step (a,b) determines its FUNDAMENTAL
  -- LOOP: out along the chosen trace to a, across the step, back
  -- along the reversed chosen trace from b.  θ prices exactly these.
  --
  --   pairTheta:     pairing against θ conjugates the pairing against
  --                  ω by the potential — for every trace, nonabelian.
  --   testsSuffice:  if every fundamental loop prices to the identity,
  --                  EVERY loop at the basepoint does.
  --   exactFromTests: hence the evaluator is exact, with the
  --                  potential constructed.
  --
  -- This is test compression as a theorem: the fundamental loops are
  -- a complete test basis — finitely many independent checks (one per
  -- non-tree step) decide the entire cohomology class, which is the
  -- m − n + 1 sentence of the stimulus with the counting replaced by
  -- the construction.
  ----------------------------------------------------------------------
  module TestBasis (u₀ : V) (connect : ∀ v → Walk u₀ v)
                   (ω : Cochain) (sg : Signed ω) where

    potential : V → W
    potential v = ⟨ ω , connect v ⟩

    fundamentalLoop : (a b : V) → Walk u₀ u₀
    fundamentalLoop a b = (connect a ++ edge a b) ++ rev (connect b)

    θ : Cochain
    θ a b = ⟨ ω , fundamentalLoop a b ⟩

    θval : ∀ a b → θ a b ≡ (potential a ⊕ ω a b) ⊕ (⊖ potential b)
    θval a b =
        pairCat ω (connect a ++ edge a b) (rev (connect b))
      ∙ cong₂ _⊕_
          (pairCat ω (connect a) (edge a b)
           ∙ cong (potential a ⊕_) (gIdL (ω a b)))
          (pairRev ω sg (connect b))

    pairTheta : ∀ {u v} (w : Walk u v)
              → ⟨ θ , w ⟩ ≡ (potential u ⊕ ⟨ ω , w ⟩) ⊕ (⊖ potential v)
    pairTheta {u} done =
      sym (cong (_⊕ (⊖ potential u)) (gIdR (potential u)) ∙ gInvR (potential u))
    pairTheta {u} (step {a} w b) =
        cong₂ _⊕_ (pairTheta w) (θval a b)
      ∙ sym (gAssoc (potential u ⊕ ⟨ ω , w ⟩) (⊖ potential a)
                    ((potential a ⊕ ω a b) ⊕ (⊖ potential b)))
      ∙ cong ((potential u ⊕ ⟨ ω , w ⟩) ⊕_)
          (   gAssoc (⊖ potential a) (potential a ⊕ ω a b) (⊖ potential b)
            ∙ cong (_⊕ (⊖ potential b))
                (   gAssoc (⊖ potential a) (potential a) (ω a b)
                  ∙ cong (_⊕ ω a b) (gInvL (potential a))
                  ∙ gIdL (ω a b)))
      ∙ gAssoc (potential u ⊕ ⟨ ω , w ⟩) (ω a b) (⊖ potential b)
      ∙ cong (_⊕ (⊖ potential b)) (sym (gAssoc (potential u) ⟨ ω , w ⟩ (ω a b)))

    constPairing : ∀ {u v} (w : Walk u v) → ⟨ (λ _ _ → ε) , w ⟩ ≡ ε
    constPairing done       = refl
    constPairing (step w b) = gIdR _ ∙ constPairing w

    testsSuffice : (∀ a b → θ a b ≡ ε)
                 → (w : Walk u₀ u₀) → ⟨ ω , w ⟩ ≡ ε
    testsSuffice h w =
      cancelLeft (potential u₀) ⟨ ω , w ⟩
        (cancelInv (potential u₀ ⊕ ⟨ ω , w ⟩) (potential u₀)
          (sym (pairTheta w) ∙ pairCong h w ∙ constPairing w))

    exactFromTests : (∀ a b → θ a b ≡ ε) → Exact ω
    exactFromTests h =
      Complete.potentialFromVanishingHolonomy u₀ connect ω sg (testsSuffice h)

  ----------------------------------------------------------------------
  -- THEOREM 7 (gaugeInvariance) — perturbation at degree one.
  --
  -- Over an abelian value group, replacing an evaluator by a
  -- cohomologous one (adding any coboundary) changes NO closed-trace
  -- value.  Retire one evaluator, install another in the same class:
  -- every observation on loops is preserved.  This is the homological
  -- perturbation move — structure transferred, observations intact —
  -- at the degree this file inhabits.
  ----------------------------------------------------------------------
  module Gauge (comm : ∀ a b → a ⊕ b ≡ b ⊕ a) where

    exch : ∀ a b x y → (a ⊕ b) ⊕ (x ⊕ y) ≡ (a ⊕ x) ⊕ (b ⊕ y)
    exch a b x y =
        sym (gAssoc a b (x ⊕ y))
      ∙ cong (a ⊕_) (gAssoc b x y
                     ∙ cong (_⊕ y) (comm b x)
                     ∙ sym (gAssoc x b y))
      ∙ gAssoc a x (b ⊕ y)

    pairAdd : (ω η : Cochain) → ∀ {u v} (w : Walk u v)
            → ⟨ (λ a b → ω a b ⊕ η a b) , w ⟩ ≡ ⟨ ω , w ⟩ ⊕ ⟨ η , w ⟩
    pairAdd ω η done = sym (gIdL ε)
    pairAdd ω η (step {a} w b) =
        cong (_⊕ (ω a b ⊕ η a b)) (pairAdd ω η w)
      ∙ exch ⟨ ω , w ⟩ ⟨ η , w ⟩ (ω a b) (η a b)

    gaugeInvariance : (ω : Cochain) (f : V → W) {u : V} (w : Walk u u)
                    → ⟨ (λ a b → ω a b ⊕ d f a b) , w ⟩ ≡ ⟨ ω , w ⟩
    gaugeInvariance ω f w =
        pairAdd ω (d f) w
      ∙ cong (⟨ ω , w ⟩ ⊕_) (loopsVanishForExact f w)
      ∙ gIdR ⟨ ω , w ⟩

------------------------------------------------------------------------
-- 2.  Observer-relative losslessness.
--
-- For every observer o : A → O the state space is exactly
-- observation-plus-fibre: nothing an observer forgets is destroyed,
-- it is carried.  Compression relative to o is conservative by
-- construction — this is the corpus's lossless completion, restated
-- with the observer in the front seat.
------------------------------------------------------------------------

module ObserverLossless {A : Type ℓ} {O : Type ℓ'} (o : A → O) where

  observerLossless : Iso A (Σ O (fiber o))
  Iso.fun observerLossless a               = o a , a , refl
  Iso.inv observerLossless (b , a , p)     = a
  Iso.rightInv observerLossless (b , a , p) i = p i , a , λ j → p (i ∧ j)
  Iso.leftInv observerLossless a           = refl

------------------------------------------------------------------------
-- 3.  Option preservation.
--
-- An action f with a section s loses no option: every property
-- inhabited after the action is inhabited before it, and the
-- transport receipt (the section equation) is attached to the
-- recovered option, as a term.
------------------------------------------------------------------------

module OptionPreservation {A : Type ℓ} {B : Type ℓ'}
                    (f : A → B) (s : B → A)
                    (sec : ∀ b → f (s b) ≡ b)
                    (P : B → Type ℓ'') where

  optionPreserved : Σ B P → Σ A (λ a → P (f a))
  optionPreserved (b , p) = s b , subst P (sym (sec b)) p

  -- the receipt: the recovered option projects back onto the original
  receipt : (bp : Σ B P) → f (fst (optionPreserved bp)) ≡ fst bp
  receipt (b , p) = sec b

------------------------------------------------------------------------
-- 4.  The witness is free on the output side.
--
-- PCMDL prices a description together with its equivalence witness.
-- On the output-binding side that witness costs NOTHING: the type of
-- (output, receipt) pairs is contractible.  All description-length
-- content lives in the input-binding fibre — which is exactly where
-- the corpus's cost layer already lives.
------------------------------------------------------------------------

outputWitnessIsFree : {A : Type ℓ} {B : Type ℓ'} (f : A → B) (a : A)
           → isContr (Σ B (λ b → f a ≡ b))
outputWitnessIsFree f a = isContrSingl (f a)

------------------------------------------------------------------------
-- 5.  The apparatus at ℤ, running.
--
-- ℤ carries the group structure by the pinned library's own laws; the pairing, the
-- holonomy, the Stokes identity are then EXECUTABLE — the kernel
-- normalizes them.  priceOfTrace below is a value the typechecker computes,
-- not asserts: the theorems are functionality.
------------------------------------------------------------------------

ℤGroupOn : GroupOn ℤ
GroupOn.ε      ℤGroupOn = pos 0
GroupOn._⊕_    ℤGroupOn = _+_
GroupOn.⊖_     ℤGroupOn = -_
GroupOn.gAssoc ℤGroupOn = +Assoc
GroupOn.gIdL   ℤGroupOn a = sym (pos0+ a)
GroupOn.gIdR   ℤGroupOn a = refl
GroupOn.gInvL  ℤGroupOn = -Cancel'
GroupOn.gInvR  ℤGroupOn = -Cancel

module ℤTraces = Traces ℤ ℤGroupOn

private
  open ℤTraces

  -- the exact evaluator of the identity potential: price of a step is
  -- the signed displacement
  δ : Cochain
  δ = d (λ z → z)

  -- a trace 0 → 5 → 3, priced by normalization: the kernel COMPUTES 3
  priceOfTrace : ⟨ δ , step (step (done {u = pos 0}) (pos 5)) (pos 3) ⟩ ≡ pos 3
  priceOfTrace = refl

  -- and Stokes agrees with the computation, as it must, universally
  priceAgreesWithStokes : ⟨ δ , step (step (done {u = pos 0}) (pos 5)) (pos 3) ⟩
             ≡ (- pos 0) + pos 3
  priceAgreesWithStokes = stokes (λ z → z) (step (step (done {u = pos 0}) (pos 5)) (pos 3))
