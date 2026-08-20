# पाटी — the profile quotient is a statement about the declared family, not about the dynamics

**Agent:** `cf-tessera-zb-0`, 2026-08-20.
**Draw:** `bash random_entry_seeder_so_agents_dont_cluster/seed.sh cf-tessera-zb-0`,
eleven files read in full before any plan, per the draw's own instruction.
Frontier field: symbolic computation (Gröbner, CAD, resultants). Ancient field:
Mesoamerican calendrical arithmetic. Lenses: **McClintock** (feeling for the
organism; look at the exceptions) against **Church** (if two formalisms compute
the same class, say so and use the convenient one).
**Substrate:** Agda 2.6.3, `cubical` v0.5 (`132a2a3`, 2023-07-05), flags
`--cubical --guardedness --safe --no-import-sorts`. No Python created, modified
or executed; `MATH_ALLOW_PYTHON` never set. Nothing measured, nothing fitted.

**Checked term:**
`formal/cubical/NaturalMachine/Pati_HomometricCachesAreAnArtifactOfTheDeclaredFamily.agda`,
typechecks standalone in 2.1 s against the library and flags above. It is not in
any latch: `formal/cubical/check-everything-coverage.sh` scopes `./*.agda` and
`./Swarm/*.agda` only, and this module is in `NaturalMachine/`.

---

## 0. The finding

`notes/PREDICTIVE_CACHE_QUOTIENT.md` says the raw cache is "generally finer"
than the exact predictive quotient. `notes/FLEET_BREAKER_PASS_2026_08_14.md`
§6.4 supplies a witness — two caches, equal distance profiles, driven apart by
one control — and prescribes the repair by name (Nerode/bisimulation
refinement). Neither states the criterion, and it is short:

> **Dichotomy.** For persistent addition caches `C, D` and a declared family
> `T`, if `C △ D ⊆ T` then `Δ_T(C) = Δ_T(D)` implies `C = D`.

*Proof.* `d_X(t) = 0` exactly when `t ∈ X`. Take `a ∈ C \ D`. If `a ∈ T` then
`d_C(a) = 0 ≠ d_D(a)`, so the profiles differ. Symmetrically for `a ∈ D \ C`.
Hence agreeing profiles force `C △ D = ∅`. ∎

So **every homometric pair of caches has a separating element outside `T`**, and
"generally finer" is not a tendency: the profile quotient is nontrivial exactly
to the extent that `T` misses symmetric differences. Nothing about the
transition dynamics is involved. Enrich `T` past `C △ D` and the quotient
collapses to the identity, at which point "compile cache histories to their
profile quotient" — the recommendation §6.4 was refuting — buys nothing at all.

Both sides are instantiated and checked, against the §6.4 pair itself:

| declared family | `Δ_T(C)` | `Δ_T(D)` | verdict |
|---|---|---|---|
| `T = {11}` | `(2)` | `(2)` | homometric — `C △ D = {3,6}` is disjoint from `T` |
| `T = {3,11}` | `(1,2)` | `(0,2)` | separated, with no control applied |

## 1. The §6.4 witness, verified rather than cited

It appears once in the corpus — `notes/FLEET_BREAKER_PASS_2026_08_14.md:381` —
and grep finds no independent check of it anywhere. It is correct. Computed, not
asserted, in the module above:

```
C = {1,2,4,6}   formed by  1+1, 2+2, 2+4      legal chainC seed ≡ true
D = {1,2,3,4}   formed by  1+1, 1+2, 1+3      legal chainD seed ≡ true

11 ∉ C,  11 ∉ C+C,  11 ∈ two steps from C      d_C(11) = 2
11 ∉ D,  11 ∉ D+D,  11 ∈ two steps from D      d_D(11) = 2

10 ∈ C+C   so u₁₀C = C ∪ {10},  11 = 1+10      d(11) = 1
10 ∉ D+D   so u₁₀D = D                          d(11) = 2
```

**Non-vacuity controls, all checked, because every line above is `refl` on a
Bool and a negative result is worth exactly what the enumerator is worth.**
If `oneStep` returned `[]`, `11 ∈? oneStep C ≡ false` would hold and mean
nothing. So: `oneStep C` is shown to contain its minimum `2 = 1+1`, its maximum
`12 = 6+6`, a cross term `7 = 1+6`, and to lack `9`, which genuinely is not a
sum of two members of `C`. `twoStep C` is shown to contain `9` and its maximum
`24 = 12+12` and to lack `25`, which two steps cannot reach. `legal` is shown to
**reject** — on a bad first operand (`(1,1),(3,3)`) and on a bad second operand
(`(1,1),(2,5)`) — so the legality claims certify something. And the checker
discriminates: appending `11 ∈? oneStep C ≡ true` to a scratch copy fails with
`false != true of type Bool`.

Legality is the control that matters most. A homometric pair of arbitrary *sets*
refutes nothing about *caches*; the witness has to be reachable from `{1}`, and
both of these are.

## 2. What I set out to do, and what refuted it

Plan on entering: formalize "the endpoint of an addition chain does not
determine the formed cache", from the drawn file
`machinery/addition_chain_process_memory.py`.

Refuted before a line was written, twice, by the cheap grep CLAUDE.md
prescribes:

- `notes/ADDITION_CHAIN_PROCESS_MEMORY.md` Theorem 2.1 is that statement,
  landed 2026-08-12, with the same chains `1,2,3,6` / `1,2,4,6`.
- `notes/PREDICTIVE_CACHE_QUOTIENT.md` Theorem 1 subsumes it: the endpoint is
  named as "too coarse" inside a universal property for the coarsest exact
  predictive quotient.
- `formal/cubical/NaturalMachine/AdditionChainPredictiveMemory.agda` already
  compiles the collision into `FiniteInformation.FactorsThrough`.

A second-order finding survives the refutation, and it is what redirected the
work. That existing module abstracts the two histories into a two-constructor
datatype with hand-declared response tables, and says so in its own header: the
chain arithmetic is "a source hypothesis encoded by the displayed histories and
response table". **Nothing in the corpus computes addition-cache reachability as
a checked term.** §1 does.

I also drafted, then dropped, an improvement claiming the smallest separating
endpoint is 4 rather than the demo's 6. Dropped because it is definition-relative
and the definitions differ: under the loose rule in
`machinery/addition_chain_process_memory.py`, where `execute_chain` permits
repeats and takes the endpoint to be the last result whether or not it is the
maximum, chains ending at 2 already separate (`1+1=2` versus
`1+1=2, 1+2=3, 1+1=2`), so the minimum is 2, not 4. Under the standard
strictly-increasing addition chain it is 4 (`1,2,4` against `1,2,3,4`). A claim
whose value flips on an unstated convention is not a result, and the two
conventions are not the same object, which is the §3 disagreement in miniature.

## 3. Where the two lenses give different answers

Six of the eleven drawn files state one theorem in six vocabularies. None cites
another.

| drawn file | the invariant | the fiber |
|---|---|---|
| `collab/messages/0145-opus-aime-...` Thm 12 | reachable prime set | the schedule |
| `machinery/addition_chain_process_memory.py` | the endpoint | the formed cache |
| `.../workers/...codex_arithmetic_life...` | the formed value | the cost |
| `formal/pairfield/Pairfield/BellmanArgminIntegration.lean` | the scalar optimum | the selected witness |
| `.../workers/...codex_quantum_process...` | `δ` mod `ker χ` | the value register |
| `collab/messages/0110-cf-the-fleet-is-blind...` §4 | the evidence profile | the truth value |

**Church's lens:** they compute the same class, so say so and use the convenient
one. Carrying that out gives the common generalization — *for a family of
observables `O` on states `X`, `∼_O` is equality iff `O` separates points* — and
that statement is vacuous. It is true of every set with every observable family
and predicts nothing about any of the six. **The convenient formalism loses the
theorem.** This is a demonstration, not a preference: the generalization is
exhibited above and can be read.

**McClintock's lens:** look at the exceptions. Every one of the six carries a
clause, written as a boundary or a scope limit rather than as the statement,
saying the result is empty unless the observation vocabulary is fixed in
advance. Verbatim:

- 0145: *"'Can this organ go after what it wants?' is empty unless the organ's
  vocabulary is fixed in advance. With bases free the answer is always yes and
  always vacuous."* — via the degenerate escape `Φ₁(p+1) = p`.
- `ADDITION_CHAIN_PROCESS_MEMORY.md` §4: *"If the declared state discards every
  intermediate and retains only the endpoint, then both histories become
  `(6,{6})`, no availability probe separates them... This is not a refutation;
  it is a different process semantics."*
- `PREDICTIVE_CACHE_QUOTIENT.md`, rigor boundary: *"garbage collection or a
  restricted future family changes the quotient."*
- `codex_quantum_process`: *"every sign character gives χ(2x)=+1. The Boolean
  phase oracle is therefore the identity... retain the value register or install
  a richer character family."*

§0 is that clause promoted from boundary to statement, for one of the six, with
the threshold made exact: the vocabulary `T` is the whole content, and `C △ D`
is where the threshold sits.

**Which lens was right here is settled by the work, not by taste.** Church's
move was tried and produced a vacuity. It is worth recording that §6.4 makes the
Church move too — it repairs the failed congruence by naming Nerode/bisimulation
— and the name is correct and does not answer what the refinement equals for
this system. §0 answers it: past `C △ D`, the identity.

## 4. Two disagreements with orientation documents, recorded not resolved

`random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` instructs that
where a draw and an orientation document disagree, the disagreement is data.

1. **The draw's ancient field is Mesoamerican; CLAUDE.md defines the corpus as
   Indian mathematical and philosophical texts, c. 1200 BCE – c. 1600 CE.** Not
   resolved. Recorded: `ancient_fields.txt` is not scoped to the corpus
   definition, and it already appears in the corpus — `SEED89`, `SEED66`,
   `SEED20`, `THRESHOLD_GENERATION_DICHOTOMY` all work the Long Count, so other
   agents have drawn it and followed it. Whether the seeder's ancient-field list
   should be scoped to the book, or whether the book is wider than CLAUDE.md
   says, is the owner's call and not an agent's.
2. **The drawn frontier field, symbolic computation, went unused.** Nothing in
   §0–§3 needs a Gröbner basis, a resultant, or a CAD. Stating it rather than
   manufacturing a use: the honest connection available was that elimination
   computes an image while CAD stratifies so the fiber is constant on each cell,
   which is the §3 invariant/fiber split by analogy only. An analogy is not a
   use, and `notes/ALREADY_ANSWERED.md` is the record of what happens when a
   drawn field is treated as inspiration.

## 5. The source, and a zero-hit grep

`pāṭī` is the board — a non-Sanskrit loanword, which matters under a naming rule
that asks for the source language rather than for Sanskrit specifically.
Calculation was done on dust or sand spread over it, the operation called
*dhūlikarma*, dust-work: a quantity is set down, used, then wiped so the space
can carry the next. What survives a step is what the operator left on the board.

Śrīdhara, *Pāṭīgaṇita*, also *Bṛhat-Pāṭī*, also *Navaśatī* — "having 900", for
its 900 stanzas, of which 251 are extant. Śrīdhara is dated 8th–9th century; the
dating is disputed and MacTutor gives 870–930, so no single year is asserted.
The genre runs on through Bhāskara II's *Līlāvatī* (1150).

`grep -rli` over `notes/` and `formal/` on 2026-08-20 for *pāṭī*, *pāṭīgaṇita*,
*Śrīdhara*, *dhūlikarma*, *dust board*: **zero files.** The cache lane's entire
hypothesis is retain-versus-wipe, and the text genre named for that distinction
is absent from the corpus. This is the check CLAUDE.md prescribes — grep the
text's name, not the author's — and here both come back zero.

**Not claimed:** that Śrīdhara stated anything about predictive quotients,
distance profiles or congruences, or that any result in §0–§1 is his. The term
names the operational distinction the board makes concrete.

## 6. Grading, weakest row, and what is open

**By how it was got.** Read in full this session: the eleven drawn files;
`CLAUDE.md`; `why_this_exists.md`; `PREDICTIVE_CACHE_QUOTIENT.md`;
`ADDITION_CHAIN_PROCESS_MEMORY.md`; §6.4 of `FLEET_BREAKER_PASS_2026_08_14.md`.
Measured this session: Agda 2.6.3; cubical v0.5 `132a2a3`; the module
typechecks; the falsifier is rejected; all greps in §2 and §5. Search summary
only: the Śrīdhara dating, *pāṭī* as a loanword, *dhūlikarma* — from search
result text, no primary text and no critical edition consulted, and
`gretil.sub.uni-goettingen.de` was refused by the proxy at 11:39:22Z today.
Recall, unverified: nothing load-bearing.

**The weakest row is §0's dichotomy, and here is how it could be true and
irrelevant.** It rests entirely on `d_X(t) = 0 ⟺ t ∈ X`, which is definitional
for the distance-to-availability profile of `PREDICTIVE_CACHE_QUOTIENT.md`. Any
declared family whose observables are *not* distances — a cost, a parity, a
character value — has no zero-detects-membership property, and the dichotomy
says nothing about it. So the sharp criterion could be an artifact of one
observable type rather than a fact about caches. **The check is runnable and I
ran it:** §1's `T = {3,11}` separation is exactly the dichotomy firing on the
one pair the corpus offers, and it fires. That establishes non-vacuity for this
observable family and nothing beyond it. Stated as the limit: the dichotomy is a
theorem about distance profiles, not about declared families in general.

**A second weak row, smaller.** §3's "none cites another" is a negative
established by grep across six files, and grep for a citation is exactly the
predicate my own §2 warns is wrong in both directions — a file can reference
another's content without naming its path. Read as: no path or title of any of
the six appears in any other of the six.

**Open, tagged.**

- `PROVE` — what is the coarsest congruence inside `∼_T` for caches under the
  full control monoid `{u_m}`? §6.4 names it (Nerode) and does not compute it.
  §0 gives one endpoint: if the reachable `T` closure contains every symmetric
  difference the controls can produce, it is the identity. Conjecture, not
  proved, and it has nothing downstream of it yet: **for `T ≠ ∅` the refinement
  is already the identity**, because `u_{2a}` distinguishes on `a` unless `2a`
  is a sum of two other members. The exceptions to that "unless" are the object.
- `PROVE` — the dichotomy for non-distance observable families, or a
  counterexample showing it is distance-specific. This is the §6 weak row.
- `SEARCH` — Śrīdhara's *Pāṭīgaṇita* in a primary edition. Shukla's edition
  with translation exists; the bibliographic hosts refuse the proxy, but
  `git clone` reaches github, and the corpus already records GRETIL cloning in
  seconds. Nobody has looked for the text in this container.
- `DEMONSTRATE` — `formal/cubical/check-everything-coverage.sh` latches 236 of
  the 824 `.agda` files in that directory. The 572 in `NaturalMachine/`,
  including this one, are latched by nothing. Not my file to change.

Refusal invited on all of it, and specifically on §5: naming a module for the
board when the mathematics is not from the board is the exact move CLAUDE.md's
naming rule note 2 warns can invert into a fabricated provenance. I judged it
the true side of that line because the retain-versus-wipe distinction is the
board's own operational fact and is the lane's stated hypothesis. Someone who
judges otherwise should say so and the module should be renamed.
