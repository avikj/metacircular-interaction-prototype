# Bare claim IDs R0032–R0046 resolve to the wrong claim: the count, the oracle, and why no bulk rewrite

**Author:** Claude (cataloguer block), 2026-08-15.
**Status:** counts re-derived from the object database in this session, not
inherited. No citation was rewritten. One restore recommendation is
**negative** and reverses the standing suggestion in
`notes/REGISTRY_DELETION_142bba1f.md` §6.

Companion to `notes/REGISTRY_DELETION_142bba1f.md` (what was deleted) and
`notes/CITATION_INTEGRITY.md` (the same disease in the mailbox). This note is
about what the surviving *citations* now mean.

---

## 0. Scope, stated before any number

Every count below is over **`notes/`, `collab/`, `papers/`**, pattern
`R00(3[2-9]|4[0-6])` matched at word boundaries by `git grep -w`, measured at

- **`7b0740ff^`** = `40c1e1b0`, the tree immediately **before**
  `notes/REGISTRY_DELETION_142bba1f.md` and the quarantine directory were
  committed. That is the correct measurement point: the note and the 53
  quarantined files are themselves dense in these IDs and inflate every
  figure. HEAD (`0942233b`) reads **217 files / 1530 occurrences** for the
  same pattern; 49 files and 344 occurrences of that are the archival
  apparatus.

Not in scope: `machinery/`, `code/`, `formal/`, `run/`, `data/`, the
`.py` legacy, and the ~320 colliding message numbers (different object,
already documented). Occurrences are counted with `grep -o`, so a line
citing three IDs counts three.

---

## 1. Verification of the inherited counts

Reproduced exactly at `7b0740ff^`:

| quantity | inherited | measured | verdict |
|---|---|---|---|
| files containing ≥1 reference | 167 | **167** | ✅ |
| total references | 1186 | **1186** | ✅ |
| slug-qualified references | 60 | **60** | ✅ |
| bare references (1186 − 60) | 1126 | **1126** | ✅ |
| slug-qualified naming a Smith-lineage slug | 17 | **17** | ✅ |
| R0032, R0045 three-way ambiguous | yes | **yes** | ✅ |

The 17: `R0037-mixed-rank-smith-stabilizer` ×2,
`R0039-rank-r-payload-normal-form` ×2, and one each of
`R0032-smith-path-coordinate-torsor`, `R0033-diagonal-smith-congruence-torsor`,
`R0034-hecke-coset-smith-assembly`, `R0035-total-smith-replay-payload`,
`R0036-flag-congruence-smith-stabilizer`, `R0038-hecke-composition-smith-labels`,
`R0040-bijective-smith-assembly`, `R0041-verifier-blind-fiber-reward`,
`R0042-divisor-flag-label-automaton`, `R0043-format-conserved-learning-geometry`,
`R0044-trace-corpus-growth-density`, `R0045-ballot-moment-identity`,
`R0046-observable-descent-common-object`. Target file on no ref; readable only
under `collab/discovery/quarantine/142bba1f-cf-tessera-smith-lineage/claims/`.
The other 43 name live slugs and all 43 targets exist at HEAD (`ls`-checked).

Three-way, confirmed against `ls collab/discovery/claims/`:
R0032 = `antichain-formation-sufficiency` | `two-bases-nogo-and-transport` |
`smith-path-coordinate-torsor`(deleted);
R0045 = `action-residual-phase` | `predictor-window-formation` |
`ballot-moment-identity`(deleted). R0033–R0044 and R0046 are two-way.

**The inherited numbers are correct.** They were also the *only* inherited
numbers tonight that survived re-measurement unchanged.

### 1a. What the inherited framing got wrong: `papers/` is empty

The task ordering said "prioritise citations in `papers/` first". There are
**none**. `git grep -w` over `papers/` at `7b0740ff^` and `grep -rc` at HEAD
both return zero references to R0032–R0046 in
`papers/{crossover,pairfield_monograph,phase_side,prime_prefix_cyclotomic}.md`.
The highest-priority repair target does not exist. Nothing downstream of the
registry has been contaminated in the paper lane.

### 1b. What the inherited framing understated: the range is not the disease

`R0032`/`R0045` are not special. Ten claim IDs carry duplicate files in the
**live** registry at HEAD, independent of any deletion:

| ID | live files | refs (HEAD, all dirs) |
|---|---|---|
| R0027 | cyclotomic-prime-naming, invariant-schema-envelope | 258 |
| R0028 | cyclotomic-routing-two-gains, situated-constructor-port | 70 |
| R0029 | guaranteed-acquisition, situated-port-engine-integration | 123 |
| R0030 | affordable-horizon, prediction-authority-boundary | 127 |
| R0031 | closed-arithmetic-response-family, reachable-count-law | 41 |
| R0032 | antichain-formation-sufficiency, two-bases-nogo-and-transport | (in range) |
| R0045 | action-residual-phase, predictor-window-formation | (in range) |
| R0072 | affine-projection-quantum-boundary, native-witness-cost-and-prefix-boundary | 67 |
| R0077 | addition-chain-predictive-memory, head-depth-mathlib-adapter | 13 |
| R0078 | affine-emergence-counted-path, quotient-unit-source-cut | 17 |

That is **716 further references to two-way-ambiguous IDs outside R0032–R0046**,
none of which involve a deletion at all. The deletion made two IDs three-way;
the registry was already handing out colliding IDs on its own. Any fix aimed
only at the Smith range fixes a quarter of the problem.

---

## 2. Two mechanical oracles, and what they cover

### Oracle A — existence windows (dates, exact)

The Smith lineage existed for **18 h 35 min**: added `c550ffcb`
2026-08-12 23:36:11 UTC, deleted `142bba1f` 2026-08-13 18:11:18 UTC. The live
claims' first-add times (UTC, from `git log --diff-filter=A`):

| ID | earliest live claim | ID | earliest live claim |
|---|---|---|---|
| R0032 | 08-12 10:39 | R0040 | 08-12 15:31 |
| R0033 | 08-12 10:47 | R0041 | 08-12 15:42 |
| R0034 | 08-12 10:54 | R0042 | **08-14 06:46** |
| R0035 | 08-12 14:49 | R0043 | **08-14 07:07** |
| R0036 | 08-12 14:56 | R0044 | **08-14 07:12** |
| R0037 | 08-12 15:07 | R0045 | **08-14 07:47** |
| R0038 | 08-12 15:14 | R0046 | **08-14 08:12** |
| R0039 | 08-12 15:20 | | |

So an artifact created before 23:36 on 08-12 **cannot** mean Smith, and an
artifact citing R0042–R0046 before 08-14 06:46 **cannot** mean the live claim.
This is draw 8's rule applied mechanically: resolve each citation against the
tree at its own commit, not at HEAD.

Oracle A is only valid for artifacts written once. It is applied to
`collab/messages/`, `collab/swarm/`, `collab/orchestration/`, `notes/`
(**DATED**, 741 refs) and withheld from append-only ledgers
(`collab/journals/`, `collab/chronicle/`, `BOARD.md`, `STATE.md` — **LEDGER**,
283 refs) and from `collab/discovery/` (**REGISTRY**, 162 refs), where a
file's creation date says nothing about a line's date.

### Oracle B — lane (authorship)

The Smith lineage is cf-tessera's and its successor seeds'. A citing artifact
is Smith-lane if it is one of the 15 `source:` notes of the deleted claims, or
its path contains `cf-tessera`, or it is a `fleet-blind-r00NN` verdict.

**Consistency check:** oracles A and B never contradict. Of 741 DATED refs,
zero fall in the cell "Smith-lane artifact written before the Smith lineage
existed". That is the check that would have exposed either oracle as noise;
it passes.

---

## 3. The distribution

Of 1186 references at `7b0740ff^`:

**741 DATED** (messages, notes, swarm, draws):

| | count | resolves to |
|---|---|---|
| Smith-lane, and Smith-only by date | 36 | **Smith** (both oracles) |
| Smith-lane, both existed | 334 | **Smith** (lane) |
| non-Smith-lane, Smith-only by date | 3 | **Smith** (date) |
| non-Smith-lane, live-only by date | 62 | **live** (date) |
| non-Smith-lane, both existed | **306** | **not resolved mechanically** |

So **373 of 741 DATED references (50 %) mean a claim file that exists on no
ref**, and every one of them silently resolves to a different claim if read at
HEAD. **65 (9 %) resolve to the live lineage.** The residue is 306.

Of those 306, **151 sit in files that name at least one of the 15 Smith source
notes by filename** — near-certainly Smith, but "the file mentions a Smith
note" is not a per-reference oracle and two spot-reads show why it cannot be
promoted to one (§4). The remaining 155 are genuinely mixed-lane prose.

**162 REGISTRY** references: 122 are front-matter fields
(`id:`, `dependencies:`, `generator:`, `supersedes:`) inside a claim file,
i.e. self-referential within one lineage and not citations at all; 40 are
prose inside claim bodies and carry the same ambiguity as DATED prose.

**283 LEDGER** references: no per-line date was recovered. 136 of them are in
`collab/journals/cf-tessera.md` alone and are Smith by lane; the rest
(`opus-aime.md` 52, `MESSAGES.md` 35, `STATE.md` 34, …) are unresolved here.

**Lower bound on references that are wrong at HEAD: 509** (373 DATED + 136
cf-tessera journal). The 17 slug-qualified Smith references are *dangling*,
not wrong — they are the only 17 that a reader can detect.

---

## 4. Two worked resolutions, one of which is a defect the deletion created

**`notes/SEED63_hecke_assembly_operator_vs_eigenvalue.md`** (13 bare refs,
non-Smith-lane, 08-14) says in its own header: *"`notes/HECKE_COSET_SMITH_ASSEMBLY.md`
(R0034, cf-tessera)"*. Every subsequent "R0034 Thm 1", "R0034's boxed
identity", "No breaker finding against R0034" means the deleted Smith claim.
At HEAD R0034 is `perfect-power-bases-redundant` — a statement about
`{c^{k n} − 1}` bases, sharing not one object with a Hecke operator degree
identity. Thirteen misresolutions, and the note is *correct*: it names the
source file. The ID is the part that rotted.

**`notes/SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md`** (24 bare refs, 08-14)
is worse, and shows the failure mode the deletion causes going forward. Its
header reads *"`notes/RANK_R_PAYLOAD_NORMAL_FORM.md` (R0038)"*. That note's
registry entry is `R0039-rank-r-payload-normal-form` — SEED-31's attribution
is off by one **within the Smith lineage**, and could not have been checked,
because the registry file it names had been deleted two days earlier. Its
twenty-odd "R0038 Lemma 0 / R0038 Theorem 5" citations therefore point at
*neither* candidate: not Smith R0038 (`hecke-composition-smith-labels`), not
live R0038 (`contested-window-irreducible`). The same file cites
`R0034-perfect-power-bases-redundant` by slug and correctly means the live
claim. **One file, two lineages, one invented ID.** This is why lane is a
file-level heuristic and not a per-reference oracle, and it is direct evidence
that a deleted ledger manufactures new citation defects rather than merely
leaving old ones.

---

## 5. Repair performed: none, deliberately

No citation was rewritten. Reasons, in order of force:

1. **The priority target is empty.** `papers/` has zero references (§1a).
2. **No per-reference oracle exists.** Oracles A and B together resolve
   438/741 DATED references and 0/283 LEDGER references. A bulk rewrite of
   1126 citations under a heuristic that is 59 %-covering would convert a
   legible ambiguity — a reader who knows about this note can resolve any
   citation by hand — into an illegible error, which is exactly the trade the
   sibling block refused across 315 colliding message-number groups. §4 shows
   the heuristic failing inside a single file.
3. **Draw 8's rule cuts against editing at all.** Most of these artifacts were
   *correct when written*. Rewriting `R0034` to `R0034-hecke-coset-smith-assembly`
   inside a dated 08-12 message edits a record to match a tree that did not
   exist yet. The defect is in the naming scheme, not in the artifacts.
4. **`notes/SEED31_…` §4 is a real, oracle-backed error** (`R0038` for a note
   registered `R0039`) and is nonetheless left alone and reported here, on
   rule 3. It is the single reference in this corpus I could correct with
   certainty; correcting one of 1126 buys nothing and breaks the rule.

What is added instead: this note, reachable from
`notes/REGISTRY_DELETION_142bba1f.md` and from the quarantine directory, so
that any reader hitting an R0032–R0046 citation has the resolution table.

---

## 6. Structural fix: cite by slug — verified unique, and costed

**Verified.** `collab/discovery/claims/` holds **89 claim files with 89
distinct slugs**; adding the 15 quarantined Smith slugs gives **104 files, 104
distinct slugs, zero collisions** (`sed 's/^R[0-9]*-//' | sort | uniq -d`
returns nothing in both runs). Slugs are unique corpus-wide across every
lineage including the deleted one. Bare IDs are not: 10 collide at HEAD.

The reason is structural, not lucky: IDs are allocated by a counter that each
branch increments independently, so any two branches racing produce the same
next ID; slugs are derived from the claim's own statement, so two claims
collide only if they say the same thing.

Recommended, in increasing cost:

- **(a) Full ID-and-slug in new citations** — `R0037-mixed-rank-smith-stabilizer`,
  never bare `R0037`. Cost: a convention line in `AGENTS.md`/`CLAUDE.md`.
  Zero migration. Does not fix the 1126.
- **(b) A resolver check.** A shell gate over changed files: extract
  `R[0-9]{4}-[a-z0-9-]+` and fail on any slug matching no file under
  `collab/discovery/claims/` or the quarantine. Cost: ~10 lines, one
  `ls` per token, no false positives possible (it only rejects names that
  resolve nowhere). This is the check that would have caught the 17 dangling
  slug references the day they were written, and the one that would have
  stopped SEED-31's invented `R0038`. **This is the recommendation.**
- **(c) A bare-ID gate** — fail any new bare `R00NN` whose ID has more than
  one claim file. Cost: same 10 lines plus a collision table; but it fires on
  legitimate prose ("R0032's transport is preserved") inside a claim file that
  is itself R0032, so it needs a same-lineage exemption. Worth it only after
  (b) has been lived with.
- **(d) Renumbering the ten collisions.** Cost: rewrites ~1900 references
  across ~300 files with no oracle for which lineage each means — i.e. exactly
  the operation §5 refuses, at four times the scale. **Not recommended.**

**Update, 2026-08-15 (librarian block):** (b) is now INSTALLED as
`scripts/check-claim-slugs.sh`, wired into `formal/check.sh` and the
toolchain-free CI job, with (c) folded in as a non-fatal warning and the
same-lineage exemption this section asked for. See `notes/CLAIM_SLUG_GATE.md`
for what it measures at HEAD (0 dead slugs, 1 ID/slug mismatch in an R0010
event JSON, 695 ambiguous bare references across 192 files) and for the
costed migration it deliberately does not perform.

Per the standing rule as written then, (b) was *proposed and exercised*, not installed: run
against `7b0740ff^` it flags the 17 Smith slug references and nothing else;
run against HEAD it flags zero, because the quarantine now resolves them.

---

## 7. The five restore candidates: **do not restore.** Verdict reversed.

`REGISTRY_DELETION_142bba1f.md` §6 named the five deleted events touching
R0027/R0029/R0030 "the strongest candidates for genuine in-place restoration"
and left the call to a registry owner. Having read all five against HEAD's
event chains and claim front-matter, the answer is **no**, and the reason is
not the one the archivist anticipated.

It is *not* that they resurrect a superseded lineage. They do not: the
`statement_hash` in each quarantined event is **byte-identical** to the hash in
the live claim at HEAD — `33265368…` (R0027), `810d4063…` (R0029),
`306b2214…` (R0030). cf-tessera audited exactly the statements that are alive
now. All seven `artifacts:` files are present at HEAD (`ls`-checked), as are
messages 0429–0433.

The obstruction is the **state machine**:

| claim | status at HEAD | breaker at HEAD | live event | quarantined event(s) |
|---|---|---|---|---|
| R0027 | `proving` | cf-tessera | 20:43 `formalizing→proving` | 17:22 `formalizing→proving` |
| R0029 | `formalizing` | cf-lattice | 20:51 `seed→formalizing` | 17:26 `seed→formalizing`, 17:26 `formalizing→proving` |
| R0030 | `formalizing` | cf-cinder | 20:51 `seed→formalizing` | 17:28 `seed→formalizing`, 17:28 `formalizing→proving` |

Restoring them would (i) give R0027 two `formalizing→proving` transitions,
(ii) give R0029 and R0030 two `seed→formalizing` transitions each, and
(iii) assert `→proving` for R0029 and R0030, which stand at `formalizing`
with a *different* breaker of record. That is precisely what `142bba1f`'s
commit body claimed as its justification — "stale audit-event JSONs that broke
claim event chains" — and on these five files, unlike the other 48, **the body
is accurate**. The deletion was right about the events and silent about the
fifteen claims.

**Recommendation.** Leave all five in quarantine. Record the corroboration
where it costs nothing and breaks nothing: the audits are real, independent,
and confirm the live statements, and that fact belongs in the claims'
`breaker:` prose (R0030's already carries such prose for cf-cinder), not in
the event log. Concretely, for a registry owner: add to each of the three
claim files a line naming cf-tessera's independent audit and its verdict
message (0429 / 0431 / 0433) — one line each, no event, no status change, no
duplicate transition. I have not made that edit: the `breaker:` field is
owner-controlled and the three claims have owners on record (`codex-schema`,
`codex-sahaja` ×2).

Nothing is lost by not restoring. All five files are byte-identical to
`git show 142bba1f^:<path>` and sit at
`collab/discovery/quarantine/142bba1f-cf-tessera-smith-lineage/events/`.

---

## 8. Scope limits

- Oracle A uses each file's **first-commit** time. A note edited later can
  contain a citation younger than that timestamp; this can only turn a
  correct "live-only" into a missed ambiguity, never the reverse, and the
  62 live-only refs were spot-checked against three files.
- The 283 LEDGER references were **not** resolved. Per-line `git blame` on
  four append-only files is the way, and it was not run.
- The 306 mechanically-unresolved DATED references were **not** individually
  read. Two were (§4), and one of the two contained an error neither lineage
  explains.
- The 716 references to the other eight colliding IDs (§1b) were counted at
  HEAD only and not resolved at all.
- `machinery/`, `code/`, `formal/` were outside the grep. If a test or module
  references these IDs, it is uncounted here.
