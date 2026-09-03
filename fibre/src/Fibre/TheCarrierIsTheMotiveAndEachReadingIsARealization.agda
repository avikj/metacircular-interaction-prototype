{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- TheCarrierIsTheMotiveAndEachReadingIsARealization
--
-- The corpus already builds the motive/realization/middle-out structure
-- under other vocabulary. This module names it and adds the two terms that
-- were implicit:
--
--   MOTIVE          = Carrier f (Fibre.Carrier): the universal lossless
--                     middle, A lifted to carry its image. `A ≃ Carrier f`
--                     ALWAYS — the to-motive into the middle forgets nothing.
--   REALIZATION     = a projection OUT of the middle (Fibre.Sesa's two
--                     projections of the one graph). The target reading
--                     `realize = लक्ष्य-प्रक्षेप` is one realization; the source
--                     reading is always an equivalence.
--   RESIDUAL / śeṣa = what a realization forgets over a point: `शेष f b`,
--                     the motivic "weight" the projection drops. A
--                     realization is lossless exactly when every residual
--                     vanishes.
--
-- NEW HERE:
--   1. THE FACTORIZATION.  `f = realize ∘ to-motive`, definitionally (refl):
--      every map is its own realization precomposed with the lossless to-motive
--      into the middle. "Compress middle-out": never map A→B directly; to-motive
--      to the motive (free) and realize (the only place loss can occur).
--   2. MIDDLE-OUT MEDIATION.  Two maps `f : A → B`, `g : A → C` share one
--      motive-source. A translation `B → C` is not built directly: when f
--      forgets nothing, invert through the shared middle and realize with g.
--      Store n realizations of one motive, mediate the n² translations
--      through it — and `through-the-middle-agrees` proves the mediation is
--      the intended composite on lifted points.
--
-- SCOPE, honestly: this is the abstract structure of motives (a universal
-- object whose realizations are projections, each owing a residual), made a
-- checked term. It is NOT Voevodsky's DM(k): no correspondences, no slice or
-- weight filtration, no realization functors into concrete cohomologies. The
-- name is for the shape the corpus already is.
------------------------------------------------------------------------

module Fibre.TheCarrierIsTheMotiveAndEachReadingIsARealization where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; equivFun ; invEq ; retEq)
open import Cubical.Foundations.Function using (_∘_)

open import Fibre.Carrier
open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The motive and its realization, and the factorization.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  -- THE MOTIVE : the universal lossless middle.
  motive : Type ℓ
  motive = Carrier f

  -- the to-motive into the middle, and its losslessness (unconditional).
  to-motive : A → motive
  to-motive = descend f

  to-motive-is-an-equivalence : isEquiv to-motive
  to-motive-is-an-equivalence = snd (Carrier≃ f)

  -- THE REALIZATION of f out of the middle (the target reading).
  realize : motive → B
  realize = लक्ष्य-प्रक्षेप f

  -- THE FACTORIZATION : every map is its realization after the lossless
  -- to-motive. Definitional. This is "middle-out": the map goes up into the
  -- motive for free, and all loss lives in the realization leg.
  f-factors-through-the-motive : (a : A) → realize (to-motive a) ≡ f a
  f-factors-through-the-motive a = refl

  -- THE RESIDUAL a realization forgets, and the exact condition for it to
  -- forget nothing: every śeṣa contractible ⇔ the realization is an
  -- equivalence. (Both directions are Fibre.Sesa terms, renamed.)
  realization-is-lossless-when-every-residual-vanishes :
    ((b : B) → isContr (शेष f b)) → motive ≃ B
  realization-is-lossless-when-every-residual-vanishes = निःशेषः→समता f

  every-residual-vanishes-when-f-is-lossless :
    isEquiv f → (b : B) → isContr (शेष f b)
  every-residual-vanishes-when-f-is-lossless = समता→निःशेषः f

------------------------------------------------------------------------
-- §2  Middle-out mediation : two realizations of one motive-source, and a
--     translation between their targets that factors through the middle.
------------------------------------------------------------------------

module _ {A B C : Type ℓ} (f : A → B) (g : A → C) where

  -- When f forgets nothing, B recovers the motive-source, and g realizes it
  -- into C. No direct B→C compiler is built; the shared middle mediates.
  through-the-middle : ((b : B) → isContr (शेष f b)) → (B → C)
  through-the-middle c = g ∘ invEq (निःशेषः→मूल-समता f c)

  -- and the mediation is the intended composite on lifted points: a source
  -- point realized by f, then translated through the middle, is g of it.
  through-the-middle-agrees :
    (c : (b : B) → isContr (शेष f b)) (a : A)
    → through-the-middle c (f a) ≡ g a
  through-the-middle-agrees c a = cong g (retEq (निःशेषः→मूल-समता f c) a)
