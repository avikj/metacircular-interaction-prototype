-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- IntegerHullMultiplicity
--
-- THE INTEGER HULL OF THE MULTIPLICITY PROGRAM  (rescue of collab/FAILURES.md F25)
--
-- F25 asserted, on the evidence of `code/exp61_integer_hull_check.py`
-- (Python, banned 2026-08-13, unreplayable), that the two convex
-- relaxations used by the August-2026 critical-line manuscript,
--
--     m² ≥ 2m − 1      (Montgomery's integrality step)
--     m² ≥ 3m − 2      (the CGG98 refinement),
--
-- are not lossy: at the band-1 ceiling S = (4/3)N the exact integer
-- optima of "minimize the number of simple atoms" and "minimize the
-- number of distinct atoms" over positive-integer multiplicity vectors
-- are exactly (2/3)N and (5/6)N, i.e. exactly the two relaxations'
-- values.  The Python checked five values of N by search.  This module
-- proves the statement for ALL N and ALL S, with no search.
--
-- THE OBJECT.  A configuration is a finite list of multiplicities
-- m₁ … m_k, each ≥ 1.  It is encoded here as a `List ℕ` whose entry `x`
-- MEANS the multiplicity `suc x`; positivity is then structural, not a
-- side condition.  For a configuration `ms`:
--
--     N  ms = Σ mᵢ            (zeros counted with multiplicity)
--     SQ ms = Σ mᵢ²           (the band-limited second moment)
--     K  ms = k               (distinct atoms)
--     ones ms = #{i : mᵢ = 1} (simple atoms)
--
-- THE MECHANISM, and the reason no search is needed.  Substituting
-- mᵢ = 1 + xᵢ turns both bounds into a single per-element fact each:
--
--     N  = K + X,      SQ = K + 2X + Q,      X = Σxᵢ,  Q = Σxᵢ² ,
--
--   so   3N ≤ SQ + 2K   ⟺   X ≤ Q   ⟺   xᵢ ≤ xᵢ²          (§4)
--   and  2N ≤ SQ + s    ⟺   K ≤ Q + s ⟺  1 ≤ xᵢ² + [xᵢ=0]  (§4)
--
-- with s = ones.  That is the whole content of "m² ≥ 3m − 2" and
-- "m² ≥ 2m − 1": they are `x ≤ x²` and `1 ≤ x² + [x=0]` in disguise,
-- and both are equalities exactly on xᵢ ∈ {0,1}, i.e. mᵢ ∈ {1,2}.
--
-- THE HULL.  Hence a single configuration saturates BOTH bounds at
-- once: `hull t` = (4t copies of m=1) ++ (t copies of m=2), for which
--
--     N = 6t,   SQ = 8t   (so 3·SQ = 4·N: exactly the band-1 ceiling),
--     K = 5t = (5/6)N,    ones = 4t = (2/3)N.
--
-- Sections §5–§7 prove those four counts for every t, and §7 concludes
-- that no feasible configuration does better.  So the optima are the
-- relaxations' values, for every t, not merely at N ∈ {12,18,24,30,36}.
--
-- WHAT IS NOT CLAIMED.  This is a statement about an integer program.
-- It says nothing about zeta zeros, and nothing about the step F25
-- itself identified as the genuinely lossy one — the von Neumann
-- transplant from multiplicities to matrix eigenvalues.  See
-- `notes/F25_F23_WITHOUT_PYTHON.md` §2.
--
-- Idiom copied from `NaturalMachine/SieveFiber.agda` and
-- `Gamma0Freeness.agda` (solver-assisted commutative rearrangement,
-- everything else by structural induction).  Note that
-- `Cubical.Tactics.NatSolver` in cubical v0.5 cannot see through `suc`
-- or numerals (it files them as opaque constants), so every solver call
-- below is on a goal in variables only; the numerals are handled by
-- `·-distribˡ`/`·-assoc`/`·-comm` and by definitional reduction.
------------------------------------------------------------------------

module IntegerHullMultiplicity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- §1  Configurations
--
-- Entry `x` means multiplicity `suc x`.  Positivity is structural.
------------------------------------------------------------------------

Config : Type
Config = List ℕ

-- distinct atoms
K : Config → ℕ
K []       = 0
K (_ ∷ xs) = suc (K xs)

-- Σ xᵢ  (total excess above simplicity)
Xs : Config → ℕ
Xs []       = 0
Xs (x ∷ xs) = x + Xs xs

-- Σ xᵢ²
Qs : Config → ℕ
Qs []       = 0
Qs (x ∷ xs) = x · x + Qs xs

-- [x = 0]
onesElt : ℕ → ℕ
onesElt zero    = 1
onesElt (suc _) = 0

-- simple atoms
ones : Config → ℕ
ones []       = 0
ones (x ∷ xs) = onesElt x + ones xs

-- Σ mᵢ
N : Config → ℕ
N []       = 0
N (x ∷ xs) = suc x + N xs

-- Σ mᵢ²
SQ : Config → ℕ
SQ []       = 0
SQ (x ∷ xs) = suc x · suc x + SQ xs

------------------------------------------------------------------------
-- §2  Pure-`+` rearrangements
--
-- Variables only: this is all the v0.5 NatSolver will accept.
------------------------------------------------------------------------

private
  swap3 : (a b c : ℕ) → a + (b + c) ≡ b + (a + c)
  swap3 _ _ _ = solveℕ!

  sqRearr : (a s k q e : ℕ)
          → (a + a + s) + ((k + (e + e)) + q)
          ≡ (k + ((a + e) + (a + e))) + (s + q)
  sqRearr _ _ _ _ _ = solveℕ!

  midSwap : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
  midSwap _ _ _ _ = solveℕ!

  tripleSplit : (k x : ℕ)
              → (k + x) + ((k + x) + (k + x))
              ≡ (k + (k + k)) + (x + (x + x))
  tripleSplit _ _ = solveℕ!

  sqPlus2K : (k x q : ℕ)
           → ((k + (x + x)) + q) + (k + k)
           ≡ (k + (k + k)) + (x + (x + q))
  sqPlus2K _ _ _ = solveℕ!

  doubleSplit : (k x : ℕ) → (k + x) + (k + x) ≡ (k + k) + (x + x)
  doubleSplit _ _ = solveℕ!

  sqPlusOnes : (k x q s : ℕ)
             → ((k + (x + x)) + q) + s ≡ (k + (q + s)) + (x + x)
  sqPlusOnes _ _ _ _ = solveℕ!

private
  ≡≤ : {a b c : ℕ} → a ≡ b → b ≤ c → a ≤ c
  ≡≤ {c = c} p q = subst (_≤ c) (sym p) q

  ≤≡ : {a b c : ℕ} → a ≤ b → b ≡ c → a ≤ c
  ≤≡ {a = a} q p = subst (a ≤_) p q

------------------------------------------------------------------------
-- §3  The reparametrisation  m = 1 + x
--
-- N = K + X   and   SQ = K + 2X + Q.  These two identities are where
-- the squares go; everything afterwards is linear.
------------------------------------------------------------------------

decompN : (ms : Config) → N ms ≡ K ms + Xs ms
decompN []       = refl
decompN (x ∷ xs) =
  cong (suc x +_) (decompN xs) ∙ cong suc (swap3 x (K xs) (Xs xs))

-- (1+x)² = 1 + 2x + x², written so that both sides reduce.
sqSuc : (x : ℕ) → suc x · suc x ≡ suc (x + x + x · x)
sqSuc x = cong (suc x +_) (·-suc x x) ∙ cong suc (+-assoc x x (x · x))

decompSQ : (ms : Config) → SQ ms ≡ (K ms + (Xs ms + Xs ms)) + Qs ms
decompSQ []       = refl
decompSQ (x ∷ xs) =
  cong (_+ SQ xs) (sqSuc x)
  ∙ cong suc ( cong ((x + x + x · x) +_) (decompSQ xs)
             ∙ sqRearr x (x · x) (K xs) (Qs xs) (Xs xs) )

------------------------------------------------------------------------
-- §4  The two per-element facts — the entire arithmetic content
--
--   x ≤ x²             is  m² ≥ 3m − 2  (the CGG98 refinement)
--   1 ≤ x² + [x = 0]   is  m² ≥ 2m − 1  (Montgomery's integrality step)
--
-- Both are equalities exactly at x ∈ {0,1}, i.e. m ∈ {1,2}: that is why
-- one configuration saturates both, and why there is no room left.
------------------------------------------------------------------------

x≤x² : (x : ℕ) → x ≤ x · x
x≤x² zero    = ≤-refl
x≤x² (suc y) = y · suc y , +-comm (y · suc y) (suc y)

one≤ : (x : ℕ) → 1 ≤ x · x + onesElt x
one≤ zero    = ≤-refl
one≤ (suc y) =
  subst (λ z → 1 ≤ z) (sym (+-zero (suc y · suc y))) (suc-≤-suc zero-≤)

X≤Q : (ms : Config) → Xs ms ≤ Qs ms
X≤Q []       = ≤-refl
X≤Q (x ∷ xs) = ≤-+-≤ (x≤x² x) (X≤Q xs)

K≤Q+ones : (ms : Config) → K ms ≤ Qs ms + ones ms
K≤Q+ones []       = ≤-refl
K≤Q+ones (x ∷ xs) =
  ≤≡ (≤-+-≤ (one≤ x) (K≤Q+ones xs))
     (midSwap (x · x) (onesElt x) (Qs xs) (ones xs))

------------------------------------------------------------------------
-- §5  THE TWO BOUNDS, for every configuration and every ceiling S
--
--   3N ≤ S + 2K        (distinct atoms)
--   2N ≤ S + #simple   (simple atoms)
--
-- Stated additively so that no truncated subtraction appears anywhere.
------------------------------------------------------------------------

distinctBound : (ms : Config) (S : ℕ) → SQ ms ≤ S
              → N ms + (N ms + N ms) ≤ S + (K ms + K ms)
distinctBound ms S h =
  ≡≤ ( cong (λ z → z + (z + z)) (decompN ms)
     ∙ tripleSplit (K ms) (Xs ms) )
     (≤-trans
       (≤-k+ {k = K ms + (K ms + K ms)}
         (≤-k+ {k = Xs ms} (≤-k+ {k = Xs ms} (X≤Q ms))))
       (≡≤ (sym ( cong (_+ (K ms + K ms)) (decompSQ ms)
                ∙ sqPlus2K (K ms) (Xs ms) (Qs ms) ))
           (≤-+k {k = K ms + K ms} h)))

simpleBound : (ms : Config) (S : ℕ) → SQ ms ≤ S
            → N ms + N ms ≤ S + ones ms
simpleBound ms S h =
  ≡≤ ( cong (λ z → z + z) (decompN ms) ∙ doubleSplit (K ms) (Xs ms) )
     (≤-trans
       (≤-+k {k = Xs ms + Xs ms} (≤-k+ {k = K ms} (K≤Q+ones ms)))
       (≡≤ (sym ( cong (_+ ones ms) (decompSQ ms)
                ∙ sqPlusOnes (K ms) (Xs ms) (Qs ms) (ones ms) ))
           (≤-+k {k = ones ms} h)))

------------------------------------------------------------------------
-- §6  The saturating configuration
--
--   hull t  =  4t atoms of multiplicity 1,  t atoms of multiplicity 2.
--
-- Every count is exact, for every t, by a one-line induction: the block
-- (0,0,0,0,1) contributes +6 to N, +8 to SQ, +5 to K and +4 to ones,
-- and `c + z` reduces to sucᶜ z on the nose.
------------------------------------------------------------------------

hull : ℕ → Config
hull zero    = []
hull (suc t) = 0 ∷ 0 ∷ 0 ∷ 0 ∷ 1 ∷ hull t

hullN : (t : ℕ) → N (hull t) ≡ t · 6
hullN zero    = refl
hullN (suc t) = cong (6 +_) (hullN t)

hullSQ : (t : ℕ) → SQ (hull t) ≡ t · 8
hullSQ zero    = refl
hullSQ (suc t) = cong (8 +_) (hullSQ t)

hullK : (t : ℕ) → K (hull t) ≡ t · 5
hullK zero    = refl
hullK (suc t) = cong (5 +_) (hullK t)

hullOnes : (t : ℕ) → ones (hull t) ≡ t · 4
hullOnes zero    = refl
hullOnes (suc t) = cong (4 +_) (hullOnes t)

-- `hull t` sits exactly ON the band-1 ceiling S = (4/3)N, i.e. 3S = 4N.
hullCeiling : (t : ℕ) → 3 · SQ (hull t) ≡ 4 · N (hull t)
hullCeiling t =
    cong (3 ·_) (hullSQ t)
  ∙ ·-assoc 3 t 8 ∙ ·-comm (3 · t) 8 ∙ ·-assoc 8 3 t
  ∙ sym (·-assoc 6 4 t) ∙ sym (·-comm (4 · t) 6) ∙ sym (·-assoc 4 t 6)
  ∙ cong (4 ·_) (sym (hullN t))

------------------------------------------------------------------------
-- §7  THE INTEGER HULL
--
-- At the band-1 ceiling (N = 6t, S = 8t) the two bounds read
-- K ≥ 5t = (5/6)N and #simple ≥ 4t = (2/3)N, and `hull t` attains both.
-- So (5/6) and (2/3) ARE the exact integer optima — the relaxations are
-- the hull, and there is no room.
------------------------------------------------------------------------

private
  -- a + a ≤ b + b → a ≤ b.  Needed once, to halve the distinct bound.
  halve : (a b : ℕ) → a + a ≤ b + b → a ≤ b
  halve a b h with splitℕ-≤ a b
  ... | inl p = p
  ... | inr q = ⊥.rec (<-asym (<-+-< q q) h)

  -- t·6 + (t·6 + t·6) ≡ t·8 + (t·5 + t·5)   — 18t = 8t + 10t
  three6 : (t : ℕ) → t · 6 + (t · 6 + t · 6) ≡ t · 8 + (t · 5 + t · 5)
  three6 t =
      cong (t · 6 +_) (·-distribˡ t 6 6) ∙ ·-distribˡ t 6 12
    ∙ sym (cong (t · 8 +_) (·-distribˡ t 5 5) ∙ ·-distribˡ t 8 10)

  -- t·6 + t·6 ≡ t·8 + t·4   — 12t = 8t + 4t
  two6 : (t : ℕ) → t · 6 + t · 6 ≡ t · 8 + t · 4
  two6 t = ·-distribˡ t 6 6 ∙ sym (·-distribˡ t 8 4)

-- Any feasible configuration at the band-1 ceiling has at least
-- (5/6)N distinct atoms.
distinctOptimal : (t : ℕ) (ms : Config)
                → N ms ≡ t · 6 → SQ ms ≤ t · 8
                → t · 5 ≤ K ms
distinctOptimal t ms hN hS =
  halve (t · 5) (K ms)
    (≤-k+-cancel {k = t · 8}
      (≡≤ (sym (three6 t))
          (≡≤ (sym (cong (λ z → z + (z + z)) hN))
              (distinctBound ms (t · 8) hS))))

-- …and at least (2/3)N simple atoms.
simpleOptimal : (t : ℕ) (ms : Config)
              → N ms ≡ t · 6 → SQ ms ≤ t · 8
              → t · 4 ≤ ones ms
simpleOptimal t ms hN hS =
  ≤-k+-cancel
    (≡≤ (sym (two6 t))
        (≡≤ (sym (cong (λ z → z + z) hN))
            (simpleBound ms (t · 8) hS)))

-- Both optima are attained, simultaneously, by one configuration.
hullAttains : (t : ℕ)
            → ((N (hull t) ≡ t · 6) × (SQ (hull t) ≤ t · 8))
            × ((K (hull t) ≡ t · 5) × (ones (hull t) ≡ t · 4))
hullAttains t = (hullN t , ≡≤ (hullSQ t) ≤-refl) , (hullK t , hullOnes t)

------------------------------------------------------------------------
-- §8  Controls
--
-- (a) No feasible configuration beats the hull, in either functional.
-- (b) Cauchy–Schwarz alone is strictly weaker: at N = 12, S = 16 it
--     gives only N²/S = 9, and 9 is NOT attainable — the integer hull
--     is 10.  So integrality is genuinely being used, and used
--     optimally.  (This is the t = 2 row of the table the retired
--     `code/exp61_integer_hull_check.py` printed.)
------------------------------------------------------------------------

noBetterDistinct : (t : ℕ)
                 → ¬ (Σ[ ms ∈ Config ]
                        ((N ms ≡ t · 6) × ((SQ ms ≤ t · 8) × (K ms < t · 5))))
noBetterDistinct t (ms , hN , hS , hK) =
  <-asym hK (distinctOptimal t ms hN hS)

noBetterSimple : (t : ℕ)
               → ¬ (Σ[ ms ∈ Config ]
                      ((N ms ≡ t · 6) × ((SQ ms ≤ t · 8) × (ones ms < t · 4))))
noBetterSimple t (ms , hN , hS , hO) =
  <-asym hO (simpleOptimal t ms hN hS)

cauchySchwarzNotAttained :
  ¬ (Σ[ ms ∈ Config ] ((N ms ≡ 12) × ((SQ ms ≤ 16) × (K ms ≡ 9))))
cauchySchwarzNotAttained (ms , hN , hS , hK) =
  <-asym {9} {10} ≤-refl (≤≡ (distinctOptimal 2 ms hN hS) hK)

-- …and 10 IS attained, by `hull 2` = eight 1s and two 2s.
integerHullAt12 : (N (hull 2) ≡ 12) × ((SQ (hull 2) ≡ 16) × (K (hull 2) ≡ 10))
integerHullAt12 = refl , refl , refl

-- the simple-atom half of the same row: 8 = (2/3)·12.
simpleHullAt12 : ones (hull 2) ≡ 8
simpleHullAt12 = refl
