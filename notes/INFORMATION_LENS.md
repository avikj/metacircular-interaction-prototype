# Information as a load-bearing mathematical lens

“Everything is information” is too weak to guide research.  The useful move
is to name an encoder or channel, compute its fibers, and quantify exactly
which distinctions survive.

## 1. The finite classical core

Let $X$ be a finite state space, let $q:X\to Y$ be the observable map, and
give $X$ a distribution.  Then

\[
H(X\mid q(X))
\]

is the average information destroyed by the observer.  For another statistic
$c:X\to C$:

- $c$ descends through $q$ exactly when $H(c(X)\mid q(X))=0$;
- the augmented observation $(q,c)$ reconstructs $X$ exactly when
  $H(X\mid q(X),c(X))=0$;
- any worst-case side channel that labels every $q$-fiber needs at least
  $\lceil\log_2\max_y|q^{-1}(y)|\rceil$ bits;
- the expected optimal side information is bounded below by
  $H(X\mid q(X))$.

These are the quantitative forms of the repository's quotient, missing
charge, and reconstruction language.  They force every claim of “one missing
bit” to exhibit an actual two-point fiber theorem rather than a suggestive
parity label.

If a group $G$ acts and $q$ sees only orbits, the hidden label at $x$ has at
most $\log_2|G/G_x|$ bits.  Equality requires proving that the fibers are
exactly the $G$-orbits.  Invariance alone proves only that orbits lie inside
fibers.

## 2. Current theorems in this language

- **Character-anchor homometry.**  On the class of finite torsion-free
  abelian-group subsets having a singleton character fiber, full labeled
  autocorrelation is sufficient modulo translation and inversion.  The
  conditional entropy of the symmetry class is zero.  This is stronger and
  more precise than saying that “parity helps phase retrieval.”
- **General homometry.**  Autocorrelation is a many-to-one channel.  Its fiber
  size is the operational ambiguity; factor-reversal algebra describes
  candidate allocations, subject to coefficient and support constraints.
- **Sieve parity.**  A neutral observable algebra annihilating a charged
  component proves zero mutual information only after a probability model and
  channel are specified.  The algebraic vanishing statement is exact; a
  Shannon slogan without the model is not.
- **Prime-prefix factor certificates.**  The large agent-generated search is
  compressed into a small finite candidate list plus independently replayable
  witnesses.  That is literal description-length reduction of a proof
  obligation, not evidence that the theorem itself is random.

## 3. The individual-state version: algorithmic information

Kolmogorov complexity supplies an individual analogue:

\[
K(x\mid q(x))
\]

measures the shortest residual program reconstructing $x$ from its observed
shadow, up to the chosen universal machine's additive constant.  It suggests
three legitimate research moves:

1. **Upper bounds by reconstruction.**  An explicit inverse or side-information
   code is a rigorous program and therefore a rigorous complexity upper bound.
2. **Lower bounds by counting.**  If many states share one observation, most
   require many residual bits.  This does not identify which named state is
   incompressible.
3. **Proof compression.**  A representation is valuable when it shortens the
   certified dependency graph or the executable verifier, not merely the prose
   explaining it.

Chaitin incompleteness is a boundary, not a magic source of number-theoretic
independence.  For a fixed sound effectively axiomatized theory, there is a
theory-dependent ceiling beyond which it cannot certify statements asserting
the high Kolmogorov complexity of particular strings.  Since $K$ is
uncomputable and machine-relative up to constants, an agent may not use a
complexity estimate as a theorem without an explicit code or counting proof.

This boundary nevertheless matters strategically.  Some proof searches may be
hard because the shortest proof is long in the current formal language.  A
Rosetta translation can change that description length drastically even when
it does not change truth.  Searching for representation is therefore a search
for *proof compression*, and a kernel-checked shorter proof is its certificate.

Prime prefixes themselves are highly compressible conditional on the cutoff
and a primality algorithm.  Treating their bit strings as algorithmically
random without specifying the conditioning is a category error.

## 4. The quantum-information import

For a finite cutoff or a weighted $\ell^2$ prime vector, normalization produces
a genuine density operator.  An observable restriction becomes a quantum
channel $\mathcal E$; informational completeness means injectivity of
$\mathcal E$ on the stated state class.  Trace-distance contraction quantifies
lost distinguishability, and a group twirl deletes nontrivial representation
sectors.  This makes the following technologies relevant:

- phase retrieval and informationally complete POVMs;
- resource theories of asymmetry and superselection;
- entropic uncertainty and Fourier sampling;
- quantum marginal/extension problems and semidefinite certificates;
- channel recovery and approximate sufficiency.

But the constraints are strict:

- the unweighted infinite von Mangoldt sequence is not a trace-class quantum
  state;
- a positive Fourier multiplier is not automatically a projection or channel;
- equal spectra do not imply unitary equivalence on a restricted state class;
- “entanglement,” “no-cloning,” and “quantum advantage” require actual tensor
  products, operational tasks, and admissible maps.

Most present reconstruction problems are set-level and classical.  QIT earns
its place only when it contributes a quantitative discrimination/recovery
theorem or a new convex certificate.

## 5. Mandatory information audit for a Rosetta card

Every observer/quotient claim should answer:

```text
STATE CLASS:          X and its normalization/prior
CHANNEL:              exact q or E, including domain and codomain
FIBERS/KERNEL:        what is provably identified
SUFFICIENT STATISTIC: what descends through the channel
MISSING INFORMATION: exact count, entropy, orbit, or complexity bound
SIDE INFORMATION:     smallest proved reconstruction supplement
STABILITY:            how noise changes distinguishability
ALGORITHMIC FORM:     explicit encoder/decoder or verifier
QUANTUM UPGRADE:      genuine CPTP/tensor formulation, or “not applicable”
FALSIFIER:            cheapest pair of states violating the claim
```

## 6. Immediate CPU-scale experiments

1. Enumerate finite fibers of every current observable map and report the
   distribution of fiber sizes, not only collisions.
2. Compute minimal distinguishing observable subsets as set-cover or SAT
   problems; independently verify the resulting reconstruction code.
3. Measure proof-DAG compression when a Rosetta translation is applied: old
   obligations versus translated obligations plus bridge cost.
4. On finite normalized truncations, use exact rational/interval SDP bounds to
   test whether QIT recovery or uncertainty inequalities strengthen known
   homometry bounds.
5. Search for stable character-anchor rigidity: lower-bound the distance
   between autocorrelations of non-equivalent near-anchored sets.

The aim is not to redescribe mathematics as information.  It is to turn every
claim about “what is forgotten” into a coding theorem, a recovery theorem, or
an impossibility certificate.

