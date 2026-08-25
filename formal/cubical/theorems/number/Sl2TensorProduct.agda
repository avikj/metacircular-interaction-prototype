{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sl2TensorProduct
--
-- The general (multi-index) 𝔰𝔩₂ action on the divisor lattice:
--   B_n = k[ξ₁,…,ξ_m]/(ξ₁^{α₁+1},…,ξ_m^{α_m+1}) = ⨂_i V_{α_i},
-- the module of notes/SL2_DIVISOR_LATTICE.md §1, whose rank-one factor
-- V_α is the content of Sl2DivisorLattice.agda (imported, not redone).
--
-- WHAT IS PROVED HERE (all --safe, no postulates, no holes):
--
--  1. tensorRep : Sl2Rep → Sl2Rep → Sl2Rep     (§3)
--     The tensor product of two 𝔰𝔩₂-triples, with the STANDARD
--     comultiplication ε ↦ ε⊗1 + 1⊗ε (likewise φ, η), is again an
--     𝔰𝔩₂-triple.  All three bracket relations are re-proved for the
--     tensor from the two factors.  This is the load-bearing lemma.
--
--  2. Bn : ℕ → Sl2Rep                          (§5)
--     Bn m = V ⊗ (V ⊗ (… ⊗ V)) with m factors.  By induction on m,
--     every multi-index divisor lattice carries the action.  Bn 0 is
--     the trivial (zero) triple on k, Bn 1 = chainRep, and
--     Bn (suc (suc m)) = chainRep ⊗ Bn (suc m).  In particular
--     Bn 2 = chainRep ⊗ chainRep = Rk2 DEFINITIONALLY (`Rk2≡Bn2`,
--     §6), so the rank-2 displays of §6 and the controls of §7 are
--     statements about the induction's own output.
--
--  3. tensor-E , tensor-F , tensor-H           (§4)
--     The comultiplication read on decomposable tensors:
--       Ê (v⊗w) = (E v)⊗w + v⊗(E w),  and likewise F̂ , Ĥ.
--     This is what makes the operators of Bn m literally the note's
--     multi-index displays; §6 reads them off at rank 2.
--
--  4. §6: rank-2 displays, general in (κ₁,d₁,κ₂,d₂) — ε as Σ_i
--     ξ^{κ+e_i} with truncation in each coordinate, φ with coefficient
--     κ_i(α_i−κ_i+1) in each summand, η with eigenvalue
--     (κ₁−d₁)+(κ₂−d₂) = 2|κ| − (α₁+α₂).
--
--  5. §7: CONTROLS at rank 2 with DISTINCT α₁ = 1 ≠ 3 = α₂, in the
--     spirit of the rank-one module's six `refl` controls.  These
--     include a NON-VACUITY control for the off-diagonal cancellation:
--     E₁F₂ applied to a basis vector is shown to be NONZERO (= 4), so
--     the identity ⟦E₁,F₂⟧ = 0 proved in §2 is a cancellation of two
--     equal nonzero terms and not of two zeros.  Rank one cannot see
--     this at all.
--
-- THE POINT THAT ACTUALLY MATTERS (note §2(c)).  The note's off-diagonal
-- step says: for i ≠ j, E_i F_j and F_j E_i produce the same monomial
-- with the same scalar, and both vanish under the SAME predicate,
-- because the truncation predicate depends only on coordinate i and F_j
-- does not touch coordinate i.  In the encoding below that statement is
-- `swap-lop-rop` (§2): E acts through the left index only, F through the
-- right index only, and the two orders of summation agree.  The
-- truncation is carried by the kernel's source list at a target index:
-- ε's list is EMPTY at the top of a chain.  The Fubini induction treats
-- the empty list uniformly on both sides, which is exactly the note's
-- "both sides vanish under the same predicate", made structural.
--
-- ENCODING.  A representation is an index type Ix together with three
-- KERNELS Ix → List (Ix × ℤ): for each target index, the finite list of
-- (source , structure constant) pairs.  An operator acts by
--   (T v) t = Σ_{(s,c) ∈ T t} c · v s .
-- Kernels are used rather than bare functions M → M for one reason: the
-- commutation of a left-slot operator with a right-slot operator is a
-- Fubini statement about finite sums, and it is FALSE for arbitrary
-- functions M → M (it needs linearity).  Lists give the linearity as a
-- theorem, with no finiteness side conditions and no postulates.  The
-- class of kernel operators is closed under the two constructions used:
-- pointwise sum (list append) and slot-lifting (§3).
--
-- The rank-one factor is imported: `chainRep` (§4) is the triple
-- (ε,φ,η) of Sl2DivisorLattice on Ix = ℕ × ℕ, and its three brackets
-- are TRANSPORTED from that module's `bracket-ηε`, `bracket-ηφ`,
-- `bracket-εφ` along the currying (ℕ × ℕ → ℤ) ≃ (ℕ → ℕ → ℤ).  Nothing
-- in Sl2DivisorLattice is modified.
--
-- SCOPE LIMITS (stated, not papered over):
--  * The general-m OPERATORS are proved to be an 𝔰𝔩₂-triple (item 2).
--    The general-m BASIS DISPLAY (ε ξ^κ = Σ_{i=1}^m ξ^{κ+e_i} with a
--    multi-index δ) is proved at m = 2 only (§6), for arbitrary
--    (κ₁,d₁,κ₂,d₂); for general m what is written is the recursive
--    comultiplication (item 3), which is the same statement unrolled,
--    but the multi-index δ notation is not set up here.
--  * Coefficients are ℤ, as in the rank-one module; char-0 consequences
--    (complete reducibility, Sperner) are NOT claimed here.
--  * Nothing here is new mathematics: this is the coproduct on U(𝔰𝔩₂)
--    (Humphreys §7, and note §3(ii)).  What is new is that it is a
--    checked term.
------------------------------------------------------------------------

module Sl2TensorProduct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Int
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)

open import Sl2DivisorLattice
  using (ε ; φ ; η ; δ ; bracket-ηε ; bracket-ηφ ; bracket-εφ
        ; ε-δ ; ε-δ-top ; φ-δ ; φ-δ-bot ; η-δ)

------------------------------------------------------------------------
-- §0  ℤ bookkeeping.  Nothing here is about 𝔰𝔩₂.
------------------------------------------------------------------------

private

  ·0ᵣ : (x : ℤ) → x · pos 0 ≡ pos 0
  ·0ᵣ x = ·Comm x (pos 0)

  +0ᵣ : (x : ℤ) → x + pos 0 ≡ x
  +0ᵣ x = +Comm x (pos 0) ∙ sym (pos0+ x)

  ·1ₗ : (x : ℤ) → pos 1 · x ≡ x
  ·1ₗ x = ·Comm (pos 1) x ∙ ·IdR x

  -- (a + b) + (c + d) ≡ (a + c) + (b + d)
  abel4 : (a b c d : ℤ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
  abel4 a b c d =
      sym (+Assoc a b (c + d))
    ∙ cong (a +_) (+Assoc b c d ∙ cong (_+ d) (+Comm b c) ∙ sym (+Assoc c b d))
    ∙ +Assoc a c (b + d)

  -- (p + q) − (r + s) ≡ (p − r) + (q − s)
  pairSub : (p q r s : ℤ) → (p + q) - (r + s) ≡ (p - r) + (q - s)
  pairSub p q r s = cong ((p + q) +_) (-Dist+ r s) ∙ abel4 p q (- r) (- s)

  -- the eight-term regrouping every tensor bracket ends in
  fourSub : (p₁ p₂ p₃ p₄ q₁ q₂ q₃ q₄ : ℤ)
    → ((p₁ + p₂) + (p₃ + p₄)) - ((q₁ + q₂) + (q₃ + q₄))
    ≡ ((p₁ - q₁) + (p₂ - q₂)) + ((p₃ - q₃) + (p₄ - q₄))
  fourSub p₁ p₂ p₃ p₄ q₁ q₂ q₃ q₄ =
      pairSub (p₁ + p₂) (p₃ + p₄) (q₁ + q₂) (q₃ + q₄)
    ∙ cong₂ _+_ (pairSub p₁ p₂ q₁ q₂) (pairSub p₃ p₄ q₃ q₄)

------------------------------------------------------------------------
-- §1  Modules, kernels, and the action.
------------------------------------------------------------------------

-- coefficient functions on an index set
Mod : Type₀ → Type₀
Mod I = I → ℤ

_⊕ᴹ_ : {I : Type₀} → Mod I → Mod I → Mod I
(v ⊕ᴹ w) t = v t + w t

_⊖ᴹ_ : {I : Type₀} → Mod I → Mod I → Mod I
(v ⊖ᴹ w) t = v t - w t

sca : {I : Type₀} → ℤ → Mod I → Mod I
sca c v t = c · v t

-- A kernel: for each TARGET index, the finite list of (source ,
-- structure constant) pairs contributing to it.
Op : Type₀ → Type₀
Op I = I → List (I × ℤ)

-- the weighted sum along a list
sumL : {I : Type₀} → List (I × ℤ) → Mod I → ℤ
sumL [] v = pos 0
sumL ((s , c) ∷ L) v = c · v s + sumL L v

-- the action of a kernel
ap : {I : Type₀} → Op I → Mod I → Mod I
ap T v t = sumL (T t) v

⟪_,_⟫ : {I : Type₀} → (Mod I → Mod I) → (Mod I → Mod I) → Mod I → Mod I
⟪ S , T ⟫ v = S (T v) ⊖ᴹ T (S v)

private
  -- the three linearity facts about weighted sums
  sumL-0 : {I : Type₀} (L : List (I × ℤ)) → sumL L (λ _ → pos 0) ≡ pos 0
  sumL-0 [] = refl
  sumL-0 ((s , c) ∷ L) =
    cong₂ _+_ (·0ᵣ c) (sumL-0 L)

  sumL-add : {I : Type₀} (L : List (I × ℤ)) (v w : Mod I)
    → sumL L (v ⊕ᴹ w) ≡ sumL L v + sumL L w
  sumL-add [] v w = refl
  sumL-add ((s , c) ∷ L) v w =
      cong₂ _+_ (·DistR+ c (v s) (w s)) (sumL-add L v w)
    ∙ abel4 (c · v s) (c · w s) (sumL L v) (sumL L w)

  sumL-scaleR : {I : Type₀} (L : List (I × ℤ)) (v : Mod I) (x : ℤ)
    → sumL L (λ s → v s · x) ≡ sumL L v · x
  sumL-scaleR [] v x = refl
  sumL-scaleR ((s , c) ∷ L) v x =
      cong₂ _+_ (·Assoc c (v s) x) (sumL-scaleR L v x)
    ∙ sym (·DistL+ (c · v s) (sumL L v) x)

  sumL-scaleL : {I : Type₀} (L : List (I × ℤ)) (v : Mod I) (x : ℤ)
    → sumL L (λ s → x · v s) ≡ x · sumL L v
  sumL-scaleL [] v x = sym (·0ᵣ x)
  sumL-scaleL ((s , c) ∷ L) v x =
      cong₂ _+_ (·Assoc c x (v s) ∙ cong (_· v s) (·Comm c x) ∙ sym (·Assoc x c (v s)))
                (sumL-scaleL L v x)
    ∙ sym (·DistR+ x (c · v s) (sumL L v))

  sumL-++ : {I : Type₀} (L K : List (I × ℤ)) (v : Mod I)
    → sumL (L ++ K) v ≡ sumL L v + sumL K v
  sumL-++ [] K v = pos0+ (sumL K v)
  sumL-++ ((s , c) ∷ L) K v =
      cong ((c · v s) +_) (sumL-++ L K v)
    ∙ +Assoc (c · v s) (sumL L v) (sumL K v)

------------------------------------------------------------------------
-- §2  The two slots of a tensor product, and the fact that they commute.
--
-- Everything a left-slot operator does happens inside the first index,
-- everything a right-slot operator does inside the second.  `lop` and
-- `rop` are the two liftings; `swap-lop-rop` is the note's §2(c).
------------------------------------------------------------------------

module _ {I J : Type₀} where

  -- T acting in the left slot: literally `ap T` applied to the slice
  lop : Op I → Mod (I × J) → Mod (I × J)
  lop T v (i , j) = ap T (λ i′ → v (i′ , j)) i

  -- U acting in the right slot
  rop : Op J → Mod (I × J) → Mod (I × J)
  rop U v (i , j) = ap U (λ j′ → v (i , j′)) j

  -- Fubini for two finite weighted sums along DIFFERENT index sets.
  -- The base cases are the empty list: when a kernel has no source at a
  -- given target (which is exactly how truncation is recorded — ε's
  -- list is empty at the top of a chain) BOTH orders give pos 0, by the
  -- same clause.  That is the note's "both sides vanish under the same
  -- predicate", here structural rather than a side condition.
  sumL-swap : (L : List (I × ℤ)) (K : List (J × ℤ)) (v : I → J → ℤ)
    → sumL L (λ i → sumL K (λ j → v i j))
    ≡ sumL K (λ j → sumL L (λ i → v i j))
  sumL-swap [] K v = sym (sumL-0 K)
  sumL-swap ((s , c) ∷ L) K v =
      cong ((c · sumL K (λ j → v s j)) +_) (sumL-swap L K v)
    ∙ cong (_+ sumL K (λ j → sumL L (λ i → v i j)))
           (sym (sumL-scaleL K (λ j → v s j) c))
    ∙ sym (sumL-add K (λ j → c · v s j) (λ j → sumL L (λ i → v i j)))

  -- ⟦ left-slot operator , right-slot operator ⟧ = 0.
  swap-lop-rop : (T : Op I) (U : Op J) (v : Mod (I × J))
    → ⟪ lop T , rop U ⟫ v ≡ (λ _ → pos 0)
  swap-lop-rop T U v = funExt go
    where
    go : (x : I × J) → ⟪ lop T , rop U ⟫ v x ≡ pos 0
    go (i , j) =
      cong (_- sumL (U j) (λ j′ → sumL (T i) (λ i′ → v (i′ , j′))))
           (sumL-swap (T i) (U j) (λ i′ j′ → v (i′ , j′)))
      ∙ -Cancel (sumL (U j) (λ j′ → sumL (T i) (λ i′ → v (i′ , j′))))

  -- the same, other order
  swap-rop-lop : (U : Op J) (T : Op I) (v : Mod (I × J))
    → ⟪ rop U , lop T ⟫ v ≡ (λ _ → pos 0)
  swap-rop-lop U T v = funExt go
    where
    go : (x : I × J) → ⟪ rop U , lop T ⟫ v x ≡ pos 0
    go (i , j) =
      cong (λ z → sumL (U j) (λ j′ → sumL (T i) (λ i′ → v (i′ , j′))) - z)
           (sumL-swap (T i) (U j) (λ i′ j′ → v (i′ , j′)))
      ∙ -Cancel (sumL (U j) (λ j′ → sumL (T i) (λ i′ → v (i′ , j′))))

  -- additivity of the two liftings (needed to expand the brackets)
  lop-add : (T : Op I) (v w : Mod (I × J))
    → lop T (v ⊕ᴹ w) ≡ (lop T v ⊕ᴹ lop T w)
  lop-add T v w = funExt λ { (i , j) → sumL-add (T i) _ _ }

  rop-add : (U : Op J) (v w : Mod (I × J))
    → rop U (v ⊕ᴹ w) ≡ (rop U v ⊕ᴹ rop U w)
  rop-add U v w = funExt λ { (i , j) → sumL-add (U j) _ _ }

------------------------------------------------------------------------
-- §3  Representations, and the tensor product of two of them.
------------------------------------------------------------------------

record Sl2Rep : Type₁ where
  field
    Ix  : Type₀
    eK  : Op Ix
    fK  : Op Ix
    hK  : Op Ix
    he  : (v : Mod Ix) → ⟪ ap hK , ap eK ⟫ v ≡ sca (pos 2) (ap eK v)
    hf  : (v : Mod Ix) → ⟪ ap hK , ap fK ⟫ v ≡ sca (- pos 2) (ap fK v)
    ef  : (v : Mod Ix) → ⟪ ap eK , ap fK ⟫ v ≡ ap hK v

open Sl2Rep public

-- ---------------------------------------------------------------------
-- the two kernel constructions the tensor needs

-- move a source list from I into I × J, at fixed second coordinate
shiftL : {I J : Type₀} → J → List (I × ℤ) → List ((I × J) × ℤ)
shiftL j [] = []
shiftL j ((s , c) ∷ L) = ((s , j) , c) ∷ shiftL j L

shiftR : {I J : Type₀} → I → List (J × ℤ) → List ((I × J) × ℤ)
shiftR i [] = []
shiftR i ((s , c) ∷ L) = ((i , s) , c) ∷ shiftR i L

lK : {I J : Type₀} → Op I → Op (I × J)
lK T (i , j) = shiftL j (T i)

rK : {I J : Type₀} → Op J → Op (I × J)
rK U (i , j) = shiftR i (U j)

_⊞_ : {I : Type₀} → Op I → Op I → Op I
(T ⊞ U) t = T t ++ U t

private
  sumL-shiftL : {I J : Type₀} (j : J) (L : List (I × ℤ)) (v : Mod (I × J))
    → sumL (shiftL j L) v ≡ sumL L (λ i′ → v (i′ , j))
  sumL-shiftL j [] v = refl
  sumL-shiftL j ((s , c) ∷ L) v = cong ((c · v (s , j)) +_) (sumL-shiftL j L v)

  sumL-shiftR : {I J : Type₀} (i : I) (L : List (J × ℤ)) (v : Mod (I × J))
    → sumL (shiftR i L) v ≡ sumL L (λ j′ → v (i , j′))
  sumL-shiftR i [] v = refl
  sumL-shiftR i ((s , c) ∷ L) v = cong ((c · v (i , s)) +_) (sumL-shiftR i L v)

-- the kernel action of lK / rK IS the slot lifting of §2
ap-lK : {I J : Type₀} (T : Op I) (v : Mod (I × J)) → ap (lK T) v ≡ lop T v
ap-lK T v = funExt λ { (i , j) → sumL-shiftL j (T i) v }

ap-rK : {I J : Type₀} (U : Op J) (v : Mod (I × J)) → ap (rK U) v ≡ rop U v
ap-rK U v = funExt λ { (i , j) → sumL-shiftR i (U j) v }

ap-⊞ : {I : Type₀} (T U : Op I) (v : Mod I)
     → ap (T ⊞ U) v ≡ (ap T v ⊕ᴹ ap U v)
ap-⊞ T U v = funExt λ t → sumL-++ (T t) (U t) v

------------------------------------------------------------------------
-- The construction.  For reps R (index I) and S (index J):
--   ê = e_R ⊗ 1 + 1 ⊗ e_S ,   f̂ = … ,   ĥ = …
-- and the three brackets are re-proved.  The four cross terms of each
-- bracket are: two "diagonal" ones, discharged by R's and S's own
-- relation, and two "off-diagonal" ones, which VANISH by §2 — that is
-- the cancellation of note §2(c), and it is the whole content of the
-- multi-index case.
------------------------------------------------------------------------

module Tensor (R S : Sl2Rep) where

  Iₗ = Ix R
  Jᵣ = Ix S
  IJ = Iₗ × Jᵣ

  eT fT hT : Op IJ
  eT = lK (eK R) ⊞ rK (eK S)
  fT = lK (fK R) ⊞ rK (fK S)
  hT = lK (hK R) ⊞ rK (hK S)

  private
    -- the action of the three tensor kernels, as lop + rop
    actE : (v : Mod IJ) → ap eT v ≡ (lop (eK R) v ⊕ᴹ rop (eK S) v)
    actE v = ap-⊞ (lK (eK R)) (rK (eK S)) v
           ∙ cong₂ _⊕ᴹ_ (ap-lK (eK R) v) (ap-rK (eK S) v)

    actF : (v : Mod IJ) → ap fT v ≡ (lop (fK R) v ⊕ᴹ rop (fK S) v)
    actF v = ap-⊞ (lK (fK R)) (rK (fK S)) v
           ∙ cong₂ _⊕ᴹ_ (ap-lK (fK R) v) (ap-rK (fK S) v)

    actH : (v : Mod IJ) → ap hT v ≡ (lop (hK R) v ⊕ᴹ rop (hK S) v)
    actH v = ap-⊞ (lK (hK R)) (rK (hK S)) v
           ∙ cong₂ _⊕ᴹ_ (ap-lK (hK R) v) (ap-rK (hK S) v)

    -- The generic bracket expansion.  A and B are the two summands of
    -- the first operator, C and D of the second; each is additive.
    -- This is where fourSub is used.
    expand : (A B C D : Mod IJ → Mod IJ)
      → ((v w : Mod IJ) → A (v ⊕ᴹ w) ≡ (A v ⊕ᴹ A w))
      → ((v w : Mod IJ) → B (v ⊕ᴹ w) ≡ (B v ⊕ᴹ B w))
      → ((v w : Mod IJ) → C (v ⊕ᴹ w) ≡ (C v ⊕ᴹ C w))
      → ((v w : Mod IJ) → D (v ⊕ᴹ w) ≡ (D v ⊕ᴹ D w))
      → (v : Mod IJ)
      → ⟪ (λ u → A u ⊕ᴹ B u) , (λ u → C u ⊕ᴹ D u) ⟫ v
      ≡ ((⟪ A , C ⟫ v ⊕ᴹ ⟪ A , D ⟫ v) ⊕ᴹ (⟪ B , C ⟫ v ⊕ᴹ ⟪ B , D ⟫ v))
    expand A B C D addA addB addC addD v =
        cong₂ _⊖ᴹ_ (cong₂ _⊕ᴹ_ (addA (C v) (D v)) (addB (C v) (D v)))
                   (cong₂ _⊕ᴹ_ (addC (A v) (B v)) (addD (A v) (B v)))
      ∙ funExt (λ x →
            cong (λ z → ((A (C v) x + A (D v) x) + (B (C v) x + B (D v) x)) - z)
                 (abel4 (C (A v) x) (C (B v) x) (D (A v) x) (D (B v) x))
          ∙ fourSub (A (C v) x) (A (D v) x) (B (C v) x) (B (D v) x)
                    (C (A v) x) (D (A v) x) (C (B v) x) (D (B v) x))

    -- ...and the scalar side: 2·(a+b) = 2a + 2b, pointwise.
    scaSplit : (c : ℤ) (v w : Mod IJ)
      → sca c (v ⊕ᴹ w) ≡ (sca c v ⊕ᴹ sca c w)
    scaSplit c v w = funExt λ x → ·DistR+ c (v x) (w x)

    zeroᴹ : Mod IJ
    zeroᴹ = λ _ → pos 0

    -- (p + 0) + (0 + q) ≡ p + q, pointwise
    dropZeros : (p q : Mod IJ)
      → ((p ⊕ᴹ zeroᴹ) ⊕ᴹ (zeroᴹ ⊕ᴹ q)) ≡ (p ⊕ᴹ q)
    dropZeros p q = funExt λ x → cong₂ _+_ (+0ᵣ (p x)) (sym (pos0+ (q x)))

  -- ⟦ĥ,ê⟧ = 2ê
  tensor-he : (v : Mod IJ) → ⟪ ap hT , ap eT ⟫ v ≡ sca (pos 2) (ap eT v)
  tensor-he v =
      cong₂ _⊖ᴹ_ (cong (ap hT) (actE v)) (cong (ap eT) (actH v))
    ∙ cong₂ _⊖ᴹ_ (actH _) (actE _)
    ∙ expand (lop (hK R)) (rop (hK S)) (lop (eK R)) (rop (eK S))
             (lop-add (hK R)) (rop-add (hK S))
             (lop-add (eK R)) (rop-add (eK S)) v
    ∙ cong₂ _⊕ᴹ_
        (cong₂ _⊕ᴹ_ diagL (swap-lop-rop (hK R) (eK S) v))
        (cong₂ _⊕ᴹ_ (swap-rop-lop (hK S) (eK R) v) diagR)
    ∙ dropZeros (sca (pos 2) (lop (eK R) v)) (sca (pos 2) (rop (eK S) v))
    ∙ sym (scaSplit (pos 2) (lop (eK R) v) (rop (eK S) v))
    ∙ cong (sca (pos 2)) (sym (actE v))
    where
    diagL : ⟪ lop (hK R) , lop (eK R) ⟫ v ≡ sca (pos 2) (lop (eK R) v)
    diagL = funExt λ { (i , j) → funExt⁻ (he R (λ i′ → v (i′ , j))) i }
    diagR : ⟪ rop (hK S) , rop (eK S) ⟫ v ≡ sca (pos 2) (rop (eK S) v)
    diagR = funExt λ { (i , j) → funExt⁻ (he S (λ j′ → v (i , j′))) j }

  -- ⟦ĥ,f̂⟧ = (−2)f̂
  tensor-hf : (v : Mod IJ) → ⟪ ap hT , ap fT ⟫ v ≡ sca (- pos 2) (ap fT v)
  tensor-hf v =
      cong₂ _⊖ᴹ_ (cong (ap hT) (actF v)) (cong (ap fT) (actH v))
    ∙ cong₂ _⊖ᴹ_ (actH _) (actF _)
    ∙ expand (lop (hK R)) (rop (hK S)) (lop (fK R)) (rop (fK S))
             (lop-add (hK R)) (rop-add (hK S))
             (lop-add (fK R)) (rop-add (fK S)) v
    ∙ cong₂ _⊕ᴹ_
        (cong₂ _⊕ᴹ_ diagL (swap-lop-rop (hK R) (fK S) v))
        (cong₂ _⊕ᴹ_ (swap-rop-lop (hK S) (fK R) v) diagR)
    ∙ dropZeros (sca (- pos 2) (lop (fK R) v)) (sca (- pos 2) (rop (fK S) v))
    ∙ sym (scaSplit (- pos 2) (lop (fK R) v) (rop (fK S) v))
    ∙ cong (sca (- pos 2)) (sym (actF v))
    where
    diagL : ⟪ lop (hK R) , lop (fK R) ⟫ v ≡ sca (- pos 2) (lop (fK R) v)
    diagL = funExt λ { (i , j) → funExt⁻ (hf R (λ i′ → v (i′ , j))) i }
    diagR : ⟪ rop (hK S) , rop (fK S) ⟫ v ≡ sca (- pos 2) (rop (fK S) v)
    diagR = funExt λ { (i , j) → funExt⁻ (hf S (λ j′ → v (i , j′))) j }

  -- ⟦ê,f̂⟧ = ĥ.  THIS is the one where the off-diagonal terms matter:
  -- ⟪lop e, rop f⟫ and ⟪rop e, lop f⟫ are E_i F_j and F_j E_i for i ≠ j.
  tensor-ef : (v : Mod IJ) → ⟪ ap eT , ap fT ⟫ v ≡ ap hT v
  tensor-ef v =
      cong₂ _⊖ᴹ_ (cong (ap eT) (actF v)) (cong (ap fT) (actE v))
    ∙ cong₂ _⊖ᴹ_ (actE _) (actF _)
    ∙ expand (lop (eK R)) (rop (eK S)) (lop (fK R)) (rop (fK S))
             (lop-add (eK R)) (rop-add (eK S))
             (lop-add (fK R)) (rop-add (fK S)) v
    ∙ cong₂ _⊕ᴹ_
        (cong₂ _⊕ᴹ_ diagL (swap-lop-rop (eK R) (fK S) v))
        (cong₂ _⊕ᴹ_ (swap-rop-lop (eK S) (fK R) v) diagR)
    ∙ dropZeros (lop (hK R) v) (rop (hK S) v)
    ∙ sym (actH v)
    where
    diagL : ⟪ lop (eK R) , lop (fK R) ⟫ v ≡ lop (hK R) v
    diagL = funExt λ { (i , j) → funExt⁻ (ef R (λ i′ → v (i′ , j))) i }
    diagR : ⟪ rop (eK S) , rop (fK S) ⟫ v ≡ rop (hK S) v
    diagR = funExt λ { (i , j) → funExt⁻ (ef S (λ j′ → v (i , j′))) j }

-- THE LOAD-BEARING LEMMA: a tensor of two 𝔰𝔩₂-triples is an 𝔰𝔩₂-triple.
tensorRep : Sl2Rep → Sl2Rep → Sl2Rep
tensorRep R S = record
  { Ix = Ix R × Ix S
  ; eK = Tensor.eT R S
  ; fK = Tensor.fT R S
  ; hK = Tensor.hT R S
  ; he = Tensor.tensor-he R S
  ; hf = Tensor.tensor-hf R S
  ; ef = Tensor.tensor-ef R S
  }

------------------------------------------------------------------------
-- §4  The rank-one factor, imported.
--
-- Ix = ℕ × ℕ with the (κ , d) encoding of Sl2DivisorLattice (d = α − κ,
-- so α = κ + d is carried by the index).  The three kernels below have
-- exactly the structure constants of that module's ε, φ, η, and the
-- brackets are TRANSPORTED, not re-proved.
--
-- Note where truncation lives: εK (zero , d) = [], the EMPTY list.  The
-- kernel is indexed by the target, so "no source" at first index 0 is
-- the same structural truncation as in the rank-one module.
------------------------------------------------------------------------

Ch : Type₀
Ch = ℕ × ℕ

εK φK ηK : Op Ch
εK (zero  , d) = []
εK (suc κ , d) = ((κ , suc d) , pos 1) ∷ []
φK (κ , zero)  = []
φK (κ , suc d) = ((suc κ , d) , pos (suc κ ·ℕ suc d)) ∷ []
ηK (κ , d)     = ((κ , d) , pos κ - pos d) ∷ []

-- currying: Mod (ℕ × ℕ) → (ℕ → ℕ → ℤ), the module of Sl2DivisorLattice
cur : Mod Ch → ℕ → ℕ → ℤ
cur v κ d = v (κ , d)

private
  apε : (v : Mod Ch) → cur (ap εK v) ≡ ε (cur v)
  apε v = funExt λ κ → funExt λ d → go κ d
    where
    go : (κ d : ℕ) → ap εK v (κ , d) ≡ ε (cur v) κ d
    go zero    d = refl
    go (suc κ) d = +0ᵣ (pos 1 · v (κ , suc d)) ∙ ·1ₗ (v (κ , suc d))

  apφ : (v : Mod Ch) → cur (ap φK v) ≡ φ (cur v)
  apφ v = funExt λ κ → funExt λ d → go κ d
    where
    go : (κ d : ℕ) → ap φK v (κ , d) ≡ φ (cur v) κ d
    go κ zero    = refl
    go κ (suc d) = +0ᵣ (pos (suc κ ·ℕ suc d) · v (suc κ , d))

  apη : (v : Mod Ch) → cur (ap ηK v) ≡ η (cur v)
  apη v = funExt λ κ → funExt λ d → +0ᵣ ((pos κ - pos d) · v (κ , d))

  -- transport of a bracket along `cur`
  brTrans : (T U : Op Ch) (T′ U′ : (ℕ → ℕ → ℤ) → (ℕ → ℕ → ℤ))
    → ((v : Mod Ch) → cur (ap T v) ≡ T′ (cur v))
    → ((v : Mod Ch) → cur (ap U v) ≡ U′ (cur v))
    → (v : Mod Ch) (κ d : ℕ)
    → ⟪ ap T , ap U ⟫ v (κ , d)
    ≡ (T′ (U′ (cur v)) κ d - U′ (T′ (cur v)) κ d)
  brTrans T U T′ U′ pT pU v κ d =
    cong₂ _-_
      (funExt⁻ (funExt⁻ (pT (ap U v)) κ) d ∙ cong (λ z → T′ z κ d) (pU v))
      (funExt⁻ (funExt⁻ (pU (ap T v)) κ) d ∙ cong (λ z → U′ z κ d) (pT v))

chain-he : (v : Mod Ch) → ⟪ ap ηK , ap εK ⟫ v ≡ sca (pos 2) (ap εK v)
chain-he v = funExt λ { (κ , d) →
    brTrans ηK εK η ε apη apε v κ d
  ∙ funExt⁻ (funExt⁻ (bracket-ηε (cur v)) κ) d
  ∙ cong (pos 2 ·_) (sym (funExt⁻ (funExt⁻ (apε v) κ) d)) }

chain-hf : (v : Mod Ch) → ⟪ ap ηK , ap φK ⟫ v ≡ sca (- pos 2) (ap φK v)
chain-hf v = funExt λ { (κ , d) →
    brTrans ηK φK η φ apη apφ v κ d
  ∙ funExt⁻ (funExt⁻ (bracket-ηφ (cur v)) κ) d
  ∙ cong ((- pos 2) ·_) (sym (funExt⁻ (funExt⁻ (apφ v) κ) d)) }

chain-ef : (v : Mod Ch) → ⟪ ap εK , ap φK ⟫ v ≡ ap ηK v
chain-ef v = funExt λ { (κ , d) →
    brTrans εK φK ε φ apε apφ v κ d
  ∙ funExt⁻ (funExt⁻ (bracket-εφ (cur v)) κ) d
  ∙ sym (funExt⁻ (funExt⁻ (apη v) κ) d) }

-- V_α, all α at once: the rank-one triple as a representation.
chainRep : Sl2Rep
chainRep = record
  { Ix = Ch ; eK = εK ; fK = φK ; hK = ηK
  ; he = chain-he ; hf = chain-hf ; ef = chain-ef }

-- the trivial (zero) triple on k: the base of the induction, B_1 = k
trivRep : Sl2Rep
trivRep = record
  { Ix = Unit
  ; eK = λ _ → [] ; fK = λ _ → [] ; hK = λ _ → []
  ; he = λ v → funExt λ _ → -Cancel (pos 0) ∙ sym (·0ᵣ (pos 2))
  ; hf = λ v → funExt λ _ → -Cancel (pos 0) ∙ sym (·0ᵣ (- pos 2))
  ; ef = λ v → funExt λ _ → -Cancel (pos 0) }

------------------------------------------------------------------------
-- §5  The induction: the multi-index divisor lattice carries the action.
--
-- Bn m has index type (ℕ×ℕ)^m — one (κ_i , d_i = α_i − κ_i) pair per
-- prime — and its three operators are the m-fold comultiplication,
-- i.e. ε = Σ_i E_i, φ = Σ_j F_j, η = Σ_i H_i, unrolled by the recursion
-- eK (Bn (suc m)) = lK εK ⊞ rK (eK (Bn m)).  That every Bn m satisfies
-- the three relations is the content of the induction; it is one line
-- because §3 did the work.
--
-- The recursion is anchored at m = 1 rather than only at m = 0, so that
-- Bn m has index type (ℕ×ℕ)^m ON THE NOSE for m ≥ 1 — with no trailing
-- Unit factor.  This is not cosmetic: it is what makes §6's rank-2
-- displays displays OF THE INDUCTION'S OUTPUT rather than of a
-- separately-built rank-2 object.  `Rk2≡Bn2` below records that, by
-- `refl`.  With the older `Bn (suc m) = tensorRep chainRep (Bn m)`
-- anchored only at zero, Bn 2 had index type Ch × (Ch × Unit) and no
-- such identification was available.
------------------------------------------------------------------------

Bn : ℕ → Sl2Rep
Bn zero          = trivRep
Bn (suc zero)    = chainRep
Bn (suc (suc m)) = tensorRep chainRep (Bn (suc m))

-- the multi-index divisor lattice of a number with m prime factors
divisorLatticeSl2 : (m : ℕ) → Sl2Rep
divisorLatticeSl2 = Bn

------------------------------------------------------------------------
-- §6  The comultiplication on decomposable tensors, and the rank-2
--     displays of the note (general in κ₁,d₁,κ₂,d₂).
------------------------------------------------------------------------

-- v ⊗ w
_⊗ᴹ_ : {I J : Type₀} → Mod I → Mod J → Mod (I × J)
(v ⊗ᴹ w) (i , j) = v i · w j

module _ (R S : Sl2Rep) where
  private
    lop-⊗ : (T : Op (Ix R)) (v : Mod (Ix R)) (w : Mod (Ix S))
      → lop T (v ⊗ᴹ w) ≡ (ap T v ⊗ᴹ w)
    lop-⊗ T v w = funExt λ { (i , j) → sumL-scaleR (T i) v (w j) }

    rop-⊗ : (U : Op (Ix S)) (v : Mod (Ix R)) (w : Mod (Ix S))
      → rop U (v ⊗ᴹ w) ≡ (v ⊗ᴹ ap U w)
    rop-⊗ U v w = funExt λ { (i , j) → sumL-scaleL (U j) w (v i) }

  -- ε(v⊗w) = (εv)⊗w + v⊗(εw) : the standard comultiplication, proved.
  tensor-E : (v : Mod (Ix R)) (w : Mod (Ix S))
    → ap (eK (tensorRep R S)) (v ⊗ᴹ w)
    ≡ ((ap (eK R) v ⊗ᴹ w) ⊕ᴹ (v ⊗ᴹ ap (eK S) w))
  tensor-E v w =
      ap-⊞ (lK (eK R)) (rK (eK S)) (v ⊗ᴹ w)
    ∙ cong₂ _⊕ᴹ_ (ap-lK (eK R) (v ⊗ᴹ w) ∙ lop-⊗ (eK R) v w)
                 (ap-rK (eK S) (v ⊗ᴹ w) ∙ rop-⊗ (eK S) v w)

  tensor-F : (v : Mod (Ix R)) (w : Mod (Ix S))
    → ap (fK (tensorRep R S)) (v ⊗ᴹ w)
    ≡ ((ap (fK R) v ⊗ᴹ w) ⊕ᴹ (v ⊗ᴹ ap (fK S) w))
  tensor-F v w =
      ap-⊞ (lK (fK R)) (rK (fK S)) (v ⊗ᴹ w)
    ∙ cong₂ _⊕ᴹ_ (ap-lK (fK R) (v ⊗ᴹ w) ∙ lop-⊗ (fK R) v w)
                 (ap-rK (fK S) (v ⊗ᴹ w) ∙ rop-⊗ (fK S) v w)

  tensor-H : (v : Mod (Ix R)) (w : Mod (Ix S))
    → ap (hK (tensorRep R S)) (v ⊗ᴹ w)
    ≡ ((ap (hK R) v ⊗ᴹ w) ⊕ᴹ (v ⊗ᴹ ap (hK S) w))
  tensor-H v w =
      ap-⊞ (lK (hK R)) (rK (hK S)) (v ⊗ᴹ w)
    ∙ cong₂ _⊕ᴹ_ (ap-lK (hK R) (v ⊗ᴹ w) ∙ lop-⊗ (hK R) v w)
                 (ap-rK (hK S) (v ⊗ᴹ w) ∙ rop-⊗ (hK S) v w)

-- ---------------------------------------------------------------------
-- Rank 2 : R = S = chainRep.  The basis vector ξ^{(κ₁,κ₂)} of
-- V_{α₁} ⊗ V_{α₂} is dl κ₁ d₁ ⊗ dl κ₂ d₂ with α_i = κ_i + d_i.

Rk2 : Sl2Rep
Rk2 = tensorRep chainRep chainRep

-- The rank-2 object the displays below are about IS the m = 2 stage of
-- §5's induction — definitionally, not up to an equivalence that would
-- have to be constructed.  Every display and every §7 control is
-- therefore a statement about `Bn 2`.
Rk2≡Bn2 : Rk2 ≡ Bn 2
Rk2≡Bn2 = refl

dl : ℕ → ℕ → Mod Ch
dl κ d (a , b) = δ κ d a b

private
  -- the rank-one actions on a basis vector, in Mod Ch form
  ap-ε-dl : (κ d : ℕ) → ap εK (dl κ (suc d)) ≡ dl (suc κ) d
  ap-ε-dl κ d = funExt λ { (a , b) →
      funExt⁻ (funExt⁻ (apε (dl κ (suc d))) a) b
    ∙ funExt⁻ (funExt⁻ (ε-δ κ d) a) b }

  ap-ε-dl-top : (κ : ℕ) → ap εK (dl κ zero) ≡ (λ _ → pos 0)
  ap-ε-dl-top κ = funExt λ { (a , b) →
      funExt⁻ (funExt⁻ (apε (dl κ zero)) a) b
    ∙ funExt⁻ (funExt⁻ (ε-δ-top κ) a) b }

  ap-φ-dl : (κ d : ℕ)
    → ap φK (dl (suc κ) d) ≡ sca (pos (suc κ ·ℕ suc d)) (dl κ (suc d))
  ap-φ-dl κ d = funExt λ { (a , b) →
      funExt⁻ (funExt⁻ (apφ (dl (suc κ) d)) a) b
    ∙ funExt⁻ (funExt⁻ (φ-δ κ d) a) b }

  ap-φ-dl-bot : (d : ℕ) → ap φK (dl zero d) ≡ (λ _ → pos 0)
  ap-φ-dl-bot d = funExt λ { (a , b) →
      funExt⁻ (funExt⁻ (apφ (dl zero d)) a) b
    ∙ funExt⁻ (funExt⁻ (φ-δ-bot d) a) b }

  ap-η-dl : (κ d : ℕ) → ap ηK (dl κ d) ≡ sca (pos κ - pos d) (dl κ d)
  ap-η-dl κ d = funExt λ { (a , b) →
      funExt⁻ (funExt⁻ (apη (dl κ d)) a) b
    ∙ funExt⁻ (funExt⁻ (η-δ κ d) a) b }

  scaTensorL : (c : ℤ) (v : Mod Ch) (w : Mod Ch)
    → (sca c v ⊗ᴹ w) ≡ sca c (v ⊗ᴹ w)
  scaTensorL c v w = funExt λ { (x , y) → sym (·Assoc c (v x) (w y)) }

  scaTensorR : (c : ℤ) (v : Mod Ch) (w : Mod Ch)
    → (v ⊗ᴹ sca c w) ≡ sca c (v ⊗ᴹ w)
  scaTensorR c v w = funExt λ { (x , y) →
    ·Assoc (v x) c (w y) ∙ cong (_· w y) (·Comm (v x) c) ∙ sym (·Assoc c (v x) (w y)) }

  ⊕-sca : (c c′ : ℤ) (u : Mod (Ch × Ch))
    → (sca c u ⊕ᴹ sca c′ u) ≡ sca (c + c′) u
  ⊕-sca c c′ u = funExt λ x → sym (·DistL+ c c′ (u x))

-- ε on a rank-2 basis vector, INTERIOR of both chains:
--   ε ξ^{(κ₁,κ₂)} = ξ^{(κ₁+1,κ₂)} + ξ^{(κ₁,κ₂+1)}   — the note's Σ_i.
rk2-ε : (κ₁ d₁ κ₂ d₂ : ℕ)
  → ap (eK Rk2) (dl κ₁ (suc d₁) ⊗ᴹ dl κ₂ (suc d₂))
  ≡ ((dl (suc κ₁) d₁ ⊗ᴹ dl κ₂ (suc d₂)) ⊕ᴹ (dl κ₁ (suc d₁) ⊗ᴹ dl (suc κ₂) d₂))
rk2-ε κ₁ d₁ κ₂ d₂ =
    tensor-E chainRep chainRep (dl κ₁ (suc d₁)) (dl κ₂ (suc d₂))
  ∙ cong₂ _⊕ᴹ_ (cong (_⊗ᴹ dl κ₂ (suc d₂)) (ap-ε-dl κ₁ d₁))
               (cong (dl κ₁ (suc d₁) ⊗ᴹ_) (ap-ε-dl κ₂ d₂))

-- ε at the TOP of the first chain (κ₁ = α₁): that summand is dropped —
-- the truncation ξ₁^{α₁+1} = 0, in the multi-index setting, with the
-- second summand surviving untouched.  Rank one cannot state this.
rk2-ε-top₁ : (κ₁ κ₂ d₂ : ℕ)
  → ap (eK Rk2) (dl κ₁ zero ⊗ᴹ dl κ₂ (suc d₂))
  ≡ (((λ _ → pos 0) ⊗ᴹ dl κ₂ (suc d₂)) ⊕ᴹ (dl κ₁ zero ⊗ᴹ dl (suc κ₂) d₂))
rk2-ε-top₁ κ₁ κ₂ d₂ =
    tensor-E chainRep chainRep (dl κ₁ zero) (dl κ₂ (suc d₂))
  ∙ cong₂ _⊕ᴹ_ (cong (_⊗ᴹ dl κ₂ (suc d₂)) (ap-ε-dl-top κ₁))
               (cong (dl κ₁ zero ⊗ᴹ_) (ap-ε-dl κ₂ d₂))

-- φ on a rank-2 basis vector: coefficient κ_i(α_i − κ_i + 1) in the
-- i-th summand, with α_i = κ_i + d_i, i.e. (κ+1)(d+1) at index (κ+1,d).
rk2-φ : (κ₁ d₁ κ₂ d₂ : ℕ)
  → ap (fK Rk2) (dl (suc κ₁) d₁ ⊗ᴹ dl (suc κ₂) d₂)
  ≡ ( sca (pos (suc κ₁ ·ℕ suc d₁)) (dl κ₁ (suc d₁) ⊗ᴹ dl (suc κ₂) d₂)
    ⊕ᴹ sca (pos (suc κ₂ ·ℕ suc d₂)) (dl (suc κ₁) d₁ ⊗ᴹ dl κ₂ (suc d₂)) )
rk2-φ κ₁ d₁ κ₂ d₂ =
    tensor-F chainRep chainRep (dl (suc κ₁) d₁) (dl (suc κ₂) d₂)
  ∙ cong₂ _⊕ᴹ_
      (cong (_⊗ᴹ dl (suc κ₂) d₂) (ap-φ-dl κ₁ d₁)
        ∙ scaTensorL (pos (suc κ₁ ·ℕ suc d₁)) (dl κ₁ (suc d₁)) (dl (suc κ₂) d₂))
      (cong (dl (suc κ₁) d₁ ⊗ᴹ_) (ap-φ-dl κ₂ d₂)
        ∙ scaTensorR (pos (suc κ₂ ·ℕ suc d₂)) (dl (suc κ₁) d₁) (dl κ₂ (suc d₂)))

-- η on a rank-2 basis vector: eigenvalue (κ₁ − d₁) + (κ₂ − d₂), which
-- is 2|κ| − (α₁ + α₂) — the note's η display at m = 2.
rk2-η : (κ₁ d₁ κ₂ d₂ : ℕ)
  → ap (hK Rk2) (dl κ₁ d₁ ⊗ᴹ dl κ₂ d₂)
  ≡ sca ((pos κ₁ - pos d₁) + (pos κ₂ - pos d₂)) (dl κ₁ d₁ ⊗ᴹ dl κ₂ d₂)
rk2-η κ₁ d₁ κ₂ d₂ =
    tensor-H chainRep chainRep (dl κ₁ d₁) (dl κ₂ d₂)
  ∙ cong₂ _⊕ᴹ_
      (cong (_⊗ᴹ dl κ₂ d₂) (ap-η-dl κ₁ d₁)
        ∙ scaTensorL (pos κ₁ - pos d₁) (dl κ₁ d₁) (dl κ₂ d₂))
      (cong (dl κ₁ d₁ ⊗ᴹ_) (ap-η-dl κ₂ d₂)
        ∙ scaTensorR (pos κ₂ - pos d₂) (dl κ₁ d₁) (dl κ₂ d₂))
  ∙ ⊕-sca (pos κ₁ - pos d₁) (pos κ₂ - pos d₂) (dl κ₁ d₁ ⊗ᴹ dl κ₂ d₂)

------------------------------------------------------------------------
-- §7  CONTROLS at rank 2, with DISTINCT α₁ = 1 ≠ 3 = α₂.
--
-- The brackets of §3 would also hold for the vacuous triple (all three
-- operators zero) — trivRep is exactly that.  So, as in the rank-one
-- module's §5′, here are the operators evaluated on actual basis
-- vectors of V₁ ⊗ V₃ = B_{p q³}, each `refl`, i.e. definitional.
--
-- Index convention: a basis vector of V₁ ⊗ V₃ is
--   ξ₁^{κ₁} ξ₂^{κ₂}  ↔  dl κ₁ (1 − κ₁) ⊗ᴹ dl κ₂ (3 − κ₂)
-- and we read a coefficient at the index ((a₁,b₁) , (a₂,b₂)).
------------------------------------------------------------------------

private
  -- the basis vector ξ₁¹ ξ₂² of V₁ ⊗ V₃  (κ = (1,2), α = (1,3))
  u12 : Mod (Ch × Ch)
  u12 = dl 1 0 ⊗ᴹ dl 2 1

  -- the basis vector ξ₁⁰ ξ₂² of V₁ ⊗ V₃
  u02 : Mod (Ch × Ch)
  u02 = dl 0 1 ⊗ᴹ dl 2 1

  ---------------------------------------------------------------------
  -- η : eigenvalue 2|κ| − (α₁+α₂).

  -- on ξ₁¹ξ₂² : 2·3 − 4 = 2
  control-η-12 : ap (hK Rk2) u12 ((1 , 0) , (2 , 1)) ≡ pos 2
  control-η-12 = refl

  -- on ξ₁⁰ξ₂² : 2·2 − 4 = 0.  A DIFFERENT eigenvalue for a DIFFERENT
  -- basis vector, so η is not a scalar operator.
  control-η-02 : ap (hK Rk2) u02 ((0 , 1) , (2 , 1)) ≡ pos 0
  control-η-02 = refl

  ---------------------------------------------------------------------
  -- ε = E₁ + E₂ : BOTH summands are present and they land on DIFFERENT
  -- basis vectors, which is what "sum over i" means.

  -- E₂ ξ₁⁰ξ₂² = ξ₁⁰ξ₂³ : coefficient 1
  control-ε-02-second : ap (eK Rk2) u02 ((0 , 1) , (3 , 0)) ≡ pos 1
  control-ε-02-second = refl

  -- E₁ ξ₁⁰ξ₂² = ξ₁¹ξ₂² : coefficient 1
  control-ε-02-first : ap (eK Rk2) u02 ((1 , 0) , (2 , 1)) ≡ pos 1
  control-ε-02-first = refl

  -- E₁ ξ₁¹ξ₂² = 0 : κ₁ = α₁ = 1, the truncation ξ₁² = 0, IN THE FIRST
  -- COORDINATE ONLY — while E₂ on the same vector is nonzero, below.
  control-ε-12-first-truncates : ap (eK Rk2) u12 ((2 , 0) , (2 , 1)) ≡ pos 0
  control-ε-12-first-truncates = refl

  -- E₂ ξ₁¹ξ₂² = ξ₁¹ξ₂³ ≠ 0 : the second coordinate is not at its top.
  control-ε-12-second : ap (eK Rk2) u12 ((1 , 0) , (3 , 0)) ≡ pos 1
  control-ε-12-second = refl

  ---------------------------------------------------------------------
  -- φ = F₁ + F₂ : coefficient κ_i(α_i − κ_i + 1), distinct per factor.

  -- F₁ ξ₁¹ξ₂² = 1·(1−1+1) ξ₁⁰ξ₂² = 1 · ξ₁⁰ξ₂²
  control-φ-12-first : ap (fK Rk2) u12 ((0 , 1) , (2 , 1)) ≡ pos 1
  control-φ-12-first = refl

  -- F₂ ξ₁¹ξ₂² = 2·(3−2+1) ξ₁¹ξ₂¹ = 4 · ξ₁¹ξ₂¹.  DIFFERENT coefficient
  -- from F₁'s, because α₁ ≠ α₂ — this is why the controls use 1 and 3.
  control-φ-12-second : ap (fK Rk2) u12 ((1 , 0) , (1 , 2)) ≡ pos 4
  control-φ-12-second = refl

  -- F₁ ξ₁⁰ξ₂² = 0 with no clause for it: the coefficient κ₁ vanishes.
  control-φ-02-first : ap (fK Rk2) u02 ((0 , 2) , (2 , 1)) ≡ pos 0
  control-φ-02-first = refl

  ---------------------------------------------------------------------
  -- NON-VACUITY OF THE OFF-DIAGONAL CANCELLATION.
  --
  -- §3 proves ⟪ lop εK , rop φK ⟫ = 0, i.e. E₁F₂ = F₂E₁.  That would be
  -- worthless if both sides were identically zero.  They are not:
  -- E₁F₂ ξ₁⁰ξ₂² = F₂ then E₁ = 4 · ξ₁¹ξ₂¹, coefficient 4 ≠ 0.

  control-E₁F₂-nonzero :
    lop εK (rop φK u02) ((1 , 0) , (1 , 2)) ≡ pos 4
  control-E₁F₂-nonzero = refl

  control-F₂E₁-nonzero :
    rop φK (lop εK u02) ((1 , 0) , (1 , 2)) ≡ pos 4
  control-F₂E₁-nonzero = refl

  -- ...and the commutator of those two nonzero operators is 0 — the
  -- theorem of §2, instantiated, at a point where both terms are 4.
  control-off-diagonal-cancels :
    ⟪ lop εK , rop φK ⟫ u02 ((1 , 0) , (1 , 2)) ≡ pos 0
  control-off-diagonal-cancels =
    funExt⁻ (swap-lop-rop εK φK u02) ((1 , 0) , (1 , 2))

  -- The other off-diagonal pair, likewise nonzero termwise:
  -- E₂F₁ ξ₁¹ξ₂² = 1 · ξ₁⁰ξ₂³.
  control-E₂F₁-nonzero :
    rop εK (lop φK u12) ((0 , 1) , (3 , 0)) ≡ pos 1
  control-E₂F₁-nonzero = refl

  control-off-diagonal-cancels′ :
    ⟪ rop εK , lop φK ⟫ u12 ((0 , 1) , (3 , 0)) ≡ pos 0
  control-off-diagonal-cancels′ =
    funExt⁻ (swap-rop-lop εK φK u12) ((0 , 1) , (3 , 0))

------------------------------------------------------------------------
-- §8  What is NOT here.
--
--  * A multi-index δ and the display ε ξ^κ = Σ_{i=1}^m ξ^{κ+e_i} for
--    GENERAL m.  What is proved for general m is the action (§5) and
--    the recursive comultiplication (§6, tensor-E/F/H); §6's rank-2
--    displays are general in (κ₁,d₁,κ₂,d₂) but are stated at m = 2.
--  * The multigrading (the analogue of Sl2DivisorLattice §4): that each
--    B_n = ⨂ V_{α_i} with FIXED α is invariant.  It follows factorwise
--    from that module's ε-grade/φ-grade/η-grade, but is not written.
--  * Everything in note §5 — complete reducibility, rank-unimodality,
--    Sperner — which needs characteristic 0 and finite-dimensional
--    𝔰𝔩₂ theory.  Nothing here bears on it.
--  * Any claim of novelty.  The coproduct is Humphreys §7; the poset
--    application is Stanley 1980 / Proctor 1982 (note §4).
------------------------------------------------------------------------
