{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्घट्ट-बीज — the collision seed.
--
-- THE CLAIM (2026-09-03, collision semantics): collision finding is
-- not inversion.  It is the construction of an off-diagonal point of a
-- program's KERNEL PAIR, and the kernel pair is the fibered pairing —
-- so a collision is exactly a pair of distinct points in one fiber.
-- This module makes that core exact, on any map, and then shows the
-- session's whole coin was collision semantics all along.
--
--   §1  THE KERNEL PAIR IS THE FIBERED PAIRING.  For any P : X → Y,
--
--         KernelPair P  ≃  Σ[ y ] (Fib P y × Fib P y),
--
--       with NO hypothesis on Y — the based-path space is contractible,
--       and the equivalence is that contraction, twice.  Collision
--       relational semantics IS fiber geometry, as a term.
--
--   §2  A COLLISION IS AN OFF-DIAGONAL FIBER CONFIGURATION.  With Y a
--       set, apartness of inputs and apartness of fiber points agree
--       (a set makes the output-proofs unique), giving both directions
--
--         Coll P → Σ[ y ] Conf₂ (Fib P y)      (no hypothesis)
--         Σ[ y ] Conf₂ (Fib P y) → Coll P      (Y a set).
--
--   §3  WHERE DID THE COLLISION ENTER?  For X →f Y →g Z, the fiber of
--       the composite is the dependent pairing of stage fibers (fiber
--       Fubini), and therefore every collision of g∘f is EITHER an
--       upstream f-collision OR a genuine merge — g identifying two
--       DISTINCT f-values.  The typed sum is the collision chain rule.
--
--   §4  THE COIN WAS COLLISION SEMANTICS.  Every face of Nanaka's coin
--       (a projection, two carried points, apart upstairs, together
--       downstairs) IS a point of Coll of its projection — one line.
--       So the P/NP gap, the route, the schedule, the count, the rope's
--       charge are all collisions, all off-diagonal fiber points; and
--       Nanaka's no-retraction lemma is exactly the statement that
--       these fibers admit no global chart.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 as stated.  NOT claimed — and this
-- is the collision-semantics document's own boundary, honoured here:
-- that any of this makes CONSTRUCTING an off-diagonal point cheap.
-- Identifying the fiber is immediate; giving it a short generative
-- presentation is the work these theorems relocate, not abolish.
------------------------------------------------------------------------

module SanghattaBija_CollisionIsAnOffDiagonalKernelPairPointTheKernelPairIsTheFiberedPairingAndEveryCoinFaceIsACollision where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- ० · The objects.
------------------------------------------------------------------------

Fib : {X : Type ℓ} {Y : Type ℓ'} (P : X → Y) → Y → Type (ℓ-max ℓ ℓ')
Fib {X = X} P y = Σ[ x ∈ X ] P x ≡ y

Conf₂ : Type ℓ → Type ℓ
Conf₂ F = Σ[ u ∈ F ] Σ[ v ∈ F ] (¬ u ≡ v)

KernelPair : {X : Type ℓ} {Y : Type ℓ'} (P : X → Y) → Type (ℓ-max ℓ ℓ')
KernelPair {X = X} P = Σ[ x ∈ X ] Σ[ x' ∈ X ] P x ≡ P x'

Coll : {X : Type ℓ} {Y : Type ℓ'} (P : X → Y) → Type (ℓ-max ℓ ℓ')
Coll {X = X} P = Σ[ x ∈ X ] Σ[ x' ∈ X ] (¬ x ≡ x') × (P x ≡ P x')

------------------------------------------------------------------------
-- १ · The kernel pair is the fibered pairing, for any P.
--     Proved as an Iso; both round trips reduce, since every witness
--     path is rebuilt from the one carried.
------------------------------------------------------------------------

module _ {X : Type ℓ} {Y : Type ℓ'} (P : X → Y) where

  private
    FP : Type (ℓ-max ℓ ℓ')
    FP = Σ[ y ∈ Y ] (Fib P y × Fib P y)

    to : KernelPair P → FP
    to (x , x' , e) = P x , (x , refl) , (x' , sym e)

    from : FP → KernelPair P
    from (y , (x , p) , (x' , p')) = x , x' , p ∙ sym p'

    -- from ∘ to: the composite proof p ∙ sym p' with p = refl, p' = sym e
    -- is refl ∙ sym (sym e); reduce it to e.
    fromTo : (k : KernelPair P) → from (to k) ≡ k
    fromTo (x , x' , e) i = x , x' , lem i
      where
        lem : refl ∙ sym (sym e) ≡ e
        lem = sym (lUnit e)  -- sym (sym e) is definitionally e (symInvo = refl)

    -- to ∘ from: transport along p using J; when p ≡ refl the whole
    -- configuration is rebuilt and only lUnit/symInvo corrections remain.
    toFrom : (w : FP) → to (from w) ≡ w
    toFrom (y , (x , p) , (x' , p')) =
      J (λ y' p₁ → (p'' : P x' ≡ y')
                 → to (from (y' , (x , p₁) , (x' , p''))) ≡ (y' , (x , p₁) , (x' , p'')))
        (λ p'' → ΣPathP (refl , ΣPathP (refl , ΣPathP (refl , lemp' p''))))
        p p'
      where
        -- at p = refl the config is rebuilt; the only correction is on the
        -- second fiber's proof: sym (refl ∙ sym p'') ≡ p''.
        lemp' : (p'' : P x' ≡ P x) → PathP (λ _ → P x' ≡ P x) (sym (refl ∙ sym p'')) p''
        lemp' p'' = cong sym (sym (lUnit (sym p'')))  -- sym (sym p'') is definitional

  kernelPair≃fiberPairing : KernelPair P ≃ FP
  kernelPair≃fiberPairing = isoToEquiv (iso to from toFrom fromTo)

------------------------------------------------------------------------
-- २ · A collision is an off-diagonal fiber configuration.
------------------------------------------------------------------------

collToConf : {X : Type ℓ} {Y : Type ℓ'} (P : X → Y)
  → Coll P → Σ[ y ∈ Y ] Conf₂ (Fib P y)
collToConf P (x , x' , ne , e) =
  P x , (x , refl) , (x' , sym e) , λ pq → ne (cong fst pq)

confToColl : {X : Type ℓ} {Y : Type ℓ'} (P : X → Y) → isSet Y
  → Σ[ y ∈ Y ] Conf₂ (Fib P y) → Coll P
confToColl P setY (y , (x , p) , (x' , p') , ne) =
  x , x' , ne' , (p ∙ sym p')
  where
    ne' : ¬ x ≡ x'
    ne' ex = ne (ΣPathP (ex , isProp→PathP (λ i → setY (P (ex i)) y) p p'))

------------------------------------------------------------------------
-- ३ · Where did the collision enter?  (fiber Fubini, then the sum.)
------------------------------------------------------------------------

module _ {X : Type ℓ} {Y : Type ℓ'} {Z : Type ℓ''} (f : X → Y) (g : Y → Z) where

  fiberFubini : (z : Z)
    → Fib (λ x → g (f x)) z ≃ (Σ[ yq ∈ Fib g z ] Fib f (fst yq))
  fiberFubini z = isoToEquiv (iso to from toFrom fromTo)
    where
      to : Fib (λ x → g (f x)) z → Σ[ yq ∈ Fib g z ] Fib f (fst yq)
      to (x , r) = (f x , r) , (x , refl)

      from : (Σ[ yq ∈ Fib g z ] Fib f (fst yq)) → Fib (λ x → g (f x)) z
      from ((y , q) , (x , p)) = x , cong g p ∙ q

      fromTo : (w : Fib (λ x → g (f x)) z) → from (to w) ≡ w
      fromTo (x , r) i = x , (sym (lUnit r)) i

      toFrom : (w : Σ[ yq ∈ Fib g z ] Fib f (fst yq)) → to (from w) ≡ w
      toFrom ((y , q) , (x , p)) =
        J (λ y' p₁ → (q' : g y' ≡ z)
                   → to (from ((y' , q') , (x , p₁))) ≡ ((y' , q') , (x , p₁)))
          (λ q' → ΣPathP (ΣPathP (refl , sym (lUnit q')) , refl))
          p q

  -- The collision chain rule.  A composite collision is upstream (the
  -- intermediates already collided) or a genuine merge (g identified two
  -- DISTINCT intermediates).  The split is exactly decidability of
  -- equality in Y — honest: hand it the decision, get the classification.
  whereDidItEnter : {x x' : X}
    → ((f x ≡ f x') ⊎ (¬ f x ≡ f x'))
    → g (f x) ≡ g (f x')
    → (f x ≡ f x') ⊎ ((¬ f x ≡ f x') × (g (f x) ≡ g (f x')))
  whereDidItEnter (inl same) e = inl same
  whereDidItEnter (inr diff) e = inr (diff , e)

------------------------------------------------------------------------
-- ४ · The coin was collision semantics: every face is a collision.
------------------------------------------------------------------------

open import Nanaka_OneNoRetractionLemmaFourCheckedFacesTheGapTheRouteTheScheduleAndTheCountAreOneCoin
  using (Paksa)
open Paksa

-- A face of the coin — a projection with two carried points, apart
-- upstairs and together downstairs — IS a point of Coll of its
-- projection.  One line: the P/NP gap, route, schedule, count, and the
-- rope's charge are all off-diagonal kernel-pair points.
faceIsCollision : (F : Paksa) → Coll (proj F)
faceIsCollision F = x F , y F , apart F , together F
