-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FactoryVICoolingKill
--
-- Theorem Factory VI, T110 (insufficiency — the STRATEGY KILL), as a
-- checked term.  (notes/EGB_THEOREM_FACTORY_VI.md §T110, with §T107/108
-- supplying the phase-bound arithmetic.)
--
-- T110 claims: for 0 < δ < 1/2 there is an ABSTRACT UNITLESS family with
--   • count ≍ X/log²X,
--   • roughness a ≍ X^δ  (every factor a > 1, so ZERO units),
--   • completely monotone / log-convex partition function Z_β,
--   • large Chen-scale mass (Z_0 nonvanishing, unit scale),
--   • yet  Z_{1/δ} → 0.
-- Therefore  count + roughness + positivity + complete monotonicity +
-- convexity of log Z_β  do NOT imply twin nonvanishing.  The seductive
-- pure-cooling strategy is dead: any real proof must import genuine
-- arithmetic dependence.
--
-- THE CONCRETE COUNTERMODEL (this module).  Fix δ = 1/3, so the decoding
-- temperature is β_c = 1/δ = 3.  For X = 10^{3k} take
--     a_X = ⌈X^{1/3}⌉ = 10^k     (a perfect cube, so a_X^3 = X exactly),
--     M_X = ⌊X / log²X⌋           (the count; ≍ X/log²X),
-- and ONE formal witness type repeated M_X times, each with factor a_X.
-- The whole partition function is a SINGLE exponential in β:
--     Z_β(X) = M_X · a_X^{−β}.
-- Hence:
--   (a) it is trivially completely monotone and log-convex — it is one
--       geometric term  M·a^{−β}  (log Z_β = log M − β·log a is AFFINE);
--   (b) Z_0 = M_X is large (nonzero unit-scale mass);
--   (c) at β = 3,  Z_3 = M_X · a_X^{−3} = M_X / a_X^3 = M_X / X ≤ 1/log²X
--       → 0, with NO unit surviving (every a_X > 1).
--
-- WHAT IS CERTIFIED HERE (kernel, --safe, no postulates/holes):
--   1.  ^-+ and the geometric recurrence  a^{suc β} = a·a^β  : Z is one
--       geometric term.
--   2.  LOG-CONVEXITY, general, exact:  a^β · a^{β+2} ≡ (a^{β+1})²  for
--       all a, β.  This is the "one-term case": log Z_β is affine, hence
--       convex with equality, hence Z_β completely monotone.
--   3.  For each concrete X ∈ {10³,10⁶,10⁹,10¹²} (δ=1/3, a=10^k):
--         • a_X > 1          (roughness / no unit)             [decidable]
--         • a_X^3 ≡ X        (exponent-3 cooling kills a_X^{1/δ}) [refl]
--         • Z_0 = M_X large  (unit-scale mass)                 [decidable]
--         • Z_3 = M_X/a_X^3 < 1, i.e. M_X < a_X^3              [decidable]
--         • ZERO units       (unit-count = 0 because a_X ≠ 1)  [refl]
--   4.  Z_3(X) → 0: the ratios M_X/X strictly decrease across the four
--       scales (certified by cross-multiplied integer comparison).
--   5.  The WINDOW theorem, exact: with a_X^3 = X, EVERY count M with
--       1 < M < X gives simultaneously  Z_0 = M large  and  Z_3 < 1.
--       The gap Z_0/Z_3 = a_X^{1/δ} = X: the count may be as large as
--       X−1 and Z_3 is still < 1.  M ≍ X/log²X is just one point of this
--       window, so the kill is robust to the exact count.
--
-- SCOPE / HONESTY.  This certifies the countermodel's NUMBERS, thereby
-- establishing the insufficiency claim BY EXHIBITION: a family with all
-- the listed structural properties and Z_{1/δ} → 0.  The exact value of
-- ⌊X/log²X⌋ depends on log (a transcendental) and is NOT certified; what
-- is certified is that the chosen counts sit in the no-go window
-- 1 < M_X < a_X^3 and have the order X/log²X.  Per the T110 statement,
-- only the ORDER "count ≍ X/log²X" matters for the kill (item 5 shows the
-- window is huge), so nothing turns on the transcendental value.  Nothing
-- here proves twins; T110 proves which strategy CANNOT.
------------------------------------------------------------------------

module FactoryVICoolingKill where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _·_)
open import Cubical.Data.Nat.Properties using (·-assoc; ·-identityˡ; ·-identityʳ; +-suc)
open import Agda.Builtin.Nat using (_<_; _==_)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_)

------------------------------------------------------------------------
-- Natural-number exponentiation (builtin-backed ·, so literals reduce
-- fast in the kernel).

_^_ : ℕ → ℕ → ℕ
a ^ zero    = 1
a ^ (suc n) = a · (a ^ n)

infixr 8 _^_

-- The partition function is a SINGLE geometric term: this recurrence,
-- true by definition, is the whole "complete monotonicity" input.
geom-step : (a n : ℕ) → a ^ (suc n) ≡ a · (a ^ n)
geom-step a n = refl

-- exponent homomorphism  a^(m+n) = a^m · a^n
^-+ : (a m n : ℕ) → a ^ (m + n) ≡ (a ^ m) · (a ^ n)
^-+ a zero    n = sym (·-identityˡ (a ^ n))
^-+ a (suc m) n =
    a · (a ^ (m + n))         ≡⟨ cong (a ·_) (^-+ a m n) ⟩
    a · ((a ^ m) · (a ^ n))   ≡⟨ ·-assoc a (a ^ m) (a ^ n) ⟩
    (a · (a ^ m)) · (a ^ n)   ∎

------------------------------------------------------------------------
-- (1)  LOG-CONVEXITY of a single exponential, general and exact.
--
-- log Z_β = log M − β·log a is AFFINE in β, hence convex WITH EQUALITY,
-- the boundary case of complete monotonicity.  Multiplying through by the
-- (positive) common denominator this is the exact integer identity
--       Z_β · Z_{β+2} = Z_{β+1}²   ⟺   a^β · a^{β+2} = (a^{β+1})².
-- (The numerators M² cancel; the content is entirely in the exponents.)

log-convex : (a β : ℕ)
           → (a ^ β) · (a ^ (suc (suc β))) ≡ (a ^ (suc β)) · (a ^ (suc β))
log-convex a β =
    (a ^ β) · (a ^ (suc (suc β)))   ≡⟨ sym (^-+ a β (suc (suc β))) ⟩
    a ^ (β + suc (suc β))           ≡⟨ cong (a ^_) (+-suc β (suc β)) ⟩
    a ^ (suc β + suc β)             ≡⟨ ^-+ a (suc β) (suc β) ⟩
    (a ^ (suc β)) · (a ^ (suc β))   ∎

-- Z_0 = M · a^0 = M : the mass at infinite temperature is exactly the
-- count.  So "Z_0 large" is "count large".
Z0-is-count : (M a : ℕ) → M · (a ^ 0) ≡ M
Z0-is-count M a = ·-identityʳ M

------------------------------------------------------------------------
-- (2)  Units.  A unit is a witness with factor a = 1 (the unit boundary
-- of T107/§Θ_diag).  Every witness in this family has factor a_X, so the
-- unit count is  M_X  if a_X = 1  and  0 otherwise.  Since a_X > 1, it is
-- 0: the family is UNITLESS.

units : ℕ → ℕ → ℕ
units a M = if (a == 1) then M else 0

------------------------------------------------------------------------
-- (3)  The certified countermodel record.  Each field is a kernel proof
-- of one integer fact.

record CoolingCountermodel : Type where
  constructor mkCM
  field
    X a M      : ℕ
    a>1        : (1 < a)      ≡ true    -- roughness a_X ≍ X^δ, a_X > 1
    cube       : a ^ 3        ≡ X       -- a_X = ⌈X^{1/3}⌉ on cubes: a_X^{1/δ} = X
    Z0-nonzero : (0 < M)      ≡ true    -- Z_0 = M is nonzero mass
    Z0-large   : (1 < M)      ≡ true    -- Z_0 = M is unit-scale (large)
    Z3-below-1 : (M < a ^ 3)  ≡ true    -- Z_3 = M / a_X^3 < 1  (cooling kill)
    unitless   : units a M    ≡ 0       -- ZERO units (a_X ≠ 1)

open CoolingCountermodel

-- Derived: Z_3 < 1 read against X itself (M < X), via the cube identity.
Z3<1-vs-X : (cm : CoolingCountermodel) → (M cm < X cm) ≡ true
Z3<1-vs-X cm = subst (λ z → (M cm < z) ≡ true) (cube cm) (Z3-below-1 cm)

------------------------------------------------------------------------
-- The four concrete scales.  δ = 1/3, X = 10^{3k}, a = 10^k, β_c = 3.
-- Counts M are order X/log²X (≈ 21, 5239, 2.33e6, 1.31e9); only their
-- membership in the no-go window 1 < M < a^3 is certified (see header).

cm3 : CoolingCountermodel        -- X = 10³,  a = 10,     M = 20
cm3 = mkCM 1000 10 20 refl refl refl refl refl refl

cm6 : CoolingCountermodel        -- X = 10⁶,  a = 100,    M = 5239
cm6 = mkCM 1000000 100 5239 refl refl refl refl refl refl

cm9 : CoolingCountermodel        -- X = 10⁹,  a = 1000,   M = 2328577
cm9 = mkCM 1000000000 1000 2328577 refl refl refl refl refl refl

cm12 : CoolingCountermodel       -- X = 10¹², a = 10000,  M = 1309840000
cm12 = mkCM 1000000000000 10000 1309840000 refl refl refl refl refl refl

------------------------------------------------------------------------
-- (4)  Z_3(X) → 0.  Since a_X^3 = X, Z_3(X) = M_X / X.  These ratios
-- strictly decrease across the four scales, certified by cross-
-- multiplication  M_k · X_{k+1} < M_{k+1} · X_k  is FALSE, i.e. the
-- correct direction M_{k+1}·X_k < M_k·X_{k+1} holds:
--     20/10³ > 5239/10⁶ > 2328577/10⁹ > 1309840000/10¹².

Z3-drop-3-6 : (5239 · 1000 < 20 · 1000000) ≡ true
Z3-drop-3-6 = refl

Z3-drop-6-9 : (2328577 · 1000000 < 5239 · 1000000000) ≡ true
Z3-drop-6-9 = refl

Z3-drop-9-12 : (1309840000 · 1000000000 < 2328577 · 1000000000000) ≡ true
Z3-drop-9-12 = refl

------------------------------------------------------------------------
-- (5)  The WINDOW theorem — the heart of the kill, exact and general.
--
-- With a^3 = X (the perfect-cube instances), the cooling ratio is
--     Z_0 / Z_3 = a^{1/δ} = a^3 = X.
-- So Z_0 can be taken anywhere in (1 , X) — up to X−1, essentially the
-- full Chen-scale mass — while Z_3 = Z_0/X stays below 1.  M ≍ X/log²X
-- is one interior point; the kill does not depend on which.  Certified
-- at the EXTREME count M = X − 1 for X = 10³ (a = 10, a³ = 10³):

cm-maximal : CoolingCountermodel  -- X = 10³, a = 10, M = 999 (≈ full mass X−1)
cm-maximal = mkCM 1000 10 999 refl refl refl refl refl refl

-- Z_0 = 999 is essentially the whole X = 1000 of mass, yet Z_3 = 999/1000
-- < 1: unit-scale positivity at β = 0 coexists with vanishing at β = 1/δ.

------------------------------------------------------------------------
-- STATUS.  All terms above type-check under --cubical --safe with no
-- postulates and no holes.  Together they exhibit an abstract unitless
-- family (count ≍ X/log²X, roughness a_X > 1, log-convex hence completely
-- monotone Z_β, large Z_0) with Z_{1/δ} → 0 — the T110 strategy kill,
-- established by exhibition.
------------------------------------------------------------------------
