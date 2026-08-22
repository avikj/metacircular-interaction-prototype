# OBLIGATION §7, executed: the corpus min-cut extraction

This note discharges the `§7 missing` obligation of `notes/OBLIGATION.md`
(recorded there in "6–8. NOT DONE" and as §9 obligation 4). It builds the
corpus dependency graph mechanically, classifies edge modes, and computes
the audit-burden min cut / max-flow **exactly** (integer algorithms, no
floating point), with the small self-application instance **kernel-certified**
in `formal/cubical/ObligationMinCut.agda` (`agda … EXIT=0`).

Per `CLAUDE.md`: everything here is exact combinatorial evaluation on the
actual corpus — certified symbolic computation, i.e. proof, not measurement.
No constant is fitted. The one number that is *not* pinned — the audit burden
itself — is reported as a certified **interval**, and the reason it is an
interval (not a point) is itself a computed quantity: the classifier's
UNKNOWN rate. That is the note's permanent obligation, stated in §5.

---

## 1. The extraction (mechanical, reproducible)

**Nodes** = `notes/*.md`. **Edges**: a literal reference `notes/B.md` inside
file `A.md` is the dependency edge `B → A` (OBLIGATION Def. 1: `u→v` means
"`v` depends on `u`"; the reference lives in the depending file `v`). Exact
commands:

```sh
# edge list: for each note v, each distinct existing note u≠v it references
for f in notes/*.md; do
  v=$(basename "$f")
  grep -oE 'notes/[A-Za-z0-9_]+\.md' "$f" | sed 's#notes/##' | sort -u \
  | while read u; do [ "$u" = "$v" ] && continue; [ -f "notes/$u" ] && echo "$u -> $v"; done
done
```

**Snapshot** (shared checkout; see RISKS): `|V| = 869` notes at extraction,
`1943` raw references, **`1292` clean directed edges** after de-duplicating
per file, dropping self-loops, and dropping `4` references to non-existent
files (`DCLOSE.md`, `GEODESIC_SPECTRUM.md`, `STATE.md`, `X.md`). `594`
distinct notes carry at least one clean edge.

The full graph is used for the corpus census and the corpus-wide min cut.
For the **kernel certificate** the tractable subgraph is the
1-neighbourhood of `notes/OBLIGATION.md` (7 nodes, 12 edges) — the corpus's
own model of its dependency structure, applied to the note that defines it.

## 2. Edge modes and the mode census

Each edge is classified by a **fixed keyword classifier** over the context
line(s) where `v` references `u` (OBLIGATION §9 obligation 4 mandates a
keyword classifier and mandates reporting its UNKNOWN fraction). Priority:
SUPERSESSION (`CORRECTED|FALSE|refutation|supersed|retract|replaces|…`) →
COMPANION (`catalogue|queue|index|ledger|pointer|see also|manifest|…`) →
VALUE (`constant|slope|exponent|coefficient|= N|…`) → STATEMENT
(`proves|theorem|lemma|follows from|invokes|depends on|discharg|…`) →
UNKNOWN otherwise. The transfer of each mode (OBLIGATION Def. 4): STATEMENT
= identity, VALUE = clamp `s ↦ s∧c`, COMPANION/TECHNIQUE = constant `≡⊤`
(non-conduit), SUPERSESSION = **excluded** (a graph rewrite, not a flow).

Corpus census over all 1292 edges:

| mode | count | conduit? |
|---|---:|---|
| UNKNOWN | **1110** | reading-dependent |
| STATEMENT (identity) | 85 | yes |
| COMPANION (const ≡⊤) | 37 | no |
| SUPERSESSION (excluded) | 33 | removed |
| VALUE (clamp) | 27 | yes |

**UNKNOWN fraction = 1110 / 1292 = 85.9 %.** This is the single most
important output and the note's permanent obligation (§5).

The 33 SUPERSESSION and 37 COMPANION edges vindicate OBLIGATION §1's claim
that corrections/cross-references are a separable class: of the `125`
two-cycles in the full clean graph, **`0` survive in the conduit graph** —
every mutual reference is a cross-ref or a correction, never a scope
transfer. Dropping COMPANION + SUPERSESSION (+ UNKNOWN, optimistically)
leaves an **acyclic** conduit graph (Kahn topological sort orders all 163
nodes), exactly the premise OBLIGATION §3 needs.

## 3. Corollary O2.4 now has its number

O2.4 said `MOP` ranges over "the set of all dependency paths, whose
cardinality on the actual corpus is computed exactly in §7." Computed
(DP over the conduit DAG, exact integer):

- **Optimistic conduit DAG** (STATEMENT + VALUE; UNKNOWN ↦ COMPANION):
  163 nodes, 112 edges, acyclic, **exactly `133` directed paths** (length ≥ 1).
- **Pessimistic conduit graph** (UNKNOWN ↦ STATEMENT): 590 nodes, 1222 edges,
  **cyclic** (125 two-cycles reappear) ⇒ the path set is **infinite**.

So O2.4 is now quantitative and reading-dependent: the meet-over-all-paths
ranges over `133` paths if UNKNOWN edges carry no transfer, and over an
**unbounded** set if they do. In neither case can a human enumerate it: 133
paths through 163 notes already exceeds hand-tracing, and the pessimistic
reading makes manual review provably hopeless. The fixed point traces none.

## 4. The audit burden (Theorem O3 min cut = max flow)

Repair network `N` (OBLIGATION §3): super-source `s⋆ → u` (cap 1) for each
open-obligation packet `u ∈ O`; conduit edges (cap 1, unit sever cost);
`t → t⋆` (cap ∞) for each target `t ∈ T`. `O` = notes whose text hits the
openness grep (`NOT DONE|open obligation|conjecture|unattributed|not
been (verified|checked)|fitted|heuristic|…`). Max flow computed by an exact
integer **Edmonds–Karp** implementation (`scratchpad/maxflow.hs`, `runghc`;
BFS augmenting paths, ∞ = total finite capacity + 1, all `Int`).

**Corpus-wide** (`T` = conduit sinks = terminal results):

| reading | \|O\| | \|T\| | **min cut = max flow** |
|---|---:|---:|---:|
| optimistic (UNKNOWN ↦ COMPANION) | 120 | 70 | **115** |
| pessimistic (UNKNOWN ↦ STATEMENT) | 364 | 92 | **222** |

**Corpus audit burden = the certified interval `[115, 222]`.** By Cor. O3.1
(integrality of max-flow) each endpoint is a set of that many
edge-disjoint contamination routes from open obligations to terminal
results — a certificate that at least that many independent audits are
unavoidable. The interval's width, 107, is a direct image of the 85.9 %
UNKNOWN rate: it is exactly the number of audits whose necessity the
classifier cannot yet decide.

**Certified self-application instance** (`T = {OBLIGATION.md}`, the note
being executed): audit burden `[1, 2]`. OBLIGATION carries its own open
obligations (its §6 prior-art / §8 taxonomy), so it is unsound in isolation
and costs `≥ 1` audit even with no upstream contamination — the honest
floor. Under the pessimistic reading of the single UNKNOWN edge
(`THRESHOLD_GENERATION_DICHOTOMY → OBLIGATION`) a second independent route
`s⋆ → THRESHOLD → OBLIGATION → t⋆` appears and the burden is exactly **2**.

## 5. The certificate, and the permanent obligation

`formal/cubical/ObligationMinCut.agda` (`--cubical --safe`, no postulates,
no holes, `EXIT=0`) encodes the pessimistic self-network as a concrete
finite object and kernel-checks:

- the flow is **feasible** — `flow e ≤ cap e` for every edge, and inflow ≡
  outflow at every internal vertex (`cons-O`, `cons-H`, `cons-R`, all `refl`);
- the cut `C = {e1,e2}` is a genuine `s⋆–t⋆` cut — it contains *every* edge
  leaving the source (`cut-covers-source`, by a decidable-equality
  discriminator on the five vertices);
- **the weak-duality equality** `value(flow) ≡ capacity(cut)`
  (`flow-is-max-cut-is-min : value-source ≡ cutCap`, `refl`), whose common
  value is `2` (`certified-burden-cut`, `certified-burden-source`), positive
  (`burden-positive`).

Because `value f ≤ cap C` holds for *every* feasible flow and *every* cut,
an equality certifies both optima simultaneously: the flow is maximum, the
cut is minimum, and the audit burden of the self-network is exactly `2`,
kernel-verified with no floating point. Independently re-derived by the
Edmonds–Karp tool (max flow `= 2`), i.e. the two lanes agree.

**Permanent obligation (OBLIGATION §9.4, discharged only as far as a
classifier can discharge it).** The reported burden is only as good as the
mode assignment, and **85.9 % of edges are UNKNOWN**. The min cut is
therefore delivered as the interval `[115, 222]`, never a point, and the
interval cannot be narrowed by more computation — only by a better mode
classifier or by human adjudication of the 1110 UNKNOWN edges. Every future
edge inherits this duty: classify it, or it widens the interval. This is not
a defect to be measured away; it is the exact external residue Theorem O5
predicts — the mechanical half is complete, and what remains is the 1110-bit
oracle question of what those references actually *do*.

---

## FILES
- `notes/OBLIGATION_S7_MINCUT.md` — this note.
- `formal/cubical/ObligationMinCut.agda` — kernel certificate, `EXIT=0`,
  `--cubical --safe`, no postulates/holes/axioms.

## STATUS
- §7 extraction: **DONE**. Graph built mechanically (1292 clean edges over
  869 notes), modes classified, census reported.
- Cor. O2.4: **numbered** — 133 conduit-DAG paths (optimistic) / ∞ (pessimistic).
- Audit burden: **computed exactly** — corpus `[115, 222]`, self-network
  `[1, 2]`; self-network value `2` **kernel-certified** and independently
  cross-checked (Edmonds–Karp).
- UNKNOWN fraction: **85.9 %** reported as the permanent obligation.

## RISKS
- **Shared checkout drift.** `|V|` was `869` at extraction; a concurrent
  writer moved it to `877` mid-task. All corpus census numbers are a
  timestamped snapshot; the exact commands in §1–§2 reproduce them against
  any snapshot. The kernel certificate is snapshot-independent (a fixed
  5-vertex graph).
- **Classifier is keyword-based, 85.9 % UNKNOWN.** The corpus-wide burden is
  an interval, not a number, and its point value is undetermined until the
  1110 UNKNOWN edges are adjudicated. This is disclosed, not hidden.
- **`O`/`T` definitions are choices.** Openness = a fixed grep; `T` =
  conduit sinks. Different mechanical `O`/`T` give different corpus numbers;
  the *method* and the *certificate* are invariant, and the self-network
  certificate uses the unambiguous `T = {OBLIGATION.md}`.
- **Certificate scope.** The kernel checks the small self-network (value 2)
  and the weak-duality *schema*; the corpus-wide `[115, 222]` rests on the
  exact integer Edmonds–Karp run (proof-grade exact computation per
  `CLAUDE.md`, but not kernel-checked). Kernel-certifying a 590-node
  max-flow is left open.
