{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Adesa_SubstitutionIsAdmissibleOnDerivationsSoASchemaCan
--               CarryACertificateAndNotOnlyAMeaning
--
-- TERM.  आदेश · ādeśa -- in Pāṇini, *Aṣṭādhyāyī* (~500 BCE), the SUBSTITUTE
-- that takes the place of a स्थानिन् (sthānin, the substituend); the
-- machinery around it includes स्थानेऽन्तरतमः (1.1.50, the nearest
-- substitute) and the sthānivadbhāva rule स्थानिवदादेशोऽनल्विधौ (1.1.56),
-- which says an ādeśa behaves LIKE its sthānin for the purposes of further
-- rules, with a stated exception.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  Pāṇini proved nothing below,
-- and nothing here interprets the Aṣṭādhyāyī.  One notion is borrowed and
-- only one: that a substitution is admissible through a rule system --
-- that the rules continue to apply after it.  The theorem below is the
-- corresponding statement for THIS calculus's `Step`/`Derivation` and is
-- proved by structural induction over its six constructors, in cubical type
-- theory (Voevodsky's univalence; the library is agda/cubical).  The
-- resemblance to 1.1.56 is noted as a resemblance and is not the proof.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `Avataranika_…` §8(b) names the frontier item: raise Vyapti_'s schema and
-- replace `install` with `install-schema`, "so that generalisation is the
-- kernel's default rather than a companion module's."  This is the missing
-- map underneath that.
--
-- Vyapti_.SchematicOperation carries `apply-sound`, an EVAL EQUALITY:
--
--     apply-sound : (t : Tm) (c : Control t) (ρ : Env)
--                 → eval t ρ ≡ eval (apply t c) ρ
--
-- ControlledGrammar.NativeOperation carries `apply-checked`, a DERIVATION:
--
--     apply-checked : (t : Tm) (c : Control t) → Derivation t (apply t c)
--
-- So a schema has the semantics of its instances and not their
-- certificates, and cannot presently become a kernel operation.
--
-- BEFORE THIS FILE, `subVar` occurred in exactly three places in the
-- kernel's own module -- the two fields of `InductionCertificate` and
-- `eval-subVar` -- and nowhere as an operation ON a proof:
--
--     git grep -nE 'Step \(subVar|Derivation \(subVar' formal/cubical
--       -> only InductionCertificate.base / .step
--     git grep -ln 'SchematicOperation' formal/cubical
--       -> Vyapti_ and Avataranika_ only
--
------------------------------------------------------------------------
-- WHAT IS PROVED.  §1 substitution is admissible on one rewrite; §2 hence
-- on a whole walk; §3 the consequence for schemas; §4 exhibited at the two
-- contexts Vyapti_ proves no single NativeOperation can both fire at.
--
-- THE REMAINDER, LOCATED — each a named next construction, not a gap:
--   * `install-schema` itself.  `NativeOperation.control-sound : Control t
--     → t ≡ source` FORCES the subsingleton property Vyapti_ measures, so
--     no schema can inhabit that record as it stands; the record's
--     `apply`/`apply-checked` would have to become fields.  This file
--     supplies the certificate a schema would need, not the record change.
--   * substitution for the other five coordinates.  `subVar` binds `var`
--     alone; §8(b)'s "all six coordinates" needs a substitution indexed by
--     coordinate and the corresponding `eval-sub`, neither written here.
--   * any claim about cost.  `subDeriv` preserves the length of a walk by
--     construction, and `Sesa_` proves no semantic criterion selects the
--     short derivation; nothing here bears on selection.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Adesa_SubstitutionIsAdmissibleOnDerivationsSoASchemaCanCarryACertificateAndNotOnlyAMeaning where

open import Cubical.Foundations.Prelude
open import RewriteCertificate

------------------------------------------------------------------------
-- §1.  One rewrite survives substitution, structurally, all six
--      constructors.  `reverse` included, so the groupoid structure of the
--      derivation space is carried across unchanged.
------------------------------------------------------------------------

subStep : (u : Tm) {a b : Tm} → Step a b → Step (subVar u a) (subVar u b)
subStep u (add-zero x)    = add-zero (subVar u x)
subStep u (add-suc x y)   = add-suc (subVar u x) (subVar u y)
subStep u (suc-step p)    = suc-step (subStep u p)
subStep u (add-left p z)  = add-left (subStep u p) (subVar u z)
subStep u (add-right z p) = add-right (subVar u z) (subStep u p)
subStep u (reverse p)     = reverse (subStep u p)

------------------------------------------------------------------------
-- §2.  Hence a whole walk survives it.  No relation is imposed and none is
--      quotiented: `then-step` goes to `then-step`, so the image of a
--      derivation has exactly the length of its preimage.
------------------------------------------------------------------------

subDeriv : (u : Tm) {a b : Tm} → Derivation a b
         → Derivation (subVar u a) (subVar u b)
subDeriv u (done x)        = done (subVar u x)
subDeriv u (then-step p d) = then-step (subStep u p) (subDeriv u d)

------------------------------------------------------------------------
-- §3.  THE CONSEQUENCE.  A checked derivation instantiates to a checked
--      derivation at every substitution instance, with no new proof
--      obligation and no appeal to `eval`.  This is the certificate a
--      schematic operation lacks.
------------------------------------------------------------------------

schema-instance-is-certified :
  {lhs rhs : Tm} → Derivation lhs rhs
  → (u : Tm) → Derivation (subVar u lhs) (subVar u rhs)
schema-instance-is-certified d u = subDeriv u d

------------------------------------------------------------------------
-- §4.  Exhibited on the kernel's own accepted theorem
--      `accepted : Derivation (add var (suc zero)) (suc var)`
--      at the two contexts of Vyapti_.ctx₀ and Vyapti_.ctx₁, which
--      `no-native-operation-does-this` proves no single NativeOperation can
--      both fire at.  One derivation, two certified instances.
------------------------------------------------------------------------

inst₀ : Derivation (add zero (suc zero)) (suc zero)
inst₀ = schema-instance-is-certified accepted zero

inst₁ : Derivation (add (suc zero) (suc zero)) (suc (suc zero))
inst₁ = schema-instance-is-certified accepted (suc zero)

-- And each still means what it says, at every environment, through the
-- kernel's own `derivation-sound` and not through a new soundness argument.

inst₀-sound : (ρ : Env) → eval (add zero (suc zero)) ρ ≡ eval (suc zero) ρ
inst₀-sound = derivation-sound inst₀

inst₁-sound : (ρ : Env) → eval (add (suc zero) (suc zero)) ρ ≡ eval (suc (suc zero)) ρ
inst₁-sound = derivation-sound inst₁
