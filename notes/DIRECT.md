# Direct structure: three workstreams, zero sampling

Course correction (upstream): empirical pattern detection is demoted to
falsifier-only duty, per MATH_OS's own falsification plane. The
structure in FOREST.md is exact; interrogate it directly.

## The exact objects

$S = \{\pm1\}^{\mathbb N}$ with the shift $\sigma$ and dilations
$(D_p x)(n) = x(pn)$. The simultaneous eigenvector set
$$M \;=\; \{x : x(mn) = x(m)x(n)\ \forall m,n\}
\;=\; \{x : D_p x = x(p)\,x\ \forall p\}$$
is a **compact abelian group** — canonically $\{\pm1\}^{\mathcal P}$,
coordinates = values at primes. Nothing is sampled: $M$ is fully known.
The problem is the interaction of the group $M$ with the shift, which
does not preserve it. The exact interface is

$$\sigma D_m=D_m\sigma^m.$$

The Liouville point is characterized up to global sign by
$D_p\lambda=-\lambda$ for every prime $p$; for a general $m$ its
eigenvalue is $\lambda(m)$, not always $-1$.

## Workstream A: classify the eigenmeasures (pure ergodic theory)

Call a shift-stationary process on $\{\pm1\}$ a **dilation eigenprocess**
if it arises as a shift-orbit statistical limit of some $x \in M$. The
convex set of these contains structured points (for example $x\equiv1$) and,
conjecturally, Bernoulli($\tfrac12$) for $\lambda$. The direct question,
stated without arithmetic:

> **(A) Dichotomy problem.** Prove or refute: every ergodic limit
> process of a point of $M$ is either (i) almost periodic (pretentious
> regime) or (ii) of positive entropy. Sharper target: (ii′) Bernoulli.

This is a proposed classification problem, not a consequence of the dilation
identity and not a theorem schema already known to contain every existing
result. Entropy-decrement and logarithmic Sarnak results are calibration
points that use substantial additional arithmetic and analytic input. The
workstream's charge is to separate
what is *soft* (true for abstract distributional eigenprocesses —
provable by dynamics alone) from what *requires arithmetic input*
(rational independence of $\{\log p\}$, positive density of primes).
A construction of an exotic eigenprocess violating the dichotomy in the
abstract setting would be a theorem: it would prove the identity alone
does not force randomness, locating exactly which arithmetic fact must
enter. Either outcome is structure.

## Workstream B: proof-diff against the solved case (name ℤ's missing geometry)

Chowla over $\mathbb F_q[t]$ (large $q$) is a **theorem**
(Sawin–Shusterman). The proof consumes: the shift becomes an algebraic
family; correlations become trace functions of sheaves; big monodromy
gives independence. The workstream's charge: align the dependency DAG of
that proof against the integer case and emit the *named missing
structure* — the precise sense in which $\mathbb Z$ lacks a connected
deformation of $n \mapsto n+1$, and what the minimal substitute would
have to provide (this is METALOOP move 3 executed on the nucleus, and
the only place the corpus's operator object $\mathbb N \rtimes
\mathbb N^\times$ re-enters legitimately: as the integral shadow of that
family). Deliverable: a missing-structure certificate, theorem-shaped —
"any proof of integer Chowla by this route requires an object with
properties P1–P3; no object with P1–P3 exists in categories C (proved);
candidate categories remain D."

## Workstream C: the constraint algebra of patterns (pure combinatorics)

Multiplicativity couples positions: $x(2n) = x(2)x(n)$ ties the sign at
$2n$ to the sign at $n$. The length-$k$ pattern question is a question
about the **constraint system** on windows $\{n+1,\dots,n+k\}$ generated
by the semigroup relations — an exact combinatorial object (which
window positions are multiplicatively coupled, through which primes, at
which scales). Charge: prove structural theorems about this constraint
graph (its expansion, its scale-recursion), and derive pattern-forcing
results *algebraically* where possible. Every length-four sign pattern is
already known to occur with positive lower density; length five is the first
open all-pattern case. Tao--Teräväinen published that at least 24 of 32 occur
at positive upper density, but the Workstream C dependency audit (R0021,
`CONSTRAINT_ALGEBRA`) found a sharp stationary ten-zero countermodel to the
printed nonzero-case orbit step. The 24-pattern conclusion is now an external
claim awaiting a multiplicative or higher-window repair, not a load-bearing
input. This is exactly why the proof must be dependency-audited rather than
treated as one undifferentiated fact.

## Discipline

Numerics appear in these workstreams only as falsifiers of proposed
constructions (a claimed exotic eigenprocess must exhibit its
correlation values exactly; a claimed constraint-forcing must be
replayable). No censuses, no scans, no fits. The registry's certificate
types apply unchanged; the target certificate for A and C is
exact-symbolic, for B a missing-structure certificate per METALOOP §4.2.
