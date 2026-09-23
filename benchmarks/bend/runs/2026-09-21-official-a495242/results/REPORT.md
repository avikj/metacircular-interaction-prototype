# Official Bend benchmark results on this machine

**Coverage:** 109/112 runtime combinations completed successfully; 13/21 supplied checker combinations completed successfully. Four checker combinations have no official source (`compute_1600` is Bend-only).

Runtime status: `{'ok': 109, 'memory_limit_3GiB': 2, 'error': 1}`.

**Environment and scope**

- Source: `a49524265bdfa5753a4bf38e25f0574a705dd868`, Bend 2.0.25.
- Apple A18 Pro, 8 GiB RAM, two performance cores plus four efficiency cores; macOS 26.6.
- Bend CPU modes: one thread and four threads. Four matches the official chart runner’s power-of-two rule; it is not an all-six-core configuration. GPU: Metal, original per-case memory settings.
- Toolchains: Bun 1.4.2, Node 24.21.0, Apple clang 21.0.0, Lean 4.34.0, Agda 2.8.0.1, Rocq 9.1.0, Isabelle2025-2. Per-tool versions and setup are recorded in the metadata/logs.
- Unmodified full-size official workload files. One separate-process warmup then one measured runtime process; checker runs use fresh source directories. Builds are logged separately, outside runtime times.
- Shared machine: other agents and desktop services remained active. Toolchain downloading/unpacking overlapped some initial runtime and checker runs. No CPU affinity, frequency locking or thermal stabilization. These are observations, not isolated performance rankings.
- The machine began on battery power at 84% charge. Power settings were not altered; before/after battery and memory snapshots are included.
- Parent monotonic wall clock includes process launch/exit and the `/usr/bin/time` wrapper. The latter also records CPU time and peak process RSS. GPU memory is not fully described by host RSS.
- One benchmark process at a time. A watchdog samples process-group RSS every two seconds and terminates only that benchmark above 3 GiB or after 600 seconds (runtime) / 300 seconds (checker). Any such stop is labeled; it is not a measured completion time.
- Source integrity: 89 benchmark/pin files hashed before execution; changed files: `[]`.

**Runtime — elapsed seconds**

| Workload | Bend 1 CPU | Bend 4 CPU | Bend GPU | C | TS/Bun | TS/Node | Lean |
|---|---:|---:|---:|---:|---:|---:|---:|
| bfs | 5.888 | 5.582 | 0.822 | 6.602 | 18.345 | 13.201 | 16.359 |
| editdist | 3.049 | 1.472 | 1.244 | 2.807 | 8.198 | 12.733 | 9.911 |
| gameoflife | 12.626 | 4.807 | 0.211 | 21.380 | 104.947 | 21.857 | 16.576 |
| hashmap | 2.932 | 1.141 | 1.650 | 0.718 | 1.040 | 1.171 | 1.656 |
| kmeans | 2.646 | 1.205 | 0.692 | 2.590 | 21.172 | 40.281 | 7.139 |
| lexer | 2.978 | 1.316 | 4.334 | 1.286 | 4.629 | 5.653 | 5.535 |
| mandelbrot | 5.009 | 1.817 | 0.117 | 4.221 | 4.969 | 3.752 | 5.105 |
| merkle | 5.130 | 1.899 | 0.154 | 3.761 | 9.181 | 8.464 | 7.202 |
| nbody | 7.405 | 2.558 | 0.115 | 5.966* | 6.479 | 16.546 | 8.780 |
| queens | 8.340 | 2.440 | 4.625 | 4.262 | 8.973 | 10.652 | 9.248 |
| raytrace | 5.234 | 2.186 | 0.767 | 4.387* | 29.291 | 65.653 | 13.791 |
| symreg | 3.460 | 1.395 | 1.067 | 2.593 | 7.555 | 7.507 | 2.812 |
| terrain | 2.587 | 1.048 | 0.533 | 2.502 | 26.304 | 6.648 | 9.981 |
| tree-bitonic | 8.181 | 3.601 | 2.598 | 7.371 | RAM limit | JS heap OOM | 44.280 |
| tree-matmul | 2.807 | 1.329 | 0.972 | 3.741 | 18.963 | 18.531 | 10.044 |
| tree-radix | 4.412 | 1.692 | 1.449 | 3.144 | RAM limit | 12.736 | 7.346 |

*C rows marked with an asterisk contain F32 in the Bend source. As in the official runner, C output equality is not enforced for these cases because floating-point code generation can change the final checksum. The raw output and whether it matched are retained in runtime.csv and records.jsonl. Every other completed runtime cell must match the official checksum.*

**Checker — elapsed seconds**

| Workload | Bend | Agda | Lean | Rocq | Isabelle |
|---|---:|---:|---:|---:|---:|
| defs_12800 | 0.513 | >300 | 48.201 | 2.764 | >300 |
| generics_3200 | 0.594 | >300 | 27.443 | 6.400 | RAM limit |
| proofs_3200 | 1.321 | >300 | >300 | 9.256 | RAM limit |
| trees_400 | 0.950 | 4.283 | 3.179 | 1.462 | RAM limit |
| compute_1600 | 1.110 | — | — | — | — |

Checker invocations time the entire tool process, including frontend and elaboration/build work. They do not isolate comparable proof kernels. “Fresh source directory” does not mean flushed OS caches. The prover encodings and required work differ.

**Observed warmup/measurement variation**

| Workload | Lane | Warmup seconds | Measured seconds | Larger/smaller |
|---|---|---:|---:|---:|
| gameoflife | bend-gpu | 1.430 | 0.211 | 6.78× |
| nbody | bend-gpu | 0.702 | 0.115 | 6.13× |
| hashmap | c | 3.887 | 0.718 | 5.41× |
| mandelbrot | bend-gpu | 0.572 | 0.117 | 4.88× |
| editdist | bend-gpu | 5.273 | 1.244 | 4.24× |
| merkle | bend-gpu | 0.571 | 0.154 | 3.72× |
| bfs | bend-gpu | 2.570 | 0.822 | 3.13× |
| bfs | bend-par | 1.856 | 5.582 | 3.01× |
| tree-matmul | bend-gpu | 2.189 | 0.972 | 2.25× |
| kmeans | bend-gpu | 1.559 | 0.692 | 2.25× |
| tree-bitonic | bend-gpu | 5.407 | 2.598 | 2.08× |
| raytrace | bend-gpu | 1.406 | 0.767 | 1.83× |

Warmups are not statistically equivalent repetitions: first GPU execution can compile/cache a shader, and filesystem/cache state differs. Large CPU warmup/timed gaps nevertheless show why single-run rankings on this machine need caution.

**Failures and limits**

- runtime/tree-bitonic — ts-bun: **memory_limit_3GiB** during timed. Observed wall time 38.281 s. See raw stderr/stdout logs.
  Sampled peak process-group RSS: 3603.7 MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory.
- runtime/tree-bitonic — ts-node: **error** during warmup. Observed wall time 52.335 s. See raw stderr/stdout logs.
  Node reported “JavaScript heap out of memory” under its default heap configuration. No larger heap flag was substituted into the official comparison.
- runtime/tree-radix — ts-bun: **memory_limit_3GiB** during warmup. Observed wall time 6.059 s. See raw stderr/stdout logs.
  Sampled peak process-group RSS: 3180.8 MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory.
- checker/defs_12800 — agda: **timeout** during timed. Observed wall time 300.185 s. See raw stderr/stdout logs.
- checker/defs_12800 — isabelle: **timeout** during timed. Observed wall time 301.082 s. See raw stderr/stdout logs.
- checker/generics_3200 — agda: **timeout** during timed. Observed wall time 300.099 s. See raw stderr/stdout logs.
- checker/generics_3200 — isabelle: **memory_limit_3GiB** during timed. Observed wall time 10.082 s. See raw stderr/stdout logs.
  Sampled peak process-group RSS: 3093.7 MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory.
- checker/proofs_3200 — agda: **timeout** during timed. Observed wall time 300.174 s. See raw stderr/stdout logs.
- checker/proofs_3200 — lean: **timeout** during timed. Observed wall time 300.249 s. See raw stderr/stdout logs.
- checker/proofs_3200 — isabelle: **memory_limit_3GiB** during timed. Observed wall time 8.065 s. See raw stderr/stdout logs.
  Sampled peak process-group RSS: 3107.7 MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory.
- checker/trees_400 — isabelle: **memory_limit_3GiB** during timed. Observed wall time 14.188 s. See raw stderr/stdout logs.
  Sampled peak process-group RSS: 3337.2 MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory.

**Floating-point output diagnostic**

The original C timings above use the official `cc -std=c11 -O3` flags. Separate full-size validation runs add only `-ffp-contract=off`; their timings are not substituted into the main table.
- nbody: ok; output `3516450380`; expected `3516450380`; match = `True`.
- raytrace: ok; output `1924309504`; expected `1924309504`; match = `True`.

**BFS follow-up samples after toolchain setup**

The same compiled binaries and full workload were run three more times per CPU mode. These are separate diagnostic observations; they do not replace the original table values or constitute an isolated experiment.

| Mode | Three elapsed times (s) | Median (s) |
|---|---|---:|
| bend-seq | 4.307, 4.279, 4.241 | 4.279 |
| bend-par | 1.478, 1.504, 1.505 | 1.504 |

**End-to-end Bend compiler — elapsed seconds**

The same full native-build command used by the official gate is run twice per workload, timing the second separately from execution. This includes Bend frontend/code generation and native compilation; it is not just time spent in the Bend compiler implementation.

| Workload | Native build seconds |
|---|---:|
| bfs | 0.587 |
| editdist | 0.667 |
| gameoflife | 0.604 |
| hashmap | 0.595 |
| kmeans | 0.670 |
| lexer | 0.651 |
| mandelbrot | 0.670 |
| merkle | 0.736 |
| nbody | 0.810 |
| queens | 0.655 |
| raytrace | 0.757 |
| symreg | 0.675 |
| terrain | 0.693 |
| tree-bitonic | 0.613 |
| tree-matmul | 0.711 |
| tree-radix | 0.654 |

**Toolchain setup and retries**

The first integrated Bend native-build attempts selected Lean’s bundled Clang 22 from PATH and failed against Apple SDK modules. Corrected attempts explicitly select `/usr/bin/clang`, the Apple compiler used by the successful runtime builds. Rocq’s binary package required local library-path configuration and refreshed ad-hoc signatures for its worker/GMP dependency; its archive digest matched the official release. These changes affect only the temporary toolchain installation. Benchmark sources remain unchanged. Initial failures and subsequent attempts are retained in records.jsonl and separate log files. See [setup details](toolchain-setup.json).


**Files**

- [Every benchmark explained](../BENCHMARKS.md)
- [Runtime data](runtime.csv)
- [Checker data](checker.csv)
- [Native compiler data](compiler.csv)
- [Every invocation, command, timing, output and status](records.jsonl)
- [Hardware, methodology and source hashes](metadata.json)
- [Reproduction runner](../run_benchmarks.py)

Run from the task directory: `python3 run_benchmarks.py runtime --lanes bend-seq,bend-par,bend-gpu,c,ts-bun,ts-node,lean`, then `python3 run_benchmarks.py checker --lanes bend,agda,lean,rocq,isabelle`. The downloaded toolchain directories are prerequisites. Re-running appends records and can reuse working files; for a strict cold-source checker repeat, create fresh checker working directories first.
