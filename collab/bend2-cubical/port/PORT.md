# The port: Agda modules → Bend files, checked and run

Every file here is checked by `bend <file>` (the cubical Bend2 build in
`cubical-paths.patch`) and its `main` runs on `--to-hvm4-full`/HVM4. Files
share definitions through `import Name` (a plain module load, added to the
compiler for this port: the named file's definitions come in unqualified,
resolved next to the importing file, then in the working directory).

| Agda | Bend | checks | main on HVM4 |
|---|---|---|---|
| `Cubical.Foundations.{Prelude,HLevels,Equiv,Isomorphism,Univalence}` (the used fragment), `Cubical.Data.Nat` (+ laws, `isSetℕ`), `Cubical.Data.List` | `Prelude.bend` | 38 | — |
| `kernel/RewriteCertificate.agda` (Tm, Step with `reverse`, Derivation, subVar, HypStep/HypDerivation, InductionCertificate, eval, step/derivation/induction soundness, `accepted`) | `RewriteCertificate.bend` | 57 | `eval (x+1)` at x=4 ⇒ 5 |
| `kernel/ControlledGrammar.agda` (NativeOperation with the open `Control` field, install, Enabled/CheckedFuture, execute, advance, branch-count law) | `ControlledGrammar.bend` | 73 | — |
| `kernel/GenerativeKernel.agda` (Branch, form, direct/detour histories, `run-count`, `run-targets` by refl) | `GenerativeKernel.bend` | 90 | 2 |
| `kernel/PvsNPGapLivesInTheForgetfulProjection.agda` (answer is projection; `forgetful-is-blind-to-route` via `isSetℕ`) | `PvsNPGapLivesInTheForgetfulProjection.bend` | 98 | 4 (the detour's length) |
| `kernel/EveryDerivationIsInvertible.agda` (`revD`, `len-revD`, `revD-sound`) | `EveryDerivationIsInvertible.bend` | 63 | — |
| `kernel/WindingCostIsUnarySize.agda` (`addTower`, cost = unary size) | `WindingCostIsUnarySize.bend` | 64 | `len (addTower 5)` ⇒ 6 |
| `SamvadaPrasna_….agda` — the two-sided h-level theorem: `Netra` over `ISC`, the corecursive contraction `sāmyaP`, एक-नेत्रम् (`oneEye`: over sets the process space is a point); `Vardhana` over the kernel, the length shadow `dlen`, वर्धन-बहुत्वम् (`vardhanaNotContr`), `¬isProp Derivation` | `HLevelOfInteraction.bend` | 104 | `emitLen p2` ⇒ 4 |
| `Cubical.HITs.SetQuotients` (`_/_`, `rec`, `elimProp`, `elimProp2`, `squash/`), `isSetΠ`, `isPropΠ` | `SetQuotient.bend` (on the declared HIT; `isPropPathP` is the dependent isProp→isSet square) | 57 | — |
| `hset.bend`: `hProp`, `isPropIso`, `uaEta`, `isSet hProp` | `HProp.bend` | 66 | — |
| `SQ.effective` (encode–decode over `Code : Q → hProp`) | `Effective.bend` | 84 | — |
| `theorems/automata/MyhillNerodeMinimalMachine.agda` — Nerode congruence and its laws, behavioural congruences (Nerode the greatest), `MinimalMachine` (`Meaning = X / ≈`, `quotStep`/`quotObserve`/`quotRun`, quotient preserves behaviour, effectivity, `quotBehavior` injective, `behaviorSeparatesStates`, `factor` + uniqueness), `Terminal` (`mediate` and its uniqueness), `Machine`/`crystal` | `MyhillNerodeMinimalMachine.bend` | 127 | — |
| `theorems/residue/Prashna_….agda` — `deterministic-collapse` (the closed machine has exactly one execution: `isContr(DetISC mc)`, an instance of एक-नेत्रम्) and `interaction-is-strictly-wider` (`¬ isContr(FreeISC 0)`, two lawful free processes differ) | `Prashna.bend` | 148 | `nextOn 3 (stepper 3)` ⇒ 4 |
| `fibre/src/Fibre/Carrier.agda` (THE LAW: singleton fibre, `Carrier≃`, `Carrier≡` by ua, `carry-transport-descend` = uaβ, the Φ-square by refl) | `Carrier.bend` | 52 | 2 |
| `kernel/CongruenceLiftsAreGradePreserving.agda` (`underSuc`/`underAddL`/`underAddR`, each length-preserving) | `CongruenceLiftsAreGradePreserving.bend` | 77 | 2 (the accepted rule lifted under `_ + y`) |
| `kernel/ClosedAdditionCostIsLinear.agda` (`addClosed`, cost b+1) | `ClosedAdditionCostIsLinear.bend` | 79 | 4 |
| `kernel/TheCompressionIsTheForgetfulProjection.agda` (`compress`, the fibre over a+b with two distinct terms, `carried_side_is_free` as an `Equiv`) | `TheCompressionIsTheForgetfulProjection.bend` | 91 | 5 |
| `kernel/WindingCostIsCarriedAndCompressionDropsIt.agda` | `WindingCostIsCarriedAndCompressionDropsIt.bend` | 93 | 4 |
| `kernel/ForgetfulCompressionPricesTheDrop.agda` (2 ≠ 4, `meaning_agrees` by `isSetNat`) | `ForgetfulCompressionPricesTheDrop.bend` | 110 | 4 |
| `kernel/RewriteCertificateMul.agda` (the language widened by `mul`: `StepM` with `mul_zero`/`mul_suc`/congruences, `mul` on Nat with `mulZero`/`mulSuc`/`plusComm` proved, `one_times_one`, the six-step `x_times_one` certificate, `embed` and the conservativity theorem `embed_certificate_sound`) | `RewriteCertificateMul.bend` | 105 | `2·3` ⇒ 6 |
| `kernel/MultiplicationUnfoldsInLinearPeels.agda` (`mulPeel`, cost b+1) | `MultiplicationUnfoldsInLinearPeels.bend` | 112 | 4 |

The port's own count of the corpus's module identities so far: 20 Agda-side objects → 20 Bend files. Counts include the imported definitions (each file re-checks what it
imports). Zero rejections in every file.

## What the port needed from the language, and what it did not

- Indexed families (`Step x y`, `Derivation x z`) are declared the Bend2 way:
  each constructor carries its index equations as `Tm{x == …}` fields and a
  function on the family matches them (`match ex: case {==}:`). The cubical
  `Path` and the inductive `{==}` coexist; the port never needed to convert
  between them.
- Records (`Env`, `NativeOperation` with a type-valued field and a proof
  field over it, `EnabledFuture`) are `type` declarations with dependent
  fields; projections are one-case matches.
- Implicit arguments do not exist: every type parameter is passed. That is
  the only systematic verbosity.
- `isSetℕ` is proved from scratch by encode–decode (`NatCode`, `J`); no
  Hedberg, no decidable-equality library.
- Nothing was postulated, no solver, no reflection.
