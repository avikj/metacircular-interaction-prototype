{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विश्वरूपम् — the fibre law is the object classifier, and the classifier
-- does not classify itself.
--
-- TERM.  viśvarūpa, "the all-form": the one form in which every form is
-- seen.  Bhagavad-gītā 11, Arjuna's vision.  No claim is made that the
-- Gītā says anything about universes; the word is borrowed for its
-- OPERATION — one object exhibited as containing every other — and that
-- operation is what §1–§3 below make a term.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS FILE IS FOR
--
-- `Ekavakyata_FiveCollapsesOneTheoremAndEachTraditionSaysItInItsOwnWords`
-- exhibits five theorems, written in five lanes about five subjects, as
-- one SENTENCE, and its closing section says exactly what it withholds:
--
--     NOT that the five are instances of one formal statement.  They are
--     not: their types differ, their ambient structures differ, and no
--     functor between them is constructed.  A common generalisation
--     would be a real theorem; it is not proved.
--
-- This file is not that functor and does not weaken that disclaimer.
-- What it does is name the AMBIENT FACT the five lanes are all speaking
-- inside of, and make it a checked term rather than a motif:
--
--     A FAMILY IS A MAP INTO THE UNIVERSE.  Σ IS ITS TOTAL SPACE.
--     TRANSPORT IS ITS PARALLEL TRANSPORT.  ONE OBJECT — the universe —
--     CLASSIFIES EVERY FAMILY WHOSE FIBRES IT CONTAINS, AND EVERY SUCH
--     FAMILY IS A PULLBACK OF ONE FIBRATION.
--
-- That is HoTT Theorem 4.8.3, the object classifier.  It is standard,
-- it is already in agda/cubical as `fibrationEquiv`, and NO NOVELTY IS
-- CLAIMED FOR IT.  What is contributed here is the IDENTIFICATION —
-- that the corpus's fibre law and the object classifier are the same
-- object, checked by importing the corpus's own decomposition and the
-- library's and finding them equal on the nose (§0) — together with the
-- three places where reading the identification as "the shape of the
-- universe, iterated, makes arbitrary form" OVERREACHES, each stated as
-- a limit rather than glossed (§7, and WHAT IS NOT CLAIMED below).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §0  सर्वविभागः-एव-totalEquiv — the corpus's own decomposition
--       (`SarvavibhagaH`, every map is the sum of its fibres) and HoTT
--       Lemma 4.8.2 are ONE TERM, `refl`.  So the fibre law was never a
--       reading of the classifier; it is the classifier's second half,
--       written down independently.
--
--   §1  विश्वरूपम् — for every base A,
--           (Σ[ E ∈ Type ℓ ] (E → A))  ≃  (A → Type ℓ).
--       Fibrations over A, and maps A → 𝒰, are the same thing.  This is
--       the object classifier, imported.
--
--   §2  विश्वरूप-तन्तुः — the universal fibration is `fst` on the type of
--       POINTED types, and ITS FIBRE OVER X IS X.  The universe carries
--       one fibration whose fibre over each point is that point.
--       `the-universal-total-space-is-the-pointed-types` checks, by
--       `refl`, that Σ[ X ∈ Type ℓ ] X is the pointed types on the nose.
--
--   §3  every-family-is-a-pullback-of-the-universal-one — for any
--       B : A → Type ℓ, the pullback of the universal fibration along B
--       is Σ A B.  "Pulling 𝒰 back gives you any shape you name",
--       as a term.
--
--   §4  अनुवृत्तिः / -रिक्ते / -योगे / -समानता — transport in a family is a
--       CONNECTION: identity over refl, composition over ∙, and an
--       equivalence over every path.  A classifying map is therefore a
--       functor from the fundamental groupoid of the base into 𝒰, and
--       its holonomy around a loop is `subst B` around that loop.  This
--       is the exact sense in which "Σ + transport = parallel transport
--       = holonomy" is not a metaphor.
--
--   §5  holonomy-of-the-universal-family — the holonomy of the universal
--       fibration at X is EXACTLY the automorphisms of X: (X ≡ Y) ≃
--       (X ≃ Y).  That is univalence, read as a statement about one
--       fibration.  And `the-universal-familys-transport-is-the-
--       equivalence` (uaβ) is the computation rule that makes it bite:
--       transport in the universal family along `ua e` IS `e`.
--       `HolonomyIsInvisibleExactlyToAnInvariantSemantics` (README §II)
--       is a statement about this one fibration's holonomy.
--
--   §6  अवरोहणम्-तन्तौ-स्थिरम् — a family that DESCENDS along f is constant
--       on the fibres of f.  This is the general lemma under Pāṇini's
--       8.2.1 as the corpus reads it (README §I): to refute descent it
--       suffices to exhibit one fibre with two points the family
--       separates, which is exactly what `तन्तुभेदः` does.  Only the
--       forward direction is proved; see WHAT IS NOT CLAIMED.
--
--   §7  the-universal-fibration-is-classified-one-level-up — the
--       classifying map of the universal fibration over Type ℓ is a map
--       Type ℓ → Type (ℓ-suc ℓ).  THE CLASSIFIER DOES NOT CLASSIFY
--       ITSELF.  There is no one object classifying every fibration
--       there is; there is one per level, and the tower is forced, not
--       a bookkeeping artefact.  Read in the corpus's own idiom this is
--       the fibre law applied to the classifier: the universe is blind
--       to its own total space, and the blindness is recovered only by
--       changing place — one level up.
--
--   §8  वेष्टनम्-अनुवृत्तिः-एव, एकावृत्तिः — ONE TURN of the fibre law is not
--       vacuous.  `helix : S¹ → Type₀` is one family over one circle;
--       `winding` is, by `refl`, parallel transport in it; and
--       `ΩS¹Isoℤ` says that transport is an isomorphism onto ℤ.  A group
--       that was not put in comes out of one application of §4.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.  This section is load-bearing.
--
-- * NOT that the five collapses of `Ekavakyata` are instances of one
--   formal statement.  The classifier is the ambient fact they are all
--   stated inside; it is not a functor between them, and none is
--   constructed here.  That disclaimer stands exactly as written.
--
-- * NOT that ONE object classifies every fibration.  §7 is the
--   refutation of that reading, and it is proved here rather than
--   conceded: the universal fibration over Type ℓ has total space in
--   Type (ℓ-suc ℓ).  A universe classifying its own fibrations would be
--   Type : Type, which is inconsistent (Girard; Hurkens).  The level
--   discipline that makes §7 unstatable at Type ℓ is Agda's, enforced
--   on this file at typecheck time, and is not itself a theorem IN this
--   file — it is a constraint ON it.
--
-- * NOT anything about physical spacetime, gauge fields, the Standard
--   Model, or SU(3)×SU(2)×U(1).  §4 and §5 are about transport in a
--   type family.  That the connection of a principal bundle is an
--   instance is standard differential geometry and is not formalised
--   here; no smooth structure, no Lie group, and no bundle over a
--   manifold appears in this file.  README §II's disclaimer stands.
--
-- * NOT that iterating the fibre law generates every homotopy type.
--   §8 is ONE application producing ℤ.  That every type arises from
--   iterated suspensions, Postnikov stages or cell attachments is not
--   proved here, is not a corollary of the object classifier, and in
--   the generality of "every homotopy type" is not available in HoTT at
--   all — whether every type is a CW complex is not a theorem of the
--   theory.  Cubical canonicity makes each SINGLE such construction
--   compute; it does not make the tower of homotopy groups of spheres
--   computable in any usable sense, and most of them are unknown.
--
-- * §6 proves DESCENT → CONSTANT ON FIBRES only.  The converse needs
--   surjectivity of f and a truncation, is a different theorem, and is
--   not attempted here.  The forward direction is the one the grammar
--   lane uses, because it is refutation that lane performs.
--
-- WHAT IS CLAIMED: the named terms exist, are checked at the pin, and
-- say what is written above them.
--
-- No postulates, no holes, --safe.
--
-- CHECK STATUS AT THIS COMMIT: **NOT YET CHECKED AT THE PIN.**  The
-- container this was written in had no toolchain; `sh setup` was still
-- building Agda 2.8.0 when this file was committed.  Until `sh check
-- --all` names this module `ok` at Agda 2.8.0 / agda/cubical v0.9,
-- every term below is a CLAIM and not a verdict, and this line is the
-- only honest thing the file can say about itself.  It is here rather
-- than omitted because a file asserting a green it has not been given
-- is the one defect this repository's whole apparatus exists to stop.
------------------------------------------------------------------------

module Visvarupa_TheFibreLawIsTheObjectClassifierAndTheClassifierDoesNotClassifyItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; equivFun ; equivToIso)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ ; univalence ; pathToEquiv)
open import Cubical.Foundations.Transport using (substComposite)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.Pointed.Base using (Pointed)
open import Cubical.Functions.Fibration using (fiberEquiv ; totalEquiv ; fibrationEquiv)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; Σ-syntax ; ΣPathP)
open import Cubical.Data.Nat using (zero)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.HITs.S1.Base using (S¹ ; helix ; ΩS¹ ; winding ; ΩS¹Isoℤ)

open import SarvavibhagaH_EveryMapIsTheSumOfItsFibresOverItsCodomainSoTheIsomorphismTheoremIsAnekanta
  using (सर्वविभागः)

------------------------------------------------------------------------
-- §0  The corpus's fibre law and the library's classifier are one term.
--
-- `SarvavibhagaH` proves A ≃ Σ[ b ∈ B ] fiber f b and reads it as the
-- first isomorphism theorem, rank–nullity, dravya/paryāya and nayavāda.
-- `Cubical.Functions.Fibration.totalEquiv` is HoTT Lemma 4.8.2.  They
-- are not analogous and not isomorphic.  They are the same term.
------------------------------------------------------------------------

सर्वविभागः-एव-totalEquiv :
  {ℓ ℓ' : Level} {A : Type ℓ} {B : Type ℓ'} (f : A → B)
  → सर्वविभागः f ≡ totalEquiv f
सर्वविभागः-एव-totalEquiv f = refl

------------------------------------------------------------------------
-- §1  विश्वरूपम् — the object classifier.  A fibration over A, and a map
--     from A into the universe, are the same thing.  (HoTT Thm 4.8.3.)
------------------------------------------------------------------------

विश्वरूपम् : {ℓ : Level} (A : Type ℓ) → (Σ[ E ∈ Type ℓ ] (E → A)) ≃ (A → Type ℓ)
विश्वरूपम् {ℓ = ℓ} A = fibrationEquiv A ℓ

------------------------------------------------------------------------
-- §2  The universal fibration, and the fibre over X is X.
--
-- Its total space is Σ[ X ∈ Type ℓ ] X — a type together with a point of
-- it — which is on the nose the type of POINTED types, and the fibration
-- is "forget the point".
------------------------------------------------------------------------

Universal : (ℓ : Level) → Type (ℓ-suc ℓ)
Universal ℓ = Σ[ X ∈ Type ℓ ] X

universal : {ℓ : Level} → Universal ℓ → Type ℓ
universal = fst

the-universal-total-space-is-the-pointed-types :
  {ℓ : Level} → Universal ℓ ≡ Pointed ℓ
the-universal-total-space-is-the-pointed-types = refl

विश्वरूप-तन्तुः : {ℓ : Level} (X : Type ℓ) → fiber (universal {ℓ}) X ≃ X
विश्वरूप-तन्तुः {ℓ = ℓ} X = fiberEquiv (idfun (Type ℓ)) X

------------------------------------------------------------------------
-- §3  Every family is a pullback of that one fibration.
------------------------------------------------------------------------

Pullback : {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ') → Type (ℓ-max ℓ (ℓ-suc ℓ'))
Pullback {ℓ' = ℓ'} {A = A} B = Σ[ a ∈ A ] fiber (universal {ℓ'}) (B a)

-- Plumbing only.  `Cubical.Data.Sigma`'s Σ-cong-equiv-snd holds the two
-- fibre families at ONE level, and here they sit at ℓ' and ℓ-suc ℓ' —
-- the pullback's fibre is a fibre of the universal fibration, which is
-- exactly one level up.  Same proof, levels separated.
private
  module _ {ℓ ℓ₁ ℓ₂ : Level} {A : Type ℓ} {B : A → Type ℓ₁} {C : A → Type ℓ₂}
    (e : (a : A) → B a ≃ C a) where
    private
      it : (a : A) → Iso (B a) (C a)
      it a = equivToIso (e a)

    Σ-cong-snd-across-levels : Iso (Σ[ a ∈ A ] B a) (Σ[ a ∈ A ] C a)
    Iso.fun      Σ-cong-snd-across-levels (a , b) = a , Iso.fun (it a) b
    Iso.inv      Σ-cong-snd-across-levels (a , c) = a , Iso.inv (it a) c
    Iso.rightInv Σ-cong-snd-across-levels (a , c) = ΣPathP (refl , Iso.rightInv (it a) c)
    Iso.leftInv  Σ-cong-snd-across-levels (a , b) = ΣPathP (refl , Iso.leftInv (it a) b)

every-family-is-a-pullback-of-the-universal-one :
  {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ')
  → Pullback B ≃ (Σ[ a ∈ A ] B a)
every-family-is-a-pullback-of-the-universal-one B =
  isoToEquiv (Σ-cong-snd-across-levels (λ a → विश्वरूप-तन्तुः (B a)))

------------------------------------------------------------------------
-- §4  अनुवृत्तिः — "carrying over".  Transport in a family is a connection:
--     it is the identity over refl, it composes over ∙, and it is an
--     equivalence over every path.  So a classifying map is a functor
--     from the fundamental groupoid of the base into the universe, and
--     the holonomy of a loop is transport around it.
------------------------------------------------------------------------

अनुवृत्तिः : {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ') {a a' : A}
  → a ≡ a' → B a → B a'
अनुवृत्तिः B p = subst B p

अनुवृत्तिः-रिक्ते : {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ') {a : A} (b : B a)
  → अनुवृत्तिः B refl b ≡ b
अनुवृत्तिः-रिक्ते B b = substRefl {B = B} b

अनुवृत्तिः-योगे : {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ') {a a' a'' : A}
  (p : a ≡ a') (q : a' ≡ a'') (b : B a)
  → अनुवृत्तिः B (p ∙ q) b ≡ अनुवृत्तिः B q (अनुवृत्तिः B p b)
अनुवृत्तिः-योगे B p q b = substComposite B p q b

अनुवृत्तिः-समानता : {ℓ ℓ' : Level} {A : Type ℓ} (B : A → Type ℓ') {a a' : A}
  → a ≡ a' → B a ≃ B a'
अनुवृत्तिः-समानता B p = pathToEquiv (cong B p)

------------------------------------------------------------------------
-- §5  The holonomy of the universal fibration is exactly Aut.
--
-- Univalence, read as a statement about ONE fibration: the loops of the
-- base at X are the self-equivalences of the fibre over X.  `uaβ` is the
-- computation rule that keeps this from being an assumed bijection —
-- transport in the universal family along `ua e` is `e` itself.
------------------------------------------------------------------------

holonomy-of-the-universal-family :
  {ℓ : Level} {X Y : Type ℓ} → (X ≡ Y) ≃ (X ≃ Y)
holonomy-of-the-universal-family = univalence

the-universal-familys-transport-is-the-equivalence :
  {ℓ : Level} {X Y : Type ℓ} (e : X ≃ Y) (x : X)
  → अनुवृत्तिः (idfun (Type ℓ)) (ua e) x ≡ equivFun e x
the-universal-familys-transport-is-the-equivalence e x = uaβ e x

------------------------------------------------------------------------
-- §6  अवरोहणम् — descent, and the fibre as the obstruction to it.
--
-- A family on A descends along f : A → B when it is the pullback of a
-- family on B.  A descended family is CONSTANT ON THE FIBRES of f, so
-- one fibre carrying two points the family separates refutes descent.
-- That refutation is what Pāṇini's 8.2.1 performs on 8.4.56's two-point
-- fibre in the grammar lane; this is the lemma under it.
------------------------------------------------------------------------

अवरोहणम् : {ℓ ℓ' ℓ'' : Level} {A : Type ℓ} {B : Type ℓ'}
  (f : A → B) (P : A → Type ℓ'') → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-suc ℓ''))
अवरोहणम् {ℓ'' = ℓ''} {A = A} {B = B} f P =
  Σ[ Q ∈ (B → Type ℓ'') ] ((a : A) → Q (f a) ≡ P a)

अवरोहणम्-तन्तौ-स्थिरम् : {ℓ ℓ' ℓ'' : Level} {A : Type ℓ} {B : Type ℓ'}
  (f : A → B) (P : A → Type ℓ'')
  → अवरोहणम् f P → {a a' : A} → f a ≡ f a' → P a ≡ P a'
अवरोहणम्-तन्तौ-स्थिरम् f P (Q , α) {a} {a'} p = sym (α a) ∙ cong Q p ∙ α a'

------------------------------------------------------------------------
-- §7  The classifier does not classify itself.
--
-- The classifying map of the universal fibration over Type ℓ is, by §2,
-- pointwise the identity — and it lands in Type (ℓ-suc ℓ).  There is no
-- single object classifying every fibration there is: there is one per
-- level, and the tower is forced.  A universe classifying its own
-- fibrations would be Type : Type, which is inconsistent.
--
-- Agda's level discipline is what makes the alternative unstatable here,
-- so this section is a WITNESS of the level shift, not a proof of its
-- necessity — the type of the term is the content.
------------------------------------------------------------------------

the-universal-fibration : (ℓ : Level) → Σ[ E ∈ Type (ℓ-suc ℓ) ] (E → Type ℓ)
the-universal-fibration ℓ = Universal ℓ , universal

the-universal-fibration-is-classified-one-level-up :
  (ℓ : Level) → Type ℓ → Type (ℓ-suc ℓ)
the-universal-fibration-is-classified-one-level-up ℓ = fiber (universal {ℓ})

------------------------------------------------------------------------
-- §8  One turn of the fibre law is not vacuous.
--
-- `helix : S¹ → Type₀` is a single family over a single circle.  The
-- winding number is, definitionally, §4's transport in it — and that
-- transport is an isomorphism onto ℤ.  A group nobody put in comes out
-- of one application of the law.  ONE application; see WHAT IS NOT
-- CLAIMED for what does not follow.
------------------------------------------------------------------------

वेष्टनम्-अनुवृत्तिः-एव : (p : ΩS¹) → winding p ≡ अनुवृत्तिः helix p (pos zero)
वेष्टनम्-अनुवृत्तिः-एव p = refl

एकावृत्तिः : Iso ΩS¹ ℤ
एकावृत्तिः = ΩS¹Isoℤ
