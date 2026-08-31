{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheGapIsInTheForgetfulProjection
--
-- ONE SENTENCE, MADE A TERM.
--
--   "Within the interaction calculus, where the derivation is carried, the
--    answer is projection and there is no gap; the gap is a property of the
--    forgetful model, not of computation itself."
--
-- Nothing generative is imported.  No learner, no matcher, no search, no
-- decision procedure.  Only the interaction calculus (RewriteCertificate),
-- the forward pass (ControlledGrammar), and the kernel's own worked seed
-- (GenerativeKernel).  The claim is discharged twice over, at that seed:
--
--   §1  THE CARRIED MODEL HAS NO GAP.  The answer is a FIELD of the executed
--       interaction object -- recovered by projection, definitionally (refl).
--       The route that reached it is likewise carried, not reconstructed.
--
--   §2  THE GAP LIVES IN THE FORGETFUL IMAGE.  The kernel's own two histories
--       between the same endpoints have DIFFERENT length in the calculus
--       (2 and 4 -- carried, visible) yet EQUAL image under the forgetful
--       semantics `derivation-sound` (because ℕ is a set).  The length gap is
--       therefore a property of the projection `eval`, invisible to it and
--       present only in the `Derivation` it forgets.
--
-- Read together: carried, the answer is π₁ and the routes are distinct data;
-- forgotten, the routes collapse to one proposition and the distinction -- the
-- "gap" -- is what the projection destroyed.  syād-asti: the gap is real in
-- the forgetful model and absent in the carried one, and both are theorems.
------------------------------------------------------------------------

module TheGapIsInTheForgetfulProjection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ)

open import RewriteCertificate
open import ControlledGrammar
open import GenerativeKernel

------------------------------------------------------------------------
-- §1.  THE CARRIED MODEL HAS NO GAP: THE ANSWER IS PROJECTION.
------------------------------------------------------------------------

-- Execute the kernel's own enabled future.  The answer is the `target` field
-- of the resulting CheckedFuture -- obtained by projection, on the nose.
answer-is-projection :
  CheckedFuture.target (execute direct-future) ≡ target₀
answer-is-projection = refl

-- And the route that produced it is carried in the same object, not
-- reconstructed afterwards: reading it out is projection too.
route-is-carried :
  Derivation seed (CheckedFuture.target (execute direct-future))
route-is-carried = CheckedFuture.derivation (execute direct-future)

------------------------------------------------------------------------
-- §2.  THE GAP LIVES IN THE FORGETFUL IMAGE.
------------------------------------------------------------------------

-- Length in the calculus: the number of steps a derivation carries.
len : {a b : Tm} → Derivation a b → ℕ
len (done _)        = zero
len (then-step _ d) = suc (len d)

-- The two routes between the SAME endpoints are distinct data: the direct
-- history is two steps, the detour (forward, reverse, then direct) is four.
-- Both facts hold by refl -- the calculus carries the difference.
len-direct : len direct-history ≡ suc (suc zero)
len-direct = refl

len-detour : len detour-history ≡ suc (suc (suc (suc zero)))
len-detour = refl

-- Yet the forgetful semantics cannot see it.  `derivation-sound` sends a
-- derivation to an equality in ℕ, a set, so any two derivations between the
-- same endpoints have EQUAL image.  The length gap (2 vs 4) is invisible to
-- the projection -- it exists only in the derivation the projection forgets.
forgetful-image-is-blind-to-route :
  (ρ : Env)
  → derivation-sound direct-history ρ ≡ derivation-sound detour-history ρ
forgetful-image-is-blind-to-route ρ =
  isSetℕ (eval seed ρ) (eval target₀ ρ)
    (derivation-sound direct-history ρ)
    (derivation-sound detour-history ρ)
