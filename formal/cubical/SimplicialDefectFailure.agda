{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- SimplicialDefectFailure
--
-- Machine-checked content of notes/OBSTRUCTION_COEND_REPAIR.md §3:
-- the defect family σ ↦ δ_σ of a charted Chu space is a functor on the
-- DEGENERACY half of the simplex category and on no more.  The prose
-- proof is not redone here; this module is its finite kernel-checked
-- shadow.
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  1. holonomy-dup      Prop. 2, degeneracy invariance, BY EQUALITY.
--     defect-dup        s_j preserves the first and the last vertex and
--                       inserts one factor ρ_{i_j i_j} = e, so
--                       𝔥_{s_j σ} ≡ 𝔥_σ and hence δ_{s_j σ} ≡ δ_σ.
--                       Unconditional on ρ: the only law used is a
--                       RIGHT UNIT for the composition.  No inverses,
--                       no associativity, no cocycle condition, no
--                       hypothesis on X, 𝒯 or Q.
--
--  2. faces-fail-covariantly     Prop. 3, the single counterexample, in
--     faces-fail-contravariantly which BOTH variances fail at once, on
--                       the same face operator d₀ at adjacent
--                       dimensions.  X = {a,b}, |𝒯| = 1, I = {0,1,2,3},
--                       ρ₁₃ = ρ₃₁ = sw and every other ρ = id.  The
--                       holonomies are computed by the kernel (refl);
--                       the two failures of inclusion are decided, not
--                       asserted.  Exhaustive as a negative because
--                       Q_α = (𝒫(X), ⊆) is a POSET: a morphism exists
--                       iff the inclusion holds, so "no inclusion" IS
--                       "no functorial relation" (note §1).
--
--  3. cocycle⇒trivial   Prop. 4, the sharp form, forward direction:
--     cocycle⇒defect-const  a cocycle ρ forces 𝔥_σ ≡ e for every σ and
--     cocycle⇒faces-act     hence δ constant, hence functorial along
--                       every face in both variances.  The CONVERSE
--                       (functoriality along faces ⇒ ρ a cocycle) is
--                       NOT formalized, because the note does not claim
--                       it either (§6.4 leaves the intermediate
--                       classification unattempted).
--
-- THE TWO READINGS OF THE HOLONOMY (note §0.3) — load-bearing for this
-- encoding.  D0016 §B reads 𝔥_σ = ρ_{i₀iₙ} ρ_{i_{n-1}iₙ} ⋯ ρ_{i₀i₁},
-- with NO inverse on the long edge; SHRINKING_TESTS_LOWER_CURVATURE.md
-- Def. 1.4 reads 𝔥_σ = ρ_{i₀iₙ}⁻¹ ρ_{i_{n-1}iₙ} ⋯ ρ_{i₀i₁}, and only
-- the latter is the descent obstruction.  This module is AGNOSTIC
-- between them, deliberately, in two separate ways:
--
--   * §1 abstracts the long-edge factor as an arbitrary `cap : G → G`.
--     Both readings are instances (cap = idfun, cap = inverse), and the
--     degeneracy theorem is proved once for all caps.
--   * §2's counterexample lives in Aut(X) ≅ ℤ/2, encoded as (Bool, _⊕_),
--     where g⁻¹ = g, so the two formulas literally coincide.  The
--     instance below takes cap = idfun, and `cap-irrelevant-in-ℤ/2`
--     records that any cap whatsoever with cap false ≡ false and
--     cap true ≡ true — in particular both readings — gives the same
--     numbers.
--
-- §3 is the one place where the readings differ, and the module says so
-- in its hypothesis rather than hiding it: Prop. 4 is proved under
-- `cap-inv : ∀ g → cap g · g ≡ e`, which holds for the corpus reading
-- and fails for the archive one.
--
-- Companion prose: notes/OBSTRUCTION_COEND_REPAIR.md §§0.3, 1, 3.
------------------------------------------------------------------------

module SimplicialDefectFailure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _⊕_ ; ⊕-identityʳ)
open import Cubical.Data.Bool using (false≢true)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat
  using (snotz ; injSuc ; inj-+m ; m+n≡0→m≡0×n≡0 ; +-zero)
  renaming (_+_ to _+ℕ_ ; +-comm to +ℕ-comm)
open import Cubical.Data.Int
  using (ℤ ; pos ; _+_ ; -_ ; _-_ ; injPos ; pos+ ; pos0+ ; plusMinus
        ; -Cancel ; -Cancel' ; +Assoc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- §0.  Simplices of the indiscrete (Čech) nerve
--
-- N_n = I^{n+1}, note §1.  An n-simplex is a NON-EMPTY list of
-- vertices, encoded as a head together with a tail, so that "first
-- vertex" is total.  The face and degeneracy operators are the ones of
-- note §1:
--   d_j (i₀,…,iₙ) = (i₀,…,î_j,…,iₙ)      s_j (i₀,…,iₙ) = (i₀,…,i_j,i_j,…,iₙ)
------------------------------------------------------------------------

record Simplex (I : Type ℓ) : Type ℓ where
  constructor _◂_
  field
    head : I
    tail : List I

open Simplex public

infixr 5 _◂_

module _ {I : Type ℓ} where

  -- last vertex iₙ
  lastL : I → List I → I
  lastL i []       = i
  lastL i (x ∷ xs) = lastL x xs

  lastV : Simplex I → I
  lastV (i ◂ t) = lastL i t

  -- s_j, as a duplication of the j-th vertex.  For j > n it is the
  -- identity; the theorem below is then vacuously true there, and for
  -- 0 ≤ j ≤ n it is exactly s_j.
  dupL : ℕ → List I → List I
  dupL j       []       = []
  dupL zero    (x ∷ xs) = x ∷ x ∷ xs
  dupL (suc j) (x ∷ xs) = x ∷ dupL j xs

  degen : ℕ → Simplex I → Simplex I
  degen zero    (i ◂ t) = i ◂ (i ∷ t)
  degen (suc j) (i ◂ t) = i ◂ dupL j t

  -- d₀, the only face operator §3.2 needs.  On a 0-simplex it is the
  -- identity (there is no (-1)-simplex); the counterexample never uses
  -- that branch.
  face₀ : Simplex I → Simplex I
  face₀ (i ◂ [])      = i ◂ []
  face₀ (i ◂ (x ∷ t)) = x ◂ t

------------------------------------------------------------------------
-- §1.  Proposition 2 — degeneracy invariance, unconditional
--
-- Structure assumed: a composition with a RIGHT unit, a chart ρ with
-- ρ_{ii} = e, and an arbitrary long-edge cap.  That is all the proof of
-- note §3.1 uses, so that is all the module assumes.  In particular
-- neither associativity nor invertibility appears, and both readings of
-- 𝔥 are instances of `cap`.
------------------------------------------------------------------------

module Holonomy
  {I : Type ℓ} {G : Type ℓ'}
  (_·_ : G → G → G) (e : G)
  (·IdR : (g : G) → g · e ≡ g)
  (ρ : I → I → G)
  (ρ-refl : (i : I) → ρ i i ≡ e)
  (cap : G → G)
  where

  -- consecutive-edge product ρ_{i_{n-1}iₙ} ⋯ ρ_{i₀i₁}
  pathL : I → List I → G
  pathL i []       = e
  pathL i (x ∷ xs) = pathL x xs · ρ i x

  -- 𝔥_σ = cap(ρ_{i₀iₙ}) · (consecutive-edge product)
  𝔥 : Simplex I → G
  𝔥 σ = cap (ρ (head σ) (lastV σ)) · pathL (head σ) (tail σ)

  -- The last vertex is untouched by a degeneracy.
  lastL-dup : (j : ℕ) (i : I) (t : List I) → lastL i (dupL j t) ≡ lastL i t
  lastL-dup j       i []       = refl
  lastL-dup zero    i (x ∷ xs) = refl
  lastL-dup (suc j) i (x ∷ xs) = lastL-dup j x xs

  -- The consecutive-edge product is untouched: one factor ρ_{i_j i_j}
  -- = e is inserted, and a right unit absorbs it.
  pathL-dup : (j : ℕ) (i : I) (t : List I) → pathL i (dupL j t) ≡ pathL i t
  pathL-dup j       i []       = refl
  pathL-dup zero    i (x ∷ xs) =
    cong (λ g → (pathL x xs · g) · ρ i x) (ρ-refl x)
      ∙ cong (_· ρ i x) (·IdR (pathL x xs))
  pathL-dup (suc j) i (x ∷ xs) = cong (_· ρ i x) (pathL-dup j x xs)

  -- The j = 0 branch of `degen` prepends the head to itself.
  lastL-head : (i : I) (t : List I) → lastL i (i ∷ t) ≡ lastL i t
  lastL-head i t = refl

  pathL-head : (i : I) (t : List I) → pathL i (i ∷ t) ≡ pathL i t
  pathL-head i t = cong (pathL i t ·_) (ρ-refl i) ∙ ·IdR (pathL i t)

  -- PROPOSITION 2.  𝔥_{s_j σ} ≡ 𝔥_σ, for every j and every σ.
  holonomy-dup : (j : ℕ) (σ : Simplex I) → 𝔥 (degen j σ) ≡ 𝔥 σ
  holonomy-dup zero (i ◂ t) =
    cong (cap (ρ i (lastL i t)) ·_) (pathL-head i t)
  holonomy-dup (suc j) (i ◂ t) =
    cong₂ (λ a b → cap (ρ i a) · b) (lastL-dup j i t) (pathL-dup j i t)

  -- COROLLARY.  δ is a function of 𝔥 and S alone (note Def. 1.5), so it
  -- inherits the equality for ANY defect assignment whatsoever.
  module _ {D : Type ℓ'} (δ𝔥 : G → D) where

    δ : Simplex I → D
    δ σ = δ𝔥 (𝔥 σ)

    defect-dup : (j : ℕ) (σ : Simplex I) → δ (degen j σ) ≡ δ σ
    defect-dup j σ = cong δ𝔥 (holonomy-dup j σ)

------------------------------------------------------------------------
-- §2.  Proposition 3 — the face counterexample
--
-- X = {a,b} = Bool; Aut(X) ≅ ℤ/2 written additively as (Bool, _⊕_, false)
-- with id = false, sw = true.  𝒯 = S = {t}, e(a,t) = 0, e(b,t) = 1, so
-- ∼_S is equality and
--        δ_σ = X  if 𝔥_σ = sw,        δ_σ = ∅  if 𝔥_σ = id.
-- Subsets of X are their characteristic functions X → Bool; A ⊆ B is
-- the (unique, if it exists) morphism of the poset Q_α = (𝒫(X), ⊆).
------------------------------------------------------------------------

data Idx : Type₀ where
  ⟨0⟩ ⟨1⟩ ⟨2⟩ ⟨3⟩ : Idx

-- ρ₁₃ = ρ₃₁ = sw, every other ρ_{ij} = id (including every ρ_{ii}).
ρX : Idx → Idx → Bool
ρX ⟨1⟩ ⟨3⟩ = true
ρX ⟨3⟩ ⟨1⟩ = true
ρX _   _   = false

ρX-refl : (i : Idx) → ρX i i ≡ false
ρX-refl ⟨0⟩ = refl
ρX-refl ⟨1⟩ = refl
ρX-refl ⟨2⟩ = refl
ρX-refl ⟨3⟩ = refl

-- ℤ/2 has g⁻¹ = g, so the archive reading (cap = id) and the corpus
-- reading (cap = inverse) are the SAME function here; cap = idfun below
-- is therefore not a choice between them.  `cap-irrelevant-in-ℤ/2`
-- makes that precise.
capX : Bool → Bool
capX b = b

cap-irrelevant-in-ℤ/2 : (c : Bool → Bool) → c false ≡ false → c true ≡ true
                      → (b : Bool) → c b ≡ capX b
cap-irrelevant-in-ℤ/2 c p q false = p
cap-irrelevant-in-ℤ/2 c p q true  = q

open Holonomy {I = Idx} _⊕_ false ⊕-identityʳ ρX ρX-refl capX
  renaming (𝔥 to 𝔥X ; pathL to pathX)

-- Subsets of X = Bool, and the poset structure of Q_α.
Psub : Type₀
Psub = Bool → Bool

∅ : Psub
∅ _ = false

full : Psub
full _ = true

_⊆_ : Psub → Psub → Type₀
A ⊆ B = (x : Bool) → A x ≡ true → B x ≡ true

infix 4 _⊆_

-- δ_σ = X when 𝔥_σ = sw, ∅ when 𝔥_σ = id.
δ𝔥X : Bool → Psub
δ𝔥X h _ = h

δX : Simplex Idx → Psub
δX σ = δ𝔥X (𝔥X σ)

-- The two simplices of note §3.2: σ = (0,1,2,3) and τ = (1,2,3) = d₀σ.
σ₃ : Simplex Idx
σ₃ = ⟨0⟩ ◂ (⟨1⟩ ∷ ⟨2⟩ ∷ ⟨3⟩ ∷ [])

τ₂ : Simplex Idx
τ₂ = ⟨1⟩ ◂ (⟨2⟩ ∷ ⟨3⟩ ∷ [])

-- d₀σ IS τ, on the nose.
d₀σ≡τ : face₀ σ₃ ≡ τ₂
d₀σ≡τ = refl

-- The holonomy table of note §3.2, decided by the kernel.
𝔥σ₃ : 𝔥X σ₃ ≡ false                         -- ρ₀₃+ρ₀₁+ρ₁₂+ρ₂₃ = 0
𝔥σ₃ = refl

𝔥τ₂ : 𝔥X τ₂ ≡ true                          -- ρ₁₃+ρ₁₂+ρ₂₃ = 1
𝔥τ₂ = refl

𝔥d₁σ : 𝔥X (⟨0⟩ ◂ (⟨2⟩ ∷ ⟨3⟩ ∷ [])) ≡ false   -- d₁σ = (0,2,3)
𝔥d₁σ = refl

𝔥d₂σ : 𝔥X (⟨0⟩ ◂ (⟨1⟩ ∷ ⟨3⟩ ∷ [])) ≡ true    -- d₂σ = (0,1,3)
𝔥d₂σ = refl

𝔥d₃σ : 𝔥X (⟨0⟩ ◂ (⟨1⟩ ∷ ⟨2⟩ ∷ [])) ≡ false   -- d₃σ = (0,1,2)
𝔥d₃σ = refl

𝔥d₀τ : 𝔥X (⟨2⟩ ◂ (⟨3⟩ ∷ [])) ≡ false         -- d₀τ = (2,3)
𝔥d₀τ = refl

𝔥d₁τ : 𝔥X (⟨1⟩ ◂ (⟨3⟩ ∷ [])) ≡ false         -- d₁τ = (1,3)
𝔥d₁τ = refl

𝔥d₂τ : 𝔥X (⟨1⟩ ◂ (⟨2⟩ ∷ [])) ≡ false         -- d₂τ = (1,2)
𝔥d₂τ = refl

-- Hence the defects: δ_σ = ∅, δ_τ = X, δ_{d₀τ} = ∅.
δσ₃ : δX σ₃ ≡ ∅
δσ₃ = refl

δτ₂ : δX τ₂ ≡ full
δτ₂ = refl

δd₀τ : δX (face₀ τ₂) ≡ ∅
δd₀τ = refl

-- The single inclusion failure that both directions reduce to.
full⊄∅ : ¬ (full ⊆ ∅)
full⊄∅ p = false≢true (p false refl)

-- CONTRAVARIANT (cosimplicial) DIRECTION FAILS, at σ:
--   a cosimplicial structure would give δ_{d₀σ} ⊆ δ_σ, i.e. X ⊆ ∅.
faces-fail-contravariantly : ¬ (δX (face₀ σ₃) ⊆ δX σ₃)
faces-fail-contravariantly = full⊄∅

-- COVARIANT (simplicial) DIRECTION FAILS, at τ, same operator d₀:
--   a simplicial structure would give δ_τ ⊆ δ_{d₀τ}, i.e. X ⊆ ∅.
faces-fail-covariantly : ¬ (δX τ₂ ⊆ δX (face₀ τ₂))
faces-fail-covariantly = full⊄∅

-- PROPOSITION 3, assembled: one charted Chu space, both failures, the
-- same face operator, adjacent dimensions.  Since Q_α is a poset, this
-- is exhaustive: it is not "no map was found" but "no map exists".
Proposition3 : (¬ (δX (face₀ σ₃) ⊆ δX σ₃)) × (¬ (δX τ₂ ⊆ δX (face₀ τ₂)))
Proposition3 = faces-fail-contravariantly , faces-fail-covariantly

-- Degeneracy invariance holds here too, as it must (§1 is unconditional).
degeneracy-still-acts : (j : ℕ) (σ : Simplex Idx) → δX (degen j σ) ≡ δX σ
degeneracy-still-acts j σ = cong δ𝔥X (holonomy-dup j σ)

------------------------------------------------------------------------
-- §3.  Proposition 4 — the sharp form, forward direction
--
-- If ρ is a cocycle then 𝔥 ≡ e and δ is constant, hence functorial
-- along every face in both variances — the case in which the apparatus
-- has nothing to measure.
--
-- HYPOTHESIS `cap-inv`.  This is the one statement in the module that
-- distinguishes the two readings of §0.3, and it is exposed as a
-- hypothesis rather than baked in: cap g · g ≡ e holds for the corpus
-- reading (cap = inverse, Def. 1.4) and FAILS for the archive reading
-- (cap = idfun, D0016 §B), where a 1-simplex has 𝔥 = ρ_{i₀i₁}² which a
-- cocycle does not make trivial — exactly the discrepancy the note
-- reports at §0.3 and declines to resolve.
------------------------------------------------------------------------

module Sharp
  {I : Type ℓ} {G : Type ℓ'}
  (_·_ : G → G → G) (e : G)
  (·IdR : (g : G) → g · e ≡ g)
  (ρ : I → I → G)
  (ρ-refl : (i : I) → ρ i i ≡ e)
  (cap : G → G)
  (cap-inv : (g : G) → cap g · g ≡ e)
  (cocycle : (i j k : I) → ρ j k · ρ i j ≡ ρ i k)
  where

  open Holonomy _·_ e ·IdR ρ ρ-refl cap

  -- Under the cocycle condition the consecutive-edge product collapses
  -- to the direct edge.
  path-collapse : (i : I) (t : List I) → pathL i t ≡ ρ i (lastL i t)
  path-collapse i []       = sym (ρ-refl i)
  path-collapse i (x ∷ xs) =
    cong (_· ρ i x) (path-collapse x xs) ∙ cocycle i x (lastL x xs)

  -- PROPOSITION 4.  𝔥_σ ≡ e for every σ.
  cocycle⇒trivial : (σ : Simplex I) → 𝔥 σ ≡ e
  cocycle⇒trivial (i ◂ t) =
    cong (cap (ρ i (lastL i t)) ·_) (path-collapse i t) ∙ cap-inv (ρ i (lastL i t))

  module _ {D : Type ℓ'} (δ𝔥 : G → D) where

    -- δ is the constant family at δ𝔥 e …
    cocycle⇒defect-const : (σ : Simplex I) → δ𝔥 (𝔥 σ) ≡ δ𝔥 e
    cocycle⇒defect-const σ = cong δ𝔥 (cocycle⇒trivial σ)

    -- … hence functorial along every operator whatsoever, faces
    -- included, in both variances: any two values are EQUAL.
    cocycle⇒faces-act : (σ τ : Simplex I) → δ𝔥 (𝔥 σ) ≡ δ𝔥 (𝔥 τ)
    cocycle⇒faces-act σ τ = cocycle⇒defect-const σ ∙ sym (cocycle⇒defect-const τ)

-- REMAINING WORK, stated plainly.  The converse of §3 — that
-- functoriality of δ along faces FORCES ρ to be a cocycle — is not
-- formalized here, and is not proved in the note either: §3.2's closing
-- paragraph asserts the slogan, Prop. 4 gives one direction, Prop. 3
-- refutes simpliciality for one non-cocycle ρ, and note §6.4 records
-- the intermediate classification as unattempted.  So "δ is functorial
-- along faces exactly when δ is zero" is, at the present state of the
-- mathematics, one implication plus a counterexample, and that is what
-- is checked above.
