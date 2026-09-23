# Native records (handoff Â§71 format)

Each record is one checked artifact on branch claude/interactive-daemon-math-vt8e9e over the handoff pin 168ea8e2. The received bundle under research/handoff_20260908/ is unchanged; research/CLAIM_GRAPH.json is the live graph pointing at these loci.

## Lane I â” native Machine gate (positive and false controls)

```text
claim_id: NV-GATE-20260908
statement: The native Machine wire accepts the handoff's positive Candidate through marga: kernel after watching the controls, returns the three vislesana normal forms, and rejects the false control with an Agda type error; both runs exit 0 with isolated logs.
source_class: infrastructure control (handoff Â§5 Lane I; infra/smoke_requests.jsonl, infra/false_candidate.jsonl)
parameters_and_quantifiers: two fixed request streams; no mathematical quantifiers
repository_commit: pin 168ea8e2; evidence committed at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: research/handoff_20260908/validation/native/{preflight.log, positive.stdout.log, positive.stderr.log, positive.wire-transcript.jsonl, false.stdout.log, false.stderr.log, false.wire-transcript.jsonl, vislesana.record.json}
imports_and_toolchain: sh interactive/run-machine.sh --wire; env YANTRA_OUT, DOSA_LEKHA, YANTRA_LEKHA, MATH_CERTCACHE=0, AGDA_DIR=$HOME/.agda-pin; Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities
existing_terms_reused: sadhana.patra, sadhana.vislesana, ControlledGrammar.install, N.normalize, N.learn (formal/cubical/kernel)
new_derivation_or_artifact: vislesana.record.json: answer â¦ suc var : Tm; N.normalize demo â¦ then-step (add-suc var zero) (then-step (suc-step (add-zero var)) (done (suc var))); N.learn demo â¦ ControlledGrammar.install (â¦) : ControlledGrammar.NativeOperation
proof_status: finite executable control (not a theorem)
executed_commands: sh interactive/run-machine.sh --wire < infra/smoke_requests.jsonl ; sh interactive/run-machine.sh --wire < infra/false_candidate.jsonl (env as above; each run in its own YANTRA_OUT)
exit_status_and_log: exit 0 / exit 0; every answer is samorderna or dosalekha with nirnaya, pramanya, vyaya; logs listed above
negative_controls: false candidate rejected by the kernel with "0 != 1 of type â•" (false.stderr.log, false.wire-transcript.jsonl)
correction_of: none
endpoint_dependency_discharged: none (infrastructure)
remaining_assumptions: none beyond the pinned toolchain
```

## MadhyaCheda â” quadratic midpoint secant, hidden square, returning work

```text
claim_id: NV-MIDPOINT-ALG
statement: Over any ring with a biadditive B, N v = B v v, DN x b = B x b + B b x: 2Â(N(a+b) âˆ’ N a) = DN(2a+b) b (the secant is the midpoint derivative, stated with the doubling on the left so no division by 2 is needed); N(a+b) âˆ’ N a âˆ’ DN a b = N b; DN(a+b) b âˆ’ (N(a+b) âˆ’ N a) = N b; if âŸv, N vâŸ = 0 for all v then âŸa, N(a+b) âˆ’ N aâŸ + âŸb, N(a+b)âŸ = 0; and the passivity identity 1Â(âˆ’y âˆ’ yÂ²) + (yÂ(1 + (1âˆ’Î½)y) + Î½ yÂ²) = 0.
source_class: algebraic core of N-MIDPOINT, N-STORAGE, A-POLARIZE (handoff Â§43â“44, [S19]); R-PASSIVE rational identity
parameters_and_quantifiers: âˆ Ring R, âˆ biadditive B, âˆ a b; conserved pairing as a hypothesis; passivity: âˆ y Î½ in a CommRing
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/MadhyaCheda_TheQuadraticSecantIsTheDerivativeAtTheMidpointFreezingAtEitherEndMissesTheHiddenSquareAndTheReturningWorkIsExactlyMinusTheHiddenWork.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities
existing_terms_reused: Cubical.Algebra.Ring / CommRing, RingTheory (+ShufflePairs, -Dist, ÂDistL+ â¦)
new_derivation_or_artifact: secant-is-midpoint-derivative, frozen-at-source-loses-the-square, frozen-at-sum-doubles-the-square, returning-work-is-minus-hidden-work, passive-despite-amplification
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: see NV-CONTROLS below (Vartana/PunarAgamana/AbelaRupa mutants rejected); during construction the checker rejected a wrong rearrangement in the diff lemma
correction_of: C34 (midpoint, not endpoint, evaluation of DN) is what the two frozen-* theorems make exact
endpoint_dependency_discharged: none; the analytic N-MIDPOINT propagator U_Q is not formalized
remaining_assumptions: the actual N is bilinear-realizable (A-POLARIZE); function-space content of N-STORAGE
```

## PramanaPatra â” block elimination certificate in projection form

```text
claim_id: NV-CERT-PROJ
statement: In a ring with an idempotent P, Q = 1 âˆ’ P, and a hidden-block inverse H (H = QHQ, QMH = Q, HMQ = Q), the tuple S = PMP âˆ’ PMHMP, T = P âˆ’ PMH, Rec = P âˆ’ HMP, Z = H satisfies PÂRec = P, PÂZ = 0, MÂRec = S, MÂZ âˆ’ 1 = âˆ’T, RecÂP + ZÂM = 1, TÂM = S; hence S y = T b â’ M(Rec y + Z b) = b, M x = b â’ S(Px) = Tb and x = Rec(Px) + Zb, and solutions are unique when M has a left inverse.
source_class: algebraic core of K-CERT (handoff Â§45, [S18]) with E = P (projection form, no transpose)
parameters_and_quantifiers: âˆ Ring, âˆ M P H with the three hidden-inverse hypotheses, âˆ sources b, âˆ x y
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/PramanaPatra_BlockEliminationByAnIdempotentIsALosslessCertificateTheReducedAndFullEquationsAreEquivalentForEverySourceAndTheForcingMapTransportsTheOperator.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities
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

## PunarAgamana â” ordered return recurrence and projected Leibniz defect

```text
claim_id: NV-RENEWAL
statement: For an idempotent P with blocks A = PLP, B = PLQ, C = QLP, D = QLQ and K n = P Lâ¿ P: Q Lâ¿ P = W n where W 0 = 0, W (n+1) = CÂK n + DÂW n; K (n+1) = AÂK n + BÂW n (unrolling W gives Îâ¼ B DÊ² C K_{nâˆ’1âˆ’j}); K 2 = AÂA + BÂC; and for a derivation ğ“ and an idempotent ğ’ on a commutative ring, ğ’ğ“(hk) âˆ’ (ğ’ğ“h)k âˆ’ h(ğ’ğ“k) = (ğ’ğ“h)(ğ’k) + (ğ’h)(ğ’ğ“k).
source_class: algebraic core of N-RENEWAL, K-EXCURSION, N-OBSRETRACT (handoff Â§38, [S17],[S25])
parameters_and_quantifiers: âˆ Ring, âˆ L, âˆ idempotent P, âˆ n; Leibniz defect: âˆ CommRing, derivation ğ“, additive idempotent ğ’ (ğ’ need not be a ring hom), âˆ h k
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/PunarAgamana_TheProjectedPowersOfAnOperatorObeyAnOrderedReturnRecurrenceWhoseKernelIsExcursionThroughTheHiddenBlockAndTheProjectedDerivationFailsLeibnizByExactlyTheCrossSectorTerms.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities
existing_terms_reused: Cubical.Algebra.Ring; the insert lemma EÂ(XÂY)ÂP = (EÂXÂP)(PÂYÂP) + (EÂXÂQ)(QÂYÂP) plays the role of formal/cubical/theorems/automata/ExcursionReturn
new_derivation_or_artifact: insert, hidden-is-horner, return-recurrence, first-return, projected-leibniz-defect
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: first-return with the BÂC term deleted is rejected
correction_of: C33 (the orthogonal generator is not a derivation): the defect is now a checked identity
endpoint_dependency_discharged: the formal-series recurrence of N-RENEWAL; the Banach-space realization is not
remaining_assumptions: the PDE observable algebra is a commutative ring with ğ“ a derivation; ğ’ is an additive idempotent (Â§38 retraction)
```

## AbelaRupa â” Abel normal form of the damped shift and the residual tower

```text
claim_id: NV-ABEL-NF
statement: In a commutative ring with a resolvent cÂ(1 âˆ’ ÏT) = 1 and B = (1âˆ’Ï)T c: 1 âˆ’ B = c(1 âˆ’ T), (1âˆ’B)µ = cµ(1âˆ’T)µ, and for the normalized source Y k = cÌµÂS k the m-th forward difference is Î”µ Y k = cÌ^{k+m}ÂAµ k where A^{m+1} = res(Aµ), res f k = f(k+1) âˆ’ cÂf k.
source_class: algebraic core of R-ABEL, R-DYADIC (handoff Â§62, [S19],[S20])
parameters_and_quantifiers: âˆ CommRing, âˆ Ï T c with the resolvent identity, âˆ m k, âˆ sequences S
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/primes/AbelaRupa_TheResolventOfTheDampedShiftNormalizesTheShiftDefectSoItsPowersInvertEveryOrderAndTheDyadicDifferencesOfTheNormalizedSourceAreTheResidualTower.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities
existing_terms_reused: Cubical.Algebra.CommRing; +-suc from Cubical.Data.Nat
new_derivation_or_artifact: normal-form, normal-form-power, difference-is-rescaled-residual
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: normal-form with the sign of T flipped is rejected
correction_of: C51 (the all-order inverse must be built from the c0 shift identity, not the old high-order assertion): the normal form is the shift identity
endpoint_dependency_discharged: none; the strong c0 convergence and the (âˆ2âˆ’1)^{âˆ’m} bound are analytic
remaining_assumptions: c0 topology, boundedness of A_m (O-RDYADIC)
```

## Vartana â” first-return radial operator, inward powers, indicial factorization

```text
claim_id: NV-RADIAL-RETURN
statement: For a derivation d on a commutative ring with a radius r, d r = 1: rÂğ’(g,h,p,f) = boundary-forms + d(antiderivative) with ğ’ = 15gh + 6r gâ²h + 3r g hâ² + pf âˆ’ r pâ² f âˆ’ 4 r p fâ²; (rÂ²dÂ² + 6r d) rµ = k(k+5) rµ for every k; and k(kâˆ’1) + 6k âˆ’ (lâˆ’2)(l+3) = (k âˆ’ (lâˆ’2))(k + (l+3)), so the inward root k = lâˆ’2 and the outward root k = âˆ’(l+3), and l = 2 is the only degree whose inward exponent is 0.
source_class: algebraic core of N-RETURN24, N-INVERSE2, N-TOROIDAL (handoff Â§19â“25, [S12],[S15])
parameters_and_quantifiers: âˆ CommRing, âˆ derivation d with d r = 1, âˆ g h p f, âˆ k : â•, âˆ k l in the ring
repository_commit: pin 168ea8e2; module at d706a72b (merged as 38013358 on claude/interactive-daemon-math-vt8e9e)
working_tree_changes: formal/cubical/theorems/physics/Vartana_TheFirstReturnRadialOperatorIsThreeBoundaryFormsPlusAnExactDerivativeAndTheIndicialPolynomialOfEveryToroidalDegreeFactorsSoDegreeTwoIsTheOnlyMarginalChannel.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) and NatSolver (solveâ•!) for closed ring/â• identities; NatSolver for the â• coefficient k(k+5)
existing_terms_reused: the derivation lemmas d-zero, d-neg, d-scale, d-pow follow formal/cubical/theorems/physics/PurnaAvakalana
new_derivation_or_artifact: return-integrates-by-parts, radial-power, indicial-factors, inward-root-coefficient
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS: indicial-factors with (l+2) in place of (l+3) is rejected
correction_of: none
endpoint_dependency_discharged: none; the boundary forms are the terms the analytic argument integrates over the shell
remaining_assumptions: decay/regularity making the boundary forms vanish; the actual toroidal projection Pâ and Biotâ“Savart source are interfaces, not formalized
```

## DvipadaGuna â” iterated Leibniz law for the observable lift

```text
claim_id: NV-LIFT-BINOMIAL
statement: For a derivation ğ“ on a commutative ring, ğ“â¿(hÂk) â‰¡ Î_{a+b=n} C(a+b,a)Âğ“µhÂğ“µk for every n (the boxed identity of handoff Â§37); unfolded at n = 2: ğ“Â²(hk) = hğ“Â²k + 2ğ“hğ“k + ğ“Â²h k. The sum over a+b = n is a recursion on n with the binomial as a function of the pair, so no truncated subtraction enters; the Pascal step is proved as an exact re-indexing lemma for every row function obeying Pascal's rule and the two edge rules.
source_class: algebraic core of N-LIFT (FORMAL-SERIES, [S17]); makes the coefficientwise product preservation of exp(ğ“) exact
parameters_and_quantifiers: âˆ CommRing, âˆ additive Leibniz ğ“, âˆ n : â•, âˆ h k
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
remaining_assumptions: that the PDE observable algebra is a commutative ring and ğ“h = Dh[F] is a derivation on it; no convergence of the time-Taylor series is claimed
```

## YogaPatra â” certificate composition, derived transport law, nilpotent causal inverse

```text
claim_id: NV-CERT-COMPOSE
statement: In any ring with an additive anti-multiplicative t fixing 1 (a transpose): (à§) the five checker identities EÂR = 1, EÂZ = 0, MÂR = tEÂS, MÂZ + tEÂT = 1, RÂE + ZÂM = 1 imply the transport law TÂM = SÂE; (à¨) for a certificate câ of M and a certificate câ of its reduced operator Sâ, the composite E = EâEâ, S = Sâ, T = TâTâ, R = RâRâ, Z = Zâ + RâZâTâ satisfies all five identities for M, so `compose : Cert M`; (à©) in a commutative ring, KÂ³ = 0 gives (1 âˆ’ zK)(1 + zK + zÂ²KÂ²) = 1 for every z.
source_class: algebraic core of K-CERT (EXACT-CONTROL, handoff Â§45, [S18]); (à©) is the "large norm is not a causal-inverse failure" control, checked in the form 1 + zK + zÂ²KÂ² (the chapter prints the last term as zÂ²K)
parameters_and_quantifiers: âˆ Ring, âˆ t with t-add, t-mul, t-one, âˆ M, âˆ certificates câ câ (the mismatched-intermediate rejection is the type: câ must be a Cert of Cert.S câ); (à©) âˆ CommRing, âˆ z K
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/YogaPatra_TheCompositeOfTwoEliminationCertificatesIsACertificateTheTransportLawFollowsFromTheFiveCheckedIdentitiesAndANilpotentCausalKernelHasAPolynomialInverseWhateverItsNorm.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) for closed commutative identities
existing_terms_reused: RingTheory (0LeftAnnihilates, 0RightAnnihilates); the projection-form certificate is PramanaPatra (NV-CERT-PROJ)
new_derivation_or_artifact: record Cert, transport-law, compose-eliminates, compose-source-blind, compose-reduces, compose-transforms, compose-reconstructs, compose, nilpotent-causal-inverse
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-2: dropping the Tâ factor from the composite Z is rejected
correction_of: C01: "exact composition installs the full session" is now a checked term, not a kernel.py convention
endpoint_dependency_discharged: K-CERT composition rule; what remains for K-CERT is wiring this Cert type to the Machine install/retire path
remaining_assumptions: the transpose is a hypothesis (t-add, t-mul, t-one); over matrices it is the ordinary transpose
```

## DviSthana â” two-sector reflection block, Schur pivot, poles, damped cosh

```text
claim_id: NV-SCHUR-BLOCK
statement: In the commutative block algebra ÎÂI + Î²ÂX with XÂ² = I, for the resolvent block (d, Ï), d = Î» + iÎ³: (d,Ï)âŠ—(d,âˆ’Ï) = (dÂ² âˆ’ ÏÂ², 0); any inverse (Ï,Ï) has Ï(dÂ² âˆ’ ÏÂ²) = d and Ï(dÂ² âˆ’ ÏÂ²) = âˆ’Ï, so RâŠâŠ = d/(dÂ² âˆ’ ÏÂ²); with ÎÂd = ÏÂ², (d âˆ’ Î)Âd = dÂ² âˆ’ ÏÂ² (the self-energy is subtracted); at d = 0 the block (0,Ï) has inverse (0, 1/Ï) = X/Ï, so the pivot pole is removable; (d âˆ’ Ï) + (d + Ï) = 2d, so the genuine poles d = ÂÏ carry residue Â½ each; with âˆe = âˆ’g e, âˆc = Ï s, âˆs = Ï c the block K = (eÂc, âˆ’eÂs) satisfies âˆK = GâŠ—K for G = (âˆ’g, âˆ’Ï), its retained channel is eÂc = e^{âˆ’iÎ³t}cosh Ït, and it starts at 1.
source_class: exact finite instance of R-SCHUR (handoff Â§64, [S17â“S18]); the same block normal form as the NS return (PunarAgamana)
parameters_and_quantifiers: âˆ CommRing, âˆ d Ï (âˆ Î with Îd = ÏÂ²; âˆ inverse (Ï,Ï); âˆ s with Ïs = 1); evolution: âˆ derivation âˆ and e c s g Ï with the three ODE hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/DviSthana_TheTwoSectorReflectionBlockResolvesExactlyThePivotPoleOfTheSelfEnergyIsRemovableTheGenuinePolesSitAtPlusMinusSigmaWithResidueOneHalfAndTheRetainedChannelIsADampedCosh.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.CommRingSolver (solve!) for closed commutative identities
existing_terms_reused: Cubical.Data.Sigma pairs; derivation lemmas as in Vartana
new_derivation_or_artifact: _âŠ—_, X-squares-to-ğŸ™, resolvent-factor, resolved-plus-plus, resolved-plus-minus, schur-denominator, pivot-inverse, residues-are-halves, evolves, retained-channel, starts-at-one
proof_status: formal theorem checking (--safe, no postulates); the block algebra is the exact 2—2 case, not an operator-theoretic statement
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-2: residues-are-halves with 2d replaced by d is rejected
correction_of: C50/C52 (the pivot pole is not a pole of the full problem; positive self-energy is subtracted, not a dissipation proof): both are checked identities here
endpoint_dependency_discharged: none; Î(1) = 0 â” RH across all orbits is analytic
remaining_assumptions: existence of cosh/sinh/exponential elements with the stated derivatives (a differential ring containing them)
```

## SmrtiMula â” emitted forcings are exact, weighted forcing is memory plus exact, log-radius factorization, symbol

```text
claim_id: NV-MEMORY-FINITE
statement: Over a commutative ring with a derivation âˆ and âˆr = 1: râ´gÂ(5gf + 2rgâ²f + rgfâ²) â‰¡ âˆ(râµgÂ²f) (Î²â exact); with f = rÂ²hÏ, g = hÂ³: 3rgfâ² âˆ’ 6gf âˆ’ rgâ²f â‰¡ 3rÂ³hâ´âˆÏ (Î²â exact); with f = âˆ’(rÂ²gâ³ + 6rgâ²) the toroidal inverse: 2r(5gf + 2rgâ²f + rgfâ²) â‰¡ 2(9rgÂ² âˆ’ rÂ³gâ²Â²) + âˆ(âˆ’2râ´ggâ³ âˆ’ 18rÂ³ggâ² âˆ’ râ´gâ²Â² âˆ’ 9rÂ²gÂ²), i.e. âˆrÎ²â = (6/7)ğ“˜[f]; in log radius (Dr = r), (4 âˆ’ 3D âˆ’ DÂ²)(rg) â‰¡ rÂ(âˆ’(DÂ²g + 5Dg)) and 9bÂ² âˆ’ (rDg)Â² â‰¡ 8bÂ² âˆ’ (Db)Â² + D(bÂ²) for b = rg; (4+Î¾Â²)Â² + 9Î¾Â² â‰¡ (1+Î¾Â²)(16+Î¾Â²); the scaled kernel matrix [[8,11],[11,8]] has eigenvalues 19 and âˆ’3.
source_class: algebraic cores of N-LEAK4, N-MEMORYK, N-SIGNEDK (handoff Â§21, Â§24; [S12],[S16])
parameters_and_quantifiers: âˆ CommRing, âˆ derivation âˆ, âˆ r with âˆr = 1 (resp. Dr = r), âˆ g f h Ï Î¾
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/SmrtiMula_TheEmittedForcingsAreExactDerivativesTheWeightedQuadrupoleForcingIsTheMemoryQuadraticPlusAnExactDerivativeTheLogRadiusSourceIsAFactoredOperatorAndItsSymbolIsTheProductOfTwoShiftedSquares.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas whose numerals are written as explicit sums of 1r (Î n unfolds to them definitionally)
existing_terms_reused: derivation lemmas as in Vartana; the two-radius kernel positivity itself is SmrtiBija
new_derivation_or_artifact: Î²â-is-exact, Î²â-is-exact, weighted-forcing-is-memory-plus-exact (with toroidal-f and memory-bracket), factored-operator, memory-integrand, symbol-modulus, kernel-eigenvalue-19, kernel-eigenvalue-minus-3
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (28 s)
negative_controls: NV-CONTROLS-3: symbol-modulus with 16 replaced by 15 is rejected
correction_of: none; makes exact the "bracketed functions vanish at both support ends" step behind the generic sign change of Î²â, Î²â and ğ“˜[Î²â,Îµ] < 0
endpoint_dependency_discharged: none; the integrals, the boundary vanishing and the Fourier/Plancherel step are analytic
remaining_assumptions: f, g are the actual radial profiles with compact support so the brackets vanish at the ends; h = g^{1/3} exists (g > 0)
```

## PidaMatra â” noncommutative spherical pressure bracket is r times an exact derivative

```text
claim_id: NV-PRESSURE-MATRIX
statement: Over any ring (noncommutative) with a derivation âˆ and a central radius r, âˆr = 1, for an arbitrary profile G with V = rGâ², W = rÂ²Gâ³: rÂâˆ(15GÂ² + 3r(GGâ² + Gâ²G) âˆ’ rÂ²Gâ²Â²) â‰¡ 18(GV + VG) + 3(GW + WG) + 4VÂ² âˆ’ (VW + WV). This is the doubled form of "the radial integrand of (12/35)[18Gâˆ˜V + 3Gâˆ˜W + 2VÂ² âˆ’ Vâˆ˜W]â is the derivative of (15/2)GÂ² + 3rGâˆ˜Gâ² âˆ’ (rÂ²/2)Gâ²Â²", valid when G, Gâ², Gâ³ do not commute.
source_class: algebraic core of N-PRESSURE (handoff Â§20, [S12]); the Lane III "full matrix identity, not only the diagonal A case"
parameters_and_quantifiers: âˆ Ring, âˆ derivation âˆ, âˆ central r with âˆr = 1, âˆ G
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/PidaMatra_TheSphericalPressureBracketOfARadialMatrixProfileIsRTimesTheDerivativeOfAQuadraticFormEvenWhenTheProfileAndItsDerivativesDoNotCommute.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; Cubical.Tactics.MonoidSolver (solveCommMonoid) on the additive commutative monoid of the ring, applied through an abstract-monoid lemma so the goal is not normalized away
existing_terms_reused: AbGroupâ’CommMonoid, Ringâ’AbGroup, RingTheory (-Dist, -DistRÂ, 0RightAnnihilates)
new_derivation_or_artifact: AdditiveShape.rearrange (the seven-monomial multiset identity), L1â“L3, R1â“R4, pressure-bracket-is-exact
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-3: replacing Gâ²ÂGâ² by Gâ²ÂG in Î¦â is rejected
correction_of: none
endpoint_dependency_discharged: none; the spherical average producing the bracket and the trace-free projection are analytic/finite-geometric steps not formalized here
remaining_assumptions: r central (scalar radius times matrix profile); the spherical-moment identity that yields the bracket from tr((âˆuâ)Â²)
```

## Sopana â” damping-moment Weyl ladder and the lossless oscillator

```text
claim_id: NV-LADDER
statement: (à§) For any additive â’ and sequence G with â’Gâ = ZZ and â’G_{n+1} = (n+1)ÂG_n: â’â¿âºÂG_n â‰¡ n!ÂZZ for every n. (à¨) For a derivation âˆ with âˆs = 1 and an additive D commuting with âˆ, â’Ï = 2sÏ âˆ’ DÏ satisfies â’(âˆÏ) âˆ’ âˆ(â’Ï) â‰¡ âˆ’2Ï, i.e. [â’, âˆ’Â½âˆ] = I; and with âˆE = âˆ’2tE, âˆt = 0: âˆ(tâ¿E) â‰¡ âˆ’2tâ¿âºÂE (R raises). (à©) With pâ² = âˆ’Î³q + fâ, qâ² = Î³p + fâ: âˆ(pÂ² + qÂ²) â‰¡ 2(pfâ + qfâ), the stored energy changes by the supplied work Re(fÌa).
source_class: algebraic cores of R-LADDER (FORMAL-SERIES), R-INVERSE, and the Â§61 lossless-oscillator realization under R-PASSIVE (handoff Â§57, Â§61; [S09],[S10])
parameters_and_quantifiers: âˆ CommRing; (à§) âˆ additive â’, âˆ G ZZ with the two rung hypotheses, âˆ n; (à¨) âˆ derivation âˆ, âˆ s with âˆs = 1, âˆ additive D with Dâˆ = âˆD, âˆ Ï; âˆ t E n; (à©) âˆ Î³ p q fâ fâ with the two ODE hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Sopana_TheDampingMomentLadderIsAWeylPairSoTheLoweringOperatorAppliedNPlusOneTimesToTheNthMomentIsNFactorialTimesTheSourceSquareAndTheLosslessOscillatorStoresExactlyTheSuppliedWork.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: scale-+/scale-Â as in Vartana; derivation lemmas as before
new_derivation_or_artifact: Ladder.ladder (with â’^ and fact), weyl, raising, stored-work
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-4: weyl with âˆ’3Ï in place of âˆ’2Ï is rejected
correction_of: none; the Â§57 regularity guard is respected by taking â’G_n = nG_{nâˆ’1} as a hypothesis on the declared domain rather than deriving it by integration by parts
endpoint_dependency_discharged: the formal-series content of R-LADDER
remaining_assumptions: the integration-by-parts identities â’Gâ = ZâŠ—ZÌ, â’G_n = nG_{nâˆ’1} on the declared domain (distributional/resolvent interpretation or a smoother faithful packet)
```

## ArdhaTala â” Hardy/Bergman overlap geometry, reflection readings, Cauchy and Vandermonde determinants

```text
claim_id: NV-HALFPLANE
statement: (à§) |2s âˆ’ z âˆ’ wÌ|Â² âˆ’ |z âˆ’ w|Â² â‰¡ 4(s âˆ’ Re z)(s âˆ’ Re w), so |âŸ¨h_z,h_wâŸ©|Â² = |âŸ¨F_z,F_wâŸ©| = 1 âˆ’ Ï_s(z,w)Â²; (à¨) on a reflection pair, sÂ² âˆ’ (sâˆ’Ï)(s+Ï) â‰¡ ÏÂ² (Gram det = ÏÂ²/sÂ²) and 2sÂ² âˆ’ 2(sâˆ’Ï)(s+Ï) â‰¡ 2ÏÂ² (â–F_z âˆ’ F_Îzâ–Â² = 2ÏÂ²/sÂ²), and the three curvature readings agree mode by mode; (à©) with cÂ² = 1 + shÂ²: (c âˆ’ sh)Â² + (c + sh)Â² âˆ’ 2 â‰¡ 4shÂ² (the holonomy defect e^{âˆ’2tÏ} + e^{2tÏ} âˆ’ 2 = 4sinhÂ²(tÏ)); (à) Cauchy determinants with rows cleared: 2—2 â‰¡ (xââˆ’xâ)(yââˆ’yâ), 3—3 â‰¡ Î _{i<j}(x_jâˆ’x_i)(y_jâˆ’y_i), which is det C_F = Î  ÏÂ² and the Schur new-atom residual Î _{wâˆˆF} Ï(z,w)Â²; (à) amplitude-weighted Vandermonde 2—2 and 3—3 determinants â‰¡ Î a_iÂÎ _{i<j}(z_j âˆ’ z_i).
source_class: algebraic cores of R-GEOMETRY (CONDITIONAL), R-CURVATURE, R-MINORS, and the Â§59 defect identity under R-HOLONOMY (handoff Â§58â“60; [S09])
parameters_and_quantifiers: âˆ CommRing; identities in the real/imaginary parts s x y u v, Ï, c sh, x_i y_j, a_i z_i
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/ArdhaTala_TheHardyAndBergmanOverlapsOfTwoZerosAreOneMinusTheSameHyperbolicRatioTheReflectionPairReadsSigmaSquaredOverSSquaredInEveryReadingAndTheFiniteGramDeterminantIsTheProductOfTheRatios.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none beyond the library
new_derivation_or_artifact: overlap-identity, reflection-gram-determinant, bergman-reflection-difference, curvature-readings, sinh-defect, cauchy-2, cauchy-3, vandermonde-2, vandermonde-3
proof_status: formal theorem checking (--safe, no postulates); finite-rank instances (2 and 3 atoms) of the determinant statements
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (12 s, the 3—3 Cauchy determinant included)
negative_controls: NV-CONTROLS-4: cauchy-3 with one factor reversed in sign is rejected
correction_of: none
endpoint_dependency_discharged: none; R-GEOMETRY stays conditional (the zeros are inputs)
remaining_assumptions: the inner products are the stated half-plane kernels; the infinite-product/closed-span statements of R-MINORS and the non-uniform Riesz/Bessel bounds are analytic
```

## DviMana â” two-metric conservation algebra

```text
claim_id: NV-TWOMETRIC
statement: In any ring with JÂ² = 1, a transfer T with two-sided inverse, and S with (SÂJ)ÂT = J: S = JÂTâ»ÂÂJ, so the metric C = SÂT is the reflected loop JÂTâ»ÂÂJÂT; the conservation law reverses, (TÂJ)ÂS = J; J-conjugation inverts C on both sides, (JÂCÂJ)ÂC = 1 = CÂ(JÂCÂJ); and for a normal transfer (SÂT = TÂS) the reciprocal cycle JÂTÂJÂTâ»Â is Câ»Â.
source_class: algebraic core of A-JUNITARY (handoff Â§12, [S14]); the loop orientations of Â§59 both stated with exact hypotheses
parameters_and_quantifiers: âˆ Ring (noncommutative), âˆ J T S Tâ»Â with the four hypotheses; à additionally SÂT = TÂS
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
remaining_assumptions: positivity of C = T*T, the logarithm A = Â½ log C and its anti-commutation with J are operator-theoretic; the generator identity G*J + JG = 0 along a path is not formalized
```

## DhruvaMula â” shifted-derivative ladder and the free viscous response

```text
claim_id: NV-SHIFTED-LADDER
statement: With âˆE = zE and âˆt = 1, â’ = âˆ âˆ’ z satisfies â’(EÂtâ°) = 0 and â’(EÂtµâºÂ) = (k+1)ÂEÂtµ, hence â’µâºÂ(EÂtµ) â‰¡ 0 (E times polynomials of degree < m lie in ker â’µ) and â’µ(EÂtµ) â‰¡ k!ÂE (the top coefficient survives); the first is the Sopana ladder instantiated. With âˆerf = Îºe, âˆe = âˆ’2qe, âˆq = 1, âˆÎº = 0: âˆ[3erf âˆ’ Îºe(3q + 2qÂ³)] â‰¡ 4Îºqâ´e, i.e. H5 is the antiderivative of (8/(3âˆÏ)) qâ´ e^{âˆ’qÂ²}.
source_class: algebraic cores of R-THETA / R-CARDINAL (the finite Î-derivative polynomial in the two-sided (Dâˆ’z)^m inverse difference, handoff Â§51) and N-H5 (handoff Â§22)
parameters_and_quantifiers: âˆ CommRing, âˆ derivation âˆ, âˆ z E t with the two hypotheses, âˆ k; âˆ Îº e erf q with the four hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/DhruvaMula_TheShiftedDerivativeLowersExponentialTimesPowersSoItsMthPowerKillsDegreeBelowMAndKeepsTheTopCoefficientAndTheFreeViscousResponseIsTheAntiderivativeOfAQuarticGaussian.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r; imports Sopana (Ladder, Î, scale, fact)
existing_terms_reused: Sopana.Ladder (ladder, â’^), Sopana.Î, Sopana.scale, Sopana.fact
new_derivation_or_artifact: pow, G, â’, tâˆpow, base, step, kills-below, keeps-top, H5â, h5-derivative
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-5: h5-derivative with qÂ³ in place of qâ´ is rejected
correction_of: none
endpoint_dependency_discharged: none; Î-interpolation, zero multiplicity and double-exponential tails are analytic
remaining_assumptions: e^{zt}, tµ, erf and e^{âˆ’qÂ²} live in a differential ring with the stated derivatives; the lifetime integral âˆH5 dt = rÂ²/(6Î½) is analytic
```

## Sikhara â” the exact peak ledger and the scale gains

```text
claim_id: NV-PEAK-LEDGER
statement: Over a commutative ring with derivations, for Ï‰ = mÎ¾ with Î¾âÂ² + Î¾âÂ² + Î¾âÂ² = 1 (doubled to avoid dividing by 2): 2ÂÎ¾Ââˆâˆ(mÎ¾) â‰¡ 2Â(âˆâˆm âˆ’ m|âˆÎ¾|Â²) and 2ÂÎ¾ÂD(mÎ¾) â‰¡ 2ÂDm; hence from the componentwise vorticity equation D(mÎ¾µ) = Sµ + Î½Î”(mÎ¾µ) and Î¾ÂS = Îm: 2ÂDm â‰¡ 2Â(Îm + Î½(Î”m âˆ’ m|âˆÎ¾|Â²)), and the ledger 2ÂÎm â‰¡ 2ÂDm + 2Â(Î½m|âˆÎ¾|Â² âˆ’ Î½Î”m). Scaling (d = 3): g_Câµ â‰¡ g_Ï‰Â²g_Eâ´ for g_Ï‰ = Aâ“, g_E = AÂ²Î»Â³, g_C = AÂ²Î»Â² (â“Î» = 1), and the energy chart â“ = Î¼â»Â², A = Î¼â»Â³, M = Î¼âµ has Aâ“M = 1 and AÂ²â“â»Â³ = 1.
source_class: algebraic cores of N-PEAK (handoff Â§27, [S13]) and N-SCALE (handoff Â§28)
parameters_and_quantifiers: âˆ CommRing, âˆ derivations âˆâ âˆâ âˆâ D, âˆ Î¾µ m Î½ Î Sµ with unit, vorticity and stretch hypotheses; âˆ A â“ Î» with â“Î» = 1; âˆ Î¼ Î¼â»Â with Î¼Î¼â»Â = 1
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/Sikhara_TheUnitDirectionAbsorbsNoLaplacianSoTheVorticityMagnitudeObeysItsOwnEquationAndThePeakLedgerIsItsRearrangementWhileTheThreeScaleGainsObeyOneMonomialRelation.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: DviDrsti (the d+2 determinant) is the companion scale module
new_derivation_or_artifact: OneDirection.direction-absorbs-nothing, OneDirection.direction-absorbs-no-rate, Magnitude.magnitude-equation, Magnitude.peak-ledger, gain-relation, energy-chart
proof_status: formal theorem checking (--safe, no postulates); all peak identities in doubled form
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (53 s)
negative_controls: NV-CONTROLS-5: direction-absorbs-nothing with +m|âˆÎ¾|Â² in place of âˆ’m|âˆÎ¾|Â² is rejected
correction_of: none; makes the Â§27 quantifier discipline exact: the identity holds pointwise wherever Ï‰ â‰  0, before any envelope/Dini argument
endpoint_dependency_discharged: none (O-NPEAK untouched)
remaining_assumptions: the maximizing point, envelope derivative Mâ² = Dm and âˆm = 0 at the maximum are analytic; division by 2 needs a ring where 2 is invertible
```

## Grahaka â” the fixed packet receiver and the two-packet Weil matrix

```text
claim_id: NV-RECEIVER
statement: With wÂwÌ = 1: (1 âˆ’ EwÌ)(1 âˆ’ Ew) â‰¡ 1 âˆ’ E(w + wÌ) + EÂ² and (z + 4)(4 âˆ’ z) â‰¡ 16 âˆ’ zÂ², so G(z) = H(z)H(âˆ’z) assembles to 256(1 âˆ’ 2eâ»Âcosh(z/4) + eâ»Â²)Â²/(16 âˆ’ zÂ²)Â²; the two-packet Weil matrix has det â‰¡ (Mâ âˆ’ Z)(Mâ + Z), trace â‰¡ 2Mâ, values 2(Mâ Â Z) on (1, Â1), and 2Âform(x,y) â‰¡ (Mâ + Z)(x+y)Â² + (Mâ âˆ’ Z)(xâˆ’y)Â², so PSD â” |Z| â‰ Mâ; the closing inequality is the tail identity up to sign.
source_class: algebraic core of R-PACKET, R-Z, R-TWOPACKET (handoff Â§46â“47, [S02])
parameters_and_quantifiers: âˆ CommRing, âˆ E w wÌ z Mâ Z x y L S J with w wÌ = 1
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Grahaka_TheFixedPacketIsTheProductOfItsTwoHalfPacketsSoItsSymbolIsARealSquareOverSixteenMinusZSquaredAndTheTwoPacketWeilMatrixIsPositiveExactlyWhenTheResponseIsBoundedByItsDiagonal.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none
new_derivation_or_artifact: packet-product, denominator, symbol-assembles, weil-determinant, weil-trace, weil-form, weil-form-on-sum, weil-form-on-difference, weil-form-diagonalizes, closing-argument
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-5: weil-determinant with (Mâ âˆ’ Z)Â² in place of (Mâ âˆ’ Z)(Mâ + Z) is rejected
correction_of: none
endpoint_dependency_discharged: none; R-TWOPACKET stays conditional
remaining_assumptions: the sector bound |arg G| < 37/50, Mâ > 0, absolute convergence of Z, the explicit-formula tail identity for t > 1/2 and the Laplace/residue argument for sufficiency are analytic
```

## Vistara â” the dilation generator is skew

```text
claim_id: NV-DILATION-SKEW
statement: Over a commutative ring with three derivations âˆµ and coordinates yµ with âˆµyµ = 1: (yÂâˆf)g + f(yÂâˆg) + 3fg â‰¡ Îµ âˆµ(yµ f g), an exact divergence; so yÂâˆ + 3/2 is skew in LÂ² and D_E = (2/5)(yÂâˆ + 3/2) = 3/5 + (2/5)yÂâˆ.
source_class: algebraic core of N-ADAPT (handoff Â§33, [S13])
parameters_and_quantifiers: âˆ CommRing, âˆ Leibniz âˆâ âˆâ âˆâ, âˆ yâ yâ yâ with the diagonal derivatives = 1, âˆ f g
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

## GolakaMatra â” spherical-moment contractions

```text
claim_id: NV-SPHERE-MOMENTS
statement: With the sphere moments taken as the tensors 15âŸ¨nµnâ¼âŸ© = 5Î´µâ¼ and 15âŸ¨nµnâ¼nâ–nâ—âŸ© = Î´µâ¼Î´â–â— + Î´µâ–Î´â¼â— + Î´µâ—Î´â¼â– over three indices: Îâ¼â– m4(i,j,k,l)Sâ¼â– â‰¡ Sµâ— + Sâ—µ + Î´µâ— tr S for every 3—3 matrix S, and the second-moment contractions Îâ¼ 5Î´µâ¼Sâ¼â— â‰¡ 5Sµâ—, Îâ– Sµâ–5Î´â–â— â‰¡ 5Sµâ—, Îâ¼â– Sâ¼â–5Î´â¼â– â‰¡ 5 tr S.
source_class: the spherical-moment algebra the Lane III deliverable asks for (handoff Â§18â“21, [S11],[S12])
parameters_and_quantifiers: âˆ CommRing, âˆ nine entries aâââ¦aââ, âˆ i l âˆˆ {1,2,3} (27 + 1 cases by solve!)
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/GolakaMatra_TheFourthMomentOfTheSphereContractsToTheSymmetrizedEntryPlusTraceTimesIdentityAndTheSecondMomentContractsToFiveTimesTheEntry.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r; the matrix is built from nine explicit entries so each entry is its own solver atom
existing_terms_reused: none
new_derivation_or_artifact: Ix, Î´, Îâ, mat, symm, tr, m4, fourth-contraction, left5, right5, trace5
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0 (42 s)
negative_controls: NV-CONTROLS-6: Sµâ— + Sµâ— in place of Sµâ— + Sâ—µ is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the moment tensors are the actual sphere averages (the two integrals âŸ¨nµnâ¼âŸ©, âŸ¨nµnâ¼nâ–nâ—âŸ©)
```

## GolakaTantra â” strain tomography and the pressure cross-effect

```text
claim_id: NV-TOMOGRAPHY
statement: For q_u(n) = âˆ’P_nSP_n âˆ’ Â½(nµSn)P_n: 30âŸ¨qâŸ© â‰¡ âˆ’11S âˆ’ Sµ âˆ’ 6(tr S)I for every S, hence 30âŸ¨qâŸ© = âˆ’12S for symmetric trace-free S, i.e. S_u = âˆ’(5/2)âŸ¨q_uâŸ©. For a symmetric biadditive H: H[uâ+uâŠ] â‰¡ H[uâ] + 2H(uâ,uâŠ) + H[uâŠ], and with 7H[uâ] = âˆ’2(SÂ²)â: 7H[u] + 2(SÂ²)â â‰¡ 7(2H(uâ,uâŠ) + H[uâŠ]).
source_class: algebraic cores of N-TOMOGRAPHY, N-SYMBOL (handoff Â§18) and N-PRESSURERES (Â§20)
parameters_and_quantifiers: âˆ CommRing, âˆ entries, âˆ i l; âˆ symmetric biadditive H, âˆ uâ uâŠ (SÂ²)â with the N-PRESSURE hypothesis
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
remaining_assumptions: the symbol q_u is the stated formula; recovering u from S by inverse Laplacian/divergence and the N-PRESSURE input 7H[uâ] = âˆ’2(SÂ²)â are analytic
```

## UpaGuna â” subset product rule and the linearized generator

```text
claim_id: NV-SUBSET-RULE
statement: âˆââˆâ(fg) â‰¡ âˆââˆâfÂg + âˆâfÂâˆâg + âˆâfÂâˆâg + fÂâˆââˆâg and âˆââˆââˆâ(fg) â‰¡ the eight-term subset sum, for any additive Leibniz âˆµ (no commutation needed); for additive L and symmetric biadditive B, F(Ï‰+v) â‰¡ F(Ï‰) + (Lv + 2B(Ï‰,v)) + B(v,v).
source_class: algebraic core of A-JETS (handoff Â§8, [S03]); companion of DvipadaGuna (single-derivation all orders) and PunarAgamana (projected failure)
parameters_and_quantifiers: âˆ CommRing, âˆ âˆâ âˆâ âˆâ additive Leibniz, âˆ f g; âˆ L B Ï‰ v
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/UpaGuna_TheMixedDerivativeOfAProductIsTheSumOverSubsetsOfWhichFactorEachDerivationHitsAndTheLinearizedGeneratorOfAQuadraticFlowIsItsLinearPartPlusTwiceThePolarization.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on shape lemmas with numerals as explicit sums of 1r
existing_terms_reused: none
new_derivation_or_artifact: subset-rule-2, subset-rule-3, F, DF, linearized-generator
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-6: B(Ï‰,v) in place of B(v,v) as the remainder is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the general |S| subset rule is stated for |S| â‰ 3; the actual B = Â½curl(u_a—b + u_b—a) is symmetric biadditive (its definition)
```

## SamaCakra â” Beltrami eigenspace cancellation

```text
claim_id: NV-BELTRAMI
statement: With an antisymmetric biadditive —, additive P, and curl u = Î»u, curl v = Î»v: A_u u = K_u u = N(u) (definitionally), A_u v = P(Î»(u—v)), K_u v = P(âˆ’Î»(u—v)), and A_u v + K_u v = P 0: each frozen factor leaks, the actual derivative DN(u)v vanishes. The positive-helicity cross product (0,1,i)—(âˆ’1,0,i) = (i,âˆ’i,1) is transverse to k = (1,1,0).
source_class: algebraic core of N-BELTRAMI (handoff Â§9, [S02])
parameters_and_quantifiers: âˆ CommRing, âˆ — P curl Î» u v with the stated hypotheses; âˆ i
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/SamaCakra_OnOneCurlEigenspaceEachFrozenFactorLeaksLambdaTimesTheCrossProductWithOppositeSignsSoTheActualDerivativeVanishesWhileTheHelicityCrossProductIsTransverseAndNonzero.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: none
new_derivation_or_artifact: A-frozen, K-frozen, N, A-reproduces, K-reproduces, A-leaks, K-leaks, derivative-vanishes, cross, dot, helicity-cross, transverse
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: (i, i, 1) in place of (i, âˆ’i, 1) is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the Leray projection P is additive and the actual — is the vector cross product; the nonzero negative-helicity projection value is a numeric evaluation not formalized
```

## Pratirodha â” impedance, Stieltjes, Cayley, dyadic Goldbach normalization

```text
claim_id: NV-IMPEDANCE
statement: (x, yâˆ’Î³)Âconj = (xÂ² + (yâˆ’Î³)Â², 0) so Re 1/(wâˆ’iÎ³) = x/(xÂ²+(yâˆ’Î³)Â²); (w,Î³)(w,âˆ’Î³) = (wÂ²+Î³Â², 0) and (w+Î³)+(wâˆ’Î³) = 2w (the ÂÎ³ pair is a Stieltjes term 2pw/(q+Î»)); |Î+Y|Â² âˆ’ |Îâˆ’Y|Â² = 4Re(¾Y) (Cayley contractive â” right half-plane); (2t)Â²Gâ âˆ’ tÂ²Gâ = 4tÂ²Gâ âˆ’ tÂ²Gâ and tÂ²AÂ² = (tA)Â² (the dyadic normalization ğ’(2t) âˆ’ ğ’(t) = 4tÂ²(G_R(2t) âˆ’ Â¼G_R(t)), ğ’ = (tA)Â²).
source_class: algebraic cores of R-IMPEDANCE, R-OUTPUT (handoff Â§61) and R-GSQUARE / R-GCRITERION (Â§63)
parameters_and_quantifiers: âˆ CommRing, âˆ x y Î³ w Î Y t Gâ Gâ A
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/Pratirodha_OneSpectralModeOfTheImpedanceHasRealPartXOverXSquaredPlusTheOffsetSquaredThePairedModesAreAStieltjesTermTheCayleyCoefficientIsContractiveExactlyOnTheRightHalfPlaneAndTheDyadicGoldbachResidualIsTheNormalizedDifference.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: complex pairs as in DviSthana
new_derivation_or_artifact: _âŠ—_, conj, âˆ_âˆÂ², mode-denominator, mode-real-part, paired-modes, stieltjes-numerator, cayley, dyadic-normalization, normalized-square
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: 2Re(¾Y) in place of 4Re(¾Y) is rejected
correction_of: C45/C49 companion: the identities hold per mode; the prefix E_T and the convergent trivial-zero tail are the analytic corrections
endpoint_dependency_discharged: none
remaining_assumptions: positivity p_Î³ > 0 under RH, convergence of the mode sums, PNT for tA â’ 1, the Mellin argument
```

## Trikona â” the triangular exact NS family

```text
claim_id: NV-TRIANGULAR
statement: For u = (0, a, v) with âˆâa = âˆâa = âˆâv = 0 over a commutative ring with derivations âˆâ âˆâ âˆâ D (âˆââˆâ = âˆââˆâ): (uÂâˆ)u â‰¡ (0, 0, aâˆâv); div((uÂâˆ)u) â‰¡ 0 (so p = 0 is consistent); div u â‰¡ 0; the NS residuals with p = 0 are NSâ â‰¡ 0, NSâ â‰¡ Da âˆ’ Î½Î”a, NSâ â‰¡ Dv + aâˆâv âˆ’ Î½Î”v; and for the strictly lower-triangular gradient [[0,0,0],[p,0,0],[q,r,0]]: tr MÂ² = 0, MÂ² has the single entry rp, tr MÂ³ = 0, MÂ³ = 0 (Q_inv = R_inv = 0).
source_class: algebraic core of N-FUTURE (handoff Â§14, [S02]): the exact family behind the finite-jet separator
parameters_and_quantifiers: âˆ CommRing, âˆ derivations, âˆ a v Î½ with the ansatz hypotheses; âˆ p q r
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/physics/Trikona_TheTriangularFamilyHasConvectiveTermZeroZeroAdvectedVIsDivergenceFreeWithZeroPressureAndItsStrictlyLowerTriangularGradientKillsBothVelocityGradientInvariants.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9 (pinned at $HOME/.agda-pin/libraries), flags --safe --no-import-sorts; CommRingSolver on closed identities
existing_terms_reused: leib-zero (âˆ0 = 0 from Leibniz alone)
new_derivation_or_artifact: advect, convective, convective-collapses, div, convective-is-divergence-free, u-is-divergence-free, Î”, NSâ NSâ NSâ, first-component-is-trivial, second-component-is-heat, third-component-is-advected-heat, Q-invariant-vanishes, square-is-one-corner, R-invariant-vanishes, cube-vanishes
proof_status: formal theorem checking (--safe, no postulates)
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-7: (0, 0, vâˆâa) in place of (0, 0, aâˆâv) is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the mode recurrence ‹_k, the jet-depth statement câ^{(j)}(0) = 0 for j < m, the path-counting bound I_m, and the coarse/fine passivity are not formalized
```

## KatalanaSima â” the Catalan majorant

```text
claim_id: NV-CATALAN
statement: For â•-valued x with xâ â‰ g and x_{n+1} â‰ bÂÎ_{a+c=n} x_a x_c: x_n â‰ bâ¿ÂCat_nÂgâ¿âºÂ for every n, where Catâ = 1, Cat_{n+1} = Î_{a+c=n} Cat_a Cat_c (defined through a memo table so the recurrence is structural; Catâ = 5 and Catâ = 42 by computation, and cat-suc is the proved recurrence).
source_class: exact finite control of N-CATALAN (handoff Â§40, [S18]); the majorant of the causal tree expansion q = Î qâ™, qâ™âŠâ = Î_{a+c=n} C(qâ,q_c) of N-HISTORY
parameters_and_quantifiers: âˆ x : â• â’ â•, âˆ b g, the two hypotheses, âˆ n; proved by strong induction over the pair sum with D-mono, D-ext, D-scale
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/KatalanaSima_AQuadraticallyMajorizedSequenceIsBoundedByCatalanNumbersTimesPowersSoTheTreeExpansionOfTheHiddenHistoryHasAnExplicitMajorant.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; Cubical.Data.Nat.Order (â‰-+-â‰, â‰-Âk, â‰-trans, â‰0â’â‰¡0), Cubical.Relation.Nullary (decRec, isPropDec), NatSolver (solveâ•!)
existing_terms_reused: the pair-sum D of DvipadaGuna, now over â•
new_derivation_or_artifact: D, D-ext, pow, pow-+, D-mono, D-scale, â‰-splitâ², â‰-Â-â‰, catTab, cat, stable, cat-zero, cat-suc, Majorant.bound, product-of-bounds, below, catalan-majorant
proof_status: formal theorem checking (--safe, no postulates); an inequality theorem over â•, not only an identity
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-8: gâ¿ in place of gâ¿âºÂ in the bound is rejected
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: the norm bounds â–C(x,y)â– â‰ bâ–xâ–â–yâ– and â–g_pâ– â‰ g that feed x; the radius 4bg < 1 and the explicit truncation remainder are analytic (Cat_n ~ 4â¿)
```

## Sima â” the open frontier is one proposition

```text
claim_id: NV-FRONTIER
statement: With the six route unknowns (O-RBOUND, O-RONESIDE, O-RLOWER, O-RLIFT, O-RDYADIC, O-RGOLDBACH) and RH as propositions, and the received conditional theorems (R-TWOPACKET both ways, R-LANDAU, R-ESCAPE, R-WEILSPACE positivity, R-IMAGE both ways, R-ABEL, R-DYADIC, R-GCRITERION both ways, and "bounded â’ one-sided") as hypotheses: each unknown â‰ RH, hence â‰¡ RH by univalence, and all six routes name one point of hProp; resolving any resolves all (Any â’ All) and refuting any refutes all; every reading P of one unknown transports to every other by subst along the ua path, and the transported inhabitant is the composed proof. For NS: with the ledger, BKM, and the definition of a maximal solution as hypotheses, O-NPEAK â‰ END-NS.
source_class: the composition of handoff Â§68 / CLAIM_GRAPH.alternative_routes; no analytic claim is proved, the SHAPE of the frontier is
parameters_and_quantifiers: âˆ â“, âˆ propositions RH Bounded OneSided Lower Lift Dyadic Goldbach (resp. Global Maximal PeakWork VortBounded Continuation) with their isProp proofs, âˆ the twelve (resp. six) conditional hypotheses
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/unplaced/Sima_TheOpenFrontierIsOnePropositionUpToTheReceivedConditionalTheoremsSoEveryRouteReadsTheSameUnknownResolvingAnyResolvesAllAndEveryReadingTransportsAlongUnivalence.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; propBiimplâ’Equiv, ua, Îâ‰¡Prop, subst
existing_terms_reused: the finite cores under each hypothesis: Grahaka, AbelaRupa, ResidueDvaya, ArdhaTala, DviSthana, DviMana, ReflectionFiber, RiktaFiber, Pratirodha, Sikhara (cited, not imported)
new_derivation_or_artifact: RH-Frontier: Boundedâ‰RH â¦ Goldbachâ‰RH, the six ua paths, Frontier and route-Aâ¦F in hProp, routes-name-one-unknown, All, Any, from-RH, to-RH, resolving-any-resolves-all, refuting-any-refutes-all, transport-reading, transport-any-reading, transport-computes; NS-Frontier: PeakWorkâ‰Global, PeakWorkâ‰¡Global, NS-Frontier-is-one
proof_status: formal theorem checking (--safe, no postulates) of a conditional structure; the endpoints stay CONDITIONAL, their premises uninstantiated
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-9: using R-DYADIC in place of R-ABEL in the dyadic route is rejected; and the kernel-gate false control below
correction_of: none; this is the Â§68 sentence "not independent conjectures to prove one after another" made a theorem
endpoint_dependency_discharged: none; what is discharged is the multiplicity: the unsupplied items are one proposition
remaining_assumptions: every hypothesis named by a graph node is the received analytic theorem; "bounded â’ one-sided", "vacuous", "no-maximal", "global-of/maximal-of" are the definitional glue of the fixed formulations
```

## Lane I bis â” the frontier through the native gate

```text
claim_id: NV-GATE-FRONTIER
statement: A Candidate importing Sima and deriving Dyadic â’ Goldbach and Dyadic â‰¡ Goldbach from the route hypotheses is accepted by the Machine kernel gate (marga: kernel, controls watched first); vislesana returns the kernel's own normal form of the corollary, Î» â¦ d â’ hââ (hâ (hâ‰ d)) â” the composed proof is literally Goldbach-necessity âˆ˜ TwoPacket-sufficiency âˆ˜ Abel. The same Candidate with the Abel hypothesis removed is rejected with "Dyadic !=< Bounded when checking that hââ has type Dyadic â’ Bounded": the gate names exactly the missing analytic input.
source_class: metacircular application (handoff Â§5, Â§69): the repository's knowledge about the frontier checked and normalized by its own kernel
parameters_and_quantifiers: two fixed request streams
repository_commit: pin 168ea8e2; evidence at (this commit; see git log for the hash)
working_tree_changes: research/handoff_20260908/validation/native/frontier/{positive,false}.{requests.jsonl,wire-transcript.jsonl,stdout.log,stderr.log}, Candidate.{positive,false}.agda.txt
imports_and_toolchain: sh interactive/run-machine.sh --wire with YANTRA_OUT, DOSA_LEKHA, YANTRA_LEKHA, MATH_CERTCACHE=0, AGDA_DIR=$HOME/.agda-pin
existing_terms_reused: sadhana.patra, sadhana.vislesana; Sima.RH-Frontier
new_derivation_or_artifact: Candidate.positive (corollary, as-path); the normal forms in positive.wire-transcript.jsonl
proof_status: finite executable control plus a formal theorem checked by the kernel gate
executed_commands: sh interactive/run-machine.sh --wire < frontier/positive.requests.jsonl ; â¦ < frontier/false.requests.jsonl
exit_status_and_log: exit 0 / exit 0; positive: samorderna on all four requests; false: dosalekha with the UnequalTerms line
negative_controls: the false Candidate (Abel hypothesis removed) is rejected at the exact slot
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: none beyond the pinned toolchain
```

## MetacircularReplay â” the codex native replay integration, merged and repaired

```text
claim_id: NV-REPLAY
statement: The codex/agda-native-replay-20260908 branch (two files) is merged: MetacircularReplay checks execute/learn/retire/replay of kernel sessions against the actual kernel (receipt targets and traces, one-operation-learned, replay-preserves-base-step-count, two branches, the sample normal form), and WrongSourceMustFail is rejected as intended. Under the pinned Agda the two substRefl steps left an unsolved implicit family; they are given explicitly (B = Î» q â’ Derivation q b) and the module now checks.
source_class: infrastructure (handoff Â§5 Lane I); repository content from another agent, composed in
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

## SamastaSima â” the typed frontier of the corpus is one computable Boolean, true at every stage

```text
claim_id: NV-TYPED-FRONTIER
statement: Over the corpus's actual objects: the RH fibre RHAt n of the Davisâ“Matiyasevichâ“Robinson arithmetization is decided (rh-dec, via <Dec), with a Boolean rhb sound and complete, so DMR.RH â‰ (âˆ m. rhb (suc m) â‰¡ true) (rh-definite; RH-is-section holds by refl); with KotiNirnaya's decided Goldbach fibre, the whole frontier Frontier = RH — Goldbach is the section of ONE Boolean family: Frontier â‰ (âˆ n. frontierb n â‰¡ true) (frontier-definite); one stage with frontierb n â‰¡ false refutes it (frontier-refuted-by); prefix k checks the first k stages (prefix-sound); and rhb 1, rhb 2, rhb 3, gcheck 4/6/8 and prefix 3 are true by refl â” the typechecker runs the DMR inequality and the sieve.
source_class: composition of the corpus's typed open problems (RH_TheWholeQuestionEntersTyped, SamastaPrasna, KotiNirnaya); this replaces the abstract Sima composition as the object-level statement of the frontier
parameters_and_quantifiers: none free: every ingredient is the corpus's computable definition; the section (n : â•) â’ frontierb n â‰¡ true is the open object
repository_commit: pin 168ea8e2; module at (this commit; see git log for the hash)
working_tree_changes: formal/cubical/theorems/primes/SamastaSima_TheTypedFrontierOfTheCorpusIsOneComputableBooleanTrueAtEveryStageTheRHFibreIsDecidedLikeTheGoldbachFibreSoTheWholeOpenSectionIsOneSectionAndTheOracleComputesItsPrefix.agda
imports_and_toolchain: Agda 2.8.0, agda/cubical v0.9, --safe; <Dec from Cubical.Data.Nat.Order
existing_terms_reused: DMR.RH, DMR.Î´, DMR.Hfrac, DMR.diffSq; SamastaPrasna.Goldbach, GoldbachAt; KotiNirnaya.gcheck, goldbach-sound, goldbach-complete
new_derivation_or_artifact: RHAt, RH-is-section, rh-dec, decb, rhb, rhb-sound, rhb-complete, RHBool, rh-definite, _and_, Frontier, frontierb, FrontierBool, frontier-definite, frontier-refuted-by, prefix, prefix-sound, first-three-stages, stages-below-three
proof_status: formal theorem checking (--safe, no postulates) plus kernel computation of the first stages
executed_commands: cd formal/cubical && LC_ALL=C.UTF-8 AGDA_DIR=$HOME/.agda-pin agda --safe <module>
exit_status_and_log: exit 0
negative_controls: NV-CONTROLS-10: RH-is-section without the 1 â‰ n guard is rejected; kernel gate: the Candidate claiming frontierb 0 â‰¡ false is rejected with "true != false"
correction_of: the abstract Sima module (NV-FRONTIER), which composed names rather than objects; kept as the route-equivalence shape, superseded as the statement of the unknown
endpoint_dependency_discharged: none; the section is uninhabited
remaining_assumptions: the classical equivalence of the DMR inequality with RH (cited in the RH module); stages beyond n = 3 of the RH fibre are decidable but not computed here (Î´(4) = 12 already makes the harmonic fraction unary-infeasible for the checker)
```

## Lane I ter â” the typed frontier through the native gate

```text
claim_id: NV-GATE-TYPED
statement: A Candidate importing SamastaSima is accepted by the kernel gate; vislesana computes F.frontierb 0 â¦ true, F.frontierb 2 â¦ true, F.rhb 3 â¦ true, F.prefix 3 â¦ true, and the inferred type of definite is (F.Frontier â’ F.FrontierBool) — (F.FrontierBool â’ F.Frontier). The Candidate claiming F.frontierb 0 â‰¡ false is rejected: "true != false of type Bool".
source_class: metacircular application: the corpus's kernel evaluates the corpus's own frontier stages
parameters_and_quantifiers: two fixed request streams
repository_commit: pin 168ea8e2; evidence at (this commit; see git log for the hash)
working_tree_changes: research/handoff_20260908/validation/native/frontier-typed/
imports_and_toolchain: sh interactive/run-machine.sh --wire (env as before)
existing_terms_reused: sadhana.patra, sadhana.vislesana
new_derivation_or_artifact: the five normal forms in positive.wire-transcript.jsonl
proof_status: finite executable control
executed_commands: sh interactive/run-machine.sh --wire < frontier-typed/{positive,false}.requests.jsonl
exit_status_and_log: exit 0 / exit 0; samorderna —2; dosalekha with the UnequalTerms line
negative_controls: the false Candidate
correction_of: none
endpoint_dependency_discharged: none
remaining_assumptions: none beyond the pinned toolchain
```

## NV-CONTROLS â” mutation negative controls

Three copies of the green modules were mutated in exactly one theorem statement and rechecked with the same command (`agda --safe`, inside the library tree). All three are rejected at the mutated line; sources and logs are in research/handoff_20260908/validation/native/mutants/.

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M1 | PunarAgamana | `first-return : K 2 â‰¡ Ablk Â Ablk + B Â C` â’ `â‰¡ Ablk Â Ablk` | 42 | MismatchedProjectionsError at the first-return proof (`_+_` vs `_Â_`) |
| M2 | Vartana | `(k + (l + three))` â’ `(k + (l + two))` in indicial-factors | 42 | solve! normal forms differ (`-_` vs `0r`) |
| M3 | AbelaRupa | `c Â (1r + (- T))` â’ `c Â (1r + T)` in normal-form | 42 | UnequalTerms `- T != T` |

The rejections are at the mutated statements, so the checker discriminates the exact identities, not only well-formedness.

## NV-CONTROLS-2 â” mutation negative controls for the second batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M4 | DvipadaGuna | Pascal rule `Cb a (suc b) +â• Cb (suc a) b` â’ `Cb a (suc b) +â• Cb a b` | 42 | first failure is the sanity check `Cb 2 2 â‰¡ 6` (`4 != 6`); the checker stops there |
| M5 | YogaPatra | composite `Zâˆ˜ = Zâ + (Râ Â Zâ) Â Tâ` â’ `Zâ + (Râ Â Zâ)` | 42 | UnequalTerms in compose-transforms (`Rc Â Z != Rc`) |
| M6 | DviSthana | `residues-are-halves : â¦ â‰¡ d + d` â’ `â‰¡ d` | 42 | solve! normal forms differ (`_+_` vs `1r`) |

## NV-CONTROLS-3 â” mutation negative controls for the third batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M7 | SmrtiMula | `symbol-modulus â¦ (Î 16 + Î¾ Â Î¾)` â’ `(Î 15 + Î¾ Â Î¾)` | 42 | solve! normal forms differ at symbol-modulus |
| M8 | PidaMatra | `Î¦â = â¦ âˆ’ rÂ²Â(Gâ² Â Gâ²)` â’ `âˆ’ rÂ²Â(Gâ² Â G)` | 42 | the Leibniz expansion L3 no longer matches the seven-monomial shape |

## NV-CONTROLS-4 â” mutation negative controls for the fourth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M9 | Sopana | `weyl : â¦ â‰¡ - (Î 2 Â Ï)` â’ `â‰¡ - (Î 3 Â Ï)` | 42 | solve! normal forms differ at weyl |
| M10 | ArdhaTala | `cauchy-3 â¦ (yâ + (- yâ))` â’ `(yâ + (- yâ))` | 42 | solve! normal forms differ at cauchy-3 |

## NV-CONTROLS-5 â” mutation negative controls for the fifth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M11 | DviMana | `reverse-conservation : (T Â J) Â S â‰¡ J` â’ `â‰¡ 1r` | 42 | UnequalTerms `J != 1r` |
| M12 | DhruvaMula | `h5-derivative â¦ (q Â q) Â (q Â q)` â’ `(q Â q) Â q` | 42 | UnequalTerms `q Â q != q` |
| M13 | Sikhara | `direction-absorbs-nothing â¦ (- (m Â Q))` â’ `(m Â Q)` | 42 | solve! normal forms differ |
| M14 | Grahaka | `weil-determinant â¦ (Mâ + Z)` â’ `(Mâ + (- Z))` | 42 | solve! normal forms differ |

## NV-CONTROLS-6 â” mutation negative controls for the sixth batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M15 | Vistara | `Î 3 Â (f Â g)` â’ `Î 2 Â (f Â g)` in symmetric-part-is-exact | 42 | solve! normal forms differ |
| M16 | GolakaMatra | `(S i l + S l i)` â’ `(S i l + S i l)` in fourth-contraction | 42 | solve! normal forms differ (first off-diagonal case) |
| M17 | GolakaTantra | `Î 6 Â (tr S Â Î´ i l)` â’ `Î 5 Â â¦` in tomography | 42 | solve! normal forms differ |
| M18 | UpaGuna | remainder `B v v` â’ `B Ï‰ v` in linearized-generator | 42 | solve! normal forms differ |

## NV-CONTROLS-7 â” mutation negative controls for the seventh batch

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M19 | SamaCakra | `helicity-cross â¦ â‰¡ (i , - i , 1r)` â’ `(i , i , 1r)` | 42 | solve! normal forms differ |
| M20 | Pratirodha | `cayley â¦ â‰¡ Î 4 Â â¦` â’ `Î 2 Â â¦` | 42 | solve! normal forms differ |
| M21 | Trikona | `convective-collapses â¦ (0r , 0r , a Â âˆâ v)` â’ `(0r , 0r , v Â âˆâ a)` | 42 | solve! normal forms differ |

## NV-CONTROLS-8 â” mutation negative control for the Catalan majorant

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M22 | KatalanaSima | `catalan-majorant : â¦ pow g (suc n)` â’ `pow g n` | 42 | UnequalTerms `g Â pow g n != pow g n` |

## Regression

All modules added since the pin were rechecked in one pass at the end of the session (`agda --safe`, each file separately); see research/handoff_20260908/validation/native/regression.log.

## NV-CONTROLS-9 â” mutation negative control for the frontier

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M23 | Sima | dyadic route closed with R-DYADIC in place of R-ABEL | 42 | UnequalTerms (the composite has the wrong type) |

## NV-CONTROLS-10 â” mutation negative control for the typed frontier

| mutant | module | mutation | exit | rejection |
|---|---|---|---|---|
| M24 | SamastaSima | `RH-is-section` stated without the `1 â‰ n` guard | 42 | refl no longer types: the corpus RH is exactly the guarded section |
