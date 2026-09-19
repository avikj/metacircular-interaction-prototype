{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- StabilizerSubgroup
--
-- T15.9 AS A SUBGROUP.  A completion of `DefectCalculus`
-- Â§4, written as a separate module so that nobody's file is edited.
--
-- THE OBJECTION.  `DefectCalculus`'s ledger records, under WHAT IS NOT
-- CLAIMED:
--
--     "T15.9 is not proved as 'subgroup'.  Â§4 takes a family of
--      self-equivalences and proves closure under identity, composition
--      and inverse.  The *group* statement wants a group object acting;
--      packaging one here would be scope creep."
--
-- The first half of that sentence is not accurate and the diagnosis in
-- the second half is the wrong one.  Â§4's parameter is not "a family of
-- self-equivalences": it is `A â‰ A`, which IS the group object, and
-- cubical ships it as `Cubical.Algebra.SymmetricGroup`
-- `SymGroup A isSetA` â” `1g = idEquiv`, `_Â_ = compEquiv`,
-- `inv = invEquiv`, i.e. literally the three operations Â§4's three
-- lemmas are stated at.  No group object had to be packaged.
--
-- WHAT WAS ACTUALLY MISSING is two h-level hypotheses, and this module
-- is the evidence: given them, the subgroup statement is the code
-- below, whose entire proof is Â§4's three lemmas cited unchanged.
--
--   (i)  `isSet A`, so that `A â‰ A` carries a group structure at all
--        (`SymGroup` demands it; without it the automorphisms
--        form a higher group and "subgroup" needs coherence, not
--        closure).
--   (ii) `isSet (Str A)`, so that `Stab g = subst Str (ua g) s â‰¡ s` is
--        a PROPOSITION.  Cubical's `Subgroup G = Î[ H âˆˆ â™ âŸ¨ G âŸ© ]
--        isSubgroup H` takes `H` valued in `hProp`, because a subgroup
--        is a property of an element and not a structure on it.
--        Without (ii), `stab-âˆ˜` is a CHOICE of composite witness rather
--        than a closure fact, and the closure clauses would themselves
--        need coherence conditions (associativity of `stab-âˆ˜` against
--        `compEquiv-assoc`, and so on) which Â§4 does not state.
--
-- So the honest ledger entry is not "the group packaging would be scope
-- creep" â” it is thirteen lines and reuses Â§4 verbatim â” but: *Â§4 is
-- stated at a generality (arbitrary `A`, arbitrary `Str : Type â“ â’
-- Type â“'`) at which "subgroup" is not yet well-posed.*  That is a
-- sharper statement than the one recorded, and it is the corpus's own
-- recurring lesson: the obstruction was an h-level, not a missing
-- missing machinery was never the obstacle").
--
-- The restriction `â“' = â“` below is cubical's `â™ X = X â’ hProp _` at
-- `X`'s own level, not a mathematical restriction; a `Lift` would
-- remove it and add nothing.
--
-- A second remark, recorded and not pursued: `Î[ g âˆˆ A â‰ A ] Stab g` is
-- the fibre of the orbit map `g â¦ subst Str (ua g) s` over `s`, so Â§4
-- is also an instance of the fibre language in
-- `CertificateFibration`.  Making that identification
-- carry weight needs the orbit map's own universal property, which is
-- `StabilizerTorsor`'s subject, not this file's.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (`formal/cubical/BUILD.md`),
-- `--cubical --safe`, no postulates, no holes.  Deliberately not
-- imported by `agda` (this session was forbidden to edit
-- the root aggregate); `DefectCalculus`'s owner should fold it in or
-- reject it.
------------------------------------------------------------------------

module StabilizerSubgroup where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Powerset using (â„™)
open import Cubical.Foundations.Structure using (âŸ¨_âŸ©)
open import Cubical.Algebra.Group.Base using (Group)
open import Cubical.Algebra.Group.Subgroup using (isSubgroup ; Subgroup)
-- see NaturalMachine/PathIsSymmetry.agda: this name is v0.9-only in cubical
-- (v0.5 spells it Symmetric-Group), so it is defined there once instead
open import PathIsSymmetry using (SymGroup)

open import DefectCalculus using (Stab ; stab-id ; stab-âˆ˜ ; stab-inv)

private
  variable
    â„“ : Level

module _ (Str : Type â„“ â†’ Type â„“) {A : Type â„“}
         (isSetA : isSet A) (isSetStrA : isSet (Str A)) (s : Str A) where

  private
    Aut : Group â„“
    Aut = SymGroup A isSetA

  -- (ii) made visible: `Stab` becomes a subSET only because `Str A` is
  -- a set.  This line is the whole content of the correction.
  StabP : â„™ âŸ¨ Aut âŸ©
  StabP g = Stab Str s g , isSetStrA _ _

  -- The three fields are `DefectCalculus`'s three lemmas, unchanged.
  -- `1g`, `_Â_`, `inv` of `SymGroup` reduce to `idEquiv`,
  -- `compEquiv`, `invEquiv`, so no bridging lemma is needed either.
  isSubgroupStab : isSubgroup Aut StabP
  isSubgroup.id-closed  isSubgroupStab       = stab-id Str s
  isSubgroup.op-closed  isSubgroupStab sg sh = stab-âˆ˜ Str s _ _ sg sh
  isSubgroup.inv-closed isSubgroupStab sg    = stab-inv Str s _ sg

  -- T15.9, in the form Delta 15 states it.
  stabilizerSubgroup : Subgroup Aut
  stabilizerSubgroup = StabP , isSubgroupStab
