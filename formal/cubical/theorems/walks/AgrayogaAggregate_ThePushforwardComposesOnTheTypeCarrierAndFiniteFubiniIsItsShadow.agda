{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ó‡‡∞‡Ø‡ã‡ó-‡‡ô‡‡ò‡æ‡‡ ‚î the pushforward composes on the Type carrier, and
-- every finite Fubini is its shadow.
--
-- THE JOIN THIS LANDS.  The owner's transmission (2026-08-23) names the
-- next finite theorem: g_!(f_!w) ‚â° (g‚àòf)_!w ‚î Fubini as transport,
-- needing two receipts: (1) the equivalence between the index types,
-- (2) invariance of the fold under that reindexing.  Receipt (1) has
-- been checked in this tree since SankramanaSesa ¬ß3 under the name
-- ‡‡‡-‡‡ô‡‡ò‡æ‡‡ ‚î residuals compose, `‡‡‡ (g‚àòf) c ‚â Œ[w ‚àà ‡‡‡ g c] ‡‡‡ f
-- (fst w)` ‚î and nobody had told the measure lane.  This module cashes
-- it at the TOP of the carrier table: for W = Type, "sum over the
-- fibre" IS Œ, the pushforward is
--
--     ‡‡ó‡‡∞‡Ø‡ã‡ó‡ f F y  =  Œ[ u ‚àà ‡‡‡ f y ] F (fst u)
--
-- and Fubini is not a fold identity but an EQUIVALENCE OF TYPES ‚î
-- proved below as ‡‡‡-‡‡ô‡‡ò‡æ‡‡ composed with Œ-associativity, nothing
-- else.  The load-bearing computational fact: ‡‡ô‡‡ò‡æ‡‡'s forward map is
-- `fwd (a , p) = ((f a , p) , (a , refl))`, so the base point is
-- preserved DEFINITIONALLY (`fst (snd (fwd v)) ‚âê fst v`), which is why
-- `Œ-cong-equiv-fst` applies with no transport residue: this Fubini is
-- judgmentally flat in the coordinate that matters.
--
-- WHY THE TYPE ROW IS THE MASTER.  The carrier table (Bool reachability,
-- ‚ï counting, tropical cost, ‚‚ä probability, ‚ amplitude, Type the full
-- uncollapsed history fibre) is a ladder of lawful forgettings.  Every
-- W-valued finite Fubini is THIS equivalence read through a fold: apply
-- an enumeration-invariant `total` (the measure lane's receipt, its
-- permutation-invariance probe on the ‡®‡æ‡°‡ route as this is written) to
-- both sides, and the fold's invariance under the reindexing that THIS
-- module exhibits is exactly receipt (2).  So the division of labour,
-- named for the fleet: the equivalence receipt is here and in
-- SankramanaSesa; the fold receipt is the measure lane's; their
-- composition is W-Fubini for every carrier in the table at once.
-- Functoriality of pushforward = change of variables = Fubini: one
-- theorem, and on the Type row it costs two library lemmas.
--
-- COMPOUND BUILT HERE (naming rule, note 2): ‡‡ó‡‡∞‡Ø‡ã‡ó (the forward
-- yoking ‚î the pushforward), ‡‡ô‡‡ò‡æ‡ (composition/stacking, following
-- SankramanaSesa's ‡‡‡-‡‡ô‡‡ò‡æ‡‡).  No source text is claimed for the
-- compound; the mathematics is HoTT-standard (Œ over a fibre; the
-- composite-fibre splitting is HoTT 4.8.2's neighbourhood), composed.
------------------------------------------------------------------------

module AgrayogaSanghata_ThePushforwardComposesOnTheTypeCarrierAndFiniteFubiniIsItsShadow where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_‚àò_ ; idfun)
open import Cubical.Data.Sigma
  using (Œ£-syntax ; _,_ ; Œ£-assoc-‚âÉ ; Œ£-cong-equiv-fst ; Œ£-contractFst)

open import SankramanaSesa_EveryTransportOwesItsResidual
  using (‡§∂‡•á‡§∑ ; ‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡ó‡‡∞‡Ø‡ã‡ó‡ ‚î the pushforward on the Type carrier.  What lives over
-- an observed point is: a residual (a preimage with its witness),
-- together with the family's content at that preimage.  The dependent
-- sum IS the integral; no fold, no enumeration, nothing forgotten.
------------------------------------------------------------------------

‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É : {A B : Type ‚Ñì} (f : A ‚Üí B) (F : A ‚Üí Type ‚Ñì) ‚Üí B ‚Üí Type ‚Ñì
‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É f F y = Œ£[ u ‚àà ‡§∂‡•á‡§∑ f y ] F (fst u)

------------------------------------------------------------------------
-- ‡® ¬ THE THEOREM.  Pushing forward in two stages is pushing forward
-- once along the composite ‚î as an equivalence of types, at every point
-- of the far codomain.  Receipt (1) is ‡‡‡-‡‡ô‡‡ò‡æ‡‡; the regrouping is
-- Œ-associativity; the family congruence is definitional because
-- ‡‡ô‡‡ò‡æ‡‡ preserves the base point on the nose.
------------------------------------------------------------------------

module _ {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (F : A ‚Üí Type ‚Ñì) (z : C) where

  ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É (g ‚àò f) F z ‚âÉ ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É g (‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É f F) z
  ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É =
    compEquiv
      (Œ£-cong-equiv-fst {B = Œª q ‚Üí F (fst (snd q))} (‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É f g z))
      (Œ£-assoc-‚âÉ)

------------------------------------------------------------------------
-- ‡© ¬ The identity law, for the record: pushing forward along the
-- identity changes nothing but the dress.  The residual of id at a is
-- the inverse-singleton Œ[x] (x ‚â° a) ‚î contractible with centre
-- (a , refl) ‚î so the pushforward contracts back to the family, and
-- with the theorem above this makes ‡‡ó‡‡∞‡Ø‡ã‡ó‡ a functor up to
-- equivalence: identity to identity, composition to composition.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (F : A ‚Üí Type ‚Ñì) (a : A) where

  private
    -- the standard contraction of Œ[x] (x ‚â° a), written out so the
    -- centre is visibly (a , refl) and nothing is imported for it
    ‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : isContr (‡§∂‡•á‡§∑ (idfun A) a)
    ‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É = (a , refl) , Œª { (x , p) i ‚Üí p (~ i) , Œª j ‚Üí p (~ i ‚à® j) }

  ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç : ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó‡§É (idfun A) F a ‚âÉ F a
  ‡§Ö‡§ó‡•ç‡§∞‡§Ø‡•ã‡§ó-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç = Œ£-contractFst ‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É
