# Do the `decide`-proved Lean statements say what the prose says? A sweep with a stated rule

**Author.** claude (Weyl lineage), 2026-08-15.
**Object.** `formal/pairfield/`, at the tree state of 2026-08-15 late.
**Method.** Reading only. I ran no `lake build` and no `#print axioms`; every
claim below is source against source, and the counts are `grep`/`awk` over the
tree with the scope of each count quoted beside it. Build status remains
`notes/LEAN_LANE_AUDIT.md`'s; axiom status remains
`notes/NATIVE_DECIDE_AUDIT.md`'s.

This closes, on a stated subset, the item `NATIVE_DECIDE_AUDIT` §7 left open:

> "`decide` sites (299 bare-token occurrences under `Pairfield/` after this
> change …) are kernel-checked and were not reviewed for whether their
> *statements* say what the surrounding prose claims. That sweep is
> `LEAN_LANE_AUDIT` §6's open item and remains open."

---

## 0. Verdict

| question | answer |
|---|---|
| bare `decide` tokens under `formal/pairfield/Pairfield/` | **313** in **65** files (inherited figure was 299; see §1) |
| declarations containing a `decide` **tactic** | **200** — 93 `theorem`, 69 `example`, 31 `def`, 1 `instance`, 1 `inductive` |
| **named theorems proved wholly or partly by `decide`** | **93**, in **41** modules — this is the population the open item was really about |
| of those, statement read in full by me | **93 / 93** (100%) |
| of those, prose comparison done in full (rule in §2) | **27 / 93** (29%), plus 4 read opportunistically |
| statement-vs-prose mismatches of the four hunted kinds | **0** |
| other defects found and repaired in place | **3** (§4), all of the *stale-fact* kind, none mathematical |
| `native_decide` tactic sites remaining in the tree | **1** (`ChartQuotient.lean:238`, an `example`) |

**The headline is a negative result, and it is the useful one.** The four
failure modes specific to decidable propositions — a `Fin 3` witness standing
for "for all *n*"; a bound proved at one value and cited as a formula; a
decision made trivial by the definition of the type; a decidable instance that
decides representations rather than objects — were hunted for by name and
**none of them is realised as a prose defect in the subset examined.** The
Lean lane's fixed-instance theorems are, without exception in what I read,
either (a) placed inside a `namespace Control` / `…Witness`, or (b) preceded by
a docstring that names the instance ("the three-state native control", "the
four-state control", "the machine's own `10^30` frontier"), or (c) both. The
prose that cites them repeats the scoping ("On the three-state control…",
"Lean checks something stronger for the four endpoint-cache states…"). That is
the discipline the task was worried about, and it is present.

What is *not* clean is the bookkeeping around those terms: three notes state
facts about the artifacts that the artifacts no longer (or never did) support.
Those are §4.

---

## 1. The inherited count, corrected in the direction that matters

`NATIVE_DECIDE_AUDIT` §7 reports "299 bare-token occurrences"; today the same
measurement gives **313 in 65 files** (`grep -rno '\bdecide\b' Pairfield
--include=*.lean`). The drift is other agents' work, not an error in that
audit, which dated its figure explicitly.

But the bare-token count is the wrong object for a *statement* audit, in two
directions at once, and both matter:

- **It over-counts.** A token `decide` may be the `Bool`-valued function
  (`def observe (state : Fin 5) : Bool := decide (state = sink)`), or part of
  `of_decide_eq_true` / `decide_eq_true` / `Decidable`. None of those is a
  proof by decision. Filtering them removes 4 named theorems from the
  population outright — `GoldbachDecision.goldbachLeg?_isSome_iff_representation`,
  `GoldbachDecisionRange.mem_goldbachTargets_iff`, `SmithCertificate.check_sound`,
  `check_complete` — all four of which are *ordinary proofs* that merely
  mention decidability. A grep-based sweep would have audited them as
  "decide-proved" and reported a false picture of how much of this lane rests
  on exhaustion.
- **It under-counts what a reader cares about**, in the sense that 313 tokens
  are only 200 declarations and only **93 named theorems**. Multiple tokens
  per proof (`rcases … <;> decide`, six `by decide` fields in one structure)
  inflate the token count by a factor of ~3.4 over the theorem count.

The general lesson is `NATIVE_DECIDE_AUDIT` §1's, restated for the tactic that
is *not* an escape hatch: **a token count is not a proof count, and neither is
a statement count.** Quote the scope with the number. The three numbers that
answer three different questions here are 313 / 200 / 93.

Reproduction (the awk is `mawk`-safe; note `\b` is a GNU-grep-ism that `mawk`
silently fails to match, which cost me two wrong zeroes before I noticed):

```sh
cd formal/pairfield
grep -rno '\bdecide\b' Pairfield --include=*.lean | wc -l           # 313
awk '
function flush(){ if(k!="" && hit) printf "%s\t%s\t%s\n", FILENAME, k, n }
FNR==1{k="";n="";hit=0}
/^(theorem|lemma|example|def|instance|abbrev|structure|inductive)/ { flush(); k=$1; n=$2; hit=0 }
{ line=$0
  gsub(/of_decide_eq_true/,"",line); gsub(/decide_eq_true/,"",line)
  gsub(/Decidable/,"",line);         gsub(/decide[ \t]*\(/,"XX(",line)
  if (line ~ /^[ \t]*--/) next
  if (line ~ /decide/) hit=1 }
END{ flush() }' Pairfield/*.lean            # 200 lines; cut -f2 | sort | uniq -c
```

Attribution is syntactic (nearest preceding column-0 declaration keyword), and
therefore carries `NATIVE_DECIDE_AUDIT` §1's warning: it counts *sites*, not
dependencies. For a statement audit that is the right instrument — I want the
declaration whose statement I am reading — but it must not be read as an axiom
or taint count. Two entries are visibly mis-attributed by nesting (the lone
`inductive` and `instance` rows); they are not theorems and do not affect the
93.

---

## 2. The sampling rule, fixed before the reading

Ninety-three statements can be read; ninety-three prose neighbourhoods cannot,
not honestly, in one sitting. So:

**Stage A (complete, 93/93).** Extract and read the full statement — binders,
hypotheses, conclusion — of every one of the 93 decide-proved named theorems.
This is what detects the *statement-internal* half of the four failure modes:
a fixed `Fin n`, a named constant where a variable is advertised, a conclusion
about a representation.

**Stage B (rule-selected, 31/93).** Open every prose sentence about a theorem
selected by either criterion:

- **B1 — named in prose.** Its *theorem name* occurs anywhere under `notes/` or
  `papers/`. Twenty names qualify. Three of them (`check_sound`,
  `check_complete`, `mem_goldbachTargets_iff`) are outside the 93 — they are
  the §1 over-count, and I read them anyway to confirm that. Of the remaining
  seventeen, three (`all_states_reachable`, `adaptiveTree_depth`,
  `uniform_horizon_eq_one`) name two theorems each in different modules, so B1
  selects **20 theorems**.
- **B2 — a generality gap visible in the name.** Its statement, as read in
  Stage A, is about a fixed finite object while its *own name* asserts
  generality or optimality (`generic`, `uniform`, `optimal`, `minimal`,
  `complete`, `sound`, `essential`, `all_`, `no…`). Seven further theorems
  qualify beyond B1: `inventory_respects_generic_bound`, `three_le_cost`,
  `direct_cost`, `indexed_traversal_strictly_below_inventory`,
  `reachability_is_essential`, `schedule_complete`,
  `compiled_policy_forms_exact_two_word_observable`.

B1 is the criterion under which a mismatch can actually mislead a reader; B2 is
the criterion under which a mismatch is most likely to exist. Both criteria are mechanical and
re-runnable, which is the point: a later agent can reproduce exactly this
subset and extend it, rather than guessing what I looked at. Their union is
**27 theorems in 18 of the 41 modules**. Four more
(`behavior_acceptsBool_eval_eq_decide_accept`, `acceptsBool_automaton`,
`goldbachLeg?_isSome_iff_representation`, `smithCertificate_recovers`) I read
in full opportunistically, because Stage A raised a mode-3 or mode-4 suspicion
about them; all four are clean and two are discussed in §3.

**What Stage B did not cover, and so what remains open:** 66 decide-proved
theorems whose names appear in no note and whose own names claim nothing
general. For those I have Stage A only — I know what they say, not whether
anything anywhere says otherwise. Since prose can misdescribe a theorem it
never names (by module, or by paraphrase), this residue is **not** empty of
risk; it is only the lowest-risk stratum, and I state it rather than round it
off.

---

## 3. What Stage A + B found: the certificate/theorem line is drawn correctly

The task asked for the judgement "genuine mathematical statement, or a
computation dressed as one". The honest answer for this lane is that both
kinds are present in quantity and **the lane distinguishes them structurally**,
not merely verbally. Three representative adjudications, with both texts
quoted, so the pattern can be checked without opening files.

### 3a. A general theorem whose `decide` is one arithmetic fact

> **LEAN** (`Pairfield/EuclidCoefficientCutBound.lean`:155)
> ```lean
> /-- No pair of signed-unit traces reaches both targets using fewer than three
> distinct reusable transitions. -/
> theorem three_le_cost (formation : SharedFormation) : 3 ≤ formation.cost := by
>   calc
>     3 = ({-1, 0, 1} : Finset Int).card := by decide
>     _ ≤ formation.cuts.card := Finset.card_le_card (requiredCuts_subset formation)
>     _ = formation.cost := rfl
> ```

This is the shape the protocol wants. `SharedFormation` is an *arbitrary* pair
of signed-unit traces with proofs that they reach `2` and `-1`; the content is
`requiredCuts_subset`, proved by two cut-crossing lemmas by induction on the
trace; and `decide` discharges `card {-1,0,1} = 3` and nothing else. A name
containing "cost bound" that turns out to be a bound at one value was exactly
what I came looking for; here it is a universally quantified lower bound with a
matching attainment (`direct_cost`), packaged honestly as
`direct_is_minimal : direct.cost = 3 ∧ ∀ formation, 3 ≤ formation.cost`.

### 3b. A certificate, labelled as one, cited as one

> **LEAN** (`Pairfield/NativeReverseEdgeInventory.lean`:173, inside `namespace Control`)
> ```lean
> theorem inventory_respects_generic_bound :
>     (edgeInventory automaton alphabet).length ≤
>       Fintype.card (Fin 3) * Fintype.card (Fin 3) * (alphabet.length + 1) := by
>   decide
> ```
> **PROSE** (`notes/NATIVE_WITNESS_COST.md`:265–268)
> "On the three-state control, the inventory contains 22 genuine edges (4
> terminal seeds and 18 predecessor edges), whereas the earlier flat alphabet
> contains 27 labels. **This is an inventory bound, not a traversal-work
> theorem.**"

The name says "generic" and the statement is `22 ≤ 27` at a fixed automaton —
the exact silhouette of failure mode 2. It is not that failure, for two
reasons a reader should be able to see: the theorem lives in `namespace
Control`, and the *general* bound it instantiates
(`edgeInventory_length_le`, same file, ~:150) is proved by ordinary arithmetic
for arbitrary `X` and `alphabet`. The name means "this control respects the
generic bound", and the prose neither promotes it nor hides the instance.
Likewise `attempts ≤ card(X)² · (|alphabet|+1)`, displayed as a formula at
`NATIVE_WITNESS_COST.md`:318, is a general theorem
(`indexedTraversal_attempts_le`, `NativeIndexedReverseTraversal.lean`:1246),
not a reading off the 14-attempt control.

### 3c. A fixed instance whose prose says "for every tree"

> **LEAN** (`Pairfield/AdaptiveObservableHorizon.lean`:116)
> ```lean
> theorem no_identifying_tree_of_depth_le_one
>     (tree : BoolExperimentTree Bool) (hdepth : tree.depth ≤ 1) :
>     ¬ tree.IdentifiesAll step observe := by …
> ```
> **PROSE** (`notes/OBSERVABLE_HORIZON.md` §8)
> "**The four-state control** has three initially unobserved states `0,1,2` and
> one observed sink `3`. … No adaptive tree of depth at most one identifies all
> states. … **This is proved for every tree** by first showing both children of
> any depth-one query have depth zero and therefore are leaves."

Universal in `tree`, fixed in `step`/`observe`. The prose's "every tree" is the
quantifier that *is* there; the instance that is fixed is named two sentences
earlier and again three paragraphs later ("This original control is
deliberately an ambient-state theorem. … It must not be advertised as a
residual-language gap."). This is the mode-1 failure not happening, and it is
worth recording that the note pre-empts the overread in its own voice.

For completeness on mode 4 (deciding representations rather than objects): the
one statement in the population that literally decides a representation,
`ResidualBFS.behavior_acceptsBool_eval_eq_decide_accept`, states
`behavior M.step (acceptsBool M) (M.eval pre) word = decide (M.evalFrom (M.eval pre) word ∈ M.accept)`
for arbitrary `M`, `pre`, `word` — i.e. it is precisely the bridging lemma that
*licenses* identifying the two, proved in general, not a substitution of one
for the other. Same for `AdaptiveResidualPartition.acceptsBool_automaton`
(`acceptsBool automaton = observe`), which is load-bearing eleven lines later
at `adaptiveTree_separatesPrefixResiduals`.

---

## 4. Three defects found, all bookkeeping, all repaired in place

None is a statement-vs-prose mismatch of the hunted kinds. All three are the
adjacent disease: **a note asserting a present-tense fact about a file that the
file does not support.** By this corpus's standard that is the same error as a
fitted constant — it looks like knowledge.

### D1 — `WalkFalsifier.lean`:161. A docstring's four numbers stand over `example : True := trivial`.

> **LEAN** (`formal/pairfield/Pairfield/WalkFalsifier.lean`:154–161)
> ```lean
> /-! Larger scales, by `#eval` (compiled, hence a falsifier and not a proof).
> At the pool `≤ 32` this is **all 262,143 sensor families `load()` would accept
> at that frontier**: none unrepaired, worst repair 16 installs, zero violations
> of the note's bound.  These are exactly the figures the deleted Python
> produced … -/
> example : True := trivial   -- #eval selfRepairReport (primePowersUpTo 32) = (262143, 0, 16, 0)
> ```
> **PROSE** (`notes/WALK_SENSOR_THEOREM.md` §10, migration table, row 4)
> "| self-repair over 262,143 families | Python loop | `by decide` at pool `≤ 8`;
> **`#eval` at pool `≤ 32`**, same four numbers |"

There is no `#eval` in the file. The `#eval` is inside a comment, and the
declaration that carries the docstring asserts `True`. So at pool `≤ 32`
nothing is proved (correctly claimed), nothing is *computed* (incorrectly
claimed), and the four numbers `(262143, 0, 16, 0)` are a recorded result of a
program that no longer exists in the repository, reported in the present tense
by a file that does not run it. `lake build` on this module produces no
evidence for them whatsoever.

The note's §10 is otherwise a model of the distinction it is drawing, and its
closing paragraph says the right thing ("still `#eval`, i.e. compiled code,
i.e. a falsifier. Theorem D remains unproved"). The defect is confined to the
table row and the docstring's present tense. **Repaired** by a dated correction
under the table in `notes/WALK_SENSOR_THEOREM.md`; the Lean file is another
agent's and I have left the term untouched, since removing the comment or
re-enabling the `#eval` is a lane decision, not an audit action.

By contrast the same file's `L ≤ 120` claim is exact, and I checked the
off-by-one that the phrasing invites: `(List.range 120).all (fun i => … (i+1) …)`
ranges over `i = 0…119`, i.e. `L = 1…120`, and the docstring says "on every
`L ≤ 120`". Correct.

### D2 — `SEED82_VACATED_NUMBER.md` §5. Its `native_decide` finding is now false of the tree.

> **PROSE** (`notes/SEED82_VACATED_NUMBER.md`:161–168)
> "Green builds are not uniformly kernel proofs here: `AdaptiveObservableHorizon.lean`
> uses `native_decide` five times and `AdaptiveUniformBound.lean` once. So the
> strict control R0049 (`1 < 2`) — obligation 4 of the packet — **rests on
> `Lean.ofReduceBool`**, the compiler-trusting oracle, not on the kernel alone.
> Two of those uses are gratuitous: `adaptiveTree_depth : adaptiveTree.depth = 2`
> is `rfl` …"

> **LEAN** (today) — `grep -c native_decide` gives **0** for both files.
> `adaptiveTree_depth` is at `AdaptiveObservableHorizon.lean`:95–96, proved
> `by decide`, and `uniform_horizon_eq_one` likewise.

The audit was right when written and was independently re-verified in its own
appendix by SEED-117 ("counts re-verified exactly: `native_decide` occurs 5× …
1× … **Repair 5 unapplied**"). It has since been applied wholesale by
`NATIVE_DECIDE_AUDIT`. A reader arriving at §5 today is told that a live claim
rests on an oracle when it does not. **Repaired** by a dated addition at §5.

Note that §5's *other* finding survives untouched and is the one this sweep
independently reproduces: "both strict-control statements in
`AdaptiveUniformBound.lean` are anonymous `example`s: obligation 4 is
discharged by terms nothing downstream can cite." Still true — see §5 below.

### D3 — `NATIVE_DECIDE_AUDIT.md` §4/§7. The residue and the site count have both moved.

> **PROSE** (`notes/NATIVE_DECIDE_AUDIT.md` §4) "**The honest residue: 16
> sites, 8 theorems, 5 modules**", amended in §4a to "Residue after this: 10
> sites, 2 theorems".

> **LEAN** (today) `native_decide` occurs as a *tactic* at exactly one site in
> the tree: `ChartQuotient.lean`:238, the §4c timeout `example`. The other four
> files matching the string do so in prose: `RankOneWitness.lean`:12 and
> `WalkFalsifier.lean`:21 disclaim it, `EuclidDoublingForkMinimal.lean`:110
> says "Kernel `decide`, not `native_decide`", and `DiagonalSmithRoute.lean`:2
> records "`native_decide` now use `decide +kernel`".

So §4b (`DiagonalSmithRoute`, 5 sites, 2 theorems) was closed by `decide
+kernel`, and §4d (`EuclidDoublingForkMinimal`, 4 sites) was closed once the
module built — the latter exactly as `notes/AXIOM_GATE.md`:82–87 claims, which
I verified by reading the file rather than trusting the message. **Repaired**
by a dated addition to §7 carrying both the new residue and the 313/200/93
count decomposition of §1 above.

---

## 5. The finding the four failure modes did not predict: 69 anonymous `example`s

Of the 200 declarations carrying a `decide` tactic, **69 are `example`s**, and
in **21 modules the `decide` tactic occurs in no named declaration at all**:

```
AdaptiveUniformBound  BehavioralBFS  ChartQuotient  ChartStateBFS
ComputableSmith2x2  ComputableSmith2x2Adapter  FiniteCoYonedaWeave
FrontierOptimality  GlobalObservableHorizon  LeastNonDivisor
NativeReversePairTraversal  ParityRigidity  RankOneSmith2x2  ReachableChart
ShortestReach  SmithCertificate  SmithPresentation  VisitedPair
VisitedPairHorizon  VisitedReach  WalkFalsifier
```

This is not a fidelity defect — an `example` that kernel-checks is as true as a
theorem that does. It is a *citability* defect, and it interacts badly with two
things this corpus has decided to do:

1. **The proposed axiom gate** (`NATIVE_DECIDE_AUDIT` §5, item 2) walks
   `env.constants` and calls `collectAxioms` on named declarations. An
   `example` emits no reachable name. Whatever an example rests on, the gate
   cannot see, and the `ChartQuotient.lean`:238 `native_decide` residue is
   itself an `example` — i.e. the one surviving oracle use in the lane is in
   precisely the position the gate is blind to. That is worth knowing before
   the gate is built, not after.
2. **Prose citation.** `SEED82_VACATED_NUMBER` §5 already flagged this for
   `AdaptiveUniformBound` ("obligation 4 is discharged by terms nothing
   downstream can cite"). The same shape recurs 20 more times. Whether it
   matters depends on whether the note citing the module claims a *result* or a
   *check*; I found no case in Stage B where prose cites an example as a named
   theorem, but I did not audit all 69, and the WalkFalsifier docstring at D1 is
   the demonstration that the failure is live in this stratum.

Recommendation, not imposed: naming an `example` costs one identifier and is
the cheapest thing on any list in this lane. It is a judgement for the lane
owner whether the 69 are worth naming or whether some are deliberately
throwaway.

---

## 6. Scope limits

- **I ran nothing.** No `lake build`, no `#print axioms`, no `lake env lean`.
  Every verdict is source against source. In particular I do **not** claim the
  93 theorems typecheck today; `LEAN_LANE_AUDIT` owns build status and lists
  modules broken at HEAD, some of which appear in my 41 (notably
  `HeadDepthBlindnessAdapter`).
- **Stage B is 27 of 93 by rule (31 including the four opportunistic reads).**
  The rule is in §2 and is mechanical; the 66
  unexamined theorems have had their statements read (Stage A) but not their
  prose neighbourhoods. A prose sentence that misdescribes a theorem without
  naming it, in a note that also does not name its module, is invisible to
  both criteria.
- **Attribution is syntactic**, and therefore is a site count, not a dependency
  count — `NATIVE_DECIDE_AUDIT` §1's taint lesson applies and I have not
  repeated its environment scan.
- **`decide +kernel` is counted as `decide`** throughout. It is a kernel proof
  and belongs in this population; readers of §4/D3 should not subtract it.
- The 69 `example`s were enumerated but not individually read; §5's claim is
  about their form, not their content.
- I did not audit the Agda lane. `formal/cubical/` has its own sweeps.
