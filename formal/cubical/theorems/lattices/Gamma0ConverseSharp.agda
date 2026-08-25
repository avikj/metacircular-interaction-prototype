{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Gamma0ConverseSharp
--
-- An anatomy of the two scope conditions of `Gamma0Converse`.
--
-- `Gamma0Converse` proves: if some integral K satisfies H·D·K ≡ D for
-- D = diag(d₁, q·d₁), then q | c (c = H₂₁).  It hangs that on two
-- hypotheses, d₁ ≠ 0 and ε² = 1 (ε = det H).  Exactly one of them is
-- load-bearing.
--
--   * `hε : ε · ε ≡ 1r` is never mentioned in the proof term of
--     `Gamma0Converse` (read it: `factor` uses only `hdet`).  §1 below
--     restates the converse with NO determinant hypothesis at all —
--     over every H ∈ M₂(ℤ), not just GL₂(ℤ) — and the witness is the
--     same one.
--
--   * `d1n : d₁ ≡ 0r → ⊥` is forced.  §4 is the control: at d₁ = 0 the
--     stabilization hypothesis is satisfied by EVERY (H,K) (`vacuous`),
--     so nothing can be concluded, and the conclusion is in fact false
--     there (`noDivision`: 2 ∤ 1, by parity).
--
-- The interesting part is WHERE the dead hypothesis would have bitten.
--
--   * §2 `unitForced`: as soon as q ≠ 0, the stabilization equation
--     ITSELF forces det H · det K ≡ 1 — H is invertible over ℤ.
--     Unimodularity is a consequence of the Γ₀ equation, not an
--     ambient assumption on it.  §2b adds the ℤ unit classification
--     (`unitSquare`, via `abs`), giving `Derived.epsSquare`:
--
--         d₁ ≠ 0, q ≠ 0, H·D·K ≡ D   ⊢   det H · det H ≡ 1r
--
--     which is `hε` on the nose.  So on the whole intended domain
--     (q = d₂/d₁ a nonzero level) `hε` is not merely unused: it is a
--     THEOREM.  Any statement in this lane whose hypotheses already
--     include the stabilization equation carries `hε` as a consequence
--     of its own other hypotheses — `Gamma0Converse` here, and
--     `Gamma0PartnerRigidity` §2 inside its inner `hstab` module.
--     `Gamma0Partner` is the exception: it is handed a witness, not a
--     stabilizer, and §3b shows its `hε` really is forced.
--
--   * §3 `q0` is the exception, and it is nonempty: at q = 0 — the
--     §1 sets aside as "degenerate strata for contrast" — the matrix
--     H = diag(1,5) two-sidedly stabilizes D = diag(1,0) with the
--     integral partner K = ((1,0),(0,0)), and det H = 5 is not a unit.
--     Every hypothesis of `Gamma0Converse` except `hε` holds; `hε`
--     fails.  So deleting `hε` genuinely widens the theorem, and the
--     locus of the widening is exactly the degenerate stratum.  The
--     same witness has det H · det K = 5 · 0 = 0 (`notForced`), so §2's
--     own `q ≠ 0` is load-bearing: this is the single point where the
--     two halves of the R0033 iff come apart.
--
-- Summary: the Γ₀ converse is a statement about M₂(ℤ), and the group
-- GL₂(ℤ) it is usually stated inside is recovered for free off the
-- degenerate stratum and is simply wrong to impose on it.
--
-- Nothing in `Gamma0Converse.agda` or `Gamma0Partner.agda` is edited by
-- this module; it only imports them.
------------------------------------------------------------------------

module Gamma0ConverseSharp where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Data.Sum using (_⊎_) renaming (rec to ⊎rec)
open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; snotz ; znots ; injSuc ; +-suc ; 0≡m·0)
  renaming (_·_ to _·ℕ_ ; _+_ to _+ℕ_)
open import Cubical.Data.Int
  using (ℤ ; pos ; injPos ; isIntegralℤ ; isEven ; abs ; abs· ; abs→⊎)
open import Cubical.Data.Int.IsEven using (trueIsEven)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (det ; detMul ; oneNotZero)

open CommRingStr (ℤCommRing .snd)

-- solver lemmas: pure polynomial regroupings over ℤ -------------------

private
  regA : (a b c e d1 q k11 k21 : R)
       → c · ((a · d1 + b · 0r) · k11 + (a · 0r + b · (q · d1)) · k21)
         - a · ((c · d1 + e · 0r) · k11 + (c · 0r + e · (q · d1)) · k21)
         ≡ (b · c - a · e) · ((q · d1) · k21)
  regA _ _ _ _ _ _ _ _ = solve! ℤCommRing

  regB : (a c d1 : R) → c · d1 - a · 0r ≡ c · d1
  regB _ _ _ = solve! ℤCommRing

  regNeg : (a b c e : R) → b · c - a · e ≡ - (a · e - b · c)
  regNeg _ _ _ _ = solve! ℤCommRing

  regZ : (c d1 q ε k21 : R)
       → d1 · (c - (- (ε · k21)) · q)
         ≡ c · d1 - (- ε) · ((q · d1) · k21)
  regZ _ _ _ _ _ = solve! ℤCommRing

  cancelSelf : (x : R) → x - x ≡ 0r
  cancelSelf _ = solve! ℤCommRing

  regF : (c kq : R) → c ≡ (c - kq) + kq
  regF _ _ = solve! ℤCommRing

  zeroL : (x : R) → 0r + x ≡ x
  zeroL _ = solve! ℤCommRing

  commL : (x y : R) → x · y ≡ y · x
  commL _ _ = solve! ℤCommRing

  dsimp : (x y : R) → x · y - 0r · 0r ≡ x · y
  dsimp _ _ = solve! ℤCommRing

  -- (the ring solver of cubical v0.5 will not take `1r` on the right of
  -- a `·` inside a goal it has to normalize — the documented ℤ-solver
  -- weakness — so `1r` is kept out of every solver call and the unit law
  -- is taken from the structure instead)
  dist2 : (p x y : R) → p · (x - y) ≡ p · x - p · y
  dist2 _ _ _ = solve! ℤCommRing

  pmul : (d k p : R) → p · (d · k) ≡ (d · p) · k
  pmul _ _ _ = solve! ℤCommRing

------------------------------------------------------------------------
-- §1.  The converse with no determinant hypothesis.
--
-- Identical to `Gamma0Converse.membership` with the module parameters
-- `ε`, `hdet`, `hε` deleted and ε read off as `a · e - b · c`.  The
-- proof term is the same; `hε` was never in it.
------------------------------------------------------------------------

module Sharp (a b c e d1 q : R)
             (k11 k12 k21 k22 : R)
             (d1n : (d1 ≡ 0r) → ⊥)
             (hstab : mul (mul (a , b , c , e) (dia d1 (q · d1)))
                          (k11 , k12 , k21 , k22)
                      ≡ dia d1 (q · d1)) where

  ε : R
  ε = a · e - b · c

  e11 : (a · d1 + b · 0r) · k11 + (a · 0r + b · (q · d1)) · k21 ≡ d1
  e11 i = fst (hstab i)

  e21 : (c · d1 + e · 0r) · k11 + (c · 0r + e · (q · d1)) · k21 ≡ 0r
  e21 i = fst (snd (snd (hstab i)))

  chain : (b · c - a · e) · ((q · d1) · k21) ≡ c · d1
  chain = sym (regA a b c e d1 q k11 k21)
          ∙ cong₂ (λ x y → c · x - a · y) e11 e21
          ∙ regB a c d1

  main : (- ε) · ((q · d1) · k21) ≡ c · d1
  main = cong (_· ((q · d1) · k21)) (sym (regNeg a b c e)) ∙ chain

  zeroprod : d1 · (c - (- (ε · k21)) · q) ≡ 0r
  zeroprod = regZ c d1 q ε k21
             ∙ cong (λ x → c · d1 - x) main
             ∙ cancelSelf (c · d1)

  diff0 : c - (- (ε · k21)) · q ≡ 0r
  diff0 = isIntegralℤ d1 (c - (- (ε · k21)) · q) zeroprod d1n

  -- q | c, with its witness, for EVERY integer matrix H
  membership : Σ[ k ∈ R ] c ≡ k · q
  membership = - (ε · k21)
             , (regF c ((- (ε · k21)) · q)
                ∙ cong (_+ ((- (ε · k21)) · q)) diff0
                ∙ zeroL ((- (ε · k21)) · q))

------------------------------------------------------------------------
-- §2.  Off the degenerate stratum the deleted hypothesis is a theorem:
--      stabilization forces det H to be a unit of ℤ.
------------------------------------------------------------------------

module Forced (H K : M) (d1 q : R)
              (d1n : (d1 ≡ 0r) → ⊥)
              (qn : (q ≡ 0r) → ⊥)
              (hstab : mul (mul H (dia d1 (q · d1))) K ≡ dia d1 (q · d1)) where

  D : M
  D = dia d1 (q · d1)

  P : R
  P = d1 · (q · d1)

  detD : det D ≡ P
  detD = dsimp d1 (q · d1)

  Pn : (P ≡ 0r) → ⊥
  Pn h = qn (isIntegralℤ d1 q
               (commL d1 q ∙ isIntegralℤ d1 (q · d1) h d1n) d1n)

  key : (det H · P) · det K ≡ P
  key = cong (λ z → (det H · z) · det K) (sym detD)
        ∙ sym (detMul (mul H D) K ∙ cong (_· det K) (detMul H D))
        ∙ cong det hstab
        ∙ detD

  zprod : P · (det H · det K - 1r) ≡ 0r
  zprod = dist2 P (det H · det K) 1r
          ∙ cong (λ z → P · (det H · det K) - z) (·IdR P)
          ∙ cong (_- P) (pmul (det H) (det K) P)
          ∙ cong (_- P) key
          ∙ cancelSelf P

  -- H is invertible over ℤ: no unimodularity was assumed anywhere
  unitForced : det H · det K ≡ 1r
  unitForced = regF (det H · det K) 1r
               ∙ cong (_+ 1r) (isIntegralℤ P (det H · det K - 1r) zprod Pn)
               ∙ zeroL 1r

------------------------------------------------------------------------
-- §2b.  ℤ has only the units ±1, so "det H is a unit" IS `hε`.
--       With §2 this makes `hε : ε · ε ≡ 1r` a THEOREM of the
--       stabilization equation whenever d₁ ≠ 0 and q ≠ 0 — it can be
--       deleted from any statement over that domain, not merely from
--       `Gamma0Converse` where it was already inert.
------------------------------------------------------------------------

private
  natUnit : (m n : ℕ) → m ·ℕ n ≡ 1 → m ≡ 1
  natUnit zero n p = ⊥rec (znots p)
  natUnit (suc zero) n p = refl
  natUnit (suc (suc m)) zero p = ⊥rec (znots (0≡m·0 (suc (suc m)) ∙ p))
  natUnit (suc (suc m)) (suc n) p =
    ⊥rec (snotz (sym (+-suc n (n +ℕ m ·ℕ suc n)) ∙ injSuc p))

unitSquare : (x y : R) → x · y ≡ 1r → x · x ≡ 1r
unitSquare x y p =
  ⊎rec (λ r → cong₂ _·_ r r) (λ r → cong₂ _·_ r r)
       (abs→⊎ x 1 (natUnit (abs x) (abs y) (sym (abs· x y) ∙ cong abs p)))

module Derived (H K : M) (d1 q : R)
               (d1n : (d1 ≡ 0r) → ⊥)
               (qn : (q ≡ 0r) → ⊥)
               (hstab : mul (mul H (dia d1 (q · d1))) K ≡ dia d1 (q · d1)) where

  open Forced H K d1 q d1n qn hstab using (unitForced)

  -- exactly the hypothesis `hε` of Gamma0Converse and Gamma0Partner
  epsSquare : det H · det H ≡ 1r
  epsSquare = unitSquare (det H) (det K) unitForced

------------------------------------------------------------------------
-- §3.  The exception is nonempty: at q = 0 a non-unimodular H really
--      does two-sidedly stabilize.  So §1 is a strict widening, and
--      §2's `q ≠ 0` cannot be dropped.
------------------------------------------------------------------------

module q0 where

  Hbad Kbad : M
  Hbad = (1r , 0r , 0r , pos 5)
  Kbad = (1r , 0r , 0r , 0r)

  Dbad : M
  Dbad = dia 1r (0r · 1r)

  -- every hypothesis of Gamma0Converse except hε, on concrete integers
  hd1 : (1r ≡ 0r) → ⊥
  hd1 = oneNotZero

  hstab : mul (mul Hbad Dbad) Kbad ≡ Dbad
  hstab = refl

  detHbad : det Hbad ≡ pos 5
  detHbad = refl

  -- ... and hε fails: 5 is not a unit of ℤ
  notUnimodular : (det Hbad · det Hbad ≡ 1r) → ⊥
  notUnimodular p = snotz (injSuc (injPos p))

  -- so §2's own scope condition `q ≠ 0` is load-bearing too: here
  -- det H · det K = 5 · 0 = 0, and `unitForced` fails
  notForced : (det Hbad · det Kbad ≡ 1r) → ⊥
  notForced p = znots (injPos p)

  -- the conclusion still holds, by §1, with witness k = 0
  divides : Σ[ k ∈ R ] 0r ≡ k · 0r
  divides = Sharp.membership 1r 0r 0r (pos 5) 1r 0r 1r 0r 0r 0r hd1 hstab

------------------------------------------------------------------------
-- §3b.  The mirror control: in the FORWARD direction `hε` is forced.
--
-- `Gamma0Partner` is handed a divisibility witness, not a stabilizer,
-- so §2 does not apply to it and its `hε` is a real hypothesis.  The
-- same matrix diag(1,5) shows it cannot be dropped: at q = 3 it has a
-- witness (c = 0 = 0·3) and, by §2, no integral partner whatsoever.
--
-- So the R0033 iff is asymmetric.  `hε` is INPUT to the forward
-- direction and OUTPUT of the converse — one hypothesis, two opposite
-- logical roles, which is why deleting it from `Gamma0Converse` is safe
-- and deleting it from `Gamma0Partner` is not.
------------------------------------------------------------------------

module partnerForced where

  Hb : M
  Hb = (1r , 0r , 0r , pos 5)

  three : (pos 3 ≡ 0r) → ⊥
  three p = snotz (injPos p)

  noPartner : (K : M)
            → mul (mul Hb (dia 1r (pos 3 · 1r))) K ≡ dia 1r (pos 3 · 1r)
            → ⊥
  noPartner K hs =
    q0.notUnimodular
      (unitSquare (det Hb) (det K)
        (Forced.unitForced Hb K 1r (pos 3) q0.hd1 three hs))

------------------------------------------------------------------------
-- §4.  Control for the OTHER hypothesis: d₁ ≠ 0 is load-bearing.
--      At d₁ = 0 the stabilization hypothesis is satisfied by every
--      pair (H,K), so it carries no information, and the conclusion is
--      false: taking q = 2 and c = 1 would assert 2 | 1.
------------------------------------------------------------------------

private
  v11 : (a b c e k11 k21 q : R)
      → (a · 0r + b · 0r) · k11 + (a · 0r + b · (q · 0r)) · k21 ≡ 0r
  v11 _ _ _ _ _ _ _ = solve! ℤCommRing
  v12 : (a b c e k12 k22 q : R)
      → (a · 0r + b · 0r) · k12 + (a · 0r + b · (q · 0r)) · k22 ≡ 0r
  v12 _ _ _ _ _ _ _ = solve! ℤCommRing
  v21 : (a b c e k11 k21 q : R)
      → (c · 0r + e · 0r) · k11 + (c · 0r + e · (q · 0r)) · k21 ≡ 0r
  v21 _ _ _ _ _ _ _ = solve! ℤCommRing
  v22 : (a b c e k12 k22 q : R)
      → (c · 0r + e · 0r) · k12 + (c · 0r + e · (q · 0r)) · k22 ≡ q · 0r
  v22 _ _ _ _ _ _ _ = solve! ℤCommRing

vacuous : (H K : M) (q : R) → mul (mul H (dia 0r (q · 0r))) K ≡ dia 0r (q · 0r)
vacuous (a , b , c , e) (k11 , k12 , k21 , k22) q i =
  ( v11 a b c e k11 k21 q i
  , v12 a b c e k12 k22 q i
  , v21 a b c e k11 k21 q i
  , v22 a b c e k12 k22 q i )

-- and the conclusion it would license at d₁ = 0 is false
noDivision : Σ[ k ∈ R ] 1r ≡ k · pos 2 → ⊥
noDivision (k , p) =
  true≢false (sym (trueIsEven (pos 1) (k , (p ∙ commL k (pos 2)))))
