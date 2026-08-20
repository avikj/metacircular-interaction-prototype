{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kuttaka_TwoCongruencesSolvableIffTheGcdDividesTheDifference
--
-- ONE PROBLEM, THREE STATEMENTS.  This corpus records the simultaneous
-- congruence problem under three names and, in three places verbatim
-- (`NaturalMachine/CRTChain.agda` lines 134–152,
-- `notes/PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md` §"Chinese remainder
-- theorem without the kuṭṭaka", `notes/DID_THE_THREE_ROOTS_SUFFICE.md`),
-- one sentence about the Chinese half:
--
--   "The Sun Zi Suanjing (c. 3rd–5th c.) poses the problem with a rule
--    for a special case; Qin Jiushao's general method is 1247."
--
-- The sources, so the difference between the three statements is on the
-- page rather than compressed into "both traditions have it":
--
--   Sunzi, *Sunzi Suanjing* (孫子算經, c. 3rd–5th c.), problem 3.26:
--     remainders 2, 3, 2 against 3, 5, 7; the text gives the multipliers
--     70, 21, 15 and the instruction to subtract 105.  Fixed pairwise
--     coprime moduli, a table, no method for producing the multipliers.
--
--   Āryabhaṭa, *Āryabhaṭīya* Gaṇitapāda 32–33 (499), the **kuṭṭaka**:
--     the descent that PRODUCES the multiplier — mutual division, keep
--     the remainder, recurse, back-substitute up the vallī.  Formalised
--     in this repository as `Kuttaka.agda` (`Run`, `bezout`).
--
--   Qin Jiushao, *Shushu Jiuzhang* (數書九章, 1247), 大衍總數術:
--     (a) 大衍求一術 *dayan qiuyi shu*, "the technique of seeking unity"
--         — mutual division to find k with a·k ≡ 1 (mod m).  This is the
--         kuṭṭaka's descent, arrived at independently, 748 years later.
--     (b) the reduction 元數 *yuanshu* (the given, possibly non-coprime
--         moduli) → 定母 *dingmu* (fixed, pairwise coprime moduli),
--         by stripping prime powers so each prime survives in one
--         modulus only.  This has no counterpart in Sunzi or in the
--         kuṭṭaka as stated at Gaṇitapāda 32–33.
--
-- WHAT IS CLAIMED OF THE SOURCES, AND WHAT IS NOT.  (a) and (b) are
-- Qin Jiushao's; the descent in `Kuttaka.agda` is Āryabhaṭa's; the
-- coprime table is Sunzi's.  **The theorem below is none of theirs.**
-- Qin Jiushao's method presupposes that the given system is consistent
-- — his problems come from calendars, granaries and levies, where the
-- data are consistent by construction — and reduces its moduli.  It
-- does not TEST consistency, and the criterion proved here is not in
-- the *Shushu Jiuzhang*, not in the *Sunzi Suanjing*, and not at
-- Gaṇitapāda 32–33.  Naming it after any of the three would repeat
-- exactly the error CLAUDE.md's provenance rule forbids, so it is named
-- for the object it consumes and nothing else: the proof of the hard
-- direction is `Kuttaka.bezout` applied to a `Kuttaka.Run`, and that is
-- what "Kuttaka" in the module name refers to.
--
-- WHAT IS PROVED.  No postulates, no holes, --safe.
--
--   necessity     if any x satisfies both congruences, then every common
--                 divisor of the two moduli divides r₁ − r₂.  No gcd, no
--                 descent, no coprimality — pure divisibility.
--   sufficiency   given a kuṭṭaka run of (m₁,m₂) terminating at g, and
--                 g ∣ (r₁ − r₂), an x satisfying both is CONSTRUCTED,
--                 explicitly, as r₁ − m₁·u·k where (u,v) is the run's
--                 back-substituted pair.  The pulveriser is the whole
--                 content of this direction.
--   sunzi-case    when the run terminates at 1, the hypothesis is
--                 vacuous and every residue pair is solvable — the
--                 coprime case, which is what `CRTChain.Coprimes`
--                 assumes and never has to check.
--   one-coset     the solution set, whenever it is inhabited, is exactly
--                 one coset of the common multiples of m₁ and m₂:
--                 `translate` (a coset element moves solutions to
--                 solutions) and `solutions-differ` (two solutions
--                 differ by a coset element).  This holds for EVERY g,
--                 coprime or not.
--   6/4 instances a consistent non-coprime pair (moduli 6,4; residues
--                 3,1) and an INCONSISTENT one (residues 3,0), the
--                 latter refuted by `necessity` plus parity.
--
-- WHAT IS NOT PROVED, stated so it is not mistaken for done.  The
-- k-modulus case.  Passing from a consistent system on k pairwise
-- non-coprime moduli to an equivalent system on pairwise coprime ones
-- is precisely Qin Jiushao's 元數→定母 reduction, it is the step
-- `CRTChain.agda` records as its open boundary, and nothing here does
-- it.  Two moduli need no reduction — the criterion replaces it.  Three
-- do.
--
-- BIBLIOGRAPHIC STATUS, stated rather than implied.  No edition of the
-- *Shushu Jiuzhang*, the *Sunzi Suanjing* or the *Āryabhaṭīya* was read
-- in this container; none is on disk here.  The Chinese terms, dates and
-- the yuanshu/dingmu distinction are as recorded in the standard
-- technical treatment (U. Libbrecht, *Chinese Mathematics in the
-- Thirteenth Century: The Shu-shu chiu-chang of Ch'in Chiu-shao*, MIT
-- Press 1973), which I have not re-read here either.  The corpus's own
-- one-sentence summary of the Chinese half — quoted at the top, and
-- verbatim in three files — is what this module is decomposing, and the
-- decomposition is a bibliographic claim, correctable as such.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, the container, NOT the repository
-- pin.  Exit code quoted in the commit message.  It will FAIL under the
-- pin (Agda 2.8.0 + cubical v0.9) for the reason `Everything.agda`
-- already records: three uses of `solve`, which v0.9 spells `solve!`,
-- plus the same defect inherited from `Kuttaka.agda:87`.  It is
-- deliberately not added to `Everything.agda`, which is already red at
-- that line and is not mine to repair.
------------------------------------------------------------------------

module Kuttaka_TwoCongruencesSolvableIffTheGcdDividesTheDifference where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
open import Cubical.Data.Int.Properties
open import Cubical.Data.Int.IsEven using (trueIsEven)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

open import Kuttaka using (Run ; stop ; div ; bezout ; _∣_ ; gcdDivides)

------------------------------------------------------------------------
-- 0.  Congruence, written as divisibility of a difference, so that it
--     needs no quotient convention and no positivity.
------------------------------------------------------------------------

-- Cong m x r  reads  x ≡ r (mod m).
Cong : ℤ → ℤ → ℤ → Type
Cong m x r = m ∣ (x + (- r))

-- the common multiples of m₁ and m₂ — the coset direction of §3.
Common : ℤ → ℤ → ℤ → Type
Common m₁ m₂ y = (m₁ ∣ y) × (m₂ ∣ y)

-- a solution of the pair
Solves : ℤ → ℤ → ℤ → ℤ → ℤ → Type
Solves m₁ m₂ r₁ r₂ x = Cong m₁ x r₁ × Cong m₂ x r₂

------------------------------------------------------------------------
-- 1.  NECESSITY.  Every common divisor of the moduli divides the
--     difference of the residues.  This is the half that holds with no
--     descent at all, and it is the half that makes an inconsistent
--     system refutable.
------------------------------------------------------------------------

private
  necId₁ : (x r₁ r₂ : ℤ)
         → r₁ + (- r₂) ≡ (x + (- r₂)) + (- (x + (- r₁)))
  necId₁ = solve ℤCommRing

  necId₂ : (d a₁ a₂ c₁ c₂ : ℤ)
         → (d · a₂) · c₂ + (- ((d · a₁) · c₁))
           ≡ d · (a₂ · c₂ + (- (a₁ · c₁)))
  necId₂ = solve ℤCommRing

necessity : (m₁ m₂ r₁ r₂ d x : ℤ)
          → d ∣ m₁ → d ∣ m₂
          → Solves m₁ m₂ r₁ r₂ x
          → d ∣ (r₁ + (- r₂))
necessity m₁ m₂ r₁ r₂ d x (a₁ , m₁≡) (a₂ , m₂≡) ((c₁ , p₁) , (c₂ , p₂)) =
    (a₂ · c₂ + (- (a₁ · c₁)))
  , ( necId₁ x r₁ r₂
      ∙ cong₂ (λ u v → u + (- v)) p₂ p₁
      ∙ cong₂ (λ u v → u · c₂ + (- (v · c₁))) m₂≡ m₁≡
      ∙ necId₂ d a₁ a₂ c₁ c₂ )

------------------------------------------------------------------------
-- 2.  SUFFICIENCY.  The pulveriser supplies the solution.
--
--     A `Run m₁ m₂ g` is Āryabhaṭa's vallī for the pair (m₁,m₂); its
--     back-substitution `bezout` returns (u,v) with m₁·u + m₂·v ≡ g.
--     If moreover r₁ − r₂ = g·k, then
--
--         x = r₁ − m₁·u·k
--
--     solves both congruences, and the second one closes because
--     g·k − m₁·u·k = (m₁u + m₂v)k − m₁uk = m₂·(v·k).
------------------------------------------------------------------------

private
  sufId₁ : (m₁ u k r₁ : ℤ)
         → (r₁ + (- ((m₁ · u) · k))) + (- r₁) ≡ m₁ · (- (u · k))
  sufId₁ = solve ℤCommRing

  sufId₂ : (m₁ u k r₁ r₂ : ℤ)
         → (r₁ + (- ((m₁ · u) · k))) + (- r₂)
           ≡ (r₁ + (- r₂)) + (- ((m₁ · u) · k))
  sufId₂ = solve ℤCommRing

  sufId₃ : (m₁ m₂ u v k : ℤ)
         → ((m₁ · u + m₂ · v) · k) + (- ((m₁ · u) · k)) ≡ m₂ · (v · k)
  sufId₃ = solve ℤCommRing

sufficiency : (m₁ m₂ g r₁ r₂ : ℤ)
            → Run m₁ m₂ g
            → g ∣ (r₁ + (- r₂))
            → Σ[ x ∈ ℤ ] Solves m₁ m₂ r₁ r₂ x
sufficiency m₁ m₂ g r₁ r₂ run (k , diff≡) =
  let (u , v , bez) = bezout m₁ m₂ g run
  in  (r₁ + (- ((m₁ · u) · k)))
    , ( ( (- (u · k)) , sufId₁ m₁ u k r₁ )
      , ( (v · k)
        , ( sufId₂ m₁ u k r₁ r₂
            ∙ cong (_+ (- ((m₁ · u) · k))) diff≡
            ∙ cong (λ z → (z · k) + (- ((m₁ · u) · k))) (sym bez)
            ∙ sufId₃ m₁ m₂ u v k ) ) )

------------------------------------------------------------------------
-- 3.  ONE COSET.  Whatever g is, the solution set is a coset of the
--     common multiples: no extra invariant appears when the moduli
--     share a factor.  Only the subgroup changes.
------------------------------------------------------------------------

private
  transId : (x y r : ℤ) → (x + y) + (- r) ≡ (x + (- r)) + y
  transId = solve ℤCommRing

  combId : (m c e : ℤ) → m · c + m · e ≡ m · (c + e)
  combId = solve ℤCommRing

  diffId : (x x' r : ℤ) → x + (- x') ≡ (x + (- r)) + (- (x' + (- r)))
  diffId = solve ℤCommRing

  subId : (m c c' : ℤ) → m · c + (- (m · c')) ≡ m · (c + (- c'))
  subId = solve ℤCommRing

private
  shift : (m x y r : ℤ) → m ∣ (x + (- r)) → m ∣ y → m ∣ ((x + y) + (- r))
  shift m x y r (c , p) (e , q) =
    (c + e) , ( transId x y r ∙ cong₂ _+_ p q ∙ combId m c e )

  sub : (m x x' r : ℤ) → m ∣ (x + (- r)) → m ∣ (x' + (- r)) → m ∣ (x + (- x'))
  sub m x x' r (c , p) (c' , q) =
    (c + (- c'))
    , ( diffId x x' r ∙ cong₂ (λ a b → a + (- b)) p q ∙ subId m c c' )

translate : (m₁ m₂ r₁ r₂ x y : ℤ)
          → Solves m₁ m₂ r₁ r₂ x → Common m₁ m₂ y
          → Solves m₁ m₂ r₁ r₂ (x + y)
translate m₁ m₂ r₁ r₂ x y (s₁ , s₂) (y₁ , y₂) =
  shift m₁ x y r₁ s₁ y₁ , shift m₂ x y r₂ s₂ y₂

solutions-differ : (m₁ m₂ r₁ r₂ x x' : ℤ)
                 → Solves m₁ m₂ r₁ r₂ x → Solves m₁ m₂ r₁ r₂ x'
                 → Common m₁ m₂ (x + (- x'))
solutions-differ m₁ m₂ r₁ r₂ x x' (s₁ , s₂) (t₁ , t₂) =
  sub m₁ x x' r₁ s₁ t₁ , sub m₂ x x' r₂ s₂ t₂

------------------------------------------------------------------------
-- 4.  THE COPRIME CASE, which is the only one the corpus had.
--     A run terminating at 1 makes the hypothesis of §2 vacuous.
------------------------------------------------------------------------

private
  oneDiv : (n : ℤ) → n ≡ pos 1 · n
  oneDiv = solve ℤCommRing

sunzi-case : (m₁ m₂ : ℤ) → Run m₁ m₂ (pos 1)
           → (r₁ r₂ : ℤ) → Σ[ x ∈ ℤ ] Solves m₁ m₂ r₁ r₂ x
sunzi-case m₁ m₂ run r₁ r₂ =
  sufficiency m₁ m₂ (pos 1) r₁ r₂ run
    ( (r₁ + (- r₂)) , oneDiv (r₁ + (- r₂)) )

-- non-vacuity: the vallī of (7,5) from `Kuttaka.example` bottoms at 1,
-- so every residue pair against 7 and 5 is solved.
coprime-7-5 : (r₁ r₂ : ℤ) → Σ[ x ∈ ℤ ] Solves (pos 7) (pos 5) r₁ r₂ x
coprime-7-5 = sunzi-case (pos 7) (pos 5) Kuttaka.example

------------------------------------------------------------------------
-- 5.  THE NON-COPRIME CASE.  moduli 6 and 4, gcd 2.
--     vallī:  6 = 1·4 + 2 ,  4 = 2·2 + 0.
------------------------------------------------------------------------

run64 : Run (pos 6) (pos 4) (pos 2)
run64 =
  div (pos 6) (pos 4) (pos 1) (pos 2) (pos 2) refl
    (div (pos 4) (pos 2) (pos 2) (pos 0) (pos 2) refl
      (stop (pos 2)))

-- 5.1  CONSISTENT: x ≡ 3 (mod 6), x ≡ 1 (mod 4).  3 − 1 = 2 = 2·1.
solved64 : Σ[ x ∈ ℤ ] Solves (pos 6) (pos 4) (pos 3) (pos 1) x
solved64 =
  sufficiency (pos 6) (pos 4) (pos 2) (pos 3) (pos 1) run64
    ( pos 1 , refl )

-- 5.2  INCONSISTENT: x ≡ 3 (mod 6), x ≡ 0 (mod 4).  3 − 0 = 3, odd.
--      Refuted by §1 alone: 2 divides both moduli, so 2 would have to
--      divide 3.  This is the direction that needs no pulveriser.

2∣6 : pos 2 ∣ pos 6
2∣6 = pos 3 , refl

2∣4 : pos 2 ∣ pos 4
2∣4 = pos 2 , refl

¬2∣3 : ¬ (pos 2 ∣ pos 3)
¬2∣3 h = false≢true (trueIsEven (pos 3) h)

unsolvable64 : ¬ (Σ[ x ∈ ℤ ] Solves (pos 6) (pos 4) (pos 3) (pos 0) x)
unsolvable64 (x , sol) =
  ¬2∣3 (necessity (pos 6) (pos 4) (pos 3) (pos 0) (pos 2) x 2∣6 2∣4 sol)

------------------------------------------------------------------------
-- 6.  WHAT THIS SETTLES ABOUT THE CORPUS'S OWN BOUNDARY.
--
-- `NaturalMachine/CRTChain.agda` §"WHAT IS STILL NOT CLAIMED" records
-- coprimality as a hypothesis discharged "by computing a gcd" at each
-- concrete frontier, and calls the general case open.  At TWO moduli
-- that boundary is not where it was placed: coprimality is not needed
-- at all, it is replaceable by a side condition on the residues
-- (§1–§2), and the machinery that replaces it — `Kuttaka.bezout` — was
-- already in the repository.  What remains genuinely open is the
-- k-modulus reduction, which is Qin Jiushao's 元數→定母 step and is
-- not attempted here.
--
-- REFUSAL CONDITION.  If someone exhibits a `Run m₁ m₂ g`, residues
-- r₁ r₂ with `g ∣ (r₁ − r₂)`, and a proof that no x solves both, then
-- `sufficiency` is false and this module is wrong.  Symmetrically, an
-- x solving both together with a common divisor d of m₁ and m₂ not
-- dividing r₁ − r₂ refutes `necessity`.  Both are decidable at any
-- concrete instance and `unsolvable64` is the worked negative.
------------------------------------------------------------------------
