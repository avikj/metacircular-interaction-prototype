{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेइल-धनत्व — Weil positivity.
--
-- Weil's criterion: RH holds iff the explicit-formula form W(g ⋆ g̃) is
-- nonnegative for every test function g.  TauRupa put the form's finite
-- algebra as a term: on a configuration of n modes with the critical-
-- line reflection τ, the form is the τ-twisted ℓ² form, and a τ-2-cycle
-- carries one positive and one negative square (dvi-cakra).  This file
-- proves the criterion itself at the finite level:
--
--   the τ-form is positive on every vector
--     ⇔  every mode of the configuration is fixed by τ.
--
-- "Fixed by τ" is ρ = 1 − ρ̄, i.e. Re ρ = ½: the mode is on the line.
--
--   §1  TWO-POINT SUPPORT.  A summand supported at two distinct indices
--       sums to the two values (Σᵣ-dvi); 0* = 0 in any *-ring.
--   §2  FIXED CONFIGURATIONS.  If τ fixes every mode below n, the τ-form
--       IS the plain form, and the plain form c ↦ ⟨c,c⟩ is a sum of
--       squares — positive for any notion of positivity closed under
--       squares, sums, and containing 0.
--   §3  A MOVED MODE IS A NEGATIVE VECTOR.  If some mode i < n is moved
--       by the involution τ (τ i ≠ i, τ i < n, τ τ i = i), the vector
--       c = δ_i − δ_{τ i} has τ-form  [c,c] = −(1 + 1).
--   §4  THE CRITERION.  For any positivity predicate that excludes −2:
--       (∀ c → Dhana [c,c])  ⇔  (∀ i < n → τ i ≡ i).
--
-- धनत्व (dhanatva, positivity) is ordinary Sanskrit.
------------------------------------------------------------------------

module WeilDhanatva_TheReflectionFormIsPositiveOnEveryVectorExactlyWhenEveryModeIsFixedByTheReflectionSoFiniteWeilPositivityIsFiniteRH where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; +-suc ; +-zero) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; <-weaken ; <≤-trans ; ¬m<m ; ≤SumLeft ; zero-≤)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

open import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  using (StarRing)
import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  as T

private
  variable
    ℓ ℓd : Level

module _ (S : StarRing ℓ) where
  open StarRing S

  Σᵣ⟨_,_⟩ : ℕ → ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σᵣ⟨ s , m ⟩ f = T.Σᵣ⟨_,_⟩ S s m f

  Σᵣ-zero = T.Σᵣ-zero S
  Vec = T.Vec S
  plain = T.plain S
  τ-rūpa = T.τ-rūpa S

  ----------------------------------------------------------------------
  -- १ · 0* = 0, and the two-point support sum.
  ----------------------------------------------------------------------

  ✶-zero : 0r ✶ ≡ 0r
  ✶-zero = sym (cancel (0r ✶) (cong _✶ (sym (+IdR 0r)) ∙ ✶-add 0r 0r))
    where
    cancel : (z : ⟨ R ⟩) → z ≡ z + z → 0r ≡ z
    cancel z h = sym (+InvR z) ∙ cong (_+ (- z)) h ∙ saṃhāra z
      where
      saṃhāra : (z : ⟨ R ⟩) → (z + z) + (- z) ≡ z
      saṃhāra z = solve! R

  suc-le : (s i : ℕ) → s ≤ i → ¬ (s ≡ i) → suc s ≤ i
  suc-le s i (zero  , e) ne = ⊥-elim (ne e)
  suc-le s i (suc k , e) ne = k , (+-suc k s ∙ e)

  -- one-point support, with the vanishing only demanded inside the range
  Σᵣ-eka′ : (s m i : ℕ) (f : ℕ → ⟨ R ⟩) → s ≤ i → i < s +ℕ m
          → ((k : ℕ) → s ≤ k → ¬ (k ≡ i) → f k ≡ 0r) → Σᵣ⟨ s , m ⟩ f ≡ f i
  Σᵣ-eka′ s zero    i f le lt off =
    ⊥-elim (¬m<m (<≤-trans lt (subst (_≤ i) (sym (+-zero s)) le)))
  Σᵣ-eka′ s (suc m) i f le lt off with discreteℕ s i
  ... | yes p = cong (f s +_) (Σᵣ-zero (suc s) m f tail) ∙ +IdR (f s) ∙ cong f p
    where
    tail : (k : ℕ) → suc s ≤ k → f k ≡ 0r
    tail k sk = off k (<-weaken sk)
                  (λ q → ¬m<m (subst (λ z → suc i ≤ z) q (subst (λ z → suc z ≤ k) p sk)))
  ... | no ¬p = cong (_+ Σᵣ⟨ suc s , m ⟩ f) (off s ≤-refl ¬p) ∙ +IdL _
              ∙ Σᵣ-eka′ (suc s) m i f (suc-le s i le ¬p) (subst (i <_) (+-suc s m) lt)
                        (λ k sk → off k (<-weaken sk))

  Σᵣ-dvi : (s m i j : ℕ) (f : ℕ → ⟨ R ⟩)
         → s ≤ i → i < s +ℕ m → s ≤ j → j < s +ℕ m → ¬ (i ≡ j)
         → ((k : ℕ) → ¬ (k ≡ i) → ¬ (k ≡ j) → f k ≡ 0r)
         → Σᵣ⟨ s , m ⟩ f ≡ f i + f j
  Σᵣ-dvi s zero i j f le lt _ _ _ _ =
    ⊥-elim (¬m<m (<≤-trans lt (subst (_≤ i) (sym (+-zero s)) le)))
  Σᵣ-dvi s (suc m) i j f lei lti lej ltj ne off with discreteℕ s i | discreteℕ s j
  ... | yes p | _ =
      cong₂ _+_ (cong f p)
        (Σᵣ-eka′ (suc s) m j f (suc-le s j lej (λ q → ne (sym p ∙ q)))
                 (subst (j <_) (+-suc s m) ltj)
                 (λ k sk kj → off k (λ ki → ¬m<m (subst (λ z → suc i ≤ z) ki
                                                  (subst (λ z → suc z ≤ k) p sk))) kj))
  ... | no ¬p | yes q =
      cong₂ _+_ (cong f q)
        (Σᵣ-eka′ (suc s) m i f (suc-le s i lei ¬p)
                 (subst (i <_) (+-suc s m) lti)
                 (λ k sk ki → off k ki (λ kj → ¬m<m (subst (λ z → suc j ≤ z) kj
                                                     (subst (λ z → suc z ≤ k) q sk)))))
    ∙ +Comm (f j) (f i)
  ... | no ¬p | no ¬q =
      cong (_+ Σᵣ⟨ suc s , m ⟩ f) (off s ¬p ¬q) ∙ +IdL _
    ∙ Σᵣ-dvi (suc s) m i j f (suc-le s i lei ¬p) (subst (i <_) (+-suc s m) lti)
                             (suc-le s j lej ¬q) (subst (j <_) (+-suc s m) ltj) ne off

  ----------------------------------------------------------------------
  -- २ · On a fixed configuration the τ-form is the plain form, a sum of squares.
  ----------------------------------------------------------------------

  module _ (n : ℕ) (τ : ℕ → ℕ) where

    Sthira : Type
    Sthira = (i : ℕ) → i < n → τ i ≡ i

    -- range-restricted pointwise agreement of sums over [0, n)
    Σᵣ-ext< : (f g : ℕ → ⟨ R ⟩) → ((i : ℕ) → i < n → f i ≡ g i)
            → Σᵣ⟨ zero , n ⟩ f ≡ Σᵣ⟨ zero , n ⟩ g
    Σᵣ-ext< f g e = go zero n ≤-refl
      where
      go : (s m : ℕ) → s +ℕ m ≤ n → Σᵣ⟨ s , m ⟩ f ≡ Σᵣ⟨ s , m ⟩ g
      go s zero    _  = refl
      go s (suc m) le = cong₂ _+_ (e s (≤-trans (≤SumLeft {n = suc s} {k = m}) le′)) (go (suc s) m le′)
        where
        le′ : suc (s +ℕ m) ≤ n
        le′ = subst (_≤ n) (+-suc s m) le

    sthira-sama : Sthira → (c d : Vec) → τ-rūpa n τ c d ≡ plain n τ c d
    sthira-sama fix c d = Σᵣ-ext< _ _ (λ i lt → cong (λ z → (c i) ✶ · d z) (fix i lt))

    -- positivity: any predicate closed under squares and sums, containing 0
    module _ (Dhana : ⟨ R ⟩ → Type ℓd)
             (dhana-varga : (x : ⟨ R ⟩) → Dhana ((x ✶) · x))
             (dhana-yoga  : {x y : ⟨ R ⟩} → Dhana x → Dhana y → Dhana (x + y))
             (dhana-śūnya : Dhana 0r) where

      Σᵣ-dhana : (s m : ℕ) (c : Vec) → Dhana (Σᵣ⟨ s , m ⟩ (λ i → (c i) ✶ · c i))
      Σᵣ-dhana s zero    c = dhana-śūnya
      Σᵣ-dhana s (suc m) c = dhana-yoga (dhana-varga (c s)) (Σᵣ-dhana (suc s) m c)

      plain-dhana : (c : Vec) → Dhana (plain n τ c c)
      plain-dhana c = Σᵣ-dhana zero n c

      sthira→dhana : Sthira → (c : Vec) → Dhana (τ-rūpa n τ c c)
      sthira→dhana fix c = subst Dhana (sym (sthira-sama fix c c)) (plain-dhana c)

    --------------------------------------------------------------------
    -- ३ · A moved mode gives a vector of τ-form −(1 + 1).
    --------------------------------------------------------------------

    -- the vector δ_i − δ_{τ i}, written with its values decided
    bheda : ℕ → Vec
    bheda i k with discreteℕ k i | discreteℕ k (τ i)
    ... | yes _ | _     = 1r
    ... | no  _ | yes _ = - 1r
    ... | no  _ | no  _ = 0r

    bheda-i : (i : ℕ) → bheda i i ≡ 1r
    bheda-i i with discreteℕ i i | discreteℕ i (τ i)
    ... | yes _ | _ = refl
    ... | no ¬p | _ = ⊥-elim (¬p refl)

    bheda-τi : (i : ℕ) → ¬ (τ i ≡ i) → bheda i (τ i) ≡ - 1r
    bheda-τi i ne with discreteℕ (τ i) i | discreteℕ (τ i) (τ i)
    ... | yes p | _    = ⊥-elim (ne p)
    ... | no  _ | yes _ = refl
    ... | no  _ | no ¬q = ⊥-elim (¬q refl)

    bheda-anya : (i k : ℕ) → ¬ (k ≡ i) → ¬ (k ≡ τ i) → bheda i k ≡ 0r
    bheda-anya i k ne ne′ with discreteℕ k i | discreteℕ k (τ i)
    ... | yes p | _     = ⊥-elim (ne p)
    ... | no  _ | yes q = ⊥-elim (ne′ q)
    ... | no  _ | no  _ = refl

    calita-ṛṇa : (i : ℕ) → i < n → τ i < n → ¬ (τ i ≡ i) → τ (τ i) ≡ i
               → τ-rūpa n τ (bheda i) (bheda i) ≡ - (1r + 1r)
    calita-ṛṇa i lt lt′ ne inv =
        Σᵣ-dvi zero n i (τ i) _ zero-≤ lt zero-≤ lt′ (λ p → ne (sym p)) off
      ∙ cong₂ _+_ pada-i pada-τi
      ∙ dvi
      where
      c = bheda i
      -- at i: 1* · (−1) = −1
      pada-i : (c i) ✶ · c (τ i) ≡ - 1r
      pada-i = cong₂ (λ u v → u ✶ · v) (bheda-i i) (bheda-τi i ne)
             ∙ cong (_· (- 1r)) ✶-one ∙ ·IdL (- 1r)
      -- at τ i: (−1)* · c (τ τ i) = (−1)* · 1 = −1
      pada-τi : (c (τ i)) ✶ · c (τ (τ i)) ≡ - 1r
      pada-τi = cong₂ (λ u v → u ✶ · v) (bheda-τi i ne) (cong c inv ∙ bheda-i i)
              ∙ cong (_· 1r) (✶-neg 1r ∙ cong -_ ✶-one) ∙ ·IdR (- 1r)
      -- elsewhere: 0* · _ = 0
      off : (k : ℕ) → ¬ (k ≡ i) → ¬ (k ≡ τ i) → (c k) ✶ · c (τ k) ≡ 0r
      off k ki kτ = cong (λ u → u ✶ · c (τ k)) (bheda-anya i k ki kτ)
                  ∙ cong (_· c (τ k)) ✶-zero ∙ śūnya (c (τ k))
        where
        śūnya : (x : ⟨ R ⟩) → 0r · x ≡ 0r
        śūnya x = solve! R
      dvi : (- 1r) + (- 1r) ≡ - (1r + 1r)
      dvi = solve! R

    --------------------------------------------------------------------
    -- ४ · The criterion: positivity of the τ-form ⇔ every mode is fixed.
    --------------------------------------------------------------------

    Antaḥ : Type
    Antaḥ = (i : ℕ) → i < n → τ i < n

    Parivartana : Type
    Parivartana = (i : ℕ) → i < n → τ (τ i) ≡ i

    module _ (Dhana : ⟨ R ⟩ → Type ℓd)
             (dhana-varga : (x : ⟨ R ⟩) → Dhana ((x ✶) · x))
             (dhana-yoga  : {x y : ⟨ R ⟩} → Dhana x → Dhana y → Dhana (x + y))
             (dhana-śūnya : Dhana 0r)
             (dhana-na-ṛṇa : ¬ Dhana (- (1r + 1r)))
             (closed : Antaḥ) (invol : Parivartana) where

      Dhanatva : Type (ℓ-max ℓ ℓd)
      Dhanatva = (c : Vec) → Dhana (τ-rūpa n τ c c)

      dhanatva→sthira : Dhanatva → Sthira
      dhanatva→sthira pos i lt with discreteℕ (τ i) i
      ... | yes p = p
      ... | no ¬p = ⊥-elim (dhana-na-ṛṇa
                      (subst Dhana (calita-ṛṇa i lt (closed i lt) ¬p (invol i lt)) (pos (bheda i))))

      sthira→dhanatva : Sthira → Dhanatva
      sthira→dhanatva = sthira→dhana Dhana dhana-varga dhana-yoga dhana-śūnya

      -- Weil positivity, finite: the form is positive iff every mode is on the line.
      weil-dhanatva : (Dhanatva → Sthira) × (Sthira → Dhanatva)
      weil-dhanatva = dhanatva→sthira , sthira→dhanatva
