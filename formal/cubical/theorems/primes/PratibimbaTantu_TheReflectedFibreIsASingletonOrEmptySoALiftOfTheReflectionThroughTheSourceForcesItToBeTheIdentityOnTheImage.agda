{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब-तन्तु — the reflection fibre.
--
-- IF A REFLECTION IS INVISIBLE TO A RESTRICTION THAT ALREADY SEPARATES
-- SOURCES, THEN THE FIBRE OF THE REFLECTED SPECTRUM IS A SINGLETON OR
-- EMPTY — AND ANY LIFT OF THE REFLECTION THROUGH THE SOURCE FORCES IT
-- TO ACT AS THE IDENTITY ON THE IMAGE.
--
-- `DescentObstructionUnified` separates two diagram shapes that are
-- easily conflated: the SEPARATED-PAIR obstruction, where a quotient
-- fails to be reached, and the MISSED-IMAGE obstruction, where a
-- perfectly well-defined datum simply fails to lie in the image of a
-- map.  This module is entirely the second shape, and it is stated so
-- that no completion can be slipped in: the reflected datum exists —
-- that is never in question — and the whole content is whether it is a
-- value of the source map.
--
-- The setting is three types and three maps.  `E` sends a source to its
-- full spectrum; `r` restricts a spectrum to a distinguished part; `J`
-- reflects a spectrum.  Two hypotheses, and no others:
--
--     (i)  r ∘ E is injective     — the restriction ALONE already
--                                   separates sources, unconditionally;
--     (ii) r ∘ J ≡ r              — the reflection is invisible to the
--                                   restriction, because it fixes the
--                                   distinguished part pointwise.
--
--   §1  RIGIDITY.  E g ≡ J (E f)  ⟹  g ≡ f.  Two rewrites: (ii) turns
--       the reflected datum's restriction into the unreflected one, and
--       (i) finishes.  Nothing else is available and nothing else is
--       used.
--
--   §2  SO THE FIBRE IS A PROPOSITION: at most one source can present
--       the reflected spectrum.
--
--   §3  AND IT IS INHABITED EXACTLY WHEN THE REFLECTION FIXES THE
--       DATUM.  Both directions, hence an equivalence of propositions
--
--         Fibre f  ≃  (J (E f) ≡ E f) .
--
--   §4  CONTRACTIBLE ON ONE SIDE, EMPTY ON THE OTHER — the singleton-or-
--       empty dichotomy, with no third case.
--
--   §5  AND THE COROLLARY THAT MATTERS.  If the reflection lifts through
--       the source at all — a `j` with E ∘ j ≡ J ∘ E — then J is the
--       identity on the image.  A lift is therefore not a mild extra
--       structure to hope for: possessing one is exactly as strong as
--       the fixedness it was meant to help establish.
--
-- WHY (ii) IS THE WHOLE HYPOTHESIS, said plainly: the reflection may
-- move the spectrum arbitrarily OFF the distinguished part.  §1 does not
-- say J is trivial; it says that whatever J does off the distinguished
-- part cannot be presented by any source, because the source is already
-- pinned down by the part J cannot touch.  The obstruction lives
-- entirely in the difference between a datum and the image.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–5 for any three types with the
-- displayed maps and the two displayed hypotheses, with the spectrum
-- type a set (§§2–4 only).  NOT claimed: that (i) holds for any
-- particular restriction — its proof there is an entire-function
-- uniqueness argument over a positive proportion of points and has no
-- carrier in this corpus; that (ii) holds for any particular reflection;
-- that any source exists — the fibre's inhabitation is exactly what is
-- being characterized, never assumed; anything about a completion, a
-- norm, or a cost — a datum's membership in a larger completed space is
-- a different question from membership in this image, and the two are
-- deliberately not connected here; and nothing about finite subfamilies
-- of the constraint, which is a different diagram again.
------------------------------------------------------------------------

module PratibimbaTantu_TheReflectedFibreIsASingletonOrEmptySoALiftOfTheReflectionThroughTheSourceForcesItToBeTheIdentityOnTheImage where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; propBiimpl→Equiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ (C : Type ℓ) (D : Type ℓ') (D₀ : Type ℓ'')
         (isSetD : isSet D)
         (E : C → D) (r : D → D₀) (J : D → D)
         -- (i) the restriction alone already separates sources
         (separates : (f g : C) → r (E f) ≡ r (E g) → f ≡ g)
         -- (ii) the reflection is invisible to the restriction
         (invisible : (a : D) → r (J a) ≡ r a)
         where

  ------------------------------------------------------------------
  -- ० · The fibre of the reflected spectrum over the source map.
  ------------------------------------------------------------------

  Fibre : C → Type (ℓ-max ℓ ℓ')
  Fibre f = Σ[ g ∈ C ] (E g ≡ J (E f))

  ------------------------------------------------------------------
  -- १ · RIGIDITY.  Two rewrites and nothing else.
  ------------------------------------------------------------------

  rigidity : (f g : C) → E g ≡ J (E f) → g ≡ f
  rigidity f g p =
    separates g f (cong r p ∙ invisible (E f))

  ------------------------------------------------------------------
  -- २ · SO THE FIBRE IS A PROPOSITION.
  ------------------------------------------------------------------

  fibre-isProp : (f : C) → isProp (Fibre f)
  fibre-isProp f (g , p) (h , q) =
    Σ≡Prop (λ k → isSetD (E k) (J (E f)))
           (rigidity f g p ∙ sym (rigidity f h q))

  ------------------------------------------------------------------
  -- ३ · AND INHABITED EXACTLY WHEN THE REFLECTION FIXES THE DATUM.
  ------------------------------------------------------------------

  fibre→fixed : (f : C) → Fibre f → J (E f) ≡ E f
  fibre→fixed f (g , p) = sym p ∙ cong E (rigidity f g p)

  fixed→fibre : (f : C) → J (E f) ≡ E f → Fibre f
  fixed→fibre f h = f , sym h

  fibre≃fixed : (f : C) → Fibre f ≃ (J (E f) ≡ E f)
  fibre≃fixed f =
    propBiimpl→Equiv (fibre-isProp f) (isSetD (J (E f)) (E f))
                     (fibre→fixed f) (fixed→fibre f)

  ------------------------------------------------------------------
  -- ४ · SINGLETON OR EMPTY, WITH NO THIRD CASE.
  ------------------------------------------------------------------

  fibre-isContr : (f : C) → J (E f) ≡ E f → isContr (Fibre f)
  fibre-isContr f h = fixed→fibre f h , fibre-isProp f (fixed→fibre f h)

  fibre-empty : (f : C) → ¬ (J (E f) ≡ E f) → ¬ (Fibre f)
  fibre-empty f nf x = nf (fibre→fixed f x)

  ------------------------------------------------------------------
  -- ५ · A LIFT THROUGH THE SOURCE FORCES THE IDENTITY ON THE IMAGE.
  ------------------------------------------------------------------

  lift-forces-identity : (j : C → C)
    → ((f : C) → E (j f) ≡ J (E f))
    → (f : C) → J (E f) ≡ E f
  lift-forces-identity j lifts f = fibre→fixed f (j f , lifts f)
