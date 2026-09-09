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

## DviMana — two-metric conservation algebra

```text
claim_id: NV-TWOMETRIC
statement: In any ring with J² = 1, a transfer T with two-sided inverse, and S with (S·J)·T = J: S = J·T⁻¹·J, so the metric C = S·T is the reflected loop J·T⁻¹·J·T; the conservation law reverses, (T·J)·S = J; J-conjugation inverts C on both sides, (J·C·J)·C = 1 = C·(J·C·J); and for a normal transfer (S·T = T·S) the reciprocal cycle J·T·J·T⁻¹ is C⁻¹.
source_class: algebraic core of A-JUNITARY (handoff §12, [S14]); the loop orientations of §59 both stated with exact hypotheses
parameters_and_quantifiers: ∀ Ring (noncommutative), ∀ J T S T⁻¹ with the four hypotheses; ४ additionally S·T = T·S
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/DviMana_TheTwoMetricConservationLawMakesTheMetricTheReflectedInverseLoopTheLoopIsInvertedByJConjugationAndForANormalTransferTheReciprocalLoopIsItsInverse.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; hand associativity only (no solver)
existing_terms_reused: none
new_derivation_or_artifact: star-is-reflected-inverse, metric-is-reflected-loop, reverse-conservation, J-conjugation-inverts, C-inverts-J-conjugation, reciprocal-loop-is-inverse
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-5: reverse-conservation with 1r in place of J is rejected
correction_of: C50 companion: the two loop orientations are distinguished by their hypotheses (normality) rather than by the word "holonomy"
endpoint_dependency_discharged: none
remaining_assumptions: positivity of C = T*T, the logarithm A = ½ log C and its anti-commutation with J are operator-theoretic; the generator identity G*J + JG = 0 along a path is not formalized
```

## DhruvaMula — shifted-derivative ladder and the free viscous response

```text
claim_id: NV-SHIFTED-LADDER
statement: With ∂E = zE and ∂t = 1, ℒ = ∂ − z satisfies ℒ(E·t⁰) = 0 and ℒ(E·tᵏ⁺¹) = (k+1)·E·tᵏ, hence ℒᵏ⁺¹(E·tᵏ) ≡ 0 (E times polynomials of degree < m lie in ker ℒᵐ) and ℒᵏ(E·tᵏ) ≡ k!·E (the top coefficient survives); the first is the Sopana ladder instantiated. With ∂erf = κe, ∂e = −2qe, ∂q = 1, ∂κ = 0: ∂[3erf − κe(3q + 2q³)] ≡ 4κq⁴e, i.e. H5 is the antiderivative of (8/(3√π)) q⁴ e^{−q²}.
source_class: algebraic cores of R-THETA / R-CARDINAL (the finite Ξ-derivative polynomial in the two-sided (D−z)^m inverse difference, handoff §51) and N-H5 (handoff §22)
parameters_and_quantifiers: ∀ CommRing, ∀ derivation ∂, ∀ z E t with the two hypotheses, ∀ k; ∀ κ e erf q with the four hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/DhruvaMula_TheShiftedDerivativeLowersExponentialTimesPowersSoItsMthPowerKillsDegreeBelowMAndKeepsTheTopCoefficientAndTheFreeViscousResponseIsTheAntiderivativeOfAQuarticGaussian.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r; imports Sopana (Ladder, ι, scale, fact)
existing_terms_reused: Sopana.Ladder (ladder, ℒ^), Sopana.ι, Sopana.scale, Sopana.fact
new_derivation_or_artifact: pow, G, ℒ, t∂pow, base, step, kills-below, keeps-top, H5₃, h5-derivative
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-5: h5-derivative with q³ in place of q⁴ is rejected
correction_of: none
endpoint_dependency_discharged: none; Ξ-interpolation, zero multiplicity and double-exponential tails are analytic
remaining_assumptions: e^{zt}, tᵏ, erf and e^{−q²} live in a differential ring with the stated derivatives; the lifetime integral ∫H5 dt = r²/(6ν) is analytic
```

## Sikhara — the exact peak ledger and the scale gains

```text
claim_id: NV-PEAK-LEDGER
statement: Over a commutative ring with derivations, for ω = mξ with ξ₁² + ξ₂² + ξ₃² = 1 (doubled to avoid dividing by 2): 2·ξ·∂∂(mξ) ≡ 2·(∂∂m − m|∂ξ|²) and 2·ξ·D(mξ) ≡ 2·Dm; hence from the componentwise vorticity equation D(mξᵢ) = Sᵢ + νΔ(mξᵢ) and ξ·S = αm: 2·Dm ≡ 2·(αm + ν(Δm − m|∇ξ|²)), and the ledger 2·αm ≡ 2·Dm + 2·(νm|∇ξ|² − νΔm). Scaling (d = 3): g_C⁵ ≡ g_ω²g_E⁴ for g_ω = Aℓ, g_E = A²λ³, g_C = A²λ² (ℓλ = 1), and the energy chart ℓ = μ⁻², A = μ⁻³, M = μ⁵ has AℓM = 1 and A²ℓ⁻³ = 1.
source_class: algebraic cores of N-PEAK (handoff §27, [S13]) and N-SCALE (handoff §28)
parameters_and_quantifiers: ∀ CommRing, ∀ derivations ∂₁ ∂₂ ∂₃ D, ∀ ξᵢ m ν α Sᵢ with unit, vorticity and stretch hypotheses; ∀ A ℓ λ with ℓλ = 1; ∀ μ μ⁻¹ with μμ⁻¹ = 1
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/Sikhara_TheUnitDirectionAbsorbsNoLaplacianSoTheVorticityMagnitudeObeysItsOwnEquationAndThePeakLedgerIsItsRearrangementWhileTheThreeScaleGainsObeyOneMonomialRelation.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: DviDrsti (the d+2 determinant) is the companion scale module
new_derivation_or_artifact: OneDirection.direction-absorbs-nothing, OneDirection.direction-absorbs-no-rate, Magnitude.magnitude-equation, Magnitude.peak-ledger, gain-relation, energy-chart
proof_status: formal theorem checking (--safe, no postulates); all peak identities in doubled form
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (53 s)
negative_controls: NV-CONTROLS-5: direction-absorbs-nothing with +m|∂ξ|² in place of −m|∂ξ|² is rejected
correction_of: none; makes the §27 quantifier discipline exact: the identity holds pointwise wherever ω ≠ 0, before any envelope/Dini argument
endpoint_dependency_discharged: none (O-NPEAK untouched)
remaining_assumptions: the maximizing point, envelope derivative M′ = Dm and ∇m = 0 at the maximum are analytic; division by 2 needs a ring where 2 is invertible
```

## Grahaka — the fixed packet receiver and the two-packet Weil matrix

```text
claim_id: NV-RECEIVER
statement: With w·w̄ = 1: (1 − Ew̄)(1 − Ew) ≡ 1 − E(w + w̄) + E² and (z + 4)(4 − z) ≡ 16 − z², so G(z) = H(z)H(−z) assembles to 256(1 − 2e⁻¹cosh(z/4) + e⁻²)²/(16 − z²)²; the two-packet Weil matrix has det ≡ (M₀ − Z)(M₀ + Z), trace ≡ 2M₀, values 2(M₀ ± Z) on (1, ±1), and 2·form(x,y) ≡ (M₀ + Z)(x+y)² + (M₀ − Z)(x−y)², so PSD ⇔ |Z| ≤ M₀; the closing inequality is the tail identity up to sign.
source_class: algebraic core of R-PACKET, R-Z, R-TWOPACKET (handoff §46–47, [S02])
parameters_and_quantifiers: ∀ CommRing, ∀ E w w̄ z M₀ Z x y L S J with w w̄ = 1
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Grahaka_TheFixedPacketIsTheProductOfItsTwoHalfPacketsSoItsSymbolIsARealSquareOverSixteenMinusZSquaredAndTheTwoPacketWeilMatrixIsPositiveExactlyWhenTheResponseIsBoundedByItsDiagonal.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none
new_derivation_or_artifact: packet-product, denominator, symbol-assembles, weil-determinant, weil-trace, weil-form, weil-form-on-sum, weil-form-on-difference, weil-form-diagonalizes, closing-argument
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-5: weil-determinant with (M₀ − Z)² in place of (M₀ − Z)(M₀ + Z) is rejected
correction_of: none
endpoint_dependency_discharged: none; R-TWOPACKET stays conditional
remaining_assumptions: the sector bound |arg G| < 37/50, M₀ > 0, absolute convergence of Z, the explicit-formula tail identity for t > 1/2 and the Laplace/residue argument for sufficiency are analytic
```

## Vistara — the dilation generator is skew

```text
claim_id: NV-DILATION-SKEW
statement: Over a commutative ring with three derivations ∂ᵢ and coordinates yᵢ with ∂ᵢyᵢ = 1: (y·∇f)g + f(y·∇g) + 3fg ≡ Σᵢ ∂ᵢ(yᵢ f g), an exact divergence; so y·∇ + 3/2 is skew in L² and D_E = (2/5)(y·∇ + 3/2) = 3/5 + (2/5)y·∇.
source_class: algebraic core of N-ADAPT (handoff §33, [S13])
parameters_and_quantifiers: ∀ CommRing, ∀ Leibniz ∂₁ ∂₂ ∂₃, ∀ y₁ y₂ y₃ with the diagonal derivatives = 1, ∀ f g
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/Vistara_TheDilationGeneratorPlusThreeHalvesIsSkewBecauseItsSymmetricPartOnAProductIsAnExactDivergence.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none
new_derivation_or_artifact: Y, div-y, symmetric-part-is-exact, generator
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-6: 2fg in place of 3fg is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the divergence integrates to zero (decay); the critical real weight 1/5 and the moving gauge terms are analytic
```

## GolakaMatra — spherical-moment contractions

```text
claim_id: NV-SPHERE-MOMENTS
statement: With the sphere moments taken as the tensors 15⟨nᵢnⱼ⟩ = 5δᵢⱼ and 15⟨nᵢnⱼnₖnₗ⟩ = δᵢⱼδₖₗ + δᵢₖδⱼₗ + δᵢₗδⱼₖ over three indices: Σⱼₖ m4(i,j,k,l)Sⱼₖ ≡ Sᵢₗ + Sₗᵢ + δᵢₗ tr S for every 3×3 matrix S, and the second-moment contractions Σⱼ 5δᵢⱼSⱼₗ ≡ 5Sᵢₗ, Σₖ Sᵢₖ5δₖₗ ≡ 5Sᵢₗ, Σⱼₖ Sⱼₖ5δⱼₖ ≡ 5 tr S.
source_class: the spherical-moment algebra the Lane III deliverable asks for (handoff §18–21, [S11],[S12])
parameters_and_quantifiers: ∀ CommRing, ∀ nine entries a₁₁…a₃₃, ∀ i l ∈ {1,2,3} (27 + 1 cases by solve!)
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/GolakaMatra_TheFourthMomentOfTheSphereContractsToTheSymmetrizedEntryPlusTraceTimesIdentityAndTheSecondMomentContractsToFiveTimesTheEntry.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r; the matrix is built from nine explicit entries so each entry is its own solver atom
existing_terms_reused: none
new_derivation_or_artifact: Ix, δ, Σ₃, mat, symm, tr, m4, fourth-contraction, left5, right5, trace5
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (42 s)
negative_controls: NV-CONTROLS-6: Sᵢₗ + Sᵢₗ in place of Sᵢₗ + Sₗᵢ is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the moment tensors are the actual sphere averages (the two integrals ⟨nᵢnⱼ⟩, ⟨nᵢnⱼnₖnₗ⟩)
```

## GolakaTantra — strain tomography and the pressure cross-effect

```text
claim_id: NV-TOMOGRAPHY
statement: For q_u(n) = −P_nSP_n − ½(nᵀSn)P_n: 30⟨q⟩ ≡ −11S − Sᵀ − 6(tr S)I for every S, hence 30⟨q⟩ = −12S for symmetric trace-free S, i.e. S_u = −(5/2)⟨q_u⟩. For a symmetric biadditive H: H[u₂+u⊥] ≡ H[u₂] + 2H(u₂,u⊥) + H[u⊥], and with 7H[u₂] = −2(S²)₀: 7H[u] + 2(S²)₀ ≡ 7(2H(u₂,u⊥) + H[u⊥]).
source_class: algebraic cores of N-TOMOGRAPHY, N-SYMBOL (handoff §18) and N-PRESSURERES (§20)
parameters_and_quantifiers: ∀ CommRing, ∀ entries, ∀ i l; ∀ symmetric biadditive H, ∀ u₂ u⊥ (S²)₀ with the N-PRESSURE hypothesis
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/GolakaTantra_TheAveragedCrossHelicitySymbolIsMinusTwoFifthsOfTheStrainSoTheStrainIsRecoveredFromTheSphericalMeanOfItsSymbolAndThePressureCrossEffectIsTheBilinearRemainder.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r; imports GolakaMatra
existing_terms_reused: GolakaMatra.Contractions
new_derivation_or_artifact: PSP15, nSnP15, q30, tomography, tomography-tracefree, cross-effect, pressure-residual
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-6: 5(tr S)I in place of 6(tr S)I is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the symbol q_u is the stated formula; recovering u from S by inverse Laplacian/divergence and the N-PRESSURE input 7H[u₂] = −2(S²)₀ are analytic
```

## UpaGuna — subset product rule and the linearized generator

```text
claim_id: NV-SUBSET-RULE
statement: ∂₁∂₂(fg) ≡ ∂₁∂₂f·g + ∂₂f·∂₁g + ∂₁f·∂₂g + f·∂₁∂₂g and ∂₃∂₁∂₂(fg) ≡ the eight-term subset sum, for any additive Leibniz ∂ᵢ (no commutation needed); for additive L and symmetric biadditive B, F(ω+v) ≡ F(ω) + (Lv + 2B(ω,v)) + B(v,v).
source_class: algebraic core of A-JETS (handoff §8, [S03]); companion of DvipadaGuna (single-derivation all orders) and PunarAgamana (projected failure)
parameters_and_quantifiers: ∀ CommRing, ∀ ∂₁ ∂₂ ∂₃ additive Leibniz, ∀ f g; ∀ L B ω v
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/UpaGuna_TheMixedDerivativeOfAProductIsTheSumOverSubsetsOfWhichFactorEachDerivationHitsAndTheLinearizedGeneratorOfAQuadraticFlowIsItsLinearPartPlusTwiceThePolarization.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none
new_derivation_or_artifact: subset-rule-2, subset-rule-3, F, DF, linearized-generator
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-6: B(ω,v) in place of B(v,v) as the remainder is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the general |S| subset rule is stated for |S| ≤ 3; the actual B = ½curl(u_a×b + u_b×a) is symmetric biadditive (its definition)
```

## SamaCakra — Beltrami eigenspace cancellation

```text
claim_id: NV-BELTRAMI
statement: With an antisymmetric biadditive ×, additive P, and curl u = λu, curl v = λv: A_u u = K_u u = N(u) (definitionally), A_u v = P(λ(u×v)), K_u v = P(−λ(u×v)), and A_u v + K_u v = P 0: each frozen factor leaks, the actual derivative DN(u)v vanishes. The positive-helicity cross product (0,1,i)×(−1,0,i) = (i,−i,1) is transverse to k = (1,1,0).
source_class: algebraic core of N-BELTRAMI (handoff §9, [S02])
parameters_and_quantifiers: ∀ CommRing, ∀ × P curl λ u v with the stated hypotheses; ∀ i
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/SamaCakra_OnOneCurlEigenspaceEachFrozenFactorLeaksLambdaTimesTheCrossProductWithOppositeSignsSoTheActualDerivativeVanishesWhileTheHelicityCrossProductIsTransverseAndNonzero.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: none
new_derivation_or_artifact: A-frozen, K-frozen, N, A-reproduces, K-reproduces, A-leaks, K-leaks, derivative-vanishes, cross, dot, helicity-cross, transverse
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: (i, i, 1) in place of (i, −i, 1) is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the Leray projection P is additive and the actual × is the vector cross product; the nonzero negative-helicity projection value is a numeric evaluation not formalized
```

## Pratirodha — impedance, Stieltjes, Cayley, dyadic Goldbach normalization

```text
claim_id: NV-IMPEDANCE
statement: (x, y−γ)·conj = (x² + (y−γ)², 0) so Re 1/(w−iγ) = x/(x²+(y−γ)²); (w,γ)(w,−γ) = (w²+γ², 0) and (w+γ)+(w−γ) = 2w (the ±γ pair is a Stieltjes term 2pw/(q+λ)); |α+Y|² − |α−Y|² = 4Re(ᾱY) (Cayley contractive ⇔ right half-plane); (2t)²G₂ − t²G₁ = 4t²G₂ − t²G₁ and t²A² = (tA)² (the dyadic normalization 𝒢(2t) − 𝒢(t) = 4t²(G_R(2t) − ¼G_R(t)), 𝒢 = (tA)²).
source_class: algebraic cores of R-IMPEDANCE, R-OUTPUT (handoff §61) and R-GSQUARE / R-GCRITERION (§63)
parameters_and_quantifiers: ∀ CommRing, ∀ x y γ w α Y t G₁ G₂ A
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Pratirodha_OneSpectralModeOfTheImpedanceHasRealPartXOverXSquaredPlusTheOffsetSquaredThePairedModesAreAStieltjesTermTheCayleyCoefficientIsContractiveExactlyOnTheRightHalfPlaneAndTheDyadicGoldbachResidualIsTheNormalizedDifference.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: complex pairs as in DviSthana
new_derivation_or_artifact: _⊗_, conj, ∣_∣², mode-denominator, mode-real-part, paired-modes, stieltjes-numerator, cayley, dyadic-normalization, normalized-square
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: 2Re(ᾱY) in place of 4Re(ᾱY) is rejected
correction_of: C45/C49 companion: the identities hold per mode; the prefix E_T and the convergent trivial-zero tail are the analytic corrections
endpoint_dependency_discharged: none
remaining_assumptions: positivity p_γ > 0 under RH, convergence of the mode sums, PNT for tA → 1, the Mellin argument
```

## Trikona — the triangular exact NS family

```text
claim_id: NV-TRIANGULAR
statement: For u = (0, a, v) with ∂₂a = ∂₃a = ∂₃v = 0 over a commutative ring with derivations ∂₁ ∂₂ ∂₃ D (∂₃∂₂ = ∂₂∂₃): (u·∇)u ≡ (0, 0, a∂₂v); div((u·∇)u) ≡ 0 (so p = 0 is consistent); div u ≡ 0; the NS residuals with p = 0 are NS₁ ≡ 0, NS₂ ≡ Da − νΔa, NS₃ ≡ Dv + a∂₂v − νΔv; and for the strictly lower-triangular gradient [[0,0,0],[p,0,0],[q,r,0]]: tr M² = 0, M² has the single entry rp, tr M³ = 0, M³ = 0 (Q_inv = R_inv = 0).
source_class: algebraic core of N-FUTURE (handoff §14, [S02]): the exact family behind the finite-jet separator
parameters_and_quantifiers: ∀ CommRing, ∀ derivations, ∀ a v ν with the ansatz hypotheses; ∀ p q r
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/Trikona_TheTriangularFamilyHasConvectiveTermZeroZeroAdvectedVIsDivergenceFreeWithZeroPressureAndItsStrictlyLowerTriangularGradientKillsBothVelocityGradientInvariants.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: leib-zero (∂0 = 0 from Leibniz alone)
new_derivation_or_artifact: advect, convective, convective-collapses, div, convective-is-divergence-free, u-is-divergence-free, Δ, NS₁ NS₂ NS₃, first-component-is-trivial, second-component-is-heat, third-component-is-advected-heat, Q-invariant-vanishes, square-is-one-corner, R-invariant-vanishes, cube-vanishes
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: (0, 0, v∂₂a) in place of (0, 0, a∂₂v) is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the mode recurrence ċ_k, the jet-depth statement c₀^{(j)}(0) = 0 for j < m, the path-counting bound I_m, and the coarse/fine passivity are not formalized
```

## KatalanaSima — the Catalan majorant

```text
claim_id: NV-CATALAN
statement: For ℕ-valued x with x₀ ≤ g and x_{n+1} ≤ b·Σ_{a+c=n} x_a x_c: x_n ≤ bⁿ·Cat_n·gⁿ⁺¹ for every n, where Cat₀ = 1, Cat_{n+1} = Σ_{a+c=n} Cat_a Cat_c (defined through a memo table so the recurrence is structural; Cat₃ = 5 and Cat₅ = 42 by computation, and cat-suc is the proved recurrence).
source_class: exact finite control of N-CATALAN (handoff §40, [S18]); the majorant of the causal tree expansion q = Σ qₙ, qₙ₊₁ = Σ_{a+c=n} C(qₐ,q_c) of N-HISTORY
parameters_and_quantifiers: ∀ x : ℕ → ℕ, ∀ b g, the two hypotheses, ∀ n; proved by strong induction over the pair sum with D-mono, D-ext, D-scale
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/KatalanaSima_AQuadraticallyMajorizedSequenceIsBoundedByCatalanNumbersTimesPowersSoTheTreeExpansionOfTheHiddenHistoryHasAnExplicitMajorant.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; Cubical.Data.Nat.Order (≤-+-≤, ≤-·k, ≤-trans, ≤0→≡0), Cubical.Relation.Nullary (decRec, isPropDec), NatSolver (solveℕ!)
existing_terms_reused: the pair-sum D of DvipadaGuna, now over ℕ
new_derivation_or_artifact: D, D-ext, pow, pow-+, D-mono, D-scale, ≤-split′, ≤-·-≤, catTab, cat, stable, cat-zero, cat-suc, Majorant.bound, product-of-bounds, below, catalan-majorant
proof_status: formal theorem checking (--safe, no postulates); an inequality theorem over ℕ, not only an identity
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-8: gⁿ in place of gⁿ⁺¹ in the bound is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the norm bounds ‖C(x,y)‖ ≤ b‖x‖‖y‖ and ‖g_p‖ ≤ g that feed x; the radius 4bg < 1 and the explicit truncation remainder are analytic (Cat_n ~ 4ⁿ)
```

## Sima — the open frontier is one proposition

```text
claim_id: NV-FRONTIER
statement: With the six route unknowns (O-RBOUND, O-RONESIDE, O-RLOWER, O-RLIFT, O-RDYADIC, O-RGOLDBACH) and RH as propositions, and the received conditional theorems (R-TWOPACKET both ways, R-LANDAU, R-ESCAPE, R-WEILSPACE positivity, R-IMAGE both ways, R-ABEL, R-DYADIC, R-GCRITERION both ways, and "bounded ⇒ one-sided") as hypotheses: each unknown ≃ RH, hence ≡ RH by univalence, and all six routes name one point of hProp; resolving any resolves all (Any → All) and refuting any refutes all; every reading P of one unknown transports to every other by subst along the ua path, and the transported inhabitant is the composed proof. For NS: with the ledger, BKM, and the definition of a maximal solution as hypotheses, O-NPEAK ≃ END-NS.
source_class: the composition of handoff §68 / CLAIM_GRAPH.alternative_routes; no analytic claim is proved, the SHAPE of the frontier is
parameters_and_quantifiers: ∀ ℓ, ∀ propositions RH Bounded OneSided Lower Lift Dyadic Goldbach (resp. Global Maximal PeakWork VortBounded Continuation) with their isProp proofs, ∀ the twelve (resp. six) conditional hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/Sima_TheOpenFrontierIsOnePropositionUpToTheReceivedConditionalTheoremsSoEveryRouteReadsTheSameUnknownResolvingAnyResolvesAllAndEveryReadingTransportsAlongUnivalence.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; propBiimpl→Equiv, ua, Σ≡Prop, subst
existing_terms_reused: the finite cores under each hypothesis: Grahaka, AbelaRupa, SesaDvaya, ArdhaTala, DviSthana, DviMana, PratibimbaTantu, RiktaTantu, Pratirodha, Sikhara (cited, not imported)
new_derivation_or_artifact: RH-Frontier: Bounded≃RH … Goldbach≃RH, the six ua paths, Frontier and route-A…F in hProp, routes-name-one-unknown, All, Any, from-RH, to-RH, resolving-any-resolves-all, refuting-any-refutes-all, transport-reading, transport-any-reading, transport-computes; NS-Frontier: PeakWork≃Global, PeakWork≡Global, NS-Frontier-is-one
proof_status: formal theorem checking (--safe, no postulates) of a conditional structure; the endpoints stay CONDITIONAL, their premises uninstantiated
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-9: using R-DYADIC in place of R-ABEL in the dyadic route is rejected; and the kernel-gate false control below
correction_of: none; this is the §68 sentence "not independent conjectures to prove one after another" made a theorem
endpoint_dependency_discharged: none; what is discharged is the multiplicity: the unsupplied items are one proposition
remaining_assumptions: every hypothesis named by a graph node is the received analytic theorem; "bounded ⇒ one-sided", "vacuous", "no-maximal", "global-of/maximal-of" are the definitional glue of the fixed formulations
```

## Lane I bis — the frontier through the native gate

```text
claim_id: NV-GATE-FRONTIER
statement: A Candidate importing Sima and deriving Dyadic → Goldbach and Dyadic ≡ Goldbach from the route hypotheses is accepted by the Yantra kernel gate (marga: kernel, controls watched first); vislesana returns the kernel's own normal form of the corollary, λ … d → h₁₂ (h₁ (h₉ d)) — the composed proof is literally Goldbach-necessity ∘ TwoPacket-sufficiency ∘ Abel. The same Candidate with the Abel hypothesis removed is rejected with "Dyadic !=< Bounded when checking that h₁₀ has type Dyadic → Bounded": the gate names exactly the missing analytic input.
source_class: metacircular application (handoff §5, §69): the repository's knowledge about the frontier checked and normalized by its own kernel
parameters_and_quantifiers: two fixed request streams
repository_commit: pin 168ea8e2; evidence at (this commit; see git log for the hash)
working_tree_changes: research/handoff_20260908/validation/native/frontier/{positive,false}.{requests.jsonl,wire-transcript.jsonl,stdout.log,stderr.log}, Candidate.{positive,false}.agda.txt
imports_and_toolchain: sh interactive/run-yantra.sh --wire with YANTRA_OUT, DOSA_LEKHA, YANTRA_LEKHA, MATH_CERTCACHE=0, AGDA_DIR=$HOME/.agda-pin
existing_terms_reused: sadhana.patra, sadhana.vislesana; Sima.RH-Frontier
new_derivation_or_artifact: Candidate.positive (corollary, as-path); the normal forms in positive.wire-transcript.jsonl
proof_status: finite executable control plus a formal theorem checked by the kernel gate
executed_commands: sh interactive/run-yantra.sh --wire < frontier/positive.requests.jsonl ; … < frontier/false.requests.jsonl
exit_status_and_log: exit 0 / exit 0; positive: samkramana on all four requests; false: dosalekha with the UnequalTerms line
negative_controls: the false Candidate (Abel hypothesis removed) is rejected at the exact slot
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: none beyond the pinned toolchain
```

## MetacircularReplay — the codex native replay integration, merged and repaired

```text
claim_id: NV-REPLAY
statement: The codex/agda-native-replay-20260908 branch (two files) is merged: MetacircularReplay checks execute/learn/retire/replay of kernel sessions against the actual kernel (receipt targets and traces, one-operation-learned, replay-preserves-base-step-count, two branches, the sample normal form), and WrongSourceMustFail is rejected as intended. Under the pinned Agda the two substRefl steps left an unsolved implicit family; they are given explicitly (B = λ q → Derivation q b) and the module now checks.
source_class: infrastructure (handoff §5 Lane I); repository content from another agent, composed in
parameters_and_quantifiers: none
repository_commit: pin 168ea8e2; merge and fix at (this commit; see git log for the hash)
working_tree_changes: interactive/agda-native-replay/MetacircularReplay.agda (two lines), WrongSourceMustFail.agda (unchanged)
imports_and_toolchain: agda --safe -i interactive/agda-native-replay from formal/cubical
existing_terms_reused: RewriteCertificate, ControlledGrammar, GenerativeKernel, the Dialogue and Normalize kernel modules
new_derivation_or_artifact: none beyond the two explicit families
proof_status: formal theorem checking (--safe)
executed_commands: cd formal/cubical && agda --safe -i ../../interactive/agda-native-replay ../../interactive/agda-native-replay/MetacircularReplay.agda
exit_status_and_log: exit 0 (MetacircularReplay), exit 42 (WrongSourceMustFail, by design: "zero != add var (suc zero)")
negative_controls: WrongSourceMustFail
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: none
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

## NV-CONTROLS-5 — mutation negative controls for the fifth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M11 | DviMana | `reverse-conservation : (T · J) · S ≡ J` → `≡ 1r` | 42 | UnequalTerms `J != 1r` |
| M12 | DhruvaMula | `h5-derivative … (q · q) · (q · q)` → `(q · q) · q` | 42 | UnequalTerms `q · q != q` |
| M13 | Sikhara | `direction-absorbs-nothing … (- (m · Q))` → `(m · Q)` | 42 | solve! normal forms differ |
| M14 | Grahaka | `weil-determinant … (M₀ + Z)` → `(M₀ + (- Z))` | 42 | solve! normal forms differ |

## NV-CONTROLS-6 — mutation negative controls for the sixth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M15 | Vistara | `ι 3 · (f · g)` → `ι 2 · (f · g)` in symmetric-part-is-exact | 42 | solve! normal forms differ |
| M16 | GolakaMatra | `(S i l + S l i)` → `(S i l + S i l)` in fourth-contraction | 42 | solve! normal forms differ (first off-diagonal case) |
| M17 | GolakaTantra | `ι 6 · (tr S · δ i l)` → `ι 5 · …` in tomography | 42 | solve! normal forms differ |
| M18 | UpaGuna | remainder `B v v` → `B ω v` in linearized-generator | 42 | solve! normal forms differ |

## NV-CONTROLS-7 — mutation negative controls for the seventh batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M19 | SamaCakra | `helicity-cross … ≡ (i , - i , 1r)` → `(i , i , 1r)` | 42 | solve! normal forms differ |
| M20 | Pratirodha | `cayley … ≡ ι 4 · …` → `ι 2 · …` | 42 | solve! normal forms differ |
| M21 | Trikona | `convective-collapses … (0r , 0r , a · ∂₂ v)` → `(0r , 0r , v · ∂₂ a)` | 42 | solve! normal forms differ |

## NV-CONTROLS-8 — mutation negative control for the Catalan majorant

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M22 | KatalanaSima | `catalan-majorant : … pow g (suc n)` → `pow g n` | 42 | UnequalTerms `g · pow g n != pow g n` |

## Regression

All modules added since the pin were rechecked in one pass at the end of the session (`agda --safe`, each file separately); see research/handoff_20260908/validation/native/regression.log.

## NV-CONTROLS-9 — mutation negative control for the frontier

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M23 | Sima | dyadic route closed with R-DYADIC in place of R-ABEL | 42 | UnequalTerms (the composite has the wrong type) |
