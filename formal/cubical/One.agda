{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- One.
--
-- Supersedes photon.agda, the fibre law, and the coinductive calculus.
-- Six statements and their instances.  Nothing here is proved twice and
-- no form is written twice: each section consumes the sections above it.
--
--   §1  THE GRAPH.  For f : A → B the graph Σa Σb (f a ≡ b) contracts two
--       ways.  Right: A.  Reassociated: Σb (fiber f b).  One construction,
--       so "retention is free" and "the residue is the fibre" are one fact.
--   §2  UNIQUENESS.  isContr (Lossless f).  The decomposition of §1 is not
--       a decomposition, it is the only one.  Hence a lossless machine on
--       A IS a map A → A.
--   §3  DESCENT.  A projection cannot carry a distinction its fibre
--       identifies.  Eight lines, used four times below.
--   §4  COST AND INVERSE CANNOT COEXIST.  A grading forbids an inverse; an
--       inverse forbids a nonzero grading.  This is why cost lives in the
--       retained trace and transport is free.
--   §5  THE POTENTIAL.  A lower bound must be local on primitive edges.
--       Telescoping gives the bound; edgewise equality gives the geodesic.
--   §6  CORECURSION.  Path is bisimulation, and transport commutes with
--       unfolding, so an identification of state spaces carries the whole
--       future and computes at every head.
--
--   §7–§9 are the instances: interaction, locality, and the photon.  §10
--   is the machine.  §11 is what is not established.
------------------------------------------------------------------------

module One where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Equiv.Fiberwise using (fiberEquiv ; totalEquiv)
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ ; snotz ; ·-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-k+ ; ¬m<m)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; -_ ; -Involutive ; negsucNotpos ; abs ; abs-)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notnot ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit ; Unit* ; tt* ; isContrUnit*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Algebra.CommRing using (CommRing ; CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private variable ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  THE GRAPH, AND ITS TWO CONTRACTIONS.
--
-- Written once.  `Carrier` of the old library is `graph` contracted on
-- the right; the fibre law is the same graph reassociated and contracted
-- on the left.  Neither is a separate construction.
------------------------------------------------------------------------

module _ {A : Type ℓ} {B : Type ℓ} (f : A → B) where

  Graph : Type ℓ
  Graph = Σ[ a ∈ A ] Σ[ b ∈ B ] (f a ≡ b)

  -- contract the singleton Σb (f a ≡ b): retention of a determined datum
  -- costs nothing.
  graph≃dom : Graph ≃ A
  graph≃dom = Σ-contractSnd (λ a → isContrSingl (f a))

  -- reassociate and contract the singleton Σa (f a ≡ b) the other way:
  -- what the visible result omits is the fibre, exactly.
  graph≃fib : Graph ≃ (Σ[ b ∈ B ] fiber f b)
  graph≃fib = isoToEquiv (iso
    (λ { (a , b , p) → b , a , p })
    (λ { (b , a , p) → a , b , p })
    (λ _ → refl) (λ _ → refl))

  -- THE LAW.  One line, because §1 already did the work.
  law : A ≃ (Σ[ b ∈ B ] fiber f b)
  law = compEquiv (invEquiv graph≃dom) graph≃fib

  law≡ : A ≡ (Σ[ b ∈ B ] fiber f b)
  law≡ = ua law

  -- The forward map keeps the source and its witness; the visible
  -- projection is f, definitionally; the source is not reconstructed.
  present : A → Σ[ b ∈ B ] fiber f b
  present a = f a , a , refl

  visible : (a : A) → fst (present a) ≡ f a
  visible a = refl

  retained : (a : A) → fst (snd (present a)) ≡ a
  retained a = refl

  -- transport along the identification computes to it.
  transport-is-present : (a : A) → transport law≡ a ≡ present a
  transport-is-present = uaβ law

------------------------------------------------------------------------
-- §2  UNIQUENESS.  The completion of f is contractible, so the residue
-- is forced, and a lossless machine on A is a map A → A.
------------------------------------------------------------------------

Lossless : {A B : Type ℓ} (f : A → B) → Type (ℓ-suc ℓ)
Lossless {ℓ} {A} {B} f =
  Σ[ T ∈ (B → Type ℓ) ] Σ[ e ∈ (A ≃ Σ B T) ] ((a : A) → fst (equivFun e a) ≡ f a)

canonical : {A B : Type ℓ} (f : A → B) → Lossless f
canonical f = fiber f , law f , visible f

private
  -- choice, definitionally
  ΠΣ : {ℓx ℓy ℓz : Level} {X : Type ℓx} {Y : X → Type ℓy} {Z : (x : X) → Y x → Type ℓz}
     → Iso ((x : X) → Σ (Y x) (Z x)) (Σ ((x : X) → Y x) (λ h → (x : X) → Z x (h x)))
  Iso.fun ΠΣ h = (λ x → fst (h x)) , (λ x → snd (h x))
  Iso.inv ΠΣ (h , k) x = h x , k x
  Iso.rightInv ΠΣ _ = refl
  Iso.leftInv ΠΣ _ = refl

  flip≃ : {X Y : Type ℓ} → (X ≃ Y) ≃ (Y ≃ X)
  flip≃ = compEquiv (invEquiv univalence)
            (compEquiv (isoToEquiv (iso sym sym (λ _ → refl) (λ _ → refl))) univalence)

  swap23 : {X : Type ℓ} {P Q : X → Type ℓ} → Iso (Σ X (λ x → P x × Q x)) (Σ X (λ x → Q x × P x))
  Iso.fun swap23 (x , p , q) = x , q , p
  Iso.inv swap23 (x , q , p) = x , p , q
  Iso.rightInv swap23 _ = refl
  Iso.leftInv swap23 _ = refl

module _ {A B : Type ℓ} (f : A → B) (T : B → Type ℓ) where

  -- a map lying over f is a section of T along f
  private
    Over : Type ℓ
    Over = Σ[ g ∈ (A → Σ B T) ] ((a : A) → fst (g a) ≡ f a)

    sect : Iso ((a : A) → T (f a)) Over
    Iso.fun sect s = (λ a → f a , s a) , (λ a → refl)
    Iso.inv sect (g , v) a = subst T (v a) (snd (g a))
    Iso.rightInv sect (g , v) =
      ΣPathP ( funExt (λ a i → v a (~ i) , subst-filler T (v a) (snd (g a)) (~ i))
             , λ i a j → v a (~ i ∨ j) )
    Iso.leftInv sect s = funExt (λ a → substRefl {B = T} (s a))

    -- a section along f is a fiberwise map out of the fibre family
    fibw : Iso ((b : B) → fiber f b → T b) ((a : A) → T (f a))
    Iso.fun fibw φ a = φ (f a) (a , refl)
    Iso.inv fibw s b w = subst T (snd w) (s (fst w))
    Iso.rightInv fibw s = funExt (λ a → substRefl {B = T} (s a))
    Iso.leftInv fibw φ = funExt λ b → funExt λ w →
      J (λ b' p → subst T p (φ (f (fst w)) (fst w , refl)) ≡ φ b' (fst w , p))
        (substRefl {B = T} (φ (f (fst w)) (fst w , refl))) (snd w)

    tot : ((b : B) → fiber f b → T b) → Σ B (fiber f) → Σ B T
    tot φ (b , w) = b , φ b w

    -- being an equivalence over f is being a fiberwise equivalence
    overIsFib : (φ : (b : B) → fiber f b → T b)
      → isEquiv (λ a → (f a , φ (f a) (a , refl))) ≃ ((b : B) → isEquiv (φ b))
    overIsFib φ = propBiimpl→Equiv (isPropIsEquiv _) (isPropΠ (λ _ → isPropIsEquiv _)) to from
      where
      g : A → Σ B T
      g a = f a , φ (f a) (a , refl)
      h : (w : Σ B (fiber f)) → g (invEq (law f) w) ≡ tot φ w
      h (b , a , p) = J (λ b' p' → g a ≡ (b' , φ b' (a , p'))) refl p
      to : isEquiv g → (b : B) → isEquiv (φ b)
      to e = fiberEquiv (fiber f) T φ
               (subst isEquiv (funExt h) (snd (compEquiv (invEquiv (law f)) (g , e))))
      from : ((b : B) → isEquiv (φ b)) → isEquiv g
      from fx = snd (compEquiv (law f) (tot φ , totalEquiv (fiber f) T φ fx))

  completion-chain :
    (Σ[ e ∈ (A ≃ Σ B T) ] ((a : A) → fst (equivFun e a) ≡ f a))
      ≃ ((b : B) → T b ≃ fiber f b)
  completion-chain =
    compEquiv (compEquiv Σ-assoc-≃ (compEquiv (isoToEquiv swap23) (invEquiv Σ-assoc-≃)))
    (compEquiv (invEquiv (Σ-cong-equiv-fst {B = λ w → isEquiv (fst w)}
                           (isoToEquiv (compIso fibw sect))))
    (compEquiv (Σ-cong-equiv-snd overIsFib)
    (compEquiv (invEquiv (isoToEquiv ΠΣ)) (equivΠCod (λ _ → flip≃)))))

-- THE THEOREM.  A product of equivalence-singletons, contractible by
-- univalence.  Losslessness is a property of f, not a structure on it.
uniqueness : {A B : Type ℓ} (f : A → B) → isContr (Lossless f)
uniqueness {ℓ} {A} {B} f = isOfHLevelRespectEquiv 0 (invEquiv unwound)
    (isContrΠ (λ b → EquivContr (fiber f b)))
  where
  unwound : Lossless f ≃ ((b : B) → Σ[ X ∈ Type ℓ ] (X ≃ fiber f b))
  unwound = compEquiv (Σ-cong-equiv-snd (completion-chain f))
              (invEquiv (isoToEquiv (ΠΣ {X = B} {Y = λ _ → Type ℓ}
                                       {Z = λ b X → X ≃ fiber f b})))

-- A lossless proof-relevant machine on A, unfolded, is a map A → A.
Machine : (A : Type ℓ) → Type (ℓ-suc ℓ)
Machine A = Σ[ f ∈ (A → A) ] Lossless f

machines-are-maps : {A : Type ℓ} → Machine A ≃ (A → A)
machines-are-maps = Σ-contractSnd uniqueness

------------------------------------------------------------------------
-- §3  DESCENT.  A projection cannot carry a distinction its fibre
-- identifies.  Stated once; §7, §9 and §10 are its instances.
------------------------------------------------------------------------

Factors : {X : Type ℓ} {Y : Type ℓ} {V : Type ℓ} (q : X → Y) (v : X → V) → Type ℓ
Factors {X = X} {Y} {V} q v = Σ[ h ∈ (Y → V) ] ((x : X) → h (q x) ≡ v x)

collision-forbids-descent :
  {X Y V : Type ℓ} (q : X → Y) (v : X → V) (x y : X)
  → q x ≡ q y → ¬ (v x ≡ v y) → ¬ Factors q v
collision-forbids-descent q v x y same differ (h , fac) =
  differ (sym (fac x) ∙ cong h same ∙ fac y)

-- The same statement read through §1: a value descends along f exactly
-- when it is constant on every fibre, and the fibre is what §1 named.
fibre-constant→descent :
  {A B : Type ℓ} {V : Type ℓ} (f : A → B) (v : A → V)
  → ((b : B) (u w : fiber f b) → v (fst u) ≡ v (fst w))
  → (a a' : A) → f a ≡ f a' → v a ≡ v a'
fibre-constant→descent f v c a a' p = c (f a') (a , p) (a' , refl)

------------------------------------------------------------------------
-- §4  COST AND INVERSE CANNOT COEXIST.
--
-- A grading adds under composition and vanishes on the unit.  On a
-- structure with inverses every grading is identically zero.  So a system
-- that wants reversibility must put its cost in the retained trace: which
-- is what §1 retains and §2 makes unique.
------------------------------------------------------------------------

record Graded {M : Type ℓ} (e : M) (_·_ : M → M → M) : Type ℓ where
  field
    ∥_∥   : M → ℕ
    unit  : ∥ e ∥ ≡ zero
    add   : (x y : M) → ∥ x · y ∥ ≡ ∥ x ∥ + ∥ y ∥
open Graded

private
  +≡zero→left : (m n : ℕ) → m + n ≡ zero → m ≡ zero
  +≡zero→left zero    n p = refl
  +≡zero→left (suc m) n p = Empty.rec (snotz p)

-- On a structure with inverses, a grading is identically zero.
inverse-kills-cost :
  {M : Type ℓ} {e : M} {_·_ : M → M → M} (G : Graded e _·_)
  (inv : M → M) (rinv : (x : M) → (x · inv x) ≡ e)
  → (x : M) → ∥ G ∥ x ≡ zero
inverse-kills-cost {_·_ = _·_} G inv rinv x =
  +≡zero→left (∥ G ∥ x) (∥ G ∥ (inv x))
    (sym (add G x (inv x)) ∙ cong (∥ G ∥) (rinv x) ∙ unit G)

-- Contrapositive, in the form used below: if some element has nonzero
-- grade, no right inverse exists.
cost-forbids-inverse :
  {M : Type ℓ} {e : M} {_·_ : M → M → M} (G : Graded e _·_) (x : M)
  → ¬ (∥ G ∥ x ≡ zero)
  → ¬ (Σ[ inv ∈ (M → M) ] ((y : M) → (y · inv y) ≡ e))
cost-forbids-inverse G x nz (inv , rinv) = nz (inverse-kills-cost G inv rinv x)

------------------------------------------------------------------------
-- §5  THE POTENTIAL.  A lower bound must be local on primitive edges.
-- Telescoping gives the bound; edgewise equality gives the geodesic.
------------------------------------------------------------------------


------------------------------------------------------------------------
-- §5  THE POTENTIAL.  A lower bound must be local on the primitive
-- edges.  Telescoping gives the bound; meeting it is geodesicity.
------------------------------------------------------------------------

module Geodesic {V : Type ℓ} (w : V → V → ℕ) (Φ : V → ℕ) where

  data Walk : V → V → Type ℓ where
    nil  : (v : V) → Walk v v
    step : (u v : V) {t : V} → Walk v t → Walk u t

  cost : {u t : V} → Walk u t → ℕ
  cost (nil _)      = zero
  cost (step u v p) = w u v + cost p

  -- the whole hypothesis: Φ never falls faster than the edge pays
  Local : Type ℓ
  Local = (u v : V) → Φ u ≤ (w u v + Φ v)

  bound : Local → {t : V} → Φ t ≡ zero → {u : V} (p : Walk u t) → Φ u ≤ cost p
  bound loc z (nil v)      = zero , z
  bound loc z (step u v p) =
    ≤-trans (loc u v) (≤-k+ (bound loc z p))

  -- A walk that meets the potential is shortest, against every competitor.
  -- No enumeration: the competitor is bounded by the same local law.
  geodesic : Local → {t : V} → Φ t ≡ zero → {u : V}
           → (p : Walk u t) → cost p ≡ Φ u
           → (q : Walk u t) → cost p ≤ cost q
  geodesic loc z p tight q = subst (_≤ cost q) (sym tight) (bound loc z q)

------------------------------------------------------------------------
-- §6  CORECURSION.  One stream.  Path is bisimulation, and transport
-- commutes with unfolding, so an identification of the state space
-- carries the entire future and computes at every head.
------------------------------------------------------------------------

record Stream (A : Type ℓ) : Type ℓ where
  coinductive
  field head : A
        tail : Stream A
open Stream public

unfold : {A : Type ℓ} → (A → A) → A → Stream A
head (unfold Φ a) = a
tail (unfold Φ a) = unfold Φ (Φ a)

mapS : {A B : Type ℓ} → (A → B) → Stream A → Stream B
head (mapS f s) = f (head s)
tail (mapS f s) = mapS f (tail s)

record _≈_ {A : Type ℓ} (x y : Stream A) : Type ℓ where
  coinductive
  field ≈head : head x ≡ head y
        ≈tail : tail x ≈ tail y
open _≈_ public

module _ {A : Type ℓ} where
  bisim : {x y : Stream A} → x ≈ y → x ≡ y
  head (bisim p i) = ≈head p i
  tail (bisim p i) = bisim (≈tail p) i

  obsv : {x y : Stream A} → x ≡ y → x ≈ y
  ≈head (obsv p) i = head (p i)
  ≈tail (obsv p)   = obsv (λ i → tail (p i))

  private
    bo : {x y : Stream A} (p : x ≡ y) → bisim (obsv p) ≡ p
    head (bo p i j) = head (p j)
    tail (bo p i j) = bo (λ k → tail (p k)) i j
    ob : {x y : Stream A} (p : x ≈ y) → obsv (bisim p) ≡ p
    ≈head (ob p i) = ≈head p
    ≈tail (ob p i) = ob (≈tail p) i

  -- program equality of non-terminating processes IS bisimulation
  path≃bisim : {x y : Stream A} → (x ≡ y) ≃ (x ≈ y)
  path≃bisim = isoToEquiv (iso obsv bisim ob bo)

-- THE SQUARE.  Push the whole execution through the identification of
-- §1, or push the seed through and run the carried dynamics: one object.
-- uaβ from §1 is consumed at every head; nothing else is needed.
module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

  carried : (Σ[ b ∈ B ] fiber f b) → (Σ[ b ∈ B ] fiber f b)
  carried c = present f (Φ (fst (snd c)))

  private
    sq : (a : A) → mapS (transport (law≡ f)) (unfold Φ a)
                 ≈ unfold carried (present f a)
    ≈head (sq a) = transport-is-present f a
    ≈tail (sq a) = sq (Φ a)

  transport-commutes-with-unfolding :
    (a : A) → mapS (transport (law≡ f)) (unfold Φ a)
            ≡ unfold carried (present f a)
  transport-commutes-with-unfolding a = bisim (sq a)

------------------------------------------------------------------------
-- §7  INTERACTION.  A machine that asks.  Its run is its answer stream —
-- the states it visits are receipts, and §1 already said receipts are
-- free.  Determinism is not a condition on steps: it is having nothing
-- to ask.
------------------------------------------------------------------------

record Interaction (X : Type ℓ) : Type (ℓ-suc ℓ) where
  field Q : X → Type ℓ
        δ : (x : X) → Q x → X
open Interaction

module _ {X : Type ℓ} (I : Interaction X) where

  -- the environment's bare contribution
  record Answers (x : X) : Type ℓ where
    coinductive
    field ans  : Q I x
          more : Answers (δ I x ans)
  open Answers public

  -- the run: a now, the receipt that now is the state, an answer, a rest
  record Run (x : X) : Type ℓ where
    coinductive
    field now  : X
          here : now ≡ x
          rans : Q I x
          rest : Run (δ I x rans)
  open Run public

  private
    forget : {x : X} → Run x → Answers x
    ans  (forget r) = rans r
    more (forget r) = forget (rest r)

    replay : (x : X) → Answers x → Run x
    now  (replay x a) = x
    here (replay x a) = refl
    rans (replay x a) = ans a
    rest (replay x a) = replay (δ I x (ans a)) (more a)

    rf : {x : X} (r : Run x) → replay x (forget r) ≡ r
    now  (rf r i) = here r (~ i)
    here (rf r i) = λ j → here r (~ i ∨ j)
    rans (rf r i) = rans r
    rest (rf r i) = rf (rest r) i

    fr : {x : X} (a : Answers x) → forget (replay x a) ≡ a
    ans  (fr a i) = ans a
    more (fr a i) = fr (more a) i

  -- THE THEOREM.  A history carries nothing beyond its answers.
  run-is-answers : (x : X) → Run x ≃ Answers x
  run-is-answers x = isoToEquiv (iso forget (replay x) fr rf)

  -- and the trajectory it visits, as a §6 stream
  trajectory : (x : X) → Answers x → Stream X
  head (trajectory x a) = x
  tail (trajectory x a) = trajectory (δ I x (ans a)) (more a)

  -- Nothing to ask, nothing to choose.  The contraction is built over a
  -- PATH of states; no h-level assumption on X is used.
  module _ (silent : (x : X) → isContr (Q I x)) where

    private
      mute : (x : X) → Answers x
      ans  (mute x) = fst (silent x)
      more (mute x) = mute (δ I x (fst (silent x)))

      uniq : {x y : X} (p : x ≡ y) (a : Answers x) (b : Answers y)
           → PathP (λ i → Answers (p i)) a b
      ans (uniq p a b i) =
        isProp→PathP (λ i → isContr→isProp (silent (p i))) (ans a) (ans b) i
      more (uniq p a b i) =
        uniq (λ i → δ I (p i)
               (isProp→PathP (λ i → isContr→isProp (silent (p i))) (ans a) (ans b) i))
             (more a) (more b) i

    silence-is-determinism : (x : X) → isContr (Run x)
    silence-is-determinism x =
      isOfHLevelRespectEquiv 0 (invEquiv (run-is-answers x))
        (mute x , uniq refl (mute x))

-- A closed machine is the interaction with nothing to ask, and §6's
-- unfolding is its trajectory.  One construction, two readings.
closed : {X : Type ℓ} → (X → X) → Interaction X
Q (closed f) _   = Unit*
δ (closed f) x _ = f x

closed-is-deterministic : {X : Type ℓ} (f : X → X) (x : X)
  → isContr (Run (closed f) x)
closed-is-deterministic f = silence-is-determinism (closed f) (λ _ → isContrUnit*)

------------------------------------------------------------------------
-- §8  LOCALITY.  Truncate a stream at depth n.  A cellwise map moves no
-- information along the stream; a map that reads one cell ahead moves it
-- at unit speed.  Depth is time and the word's length is its light cone.
-- §5's potential is the same statement read metrically.
------------------------------------------------------------------------

take : {A : Type ℓ} → ℕ → Stream A → List A
take zero    s = []
take (suc n) s = head s ∷ take n (tail s)

Close : {A : Type ℓ} → ℕ → Stream A → Stream A → Type ℓ
Close n s t = take n s ≡ take n t

-- zero lookahead: a cellwise map is 1-Lipschitz with modulus the identity
cellwise-continuous : {A : Type ℓ} (g : A → A) (n : ℕ) (s t : Stream A)
  → Close n s t → Close n (mapS g s) (mapS g t)
cellwise-continuous g zero    s t p = refl
cellwise-continuous g (suc n) s t p =
  cong₂ _∷_ (cong g (cons-inj₁ p)) (cellwise-continuous g n (tail s) (tail t) (cons-inj₂ p))

-- Equations pass to a limit under a shared modulus.  Nothing classical
-- is used: the modulus IS the hypothesis.
take-ext : {A : Type ℓ} {x y : Stream A} → ((n : ℕ) → take n x ≡ take n y) → x ≡ y
head (take-ext h i) = cons-inj₁ (h 1) i
tail (take-ext h i) = take-ext (λ n → cons-inj₂ (h (suc n))) i

------------------------------------------------------------------------
-- §9  THE PAIR.  One four-line map, and §3 applied to it.
--
-- `turn` has exact order four.  Its SQUARE descends to each coordinate,
-- definitionally.  `turn` ITSELF descends to neither — §3 at the smallest
-- instance there is.  So order four is a property of the pair: a lone
-- observable carries at most the involution, and the coherence a braid
-- or a phase demands is data that lives on the pair.
------------------------------------------------------------------------

Pair : Type
Pair = Bool × Bool

turn half : Pair → Pair
turn (a , b) = not b , a
half (a , b) = not a , not b

turn² : (p : Pair) → turn (turn p) ≡ half p
turn² _ = refl

turn⁴ : (p : Pair) → turn (turn (turn (turn p))) ≡ p
turn⁴ (a , b) i = notnot a i , notnot b i

order-is-four : ¬ ((p : Pair) → turn (turn p) ≡ p)
order-is-four h = true≢false (cong fst (sym (h (true , true))))

-- the square descends, on the nose
half-descends : (p : Pair) → fst (half p) ≡ not (fst p)
half-descends _ = refl

-- the turn does not: §3, with the collision exhibited
turn-descends-to-neither :
  (g : Bool → Bool) → ¬ Factors {X = Pair} fst (λ p → fst (turn p))
turn-descends-to-neither g =
  collision-forbids-descent fst (λ p → fst (turn p))
    (true , false) (true , true) refl
    (λ e → true≢false e)

------------------------------------------------------------------------
-- §10  THE AMPLITUDE.  §9's turn, encoded: i is what two interdependent
-- bits do.  Phase is then a path in the universe, and transport along it
-- IS the rotation — §1's uaβ again, at a different map.
------------------------------------------------------------------------

Amp : Type
Amp = ℤ × ℤ

i· : Amp → Amp
i· (a , b) = - b , a

χ : Pair → Amp
χ (true  , true ) = pos 1    , pos 0
χ (false , true ) = pos 0    , pos 1
χ (false , false) = negsuc 0 , pos 0
χ (true  , false) = pos 0    , negsuc 0

-- THE IDENTIFICATION.  Multiplication by i is not adjoined; it is §9's
-- turn read through χ, on all four points, by reduction.
turn-is-i : (p : Pair) → χ (turn p) ≡ i· (χ p)
turn-is-i (true  , true ) = refl
turn-is-i (false , true ) = refl
turn-is-i (false , false) = refl
turn-is-i (true  , false) = refl

i·⁴ : (z : Amp) → i· (i· (i· (i· z))) ≡ z
i·⁴ (a , b) i = -Involutive a i , -Involutive b i

phase : Amp ≃ Amp
phase = isoToEquiv (iso i· (λ z → i· (i· (i· z))) i·⁴ i·⁴)

-- Phase is a loop in the universe, and applying it is transport.
phase-loop : Amp ≡ Amp
phase-loop = ua phase

phase-computes : (z : Amp) → transport phase-loop z ≡ i· z
phase-computes = uaβ phase

-- weight = |a|² + |b|², exact in ℤ.  Preserved by the phase.
sq : ℤ → ℕ
sq a = abs a Cubical.Data.Nat.· abs a
  where open import Cubical.Data.Nat using (_·_)

weight : Amp → ℕ
weight (a , b) = sq a + sq b

private
  sq-neg : (a : ℤ) → sq (- a) ≡ sq a
  sq-neg a = cong₂ _·ℕ_ (abs- a) (abs- a)
    where open import Cubical.Data.Nat using () renaming (_·_ to _·ℕ_)

weight-phase : (z : Amp) → weight (i· z) ≡ weight z
weight-phase (a , b) =
  cong (_+ sq a) (sq-neg b) ∙ +-comm (sq b) (sq a)
  where open import Cubical.Data.Nat using (+-comm)

-- §1 at `weight`: an amplitude is its weight together with what the
-- weight does not say.  No new construction.
amplitude-is-weight-and-residue : Amp ≃ (Σ[ n ∈ ℕ ] fiber weight n)
amplitude-is-weight-and-residue = law weight

------------------------------------------------------------------------
-- §11  INTERFERENCE.  Global phase is unobservable; relative phase is
-- not.  Both halves are computations, and together they are §3 read in
-- its two directions: an invariant descends along the phase action, and
-- it separates two states that action does not join.
------------------------------------------------------------------------

open CommRingStr (snd ℤCommRing) using () renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)

State₂ : Type
State₂ = Amp × Amp

-- the balanced two-mode mixer, with its common factor removed so the
-- arithmetic stays exact
mix : State₂ → State₂
mix ((a , b) , (c , d)) = (a +ℤ c , b +ℤ d) , (a -ℤ c , b -ℤ d)

ports : State₂ → ℕ × ℕ
ports s = weight (fst (mix s)) , weight (snd (mix s))

one : Amp
one = pos 1 , pos 0

plusState minusState : State₂
plusState  = one , one
minusState = one , (- pos 1 , - pos 0)

-- the two rays differ only by a relative phase, and the mixer sees it
plus-ports  : ports plusState  ≡ (4 , 0)
plus-ports  = refl

minus-ports : ports minusState ≡ (0 , 4)
minus-ports = refl

relative-phase-is-observable : ¬ (ports plusState ≡ ports minusState)
relative-phase-is-observable e =
  snotz (cong fst (sym plus-ports ∙ e ∙ minus-ports))

-- the global phase acts by §10's `i·` on both coordinates and is
-- invisible to the weights, coordinatewise — so it is invisible to the
-- ports, which are built from them
globalPhase : State₂ → State₂
globalPhase (x , y) = i· x , i· y

global-phase-is-unobservable :
  (s : State₂) → (weight (fst (globalPhase s)) ≡ weight (fst s))
               × (weight (snd (globalPhase s)) ≡ weight (snd s))
global-phase-is-unobservable (x , y) = weight-phase x , weight-phase y

------------------------------------------------------------------------
-- §12  THE FIELD.  Two prop-valued specifications that imply each other
-- are the SAME OBJECT, so every property transports and nothing is
-- reproved on the far side.  One lemma; Maxwell and Schrödinger are its
-- instance, as is any pair of specifications in this shape.
------------------------------------------------------------------------

spec≡ : {F : Type ℓ} {P Q : F → Type ℓ}
      → ((x : F) → isProp (P x)) → ((x : F) → isProp (Q x))
      → ((x : F) → P x → Q x) → ((x : F) → Q x → P x)
      → Σ F P ≡ Σ F Q
spec≡ pP pQ to from = ua (Σ-cong-equiv-snd (λ x → propBiimpl→Equiv (pP x) (pQ x) (to x) (from x)))

-- and the only thing that needs saying about it
transport-every-property :
  {F : Type ℓ} {P Q : F → Type ℓ} (p : Σ F P ≡ Σ F Q)
  → (Prop* : Type ℓ → Type ℓ') → Prop* (Σ F P) → Prop* (Σ F Q)
transport-every-property p Prop* = subst Prop* p

module Field {V : Type ℓ} (setV : isSet V)
             (neg : V → V) (negneg : (v : V) → neg (neg v) ≡ v)
             (∂t curl : V → V) where

  F : Type ℓ
  F = V × V

  -- multiplication by i on the pair: §9's `turn`, at V instead of Bool
  rotI : F → F
  rotI (e , b) = neg b , e

  Maxwell Schrodinger : F → Type ℓ
  Maxwell (e , b) = (∂t e ≡ curl b) × (∂t b ≡ neg (curl e))
  Schrodinger x    = rotI (∂t (fst x) , ∂t (snd x)) ≡ (curl (fst x) , curl (snd x))

  private
    pM : (x : F) → isProp (Maxwell x)
    pM (e , b) = isProp× (setV _ _) (setV _ _)
    pS : (x : F) → isProp (Schrodinger x)
    pS x = isSet× setV setV _ _
    m→s : (x : F) → Maxwell x → Schrodinger x
    m→s (e , b) (el , mg) = cong₂ _,_ (cong neg mg ∙ negneg (curl e)) el
    s→m : (x : F) → Schrodinger x → Maxwell x
    s→m (e , b) p = cong snd p , sym (negneg (∂t b)) ∙ cong neg (cong fst p)

  -- THE IDENTIFICATION.  Not a change of variables: the same type.
  maxwell≡schrodinger : Σ F Maxwell ≡ Σ F Schrodinger
  maxwell≡schrodinger = spec≡ pM pS m→s s→m

  -- so every property of the solution space travels, computing
  transport-physics : (Prop* : Type ℓ → Type ℓ') → Prop* (Σ F Maxwell) → Prop* (Σ F Schrodinger)
  transport-physics = transport-every-property maxwell≡schrodinger

  -- and by §6 the whole future travels with it
  solutions-and-their-futures : Stream (Σ F Maxwell) ≡ Stream (Σ F Schrodinger)
  solutions-and-their-futures = cong Stream maxwell≡schrodinger

------------------------------------------------------------------------
-- §13  THE MACHINE.  §1 at a step function: the ordinary irreversible
-- step is the visible projection of its completion, §2 says that
-- completion is unique, and therefore finding and checking are the two
-- directions of one equivalence with nothing between them.  Nothing here
-- is specific to Turing machines; instantiate at any step you like.
------------------------------------------------------------------------

module Step {A : Type ℓ} (f : A → A) where

  decide : A → Σ[ b ∈ A ] fiber f b
  decide = present f

  verify : (b : A) → fiber f b → A
  verify _ (a , _) = a

  -- the answer is the ordinary step, definitionally
  deciding-is-stepping : (a : A) → fst (decide a) ≡ f a
  deciding-is-stepping = visible f

  -- the witness ships its own certificate, and the certificate is refl
  witness-self-certifies : (a : A) → snd (snd (decide a)) ≡ refl
  witness-self-certifies a = refl

  -- checking a decided answer is free
  verify-inverts-decide : (a : A) → verify (fst (decide a)) (snd (decide a)) ≡ a
  verify-inverts-decide = retained f

  -- and there is no other completion in which a gap could live
  no-other-completion : (L : Lossless f) → fst (uniqueness f) ≡ L
  no-other-completion = snd (uniqueness f)

-- THE OTHER HALF, and it is also a theorem.  A value in a set cannot
-- see which route produced it: any two proofs of the same observation
-- are identified.  So the gap is real in the forgetful image and absent
-- in the carried one, and neither statement is a concession.
forgetful-is-blind : {A : Type ℓ} → isSet A → {x y : A} (p q : x ≡ y) → p ≡ q
forgetful-is-blind setA p q = setA _ _ p q

routes-through-ℕ-are-identified : {m n : ℕ} (p q : m ≡ n) → p ≡ q
routes-through-ℕ-are-identified = forgetful-is-blind isSetℕ

------------------------------------------------------------------------
-- §14  WHAT IS NOT ESTABLISHED, said here because a development that
-- lists only its theorems has dropped half its witness.
--
--   * Univalence transports a PROVED equivalence.  It does not turn a
--     many-to-one map into one, and §1 does not pretend otherwise: it
--     names what the map forgets, it does not recover it.
--   * §5 is a lower-bound SCHEMA.  It certifies a family only when a Φ
--     is exhibited and its edge law proved against the actual primitive
--     edges.  A count of states, cells, or assignments is not a Φ.
--   * §7 models strategies as functions of the state.  Histories,
--     protocols and adversaries are not modelled.
--   * Nothing here says a trace is small, cheap to store, or safe to
--     transmit.  It says what it is.
--   * §12 is stated for an abstract V with an abstract ∂t and curl.  The
--     analytic content of a particular field theory — domains, moduli,
--     completeness — is not supplied by the identification.
--   * effects, capability, disclosure, authority, verifier correctness,
--     protocol security, revocation, privacy accounting, specification
--     adequacy: none is a corollary of a transport law, and none appears.
------------------------------------------------------------------------
