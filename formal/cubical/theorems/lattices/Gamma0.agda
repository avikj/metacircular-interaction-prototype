{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Γ₀(D): the congruence subgroup attached to a Smith diagonal, as a
-- decidable predicate, and the torsor it acts on.
--
-- For D = diag(d₀,…,d_{n-1}) the residual freedom in a Smith
-- presentation U A V = D is the stabiliser of D.  A matrix P belongs to
-- it (on the left) exactly when its D-conjugate is again integral,
-- which is the entrywise congruence
--
--     Γ₀(D)  =  { P :  dᵢ ∣ dⱼ · Pᵢⱼ  for all i , j }.
--
-- Two things to note about that condition.
--
--  * It is uniform in n and needs no division and no divisibility
--    chain hypothesis: for i ≤ j (where dᵢ ∣ dⱼ) it is automatic, and
--    for i > j it is the familiar (dᵢ/dⱼ) ∣ Pᵢⱼ.  This is the whole
--    "Γ₀(D) payload at all n", with no case split.
--  * At n = 2 and d = (1 , N) it collapses to N ∣ c, the classical
--    Γ₀(N) — proved below, so the name is earned rather than asserted.
--
-- Being a conjunction of decidable divisibilities it is decidable, and
-- the decision procedure returns *either* membership *or* the offending
-- entry (i , j).  A refusal is a witness, not a string.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Gamma0 where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels

open import Cubical.Data.Nat using (ℕ) renaming (zero to ℕzero ; suc to ℕsuc)
open import Cubical.Functions.FunExtEquiv using (funExt₂)
open import Cubical.Data.FinData using (Fin ; zero ; suc ; FinVec)
open import Cubical.Data.FinData.Properties using (∀Dec2)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Int.Divisibility using (_∣_ ; dec∣ ; isProp∣ ; ∣→∣')
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)

open import Cubical.Algebra.Ring.BigOps
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient

open Coefficient ℤCommRing
open CommRingStr (ℤCommRing .snd)
open Sum             (CommRing→Ring ℤCommRing)
open KroneckerDelta  (CommRing→Ring ℤCommRing)

private
  variable
    m n : ℕ

------------------------------------------------------------------------
-- 1.  Diagonal matrices and their two multiplication laws.
------------------------------------------------------------------------

Diag : FinVec ℤ n → Mat n n
Diag d i j = δ i j · d j

private
  swap· : (a b c : ℤ) → a · (b · c) ≡ (a · c) · b
  swap· a b c = cong (a ·_) (·Comm b c) ∙ ·Assoc a c b

-- Left multiplication by a diagonal scales rows.
Diag⋆ : (d : FinVec ℤ n) (M : Mat n m) (i : Fin n) (j : Fin m)
      → (Diag d ⋆ M) i j ≡ d i · M i j
Diag⋆ d M i j =
    ∑Ext (λ k → sym (·Assoc (δ i k) (d k) (M k j)))
  ∙ ∑Mul1r _ (λ k → d k · M k j) i

-- Right multiplication by a diagonal scales columns.
⋆Diag : (d : FinVec ℤ n) (M : Mat m n) (i : Fin m) (j : Fin n)
      → (M ⋆ Diag d) i j ≡ M i j · d j
⋆Diag d M i j =
    ∑Ext (λ k → swap· (M i k) (δ k j) (d j))
  ∙ ∑Mulr1 _ (λ k → M i k · d j) j

------------------------------------------------------------------------
-- 2.  Γ₀(D) as a decidable predicate.
------------------------------------------------------------------------

inΓ₀ : FinVec ℤ n → Mat n n → Type
inΓ₀ {n = n} d P = (i j : Fin n) → d i ∣ (d j · P i j)

isPropInΓ₀ : (d : FinVec ℤ n) (P : Mat n n) → isProp (inΓ₀ d P)
isPropInΓ₀ d P = isPropΠ2 λ _ _ → isProp∣

-- The decision procedure.  Either the whole congruence holds, or there
-- is a named entry at which it fails.
Γ₀? : (d : FinVec ℤ n) (P : Mat n n)
    → inΓ₀ d P ⊎ (Σ[ i ∈ Fin n ] Σ[ j ∈ Fin n ] ¬ (d i ∣ (d j · P i j)))
Γ₀? d P = ∀Dec2 (λ i j → d i ∣ (d j · P i j)) (λ i j → dec∣ (d i) (d j · P i j))

decInΓ₀ : (d : FinVec ℤ n) (P : Mat n n) → Dec (inΓ₀ d P)
decInΓ₀ d P with Γ₀? d P
... | inl h                 = yes h
... | inr (i , j , ¬div)    = no λ h → ¬div (h i j)

------------------------------------------------------------------------
-- 3.  The payload: membership is exactly integrality of the conjugate.
------------------------------------------------------------------------

private
  -- An untruncated quotient.  The a = 0 branch of `∣'` carries no
  -- quotient because it does not need one: there 0 ≡ b already.
  divWit : (a b : ℤ) → a ∣ b → Σ[ k ∈ ℤ ] a · k ≡ b
  divWit (pos ℕzero)    b h = 0r , ∣→∣' _ _ h
  divWit (pos (ℕsuc k)) b h =
    let (c , p) = ∣→∣' (pos (ℕsuc k)) b h in c , ·Comm (pos (ℕsuc k)) c ∙ p
  divWit (negsuc k)     b h =
    let (c , p) = ∣→∣' (negsuc k) b h in c , ·Comm (negsuc k) c ∙ p

-- The D-conjugate D⁻¹ P D, built entrywise out of the divisibility
-- witnesses.  No inverse is ever formed: the witnesses *are* the
-- conjugate.
conj : (d : FinVec ℤ n) (P : Mat n n) → inΓ₀ d P → Mat n n
conj d P h i j = divWit (d i) (d j · P i j) (h i j) .fst

conj-eq : (d : FinVec ℤ n) (P : Mat n n) (h : inΓ₀ d P)
        → Diag d ⋆ conj d P h ≡ P ⋆ Diag d
conj-eq d P h = funExt₂ λ i j →
    Diag⋆ d (conj d P h) i j
  ∙ divWit (d i) (d j · P i j) (h i j) .snd
  ∙ ·Comm (d j) (P i j)
  ∙ sym (⋆Diag d P i j)

-- …and conversely, so the congruence is not merely sufficient for the
-- conjugate to be integral, it is that statement.
integral→inΓ₀ : (d : FinVec ℤ n) (P Q : Mat n n)
              → Diag d ⋆ Q ≡ P ⋆ Diag d
              → inΓ₀ d P
integral→inΓ₀ d P Q e i j =
  ∣ Q i j , ·Comm (Q i j) (d i)
          ∙ sym (Diag⋆ d Q i j)
          ∙ (λ t → e t i j)
          ∙ ⋆Diag d P i j
          ∙ ·Comm (P i j) (d j) ∣₁

-- Γ₀(D) is *characterised* by integrality of the conjugate.
Γ₀-characterisation : (d : FinVec ℤ n) (P : Mat n n)
  → inΓ₀ d P ≃ ∥ Σ[ Q ∈ Mat n n ] (Diag d ⋆ Q ≡ P ⋆ Diag d) ∥₁
Γ₀-characterisation d P =
  propBiimpl→Equiv (isPropInΓ₀ d P) PT.squash₁
    (λ h → ∣ conj d P h , conj-eq d P h ∣₁)
    (PT.rec (isPropInΓ₀ d P) λ (Q , e) → integral→inΓ₀ d P Q e)

------------------------------------------------------------------------
-- 4.  At n = 2 this is the classical Γ₀(N).
------------------------------------------------------------------------

private
  one∣ : (b : ℤ) → 1r ∣ b
  one∣ b = ∣ b , ·IdR b ∣₁

  ∣self· : (a b : ℤ) → a ∣ (a · b)
  ∣self· a b = ∣ b , ·Comm b a ∣₁

module _ (N : ℤ) where

  private
    d₁ : FinVec ℤ 2
    d₁ zero       = 1r
    d₁ (suc zero) = N

  -- With invariants (1 , N), membership in Γ₀(D) is exactly the single
  -- classical condition N ∣ c on the lower-left entry.
  Γ₀-2 : (P : Mat 2 2) → inΓ₀ d₁ P ≃ (N ∣ P (suc zero) zero)
  Γ₀-2 P = propBiimpl→Equiv (isPropInΓ₀ d₁ P) isProp∣ fwd bwd
    where
      fwd : inΓ₀ d₁ P → N ∣ P (suc zero) zero
      fwd h = subst (N ∣_) (·IdL (P (suc zero) zero)) (h (suc zero) zero)

      bwd : N ∣ P (suc zero) zero → inΓ₀ d₁ P
      bwd r zero       zero       = one∣ _
      bwd r zero       (suc zero) = one∣ _
      bwd r (suc zero) zero       = subst (N ∣_) (sym (·IdL _)) r
      bwd r (suc zero) (suc zero) = ∣self· N _

------------------------------------------------------------------------
-- 5.  The torsor.
--
-- A presentation of A with normal form D is an invertible pair (U , V)
-- with U A V = D.  The stabiliser of D is the same thing with A = D,
-- and it acts on presentations by post-composition.  The action is
-- transitive and free: presentations of a fixed A with a fixed normal
-- form D form a torsor under Stab D, so "which Smith transform the
-- machine emitted" is a choice of basepoint and nothing more.
------------------------------------------------------------------------

Transforms : Mat m n → Mat m n → Type
Transforms {m = m} {n = n} A D =
  Σ[ UV ∈ Mat m m × Mat n n ]
    (isInv (UV .fst) × isInv (UV .snd) × ((UV .fst ⋆ A ⋆ UV .snd) ≡ D))

Stab : Mat m n → Type
Stab D = Transforms D D

-- Equality of transforms is equality of the matrix pair: everything
-- else is a proposition.
Transforms≡ : {A D : Mat m n} {s t : Transforms A D}
            → s .fst ≡ t .fst → s ≡ t
Transforms≡ =
  Σ≡Prop λ _ → isProp× (isPropIsInv _) (isProp× (isPropIsInv _) (isSetMat _ _))

-- Composition of transforms; the action is its special case.
compT : {A B C : Mat m n} → Transforms A B → Transforms B C → Transforms A C
compT {A = A} ((U , V) , iU , iV , f) ((P , Q) , iP , iQ , e) =
  (P ⋆ U , V ⋆ Q) , isInv⋆ iP iU , isInv⋆ iV iQ , eq
  where
    eq : (P ⋆ U) ⋆ A ⋆ (V ⋆ Q) ≡ _
    eq =
      ((P ⋆ U) ⋆ A) ⋆ (V ⋆ Q)   ≡⟨ cong (_⋆ (V ⋆ Q)) (sym (⋆Assoc P U A)) ⟩
      (P ⋆ (U ⋆ A)) ⋆ (V ⋆ Q)   ≡⟨ ⋆Assoc (P ⋆ (U ⋆ A)) V Q ⟩
      ((P ⋆ (U ⋆ A)) ⋆ V) ⋆ Q   ≡⟨ cong (_⋆ Q) (sym (⋆Assoc P (U ⋆ A) V)) ⟩
      (P ⋆ ((U ⋆ A) ⋆ V)) ⋆ Q   ≡⟨ cong (λ Z → (P ⋆ Z) ⋆ Q) f ⟩
      (P ⋆ _) ⋆ Q               ≡⟨ e ⟩
      _                         ∎

idT : (A : Mat m n) → Transforms A A
idT A = (𝟙 , 𝟙) , isInv𝟙 , isInv𝟙 , cong (_⋆ 𝟙) (⋆lUnit A) ∙ ⋆rUnit A

-- Every transform is invertible as a transform.
invT : {A D : Mat m n} → Transforms A D → Transforms D A
invT {A = A} ((U , V) , (U' , uu' , u'u) , (V' , vv' , v'v) , f) =
  (U' , V') , (U , u'u , uu') , (V , v'v , vv') , eq
  where
    eq : (U' ⋆ _) ⋆ V' ≡ A
    eq =
      (U' ⋆ _) ⋆ V'              ≡⟨ cong (λ Z → (U' ⋆ Z) ⋆ V') (sym f) ⟩
      (U' ⋆ ((U ⋆ A) ⋆ V)) ⋆ V'  ≡⟨ cong (_⋆ V') (⋆Assoc U' (U ⋆ A) V) ⟩
      ((U' ⋆ (U ⋆ A)) ⋆ V) ⋆ V'  ≡⟨ cong (λ Z → (Z ⋆ V) ⋆ V') (⋆Assoc U' U A) ⟩
      (((U' ⋆ U) ⋆ A) ⋆ V) ⋆ V'  ≡⟨ cong (λ Z → ((Z ⋆ A) ⋆ V) ⋆ V') u'u ⟩
      ((𝟙 ⋆ A) ⋆ V) ⋆ V'         ≡⟨ cong (λ Z → (Z ⋆ V) ⋆ V') (⋆lUnit A) ⟩
      ((A ⋆ V) ⋆ V')             ≡⟨ sym (⋆Assoc A V V') ⟩
      A ⋆ (V ⋆ V')               ≡⟨ cong (A ⋆_) vv' ⟩
      A ⋆ 𝟙                      ≡⟨ ⋆rUnit A ⟩
      A                          ∎

-- The action of the stabiliser on presentations.
act : {A D : Mat m n} → Stab D → Transforms A D → Transforms A D
act s t = compT t s

-- Transitive: any two presentations of A with the same normal form
-- differ by a stabiliser element.
act-transitive : {A D : Mat m n} (t t' : Transforms A D)
               → Σ[ s ∈ Stab D ] act s t ≡ t'
act-transitive t@((U , V) , (U' , uu' , u'u) , (V' , vv' , v'v) , _) t' =
  compT (invT t) t' , Transforms≡ (≡-× fstEq sndEq)
  where
    W  = t' .fst .fst
    X  = t' .fst .snd

    fstEq : (W ⋆ U') ⋆ U ≡ W
    fstEq = sym (⋆Assoc W U' U) ∙ cong (W ⋆_) u'u ∙ ⋆rUnit W

    sndEq : V ⋆ (V' ⋆ X) ≡ X
    sndEq = ⋆Assoc V V' X ∙ cong (_⋆ X) vv' ∙ ⋆lUnit X

-- Free: only the identity stabiliser element fixes a presentation.
act-free : {A D : Mat m n} (t : Transforms A D) (s : Stab D)
         → act s t ≡ t → s ≡ idT D
act-free ((U , V) , (U' , uu' , u'u) , (V' , vv' , v'v) , _)
         ((P , Q) , _ , _ , _) p =
  Transforms≡ (≡-× Pid Qid)
  where
    pu : P ⋆ U ≡ U
    pu i = p i .fst .fst

    qv : V ⋆ Q ≡ V
    qv i = p i .fst .snd

    Pid : P ≡ 𝟙
    Pid =
      sym (⋆rUnit P) ∙ cong (P ⋆_) (sym uu') ∙ ⋆Assoc P U U'
      ∙ cong (_⋆ U') pu ∙ uu'

    Qid : Q ≡ 𝟙
    Qid =
      sym (⋆lUnit Q) ∙ cong (_⋆ Q) (sym v'v) ∙ sym (⋆Assoc V' V Q)
      ∙ cong (V' ⋆_) qv ∙ v'v

------------------------------------------------------------------------
-- 6.  The bridge: a Γ₀ member with invertible conjugate is a
--     stabiliser element of the diagonal, and hence acts.
------------------------------------------------------------------------

Γ₀→Stab : (d : FinVec ℤ n) (P : Mat n n) (h : inΓ₀ d P)
        → isInv P → isInv (conj d P h)
        → Stab (Diag d)
Γ₀→Stab d P h (P' , pp' , p'p) iQ =
  (P' , conj d P h) , (P , p'p , pp') , iQ , eq
  where
    Q = conj d P h
    D = Diag d

    eq : (P' ⋆ D) ⋆ Q ≡ D
    eq =
      (P' ⋆ D) ⋆ Q     ≡⟨ sym (⋆Assoc P' D Q) ⟩
      P' ⋆ (D ⋆ Q)     ≡⟨ cong (P' ⋆_) (conj-eq d P h) ⟩
      P' ⋆ (P ⋆ D)     ≡⟨ ⋆Assoc P' P D ⟩
      (P' ⋆ P) ⋆ D     ≡⟨ cong (_⋆ D) p'p ⟩
      𝟙 ⋆ D            ≡⟨ ⋆lUnit D ⟩
      D                ∎
