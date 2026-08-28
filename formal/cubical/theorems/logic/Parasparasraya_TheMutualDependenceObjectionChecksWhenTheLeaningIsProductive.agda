{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परस्पराश्रय — अन्योन्याश्रितं चेत् प्रसूते, न दोषः ; गुप्तं चक्रं प्रमाणम् ।
--
-- (if the mutual leaning is productive, it is not a defect; the guarded
-- circle is the warrant.)
--
-- THE OBJECTION.  parasparāśraya — each of two things established only
-- through the other — is catalogued across the Nyāya and Jaina
-- literature as a defect of definition: the circle establishes nothing.
-- [Citation contract: the term and its defect-classification are the
-- tradition's; the primary-text loci are UNVERIFIED here and no theorem
-- below is attributed to any historical author.]
--
-- THE THEOREM.  The objection is answered by a criterion, not a
-- concession, and the criterion is the guardedness discipline of this
-- corpus's own kernel: a mutual pair whose leaning is PRODUCTIVE exists,
-- and the typechecker is the arbiter of which circles are vicious and
-- which are generative.  This file exhibits both faces of the resulting
-- notion — the INTERDEPENDENT TYPE — as one checked object:
--
--   FACE 1 (neither checks without the other).  Two streams defined in
--   one mutual block, each the tail of the other.  Delete either
--   definition and the other is a type error.  They are proved distinct,
--   and the circle closes BY REFL at depth two: the productivity
--   dividend, computed rather than argued.
--
--   FACE 2 (neither has the property, but together they do).  A record
--   packaging two observables, a named blind pair for each, and joint
--   faithfulness.  Inhabited at the smallest complete instance.  Two
--   theorems fall out of the record generically:
--     · dvitīya-paśyati — in ANY such pair, each sense provably
--       separates every blind pair of the other: interdependence forces
--       complementary vision (the ApurvaIndriyam admission gate, read
--       from the joint side);
--     · na-ekākin — neither observable can be discarded: a constant
--       second sense refutes the record.  The property genuinely lives
--       on the pair and provably not on either projection.
--
-- WHAT IS NOT CLAIMED.  No general theory of circular definition is
-- given; "productive" here means exactly what --guardedness accepts,
-- and the vicious circle is not represented in this file because a
-- --safe module cannot contain it — that refusal is the point, and the
-- unguarded control belongs to the must_fail lane, not here.
------------------------------------------------------------------------

module Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · FACE 1 — अन्योन्यजीवनम् : neither checks without the other
------------------------------------------------------------------------

record Dhārā (A : Type₀) : Type₀ where
  coinductive
  field
    śiras : A
    śeṣam : Dhārā A

open Dhārā

-- The mutual pair.  `śeṣam jina = ajina` and `śeṣam ajina = jina`:
-- each stream is defined THROUGH the other, and the block is accepted
-- because the leaning is guarded.  This is parasparāśraya as a
-- construction principle.
mutual
  jina : Dhārā Bool
  śiras jina = true
  śeṣam jina = ajina

  ajina : Dhārā Bool
  śiras ajina = false
  śeṣam ajina = jina

-- The two are distinct — the circle did not collapse its members.
jina≢ajina : jina ≡ ajina → ⊥
jina≢ajina p = true≢false (cong śiras p)

-- The productivity dividend: the circle closes by refl at depth two.
-- An unguarded circle would have nothing to compute here; this one
-- computes its own period.
dvicakram : śeṣam (śeṣam jina) ≡ jina
dvicakram = refl

dvicakram' : śeṣam (śeṣam ajina) ≡ ajina
dvicakram' = refl

------------------------------------------------------------------------
-- २ · FACE 2 — युग्मदृष्टिः : neither has the property, together they do
--
-- The record IS the interdependent type: two senses, a named blindness
-- for each (the two states, their distinctness, and the identification
-- the sense cannot avoid making), and joint faithfulness.
------------------------------------------------------------------------

record Parasparāśraya (X : Type ℓ) (O₁ : Type ℓ') (O₂ : Type ℓ'')
       : Type (ℓ-max ℓ (ℓ-max ℓ' ℓ'')) where
  field
    dṛś₁ : X → O₁
    dṛś₂ : X → O₂
    andha₁ : Σ[ x ∈ X ] Σ[ y ∈ X ] ((x ≡ y → ⊥) × (dṛś₁ x ≡ dṛś₁ y))
    andha₂ : Σ[ x ∈ X ] Σ[ y ∈ X ] ((x ≡ y → ⊥) × (dṛś₂ x ≡ dṛś₂ y))
    yugma  : (x y : X) → dṛś₁ x ≡ dṛś₁ y → dṛś₂ x ≡ dṛś₂ y → x ≡ y

  -- Interdependence forces complementary vision: each sense separates
  -- every blind pair of the other.  This is generic — no instance data
  -- is used — so it is a law of the notion, not of an example.
  dvitīya-paśyati : (x y : X) → (x ≡ y → ⊥)
                  → dṛś₁ x ≡ dṛś₁ y
                  → dṛś₂ x ≡ dṛś₂ y → ⊥
  dvitīya-paśyati x y x≢y p q = x≢y (yugma x y p q)

  prathama-paśyati : (x y : X) → (x ≡ y → ⊥)
                   → dṛś₂ x ≡ dṛś₂ y
                   → dṛś₁ x ≡ dṛś₁ y → ⊥
  prathama-paśyati x y x≢y q p = x≢y (yugma x y p q)

  -- Neither sense may be discarded: a constant replacement for either
  -- refutes the record through the other's blind pair.  The property
  -- (faithfulness) inhabits the PAIR and provably not the projection.
  na-ekākin₂ : ((x y : X) → dṛś₂ x ≡ dṛś₂ y) → ⊥
  na-ekākin₂ const =
    fst (snd (snd andha₁))
        (yugma (fst andha₁) (fst (snd andha₁))
               (snd (snd (snd andha₁)))
               (const (fst andha₁) (fst (snd andha₁))))

  na-ekākin₁ : ((x y : X) → dṛś₁ x ≡ dṛś₁ y) → ⊥
  na-ekākin₁ const =
    fst (snd (snd andha₂))
        (yugma (fst andha₂) (fst (snd andha₂))
               (const (fst andha₂) (fst (snd andha₂)))
               (snd (snd (snd andha₂))))

------------------------------------------------------------------------
-- ३ · The smallest complete instance, inhabited.
--
-- X = Bool × Bool, the senses are the two projections.  Each is blind
-- at a named pair (the blindness is refl; the distinctness is a
-- refutation through the OTHER coordinate — face 2's content in
-- miniature), and the joint reading is faithful by the pair path.
------------------------------------------------------------------------

yugmanetra : Parasparāśraya (Bool × Bool) Bool Bool
Parasparāśraya.dṛś₁ yugmanetra = fst
Parasparāśraya.dṛś₂ yugmanetra = snd
Parasparāśraya.andha₁ yugmanetra =
  (true , true) , (true , false)
  , (λ p → true≢false (cong snd p)) , refl
Parasparāśraya.andha₂ yugmanetra =
  (true , true) , (false , true)
  , (λ p → true≢false (cong fst p)) , refl
Parasparāśraya.yugma yugmanetra x y p q i = p i , q i

-- The generic laws, landed on the instance: the second projection
-- separates the first's named blind pair, and neither projection is
-- individually faithful.
snd-paśyati : Parasparāśraya.dṛś₂ yugmanetra (true , true)
            ≡ Parasparāśraya.dṛś₂ yugmanetra (true , false) → ⊥
snd-paśyati q =
  Parasparāśraya.dvitīya-paśyati yugmanetra
    (true , true) (true , false)
    (λ p → true≢false (cong snd p)) refl q

fst-not-faithful : ((x y : Bool × Bool) → fst x ≡ fst y → x ≡ y) → ⊥
fst-not-faithful faithful =
  true≢false (cong snd (faithful (true , true) (true , false) refl))
