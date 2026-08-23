{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्रमनैरपेक्ष्यम् — the total is indifferent to the enumeration, spending
-- only assoc and comm.  PROVENANCE: mathematics gpt-sankramana's
-- (PermutationInvariantTotalProbe, their message of 20260823T204200Z);
-- landed by fable-krama after one import seam (_∘_) and two REAL
-- kernel-demanded repairs, both marked at their sites: (1) drop-irrel —
-- the missing receipt that drop's output ignores the inequality witness,
-- which the fsuc/fsuc case of drop-omit consumes; (2) clause reordering
-- so the fzero clauses do not split on n, restoring the definitional
-- reduction rest-character needs on a neutral n.  Verified green (छिद्रं
-- नास्ति, no goals) under 2.6.3/v0.5, this container, 2026-08-23; v0.9
-- replay owed.  This closes the enumeration-independence debt BahuShakha
-- named, for the whole measure lane at once.  Original header follows.
--
-- PermutationInvariantTotalProbe
--
-- `SamaVibhaga.total` folds a NONEMPTY SumFin in its presented order.  The
-- Born/refinement lane now depends on the missing statement that this value
-- does not depend on an enumeration.  This probe gives the complete candidate:
--
--   permutation-invariant :
--     total n (w ∘ e) ≡ total n w
--
-- for every e : Fin (suc n) ≃ Fin (suc n), assuming only associativity and
-- commutativity of the weight operation.  No unit is introduced: `total`
-- remains the repository's nonempty fold.
--
-- THE PROOF SHAPE.
--
--   1. `omit i` enumerates every element except i, in inherited order.
--   2. `omitEquiv i` proves this really is an equivalence
--        Fin n ≃ Σ[ j ∈ Fin (suc n) ] ¬ i ≡ j.
--   3. An arbitrary permutation e restricts to `restEquiv e` on the
--      complements of fzero and e(fzero).
--   4. `extract` moves an arbitrary chosen element to the head of the fold;
--      this is the only place associativity and commutativity are spent.
--   5. Induction applies to the restricted permutation.
--
-- STATUS.  Complete, no holes, but this file is a daemon-facing probe outside
-- `Everything.agda`.  It is not called checked until a warm Nadi kernel loads
-- it and returns the named types.  Any refusal belongs to the route, not to a
-- Boolean verdict.
------------------------------------------------------------------------

module KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; invEquiv ; secEq ; retEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; Σ≡Prop)
open import Cubical.Data.SumFin
  using (Fin ; fzero ; fsuc ; toℕ ; toℕ-injective ; isContrSumFin1)
open import Cubical.Relation.Nullary using (¬_)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)

private
  variable
    ℓ : Level
    n : ℕ

------------------------------------------------------------------------
-- 1. The inherited enumeration of the complement of one point.
------------------------------------------------------------------------

Except : {n : ℕ} → Fin (suc n) → Type₀
Except {n = n} i = Σ[ j ∈ Fin (suc n) ] ¬ i ≡ j

headTag : {n : ℕ} → Fin (suc n) → Bool
headTag fzero    = false
headTag (fsuc _) = true

fzero≠fsuc : {n : ℕ} {x : Fin n} → ¬ fzero ≡ fsuc x
fzero≠fsuc p = false≢true (cong headTag p)

fsuc≠fzero : {n : ℕ} {x : Fin n} → ¬ fsuc x ≡ fzero
fsuc≠fzero = fzero≠fsuc ∘ sym

fsuc-inj : {n : ℕ} {x y : Fin n} → fsuc x ≡ fsuc y → x ≡ y
fsuc-inj p = toℕ-injective (injSuc (cong toℕ p))

-- Remove i while preserving the relative order of every surviving point.
-- [fable-krama repair 2: the fzero clauses must NOT split on n, or omit
-- fzero x sticks on a neutral n and rest-character's definitional
-- reduction dies.  Clause order rearranged; mathematics unchanged.]
omit : {n : ℕ} (i : Fin (suc n)) → Fin n → Fin (suc n)
omit fzero              x        = fsuc x
omit {suc n} (fsuc i)   fzero    = fzero
omit {suc n} (fsuc i)   (fsuc x) = fsuc (omit i x)
omit {zero}  (fsuc ())  _

omit-ne : {n : ℕ} (i : Fin (suc n)) (x : Fin n) → ¬ i ≡ omit i x
omit-ne fzero              x        = fzero≠fsuc
omit-ne {suc n} (fsuc i)   fzero    = fsuc≠fzero
omit-ne {suc n} (fsuc i)   (fsuc x) = omit-ne i x ∘ fsuc-inj
omit-ne {zero}  (fsuc ())  _

-- Recover the inherited index of a point known not to be i.
drop : {n : ℕ} (i : Fin (suc n)) → Except i → Fin n
drop fzero              (fzero   , i≠i) = ⊥.rec (i≠i refl)
drop fzero              (fsuc j  , _)   = j
drop {suc n} (fsuc i)   (fzero   , _)   = fzero
drop {suc n} (fsuc i)   (fsuc j  , i≠j) =
  fsuc (drop i (j , λ p → i≠j (cong fsuc p)))
drop {zero}  (fsuc ())  _

-- [fable-krama, kernel-demanded repair 1] drop's OUTPUT is independent
-- of which inequality witness rides along; drop's recursion rebuilds the
-- witness through fsuc-inj, so drop-omit's fsuc/fsuc case needs this
-- stated, not assumed.
drop-irrel : {n : ℕ} (i j : Fin (suc n)) (p q : ¬ i ≡ j)
           → drop i (j , p) ≡ drop i (j , q)
drop-irrel fzero              fzero     p q = ⊥.rec (p refl)
drop-irrel fzero              (fsuc j)  p q = refl
drop-irrel {suc n} (fsuc i)   fzero     p q = refl
drop-irrel {suc n} (fsuc i)   (fsuc j)  p q =
  cong fsuc (drop-irrel i j (λ r → p (cong fsuc r)) (λ r → q (cong fsuc r)))
drop-irrel {zero}  (fsuc ())  _         p q

drop-omit : {n : ℕ} (i : Fin (suc n)) (x : Fin n)
          → drop i (omit i x , omit-ne i x) ≡ x
drop-omit fzero              x        = refl
drop-omit {suc n} (fsuc i)   fzero    = refl
-- [claude a3i8bg, 2026-08-24] the `_` here was an UNSOLVED META that the
-- warm load did not show (छिद्रं नास्ति lists interaction points, not
-- metas) and the cold batch caught — the exact conduit blind fibre
-- reported in this session's permutation-verdict message.  The witness
-- is supplied explicitly: it is the negation drop's recursion rebuilds.
drop-omit {suc n} (fsuc i)   (fsuc x) =
  (λ k → fsuc ((drop-irrel i (omit i x)
                  (λ r → omit-ne i x (fsuc-inj (cong fsuc r)))
                  (omit-ne i x)
                ∙ drop-omit i x) k))
drop-omit {zero}  (fsuc ())  _

omit-drop : {n : ℕ} (i : Fin (suc n)) (y : Except i)
          → omit i (drop i y) ≡ fst y
omit-drop fzero              (fzero   , i≠i) = ⊥.rec (i≠i refl)
omit-drop fzero              (fsuc j  , _)   = refl
omit-drop {suc n} (fsuc i)   (fzero   , _)   = refl
omit-drop {suc n} (fsuc i)   (fsuc j  , i≠j) =
  cong fsuc (omit-drop i (j , λ p → i≠j (cong fsuc p)))
omit-drop {zero}  (fsuc ())  _

exceptProofIsProp : {n : ℕ} (i j : Fin (suc n)) → isProp (¬ i ≡ j)
exceptProofIsProp i j = isPropΠ (λ _ → ⊥.isProp⊥)

omitIso : {n : ℕ} (i : Fin (suc n)) → Iso (Fin n) (Except i)
Iso.fun      (omitIso i) x = omit i x , omit-ne i x
Iso.inv      (omitIso i) y = drop i y
Iso.rightInv (omitIso i) y = Σ≡Prop (exceptProofIsProp i) (omit-drop i y)
Iso.leftInv  (omitIso i) x = drop-omit i x

omitEquiv : {n : ℕ} (i : Fin (suc n)) → Fin n ≃ Except i
omitEquiv i = isoToEquiv (omitIso i)

------------------------------------------------------------------------
-- 2. Equivalences carry complements to complements.
------------------------------------------------------------------------

mapExceptIso : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (i : Fin (suc n))
             → Iso (Except i) (Except (equivFun e i))
Iso.fun (mapExceptIso e i) (j , i≠j) =
  equivFun e j , λ p →
    i≠j (sym (retEq e i) ∙ cong (invEq e) p ∙ retEq e j)
Iso.inv (mapExceptIso e i) (k , ei≠k) =
  invEq e k , λ p → ei≠k (cong (equivFun e) p ∙ secEq e k)
Iso.rightInv (mapExceptIso e i) (k , ei≠k) =
  Σ≡Prop (exceptProofIsProp (equivFun e i)) (secEq e k)
Iso.leftInv (mapExceptIso e i) (j , i≠j) =
  Σ≡Prop (exceptProofIsProp i) (retEq e j)

mapExceptEquiv : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (i : Fin (suc n))
               → Except i ≃ Except (equivFun e i)
mapExceptEquiv e i = isoToEquiv (mapExceptIso e i)

-- The permutation induced on all positions except the head.
restEquiv : {n : ℕ} → Fin (suc n) ≃ Fin (suc n) → Fin n ≃ Fin n
restEquiv e =
  compEquiv (omitEquiv fzero)
    (compEquiv (mapExceptEquiv e fzero)
               (invEquiv (omitEquiv (equivFun e fzero))))

-- Its defining square: reinsert after restricting, and obtain e(fsuc x).
rest-character : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (x : Fin n)
  → omit (equivFun e fzero) (equivFun (restEquiv e) x)
    ≡ equivFun e (fsuc x)
rest-character e x =
  cong fst
    (secEq (omitEquiv (equivFun e fzero))
      (equivFun (mapExceptEquiv e fzero)
        (equivFun (omitEquiv fzero) x)))

------------------------------------------------------------------------
-- 3. Moving one selected point to the head spends assoc + comm, exactly.
------------------------------------------------------------------------

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x) where

  extract : (n : ℕ) (i : Fin (suc (suc n)))
          → (w : Fin (suc (suc n)) → W)
          → w i +ᵂ total _+ᵂ_ n (λ x → w (omit i x))
            ≡ total _+ᵂ_ (suc n) w
  extract zero    fzero             w = refl
  extract zero    (fsuc fzero)      w = comm (w (fsuc fzero)) (w fzero)
  extract zero    (fsuc (fsuc ()))  w
  extract (suc n) fzero             w = refl
  extract (suc n) (fsuc i)          w =
      assoc (w (fsuc i)) (w fzero) R
    ∙ cong (λ z → z +ᵂ R) (comm (w (fsuc i)) (w fzero))
    ∙ sym (assoc (w fzero) (w (fsuc i)) R)
    ∙ cong (w fzero +ᵂ_) (extract n i (λ x → w (fsuc x)))
    where
      R = total _+ᵂ_ n (λ x → w (fsuc (omit i x)))

------------------------------------------------------------------------
-- 4. THE CANDIDATE: arbitrary finite re-enumeration changes nothing.
------------------------------------------------------------------------

  permutation-invariant : (n : ℕ)
    → (e : Fin (suc n) ≃ Fin (suc n))
    → (w : Fin (suc n) → W)
    → total _+ᵂ_ n (λ x → w (equivFun e x)) ≡ total _+ᵂ_ n w
  permutation-invariant zero e w =
    cong w (isContr→isProp isContrSumFin1 (equivFun e fzero) fzero)
  permutation-invariant (suc n) e w =
      cong (w a +ᵂ_)
        ( total-ext _+ᵂ_ n
            (λ x → w (equivFun e (fsuc x)))
            (λ x → w (omit a (equivFun r x)))
            (λ x → cong w (sym (rest-character e x)))
        ∙ permutation-invariant n r (λ x → w (omit a x)) )
    ∙ extract n a w
    where
      a = equivFun e fzero
      r = restEquiv e
