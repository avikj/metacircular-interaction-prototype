{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संवित् — the shared secret is Piṅgala's घात commuting with itself, and
-- its secrecy is the inverse घात that Shor also breaks.
--
-- संवित् (saṃvit) is shared knowing, mutual awareness — the exact thing a
-- key-agreement protocol manufactures between two parties who have never
-- met: a secret both KNOW and neither TRANSMITTED.  No technical sūtra is
-- claimed for the term; it is the ordinary word for common awareness,
-- chosen for what the protocol produces.
--
-- WHAT DIFFIE–HELLMAN IS.  A public commutative monoid M and a public
-- generator g.  Alice draws a secret a, publishes A = घात g a.  Bob draws
-- b, publishes B = घात g b.  Alice computes घात B a; Bob computes घात A b.
-- The protocol works iff these two agree — and the shared value is never
-- sent.  (Restated 1976; the algebra is older, see below.)
--
-- WHAT IS PROVED (over any commutative monoid; §3 needs commutativity of
-- the EXPONENTS in ℕ, which is `·-comm`, and of nothing else):
--
--   §2  संवाद : घात (घात g a) b ≡ घात (घात g b) a
--       Both sides equal घात g (a · b) resp. घात g (b · a) by Piṅgala's
--       घात-गुणः (imported from `Bijamula`, checked), and a · b ≡ b · a is
--       `·-comm`.  So the agreement is EXACTLY Piṅgala's power law closing
--       on the commutativity of multiplication.  The shared secret is
--       घात g (a·b), and each party reaches it by a different route
--       through the same identity.
--
-- SO DIFFIE–HELLMAN'S CORRECTNESS IS Piṅgala's घात-गुणः (Chandaḥśāstra
-- 8.28–31, ~300 BCE) plus a·b = b·a.  Its SECURITY is the ONE-WAYNESS of
-- घात: given g and घात g a, recover a — the discrete logarithm, the
-- inverse of the fold.  That inverse is precisely what order-finding
-- computes: Shor recovers the exponent (`Bijamula` §4), so the same
-- quantum step that lifts RSA's one hypothesis breaks DH's one secret.
-- §4 states the reduction shape; the quantum step is NOT proved (owed,
-- as in `Bijamula`).
--
-- THE UNIFICATION, stated because it is the night's spine.  `MalaSetu`
-- showed घात is the free-monoid fold; `Bijamula` showed RSA is that fold
-- plus the pulverizer; this shows DH is that fold commuting with itself.
-- Encryption (RSA), key-agreement (DH), the vallī trace, and the metre
-- are one homomorphism out of a free monoid, and every one of these
-- cryptosystems is broken at the SAME place: the inverse of घात.
--
-- WHAT IS **NOT** CLAIMED:
--   * That Diffie, Hellman, or Merkle knew Piṅgala.  The algebra of
--     घात-गुणः is Piṅgala's; the protocol built on it is 1976.  The claim
--     is provenance of the MECHANISM, not of the protocol.
--   * Any hardness of the discrete log (it is the security ASSUMPTION,
--     stated, not proved — proving it would settle far more than DH).
--   * Shor's quantum order-finding (owed, as in Bijamula §4).
--   * That M is a group or finite.  Unused; a commutative monoid suffices
--     for correctness (security needs more, and is not formalised).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Mula.Samvit_TheSharedSecretIsPingalasPowerCommutingWithItselfAndItsSecrecyIsTheInverseShorBreaks where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _·_)
open import Cubical.Data.Nat.Properties using (·-comm)

open import Mula.Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation
  using (CMonoid ; घात ; घात-गुणः)

private
  variable
    ℓ : Level

module _ {M : Type ℓ} (CM : CMonoid M) where

  ------------------------------------------------------------------------
  -- §1  घात at this monoid (Bijamula's, reused).
  ------------------------------------------------------------------------

  pow : M → ℕ → M
  pow = घात CM

  ------------------------------------------------------------------------
  -- §2  The agreement.  Alice: pow (pow g a) b.  Bob: pow (pow g b) a.
  ------------------------------------------------------------------------

  संवाद : (g : M) (a b : ℕ)
        → pow (pow g a) b ≡ pow (pow g b) a
  संवाद g a b =
      sym (घात-गुणः CM g a b)        -- pow (pow g a) b ≡ pow g (a · b)
    ∙ cong (pow g) (·-comm a b)       -- ≡ pow g (b · a)
    ∙ घात-गुणः CM g b a               -- ≡ pow (pow g b) a

  -- the shared secret, named: both parties reach घात g (a·b)
  साधारणम् : (g : M) (a b : ℕ) → M
  साधारणम् g a b = pow g (a · b)

  आलिस्-सिद्धिः : (g : M) (a b : ℕ) → pow (pow g a) b ≡ साधारणम् g a b
  आलिस्-सिद्धिः g a b = sym (घात-गुणः CM g a b)

  बॉब्-सिद्धिः : (g : M) (a b : ℕ) → pow (pow g b) a ≡ साधारणम् g a b
  बॉब्-सिद्धिः g a b = sym (घात-गुणः CM g b a) ∙ cong (pow g) (·-comm b a)

------------------------------------------------------------------------
-- §4  The break, as a reduction shape.  DH's secret a is recoverable iff
--     the discrete log of `pow g a` is — the inverse of घात.  Given the
--     exponent a (which order-finding yields), the shared secret is one
--     more घात.  So the secret is exactly one घात-inverse away, and that
--     inverse is Shor's territory (Bijamula §4); the quantum step is not
--     proved here.
--
--     Stated as: if an oracle returns the exponent a from A = pow g a,
--     then the shared secret साधारणम् g a b follows from the public B by
--     one घात — no secret channel used.
------------------------------------------------------------------------

module _ {M : Type ℓ} (CM : CMonoid M) where

  -- if the discrete-log oracle hands back a from A ≡ pow g a, and B is
  -- Bob's public pow g b, then pow B a is the shared secret.  (Pure
  -- corollary of §2's Bob-route; the CONTENT is that only PUBLIC data
  -- and the recovered exponent are used.)
  भेदनम् : (g A B : M) (a b : ℕ)
         → A ≡ pow CM g a
         → B ≡ pow CM g b
         → pow CM B a ≡ साधारणम् CM g a b
  भेदनम् g A B a b _ Beq =
      cong (λ z → pow CM z a) Beq       -- pow B a ≡ pow (pow g b) a
    ∙ बॉब्-सिद्धिः CM g a b             -- ≡ साधारणम् g a b
