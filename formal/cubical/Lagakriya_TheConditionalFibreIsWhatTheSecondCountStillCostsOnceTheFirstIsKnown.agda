{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- लगक्रिया — अंश-नियमे तन्तुः, अर्थात् प्रथमे ज्ञाते द्वितीयस्य मूल्यम् ।
--
-- (the fibre over a PARTIAL specification: what the second count still
-- costs once the first is known.)
--
-- ────────────────────────────────────────────────────────────────────
-- मूलवाक्यम् · SOURCE OF THE TERM, with text and date, and with the one
-- thing I could not establish said as such.
--
--   The प्रत्यय of Piṅgala, *Chandaḥśāstra*, ch. 8 (~300 BCE) are listed
--   in the commentarial tradition as six: प्रस्तार (lay the forms out),
--   नष्ट (index → form), उद्दिष्ट (form → index), सङ्ख्या (how many),
--   अध्वयोग (the space the table occupies), and — the one this module is
--   about — **एकद्व्यादि-लगक्रिया**, "the operation for [the forms
--   having] one, two, and so on लग", लग being the तradition's word for
--   the heavy syllable (गुरु).  It is the count of the forms carrying a
--   GIVEN NUMBER of gurus, and it is answered by the मेरुप्रस्तार of
--   छन्दःशास्त्रम् ८.३४–३५, whose construction rule — अग्रिम-पङ्क्तिः
--   पूर्व-पङ्क्तेः पार्श्व-योगैः, the next row from the adjacent sums of the
--   previous — is stated by हलायुध, *मृतसञ्जीवनी*, 10th c. CE.
--
--   WHAT I DID NOT ESTABLISH, said plainly rather than guessed: I have
--   not verified a sūtra number at which the word लगक्रिया itself
--   appears.  ८.३४–३५ is cited for the ARRAY, which is what is used
--   below; the name is the commentarial tradition's name for the fourth
--   pratyaya and is used here in that sense.  A later agent who can open
--   the text should pin the sūtra or strike this sentence.
--
--   The later European statement of the array is Pascal, *Traité du
--   triangle arithmétique*, 1654 — a restatement, named after the source
--   and as one, and never transliterated into Devanagari, which would
--   be worse than the Latin.
--
-- WHAT IS AND IS NOT CLAIMED.  **Piṅgala proved nothing below.**  He
-- states procedures and counts; he states no type, no fibre, no
-- equivalence.  The claim is that the objects his pratyayas enumerate
-- ARE the fibres of the counting maps — a fact about the definitions in
-- `PingalaPrastara.agda`, not an attribution — and that the fourth
-- pratyaya, counting over a PARTIAL specification, is the general
-- construction §१ below, which is this repository's.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, for `f : A → B` and `g : A → C`.
--
--   §१  लगक्रिया  fiber ⟨f,g⟩ (b , c) ≃ fiber (g ∘ fst) c, where the
--       `fst` is off `fiber f b`.  THE JOINT FIBRE IS THE FIBRE OF g
--       RESTRICTED TO THE FIBRE OF f — the conditional receipt: once f
--       is known to be b, what g still costs is one fibre, taken inside
--       the answer f already gave.
--
--       The passage is not definitional and the gap is the content: a
--       PAIR OF EQUATIONS is not an EQUATION OF PAIRS.  They meet only
--       through `ΣPath≃PathΣ`, and measuring two observables jointly is
--       not the act of measuring each.
--
--   §२  लगक्रिया-विभागः  fiber f b ≃ Σ[ c ∈ C ] fiber ⟨f,g⟩ (b , c).
--       The fibre of f partitions over the values of g.  This is the
--       sum rule — the total is the sum of the conditionals — and it is
--       an equivalence of types, with no finiteness anywhere.
--
--   §३  मुक्त-लगक्रिया  if f's fibre at b is contractible, the joint
--       fibre collapses to a single path `g a₀ ≡ c`.  When f is already
--       an answer (नष्टोद्दिष्ट-परीक्षा §४: एकम् at b), g costs nothing
--       beyond identifying its value.
--
--   §४  पिङ्गले  Vak n ≃ Σ[ k ∈ ℕ ] Chosen n k.  Piṅgala's own case:
--       the syllable-metre decomposes over the guru-count.  §२
--       instantiated at (वर्ण, गुरु), joined to
--       `Chandomudra_….युग्म-तन्तुः` which prices the joint fibre.
--
--   §५  पङ्क्ति-योगः  योगफल (पङ्क्ति n) ≡ sankhya n.  The same statement
--       at the level of NUMBERS: the n-th row of the मेरुप्रस्तार sums to
--       the सङ्ख्या 2ⁿ, proved from हलायुध's adjacent-sums rule as it is
--       written in `NastaUddista_….पङ्क्ति` — one row held in memory, no
--       triangle stored.
--
--   §६  लग-गणना  Σ[ k ∈ ℕ ] Chosen n k ≃ Fin (योगफल (पङ्क्ति n)).  §४ and
--       §५ joined, by way of Piṅgala's OWN नष्ट/उद्दिष्ट count
--       (`PingalaPrastara.uddistaIso`).  Summing the लगक्रिया over every
--       guru-count returns the सङ्ख्या, and no summand is ever examined.
--
-- RELATION TO WHAT IS ALREADY HERE.  `Sesa_….शेष` gives the COMPOSITION
-- half — fiber (g ∘ f) z ≃ Σ[ p ∈ fiber g z ] fiber f (fst p) — for two
-- maps run in series.  §१ is the PAIRING half, for two maps run on the
-- same source.  They are different fibrations of a fibration and neither
-- follows from the other; §१'s hypothesis is a common domain, §शेष's is
-- a shared middle.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (the installed version), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module Lagakriya_TheConditionalFibreIsWhatTheSecondCountStillCostsOnceTheFirstIsKnown where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (fiber ; _≃_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma
  using ( Σ-syntax ; _×_ ; _,_ ; fst ; snd
        ; ΣPath≃PathΣ ; Σ-assoc-≃
        ; Σ-cong-equiv-snd ; Σ-contractFst ; Σ-contractSnd )
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import PingalaPrastara
  using (Pattern ; varna ; guruOf ; Vak ; Chosen ; sankhya ; uddistaIso)
open import NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
  using (नयन ; युग्म ; अग्रिम ; पङ्क्ति)
import Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided as CM

private
  variable
    ℓ ℓ' ℓ'' ℓ''' : Level

-- A swap of two independent Σ-bases, needed below and not in the library
-- in this generality (`Cubical.Data.Sigma.Σ-swap-≃` is the plain product
-- only, and here the last family depends on BOTH bases).  Both round
-- trips are `refl`.
विपर्यय-Iso : {D : Type ℓ} {E : Type ℓ'} {F : D → E → Type ℓ''}
            → Iso (Σ[ d ∈ D ] Σ[ e ∈ E ] F d e)
                  (Σ[ e ∈ E ] Σ[ d ∈ D ] F d e)
Iso.fun      विपर्यय-Iso (d , e , x) = (e , d , x)
Iso.inv      विपर्यय-Iso (e , d , x) = (d , e , x)
Iso.rightInv विपर्यय-Iso _ = refl
Iso.leftInv  विपर्यय-Iso _ = refl

------------------------------------------------------------------------
-- १ · THE CONDITIONAL RECEIPT.
--
-- Two observables on one source.  The JOINT specification names both;
-- the PARTIAL specification names only the first, and what remains to be
-- paid is a fibre taken INSIDE the first answer.
------------------------------------------------------------------------

module _ {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''} (f : A → B) (g : A → C) where

  -- ⟨f,g⟩ — the joint measurement, made in one act.
  युग्म-मापः : A → B × C
  युग्म-मापः a = f a , g a

  -- the conditional fibre: g read off the fibre of f, at the value c.
  सापेक्ष-तन्तुः : B → C → Type (ℓ-max (ℓ-max ℓ ℓ') ℓ'')
  सापेक्ष-तन्तुः b c = fiber (λ (x : fiber f b) → g (fst x)) c

  -- §१  the joint fibre IS the conditional fibre.
  --
  -- Left to right the two coordinates of the pair-equation are split
  -- (`ΣPath≃PathΣ`, and this is the step that is not definitional);
  -- then the Σ is reassociated so that "the part f already answered"
  -- becomes the base and "what g still costs" becomes the fibre.
  लगक्रिया : (b : B) (c : C)
           → fiber युग्म-मापः (b , c) ≃ सापेक्ष-तन्तुः b c
  लगक्रिया b c =
    compEquiv (Σ-cong-equiv-snd (λ _ → invEquiv ΣPath≃PathΣ))
              (invEquiv Σ-assoc-≃)

  -- §२  the sum rule.  The fibre of f is the sum, over the values of g,
  -- of the joint fibres.  Nothing is lost by refining a specification:
  -- the refinements reassemble to exactly what was there.
  लगक्रिया-विभागः : (b : B)
                  → fiber f b ≃ (Σ[ c ∈ C ] fiber युग्म-मापः (b , c))
  लगक्रिया-विभागः b =
    invEquiv
      (compEquiv (Σ-cong-equiv-snd (λ c → लगक्रिया b c))
      (compEquiv (isoToEquiv विपर्यय-Iso)
                 (Σ-contractSnd (λ x → isContrSingl (g (fst x))))))

  -- §३  when the first answer is already एकम्, the conditional receipt
  -- is a single path and nothing more.
  मुक्त-लगक्रिया : (b : B) (h : isContr (fiber f b)) (c : C)
                → fiber युग्म-मापः (b , c) ≃ (g (fst (h .fst)) ≡ c)
  मुक्त-लगक्रिया b h c = compEquiv (लगक्रिया b c) (Σ-contractFst h)

------------------------------------------------------------------------
-- ४ · पिङ्गले — the instance the pratyaya was stated for.
--
-- f = वर्ण (syllable count), g = गुरु (heavy-syllable count).  §२ says
-- the वर्णवृत्त of n syllables decomposes over the guru-count, and
-- `Chandomudra_….युग्म-तन्तुः` says each joint fibre is `Chosen n k`,
-- which is what the मेरुप्रस्तार tabulates.
--
-- `fiber varna n` and `Vak n` are the same type on the nose, so no step
-- is spent on that (छन्दोमुद्रा §२).
------------------------------------------------------------------------

लग-विभागः : (n : ℕ) → Vak n ≃ (Σ[ k ∈ ℕ ] Chosen n k)
लग-विभागः n =
  compEquiv (लगक्रिया-विभागः varna guruOf n)
            (Σ-cong-equiv-snd (λ k → CM.युग्म-तन्तुः n k))

------------------------------------------------------------------------
-- ५ · THE SAME STATEMENT AT THE LEVEL OF NUMBERS.
--
-- §४ is an equivalence of types and stops there: passing to a count
-- needs a finiteness §४ does not assume, and `Σ[ k ∈ ℕ ]` ranges over
-- all of ℕ with all but finitely many summands empty.  The numerical
-- form is proved separately, from हलायुध's rule as it is actually
-- written in `NastaUddista_….पङ्क्ति` — one row generated from the
-- previous by adjacent sums, one row held, no triangle stored.
------------------------------------------------------------------------

योगफल : List ℕ → ℕ
योगफल []       = 0
योगफल (x ∷ xs) = x + योगफल xs

-- two pure rearrangements in the semiring, so the induction below shows
-- only its own step.
विन्यास₁ : (x a t : ℕ) → x + ((a + x) + t) ≡ (x + x) + (a + t)
विन्यास₁ x a t = solveℕ!

विन्यास₂ : (x s : ℕ) → (x + x) + (s + s) ≡ (x + s) + (x + s)
विन्यास₂ x s = solveℕ!

-- the adjacent-sum row doubles the total, less its own head — stated
-- without subtraction, which ℕ does not have.
युग्म-योगः : (xs : List ℕ)
           → नयन xs 0 + योगफल (युग्म xs) ≡ योगफल xs + योगफल xs
युग्म-योगः []       = refl
युग्म-योगः (x ∷ xs) =
    विन्यास₁ x (नयन xs 0) (योगफल (युग्म xs))
  ∙ cong ((x + x) +_) (युग्म-योगः xs)
  ∙ विन्यास₂ x (योगफल xs)

-- every row of the मेरु begins with 1 — by the construction, not by a
-- separate argument.
पङ्क्ति-मुखम् : (n : ℕ) → नयन (पङ्क्ति n) 0 ≡ 1
पङ्क्ति-मुखम् zero    = refl
पङ्क्ति-मुखम् (suc n) = refl

-- THE THEOREM.  The n-th row of the मेरुप्रस्तार sums to Piṅgala's
-- सङ्ख्या.  Read backwards: summing the लगक्रिया over every possible
-- guru-count returns the whole प्रस्तार, so the conditional receipts
-- account for the total exactly.
पङ्क्ति-योगः : (n : ℕ) → योगफल (पङ्क्ति n) ≡ sankhya n
पङ्क्ति-योगः zero    = refl
पङ्क्ति-योगः (suc n) =
    cong (_+ योगफल (युग्म (पङ्क्ति n))) (sym (पङ्क्ति-मुखम् n))
  ∙ युग्म-योगः (पङ्क्ति n)
  ∙ cong₂ _+_ (पङ्क्ति-योगः n) (पङ्क्ति-योगः n)

------------------------------------------------------------------------
-- ६ · §४ AND §५ JOINED BY A TERM, not by a paragraph.
--
-- The first draft of this module left them apart and said in prose that
-- joining them needed a finiteness — that `Chosen n k` is empty for
-- k > n.  It does not.  The route runs the other way round: §४ says the
-- sum of the conditional fibres IS the वर्णवृत्त, and Piṅgala's own
-- नष्ट/उद्दिष्ट pair already counts THAT (`PingalaPrastara.uddistaIso`,
-- Vak n ≃ Fin (sankhya n)).  §५ then rewrites the count as the row sum.
--
-- So: the सङ्ख्या is recovered by summing the लगक्रिया over every guru
-- count, as an equivalence, with no summand ever examined.
------------------------------------------------------------------------

लग-गणना : (n : ℕ) → (Σ[ k ∈ ℕ ] Chosen n k) ≃ Fin (योगफल (पङ्क्ति n))
लग-गणना n =
  compEquiv (invEquiv (लग-विभागः n))
  (compEquiv (isoToEquiv (uddistaIso n))
             (pathToEquiv (cong Fin (sym (पङ्क्ति-योगः n)))))

------------------------------------------------------------------------
-- ७ · उदाहरणानि — कर्णेन गणितानि (refl), न मापितानि ।
------------------------------------------------------------------------

-- हलायुधस्य चतुर्थी पङ्क्तिः : 1 4 6 4 1, योगः १६ = २⁴ ।
_ : योगफल (पङ्क्ति 4) ≡ 16
_ = refl

_ : योगफल (पङ्क्ति 4) ≡ sankhya 4
_ = refl

-- दशमी पङ्क्तिः : १०२४ ।
_ : योगफल (पङ्क्ति 10) ≡ 1024
_ = refl

-- एका लगक्रिया : चतुरक्षरे द्वि-गुरूणि षट् रूपाणि ।
_ : नयन (पङ्क्ति 4) 2 ≡ 6
_ = refl

------------------------------------------------------------------------
-- ८ · शेषः — what is not settled here.
--
-- §६ counts the sum WITHOUT ever showing a summand empty.  What is
-- therefore still not proved is the summand-wise statement — that
-- `Chosen n k` is empty for k > n — which is true, is what would let
-- the infinite `Σ[ k ∈ ℕ ]` be replaced by a finite one over `Fin
-- (suc n)`, and is not needed for anything above.  Someone who wants
-- the row read term by term rather than in total has to prove it.
--
-- Also not here: the अध्वयोग, the sixth pratyaya, which measures the
-- SPACE the प्रस्तार would occupy if written out.  That is the one the
-- machine's `--no-table` design answers by refusing to write it, and it
-- has no module.
------------------------------------------------------------------------
