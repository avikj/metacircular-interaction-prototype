# Bend benchmarks

This is the canonical home for this benchmark campaign. Start here, rather than searching
the research experiments or guessing which directory named Bend2 is the compiler.

- [Implementation map and comparison requirements](TARGETS.md)
- [All 21 workloads and what each measures](runs/2026-09-21-official-a495242/BENCHMARKS.md)
- [Original official baseline results](runs/2026-09-21-official-a495242/results/REPORT.md)
- [Run index, including organization smoke tests](runs/README.md)
- [Toolchain setup and portability limits](SETUP.md)
- [Exact official source and tool versions](suite.lock.json)

## Directory contract

| Location | Purpose | Preserve in Git? |
|---|---|---|
| `bench.py`, `lib/engine.py` | Current entry point and measurement implementation | Yes |
| `suite.lock.json` | Upstream commit, source hashes and tool versions | Yes |
| `runs/2026-09-21-official-a495242/` | Original report, raw evidence and original scripts, unchanged | Yes |
| `runs/<UTC>-official-<unique-id>/` | New report, CSV, manifest, raw logs, harness snapshot | Yes |
| `local/toolchains/2026-09-21/` | Machine-local downloaded tools and original task workspace | No |
| `work/<run-id>/` | Fresh source copy, generated code, binaries and checker intermediates | No |

The historical folder retains its original internal layout and temporary paths as evidence.
Its old `research/official_bend_bench_20260921_a495242` location is a compatibility symlink.
`historical-files.sha256.json` inventories every historical file before relocation.
The local `.gitignore` explicitly includes raw `.jsonl` and `.log` evidence despite the
repository-wide ignore rules. Nothing has been committed automatically.

## Run on this machine

From the repository root:

```sh
python3 benchmarks/bend/bench.py doctor
# Short real checker validation:
python3 benchmarks/bend/bench.py run --suite checker --lanes bend --only defs_12800
# Complete official matrix, sequentially (can take hours):
python3 benchmarks/bend/bench.py run --suite all
# Repeated fresh observations, for example:
python3 benchmarks/bend/bench.py run --suite runtime --lanes bend-seq,bend-par --repetitions 3
```

Every invocation creates a new run ID. `--repetitions` creates separate independent run
directories. There is no append/resume/overwrite mode. Builds and checker source directories
are fresh for each run; source hashes are verified before and after copying. A lock prevents
two campaigns using the same cache concurrently. Other agents' processes remain untouched.

Runtime/build measurements retain the baseline protocol: one fresh-process warmup and one
measured process, full-size inputs, expected-output checking, 600-second runtime timeout,
300-second checker timeout, sampled 3 GiB process-tree RSS guard. C floating-point outputs
are recorded but not enforced, matching the original campaign. Compiler suite measures all
16 integrated native builds; the historical FMA/BFS diagnostics are not part of each rerun.
Non-successful invocations remain in the report and produce a nonzero campaign exit code.

`REPORT.md` and `invocations.csv` are derived from the raw `records.jsonl`; the manifest
records run selection, paths, platform, Python and harness hashes. `metadata.json` captures
hardware, compiler/Bun/Node/Agda versions and workload hashes. Each run saves the harness
and lockfile used. The original detailed historical report is not regenerated or rewritten.

These are still shared-machine measurements. Fresh build directories do not flush OS caches,
lock clocks, stabilize temperature or eliminate other agents' load. Isabelle uses a shared
tool installation/user cache (its invocation uses `build -c`). Separate JS warmup processes
do not preserve JIT state. For fork comparisons, rerun the baseline alongside the forks,
interleave repetitions, and compare distributions rather than the old single observations.

## What is ready next?

The official campaign is rerunnable here. Both fork directories were located on `origin/claude/metacircular-interaction-prototype-ly3qjn`, not this working branch. Their identities and compatibility work
are tracked in [TARGETS.md](TARGETS.md). Fork adapters and full fork campaigns are **not yet
implemented/run**. In particular, the old interaction-net language must not silently receive
new public Bend programs and be treated as the same experiment.
