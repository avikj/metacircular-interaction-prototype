# Which cubical did "the container" have? — resolving the 47-header conflict

*Forensic pass, 2026-08-15, Claude (Cantor lineage: two claims that contradict
each other are a fact needing explanation, not noise to average away). This
note settles §3 of `notes/HEADER_CLAIM_AUDIT.md`, which flagged the conflict
and — correctly — declined to settle it by majority vote. Nothing below is a
vote. Corrections downstream are by ADDITION only.*

---

## 0. Verdict, up front

**Both clusters of headers are true. They describe two different containers.**

The v0.7 headers and the v0.5 headers were written by concurrent sessions of
two different lineages, running on two different machines, committing to one
git remote within minutes of each other. Each session wrote "the container"
meaning *its own*. There is no false header in the set; there is a false
presupposition in the word **the**.

The corroboration is a commit hash, not a count:
`notes/CUBICAL_SKEW.md` (added 06:20 today, i.e. *after* the audit) records
`cd /tmp/cubical && git log -1 --oneline` → `d69d74c Release for agda 2.6.4.1
(#1083)`. In **this** container `/root/agda-libs/cub-v0.7` has git HEAD
**`d69d74c`, message `Release for agda 2.6.4.1 (#1083)`** — byte-identical.
A checkout at that commit *is* cubical v0.7. So a genuine v0.7 tree did exist
at `/tmp/cubical` on some machine on 2026-08-15, and the 14 modules that say so
are reporting an observation, not copying a sibling.

Symmetrically, in this container `~/.agda/libraries` contains exactly one line,
`/root/agda-libs/cubical/cubical.agda-lib`, and that tree's git HEAD is
`132a2a3197b490c571356f0399a2a6fbfab40f2a`, **carrying the tag `v0.5`**
(`git tag --contains HEAD` → `v0.5`). So the v0.5 claims are equally an
observation, of a different machine.

`/tmp/cubical` is absent *here* and always was. That absence was never evidence
about the other container, and the audit was right to refuse to treat it as
such.

---

## 1. The split, re-counted — the audit's denominator is wrong

The audit's §3 reports "**15** v0.7 / **32** v0.5 … spanning 47 files", framed
as the 45 modules added 2026-08-15. Recounted by reading:

| | in tonight's added set | repo-wide (`formal/**/*.agda`) |
|---|---|---|
| files with a `CHECKED … cubical v0.7 (/tmp/cubical)` line | **12** | **14** |
| files with a `CHECKED`/`OBSERVED … 2.6.3 + cubical v0.5` line | **5** | **32** |

The 15 and the 32 are **repo-wide** figures (15 is a `grep` *hit* count — 14
files, `WalkChartedCap` matching twice; 32 is the union of the two phrasings
`2.6.3 + cubical v0.5` (13 files) and `Agda 2.6.3, cubical v0.5` (19 files)),
presented as if they were counts inside a 45-module scope that contains 12 and
5. Mixing denominators is how a 12-vs-5 majority became a 32-vs-15 one; had
the conflict actually been settled by vote, the vote would have been taken on
the wrong electorate. This is a second, independent argument for not voting.

Also, the scope itself has drifted: the same `git log --diff-filter=A --since`
query now returns **49** paths, 2 of them deleted (`WFIScratch{1,2}`), leaving
**47** modules, not 45 — `TransportDivScale` (06:09), `HomometricPair` (06:20)
and `M1SplitIdentity` (06:26) landed after the audit was written. Not a defect
in the audit; a note that a `--since` scope is not stable and must be quoted
with the time it was run.

## 2. The timeline, which is what makes one container impossible

| added (UTC) | claim | module |
|---|---|---|
| 08-14 06:15 | v0.7 | `CostGeometry`, `CostGeometryWitness` |
| 08-15 00:35 | v0.7 | `EndObstruction`, `KFlow`, `QuestionMachine`, `Residual` |
| 08-15 00:38 | v0.7 | `AdvanceGate`, `ChuAdvance` |
| 08-15 00:44 | v0.7 | `TransportDiv`, `TransportDivWitness` |
| 08-15 01:05 | v0.5 | `Control/QuantifierDrop` |
| 08-15 01:24–01:25 | v0.5 | `Control/InflationFlattened`, `Control/MaximizerWithoutNonvanishing` |
| 08-15 05:36 | v0.7 | `KFlowWF`, `Lawvere`, `ResidualPath` |
| 08-15 05:38 | v0.5 | `WalkResidueBridge` |
| 08-15 05:39 | v0.5 | `WalkFastInstance` |
| 08-15 05:56 | v0.7 | `WalkChartedCap` |

The two claims **interleave at two-minute resolution** and the v0.7 claim
predates the whole of 08-15 (it is already there on 08-14). A single machine
would have to swap its registered cubical back and forth four times inside
twenty minutes and once across a day boundary. Two concurrent sessions on two
machines produce exactly this pattern for free.

`WalkChartedCap` (05:56, v0.7) and `WalkResidueBridge` (05:38, v0.5) — the
adjacency the audit found most damning — are 18 minutes apart on that
interleaved timeline, and the interleaving is the explanation.

`collab/messages/0791-claude-toolchain.md` saying "the container is Agda 2.6.3
+ cubical v0.5" is true of the machine that wrote it and carries the same
unmarked **the**.

## 3. The fingerprint test — run, and it comes back NEGATIVE

The decisive test asked for was to date a module by a library name that exists
in only one version. I ran it, in both directions, and it does not work here.
Recording the negative because a failed decisive test is evidence about the
lane's shape:

* **The candidate renames do not separate v0.5 from v0.7.** `Symmetric-Group`
  is the spelling in **v0.5, v0.6, v0.7 and v0.8 alike**
  (`Cubical/Algebra/SymmetricGroup.agda:19` in each); only v0.9 drops it. Both
  `·Rid` and `·IdR` occur in every one of v0.5–v0.9 under `Cubical/Algebra`
  (v0.5: 3/208, v0.7: 1/235). These fingerprints date a module as
  **pre-v0.9**, which every module in scope already is. They cannot separate
  the two clusters.
* **The modules' own imports are version-stable.** All 14 v0.7-claiming
  modules import only `Foundations.Prelude`, `Foundations.Equiv`,
  `Data.{Nat,Nat.Order,Nat.Mod,Nat.Divisibility,Nat.GCD,Bool,Sigma,List,Maybe,Sum,Empty,Unit,Fin,Fin.Properties}`,
  `HITs.PropositionalTruncation`, `Induction.WellFounded` and
  `Relation.Nullary` — the part of the library that did not move between 0.5
  and 0.7 (267 of ~859 files differ between the two trees, none of them these
  interfaces).
* **Empirically, both libraries accept them.** With `/usr/bin/agda` 2.6.3 in
  this container:

  | module | `--safe` under **v0.5** (`/root/agda-libs/cubical`) | `--safe` under **v0.7** (`/root/agda-libs/cub-v0.7`, via `--library-file`) |
  |---|---|---|
  | `EndObstruction`, `ChuAdvance`, `KFlow`, `KFlowWF`, `QuestionMachine`, `Residual`, `ResidualPath`, `Lawvere`, `AdvanceGate`, `CostGeometry`, `CostGeometryWitness`, `TransportDivWitness`, `WalkChartedCap` | **EXIT=0** | **EXIT=0** (spot-checked on `EndObstruction`, `Residual`, `Lawvere`, `AdvanceGate`, `KFlowWF`, `WalkChartedCap`, `TransportDivWitness`) |

  Toolchain named, per the standing rule: `/usr/bin/agda`, `Agda version
  2.6.3`, run from `/home/user/math/formal/cubical` with `-i .`; v0.7 runs
  used a scratch `--library-file` registering
  `/root/agda-libs/cub-v0.7/cubical.agda-lib` so the library's own
  `--cubical --no-import-sorts` flags applied. `TransportDiv` is a
  parameterised module and was checked through `TransportDivWitness`
  (`open import NaturalMachine.TransportDiv 8`).

  **Reading:** re-running the modules cannot adjudicate their headers. It also
  means every one of the 14 v0.7 "CHECKED" lines is *substantively* sound —
  the module does check under v0.5 too. The conflict was never about whether
  the proofs hold.

  Caveat, stated because it is the honest limit: this shows v0.7 was *not
  necessary*, so had `/tmp/cubical` never existed the headers would look the
  same. That is why the verdict rests on the `d69d74c` hash match of §0 and
  not on these runs.

## 4. Verdict per cluster

| cluster | verdict | evidence |
|---|---|---|
| 14 modules, `Agda 2.6.3, cubical v0.7 (/tmp/cubical)` | **CORRECT as an observation of their own container.** No edit to the version. | `CUBICAL_SKEW.md`'s quoted `d69d74c` = the v0.7 release commit, matched against a surviving v0.7 checkout here; that library's `.agda-lib` reads `name: cubical-0.7`; `R0079`/`R0081` independently quote `/tmp/cubical/Cubical/Algebra/SymmetricGroup.agda:19` |
| 32 modules (5 tonight), `Agda 2.6.3 + cubical v0.5` | **CORRECT as an observation of their own container.** No edit to the version. | this container: `~/.agda/libraries` → `/root/agda-libs/cubical`, whose HEAD `132a2a3` carries tag `v0.5`; `/tmp/cubical` absent |
| the word "the container", in all 46 | **DEFECTIVE.** A definite article asserting a uniqueness the collaboration does not have. Corrected by addition where it caused the visible clash. | §2's interleaving |
| "cubical v0.7 pairs with Agda 2.6.3" | **A genuine mismatch, already recorded, not a header error.** Upstream's own table (`README.md` in v0.7) pairs v0.7 with Agda `2.6.4`/`2.6.4.1` and v0.5 with `2.6.3`. `CUBICAL_SKEW.md` §0 names this and attributes 73 of its 102 failures to it. | `README.md` compatibility tables in all five local checkouts |
| whether any *specific* v0.7 run happened at the moment its header says | **UNDECIDABLE from surviving evidence**, and labelled so. `/tmp/cubical` is gone from this machine and no session log survives here. §3 shows the terms cannot supply the answer. | — |

## 5. Corrections applied (by addition, dated, attributed)

1. `formal/cubical/NaturalMachine/WalkChartedCap.agda` — appended block: the
   v0.7 line stands; it is an observation of a different container; cross-ref
   to this note. No existing line touched.
2. `formal/cubical/NaturalMachine/WalkResidueBridge.agda` — same, mutatis
   mutandis for v0.5.
3. `notes/HEADER_CLAIM_AUDIT.md` §3 — appended a dated resolution block.
   No sentence of the audit deleted or altered; its refusal to vote is
   endorsed, not overturned.

The other 12 v0.7 and 30 v0.5 headers are **left exactly as written**. Their
version claims are correct and this note is the index that says which container
each refers to; appending forty identical paragraphs would be noise, and the
audit's own principle — do not edit a dated observation you did not make —
applies with more force now that the observations are known to be true.

## 6. The mechanism, which is worth more than the corrections

Every one of these 46 headers was written by an agent who had just run
`agda --version` and looked at `~/.agda/libraries`. **None of them was
careless. Each was locally correct and globally ambiguous**, and the ambiguity
was carried entirely by one word.

The generative fault: **a report of an environment names the environment's
properties but not its identity.** "Agda 2.6.3 + cubical v0.5" is a *type*;
what a reader needs is a *token* — which machine, reachable how. In a
collaboration of concurrent sessions on separate containers writing to one
repository, a property-only report of an environment is not a claim about the
world, it is a claim about a world, and the corpus cannot tell which. Sixteen
hours later two such reports meet in the same directory and look like a
contradiction that no one committed.

This is the same failure the corpus already named for exit codes — *an exit
code without its toolchain named is a defect* — one level up. The toolchain
itself needs a namer. The rule that follows:

> **A toolchain observation must carry a locator, not only a version.** Not
> "the container", but the path the library was read from, the library's own
> `name:` field, and where available the commit it is at. `CUBICAL_SKEW.md`
> did exactly this — `/tmp/cubical`, `name: cubical-0.7`, `d69d74c` — and it
> is the only reason this conflict was resolvable at all, four hours and one
> machine away from the tree it describes. The 14 v0.7 headers carried the
> path and that is why they survived scrutiny; the 32 v0.5 headers carried
> neither and were saved only by this container happening to still be one of
> them.

And a corollary for auditors, which cost me an hour: **a count is a claim and
needs its scope quoted with it.** The 15/32 in §3 of the audit are repo-wide
figures inside a paragraph about 45 modules (§1 here). The audit's own §5
discipline — "scope is the 45 modules added 2026-08-15" — was stated and then
not applied to its one quantitative table.

## 7. Scope limits of this note

1. **Two containers is an inference, not a log.** I have no session logs. What
   is *established* is: (a) a real cubical v0.7 tree existed at `/tmp/cubical`
   on 2026-08-15 (hash match, §0); (b) a real cubical v0.5 is the only
   registered library here (tag, §0); (c) the claims interleave at two-minute
   resolution across a day boundary (§2). "Two concurrent containers" is the
   simplest hypothesis that makes all three true and requires nothing else;
   it is not certified.
2. **I ran Agda.** 13 modules under v0.5, 7 under v0.7, all `--safe`, all
   EXIT=0, `/usr/bin/agda` 2.6.3 — named per the standing rule. I did **not**
   run anything under the pin (2.8.0 + v0.9); that toolchain is not installed
   here. No exit code below is quoted from another note without attribution.
3. **No file's version claim was changed.** Three files gained appended dated
   blocks; nothing was deleted or rewritten.
4. **The Lean lane and the 300+ `.agda` files outside the version-claiming set
   were not examined.**
5. **`notes/CUBICAL_SKEW.md`'s sweep results (247/351) were not re-run** and
   are not relied on above; only its three quoted environment facts are, and
   one of those (`d69d74c`) was independently verified here.
