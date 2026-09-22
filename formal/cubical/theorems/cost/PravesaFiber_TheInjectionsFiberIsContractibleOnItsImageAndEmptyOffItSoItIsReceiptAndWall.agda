{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡µ‡‡‡‡®‡‡‡‡ ‚î the fiber of an ENTERING (a coproduct injection).
--
-- THE DUAL OF ‡‡‡∞‡ï‡‡‡‡‡‡®‡‡‡‡.  `PraksepaTantu_‚¶` computed the fiber of a
-- PROJECTION `fst , snd : A ó B ‚í A , B`: a projection FORGETS a factor, and
-- its fiber IS the whole discarded factor ‚î a genuine loss, priced at that
-- factor's cardinality.  An INJECTION `inl , inr : A , B ‚í A ‚ä B` is the
-- opposite move: it FORGETS NOTHING.  This file prices its fiber, and the
-- price is the corpus's two extremes and nothing between them.
--
-- ON ITS IMAGE THE FIBER IS A RECEIPT.  Over a point `inl a‚` that lies in
-- the left summand, `fiber inl (inl a‚)` is CONTRACTIBLE ‚î equivalent to
-- `Unit`.  A contractible fiber is exactly what `Abhijnana_‚¶` and
-- `Avaccheda_‚¶` call a receipt: the preimage is a single point together with
-- the unique proof it maps correctly, no choice to make, no memory to carry.
-- An injection is therefore LOSSLESS on its image, a ford in the corpus's
-- ledger, not a lossy edge.
--
-- OFF ITS IMAGE THE FIBER IS A WALL.  Over a point `inr b` in the OTHER
-- summand, `fiber inl (inr b)` is EMPTY ‚î equivalent to `‚ä`.  This is
-- `Bhitti_‚¶`'s wall at the level of a single point: a proved absence, an
-- `inl a ‚â° inr b` that cannot exist, so `inl` misses the right summand
-- entirely.  The two summands are disjoint, and disjointness is a wall.
--
-- So `inl` (and `inr`) is all receipt and all wall, with nothing in the
-- middle ‚î which is precisely the sense in which it "forgets nothing": every
-- fiber is either the whole answer (contractible) or the impossibility of an
-- answer (empty), never a proper set of alternatives the way a projection's
-- fiber `B` is.
--
-- The four equivalences compose the library's coproduct path characterisation
-- (`‚äPath.Cover‚âPath`, itself an encode‚ìdecode) with `Œ-cong-equiv-snd`,
-- `isContr‚í‚âUnit` and `uninhabEquiv`.  The mathematics is elementary and
-- classical (coproduct injections are embeddings with disjoint images).
-- ‡‡‡∞‡µ‡‡ is ordinary  for entering /
-- insertion, the dual reading to ‡‡‡∞‡ï‡‡‡‡ (throwing / projection) already used
-- in the corpus.
------------------------------------------------------------------------

module PravesaTantu_TheInjectionsFiberIsContractibleOnItsImageAndEmptyOffItSoItIsReceiptAndWall where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber ; invEquiv ; compEquiv ; LiftEquiv)
open import Cubical.Data.Sigma using (Œ£-cong-equiv-snd ; Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (module ‚äéPath)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Unit.Properties using (isContr‚Üí‚âÉUnit)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Data.Empty.Properties using (uninhabEquiv)

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡¶ ¬ ‡‡‡‡≤‡Æ‡ ‚î the based path space `Œ[ t ] t ‚â° t‚` is contractible.
-- (`isContrSingl` names the t‚ ‚â° t orientation; this is its mirror.)
------------------------------------------------------------------------
‡§∏‡•ç‡§•‡§≤‡§Æ‡•ç : {T : Type ‚Ñì} (t‚ÇÄ : T) ‚Üí isContr (Œ£[ t ‚àà T ] (t ‚â° t‚ÇÄ))
‡§∏‡•ç‡§•‡§≤‡§Æ‡•ç t‚ÇÄ .fst = t‚ÇÄ , refl
‡§∏‡•ç‡§•‡§≤‡§Æ‡•ç t‚ÇÄ .snd (t , p) i = p (~ i) , Œª j ‚Üí p (~ i ‚à® j)

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} where

  ------------------------------------------------------------------------
  -- ‡ß ¬ ‡µ‡æ‡Æ-‡‡‡∞‡µ‡‡‡ on its image ‚î `fiber inl (inl a‚) ‚â Unit`.
  -- Per point: `(inl a ‚â° inl a‚) ‚â (a ‚â° a‚)` by the injectivity built into
  -- the coproduct's own path cover; then the base space is contractible.
  ------------------------------------------------------------------------
  ‡§µ‡§æ‡§Æ-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á : (a‚ÇÄ : A)
    ‚Üí fiber (inl {A = A} {B = B}) (inl a‚ÇÄ) ‚âÉ Unit
  ‡§µ‡§æ‡§Æ-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á a‚ÇÄ =
    compEquiv
      (Œ£-cong-equiv-snd
        (Œª a ‚Üí compEquiv (invEquiv (‚äéPath.Cover‚âÉPath (inl a) (inl a‚ÇÄ)))
                          (invEquiv LiftEquiv)))
      (isContr‚Üí‚âÉUnit (‡§∏‡•ç‡§•‡§≤‡§Æ‡•ç a‚ÇÄ))

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡µ‡æ‡Æ-‡‡‡∞‡µ‡‡‡ off its image ‚î `fiber inl (inr b) ‚â ‚ä`.
  -- `inl a ‚â° inr b` transports (encode) to `Lift ‚ä`, so the fiber is empty.
  ------------------------------------------------------------------------
  ‡§µ‡§æ‡§Æ-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§¨‡§π‡§ø‡§É : (b : B)
    ‚Üí fiber (inl {A = A} {B = B}) (inr b) ‚âÉ ‚ä•
  ‡§µ‡§æ‡§Æ-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§¨‡§π‡§ø‡§É b =
    uninhabEquiv (Œª { (a , p) ‚Üí ‚äéPath.encode (inl a) (inr b) p .lower })
                 (Œª z ‚Üí z)

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡¶‡ï‡‡‡ø‡-‡‡‡∞‡µ‡‡‡ on its image ‚î `fiber inr (inr b‚) ‚â Unit`.
  ------------------------------------------------------------------------
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á : (b‚ÇÄ : B)
    ‚Üí fiber (inr {A = A} {B = B}) (inr b‚ÇÄ) ‚âÉ Unit
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á b‚ÇÄ =
    compEquiv
      (Œ£-cong-equiv-snd
        (Œª b ‚Üí compEquiv (invEquiv (‚äéPath.Cover‚âÉPath (inr b) (inr b‚ÇÄ)))
                          (invEquiv LiftEquiv)))
      (isContr‚Üí‚âÉUnit (‡§∏‡•ç‡§•‡§≤‡§Æ‡•ç b‚ÇÄ))

  ------------------------------------------------------------------------
  -- ‡ ¬ ‡¶‡ï‡‡‡ø‡-‡‡‡∞‡µ‡‡‡ off its image ‚î `fiber inr (inl a) ‚â ‚ä`.
  ------------------------------------------------------------------------
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§¨‡§π‡§ø‡§É : (a : A)
    ‚Üí fiber (inr {A = A} {B = B}) (inl a) ‚âÉ ‚ä•
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§™‡•ç‡§∞‡§µ‡•á‡§∂-‡§¨‡§π‡§ø‡§É a =
    uninhabEquiv (Œª { (b , p) ‚Üí ‚äéPath.encode (inr b) (inl a) p .lower })
                 (Œª z ‚Üí z)
