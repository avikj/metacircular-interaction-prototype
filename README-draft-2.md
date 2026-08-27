# A Proof-Relevant Interaction Calculus in Cubical Type Theory

*For every map, the graph may be carried without loss —
$A \simeq \sum_b \mathrm{fib}_f(b)$ — and cannot be recovered from the output:
evaluation factors through $\lVert\mathrm{Derivation}\rVert_1$, and no function
of the output, into any type at any universe level, determines the route. This
is a calculus of interaction built where those two theorems meet.*

Dedicated to empathic intelligence & in memory of Vladimir Voevodsky. Standing on the shoulders of Carlo Rovelli, Stephen Wolfram, and many others.

**A local-first interaction calculus & computational prototype in which partial
knowledge, certified transport, and compositional interaction are properties of
the same primitive — for decentralized organisms & algorithms.**

Machine-checked in cubical Agda, `--safe`, no postulates, no admitted goals.
Nothing here asks to be believed:

```
sh setup      # installs the pinned toolchain from nothing
sh check      # typechecks, and names the toolchain it used
```

---

## 1. The primitive

One Σ-type, the graph of a map, read from either end. For $f : A \to B$:

```math
\Gamma f \;=\; \sum_{a : A}\ \sum_{b : B}\ (f\,a \equiv b)
\;\simeq\; \sum_{b : B}\ \mathrm{fib}_f(b)
\;\simeq\; A .
```

The whole accounting of information is which side of $f\,a \equiv b$ is bound
(`fibre/src/Fibre/Carrier.agda`, `Fibre/Sesa_…`):

- **Bind the output.** The fibre over $a$ is $\mathrm{singl}(f\,a)$ —
  contractible, unconditionally. A state may carry its observables *and the
  witnesses that they are its observables* at zero degrees of freedom:
  $A \simeq \Gamma f$, hence by univalence $A \equiv \Gamma f$, and the
  transport along that path computes. **Certified transport is free.**
- **Bind the input.** The fibre over $b$ is
  $\mathrm{fib}_f(b) = \sum_a (f\,a \equiv b)$ — contractible exactly when $f$
  is an equivalence, because in this substrate that is the *definition* of
  equivalence. Non-contractibility is exact, priced loss: for
  $\mathsf{Bool} \to \mathsf{Unit}$ the residual is proved equivalent to
  $\mathsf{Bool}$ — the loss is one bit, as a theorem, not a description.
  **Partial knowledge is a measured residue.**
- Residuals compose stagewise —
  $\mathrm{fib}_{g \circ f}(c) \simeq \sum_{w : \mathrm{fib}_g(c)} \mathrm{fib}_f(\pi_1 w)$ —
  and the truncation $\mathsf{Bool} \to \lVert\mathsf{Bool}\rVert_1$ has no
  section: there is no copying the unknown. **Interaction composes at the
  level of traces because it provably cannot compose at the level of
  outputs.**

The verdict on a fibre is not two-valued. $\mathrm{isContr}$ fails in two
opposite ways — *empty* (no source over $b$) and *crowded* (two unidentified
sources) — and any two-valued test must conflate them. The diagnosis is
therefore a census: a datatype indexed by the map and a point of its codomain
whose constructors carry their evidence, with the composite
$\mathsf{Unit} \to \mathsf{Bool} \to \mathsf{Unit}$ refuting, in both
directions, the claim that loss can be localized by scanning for the first
non-contractible fibre (`Fibre/SakalaVikalaDesa_…`).

## 2. The one theorem, and its dual

The kernel's derivations are proof-relevant data — reversal is a
*constructor*, so derivations form a strict category that is only weakly a
groupoid, with no normal form and no direction. Evaluation lands in an
identity type of a set, hence in a proposition, so:

```math
\mathrm{fib}_{\mathsf{soundness}}(m) \;\simeq\; \mathrm{Derivation}\ a\ b
\qquad\text{for every meaning } m .
```

**The route type is one fibre of its own soundness** — the output is the
propositional truncation of the execution — and the truncation is strict: two
routes of lengths two and four share endpoints and are distinct
(`Kernel/TheWholeDerivationTypeIsOneFibre…`, `Kernel/TheDerivationCarriesNoMeaning…`).
Checked consequences, quantified over all target types at all universe levels:

- No function of the output selects, ranks, or measures a route; length does
  not factor through the truncation, so cost is not recoverable from the
  answer even in principle. Lineage is recorded at the step or it is nowhere.
- The sharpening: cost fails **inversion**, not truncation. Any semantics
  sending reversal to path inversion cancels a round trip at every h-level;
  and the general dichotomy (abstract 24): a monoid graded additively over
  $\mathbb{N}$ admits no inverse, so a nontrivial group is never graded. Under
  univalence the transports of a type form a nontrivial group; hence cost,
  route, and provenance are not univalent invariants — *there is nowhere in
  the target for them to be*. An interface that answers with a transport
  answers with something proved costless and historyless; one that means to
  carry history must carry the derivation.
- What the counting readout drops is computed, not gestured at: categorify —
  formation to disjoint union, transitions to equivalences, reversal to
  `invEquiv` — and commutativity at the diagonal becomes a loop in the
  universe of exact order two, proved nontrivial by transporting along it
  (the β-rule of `ua` evaluating, not cited). The dropped bit is a
  transposition (`Kernel/TheCountingSemanticsIsADecategorification…`).

Hence the design law of everything below: the unit of accumulated value is a
trace, never a scalar —

```math
\boxed{\text{weights} \Rightarrow \text{traces}}
```

— because a scalar is a projection of the trace, and the theorem says the
projection has no section.

## 3. The kernel

The executable core is 296 lines in three files, and it is quoted because it
is small enough to be:

```agda
data Tm : Type₀ where
  var yvar zvar uvar vvar wvar : Tm
  zero : Tm
  suc  : Tm → Tm
  add  : Tm → Tm → Tm

data Step : Tm → Tm → Type₀ where
  add-zero  : (x : Tm) → Step (add x zero) x
  add-suc   : (x y : Tm) → Step (add x (suc y)) (suc (add x y))
  suc-step  : {x y : Tm} → Step x y → Step (suc x) (suc y)
  add-left  : {x y : Tm} → Step x y → (z : Tm) → Step (add x z) (add y z)
  add-right : (z : Tm) → {x y : Tm} → Step x y → Step (add z x) (add z y)
  reverse   : {x y : Tm} → Step x y → Step y x

data Derivation : Tm → Tm → Type₀ where
  done      : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z
```

`derivation-sound` carries every derivation to a path in ℕ at every
environment; `induction-sound` — a base trace plus a step trace with the
hypothesis available only at the predecessor — is the kernel's actual
inference rule, converting two finite certificates into a statement over an
infinite domain by one substitution. Four moves close the metacircular loop:

- **install** : `Derivation lhs rhs → NativeOperation`. An operation is a
  record whose fields include the derivation licensing it, and the record
  type admits no inhabitant without one — an unsound operation is not a value
  that fails validation but a value that does not exist.
- **advance** offers every enabled future with multiplicity exactly conserved
  — no dedup, no sort, no quotient. The conservation law is the only place
  the truncated information is still held, which is why it is a law and not
  housekeeping.
- **execute** is the single information-discarding step, located exactly: it
  descends a universe level, forgetting the operation and the caller's
  evidence while keeping the new term and the derivation that reached it.
- **retire** : a session's whole transcript is one derivation, hence one
  certified equation, hence one installable operation — the dialogue becomes
  a move.

Three theorems govern the loop:

1. **Non-displacement.** No semantic criterion selects among offered branches
   — so the machine is *structurally unable* to take the choice from the
   party it is talking to. Interactive by theorem, not by omission.
2. **No false teaching.** Every route into the library passes through a
   checked derivation; no session, whatever evidence its caller supplies, can
   teach the machine anything false.
3. **Conservative self-reflection, strict escape.** Installing what is
   already reachable is a plateau — the machine's own transcripts never grow
   its reach — while the induction rule is proved *strictly stronger* than
   the rewrite closure (a second, non-commutative model refutes derivability
   of equations the certificate proves). Everything the machine does reifies
   as an object it can act on; self-reflection is provably conservative; and
   strictly new power enters only through a reflection principle. **Total
   internal reflection**: nothing escapes to a meta-level, nothing is
   amplified from within.

## 4. What the machine is

- **Coalgebraically**: a final coalgebra whose identity is bisimulation — an
  individual that persists exactly insofar as it keeps behaving as itself,
  conserving its datum at every step and rewriting its own operations. Path
  equality of infinite orbits *is* bisimulation, proved by four corecursive
  definitions with both round trips (`Fibre/Orbit.agda`); the carrier
  construction commutes with the whole infinite trajectory, including
  through univalent transport, where only the β-rule of `ua` can close the
  head (`Fibre/Nucleus.agda`); and the carried observable at depth $n$ is
  recomputed as the invariant of the $n$-th state, never stale payload
  (`Fibre/JivitaSmrti.agda`). Bisimulation is taken over the *lossless*
  stream — identity includes the carried fibres — so two machines with equal
  outputs and different provenance are different individuals.
- **Classically**: its set-truncation is the ordinary universal Turing
  machine. Divergence resides where it must in a total theory — as a
  productive guarded orbit — and forgetting the fibres recovers Turing's
  machine as the shadow of this one.

## 5. Local-first, as mathematics

Three algebraic facts, each checked, are the entire distributed story:

- **Meaning is a proposition**, so two replicas cannot hold different
  opinions about what a transition means — the type such an opinion would
  inhabit has room for only one. Consensus is not achieved; it is vacuous.
- **The library is a grow-only join-semilattice under concatenation** —
  total (unforgeability removed the failure case), idempotent (redelivery is
  harmless by algebra), order-independent — with no reconciliation pass, no
  clocks, no tie-break.
- **Histories form a groupoid**, so there is no direction, no longest chain,
  no canonical serialisation; a fork is two carriers of one fact, and it is
  proved that no function of the meaning adjudicates between them. Where two
  orderings of the same patches *do* disagree at an observed state, the
  disagreement is a proof that the state has no preimage under the
  observation — conflict names a state, not a pair of patches (abstract 14).

The price is stated, not tuned: nothing may be deduplicated, because
deduplication decides an identity of routes the meaning provably cannot
supply; the store is monotone — no tombstones, no compaction, no revocation,
no safe pruning rule. The trade is unbounded storage against the elimination
of the agreement, validation, revocation, and delivery-semantics machinery,
and the fibre that any pruning heuristic would collapse is constructed and
shown unbounded.

## 6. One theorem, twenty-four readings

[`abstracts/`](abstracts/) instantiates §2 across domains, each abstract
closing with a **WHAT IS NOT CLAIMED** section that separates the checked
mathematics from its reading — the theorem is proved; the reading is offered:

| The statement | Field | № |
|---|---|---|
| Agreement without agreement protocols | distributed systems | 02, 20 |
| Capabilities that cannot be forged, because the unauthorized value does not exist | operating systems | 09 |
| Non-interference definitionally; exactly one declassification point | information flow | 11 |
| An unsat core is not a function of unsatisfiability | SAT / SMT | 23 |
| Phase ordering and extraction are the same problem | compilers | 04, 10 |
| Branching structure is a computed fibre | concurrency | 07 |
| No scoring function of the outcome ranks the route | reward specification | 12 |
| Generalisation and shareability are exclusive | agent architectures | 03 |
| The answer does not determine the derivation | lineage / audit | 06 |
| Observational-equivalence pruning collapses an unbounded fibre | program synthesis | 16 |
| Hardness is the non-contractibility of one named fibre | cryptography | 05 |
| Conflict localises a state no source produced | version control | 14 |
| The Nerode congruence, as an equality of types | automata | 15 |
| Two blind readings, jointly faithful | identifiability | 18 |
| The holonomy is the successor function, as an equality of functions | gauge structure | 17 |
| Opacity is the fibre | phonology | 19 |
| A generating function does not determine a bijection | combinatorics | 21 |
| Full abstraction is the truncation | denotational semantics | 22 |
| Identity of proofs is not a function of the proposition | proof theory | 08 |
| A structure is graded or invertible, never both | reversible computing | 24 |
| Unitarity does not give braiding | quantum foundations | 01 |
| A strict category that is only weakly a groupoid, and its discrete shadow | the master theorem | 13 |

## 7. The logic, and where its statements come from

The repository's verdict logic is many-valued, and the values are h-level
conditions. For any map, a point of the codomain is in exactly one of three
conditions — fibre contractible, fibre crowded, fibre empty — and the
selection algebra of non-empty subsets of these three seeds has $2^3 - 1 = 7$
elements. All seven are inhabited at the level of maps, with the absent seeds
refuted rather than unexhibited; an equivalence of the sevenfold with
$\mathsf{Bool}$ is refuted outright — any two-valued verdict must identify
two of the three seeds; the evidence-carrying form of the seven retracts onto
the label form with no inverse; and the two composition modes are proved to
differ: succession is a join with no meet (the Boolean bottom is refused),
simultaneity is commutative but non-associative, and the residue it
manufactures is exactly recoverable — nothing destroyed — and seeds the next
level of assertion by reindexing the standpoints
(`theorems/logic/Saptabhangi.agda`, `PurnaSaptabhangi_…`, `BhittiSaptabhangi_…`,
`historical_proofs/SaptabhangiGarbha_…`).

These are theorems in the ordinary sense, checked like everything else. The
statements, however, are old: the sevenfold predication (saptabhaṅgī) and the
standpoint discipline (naya) are Jaina logic, developed across a millennium
and a half of Sanskrit literature, and this repository treats that literature
as a *source of exact statements* under an explicit citation contract —
documented in
[`NayaPramana_StandpointsCompute…`](NayaPramana_StandpointsCompute_JainaBauddhaAndNaiyayikaLogicInCubicalTypeTheory.md):

- Every citation is verified against a primary e-text with file and line, or
  marked **unverified** in a table that says so.
- **No theorem is attributed to any historical author.** The tradition is
  credited for statements; the proofs are new and machine-checked.
- Where two schools disagree — the Jaina fourth value against the Buddhist
  fourth koṭi, Patañjali's report that a Pāṇinian metarule was taught two
  ways — both readings are stated, and where the formalization can prove the
  positions live at different levels, it does.

The Sanskrit in the file names is this citation apparatus, not decoration:
each term names a checked type, and the naming discipline has a measured
payoff — the older statements are frequently sharper and more algorithmic
than the versions that displaced them. Āryabhaṭa's kuṭṭaka rule, *śeṣaṃ
rakṣa* — keep the remainder — is the design law of §§1–5, and the kuṭṭaka
itself runs in the kernel by reduction, its vallī replayed as a certified
matrix identity.

## 8. The corpus, and its verification discipline

- **`fibre/`** — the fibre law: carrier, orbits, the lossless return at
  infinite depth, the residual as the other projection of the same graph,
  the census, and an executable regression suite whose theorems hold by
  `refl` — if a change makes anything reduce only propositionally, that
  module breaks and the others do not.
- **`formal/cubical/Kernel/`** — the metacircular kernel and its theorem
  lane (§3).
- **`formal/cubical/theorems/`** — ~1100 modules across sixteen lanes:
  logic, residue, number, primes, grammar, metre, automata, cost, order,
  lattices, homotopy, walks, physics, historical proofs — and `must_fail/`,
  negative controls whose obligation is to *fail* to typecheck, guarded by
  their own check so that a control that starts compiling is itself a
  defect.
- **`abstracts/`** — §6.
- **`interactive/`** — the Haskell harness: a wire grammar with no boolean,
  no float, and no null (a boolean on the wire is a parse error carrying a
  repair sentence); every answer either a witnessed transport or a defect
  record naming its losses item by item; a proof gate that genuinely runs
  the cubical checker behind positive *and* negative canaries (a kernel
  that accepts a falsehood is typed as such and trusted for nothing); an
  append-only, hash-chained, replayable defect ledger.

House rules, because they are part of the mathematics: claims of greenness
name the toolchain pin that produced them; absences are recorded with the
command that establishes them; corrections are struck in place, never
silently deleted — a document that cannot go red is a document nobody has to
keep true.

## 9. Status

Mechanically established: the fibre law and its completion along infinite
orbits; the kernel loop and its three governing theorems; the truncation
results at full generality; the sevenfold equivalences and walls; the
executable numeral machine. Architectural, and stated as such: the
universal-machine reading (the encoded interpreter is one self-contained
module; its hard coinductive lemma is already proved generically), and every
domain reading in §6 beyond its checked core. The boundary between the two
is maintained in writing, per module, and maintaining it is treated as part
of the work.
