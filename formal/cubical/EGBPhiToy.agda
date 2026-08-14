{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EGBPhiToy : one finite cycle of the achromatic-reflection operator Φ
--
-- Delta 24 §19.C ("Formalize a finite Φ toy") transcribed to Cubical
-- Agda.  Three finite presentations, one TRUE equivalence, one weaker
-- RELATION, one FALSE proposed equivalence with an explicit separator,
-- univalent completion, gluing, retained defect, one reflection step.
--
-- *** STATUS: UNCHECKED IN THIS SESSION. ***
--
-- The environment this file was written in has NO agda/lean toolchain
-- (`command -v agda` fails; `run` skips the formal lane).  Therefore:
--
--   * this module is NOT in `run`'s checked build list, and no claim
--     that it type-checks is made anywhere;
--   * it is a KERNEL OBLIGATION, in the exact spirit of the corpus's
--     own out-of-build control `NaturalMachine/Control/WrongEquivalence.agda`
--     (that one is excluded because it MUST fail; this one because it
--     CANNOT be run here);
--   * library-lemma names below (esp. the Fin-cardinality separator)
--     are written against cubical stdlib from memory and MAY need
--     adjustment against the installed version.  Making them check IS
--     the obligation.  Genuine obligations are marked with `?`.
--
-- The MATHEMATICS is finite and hand-verified in
-- `formal/EGB_DELTA24_LAWVERE_AND_PHI_TOY.md` §3; this file is the
-- transcription, not the proof of correctness.
------------------------------------------------------------------------

module EGBPhiToy where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.FinData using (Fin ; zero ; suc)
open import Cubical.Data.Nat using (ℕ ; suc ; zero) renaming (suc to sucℕ ; zero to zeroℕ)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1. Three native presentations (Delta 24 §19.C.1)
------------------------------------------------------------------------

G₁ : Type
G₁ = Bool

G₂ : Type
G₂ = Fin 2

G₃ : Type
G₃ = Fin 3

------------------------------------------------------------------------
-- 2. One TRUE equivalence  e₁₂ : Bool ≃ Fin 2   (Delta 24 §19.C.2)
--    false ↦ 0 , true ↦ 1.  Both round trips by exhaustion on 2 points.
------------------------------------------------------------------------

to₁₂ : G₁ → G₂
to₁₂ false = zero
to₁₂ true  = suc zero

from₁₂ : G₂ → G₁
from₁₂ zero            = false
from₁₂ (suc zero)      = true
from₁₂ (suc (suc ()))            -- Fin 0 is empty

sec₁₂ : (i : G₂) → to₁₂ (from₁₂ i) ≡ i
sec₁₂ zero            = refl
sec₁₂ (suc zero)      = refl
sec₁₂ (suc (suc ()))

ret₁₂ : (b : G₁) → from₁₂ (to₁₂ b) ≡ b
ret₁₂ false = refl
ret₁₂ true  = refl

e₁₂ : G₁ ≃ G₂
e₁₂ = isoToEquiv (iso to₁₂ from₁₂ sec₁₂ ret₁₂)

------------------------------------------------------------------------
-- 5. Univalent (Rezk) completion of the proved equivalence
--    (Delta 24 §19.C.5).  Proved equivalence ⇒ identity ⇒ transport.
--    This is the `Digits.agda`/`Transport.agda` move on a 2-element type.
------------------------------------------------------------------------

G₁≡G₂ : G₁ ≡ G₂
G₁≡G₂ = ua e₁₂

-- The involution `not` on Bool transported to its image on Fin 2.
-- (`subst (λ X → X → X) G₁≡G₂ not` is the flip 0 ↔ 1 on Fin 2.)
flip₂ : G₂ → G₂
flip₂ = subst (λ X → (X → X)) G₁≡G₂ not

------------------------------------------------------------------------
-- 3. One WEAKER relation  R₂₃ : Fin 2 → Fin 3 → Type   (Delta 24 §19.C.3)
--    the graph of the inclusion ι : Fin 2 ↪ Fin 3.  A genuine
--    proof-relevant relation, NOT an equivalence.  Retained, not collapsed.
------------------------------------------------------------------------

ι : G₂ → G₃
ι zero            = zero
ι (suc zero)      = suc zero
ι (suc (suc ()))

R₂₃ : G₂ → G₃ → Type
R₂₃ i j = ι i ≡ j

------------------------------------------------------------------------
-- 6. Gluing of the relation (Delta 24 §19.C.6): the span/collage total
--    space, in which the relation is internalized without being declared
--    an identity.  (Artin gluing / logical-relations-as-types.)
------------------------------------------------------------------------

Collage₂₃ : Type
Collage₂₃ = Σ[ i ∈ G₂ ] Σ[ j ∈ G₃ ] R₂₃ i j

-- both ends are visible in the collage:
proj₂ : Collage₂₃ → G₂
proj₂ (i , _ , _) = i

proj₃ : Collage₂₃ → G₃
proj₃ (_ , j , _) = j

------------------------------------------------------------------------
-- 4. + 7.  The FALSE proposed equivalence and its retained separator
--          (Delta 24 §19.C.4, §19.C.7).
--
-- Proposing G₂ ≃ G₃ is false: an equivalence Fin m ≃ Fin n forces m ≡ n,
-- and ¬ (2 ≡ 2+1).  The separator (the cardinality gap) is KEPT as a term,
-- exactly as `Controls.no-raw-round-trip` keeps the leading-zero witness.
--
-- OBLIGATION: the cubical stdlib lemma "Fin m ≃ Fin n → m ≡ n" is used
-- here under a placeholder name; discharge it against the installed
-- library (e.g. via `Cubical.Data.FinData.Properties`).  Marked `?`.
------------------------------------------------------------------------

-- 2 ≢ 3 in ℕ.
2≢3 : ¬ (2 ≡ 3)
2≢3 p = ?          -- OBLIGATION: `snotz`/`¬ (suc² 0 ≡ suc³ 0)` — decidable

-- cardinality lemma (name approximate; the kernel obligation):
Fin≃→≡ : {m n : ℕ} → (Fin m ≃ Fin n) → (m ≡ n)
Fin≃→≡ e = ?       -- OBLIGATION: standard finite-cardinality fact

-- the separator: NO equivalence G₂ ≃ G₃.  This is the torn thread,
-- adjoined as an object rather than discarded.
separator₂₃ : ¬ (G₂ ≃ G₃)
separator₂₃ e = 2≢3 (Fin≃→≡ e)

------------------------------------------------------------------------
-- 8. One reflection step (Delta 24 §19.C.8): the cycle
--       G₁ ≃ G₂  —R₂₃→  G₃  ⇢  G₁
--    does NOT close to id — the G₂→G₃ leg is a non-invertible relation
--    and the return leg is a REFUTED equivalence (`separator₂₃`).  So the
--    "unity" of the cycle is not a single collapsed object; it is the
--    collage (§6) PLUS the retained defect (§7).  Presented one universe
--    up, that composite is S₂ = Φ(S₁).  The holonomy of the cycle is the
--    defect (Delta 24 T24.3/T24.4) in its smallest finite instance.
------------------------------------------------------------------------

record Stage : Type₁ where
  field
    carrier   : Type            -- the glued object
    defect    : Type            -- the retained torn thread (a proposition here)

-- Φ(S₁): the reflected stage bundles the collage with its defect.
S₂ : Stage
S₂ = record { carrier = Collage₂₃ ; defect = ¬ (G₂ ≃ G₃) }

-- and the defect is inhabited — the reflection genuinely carries the
-- separator, it did not average it away:
S₂-defect-inhabited : Stage.defect S₂
S₂-defect-inhabited = separator₂₃

------------------------------------------------------------------------
-- Reading:  Φ transports where equivalence is PROVED (G₁≡G₂, flip₂),
-- glues where only a RELATION holds (Collage₂₃), and retains the
-- SEPARATOR where equivalence is falsely claimed (separator₂₃) — so the
-- cycle's unity keeps its defect instead of collapsing.  Two `?` remain:
-- they are the kernel obligation this session cannot discharge, and they
-- are the ONLY thing between this file and a checked term.
------------------------------------------------------------------------
