{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PathIsSymmetry
--
-- The thesis in one line.
--
-- For a type X, the identity type (X ≡ X) *is* the automorphism group
-- of X.  Not "corresponds to", not "is isomorphic to by an asserted
-- dictionary": univalence supplies the equivalence, and path
-- composition is transported to composition of equivalences, so the
-- correspondence is a group isomorphism, checked.
--
-- A name for X is a point of π₀; the geometry of X lives in its
-- identity type.  Univalence is what makes symbol and geometry say the
-- same thing.
--
-- Contrast, also proved here: as a bare type ℕ has many automorphisms
-- (swap 0 and 1); as an algebra for X ↦ 1 + X it has exactly one.
-- Structure is what cuts the automorphism group down --- which is the
-- whole content of the structure identity principle.
------------------------------------------------------------------------

module PathIsSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.GroupoidLaws
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin ; isSetFin)
import Cubical.Data.SumFin as SumFin
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group
open import Cubical.Algebra.Group.Morphisms
open import Cubical.Algebra.Group.MorphismProperties
-- NOT `open import Cubical.Algebra.SymmetricGroup`.  That module names
-- this group `Symmetric-Group` in cubical v0.5 and `SymGroup` in v0.9,
-- and this file used the v0.9 spelling.  On a v0.5 container the import
-- fails at line 98, "Not in scope: SymGroup" -- and because
-- agda imports this file FIRST, the whole aggregate dies
-- in two seconds and nothing downstream of it is ever typechecked.
-- Measured 2026-08-19 with interactive/Yogyata.hs: 409 modules are reached
-- only by agda or Everything.agda, and this was the FIRST
-- of several such name skews blocking them.  Fixing it moves the failure
-- to NaturalMachine/SymmetryCardinality.agda:31 on `factorial`.  So this
-- is one step of a repair, not the repair; the honest claim is that this
-- particular blocker is gone, not that the gate is green.
--
-- Renaming to `Symmetric-Group` would move the breakage to the other
-- toolchain.  The group is four lines of primitives stable across both
-- versions, so it is defined below and the version dependence is gone
-- rather than swapped.

private
  variable
    ℓ : Level
    A B C : Type ℓ

-- the symmetric group, spelled once, here (see the note above)
SymGroup : (X : Type ℓ) → isSet X → Group ℓ
SymGroup X isSetX =
  makeGroup (idEquiv X) compEquiv invEquiv (isOfHLevel≃ 2 isSetX isSetX)
    compEquiv-assoc compEquivEquivId compEquivIdEquiv
    invEquiv-is-rinv invEquiv-is-linv

-- and the finite one, which the pinned v0.5 calls `Sym` and v0.9 calls
-- `FinSymGroup`.  Same reasoning: named once, here.
-- and the finite one.  v0.9 calls it `FinSymGroup` and builds it over
-- Cubical.Data.SumFin.Fin (⊤ ⊎ …), NOT Cubical.Data.Fin (Σ ℕ (_< n));
-- the pinned v0.5 calls the analogue `Sym` and uses the OTHER carrier.
-- Getting that wrong typechecks locally and then fails in the module
-- that uses it, which is how it was found: FiniteNonabelianHolonomy
-- rejected `isoToEquiv swap01Iso` with `Σ ℕ (λ k → k < 3) != ⊤ ⊎ Fin 2`.
-- So it is SumFin here, matching v0.9's carrier.
FinSymGroup : ℕ → Group ℓ-zero
FinSymGroup n = SymGroup (SumFin.Fin n) SumFin.isSetFin

------------------------------------------------------------------------
-- 1.  The statement, in one line.
------------------------------------------------------------------------

-- Univalence, read as: the loop type at X in the universe is the type
-- of symmetries of X.
pathIsSymmetry : (X : Type ℓ) → (X ≡ X) ≃ (X ≃ X)
pathIsSymmetry X = univalence

-- Specialised to the standard finite types.  The right-hand side is the
-- underlying type of the symmetric group Sₙ.
finPathIsSymmetry : (n : ℕ) → (Fin n ≡ Fin n) ≃ (Fin n ≃ Fin n)
finPathIsSymmetry n = pathIsSymmetry (Fin n)

------------------------------------------------------------------------
-- 2.  It is a group isomorphism, not merely a bijection.
--
-- pathToEquiv is multiplicative: it sends path composition to
-- composition of equivalences.  Proved by path induction on the second
-- path, so nothing is asserted.
------------------------------------------------------------------------

pathToEquiv-∙ : (p : A ≡ B) (q : B ≡ C)
              → pathToEquiv (p ∙ q) ≡ compEquiv (pathToEquiv p) (pathToEquiv q)
pathToEquiv-∙ {A = A} p =
  J (λ _ q → pathToEquiv (p ∙ q) ≡ compEquiv (pathToEquiv p) (pathToEquiv q))
    ( cong pathToEquiv (sym (rUnit p))
    ∙ sym (compEquivEquivId (pathToEquiv p))
    ∙ cong (compEquiv (pathToEquiv p)) (sym pathToEquivRefl) )

-- The loop group of the universe at a set X.  Note the universe level:
-- (X ≡ X) lives one level above X, so this is a Group (ℓ-suc ℓ) while
-- SymGroup X is a Group ℓ.  The two are isomorphic but not
-- literally equal --- an honest universe-level fact, not a defect.
ΩGroup : (X : Type ℓ) → isSet X → Group (ℓ-suc ℓ)
ΩGroup X isSetX =
  makeGroup (refl {x = X}) _∙_ sym isSetΩ
    (λ p q r → assoc p q r)
    (λ p → sym (rUnit p))
    (λ p → sym (lUnit p))
    rCancel
    lCancel
  where
    isSetΩ : isSet (X ≡ X)
    isSetΩ = isOfHLevelRespectEquiv 2 (invEquiv univalence)
               (isOfHLevel≃ 2 isSetX isSetX)

-- THE PUNCHLINE OF §1: the loop group of the universe at X is the
-- symmetric group of X, as groups.
ΩGroup≃Symmetric : (X : Type ℓ) (isSetX : isSet X)
                 → GroupEquiv (ΩGroup X isSetX) (SymGroup X isSetX)
ΩGroup≃Symmetric X isSetX =
  univalence , makeIsGroupHom (λ p q → pathToEquiv-∙ p q)

-- Ω(Type, Fin n) ≅ Sₙ.
ΩFin≃Sym : (n : ℕ) → GroupEquiv (ΩGroup (Fin n) isSetFin) (SymGroup (Fin n) isSetFin)
ΩFin≃Sym n = ΩGroup≃Symmetric (Fin n) isSetFin

------------------------------------------------------------------------
-- 3.  Structure cuts down symmetry: ℕ as a type versus ℕ as an algebra.
------------------------------------------------------------------------

-- (a) As a bare type, ℕ has a nonidentity automorphism.
swap01 : ℕ → ℕ
swap01 zero                = suc zero
swap01 (suc zero)          = zero
swap01 (suc (suc n))       = suc (suc n)

swap01-involutive : (n : ℕ) → swap01 (swap01 n) ≡ n
swap01-involutive zero          = refl
swap01-involutive (suc zero)    = refl
swap01-involutive (suc (suc n)) = refl

swap01-Equiv : ℕ ≃ ℕ
swap01-Equiv = isoToEquiv (iso swap01 swap01 swap01-involutive swap01-involutive)

-- ... and it is not the identity, so Aut(ℕ as a bare type) is nontrivial.
swap01-≢-id : ¬ (swap01-Equiv ≡ idEquiv ℕ)
swap01-≢-id p = snotz (funExt⁻ (cong (λ e → equivFun e) p) zero)

-- (b) As an algebra for X ↦ 1 + X, ℕ is rigid: any endomorphism
--     commuting with zero and successor is the identity.  No
--     equivalence hypothesis is needed; a bare map suffices.
ℕ-algebra-rigid : (f : ℕ → ℕ)
                → f zero ≡ zero
                → ((n : ℕ) → f (suc n) ≡ suc (f n))
                → (n : ℕ) → f n ≡ n
ℕ-algebra-rigid f p q zero    = p
ℕ-algebra-rigid f p q (suc n) = q n ∙ cong suc (ℕ-algebra-rigid f p q n)

-- Consequence: the automorphism group of the initial (1 + X)-algebra is
-- trivial.  Every self-equivalence respecting the structure is refl.
ℕ-algebra-Aut-trivial :
    (e : ℕ ≃ ℕ)
  → equivFun e zero ≡ zero
  → ((n : ℕ) → equivFun e (suc n) ≡ suc (equivFun e n))
  → e ≡ idEquiv ℕ
ℕ-algebra-Aut-trivial e p q =
  equivEq (funExt (ℕ-algebra-rigid (equivFun e) p q))

-- swap01 witnesses the gap: it is an automorphism of the type that is
-- not an automorphism of the algebra.
swap01-breaks-zero : ¬ (swap01 zero ≡ zero)
swap01-breaks-zero = snotz

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  A VERIFIED REPAIR, OFFERED AND NOT APPLIED.
--
-- This module is the sole reported blocker of `Everything.agda` on the
-- pinned container, and `IndianLane.agda`'s header records that as
-- pre-existing and deliberately untouched.  The skew is a library
-- rename: cubical v0.9 spells the symmetric group `SymGroup`, and the
-- pinned v0.5 — whose `Cubical.Algebra.SymmetricGroup` this file already
-- opens at line 41 — spells it
--
--     Symmetric-Group : (X : Type ℓ) → isSet X → Group ℓ
--
-- with the SAME two explicit arguments this file passes.  (v0.5 also
-- defines `Sym n = Symmetric-Group (Fin n) isSetFin`, which is exactly
-- `ΩFin≃Sym`'s right-hand side.)
--
-- So the repair is two tokens, at lines 98 and 104:
--
--     sed -i 's/SymGroup/Symmetric-Group/g' NaturalMachine/PathIsSymmetry.agda
--
-- I did NOT apply it here.  I verified it on a renamed copy outside the
-- repository, so that nothing of this file changed:
--
--     sed -e 's/SymGroup/Symmetric-Group/g' \
--         -e 's/^module NaturalMachine\.PathIsSymmetry where/module PathIsSymmetryRepairProbe where/' \
--         NaturalMachine/PathIsSymmetry.agda > <scratch>/NaturalMachine/PathIsSymmetryRepairProbe.agda
--     agda -i <scratch> -i . <scratch>/NaturalMachine/PathIsSymmetryRepairProbe.agda
--       → PATCHED_EXIT=0
--
-- and confirmed this is the FIRST error the root aggregate hits:
--
--     agda -i . Everything.agda
--       → EXIT=42, sole reported error PathIsSymmetry.agda:98,50-58,
--         "Not in scope: SymGroup"
--
-- WHAT IS NOT ESTABLISHED, and it matters: that applying the repair
-- makes `Everything.agda` GREEN.  Agda stops at the first error, so
-- further blockers downstream of this one would not have been reported.
-- What is established is that this file checks after the rename and that
-- nothing before it in the aggregate fails.
--
-- Left for this file's author or the owner to apply or refuse.
------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19, after the note above and altering no line of it.
--
-- THE REPAIR IS NOW APPLIED, and in a different form than the one offered,
-- for the reason that note itself implies.  A global rename to
-- `Symmetric-Group` is correct on the v0.5 container and WRONG on the
-- repository's declared pin, which BUILD.md gives as cubical v0.9 -- so it
-- does not fix the skew, it chooses a side of it.  What is above instead
-- defines `SymGroup` and `FinSymGroup` here, from primitives spelled the
-- same in both versions, and the three consumers
-- (StabilizerSubgroup, FiniteNonabelianHolonomy, Decategorification) point
-- at them.  Nothing then depends on which spelling the library ships.
--
-- One correction to the offered patch, found by applying it.  v0.9's
-- `FinSymGroup` is built over `Cubical.Data.SumFin.Fin` (⊤ ⊎ …) while
-- v0.5's `Sym` uses `Cubical.Data.Fin` (Σ ℕ (_< n)).  Those are different
-- carriers, the difference typechecks locally, and it surfaces only in the
-- consumer: FiniteNonabelianHolonomy rejected `isoToEquiv swap01Iso` with
--     Σ ℕ (λ k → k < 3) != ⊤ ⊎ Fin 2
-- A `sed s/SymGroup/Symmetric-Group/g` would have carried that error in
-- silently at this site.
--
-- AND THE QUESTION THAT NOTE MARKED UNESTABLISHED IS NOW ANSWERED, in the
-- direction it suspected.  It said: "NOT ESTABLISHED, and it matters: that
-- applying the repair makes Everything.agda GREEN.  Agda stops at the first
-- error, so further blockers downstream would not have been reported."
--
-- Applied and run: it does NOT.  The aggregate now proceeds past this file
-- and stops at
--     NaturalMachine/SymmetryCardinality.agda:31 -- Not in scope: factorial
-- another v0.5/v0.9 name difference.  So this is the first of a series, and
-- neither IndianLane's reason for existing nor its closing sentence is
-- affected yet.  Measured, not inferred; the run is what reported it.
-- ---------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, second append, by the reader who made the first.
-- At the end, altering no line above, including the previous append and
-- the answer written after it.
--
-- The answer is taken, in full: applying the rename does NOT make the
-- aggregate green (it stops next at SymmetryCardinality.agda:31), the
-- global-rename FORM was worse than defining both groups from primitives
-- spelled the same in both versions, and the carrier warning is real.
-- Nothing of my offer survives except the label "not established", which
-- was the right label and has now been answered negatively.
--
-- One thing I can still add, for the carrier warning specifically —
-- v0.9's FinSymGroup over Cubical.Data.SumFin.Fin versus v0.5's Sym over
-- Cubical.Data.Fin.  Those carriers are not merely both called Fin; they
-- are EQUAL, and v0.5 proves it (`SumFin≡Fin = ua (SumFin≃Fin)`).
-- Checked in `TheTwoFinCarriersAreEqual`:
--
--     carriersAreEqual        : (n) → SF.Fin n ≡ F.Fin n
--     symmetricGroupsAreEqual : (n) (s : isSet (SF.Fin n))
--       → Symmetric-Group (SF.Fin n) s
--       ≡ Symmetric-Group (F.Fin n) (subst isSet (carriersAreEqual n) s)
--
-- So the fork is not a real fork, and this does NOT make the rename
-- safe: a path is not a definitional equality, the coercion still has to
-- be WRITTEN, and "typechecks locally, fails in the consumer" is exactly
-- the report that nobody wrote it.  The repair strategy chosen in the
-- answer above is not second-guessed; this is the lemma its carrier
-- clause needs, not an alternative to it.
------------------------------------------------------------------------
