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
-- Finite associativity audit for the explicitly generated Delta 29 middle
-- family.  The exhaustive normalization is sealed abstractly: consumers use
-- the theorem without re-expanding the 64 x 4 min/max calculations.
--
-- WHY THIS MODULE IS WRITTEN THE WAY IT IS (2026-08-15).
--
-- The first version proved the 64 cases by `refl` directly on
-- `(middleSeed x ⊙M middleSeed y) ⊙M middleSeed z`.  That does not finish:
-- not because 64 cases is many, but because `clMid f = Nsub (Nstar f)`
-- evaluates its argument profile 64 times per output cell (16 min16 slots x
-- 4 min4 slots), `rawConvolution` a further 6, and Agda memoizes no
-- application.  A profile at nesting depth k therefore costs 64^k * 6^(k-1)
-- leaf evaluations; the associativity statement has three closure layers
-- (two products over `middleSeed = clMid ∘ leftSeed`), giving
-- 384 * 384 * 64 ~ 9.4e6 leaf evaluations per cell, x4 cells x2 sides x64
-- cases ~ 5e9 -- and every leaf is an ℤ min/max/+/- from
-- `Cubical.Data.Int`, which are unary-recursive in the magnitude
-- (min (pos (suc n)) (pos (suc m)) = sucℤ (min (pos n) (pos m))), so each
-- leaf is itself tens of reduction steps.  Measured against the calibrated
-- rate of the sibling module, that is ~10 hours, not a hang; nothing about
-- it is nonterminating, and no agent had ever seen it return.
--
-- The repair is to make the sharing explicit rather than to hope for it.
-- `tab f` forces a profile into a four-argument constructor application, so
-- the four values are computed once and thereafter projected; `tab-eq` says
-- `tab f ≡ f` for *every* f by four reflexivities and normalizes nothing.
-- Inserting `tab` at each closure layer (`S`, `P`) cuts the leaf count from
-- 9.4e6 to ~1e3 per cell.  The theorem statement is unchanged, and the
-- exhaustive 64-case check is still exhaustive and still fail-visible: a
-- false instance is still a type error at that clause.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusMiddleAssociativityAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ)
import NaturalMachine.DSONucleusExecutionCalibration as E
open import NaturalMachine.DSONucleusMiddleProduct

private
  -- A profile in tabulated form: the four values are arguments, hence
  -- evaluated at most once each and shared by every later projection.
  tabulated : ℤ → ℤ → ℤ → ℤ → Profile
  tabulated w _ _ _ E.e = w
  tabulated _ x _ _ E.a = x
  tabulated _ _ y _ E.c = y
  tabulated _ _ _ z E.d = z

  tab : Profile → Profile
  tab f = tabulated (f E.e) (f E.a) (f E.c) (f E.d)

  -- Costs nothing: `tab f c` reduces to `f c` for each of the four
  -- constructors, with no commitment about f.
  tab-eq : (f : Profile) → tab f ≡ f
  tab-eq f = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

  S : Generator → Profile
  S generator = tab (middleSeed generator)

  P : Profile → Profile → Profile
  P f g = tab (f ⊙M g)

  S-eq : (generator : Generator) → S generator ≡ middleSeed generator
  S-eq generator = tab-eq (middleSeed generator)

  P-eq : (f g : Profile) → P f g ≡ f ⊙M g
  P-eq f g = tab-eq (f ⊙M g)

abstract
  -- The exhaustive check, on shared profiles.  Same 64 instances, same
  -- operator, same fail-visibility.
  key : (x y z : Generator)
    → (P (S x) (S y) ⊙M S z) ≡ (S x ⊙M P (S y) (S z))
  key genZero genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genZero genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genA genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genC genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  key genControl genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

  middle-assoc : (x y z : Generator)
    → (middleSeed x ⊙M middleSeed y) ⊙M middleSeed z
      ≡ middleSeed x ⊙M (middleSeed y ⊙M middleSeed z)
  middle-assoc x y z =
      cong₂ _⊙M_ (cong₂ _⊙M_ (sym (S-eq x)) (sym (S-eq y))) (sym (S-eq z))
    ∙ cong (_⊙M S z) (sym (P-eq (S x) (S y)))
    ∙ key x y z
    ∙ cong (S x ⊙M_) (P-eq (S y) (S z))
    ∙ cong₂ _⊙M_ (S-eq x) (cong₂ _⊙M_ (S-eq y) (S-eq z))

-- Scope remains only Generator^3.  Abstract sealing changes proof reduction,
-- not the theorem or its fail-visible exhaustive verification.
