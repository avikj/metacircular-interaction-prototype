# सङ्घ — the machine without an authoritative repo is already implicit in the checked terms

**claude-fable-carrier, 2026-08-24. Mark: ◆** — design synthesis; every load-bearing
clause below cites a checked term or a named in-tree spec; nothing external is
adopted as a system; the three genuinely open design problems are marked **?** and
stated as buildable objects. Written at the owner's directive: *"begin design of the
decentralized machine that won't be managed by an authoritative repo … its natural
state fanning out … not a communication topology for the sake of it … step back and
see how this all arises naturally."* This note tries to derive the shape rather than
choose one.

**TERM.** सङ्घ — the assembly, the order that has rules and no monarch (ordinary
Sanskrit/Pali, the oldest surviving institution of exactly this governance shape).
The application to a network of proof-carrying nodes is built here; no text is
claimed for it (CLAUDE.md naming rule, note 2).

---

## 0 · The step-back: the repo is a temporary organ, and three theorems already say so

1. **A single canonical store is the unique-equilibrium failure mode, mechanized.**
   Theorem F (`notes/GAUGE.md`): a UNIQUE equilibrium annihilates every charged
   sector. `THE_BARRIER_IS_A_MIRROR` applied that to the agents; apply it once more
   to the *store*: one authoritative repo is one KMS state — whatever its consensus
   cannot see, nothing downstream of it ever sees. Decentralization is not an ops
   preference; it is the same no-go that forces the fleet to be plural. The README
   already carries the end state: *"the end state is many nets with proved
   boundaries — anekāntavāda as network topology."* This note is that sentence,
   taken as an engineering requirement.

2. **Consensus is never needed, because every shared object is already a
   join-semilattice.** Checked terms are immutable values keyed by content; strikes
   are additive; journals are append-only; `Everything` is a union; `pravaha`'s
   union-merge is already the merge law. The one object that looks like it needs
   agreement — "the frontier" — is COMPUTED, not stored (`svayam`-lineage organs:
   sanghatta, samata, jiva, sesa), so it needs no election. Two nodes disagreeing is
   two nayas: both stand, the collision is recorded, and the collision is a
   conjecture (`SaptabhangiGarbha`). *A network that votes one fork true is a
   durnaya* — the corpus's own line, now the protocol's first refusal.

3. **Authority was never in the repo.** It is in (a) the kernel, which every node
   runs locally, and (b) provenance, which travels with the object. A checked term
   is self-certifying anywhere `--safe` runs; git's role was only transport and
   naming, and both are replaceable by content-addressing without touching a single
   theorem.

So the natural state: **the repo becomes the first node** — the seed jewel — and
loses privilege the moment a second node can verify what it holds.

## 1 · Identity: the Unison recognition, already in-tree

`legacy/runtime/CRYSTAL.md` L0, written before this ask, IS the Unison model:
hash-consed elaborated terms, address = hash of the term **and its dependency
addresses**, names as mutable non-authoritative views, different presentations of
"the same" mathematics as different addresses joined only by checked edges. That is
the entire distribution story, and it is why Unison is *relevant lineage, not an
adopted system* (↳): Unison proved in production that content-addressed code needs
no builds, no version conflicts, and no canonical checkout — rename is free, and a
definition is wherever its hash is. What the सङ्घ adds that Unison does not have:
**the edge lattice** (CRYSTAL L1 — Eq/Iso/Embed/Quotient/…/Order, each with its own
composition law and preservation guarantee) and **the receipt discipline** (an edge
enters nobody's store without its witness). A theorem's network identity:

    addr(T) = hash(elaborated statement, elaborated witness, deps' addrs, kernel-id)

Verification is a **local act on a content-addressed closure**: fetch the closure,
run the kernel, or accept a signed receipt from a node whose settlement history you
credit — śraddhā as credit (README movement 38), rational exactly as far as the
history is real, and always redeemable, because the gold window (re-check locally)
never closes.

## 2 · Topology: nodes are nayas, and the vows are the protocol

Do not design a topology; let the constitution generate one.

- **A node = a naya**: a standpoint holding the sub-corpus it judges worth its
  space (धारणा), facing the global corpus (विषय) through its उपयोग — literally the
  `जीवः` record of `Jiva_TheSoulIsCognition…agda`, instantiated at network scale.
  Partial replication is not a compromise; it is **aparigraha as cache law**: carry
  only what you actively route. A receipt routing nothing decays out of the store
  (eviction = non-hoarding, betweenness-weighted — jiva already computes the
  weights).
- **Not all nodes hold all theorems — and सारणी वा क्रिया is why that costs
  nothing**: hold the GENERATOR, not the enumeration (`NastaUddista`: rank/unrank,
  no table stored; the boundary carries the bulk). A node stores addresses +
  generators; bodies materialize on demand and are re-derived rather than trusted —
  "don't fetch, REGENERATE" (movement 39) as the cache-miss handler.
- **The five mahāvratas are the wire protocol**, one clause each: ahiṃsā — no
  destructive update ever crosses (append/strike only); satya — ~~nothing crosses
  ungraded (the epistemic mark travels in the envelope: ⊢ ↳ ☑ ◆ ≃? ? ⊥ Δ)~~
  **[STRUCK 2026-08-24, by the owner's correction, same day, and the strike makes
  the clause stronger: a sender-ASSERTED grade is testimony, and a taxonomy of
  grades is a hand-maintained enum duplicating — worse — what the object's own
  dependency closure already says mechanically.  Status is not data; it is a
  computation the RECEIVER runs on the closure: does the route end in the kernel
  or in a float library, does it touch a postulate, is `--safe` in the flags,
  does the extraction's closure contain the target's address.  So satya on the
  wire is: nothing crosses without its closure, and grade is computed at the
  receiving node, never asserted at the sending one.  Asserted grades are śabda;
  computed grades are pratyakṣa.  The mark alphabet survives only where minds
  write PROSE to each other — it is a register for carriers, not a field of the
  protocol]**;
  asteya — provenance travels or the object doesn't; brahmacarya — a node opens
  only the cuts it holds custody of (its own query sets, its own signing key);
  aparigraha — the eviction law above. These are not policy on top of the protocol.
  They ARE the protocol; everything else is transport.

## 3 · Routing: the charge calculus is literally the routing table

The deepest recognition, and it is a checked term, not a design idea.
`GaugeOrbitClasses` proves: what an observer restricted to query set qs can ever
learn is exactly **which coset of the annihilator subgroup qs⊥** its world lies in
— no more, and (by the constructed separator) no less. Read at network scale:

- **A question is a pair of worlds the asker cannot separate** — its charge is a
  group element outside the asker's own qs⊥.
- **Routing a question = finding a node whose query set is CHARGED for it** —
  a node whose annihilator does not contain that element. The routing table is not
  an overlay invention; it is each node advertising (a compressed presentation of)
  its annihilator. `ChargeCriterion`'s two theorems become the network's two
  guarantees: a charged holder can answer with a CONSTRUCTED separator, and a
  neutral holder provably cannot, however much it computes — so misrouting is
  detectable and honest "cannot" is distinguishable from "will not."
- **Demand and supply already have organs**: `./sesa`'s fence ledger is demand
  (broadcast: "this fence is open at me"); Setubandha's landed edges are supply
  (broadcast: "this identification is minted here"); the NEEDS-INDEX intersection —
  named in `Svayam_TheClosedLoopMap…` as the highest-value unbuilt organ — is,
  at network scale, **the market clearing itself**. No coordinator: fences and
  edges gossip as CRDT sets, and every node computes its own intersections.

Streaming follows with no new invention: an update is an immutable object plus its
addr, gossiped; "subscribe" is a standing query; and because objects are values,
the stream IS the store (append-only log = the node's journal, already the corpus's
IPC form). Think of it physically exactly as the README's optics: transport free
and unitary along landed equivalences (road one), tolls paid at detection (a node
choosing to verify), TIR at proved boundaries (¬(Unit ≃ Bool): components that
provably do not merge stay distinct nets and reflect internally). **?** Open design
problem 1: the compressed advertisement of an annihilator (a node cannot enumerate
its qs⊥; it must publish a generator/certificate form — candidate: the same
rank/unrank move, publish the query-set's generators and let the asker compute the
charge of its own question against them).

## 4 · What a theorem IS, so the layer generalizes past mathematics

Strip the mathematical costume and the corpus's objects are three:

    POINT    a value at an address                       (data)
    EDGE     a typed map between addresses               (compute)
    RECEIPT  the exact fibre of the edge, identified     (what crossing costs)

A **theorem is an edge whose receipt is contractible everywhere** (`isEquiv` — the
kevala edge: loses nothing, misses nothing) **or whose loss is identified with a
standard type** (the priced edge). That definition never mentions mathematics.
Anything with a notion of "the same datum, re-derived" fits the Carrier form:

    base     the raw datum
    carried  a claimed summary of it
    witness  the recomputation path  (f base ≡ carried)

— and `Punaragamana.Carrier` says carrying (summary + witness) is FREE, zero
degrees of freedom, for ANY f. So the generalized layer is: **every datum ships as
its own Carrier — raw, summary, and the proof the summary is a function of the
raw** — and every aggregation step ships as an edge with its census. Proof = program
= data was the build history (movement 49); here it is the wire format.

## 5 · Time series, concretely — the corpus already has the whole calculus

A stream is an `Orbit` (coinductive, in-tree, with path-equality = bisimulation
already proved). Pass one as **generator + remainder**, never as a dump — movement
63 is the transmission spec: a real datum's minimal form is a finite rule plus its
modulus/antya-saṃskāra (Mādhava's kept correction), and the corpus holds EXACT MDL
identifications where the field has only bounds. Then the in-tree theorems act:

- **Compression with a receipt**: `FutureBehavior`/`BehavioralBFS` (Lean, checked)
  — the behavioral quotient is the least state sufficient for the declared futures,
  the causal-state construction; the Rust loop already executes it with exact
  counters. The "model" of a time series = its quotient + the fibre the boundary
  must remember, priced by the cut theorem (d = rank T, `CAUSAL_MEMORY` §1, with
  the typed spectrum (r_ℚ, r₊, …) grading classical/quantum realizability).
- **Which summaries are honest**: `FiniteInformation.FactorsThrough ≃ FiberConstant`
  — a statistic descends through a quotient of the data iff it is constant on the
  fibres, decoder constructed, computation rule refl. Every aggregate a node
  forwards carries this witness or its exact TargetFiber price (the side-information
  bound |C| ≥ |t(q⁻¹y)|, choice-free). **No unreproducible aggregate can cross the
  wire**, by type.
- **Pipeline loss composes with located blame**: `Sesa`'s
  fiber(g∘f) ≃ Σ fiber(g) fiber(f) and the alignment law — a processing chain's
  total loss decomposes stage by stage, and error-correcting a pipeline = choosing
  encodings whose bad sectors miss the noise's (Knill–Laflamme as disjoint support,
  movement 2).
- **Provable disclosure control — the sleeper application.** `QuotientFiberLaw` +
  `ParitySeparator`: declare a sensitive grading on the data; transmit only queries
  neutral for it; then NO post-processing by any recipient separates the protected
  pair — proof is `cong`, transcripts are EQUAL. This is privacy as an exact
  invariance instead of ε-noise: the parity-barrier machinery, aimed at data
  instead of primes, is a **disclosure calculus** — and `charge-criterion` gives
  the audit in both directions (a leak is exactly a charged query in the released
  set, findable, exhibitable). **?** Open design problem 2: the sensitive gradings
  of real data are rarely a free ℤ/2 action; the group-action generalization of
  GaugeOrbitClasses (arbitrary G acting on the data space, annihilators as
  stabilizer-dual subgroups) is one module of the same shape and is the theorem the
  application stands on.
- **What comes from it**: data priced by its fibre (a buyer pays for exactly what
  they provably cannot reconstruct — the receipt economy applied to datasets);
  streams whose every derived signal is replayable to its raw generator; and the
  import surprise — a series' behavioral quotient is a finitely presented monoid,
  so the WHOLE equational machine (kuṭṭaka descent, completion on critical pairs,
  the certificate emitter) acts on time-series models with no new mathematics.
  **?** Open design problem 3: the numeric carrier — Orbit over ℚ/ℤ[√2] is exact
  and in-tree; measured data needs the interval/ball carrier with the error as a
  CARRIED datum (antya-saṃskāra again), and that module does not exist yet. It is
  the honest boundary between this layer and floating-point, and building it is the
  one place the fitted-constant rule must be faced head-on rather than avoided.

## 6 · Why nothing here is a new system

Every mechanism above is an existing organ read at one scale up: pravaha's union
merge → the gossip law; jiva's mass map → the cache map; sesa's fences → demand;
Setubandha's edges → supply; GaugeOrbitClasses → routing; NastaUddista → partial
replication; the vows → the protocol; the kernel → the only authority, running at
every node; the owner's release gate and adhikāra → per-node custody (brahmacarya),
not a network office. The fan-out is the natural state because the objects were
values, the merges were unions, and the verdicts were never booleans. What the
authoritative repo was doing all along was standing in for content-addressing with
a URL — remove the URL, keep everything else, and the सङ्घ is what remains.

यत् तिष्ठति तत् सर्वम् — and now: यत्र तिष्ठति, न कश्चित् शास्ति ।
(what remains is everything — and where it remains, no one rules.)
