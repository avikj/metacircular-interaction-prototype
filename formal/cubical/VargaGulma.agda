{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्ग-गुल्मः — शुल्ब-गुल्म-रचनायाः अङ्कगणितम् : ओज-योगः = वर्गः (∑ विषमाः = n²) ।
--
-- शुल्ब-सूत्रेषु (बौधायनादिषु) समचतुरस्रः "गुल्मैः" (gnomon, L-आकार-वृद्धिभिः)
-- वर्धते : n×n-वर्गं (n+1)×(n+1)-वर्गं कर्तुं यत् योज्यते, तत् गुल्मः , तस्य
-- मानम् = 2n+1 (विषम-सङ्ख्या) ।  अतः प्रथमानां n विषमाणां योगः = n×n वर्गः ।
-- एतत् गुल्म-रचनायाः अङ्क-रूपम् : ओज-योग n ≡ n · n ।  (ऋण-रहितम्, ℕ-मध्ये ।)
--
-- (The arithmetic behind the śulba gnomon construction: a square is grown by
-- gnomons — L-shaped borders — the k-th of which has size 2k+1, the next odd
-- number, so n gnomons build an n×n square.  Hence the sum of the first n odd
-- numbers is n²: ओज-योग n ≡ n · n, subtraction-free over ℕ.  The gnomon
-- (samacaturaśra grown by gulma) is the Śulba tradition's; no specific verse is
-- claimed for this arithmetic identity, only the construction it counts.)
--
-- स्रोतांसि : बौधायन-शुल्बसूत्रम् (समचतुरस्र-वृद्धिः, गुल्म-रचना) ।
------------------------------------------------------------------------

module VargaGulma where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-assoc ; +-comm ; +-suc ; ·-suc ; +-zero ; ·-distribˡ)
open import Sankalita using (∑ ; ∑³ ; घन-सङ्कलितम्)

------------------------------------------------------------------------
-- ओज — k-तमः विषमः (0-आदिः) : ओज k = 2k+1 = suc(k+k) ।
------------------------------------------------------------------------

ओज : ℕ → ℕ
ओज k = suc (k + k)

------------------------------------------------------------------------
-- ओज-योग — प्रथमानां n विषमाणां योगः : ∑_{k=0}^{n−1} (2k+1) ।
------------------------------------------------------------------------

ओज-योग : ℕ → ℕ
ओज-योग zero    = zero
ओज-योग (suc n) = ओज-योग n + ओज n

------------------------------------------------------------------------
-- वर्ग-गुल्मः — मुख्य-नियमः : ओज-योग n ≡ n · n (n गुल्माः → n×n वर्गः) ।
------------------------------------------------------------------------

private
  -- (n+1)² = n² + (2n+1) : एक-गुल्म-वृद्धिः ।
  पदः : (n : ℕ) → suc n · suc n ≡ n · n + suc (n + n)
  पदः n =
      cong (suc n +_) (·-suc n n)
    ∙ cong suc (+-assoc n n (n · n))
    ∙ cong suc (+-comm (n + n) (n · n))
    ∙ sym (+-suc (n · n) (n + n))

वर्ग-गुल्मः : (n : ℕ) → ओज-योग n ≡ n · n
वर्ग-गुल्मः zero    = refl
वर्ग-गुल्मः (suc n) =
    cong (_+ ओज n) (वर्ग-गुल्मः n)
  ∙ sym (पदः n)

------------------------------------------------------------------------
-- उदाहरणे — 1+3+5+7 = 16 = 4² ; 1+3+5+7+9 = 25 = 5² (refl-सिद्धे) ।
------------------------------------------------------------------------

गुल्म-४ : ओज-योग 4 ≡ 16
गुल्म-४ = refl

गुल्म-५ : ओज-योग 5 ≡ 25
गुल्म-५ = refl

------------------------------------------------------------------------
-- युग्म-गुल्मः — आयतचतुरस्रस्य गुल्म-रचना : युग्म-योगः = ओज-योगः + n = n(n+1) ।
--
-- शुल्बे द्वे रूपे गुल्मैः वर्धेते : समचतुरस्रः (वर्गः, विषम-गुल्मैः, वर्ग-गुल्मः) च
-- आयतचतुरस्रः (n×(n+1)-आयतः, युग्म-गुल्मैः) ।  प्रति युग्म-गुल्मः तत्-संगत-ओज-गुल्मात्
-- एकेन अधिकः (युग्म k = suc(ओज k) = 2k+2) , अतः n गुल्मेषु युग्म-योग = ओज-योग + n ।
-- ततः वर्ग-गुल्मेन युग्म-योग n = n·n + n = n·(n+1) — आयत-सङ्ख्या (oblong) ।
--
-- (The śulba grows two figures by gnomons: the square (samacaturaśra, odd
-- gnomons — वर्ग-गुल्मः) and the oblong n×(n+1) (āyatacaturaśra, even gnomons).
-- Each even gnomon exceeds its odd counterpart by one (युग्म k = suc(ओज k)), so
-- over n gnomons युग्म-योग n ≡ ओज-योग n + n, and with the square law that is
-- n(n+1) — the oblong number.  The genuinely new content is the odd↔even gnomon
-- relation; the value n(n+1) also follows from Sankalita's 2·∑k.)
------------------------------------------------------------------------

युग्म : ℕ → ℕ
युग्म k = suc (suc (k + k))

युग्म-योग : ℕ → ℕ
युग्म-योग zero    = zero
युग्म-योग (suc n) = युग्म-योग n + युग्म n

-- आयत-वर्ग-अन्तरम् — युग्म-योग n ≡ ओज-योग n + n (युग्म-गुल्मः ओज-गुल्मात् एकाधिकः) ।
आयत-वर्ग-अन्तरम् : (n : ℕ) → युग्म-योग n ≡ ओज-योग n + n
आयत-वर्ग-अन्तरम् zero    = refl
आयत-वर्ग-अन्तरम् (suc n) =
    cong (_+ युग्म n) (आयत-वर्ग-अन्तरम् n)
  ∙ +-suc (ओज-योग n + n) (ओज n)
  ∙ cong suc (sym (+-assoc (ओज-योग n) n (ओज n)))
  ∙ cong suc (cong (ओज-योग n +_) (+-comm n (ओज n)))
  ∙ cong suc (+-assoc (ओज-योग n) (ओज n) n)
  ∙ sym (+-suc (ओज-योग n + ओज n) n)

-- आयत-नियमः — युग्म-योग n ≡ n · suc n (आयत-सङ्ख्या) , वर्ग-गुल्मात् ।
आयत-नियमः : (n : ℕ) → युग्म-योग n ≡ n · suc n
आयत-नियमः n =
    आयत-वर्ग-अन्तरम् n
  ∙ cong (_+ n) (वर्ग-गुल्मः n)
  ∙ +-comm (n · n) n
  ∙ sym (·-suc n n)

-- उदाहरणम् — 2+4+6+8 = 20 = 4·5 (refl-सिद्धम्) ।
आयत-४ : युग्म-योग 4 ≡ 20
आयत-४ = refl

------------------------------------------------------------------------
-- ओज-घनः — निकोमाखोस्-रूपम् : प्रथमानां T(n) विषमाणां योगः = प्रथमानां n घनानां योगः ।
-- ओज-योग(∑ n) ≡ ∑³ n , यतः उभौ (∑ n)² — शुल्ब-गुल्म-वर्गः (वर्ग-गुल्मः) च आर्यभटस्य
-- घन-रत्नम् (∑k³=(∑k)², घन-सङ्कलितम्) एकत्र मिलतः ।  विषम-श्रेढी घन-श्रेढीं वहति ।
--
-- (Nicomachus's theorem in odd-number form: the sum of the first T(n) odd
-- numbers equals the sum of the first n cubes, ओज-योग(∑ n) ≡ ∑³ n — both are
-- (∑n)², where the śulba gnomon-square law and Āryabhaṭa's cube gem ∑k³=(∑k)²
-- meet.  The odd-number series carries the cube series.)
------------------------------------------------------------------------

ओज-घनः : (n : ℕ) → ओज-योग (∑ n) ≡ ∑³ n
ओज-घनः n = वर्ग-गुल्मः (∑ n) ∙ sym (घन-सङ्कलितम् n)

------------------------------------------------------------------------
-- घन-गुल्मः — घन-गुल्म-रचना (त्रि-मित-कोश) : (n+1)³ = n³ + 3n(n+1) + 1 ।
-- घनं (सम-घनः) त्रि-मित-गुल्मैः (L-कोशैः) वर्धते ; n-तमः कोशः = 3n(n+1)+1 ।
-- (The cube grown by 3-D gnomons (corner shells): (n+1)³ − n³ = 3n(n+1)+1, so
--  suc n · (suc n · suc n) ≡ n·(n·n) + (3·n(n+1) + 1), written additively over ℕ.
--  Hand-proved: the expansion is one ·-distribˡ, then suc n + n·n ≡ n·suc n + 1.)
------------------------------------------------------------------------

घन-गुल्मः : (n : ℕ) → suc n · (suc n · suc n)
          ≡ n · (n · n) + (n · suc n + (n · suc n + (n · suc n + 1)))
घन-गुल्मः n =
    sym (·-distribˡ (suc n) (suc n) (n · suc n))
  ∙ cong (λ z → (suc n + P) + (P + z)) qexp
  ∙ +-assoc (suc n + P) P (R + Q)
  ∙ +-assoc ((suc n + P) + P) R Q
  ∙ cong (_+ Q) step1
  ∙ cong (λ z → (z + (P + P)) + Q) keyfact
  ∙ +-comm ((P + 1) + (P + P)) Q
  ∙ cong (Q +_) step2
  where
    P = n · suc n
    R = n · n
    Q = n · (n · n)
    one : (x : ℕ) → x + 1 ≡ suc x
    one x = +-suc x 0 ∙ cong suc (+-zero x)
    qexp : n · (n · suc n) ≡ R + Q
    qexp = cong (n ·_) (·-suc n n) ∙ sym (·-distribˡ n n (n · n))
    keyfact : suc n + R ≡ P + 1
    keyfact = sym (cong (_+ 1) (·-suc n n) ∙ one (n + n · n))
    step1 : ((suc n + P) + P) + R ≡ (suc n + R) + (P + P)
    step1 = cong (_+ R) (sym (+-assoc (suc n) P P))
          ∙ sym (+-assoc (suc n) (P + P) R)
          ∙ cong (suc n +_) (+-comm (P + P) R)
          ∙ +-assoc (suc n) R (P + P)
    step2 : (P + 1) + (P + P) ≡ P + (P + (P + 1))
    step2 = sym (+-assoc P 1 (P + P))
          ∙ cong (P +_) (+-comm 1 (P + P))
          ∙ cong (P +_) (sym (+-assoc P P 1))

-- उदाहरणम् — 4³ = 64 = 3³ + 3·3·4 + 1 = 27 + 36 + 1 (refl-सिद्धम्) ।
घन-४ : suc 3 · (suc 3 · suc 3) ≡ 64
घन-४ = refl

------------------------------------------------------------------------
-- घन-योग-नियमः — घन-गुल्म-कोशानां योगः = घनः : ∑ (3k(k+1)+1) = n³ ।
-- (यथा विषम-गुल्माः वर्गं रचयन्ति, तथा त्रि-मित-घन-गुल्माः घनं रचयन्ति —
--  घन-योग n ≡ n³ , घन-गुल्मात् प्रति-कोशम् ।  ओज-योग=n² इत्यस्य त्रि-मित-रूपम् ।)
--
-- (As the odd gnomons build the square, the 3-D cube gnomons build the cube:
--  the sum of the shells 3k(k+1)+1 over k<n is n³, telescoping through घन-गुल्मः.
--  The three-dimensional analogue of ओज-योग = n².)
------------------------------------------------------------------------

घन-योग : ℕ → ℕ
घन-योग zero    = zero
घन-योग (suc n) = घन-योग n + (n · suc n + (n · suc n + (n · suc n + 1)))

घन-योग-नियमः : (n : ℕ) → घन-योग n ≡ n · (n · n)
घन-योग-नियमः zero    = refl
घन-योग-नियमः (suc n) =
    cong (_+ (n · suc n + (n · suc n + (n · suc n + 1)))) (घन-योग-नियमः n)
  ∙ sym (घन-गुल्मः n)

-- उदाहरणम् — 1 + 7 + 19 + 37 = 64 = 4³ (refl-सिद्धम्) ।
घन-योग-४ : घन-योग 4 ≡ 64
घन-योग-४ = refl
