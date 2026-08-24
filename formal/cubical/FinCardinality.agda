-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

{-
  FinCardinality — a counting layer: cardinality transported along equivalences,
  the pigeonhole principle in its useful direction, and the Chinese remainder
  theorem as an *equivalence* of finite types, with the multiplicativity of a
  counting function read off from it.

  PRIOR ART, and what is and is not claimed here.

    * `card`, its invariance `cardEquiv : ∥ X ≃ Y ∥₁ → card X ≡ card Y`, the
      sums/products `sum`, `prod`, `cardΣ`, `cardΠ`, `card+`, `card×`, and the
      pigeonhole principle in the direction "too many elements ⇒ a repeat"
      ALL ALREADY EXIST in cubical v0.9 (`Cubical.Data.FinSet.Cardinality`).
      They are imported, not re-proved.  So does the transport of a count along
      an equivalence *inside this repository*:
      `NaturalMachine/FiniteEquivalenceBridge.agda` (`X ≃ Y → card X ≡ card Y`)
      and `NaturalMachine/Decategorification.agda` (`card-invariant`,
      `card≡MereEq`).  A `Fin`-cardinality layer transporting counts along an
      equivalence therefore did NOT need building: it was already here twice.
    * What is genuinely absent, verified by reading
      `Cubical/Data/FinSet/Cardinality.agda` in full: the CONVERSE counting
      principle — *an injection between finite sets of equal cardinality is an
      equivalence*.  The library has `card↪Inequality'`, `card↠Inequality'`
      and `pigeonHole`, but nothing turning an injection into an equivalence.
      That is `injSameCard→isEquiv` (§2), with the sum lemma `sum-pointwise`
      (§1) it rests on.  Neither has a counterpart in `formal/`.
    * Cubical v0.9 has NO Chinese remainder theorem of any form
      (`grep -ril chinese` over the v0.9 tree is empty; re-verified today, and
      `formal/` has none either — `Gamma0Index.agda`'s `crtGL12`, `crtΓ12`,
      `crtGL10`, `crtΓ10` are four `refl`s on closed numbers).  `crtEquiv` (§4)
      is that theorem, in the form a count can be transported along, and
      `countMul` (§5) is the multiplicativity those four `refl`s instantiate.

  The mathematics is entirely classical (CRT; "an injective map between finite
  sets of the same size is bijective"); see the HoTT book's finite-set chapter,
  the cubical library's own `FinSet` development, and Agda-unimath's
  finite-type library.  What is claimed is the certificate under this pin, and
  that it is the layer the Γ₀(N)-index lane was blocked on.

  Hypotheses are arguments, never comments.  §6 gives five controls, three of
  them NEGATIONS: the order hypothesis of `split+`, the coprimality hypothesis
  of `crtEquiv` and the equal-cardinality hypothesis of `injSameCard→isEquiv`
  are each shown FALSIFYING when dropped.
-}

module FinCardinality where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels

open import Cubical.Functions.Embedding
open import Cubical.Functions.Surjection

open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty
open import Cubical.Data.Sum

open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD

open import Cubical.Data.Fin
open import Cubical.Data.Fin.Properties
import Cubical.Data.SumFin as SFin

open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors
open import Cubical.Data.FinSet.Cardinality
open import Cubical.Data.FinSet.Induction renaming (_+_ to _+F_)

open import Cubical.Relation.Nullary
open import Cubical.HITs.PropositionalTruncation as Prop

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1. A sum lemma: pointwise ≤ with equal sums forces pointwise equality
------------------------------------------------------------------------

-- The arithmetic core, isolated so the hypotheses are visible.
split+ : {a b A B : ℕ} → a ≤ b → A ≤ B → a + A ≡ b + B → (a ≡ b) × (A ≡ B)
split+ {a = a} {b = b} {A = A} {B = B} (p , hp) (q , hq) e = ea , eA
  where
    step : (p + q) + (a + A) ≡ a + A
    step = (λ i → +-assoc p q (a + A) (~ i))
         ∙ (λ i → p + (+-assoc q a A i))
         ∙ (λ i → p + (+-comm q a i + A))
         ∙ (λ i → p + (+-assoc a q A (~ i)))
         ∙ (+-assoc p a (q + A))
         ∙ (λ i → hp i + hq i)
         ∙ sym e

    pq≡0 : p + q ≡ 0
    pq≡0 = m+n≡n→m≡0 step

    p≡0 : p ≡ 0
    p≡0 = m+n≡0→m≡0×n≡0 pq≡0 .fst

    q≡0 : q ≡ 0
    q≡0 = m+n≡0→m≡0×n≡0 pq≡0 .snd

    ea : a ≡ b
    ea = sym (cong (_+ a) p≡0) ∙ hp

    eA : A ≡ B
    eA = sym (cong (_+ A) q≡0) ∙ hq

sum-pointwise𝔽in : (n : ℕ) (g h : 𝔽in {ℓ} n .fst → ℕ)
  → ((x : 𝔽in {ℓ} n .fst) → g x ≤ h x)
  → sum (𝔽in n) g ≡ sum (𝔽in n) h
  → (x : 𝔽in {ℓ} n .fst) → g x ≡ h x
sum-pointwise𝔽in 0 g h le e x = Empty.rec* x
sum-pointwise𝔽in {ℓ = ℓ} (suc n) g h le e = goal
  where
    q : g (inl tt*) + sum (𝔽in {ℓ} n) (g ∘ inr)
      ≡ h (inl tt*) + sum (𝔽in {ℓ} n) (h ∘ inr)
    q = sym (sum𝔽in1+n n g) ∙ e ∙ sum𝔽in1+n n h

    tails : sum (𝔽in {ℓ} n) (g ∘ inr) ≤ sum (𝔽in {ℓ} n) (h ∘ inr)
    tails = sum≤ (𝔽in n) (g ∘ inr) (h ∘ inr) (le ∘ inr)

    both : (g (inl tt*) ≡ h (inl tt*))
         × (sum (𝔽in {ℓ} n) (g ∘ inr) ≡ sum (𝔽in {ℓ} n) (h ∘ inr))
    both = split+ (le (inl tt*)) tails q

    goal : (x : 𝔽in {ℓ} (suc n) .fst) → g x ≡ h x
    goal (inl tt*) = both .fst
    goal (inr y) = sum-pointwise𝔽in n (g ∘ inr) (h ∘ inr) (le ∘ inr) (both .snd) y

-- Pointwise ≤ plus equal sums forces pointwise equality, on any finite set.
sum-pointwise : (X : FinSet ℓ) (g h : X .fst → ℕ)
  → ((x : X .fst) → g x ≤ h x)
  → sum X g ≡ sum X h
  → (x : X .fst) → g x ≡ h x
sum-pointwise {ℓ = ℓ} =
  elimProp
    (λ X → (g h : X .fst → ℕ) → ((x : X .fst) → g x ≤ h x)
         → sum X g ≡ sum X h → (x : X .fst) → g x ≡ h x)
    (λ X → isPropΠ2 (λ _ _ → isPropΠ2 (λ _ _ → isPropΠ (λ _ → isSetℕ _ _))))
    (λ n → sum-pointwise𝔽in {ℓ = ℓ} n)

------------------------------------------------------------------------
-- 2. The counting principle: an injection with equal cardinality is an
--    equivalence.  This is what cubical v0.9 lacks.
------------------------------------------------------------------------

module _
  (X : FinSet ℓ) (Y : FinSet ℓ')
  (f : X .fst → Y .fst)
  (inj : (x x' : X .fst) → f x ≡ f x' → x ≡ x')
  where

  private
    emb : isEmbedding f
    emb = injEmbedding (isFinSet→isSet (Y .snd)) (λ {x} {x'} → inj x x')

    fibCard : Y .fst → ℕ
    fibCard y = card (fiber f y , isFinSetFiber X Y f y)

    fib≤1 : (y : Y .fst) → fibCard y ≤ 1
    fib≤1 y = isProp→card≤1 (fiber f y , isFinSetFiber X Y f y)
                            (isEmbedding→hasPropFibers emb y)

  module _ (same : card X ≡ card Y) where

    private
      sums : sum Y fibCard ≡ sum Y (λ _ → 1)
      sums = sym (sumCardFiber X Y f) ∙ same
           ∙ sym (·-identityˡ (card Y))
           ∙ sym (sumConst Y (λ _ → 1) 1 (λ _ → refl))

      fib≡1 : (y : Y .fst) → fibCard y ≡ 1
      fib≡1 = sum-pointwise Y fibCard (λ _ → 1) fib≤1 sums

    injSameCard→isSurjection : isSurjection f
    injSameCard→isSurjection y =
      ∣ card≡1→isContr {X = fiber f y , isFinSetFiber X Y f y} (fib≡1 y) .fst ∣₁

    injSameCard→isEquiv : isEquiv f
    injSameCard→isEquiv =
      isEmbedding×isSurjection→isEquiv (emb , injSameCard→isSurjection)

    injSameCard→Equiv : X .fst ≃ Y .fst
    injSameCard→Equiv = f , injSameCard→isEquiv

------------------------------------------------------------------------
-- 3. Number theory for CRT: congruence, divisibility, Gauss
------------------------------------------------------------------------

-- x mod k ≡ 0 gives k ∣ x.
-- (Stated only for a positive modulus: `x mod 0` is defined to be 0 in this
-- library, so the statement is FALSE at k = 0 unless x ≡ 0.  The positivity is
-- an argument, not a comment.)
mod0→∣ : (k x : ℕ) → x mod (suc k) ≡ 0 → suc k ∣ x
mod0→∣ k x p =
  ∣-trans (∣-left (quotient x / suc k))
          (∣-refl (sym (cong (_+ (suc k · (quotient x / suc k))) p)
                 ∙ ≡remainder+quotient (suc k) x))

-- If r < k and s < k and s ≡ (r + s) mod k, then r ≡ 0.
private
  shift-fix : (k r s : ℕ) → r < suc k → s < suc k
    → s ≡ (r + s) mod (suc k) → r ≡ 0
  shift-fix k r s r< s< e with splitℕ-≤ (suc k) (r + s)
  ... | inl (t , ht) = Empty.rec (<→≢ t<s (sym e'))
    where
      rs< : r + s < suc k + suc k
      rs< = <-+-< r< s<

      t< : t < suc k
      t< = ≤-+k-cancel {k = suc k} (subst (λ z → suc z ≤ suc k + suc k) (sym ht) rs<)

      modt : (r + s) mod (suc k) ≡ t
      modt = cong (_mod (suc k)) (sym ht) ∙ sym (mod-rUnit (suc k) t)
           ∙ modIndBase k t t<

      e' : s ≡ t
      e' = e ∙ modt

      t<s : t < s
      t<s = ≤-+k-cancel {k = suc k}
              (subst (λ z → suc z ≤ s + suc k) (sym ht)
                (subst (λ z → r + s < z) (+-comm (suc k) s) (<-+k r<)))
  ... | inr big = r≡0
    where
      modrs : (r + s) mod (suc k) ≡ r + s
      modrs = modIndBase k (r + s) big

      e' : s ≡ r + s
      e' = e ∙ modrs

      r≡0 : r ≡ 0
      r≡0 = m+n≡n→m≡0 (sym e')

-- Equal residues at a positive modulus force the modulus to divide the shift.
cong-shift→∣ : (k d x : ℕ) → x mod (suc k) ≡ (d + x) mod (suc k) → suc k ∣ d
cong-shift→∣ k d x e =
  mod0→∣ k d
    (shift-fix k (d mod suc k) (x mod suc k) (mod< k d) (mod< k x)
      (e ∙ mod-lCancel (suc k) d x ∙ mod-rCancel (suc k) (d mod suc k) x))

-- Gauss: coprime divisors of the same number have divisible product.
gauss : (m n d : ℕ) → isGCD m n 1 → m ∣ d → n ∣ d → (m · n) ∣ d
gauss m n d cop m∣d n∣d = ∣-trans (∣-left b) (∣-refl mnb≡d)
  where
    a : ℕ
    a = ∣-untrunc m∣d .fst

    ha : a · m ≡ d
    ha = ∣-untrunc m∣d .snd

    n∣ma : n ∣ (m · a)
    n∣ma = subst (n ∣_) (sym (·-comm m a ∙ ha)) n∣d

    n∣gcd : n ∣ gcd (m · a) (n · a)
    n∣gcd = gcdIsGCD (m · a) (n · a) .snd n (n∣ma , ∣-left a)

    gcd≡a : gcd (m · a) (n · a) ≡ a
    gcd≡a = gcd-factorʳ m n a ∙ cong (_· a) (isGCD→gcd≡ cop) ∙ ·-identityˡ a

    n∣a : n ∣ a
    n∣a = subst (n ∣_) gcd≡a n∣gcd

    b : ℕ
    b = ∣-untrunc n∣a .fst

    hb : b · n ≡ a
    hb = ∣-untrunc n∣a .snd

    mnb≡d : (m · n) · b ≡ d
    mnb≡d = sym (·-assoc m n b) ∙ cong (m ·_) (·-comm n b ∙ hb) ∙ ·-comm m a ∙ ha

------------------------------------------------------------------------
-- 4. The Chinese remainder theorem as an equivalence of finite types
------------------------------------------------------------------------

-- The residue-pair map.  Both moduli are positive by construction.
resPair : (m n : ℕ) → Fin (suc m · suc n) → Fin (suc m) × Fin (suc n)
resPair m n (x , _) = (x mod suc m , mod< m x) , (x mod suc n , mod< n x)

private
  crt-inj-≤ : (m n : ℕ) → isGCD (suc m) (suc n) 1
    → (x y : ℕ) → y < suc m · suc n → x ≤ y
    → x mod suc m ≡ y mod suc m → x mod suc n ≡ y mod suc n → x ≡ y
  crt-inj-≤ m n cop x y y< (d , hd) em en with discreteℕ d 0
  ... | yes d≡0 = sym (cong (_+ x) d≡0) ∙ hd
  ... | no d≢0 = Empty.rec (<-asym d< (m∣n→m≤n d≢0 N∣d))
    where
      em' : x mod suc m ≡ (d + x) mod suc m
      em' = em ∙ cong (_mod suc m) (sym hd)

      en' : x mod suc n ≡ (d + x) mod suc n
      en' = en ∙ cong (_mod suc n) (sym hd)

      N∣d : (suc m · suc n) ∣ d
      N∣d = gauss (suc m) (suc n) d cop
              (cong-shift→∣ m d x em') (cong-shift→∣ n d x en')

      d< : d < suc m · suc n
      d< = ≤<-trans (subst (d ≤_) hd ≤SumLeft) y<

-- Injectivity of the residue-pair map: this is the Chinese remainder theorem.
crtInj : (m n : ℕ) → isGCD (suc m) (suc n) 1
  → (x y : Fin (suc m · suc n)) → resPair m n x ≡ resPair m n y → x ≡ y
crtInj m n cop (x , x<) (y , y<) e = Fin-fst-≡ (main (splitℕ-≤ x y))
  where
    em : x mod suc m ≡ y mod suc m
    em = cong (λ z → z .fst .fst) e

    en : x mod suc n ≡ y mod suc n
    en = cong (λ z → z .snd .fst) e

    main : (x ≤ y) ⊎ (y < x) → x ≡ y
    main (inl p) = crt-inj-≤ m n cop x y y< p em en
    main (inr p) = sym (crt-inj-≤ m n cop y x x< (<-weaken p) (sym em) (sym en))

-- `Fin n` as a finite set, with `card (FinSetFin n) ≡ n` definitionally.
FinSetFin : (n : ℕ) → FinSet ℓ-zero
FinSetFin n = Fin n , n , ∣ invEquiv (SFin.SumFin≃Fin n) ∣₁

cardFinSetFin : (n : ℕ) → card (FinSetFin n) ≡ n
cardFinSetFin n = refl

-- The Chinese remainder theorem, in the form a count transports along:
-- for coprime moduli the residue-pair map is an EQUIVALENCE, not merely an
-- injection.  Surjectivity is not proved by hand: it is the counting principle
-- of §2 applied to the (definitional) equality of cardinalities.
crtEquiv : (m n : ℕ) → isGCD (suc m) (suc n) 1
  → Fin (suc m · suc n) ≃ (Fin (suc m) × Fin (suc n))
crtEquiv m n cop =
  injSameCard→Equiv
    (FinSetFin (suc m · suc n))
    (_ , isFinSet× (FinSetFin (suc m)) (FinSetFin (suc n)))
    (resPair m n) (crtInj m n cop) refl

------------------------------------------------------------------------
-- 5. The payoff: multiplicativity of a counting function along CRT
------------------------------------------------------------------------

-- A "counting function" on Fin (m·n) given by independent finite data at each
-- of the two coprime moduli.  For P, Q propositional this is exactly
-- #{x < mn : P(x mod m) and Q(x mod n)} = #P · #Q, the shape of the
-- multiplicativity step (Lemma 3.2) in the Γ₀(N) index argument.
module _ (m n : ℕ) (cop : isGCD (suc m) (suc n) 1)
  (P : Fin (suc m) → FinSet ℓ-zero) (Q : Fin (suc n) → FinSet ℓ-zero) where

  private
    W : Fin (suc m) × Fin (suc n) → FinSet ℓ-zero
    W ab = (P (ab .fst) .fst × Q (ab .snd) .fst) , isFinSet× (P (ab .fst)) (Q (ab .snd))

  CountedFam : Fin (suc m · suc n) → FinSet ℓ-zero
  CountedFam x = W (resPair m n x)

  Counted : FinSet ℓ-zero
  Counted = _ , isFinSetΣ (FinSetFin (suc m · suc n)) CountedFam

  ΣP : FinSet ℓ-zero
  ΣP = _ , isFinSetΣ (FinSetFin (suc m)) P

  ΣQ : FinSet ℓ-zero
  ΣQ = _ , isFinSetΣ (FinSetFin (suc n)) Q

  private
    step1 : Counted .fst ≃ Σ (Fin (suc m) × Fin (suc n)) (λ ab → W ab .fst)
    step1 = Σ-cong-equiv (crtEquiv m n cop) (λ _ → idEquiv _)

    shuffle : Iso (Σ (Fin (suc m) × Fin (suc n)) (λ ab → W ab .fst))
                  (ΣP .fst × ΣQ .fst)
    Iso.fun shuffle ((a , b) , (p , q)) = (a , p) , (b , q)
    Iso.inv shuffle ((a , p) , (b , q)) = (a , b) , (p , q)
    Iso.rightInv shuffle _ = refl
    Iso.leftInv shuffle _ = refl

  countMul : card Counted ≡ card ΣP · card ΣQ
  countMul =
      cardEquiv Counted (_ , isFinSet× ΣP ΣQ)
        ∣ compEquiv step1 (isoToEquiv shuffle) ∣₁
    ∙ card× ΣP ΣQ

------------------------------------------------------------------------
-- 6. Controls.  Three of the five are NEGATIONS: they prove the statement
--    FALSE where its hypothesis fails, which is stronger than exhibiting a
--    non-trivial instance where it holds.
------------------------------------------------------------------------

-- (a) `split+` needs BOTH order hypotheses: dropping `A ≤ B` falsifies it.
--     Witness a = 0, b = 1, A = 2, B = 1.
control-split+-needs-A≤B :
  ¬ ({a b A B : ℕ} → a ≤ b → a + A ≡ b + B → a ≡ b)
control-split+-needs-A≤B h = znots (h {0} {1} {2} {1} (1 , refl) refl)

-- (b) The moduli 2 and 2 are not coprime — the hypothesis of `crtEquiv`
--     genuinely fails there.
control-2-2-not-coprime : ¬ isGCD 2 2 1
control-2-2-not-coprime cop =
  ¬m<m (≤<-trans (m∣n→m≤n snotz (cop .snd 2 (∣-refl refl , ∣-refl refl)))
                 (0 , refl))

-- (c) …and there the residue-pair map is NOT injective, so `crtEquiv` is false
--     without coprimality: 0 and 2 in Fin 4 have the same pair of residues.
control-crt-needs-coprime :
  ¬ ((x y : Fin (2 · 2)) → resPair 1 1 x ≡ resPair 1 1 y → x ≡ y)
control-crt-needs-coprime h = znots (cong fst (h (0 , 0<4) (2 , 2<4) same))
  where
    0<4 : 0 < 2 · 2
    0<4 = 3 , refl

    2<4 : 2 < 2 · 2
    2<4 = 1 , refl

    e : 0 mod 2 ≡ 2 mod 2
    e = modIndBase 1 0 (1 , refl) ∙ sym (zero-charac 2)

    c : Path (Fin 2) (0 mod 2 , mod< 1 0) (2 mod 2 , mod< 1 2)
    c = Fin-fst-≡ e

    same : resPair 1 1 (0 , 0<4) ≡ resPair 1 1 (2 , 2<4)
    same i = c i , c i

-- (d) The counting principle needs the cardinalities to agree: the injection
--     Fin 1 → Fin 2 is injective and is NOT an equivalence.
control-injSameCard-needs-sameCard :
  Σ[ f ∈ (Fin 1 → Fin 2) ] ((x y : Fin 1) → f x ≡ f y → x ≡ y) × (¬ isEquiv f)
control-injSameCard-needs-sameCard = f , inj , noteq
  where
    f : Fin 1 → Fin 2
    f _ = 0 , (1 , refl)

    inj : (x y : Fin 1) → f x ≡ f y → x ≡ y
    inj x y _ = sym (isContrFin1 .snd x) ∙ isContrFin1 .snd y

    noteq : ¬ isEquiv f
    noteq e =
      znots (injSuc (cardEquiv (FinSetFin 1) (FinSetFin 2) ∣ f , e ∣₁))

-- (e) Non-vacuity, positive: the theorem does fire.  2 and 3 are coprime, so
--     Fin 6 ≃ Fin 2 × Fin 3 by the residue-pair map itself.
control-coprime-2-3 : isGCD 2 3 1
control-coprime-2-3 = gcd≡→isGCD refl

control-crt-6 : Fin (2 · 3) ≃ (Fin 2 × Fin 3)
control-crt-6 = crtEquiv 1 2 control-coprime-2-3

-- and the counting function is then multiplicative on the nose.
control-countMul-6 : (P : Fin 2 → FinSet ℓ-zero) (Q : Fin 3 → FinSet ℓ-zero)
  → card (Counted 1 2 control-coprime-2-3 P Q)
  ≡ card (ΣP 1 2 control-coprime-2-3 P Q) · card (ΣQ 1 2 control-coprime-2-3 P Q)
control-countMul-6 P Q = countMul 1 2 control-coprime-2-3 P Q
