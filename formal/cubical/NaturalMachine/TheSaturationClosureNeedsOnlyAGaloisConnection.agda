{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheSaturationClosureNeedsOnlyAGaloisConnection
--
-- `SaturationAtACutIsIdempotent` proved that Δ 28 §31–32's "re-saturate"
-- is idempotent, and then said, as the load-bearing limitation:
--
--   "§31–32's ↑ and ↓ are min-plus RESIDUATIONS over a semiring-valued
--    kernel … That the former is an instance of the latter is NOT
--    proved here and is not obvious … So what is established is that
--    the SATURATION discipline is sound wherever the adjunction holds —
--    not that Δ 28's particular ↑/↓ satisfy it."
--
-- That sentence names a gap without saying what would close it.  This
-- module says exactly what would: the whole closure argument uses
-- NOTHING about `Type`, `⊆`, or the relation K.  It uses two preorders,
-- two maps, and the two directions of a contravariant Galois connection.
-- Everything else — antitonicity, unit, counit, the triangles,
-- idempotence — is derived.
--
-- So the residuation instance is not a matter of re-proving anything.
-- It is exactly this obligation and no more:
--
--   a preorder on burden profiles, a preorder on residual profiles, and
--
--     galFwd : a ≼ d b → b ⊑ u a
--     galBwd : b ⊑ u a → a ≼ d b
--
--   for the min-plus ↑ and ↓.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   u-antitone / d-antitone   derived, not assumed
--   unit / counit             a ≼ d (u a), b ⊑ u (d b)
--   triangle-in / triangle-out
--   c-inflationary / c-monotone / c-idempotent-in / c-idempotent-out
--   fixedGivesSaturated / saturatedGivesFixed
--   §5: the previous module's Type-valued polarities ARE an instance —
--   `galFwdPred` and `galBwdPred` are one line each, and
--   `saturationIsAnInstance` transports the closure back
--
-- NO NOVELTY.  Contravariant Galois connections and the fact that
-- `d ∘ u` is a closure operator are Birkhoff (`Lattice Theory`, 1940,
-- §V); the general order-theoretic treatment is Ore's ("Galois
-- connexions", *Trans. AMS* 55, 1944), which is where the abstract form
-- used here — two preorders, two antitone maps, one adjunction — is
-- stated.  What is contributed is the reduction of Δ 28 §31–32's
-- residuation obligation to those two lines.
--
-- WHAT IS STILL NOT CLAIMED.  The min-plus instance itself: neither
-- `galFwd` nor `galBwd` is proved for a semiring-valued kernel here,
-- and no quantale is constructed anywhere in this repository.  The
-- idempotence result therefore STILL does not apply to min-plus
-- convolution — this module makes the remaining obligation small and
-- explicit, which is not the same as discharging it.  Reflexivity and
-- transitivity are assumed as data; no antisymmetry is assumed or used,
-- so `≼` is a preorder and the "fixed points" are fixed up to `≼` in
-- both directions, never up to a path.  Tractability is not claimed —
-- §31–32 claims none either.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheSaturationClosureNeedsOnlyAGaloisConnection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)

------------------------------------------------------------------------
-- 1.  The only assumptions: two preorders and one adjunction
------------------------------------------------------------------------

module Galois
  {ℓP ℓQ ℓ≼ ℓ⊑ : Level}
  {P : Type ℓP} {Q : Type ℓQ}
  (_≼_ : P → P → Type ℓ≼)
  (_⊑_ : Q → Q → Type ℓ⊑)
  (≼-refl  : (a : P) → a ≼ a)
  (≼-trans : (a b c : P) → a ≼ b → b ≼ c → a ≼ c)
  (⊑-refl  : (b : Q) → b ⊑ b)
  (⊑-trans : (a b c : Q) → a ⊑ b → b ⊑ c → a ⊑ c)
  (u : P → Q) (d : Q → P)
  (galFwd : (a : P) (b : Q) → a ≼ d b → b ⊑ u a)
  (galBwd : (a : P) (b : Q) → b ⊑ u a → a ≼ d b)
  where

  unit : (a : P) → a ≼ d (u a)
  unit a = galBwd a (u a) (⊑-refl (u a))

  counit : (b : Q) → b ⊑ u (d b)
  counit b = galFwd (d b) b (≼-refl (d b))

  u-antitone : (a a' : P) → a ≼ a' → u a' ⊑ u a
  u-antitone a a' le = galFwd a (u a') (≼-trans a a' (d (u a')) le (unit a'))

  d-antitone : (b b' : Q) → b ⊑ b' → d b' ≼ d b
  d-antitone b b' le = galBwd (d b') b (⊑-trans b b' (u (d b')) le (counit b'))

  ------------------------------------------------------------------
  -- 2.  Saturating a saturated profile changes nothing
  ------------------------------------------------------------------

  triangle-in : (a : P) → u (d (u a)) ⊑ u a
  triangle-in a = u-antitone a (d (u a)) (unit a)

  triangle-out : (a : P) → u a ⊑ u (d (u a))
  triangle-out a = counit (u a)

  ------------------------------------------------------------------
  -- 3.  Hence re-saturation is idempotent
  ------------------------------------------------------------------

  c : P → P
  c a = d (u a)

  c-inflationary : (a : P) → a ≼ c a
  c-inflationary = unit

  c-monotone : (a a' : P) → a ≼ a' → c a ≼ c a'
  c-monotone a a' le = d-antitone (u a') (u a) (u-antitone a a' le)

  c-idempotent-in : (a : P) → c (c a) ≼ c a
  c-idempotent-in a = d-antitone (u a) (u (c a)) (counit (u a))

  c-idempotent-out : (a : P) → c a ≼ c (c a)
  c-idempotent-out a = unit (c a)

  ------------------------------------------------------------------
  -- 4.  Saturated pairs are exactly the fixed points
  ------------------------------------------------------------------

  Saturated : P → Q → Type (ℓ-max ℓ≼ ℓ⊑)
  Saturated a b = ((u a ⊑ b) × (b ⊑ u a)) × ((d b ≼ a) × (a ≼ d b))

  fixedGivesSaturated : (a : P) → c a ≼ a → Saturated a (u a)
  fixedGivesSaturated a fix =
    (⊑-refl (u a) , ⊑-refl (u a)) , (fix , unit a)

  saturatedGivesFixed : (a : P) (b : Q) → Saturated a b → c a ≼ a
  saturatedGivesFixed a b ((_ , bu) , (da , _)) =
    ≼-trans (c a) (d b) a (d-antitone b (u a) bu) da

------------------------------------------------------------------------
-- 5.  The previous module's polarities are an instance
--
-- Two one-line proofs, which is the point: this is the entire cost of
-- being an instance, and it is what the min-plus residuations still owe.
------------------------------------------------------------------------

_⊆_ : {ℓ : Level} {A : Type ℓ} → (A → Type) → (A → Type) → Type ℓ
_⊆_ {A = A} S T = (a : A) → S a → T a

⊆-refl : {ℓ : Level} {A : Type ℓ} (S : A → Type) → S ⊆ S
⊆-refl S a s = s

⊆-trans : {ℓ : Level} {A : Type ℓ} (S T U : A → Type) → S ⊆ T → T ⊆ U → S ⊆ U
⊆-trans S T U f g a s = g a (f a s)

module Polarity {X Y : Type} (K : X → Y → Type) where

  up : (X → Type) → (Y → Type)
  up A y = (x : X) → A x → K x y

  dn : (Y → Type) → (X → Type)
  dn B x = (y : Y) → B y → K x y

  galFwdPred : (A : X → Type) (B : Y → Type) → A ⊆ dn B → B ⊆ up A
  galFwdPred A B h y b x a = h x a y b

  galBwdPred : (A : X → Type) (B : Y → Type) → B ⊆ up A → A ⊆ dn B
  galBwdPred A B h x a y b = h y b x a

  -- and the whole closure theory transports, with nothing re-proved
  open Galois {P = X → Type} {Q = Y → Type}
              _⊆_ _⊆_ ⊆-refl ⊆-trans ⊆-refl ⊆-trans
              up dn galFwdPred galBwdPred
    public
