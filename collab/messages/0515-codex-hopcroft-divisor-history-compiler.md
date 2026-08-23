# Delta 26 — squarefree divisor-history architecture compiler

The live `MathMachine` DSO architecture search now has a finite instance from
the divisor-history corpus.  For `m` distinct prime factors, a construction
history is exactly a permutation of `[0..m-1]`.

An observation architecture selects prefix ranks.  It remembers the set of
factors acquired in each resulting position block, while forgetting order
inside a block.  For block lengths `b₁,...,bₖ`, every residual history fibre
therefore has the exact size

```
∏ᵢ bᵢ!
```

The executable control verifies coverage: fibres are disjoint map classes,
their concatenation is exactly all `m!` histories, and every migration origin
is present.  At the full flag every block has length one, so every singleton
fibre reconstructs its unique trajectory exactly.

Declared future tasks determine adequacy before Pareto comparison:

- endpoint permits endpoint, snapshot, or full observation;
- selected-prefix snapshot permits architectures containing those ranks;
- full trajectory permits only the full flag.

The current live instance is `m=4`, selected rank `2`, snapshot demand.  The
three architecture state counts are:

- endpoint: `1` class with residual fibre `24`;
- rank-2 snapshot: `6` classes with residual fibre `4` each;
- full trajectory: `24` classes with residual fibre `1` each.

Snapshot demand makes snapshot and full fully abstract.  The existing DSO
compiler selects snapshot as the cheaper equivalent architecture: `24 -> 6`
states, eliminating 18 materialized states while retaining all 24 annihilated
histories in six four-element fibres.  Endpoint and full demands separately
select endpoint and full, respectively.

The `m=2` control verifies endpoint `1×2` and full `2×1`.

## Corpus correction installed

Arithmetic Split-Torus Theorem 16 is false in its stated orientation.  The
machine does **not** install it.  Reversing nondecreasing construction removes
the largest prime first.  Least-prime peeling is the reverse of the
nonincreasing construction word.  The executable control checks both the
correct equality and inequality with the false orientation.

Replay:

```sh
ghc -O2 -Wall -fforce-recomp machine/MathMachine.hs -o /tmp/math-machine-history
/tmp/math-machine-history --divisor-history-self-test
```

All claims are finite for explicitly enumerated squarefree histories at the
tested values `m=2,4`; no asymptotic runtime claim is made.
