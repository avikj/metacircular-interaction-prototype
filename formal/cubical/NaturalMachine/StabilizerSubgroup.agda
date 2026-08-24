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
-- NaturalMachine.StabilizerSubgroup
--
-- T15.9 AS A SUBGROUP.  A completion of `NaturalMachine.DefectCalculus`
-- §4, written as a separate module so that nobody's file is edited.
--
-- THE OBJECTION.  `DefectCalculus`'s ledger records, under WHAT IS NOT
-- CLAIMED:
--
--     "T15.9 is not proved as 'subgroup'.  §4 takes a family of
--      self-equivalences and proves closure under identity, composition
--      and inverse.  The *group* statement wants a group object acting;
--      packaging one here would be scope creep."
--
-- The first half of that sentence is not accurate and the diagnosis in
-- the second half is the wrong one.  §4's parameter is not "a family of
-- self-equivalences": it is `A ≃ A`, which IS the group object, and
-- cubical ships it as `Cubical.Algebra.SymmetricGroup`
-- `SymGroup A isSetA` — `1g = idEquiv`, `_·_ = compEquiv`,
-- `inv = invEquiv`, i.e. literally the three operations §4's three
-- lemmas are stated at.  No group object had to be packaged.
--
-- WHAT WAS ACTUALLY MISSING is two h-level hypotheses, and this module
-- is the evidence: given them, the subgroup statement is the code
-- below, whose entire proof is §4's three lemmas cited unchanged.
--
--   (i)  `isSet A`, so that `A ≃ A` carries a group structure at all
--        (`SymGroup` demands it; without it the automorphisms
--        form a higher group and "subgroup" needs coherence, not
--        closure).
--   (ii) `isSet (Str A)`, so that `Stab g = subst Str (ua g) s ≡ s` is
--        a PROPOSITION.  Cubical's `Subgroup G = Σ[ H ∈ ℙ ⟨ G ⟩ ]
--        isSubgroup H` takes `H` valued in `hProp`, because a subgroup
--        is a property of an element and not a structure on it.
--        Without (ii), `stab-∘` is a CHOICE of composite witness rather
--        than a closure fact, and the closure clauses would themselves
--        need coherence conditions (associativity of `stab-∘` against
--        `compEquiv-assoc`, and so on) which §4 does not state.
--
-- So the honest ledger entry is not "the group packaging would be scope
-- creep" — it is thirteen lines and reuses §4 verbatim — but: *§4 is
-- stated at a generality (arbitrary `A`, arbitrary `Str : Type ℓ →
-- Type ℓ'`) at which "subgroup" is not yet well-posed.*  That is a
-- sharper statement than the one recorded, and it is the corpus's own
-- recurring lesson: the obstruction was an h-level, not a missing
-- library.  Compare `notes/WALK_INSTALLS_ARE_JUMPS.md` ("the library's
-- missing machinery was never the obstacle").
--
-- The restriction `ℓ' = ℓ` below is cubical's `ℙ X = X → hProp _` at
-- `X`'s own level, not a mathematical restriction; a `Lift` would
-- remove it and add nothing.
--
-- NOT CLAIMED.  Nothing here is new mathematics: "the stabiliser of a
-- point under a group action is a subgroup" is standard, and the point
-- of the module is only that the corpus's version of it is now the
-- library's `Subgroup`, so downstream lanes get `Subgroup→Group`,
-- `isNormal`, quotients and the rest by citation.  In particular this
-- does NOT supply the group statement at non-set `Str A`, which is a
-- real open item and is where the coherence work lives.
--
-- A second remark, recorded and not pursued: `Σ[ g ∈ A ≃ A ] Stab g` is
-- the fibre of the orbit map `g ↦ subst Str (ua g) s` over `s`, so §4
-- is also an instance of the fibre language in
-- `NaturalMachine.CertificateFibration`.  Making that identification
-- carry weight needs the orbit map's own universal property, which is
-- `NaturalMachine.StabilizerTorsor`'s subject, not this file's.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (`formal/cubical/BUILD.md`),
-- `--cubical --safe`, no postulates, no holes.  Deliberately not
-- imported by `NaturalMachine.agda` (this session was forbidden to edit
-- the root aggregate); `DefectCalculus`'s owner should fold it in or
-- reject it.
------------------------------------------------------------------------

module NaturalMachine.StabilizerSubgroup where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Powerset using (ℙ)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Group.Base using (Group)
open import Cubical.Algebra.Group.Subgroup using (isSubgroup ; Subgroup)
-- see NaturalMachine/PathIsSymmetry.agda: this name is v0.9-only in cubical
-- (v0.5 spells it Symmetric-Group), so it is defined there once instead
open import NaturalMachine.PathIsSymmetry using (SymGroup)

open import NaturalMachine.DefectCalculus using (Stab ; stab-id ; stab-∘ ; stab-inv)

private
  variable
    ℓ : Level

module _ (Str : Type ℓ → Type ℓ) {A : Type ℓ}
         (isSetA : isSet A) (isSetStrA : isSet (Str A)) (s : Str A) where

  private
    Aut : Group ℓ
    Aut = SymGroup A isSetA

  -- (ii) made visible: `Stab` becomes a subSET only because `Str A` is
  -- a set.  This line is the whole content of the correction.
  StabP : ℙ ⟨ Aut ⟩
  StabP g = Stab Str s g , isSetStrA _ _

  -- The three fields are `DefectCalculus`'s three lemmas, unchanged.
  -- `1g`, `_·_`, `inv` of `SymGroup` reduce to `idEquiv`,
  -- `compEquiv`, `invEquiv`, so no bridging lemma is needed either.
  isSubgroupStab : isSubgroup Aut StabP
  isSubgroup.id-closed  isSubgroupStab       = stab-id Str s
  isSubgroup.op-closed  isSubgroupStab sg sh = stab-∘ Str s _ _ sg sh
  isSubgroup.inv-closed isSubgroupStab sg    = stab-inv Str s _ sg

  -- T15.9, in the form Delta 15 states it.
  stabilizerSubgroup : Subgroup Aut
  stabilizerSubgroup = StabP , isSubgroupStab
