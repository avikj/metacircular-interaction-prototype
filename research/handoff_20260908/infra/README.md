# Native execution entry points

The standalone `preflight.sh` is nonmutating. It records the working tree, source pin, installed tools, library registrations and case-sensitive kernel paths. It neither installs dependencies nor runs tests. Review its output and the repository's own current scripts before choosing a build.

The comparison pin is Agda 2.8.0 / Cubical v0.9. `sh setup --report` installs nothing. A full `sh setup` can install large dependencies and, in the historical script, changes Cabal index-signature settings; inspect and authorize that explicitly in the receiving environment.

## Suggested smoke invocation, after the current tree and tools are verified

Use a fresh session-scoped output directory so the runtime does not replace an existing research defect log:

```sh
OUT="$(mktemp -d "${TMPDIR:-/tmp}/mip-yantra-smoke.XXXXXX")"
export LC_ALL=C.utf8
export YANTRA_OUT="$OUT/build"
export DOSA_LEKHA="$OUT/session.lekha"
export YANTRA_LEKHA="$OUT/wire-transcript.jsonl"
export MATH_CERTCACHE=0
# From the repository root; use the absolute path to this handoff's requests.
sh interactive/run-yantra.sh --wire < /path/to/handoff/infra/smoke_requests.jsonl \
  > "$OUT/stdout.log" 2> "$OUT/stderr.log"
STATUS=$?
printf '%s\n' "$STATUS" > "$OUT/exit.txt"
```

The launcher may print a build banner before wire JSON; retain it and parse the actual response records rather than assuming every stdout line is a response. The launcher has a historical working-tree/HEAD fallback. Record which tree actually ran and which files were excluded; do not silently accept a fallback green as a check of all current edits.

`smoke_requests.jsonl` calls:
1. `yantra.kriyah` to read the live capabilities, not infer them from documentation;
2. `sadhana.patra` with a repository-native arithmetic normalizer theorem;
3. `sadhana.vislesana` to obtain actual normal forms/types for the term, its derivation and installed operation;
4. `yantra.sthiti` to preserve session output.

This is not a new NS/RH proof. It establishes that the native interfaces actually run. The gate's built-in false controls must be observed before any successful theorem is treated as evidence. `false_candidate.jsonl` is an additional explicit rejection test; submit it only to a test session. Do not add the false module to a positive aggregate root.

No command in this handoff has been executed against Yantra/Agda here. The requested receiving agents have the infrastructure and must record their own commands and evidence.
