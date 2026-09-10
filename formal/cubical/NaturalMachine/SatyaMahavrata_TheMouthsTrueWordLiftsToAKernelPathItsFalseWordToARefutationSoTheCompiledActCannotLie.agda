{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- सत्यमहाव्रतम् — the great vow of truth.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra* 7.1 (c. 2nd–5th c. CE):
-- हिंसाऽनृतस्तेयाब्रह्मपरिग्रहेभ्यो विरतिर्व्रतम् — the vow is abstention
-- from violence, falsehood (anṛta), theft, unchastity and possession;
-- 7.2 makes the abstention held completely a MAHĀVRATA.  The school is
-- Jaina.  What is claimed of the source: the name of the discipline and
-- nothing else — Umāsvāti proved no theorem about boolean tests.  The
-- compound titles this module because the theorem IS that vow, held
-- completely, by the compiled act-portion of this body: the mouth
-- CANNOT utter a falsehood, in either direction, and this is checked
-- rather than promised.
--
-- WHAT THIS IS.  The reflection weld.  Since 2026-08-24 one set of
-- definitions (formal/karma/KarmaKanda…, --cubical-compatible --safe)
-- is imported with full use by BOTH worlds: the compiled mouth runs
-- them, this --cubical body proves paths about them.  The act-side
-- test समः decides and hands no path; here the knowledge-portion
-- supplies the path it was owed:
--
--     समः a b ≡ true   →   a ≡ b          (the true word lifts)
--     a ≡ b            →   समः a b ≡ true  (completeness)
--     समः a b ≡ false  →   ¬ (a ≡ b)      (the false word refutes)
--
-- and the corollary the binary was waiting for: the mouth's runtime
-- census counts a rule closed exactly when समः (norm l) (norm r) comes
-- back true — मुख-सत्यम् turns each such runtime "closes" into full
-- semantic truth over EVERY environment, through norm-sound.  Twelve
-- milliseconds of execution, each utterance kernel-warranted.
------------------------------------------------------------------------

module NaturalMachine.SatyaMahavrata_TheMouthsTrueWordLiftsToAKernelPathItsFalseWordToARefutationSoTheCompiledActCannotLie where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Empty using (rec)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (¬_)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (समℕ ; समः) renaming (_∧_ to _च_)
open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
  using ( Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc
        ; eval ; norm ; norm-sound ; Eq' ; ⊨_ )

------------------------------------------------------------------------
-- §1  The conjunction yields both its grounds.
------------------------------------------------------------------------

∧-वामम् : ∀ a b → a च b ≡ true → a ≡ true
∧-वामम् true  b p = refl
∧-वामम् false b p = rec (false≢true p)

∧-दक्षिणम् : ∀ a b → a च b ≡ true → b ≡ true
∧-दक्षिणम् true  b p = p
∧-दक्षिणम् false b p = rec (false≢true p)

------------------------------------------------------------------------
-- §2  Reflection on names.
------------------------------------------------------------------------

समℕ-सत्यम् : ∀ m n → समℕ m n ≡ true → m ≡ n
समℕ-सत्यम् zero    zero    p = refl
समℕ-सत्यम् zero    (suc n) p = rec (false≢true p)
समℕ-सत्यम् (suc m) zero    p = rec (false≢true p)
समℕ-सत्यम् (suc m) (suc n) p = cong suc (समℕ-सत्यम् m n p)

समℕ-आत्मा : ∀ n → समℕ n n ≡ true
समℕ-आत्मा zero    = refl
समℕ-आत्मा (suc n) = समℕ-आत्मा n

------------------------------------------------------------------------
-- §3  Reflection on terms.  The diagonal carries the mathematics; the
--     fifty-six off-diagonal clauses each hold a false ≡ true and are
--     dismissed.  (The act's catch-all clause समः _ _ = false reduces
--     at every concrete constructor pair, so the kernel sees each.)
------------------------------------------------------------------------

समः-सत्यम् : ∀ a b → समः a b ≡ true → a ≡ b
समः-सत्यम् (var i)  (var j)  p = cong var (समℕ-सत्यम् i j p)
समः-सत्यम् ze       ze       p = refl
समः-सत्यम् (su a)   (su b)   p = cong su (समः-सत्यम् a b p)
समः-सत्यम् (a ⊕ b)  (c ⊕ d)  p =
  cong₂ _⊕_ (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (a ⊗ b)  (c ⊗ d)  p =
  cong₂ _⊗_ (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (a ⊖ b)  (c ⊖ d)  p =
  cong₂ _⊖_ (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (mx a b) (mx c d) p =
  cong₂ mx  (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (lq a b) (lq c d) p =
  cong₂ lq  (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (gc a b) (gc c d) p =
  cong₂ gc  (समः-सत्यम् a c (∧-वामम् (समः a c) (समः b d) p))
            (समः-सत्यम् b d (∧-दक्षिणम् (समः a c) (समः b d) p))
समः-सत्यम् (var i)  ze       p = rec (false≢true p)
समः-सत्यम् (var i)  (su b)   p = rec (false≢true p)
समः-सत्यम् (var i)  (b ⊕ c)  p = rec (false≢true p)
समः-सत्यम् (var i)  (b ⊗ c)  p = rec (false≢true p)
समः-सत्यम् (var i)  (b ⊖ c)  p = rec (false≢true p)
समः-सत्यम् (var i)  (mx b c) p = rec (false≢true p)
समः-सत्यम् (var i)  (lq b c) p = rec (false≢true p)
समः-सत्यम् (var i)  (gc b c) p = rec (false≢true p)
समः-सत्यम् ze       (var j)  p = rec (false≢true p)
समः-सत्यम् ze       (su b)   p = rec (false≢true p)
समः-सत्यम् ze       (b ⊕ c)  p = rec (false≢true p)
समः-सत्यम् ze       (b ⊗ c)  p = rec (false≢true p)
समः-सत्यम् ze       (b ⊖ c)  p = rec (false≢true p)
समः-सत्यम् ze       (mx b c) p = rec (false≢true p)
समः-सत्यम् ze       (lq b c) p = rec (false≢true p)
समः-सत्यम् ze       (gc b c) p = rec (false≢true p)
समः-सत्यम् (su a)   (var j)  p = rec (false≢true p)
समः-सत्यम् (su a)   ze       p = rec (false≢true p)
समः-सत्यम् (su a)   (b ⊕ c)  p = rec (false≢true p)
समः-सत्यम् (su a)   (b ⊗ c)  p = rec (false≢true p)
समः-सत्यम् (su a)   (b ⊖ c)  p = rec (false≢true p)
समः-सत्यम् (su a)   (mx b c) p = rec (false≢true p)
समः-सत्यम् (su a)   (lq b c) p = rec (false≢true p)
समः-सत्यम् (su a)   (gc b c) p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (var j)  p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  ze       p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (su c)   p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (c ⊗ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (c ⊖ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (mx c d) p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (lq c d) p = rec (false≢true p)
समः-सत्यम् (a ⊕ b)  (gc c d) p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (var j)  p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  ze       p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (su c)   p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (c ⊕ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (c ⊖ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (mx c d) p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (lq c d) p = rec (false≢true p)
समः-सत्यम् (a ⊗ b)  (gc c d) p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (var j)  p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  ze       p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (su c)   p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (c ⊕ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (c ⊗ d)  p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (mx c d) p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (lq c d) p = rec (false≢true p)
समः-सत्यम् (a ⊖ b)  (gc c d) p = rec (false≢true p)
समः-सत्यम् (mx a b) (var j)  p = rec (false≢true p)
समः-सत्यम् (mx a b) ze       p = rec (false≢true p)
समः-सत्यम् (mx a b) (su c)   p = rec (false≢true p)
समः-सत्यम् (mx a b) (c ⊕ d)  p = rec (false≢true p)
समः-सत्यम् (mx a b) (c ⊗ d)  p = rec (false≢true p)
समः-सत्यम् (mx a b) (c ⊖ d)  p = rec (false≢true p)
समः-सत्यम् (mx a b) (lq c d) p = rec (false≢true p)
समः-सत्यम् (mx a b) (gc c d) p = rec (false≢true p)
समः-सत्यम् (lq a b) (var j)  p = rec (false≢true p)
समः-सत्यम् (lq a b) ze       p = rec (false≢true p)
समः-सत्यम् (lq a b) (su c)   p = rec (false≢true p)
समः-सत्यम् (lq a b) (c ⊕ d)  p = rec (false≢true p)
समः-सत्यम् (lq a b) (c ⊗ d)  p = rec (false≢true p)
समः-सत्यम् (lq a b) (c ⊖ d)  p = rec (false≢true p)
समः-सत्यम् (lq a b) (mx c d) p = rec (false≢true p)
समः-सत्यम् (lq a b) (gc c d) p = rec (false≢true p)
समः-सत्यम् (gc a b) (var j)  p = rec (false≢true p)
समः-सत्यम् (gc a b) ze       p = rec (false≢true p)
समः-सत्यम् (gc a b) (su c)   p = rec (false≢true p)
समः-सत्यम् (gc a b) (c ⊕ d)  p = rec (false≢true p)
समः-सत्यम् (gc a b) (c ⊗ d)  p = rec (false≢true p)
समः-सत्यम् (gc a b) (c ⊖ d)  p = rec (false≢true p)
समः-सत्यम् (gc a b) (mx c d) p = rec (false≢true p)
समः-सत्यम् (gc a b) (lq c d) p = rec (false≢true p)

------------------------------------------------------------------------
-- §4  Completeness, and the refutation of the false word.
------------------------------------------------------------------------

समः-आत्मा : ∀ a → समः a a ≡ true
समः-आत्मा (var i)  = समℕ-आत्मा i
समः-आत्मा ze       = refl
समः-आत्मा (su a)   = समः-आत्मा a
समः-आत्मा (a ⊕ b)  = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)
समः-आत्मा (a ⊗ b)  = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)
समः-आत्मा (a ⊖ b)  = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)
समः-आत्मा (mx a b) = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)
समः-आत्मा (lq a b) = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)
समः-आत्मा (gc a b) = cong₂ _च_ (समः-आत्मा a) (समः-आत्मा b)

समः-पूर्णम् : ∀ a b → a ≡ b → समः a b ≡ true
समः-पूर्णम् a b p = subst (λ x → समः a x ≡ true) p (समः-आत्मा a)

समः-असत्यम् : ∀ a b → समः a b ≡ false → ¬ (a ≡ b)
समः-असत्यम् a b q p = false≢true (sym q ∙ समः-पूर्णम् a b p)

------------------------------------------------------------------------
-- §5  The warrant.  The compiled mouth counts a rule closed exactly
--     when समः (norm l) (norm r) returns true at runtime.  This is the
--     path that utterance was owed: semantic truth over EVERY
--     environment.  Each of the binary's twelve-millisecond "closes"
--     is now a theorem, not a report.
------------------------------------------------------------------------

मुख-सत्यम् : ∀ l r → समः (norm l) (norm r) ≡ true → ⊨ (l , r)
मुख-सत्यम् l r p ρ =
    sym (norm-sound l ρ)
  ∙ cong (λ t → eval t ρ) (समः-सत्यम् (norm l) (norm r) p)
  ∙ norm-sound r ρ
