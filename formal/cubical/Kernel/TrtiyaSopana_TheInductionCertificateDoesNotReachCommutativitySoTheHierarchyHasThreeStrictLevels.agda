{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.TrtiyaSopana_TheInductionCertificateDoesNotReach
--            CommutativitySoTheHierarchyHasThreeStrictLevels
--
-- ‡‡‡‡‡Ø-‡‡ã‡‡æ‡®‡Æ‡ ¬ the third step of the stair.  The compound is assembled
-- here for this module and no textual source is claimed for it.
--
-- WHERE THIS STANDS.  `Naya_‚¶` proved two things and left one question
-- between them, named in its own WHAT-IS-NOT-PROVED block by omission:
--
--   ¬ß3 there   commutativity of `add` is UNDERIVABLE          (W-model)
--   ¬ß4 there   the induction rule is STRICTLY STRONGER than
--              the rewrite closure                            (0 + x = x)
--
-- Open between them: whether the induction apparatus ‚î the strongest
-- thing in the kernel's three files ‚î reaches commutativity.  This
-- module answers: IT DOES NOT.  The same W-standpoint that decided ¬ß3
-- decides this, one level up, with no new machinery: an
-- `InductionCertificate (add var yvar) (add yvar var)` carries a `base`
-- field of type `Derivation (add zero yvar) (add yvar zero)`, and the
-- W-values of those endpoints differ at the head ‚î
--
--     ‚ü¶ add zero yvar ‚üß = aM ‚à aY ‚à []        (the marker survives)
--     ‚ü¶ add yvar zero ‚üß = aY ‚à []             (right unit, by refl)
--
-- so `derivation-model` refutes the base, hence the certificate.
--
-- THE CONSEQUENCE, stated as one object below.  Commutativity is TRUE at
-- every environment (`+-comm`), certifiable by nothing the kernel has,
-- installable a fortiori by nothing the kernel has.  With `Naya_‚¶`'s ¬ß4
-- this closes a three-level strictness:
--
--     rewrite closure  ‚ää  induction closure  ‚ää  truth in ‚ï
--
-- first strictness witnessed by `0 + x = x` (there), second by
-- `x + y = y + x` (here).  The kernel certifies more than it can
-- install, and there is truth it cannot even certify.
--
-- WHAT THIS MEANS FOR THE APPARATUS, read forward not backward: the
-- certificate form does induction on ONE coordinate (`var`), and
-- commutativity's classical proof needs a nested induction whose base
-- `0 + y = y` is itself only induction-certifiable ‚î but `base` demands
-- a `Derivation`, and by `Naya_‚¶`'s `not-left-unital` argument none
-- exists.  The wall is exactly the type of the `base` field.  A
-- certificate whose base may itself be a certificate is the repair this
-- names and does not make; whether to make it is a design decision and
-- is not taken here.
--
-- CHECKED at the repository pin, --safe, no postulates, no holes.
------------------------------------------------------------------------

module Kernel.TrtiyaSopana_TheInductionCertificateDoesNotReachCommutativitySoTheHierarchyHasThreeStrictLevels where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; _+_ ; +-comm)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
import Cubical.Data.Empty as E

open import RewriteCertificate
open import Kernel.Naya_EvalIsOneStandpointAndASecondOneProvesTheInductionRuleIsStrictlyStrongerThanTheRewriteClosure
  using (Atom ; aX ; aY ; aM ; W ; ‚ü¶_‚üß ; derivation-model ; hd)

------------------------------------------------------------------------
-- ¬ß1.  The discriminator.  ¬ß3 there used the head against aX; the base
--      of a commutativity certificate is decided by the head against aY:
--      the left side keeps the dropped marker aM, the right side is the
--      bare aY by right-unitality.
------------------------------------------------------------------------

isY : Atom ‚Üí Bool
isY aY = true
isY _  = false

------------------------------------------------------------------------
-- ¬ß2.  THE REFUTATION.  The base field's endpoints, evaluated at the
--      W-standpoint, differ at the head; a derivation between them would
--      transport that difference into true ‚â° false.
------------------------------------------------------------------------

base-refuted : Derivation (add zero yvar) (add yvar zero) ‚Üí E.‚ä•
base-refuted d = true‚â¢false (sym (cong isY (cong hd (derivation-model d))))

not-comm-certifiable :
  InductionCertificate (add var yvar) (add yvar var) ‚Üí E.‚ä•
not-comm-certifiable cert =
  base-refuted (InductionCertificate.base cert)

------------------------------------------------------------------------
-- ¬ß3.  THE THEOREM, one object: true at every environment, and beyond
--      the certificate's reach.  With Naya_‚¶'s ¬ß4 this is the third
--      level of the stair.
------------------------------------------------------------------------

comm-holds-everywhere :
  (œÅ : Env) ‚Üí eval (add var yvar) œÅ ‚â° eval (add yvar var) œÅ
comm-holds-everywhere œÅ = +-comm (Env.x œÅ) (Env.y œÅ)

certificate-does-not-reach-truth :
  ((œÅ : Env) ‚Üí eval (add var yvar) œÅ ‚â° eval (add yvar var) œÅ)
  √ó (InductionCertificate (add var yvar) (add yvar var) ‚Üí E.‚ä•)
certificate-does-not-reach-truth =
  comm-holds-everywhere , not-comm-certifiable
