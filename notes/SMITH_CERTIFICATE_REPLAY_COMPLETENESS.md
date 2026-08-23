# The full Smith certificate determines the complete installed trace

The preceding family calculation suggested searching for two distinct Smith
operation traces with the same final transformation certificate.  For the
installed deterministic reducer, that search is impossible for a structural
reason.

Every returned certificate satisfies

`L A R = D`,

with `det L, det R` in `{−1,1}`.  Therefore

`A = L^{-1} D R^{-1}`.

The inverses are integral and unique.  Thus the map from source matrices to
full certificate triples `(L,D,R)` is injective.  Since the installed reducer
is a deterministic function of its source, its entire sequence of typed
residuals, quotients, and intermediate matrices is also a function of
`(L,D,R)`: reconstruct `A`, then rerun the reducer.

## Theorem

For arbitrary integer two-by-two source matrices—including signed, singular,
and zero matrices—the full certificate returned by `smith_reduce` uniquely
determines both the source and the complete installed reduction trace.  Hence
no two installed histories have the same `(L,D,R)`.

The proof uses only certificate validity, unimodularity, and determinism.  It
does not depend on a finite scan or on uniqueness of Smith normal form
decompositions in general.  Many valid triples can represent one source; the
canonical triple produced by this installed algorithm nevertheless identifies
that source, and rerunning identifies its canonical trace.

## Quantum/process correspondence

On the computational basis, the certificate map

`|A> -> |L_A,D_A,R_A>`

is injective and therefore extends to an isometry on its span.  No additional
environment is required to preserve source distinguishability.  The
intensional operation trace may be uncomputed after the extensional
transformation certificate is formed, because it is recoverable by reversible
recomputation from that certificate.

This trades retained space for replay time; it does not erase computational
work.  It also depends on preserving the exact transformation witnesses.  If
only the Smith diagonal `D` is retained, large and unbounded fibers return.

## Decisive no-go and changed motion

Do not search for irreducible transcript collisions behind the full
`(L,D,R)` output of this deterministic reducer: algebra rules them out.  Stop
building operation-log memory for this process unless a consumer explicitly
requires low-latency replay rather than information-theoretic recoverability.

The next mathematical move must change one premise:

- quotient the transformation certificate and compute the resulting fibers;
- admit nondeterministic or alternative reduction strategies and ask which
  strategy information survives a common extensional certificate; or
- price time/space tradeoffs for recomputation.

The quantum/process line should take the first option only when a native
consumer actually discards part of `(L,D,R)`.  Otherwise this branch is
closed.

## Scope

This is an information and exact-replay theorem for the installed deterministic
two-by-two Smith reducer.  It is not a lower bound on time, gates, energy, or
fault tolerance, and not a uniqueness theorem for arbitrary Smith
factorizations.
