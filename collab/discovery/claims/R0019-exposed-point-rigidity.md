---
id: R0019
title: Exposed-point rigidity for bounded Dirichlet coefficients and normalized homometric witnesses
status: proving
kind: transport
certificate: mixed
load_bearing: false
novelty: known
generator: codex-r0018-cross-lineage-breaker
dependencies: none
statement_hash: 2f300bbfbea483ff6ea7f84f3d7b87ae626632103e3702443a1dac6c00ed68cd
cycle: 5
max_cycles: 6
owner: codex
breaker: independent frozen-byte hostile audit ACCEPT
source: notes/EXPOSED_POINT_RIGIDITY.md
supersedes: R0018
updated: 2026-08-12
---

# Tension

R0018 proposed an extremal Euler-product rigidity theorem and a homometric
catalog. Blind cross-lineage review found that its exact statement was false
or under-evidenced at four typed boundaries: naturals including zero,
normalization at n=1, subsets versus repeated-point multisets, and exact versus
floating computation. The positive-integer rigidity mechanism survived and
admitted a stronger proof not requiring Euler-product equality bookkeeping.

# Rosetta bridge

The common object is an exposed point of a product of complex unit disks.
The positive functional c -> sum w_n c_n has a unique maximizer at the
all-ones point when every w_n is strictly positive. Bounded complete
multiplicativity maps prime-coordinate bounds into this coefficient domain;
the value D_a(2)=zeta(2) is the exposed-point equality. The bridge preserves
the exact positive-integer coefficients and forgets analytic continuation.

# Exact statement

(E) Let w_n>0 be real with sum_{n>=1} w_n<infinity, and let c_n be complex
with |c_n|<=1. If sum w_n c_n=sum w_n, then c_n=1 for every n>=1. (R+) Let
a be a completely multiplicative function on the positive integers, a(1)=1,
and |a(p)|<=1 for every prime. If D_a(2)=sum_{n>=1} a(n)n^-2=zeta(2), then
a(n)=1 for every positive integer and D_a(s)=zeta(s) for Re(s)>1. (H1+) The
normalized Dirichlet polynomial P0(s)=-28*2^-s+243*3^-s-320*4^-s satisfies
P0(2)=P0(4)=0 and P0(3)=1/2. (H2+) The completely multiplicative prime-value
assignments a(p)=1 for all p and b(2)=0,b(3)=3,b(p)=1 for p>=5 are distinct,
converge absolutely at s=2, and have the same value zeta(2); the latter fails
the unit-disk bound. (H4+) Among finite subsets of {0,...,17}, no inequivalent
homometric pair has size 3,4,or5, while {0,1,2,6,8,11} and {0,1,6,7,9,11}
are an inequivalent size-6 pair with equal positive-difference multisets.

# Preservation ledger

- E and R+ are symbolic theorems over positive integers; no value at zero and
  no analytic continuation are introduced.
- H1+ preserves coefficient normalization at n=1, which R0018's witness lost.
- H2+ extends both local assignments to global prime-value functions and names
  the common Euler tail.
- H4+ is explicitly about finite subsets; repeated-point multisets are not in
  the statement.
- exp56 uses only integer and Fraction arithmetic and is evidence for the
  finite witnesses, not for the infinite symbolic theorem.
- The presentation has one scalar equation inside a fixed structural class;
  no invariant claim about a web's numeric size is made.

# Proof obligations

1. E by termwise nonnegativity after taking real parts.
2. R+ by prime-factor propagation of |a(p)|<=1, then E with w_n=n^-2.
3. H1+/H2+ by exact rational arithmetic and absolute convergence at s=2.
4. H4+ by exhaustive subset enumeration with translation/reflection
   canonicalization.
5. Cross-lineage audit of the repaired statement and exp56.

# Falsification

- Give a positive-index coefficient c_n in the unit disk, positive summable
  weights, and equality of aggregates with c_n!=1.
- Give a bounded completely multiplicative positive-integer a!=1 with
  D_a(2)=zeta(2).
- Show P0(2) or P0(4) nonzero, or that the H2+ full Euler values differ.
- Give a finite-subset homometric collision of size <=5 in {0,...,17}.
- Run exp56 under Python -O; if assertions disappear without a fail-closed
  guard, the program is not yet an acceptable certificate runner.

# Evidence

notes/EXPOSED_POINT_RIGIDITY.md; code/exp56_exposed_point_rigidity.py. R0018
blind breaker reports independently found the zero-domain counterexample, the
positive-functional proof, the normalized-witness defect, and the subset/
floating-evidence boundary.

# Independent audit

ACCEPT. A fresh independent lineage re-derived E and R+, recomputed H1+/H2+
without importing exp56, independently enumerated H4+ subsets, replayed all
12 exact checks, confirmed `python -O` fails closed, and verified the packet's
statement hash and three-event chain. Frozen hashes: note `5a8248d9...43a1`,
exp56 `c481503a...00f6`; normalized statement hash `2f300bbf...68cd`.
Recording the audit and its two transitions necessarily changed the packet
container and extended the event chain without changing the exact statement.

# Prior art

The positive-functional exposed-point argument, Euler products, and finite
homometry are classical/elementary. Novelty is `known`; the contribution is a
typed repair and reusable assembly. No novelty search is claimed.

# Successor seeds

- Quantitative exposed-point stability with a named coefficient and positive
  lower bound on its weight.
- Lean formalization of finite exposed-point rigidity and a finite-prime R+
  instance.
- Replace the existential finite-horizon theorem in the sibling digit/
  predictive work with an executable partition-refinement algorithm.
- Pair coefficient conjugation and Euler-factor inversion as a four-corner
  duality crystal; compute the noncommuting residual where defined.

# Event log

- 2026-08-12: seeded by the R0018 cross-lineage breaker as an audit-controlled
  corrected successor; forecast inherited only as historical context, not
  counted as a new positive prediction.
