-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- IndraNet
--
-- The synchronic side of the Eternal Golden Braid
-- (notes/ETERNAL_GOLDEN_BRAID_DELTA25.md), four of its formalization
-- targets as checked terms:
--
-- T25.A — Yoneda jewel theorem, univalent-groupoid case.  The
--   reflection profile of a jewel x is the family z ↦ (z ≡ x); a
--   thread x ≡ y is EXACTLY a transformation between whole profiles:
--
--     ((z : A) → z ≡ x → z ≡ y) ≃ (x ≡ y).
--
--   And "all in one" is literal: the profile's total space is the
--   singleton, contractible onto the jewel (`profileContractsToJewel`).
--
-- T25.B — Rooted reflection total space.  Root(U,Φ) = Σ[ x ∈ U ] Φ x,
--   the projection forgets the root, and the fiber over x is Φ x —
--   "the net as seen from this jewel" (library `fiberEquiv`, inherited
--   as instructed rather than re-proved).
--
-- T25.F — Local discovery propagation.  A new thread e : x ≡ y updates
--   every rooted profile functorially (`threadUpdatesProfiles`), every
--   dependent view transports (`viewTransport`), and a separator's tear
--   is visible from every jewel that reaches both sides
--   (`tearVisibleEverywhere`).  One local Braid event reweaves the Net
--   globally by transport, not by broadcast.
--
-- T25.D — Guarded Indra equation, in the guardedness approximation.
--   cubical v0.5 has no later modality; the coinductive record with
--   --guardedness realizes the domain equation
--
--     Net x ≃ L x × ((y : J) → Net y)
--
--   with productivity enforced syntactically (`weave` is a total
--   corecursive section), the unfolding equivalence proved
--   (`netUnfold`), and the path principle proved: bisimulation is
--   identity (`bisim→path`).  Identity in the Net IS relational
--   identity — finality's "to be is to be observable", as a term.
--   The ▷-modality refinement and clock quantification remain open and
--   are recorded in the note, not claimed here.
------------------------------------------------------------------------

module IndraNet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Transport using (substEquiv)
open import Cubical.Foundations.Path using (compPathrEquiv)
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Functions.Fibration using (fiberEquiv)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- T25.A — the Yoneda jewel theorem for the univalent groupoid case

module _ {ℓ : Level} {A : Type ℓ} where

  -- the contravariant reflection profile of a jewel
  Profile : A → (A → Type ℓ)
  Profile x = λ z → z ≡ x

  -- "all in one", literally: the total space of a jewel's whole
  -- reflection profile contracts onto the jewel
  profileContractsToJewel : (x : A) → isContr (Σ[ z ∈ A ] Profile x z)
  profileContractsToJewel x .fst = x , refl
  profileContractsToJewel x .snd (z , q) i = q (~ i) , λ j → q (~ i ∨ j)

  -- a thread between jewels is exactly a transformation of whole
  -- reflection profiles: Map(x,y) ≃ [Profile x, Profile y]
  yonedaJewel : (x y : A)
    → ((z : A) → Profile x z → Profile y z) ≃ (x ≡ y)
  yonedaJewel x y = isoToEquiv (iso ev lift* ev-lift lift-ev)
    where
    ev : ((z : A) → z ≡ x → z ≡ y) → x ≡ y
    ev φ = φ x refl
    lift* : x ≡ y → (z : A) → z ≡ x → z ≡ y
    lift* p z q = q ∙ p
    ev-lift : (p : x ≡ y) → refl ∙ p ≡ p
    ev-lift p = sym (lUnit p)
    -- pointwise, by path induction on the incoming thread (sym q runs
    -- x → z; sym (sym q) is definitionally q in cubical)
    pointwise : (φ : (z : A) → z ≡ x → z ≡ y) (z : A) (q : z ≡ x)
      → q ∙ φ x refl ≡ φ z q
    pointwise φ z q =
      J (λ w p → sym p ∙ φ x refl ≡ φ w (sym p))
        (sym (lUnit (φ x refl)))
        (sym q)
    lift-ev : (φ : (z : A) → z ≡ x → z ≡ y) → (λ z q → q ∙ φ x refl) ≡ φ
    lift-ev φ i z q = pointwise φ z q i

------------------------------------------------------------------------
-- T25.B — the rooted reflection total space Σ x . Φ x

module Rooted {U : Type ℓ} (Φ : U → Type ℓ') where

  Root : Type (ℓ-max ℓ ℓ')
  Root = Σ[ x ∈ U ] Φ x

  -- forgetting the distinguished root
  unroot : Root → U
  unroot = fst

  -- the fiber over a jewel IS its rooted view Φ x — the reflection
  -- fiber is the net-as-seen-from-this-jewel (inherited: HoTT 4.8.1)
  rootFiber : (x : U) → fiber unroot x ≃ Φ x
  rootFiber x = fiberEquiv Φ x

------------------------------------------------------------------------
-- T25.F — a local Braid event propagates through the whole Net

module _ {ℓ ℓ' : Level} {A : Type ℓ} where

  -- a new thread e : x ≡ y updates the reflection profile at EVERY
  -- jewel z, functorially, with no broadcast: post-composition
  threadUpdatesProfiles : {x y : A} (e : x ≡ y)
    → (z : A) → Profile x z ≃ Profile y z
  threadUpdatesProfiles e z = compPathrEquiv e

  -- every dependent view (family over the net) transports along the
  -- thread: the Braid updates every jewel at once
  viewTransport : {x y : A} (P : A → Type ℓ') (e : x ≡ y) → P x ≃ P y
  viewTransport = substEquiv

  -- a separator's tear is visible from every rooted view that reaches
  -- both of its sides: no jewel can hold q : z ≡ x and r : z ≡ y once
  -- x and y are torn apart
  tearVisibleEverywhere : {x y : A}
    → ¬ x ≡ y
    → (z : A) → ¬ (Profile x z × Profile y z)
  tearVisibleEverywhere tear z (q , r) = tear (sym q ∙ r)

------------------------------------------------------------------------
-- T25.D — the coinductive Net, guardedness form

module Coinductive {J : Type ℓ} (L : J → Type ℓ') where

  -- the guarded Indra equation J_x ≃ L_x × ∏_y (view of y), with the
  -- later modality replaced by coinductive guardedness: reflections of
  -- reflections unfold one observation later
  record Net (x : J) : Type (ℓ-max ℓ ℓ') where
    coinductive
    field
      local : L x
      image : (y : J) → Net y

  open Net

  -- productivity: from bare local data, the infinite mutual weave is a
  -- total corecursive section — every jewel's view exists at once
  weave : ((x : J) → L x) → (x : J) → Net x
  weave ℓoc x .local = ℓoc x
  weave ℓoc x .image y = weave ℓoc y

  -- the domain equation is solved, not merely postulated: observing
  -- and rebuilding are inverse
  reroot : {x : J} → L x × ((y : J) → Net y) → Net x
  reroot (l , f) .local = l
  reroot (l , f) .image = f

  -- bisimulation: pointwise local agreement, corecursively
  record Bisim {x : J} (m n : Net x) : Type (ℓ-max ℓ ℓ') where
    coinductive
    field
      localEq : m .local ≡ n .local
      imageB  : (y : J) → Bisim (m .image y) (n .image y)

  open Bisim

  -- the path principle: identity in the Net IS relational identity.
  -- Two jewel-views are equal exactly when no observation separates
  -- them — coalgebraic "to be is to be observable", as a term.
  bisim→path : {x : J} {m n : Net x} → Bisim m n → m ≡ n
  bisim→path b i .local = b .localEq i
  bisim→path b i .image y = bisim→path (b .imageB y) i

  bisimRefl : {x : J} (m : Net x) → Bisim m m
  bisimRefl m .localEq = refl
  bisimRefl m .imageB y = bisimRefl (m .image y)

  -- the unfolding equivalence Net x ≃ L x × ∏_y Net y: coinductive
  -- records lack eta, so the record-side round trip is by coinduction
  netUnfold : (x : J) → Net x ≃ (L x × ((y : J) → Net y))
  netUnfold x = isoToEquiv (iso obs reroot (λ _ → refl) back)
    where
    obs : Net x → L x × ((y : J) → Net y)
    obs m = m .local , m .image
    back : (m : Net x) → reroot (m .local , m .image) ≡ m
    back m = bisim→path (rebuild m)
      where
      rebuild : (m : Net x) → Bisim (reroot (m .local , m .image)) m
      rebuild m .localEq = refl
      rebuild m .imageB y = bisimRefl (m .image y)

  -- the rooted totalization of the coinductive Net, closing the loop
  -- with T25.B: jewels together with their infinite rooted views
  IndraRoot : Type (ℓ-max ℓ ℓ')
  IndraRoot = Σ[ x ∈ J ] Net x
