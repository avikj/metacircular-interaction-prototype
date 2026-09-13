{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- एकत्वम् — the uniqueness half that `Drdha` said was absent.
--
-- `Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIs
-- DecidedByDivision` proved existence (every n ≥ 1 is SOME product of
-- firm numbers), Euclid's lemma, and that the SUPPORT is determined by n.
-- Its own ledger said, at the same grain:
--
--     · UNIQUENESS IS NOT PROVED. … nothing here says two such lists are
--       permutations of each other. … HOW MANY times each occurs is not
--       settled.
--     · v_p IS NOT DEFINED HERE at all.
--
-- and `TheUsualReasonsMadeExplicit…` said of the walks module's `Perm`:
--
--     · it is not proved to coincide with "same multiset";
--       the CONVERSE containment `≈ → Perm` is also not proved.
--
-- Both absences are the same absence, and it is a composition of what is
-- already there.  Nothing new is assumed; the only tools are Euclid's
-- lemma from Drdha, the `Insert`/`Perm` relation from the walks module,
-- and cancellation in ℕ from the library.
--
--   १  Over any discrete type: `Perm xs ys` and `xs ≈ ys` (the corpus's
--      four-constructor relation) each give "same count of every element",
--      and same-count gives `Perm` back.  So Perm, ≈ and same-multiset are
--      one relation — the equivalence `TheUsualReasons` left open.
--   २  Two lists of firm numbers with the same product are a `Perm` of
--      each other (एकत्वम्).  Proof: the head of one divides the product
--      of the other, so it OCCURS there (Drdha §७); remove it with an
--      `Insert`; cancel it from the product; recurse.
--   ३  Hence the valuation मानम् p n := count of p in Drdha's list is
--      WELL DEFINED: every factorisation of n has that count of p.
--   ४  The fibre of वधः over n on firm lists is Perm-connected: that is the
--      exact sense in which Drdha's §९ fibre is "unique".  On raw lists it
--      is not contractible (order), and this module does not say it is.
--
-- The kernel runs the valuation: मानम् 2 12 ≡ 2, मानम् 3 12 ≡ 1,
-- मानम् 5 12 ≡ 0 are refl.
------------------------------------------------------------------------
module Ekatva_TheFirmFactorisationIsUniqueTwoPrimeListsWithOneProductAreAPermutationSoTheValuationIsWellDefinedAndPermIsExactlySameCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-left)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision
  using (दृढम् ; वधः ; सर्वे ; _सदस्यः_ ; विभाजनम् ; अन्तर्भावः)
open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using (Insert ; here ; there ; Perm ; pnil ; pcons ; _≈_ ; ≈nil ; ≈cons ; ≈swap ; ≈trans ; permIsAnAdjacentChain)

------------------------------------------------------------------------
-- १ · गणना — counting over a discrete type, and the three relations
------------------------------------------------------------------------

module Bahulya {A : Type} (_≟_ : Discrete A) where

  दश : {x y : A} → Dec (x ≡ y) → ℕ
  दश (yes _) = 1
  दश (no  _) = 0

  दश-स्वयम् : {x : A} (d : Dec (x ≡ x)) → दश d ≡ 1
  दश-स्वयम् (yes _) = refl
  दश-स्वयम् (no ¬e) = ⊥-rec (¬e refl)

  एकः : A → A → ℕ
  एकः x y = दश (x ≟ y)

  गणना : A → List A → ℕ
  गणना z []       = 0
  गणना z (x ∷ xs) = एकः z x + गणना z xs

  -- an insertion adds exactly the inserted element's count
  insert-count : {x : A} {xs ys : List A} → Insert x xs ys
               → (z : A) → गणना z ys ≡ एकः z x + गणना z xs
  insert-count here z = refl
  insert-count (there {y = y} {xs = xs} {ys = ys} ins) z =
      cong (एकः z y +_) (insert-count ins z)
    ∙ +-assoc (एकः z y) (एकः z _) (गणना z xs)
    ∙ cong (_+ गणना z xs) (+-comm (एकः z y) (एकः z _))
    ∙ sym (+-assoc (एकः z _) (एकः z y) (गणना z xs))

  perm-count : {xs ys : List A} → Perm xs ys → (z : A) → गणना z xs ≡ गणना z ys
  perm-count pnil z = refl
  perm-count (pcons {x = x} p ins) z =
    cong (एकः z x +_) (perm-count p z) ∙ sym (insert-count ins z)

  ≈-count : {xs ys : List A} → xs ≈ ys → (z : A) → गणना z xs ≡ गणना z ys
  ≈-count ≈nil z = refl
  ≈-count (≈cons {p = p} h) z = cong (एकः z p +_) (≈-count h z)
  ≈-count (≈swap {p = p} {q = r} {xs = xs}) z =
      +-assoc (एकः z p) (एकः z r) (गणना z xs)
    ∙ cong (_+ गणना z xs) (+-comm (एकः z p) (एकः z r))
    ∙ sym (+-assoc (एकः z r) (एकः z p) (गणना z xs))
  ≈-count (≈trans h k) z = ≈-count h z ∙ ≈-count k z

  -- a positive count locates an insertion
  निष्कासनम् : (x : A) (ys : List A) → 0 < गणना x ys → Σ[ ys' ∈ List A ] Insert x ys' ys
  निष्कासनम् x []       h = ⊥-rec (¬-<-zero h)
  निष्कासनम् x (y ∷ ys) h = step (x ≟ y) h
    where
    step : (d : Dec (x ≡ y)) → 0 < दश d + गणना x ys → Σ[ ys' ∈ List A ] Insert x ys' (y ∷ ys)
    step (yes e) _  = ys , subst (λ w → Insert x ys (w ∷ ys)) e here
    step (no  _) h' = y ∷ fst rest , there (snd rest)
      where rest = निष्कासनम् x ys h'

  -- same count of every element gives a Perm
  count-perm : (xs ys : List A) → ((z : A) → गणना z xs ≡ गणना z ys) → Perm xs ys
  count-perm []       []       _ = pnil
  count-perm []       (y ∷ ys) h =
    ⊥-rec (znots (h y ∙ cong (_+ गणना y ys) (दश-स्वयम् (y ≟ y))))
  count-perm (x ∷ xs) ys       h = pcons (count-perm xs (fst rem) h') (snd rem)
    where
    hx : suc (गणना x xs) ≡ गणना x ys
    hx = cong (_+ गणना x xs) (sym (दश-स्वयम् (x ≟ x))) ∙ h x

    rem : Σ[ ys' ∈ List A ] Insert x ys' ys
    rem = निष्कासनम् x ys (subst (0 <_) hx (suc-≤-suc zero-≤))

    h' : (z : A) → गणना z xs ≡ गणना z (fst rem)
    h' z = inj-m+ {m = एकः z x} (h z ∙ insert-count (snd rem) z)

  -- the three relations are one:  Perm ⇒ ≈ ⇒ same-count ⇒ Perm
  ≈→Perm : {xs ys : List A} → xs ≈ ys → Perm xs ys
  ≈→Perm {xs} {ys} h = count-perm xs ys (≈-count h)

  Perm→≈ : {xs ys : List A} → Perm xs ys → xs ≈ ys
  Perm→≈ = permIsAnAdjacentChain

open Bahulya discreteℕ

------------------------------------------------------------------------
-- २ · एकत्वम् — two firm lists with one product are a Perm
------------------------------------------------------------------------

-- a firm list has positive product
वध-धनः : (L : List ℕ) → सर्वे दृढम् L → 0 < वधः L
वध-धनः []       _                = suc-≤-suc zero-≤
वध-धनः (x ∷ xs) ((1<x , _) , hs) =
  ≤-trans (वध-धनः xs hs)
          (subst (_≤ x · वधः xs) (·-identityˡ (वधः xs)) (≤-·k (<-weaken 1<x)))

-- a nonempty firm list has product ≠ 1
नैकम् : (y : ℕ) (ys : List ℕ) → सर्वे दृढम् (y ∷ ys) → ¬ (वधः (y ∷ ys) ≡ 1)
नैकम् y ys ((1<y , _) , hs) e = ¬m<m (<≤-trans 1<y y≤1)
  where
  y≤1 : y ≤ 1
  y≤1 = subst (y ≤_) (·-comm (वधः ys) y ∙ e)
          (subst (_≤ वधः ys · y) (·-identityˡ y) (≤-·k {k = y} (वध-धनः ys hs)))
  -- 1 ≤ वधः ys gives 1·y ≤ वधः ys · y, i.e. y ≤ y · वधः ys, and that product is 1.

-- membership locates an insertion
सदस्य-निष्कासनम् : (x : ℕ) (M : List ℕ) → x सदस्यः M → Σ[ M' ∈ List ℕ ] Insert x M' M
सदस्य-निष्कासनम् x (y ∷ ys) (inl e) = ys , subst (λ w → Insert x ys (w ∷ ys)) e here
सदस्य-निष्कासनम् x (y ∷ ys) (inr m) = y ∷ fst rest , there (snd rest)
  where rest = सदस्य-निष्कासनम् x ys m

-- an insertion multiplies the product by the inserted element
Insert-वधः : {x : ℕ} {M' M : List ℕ} → Insert x M' M → वधः M ≡ x · वधः M'
Insert-वधः here = refl
Insert-वधः {x} (there {y = y} {xs = xs} ins) =
    cong (y ·_) (Insert-वधः ins)
  ∙ ·-assoc y x (वधः xs)
  ∙ cong (_· वधः xs) (·-comm y x)
  ∙ sym (·-assoc x y (वधः xs))

-- and preserves firmness of the rest
Insert-सर्वे : {x : ℕ} {M' M : List ℕ} → Insert x M' M → सर्वे दृढम् M → सर्वे दृढम् M'
Insert-सर्वे here        (_ , hs) = hs
Insert-सर्वे (there ins) (h , hs) = h , Insert-सर्वे ins hs

एकत्वम् : (L M : List ℕ) → सर्वे दृढम् L → सर्वे दृढम् M → वधः L ≡ वधः M → Perm L M
एकत्वम् []       []       _          _   _ = pnil
एकत्वम् []       (y ∷ ys) _          दृM e = ⊥-rec (नैकम् y ys दृM (sym e))
एकत्वम् (x ∷ xs) M        (दृx , दृxs) दृM e =
  pcons (एकत्वम् xs (fst rem) दृxs (Insert-सर्वे (snd rem) दृM) e') (snd rem)
  where
  mem : x सदस्यः M
  mem = अन्तर्भावः x दृx M दृM (subst (x ∣_) e (∣-left (वधः xs)))

  rem : Σ[ M' ∈ List ℕ ] Insert x M' M
  rem = सदस्य-निष्कासनम् x M mem

  x≢0 : ¬ x ≡ 0
  x≢0 x≡0 = ¬-<-zero (subst (1 <_) x≡0 (fst दृx))

  e' : वधः xs ≡ वधः (fst rem)
  e' = inj-sm· {m = predℕ x}
         (subst (λ w → w · वधः xs ≡ w · वधः (fst rem)) (suc-predℕ x x≢0)
                (e ∙ Insert-वधः (snd rem)))

-- the same statement in the corpus's four-constructor relation, and as counts
एकत्व-≈ : (L M : List ℕ) → सर्वे दृढम् L → सर्वे दृढम् M → वधः L ≡ वधः M → L ≈ M
एकत्व-≈ L M दृL दृM e = Perm→≈ (एकत्वम् L M दृL दृM e)

एकत्व-गणना : (L M : List ℕ) → सर्वे दृढम् L → सर्वे दृढम् M → वधः L ≡ वधः M
           → (p : ℕ) → गणना p L ≡ गणना p M
एकत्व-गणना L M दृL दृM e = perm-count (एकत्वम् L M दृL दृM e)

------------------------------------------------------------------------
-- ३ · मानम् — the valuation, well defined
------------------------------------------------------------------------

मानम् : ℕ → (n : ℕ) → 0 < n → ℕ
मानम् p n pos = गणना p (fst (विभाजनम् n pos))

-- every factorisation of n has the same count of p as Drdha's
मान-निश्चयः : (p n : ℕ) (pos : 0 < n) (L : List ℕ) → सर्वे दृढम् L → वधः L ≡ n
            → गणना p L ≡ मानम् p n pos
मान-निश्चयः p n pos L दृL e =
  एकत्व-गणना L (fst (विभाजनम् n pos)) दृL (fst (snd (विभाजनम् n pos)))
             (e ∙ sym (snd (snd (विभाजनम् n pos)))) p

-- and does not depend on the positivity proof
मान-प्रमाण-निरपेक्षः : (p n : ℕ) (pos pos' : 0 < n) → मानम् p n pos ≡ मानम् p n pos'
मान-प्रमाण-निरपेक्षः p n pos pos' =
  मान-निश्चयः p n pos' (fst (विभाजनम् n pos)) (fst (snd (विभाजनम् n pos))) (snd (snd (विभाजनम् n pos)))

------------------------------------------------------------------------
-- ४ · परीक्षा — the kernel runs the valuation
------------------------------------------------------------------------

private
  ०<१२ : 0 < 12
  ०<१२ = suc-≤-suc zero-≤

  मान-२-१२ : मानम् 2 12 ०<१२ ≡ 2
  मान-२-१२ = refl

  मान-३-१२ : मानम् 3 12 ०<१२ ≡ 1
  मान-३-१२ = refl

  मान-५-१२ : मानम् 5 12 ०<१२ ≡ 0
  मान-५-१२ = refl
