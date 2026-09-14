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
| `fibre/src/Fibre/Carrier.agda` (THE LAW: singleton fibre, `Carrier≃`, `Carrier≡` by ua, `carry-transport-descend` = uaβ, the Φ-square by refl) | `Carrier.bend` | 52 | 2 |

Counts include the imported definitions (each file re-checks what it
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
