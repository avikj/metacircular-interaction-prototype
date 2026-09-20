{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PairsSummingTo
--
-- Ingredient (i) of `DurationIsSyllablesPlusGuru` Â§7, built rather than
-- described.
--
--     pairsFin : (n : â•) â’ Pairs n â‰ SumFin (suc n)
--
-- where `Pairs n = Î[ (a,b) âˆˆ â• — â• ] (a + b â‰¡ n)`.  The antidiagonal
-- index set is finite, with `n + 1` elements, by a structural induction
-- and **no truncated subtraction** â” which is what every other encoding in
-- this thread died of.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE INDUCTION
--
--     Pairs 0        â‰  âŠ
--     Pairs (suc n)  â‰  âŠ âŠ Pairs n
--
-- the first summand being the pair `(0 , suc n)` and the rest having `a`
-- a successor, dropping to the previous level.  `Cubical.Data.SumFin`
-- defines `Fin (suc n) = âŠ âŠ Fin n` **definitionally**, so the second
-- line composes into the result with no arithmetic at all.
--
-- Every round-trip obligation beyond the pair itself is an equation in
-- â•, hence a proposition, hence `isSetâ•`.  Same observation that made
-- `DurationIsSyllablesPlusGuru`'s Î-contraction go through.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT REMAINS OF THE DIAGONAL IDENTITY
--
-- `Sankalita` Â§13 refuted three encodings; `DurationIsSyllablesPlusGuru`
-- carried the fourth to an equivalence and then Â§7 named two remaining
-- ingredients.  This is the first.  The second â” that the library's `sum`
-- over this FinSet is the recursive `Sankalita.AD` â” is a reindexing, and
-- reindexing is precisely what the third refuted encoding got wrong, so
-- it is not being called routine here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module PairsSummingTo where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; compEquiv)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; isSetâ„• ; injSuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.SumFin using () renaming (Fin to SumFin)

------------------------------------------------------------------------
-- 1.  The antidiagonal index set
------------------------------------------------------------------------

Pairs : â„• â†’ Type
Pairs n = Î£[ ab âˆˆ (â„• Ã— â„•) ] (fst ab + snd ab â‰¡ n)

------------------------------------------------------------------------
-- 2.  Base: only (0,0) sums to 0
------------------------------------------------------------------------

pairs0-Iso : Iso (Pairs 0) Unit
Iso.fun      pairs0-Iso _ = tt
Iso.inv      pairs0-Iso _ = (0 , 0) , refl
Iso.rightInv pairs0-Iso _ = refl
Iso.leftInv  pairs0-Iso ((zero  , zero)  , p) =
  Î£PathP (refl , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _)
Iso.leftInv  pairs0-Iso ((zero  , suc b) , p) = Empty.rec (snotz p)
  where open import Cubical.Data.Empty as Empty using (âŠ¥)
        open import Cubical.Data.Nat using (snotz)
Iso.leftInv  pairs0-Iso ((suc a , b)     , p) = Empty.rec (snotz p)
  where open import Cubical.Data.Empty as Empty using (âŠ¥)
        open import Cubical.Data.Nat using (snotz)

------------------------------------------------------------------------
-- 3.  Step: peel the a = 0 pair off
------------------------------------------------------------------------

pairsSuc-Iso : (n : â„•) â†’ Iso (Pairs (suc n)) (Unit âŠŽ Pairs n)
Iso.fun (pairsSuc-Iso n) ((zero  , b) , p) = inl tt
Iso.fun (pairsSuc-Iso n) ((suc a , b) , p) = inr ((a , b) , injSuc p)

Iso.inv (pairsSuc-Iso n) (inl _)              = (0 , suc n) , refl
Iso.inv (pairsSuc-Iso n) (inr ((a , b) , q))  = (suc a , b) , cong suc q

Iso.rightInv (pairsSuc-Iso n) (inl tt) = refl
Iso.rightInv (pairsSuc-Iso n) (inr ((a , b) , q)) =
  cong inr (Î£PathP (refl , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _))

Iso.leftInv (pairsSuc-Iso n) ((zero  , b) , p) =
  Î£PathP ( Î£PathP (refl , sym p)
         , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _ )
Iso.leftInv (pairsSuc-Iso n) ((suc a , b) , p) =
  Î£PathP (refl , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _)

------------------------------------------------------------------------
-- 4.  THE STATEMENT.  `SumFin (suc n) = âŠ âŠ SumFin n` definitionally, so
--     the induction composes with no arithmetic.
------------------------------------------------------------------------

âŠŽ-cong : {A B : Type} â†’ A â‰ƒ B â†’ (Unit âŠŽ A) â‰ƒ (Unit âŠŽ B)
âŠŽ-cong e = isoToEquiv is
  where
  open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
  is : Iso _ _
  Iso.fun is (inl t) = inl t
  Iso.fun is (inr a) = inr (equivFun e a)
  Iso.inv is (inl t) = inl t
  Iso.inv is (inr b) = inr (invEq e b)
  Iso.rightInv is (inl t) = refl
  Iso.rightInv is (inr b) = cong inr (secEq e b)
  Iso.leftInv  is (inl t) = refl
  Iso.leftInv  is (inr a) = cong inr (retEq e a)

pairsFin : (n : â„•) â†’ Pairs n â‰ƒ SumFin (suc n)
pairsFin zero    = compEquiv (isoToEquiv pairs0-Iso) unitEquiv
  where
  open import Cubical.Data.Empty as Empty using (âŠ¥)
  unitEquiv : Unit â‰ƒ SumFin 1
  unitEquiv = isoToEquiv is
    where
    is : Iso Unit (SumFin 1)
    Iso.fun      is _        = inl tt
    Iso.inv      is _        = tt
    Iso.rightInv is (inl tt) = refl
    Iso.rightInv is (inr ())
    Iso.leftInv  is _        = refl
pairsFin (suc n) =
  compEquiv (isoToEquiv (pairsSuc-Iso n)) (âŠŽ-cong (pairsFin n))

------------------------------------------------------------------------
-- 5.  So the antidiagonal index set has n+1 elements, structurally.
--
-- That is ingredient (i).  Ingredient (ii) â” that the library's sum over
-- this FinSet is `Sankalita.AD` â” is a reindexing, and this thread's
-- record on reindexings is one for one against.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  State of the diagonal-sum thread, facts only.
--
-- PROVED, all checked in this repository:
--
--   `Sankalita.sankalita-column`      Î_{m<n} meru m r â‰¡ meru n (suc r)
--   `Sankalita.varasankalita`         Î^r 1 at n â‰¡ meru n r
--   `Sankalita.AD2-breaks-the-recurrence`
--                                     the row-2 antidiagonal sums are not
--                                     Fibonacci-recurrent
--   `DurationIsSyllablesPlusGuru.matra-split`
--                                     matrOf p â‰¡ vara p + guruOf p
--   `DurationIsSyllablesPlusGuru.metre-sorts`
--                                     Metre n â‰ Î_{a+b=n} Chosen a b
--   here `pairsFin`                   Pairs n â‰ SumFin (suc n)
--
-- AND NOW ALSO PROVED, in `DiagonalIsMatra`:
--
--   `diagonal-is-matra : (n : â•) â’ matra n â‰¡ antidiag n`
--
-- The cardinality computation this section declined to estimate turned
-- out to need the SHIFTED family `SortedC c n` â” the unshifted one does
-- not close the induction â” plus `Î-contractFst`, `ÎâŠâ‰`, `SumFinâŠâ‰` and
-- `Fin-inj`.  Declining to estimate was right: the shift was the content,
-- and no sentence written before doing it would have named it.
------------------------------------------------------------------------
