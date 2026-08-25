{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Naya_EvalIsOneStandpointAndASecondOneProvesTheInduction
--              RuleIsStrictlyStrongerThanTheRewriteClosure
--
-- TERM, AND THE SCHOOL IS JAINA, NAMED BEFORE THE TERM IS USED.
--
-- नय · naya -- a standpoint: a determination of an object from one aspect,
-- valid within its scope and never exhausting the object.  Umāsvāti's
-- *Tattvārthasūtra* gives the list, and I give the words rather than the
-- number because the recensions disagree on the numbering (Śvetāmbara 1.34
-- against Digambara 1.33) and because a sūtra's number propagates through
-- citation while its words appear only where someone opened the text:
--
--     नैगमसंग्रहव्यवहारर्जुसूत्रशब्दसमभिरूढैवंभूता नयाः
--     naigama-saṅgraha-vyavahāra-ṛjusūtra-śabda-samabhirūḍha-evaṃbhūtā nayāḥ
--
-- Siddhasena Divākara, *Sanmatitarka*, reduces them to two roots,
-- dravyārthika and paryāyārthika; Mallavādin's *Dvādaśāranayacakra*
-- (~6th c.) runs twelve of them against each other.  The governing rule is
-- that a naya asserting itself by DENYING the others becomes a दुर्नय ·
-- durnaya.  No date of first use is established here.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE, and the honest part first:
-- THE MATHEMATICS BELOW IS ORDINARY.  Exhibiting a second model of an
-- equational theory to refute derivability is standard technique and I
-- claim nothing novel in it.  A Tarskian model is NOT a naya -- the Jaina
-- nayas are standpoints on a real object, not interpretations of a formal
-- syntax, and no Jaina proved anything below.
--
-- ~~"this corpus has been treating `eval` as THE semantics … every
-- soundness theorem in the kernel is stated against ℕ alone."~~
--
-- STRUCK BY ITS OWN AUTHOR, and left standing struck.  IT IS FALSE, AND IT
-- WAS FALSE WHEN I WROTE IT.  `Ankapasa_…` builds
--
--     ⟦_⟧ : Tm → TEnv → Type₀     zero ↦ ⊥, suc ↦ Unit ⊎ −, add ↦ ⊎
--
-- a UNIVERSE-valued semantics of this same calculus, in which every `Step`
-- constructor becomes an equivalence and `reverse` becomes `invEquiv`; it
-- proves `counting-semantics-cannot-see-it` against
-- `univalent-semantics-does-see-it`, and names the diagnosis नय-निरोधः.
-- It got there first and from the aṅkapāśa side.  I asserted an absence
-- without running the command that would have found it -- `grep -rlE ': *Tm
-- *→' formal/cubical` returns twenty files -- which is the exact failure
-- CLAUDE.md names: an absence without a command is a rumor.
--
-- WHAT SURVIVES, and it is the whole mathematical content:
--   * `Ankapasa_`'s model VALIDATES commutativity -- `add ↦ ⊎` and
--     `⊎-swap-≃` -- and separates it from the identity.  §3 below REFUTES
--     it: no derivation exists at all.  Non-triviality and underivability
--     are different theorems and neither implies the other.
--   * Nothing in `Ankapasa_` bears on left-unitality or on induction, and
--     §4 is untouched by it.
--   * TOGETHER the two bracket the fact, which neither does alone:
--     commutativity of `add` IS NOT DERIVABLE, and once added IT IS NOT
--     TRIVIAL.  That is two nayas on one object, arrived at separately,
--     neither reducible to the other -- which is the doctrine, not a
--     consolation.
--
-- So the diagnosis this file offers is narrower than the struck sentence:
-- not that the corpus had one standpoint, but that ℕ was the standpoint
-- from which the questions in §3 and §4 had not been asked, and that a
-- second one three lines long decides them.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `Vyabhicara_…` gives the instrument for underivability that ℕ supports:
-- deviation at one environment forbids a derivation.  Its own header names
-- what it cannot reach -- a pair TRUE AT EVERY ENVIRONMENT and still
-- underivable, with commutativity of `add` as the candidate.
--
-- And the larger thing standing open behind it: `RewriteCertificate`
-- carries `HypStep`, `HypDerivation`, `InductionCertificate` and
-- `induction-sound` -- a whole induction apparatus, sound, and consumed by
-- NOTHING.  Whether it is redundant machinery or strictly necessary was
-- never decided.  §4 decides it.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   §1  A second model: the free-monoid-like structure W with `p`, which
--       is right-unital and successor-compatible -- so BOTH axioms hold,
--       by `refl` -- and is neither commutative nor left-unital.
--   §2  Soundness at that standpoint, all six `Step` constructors.
--   §3  not-commutative, not-left-unital.  Two underivabilities, neither
--       reachable from ℕ, both of statements TRUE in ℕ.
--   §4  THE GAP, AS A THEOREM.  `leftZero-cert` is an induction
--       certificate for `0 + x = x`; `induction-sound` discharges it at
--       every environment; and §3 says no derivation exists.  Therefore
--       THE INDUCTION RULE IS STRICTLY STRONGER THAN THE REWRITE CLOSURE,
--       and the kernel can certify theorems it cannot install, since
--       `NativeOperation.checked` demands a `Derivation`.
--
-- WHAT IS NOT PROVED, named rather than hidden:
--   * NO completeness, no characterisation, no decision procedure.  §3
--     refutes two statements; it does not describe what IS derivable.
--   * NO claim that this standpoint is canonical or best.  It is one more,
--     which is the whole point; a third would decide things it cannot.
--   * NO repair.  §4 exhibits the gap and closes nothing: making an
--     induction certificate installable needs either a `Step` constructor
--     for induction or a weakening of `NativeOperation.checked`, and both
--     are design changes that are not mine to make.
--   * `p`'s third clause overlaps its second and so does not reduce on an
--     open head variable.  Every use below is at a concrete head.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Naya_EvalIsOneStandpointAndASecondOneProvesTheInductionRuleIsStrictlyStrongerThanTheRewriteClosure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_)
import Cubical.Data.Empty as E

open import Kernel.RewriteCertificate

------------------------------------------------------------------------
-- §1.  THE SECOND STANDPOINT.
--
-- The two axioms constrain `add` only where the right argument is `zero`
-- or a `suc`.  At an opaque right argument they say nothing at all, and ℕ
-- silently fills that freedom with commutativity.  Here it is filled
-- differently: a marker is dropped between the two sides.
------------------------------------------------------------------------

data Atom : Type₀ where
  aX aY aZ aU aV aW aS aM : Atom

W : Type₀
W = List Atom

-- right-unital and successor-compatible by construction; the third clause
-- overlaps the second and fires only at a head that is not `aS`.
p : W → W → W
p a []       = a
p a (aS ∷ b) = aS ∷ p a b
p a (c ∷ b)  = a ++ (aM ∷ c ∷ b)

⟦_⟧ : Tm → W
⟦ var ⟧     = aX ∷ []
⟦ yvar ⟧    = aY ∷ []
⟦ zvar ⟧    = aZ ∷ []
⟦ uvar ⟧    = aU ∷ []
⟦ vvar ⟧    = aV ∷ []
⟦ wvar ⟧    = aW ∷ []
⟦ zero ⟧    = []
⟦ suc t ⟧   = aS ∷ ⟦ t ⟧
⟦ add l r ⟧ = p ⟦ l ⟧ ⟦ r ⟧

------------------------------------------------------------------------
-- §2.  SOUNDNESS AT THIS STANDPOINT.  Both axioms hold by `refl`, which is
--      the check that this is a model of the same theory and not a
--      different one dressed up.
------------------------------------------------------------------------

step-model : {a b : Tm} → Step a b → ⟦ a ⟧ ≡ ⟦ b ⟧
step-model (add-zero x)    = refl
step-model (add-suc x y)   = refl
step-model (suc-step q)    = cong (aS ∷_) (step-model q)
step-model (add-left q z)  = cong (λ w → p w ⟦ z ⟧) (step-model q)
step-model (add-right z q) = cong (p ⟦ z ⟧) (step-model q)
step-model (reverse q)     = sym (step-model q)

derivation-model : {a b : Tm} → Derivation a b → ⟦ a ⟧ ≡ ⟦ b ⟧
derivation-model (done _)        = refl
derivation-model (then-step q d) = step-model q ∙ derivation-model d

------------------------------------------------------------------------
-- §3.  TWO UNDERIVABILITIES ℕ CANNOT REACH.  Both statements are TRUE at
--      every environment, so `Vyabhicara_…`'s instrument has no grip on
--      either; this standpoint decides both.
------------------------------------------------------------------------

hd : W → Atom
hd []      = aM
hd (a ∷ _) = a

isX : Atom → Bool
isX aX = true
isX _  = false

not-commutative : Derivation (add var yvar) (add yvar var) → E.⊥
not-commutative d = true≢false (cong isX (cong hd (derivation-model d)))

not-left-unital : Derivation (add zero var) var → E.⊥
not-left-unital d = true≢false (sym (cong isX (cong hd (derivation-model d))))

------------------------------------------------------------------------
-- §4.  THE GAP, AS A THEOREM.
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

leftZero-holds-everywhere : (ρ : Env) → eval (add zero var) ρ ≡ eval var ρ
leftZero-holds-everywhere = induction-sound leftZero-cert

-- the two halves side by side, so the statement is one object.
induction-is-strictly-stronger :
  ((ρ : Env) → eval (add zero var) ρ ≡ eval var ρ)
  × (Derivation (add zero var) var → E.⊥)
induction-is-strictly-stronger = leftZero-holds-everywhere , not-left-unital
