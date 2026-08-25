{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SmithSignNormal
--
-- The Smith capability's normal form is only defined up to units, and the
-- native cubical construction does not choose the nonnegative representative.
--
-- `NaturalMachine.SmithCapability` says the native construction "already is
-- the proof-carrying executable package sought by the repository".  That is
-- true of its *content* and false of its *convention*: the Lean lane's
-- acceptance predicate (`Pairfield.SmithCertificate2.Valid`) demands
-- `0 ≤ d₁` and `0 ≤ d₂`, and the native output does not satisfy it.
--
-- Nobody had noticed, because the capability was used only through its types.
-- Section C below evaluates it on a closed input and the disagreement appears
-- immediately: `diag(2,3)` normalizes to `diag(1,-6)`.
--
-- Section D is the repair, at the level where the ambiguity actually lives:
-- the list of invariants.  Every consecutively-divisible list is carried to
-- its nonnegative representative list by an involutive diagonal matrix of
-- units, so sign normalization is a change of presentation and not a change
-- of mathematical content.
------------------------------------------------------------------------

module NaturalMachine.SmithSignNormal where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; map)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; abs ; _·_ ; injPos ; ¬x≡0→¬abs≡0)
open import Cubical.Data.Int.Divisibility
  using (_∣_ ; ∣→∣ℕ ; ∣ℕ→∣)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient
open import Cubical.Algebra.IntegerMatrix.Smith
open import Cubical.Algebra.IntegerMatrix.Smith.NormalForm

open Coefficient ℤCommRing
open Sim
open SimRel
open Smith
open isSmithNormal

private
  variable
    m n : ℕ

------------------------------------------------------------------------
-- A.  The unit that normalizes a sign.

-- The nonnegative representative of an integer, as an integer.
absℤ : ℤ → ℤ
absℤ x = pos (abs x)

-- The unit carrying an integer to that representative.  `sgn 0 = 1`, which is
-- harmless: `absℤ 0 = 0` either way.
sgn : ℤ → ℤ
sgn (pos _) = pos 1
sgn (negsuc _) = negsuc 0

-- Both cases are definitional: `pos 1 · pos n` and `negsuc 0 · negsuc n`
-- already reduce to `pos (abs _)`.  Deliberately no named arithmetic lemma is
-- used here -- `·Rid` / `·IdR` is exactly the identifier the cubical rename
-- generation moved (msg 0467), and this module should not depend on how that
-- question is settled.
sgn· : (x : ℤ) → sgn x · x ≡ absℤ x
sgn· (pos n) = refl
sgn· (negsuc n) = refl

-- Each sign is its own inverse, so the normalizing matrix will be involutive.
sgn·sgn : (x : ℤ) → sgn x · sgn x ≡ pos 1
sgn·sgn (pos _) = refl
sgn·sgn (negsuc _) = refl

------------------------------------------------------------------------
-- B.  Sign normalization preserves the divisibility chain.
--
-- Divisibility over ℤ is sign-blind: it factors through `abs` in both
-- directions, and `abs (absℤ x)` is `abs x` definitionally.  So the whole
-- chain transports with no arithmetic.

absℤ∣ : {a b : ℤ} → a ∣ b → absℤ a ∣ absℤ b
absℤ∣ p = ∣ℕ→∣ (∣→∣ℕ p)

absℤ≢0 : {a : ℤ} → ¬ a ≡ pos 0 → ¬ absℤ a ≡ pos 0
absℤ≢0 p q = ¬x≡0→¬abs≡0 p (injPos q)

absList : List ℤ → List ℤ
absList = map absℤ

absAll : (a : ℤ) (xs : List ℤ) → a ∣all xs → absℤ a ∣all absList xs
absAll a [] p = absℤ≢0 p
absAll a (x ∷ xs) (h , hs) = absℤ∣ h , absAll a xs hs

absConsDivs : (xs : List ℤ) → isConsDivs xs → isConsDivs (absList xs)
absConsDivs [] _ = tt
absConsDivs (x ∷ xs) (h , hs) = absAll x xs h , absConsDivs xs hs

absDivs : ConsDivs → ConsDivs
absDivs (xs , p) = absList xs , absConsDivs xs p

lenAbs : (xs : List ℤ) → length (absList xs) ≡ length xs
lenAbs [] = refl
lenAbs (x ∷ xs) = cong suc (lenAbs xs)

------------------------------------------------------------------------
-- C.  The normalized normal matrix, and the unit matrix reaching it.
--
-- `absSmithMat` is `smithMat` of the normalized list, but indexed by the
-- *original* length, so that everything below stays transport-free.  The one
-- transport needed anywhere is `absSmith≡`.

absSmithMat : (xs : List ℤ) (m n : ℕ) → Mat (length xs + m) (length xs + n)
absSmithMat [] _ _ = 𝟘
absSmithMat (x ∷ xs) m n = absℤ x ⊕ absSmithMat xs m n

absSmith≡ : (xs : List ℤ) (m n : ℕ)
          → PathP (λ i → Mat (lenAbs xs i + m) (lenAbs xs i + n))
                  (smithMat (absList xs) m n) (absSmithMat xs m n)
absSmith≡ [] _ _ = refl
absSmith≡ (x ∷ xs) m n i = absℤ x ⊕ absSmith≡ xs m n i

-- The diagonal matrix of units.  It is built by the same recursion as the
-- normal matrix, so no coordinate bookkeeping is needed.
signMat : (xs : List ℤ) (m : ℕ) → Mat (length xs + m) (length xs + m)
signMat [] _ = 𝟙
signMat (x ∷ xs) m = sgn x ⊕ signMat xs m

-- Involutive, hence unimodular, and its own inverse witness.
signMat⋆signMat : (xs : List ℤ) (m : ℕ)
                → signMat xs m ⋆ signMat xs m ≡ 𝟙
signMat⋆signMat [] _ = ⋆lUnit 𝟙
signMat⋆signMat (x ∷ xs) m =
    ⊕-⋆ (sgn x) (sgn x) (signMat xs m) (signMat xs m)
  ∙ (λ i → sgn·sgn x i ⊕ signMat⋆signMat xs m i)
  ∙ 1⊕𝟙

isInvSignMat : (xs : List ℤ) (m : ℕ) → isInv (signMat xs m)
isInvSignMat xs m .fst = signMat xs m
isInvSignMat xs m .snd .fst = signMat⋆signMat xs m
isInvSignMat xs m .snd .snd = signMat⋆signMat xs m

-- The normalization equation.  This is where `sgn· ` is spent, once per
-- invariant, and nothing else happens.
signMat⋆smithMat : (xs : List ℤ) (m n : ℕ)
                 → signMat xs m ⋆ smithMat xs m n ≡ absSmithMat xs m n
signMat⋆smithMat [] m n = ⋆lUnit 𝟘
signMat⋆smithMat (x ∷ xs) m n =
    ⊕-⋆ (sgn x) x (signMat xs m) (smithMat xs m n)
  ∙ (λ i → sgn· x i ⊕ signMat⋆smithMat xs m n i)

------------------------------------------------------------------------
-- D.  Sign normalization as a change of presentation.

-- The normalized matrix is similar to the original normal matrix, by the
-- involutive unit matrix on the left and nothing on the right.
signSim : (xs : List ℤ) (m n : ℕ) → Sim (smithMat xs m n)
signSim xs m n .result = absSmithMat xs m n
signSim xs m n .simrel .transMatL = signMat xs m
signSim xs m n .simrel .transMatR = 𝟙
signSim xs m n .simrel .transEq =
    sym (signMat⋆smithMat xs m n)
  ∙ sym (⋆rUnit (signMat xs m ⋆ smithMat xs m n))
signSim xs m n .simrel .isInvTransL = isInvSignMat xs m
signSim xs m n .simrel .isInvTransR = isInv𝟙

-- And it is still a Smith normal matrix: the invariants are the normalized
-- list, whose divisibility chain was transported in section B.
isSmithNormalAbs : (xs : ConsDivs) (m n : ℕ)
                 → isSmithNormal (absSmithMat (xs .fst) m n)
isSmithNormalAbs xs m n .divs = absDivs xs
isSmithNormalAbs xs m n .rowNull = m
isSmithNormalAbs xs m n .colNull = n
isSmithNormalAbs xs m n .rowEq = cong (_+ m) (lenAbs (xs .fst))
isSmithNormalAbs xs m n .colEq = cong (_+ n) (lenAbs (xs .fst))
isSmithNormalAbs xs m n .matEq = absSmith≡ (xs .fst) m n

-- Sign normalization of a Smith normal matrix, packaged as a `Smith`.
smithSignNormal : (xs : ConsDivs) (m n : ℕ) → Smith (smithMat (xs .fst) m n)
smithSignNormal xs m n .sim = signSim (xs .fst) m n
smithSignNormal xs m n .isnormal = isSmithNormalAbs xs m n

------------------------------------------------------------------------
-- E.  Idempotence: normalizing twice is normalizing once.
--
-- This is the check that `absℤ` really picks representatives rather than
-- merely moving the sign around.

absℤ-idem : (x : ℤ) → absℤ (absℤ x) ≡ absℤ x
absℤ-idem _ = refl

absList-idem : (xs : List ℤ) → absList (absList xs) ≡ absList xs
absList-idem [] = refl
absList-idem (x ∷ xs) i = absℤ x ∷ absList-idem xs i

absSmithMat-idem : (xs : List ℤ) (m n : ℕ)
                 → PathP (λ i → Mat (lenAbs xs i + m) (lenAbs xs i + n))
                         (absSmithMat (absList xs) m n) (absSmithMat xs m n)
absSmithMat-idem [] _ _ = refl
absSmithMat-idem (x ∷ xs) m n i = absℤ x ⊕ absSmithMat-idem xs m n i
