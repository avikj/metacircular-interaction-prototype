{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡¶‡‡-‡‡ô‡‡ò‡æ‡‡ ‚î the CENSUS composes, and the composition law is the reason
-- there is no shortest-path formulation of routing in this corpus.
--
-- WHAT WAS ALREADY THERE, and is used rather than reproved:
--   * `‡‡‡-‡‡ô‡‡ò‡æ‡‡` (SankramanaSesa) ‚î fibres compose:
--         ‡‡‡ (g ‚àò f) z  ‚â  Œ[ w ‚àà ‡‡‡ g z ] ‡‡‡ f (fst w)
--   * `‡¶‡‡` (Loss.SakalaVikalaDesa) ‚î the census as a TERM, three
--     constructors carrying their evidence: ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (empty fibre, nothing
--     lost, ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡), ‡‡ï‡≤‡æ‡¶‡‡ (contractible), ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ (two points, exhibited).
--
-- WHAT IS MISSING AND IS BUILT HERE.  The Œ-law is about FIBRES.  Nobody
-- lifted it to the CENSUS, and that lift is the whole content of "what does
-- a route cost".  `SakalaVikalaDesa` ¬ß3 exhibits the cancellation as three
-- hand-computed instances on Unit/Bool and reads the moral off them.  Here
-- it is the general mechanism, and the instances become corollaries.
--
-- THE THREE LAWS, and what each one kills.
--
-- ¬ß‡® ‡‡µ‡ï‡‡‡µ‡‡Ø-‡ó‡‡∞‡æ‡‡ ‚î an empty OUTER fibre is ABSORBING.  ¬ ‡‡‡ g z forces
--    ¬ ‡‡‡ (g ‚àò f) z, whatever f is.  So arbitrary loss upstream of an
--    inexpressible point is INVISIBLE in the composite.  This kills
--    monotonicity: extending a path can hide cost already paid.
--
-- ¬ß‡© ‡‡ï‡≤-‡‡ô‡‡ï‡‡∞‡Æ‡ ‚î a contractible OUTER fibre is TRANSPARENT.  With centre
--    (b , p), ‡‡‡ (g ‚àò f) z ‚â ‡‡‡ f b: the composite's census at z IS f's
--    census at b, on the nose.  This is the only case in which a scalar
--    weight would have been correct, and it is the case where the weight
--    is not needed.
--
-- ¬ß‡ ‡‡‡∞‡‡ø‡‡®‡®‡Æ‡ ‚î the cancellation, as a mechanism.  A CROWDED outer fibre
--    whose points have empty inner fibres except one contractible entry
--    yields a CONTRACTIBLE composite.  ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ ‚àò ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ = ‡‡ï‡≤‡æ‡¶‡‡.  Two
--    genuine defects annihilate.  ¬ß‡ instantiates this at Unit ‚í Bool ‚í
--    Unit and recovers SakalaVikalaDesa ¬ß3's computed example as a
--    corollary of the general law rather than as a witness of it.
--
-- THE CONSEQUENCE FOR ROUTING, which is why this file exists.  A cost model
-- admits a shortest-path algorithm when costs form a graded monoid: an
-- associative accumulation, monotone under extension.  ¬ß‡® refutes
-- monotonicity and ¬ß‡ refutes any accumulation at all ‚î the composite's
-- census is not a function of the two censuses, because ¬ß‡'s outcome
-- depends on WHICH points of the outer fibre carry which inner fibres, data
-- that neither census records.  The correct object is not a weight but the
-- Œ itself: cost is a SECTION over the codomain, and composition is
-- dependent sum, not addition.  Dijkstra has no formulation here; the
-- routing target is `isEquiv`, which `SakalaVikalaDesa` ¬ß4 already
-- identifies as "every point of the census is ‡‡ï‡≤‡æ‡¶‡‡".
--
-- ‡¶‡‡-‡‡ô‡‡ò‡æ‡ is built here from the corpus's own two words, 2026-08-22.  No
-- source is claimed for the mathematics; the Jain attributions for ‡‡ï‡≤‡æ‡¶‡‡
-- / ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ are carried, at ‡‡‡‡¶ grade, from the module that defines them.
------------------------------------------------------------------------

module DesaSanghata_TheCensusComposesAndThatIsWhyCostIsNotAGradedMonoid where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open Iso
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Foundations.Transport using (transport‚ÅªTransport)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; false‚â¢true ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level
    A B C : Type ‚Ñì

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡ and the composition law, restated locally at the level the
-- corpus states them, so this file stands alone under the kernel.
-- (‡‡‡-‡‡ô‡‡ò‡æ‡‡ is SankramanaSesa's theorem; the proof term
-- below is the same one, cited, not claimed.)
------------------------------------------------------------------------

‡§∂‡•á‡§∑ : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí B ‚Üí Type ‚Ñì
‡§∂‡•á‡§∑ {A = A} f b = Œ£[ a ‚àà A ] (f a ‚â° b)

module _ {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C) where

  private
    fwd : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z ‚Üí Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)
    fwd (a , p) = ((f a , p) , (a , refl))

    bwd : (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z
    bwd ((b , q) , (a , p)) = (a , cong g p ‚àô q)

    bwd-fwd : (x : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z) ‚Üí bwd (fwd x) ‚â° x
    bwd-fwd (a , p) i = (a , sym (lUnit p) i)

    fwd-bwd : (w : Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí fwd (bwd w) ‚â° w
    fwd-bwd ((b , q) , (a , p)) = lem a b p q
      where
      lem : (a : A) (b : B) (p : f a ‚â° b) (q : g b ‚â° z)
          ‚Üí fwd (bwd ((b , q) , (a , p))) ‚â° ((b , q) , (a , p))
      lem a b p q =
        J (Œª b' p' ‚Üí (q' : g b' ‚â° z)
              ‚Üí fwd (bwd ((b' , q') , (a , p'))) ‚â° ((b' , q') , (a , p')))
          (Œª q' i ‚Üí ((f a , lUnit q' (~ i)) , (a , refl)))
          p q

  ‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z ‚âÉ (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w))
  ‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É = isoToEquiv (iso fwd bwd fwd-bwd bwd-fwd)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡µ‡ï‡‡‡µ‡‡Ø-‡ó‡‡∞‡æ‡‡ ‚î the empty outer fibre swallows everything upstream.
-- MONOTONICITY DIES HERE: f may lose arbitrarily much and the composite
-- records none of it.
------------------------------------------------------------------------

‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø-‡§ó‡•ç‡§∞‡§æ‡§∏‡§É : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C)
                ‚Üí ¬¨ (‡§∂‡•á‡§∑ g z) ‚Üí ¬¨ (‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z)
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø-‡§ó‡•ç‡§∞‡§æ‡§∏‡§É f g z ne (a , p) = ne (f a , p)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ï‡≤-‡‡ô‡‡ï‡‡∞‡Æ‡ ‚î the contractible outer fibre is transparent.
-- The composite's census at z IS f's census at the centre.
------------------------------------------------------------------------

‡§∏‡§ï‡§≤-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§É : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C)
             ‚Üí (c : isContr (‡§∂‡•á‡§∑ g z))
             ‚Üí ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z ‚âÉ ‡§∂‡•á‡§∑ f (fst (fst c))
‡§∏‡§ï‡§≤-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§É f g z c =
  compEquiv (‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É f g z)
            (isoToEquiv (iso to fro to-fro fro-to))
  where
    b‚ÇÄ = fst (fst c)
    to : (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí ‡§∂‡•á‡§∑ f b‚ÇÄ
    to (w , r) = subst (‡§∂‡•á‡§∑ f) (cong fst (sym (snd c w))) r
    fro : ‡§∂‡•á‡§∑ f b‚ÇÄ ‚Üí Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)
    fro r = fst c , r
    to-fro : (r : ‡§∂‡•á‡§∑ f b‚ÇÄ) ‚Üí to (fro r) ‚â° r
    to-fro r =
      cong (Œª pth ‚Üí subst (‡§∂‡•á‡§∑ f) (cong fst pth) r)
           (isProp‚ÜíisSet (isContr‚ÜíisProp c) (fst c) (fst c) (sym (snd c (fst c))) refl)
      ‚àô substRefl {B = ‡§∂‡•á‡§∑ f} r
    fro-to : (wr : Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí fro (to wr) ‚â° wr
    fro-to (w , r) =
      Œ£PathP ( snd c w
             , toPathP (transport‚ÅªTransport (cong (‡§∂‡•á‡§∑ f) (cong fst (sym (snd c w)))) r
                        ‚àô refl) )

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡∞‡‡ø‡‡®‡®‡Æ‡ ‚î the cancellation, as the general mechanism.
--
-- The composite is the Œ of the inner fibres over the outer fibre.  So a
-- CROWDED outer fibre contributes only at those of its points whose inner
-- fibre is inhabited: emptiness downstream DELETES points of the outer
-- fibre.  ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ above ‚àò ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ below can be ‡‡ï‡≤‡æ‡¶‡‡.
--
-- Stated as the exact criterion the Œ gives: the composite is contractible
-- exactly when the Œ is, and the Œ can be contractible while the outer
-- fibre is not.  ¬ß‡ exhibits that, minimally.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡§ø‡§π‡§®‡§®‡§Æ‡•ç : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C)
           ‚Üí isContr (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w))
           ‚Üí isContr (‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z)
‡§™‡•ç‡§∞‡§§‡§ø‡§π‡§®‡§®‡§Æ‡•ç f g z ic =
  isOfHLevelRespectEquiv 0 (invEquiv (‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É f g z)) ic

------------------------------------------------------------------------
-- ‡ ¬ The minimal witness, recovered as a COROLLARY of ¬ß‡ rather than as
-- an example standing on its own.  SakalaVikalaDesa ¬ß3 computes these three
-- censuses by hand; here the third follows from the first two through the Œ.
------------------------------------------------------------------------

‡§∏‡§§‡•ç : Unit ‚Üí Bool
‡§∏‡§§‡•ç _ = true

‡§è‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§è‡§ï‡§Æ‡•ç _ = tt

-- outer (‡‡ï‡Æ‡ at tt) is CROWDED: false and true both sit over tt
‡§¨‡§π‡§ø‡§É-‡§µ‡§æ‡§Æ ‡§¨‡§π‡§ø‡§É-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : ‡§∂‡•á‡§∑ ‡§è‡§ï‡§Æ‡•ç tt
‡§¨‡§π‡§ø‡§É-‡§µ‡§æ‡§Æ   = false , refl
‡§¨‡§π‡§ø‡§É-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ = true  , refl

‡§¨‡§π‡§ø‡§É-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : ¬¨ (‡§¨‡§π‡§ø‡§É-‡§µ‡§æ‡§Æ ‚â° ‡§¨‡§π‡§ø‡§É-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§¨‡§π‡§ø‡§É-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç p = false‚â¢true (cong fst p)

-- inner over `false` is EMPTY ‚î this is the point the Œ deletes
‡§Ö‡§®‡•ç‡§§‡§É-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç : ¬¨ (‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç false)
‡§Ö‡§®‡•ç‡§§‡§É-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç (_ , p) = true‚â¢false p

-- inner over `true` is contractible
‡§Ö‡§®‡•ç‡§§‡§É-‡§∏‡§ï‡§≤‡§Æ‡•ç : isContr (‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç true)
fst ‡§Ö‡§®‡•ç‡§§‡§É-‡§∏‡§ï‡§≤‡§Æ‡•ç          = tt , refl
snd ‡§Ö‡§®‡•ç‡§§‡§É-‡§∏‡§ï‡§≤‡§Æ‡•ç (u , p) i = tt , isSetBool true true refl p i

-- THE DELETION, isolated as its own term and structural (no `with`, per the
-- house discipline): an outer point whose inner fibre is inhabited MUST be
-- `true`.  This is exactly "emptiness downstream deletes points of the outer
-- fibre" ‚î the mechanism of ¬ß‡, at its smallest.
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç : (b : Bool) ‚Üí ‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç b ‚Üí true ‚â° b
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç true  _ = refl
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç false r = ‚ä•-rec (‡§Ö‡§®‡•ç‡§§‡§É-‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç r)

-- the Œ therefore has exactly one inhabitant ‚î and the reason is the
-- Carrier law itself: after the deletion, what remains is literally
-- `singl true`, contractible with no hypothesis (‡‡‡®‡∞‡æ‡ó‡Æ‡®).  So the
-- annihilation of two defects is not a coincidence of this example; it is
-- `isContrSingl` showing through.
‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É : Iso (Œ£[ w ‚àà ‡§∂‡•á‡§∑ ‡§è‡§ï‡§Æ‡•ç tt ] ‡§∂‡•á‡§∑ ‡§∏‡§§‡•ç (fst w)) (singl true)
Iso.fun      ‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É ((b , q) , (u , p)) = b , p
Iso.inv      ‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É (b , p)             = (b , refl) , (tt , p)
Iso.rightInv ‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É (b , p)             = refl
Iso.leftInv  ‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É ((b , q) , (u , p)) i =
  (b , isSetUnit tt tt refl q i) , (tt , p)

‡§∏‡§Ç‡§π‡§§‡§ø-‡§∏‡§ï‡§≤‡§Æ‡•ç : isContr (‡§∂‡•á‡§∑ (Œª u ‚Üí ‡§è‡§ï‡§Æ‡•ç (‡§∏‡§§‡•ç u)) tt)
‡§∏‡§Ç‡§π‡§§‡§ø-‡§∏‡§ï‡§≤‡§Æ‡•ç =
  ‡§™‡•ç‡§∞‡§§‡§ø‡§π‡§®‡§®‡§Æ‡•ç ‡§∏‡§§‡•ç ‡§è‡§ï‡§Æ‡•ç tt
    (isOfHLevelRespectEquiv 0
      (invEquiv (isoToEquiv ‡§∏‡§Ç‡§π‡§§‡§ø-Iso-‡§µ‡§æ‡§π‡§ï‡§É))
      (isContrSingl true))

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡ ‚î what this does NOT give, written rather than glossed.
--
-- ¬ß‡ is stated as "if the Œ is contractible then the composite is".  It is
-- NOT a function from (‡¶‡‡ g z) and (‡¶‡‡ f) to (‡¶‡‡ (g ‚àò f) z), and no such
-- function exists: ¬ß‡'s outcome depends on WHICH point of the outer fibre
-- carries the empty inner fibre, and a census records only that the outer
-- fibre is crowded, not which of its points are which.  That is precisely
-- why cost here is a Œ and not a weight.  The seam of SakalaVikalaDesa ¬ß4
-- (levels ‡© and ‡ unseparated) is inherited unchanged; nothing here
-- distinguishes them either.
------------------------------------------------------------------------
