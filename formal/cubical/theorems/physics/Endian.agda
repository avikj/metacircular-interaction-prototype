{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Endian
--
-- Place value is a CHART, not the object.
--
-- The digit presentation carries structure that ℕ does not: word
-- reversal D and digit complement E.  Both are involutions of the raw
-- word chart, they commute (Klein four), and NEITHER descends along the
-- value map to a function on ℕ --- each fact proved here by exhibiting
-- explicit witnesses, in the descent-obstruction idiom of the repo's
-- existing `ProjectionChargeAudit.agda`.
--
-- The sharp difference between D and E, which is the residual isolated
-- in `notes/DIGIT_CRYSTAL.md`, is *endianness*:
--
--   * E commutes with π = "delete the most significant digit";
--   * D does not; instead D exchanges π with ς = "delete the least
--     significant digit"  (DIGIT_CRYSTAL Thm 4.2's boxed intertwiner,
--     proved here at word level).
--
-- Everything below is at the level of finite words.  The profinite
-- statements of DIGIT_CRYSTAL §4.3 (Thm 4.4, Cor 4.5) are NOT
-- formalized here; see notes/NATURAL_MACHINE.md for the exact ledger.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module Endian (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ ; toℕ-injective ; fzero≠fone)
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Digits k

------------------------------------------------------------------------
-- 1.  E = digit complement, d ↦ b - 1 - d.
--
-- Constructed from the ≤-witness of `toℕ d < b`, so the defining
-- identity comes for free rather than through truncated subtraction.
------------------------------------------------------------------------

dcomp : Digit → Digit
dcomp d = fst (snd d) , bound
  where
    j : ℕ
    j = fst (snd d)

    wit : j + suc (toℕ d) ≡ b
    wit = snd (snd d)

    bound : suc j ≤ b
    bound = subst (_≤ b) (+-comm j 1) (subst (j + 1 ≤_) wit (≤-k+ (suc-≤-suc zero-≤)))

-- The complement identity, exactly: dcomp d + d + 1 = b.
dcomp-law : (d : Digit) → toℕ (dcomp d) + suc (toℕ d) ≡ b
dcomp-law d = snd (snd d)

dcomp-involutive : (d : Digit) → dcomp (dcomp d) ≡ d
dcomp-involutive d = toℕ-injective (inj-m+ {m = toℕ (dcomp d)} step2)
  where
    x y z : ℕ
    x = toℕ d
    y = toℕ (dcomp d)
    z = toℕ (dcomp (dcomp d))

    step1 : suc (z + y) ≡ suc (y + x)
    step1 = sym (+-suc z y) ∙ dcomp-law (dcomp d) ∙ sym (dcomp-law d) ∙ +-suc y x

    step2 : y + z ≡ y + x
    step2 = +-comm y z ∙ injSuc step1

-- E on words.
compw : Word → Word
compw = map dcomp

compw-involutive : (w : Word) → compw (compw w) ≡ w
compw-involutive []      = refl
compw-involutive (d ∷ w) = cong₂ _∷_ (dcomp-involutive d) (compw-involutive w)

------------------------------------------------------------------------
-- 2.  D = word reversal, and the Klein four group.
------------------------------------------------------------------------

-- rev is `Cubical.Data.List.rev`; rev-rev is its involutivity.
rev-involutive : (w : Word) → rev (rev w) ≡ w
rev-involutive = rev-rev

map-++ : (f : Digit → Digit) (xs ys : Word) → map f (xs ++ ys) ≡ map f xs ++ map f ys
map-++ f []       ys = refl
map-++ f (x ∷ xs) ys = cong (f x ∷_) (map-++ f xs ys)

-- D and E commute.  (DIGIT_CRYSTAL Thm 3.1: the commutator is trivial.)
rev-compw-comm : (w : Word) → rev (compw w) ≡ compw (rev w)
rev-compw-comm []      = refl
rev-compw-comm (d ∷ w) =
    cong (_++ (dcomp d ∷ [])) (rev-compw-comm w)
  ∙ sym (map-++ dcomp (rev w) (d ∷ []))

------------------------------------------------------------------------
-- 3.  The four chart symmetries id, D, E, DE are pairwise distinct.
--
-- All six inequalities are landed: D, E, DE differ from id (D≢id,
-- E≢id, DE≢id) and from each other (D≢E, DE≢D, DE≢E), each refuted
-- pointwise on an explicit witness word.  This is the on-elements
-- content of "the Klein-four action is faithful"; the K₄ group object
-- itself and a homomorphism into Word → Word are NOT constructed here,
-- so "faithful" has no formal referent beyond this distinctness.
------------------------------------------------------------------------

headD : Word → Digit
headD []      = fzero
headD (d ∷ _) = d

-- Two explicit words used as witnesses throughout.
w01 : Word
w01 = fzero ∷ fone ∷ []

w0 : Word
w0 = fzero ∷ []

toℕ-dcomp-fzero : toℕ (dcomp fzero) ≡ suc k
toℕ-dcomp-fzero =
  injSuc (sym (+-comm (toℕ (dcomp fzero)) 1) ∙ dcomp-law fzero)

dcomp-fzero≢fzero : ¬ (dcomp fzero ≡ fzero)
dcomp-fzero≢fzero p = snotz (sym toℕ-dcomp-fzero ∙ cong toℕ p)

D≢id : ¬ (rev w01 ≡ w01)
D≢id p = fzero≠fone (sym (cong headD p))

E≢id : ¬ (compw w0 ≡ w0)
E≢id p = dcomp-fzero≢fzero (cong headD p)

DE≢id : ¬ (rev (compw w0) ≡ w0)
DE≢id p = dcomp-fzero≢fzero (cong headD p)

-- D ≠ E: on the one-letter word w0, reversal is the identity but the
-- complement moves the head digit.
D≢E : ¬ ((w : Word) → rev w ≡ compw w)
D≢E h = dcomp-fzero≢fzero (sym (cong headD (h w0)))

-- DE ≠ D: on w0, D is the identity but DE complements the head digit.
DE≢D : ¬ ((w : Word) → rev (compw w) ≡ rev w)
DE≢D h = dcomp-fzero≢fzero (cong headD (h w0))

-- DE ≠ E: on the two-letter word w01, DE puts the complement of fone at
-- the head while E keeps the complement of fzero there; equality of the
-- heads would force fone ≡ fzero through involutivity of dcomp.
DE≢E : ¬ ((w : Word) → rev (compw w) ≡ compw w)
DE≢E h = fzero≠fone (sym q)
  where
    p : dcomp fone ≡ dcomp fzero
    p = cong headD (h w01)

    q : fone ≡ fzero
    q = sym (dcomp-involutive fone) ∙ cong dcomp p ∙ dcomp-involutive fzero

------------------------------------------------------------------------
-- 4.  Neither symmetry preserves canonicity: they are not even
--     endomorphisms of the canonical-word presentation.
------------------------------------------------------------------------

w01-canonical : Canonical w01
w01-canonical = suc-≤-suc zero-≤

rev-breaks-canonicity : ¬ (Canonical (rev w01))
rev-breaks-canonicity = ¬-<-zero

wtop : Word
wtop = dcomp fzero ∷ []

wtop-canonical : Canonical wtop
wtop-canonical = subst (0 <_) (sym toℕ-dcomp-fzero) (suc-≤-suc zero-≤)

compw-breaks-canonicity : ¬ (Canonical (compw wtop))
compw-breaks-canonicity c =
  ¬-<-zero (subst (0 <_) (cong toℕ (dcomp-involutive fzero)) c)

------------------------------------------------------------------------
-- 5.  Neither symmetry descends along the value map.
--
-- This is the formal content of "place value is a chart, not the
-- object".  Cf. `ProjectionChargeAudit.noChargeDescent`.
------------------------------------------------------------------------

-- Two words with the same value but different reversals.
u1 : Word
u1 = fone ∷ []

v1 : Word
v1 = fone ∷ fzero ∷ []

value-w0 : value w0 ≡ 0
value-w0 = sym (0≡m·0 b)

value-u1 : value u1 ≡ 1
value-u1 = cong suc (sym (0≡m·0 b))

value-v1 : value v1 ≡ 1
value-v1 = cong (λ z → suc (b · z)) value-w0 ∙ cong suc (sym (0≡m·0 b))

value-rev-v1 : value (rev v1) ≡ b
value-rev-v1 = cong (b ·_) value-u1 ∙ ·-identityʳ b

1≢b : ¬ (1 ≡ b)
1≢b p = znots (injSuc p)

-- REVERSAL DOES NOT DESCEND.
noRevDescent :
  ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (rev w)))
noRevDescent (f , agrees) = 1≢b contradiction
  where
    left : f 1 ≡ 1
    left = cong f (sym value-u1) ∙ agrees u1 ∙ value-u1

    right : f 1 ≡ b
    right = cong f (sym value-v1) ∙ agrees v1 ∙ value-rev-v1

    contradiction : 1 ≡ b
    contradiction = sym left ∙ right

-- COMPLEMENT DOES NOT DESCEND EITHER.
value-compw-w0 : value (compw w0) ≡ suc k
value-compw-w0 = cong (_+ b · 0) toℕ-dcomp-fzero ∙ cong (suc k +_) (sym (0≡m·0 b))
               ∙ +-zero (suc k)

noCompDescent :
  ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (compw w)))
noCompDescent (f , agrees) = znots contradiction
  where
    left : f 0 ≡ 0
    left = agrees []

    right : f 0 ≡ suc k
    right = cong f (sym value-w0) ∙ agrees w0 ∙ value-compw-w0

    contradiction : 0 ≡ suc k
    contradiction = sym left ∙ right

------------------------------------------------------------------------
-- 6.  The residual: endianness.
--
-- The two truncations of a digit word.  π deletes the most significant
-- digit (the one the profinite limit ℤ_b is built from); ς deletes the
-- least significant one.
------------------------------------------------------------------------

π : Word → Word
π []          = []
π (d ∷ [])    = []
π (d ∷ e ∷ w) = d ∷ π (e ∷ w)

ς : Word → Word
ς []      = []
ς (d ∷ w) = w

π-snoc : (xs : Word) (y : Digit) → π (xs ++ (y ∷ [])) ≡ xs
π-snoc []           y = refl
π-snoc (x ∷ [])     y = refl
π-snoc (x ∷ z ∷ xs) y = cong (x ∷_) (π-snoc (z ∷ xs) y)

-- DIGIT_CRYSTAL Thm 4.2, first boxed identity, at word level:
-- reversal exchanges the two truncation systems.
π-rev : (w : Word) → π (rev w) ≡ rev (ς w)
π-rev []      = refl
π-rev (d ∷ w) = π-snoc (rev w) d

ς-rev : (w : Word) → ς (rev w) ≡ rev (π w)
ς-rev w =
    sym (rev-rev (ς (rev w)))
  ∙ cong rev (sym (π-rev (rev w)) ∙ cong π (rev-rev w))

-- E IS compatible with π: the complement descends to every ℤ/bⁿ chart
-- compatibly with truncation.
π-compw : (w : Word) → π (compw w) ≡ compw (π w)
π-compw []          = refl
π-compw (d ∷ [])    = refl
π-compw (d ∷ e ∷ w) = cong (dcomp d ∷_) (π-compw (e ∷ w))

ς-compw : (w : Word) → ς (compw w) ≡ compw (ς w)
ς-compw []      = refl
ς-compw (d ∷ w) = refl

-- D IS NOT.  This is the exact obstruction: reversal needs a most
-- significant end to exist, and the truncation system that has a
-- group-valued limit is the one that deletes it.
noRevπEquivariance : ¬ ((w : Word) → π (rev w) ≡ rev (π w))
noRevπEquivariance h = fzero≠fone (sym (cong headD (h w01)))

------------------------------------------------------------------------
-- 7.  Summary object: the Klein four data, packaged.
--
-- "Klein four" names the shape of this data (two commuting involutions
-- and their composite, all four elements pairwise distinct); no Group
-- instance is constructed.
------------------------------------------------------------------------

record ChartSymmetry : Type₀ where
  field
    D-involutive : (w : Word) → rev (rev w) ≡ w
    E-involutive : (w : Word) → compw (compw w) ≡ w
    DE-commute   : (w : Word) → rev (compw w) ≡ compw (rev w)
    D-nontrivial : ¬ (rev w01 ≡ w01)
    E-nontrivial : ¬ (compw w0 ≡ w0)
    DE-nontrivial : ¬ (rev (compw w0) ≡ w0)
    D-E-distinct  : ¬ ((w : Word) → rev w ≡ compw w)
    DE-D-distinct : ¬ ((w : Word) → rev (compw w) ≡ rev w)
    DE-E-distinct : ¬ ((w : Word) → rev (compw w) ≡ compw w)
    D-no-descent : ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (rev w)))
    E-no-descent : ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (compw w)))
    E-π-equivariant : (w : Word) → π (compw w) ≡ compw (π w)
    D-not-π-equivariant : ¬ ((w : Word) → π (rev w) ≡ rev (π w))
    D-exchanges-truncations : (w : Word) → π (rev w) ≡ rev (ς w)

chartSymmetry : ChartSymmetry
chartSymmetry = record
  { D-involutive            = rev-involutive
  ; E-involutive            = compw-involutive
  ; DE-commute              = rev-compw-comm
  ; D-nontrivial            = D≢id
  ; E-nontrivial            = E≢id
  ; DE-nontrivial           = DE≢id
  ; D-E-distinct            = D≢E
  ; DE-D-distinct           = DE≢D
  ; DE-E-distinct           = DE≢E
  ; D-no-descent            = noRevDescent
  ; E-no-descent            = noCompDescent
  ; E-π-equivariant         = π-compw
  ; D-not-π-equivariant     = noRevπEquivariance
  ; D-exchanges-truncations = π-rev
  }
