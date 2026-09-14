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
| `theorems/automata/MyhillNerodeMinimalMachine.agda` — Nerode congruence and its laws, behavioural congruences (Nerode the greatest), `MinimalMachine` (`Meaning = X / ≈`, `quotStep`/`quotObserve`/`quotRun`, quotient preserves behaviour, effectivity, `quotBehavior` injective, `behaviorSeparatesStates`, `factor` + uniqueness), `Terminal` (`mediate` and its uniqueness), `Machine`/`crystal` | `MyhillNerodeMinimalMachine.bend` | (checking) | — |
| `fibre/src/Fibre/Carrier.agda` (THE LAW: singleton fibre, `Carrier≃`, `Carrier≡` by ua, `carry-transport-descend` = uaβ, the Φ-square by refl) | `Carrier.bend` | 52 | 2 |
| `MyhillNerodeMinimalMachine.bend` §0–§3 only (run, behavior, Nerode as a prop-valued equivalence relation, `Meaning`, `isSetMeaning`, `nerodeEffective`) — the light module the biological presentations import; the full minimal-machine file checks slowly (its full-abstraction/terminality proofs) | `Nerode.bend` | 99 (0.5 s) | — |
| **The first biological finite presentation** — a perturbation system (cells on a gene panel, knockdown/passage generators, histories as derivations): `Receiver`/`fold`/`fold_unique` (AdiBija), four readings and the two-history elucidation (Vivarana), commutation kept and its failure retained (Krama), `Meaning = Cell / Nerode` under a tgt-only assay with `tf_is_necessary` (unread state that one future separates) and `hk_is_invisible` (unread state every future ignores), erasure = descent through the quotient forgetting hk, the challenge shape (`Context`, `predict`, pseudobulk descends) — see `research/BIOLOGY_2026_FRONTIER.md` | `Perturbation.bend`; soundness probe `Perturbation_mustfail.bend` (the hk-reading receiver must be rejected); `PerturbationEmitted.bend` is the same shape emitted by `scripts/emit-perturbation.py` from `scripts/examples/vcc_shape.json` | 175 (probe: 176 ✓ + exactly the 1 intended ✗, `hkResp_WRONG`); emitted: 145 | 4 (497 itrs on `--to-hvm4-full`); emitted: 0 (513 itrs; kd TF then passage zeroes the target) |
| Bench: three receivers over one history of N passages, bound once vs rebuilt per receiver (`shared`/`separate`) | `PerturbationBench.bend` | 180 | shared/separate itrs on `--to-hvm4-full`: N=8 2436/2432, N=32 16956/17000, N=128 190236/190472 — no sharing advantage for a cheap-to-build history (a dup costs what construction costs); see the note §3 |
| **Spatial omics** (the SpatialData shape): a molecule field, two segmentations, the fibre law at a segmentation (`Mol ≃ Σ c. fiber s c`, ua path, transport computes), receivers as folds, total = sum over cells of fibre sizes for every segmentation, segmentation-invariance = descent through the quotient forgetting coordinates (the cell-by-gene entry refuted as non-descending), a coordinate swap as a `ua` path | `Spatial.bend`; probe `Spatial_mustfail.bend` | 147 (probe: 148 ✓ + exactly the 1 intended ✗); `--total` passes | 1 (714 itrs) |
| **Lineage / development**: the interaction at depth n (run-is-answers as an Equiv), a fate ladder whose digestion rule depends on history (Upayoga: the two orders of the same encounters are separated), the terminal-readout fibre with two distinct points (the unresolved history is that fibre, not contractible), determinism-is-silence for the closed program vs generativity for the open question | `Lineage.bend` | 98; `--total` passes | 7 (347 itrs) |
| **Molecular dynamics / structure**: the fibre law generic (fibrelaw.bend), a reversible step with contractible residue, a thermostat with a crowded residue over (q, up) and an empty one over (q, down) (both shapes of non-invertibility; `dissipate_not_equiv`), trajectories with two observables as folds over one word (same endpoint, different path integral), the conformer ensemble as the fibre of the top-1 projection, not a point | `Dynamics.bend` | 107; `--total` passes | 6 (576 itrs) |

The port's own count of the corpus's module identities so far: 13 Agda-side objects → 13 Bend files. Counts include the imported definitions (each file re-checks what it
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
