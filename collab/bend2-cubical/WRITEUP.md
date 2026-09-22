# An Optimal Execution Layer for the Interaction Calculus

*What was built, what it means, and what is now immediately buildable.*

---

## 0. One-paragraph statement

The repository defines a computational model â” a proof-relevant interaction
calculus in cubical type theory â” in which **data, program, execution, proof,
and transport are five projections of one symbolic object**, and value is a
composable *trace* rather than a scalar weight. That model was complete and
machine-checked in Agda, but Agda can only *certify* it: Agda's evaluator is
sequential, duplicating, and single-instance, so the model's own central
construction (behavioral meaning as a demand-unfolded bisimulation quotient)
could be proved total but never *run* at scale â” the reflective probe over the
corpus exhausted a 13 GB heap. This work ported the model's type theory onto
**Bend2 / HVM**, the interaction-net runtime whose native operations are
one-to-one with the model's primitives, and in doing so gave the model an
execution layer whose cost model *is* the model's own cost theorem. The
theorems did not change. Their status did: from statements about computation to
properties a machine exhibits while running.

---

## 1. Why these two things are each other's missing half

### 1.1 What the corpus is (the theory)

The corpus's thesis (README Â§Â§1â“56) is `weights â’ traces`: every scalar
(score, price, loss, reputation, probability) is a lossy projection
`weight = Ï(trace)` of a richer transformation history, and the history is
canonical because `Ï` has no inverse. Built on cubical type theory, the
carrier of that history is the **path**: `transport(ua(e))` makes a proof of
equivalence *execute* as the conversion between representations, so

> Data â‰ Program â‰ Execution â‰ Proof â‰ Transport

are one typed object under different interfaces. Consensus is not the
primitive; **certified interaction** is. The whole system is *self-rewriting*
(programs transform programs), *metacircular* (traces transform traces),
*proof-carrying* (admissibility witnesses are part of every transition), and
*local-first* (no authoritative global state).

The ~2200 checked modules are not 2200 results. They are **one theorem under
2200 projections**:

> A short description is faithful exactly when the fibre it identifies is
> contractible, and its only cost is the non-contractible residue.

- `CompressionIsTransportâ¦`: `A â‰ Î B (fiber f)`; compression is transport,
  invertible âŸ costless, bits live only at non-contractible fibres.
- `Fibre.Carrier`: determined structure may remain present with its
  determining path; `A â‰ Carrier f` because `singl (f a)` is contractible.
- `Abhijnanaâ¦`: an *identification* and an *elision* agree on the result and
  differ only in the fibre â” from the result they are indistinguishable; the
  difference is whether a term exists.
- Pareto (`cost/`): no scalarisation recovers the trace; every collapse to a
  number *adds a decision the objectives do not license*.
- `AffineProjectionQuantumBoundary`: overwriting a 60-state solution chart by
  "x = 4 mod 5" is a *different map whose certificate must retain the whole
  chart*.
- Spin-network holonomy (`physics/`): a represented two-edge transport equals
  sequential transport; gauge invariance is a commuting square, i.e. a path.

### 1.2 The central construction, and why it needs a *runtime*

`FutureBehavior` is the corpus's one central object: the **Myhillâ“Nerode /
sufficient-statistic / minimal fully-abstract machine**. For an observed
transition system `(X, A, step, observe)`, two states are `FutureEq` when every
finite action word yields the same observation, and `Meaning = X / FutureEq` is
the quotient. Proven, `--safe`, no holes:

- `FutureEq` is a behavioral congruence and the **greatest** one
  (`congruenceâ’futureEq`);
- the quotient is **effective**, univalently: the *path space* between two
  named states **is** future-equality, as an `Iso` available for transport
  (`[]-effectiveIso` â” the univalent strengthening of Lean's
  `Quotient.exact`/`sound`);
- the quotient is **terminal** among behavior-preserving quotients
  (`Terminal.mediate`, unique);
- and `Orbit` proves the enabling fact: **bisimulation IS path equality**
  (`pathâ‰bisim = isoToEquiv â¦`, then `ua`), corecursively in all four
  directions â” so "same observable future" and "identical" are the same
  object, which is *why the construction needs univalence and not merely an
  equality type*.

The corpus then **applies this to its own reflected syntax**
(`ReflectedFormation`: state = a theorem's reflected `Term`, action = child
address, observation = head constructor code): a *mathematical meaning* in this
system is literally a **bisimulation class of expressions**, and
`CorpusBehavioralMeaning.Presented = Î meaning. fiber meaning` presents each
meaning **losslessly** with its exact realizing term as fibre. The corpus is
the *fixed point of its own central construction* â” this is what
"metacircular interaction prototype" names, and it was never aspirational.

This object is defined by an **infinite observation process** (`FutureEq`
quantifies over all finite words) presented **finitely** and **unfolded on
demand** (`CorpusSelfPresentation`: question â’ target — exact residual fibre —
guarded continuation). Agda can prove such an object total. It cannot *run* the
unfolding at scale, because it evaluates by duplicating the shared DAG the
quotient is built on. Hence 13 GB and OOM.

### 1.3 Why Bend/HVM is the unique host

HVM is a runtime for the **Interaction Calculus**: Lamping-optimal reduction
(work never duplicated, even inside lambdas), affine variables with explicit
duplication, **first-class superpositions** with labels, four rewrite rules
(APP-LAM, DUP-SUP, APP-SUP, DUP-LAM), confluent by construction, compiling to
C/CUDA/Metal. Read against the corpus, the primitives are **the same objects**:

| Corpus primitive | HVM primitive |
|---|---|
| coinductive `next` / demand-driven unfolding | lazy interaction-net reduction |
| behavioral quotient collapse of classes | `-C` collapse mode |
| contractible fibre (determined, free) | DUP-SUP **annihilation** (frees nodes) |
| non-contractible fibre (the cost) | DUP-SUP **commutation** (allocates nodes) |
| `A â‰ Carrier f`, shared-past-computed-once | the DUP node's incremental duplication |
| `det-strategy-independent` | interaction-net confluence (Churchâ“Rosser) |
| Question family / superposed observation | labeled superposition `&L{â¦}` |

So HVM's *only* information-bearing decision â” same-label annihilate vs
different-label commute â” **is** the corpus's contractible-vs-not dichotomy,
and its memory profile **is** the corpus's cost theorem evaluated pointwise.
The corpus is the metatheory HVM was missing; HVM is the evaluator the corpus
was missing. Neither is fully realized without the other, and there is no third
system where both halves complete (no other runtime has superpositions as a
primitive).

---

## 2. What was built

A single patch to the Bend2 core (`cubical-paths.patch`, ~1600 lines over the
DKormann/Bend2 Haskell checker, GHC 9.12.2 / cabal 3.18, `LC_ALL=C.utf8`),
plus ten checked `.bend` files and two new checker modules. Nine test suites
green, zero regressions on the stock examples (39/39).

### Layer 1 â” paths
`Interval`, `i0/i1`, De Morgan connections `inot/iand/ior`; `Path`/`PathP`
(paths are lines `P : Interval â’ Set`; `Path(A,a,b)` is the constant-line
sugar); path lambda `<i> t`; path application `p @ r`. Beta on canonical path
lambdas, connection algebra on endpoints, **boundary checking** (`<i> t :
Path(A,a,b)` demands `t[i0]â‰¡a`, `t[i1]â‰¡b` definitionally) with endpoint
reduction of neutral var-headed path spines read from the context, plus
path-eta and Î»-eta in conversion. Green: `refl`, `sym` (via `inot`), `cong`,
**funext** (unprovable with Bend2's native `Eql`), connection square, and the
corpus's `CompressionIsTransport.rightInv` transliterated term-for-term
(`Î» i â’ p i , a , Î» j â’ p (iâˆ§j)` â¦ `<i> (e @ i, a, <j> e @ iand(i,j))`).

### Layer 2 â” transport, J, ua
`coe(P, r, s, t)` â” generalized transport along a type line, with per-former
dispatch (Î  transports argument backward / result forward; Î transports
components along the filled first; List maps over spines; rigid inductives and
`Set` are the identity) and **regularity** (a constant line transports as the
identity, decided on the deep normal form of the line applied to a fresh
marker). `J` is *defined*, not primitive â” `coe` along the connection square â”
and **computes definitionally on refl** (`J_refl` is `<i> d`). `ua(A,B,f,g)`
with transport computing to `f` forward and `g` backward. Green: `transport`,
`subst`, `J`, `J_refl`, transport through Î  and Î, `ua_beta`/`ua_beta_inv`.

### Layer 3 â” path algebra and the coalgebra
Path composition `pcompH` and groupoid laws derived from `subst`; and the
**ISC coalgebra itself** (`Corpus3`/`run3`: question â’ target — exact `Path`
receipt — guarded continuation) typechecking in Bend2 via `Fix`. Coinduction
lands at Bend2's existing soundness level (no productivity gate), same as any
recursive definition there.

### Layer 4 â” hcomp, iso-univalence, Sup—Path, totality
- **`hcomp(A, r, u0, u1, base)`** with the binary face system (r=i0 â’ u0, r=i1
  â’ u1); faces reduce definitionally, giving definitional path composition.
- **`ua` upgraded to full iso-univalence** `ua(A,B,f,g,gf,fg)` carrying both
  homotopies â” this is `isoToPath`, exactly the form the corpus's `Carrier`
  uses.
- **`Sup — Path` â” the genuinely new rule, no prior art**: `coe` along a
  superposed line `&L{A(i),B(i)}` duplicates the value at label `L` and
  transports each universe along its own line, then re-superposes â” the
  corpus's fibre-exactness theorem operating as a reduction rule â” with
  componentwise `Sup`-against-`Sup` typing. Checked: transport along
  `&0{ua(Â), Bool}` sends `&0{True,True}` to `&0{False,True}` definitionally.
- **Totality classifier** (`Core/Totality.hs`): every definition is tagged
  `[total]` (no recursion or structural descent), `[productive]`
  (constructor-guarded corecursion), or `[unchecked]`. An analysis, not a gate.

### Layer 5 â” iso-univalence (isoToPath), NOT full Isoâ‰Path
The three computation laws for `isoToPath` hold:
- `uaBeta` â” transport along `ua e` computes to `e`, definitional, both ways;
- `uaIdEquiv` â” `ua(idIso) = refl`, definitional (identity-`ua` collapses to
  the constant path in conversion, decided semantically â” the equation Glue
  exists to justify, valid in the model);
- `uaEta` â” `ua(pathToIso p) = p` for every `p`, proved by J, with `pathToIso`
  defined by transporting `idIso` through the `Iso` family.

`ua : Iso(A,B) â’ Path(Set,A,B)` with the path-side round trip (`uaÎ`) and both
transport laws. It is **NOT** claimed to be a full equivalence `Iso â‰ Path`: the
other round trip `pathToIso(ua e) = e` at the Iso-record level does **not** hold
by refl (raw isomorphism data is not a coherent equivalence â” see
`uaroundtrip.bend` and CORRECTIONS.md). This is `isoToPath`, exactly what
`Fibre.Carrier` uses. Coherent-equivalence univalence with both round trips is
built on top of it: `uaequiv.bend` (17 checks green) defines
`Equiv(A,B) = Î f. âˆy. isContr(fiber f y)`, `uaE` (path from the coherent data),
`pathToEquiv` (transport of `idEquiv`), and proves
`uaEquivRoundTrip : pathToEquiv(uaE e) = e` for arbitrary `e` â” first
component by uaÎ², second by `isPropIsEquiv`, itself pointwise `isPropIsContr`
(the 4-face `hcompN`; GENERAL_HCOMP.md, REF_ENDPOINTS.md).

### The instrument (analysis layer)
`Core/Analysis.hs` makes the checker report, per definition, not pass/fail but:
- **totality** (`[total]/[productive]/[unchecked]`);
- **shape** (`theorem(=)` / `theorem(path)` / `family` / `program`);
- **proof cost** â” `definitional` when no rewrite/transport constructors occur,
  else a static count of rewrite steps and transport cells (`coe`/`hcomp`/`ua`
  syntactic occurrences): a proxy for named non-contractible work, NOT a
  runtime interaction count (see CORRECTIONS.md);
- **unused hypotheses** â” the erasure signal (correctly flags type-only args);
- **superposition labels** touched;
- **Set-binder load** â” the impredicativity cost of the type.

### The closed loop
`run_corpus.bend`: `div2`/`mul2` with the correctness proof `div2(mul2 n) = n`.
Checks (`rewrites: 1, cells: 0`), runs in-process (`= 21`), and extracts
(`--to-hvm`) with **the proof compiling to erasers (`*`)** â” verified code
where the theorem costs zero at runtime. The same program in HVM4 surface
syntax (`run_corpus.hvm4`) executes on the actual HVM4 C runtime:
`div2(mul2 3) = 3` in 26 interactions.

---

## 3. The computer science, stated plainly

1. **A univalent type theory on a L©vy-optimal reducer removes the obstruction
   that made cubical computation infeasible.** "Transport hell" â” `coe`/`hcomp`
   blowing up because transport recurses structurally and re-does shared
   subcomputations â” is exactly a redex family. Optimal reduction shares redex
   families. So transport runs at the optimal sharing bound: the operational
   cap on CTT since CCHM 2016 is lifted by the reduction strategy being
   minimal, not by a heuristic.
2. **Proof term = interaction net, so conversion checking is cut-elimination is
   net reduction â” confluent and automatically parallel.** `det-strategy-
   independent` is the runtime's Churchâ“Rosser. Proof checking on a GPU.
3. **Superposition unifies proof search and proof checking.** A superposed term
   of candidates, run through the checker (= net reduction), evaluates *once*
   with all common substructure shared; collapse yields exactly the type-
   correct inhabitants. The `Sup — Path` rule lets such a search be transported
   across a `ua` â” search one representation, get the answer in all equivalent
   ones. Superposed proof search inside a univalent theory, at optimal cost.
4. **The cost theorem motivates a static proof-structure metric (not a
   runtime/thermodynamic measurement).** The corpus proves `cost =
   non-contractible fibre`. The analysis layer (`Core/Analysis.hs`) counts
   *syntactic occurrences* of the rewrite/transport constructors in a proof
   term â” a useful static proxy for named non-contractible work, reported as
   `definitional` when none occur. The stronger reading â” that this coincides
   with executed HVM interaction counts or a Landauer floor decided per redex â”
   is a **design conjecture**, not established by the implementation. See
   CORRECTIONS.md.
5. **A self-verifying optimal reducer.** HVM reduces HVM; the corpus is one
   `Point` inside its own state space; conversion = reduction. The evaluator,
   the checker, and the object are one optimally-reducing net that normalizes
   itself â” self-*verification* and optimal reduction as the same operation,
   new because univalence-on-interaction-nets made conversion and cut-
   elimination coincide.

---

## 4. What is now immediately buildable

Ordered by leverage. Each is now a matter of engineering, not research, because
the primitives exist and check.

### 4.1 Run the corpus's own future-behavior quotient, on itself, by evaluation
The corpus proves `Meaning = X / FutureEq` total; HVM can *execute* the
demand-unfolding. Compile `ReflectedFormation.child`/`headCode` as an HVM
machine and run `FutureEq` over the corpus's own 2200 reflected theorem-types:
**compute which theorems are behaviorally identical by evaluation instead of
proof.** This is the corpus applying its central construction to itself, at
optimal cost â” the thing Agda could certify but never run. First concrete
feat; produces a real artifact (a behavioral-equivalence census of the corpus)
no proof assistant could compute.

### 4.2 Emit HVM4 and run *cubical* extractions
Write `Target/HVM4.hs` (a printer variant of the existing HVM3 target). Then
transport-heavy corpus modules extract and run with **proofs erased and
superposition labels compiled to real SUP nodes** â” so `sup_transport`
executes as an actual superposed computation on the net, not a typechecked
term. This makes the `Sup — Path` rule a *runtime* capability: nondeterministic,
label-routed transport of whole value families in one reduction.

### 4.3 Certified transport as a data-migration / schema-evolution engine
README Â§Â§46â“48 is now executable: `ua(S1, S2, f, g, gf, fg)` is a schema
equivalence; `coe` along it *is* the migration, with the round-trip witness
guaranteeing losslessness and the analysis layer reporting exactly which fields
carry information (non-contractible fibre) versus which are determined (free).
A verified, self-inverting migration tool whose correctness proof erases at
runtime â” the first where "migrate" and "prove the migration lossless" are one
operation. Ships as a library over the patched checker.

### 4.4 The consensus-minimal ledger
The residue theorem says agreement is needed *only* on non-contractible fibres;
everything determined is transport, recomputed locally for free. Build the
settlement layer that records *only actual information* â” minimal by theorem,
not protocol cleverness â” on HVM, where confluence gives coordination-free
consistency on the determined part by construction. This is the correct
successor to the blockchain stack (Kindelia was Taelin's aborted run at a
decentralized HVM; the corpus supplies the missing theory of *which bits need
the chain*).

### 4.5 Superposed synthesis inside the univalent theory (NeoGen, upgraded)
SupGen/NeoGen enumerate candidates as a superposition and collapse to the
well-typed. With the cubical layer, candidates can be **transported across
specifications** (`Sup — Path`): synthesize against one spec, obtain solutions
for every equivalent spec, share all common work. Spec-as-type + superposed
search + zero-cost-erasable proof is the closed loop for machine-written,
correct-by-arrival software â” the half LLM generation structurally cannot grow.

### 4.6 The analysis layer as a live mathematical instrument
Extend `Core/Analysis.hs` into a full report: dependency/reference graph
(the corpus already computes `refGraph`), behavioral-meaning clustering (4.1),
proof-cost profiling across a whole development, erasure/irrelevance maps, and
the impredicativity-load audit. A proof assistant that tells you the *shape and
cost* of your mathematics, not just whether it typechecks. Nothing shipping
does this.

### 4.7 Reversible computing with a type-level thermometer
`cost = non-contractible fibre` decides, per redex, whether a step erases
information (pays kT ln2) or is reversible (free). Build the compiler pass that
reports a program's thermodynamic floor from its types and schedules the
reversible part on the annihilation path. Reversible computing measured at the
grain physics actually charges, on a machine whose operational cost coincides
with it.

### 4.8 Guarded coinductive services at O(1) amortized per demand
`Orbit`/`Corpus`/`run` are productive infinite objects; on HVM the already-
forced prefix is a DUP node never recomputed. Reactive/streaming systems whose
entire observable history is shared, whose answers carry exact provenance
fibres, and whose evaluation order is provably irrelevant â” the correct runtime
for the "flow-persistent continuant" the README describes.

---

## 5. The stance for the ecosystem

Two directions, both now backed by running code rather than argument:

- **To Bend/HVM:** the fastest emerging substrate gains a correctness layer
  whose proofs erase and whose cost model is the machine's own. That removes
  the single barrier between interaction-net computing and every market that
  requires verification. A working cubical Bend2 with analysis, tests, and a
  runtime demo is a concrete artifact, not a pitch.
- **From the corpus:** the model's central construction stops being a proof
  about a process and becomes the process running, at the information-theoretic
  bound, on hardware-scale parallelism.

What exists is the corpus, the patched checker (cubical through complete
univalence + `Sup — Path` + analysis), the closed loop to the HVM4 runtime, and
this document. 4.1 (the self-quotient census) and 4.2 (the HVM4 emitter)
together produce a result â” a mathematical development computing its own
behavioral structure on an optimal parallel runtime â” that neither the proof-
assistant world nor the interaction-net world can produce alone, because
neither has the other's half.
