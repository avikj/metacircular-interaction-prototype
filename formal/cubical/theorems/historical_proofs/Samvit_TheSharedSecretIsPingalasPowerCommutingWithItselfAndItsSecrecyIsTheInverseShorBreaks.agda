{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡µ‡ø‡‡ ‚î the shared secret is Pigala's ‡ò‡æ‡ commuting with itself, and
-- its secrecy is the inverse ‡ò‡æ‡ that Shor also breaks.
--
-- ‡‡‡µ‡ø‡‡ (savit) is shared knowing, mutual awareness ‚î the exact thing a
-- key-agreement protocol manufactures between two parties who have never
-- met: a secret both KNOW and neither TRANSMITTED.  No technical stra is
-- claimed for the term; it is the ordinary word for common awareness,
-- chosen for what the protocol produces.
--
-- WHAT DIFFIE‚ìHELLMAN IS.  A public commutative monoid M and a public
-- generator g.  Alice draws a secret a, publishes A = ‡ò‡æ‡ g a.  Bob draws
-- b, publishes B = ‡ò‡æ‡ g b.  Alice computes ‡ò‡æ‡ B a; Bob computes ‡ò‡æ‡ A b.
-- The protocol works iff these two agree ‚î and the shared value is never
-- sent.  (Restated 1976; the algebra is older, see below.)
--
-- WHAT IS PROVED (over any commutative monoid; ¬ß3 needs commutativity of
-- the EXPONENTS in ‚ï, which is `¬-comm`, and of nothing else):
--
--   ¬ß2  ‡‡‡µ‡æ‡¶ : ‡ò‡æ‡ (‡ò‡æ‡ g a) b ‚â° ‡ò‡æ‡ (‡ò‡æ‡ g b) a
--       Both sides equal ‡ò‡æ‡ g (a ¬ b) resp. ‡ò‡æ‡ g (b ¬ a) by Pigala's
--       ‡ò‡æ‡-‡ó‡‡‡ (imported from `Bijamula`, checked), and a ¬ b ‚â° b ¬ a is
--       `¬-comm`.  So the agreement is EXACTLY Pigala's power law closing
--       on the commutativity of multiplication.  The shared secret is
--       ‡ò‡æ‡ g (a¬b), and each party reaches it by a different route
--       through the same identity.
--
-- SO DIFFIE‚ìHELLMAN'S CORRECTNESS IS Pigala's ‡ò‡æ‡-‡ó‡‡‡ (Chandastra
-- 8.28‚ì31, ~300 BCE) plus a¬b = b¬a.  Its SECURITY is the ONE-WAYNESS of
-- ‡ò‡æ‡: given g and ‡ò‡æ‡ g a, recover a ‚î the discrete logarithm, the
-- inverse of the fold.  That inverse is precisely what order-finding
-- computes: Shor recovers the exponent (`Bijamula` ¬ß4), so the same
-- quantum step that lifts RSA's one hypothesis breaks DH's one secret.
-- ¬ß4 states the reduction shape; the quantum step is NOT proved (owed,
-- as in `Bijamula`).
--
-- THE UNIFICATION, stated because it is the night's spine.  `MalaSetu`
-- showed ‡ò‡æ‡ is the free-monoid fold; `Bijamula` showed RSA is that fold
-- plus the pulverizer; this shows DH is that fold commuting with itself.
-- Encryption (RSA), key-agreement (DH), the vall trace, and the metre
-- are one homomorphism out of a free monoid, and every one of these
-- cryptosystems is broken at the SAME place: the inverse of ‡ò‡æ‡.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Samvit_TheSharedSecretIsPingalasPowerCommutingWithItselfAndItsSecrecyIsTheInverseShorBreaks where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; _¬∑_)
open import Cubical.Data.Nat.Properties using (¬∑-comm)

open import Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation
  using (CMonoid ; ‡§ò‡§æ‡§§ ; ‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É)

private
  variable
    ‚Ñì : Level

module _ {M : Type ‚Ñì} (CM : CMonoid M) where

  ------------------------------------------------------------------------
  -- ¬ß1  ‡ò‡æ‡ at this monoid (Bijamula's, reused).
  ------------------------------------------------------------------------

  pow : M ‚Üí ‚Ñï ‚Üí M
  pow = ‡§ò‡§æ‡§§ CM

  ------------------------------------------------------------------------
  -- ¬ß2  The agreement.  Alice: pow (pow g a) b.  Bob: pow (pow g b) a.
  ------------------------------------------------------------------------

  ‡§∏‡§Ç‡§µ‡§æ‡§¶ : (g : M) (a b : ‚Ñï)
        ‚Üí pow (pow g a) b ‚â° pow (pow g b) a
  ‡§∏‡§Ç‡§µ‡§æ‡§¶ g a b =
      sym (‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g a b)        -- pow (pow g a) b ‚â° pow g (a ¬∑ b)
    ‚àô cong (pow g) (¬∑-comm a b)       -- ‚â° pow g (b ¬∑ a)
    ‚àô ‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g b a               -- ‚â° pow (pow g b) a

  -- the shared secret, named: both parties reach ‡ò‡æ‡ g (a¬b)
  ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç : (g : M) (a b : ‚Ñï) ‚Üí M
  ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç g a b = pow g (a ¬∑ b)

  ‡§Ü‡§≤‡§ø‡§∏‡•ç-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É : (g : M) (a b : ‚Ñï) ‚Üí pow (pow g a) b ‚â° ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç g a b
  ‡§Ü‡§≤‡§ø‡§∏‡•ç-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É g a b = sym (‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g a b)

  ‡§¨‡•â‡§¨‡•ç-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É : (g : M) (a b : ‚Ñï) ‚Üí pow (pow g b) a ‚â° ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç g a b
  ‡§¨‡•â‡§¨‡•ç-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É g a b = sym (‡§ò‡§æ‡§§-‡§ó‡•Å‡§£‡§É CM g b a) ‚àô cong (pow g) (¬∑-comm b a)

------------------------------------------------------------------------
-- ¬ß4  The break, as a reduction shape.  DH's secret a is recoverable iff
--     the discrete log of `pow g a` is ‚î the inverse of ‡ò‡æ‡.  Given the
--     exponent a (which order-finding yields), the shared secret is one
--     more ‡ò‡æ‡.  So the secret is exactly one ‡ò‡æ‡-inverse away, and that
--     inverse is Shor's territory (Bijamula ¬ß4); the quantum step is not
--     proved here.
--
--     Stated as: if an oracle returns the exponent a from A = pow g a,
--     then the shared secret ‡‡æ‡ß‡æ‡∞‡‡Æ‡ g a b follows from the public B by
--     one ‡ò‡æ‡ ‚î no secret channel used.
------------------------------------------------------------------------

module _ {M : Type ‚Ñì} (CM : CMonoid M) where

  -- if the discrete-log oracle hands back a from A ‚â° pow g a, and B is
  -- Bob's public pow g b, then pow B a is the shared secret.  (Pure
  -- corollary of ¬ß2's Bob-route; the CONTENT is that only PUBLIC data
  -- and the recovered exponent are used.)
  ‡§≠‡•á‡§¶‡§®‡§Æ‡•ç : (g A B : M) (a b : ‚Ñï)
         ‚Üí A ‚â° pow CM g a
         ‚Üí B ‚â° pow CM g b
         ‚Üí pow CM B a ‚â° ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç CM g a b
  ‡§≠‡•á‡§¶‡§®‡§Æ‡•ç g A B a b _ Beq =
      cong (Œª z ‚Üí pow CM z a) Beq       -- pow B a ‚â° pow (pow g b) a
    ‚àô ‡§¨‡•â‡§¨‡•ç-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É CM g a b             -- ‚â° ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§Æ‡•ç g a b
