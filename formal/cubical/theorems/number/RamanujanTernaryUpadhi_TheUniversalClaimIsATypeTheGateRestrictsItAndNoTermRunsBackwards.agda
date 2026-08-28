{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, उपाधि — THE UNIVERSAL CLAIM IS A TYPE, THE GATE RESTRICTS
-- IT, AND NO TERM RUNS BACKWARDS.
--
-- The discipline is Upadhi_TheMertensGate's: separate the universal
-- statement from the finite check as TYPES, give the restriction map,
-- and let the absence of a converse term make the inflation a type
-- error rather than a wording problem.
--
--   `RamanujanAssertion` — his 1916 claim entire, over ALL odd
--     numbers, the eighteen with 2719 included: everything odd and
--     unrepresented is listed, and everything listed is
--     unrepresented.
--
--   `Gate720` — what the kernel has signed (the two theorems of the
--     companion file), as a type; `the-gate-holds` inhabits it.
--
--   `restrict : RamanujanAssertion → Gate720` — the universal claim
--     yields the gate.  There is deliberately no term the other way,
--     because the other way is the error.  The restriction is not
--     trivial: it runs through `rep-decidable-below-720`, a theorem
--     of independent worth — below 720 representation is DECIDED,
--     with the witness or with a proof of absence, by completeness
--     of the finders — and through the arithmetic that keeps 2719
--     out of the bounded window.
--
-- THE ASYMMETRY AGAINST MERTENS, stated where it belongs: for the
-- Mertens gate the defeating condition is PROVED to exist beyond
-- every reachable check, so the finite gate carries no evidence.
-- Here no defeating condition is known, and under GRH none exists;
-- the machine's verdict organs accordingly hold the totality as
-- syād-avaktavyam — one content at two scopes, not formable as a
-- single predication — with the gate itself affirmed.  The extent of
-- the search IS the content of Gate720's type: 720, and not a step
-- further.
------------------------------------------------------------------------

module RamanujanTernaryUpadhi_TheUniversalClaimIsATypeTheGateRestrictsItAndNoTermRunsBackwards where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; <≤-trans ; splitℕ-≤ ; ≤-antisym ;
         <-split ; ≤SumLeft ; ≤SumRight)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (eq?-complete ; loop ; loop-sound ; ≤-k·)
open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict
open import RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList
  using (listed-not-represented ; xy-bound ; z-bound)

------------------------------------------------------------------------
-- §1  The eighteen, and the universal claim as a type.
------------------------------------------------------------------------

Odd : ℕ → Type
Odd n = Σ ℕ (λ m → n ≡ suc (2 · m))

exc18 : ℕ → ℕ
exc18 0 = 3 ; exc18 1 = 7 ; exc18 2 = 21 ; exc18 3 = 31 ; exc18 4 = 33
exc18 5 = 43 ; exc18 6 = 67 ; exc18 7 = 79 ; exc18 8 = 87 ; exc18 9 = 133
exc18 10 = 217 ; exc18 11 = 219 ; exc18 12 = 223 ; exc18 13 = 253
exc18 14 = 307 ; exc18 15 = 391 ; exc18 16 = 679 ; exc18 17 = 2719
exc18 _ = 0

In18 : ℕ → Type
In18 n = Σ ℕ (λ i → (i ≤ 17) × (n ≡ exc18 i))

-- Ramanujan's assertion, entire.
RamanujanAssertion : Type
RamanujanAssertion =
  ((n : ℕ) → Odd n → (¬ Rep n) → In18 n)
  × ((i : ℕ) → i ≤ 17 → ¬ Rep (exc18 i))

-- The kernel-signed gate, as a type; the companion file inhabits it.
Gate720 : Type
Gate720 =
  ((m : ℕ) → m ≤ 359 → In17 (suc (2 · m)) ⊎ Rep (suc (2 · m)))
  × ((i : ℕ) → i ≤ 16 → (x y z : ℕ) → ¬ Q x y z ≡ exc i)

the-gate-holds : Gate720
the-gate-holds = represented-or-listed , listed-not-represented

------------------------------------------------------------------------
-- §2  The finders are complete: silence below the box means absence.
------------------------------------------------------------------------

findZ-complete : (x y n b : ℕ) → findZ x y n b ≡ nothing →
  (z : ℕ) → z ≤ b → ¬ Q x y z ≡ n
findZ-complete x y n zero h z hz =
  go (<-split (suc-≤-suc hz))
  where
  go : (z < zero) ⊎ (z ≡ zero) → ¬ Q x y z ≡ n
  go (inl z0) = Empty.rec (¬-<-zero z0)
  go (inr z0) hq =
    eq?-complete _ _
      (strip (eq? (Q x y zero) n) refl)
      (subst (λ w → Q x y w ≡ n) z0 hq)
    where
    strip : (w : Maybe (Q x y zero ≡ n)) → eq? (Q x y zero) n ≡ w →
            eq? (Q x y zero) n ≡ nothing
    strip nothing  e = e
    strip (just p) e =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (map-Maybe (λ p' → zero , p')) e) ∙ h)))
findZ-complete x y n (suc b) h z hz =
  go (<-split (suc-≤-suc hz))
  where
  parts : (findZ x y n b ≡ nothing) × (eq? (Q x y (suc b)) n ≡ nothing)
  parts = split (eq? (Q x y (suc b)) n) refl
    where
    split : (w : Maybe (Q x y (suc b) ≡ n)) → eq? (Q x y (suc b)) n ≡ w →
            (findZ x y n b ≡ nothing) × (eq? (Q x y (suc b)) n ≡ nothing)
    split (just p) pw =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (rec (findZ x y n b) (λ p' → just (suc b , p'))) pw)
             ∙ h)))
    split nothing  pw =
      (sym (cong (rec (findZ x y n b) (λ p' → just (suc b , p'))) pw) ∙ h) , pw

  go : (z < suc b) ⊎ (z ≡ suc b) → ¬ Q x y z ≡ n
  go (inl zb) = findZ-complete x y n b (fst parts) z (pred-≤-pred zb)
  go (inr zb) hq =
    eq?-complete _ _ (snd parts) (subst (λ w → Q x y w ≡ n) zb hq)

findY-complete : (x n b : ℕ) → findY x n b ≡ nothing →
  (y : ℕ) → y ≤ b → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
findY-complete x n zero h y hy =
  go (<-split (suc-≤-suc hy))
  where
  inner : findZ x zero n 8 ≡ nothing
  inner = split (findZ x zero n 8) refl
    where
    split : (w : Maybe _) → findZ x zero n 8 ≡ w → findZ x zero n 8 ≡ nothing
    split nothing  e = e
    split (just p) e =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (map-Maybe (λ w' → zero , w')) e) ∙ h)))

  go : (y < zero) ⊎ (y ≡ zero) → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
  go (inl y0) = Empty.rec (¬-<-zero y0)
  go (inr y0) z hz hq =
    findZ-complete x zero n 8 inner z hz
      (subst (λ w → Q x w z ≡ n) y0 hq)
findY-complete x n (suc b) h y hy =
  go (<-split (suc-≤-suc hy))
  where
  parts : (findY x n b ≡ nothing) × (findZ x (suc b) n 8 ≡ nothing)
  parts = split (findZ x (suc b) n 8) refl
    where
    split : (w : Maybe (Σ ℕ (λ z' → Q x (suc b) z' ≡ n))) →
            findZ x (suc b) n 8 ≡ w →
            (findY x n b ≡ nothing) × (findZ x (suc b) n 8 ≡ nothing)
    split (just p) pw =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (rec (findY x n b) (λ w' → just (suc b , w'))) pw)
             ∙ h)))
    split nothing  pw =
      (sym (cong (rec (findY x n b) (λ w' → just (suc b , w'))) pw) ∙ h) , pw

  go : (y < suc b) ⊎ (y ≡ suc b) → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
  go (inl yb) = findY-complete x n b (fst parts) y (pred-≤-pred yb)
  go (inr yb) z hz hq =
    findZ-complete x (suc b) n 8 (snd parts) z hz
      (subst (λ w → Q x w z ≡ n) yb hq)

findX-complete : (n b : ℕ) → findX n b ≡ nothing →
  (x : ℕ) → x ≤ b → (y : ℕ) → y ≤ 26 → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
findX-complete n zero h x hx =
  go (<-split (suc-≤-suc hx))
  where
  inner : findY zero n 26 ≡ nothing
  inner = split (findY zero n 26) refl
    where
    split : (w : Maybe _) → findY zero n 26 ≡ w → findY zero n 26 ≡ nothing
    split nothing  e = e
    split (just p) e =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (map-Maybe (λ w' → zero , w')) e) ∙ h)))

  go : (x < zero) ⊎ (x ≡ zero) →
       (y : ℕ) → y ≤ 26 → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
  go (inl x0) = Empty.rec (¬-<-zero x0)
  go (inr x0) y hy z hz hq =
    findY-complete zero n 26 inner y hy z hz
      (subst (λ w → Q w y z ≡ n) x0 hq)
findX-complete n (suc b) h x hx =
  go (<-split (suc-≤-suc hx))
  where
  parts : (findX n b ≡ nothing) × (findY (suc b) n 26 ≡ nothing)
  parts = split (findY (suc b) n 26) refl
    where
    split : (w : Maybe (Σ ℕ (λ y' → Σ ℕ (λ z' → Q (suc b) y' z' ≡ n)))) →
            findY (suc b) n 26 ≡ w →
            (findX n b ≡ nothing) × (findY (suc b) n 26 ≡ nothing)
    split (just p) pw =
      Empty.rec (¬nothing≡just
        (sym (sym (cong (rec (findX n b) (λ w' → just (suc b , w'))) pw)
             ∙ h)))
    split nothing  pw =
      (sym (cong (rec (findX n b) (λ w' → just (suc b , w'))) pw) ∙ h) , pw

  go : (x < suc b) ⊎ (x ≡ suc b) →
       (y : ℕ) → y ≤ 26 → (z : ℕ) → z ≤ 8 → ¬ Q x y z ≡ n
  go (inl xb) = findX-complete n b (fst parts) x (pred-≤-pred xb)
  go (inr xb) y hy z hz hq =
    findY-complete (suc b) n 26 (snd parts) y hy z hz
      (subst (λ w → Q w y z ≡ n) xb hq)

------------------------------------------------------------------------
-- §3  Representation below 720 is decided, either way with evidence.
------------------------------------------------------------------------

rep-decidable-below-720 : (n : ℕ) → n < 720 → Rep n ⊎ (¬ Rep n)
rep-decidable-below-720 n n< = go (findRep n) refl
  where
  go : (w : Maybe (Rep n)) → findRep n ≡ w → Rep n ⊎ (¬ Rep n)
  go (just w) _  = inl w
  go nothing  pw = inr absent
    where
    absent : ¬ Rep n
    absent (x , y , z , hq) =
      findX-complete n 26 pw
        x (xy-bound x n n< (subst (x · x ≤_) hq
            (≤-trans (≤SumLeft {n = x · x} {k = y · y})
                     (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)}))))
        y (xy-bound y n n< (subst (y · y ≤_) hq
            (≤-trans (≤SumRight {n = y · y} {k = x · x})
                     (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)}))))
        z (z-bound z n n< (subst (10 · (z · z) ≤_) hq
            (≤SumRight {n = 10 · (z · z)} {k = x · x + y · y})))
        hq

------------------------------------------------------------------------
-- §4  Bridging the seventeen to the eighteen.
------------------------------------------------------------------------

exc18-prefix : (i : ℕ) → i ≤ 16 → exc18 i ≡ exc i
exc18-prefix i hi = g (eq? (exc18 i) (exc i)) refl
  where
  leafP : ℕ → Maybe Unit
  leafP j = rec nothing (λ _ → just tt) (eq? (exc18 j) (exc j))

  scanP-ok : loop leafP 16 ≡ just tt
  scanP-ok = refl

  g : (w : Maybe (exc18 i ≡ exc i)) → eq? (exc18 i) (exc i) ≡ w →
      exc18 i ≡ exc i
  g (just p) _  = p
  g nothing  pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec nothing (λ _ → just tt)) pw)
       ∙ loop-sound leafP 16 scanP-ok i hi))

odd-window : (m : ℕ) → m ≤ 359 → suc (2 · m) < 720
odd-window m hm = suc-≤-suc (suc-≤-suc (≤-k· 2 hm))

------------------------------------------------------------------------
-- §5  THE RESTRICTION.  One direction; the other is the error.
------------------------------------------------------------------------

restrict : RamanujanAssertion → Gate720
restrict (complete , sound) = gateA , gateB
  where
  gateB : (i : ℕ) → i ≤ 16 → (x y z : ℕ) → ¬ Q x y z ≡ exc i
  gateB i hi x y z hq =
    sound i (≤-trans hi (1 , refl))
      (x , y , z , hq ∙ sym (exc18-prefix i hi))

  gateA : (m : ℕ) → m ≤ 359 → In17 (suc (2 · m)) ⊎ Rep (suc (2 · m))
  gateA m hm = go (rep-decidable-below-720 n (odd-window m hm))
    where
    n : ℕ
    n = suc (2 · m)

    to17 : In18 n → In17 n
    to17 (i , hi , p) = split (splitℕ-≤ i 16)
      where
      split : (i ≤ 16) ⊎ (16 < i) → In17 n
      split (inl h16) = i , h16 , p ∙ exc18-prefix i h16
      split (inr h17) =
        Empty.rec (¬m<m
          (<≤-trans
            (subst (_< 720) (p ∙ cong exc18 i≡17) (odd-window m hm))
            (1999 , refl)))
        where
        i≡17 : i ≡ 17
        i≡17 = ≤-antisym hi h17

    go : Rep n ⊎ (¬ Rep n) → In17 n ⊎ Rep n
    go (inl r)  = inr r
    go (inr nr) = inl (to17 (complete n (m , refl) nr))
