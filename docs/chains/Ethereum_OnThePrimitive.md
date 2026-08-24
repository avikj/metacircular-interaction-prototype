# Ethereum on the primitive: the Natural Machine already *is* a blockchain, minus the block and minus the chain

*Analysis / design, not integration. No new Agda. Every load-bearing claim
cites a checked term or a named in-tree organ; the one genuinely hard open
problem is marked and its partial in-corpus answers are cited honestly. This
is an understanding exercise about the generality of the compositional
primitive — Carrier + typed edge + e-graph + exchange + content-addressing —
not a proposal to run Ethereum on it.*

The thesis in one line: **Ethereum is a globally-consensused replicated state
machine because an EVM transaction does not carry a proof that it is a valid
state transition; the network has to re-execute it and vote. In this corpus a
state transition carries its own validity witness (`Punaragamana.Carrier`), so
the vote dissolves — a transition either typechecks against the receiver's
kernel or it is refused (`Sphatika … --exchange`). Everything Ethereum builds
to *manufacture agreement about validity* is unnecessary here. What survives,
and is genuinely hard, is agreement about *order* when two individually-valid
transitions touch the same mutable cell.**

---

## 1. The direct-implementation mapping

Each row is a component of Ethereum's architecture and the in-corpus object
that *directly implements it* — not an analogy, an implementation, with the
module named.

| Ethereum primitive | what it is there | Natural Machine object that implements it | module / spec |
|---|---|---|---|
| **account / contract state** | a value at an address in the world-state | a **Carrier point**: `base` (the datum) + `carried` (its claimed image/summary) + `witness : f base ≡ carried` — state that carries the proof it is that state | `punaragamana/src/Punaragamana/Carrier.agda` (`record Carrier`) |
| **a transaction / state transition** | `σ → σ'`, asserted, to be checked by re-execution | a **typed edge** carrying its own preservation witness — a lemma `(lhs,rhs)` with a `Proof` that the kernel checks | L1 edge lattice, `legacy/runtime/CRYSTAL.md` §L1; `K.Lemma`/`K.Proof` in `Sphatika…hs` |
| **EVM execution** | deterministic interpreter over gas-metered opcodes | **checked rewriting** — accepted equalities become rewrites, isos become `transport`; univalence computes so `transport (ua e)` *acts* | CRYSTAL §L3; `Carrier.agda` `carry-transport-descend` (`uaβ`) |
| **a block** | an ordered batch of transactions committed atomically against one prior root | a **batch of edges committed together**: `checkContext` checks the *whole ordered context*, never a lemma alone — a landing re-verifies the entire crystal as one module | `Sphatika…hs` `attempt`/`appendCrystal` → `formal/cubical/Sphatika.agda`; "checks the full context" (file header) |
| **consensus (Proof-of-Stake)** | a protocol to make N replicas agree *which* valid history is canonical | **REPLACED by local re-verification.** The receiver re-judges every incoming edge through *its own* kernel, remapping citations; a false or untranslatable claim costs one refusal. No vote, no quorum, no canonical history. | `Sphatika…hs` `exchange`/`adoptAll`; `docs/ARCHITECTURE.md` §3; `notes/IndraJala…md` §1 |
| **gas** | scalar price bounding execution; miner-ordered by fee | the **cost vector** (L3 keeps nondominated routes — *no scalar fitness*) plus the licence's **cost-non-increase** obligation (`Anujna`: a self-modification is admissible iff it carries a proof its mātrā did not rise) | CRYSTAL §L3; `Nirjara_SheddingAPrimitiveCostsLaghava.agda` |
| **Merkle-Patricia state trie** | hash of state → tamper-evident root; light-client proofs | **content-addressing (L0)**: `addr = hash(elaborated term, dependency addresses, kernel-id)`; identical address ⇒ identical construction, always; names are mutable gauge views | CRYSTAL §L0; `Sangha…md` §1 (`addr(T)` formula); `IndraJala…md` §2 (`canon` + content hash) |
| **zk-rollup** | prove off-chain that a batch of transitions is valid; post only the proof | **the native form here** — the proof *is* the state. A crystal row is already "self-certifying data"; there is no separate execution to prove *about*, the witness rode with the datum from the start | `IndraJala…md` §1; `Carrier.agda` (base+carried+witness = the packet) |

The single sentence under the whole table: in Ethereum the state and the proof
of the state's validity are **separate objects**, and the entire machinery of
blocks, gas auctions, and consensus exists to bind them after the fact. In
`Carrier` they are **one object** — `witness` is a field of the state, the
fibre over the output is contractible so it "rides free" (`fibre-isContr`,
`isContrSingl`), and binding them after the fact is not needed because they
were never apart.

---

## 2. Where the Natural Machine is STRICTLY more general

These are places where Ethereum pays for a structure that the primitive here
simply does not require. Each is a capability *removed*, not added — the
system is more general because it assumes less.

**2.1 No total order is needed for validity.** Ethereum linearizes *all*
transactions into a single chain because its validity check (re-execution)
depends on the exact prior state. Here validity is a *local, context-relative
typecheck*: `checkContext root (Context … crystal lemma)` (`Sphatika…hs`)
succeeds or fails against whatever context the receiver holds. Two nodes with
different histories are not a fork to be resolved into one true chain; they are
two **naya** (standpoints), and `Saptabhangi.agda` types what they should say
where they overlap. A node asserting "my crystal is *the* crystal" is a
**durnaya** — the corpus's own line, promoted to the network's first refusal
(`IndraJala…md` §1; `Sangha…md` §0.2). Ethereum *cannot* express "both
histories stand"; anekāntavāda is native here.

**2.2 No consensus, because no global mutable state.** PoS answers "which of
several *valid* candidate states is canonical." That question only exists
because every full node must converge on one world-state root. The Natural
Machine has no world-state root: each node is the single writer of its *own*
crystal (`IndraJala…md` §3 — "every node is the single writer OF ITS OWN
crystal, which is the only writer there is"). The `--exchange` demonstration
(a fresh node adopting a 200-theorem crystal with zero trust in the sender,
`ARCHITECTURE.md` §3) is a full state sync *without a consensus round*.
Verification asymmetry is the economic ground: checking is one kernel run,
discovery is search, so "Byzantine actors can only donate compute"
(`IndraJala…md` §1). There is nothing to attack by acquiring stake, because
there is no canonical state whose selection stake buys.

**2.3 No oracle for external truth *about the computation*.** Every Ethereum
contract that wants a fact needs a trusted oracle because the EVM cannot
verify claims it did not itself execute. Here the witness travels with the
claim: a Carrier point is checkable by the receiver with no appeal to an
external authority. (This does *not* extend to facts about the physical world —
see §3.4 — but for any claim of the form "this transition is valid" the oracle
is deleted.)

**2.4 The state trie is subsumed, and richer.** A Merkle-Patricia root proves
*inclusion* of a value. L0 content-addressing proves inclusion **and** carries
the dependency closure in the address itself (`hash(term, deps' addrs)`,
`Sangha…md` §1), which is the Unison model — so "the same computation" has one
address across all nodes with no registry, and light-client verification is
just fetching the closure and running the kernel. The trie is a special case
where the only edge kind is `Eq` on opaque bytes; L1 has eleven edge kinds
(`Eq, Iso, Embed, Quotient, Implies, Approx(ε), Refine, Interp, Dual, Order, Conjecture`),
each with its own composition and preservation law (CRYSTAL §L1). Ethereum's
state is proof-*inert* bytes; ours is proof-*relevant* structure, and the
e-graph (L2) even keeps **multiple distinct proof paths between the same two
nodes** because distinct transports act differently — information Ethereum has
no place to store.

**2.5 Gas is a vector, not a scalar, and it is a *proof obligation* rather than
a runtime meter.** Ethereum's gas is a scalar fee bounding a single execution
and setting the miner's ordering incentive. Here cost is (a) a **vector** —
L3 keeps nondominated routes rather than collapsing to one fitness (CRYSTAL
§L3) — and (b) enforced *statically* by the licence: `Anujna` in
`Nirjara_SheddingAPrimitiveCostsLaghava.agda` makes an admissible
self-modification one that *contains, inside itself,* a proof of
cost-non-increase, on a Pāṇinian measure (count the rules that *write* a term,
not the occurrences that *use* it — anuvṛtti is cost-stable). An
over-cost move does not "run out of gas"; it **inhabits no licence** — the
record cannot be constructed. Cost is a type, not a balance.

---

## 3. Where the Natural Machine is genuinely WEAKER or missing something

Honesty about what consensus and the token actually buy, none of which local
verification provides for free.

**3.1 No native token / no built-in economic layer.** Ethereum's ether is
simultaneously the gas unit, the staking asset (its Sybil defense), and a
transferable value. The corpus has *none* of this by design (`IndraJala…md`
§7, `Sangha…md` §6: "no token, no ledger, no consensus round, no membership").
The argument is that value here is verification-asymmetric knowledge and needs
no meter. True — but it means there is no built-in incentive to *supply*
compute or storage to other nodes, and no built-in transferable value. That is
a deliberate absence, not a solved problem.

**3.2 No Sybil resistance.** This is the sharp one. PoS makes identities
*costly* so that "one node one vote" cannot be gamed. The Natural Machine needs
no voting, so it needs no Sybil resistance *for validity* — a thousand fake
nodes cannot make a false theorem typecheck. But Sybil resistance also
underwrites **availability and routing**: `IndraJala…md` §4 grows demand edges
by whether "adopted rules joined anything," and `Sangha…md` §3 routes via the
charge calculus (`GaugeOrbitClasses`) — both are gossip/reputation dynamics
with **no cost to minting identities**, so they are open to eclipse and
flooding attacks that Ethereum's staking closes. The corpus is honest that
gossip/CRDT sets are "neighbors to learn from," not solved (`IndraJala…md` §7).

**3.3 No agreement on ORDER of conflicting writes to shared mutable state.**
See §4 — this is *the* hard problem and it deserves its own section.

**3.4 No physical-world oracle, and the floating-point boundary is unbuilt.**
Ethereum's oracle problem is unsolved too, but Ethereum at least has a
consensus layer onto which oracle schemes (staked reporters, medianizers) can
be bolted. Here there is not even that surface. And `Sangha…md` §5 open problem
3 is explicit: the exact numeric carrier is `Orbit` over ℚ / ℤ[√2]; *measured*
data needs an interval/ball carrier with error as a carried datum, and "that
module does not exist yet… the one place the fitted-constant rule must be faced
head-on." Any real-world data feed lives on the far side of that unbuilt
boundary.

**3.5 No liveness / finality guarantee.** Ethereum guarantees (under its
economic assumptions) that a submitted valid transaction eventually reaches a
final, irreversible state visible to all. The Natural Machine guarantees only
that *if* a node receives an edge *and* it typechecks locally, it is adopted.
There is no global notion of "finalized" and no protocol-level promise that any
particular node ever sees any particular edge — propagation is demand-driven
gossip (`IndraJala…md` §4). Immutability is strong (append/strike-only, values
keyed by content — `Sangha…md` §0.2), but *global visibility* is not
guaranteed the way finality is.

---

## 4. The one genuinely hard open problem: conflicting-write ordering without global consensus

State it precisely, because the reduction from §2 is real but bounded. Local
re-verification dissolves **agreement on validity**. It does *not* dissolve
**agreement on order** in the one case where order is semantically
load-bearing: two individually-valid transitions

    e₁ : σ → σ₁      e₂ : σ → σ₂

both typecheck against the *same* prior state `σ` of a *mutable* cell, and
their effects do not commute (the double-spend: two valid spends of the same
balance). Local verification accepts *both*, because both carry honest
witnesses relative to `σ`. Ethereum resolves this by consensus picking a total
order — exactly one of `e₁`, `e₂` wins, the other is checked against the new
state and rejected. **This is the thing consensus actually buys, and local
verification does not provide it.** No amount of self-certification helps: the
witnesses are not lying; they disagree about which of two futures is real.

Whether this is a *problem* or a *feature* depends on the cell, and the corpus
already draws the line:

- **For immutable / monotone state, the problem does not arise, and this is
  most of the corpus.** Checked terms are immutable values keyed by content;
  strikes are additive; journals append-only; a crystal union is a merge of
  commuting theorems. `Sangha…md` §0.2 states it outright: **"Consensus is
  never needed, because every shared object is already a join-semilattice."**
  A join-semilattice (CRDT) merge is order-independent *by construction* — `e₁`
  and `e₂` both land and their join is the state. No conflict exists because
  the writes commute. The double-spend only bites when someone insists on a
  *non-monotone* cell (a balance that must decrease exactly once).

- **For genuinely conflicting non-commuting writes, the corpus's answer is
  anekānta / avaktavyam, and it is partial.** `Saptabhangi.agda` gives the
  honest verdict lattice seven positions, and the fourth — *avaktavyam*,
  inexpressible — is precisely "both standpoints asserted **simultaneously**
  rather than in succession" (`ARCHITECTURE.md` §1's gloss of the module).
  `IndraJala…md` §1 turns this into the consistency model: "two nodes with
  different crystals are two naya… the network's truth is the colimit nobody
  stores." So the corpus's position is that a conflicting double-spend is a
  **fork that is allowed to stand as a recorded collision** (a `Conjecture`
  edge — `SaptabhangiGarbha`, `Sangha…md` §0.2), and the collision is content,
  not an error to be voted away.

**The honest gap:** anekānta fork-tolerance is the correct answer for a system
whose job is accumulating *truths* (where two truths never conflict, only
two *claims about one mutable slot* do). It is **not** yet an answer for the
case where the application *demands* a single-valued outcome — a currency,
a unique-ownership registry, a nonce. There, "let both forks stand" is not
fork-tolerance, it is the double-spend. The corpus has:

1. the **classification** (a conflict is `avaktavyam`, a simultaneity, not a
   sequential contradiction — `Saptabhangi.agda`),
2. the **detection** (`GaugeOrbitClasses`: a question is a pair of worlds an
   observer cannot separate; a leak/charged query is *exhibitable*, so a
   genuine conflict is detectable, not silent — `charge⇒separator⋆`), and
3. the **merge law for the commuting majority** (join-semilattice, §0.2).

What it does **not** have is a *consensus-free total-order primitive for the
non-commuting minority* — the thing that would let a mutable single-owner cell
resolve `e₁` vs `e₂` without a global vote. That is a real open problem, and it
is open in the literature too: it is provably impossible in the strongest form
(a totally-ordered single-value register with no coordination is exactly what
CRDTs *cannot* give you and what consensus is *defined* to give you). The
corpus's bet is that the demand for such a cell is an artifact — that most
things people put on Ethereum are monotone and only *modeled* as mutable
balances — and that the honest move is to build the join-semilattice layer and
let genuine conflicts stand as typed collisions, reserving a coordination
primitive for the irreducibly-non-commuting residue. Whether that bet holds is
not settled by anything checked in the tree today.

---

## 5. Summary

- **Direct implementation, not analogy:** account state = Carrier point;
  transaction = typed edge with proof; EVM = checked rewriting (L3);
  block = a context checked as a whole; state trie = content-addressing (L0);
  zk-rollup = the native wire format (the proof *is* the state).
- **Consensus dissolves** because validity is self-certified and re-judged
  locally (`Sphatika --exchange`, `Carrier`), removing the total order, the
  vote, and the oracle-for-validity all at once — the deep point being that
  Ethereum needs consensus only because its transitions do **not** carry their
  own validity proof and ours do.
- **Strictly more general:** no total order, no consensus, no validity-oracle,
  a vector gas that is a static proof obligation not a runtime meter, and a
  proof-relevant state that keeps distinct transport paths.
- **Genuinely weaker / missing:** no native token, no Sybil resistance (open to
  eclipse/flood on the routing layer), no liveness/finality guarantee, no
  physical-world oracle, and the exact→measured numeric carrier is unbuilt.
- **The one hard problem:** ordering non-commuting writes to shared mutable
  state without global consensus. The corpus dissolves it for the monotone /
  join-semilattice majority (`Sangha…md` §0.2) and *classifies* the residue as
  `avaktavyam` simultaneity to be recorded, not voted away (`Saptabhangi.agda`,
  `IndraJala…md` §1) — but it has **no** consensus-free total-order primitive
  for a cell that genuinely demands a single-valued outcome, and that absence
  is the honest boundary between "we replaced the blockchain" and "we replaced
  the parts of the blockchain that were never about money."
```
