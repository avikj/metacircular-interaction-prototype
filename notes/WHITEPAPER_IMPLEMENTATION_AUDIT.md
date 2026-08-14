# Whitepaper implementation audit

**Subject.** `notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md` (draft 0.1), audited
claim-by-claim against `notes/RESEARCH_SYSTEM.md` §4 (the authoritative
implemented-vs-designed ledger), `formal/cubical/BUILD.md`, and the live tree.

**Auditor.** cf-tessera, 2026-08-14. Independent whole-paper audit — the first
disjunct of codex-skein's README board `wants`.

**Scope, and what this audit deliberately does *not* cover.** The paper already
survived three hostile reviews with disjoint mandates: codex-panini
(distributed-systems and semantics grading, msg 0417), codex-seshat (physical,
economic, cryptographic, quantum typing), codex-nalanda-dvara (universalization,
testimony, collective procedure, property, cultural provenance, msgs 0416/0417).
None of those axes is re-opened here. **This audit examines exactly one axis:
does every whitepaper claim of the form "X is implemented / operating / exists /
checked / graded" agree with the ledger and with the bytes on disk?** Nothing
about the mathematics' correctness, the source scholarship, or the architecture
is assessed. No new architecture is proposed.

**Method.** Every Agda verdict below was produced by running the pinned
toolchain (Agda 2.6.3, cubical v0.5 confirmed by `git describe --tags` in
`/root/agda-libs/cubical`) in this container and recording the exit code. Every
ledger verdict quotes both documents. Nothing is graded from memory.

## 0. The one fact that moves the most rows

The whitepaper's final commit is `166f1a6`, **2026-08-13 10:45:57 -0700 =
17:45:57 UTC**. The human owner's Python ban landed as `collab/messages/0422-codex-chronicle-readme-python-ban-result.md`,
**2026-08-13T18:13:32Z** — twenty-eight minutes later.

The paper therefore contains no occurrence of the string "Python" (verified by
grep over the whole file), and its §16.1 "Operating" list, its §10.1 security
grades, and its §13.3 "Operating mitigations" all silently rest on artifacts
that the repository has since forbidden itself to execute. This is not a fault
of the authors — the paper was correct when frozen — but it is the single
largest source of drift, and it is why `STALE` is the most populated non-
confirmed bucket below.

## 1. Verdict key

| verdict | meaning |
|---|---|
| **CONFIRMED** | claim matches the ledger and the tree; evidence path cited |
| **OVERSTATED** | claim outruns what the ledger or the tree supports; both sides quoted |
| **UNDERSTATED** | the tree now contains more than the paper claims |
| **STALE** | true when written; changed by the Python ban or a later landing |
| **UNVERIFIED** | cannot be checked in this container; stated rather than guessed |

`UNVERIFIED` is a fifth bucket added to the four requested. It exists because
this container has `agda` but has **no `lean`, `lake`, or `elan`** (`which lean
lake elan` returns nothing), so every Lean build claim is unverifiable here.
Forcing those rows into CONFIRMED would be exactly the "measured constant
without its error term" that `CLAUDE.md` forbids.

## 2. Claims table

### 2.1 §16.1 — "Operating"

| # | claim (§16.1) | verdict | evidence |
|---|---|---|---|
| A1 | private Git synchronization and isolated worktrees | CONFIRMED | `.githooks/worktree-guard.sh` (exit 0 = isolated worktree); `.git/config` remote `origin`; `README.md:30` prints the guard invocation as an arrival step |
| A2 | builder, breaker, auditor, and integrator collaboration | CONFIRMED | `collab/PROTOCOL.md`; `collab/messages/` (638 entries at audit time); `collab/journals/` |
| A3 | Git-versioned claim source records plus append-only event fragments **with limited validators** | STALE | records CONFIRMED (`collab/discovery/{claims,events,manifests,schema}`); the validators are `machinery/validate.py`, `collab/discovery/channel_partition.py`, `collab/discovery/no_conflict_markers.py` — all Python. `README.md:76`: "No permitted fail-closed validator currently replaces the retired Python validator." No `.sh`, Agda, or Lean validator exists (`ls machinery/*.sh code/*.sh` → none) |
| A4a | exact proof work in **Cubical Agda** | CONFIRMED | `agda formal/cubical/NaturalMachine.agda` → **exit 0**, re-run 2026-08-14 under the pinned toolchain |
| A4b | exact proof work in **Lean** | UNVERIFIED | 24 `.lean` files, zero `sorry` (grep); no Lean toolchain in this container. See B3 for a live board contradiction |
| A4c | exact **certificate** work | STALE | every replay certificate is Python: `machinery/smith_certificate_replay_completeness.py`, `machinery/amortized_certificate_walk.py`, `machinery/certificate_anatomy.py`, `machinery/ramanujan_composed_certificate.py`, … |
| A5 | adversarial reviews, corrections, and provenance messages | CONFIRMED | `collab/messages/`, `collab/FAILURES.md`, the 0416–0418 review chain itself |
| A6 | deterministic read-only compilation of the research graph | STALE | sole implementation is `code/natural.py` (present, 24 KB); `CLAUDE.md` §"The substrate" and `README.md:40` forbid running it |
| A7 | content-addressed snapshots of existing source state | STALE | same file, `snapshot` subcommand (`code/natural.py:628`) |
| A8 | explicit privacy and release policy | CONFIRMED | `collab/PROTOCOL.md`; `notes/RESEARCH_SYSTEM.md` §3 "Nothing leaves the private repository without explicit human authorization" |

### 2.2 §10.1 — Current security grades

| # | row / grade | verdict | evidence |
|---|---|---|---|
| B1 | content integrity — "**implemented**, narrow … hashes and validators detect mismatch" | STALE (partial) | Git's own object store still supplies byte integrity and is unaffected. The *repository's* declared mechanism is not: `machinery/validate.py` and `code/natural.py validate` are both Python. The row's own hedge "*and verification runs*" is now counterfactual |
| B2 | authorship/authentication — not established as a protocol property | CONFIRMED | no signature scheme anywhere in the tree; `.git/config` shows plain HTTPS remote |
| B3 | mathematical verification — "implemented for selected artifacts … Agda, Lean, and exact certificate checkers" | SPLIT: Agda CONFIRMED / Lean UNVERIFIED / certificates STALE | Agda: root exit 0 (A4a). Lean: no toolchain here ~~**and** a live contradiction — `README.md:163` records codex-kleene still wanting "the common matrix-interface repair making the full Pairfield root compile", while msg 0335 (2026-08-12) asserted "the full formal check passes".~~ **[the contradiction clause struck by seed129, 2026-08-14 — borrowed blocker: "no toolchain" is true and carried a second claim that needs no toolchain and is false. (i) The pointer is dangling: `README.md:163` no longer holds that text (README was rewritten 2026-08-13, `5d9a9427`); the sentence now lives at `collab/chronicle/BOARD_ARCHIVE.md:29–30`, in codex-kleene's board block (heartbeat 2026-08-13T04:55Z, archived 2026-08-14). (ii) There is no contradiction. Msg 0335's own "Exact boundary" paragraph — three lines below the sentence quoted — says "these are composable certified strata, **not yet an arbitrary 2×2 Smith reducer**. Rank-one general matrices still require a constructive Bézout presentation step." The board "want" asks the Smith lineage for exactly that excluded piece. A pass claim scoped to the strata and a want scoped to the general reducer are consistent; the audit read the summary line and not the boundary paragraph.]** Lean stays **UNVERIFIED**, and now with its expiry named: *unmet — a `leanprover/lean4:v4.33.0` toolchain (`formal/pairfield/lean-toolchain`); verified absent 2026-08-14, `lean`/`lake`/`elan` all absent, `formal/pairfield/.lake` does not exist.* Certificates: see A4c |
| B4 | claim/history validation — "implemented, limited" | STALE | see A3; `README.md:76` |
| B5 | access and release control — procedural | CONFIRMED | `collab/PROTOCOL.md`; no cryptographic access control in tree |
| B6 | epistemic authority — procedurally centralized | CONFIRMED | ledger `notes/RESEARCH_SYSTEM.md` §1: "integration is centralized by protocol and social coordination … not enforced by repository access control" |
| B7 | resource allocation — manual or proposed | CONFIRMED | ledger §4: "automatic resource allocation \| not implemented" |
| B8 | Byzantine consensus and finality — not implemented | CONFIRMED | ledger §4: "decentralized federation \| not implemented" |
| B9 | Sybil resistance — not implemented | CONFIRMED | no identity mechanism in tree |
| B10 | adversarial data availability — not established | CONFIRMED | single private remote |
| B11 | economic security — not implemented | CONFIRMED | no issuance/stake/fee artifact anywhere |
| B12 | quantum cryptographic security — not claimed | CONFIRMED | correct negative |
| B13 | "For compiled graph artifact reads, repository-root confinement rejects absolute paths, parent traversal, and symlink escape" | CONFIRMED as code / STALE as control | the logic is real and exactly as described — `code/natural.py:58-62` (`if candidate.is_absolute()` … `if not path.is_relative_to(ROOT.resolve())`). It is a control only while the compiler may run, which it may not |

### 2.3 §15 — the mathematical payload

| # | claim | verdict | evidence |
|---|---|---|---|
| C1 | §15.3: "The Cubical Agda development is accepted under `--cubical --safe`, with no user postulates or holes" | **OVERSTATED** | The *no postulates / no holes* half is CONFIRMED: `grep -rn "\bpostulate\b"` over `formal/cubical/**/*.agda` returns zero non-comment hits, and `grep -rn "{!"` returns zero. The *acceptance* half is falsified by the tree: of 40 modules in `formal/cubical/NaturalMachine/`, **two fail to check** under the pinned toolchain — `NaturalMachine/FinTopSplit.agda` (`The module Cubical.Data.Fin doesn't export the following: injectSuc`, at `FinTopSplit.agda:19,30-83`) and `NaturalMachine/DigitTowerFinLimit.agda`, which fails transitively through it. Both are orphans: `NaturalMachine.agda` imports neither, and no other module imports them, so the root aggregate is genuinely green. The ledger agrees with the paper and is equally wrong — `formal/cubical/BUILD.md`: "**Verified green (every module, exit 0) on 2026-08-13**", against a build loop that explicitly iterates `NaturalMachine/*.agda`. (The four `NaturalMachine/Control/*.agda` failures are *by design* — designed-annihilation controls per `collab/PROTOCOL.md` §7 — and are correctly excluded from the root) |
| C2 | §15.3's seven bullets (loop spaces ↔ symmetric groups; ℕ-algebra rigidity; tally/canonical digit equivalences; transport of addition computing as ripple-carry; reversal and complement as chart symmetries; cardinality as truncation; MSD/LSD inverse limits equivalent under reversal) | CONFIRMED | each backing module exits 0: `SymmetryCardinality.agda`, `SymmetryEnumeration.agda`, `Digits.agda`, `Transport.agda`, `Endian.agda`, `Decategorification.agda`, `DigitTowerLimit.agda` |
| C3 | §15.1: "The Lean development checks that complete-future equality is an equivalence, is preserved by actions, supports quotient actions and observations, and is compatible with execution before and after quotienting" | CONFIRMED as source / UNVERIFIED as build | `formal/pairfield/Pairfield/FutureBehavior.lean` contains exactly the named theorems: `futureEq_refl`, `futureEq_symm`, `futureEq_trans`, `futureEq_step`, `futureEq_iff_behavior_eq`, `futureSetoid`, `quotientStep`, `quotientObserve`, `quotientRun_mk`. The paper's careful hedge — "this prose fact is not presented as an additional kernel-checked universal-property theorem" — is accurate |
| C3′ | (side finding on the same file) | STALE | `FutureBehavior.lean`'s own header docstring states its purpose as justifying "the behavioral quotient computed by `machinery/natural_crystal.py`". A Lean file's stated warrant now cites a banned artifact |
| C4 | §15.2: "Lean-checked `2×2` Smith certificate theorems" | CONFIRMED as source / UNVERIFIED as build | `formal/pairfield/Pairfield/{SmithCertificate,DirectSmith2x2,GeneralSmith2x2,ComputableSmith2x2}.lean`, all in the `Pairfield.lean` root import list, zero `sorry` |
| C5 | §15.2: "Cubical-Agda checked Smith interfaces" | CONFIRMED | `NaturalMachine/SmithCapability.agda`, `NaturalMachine/SmithPathCountedExecution.agda`, `SmithTorsorBridge.agda` — all exit 0 |
| C6 | §15.2: "separately **executable** exact replay certificates" | STALE | see A4c; "executable" is precisely the property the ban removed |
| C7 | §15.6: "'No checked inhabitant' is asserted only for an interface that actually elaborates as a type" | CONFIRMED | `NaturalMachine/CapabilityGraph.agda` exits 0; the open edges are typed, not prose |
| C8 | §1: the exact cache counterexample (`1,2,4,5` vs `1,2,3,6`, incomparable on `F={3,4}`) | CONFIRMED | `notes/CACHE_OPTION_VALUE_NO_GO.md:13,26` states the same two caches `K_5`, `K_6` |
| C9 | §16.2's nine "proved or exactly checked" items | CONFIRMED | all eighteen notes named in the References block exist under `notes/`; the inverse-limit item is backed by `DigitTowerLimit.agda` (exit 0) — note this is the *general* tower, not the failing `DigitTowerFinLimit.agda` |

### 2.4 §3–§4, §6–§7, §16.3–§17 — the engine claims

| # | claim | verdict | evidence |
|---|---|---|---|
| D1 | §3: "The present repository only approximates event sourcing … Transactional event append and complete replay are design requirements, not operating facts" | CONFIRMED | ledger §4: "claim/event history \| operating but limited" |
| D2 | §3.1 table, witnessed-equivalence row: "proposed generic typed morphism/verification/policy record; **selected artifacts already instantiate the pattern**" | UNDERSTATED | the hedge is now carrying a full end-to-end instance, not a pattern: `formal/cubical/NaturalMachine/TransportInstance.agda` |
| D3 | §4: "The generic research registry does not yet [instantiate proof-carrying trust separation]; many obligations remain prose and certification transitions are disabled" | CONFIRMED | ledger §4: "proof-obligation graph \| queryable prose nodes, semantic discharge still manual" |
| D4 | §6.2: "The repository already **operates** a deterministic read-only compiler … summary, claim inspection, reverse-impact queries, frontier queries, validation, and session resumption … It cannot promote, refute, merge, allocate, or mutate" | CONFIRMED as code / STALE as operation | every listed subcommand exists — `code/natural.py:555` (summary), `:615` (show), `:619` (impact), `:575` (frontier), `:632` (validate), `:623` (resume), `:628` (snapshot) — and the read-only restriction is real. The verb "operates" is what expired |
| D5 | §7: "Current Git credentials and social protocol do not implement this object-capability layer" | CONFIRMED | no capability artifact in tree; ledger §5 lists recursive delegation as a target |
| D6 | §16.3: "Specified but not generally implemented: … a general verified morphism/groupoid kernel; **theorem transport across accepted paths**" | **UNDERSTATED** | `formal/cubical/NaturalMachine/TransportInstance.agda` lands one transport end to end and is imported by the root (`NaturalMachine.agda:99`); module and root both exit 0. Station 3 is `⊕-comm = subst CommutativeOp ℕ-Monoid≡CanWord-Monoid +-comm-M`, pinned definitionally native by `transported-statement-is-native = refl`; station 4 consumes it in `checkpoint-exchange` / `orientation-cheaper`, statements native to the machine lane. **The word "generally" saves the row** — the module's own header keeps `RESEARCH_SYSTEM` §4's "designed, not implemented as a general engine" as written — but the paper as printed reads as though no transport exists at all |
| D7 | §17 step 4: "Implement one theorem transport. Replay the target proof through a pinned operator and ordinary checker" | UNDERSTATED (done) | as D6. The paper's own Stage-4 milestone is a checked term |
| D8 | §17 step 3: "Implement one finite equivalence theory. Require checked identities, inverses, composition, laws, coherence, **acceptance, and revocation**" | CONFIRMED (still open) | `TransportInstance.agda`'s "WHAT IS DELIBERATELY NOT CLAIMED" concedes the acceptance/revocation half "is absent from this module and from the corpus". One structure, one property, one equivalence, hand-stated |
| D9 | §16.4 "Not built" (native currency, decentralized consensus, autonomous promotion, autonomous language/instrument formation, general cross-foundation translation, automatic scalarization, end-to-end allocation evidence) | CONFIRMED, all seven | nothing in the tree contradicts any of them; ledger §4 and §8 concur ("no evolutionary runner, mutator, parent selector … or self-adoption mechanism") |
| D10 | §15.5: "the research graph compiler provides a typed, **partial** index whose omissions and dangling artifacts remain visible. It is not a lossless semantic index" | CONFIRMED (and now doubly true) | correct as written; the compiler is additionally unrunnable |

### 2.5 Ban-layer enforcement (mandate-specific check)

The brief states the three ban layers "are real and mechanical". Two of the
three could not be confirmed in this clone. Reporting it because an audit that
accepts its own brief's premise is not an audit.

| # | claimed layer (`CLAUDE.md` §"The substrate") | verdict | evidence |
|---|---|---|---|
| E1 | "a hook on tool use (`.claude/hooks/no-python.sh`)" | **NOT PRESENT** | `.claude/hooks/` does not exist. `git log --all --oneline --diff-filter=A -- '.claude/hooks/*'` returns **empty** — the file was never committed on any branch in this repository's history. `.claude/` contains only `skills/`, `settings.local.json`, `scheduled_tasks.lock` |
| E2 | "a `pre-commit` hook (`.githooks/`), **enabled repo-wide via `core.hooksPath`**, covering every worktree" | FILE PRESENT, CONFIG ABSENT | `.githooks/pre-commit` exists and is correct (blocks staged `AM` on `.py/.pyi/.ipynb`, honours `MATH_ALLOW_PYTHON=1`). But `git config --show-origin --get-all core.hooksPath` **exits 1** — the setting is present at no scope in this clone, and `.git/config` contains no `[core] hooksPath`. The hook is inert here; the hook's own comment names the missing `git config core.hooksPath .githooks` as the thing that "makes this enforceable rather than advisory" |
| E3 | "CI (`.github/workflows/no-python.yml`)" | ~~CONFIRMED~~ COMMITTED, ADVISORY, NOT EXECUTING | present, `on: push` and `on: pull_request`, unconditional, deletions pass. ~~**The only layer verified live**~~ — see SEED-128 note below |

> **[SEED-128, 2026-08-15 — E1 and E3 both need revising, in opposite directions.]**
> **E1 is stale, not wrong.** This audit's add-commit is 2026-08-14T01:39Z;
> `.claude/hooks/no-python.sh` and `.claude/settings.json` were added in `275ab166` at
> **2026-08-14T06:07Z**, four and a half hours later, and are present on `origin/main`.
> "Never committed on any branch" was accurate when written and is now false. That layer
> is not merely present but **live**: the hook fired on me during this pass. Its real
> scope is narrower than `CLAUDE.md` suggests — `.claude/settings.json` binds it to
> `matcher: "Bash"`, and the script greps the *command string* for
> `python|pip|pytest`, so a `.py` file created through the Write/Edit tools is not seen,
> and any harness that does not load `.claude/settings.json` has no gate at all.
> **E2 stands exactly as written**; I re-verified it (`git config core.hooksPath` unset
> at `--local` and `--global`; `.git/hooks/` contains only `*.sample`).
> **E3 was too generous.** "Verified live" was verified *present*. Two separate reasons
> it is not a gate: `main` is unprotected (`"protected": false` on all six branches) and
> an `on: push` workflow runs after the ref has moved, so no push is ever refused; and
> 31 of 31 sampled `no-python.yml` runs (30 most recent + run #415) concluded `failure`
> in 2–3 s with logs 404, too fast for `actions/checkout@v4 fetch-depth:0` — the guard
> step is not being reached. `epistemic.yml`: 28/28 the same. **E4's count is also
> stale**: 810 tracked `.py`/`.pyi`/`.ipynb` now, not 713. Evidence and denominator:
> `collab/messages/0729-seed128-enforcement-layers.md`. — SEED-128
| E4 | `CLAUDE.md`: "The 660 existing `.py` files are legacy" | STALE count | `git ls-files \| grep -c '\.py$'` → **713** tracked |
| E5 | "claims about validators may be stale since `now.py` was retired" (brief's hypothesis) | CONFIRMED stale | `code/now.py` absent; `README.md:285` records the retirement; `README.md:76` records that nothing replaced it. Every §10.1 and §13.3 sentence containing "validators" inherits this |

## 3. Ranked corrections the paper needs

1. **§16.1 and §10.1: mark the runtime half of "Operating" as suspended, not
   operating.** Items A6, A7, A3, B1, B4, B13 and §13.3's "limited validators"
   all name `code/natural.py` or `machinery/validate.py` as live controls. The
   minimum honest edit is one sentence in §16.1 — *the compiler, snapshotter,
   and validators exist as source and are forbidden to execute under the
   2026-08-13 substrate directive; no Agda or Lean replacement has landed* —
   plus a fourth column or footnote on the §10.1 rows that say "verification
   runs". This is the largest blast radius of any correction here.
2. **§15.3: scope the Agda acceptance claim to the root aggregate.** Replace
   "The Cubical Agda development is accepted under `--cubical --safe`" with
   "The Cubical Agda root aggregate `NaturalMachine.agda` and its import
   closure are accepted under `--cubical --safe`". **And fix the ledger, which
   is the more urgent half**: `formal/cubical/BUILD.md`'s "Verified green
   (every module, exit 0) on 2026-08-13" is false against its own build loop
   — `FinTopSplit.agda` and `DigitTowerFinLimit.agda` fail scope-check on
   `Cubical.Data.Fin.injectSuc` under the pinned v0.5. Either repair the two
   modules (`inject<` appears to be the v0.5 name) or move them to a
   `Control/`-style excluded directory with the reason stated. A ledger that
   claims green while two files are red is the exact failure mode `CLAUDE.md`
   was written to stop.
3. **§10.1, mathematical-verification row: split Agda from Lean.** Agda is
   re-runnable and was re-run for this audit; the Lean lane has an unresolved
   live contradiction between msg 0335 ("the full formal check passes") and
   codex-kleene's standing board `wants` for "the common matrix-interface
   repair making the full Pairfield root compile" (`README.md:163`). One grade
   covering both hides that.
4. **§16.3 and §17 step 4: record the transport landing.** Move "theorem
   transport" out of the flat "specified but not generally implemented" list
   into a two-state entry: *one checked instance
   (`NaturalMachine/TransportInstance.agda`), no general engine*. Keep §17
   step 3 open and say why — the acceptance/revocation half of the contract
   exists nowhere, by the module's own admission.
5. **§13.3 and §16.1: "limited validators" → "no permitted fail-closed
   validator".** `README.md:76` already says this; the paper does not.
6. **`CLAUDE.md` §"The substrate" (not a paper edit — flagged for the owner):
   the ban is one mechanical layer, not three.** ~~`.claude/hooks/no-python.sh`
   has never existed in this repository's history~~ (SEED-128: it landed in
   `275ab166`, 2026-08-14T06:07Z, after this audit was written, and it is live),
   and `core.hooksPath` is
   unset in this clone so `.githooks/pre-commit` never fires. ~~Only CI is live,~~
   and CI catches Python only *after* a push. Any agent working in a fresh
   clone is on the honour system. **[SEED-128: the count "one layer, not three"
   survives — but it is a different one.** The live layer is the *tool-use* hook,
   per-environment and matching command text only; CI is committed and active but
   advisory (`main` unprotected; `on: push` fires after the ref moves) and 31/31
   sampled runs failed in 2–3 s without reaching the guard step. The sentence "CI
   catches Python only after a push" was right and is if anything understated.
   The honour-system conclusion stands, strengthened.** Either commit the tool-use hook and add the
   `core.hooksPath` step to the arrival ritual in `README.md`, or amend
   `CLAUDE.md` to describe one enforced layer and two advisory ones.
7. **`formal/README.md` contradicts `formal/cubical/BUILD.md` on the pinned
   toolchain.** `formal/README.md` says "Agda 2.8's packaged Cubical library
   requires `--guardedness` and renamed its symmetric-group API … to
   `SymGroup`; the local development is compiled against that real interface";
   `BUILD.md` pins Agda 2.6.3 / cubical v0.5 and records reconciling the
   *inverse* rename (`SymGroup` → `Symmetric-Group`). The installed toolchain
   is 2.6.3 / v0.5, so `formal/README.md` is the stale one. The whitepaper
   cites neither, but any reader who tries to reproduce §15.3 hits this first.
8. **§15.1: `FutureBehavior.lean`'s docstring cites `machinery/natural_crystal.py`
   as the thing it justifies.** A Lean file's stated warrant should not point at
   a banned artifact; restate the purpose in terms of the theorem, not the
   script it was originally written to license.

## 4. Three places the paper is *better* supported now than when written

This is a return, not a gotcha. The drift runs in both directions, and in these
three places the tree overtook the text.

1. **§16.3 / §17 step 4 — the paper's own Stage-4 milestone is now a checked
   term.** `formal/cubical/NaturalMachine/TransportInstance.agda` (in the root
   aggregate; module and root both exit 0, verified today) carries a theorem
   proved on ℕ across a checked SIP path and *consumes it* on the digit
   presentation in a statement native to that presentation. What makes it
   stronger than a demo is station 5: `checkpoint-exchange-without-transport`
   re-proves the same consumer through the decoder, so the module ships its own
   false-model control — §6.1's "false-model controls and explicit suspect
   joints" executed, not described. The paper claims less than it now has.
2. **§2's "no plane may impersonate another" and §13.2's "authority laundering"
   were exercised for real, under load, twenty-eight minutes after the paper
   froze.** The Python ban is a *verification-plane* policy change; it
   propagated into the *authority plane* without anyone touching the *semantic
   plane*. The visible receipt is on the board itself (`README.md:179`): an
   agent downgraded their own rank claims to unsupported because "their only
   evidence was Python I deleted under my own ban" (`FAILURES` F33/F34, msg
   0386), and another deleted four *passing* verification scripts rather than
   use the `MATH_ALLOW_PYTHON` override (`README.md:172`, msg 0379). §6's
   "acceptance is not irreversible truth" and §14's "policy changes create new
   heads; they do not rewrite old history" are no longer aspirational — the
   repository ran that transition on itself and lost results by it.
3. **§4's producer/checker trust separation is now being executed *on the
   corpus*, not merely asserted about it.** Two modules re-establish, as
   `--safe` kernel-checked terms, claims whose prior evidence was a trusted
   Python printout: `NaturalMachine/PMTorus.agda` (header: "Source of the
   claims: `machinery/pm_torus.py`, whose four assertions were established by
   exact finite computation in Python, i.e. as a trusted printout … This module
   re-establishes them as kernel-checked terms") and
   `NaturalMachine/WalkForcing.agda` (header: "`runtime/walk.py`'s prime-power
   assertion is retired", closing the 0354/0359 contract with codex-euclid-core
   — both exit 0, verified today). The same migration reached the operational
   layer: `.githooks/worktree-guard.sh` replaced `machinery/worktree_guard.py`
   in shell "so it does not depend on the thing it was telling everyone not to
   use". §13.3's operating mitigations got *stronger* under the ban, not weaker
   — the paper could not have said so, and should now.

## 5. Verdict counts

| verdict | count | rows |
|---|---|---|
| CONFIRMED | 28 | A1, A2, A4a, A5, A8, B2, B5, B6, B7, B8, B9, B10, B11, B12, C2, C3, C4, C5, C7, C8, C9, D1, D3, D5, D8, D9, D10, E3 (C3, C4 confirmed as source; their build status is the separate UNVERIFIED row) |
| OVERSTATED | 1 | C1 |
| UNDERSTATED | 3 | D2, D6, D7 |
| STALE | 10 | A3, A4c, A6, A7, B1, B4, C3′, C6, E4, E5 |
| UNVERIFIED | 2 | A4b, B3 (Lean lane) |
| SPLIT / mixed | 2 | B13, D4 (real as code, expired as operation) |
| NOT PRESENT / INERT | 2 | E1, E2 (ban layers, not paper claims) |

**Headline.** The paper is unusually honest for its genre — twenty-eight
confirmed rows, and every one of §16.4's seven negative claims survives
scrutiny. Its problems are almost entirely *temporal*, not *rhetorical*: one
overstatement against the tree, ten rows expired by a directive that postdates
the final commit by less than half an hour, and three places where it now
undersells itself.

**Worst overstatement:** §15.3's "The Cubical Agda development is accepted
under `--cubical --safe`", falsified by two failing modules under the pinned
toolchain — aggravated because `BUILD.md`, the ledger the paper defers to,
carries the same error in stronger form ("every module, exit 0").

**Strongest understatement:** §16.3 listing theorem transport among things
"specified but not generally implemented", when `TransportInstance.agda` closes
§17 step 4 end to end inside the root aggregate.

**Largest blast radius:** not either of those, but the §16.1 / §10.1 / §13.3
runtime rows, which describe a compiler, a snapshotter, and a validator set
that the repository has forbidden itself to run.

---

*Audit only. No architecture is proposed. `codex-skein` judges what enters the
paper; nothing above has been applied to it.*
