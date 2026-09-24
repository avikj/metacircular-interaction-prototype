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
--   §7   INTERACTION.  §8  LOCALITY.  §9–§11 THE PHOTON: the quarter
--        turn on an interdependent pair, the amplitude it generates, and
--        interference.
--   §12  THE EQUATIONS.  Two prop-valued specifications that imply each
--        other are the same type; Maxwell and Schrödinger are the
--        instance.
--   §13  THE OBJECT.  The completion of the rational scale — at one
--        dimension the constructive reals, at the Fourier cell an
--        infinite-dimensional space — the actual operator k × · on it,
--        and §12 instantiated there, so the identification is about a
--        space and not a parameter list.
--   §14  THE MACHINE.
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
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; max ; isSetℕ ; snotz ; ·-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-k+ ; ≤-sucℕ ; ¬m<m ; left-≤-max ; right-≤-max)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; -_ ; -Involutive ; negsucNotpos ; abs ; abs-)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notnot ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; map)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit ; Unit* ; tt* ; isContrUnit*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Algebra.CommRing using (CommRing ; CommRingStr ; makeCommRing)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.Relation.Binary using (module BinaryRelation)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)
import Cubical.Data.Rationals as Q
import Cubical.Data.Rationals.Order as O
open import Cubical.Data.NatPlusOne using (1+_)
open import Cubical.Data.Nat.Literals
open Q using (ℚ)

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

-- An operator of physics need not be defined everywhere: ∂t and curl go
-- from a DOMAIN to the space of values, which is what §13's graph norm
-- delivers.  Taking D = V recovers the bounded case.
module Field {D : Type ℓ} {V : Type ℓ} (setV : isSet V)
             (neg : V → V) (negneg : (v : V) → neg (neg v) ≡ v)
             (∂t curl : D → V) where

  Fl : Type ℓ
  Fl = D × D

  -- multiplication by i on the pair: §9's `turn`, at V instead of Bool
  rotI : V × V → V × V
  rotI (e , b) = neg b , e

  Maxwell Schrodinger : Fl → Type ℓ
  Maxwell (e , b) = (∂t e ≡ curl b) × (∂t b ≡ neg (curl e))
  Schrodinger x    = rotI (∂t (fst x) , ∂t (snd x)) ≡ (curl (fst x) , curl (snd x))

  maxwell-isProp : (x : Fl) → isProp (Maxwell x)
  maxwell-isProp (e , b) = isProp× (setV _ _) (setV _ _)
  schrodinger-isProp : (x : Fl) → isProp (Schrodinger x)
  schrodinger-isProp x = isSet× setV setV _ _

  private
    m→s : (x : Fl) → Maxwell x → Schrodinger x
    m→s (e , b) (el , mg) = cong₂ _,_ (cong neg mg ∙ negneg (curl e)) el
    s→m : (x : Fl) → Schrodinger x → Maxwell x
    s→m (e , b) p = cong snd p , sym (negneg (∂t b)) ∙ cong neg (cong fst p)

  -- THE IDENTIFICATION.  Not a change of variables: the same type.
  maxwell≡schrodinger : Σ Fl Maxwell ≡ Σ Fl Schrodinger
  maxwell≡schrodinger = spec≡ maxwell-isProp schrodinger-isProp m→s s→m

  -- so every property of the solution space travels, computing
  transport-physics : (Prop* : Type ℓ → Type ℓ') → Prop* (Σ Fl Maxwell) → Prop* (Σ Fl Schrodinger)
  transport-physics = transport-every-property maxwell≡schrodinger

  -- and by §6 the whole future travels with it
  solutions-and-their-futures : Stream (Σ Fl Maxwell) ≡ Stream (Σ Fl Schrodinger)
  solutions-and-their-futures = cong Stream maxwell≡schrodinger

------------------------------------------------------------------------
-- §13  THE OBJECT.  §12 identifies two specifications of a field; this
-- section supplies the field.  An infinite-dimensional space is built
-- from the rational scale by completion, the actual Fourier operator
-- k × · and its quarter turn are lifted to it, and §12 is instantiated
-- there — so `maxwell≡schrodinger` is about an object, not a parameter
-- list.  Three things are worth stating in advance, because each is a
-- section above read metrically:
--
--   * a NAME is a presentation (sequence, modulus, proof) and the
--     completion is its quotient — §1, with the residue retained;
--   * extending a map COMPOSES the two moduli, explicitly — §4's cost,
--     carried through a map instead of discarded;
--   * set-quotient EFFECTIVITY turns equality back into the approach
--     data, which is how the completion keeps a distinction a setoid
--     cannot state.
--
-- Everything metric is proved once at a record `Cell` and instantiated:
-- scalar, product, lists, and the graph of an operator are all cells.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- A  RING LEMMAS.  Every polynomial identity used below, proved once by
-- the ring solver, stated over an arbitrary commutative ring so that the
-- rational metric and the Fourier symbol draw on the same list.
------------------------------------------------------------------------

module Ring {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (snd R) public using (0r ; 1r)
    renaming (_+_ to _+r_ ; _·_ to _*r_ ; -_ to negr ; _-_ to _-r_)

  square : fst R → fst R
  square a = a *r a

  twice : fst R → fst R
  twice a = a +r a

  neg-zero      : negr 0r ≡ 0r
  neg-zero      = solve! R
  neg-neg       : (a : fst R) → negr (negr a) ≡ a
  neg-neg a     = solve! R
  square-neg       : (a : fst R) → square (negr a) ≡ square a
  square-neg a     = solve! R
  square-zero       : square 0r ≡ 0r
  square-zero       = solve! R
  square-self      : (a : fst R) → square (a -r a) ≡ 0r
  square-self a    = solve! R
  square-sub-neg        : (a b : fst R) → square (negr a -r negr b) ≡ square (a -r b)
  square-sub-neg a b    = solve! R
  square-self+       : (a t : fst R) → square (a -r a) +r t ≡ t
  square-self+ a t   = solve! R
  square-sym        : (a b : fst R) → square (a -r b) ≡ square (b -r a)
  square-sym a b    = solve! R
  expand        : (a b c : fst R) → square (a -r b) +r square ((a -r c) -r (c -r b))
                                  ≡ twice (square (a -r c) +r square (c -r b))
  expand a b c  = solve! R
  shuffle       : (a b c d : fst R) → twice (a +r b) +r twice (c +r d)
                                    ≡ twice ((a +r c) +r (b +r d))
  shuffle a b c d = solve! R
  quarter-four  : (a b : fst R) → twice (twice (a *r b)) ≡ twice (twice a) *r b
  quarter-four a b = solve! R
  zero-twice    : twice (0r +r 0r) ≡ 0r
  zero-twice    = solve! R
  zero-sum      : 0r +r 0r ≡ 0r
  zero-sum      = solve! R

------------------------------------------------------------------------
-- B  THE RATIONAL SCALE.  ℚ as a commutative ring, its squares are
-- nonnegative, and a geometric accuracy scale ε n = 4⁻ⁿ whose only
-- property used anywhere below is that two steps of ε (n+1) rebuild ε n.
------------------------------------------------------------------------

ℚRing : CommRing ℓ-zero
ℚRing = makeCommRing {R = ℚ} 0 1 Q._+_ Q._·_ Q.-_ Q.isSetℚ
  Q.+Assoc Q.+IdR Q.+InvR Q.+Comm Q.·Assoc Q.·IdR Q.·DistL+ Q.·Comm

open Ring ℚRing using (twice) renaming (square to sqQ)
module R = Ring ℚRing

nonneg-sq : (x : ℚ) → 0 O.≤ sqQ x
nonneg-sq x with x O.≟ 0
... | O.lt h = subst (0 O.≤_) (R.square-neg x) (pos-prod (Q.- x) pos-neg)
  where
  pos-neg : 0 O.≤ (Q.- x)
  pos-neg = O.<Weaken≤ 0 (Q.- x)
    (subst2 O._<_ (Q.+InvR x) (Q.+IdL (Q.- x)) (O.<-+o x 0 (Q.- x) h))
  pos-prod : (a : ℚ) → 0 O.≤ a → 0 O.≤ sqQ a
  pos-prod a p = subst (O._≤ sqQ a) (Q.·AnnihilL a) (O.≤-·o 0 a a p p)
... | O.eq p = subst (0 O.≤_) (sym (cong sqQ p ∙ R.square-zero)) (O.isRefl≤ 0)
... | O.gt h = subst (O._≤ sqQ x) (Q.·AnnihilL x)
  (O.≤-·o 0 x x (O.<Weaken≤ 0 x h) (O.<Weaken≤ 0 x h))

nonneg-+ : (x y : ℚ) → 0 O.≤ x → 0 O.≤ y → 0 O.≤ (x Q.+ y)
nonneg-+ x y p q = subst (O._≤ (x Q.+ y)) (Q.+IdR 0) (O.≤Monotone+ 0 x 0 y p q)

quarterQ : ℚ
quarterQ = Q.[ pos 1 / 1+ 3 ]

ε : ℕ → ℚ
ε zero    = 1
ε (suc n) = quarterQ Q.· ε n

ε-pos : (n : ℕ) → 0 O.≤ ε n
ε-pos zero    = 1 , refl
ε-pos (suc n) = subst (O._≤ ε (suc n)) (Q.·AnnihilL (ε n))
  (O.≤-·o 0 quarterQ (ε n) (ε-pos n) (1 , refl))

ε-step : (n : ℕ) → ε (suc n) O.≤ ε n
ε-step n = subst (ε (suc n) O.≤_) (Q.·IdL (ε n))
  (O.≤-·o quarterQ 1 (ε n) (ε-pos n) (3 , refl))

ε-four : (n : ℕ) → twice (twice (ε (suc n))) ≡ ε n
ε-four n = R.quarter-four quarterQ (ε n)
  ∙ cong (Q._· ε n) (Q.eq/ _ _ refl) ∙ Q.·IdL (ε n)

ε-mono : {n m : ℕ} → n ≤ m → ε m O.≤ ε n
ε-mono {n} (k , p) = subst (λ m → ε m O.≤ ε n) p (go k n)
  where
  go : (k n : ℕ) → ε (Cubical.Data.Nat._+_ k n) O.≤ ε n
  go zero    n = O.isRefl≤ (ε n)
  go (suc k) n = O.isTrans≤ (ε (suc (Cubical.Data.Nat._+_ k n))) (ε (Cubical.Data.Nat._+_ k n)) (ε n)
                   (ε-step (Cubical.Data.Nat._+_ k n)) (go k n)

------------------------------------------------------------------------
-- C  A CELL.  A type with a rational squared distance, a padding point,
-- and four laws.  Everything metric below is proved ONCE at this record
-- and then instantiated: the scalar, products, lists of cells, and the
-- graph of an operator are all cells, so the completion is written once.
------------------------------------------------------------------------

record Cell : Type₁ where
  field
    Pt   : Type
    null : Pt
    d    : Pt → Pt → ℚ
    d-pos  : (x y : Pt) → 0 O.≤ d x y
    d-self : (x : Pt) → d x x ≡ 0
    d-sym  : (x y : Pt) → d x y ≡ d y x
    d-tri  : (x y w : Pt) → d x y O.≤ twice (d x w Q.+ d w y)
open Cell

-- the scalar cell
scalarCell : Cell
Pt     scalarCell = ℚ
null   scalarCell = 0
d      scalarCell x y = sqQ (x Q.- y)
d-pos  scalarCell x y = nonneg-sq (x Q.- y)
d-self scalarCell x   = R.square-self x
d-sym  scalarCell x y = R.square-sym x y
d-tri  scalarCell x y w = subst2 O._≤_ (Q.+IdR (sqQ (x Q.- y))) (R.expand x y w)
  (O.≤-o+ 0 (sqQ ((x Q.- w) Q.- (w Q.- y))) (sqQ (x Q.- y))
    (nonneg-sq ((x Q.- w) Q.- (w Q.- y))))

-- the sum of two cell-distances read off one type: products and graphs
sumCell : (K L : Cell) (P : Type) (p : P) (u : P → Pt K) (v : P → Pt L) → Cell
Pt     (sumCell K L P p u v) = P
null   (sumCell K L P p u v) = p
d      (sumCell K L P p u v) x y = d K (u x) (u y) Q.+ d L (v x) (v y)
d-pos  (sumCell K L P p u v) x y = nonneg-+ (d K (u x) (u y)) (d L (v x) (v y)) (d-pos K (u x) (u y)) (d-pos L (v x) (v y))
d-self (sumCell K L P p u v) x = cong₂ Q._+_ (d-self K (u x)) (d-self L (v x)) ∙ R.zero-sum
d-sym  (sumCell K L P p u v) x y = cong₂ Q._+_ (d-sym K (u x) (u y)) (d-sym L (v x) (v y))
d-tri  (sumCell K L P p u v) x y w =
  subst (d K (u x) (u y) Q.+ d L (v x) (v y) O.≤_)
    (R.shuffle (d K (u x) (u w)) (d K (u w) (u y)) (d L (v x) (v w)) (d L (v w) (v y)))
    (O.≤Monotone+ (d K (u x) (u y)) (twice (d K (u x) (u w) Q.+ d K (u w) (u y)))
                  (d L (v x) (v y)) (twice (d L (v x) (v w) Q.+ d L (v w) (v y)))
      (d-tri K (u x) (u y) (u w)) (d-tri L (v x) (v y) (v w)))

prodCell : Cell → Cell → Cell
prodCell K L = sumCell K L (Pt K × Pt L) (null K , null L) fst snd

graphCell : (K : Cell) → (Pt K → Pt K) → Cell
graphCell K g = sumCell K K (Pt K) (null K) (λ x → x) g

-- lists of cells, padded by the cell's null: the finitely supported
-- vectors over a cell, which is again a cell
module ListOf (K : Cell) where
  P : Type
  P = Pt K

  hd : List P → P
  hd []      = null K
  hd (x ∷ _) = x
  tl : List P → List P
  tl []       = []
  tl (_ ∷ xs) = xs

  ld : List P → List P → ℚ
  ld []       []       = 0
  ld []       (y ∷ ys) = d K (null K) y Q.+ ld [] ys
  ld (x ∷ xs) []       = d K x (null K) Q.+ ld xs []
  ld (x ∷ xs) (y ∷ ys) = d K x y Q.+ ld xs ys

  ld-step : (x y : List P) → ld x y ≡ d K (hd x) (hd y) Q.+ ld (tl x) (tl y)
  ld-step []       []       = sym (cong (Q._+ 0) (d-self K (null K)) ∙ Q.+IdL 0)
  ld-step []       (y ∷ ys) = refl
  ld-step (x ∷ xs) []       = refl
  ld-step (x ∷ xs) (y ∷ ys) = refl

  ld-pos : (x y : List P) → 0 O.≤ ld x y
  ld-pos []       []       = O.isRefl≤ 0
  ld-pos []       (y ∷ ys) = nonneg-+ (d K (null K) y) (ld [] ys)
                               (d-pos K (null K) y) (ld-pos [] ys)
  ld-pos (x ∷ xs) []       = nonneg-+ (d K x (null K)) (ld xs [])
                               (d-pos K x (null K)) (ld-pos xs [])
  ld-pos (x ∷ xs) (y ∷ ys) = nonneg-+ (d K x y) (ld xs ys)
                               (d-pos K x y) (ld-pos xs ys)

  ld-self : (x : List P) → ld x x ≡ 0
  ld-self []       = refl
  ld-self (x ∷ xs) = cong₂ Q._+_ (d-self K x) (ld-self xs) ∙ R.zero-sum

  ld-sym : (x y : List P) → ld x y ≡ ld y x
  ld-sym []       []       = refl
  ld-sym []       (y ∷ ys) = cong₂ Q._+_ (d-sym K (null K) y) (ld-sym [] ys)
  ld-sym (x ∷ xs) []       = cong₂ Q._+_ (d-sym K x (null K)) (ld-sym xs [])
  ld-sym (x ∷ xs) (y ∷ ys) = cong₂ Q._+_ (d-sym K x y) (ld-sym xs ys)

  ld-tri-step : (x y w : List P)
    → ld (tl x) (tl y) O.≤ twice (ld (tl x) (tl w) Q.+ ld (tl w) (tl y))
    → ld x y O.≤ twice (ld x w Q.+ ld w y)
  ld-tri-step x y w p = subst2 O._≤_ (sym (ld-step x y)) target
    (O.≤Monotone+ (d K (hd x) (hd y)) (twice (d K (hd x) (hd w) Q.+ d K (hd w) (hd y)))
                  (ld (tl x) (tl y)) (twice (ld (tl x) (tl w) Q.+ ld (tl w) (tl y)))
                  (d-tri K (hd x) (hd y) (hd w)) p)
    where
    target : twice (d K (hd x) (hd w) Q.+ d K (hd w) (hd y))
             Q.+ twice (ld (tl x) (tl w) Q.+ ld (tl w) (tl y))
           ≡ twice (ld x w Q.+ ld w y)
    target = R.shuffle (d K (hd x) (hd w)) (d K (hd w) (hd y))
                       (ld (tl x) (tl w)) (ld (tl w) (tl y))
      ∙ cong twice (cong₂ Q._+_ (sym (ld-step x w)) (sym (ld-step w y)))

  ld-tri : (x y w : List P) → ld x y O.≤ twice (ld x w Q.+ ld w y)
  ld-tri []       []       []       = subst (0 O.≤_) (sym R.zero-twice) (O.isRefl≤ 0)
  ld-tri []       []       (w ∷ ws) = ld-tri-step [] [] (w ∷ ws) (ld-tri [] [] ws)
  ld-tri []       (y ∷ ys) []       = ld-tri-step [] (y ∷ ys) [] (ld-tri [] ys [])
  ld-tri []       (y ∷ ys) (w ∷ ws) = ld-tri-step [] (y ∷ ys) (w ∷ ws) (ld-tri [] ys ws)
  ld-tri (x ∷ xs) []       []       = ld-tri-step (x ∷ xs) [] [] (ld-tri xs [] [])
  ld-tri (x ∷ xs) []       (w ∷ ws) = ld-tri-step (x ∷ xs) [] (w ∷ ws) (ld-tri xs [] ws)
  ld-tri (x ∷ xs) (y ∷ ys) []       = ld-tri-step (x ∷ xs) (y ∷ ys) [] (ld-tri xs ys [])
  ld-tri (x ∷ xs) (y ∷ ys) (w ∷ ws) = ld-tri-step (x ∷ xs) (y ∷ ys) (w ∷ ws) (ld-tri xs ys ws)

  cell : Cell
  Pt     cell = List P
  null   cell = []
  d      cell = ld
  d-pos  cell = ld-pos
  d-self cell = ld-self
  d-sym  cell = ld-sym
  d-tri  cell = ld-tri

  -- a distance-preserving self-map of the cell acts on vectors the same way
  lift-isometry : (h : P → P) → h (null K) ≡ null K
    → ((x y : P) → d K (h x) (h y) ≡ d K x y)
    → (xs ys : List P) → ld (map h xs) (map h ys) ≡ ld xs ys
  lift-isometry h h0 pres []       []       = refl
  lift-isometry h h0 pres []       (y ∷ ys) =
    cong₂ Q._+_ (cong (λ z → d K z (h y)) (sym h0) ∙ pres (null K) y)
                (lift-isometry h h0 pres [] ys)
  lift-isometry h h0 pres (x ∷ xs) []       =
    cong₂ Q._+_ (cong (d K (h x)) (sym h0) ∙ pres x (null K))
                (lift-isometry h h0 pres xs [])
  lift-isometry h h0 pres (x ∷ xs) (y ∷ ys) =
    cong₂ Q._+_ (pres x y) (lift-isometry h h0 pres xs ys)

listCell : Cell → Cell
listCell K = ListOf.cell K

------------------------------------------------------------------------
-- D  THE COMPLETION.  Approximation NAMES — a sequence, a modulus, and
-- the proof that the modulus works — quotiented by mutual approach.  A
-- name is a *presentation* of a point and the quotient is §1's descent:
-- the completion is the visible part, the name is the retained residue.
-- Written once at an arbitrary cell.
--
-- Constructive-analysis reference: Russell O'Connor, "A Monadic,
-- Functional Implementation of Real Numbers" (2006), completion by
-- regular functions and lifting of uniformly continuous maps.
------------------------------------------------------------------------

module Metric (K : Cell) where
  B : ℕ → Pt K → Pt K → Type
  B n x y = d K x y O.≤ ε n

  B-refl : (n : ℕ) (x : Pt K) → B n x x
  B-refl n x = subst (O._≤ ε n) (sym (d-self K x)) (ε-pos n)

  B-sym : (n : ℕ) (x y : Pt K) → B n x y → B n y x
  B-sym n x y = subst (O._≤ ε n) (d-sym K x y)

  B-weaken : {n m : ℕ} → n ≤ m → {x y : Pt K} → B m x y → B n x y
  B-weaken {n} {m} h {x} {y} p = O.isTrans≤ (d K x y) (ε m) (ε n) p (ε-mono h)

  B-tri : (n : ℕ) {x y w : Pt K} → B (suc n) x y → B (suc n) y w → B n x w
  B-tri n {x} {y} {w} p q =
    O.isTrans≤ (d K x w) (twice (d K x y Q.+ d K y w)) (ε n) (d-tri K x w y)
      (subst (twice (d K x y Q.+ d K y w) O.≤_) (ε-four n)
        (O.≤Monotone+ (d K x y Q.+ d K y w) (twice (ε (suc n)))
                      (d K x y Q.+ d K y w) (twice (ε (suc n))) s s))
    where
    s : (d K x y Q.+ d K y w) O.≤ twice (ε (suc n))
    s = O.≤Monotone+ (d K x y) (ε (suc n)) (d K y w) (ε (suc n)) p q

  B-three : (n : ℕ) {x y w v : Pt K}
    → B (suc (suc n)) x y → B (suc (suc n)) y w → B (suc (suc n)) w v → B n x v
  B-three n p q r = B-tri n (B-tri (suc n) p q) (B-weaken {suc n} {suc (suc n)} ≤-sucℕ r)

module Completion (K : Cell) where
  open Metric K public

  Tail : (ℕ → Pt K) → (ℕ → ℕ) → Type
  Tail s m = (n i j : ℕ) → m n ≤ i → m n ≤ j → B n (s i) (s j)

  Name : Type
  Name = Σ[ s ∈ (ℕ → Pt K) ] Σ[ m ∈ (ℕ → ℕ) ] Tail s m

  seq : Name → ℕ → Pt K
  seq = fst
  mod : Name → ℕ → ℕ
  mod s = fst (snd s)
  tail-of : (s : Name) → Tail (seq s) (mod s)
  tail-of s = snd (snd s)

  At : ℕ → Name → Name → Type
  At n s t = Σ[ N ∈ ℕ ] ((i j : ℕ) → N ≤ i → N ≤ j → B n (seq s i) (seq t j))

  CloseTo : Name → Name → Type
  CloseTo s t = (n : ℕ) → At n s t

  Related : Name → Name → Type
  Related s t = ∥ CloseTo s t ∥₁

  -- THE OBJECT
  Space : Type
  Space = Name / Related

  isSetSpace : isSet Space
  isSetSpace = SQ.squash/

  same-seq : (s t : Name) → ((n : ℕ) → seq s n ≡ seq t n) → Related s t
  same-seq s t p = ∣ (λ n → mod s n , λ i j hi hj →
    subst (B n (seq s i)) (p j) (tail-of s n i j hi hj)) ∣₁

  same-point : (s t : Name) → ((n : ℕ) → seq s n ≡ seq t n)
             → Path Space SQ.[ s ] SQ.[ t ]
  same-point s t p = SQ.eq/ s t (same-seq s t p)

  -- the dense cell sits inside its completion as the constant names
  point : Pt K → Name
  point x = (λ _ → x) , (λ _ → zero) , (λ n i j _ _ → B-refl n x)

  embed : Pt K → Space
  embed x = SQ.[ point x ]

  -- Related is an equivalence relation, so by set-quotient effectivity
  -- equality in the completion RECOVERS the approximation data: nothing
  -- is lost by quotienting that was not already a mutual approach.
  Related-refl : (s : Name) → Related s s
  Related-refl s = same-seq s s (λ _ → refl)

  Related-sym : (s t : Name) → Related s t → Related t s
  Related-sym s t = PT.rec PT.squash₁ λ p → ∣ (λ n →
    fst (p n) , λ i j hi hj → B-sym n (seq s j) (seq t i) (snd (p n) j i hj hi)) ∣₁

  Related-trans : (s t u : Name) → Related s t → Related t u → Related s u
  Related-trans s t u = PT.rec2 PT.squash₁ λ p q → ∣ (λ n →
    max (fst (p (suc n))) (fst (q (suc n))) , λ i j hi hj → B-tri n
      (snd (p (suc n)) i (max (fst (p (suc n))) (fst (q (suc n))))
        (≤-trans left-≤-max hi) left-≤-max)
      (snd (q (suc n)) (max (fst (p (suc n))) (fst (q (suc n)))) j
        right-≤-max (≤-trans right-≤-max hj))) ∣₁

  Related-isEquivRel : BinaryRelation.isEquivRel Related
  BinaryRelation.isEquivRel.reflexive  Related-isEquivRel = Related-refl
  BinaryRelation.isEquivRel.symmetric  Related-isEquivRel = Related-sym
  BinaryRelation.isEquivRel.transitive Related-isEquivRel = Related-trans

  effective : (s t : Name) → Path Space SQ.[ s ] SQ.[ t ] → Related s t
  effective = SQ.effective (λ _ _ → PT.squash₁) Related-isEquivRel

  ----------------------------------------------------------------------
  -- COMPLETENESS.  A regular family of names has a diagonal, and the
  -- diagonal is a name whose point every member approaches.
  ----------------------------------------------------------------------

  Regular : (ℕ → Name) → Type
  Regular f = (n i j : ℕ) → n ≤ i → n ≤ j → At n (f i) (f j)

  diagonal : (ℕ → Name) → ℕ → Pt K
  diagonal f i = seq (f i) (mod (f i) i)

  diagonal-tail : (f : ℕ → Name) → Regular f → Tail (diagonal f) (λ n → suc (suc n))
  diagonal-tail f reg n i j hi hj =
    B-three n
      (B-weaken hi (tail-of (f i) i mi p ≤-refl left-≤-max))
      (snd rel p q right-≤-max right-≤-max)
      (B-weaken hj (tail-of (f j) j q mj left-≤-max ≤-refl))
    where
    mi = mod (f i) i
    mj = mod (f j) j
    rel = reg (suc (suc n)) i j hi hj
    p = max mi (fst rel)
    q = max mj (fst rel)

  limit-name : (f : ℕ → Name) → Regular f → Name
  limit-name f reg = diagonal f , (λ n → suc (suc n)) , diagonal-tail f reg

  limit : (f : ℕ → Name) → Regular f → Space
  limit f reg = SQ.[ limit-name f reg ]

  converges : (f : ℕ → Name) (reg : Regular f) (n i : ℕ) → suc (suc n) ≤ i
            → At n (f i) (limit-name f reg)
  converges f reg n i hi = max mi (suc (suc n)) , estimate
    where
    level = suc (suc n)
    mi = mod (f i) level
    estimate : (p q : ℕ) → max mi level ≤ p → max mi level ≤ q
             → B n (seq (f i) p) (diagonal f q)
    estimate p q hp hq = B-three n
      (tail-of (f i) level p r (≤-trans left-≤-max hp) left-≤-max)
      (snd rel r s right-≤-max right-≤-max)
      (B-weaken q-bound (tail-of (f q) q s mq left-≤-max ≤-refl))
      where
      q-bound = ≤-trans right-≤-max hq
      rel = reg level i q hi q-bound
      mq = mod (f q) q
      r = max mi (fst rel)
      s = max mq (fst rel)

-- A uniformly continuous map of cells extends to the completions, and the
-- extension's modulus is the COMPOSITE of the two moduli: the cost of the
-- map composed with the cost of the approximation, written down.
module Extend (K L : Cell) (f : Pt K → Pt L) (modulus : ℕ → ℕ)
  (uniform : (n : ℕ) (x y : Pt K)
           → Metric.B K (modulus n) x y → Metric.B L n (f x) (f y)) where
  module S = Completion K
  module T = Completion L

  map-name : S.Name → T.Name
  map-name (s , m , t) = (λ n → f (s n)) , (λ n → m (modulus n))
    , (λ n i j hi hj → uniform n (s i) (s j) (t (modulus n) i j hi hj))

  modulus-composes : (s : S.Name) (n : ℕ) → T.mod (map-name s) n ≡ S.mod s (modulus n)
  modulus-composes s n = refl

  map-related : (s t : S.Name) → S.Related s t → T.Related (map-name s) (map-name t)
  map-related s t = PT.rec PT.squash₁ λ p → ∣ (λ n →
    fst (p (modulus n)) , λ i j hi hj →
      uniform n (S.seq s i) (S.seq t j) (snd (p (modulus n)) i j hi hj)) ∣₁

  extended : S.Space → T.Space
  extended = SQ.rec SQ.squash/ (λ s → SQ.[ map-name s ])
    (λ s t p → SQ.eq/ (map-name s) (map-name t) (map-related s t p))

  extends-the-dense-map : (x : Pt K) → extended (S.embed x) ≡ T.embed (f x)
  extends-the-dense-map x = T.same-point (map-name (S.point x)) (T.point (f x)) (λ _ → refl)

-- lifting the identity is the identity (needed wherever one leg of a
-- commuting square is trivial)
extended-id : (K : Cell)
  (u : (n : ℕ) (x y : Pt K) → Metric.B K n x y → Metric.B K n x y)
  (x : Completion.Space K) → Extend.extended K K (λ z → z) (λ n → n) u x ≡ x
extended-id K u = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
  Completion.same-point K (Extend.map-name K K (λ z → z) (λ n → n) u s) s (λ n → refl)

-- A distance-preserving equivalence of cells is an identification of their
-- completions: §1's law survives the limit.
module Isometry (K L : Cell) (e : Pt K ≃ Pt L)
  (pres : (x y : Pt K) → d L (equivFun e x) (equivFun e y) ≡ d K x y) where
  module S = Completion K
  module T = Completion L

  fwd-u : (n : ℕ) (x y : Pt K) → S.B n x y → T.B n (equivFun e x) (equivFun e y)
  fwd-u n x y = subst (O._≤ ε n) (sym (pres x y))

  bwd-path : (x y : Pt L) → d L x y ≡ d K (invEq e x) (invEq e y)
  bwd-path x y = cong₂ (d L) (sym (secEq e x)) (sym (secEq e y))
               ∙ pres (invEq e x) (invEq e y)

  bwd-u : (n : ℕ) (x y : Pt L) → T.B n x y → S.B n (invEq e x) (invEq e y)
  bwd-u n x y = subst (O._≤ ε n) (bwd-path x y)

  module F = Extend K L (equivFun e) (λ n → n) fwd-u
  module G = Extend L K (invEq e)    (λ n → n) bwd-u

  back-forth : (x : S.Space) → G.extended (F.extended x) ≡ x
  back-forth = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    S.same-point (G.map-name (F.map-name s)) s (λ n → retEq e (S.seq s n))

  forth-back : (y : T.Space) → F.extended (G.extended y) ≡ y
  forth-back = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    T.same-point (F.map-name (G.map-name s)) s (λ n → secEq e (T.seq s n))

  completion-equiv : S.Space ≃ T.Space
  completion-equiv = isoToEquiv (iso F.extended G.extended forth-back back-forth)

  completion-path : S.Space ≡ T.Space
  completion-path = ua completion-equiv

  -- and transport along it computes, at every point, by §1's uaβ
  completion-transport : (x : S.Space) → transport completion-path x ≡ F.extended x
  completion-transport = uaβ completion-equiv

-- Commuting dense maps still commute after completion.  The four moduli
-- may all differ; what is asserted is equality of represented points.
module Square (C₁ C₂ C₃ C₄ : Cell)
  (f : Pt C₁ → Pt C₂) (g : Pt C₁ → Pt C₃) (h : Pt C₂ → Pt C₄) (k : Pt C₃ → Pt C₄)
  (mf mg mh mk : ℕ → ℕ)
  (uf : (n : ℕ) (x y : Pt C₁) → Metric.B C₁ (mf n) x y → Metric.B C₂ n (f x) (f y))
  (ug : (n : ℕ) (x y : Pt C₁) → Metric.B C₁ (mg n) x y → Metric.B C₃ n (g x) (g y))
  (uh : (n : ℕ) (x y : Pt C₂) → Metric.B C₂ (mh n) x y → Metric.B C₄ n (h x) (h y))
  (uk : (n : ℕ) (x y : Pt C₃) → Metric.B C₃ (mk n) x y → Metric.B C₄ n (k x) (k y))
  (square : (a : Pt C₁) → h (f a) ≡ k (g a)) where
  module F = Extend C₁ C₂ f mf uf
  module G = Extend C₁ C₃ g mg ug
  module H = Extend C₂ C₄ h mh uh
  module J = Extend C₃ C₄ k mk uk
  module S = Completion C₁
  module T = Completion C₄

  completed-square : (x : S.Space) → H.extended (F.extended x) ≡ J.extended (G.extended x)
  completed-square = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    T.same-point (H.map-name (F.map-name s)) (J.map-name (G.map-name s))
      (λ n → square (S.seq s n))

------------------------------------------------------------------------
-- E  THE FOURIER SYMBOL.  The spatial operator of a single mode, over an
-- arbitrary commutative ring: k × ·.  Three identities carry the physics
-- — the square is −|k|², the operator is skew, and the curl of a curl is
-- divergence-free — and the Schrödinger factorisation is `refl`.
------------------------------------------------------------------------

module Fourier {ℓ : Level} (R : CommRing ℓ) where
  open Ring R public

  Vec : Type ℓ
  Vec = fst R × fst R × fst R

  zeroV : Vec
  zeroV = 0r , 0r , 0r
  negV : Vec → Vec
  negV (x , y , z) = negr x , negr y , negr z
  scale : fst R → Vec → Vec
  scale a (x , y , z) = a *r x , a *r y , a *r z
  subV : Vec → Vec → Vec
  subV (x , y , z) (u , v , w) = x -r u , y -r v , z -r w
  dot : Vec → Vec → fst R
  dot (x , y , z) (u , v , w) = (x *r u) +r ((y *r v) +r (z *r w))
  cross : Vec → Vec → Vec
  cross (x , y , z) (u , v , w) =
    (y *r w) -r (z *r v) , (z *r u) -r (x *r w) , (x *r v) -r (y *r u)

  pathV : {x y : Vec} → fst x ≡ fst y → fst (snd x) ≡ fst (snd y)
        → snd (snd x) ≡ snd (snd y) → x ≡ y
  pathV p q r = ΣPathP (p , ΣPathP (q , r))

  -- the Laplacian in disguise: K² = −|k|² on the transverse subspace
  cross-square : (k v : Vec) → cross k (cross k v) ≡ subV (scale (dot k v) k) (scale (dot k k) v)
  cross-square (x , y , z) (u , v , w) = pathV (solve! R) (solve! R) (solve! R)
  -- the operator is skew, so the group it generates is unitary
  skew : (k v w : Vec) → dot (cross k v) w ≡ negr (dot v (cross k w))
  skew (a , b , c) (x , y , z) (u , v , w) = solve! R
  -- transversality is preserved, so the constraint is not an extra equation
  divergence-curl : (k v : Vec) → dot k (cross k v) ≡ 0r
  divergence-curl (x , y , z) (u , v , w) = solve! R
  -- no energy flows out of a mode
  energy-rate-zero : (k v : Vec) → dot v (cross k v) ≡ 0r
  energy-rate-zero (x , y , z) (u , v , w) = solve! R
  cross-neg : (k v : Vec) → cross k (negV v) ≡ negV (cross k v)
  cross-neg (x , y , z) (u , v , w) = pathV (solve! R) (solve! R) (solve! R)
  negV-zero : negV zeroV ≡ zeroV
  negV-zero = pathV neg-zero neg-zero neg-zero
  negV-negV : (v : Vec) → negV (negV v) ≡ v
  negV-negV (x , y , z) = pathV (neg-neg x) (neg-neg y) (neg-neg z)

  -- a complex field amplitude is an interdependent pair of real vectors:
  -- §9's Pair, at ℚ³ instead of Bool
  Fld : Type ℓ
  Fld = Vec × Vec
  zeroF : Fld
  zeroF = zeroV , zeroV

  quarterF : Fld → Fld          -- multiplication by i: §9's `turn`
  quarterF (a , b) = negV b , a
  generator : Vec → Fld → Fld   -- K = k × ·
  generator k (a , b) = cross k a , cross k b
  curlF : Vec → Fld → Fld       -- iK
  curlF k (a , b) = negV (cross k b) , cross k a

  -- MAXWELL IS SCHRÖDINGER AT ONE MODE, definitionally.
  schrodinger-factorization : (k : Vec) (f : Fld) → quarterF (generator k f) ≡ curlF k f
  schrodinger-factorization k f = refl

  duality-natural : (k : Vec) (f : Fld) → generator k (quarterF f) ≡ quarterF (generator k f)
  duality-natural k (a , b) = ΣPathP (cross-neg k b , refl)

  quarterF-zero : quarterF zeroF ≡ zeroF
  quarterF-zero = ΣPathP (negV-zero , refl)

  quarterF⁴ : (f : Fld) → quarterF (quarterF (quarterF (quarterF f))) ≡ f
  quarterF⁴ (a , b) = ΣPathP (negV-negV a , negV-negV b)

------------------------------------------------------------------------
-- F  THE OBJECT.  Not a parameter list: an actual infinite-dimensional
-- space.  Cells are assembled from the scalar by product and list, the
-- completion of §D is taken at that cell, and the operators of §E are
-- lifted to it.  Everything below is about THIS space.
------------------------------------------------------------------------

module FS = Fourier ℚRing
open FS using (Vec ; Fld ; zeroV ; zeroF ; negV ; cross ; quarterF ; generator ; curlF)

cplxCell vecCell fldCell modeCell : Cell
cplxCell = prodCell scalarCell scalarCell      -- ℚ × ℚ, one complex scalar
vecCell  = prodCell scalarCell cplxCell        -- ℚ³
fldCell  = prodCell vecCell vecCell            -- one complex Fourier coefficient
modeCell = listCell fldCell                    -- finitely many coefficients

module M = ListOf fldCell

negV-dist : (u v : Vec) → d vecCell (negV u) (negV v) ≡ d vecCell u v
negV-dist (a , b , c) (x , y , z) =
  cong₂ Q._+_ (R.square-sub-neg a x) (cong₂ Q._+_ (R.square-sub-neg b y) (R.square-sub-neg c z))

quarterF-dist : (x y : Fld) → d fldCell (quarterF x) (quarterF y) ≡ d fldCell x y
quarterF-dist (a , b) (c , e) =
  cong (Q._+ d vecCell a c) (negV-dist b e) ∙ Q.+Comm (d vecCell b e) (d vecCell a c)

rotate : List Fld → List Fld
rotate = map quarterF

rotate-dist : (x y : List Fld) → d modeCell (rotate x) (rotate y) ≡ d modeCell x y
rotate-dist = M.lift-isometry quarterF FS.quarterF-zero quarterF-dist

rotate⁴ : (xs : List Fld) → rotate (rotate (rotate (rotate xs))) ≡ xs
rotate⁴ []       = refl
rotate⁴ (x ∷ xs) = cong₂ _∷_ (FS.quarterF⁴ x) (rotate⁴ xs)

rotateEquiv : Pt modeCell ≃ Pt modeCell
rotateEquiv = isoToEquiv (iso rotate (λ xs → rotate (rotate (rotate xs))) rotate⁴ rotate⁴)

------------------------------------------------------------------------
-- THE SPACE, and §10's phase loop on it.  `Amp` was ℤ²; this is the
-- completed space of rational Fourier data, and the same quarter turn
-- is a path from it to itself whose transport computes.
------------------------------------------------------------------------

rot-u : (n : ℕ) (x y : List Fld)
      → Metric.B modeCell n x y → Metric.B modeCell n (rotate x) (rotate y)
rot-u n x y = subst (O._≤ ε n) (sym (rotate-dist x y))

id-u : (n : ℕ) (x y : List Fld) → Metric.B modeCell n x y → Metric.B modeCell n x y
id-u n x y p = p

module Mode = Completion modeCell

Hilbert : Type
Hilbert = Mode.Space

module PhaseIso = Isometry modeCell modeCell rotateEquiv rotate-dist
module Rot      = Extend modeCell modeCell rotate (λ n → n) rot-u

completed-phase-loop : Hilbert ≡ Hilbert
completed-phase-loop = PhaseIso.completion-path

completed-phase-computes : (x : Hilbert) → transport completed-phase-loop x ≡ Rot.extended x
completed-phase-computes = PhaseIso.completion-transport

completed-phase-four : (x : Hilbert)
  → Rot.extended (Rot.extended (Rot.extended (Rot.extended x))) ≡ x
completed-phase-four = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
  Mode.same-point
    (Rot.map-name (Rot.map-name (Rot.map-name (Rot.map-name s)))) s
    (λ n → rotate⁴ (Mode.seq s n))

-- the completed negation is the square of the quarter turn, exactly as on
-- §9's pair, and it is an involution because the turn has order four
negH : Hilbert → Hilbert
negH x = Rot.extended (Rot.extended x)

negH-involutive : (x : Hilbert) → negH (negH x) ≡ x
negH-involutive = completed-phase-four

-- reading one summand of a sum of nonnegative bounds
left-of-sum : (a b c : ℚ) → 0 O.≤ b → (a Q.+ b) O.≤ c → a O.≤ c
left-of-sum a b c hb h = O.isTrans≤ a (a Q.+ b) c
  (subst (O._≤ (a Q.+ b)) (Q.+IdR a) (O.≤-o+ 0 b a hb)) h

right-of-sum : (a b c : ℚ) → 0 O.≤ a → (a Q.+ b) O.≤ c → b O.≤ c
right-of-sum a b c ha h = O.isTrans≤ b (a Q.+ b) c
  (subst (O._≤ (a Q.+ b)) (Q.+IdL b) (O.≤-+o 0 a b ha)) h

------------------------------------------------------------------------
-- THE OPERATORS.  An unbounded operator is not a map of the space; it is
-- a map out of its GRAPH, and the graph is a cell too (§C), so the same
-- completion applies to it.  Teschl, Mathematical Methods in Quantum
-- Mechanics (2009), §2.2: closure of the graph and the graph norm.
------------------------------------------------------------------------

module Waves (wave : ℕ → ℤ × ℤ × ℤ) where

  waveQ : ℕ → Vec
  waveQ n = Q.[ fst (wave n) / 1+ 0 ]
          , Q.[ fst (snd (wave n)) / 1+ 0 ]
          , Q.[ snd (snd (wave n)) / 1+ 0 ]

  gen : ℕ → List Fld → List Fld
  gen n []       = []
  gen n (x ∷ xs) = generator (waveQ n) x ∷ gen (suc n) xs

  crl : ℕ → List Fld → List Fld
  crl n []       = []
  crl n (x ∷ xs) = curlF (waveQ n) x ∷ crl (suc n) xs

  -- MAXWELL IS SCHRÖDINGER, coefficient by coefficient
  crl-is-phase-gen : (n : ℕ) (xs : List Fld) → rotate (gen n xs) ≡ crl n xs
  crl-is-phase-gen n []       = refl
  crl-is-phase-gen n (x ∷ xs) =
    cong₂ _∷_ (FS.schrodinger-factorization (waveQ n) x) (crl-is-phase-gen (suc n) xs)

  gen-commutes-with-phase : (n : ℕ) (xs : List Fld) → gen n (rotate xs) ≡ rotate (gen n xs)
  gen-commutes-with-phase n []       = refl
  gen-commutes-with-phase n (x ∷ xs) =
    cong₂ _∷_ (FS.duality-natural (waveQ n) x) (gen-commutes-with-phase (suc n) xs)

  K : List Fld → List Fld      -- the spatial operator
  K = gen zero
  iK : List Fld → List Fld     -- its quarter turn: the time derivative
  iK = crl zero

  grCell : Cell
  grCell = graphCell modeCell K

  module Dom = Completion grCell

  Domain : Type
  Domain = Dom.Space

  -- the graph ball controls both coordinates, so each is readable off it
  gr-left : (n : ℕ) (x y : List Fld) → Metric.B grCell n x y → Metric.B modeCell n x y
  gr-left n x y = left-of-sum (M.ld x y) (M.ld (K x) (K y)) (ε n) (M.ld-pos (K x) (K y))

  gr-right : (n : ℕ) (x y : List Fld) → Metric.B grCell n x y → Metric.B modeCell n (K x) (K y)
  gr-right n x y = right-of-sum (M.ld x y) (M.ld (K x) (K y)) (ε n) (M.ld-pos x y)

  iK-dist : (x y : List Fld) → d modeCell (iK x) (iK y) ≡ d modeCell (K x) (K y)
  iK-dist x y = cong₂ (d modeCell) (sym (crl-is-phase-gen zero x)) (sym (crl-is-phase-gen zero y))
              ∙ rotate-dist (K x) (K y)

  gr-curl : (n : ℕ) (x y : List Fld) → Metric.B grCell n x y → Metric.B modeCell n (iK x) (iK y)
  gr-curl n x y p = subst (O._≤ ε n) (sym (iK-dist x y)) (gr-right n x y p)

  -- the quarter turn is an isometry of the GRAPH as well, because it
  -- commutes with the operator
  rotD-dist : (x y : List Fld) → d grCell (rotate x) (rotate y) ≡ d grCell x y
  rotD-dist x y = cong₂ Q._+_ (rotate-dist x y)
    (cong₂ (d modeCell) (gen-commutes-with-phase zero x) (gen-commutes-with-phase zero y)
     ∙ rotate-dist (K x) (K y))

  rotD-u : (n : ℕ) (x y : List Fld) → Metric.B grCell n x y → Metric.B grCell n (rotate x) (rotate y)
  rotD-u n x y = subst (O._≤ ε n) (sym (rotD-dist x y))

  module Curl  = Extend grCell   modeCell iK     (λ n → n) gr-curl
  module Gen   = Extend grCell   modeCell K      (λ n → n) gr-right
  module Incl  = Extend grCell   modeCell (λ x → x) (λ n → n) gr-left
  module RotD  = Extend grCell   grCell   rotate (λ n → n) rotD-u

  module Sch  = Square grCell modeCell modeCell modeCell
                  K iK rotate (λ x → x)
                  (λ n → n) (λ n → n) (λ n → n) (λ n → n)
                  gr-right gr-curl rot-u id-u
                  (crl-is-phase-gen zero)
  module Dual = Square grCell grCell modeCell modeCell
                  rotate K K rotate
                  (λ n → n) (λ n → n) (λ n → n) (λ n → n)
                  rotD-u gr-right gr-right rot-u
                  (gen-commutes-with-phase zero)

  -- ON THE COMPLETED SPACE: the time derivative is the quarter turn of
  -- the spatial operator.  This is Maxwell ≡ Schrödinger, at an object.
  completed-schrodinger : (x : Domain) → Rot.extended (Gen.extended x) ≡ Curl.extended x
  completed-schrodinger x = Sch.completed-square x ∙ extended-id modeCell id-u (Curl.extended x)

  completed-duality : (x : Domain) → Gen.extended (RotD.extended x) ≡ Rot.extended (Gen.extended x)
  completed-duality = Dual.completed-square

------------------------------------------------------------------------
-- G  THE EQUATIONS, at the object.
------------------------------------------------------------------------

module Physics (wave : ℕ → ℤ × ℤ × ℤ) where
  open Waves wave

  -- THE INSTANCE.  Values in the completed space; operators the actual
  -- Fourier cross product and its quarter turn; negation the square of
  -- the quarter turn.  No parameter is left open.
  module Eq = Field {D = Domain} {V = Hilbert} SQ.squash/ negH negH-involutive
                      Curl.extended Gen.extended

  -- every field in the domain, paired with its quarter turn, solves them
  solution : Domain → Σ Eq.Fl Eq.Maxwell
  solution E = (E , RotD.extended E)
    , sym (completed-duality E ∙ completed-schrodinger E)
    , sym (completed-schrodinger (RotD.extended E))
      ∙ cong Rot.extended (completed-duality E)

  schrodinger-solution : Domain → Σ Eq.Fl Eq.Schrodinger
  schrodinger-solution E = transport Eq.maxwell≡schrodinger (solution E)

------------------------------------------------------------------------
-- H  THE COMPLETION RETAINS A DISTINCTION.  Set-quotient effectivity
-- turns equality of completed points back into the approximation data,
-- and a single rational bound then separates two points.  Constructive
-- apartness, from the quotient itself — a setoid cannot state this.
--
-- Proved once at an arbitrary cell, then read at two of them.
------------------------------------------------------------------------

quarter<1 : quarterQ O.< 1
quarter<1 = 2 , refl

separated : (K : Cell) (x y : Pt K) → 1 O.≤ d K x y
          → ¬ (Completion.embed K x ≡ Completion.embed K y)
separated K x y big p = PT.rec (λ ()) contra
  (Completion.effective K (Completion.point K x) (Completion.point K y) p)
  where
  contra : Completion.CloseTo K (Completion.point K x) (Completion.point K y) → ⊥
  contra close = O.isIrrefl< 1 (O.isTrans≤< 1 quarterQ 1 one≤quarter quarter<1)
    where
    one≤quarter : 1 O.≤ quarterQ
    one≤quarter = O.isTrans≤ 1 (d K x y) quarterQ big
      (subst (d K x y O.≤_) (Q.·IdR quarterQ)
        (snd (close 1) (fst (close 1)) (fst (close 1)) ≤-refl ≤-refl))

at-least-one : {x : ℚ} → x ≡ 1 → 1 O.≤ x
at-least-one q = subst (1 O.≤_) (sym q) (O.isRefl≤ 1)

------------------------------------------------------------------------
-- THE SCALAR CASE IS ℝ.  §13's ball at `scalarCell` is (x−y)² ≤ 4⁻ⁿ,
-- that is |x−y| ≤ 2⁻ⁿ: the completion of ℚ at its own metric.  So the
-- constructive reals are not extra machinery here, they are the one-
-- dimensional reading of the same construction — a regular sequence of
-- rationals carrying its modulus, up to mutual approach (O'Connor 2006).
-- They are NOT the classical reals: no least upper bounds, no
-- trichotomy, no compactness is available or claimed.  What IS available
-- is apartness, and it comes from effectivity, not from an axiom.
------------------------------------------------------------------------

module Real = Completion scalarCell

ℝ : Type
ℝ = Real.Space

fromℚ : ℚ → ℝ
fromℚ = Real.embed

scalar-unit : d scalarCell 0 1 ≡ 1
scalar-unit = Q.eq/ _ _ refl

zero-apart-one : ¬ (fromℚ 0 ≡ fromℚ 1)
zero-apart-one = separated scalarCell 0 1 (at-least-one scalar-unit)

-- the same statement at the infinite-dimensional space, same proof
unitMode : List Fld
unitMode = ((1 , 0 , 0) , (0 , 0 , 0)) ∷ []

distance-unit : d modeCell [] unitMode ≡ 1
distance-unit = Q.eq/ _ _ refl

apart : ¬ (Mode.embed [] ≡ Mode.embed unitMode)
apart = separated modeCell [] unitMode (at-least-one distance-unit)

------------------------------------------------------------------------
-- §14  THE MACHINE.  §1 at a step function: the ordinary irreversible
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

