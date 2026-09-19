{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡¶‡‡∞‡ó‡‡ø‡‡Æ‡ ‚î the mathematics of the numerical square.
--
-- THE TERM, ITS TEXT AND ITS DATE.  ‡‡¶‡‡∞‡ó‡‡ø‡ is the name of the chapter on
-- the construction of numerical squares in Nryaa Paita's
-- *Gaitakaumud*, 1356 CE ‚î the fourteenth and last chapter, which
-- classifies ‡‡¶‡‡∞s by order (‡‡Æ, ‡µ‡ø‡‡Æ, ‡‡Æ‡‡Æ) and gives general
-- construction rules rather than instances.  The older attested Indian
-- treatment of a numerical square is Varhamihira, *Bhatsahit* 76
-- (c. 550 CE), the ‡ï‡‡‡‡‡‡ü arrangement used for compounding perfumes,
-- which is a 4ó4 square with prescribed row sums.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `machine/AnulomaPratiloma_‚¶hs` proposed
--
--     entriesOf : Mat 3 3 ‚í Nine   ‚   fromNine : Nine ‚í Mat 3 3
--     colsOf    : Col     ‚í ‚¬≥     ‚   fromCols : ‚¬≥   ‚í Col
--
-- out of `SmithPathCountedExecution` and its kernel left
-- both as obligations, at all three rungs of its ladder.  Both are equivalences and the
-- reason the machine could not see it is worth stating exactly, because it
-- is the same reason in both cases:
--
--     ONE HALF OF EACH ROUND TRIP WAS ALREADY PROVED IN THE HOST FILE, BY
--     HAND, AND THE OTHER HALF IS `refl`.
--
-- `fromNine-entries` and `fromCols-entries` sit forty lines above the
-- functions the proposer paired, proved by an exhaustive `Fin`-split which
-- is precisely the induction the proposer's rung two would have had to
-- synthesise.  The proposer offered `Œª _ ‚í refl` for BOTH directions of
-- each pair; one of the two was right.  Half a proof is not a rung of a
-- ladder ‚î it is a lemma already in the file, and the instrument had no
-- way to look for one.
--
-- WHAT CROSSES.  Two things, and neither is in the host:
--
--   ‡ß  `Discrete (Mat 3 3)`.  Deciding equality of two 3ó3 integer
--      matrices directly means deciding equality of two FUNCTIONS out of
--      `Fin 3 ó Fin 3`, which needs the finiteness of the index worked
--      through by hand.  Across the edge it is `discreteŒ` applied nine
--      times to `discrete‚`, and then one `subst`.  No induction on
--      matrices occurs in this file.
--   ‡®  Componentwise addition AND its associativity, moved as one object
--      ‚î the `Setubandha_‚¶agda` pattern, where the carrier and the
--      operation travel as a pair so that the law is not re-proved on the
--      far bank.  The host has no addition on `Mat 3 3`.
------------------------------------------------------------------------

module Bhadraganita_TheThreeByThreeSquareIsNineEntriesAndDecidabilityCrossesFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.Transport using (substSubst‚Åª)
open import Cubical.Data.Sigma using (_√ó_ ; Œ£-syntax ; _,_ ; Œ£PathP
                                     ; discreteŒ£)
open import Cubical.Data.Int using (‚Ñ§ ; _+_)
open import Cubical.Data.Int.Properties using (discrete‚Ñ§ ; +Assoc)
open import Cubical.Relation.Nullary using (Discrete ; Discrete‚ÜíisSet)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient

open Coefficient ‚Ñ§CommRing

open import SmithPathCountedExecution
  using ( Row3 ; Nine ; entriesOf ; fromNine ; fromNine-entries
        ; Col ; colsOf ; fromCols ; fromCols-entries )

------------------------------------------------------------------------
-- ‡ß ¬ THE TWO EDGES.  The `rightInv` half is `refl` ‚î the entries of a
--     matrix built from a tuple are that tuple, by Œ-eta.  The `leftInv`
--     half is the host's own lemma, quoted, not rebuilt.
------------------------------------------------------------------------

nineIso : Iso (Mat 3 3) Nine
Iso.fun      nineIso = entriesOf
Iso.inv      nineIso = fromNine
Iso.rightInv nineIso _ = refl
Iso.leftInv  nineIso = fromNine-entries

Mat3‚âÉNine : Mat 3 3 ‚âÉ Nine
Mat3‚âÉNine = isoToEquiv nineIso

Mat3‚â°Nine : Mat 3 3 ‚â° Nine
Mat3‚â°Nine = ua Mat3‚âÉNine

colIso : Iso Col Row3
Iso.fun      colIso = colsOf
Iso.inv      colIso = fromCols
Iso.rightInv colIso _ = refl
Iso.leftInv  colIso = fromCols-entries

Col‚âÉRow3 : Col ‚âÉ Row3
Col‚âÉRow3 = isoToEquiv colIso

Col‚â°Row3 : Col ‚â° Row3
Col‚â°Row3 = ua Col‚âÉRow3

------------------------------------------------------------------------
-- ‡® ¬ DECIDABLE EQUALITY, CROSSED.
--
--     `Nine` is a nested product of nine copies of ‚; `discreteŒ` and
--     `discrete‚` settle it with no reference to matrices at all.  Then
--     one `subst` along the edge, and 3ó3 integer matrices have decidable
--     equality ‚î including the `isSet` that follows, which the host also
--     never proves.
------------------------------------------------------------------------

discreteRow3 : Discrete Row3
discreteRow3 = discreteŒ£ discrete‚Ñ§ (Œª _ ‚Üí discreteŒ£ discrete‚Ñ§ (Œª _ ‚Üí discrete‚Ñ§))

discreteNine : Discrete Nine
discreteNine = discreteŒ£ discreteRow3 (Œª _ ‚Üí discreteŒ£ discreteRow3 (Œª _ ‚Üí discreteRow3))

discreteMat3 : Discrete (Mat 3 3)
discreteMat3 = subst Discrete (sym Mat3‚â°Nine) discreteNine

isSetMat3 : isSet (Mat 3 3)
isSetMat3 = Discrete‚ÜíisSet discreteMat3

discreteCol : Discrete Col
discreteCol = subst Discrete (sym Col‚â°Row3) discreteRow3

------------------------------------------------------------------------
-- ‡© ¬ AN OPERATION AND ITS LAW, CROSSED TOGETHER.
--
--     The pair (carrier , operation) is moved as ONE object, so the law
--     arrives with it and is not re-proved on the far bank.  This is why
--     `Assoc` below is a predicate on the PAIR and not on the operation.
------------------------------------------------------------------------

Magma : Type‚ÇÅ
Magma = Œ£[ A ‚àà Type‚ÇÄ ] (A ‚Üí A ‚Üí A)

Assoc : Magma ‚Üí Type‚ÇÄ
Assoc (A , op) = (a b c : A) ‚Üí op (op a b) c ‚â° op a (op b c)

_+Row_ : Row3 ‚Üí Row3 ‚Üí Row3
(a , b , c) +Row (x , y , z) = a + x , b + y , c + z

+Row-assoc : Assoc (Row3 , _+Row_)
+Row-assoc (a , b , c) (x , y , z) (u , v , w) i =
  +Assoc a x u (~ i) , +Assoc b y v (~ i) , +Assoc c z w (~ i)

_+Nine_ : Nine ‚Üí Nine ‚Üí Nine
(r , s , t) +Nine (r' , s' , t') = r +Row r' , s +Row s' , t +Row t'

+Nine-assoc : Assoc (Nine , _+Nine_)
+Nine-assoc (r , s , t) (r' , s' , t') (r'' , s'' , t'') i =
    +Row-assoc r r' r'' i
  , +Row-assoc s s' s'' i
  , +Row-assoc t t' t'' i

-- the transported operation on matrices, and the transported law
_+Mat_ : Mat 3 3 ‚Üí Mat 3 3 ‚Üí Mat 3 3
_+Mat_ = subst (Œª A ‚Üí A ‚Üí A ‚Üí A) (sym Mat3‚â°Nine) _+Nine_

‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : Path Magma (Mat 3 3 , _+Mat_) (Nine , _+Nine_)
‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É = Œ£PathP (Mat3‚â°Nine
               , toPathP (substSubst‚Åª (Œª A ‚Üí A ‚Üí A ‚Üí A) Mat3‚â°Nine _+Nine_))

+Mat-assoc : Assoc (Mat 3 3 , _+Mat_)
+Mat-assoc = subst Assoc (sym ‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É) +Nine-assoc

-- the same for columns, at no extra cost
_+Col_ : Col ‚Üí Col ‚Üí Col
_+Col_ = subst (Œª A ‚Üí A ‚Üí A ‚Üí A) (sym Col‚â°Row3) _+Row_

‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É-col : Path Magma (Col , _+Col_) (Row3 , _+Row_)
‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É-col = Œ£PathP (Col‚â°Row3
                   , toPathP (substSubst‚Åª (Œª A ‚Üí A ‚Üí A ‚Üí A) Col‚â°Row3 _+Row_))

+Col-assoc : Assoc (Col , _+Col_)
+Col-assoc = subst Assoc (sym ‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É-col) +Row-assoc

------------------------------------------------------------------------
-- ‡ ¬ THE SCOPE, EXACTLY, stated so nothing is read into it.
--
--   * That `_+Mat_` is the library's matrix addition.  It is the transport
--     of componentwise addition on the tuple, and it agrees with the
--     entrywise sum by construction; but `Cubical.Algebra.Matrix`'s own
--     `addFinMatrix` is a different term and no path between them is built
--     here.  `Setubandha_‚¶agda` ¬ß‡ records the identical caveat about its
--     transported concatenation, and the caveat is the honest one: what is
--     proved is that the carrier has an associative operation obtained
--     without re-proving anything.
--   * That anything here bears on the Smith normal form the host file is
--     about.  These are the host's transcription helpers, not its
--     mathematics; the edges are real and they are edges between a matrix
--     type and a tuple type, which is all.
--   * That the ‡‡¶‡‡∞ literature contains a decidability statement.  It does
--     not, and ¬ß‡¶ says what is being taken from it: a name for the object.
------------------------------------------------------------------------
