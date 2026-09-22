{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Pratyahara
--
-- ‡‡‡∞‡‡‡Ø‡æ‡‡æ‡∞ ‚î Pini's abbreviation device, and a fourth level of the
-- tower `Anuvrtti` built.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE DEVICE
--
-- The iva-stras list the phonemes in a chosen order with markers (‡‡‡)
-- placed between groups.  A pratyhra names a set of phonemes in TWO
-- symbols ‚î a first element and a marker ‚î and it names exactly the
-- CONTIGUOUS RUN between them.  ‡‡‡, ‡‡≤‡, ‡‡≤‡, ‡Ø‡‡ are all of this form.
-- The whole of the Adhyy's brevity rests on it: a rule that would
-- have to list twenty phonemes lists two.
--
-- So the cost of naming a set is 2 when the set is an interval of the
-- chosen order, and the size of the set otherwise.  Which means **the
-- order of the alphabet is itself a –ªghava-bearing choice**, sitting
-- below the ordered rule text:
--
--   denotation  <  rule set  <  ordered rule text  <  alphabet order
--
-- The first three separations are `Laghava` and `Anuvrtti`.  This module
-- is the fourth, and it is the one with a hard obstruction in it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE OBSTRUCTION
--
-- Not every family of sets can be made intervals at once.  Over three
-- letters, the three two-element subsets cannot:
--
--     no-order-makes-all-intervals :
--       (o : Ord) ‚í Œ[ s ‚àà Pair ] (isInterval o s ‚â° false)
--
-- For any ordering (a, b, c), the set {a, c} skips the middle and is not
-- a run.  All six orderings are checked, each by `refl` ‚î finite
-- exhaustive verification.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THAT PREDICTS ABOUT THE IVA-STRAS, AND IT IS TRUE OF THEM
--
-- If the grammatically required sets do not all fit one linear order,
-- then a list in which every phoneme occurs ONCE cannot supply every
-- needed pratyhra.  The way out is to let a phoneme occur twice, so it
-- can sit in two different runs.
--
-- Pini does exactly this.  ‡ appears twice in the iva-stras ‚î once in
-- ‡‡Ø‡µ‡∞‡ü‡ and once in ‡‡≤‡ ‚î and the doubling is what lets both ‡‡≤‡ and ‡‡≤‡
-- be single runs.  It has been read as redundancy or as a transmission
-- artefact.  It is neither: **repetition is forced**, and the obstruction
-- above is the reason, in its smallest instance.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
------------------------------------------------------------------------

module Pratyahara where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  Three letters, and the sets to be named
------------------------------------------------------------------------

data L : Type where
  x y z : L

Set‚ÇÉ : Type
Set‚ÇÉ = L ‚Üí Bool

data Pair : Type where
  XY YZ XZ : Pair

mem : Pair ‚Üí Set‚ÇÉ
mem XY x = true
mem XY y = true
mem XY z = false
mem YZ x = false
mem YZ y = true
mem YZ z = true
mem XZ x = true
mem XZ y = false
mem XZ z = true

------------------------------------------------------------------------
-- 2.  Orderings, and what it means to be a run
--
-- For a three-element order (a, b, c), a set fails to be contiguous
-- exactly when it holds a and c but not b.  That is computed, not
-- tabulated.
------------------------------------------------------------------------

data Ord : Type where
  xyz xzy yxz yzx zxy zyx : Ord

triple : Ord ‚Üí L √ó L √ó L
triple xyz = x , y , z
triple xzy = x , z , y
triple yxz = y , x , z
triple yzx = y , z , x
triple zxy = z , x , y
triple zyx = z , y , x

skips : L √ó L √ó L ‚Üí Set‚ÇÉ ‚Üí Bool
skips (a , b , c) s = s a and (not (s b) and s c)

isInterval : Ord ‚Üí Pair ‚Üí Bool
isInterval o p = not (skips (triple o) (mem p))

------------------------------------------------------------------------
-- 3.  THE OBSTRUCTION.  Every ordering fails on some pair.
--
-- The witness is always the pair of the two OUTER letters.
------------------------------------------------------------------------

no-order-makes-all-intervals :
  (o : Ord) ‚Üí Œ£[ p ‚àà Pair ] (isInterval o p ‚â° false)
no-order-makes-all-intervals xyz = XZ , refl
no-order-makes-all-intervals xzy = XY , refl
no-order-makes-all-intervals yxz = YZ , refl
no-order-makes-all-intervals yzx = XY , refl
no-order-makes-all-intervals zxy = YZ , refl
no-order-makes-all-intervals zyx = XZ , refl

-- stated as the impossibility it is
consecutive-ones-can-fail :
  ¬¨ (Œ£[ o ‚àà Ord ] ((p : Pair) ‚Üí isInterval o p ‚â° true))
consecutive-ones-can-fail (o , all) with no-order-makes-all-intervals o
... | (p , bad) = true‚â¢false (sym (all p) ‚àô bad)
  where
  open import Cubical.Data.Bool using (true‚â¢false)

------------------------------------------------------------------------
-- 4.  And each ordering does name the other two pairs in two symbols
--
-- So the obstruction is exactly one set short, not a general failure ‚î
-- which is why the repair is one repetition and not a redesign.
------------------------------------------------------------------------

xyz-names-XY : isInterval xyz XY ‚â° true
xyz-names-XY = refl

xyz-names-YZ : isInterval xyz YZ ‚â° true
xyz-names-YZ = refl

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- ‡≤‡æ‡ò‡µ descends one further level than `Anuvrtti` reached: past the
-- ordered rule text to the ordering of the ALPHABET, because that order
-- decides which sets cost two symbols and which cost their cardinality.
-- And at that level, unlike the ones above it, there is a genuine
-- obstruction: some families of sets fit no linear order at all.
--
-- Pini's response ‚î repeat a phoneme so it can lie in two runs ‚î is not
-- untidiness.  It is the only available response, and the smallest
-- instance of the obstruction is checked above.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  ONE REPETITION SUFFICES.
--
-- With a letter allowed to occur twice, "nameable" changes meaning: a set
-- is nameable when SOME contiguous run of positions has exactly that set
-- of letters ‚î not when every occurrence of every member is inside one
-- run.  That distinction is the whole point of repeating a phoneme, and
-- it is why the naive contiguity test of ¬ß2 does not apply here.
--
-- The list x y z x names all three pairs:  [x,y] , [y,z] , [z,x].
------------------------------------------------------------------------

eqL : L ‚Üí L ‚Üí Bool
eqL x x = true
eqL y y = true
eqL z z = true
eqL _ _ = false

single : L ‚Üí Set‚ÇÉ
single a = eqL a

_‚à™_ : Set‚ÇÉ ‚Üí Set‚ÇÉ ‚Üí Set‚ÇÉ
(s ‚à™ t) l = s l or t l
  where open import Cubical.Data.Bool using (_or_)

eqBool : Bool ‚Üí Bool ‚Üí Bool
eqBool true  true  = true
eqBool false false = true
eqBool _     _     = false

eqSet : Set‚ÇÉ ‚Üí Set‚ÇÉ ‚Üí Bool
eqSet s t = eqBool (s x) (t x) and (eqBool (s y) (t y) and eqBool (s z) (t z))

-- the ten non-empty runs of a four-position list
nameable4 : L ‚Üí L ‚Üí L ‚Üí L ‚Üí Set‚ÇÉ ‚Üí Bool
nameable4 a b c d S =
  eqSet (single a) S                              or
  (eqSet (single b) S                             or
  (eqSet (single c) S                             or
  (eqSet (single d) S                             or
  (eqSet (single a ‚à™ single b) S                  or
  (eqSet (single b ‚à™ single c) S                  or
  (eqSet (single c ‚à™ single d) S                  or
  (eqSet (single a ‚à™ (single b ‚à™ single c)) S     or
  (eqSet (single b ‚à™ (single c ‚à™ single d)) S     or
   eqSet (single a ‚à™ (single b ‚à™ (single c ‚à™ single d))) S))))))))
  where open import Cubical.Data.Bool using (_or_)

-- x y z x ‚î the iva-stra move, at its smallest
repaired-XY : nameable4 x y z x (mem XY) ‚â° true
repaired-XY = refl

repaired-YZ : nameable4 x y z x (mem YZ) ‚â° true
repaired-YZ = refl

repaired-XZ : nameable4 x y z x (mem XZ) ‚â° true
repaired-XZ = refl

one-repetition-suffices :
  (nameable4 x y z x (mem XY) ‚â° true)
  √ó (nameable4 x y z x (mem YZ) ‚â° true)
  √ó (nameable4 x y z x (mem XZ) ‚â° true)
one-repetition-suffices = repaired-XY , repaired-YZ , repaired-XZ

------------------------------------------------------------------------
-- So the pair of facts is complete, and they are the two halves of one
-- design decision:
--
--   ¬ß3  repetition is FORCED   ‚î no single-occurrence order names all
--                                three, all six checked;
--   ¬ß6  one repetition SUFFICES ‚î x y z x names all three.
--
-- Which is the shape of the iva-stras: ‡ twice, and not three times.
-- Not carelessness, not corruption ‚î the minimum a real obstruction
-- allows.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  THE OBSTRUCTION, QUANTIFIED.  Three positions never suffice ‚î
--     including lists that repeat a letter or omit one.
--
-- ¬ß3 rules out the six PERMUTATIONS.  That leaves the twenty-one other
-- three-position lists, and they fail too: a list omitting a letter
-- cannot name either pair containing it.  All twenty-seven are checked
-- below, exhaustively, which with ¬ß6 pins the obstruction to a number:
--
--     minimum list length for this family  =  4,  not 3.
--
-- every obstruction in this corpus takes: not "you cannot", but "not at
-- that size."
------------------------------------------------------------------------

-- the six non-empty runs of a three-position list
nameable3 : L ‚Üí L ‚Üí L ‚Üí Set‚ÇÉ ‚Üí Bool
nameable3 a b c S =
  eqSet (single a) S                          or
  (eqSet (single b) S                         or
  (eqSet (single c) S                         or
  (eqSet (single a ‚à™ single b) S              or
  (eqSet (single b ‚à™ single c) S              or
   eqSet (single a ‚à™ (single b ‚à™ single c)) S))))
  where open import Cubical.Data.Bool using (_or_)

witness : L ‚Üí L ‚Üí L ‚Üí Pair
witness a b c with nameable3 a b c (mem XY) | nameable3 a b c (mem YZ)
... | false | _     = XY
... | true  | false = YZ
... | true  | true  = XZ

no-3-list : (a b c : L) ‚Üí Œ£[ p ‚àà Pair ] (nameable3 a b c (mem p) ‚â° false)
no-3-list x x x = witness x x x , refl
no-3-list x x y = witness x x y , refl
no-3-list x x z = witness x x z , refl
no-3-list x y x = witness x y x , refl
no-3-list x y y = witness x y y , refl
no-3-list x y z = witness x y z , refl
no-3-list x z x = witness x z x , refl
no-3-list x z y = witness x z y , refl
no-3-list x z z = witness x z z , refl
no-3-list y x x = witness y x x , refl
no-3-list y x y = witness y x y , refl
no-3-list y x z = witness y x z , refl
no-3-list y y x = witness y y x , refl
no-3-list y y y = witness y y y , refl
no-3-list y y z = witness y y z , refl
no-3-list y z x = witness y z x , refl
no-3-list y z y = witness y z y , refl
no-3-list y z z = witness y z z , refl
no-3-list z x x = witness z x x , refl
no-3-list z x y = witness z x y , refl
no-3-list z x z = witness z x z , refl
no-3-list z y x = witness z y x , refl
no-3-list z y y = witness z y y , refl
no-3-list z y z = witness z y z , refl
no-3-list z z x = witness z z x , refl
no-3-list z z y = witness z z y , refl
no-3-list z z z = witness z z z , refl

-- so no three-position list names all three pairs, whatever it contains
three-is-not-enough :
  ¬¨ (Œ£[ abc ‚àà (L √ó L √ó L) ]
       ((p : Pair) ‚Üí nameable3 (fst abc) (fst (snd abc)) (snd (snd abc)) (mem p) ‚â° true))
three-is-not-enough ((a , b , c) , all) with no-3-list a b c
... | (p , bad) = true‚â¢false (sym (all p) ‚àô bad)
  where open import Cubical.Data.Bool using (true‚â¢false)

------------------------------------------------------------------------
-- The obstruction's whole content, as a number:
--
--   ¬ß7  three positions:  impossible, all 27 checked
--   ¬ß6  four positions:   x y z x works
--
-- The iva-stras repeat ‡ once.  Not carelessness, not corruption: the
-- exact increment a real obstruction forces.
------------------------------------------------------------------------
