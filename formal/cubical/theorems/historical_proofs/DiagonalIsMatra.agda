{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DiagonalIsMatra
--
-- The identity the Sankalita thread left open:
--
--     mtr n  â‰¡  Î_{a+b=n} meru a b
--
-- Virahka's mtrmeru (c. 600â“800) is the shallow diagonal of Pigala's
-- meru-prastra (c. 300â“200 BCE).  Both arrays were already in this
-- repository; the identity between them was not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- HOW IT GOES, AFTER FOUR ENCODINGS
--
-- `Sankalita` Â§Â§8â“13 refuted three numeric encodings, each for a
-- different reason, and left Pigala's own: sort the patterns by
-- syllable count.  `DurationIsSyllablesPlusGuru` carried that to an
-- equivalence, `PairsSummingTo` made the index set finite structurally,
-- and this file takes cardinalities.
--
-- The shifted family is what makes the induction close:
--
--     SortedC c n  =  Î[ ((a,b),_) âˆˆ Pairs n ]  Chosen (c + a) b
--
-- with `SortedC c 0 â‰ Chosen c 0` and
-- `SortedC c (suc n) â‰ Chosen c (suc n) âŠ SortedC (suc c) n`, matching
-- `Sankalita.AD` step for step.  `AD` walks the first index up and the
-- second down; so does the peeling of `Pairs`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS USED, ALL PRIOR ART
--
--   `Pingala.meruCount`         Chosen n k â‰ Fin (meru n k)
--   `Pingala.matraCount`        Metre n â‰ Fin (mtr n)
--   `PairsSummingTo.pairsSuc-Iso`
--   `DurationIsSyllablesPlusGuru.metre-sorts`
--   `Cubical.Data.Sigma`        Î-contractFst, Î-cong-equiv-fst/snd
--   `Cubical.Data.Sum`          ÎâŠâ‰
--   `Cubical.Data.SumFin`       SumFinâŠâ‰, SumFinâ‰Fin
--
-- Nothing new is proved about arrays; the content is the assembly.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module DiagonalIsMatra where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; compEquiv ; invEquiv ; idEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr ; Î£âŠŽâ‰ƒ)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.SumFin using (SumFinâŠŽâ‰ƒ ; SumFinâ‰ƒFin) renaming (Fin to SFin)

open import PingalaPrastara using (Chosen ; meru ; meruCount ; Metre ; matra ; matraCount)
open import Sankalita using (AD ; antidiag)
open import PairsSummingTo using (Pairs ; pairsSuc-Iso ; pairs0-Iso)
open import DurationIsSyllablesPlusGuru using (Sorted ; metre-sorts)

------------------------------------------------------------------------
-- 1.  Chosen, as a SumFin
------------------------------------------------------------------------

chosenFin : (a b : â„•) â†’ Chosen a b â‰ƒ SFin (meru a b)
chosenFin a b =
  compEquiv (isoToEquiv (meruCount a b)) (invEquiv (SumFinâ‰ƒFin (meru a b)))

------------------------------------------------------------------------
-- 2.  The shifted family, and its two structural equivalences
------------------------------------------------------------------------

SortedC : â„• â†’ â„• â†’ Type
SortedC c n = Î£[ p âˆˆ Pairs n ] Chosen (c + fst (fst p)) (snd (fst p))

-- base: Pairs 0 is contractible at ((0,0), refl)
isContrPairs0 : isContr (Pairs 0)
isContrPairs0 = ((0 , 0) , refl) , Î» p â†’ Iso.leftInv pairs0-Iso p

sortedC0 : (c : â„•) â†’ SortedC c 0 â‰ƒ Chosen (c + 0) 0
sortedC0 c = Î£-contractFst isContrPairs0

-- step: peel the a = 0 pair, and the rest shifts the offset up by one
sortedCsuc : (c n : â„•) â†’ SortedC c (suc n) â‰ƒ (Chosen (c + 0) (suc n) âŠŽ SortedC (suc c) n)
sortedCsuc c n =
  compEquiv
    (invEquiv (Î£-cong-equiv-fst (invEquiv (isoToEquiv (pairsSuc-Iso n)))))
    (compEquiv Î£âŠŽâ‰ƒ
      (âŠŽEquiv (Î£-contractFst isContrUnit) shift))
  where
  âŠŽEquiv : {A B C D : Type} â†’ A â‰ƒ B â†’ C â‰ƒ D â†’ (A âŠŽ C) â‰ƒ (B âŠŽ D)
  âŠŽEquiv e f = isoToEquiv is
    where
    open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
    is : Iso _ _
    Iso.fun is (inl a) = inl (equivFun e a)
    Iso.fun is (inr c) = inr (equivFun f c)
    Iso.inv is (inl b) = inl (invEq e b)
    Iso.inv is (inr d) = inr (invEq f d)
    Iso.rightInv is (inl b) = cong inl (secEq e b)
    Iso.rightInv is (inr d) = cong inr (secEq f d)
    Iso.leftInv  is (inl a) = cong inl (retEq e a)
    Iso.leftInv  is (inr c) = cong inr (retEq f c)

  shift : (Î£[ p âˆˆ Pairs n ] Chosen (c + suc (fst (fst p))) (snd (fst p))) â‰ƒ SortedC (suc c) n
  shift = Î£-cong-equiv-snd
            (Î» p â†’ pathToEquiv (cong (Î» z â†’ Chosen z (snd (fst p)))
                                     (+-suc c (fst (fst p)))))

------------------------------------------------------------------------
-- 3.  The shifted family counted
------------------------------------------------------------------------

sortedCFin : (c n : â„•) â†’ SortedC c n â‰ƒ SFin (AD c n)
sortedCFin c zero =
  compEquiv (sortedC0 c)
    (compEquiv (pathToEquiv (cong (Î» z â†’ Chosen z 0) (+-zero c)))
               (chosenFin c 0))
sortedCFin c (suc n) =
  compEquiv (sortedCsuc c n)
    (compEquiv
      (âŠŽE (compEquiv (pathToEquiv (cong (Î» z â†’ Chosen z (suc n)) (+-zero c)))
                     (chosenFin c (suc n)))
          (sortedCFin (suc c) n))
      (SumFinâŠŽâ‰ƒ (meru c (suc n)) (AD (suc c) n)))
  where
  âŠŽE : {A B C D : Type} â†’ A â‰ƒ B â†’ C â‰ƒ D â†’ (A âŠŽ C) â‰ƒ (B âŠŽ D)
  âŠŽE e f = isoToEquiv is
    where
    open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
    is : Iso _ _
    Iso.fun is (inl a) = inl (equivFun e a)
    Iso.fun is (inr c') = inr (equivFun f c')
    Iso.inv is (inl b) = inl (invEq e b)
    Iso.inv is (inr d) = inr (invEq f d)
    Iso.rightInv is (inl b) = cong inl (secEq e b)
    Iso.rightInv is (inr d) = cong inr (secEq f d)
    Iso.leftInv  is (inl a) = cong inl (retEq e a)
    Iso.leftInv  is (inr c') = cong inr (retEq f c')

------------------------------------------------------------------------
-- 4.  The unshifted case is the antidiagonal
------------------------------------------------------------------------

sortedIsSortedC0 : (n : â„•) â†’ Sorted n â‰ƒ SortedC 0 n
sortedIsSortedC0 n = invEquiv Î£-assoc-â‰ƒ

metreFin : (n : â„•) â†’ Metre n â‰ƒ SFin (antidiag n)
metreFin n =
  compEquiv (metre-sorts n)
    (compEquiv (sortedIsSortedC0 n) (sortedCFin 0 n))

------------------------------------------------------------------------
-- 5.  THE IDENTITY, by comparing the two counts of `Metre n`
------------------------------------------------------------------------

metreFin' : (n : â„•) â†’ Metre n â‰ƒ SFin (matra n)
metreFin' n =
  compEquiv (isoToEquiv (matraCount n)) (invEquiv (SumFinâ‰ƒFin (matra n)))

diagonal-is-matra : (n : â„•) â†’ matra n â‰¡ antidiag n
diagonal-is-matra n =
  SumFin-inj (matra n) (antidiag n)
    (compEquiv (invEquiv (metreFin' n)) (metreFin n))
  where
  open import Cubical.Data.Fin using (Fin-inj)
  open import Cubical.Foundations.Univalence using (ua)

  -- SumFin injectivity, from `Cubical.Data.Fin.Fin-inj` through
  -- `SumFinâ‰Fin` -- the same route `Cubical.Data.FinSet.Base` uses to
  -- show `card` is well defined.
  SumFin-inj : (m k : â„•) â†’ SFin m â‰ƒ SFin k â†’ m â‰¡ k
  SumFin-inj m k e =
    Fin-inj m k
      (ua (compEquiv (invEquiv (SumFinâ‰ƒFin m))
                     (compEquiv e (SumFinâ‰ƒFin k))))

------------------------------------------------------------------------
-- 6.  It runs, and the two arrays agree.
--
--   mtr 6 = 13, and the antidiagonal a+b=6 of the meru is
--   C(6,0)+C(5,1)+C(4,2)+C(3,3) = 1+5+6+1 = 13.
------------------------------------------------------------------------

check-6 : matra 6 â‰¡ antidiag 6
check-6 = diagonal-is-matra 6

check-6-value : matra 6 â‰¡ 13
check-6-value = refl

check-9 : matra 9 â‰¡ antidiag 9
check-9 = diagonal-is-matra 9

------------------------------------------------------------------------
-- 7.  The thread, closed.
--
--   `Sankalita` Â§Â§8â“13    three numeric encodings refuted, each with its
--                         counterexample recorded
--   `DurationIsSyllablesPlusGuru`
--                         the typed route: mtrOf p â‰¡ vara p + guruOf p,
--                         and Metre n â‰ Î_{a+b=n} Chosen a b
--   `PairsSummingTo`      the index set is finite, structurally
--   here                  cardinalities, and the identity
--
-- Virahka's mtrmeru is the shallow diagonal of Pigala's
-- meru-prastra â” a theorem now, between two arrays this repository had
-- held separately, from sources about a thousand years apart within one
-- tradition.
--
-- No numeric identity was proved along the way that is not a corollary of
-- the typed one, which is the shape `Pingala.agda` set: count the objects,
-- then read the numbers off.
------------------------------------------------------------------------
