# Constellation on the primitive — the closest structural match, and exactly what we add

*One of a small set of orientation notes reading an existing chain's
architecture against the Natural Machine's one primitive (the fibre law,
`punaragamana/src/Punaragamana/Carrier.agda`). The claim of this note is
narrow and specific: **of Ethereum, Solana, and Constellation, Constellation
is the closest structural match to what this repository already runs** —
because Constellation is a DAG rather than a chain, and this machine is a DAG
(a proof-relevant e-graph, `legacy/runtime/CRYSTAL.md` L2). The mapping below
is not an analogy hunt; where a row says "→" it names the in-tree object that
already does the job. Nothing here proposes to build a network layer for its
own sake — that stance is `notes/IndraJala_…md` §0 and it governs here.*

*Not Agda. This is a reading of checked terms, not a new one. Every module
named is cited so the reader can open it; no theorem is invented.*

---

## 0. Why Constellation and not Ethereum/Solana

Ethereum and Solana are **chains**: a single totally-ordered ledger, one
global state advanced by consensus, validation = "does this transaction apply
to the one agreed state." The structural mismatch with this machine is total —
the machine has *no global state* (`notes/IndraJala_…md` §1: "no consensus,
because no global state"), two nodes with different crystals are two *naya*
(standpoints), not a fork to resolve, and there is nothing to totally order.

Constellation (Hypergraph / HGTP) is a **DAG of state channels**: validation
is *layered and local to a channel*, there is no single chain, and application-
specific channels settle asynchronously to a shared base layer. That is the
same shape this repository already runs:

- the machine's memory is a **DAG of typed edges** — a proof-relevant e-graph
  with a Nieuwenhuis–Oliveras proof forest, directed edges that never merge
  classes, multiple distinct paths kept (`legacy/runtime/CRYSTAL.md` L2);
- validation is **local re-check** — a peer's rows are re-judged through the
  receiver's own kernel, no sender trust (`machine/Sphatika_…hs`, the
  `--exchange` organ; `docs/ARCHITECTURE.md` §3);
- there is no authoritative store and, deliberately, no consensus mechanism
  (`docs/WHAT_THIS_IS.md` property 2).

So the comparison is worth making precisely because it is *close*: on the
other two chains almost every row of the table below would read "no analogue."
Here they read "nearly the same object."

---

## 1. The mapping — HGTP → e-graph + exchange is the load-bearing row

| Constellation mechanism | Natural Machine object | in-tree citation |
|---|---|---|
| **HGTP** — a DAG of state channels, feeless, validation layered per channel | **the proof-relevant e-graph (a DAG of typed edges) + the exchange (local re-verification)**. This is nearly the same object: a DAG whose edges are validated locally, no global chain, no fee because *checking is the cost and it is the receiver's* | `legacy/runtime/CRYSTAL.md` L2; `machine/Sphatika_…hs` `exchange`; `docs/ARCHITECTURE.md` §3 |
| **Global L0 / metagraph L1** — application channels with their own validation settling to a shared L0 | **content-addressed identity (our L0) / per-node crystals settling by exchange**. A node is the single writer of its own crystal; it settles to peers by shipping self-certifying rows | `legacy/runtime/CRYSTAL.md` L0; `notes/IndraJala_…md` §2–3; `machine/Sphatika_…hs` (single-writer lock, `appendCrystal`) |
| **Metagraphs** — custom state channels, own token/validation/data | **per-node crystals / sub-corpora, each a *naya* owning what it judges worth its space** (धारणा) | `notes/Sangha_…md` §2 ("a node = a naya"); `notes/IndraJala_…md` §5 |
| **Proof-of-reputation / validator scoring** | **"what makes a node stick is being used"** (routes decay if nothing crosses them) + **routing-by-charge**: a node advertises its annihilator; questions route to charged holders | `notes/IndraJala_…md` §4; `notes/Sangha_…md` §3; `formal/cubical/NaturalMachine/GaugeOrbitClasses.agda`; `…/ChargeCriterion.agda` |
| **Data-as-first-class** — validates arbitrary data feeds, not only token transfers | **the Carrier form generalizes past mathematics**: any datum ships as `base + carried + witness`; an eval-environment IS a data stream | `punaragamana/src/Punaragamana/Carrier.agda`; `notes/IndraJala_…md` §6; `notes/Sangha_…md` §4–5 |

### The load-bearing row, expanded: HGTP ≈ e-graph + exchange

Constellation's HGTP is a DAG where a piece of state is validated by the
channel it lives in, and channels compose without a global sequencer. Read the
machine's two organs together and you have the same primitive:

- **The DAG** is `CRYSTAL.md` L2: union-find + congruence closure over
  hash-consed terms, *plus a proof forest* — every union stores its
  justification and can emit a checkable path. Directed edges (`Quotient`,
  `Refine`, `Approx`) live in a separate DAG and never merge classes. This is
  the "hypergraph" object: nodes, typed directed edges, multiple paths kept as
  content.

- **The layered/local validation** is the exchange (`machine/Sphatika_…hs`,
  `exchange` / `adoptAll`): a peer offers rows; the receiver re-judges *every
  row through its own kernel* (`checkContext`), remapping citations name-by-
  name as their targets are adopted (peers cite only earlier rows, so one
  ordered pass suffices); a refused row costs one receipt and is skipped.
  `docs/ARCHITECTURE.md` §3 records the demonstration: a fresh node adopted a
  200-theorem crystal with zero trust in the sender.

Constellation makes validation cheap-and-local by *layering* (an L1 channel
validates its own state, L0 only settles). The machine makes it cheap-and-
local by *verification asymmetry* (`notes/IndraJala_…md` §1): checking is one
kernel run, discovery is search, so the receiver can always afford to re-judge
and never has to trust. Same effect — local validation, no global authority —
reached from two different guarantees.

---

## 2. Where the primitive SUBSUMES Constellation

Constellation is the closest match, and the machine is strictly more than it in
two specific, checkable ways.

### 2.1 Typed edges — 11 kinds, each with a preservation guarantee

Constellation's DAG edges are essentially **single-kind**: an edge is "this
state references / follows from that state," untyped as to what it *preserves*.
The machine's L1 (`legacy/runtime/CRYSTAL.md` §"L1 — typed edges") is an
**edge lattice of 11 kinds** — `Eq, Iso, Embed, Quotient, Implies, Approx(ε),
Refine, Interp, Dual, Order⟨≤⟩, Conjecture` — each carrying *its own
composition law and its own preservation guarantee*. This is not decoration;
the table encodes hard facts a single edge kind cannot:

- **`Iso` does not preserve `sign`** — Galois conjugation
  $a+b\sqrt2 \mapsto a-b\sqrt2$ is a field isomorphism of $\mathbb Q(\sqrt2)$
  that exchanges its two orderings, so `(Iso ; Order)` is *not licensed*.
- **No path through a `Quotient` delivers parity** — the machine's parity-
  blindness stated in its own type system.
- **`Conjecture` composes with nothing and preserves nothing** — a guide-only
  edge that can never enter an accepted derivation.

A single-kind DAG cannot say any of this: it cannot distinguish "these two
states are equal" from "this state approximates that one to ε" from "this one
is merely conjectured to relate." The machine routes over a **cost vector**,
keeping nondominated paths (`CRYSTAL.md` L3), precisely because the edges carry
different preservation semantics. Constellation's settlement has one notion of
"valid"; the machine has eleven, and the difference is what lets a route *know
what it is allowed to carry across itself*.

### 2.2 Proof-carrying — local kernel re-check, not consensus-among-validators

Constellation validates by **consensus among validators** (a reputation-
weighted set of nodes agrees a state is valid). The machine validates by
**local kernel re-check**: the receiver runs the Agda kernel on the witness the
datum carries with it. The datum is self-certifying — `Carrier` = `base +
carried + witness`, with the fibre `singl (f a)` contractible so the witness
rides free (`punaragamana/src/Punaragamana/Carrier.agda`, `Σ-law`,
`Carrier≃`). This removes the validator-trust assumption entirely:

- Constellation: *I believe this state because enough reputable validators
  signed it.* Trust is in the validator set; a corrupted quorum corrupts the
  state.
- Machine: *I believe this theorem because my own kernel just re-derived its
  witness.* Trust is in nothing but the receiver's kernel — `no candidate may
  rewrite the kernel that judges it` (`docs/ARCHITECTURE.md` §6). A false
  theorem costs the receiver one refusal; "Byzantine actors can only donate
  compute" (`notes/IndraJala_…md` §1).

That is the subsumption: Constellation's reputation/consensus layer is a
*substitute* for local re-verification, needed exactly because its data is not
proof-carrying. Make the data proof-carrying and the consensus layer becomes
unnecessary — not improved, *unnecessary*. The proof-of-reputation mechanism
maps onto the machine only as the *soft* residual signal ("a node that keeps
paying — whose adopted rows keep joining pairs — strengthens its edges,"
`notes/IndraJala_…md` §4), never as the ground of truth.

### 2.3 A note on the L0/L1 naming coincidence — same word, different cut

Both systems say "L0/L1," and it is worth being exact that they **do not name
the same layers**, so the coincidence is not evidence of a match (the real
match is §1, HGTP ≈ e-graph+exchange):

- **Constellation** L0 = the shared global settlement layer; L1 = the
  application metagraph channels above it. The number grows *upward toward the
  application*.
- **`CRYSTAL.md`** L0 = content-addressed identity (hash of elaborated term +
  dependency addresses); L1 = the typed edge lattice; L2 = the proof-relevant
  e-graph; L3 = execution; L4 = consequence propagation. The number grows
  *upward from identity toward execution*.

Where they genuinely coincide: **Constellation's Global L0 (the thing every
channel settles to) and our L0 (content-addressed identity that every node
agrees on without having met) play the same role** — the shared floor that
needs no coordination because it is determined by content. `canon` + a hash is
the address, and "two nodes that landed the same truth independently already
agree on it without having met" (`notes/IndraJala_…md` §2), which is exactly
what a settlement L0 is *for*. Above that floor the numbering diverges: their
L1 is application channels, our L1 is edge *types*. Same instinct (a
content-determined floor, application-specific structure above), different
slicing.

---

## 3. Honest gaps — what Constellation has that this repository does not

This is the half of the comparison the machine must not flatter itself past.

- **A live network.** Constellation has a deployed, running mainnet with real
  nodes. The machine has run the exchange organ exactly **once** (a fresh node
  adopting a 200-theorem crystal, `docs/ARCHITECTURE.md` §3, "BUILT, fired
  once"). Two-nodes-one-machine is specified (`notes/IndraJala_…md` §8) and not
  yet standing. There is no gossip layer, no transport substrate, no running
  second node.

- **Tokenomics / an incentive layer.** Constellation has a token (\$DAG), a fee/
  reward economy, and a proof-of-reputation staking mechanism that pays nodes.
  The machine has *deliberately no token, no ledger, no consensus round*
  (`notes/IndraJala_…md` §7) — which is a design stance, not an implemented
  incentive system. "Value is verification-asymmetric knowledge" is an argument
  that a token is *unnecessary*; it is not a mechanism that makes nodes show
  up, stay online, or spend compute on others' questions. The routing-by-
  demand dynamic (`notes/IndraJala_…md` §4, `Sangha_…md` §3) is designed, not
  wired, and the "market clearing itself" (the NEEDS-INDEX intersection) is
  named as the highest-value *unbuilt* organ.

- **Actual deployed metagraphs.** Constellation has real application state
  channels validating real data feeds in production. The machine's "per-node
  crystals as metagraphs" is one running crystal (the completion loop) plus a
  design for many. The data-stream generalization (§1 last row) is argued from
  checked terms — eval-environments as data, causal-state quotients with priced
  memory (`Sangha_…md` §5) — but the interval/ball carrier that real measured
  data needs *does not exist yet* (`Sangha_…md` §5, open design problem 3), and
  it is the honest boundary between this layer and floating point.

- **A working incentive layer / operational maturity generally.** Beyond
  tokenomics: Constellation has the ordinary machinery of a live system —
  peer discovery, membership, liveness, the things `notes/IndraJala_…md` §7
  lists as "deliberately not here." Calling them absent-by-design is honest
  about the *stance*; it does not make the machine a running network.

The trade is legible: the machine buys **trustlessness without consensus**
(proof-carrying data + local re-check) and **typed transport** (the 11-kind
edge lattice) at the cost of **not being live**. Constellation buys **a
running, incentivized, deployed network** at the cost of **validator-trust
consensus** and **single-kind untyped edges**. The machine's claim is that its
primitive *subsumes the architecture*; it is not the claim that it subsumes the
deployment.

---

## 4. One-line summary

Constellation is the closest of the three because it is already a DAG with
layered local validation — HGTP is nearly our e-graph + exchange. On top of
that shared primitive the machine adds two things Constellation does not have:
**typed edges** (11 kinds, each with a proven preservation guarantee, vs.
single-kind untyped DAG edges) and the **proof-carrying property** (validation
by the receiver's own kernel re-check, which makes consensus-among-validators
unnecessary rather than better). What Constellation has and the machine does
not is everything about being *alive*: a live network, a token and incentive
layer, and deployed metagraphs validating real data.
