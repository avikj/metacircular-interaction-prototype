# Prime Pair Field — Fields-Medal / Cross-Mathematics Lens Delta

Date: 2026-08-11
Status: conceptual research delta; preserve separately from proved canonical state until individual claims are verified.

## Purpose
This checkpoint records the strongest synthesis from the current cross-field scan so it is not lost. It does NOT upgrade any theorem's verification grade. The canonical research state remains authoritative for exact claims.

## 1. Strongest organizing hypothesis: arithmetic hardness as reconstruction failure under restricted observables
The pair field Λ⊗Λ is simple; difficulty repeatedly appears after natural information-losing maps. Candidate master problem:

> Given an arithmetic state x and a symmetry-restricted / compressed observable algebra O(x), characterize (i) the kernel/equivalence class, (ii) minimal extra observables restoring reconstruction, and (iii) obstruction classes when lifting/reconstruction fails.

Three existing faces:
- Harmonic/phase retrieval: f -> f * f~; Fourier data |f-hat|^2; homometric ambiguity after radial/heat compression.
- Gauge/operator algebra: a -> E_gauge(a); charged sectors are annihilated by invariant expectation.
- Sieve: finite local divisibility data loses the unresolved large-prime/factorization-charge bit; canonical state already corrects the too-strong claim that full divisibility algebra cannot see Ω.

Important correction inherited from canonical state: full heat-resolved gap data is reconstructive; phase loss occurs only after compression. Likewise full divisibility data determines Ω; sieve parity is a scale-truncation/coherence obstruction, not absolute algebraic invisibility.

## 2. Candidate unification to prove, not merely analogize
Seek a common invariant-theoretic/conditional-expectation theorem for:
- homometry / phase loss,
- x -> -x polynomial involution and resultant charge pairing,
- gauge charge projection,
- parity-character modes of Buchstab flow.

The useful abstraction is not 'quantum' language itself but:
observable algebra; group action; conditional expectation/twirling; commutant; informational completeness; superselection/asymmetry resource; reconstruction after symmetry averaging.

Research question: can A/A'/E1/F and the charge-deformed Buchstab semigroup be placed in one functorial diagram whose arrows carry explicit (kernel, symmetry group, invariant algebra, reconstruction theorem)?

## 3. Most promising foreign machine: obstruction/index theory
The sieve parity problem has the shape 'locally available information does not glue/lift to the desired global prime event.' This suggests importing obstruction theory/sheaf-cohomological language, but only through finite toy models first.

Potential bridge:
local sieve data -> failure of lifting/gluing -> obstruction class -> index/boundary map.

This makes the Toeplitz K-theory spearhead conceptually meaningful if, and only if, the K-boundary class can be tied functorially to the actual scale-truncated parity obstruction rather than merely to topology of the Toeplitz extension.

Sharper target than 'is ∂ nonzero?':

> Is the sieve parity obstruction itself naturally represented by a boundary/obstruction class associated with quotienting or forgetting factorization charge? If not, prove the no-go and demote the K-theory branch.

Finite-place testbed: for a finite prime set S, use X_S = ∏_{p∈S} Z/pZ and local prime-avoidance/charge observables. Organize local data as a finite presheaf/diagram and ask whether the missing parity/large-prime bit is represented by a nontrivial cocycle or lifting defect. Then compare inverse-limit behavior with the Toeplitz six-term boundary map.

The exact local factor I_p(-1,...,-1)=(p+1-2k)/(p+1), with annihilation at p=2k-1 in the distinct-residue case, is a natural finite-place stress test, not by itself evidence of a global obstruction class.

## 4. Quantum-information/phase-retrieval import
Finite-dimensional quantum information provides ready-made mathematics for restricted observability:
- homometric sets ~ states indistinguishable under a measurement family;
- heat/radial resolution ~ enlargement to an informationally complete family;
- gauge expectation ~ group twirling;
- charge sectors ~ asymmetry resources/superselection sectors.

Concrete target: characterize the minimal additional family of arithmetic observables needed to recover the scale-truncated odd/parity sector, analogous to completing a non-informationally-complete POVM/measurement algebra.

This reframes 'beat parity' as: what is the minimal enlargement of the sieve observable algebra that makes factorization charge identifiable at the needed scale?

## 5. E0 remains the highest-value established structural node
The critical KMS / Hardy-Littlewood singular-series correspondence plus β=1+λ/log z finite-size crossover, Dickman/Buchstab adjunction, and ζ Laurent ladder is currently the most structurally fertile established cluster. Main conceptual question:

> Why is the Hardy-Littlewood singular series the critical correlation function?

Look for an answer stated in renormalization/locality/transfer-operator terms that does not insert prime correlations by hand.

Canonical state already sharpens this: Buchstab peeling is scale-ordered traversal of ax+b inverse branches; local singular-series factors are branch-survival/collision probabilities; the hard problem lives in the non-self-adjoint positive-cone lift retaining stopping/boundary information.

## 6. Strong convergence with the newer charge-deformed Buchstab result
The library delta already contains a major refinement:
R_z(x,y)=π(x)-π(y)+z Σ_{y<p≤√x} R_z(x/p,p),
with continuum (uω_z(u))'=zω_z(u-1), and measure semigroup μ_z satisfying Laplace(μ_z)=exp(z E1(s)), μ_{z1}*μ_{z2}=μ_{z1+z2}.

This means parity z=-1 is the convolution inverse of ordinary factorization flow z=1. This is stronger and cleaner than a binary even/odd metaphor. Future cross-field work should use the full analytic charge parameter z and ask what representation-theoretic object diagonalizes this semigroup.

Candidate directions inspired by broad Fields-Medal mathematics:
- Representation theory/harmonic analysis: interpret z as character/weight and μ_z as an exponential in a convolution algebra; seek a Plancherel/spectral decomposition of the affine transfer operator retaining stopping order.
- Renormalization/dynamical systems: Buchstab flow as an exact scale semigroup; identify fixed points, relevant/irrelevant modes, and whether the parity inverse is an unstable direction invisible at equilibrium.
- Ergodic theory: distinguish equilibrium averages from boundary/stopping-time observables; formulate prime detection as a return/hitting problem rather than a static correlation.
- Additive combinatorics: seek an arithmetic regularity/inverse theorem saying failure of parity cancellation forces correlation with a structured charged object, analogous to inverse theorems for Gowers norms.
- Algebraic geometry/function fields: treat Hodge-index negativity/monodromy as the solved-world mechanism that supplies a sign unavailable over number fields; ask what abstract positivity/negativity axiom the number-field observable category lacks.
- Geometric measure / optimal transport: study whether sum/difference marginals plus charge are tomographic projections of a positive measure with stability bounds; potentially quantify how much resolution is needed for reconstruction.
- PDE/microlocal analysis: sharp cutoff difficulty versus heat smoothing suggests boundary singularities/wavefront information are the missing data; formulate the sharp Goldbach problem as recovery of a boundary trace from smoothed semigroup data.
- Topology/index theory: only pursue if an explicit lifting problem for the charged transfer operator can be written.

## 7. Current ranking of effort
1. Build the master observable/reconstruction diagram and make every claimed analogy an explicit map.
2. Write the scale-ordered charged Ruelle/Exel transfer operator from ax+b inverse branches; determine its z/character sectors and relation to μ_z.
3. Attack the finite obstruction toy model and K-boundary spearhead in parallel; kill the K-theory story quickly if no functorial connection to sieve parity exists.
4. Import inverse-theorem machinery from additive combinatorics/ergodic theory to characterize what non-cancellation of charged sectors must look like.
5. Use function-field geometry to isolate the exact 'missing sign/negativity' axiom rather than continuing loose analogy.
6. Deprioritize further high-precision confirmation of already-validated zero-pair spectral dictionaries unless it tests a new mechanism.

## 8. What would count as a major conceptual collapse
Best-case theorem schema:

There exists a category of arithmetic states with scale filtration and symmetry/charge action such that:
(a) classical sieve/KMS observables are a conditional expectation onto a neutral subalgebra;
(b) the charge-deformed Buchstab flow is the scale-evolution semigroup on isotypic sectors;
(c) prime detection is a boundary/stopping observable requiring a specific non-neutral sector;
(d) failure to reconstruct that sector from neutral finite-scale data is measured either by an explicit inverse-theorem obstruction or a canonical boundary/index class;
(e) adding a minimal extra observable family restores informational completeness.

Even proving (a)-(c) rigorously in a clean finite/semigroup model would unify a large fraction of the program. A proof that (d) cannot be K-theoretic would also be valuable.

## 9. Verification discipline
Everything in this delta beyond cited canonical exact identities is HYPOTHESIS / RESEARCH DIRECTION unless separately certified. In particular:
- no claim yet that sieve parity is a sheaf cohomology class;
- no claim yet that the Toeplitz boundary class represents Liouville parity;
- no claim yet that quantum informational completeness directly solves a number-theory barrier;
- no claim that the proposed master category exists in a useful non-tautological form.

The value of these imports is measured by whether they produce an exact finite model, theorem, obstruction, or computable invariant.
