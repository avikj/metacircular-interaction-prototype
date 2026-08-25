{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MeanStandardRep
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
--           deliberately NOT re-proved.  It is Chevalley–Shephard–Todd
--           for the symmetric group, i.e. the fundamental theorem of
--           symmetric polynomials.  Nothing below depends on it.
--
-- `CenterRelative` is imported, not edited; §2 proves that
-- its `Φ` **is** the k = 2 mean-split followed by the identification
-- `V₂ ≅ R`, so C14.10 is that file's `ρ` and is not a second object.
--
--
-- WHAT IS A TERM HERE, AND WHAT IS NOT
--
--   T14.8    k = 2 (`split₂`), k = 3 (`split₃`), and **GENERAL `k`**
--            (`splitₖ`, §4), with "`k` invertible" presented as the
--            hypothesis the proof consumes: an element `kinv` with
--            `Σ_{i<k} kinv ≡ 1r`.
--   T14.11    non-scalarity also at **every `k ≥ 3`** (`sw01ₖ-scalar→char2`,
--            §4.1); the eigenvalue MULTIPLICITIES stay at k = 3, since
--            they need a basis of `V_k` and not one vector pair.
--   T14.9    k = 2 (`mean₂-inv`, `dev₂-equivariant`) and k = 3 for all
--            three transpositions, which generate `S₃`
--            (`mean₃-inv-*`, `dev₃-equivariant-*`).  The statement is
--            proved for the generators; it is NOT lifted to a
--            homomorphism out of an abstract `S₃`, because no group
--            object is built.  Saying "the `S₃` action" of the three
--            checked transpositions would overstate by exactly that gap.
--   C14.10   `sign-rep₂` — the swap acts on `V₂ ≅ R` by `x ↦ −x`.
--   T14.11   k = 3, in the STRONG form: an explicit basis change
--            `V₃ ≃ R × R` in which the transposition is `diag(−1,+1)`
--            (`sw01-diagonalised`), which IS "eigenvalue −1 with
--            multiplicity 1, +1 with multiplicity k−2 = 1"; plus the two
--            eigenvectors exhibited (`sw01-u`, `sw01-v`) and the
--            non-scalarity corollary in its sharp form: a transposition
--            on `V₃` is scalar ONLY in characteristic 2
--            (`sw01-scalar→char2`), hence never when 2 is invertible in
--            a nontrivial ring (`sw01-not-scalar`).
--   T14.12   **NOT PROVED, AND NOT FAKED.**  See §5 for the three
--            missing objects.  What is a term is the arithmetic the
--            trace reduces to at k = 3 once the eigenbasis is granted:
--            `altSum-even` / `altSum-odd`.
--
--
-- HYPOTHESIS STRATIFICATION, deliberately
--
-- Each result is stated under exactly the arithmetic it needs — the
-- point `CenterRelative` makes about `half+half ≡ 1r`, kept:
--
--   §3.1  no `half`, no `third`  — `V₃`, the transpositions, the two
--                                  eigenvectors, and `sw01-scalar→char2`.
--                                  **T14.11's obstruction needs no
--                                  invertibility hypothesis at all.**
--   §3.2  `half` only            — the diagonalising basis `V₃ ≃ R × R`,
--                                  `sw01-diagonalised`, `sw01-not-scalar`.
--   §3.3  `third` only           — T14.8 and T14.9 at k = 3.  The mean
--                                  needs `3` invertible and nothing else.
--
-- That `k` invertible is needed for the SPLIT while it is NOT needed for
-- the ACTION to be non-scalar is a real distinction, and the layering is
-- how it is recorded rather than asserted.
--
--
-- THE ONE THING THIS FILE IS NOT SILENT ABOUT: 5 WARNINGS
--
-- `agda NaturalMachine/MeanStandardRep.agda` exits 0 but prints five
-- `UnsupportedIndexedMatch` warnings, all from §4.1, all of the form
--
--   "It relies on injectivity of the data constructor suc, which is not
--    yet supported … will not compute when applied to transports."
--
-- This is a property of the PINNED TOOLCHAIN, not of the mathematics,
-- and it is unavoidable here: in Agda 2.6.3 + cubical v0.5, **every**
-- definition by pattern matching on `Cubical.Data.FinData`'s `Fin`
-- raises it as soon as the length index is a constructor applied to a
-- variable — verified at depth one (a bare `cons`) as well as depth two.
-- cubical v0.5's own `Cubical.Algebra.Ring.BigOps.∑Mulr1` matches `Fin`
-- the same way.  §4.1 needs the transposition of the first two
-- coordinates of a length-`(n+3)` vector, and that map cannot be built
-- from the library's warning-free combinators (`rec`, `replicateFinVec`,
-- `_++Fin_`), which can produce constant and concatenated vectors but
-- cannot permute.
--
-- The warning says the function may fail to REDUCE under a transport.
-- It does not weaken any statement: every theorem below is a checked
-- term under `--safe`, with no postulate, hole, or `TERMINATING`.  §§1–4
-- and §5 are warning-free; deleting §4.1 would remove five warnings and
-- one theorem (T14.11's obstruction at every `k ≥ 3`).  It is kept, and
-- disclosed here, rather than dropped to make a log look cleaner.
--
-- For calibration, since a bare warning count invites the wrong
-- inference: `agda agda` (the root aggregate, exit 0)
-- already prints this SAME warning at ~57 sites across five modules
-- already in the tree — `PMTorus`, `PayloadMorphism`, `DigitTowerLimit`,
-- `SmithPathCountedExecution`, `PMCokernel`.  Five more is not a new
-- category of defect in this corpus; it is the pinned toolchain's
-- standing cost for indexed families, and `BUILD.md`'s version-skew list
-- is where it belongs if anyone wants it recorded once.
--
--
-- PRIOR ART (searched before proving, per CLAUDE.md)
--
-- Searched `~/agda-libs/` (cubical v0.5, agda-unimath, UniMath, Symmetry
-- book, Coq-HoTT, mathlib4) for a reusable standard representation.
-- Result: **none exists to reuse.**  mathlib4 has
-- `Mathlib/RepresentationTheory/` but no `standardRep`, no Specht
-- modules, and no permutation-module decomposition (grep for "standard
-- representation", "standardRep", "Specht": zero hits across
-- `Mathlib/`).  agda-unimath has `finite-group-theory/sign-homomorphism`
-- — the sign CHARACTER, not the sign representation as a module — and no
-- representation theory above it.  cubical v0.5 has
-- `Algebra/SymmetricGroup.agda`, `Algebra/Module`, `Algebra/Matrix`, and
-- no representation theory whatsoever.  Hand-rolling at k = 2, 3 is
-- therefore not a rediscovery of available formal material.  The
-- MATHEMATICS is entirely classical and no novelty is claimed for it;
-- what is new is only that the machine core now holds it as terms.
------------------------------------------------------------------------

module MeanStandardRep where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.FinData.Base using (Fin ; FinVec ; replicateFinVec)
  renaming (zero to fzero ; suc to fsuc)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring.BigOps using (module Sum)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import CenterRelative using (Pair ; Φ)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)

 private
   -- `Σxᵢ ≡ 0r` is a path in a set, hence a proposition; this is what
   -- lets `V₂`/`V₃` be compared by their vector components alone.
   isPropEq : (x y : ⟨ R ⟩) → isProp (x ≡ y)
   isPropEq x y = is-set x y

 ---------------------------------------------------------------------
 -- 1.  k = 2:  `V₂ = {(a,b) : a + b = 0}`, T14.8, `V₂ ≅ R`, C14.10.
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
   sw2sum _ _ = solve! R

 swap2-sum : (x : Vec2) → sum2 (swap2 x) ≡ sum2 x
 swap2-sum (a , b) = sw2sum a b

 -- the `S₂`-action on `V₂`
 swap2V : V₂ → V₂
 swap2V (x , p) = (swap2 x , swap2-sum x ∙ p)

 swap2V-invol : (x : V₂) → swap2V (swap2V x) ≡ x
 swap2V-invol ((a , b) , p) = Σ≡Prop (λ v → isPropEq (sum2 v) 0r) refl

 -- `V₂ ≅ R`, by the second coordinate: `a` is determined, `a = −b`.
 private
   negFromSum : (a b : ⟨ R ⟩) → a + b ≡ 0r → (- b) ≡ a
   negFromSum a b p = sym (sym (e1 a b) ∙ cong (_+ (- b)) p ∙ e2 b)
     where
     e1 : (a b : ⟨ R ⟩) → (a + b) + (- b) ≡ a
     e1 _ _ = solve! R
     e2 : (b : ⟨ R ⟩) → 0r + (- b) ≡ - b
     e2 _ = solve! R

   negSum2 : (b : ⟨ R ⟩) → (- b) + b ≡ 0r
   negSum2 _ = solve! R

 V₂→R : V₂ → ⟨ R ⟩
 V₂→R ((a , b) , _) = b

 R→V₂ : ⟨ R ⟩ → V₂
 R→V₂ b = ((- b , b) , negSum2 b)

 V₂Iso : Iso V₂ ⟨ R ⟩
 Iso.fun      V₂Iso = V₂→R
 Iso.inv      V₂Iso = R→V₂
 Iso.rightInv V₂Iso b = refl
 Iso.leftInv  V₂Iso ((a , b) , p) =
   Σ≡Prop (λ v → isPropEq (sum2 v) 0r) (≡-× (negFromSum a b p) refl)

 V₂≃R : V₂ ≃ ⟨ R ⟩
 V₂≃R = isoToEquiv V₂Iso

 -- C14.10.  THE SIGN REPRESENTATION at k = 2: under `V₂ ≅ R` the
 -- transposition is multiplication by `−1`.  One line, because `V₂` is
 -- the line `{(−b, b)}` and swapping its entries negates `b`.
 sign-rep₂ : (x : V₂) → V₂→R (swap2V x) ≡ - (V₂→R x)
 sign-rep₂ ((a , b) , p) = sym (negFromSum a b p)

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
    d2a _ _ _ = solve! R
    d2b : (s : ⟨ R ⟩) → s - 1r · s ≡ 0r
    d2b _ = solve! R
    m2a : (h m a b : ⟨ R ⟩) → h · ((m + a) + (m + b)) ≡ h · ((m + m) + (a + b))
    m2a _ _ _ _ = solve! R
    m2b : (h m : ⟨ R ⟩) → h · ((m + m) + 0r) ≡ (h + h) · m
    m2b _ _ = solve! R
    s2a : (m a : ⟨ R ⟩) → (m + a) - m ≡ a
    s2a _ _ = solve! R
    s2b : (m a : ⟨ R ⟩) → m + (a - m) ≡ a
    s2b _ _ = solve! R

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

  split₂Iso : Iso Vec2 (⟨ R ⟩ × V₂)
  Iso.fun      split₂Iso = split₂-fun
  Iso.inv      split₂Iso = split₂-inv
  Iso.rightInv split₂Iso (m , ((a , b) , p)) =
    ≡-× meanPath
        (Σ≡Prop (λ v → isPropEq (sum2 v) 0r)
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
  Iso.leftInv  split₂Iso (a , b) =
    ≡-× (s2b (mean₂ (a , b)) a) (s2b (mean₂ (a , b)) b)

  split₂ : Vec2 ≃ (⟨ R ⟩ × V₂)
  split₂ = isoToEquiv split₂Iso

  -- T14.9 at k = 2: the centre coordinate is `S₂`-invariant …
  mean₂-inv : (x : Vec2) → mean₂ (swap2 x) ≡ mean₂ x
  mean₂-inv x = cong (half ·_) (swap2-sum x)

  -- … and the deviation is equivariant, so `split₂` intertwines the
  -- `S₂`-action on `R²` with (trivial on the centre) × (sign on `V₂`).
  dev₂-equivariant : (x : Vec2) → dev₂ (swap2 x) ≡ swap2 (dev₂ x)
  dev₂-equivariant (a , b) = cong (λ u → shift₂ u (b , a)) (mean₂-inv (a , b))

  ------------------------------------------------------------------
  -- 2.  THE BRIDGE TO `CenterRelative`.
  --
  -- The k = 2 mean-split, followed by `V₂ ≅ R`, IS that file's `Φ`.
  -- So C14.10's sign representation is `CenterRelative.ρ`'s second
  -- component, and `CenterRelative.Φ∘τ≡ρ∘Φ` is already the intertwining
  -- statement — neither is a second object and neither is re-proved here.
  ------------------------------------------------------------------

  private
    bridge : (h a b : ⟨ R ⟩) → (h + h) · b - h · (a + b) ≡ h · (b - a)
    bridge _ _ _ = solve! R

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

 -- the three transpositions, which generate `S₃`
 sw01 sw12 sw02 : Vec3 → Vec3
 sw01 (a , b , c) = (b , a , c)
 sw12 (a , b , c) = (a , c , b)
 sw02 (a , b , c) = (c , b , a)

 private
   p01 : (a b c : ⟨ R ⟩) → b + a + c ≡ a + b + c
   p01 _ _ _ = solve! R
   p12 : (a b c : ⟨ R ⟩) → a + c + b ≡ a + b + c
   p12 _ _ _ = solve! R
   p02 : (a b c : ⟨ R ⟩) → c + b + a ≡ a + b + c
   p02 _ _ _ = solve! R

 sw01-sum : (x : Vec3) → sum3 (sw01 x) ≡ sum3 x
 sw01-sum (a , b , c) = p01 a b c
 sw12-sum : (x : Vec3) → sum3 (sw12 x) ≡ sum3 x
 sw12-sum (a , b , c) = p12 a b c
 sw02-sum : (x : Vec3) → sum3 (sw02 x) ≡ sum3 x
 sw02-sum (a , b , c) = p02 a b c

 -- the transpositions restrict to `V₃`: the standard representation, as
 -- maps.  (No group object; see the header.)
 sw01V sw12V sw02V : V₃ → V₃
 sw01V (x , p) = (sw01 x , sw01-sum x ∙ p)
 sw12V (x , p) = (sw12 x , sw12-sum x ∙ p)
 sw02V (x , p) = (sw02 x , sw02-sum x ∙ p)

 sw01V-invol : (x : V₃) → sw01V (sw01V x) ≡ x
 sw01V-invol ((a , b , c) , p) = Σ≡Prop (λ v → isPropEq (sum3 v) 0r) refl

 private
   scale-sum : (c a b d : ⟨ R ⟩) → (c · a) + (c · b) + (c · d) ≡ c · (a + b + d)
   scale-sum _ _ _ _ = solve! R
   scale-zero : (c : ⟨ R ⟩) → c · 0r ≡ 0r
   scale-zero _ = solve! R

 scaleV : ⟨ R ⟩ → V₃ → V₃
 scaleV c ((a , b , d) , p) =
   ((c · a , c · b , c · d) , scale-sum c a b d ∙ cong (c ·_) p ∙ scale-zero c)

 ------------------------------------------------------------------
 -- 3.1  T14.11's OBSTRUCTION, with NO invertibility hypothesis.
 --
 -- Two eigenvectors, and the exact conclusion they force.
 ------------------------------------------------------------------

 private
   uSum : 1r + (- 1r) + 0r ≡ 0r
   uSum = lem 1r
     where
     lem : (x : ⟨ R ⟩) → x + (- x) + 0r ≡ 0r
     lem _ = solve! R

   vSum : 1r + 1r + (- (1r + 1r)) ≡ 0r
   vSum = lem 1r
     where
     lem : (x : ⟨ R ⟩) → x + x + (- (x + x)) ≡ 0r
     lem _ = solve! R

 -- `u = (1, −1, 0)`: the `−1` eigenvector of the transposition (0 1)
 uVec : V₃
 uVec = ((1r , - 1r , 0r) , uSum)

 -- `v = (1, 1, −2)`: the `+1` eigenvector
 vVec : V₃
 vVec = ((1r , 1r , - (1r + 1r)) , vSum)

 private
   uc0 : (- 1r) ≡ (- 1r) · 1r
   uc0 = lem 1r
     where
     lem : (x : ⟨ R ⟩) → (- x) ≡ (- x) · 1r
     lem _ = solve! R
   uc1 : 1r ≡ (- 1r) · (- 1r)
   uc1 = lem 1r
     where
     lem : (x : ⟨ R ⟩) → x ≡ (- 1r) · (- x)
     lem _ = solve! R
   uc2 : 0r ≡ (- 1r) · 0r
   uc2 = lem 1r
     where
     lem : (x : ⟨ R ⟩) → 0r ≡ (- x) · 0r
     lem _ = solve! R
   vc0 : 1r ≡ 1r · 1r
   vc0 = lem 1r
     where
     lem : (x : ⟨ R ⟩) → x ≡ x · 1r
     lem _ = solve! R
   vc2 : (- (1r + 1r)) ≡ 1r · (- (1r + 1r))
   vc2 = lem 1r
     where
     lem : (x : ⟨ R ⟩) → (- (x + x)) ≡ 1r · (- (x + x))
     lem _ = solve! R

 -- T14.11, the exhibition: `(0 1)` scales `u` by `−1` …
 sw01-u : sw01V uVec ≡ scaleV (- 1r) uVec
 sw01-u = Σ≡Prop (λ v → isPropEq (sum3 v) 0r) (≡-× uc0 (≡-× uc1 uc2))

 -- … and fixes `v`.
 sw01-v : sw01V vVec ≡ scaleV 1r vVec
 sw01-v = Σ≡Prop (λ v → isPropEq (sum3 v) 0r) (≡-× vc0 (≡-× vc0 vc2))

 -- "the transposition acts on `V₃` by a scalar", as a type to be refuted
 Scalar01 : Type ℓ
 Scalar01 = Σ[ c ∈ ⟨ R ⟩ ] ((x : V₃) → sw01V x ≡ scaleV c x)

 private
   fstOf : V₃ → ⟨ R ⟩
   fstOf ((a , _ , _) , _) = a

   c1 : (c : ⟨ R ⟩) → c · 1r ≡ c
   c1 _ = solve! R
   char2lem : (x : ⟨ R ⟩) → x + x ≡ x - (- x)
   char2lem _ = solve! R
   selfSub : (x : ⟨ R ⟩) → x - x ≡ 0r
   selfSub _ = solve! R

 -- **T14.11, SHARP.**  If the transposition (0 1) acts on `V₃` by a
 -- scalar then `1 + 1 ≡ 0`.  No invertibility hypothesis of any kind:
 -- the two eigenvectors force the scalar to be both `−1` and `+1`, and
 -- that is already the whole content.
 sw01-scalar→char2 : Scalar01 → 1r + 1r ≡ 0r
 sw01-scalar→char2 (c , h) =
   char2lem 1r ∙ cong (λ u → 1r - u) neg1≡1 ∙ selfSub 1r
   where
   fromU : (- 1r) ≡ c
   fromU = cong fstOf (h uVec) ∙ c1 c
   fromV : 1r ≡ c
   fromV = cong fstOf (h vVec) ∙ c1 c
   neg1≡1 : (- 1r) ≡ 1r
   neg1≡1 = fromU ∙ sym fromV

 ------------------------------------------------------------------
 -- 3.2  With `half`: the DIAGONALISING BASIS, and T14.11 in full.
 ------------------------------------------------------------------

 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  private
    unit½ : (x : ⟨ R ⟩) → (half + half) · x ≡ x
    unit½ x = cong (_· x) half+half ∙ ·IdL x

    q1 : (h α β : ⟨ R ⟩) → h · ((α + β) - ((- α) + β)) ≡ (h + h) · α
    q1 _ _ _ = solve! R
    q2 : (h α β : ⟨ R ⟩) → h · ((α + β) + ((- α) + β)) ≡ (h + h) · β
    q2 _ _ _ = solve! R
    q3 : (α β : ⟨ R ⟩) → (α + β) + ((- α) + β) + (- (β + β)) ≡ 0r
    q3 _ _ = solve! R
    r1 : (h a b : ⟨ R ⟩) → h · (a - b) + h · (a + b) ≡ (h + h) · a
    r1 _ _ _ = solve! R
    r2 : (h a b : ⟨ R ⟩) → (- (h · (a - b))) + h · (a + b) ≡ (h + h) · b
    r2 _ _ _ = solve! R
    r3 : (h a b : ⟨ R ⟩) → (- (h · (a + b) + h · (a + b))) ≡ - ((h + h) · (a + b))
    r3 _ _ _ = solve! R
    r4 : (a b c : ⟨ R ⟩) → (a + b + c) + (- (a + b)) ≡ c
    r4 _ _ _ = solve! R
    r5 : (s : ⟨ R ⟩) → 0r + (- s) ≡ - s
    r5 _ = solve! R

    negOfSum3 : (a b c : ⟨ R ⟩) → a + b + c ≡ 0r → (- (a + b)) ≡ c
    negOfSum3 a b c p =
      sym (sym (r4 a b c) ∙ cong (_+ (- (a + b))) p ∙ r5 (a + b))

  -- coordinates in the basis `u = (1,−1,0)`, `v = (1,1,−2)` of `V₃`
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
    Σ≡Prop (λ v → isPropEq (sum3 v) 0r)
      (≡-× (r1 half a b ∙ unit½ a)
           (≡-× (r2 half a b ∙ unit½ b)
                (r3 half a b
                 ∙ cong (λ u → - (u · (a + b))) half+half
                 ∙ cong (λ u → - u) (·IdL (a + b))
                 ∙ negOfSum3 a b c p)))

  -- `V₃` is free of rank 2 — the companion of T14.8 that makes the
  -- multiplicity statement below meaningful.
  V₃≃R² : V₃ ≃ (⟨ R ⟩ × ⟨ R ⟩)
  V₃≃R² = isoToEquiv V₃Iso

  private
    f1 : (h a b : ⟨ R ⟩) → h · (b - a) ≡ - (h · (a - b))
    f1 _ _ _ = solve! R
    f2 : (h a b : ⟨ R ⟩) → h · (b + a) ≡ h · (a + b)
    f2 _ _ _ = solve! R

  -- **T14.11 IN FULL, at k = 3.**  In the basis `(u,v)` the transposition
  -- (0 1) is `diag(−1, +1)`: eigenvalue `−1` with multiplicity 1,
  -- eigenvalue `+1` with multiplicity `k − 2 = 1`.  This is the
  -- eigenvalue-multiplicity statement itself, not a sample of it.
  sw01-diagonalised :
    (x : V₃) → coords₃ (sw01V x) ≡ (- (coords₃ x .fst) , coords₃ x .snd)
  sw01-diagonalised ((a , b , c) , p) = ≡-× (f1 half a b) (f2 half a b)

  private
    g : (h : ⟨ R ⟩) → h + h ≡ h · (1r + 1r)
    g _ = solve! R
    z : (h : ⟨ R ⟩) → h · 0r ≡ 0r
    z _ = solve! R

  -- … and hence, when 2 is invertible in a NONTRIVIAL ring, the
  -- transposition is not scalar — Delta 14 T14.11's own phrasing.
  sw01-not-scalar : (1r ≡ 0r → ⊥) → Scalar01 → ⊥
  sw01-not-scalar nz s =
    nz (sym half+half ∙ g half ∙ cong (half ·_) (sw01-scalar→char2 s) ∙ z half)

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
    g1 _ _ _ _ = solve! R
    g2 : (s : ⟨ R ⟩) → s - 1r · s ≡ 0r
    g2 _ = solve! R
    g3 : (t m a b c : ⟨ R ⟩)
       → t · ((m + a) + (m + b) + (m + c)) ≡ t · ((m + m + m) + (a + b + c))
    g3 _ _ _ _ _ = solve! R
    g4 : (t m : ⟨ R ⟩) → t · ((m + m + m) + 0r) ≡ (t + t + t) · m
    g4 _ _ = solve! R
    g5 : (m a : ⟨ R ⟩) → (m + a) - m ≡ a
    g5 _ _ = solve! R
    g6 : (m a : ⟨ R ⟩) → m + (a - m) ≡ a
    g6 _ _ = solve! R

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
        (Σ≡Prop (λ v → isPropEq (sum3 v) 0r)
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

  -- … and the deviation is equivariant, so under `split₃` the action on
  -- `R³` is (trivial on the centre) × (the action on `V₃`), which by
  -- §3.2 is `diag(−1,+1)` for a transposition.  That is the standard
  -- representation at k = 3.
  dev₃-equivariant-01 : (x : Vec3) → dev₃ (sw01 x) ≡ sw01 (dev₃ x)
  dev₃-equivariant-01 (a , b , c) =
    cong (λ u → shift₃ u (b , a , c)) (mean₃-inv-01 (a , b , c))
  dev₃-equivariant-12 : (x : Vec3) → dev₃ (sw12 x) ≡ sw12 (dev₃ x)
  dev₃-equivariant-12 (a , b , c) =
    cong (λ u → shift₃ u (a , c , b)) (mean₃-inv-12 (a , b , c))
  dev₃-equivariant-02 : (x : Vec3) → dev₃ (sw02 x) ≡ sw02 (dev₃ x)
  dev₃-equivariant-02 (a , b , c) =
    cong (λ u → shift₃ u (c , b , a)) (mean₃-inv-02 (a , b , c))

 ---------------------------------------------------------------------
 -- 4.  T14.8 AT GENERAL k.
 --
 -- `Vₖ k = {x : Fin k → R | Σxᵢ = 0}` and `Rᵏ ≃ R × Vₖ k` by
 -- `x ↦ (mean x , x − mean x · 1)`, for EVERY `k`, given `k` invertible.
 --
 -- "`k` invertible" is presented in the form the proof actually consumes:
 -- an element `kinv` with `Σ_{i<k} kinv ≡ 1r`.  That is the same shape as
 -- `CenterRelative`'s `half + half ≡ 1r` and is the honest statement —
 -- `k·kinv = 1` needs a ring map from ℕ, which this avoids.
 --
 -- Note what this does NOT give.  **T14.9 at general `k` is NOT here**,
 -- and the reason is precise: it needs `Σ` to be invariant under
 -- permutation of the index, and cubical v0.5's
 -- `Cubical.Algebra.Ring.BigOps` has `∑Ext`, `∑Split`, `∑Mulrdist`,
 -- `∑Mulldist`, `∑Dist-` and NO permutation-invariance lemma at all
 -- (not even for a transposition of two indices).  Proving it is an
 -- induction over `FinData` positions and is a module of its own.  So
 -- T14.9 stands at k = 2, 3 (§1, §3.3), where the permutations are
 -- finitely many concrete maps and the invariance is one solver call
 -- each.
 ---------------------------------------------------------------------

 open Sum (CommRing→Ring R)
   using (∑ ; ∑0r ; ∑Split ; ∑Mulrdist ; ∑Mulldist ; ∑Dist-)

 Vecₖ : ℕ → Type ℓ
 Vecₖ k = FinVec ⟨ R ⟩ k

 Vₖ : ℕ → Type ℓ
 Vₖ k = Σ[ x ∈ Vecₖ k ] (∑ x ≡ 0r)

 private
   n1 : (t s : ⟨ R ⟩) → t · (s + 0r) ≡ t · s
   n1 _ _ = solve! R
   n2 : (s : ⟨ R ⟩) → s + (- s) ≡ 0r
   n2 _ = solve! R
   n3 : (m a : ⟨ R ⟩) → (m + a) - m ≡ a
   n3 _ _ = solve! R
   n4 : (m a : ⟨ R ⟩) → m + (a - m) ≡ a
   n4 _ _ = solve! R

 module _ (k : ℕ) (kinv : ⟨ R ⟩)
          (kinvSum : ∑ (replicateFinVec k kinv) ≡ 1r) where

  meanₖ : Vecₖ k → ⟨ R ⟩
  meanₖ x = kinv · ∑ x

  devₖ : Vecₖ k → Vecₖ k
  devₖ x i = x i - meanₖ x

  private
    -- the two places `kinvSum` is used, and the only two
    constSum : (s : ⟨ R ⟩) → ∑ (replicateFinVec k (kinv · s)) ≡ s
    constSum s = sym (∑Mulldist s (replicateFinVec k kinv))
               ∙ cong (_· s) kinvSum
               ∙ ·IdL s

    meanConst : (m : ⟨ R ⟩) → kinv · ∑ (replicateFinVec k m) ≡ m
    meanConst m = ∑Mulrdist kinv (replicateFinVec k m)
                ∙ sym (∑Mulldist m (replicateFinVec k kinv))
                ∙ cong (_· m) kinvSum
                ∙ ·IdL m

  devₖ-sum : (x : Vecₖ k) → ∑ (devₖ x) ≡ 0r
  devₖ-sum x =
      ∑Split x (replicateFinVec k (- meanₖ x))
    ∙ cong (∑ x +_)
           (∑Dist- (replicateFinVec k (meanₖ x))
            ∙ cong (λ u → - u) (constSum (∑ x)))
    ∙ n2 (∑ x)

  splitₖ-fun : Vecₖ k → ⟨ R ⟩ × Vₖ k
  splitₖ-fun x = (meanₖ x , (devₖ x , devₖ-sum x))

  splitₖ-inv : ⟨ R ⟩ × Vₖ k → Vecₖ k
  splitₖ-inv (m , (v , _)) i = m + v i

  splitₖIso : Iso (Vecₖ k) (⟨ R ⟩ × Vₖ k)
  Iso.fun      splitₖIso = splitₖ-fun
  Iso.inv      splitₖIso = splitₖ-inv
  Iso.rightInv splitₖIso (m , (v , p)) =
    ≡-× meanPath
        (Σ≡Prop (λ w → isPropEq (∑ w) 0r)
                (funExt (λ i → cong (λ u → (m + v i) - u) meanPath
                               ∙ n3 m (v i))))
    where
    meanPath : meanₖ (splitₖ-inv (m , (v , p))) ≡ m
    meanPath =
        cong (kinv ·_)
             (∑Split (replicateFinVec k m) v
              ∙ cong (∑ (replicateFinVec k m) +_) p)
      ∙ n1 kinv (∑ (replicateFinVec k m))
      ∙ meanConst m
  Iso.leftInv  splitₖIso x = funExt (λ i → n4 (meanₖ x) (x i))

  -- **T14.8, general `k`.**
  splitₖ : Vecₖ k ≃ (⟨ R ⟩ × Vₖ k)
  splitₖ = isoToEquiv splitₖIso

 ---------------------------------------------------------------------
 -- 4.1  T14.11's OBSTRUCTION AT GENERAL k ≥ 3.
 --
 -- The same two eigenvectors as §3.1, now inside `Vₖ (n+3)`:
 -- `u = e₀ − e₁` and `v = e₀ + e₁ − 2e₂`.  The transposition `(0 1)`
 -- scales `u` by `−1` and fixes `v`, so it is scalar only if `−1 ≡ 1`.
 --
 -- No invertibility hypothesis, and no `mean` — this section does not
 -- use `kinv` at all, which is the point: the SPLIT needs `k` invertible,
 -- the non-scalarity does not.
 --
 -- Note that `∑`-invariance is proved HERE only for this one
 -- transposition, and by unfolding `∑` twice rather than by any general
 -- permutation lemma (v0.5 has none — see §4).  That is why the
 -- multiplicity half of T14.11 stays at k = 3 (§3.2): it needs a basis
 -- of `Vₖ`, not one vector pair.
 ---------------------------------------------------------------------

 module _ (n : ℕ) where

  private
    K : ℕ
    K = suc (suc (suc n))

    swSum : (a b s : ⟨ R ⟩) → b + (a + s) ≡ a + (b + s)
    swSum _ _ _ = solve! R
    us : (x : ⟨ R ⟩) → x + ((- x) + 0r) ≡ 0r
    us _ = solve! R
    vs : (x : ⟨ R ⟩) → x + (x + ((- (x + x)) + 0r)) ≡ 0r
    vs _ = solve! R
    vz : 0r ≡ 1r · 0r
    vz = lem 1r
      where
      lem : (x : ⟨ R ⟩) → 0r ≡ x · 0r
      lem _ = solve! R

  -- the transposition of the first two coordinates
  sw01ₖ : Vecₖ K → Vecₖ K
  sw01ₖ x fzero              = x (fsuc fzero)
  sw01ₖ x (fsuc fzero)       = x fzero
  sw01ₖ x (fsuc (fsuc i))    = x (fsuc (fsuc i))

  sw01ₖ-sum : (x : Vecₖ K) → ∑ (sw01ₖ x) ≡ ∑ x
  sw01ₖ-sum x =
    swSum (x fzero) (x (fsuc fzero)) (∑ (λ i → x (fsuc (fsuc i))))

  sw01ₖV : Vₖ K → Vₖ K
  sw01ₖV (x , p) = (sw01ₖ x , sw01ₖ-sum x ∙ p)

  scaleₖ : ⟨ R ⟩ → Vₖ K → Vₖ K
  scaleₖ c (x , p) =
    ((λ i → c · x i) , sym (∑Mulrdist c x) ∙ cong (c ·_) p ∙ scale-zero c)

  -- `u = e₀ − e₁`
  uK : Vecₖ K
  uK fzero           = 1r
  uK (fsuc fzero)    = - 1r
  uK (fsuc (fsuc i)) = 0r

  uK-sum : ∑ uK ≡ 0r
  uK-sum = cong (λ s → 1r + ((- 1r) + s)) (∑0r (suc n)) ∙ us 1r

  -- `v = e₀ + e₁ − 2e₂`
  vK : Vecₖ K
  vK fzero                  = 1r
  vK (fsuc fzero)           = 1r
  vK (fsuc (fsuc fzero))    = - (1r + 1r)
  vK (fsuc (fsuc (fsuc i))) = 0r

  vK-sum : ∑ vK ≡ 0r
  vK-sum = cong (λ s → 1r + (1r + ((- (1r + 1r)) + s))) (∑0r n) ∙ vs 1r

  uₖ vₖ : Vₖ K
  uₖ = (uK , uK-sum)
  vₖ = (vK , vK-sum)

  sw01ₖ-u : sw01ₖV uₖ ≡ scaleₖ (- 1r) uₖ
  sw01ₖ-u = Σ≡Prop (λ w → isPropEq (∑ w) 0r) (funExt lem)
    where
    lem : (i : Fin K) → sw01ₖ uK i ≡ (- 1r) · uK i
    lem fzero           = uc0
    lem (fsuc fzero)    = uc1
    lem (fsuc (fsuc i)) = uc2

  sw01ₖ-v : sw01ₖV vₖ ≡ scaleₖ 1r vₖ
  sw01ₖ-v = Σ≡Prop (λ w → isPropEq (∑ w) 0r) (funExt lem)
    where
    lem : (i : Fin K) → sw01ₖ vK i ≡ 1r · vK i
    lem fzero                  = vc0
    lem (fsuc fzero)           = vc0
    lem (fsuc (fsuc fzero))    = vc2
    lem (fsuc (fsuc (fsuc i))) = vz

  Scalar01ₖ : Type ℓ
  Scalar01ₖ = Σ[ c ∈ ⟨ R ⟩ ] ((x : Vₖ K) → sw01ₖV x ≡ scaleₖ c x)

  -- **T14.11's obstruction, at every k ≥ 3.**
  sw01ₖ-scalar→char2 : Scalar01ₖ → 1r + 1r ≡ 0r
  sw01ₖ-scalar→char2 (c , h) =
    char2lem 1r ∙ cong (λ u → 1r - u) neg1≡1 ∙ selfSub 1r
    where
    at0 : Vₖ K → ⟨ R ⟩
    at0 (x , _) = x fzero
    fromU : (- 1r) ≡ c
    fromU = cong at0 (h uₖ) ∙ c1 c
    fromV : 1r ≡ c
    fromV = cong at0 (h vₖ) ∙ c1 c
    neg1≡1 : (- 1r) ≡ 1r
    neg1≡1 = fromU ∙ sym fromV

 ---------------------------------------------------------------------
 -- 5.  T14.12, AND WHY IT IS NOT HERE.
 --
 -- Delta 14 T14.12 asserts
 --
 --     Σ_{j≥0} tr(τ | Symʲ V_k) tʲ  =  1 / ((1−t)^{k−2} (1+t)),
 --
 -- with `(−1)ʲ` at k = 2 and `1 / 0` alternating at k = 3.  It is NOT
 -- proved here and NOT approximated here.  The missing objects are
 -- specific, and naming them is more useful than gesturing:
 --
 --   * `Symʲ M` for a module `M` over a `CommRing`.  cubical v0.5 has
 --     `Cubical.Algebra.Module` but no symmetric power, no tensor
 --     algebra, and no graded quotient to build one from.
 --   * a TRACE.  A trace needs a finite basis and basis-independence;
 --     v0.5's `Cubical.Algebra.Matrix` has matrices but no trace or
 --     determinant theory for module endomorphisms.
 --   * the fact that `Symʲ` of a diagonalised rank-2 module has the
 --     monomial eigenbasis `{uⁱ v^{j−i}}`.  This is the actual content
 --     of T14.12 at k = 3, and it is a theorem ABOUT `Symʲ`, hence
 --     downstream of the first bullet.
 --
 -- Building all three is a module of its own.  Hand-rolling
 -- `Symʲ := free module on monomials, acting diagonally` and computing
 -- its trace would be MODELLING the answer rather than proving it —
 -- exactly the promotion `PerspectiveCore` refuses for T14.6's iff.
 --
 -- What CAN be checked, and is, is the arithmetic the trace reduces to
 -- at k = 3 once the eigenbasis is GRANTED: by §3.2 the diagonal entries
 -- on `Symʲ` are `(−1)ⁱ` for `i = 0 … j`, so the trace would be
 -- `Σ_{i≤j} (−1)ⁱ`, which is `1` for `j` even and `0` for `j` odd — the
 -- coefficients of `1/((1−t)(1+t)) = 1/(1−t²)`.  The two lemmas below
 -- are that identity in `R`.  They are terms; T14.12 is not.
 ---------------------------------------------------------------------

 -- `(−1)ʲ`
 negPow : ℕ → ⟨ R ⟩
 negPow zero    = 1r
 negPow (suc j) = (- 1r) · negPow j

 -- `Σ_{i=0}^{j} (−1)ⁱ`
 altSum : ℕ → ⟨ R ⟩
 altSum zero    = 1r
 altSum (suc j) = altSum j + negPow (suc j)

 dbl : ℕ → ℕ
 dbl zero    = zero
 dbl (suc n) = suc (suc (dbl n))

 private
   np1 : (x : ⟨ R ⟩) → (- 1r) · ((- 1r) · x) ≡ x
   np1 _ = solve! R
   ah  : (s p : ⟨ R ⟩) → (s + (- 1r) · p) + p ≡ s
   ah _ _ = solve! R
   a0  : (x : ⟨ R ⟩) → x + (- 1r) · x ≡ 0r
   a0 _ = solve! R

 negPow-two : (j : ℕ) → negPow (suc (suc j)) ≡ negPow j
 negPow-two j = np1 (negPow j)

 -- the two-step recursion: `Σ_{i≤j+2} (−1)ⁱ = Σ_{i≤j} (−1)ⁱ`
 altSum-two : (j : ℕ) → altSum (suc (suc j)) ≡ altSum j
 altSum-two j =
   cong (λ u → (altSum j + (- 1r) · negPow j) + u) (negPow-two j)
   ∙ ah (altSum j) (negPow j)

 altSum-even : (n : ℕ) → altSum (dbl n) ≡ 1r
 altSum-even zero    = refl
 altSum-even (suc n) = altSum-two (dbl n) ∙ altSum-even n

 altSum-odd : (n : ℕ) → altSum (suc (dbl n)) ≡ 0r
 altSum-odd zero    = a0 1r
 altSum-odd (suc n) = altSum-two (suc (dbl n)) ∙ altSum-odd n
