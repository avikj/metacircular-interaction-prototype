{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PeirceGluing — the charge-gluing defect is exactly the off-sector
-- mass, and fixed-charge projection is linear but not multiplicative.
--
-- SOURCES, quoted exactly.
--
-- (1) D0026 §5.11, boxed.  With `C|n⟩ = Ω(n)|n⟩` the charge operator,
--     `Π_r` the projector onto charge r, `P = Π₁`, `Q = 1 − P`, and `U_h`
--     the shift:
--
--       "PU_hPU_kP − PU_{h+k}P = −PU_hQU_kP"
--
--       "PU_{h+k}P − PU_hPU_kP = 𝛍_{h,k}(ℕ∖{1}) — the arithmetic gluing
--        defect is exactly the total non-prime intermediate charge mass"
--
--     where `𝛍_{h,k} = Σ_r PU_hΠ_rU_kP δ_r`.
--
-- (2) D0018 T18.7:
--
--       "M^{(h+k)}_{1,1} = Σ_r M^{(h)}_{1,r} M^{(k)}_{r,1}; charge-one
--        propagation is closed under composition iff all off-sector
--        excursion-return terms vanish".
--
-- (3) D0015 §15.8, listed by the corpus as NOT YET TOUCHED:
--
--       "fixed-charge coefficient extraction
--        Π_c(FG) = Σ_{i+j=c} Π_i(F)Π_j(G); Π_c linear but not
--        multiplicative".
--
-- WHAT THE CORPUS ALREADY HAS.  `DynamicDescent` (2×2 over ℤ: the
-- defect is the single number bc), `ExcursionReturn` (K_tK_s − K_{t+s}
-- = −P T_t Q T_s i over an abstract ring) and `CompressionDefect`
-- (T18.4 with an idempotent e and complement q) are all the TWO-sector
-- case: one retained sector, one complement.  D0026 and T18.7 are the
-- n-sector case, where the complement is itself graded by charge and
-- the defect is a SUM over the intermediate charges.  That sum is what
-- is checked here.
--
-- WHAT IS PROVED (all --safe, no postulates, no holes).
--
--   §0  FiniteSums — sums over `Fin n` via `Cubical.Algebra.Ring.BigOps`
--       (`∑ = foldrFin _+_ 0r`).  `zeroAt r V` is V with its r-th entry
--       replaced by 0r, so `∑ (zeroAt r V)` is the sum over s ≠ r:
--         zeroAt-diag     zeroAt r V r ≡ 0r
--         zeroAt-off      s ≠ r → zeroAt r V s ≡ V s
--         ∑pick           ∑ V ≡ V r + ∑ (zeroAt r V)
--         ∑≢0→¬¬witness   ∑ V ≢ 0 → ¬¬ Σ s. V s ≢ 0      (constructive)
--         ∑≢0→witness     Discrete R → ∑ V ≢ 0 → Σ s. V s ≢ 0  (sharp)
--
--   §1  Peirce — any ring R, any finite family e : Fin n → R that is
--       complete (∑ e ≡ 1r) and idempotent (e r · e r ≡ e r).  Writing
--       term r a b s = e_r a e_s b e_r, K r a = e_r a e_r and
--       off r a b = zeroAt r (term r a b):
--         peirce          e_r (a b) e_r ≡ Σ_s e_r a e_s b e_r
--         peirce-block    e_r (a b) e_r ≡ Σ_s (e_r a e_s)(e_s b e_r)
--         KK              (e_r a e_r)(e_r b e_r) ≡ term r a b r
--         gluing          e_r (a b) e_r − (e_r a e_r)(e_r b e_r)
--                           ≡ Σ_{s≠r} e_r a e_s b e_r
--         off-is-Q        Σ_{s≠r} e_r a e_s b e_r ≡ e_r a (1 − e_r) b e_r
--         boxed           (e_r a e_r)(e_r b e_r) − e_r (a b) e_r
--                           ≡ −(e_r a (1 − e_r) b e_r)         [D0026 box]
--         closure→off0, off0→closure   the iff of T18.7
--         Arithmetic.T18-7  M^{(h+k)}_{r,r} ≡ Σ_s M^{(h)}_{r,s} M^{(k)}_{s,r}
--                           for any U : ℕ → R with U_h U_k ≡ U_{h+k}
--         Arithmetic.gluing-arith   the D0026 second line, with the
--                           right-hand side the sum over s ≠ r
--         Arithmetic.closure-iff-arith   closure of M^{(h)}_{r,r} under
--                           composition forces the off-sector sum to 0
--       and the honest converse of T18.5:
--         off≢0→¬¬witness   Σ_{s≠r} e_r a e_s b e_r ≢ 0
--                           → ¬¬ Σ[ s ] (s ≠ r) × (e_r a e_s b e_r ≢ 0)
--         nonclosure→¬¬witness   the same from failure of closure
--         off≢0→witness     Discrete R → the witness itself (search)
--
--   §2  Two — the n = 2 instance: P + Q ≡ 1, P and Q idempotent.  The
--       off-sector sum at r = 0 collapses to the single term P a Q b P:
--         defect₂            P (a b) P − (P a P)(P b P) ≡ P a Q b P
--         dynamicDescent-shape  (P T P)² − P T² P ≡ −(P T Q T P)
--       which is `DynamicDescent.twoStepDefect` as an operator identity.
--
--   §3  Matrix2 — the same in the library's `FinMatrixRing 2` over ℤ
--       with P = diag(1,0), Q = diag(0,1), T = (a b / c d): the (0,0)
--       entry of the general defect is the number bc:
--         recovered          [P T² P − (P T P)²]₀₀ ≡ b · c
--         recovered-signed   [(P T P)² − P T² P]₀₀ ≡ −(b · c)
--         markov-entry       [(P T P)²]₀₀ ≡ a · a     (= markovSquare a)
--         twoStep-entry      [P T² P]₀₀ ≡ a · a + b · c (= trueTwoStep)
--       so DynamicDescent's scalar identity is the n = 2, r = 0, (0,0)
--       entry of `gluing`.  P, Q are also checked orthogonal there.
--
--   §4  Graded — charge-graded sequences F : ℕ → R with F c the charge-c
--       piece, Π c F = F c, and the Cauchy product
--       (F ⊠ G) c = Σ_{i : Fin (suc c)} F i · G (c ∸ i):
--         Π-add, Π-scale   Π_c is additive and R-linear   (both refl)
--         Π-conv           Π_c (F ⊠ G) ≡ Σ_i Π_i F · Π_{c∸i} G   (refl:
--                          D0015's formula IS the definition's content)
--         index-sum        every summand has i + (c ∸ i) ≡ c
--       and over ℤ with ind₁ the indicator of charge 1:
--         Π₁conv           Π_1 (ind₁ ⊠ ind₁) ≡ 0
--         Π₁prod           Π_1 ind₁ · Π_1 ind₁ ≡ 1
--         Π-not-mult       Π_1 (ind₁ ⊠ ind₁) ≢ Π_1 ind₁ · Π_1 ind₁
--         Π-not-mult-∀     ¬ ∀ F G c. Π_c (F ⊠ G) ≡ Π_c F · Π_c G
--
-- WHAT IS NOT PROVED, exactly.
--
--  * Orthogonality (e_r e_s ≡ 0 for r ≠ s) is part of the hypothesis
--    "complete orthogonal family of idempotents" in the task and in
--    D0026, and it is NEVER USED: every identity in §1 holds for any
--    complete family of idempotents.  It is therefore not a field of
--    `SectorFamily`; the instances in §2/§3 prove it separately
--    (`orth₂`, `PQ0`, `QP0`) so that they are genuine sector families.
--    Proving under fewer hypotheses is a strengthening, not a change of
--    statement.
--
--  * The converse of T18.5 is proved at the RING level and with a
--    double negation: from "the off-sector sum is not zero" one gets
--    ¬¬(some off-sector component is nonzero), not the component.  The
--    price is genuine: a sum of n ring elements being nonzero does not
--    constructively locate a nonzero summand unless equality in R is
--    decidable (`off≢0→witness`) or otherwise stable.  What
--    `CompressionDefect` calls open — a STATE in a module that changes a
--    future observation — is still not touched: there is no module,
--    no state, no observation here, only ring elements.
--
--  * D0026's arithmetic operators (the charge operator C with
--    eigenvalues Ω(n), the projectors Π_r on ℓ²(ℕ), the shift U_h) are
--    not constructed.  `Arithmetic` takes an abstract semigroup U with
--    U_h U_k ≡ U_{h+k}; "non-prime intermediate charge mass" is D0026's
--    name for Σ_{s≠1} of the summands, and the name is not a theorem.
--
--  * `Graded` proves the projection formula and linearity; it does NOT
--    prove that ⊠ makes ℕ → R a ring (associativity of the Cauchy
--    product is not needed for any statement here and is not claimed).
--
--  * DynamicDescent is not imported (its module carries a different
--    option set); §3 restates its three scalars as matrix entries and
--    proves those entries, so the correspondence is by inspection of
--    two definitions, both printed above.
--
--  * The CommRingSolver is not used.  Its reflection dispatches on the
--    head constructor of a normalised term, so over ℤ every `pos k`
--    constant is read as 0; the entry computations of §3 are done by
--    hand with `·IdR` and `0RightAnnihilates` instead.
--
--  * The check emits Agda's `UnsupportedIndexedMatch` warnings, one
--    per pattern match on `Fin` at a fixed index (`zeroAt`, `pair`,
--    `Pm`, `mat`, ...).  They say such functions may not compute under
--    transports; they do not affect the checked identities, and the
--    corpus's `Gamma0` and `Rupasamata` match on `Fin 2` the same way.
------------------------------------------------------------------------

module PeirceGluing_TheChargeGluingDefectIsExactlyTheOffSectorMassAndProjectionIsLinearNotMultiplicative where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _∸_) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Nat.Properties using () renaming (znots to ℕznots)
open import Cubical.Data.FinData
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Int.Properties using (injPos)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Algebra.Ring
open import Cubical.Algebra.Ring.BigOps
open import Cubical.Algebra.Matrix using (FinMatrix ; FinMatrixRing)
open import Cubical.Algebra.CommRing using (CommRing→Ring)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §0  Finite sums over Fin n, and the sum over s ≠ r.
------------------------------------------------------------------------

module FiniteSums (R' : Ring ℓ) where
  open RingStr (snd R')
  open RingTheory R'
  open Sum R'
  private R = ⟨ R' ⟩

  -- Two ring facts used repeatedly below.
  cancelL : (x y : R) → (x + y) - x ≡ y
  cancelL x y =
    +Comm (x + y) (- x) ∙ +Assoc (- x) x y ∙ cong (_+ y) (+InvL x) ∙ +IdL y

  negSub : (x y : R) → y - x ≡ - (x - y)
  negSub x y =
    +Comm y (- x) ∙ cong ((- x) +_) (sym (-Idempotent y)) ∙ -Dist x (- y)

  -- V with its r-th entry replaced by 0r.  Summing it is summing over
  -- s ≠ r.
  zeroAt : {n : ℕ} → Fin n → FinVec R n → FinVec R n
  zeroAt zero    V zero    = 0r
  zeroAt zero    V (suc s) = V (suc s)
  zeroAt (suc r) V zero    = V zero
  zeroAt (suc r) V (suc s) = zeroAt r (V ∘ suc) s

  zeroAt-diag : {n : ℕ} (r : Fin n) (V : FinVec R n) → zeroAt r V r ≡ 0r
  zeroAt-diag zero    V = refl
  zeroAt-diag (suc r) V = zeroAt-diag r (V ∘ suc)

  zeroAt-off : {n : ℕ} (r s : Fin n) (V : FinVec R n)
             → ¬ (s ≡ r) → zeroAt r V s ≡ V s
  zeroAt-off zero    zero    V h = ⊥.rec (h refl)
  zeroAt-off zero    (suc s) V h = refl
  zeroAt-off (suc r) zero    V h = refl
  zeroAt-off (suc r) (suc s) V h = zeroAt-off r s (V ∘ suc) (λ p → h (cong suc p))

  -- ∑ V = V r + Σ_{s ≠ r} V s
  ∑pick : {n : ℕ} (r : Fin n) (V : FinVec R n) → ∑ V ≡ V r + ∑ (zeroAt r V)
  ∑pick zero    V = cong (V zero +_) (sym (+IdL _))
  ∑pick (suc r) V = cong (V zero +_) (∑pick r (V ∘ suc)) ∙ +Assoc-comm1 _ _ _

  -- A nonzero finite sum has a nonzero summand — up to double negation.
  -- This is constructive because ¬¬ commutes with FINITE conjunction:
  -- the induction threads ¬¬(V 0 ≡ 0) and ¬¬(∑ tail ≡ 0) into
  -- ¬¬(∑ V ≡ 0).  No stability of equality in R is assumed.
  ∑≢0→¬¬witness : {n : ℕ} (V : FinVec R n)
                → ¬ (∑ V ≡ 0r) → ¬ ¬ (Σ[ s ∈ Fin n ] ¬ (V s ≡ 0r))
  ∑≢0→¬¬witness {n = zero}  V h _ = h refl
  ∑≢0→¬¬witness {n = suc n} V h k =
    k0 (λ p0 → ∑≢0→¬¬witness (V ∘ suc)
                 (λ pt → h (cong₂ _+_ p0 pt ∙ +IdR 0r)) ktail)
    where
    k0 : ¬ ¬ (V zero ≡ 0r)
    k0 nz = k (zero , nz)
    ktail : ¬ (Σ[ s ∈ Fin n ] ¬ (V (suc s) ≡ 0r))
    ktail (s , nz) = k (suc s , nz)

  -- With decidable equality the witness is found by search.
  ∑≢0→witness : Discrete R → {n : ℕ} (V : FinVec R n)
              → ¬ (∑ V ≡ 0r) → Σ[ s ∈ Fin n ] ¬ (V s ≡ 0r)
  ∑≢0→witness dec {n = zero}  V h = ⊥.rec (h refl)
  ∑≢0→witness dec {n = suc n} V h with dec (V zero) 0r
  ... | no  nz = zero , nz
  ... | yes p0 =
    let w = ∑≢0→witness dec (V ∘ suc) (λ pt → h (cong₂ _+_ p0 pt ∙ +IdR 0r))
    in suc (fst w) , snd w

------------------------------------------------------------------------
-- §1  The Peirce form.
------------------------------------------------------------------------

-- A finite complete family of idempotents.  Orthogonality is not a
-- field: see the header.
record SectorFamily (R' : Ring ℓ) (n : ℕ) : Type ℓ where
  open RingStr (snd R')
  open Sum R'
  field
    e        : FinVec ⟨ R' ⟩ n
    complete : ∑ e ≡ 1r
    idem     : (r : Fin n) → e r · e r ≡ e r

Orthogonal : {R' : Ring ℓ} {n : ℕ} → SectorFamily R' n → Type ℓ
Orthogonal {R' = R'} S =
  (r s : Fin _) → ¬ (r ≡ s) → RingStr._·_ (snd R') (S .SectorFamily.e r) (S .SectorFamily.e s) ≡ RingStr.0r (snd R')

module Peirce (R' : Ring ℓ) {n : ℕ} (S : SectorFamily R' n) where
  open RingStr (snd R')
  open RingTheory R'
  open Sum R'
  open FiniteSums R'
  open SectorFamily S
  private R = ⟨ R' ⟩

  -- e_r a e_s b e_r : leave sector r into sector s under a, return under b.
  term : (r : Fin n) (a b : R) → FinVec R n
  term r a b s = (((e r · a) · e s) · b) · e r

  -- the compressed piece e_r a e_r
  K : Fin n → R → R
  K r a = (e r · a) · e r

  -- the off-sector terms: term with the s = r entry removed
  off : (r : Fin n) (a b : R) → FinVec R n
  off r a b = zeroAt r (term r a b)

  -- e_r (a b) e_r = Σ_s e_r a e_s b e_r.  Only completeness is used.
  peirce : (r : Fin n) (a b : R) → (e r · (a · b)) · e r ≡ ∑ (term r a b)
  peirce r a b =
      (e r · (a · b)) · e r
    ≡⟨ cong (λ z → (e r · z) · e r) expand ⟩
      (e r · ∑ (λ s → a · (e s · b))) · e r
    ≡⟨ cong (_· e r) (∑Mulrdist (e r) (λ s → a · (e s · b))) ⟩
      (∑ (λ s → e r · (a · (e s · b)))) · e r
    ≡⟨ ∑Mulldist (e r) (λ s → e r · (a · (e s · b))) ⟩
      ∑ (λ s → (e r · (a · (e s · b))) · e r)
    ≡⟨ ∑Ext (λ s → cong (_· e r) (·Assoc (e r) a (e s · b) ∙ ·Assoc (e r · a) (e s) b)) ⟩
      ∑ (term r a b) ∎
    where
    expand : a · b ≡ ∑ (λ s → a · (e s · b))
    expand =
        a · b
      ≡⟨ cong (a ·_) (sym (·IdL b)) ⟩
        a · (1r · b)
      ≡⟨ cong (λ z → a · (z · b)) (sym complete) ⟩
        a · (∑ e · b)
      ≡⟨ cong (a ·_) (∑Mulldist b e) ⟩
        a · ∑ (λ s → e s · b)
      ≡⟨ ∑Mulrdist a (λ s → e s · b) ⟩
        ∑ (λ s → a · (e s · b)) ∎

  -- Each summand is a product of two blocks, e_r a e_s and e_s b e_r.
  -- Idempotence of e_s is what glues the two blocks.
  term-block : (r : Fin n) (a b : R) (s : Fin n)
             → term r a b s ≡ ((e r · a) · e s) · ((e s · b) · e r)
  term-block r a b s = sym (
      ((e r · a) · e s) · ((e s · b) · e r)
    ≡⟨ ·Assoc ((e r · a) · e s) (e s · b) (e r) ⟩
      (((e r · a) · e s) · (e s · b)) · e r
    ≡⟨ cong (_· e r) (·Assoc ((e r · a) · e s) (e s) b) ⟩
      ((((e r · a) · e s) · e s) · b) · e r
    ≡⟨ cong (λ z → (z · b) · e r) (sym (·Assoc (e r · a) (e s) (e s))) ⟩
      (((e r · a) · (e s · e s)) · b) · e r
    ≡⟨ cong (λ z → (((e r · a) · z) · b) · e r) (idem s) ⟩
      (((e r · a) · e s) · b) · e r ∎)

  -- T18.7's block form: M_{r,r}(ab) = Σ_s M_{r,s}(a) M_{s,r}(b).
  peirce-block : (r : Fin n) (a b : R)
               → (e r · (a · b)) · e r ≡ ∑ (λ s → ((e r · a) · e s) · ((e s · b) · e r))
  peirce-block r a b = peirce r a b ∙ ∑Ext (term-block r a b)

  -- The product of the compressed pieces is the diagonal summand.
  KK : (r : Fin n) (a b : R) → K r a · K r b ≡ term r a b r
  KK r a b = sym (term-block r a b r)

  -- THE GLUING DEFECT IS EXACTLY THE OFF-SECTOR MASS.
  gluing : (r : Fin n) (a b : R)
         → ((e r · (a · b)) · e r) - (K r a · K r b) ≡ ∑ (off r a b)
  gluing r a b =
      ((e r · (a · b)) · e r) - (K r a · K r b)
    ≡⟨ cong₂ _-_ (peirce r a b ∙ ∑pick r (term r a b)) (KK r a b) ⟩
      (term r a b r + ∑ (off r a b)) - term r a b r
    ≡⟨ cancelL _ _ ⟩
      ∑ (off r a b) ∎

  -- The off-sector mass is the single Q-term of the two-sector
  -- theorems: Σ_{s≠r} e_r a e_s b e_r = e_r a (1 − e_r) b e_r.  This
  -- is the bridge from CompressionDefect/ExcursionReturn (one Q) to
  -- D0026 (a sum over intermediate charges).
  off-is-Q : (r : Fin n) (a b : R)
           → ∑ (off r a b) ≡ ((e r · a) · (1r - e r)) · (b · e r)
  off-is-Q r a b = sym (
      ((e r · a) · (1r - e r)) · (b · e r)
    ≡⟨ cong (_· (b · e r))
        (·DistR+ (e r · a) 1r (- e r)
         ∙ cong₂ _+_ (·IdR (e r · a)) (-DistR· (e r · a) (e r))) ⟩
      ((e r · a) - ((e r · a) · e r)) · (b · e r)
    ≡⟨ ·DistL+ (e r · a) (- ((e r · a) · e r)) (b · e r)
       ∙ cong (((e r · a) · (b · e r)) +_) (-DistL· ((e r · a) · e r) (b · e r)) ⟩
      ((e r · a) · (b · e r)) - (((e r · a) · e r) · (b · e r))
    ≡⟨ cong₂ _-_ (·-assoc2 (e r) a b (e r) ∙ peirce r a b ∙ ∑pick r (term r a b))
                 (·Assoc ((e r · a) · e r) b (e r)) ⟩
      (term r a b r + ∑ (off r a b)) - term r a b r
    ≡⟨ cancelL _ _ ⟩
      ∑ (off r a b) ∎)

  -- D0026's boxed first line, PU_hPU_kP − PU_{h+k}P = −PU_hQU_kP,
  -- with P = e_r and Q = 1 − e_r.
  boxed : (r : Fin n) (a b : R)
        → (K r a · K r b) - ((e r · (a · b)) · e r)
        ≡ - (((e r · a) · (1r - e r)) · (b · e r))
  boxed r a b =
    negSub ((e r · (a · b)) · e r) (K r a · K r b) ∙ cong -_ (gluing r a b ∙ off-is-Q r a b)

  -- T18.7's iff: closure of sector-r propagation under composition is
  -- exactly the vanishing of the off-sector sum.
  closure→off0 : (r : Fin n) (a b : R)
               → K r a · K r b ≡ (e r · (a · b)) · e r → ∑ (off r a b) ≡ 0r
  closure→off0 r a b h =
    sym (gluing r a b) ∙ cong (_- (K r a · K r b)) (sym h) ∙ +InvR (K r a · K r b)

  off0→closure : (r : Fin n) (a b : R)
               → ∑ (off r a b) ≡ 0r → K r a · K r b ≡ (e r · (a · b)) · e r
  off0→closure r a b h = sym (equalByDifference _ _ (gluing r a b ∙ h))

  ----------------------------------------------------------------------
  -- The converse of T18.5, in its honest constructive form.
  ----------------------------------------------------------------------

  -- A nonzero off-sector entry is off the diagonal and is a nonzero
  -- excursion-return term.
  locate : (r : Fin n) (a b : R)
         → Σ[ s ∈ Fin n ] ¬ (off r a b s ≡ 0r)
         → Σ[ s ∈ Fin n ] (¬ (s ≡ r)) × (¬ (term r a b s ≡ 0r))
  locate r a b (s , nz) = s , s≠r , (λ t0 → nz (zeroAt-off r s (term r a b) s≠r ∙ t0))
    where
    s≠r : ¬ (s ≡ r)
    s≠r p = nz (cong (off r a b) p ∙ zeroAt-diag r (term r a b))

  -- If the off-sector mass is not zero then NOT NOT some excursion
  -- through some s ≠ r returns with nonzero amplitude.  The double
  -- negation is the price of locating a summand without deciding
  -- equality in R.
  off≢0→¬¬witness : (r : Fin n) (a b : R)
                  → ¬ (∑ (off r a b) ≡ 0r)
                  → ¬ ¬ (Σ[ s ∈ Fin n ] (¬ (s ≡ r)) × (¬ (term r a b s ≡ 0r)))
  off≢0→¬¬witness r a b h k = ∑≢0→¬¬witness (off r a b) h (λ w → k (locate r a b w))

  -- The same from failure of closure itself.
  nonclosure→¬¬witness : (r : Fin n) (a b : R)
                       → ¬ (K r a · K r b ≡ (e r · (a · b)) · e r)
                       → ¬ ¬ (Σ[ s ∈ Fin n ] (¬ (s ≡ r)) × (¬ (term r a b s ≡ 0r)))
  nonclosure→¬¬witness r a b h = off≢0→¬¬witness r a b (λ z → h (off0→closure r a b z))

  -- Sharp form: with decidable equality the witness is found by search.
  off≢0→witness : Discrete R → (r : Fin n) (a b : R)
                → ¬ (∑ (off r a b) ≡ 0r)
                → Σ[ s ∈ Fin n ] (¬ (s ≡ r)) × (¬ (term r a b s ≡ 0r))
  off≢0→witness dec r a b h = locate r a b (∑≢0→witness dec (off r a b) h)

  ----------------------------------------------------------------------
  -- The arithmetic form: a shift semigroup U_h U_k = U_{h+k}.
  ----------------------------------------------------------------------

  module Arithmetic (U : ℕ → R) (U-hom : (h k : ℕ) → U h · U k ≡ U (h +ℕ k)) where

    -- T18.7's block matrices M^{(h)}_{r,s} = e_r U_h e_s.
    M : ℕ → Fin n → Fin n → R
    M h r s = (e r · U h) · e s

    T18-7 : (r : Fin n) (h k : ℕ) → M (h +ℕ k) r r ≡ ∑ (λ s → M h r s · M k s r)
    T18-7 r h k = cong (λ z → (e r · z) · e r) (sym (U-hom h k)) ∙ peirce-block r (U h) (U k)

    -- D0026's second line: PU_{h+k}P − PU_hPU_kP = Σ_{s≠r} PU_hΠ_sU_kP.
    gluing-arith : (r : Fin n) (h k : ℕ)
                 → M (h +ℕ k) r r - (M h r r · M k r r) ≡ ∑ (off r (U h) (U k))
    gluing-arith r h k =
      cong (λ z → ((e r · z) · e r) - (M h r r · M k r r)) (sym (U-hom h k)) ∙ gluing r (U h) (U k)

    closure-iff-arith : (r : Fin n) (h k : ℕ)
                      → (M h r r · M k r r ≡ M (h +ℕ k) r r) → ∑ (off r (U h) (U k)) ≡ 0r
    closure-iff-arith r h k cl =
      closure→off0 r (U h) (U k) (cl ∙ cong (λ z → (e r · z) · e r) (sym (U-hom h k)))

------------------------------------------------------------------------
-- §2  n = 2: the off-sector sum is one term, and it is DynamicDescent's.
------------------------------------------------------------------------

record TwoSectors (R' : Ring ℓ) : Type ℓ where
  open RingStr (snd R')
  field
    P Q : ⟨ R' ⟩
    PQ1 : P + Q ≡ 1r
    PP  : P · P ≡ P
    QQ  : Q · Q ≡ Q

module Two (R' : Ring ℓ) (T2 : TwoSectors R') where
  open RingStr (snd R')
  open RingTheory R'
  open Sum R'
  open FiniteSums R'
  open TwoSectors T2
  private R = ⟨ R' ⟩

  pair : R → R → FinVec R 2
  pair x y zero      = x
  pair x y (suc zero) = y

  S : SectorFamily R' 2
  S = record
    { e        = pair P Q
    ; complete = cong (P +_) (+IdR Q) ∙ PQ1
    ; idem     = λ { zero → PP ; (suc zero) → QQ } }

  -- orthogonality, checked here since §1 does not require it
  orth₂ : P · Q ≡ 0r → Q · P ≡ 0r → Orthogonal S
  orth₂ pq qp zero       zero       h = ⊥.rec (h refl)
  orth₂ pq qp zero       (suc zero) h = pq
  orth₂ pq qp (suc zero) zero       h = qp
  orth₂ pq qp (suc zero) (suc zero) h = ⊥.rec (h refl)

  open Peirce R' S

  -- at r = 0 the sum over s ≠ 0 is the single s = 1 term P a Q b P
  off₀ : (a b : R) → ∑ (off zero a b) ≡ (((P · a) · Q) · b) · P
  off₀ a b = +IdL _ ∙ +IdR _

  -- P (a b) P − (P a P)(P b P) = P a Q b P
  defect₂ : (a b : R)
          → ((P · (a · b)) · P) - (((P · a) · P) · ((P · b) · P)) ≡ (((P · a) · Q) · b) · P
  defect₂ a b = gluing zero a b ∙ off₀ a b

  -- DynamicDescent.twoStepDefect as an operator identity:
  -- (P T P)² − P T² P ≡ −(P T Q T P).
  dynamicDescent-shape : (T : R)
    → (((P · T) · P) · ((P · T) · P)) - ((P · (T · T)) · P) ≡ - ((((P · T) · Q) · T) · P)
  dynamicDescent-shape T = negSub _ _ ∙ cong -_ (defect₂ T T)

------------------------------------------------------------------------
-- §3  2×2 matrices over ℤ: the entry is bc.
------------------------------------------------------------------------

module Matrix2 where
  ℤR : Ring ℓ-zero
  ℤR = CommRing→Ring ℤCommRing

  M₂ : Ring ℓ-zero
  M₂ = FinMatrixRing ℤR 2

  open RingStr (snd ℤR) using (_·_ ; _+_ ; -_ ; _-_ ; ·IdR ; +IdR ; +IdL)
  open RingTheory ℤR using (0RightAnnihilates)
  open RingStr (snd M₂) using ()
    renaming (_·_ to _⋆_ ; _+_ to _⊕_ ; 1r to 𝟙 ; 0r to 𝟘)

  Pm Qm : FinMatrix ℤ 2 2
  Pm zero       zero       = pos 1
  Pm zero       (suc zero) = pos 0
  Pm (suc zero) zero       = pos 0
  Pm (suc zero) (suc zero) = pos 0
  Qm zero       zero       = pos 0
  Qm zero       (suc zero) = pos 0
  Qm (suc zero) zero       = pos 0
  Qm (suc zero) (suc zero) = pos 1

  -- T = (a b / c d), DynamicDescent's step operator
  mat : ℤ → ℤ → ℤ → ℤ → FinMatrix ℤ 2 2
  mat a b c d zero       zero       = a
  mat a b c d zero       (suc zero) = b
  mat a b c d (suc zero) zero       = c
  mat a b c d (suc zero) (suc zero) = d

  -- Left multiplication by Pm reduces definitionally (ℤ's `_·_` and
  -- `_+_` recurse on their FIRST argument, and Pm's entries are closed).
  -- Right multiplication does not, so the four lemmas below are the
  -- only ring steps the entry computations need.  (The CommRingSolver
  -- cannot be used here: after normalisation it reads every `pos k`
  -- constant as 0, since it dispatches on the head constructor.)
  rightP : (X : FinMatrix ℤ 2 2) (i : Fin 2) → (X ⋆ Pm) i zero ≡ X i zero
  rightP X i =
    cong₂ _+_ (·IdR (X i zero)) (0RightAnnihilates (X i (suc zero))) ∙ +IdR (X i zero)

  rightP1 : (X : FinMatrix ℤ 2 2) (i : Fin 2) → (X ⋆ Pm) i (suc zero) ≡ pos 0
  rightP1 X i =
    cong₂ _+_ (0RightAnnihilates (X i zero)) (0RightAnnihilates (X i (suc zero)))

  rightQ0 : (X : FinMatrix ℤ 2 2) (i : Fin 2) → (X ⋆ Qm) i zero ≡ pos 0
  rightQ0 X i =
    cong₂ _+_ (0RightAnnihilates (X i zero)) (0RightAnnihilates (X i (suc zero)))

  rightQ1 : (X : FinMatrix ℤ 2 2) (i : Fin 2) → (X ⋆ Qm) i (suc zero) ≡ X i (suc zero)
  rightQ1 X i =
    cong₂ _+_ (0RightAnnihilates (X i zero)) (·IdR (X i (suc zero))) ∙ +IdL (X i (suc zero))

  ext₂ : {M N : FinMatrix ℤ 2 2}
       → M zero zero ≡ N zero zero → M zero (suc zero) ≡ N zero (suc zero)
       → M (suc zero) zero ≡ N (suc zero) zero → M (suc zero) (suc zero) ≡ N (suc zero) (suc zero)
       → M ≡ N
  ext₂ p q r s = funExt λ { zero → funExt (λ { zero → p ; (suc zero) → q })
                          ; (suc zero) → funExt (λ { zero → r ; (suc zero) → s }) }

  -- P, Q are a complete orthogonal pair of idempotents: closed
  -- computations in ℤ, all by refl.
  PQ1 : Pm ⊕ Qm ≡ 𝟙
  PQ1 = ext₂ refl refl refl refl

  PP : Pm ⋆ Pm ≡ Pm
  PP = ext₂ refl refl refl refl

  QQ : Qm ⋆ Qm ≡ Qm
  QQ = ext₂ refl refl refl refl

  PQ0 : Pm ⋆ Qm ≡ 𝟘
  PQ0 = ext₂ refl refl refl refl

  QP0 : Qm ⋆ Pm ≡ 𝟘
  QP0 = ext₂ refl refl refl refl

  T2 : TwoSectors M₂
  T2 = record { P = Pm ; Q = Qm ; PQ1 = PQ1 ; PP = PP ; QQ = QQ }

  open Two M₂ T2

  orthogonal : Orthogonal S
  orthogonal = orth₂ PQ0 QP0

  -- the (0,0) entry of the excursion P T Q T P is bc
  defect-entry : (a b c d : ℤ)
    → ((((Pm ⋆ mat a b c d) ⋆ Qm) ⋆ mat a b c d) ⋆ Pm) zero zero ≡ b · c
  defect-entry a b c d =
      ((((Pm ⋆ T) ⋆ Qm) ⋆ T) ⋆ Pm) zero zero
    ≡⟨ rightP (((Pm ⋆ T) ⋆ Qm) ⋆ T) zero ⟩
      (((Pm ⋆ T) ⋆ Qm) ⋆ T) zero zero
    ≡⟨ cong₂ _+_ (cong (_· a) (rightQ0 (Pm ⋆ T) zero))
                 (cong (_· c) (rightQ1 (Pm ⋆ T) zero)) ⟩
      pos 0 · a + b · c
    ≡⟨ +IdL (b · c) ⟩
      b · c ∎
    where T = mat a b c d

  -- the (0,0) entry of the general n = 2 gluing defect is bc:
  -- [P T² P]₀₀ − [(P T P)²]₀₀ ≡ b · c
  recovered : (a b c d : ℤ)
    → (((Pm ⋆ (mat a b c d ⋆ mat a b c d)) ⋆ Pm) zero zero)
      - ((((Pm ⋆ mat a b c d) ⋆ Pm) ⋆ ((Pm ⋆ mat a b c d) ⋆ Pm)) zero zero)
      ≡ b · c
  recovered a b c d =
    cong (λ N → N zero zero) (defect₂ (mat a b c d) (mat a b c d)) ∙ defect-entry a b c d

  -- and with DynamicDescent's sign: [(P T P)²]₀₀ − [P T² P]₀₀ ≡ −(b · c)
  recovered-signed : (a b c d : ℤ)
    → ((((Pm ⋆ mat a b c d) ⋆ Pm) ⋆ ((Pm ⋆ mat a b c d) ⋆ Pm)) zero zero)
      - (((Pm ⋆ (mat a b c d ⋆ mat a b c d)) ⋆ Pm) zero zero)
      ≡ - (b · c)
  recovered-signed a b c d =
    cong (λ N → N zero zero) (dynamicDescent-shape (mat a b c d)) ∙ cong -_ (defect-entry a b c d)

  -- DynamicDescent's two scalars, as the entries they are:
  -- markovSquare a = a · a and trueTwoStep a b c = a · a + b · c.
  markov-entry : (a b c d : ℤ)
    → ((((Pm ⋆ mat a b c d) ⋆ Pm) ⋆ ((Pm ⋆ mat a b c d) ⋆ Pm)) zero zero) ≡ a · a
  markov-entry a b c d =
      cong₂ _+_ (cong₂ _·_ (rightP (Pm ⋆ T) zero) (rightP (Pm ⋆ T) zero))
                (0RightAnnihilates (((Pm ⋆ T) ⋆ Pm) zero (suc zero)))
    ∙ +IdR (a · a)
    where T = mat a b c d

  twoStep-entry : (a b c d : ℤ)
    → (((Pm ⋆ (mat a b c d ⋆ mat a b c d)) ⋆ Pm) zero zero) ≡ a · a + b · c
  twoStep-entry a b c d = rightP (Pm ⋆ (mat a b c d ⋆ mat a b c d)) zero

------------------------------------------------------------------------
-- §4  Charge-graded convolution: Π_c is linear, not multiplicative.
------------------------------------------------------------------------

module Graded (R' : Ring ℓ) where
  open RingStr (snd R')
  open Sum R'
  private R = ⟨ R' ⟩

  -- a charge-graded element: F c is its charge-c piece
  GradedSeq : Type ℓ
  GradedSeq = ℕ → R

  -- fixed-charge coefficient extraction
  Π : ℕ → GradedSeq → R
  Π c F = F c

  _⊞_ : GradedSeq → GradedSeq → GradedSeq
  (F ⊞ G) c = F c + G c

  _⊡_ : R → GradedSeq → GradedSeq
  (x ⊡ F) c = x · F c

  -- the Cauchy product: charge is additive, so the charge-c piece of a
  -- product collects every split i + j = c.
  _⊠_ : GradedSeq → GradedSeq → GradedSeq
  (F ⊠ G) c = ∑ (λ (i : Fin (suc c)) → F (toℕ i) · G (c ∸ toℕ i))

  -- Π_c is additive and R-linear: both are the definitions.
  Π-add : (c : ℕ) (F G : GradedSeq) → Π c (F ⊞ G) ≡ Π c F + Π c G
  Π-add c F G = refl

  Π-scale : (c : ℕ) (x : R) (F : GradedSeq) → Π c (x ⊡ F) ≡ x · Π c F
  Π-scale c x F = refl

  -- D0015's Π_c(FG) = Σ_{i+j=c} Π_i(F) Π_j(G) is the content of the
  -- definition of ⊠, and nothing more: refl.
  Π-conv : (c : ℕ) (F G : GradedSeq)
         → Π c (F ⊠ G) ≡ ∑ (λ (i : Fin (suc c)) → Π (toℕ i) F · Π (c ∸ toℕ i) G)
  Π-conv c F G = refl

  -- the index bookkeeping: every summand really has i + j = c
  index-sum : (c : ℕ) (i : Fin (suc c)) → toℕ i +ℕ (c ∸ toℕ i) ≡ c
  index-sum c       zero    = refl
  index-sum (suc c) (suc i) = cong suc (index-sum c i)

module GradedInt where
  ℤR : Ring ℓ-zero
  ℤR = CommRing→Ring ℤCommRing

  open RingStr (snd ℤR) using (_·_)
  open Graded ℤR

  -- the indicator of charge 1
  ind₁ : GradedSeq
  ind₁ zero          = pos 0
  ind₁ (suc zero)    = pos 1
  ind₁ (suc (suc _)) = pos 0

  -- Π_1 (ind₁ ⊠ ind₁) = ind₁ 0 · ind₁ 1 + ind₁ 1 · ind₁ 0 = 0
  Π₁conv : Π 1 (ind₁ ⊠ ind₁) ≡ pos 0
  Π₁conv = refl

  -- Π_1 ind₁ · Π_1 ind₁ = 1
  Π₁prod : Π 1 ind₁ · Π 1 ind₁ ≡ pos 1
  Π₁prod = refl

  -- Π_c is not multiplicative, at c = 1, F = G = ind₁.
  Π-not-mult : ¬ (Π 1 (ind₁ ⊠ ind₁) ≡ Π 1 ind₁ · Π 1 ind₁)
  Π-not-mult p = ℕznots (injPos p)

  Π-not-mult-∀ : ¬ ((F G : GradedSeq) (c : ℕ) → Π c (F ⊠ G) ≡ Π c F · Π c G)
  Π-not-mult-∀ h = Π-not-mult (h ind₁ ind₁ 1)
