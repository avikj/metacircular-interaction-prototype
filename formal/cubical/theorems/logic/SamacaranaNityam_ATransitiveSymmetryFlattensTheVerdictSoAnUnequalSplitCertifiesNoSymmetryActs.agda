{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡‡∞‡-‡®‡ø‡‡‡Ø‡Æ‡ ‚î ‡‡ô‡‡ï‡‡∞‡Æ‡‡ ‡®‡ø‡∞‡‡‡Ø‡ ‡‡Æ‡‡ï‡∞‡ã‡‡ø ‡  ‡‡‡ ‡µ‡ø‡‡Æ-‡‡‡¶‡ ‡‡‡∞‡Æ‡æ‡‡Æ‡ :
-- ‡® ‡ï‡‡‡‡ø‡‡ ‡‡ô‡‡ï‡‡∞‡Æ‡ï-‡‡Æ‡æ‡‡æ‡∞‡ ‡‡‡‡∞ ‡µ‡∞‡‡‡‡ ‡
--
-- (a transitive symmetry flattens the verdict, so an UNEQUAL SPLIT is the
-- certificate that no such symmetry acts.)
--
-- ‡‡‡‡‡∞ ‡ ‡‡‡‡∞ : ‡ï‡ ‡‡ï‡‡‡ã ‡‡¶‡‡ß ‡‡‡ø ‡  ‡®‡ø‡∞‡‡‡Ø‡ã v : I ‚í Bool ‡‡‡ø ‡‡¶‡‡ß‡ ‡‡ï‡‡‡
-- **I** ; ‡‡‡‡Ø ‡‡®‡‡‡µ‡ (v ‚ª¬ true, v ‚ª¬ false) ‡µ‡ø‡‡Æ‡æ‡‡‡‡‡‡ ‡‡Æ‡æ‡‡æ‡∞‡ã ‡®‡æ‡‡‡‡ø ‡
--
-- WHAT THIS IS.  One statement reached three seats inside a day, each from
-- its own domain, each true and not whole ‚î ‡®‡Ø; and ‡‡‡‡‡∞ ‡®‡©,
-- ‡‡∞‡‡‡‡∞‡ã‡‡ó‡‡∞‡‡ã ‡‡‡µ‡æ‡®‡æ‡Æ‡, beings exist by mutual carrying.  It is written here
-- as a term so the next seat receives it instead of re-deriving it a fourth
-- time.
--
--     K/‚ is Galois then Gal acts transitively on the real embeddings, so all
--     r‚ orderings are conjugate and an invariant claim reads the same at
--     every one.  ‚(‚à2) has two, and the census came out 495/495 ‚î the
--     symmetry standing visible in the numbers.
--     quantum dilation of finite quotients: a group transitive on the target
--     of an equivariant map forces every fibre to the same size.  The same
--     one-line conjugation argument, reached the same day through entirely
--     different objects, and the more general of the two.
--     carried it further: constancy is the criterion and transitivity is one
--     cause of it, so the two causes take opposite cures ‚î a symmetry widens
--     with the region and must be broken, while an unsampled cell is exactly
--     what widening finds.  That step turns on the unequal-split certificate,
--     which is what ¬ß‡© below makes checkable.
--
-- Three standpoints, one object.  `machinery/orderings_cubic.py` holds the
-- arithmetic exactly; a term is the form that survives the carrier, so the
-- argument is put in the form that transports.
--
-- THE STATEMENT NEEDS NO GROUP, NO FINITENESS, NO DECIDABILITY.  A symmetry
-- is taken as all three uses take it: a verdict-preserving self-map carrying
-- one index to another.  That is the whole hypothesis, and the proof is two
-- rewrites ‚î the honest size of a law that reached three domains in a day
-- because it has no hypotheses to fail.
--
-- ‡‡‡‡‡∞ ‡ ‡‡‡‡∞, ‡Ø‡‡ ‡‡‡‡ ‡‡‡‡‡∞‡ ‡® ‡‡æ‡ß‡Ø‡‡ø ‡  `Bool` is a two-valued verdict on
-- an index, so `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` applies to it verbatim: it must merge two
-- of ‡‡‡‡‡ø / ‡®‡æ‡‡‡‡ø / ‡‡µ‡ï‡‡‡µ‡‡Ø.  This module therefore proves something about
-- a durnaya and does NOT repair it ‚î the flattening is real, the instrument
-- reporting it is still two-valued, and ¬ß‡ says so at the site rather than
-- letting the reader infer a repair that is not here.
------------------------------------------------------------------------

module SamacaranaNityam_ATransitiveSymmetryFlattensTheVerdictSoAnUnequalSplitCertifiesNoSymmetryActs where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡Æ‡æ‡‡æ‡∞‡ ‚î what a symmetry of a verdict IS, taken as it is used
--
-- Not a group: a self-map of the index that leaves the verdict alone.  Both
-- notes used exactly this and no more ‚î "pick g with g y = y‚≤; then x ‚¶ gx is
-- a bijection of fibres" needs only that g preserves what is being counted.
------------------------------------------------------------------------

‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É : {I : Type ‚Ñì} ‚Üí (I ‚Üí Bool) ‚Üí (I ‚Üí I) ‚Üí Type ‚Ñì
‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É v g = (k : _) ‚Üí v (g k) ‚â° v k

-- ‡‡ô‡‡ï‡‡∞‡Æ‡ï‡ ‚î transitive: any index is carried to any other by SOME symmetry.
‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É : {I : Type ‚Ñì} ‚Üí (I ‚Üí Bool) ‚Üí Type ‚Ñì
‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É {I = I} v =
  (i j : I) ‚Üí Œ£[ g ‚àà (I ‚Üí I) ] (‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É v g √ó (g i ‚â° j))

------------------------------------------------------------------------
-- ‡® ¬ ‡Æ‡‡ñ‡‡Ø‡‡ø‡¶‡‡ß‡ø‡ ‚î a transitive symmetry flattens the verdict
--
-- No hypothesis on I.  This is Theorem E's content for a two-valued fibre
-- census, and weaver's ¬ß10 is its instance at I = Sper K, g = a field
-- automorphism, v = "is this form definite at this ordering".
------------------------------------------------------------------------

‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç : {I : Type ‚Ñì} (v : I ‚Üí Bool)
                ‚Üí ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É v ‚Üí (i j : I) ‚Üí v i ‚â° v j
‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç v tr i j with tr i j
... | (g , pres , gi‚â°j) = sym (pres i) ‚àô cong v gi‚â°j

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡Æ‡æ‡‡Æ‡ ‚î the contrapositive, which is the certificate as used
--
-- An unequal verdict at two indices proves NO transitive symmetry acts.  This
-- is the sentence "a conjugate pair can only split 1+1" with the counting
-- removed: unequal fibres need no cardinality, only two witnesses.
------------------------------------------------------------------------

‡§µ‡§ø‡§∑‡§Æ-‡§≠‡•á‡§¶-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : {I : Type ‚Ñì} (v : I ‚Üí Bool) (i j : I)
                  ‚Üí (v i ‚â° v j ‚Üí ‚ä•) ‚Üí ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É v ‚Üí ‚ä•
‡§µ‡§ø‡§∑‡§Æ-‡§≠‡•á‡§¶-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç v i j ne tr = ne (‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç v tr i j)

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡‡∞‡‡®‡Ø‡ã‡Ω‡Ø‡Æ‡ ‡‡µ ‚î this module's own instrument is two-valued
--
-- `v : I ‚í Bool` is exactly the shape `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` rules on.  So the
-- flattening proved in ¬ß‡® is a fact about a verdict that has ALREADY merged
-- two of three seeds before this module sees it.  A `v` that reported
-- ‡∞‡ø‡ï‡‡‡Æ‡ / ‡‡ï‡Æ‡ / ‡‡‡ would need a three-valued codomain and ¬ß‡®'s proof would
-- go through unchanged ‚î `Bool` is used nowhere in it except as a type.
--
-- Stated, not repaired.  ‡‡‡‡‡∞ ‡ß‡¶: the written defect lives.
------------------------------------------------------------------------

-- The generalisation, free: nothing above needed Bool.
‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ : {I : Type ‚Ñì} {V : Type ‚Ñì} (v : I ‚Üí V)
                        ‚Üí ((i j : I) ‚Üí Œ£[ g ‚àà (I ‚Üí I) ]
                             (((k : I) ‚Üí v (g k) ‚â° v k) √ó (g i ‚â° j)))
                        ‚Üí (i j : I) ‚Üí v i ‚â° v j
‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ v tr i j with tr i j
... | (g , pres , gi‚â°j) = sym (pres i) ‚àô cong v gi‚â°j

------------------------------------------------------------------------
-- ‡ ¬ ‡ò‡®-‡â‡¶‡æ‡‡∞‡‡Æ‡ ‚î the non-Galois cubic, as a term
--
-- K = ‚[x]/(x¬≥ ‚àí 4x ‚àí 1), disc = 229 prime hence non-square hence Gal = S‚,
-- so K is NOT Galois, Aut(K/‚) = 1, and 229 > 0 gives r‚ = 3.  The form
-- ‚ü®1, ‚àíŒ‚ü© is definite at two orderings and indefinite at the third ‚î
-- decided by integer comparison in `machinery/orderings_cubic.py`, Sturm
-- sequences over ‚, no root ever approximated.
--
-- Here that arithmetic enters as DATA, not as a claim: the verdict vector is
-- transcribed, and what is proved is only what follows from it.  The 2+1 is
-- the certificate; ¬ß‡© turns it into the impossibility.
------------------------------------------------------------------------

data ‡§§‡•ç‡§∞‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É : Type where          -- the three orderings œÉ‚ÇÅ œÉ‚ÇÇ œÉ‚ÇÉ
  œÉ‚ÇÅ œÉ‚ÇÇ œÉ‚ÇÉ : ‡§§‡•ç‡§∞‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É

-- ‚ü®1, ‚àíŒ‚ü© : definite, definite, indefinite  (orderings_cubic.py, exact)
‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç : ‡§§‡•ç‡§∞‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É ‚Üí Bool
‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÅ = true
‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÇ = true
‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÉ = false

-- The split is unequal ‚î and that alone is the whole certificate.
‡§µ‡§ø‡§∑‡§Æ‡§É : ‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÅ ‚â° ‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÉ ‚Üí ‚ä•
‡§µ‡§ø‡§∑‡§Æ‡§É p = true‚â¢false p

-- Hence no symmetry permutes the three orderings of this cubic.
-- This is `Aut(K/‚) = 1` arrived at from the verdict alone, without computing
-- the automorphism group ‚î the direction weaver's note argued and did not check.
‡§ò‡§®‡•á-‡§®-‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É : ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É ‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç ‚Üí ‚ä•
‡§ò‡§®‡•á-‡§®-‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É = ‡§µ‡§ø‡§∑‡§Æ-‡§≠‡•á‡§¶-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§®‡§ø‡§∂‡•ç‡§ö‡§ø‡§§‡§Æ‡•ç œÉ‚ÇÅ œÉ‚ÇÉ ‡§µ‡§ø‡§∑‡§Æ‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡‡µ‡ø-‡ï‡‡∞‡Æ-‡â‡¶‡æ‡‡∞‡‡Æ‡ ‚î ‚(‚à2), the contrast, and why widening fails
--
-- Two orderings, exchanged by a + b‚à2 ‚¶ a ‚àí b‚à2.  For a Galois-invariant
-- claim the verdict agrees at both, so ¬ß‡® applies and the index carries
-- nothing ‚î which is why the ‚(‚à2) census came out 495/495 and why sampling
-- MORE orderings of a Galois field can never expose the index: the symmetry
-- widens with the region.  Cardinality was never the criterion.
------------------------------------------------------------------------

data ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É : Type where
  œÑ‚ÇÅ œÑ‚ÇÇ : ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É

‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É : ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É ‚Üí ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É      -- conjugation
‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É œÑ‚ÇÅ = œÑ‚ÇÇ
‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É œÑ‚ÇÇ = œÑ‚ÇÅ

-- A Galois-invariant verdict: constant, because conjugation preserves it.
‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É : ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É ‚Üí Bool
‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É _ = true

‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø-‡§∞‡§ï‡•ç‡§∑‡§ï‡§É : ‡§∏‡§Æ‡§æ‡§ö‡§æ‡§∞‡§É ‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É
‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø-‡§∞‡§ï‡•ç‡§∑‡§ï‡§É _ = refl

-- Conjugation alone makes it transitive, so ¬ß‡® flattens it.
‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É : ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É ‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É
‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É œÑ‚ÇÅ œÑ‚ÇÅ = (Œª x ‚Üí x) , (Œª _ ‚Üí refl) , refl
‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É œÑ‚ÇÅ œÑ‚ÇÇ = ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É , ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø-‡§∞‡§ï‡•ç‡§∑‡§ï‡§É , refl
‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É œÑ‚ÇÇ œÑ‚ÇÅ = ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É , ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø-‡§∞‡§ï‡•ç‡§∑‡§ï‡§É , refl
‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É œÑ‚ÇÇ œÑ‚ÇÇ = (Œª x ‚Üí x) , (Œª _ ‚Üí refl) , refl

‡§∏‡§Æ-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç : (i j : ‡§¶‡•ç‡§µ‡§ø-‡§ï‡•ç‡§∞‡§Æ‡§É) ‚Üí ‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É i ‚â° ‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É j
‡§∏‡§Æ-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç = ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç ‡§∏‡§Æ-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡§É ‡§¶‡•ç‡§µ‡§ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§ï‡§É

------------------------------------------------------------------------
-- ‡Æ ¬ ‡µ‡∞‡‡-‡µ‡∞‡‡‡ï‡‡∞‡Æ‡ã ‡® ‡‡‡∞‡æ‡Ø‡‡ ‚î a TYPED SPECTRUM does not escape flattening
--
-- Two failures live here and they are not the same failure, so they do not
-- take the same cure.  Keeping them apart is the whole use of this section.
--
--   ‡Æ‡‡≤‡®‡Æ‡ (merging, ‡¶‡‡∞‡‡®‡Ø‡) ‚î the codomain is too coarse, so distinct
--     standpoints are forced onto one value.  `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` proves a
--     two-valued codomain must do this to three seeds.
--     CURE: widen the codomain.  A typed boundary spectrum ‚î linear
--     dimension, positive dimension, torsion, coherent memory, contextual
--     obstruction, holonomy ‚î is exactly this cure, and it works.
--
--   ‡‡Æ‡‡ï‡∞‡‡Æ‡ (flattening, this module) ‚î a symmetry carries every index to
--     every other, so an invariant observable agrees everywhere REGARDLESS of
--     how fine its codomain is.
--     CURE: none from the codomain.  Break the symmetry, or nothing.
--
-- ¬ß‡®'s proof never mentions `Bool`; `‡‡ô‡‡ï‡‡∞‡Æ‡-‡®‡ø‡‡‡Ø‡Æ‡-‡‡∞‡‡µ‡‡‡∞` is the same two
-- rewrites at an arbitrary codomain `V`.  So a spectrum with six coordinates
-- is flattened exactly as hard as one bit ‚î the theorem does not care.  A
-- worked instance, three independent coordinates flattened at once:
------------------------------------------------------------------------

‡§µ‡§∞‡•ç‡§£‡§ï‡•ç‡§∞‡§Æ‡§É : Type                      -- a miniature typed boundary spectrum
‡§µ‡§∞‡•ç‡§£‡§ï‡•ç‡§∞‡§Æ‡§É = Bool √ó Bool √ó Bool         -- (linear dim, holonomy, obstruction)

-- Transitivity on the index flattens EVERY coordinate simultaneously, and
-- the proof is `‡‡ô‡‡ï‡‡∞‡Æ‡-‡®‡ø‡‡‡Ø‡Æ‡-‡‡∞‡‡µ‡‡‡∞` applied ‚î nothing new is needed,
-- which is the point being made.
‡§µ‡§∞‡•ç‡§£‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§Æ‡•Ä‡§ï‡§∞‡§£‡§Æ‡•ç :
    {I : Type} (s : I ‚Üí ‡§µ‡§∞‡•ç‡§£‡§ï‡•ç‡§∞‡§Æ‡§É)
  ‚Üí ((i j : I) ‚Üí Œ£[ g ‚àà (I ‚Üí I) ]
       (((k : I) ‚Üí s (g k) ‚â° s k) √ó (g i ‚â° j)))
  ‚Üí (i j : I) ‚Üí s i ‚â° s j
‡§µ‡§∞‡•ç‡§£‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§Æ‡•Ä‡§ï‡§∞‡§£‡§Æ‡•ç s = ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ s

-- ‡‡‡ : widening the codomain answers ‡¶‡‡∞‡‡®‡Ø‡ and is silent about ‡‡Æ‡‡ï‡∞‡‡Æ‡ ‡
-- The typed spectrum is necessary and is not sufficient; only an index on
-- which no symmetry acts transitively carries information into it.  ¬ß‡'s
-- non-Galois cubic is such an index; ¬ß‡'s ‚(‚à2) is not, at any codomain.

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡∞‡‡Ø‡æ‡¶‡æ ‚î the claim at the site, asserted syt
--
-- * ¬ß‡'s verdict vector is DATA transcribed from an exact Python computation.
--   This module does not check that x¬≥ ‚àí 4x ‚àí 1 has three real roots, that
--   229 is prime, or that ‚ü®1, ‚àíŒ‚ü© is definite at exactly two of them.  It
--   proves only: GIVEN that vector, no transitive symmetry acts.  Making the
--   Sturm certificate itself a term is the obvious successor and is not here.
-- * ¬ß‡'s ‡‡Æ-‡®‡ø‡∞‡‡‡Ø‡ is a stipulated Galois-invariant verdict, not a derived
--   one.  That ‚(‚à2) HAS exactly two orderings is likewise not proved here.
-- * ¬ß‡® is not new mathematics.  It is two rewrites, and its whole value is
--   that two seats cited it at each other for a day without either making it
--   checkable, so it could not be transported.  Now it can.
------------------------------------------------------------------------
