{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Syat_TheBlindnessIsAPropertyOfTheCodomain
--                     AndCostFailsInversionRatherThanTruncation
--
-- TERM, AND THE SCHOOL IS JAINA, NAMED BEFORE THE TERM IS USED.
--
-- स्यात् · syāt -- the qualifier that prefixes every bhaṅga of the
-- saptabhaṅgī.  Optative of √अस्, used as an indeclinable, and it does NOT
-- mean "maybe": the Jaina logicians insist each qualified predication is
-- निश्चय · niścaya, determinate, asserted under a stated उपाधि · upādhi.
-- The apparatus is laid out in Samantabhadra's *Āptamīmāṃsā* (~6th c.) and
-- developed by Akalaṅka (~8th c.) and Vidyānanda; the governing rule taken
-- here is the older one, that a naya asserting itself by denying the
-- others becomes a दुर्नय · durnaya.  No first use is established.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  No Jaina proved anything
-- below and nothing here interprets the *Āptamīmāṃsā*.  One rule is
-- borrowed and only one: AN ASSERTION MUST CARRY THE RESPECT IN WHICH IT
-- HOLDS, and an unqualified one is defective even when its qualified form
-- is true.  §1 applies that rule to a theorem of this corpus, and the
-- application is a theorem rather than a reading.
--
------------------------------------------------------------------------
-- WHAT THIS REVISES, AND IT IS NOT A REFUTATION.
--
-- `Sesa_…` proves `every-semantic-criterion-is-blind` and states it
-- unqualified -- "No semantic criterion -- none, at any h-level, of any
-- complexity -- selects the short proof."  THE THEOREM IS TRUE AND THE
-- SCOPE SENTENCE IS THE DURNAYA.  §1 abstracts that proof over its
-- codomain and shows what it actually consumes: `isSet X`, and nothing
-- else.  Not ℕ, not `eval`, not one fact about this kernel.  So the
-- qualified form is
--
--     syāt: FROM A 0-TRUNCATED STANDPOINT, no criterion selects.
--
-- and "at any h-level" is the clause that does not survive -- the h-level
-- of the CRITERION is unrestricted in `Sesa_`'s statement, but the h-level
-- of the CODOMAIN is what does the work, and it is fixed at 0 by ℕ.
-- `Sesa_` is not edited here; the general form is supplied beside it.
--
------------------------------------------------------------------------
-- AND THE OBVIOUS REPAIR DOES NOT WORK, WHICH IS THE SHARPER HALF.
--
-- If truncation is the obstruction, raise it: interpret into a groupoid
-- and let parallel derivations have distinct meanings.  §2 says that fails
-- for a second and independent reason.  Any measure that respects the
-- groupoid structure must send `rev d` to the inverse of `d`, hence a
-- round trip to the identity.  Lāghava sends a round trip to TWICE the
-- cost.  So cost is a functor on the CATEGORY and not on the GROUPOID:
-- the obstruction to seeing it is INVERSION, not truncation, and raising
-- h-level does not reach it.
--
-- `Avirodha_…` states the structure -- strictly a category, weakly a
-- groupoid, and the gap between them is the śeṣa.  §2 measures that gap:
-- it is exactly `len d + len d`.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--   §1  blindness-is-a-property-of-the-codomain -- the parametric form.
--   §2  ⊕-len, rev-len, round-trip -- reversal is free to the law and
--       costs double to the walker.
--
-- WHAT IS NOT PROVED, named:
--   * NO converse.  §1 gives sufficiency of `isSet`; that a NON-set
--     codomain actually separates the kernel's two histories is not shown
--     here and needs a model landing in a genuine groupoid.  Until that
--     exists, "0-truncation is why" is a sufficient explanation and not a
--     characterisation, and I do not state it as one.
--   * NO construction of the extra-semantic criterion `Sesa_` says is
--     necessary.  §2 explains why one class of attempts cannot work.
--   * nothing about which cost is right; `len` is one, and the round-trip
--     law is about invertibility, not about that choice.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0.  The repository pin is 2.8.0 + cubical v0.9, and that check is a
-- command not yet run on this module.
------------------------------------------------------------------------

module NaturalMachine.Syat_TheBlindnessIsAPropertyOfTheCodomainAndCostFailsInversionRatherThanTruncation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-zero)

open import NaturalMachine.RewriteCertificate

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1.  WHAT THE BLINDNESS PROOF ACTUALLY EATS.
--
-- The codomain, the interpretation and its soundness are all parameters.
-- Nothing about ℕ survives, nothing about `eval`, nothing about the six
-- constructors.  One hypothesis is consumed and it is `isSet X`.
------------------------------------------------------------------------

blindness-is-a-property-of-the-codomain :
  {X : Type ℓ} → isSet X
  → (⟦_⟧ : Tm → Env → X)
  → (sound : {a b : Tm} → Derivation a b → (ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ)
  → {a b : Tm} {C : Type ℓ'}
  → (φ : ((ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ) → C)
  → (d e : Derivation a b) → φ (sound d) ≡ φ (sound e)
blindness-is-a-property-of-the-codomain setX ⟦_⟧ sound φ d e =
  cong φ (funExt (λ ρ → setX _ _ (sound d ρ) (sound e ρ)))

------------------------------------------------------------------------
-- §2.  AND RAISING THE H-LEVEL DOES NOT REACH IT.  A round trip is the
--      identity to anything that respects inversion, and twice the cost
--      to lāghava.
------------------------------------------------------------------------

len : {a b : Tm} → Derivation a b → ℕ
len (done _)        = zero
len (then-step _ d) = suc (len d)

_⊕_ : {a b c : Tm} → Derivation a b → Derivation b c → Derivation a c
done _        ⊕ e = e
then-step p d ⊕ e = then-step p (d ⊕ e)

rev : {a b : Tm} → Derivation a b → Derivation b a
rev (done x)        = done x
rev (then-step p d) = rev d ⊕ then-step (reverse p) (done _)

⊕-len : {a b c : Tm} (d : Derivation a b) (e : Derivation b c)
      → len (d ⊕ e) ≡ len d + len e
⊕-len (done _)        e = refl
⊕-len (then-step _ d) e = cong suc (⊕-len d e)

-- reversal is free to the law: the same number of steps, both ways.
rev-len : {a b : Tm} (d : Derivation a b) → len (rev d) ≡ len d
rev-len (done x)        = refl
rev-len (then-step p d) =
    ⊕-len (rev d) (then-step (reverse p) (done _))
  ∙ +-suc (len (rev d)) zero
  ∙ cong suc (+-zero (len (rev d)))
  ∙ cong suc (rev-len d)

-- and costs double to the walker.  Any groupoid-functorial measure sends
-- this to the identity; lāghava sends it to `len d + len d`.
round-trip : {a b : Tm} (d : Derivation a b) → len (d ⊕ rev d) ≡ len d + len d
round-trip d = ⊕-len d (rev d) ∙ cong (len d +_) (rev-len d)
