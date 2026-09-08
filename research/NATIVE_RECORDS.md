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

## DvipadaGuna — iterated Leibniz law for the observable lift

```text
claim_id: NV-LIFT-BINOMIAL
statement: For a derivation 𝓛 on a commutative ring, 𝓛ⁿ(h·k) ≡ Σ_{a+b=n} C(a+b,a)·𝓛ᵃh·𝓛ᵇk for every n (the boxed identity of handoff §37); unfolded at n = 2: 𝓛²(hk) = h𝓛²k + 2𝓛h𝓛k + 𝓛²h k. The sum over a+b = n is a recursion on n with the binomial as a function of the pair, so no truncated subtraction enters; the Pascal step is proved as an exact re-indexing lemma for every row function obeying Pascal's rule and the two edge rules.
source_class: algebraic core of N-LIFT (FORMAL-SERIES, [S17]); makes the coefficientwise product preservation of exp(𝓛) exact
parameters_and_quantifiers: ∀ CommRing, ∀ additive Leibniz 𝓛, ∀ n : ℕ, ∀ h k
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/DvipadaGuna_TheIteratesOfADerivationOnAProductAreTheBinomialSumOfIteratesSoTheObservableLiftPreservesProductsCoefficientwiseAtEveryOrder.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) for closed commutative identities
existing_terms_reused: RingTheory (+ShufflePairs); the derivation lemmas follow PurnaAvakalana/Vartana
new_derivation_or_artifact: Cb (pair binomial, C(4,2)=6 by refl), D (sum over a+b=n), shift-row, pascal-D, step, iterated-leibniz, second-order
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-2: breaking Pascal's rule in Cb is rejected
correction_of: C33 companion: the full-space lift is a derivation at every order; the projected one is not (PunarAgamana)
endpoint_dependency_discharged: the formal-series part of N-LIFT
remaining_assumptions: that the PDE observable algebra is a commutative ring and 𝓛h = Dh[F] is a derivation on it; no convergence of the time-Taylor series is claimed
```

## YogaPatra — certificate composition, derived transport law, nilpotent causal inverse

```text
claim_id: NV-CERT-COMPOSE
statement: In any ring with an additive anti-multiplicative t fixing 1 (a transpose): (१) the five checker identities E·R = 1, E·Z = 0, M·R = tE·S, M·Z + tE·T = 1, R·E + Z·M = 1 imply the transport law T·M = S·E; (२) for a certificate c₁ of M and a certificate c₂ of its reduced operator S₁, the composite E = E₂E₁, S = S₂, T = T₂T₁, R = R₁R₂, Z = Z₁ + R₁Z₂T₁ satisfies all five identities for M, so `compose : Cert M`; (३) in a commutative ring, K³ = 0 gives (1 − zK)(1 + zK + z²K²) = 1 for every z.
source_class: algebraic core of K-CERT (EXACT-CONTROL, handoff §45, [S18]); (३) is the "large norm is not a causal-inverse failure" control, checked in the form 1 + zK + z²K² (the chapter prints the last term as z²K)
parameters_and_quantifiers: ∀ Ring, ∀ t with t-add, t-mul, t-one, ∀ M, ∀ certificates c₁ c₂ (the mismatched-intermediate rejection is the type: c₂ must be a Cert of Cert.S c₁); (३) ∀ CommRing, ∀ z K
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/YogaPatra_TheCompositeOfTwoEliminationCertificatesIsACertificateTheTransportLawFollowsFromTheFiveCheckedIdentitiesAndANilpotentCausalKernelHasAPolynomialInverseWhateverItsNorm.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) for closed commutative identities
existing_terms_reused: RingTheory (0LeftAnnihilates, 0RightAnnihilates); the projection-form certificate is PramanaPatra (NV-CERT-PROJ)
new_derivation_or_artifact: record Cert, transport-law, compose-eliminates, compose-source-blind, compose-reduces, compose-transforms, compose-reconstructs, compose, nilpotent-causal-inverse
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-2: dropping the T₁ factor from the composite Z is rejected
correction_of: C01: "exact composition installs the full session" is now a checked term, not a kernel.py convention
endpoint_dependency_discharged: K-CERT composition rule; what remains for K-CERT is wiring this Cert type to the Yantra install/retire path
remaining_assumptions: the transpose is a hypothesis (t-add, t-mul, t-one); over matrices it is the ordinary transpose
```

## DviSthana — two-sector reflection block, Schur pivot, poles, damped cosh

```text
claim_id: NV-SCHUR-BLOCK
statement: In the commutative block algebra α·I + β·X with X² = I, for the resolvent block (d, σ), d = λ + iγ: (d,σ)⊗(d,−σ) = (d² − σ², 0); any inverse (ρ,τ) has ρ(d² − σ²) = d and τ(d² − σ²) = −σ, so R₊₊ = d/(d² − σ²); with Σ·d = σ², (d − Σ)·d = d² − σ² (the self-energy is subtracted); at d = 0 the block (0,σ) has inverse (0, 1/σ) = X/σ, so the pivot pole is removable; (d − σ) + (d + σ) = 2d, so the genuine poles d = ±σ carry residue ½ each; with ∂e = −g e, ∂c = σ s, ∂s = σ c the block K = (e·c, −e·s) satisfies ∂K = G⊗K for G = (−g, −σ), its retained channel is e·c = e^{−iγt}cosh σt, and it starts at 1.
source_class: exact finite instance of R-SCHUR (handoff §64, [S17–S18]); the same block normal form as the NS return (PunarAgamana)
parameters_and_quantifiers: ∀ CommRing, ∀ d σ (∀ Σ with Σd = σ²; ∀ inverse (ρ,τ); ∀ s with σs = 1); evolution: ∀ derivation ∂ and e c s g σ with the three ODE hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/DviSthana_TheTwoSectorReflectionBlockResolvesExactlyThePivotPoleOfTheSelfEnergyIsRemovableTheGenuinePolesSitAtPlusMinusSigmaWithResidueOneHalfAndTheRetainedChannelIsADampedCosh.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) for closed commutative identities
existing_terms_reused: Cubical.Data.Sigma pairs; derivation lemmas as in Vartana
new_derivation_or_artifact: _⊗_, X-squares-to-𝟙, resolvent-factor, resolved-plus-plus, resolved-plus-minus, schur-denominator, pivot-inverse, residues-are-halves, evolves, retained-channel, starts-at-one
proof_status: formal theorem checking (--safe, no postulates); the block algebra is the exact 2×2 case, not an operator-theoretic statement
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-2: residues-are-halves with 2d replaced by d is rejected
correction_of: C50/C52 (the pivot pole is not a pole of the full problem; positive self-energy is subtracted, not a dissipation proof): both are checked identities here
endpoint_dependency_discharged: none; Σ(1) = 0 ⇔ RH across all orbits is analytic
remaining_assumptions: existence of cosh/sinh/exponential elements with the stated derivatives (a differential ring containing them)
```

## SmrtiMula — emitted forcings are exact, weighted forcing is memory plus exact, log-radius factorization, symbol

```text
claim_id: NV-MEMORY-FINITE
statement: Over a commutative ring with a derivation ∂ and ∂r = 1: r⁴g·(5gf + 2rg′f + rgf′) ≡ ∂(r⁵g²f) (β₂ exact); with f = r²hφ, g = h³: 3rgf′ − 6gf − rg′f ≡ 3r³h⁴∂φ (β₄ exact); with f = −(r²g″ + 6rg′) the toroidal inverse: 2r(5gf + 2rg′f + rgf′) ≡ 2(9rg² − r³g′²) + ∂(−2r⁴gg″ − 18r³gg′ − r⁴g′² − 9r²g²), i.e. ∫rβ₂ = (6/7)𝓘[f]; in log radius (Dr = r), (4 − 3D − D²)(rg) ≡ r·(−(D²g + 5Dg)) and 9b² − (rDg)² ≡ 8b² − (Db)² + D(b²) for b = rg; (4+ξ²)² + 9ξ² ≡ (1+ξ²)(16+ξ²); the scaled kernel matrix [[8,11],[11,8]] has eigenvalues 19 and −3.
source_class: algebraic cores of N-LEAK4, N-MEMORYK, N-SIGNEDK (handoff §21, §24; [S12],[S16])
parameters_and_quantifiers: ∀ CommRing, ∀ derivation ∂, ∀ r with ∂r = 1 (resp. Dr = r), ∀ g f h φ ξ
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/SmrtiMula_TheEmittedForcingsAreExactDerivativesTheWeightedQuadrupoleForcingIsTheMemoryQuadraticPlusAnExactDerivativeTheLogRadiusSourceIsAFactoredOperatorAndItsSymbolIsTheProductOfTwoShiftedSquares.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas whose numerals are written as explicit sums of 1r (ι n unfolds to them definitionally)
existing_terms_reused: derivation lemmas as in Vartana; the two-radius kernel positivity itself is SmrtiBija
new_derivation_or_artifact: β₂-is-exact, β₄-is-exact, weighted-forcing-is-memory-plus-exact (with toroidal-f and memory-bracket), factored-operator, memory-integrand, symbol-modulus, kernel-eigenvalue-19, kernel-eigenvalue-minus-3
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (28 s)
negative_controls: NV-CONTROLS-3: symbol-modulus with 16 replaced by 15 is rejected
correction_of: none; makes exact the "bracketed functions vanish at both support ends" step behind the generic sign change of β₂, β₄ and 𝓘[β₂,ε] < 0
endpoint_dependency_discharged: none; the integrals, the boundary vanishing and the Fourier/Plancherel step are analytic
remaining_assumptions: f, g are the actual radial profiles with compact support so the brackets vanish at the ends; h = g^{1/3} exists (g > 0)
```

## PidaMatra — noncommutative spherical pressure bracket is r times an exact derivative

```text
claim_id: NV-PRESSURE-MATRIX
statement: Over any ring (noncommutative) with a derivation ∂ and a central radius r, ∂r = 1, for an arbitrary profile G with V = rG′, W = r²G″: r·∂(15G² + 3r(GG′ + G′G) − r²G′²) ≡ 18(GV + VG) + 3(GW + WG) + 4V² − (VW + WV). This is the doubled form of "the radial integrand of (12/35)[18G∘V + 3G∘W + 2V² − V∘W]₀ is the derivative of (15/2)G² + 3rG∘G′ − (r²/2)G′²", valid when G, G′, G″ do not commute.
source_class: algebraic core of N-PRESSURE (handoff §20, [S12]); the Lane III "full matrix identity, not only the diagonal A case"
parameters_and_quantifiers: ∀ Ring, ∀ derivation ∂, ∀ central r with ∂r = 1, ∀ G
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/PidaMatra_TheSphericalPressureBracketOfARadialMatrixProfileIsRTimesTheDerivativeOfAQuadraticFormEvenWhenTheProfileAndItsDerivativesDoNotCommute.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.MonoidSolver (solveCommMonoid) on the additive commutative monoid of the ring, applied through an abstract-monoid lemma so the goal is not normalized away
existing_terms_reused: AbGroup→CommMonoid, Ring→AbGroup, RingTheory (-Dist, -DistR·, 0RightAnnihilates)
new_derivation_or_artifact: AdditiveShape.rearrange (the seven-monomial multiset identity), L1–L3, R1–R4, pressure-bracket-is-exact
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-3: replacing G′·G′ by G′·G in Φ₂ is rejected
correction_of: none
endpoint_dependency_discharged: none; the spherical average producing the bracket and the trace-free projection are analytic/finite-geometric steps not formalized here
remaining_assumptions: r central (scalar radius times matrix profile); the spherical-moment identity that yields the bracket from tr((∇u₂)²)
```

## Sopana — damping-moment Weyl ladder and the lossless oscillator

```text
claim_id: NV-LADDER
statement: (१) For any additive ℒ and sequence G with ℒG₀ = ZZ and ℒG_{n+1} = (n+1)·G_n: ℒⁿ⁺¹G_n ≡ n!·ZZ for every n. (२) For a derivation ∂ with ∂s = 1 and an additive D commuting with ∂, ℒφ = 2sφ − Dφ satisfies ℒ(∂φ) − ∂(ℒφ) ≡ −2φ, i.e. [ℒ, −½∂] = I; and with ∂E = −2tE, ∂t = 0: ∂(tⁿE) ≡ −2tⁿ⁺¹E (R raises). (३) With p′ = −γq + f₁, q′ = γp + f₂: ∂(p² + q²) ≡ 2(pf₁ + qf₂), the stored energy changes by the supplied work Re(f̄a).
source_class: algebraic cores of R-LADDER (FORMAL-SERIES), R-INVERSE, and the §61 lossless-oscillator realization under R-PASSIVE (handoff §57, §61; [S09],[S10])
parameters_and_quantifiers: ∀ CommRing; (१) ∀ additive ℒ, ∀ G ZZ with the two rung hypotheses, ∀ n; (२) ∀ derivation ∂, ∀ s with ∂s = 1, ∀ additive D with D∂ = ∂D, ∀ φ; ∀ t E n; (३) ∀ γ p q f₁ f₂ with the two ODE hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Sopana_TheDampingMomentLadderIsAWeylPairSoTheLoweringOperatorAppliedNPlusOneTimesToTheNthMomentIsNFactorialTimesTheSourceSquareAndTheLosslessOscillatorStoresExactlyTheSuppliedWork.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: scale-+/scale-· as in Vartana; derivation lemmas as before
new_derivation_or_artifact: Ladder.ladder (with ℒ^ and fact), weyl, raising, stored-work
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-4: weyl with −3φ in place of −2φ is rejected
correction_of: none; the §57 regularity guard is respected by taking ℒG_n = nG_{n−1} as a hypothesis on the declared domain rather than deriving it by integration by parts
endpoint_dependency_discharged: the formal-series content of R-LADDER
remaining_assumptions: the integration-by-parts identities ℒG₀ = Z⊗Z̄, ℒG_n = nG_{n−1} on the declared domain (distributional/resolvent interpretation or a smoother faithful packet)
```

## ArdhaTala — Hardy/Bergman overlap geometry, reflection readings, Cauchy and Vandermonde determinants

```text
claim_id: NV-HALFPLANE
statement: (१) |2s − z − w̄|² − |z − w|² ≡ 4(s − Re z)(s − Re w), so |⟨h_z,h_w⟩|² = |⟨F_z,F_w⟩| = 1 − ρ_s(z,w)²; (२) on a reflection pair, s² − (s−σ)(s+σ) ≡ σ² (Gram det = σ²/s²) and 2s² − 2(s−σ)(s+σ) ≡ 2σ² (‖F_z − F_θz‖² = 2σ²/s²), and the three curvature readings agree mode by mode; (३) with c² = 1 + sh²: (c − sh)² + (c + sh)² − 2 ≡ 4sh² (the holonomy defect e^{−2tσ} + e^{2tσ} − 2 = 4sinh²(tσ)); (४) Cauchy determinants with rows cleared: 2×2 ≡ (x₂−x₁)(y₂−y₁), 3×3 ≡ Π_{i<j}(x_j−x_i)(y_j−y_i), which is det C_F = Π ρ² and the Schur new-atom residual Π_{w∈F} ρ(z,w)²; (५) amplitude-weighted Vandermonde 2×2 and 3×3 determinants ≡ Πa_i·Π_{i<j}(z_j − z_i).
source_class: algebraic cores of R-GEOMETRY (CONDITIONAL), R-CURVATURE, R-MINORS, and the §59 defect identity under R-HOLONOMY (handoff §58–60; [S09])
parameters_and_quantifiers: ∀ CommRing; identities in the real/imaginary parts s x y u v, σ, c sh, x_i y_j, a_i z_i
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/ArdhaTala_TheHardyAndBergmanOverlapsOfTwoZerosAreOneMinusTheSameHyperbolicRatioTheReflectionPairReadsSigmaSquaredOverSSquaredInEveryReadingAndTheFiniteGramDeterminantIsTheProductOfTheRatios.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none beyond the library
new_derivation_or_artifact: overlap-identity, reflection-gram-determinant, bergman-reflection-difference, curvature-readings, sinh-defect, cauchy-2, cauchy-3, vandermonde-2, vandermonde-3
proof_status: formal theorem checking (--safe, no postulates); finite-rank instances (2 and 3 atoms) of the determinant statements
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (12 s, the 3×3 Cauchy determinant included)
negative_controls: NV-CONTROLS-4: cauchy-3 with one factor reversed in sign is rejected
correction_of: none
endpoint_dependency_discharged: none; R-GEOMETRY stays conditional (the zeros are inputs)
remaining_assumptions: the inner products are the stated half-plane kernels; the infinite-product/closed-span statements of R-MINORS and the non-uniform Riesz/Bessel bounds are analytic
```

## NV-CONTROLS — mutation negative controls

Three copies of the green modules were mutated in exactly one theorem statement and rechecked with the same command (`agda --safe`, inside the library tree). All three are rejected at the mutated line; sources and logs are in research/handoff_20260908/validation/native/mutants/.

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M1 | PunarAgamana | `first-return : K 2 ≡ Ablk · Ablk + B · C` → `≡ Ablk · Ablk` | 42 | MismatchedProjectionsError at the first-return proof (`_+_` vs `_·_`) |
| M2 | Vartana | `(k + (l + three))` → `(k + (l + two))` in indicial-factors | 42 | solve! normal forms differ (`-_` vs `0r`) |
| M3 | AbelaRupa | `c · (1r + (- T))` → `c · (1r + T)` in normal-form | 42 | UnequalTerms `- T != T` |

The rejections are at the mutated statements, so the checker discriminates the exact identities, not only well-formedness.

## NV-CONTROLS-2 — mutation negative controls for the second batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M4 | DvipadaGuna | Pascal rule `Cb a (suc b) +ℕ Cb (suc a) b` → `Cb a (suc b) +ℕ Cb a b` | 42 | first failure is the sanity check `Cb 2 2 ≡ 6` (`4 != 6`); the checker stops there |
| M5 | YogaPatra | composite `Z∘ = Z₁ + (R₁ · Z₂) · T₁` → `Z₁ + (R₁ · Z₂)` | 42 | UnequalTerms in compose-transforms (`Rc · Z != Rc`) |
| M6 | DviSthana | `residues-are-halves : … ≡ d + d` → `≡ d` | 42 | solve! normal forms differ (`_+_` vs `1r`) |

## NV-CONTROLS-3 — mutation negative controls for the third batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M7 | SmrtiMula | `symbol-modulus … (ι 16 + ξ · ξ)` → `(ι 15 + ξ · ξ)` | 42 | solve! normal forms differ at symbol-modulus |
| M8 | PidaMatra | `Φ₂ = … − r²·(G′ · G′)` → `− r²·(G′ · G)` | 42 | the Leibniz expansion L3 no longer matches the seven-monomial shape |

## NV-CONTROLS-4 — mutation negative controls for the fourth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M9 | Sopana | `weyl : … ≡ - (ι 2 · φ)` → `≡ - (ι 3 · φ)` | 42 | solve! normal forms differ at weyl |
| M10 | ArdhaTala | `cauchy-3 … (y₃ + (- y₂))` → `(y₂ + (- y₃))` | 42 | solve! normal forms differ at cauchy-3 |
