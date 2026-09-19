{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡∞‡‡‡ ‚î ‡‡®‡ï‡‡‡Ø ‡‡µ‡∞‡‡‡ ‡‡∞‡‡µ‡æ‡ ‡ò‡æ‡‡ ‡®‡æ‡‡Ø‡‡ø ‡
--
-- (the turning: the generator's own order annihilates every power of it,
--  so RSA's single hypothesis is discharged where RSA actually lives.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SUCCESSOR THIS FILE PAYS, NAMED BY THE MODULE THAT OWED IT.
--
-- `Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIs
-- PingalasExponentiation.agda` isolates RSA to one fact and says so
-- exactly:
--
--     "SO THE ONLY NUMBER THEORY IN RSA IS `pow x œ ‚â° Œµ`.  Everything
--      else is Pigala's fold and ryabhaa's witness, both already
--      checked."
--
-- It is the hypothesis, not a lemma ‚î deliberately, because the point is that
-- RSA's correctness isolates to exactly this one fact. Proving it (order
-- divides œ, Lagrange) is a clean owed successor."*
--
-- ¬ß‡® is that successor, in the one case where it is one line ‚î and that
-- case is not a toy.  `BijamulaKrida_‚¶agda` establishes the ground:
-- (‚/n)À for a semiprime is a product of two CYCLIC groups, so a cyclic
-- factor is one CRT component of a real decryption, and it is where the
-- exponentiation computes at all.  So discharging the hypothesis on a
-- cyclic group discharges it exactly where that lane says RSA lives.
--
-- WHY IT IS ONE LINE.  In a cyclic group every element is a power of the
-- generator, and Pigala's two exponent laws are already proved in the
-- sibling module.  `‡ò‡æ‡ (‡ò‡æ‡ g k) n` reassociates to `‡ò‡æ‡ (‡ò‡æ‡ g n) k`
-- through commutativity of ‚ï-multiplication, the hypothesis collapses the
-- inner term to Œµ, and `‡ò‡æ‡-Œµ` finishes.  Lagrange is not needed here
-- because a cyclic group's element orders divide the generator's order by
-- the arithmetic of exponents rather than by counting cosets ‚î which is
-- the whole reason this case is separable from the general one.
--
--   * LAGRANGE, or Euler's theorem for a general finite group.  Not
--     proved, not approached.  The general case needs cosets and
--     cardinality; nothing below counts anything.  ¬ß‡® is the cyclic case
--     and is stated as the cyclic case.
--   * THAT (‚/n)À IS CYCLIC-BY-CRT.  Cited in `BijamulaKrida`'s header as
--     a classical fact and not proved in either file.  ¬ß‡© therefore
--     discharges RSA's hypothesis for a group GIVEN as cyclic; it does not
--     establish that any particular RSA modulus supplies one.
--   * ANYTHING ABOUT ORDER-FINDING OR SHOR.  The sibling states that this
--     same fact is where Shor drives the wedge ‚î security rests on œ(n)
--     being hard without the factorisation, and order-finding gets the
--     order directly, after which the factor falls out by a gcd, which is
--     the kuaka again.  Nothing here bears on that, in either
--     direction: discharging the hypothesis makes RSA's CORRECTNESS
--     unconditional on a cyclic group and says nothing whatever about its
--     SECURITY.  Correctness and hardness are different statements and
--     conflating them here would be the graver error.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ON THE NAME.  ‡‡µ‡∞‡‡ ‚î a turning, a revolution, a whirl; ordinary
-- , used here in its plain sense for a group that comes back to
-- where it started.  **NO SOURCE IS CLAIMED FOR IT AS A TECHNICAL TERM**,
-- and the compound in the title is built here.  ‡ò‡æ‡ (exponentiation as a
-- fold) is Pigala's procedure, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ (~300 BCE), and the
-- kuaka whose witness supplies e¬d ‚â° œ¬k+1 is ryabhaa's,
-- ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡ ‡ó‡‡ø‡‡‡æ‡¶‡ ‡©‡®‚ì‡©‡© (499) ‚î both cited from the sibling module and
-- from this repository's own MulaVakya ledger, second-hand, owed at verse
-- level.  The group theory is not Indian and is not dressed as Indian:
-- CLAUDE.md's naming note 2 says to state that rather than invent a label,
-- and it is stated.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avarta_TheGeneratorsOrderAnnihilatesEveryPowerSoEulersHypothesisIsDischargedOnACyclicGroup where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; _+_ ; _¬∑_)
open import Cubical.Data.Nat.Properties using (¬∑-comm)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)

open import Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation
  using (CMonoid ; ‡§ò‡§æ‡§§ ; ‡§ò‡§æ‡§§-Œµ ; ‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É ; ‡§¨‡•Ä‡§ú‡§Æ‡•Ç‡§≤-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø)

private
  variable
    ‚Ñì : Level

module _ {M : Type ‚Ñì} (CM : CMonoid M) where
  open CMonoid CM

  ------------------------------------------------------------------------
  -- ‡ß ¬ ‡‡µ‡∞‡‡‡ ‚î a cyclic group, as the data that makes it one: a
  --     generator, its order, and the fact that every element is a power
  --     of it.  Stated as a record of hypotheses rather than assumed of
  --     the ambient monoid, so ¬ß‡® says exactly what it needs.
  ------------------------------------------------------------------------

  ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É : M ‚Üí ‚Ñï ‚Üí Type ‚Ñì
  ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É g n = (‡§ò‡§æ‡§§ CM g n ‚â° Œµ) √ó ((x : M) ‚Üí Œ£[ k ‚àà ‚Ñï ] (‡§ò‡§æ‡§§ CM g k ‚â° x))
    where open import Cubical.Data.Sigma using (_√ó_)

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡Ø‡‡≤‡∞-‡‡ø‡¶‡‡ß‡ø‡ ‚î THE HYPOTHESIS, DISCHARGED.
  --
  --     Every element of a cyclic group is annihilated by the generator's
  --     own order.  No counting, no cosets: the element is `‡ò‡æ‡ g k`, and
  --     `‡ò‡æ‡ (‡ò‡æ‡ g k) n ‚â° ‡ò‡æ‡ (‡ò‡æ‡ g n) k` by the commutativity of
  --     ‚ï-multiplication inside Pigala's second exponent law.
  ------------------------------------------------------------------------

  ‡§ú‡§®‡§ï-‡§Ü‡§µ‡§∞‡•ç‡§§‡§É : (g : M) (n : ‚Ñï) ‚Üí ‡§ò‡§æ‡§§ CM g n ‚â° Œµ
             ‚Üí (k : ‚Ñï) ‚Üí ‡§ò‡§æ‡§§ CM (‡§ò‡§æ‡§§ CM g k) n ‚â° Œµ
  ‡§ú‡§®‡§ï-‡§Ü‡§µ‡§∞‡•ç‡§§‡§É g n gn‚â°Œµ k =
      sym (‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g k n)                    -- ‡§ò‡§æ‡§§ (‡§ò‡§æ‡§§ g k) n ‚â° ‡§ò‡§æ‡§§ g (k¬∑n)
    ‚àô cong (‡§ò‡§æ‡§§ CM g) (¬∑-comm k n)                -- ‚â° ‡§ò‡§æ‡§§ g (n¬∑k)
    ‚àô ‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g n k                           -- ‚â° ‡§ò‡§æ‡§§ (‡§ò‡§æ‡§§ g n) k
    ‚àô cong (Œª z ‚Üí ‡§ò‡§æ‡§§ CM z k) gn‚â°Œµ                -- ‚â° ‡§ò‡§æ‡§§ Œµ k
    ‚àô ‡§ò‡§æ‡§§-Œµ CM k                                  -- ‚â° Œµ

  -- and therefore of EVERY element, once every element is known to be a
  -- power of the generator
  ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É : (g : M) (n : ‚Ñï) ‚Üí ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É g n ‚Üí (x : M) ‚Üí ‡§ò‡§æ‡§§ CM x n ‚â° Œµ
  ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É g n (gn‚â°Œµ , surj) x =
    cong (Œª z ‚Üí ‡§ò‡§æ‡§§ CM z n) (sym (snd (surj x)))
    ‚àô ‡§ú‡§®‡§ï-‡§Ü‡§µ‡§∞‡•ç‡§§‡§É g n gn‚â°Œµ (fst (surj x))

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡‡‡‡Æ‡‡≤-‡‡ø‡¶‡‡ß‡ø‡-‡®‡ø‡∞‡‡‡æ‡ß‡ø‡ï‡æ ‚î RSA correctness with NO Euler
  --     hypothesis, on a cyclic group.
  --
  --     The sibling's theorem takes `‡ò‡æ‡ x œ ‚â° Œµ` as an argument.  Here
  --     it is supplied by ¬ß‡®, so what remains to be given is exactly
  --     ryabhaa's witness ‚î e¬d ‚â° œ¬k+1 ‚î and nothing else.  That is the
  --     sentence "the only number theory in RSA is pow x œ ‚â° Œµ" turned
  --     around: on this ground there is none left, and the whole of RSA is
  --     Pigala's fold plus the pulverizer's witness.
  ------------------------------------------------------------------------

  ‡§¨‡•Ä‡§ú‡§Æ‡•Ç‡§≤-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É-‡§®‡§ø‡§∞‡•Å‡§™‡§æ‡§ß‡§ø‡§ï‡§æ
    : (g : M) (œÜ : ‚Ñï) ‚Üí ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É g œÜ
    ‚Üí (x : M) (e d k : ‚Ñï) ‚Üí e ¬∑ d ‚â° œÜ ¬∑ k + 1
    ‚Üí ‡§ò‡§æ‡§§ CM (‡§ò‡§æ‡§§ CM x e) d ‚â° x
  ‡§¨‡•Ä‡§ú‡§Æ‡•Ç‡§≤-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É-‡§®‡§ø‡§∞‡•Å‡§™‡§æ‡§ß‡§ø‡§ï‡§æ g œÜ cyc x e d k witness =
    ‡§¨‡•Ä‡§ú‡§Æ‡•Ç‡§≤-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø CM x e d œÜ k witness (‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É g œÜ cyc x)
