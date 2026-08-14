# Balanced rooted reweaving: the lower bound and the finite fusion exit

**Status:** safe-Agda checked construction plus native measurement.  The
complexity argument below is an ordinary proof; wall-clock figures are
measurements, not theorems.

## Forecast registered before implementation

Outcome space: balancing either (a) reduces the number of constituent maps a
read must execute, (b) only reduces evaluator depth, or (c) adds overhead with
no structural gain.  Prediction: (b); arbitrary opaque maps cannot be fused.
For a finite carrier, prediction: eager tabulation moves work from reads to
updates and becomes favorable when versions are read repeatedly.

## The exact representation

`formal/executable/BalancedReweave.agda` represents a sequence of endomorphisms
as binary digits.  An occupied digit of rank `r` holds a perfect tree of
`2^r` maps.  The type `PlanFrom A r` permits at most one tree at every rank;
there is no separately trusted balance predicate.  Insertion is binary carry:

```text
empty rank       -> install one tree
occupied rank    -> join equal-rank trees and carry
```

The checked theorem `insertTree-sound` states pointwise that inserting a tree
is exactly precomposition by that tree.  `push-sound` is its one-map instance,
and `update-read` connects it to rooted profiles.  Therefore balancing changes
evaluation shape without changing the rooted reflection.

After `k` pushes, there are at most `floor(log2 k)+1` occupied digits and every
tree has height at most that quantity.  A push performs one operation plus one
carry for each trailing `1` in the binary expansion of `k`.  Hence:

- worst-case push time is `O(log k)`;
- total carries in `k` pushes are less than `k`, so amortized push time is
  `O(1)`;
- representation space is `Theta(k)` because the history is persistent;
- one read executes all `k` opaque maps, hence takes `Theta(k)` work;
- the balanced evaluator's structural depth is `O(log k)`, versus `Theta(k)`
  for the linear control.

The last distinction is load-bearing.  A balanced composition tree does not
make composition disappear.

## Why a generic faster read is impossible

Treat each stored endomorphism as an oracle.  Suppose a purported exact read
does not query map `f_i` on the value reaching it.  Replace only that oracle by
a map which agrees on every queried input but changes that unqueried value,
and let every later map preserve the difference.  The true composite changes
while the purported read's observation does not.  Thus an exact worst-case
algorithm must, absent additional algebraic information, inspect every map
that can affect the result: `Omega(k)` oracle applications.

This kills the proposed generic `1000x` acceleration.  It also names the
missing coordinate: a finite carrier, a fusible algebra, or a memoized query
distribution.

## Finite fusion

For a finite state set `X`, normalize a composite endomorphism to its complete
table.  Given the old table `T` and new precomposition `f`, form

```text
T'[x] = T[f(x)]  for every x in X.
```

On a random-access table this costs `Theta(|X|)` per persistent update and
`Theta(1)` per read, using `Theta(|X|)` additional space per version.  Compared
with a chain of length `k`, built once and read `q` times, the simple cost model
is

```text
chain: k updates + q k map applications
table: k |X| table operations + q lookups.
```

Ignoring machine constants, tabulation wins when
`q(k-1) > k(|X|-1)`.  It is especially strong for small state spaces and many
reads; it can lose badly for large state spaces or versions that are never
queried.

The Agda module gives the exact two-state instance.  `BoolTable` stores both
outputs.  `composeBoolTable-sound`, proved by the two Boolean cases, relates
eager table composition to ordinary composition.  `updateFusedBool-read`
connects that normalization to rooted profiles, and `fused-balanced-flip`
proves that the fused and history-preserving representations execute the same
sequence of local flips at every input.  After each update the fused profile
retains two values, not a history chain: update and read are both worst-case
`Theta(1)` for this fixed carrier.

## Native measurement

Command on Apple Silicon, GHC 9.12.2, Agda 2.8.0, `-O2` driver:

```sh
machine/run-balanced-reweave-bench.sh 10000 100000 500000
```

One observed run (milliseconds, including construction and one read):

| updates | linear Nat | balanced Nat | balanced Bool | fused Bool |
|---:|---:|---:|---:|---:|
| 10,000 | 0.754 | 0.579 | 0.791 | 0.233 |
| 100,000 | 7.342 | 13.903 | 10.641 | 2.740 |
| 500,000 | 66.077 | 150.081 | 113.369 | 16.058 |

The balanced generic representation was about `2x` slower than the linear
control at the larger sizes; it buys logarithmic structural depth, not fewer
map applications.  The two-state fused instance was about `7x` faster than
the balanced Boolean chain at 500,000 updates.  This is not a `1000x` result,
and a single run is not a stable performance estimate.  The benchmark's
purpose is falsification: it prevents an asymptotic stack improvement from
being advertised as a throughput improvement.

## Rigor boundary

Checked with `agda --safe`: semantic preservation of binary carry, rooted
updates, Boolean tabulation, Boolean composition, and fused/balanced flip
agreement.  Proved here on paper: binary-counter complexity, the oracle lower
bound, and the finite-table cost equation.  Measured only: native timings.
General constant-time table lookup assumes a RAM array backend and is not
claimed for Agda's inductive vectors.  No claim is made that arbitrary rewrite
languages admit finite tabulation or algebraic fusion.

## Adaptive online selection

`AdaptiveMode` now makes the choice executable rather than advisory.  A lazy
mode carries `(plan,k,q)`, where `k` is its chain length and `q` counts reads in
the current write epoch.  Every write extends the plan and resets `q`, because
reads paid before the write used a different chain length.  After a read, the
two-state specialization switches exactly when

```text
k < q * (k - 1),
```

the `|X|=2` instance of `q(k-1) > k(|X|-1)`.  This is an online ski-rental
threshold: past lazy reads pay for the decision; subsequent reads receive the
fused representation.  A fused update remains fused.

The representation change is not observational.  `readMode-value` proves the
returned value equals the pre-read mode semantics.  `readMode-next` proves the
returned mode has the same behavior at every next input.  `updateMode-sound`
proves writes commute with interpretation.  The rooted wrapper exports the
same laws as `readAdaptiveBool-value` and `updateAdaptiveBool-sound`.

The extracted rooted runtime exercises the boundary after 100 writes:

```text
adaptive fusion after 100 writes: read1=false read2=true
```

Here `false`/`true` report the representation, not the mathematical
observation: one read remains lazy; the second crosses `100 < 2*99`.

The benchmark also executes identical mixed workloads through always-lazy,
adaptive, and always-fused strategies and rejects any disagreement.  One
native run gave:

| epochs | writes/epoch | reads/epoch | lazy ms | adaptive ms | fused ms |
|---:|---:|---:|---:|---:|---:|
| 100 | 100 | 1 | 10.160 | 9.454 | 0.178 |
| 100 | 100 | 4 | 32.355 | 0.788 | 0.194 |
| 20 | 1,000 | 100 | 332.180 | 1.557 | 0.373 |
| 10 | 1,000 | 2,000 | 1,689.556 | 2.185 | 0.336 |

The last adaptive/lazy ratio is about `773x`; it is a workload-specific
measurement, not a universal acceleration factor.  Always-fused wins these
two-state workloads because its table has only two entries.  Adaptation exists
for the general situation where table construction and persistent table space
are not effectively free; this Boolean instance validates the switching law
and extraction path, not that broader engineering tradeoff.

## Prior-art boundary

The binary-digit forest is the standard binary random-access-list technique
associated with persistent functional data structures; it is not novel.  The
local configured `~/agda-libs/` path was absent, and repository searches for
`binary random access list`, `skew binary`, and `perfect tree` found no prior
implementation.  No external novelty claim is made.
