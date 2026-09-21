{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्गमूलम् — the square root is the threshold, and it is forced.
--
-- SOURCE (owner transmission D0022, "Evaluation geometry, collision
-- divisors, and polynomial moduli", recovered from git history; quoted
-- exactly):
--
--   "**T22.2**: for a fixed finite prime set S there exist composites
--    coprime to every p in S — Proof: choose primes q,r outside S and
--    take qr."
--   "**T22.3**: for m ≤ X, testing all primes ≤ √X is sufficient."
--   "**T22.4**: if primes r,s > z exist with rs ≤ X, divisibility only by
--    primes ≤ z is insufficient for primality on [1,X] — an explicit
--    behavioral separator forcing the square-root threshold."
--   "Therefore no fixed finite local-divisibility observer decides
--    unbounded primality."
--   "Hence the issue is not absolute nonreconstructibility. It is growth
--    of the sufficient observer with task scale."
--   "**T22.5**: Center, product, and gap are simply coefficient/
--    discriminant coordinates of the quadratic whose roots are the pair:
--    F(X) = X² − 2wX + (w² − r²), e₁ = 2w, e₂ = w² − r², disc = 4r²."
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, in the corpus's own terms.  "Prime" is Drdha's दृढम्
-- (1 < p and every divisor is 1 or p, divisor in the library's
-- truncated `_∣_`); the factorisation is Drdha's विभाजनम्; Euclid's lemma
-- is Drdha's युक्लिड-वाक्यम्; the infinitude of primes is Anantata's
-- `euclid` (n! + 1 has a prime factor above n), which lives over
-- Prakriti's `IsPrime` — §0 bridges the two prime predicates both ways.
--
--   §0  सेतुः      दृढम् p ↔ IsPrime p, and Euclid's "a prime above n"
--                 read in दृढम्.
--   §1  अस्पृष्टम्  THE CORE LEMMA.  If 1 < d and q, r are primes above
--                 d, then d does not divide q · r.  (Any d: take a prime
--                 factor of d and apply Euclid's lemma.)  Hence for EVERY
--                 modulus d below both q and r, d ∣ q and d ∣ q·r read
--                 alike (both false for d ≥ 2 and d = 0, both true for
--                 d = 1).
--   §2  T22.2      For every finite list S of primes there are primes
--                 q < r with q, r ∉ S, q · r NOT prime, no member of S
--                 dividing q · r, and gcd p (q · r) ≡ 1 for every p ∈ S.
--                 Constructed: q above the sum of S, r above q.
--   §3  T22.3      For 0 < m ≤ X: if no prime p with p · p ≤ X divides
--                 m, then m ≡ 1 or m is prime.  Equivalently, a composite
--                 m ≤ X has a prime divisor p with p · p ≤ X.  Via
--                 Drdha's factorisation: a list of two or more primes
--                 has an entry whose square is at most its product.
--   §4  T22.4      For z, X and primes r, s > z with r · s ≤ X: both r
--                 and r · s lie in [1, X], r is prime, r · s is not, and
--                 for every prime p ≤ z the readings p ∣ r and p ∣ (r · s)
--                 agree (both false).  Consequently NO property that is a
--                 function of the "primes ≤ z" divisibility readings
--                 coincides with primality on [1, X].
--   §5  सर्वत्र     "No fixed finite local-divisibility observer decides
--                 unbounded primality":  for every finite list S of
--                 moduli (ANY naturals, prime or not) there are a prime q
--                 and a non-prime q · r whose divisibility readings by
--                 every member of S agree, so no property that is a
--                 function of those readings coincides with primality on
--                 all of ℕ.  This is §2's witness read through §1.
--   §6  T22.5      Over ℤ, by the commutative-ring solver: the monic
--                 quadratic with roots w − r and w + r is
--                 X² − (2w)X + (w² − r²); its root sum e₁ is 2w, its root
--                 product e₂ is w² − r², its root gap is 2r, and its
--                 discriminant e₁² − 4e₂ is 4r² = (gap)².  Both roots are
--                 verified to be roots.  Over ℕ, for r ≤ w, the same
--                 reads in EkaBija's centre/radius chart (w ∸ r, w + r):
--                 (w ∸ r) + (w + r) ≡ 2 · w,  (w ∸ r) · (w + r) + r · r
--                 ≡ w · w, and (w + r) ∸ (w ∸ r) ≡ 2 · r.  So EkaBija's
--                 chart IS Vieta for the pair.
--
-- For m = 0 the hypothesis is vacuous when X < 4 and 0 is neither 1 nor
-- prime, so the bound is needed and is stated. · "Sufficient" in T22.3 is the
-- mathematical statement, not a statement about the Boolean testers
-- `primeb`/`spf` of SamastaPrasna/RH_; those are not touched here. ·
-- "Observer" is formalised as the family of divisibility readings (d ∣ n for
-- d in a finite list, or for primes d ≤ z), and "decides primality" as: some
-- property that depends on n ONLY through those readings coincides with
-- दृढम्. The separator refutes every such property at once. Nothing is said
-- about observers of any other shape. · The sentence "growth of the
-- sufficient observer with task scale" is illustrated (T22.3 gives a
-- sufficient observer of size √X; T22.4 shows z < √X does not suffice when
-- two primes sit in (z, √X]) but "growth" is not itself a formal statement
-- here. · T22.5 over ℤ uses no ordering; the ℕ chart needs r ≤ w and says so.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes, no TERMINATING pragmas.
------------------------------------------------------------------------

module Vargamula_TwoPrimesAboveTheThresholdMakeAnUnseenCompositeSoTheSquareRootIsForcedNoFiniteDivisibilityObserverDecidesPrimalityAndCentreRadiusIsVieta where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; ∣-untrunc ; ∣-left ; ∣-right ; ∣-trans ; ∣-oneˡ ; ∣-zeroˡ ; m∣n→m≤n)
open import Cubical.Data.Nat.GCD using (gcd ; gcdIsGCD)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr) renaming (rec to ⊎-rec)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing using (CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import Prakriti using (IsPrime ; primeFactor)
open import Anantata using (euclid)
open import Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision
  using (दृढम् ; वधः ; सर्वे ; _सदस्यः_ ; विभाजनम् ; युक्लिड-वाक्यम्)
open import PairCompositionSeed_ProductOfTwoFactorsAtLeastTwoIsNeverPrimeSoNoComposedPairIsAPrimePair
  using (¬prime-product)

------------------------------------------------------------------------
-- small logical furniture: "reads alike"
------------------------------------------------------------------------

_↔_ : Type₀ → Type₀ → Type₀
A ↔ B = (A → B) × (B → A)

------------------------------------------------------------------------
-- §0 · सेतुः — the two prime predicates are one, and Euclid in दृढम्.
------------------------------------------------------------------------

दृढ→IsPrime : (p : ℕ) → दृढम् p → IsPrime p
दृढ→IsPrime p (1<p , h) = 1<p , λ d (c , e) → h d ∣ c , e ∣₁

IsPrime→दृढ : (p : ℕ) → IsPrime p → दृढम् p
IsPrime→दृढ p (1<p , h) = 1<p , λ d d∣p → h d (∣-untrunc d∣p)

-- Euclid (Anantata): a prime above every n — read in दृढम्.
अनन्तता : (n : ℕ) → Σ[ p ∈ ℕ ] दृढम् p × (n < p)
अनन्तता n = fst (euclid n)
          , IsPrime→दृढ (fst (euclid n)) (fst (snd (euclid n)))
          , snd (snd (euclid n))

------------------------------------------------------------------------
-- §1 · अस्पृष्टम् — the untouched product.
------------------------------------------------------------------------

-- a product of positives is positive
0<· : (x y : ℕ) → 0 < x → 0 < y → 0 < x · y
0<· x y 0<x 0<y =
  ≤-trans 0<x (subst2 _≤_ (·-identityˡ x) (·-comm y x) (≤-·k {1} {y} {x} 0<y))

-- a number strictly between 1 and the prime q does not divide q
अल्पः-न-भजति : (d q : ℕ) → 1 < d → दृढम् q → d < q → ¬ (d ∣ q)
अल्पः-न-भजति d q 1<d (_ , h) d<q d∣q =
  ⊎-rec (λ d≡1 → <→≢ 1<d (sym d≡1)) (<→≢ d<q) (h d d∣q)

-- every d > 1 has a firm divisor (Prakriti's primeFactor, read in दृढम्)
दृढ-भाजकः : (d : ℕ) → 1 < d → Σ[ p ∈ ℕ ] दृढम् p × (p ∣ d)
दृढ-भाजकः d 1<d =
    fst (primeFactor d 1<d)
  , IsPrime→दृढ (fst (primeFactor d 1<d)) (fst (snd (primeFactor d 1<d)))
  , ∣ snd (snd (primeFactor d 1<d)) ∣₁

-- THE CORE: 1 < d, primes q r above d  ⇒  d ∤ q · r.
-- (d need not be prime: a prime factor of d would divide q or r.)
अस्पृष्टम् : (d q r : ℕ) → 1 < d → दृढम् q → दृढम् r → d < q → d < r
           → ¬ (d ∣ (q · r))
अस्पृष्टम् d q r 1<d दृq दृr d<q d<r d∣qr =
  ⊎-rec (अल्पः-न-भजति p q 1<p दृq (≤<-trans p≤d d<q))
        (अल्पः-न-भजति p r 1<p दृr (≤<-trans p≤d d<r))
        (युक्लिड-वाक्यम् p q r दृp (∣-trans p∣d d∣qr))
  where
  p : ℕ
  p = fst (दृढ-भाजकः d 1<d)
  दृp : दृढम् p
  दृp = fst (snd (दृढ-भाजकः d 1<d))
  1<p : 1 < p
  1<p = fst दृp
  p∣d : p ∣ d
  p∣d = snd (snd (दृढ-भाजकः d 1<d))
  d≢0 : ¬ (d ≡ 0)
  d≢0 d≡0 = ¬-<-zero (subst (1 <_) d≡0 1<d)
  p≤d : p ≤ d
  p≤d = m∣n→m≤n d≢0 p∣d

-- for EVERY modulus d below both primes, "d ∣ q" and "d ∣ q · r" agree.
पाठ-प्रत्यागमः : (d q r : ℕ) → दृढम् q → दृढम् r → d < q → d < r
              → d ∣ (q · r) → d ∣ q
पाठ-प्रत्यागमः zero          q r दृq दृr _   _   0∣qr =
  ⊥-rec (¬m<m (subst (0 <_) (sym (∣-zeroˡ 0∣qr))
                     (0<· q r (<-weaken (fst दृq)) (<-weaken (fst दृr)))))
पाठ-प्रत्यागमः (suc zero)    q r _   _   _   _   _    = ∣-oneˡ q
पाठ-प्रत्यागमः (suc (suc d)) q r दृq दृr d<q d<r d∣qr =
  ⊥-rec (अस्पृष्टम् (suc (suc d)) q r (suc-≤-suc (suc-≤-suc zero-≤)) दृq दृr d<q d<r d∣qr)

समान-पाठः : (d q r : ℕ) → दृढम् q → दृढम् r → d < q → d < r
          → (d ∣ q) ↔ (d ∣ (q · r))
समान-पाठः d q r दृq दृr d<q d<r =
  (λ d∣q → ∣-trans d∣q (∣-left r)) , पाठ-प्रत्यागमः d q r दृq दृr d<q d<r

------------------------------------------------------------------------
-- §2 · T22.2 — composites coprime to every member of a finite prime set.
------------------------------------------------------------------------

योगः : List ℕ → ℕ
योगः []       = 0
योगः (x ∷ xs) = x + योगः xs

सदस्य-≤-योगः : (x : ℕ) (L : List ℕ) → x सदस्यः L → x ≤ योगः L
सदस्य-≤-योगः x (y ∷ ys) (inl e) = subst (_≤ y + योगः ys) (sym e) ≤SumLeft
सदस्य-≤-योगः x (y ∷ ys) (inr m) = ≤-trans (सदस्य-≤-योगः x ys m) ≤SumRight

सदस्य-सर्वे : {P : ℕ → Type₀} (x : ℕ) (L : List ℕ) → x सदस्यः L → सर्वे P L → P x
सदस्य-सर्वे {P} x (y ∷ ys) (inl e) (Py , _)   = subst P (sym e) Py
सदस्य-सर्वे {P} x (y ∷ ys) (inr m) (_ , rest) = सदस्य-सर्वे x ys m rest

-- two primes q < r, both above every member of S
द्वौ-बहिः : (S : List ℕ)
        → Σ[ q ∈ ℕ ] Σ[ r ∈ ℕ ] दृढम् q × दृढम् r × (q < r)
          × ((d : ℕ) → d सदस्यः S → (d < q) × (d < r))
द्वौ-बहिः S = q , r , दृq , दृr , q<r ,
  λ d m → ≤<-trans (सदस्य-≤-योगः d S m) B<q
        , <-trans (≤<-trans (सदस्य-≤-योगः d S m) B<q) q<r
  where
  B   = योगः S
  q   = fst (अनन्तता B)
  दृq : दृढम् q
  दृq = fst (snd (अनन्तता B))
  B<q : B < q
  B<q = snd (snd (अनन्तता B))
  r   = fst (अनन्तता q)
  दृr : दृढम् r
  दृr = fst (snd (अनन्तता q))
  q<r : q < r
  q<r = snd (snd (अनन्तता q))

-- a prime p not dividing m has gcd p m ≡ 1
अभाज्य-गcd : (p m : ℕ) → दृढम् p → ¬ (p ∣ m) → gcd p m ≡ 1
अभाज्य-गcd p m (_ , h) p∤m =
  ⊎-rec (λ g≡1 → g≡1)
        (λ g≡p → ⊥-rec (p∤m (subst (_∣ m) g≡p (snd (fst (gcdIsGCD p m))))))
        (h (gcd p m) (fst (fst (gcdIsGCD p m))))

T22-2 : (S : List ℕ) → सर्वे दृढम् S
      → Σ[ q ∈ ℕ ] Σ[ r ∈ ℕ ]
          दृढम् q × दृढम् r × (q < r)
        × (¬ (q सदस्यः S)) × (¬ (r सदस्यः S))
        × (¬ दृढम् (q · r))
        × ((p : ℕ) → p सदस्यः S → ¬ (p ∣ (q · r)))
        × ((p : ℕ) → p सदस्यः S → gcd p (q · r) ≡ 1)
T22-2 S allS = q , r , दृq , दृr , q<r
             , (λ m → ¬m<m (fst (above q m)))
             , (λ m → ¬m<m (snd (above r m)))
             , ¬prime-product q r (fst दृq) (fst दृr)
             , untouched
             , (λ p m → अभाज्य-गcd p (q · r) (सदस्य-सर्वे p S m allS) (untouched p m))
  where
  W = द्वौ-बहिः S
  q = fst W
  r = fst (snd W)
  दृq : दृढम् q
  दृq = fst (snd (snd W))
  दृr : दृढम् r
  दृr = fst (snd (snd (snd W)))
  q<r : q < r
  q<r = fst (snd (snd (snd (snd W))))
  above : (d : ℕ) → d सदस्यः S → (d < q) × (d < r)
  above = snd (snd (snd (snd (snd W))))
  untouched : (p : ℕ) → p सदस्यः S → ¬ (p ∣ (q · r))
  untouched p m = अस्पृष्टम् p q r (fst (सदस्य-सर्वे p S m allS)) दृq दृr
                            (fst (above p m)) (snd (above p m))

------------------------------------------------------------------------
-- §3 · T22.3 — testing all primes with p · p ≤ X suffices for m ≤ X.
------------------------------------------------------------------------

-- a list of firm numbers has a positive product
वध-धनः : (L : List ℕ) → सर्वे दृढम् L → 0 < वधः L
वध-धनः []       _          = ≤-refl
वध-धनः (x ∷ xs) (दृx , rest) = 0<· x (वधः xs) (<-weaken (fst दृx)) (वध-धनः xs rest)

-- a list of two or more firm numbers has an entry whose square is at
-- most the product: compare the head p with the rest b = q · ∏R.  If
-- p ≤ b then p · p ≤ p · b; if b < p then q ≤ b < p gives q · q ≤ p · b.
वर्ग-सीमा : (p q : ℕ) (R : List ℕ) → सर्वे दृढम् (p ∷ q ∷ R)
         → Σ[ d ∈ ℕ ] दृढम् d × (d ∣ वधः (p ∷ q ∷ R)) × (d · d ≤ वधः (p ∷ q ∷ R))
वर्ग-सीमा p q R (दृp , दृq , दृR) with splitℕ-≤ p b
  where b = q · वधः R
... | inl p≤b = p , दृp , ∣-left (q · वधः R)
              , subst2 _≤_ refl (·-comm (q · वधः R) p) (≤-·k {p} {q · वधः R} {p} p≤b)
... | inr b<p = q , दृq
              , ∣-trans (∣-left (वधः R)) (∣-right p)
              , ≤-trans (subst2 _≤_ refl (·-comm (q · वधः R) q) (≤-·k {q} {q · वधः R} {q} q≤b))
                        (≤-·k {q} {p} {q · वधः R} (≤-trans q≤b (<-weaken b<p)))
  where
  q≤b : q ≤ q · वधः R
  q≤b = subst2 _≤_ (·-identityˡ q) (·-comm (वधः R) q)
                   (≤-·k {1} {वधः R} {q} (वध-धनः R दृR))

-- the contrapositive form: a composite m ≤ X has a prime divisor whose
-- square is at most X (indeed at most m).
T22-3-भाजकः : (X m : ℕ) → 0 < m → m ≤ X → ¬ (m ≡ 1) → ¬ दृढम् m
            → Σ[ p ∈ ℕ ] दृढम् p × (p · p ≤ X) × (p ∣ m)
T22-3-भाजकः X m 0<m m≤X m≢1 ¬दृm = go (fst (विभाजनम् m 0<m)) (fst (snd (विभाजनम् m 0<m))) (snd (snd (विभाजनम् m 0<m)))
  where
  go : (L : List ℕ) → सर्वे दृढम् L → वधः L ≡ m
     → Σ[ p ∈ ℕ ] दृढम् p × (p · p ≤ X) × (p ∣ m)
  go []          _          e = ⊥-rec (m≢1 (sym e))
  go (p ∷ [])    (दृp , _)  e = ⊥-rec (¬दृm (subst दृढम् (sym (·-identityʳ p) ∙ e) दृp))
  go (p ∷ q ∷ R) all        e =
    let (d , दृd , d∣L , dd≤L) = वर्ग-सीमा p q R all
    in d , दृd , ≤-trans (subst (d · d ≤_) e dd≤L) m≤X , subst (d ∣_) e d∣L

-- T22.3 as stated: no prime p with p · p ≤ X divides m  ⇒  m ≡ 1 or m prime.
T22-3 : (X m : ℕ) → 0 < m → m ≤ X
      → ((p : ℕ) → दृढम् p → p · p ≤ X → ¬ (p ∣ m))
      → (m ≡ 1) ⊎ दृढम् m
T22-3 X m 0<m m≤X noSmall = go (fst (विभाजनम् m 0<m)) (fst (snd (विभाजनम् m 0<m))) (snd (snd (विभाजनम् m 0<m)))
  where
  go : (L : List ℕ) → सर्वे दृढम् L → वधः L ≡ m → (m ≡ 1) ⊎ दृढम् m
  go []          _          e = inl (sym e)
  go (p ∷ [])    (दृp , _)  e = inr (subst दृढम् (sym (·-identityʳ p) ∙ e) दृp)
  go (p ∷ q ∷ R) all        e =
    let (d , दृd , d∣L , dd≤L) = वर्ग-सीमा p q R all
    in ⊥-rec (noSmall d दृd (≤-trans (subst (d · d ≤_) e dd≤L) m≤X) (subst (d ∣_) e d∣L))

------------------------------------------------------------------------
-- §4 · T22.4 — the separator forcing the square-root threshold.
------------------------------------------------------------------------

-- the "primes ≤ z" observer reads a and b alike
पाठः≤ : ℕ → ℕ → ℕ → Type₀
पाठः≤ z a b = (p : ℕ) → दृढम् p → p ≤ z → (p ∣ a) ↔ (p ∣ b)

T22-4 : (z X r s : ℕ) → दृढम् r → दृढम् s → z < r → z < s → r · s ≤ X
      → ((1 ≤ r) × (r ≤ X)) × ((1 ≤ r · s) × (r · s ≤ X))   -- both in [1, X]
      × दृढम् r × (¬ दृढम् (r · s))                        -- one prime, one not
      × ((p : ℕ) → दृढम् p → p ≤ z → ¬ (p ∣ r))             -- observer: no
      × ((p : ℕ) → दृढम् p → p ≤ z → ¬ (p ∣ (r · s)))         -- observer: no
      × पाठः≤ z r (r · s)                                   -- same reading
T22-4 z X r s दृr दृs z<r z<s₁ rs≤X =
    (<-weaken (fst दृr) , ≤-trans r≤rs rs≤X)
  , (0<· r s 0<r 0<s , rs≤X)
  , दृr , ¬prime-product r s (fst दृr) (fst दृs)
  , noR , noRS
  , (λ p दृp p≤z → (λ p∣r → ⊥-rec (noR p दृp p≤z p∣r)) , (λ p∣rs → ⊥-rec (noRS p दृp p≤z p∣rs)))
  where
  0<r : 0 < r
  0<r = <-weaken (fst दृr)
  0<s : 0 < s
  0<s = <-weaken (fst दृs)
  r≤rs : r ≤ r · s
  r≤rs = subst2 _≤_ (·-identityˡ r) (·-comm s r) (≤-·k {1} {s} {r} 0<s)
  noR : (p : ℕ) → दृढम् p → p ≤ z → ¬ (p ∣ r)
  noR p दृp p≤z = अल्पः-न-भजति p r (fst दृp) दृr (≤<-trans p≤z z<r)
  noRS : (p : ℕ) → दृढम् p → p ≤ z → ¬ (p ∣ (r · s))
  noRS p दृp p≤z = अस्पृष्टम् p r s (fst दृp) दृr दृs (≤<-trans p≤z z<r) (≤<-trans p≤z z<s₁)

-- consequence: no property that depends on n only through the
-- "primes ≤ z" readings coincides with primality on [1, X].
T22-4-अनिर्णयः : (z X r s : ℕ) → दृढम् r → दृढम् s → z < r → z < s → r · s ≤ X
              → (Φ : ℕ → Type₀)
              → ((a b : ℕ) → पाठः≤ z a b → Φ a ↔ Φ b)
              → ¬ ((n : ℕ) → 1 ≤ n → n ≤ X → Φ n ↔ दृढम् n)
T22-4-अनिर्णयः z X r s दृr दृs z<r z<s₁ rs≤X Φ factors decides =
  ¬दृrs (fst (decides (r · s) (fst inRS) (snd inRS))
             (fst (factors r (r · s) alike)
                  (snd (decides r (fst inR) (snd inR)) दृr)))
  where
  T = T22-4 z X r s दृr दृs z<r z<s₁ rs≤X
  inR   = fst T
  inRS  = fst (snd T)
  ¬दृrs : ¬ दृढम् (r · s)
  ¬दृrs = fst (snd (snd (snd T)))
  alike : पाठः≤ z r (r · s)
  alike = snd (snd (snd (snd (snd (snd T)))))

------------------------------------------------------------------------
-- §5 · सर्वत्र — no fixed finite local-divisibility observer decides
--     unbounded primality.  S is ANY finite list of moduli.
------------------------------------------------------------------------

-- the S-observer reads a and b alike
पाठः : List ℕ → ℕ → ℕ → Type₀
पाठः S a b = (d : ℕ) → d सदस्यः S → (d ∣ a) ↔ (d ∣ b)

-- the separator for S: a prime and a non-prime the S-observer cannot tell apart
सर्वत्र-विभेदकः : (S : List ℕ)
              → Σ[ q ∈ ℕ ] Σ[ r ∈ ℕ ] दृढम् q × (¬ दृढम् (q · r)) × पाठः S q (q · r)
सर्वत्र-विभेदकः S = q , r , दृq , ¬prime-product q r (fst दृq) (fst दृr)
                  , λ d m → समान-पाठः d q r दृq दृr (fst (above d m)) (snd (above d m))
  where
  W = द्वौ-बहिः S
  q = fst W
  r = fst (snd W)
  दृq : दृढम् q
  दृq = fst (snd (snd W))
  दृr : दृढम् r
  दृr = fst (snd (snd (snd W)))
  above : (d : ℕ) → d सदस्यः S → (d < q) × (d < r)
  above = snd (snd (snd (snd (snd W))))

T22-सर्वत्र : (S : List ℕ) (Φ : ℕ → Type₀)
           → ((a b : ℕ) → पाठः S a b → Φ a ↔ Φ b)
           → ¬ ((n : ℕ) → Φ n ↔ दृढम् n)
T22-सर्वत्र S Φ factors decides =
  ¬दृqr (fst (decides (q · r)) (fst (factors q (q · r) alike) (snd (decides q) दृq)))
  where
  W = सर्वत्र-विभेदकः S
  q = fst W
  r = fst (snd W)
  दृq : दृढम् q
  दृq = fst (snd (snd W))
  ¬दृqr : ¬ दृढम् (q · r)
  ¬दृqr = fst (snd (snd (snd W)))
  alike : पाठः S q (q · r)
  alike = snd (snd (snd (snd W)))

------------------------------------------------------------------------
-- §6 · T22.5 — centre, product, gap are Vieta coordinates of the pair.
------------------------------------------------------------------------

module वियता where
  open CommRingStr (ℤCommRing .snd)
    renaming (_+_ to _+ᶻ_ ; _·_ to _·ᶻ_ ; -_ to -ᶻ_)

  २ : ℤ
  २ = 1r +ᶻ 1r

  -- the monic quadratic with roots w − r and w + r
  F : ℤ → ℤ → ℤ → ℤ
  F w r x = (x +ᶻ (-ᶻ (w +ᶻ (-ᶻ r)))) ·ᶻ (x +ᶻ (-ᶻ (w +ᶻ r)))

  -- e₁ = 2w : the root sum is twice the centre
  e₁ : (w r : ℤ) → (w +ᶻ (-ᶻ r)) +ᶻ (w +ᶻ r) ≡ २ ·ᶻ w
  e₁ w r = solve! ℤCommRing

  -- e₂ = w² − r² : the root product
  e₂ : (w r : ℤ) → (w +ᶻ (-ᶻ r)) ·ᶻ (w +ᶻ r) ≡ (w ·ᶻ w) +ᶻ (-ᶻ (r ·ᶻ r))
  e₂ w r = solve! ℤCommRing

  -- gap = 2r
  gap : (w r : ℤ) → (w +ᶻ r) +ᶻ (-ᶻ (w +ᶻ (-ᶻ r))) ≡ २ ·ᶻ r
  gap w r = solve! ℤCommRing

  -- F(X) = X² − 2wX + (w² − r²)
  expand : (w r x : ℤ)
         → F w r x ≡ (x ·ᶻ x) +ᶻ (-ᶻ ((२ ·ᶻ w) ·ᶻ x)) +ᶻ ((w ·ᶻ w) +ᶻ (-ᶻ (r ·ᶻ r)))
  expand w r x = solve! ℤCommRing

  -- disc = e₁² − 4 e₂ = 4 r²
  disc : (w r : ℤ)
       → ((२ ·ᶻ w) ·ᶻ (२ ·ᶻ w)) +ᶻ (-ᶻ ((२ ·ᶻ २) ·ᶻ ((w ·ᶻ w) +ᶻ (-ᶻ (r ·ᶻ r)))))
         ≡ (२ ·ᶻ २) ·ᶻ (r ·ᶻ r)
  disc w r = solve! ℤCommRing

  -- and the discriminant is the square of the gap
  disc-is-gap² : (w r : ℤ) → (२ ·ᶻ २) ·ᶻ (r ·ᶻ r) ≡ (२ ·ᶻ r) ·ᶻ (२ ·ᶻ r)
  disc-is-gap² w r = solve! ℤCommRing

  -- both members of the pair are roots
  root₁ : (w r : ℤ) → F w r (w +ᶻ (-ᶻ r)) ≡ 0r
  root₁ w r = solve! ℤCommRing

  root₂ : (w r : ℤ) → F w r (w +ᶻ r) ≡ 0r
  root₂ w r = solve! ℤCommRing

-- EkaBija's chart over ℕ: the pair at centre w and radius r ≤ w is
-- (w ∸ r , w + r).  Its Vieta reading in ℕ: with the witness k of
-- r ≤ w (so w = k + r), the truncated subtraction is exact and the three
-- identities are semiring identities in k and r.
module एकबीज-वियता where
  केन्द्रम् : (w r : ℕ) → r ≤ w → (w ∸ r) + (w + r) ≡ 2 · w
  केन्द्रम् w r (k , e) =
    subst (λ w → (w ∸ r) + (w + r) ≡ 2 · w) e
          (cong (_+ (k + r + r)) (+∸ k r) ∙ समीकरणम्)
    where
    समीकरणम् : k + (k + r + r) ≡ 2 · (k + r)
    समीकरणम् = solveℕ!

  वधः-चक्रम् : (w r : ℕ) → r ≤ w → (w ∸ r) · (w + r) + r · r ≡ w · w
  वधः-चक्रम् w r (k , e) =
    subst (λ w → (w ∸ r) · (w + r) + r · r ≡ w · w) e
          (cong (λ z → z · (k + r + r) + r · r) (+∸ k r) ∙ समीकरणम्)
    where
    समीकरणम् : k · (k + r + r) + r · r ≡ (k + r) · (k + r)
    समीकरणम् = solveℕ!

  अन्तरम् : (w r : ℕ) → r ≤ w → (w + r) ∸ (w ∸ r) ≡ 2 · r
  अन्तरम् w r (k , e) =
    subst (λ w → (w + r) ∸ (w ∸ r) ≡ 2 · r) e
          (cong ((k + r + r) ∸_) (+∸ k r) ∙ cong (_∸ k) समीकरणम् ∙ ∸+ (2 · r) k)
    where
    समीकरणम् : k + r + r ≡ k + 2 · r
    समीकरणम् = solveℕ!
