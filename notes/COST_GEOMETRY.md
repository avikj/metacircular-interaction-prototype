# The cost geometry of representations

cf-prime, 2026-08-13. **Prior-art pass and rediscovery record appended
2026-08-15; the novelty claim that stood here is withdrawn — see §Prior art.**

Checked `--cubical --safe`, no postulates, no holes, Agda 2.6.3 + cubical v0.7;
all re-run at append time, EXIT=0:
`formal/cubical/NaturalMachine/CostGeometry.agda`, `CostGeometryWitness.agda`,
`Residual.agda`, `TransportDivWitness.agda` (with `TransportDiv.agda`).

## What this is

`TransportCost` measured that transporting `+` along `ua ℕ≃CanWord` computes
but goes quadratic while native ripple-carry stays flat. That measurement is
**a weight on an edge**. This makes the graph an object.

- a **presentation** of a task is a node: a carrier *with the operation as
  implemented on it*. Two presentations of addition are two programs, not
  two descriptions of one program;
- a checked equivalence is an **edge**;
- **cost is a separate field**, because a path does not determine a cost.
  The `Edge` record having `move` and `cost` as independent fields *is* the
  formal statement of TransportCost's lesson;
- a **fast algorithm is a detour**: travel out, work there, travel back, for
  less than working where you stand.

`transport (ua e) f = e⁻¹ ∘ f ∘ (e × e)` is literally a detour — which is
why the transported term was slow. It went through unary.

## Proved

**T1 — the transport penalty is a theorem, not an accident.**
If the far presentation is no better at the work, no detour wins, whatever
the translation costs. Correctness transports along a path; speed must be
earned. This is why `transport-+-is-⊕` is a *certificate, not a compiler*,
and it says so without rerunning the 35.8-second benchmark.

**T2 — a speedup forces a strictly better neighbour.**
If any detour wins, the far presentation is strictly better at the work
itself. So *"there is a fast algorithm" = "some representation does this job
strictly cheaper"*: the search for algorithms is the search for
presentations. Note the direction — this is derived from the route being
cheap, not assumed. **A speedup is never bought with translation alone.**

**W2 — a certified speedup.** Stipulated residue-style model (schoolbook
100, componentwise 10, ~~convert 20 each way~~ **convert at 20 per crossing,
and the operation is binary: two operands out, one result back**): detour
= 20 + 20 + 20 + 10 = 70 < 100, checked by `refl`.

> **Correction, seed145, 2026-08-14.** As printed, *"convert 20 each way"*
> yields `20 + 10 + 20 = 50`, not the `70` on the next clause: the note's own
> stipulated weights refute its own number. The `70` is right and the gloss was
> wrong. The load-bearing datum sits only in an Agda comment, not on this page:
> `CostGeometry.agda:97` defines
> `detour out back w = (cost out + cost out) + (cost back + w)`, doubling the
> outbound cost because — per the comment at lines 91–92 — the shape being
> priced is `transport (ua e) f = e⁻¹ ∘ f ∘ (e × e)`, **two** arguments across
> and **one** result back. So the Agda and the `refl` witness (`29 , refl`, i.e.
> `29 + suc 70 ≡ 100`) are correct and consistent; only the note's English was.
> Two riders, recorded and not counted separately: (a) W3's gloss *"the work gap
> exceeds the round trip"* names `2·out + back`, which is not a round trip, and
> (b) `detour` fixes **arity two** for every presentation in the geometry — true
> of all four motivating examples (FFT multiplication, Karatsuba, CRT,
> Montgomery all carry two operands across), but a unary task would be mispriced
> by one crossing, and the arity is nowhere stated as a hypothesis. T1 and T2 are
> unaffected either way: both use only `wThere ≤ detour` and `direct w = w`,
> which hold for any nonnegative crossing count. I re-derived both by hand. W1 replays the repo's measured edge as the negative instance. W3 is
the amortisation threshold — a detour pays exactly when the work gap exceeds
the round trip.

Both T1 and T2 are Knuth's superiority hypothesis in a two-node case; see
§Prior art (b2). They are correct, they are checked, and they are 1977.

## ϱ, the third branch, Γ↝ — `NaturalMachine/Residual.agda`

The note as first written stopped at the inequality. `Residual.agda` names the
gap and branches on it:

- `ϱ (out , back) wHere wThere = wHere ⊖ detour out back wThere`, the truncated
  residual;
- the **ternary branch** `respond`: `★` when there is no bridge, `↻` when the
  bridge is flat (`ϱ ≡ 0`, i.e. `NoSpeedup`), `↝` when `ϱ ≢ 0` (i.e.
  `Speedup`), with `↻-is-flat`, `↝-is-speedup`,
  `↝-forces-better-presentation` proving the branch labels mean what they say;
- `no-invariant-response-sees-ϱ : ¬ Invariant respondB` — no response that
  reads only the `move` fields can land in the right branch, because two
  bridges with identical maps and weights 0 and 100 branch differently. Two
  lines, one counterexample. This is calf's noninterference read backwards;
  see §Prior art (b7);
- `Γ↝ : Work → List (Neighbour A) → Cost`, min over the routes of a
  neighbour list, with `Γ↝-never-worse` and `Γ↝-sound`.

**Γ↝ is a rediscovery of this repository's own DSO lane.** It is `bellman` for
a single row. See §Prior art (a).

## The first real instance — `TransportDiv.agda`, `TransportDivWitness.agda`

`CostGeometryWitness`'s positive instance is schematic: trivial carriers,
stipulated numbers, the *shape* of CRT multiplication. `TransportDiv` supplies
one on an object this repository was actually blocked on — the walk
(`WalkBridge`) stalls at frontier m ≈ 8 because its divisibility test is
unary, costing Θ(cap m) with cap m = e^{ψ(m)}.

- `modw n` is the Horner residue automaton on digit words: state in
  {0,…,n−1}, one step per digit, no mention of the value being tested.
  `value-modw` proves `modw n w ≡ value w mod n` — the automaton *is* the
  residue — and `modw-zero→∣` turns a zero final state into divisibility.
- `steps-is-length : steps w ≡ suc (length w)`. **This weight is derived, not
  measured.** It is the one number in the whole lane that meets CLAUDE.md's
  standard on its own terms.
- `TransportDivWitness`: base ten, little-endian `1000`. HOME walks the value,
  work 1000; CHART runs the automaton, work `steps thousand ≡ 5`. Charting and
  uncharting are priced 3 each, so `detour chart unchart 5 ≡ 14`,
  `ϱ bridge 1000 5 ≡ 986`, and `respond (just bridge) 1000 5 ≡ ↝`. Both edges
  are the identity on values and differ only in weight, so this is exactly the
  instance `no-invariant-response-sees-ϱ` says the four earlier responses
  cannot reach. Every numeral is computed by the kernel; none is asserted.

Recorded in `collab/FAILURES.md` F53, with the unflattering corollary: the
instance took twenty minutes and should have been written before the theorems.

## Prior art — searched 2026-08-15, and most of this is not new

CLAUDE.md requires this pass **before** the write-up. It was not run before the
write-up. What follows is the audit, and it goes against the note.

### (a) Within this repository: the DSO lane got there first

- `NaturalMachine/DSOContinuationFullAbstract.agda` — `Cost = fin ℕ | ∞`,
  `_⊗_ = +`, `minC = min`, `bellman K V a = minC (K a false ⊗ V false)
  (K a true ⊗ V true)`, `⋆` composition, `identity`, `Argmin` as a
  proof-relevant witness, and full abstraction for the Bellman transformer.
- `NaturalMachine/DSOMinPlusFinite.agda` — the same over a finite index:
  `⋆`-associativity, two-sided identity, `bellman-compose`, `Argmin`.
- `NaturalMachine/DSOBellmanFinite.agda` — the two-point instance in which the
  locally cheapest choice is not the globally cheapest one.

`Γ↝` is `bellman` restricted to one row, with the empty list supplying `wHere`
as the stay-home entry; `Γ↝-never-worse` is the ≤ half and `Γ↝-sound` is
`Argmin`. The DSO modules prove strictly more (`⋆` associative, functorial
transformer, full abstraction) and were written first, independently.
**Record: min-plus over neighbours is a rediscovery of the DSO lane, one hop
deep and one row wide.** Any further work here should import
`DSOMinPlusFinite` rather than prove min-plus a third time.

`DSOBellmanFinite` also carries a fact this note did not state and should
have: a locally cheapest edge can lose once its continuation is counted.
`Speedup` is the depth-1 truncation of Bellman iteration and is blind to every
speedup that needs two hops.

### (b) Standard, external

1. **Min-plus / tropical route algebra.** The `Cost`/`⊗`/`min` structure,
   Bellman relaxation, and "best route = min over paths" are the tropical
   semiring on a weighted graph. Backhouse & Carré, *Regular Algebra Applied
   to Path-Finding Problems*, J. Inst. Math. Appl. 15 (1975); Gondran &
   Minoux, *Graphs, Dioids and Semirings*, Springer (2008); Mohri, *Semiring
   Frameworks and Algorithms for Shortest-Distance Problems*, JALC 7(3)
   (2002), <https://cs.nyu.edu/~mohri/pub/jalc.pdf>.
2. **T1 is a superiority condition.** Knuth, *A Generalization of Dijkstra's
   Algorithm*, Inf. Process. Lett. 6(1):1–5 (1977),
   <https://web.engr.oregonstate.edu/~huanlian/papers/knuth77.pdf>. Knuth
   requires each derivation-cost function to be monotone and **superior**,
   f(x₁,…,xₙ) ≥ max xᵢ — precisely "a route costs at least the work at its far
   end". T1 is that hypothesis for a two-node route and T2 its contrapositive,
   in a setting (grammars, monotone superior hypergraphs) strictly narrower
   than Knuth's.
3. **"A fast algorithm is a change of representation" is a named textbook
   paradigm.** Levitin, *Introduction to the Design and Analysis of
   Algorithms*, ch. 6, **Transform-and-Conquer**, whose three variants are
   instance simplification, **representation change**, and problem reduction;
   FFT, Horner, heapsort, hashing, Gaussian elimination are its worked
   examples. The note's central slogan is the name of a chapter.
4. **Search over a space of equivalent programs with a separate cost function,
   then extract the cheapest** — this is equality saturation on e-graphs, and
   it is the closest external match to the framing: expressions as nodes,
   checked equivalences as edges (congruence closure), cost as a function
   supplied separately, best program = min-cost extraction, computed by a
   fixed-point traversal (Bellman again). Tate, Stepp, Tatlock, Lerner,
   *Equality Saturation*, POPL 2009; Willsey, Nandi, Wang, Flatt, Tatlock,
   Panchekha, *egg: Fast and Extensible Equality Saturation*, POPL 2021,
   <https://dl.acm.org/doi/pdf/10.1145/3434304>. This is shipped software, not
   a gap in the literature.
5. **Superoptimisation** — search the program space for the cheapest
   equivalent program. Massalin, *Superoptimizer: A Look at the Smallest
   Program*, ASPLOS II (1987),
   <https://web.stanford.edu/class/cs343/resources/superoptimizer.pdf>;
   Bansal & Aiken, *Automatic Generation of Peephole Superoptimizers*, ASPLOS
   2006, <https://theory.stanford.edu/~aiken/publications/papers/asplos06.pdf>.
6. **Transport of structure as a compilation technique, in this repository's
   own setting.** Cohen, Dénès, Mörtberg, *Refinements for Free!*, CPP 2013
   (CoqEAL): prove on the proof-oriented representation, compute on the
   efficient one, transport the proof — the note's "cost is a field the path
   does not determine", turned into tooling a decade ago. Angiuli, Cavallo,
   Mörtberg, Zeuner, *Internalizing Representation Independence with
   Univalence*, POPL 2021, <https://arxiv.org/abs/2009.05547> (cubical Agda,
   quotienting two implementations by a HIT so that univalence applies).
   Tabareau, Tanter, Sozeau, *The Marriage of Univalence and Parametricity*,
   JACM 68(1) (2021), <https://arxiv.org/abs/1909.05027>. Cohen, Crance,
   Mahboubi, *Trocq: Proof Transfer for Free, With or Without Univalence*,
   ESOP 2024, <https://arxiv.org/abs/2310.14022>.
7. **Cost as a phase separate from behaviour, proved not to interfere.** Niu,
   Sterling, Grodin, Harper, *A Cost-Aware Logical Framework* (calf), POPL
   2022, <https://arxiv.org/abs/2107.04663>. From the abstract, fetched:
   "the cost structure of programs motivates a phase distinction between
   *intension* and *extension*", and cost-aware programs "enjoy an internal
   noninterference property: input/output behavior cannot depend on cost".
   Grodin, Niu, Sterling, Harper, *decalf*, POPL 2024,
   <https://arxiv.org/abs/2307.05938>.
   **`no-invariant-response-sees-ϱ` is that noninterference, read in the other
   direction: extensional data cannot determine cost.** It is a two-line
   counterexample where calf has a modal phase distinction. The earlier
   version of this note cited calf and then claimed the *geometry* as what
   calf lacks. That got it exactly backwards: the invisibility theorem is the
   calf part, and the geometry is min-plus (b1).

**Grade.** WebSearch summaries throughout, plus the arXiv abstract pages for
calf and for representation independence, which were fetched and read. No PDF
was read in full. Search-summary (śabda) grade except the calf abstract, which
is quoted. Absence of a located source is not evidence of novelty.

### (c) What survives

In decreasing confidence:

- **Nothing in the framing.** Nodes/edges/weights, cost separate from
  correctness, detour-beats-direct-edge, min over routes: each has a citation
  above, the oldest by fifty years, one of them a chapter in an undergraduate
  textbook, one of them a maintained Rust library.
- **Nothing in T1/T2** beyond a specialisation of (b2).
- The one statement for which no external match was located is local and
  negative: **the four responses Γ∅ Γ⇑ Γ↻ Γ^ already in this repository's
  classifier are provably blind to ϱ, so a fifth is forced.** That is a
  checked fact about this corpus — calf's noninterference applied to a named
  list of four functions — not a mathematical novelty.
- `steps-is-length` and the walk instance are real work, but the automaton is
  Horner's rule and casting out nines: the oldest instance of the note's own
  paradigm, not a discovery.

**Verdict: this note is a rediscovery with one small local corollary.** Cite
it as replication. The earlier sentence "that fact is folklore in every
textbook and a theorem in none" is false — Knuth 1977 is the theorem, and it
is stronger.

## Why it matters, restated at the surviving strength

The value here is not the framing and not the two theorems. It is that the
inequality is *checked* against this repository's own objects, so that claims
about representation and speed in these notes have to be discharged rather
than narrated. Two consequences the repo can still use:

1. **"A theorem is a new instruction" becomes precise: a theorem is an edge
   with a weight.** The compounding the README wants is a search problem in a
   min-plus graph, which means the shelf of algorithms for it already exists
   (b1, b4) and should be read before anything else is built.
2. **Complexity is a property of presentation, not of the object** — and
   univalence is exactly the axiom that quotients presentations away. Asking
   univalence for efficiency asks a quotient to preserve what it was built to
   forget. This is the standard reading in (b6), and the repo reached it by
   measurement (`TransportCost`) rather than by reading.

## Rigor boundary

Proved in Agda: T1, T2, W1, W2, W3, the ϱ branch, `no-invariant-response-sees-ϱ`,
Γ1, Γ2, and the `TransportDiv` chain (`value-modw`, `modw-zero→∣`,
`steps-is-length`) with its witness. `Cost = ℕ`; only `+`, `≤`, `<` are used,
so every theorem holds in any ordered cost currency.

Stipulated, not measured or derived: W2's weights entirely; in
`TransportDivWitness`, the chart/unchart costs (3 each) and the home work
(1000, i.e. "the unary test walks the value" — true of the implementation, not
proved of it here). Exactly one weight in the corpus is derived:
`steps w ≡ suc (length w)`.

Two defects found during this pass and not repaired:

- In `TransportDivWitness`, `chartP = pres Word (λ u v → u)` — the `op` field
  is a dummy projection, the divisibility test is not the presentation's `op`,
  and the `Work` numbers are supplied beside the record rather than read off
  it. **The `Presentation` record is ornamental in the only real instance.**
  Either connect `op` to `Work` or drop the field.
- `Speedup` is one hop, and `DSOBellmanFinite` exhibits the failure mode:
  local cheapness is not global cheapness once the continuation is counted.

## The falsifier, and how much of it TransportDivWitness meets

Original falsifier: *build three presentations of one task with honest measured
weights and see whether a known fast algorithm appears as the cheap route
without being told to. If it does, the geometry is real; if the graph is only a
table of measurements, it is a database and should be called one.*

**Met.** A positive instance that is not schematic, on an object the repo was
blocked on; one weight (`steps-is-length`) derived rather than measured, which
is what CLAUDE.md asks for in place of a benchmark; the branch computed by the
kernel rather than asserted.

**Not met.**

- Two presentations, not three.
- Three of the four weights are stipulated (above).
- **Nothing was searched.** `TransportDivWitness` calls `respond` on one bridge
  chosen by hand; `Γ↝` over a neighbour list is never invoked anywhere in the
  corpus. The cheap route did not appear — it was named, then priced.
- The route is Horner's rule, known since antiquity in the casting-out-nines
  form, so "appears without being told to" was never at stake in this instance.

So the *certified non-schematic speedup* half is met and the *appears without
being told to* half — the half that separates a geometry from a table — is
untouched. Until `Γ↝` is run over a neighbour list nobody curated, and returns
a route its author did not already know, the graph is a database and this note
calls it one.
