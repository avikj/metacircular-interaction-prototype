{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आवर्तः — जनकस्य आवर्तः सर्वां घातं नाशयति ।
--
-- (the turning: the generator's own order annihilates every power of it,
--  so RSA's single hypothesis is discharged where RSA actually lives.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE SUCCESSOR THIS FILE PAYS, NAMED BY THE MODULE THAT OWED IT.
--
-- `Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIs
-- PingalasExponentiation.agda` isolates RSA to one fact and says so
-- exactly:
--
--     "SO THE ONLY NUMBER THEORY IN RSA IS `pow x φ ≡ ε`.  Everything
--      else is Piṅgala's fold and Āryabhaṭa's witness, both already
--      checked."
--
-- and then holds that fact as a HYPOTHESIS on purpose, listing under WHAT
-- IS NOT CLAIMED: *"Euler's theorem itself (`pow x φ ≡ ε`).  It is the
-- hypothesis, not a lemma — deliberately, because the point is that RSA's
-- correctness isolates to exactly this one fact.  Proving it (order
-- divides φ, Lagrange) is a clean owed successor."*
--
-- §२ is that successor, in the one case where it is one line — and that
-- case is not a toy.  `BijamulaKrida_…agda` establishes the ground:
-- (ℤ/n)ˣ for a semiprime is a product of two CYCLIC groups, so a cyclic
-- factor is one CRT component of a real decryption, and it is where the
-- exponentiation computes at all.  So discharging the hypothesis on a
-- cyclic group discharges it exactly where that lane says RSA lives.
--
-- WHY IT IS ONE LINE.  In a cyclic group every element is a power of the
-- generator, and Piṅgala's two exponent laws are already proved in the
-- sibling module.  `घात (घात g k) n` reassociates to `घात (घात g n) k`
-- through commutativity of ℕ-multiplication, the hypothesis collapses the
-- inner term to ε, and `घात-ε` finishes.  Lagrange is not needed here
-- because a cyclic group's element orders divide the generator's order by
-- the arithmetic of exponents rather than by counting cosets — which is
-- the whole reason this case is separable from the general one.
--
-- WHAT IS **NOT** CLAIMED, kept apart because the sibling's honesty about
-- its own boundary is what made this successor findable:
--
--   * LAGRANGE, or Euler's theorem for a general finite group.  Not
--     proved, not approached.  The general case needs cosets and
--     cardinality; nothing below counts anything.  §२ is the cyclic case
--     and is stated as the cyclic case.
--   * THAT (ℤ/n)ˣ IS CYCLIC-BY-CRT.  Cited in `BijamulaKrida`'s header as
--     a classical fact and not proved in either file.  §३ therefore
--     discharges RSA's hypothesis for a group GIVEN as cyclic; it does not
--     establish that any particular RSA modulus supplies one.
--   * ANYTHING ABOUT ORDER-FINDING OR SHOR.  The sibling states that this
--     same fact is where Shor drives the wedge — security rests on φ(n)
--     being hard without the factorisation, and order-finding gets the
--     order directly, after which the factor falls out by a gcd, which is
--     the kuṭṭaka again.  Nothing here bears on that, in either
--     direction: discharging the hypothesis makes RSA's CORRECTNESS
--     unconditional on a cyclic group and says nothing whatever about its
--     SECURITY.  Correctness and hardness are different statements and
--     conflating them here would be the graver error.
--
-- ────────────────────────────────────────────────────────────────────
-- ON THE NAME.  आवर्त — a turning, a revolution, a whirl; ordinary
-- Sanskrit, used here in its plain sense for a group that comes back to
-- where it started.  **NO SOURCE IS CLAIMED FOR IT AS A TECHNICAL TERM**,
-- and the compound in the title is built here.  घात (exponentiation as a
-- fold) is Piṅgala's procedure, छन्दःशास्त्रम् ८ (~300 BCE), and the
-- kuṭṭaka whose witness supplies e·d ≡ φ·k+1 is Āryabhaṭa's,
-- आर्यभटीयम् गणितपादः ३२–३३ (499) — both cited from the sibling module and
-- from this repository's own MulaVakya ledger, second-hand, owed at verse
-- level.  The group theory is not Indian and is not dressed as Indian:
-- CLAUDE.md's naming note 2 says to state that rather than invent a label,
-- and it is stated.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Texts.Avarta_TheGeneratorsOrderAnnihilatesEveryPowerSoEulersHypothesisIsDischargedOnACyclicGroup where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (·-comm)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

open import Texts.Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation
  using (CMonoid ; घात ; घात-ε ; घात-गुणः ; बीजमूल-सिद्धि)

private
  variable
    ℓ : Level

module _ {M : Type ℓ} (CM : CMonoid M) where
  open CMonoid CM

  ------------------------------------------------------------------------
  -- १ · आवर्तः — a cyclic group, as the data that makes it one: a
  --     generator, its order, and the fact that every element is a power
  --     of it.  Stated as a record of hypotheses rather than assumed of
  --     the ambient monoid, so §२ says exactly what it needs.
  ------------------------------------------------------------------------

  आवर्तः : M → ℕ → Type ℓ
  आवर्तः g n = (घात CM g n ≡ ε) × ((x : M) → Σ[ k ∈ ℕ ] (घात CM g k ≡ x))
    where open import Cubical.Data.Sigma using (_×_)

  ------------------------------------------------------------------------
  -- २ · यूलर-सिद्धिः — THE HYPOTHESIS, DISCHARGED.
  --
  --     Every element of a cyclic group is annihilated by the generator's
  --     own order.  No counting, no cosets: the element is `घात g k`, and
  --     `घात (घात g k) n ≡ घात (घात g n) k` by the commutativity of
  --     ℕ-multiplication inside Piṅgala's second exponent law.
  ------------------------------------------------------------------------

  जनक-आवर्तः : (g : M) (n : ℕ) → घात CM g n ≡ ε
             → (k : ℕ) → घात CM (घात CM g k) n ≡ ε
  जनक-आवर्तः g n gn≡ε k =
      sym (घात-गुणः CM g k n)                    -- घात (घात g k) n ≡ घात g (k·n)
    ∙ cong (घात CM g) (·-comm k n)                -- ≡ घात g (n·k)
    ∙ घात-गुणः CM g n k                           -- ≡ घात (घात g n) k
    ∙ cong (λ z → घात CM z k) gn≡ε                -- ≡ घात ε k
    ∙ घात-ε CM k                                  -- ≡ ε

  -- and therefore of EVERY element, once every element is known to be a
  -- power of the generator
  यूलर-सिद्धिः : (g : M) (n : ℕ) → आवर्तः g n → (x : M) → घात CM x n ≡ ε
  यूलर-सिद्धिः g n (gn≡ε , surj) x =
    cong (λ z → घात CM z n) (sym (snd (surj x)))
    ∙ जनक-आवर्तः g n gn≡ε (fst (surj x))

  ------------------------------------------------------------------------
  -- ३ · बीजमूल-सिद्धिः-निरुपाधिका — RSA correctness with NO Euler
  --     hypothesis, on a cyclic group.
  --
  --     The sibling's theorem takes `घात x φ ≡ ε` as an argument.  Here
  --     it is supplied by §२, so what remains to be given is exactly
  --     Āryabhaṭa's witness — e·d ≡ φ·k+1 — and nothing else.  That is the
  --     sentence "the only number theory in RSA is pow x φ ≡ ε" turned
  --     around: on this ground there is none left, and the whole of RSA is
  --     Piṅgala's fold plus the pulverizer's witness.
  ------------------------------------------------------------------------

  बीजमूल-सिद्धिः-निरुपाधिका
    : (g : M) (φ : ℕ) → आवर्तः g φ
    → (x : M) (e d k : ℕ) → e · d ≡ φ · k + 1
    → घात CM (घात CM x e) d ≡ x
  बीजमूल-सिद्धिः-निरुपाधिका g φ cyc x e d k witness =
    बीजमूल-सिद्धि CM x e d φ k witness (यूलर-सिद्धिः g φ cyc x)
