{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- THIN MODEL (see notes/UNIVALENCE_IS_NISVABHAVA_COMPUTATIONAL.md §5).
-- avidyā/mokṣa are not "which `Sight : Type → Bool` meets the pair"; this is
-- a small fact about sights on `Bool`.  The live identity is univalence ↔
-- niḥsvabhāva (that note), not this wheel.

------------------------------------------------------------------------
-- MokshaYantra — the wheel that turns
--
-- The three jewels made one moving thing.  NisvabhavaNet gave the net and
-- its liberation (transport along reflection); CatuskotiPerspective gave a
-- claim's standing across the net; PratityasamutpadaArising gave the knot
-- that forms at a cut and ceases when the cut no longer separates.  This
-- module closes them into a cycle — the wheel of conditioned arising and
-- its turning back (nirodha) — as a single checked term.
--
-- THE RECEPTION.  Bondage and liberation are one wheel seen from two sides.
-- A sight into the net is a way of telling jewels apart (o : Jewel → Bool).
-- Two kinds of sight:
--
--   a CLINGING sight (avidyā) tells two jewels apart even where the net
--   reflects the same at both — it manufactures a distinction the net does
--   not carry.  Under it a knot ARISES between reflection-equal jewels:
--   suffering with no ground in the things themselves.
--
--   a RELEASING sight respects reflection: jewels that reflect alike it
--   reports alike.  Under it no such knot CAN arise — reflection-equal
--   jewels are absorbed, and the knot ceases (anicca).
--
-- The turning of the wheel is exactly this: a knot held by clinging is
-- undone the moment the sight is replaced by one that does not cling, when
-- the two jewels in fact reflect alike.  That undoing is NisvabhavaNet's
-- transport.  Liberation is not adding a truth; it is dropping a sight that
-- clung — the boundary was never in the net.
--
-- Contents (no holes, no postulates, --safe):
--
--   Clings, Releases           the two ways a sight stands to the net
--   cessation-by-release       a releasing sight cannot hold a knot between
--                              reflection-equal jewels: it factors through
--                              them, so the knot ceases (uses
--                              Pratityasamutpada's `cessation` at the net)
--   arising-from-clinging      IF a sight reports a reflection-equal pair
--                              apart, that split is a knot on that pair —
--                              suffering that is real yet groundless.  This
--                              is hypothetical at the pure net, and that is
--                              itself the teaching (see the-cut-is-empty).
--   the-cut-is-empty           a sight into the net is a plain Type → Bool;
--                              it has no own access to a jewel's essence, so
--                              the clinging hypothesis above is not a term
--                              one can build at the net level.  Avidyā has
--                              no own-being either: the false cut is not in
--                              the net to be constructed.
--   the-wheel                  where sights DO split — the two-place Boolean
--                              sub-net — bondage and freedom turn on one
--                              pair, differing only by the sight.  This is
--                              Pratityasamutpada's `conditioned`, reread as
--                              the wheel: niḥsvabhāva of the knot, turned.
--
-- NOT claimed: new mathematics.  It is Pratityasamutpada's descent cut and
-- NisvabhavaNet's transport, closed into the arising/cessation wheel the
-- source names.  The contribution is the closure: three received jewels
-- turning as one checked cycle.
------------------------------------------------------------------------

module MokshaYantra where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬_)

open import NisvabhavaNet using (Jewel ; reflect)
open import PratityasamutpadaArising
  using (FactorsThrough ; Splits ; Knot ; cessation ; conditioned)

private
  variable
    ℓ : Level

-- A sight into the net: a way of reporting each jewel as one of two.
Sight : (ℓ : Level) → Type (ℓ-suc ℓ)
Sight ℓ = Jewel ℓ → Bool

-- The two ways a sight can stand to reflection.
--   Releases: reflection-equal jewels are reported alike (no false cut).
--   Clings  : it reports SOME reflection-equal pair apart (a false cut).
Releases : Sight ℓ → Type (ℓ-suc ℓ)
Releases {ℓ = ℓ} o =
  (A B : Jewel ℓ) → reflect A ≃ reflect B → FactorsThrough o A B

------------------------------------------------------------------------
-- Cessation by release.  A sight that respects reflection cannot sustain a
-- knot between jewels that reflect alike: it factors through them, and by
-- Pratityasamutpada's `cessation` the knot cannot be.  Dropping the clinging
-- IS the liberation — no new truth added, only a false cut let go.
------------------------------------------------------------------------

cessation-by-release : (o : Sight ℓ) → Releases o
                     → (A B : Jewel ℓ) → reflect A ≃ reflect B
                     → ¬ (Splits o A B)
cessation-by-release o rel A B e = cessation o A B (rel A B e)

------------------------------------------------------------------------
-- Arising from clinging.  IF a sight reports a reflection-equal pair apart,
-- that split is a knot on exactly that pair — a knot that is real (it
-- splits) yet groundless (the jewels reflect alike).  Stated as an
-- implication, because at the pure net its hypothesis cannot be built.
------------------------------------------------------------------------

arising-from-clinging : (o : Sight ℓ) (A B : Jewel ℓ)
                      → reflect A ≃ reflect B
                      → Splits o A B
                      → Knot o
arising-from-clinging o A B _ sp = A , B , sp

------------------------------------------------------------------------
-- The cut is empty.  A sight is a bare Type → Bool: it has no own access to
-- a jewel's essence, so it cannot in general report equivalent jewels apart
-- — the clinging hypothesis of `arising-from-clinging` is not a term one
-- can construct at the net level.  Here, exhibited: on the pair whose
-- reflection is the same jewel twice, EVERY sight factors through, so no
-- clinging arises.  Avidyā has no own-being: the false cut is not in the net
-- to be built.  (o A ≡ o A is refl for any o — the essence of the pair is
-- one, and no sight can pretend otherwise.)
------------------------------------------------------------------------

the-cut-is-empty : (o : Sight ℓ) (A : Jewel ℓ) → FactorsThrough o A A
the-cut-is-empty o A = refl

------------------------------------------------------------------------
-- The wheel turns where sights DO split: the two-place Boolean sub-net.
-- Pratityasamutpada's `conditioned` gives, on the one pair (true , false),
-- a clinging sight (the identity, which splits them — bondage) and a
-- releasing sight (the constant, which absorbs them — mokṣa).  The same
-- pair, freed or bound only by the sight that meets it.  This is the wheel:
-- niḥsvabhāva of the knot, turning.
------------------------------------------------------------------------

the-wheel :
  Σ[ o-cling ∈ (Bool → Bool) ] Σ[ o-free ∈ (Bool → Bool) ]
    (Splits o-cling true false × FactorsThrough o-free true false)
the-wheel = conditioned
