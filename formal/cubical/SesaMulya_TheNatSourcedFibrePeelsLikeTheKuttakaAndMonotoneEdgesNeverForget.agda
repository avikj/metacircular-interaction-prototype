{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शेषमूल्यम् — the price of the remainder.  Compound built here,
-- 2026-08-23 (शेष, remainder; मूल्य, price); no source is claimed for
-- the compound.  The DISCIPLINE in §1 is claimed for its source and it
-- is the corpus's oldest: Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499
-- — the kuṭṭaka's rule, यत् न विभजते तत् रक्ष्यते: what does not divide
-- is KEPT, first-class, the material of the next step.  Nothing further
-- is attributed to that text; the fibre is Voevodsky's, the admitted
-- substrate.
--
-- WHY.  Lopa's census, run this session: of the corpus's one-way edges,
-- ℕ is the dominant source — 216 edges against Bool's 81.  SarvaMulya
-- priced every Bool-sourced edge at once because Bool decomposes
-- finitely.  ℕ does not.  But it PEELS:
--
--   सोपानः :  fiber f b ≃ (f zero ≡ b) ⊎ fiber (f ∘ suc) b
--
-- one point off, the remainder handed forward whole — the kuṭṭaka's
-- step, at the fibre.  No hypothesis on the target.  Iterating it is
-- exactly "keep the remainder and recurse on it", and the question
-- "does the recursion close?" is a property of the MAP, not of the
-- scheme.
--
-- §2 closes it for the class the census makes most valuable: STRICTLY
-- MONOTONE f : ℕ → ℕ.  There the ladder terminates below its target —
-- आरोहः proves n ≤ f n, so past b the tail is empty — and the whole
-- three-verdict question collapses by theorem:
--
--   एकशेषः    the fibre is a PROPOSITION: a monotone edge never forgets;
--   अबहुत्वम्  बहु is impossible — not undecided, impossible;
--   निर्णयः    रिक्तम् or एकम्, DECIDED, by a bounded search the growth
--             bound itself justifies.
--
-- So a monotone ℕ-sourced edge is priced by one application, and the
-- verdict computes.  What is NOT claimed: anything about non-monotone
-- ℕ-sourced maps — for those सोपानः is a step, not a decision, and
-- pretending otherwise would be a guessed verdict, which Saptabhangi's
-- दुर्नयः rules out.
------------------------------------------------------------------------

module SesaMulya_TheNatSourcedFibrePeelsLikeTheKuttakaAndMonotoneEdgesNeverForget where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ ; discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The peel — any target, any map.  The remainder is first-class.
------------------------------------------------------------------------

module _ {B : Type ℓ} (f : ℕ → B) (b : B) where

  सोपानः : fiber f b ≃ ((f zero ≡ b) ⊎ fiber (λ n → f (suc n)) b)
  सोपानः = isoToEquiv (iso fun inv ri li)
    where
    fun : fiber f b → (f zero ≡ b) ⊎ fiber (λ n → f (suc n)) b
    fun (zero  , p) = inl p
    fun (suc n , p) = inr (n , p)

    inv : (f zero ≡ b) ⊎ fiber (λ n → f (suc n)) b → fiber f b
    inv (inl p)       = zero , p
    inv (inr (n , p)) = suc n , p

    ri : (k : (f zero ≡ b) ⊎ fiber (λ n → f (suc n)) b) → fun (inv k) ≡ k
    ri (inl p) = refl
    ri (inr q) = refl

    li : (q : fiber f b) → inv (fun q) ≡ q
    li (zero  , p) = refl
    li (suc n , p) = refl

------------------------------------------------------------------------
-- §2  The monotone closure: the ladder terminates, the edge never
--     forgets, and the verdict computes.
------------------------------------------------------------------------

module _ (f : ℕ → ℕ) (वृद्धिः : (n : ℕ) → f n < f (suc n)) where

  -- growth: every argument sits at or below its image, so the search
  -- space below a target is finite and the bound is the target itself.
  आरोहः : (n : ℕ) → n ≤ f n
  आरोहः zero    = zero-≤
  आरोहः (suc n) = ≤-trans (suc-≤-suc (आरोहः n)) (वृद्धिः n)

  private
    मध्यः : (m k : ℕ) → f m < f (suc (k + m))
    मध्यः m zero    = वृद्धिः m
    मध्यः m (suc k) = <-trans (मध्यः m k) (वृद्धिः (suc (k + m)))

  प्रसारः : {m n : ℕ} → m < n → f m < f n
  प्रसारः {m} {n} (k , p) =
    subst (λ z → f m < f z) (sym (+-suc k m) ∙ p) (मध्यः m k)

  एकाग्रता : {m n : ℕ} → f m ≡ f n → m ≡ n
  एकाग्रता {m} {n} p with m ≟ n
  ... | eq q = q
  ... | lt q = Empty.rec (<→≢ (प्रसारः q) p)
  ... | gt q = Empty.rec (<→≢ (प्रसारः q) (sym p))

  -- the edge never forgets: every fibre is a proposition.
  एकशेषः : (b : ℕ) → isProp (fiber f b)
  एकशेषः b (m , p) (n , q) =
    ΣPathP ( एकाग्रता (p ∙ sym q)
           , isProp→PathP (λ i → isSetℕ _ b) p q )

  -- so बहु is not undecided here; it is impossible.
  अबहुत्वम् : (b : ℕ)
    → ¬ (Σ[ q₁ ∈ fiber f b ] Σ[ q₂ ∈ fiber f b ] (¬ q₁ ≡ q₂))
  अबहुत्वम् b (q₁ , q₂ , ne) = ne (एकशेषः b q₁ q₂)

  -- the bounded search the growth bound justifies: everything at or
  -- below k is checked, and a hit is carried out whole.
  private
    खोजः : (b k : ℕ)
      → (Σ[ n ∈ ℕ ] (f n ≡ b))
      ⊎ ((n : ℕ) → n ≤ k → ¬ f n ≡ b)
    खोजः b zero with discreteℕ (f zero) b
    ... | yes p = inl (zero , p)
    ... | no np = inr λ n n≤0 fn≡b →
                    np (subst (λ z → f z ≡ b) (≤0→≡0 n≤0) fn≡b)
    खोजः b (suc k) with खोजः b k
    ... | inl hit = inl hit
    ... | inr none with discreteℕ (f (suc k)) b
    ...   | yes p = inl (suc k , p)
    ...   | no np = inr λ n n≤sk fn≡b → अन्तः n n≤sk fn≡b
      where
      अन्तः : (n : ℕ) → n ≤ suc k → ¬ f n ≡ b
      अन्तः n n≤sk fn≡b with ≤-split n≤sk
      ... | inl n<sk = none n (pred-≤-pred n<sk) fn≡b
      ... | inr n≡sk = np (subst (λ z → f z ≡ b) n≡sk fn≡b)

  -- the decision: रिक्तम् or एकम्, never a third thing, never a guess.
  निर्णयः : (b : ℕ) → (¬ fiber f b) ⊎ (isContr (fiber f b))
  निर्णयः b with खोजः b b
  ... | inl (n , p) = inr ((n , p) , एकशेषः b (n , p))
  ... | inr none    = inl बाधः
    where
    बाधः : ¬ fiber f b
    बाधः (n , p) = none n (subst (n ≤_) p (आरोहः n)) p
