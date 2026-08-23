# Census of mathematical results in `formal/cubical/`

Read 2026-08-23. Scope: every `.agda` file at the top level and in
`NaturalMachine/` — 937 modules (350 top-level + 587 `NaturalMachine/`).
`Control/` (deliberately-failing gates) and `AbhijnanaProbes/` were skipped by
instruction. Method: header comment blocks (first ~40 lines) read in batches;
nothing was typechecked for this census. Each row is the module's main
mathematical statement in one line — the mathematics, not the framing.
17 modules had empty or near-empty headers; their rows are marked
"(headerless; from code)" and were reconstructed from type signatures only.

Areas: number theory (154) · algebra (130) · combinatorics (106) ·
logic-foundations (274) · order theory (61) · physics-QM (53) ·
linguistics-prosody (45) · graph-computation (107) · other (7). Total 937.

---

## Number theory (154)

| Module | Main result |
|---|---|
| `Apavartana_TheCarriedPairLosesTheLesserFromTheGreaterAndTheCommonMeasureStands` | A common divisor of a pair divides both sum and difference, so the subtractive kuttaka step preserves the common measure (gcd carrier law) |
| `Apunaragamana_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity` | The bhavana orbit from (3,2) under composition strictly grows in both coordinates, hence never returns: the x²−2y² unit orbit is infinite |
| `Ardhaccheda` | Jain ardhaccheda (log base 2 as iterated halving): halving inverts doubling, ardhaccheda(2^n)=n, floor-halving on even and odd |
| `Avarta_TheGeneratorsOrderAnnihilatesEveryPowerSoEulersHypothesisIsDischargedOnACyclicGroup` | Euler's hypothesis pow x φ ≡ ε discharged on a cyclic group: the generator's order annihilates every power (RSA's one number-theoretic fact, proved where RSA lives) |
| `Avasesa_TheResidueMapsFibreIsACopyOfTheNaturalsAndTheProgressionIsTheReceipt` | fiber (_mod k) r ≃ ℕ for r < k via q ↦ r + kq; the fibre is empty for r ≥ k |
| `Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAtSixtyOne` | Exact division as a carrier with propositional (not contractible) fibre — the divisibility witness; six cakravala turns at prakriti 61 reach ksepa 1 |
| `Bhavana` | Brahmagupta's bhavana over any commutative ring: N(a₁,b₁)·N(a₂,b₂) ≡ N(composite), both compositions, plus the homogeneity and divisibility-conversion identities the cakravala uses |
| `BhavanaGenerative` | Bhavana typed as an operation Sol D k₁ → Sol D k₂ → Sol D (k₁·k₂): solutions compose with multiplying norms; unit-norm solutions closed, ℕ-indexed family from a seed |
| `BhavanaKrida` | The bhavana as a typed game: cards are pairs with their norm proof, the move is patra k₁ → patra k₂ → patra (k₁k₂); eight moves from (1,1) at D=2 reach Baudhayana's 577/408 |
| `BhedaAvatarana` | Decision-free kuttaka descent: peel suc/suc structurally, remainder born when one side hits zero; identity is the fixpoint, no Dec/Bool anywhere |
| `Bija` | Bezout's relation via the kuttaka entirely in ℕ: a·x ≡ b·y + g in two alternating-orientation forms, no negative numbers (Aryabhata's valli) |
| `BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded` | Concrete RSA keypair executed in a cyclic CRT component: g³ ≡ ε, 5·5 ≡ 3·8+1, both decryption roads agree by refl |
| `Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation` | RSA correctness over any commutative monoid = Pingala's two exponent laws + one hypothesis (pow x φ ≡ ε); private key is the kuttaka witness |
| `Brahmagupta` | Brahmagupta's bhavana as a pure ℤ ring identity (both samasa and antara compositions), norms multiply, discharged by the ring solver |
| `Cakravala` | The cakravala's cyclic step is bhavana specialised to (m,1): composite norm = k·(m²−N), form preserved |
| `CakravalaBound` | Bhaskara's choice rule preserves k² ≤ 4D strictly (proved as 16k'² ≤ 36D), all in natural-number inequalities with no square roots — the window that makes the wheel terminate |
| `CakravalaDescent` | The cakravala step over any commutative ring: from a²−Db²=k and k\|(a+bm), the new triple satisfies a'²−Db'²=(m²−D)/k, with one congruence sufficing |
| `CakravalaNat` | The cakravala step cleared of subtraction: an ℕ identity with no hypothesis, GMP-computable (the ℤ form is unusable for concrete runs) |
| `CakravalaWitness` | Machine-emitted, kernel-checked cakravala run at D=61: 8 turns from seed to x=1766319049, y=226153980 with x²−61y²=1 |
| `Calana_TheRunAndTheInvariantForAllN` | The kuttaka run executed by the checker: each step is refl and the remainder invariant holds at every n by structure |
| `CyclotomicMined` | Machine-mined, kernel-certified LTE instances: v_p(a^n−1) = e + v_p(n) on the chain d\|n (odd p), with the naive rival refuted at (3,2,2) |
| `Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision` | Every n ≥ 1 is a finite product of primes (well-founded recursion), Euclid's lemma proved from gcd, and the support of the factorisation is determined by divisibility |
| `Dvikarani` | Baudhayana's 577/408 for √2 solves x²−2y²=1, and bhavana generates it from (3,2) by composition-with-self: (3,2)→(17,12)→(577,408) |
| `EGBPairComposition` | In split coordinates both compositions carry the pair product multiplicatively; prime pairs are not a submonoid (witness (3,5)∘(5,7)=(15,35), primality decided by refl) |
| `EGBPairConic` | (w+r)(w−r) = w²−r² over ℕ with the hypothesis r ≤ w: one conic carrying both Goldbach's and Fermat's projections |
| `EGBResidueGlue` | Non-coprime gluing on ℤ/24: mod-4 and mod-6 readings agree on ℤ/gcd=ℤ/2, yet 0 and 12 share joint readings — the hidden fibre of size gcd stays hidden |
| `EGBSuccessorCost` | The successor-action reopening cost on ℤ/m: m − (q+a) = q(2^a −1) − a for m = 2^a·q, both subtraction forms agree with no hypotheses, machine outputs recovered by refl |
| `FactoryVICoolingKill` | Countermodel killing the pure-cooling strategy: a single-term partition function with count ≍ X/log²X, roughness X^δ, log-affine Z_β, large Z₀, yet Z_{1/δ} → 0 — monotonicity+convexity do not imply twin nonvanishing |
| `FactoryVICore` | Integer-exact factor-share arithmetic: a^m ≤ b ⟺ a^{m+1} ≤ n (n=ab), and the quantifier tear ∀m∃x ⇏ ∃x∀m witnessed by the near-boundary family with empty unit set |
| `Gati` | The pulverizer's full iteration on a grant: resolves to the common measure or honestly holds its whole live state (no Dec, no Bool); computation refl-checked |
| `GhataTantu_TheDiscreteLogIsTheFibreOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt` | The discrete log is the fibre of Pingala's power map: singl(ghata g a) contractible (public key free) but fiber over ε non-contractible, containing the full period — the crypto asymmetry as the quotient/fibre law |
| `GrahaYuti` | Concrete kuttaka→CRT run: periods 3,5, witness 3·2 = 5·1+1, simultaneous solution X=8 of X≡2 (3), X≡3 (5), all by refl |
| `GunaDhana` | Mahavira's geometric-series sum at r=2, subtraction-free: Σ_{k<n} 2^k + 1 = 2^n (binary place value) |
| `GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating` | The cakravala wheel's state (m,k) is bounded and self-propagating: each turn's class carries the data for the next |
| `Gurutama` | First half of gcd correctness: the pulverizer's resolved g divides both original inputs (subtraction preserves common divisors, lifted back up the spine) |
| `GurutamaSiddha` | Full gcd correctness of the pulverizer: the resolved g satisfies the library's isGCD (divides both, divisible by every common divisor), with uniqueness |
| `HeadDepthMerge` | e_b(q) = v_q(b^ord−1) computed once; the 1048-triple table is a checked term, and strong (Miller–Rabin) blindness depth EQUALS Fermat blindness depth for odd prime powers (every Fermat liar is a strong liar) |
| `HeadDepthMergeBreaker` | Hostile replication: independently rebuilt primitives re-prove both headline certificates and agree pointwise on all 1048 triples; out-of-range divergences exhibited as terms |
| `HeadDepthTwo` | At q=2 the two-parameter sensor collapses: Fermat blindness on 2^a ⟺ b ≡ 1 (mod 2^a) (e₊ never enters, the Fermat exponent is odd); strong = Fermat by definitional degeneracy |
| `Jiva` | Aggregate of the living pulverizer: descent without decision, reversibility, gcd via isGCD, Bezout in ℕ, modular solution — one seed, each kernel-checked |
| `Khahara` | Bhaskara II's khahara: n÷0 (n≠0) is a determinate infinite unchanged by finite addition, distinguished from 0÷0 (a uniqueness failure, not expressibility failure — corrected header) |
| `KloostermanExponents` | The exact rational-exponent identities and inequalities of the Kloosterman parameter audit (denominators cleared to 40), decided by the kernel on ℕ |
| `Kuttaka` | The kuttaka as theorem: every run yields Bezout x,y with a·x + b·y ≡ g by back-substitution up the valli, g divides both and every common divisor divides g |
| `KuttakaCRT` | Bridge from ℕ kuttaka witness to ℤ Bezout (pos a·U + pos b·V = 1), feeding the CRT solver: pulverizer and conjunction in one pipeline |
| `KuttakaSamapti_TheValliIsFiniteForEveryPair` | Termination: for every pair a Run exists — the remainder measure decreases, so the valli is finite for every input (closing Kuttaka's conditionality) |
| `KuttakaValli` | replay is a monoid morphism from quotient lists to 2×2 matrices (replayHom), and det(replay v) = (−1)^length: trace concatenation is payload multiplication |
| `NaturalMachine/BezoutIsGCD` | BezN a b (a·x ≡ b·y + 1 in ℕ) implies isGCD a b 1: the bridge from kuttaka certificate to the library's gcd, subtraction-free |
| `NaturalMachine/CRTChain` | crtChain : Coprimes ms → Fin(suc(Prod ms)) ≃ Vec ms — the CRT for any list of moduli, with coprimality a per-install gcd computation |
| `NaturalMachine/Cakravala` | The cakravala step in cleared form: (k·k)(a'²−Db'²) ≡ (k·k)k' from one solver identity (am+Db)² − D(a+bm)² ≡ (a²−Db²)(m²−D) |
| `NaturalMachine/CakravalaNeedsKuttaka` | The cakravala's choice set is non-empty: a kuttaka run witnessing gcd(b,k)=1 produces m with a+bm ≡ kc for every a — the wheel calls the pulverizer at every cycle |
| `NaturalMachine/ChargeCriterion` | A query set admits a parity-separating decision procedure IFF it contains a query of odd Ω — both directions, the separator constructed (the parity barrier as a decidable criterion on methods) |
| `NaturalMachine/ChargeGradedPeeling` | Least-prime peeling drops Ω by exactly one and flips its parity: a directed map H(k+1) → H k of graded sectors, with the unit as sole fixed point (X=30, exhaustive refl) |
| `NaturalMachine/ChargePolynomialFinite` | Finite exhaustive certificates for the divisor-lattice characteristic polynomial and Chen-envelope prime projector theorems (Ω-instances by refl) |
| `NaturalMachine/ChargeTwoHistories` | A repeated prime has one charge-two history; two distinct primes have exactly the two orders; endpoint augmentation forgets the order and sums them |
| `NaturalMachine/ChenTwoChargeProjector` | Liouville parity on the two admitted charges (Ω=1 odd, Ω=2 even): algebraic commutation of the two projections, sharply fenced from any lower-bound claim |
| `NaturalMachine/ConeImage` | (s,d) is hit by the pair map ⟺ s+d is a double, over any commutative ring, with explicit constructive witnesses both ways |
| `NaturalMachine/ConeOrder` | Over ℕ the cone's parity congruence and the inequality d ≤ s fuse into one condition Σ m (s ≡ d+m+m): T17.13 as a one-Σ isomorphism |
| `NaturalMachine/ConvergentsAreDeterminedByThePrefixOfTheValli` | Stability: the k-th convergent depends only on the quotients strictly below k — reading more of the valli never revises what was produced |
| `NaturalMachine/CoprimePowers` | Bez a b → Bez a c → Bez a (bc), hence coprime bases give coprime powers: Bezout certificates compose by one polynomial identity (8 ⊥ 9 because 2 ⊥ 3, computed) |
| `NaturalMachine/CoprimePowersN` | IsPrime p → IsPrime q → p ≠ q → isGCD (p^i) (q^j) 1: the ℕ↔ℤ transfer completing the coprime-powers chain via the library's Euclidean Bezout |
| `NaturalMachine/CoprimeSplitting` | A least non-divisor q > 1 is a prime power: two distinct primes dividing n yield an explicit coprime splitting, and WalkForcing's no-splitting theorem closes the argument |
| `NaturalMachine/DescentIsNotInversion` | Invertible bhavana pairs have unit norm, so no composition step reaches norm 1 from non-unit k: the cakravala's descent is provably not inversion in the monoid — it is the scalar scaling action (homogeneity + equivariance) |
| `NaturalMachine/DiagonalEndpoint` | Factory VI diagonal endpoint compiler: near-boundary witness + subcritical certificate return the unit boundary through the exact discrete gap (no prime theorem postulated) |
| `NaturalMachine/DifferenceBasinCompiler` | Difference-basin compiler consuming the Delta-star recurrent-pair interface as proof-relevant input (record deliberately uninhabited here) |
| `NaturalMachine/DistinctPrimesAreCoprime` | IsPrime p → IsPrime q → p ≠ q → isGCD p q 1 (the schoolbook three-line case analysis completing the walk's residue-count chain) |
| `NaturalMachine/DivisibilityGuardsAreMeetClosed` | D_d ∩ D_e = D_lcm(d,e) mechanised from the lcm's universal property alone — no unique factorisation needed |
| `NaturalMachine/EndogenousHorizon` | A behavioural separator (prime r vs semiprime rs agreeing on all sub-threshold divisibility tests) shows no function of the sub-threshold observation decides primality |
| `NaturalMachine/EveryCommonDivisorOfAConvergentDividesTheDeterminant` | Any common divisor of a convergent's numerator and denominator divides the (unit) determinant of adjacent convergents |
| `NaturalMachine/EveryTripleIsARotation` | Every Pythagorean triple scaled by its inverse hypotenuse has norm one: the circle's identifications are indexed by the triples (one ring identity) |
| `NaturalMachine/ExponentBound` | Specification of logOf: p^(logOf p k) ≤ k < p^(suc(logOf p k)), from k < p^k proved by induction; hence p^a ∣ n ≤ k gives a ≤ logOf p k |
| `NaturalMachine/Factorisation` | Every positive n is a product of primes with the list as data: prime-divisor atom plus fuel-carried descent c < n |
| `NaturalMachine/FrontierCount` | Fin(prodOf es) ≃ VecOf es for any list of distinct-prime prime powers: the walk's residue count at a general frontier, one term |
| `NaturalMachine/FrontierDivides` | If every prime power in the frontier divides N, so does their product (iterated Gauss from Bezout certificates) — the easy half of the lcm universal property |
| `NaturalMachine/FrontierDividesHard` | m ∣ prodOf(frontierList k) for every 0 < m ≤ k: strong induction with prime peeling — completing prodOf(frontierList k) = lcm(1..k) by universal property |
| `NaturalMachine/FrontierIsWellFormed` | frontierList k is provably AllPrime and Distinct for EVERY k (not per-k refl): the frontier's residue count as a theorem |
| `NaturalMachine/FrontierList` | frontierList k = [(p, ⌊log_p k⌋) \| p ≤ k prime], computed with decidable hypotheses: at k=8 it is [(2,3),(3,1),(5,1),(7,1)], product 840, by refl |
| `NaturalMachine/FrontierMember` | Every prime p ≤ k appears in frontierList k with exponent logOf p k (pure list structure) |
| `NaturalMachine/GaugeOrbitClasses` | The transcript map's fibres are exactly the cosets of the annihilator subgroup qs^⊥ of the gauge torus: val is a character, and the parity barrier is a statement about observable classes |
| `NaturalMachine/JoinSavesTheMeet` | max x y + min x y ≡ x + y lifted through val: lcm(u,v)·gcd(u,v) ≡ u·v — the join saves exactly the meet (sign correction of OverlapIsTheCost) |
| `NaturalMachine/LCMExists` | lcm exists unconditionally for arbitrary lists (zeros included): a·b/gcd via untruncated divisibility, leastness from gcd multiplicativity without Bezout — the walk lane's standing hypothesis discharged |
| `NaturalMachine/MinimalityOfABoundaryPopulationNeedsLowestTerms` | Boundary populations at 1/(q+1) have minimal length q+1 (denominator divides length), but at 2/4 a length-2 population exists: minimality is false without lowest terms |
| `NaturalMachine/OracleCharge` | A functional-equation comparison cannot be parity-neutral: Ω(pn) = Ω(n)+1 puts the two ends in opposite parity sectors, so FE-closed query sets always contain an odd-Ω argument and admit a separator |
| `NaturalMachine/OracleQueries` | A functional-equation query carries NO charge (constant true on the class, simulated by ignoring the oracle): the same odd-Ω argument separates as a value and not through the FE — charge is a property of the reading |
| `NaturalMachine/OracleSeparation` | W3 split: the unspecialized FE oracle is simulated by the empty query set (no separation), while the specialized λ(pn) = −λ(n) instance separates against the full neutral-sector transcript with arbitrary post-processing |
| `NaturalMachine/PFreePart` | Every positive m factors as p^a·m′ with p ∤ m′: the p-adic split as a term, extracted by fuelled descent |
| `NaturalMachine/PairReflectionSector` | J(u,v) = (u,−v) restricts to the admissible sector at every finite prime (sum and difference fibres equivalent, counts equal — the local statement behind the common singular series); on the positive cone J breaks |
| `NaturalMachine/ParitySeparator` | val σ′ n = (−1)^Ω(n)·val σ n: the total gauge flip agrees with σ on every even-Ω argument, so a neutral observer returns identical data and no post-processing separates (the sieve parity barrier as a collision) |
| `NaturalMachine/PiPartialOnEveryPrime` | D0020's Π_∂ identity fails on EVERY prime by exactly 1, as a closed universal theorem — numbers represented by exponent multisets so the prime shape is derived, not assumed |
| `NaturalMachine/PrimalityDecision` | Dec (IsPrime n) for every n, by dispatching the bounded divisor search at k = n−1 |
| `NaturalMachine/PrimeCofactorCoprime` | IsPrime p → ¬(p ∣ m) → isGCD (p^a) m 1, in three lines with no Euclid (the primality definition does the work) |
| `NaturalMachine/PrimePairDecompositionCurvature` | The endpoint pattern {0,4} is locally admissible mod 3 while the materialized waypoint {0,2,4} is locally empty: a decomposition-loss certificate |
| `NaturalMachine/PrimeSquareOptionalComposite` | Modulus 5 is forced by the 5/25 collision while composite modulus 4 is inert: unique forced core, multiple sound anatomies |
| `NaturalMachine/PrimeSquarePinAdapter` | The 5 vs 25 collision compiled into a PinnedSensorForcing witness: modulus 5's admission is forced |
| `NaturalMachine/PythagoreanTransition` | Samasa-bhavana at D = −1 is the circle's group law: the conic has the additive transition the line lacks (correcting the chart-incompatibility over-claim) |
| `NaturalMachine/RadiusNoGo` | (headerless; from code) no-go on proper-factor radius: a ProperFactor-based radius bound is refuted in natural-number order |
| `NaturalMachine/ResidueTransport` | Residue/CRT observations compile along ℕ ≃ CanWord and replay via the odometer round trip: capabilities above the atomic core, no second engine |
| `NaturalMachine/RoughSplit` | If n ≤ X and every prime factor of n exceeds isqrt X, then n = 1 or n is prime — X-uniformly, with the integer square root constructed with its two-sided specification, and no factorization used |
| `NaturalMachine/SensorNerode` | The walk's minimal state is its lcm: Ind S a b ⟺ lcm S ∣ dist a b, with no arithmetic — the universal property applied to the distance |
| `NaturalMachine/SensorResidueBridge` | The residue bridge: m ∣ dist a b ⟺ equal residues mod m (both directions, pure induction) — closing SensorNerode's first gap |
| `NaturalMachine/SieveFiber` | The owner's experiment run: X=30 sieve fibre — visible valuation state below √X, residual bit ε, the fibre characterized, ε is one bit, and removing ε breaks reconstruction (finite parity obstruction as an actual fibre) |
| `NaturalMachine/SieveRoughBridge` | The bridge: SieveFiber's computed rough n satisfies RoughSplit's hypothesis, conditional on isqrt X ≤ 5 (the honest condition stated explicitly) |
| `NaturalMachine/SieveScaleTower` | The scale tower O₀→O₃ at horizons 0,2,3,5 with strict commuting squares and the homotopy fibres over the trivial state as explicit lists |
| `NaturalMachine/SuccessorIsNotTropical` | Consecutive integers share no coordinate in the derivation chart (gcd(n,n+1)=1): the successor has no locality in the tropical/multiplicative chart — the parity barrier as chart incompatibility |
| `NaturalMachine/TheArithmeticCircleIsFourPeriodic` | The arithmetic circle over ℤ is 4-periodic: rot i has order 4 and loop⁴ ≡ refl, so the loop map factors through ℤ/4 (vs ΩS¹ ≃ ℤ) — infinitude only on passing to ratios |
| `NaturalMachine/TheFibreIsTheSubject` | The norm's collision is vargaprakriti's subject: the group action (samasa-bhavana) on each norm fibre GENERATES the collisions — obstruction and group action are one fact viewed twice |
| `NaturalMachine/TheIstaSectionIsAnImportedConvention` | The ista reduction as an imported section: a parameter costing nothing (the reduced solution still solves), with least-non-negativity honestly still open |
| `NaturalMachine/TheValliConvergentDeterminantAlternates` | det(k+1) ≡ −det k for consecutive valli convergents, so every determinant is ± the first: each CF step is invertible over ℤ (losslessness = Bezout) |
| `NaturalMachine/TransmissionRefutations` | Three displays of the owner's transmission refuted as terms: the Π_∂ identity fails by exactly 1 on every prime, the Mobius display fails at ν=3 (the sum is φ(ν)), the classical identity verified at 1..12 |
| `NaturalMachine/WalkBridge` | The walk installs exactly the jump points of cap k = lcm(1..k), in increasing order: capacity is flat across skipped intervals (four-line argument), and the walk is made total |
| `NaturalMachine/WalkBridgeUniform` | Independent replication of WalkBridge with a strictly shorter flatness proof (antisymmetry, no induction) and the 1 ≤ m hypothesis removed |
| `NaturalMachine/WalkCapacity` | Any lossless sensor family with addresses ≤ k has lcm dividing lcm(1..k): e^ψ(k) is the capacity of frontier k, stated by universal property |
| `NaturalMachine/WalkChartedCap` | cap(m+1) ≡ cap m · capQuot m with the quotient exhibited and bounded by m+1: the capacity built inside the digit chart with no capacity-sized fold |
| `NaturalMachine/WalkChartedLength` | Canonicity of the scaling pass (0 < q load-bearing, failure at q=0 a theorem), and the length law: length(capw m) is logarithmic in cap m |
| `NaturalMachine/WalkChartedStep` | The walk's search re-typed against Word: findNDw returns the least q ≥ 2 with q ∤ value w, never converting the capacity back to unary |
| `NaturalMachine/WalkFast` | next m characterised by prime-power-hood: the Θ(e^ψ(m)) divisibility predicate traded for decidable prime-power tests at size ~q — a proved theorem buying a superexponential speedup |
| `NaturalMachine/WalkFastInstance` | next 8 ≡ 9, next 9 ≡ 11, next 10 ≡ 11 typechecked in seconds, with the sharing diagnosis (writing next 8 twice is what ran the walk) |
| `NaturalMachine/WalkForcing` | The walk's forcing law: a least non-divisor of L is a prime power (coprime divisors multiply, gcd-side, no Bezout) |
| `NaturalMachine/WalkInduction` | The induction along the walk: every reachable state satisfies the invariant and its lcm IS the lcm of its frontier range (capacity at every step, trajectory inhabited) |
| `NaturalMachine/WalkJumps` | A prime power p^a is a jump point: p^a ∤ lcm(1..p^a −1), for every prime and exponent |
| `NaturalMachine/WalkObservationCount` | The walk's observation space at frontier 8 is Fin 8 × Fin 3 × Fin 5 × Fin 7 ≃ Fin 840 by CRT applied three times: the lower bound is attained by mechanism, not arithmetic coincidence |
| `NaturalMachine/WalkPrimePowers` | The walk installs exactly the prime powers in increasing order (composition of the three checked pieces, with the genuinely new locate induction) |
| `NaturalMachine/WalkResidueBridge` | decDivides: divisibility of the number decided from the automaton's final state; equal to the unary decision (Dec of a prop is a prop); cost gap as a theorem: 5 steps vs 1001 |
| `NaturalMachine/WalkStream` | After installing q, lcm(S) = lcm(1..q): the single install step by universal property, both directions, with both side conditions shown load-bearing |
| `NaturalMachine/WalkStreamHypothesisBoundary` | The two-way universal-property form of installStream, with controls showing each side condition independently load-bearing |
| `NaturalMachine/WalkUnconditional` | The walk's laws unconditional: cap k is a computable number (hypothesis discharged by LCMExists), e^ψ(k) as a number |
| `NaturalMachine/WhereTheCircleSplits` | No integer squares to −1 (ℤ-has-no-i), so the conic over ℤ is a genuine circle and does not split into two lines — the dichotomy the subject turns on |
| `Paryayasabda_TwoNamesForTheParitySectorAndTheCharacterLawCarriesAcrossBetweenThem` | The two parity encodings (sgn with one-step recursion, parity with two-step) are identified and the character law carried across |
| `PrimePairField` | Goldbach and twin primes as the two transverse fibrations of one bounded pair type: centre/gap are the light-cone coordinates, J₂ exchanges the foliations but cannot preserve the positivity cone |
| `Punaragamana` | The lossless kuttaka descent: side, magnitude and remainder all kept, so the pair (a,b) is recoverable whole — reversibility as ahimsa, by structure with no decisions |
| `Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem` | The two scaled cakravala steps (CakravalaDescent.cakravalaScaled and NaturalMachine.Cakravala.cakravala-step) are ONE theorem over any commutative ring, interderived both ways |
| `Purnata` | Completeness: with grant suc(a+b) the pulverizer always resolves to the gcd — the pair-sum measure strictly decreases, so sufficient grant forces resolution |
| `R0021FlipOrbit` | Independent audit of the window-5 stationary countermodel: at most ten atoms vanish with equality iff the vertex, and the endpoint flip changes mass by a term ∝ a(ε₁+ε₅) — kernel-checked exhaustions |
| `Sadhyata` | Necessity of Aryabhata's solvability condition: if a·X ≡ b·Y + c has any solution then g = gcd(a,b) divides c (with sufficiency already in Yuti — the iff complete) |
| `Samasesha` | Subtraction-free congruence x ≈ y [m] ⟺ ∃ a b, x+am = y+bm: an equivalence relation compatible with + and ·, multiples vanishing — the groundwork for CRT |
| `Samvit_TheSharedSecretIsPingalasPowerCommutingWithItselfAndItsSecrecyIsTheInverseShorBreaks` | Diffie–Hellman correctness IS Pingala's exponent law plus a·b = b·a: ghata(ghata g a) b ≡ ghata(ghata g b) a over any commutative monoid; its security is the inverse fold Shor computes |
| `Sarvasthana_TheTotalOverEveryPlaceIsZeroAndTheArchimedeanEntryIsTheBalancingOne` | The product-formula accounting skeleton: for any exponent assignment and any weights, finite entries and the archimedean entry cancel identically (all in ℤ, weights abstract) |
| `Shora_TheClassicalHalfOfFactoringIsAZeroDivisorSplitByThePulverizerAndOnlyOrderFindingIsQuantum` | y² ≡ 1 → (y−1)(y+1) ≡ 0 over any commutative ring: Shor's classical extraction is a zero-divisor split finished by the kuttaka gcd; only order-finding is quantum |
| `Shunya` | Brahmagupta's zero rules as ring truths, with 0÷0 = 0 exhibited as a durnaya (corrected header: a uniqueness failure, not avaktavya) |
| `Sthairya` | Stability: a resolution survives any larger grant — fuel threads down structurally, so more grant cannot disturb a resolved answer |
| `Sulba` | Baudhayana's diagonal relation and the triple parametrization (m²−n², 2mn, m²+n²) as a checked ring identity (before Pythagoras) |
| `Trikarani` | √3 as vargaprakriti x² = 3y² + 1: fundamental (2,1), bhavana breeding (7,4), (26,15), … each of norm 1 — the sulba's equilateral ratio as a checked identity |
| `VajraAbhyasa_TheCrossProductIsOneAndTheNextClassIsExactlyMinusM` | Consecutive cakravala turns have crosswise product exactly 1, and from that alone gcd(b′,k′)=1 follows — so the next turn's admissible multipliers are EXACTLY the class of −m (no kuttaka run needed) |
| `Varana_TheChoiceWindowIsDerivedNotFitted` | The width of Bhaskara's m-choice window derived rather than measured: the minimiser is provably adjacent to √D, replacing the engine's two-run comparison |
| `VargaPrakrtiWitness_FundamentalUnitOfTheOrder` | Machine-emitted, kernel-checked fundamental unit of the maximal order of discriminant 61: ε = (39+5√61)/2 with N(ε) = −1, reached in 2 turns — a unit x² − 61y² = 1 cannot see |
| `VargaPrakrti_TraceBhavanaOverN` | Bhavana and cakravala with the middle coefficient carried (N(x,y) = x² + Txy − Cy²), over ℕ subtraction-free — the maximal-order generalization with Brahmagupta's T = 0 case exhibited as a checked specialization |
| `Vargana` | The Jain laws of indices (Anuyogadvara): a^(m+n) = a^m·a^n and (a^m)^n = a^(mn) |
| `VargaprakritiSreni` | Infinitely many vargaprakriti solutions from one: iterating bhavana from a fundamental keeps norm 1, by induction |
| `Vargaprakrtitantu_ThePellFibreIsInfiniteAndBrahmaguptasCompositionIsTheWitness` | fiber (ksepa D) 1 contains a strictly increasing sequence, hence is infinite: invariance (norms multiply) + growth (never returns) joined — the Pell fibre infinite with bhavana as witness |
| `Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts` | Generators split by punaragamana: ascending ones (bhavana, abstracted) never return, descending ones (ardhaccheda, vargasalaka) strictly decrease and exhaust |
| `Window5Walsh` | The length-five Walsh countermodel as kernel exhaustion over 32 sign patterns: masses non-negative, total 96, exactly ten zeros, values in {0,4,8}, at all four sharp vertices |
| `Yugapat` | The CRT projection direction: congruence mod b·c implies congruence mod b and mod c, subtraction-free, with a concrete conjunction (X = 8) |
| `YugapatZ` | The CRT existence direction over ℤ: from the Bezout witness bu + cv = 1, X = r₁cv + r₂bu solves both congruences simultaneously |
| `YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther` | The valli's endpoint matrix recovers its length exactly modulo 2 (det = (−1)^length): three unrelated no-decoder theorems are all sharp at ℤ/2, and odd padding is impossible |
| `Yuti` | Aryabhata's conjunction: a·X ≡ b·Y + c solvable when c is a multiple of the gcd, by scaling the Bezout witness — otherwise no solution and none fabricated |

## Algebra (130)

| Module | Main result |
|---|---|
| `Aikya_TheJointModelOfLeftZeroAndRightZeroIsASingletonSoTheEngineVerdictIsATerm` | Any binary operation satisfying both left-zero (xy=x) and right-zero (xy=y) laws forces the carrier to be a proposition; no model on Bool |
| `Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup` | The machine-proposed inverse (restriction) of inflation is provably not an inverse; the true inverse is a third map |
| `Bhadraganita_TheThreeByThreeSquareIsNineEntriesAndDecidabilityCrossesFree` | Mat 3 3 ≃ Nine and Col ≃ ℤ³: the entries/columns round trips are equivalences (half was already proved, the other half is refl) |
| `BhavanaSamuha` | Brahmagupta's bhavana is a full group law on ℤ[√N]: associativity in both coordinates, identity (1,0), conjugate inverse — the structure Gauss later generalized |
| `BhavanaSemiring` | Subtraction-free bhavana: cx² + Dx₁²y₂² + Dx₂²y₁² = x₁²x₂² + D²y₁²y₂² + Dcy² holds in any commutative semiring (the ℤ-form fails over ℕ monus; witness exhibited) |
| `CayleyPairChart` | The Cayley transform x=(z−1)/(z+1) conjugates leg exchange z↦1/z into x↦−x and sign flip z↦−z into x↦1/x, over a commutative ring with denominators cleared (the pair involutions are Mobius geometry on P¹) |
| `CenterRelative` | Pair ≃ CR (parity-compatible lattice); one-leg reflection J₂; positivity cone preserved by exchange but not by J₂; the quadratic invariant Q=W²−R²=4pq with Q∘J₂=−Q |
| `CenterRelativeWeightTransport` | The pair product transported along Pair ≃ CR is the unique division-free quarter of Q: four(nativeWeight y) = Q y |
| `CyclicAliasing` | Exact aliasing: the cyclic projector (1/M)Σ ζ^{-sν}A(ζ^ν) returns the sum of the whole residue class of s mod M supported in [0,R]; exact iff M > R |
| `EGBDetConservation` | det is a monoid morphism on upper-triangular 2×2 matrices over ℕ: det(PQ)=det(P)det(Q) subtraction-free, with the sector restriction exactly what clears the subtraction |
| `EGBRootedNet` | The rooted reflection total space Σ x. View_x with π⁻¹(x) ≃ View(x), instantiated on the pair net: p+q=2w, q−p=2r, pq=w²−r² proved at every jewel |
| `EGBThreadYoneda` | Yoneda for the free category on the pair net's two thread families: Map(x,y) ≃ Nat(よx, よy), both round trips checked |
| `Ekadhara_ReplayAtConstantWordsIsPingalasFoldSoOneHomomorphismCarriesValliAndMetre` | replay(repeat n q) ≡ matGhata (L q) n: Pingala's fold is the valli replay at constant words, and the matrix exponent law follows by transport; the exponent laws need only Monoid, not CMonoid |
| `Gamma0Converse` | If any integral K stabilizes (HDK ≡ D, D=diag(d₁,qd₁), d₁≠0) then q divides H₂₁, witness extracted as k = −εK₂₁ — closing the Γ₀(q) iff |
| `Gamma0ConverseSharp` | Anatomy of the converse's hypotheses: ε²=1 is derivable (unimodularity is forced by the stabilization equation when q≠0), d₁≠0 is load-bearing (vacuous+false at d₁=0) |
| `Gamma0Freeness` | Freeness of the stabilizer action: H·U ≡ U for unimodular U forces H = I (adjugate + integral cancellation) |
| `Gamma0Index` | [GLᵣ(ℤ):Γ₀(D)] = ∏_p p^{G_p−E_p}·Gaussian multinomial, verified exhaustively in the kernel for r=2,3,4 by counting matrices over ℤ/n (corroboration of the note's theorem) |
| `Gamma0IndexExponent` | The exponent arithmetic G_p − E_p = Σ_{u<t} r_u r_t (f_t−f_u−1) ≥ 0 of the Γ₀(D) index formula, proved for every rank and divisor chain |
| `Gamma0Partner` | Divisibility as witness: from c = kq the explicit two-sided partner K with HDK ≡ D is constructed, division-free, over all of ℤ |
| `Gamma0PartnerRigidity` | The two-sided stabilizer partner is unique (entrywise canonical), the partner type is a proposition, contractible given a witness, and partner ≃ witness — Γ₀-membership and stabilization are one type |
| `Gamma0Transitivity` | Transitivity of the payload action: the explicit transporter H = ε·U′·adj U carries any normalization event to any other and stabilizes the endpoint — completing the torsor (free + transitive) |
| `IntegerHullMultiplicity` | The two convex relaxations m² ≥ 2m−1 and m² ≥ 3m−2 are lossless for ALL N,S: integer optima of atom-count minimization equal the relaxation values, via the substitution m=1+x reducing both to per-element facts |
| `Ksepa_ThePassedInvariantComposesAndTheGradingIteratesOnlyIfItIsACharacter` | Bilinear weight W a b = u a ⊗ u b ⊗ g(a⊕b): the composite grading iterates iff g is a (twisted) character — locating exactly where the INDRA_CROSS table stops being bhavana |
| `M1SplitIdentity` | The convolution split of METHOD M1: the double sum over ℕ≥1×ℕ≥1 partitions as corner (1,1) + two cross terms + remainder, for arbitrary weight and arithmetic function in any commutative semiring |
| `M2Unimodular` | 2×2 toolkit: adjugate identities adj·H = H·adj = det·I, det multiplicativity (Binet n=2), and unimodular determinants are nonzero |
| `MachineLibrary` | The engine's discovered identities re-proved by hand: second-argument vs first-argument recursion give the same functions on ℕ with different definitional behaviour |
| `Madhava` | The finite geometric sum (1−r)·Σ_{k<n} r^k ≡ 1 − r^n over any ring — the algebraic bone of Madhava's series; the limit statement honestly left un-said |
| `MadhyaVinimaya_TheMiddleExchangeIsOneLawStandingInSixPlaces` | The interchange law (a∘b)∘(c∘d) ≡ (a∘c)∘(b∘d) proved once over a commutative semigroup; six independent corpus declarations proved literally equal to its instances |
| `MalaSetu_TheFreeMonoidFoldIsOneHomomorphismAndPingalasPowerAndTheValliTraceAreTwoAlphabetsOfIt` | foldMap is a monoid homomorphism (List A, ++) → (M, ⋆) with no commutativity; Pingala's power and the valli trace are its one-letter and digit-alphabet instances |
| `NaturalMachine/ActionResidual` | The equivariance residual q(step x) − predict(q x): zero residual iff pointwise commutation; square-under-successor leaves residual 2x, strictly splitting the old fibre |
| `NaturalMachine/AntyaSamskaraSthaulya` | Madhava's end-corrections as successive solutions of R(n)+R(n+1)=1/(2n+1): each correction's exactness is a polynomial identity, its coarseness computed |
| `NaturalMachine/AssemblyCharacterNonfaithfulness` | The three assembly gradings are multiplicative characters of concatenation whose product controls the determinant but is not faithful: the pulverizer letter's quotient is invisible to all three |
| `NaturalMachine/BoundedStateNeedsAGroup` | Among the walk's three laws only the group can forget (window-slide); ℕ-cone and join installs are irreversible (positivity, idempotence) — bounded state needs inverses, in three checked instances |
| `NaturalMachine/BraidCoherenceBoundary` | Adjacent swaps on three Boolean strands satisfy the Yang–Baxter braid relation; negation-and-identity are involutive equivalences that fail it at a named point — invertibility alone gives no braid action |
| `NaturalMachine/CarryClassNonzero` | For every base b ≥ 2, n ≥ 1 and EVERY digit section, the carry class [cₙ] ≠ 0 in H²(ℤ/bⁿ; ker πₙ): carrying is a nonzero cohomology class |
| `NaturalMachine/CarryObstruction` | Carrying cannot be removed by any choice of digit set: the extension 0 → bⁿℤ/bⁿ⁺¹ → ℤ/bⁿ⁺¹ → ℤ/bⁿ → 0 does not split (direct exponent argument) |
| `NaturalMachine/CenterRelative` | Over any commutative ring with half+half ≡ 1: Φ(p,q)=((p+q)/2,(q−p)/2) and Ψ are mutually inverse, and reflection ρ IS the transport of exchange τ along ua(Φ) |
| `NaturalMachine/CenterRelativeIntegral` | Without 2 invertible, the integral sum/difference map composes with its inverse to DOUBLING, not identity: the chart's defect is exactly multiplication by 2 |
| `NaturalMachine/ChargeGrading` | Shifts add under composition, a degree-δ map sends sector c to c+δ, sector-closure iff δ=0 (over cancellative ℕ), parity is a strict truncation of charge (witness pair) |
| `NaturalMachine/ChargeIsStrictRefinement` | The Lean strict-refinement iff and the Agda gauge-orbit annihilator statement are one theorem; the parity charge criterion is that iff evaluated at τ₋, and the transport alone does not decide charge |
| `NaturalMachine/CompositionalContextAdapter` | Equality under all generated one-hole contexts is a congruence for the binary operation and the greatest observation-compatible magma congruence; quotienting by the bare observation kernel is unsound (four-state control) |
| `NaturalMachine/CompositionalMagmaFactorization` | The factor of a context-constant magma map through the contextual quotient is again a magma map and unique on generators |
| `NaturalMachine/ContextCloneEquivalence` | Mutual word-simulations identify complete-future equality and induce an Iso of set quotients; left and right projections have equivalent contextual quotients despite unequal operations |
| `NaturalMachine/DSOFactorRankFinite` | Every min-plus rank-one matrix obeys the additive 2×2 minor identity: the exact finite semantic-width lower-bound seam |
| `NaturalMachine/DSOFiniteCore` | The trefoil identity M(ab,c)+M(a,b) = M(a,bc)+M(b,c) proved for any semigroup with a ℤ-measurement (both sides equal the ternary defect); the D4 four-element table certified by 64-case exhaustion |
| `NaturalMachine/DSONucleusExecutionCalibration` | The four-state execution defect M computed from the state multiplication: full table and trefoil identity as kernel reductions |
| `NaturalMachine/DSONucleusFinite` | A two-boundary cost relation exactly separable through one rank-one mode: K(a,c) = x(a) + y(c), soundness certified |
| `NaturalMachine/DSONucleusMiddleAssociativityAudit` | Exhaustive 64-case associativity of the Delta 29 middle closure family, made feasible by explicit sharing (tab) reducing 5e9 leaf evaluations to ~1e3 per cell |
| `NaturalMachine/DSONucleusMiddleProduct` | The ternary defect has both trefoil decompositions on the middle Isbell operator's four-cell calibration |
| `NaturalMachine/DSONucleusOneSidedProduct` | The left Isbell closure and one-sided product computed over the full finite fiber of the four-cell execution defect |
| `NaturalMachine/DSONucleusResidualAudit` | Delta 29 residual synthesis audited on the four middle profiles with boolean order-decisions checking both truth and falsity |
| `NaturalMachine/DescentCostsTheIntegers` | Three walk laws, three failures, two reasons: join irreversible by idempotence, ⊕ by positivity; only the ℤ-exponent group inverts, and its price is admitting ratios (the cone sits properly inside) |
| `NaturalMachine/FiniteGraphCohomology` | F2 graph cochains: a cycle evaluation (additive functional killing vertex coboundaries) is gauge invariant and descends to the quotient |
| `NaturalMachine/FiniteNonabelianHolonomy` | A finite nonabelian (S₃) instance of the holonomy/refinement seam, falsifiable |
| `NaturalMachine/FiniteWorldMaximizer` | For integral polynomial f nonvanishing on finite E, any v_p(f)-maximizer fails to transport; dropping the nonvanishing clause makes the statement false (proved) |
| `NaturalMachine/FluxUnitCancellationBoundary` | D(1)=0 for a Leibniz flux only once unit and additive-cancellation laws are supplied; a Boolean inhabitant shows they cannot be inferred from the record |
| `NaturalMachine/FreeMonoid` | List Unit is the free monoid on one generator; concatenation is literally the transport of addition along ua, and the two monoids are EQUAL by SIP |
| `NaturalMachine/Gamma0` | Γ₀(D) at any rank as the entrywise congruence dᵢ ∣ dⱼPᵢⱼ, decidable with refusals as witnesses, collapsing to the classical N ∣ c at n=2 |
| `NaturalMachine/GlobalSmithAtlasFlatness` | Global Smith chart transitions obey the cocycle law with every closed triangle the identity: global relabellings cannot create loop holonomy (negative closure of the holonomy seed) |
| `NaturalMachine/GroupCohomologyH2` | H²(Q;A) constructed as an actual quotient group (Z²/B²) with effectivity; class-zero ⟺ homomorphic section, locating the carry class as a nonzero element |
| `NaturalMachine/HolonomyDescent` | Orbit quotient (path erasure): a set-valued task descends iff invariant under every holonomy, with unique descent (isContr) and effectivity; coinvariants via raw generator relation with no closure lemma |
| `NaturalMachine/IdempotenceForbidsDescent` | In any monoid an idempotent element with an inverse is the unit: no step of a join law can be undone, so the walk's monotone capacity is forced (contrast: bhavana has non-unit invertibles) |
| `NaturalMachine/InflationVersusSubgroup` | Inflation H¹(G/N,V) → H¹(G,V) is injective (enlargement along a quotient); for a subgroup inclusion there is no canonical map at all, and the needed transport is impossible on the smallest model |
| `NaturalMachine/LeakageCommutator` | In any involutive ring with p† = p, a† = a: pa − ap = L† − L for L = (1−p)ap — the commutator is the antisymmetrized leakage; idempotence never used, †1 = 1 derived |
| `NaturalMachine/LineWorldTransport` | The line-world transport criterion s ≢ −1 holds only for f = X+Y: dropping the hypothesis makes the criterion false (f = X transports at every slope), all by finite exhaustion at p=5 |
| `NaturalMachine/MeanStandardRep` | R^k ≃ R × V_k by mean/deviation for k invertible (general k); S_k fixes the mean and acts on V_k by the standard representation; transpositions non-scalar for k ≥ 3 |
| `NaturalMachine/NoNormOnAJoin` | A multiplicative norm on a join monoid takes at most two values (idempotents of a domain): among any three states two collide — no norm, no descent, closed without measurement |
| `NaturalMachine/NumberIsExponentialInDerivation` | suc e ≤ b^e for b ≥ 2: the walk's stored number is exponential in the derivation it encodes — the size lives in the encoding, not the lattice width |
| `NaturalMachine/OrderedSectorBreak` | The positive cone is not invariant under the centre-relative equivalence: an exact SectorBreak inhabitant over a parameterized ordered ring |
| `NaturalMachine/OverlapIsTheCost` | On disjoint supports join and sum coincide, and nothing is disjoint from itself except 0: val is multiplicative for the join exactly on coprime pairs (killing SignIsNotAccumulable's antecedent) |
| `NaturalMachine/PMCokernel` | Peres–Mermin: the all-ones parity functional vanishes on im δ while the sign vector has odd weight, so no global section — coker(δ) ≅ F₂ with the invariant as content (vs the 512-case exhaustion) |
| `NaturalMachine/PMGaugeCohomology` | Cech H¹ carrier of the PM twist: cycle parity descends to the gauge quotient, so the odd class is gauge-invariant and edge location is only a representative choice |
| `NaturalMachine/PMIncidenceLocalSystem` | The PM incidence HIT: a Bool local system trivial on eight overlaps and negating across ZZ has nontrivial holonomy on the six-edge cycle — no global section |
| `NaturalMachine/PMMonodromyDerivationNoGo` | Any endpoint-only edge rule has even holonomy around the cover cycle while the PM obstruction is odd: the ZZ-supported representative is a gauge choice, not derivable from vertex signs |
| `NaturalMachine/PMRelationalNoFit` | The naive context-indexed family HAS a global section: the PM no-section theorem needs overlap compatibility (an incidence/Cech base), not the discrete context type |
| `NaturalMachine/PMRelativeProcessBridge` | The PM incidence HIT is a genuine dependent RelativeProcess base: the six-edge loop composes and the generic no-fixed-loop theorem yields no-global-sheet |
| `NaturalMachine/PMTorus` | The Peres–Mermin incidence graph IS K₃,₃ (graph isomorphism exhibited) and violates the bipartite planarity bound E+4 ≤ 2V |
| `NaturalMachine/PairCoordinates` | Centre, product, gap are the coefficient/discriminant coordinates of the quadratic with the pair as roots; the product is the split quadratic norm; the gap is a determinant — one ring theorem instantiated at two levels |
| `NaturalMachine/PayloadMorphism` | Carrier rank is relative to the morphism class: the same payload has rank 1 unrestricted and rank 3 graded (proved), with chain-map closure forcing dim U + dim dU as a third class |
| `NaturalMachine/PerspectiveSymmetry` | Stab S s e = Defect e s s: the stabilizer of a structure is its self-defect, so subgroup laws (T15.9) are transport functoriality read on the diagonal; symmetry breaking and structured transport are one mechanism |
| `NaturalMachine/PolynomialAttachmentGrowth` | (headerless; from code) attaching an operation to a signature: filler terms and their recognition, growth of the term algebra |
| `NaturalMachine/PolynomialRewrite` | (headerless; from code) signatures, term algebras, and algebra structures: polynomial rewriting over an arbitrary signature |
| `NaturalMachine/QuadraticRefinement` | Refinements of a fixed alternating form over F₂ form a torsor under Hom(V,F₂) (difference additive, shifts refine): the 16 = 10+6 Arf split behind Mermin squares made structural |
| `NaturalMachine/RepairTorsor` | Repairs of a defect form a torsor under Aut of the repaired object (free and transitive, contractible transporter type): the repair is canonical iff the group is trivial |
| `NaturalMachine/RootWeightIndex` | ℤ^k/ℤ(1..1) is the A_{k−1} WEIGHT lattice, not the root lattice; P/Q ≅ ℤ/k, and at k=2 that ℤ/2 is exactly the pair map's parity constraint — three Delta items are one index computation |
| `NaturalMachine/S3ConjugacyObservation` | The fixed-vertex type is a nonconstant gauge-invariant loop observation for S₃, with conjugation-invariance turned into equality by univalence |
| `NaturalMachine/S3EquivariantEndomorphismRigidity` | Every equivariant endomorphism of the natural transitive S₃ action on Fin 3 is the identity; the terminal action admits a collapsing intertwiner |
| `NaturalMachine/S3FiniteSpinNetwork` | The natural S₃ action on Fin 3 as a finite calibration of the spin-network kinematics (inverse action fixing the left-action convention) |
| `NaturalMachine/S3FixedPointCharacter` | The trace of the three permutation matrices equals the cardinality of the fixed-point type (finite character calibration) |
| `NaturalMachine/S3IntegerPermutationModule` | The two adjacent transposition generators act ℤ-linearly on the integer permutation module |
| `NaturalMachine/S3IntegerRelativeCoordinates` | The augmentation-zero lattice over ℤ is ℤ² via (a,b,−a−b); the radial intersection is 3-torsion, hence zero by torsion-freeness |
| `NaturalMachine/SignIsNotAccumulable` | An accumulative (idempotent) law admits no multiplicative function taking any unit value other than 1: knowing something twice is knowing it once, as a ring theorem |
| `NaturalMachine/SmithCapability` | The cubical Smith normalizer already returns matrix, transformations, replay equation and normality proof: replay is a path, not a test |
| `NaturalMachine/SmithKernelQuantumBoundary` | The joint Smith kernel (ℤ/2)² fixes the four-state memory type; the two elimination orders differ by the swap involution, so interoperability needs the explicit alignment automorphism |
| `NaturalMachine/SmithPathCountedExecution` | The two adjacent-pair Smith schedules on diag(2,3,2) certified over the library's integer-matrix layer: the transcribed tables are genuine Smith certificates |
| `NaturalMachine/SpectatorPaddingCollapse` | Commutative binary parallel composition makes unary order disappear after padding (two-arity algebraic seam) |
| `NaturalMachine/StabilizerSubgroup` | The stabilizer of a structure point is a genuine library Subgroup of SymGroup A, given the two h-level hypotheses that were actually missing |
| `NaturalMachine/StabilizerTorsor` | The transporter T x y carries a free transitive Stab-action (any two transporters differ by a unique stabilizer element); endpoint-invariant certificate selection forces trivial stabilizer |
| `NaturalMachine/SthaulyaIsTheOmittedTerm` | For EVERY convergent of the Madhava continued fraction: (h_k(n)k_k(n+1)+h_k(n+1)k_k(n))(2n+1) − k_k(n)k_k(n+1) = (−1)^{k−1}4^k(k!)² — the coarseness in closed form from the determinant recurrence |
| `NaturalMachine/SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3` | countFix is a class function on S₃ (values 3,1,0 on the classes), conjugation-invariant abstractly, hence a closed-loop gauge-invariant for nonabelian holonomy |
| `NaturalMachine/StructuredSymmetryTransport` | A structured equivalence conjugates preserved symmetries both ways: the symmetry group is an invariant of the structured object, not its presentation |
| `NaturalMachine/SumProductTorus` | The Σ/Π torus: derivations add and take pointwise max while numbers multiply and take lcm, cohering by max-over-plus |
| `NaturalMachine/TheDerivationIsDenseToo` | The walk's derivation is dense (every coordinate nonzero at frontier 8): the exponential encoding saving is per-coordinate only, so the encoding is A mechanism of the size, not THE mechanism |
| `NaturalMachine/TheTrajectoryIsAChain` | Along the walk's own trajectory, every join is an absorption (the lattice is never used): the machine pays for a lattice to move along a chain |
| `NaturalMachine/TheTruncationErrorIsExactAtEveryFiniteStage` | The truncated geometric series' error is exactly r^n at every finite stage over ℤ; the partial sum alone does not carry it (at n=1 the sum is 1 for every ratio) |
| `NaturalMachine/TranslationPeakObservability` | A sharply cancelling translation family with one singleton fibre makes one-step response profiles faithful: FutureBehavior collapses to state equality |
| `NaturalMachine/TwoLoopNonabelianNetwork` | Raw S₃ holonomy distinguishes the two orders of two based loops; the fixed-point profile identifies the conjugate three-cycles — the exact boundary between path order and class observation |
| `NaturalMachine/TwoProjections` | im(PQ) = im P ∩ im Q needs commutation (necessity witnessed); non-commutation makes order matter; and a COMMUTING pair with constant composite: zero commutator, total loss |
| `OrbitSeparation` | (headerless; from code) for an automorphism α : X ≃ X and observable P : X → C, separation of α-orbits by P-invariants |
| `PMNoSection` | Peres–Mermin no-section by 512-fold typechecker exhaustion: every context has local sections, no global assignment satisfies all six |
| `ParityNormEliminant` | The degree-10 reflection product, the 3×3 and 4×4 Sylvester determinants, and norm multiplicativity — the four identities under the parity/resultant lane, proved over an arbitrary CommRing |
| `Rank1DihedralChart` | The rank-one cell's stabilizer acts on the transporter chart by S(b,e)·U(k,s) = U(k−bs, es), transitively and freely (pure ring identities, sign entering only as s² = 1) |
| `ResponseCharacterKickback` | Phase kickback needs a character: ℤ/2 has the nontrivial sign character; every sign character of ℤ/3 is trivial, so trit translation admits no one-query ±1 kickback |
| `Rupasamata_TheTwoByTwoMatrixAndTheFourTupleAreOneObjectAndMultiplicationAgrees` | Mat 2 2 ≃ ℤ⁴ with the equivalence intertwining the library's matrix product and Gamma0Partner's mul — the missing equivalence upgraded from the one-directional bridge |
| `SamraksakaSamuha_TheInvertibleConservingFlowsAreTheSymmetryGroupAndTotalLossMakesItAllOfAut` | The invertible conserving flows form the observable's symmetry GROUP, trivial at zero loss and all of Aut(A) at total loss (GroupEquiv with function part refl) |
| `SexticParityEliminant` | The sextic parity/eliminant spine: the exact commutative-ring algebra under the sextic obstruction note |
| `SimplicialDefectFailure` | The defect family of a charted Chu space is functorial on the degeneracy half of the simplex category and no more: faces fail in both variances at once (counterexample), and a cocycle forces triviality (with the converse in one direction) |
| `Sl2DivisorLattice` | The sl₂-triple on the rank-one divisor chain: all three brackets ([η,ε]=2ε, [η,φ]=−2φ, [ε,φ]=η) checked pointwise with structural truncation, no truncated subtraction |
| `Sl2TensorProduct` | The multi-index sl₂ action on the divisor lattice B_n = ⊗ V_{α_i} (the general case of the chain) |
| `SmithDeterminantClassMultiplicativity` | Congruence witnesses multiply, so determinant classes multiply under matrix composition; the d=5 control shows the allowed sign classes are closed while their complement is not |
| `SmithTorsorBridge` | The certified Smith normalizer computes a SECTION of the event torsor: its replay path converted to the torsor's event equation, any other presentation differing by the explicit transporter |
| `SubgroupIndex` | (headerless; from code) subgroup index for finite groups: decidable-prop machinery, Index and Extremes modules bounding index at the extreme subgroups |
| `SubsetSumChartDepth` | The labelled subset-sum response determines its argument exactly to congruence mod p^(m+1): the observational fibre contains a whole congruence class with non-proportional tuples (depth m is not enough) |
| `TomographyConditioning` | The exact conditioning constants: κ_pow,raw = R+1 and κ_pow = C(2R,R), via the unsigned Stirling alternation and rise R R · R! ≡ (2R)! — general in R, nothing fitted |
| `TotientFibreSymmetry` | An existentially quantified transitive group action always exists (the observational stabilizer), so it separates nothing; pinned to the multiplicative chart the totient's stabilizer is TRIVIAL (fibre {1,2} not in any orbit) |
| `TransporterMembership` | The Smith event set is a Γ₀(q)-torsor, closed: the explicit transporter between any two events has lower-left entry divisible by q, witness computed — every clause a program |
| `TransporterPortReduction` | A ported transporter IS the unported transporter of the product action at the pair point: ports reduce, joint stabilizers embed, and a redundant port certifies nothing |
| `TrayoNirnaya_TheEnginesThreeVerdictSemanticsEachCarryOneCheckedRepresentative` | The engine's three verdict classes each get one kernel representative: left-zero ⟹ semigroup (SUCCEEDED), the Aikya collapse (IMPOSSIBLE), and semigroup strictly weaker than commutative (STRICTLY_WEAKER) |
| `YogaDhruva_TheFibreOfAdditionIsATorsorAndEveryConservingFlowIsATranslation` | fiber yoga n is a ℤ-torsor under the shears (free, transitive, unique joining shear): the charge/gauge split at its smallest — the sum is the charge, the shear the gauge motion |
| `YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields` | (Σ Φ. conservation yoga Φ) ≃ (R × R → R): the conserving flows of addition are exactly the shear fields, over any commutative ring — the cut's freedom is a function space |

## Combinatorics (106)

| Module | Main result |
|---|---|
| `AksaraDviguna` | Vak(n+1) ≃ Vak(n) ⊎ Vak(n): object-level equivalence behind Pingala's 2^n count of n-syllable metres |
| `AksharaDvaya_TheVirahankaBoolFibreAndThePingalaChandasFibreAreOneWeightedCount` | fiber over List Bool weight = fiber over List aksara matra: Virahanka's weighted count and Pingala's matra count are one object; recurrence transported |
| `Ankapasa_TheMetreNamesAFiniteSetAndTheLoopsOfThatSetAreTheFactorial` | Pingala's sankhya is a cardinality (a component of the groupoid of finite sets) and the loop space of that component has exactly n! elements (Bhaskara's ankapasa product) |
| `Avrtti_TheFibreOfACountingMapSatisfiesARecurrenceAndThatRecurrenceIsSankhya` | fiber length (suc n) ≃ X × fiber length n and fiber length 0 ≃ Unit, for any element type: the counting map's fibre satisfies the sankhya recurrence |
| `Bhara_TheWeightedCountingMapsFibreDecomposesOverEverySummandThatFits` | The weighted counting map's fibre over n decomposes as Σ x Σ m (w x + m ≡ n) × fiber m — the fitting witness carried as an equation, no truncated subtraction |
| `Bharavrtti_TheWeightedCountingMapsFibreDecomposesByHeadWeightAndTheNilCaseIsASeparateSummand` | Exact weighted-fibre recurrence: fiber f n ≃ (nil summand for n=0) ⊎ Σ x Σ m (w x + m ≡ n) × fiber f m, round trips by refl |
| `Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided` | Metre n is definitionally fiber matraOf n (and likewise Vak, Chosen): the pratyaya fibres are refl-identified with the prosody types |
| `ChitiDvipada` | Aryabhata's vrnda (sum of triangular numbers) equals the third meru diagonal: citi n ≡ C(n+2,3), bridged via the vara-sankalita hockey-stick |
| `Citighana` | 6·Σ_{k≤n} T_k ≡ n(n+1)(n+2): Aryabhata's citighana/tetrahedral sum, division-free, by induction |
| `DviGhataVargana` | Pingala's additive 2^n equals the multiplicative power: dvi-ghata n ≡ ghata 2 n, carrying the Jain (a^m)^n = a^(mn) law to the additive tower |
| `DviMatra_TheFibreOverTotalTwoIsExactlyBoolTheSmallestVeil` | fiber chandah 2 ≃ Bool: the first total at which Pingala's matra count forgets anything is 2, and the loss is exactly one bit |
| `Dvipada` | Binomial C(n,k) from the Pascal recurrence alone; Narayana's vara-sankalita in closed form is the hockey-stick V_r(n) = C(n+r, r+1) |
| `EkaksharaSetu_TheOneLetterTallyIsThePiZeroOfFinSet` | Tally ≃ π₀FinSet: the one-letter free monoid and the iso-classes of finite sets, composed through ℕ, with cardinality agreeing with word length |
| `FinCardinality` | (headerless; from code) finite-cardinality toolkit: split of equal bounded sums into componentwise equalities, pointwise sum equality over FinSet, mod-0 to divisibility |
| `GhanaBaddha` | Closed form of Aryabhata's cube sum: 4·Σk³ = (n(n+1))², completing the closed forms of the three sankalitas |
| `HomometricPair` | A={0,1,2,6,8,11}, B={0,1,6,7,9,11} have identical interval vectors (all 15 differences) yet are provably not congruent under any translation/reflection of ℤ — a genuine kernel of the difference marginal |
| `Lagakriya_TheConditionalFibreIsWhatTheSecondCountStillCostsOnceTheFirstIsKnown` | The guru-count fibre over a partial specification: the conditional count of forms with given gurus once the matra total is known (Pingala's lagakriya as fibre of the counting map) |
| `Lopa_TheSumsFibreIsExactlyNPlusOneAndNoLeftInverseExists` | fiber of addition over n is exactly the (n+1)-point antidiagonal, and no left inverse of the sum map exists |
| `MatraSamasa` | Virahanka's metre count over chandas and Narayana's samasa-bhavana over List ℕ at {1,2} count the same numbers: both satisfy M(n+2)=M(n+1)+M(n) with M₀=M₁=1 |
| `MatraSetu_TheVirahankaFibreCountsAsFinByBridgingToPingalasMetre` | fiber chandah n ≃ Metre n ≃ Fin (matra n): Virahanka's fibre counted by bridging alphabets to Pingala's closed form |
| `MatraVarnaGuru` | matraOf p ≡ varna p + guruOf p: the three per-syllable statistics are bound by one relation, so Chosen n k has duration exactly n+k |
| `Matramerus` | Virahanka's count M(n+2)=M(n+1)+M(n) with soundness and completeness: the enumeration carries exactly the weight-n patterns ("Fibonacci" five centuries before Leonardo) |
| `Matrasankhya_TheMatraFibreIsFinOfTheVirahankaNumber` | fiber chandah n ≃ Fin(matra-sankhya n): the matra fibre is a standard finite type with census computed by the Virahanka recurrence |
| `Meru` | Halayudha's meru-prastara (Pascal's triangle 600 years earlier): next row from adjacent sums, each row summing to 2^n |
| `MeruKarna` | The shallow diagonal of the meru sums to Virahanka's count: Σ_k C(n−k,k) = M(n), decision-free, via the diagonal Pascal lemma |
| `MeruSammiti` | Meru symmetry C(j+k,k) = C(j+k,j) (i.e. C(n,k)=C(n,n−k)), subtraction-free, by double induction on Pascal's recurrence |
| `MeruTantu_TheGuruCountFibreSplitsByHeadIntoTheTwoAdjacentCellsWhichIsMeruprastara` | fiber (varna,guru) (n+1,k+1) ≃ fiber (n,k) ⊎ fiber (n,k+1): the meru/Pascal rule as an equivalence of fibres, not an equation of counts |
| `Narayana` | Narayana's cow sequence a(n)=a(n−1)+a(n−3) generated (not decided), with recurrence, soundness and completeness of the emanation |
| `NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches` | The {1,3}-composition fibre splits at the head into weight-1 and weight-3 branches: Narayana's cow recurrence as an equivalence of fibres |
| `NarayanaKarna` | The steeper meru diagonal Σ_k C(n−2k,k) equals Narayana's cow sequence: {1,3}-compositions counted by the step-2 diagonal, via a two-step induction |
| `NarayanaSamasa` | length(gosarga n) ≡ length(sarga {1,3} n): Narayana's bespoke cow emanation and the general samasa-meru at {1,3} agree, by three-term induction |
| `NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn` | Pingala's nashta/uddishta as rank/unrank: index↔pattern in log n steps with no table, proved inverse |
| `NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne` | The least worst-case number of adaptive valuation queries identifying r in ℤ/p^k is exactly k(p−1): upper bound by digit-descent protocol, lower bound by adversary — both halves checked |
| `NaturalMachine/CarryBorrowObservation` | c(E w) = z(w) for every finite base-4 word (complement exchanges carry and borrow counts); positive borrow value excludes first-digit-nonzero and distinct words collide at 0 |
| `NaturalMachine/CarryChartBridge` | Deleting the MSD does not preserve canonicity (counterexample); reducing the b^(n+1)-chart coordinate mod b^n equals the chart coordinate of normalizeMSD |
| `NaturalMachine/CommutationPreservesEveryPredicateAndMultiplicityWhereItIsStatable` | Adjacent-transposition equivalence preserves Any, All, length with no hypotheses, and multiplicity of every element given Discrete — the same-multiset claim exactly where it is statable |
| `NaturalMachine/CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity` | The permutation relation preserves the count of each element (multiplicity), a statement posable only with decidable equality |
| `NaturalMachine/Decategorification` | ℕ ≃ π₀(FinSet) (card is the π₀ collapse), and what the collapse forgets is exactly the loop space: FinSetLoop ≃ Sₙ |
| `NaturalMachine/DiagonalIsMatra` | matra n ≡ Σ_{a+b=n} meru a b: Virahanka's matrameru is the shallow diagonal of Pingala's meru-prastara, via cardinalities of the sorted-pattern equivalence |
| `NaturalMachine/DigitTowerFin` | The Vec transport warning is a vocabulary artefact: with words as Fin n → Digit, zero warnings; LSD deletion is not additive at base 2 but is a homomorphism for carry-free XOR |
| `NaturalMachine/DigitTowerFinLimit` | MSDLimit A ≃ (ℕ → A) for any set A: the MSD inverse limit ported to the Fin presentation via the top-splitting eliminator |
| `NaturalMachine/DigitTowerLimit` | The MSD/LSD digit-tower inverse limits with the reversal equivalence MSDLimit ≃ LSDLimit and transported carry law (Vec presentation, warning retained) |
| `NaturalMachine/Digits` | ℕ ≃ CanWord constructed: value (positional sum) and digits (iterated odometer) are mutually inverse — the odometer computes the successor |
| `NaturalMachine/DivisorHistoryDSO` | A divisor history with labelled events observed through ordered blocks: residual fiber is Π b! and the visible count is the iterated binomial coefficient |
| `NaturalMachine/DurationIsSyllablesPlusGuru` | matra p ≡ varna p + guru p, giving Metre n ≃ Σ_{a+b≡n} Chosen a b with no truncated subtraction |
| `NaturalMachine/Endian` | Word reversal D and digit complement E are commuting involutions (Klein four) and neither descends along value; E commutes with delete-MSD while D intertwines delete-MSD with delete-LSD |
| `NaturalMachine/EndianAtlasReplay` | The four two-bit raw words replayed little-endian against their integer codes |
| `NaturalMachine/FinTopSplit` | The top-splitting eliminator for Fin (suc n) (the library only splits at the bottom): one lemma unlocking MSD-tower inductions |
| `NaturalMachine/FiniteEquivalenceBridge` | A finite equivalence lifts by univalence to a path of FinSets, whose card gives the arithmetic equality — exactly the invariant cardinality retains |
| `NaturalMachine/FiniteOccupancyChannelNoGo` | 1010 and 1100 share Hamming weight and occupied-pair count but differ on adjacency: a symmetric occupancy summary is not a local channel |
| `NaturalMachine/FixedCarryChart` | Fixed-width MSD deletion composes strictly and intertwines the tower with Endian.π; normalization preserves each stage's residue chart but is provably not a tower morphism |
| `NaturalMachine/LosslessLowerBound` | Any injective observation of {0..n} needs at least n+1 outcomes (pigeonhole as a term): the walk's lcm(S) > n criterion becomes a bound on every machine |
| `NaturalMachine/MeruDiagonalIsVirahanka` | Fib(n+1) = Σ_k C(n−k,k): the meru's shallow diagonal equals the matrameru count — the bridge between two encodings, four lines of induction |
| `NaturalMachine/OffDiagonalThueMorseUnique` | Uniqueness of the ±1 solution of ε(2m)=ε(m), ε(2m+1)=−ε(m): any two solutions agreeing at 0 agree everywhere, so the solution set injects into Bool |
| `NaturalMachine/OptimalObservation` | Optimal = injective with card Y ≡ card X, forcing minimality among all lossless schemes; Pingala's uddishta, Virahanka's matrameru and the walk's CRT proved optimal against one definition |
| `NaturalMachine/PairsSummingTo` | Pairs n ≃ SumFin (suc n): the antidiagonal has n+1 elements by structural induction with no truncated subtraction |
| `NaturalMachine/PingalaIsOptimal` | No lossless observation of the n-syllable metres has fewer than 2^n outcomes, and uddishta attains it: Pingala's algorithm proved optimal against every scheme |
| `NaturalMachine/PointedReindexOrbitObstruction` | Coordinate reindexing preserves every constant assignment, so a collision with a distinct constant assignment need not be a reindexing orbit |
| `NaturalMachine/RadixResidueUnification` | The big-endian Radix and little-endian TransportDiv digit actions are one object: val(rev w) ≡ value w with the reversal part of the statement |
| `NaturalMachine/RadixSymptoma` | Two states of the base-b divisibility automaton are behaviourally equal iff they have the same set of shortest completions: a two-coordinate complete invariant σ(r) = (κ r, b^{κr}·r mod m) |
| `NaturalMachine/RawWordPaddingNormalForm` | A raw little-endian word is uniquely a canonical numeral followed by a run of zeros at the MSD end: the fibres of the positional chart |
| `NaturalMachine/Sankalita` | Σ_{m<n} meru(m+r) r ≡ meru(n+r)(r+1): one summation of a meru column is the next column, so Kerala varasankalita and Pingala's array are the same object at the recurrence level |
| `NaturalMachine/SpernerFromSl2` | The divisor lattice of p^α is Sperner via its sl₂ action (rank-one Stanley/Proctor chain closed): raising maps full-rank, rank-symmetric, unimodal — classical, formalized |
| `NaturalMachine/SymmetryArithmeticAction` | A permutation acts on register assignments by precomposition: the action data the cardinality n! forgets, with loops acting through checked permutations |
| `NaturalMachine/SymmetryCardinality` | \|Aut(Fin n)\| ≡ n!: the loop-symmetry carrier's size compiled to the arithmetic factorial |
| `NaturalMachine/SymmetryEnumeration` | (Fin n ≃ Fin n) ≃ Fin (n!): permutations enumerated by Lehmer codes as factorial-base numerals — the k-th permutation is computed, not just counted |
| `NaturalMachine/TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself` | card X ≡ card Y IS the mere equivalence ∥X ≃ Y∥₁ on FinSet (not a lossy proxy): the count half of Optimal says nothing about the scheme itself |
| `NaturalMachine/TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree` | The converse containment between the two permutation relations reduces to transitivity of Perm (three of four cases free) |
| `NaturalMachine/TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem` | Two insertions commute (exchange lemma), giving Perm transitivity and hence the containment Perm = ≈ in both directions |
| `NaturalMachine/TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable` | The open pigeonhole (Optimal → isEquiv) reduces to the Fin case, usable because the target is a proposition (mere equivalences eliminate) |
| `NaturalMachine/TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem` | The two pigeonhole forms are interderivable: nothing about finite sets remains in the open item (only the Fin-level fact) |
| `NaturalMachine/TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions` | "The usual reasons" proved in a page: the inductive permutation relation embeds in the adjacent-transposition closure, over an arbitrary element type |
| `PanktiYoga` | Σ_k C(n,k) = 2^n from the Pascal recurrence alone: the binomial's prosodic root — decompose the metres by guru-count and re-sum |
| `Pingala` | Pingala's prastara as bijective base-2: successor is the next-row rule, reconstruction total, decisionless and reversible |
| `PingalaGhata` | Pingala's binary exponentiation (Chandahsastra 8.28–31): the square-and-double fold over Halayudha's marker list computes 2^(value), in log steps — the markers ARE the binary digits |
| `PingalaPrastara` | matrameruIso: Metre(2+n) ≃ Metre(1+n) ⊎ Metre n; any counting function satisfying the fibre equivalences obeys the Virahanka recurrence; nashta/uddishta as an Iso Vak n ≃ Fin(sankhya n) |
| `PingalaSatya` | Pingala's vinyasa as a TOTAL honest machine (always answers): soundness = the prastara reconstruction — the interface is general, not gcd-specific |
| `PraksepaSankhya_TheProjectionsFibreCensusIsTheDiscardedFactorAndTheAbhijnanaIsSupplied` | The census of a projection's fibre IS card B, and the untruncated identification is supplied at this concrete map (the truncation discharged) |
| `PrastaraPankti` | sankhya n ≡ Σ_k C(n,k): Pingala's metre count IS the meru row sum, as a proof rather than a numerical coincidence |
| `Pratyaya_TheChandasCountsStandTwiceAndTheTwoProofsAreOnePath` | Two pairs of duplicate chandas-count proofs identified: same definitions, one type, and since ℕ is a set the proofs themselves are equal |
| `Salaka_TheOrdersAreSeparatedByHowManyCutsTheyOutlastAndEachCutStripsExactlyOneStorey` | Each salaka cut strips exactly one storey of the exponential tower: k cuts level a height-k tower and fail on height k+1 — the Jaina orders separated by the instrument, exactly |
| `SamaVisama_TheCountSplitsByParityIntoTwoCopiesOfItselfAndEachNayaIsTheWhole` | ℕ ≃ ℕ ⊎ ℕ (hence ℕ ≡ ℕ ⊎ ℕ): Pingala's even/odd nashta decision as the reversible split, with merge as inverse |
| `SamaghataSankalita_TheDescentIsExactForEverySequenceAndAryabhatasRulesAreItsFirstInstances` | The Kerala power-sum descent has an exact finite kernel for every sequence, with Aryabhata's citighana and doubling rules as its first instances |
| `SamantaraSankalita_TheGeneralSeriesAtOneAndOneIsTheSankalitaAndTheExampleWasStandingForIt` | shredhi 1 1 n ≡ Σ n for every n (both double to n·(n+1)): the arithmetic progression at a=d=1 IS the sankalita — the theorem replacing a refl at n=4 |
| `SamanyaGhata` | General-base square-and-multiply: the fast algorithm computes a^(value of the marker list) in log steps, proved against the naive power (Pingala's method at any base) |
| `SamasaDvi` | The single part {2}: the composition count is the even-indicator with pure period-2 recurrence a(n+2) = a(n) |
| `SamasaDviAmsa` | The general two-part {L,M} recurrence a(n) = a(n−L) + a(n−M), subsuming Virahanka {1,2}, Narayana {1,3} and the unit-free {2,3} as corollaries |
| `SamasaEkAmsa` | The general single-part {L} law: pure period-L recurrence (the L-divisibility indicator), with {1} and {2} as the k = 0,1 cases |
| `SamasaEka` | The degenerate base: with part-set {1} every n has exactly one composition — the constant line the whole samasa-meru family perturbs |
| `SamasaEkagra` | A unit part at the front makes the composition sequence non-decreasing: the root of positivity for every unit-containing recurrence |
| `SamasaMeru` | Narayana's samasa-bhavana for the {1,L} family: generation with soundness and completeness, the recurrence a(m) = a(m−1) + a(m−L) proved fuel-independently |
| `SamasaMeruN` | The samasa-bhavana over an ARBITRARY finite part-set: generation, soundness, completeness, fuel-independence, and the sum-recurrence a(n) = Σ_p a(n−s_p) (tribonacci etc. as instances) |
| `SamasaNyuna` | Below the smallest part the composition count is zero, over an arbitrary part-set |
| `SamkhyataAnanta_AdjoiningANumerableToTheCountablyInfiniteReturnsTheCountablyInfinite` | Fin k ⊎ ℕ ≃ ℕ: adjoining any numerable collection to the countably infinite returns it — the Jaina principle as an absorption law |
| `Sankalita` | Aryabhata's series sums: 2·Σk = n(n+1) and the gem Σk³ = (Σk)², proved by hand via distributivity |
| `SankhyaTantu_TheFibreOfAFiniteSourceMapIsFiniteAndItsCardinalityIsTheReceipt` | Every fibre of a finite-source map is finite with computable cardinality: the counting receipt for dozens of finite-source edges (count delivered, identification honestly withheld) |
| `SetuYugma_TheSeamFordJoinsTheValliToPingalaAndVivekaIsTheNaturalNumbers` | (ℕ × ℕ) ≃ ℕ (diagonal enumeration) and hence viveka ≡ ℕ: the seam ford joining the valli component to the metre component |
| `Shadrasa` | Bhaskara's six-tastes count: Σ C(6,k) = 64 (the meru row-sum instance), the per-size row 1,6,15,20,15,6,1 by refl |
| `Shredhi` | Aryabhata's AP sum (Ganitapada 19): 2S = n·2a + n(n−1)d, by induction, with Σk as the a=d=1 case |
| `Sthana_ThePositionalWordIsPingalasNextRowAndItsAdditionArrivesWithNoCarryRule` | The base-b positional word IS Pingala's next-row rule transported (odometer with carry), and its additive monoid is the transport of ℕ's — the second causeway routed through the identification graph |
| `Uddista_TheReceiptBecomesAnAddressExactlyWhenTheFibreRankIsCarriedAndItsPriceIsVirahankasNumber` | Pattern ≅ Σ n. Metre n: carrying the whole fibre rank makes the matra an address, and the rank space at weight n is exactly Virahanka's number |
| `VaraSankalita` | Narayana's r-fold repeated summation with the recurrence V_{r+1}(n) = V_{r+1}(n−1) + V_r(n), unifying Aryabhata's triangular and tetrahedral orders |
| `VargaGulma` | The sum of the first n odd numbers is n² (the sulba gnomon construction's arithmetic), subtraction-free over ℕ |
| `Vargacitighana` | Aryabhata's sum of squares: 6·Σk² + 3·n(n+1) ≡ 2·n(n+1)(n+2), via k²+k = 2T_k dodging the cubic crux |
| `Viloma_TheBackwardReadingOfAMatraMetrePreservesItsDurationSoReversalIsAnInvolutionOnEachDurationFibre` | The matra map is invariant under list reversal, so reversal is a non-identity involution of every duration fibre — the prastara's palindromic symmetry the recurrence cannot see |
| `Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence` | fiber chandah (2+n) ≃ fiber chandah (1+n) ⊎ fiber chandah n: Virahanka's recurrence as an equivalence of fibres, not a count |

## Logic and foundations (274)

| Module | Main result |
|---|---|
| `AbhavaAvacchedaka` | Absence formalized as dependent record whose limitor (avacchedaka) is a dependent binder; the absence is a genuine function of the limitor |
| `Abhedabheda_OneObservationFailsToSeparateWhatIsDistinctAndTheFullClassNeverDoes` | cong is free (indiscernibility of identicals); a single observation cannot separate true from false; with the full class univalence gives identity of indiscernibles |
| `Abhijnana_TheReceiptAndTheElisionAgreeOnTheResultAndDifferOnlyInTheFibre` | Two maps into one codomain, one an equivalence and one not: the codomain never determines losslessness, only the fibre does |
| `AchromaticToy` | Certified Bool ≃ Unit⊎Unit; a cycle of certified lenses composes to not≠id (ua-path ≠ refl); a collapse kept as graph relation loses nothing while the quotient does |
| `Adhisthana_TheFreeReversalStandsOnTheDeMorganSiteAndTheKanFloorHasTwoOperationsNotOne` | transp and hcomp are distinct Kan primitives; path reversal is free only on the De Morgan cube site, derived on the cartesian site |
| `Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm` | Three independently declared module terms are definitionally the same term uaβ; identification is refl (grade-one duplication) |
| `Alopasetu_TheEnginesInvarianceIsTheOrbitLawInstantiatedAndNotASeparateInduction` | Rewriter soundness eval(step t)≡eval t is the orbit conservation law instantiated; the two iteration orders commute |
| `AmshaSatyayantra` | The partial honest machine: soundness + stability without completeness; permanent un-said (ananta avaktavya) is consistent |
| `Ananta` | ℕ and ℕ→Bool are provably inequivalent infinities (Cantor diagonal, checked constructively) |
| `Anapeksa_BlindnessToACoordinateIsAFactorisationSoEveryStepInItConservesForFree` | An invariant that factors through a projection is conserved for free by every step moving only the invisible coordinate |
| `Anekanta` | Saptabhangi predication over vallis in the discreteN register, with a repaired soundness bug (witness now bound to the terms) |
| `AnuktaAvaktavya` | The un-said (anukta) and the inexpressible (avaktavya) are separated by a swapped quantifier: removable-by-grant vs never-removable |
| `Anupalabdhi_AbsenceIsAStatementAboutTheWholeFieldAndNotAFailureAtAPoint` | ¬Σ ≃ Π¬: a claim of absence is a Π over the whole domain, never a failed search at a point |
| `Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge` | Non-apprehension yields knowledge of absence only under the fitness (yogyata) hypothesis, formalized as a hypothesis of the theorem |
| `Anuvrtti_TheGlueIsTransparentAndTheWholeCostIsTheNeutralTypeNotTheIdentification` | transport(ua e)x ≡ equivFun e x holds by refl even on neutral input; the whole cost is one stuck transp at a neutral type and does not accumulate under composition |
| `Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork` | Three fibre grades (contractible/propositional/neither): algorithms have content exactly at propositional fibres, where existence is the work and uniqueness free |
| `ApohaParyaya_WhetherConceptualContentIsNegativeIsWhatTheTwoSchoolsActuallyDispute` | Bauddha apoha and Jaina paryaya accounts formalized as incompatible structures; the incompatibility exhibited as a checked object without resolution |
| `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis` | Irreversible collapse: no retraction exists for the collapse to Bool/propositional truncation; the retraction type is exactly the h-level hypothesis |
| `Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence` | The forgetful map from naya-carrying saptabhangi positions to label positions is a homomorphism for both modes of assertion, has a section, and is provably not an equivalence |
| `Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible` | A ≃ Σ b (fiber f b): every history decomposes as boundary datum plus what the boundary failed to retain; memory is the fibre failing to be contractible |
| `Avacchedaka_TheTruncationsFibreIsTheWholeSourceAndTheSeamHasItsCriterion` | fiber \|_\|₁ x ≃ A for x in the propositional truncation: the truncation's fibre is the whole source |
| `BehavioralApartness` | FutureEq is a proposition (sameness carries no data) while Apart is provably not a proposition (a separating experiment is data): apartness and equality are not De Morgan duals |
| `Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMovesTheoremsBetweenThem` | Two definitionally distinct eqℕ testers identified by an exhibited equivalence; completeness transported to the module that never proved it |
| `BhittiDvaya_TwoMoreWallsTheFiniteBanksCannotMergeWithTheNaturals` | ¬(ℕ ≃ Unit) and ∀n ¬(ℕ ≃ Fin n) (via pigeonhole): finite banks cannot merge with the naturals |
| `BhittiSankrama_WallsTransportAlongFordsSoEveryFordRetiresCandidatesForFree` | (A ≃ B) → ¬(B ≃ C) → ¬(A ≃ C): a wall composes with a ford into a wall, so the candidate list shrinks quadratically |
| `BhittiSaptabhangi_TheSevenfoldCannotBeTwoValuedSoTheTopJoinCandidateIsAWall` | ¬(saptabhangi ≃ Bool): any two-valued verdict on the sevenfold identifies two of the three seeds (pigeonhole), so the top join candidate is a wall |
| `Bhitti_TheNaturalsAndTheBooleansAreAProvedWallSoThatSeamIsRetiredForever` | ¬(ℕ ≃ Bool): a finite type is not the naturals, retiring the largest candidate merge in the ford graph |
| `ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm` | On S¹ with the double cover z↦z²: pointwise fibre-invariance holds as data yet no factorization through the image exists (parity of winding refutes it) — the isSet hypothesis in fiberConstant→factorsThrough is necessary |
| `ContractibleFiberSectionBoundary` | The section space of a↦Σx(a≡x) is contractible for every A, but a retraction of A → ∥A∥₂ exists iff A is a set; S¹ separates the two |
| `DesaSanghata_TheCensusComposesAndThatIsWhyCostIsNotAGradedMonoid` | Census composition laws: empty outer fibre absorbs, contractible outer fibre is transparent, and vikala∘avaktavya = sakala (two defects annihilate) — so route cost is not a graded monoid |
| `DescentLaw` | Descent through a carrier is the elimination rule of the set quotient: an observable constant on fibres factors uniquely; a splitting witness refutes every factorization |
| `DisclosureDimension` | Minimal disclosure alphabet is strictly submultiplicative on composites (3 < 2·2 exhibited), so its log is not additive and set-level disclosure is not a dimension |
| `Durnaya_TheBlindnessNeedsBothConditionsAndTheHiddenChargeIsExactlyTheIntegers` | cong of the identity on the universe does not kill the circle's loop: the blindness needs non-dependency AND the answer's h-level; the hidden charge is exactly ℤ (winding) |
| `Dvayam_AnyLossEmbedsABitSoTwoIsTheSmallestVeilThereIs` | Any failure of injectivity embeds Bool into a fibre: one bit is the minimum possible loss |
| `EGBCycleHolonomy` | The holonomy of a 3-cycle of equivalences is an automorphism; the (not,not,not) cycle on Bool has holonomy `not` ≠ id, giving a non-refl loop at Bool in the universe |
| `EGBFalsifierAsymmetry` | Refutation of a decidable Π₁ is finitely witnessed (one point) while every bounded Π is decidable; the unbounded Π is deliberately undecided — the falsifier/verifier asymmetry as Σ/Π |
| `EGBPhiIdempotent` | (A/R)/≡ ≃ A/R: the achromatic set-quotient reflector is idempotent — the second pass adds no identifications, so generativity must live in the retained defect |
| `EGBReversalInvariant` | List reversal is an involution; length is reversal-blind, head is reversal-sighted, the fixed locus is Palindrome (with witness and refutation) |
| `EGBSpanWeave` | Proof-relevant relation composition keeps its middle: associativity up to equivalence, path relation is left unit, and Total⋈Total over Bool has two distinct inhabitants (the middle is remembered) |
| `EGBTear` | The pair net tears: composing shared-centre and shared-radius threads carries neither invariant (exhibited disagreement), and Γ turns a tear into the next stage's jewel |
| `EGBTwoFibrations` | One total space Σ w Σ r. P w r with two projections: Goldbach-shape = all π₊ fibres inhabited, twin-shape = π₋ fibre over 1 unbounded (abstract, no primality) |
| `GananaAsNat_TheIndicatorsFullCensusPricesTheBusiestUnpricedEdge` | The indicator Bool→ℕ: fibres over 0,1 contractible, over n+2 empty — injective, not an equivalence, defect entirely of the empty kind |
| `GodelSeparation` | Cantor and Tarski are one Lawvere term; Godel I's second conjunct (truth of the undecided sentence) is provably NOT an instance of Lawvere's fixed-point theorem |
| `IndraNet` | Yoneda for the univalent groupoid: ((z:A) → z≡x → z≡y) ≃ (x≡y); rooted total space; local thread updates propagate to every profile by transport; guarded net domain equation with bisimulation-is-identity |
| `InvarianceConstant` | The invariance theorem of Kolmogorov complexity abstracted: mutual simulation with bounded overhead implies uniformly bounded difference, constant max c₁ c₂, with groupoid laws on the Within relation |
| `JainSankhya` | The Jain stratification of magnitude (3 kinds × 3 grades) as a strict lexicographic order: every lower-kind magnitude strictly below every higher-kind one |
| `Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry` | The fibre of the constant (zero-divisor) map is the whole domain, and total loss is exactly total symmetry: every endomorphism conserves a constant observable |
| `Kosthabhitti_TheHaniIsAWallGeneratorSoThePigeonholeRetiresJoinsAcrossTheWholeNet` | Wall generator: a two-valued codomain plus three pairwise-distinct source points yields ¬(A ≃ B) — the pigeonhole makes the wall family a theorem |
| `Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis` | The pigeonhole (three points into two values, two images agree) is unconditional; the LOSS (genuine merge) needs pairwise distinctness as a separate hypothesis — stated over any carrier |
| `LawvereDiagonal` | Lawvere's fixed-point theorem in full: a weak enumeration e : A → (A → Y) gives every ν : Y → Y a fixed point; contrapositively `not` productively refutes any enumeration (Cantor), exhibiting the disagreeing point |
| `Lekha_TheAppendOnlyFoldAbsorbsRefutationAndABooleanCannotCarryIt` | Ledger fold: pending holds exactly on the empty log, refutation is absorbing, and no boolean transition function simulates the three-valued fold (⊥ exhibited) |
| `Lekha_TheWholeAuditTrailOfAChainIsFreeToCarryAndNotOnlyOneStep` | The whole audit trail is contractible at every length: a point dragged through n maps with all intermediates and witnesses is equivalent to the bare point (induction) |
| `LiftingFiberResidue` | Pareto transport through a forgetful functor is constructive and hypothesis-free; the note's "validity ⟺ nonempty fibre" conflates ¬¬, ∥·∥₁ and Σ, and the residue is an undeclared logical principle |
| `Namantara_TheLatinLabelledSevenfoldAndTheDevanagariSevenfoldAreOneTypeAndAkalankasCountRoutesAcross` | The Latin-labelled Bhanga enumeration and the Devanagari saptabhangi are one type (causeway built), routing Akalanka's count of exactly seven across |
| `Nasta_TheOneHoleContextAndTheColumnAreRecoveredFromTheirData` | The one-hole context and the valli column are addresses, not just receipts: the dropped object is recovered from the datum (recovery maps with both round trips) |
| `Nasti_ShabdeJivahVartante` | Propositional truncation has no section: the WHICH is destroyed irrecoverably while the THAT survives (syad-nasti as h-level fact) |
| `NastoddistaPariksa_BothDirectionsExistExactlyWhenEveryFibreIsContractible` | Both a nashta and an uddishta exist for a map exactly when every fibre is contractible (isEquiv): Pingala's pair as the discriminant between the corpus's two edge classes |
| `NaturalMachine` | (X ≡ X) ≃ (X ≃ X) as group iso onto Sym(X), ΩFin ≅ Sₙ; the initial (1+X)-algebra is rigid while bare ℕ is not; ℕ ≃ Tally ≃ CanWord with transported addition literally the ripple-carry algorithm; chart symmetries Klein-four, neither descending |
| `NaturalMachine/ADiagonalSentenceIndependentInAConcreteTheory` | A diagonal sentence is independent in a concrete provability theory: both conjuncts proved via two different models (truth-functional and proof-counting) |
| `NaturalMachine/ADisjointValidatorMakesAFlagUnusableAndInvisible` | If validator-accepted and user-intended token lists are disjoint, every intended token is rejected and the defect is invisible to default runs |
| `NaturalMachine/AFigureWithoutItsInputDecidesNothing` | A published count without its input decides nothing: the regression guard recovers only agreement-relative-to-input, formalized |
| `NaturalMachine/AProvabilityDeterminedImplicationForbidsIndependence` | A provability-determined implication forbids independent sentences: sufficiency cannot be built in the valuation-model class |
| `NaturalMachine/ASmallTheoryWithAnIndependentSentence` | A rule-generated derivability with soundness over a class of valuations yields a concrete theory with an independent sentence |
| `NaturalMachine/ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable` | A mechanizable text predicate for a semantic property exists iff the property is decidable of the denotation (Dec equivalence, both directions) |
| `NaturalMachine/ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence` | Any truth-functional interpretation of the provability operator falsifies the diagonal sentence: independence dies in two lines under HBL soundness |
| `NaturalMachine/Abhava` | The negation hierarchy stabilises at three constructively (¬¬¬P ↔ ¬P derivable, ¬¬P → P not), collapsing at two exactly when the counterpositive is decidable — abhava with pratiyogin as type |
| `NaturalMachine/Abhava_MamaAdarsanamNaTasyaAbhavah` | My-not-seeing is not its-absence: the inference from non-apprehension to absence is refuted as a term |
| `NaturalMachine/ActionRefinement` | The product (q, action) is the minimal refinement through which both coordinates descend (universal property of the product in Descends language) |
| `NaturalMachine/ActionResidualCoordinateFibers` | Postcomposition with an equivalence of output coordinates preserves every homotopy fibre proof-relevantly (with a noninjective control) |
| `NaturalMachine/AdaptiveProbeCollapse` | In the bare probe-pool register, every adaptive strategy's kernel EQUALS the static full-pool kernel (adaptivity buys no new distinctions), including seeded randomised strategies |
| `NaturalMachine/AdaptiveResidualAdapter` | Finite response-conditioned experiment trees create no new behavioral quotient: tree-trace equality = word-trace equality, identified with paths in the future-quotient |
| `NaturalMachine/AdvanceGate` | The advance gate implies the test set separates and nonzero useful escape forces a strictly cheaper presentation; δ=0 does not imply advance |
| `NaturalMachine/AnEmptyDependencyRelationMakesCausalDeliveryVacuous` | An empty happens-before relation makes causal delivery vacuous (every order qualifies); one recorded edge already rules orders out |
| `NaturalMachine/Anekanta` | syat-asti and syat-nasti simultaneously inhabited without ⊥; avaktavya is a theorem (no single standpoint carries both); collapsing the naya index is possible exactly when all standpoints agree (plurality-blocks-collapse) |
| `NaturalMachine/AnswerabilityIsFreeAtTheFactoringLaw` | At the factoring law, answerability is a theorem not a hypothesis: a collision alone yields witness number 2 with the decoder supplied internally |
| `NaturalMachine/AnyonyaAbhava` | Mutual absence (non-identity) and relational absence are interderivable classically but NOT constructively: anyonya ⟹ samsarga freely, the converse fails — the Nyaya non-reduction is constructively right |
| `NaturalMachine/ArithmeticPayloadCounterexample` | Interface no-go: the ArithmeticPayloadOver record is inhabited by a semantics that ignores installation — the preservation law never mentions the datum, so every two data induce the same semantics |
| `NaturalMachine/AskingIsNotAPropertyOfTheFunction` | Two presentations of one function (peel ≡ askℕ by funext) differ in whether they ask a decision: asking is a predicate on presentations no invariant of the function reports |
| `NaturalMachine/AtlasResiduals` | The comparison type from ℕ to any (1+X)-algebra is contractible (initiality as contractibility, no h-level hypothesis); Σ[X ∈ BSₙ] LinOrd(X) is contractible (ordinals rigidify what cardinals truncate) |
| `NaturalMachine/AtomicSatisfaction` | Atomic observation is preserved exactly when the response square commutes; a changed response type keeps the biconditional only if its comparison map is injective |
| `NaturalMachine/AvaktavyaDoesNotFactor` | Avaktavya is neither a truth-value gap nor undecidability (it is decidable): it is exactly ¬FactorsThrough — failure to factor through a single utterance, the same shape as the barrier problem |
| `NaturalMachine/BalanceWithoutTransitivity` | A balanced 2+2 quotient attains the exact coherent-overwrite bound even when retained structure forbids every lift of the target swap: fibre balance, not transitive equivariance, is the criterion |
| `NaturalMachine/BarrierIsTwoWitnesses` | The barrier problem's shape is witness number 2: a pair of configurations indistinguishable to all blurred observables with different statistics — proved schematically over abstract Config/Blur/Stat |
| `NaturalMachine/Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain` | Krama ⇒ Vikalpa ⇒ Yugapat with the first step strict (refuted outright) and the second's converse equivalent to weak excluded middle |
| `NaturalMachine/CapabilityGraph` | Cardinality is a lossy projection of the symmetry carrier: a carrier element supplies the checked fork without reconstructing a permutation from the factorial count |
| `NaturalMachine/CatuskotiPerspective` | At a single perspective "both" and "neither" degenerate to ⊥; across perspectives the four corners are consistent (presheaf semantics; the Sanskrit identification later withdrawn) |
| `NaturalMachine/CertificateFibration` | fiber ⟨f,c⟩ (y,e) ≅ fiber (c restricted to fiber f y) e by Σ-eta (both trips refl): a certificate restoring injectivity embeds every fibre into E, and fibrewise embeddings ARE certificates |
| `NaturalMachine/ChuAdvance` | The defect of a Chu space is monotone in the test list (dropping tests only merges points): δ=0 is a statement about the tests, never about the space; a flat base does not imply a flat fibre |
| `NaturalMachine/ChuDefect` | Quantitative Chu defect: δ monotone in the test list, δ on empty tests ≡ 0, and saturation exactly when the tests separate the points |
| `NaturalMachine/ComparisonNeedNotBeInjective` | Injectivity of the comparison map is sufficient but NOT necessary for the satisfaction invariant: a non-injective revised observer with the full biconditional exhibited |
| `NaturalMachine/ConstantBoundNotFunctionBound` | Quantifier promotion made a type: two witness points prove a constant bound sharp among constants but cannot prove "no function improves it" (refuting function exhibited) |
| `NaturalMachine/ControlledGrammar` | An installed theorem applies only where evidence certifies the current term as its source (native control) |
| `NaturalMachine/Controls` | Designed annihilation: canonicity is load-bearing (value not injective without it), the big-endian misreading fails its round trip — refutations machine-checked |
| `NaturalMachine/DecategorifiedDefect` | An invariant detecting a defect in one direction only makes "invariant vanished ⟹ sufficient" unsound: the Euler-characteristic asymmetry in a faithful finite model |
| `NaturalMachine/DeclaredRootProofRelevance` | A proof-relevant declaration family can select different separator data from two declarations of one root; propositional fibres restore root-determined choice |
| `NaturalMachine/DeclaredRootedProfiles` | Rooted profiles with contravariant reindexing preserve identity/composition pointwise; separators transport root by root, never promoted to all roots (Bool control) |
| `NaturalMachine/DefectCalculus` | The structured defect type: a sector break is one failure of Def to be inhabited; `not` is a bare equivalence not carrying the distinguished point (with positive control) |
| `NaturalMachine/DefinitionalExtension` | Definitional extension is judgmental: unfold-and-recheck is refl and conservativity is the theory's construction (the seven-gate apparatus in one δ-reduction) |
| `NaturalMachine/DeflationaryTest` | ¬¬¬A → ¬A holds for EVERY A: the absence tower is two-tall unconditionally, so its stabilisation level measures nothing (Abhava's reading withdrawn; decidability enters only at ¬¬A → A) |
| `NaturalMachine/Descent` | The descent law: f factors through q ⟺ f is constant on q's fibres (target a set, q surjective), and the factorisation is unique |
| `NaturalMachine/DescentObstructionUnified` | Two of three claimed-identical descent obstructions are one lemma (exhibited); the third is a missed-point certificate, provably not interconvertible without extra data |
| `NaturalMachine/DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion` | The false-verdict fibre is exactly the complement of capable (both inclusions plus constancy), upgrading the one-inclusion claim to an equivalence |
| `NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees` | Collapse of a naya-indexed family exists IFF every pair of fibres is equivalent; a third option (neither disagreement nor uniform equivalence, still no collapse) exhibited, correcting Anekanta's exhaustiveness gloss |
| `NaturalMachine/Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld` | Over hProp-valued nayas the collapse prohibition degenerates to logical equivalence: the prohibition has content only off the propositional world |
| `NaturalMachine/EffectiveDescent` | Descent along a genuine surjection of sets with the split hypothesis removed (via the KECA truncation-into-set factorisation) and surjectivity shown necessary |
| `NaturalMachine/EndObstruction` | For every quotation e : Q → (Q → Bool) the diagonal observable is outside the image: δ_end ≢ 0 unconditionally (Lawvere/Cantor, no fuel) |
| `NaturalMachine/EquivalenceHasNoFloor` | An equivalence has no identity beyond its action: equivEq, isPropIsEquiv, funExt chained — the "no floor" claim as checked terms |
| `NaturalMachine/EvaluatorTransport` | Inverse precomposition is the unique evaluator transport conserving every paired result along an equivalence; moving only the candidate can change the score |
| `NaturalMachine/ExclusionInstantiatesAbhavaWithALoadBearingLimitor` | The exclusion instantiates Abhava with observables as limitors: the same pair and counterpositive family hold under one limitor and fail under another |
| `NaturalMachine/FailClosedForgetsOnlyTheReasonForDistrust` | The fail-closed verdict is one-sided: trusting determines the state completely, distrusting determines only "not that" |
| `NaturalMachine/FillabilityCertificate` | The two fillability predicates: finite inductive certificates vs coinductive total branches, their strict separation (A∞), decision procedures consuming finite branching, and the truncation bound |
| `NaturalMachine/FiniteIndraWeave` | (headerless; from code) finite Indra net: TotalView/LocalAction over Root and Jewel types, reweave operation with anchor coherence |
| `NaturalMachine/FiniteInformation` | The finite-information kernel: factorsThrough ⟺ fiberConstant with the decoder CONSTRUCTED via rec→Set (isSet T replacing choice), computation rule refl |
| `NaturalMachine/FitnessIsNecessaryUpToDoubleNegation` | Yogya-anupalabdhi: the fitness condition is necessary only up to double negation, and closing the gap is exactly stability of the searched domain |
| `NaturalMachine/FutureBehavior` | The future-behavior (Myhill–Nerode) quotient as a HIT set quotient: FutureEq is the greatest behavioral congruence, the quotient is the minimal fully abstract machine, with univalent effectivity iso |
| `NaturalMachine/FutureSeparation` | Failure of FutureEq yields a separating word only under double negation; Markov's Principle plus a countable chart removes it |
| `NaturalMachine/GterTwoCoordinate` | The two Gter defect coordinates (separation, composition) are independent: surjectivity onto the 2×2 grid on a finite cut system, all cells decidable/refl |
| `NaturalMachine/HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned` | The converse (transport-invariance implies h-invariance) proved via uaβ, earning the "exactly" the sibling module's title claimed |
| `NaturalMachine/HolonomyIsInvisibleExactlyToAnInvariantSemantics` | Holonomy is invisible exactly to invariant consumers: an h-invariant semantics is unmoved by transport along ua h, while the identity consumer (a cache) is moved wherever h moves a point |
| `NaturalMachine/HypothesesAssumedWhereTheyAreDerivable` | isSet T is derivable from Discrete T at one site (redundant hypothesis found); pointwise stability does not yield Hedberg, so the other site's pair is not redundant |
| `NaturalMachine/IndependenceNeedsAnInternalImplication` | The independence predicate written down: the lane carries all objects except an internal implication — the one missing field named |
| `NaturalMachine/KramaAstiNasti_AnEnumerableRemedySetKillsTheFourthCorner` | An enumerable remedy set kills the fourth corner outright (enumerability of instances was inert; of remedies is not) |
| `NaturalMachine/KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift` | At one instance the fourth corner IS a counterexample to the double-negation shift (Spector/Kreisel DNS): pointwise stability is necessary, not merely sufficient |
| `NaturalMachine/KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet` | Over an enumerable instance family with decidable badness, the fourth corner is refuted (hypothesis discharged, not assumed) |
| `NaturalMachine/KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability` | Under pointwise stability of the badness family, the fourth corner ¬samayika × ¬nitya is refuted |
| `NaturalMachine/KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition` | ¬(A ⊎ B) ⟺ ¬A × ¬B constructively, so the formalism's "simultaneous refusal" collapses to the sequential pair: it cannot express avaktavya at all |
| `NaturalMachine/Lawvere` | Lawvere's fixed-point theorem in three lines with instance table (Cantor, Russell, Tarski; the Godel line corrected by appended audit: only the diagonal lemma is an instance) |
| `NaturalMachine/LeastWindowRadiusEdge` | (headerless; from code) double-negation lift at a boundary implies LEM: the least-window radius edge is a constructive taboo |
| `NaturalMachine/LeastWitnessFactory` | (headerless; from code) least-witness selector from mere existence: leastSelector and its uniqueness, packaged as a canonical polynomial over a signature |
| `NaturalMachine/LocatingIsEnough` | Discreteness of Y weakened to Locates (per-listed-point decidability): the exact hypothesis of the location problem, with the discrete case as corollary |
| `NaturalMachine/Moksha` | Sealed build root of the four jewels (aggregate; the checked closure is the content) |
| `NaturalMachine/MokshaYantra` | A clinging sight holds a knot between reflection-equal jewels; a releasing sight cannot; replacing the sight undoes the knot by transport (thin model, so labelled) |
| `NaturalMachine/NegationCompletenessForbidsIndependence` | Negation-completeness (¬Pf s → Pf ¬s) forbids independent sentences in one line; Wit is negation-complete |
| `NaturalMachine/NisvabhavaNet` | Univalence as no-own-being: jewels with equal reflections are identified, transport dissolves the boundary (identification examined and upheld in the companion note) |
| `NaturalMachine/NonUniquenessAndInexpressibilityAreIndependent` | Non-uniqueness (0÷0) and inexpressibility (avaktavya) are independent over four realised corners: neither implies the other, both can hold at once |
| `NaturalMachine/ObservableHorizon` | A bounded response kernel enters the future-behavior quotient exactly when every action preserves it, whereupon greatest-congruence upgrades bounded to unbounded equality |
| `NaturalMachine/ObservableInterface` | An interface's induced path transports every predicate on observations; it does not identify states whose observations merely agree |
| `NaturalMachine/ObservationPresentation` | Postcomposition by an equivalence preserves the kernel pair and FactorsThrough both ways; a non-injective postprocess destroys descent (control) |
| `NaturalMachine/ObserverRevisionComposition` | Observer revisions compose with defects in the union of stage defects; no function Bool×Bool → Bool reconstructs composite defect flags (three-value control) |
| `NaturalMachine/OneCounterexampleRefutesALabelButNotAnExistential` | A label is a Π-claim refuted by one failed replay; the same failure leaves an existential standing — claim shapes differ in refutation conditions |
| `NaturalMachine/OneLemmaFiveSites` | Five reinventions derived from one collision lemma — with the distinction that two sites are exhaustions over a finite decoder set, not collisions |
| `NaturalMachine/PathIsSymmetry` | (X ≡ X) is the automorphism group of X as a group isomorphism (univalence); bare ℕ has many automorphisms, the (1+X)-algebra ℕ exactly one — the SIP in one line |
| `NaturalMachine/PermanentUnsaidIsStableAndTemporaryIsASearch` | The permanent un-said (a negation) is ¬¬-stable unconditionally; the temporary un-said (a Σ) is stable exactly when decidable |
| `NaturalMachine/PerspectiveCore` | The perspective toolkit: fibrewise-corresponding predicates let equivalences restrict, sector breaks are non-invariance witnesses, conjugation iterates (f^e)^n = e∘f^n∘e⁻¹, fixed points transport |
| `NaturalMachine/PhasePredictorClosure` | Quotient descent for predicted phases: a phase factor reconstructs from a retained carrier iff it descends; two-sign swap is the minimal failure, closed exactly by adjoining the second character |
| `NaturalMachine/PhysicalLearningQuotient` | Equality after compilation is equivalent (proof-level) to equality under every finite action word; the coherent kernel strictly refines the population kernel |
| `NaturalMachine/PinnedSensorForcing` | A uniquely refuted bad world forces its refuter into every sound sensor anatomy (least core, not the whole anatomy); deletion must supply a different refuter per bad world |
| `NaturalMachine/PratityasamutpadaArising` | A knot arises exactly where an observation splits a pair and ceases when the cut factors through (thin model, so labelled) |
| `NaturalMachine/Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries` | A network of validators sees exactly the union of its queries: recognition of sameness is bounded by the query set (pratyabhijna dispute formalized at the interface) |
| `NaturalMachine/PredictorFormation` | A two-reading predictor exists exactly when the third reading descends through the window; the four-state clock refutes it and the three-reading carrier repairs it minimally |
| `NaturalMachine/ProductiveFiberQuotientAdapter` | When Jewel is a set, the productive future-view fibre maps constantly to one quotient point (the set hypothesis load-bearing) |
| `NaturalMachine/ProductiveIndraNet` | One productive layer of local propagation, guarded by the coinductive next field |
| `NaturalMachine/ProductiveObservabilityBridge` | For the linear productive Net, coinductive bisimulation ≃ equality of every future rooted view |
| `NaturalMachine/ProductiveObservationFiber` | The future-view encoder's fibre over a centre ≃ candidates with a bisimulation to the centre (fibre-level composition with funext) |
| `NaturalMachine/ProstheticImageAdapter` | A commuting revision square maps the revised response image into the old image (truncated witnesses mapped directly); an outside response refutes total preservation |
| `NaturalMachine/PunaragamanaMulyam_TheReturnTripIsFreeForEveryAdditiveCost` | c p q + c q p ≡ 0 for every additive cost: the conjugation step's round trip is free before ℕ, +, or Φ are chosen |
| `NaturalMachine/QuotientFiberLaw` | THE one law over arbitrary state space and Boolean queries: blind queries give equal transcripts so no post-processing separates; one charged query constructs a separator — twelve corpus results derived as instances |
| `NaturalMachine/QuotientUnitSourceCutBoundary` | u∘q has exactly q's fibres relabelled: a reversible action on the quotient does not erase physical side-memory; unit environment only from quotient input |
| `NaturalMachine/ReachableActionRefinement` | Total descent restricts to the reachable image; the converse fails constructively when the observation has unreachable codomain values |
| `NaturalMachine/ReflectionAttachment` | (headerless; from code) Reflection records with fibre/total/section spaces: attaching a reflection to a type |
| `NaturalMachine/RepresentabilityIsNotEnoughForIndependence` | The four-sentence countermodel carries a full diagonal (HasDiagonal inhabited), is consistent and HBL1, yet has no independent sentence: representability is not enough |
| `NaturalMachine/RootedGrothendieck` | The Grothendieck total space Σ r. Jewel r with projection, fibre totalization, inverse laws, and two-sided rooted-vs-fibre controls |
| `NaturalMachine/RootedIndraTotal` | The rooted view total space with definitional projection and fibre |
| `NaturalMachine/SamayikaAndNityaAreIndependent` | The two swapped-quantifier positions are independent: both hold, each without the other, and each refutes the other's STRONG failure (the fourth corner has no strong witness) |
| `NaturalMachine/SankramanaSesa_EveryTransportOwesItsResidual` | Transport along ua drops nothing (uaβ); along a non-identification the source is the target paired with its fibre residual; ∥·∥₁ has no section at Bool — copying the unknown does not exist |
| `NaturalMachine/SaptabhangiGarbha_ThePositionsCarryTheirNayasAndTheResidueSeedsTheNext` | The sevenfold with positions as records carrying their standpoints: kramarpana is non-commutative, avaktavya destroys nothing, and the residue seeds the next naya |
| `NaturalMachine/SetBaseNoMonodromy` | If the base is a set, MonodromyOf F b p is uninhabited for every family, point, and loop (p ≡ refl): the parity-monodromy route dissolved for every 0-truncated base in the lane |
| `NaturalMachine/SingletonActionObservability` | Equality under every word of a one-action machine = equality along every iterate, via ℕ ≃ List Unit |
| `NaturalMachine/SingletonStabilizedEquivalence` | Set-valued views make the stabilized bounded kernel and productive bisimulation equivalent as witness types (both propositions) |
| `NaturalMachine/SingletonWitnessStabilization` | One separator in the last insufficient fibre defeats every coarser chart in a nested family: a complete positive certificate of terminal-depth stabilization |
| `NaturalMachine/SiteAudit` | Audit correction: Laghava's observation space (ℕ → ℕ) is neither discrete nor locatable, and two sites quantify over whole-codomain decoders — the ceiling theorem restated for them, simpler |
| `NaturalMachine/StructuredDefect` | The structured defect as an identity type: e upgrades to a structured equivalence iff Def(e) inhabited; descent iff kernel-pair coequalization; refutations transport and pull back |
| `NaturalMachine/TerminalTraceCompression` | A deterministic history carries no more quotient information than a terminal record exactly when each observation factors through the other on its realized image (Isos of carriers, kernels, fibres, witnesses) |
| `NaturalMachine/TheAbsenceTowerIsThreeUnconditionally` | ¬¬¬A ≃ ¬A for every type with no hypothesis: the tower is at most three tall, and collapse to two is EXACTLY stability (decidability was only sufficient) |
| `NaturalMachine/TheAnuyogitaAvacchedakaIsADistinctSlot` | An absence carries TWO limitors (of counterpositive and of locus), neither derivable from the other; the one-limitor presentation provably loses absences |
| `NaturalMachine/TheCeilingIsAboutReading` | The witness ceiling returns exactly for probe-reading decoders with discrete probe target: which decoder spaces get the ceiling, with Laghava's as the boundary case |
| `NaturalMachine/TheDeflationaryTestIsVacuous` | Every proved statement is stable (A → Stable A) and every negation is stable, so the deflationary test's middle clause holds for everything asserted with no survey and no decidability |
| `NaturalMachine/TheDeflationaryTestWasAlreadyRun` | The thread's closure lemmas are refl-equal to DeflationaryTest's prior terms: the rediscovery made checked |
| `NaturalMachine/TheDelimitorNeedsOnlyStability` | Stable (Collision q t) suffices where Dec was assumed; Dec holds at two-point sites by finite exhaustion — the delimitor needs only stability |
| `NaturalMachine/TheDiagonalLemmaDischargesGoedelFix` | Representability written down (HasDiagonal: one-place formulas, application, fixed point) and GoedelFix discharged from it |
| `NaturalMachine/TheDomainThatIsAnAbsence` | A → isContr(¬A → Y) and ¬A → ((¬A → Y) ≃ Y); ¬¬Dec A holds for every A and ¬(A × ¬A): the shadow's codomain is settled only by settling A, and two of the four naive positions are refuted outright |
| `NaturalMachine/TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty` | The empty list refutes exactly when the decoder space is empty (¬D): the unchecked length-0 case of the witness-number measure, both directions |
| `NaturalMachine/TheFloorIsAnswerability` | The witness floor's hidden hypothesis is Answerability (every point answered by some decoder): drop it and witness number 1 is realised; the ceiling/floor pair exhausts the cases |
| `NaturalMachine/TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms` | All six pairs of the four descent verdicts decided: four exclusive, two compatible — the verdict type is not a partition, and that is its epistemic content |
| `NaturalMachine/TheInternalRulesPreserveIndependenceInThisCalculus` | Contraposition, double-negation elimination and transitivity are all sound in both models: independence survives all three (prediction refuted, reported as found) |
| `NaturalMachine/TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness` | The least refuting list is not unique (the reversed pair also refutes): the witness measure is a number, not a canonical witness |
| `NaturalMachine/TheOmegaInconsistentExtensionDerivesTheNegation` | Adding the axiom pv gs yields an ω-inconsistent but consistent calculus that DERIVES ng gs: independence refuted outright once double-negation introduction is present |
| `NaturalMachine/TheRefutingModelAlreadyGivesTheFirstConjunct` | The syntax-indexed model route to Godel also closes, by a different obstruction: the refuting model already forces the first conjunct |
| `NaturalMachine/TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired` | The seed's question as phrased is satisfied by a lookup table: a decidable separator exists for ANY disjoint finite lists, so exhibiting one is evidence of nothing until generalisation is demanded |
| `NaturalMachine/TheTextPredicateIsUniqueSoExistsCarriesNoChoice` | Any two correct Bool text-predicates agree everywhere (Bool rigidity), so the untruncated Σ equals the truncated claim: exists carries no choice |
| `NaturalMachine/TheTwoCollisionsAreOneInstantiation` | The two collisions (laghava, anuvrtti) already derived in prior art; a second route through anyonya→samsarga recorded, with the grep lesson (search statements, not names) |
| `NaturalMachine/TheTwoDirectionsUpgradeToAnEquivalenceBecauseBothSidesArePropositions` | The rate-one biconditional upgrades to a genuine identity of propositions because both sides are propositions (h-level, not induction) |
| `NaturalMachine/TheTwoFinCarriersAreEqual` | The two library Fin carriers are EQUAL as types in v0.5, and the symmetric groups over them equal as groups (the skew removable by transport, not by picking a side) |
| `NaturalMachine/TheUniformFormIsNotRefuted` | Of three barrier forms only the parameter-uniform one survives: non-existence of an algorithm uniform in a parameter is expressible and not refuted by the stability results |
| `NaturalMachine/TheUnstableGroundCannotBeExhibited` | The separating pair (co-excluding, not co-identifying) needs unstable ground, and no such ground can be exhibited: the gap closes on the second branch |
| `NaturalMachine/TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal` | A scoped factorization becomes global exactly when the scope is inhabited EVERYWHERE (totality, not sample size) |
| `NaturalMachine/TranscriptDescent` | The transcript predicate IS the descent law: the compositional criterion identified with FiberConstant, giving an executable decoder on reachable terminal observations (home of collisionObstructsDecoder) |
| `NaturalMachine/Transport` | transport-+-is-⊕: transporting ℕ's addition along ua is literally schoolbook ripple-carry, and the two monoids are EQUAL by SIP (laws inherited, not re-proved) |
| `NaturalMachine/TransportMul` | Multiplication survives the transport: ℕ's · transported along ua IS native shift-and-add ⊗ — the chart carries the whole semiring |
| `NaturalMachine/TransportPrice` | Every additive transport cost is the difference of a potential (cocycle→coboundary): no path-dependence, no holonomy, loop-is-free |
| `NaturalMachine/TransportPrice_AgreementDoesNotDetermineTheTransport` | Over hProp-valued nayas the transport is unique (nothing to choose); off them agreement does not determine the correspondence — the price that survives is the choice |
| `NaturalMachine/TwoProfilesSuffice` | One profile never refutes the sevenfold language, but TWO do (complementary agreement sets): avaktavya-does-not-factor from two witnesses instead of six cases |
| `NaturalMachine/TwoTruthsCompute` | uaβ as the two truths: transport along ua e reduces to equivFun e — the ultimate reached only by running the conventional, as a kernel reduction |
| `NaturalMachine/UnivalenceErasesTheAlgorithm` | ua identifies Pingala's, Virahanka's and the walk's enumerations as EQUAL types (Vak 1 ≡ Metre 2) — and erases the three algorithms: transport keeps the equivalence, not the computation |
| `NaturalMachine/Vacuity` | Vacuity verdicts as witness-carrying types; a claim vacuous at every apart-pair is precisely one whose invariant descends — "carries no information" = "factors through the quotient" |
| `NaturalMachine/VacuityIsExactlyEmptinessAndTheEquivalenceCostsAUniverseLift` | The biimplication published: every order respects hb iff hb is empty (the stronger converse was free from the module's own instance), with the equivalence costing a universe lift |
| `NaturalMachine/VacuityVerdict` | The four verdicts as four types (scoped collision, global factorization, local+ambient collision, undecided-with-resolver): a larger finite sample never constructs GlobalFactorization |
| `NaturalMachine/WhatTheSubstrateArgumentCovers` | "Every inhabited type is a decision" is about inhabitation, not sums (A → Dec A); it delivers strictly more than stability, and the two deflations have different ranges |
| `NaturalMachine/WhereTheTowerCanStillBeThree` | Stability is closed under Π pointwise; FiberConstant is stable when target paths are; FactorsThrough is stable with isSet T — the tower over the central affirmation is two tall under the hypothesis already charged |
| `NaturalMachine/WhyTheSamePriceKeepsAppearing` | The stable types are closed under ¬, →, Π, × and NOT under Σ or ⊎ (no component from ¬¬Σ): predicting where Dec hypotheses are genuinely needed by reading conclusions |
| `NaturalMachine/WhyTheSitesAreTwo` | Over an unconstrained decoder space with discrete Y, a list refutes only by containing a collision: every witness number in the corpus is 2 for a reason about decoder spaces |
| `NaturalMachine/WitSatisfiesEveryHypothesisButOmegaConsistency` | Wit satisfies consistency, HBL1, representability and the three internal rules, and fails independence: ω-consistency is the single load-bearing hypothesis, witnessed |
| `NaturalMachine/WitnessDichotomy` | Answerability is a gate, not an axis: one unanswerable point refutes alone (number 1); answerable+readable gives 2; answerable-not-readable admits 3 and ∞ — a chain, not a square |
| `NaturalMachine/WitnessNumberCanBeInfinite` | The diagonal law's refuting lists are exactly those containing every point, so over ℕ no finite list refutes: witness number infinite, characterised not bounded |
| `NaturalMachine/WitnessNumberIsInvariant` | The witness number is a univalent invariant: preserved by every reindexing of the decoder space, reflected by surjective ones — depending only on the image |
| `NaturalMachine/WitnessNumberIsThePotential` | The witness number is a potential for the transport price: invariant under surjective reindexing in both directions (transport price identically zero) |
| `NaturalMachine/WitnessNumberIsTwo` | One point never refutes a FactorsThrough obstruction (constant decoder), and a collision is exactly a refuting pair: witness number is exactly 2 at every collision site, including the six-atom avaktavya site |
| `NaturalMachine/WitnessNumberIsUnbounded` | Witness number 3 is realised: there is no general ceiling, so the corpus-wide 2 is a fact about the corpus's decoder spaces |
| `NaturalMachine/YantraTantu_TheEngineLivesInTheFibreOfItsDenotation` | The rewriting engine lives in the bahu fibre of its denotation map (rules move inside one fibre; size is a function on the fibre invisible to the base); an empty fibre exhibited where only symbol-invention reaches |
| `NaturalMachine/Yugapat_TheRefusalOfJointAssertionDoesNotDecompose` | The De Morgan asymmetry: ¬(A ⊎ B) decomposes but ¬(A × B) does not — the refusal of joint assertion is a genuine yugapat position no product of refusals expresses |
| `Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere` | Every set-valued observable annihilates every loop (cong F p ≡ refl) while the loop is not refl: a nonzero charged sector on which every set-valued standpoint has expectation zero; the only escape is a non-set-valued observable; antisymmetry is free on identification graphs |
| `Nirnaya_TheVerdictCannotDropItsWitness` | The six-position verdict type where every verdict carries what makes it a verdict (derivation, separating assignment, searched domain, failed unification, silencing symbol, or the residue seeding the next naya); a bare label is a truncation with no section |
| `ObligatioOrderTrilemma` | (headerless; from code) Boolean obligation algebra: and-projections, commutation (x∧a)∧b ≡ (x∧b)∧a, toward an order trilemma on obligatio states |
| `Parampara_TheChainOfThreeIsPricedAndTheLossesDoNotAddBecauseAnAbsenceSitsInTheMiddleFibre` | A chain of three maps priced: the losses do not add because an absence sits in the middle fibre (fibre counting via Fin-inj) |
| `Paryaya_ElevenOfTheFourteenLoopsMoveAPointOneIsTheIdentityAndTwoDependOnTheParameter` | Census of the corpus's fourteen A ≃ A identifications: eleven move a point, one is the identity, two depend on the parameter — the charged sector decided element by element |
| `Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness` | A SET-valued observable that sees the loop exists (the holonomy): "truncating to a set is the whole of the blindness" is false — the blindness needs non-dependence too |
| `Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification` | Receipt vs address: carrying a derived datum is unconditional (contractible singl); recovering the base needs the map to be an identification — Pingala's matra as counterexample, uddishta as address |
| `PraksepaTantu_TheFibreOfAProjectionIsTheDiscardedFactor` | fiber fst a ≃ B and fiber snd b ≃ A, for arbitrary types: the projection's fibre is exactly the discarded factor (the enzyme for every fst/snd edge) |
| `PramanaSankramana_ProofOfTransportIsTheReceiptThatComposesWithoutBeingSpentAndOwesNoCounterparty` | A proven equivalence as non-rival wealth: receipts compose into edges neither party held, are not spent by use, and cost nothing to cross twice |
| `PratibimbaSanghata_CostComposesMonotonicallyExactlyOnTheImageWhichIsWhatTypingTheDecoderOnItBuys` | Cost composes monotonically exactly on the image: the section whose absence kills composition IS the image condition — the two FactorsThrough definitions are the boundary of a composable cost model |
| `Pratibimba_TheRootedFiberOverAJewelIsItsLocalDatumWithAllItsReflections` | Composing T25.B (fiber unroot x ≃ Net x) with T25.D (Net x ≃ L x × ∀y Net y) identifies the rooted fibre over a jewel with its local datum times all views — HoTT 4.8.1 joined to the guarded Indra equation |
| `PravesaTantu_TheInjectionsFibreIsContractibleOnItsImageAndEmptyOffItSoItIsReceiptAndWall` | fiber inl (inl a) ≃ Unit and fiber inl (inr b) ≃ ⊥: an injection is all receipt and all wall — lossless on its image, disjoint off it |
| `ProjectionChargeAudit` | Local coordinate plus total charge is an equivalence on Bool × Bool; a charge separating quotient-identified points cannot descend |
| `ProjectionChargeAudit2` | The descent criterion: Descends ≃ Respects (equivalence of propositions — descent is property, never structure), with both instances re-derived as corollaries |
| `PunaragamanaVartula_TheDatumRidesTheLoopFreeExactlyWhenTheConsumerIsInvariant` | The carried datum rides a holonomy loop free exactly when the consumer is invariant (biconditional, refl-cheap), with Bool/not exhibiting the failure |
| `Punaragamanam_ReturnIsOnlyAtZeroCostAndALossyEdgeHasSectionsButNoWayBack` | Bool → Unit has a right inverse but no left inverse: out-and-back in the codomain is always available, out-and-back in the DOMAIN exactly at zero loss |
| `Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt` | (ℕ×ℕ) ≡ viveka-pramana falls out of the contractible-fibre Carrier law: the hand-built equivalence identified with the free one, everything refl |
| `Punaragamanam_TheStepIsAConjugationAndNothingIsTouchedByIt` | The machine's step is a conjugation descent∘Φ∘ascent through an equivalence, so the infinite run is one transport and no fibre collapses (both spec equations refl) |
| `Punarukti_TwoOfTheThreeSevenfoldsAreOneTypeAndTheThirdIsADifferentQuestion` | Two of the three saptabhangi types are identified (a causeway); the third (witness-carrying family) is proved a DIFFERENT question, not one type |
| `Sakaladesa_NoSingleUtteranceDenotesTheTotalStatementAndTheContentNonethelessFolds` | No single utterance denotes the total statement, yet its content folds: the sakaladesa obstruction as a factorisation failure with the folding supplied |
| `SamasaSetu_TheChildEdgeIsTheCompositionOfTwoParentFordsSexualNotAsexual` | Two parent fords recombined at a shared node breed a child equivalence neither stated: viveka-pramana ≃ Σ n fiber yoga n |
| `Samkramana_AnEdgeCarriesEveryPredicateAndEdgesComposeSoTheRouteIsFree` | A landed equivalence carries EVERY predicate with no hypothesis, edges compose and invert: the four library facts (subst, ua, compEquiv, invEquiv) ARE the transport economy |
| `Samkramana_TransportCarriesStructureAndTruncationIsTransportExactlyWhenNothingWasThereToLose` | Transport carries structure and nothing perishes; truncation is a transport exactly when nothing was there to lose (the sutra's claim proved rather than defined) |
| `Samyoge_LosslessnessComposesButLossinessDoesNotSoNoPipelineGradesByItsSteps` | Losslessness composes, lossiness does not: Unit→Bool→Unit composes two defective maps to the identity — no grading function on maps both respects composition and detects loss |
| `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibreCriterionFailsOnItsOwnArchetype` | The loss-level is not a property of the map alone: the proposed fibre-size criterion fails on its own archetype (context-relative, sapeksha) |
| `Saptabhangi` | The sevenfold from two seeds and two modes: syat-asti-nasti ≢ syat-avaktavyam (simultaneity is not sequential bothness), and any two-valued verdict identifies two of the three seeds (durnaya as pigeonhole) |
| `SaptabhangiNaya` | The sevenfold as a checked type with the krama/saha distinction and no-single-vacana proved exhaustively over the six utterances |
| `SaptabhangiSamyoga_TheCompositionOfVerdicts` | Verdict algebra: succession composes associatively (semilattice), avaktavya is NOT reachable by succession, simultaneity is NOT associative, and asti/nasti have no meet (the would-be meet is the empty eighth profile) |
| `Satyayantra` | The honest machine interface: soundness, stability, completeness — answer or un-said, never a false verdict; the kuttaka's gcd solver as first inhabitant |
| `SatyayantraSamyoga` | Honest machines compose (relational composition carrying both witnesses, grants aligned by stability): the interface is category-like |
| `Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd` | fibre (g∘f) z ≃ Σ (p : fibre g z) fibre f (fst p): the composite's remainder is the second summed over the first — rank–nullity's "alignment obstruction" is this fibration additivity |
| `Sesa_TheOneWayFunctionIsExactlyANonEquivalenceAndCryptoLivesInTheResidualUnivalenceCannotErase` | A one-way function is exactly a non-equivalence: binding the output is free for every f (isContrSingl), binding the input is free iff isEquiv — cryptography as the deliberate use of a map outside ua's image |
| `SetTruncationDescentBoundary` | The type of set-level descent data for id_A IS the proposition isSet A: the boundary is the h-level, not the C₃ example (the Python replay replaced by the theorem) |
| `Setu` | The honest machine occupies the sevenfold-sanctioned pair {asti, avaktavya}, never asserting nasti: honesty as the durnaya-free fragment |
| `SetuPramana_TheAmbiguousNameHidTheFordAndTheRemainderLawIsAlsoTheNaturals` | viveka-pramana ≡ ℕ by composing two landed fords: the largest component merge on the board (+91 crossings) |
| `Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap` | Carrier yoga and Σ n fiber yoga n both decompose ℕ × ℕ: the return and the cut are one object, the machine-named gap closed by transport |
| `StagewiseComposite` | Stagewise defects determine the composite defect iff R has at most two values: xor works on Bool (eight cases), fails at three values, and the full iff is closed |
| `StagewiseCompositeB` | The relativised theorem: determination on realized spans T holds iff the cancellation cell is unrealized (with the one Dec hypothesis named), recovering Theorem A at T = R³ |
| `Tala_TheFloorIsTheThirdAssetEveryRouteFromSevenToTwoPaysAtLeastOneCollision` | The floor: EVERY map from the sevenfold to Bool collides on an exhibited pair (no injection, not just no equivalence) — the third asset class between fords and walls |
| `Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem` | The fibre's three verdicts (empty/contractible/crowded) decided by which side of f a ≡ b is bound: bind b and it is always singl (free); bind a and it is fiber (any of three); a Bool verdict provably merges two |
| `Tantusandhi_TheFourWrittenFibresWereAlreadyTheQueuesOwnMapsAndTwoEdgesTheCensusNeverSaw` | Four written fibres refl-identified with the census's own maps (Fib n ≡ fiber value n etc.), with the method's false-positive rate reported (six of eleven leads died) |
| `Tantutrayam_ThreeMapsIntoOneCodomainExhibitTheThreeVerdictsAndTwoLossyEdgesComposeLosslessly` | Three maps into Unit exhibiting the three fibre verdicts, and Unit→Bool→Unit composing two lossy edges losslessly: the image dodges the collapse (Knill–Laflamme at minimum scale) |
| `TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple` | Passing from ¬(∀b contractible) to Σ b ¬contractible costs exactly Markov's principle at the right class — the written defect's price named, not estimated |
| `Trivarna_TheTwoThreeLetterAlphabetsAreOneType` | Two privately defined three-point types identified by an explicit bijection (six refl round-trip cases): the isolated nodes were one type |
| `Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart` | The quotient-fiber law's negative half survives with Bool replaced by any answer type under any irreflexive apartness: two-valuedness was never needed |
| `Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal` | The section space of an equivalence is contractible (no choice); Bool → Unit has two distinct sections with nothing deciding between them — symmetry breaking at the smallest scale |
| `Vikalpa_TheFibreOfATwofoldMapIsTheTwofoldOfItsFibresAndSoTheCountsAdd` | fiber (rec f g) c ≃ fiber f c ⊎ fiber g c, round trips refl: the case-map's fibre is the case of the fibres — the abstract law behind every laghu/guru split |
| `Vilopa_TheAnnihilationIsExactlyAFailureOfChoiceOverTheOuterFibre` | isContr(Σ B P) → ¬isContr B → ¬((b:B) → P b): the cost annihilation is exactly a failure of choice — a section is what makes composite cost the outer cost |
| `VivekaPramana_TheRemainderIsLawfulAndTheNetBeats` | viveka-pramana with the law dakshina ≡ sama + vama IS the graph of +: ℕ×ℕ ≡ viveka-pramana contentfully, with the field paying its own coherence |
| `VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal` | The defeating condition carried as a field: descent/ascent are mutually inverse exactly on the pramana subtype, making the equivalence real (upadhi made structural) |
| `VivekaSetu_TheTwoRemainderRecordsAreOnePairAndThereforeEachOther` | The two viveka-pramana records identified through their shared ℕ×ℕ paths (composition of two univalence bridges) |
| `VivekaTadatmya_TheSumTypeDescentAndTheGraphOfPlusAreOneObject` | viveka ≡ ℕ×ℕ ≡ viveka-pramana: the sum-type descent record and the graph of plus are one object |
| `Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence` | From "the round trip is absent" the machine inferred "the equivalence is absent" — a vyatireka pervasion that does not hold, refuted (with sixteen of 39 proposals already identified by their hosts) |
| `Yamaja_TheThirdTesterWasFoundByCensusAndTheChannelPaysReflexivityAndCompleteness` | A third eqℕ found by the kernel-elaborated-type census; the channel pays it reflexivity and completeness in both directions |

## Order theory (61)

| Module | Main result |
|---|---|
| `ExtremalDescription` | ForeverEq is the greatest safe quotient (maximality proved, unique); certifying oracle-bit sets are exactly supersets of the cut — but min-cut equality fails |
| `ModeAdjointFinitenessBoundary` | Every proof-relevant order adjunction gives an admissible transfer; the converse fails in the infinite case (constant TOP on (ℕ,max,0) is admissible with no left adjoint) |
| `NaturalMachine/ANonEmptyArchiveHasANonEmptyStratum` | Every non-empty archive has a Pareto-maximal member (list induction with per-step decision, needing transitivity of strict domination), so the computed stratum is non-empty |
| `NaturalMachine/AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision` | The pointwise order on fitness vectors is a genuine partial order that is not total; any monotone scalarisation strictly extends it, deciding pairs the objectives leave incomparable |
| `NaturalMachine/ArityOfRepair` | A tight bilateral certificate determines the magnitude; unary repair certificates cannot certify quantitative defects (the impossibility is visible in the operator's signature) |
| `NaturalMachine/AscendingFirstIsTheWorstUnlessTheArchiveIsConstant` | "First of ascending" and "best" coincide only on a constant archive, exactly where selection carries no information (dichotomy proved) |
| `NaturalMachine/AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo` | Asymmetry of the strict rate order is free (irreflexivity + transitivity); the weak claim is antitone along the strict order (lifted by elimProp2) |
| `NaturalMachine/CertifiedRewritesFormASemicategoryAndOnlyTheCostComponentNeedsAnHLevel` | Certified rewrites form a semicategory: composition is associative, with the four certificate components paying four different prices (only cost needs an h-level) |
| `NaturalMachine/EveryRemainderMemberIsBeatenByAStratumMember` | Every remainder member is strictly dominated by a member of the STRATUM (maximalExists applied to the dominators sublist; no well-founded induction needed) |
| `NaturalMachine/EveryRemainderMemberIsStrictlyDominated` | Every member of the Pareto remainder is strictly dominated by an archive member (double negation resolved by decidability) |
| `NaturalMachine/EveryThresholdHasABoundaryPopulationOfItsOwnDenominator` | For p ≤ q+1 the population of p trues and q+1−p falses realizes p·length ≡ (q+1)·count exactly: every threshold has a non-vacuous boundary population |
| `NaturalMachine/ExcludingPerfectScorersRemovesOnlyGainlessCandidates` | An agent at the score cap admits no strictly better agent, so the eligibility exclusion removes only gainless candidates; the seam is invisible exactly when nobody is perfect |
| `NaturalMachine/ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll` | Disjointness of Pareto strata is already fuel-quantified (nothing to transport); coverage needs exhaustion, safety needs no fuel — the asymmetry read off the signatures |
| `NaturalMachine/FlippingACostCoordinateIsSoundButNotFaithful` | Mixed (benefit/cost) dominance implies product dominance of capped-flipped vectors, but the converse fails: two costs above the cap flip to the same 0 |
| `NaturalMachine/LinearOrderFinite` | LinOrd′ X ≃ (X ≃ Fin n) for merely-finite X: genuine linear orders rigidify — with decidability DERIVED from mere totality plus discrete equality, not assumed |
| `NaturalMachine/MajorityLiesStrictlyBetweenAllAndSome` | Majority (2·count > length) lies strictly between the universal and existential claims: two witness populations separate the three thresholds |
| `NaturalMachine/MinPlusResiduationIsAGaloisConnectionAtOneCut` | The monus adjunction K∸ψ ≤ φ ⟺ K ≤ φ+ψ makes min-plus residuation a Galois connection under the REVERSED order (naive order refuted by truncation witness); idempotence and fixed points follow free |
| `NaturalMachine/OneStepCoverageAndDisjointnessOfTheLayer` | A decidable filter and its complement partition the archive at one step: coverage and disjointness of the Pareto layer |
| `NaturalMachine/ParetoCost` | Two routes incomparable in the product order; two monotone scalarizations select opposite routes — scalarization is policy, not mathematics |
| `NaturalMachine/RateOneIsExactlyTheUniversalClaim` | count xs ≡ length xs and All isTrue xs are the same claim: the label criterion is the threshold at rate 1 with zero tolerance |
| `NaturalMachine/RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase` | Per-coordinate caps: soundness independent of the bound, faithfulness below the caps, with the single cap as the constant special case |
| `NaturalMachine/RnaDhana_TheCostFlipIsFaithfulBelowTheCap` | Below the cap the cost flip reflects the order (c∸x ≤ c∸y → y ≤ x): mixed and product dominance agree, with the bound needed only on the dominating vector |
| `NaturalMachine/RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder` | Mixed layer covers, is disjoint, stays bounded, and every mixed-remainder member is strictly beaten in the mixed order (only order needs the transport) |
| `NaturalMachine/RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered` | The mixed strata are pairwise disjoint (generic list surgery) and ordered (needing the whole rna-dhana transport plus caps), for every fuel |
| `NaturalMachine/RnaDhana_TheMixedStratificationTerminatesAndCovers` | A non-empty bounded archive has a non-empty mixed layer, the remainder strictly shortens, and the mixed stratification terminates and covers at fuel = length |
| `NaturalMachine/RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum` | map flip (mixedStratum ds vs) ≡ stratum (map flip vs): the mixed layer IS the flipped layer as a list equality; mixed maximality ⟺ flipped Pareto maximality under caps |
| `NaturalMachine/RnaDhana_TheParetoMaximumTransfersToCostCoordinates` | Every non-empty archive of mixed benefit/cost vectors has a mixed-maximal member (under caps), by calling maximalExists on the flipped archive |
| `NaturalMachine/RnaDhana_TheStrongerFormIsUpstreamOfTheFlipAndOnlyItsImageWasPublished` | The stronger upstream equality (mixed layer = flipped-test sublist of vs) was proved inside and discarded; the published image is strictly weaker since flip is not injective |
| `NaturalMachine/RnaDhana_TheWholeMixedStratificationIsTheFlippedOne` | map (map flip) (mixedStrata n ds vs) ≡ strata n (map flip vs) for every fuel: the whole mixed stratification is the flipped one |
| `NaturalMachine/Samacchheda_TheUntruncatedTrichotomyOnTheRate` | Untruncated trichotomy on rates via common denominators: exclusivity + generic isPropSum strips the truncation (the expensive object was the nine-case match, measured) |
| `NaturalMachine/SaturationAtACutIsIdempotent` | The polarity closure of an arbitrary relation is idempotent (Birkhoff polarities): re-saturation terminates in one application |
| `NaturalMachine/TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms` | The adjunction and unit/counit presentations of a Galois connection are interderivable, needing different axiom subsets |
| `NaturalMachine/TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert` | Over-fuelling is inert: any two sufficient fuels give the same stratification, so lengthL xs is canonical |
| `NaturalMachine/TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections` | AtLeast is exactly Above-or-boundary (ℕ ≤-split): the strict and non-strict families agree off the boundary, in both directions |
| `NaturalMachine/TheImpossibilityNeedsNeitherHPropNorEveryRepresentative` | The minimality-cannot-live-on-the-quotient impossibility restated for arbitrary Type-valued predicates (the hProp narrowing removed) |
| `NaturalMachine/TheMediantDoesNotDescendToTheRate` | The mediant does NOT descend to the rate quotient ((1,1) ≈ (2,3) but the mediants differ: 2/5 ≠ 3/7): no canonical between-rate from truncated existence |
| `NaturalMachine/TheMeetIsMaxAndTheProfileCutIsAGaloisConnection` | The profile cut is a Galois connection with the meet being MAX (a meet in the reversed order is a join): profiles as a recursive family so length mismatch is unrepresentable |
| `NaturalMachine/TheParetoStratumIsDecidableAndTheFilterIsExact` | The product order is decidable, hence Pareto maximality against a finite archive; the computed stratum filter is sound and complete |
| `NaturalMachine/TheRateQuotientExistsAndMinimalityCannotLiveOnIt` | Rate = (ℕ×ℕ)/≈ formed; AtLeast/Above lift; and NO function on Rate agrees with Minimal on all representatives (impossibility, via a path in the quotient) |
| `NaturalMachine/TheRatesAreDenseAndTheMediantSurvivesTheQuotient` | ⊏ respects ≈ on both sides and lifts to Rate; the rates are dense — with the mediant never having to descend (mere existence eliminates into a proposition) |
| `NaturalMachine/TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure` | filterDec/filterOut partition the archive (lengths sum), so a non-empty stratum makes the remainder strictly shorter: the decreasing measure for stratification |
| `NaturalMachine/TheSaturationClosureNeedsOnlyAGaloisConnection` | The whole saturation-closure argument needs only two preorders and a contravariant Galois connection: antitonicity, unit, counit, triangles, idempotence all derived |
| `NaturalMachine/TheScoreOrderAndTheWeightOrderDisagree` | The DGM parent weight f(α)/(1+n) checked by cross-multiplication in ℕ: score order and weight order provably disagree (shape property, no reals) |
| `NaturalMachine/TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections` | The converse direction supplied: eligibility keeps every member iff no agent attains the cap — the theorem-level "exactly" now earned |
| `NaturalMachine/TheSharedPreambleIsACommonPrefixNotACommonSet` | The longest common prefix is the greatest common prefix (a meet); the common SET is not a preamble at all (shared declarations with empty common prefix exhibited) |
| `NaturalMachine/TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma` | Every member of a later stratum is strictly dominated by a member of an earlier one: strataSound composed with the one-step theorem, no new lemma |
| `NaturalMachine/TheStratificationCoversAndItsStrataArePairwiseDisjoint` | The stratification covers at fuel = length (leftover empty by termination) and its strata are pairwise disjoint at every fuel — coverage needs the measure, disjointness does not |
| `NaturalMachine/TheStratificationTerminatesOnItsOwnLength` | The fuelled stratification exhausts the archive at fuel = its own length (one induction on the decreasing measure) |
| `NaturalMachine/TheStratumRankExistsAndDominationStrictlyLowersIt` | The stratum rank exists (fuel-recursive) and strict domination strictly lowers it, given fuel ≥ archive length |
| `NaturalMachine/TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt` | ⊏R on Rate is irreflexive and transitive, and the claim family is antitone along it: the threshold apparatus at the level where 2/4 and 1/2 are one object |
| `NaturalMachine/TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary` | The strict family is antitone along the SAME chain (one order, no second totality); strict ⇒ non-strict, Majority IS Above 1 1, and the gap is exactly the on-threshold population |
| `NaturalMachine/TheThresholdChainIsDenseAndTheMediantWitnessesIt` | The threshold chain is dense with the mediant as witness: both betweenness halves reduce to the assumed inequality (Farey/Stern–Brocot, checked) |
| `NaturalMachine/TheThresholdOrderIsTotalAndTheClaimIsAntitone` | The threshold order p·(q'+1) ≤ p'·(q+1) is total and the rate claim is antitone along it (the family stated, not populations exhibited) |
| `NaturalMachine/TheTwoSidedCutExistsOverANonEmptyResidualIndex` | The two-sided profile cut exists over a non-empty residual index: right adjoint by componentwise max over rows, both Galois halves proved |
| `NaturalMachine/TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero` | The empty meet is ZERO, not ∞ (⊑p-greatest is ≤-least): the two-sided cut needs no infinity — the sign error caught by building the wrong object |
| `NaturalMachine/TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` | The burdens taken as a profile: upV/dnV still a Galois connection, with componentwise max and the matrix form UpP locating the remaining obstruction |
| `NaturalMachine/TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation` | Trichotomy computes on pairs; the lift to Rate costs a truncation (no decision procedure) — with the missing piece named exactly |
| `NaturalMachine/WhichThresholdStatementsDescendToTheRate` | ⊑-trans proved (the "preorder" now earned); AtLeast and Above descend to the rate, minimality does not — both sides of the separation |
| `PolarityClosure` | The Birkhoff polarity of an arbitrary relation: both maps antitone, Galois connection, closure extensive/monotone/idempotent — unconditionally; the boolean apoha gloss is vacuous on P(X) |
| `ThresholdGenerationDichotomy` | Every unary ACUI-polynomial on a meet-semilattice is a clamp or a constant; the four-chain map ψ is admissible, not a polynomial, not a threshold, but IS a meet of two thresholds — the vocabulary must be a generating family |
| `ThresholdGenerationN5Boundary` | On the pentagon N5 the identity is admissible but not a finite pointwise meet of thresholds: the generation fails off distributivity |

## Physics and quantum mechanics (53)

| Module | Main result |
|---|---|
| `Apratiloma_TheConservingFlowsAreAMonoidNotAGroupSoNoethersFirstTheoremDoesNotTransfer` | Conserving flows of an observation form a monoid, not a group; the sections-of-fibre equivalence holds but Noether's first theorem does not transfer (no dynamics, no variational structure, no inverses) |
| `Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap` | Near-law: the quotient-fiber barrier argument needs equality of transcripts and dies under ε-agreement; the barrier proposition does not split as proposed |
| `Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry` | f∘Φ ≡ f iff Φ maps every fibre into itself; if f is an equivalence, conservation forces Φ = id (no loss, no symmetry) — Noether's structural half |
| `Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep` | The conserved charge is constant along the whole forward orbit (induction from the one-step law): f(Φⁿ a) ≡ f a for all n |
| `NaturalMachine/AbstractSpinNetworkKinematics` | Spin-network kinematics over any group action: edge labels as actions, bivalent vertices as intertwiners, identity-vertex insertion preserves evaluation, two-edge holonomy = sequential transport |
| `NaturalMachine/ActionResidualPhase` | The sign character trivialises the injective residual 2x: a strict classical refinement compiles to the identity phase (algebraic, no Hilbert space) |
| `NaturalMachine/CoherentSurvivalDephasing` | Every diagonal history cost factors through dephasing; two phase states share a diagonal so no diagonal cost distinguishes them, while an off-diagonal port does |
| `NaturalMachine/CompressionDefect` | T18.4 over any ring: K_t K_s − K_{t+s} = −P T_t Q T_s i — the excursion–return defect of projected dynamics, by hand in a noncommutative ring |
| `NaturalMachine/CompressionDefectRegularWitness` | A nonzero defect element acquires an inhabited witness type via the regular action on 1r (specialization, not the general witness direction) |
| `NaturalMachine/ConstructiveBornNormalization` | Two-outcome distributions as natural numerators over a witnessed-positive denominator with n0+n1=d: exact Born normalization without floats |
| `NaturalMachine/ExactExperimentFullAbstraction` | Full abstraction for the exact finite experiment language: operational equivalence reconstructs exactly the declared two-branch weight/posterior signature |
| `NaturalMachine/ExactHadamardInterference` | Unnormalised Hadamard over Gaussian integers: norm scales by exactly 2, H² is scalar multiplication by 2, opposite relative phases exit opposite ports |
| `NaturalMachine/ExactLocalJointSeparation` | Central joint phase leaves the local population marginal unchanged while the joint interference port distinguishes it (algebraic marginal invariance) |
| `NaturalMachine/ExactProjectiveCircuits` | Gate equivariance is the descent condition: every quotient-defined observation composes with every X/Z/H circuit without recovering a representative |
| `NaturalMachine/ExactProjectivePhase` | The Gaussian two-state chart modulo the global ℤ4 phase: norm and Hadamard weights descend, equal/opposite relative phases stay distinguishable |
| `NaturalMachine/ExactTwoStateAmplitudes` | Two-state vectors over Gaussian integers with unnormalized Born weights and norm-preserving X/Z and central ℤ4 actions — exact amplitudes, no floats |
| `NaturalMachine/ExactTwoStateInstrument` | A two-outcome basis readout with explicit realized-outcome selection: Pauli X covariance exchanges amplitudes, labels, weights and posteriors coherently |
| `NaturalMachine/ExcursionReturn` | T18.4: K_t K_s − K_{t+s} = −P T_t Q T_s i over any ring; the observability kernel of the compressed evolution is definitionally FutureEq (identification proved) |
| `NaturalMachine/FiniteGraphCylindricalEquivalence` | Generator assignments on the subdivided graph modulo gauge at the new bivalent vertex are univalently equivalent to coarse assignments (cylindrical consistency) |
| `NaturalMachine/FiniteGraphFluxCylindrical` | Flux evaluation transported across the cylindrical path equals evaluation on the collapsed coarse assignment |
| `NaturalMachine/FiniteGraphHolonomyGroupoid` | A fork-and-loop graph as a HIT: identity paths supply composition, reversal, cancellation and higher coherence; contraction is automatically functorial |
| `NaturalMachine/FluxCylindricalCoherence` | Flux evaluation is coherent across the first nontrivial refinement history |
| `NaturalMachine/FullSequentialTableNormalization` | The two-branch sequential carrier retains both first-stage weights, sufficing for witnessed-positive normalization |
| `NaturalMachine/HadamardReadoutInstrument` | Equal and opposite relative phases are sent by unnormalised Hadamard to opposite basis support channels, with natural-number squared-amplitude weights |
| `NaturalMachine/HolonomyFluxDerivation` | The representation-independent Leibniz seam of the holonomy–flux algebra: subdivision consumes exactly multiplicativity plus the Leibniz law |
| `NaturalMachine/IteratedCylindricalConsistency` | Iterated cylindrical consistency for a three-edge refinement history |
| `NaturalMachine/NormalizationInterfaceMinimality` | Born normalization factors through the two-weight interface; the sequential-complete table contains option value not reconstructible from it |
| `NaturalMachine/NormalizedFiniteInstrument` | A nonzero-total witness normalizes the two weights into a common-denominator distribution retaining the original numerators |
| `NaturalMachine/NormalizedFrameCovariance` | Normalization commutes with X-frame transport: the denominator is preserved and the numerators exchange |
| `NaturalMachine/OrientedSurfaceFlux` | Surface/intersection seam: a coarse transverse crossing is inherited by exactly one child edge under subdivision off the surface |
| `NaturalMachine/PairedInterfaceMinimality` | The paired past×future kernel is the coarsest deterministic identification through which every declared response factors; immediate readout is provably too coarse |
| `NaturalMachine/ParallelNetworkComposition` | Parallel/disjoint composition of spin-network seams as a cartesian product of actions |
| `NaturalMachine/PauliGaugeCocycleSplit` | The PauliWeyl phase splits into observable phase plus the Weyl cocycle; the observable-phase correction is killed by the cokernel parity on the six contexts |
| `NaturalMachine/PauliJointPhaseRealization` | The Bool joint-phase seam is realized as the central sign sector {±I} of the two-qubit Weyl presentation, with the PM line products as endpoints |
| `NaturalMachine/PauliWeyl` | The Peres–Mermin sign vector DERIVED from the finite Weyl/symplectic presentation (i^e X^a Z^b ⊗ ...): the six line products computed by the kernel and proved equal to the transcribed datum |
| `NaturalMachine/PhysicalLearningCore` | Smallest classical/quantum joint: two exact density matrices with equal populations and opposite phase — population port compiles both to Unit, coherent port forces any exact compiler to retain a separating state; evolution and compilation commute |
| `NaturalMachine/RelationalHolonomyInteraction` | Endpoint gauge covariance is interaction-relative transport once the gauge pair is supplied as the interaction; no global gauge fixing constructed |
| `NaturalMachine/RelationalHolonomyRefinement` | Subdividing an edge introduces an internal gauge coordinate; quotienting it is path-equal to the coarse holonomy, and conjugation-invariant loop observations descend |
| `NaturalMachine/RelationalProcessCore` | Locus-indexed facts with transport along interactions: local facts exist without a global choice (Bool double cover of S¹: a global section would fix negation); rooted datum repairs it |
| `NaturalMachine/RelationalTensorObstructionBridge` | The relational (no loop-coherent section) and tensor (no right inverse) obstructions share the Bool-negation fibre but are different diagrams — not one slogan |
| `NaturalMachine/RelativeFrameChange` | A fibrewise equivalence of fact families automatically commutes with transport along every interaction path; identity/composition/triple coherence inherited |
| `NaturalMachine/RelativeFrameObservable` | Frame independence is conservation of the paired result (family covariant, evaluator contravariant), not literal equality of observer-relative facts |
| `NaturalMachine/RelativeInstrument` | Observer-indexed instruments: outcome plus outcome-indexed posterior, sequential composition, frame covariance through fibrewise equivalences |
| `NaturalMachine/RelativeInstrumentAssociativity` | Three dependent instruments compose associatively after canonical reassociation of outcome/posterior total spaces |
| `NaturalMachine/SequentialHadamardReadout` | Sequential histories: the second readout consumes the first posterior and retains both records (deterministic selected-event semantics) |
| `NaturalMachine/SequentialNormalizationObstruction` | Identical retained histories can require different normalized distributions: no exact projection to BornDistribution₂ from the selected-history carrier alone (repair = full branch table, imported back) |
| `NaturalMachine/SurfaceFluxCylindricalSquare` | The cylindrical square commutes: quotient + univalent transport + signed evaluation equals collapse + evaluation (SignedSplit witness the sole geometric hypothesis) |
| `NaturalMachine/TwoSidedExperimentInterface` | Immediate readout is a one-sided summary (phase inputs collide, future Hadamard separates); closing under preparation and experiment restores compositional equality |
| `NaturalMachine/UnivalentPhysicalProcess` | A reversible presentation change is a path in the universe; transport along the phase flip moves the state, and the loop is nontrivial — invariance only when state and evaluator move together |
| `NaturalMachine/UnivalentTensorInteraction` | Two Unit local interfaces tensor to Unit×Unit yet the joint sector has two phases: no decoder from the local product reconstructs them; the exchange is a path by univalence |
| `SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl` | The conserving flows form a monoid identified with sections under convolution BY refl; at zero loss the monoid is trivial, at total loss it is the full transformation monoid |
| `SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres` | (Σ Φ. conservation f Φ) ≃ ((a : A) → fiber f (f a)): the conserving flows of ANY observable are the sections of its own fibre family, no hypotheses — the middle of the loss–symmetry scale closed |
| `TantuVibhaga_TheGanaOfAnObservableIsTheProductOfItsFibresOwnEndomorphismMonoids` | The observable's monoid decomposes: sections ≃ Π_b End(fiber f b) as MonoidEquiv over set carriers — the typal shadow of "the commutant decomposes over the spectrum", end to end |

## Linguistics and prosody (45)

| Module | Main result |
|---|---|
| `Antya_OneAnubandhaCarriesEveryFreshStartSuffixSoAChainCostsOneMarker` | For any alphabet, one final marker (antya) denotes every fresh-start suffix of its stretch: a ⊆-chain of n pratyahara classes costs one marker, not n |
| `Asiddhatva` | The unstratified two-rule cycle (8.2.39/8.4.56) has no normal form, no normalizer, reductions of every length, and no strict order decreasing on all steps; Panini's 8.2.1 stratification is exactly what restores termination |
| `AsiddhavatRegime` | Ordered (8.2.1) vs simultaneous (6.4.22) rule regimes provably produce different outputs at tat+jalam: t→d→j vs t→d; the regime decides the attested form |
| `Dvihpatha_TheAntichainBoundIsAttainedOnlyIfASoundMayBeListedTwice` | The antichain lower bound on anubandha markers is not tight: exhaustively over all 120 arrangements, five classes on three sounds need three markers recited-once but two if a sound may be recited twice |
| `ElsewhereCondition` | The Elsewhere Condition selector: unique when it decides; complete on ascending chains and on directed families (strictly weaker than laminarity, crossing pair exhibited); existence fails irreparably without directedness |
| `ExclusionScope` | Apoha as exclusion operator: exists on unrestricted relations (pointwise implication) but NOT on the lattice of equivalence relations — transitivity obstructs any greatest admissible exclusion (three points suffice) |
| `Krama_NoRecitationOrderSeatsTheCycleSoRepetitionLiftsAnObstructionAndNotACost` | The cyclic family {ab},{bc},{ac} is seatable by NO recited-once order at any marker count (exhaustive over six orders), but three markers with repetition attain the width bound: repetition lifts an obstruction, not a cost |
| `NaturalMachine/AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem` | The type of a compositional semantics already chooses between the Bhatta and Prabhakara positions; soundness is free on exactly one of them |
| `NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning` | Rewriter soundness for the whole run: eval(normalize n rs t) ≡ eval t; equal normal forms give equality under every environment, one disagreeing point refutes, and sampling can never decide |
| `NaturalMachine/Anuvrtti` | Anuvrtti cost is not a function of the rule SET: same rules in different orders have different cost (witness: 3 vs 2), so the sutra text is strictly finer than its denotation |
| `NaturalMachine/AnuvrttiIsTheSameTrade` | The Astadhyayi's four devices split two local / two non-local by type; anuvrtti's non-locality is necessary and its saving is quantified |
| `NaturalMachine/Apavada` | Utsarga/apavada as standpoints of a rule pair: a collapse exists iff every pair of standpoints agrees (third instance of the one law) |
| `NaturalMachine/Asiddha` | Asiddhatva = standpoint-indexed state at the level of rules: mutually asiddha rules admit no common state (inherited from plurality-blocks-collapse) |
| `NaturalMachine/AsiddhatvaBreaksFactoring` | Siddha rules factor through the current form; asiddha rules provably do NOT (collision exhibited) — 8.2.1 is an information-retention device, not ordering bookkeeping |
| `NaturalMachine/AvaktavyaPrasava_TheBornStandpointDecidesAndAssertsOnlyWhatAllAsserted` | The rule born from the fourth position uniquely decides the contested item AND asserts only what every contender asserted (nothing is born where they differ) |
| `NaturalMachine/ConservativePrimitiveExtension` | Language as arity-indexed operation family; terms with intrinsic arity (function of children) |
| `NaturalMachine/ExclusionRecoversGroundAtAPrice` | Apoha vs pratiyogin, formalized: exclusion recovers ground, and the recovery's price can be paid in either of two places (dispute exhibited, not settled) |
| `NaturalMachine/FlipObservable` | Grammar blindness: at the parity port every term of the mod/gcd/valli grammar is flip-invariant (structural induction); one more bit (mod 4) already breaks the flip |
| `NaturalMachine/GeneratedGrammarDescentBoundary` | Two productions sharing a semantic observation can depend on different rules: survival after rule withdrawal does not descend through the observation map |
| `NaturalMachine/Laghava` | No function of the denotation computes presentation size: two identical meanings with different sizes — laghava is not semantic (univalence corollary is the weak form) |
| `NaturalMachine/LaghavaUnderdeterminesSoTheMetarulesAreNotOptional` | Laghava attains its minimum non-uniquely (two distinct minimal presentations with equal denotation): brevity picks a level set, so Panini's metarules are structurally required |
| `NaturalMachine/NamingIsNotAFunctionOfResemblance` | No invariant of the resemblance relation computes the naming (upamana): what both Nyaya and Dignaga need, and neither side's conclusion — the dispute left open |
| `NaturalMachine/Nirjara_SheddingAPrimitiveCostsLaghava` | Shedding an inert primitive loses no meaning and removes the symbol but strictly increases presentation size: brevity opposes nirjara, always |
| `NaturalMachine/NonInitialPratyaharasAndOneIntersectionInstance` | Pratyaharas with both endpoints free: three non-initial classes by refl, and the intersection of aK and iC is the named class iK |
| `NaturalMachine/Pratyahara` | Over three letters, no ordering makes all three two-element subsets intervals (all six orders exhausted): the alphabet order is itself a laghava-bearing choice with a hard obstruction |
| `NaturalMachine/PratyaharaBuysTotalityWithLocality` | The repetition that repairs totality destroys locality: in x y z x the name (x,x) denotes two different runs — the aN problem as a theorem |
| `NaturalMachine/Pythagoras_RatioIsTheInvariantAndLengthIsThePresentation` | No scale-respecting function of a sounding returns a length: the interval (ratio) is the invariant, lengths are presentation; composition of intervals survives the quotient |
| `NaturalMachine/RefutingLaghavaIsASearch` | A witness refutes invariance in one line; the converse is a search — the Π/Σ asymmetry behind the repeated laghava refutation shape |
| `NaturalMachine/RewriteCertificate` | A rewrite system parameterized by one conclusion-indexed induction hypothesis usable under contexts |
| `NaturalMachine/RewriteCertificateMul` | The certificate language widened to multiplication with a proved-conservative embedding: every additive certificate is accepted with the same meaning |
| `NaturalMachine/TheSecondNaIsTheCollision` | The two readings of aN computed from the six sivasutras: the repeated N makes the name denote two different sets — the first-match convention becomes visible only at sutra six |
| `NaturalMachine/TheSecondUpadhiConditionDoesAllTheWork` | Of the Nyaya upadhi's two conditions the first is satisfied by an always-existing candidate (no information); the bare existential is equivalent to failure of the pervasion — only a NAMED upadhi informs |
| `NaturalMachine/TheTower` | Five levels of description (cardinality, denotation, rule set, ordered text, alphabet order), each strictly finer, each separation a term; univalence sits at level 1 and is blind to 2–5 by construction |
| `Niksepa` | The four niksepa (name, installation, substance, state) as a checked object, with the module itself typed as a sthapana — the deposit fixed before dispute |
| `Niyama_TheDoubledSoundCouldHaveBeenAnyOfThreeAndTheFullClassesRestrictItToHaAlone` | The impossibility theorem proved once parametrically over any triple: the attested classes restrict the doubled sound to ha alone — Panini's choice was not a choice |
| `Panini` | Utsarga/apavada with priority resolution (vipratisedhe param karyam) modelled as generative Maybe-rules with first-fire priority: the exception ahead blocks the general |
| `PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain` | Classes ending at one marker form a ⊆-chain, so an antichain of width w forces w distinct markers; the four attested vowel classes force four, and the sivasutra order attains the bound |
| `Purvatrasiddham_TheLaterRulesFibreIsExactlyWhatTheEarlierRuleCannotSeeAndTheBlindnessIsForcedByCollapse` | The tripadi as a tower of maps: the earlier rule's condition fails to descend along the later rules, and the failure is exactly a non-contractible fibre |
| `Samjna_TheSemanticFibreCarriedItsNameAndTheFiveThatDidNotAreFibresOfARestriction` | The semantic fibre already carried its Panini-style name (census blindness diagnosed); five failed leads are fibres of a restriction, not of the named map |
| `Sivasutra` | The pratyahara extractor checked on the vowel prefix: aN, aK, aC compute to the traditional classes by refl, markers never members |
| `Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm` | Panini 1.1.56 as representation independence: any rule reading only designations gives the same answer on substitute and original (factoring through the designation), with the al-vidhi exception exact |
| `Svasthani_TheHypothesisThatClosesSthanivadbhavaFailsAtTheFirstSubstitutionAndReturnsAtTheSecond` | The self-standing hypothesis holds before substitution, fails at the first genuine adesa, and returns at the second application of the same form — a depth condition, definitionally |
| `Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction` | The purvapaksha/uttarapaksha as slots in one text (not a citation graph): a retraction that is not strict is not a retraction — the refusal Agda itself made, formalized |
| `Vyavaya_TheAttestedTrioForcesATwiceRecitedSoundAndPaninisChoiceIsHa` | On the actual 57-token Mahesvara line: the three attested pratyaharas restrict to the {h y s'} cycle, and no once-recited line names all three — a twice-recited sound is forced, and it is ha |
| `WallCertificate` | The wall: over any signature, if every operation preserves a naked relation argument-wise, then eval respects pointwise-related environments — saturation as a certificate, not a whimper |

## Graph theory and computation (107)

| Module | Main result |
|---|---|
| `Anvesanam_ForwardSearchIsFreeAtAnyDepthAndCostIsIncurredPerIdentificationDemandedNotPerEdgeTraversed` | A forward search trail of any depth is contractible (free); cost is incurred only per demanded identification, not per edge |
| `CachePathOrder` | Fixed-policy path caches: accumulated marginal cost telescopes to endpoint potential growth and inherits permutation invariance from commuting updates |
| `DSOCutCalibration` | Kernel-checked min-plus calibration: Kleene boundary closure equals both Schur elimination orders, and the strict interface hierarchy r_e=2 < d_e=3 < 4 raw separator states (rectangle-cover lower bound proved) |
| `DynamicDescent` | Descent through a dynamics: quotient by ker P is unsafe, only N_obs = ⋂ ker(P∘Tⁿ) is; excursion obstruction witnessed at 2×2, closure iff excursion vanishes, leaving is free but returning is not |
| `Marga1_TheDoubleCountermodelCrossesTwoCausewaysAndTheFarCensusHasTwoDistinctInhabitants` | First mechanically routed transported theorem: BFS-found route carries the two distinct countermodels across two causeways to prove the far census type has two distinct inhabitants |
| `Marga2_TheFirstTolledCrossingOfAOneWayEdge` | First tolled crossing of a lossy edge: det∘replay descends through the parity map (toll paid via FiberConstant), with the fibre quotient priced at exactly ℤ/2 |
| `NaturalMachine/ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem` | Certified rewrites compose; three of four certificate components compose for free and only Pareto improvement needs a theorem (transitivity of strict domination); no self-rewrite |
| `NaturalMachine/AFoolingPairForcesTwoRectangles` | A fooling pair forces two rectangles in any sound cover, for arbitrary row/column types (the rectangle-through-corners argument, generalized) |
| `NaturalMachine/AFoolingSetForcesDistinctRectangles` | Any sound rectangle cover assigns distinct rectangles to distinct fooling-set cells (injectivity, either-corner form) |
| `NaturalMachine/AcceptanceTest` | One theorem (counted time composes additively) makes resuming from a checkpoint compile to a strictly cheaper plan (cost m vs m+n), replayably |
| `NaturalMachine/AdditionChainPredictiveMemory` | Two addition chains with the same endpoint but different caches: the endpoint cannot predict the declared availability table, endpoint+cache-bit can (FactorsThrough collision) |
| `NaturalMachine/AffineEmergenceCountedPath` | Affine emergence: neither generator alone reaches the target (over every finite counted path) yet the union does — generatorwise no-hit verdicts do not compose |
| `NaturalMachine/AffineProjectionQuantumBoundary` | The 6x+10y=14 mod 30 solution chart is Fin 6 × Fin 10; projecting to x needs and attains a Fin 10 certificate, while the constant symbolic summary must retain all sixty states |
| `NaturalMachine/BGRadiusProjectionUnsafe` | (headerless; from code) BG certificate-state machine with radius and output projection, the unsafe (unguarded) variant |
| `NaturalMachine/BatchDepthMemoryBoundary` | A two-point encounter can raise both least chart depth and required environment alphabet (impossible under refinement on a fixed source): source growth, with matching lower/upper bounds |
| `NaturalMachine/BehavioralHankel` | A finite behavioral Hankel cut has an exact two-state realization (identity factorization); Dirac continuations expose each entry so the two future states cannot be identified |
| `NaturalMachine/BuchstabDegree` | The child operator has degree +1 on the graded tree, so "keep only the children" is a degree truncation, not a sector restriction: the Buchstab target is answered negatively with the correct statement supplied |
| `NaturalMachine/CompileBridge` | The generative loop's produced obstruction has residual = checkpoint (chain lemma: a head absent at start and present at end was named by some step), discharging Compile's dangling hypothesis |
| `NaturalMachine/CostGeometry` | Cost as edge weights on presentations: a fast algorithm is a detour whose round trip beats working in place — the defining inequality proved inside type theory, unit-independent |
| `NaturalMachine/CostGeometryEdgeBoundary` | The Edge record certifies neither equivalence nor operation-preservation: the two missing fields are independent (two controls) |
| `NaturalMachine/CostGeometryIndexed` | Cost as a function of the input: the scalar geometry embeds faithfully, and a pointwise speedup is strictly weaker than a uniform one (bridge winning at one input, losing at another) |
| `NaturalMachine/CostGeometryWitness` | Unary-to-binary transport of + is not a speedup (negative instance); a residue-style presentation where the detour provably wins (the CRT/Karatsuba/FFT shape, from stipulated weights) |
| `NaturalMachine/CountedComposition` | Counted time composes additively: running m+n ticks equals running n then resuming for m — what makes a tick count a cost |
| `NaturalMachine/CountedDigits` | The generic counted execution IS the positional digit generator (instantiation, definitional): decoding the executed state returns the count |
| `NaturalMachine/CountedDigitsEdge` | The carry-cost theorem: the counter carried in the same recursion as the odometer (nothing counted that is not executed), closing the lane's open cost edge |
| `NaturalMachine/CountedExecution` | The atomic execution law (run as iteration, successor equation refl); a seed-preserving step-commuting map commutes with every counted execution |
| `NaturalMachine/CurvatureCannotLiveOnTheImageOfAnExactCompression` | If a compression intertwines both steps and the uncompressed steps commute, compressed steps commute at every image point: architecture curvature lives only off the image (four causes reduced to one) |
| `NaturalMachine/CurvatureIsNonVacuousBecauseHereIsOnePointOffTheImage` | A point off the image where compressed steps fail to commute exists: the curvature theorem is non-vacuous |
| `NaturalMachine/DSOArchitecture` | A materialised intermediate architecture can lose an endpoint witness: R contains a valid pair no composite T;S reaches — no optimizer within the architecture can repair it |
| `NaturalMachine/DSOBellmanFinite` | A local choice is not safe to erase before its continuation is observed: the locally cheaper branch loses after Bellman composition (two-point model) |
| `NaturalMachine/DSOContinuationFullAbstract` | Extended natural costs with infinity as structural unreachability, not a sentinel |
| `NaturalMachine/DSOFinite` | Local argmin selection can destroy a cheaper composed continuation (exact finite counterexample) |
| `NaturalMachine/DSOMinPlusFinite` | Finite min-plus development over an inductive index (no enumeration axiom) |
| `NaturalMachine/DSOOption` | Coarsening an interface cannot add exactly-supported tasks: every task visible after coarsening was visible before |
| `NaturalMachine/DatumSensitivePayload` | Repair of the payload law: installation may inspect its datum, preservation required exactly when the datum realizes the defining body |
| `NaturalMachine/DependentOptimizationFibration` | (headerless; from code) architectures with dependent realizations: configurations as a fibration over architecture choice, left/right optima |
| `NaturalMachine/ExhaustionIsSystematic` | Every fuelled function in the corpus defaults on exhaustion to a legitimate output (nine instances): the collision is forced by totality, and convergence-testing fails as a surrogate |
| `NaturalMachine/ExposureStabilizationAdapter` | A causal exposure certificate composes positively into the stage separator (no search, closure, or choice) |
| `NaturalMachine/FormationDirectionIncidence` | A direction criterion compiles to the formed-counterexample interface only when the direction is realized by a formed point; inclusion covariant for counterexamples, contravariant for sufficiency |
| `NaturalMachine/FormationRelativeMinimality` | Sufficiency restricts to formed subworlds; exact minimality needs an explicit formed witness — extracting it from mere failure would imply double-negation elimination |
| `NaturalMachine/FuelAdequacyIsACollision` | The one fuelled function returning bare data (expOf) is the only one whose adequacy went unproved: bare data cannot carry adequacy, exhibited as a collision |
| `NaturalMachine/FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt` | Theorem 28.14: fully abstract compression relative to a context family preserves semantics for every elimination order (the family made explicit) |
| `NaturalMachine/GeneratedCapability` | The full composite: a generated obstruction installs the missing capability, flipping compilation restart→resume at equal answers and strictly smaller cost, changing executable future behavior |
| `NaturalMachine/GenerativeKernel` | Formation state and executable branch as one typed object: the generative transformation is the checked program itself |
| `NaturalMachine/GenerativeLoop` | Anti-plateau: an obstruction-indexed proposal chain can never leave the matcher equal, and the loop terminates within a bound that is a measure of the target |
| `NaturalMachine/HaskellDefinitionBoundary` | The Haskell engine's old positive-positive gcd rewrite is refuted in the kernel (LHS 1, RHS 3 at x=1,y=2); the surviving base equations proved, with refl-guarded rule-list agreement |
| `NaturalMachine/HaskellDiscoveryBoundary` | The engine's five-round discoveries promoted to typed equalities: all seven proofs checked by the kernel, with the generated AST refl-matched |
| `NaturalMachine/HaskellGenericSyntaxAdapter` | The bounded discovery bridge and the generic primitive-extension syntax are one four-operation language: discovery equations reuse the generic substitution theorem |
| `NaturalMachine/IntrinsicProductiveInstall` | The finite local operation recognizes exactly the two rooted source terms generated by the intrinsic installation |
| `NaturalMachine/IntrinsicRewrite` | A Run's constructors ARE the executable motions: ill-composed motions cannot be built (Curry–Howard collapse of execution and justification) |
| `NaturalMachine/KFlow` | Trichotomy of the obstruction flow ∂∘Γ: contracting orbits reach 0 in finite time, stationary at ρ=1, never at ρ>1 — the spectral radius as the sign of one step, nothing fitted |
| `NaturalMachine/KFlowWF` | Fuel removed: the contracting flow terminates by well-founded recursion on any well-founded measure into any type (general form, instances recovered) |
| `NaturalMachine/KnowledgeProcess` | Bridge between exact interaction histories, past×future continuation observations, and the mixed-corner compiler (capability retained as input) |
| `NaturalMachine/LawfulContinuationCore` | State-dependent lawful motion with counted histories |
| `NaturalMachine/MachineLoop` | The engine's round loop constrained: decay rounds need not grow, no growth on a collapsed test set, and the min-plus growth chooser never does worse than staying |
| `NaturalMachine/MatchingPenniesSeparator` | Matching pennies: welfare and pure-Nash summaries have one fiber so best-response descends through neither — von Neumann's example and the blind-fiber-reward theorem are one level-set theorem |
| `NaturalMachine/MergingASeparatedPairBreaksAtTheSeparatingContinuation` | Merging a separated pair breaks at the separating continuation: ¬(A × B) proved, and provably not ¬A ⊎ ¬B — the guilty state is undetermined without a decision |
| `NaturalMachine/MigrationNeedsALawAndTheLawIsNotFree` | The migration law (observation preservation) composes and transports every invariant, but is not free: an unlawful migration exists (not on Bool) |
| `NaturalMachine/MixedCornerTransferCompiler` | The mixed-corner compiler: well-founded rank κ = 2i + bit admits purification and descent, transporting any cofinal seed to (radius 0, exact charge) |
| `NaturalMachine/NRectanglesCannotCoverSucNFoolingCells` | A fooling family of n+1 cells cannot be covered by n rectangles (pigeonhole composed with cover injectivity, stated without cardinality) |
| `NaturalMachine/NRectanglesCannotCoverSucNFoolingCellsEvenWhenTheCoveringIsOnlyAProperty` | The covering hypothesis weakened from equipped choice to a property: the price is finite choice, paid in both untruncated and truncated forms |
| `NaturalMachine/NoObservationDepthDeterminesTheNet` | The root survives at every observation depth of the guarded stream, yet the net is not determined at any depth |
| `NaturalMachine/ObservabilityQuotient` | N_obs = ⋂ ker(P∘Tⁿ) is T-invariant, is future-observational equivalence, is a congruence, and is strictly finer than ker P (witness: instantaneously indistinguishable states separated next step) |
| `NaturalMachine/Obstruction` | The obstruction-indexed proposer: frequency proposers plateau (closed under already-built), residual-driven proposals name exactly the missing head — both halves checked |
| `NaturalMachine/OneStepDecidesResonanceAndNoPrefixDecidesDecay` | Resonance is decided by one comparison (sound and complete); decay is decided by NO finite prefix (for every N a contracting flow hits 0 only at N+1) |
| `NaturalMachine/OperationalCoverageCounterexample` | A finite category with declared singleton covers need not be a site: adjacent arrows cover, their composite does not — transitivity fails |
| `NaturalMachine/OrderIndependenceTransfersAlongAnyNumberOfSteps` | Intertwining extends to any composite by one square per step: if two uncompressed composites agree, the compressed ones agree on the image (n-step, with two-step as corollary) |
| `NaturalMachine/PairwiseCommutationGivesEveryOrder` | Pairwise commutation of steps gives equal uncompressed composites for ANY two permutations (inductive presentation), making the every-order compression theorem hypothesis-free |
| `NaturalMachine/PolyHaythamResponseCostNoGo` | If a response fiber contains two implementations separated by a cost, no postprocessing of the response recovers the cost (two-point refutation of response-to-cost descent) |
| `NaturalMachine/PowModHasTheSameShape` | powMod's fuel exhaustion returns the same expression as the legitimate e=0 branch (1 mod m): the collision that makes bare-data fuel unrescuable by any decoder |
| `NaturalMachine/ProductiveTear` | A returned tear is earliest in the inspected prefix, not merely some failure (coherence retained layer by layer) |
| `NaturalMachine/ProgrammableActionFibers` | Keeping the program leaves one action fibre; erasing it sums every program fibre — the max/sum coherent environment law at the type level |
| `NaturalMachine/ProgressDefinition` | A progress statement in which the generated body is load-bearing: the deficit measure splits through plug/unfold, false for a proposer generating nothing (negative control) |
| `NaturalMachine/ProofLabelNoGo` | If two distinct claims receive the same emitted label, no round trip recovers which claim a certificate certifies (the Maybe String obstruction) |
| `NaturalMachine/ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty` | Provenance may be replaced by the empty list and the certificate survives: vacuously-free vs derivably-free distinguished with a term |
| `NaturalMachine/QuestionMachine` | halts (contracting flow resolves every question) and never-final (any quotation leaves an observable outside) hold at once: completeness does not close the system |
| `NaturalMachine/RadiusTransferCompiler` | Factory III Theorem 41: a bounded edge transports recurrence to radius one (transfer compiler; the prime predicate a parameter) |
| `NaturalMachine/ReachableFromStart` | The unreachability verdict holds only with start ≡ s0 in the type: the dropped premise makes the start-free reading imply ⊥ |
| `NaturalMachine/RealizedPayloadCapability` | Only the checked package carries the semantics-preservation capability of the installation edge |
| `NaturalMachine/Residual` | The residual ϱ = wHere ∸ detour is invisible to every equivalence-invariant response (cost is an undetermined field); Γ↝ never loses and exhibits a strictly better presentation when it wins |
| `NaturalMachine/ResidualInvariance` | Corrected form: an invariant response may READ the residual but only constantly — it may look and may not distinguish (constant counterexample honored) |
| `NaturalMachine/ResidualPath` | Γ↝ is certified as the minimum of home and listed routes (sound with member witness, optimal, greatest, attained): a search, not an oracle |
| `NaturalMachine/SelfImprovement` | Genotype/phenotype separation as types: no store edit computes a genotype from scores; transport needs a Bridge plus invariance (sharp refutation without it); a gamed evaluator quarantines cleanly |
| `NaturalMachine/SemanticCrystal` | Execution, measured defect, two-sided nucleus interface, and a language generated from the exact observations (constructors retain recomputation data) |
| `NaturalMachine/TermFreeMonoid` | Tm ≃ List Shape with plug carried to ++ (the transition is a monoid map): the generative lane's chart transition |
| `NaturalMachine/TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount` | Respects hb ord is definitionally hb ⊑ ord: admissible orders are the principal up-set, and two one-edge relations have incomparable admissible families — strength is not a function of edge count |
| `NaturalMachine/TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation` | The cardinal form of the fooling bound needs an injection Fin↪Fin and does not follow by instantiating the contrapositive (the strong/weak reading split made exact) |
| `NaturalMachine/TheGapWasAUnitsError` | The walk's "gap" dissolved: at frontier k it has distinguished cap(k)=lcm(1..k)=e^ψ(k) inputs, so storage is the logarithm of workload exactly (the comparison had mismatched units) |
| `NaturalMachine/TheLastCutHasOneRowWhenItsSeparatorIsInhabited` | For an arbitrary import relation the last cut has a single column so every separator row is the same row — width 1 when inhabited, 0 when not (the glossed edge case stated) |
| `NaturalMachine/TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain` | The five-component certificate (with the migration law) composes along arbitrary chains, moves no observation, transports every invariant, strictly improves; the law is independent of the other four |
| `NaturalMachine/TheReachableLawDoesNotComposeWithoutPreservation` | Reachable-only migration laws compose ONLY given preservation of the invariant (three systems whose lawful-on-R migrations compose unlawfully; global law recovers as the total case) |
| `NaturalMachine/TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose` | The six-component certificate composes; a full five-component certificate that fails invariant-preservation shows the sixth is independent — and it is what makes the fifth compose |
| `NaturalMachine/TheTransportOverheadIsProvablyRedundantAndItsMechanismIsALibraryLemmaNotAMeasurement` | The transported-operation overhead is transportUAop₂ verbatim (a library lemma, not a measurement): the mechanism was derived, never measured |
| `NaturalMachine/TransportCost` | The transported term computes but quadratically: transport across ua e is e⁻¹∘f∘(e×e), a full unary round trip per operation (the reproducible witness) |
| `NaturalMachine/TransportDiv` | The Horner automaton modw computes value w mod n in one step per digit (value-modw), vs the unary test walking the value: the walk's frontier gap derived, with prior art recorded (Sutner, Alexeev) |
| `NaturalMachine/TransportDivQuot` | Euclidean division on the digit chart: divw with value w ≡ n·value(divw n w) + modw n w and the transport statement, including the honest n=0 case |
| `NaturalMachine/TransportDivScale` | The frontier's X-dependence derived: chart cost linear in length, home cost exponential (positional lower bound b^(L−1)), so the detour wins past a derived threshold — points as instances of the law |
| `NaturalMachine/TransportDivWitness` | The frontier with numbers: word 1000 base ten, home work 1000 vs chart work 5, detour 14 — computed by the kernel |
| `NaturalMachine/TransportInstance` | End-to-end theorem transport: +-commutativity carried to digit words by one subst along the SIP path — no word induction, no carry analysis |
| `NaturalMachine/TransportMulWitness` | The digit multiplier running at base 10 by refl (99·99 = 9801 with the kernel carrying the ripple) |
| `NaturalMachine/TypedUnfold` | The algebra interpreting heads, semantic preservation of unfold, separated invocation/unfolded costs, and the strict growth of the cost-bounded denotation language |
| `NaturalMachine/UnderExtensionalFlatnessOneCostDifferenceSuffices` | Under extensional flatness every pair of orders is already a collision: one cost difference anywhere refutes any result-to-cost decoder |
| `NaturalMachine/WitnessPolicy` | The informative witness policy: the obstruction's own carried subterm is the body (the substrate's unused hypothesis is exactly gate D4), with size laws through plug/unfold |
| `NaturalMachineRun` | The machine executed by the kernel: positional arithmetic, transported addition applied to actual words, the kuttaka valli replayed, macro compression, and the rank-one chart — every line refl |
| `ObligationMinCut` | A concrete finite network with feasible flow and cut both of value 2: weak duality certifies both optima at once, so the self-network's audit burden is exactly 2 |
| `SeamClosed` | The flagship residual x ≡ x + 0·x discharged with the machine's own discarded addZero induction: the lemma the engine proved in every replay and threw away 820 times |
| `TraceCorpus` | Generated corpus of the machine's own trace-replay output (17 records, 22 shared declarations) |

## Other (build aggregates, indices) (7)

| Module | Main result |
|---|---|
| `ArchivistLane` | Build aggregate gate (no theorem): rechecks 34 modules outside the other gates' import closures |
| `Everything` | Build aggregate importing every top-level module (no theorem) |
| `IndianLane` | Build aggregate gate for the Indian lane (no theorem) |
| `MachineCurriculum` | The lemmas the rewriting engine demanded (0=y·0, x·0=0, x=x+0, ...), proved — machine-driven curriculum, elementary content |
| `NaturalMachine/ListKit_OneImportPointAndNoNewDefinitions` | Import point re-exporting canonical list plumbing (no theorem) |
| `NaturalMachine/RootsThreadLatch` | Container-buildable latch for orphan modules (no theorem) |
| `Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted` | Generated aggregate root importing every module (no theorem) |

---

## Counts per area

| Area | Modules |
|---|---|
| number theory | 154 |
| algebra | 130 |
| combinatorics | 106 |
| logic-foundations | 274 |
| order theory | 61 |
| physics-QM | 53 |
| linguistics-prosody | 45 |
| graph-computation | 107 |
| other | 7 |
| **total** | **937** |

## The 15 mathematically strongest results

Judged as mathematics — general, sharp, novelty-shaped — not as process notes.
Where a result spans several modules, the modules are listed together.

1. **`NaturalMachine/QuotientFiberLaw`** — One law over an arbitrary state
   space and Boolean queries: blind queries yield equal transcripts (so no
   post-processing separates), and a single charged query constructs a
   separator. Twelve previously independent corpus results fall out as
   instances. The widest-scope single theorem in the directory.
2. **`CakravalaBound` + `VajraAbhyasa` + `CakravalaDescent`** — Bhāskara's
   cakravāla choice rule keeps k² ≤ 4D strictly (proved as 16k′² ≤ 36D in pure
   ℕ-inequalities, no square roots); consecutive turns have crosswise product
   exactly 1, so gcd(b′,k′)=1 and the next admissible multipliers are exactly
   the class of −m — the descent step over any commutative ring. Together:
   the termination window of the wheel, formalized sharply.
3. **`NaturalMachine/SthaulyaIsTheOmittedTerm`** — For every convergent of the
   Mādhava continued fraction: (h_k(n)k_k(n+1)+h_k(n+1)k_k(n))(2n+1) −
   k_k(n)k_k(n+1) = (−1)^{k−1}·4^k·(k!)². The sthaulya (coarseness) in closed
   form from the determinant recurrence, uniform in both indices.
4. **`Gamma0PartnerRigidity` + `Gamma0IndexExponent`** — The two-sided
   stabilizer partner in Γ₀(D) is entrywise canonical, a proposition,
   contractible given a witness (membership and stabilization are one type);
   and the index-formula exponent identity G_p − E_p = Σ_{u<t} r_u r_t
   (f_t−f_u−1) ≥ 0 proved for every rank and divisor chain.
5. **`NaturalMachine/RadixSymptoma`** — Myhill–Nerode for the base-b
   divisibility automaton: two states are behaviourally equal iff they have
   the same set of shortest completions, with a two-coordinate complete
   invariant σ(r) = (κ r, b^{κr}·r mod m).
6. **`NaturalMachine/FrontierDividesHard` + the Walk suite
   (`WalkForcing`/`WalkJumps`/`WalkPrimePowers`/`WalkFast`)** — prodOf(frontierList k)
   = lcm(1..k) by universal property (m ∣ product for all m ≤ k, by strong
   induction with prime peeling); the lcm walk installs exactly the prime
   powers in increasing order; and the divisibility predicate is traded for a
   decidable prime-power test — a proved superexponential speedup.
7. **`HeadDepthMerge`** — For odd prime powers, strong (Miller–Rabin)
   blindness depth equals Fermat blindness depth: every Fermat liar is a
   strong liar, with e_b(q) = v_q(b^ord − 1) computed once and a 1048-triple
   table as a checked term.
8. **`NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne`** —
   Exact adaptive query complexity: the least worst-case number of valuation
   queries identifying r in ℤ/p^k is exactly k(p−1) — digit-descent protocol
   for the upper bound, adversary for the lower, both checked.
9. **`NaturalMachine/CarryClassNonzero` + `GroupCohomologyH2`** — H²(Q;A)
   constructed as an actual quotient group with effectivity (class zero ⟺
   homomorphic section), and for every base b ≥ 2, every n, every digit
   section, the carry class [cₙ] ≠ 0 in H²(ℤ/bⁿ; ker πₙ): carrying is a
   nonzero cohomology class.
10. **`NaturalMachine/PauliWeyl` + `PMCokernel`** — Peres–Mermin derived, not
    transcribed: the sign vector computed from the finite Weyl/symplectic
    presentation, and the obstruction identified as coker(δ) ≅ F₂ via the
    all-ones parity functional (odd-weight sign vector vs even image) —
    invariant-as-content replacing the 512-case exhaustion.
11. **`IntegerHullMultiplicity`** — The convex relaxations m² ≥ 2m−1 and
    m² ≥ 3m−2 are lossless for all N,S: integer optima of atom-count
    minimization equal the relaxation values, by the substitution m = 1+x
    reducing both to per-element facts.
12. **`SvaTantuVasa` + `TantuVibhaga`** — (Σ Φ. conservation f Φ) ≃
    ((a : A) → fiber f (f a)): the conserving flows of any observable are the
    sections of its own fibre family, with no hypotheses; and the sections
    monoid decomposes as Π_b End(fiber f b) — the typal shadow of "the
    commutant decomposes over the spectrum".
13. **`TomographyConditioning`** — Exact conditioning constants for power-basis
    tomography: κ_pow,raw = R+1 and κ_pow = C(2R,R), via the unsigned Stirling
    alternation — general in R, nothing fitted.
14. **`Asiddhatva`** — The unstratified two-rule cycle (Pāṇini 8.2.39/8.4.56)
    has no normal form, no normalizer, reductions of every length, and no
    strict order decreasing on all steps; 8.2.1 stratification is exactly what
    restores termination. A genuine non-termination theorem with the
    no-strict-order half included.
15. **`ThresholdGenerationDichotomy`** — Every unary ACUI-polynomial on a
    meet-semilattice is a clamp or a constant; the four-chain map ψ is
    admissible, not a polynomial, not a threshold, but is a meet of two
    thresholds — so the threshold vocabulary must be taken as a generating
    family, not a basis.

Near misses, listed because the cut was close: `LawvereDiagonal` (Lawvere
fixed point in full generality with productive Cantor contrapositive),
`Vargaprakrtitantu` (the Pell fibre is infinite with bhāvanā as the witness),
`ChidraDosa` (pointwise fibre-invariance without coherent descent on S¹ — the
isSet hypothesis is necessary), `NaturalMachine/SpernerFromSl2` (divisor
lattice of p^α Sperner via its sl₂ action), `NaturalMachine/OffDiagonalThueMorseUnique`
(uniqueness of the ±1 Thue–Morse solution), `NaturalMachine/PiPartialOnEveryPrime`
(the Π_∂ identity fails on every prime by exactly 1, as a closed universal
theorem), and `Vyavaya` (on the attested 57-token Māheśvara line a
twice-recited sound is forced, and it is *ha*).
