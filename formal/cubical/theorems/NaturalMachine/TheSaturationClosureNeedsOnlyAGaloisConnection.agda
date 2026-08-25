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

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "the min-plus instance itself: neither `galFwd` nor `galBwd` is
--    proved for a semiring-valued kernel here, and no quantale is
--    constructed anywhere in this repository."
--
-- Paid AT ONE CUT, with real min-plus data, in
-- `NaturalMachine.MinPlusResiduationIsAGaloisConnectionAtOneCut`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
--   ∸-adjˡ / ∸-adjʳ   K ∸ ψ ≤ φ ⟺ K ≤ φ + ψ, which v0.5 does not ship
--   galFwd / galBwd   both directions for `u = d = (K ∸_)`, and they
--                     are the SAME statement once `+` is commuted
--   MinPlusCut        `module Galois` instantiated — antitonicity,
--                     unit, counit, triangles, idempotence of
--                     `c a = K ∸ (K ∸ a)` and the fixed-point
--                     characterisation, with NOTHING re-proved
--
-- THE ORDER HAD TO BE REVERSED, and that is the content, not
-- bookkeeping.  In min-plus lower cost is better, so the quantale order
-- is ℕ's `≤` backwards.  Under ℕ's own order the same maps are not a
-- Galois connection at all: `truncationBreaksTheNaiveOrder` exhibits
-- `K = 0, φ = 0, ψ = 5`, where one side holds and the other does not,
-- because `∸` truncates.  The obligation is dischargeable or false
-- depending on which way the order points.
--
-- STILL NOT CLAIMED, and it is the larger half: ONE CUT is one burden
-- and one residual, `X = Y = Unit`, so no infimum over an index appears.
-- Δ 28's cut carries a PROFILE on each side and its `↑` takes a meet
-- over all burdens — that needs `min` over a finite index and its
-- universal property, not built.  **So what this settles is that the
-- obstruction is NOT the residuation law; it is the meet.**  No `∞` is
-- adjoined, so that is ℕ and not the min-plus semiring proper, and
-- convolution does not appear.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above — including the 2026-08-19 append above it, half of which
-- is what is being corrected.  TWO items, and they are of different
-- kinds.
--
-- ────────────────────────────────────────────────────────────────────
-- (1)  THE TITLE IS EARNED, AND SAYING SO IS PART OF THE AUDIT.
--
-- All six of `module Galois`'s hypotheses are consumed: `≼-refl` in
-- `counit`; `≼-trans` in `u-antitone` and `saturatedGivesFixed`;
-- `⊑-refl` in `unit` and `fixedGivesSaturated`; `⊑-trans` in
-- `d-antitone`; both adjunction directions throughout.  Nothing is
-- assumed and unused.  This was checked by a sweep whose four previous
-- findings were all overclaims, and a sweep that only ever finds faults
-- is not auditing — so the negative result is recorded here rather than
-- left silent.
--
-- **WHAT THIS MODULE DOES NOT SHOW is that its package is the ONLY
-- sufficient one**, which is what "needs only X" invites a reader to
-- conclude.  §"WHAT IS STILL NOT CLAIMED" above lists the min-plus
-- instance, antisymmetry and tractability, and does not mention the
-- alternative presentation.  At commit 10c5bca1,
-- `NaturalMachine.TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms`:
-- `FromUnitCounit` derives `galFwd`/`galBwd` from `u-antitone`,
-- `d-antitone`, `unit`, `counit` — one line each — and then transports
-- this entire module by `open Galois … public`, nothing re-proved;
-- `RoundTrip` shows out-and-back is the identity when the order
-- relations are proposition-valued.
--
-- **AND THE TWO PACKAGES NEED DIFFERENT AXIOMS.**  unit/counit ⟹
-- adjunction uses ONLY the two transitivities.  Adjunction ⟹
-- unit/counit is exactly where reflexivity enters, above.  So they are
-- interderivable over a preorder and NOT interderivable over a bare
-- transitive relation.
--
-- ────────────────────────────────────────────────────────────────────
-- (2)  A CORRECTION THAT WAS RECORDED AT ONE SITE AND NOT AT THIS ONE.
--
-- The append above ends: *"its `↑` takes a meet over all burdens — that
-- needs `min` over a finite index and its universal property, not
-- built."*  **Both halves of that are now wrong.**
--
--   THE OPERATION.  The min-plus order is ℕ's `≤` REVERSED — the same
--   append says so three lines earlier — so a meet in it is a JOIN in
--   ℕ.  The operation is `max`, not `min`.  That correction was made in
--   `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`, whose header
--   states it as its own finding, and it was recorded THERE AND NOWHERE
--   ELSE.  The wrong word survived here, in a file that had already
--   written down the reversal that refutes it.
--
--   "NOT BUILT".  Built.  The meet with its universal property is in
--   that module; the two-sided profile cut is at 89c9b7f0 and then,
--   over an ARBITRARY residual index list with no `∞` and no
--   restriction, at 8f3acebb.  The intermediate claim that the empty
--   meet forced `ℕ ⊎ ∞` was mine and was itself wrong; retracted at
--   819e0a57.
--
-- **THIS IS A DIFFERENT FAILURE MODE FROM THE OTHERS THIS SWEEP HAS
-- FOUND, AND WORTH NAMING.**  Nothing here was ever an overclaim: the
-- sentence was true when written and was corrected elsewhere later.
-- What failed is PROPAGATION — a correction recorded at one of the two
-- sites carrying the same wrong word.  Grepping for the word, not for
-- the module, is what catches it.
--
-- WHAT IS NOT RETRACTED.  Everything else above.  §1–§5 are unaltered
-- and true; the reduction of Δ 28 §31–32's obligation to two lines
-- stands; the reversal paragraph in the earlier append is correct and
-- is what convicts the sentence three lines below it.  CONVOLUTION is
-- still absent everywhere, so Δ 28's COMPOSITION step remains untouched
-- by any of this.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  Short, because this is the third append here and the
-- record must not outgrow the mathematics.
--
-- **RETRACTED, from the block immediately above: "and it was recorded
-- THERE AND NOWHERE ELSE."**  False.
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut` also carries the
-- correction, in its own words, in its own earlier append.  The
-- correction had reached two of its three sites; one was missed — this
-- one.  Recorded at 94054b52, with the reason I got it wrong: I grepped
-- for the wrong phrase and read the hit count instead of the files, and
-- a grep for a wrong word finds the corrections too, because a
-- correction must quote what it corrects.
--
-- The substantive half stands unchanged: the wrong word DID survive
-- here, unpropagated, and is corrected above.
------------------------------------------------------------------------
