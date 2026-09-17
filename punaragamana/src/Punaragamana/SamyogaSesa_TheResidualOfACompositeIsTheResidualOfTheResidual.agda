-- à àààà®à à  One machine, one law: which side of `f a â‰¡ b` is bound is everything.
-- Output bound: singl (f a), contractible â” the datum rides free.  Input bound:
-- fiber f b â” the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect â” there is no third path (ahis).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhag, and the sources are the origin
-- (Umsvti, Samantabhadra, Akalaka â” restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Punargamana Â ààà¯à‹à—ààà
--
-- ON THE NAME.  ààà¯à‹à— (sayoga), "conjunction / composition", is a
-- standard technical term across  grammar and Nyya-Vaieika
-- (a padrtha in the Vaieika category scheme: contact between two
-- things that could exist apart).  It is used here as an ordinary
-- compounding word, not cited for a specific technical sense from a
-- particular Nyya text â” no source is claimed for THIS compound,
-- `ààà¯à‹à—ààà`, which is built here from àà¾àà¿ààà¯ already in this library
-- (`Punaragamana.Carrier`'s `fibre`, `Punaragamana.Sesaâ¦`'s `ààà`).
--
-- WHAT THIS MODULE ADDS.
--
-- `Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph` proves ààà f b is
-- what a single map f forgets over a point b.  It says nothing about two
-- maps composed.  This module supplies exactly that, and the answer is
-- the ordinary "fibre of a composite is a fibre of fibres" fact (HoTT
-- book, Ex. 4.4 / the pullback-pasting lemma read fibrewise), stated in
-- this library's vocabulary and PROVED FROM THE SAME LEMMA `Carrier`
-- already uses to buy contractibility â” `fibre-isContr`/`Î-contractFst`
-- â” reused here rather than re-derived.
--
--   ààà (g âˆ˜ f) c   â‰   Î[ y âˆˆ ààà g c ] ààà f (fst y)
--
-- Read aloud: what A-to-C forgets over c is exactly â” a choice of which
-- B-point c came from (ààà g c), together with, for THAT choice, what
-- A-to-B forgot on the way to it (ààà f, at that B-point).  A residual
-- does not accumulate as a single opaque number; it is itself fibred
-- over the earlier residual.  This is the reason àà¯à¨ààà™àà–à²à¾ (a chain of
-- choices, one per stage) is the right shape for tracking loss through a
-- pipeline of maps, and a single "total loss" scalar is already throwing
-- structure away that this equivalence proves is there to keep.
--
-- THE PROOF STRATEGY, stated because it is itself the content: every
-- step below is either (a) `Î-contractFst` fed the SAME `fibre-isContr`
-- that makes `Carrierâ‰¡` free, or (b) a `refl`-round-trip reshuffling of
-- non-dependent Î (no transport, because nothing here needs one â” this
-- is `Î-eta`, exactly as `àààµàà` in the residual module already used it
-- for the two-projection reading). No J, no `subst` outside what
-- `Î-contractFst` already carries.  That the whole composite-fibre
-- theorem needs no MORE path algebra than `Carrier` already contains is
-- itself the point: this is not new machinery, it is the existing
-- machinery answering a question it had not yet been asked.
--
-- CHECKED: Agda 2.6.3, agda/cubical v0.5 â” the library's declared pin.
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Punaragamana.SamyogaSesa_TheResidualOfACompositeIsTheResidualOfTheResidual where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma

open import Punaragamana.Carrier using (fibre ; fibre-isContr)
open import Punaragamana.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph
  using (à¤¶à¥‡à¤·)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- A small, fully generic reshuffling: a Î whose inner component ignores
-- the outer witness pulls the constant factor D outward.  No hypothesis,
-- no transport â” both round trips are `refl`, because nothing but
-- pairing order changed.
------------------------------------------------------------------------

module _ {A : Type â„“} (P : A â†’ Type â„“) (D : Type â„“) where

  Î£Î£const-Iso : Iso (Î£[ a âˆˆ A ] (Î£[ p âˆˆ P a ] D)) (D Ã— (Î£[ a âˆˆ A ] P a))
  Iso.fun      Î£Î£const-Iso (a , (p , d)) = d , (a , p)
  Iso.inv      Î£Î£const-Iso (d , (a , p)) = a , (p , d)
  Iso.rightInv Î£Î£const-Iso _ = refl
  Iso.leftInv  Î£Î£const-Iso _ = refl

-- The two independent outer variables of a doubly-indexed Î commute.
-- Again no transport: C does not change shape, only which variable is
-- bound first.
module _ {A B : Type â„“} (C : A â†’ B â†’ Type â„“) where

  Î£-swap-dep-Iso : Iso (Î£[ a âˆˆ A ] Î£[ b âˆˆ B ] C a b) (Î£[ b âˆˆ B ] Î£[ a âˆˆ A ] C a b)
  Iso.fun      Î£-swap-dep-Iso (a , (b , c)) = b , (a , c)
  Iso.inv      Î£-swap-dep-Iso (b , (a , c)) = a , (b , c)
  Iso.rightInv Î£-swap-dep-Iso _ = refl
  Iso.leftInv  Î£-swap-dep-Iso _ = refl

------------------------------------------------------------------------
-- ààà¯à‹à—ààà.  f : A â’ B, g : B â’ C, c : C.
------------------------------------------------------------------------

module _ {A B C : Type â„“} (f : A â†’ B) (g : B â†’ C) (c : C) where

  gComposeF : A â†’ C
  gComposeF a = g (f a)

  -- e1 : unfold ààà(gâˆ˜f) c against the CONTRACTIBLE fibre of f at a â”
  -- the same contraction `Carrier` runs to buy `Carrierâ‰¡` for free.
  e1 : à¤¶à¥‡à¤· gComposeF c â‰ƒ (Î£[ a âˆˆ A ] Î£[ y âˆˆ fibre f a ] (g (fst y) â‰¡ c))
  e1 = Î£-cong-equiv-snd (Î» a â†’ invEquiv (Î£-contractFst (fibre-isContr f a)))

  -- e2 : unpack the fibre pair.
  e2 : (Î£[ a âˆˆ A ] Î£[ y âˆˆ fibre f a ] (g (fst y) â‰¡ c))
     â‰ƒ (Î£[ a âˆˆ A ] Î£[ b âˆˆ B ] Î£[ p âˆˆ f a â‰¡ b ] (g b â‰¡ c))
  e2 = Î£-cong-equiv-snd (Î» a â†’ Î£-assoc-â‰ƒ)

  -- e3 : the two independent binders a and b commute.
  e3 : (Î£[ a âˆˆ A ] Î£[ b âˆˆ B ] Î£[ p âˆˆ f a â‰¡ b ] (g b â‰¡ c))
     â‰ƒ (Î£[ b âˆˆ B ] Î£[ a âˆˆ A ] Î£[ p âˆˆ f a â‰¡ b ] (g b â‰¡ c))
  e3 = isoToEquiv (Î£-swap-dep-Iso (Î» a b â†’ Î£[ p âˆˆ f a â‰¡ b ] (g b â‰¡ c)))

  -- e4 : for fixed b, pull the constant factor (g b â‰¡ c) out past a.
  e4 : (Î£[ b âˆˆ B ] Î£[ a âˆˆ A ] Î£[ p âˆˆ f a â‰¡ b ] (g b â‰¡ c))
     â‰ƒ (Î£[ b âˆˆ B ] ((g b â‰¡ c) Ã— (Î£[ a âˆˆ A ] (f a â‰¡ b))))
  e4 = Î£-cong-equiv-snd (Î» b â†’ isoToEquiv (Î£Î£const-Iso (Î» a â†’ f a â‰¡ b) (g b â‰¡ c)))

  -- e5 : `(g b â‰¡ c) — ààà f b` IS `Î[ q âˆˆ g b â‰¡ c ] ààà f b` â” Data.Sigma's
  -- `_—_` is exactly that Î, so this a `refl` at every point; and pairing
  -- the outer b back on is `Î-assoc-â‰` read backwards, matching `ààà g c`
  -- paired with `ààà f` at its first projection on the nose.
  e5 : (Î£[ b âˆˆ B ] ((g b â‰¡ c) Ã— (Î£[ a âˆˆ A ] (f a â‰¡ b))))
     â‰ƒ (Î£[ y âˆˆ à¤¶à¥‡à¤· g c ] à¤¶à¥‡à¤· f (fst y))
  e5 = invEquiv Î£-assoc-â‰ƒ

  -- THE THEOREM.
  à¤¸à¤‚à¤¯à¥‹à¤—à¤¶à¥‡à¤· : à¤¶à¥‡à¤· gComposeF c â‰ƒ (Î£[ y âˆˆ à¤¶à¥‡à¤· g c ] à¤¶à¥‡à¤· f (fst y))
  à¤¸à¤‚à¤¯à¥‹à¤—à¤¶à¥‡à¤· = compEquiv e1 (compEquiv e2 (compEquiv e3 (compEquiv e4 e5)))
