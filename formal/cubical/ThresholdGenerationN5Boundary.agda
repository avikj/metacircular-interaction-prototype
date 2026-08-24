-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ThresholdGenerationN5Boundary
--
-- A checked companion to `ThresholdGenerationDichotomy` section 7.2.
-- On the five-element pentagon N5, the identity preserves binary meet and
-- top, but is not a finite nonempty pointwise meet of thresholds whose Bool
-- tests preserve meet.  The generator deliberately does not require its
-- test to send top to true, so the no-go applies to a family at least as
-- large as the admissible thresholds in the source note.
--
-- This finite boundary does not prove the open converse "thresholds generate
-- all admissible maps only if the lattice is distributive".
------------------------------------------------------------------------

module ThresholdGenerationN5Boundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Data.Sigma using (_×_; _,_)
open import Cubical.Data.Bool
  using (Bool; true; false; if_then_else_; false≢true)

------------------------------------------------------------------------
-- 1.  The pentagon meet-semilattice.
--
-- nbot < na < nc < ntop and nbot < nb < ntop, with nb incomparable to
-- na and nc.  Constructor order follows the chain before the side point.
------------------------------------------------------------------------

data N5 : Type where
  nbot na nc nb ntop : N5

_∧⁵_ : N5 → N5 → N5
nbot ∧⁵ _    = nbot
na   ∧⁵ nbot = nbot
na   ∧⁵ na   = na
na   ∧⁵ nc   = na
na   ∧⁵ nb   = nbot
na   ∧⁵ ntop = na
nc   ∧⁵ nbot = nbot
nc   ∧⁵ na   = na
nc   ∧⁵ nc   = nc
nc   ∧⁵ nb   = nbot
nc   ∧⁵ ntop = nc
nb   ∧⁵ nbot = nbot
nb   ∧⁵ na   = nbot
nb   ∧⁵ nc   = nbot
nb   ∧⁵ nb   = nb
nb   ∧⁵ ntop = nb
ntop ∧⁵ y    = y

∧⁵-idem : (x : N5) → x ∧⁵ x ≡ x
∧⁵-idem nbot = refl
∧⁵-idem na   = refl
∧⁵-idem nc   = refl
∧⁵-idem nb   = refl
∧⁵-idem ntop = refl

∧⁵-comm : (x y : N5) → x ∧⁵ y ≡ y ∧⁵ x
∧⁵-comm nbot nbot = refl
∧⁵-comm nbot na   = refl
∧⁵-comm nbot nc   = refl
∧⁵-comm nbot nb   = refl
∧⁵-comm nbot ntop = refl
∧⁵-comm na nbot = refl
∧⁵-comm na na   = refl
∧⁵-comm na nc   = refl
∧⁵-comm na nb   = refl
∧⁵-comm na ntop = refl
∧⁵-comm nc nbot = refl
∧⁵-comm nc na   = refl
∧⁵-comm nc nc   = refl
∧⁵-comm nc nb   = refl
∧⁵-comm nc ntop = refl
∧⁵-comm nb nbot = refl
∧⁵-comm nb na   = refl
∧⁵-comm nb nc   = refl
∧⁵-comm nb nb   = refl
∧⁵-comm nb ntop = refl
∧⁵-comm ntop nbot = refl
∧⁵-comm ntop na   = refl
∧⁵-comm ntop nc   = refl
∧⁵-comm ntop nb   = refl
∧⁵-comm ntop ntop = refl

-- A small no-confusion code; it keeps every contradiction kernel-checked.
Code⁵ : N5 → N5 → Type
Code⁵ nbot nbot = Unit
Code⁵ na   na   = Unit
Code⁵ nc   nc   = Unit
Code⁵ nb   nb   = Unit
Code⁵ ntop ntop = Unit
Code⁵ _    _    = ⊥

encode⁵ : (x : N5) → Code⁵ x x
encode⁵ nbot = tt
encode⁵ na   = tt
encode⁵ nc   = tt
encode⁵ nb   = tt
encode⁵ ntop = tt

decode⁵ : {x y : N5} → x ≡ y → Code⁵ x y
decode⁵ {x} p = subst (Code⁵ x) p (encode⁵ x)

------------------------------------------------------------------------
-- 2.  Admissibility and the threshold family used by the obstruction.
------------------------------------------------------------------------

PresMeet : (N5 → N5) → Type
PresMeet f = (x y : N5) → f (x ∧⁵ y) ≡ (f x) ∧⁵ (f y)

PresTop : (N5 → N5) → Type
PresTop f = f ntop ≡ ntop

Adm : (N5 → N5) → Type
Adm f = PresMeet f × PresTop f

id⁵-Adm : Adm (λ x → x)
id⁵-Adm = (λ _ _ → refl) , refl

_&&_ : Bool → Bool → Bool
true  && y = y
false && _ = false

Mult : (N5 → Bool) → Type
Mult χ = (x y : N5) → χ (x ∧⁵ y) ≡ (χ x) && (χ y)

thr⁵ : (N5 → Bool) → N5 → N5 → N5
thr⁵ χ floor s = if χ s then ntop else floor

AboveId : (N5 → N5) → Type
AboveId f = (s : N5) → s ∧⁵ (f s) ≡ s

-- A finite nonempty pointwise meet.  As in the M3 source theorem, tests
-- preserve binary meet but need not preserve top; proving failure for this
-- larger family also proves failure for admissible thresholds.
data MeetOfThresholds⁵ : (N5 → N5) → Type where
  gen : (χ : N5 → Bool) (floor : N5)
      → Mult χ
      → MeetOfThresholds⁵ (thr⁵ χ floor)
  _⋏_ : {f g : N5 → N5}
      → MeetOfThresholds⁵ f → MeetOfThresholds⁵ g
      → MeetOfThresholds⁵ (λ s → (f s) ∧⁵ (g s))

------------------------------------------------------------------------
-- 3.  The load-bearing N5 invariant.
--
-- Every threshold above the identity has value at na at least nc.  If its
-- test is false at na and its floor were na, being above id at nb and nc
-- would force both tests true.  Multiplicativity then makes the bottom test
-- true, hence every test true, contradicting the false test at na.
------------------------------------------------------------------------

AtAAboveC : (N5 → N5) → Type
AtAAboveC f = nc ∧⁵ (f na) ≡ nc

boolCase : {A : Type} (x : Bool) → (x ≡ true → A) → (x ≡ false → A) → A
boolCase true  yes no = yes refl
boolCase false yes no = no refl

threshold-above-id-at-a :
    (χ : N5 → Bool) (floor : N5)
  → Mult χ
  → AboveId (thr⁵ χ floor)
  → AtAAboveC (thr⁵ χ floor)
threshold-above-id-at-a χ nbot mult above =
  boolCase (χ na)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else nbot)) ha)
    (λ ha → ⊥rec (decode⁵ (
        sym (cong (λ z → na ∧⁵ (if z then ntop else nbot)) ha)
      ∙ above na)))
threshold-above-id-at-a χ na mult above =
  boolCase (χ na)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else na)) ha)
    (λ ha → ⊥rec (false≢true (sym ha ∙ allTrueAtA)))
  where
    testB : χ nb ≡ true
    testB = boolCase (χ nb)
      (λ hb → hb)
      (λ hb → ⊥rec (decode⁵ (
          sym (cong (λ z → nb ∧⁵ (if z then ntop else na)) hb)
        ∙ above nb)))

    testC : χ nc ≡ true
    testC = boolCase (χ nc)
      (λ hc → hc)
      (λ hc → ⊥rec (decode⁵ (
          sym (cong (λ z → nc ∧⁵ (if z then ntop else na)) hc)
        ∙ above nc)))

    testBottom : χ nbot ≡ true
    testBottom = mult nb nc
      ∙ cong (λ z → z && (χ nc)) testB
      ∙ testC

    allTrueAtA : χ na ≡ true
    allTrueAtA = sym
      (sym testBottom
      ∙ mult nbot na
      ∙ cong (λ z → z && (χ na)) testBottom)
threshold-above-id-at-a χ nc mult above =
  boolCase (χ na)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else nc)) ha)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else nc)) ha)
threshold-above-id-at-a χ nb mult above =
  boolCase (χ na)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else nb)) ha)
    (λ ha → ⊥rec (decode⁵ (
        sym (cong (λ z → na ∧⁵ (if z then ntop else nb)) ha)
      ∙ above na)))
threshold-above-id-at-a χ ntop mult above =
  boolCase (χ na)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else ntop)) ha)
    (λ ha → cong (λ z → nc ∧⁵ (if z then ntop else ntop)) ha)

-- The invariant is stable under pointwise meet.  The proof is an exact
-- five-point order calculation, not a cancellation or distributivity step.
aboveC-meet : (x y : N5)
            → nc ∧⁵ x ≡ nc → nc ∧⁵ y ≡ nc
            → nc ∧⁵ (x ∧⁵ y) ≡ nc
aboveC-meet nbot y px py = ⊥rec (decode⁵ px)
aboveC-meet na   y px py = ⊥rec (decode⁵ px)
aboveC-meet nc nbot px py = ⊥rec (decode⁵ py)
aboveC-meet nc na   px py = ⊥rec (decode⁵ py)
aboveC-meet nc nc   px py = refl
aboveC-meet nc nb   px py = ⊥rec (decode⁵ py)
aboveC-meet nc ntop px py = refl
aboveC-meet nb   y px py = ⊥rec (decode⁵ px)
aboveC-meet ntop nbot px py = ⊥rec (decode⁵ py)
aboveC-meet ntop na   px py = ⊥rec (decode⁵ py)
aboveC-meet ntop nc   px py = refl
aboveC-meet ntop nb   px py = ⊥rec (decode⁵ py)
aboveC-meet ntop ntop px py = refl

-- If a point is below a binary meet, it is below either factor.  These two
-- finite lemmas are the N5 instance of the generic semilattice calculation
-- `Terms.aboveMeetL/R` in the source module.
aboveMeetL⁵ : (s x y : N5) → s ∧⁵ (x ∧⁵ y) ≡ s → s ∧⁵ x ≡ s
aboveMeetL⁵ nbot x y p = refl
aboveMeetL⁵ na nbot y p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na na   y p = refl
aboveMeetL⁵ na nc   y p = refl
aboveMeetL⁵ na nb nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na nb na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na nb nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na nb nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na nb ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ na ntop y p = refl
aboveMeetL⁵ nc nbot y p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc na nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc na na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc na nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc na nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc na ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc nc y p = refl
aboveMeetL⁵ nc nb nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc nb na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc nb nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc nb nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc nb ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nc ntop y p = refl
aboveMeetL⁵ nb nbot y p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb na nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb na na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb na nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb na nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb na ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nc nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nc na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nc nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nc nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nc ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ nb nb y p = refl
aboveMeetL⁵ nb ntop y p = refl
aboveMeetL⁵ ntop nbot y p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop na nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop na na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop na nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop na nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop na ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nc nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nc na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nc nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nc nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nc ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nb nbot p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nb na   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nb nc   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nb nb   p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop nb ntop p = ⊥rec (decode⁵ p)
aboveMeetL⁵ ntop ntop y p = refl

aboveMeetR⁵ : (s x y : N5) → s ∧⁵ (x ∧⁵ y) ≡ s → s ∧⁵ y ≡ s
aboveMeetR⁵ s x y p =
  aboveMeetL⁵ s y x (sym (cong (λ z → s ∧⁵ z) (∧⁵-comm x y)) ∙ p)

meets-above-id-at-a : {f : N5 → N5}
                    → MeetOfThresholds⁵ f
                    → AboveId f
                    → AtAAboveC f
meets-above-id-at-a (gen χ floor mult) above =
  threshold-above-id-at-a χ floor mult above
meets-above-id-at-a (_⋏_ {f} {g} mf mg) above =
  aboveC-meet (f na) (g na)
    (meets-above-id-at-a mf (λ s → aboveMeetL⁵ s (f s) (g s) (above s)))
    (meets-above-id-at-a mg (λ s → aboveMeetR⁵ s (f s) (g s) (above s)))

------------------------------------------------------------------------
-- 4.  Checked N5 boundary.
------------------------------------------------------------------------

n5-id-not-meet-of-thresholds :
    {f : N5 → N5}
  → MeetOfThresholds⁵ f
  → ((s : N5) → f s ≡ s)
  → ⊥
n5-id-not-meet-of-thresholds {f} mf isId =
  ⊥rec (decode⁵ (
      sym (cong (λ z → nc ∧⁵ z) (isId na))
    ∙ meets-above-id-at-a mf above))
  where
    above : AboveId f
    above s = cong (λ z → s ∧⁵ z) (isId s) ∙ ∧⁵-idem s
