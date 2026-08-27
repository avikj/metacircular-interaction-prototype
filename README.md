# The Interactive Symbolic Computer

*A universal machine that keeps what computation forgets.*

Dedicated to empathic intelligence & in memory of Vladimir Voevodsky. Standing on the shoulders of Carlo Rovelli, Stephen Wolfram, and many others.

**A local-first interaction calculus & computational prototype in which partial
knowledge, certified transport, and compositional interaction are properties of
the same primitive — for decentralized organisms & algorithms.**

The primitive is one Σ-type: the graph of a map, $\Gamma f = \sum_a \sum_b (f\,a \equiv b)$,
read from either end.

- Read from the **source**, the fibre is contractible: a state may carry its
  observables and their witnesses at zero cost — *certified transport*.
- Read from the **target**, the fibre is contractible exactly when nothing was
  lost: non-contractibility is a named, priced residue — *partial knowledge*.
- Interactions **compose** by concatenating traces, and the trace algebra is
  where compositionality lives — the output alone provably cannot carry it.

One theorem organizes everything here: **the output of a computation is the
propositional truncation of its execution.** Cost, route, branching, provenance,
authority, conflict, and opacity are the fibre of that truncation — and no
function of the output, into any type at any universe level, recovers them.
This machine is engineered, from the wire grammar to the proof kernel, to keep
the fibre instead.

Because unsoundness is unrepresentable and meaning is a proposition, replicas
merge by concatenation and consensus on meaning is vacuous — the model is
local-first by theorem, not by protocol. The same theorem, read into domains:
merge without consensus (replicated data), capabilities without a manager
(security), proof logging that must be online (solvers), extraction vs. phase
ordering as one quotient (compilers), branching structure as a fibre
(concurrency), opacity as a fibre (phonology), a hardness claim as one named
non-contractible fibre (cryptography). See `abstracts/` — twenty-four
instantiations of the one theorem.

What the machine *is*, in one sentence each way:

- **Coalgebraically**: a final coalgebra whose identity is bisimulation — an
  individual that persists exactly insofar as it keeps behaving as itself,
  conserving its datum at every step and rewriting its own operations.
- **Proof-theoretically**: a metacircular computational model with total
  internal reflection — everything it does reifies as an object it can act on,
  self-reflection is provably conservative, and strictly new power enters only
  through a reflection principle.
- **Classically**: its set-truncation is the ordinary universal Turing machine.
  Forget the fibres and Turing's machine is what remains.

---

Machine-checked in cubical Agda, `--safe`, no postulates, no admitted goals.
Nothing here asks to be believed:

```
sh setup      # installs the pinned toolchain (Agda 2.8.0, agda/cubical v0.9), from nothing
sh check      # typechecks, and names the toolchain it used
```

Everything below expands the masthead and states no claim it does not source.
Each section names the one theorem it is a face of; if a section reads as a new
idea rather than a return to the same Σ-type, it is written badly.

---

## The primitive, in full

A computational object is a partially known local state together with the
computable paths along which it may change while preserving what is already
valid — a continuant $X = (\text{identity}, \text{invariants}, \text{modes})$
whose mode may turn while its identity persists. The relation between two
representations is not syntactic equality $x \equiv y$ but a path $p : x = y$
whose content *is* the transformation. This is only computational because in
cubical Agda `ua`'s β-rule reduces: an equivalence $e : A \simeq B$ is not a
fact one cites but a channel that acts, $\mathsf{transport}(\mathsf{ua}\,e) : A \to B$,
carrying any theorem across on the nose, for free, in both directions. The proof
*is* the transport.

Every transition is therefore recorded as its graph. For $f : A \to B$,

$$\Gamma f \;=\; \sum_{b:B} \operatorname{fib}_f(b) \;\simeq\; A,$$

and the two ways to bind $f\,a \equiv b$ are the whole accounting of loss
(`fibre/src/Fibre/Carrier.agda`):

- **Bind the output.** $\operatorname{fib}$ over $a$ is $\mathsf{singl}(f\,a)$,
  contractible. The carried value and its witness add zero degrees of freedom,
  so the graph $a \mapsto (f\,a,\, a,\, \mathsf{refl})$ retains the input at no
  cost. This is *certified transport*, and it is lossless because the fibre is a
  point.
- **Bind the input.** $\operatorname{fib}_f(b)$ is contractible **exactly when
  $f$ is an equivalence**. Where $f$ merges histories it is not, and its size is
  the exact information the merge destroys. This is *partial knowledge*: a named,
  priced residue rather than a silent loss.

The object the machine stores is not the output $b$ but the trace $\tau$: the
path history $a \xrightarrow{p_1} x_1 \xrightarrow{p_2} \cdots \xrightarrow{p_n} b$.
A trace is simultaneously an execution (constructing it performs the
transformation), a program (it specifies one), a proof (its type constrains what
can inhabit it), a transport (it carries a value between representations), and a
provenance record — not five objects but five interfaces onto one. The unit of
accumulated value is this trace, never a scalar:

$$\boxed{\text{weights} \Rightarrow \text{traces}}$$

A scalar $s$ is a projection $\pi : \mathrm{Trace} \to S$; the reverse map does
not exist, which is not a slogan here but the theorem below.

---

## The one theorem

Let a *route* be a derivation and its *output* be its meaning,
$\mathsf{soundness} : \mathrm{Route}\,a\,b \to \big((\rho : \mathrm{Env}) \to \mathsf{eval}\,a\,\rho \equiv \mathsf{eval}\,b\,\rho\big)$.
The codomain is an identity type in a **set**, hence a proposition. A map into a
proposition has every fibre equivalent to its whole domain, so

$$\operatorname{fib}_{\mathsf{soundness}}(m) \;\simeq\; \mathrm{Route}\,a\,b
\quad\text{for every output } m.$$

**The route type is one fibre of its own soundness**
(`Kernel/TheWholeDerivationTypeIsOneFibreSoSoundnessIsNeverAnEquivalence.agda`),
and soundness is therefore *not* an equivalence — witnessed by two routes with
equal endpoints and unequal length
(`Kernel/TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainder.agda`). This is
the masthead's theorem: **the output is the propositional truncation of the
execution.** Its consequences are checked and quantified over all target types
at all universe levels:

- No function of the output selects a route.
- Length does not factor through the truncation — cost is not a function of the
  output even in principle.
- The route must be recorded **online**, at the step; afterward it is nowhere in
  the system to be recovered (abstract 06).

The dual half prices it (abstract 24). A structure that carries an
additive-under-composition grading to $\mathbb{N}$ admits no inverse; a
nontrivial group is not graded. Univalence makes equivalent types equal, so an
invariant of types-up-to-equivalence is a function on the groupoid of
transports — a nontrivial group — and admits no grading. Hence **cost, route,
provenance, and derivation length are not univalent invariants: there is nowhere
in the target for them to live.** An interface that answers with a transport
answers with something proved costless, therefore historyless; an interface that
means to carry route or cost must carry the derivation. The output is cheap and
historyless; the route is the irreducible object. **The route is the value.**

---

## The calculus

`Kernel/RewriteCertificate.agda`, `ControlledGrammar.agda`, `GenerativeKernel.agda`
— 296 lines, three files, realizing the theorem concretely.

**Terms** are a closed inductive type with six independent registers, `zero`,
`suc`, `add`; no binder, no context, no α-equivalence — nothing to capture — and
the registers held distinct so a provable equation is not silently about the
diagonal. **Steps** include `reverse` *as a constructor*, so routes form a
**groupoid**, not a reduction order: no normal form, no termination measure, no
critical pair, no completion — not open questions here but absent ones.

Concatenation is associative and unital *on the nose*, as data, so terms and
routes form a **strict category**; inversion is derived and double-inversion is a
syntactically distinct term, so the groupoid is only **weak**. That one
asymmetry is where all the cost lives, and it is localized exactly: path
inversion is definitionally involutive in the interpreting theory, syntactic
`reverse` is not, so the entire interpretation-inaccessible content is one
order-two redundancy. `eval`'s addition recurses on the right while the
metatheory's recurses on the left, so each soundness case discharges to a real
equality, not `refl` — the calculus is a theory of the domain, not a mirror of
the evaluator. The minimal witness of the theorem ships with it: a direct route
and a detour that steps, reverses that step, and proceeds, endpoints equal *by
reduction*, so no context separates them.

Acquired rules come in two dual forms, and the duality is
generality-versus-transmissibility made exact. The **memorising** form lives one
universe up, carries its route as a field, has an *open* applicability family
constrained only to project onto an identification with its single source, and
fires at exactly one term — which is what makes it **unforgeable**. The
**generalising** form lives one universe down, carries only an outcome family —
the image of soundness, a map into a subsingleton — and fires everywhere, for
free. So **a rule is general exactly to the extent its route has been truncated
away**, and the universe level is the ledger. Frontier expansion (`advance`)
maps over branches with no dedup, sort, or quotient; the only invariant is
**multiplicity** (`advance-preserves-branch-count`) — the stronger law would
decide two same-endpoint routes coincide, the judgement the theorem forbids —
and it is the one place the collapsed information is still held.

---

## The kernel is metacircular

One line closes the loop:

```
install : Derivation lhs rhs → NativeOperation
```

A route the machine has proved becomes an operation it can apply. A whole
session is one derivation, hence one theorem (`session-sound`), hence one
installable operation (`retire`): $\mathsf{learn} = \mathsf{install} \circ
\mathsf{CheckedFuture.derivation}$. **No session can install a falsehood**,
because `NativeOperation` is unconstructible without a checked route — the
trusted boundary is a *constructor*, not a checker, and there is no second
language to keep in sync. This is *total internal reflection* precisely: the
self-description never refracts out to an external metatheory; all of it
reflects back inside. The reflection is provably **conservative** — widening the
language (`Kernel/RewriteCertificateMul.agda`) is a mirror-plus-embedding proved
meaning-preserving, so no epoch change unsays an installed operation — and
strictly new power enters only through the reflection principle: `induction-sound`
is proved strictly stronger than the plain rewrite closure (`Kernel/Naya_…`).

---

## The individual is coinductive

`fibre/src/Fibre/Orbit.agda`. The trajectory of an endomorphism is a
`coinductive record` — the **final coalgebra** of $X \mapsto A \times X$, an
**M-type** (dually to a `W`-type). The interactive runtime is the same kind of
object at full generality, a coalgebra for a dependent polynomial functor,

$$\mathsf{ISC}(s) \;\simeq\; \prod_{q:Q(s)} \sum_{s'} \sum_{o} E(s,q,s',o) \times {\triangleright}\,\mathsf{ISC}(s'),$$

the ${\triangleright}$ being the `--safe` way to take that final coalgebra
without sized types, and the $\prod_{q:Q(s)}$ being the interaction point — who
chooses $q$ is the caller, not the machine. The signature fact, proved not
asserted:

$$(x \equiv y) \;\simeq\; (x \approx y)$$

**identity of individuals is bisimulation.** Persistence-through-transformation
is a theorem: two individuals are equal iff they keep behaving as themselves,
observed step by step, forever. `JivitaSmrti.agda` proves the conserved datum is
recomputed live at every rung — the losslessness of the source-binding carried
through the whole infinite orbit. The finite kernel is the inductive truncation
of this coalgebra; the individual is a point of it.

---

## Classical computation is the set-truncation

Forgetting the route is 0-truncation: collapse the groupoid to its
value-identifications and the fibre of the theorem is discarded. What remains is
ordinary computation — the trace-forgetting projection, $\pi_1$ of the graph.
Forget the fibres and Turing's machine is what remains.

To make the object language itself *universal* — so the truncation is not merely
ordinary computation but the universal machine mechanically — is to add an
encoded universal step $\mathsf{uStep} : \mathrm{Code} \times \mathrm{Conf} \to
\mathrm{Code} \times \mathrm{Conf}$ over a Turing-complete term language, with a
faithful simulation theorem and divergence carried coinductively (the coalgebra
above). That is the identified frontier, not a rumour dressed as a result: the
present term language (`eval` total, first-order) is deliberately sub-Turing, and
the encoded step is stated as open in the kernel's own descent file.

---

## The faces — one theorem, many vocabularies

None of these is a separate mechanism. Each is the graph Σ-type read in a
domain's language.

- **Local-first partial knowledge.** Validity of a transition lands in a
  subsingleton, so two replicas cannot hold different opinions about what a
  transition means — the type has room for one. Consensus is *vacuous*, not
  achieved; the model is local-first by theorem, not by protocol (abstract 02).
- **Certified transport, unforgeable.** A capability carries the route that
  licenses it, and its type admits no inhabitant without one. An unauthorized
  value is not rejected — it does not exist, for the reason an integer that is
  not an integer does not. Merge needs no validation and survives an adversary
  with full control of the channel (abstracts 02, 05, 09, 20).
- **Decentralized decision.** No observable selects among routes, so selection is
  extra-semantic *by theorem* — the system is structurally unable to take the
  choice from the party it is talking to (abstract 12). Decentralization is the
  non-existence of a semantic selector, not a deployment topology.
- **Conservative flow.** The invertible meaning-preserving flows are the symmetry
  group, exhausting $\mathrm{Aut}$ at total loss (`…SamraksakaSamuha…`); nothing
  valid is silently destroyed. The price is exact, not tuned: nothing may be
  deduplicated (dedup decides a route-identity the theorem forbids), so the store
  is monotone — no tombstones, no compaction, no safe pruning — and a pruning
  heuristic collapses an unbounded fibre (abstracts 02, 06, 09, 20).
- **Compositional interaction.** Merge is concatenation: total, idempotent,
  order-independent, a grow-only join-semilattice with nothing to validate.
  Independent interactions are the commuting cells of the groupoid; conflicting
  ones stay explicit — a fork is two carriers of one fact, not a conflict
  awaiting resolution (abstracts 02, 14).

The one irreversible step in the whole system is **execution**, which discards
the operation and its applicability witness while retaining outcome and route.
The system learns from what a step did, never from why it was permitted.

Each abstract under `abstracts/` is the theorem in one field:

| # | Domain | The theorem, locally | Forbids |
|---|---|---|---|
| 01 | Quantum / TQC | invertibility ≠ braid action | certified gates certifying exchange statistics |
| 02 | Distributed systems | validity is a subsingleton | the consensus stack |
| 03 | Learned skills | generalise vs transmit split by one field | a skill both general and shareable |
| 04 | Term rewriting | proof production ⇏ from closure | recovering proofs from an e-graph |
| 05 | Cryptography | hardness = one non-contractible fibre | pricing the assumption by evaluation |
| 06 | Query / audit | answer ⇏ derivation | reconstructing lineage after the fact |
| 07 | Concurrency | branching structure is the fibre | a scheduler that merges |
| 08 | Proof theory | proof identity is the fibre | a normalisation criterion |
| 09 | Capabilities / OS | the unauthorised value does not exist | a manager and a revocation list |
| 10 | Compilers | phase-ordering = extraction, one quotient | removing both |
| 11 | Information flow | high input open, action constant in it | a flow being writable |
| 12 | Reward / preference | no functional of outcome ranks a route | taking the choice from the agent |
| 13 | HoTT | strict category, weak groupoid | a functional out of the truncation |
| 14 | Version control | conflict = a state off the image | conflict as a patch relation |
| 15 | Automata | Nerode congruence = divisibility by lcm | seeing one's own lcm |
| 16 | Synthesis | spec ⇏ program | a semantic ranking within a fibre |
| 17 | Gauge / observability | holonomy = successor; invisible ⇔ invariant | representing a symmetry one is invariant under |
| 18 | Identifiability | non-identifiability is a fibre | two lossy readings composing to lossy |
| 19 | Phonology | opacity is the fibre | surface-only evaluation stating it |
| 20 | Stream processing | redelivery harmless by algebra | the deduplication store |
| 21 | Combinatorics | count = decategorification; excess is a group action | recovering the bijection from the count |
| 22 | Denotational semantics | full abstraction = denotation is the truncation | an extensional model retaining the play |
| 23 | SMT / proof logging | a core ⇏ from unsat | reconstructing proofs offline |
| 24 | Reversible computing | cost and inverse cannot coexist | a cost measure on a reversible model |

Every abstract ends with *what is not claimed*: the reading as a version-control
system, a synthesiser, a physical theory is a reading and is not proved. The
checked object is a term calculus, a fibre law, a coalgebra; the domain is the
vocabulary.

---

## The ontology it computes

The correspondence to the Jaina ontology of persistence-through-transformation
is the mathematics read in the vocabulary it was translated from — each term a
face of the one theorem, not a new claim.

- **dravya / paryāya** (continuant / mode) — the coinductive carrier: identity
  preserved while the mode turns, equality being bisimulation. Persistence is the
  theorem.
- **ahiṃsā** (non-harm) — conservation: a transformation does not silently
  destroy a distinction needed to reconstruct the prior state; it preserves it,
  or carries an explicit account of what it relinquished. This is the discipline
  behind *carry the derivation*.
- **anekānta / naya / syāt** (many-sidedness / standpoint / indexed assertion) —
  the faces above: many valid readings of one object, none promoted to the whole
  ($\pi_i(X) \neq X$), each assertion indexed by the standpoint that produced it,
  which is exactly a route carried with its witness rather than an output
  stripped of one.

Conservation of *structure* (ahiṃsā on the data — conservative flow) and
conservation of *agency* (no observable takes the decision — decentralized
decision) are one invariant read on two objects.

---

## What is not claimed, and how it is checked

- Every module cited is `--safe` cubical Agda, no postulates, no admitted goals,
  at the pin (Agda 2.8.0, agda/cubical v0.9). `sh check` names the toolchain it
  used; a module outside a root's import closure is built by no command, so "it
  is green" about such a module is a claim about one shell.
- The **universal machine** is the set-truncation architecturally; making the
  object language itself universal (an encoded step and a simulation theorem) is
  the identified frontier, not the present checked core.
- The **domain readings** are readings. The checked objects are the calculus, the
  fibre law, the coalgebra, and the theorems stated; their bearing on any
  deployed system is asserted only where a module asserts it.
- No thermodynamics, no probability, no Hilbert spaces, no MDP: cost is a natural
  number, and where the corpus names heat, reward, or measurement it marks the
  identification as a reading.

The spine is one theorem: the output is the truncation of the execution, so the
route is carried and conserved. Everything above is that, turned in the light.
