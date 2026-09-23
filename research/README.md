# Research directory

This directory contains experiment-specific reports, prototypes, data and local build trees.
It is not a single language implementation or a unified benchmark suite.

For the official Bend benchmarks and upcoming comparisons with both cubical forks, start at
[the canonical Bend benchmark home](../benchmarks/bend/README.md). The old
`official_bend_bench_20260921_a495242` path is a compatibility symlink to the preserved run.

The older Haskell/interaction-net Bend compiler currently lives under
`biology_exact/build/toolchain/Bend2-f026483`, with HVM runtimes alongside it. Existing
Unison integration scripts depend on that path. Cubical patches and examples live under
[`collab/bend2-cubical`](../collab/bend2-cubical/README.md). These are distinct from the new
public TypeScript Bend compiler; see the [implementation map](../benchmarks/bend/TARGETS.md).

This index does not relocate or impose a new structure on other active research projects.
