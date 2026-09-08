# Native records (handoff §71 format)

Each record is one checked artifact on branch claude/interactive-daemon-math-vt8e9e over the handoff pin 168ea8e2. The received bundle under research/handoff_20260908/ is unchanged; research/CLAIM_GRAPH.json is the live graph pointing at these loci.

## Lane I — native Yantra gate (positive and false controls)

```text
claim_id: NV-GATE-20260908
statement: The native Yantra wire accepts the handoff's positive Candidate through marga: kernel after watching the controls, returns the three vislesana normal forms, and rejects the false control with an Agda type error; both runs exit 0 with isolated logs.
source_class: infrastructure control (handoff §5 Lane I; infra/smoke_requests.jsonl, infra/false_candidate.jsonl)
parameters_and_quantifiers: two fixed request streams; no mathematical quantifiers
repository_commit: pin 168ea8e2; evidence committed at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: research/handoff_20260908/validation/native/{preflight.log, positive.stdout.log, positive.stderr.log, positive.wire-transcript.jsonl, false.stdout.log, false.stderr.log, false.wire-transcript.jsonl, vislesana.record.json}
imports_and_toolchain: sh interactive/run-yantra.sh --wire; env YANTRA_OUT, DOSA_LEKHA, YANTRA_LEKHA, MATH_CERTCACHE=0, AGDA_DIR=$HOME/.agda-pin; Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities
existing_terms_reused: sadhana.patra, sadhana.vislesana, ControlledGrammar.install, N.normalize, N.learn (formal/cubical/kernel)
new_derivation_or_artifact: vislesana.record.json: answer ↦ suc var : Tm; N.normalize demo ↦ then-step (add-suc var zero) (then-step (suc-step (add-zero var)) (done (suc var))); N.learn demo ↦ ControlledGrammar.install (…) : ControlledGrammar.NativeOperation
proof_status: finite executable control (not a theorem)
executed_commands: sh interactive/run-yantra.sh --wire < infra/smoke_requests.jsonl ; sh interactive/run-yantra.sh --wire < infra/false_candidate.jsonl (env as above; each run in its own YANTRA_OUT)
exit_status_and_log: exit 0 / exit 0; every answer is samkramana or dosalekha with nirnaya, pramanya, vyaya; logs listed above
negative_controls: false candidate rejected by the kernel with "0 != 1 of type ℕ" (false.stderr.log, false.wire-transcript.jsonl)
correction_of: none
endpoint_dependency_discharged: none (infrastructure)
remaining_assumptions: none beyond the pinned toolchain
```

## MadhyaCheda — quadratic midpoint secant, hidden square, returning work

```text
claim_id: NV-MIDPOINT-ALG
statement: Over any ring with a biadditive B, N v = B v v, DN x b = B x b + B b x: 2·(N(a+b) − N a) = DN(2a+b) b (the secant is the midpoint derivative, stated with the doubling on the left so no division by 2 is needed); N(a+b) − N a − DN a b = N b; DN(a+b) b − (N(a+b) − N a) = N b; if ⟪v, N v⟫ = 0 for all v then ⟪a, N(a+b) − N a⟫ + ⟪b, N(a+b)⟫ = 0; and the passivity identity 1·(−y − y²) + (y·(1 + (1−ν)y) + ν y²) = 0.
source_class: algebraic core of N-MIDPOINT, N-STORAGE, A-POLARIZE (handoff §43–44, [S19]); R-PASSIVE rational identity
parameters_and_quantifiers: ∀ Ring R, ∀ biadditive B, ∀ a b; conserved pairing as a hypothesis; passivity: ∀ y ν in a CommRing
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/MadhyaCheda_TheQuadraticSecantIsTheDerivativeAtTheMidpointFreezingAtEitherEndMissesTheHiddenSquareAndTheReturningWorkIsExactlyMinusTheHiddenWork.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities
existing_terms_reused: Cubical.Algebra.Ring / CommRing, RingTheory (+ShufflePairs, -Dist, ·DistL+ …)
new_derivation_or_artifact: secant-is-midpoint-derivative, frozen-at-source-loses-the-square, frozen-at-sum-doubles-the-square, returning-work-is-minus-hidden-work, passive-despite-amplification
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: see NV-CONTROLS below (Vartana/PunarAgamana/AbelaRupa mutants rejected); during construction the checker rejected a wrong rearrangement in the diff lemma
correction_of: C34 (midpoint, not endpoint, evaluation of DN) is what the two frozen-* theorems make exact
endpoint_dependency_discharged: none; the analytic N-MIDPOINT propagator U_Q is not formalized
remaining_assumptions: the actual N is bilinear-realizable (A-POLARIZE); function-space content of N-STORAGE
```

## PramanaPatra — block elimination certificate in projection form

```text
claim_id: NV-CERT-PROJ
statement: In a ring with an idempotent P, Q = 1 − P, and a hidden-block inverse H (H = QHQ, QMH = Q, HMQ = Q), the tuple S = PMP − PMHMP, T = P − PMH, Rec = P − HMP, Z = H satisfies P·Rec = P, P·Z = 0, M·Rec = S, M·Z − 1 = −T, Rec·P + Z·M = 1, T·M = S; hence S y = T b ⇒ M(Rec y + Z b) = b, M x = b ⇒ S(Px) = Tb and x = Rec(Px) + Zb, and solutions are unique when M has a left inverse.
source_class: algebraic core of K-CERT (handoff §45, [S18]) with E = P (projection form, no transpose)
parameters_and_quantifiers: ∀ Ring, ∀ M P H with the three hidden-inverse hypotheses, ∀ sources b, ∀ x y
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/PramanaPatra_BlockEliminationByAnIdempotentIsALosslessCertificateTheReducedAndFullEquationsAreEquivalentForEverySourceAndTheForcingMapTransportsTheOperator.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities
existing_terms_reused: Cubical.Algebra.Ring, RingTheory
new_derivation_or_artifact: visible-round-trip, no-visible-correction, reduction-of-M, source-equation, every-solution-reconstructs, transport-law, reduced-solves-full, full-reduces, full-reconstructs, unique-solution
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS; four wrong associativity/negation steps were rejected while building the module
correction_of: C01 (certificates carry source transport, not only the reduced operator): the source-equation and transport-law are the checked form
endpoint_dependency_discharged: K-CERT identities for the single-elimination case; composition is the next record
remaining_assumptions: the hidden block inverse H is a hypothesis (existence is the finite exact elimination in [S18]'s kernel.py)
```

## PunarAgamana — ordered return recurrence and projected Leibniz defect

```text
claim_id: NV-RENEWAL
statement: For an idempotent P with blocks A = PLP, B = PLQ, C = QLP, D = QLQ and K n = P Lⁿ P: Q Lⁿ P = W n where W 0 = 0, W (n+1) = C·K n + D·W n; K (n+1) = A·K n + B·W n (unrolling W gives Σⱼ B Dʲ C K_{n−1−j}); K 2 = A·A + B·C; and for a derivation 𝓛 and an idempotent 𝒫 on a commutative ring, 𝒬𝓛(hk) − (𝒬𝓛h)k − h(𝒬𝓛k) = (𝒫𝓛h)(𝒬k) + (𝒬h)(𝒫𝓛k).
source_class: algebraic core of N-RENEWAL, K-EXCURSION, N-OBSRETRACT (handoff §38, [S17],[S25])
parameters_and_quantifiers: ∀ Ring, ∀ L, ∀ idempotent P, ∀ n; Leibniz defect: ∀ CommRing, derivation 𝓛, additive idempotent 𝒫 (𝒫 need not be a ring hom), ∀ h k
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/PunarAgamana_TheProjectedPowersOfAnOperatorObeyAnOrderedReturnRecurrenceWhoseKernelIsExcursionThroughTheHiddenBlockAndTheProjectedDerivationFailsLeibnizByExactlyTheCrossSectorTerms.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities
existing_terms_reused: Cubical.Algebra.Ring; the insert lemma E·(X·Y)·P = (E·X·P)(P·Y·P) + (E·X·Q)(Q·Y·P) plays the role of formal/cubical/theorems/automata/ExcursionReturn
new_derivation_or_artifact: insert, hidden-is-horner, return-recurrence, first-return, projected-leibniz-defect
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: first-return with the B·C term deleted is rejected
correction_of: C33 (the orthogonal generator is not a derivation): the defect is now a checked identity
endpoint_dependency_discharged: the formal-series recurrence of N-RENEWAL; the Banach-space realization is not
remaining_assumptions: the PDE observable algebra is a commutative ring with 𝓛 a derivation; 𝒫 is an additive idempotent (§38 retraction)
```

## AbelaRupa — Abel normal form of the damped shift and the residual tower

```text
claim_id: NV-ABEL-NF
statement: In a commutative ring with a resolvent c·(1 − ρT) = 1 and B = (1−ρ)T c: 1 − B = c(1 − T), (1−B)ᵐ = cᵐ(1−T)ᵐ, and for the normalized source Y k = c̄ᵏ·S k the m-th forward difference is Δᵐ Y k = c̄^{k+m}·Aᵐ k where A^{m+1} = res(Aᵐ), res f k = f(k+1) − c·f k.
source_class: algebraic core of R-ABEL, R-DYADIC (handoff §62, [S19],[S20])
parameters_and_quantifiers: ∀ CommRing, ∀ ρ T c with the resolvent identity, ∀ m k, ∀ sequences S
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/primes/AbelaRupa_TheResolventOfTheDampedShiftNormalizesTheShiftDefectSoItsPowersInvertEveryOrderAndTheDyadicDifferencesOfTheNormalizedSourceAreTheResidualTower.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities
existing_terms_reused: Cubical.Algebra.CommRing; +-suc from Cubical.Data.Nat
new_derivation_or_artifact: normal-form, normal-form-power, difference-is-rescaled-residual
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: normal-form with the sign of T flipped is rejected
correction_of: C51 (the all-order inverse must be built from the c0 shift identity, not the old high-order assertion): the normal form is the shift identity
endpoint_dependency_discharged: none; the strong c0 convergence and the (√2−1)^{−m} bound are analytic
remaining_assumptions: c0 topology, boundedness of A_m (O-RDYADIC)
```

## Vartana — first-return radial operator, inward powers, indicial factorization

```text
claim_id: NV-RADIAL-RETURN
statement: For a derivation d on a commutative ring with a radius r, d r = 1: r·𝒞(g,h,p,f) = boundary-forms + d(antiderivative) with 𝒞 = 15gh + 6r g′h + 3r g h′ + pf − r p′ f − 4 r p f′; (r²d² + 6r d) rᵏ = k(k+5) rᵏ for every k; and k(k−1) + 6k − (l−2)(l+3) = (k − (l−2))(k + (l+3)), so the inward root k = l−2 and the outward root k = −(l+3), and l = 2 is the only degree whose inward exponent is 0.
source_class: algebraic core of N-RETURN24, N-INVERSE2, N-TOROIDAL (handoff §19–25, [S12],[S15])
parameters_and_quantifiers: ∀ CommRing, ∀ derivation d with d r = 1, ∀ g h p f, ∀ k : ℕ, ∀ k l in the ring
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/Vartana_TheFirstReturnRadialOperatorIsThreeBoundaryFormsPlusAnExactDerivativeAndTheIndicialPolynomialOfEveryToroidalDegreeFactorsSoDegreeTwoIsTheOnlyMarginalChannel.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveℕ!) for closed ring/ℕ identities; NatSolver for the ℕ coefficient k(k+5)
existing_terms_reused: the derivation lemmas d-zero, d-neg, d-scale, d-pow follow formal/cubical/theorems/physics/PurnaAvakalana
new_derivation_or_artifact: return-integrates-by-parts, radial-power, indicial-factors, inward-root-coefficient
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: indicial-factors with (l+2) in place of (l+3) is rejected
correction_of: none
endpoint_dependency_discharged: none; the boundary forms are the terms the analytic argument integrates over the shell
remaining_assumptions: decay/regularity making the boundary forms vanish; the actual toroidal projection P₂ and Biot–Savart source are interfaces, not formalized
```

## NV-CONTROLS — mutation negative controls

Three copies of the green modules were mutated in exactly one theorem statement and rechecked with the same command (`agda --safe`, inside the library tree). All three are rejected at the mutated line; sources and logs are in research/handoff_20260908/validation/native/mutants/.

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M1 | PunarAgamana | `first-return : K 2 ≡ Ablk · Ablk + B · C` → `≡ Ablk · Ablk` | 42 | MismatchedProjectionsError at the first-return proof (`_+_` vs `_·_`) |
| M2 | Vartana | `(k + (l + three))` → `(k + (l + two))` in indicial-factors | 42 | solve! normal forms differ (`-_` vs `0r`) |
| M3 | AbelaRupa | `c · (1r + (- T))` → `c · (1r + T)` in normal-form | 42 | UnequalTerms `- T != T` |

The rejections are at the mutated statements, so the checker discriminates the exact identities, not only well-formedness.
