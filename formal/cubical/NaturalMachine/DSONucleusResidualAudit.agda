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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Delta 29 residual synthesis, audited only on the four explicitly generated
-- middle profiles.  Boolean comparison is the decision procedure for the
-- pointwise integer order, so the finite equalities below check both truth and
-- falsity cases without assuming either side.
--
-- WHY THE `tab` INDIRECTION (2026-08-15).  Proved directly on `middleSeed`,
-- these 256 instances do not return: `clMid` evaluates its argument profile
-- 64 times per output cell and `rawConvolution` a further 6, with no
-- memoization anywhere, so each `middleSeed x ⊙M middleSeed y` costs
-- 64*6*64*16 ~ 4e5 leaf evaluations per cell -- each leaf a unary-recursive
-- ℤ min/max/+/- from `Cubical.Data.Int`.  `tab` forces a profile into a
-- four-argument application whose arguments are computed once and shared;
-- `tab-eq : tab f ≡ f` holds for every f by four reflexivities and
-- normalizes nothing.  Statements, scope and fail-visibility are unchanged.
-- See NaturalMachine.DSONucleusMiddleAssociativityAudit for the full account.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusResidualAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; min)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)
open import Cubical.Data.Int.Order using (_≤_ ; ≤Dec)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)

import NaturalMachine.DSONucleusExecutionCalibration as E
import NaturalMachine.DSONucleusOneSidedProduct as L
open import NaturalMachine.DSONucleusMiddleProduct

leq : ℤ → ℤ → Bool
leq x y with ≤Dec x y
... | yes _ = true
... | no  _ = false

_≤P_ : Profile → Profile → Bool
f ≤P g =
  (leq (f E.e) (g E.e) and leq (f E.a) (g E.a))
  and (leq (f E.c) (g E.c) and leq (f E.d) (g E.d))

leftResidual : Profile → Profile → Profile
leftResidual f r z =
  L.min4
    (r (E.e E.·C z) +ℤ E.M E.e z -ℤ f E.e)
    (r (E.a E.·C z) +ℤ E.M E.a z -ℤ f E.a)
    (r (E.c E.·C z) +ℤ E.M E.c z -ℤ f E.c)
    (r (E.d E.·C z) +ℤ E.M E.d z -ℤ f E.d)

rightResidual : Profile → Profile → Profile
rightResidual f ell x =
  L.min4
    (ell (x E.·C E.e) +ℤ E.M x E.e -ℤ f E.e)
    (ell (x E.·C E.a) +ℤ E.M x E.a -ℤ f E.a)
    (ell (x E.·C E.c) +ℤ E.M x E.c -ℤ f E.c)
    (ell (x E.·C E.d) +ℤ E.M x E.d -ℤ f E.d)

private
  tabulated : ℤ → ℤ → ℤ → ℤ → Profile
  tabulated w _ _ _ E.e = w
  tabulated _ x _ _ E.a = x
  tabulated _ _ y _ E.c = y
  tabulated _ _ _ z E.d = z

  tab : Profile → Profile
  tab f = tabulated (f E.e) (f E.a) (f E.c) (f E.d)

  tab-eq : (f : Profile) → tab f ≡ f
  tab-eq f = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

  S : Generator → Profile
  S generator = tab (middleSeed generator)

  S-eq : (generator : Generator) → S generator ≡ middleSeed generator
  S-eq generator = tab-eq (middleSeed generator)

  -- The four audited predicates, as functions of profiles, so the shared and
  -- the unshared statements are literally the same function at equal
  -- arguments and the transport below normalizes nothing.
  rawL rawR midL midR : Profile → Profile → Profile → Bool
  rawL a b c = (L.rawConvolution a b ≤P c)
  rawR a b c = (b ≤P leftResidual a c)
  midL a b c = ((a ⊙M b) ≤P c)
  midR a b c = (b ≤P clMid (leftResidual a c))

  rawR' midR' : Profile → Profile → Profile → Bool
  rawR' a b c = (a ≤P rightResidual b c)
  midR' a b c = (a ≤P clMid (rightResidual b c))

  shift : (F : Profile → Profile → Profile → Bool) (x y z : Generator)
    → F (middleSeed x) (middleSeed y) (middleSeed z) ≡ F (S x) (S y) (S z)
  shift F x y z i = F (S-eq x (~ i)) (S-eq y (~ i)) (S-eq z (~ i))

abstract
  key-raw-left : (x y z : Generator) → rawL (S x) (S y) (S z) ≡ rawR (S x) (S y) (S z)
  key-raw-left genZero genZero genZero = refl
  key-raw-left genZero genZero genA = refl
  key-raw-left genZero genZero genC = refl
  key-raw-left genZero genZero genControl = refl
  key-raw-left genZero genA genZero = refl
  key-raw-left genZero genA genA = refl
  key-raw-left genZero genA genC = refl
  key-raw-left genZero genA genControl = refl
  key-raw-left genZero genC genZero = refl
  key-raw-left genZero genC genA = refl
  key-raw-left genZero genC genC = refl
  key-raw-left genZero genC genControl = refl
  key-raw-left genZero genControl genZero = refl
  key-raw-left genZero genControl genA = refl
  key-raw-left genZero genControl genC = refl
  key-raw-left genZero genControl genControl = refl
  key-raw-left genA genZero genZero = refl
  key-raw-left genA genZero genA = refl
  key-raw-left genA genZero genC = refl
  key-raw-left genA genZero genControl = refl
  key-raw-left genA genA genZero = refl
  key-raw-left genA genA genA = refl
  key-raw-left genA genA genC = refl
  key-raw-left genA genA genControl = refl
  key-raw-left genA genC genZero = refl
  key-raw-left genA genC genA = refl
  key-raw-left genA genC genC = refl
  key-raw-left genA genC genControl = refl
  key-raw-left genA genControl genZero = refl
  key-raw-left genA genControl genA = refl
  key-raw-left genA genControl genC = refl
  key-raw-left genA genControl genControl = refl
  key-raw-left genC genZero genZero = refl
  key-raw-left genC genZero genA = refl
  key-raw-left genC genZero genC = refl
  key-raw-left genC genZero genControl = refl
  key-raw-left genC genA genZero = refl
  key-raw-left genC genA genA = refl
  key-raw-left genC genA genC = refl
  key-raw-left genC genA genControl = refl
  key-raw-left genC genC genZero = refl
  key-raw-left genC genC genA = refl
  key-raw-left genC genC genC = refl
  key-raw-left genC genC genControl = refl
  key-raw-left genC genControl genZero = refl
  key-raw-left genC genControl genA = refl
  key-raw-left genC genControl genC = refl
  key-raw-left genC genControl genControl = refl
  key-raw-left genControl genZero genZero = refl
  key-raw-left genControl genZero genA = refl
  key-raw-left genControl genZero genC = refl
  key-raw-left genControl genZero genControl = refl
  key-raw-left genControl genA genZero = refl
  key-raw-left genControl genA genA = refl
  key-raw-left genControl genA genC = refl
  key-raw-left genControl genA genControl = refl
  key-raw-left genControl genC genZero = refl
  key-raw-left genControl genC genA = refl
  key-raw-left genControl genC genC = refl
  key-raw-left genControl genC genControl = refl
  key-raw-left genControl genControl genZero = refl
  key-raw-left genControl genControl genA = refl
  key-raw-left genControl genControl genC = refl
  key-raw-left genControl genControl genControl = refl

  key-raw-right : (x y z : Generator) → rawL (S x) (S y) (S z) ≡ rawR' (S x) (S y) (S z)
  key-raw-right genZero genZero genZero = refl
  key-raw-right genZero genZero genA = refl
  key-raw-right genZero genZero genC = refl
  key-raw-right genZero genZero genControl = refl
  key-raw-right genZero genA genZero = refl
  key-raw-right genZero genA genA = refl
  key-raw-right genZero genA genC = refl
  key-raw-right genZero genA genControl = refl
  key-raw-right genZero genC genZero = refl
  key-raw-right genZero genC genA = refl
  key-raw-right genZero genC genC = refl
  key-raw-right genZero genC genControl = refl
  key-raw-right genZero genControl genZero = refl
  key-raw-right genZero genControl genA = refl
  key-raw-right genZero genControl genC = refl
  key-raw-right genZero genControl genControl = refl
  key-raw-right genA genZero genZero = refl
  key-raw-right genA genZero genA = refl
  key-raw-right genA genZero genC = refl
  key-raw-right genA genZero genControl = refl
  key-raw-right genA genA genZero = refl
  key-raw-right genA genA genA = refl
  key-raw-right genA genA genC = refl
  key-raw-right genA genA genControl = refl
  key-raw-right genA genC genZero = refl
  key-raw-right genA genC genA = refl
  key-raw-right genA genC genC = refl
  key-raw-right genA genC genControl = refl
  key-raw-right genA genControl genZero = refl
  key-raw-right genA genControl genA = refl
  key-raw-right genA genControl genC = refl
  key-raw-right genA genControl genControl = refl
  key-raw-right genC genZero genZero = refl
  key-raw-right genC genZero genA = refl
  key-raw-right genC genZero genC = refl
  key-raw-right genC genZero genControl = refl
  key-raw-right genC genA genZero = refl
  key-raw-right genC genA genA = refl
  key-raw-right genC genA genC = refl
  key-raw-right genC genA genControl = refl
  key-raw-right genC genC genZero = refl
  key-raw-right genC genC genA = refl
  key-raw-right genC genC genC = refl
  key-raw-right genC genC genControl = refl
  key-raw-right genC genControl genZero = refl
  key-raw-right genC genControl genA = refl
  key-raw-right genC genControl genC = refl
  key-raw-right genC genControl genControl = refl
  key-raw-right genControl genZero genZero = refl
  key-raw-right genControl genZero genA = refl
  key-raw-right genControl genZero genC = refl
  key-raw-right genControl genZero genControl = refl
  key-raw-right genControl genA genZero = refl
  key-raw-right genControl genA genA = refl
  key-raw-right genControl genA genC = refl
  key-raw-right genControl genA genControl = refl
  key-raw-right genControl genC genZero = refl
  key-raw-right genControl genC genA = refl
  key-raw-right genControl genC genC = refl
  key-raw-right genControl genC genControl = refl
  key-raw-right genControl genControl genZero = refl
  key-raw-right genControl genControl genA = refl
  key-raw-right genControl genControl genC = refl
  key-raw-right genControl genControl genControl = refl

  key-mid-left : (x y z : Generator) → midL (S x) (S y) (S z) ≡ midR (S x) (S y) (S z)
  key-mid-left genZero genZero genZero = refl
  key-mid-left genZero genZero genA = refl
  key-mid-left genZero genZero genC = refl
  key-mid-left genZero genZero genControl = refl
  key-mid-left genZero genA genZero = refl
  key-mid-left genZero genA genA = refl
  key-mid-left genZero genA genC = refl
  key-mid-left genZero genA genControl = refl
  key-mid-left genZero genC genZero = refl
  key-mid-left genZero genC genA = refl
  key-mid-left genZero genC genC = refl
  key-mid-left genZero genC genControl = refl
  key-mid-left genZero genControl genZero = refl
  key-mid-left genZero genControl genA = refl
  key-mid-left genZero genControl genC = refl
  key-mid-left genZero genControl genControl = refl
  key-mid-left genA genZero genZero = refl
  key-mid-left genA genZero genA = refl
  key-mid-left genA genZero genC = refl
  key-mid-left genA genZero genControl = refl
  key-mid-left genA genA genZero = refl
  key-mid-left genA genA genA = refl
  key-mid-left genA genA genC = refl
  key-mid-left genA genA genControl = refl
  key-mid-left genA genC genZero = refl
  key-mid-left genA genC genA = refl
  key-mid-left genA genC genC = refl
  key-mid-left genA genC genControl = refl
  key-mid-left genA genControl genZero = refl
  key-mid-left genA genControl genA = refl
  key-mid-left genA genControl genC = refl
  key-mid-left genA genControl genControl = refl
  key-mid-left genC genZero genZero = refl
  key-mid-left genC genZero genA = refl
  key-mid-left genC genZero genC = refl
  key-mid-left genC genZero genControl = refl
  key-mid-left genC genA genZero = refl
  key-mid-left genC genA genA = refl
  key-mid-left genC genA genC = refl
  key-mid-left genC genA genControl = refl
  key-mid-left genC genC genZero = refl
  key-mid-left genC genC genA = refl
  key-mid-left genC genC genC = refl
  key-mid-left genC genC genControl = refl
  key-mid-left genC genControl genZero = refl
  key-mid-left genC genControl genA = refl
  key-mid-left genC genControl genC = refl
  key-mid-left genC genControl genControl = refl
  key-mid-left genControl genZero genZero = refl
  key-mid-left genControl genZero genA = refl
  key-mid-left genControl genZero genC = refl
  key-mid-left genControl genZero genControl = refl
  key-mid-left genControl genA genZero = refl
  key-mid-left genControl genA genA = refl
  key-mid-left genControl genA genC = refl
  key-mid-left genControl genA genControl = refl
  key-mid-left genControl genC genZero = refl
  key-mid-left genControl genC genA = refl
  key-mid-left genControl genC genC = refl
  key-mid-left genControl genC genControl = refl
  key-mid-left genControl genControl genZero = refl
  key-mid-left genControl genControl genA = refl
  key-mid-left genControl genControl genC = refl
  key-mid-left genControl genControl genControl = refl

  key-mid-right : (x y z : Generator) → midL (S x) (S y) (S z) ≡ midR' (S x) (S y) (S z)
  key-mid-right genZero genZero genZero = refl
  key-mid-right genZero genZero genA = refl
  key-mid-right genZero genZero genC = refl
  key-mid-right genZero genZero genControl = refl
  key-mid-right genZero genA genZero = refl
  key-mid-right genZero genA genA = refl
  key-mid-right genZero genA genC = refl
  key-mid-right genZero genA genControl = refl
  key-mid-right genZero genC genZero = refl
  key-mid-right genZero genC genA = refl
  key-mid-right genZero genC genC = refl
  key-mid-right genZero genC genControl = refl
  key-mid-right genZero genControl genZero = refl
  key-mid-right genZero genControl genA = refl
  key-mid-right genZero genControl genC = refl
  key-mid-right genZero genControl genControl = refl
  key-mid-right genA genZero genZero = refl
  key-mid-right genA genZero genA = refl
  key-mid-right genA genZero genC = refl
  key-mid-right genA genZero genControl = refl
  key-mid-right genA genA genZero = refl
  key-mid-right genA genA genA = refl
  key-mid-right genA genA genC = refl
  key-mid-right genA genA genControl = refl
  key-mid-right genA genC genZero = refl
  key-mid-right genA genC genA = refl
  key-mid-right genA genC genC = refl
  key-mid-right genA genC genControl = refl
  key-mid-right genA genControl genZero = refl
  key-mid-right genA genControl genA = refl
  key-mid-right genA genControl genC = refl
  key-mid-right genA genControl genControl = refl
  key-mid-right genC genZero genZero = refl
  key-mid-right genC genZero genA = refl
  key-mid-right genC genZero genC = refl
  key-mid-right genC genZero genControl = refl
  key-mid-right genC genA genZero = refl
  key-mid-right genC genA genA = refl
  key-mid-right genC genA genC = refl
  key-mid-right genC genA genControl = refl
  key-mid-right genC genC genZero = refl
  key-mid-right genC genC genA = refl
  key-mid-right genC genC genC = refl
  key-mid-right genC genC genControl = refl
  key-mid-right genC genControl genZero = refl
  key-mid-right genC genControl genA = refl
  key-mid-right genC genControl genC = refl
  key-mid-right genC genControl genControl = refl
  key-mid-right genControl genZero genZero = refl
  key-mid-right genControl genZero genA = refl
  key-mid-right genControl genZero genC = refl
  key-mid-right genControl genZero genControl = refl
  key-mid-right genControl genA genZero = refl
  key-mid-right genControl genA genA = refl
  key-mid-right genControl genA genC = refl
  key-mid-right genControl genA genControl = refl
  key-mid-right genControl genC genZero = refl
  key-mid-right genControl genC genA = refl
  key-mid-right genControl genC genC = refl
  key-mid-right genControl genC genControl = refl
  key-mid-right genControl genControl genZero = refl
  key-mid-right genControl genControl genA = refl
  key-mid-right genControl genControl genC = refl
  key-mid-right genControl genControl genControl = refl

  raw-left-residuation : (x y z : Generator)
    → (L.rawConvolution (middleSeed x) (middleSeed y) ≤P middleSeed z)
      ≡ (middleSeed y ≤P leftResidual (middleSeed x) (middleSeed z))
  raw-left-residuation x y z =
    shift rawL x y z ∙ key-raw-left x y z ∙ sym (shift rawR x y z)

  raw-right-residuation : (x y z : Generator)
    → (L.rawConvolution (middleSeed x) (middleSeed y) ≤P middleSeed z)
      ≡ (middleSeed x ≤P rightResidual (middleSeed y) (middleSeed z))
  raw-right-residuation x y z =
    shift rawL x y z ∙ key-raw-right x y z ∙ sym (shift rawR' x y z)

  -- For middle-closed inputs, test the closure-aware candidate residuals.
  middle-left-residuation : (x y z : Generator)
    → ((middleSeed x ⊙M middleSeed y) ≤P middleSeed z)
      ≡ (middleSeed y ≤P clMid (leftResidual (middleSeed x) (middleSeed z)))
  middle-left-residuation x y z =
    shift midL x y z ∙ key-mid-left x y z ∙ sym (shift midR x y z)

  middle-right-residuation : (x y z : Generator)
    → ((middleSeed x ⊙M middleSeed y) ≤P middleSeed z)
      ≡ (middleSeed x ≤P clMid (rightResidual (middleSeed y) (middleSeed z)))
  middle-right-residuation x y z =
    shift midL x y z ∙ key-mid-right x y z ∙ sym (shift midR' x y z)

admissible : Generator → Generator → Generator → Bool
admissible x z y = (middleSeed x ⊙M middleSeed y) ≤P middleSeed z

private
  admissible-value : (x z y : Generator) (b : Bool)
    → midL (S x) (S y) (S z) ≡ b → admissible x z y ≡ b
  admissible-value x z y b p = shift midL x y z ∙ p

------------------------------------------------------------------------
-- CORRECTION, 2026-08-15.  This module had never been typechecked by anyone
-- (no .agdai under any toolchain), because the exhaustive parts did not
-- return.  With the normalization repaired, three of the four `admissible`
-- examples it asserted turn out to be FALSE, and so does the residual
-- synthesis example.  The true values, all verified below by kernel
-- reduction, are:
--
--   admissible genC genControl genZero    = false   (was asserted true)
--   admissible genC genControl genA       = true    (was asserted true)
--   admissible genC genControl genC       = false   (was asserted true)
--   admissible genC genControl genControl = false   (was asserted true)
--
-- and clMid (leftResidual (middleSeed genC) (middleSeed genControl)) takes
-- the value -3 at e and 0 at a, so it is not middleSeed genZero (which is 0
-- at e); it is not any of the four generated middle profiles.  These are
-- consistent with each other and with `middle-left-residuation` above: the
-- residual R satisfies (middleSeed y ≤P R) exactly for y = genA, which is
-- exactly the set of admissible y.  The residuation theorem is intact; only
-- the guess that the synthesized residual is the family's top element was
-- wrong.  `example-greatest` survives unchanged.
------------------------------------------------------------------------

abstract
  example-zero-not-admissible : admissible genC genControl genZero ≡ false
  example-zero-not-admissible = admissible-value genC genControl genZero false refl

  example-a-admissible : admissible genC genControl genA ≡ true
  example-a-admissible = admissible-value genC genControl genA true refl

  example-c-not-admissible : admissible genC genControl genC ≡ false
  example-c-not-admissible = admissible-value genC genControl genC false refl

  example-control-not-admissible : admissible genC genControl genControl ≡ false
  example-control-not-admissible = admissible-value genC genControl genControl false refl

  example-greatest : (b : Generator) → middleSeed b ≤P middleSeed genZero ≡ true
  example-greatest b = (λ i → S-eq b (~ i) ≤P S-eq genZero (~ i)) ∙ lemma b
    where
    lemma : (g : Generator) → S g ≤P S genZero ≡ true
    lemma genZero = refl
    lemma genA = refl
    lemma genC = refl
    lemma genControl = refl

private
  synthesized : Profile
  synthesized = clMid (leftResidual (middleSeed genC) (middleSeed genControl))

  synthesized-e : synthesized E.e ≡ negsuc 2
  synthesized-e =
    (λ i → clMid (leftResidual (S-eq genC (~ i)) (S-eq genControl (~ i))) E.e)
    ∙ refl

  zero-seed-e : middleSeed genZero E.e ≡ pos 0
  zero-seed-e = (λ i → S-eq genZero (~ i) E.e) ∙ refl

  minus-three≢zero : ¬ (negsuc 2 ≡ pos 0)
  minus-three≢zero path = subst distinguish path tt
    where
    distinguish : ℤ → Type₀
    distinguish (pos _) = ⊥
    distinguish (negsuc _) = Unit

abstract
  -- The claim this replaces was `synthesized ≡ middleSeed genZero`.  It is
  -- refuted, not merely unproved: the two profiles differ at e.
  residual-does-not-synthesize-greatest : ¬ (synthesized ≡ middleSeed genZero)
  residual-does-not-synthesize-greatest path =
    minus-three≢zero (sym synthesized-e ∙ cong (λ f → f E.e) path ∙ zero-seed-e)

-- Rigor boundary: exhaustive only for Generator^3.  The formulas are generic,
-- but no unbounded residuated-lattice theorem is claimed.
