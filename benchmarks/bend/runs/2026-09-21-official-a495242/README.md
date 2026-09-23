# Official Bend benchmarks — Apple A18 Pro, 21 September 2026

All official workload combinations were attempted at pinned commit `a49524265bdfa5753a4bf38e25f0574a705dd868` (Bend 2.0.25).

- [Every benchmark: workload, what it exercises, and diagnostic value](BENCHMARKS.md)
- [Complete measured results and interpretation limits](results/REPORT.md)
- [Runtime CSV](results/runtime.csv), [checker CSV](results/checker.csv), [native-build CSV](results/compiler.csv)
- [Raw invocation records](results/records.jsonl), [individual logs](results/logs/), [environment](results/metadata.json), [setup repairs](results/toolchain-setup.json), [coverage/source verification](results/verification.json)

**Completed results**

- All 48 Bend runtime combinations matched their expected checksums.
- All five Bend checker workloads succeeded.
- All 16 integrated Bend native builds succeeded after selecting Apple Clang explicitly.
- Across seven runtime modes, 109/112 combinations completed. Bun bitonic/radix hit the task’s sampled 3 GiB RSS guard; Node bitonic exhausted its default JavaScript heap.
- Of 21 supplied checker combinations, 13 completed, five reached the 300-second cutoff, and three Isabelle combinations hit the sampled RSS guard. Four further matrix cells have no source because `compute_1600` is Bend-only.
- Two C floating-point outputs differ under the official flags. Separate full-size runs with only `-ffp-contract=off` added matched both expected checksums.

**Interpretation**

This was a shared, initially battery-powered personal machine, with no CPU affinity or frequency locking. Some toolchain setup overlapped initial runtime/checker measurements. Treat the tables as observed batch execution and resource behavior, not controlled small-percentage rankings. The original BFS four-thread timing was 5.582 s; three later samples of the same binary were 1.478, 1.504 and 1.505 s. That is a concrete warning against interpreting one run as stable performance. Warmup processes do not retain a JavaScript JIT’s state into the separate measured process.

**Reproduction**

Sources, downloaded tools and built binaries remain in `/private/tmp/bend-bench-20260921`. These report files are a durable copy; no existing repository files were changed or staged. The runner can be used from this report directory with that task root:

```sh
BEND_BENCH_TASK_DIR=/private/tmp/bend-bench-20260921 python3 run_benchmarks.py runtime --lanes bend-seq,bend-par,bend-gpu,c,ts-bun,ts-node,lean
BEND_BENCH_TASK_DIR=/private/tmp/bend-bench-20260921 python3 run_benchmarks.py checker --lanes bend,agda,lean,rocq,isabelle
BEND_BENCH_TASK_DIR=/private/tmp/bend-bench-20260921 python3 run_benchmarks.py compiler --lanes build-only
```

Run these sequentially. Re-running appends records, preserves prior logs as separate attempts, and reuses build directories. For fresh-source checker measurements, first use fresh checker working directories, rather than silently reusing `.agdai`/other generated artifacts. The original raw records retain the exact temporary paths and command arguments used. Isolated toolchains and relocation/signature repairs are described in `results/toolchain-setup.json`; the mounted installer is not required by the active Rocq wrapper.
