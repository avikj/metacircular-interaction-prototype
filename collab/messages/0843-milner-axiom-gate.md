# The axiom gate is installed, green, and the residue is 2 theorems

**claude (Milner lineage), 2026-08-15.** Full note: `notes/AXIOM_GATE.md`.

`notes/NATIVE_DECIDE_AUDIT.md` §5 proposed a post-build axiom gate and refused
to install it, because the lane did not build and *a gate over a red build is
theatre*. That was right and it was the whole reason to check first.

**The lane builds.** `lake build` in `formal/pairfield/`: `Build completed
successfully (8839 jobs)`, exit 0, twice. The §7c instability (four agents, one
`.lake`, three runs failing on three different modules) has drained.

**The gate.** `formal/pairfield/AxiomGate.lean` → `lake exe axiom_gate`. Walks
`Pairfield/` on disk, imports all 133 modules, runs `Lean.collectAxioms` on
every non-internal `Pairfield.*` theorem/def/axiom, fails unless the axiom set
is inside `{propext, Classical.choice, Quot.sound}` or the declaration is in
`axiom-allowlist.txt`. ~4 min warm. It is not taught the names of the escape
hatches: it allows three axioms and rejects everything else, so `sorryAx`, a
hand-written `axiom`, and whatever Lean grows next fail it without an edit.

**First run, empty allowlist on purpose: 13 theorems in 5 modules**, not the
predicted 8 in 4. The gap is the gate earning its keep — `EuclidDoublingForkMinimal`
was *broken* when the audit ran, so its taint could not be counted; a sibling
repaired it and 5 tainted theorems appeared. **Repairing a module can raise the
axiom count, and only a gate that runs after the build sees it.**

**Now 2, in `DiagonalSmithRoute`.** I converted all four `EuclidDoublingForkMinimal`
sites to kernel `decide` (the audit had them as "untested"; three needed
nothing, `noFormationFormsBoth` needed `set_option maxRecDepth 100000` and 79 s
— exactly the intended trade). Church lineage's `82b8dc07` retired the other
six. The last two are the `reduceDiagonal` projections of §4b; they are
allowlisted **with** the observed reason and the removal path, and
`DiagonalSmithRoute.lean` now carries the `-- TRUSTS-COMPILER:` header. It is
the only module that carries one and the gate is what keeps that true.

The allowlist requires per entry: the axiom, the *observed* reason, and what
would remove it. An entry without those three should be deleted so the gate goes
red and someone looks. The gate also prints `ALLOWLIST-STALE` / `-ABSENT` for
entries that have rotted (verified against a scratch file, not assumed).

**Wired:** `formal/check.sh` after `lake build`, and a step in
`.github/workflows/formal-gates.yml`. **Say this plainly: GitHub Actions on this
account never starts** — runner_id 0, no steps, logs 404. Nothing I wired has
run in a runner. It is correct-but-inert and begins working the moment Actions
is re-enabled. Every verdict above is from a run in this container.

**Agda:** it does *not* need this. `--safe` is stronger — compiler-checked at
typecheck time, not a second pass over a possibly-stale build. The one gap is
that `--safe` is asserted per module, so a file that omits the pragma is checked
without it silently; a toolchain-free grep that all 272 headers carry
`--cubical --safe` would close it, and would run in CI as cheaply as the
existing closure checks. I did not add it — I have not audited those headers and
will not gate on a property I have not measured. That is the open item I leave.

Still open, unchanged and larger than any of this: nothing checks that a
theorem's *statement* says what the prose citing it claims (`LEAN_LANE_AUDIT` §6).
