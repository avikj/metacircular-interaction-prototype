{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- рррроррорр╛ рЙрр░р┐ тФ р╡ррпррррХрр░ро-рррррр╡р ррорр╛-рррррр╡рорр╡, ррр░рХрррХ-рроррррр
-- рЙрр░р┐-рррроррорр╛-рроррр р
--
-- (the stored two-sided conserving inverse of a flow is EXACTLY the
--  invertibility of its map component тФ no extra datum тФ and therefore
--  the observable's symmetry group is Aut_B(A), the automorphisms of A
--  that commute with f.)
--
-- тФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФ
-- WHAT THIS IS.  A SIMPLIFICATION of an existing theorem, not a
-- correction of one.  Everything it leans on is checked and stands:
--
--   ┬ `SamraksakaSet_тж.agda` ┬зрзтУ┬зр builds the symmetry group over the
--     carrier `╬[ ╧ тИИ ррр░р╡р╛рр f ] р╡ррпррррХрр░ро-ррр ╧` тФ a flow bundled with
--     STORED two-sided conserving-inverse evidence тФ and proves that
--     evidence is a proposition (р╡ррпррррХрр░ро-ррХррр╡рор), so the carrier is a
--     subtype.  That is all correct.
--   ┬ `SamanaKaksya_тж.agda` ┬зр proves, separately, that when the map is
--     an equivalence its inverse conserves automatically
--     (р╡ррпррррХрр░ро-ррр░рХррррор тФ one `sym`, one `cong`).
--
-- The two were never joined.  Joining them (┬зрз) collapses the stored
-- datum: р╡ррпррррХрр░ро-ррр ╧ тЙ isEquiv (╧ .fst).  Left to right is the
-- isoтТequiv the group's own `ррр░рр┐` already performs; right to left is
-- SamanaKaksya's backward conservation, which supplies the one thing the
-- bare `isEquiv` does not carry тФ that the INVERSE map is itself a flow.
-- Both sides are propositions, so it is an equivalence and not merely a
-- biimplication.
--
-- Consequently the group's carrier is `╬[ ╧ тИИ ррр░р╡р╛рр f ] isEquiv (╧ .fst)`
-- тФ the conserving flows that HAPPEN to be invertible, with no attached
-- data тФ and, reassociated (┬зри), it is
--
--     рррроррорр╛-рЙрр░р┐  =  ╬[ ╬╡ тИИ (A тЙ A) ] ррр░рХррррор f (equivFun ╬╡),
--
-- Aut_B(A): the automorphisms of A lying OVER B, i.e. commuting with f.
-- ┬зрй makes that a `Group` in its own right and exhibits a `GroupEquiv`
-- from `ррр░рХрррХ-рроррр` onto it whose hom law is `рЙрр░р┐-ррорр╛ refl`.  So the
-- Dhruva/Khahara scale reads, intrinsically:
--
--     near pole (isEquiv f)   Aut_B(A) is trivial                (┬зрa)
--     far pole  (рр░рр╡-рир╛рр f)  Aut_B(A) тЙ Aut(A), the witness free (┬зрc)
--     in between              Aut_B(A) exactly, nothing else.
--
-- ┬зрb prices `Apratiloma`'s witness intrinsically: ррр░рр is outside the
-- unit subgroup for exactly one reason тФ it is not an equivalence
-- (ррр░рр 0 тЙб ррр░рр 1 while 0 тЙ 1) тФ and by ┬зрз that reason is the ONLY one
-- available.  `Apratiloma`'s fence does not move: `ррр░р╡р╛рр f` is still a
-- monoid and not a group, `crush` is still in it and still has no
-- inverse.  What ┬зрз adds is that non-invertibility of the underlying map
-- is not merely sufficient for falling outside the group, it is
-- necessary and sufficient, so "which flows are the units" has an answer
-- with no reference to the monoid at all.
--
-- тФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФ
-- TERMS.  рррро-ррорр╛ тФ "self-sameness"; the compound рррро-ррорр╛-рроррр is
-- already this corpus's own name for Aut(A) (`SamraksakaSet` ┬зрb),
-- and it is MODERN mathematical : no classical text is claimed
-- for it, there and not here either.  рЙрр░р┐ тФ "above, over", ordinary
-- , used here for the slice: "over B".  ррр░рХрррХ, ррр░р╡р╛р, рЧр, ррорр,
-- р╡ррпррррХрр░ро as in `SamraksakaGana`/`SamraksakaSet`, with their limits
-- unchanged (рЧр attested as the gaapha's device, Pini,
-- ррррЯр╛рзррпр╛рпр, ~500 BCE; the application to flows is this corpus's).
-- The compound рррроррорр╛-рЙрр░р┐ is BUILT HERE, 2026-08-23; no source states
-- anything below.
--
-- тФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФтФ
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 тФ the CONTAINER, not the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.  One caveat stated in full because it is load-bearing:
-- the import chain passes through `SvaFiberVasa`, which imports
-- `YogaKsetra`, whose ring-solver calls are written `solve! R'` тФ a name
-- cubical v0.9 has and v0.5 does not (v0.5 calls the macro `solve`).
-- That is container skew and not a verdict on any file.  This module was
-- checked with `YogaKsetra`'s import and the `рпрЛрЧр` section of
-- `SvaFiberVasa` (neither of which anything below touches) locally
-- commented out; that local edit is NOT committed and no file other than
-- this one is changed by this landing.
------------------------------------------------------------------------

module AtmaequalityUpari_TheStoredInverseIsExactlyInvertibilityAndTheSymmetryGroupIsAutOverB where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels
  using (isSet╬г ; isProp╬а ; isOfHLevelтЙГ)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (тДХ ; zero ; suc)
open import Cubical.Data.Nat.Properties using (isSetтДХ ; znots)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Relation.Nullary using (┬м_)
open import Cubical.Algebra.Group
open import Cubical.Algebra.Group.Morphisms using (GroupEquiv)
open import Cubical.Algebra.Group.MorphismProperties using (makeIsGroupHom)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (рд╕рдВрд░рдХреНрд╖рдгрдореН)
open import Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry
  using (рд╕рд░реНрд╡-рдирд╛рд╢рдГ)
open import SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient
  using (рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдВрд░рдХреНрд╖рдгрдореН)
open import SvaFiberVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres
  using (рдзреНрд░реБрд╡-рдмрд┐рдиреНрджреБрдГ)
open import SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl
  using (рдкреНрд░рд╡рд╛рд╣рдГ ; _тИШрдкреНрд░_ ; рдПрдХрдГ ; module рдЧрдгреЗ)
open import SamraksakaSet_TheInvertibleConservingFlowsAreTheSymmetryGroupAndTotalLossMakesItAllOfAut
  using (module рд╕рдореВрд╣реЗ)
open import Apratiloma_TheConservingFlowsAreAMonoidNotAGroupSoNoethersFirstTheoremDoesNotTransfer
  using (рдЕрдиреНрдз ; рдЪреВрд░реНрдг)

private variable тДУ : Level

module рдЙрдкрд░рд┐ {A B : Type тДУ} (setA : isSet A) (setB : isSet B) (f : A тЖТ B) where

  open рдЧрдгреЗ setA setB f using (рдкреНрд░рд╡рд╛рд╣-рд╕рдорддрд╛)
  open рд╕рдореВрд╣реЗ setA setB f
    using (рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рддреН ; рд╡реНрдпреБрддреНрдХреНрд░рдо-рдПрдХрддреНрд╡рдореН ; рд╕рдореВрд╣-рд╡рд╛рд╣рдГ ; рд╕рдореВрд╣-рд╕рдорддрд╛ ; рд╕рдВрд░рдХреНрд╖рдХ-рд╕рдореВрд╣рдГ)

  ------------------------------------------------------------------
  -- ┬зрз ┬ THE STORED INVERSE IS EXACTLY INVERTIBILITY.
  --
  -- Forward: the two flow-inverse laws, read on the map component, are
  -- the two homotopies of an isomorphism.  Backward: the map's inverse
  -- is a flow because conservation propagates backwards (SamanaKaksya
  -- ┬зр), and the two laws are then secEq / retEq under ррр░р╡р╛р-ррорр╛.
  ------------------------------------------------------------------

  рд╕рддреН-рддрдГ-рд╕рдорддрд╛ : (╧Г : рдкреНрд░рд╡рд╛рд╣рдГ f) тЖТ рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рддреН ╧Г тЖТ isEquiv (╧Г .fst)
  рд╕рддреН-рддрдГ-рд╕рдорддрд╛ ╧Г (╧Д , p , q) =
    isoToIsEquiv (iso (╧Г .fst) (╧Д .fst)
                      (funExtтБ╗ (cong fst p)) (funExtтБ╗ (cong fst q)))

  рд╕рдорддрд╛-рддрдГ-рд╕рддреН : (╧Г : рдкреНрд░рд╡рд╛рд╣рдГ f) тЖТ isEquiv (╧Г .fst) тЖТ рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рддреН ╧Г
  рд╕рдорддрд╛-рддрдГ-рд╕рддреН ╧Г e =
      (invEq ╬╡ , рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдВрд░рдХреНрд╖рдгрдореН f (╧Г .fst) e (╧Г .snd))
    , рдкреНрд░рд╡рд╛рд╣-рд╕рдорддрд╛ _ _ (funExt (secEq ╬╡))
    , рдкреНрд░рд╡рд╛рд╣-рд╕рдорддрд╛ _ _ (funExt (retEq ╬╡))
    where
    ╬╡ : A тЙГ A
    ╬╡ = ╧Г .fst , e

  -- both sides are propositions, so this is an equivalence of types and
  -- not merely a two-way implication: NO DATUM IS LOST either way.
  рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдорддрд╛ : (╧Г : рдкреНрд░рд╡рд╛рд╣рдГ f) тЖТ рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рддреН ╧Г тЙГ isEquiv (╧Г .fst)
  рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдорддрд╛ ╧Г =
    isoToEquiv (iso (рд╕рддреН-рддрдГ-рд╕рдорддрд╛ ╧Г) (рд╕рдорддрд╛-рддрдГ-рд╕рддреН ╧Г)
                    (╬╗ e тЖТ isPropIsEquiv (╧Г .fst) _ e)
                    (╬╗ v тЖТ рд╡реНрдпреБрддреНрдХреНрд░рдо-рдПрдХрддреНрд╡рдореН ╧Г _ v))

  ------------------------------------------------------------------
  -- ┬зри ┬ THE CARRIER, WITH THE STORED DATUM REMOVED, AND THEN
  -- REASSOCIATED INTO Aut_B(A).
  ------------------------------------------------------------------

  рд╡рд╛рд╣-рд╕рдорддрд╛ : рд╕рдореВрд╣-рд╡рд╛рд╣рдГ тЙГ (╬г[ ╧Г тИИ рдкреНрд░рд╡рд╛рд╣рдГ f ] isEquiv (╧Г .fst))
  рд╡рд╛рд╣-рд╕рдорддрд╛ = ╬г-cong-equiv-snd рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдорддрд╛

  -- Aut_B(A): an automorphism of A that f cannot tell acted.
  рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ : Type тДУ
  рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ = ╬г[ ╬╡ тИИ (A тЙГ A) ] рд╕рдВрд░рдХреНрд╖рдгрдореН f (equivFun ╬╡)

  -- equality of such is determined by the underlying FUNCTION alone:
  -- one ╬тЙбProp for the conservation witness (setB), one equivEq for the
  -- isEquiv field.
  рдЙрдкрд░рд┐-рд╕рдорддрд╛ : {u v : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐} тЖТ equivFun (u .fst) тЙб equivFun (v .fst) тЖТ u тЙб v
  рдЙрдкрд░рд┐-рд╕рдорддрд╛ p = ╬гтЙбProp (╬╗ _ тЖТ isProp╬а (╬╗ a тЖТ setB _ _)) (equivEq p)

  рдЙрдкрд░рд┐-рд╕реЗрдЯреН : isSet рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐
  рдЙрдкрд░рд┐-рд╕реЗрдЯреН = isSet╬г (isOfHLevelтЙГ 2 setA setA)
                     (╬╗ _ тЖТ isPropтЖТisSet (isProp╬а (╬╗ a тЖТ setB _ _)))

  ------------------------------------------------------------------
  -- ┬зрй ┬ Aut_B(A) IS THE SYMMETRY GROUP, BY A GroupEquiv WHOSE HOM LAW
  -- IS `рЙрр░р┐-ррорр╛ refl`.
  --
  -- Composition is in application order (u ┬рЙ v applies v first), to
  -- match `_┬р_`'s order, so that the comparison never has to commute
  -- anything.
  ------------------------------------------------------------------

  рдПрдХрдореН-рдЙ : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐
  рдПрдХрдореН-рдЙ = idEquiv A , (╬╗ _ тЖТ refl)

  _┬╖рдЙ_ : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ тЖТ рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ тЖТ рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐
  (╬╡ , c) ┬╖рдЙ (╬┤ , d) = compEquiv ╬┤ ╬╡ , (╬╗ a тЖТ c (equivFun ╬┤ a) тИЩ d a)

  рд╡реНрдпреБрддреН-рдЙ : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ тЖТ рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐
  рд╡реНрдпреБрддреН-рдЙ (╬╡ , c) = invEquiv ╬╡ , рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рдВрд░рдХреНрд╖рдгрдореН f (equivFun ╬╡) (╬╡ .snd) c

  рдЙрдкрд░рд┐-рд╕рдореВрд╣рдГ : Group тДУ
  рдЙрдкрд░рд┐-рд╕рдореВрд╣рдГ = makeGroup рдПрдХрдореН-рдЙ _┬╖рдЙ_ рд╡реНрдпреБрддреН-рдЙ рдЙрдкрд░рд┐-рд╕реЗрдЯреН
    (╬╗ x y z тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl)
    (╬╗ x тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl)
    (╬╗ x тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl)
    (╬╗ x тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ (funExt (secEq (x .fst))))
    (╬╗ x тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ (funExt (retEq (x .fst))))

  рдЙрддреНрддрд╛рд░рдГ : рд╕рдореВрд╣-рд╡рд╛рд╣рдГ тЖТ рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐
  рдЙрддреНрддрд╛рд░рдГ u = (u .fst .fst , рд╕рддреН-рддрдГ-рд╕рдорддрд╛ (u .fst) (u .snd)) , u .fst .snd

  рдЕрд╡рддрд╛рд░рдГ : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ тЖТ рд╕рдореВрд╣-рд╡рд╛рд╣рдГ
  рдЕрд╡рддрд╛рд░рдГ (╬╡ , c) = (equivFun ╬╡ , c) , рд╕рдорддрд╛-рддрдГ-рд╕рддреН (equivFun ╬╡ , c) (╬╡ .snd)

  рдЙрддреН-рдЕрд╡ : (u : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐) тЖТ рдЙрддреНрддрд╛рд░рдГ (рдЕрд╡рддрд╛рд░рдГ u) тЙб u
  рдЙрддреН-рдЕрд╡ u = рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl

  рдЕрд╡-рдЙрддреН : (u : рд╕рдореВрд╣-рд╡рд╛рд╣рдГ) тЖТ рдЕрд╡рддрд╛рд░рдГ (рдЙрддреНрддрд╛рд░рдГ u) тЙб u
  рдЕрд╡-рдЙрддреН u = рд╕рдореВрд╣-рд╕рдорддрд╛ (рдкреНрд░рд╡рд╛рд╣-рд╕рдорддрд╛ _ _ refl)

  -- THE IDENTIFICATION.  The observable's symmetry group IS the group of
  -- automorphisms of its domain over its codomain.
  рдЙрдкрд░рд┐-рд╕рдореВрд╣-рд╕рдорддрд╛ : GroupEquiv рд╕рдВрд░рдХреНрд╖рдХ-рд╕рдореВрд╣рдГ рдЙрдкрд░рд┐-рд╕рдореВрд╣рдГ
  рдЙрдкрд░рд┐-рд╕рдореВрд╣-рд╕рдорддрд╛ =
      isoToEquiv (iso рдЙрддреНрддрд╛рд░рдГ рдЕрд╡рддрд╛рд░рдГ рдЙрддреН-рдЕрд╡ рдЕрд╡-рдЙрддреН)
    , makeIsGroupHom (╬╗ u v тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl)

  ------------------------------------------------------------------
  -- ┬зрa ┬ NEAR POLE, intrinsically.  Zero loss тЯ Aut_B(A) is trivial.
  -- The flow space is already contractible (рзрр░рр╡-рр┐рирржрр), so no
  -- inverse-side argument is needed at all.
  ------------------------------------------------------------------

  рддреБрдЪреНрдЫрдореН-рдЙрдкрд░рд┐ : isEquiv f тЖТ (u : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐) тЖТ u тЙб рдПрдХрдореН-рдЙ
  рддреБрдЪреНрдЫрдореН-рдЙрдкрд░рд┐ e u =
    рдЙрдкрд░рд┐-рд╕рдорддрд╛ (cong fst (isContrтЖТisProp (рдзреНрд░реБрд╡-рдмрд┐рдиреНрджреБрдГ f e)
                                          (equivFun (u .fst) , u .snd) (рдПрдХрдГ f)))

------------------------------------------------------------------------
-- ┬зрb ┬ THE UNIT SUBGROUP, PRICED AT `Apratiloma`'s OWN WITNESS.
--
-- ррр░рр conserves рриррз and is not a unit.  ┬зрз says the reason can only be
-- one thing, and here it is that thing: ррр░рр is not an equivalence,
-- because a retraction of it would identify 0 with 1.
------------------------------------------------------------------------

рдЪреВрд░реНрдг-рди-рд╕рдорддрд╛ : ┬м (isEquiv рдЪреВрд░реНрдг)
рдЪреВрд░реНрдг-рди-рд╕рдорддрд╛ e = znots (sym (retEq ╬╡ zero) тИЩ retEq ╬╡ (suc zero))
  where
  ╬╡ : тДХ тЙГ тДХ
  ╬╡ = рдЪреВрд░реНрдг , e

рдЪреВрд░реНрдг-рдкреНрд░рд╡рд╛рд╣рдГ : рдкреНрд░рд╡рд╛рд╣рдГ рдЕрдиреНрдз
рдЪреВрд░реНрдг-рдкреНрд░рд╡рд╛рд╣рдГ = рдЪреВрд░реНрдг , (╬╗ _ тЖТ refl)

-- and therefore no stored inverse exists тФ by ┬зрз, not by inspection of
-- the monoid.  `Apratiloma`'s fence is unmoved and now has a reason.
рдЪреВрд░реНрдг-рди-рд╡реНрдпреБрддреНрдХреНрд░рдордГ : ┬м (рд╕рдореВрд╣реЗ.рд╡реНрдпреБрддреНрдХреНрд░рдо-рд╕рддреН isSetтДХ isSetUnit рдЕрдиреНрдз рдЪреВрд░реНрдг-рдкреНрд░рд╡рд╛рд╣рдГ)
рдЪреВрд░реНрдг-рди-рд╡реНрдпреБрддреНрдХреНрд░рдордГ v = рдЪреВрд░реНрдг-рди-рд╕рдорддрд╛ (рдЙрдкрд░рд┐.рд╕рддреН-рддрдГ-рд╕рдорддрд╛ isSetтДХ isSetUnit рдЕрдиреНрдз рдЪреВрд░реНрдг-рдкреНрд░рд╡рд╛рд╣рдГ v)

------------------------------------------------------------------------
-- ┬зрc ┬ FAR POLE, intrinsically.  At total loss the conservation
-- witness is free, so Aut_B(A) тЙ Aut(A) by the bare projection тФ
-- which is `SamraksakaSet` ┬зрb's GroupEquiv seen without the stored
-- inverse in the way.
------------------------------------------------------------------------

module рдЕрдиреНрдзреЗ-рдЙрдкрд░рд┐ {A B : Type тДУ} (setA : isSet A) (setB : isSet B)
                  (f : A тЖТ B) (blind : рд╕рд░реНрд╡-рдирд╛рд╢рдГ f) where

  open рдЙрдкрд░рд┐ setA setB f using (рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ ; рдЙрдкрд░рд┐-рд╕рдорддрд╛)

  рд╕рд░реНрд╡-рдЙрдкрд░рд┐ : рдЖрддреНрдорд╕рдорддрд╛-рдЙрдкрд░рд┐ тЙГ (A тЙГ A)
  рд╕рд░реНрд╡-рдЙрдкрд░рд┐ = isoToEquiv
    (iso fst (╬╗ ╬╡ тЖТ ╬╡ , (╬╗ a тЖТ blind (equivFun ╬╡ a) a))
         (╬╗ _ тЖТ refl) (╬╗ u тЖТ рдЙрдкрд░рд┐-рд╕рдорддрд╛ refl))

------------------------------------------------------------------------
-- ┬зр ┬ рррр.
--
-- (a) The section-side units as a packaged `Group`, with р╡р╛рр a
--     `GroupEquiv` onto it тФ `SamraksakaSet` ┬зр's remainder, still
--     open, and now cheaper: by ┬зрз the section-side unit predicate can
--     be stated as invertibility of the section's point component
--     instead of as stored data.
-- (b) The group leg of `FiberVibhaga`'s decomposition: is
--     рррроррорр╛-рЙрр░р┐ тЙ ╬а over the codomain of Aut(fibre f b)?  ┬зри's
--     reassociation is what makes this a question about equivalences of
--     ╬-types rather than about the monoid, but it is NOT proved here.
-- (c) The тИЮ-version.  Over arbitrary types isEquiv is still a
--     proposition, so ┬зрз has a chance of surviving verbatim while
--     р╡ррпррррХрр░ро-ррХррр╡рор does not (its uniqueness argument used
--     ррр░р╡р╛р-ррорр╛, hence setB).  Untried.
-- (d) Whether `рЙрр░р┐-рроррр` and `ррр░рХрррХ-рроррр` being GroupEquiv upgrades
--     to a path of `Group`s by univalence for groups тФ the library has
--     it; nothing below consumes it, so it is not invoked.
------------------------------------------------------------------------
