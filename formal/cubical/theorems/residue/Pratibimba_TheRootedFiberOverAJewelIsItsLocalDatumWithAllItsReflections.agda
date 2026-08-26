{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब — the reflection.  The rooted fiber over a jewel IS that
-- jewel's local datum together with all its reflections.
--
-- SOURCE / SCOPE.  The metaphor is इन्द्रजाल, Indra's net: at every knot
-- a jewel, and in each jewel the reflection of every other (the net of
-- Indra, Atharvaveda 8.8.6–8; the interpenetration reading is Huayan,
-- Fazang 643–712).  The MATHEMATICS is not claimed for any text: it is
-- Voevodsky-substrate homotopy type theory (the fibration lemma HoTT
-- 4.8.1, and the final-coalgebra / domain-equation form of Indra's net),
-- already checked in this repository as `IndraNet.agda`, whose module
-- header names them as targets T25.B and T25.D of
--
-- THE GAP THIS FILE CLOSES.  `IndraNet.agda` proves two equivalences and
-- never joins them, though its own `IndraRoot` comment says it is
-- "closing the loop with T25.B":
--
--   T25.B  Rooted.rootFiber x : fiber unroot x ≃ Net x
--            — the fiber of the rooted totalization Σ x . Net x over a
--              jewel x is "the net as seen from this jewel".
--   T25.D  netUnfold       x : Net x ≃ (L x × ((y : J) → Net y))
--            — the guarded Indra equation: a jewel unfolds into its own
--              local datum and the view of every jewel.
--
-- Both are equivalences of corpus-defined objects, and they share the
-- middle term `Net x`.  Composing them (cubical's one verb: transport
-- along the identification, here `compEquiv`) identifies the two OUTER
-- objects, which the corpus had left unjoined:
--
--   fiber unroot x  ≃  L x × ((y : J) → Net y).
--
-- Read in the net's own terms: to stand at a jewel of the rooted net (a
-- point of its totalization lying over x) is exactly to hold that jewel's
-- own local light and, with it, the reflection of the whole net.  The
-- rooted view and the unfolding are one object seen under two nayas; this
-- is their identification, not a fresh construction.
--
-- No sorry / postulate / axiom / hole.  Everything is `compEquiv` of two
-- equivalences already kernel-checked in `IndraNet.agda`.
------------------------------------------------------------------------

module Pratibimba_TheRootedFiberOverAJewelIsItsLocalDatumWithAllItsReflections where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; fiber)
open import Cubical.Data.Sigma using (_×_)

import IndraNet

private
  variable
    ℓ ℓ' : Level

-- Fix the local-data assignment L over the jewels J, exactly as the
-- coinductive Net of IndraNet is parametrized.
module _ {J : Type ℓ} (L : J → Type ℓ') where

  open IndraNet.Coinductive {J = J} L
    using (Net ; netUnfold ; IndraRoot)

  -- Root the reflection net on its own jewels: instantiate the rooted
  -- totalization of IndraNet with Φ := Net.  `Root` is then Σ x . Net x,
  -- which is IndraNet's `IndraRoot` on the nose, and `unroot` forgets the
  -- distinguished jewel.
  open IndraNet.Rooted {U = J} Net
    using (Root ; unroot ; rootFiber)

  -- The two encodings ARE the same rooted total space (definitionally;
  -- recorded so the identification below is read against the right object).
  Root≡IndraRoot : Root ≡ IndraRoot
  Root≡IndraRoot = refl

  -- THE CLOSED GAP.  Fiber-over-a-jewel (T25.B) composed with the guarded
  -- unfolding (T25.D): to lie over x in the rooted net is exactly to be
  -- x's local datum together with the whole net's reflection.
  pratibimba : (x : J)
    → fiber unroot x ≃ (L x × ((y : J) → Net y))
  pratibimba x = compEquiv (rootFiber x) (netUnfold x)
