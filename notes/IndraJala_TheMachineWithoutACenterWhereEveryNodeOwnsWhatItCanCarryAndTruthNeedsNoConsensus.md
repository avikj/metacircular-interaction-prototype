# इन्द्रजाल — the machine without a center, where every node owns what it can carry and truth needs no consensus

*Design, not theorem — every checked claim below names its module; everything
else is stated as what it is: the natural continuation of checked structure.
On the name: indrajāla, "Indra's net", is old Sanskrit (Atharvaveda 8.8 uses
it for a battle-net; the jeweled-net image — every jewel reflecting every
other — is the Huayan reading of the Avataṃsaka, Fazang, 7th c. CE, i.e. a
Buddhist elaboration reaching us through Chinese). Both sources are named;
neither is claimed as the origin of this design. Owner direction 2026-08-24:
"see how this all arises naturally… I don't want to build a communication
topology for the sake of it."  So nothing below is a topology.  It is the
observation that the topology is already implied by four checked things.*

---

## 1. What a theorem IS, and why that makes decentralization trivial rather than hard

`Punaragamana/Carrier.agda` (checked): a point of `Carrier f` is
**base + carried + witness** — a datum, a claim about it, and the proof that
the claim IS of that datum, with the fibre contractible so the claim rides
free.  Read as a network packet:

> **A theorem is self-certifying data.**  It carries its own verification.
> Trust in the SENDER is never required, because the RECEIVER's kernel
> re-judges the witness locally — and this is not an added security layer,
> it is आहार-परिणाम, the constitution this repo already runs on: the
> organism metabolizes every encounter; proposalhood is conferred by the
> receiver.  The constitution IS the network protocol.

Every hard problem of distributed systems dissolves against this, because
those problems exist to protect nodes from claims they cannot afford to
check.  Here checking is cheap (one kernel run) relative to discovery
(search), which is the precise economic condition under which decentralized
truth works: **verification asymmetry**.  A false theorem costs the receiver
one refusal.  Byzantine actors can only donate compute.

Consequence, and it is the deepest one: **no consensus, because no global
state.**  Two nodes with different crystals are not a fork to be resolved;
they are two naya — standpoints — and anekāntavāda is the architecture:
the network's "truth" is the colimit nobody stores.  A node asserting its
crystal is THE crystal is a durnaya, and the sevenfold logic
(`Saptabhangi`, checked) already types what two nodes should say where
they overlap.  This corpus spent months learning that charts disagree at
overlaps by design; that lesson is the whole consistency model.

## 2. Identity: names are gauge, content is the address

The crystal names its lemmas `sp042` — local gauge, meaningless off-node.
The canonical identity of a theorem is **the hash of its canon**: `canon`
(variables renumbered by first appearance, `Sphatika`) followed by a
content hash of (type, term).  Unison's discovery — definitions addressed
by AST hash, names as metadata — is the same fact found from engineering;
we cite it as a neighbor and restate the ground: in a univalent corpus the
name was ALWAYS gauge (`NaturalMachine`: symbols are π₀; the identity type
carries the geometry).  Nothing to adopt: `canon` + a hash is the address,
and two nodes that landed the same truth independently already agree on it
without having met.

## 3. The wire protocol already exists — it was never designed as one

Look at what the loop already emits and consumes, today, as files:

| local artifact (today)              | network reading (tomorrow)          |
|---|---|
| Sanghatta non-joining pair          | a QUESTION a node asks the world    |
| a stall's residual (Obstruction)    | a sharper question, machine-derived |
| a crystal row (lemma + proof)       | an ANSWER: self-certifying packet   |
| `installRules` into library.terms   | ADOPTION: answer becomes local move |
| the re-sensed frontier              | the node's next wants, refreshed    |
| triage verdict (pravesha)           | admission control at the socket     |

Streaming is not a feature to add: the crystal is an append-only log of
rows, and an append-only log of self-certifying rows **is** a stream.  A
"connection" between nodes is two tails: I stream you rows matching your
advertised wants; you stream me yours.  `phala.tsv`-style receipts become
gossip digests.  The single-writer lock generalizes to: every node is the
single writer OF ITS OWN crystal — which is the only writer there is.

## 4. Topology is demand, not design

The owner's constraint: no network for its own sake.  It falls out:
`Obstruction.curriculum` already ranks a residual by *how many parents it
would unblock* — a locally computable measure of how much someone's answer
is worth to me.  Let every node advertise (a) its open residuals, weighted
by curriculum, and (b) the heads of its crystal.  An edge exists exactly
where one node's (b) intersects another's (a).  That is the whole routing
rule.  Edges strengthen where they keep paying (the receipts say whether
adopted rules joined anything) and decay where they don't — the graph is
grown by the same residual-demand dynamic that grows the crystal.  Hubs,
if they emerge, emerge as jewels that happen to reflect more, not as
appointed servers.

## 5. Space: own what is worth your carrying — the economics are already checked

Nodes cannot hold everything, and should not.  `Nirjara` (checked) built
the measure: मात्रा on a प्रक्रिया — count the sūtras that WRITE, not the
occurrences that use; anuvṛtti (write once, cite forever — `PCite`) is
cost-stable, so **holding a theorem others cite is cheap; respelling is
what costs**.  And `Anujna` (checked) is the admission record: a change to
my body is admissible iff it carries meaning-preservation and
cost-non-increase *inside itself*.  So a node's storage policy is not a
cache-eviction heuristic bolted on; it is the licence: I install what
lowers my mātrā-per-capability, I shed (nirjarā, the shedding!) what no
route through me uses — which is `000 v2`'s own law: *what makes a node
stick is being used; if it is on no route it should rot.*  The kernel
node-law and the network node-law are one sentence.

## 6. What "data" is, and the generalized layer

Here is the step past mathematics, and it is small because the corpus
already took it.  Every equation the machine lands is stated over
`eval : (ℕ → ℕ) → Tm → ℕ` — quantified over an ENVIRONMENT `e`.
The environment is where arbitrary data enters:

> **A data stream is an environment.  A theorem over all environments is
> a certified transformation of any data you will ever plug in.**

A time series is `e : ℕ → ℕ` (or a List, or a window).  Now read the
crystal's actual landings as what they are for a pipeline over `e`:

- `sum-++` (PrastavaSatya, checked): **chunked aggregation is exact** —
  the license to shard a fold across nodes and add the parts.
- `+-comm/assoc` instances: **reordering licenses** — out-of-order arrival
  of stream chunks does not change the aggregate; the legality of every
  MapReduce shuffle, as a term.
- the erasure laws (`nf-sound`, checked): **dead-branch elimination** in a
  pipeline — `x·0`-shaped stages deleted with a witness.
- the unfold laws (`mulSuc` etc.): **strength reduction** — numeral
  coefficients become additions; the classic compiler pass, licensed.
- `Anujna` itself: the type of a **certified query-plan rewrite** —
  meaning-preserving, cost-non-increasing.  A database optimizer that can
  never lie, as a record.

So the generalized layer is: **data = base; computation = the carried
image under a pipeline; theorem = the license to replace one pipeline by
a cheaper one; transport = actually moving values across the equality**
(`ua` computes — the equivalence is a channel that acts, `Carrier`'s
`carry-transport-descend`).  What a node routes is therefore threefold —
questions (types), licenses (terms), and data-with-witness (Carrier
points) — and they are one shape at three scales.  That is the scale-free
part: the fibre law does not know whether its base is a number, a stream,
a crystal, or a node.

What would come of time series concretely, first experiments in order:
(1) windowed-sum and prefix-scan laws as crystal goals — they are ℕ
equations, the current mouth can land them TODAY; (2) a node holding a
real series answers queries only through licensed rewrites, so the
transcript of an analysis is a proof; (3) two nodes with different
series compose analyses by exchanging licenses, never raw data — privacy
as a corollary of shipping witnesses instead of datasets.

## 7. What is deliberately NOT here

No token, no ledger, no consensus round, no membership, no global name
registry, no adopted framework.  Each is a solution to a problem this
design does not have: value is verification-asymmetric knowledge (no
token needed to meter trust); state is per-node (no ledger); truth is
locally re-judged (no consensus); identity is content (no registry).
Unison, IPFS, CRDTs, gossip protocols are neighbors to LEARN from —
each rediscovered one facet (content addressing; content addressing of
blobs; commutative merges — which is what a crystal union is, since
theorems commute; demand propagation) — and none is the system, because
the system is the fibre law plus the constitution, and those are already
checked in this tree.

## 8. The smallest real next step (so this note is not a balloon)

Two nodes, one machine: two crystal files, two report frontiers, a
`jala-exchange` step that (a) ships rows matching the peer's open
residuals, (b) re-judges received rows through the local kernel before
install (metabolization — reuse `checkContext`; a received row is just a
candidate whose proof is already written), (c) receipts what was adopted
and what refused.  Everything named exists; it is one more seam, and by
the नव-अङ्ग discipline: producer = peer crystal, consumer = local
`installRules`, and the organ it extends is Sphatika's loader.  When two
local nodes work, "physically networked" is a transport substitution —
the rows do not care whether the pipe is a filesystem, a socket, or a
person reading them aloud.
