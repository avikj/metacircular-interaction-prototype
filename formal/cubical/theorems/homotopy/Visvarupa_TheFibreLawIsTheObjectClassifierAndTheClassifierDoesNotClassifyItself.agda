{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡ø‡‡‡µ‡∞‡‡‡Æ‡ ‚î the fibre law is the object classifier, and the classifier
-- does not classify itself.
--
-- TERM.  vivarpa, "the all-form": the one form in which every form is
-- seen.  Bhagavad-gt 11, Arjuna's vision.
-- The word is borrowed for its
-- OPERATION ‚î one object exhibited as containing every other ‚î and that
-- operation is what ¬ß1‚ì¬ß3 below make a term.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS FILE IS FOR
--
-- `Ekavakyata_FiveCollapsesOneTheoremAndEachTraditionSaysItInItsOwnWords`
-- exhibits five theorems, written in five lanes about five subjects, as
-- one SENTENCE.
-- This file names the AMBIENT FACT the five lanes are all speaking
-- inside of, and make it a checked term rather than a motif:
--
--     A FAMILY IS A MAP INTO THE UNIVERSE.  Œ IS ITS TOTAL SPACE.
--     TRANSPORT IS ITS PARALLEL TRANSPORT.  ONE OBJECT ‚î the universe ‚î
--     CLASSIFIES EVERY FAMILY WHOSE FIBRES IT CONTAINS, AND EVERY SUCH
--     FAMILY IS A PULLBACK OF ONE FIBRATION.
--
-- That is HoTT Theorem 4.8.3, the object classifier. It is standard, it is
-- already in agda/cubical as `fibrationEquiv`.
-- What is contributed here is the IDENTIFICATION ‚î that the corpus's
-- fibre law and the object classifier are the same object, checked by
-- importing the corpus's own decomposition and the library's and finding them
-- equal on the nose (¬ß0).
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß0  ‡‡∞‡‡µ‡µ‡ø‡‡æ‡ó‡-‡‡µ-totalEquiv ‚î the corpus's own decomposition
--       (`SarvavibhagaH`, every map is the sum of its fibres) and HoTT
--       Lemma 4.8.2 are the SAME EQUIVALENCE, by `equivEq refl`: their
--       underlying maps are definitionally identical and only the
--       packaging of the round-trips differs.  `refl` alone does NOT
--       typecheck ‚î the two Isos are built by different copattern
--       clauses and Agda will not identify them ‚î and that failure is
--       recorded here rather than hidden, because it is the exact size
--       of the claim.  So the fibre law was never a reading of the
--       classifier; it is the classifier's second half, written down
--       independently.
--
--   ¬ß1  ‡µ‡ø‡‡‡µ‡∞‡‡‡Æ‡ ‚î for every base A,
--           (Œ[ E ‚àà Type ‚ì ] (E ‚í A))  ‚â  (A ‚í Type ‚ì).
--       Fibrations over A, and maps A ‚í í∞, are the same thing.  This is
--       the object classifier, imported.
--
--   ¬ß2  ‡µ‡ø‡‡‡µ‡∞‡‡-‡‡®‡‡‡‡ ‚î the universal fibration is `fst` on the type of
--       POINTED types, and ITS FIBRE OVER X IS X.  The universe carries
--       one fibration whose fibre over each point is that point.
--       `the-universal-total-space-is-the-pointed-types` checks, by
--       `refl`, that Œ[ X ‚àà Type ‚ì ] X is the pointed types on the nose.
--
--   ¬ß3  every-family-is-a-pullback-of-the-universal-one ‚î for any
--       B : A ‚í Type ‚ì, the pullback of the universal fibration along B
--       is Œ A B.  "Pulling í∞ back gives you any shape you name",
--       as a term.
--
--   ¬ß4  ‡‡®‡‡µ‡‡‡‡‡ø‡ / -‡∞‡ø‡ï‡‡‡ / -‡Ø‡ã‡ó‡ / -‡‡Æ‡æ‡®‡‡æ ‚î transport in a family is a
--       CONNECTION: identity over refl, composition over ‚àô, and an
--       equivalence over every path.  A classifying map is therefore a
--       functor from the fundamental groupoid of the base into í∞, and
--       its holonomy around a loop is `subst B` around that loop.  This
--       is the exact sense in which "Œ + transport = parallel transport
--       = holonomy" is not a metaphor.
--
--   ¬ß5  holonomy-of-the-universal-family ‚î the holonomy of the universal
--       fibration at X is EXACTLY the automorphisms of X: (X ‚â° Y) ‚â
--       (X ‚â Y).  That is univalence, read as a statement about one
--       fibration.  And `the-universal-familys-transport-is-the-
--       equivalence` (uaŒ≤) is the computation rule that makes it bite:
--       transport in the universal family along `ua e` IS `e`.
--       `HolonomyIsInvisibleExactlyToAnInvariantSemantics` (README ¬ßII)
--       is a statement about this one fibration's holonomy.
--
--   ¬ß6  ‡‡µ‡∞‡ã‡‡‡Æ‡-‡‡®‡‡‡-‡‡‡‡ø‡∞‡Æ‡ ‚î a family that DESCENDS along f is constant
-- on the fibres of f. This is the general lemma under Pini's 8.2.1 as the
-- corpus reads it (README ¬ßI): to refute descent it suffices to exhibit one
-- fibre with two points the family separates, which is exactly what
-- `‡‡®‡‡‡‡‡‡¶‡` does.
--
--   ¬ß7  the-universal-fibration-is-classified-one-level-up ‚î the
--       classifying map of the universal fibration over Type ‚ì is a map
--       Type ‚ì ‚í Type (‚ì-suc ‚ì).  THE CLASSIFIER DOES NOT CLASSIFY
--       ITSELF.  There is no one object classifying every fibration
--       there is; there is one per level, and the tower is forced, not
--       a bookkeeping artefact.  Read in the corpus's own idiom this is
--       the fibre law applied to the classifier: the universe is blind
--       to its own total space, and the blindness is recovered only by
--       changing place ‚î one level up.
--
--   ¬ß8  ‡µ‡‡‡‡ü‡®‡Æ‡-‡‡®‡‡µ‡‡‡‡‡ø‡-‡‡µ, ‡‡ï‡æ‡µ‡‡‡‡‡ø‡ ‚î ONE TURN of the fibre law is not
--       vacuous.  `helix : S¬ ‚í Type‚` is one family over one circle;
--       `winding` is, by `refl`, parallel transport in it; and
--       `Œ©S¬Iso‚` says that transport is an isomorphism onto ‚.  A group
--       that was not put in comes out of one application of ¬ß4.
------------------------------------------------------------------------

module Visvarupa_TheFibreLawIsTheObjectClassifierAndTheClassifierDoesNotClassifyItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber ; equivFun ; equivToIso ; equivEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤ ; univalence ; pathToEquiv)
open import Cubical.Foundations.Transport using (substComposite)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.Pointed.Base using (Pointed)
open import Cubical.Functions.Fibration using (fiberEquiv ; totalEquiv ; fibrationEquiv)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd ; Œ£-syntax ; Œ£PathP)
open import Cubical.Data.Nat using (zero)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; suc‚Ñ§)
open import Cubical.HITs.S1.Base using (S¬π ; loop ; helix ; Œ©S¬π ; winding ; Œ©S¬πIso‚Ñ§)

open import SarvavibhagaH_EveryMapIsTheSumOfItsFibresOverItsCodomainSoTheIsomorphismTheoremIsAnekanta
  using (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É)
open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (‡§∏‡§∞‡§£‡§ø‡§É)

------------------------------------------------------------------------
-- ¬ß0  The corpus's fibre law and the library's classifier are one term.
--
-- `SarvavibhagaH` proves A ‚â Œ[ b ‚àà B ] fiber f b and reads it as the
-- first isomorphism theorem, rank‚ìnullity, dravya/paryya and nayavda.
-- `Cubical.Functions.Fibration.totalEquiv` is HoTT Lemma 4.8.2.  They
-- are not analogous and not isomorphic.  They are the same term.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É-‡§è‡§µ-totalEquiv :
  {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B)
  ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É f ‚â° totalEquiv f
‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É-‡§è‡§µ-totalEquiv f = equivEq refl

------------------------------------------------------------------------
-- ¬ß1  ‡µ‡ø‡‡‡µ‡∞‡‡‡Æ‡ ‚î the object classifier.  A fibration over A, and a map
--     from A into the universe, are the same thing.  (HoTT Thm 4.8.3.)
------------------------------------------------------------------------

‡§µ‡§ø‡§∂‡•ç‡§µ‡§∞‡•Ç‡§™‡§Æ‡•ç : {‚Ñì : Level} (A : Type ‚Ñì) ‚Üí (Œ£[ E ‚àà Type ‚Ñì ] (E ‚Üí A)) ‚âÉ (A ‚Üí Type ‚Ñì)
‡§µ‡§ø‡§∂‡•ç‡§µ‡§∞‡•Ç‡§™‡§Æ‡•ç {‚Ñì = ‚Ñì} A = fibrationEquiv A ‚Ñì

------------------------------------------------------------------------
-- ¬ß2  The universal fibration, and the fibre over X is X.
--
-- Its total space is Œ[ X ‚àà Type ‚ì ] X ‚î a type together with a point of
-- it ‚î which is on the nose the type of POINTED types, and the fibration
-- is "forget the point".
------------------------------------------------------------------------

Universal : (‚Ñì : Level) ‚Üí Type (‚Ñì-suc ‚Ñì)
Universal ‚Ñì = Œ£[ X ‚àà Type ‚Ñì ] X

universal : {‚Ñì : Level} ‚Üí Universal ‚Ñì ‚Üí Type ‚Ñì
universal = fst

the-universal-total-space-is-the-pointed-types :
  {‚Ñì : Level} ‚Üí Universal ‚Ñì ‚â° Pointed ‚Ñì
the-universal-total-space-is-the-pointed-types = refl

‡§µ‡§ø‡§∂‡•ç‡§µ‡§∞‡•Ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É : {‚Ñì : Level} (X : Type ‚Ñì) ‚Üí fiber (universal {‚Ñì}) X ‚âÉ X
‡§µ‡§ø‡§∂‡•ç‡§µ‡§∞‡•Ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É {‚Ñì = ‚Ñì} X = fiberEquiv (idfun (Type ‚Ñì)) X

------------------------------------------------------------------------
-- ¬ß3  Every family is a pullback of that one fibration.
------------------------------------------------------------------------

Pullback : {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì') ‚Üí Type (‚Ñì-max ‚Ñì (‚Ñì-suc ‚Ñì'))
Pullback {‚Ñì' = ‚Ñì'} {A = A} B = Œ£[ a ‚àà A ] fiber (universal {‚Ñì'}) (B a)

-- Plumbing only.  `Cubical.Data.Sigma`'s Œ-cong-equiv-snd holds the two
-- fibre families at ONE level, and here they sit at ‚ì' and ‚ì-suc ‚ì' ‚î
-- the pullback's fibre is a fibre of the universal fibration, which is
-- exactly one level up.  Same proof, levels separated.
private
  module _ {‚Ñì ‚Ñì‚ÇÅ ‚Ñì‚ÇÇ : Level} {A : Type ‚Ñì} {B : A ‚Üí Type ‚Ñì‚ÇÅ} {C : A ‚Üí Type ‚Ñì‚ÇÇ}
    (e : (a : A) ‚Üí B a ‚âÉ C a) where
    private
      it : (a : A) ‚Üí Iso (B a) (C a)
      it a = equivToIso (e a)

    Œ£-cong-snd-across-levels : Iso (Œ£[ a ‚àà A ] B a) (Œ£[ a ‚àà A ] C a)
    Iso.fun      Œ£-cong-snd-across-levels (a , b) = a , Iso.fun (it a) b
    Iso.inv      Œ£-cong-snd-across-levels (a , c) = a , Iso.inv (it a) c
    Iso.rightInv Œ£-cong-snd-across-levels (a , c) = Œ£PathP (refl , Iso.rightInv (it a) c)
    Iso.leftInv  Œ£-cong-snd-across-levels (a , b) = Œ£PathP (refl , Iso.leftInv (it a) b)

every-family-is-a-pullback-of-the-universal-one :
  {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì')
  ‚Üí Pullback B ‚âÉ (Œ£[ a ‚àà A ] B a)
every-family-is-a-pullback-of-the-universal-one B =
  isoToEquiv (Œ£-cong-snd-across-levels (Œª a ‚Üí ‡§µ‡§ø‡§∂‡•ç‡§µ‡§∞‡•Ç‡§™-‡§§‡§®‡•ç‡§§‡•Å‡§É (B a)))

------------------------------------------------------------------------
-- ¬ß4  ‡‡®‡‡µ‡‡‡‡‡ø‡ ‚î "carrying over".  Transport in a family is a connection:
--     it is the identity over refl, it composes over ‚àô, and it is an
--     equivalence over every path.  So a classifying map is a functor
--     from the fundamental groupoid of the base into the universe, and
--     the holonomy of a loop is transport around it.
------------------------------------------------------------------------

‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì') {a a' : A}
  ‚Üí a ‚â° a' ‚Üí B a ‚Üí B a'
‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É B p = subst B p

‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§∞‡§ø‡§ï‡•ç‡§§‡•á : {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì') {a : A} (b : B a)
  ‚Üí ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É B refl b ‚â° b
‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§∞‡§ø‡§ï‡•ç‡§§‡•á B b = substRefl {B = B} b

‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§Ø‡•ã‡§ó‡•á : {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì') {a a' a'' : A}
  (p : a ‚â° a') (q : a' ‚â° a'') (b : B a)
  ‚Üí ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É B (p ‚àô q) b ‚â° ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É B q (‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É B p b)
‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§Ø‡•ã‡§ó‡•á B p q b = substComposite B p q b

‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§∏‡§Æ‡§æ‡§®‡§§‡§æ : {‚Ñì ‚Ñì' : Level} {A : Type ‚Ñì} (B : A ‚Üí Type ‚Ñì') {a a' : A}
  ‚Üí a ‚â° a' ‚Üí B a ‚âÉ B a'
‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§∏‡§Æ‡§æ‡§®‡§§‡§æ B p = pathToEquiv (cong B p)

------------------------------------------------------------------------
-- ¬ß5  The holonomy of the universal fibration is exactly Aut.
--
-- Univalence, read as a statement about ONE fibration: the loops of the
-- base at X are the self-equivalences of the fibre over X.  `uaŒ≤` is the
-- computation rule that keeps this from being an assumed bijection ‚î
-- transport in the universal family along `ua e` is `e` itself.
------------------------------------------------------------------------

holonomy-of-the-universal-family :
  {‚Ñì : Level} {X Y : Type ‚Ñì} ‚Üí (X ‚â° Y) ‚âÉ (X ‚âÉ Y)
holonomy-of-the-universal-family = univalence

the-universal-familys-transport-is-the-equivalence :
  {‚Ñì : Level} {X Y : Type ‚Ñì} (e : X ‚âÉ Y) (x : X)
  ‚Üí ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (idfun (Type ‚Ñì)) (ua e) x ‚â° equivFun e x
the-universal-familys-transport-is-the-equivalence e x = uaŒ≤ e x

------------------------------------------------------------------------
-- ¬ß6  ‡‡µ‡∞‡ã‡‡‡Æ‡ ‚î descent, and the fibre as the obstruction to it.
--
-- A family on A descends along f : A ‚í B when it is the pullback of a
-- family on B.  A descended family is CONSTANT ON THE FIBRES of f, so
-- one fibre carrying two points the family separates refutes descent.
-- That refutation is what Pini's 8.2.1 performs on 8.4.56's two-point
-- fibre in the grammar lane; this is the lemma under it.
------------------------------------------------------------------------

‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§Æ‡•ç : {‚Ñì ‚Ñì' ‚Ñì'' : Level} {A : Type ‚Ñì} {B : Type ‚Ñì'}
  (f : A ‚Üí B) (P : A ‚Üí Type ‚Ñì'') ‚Üí Type (‚Ñì-max (‚Ñì-max ‚Ñì ‚Ñì') (‚Ñì-suc ‚Ñì''))
‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§Æ‡•ç {‚Ñì'' = ‚Ñì''} {A = A} {B = B} f P =
  Œ£[ Q ‚àà (B ‚Üí Type ‚Ñì'') ] ((a : A) ‚Üí Q (f a) ‚â° P a)

‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§Æ‡•ç-‡§§‡§®‡•ç‡§§‡•å-‡§∏‡•ç‡§•‡§ø‡§∞‡§Æ‡•ç : {‚Ñì ‚Ñì' ‚Ñì'' : Level} {A : Type ‚Ñì} {B : Type ‚Ñì'}
  (f : A ‚Üí B) (P : A ‚Üí Type ‚Ñì'')
  ‚Üí ‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§Æ‡•ç f P ‚Üí {a a' : A} ‚Üí f a ‚â° f a' ‚Üí P a ‚â° P a'
‡§Ö‡§µ‡§∞‡•ã‡§π‡§£‡§Æ‡•ç-‡§§‡§®‡•ç‡§§‡•å-‡§∏‡•ç‡§•‡§ø‡§∞‡§Æ‡•ç f P (Q , Œ±) {a} {a'} p = sym (Œ± a) ‚àô cong Q p ‚àô Œ± a'

------------------------------------------------------------------------
-- ¬ß7  The classifier does not classify itself.
--
-- The classifying map of the universal fibration over Type ‚ì is, by ¬ß2,
-- pointwise the identity ‚î and it lands in Type (‚ì-suc ‚ì).  There is no
-- single object classifying every fibration there is: there is one per
-- level, and the tower is forced.  A universe classifying its own
-- fibrations would be Type : Type, which is inconsistent.
--
-- Agda's level discipline is what makes the alternative unstatable here,
-- so this section is a WITNESS of the level shift, not a proof of its
-- necessity ‚î the type of the term is the content.
------------------------------------------------------------------------

the-universal-fibration : (‚Ñì : Level) ‚Üí Œ£[ E ‚àà Type (‚Ñì-suc ‚Ñì) ] (E ‚Üí Type ‚Ñì)
the-universal-fibration ‚Ñì = Universal ‚Ñì , universal

the-universal-fibration-is-classified-one-level-up :
  (‚Ñì : Level) ‚Üí Type ‚Ñì ‚Üí Type (‚Ñì-suc ‚Ñì)
the-universal-fibration-is-classified-one-level-up ‚Ñì = fiber (universal {‚Ñì})

------------------------------------------------------------------------
-- ¬ß8  One turn of the fibre law is not vacuous.
--
-- `helix : S¬ ‚í Type‚` is a single family over a single circle.  The
-- winding number is, definitionally, ¬ß4's transport in it ‚î and that
-- transport is an isomorphism onto ‚.  A group nobody put in comes out
-- of one application of the law.
------------------------------------------------------------------------

‡§µ‡•á‡§∑‡•ç‡§ü‡§®‡§Æ‡•ç-‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§è‡§µ : (p : Œ©S¬π) ‚Üí winding p ‚â° ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É helix p (pos zero)
‡§µ‡•á‡§∑‡•ç‡§ü‡§®‡§Æ‡•ç-‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§è‡§µ p = refl

‡§è‡§ï‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : Iso Œ©S¬π ‚Ñ§
‡§è‡§ï‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É = Œ©S¬πIso‚Ñ§

-- and the corpus already priced ONE loop of it.  `Pradakshina_` computes
-- the same family's transport at the generator; ¬ß4's `‡‡®‡‡µ‡‡‡‡‡ø‡` at `loop`
-- IS that map, so the two are one theorem read at one loop and at all of
-- them.  Imported rather than restated: if it moves, this goes red.
‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ-‡§è‡§µ-‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (x : ‚Ñ§) ‚Üí ‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É helix loop x ‚â° suc‚Ñ§ x
‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ-‡§è‡§µ-‡§Ö‡§®‡•Å‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É = ‡§∏‡§∞‡§£‡§ø‡§É
