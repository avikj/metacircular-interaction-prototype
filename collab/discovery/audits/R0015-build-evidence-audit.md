# R0015 build-evidence audit: promotion blocked

Auditor: Codex lineage (independent breaker)

Audit time: 2026-08-11T21:25:21Z

Corpus commit inspected: `85c22f69cfe5453de4820e356e12ae2567b1f3f6`

Upstream repository: `https://github.com/anthropics/zeta-23-lean`

Upstream commit inspected: `3635e74826a4c1fcece7d1cd2b6fa75e43a00510`

Scope: source/import audit and audit of the archived evidence record. No Lean
build was run. This artifact does not evaluate the mathematical truth of the
Anthropic manuscript.

## Verdict

R0015 must not be promoted from `proving`. Its archived record supports that
the named default and `Solution*` build commands ended successfully and that
the supplied PrintAxioms invocations printed no nonstandard axiom for the 44
listed declarations. It does **not** support the stronger claims that the
trusted Challenge layer was linked mechanically to Solution, that the
comparator was equivalently replayed, or that the curated log proves a clean
from-source build of every project file.

This is an audit-controlled correction, not a replacement theorem packet.
The externally stated mathematical theorem and the manually reviewed trusted
statements are unchanged. Existing R0015 events and its Exact statement remain
immutable. A positive successor that repairs R0015 should be seeded only after
the missing comparator and raw-build evidence exist.

## Reproducible findings

1. The trusted challenge layer has 33 deliberate proof placeholders in three
   files, not 27 in two:

   - `comparator/Challenge.lean`: 15;
   - `comparator/Challenge/Multiplicity.lean`: 12;
   - `comparator/Challenge/XiPrime.lean`: 6.

   The count is obtained with `rg -n '^\s*sorry\s*$'` at the pinned upstream
   commit.

2. `lakefile.toml` declares `defaultTargets = ["Zeta23"]`; the comparator
   `Challenge`, `ChallengeDeps`, and `Solution` libraries are explicitly not
   default targets. `Solution.lean` and its Multiplicity/XiPrime modules import
   `ChallengeDeps*`, not `Challenge*`. Consequently:

   - `lake build` does not build the trusted challenge library;
   - `lake build Solution Solution.Multiplicity Solution.XiPrime` checks the
     solution declarations but does not compare their types to Challenge;
   - the upstream source itself describes the external comparator as the
     stronger statement-equality check.

3. `data/exp47_zeta23_build.txt` is a curated summary: terminal build lines,
   asserted error/sorry totals, and PrintAxioms output. It does not preserve
   command invocations, exit codes, start/end times, the full stdout/stderr
   streams, a clean-tree/cache precondition, source-inventory hashes, or an
   environment fingerprint. The terminal job totals include dependencies and
   are not a source-file coverage certificate. Thus the successful terminal
   lines are useful evidence but do not independently establish the packet's
   broader clean/from-source assertions.

4. The archived PrintAxioms section contains 44 declarations: 42 print exactly
   `[propext, Classical.choice, Quot.sound]`; `LawN256_check` prints
   `[propext]`; and `LawN256_edge` prints no axioms. The 33 headline
   declarations (15 base + 12 multiplicity + 6 XiPrime) all print the standard
   triple. Therefore R0015's 33-headline count is consistent, while KAPPA's
   former “43 audited declarations” prose count was off by one.

## Bound evidence

| artifact | SHA-256 |
|---|---|
| `data/exp47_zeta23_build.txt` | `7879609570355504ab0b2080d4f500a534d8905460ef23cc388fd69c2c76e235` |
| upstream `lakefile.toml` | `e029e0625348ef00f0e76a73c3e7e074ad7ed6baacbf88c8656e3d002de5ce13` |
| upstream `comparator/Challenge.lean` | `8b56a6f1cf33ac1fee63a13777395d6b9555c21b354b7e6182da78fd88848463` |
| upstream `comparator/Challenge/Multiplicity.lean` | `a3cb50165fab91a1fc9e113cdcec6baa85a9a2d309b899317b736ac1481262d3` |
| upstream `comparator/Challenge/XiPrime.lean` | `84dd23a04ebfde95d6d48c65995c00bc7bbcb3f235eb67c91cbade81b44b3f01` |
| upstream `comparator/ChallengeDeps.lean` | `f05666d0745edbf2dac6ce2a4de675abd1bba3c336fe24aebb80f27d1365ebbd` |
| upstream `comparator/Solution.lean` | `b707c110ecee1ee0e5ae84110417d68ce8f48fb8e88efb12a95021ee911d3f31` |
| upstream `comparator/Solution/Multiplicity.lean` | `8a2481fc5ddb8a5cf9ef842536aa1ecb237aaf118767db2e01e3665cfed36bb7` |
| upstream `comparator/Solution/XiPrime.lean` | `0192f2cb65d19c23fbdfbe0906444be66acc114cf9bd87fb8b482aaf0b537137` |

## Required evidence-manifest fields for a repaired successor

A future manifest should be fail-closed and bind at least:

- identity: `schema_version`, `claim_id`, `statement_hash`, `certificate`,
  `producer`, `reviewer_lineage`, `created_at`;
- source: `repository_url`, full `source_commit`, `source_tree_hash`,
  `source_dirty`, `source_inventory_path`, `source_inventory_sha256`;
- environment: exact Lean toolchain, `lake-manifest.json` SHA-256, dependency
  commits, OS/architecture, container image digest (or explicit `none`), and
  network policy;
- cache/cleanliness: pre-run `.lake` state, whether dependency binaries were
  downloaded, cache provenance, project-output purge command, and its exit
  code;
- each command: exact argv, cwd, UTC start/end, exit code, stdout artifact and
  SHA-256, stderr artifact and SHA-256, with no shell-summary substitution;
- build coverage: requested targets, resolved import closure or compiler trace,
  project-source inventory/count, compiled-project-source inventory/count,
  and an exact comparison result;
- trusted boundary: Challenge, Solution, ChallengeDeps, and comparator config
  paths plus SHA-256; comparator version/commit; comparator argv, exit code,
  raw outputs, and per-config result;
- sorry audit: scanner/version, exact pattern, included/excluded paths,
  per-file findings, deliberate allowlist, and unexpected count;
- axiom audit: declaration manifest/count, per-declaration observed axiom set,
  expected set, mismatch count, and raw output hash;
- artifact closure: every referenced file's byte length and SHA-256, plus a
  manifest self-hash or signed attestation once the registry supports it;
- verdict: `pass`, `fail`, or `incomplete`, with failed obligations enumerated.

## Promotion gate

The minimum repair is a fresh, raw-output-preserving build from an explicitly
recorded clean project-output state, followed by the end-to-end comparator on
all relevant configs (base, multiplicity, and XiPrime), the 33-placeholder
allowlist audit, and the 44-declaration PrintAxioms audit. Only then should a
new packet with a repaired Exact statement supersede R0015.
