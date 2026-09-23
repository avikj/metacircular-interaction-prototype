# Local setup and reproducibility boundary

The completed task's 14 GiB workspace was moved from `/private/tmp/bend-bench-20260921`
to `benchmarks/bend/local/toolchains/2026-09-21`. The temporary path is now a compatibility
symlink. This keeps the installed tools outside temporary-directory cleanup while preserving
the original raw commands. The old workspace includes downloads, original builds and caches;
it is intentionally ignored by Git. New builds go to `work/<run-id>`.

The local Rocq launcher/findlib configuration and Isabelle settings were updated to the
persistent location. Their original settings and repair record remain in the historical run.
No global tools or settings were changed.

The runner currently supports **macOS arm64**, Apple Clang and Metal. It is not a portable
Linux/CUDA benchmark runner and does not automatically install dependencies on a new machine.
`doctor` verifies source bytes and required launcher availability; it is not a full validation
of every external tool's transitive dependencies. The recorded version pins are in
`suite.lock.json`; current runs also record observed tool versions in metadata.

For a new machine or a relocated checkout, provision `--cache /absolute/path` with:

| Tool/source | Expected relative location | Origin/version |
|---|---|---|
| Official source | `bend-a49524265bdfa5753a4bf38e25f0574a705dd868/` | `https://github.com/bendlang/bend`, pinned commit in lockfile |
| Bun | `bun-darwin-aarch64/bun` | oven-sh/bun release `bun-v1.4.2` |
| Node | `node-v24.21.0-darwin-arm64/bin/node` | nodejs.org release `v24.21.0` |
| Lean | `lean-4.34.0-darwin_aarch64/bin/lean` and `leanc` | leanprover/lean4 release `v4.34.0` |
| Rocq | `rocq-bin/rocq` launcher | Rocq Platform `2026.07.0`, Rocq `9.1.0` |
| Isabelle | `isabelle-bin/isabelle` launcher | Isabelle2025-2 macOS distribution |
| Agda | `/opt/homebrew/bin/agda` | `2.8.0.1`, existing installation |
| C compiler | `/usr/bin/clang`, `/usr/bin/cc` | Apple developer tools; baseline Clang 21 |

Rocq also uses the extracted `Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/`
tree. Its launcher must set findlib/library paths for the selected cache. Isabelle must use
a writable local user/cache directory. Update those absolute paths after relocating a cache.
See the preserved [setup repair record](runs/2026-09-21-official-a495242/results/toolchain-setup.json)
and [Isabelle patch](runs/2026-09-21-official-a495242/isabelle-local-settings.patch).
The original Rocq distribution required task-local signature repairs; retain that provenance
instead of presenting the installed bytes as pristine upstream binaries.

Source verification checks all locked `bench/` and `bend2/` files, including unexpected files.
Use a pristine source extraction, not a compiler checkout with generated artifacts.
Tool archives are retained locally, but are not vendored in Git. Consequently a Git clone
alone is sufficient to inspect the evidence and harness, **not** to run every language tool
without installing dependencies. Automated clean-machine provisioning remains future work.
