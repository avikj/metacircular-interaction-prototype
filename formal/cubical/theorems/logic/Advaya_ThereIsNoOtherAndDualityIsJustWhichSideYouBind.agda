{-# OPTIONS --cubical --safe #-}

-- अद्वय — not-two.  Not a slogan: the fibre law read without the dualist
-- standpoint.  There is one object.  "Duality" is not a second thing —
-- it is which side of f a ≡ b you bind, and grasping one side as THE
-- truth is the durnaya.  Put to the kernel, generated freely.

module Advaya_ThereIsNoOtherAndDualityIsJustWhichSideYouBind where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma

private variable ℓ : Type
module _ {A : Type} where

  -- अद्वय: the space of "what is equal to me" is CONTRACTIBLE — there is
  -- no other.  Everything equal to a IS a, joined to it by a path.  This
  -- is the output-binding of the fibre law (singl), and it holds with no
  -- hypothesis: nonduality is not achieved, it is the default reading.
  naparah : (a : A) → isContr (singl a)
  naparah a = isContrSingl a

  -- the appearance of an "other" is the INPUT-binding: for a map f, the
  -- fibre over b can be arbitrary.  Otherness = a non-contractible fibre
  -- = charge = memory = the knot.  Same map, other side.  So duality is
  -- not false; it is a standpoint (naya), and it is exactly a fibre that
  -- failed to be contractible.
module _ {A B : Type} (f : A → B) where
  otherness : B → Type
  otherness b = fiber f b

  -- and the bridge, kevala = isEquiv (AtmaJnana): a map is an equivalence
  -- EXACTLY when every otherness is contractible — when nothing is hidden
  -- from it, no dark sector, no second.  Perfect self-knowledge IS non-
  -- duality, definitionally.  (This is the definition of isEquiv unfolded:
  -- to give it is to give contractibility of every fibre.)
  advaya-is-kevala : (∀ b → isContr (fiber f b)) → isEquiv f
  advaya-is-kevala h = record { equiv-proof = h }

  -- the converse standpoint, stated so the durnaya is visible: if the map
  -- is NOT an equivalence, some otherness is non-contractible — a real
  -- charge, a real hidden sector.  Dualism is not an error to erase; it
  -- is a fibre that carries something, and the mistake is only grasping
  -- it as final rather than as one binding of the one map.
  kevala-is-advaya : isEquiv f → (∀ b → isContr (fiber f b))
  kevala-is-advaya e = equiv-proof e
