{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समघात-सङ्कलितम् — सङ्कलितस्य अवरोहः सान्तः, न सीमा-सापेक्षः ।
--
-- (the summation of like powers: the descent from one power to the next
--  is a finite identity, not a limit.)
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES, AND THEY ARE SECOND-HAND.
--
--   Jyeṣṭhadeva, युक्तिभाषा / *Gaṇita-yukti-bhāṣā* (Malayalam, c. 1530),
--   mathematics part, the परिधि–व्यास chapter — the **समघात-सङ्कलित**,
--   the summation of like powers, argued for a general power by
--   obtaining each power-sum by means of the one below it.
--
--   Nīlakaṇṭha Somayāji, तन्त्रसङ्ग्रहः (1501), which the युक्तिभाषा
--   derives; Mādhava of Saṅgamagrāma (c. 1340–1425), to whom the
--   material is attributed there.
--
--   Earlier, and the two results §५ and §६ recover: Āryabhaṭa,
--   आर्यभटीयम्, गणितपादः २१–२२ (499) — the चितिघन (the saṅkalita of
--   saṅkalitas) and the doubling rule 2·∑ = n(n+1).  Those verse numbers
--   are carried from `Citighana.agda` and `Sankalita.agda` in this lane.
--
-- NOT CLAIMED, and the omission is the important half: that Jyeṣṭhadeva,
-- Nīlakaṇṭha, Mādhava or Āryabhaṭa proved any statement below; that any
-- of the texts has been opened by the author of this file.  The citation
-- is carried from `notes/YUKTIBHASA_THE_SERIES_KEEPS_ITS_REMAINDER.md`,
-- which itself marks its account of the derivation `[recalled]`, and it
-- is owed at verse level.  What IS claimed is narrower and is §२: that
-- the descent from one power-sum to the next, as that note describes it —
-- "each power-sum estimated by means of the previous one" — has an exact
-- finite kernel, and that this is it.
--
-- Nothing here is claimed about π, and there is no series in this file.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS EXACT, AND WHAT IS NOT (§८, and it is declared, not filled).
--
-- The युक्तिभाषा's use of the समघात-सङ्कलित is asymptotic: for a fine
-- enough division, the sum of the p-th powers of 1…n is n^(p+1)/(p+1),
-- the deficit becoming negligible.  **That statement is not available in
-- this lane and is not approximated here.**  It needs ℚ or ℝ, a notion
-- of "negligible", and a limit; ℕ has none of the three.  This is the
-- same declaration `Madhava.agda` makes about the geometric remainder —
-- अनुक्तम्, न मिथ्या-सिद्धम्, un-said, not falsely proved — and the same
-- wall `NaturalMachine.SthaulyaIsTheOmittedTerm` records at its foot,
-- where an order statement about degree is unavailable in a lane whose
-- objects are ring elements.
--
-- What survives the scoping is the STEP, and it is an identity:
--
--     (n+1) · Σ_{k≤n} f(k)  =  Σ_{k≤n} k·f(k)  +  Σ_{j≤n} Σ_{k≤j} f(k)
--
-- — §२, `सङ्कलित-अवरोहः`.  Read right to left it is the युक्तिभाषा's own
-- move: the (p+1)-th power-sum is what is left of (n+1) times the p-th
-- once the repeated summation (सङ्कलित-सङ्कलितम्) has been taken out.
-- The deficit of Σk^(p+1) from n·Σk^p is EXACTLY a saṅkalita one order
-- down, at every finite n, with nothing thrown away.  §३ is that form
-- with the n rather than the n+1, which is how the text states it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FINDING, and it is what makes this more than a restatement.
--
-- The descent has nothing to do with powers.  §२ is proved for an
-- ARBITRARY sequence f : ℕ → ℕ; the powers enter only in §४, and only to
-- make k·f(k) be the next power, which is a definitional unfolding and
-- not a step of the proof.  So "summation of like powers" names the
-- instance the text needed, and the mechanism is bilinear bookkeeping on
-- any sequence whatever.
--
-- Two consequences, both checked below, and both of them are Āryabhaṭa's
-- rules falling out of the युक्तिभाषा's law as its first two instances:
--
--   §५  at the CONSTANT sequence f ≡ 1, the descent reads
--         (n+1)·n = ∑n + ∑n,
--       which is गणितपादः' doubling rule.  `द्विगुण-सङ्कलितम्-पुनः` is
--       `Sankalita.द्विगुण-सङ्कलितम्` re-derived from the general law
--       rather than by its own induction.
--
--   §६  at f = k, the descent reads (n+1)·∑n = ∑²n + चिति n, and
--       together with `Vargacitighana.योगद्वयम्` it gives
--       3·चिति n = (n+2)·∑n and hence 6·चिति n = n(n+1)(n+2) —
--       `चितिघनः-पुनः`, which is `Citighana.चितिघनः` obtained from the
--       descent instead of from the hand-derived cubic step there.
--
-- Neither re-derivation replaces the module it re-proves.  What they
-- establish is that the two Āryabhaṭa results and the युक्तिभाषा's
-- general descent are one law and two instances, which is a claim about
-- the lane's own files and is checked rather than asserted.
--
-- §७ is the p = 2 instance, which does not close on a corpus theorem:
-- (n+1)·∑²n = ∑³n + Σ_{j≤n} ∑²j, linking `Sankalita.∑³` to
-- `Vargacitighana.∑²` through the same law.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the container, not the
-- repository pin (BUILD.md).  No postulates, no holes.
------------------------------------------------------------------------

module Texts.SamaghataSankalita_TheDescentIsExactForEverySequenceAndAryabhatasRulesAreItsFirstInstances where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties
  using ( +-assoc ; +-comm ; ·-assoc ; ·-comm
        ; ·-identityʳ ; ·-distribˡ ; inj-m+ )

open import Texts.Sankalita_AryabhatasSeriesSumsAndTheCubeSumIsTheSquareOfTheSum      using (∑ ; ∑³ ; द्विगुण-सङ्कलितम्)
open import Citighana      using (चिति ; द्वि·)
open import Vargacitighana using (∑² ; योगद्वयम्)

------------------------------------------------------------------------
-- १.  सङ्कलितम् — the summation of a sequence from 1 to n.
--
-- The shape is `Sankalita.∑`'s, so that ∑, ∑², ∑³ and चिति are all
-- literally instances and no re-indexing lemma is needed anywhere below.
------------------------------------------------------------------------

योगः : (ℕ → ℕ) → ℕ → ℕ
योगः f zero    = zero
योगः f (suc n) = f (suc n) + योगः f n

योगः-सदृशम् : (f g : ℕ → ℕ) → ((k : ℕ) → f k ≡ g k)
            → (n : ℕ) → योगः f n ≡ योगः g n
योगः-सदृशम् f g h zero    = refl
योगः-सदृशम् f g h (suc n) = cong₂ _+_ (h (suc n)) (योगः-सदृशम् f g h n)

private
  विन्यासः : (a b c d : ℕ) → a + (b + (c + d)) ≡ (b + c) + (a + d)
  विन्यासः a b c d =
      cong (a +_) (+-assoc b c d)
    ∙ +-assoc a (b + c) d
    ∙ cong (_+ d) (+-comm a (b + c))
    ∙ sym (+-assoc (b + c) a d)

  सन्धिः : (a b c : ℕ) → a + (b + c) ≡ b + (a + c)
  सन्धिः a b c =
      +-assoc a b c
    ∙ cong (_+ c) (+-comm a b)
    ∙ sym (+-assoc b a c)

------------------------------------------------------------------------
-- २.  THE DESCENT, for an arbitrary sequence.
--
--     (n+1) · Σ_{k≤n} f(k)  ≡  Σ_{k≤n} k·f(k)  +  Σ_{j≤n} Σ_{k≤j} f(k)
--
-- Finite, exact, in ℕ, for every f.  No division, no limit, no order.
------------------------------------------------------------------------

सङ्कलित-अवरोहः : (f : ℕ → ℕ) (n : ℕ)
  → suc n · योगः f n ≡ योगः (λ k → k · f k) n + योगः (योगः f) n
सङ्कलित-अवरोहः f zero    = refl
सङ्कलित-अवरोहः f (suc n) =
    cong (योगः f (suc n) +_)
         (sym (·-distribˡ (suc n) (f (suc n)) (योगः f n)))
  ∙ cong (λ z → योगः f (suc n) + ((suc n · f (suc n)) + z))
         (सङ्कलित-अवरोहः f n)
  ∙ विन्यासः (योगः f (suc n)) (suc n · f (suc n))
             (योगः (λ k → k · f k) n) (योगः (योगः f) n)

------------------------------------------------------------------------
-- ३.  THE SAME, IN THE FORM THE TEXT STATES.
--
-- n times the sum, not (n+1) times, with the repeated summation running
-- one short — "the excess of n·Σf over Σk·f is the saṅkalita of the
-- saṅkalitas up to n−1".  Obtained from §२ by cancelling one copy of the
-- sum on both sides, which is `inj-m+`, addition in ℕ being injective.
------------------------------------------------------------------------

सङ्कलित-अवरोहः-न्यूनः : (f : ℕ → ℕ) (m : ℕ)
  → suc m · योगः f (suc m)
  ≡ योगः (λ k → k · f k) (suc m) + योगः (योगः f) m
सङ्कलित-अवरोहः-न्यूनः f m = inj-m+ {m = योगः f (suc m)} पदम्
  where
  पदम् : योगः f (suc m) + (suc m · योगः f (suc m))
       ≡ योगः f (suc m)
         + (योगः (λ k → k · f k) (suc m) + योगः (योगः f) m)
  पदम् = सङ्कलित-अवरोहः f (suc m)
       ∙ सन्धिः (योगः (λ k → k · f k) (suc m))
                (योगः f (suc m)) (योगः (योगः f) m)

------------------------------------------------------------------------
-- ४.  समघात-सङ्कलितम् — the like-power instance.
--
-- The only thing the powers contribute is that k·k^p is k^(p+1), which
-- is how `घातः` is defined; so §४ is §२ with nothing added.
------------------------------------------------------------------------

घातः : ℕ → ℕ → ℕ
घातः k zero    = 1
घातः k (suc p) = k · घातः k p

समघात-सङ्कलितम् : ℕ → ℕ → ℕ
समघात-सङ्कलितम् p n = योगः (λ k → घातः k p) n

समघात-अवरोहः : (p n : ℕ)
  → suc n · समघात-सङ्कलितम् p n
  ≡ समघात-सङ्कलितम् (suc p) n + योगः (समघात-सङ्कलितम् p) n
समघात-अवरोहः p n = सङ्कलित-अवरोहः (λ k → घातः k p) n

------------------------------------------------------------------------
-- ४a.  The low powers, identified with the lane's existing summations.
------------------------------------------------------------------------

मूल-योगः : (n : ℕ) → योगः (λ k → k) n ≡ ∑ n
मूल-योगः zero    = refl
मूल-योगः (suc n) = cong (suc n +_) (मूल-योगः n)

शून्य-सङ्कलितम् : (n : ℕ) → समघात-सङ्कलितम् 0 n ≡ n
शून्य-सङ्कलितम् zero    = refl
शून्य-सङ्कलितम् (suc n) = cong suc (शून्य-सङ्कलितम् n)

एक-सङ्कलितम् : (n : ℕ) → समघात-सङ्कलितम् 1 n ≡ ∑ n
एक-सङ्कलितम् n =
  योगः-सदृशम् (λ k → घातः k 1) (λ k → k) (λ k → ·-identityʳ k) n
  ∙ मूल-योगः n

द्वि-सङ्कलितम् : (n : ℕ) → समघात-सङ्कलितम् 2 n ≡ ∑² n
द्वि-सङ्कलितम् zero    = refl
द्वि-सङ्कलितम् (suc n) =
  cong₂ _+_ (cong (suc n ·_) (·-identityʳ (suc n))) (द्वि-सङ्कलितम् n)

त्रि-सङ्कलितम् : (n : ℕ) → समघात-सङ्कलितम् 3 n ≡ ∑³ n
त्रि-सङ्कलितम् zero    = refl
त्रि-सङ्कलितम् (suc n) =
  cong₂ _+_ (cong (λ z → suc n · (suc n · z)) (·-identityʳ (suc n)))
            (त्रि-सङ्कलितम् n)

पुनः-सङ्कलितम् : (n : ℕ) → योगः (समघात-सङ्कलितम् 1) n ≡ चिति n
पुनः-सङ्कलितम् zero    = refl
पुनः-सङ्कलितम् (suc n) =
  cong₂ _+_ (एक-सङ्कलितम् (suc n)) (पुनः-सङ्कलितम् n)

------------------------------------------------------------------------
-- ५.  FIRST INSTANCE — p = 0, the constant sequence.
--
-- Σ_{k≤n} 1 = n, Σ_{k≤n} k·1 = ∑n, Σ_{j≤n} j = ∑n, so the descent is
--
--     (n+1)·n = ∑n + ∑n,
--
-- which is आर्यभटीयम् गणितपादः' doubling rule.  `Sankalita` proves it by
-- its own induction; here it is a consequence.
------------------------------------------------------------------------

आर्यभट-द्विगुणम् : (n : ℕ) → suc n · n ≡ ∑ n + ∑ n
आर्यभट-द्विगुणम् n =
    cong (suc n ·_) (sym (शून्य-सङ्कलितम् n))
  ∙ समघात-अवरोहः 0 n
  ∙ cong₂ _+_ (एक-सङ्कलितम् n)
              ( योगः-सदृशम् (समघात-सङ्कलितम् 0) (λ k → k) शून्य-सङ्कलितम् n
              ∙ मूल-योगः n )

द्विगुण-सङ्कलितम्-पुनः : (n : ℕ) → ∑ n + ∑ n ≡ n · suc n
द्विगुण-सङ्कलितम्-पुनः n = sym (आर्यभट-द्विगुणम् n) ∙ ·-comm (suc n) n

------------------------------------------------------------------------
-- ६.  SECOND INSTANCE — p = 1, and it recovers the चितिघन.
--
-- The descent at f = k reads (n+1)·∑n = ∑²n + चिति n.  With
-- `Vargacitighana.योगद्वयम्` (∑²n + ∑n = 2·चिति n) that gives
-- (n+2)·∑n = 3·चिति n, and doubling gives 6·चिति n = n(n+1)(n+2).
------------------------------------------------------------------------

एक-अवरोहः : (n : ℕ) → suc n · ∑ n ≡ ∑² n + चिति n
एक-अवरोहः n =
    cong (suc n ·_) (sym (एक-सङ्कलितम् n))
  ∙ समघात-अवरोहः 1 n
  ∙ cong₂ _+_ (द्वि-सङ्कलितम् n) (पुनः-सङ्कलितम् n)

private
  त्रि-गुणः : (x : ℕ) → 2 · x + x ≡ 3 · x
  त्रि-गुणः x = sym (+-assoc x (x + 0) x) ∙ cong (x +_) (+-comm (x + 0) x)

त्रि-चितिः : (n : ℕ) → suc (suc n) · ∑ n ≡ 3 · चिति n
त्रि-चितिः n =
    cong (∑ n +_) (एक-अवरोहः n)
  ∙ +-assoc (∑ n) (∑² n) (चिति n)
  ∙ cong (_+ चिति n) (+-comm (∑ n) (∑² n))
  ∙ cong (_+ चिति n) (योगद्वयम् n)
  ∙ त्रि-गुणः (चिति n)

चितिघनः-पुनः : (n : ℕ) → 6 · चिति n ≡ n · suc n · suc (suc n)
चितिघनः-पुनः n =
    sym (·-assoc 2 3 (चिति n))
  ∙ cong (2 ·_) (sym (त्रि-चितिः n))
  ∙ ·-assoc 2 (suc (suc n)) (∑ n)
  ∙ cong (_· ∑ n) (·-comm 2 (suc (suc n)))
  ∙ sym (·-assoc (suc (suc n)) 2 (∑ n))
  ∙ cong (suc (suc n) ·_) (द्वि· (∑ n) ∙ द्विगुण-सङ्कलितम्-पुनः n)
  ∙ ·-comm (suc (suc n)) (n · suc n)

------------------------------------------------------------------------
-- ७.  THIRD INSTANCE — p = 2, which closes on no corpus theorem.
--
-- (n+1)·∑²n = ∑³n + Σ_{j≤n} ∑²j.  `Sankalita.∑³` and
-- `Vargacitighana.∑²` were proved in this lane with no relation between
-- them; the descent supplies one, and the second summand is a repeated
-- summation that the lane does not otherwise name.
------------------------------------------------------------------------

द्वि-अवरोहः : (n : ℕ) → suc n · ∑² n ≡ ∑³ n + योगः ∑² n
द्वि-अवरोहः n =
    cong (suc n ·_) (sym (द्वि-सङ्कलितम् n))
  ∙ समघात-अवरोहः 2 n
  ∙ cong₂ _+_ (त्रि-सङ्कलितम् n)
              (योगः-सदृशम् (समघात-सङ्कलितम् 2) ∑² द्वि-सङ्कलितम् n)

------------------------------------------------------------------------
-- ८.  IT RUNS.
--
-- The descent is an identity, so its instances hold by `refl` once both
-- sides are closed numerals; these check that the definitions are the
-- ones the sections above are about, and not something else with the
-- same names.
--
--   p = 2, n = 3:  4 · (1+4+9)   = 56 = (1+8+27) + (1 + 5 + 14)
--   p = 4, n = 3:  1 + 16 + 81   = 98
------------------------------------------------------------------------

गणना-समघातः : समघात-सङ्कलितम् 4 3 ≡ 98
गणना-समघातः = refl

गणना-अवरोहः : suc 3 · ∑² 3 ≡ ∑³ 3 + योगः ∑² 3
गणना-अवरोहः = refl

गणना-अवरोहः-न्यूनः : 3 · ∑² 3 ≡ ∑³ 3 + योगः ∑² 2
गणना-अवरोहः-न्यूनः = refl

गणना-चितिः : 6 · चिति 4 ≡ 4 · 5 · 6
गणना-चितिः = चितिघनः-पुनः 4
