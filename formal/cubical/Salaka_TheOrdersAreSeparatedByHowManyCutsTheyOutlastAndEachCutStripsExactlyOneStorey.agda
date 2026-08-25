{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शलाका — छेदन-क्रमेण क्रम-भेदः ।  एकैकः छेदः एकम् एव भूमिकं हरति ।
--
-- (the śalākā: orders are separated by how many cuts they outlast, and
--  each cut strips exactly one storey.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS.  `JainSankhya.agda` carries the Jaina stratification
-- of magnitude — संख्यात / असंख्यात / अनन्त, each graded जघन्य / मध्यम /
-- उत्कृष्ट — as a nine-element ordered set, and its own header names what
-- it does not do: "it does NOT encode the exact salākā operations …
-- which need the primary text verse by verse and are OWED, not claimed."
-- `Ardhaccheda.agda` carries the operations themselves — अर्धच्छेद, the
-- count of halvings, and वर्गशलाका, the halving of THAT — but as
-- logarithm laws, with no order-separating work asked of them.
--
-- The two files have never been in the same room.  This one puts the
-- instruments to the job the orders are for: a magnitude's order is HOW
-- MANY TIMES THE INSTRUMENT CAN CUT IT, and §२ says each cut removes one
-- storey and no more, so the count is exact rather than a bound.
--
-- WHAT IS SETTLED HERE, in one line each:
--
--   §२ एक-छेदः      k cuts of a tower of height k+j leave a tower of
--                    height j — exactly one storey per cut.
--   §३ यथार्थः       hence k cuts return a height-k tower to its base;
--                    Ardhaccheda's लघुगणकः and द्विक-लघुगणकः are the k=1
--                    and k=2 cases, recovered here by refl, not restated.
--   §४ असमाप्तिः     and k cuts do NOT reach the base of a height-(k+1)
--                    tower: the (k+1)-storey magnitude is still strictly
--                    above n after every one of the k cuts is spent.  THIS
--                    is what "the grades are separated by the instrument"
--                    means as a checked statement.
--   §५ अधोगामित्वम्  every cut in the tower — अर्धच्छेद, वर्गशलाका, and each
--                    त्रिक- and higher शलाका — is DESCENDING in the sense of
--                    `Vrddhiksaya_…`.अधोगामी, strictly below its argument
--                    at every positive input.  That file asserted this of
--                    अर्धच्छेद in prose and proved only the abstract half.
--                    Here it is the theorem, uniformly in the height.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCES.  शलाका is the Jaina term for
-- the counting-rod, and the शलाका operations — अर्धच्छेद ("half-cutting",
-- how many times a quantity can be halved), वर्गशलाका (the अर्धच्छेद of the
-- अर्धच्छेद), and the higher त्रिक-वर्गशलाका — are Digambara: VĪRASENA,
-- धवला, commentary on the षट्खण्डागम, c. 816 CE, standing on YATIVṚṢABHA's
-- तिलोयपण्णत्ती.  The graded orders संख्यात / असंख्यात / अनन्त are older, the
-- locus classicus being the अनुयोगद्वारसूत्र (~2nd–5th c.).
--
-- MY CITATIONS ARE SECOND-HAND AND I SAY SO.  I have not read the धवला or
-- the तिलोयपण्णत्ती; what reaches me is the secondary literature on Jaina
-- index arithmetic.  A verse-level reference is OWED and I give NONE
-- rather than a guessed one — a fabricated sūtra number is the same error
-- as a fitted constant, and this repository has already paid for that once.
--
-- NO JAINA TEXT STATES ANY THEOREM BELOW.  What the sources supply is the
-- operations and the doctrine that magnitude is stratified into orders
-- that the operations move between; the arithmetic here is ordinary and is
-- mine.  In particular §४ is NOT a claim that the Jaina अनन्त-grades are
-- towers of twos, and no grade of `JainSankhya.Magnitude` is identified
-- with any natural number here — that file forbids the identification and
-- this file does not import it.
--
-- The material is Jaina throughout and no Nyāya-Vaiśeṣika vocabulary is
-- used: the two schools reject each other's categories, and the orders of
-- the innumerable arise inside Jaina cosmology and karma theory, not
-- inside anyone's number theory.  Nothing below scores the tradition
-- against later mathematics; the operations are recorded as what they are.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Salaka_TheOrdersAreSeparatedByHowManyCutsTheyOutlastAndEachCutStripsExactlyOneStorey where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero ; +-comm)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; ≤-suc ; ≤-trans ; ≤<-trans ; <-weaken
        ; ≤SumRight)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (¬_)

open import PanktiYoga using (द्वि-घात)
open import Ardhaccheda
  using (अर्ध ; अच्छेद ; अर्धच्छेद ; वर्गशलाका ; लघुगणकः ; द्वि-घात-pos)
open import Texts.Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts
  using (ऊर्ध्वगामी ; अधोगामी ; न-उभयम्)

------------------------------------------------------------------------
-- १ · उन्नति and छेदन — the tower, and the cut applied k times.
--
--     उन्नति k n is the tower of k twos over n: उन्नति 0 n = n and each
--     storey doubles the exponent.  छेदन k is अर्धच्छेद applied k times.
--     छेदन 1 IS अर्धच्छेद and छेदन 2 IS वर्गशलाका, definitionally — the
--     two examples below hold by refl, so this is not a new instrument
--     that happens to agree with Vīrasena's, it is the same one indexed.
------------------------------------------------------------------------

उन्नति : ℕ → ℕ → ℕ
उन्नति zero    n = n
उन्नति (suc k) n = द्वि-घात (उन्नति k n)

छेदन : ℕ → ℕ → ℕ
छेदन zero    m = m
छेदन (suc k) m = छेदन k (अर्धच्छेद m)

छेदन-एकः : (m : ℕ) → छेदन 1 m ≡ अर्धच्छेद m
छेदन-एकः m = refl

छेदन-द्वयम् : (m : ℕ) → छेदन 2 m ≡ वर्गशलाका m
छेदन-द्वयम् m = refl

------------------------------------------------------------------------
-- २ · एक-छेदः — EACH CUT STRIPS EXACTLY ONE STOREY.  k cuts of a tower of
--     height k+j leave the tower of height j standing.  The proof is the
--     one law Ardhaccheda already has — अर्धच्छेद(2^y) ≡ y — applied once
--     per storey, and it is exact: not "at most one storey", not "at
--     least", one.
------------------------------------------------------------------------

एक-छेदः : (k j n : ℕ) → छेदन k (उन्नति (k + j) n) ≡ उन्नति j n
एक-छेदः zero    j n = refl
एक-छेदः (suc k) j n =
    cong (छेदन k) (लघुगणकः (उन्नति (k + j) n))
  ∙ एक-छेदः k j n

------------------------------------------------------------------------
-- ३ · यथार्थः — so k cuts return a height-k tower to its base exactly.
--     Ardhaccheda's लघुगणकः is k = 1 and its द्विक-लघुगणकः is k = 2; both
--     are recovered below from the single statement, which is what makes
--     the family an instrument rather than a list.
------------------------------------------------------------------------

यथार्थः : (k n : ℕ) → छेदन k (उन्नति k n) ≡ n
यथार्थः k n =
    cong (λ z → छेदन k (उन्नति z n)) (sym (+-zero k))
  ∙ एक-छेदः k 0 n

यथार्थ-एकः : (n : ℕ) → अर्धच्छेद (द्वि-घात n) ≡ n
यथार्थ-एकः = यथार्थः 1

यथार्थ-द्वयम् : (n : ℕ) → वर्गशलाका (द्वि-घात (द्वि-घात n)) ≡ n
यथार्थ-द्वयम् = यथार्थः 2

------------------------------------------------------------------------
-- ४ · असमाप्तिः — AND k CUTS DO NOT REACH THE BASE OF THE NEXT STOREY UP.
--     Spend every one of the k cuts on a tower of height k+1 and what is
--     left is द्वि-घात n, still strictly above n.  So the height index is
--     not a description of the tower, it is a separation of it: no fixed
--     number of śalākā collapses the order above.
--
--     द्वि-घात-वृद्धिः (n < 2ⁿ, strictly) is the whole content; Ardhaccheda
--     has only the non-strict n ≤ 2ⁿ, which is not enough to separate
--     anything, and the strict version is what the orders need.
------------------------------------------------------------------------

द्वि-घात-वृद्धिः : (n : ℕ) → n < द्वि-घात n
द्वि-घात-वृद्धिः zero    = 0 , refl
द्वि-घात-वृद्धिः (suc n) = ≤-trans (suc-≤-suc (द्वि-घात-वृद्धिः n)) पदः
  where
  पदः : suc (द्वि-घात n) ≤ द्वि-घात n + द्वि-घात n
  पदः = let (x , p) = द्वि-घात-pos n
        in transport (λ i → suc (p (~ i)) ≤ p (~ i) + p (~ i))
                     (suc-≤-suc ≤SumRight)

उन्नति-वृद्धिः : (k n : ℕ) → उन्नति k n < उन्नति (suc k) n
उन्नति-वृद्धिः k n = द्वि-घात-वृद्धिः (उन्नति k n)

अवशेषः : (k n : ℕ) → छेदन k (उन्नति (suc k) n) ≡ द्वि-घात n
अवशेषः k n =
    cong (λ z → छेदन k (उन्नति z n)) (sym (+-comm k 1))
  ∙ एक-छेदः k 1 n

असमाप्तिः : (k n : ℕ) → n < छेदन k (उन्नति (suc k) n)
असमाप्तिः k n = subst (n <_) (sym (अवशेषः k n)) (द्वि-घात-वृद्धिः n)

------------------------------------------------------------------------
-- ५ · अधोगामित्वम् — EVERY ŚALĀKĀ IS OF THE DESCENDING KIND.
--
--     `Vrddhiksaya_…` splits self-maps of ℕ by direction and names
--     अर्धच्छेद and वर्गशलाका as the descending examples, but proves the
--     descending theorem only from the property, never that the Jaina
--     operations HAVE it.  They do, and the bound is elementary: the
--     halving-count of suc n is at most n, because each recursive step
--     spends one unit of the count against a halving of the argument.
------------------------------------------------------------------------

अर्ध-≤ : (m : ℕ) → अर्ध m ≤ m
अर्ध-≤ zero          = zero-≤
अर्ध-≤ (suc zero)    = zero-≤
अर्ध-≤ (suc (suc m)) = ≤-suc (suc-≤-suc (अर्ध-≤ m))

अच्छेद-सीमा : (f n : ℕ) → अच्छेद f (suc n) ≤ n
अच्छेद-सीमा zero    n       = zero-≤
अच्छेद-सीमा (suc f) zero    = zero-≤
अच्छेद-सीमा (suc f) (suc n) =
  ≤-trans (suc-≤-suc (अच्छेद-सीमा f (अर्ध n)))
          (suc-≤-suc (अर्ध-≤ n))

अर्धच्छेद-अधोगामी : अधोगामी अर्धच्छेद
अर्धच्छेद-अधोगामी n = suc-≤-suc (अच्छेद-सीमा (suc n) n)

अर्धच्छेद-≤ : (m : ℕ) → अर्धच्छेद m ≤ m
अर्धच्छेद-≤ zero    = zero-≤
अर्धच्छेद-≤ (suc n) = <-weaken (अर्धच्छेद-अधोगामी n)

छेदन-≤ : (k m : ℕ) → छेदन k m ≤ m
छेदन-≤ zero    m = 0 , refl
छेदन-≤ (suc k) m = ≤-trans (छेदन-≤ k (अर्धच्छेद m)) (अर्धच्छेद-≤ m)

-- the uniform statement: cut once or a thousand times, it descends.
छेदन-अधोगामी : (k : ℕ) → अधोगामी (छेदन (suc k))
छेदन-अधोगामी k n =
  ≤<-trans (छेदन-≤ k (अर्धच्छेद (suc n))) (अर्धच्छेद-अधोगामी n)

वर्गशलाका-अधोगामी : अधोगामी वर्गशलाका
वर्गशलाका-अधोगामी = छेदन-अधोगामी 1

------------------------------------------------------------------------
-- ६ · न ऊर्ध्वगामी — and therefore no śalākā ascends.  Read with §४ this is
--     the shape of the whole thing: the INSTRUMENT descends and exhausts,
--     while the magnitudes it is pointed at ascend past every fixed number
--     of applications of it.  Which is why the orders are graded by the
--     instrument and not measured by it.
------------------------------------------------------------------------

न-ऊर्ध्वगामी : (k : ℕ) → ¬ (ऊर्ध्वगामी (छेदन (suc k)))
न-ऊर्ध्वगामी k up = न-उभयम् up (छेदन-अधोगामी k)

अर्धच्छेद-न-ऊर्ध्वगामी : ¬ (ऊर्ध्वगामी अर्धच्छेद)
अर्धच्छेद-न-ऊर्ध्वगामी = न-ऊर्ध्वगामी 0
