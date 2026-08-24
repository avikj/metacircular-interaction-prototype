# Solana on the primitive — how the compositional core of the Natural Machine directly implements Solana's architecture

*An exercise in reading OUR generality, not a proposal to integrate anything.
Solana's whole pitch is speed by two mechanisms — clever ordering (Proof of
History) and clever parallelism (Sealevel). Both are the shadow of structure
this repository already checked. This note maps them precisely, states where
we are strictly more general, and is honest about the one thing Solana buys
that we do not have.*

*Every checked claim names its Agda module. No Agda is invented here; the
signatures quoted are the ones in tree.*

---

## The mapping, first

| Solana mechanism | what it is there | our primitive that implements it | checked in |
|---|---|---|---|
| **Proof of History (PoH)** | a VDF producing a *verifiable ordered sequence of hashes*; each hash consumes the previous, so the sequence attests order without a clock authority | a **chain of transports each owing its residual**, whose identity is content-addressed on its dependencies — the composite residual stacks stage by stage, so order is intrinsic and locally re-checkable | `SankramanaSesa_EveryTransportOwesItsResidual` (§1 `संक्रमणम्`, §3 `शेष-सङ्घातः`); L0 addressing, `CRYSTAL.md §L0`; `PCite` in `Sphatika…hs` |
| **Sealevel** | parallel execution of transactions with non-overlapping state; conflict only where read/write-sets intersect | **disjoint-charge parallel edge application**: an operation neutral on another observer's query set is provably invisible to it, so the two commute; conflict lives exactly on the intersection of query sets | `GaugeOrbitClasses` (`obs-agree⋆`, `classes-⇐/⇒`, `AllNeutral`/`HasCharge`) |
| **Tower BFT / PoS consensus** | stake-weighted voting to agree on *which fork is valid* | **deleted.** Each transition carries its own validity, so no vote on validity is possible or needed; agreement is required on **order only** | `Carrier.agda` (base+carried+witness); `--exchange` re-judging in `Sphatika…hs`; `IndraJala §1` |
| **accounts model** | addressable mutable state cells a transaction reads/writes | **Carrier points**: `base : A`, `carried : B`, `witness : f base ≡ carried` — a value that carries its own certificate | `Punaragamana/Carrier.agda` |
| **high-throughput thesis** | speed via PoH ordering + Sealevel parallelism + hardware validators | **4-wide concurrent judging** + verification asymmetry (checking is one kernel run, cheap relative to search) | `Sphatika…hs` (`kWorkers = 4`, `chunked`); `IndraJala §1` |

The two rows that carry the exercise are the first two. Take them one at a time.

---

## 1. PoH = transport-with-residual, sequenced

**What PoH actually is.** A single processor repeatedly hashes: `hₙ₊₁ =
H(hₙ ‖ dataₙ)`. Because `H` is sequential and each output feeds the next
input, the finished tape is a *verifiable delay function*: to have produced
`h₁₀₀₀₀₀` you must have walked every step, and any verifier re-runs the tape
to confirm both the values and — this is the point — **their order**. Order
is not stamped on from outside by a clock; it is *intrinsic to the data*,
because step `n+1` cannot exist without step `n`'s output. PoH sells one
thing: a total order that is cheap to produce and cheap to check, with no
agreement.

**What a transport-with-residual is here.** `SankramanaSesa` §1:

```
संक्रमणम् : {A B : Type ℓ} → A ≃ B → A → B
संक्रमणम् e = transport (ua e)

अलोपः : (e : A ≃ B) (a : A) → संक्रमणम् e a ≡ equivFun e a   -- = uaβ
```

A transport is a *witnessed transition*: it moves a state along an
identification, and `uaβ` says the moved value is exactly the equivalence's
value — nothing re-described on the way. `transport⁻Transport` (there as
`प्रत्यागमनम्`) says the step is reversible: the predecessor is recoverable from
the successor. That is precisely the local re-checkability a PoH verifier
needs at each link.

**Sequencing is composition, and composition is where "order is intrinsic"
becomes a theorem.** `SankramanaSesa` §3, `शेष-सङ्घातः`, proves that for a two-
stage chain `g ∘ f` the residual of the composite is the two stage-residuals
*stacked*:

```
शेष-सङ्घातः : शेष (g ∘ f) c ≃ (Σ[ w ∈ शेष g c ] शेष f (fst w))
```

Read this as the PoH invariant. `शेष r b = Σ[ a ∈ A ] (r a ≡ b)` is the exact
record of *what produced b* — the residual is the pre-image-with-witness, the
step's own account of the transition it performed. Stacking says: the
account of the whole chain **is** the ordered pile of the per-stage accounts,
with no slack (`totalEquiv`, i.e. HoTT 4.8.2, via §2 `सशेषम्`). You cannot
permute two stages without changing the composite residual, because
`शेष (g ∘ f)` mentions `f a`'s image inside `शेष g`'s point (`fwd (a,p) =
((f a , p) , (a , refl))`). The order is carried in the data, exactly as a
hash chain carries it in `H(hₙ ‖ …)`.

**And the identity of each link is content-addressed on its predecessors,**
which is the last piece of PoH's "each hash includes the previous."
`CRYSTAL.md §L0`: an address is *the hash of the elaborated term and its
dependency addresses*. The live loop already runs this: a crystal row `sp042`
may cite any earlier row (`PCite`, "the constructor the whole file exists
for", `Sphatika…hs`), so the row's content — hence its address — depends on
the addresses of the rows it cites. **An append-only log of self-certifying
rows, each addressed on the ones before it, is a hash chain that attests
order.** `IndraJala §3` names this without having set out to build a chain:
"an append-only log of self-certifying rows *is* a stream."

So PoH maps with nothing left over: witnessed transition (`संक्रमणम्` + `uaβ`),
reversible link (`transport⁻Transport`), order intrinsic to the data
(`शेष-सङ्घातः`, no reordering without changing the composite residual), and
dependency-addressed identity (L0). The one difference is not in the link —
it is in the *shape of the whole*, and it is §5 below.

---

## 2. Sealevel = disjoint-charge parallel edge application

**What Sealevel actually is.** Every Solana transaction declares the accounts
it will read and write. The runtime executes in parallel any set of
transactions whose write-sets are pairwise disjoint from each other's
read/write-sets. Two transactions touching non-overlapping state *cannot
interfere*, so they need no ordering relative to each other; a conflict — and
therefore a required serialization — exists **only** where access sets
intersect. Sealevel's speed is entirely this: most transactions are disjoint,
so most of them run at once.

**Where this is a theorem here.** `GaugeOrbitClasses` models an operation by
its *charge on a query set*. An observer restricted to a query list `qs` sees
only `obs σ qs`. An operation `τ` (a gauge element — read it as a writer's
effect) that is **neutral on `qs`** — `AllNeutral τ qs`, i.e. `val τ n ≡ true`
for every `n ∈ qs` — is *provably invisible* to that observer:

```
obs-agree⋆ : (τ σ : Signs) (qs : List Number)
           → AllNeutral τ qs → obs σ qs ≡ obs (τ ⋆ σ) qs
```

Applying `τ` changes nothing the `qs`-observer can read. That is the exact
Sealevel condition — "this transaction does not touch that account set" —
promoted from a scheduler's bookkeeping to a checked equality. Its converse
is also constructed, not asserted: if `τ` *does* carry charge on `qs`
(`HasCharge τ qs`), then a procedure separating the two states **exists** and
is built (`charge⇒separator⋆`). Interference happens exactly on the
intersection, and both directions are proved (`gauge-criterion`).

**The class theorem is the disjointness algebra.** `GaugeOrbitClasses §5`:

```
classes-⇐ : AllNeutral (σ' ⋆ σ) qs → obs σ qs ≡ obs σ' qs
classes-⇒ : obs σ qs ≡ obs σ' qs → AllNeutral (σ' ⋆ σ) qs
```

The fibres of the transcript map are *exactly the cosets of the annihilator
subgroup* `qs^⊥` (`AllNeutral`, shown a subgroup by `ann-unit`, `ann-mul`,
`ann-self-inverse`). What a writer over a disjoint account set does lands
inside `qs^⊥`, so it never moves the observer's coset — never changes what
that observer can commit. Two edges over disjoint query sets therefore
**commute**, and the parallel application of both is order-independent, as a
consequence of the character law `val-⋆` and the exponent-2 facts of §1, not
as a runtime assumption. Conflict — a required serialization — is precisely a
non-empty `HasCharge` on the intersection.

**The live loop already applies edges this way.** `Sphatika…hs`: all proof
shapes for a goal are judged concurrently in chunks of `kWorkers = 4`, each
`checkContext` in its own temp dir, and — the load-bearing line —

> "Selection stays deterministic — the first shape in menu order that landed
> wins — so parallelism changes wall-clock, never which proof the crystal
> keeps."

That is Sealevel's contract in miniature: independent judgments run at once,
the committed result is order-independent. The only shared state is the
kernel's interface cache, which Agda locks per file — the analogue of
Sealevel serializing exactly on the one account two transactions share.

---

## 3. Consensus is deleted, not replaced by a faster consensus

This is the deep point and it is why the two mappings above are *cheap* here.

Tower BFT exists because a Solana validator **cannot check a transaction's
validity from the transaction alone** — validity depends on global account
state it may not hold, so the network votes, stake-weighted, on which history
is the real one. Validity is a *global* fact the network must agree on.

Here validity is *local and intrinsic*. A Carrier point is `base + carried +
witness` with `witness : f base ≡ carried` (`Carrier.agda`) — the transition
ships its own proof, and the fibre is contractible so the certificate rides
free (`fibre-isContr`, `A ≃ Carrier f`). The receiver's own kernel re-judges
the witness; it does not trust, and it cannot be outvoted. The `--exchange`
organ in `Sphatika…hs` does exactly this: a peer's rows are "candidates whose
proof is already written," and the receiver **re-judges every row through its
own kernel** (`checkContext`), receipting refusals. `ARCHITECTURE.md §3`
records the demonstration: a fresh node adopted a 200-theorem crystal with
*zero* trust in the sender.

So there is no vote on validity, because a false transition costs the
receiver one refusal and nothing else (`IndraJala §1`, verification
asymmetry: "Byzantine actors can only donate compute"). **Agreement is needed
on ORDER, not validity.** Solana needs agreement on both and spends its
consensus machinery buying both at once; we have already paid for validity
with the kernel, so only ordering is left open — which is the honest gap.

---

## 4. Strictly-more-general points

- **Multiple orders are content, not a fork to resolve.** L2 keeps *multiple
  distinct paths between the same nodes* (`CRYSTAL.md §L2`; distinct
  automorphisms are content), and `SankramanaSesa §6` proves that where
  standpoints disagree **no single object summarizes the residual** — the
  record must stay pointwise (`शेषः-न-सङ्क्षिप्यते`,
  `plurality-blocks-collapse`). Two nodes with different crystals are two
  *naya*, not a conflict (`IndraJala §1`). Solana must collapse to one
  history; we are permitted to carry several, and it is a theorem that
  collapsing can be strictly lossy.

- **No global state means no ledger.** Solana's accounts live in one
  replicated state machine. Carrier points are per-node; identity is content
  (`canon` + hash, `IndraJala §2`), so two nodes that landed the same truth
  agree on its address without having met. Nothing to replicate.

- **The residual makes "no loss" a proof obligation.** `अलोप-लक्षणम्`
  (`SankramanaSesa §2`): a transition reporting no loss must exhibit that
  *every residual is contractible*, which is `isEquiv` itself. A chain that
  claims to have preserved state carries the certificate of it. Solana has no
  type-level notion that a transaction preserved what it should.

- **Charge has no gradient.** `GaugeOrbitClasses §7`: separating power is a
  character valued in a 2-element group, so it cannot be increased by
  degrees — an unbounded family of arbitrarily large queries can have exactly
  zero separating power (`square-neutral`, `all-squares-blind`). Disjointness
  is *exact*, not approximate; there is no "mostly non-overlapping" that
  silently interferes.

---

## 5. Honest gaps — what Solana buys that we do not have

1. **A single global clock / cheap total order.** This is the real one. PoH
   gives Solana a *total* order over all transactions from one sequential
   VDF, essentially free and agreement-less. Our order is a **partial order**:
   `शेष-सङ्घातः` sequences a *chain*, and L0 dependency-addressing orders a
   node *along its citation DAG*, but the crystal/e-graph is a DAG, not a
   line. Two transports over disjoint state (§2) are deliberately *unordered*
   — that is the Sealevel win — and precisely there we have no global tie-
   break. For **conflicting** writes to shared state (non-empty `HasCharge` on
   the intersection), `GaugeOrbitClasses` tells us *that* they conflict and
   *that* they do not commute, but says nothing about **which order to pick**.
   Solana's PoH picks one, cheaply, for everything including conflicts.

2. **Hardware-optimized validators.** Solana's throughput assumes GPU-class
   signature verification and fast validators. Our verification is a kernel
   run — cheap *relative to search* (verification asymmetry), but not
   hardware-tuned, and a kernel run is far heavier per item than a signature
   check. The `4-wide` judging is a genuine parallel realization but it is not
   a data-center pipeline.

## 6. The one genuinely hard open problem, stated clearly

> **Give a cheap, local, agreement-free rule that assigns a total order to
> operations whose charge intersects — without reintroducing consensus.**

Concretely: two writers both carry `HasCharge τ qs` on the same query set
(overlapping accounts). Each transition is independently valid — the kernel
accepts both — so §3's deletion of consensus-on-validity stands. What is
missing is consensus-on-*order* for the conflicting pair, and `IndraJala §7`
has explicitly refused the tools Solana uses to get it (no token, no ledger,
no consensus round, no membership). PoH solves this by fiat: one sequential
tape, one clock, one order for everyone. We have a partial order that is
*provably correct wherever it commits* (disjoint charge commutes, by
`obs-agree⋆`) and *silent wherever operations collide*.

The candidates in tree do not close it. `SankramanaSesa §6` says the residual
of a colliding boundary has **no single summary** — which is a reason to
doubt that a canonical total order over conflicts even exists as one object,
rather than a recipe for producing one. Content-addressing (L0) gives a
*deterministic* tiebreak (order by hash), but a hash order is arbitrary with
respect to intended semantics — it is a total order, not the *right* one, and
nothing certifies it against the writers' intent. `GaugeOrbitClasses` detects
the conflict and even constructs the separator (`charge⇒separator⋆`); it does
not order the two sides.

So the open problem is exactly the seam between §2 and §5(1): we have the
Sealevel half as a theorem (disjoint charge commutes) and we lack the PoH
half for the non-disjoint remainder (a cheap agreement-free total order over
conflicts) — and the corpus's own `plurality-blocks-collapse` is evidence
that the missing object may not be a single canonical thing at all. That is
the honest frontier this mapping exposes.
