# The port: Agda modules ‚í Bend files, checked and run

Every file here is checked by `bend <file>` (the cubical Bend2 build in
`cubical-paths.patch`) and its `main` runs on `--to-hvm4-full`/HVM4. Files
share definitions through `import Name` (a plain module load, added to the
compiler for this port: the named file's definitions come in unqualified,
resolved next to the importing file, then in the working directory).

| Agda | Bend | checks | main on HVM4 |
|---|---|---|---|
| `Cubical.Foundations.{Prelude,HLevels,Equiv,Isomorphism,Univalence}` (the used fragment), `Cubical.Data.Nat` (+ laws, `isSet‚ï`), `Cubical.Data.List` | `Prelude.bend` | 38 | ‚î |
| `kernel/RewriteCertificate.agda` (Tm, Step with `reverse`, Derivation, subVar, HypStep/HypDerivation, InductionCertificate, eval, step/derivation/induction soundness, `accepted`) | `RewriteCertificate.bend` | 57 | `eval (x+1)` at x=4 ‚í 5 |
| `kernel/ControlledGrammar.agda` (NativeOperation with the open `Control` field, install, Enabled/CheckedFuture, execute, advance, branch-count law) | `ControlledGrammar.bend` | 73 | ‚î |
| `kernel/GenerativeKernel.agda` (Branch, form, direct/detour histories, `run-count`, `run-targets` by refl) | `GenerativeKernel.bend` | 90 | 2 |
| `kernel/PvsNPGapLivesInTheForgetfulProjection.agda` (answer is projection; `forgetful-is-blind-to-route` via `isSet‚ï`) | `PvsNPGapLivesInTheForgetfulProjection.bend` | 98 | 4 (the detour's length) |
| `kernel/EveryDerivationIsInvertible.agda` (`revD`, `len-revD`, `revD-sound`) | `EveryDerivationIsInvertible.bend` | 63 | ‚î |
| `kernel/WindingCostIsUnarySize.agda` (`addTower`, cost = unary size) | `WindingCostIsUnarySize.bend` | 64 | `len (addTower 5)` ‚í 6 |
| `InteractionPrasna_‚¶.agda` ‚î the two-sided h-level theorem: `Netra` over `ISC`, the corecursive contraction `smyaP`, ‡‡ï-‡®‡‡‡‡∞‡Æ‡ (`oneEye`: over sets the process space is a point); `Vardhana` over the kernel, the length shadow `dlen`, ‡µ‡∞‡‡ß‡®-‡‡‡‡‡‡µ‡Æ‡ (`vardhanaNotContr`), `¬isProp Derivation` | `HLevelOfInteraction.bend` | 104 | `emitLen p2` ‚í 4 |
| `Cubical.HITs.SetQuotients` (`_/_`, `rec`, `elimProp`, `elimProp2`, `squash/`), `isSetŒ†`, `isPropŒ†` | `SetQuotient.bend` (on the declared HIT; `isPropPathP` is the dependent isProp‚íisSet square) | 57 | ‚î |
| `hset.bend`: `hProp`, `isPropIso`, `uaEta`, `isSet hProp` | `HProp.bend` | 66 | ‚î |
| `SQ.effective` (encode‚ìdecode over `Code : Q ‚í hProp`) | `Effective.bend` | 84 | ‚î |
| `theorems/automata/MyhillNerodeMinimalMachine.agda` ‚î Nerode congruence and its laws, behavioural congruences (Nerode the greatest), `MinimalMachine` (`Meaning = X / ‚âà`, `quotStep`/`quotObserve`/`quotRun`, quotient preserves behaviour, effectivity, `quotBehavior` injective, `behaviorSeparatesStates`, `factor` + uniqueness), `Terminal` (`mediate` and its uniqueness), `Machine`/`crystal` | `MyhillNerodeMinimalMachine.bend` | 127 | ‚î |
| `theorems/residue/Prashna_‚¶.agda` ‚î `deterministic-collapse` (the closed machine has exactly one execution: `isContr(DetISC mc)`, an instance of ‡‡ï-‡®‡‡‡‡∞‡Æ‡) and `interaction-is-strictly-wider` (`¬ isContr(FreeISC 0)`, two lawful free processes differ) | `Prashna.bend` | 148 | `nextOn 3 (stepper 3)` ‚í 4 |
| `fibre/src/Fibre/Carrier.agda` (THE LAW: singleton fibre, `Carrier‚â`, `Carrier‚â°` by ua, `carry-transport-descend` = uaŒ≤, the Œ¶-square by refl) | `Carrier.bend` | 52 | 2 |
| `kernel/CongruenceLiftsAreGradePreserving.agda` (`underSuc`/`underAddL`/`underAddR`, each length-preserving) | `CongruenceLiftsAreGradePreserving.bend` | 77 | 2 (the accepted rule lifted under `_ + y`) |
| `kernel/ClosedAdditionCostIsLinear.agda` (`addClosed`, cost b+1) | `ClosedAdditionCostIsLinear.bend` | 79 | 4 |
| `kernel/TheCompressionIsTheForgetfulProjection.agda` (`compress`, the fibre over a+b with two distinct terms, `carried_side_is_free` as an `Equiv`) | `TheCompressionIsTheForgetfulProjection.bend` | 91 | 5 |
| `kernel/WindingCostIsCarriedAndCompressionDropsIt.agda` | `WindingCostIsCarriedAndCompressionDropsIt.bend` | 93 | 4 |
| `kernel/ForgetfulCompressionPricesTheDrop.agda` (2 ‚â† 4, `meaning_agrees` by `isSetNat`) | `ForgetfulCompressionPricesTheDrop.bend` | 110 | 4 |
| `kernel/RewriteCertificateMul.agda` (the language widened by `mul`: `StepM` with `mul_zero`/`mul_suc`/congruences, `mul` on Nat with `mulZero`/`mulSuc`/`plusComm` proved, `one_times_one`, the six-step `x_times_one` certificate, `embed` and the conservativity theorem `embed_certificate_sound`) | `RewriteCertificateMul.bend` | 105 | `2¬3` ‚í 6 |
| `kernel/MultiplicationUnfoldsInLinearPeels.agda` (`mulPeel`, cost b+1) | `MultiplicationUnfoldsInLinearPeels.bend` | 112 | 4 |

The port's own count of the corpus's module identities so far: 20 Agda-side objects ‚í 20 Bend files. Counts include the imported definitions (each file re-checks what it
imports). Zero rejections in every file.

## What the port needed from the language, and what it did not

- Indexed families (`Step x y`, `Derivation x z`) are declared the Bend2 way:
  each constructor carries its index equations as `Tm{x == ‚¶}` fields and a
  function on the family matches them (`match ex: case {==}:`). The cubical
  `Path` and the inductive `{==}` coexist; the port never needed to convert
  between them.
- Records (`Env`, `NativeOperation` with a type-valued field and a proof
  field over it, `EnabledFuture`) are `type` declarations with dependent
  fields; projections are one-case matches.
- Implicit arguments do not exist: every type parameter is passed. That is
  the only systematic verbosity.
- `isSet‚ï` is proved from scratch by encode‚ìdecode (`NatCode`, `J`); no
  Hedberg, no decidable-equality library.
- Nothing was postulated, no solver, no reflection.

## Schematic installation (2026-09-15)

`SchematicOperation.bend` ports section 3 of
`formal/cubical/Kernel/TheInstalledOperationHasNoPervasionSoTheKernelMemorises.agda`.
Its control retains a substitution `u` and a path from the actual source to
`subVar(u, lhs)`; application returns `subVar(u, rhs)`. `schemaApplySound`
uses the existing `eval_subVar` proof and the equation's meaning in the
substituted environment. `installSchema` accepts existing derivations;
`installInductionSchema` accepts existing induction certificates. Substitution
witnesses are supplied, not discovered by these functions. This adds a callable
schema interface without changing the existing ground `NativeOperation` API.

Validation with the local path-transport-patched Bend binary and HVM4 at
`6defdfc7dae2a3cca5dd6e74ed0612385b5646a8`: ordinary checking passed; the
full emitted target returned `#Suc{#Suc{#Zer{}}}` (2), 955 interactions.
`schemaZero` and `schemaSuccessor` check the two distinct contexts from the
Agda separation example. A negative probe pairing the zero context with the
successor substitution was rejected with a source-endpoint mismatch.
The separate `--total` gate refused the imported `derivation_sound`, `eval`,
and `hyp_derivation_sound`, classified as unchecked; this is not a whole-program
totality pass. No dataset analysis or compression result is asserted by this port.
