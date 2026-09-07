{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भद्रगणितम् — the mathematics of the numerical square.
--
-- THE TERM, ITS TEXT AND ITS DATE.  भद्रगणित is the name of the chapter on
-- the construction of numerical squares in Nārāyaṇa Paṇḍita's
-- *Gaṇitakaumudī*, 1356 CE — the fourteenth and last chapter, which
-- classifies भद्रs by order (सम, विषम, समसम) and gives general
-- construction rules rather than instances.  The older attested Indian
-- treatment of a numerical square is Varāhamihira, *Bṛhatsaṃhitā* 76
-- (c. 550 CE), the कच्छपुट arrangement used for compounding perfumes,
-- which is a 4×4 square with prescribed row sums.
--
-- WHAT IS AND IS NOT CLAIMED.  Neither Nārāyaṇa nor Varāhamihira is being
-- credited with matrices over ℤ, with decidable equality, with univalence,
-- or with any theorem below.  What is claimed is narrower and is true: the
-- tradition has a standing name for an n×n array of numbers taken as a
-- mathematical object in its own right, and that name is भद्र.  The object
-- below is a 3×3 array of integers taken as an object in its own right.
-- The substrate — cubical type theory, `ua`, `subst` — is not claimed for
-- any Indian source.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `machine/AnulomaPratiloma_…hs` proposed
--
--     entriesOf : Mat 3 3 → Nine   ⇄   fromNine : Nine → Mat 3 3
--     colsOf    : Col     → ℤ³     ⇄   fromCols : ℤ³   → Col
--
-- out of `NaturalMachine.SmithPathCountedExecution` and its kernel refused
-- both, at all three rungs of its ladder.  Both are equivalences and the
-- reason the machine could not see it is worth stating exactly, because it
-- is the same reason in both cases:
--
--     ONE HALF OF EACH ROUND TRIP WAS ALREADY PROVED IN THE HOST FILE, BY
--     HAND, AND THE OTHER HALF IS `refl`.
--
-- `fromNine-entries` and `fromCols-entries` sit forty lines above the
-- functions the proposer paired, proved by an exhaustive `Fin`-split which
-- is precisely the induction the proposer's rung two would have had to
-- synthesise.  The proposer offered `λ _ → refl` for BOTH directions of
-- each pair; one of the two was right.  Half a proof is not a rung of a
-- ladder — it is a lemma already in the file, and the instrument had no
-- way to look for one.
--
-- WHAT CROSSES.  Two things, and neither is in the host:
--
--   १  `Discrete (Mat 3 3)`.  Deciding equality of two 3×3 integer
--      matrices directly means deciding equality of two FUNCTIONS out of
--      `Fin 3 × Fin 3`, which needs the finiteness of the index worked
--      through by hand.  Across the edge it is `discreteΣ` applied nine
--      times to `discreteℤ`, and then one `subst`.  No induction on
--      matrices occurs in this file.
--   २  Componentwise addition AND its associativity, moved as one object
--      — the `Setubandha_…agda` pattern, where the carrier and the
--      operation travel as a pair so that the law is not re-proved on the
--      far bank.  The host has no addition on `Mat 3 3`.
------------------------------------------------------------------------

module Mula.Bhadraganita_TheThreeByThreeSquareIsNineEntriesAndDecidabilityCrossesFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.Transport using (substSubst⁻)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_ ; ΣPathP
                                     ; discreteΣ)
open import Cubical.Data.Int using (ℤ ; _+_)
open import Cubical.Data.Int.Properties using (discreteℤ ; +Assoc)
open import Cubical.Relation.Nullary using (Discrete ; Discrete→isSet)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient

open Coefficient ℤCommRing

open import NaturalMachine.SmithPathCountedExecution
  using ( Row3 ; Nine ; entriesOf ; fromNine ; fromNine-entries
        ; Col ; colsOf ; fromCols ; fromCols-entries )

------------------------------------------------------------------------
-- १ · THE TWO EDGES.  The `rightInv` half is `refl` — the entries of a
--     matrix built from a tuple are that tuple, by Σ-eta.  The `leftInv`
--     half is the host's own lemma, quoted, not rebuilt.
------------------------------------------------------------------------

nineIso : Iso (Mat 3 3) Nine
Iso.fun      nineIso = entriesOf
Iso.inv      nineIso = fromNine
Iso.rightInv nineIso _ = refl
Iso.leftInv  nineIso = fromNine-entries

Mat3≃Nine : Mat 3 3 ≃ Nine
Mat3≃Nine = isoToEquiv nineIso

Mat3≡Nine : Mat 3 3 ≡ Nine
Mat3≡Nine = ua Mat3≃Nine

colIso : Iso Col Row3
Iso.fun      colIso = colsOf
Iso.inv      colIso = fromCols
Iso.rightInv colIso _ = refl
Iso.leftInv  colIso = fromCols-entries

Col≃Row3 : Col ≃ Row3
Col≃Row3 = isoToEquiv colIso

Col≡Row3 : Col ≡ Row3
Col≡Row3 = ua Col≃Row3

------------------------------------------------------------------------
-- २ · DECIDABLE EQUALITY, CROSSED.
--
--     `Nine` is a nested product of nine copies of ℤ; `discreteΣ` and
--     `discreteℤ` settle it with no reference to matrices at all.  Then
--     one `subst` along the edge, and 3×3 integer matrices have decidable
--     equality — including the `isSet` that follows, which the host also
--     never proves.
------------------------------------------------------------------------

discreteRow3 : Discrete Row3
discreteRow3 = discreteΣ discreteℤ (λ _ → discreteΣ discreteℤ (λ _ → discreteℤ))

discreteNine : Discrete Nine
discreteNine = discreteΣ discreteRow3 (λ _ → discreteΣ discreteRow3 (λ _ → discreteRow3))

discreteMat3 : Discrete (Mat 3 3)
discreteMat3 = subst Discrete (sym Mat3≡Nine) discreteNine

isSetMat3 : isSet (Mat 3 3)
isSetMat3 = Discrete→isSet discreteMat3

discreteCol : Discrete Col
discreteCol = subst Discrete (sym Col≡Row3) discreteRow3

------------------------------------------------------------------------
-- ३ · AN OPERATION AND ITS LAW, CROSSED TOGETHER.
--
--     The pair (carrier , operation) is moved as ONE object, so the law
--     arrives with it and is not re-proved on the far bank.  This is why
--     `Assoc` below is a predicate on the PAIR and not on the operation.
------------------------------------------------------------------------

Magma : Type₁
Magma = Σ[ A ∈ Type₀ ] (A → A → A)

Assoc : Magma → Type₀
Assoc (A , op) = (a b c : A) → op (op a b) c ≡ op a (op b c)

_+Row_ : Row3 → Row3 → Row3
(a , b , c) +Row (x , y , z) = a + x , b + y , c + z

+Row-assoc : Assoc (Row3 , _+Row_)
+Row-assoc (a , b , c) (x , y , z) (u , v , w) i =
  +Assoc a x u (~ i) , +Assoc b y v (~ i) , +Assoc c z w (~ i)

_+Nine_ : Nine → Nine → Nine
(r , s , t) +Nine (r' , s' , t') = r +Row r' , s +Row s' , t +Row t'

+Nine-assoc : Assoc (Nine , _+Nine_)
+Nine-assoc (r , s , t) (r' , s' , t') (r'' , s'' , t'') i =
    +Row-assoc r r' r'' i
  , +Row-assoc s s' s'' i
  , +Row-assoc t t' t'' i

-- the transported operation on matrices, and the transported law
_+Mat_ : Mat 3 3 → Mat 3 3 → Mat 3 3
_+Mat_ = subst (λ A → A → A → A) (sym Mat3≡Nine) _+Nine_

मार्गः : Path Magma (Mat 3 3 , _+Mat_) (Nine , _+Nine_)
मार्गः = ΣPathP (Mat3≡Nine
               , toPathP (substSubst⁻ (λ A → A → A → A) Mat3≡Nine _+Nine_))

+Mat-assoc : Assoc (Mat 3 3 , _+Mat_)
+Mat-assoc = subst Assoc (sym मार्गः) +Nine-assoc

-- the same for columns, at no extra cost
_+Col_ : Col → Col → Col
_+Col_ = subst (λ A → A → A → A) (sym Col≡Row3) _+Row_

मार्गः-col : Path Magma (Col , _+Col_) (Row3 , _+Row_)
मार्गः-col = ΣPathP (Col≡Row3
                   , toPathP (substSubst⁻ (λ A → A → A → A) Col≡Row3 _+Row_))

+Col-assoc : Assoc (Col , _+Col_)
+Col-assoc = subst Assoc (sym मार्गः-col) +Row-assoc

------------------------------------------------------------------------
-- ४ · WHAT IS NOT PROVED HERE, stated so nothing is read into it.
--
--   * That `_+Mat_` is the library's matrix addition.  It is the transport
--     of componentwise addition on the tuple, and it agrees with the
--     entrywise sum by construction; but `Cubical.Algebra.Matrix`'s own
--     `addFinMatrix` is a different term and no path between them is built
--     here.  `Setubandha_…agda` §५ records the identical caveat about its
--     transported concatenation, and the caveat is the honest one: what is
--     proved is that the carrier has an associative operation obtained
--     without re-proving anything.
--   * That anything here bears on the Smith normal form the host file is
--     about.  These are the host's transcription helpers, not its
--     mathematics; the edges are real and they are edges between a matrix
--     type and a tuple type, which is all.
--   * That the भद्र literature contains a decidability statement.  It does
--     not, and §० says what is being taken from it: a name for the object.
------------------------------------------------------------------------
