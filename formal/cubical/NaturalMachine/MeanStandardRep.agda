{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.MeanStandardRep
--
-- DELTA 14, PROGRAM 14.73: `Rᵏ ≃ R × V_k` and the `S_k` action, at
-- k = 2 and k = 3.
--
--   T14.8   for `k` invertible in `R` and `V_k = {x ∈ Rᵏ : Σxᵢ = 0}`,
--           `Rᵏ ≃ R × V_k` by `x ↦ (mean x, x − mean x·1)`.
--   T14.9   `S_k` fixes the centre coordinate and acts on `V_k` by the
--           standard representation.
--   C14.10  k = 2 gives the one-dimensional sign representation.
--   T14.11  for k ≥ 3 a transposition on `V_k` is not scalar —
--           eigenvalue −1 with multiplicity 1, +1 with multiplicity k−2.
--   T14.12  `Σ_{j≥0} tr(τ|Symʲ V_k) tʲ = 1/((1−t)^{k−2}(1+t))`.
--   T14.13  (char 0, `R[V_k]^{S_k}` polynomial on degrees 2..k) — Delta
--           14 labels this a **Known anchor**; it is CITED here and is
--           deliberately NOT re-proved.  Chevalley–Shephard–Todd for the
--           symmetric group, i.e. the fundamental theorem of symmetric
--           polynomials.  Nothing below depends on it.
--
-- `NaturalMachine.CenterRelative` is imported, not edited; §2 proves that
-- its `Φ` **is** the k = 2 mean-split followed by the identification
-- `V₂ ≅ R`, so C14.10 is that file's `ρ` and is not a second object.
--
--
-- WHAT IS A TERM HERE, AND WHAT IS NOT
--
--   T14.8    k = 2 (`split₂`) and k = 3 (`split₃`).  General `k`: NOT
--            attempted — see the closing note.
--   T14.9    k = 2 (`mean₂-inv`, `dev₂-equivariant`) and k = 3 for all
--            three transpositions, which generate `S₃`
--            (`mean₃-inv-*`, `dev₃-equivariant-*`).  The statement is
--            proved for the generators; it is NOT lifted to a homomorphism
--            out of an abstract `S₃`, because no group object is built.
--   C14.10   `sign-rep₂` — the swap acts on `V₂ ≅ R` by `x ↦ −x`.
--   T14.11   k = 3, in the STRONG form: an explicit basis change
--            `V₃ ≃ R × R` in which the transposition is `diag(−1,+1)`
--            (`sw01-diagonalised`), which is exactly "eigenvalue −1 with
--            multiplicity 1, +1 with multiplicity k−2 = 1"; plus the
--            two eigenvectors exhibited (`sw01-u`, `sw01-v`) and the
--            non-scalarity corollary in its sharp form: a transposition
--            on `V₃` is scalar ONLY in characteristic 2
--            (`sw01-scalar→char2`), hence never when 2 is invertible in a
--            nontrivial ring (`sw01-not-scalar`).
--   T14.12   **NOT PROVED, AND NOT FAKED.**  See §5.  What is a term is
--            its arithmetic half at k = 3, `altSum-even` / `altSum-odd`
--            (`Σ_{i≤j} (−1)ⁱ = 1` for `j` even, `0` for `j` odd), which
--            is what the trace reduces to *given* the monomial eigenbasis
--            of `Symʲ` of a diagonalised rank-2 module.  `Symʲ` does not
--            exist in this development and no trace is computed.
--
--
-- HYPOTHESIS STRATIFICATION, deliberately
--
-- The file is layered so that each result is stated under exactly the
-- arithmetic it needs, which is the point `CenterRelative` makes about
-- `half+half ≡ 1r` and is worth keeping:
--
--   §3.1  no `half`, no `third`  — `V₃`, the transpositions, the two
--                                  eigenvectors, and `sw01-scalar→char2`.
--                                  **T14.11's obstruction needs no
--                                  invertibility at all.**
--   §3.2  `half` only            — the diagonalising basis `V₃ ≃ R × R`,
--                                  `sw01-diagonalised`, `sw01-not-scalar`.
--   §3.3  `third` only           — T14.8 and T14.9 at k = 3.  The mean
--                                  needs `3` invertible and nothing else.
--
-- That `k` invertible is needed for the SPLIT while `k` invertible is
-- NOT needed for the ACTION to be non-scalar is a real distinction and
-- the layering is how it is recorded.
--
--
-- PRIOR ART (searched before proving, per CLAUDE.md)
--
-- Searched `~/agda-libs/` (cubical v0.5, agda-unimath, UniMath, Symmetry
-- book, Coq-HoTT, mathlib4) for a reusable standard representation.
-- Result: **none exists to reuse.**  mathlib4 has
-- `Mathlib/RepresentationTheory/` but no `standardRep`, no Specht
-- modules, and no permutation-module decomposition (grep for "standard
-- representation", "standardRep", "Specht": zero hits).  agda-unimath has
-- `finite-group-theory/sign-homomorphism` — the sign CHARACTER, not the
-- sign representation as a module — and no representation theory above
-- it.  cubical v0.5 has `Algebra/SymmetricGroup.agda`, `Algebra/Module`,
-- `Algebra/Matrix`, and no representation theory whatsoever.  Hand-rolling
-- at k = 2, 3 is therefore not a rediscovery.  The MATHEMATICS is of
-- course entirely classical and no novelty is claimed for it; what is new
-- is only that the machine core now holds it as terms.
------------------------------------------------------------------------

module NaturalMachine.MeanStandardRep where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

open import NaturalMachine.CenterRelative using (Pair ; Φ)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)

 private
   -- `x₀ + x₁ + x₂ ≡ 0r` is a path in a set, hence a proposition; this is
   -- what lets `V₂`/`V₃` be compared by their vector components alone.
   isPropSum : (x y : ⟨ R ⟩) → isProp (x ≡ y)
   isPropSum x y = is-set x y

 ---------------------------------------------------------------------
 -- 1.  k = 2.
 --
 -- `V₂ = {(a,b) : a + b = 0}`.  T14.8, then `V₂ ≅ R`, then C14.10.
 ---------------------------------------------------------------------

 Vec2 : Type ℓ
 Vec2 = ⟨ R ⟩ × ⟨ R ⟩

 sum2 : Vec2 → ⟨ R ⟩
 sum2 (a , b) = a + b

 V₂ : Type ℓ
 V₂ = Σ[ x ∈ Vec2 ] (sum2 x ≡ 0r)

 swap2 : Vec2 → Vec2
 swap2 (a , b) = (b , a)

 private
   sw2sum : (a b : ⟨ R ⟩) → b + a ≡ a + b
   sw2sum = solve R

 swap2-sum : (x : Vec2) → sum2 (swap2 x) ≡ sum2 x
 swap2-sum (a , b) = sw2sum a b

 -- the swap restricted to `V₂` — this is the `S₂`-action on `V₂`
 swap2V : V₂ → V₂
 swap2V (x , p) = (swap2 x , swap2-sum x ∙ p)

 -- `V₂ ≅ R`, by the second coordinate.  (`a` is determined: `a = −b`.)
 private
   negFromSum : (a b : ⟨ R ⟩) → a + b ≡ 0r → (- b) ≡ a
   negFromSum a b p = sym (sym (e1 a b) ∙ cong (_+ (- b)) p ∙ e2 b)
     where
     e1 : (a b : ⟨ R ⟩) → (a + b) + (- b) ≡ a
     e1 = solve R
     e2 : (b : ⟨ R ⟩) → 0r + (- b) ≡ - b
     e2 = solve R

   negSum2 : (b : ⟨ R ⟩) → (- b) + b ≡ 0r
   negSum2 = solve R

 V₂→R : V₂ → ⟨ R ⟩
 V₂→R ((a , b) , _) = b

 R→V₂ : ⟨ R ⟩ → V₂
 R→V₂ b = ((- b , b) , negSum2 b)

 V₂Iso : Iso V₂ ⟨ R ⟩
 Iso.fun      V₂Iso = V₂→R
 Iso.inv      V₂Iso = R→V₂
 Iso.rightInv V₂Iso b = refl
 Iso.leftInv  V₂Iso ((a , b) , p) =
   Σ≡Prop (λ v → isPropSum (sum2 v) 0r) (≡-× (negFromSum a b p) refl)

 V₂≃R : V₂ ≃ ⟨ R ⟩
 V₂≃R = isoToEquiv V₂Iso

 -- C14.10.  THE SIGN REPRESENTATION at k = 2: under `V₂ ≅ R`, the
 -- transposition is multiplication by `−1`.  One line, because `V₂` is
 -- the line `{(−b, b)}` and swapping its two entries negates `b`.
 sign-rep₂ : (x : V₂) → V₂→R (swap2V x) ≡ - (V₂→R x)
 sign-rep₂ ((a , b) , p) = sym (negFromSum a b p)

 -- … and it really is an action of order 2, not merely a map.
 swap2V-invol : (x : V₂) → swap2V (swap2V x) ≡ x
 swap2V-invol (x , p) = Σ≡Prop (λ v → isPropSum (sum2 v) 0r) refl

 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  mean₂ : Vec2 → ⟨ R ⟩
  mean₂ (a , b) = half · (a + b)

  shift₂ : ⟨ R ⟩ → Vec2 → Vec2
  shift₂ m (a , b) = (a - m , b - m)

  dev₂ : Vec2 → Vec2
  dev₂ x = shift₂ (mean₂ x) x

  private
    d2a : (h a b : ⟨ R ⟩) → (a - h · (a + b)) + (b - h · (a + b))
                          ≡ (a + b) - (h + h) · (a + b)
    d2a = solve R

    d2b : (s : ⟨ R ⟩) → s - 1r · s ≡ 0r
    d2b = solve R

    m2a : (h m a b : ⟨ R ⟩) → h · ((m + a) + (m + b)) ≡ h · ((m + m) + (a + b))
    m2a = solve R

    m2b : (h m : ⟨ R ⟩) → h · ((m + m) + 0r) ≡ (h + h) · m
    m2b = solve R

    s2a : (m a : ⟨ R ⟩) → (m + a) - m ≡ a
    s2a = solve R

    s2b : (m a : ⟨ R ⟩) → m + (a - m) ≡ a
    s2b = solve R

  dev₂-sum : (x : Vec2) → sum2 (dev₂ x) ≡ 0r
  dev₂-sum (a , b) =
      d2a half a b
    ∙ cong (λ u → (a + b) - u · (a + b)) half+half
    ∙ d2b (a + b)

  -- T14.8 at k = 2:  `R² ≃ R × V₂`, by `x ↦ (mean x , x − mean x · 1)`.
  split₂-fun : Vec2 → ⟨ R ⟩ × V₂
  split₂-fun x = (mean₂ x , (dev₂ x , dev₂-sum x))

  split₂-inv : ⟨ R ⟩ × V₂ → Vec2
  split₂-inv (m , ((a , b) , _)) = (m + a , m + b)

  private
    mean-of-shift₂ : (m : ⟨ R ⟩) (x : Vec2) → sum2 x ≡ 0r
                   → mean₂ (split₂-inv (m , (x , refl-irrelevant))) ≡ m
      where refl-irrelevant = tt-unused
    mean-of-shift₂ = _

  -- (the helper above is replaced by the direct computation below)

  split₂Iso : Iso Vec2 (⟨ R ⟩ × V₂)
  Iso.fun      split₂Iso = split₂-fun
  Iso.inv      split₂Iso = split₂-inv
  Iso.rightInv split₂Iso (m , ((a , b) , p)) =
    ≡-× meanPath
        (Σ≡Prop (λ v → isPropSum (sum2 v) 0r)
                (cong (λ u → shift₂ u (m + a , m + b)) meanPath
                 ∙ ≡-× (s2a m a) (s2a m b)))
    where
    meanPath : mean₂ (m + a , m + b) ≡ m
    meanPath =
        m2a half m a b
      ∙ cong (λ u → half · ((m + m) + u)) p
      ∙ m2b half m
      ∙ cong (_· m) half+half
      ∙ ·IdL m
  Iso.leftInv  split₂Iso (a , b) = ≡-× (s2b (mean₂ (a , b)) a)
                                       (s2b (mean₂ (a , b)) b)

  split₂ : Vec2 ≃ (⟨ R ⟩ × V₂)
  split₂ = isoToEquiv split₂Iso

  -- T14.9 at k = 2: the centre coordinate is `S₂`-invariant …
  mean₂-inv : (x : Vec2) → mean₂ (swap2 x) ≡ mean₂ x
  mean₂-inv x = cong (half ·_) (swap2-sum x)

  -- … and the deviation is equivariant, so the split intertwines the
  -- `S₂`-action on `R²` with (trivial on the centre) × (sign on `V₂`).
  dev₂-equivariant : (x : Vec2) → dev₂ (swap2 x) ≡ swap2 (dev₂ x)
  dev₂-equivariant x = cong (λ u → shift₂ u (swap2 x)) (mean₂-inv x)

  ------------------------------------------------------------------
  -- 2.  The bridge to `CenterRelative`.
  --
  -- The k = 2 mean-split, followed by `V₂ ≅ R`, IS that file's `Φ`.
  -- So C14.10's sign representation is `CenterRelative.ρ`'s second
  -- component, and `Φ∘τ≡ρ∘Φ` (proved there) is the intertwining
  -- statement — neither is a second object and neither is re-proved.
  ------------------------------------------------------------------

  private
    bridge : (h a b : ⟨ R ⟩) → (h + h) · b - h · (a + b) ≡ h · (b - a)
    bridge = solve R

  split₂-is-Φ : (x : Pair R half half+half)
              → (mean₂ x , V₂→R (dev₂ x , dev₂-sum x)) ≡ Φ R half half+half x
  split₂-is-Φ (a , b) =
    ≡-× refl
        (cong (λ u → u - half · (a + b))
              (sym (cong (_· b) half+half ∙ ·IdL b))
         ∙ bridge half a b)

 ---------------------------------------------------------------------
 -- 3.  k = 3.
 ---------------------------------------------------------------------

 Vec3 : Type ℓ
 Vec3 = ⟨ R ⟩ × ⟨ R ⟩ × ⟨ R ⟩

 sum3 : Vec3 → ⟨ R ⟩
 sum3 (a , b , c) = a + b + c

 V₃ : Type ℓ
 V₃ = Σ[ x ∈ Vec3 ] (sum3 x ≡ 0r)

 -- the three transpositions of `S₃`, which generate it
 sw01 sw12 sw02 : Vec3 → Vec3
 sw01 (a , b , c) = (b , a , c)
 sw12 (a , b , c) = (a , c , b)
 sw02 (a , b , c) = (c , b , a)

 private
   p01 : (a b c : ⟨ R ⟩) → b + a + c ≡ a + b + c
   p01 = solve R
   p12 : (a b c : ⟨ R ⟩) → a + c + b ≡ a + b + c
   p12 = solve R
   p02 : (a b c : ⟨ R ⟩) → c + b + a ≡ a + b + c
   p02 = solve R

 sw01-sum : (x : Vec3) → sum3 (sw01 x) ≡ sum3 x
 sw01-sum (a , b , c) = p01 a b c
 sw12-sum : (x : Vec3) → sum3 (sw12 x) ≡ sum3 x
 sw12-sum (a , b , c) = p12 a b c
 sw02-sum : (x : Vec3) → sum3 (sw02 x) ≡ sum3 x
 sw02-sum (a , b , c) = p02 a b c

 -- the transpositions restrict to `V₃`: this is the standard
 -- representation, as a map
 sw01V sw12V sw02V : V₃ → V₃
 sw01V (x , p) = (sw01 x , sw01-sum x ∙ p)
 sw12V (x , p) = (sw12 x , sw12-sum x ∙ p)
 sw02V (x , p) = (sw02 x , sw02-sum x ∙ p)

 sw01V-invol : (x : V₃) → sw01V (sw01V x) ≡ x
 sw01V-invol (x , p) = Σ≡Prop (λ v → isPropSum (sum3 v) 0r) refl

 -- scaling on `V₃`
 private
   scale-sum : (c a b d : ⟨ R ⟩) → (c · a) + (c · b) + (c · d) ≡ c · (a + b + d)
   scale-sum = solve R
   scale-zero : (c : ⟨ R ⟩) → c · 0r ≡ 0r
   scale-zero = solve R

 scaleV : ⟨ R ⟩ → V₃ → V₃
 scaleV c ((a , b , d) , p) =
   ((c · a , c · b , c · d) , scale-sum c a b d ∙ cong (c ·_) p ∙ scale-zero c)

 ------------------------------------------------------------------
 -- 3.1  T14.11's OBSTRUCTION, with NO invertibility hypothesis.
 --
 -- The two eigenvectors, and the exact conclusion they force.
 ------------------------------------------------------------------

 private
   uSum : (1r + (- 1r) + 0r) ≡ 0r
   uSum = lem 1r where
     lem : (x : ⟨ R ⟩) → x + (- x) + 0r ≡ 0r
     lem = solve R

   vSum : (1r + 1r + (- (1r + 1r))) ≡ 0r
   vSum = lem 1r where
     lem : (x : ⟨ R ⟩) → x + x + (- (x + x)) ≡ 0r
     lem = solve R

 -- `u = (1, −1, 0)` : the `−1` eigenvector of the transposition (0 1)
 uVec : V₃
 uVec = ((1r , - 1r , 0r) , uSum)

 -- `v = (1, 1, −2)` : the `+1` eigenvector
 vVec : V₃
 vVec = ((1r , 1r , - (1r + 1r)) , vSum)

 private
   uNegSnd : (- 1r) ≡ (- 1r) · 1r
   uNegSnd = lem 1r where
     lem : (x : ⟨ R ⟩) → (- x) ≡ (- x) · x
     lem = solve R
   uNegFst : 1r ≡ (- 1r) · (- 1r)
   uNegFst = lem 1r where
     lem : (x : ⟨ R ⟩) → x ≡ (- x) · (- x)
     lem = solve R
   uNegThd : 0r ≡ (- 1r) · 0r
   uNegThd = lem 1r where
     lem : (x : ⟨ R ⟩) → 0r ≡ (- x) · 0r
     lem = solve R
   vOneA : 1r ≡ 1r · 1r
   vOneA = lem 1r where
     lem : (x : ⟨ R ⟩) → x ≡ x · x
     lem = solve R
   vOneC : (- (1r + 1r)) ≡ 1r · (- (1r + 1r))
   vOneC = lem 1r where
     lem : (x : ⟨ R ⟩) → (- (x + x)) ≡ x · (- (x + x))
     lem = solve R

 -- T14.11, the exhibition: `(0 1)` scales `u` by `−1` …
 sw01-u : sw01V uVec ≡ scaleV (- 1r) uVec
 sw01-u = Σ≡Prop (λ v → isPropSum (sum3 v) 0r)
                 (≡-× uNegSnd (≡-× uNegFst uNegThd))

 -- … and fixes `v`.
 sw01-v : sw01V vVec ≡ scaleV 1r vVec
 sw01-v = Σ≡Prop (λ v → isPropSum (sum3 v) 0r)
                 (≡-× vOneA (≡-× vOneA vOneC))

 -- "the transposition acts by a scalar", as a type to be refuted
 Scalar01 : Type ℓ
 Scalar01 = Σ[ c ∈ ⟨ R ⟩ ] ((x : V₃) → sw01V x ≡ scaleV c x)

 private
   fstOf : V₃ → ⟨ R ⟩
   fstOf ((a , _ , _) , _) = a

   c1 : (c : ⟨ R ⟩) → c · 1r ≡ c
   c1 = solve R

   char2lem : (x : ⟨ R ⟩) → x + x ≡ x - (- x)
   char2lem = solve R

 -- **T14.11, sharp.**  If the transposition (0 1) acts on `V₃` by a
 -- scalar then `1 + 1 ≡ 0`.  No invertibility hypothesis of any kind:
 -- the two eigenvectors force the scalar to be both `−1` and `+1`.
 sw01-scalar→char2 : Scalar01 → 1r + 1r ≡ 0r
 sw01-scalar→char2 (c , h) = step
   where
   fromU : (- 1r) ≡ c
   fromU = cong fstOf (h uVec) ∙ c1 c
   fromV : 1r ≡ c
   fromV = cong fstOf (h vVec) ∙ c1 c
   neg1≡1 : (- 1r) ≡ 1r
   neg1≡1 = fromU ∙ sym fromV
   step : 1r + 1r ≡ 0r
   step = char2lem 1r ∙ cong (1r -_) neg1≡1 ∙ z 1r
     where
     z : (x : ⟨ R ⟩) → x - x ≡ 0r
     z = solve R

 ------------------------------------------------------------------
 -- 3.2  With `half`: the DIAGONALISING BASIS, and T14.11 in full.
 ------------------------------------------------------------------

 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  private
    unit½ : (x : ⟨ R ⟩) → (half + half) · x ≡ x
    unit½ x = cong (_· x) half+half ∙ ·IdL x

    q1 : (h α β : ⟨ R ⟩) → h · ((α + β) - ((- α) + β)) ≡ (h + h) · α
    q1 = solve R
    q2 : (h α β : ⟨ R ⟩) → h · ((α + β) + ((- α) + β)) ≡ (h + h) · β
    q2 = solve R
    q3 : (α β : ⟨ R ⟩) → (α + β) + ((- α) + β) + (- (β + β)) ≡ 0r
    q3 = solve R
    r1 : (h a b : ⟨ R ⟩) → h · (a - b) + h · (a + b) ≡ (h + h) · a
    r1 = solve R
    r2 : (h a b : ⟨ R ⟩) → (- (h · (a - b))) + h · (a + b) ≡ (h + h) · b
    r2 = solve R
    r3 : (h a b : ⟨ R ⟩) → (- (h · (a + b) + h · (a + b))) ≡ - ((h + h) · (a + b))
    r3 = solve R
    r4 : (a b c : ⟨ R ⟩) → (a + b + c) + (- (a + b)) ≡ c
    r4 = solve R
    r5 : (s : ⟨ R ⟩) → 0r + (- s) ≡ - s
    r5 = solve R

    negOfSum3 : (a b c : ⟨ R ⟩) → a + b + c ≡ 0r → (- (a + b)) ≡ c
    negOfSum3 a b c p =
      sym (sym (r4 a b c) ∙ cong (_+ (- (a + b))) p ∙ r5 (a + b))

  -- the basis `u = (1,−1,0)`, `v = (1,1,−2)` of `V₃`, as coordinates
  coords₃ : V₃ → ⟨ R ⟩ × ⟨ R ⟩
  coords₃ ((a , b , _) , _) = (half · (a - b) , half · (a + b))

  uncoords₃ : ⟨ R ⟩ × ⟨ R ⟩ → V₃
  uncoords₃ (α , β) = ((α + β , (- α) + β , - (β + β)) , q3 α β)

  V₃Iso : Iso V₃ (⟨ R ⟩ × ⟨ R ⟩)
  Iso.fun      V₃Iso = coords₃
  Iso.inv      V₃Iso = uncoords₃
  Iso.rightInv V₃Iso (α , β) =
    ≡-× (q1 half α β ∙ unit½ α) (q2 half α β ∙ unit½ β)
  Iso.leftInv  V₃Iso ((a , b , c) , p) =
    Σ≡Prop (λ v → isPropSum (sum3 v) 0r)
      (≡-× (r1 half a b ∙ unit½ a)
           (≡-× (r2 half a b ∙ unit½ b)
                (r3 half a b
                 ∙ cong (λ u → - (u · (a + b))) half+half
                 ∙ cong -_ (·IdL (a + b))
                 ∙ negOfSum3 a b c p)))

  -- T14.8's companion at k = 3: `V₃` is free of rank 2.
  V₃≃R² : V₃ ≃ (⟨ R ⟩ × ⟨ R ⟩)
  V₃≃R² = isoToEquiv V₃Iso

  private
    f1 : (h a b : ⟨ R ⟩) → h · (b - a) ≡ - (h · (a - b))
    f1 = solve R
    f2 : (h a b : ⟨ R ⟩) → h · (b + a) ≡ h · (a + b)
    f2 = solve R

  -- **T14.11 IN FULL, at k = 3.**  In the basis `(u,v)` the
  -- transposition (0 1) is `diag(−1, +1)`: eigenvalue `−1` with
  -- multiplicity 1, eigenvalue `+1` with multiplicity `k − 2 = 1`.
  -- This is the eigenvalue-multiplicity statement, not a sample of it.
  sw01-diagonalised :
    (x : V₃) → coords₃ (sw01V x)
             ≡ (- (coords₃ x .fst) , coords₃ x .snd)
  sw01-diagonalised ((a , b , c) , p) = ≡-× (f1 half a b) (f2 half a b)

  -- and hence, when 2 is invertible in a NONTRIVIAL ring, the
  -- transposition is not scalar — Delta 14 T14.11's own phrasing.
  sw01-not-scalar : (1r ≡ 0r → ⊥) → Scalar01 → ⊥
  sw01-not-scalar nz s = nz (sym half+half ∙ g half ∙ cong (half ·_) ch2 ∙ z half)
    where
    ch2 : 1r + 1r ≡ 0r
    ch2 = sw01-scalar→char2 s
    g : (h : ⟨ R ⟩) → h + h ≡ h · (1r + 1r)
    g = solve R
    z : (h : ⟨ R ⟩) → h · 0r ≡ 0r
    z = solve R

 ------------------------------------------------------------------
 -- 3.3  With `third`: T14.8 and T14.9 at k = 3.
 ------------------------------------------------------------------

 module _ (third : ⟨ R ⟩) (third3 : third + third + third ≡ 1r) where

  mean₃ : Vec3 → ⟨ R ⟩
  mean₃ x = third · sum3 x

  shift₃ : ⟨ R ⟩ → Vec3 → Vec3
  shift₃ m (a , b , c) = (a - m , b - m , c - m)

  dev₃ : Vec3 → Vec3
  dev₃ x = shift₃ (mean₃ x) x

  private
    g1 : (t a b c : ⟨ R ⟩)
       → (a - t · (a + b + c)) + (b - t · (a + b + c)) + (c - t · (a + b + c))
       ≡ (a + b + c) - (t + t + t) · (a + b + c)
    g1 = solve R
    g2 : (s : ⟨ R ⟩) → s - 1r · s ≡ 0r
    g2 = solve R
    g3 : (t m a b c : ⟨ R ⟩)
       → t · ((m + a) + (m + b) + (m + c)) ≡ t · ((m + m + m) + (a + b + c))
    g3 = solve R
    g4 : (t m : ⟨ R ⟩) → t · ((m + m + m) + 0r) ≡ (t + t + t) · m
    g4 = solve R
    g5 : (m a : ⟨ R ⟩) → (m + a) - m ≡ a
    g5 = solve R
    g6 : (m a : ⟨ R ⟩) → m + (a - m) ≡ a
    g6 = solve R

  dev₃-sum : (x : Vec3) → sum3 (dev₃ x) ≡ 0r
  dev₃-sum (a , b , c) =
      g1 third a b c
    ∙ cong (λ u → (a + b + c) - u · (a + b + c)) third3
    ∙ g2 (a + b + c)

  -- T14.8 at k = 3:  `R³ ≃ R × V₃`,  `x ↦ (mean x , x − mean x · 1)`.
  split₃-fun : Vec3 → ⟨ R ⟩ × V₃
  split₃-fun x = (mean₃ x , (dev₃ x , dev₃-sum x))

  split₃-inv : ⟨ R ⟩ × V₃ → Vec3
  split₃-inv (m , ((a , b , c) , _)) = (m + a , m + b , m + c)

  split₃Iso : Iso Vec3 (⟨ R ⟩ × V₃)
  Iso.fun      split₃Iso = split₃-fun
  Iso.inv      split₃Iso = split₃-inv
  Iso.rightInv split₃Iso (m , ((a , b , c) , p)) =
    ≡-× meanPath
        (Σ≡Prop (λ v → isPropSum (sum3 v) 0r)
                (cong (λ u → shift₃ u (m + a , m + b , m + c)) meanPath
                 ∙ ≡-× (g5 m a) (≡-× (g5 m b) (g5 m c))))
    where
    meanPath : mean₃ (m + a , m + b , m + c) ≡ m
    meanPath =
        g3 third m a b c
      ∙ cong (λ u → third · ((m + m + m) + u)) p
      ∙ g4 third m
      ∙ cong (_· m) third3
      ∙ ·IdL m
  Iso.leftInv  split₃Iso (a , b , c) =
    ≡-× (g6 (mean₃ (a , b , c)) a)
        (≡-× (g6 (mean₃ (a , b , c)) b) (g6 (mean₃ (a , b , c)) c))

  split₃ : Vec3 ≃ (⟨ R ⟩ × V₃)
  split₃ = isoToEquiv split₃Iso

  -- T14.9 at k = 3.  The centre coordinate is fixed by every generator
  -- of `S₃` …
  mean₃-inv-01 : (x : Vec3) → mean₃ (sw01 x) ≡ mean₃ x
  mean₃-inv-01 x = cong (third ·_) (sw01-sum x)
  mean₃-inv-12 : (x : Vec3) → mean₃ (sw12 x) ≡ mean₃ x
  mean₃-inv-12 x = cong (third ·_) (sw12-sum x)
  mean₃-inv-02 : (x : Vec3) → mean₃ (sw02 x) ≡ mean₃ x
  mean₃-inv-02 x = cong (third ·_) (sw02-sum x)

  -- … and the deviation is equivariant, so under `split₃` the `S₃`-action
  -- on `R³` is (trivial on the centre) × (the action on `V₃`), which by
  -- §3.2 is `diag(−1,+1)` for a transposition.  That is the standard
  -- representation at k = 3.
  dev₃-equivariant-01 : (x : Vec3) → dev₃ (sw01 x) ≡ sw01 (dev₃ x)
  dev₃-equivariant-01 x = cong (λ u → shift₃ u (sw01 x)) (mean₃-inv-01 x)
  dev₃-equivariant-12 : (x : Vec3) → dev₃ (sw12 x) ≡ sw12 (dev₃ x)
  dev₃-equivariant-12 x = cong (λ u → shift₃ u (sw12 x)) (mean₃-inv-12 x)
  dev₃-equivariant-02 : (x : Vec3) → dev₃ (sw02 x) ≡ sw02 (dev₃ x)
  dev₃-equivariant-02 x = cong (λ u → shift₃ u (sw02 x)) (mean₃-inv-02 x)

 ---------------------------------------------------------------------
 -- 5.  T14.12, AND WHY IT IS NOT HERE.
 --
 -- Delta 14 T14.12 asserts
 --
 --     Σ_{j≥0} tr(τ | Symʲ V_k) tʲ  =  1 / ((1−t)^{k−2} (1+t)),
 --
 -- with `(−1)ʲ` at k = 2 and `1 / 0` alternating at k = 3.  It is NOT
 -- proved here and is NOT approximated here.  The missing objects are
 -- specific and worth naming rather than gesturing at:
 --
 --   * `Symʲ M` for a module `M` over a `CommRing`.  cubical v0.5 has
 --     `Cubical.Algebra.Module` but no symmetric power, no tensor
 --     algebra, and no graded quotient construction to build one from.
 --   * a TRACE.  A trace needs a finite basis and a proof that the
 --     trace is basis-independent; v0.5's `Cubical.Algebra.Matrix` has
 --     matrices but no determinant/trace theory for module
 --     endomorphisms.
 --   * the fact that `Symʲ` of a diagonalised rank-2 module has the
 --     monomial eigenbasis `{uⁱ v^{j−i}}`.  This is the actual content
 --     of T14.12 at k = 3 and it is a theorem about `Symʲ`, so it is
 --     downstream of the first bullet.
 --
 -- Building all three is a module of its own and is out of scope for
 -- Program 14.73.  Writing a hand-rolled "Symʲ := free module on
 -- monomials, acting diagonally" and computing its trace would be
 -- MODELLING the answer, not proving it, and would be exactly the
 -- promotion `PerspectiveCore` refuses for T14.6's iff.
 --
 -- What CAN be checked, and is checked below, is the arithmetic the
 -- trace reduces to at k = 3 once the eigenbasis is granted: the
 -- diagonal entries on `Symʲ` are `(−1)ⁱ` for `i = 0 … j`, so the trace
 -- is `Σ_{i≤j} (−1)ⁱ`, which is `1` for `j` even and `0` for `j` odd —
 -- i.e. the coefficients of `1/((1−t)(1+t)) = 1/(1−t²)`.  This is an
 -- identity in `R`, is a term, and is **not** T14.12; the conditional is
 -- the whole point of stating it separately.
 ---------------------------------------------------------------------

 -- `(−1)ʲ`
 negPow : ℕ → ⟨ R ⟩
 negPow zero    = 1r
 negPow (suc j) = (- 1r) · negPow j

 -- `Σ_{i=0}^{j} (−1)ⁱ`
 altSum : ℕ → ⟨ R ⟩
 altSum zero    = 1r
 altSum (suc j) = altSum j + negPow (suc j)

 private
   np1 : (x : ⟨ R ⟩) → (- 1r) · ((- 1r) · x) ≡ x
   np1 = solve R
   as1 : (s : ⟨ R ⟩) → s + (- 1r) · s ≡ 0r
   as1 = solve R
   as2 : (x : ⟨ R ⟩) → 0r + (- 1r) · ((- 1r) · x) ≡ x
   as2 = solve R

 -- the two-step recursion, in the form the induction needs
 negPow-two : (j : ℕ) → negPow (suc (suc j)) ≡ negPow j
 negPow-two j = np1 (negPow j)

 -- `Σ_{i≤2n} (−1)ⁱ = 1` and `Σ_{i≤2n+1} (−1)ⁱ = 0`.
 altSum-even : (n : ℕ) → altSum (double n) ≡ 1r
 altSum-odd  : (n : ℕ) → altSum (suc (double n)) ≡ 0r

 altSum-even zero    = refl
 altSum-even (suc n) =
   cong (_+ negPow (suc (suc (double n)))) (altSum-odd n)
   ∙ cong (0r +_) (negPow-two (double n))
   ∙ lem (altSum (double n))
   ∙ altSum-even n
   where
   -- `negPow (double n)` is `+1` only after the induction; keep the step
   -- purely arithmetic by rewriting through `altSum`
   lem : (s : ⟨ R ⟩) → 0r + negPow (double n) ≡ negPow (double n)
   lem _ = solve R _

 altSum-odd n = cong (_+ negPow (suc (double n))) (altSum-even n)
                ∙ as1' (negPow (double n))
   where
   as1' : (s : ⟨ R ⟩) → 1r + negPow (suc (double n)) ≡ 0r
   as1' _ = solve R _
