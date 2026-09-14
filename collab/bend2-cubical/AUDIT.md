# Retiring Agda: the feature audit, row by row, each row a checked file

The corpus is 2300 `.agda` files under `--cubical --safe`. This is every
language feature and library dependency it uses (counted by import/usage
over the corpus), what Bend has instead, and the file that proves it.

| the corpus uses | count | in Bend | evidence |
|---|---|---|---|
| Path/PathP, refl/sym/cong/∙, funExt, J, subst, transport | ubiquitous | native (`Path`, `<i>`, `@`, `hcomp`/`coe`) | `port/Prelude.bend` 47✓; every suite file |
| univalence (`ua`, `uaβ`, `isoToEquiv`, `equivFun`, `compEquiv`) | 758 / 577 / 552 / 431 | `ua` with uaβ definitional, Glue, `lemIso` transcribed | `uaequiv.bend`, `uaglue.bend`, `roundtrip.bend`, `port/Carrier.bend` |
| h-levels (`isContr`/`isProp`/`isSet`, `isContrSingl`, `isProp→isSet`, `isPropIsContr`, `isSetℕ`) | ~2800 | defined; `isSetNat` by encode–decode, `isPropToIsSet` by a square | `port/Prelude.bend`, `hset.bend`, `effective.bend` |
| `Cubical.HITs.PropositionalTruncation` (117 files), `SetQuotients` (66), `S1` (44), `Truncation`/`SetTruncation` (32), `Sn`, `KleinBottle`, `Torus`, `Susp`, `Pushout`, `Bouquet`, `FreeGroup`, `MappingCones` | | ONE declaration schema (`type … path @c(…): Path(…)`), dependent eliminator, transport and hcomp through HITs, full runtime | `HITS.md`, `hit_*.bend` (16 files), effectivity 23✓ |
| inductive families with indices (`Step x y`, `Vec A n`, …) | everywhere | constructors carry index equations `T{x == …}`, matched by `{==}` | `port/RewriteCertificate.bend` 57✓ |
| records with dependent and type-valued fields (`NativeOperation`, `Machine`) | everywhere | `type` with dependent fields, one-case matches as projections | `port/ControlledGrammar.bend` 73✓ |
| coinductive records, `--guardedness` (1106 files), copattern bisimulations | | corecursive `type`s (Fix-typed), corecursive paths, `--total` productivity gate | `coinduction.bend`, `silence.bend`, `port/HLevelOfInteraction.bend` |
| implicit arguments `{A : Type}`, instance arguments (626 files) | | none: every parameter is passed; the only systematic verbosity | all `port/*.bend` |
| `with`-abstraction (2070 files), `mutual` (138) | | `match` on the abstracted value; top-level recursion is mutual by name | `port/*.bend` |
| `Cubical.Data.Nat` (+ Order, Divisibility, Mod, GCD), `Int`, `List`, `Sigma`, `Sum`, `Maybe`, `Fin`, `Bool`, `Unit`, `Empty` | 1613 / 280 / 553 / … | Nat/List/Bool/Unit/Empty/Σ native; Int, Sum, Maybe, Fin as declared `type`s; laws proved as needed | `port/Prelude.bend` (Nat laws), library to grow with the port |
| `Cubical.Tactics.CommRingSolver` (163 files), `NatSolver` (59) | | NOT needed and NOT wanted: an equation in the ring is a normal form that computes; the port proves each by the two sides reducing or by induction | `port/EveryDerivationIsInvertible.bend` (`len-revD` by `plusSuc`/`plusZero`) |
| reflection (`Agda.Builtin.Reflection`, 23 files) | | tooling only (the census reflects corpus types); the Bend emitters are the reflection: a term is data | `census/`, `EMITTER.md` |
| `FOREIGN GHC` / IO (10 files) | | `main` runs on HVM4 (`--to-hvm4-full`), values printed by the runtime | every `port/*.bend` main |
| universe levels (`Type ℓ`) | | `Set : Set` (no levels) — a consistency caveat of Bend2, not of the port | — |
| `abstract` (226), `postulate` (only in the erased/mukha lane) | | not needed; nothing is postulated in the port | — |

## What is genuinely different, stated exactly

- No implicit arguments and no instance resolution: ports are longer, never
  weaker.
- Conversion is untyped one-step unfolding: some definitional equalities
  Agda sees need an explicit path here (e.g. η for a user record is Σ-η
  componentwise, so projections must be plain `fst`/`snd`, see the note in
  `port/HLevelOfInteraction.bend`).
- Parameters of a HIT constructor are read from the goal or supplied by an
  annotation; Agda infers them by unification.
- `Set : Set`.
- Two checker rules the port needed, both about recursive definitions:
  a stuck eliminator of a HIT is a stuck form (`ugly`), so a recursive
  definition whose branches mention itself stays folded under `whnf Soft`;
  and the goal-rewriting pass rewrites an application of a definition in
  its arguments without unfolding it (a productive corecursive definition
  such as a process would otherwise unfold forever). Neither changes what
  converts; both change what terminates.

Nothing in the corpus requires a feature Bend lacks; the remaining work is
labour (porting module by module over the growing Prelude), not a gap.
