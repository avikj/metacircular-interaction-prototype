{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DSOCutCalibration
--
-- The executable calibration of Delta 28
-- (notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md §62), as checked
-- terms.  The delta's "attached demo" cannot exist here (Python is
-- banned), so the demo IS this module — kernel facts, not stdout.
--
-- Three §62 claims are certified on concrete finite instances:
--
-- 1. TROPICAL FEEDBACK CLOSURE (Thm 28.3 instance).  A four-vertex
--    min-plus system with boundary {b₀,b₁} and hidden {h₂,h₃}: the
--    Kleene-closed boundary relation A ⊕ P D* Q equals ((0,5),(6,0)).
--
-- 2. ELIMINATION-ORDER INVARIANCE (Thm 28.2/28.4 instance).  Schur
--    elimination of the hidden vertices in order (h₂,h₃) and (h₃,h₂)
--    both reproduce the same boundary matrix — the closure above.
--    (Nonnegative costs, no self-loops, so the per-vertex star is 0
--    and one Schur step per vertex is exact.)
--
-- 3. STRICT INTERFACE HIERARCHY r_e < d_e < |X_Se| (Thm 28.7/§24).
--    The Boolean cut matrix with rows (1,0),(0,1),(1,1),(1,1):
--      * raw separator states  = 4;
--      * deterministic continuation classes (distinct rows) = 3,
--        certified by kernel count;
--      * an EXACT 2-rectangle cover exists (upper bound r_e ≤ 2),
--        certified entrywise;
--      * NO single sound rectangle covers both diagonal 1-entries
--        (fooling pair r₁,r₂), so r_e ≥ 2 — proved, not enumerated:
--        a rectangle through (r₁,c₁) and (r₂,c₂) must contain
--        (r₁,c₂), where the matrix is 0.
--    Hence r_e = 2 < d_e = 3 < 4 = raw: nondeterministic latent
--    interfaces strictly beat deterministic quotients strictly beat
--    raw separators, exactly as Delta 28 §18/§24 states.
--
-- General Theorems 28.1–28.14 are inherited semiring/min-plus algebra
-- (the delta's own ledger claims no novelty); what this module adds is
-- that the calibration instances are now kernel-checked and --safe.
------------------------------------------------------------------------

module DSOCutCalibration where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_)
open import Agda.Builtin.Nat using (_<_)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_; _or_; not)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The tropical (min-plus) carrier

data Trop : Type where
  fin : ℕ → Trop
  inf : Trop

_⊕_ : Trop → Trop → Trop
inf   ⊕ y     = y
fin m ⊕ inf   = fin m
fin m ⊕ fin n = fin (if m < n then m else n)

_⊗_ : Trop → Trop → Trop
inf   ⊗ _     = inf
fin m ⊗ inf   = inf
fin m ⊗ fin n = fin (m + n)

infixr 6 _⊕_
infixr 7 _⊗_

------------------------------------------------------------------------
-- 1+2.  The four-vertex feedback system

data V4 : Type where
  b₀ b₁ h₂ h₃ : V4

-- block form T = (A P ; Q D): A = I on the boundary, P enters the
-- hidden sector, D evolves it, Q returns
T : V4 → V4 → Trop
T b₀ b₀ = fin 0
T b₁ b₁ = fin 0
T b₀ h₂ = fin 1      -- P
T b₁ h₃ = fin 3      -- P
T h₂ h₃ = fin 2      -- D
T h₃ h₂ = fin 1      -- D
T h₂ b₀ = fin 2      -- Q
T h₃ b₁ = fin 2      -- Q
T _  _  = inf

-- D* on the hidden block: I ⊕ D ⊕ D² (exact for two hidden vertices
-- with nonnegative costs and no self-loops)
dstar : V4 → V4 → Trop
dstar h₂ h₂ = fin 0 ⊕ (T h₂ h₃ ⊗ T h₃ h₂)
dstar h₃ h₃ = fin 0 ⊕ (T h₃ h₂ ⊗ T h₂ h₃)
dstar h₂ h₃ = T h₂ h₃
dstar h₃ h₂ = T h₃ h₂
dstar _  _  = inf

-- the feedback trace  A ⊕ P D* Q, expanded over both hidden modes
closure : V4 → V4 → Trop
closure i j =
  T i j ⊕ (T i h₂ ⊗ dstar h₂ h₂ ⊗ T h₂ j)
        ⊕ (T i h₂ ⊗ dstar h₂ h₃ ⊗ T h₃ j)
        ⊕ (T i h₃ ⊗ dstar h₃ h₂ ⊗ T h₂ j)
        ⊕ (T i h₃ ⊗ dstar h₃ h₃ ⊗ T h₃ j)

-- §62: the closed boundary matrix is ((0,5),(6,0))
closure-00 : closure b₀ b₀ ≡ fin 0
closure-00 = refl

closure-01 : closure b₀ b₁ ≡ fin 5
closure-01 = refl

closure-10 : closure b₁ b₀ ≡ fin 6
closure-10 = refl

closure-11 : closure b₁ b₁ ≡ fin 0
closure-11 = refl

-- Schur elimination of one hidden vertex (star at v is 0: no
-- self-loops, nonnegative costs)
elim : V4 → (V4 → V4 → Trop) → (V4 → V4 → Trop)
elim v W i j = W i j ⊕ (W i v ⊗ W v j)

elim₂₃ : V4 → V4 → Trop
elim₂₃ = elim h₃ (elim h₂ T)

elim₃₂ : V4 → V4 → Trop
elim₃₂ = elim h₂ (elim h₃ T)

-- §62: both elimination orders reproduce the closure on the boundary
order-23-00 : elim₂₃ b₀ b₀ ≡ closure b₀ b₀
order-23-00 = refl

order-23-01 : elim₂₃ b₀ b₁ ≡ closure b₀ b₁
order-23-01 = refl

order-23-10 : elim₂₃ b₁ b₀ ≡ closure b₁ b₀
order-23-10 = refl

order-23-11 : elim₂₃ b₁ b₁ ≡ closure b₁ b₁
order-23-11 = refl

order-32-00 : elim₃₂ b₀ b₀ ≡ closure b₀ b₀
order-32-00 = refl

order-32-01 : elim₃₂ b₀ b₁ ≡ closure b₀ b₁
order-32-01 = refl

order-32-10 : elim₃₂ b₁ b₀ ≡ closure b₁ b₀
order-32-10 = refl

order-32-11 : elim₃₂ b₁ b₁ ≡ closure b₁ b₁
order-32-11 = refl

------------------------------------------------------------------------
-- 3.  The strict interface hierarchy 2 < 3 < 4

data R4 : Type where
  r₁ r₂ r₃ r₄ : R4

data C2 : Type where
  c₁ c₂ : C2

-- the cut matrix with rows (1,0), (0,1), (1,1), (1,1)
K : R4 → C2 → Bool
K r₁ c₁ = true
K r₁ c₂ = false
K r₂ c₁ = false
K r₂ c₂ = true
K r₃ _  = true
K r₄ _  = true

-- raw separator states: 4 (the carrier R4) — trivially

-- deterministic continuation classes: distinct rows, counted by first
-- occurrence in the enumeration r₁ r₂ r₃ r₄
rowEq : R4 → R4 → Bool
rowEq r r' =
  (if K r c₁ then K r' c₁ else not (K r' c₁)) and
  (if K r c₂ then K r' c₂ else not (K r' c₂))

distinctRows : ℕ
distinctRows =
  1 + (if rowEq r₂ r₁ then 0 else 1)
    + (if rowEq r₃ r₁ or rowEq r₃ r₂ then 0 else 1)
    + (if rowEq r₄ r₁ or rowEq r₄ r₂ or rowEq r₄ r₃ then 0 else 1)

deterministicClasses : distinctRows ≡ 3
deterministicClasses = refl

-- upper bound: an exact 2-rectangle (2-latent-mode) cover of K
inRowA inRowB : R4 → Bool
inRowA r₁ = true
inRowA r₂ = false
inRowA r₃ = true
inRowA r₄ = true
inRowB r₁ = false
inRowB r₂ = true
inRowB r₃ = true
inRowB r₄ = true

inColA inColB : C2 → Bool
inColA c₁ = true
inColA c₂ = false
inColB c₁ = false
inColB c₂ = true

cover : R4 → C2 → Bool
cover r c = (inRowA r and inColA c) or (inRowB r and inColB c)

coverCheck : R4 → C2 → Bool
coverCheck r c = if K r c then cover r c else not (cover r c)

coverExact : ((coverCheck r₁ c₁ and coverCheck r₁ c₂) and
              (coverCheck r₂ c₁ and coverCheck r₂ c₂) and
              (coverCheck r₃ c₁ and coverCheck r₃ c₂) and
              (coverCheck r₄ c₁ and coverCheck r₄ c₂)) ≡ true
coverExact = refl

-- lower bound: no single sound rectangle covers both diagonal
-- 1-entries — the fooling pair.  Proved for ALL rectangles, not
-- enumerated: soundness at (r₁,c₂) is violated.
private
  and-true-l : (x y : Bool) → (x and y) ≡ true → x ≡ true
  and-true-l true  y p = refl
  and-true-l false y p = p

  and-true-r : (x y : Bool) → (x and y) ≡ true → y ≡ true
  and-true-r true  y p = p
  and-true-r false true  p = refl
  and-true-r false false p = p

  true≢false' : ¬ true ≡ false
  true≢false' p = subst (λ b → if b then Bool else ⊥) p true

oneRectangleImpossible :
  (ρ : R4 → Bool) (γ : C2 → Bool)
  → ((r : R4) (c : C2) → (ρ r and γ c) ≡ true → K r c ≡ true)
  → (ρ r₁ and γ c₁) ≡ true
  → (ρ r₂ and γ c₂) ≡ true
  → ⊥
oneRectangleImpossible ρ γ sound p q =
  true≢false' (sym (sound r₁ c₂ off) )
  where
  off : (ρ r₁ and γ c₂) ≡ true
  off = cong₂ _and_ (and-true-l (ρ r₁) (γ c₁) p)
                    (and-true-r (ρ r₂) (γ c₂) q)

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- The lower-bound argument this header states — "a rectangle through
-- (r₁,c₁) and (r₂,c₂) must contain (r₁,c₂), where the matrix is 0" — is
-- carrier-free, and is now a term for arbitrary row and column types in
-- `NaturalMachine.AFoolingPairForcesTwoRectangles`:
--
--   foolingPairNotInOneRectangle :
--     (r₁ r₂ : Row) (c₁ c₂ : Col) → M r₁ c₂ ≡ false
--     → (rect : Rect) → Sound rect
--     → ¬ (Covers rect r₁ c₁ × Covers rect r₂ c₂)
--
-- One thing that surfaced in making it a term, and it sharpens the
-- method rather than this instance: the proof uses NEITHER 1-entry.  It
-- needs only `R r₁`, `C c₂`, and the 0 at the exchanged corner.  The two
-- 1-entries are what make a pair worth CHOOSING as a fooling pair; they
-- are not what makes the argument run.
--
-- NOT claimed there: that r_e = 2 for this matrix — the matching UPPER
-- bound is this module's exhibited 2-rectangle cover, certified
-- entrywise, and that module constructs no cover.  Nor anything about
-- d_e, raw width, the min-plus closure, the two elimination orders, or
-- Delta 28 §18/§24.  Nor a general k-fooling-set bound: "at least two"
-- from a PAIR is all that is proved.
------------------------------------------------------------------------
