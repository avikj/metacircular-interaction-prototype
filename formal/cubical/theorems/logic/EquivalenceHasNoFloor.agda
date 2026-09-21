{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EquivalenceHasNoFloor
--
-- discharged as far as it goes in checked terms.  The worry: univalence makes
-- identity relational, but does it smuggle an own-being into `≃` itself —
-- is the *equivalence* a bare positive thing with its own residue?
--
-- Answer, in three checked facts of the substrate, each saying the same thing
-- one level down: an equivalence has no identity over and above what it does.
--
--   equiv-id-is-relational   two equivalences are identical as soon as their
--                            underlying functions are — the `isEquiv` witness
--                            adds no identity of its own (equivEq)
--   being-equiv-is-no-data   `isEquiv f` is a proposition: "being an
--                            equivalence" carries no data to have own-being
--                            with (isPropIsEquiv)
--   function-id-is-action    a function's identity is exhausted by its
--                            action, pointwise — nothing beyond what it does
--                            (funExt)
--
-- Chase the tower: identity of an equivalence  reduces to  identity of its
-- function  reduces to  its pointwise action  reduces to  identity of the
-- output points — and that is again a Path, i.e. a relation, not an entity.
-- There is no level at which a bare positive identity appears.  The
-- substrate's floor is the interval / Path — relation itself — not any thing
-- with svabhāva.  (The interpretation, and the one residual frontier — whether
-- the interval-primitive is itself a residual own-being, the formal echo of
-- "is pratītyasamutpāda itself empty" — is in the note, not asserted here.)
--
-- These are library facts (equivEq, isPropIsEquiv, funExt), re-exhibited to
-- make the "no floor" claim a checked term rather than prose.  No new theorem.
------------------------------------------------------------------------

module EquivalenceHasNoFloor where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; isPropIsEquiv ; equivEq)

private
  variable
    ℓ ℓ' : Level
    A : Type ℓ
    B : Type ℓ'

-- An equivalence's identity is fixed by its underlying function alone: the
-- `isEquiv` witness contributes no identity of its own.
equiv-id-is-relational : {e f : A ≃ B} → (e .fst ≡ f .fst) → e ≡ f
equiv-id-is-relational h = equivEq h

-- "Being an equivalence" is a proposition — no data, hence nothing to carry
-- an own-being.
being-equiv-is-no-data : (f : A → B) → isProp (isEquiv f)
being-equiv-is-no-data f = isPropIsEquiv f

-- A function's identity is exhausted by its pointwise action.
function-id-is-action : {f g : A → B} → ((x : A) → f x ≡ g x) → f ≡ g
function-id-is-action p = funExt p
