{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Naya_EvalIsOneStandpointAndASecondOneProvesTheInduction
--              RuleIsStrictlyStrongerThanTheRewriteClosure
--
-- TERM, AND THE SCHOOL IS JAINA, NAMED BEFORE THE TERM IS USED.
--
-- ‡®‡Ø ¬ naya -- a standpoint: a determination of an object from one aspect,
-- valid within its scope and never exhausting the object.  Umsvti's
-- *Tattvrthastra* gives the list, and I give the words rather than the
-- number because the recensions disagree on the numbering (vetmbara 1.34
-- against Digambara 1.33) and because a stra's number propagates through
-- citation while its words appear only where someone opened the text:
--
--     ‡®‡à‡ó‡Æ‡‡‡ó‡‡∞‡‡µ‡‡Ø‡µ‡‡æ‡∞‡∞‡‡‡‡‡‡‡‡∞‡‡‡‡¶‡‡Æ‡‡ø‡∞‡‡‡à‡µ‡‡‡‡‡æ ‡®‡Ø‡æ‡
--     naigama-sagraha-vyavahra-justra-abda-samabhirha-evabht nay
--
-- Siddhasena Divkara, *Sanmatitarka*, reduces them to two roots,
-- dravyrthika and paryyrthika; Mallavdin's *Dvdaranayacakra*
-- (~6th c.) runs twelve of them against each other.  The governing rule is
-- that a naya asserting itself by DENYING the others becomes a ‡¶‡‡∞‡‡®‡Ø ¬
-- durnaya.  No date of first use is established here.
--
-- `eval` INTO ‚ï IS ONE STANDPOINT AMONG MANY, not THE semantics.
-- `Ankapasa_‚¶` builds
--
--     ‚ü¶_‚üß : Tm ‚í TEnv ‚í Type‚     zero ‚¶ ‚ä, suc ‚¶ Unit ‚ä ‚àí, add ‚¶ ‚ä
--
-- a UNIVERSE-valued semantics of this same calculus, in which every `Step`
-- constructor becomes an equivalence and `reverse` becomes `invEquiv`; it
-- proves `counting-semantics-cannot-see-it` against
-- `univalent-semantics-does-see-it`, and names the diagnosis ‡®‡Ø-‡®‡ø‡∞‡ã‡ß‡.
-- It reaches the fact from the akapa side; `grep -rlE ': *Tm *‚í'
-- formal/cubical` returns twenty files reading `Tm` into other codomains.
--
-- THE MATHEMATICAL CONTENT, bracketed by the two standpoints:
--   * `Ankapasa_`'s model VALIDATES commutativity -- `add ‚¶ ‚ä` and
--     `‚ä-swap-‚â` -- and separates it from the identity.  ¬ß3 below REFUTES
--     it: no derivation exists at all.  Non-triviality and underivability
--     are different theorems and neither implies the other.
--   * Nothing in `Ankapasa_` bears on left-unitality or on induction, and
--     ¬ß4 is untouched by it.
--   * TOGETHER the two bracket the fact, which neither does alone:
--     commutativity of `add` IS NOT DERIVABLE, and once added IT IS NOT
--     TRIVIAL.  That is two nayas on one object, arrived at separately,
--     neither reducible to the other -- which is the doctrine, not a
--     consolation.
--
-- So the diagnosis this file offers is narrower than the struck sentence:
-- not that the corpus had one standpoint, but that ‚ï was the standpoint
-- from which the questions in ¬ß3 and ¬ß4 had not been asked, and that a
-- second one three lines long decides them.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `Vyabhicara_‚¶` gives the instrument for underivability that ‚ï supports:
-- deviation at one environment forbids a derivation.  Its own header names
-- what it cannot reach -- a pair TRUE AT EVERY ENVIRONMENT and still
-- underivable, with commutativity of `add` as the candidate.
--
-- And the larger thing standing open behind it: `RewriteCertificate`
-- carries `HypStep`, `HypDerivation`, `InductionCertificate` and
-- `induction-sound` -- a whole induction apparatus, sound, and consumed by
-- NOTHING.  Whether it is redundant machinery or strictly necessary was
-- never decided.  ¬ß4 decides it.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   ¬ß1  A second model: the free-monoid-like structure W with `p`, which
--       is right-unital and successor-compatible -- so BOTH axioms hold,
--       by `refl` -- and is neither commutative nor left-unital.
--   ¬ß2  Soundness at that standpoint, all six `Step` constructors.
--   ¬ß3  not-commutative, not-left-unital.  Two underivabilities, neither
--       reachable from ‚ï, both of statements TRUE in ‚ï.
--   ¬ß4  THE GAP, AS A THEOREM.  `leftZero-cert` is an induction
--       certificate for `0 + x = x`; `induction-sound` discharges it at
--       every environment; and ¬ß3 says no derivation exists.  Therefore
--       THE INDUCTION RULE IS STRICTLY STRONGER THAN THE REWRITE CLOSURE,
--       and the kernel can certify theorems it cannot install, since
--       `NativeOperation.checked` demands a `Derivation`.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Naya_EvalIsOneStandpointAndASecondOneProvesTheInductionRuleIsStrictlyStrongerThanTheRewriteClosure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; _++_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
import Cubical.Data.Empty as E

open import RewriteCertificate

------------------------------------------------------------------------
-- ¬ß1.  THE SECOND STANDPOINT.
--
-- The two axioms constrain `add` only where the right argument is `zero`
-- or a `suc`.  At an opaque right argument they say nothing at all, and ‚ï
-- silently fills that freedom with commutativity.  Here it is filled
-- differently: a marker is dropped between the two sides.
------------------------------------------------------------------------

data Atom : Type‚ÇÄ where
  aX aY aZ aU aV aW aS aM : Atom

W : Type‚ÇÄ
W = List Atom

-- right-unital and successor-compatible by construction; the third clause
-- overlaps the second and fires only at a head that is not `aS`.
p : W ‚Üí W ‚Üí W
p a []       = a
p a (aS ‚à∑ b) = aS ‚à∑ p a b
p a (c ‚à∑ b)  = a ++ (aM ‚à∑ c ‚à∑ b)

‚ü¶_‚üß : Tm ‚Üí W
‚ü¶ var ‚üß     = aX ‚à∑ []
‚ü¶ yvar ‚üß    = aY ‚à∑ []
‚ü¶ zvar ‚üß    = aZ ‚à∑ []
‚ü¶ uvar ‚üß    = aU ‚à∑ []
‚ü¶ vvar ‚üß    = aV ‚à∑ []
‚ü¶ wvar ‚üß    = aW ‚à∑ []
‚ü¶ zero ‚üß    = []
‚ü¶ suc t ‚üß   = aS ‚à∑ ‚ü¶ t ‚üß
‚ü¶ add l r ‚üß = p ‚ü¶ l ‚üß ‚ü¶ r ‚üß

------------------------------------------------------------------------
-- ¬ß2.  SOUNDNESS AT THIS STANDPOINT.  Both axioms hold by `refl`, which is
--      the check that this is a model of the same theory and not a
--      different one dressed up.
------------------------------------------------------------------------

step-model : {a b : Tm} ‚Üí Step a b ‚Üí ‚ü¶ a ‚üß ‚â° ‚ü¶ b ‚üß
step-model (add-zero x)    = refl
step-model (add-suc x y)   = refl
step-model (suc-step q)    = cong (aS ‚à∑_) (step-model q)
step-model (add-left q z)  = cong (Œª w ‚Üí p w ‚ü¶ z ‚üß) (step-model q)
step-model (add-right z q) = cong (p ‚ü¶ z ‚üß) (step-model q)
step-model (reverse q)     = sym (step-model q)

derivation-model : {a b : Tm} ‚Üí Derivation a b ‚Üí ‚ü¶ a ‚üß ‚â° ‚ü¶ b ‚üß
derivation-model (done _)        = refl
derivation-model (then-step q d) = step-model q ‚àô derivation-model d

------------------------------------------------------------------------
-- ¬ß3.  TWO UNDERIVABILITIES ‚ï CANNOT REACH.  Both statements are TRUE at
--      every environment, so `Vyabhicara_‚¶`'s instrument has no grip on
--      either; this standpoint decides both.
------------------------------------------------------------------------

hd : W ‚Üí Atom
hd []      = aM
hd (a ‚à∑ _) = a

isX : Atom ‚Üí Bool
isX aX = true
isX _  = false

not-commutative : Derivation (add var yvar) (add yvar var) ‚Üí E.‚ä•
not-commutative d = true‚â¢false (cong isX (cong hd (derivation-model d)))

not-left-unital : Derivation (add zero var) var ‚Üí E.‚ä•
not-left-unital d = true‚â¢false (sym (cong isX (cong hd (derivation-model d))))

------------------------------------------------------------------------
-- ¬ß4.  THE GAP, AS A THEOREM.
--
-- `0 + x = x` is certifiable by the kernel's own induction apparatus and
-- true at every environment -- and underivable.  So `induction-sound` is
-- not redundant machinery: it proves what the rewrite closure cannot.  And
-- because `NativeOperation.checked` demands a `Derivation`, this theorem
-- CANNOT ENTER THE LIBRARY.  The kernel certifies more than it can learn.
------------------------------------------------------------------------

leftZero-cert : InductionCertificate (add zero var) var
InductionCertificate.base leftZero-cert = then-step (add-zero zero) (done zero)
InductionCertificate.step leftZero-cert =
  hyp-then (lift-step (add-suc zero var))
    (hyp-then (hyp-suc hypothesis) (hyp-done (suc var)))

leftZero-holds-everywhere : (œÅ : Env) ‚Üí eval (add zero var) œÅ ‚â° eval var œÅ
leftZero-holds-everywhere = induction-sound leftZero-cert

-- the two halves side by side, so the statement is one object.
induction-is-strictly-stronger :
  ((œÅ : Env) ‚Üí eval (add zero var) œÅ ‚â° eval var œÅ)
  √ó (Derivation (add zero var) var ‚Üí E.‚ä•)
induction-is-strictly-stronger = leftZero-holds-everywhere , not-left-unital
