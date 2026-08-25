{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module DatumSensitivePayload where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Bool using (true ; false ; if_then_else_ ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Monoid.Base

open import Obstruction
open import PayloadMorphism using (MorphismClass ; MinCarrier)

-- The smallest repair of CompileBridge.ArithmeticPayloadOver's semantic
-- law: installation may inspect its datum, while preservation is required
-- exactly when that datum realizes the old-language defining body.
record DatumSensitivePayloadOver (Ans : Type₀) (M : MorphismClass Ans) : Type₁ where
  field
    Datum : Shape → Type₀
    Store : Vocab → Type₀
    atom : {V : Vocab} → Store V → (s : Shape) → memb s V ≡ true → Ans
    installP : {V : Vocab} → Store V → (d : Shape) (b : Tm) → Over V b
             → Datum d → Store (d ∷ V)
    combine : Ans → Ans → Ans
    sem : {V : Vocab} → Store V → (t : Tm) → Over V t → Ans
    sem-node : {V : Vocab} (st : Store V) (c : Shape) (u : Tm)
             → (hc : memb c V ≡ true) (hu : Over V u)
             → sem st (node c u) (hc , hu)
               ≡ combine (atom st c hc) (sem st u hu)
    Realizes : {V : Vocab} → Store V → (d : Shape) (b : Tm)
             → Over V b → Datum d → Type₀
    unfold-preserves :
      {V : Vocab} (st : Store V) (d : Shape) (b : Tm) (bB : Over V b)
      (x : Datum d) → Realizes st d b bB x → (t : Tm) (h : Over (d ∷ V) t)
      → sem (installP st d b bB x) t h
        ≡ sem st (unfold d b t) (unfold-elim V d b bB t h)
    Cost : Type₀
    vcost : {V : Vocab} → Store V → (t : Tm) → Over V t → Cost
    carrier : {V : Vocab} → Store V → (t : Tm) → Over V t → ℕ
    carrier-minimal : {V : Vocab} (st : Store V) (t : Tm) (h : Over V t)
                    → MinCarrier M (sem st t h) (carrier st t h)
    payload-separates :
      Σ[ V ∈ Vocab ] Σ[ t ∈ Tm ] Σ[ h ∈ Over V t ]
      Σ[ st ∈ Store V ] Σ[ st' ∈ Store V ] ¬ (sem st t h ≡ sem st' t h)

update : {A : Type₀} → (Shape → A) → Shape → A → Shape → A
update st d x c = if eqℕ c d then x else st c

module _ (A : Monoid ℓ-zero) where
  private module A = MonoidStr (snd A)

  semₘ : (Shape → ⟨ A ⟩) → Tm → ⟨ A ⟩
  semₘ st var = A.ε
  semₘ st (node c t) = st c A.· semₘ st t

  plug-semₘ : (st : Shape → ⟨ A ⟩) (b u : Tm)
    → semₘ st (plug b u) ≡ semₘ st b A.· semₘ st u
  plug-semₘ st var u = sym (A.·IdL (semₘ st u))
  plug-semₘ st (node c b) u =
    cong (st c A.·_) (plug-semₘ st b u) ∙ A.·Assoc (st c) (semₘ st b) (semₘ st u)

  update-unfold-semₘ : (st : Shape → ⟨ A ⟩) (d : Shape) (b t : Tm)
    → semₘ (update st d (semₘ st b)) t ≡ semₘ st (unfold d b t)
  update-unfold-semₘ st d b var = refl
  update-unfold-semₘ st d b (node c t) = helper (dichotomyBool (eqℕ c d)) where
    helper : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false) →
      semₘ (update st d (semₘ st b)) (node c t) ≡ semₘ st (unfold d b (node c t))
    helper (inl e) = cong₂ A._·_ (if≡true e) (update-unfold-semₘ st d b t)
      ∙ sym (plug-semₘ st b (unfold d b t)) ∙ cong (semₘ st) (sym (if≡true e))
    helper (inr e) = cong₂ A._·_ (if≡false e) (update-unfold-semₘ st d b t)
      ∙ cong (semₘ st) (sym (if≡false e))

  monoidDatumSensitive : (M : MorphismClass ⟨ A ⟩)
    → ((a : ⟨ A ⟩) → Σ[ n ∈ ℕ ] MinCarrier M a n)
    → (a₀ a₁ : ⟨ A ⟩) → ¬ (a₀ ≡ a₁) → DatumSensitivePayloadOver ⟨ A ⟩ M
  DatumSensitivePayloadOver.Datum (monoidDatumSensitive M mins a₀ a₁ ne) d = ⟨ A ⟩
  DatumSensitivePayloadOver.Store (monoidDatumSensitive M mins a₀ a₁ ne) V = Shape → ⟨ A ⟩
  DatumSensitivePayloadOver.atom (monoidDatumSensitive M mins a₀ a₁ ne) st s h = st s
  DatumSensitivePayloadOver.installP (monoidDatumSensitive M mins a₀ a₁ ne) st d b bB x = update st d x
  DatumSensitivePayloadOver.combine (monoidDatumSensitive M mins a₀ a₁ ne) = A._·_
  DatumSensitivePayloadOver.sem (monoidDatumSensitive M mins a₀ a₁ ne) st t h = semₘ st t
  DatumSensitivePayloadOver.sem-node (monoidDatumSensitive M mins a₀ a₁ ne) st c u hc hu = refl
  DatumSensitivePayloadOver.Realizes (monoidDatumSensitive M mins a₀ a₁ ne) st d b bB x = x ≡ semₘ st b
  DatumSensitivePayloadOver.unfold-preserves (monoidDatumSensitive M mins a₀ a₁ ne) st d b bB x rx t h =
    cong (λ y → semₘ (update st d y) t) rx ∙ update-unfold-semₘ st d b t
  DatumSensitivePayloadOver.Cost (monoidDatumSensitive M mins a₀ a₁ ne) = Unit
  DatumSensitivePayloadOver.vcost (monoidDatumSensitive M mins a₀ a₁ ne) st t h = tt
  DatumSensitivePayloadOver.carrier (monoidDatumSensitive M mins a₀ a₁ ne) st t h = fst (mins (semₘ st t))
  DatumSensitivePayloadOver.carrier-minimal (monoidDatumSensitive M mins a₀ a₁ ne) st t h = snd (mins (semₘ st t))
  DatumSensitivePayloadOver.payload-separates (monoidDatumSensitive M mins a₀ a₁ ne) =
    (zero ∷ []) , node zero var , (memb-here zero [] , tt) , (λ _ → a₀) , (λ _ → a₁) ,
    (λ p → ne (sym (A.·IdR a₀) ∙ p ∙ A.·IdR a₁))
