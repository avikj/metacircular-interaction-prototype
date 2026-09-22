{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DurationIsSyllablesPlusGuru
--
-- The surviving route from `Sankalita` Â§13, taken one step.
--
-- Three encodings of the mtrmeru/meru diagonal identity were refuted
-- there, each differently, leaving one: Pigala's own argument, which
-- sorts patterns by syllable count instead of manipulating sums.  Its
-- heart is a one-line induction, and here it is.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE LEMMA
--
--     matra-split :  matrOf p  â‰¡  vara p + guruOf p
--
-- Duration equals syllable count plus guru count, because a laghu weighs
-- one mtr and a guru weighs two.  Trivial, and it is exactly what
-- reparametrises the identity out of subtraction: a pattern of duration
-- `n` with `a` syllables and `b` guru satisfies `a + b â‰¡ n`, with no
-- `n âˆ’ k` anywhere.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IT BUYS
--
--     metre-sorts :  Metre n  â‰  Î[ (a,b) : a + b â‰¡ n ] Chosen a b
--
-- â” "a metre of duration `n` is a choice of how many syllables and how
-- many of them are guru, then a pattern with those statistics" â” is now a
-- statement with no truncated subtraction in it, which is what killed the
-- second encoding.  `metre-to-sorted` and `sorted-to-metre` below are the
-- two maps, and `metre-sorts` is the equivalence.
--
-- Taking cardinalities of that statement, with `Pingala.matraCount` and
-- `Pingala.meruCount`, is the diagonal identity.
------------------------------------------------------------------------

module DurationIsSyllablesPlusGuru where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import PingalaPrastara
  using ( Pattern ; Syllable ; laghu ; guru ; mora
        ; matraOf ; varna ; guruOf ; Metre ; Chosen )

------------------------------------------------------------------------
-- 1.  THE LEMMA.  Duration is syllables plus guru.
------------------------------------------------------------------------

matra-split : (p : Pattern) â†’ matraOf p â‰¡ varna p + guruOf p
matra-split [] = refl
matra-split (laghu âˆ· p) = cong suc (matra-split p)
matra-split (guru âˆ· p) =
    cong (Î» z â†’ suc (suc z)) (matra-split p)
  âˆ™ cong suc (sym (+-suc (varna p) (guruOf p)))

------------------------------------------------------------------------
-- 2.  The two maps of the sorting statement
------------------------------------------------------------------------

Sorted : â„• â†’ Type
Sorted n = Î£[ ab âˆˆ (â„• Ã— â„•) ] ((fst ab + snd ab â‰¡ n) Ã— Chosen (fst ab) (snd ab))

metre-to-sorted : (n : â„•) â†’ Metre n â†’ Sorted n
metre-to-sorted n (p , dur) =
  (varna p , guruOf p) , (sym (matra-split p) âˆ™ dur) , (p , refl , refl)

sorted-to-metre : (n : â„•) â†’ Sorted n â†’ Metre n
sorted-to-metre n ((a , b) , sum , (p , va , gu)) =
  p , (matra-split p âˆ™ congâ‚‚ _+_ va gu âˆ™ sum)

------------------------------------------------------------------------
-- 3.  One round trip is immediate â” the pattern is untouched
------------------------------------------------------------------------

roundtrip-pattern :
  (n : â„•) (m : Metre n) â†’ fst (sorted-to-metre n (metre-to-sorted n m)) â‰¡ fst m
roundtrip-pattern n (p , _) = refl

------------------------------------------------------------------------
-- 4.  What the reparametrisation removes.
--
-- `Sankalita` Â§13 left one route standing out of four.  This file shows
-- its first step goes through, and that the reparametrisation removes the
-- obstacle the other three died of: there is no `n âˆ’ k` in `Sorted`, and
-- the index set `{(a,b) : a + b â‰¡ n}` is closed under the reindexing the
-- Pascal step performs, because it is symmetric in the two coordinates.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  The Î-contraction, and the equivalence.
--
-- Both round trips leave the PATTERN untouched â” that is what
-- `roundtrip-pattern` records â” so every remaining component is an
-- equation in â•, hence a proposition, hence transported by
-- `isPropâ’PathP`.  The contraction is that observation and nothing else.
------------------------------------------------------------------------

open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Data.Nat using (isSetâ„•)

metre-roundtrip :
  (n : â„•) (m : Metre n) â†’ sorted-to-metre n (metre-to-sorted n m) â‰¡ m
metre-roundtrip n (p , dur) =
  Î£PathP (refl , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _)

sorted-roundtrip :
  (n : â„•) (s : Sorted n) â†’ metre-to-sorted n (sorted-to-metre n s) â‰¡ s
sorted-roundtrip n ((a , b) , sum , (p , va , gu)) =
  Î£PathP ( Î£PathP (va , gu)
         , Î£PathP ( isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _
                  , Î£PathP ( refl
                           , Î£PathP ( isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _
                                    , isPropâ†’PathP (Î» _ â†’ isSetâ„• _ _) _ _ ) ) ) )

metre-sorts-Iso : (n : â„•) â†’ Iso (Metre n) (Sorted n)
Iso.fun      (metre-sorts-Iso n) = metre-to-sorted n
Iso.inv      (metre-sorts-Iso n) = sorted-to-metre n
Iso.rightInv (metre-sorts-Iso n) = sorted-roundtrip n
Iso.leftInv  (metre-sorts-Iso n) = metre-roundtrip n

-- THE STATEMENT.  A metre of duration n IS a choice of syllable count and
-- guru count summing to n, together with a pattern having those
-- statistics.  Pigala's sorting, as an equivalence.
metre-sorts : (n : â„•) â†’ Metre n â‰ƒ Sorted n
metre-sorts n = isoToEquiv (metre-sorts-Iso n)

------------------------------------------------------------------------
-- 6.  The cardinality reading.
--
-- `metre-sorts` is the typed diagonal identity.  Taking cardinalities
-- gives the numeric one:
--
--     mtr n  â‰¡  Î_{a+b=n} meru a b   ( = `Sankalita.antidiag n` )
--
-- via `Pingala.matraCount` on the left, `Pingala.meruCount` inside the
-- sum on the right, and the cardinality of a Î over a finite index â”
-- `Cubical.Data.FinSet.Cardinality`.
--
-- Four encodings, three refuted, one carried to an equivalence.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  The cardinality's ingredients.
--
-- `Cubical.Data.FinSet.Cardinality`'s lemma
--
--     cardÎ : card (Î X Y) â‰¡ sum X (Î» x â’ card (Y x))
--
-- takes `X` as a **FinSet**, and the index set here,
-- `Î[ (a,b) ] (a + b â‰¡ n)`, does not arrive with a finiteness proof.  So
-- two ingredients are needed, not one:
--
--   (i)  the index set is finite;
--   (ii) the library's `sum` over that FinSet is the recursive sum
--        `Sankalita.AD` â” a reindexing.
--
-- (i) holds structurally.  Induct on `n`:
--
--     Î[ (a,b) ] (a + b â‰¡ 0)        â‰  Unit
--     Î[ (a,b) ] (a + b â‰¡ suc n)    â‰  Unit âŠ Î[ (a,b) ] (a + b â‰¡ n)
--
-- â” the first summand is the pair `(0 , suc n)`, the rest have `a` a
-- successor and drop to the previous level.  No subtraction, and the
-- recursion is the one `AD` already walks; `PairsSummingTo.pairsFin` builds (i).
------------------------------------------------------------------------
