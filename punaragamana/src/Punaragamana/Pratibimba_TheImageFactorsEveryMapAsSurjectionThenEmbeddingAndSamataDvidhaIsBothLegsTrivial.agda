{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Punargamana ¬ ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡
--
-- ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡ (pratibimba) ‚î reflection, image.  The compound is CHOSEN
-- here, descriptively; no source is claimed for it (the same standing as
-- `Carrier` and `SamataDvidha`'s own names).
------------------------------------------------------------------------
-- WHY THIS MODULE EXISTS.
--
-- `SamataDvidha` proved, fibrewise, that being an equivalence is a
-- PRODUCT of two independent obligations:
--
--     ((b : B) ‚í isContr (‡‡‡ f b))  ‚â  ‡‡‡¶‡ f  ó  ‡‡æ‡¶‡®‡Æ‡ f
--
-- ‡‡‡¶‡ f  = hasPropFibers f      ("no two points collapsed", an embedding)
-- ‡‡æ‡¶‡®‡Æ‡ f = (b : B) ‚í ‡‡‡ f b     ("nothing missing", a split surjection)
--
-- That is a per-point SPLIT of a hypothesis.  This module exhibits the
-- SAME split as a factorisation of the MAP: every f : A ‚í B factors as
--
--     A  --‡‡‡∞‡‡Æ-‡‡∞‡-->  ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡ f  --‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡-->  B
--
-- where ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡ f = Œ[ b ‚àà B ] ‚à ‡‡‡ f b ‚à‚ (the propositional image),
-- ‡‡‡∞‡‡Æ-‡‡∞‡ is UNCONDITIONALLY a surjection, and ‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ is
-- UNCONDITIONALLY an embedding.  f is an equivalence exactly when this
-- factorisation's own obligations trivialise:
--
--   ‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ is an equivalence  ‚ü∫  f is surjective  (isSurjection f)
--   ‡‡‡∞‡‡Æ-‡‡∞‡  is an equivalence  ‚ü∫  f is an embedding  (‡‡‡¶‡ f, up to
--                                    `SamataDvidha.‡‡‡¶‡‚íembedding`)
--
-- and both together are exactly `isEquiv‚âisEmbeddingóisSurjection`
-- (`Cubical.Functions.Surjection`), which is `‡‡Æ‡‡æ‚â‡‡‡¶ó‡‡æ‡¶‡®` composed with
-- the observation, proved in ¬ß3 below, that ‡‡æ‡¶‡®‡Æ‡ f and isSurjection f
-- COINCIDE precisely when ‡‡‡¶‡ f holds ‚î i.e. exactly when the fibres are
-- already propositions, truncation is idempotent (`propTruncIdempotent‚â`)
-- and "merely inhabited" and "inhabited" are the same obligation.  So
-- SamataDvidha's per-point product and Image's map factorisation are the
-- SAME theorem, read at two different granularities: SamataDvidha reads it
-- fibre-by-fibre with the UNtruncated ‡‡æ‡¶‡®‡Æ‡; the factorisation reads it as
-- one map with the TRUNCATED isSurjection, and ¬ß3 is exactly the bridge
-- between the two granularities.
--
-- WHAT IS DONE HERE VS. WHAT IS ALREADY IN THE LIBRARY.
-- `Cubical.Functions.Image` already proves the factorisation itself
-- (`imageInclusion`, `restrictToImage`, `imageFactorization`), the
-- unconditional surjectivity of the first leg
-- (`isSurjectionImageRestriction`), the unconditional embedding-ness of the
-- second leg (built into `imageInclusion`), and the two directions linking
-- an equivalence-first-leg to an embedding (`isEquivEmbeddingOntoImage`,
-- `isEmbeddingFromIsEquivToImage`).  Nothing here reproves those; they are
-- imported and used directly, by name, so their provenance stays visible.
-- What this module adds, as new checked terms:
--
--   1.  the missing converse `isEquiv (‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ f) ‚â isSurjection f`
--       (the library states the first-leg case; not the second-leg case);
--   2.  the bridge ‡‡æ‡¶‡®‡Æ‡ f ‚â isSurjection f UNDER ‡‡‡¶‡ f ‚î the exact
--       identification between SamataDvidha's untruncated obligation and
--       Image's truncated one;
--   3.  `‡‡‡∞‡‡Æ-‡‡∞‡-equiv‚â‡‡‡¶‡`, restating the library's embedding-onto-image
--       facts through ‡‡‡¶‡ so they compose with SamataDvidha directly,
--       exhibiting `‡‡‡∞‡‡ø‡‡ø‡Æ‡‡`'s factorisation and `‡‡Æ‡‡æ-‡¶‡‡µ‡ø‡ß‡æ`'s product
--       as the same theorem at two granularities.
------------------------------------------------------------------------

module Punaragamana.Pratibimba_TheImageFactorsEveryMapAsSurjectionThenEmbeddingAndSamataDvidhaIsBothLegsTrivial where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Function using (_‚àò_)
open import Cubical.Data.Sigma
open import Cubical.HITs.PropositionalTruncation
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; squash‚ÇÅ ; isPropPropTrunc ; propTruncIdempotent‚âÉ ; rec)
open import Cubical.Functions.Embedding
  using (isEmbedding ; hasPropFibers ; hasPropFibers‚ÜíisEmbedding ; isEmbedding‚ÜíhasPropFibers)
open import Cubical.Functions.Surjection
  using (isSurjection ; isPropIsSurjection ; isEquiv‚âÉisEmbedding√óisSurjection)
open import Cubical.Functions.Image
  using (Image ; isInImage ; isPropIsInImage ; imageInclusion ; restrictToImage
        ; isSurjectionImageRestriction ; imageFactorization
        ; isEquivEmbeddingOntoImage ; isEmbeddingFromIsEquivToImage)

open import Punaragamana.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph
  using (‡§∂‡•á‡§∑)
open import Punaragamana.SamataDvidha_TheContractibleFibreSplitsAsEmbeddingTimesSurjectionAndTheEmptyAndCrowdedRefusalsAreTheTwoFactorsFailingApart
  using (‡§≠‡•á‡§¶‡§É ; ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç ; ‡§∏‡§Æ‡§§‡§æ-‡§¶‡•ç‡§µ‡§ø‡§ß‡§æ ; ‡§∏‡§Æ‡§§‡§æ‚âÉ‡§≠‡•á‡§¶√ó‡§õ‡§æ‡§¶‡§® ; ‡§≠‡•á‡§¶‡§É‚Üíembedding ; embedding‚Üí‡§≠‡•á‡§¶‡§É)

private
  variable
    ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ------------------------------------------------------------------------
  -- 0.  THE FACTORISATION ITSELF, named in this module's vocabulary.
  ------------------------------------------------------------------------

  -- ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡ f = the propositional image, Œ[ b ‚àà B ] ‚à ‡‡‡ f b ‚à‚.
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨ : Type ‚Ñì
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨ = Image f

  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£ : A ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨
  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£ = restrictToImage f

  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ : ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨ ‚Üí B
  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ = fst (imageInclusion f)

  -- the composite recovers f exactly, ON THE NOSE.
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨-‡§∏‡§Ç‡§ò‡§ü‡§® : ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ ‚àò ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£ ‚â° f
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨-‡§∏‡§Ç‡§ò‡§ü‡§® = imageFactorization f

  ------------------------------------------------------------------------
  -- 1.  ‡‡‡∞‡‡Æ-‡‡∞‡ is UNCONDITIONALLY a surjection.
  ------------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£-‡§õ‡§æ‡§¶‡§ï‡§É : isSurjection ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£
  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£-‡§õ‡§æ‡§¶‡§ï‡§É = isSurjectionImageRestriction f

  ------------------------------------------------------------------------
  -- 2.  ‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ is UNCONDITIONALLY an embedding.
  ------------------------------------------------------------------------

  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-‡§≠‡§ø‡§®‡•ç‡§®‡§É : isEmbedding ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£
  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-‡§≠‡§ø‡§®‡•ç‡§®‡§É = snd (imageInclusion f)

  ------------------------------------------------------------------------
  -- 3.  THE BRIDGE.  Under ‡‡‡¶‡ f (f's fibres already propositions),
  --     the UNTRUNCATED ‡‡æ‡¶‡®‡Æ‡ f and the TRUNCATED isSurjection f
  --     coincide: truncation is idempotent on an already-prop type.
  ------------------------------------------------------------------------

  ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç‚âÉsurjection-under-‡§≠‡•á‡§¶‡§É : ‡§≠‡•á‡§¶‡§É f ‚Üí ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç f ‚âÉ isSurjection f
  ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç‚âÉsurjection-under-‡§≠‡•á‡§¶‡§É ‡§≠ =
    equivŒ†Cod (Œª b ‚Üí invEquiv (propTruncIdempotent‚âÉ (‡§≠ b)))

  ------------------------------------------------------------------------
  -- 4.  ‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ IS an equivalence  ‚ü∫  f IS surjective.
  --     (fibre of ‡¶‡‡µ‡ø‡‡‡Ø-‡‡∞‡ over b is isInImage f b, an ALREADY-prop
  --     type by definition, so isEquiv ‚ü∫ inhabited, pointwise.)
  ------------------------------------------------------------------------

  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-equiv‚âÉsurjective : isEquiv ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ ‚âÉ isSurjection f
  ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-equiv‚âÉsurjective =
    propBiimpl‚ÜíEquiv (isPropIsEquiv ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£) isPropIsSurjection to fro
    where
      to : isEquiv ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ ‚Üí isSurjection f
      to e b = subst (isInImage f) (equiv-proof e b .fst .snd) (equiv-proof e b .fst .fst .snd)

      ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-fibre-prop : (b : B) ‚Üí isProp (fiber ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£ b)
      ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-fibre-prop = isEmbedding‚ÜíhasPropFibers ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-‡§≠‡§ø‡§®‡•ç‡§®‡§É

      fro : isSurjection f ‚Üí isEquiv ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£
      equiv-proof (fro sur) b =
        inhProp‚ÜíisContr
          (rec (‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-fibre-prop b)
               (Œª (a , pf) ‚Üí ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£ a , pf)
               (sur b))
          (‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø-‡§ö‡§∞‡§£-fibre-prop b)

  ------------------------------------------------------------------------
  -- 5.  ‡‡‡∞‡‡Æ-‡‡∞‡ IS an equivalence  ‚ü∫  f IS an embedding.
  --     (Library's `isEquivEmbeddingOntoImage` / `isEmbeddingFromIsEquivToImage`,
  --     restated through ‡‡‡¶‡ so it composes with SamataDvidha directly.)
  ------------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£-equiv‚âÉ‡§≠‡•á‡§¶‡§É : isEquiv ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£ ‚âÉ ‡§≠‡•á‡§¶‡§É f
  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£-equiv‚âÉ‡§≠‡•á‡§¶‡§É =
    propBiimpl‚ÜíEquiv (isPropIsEquiv ‡§™‡•ç‡§∞‡§•‡§Æ-‡§ö‡§∞‡§£) (isPropŒ† (Œª _ ‚Üí isPropIsProp))
      (Œª e ‚Üí embedding‚Üí‡§≠‡•á‡§¶‡§É f (isEmbeddingFromIsEquivToImage f e))
      (Œª ‡§≠ ‚Üí isEquivEmbeddingOntoImage (f , ‡§≠‡•á‡§¶‡§É‚Üíembedding f ‡§≠))
