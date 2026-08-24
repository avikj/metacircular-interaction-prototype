# Hedera Hashgraph, on the primitive

*The hard problem the other chain-analyses raise — ordering conflicting writes
to shared mutable state without a global authority — has, in Hashgraph, a
constructive answer: **fair deterministic ordering from a shared DAG is
possible**. This document takes that answer seriously, maps Hashgraph's
mechanisms onto the Natural Machine's fibre primitive, and then does the one
thing the mapping forces: decides, sharply and honestly, WHEN a total order is
the right move and when forcing one is a proven error (`Saptabhangi.दुर्नयः`).
Every checked claim names its module. Nothing external is adopted as a system;
Hashgraph is read as a neighbor that solved one sector and centralized the
rest. No Agda is invented here.*

---

## 0. The one-sentence result, stated before the argument

Hashgraph proves that a **total order** over a distributed event-DAG can be
computed by every node **locally and identically**, with no vote messages, by
replaying shared history through a deterministic function. That capability is
real and our primitive can express it — it is a pure deterministic fold over a
content-addressed DAG, and content-addressed DAGs are the substrate
(`legacy/runtime/CRYSTAL.md` L0/L2). **The question is never "can we order",
it is "should we".** And the answer the corpus already holds:

- **Financial / exclusive-resource state (double-spend):** a total order is
  genuinely needed, because the two conflicting writes contend for **one cell
  whose invariant forbids both surviving**. Order here is instrumental to a
  conservation law (ahiṃsā = conservation, `EkatvaMatra`), not fundamental.
  Virtual voting is exactly the right way to get it — decentralized, no
  council.
- **Independent knowledge claims (the corpus default):** two individually
  valid, conflicting transitions are **not** a fork to be resolved. They are
  two *naya*. Forcing them into a sequence is the `krama`/`saha` collapse that
  `Saptabhangi.क्रम-सह-भेदः` proves is a category error, and a two-valued
  "which came first" verdict on a genuine simultaneity is
  `Saptabhangi.दुर्नयः`, mechanically. Hold the fork (partial order,
  anekānta).

**The application decides, and it decides by exactly one question: do the
conflicting writes target shared mutable state whose invariant admits only
one?** If yes, order (and only as much order as the invariant forces). If no,
hold the fork.

---

## 1. Virtual voting — the centerpiece

### 1.1 What Hashgraph actually does

Two mechanisms, read precisely:

- **Gossip-about-gossip.** Nodes gossip *events*, and each event records the
  two parents it was built from — the last event of the creator and the last
  event received from the peer it just synced with. So every event carries the
  **history of who told whom**. The set of events is therefore not a bag; it is
  a **hash-linked DAG**, and syncing propagates not just payloads but the DAG
  structure itself. Every honest node converges to (a growing prefix of) the
  **same** DAG.

- **Virtual voting.** To reach consensus on the order of events, nodes do
  **not** send votes. Each node, holding the shared DAG, **replays** it and
  computes — as a pure function of the DAG — which events are "witnesses",
  which witnesses are "famous" (by a deterministic see/strongly-see
  relation over the graph), a "round received" for every event, and a median
  of the timestamps at which honest nodes first received it. Sorting by
  (round received, median timestamp, deterministic tie-break) yields a **total
  order**. Because the function is deterministic and the DAG is shared, **every
  node computes the same order without exchanging a single vote message**. The
  votes are *virtual*: they are what a node WOULD have said, calculated from
  the shared record rather than transmitted.

The content, distilled: **a total order is a deterministic fold over a shared
content-history DAG.** That is the whole trick, and it is representable in our
primitive without any new machinery.

### 1.2 The two ingredients, both already ours

Virtual voting needs exactly two things, and the Natural Machine has both:

**(a) A shared content-addressed DAG with provenance riding on every node.**
This is `legacy/runtime/CRYSTAL.md` L0 (address = hash of the elaborated term
*and its dependency addresses*) and L2 (the proof-relevant e-graph: a DAG of
transitions where **multiple distinct paths between the same nodes are kept**,
justifications stored per union). Gossip-about-gossip's "each event names its
parents" **is** L0's "each address hashes in its dependency addresses". The
exchange organ already ships rows this way: in
`machine/Sphatika_…hs`, a peer row's proof `PCite n` names an *earlier* row,
so a peer file is an ordered citation-DAG, and `adoptAll`'s `nameMap` remaps
those citations name-by-name as their targets are adopted (the DAG structure
travels and is preserved, not just the payloads). Provenance-carrying rows +
DAG structure = gossip-about-gossip, already built.

**(b) A deterministic function from the shared DAG to a verdict, computed
identically at every node.** This is `canon` (`machine/Sphatika_…hs`:
variables renumbered by first appearance) followed by a content hash — the
address function of `IndraJala §2`. Its defining property is exactly virtual
voting's defining property: **two nodes that landed the same object
independently agree on its identity without having met.** A pure deterministic
function of shared content, giving the same answer everywhere, no messages
exchanged — that is virtual voting's determinism, already the corpus's identity
law.

So: **can our primitive do virtual voting?** Yes. Define a pure order function
`O : DAG → TotalOrder` computed locally by every node over the shared
content-addressed transition-DAG. Determinism + shared history give every node
the same order with zero vote traffic. Nothing in the substrate resists this;
it is a fold over L2 with a `canon`-based tie-break.

### 1.3 Why this does NOT contradict Pratyabhijna (the subtle, load-bearing point)

`NaturalMachine/Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries.agda`
(checked) proves `network-no-decision`: if every validator is blind on a pair
`x y`, then `¬ Separates (pool oss) x y` — and `Separates` quantifies over
**every** reading of the pooled transcript, so no consensus rule whatsoever
(majority, stake, committees, appeals) recovers a difference none of the
members can see. `sees-exactly` sharpens it: the assembly sees **precisely**
the kernel of the pooled-transcript map — the union of its members' queries and
nothing more. `Sangati §1` states the consequence: *decentralization buys fault
tolerance and availability; it does not buy resolution.*

This looks like it forbids virtual voting. It does not, and the reason is the
crux:

> **Virtual voting does not manufacture a new distinction. It orders events
> that are ALREADY in the shared DAG.**

Pratyabhijna is about **resolution** — separating two worlds that no member can
read. Ordering is not resolution of a blindness; it is a deterministic function
of what is **already visible**. Virtual voting works *because* the order is a
fold over the shared visible DAG, never an attempt to see what is invisible.
The two results are complementary, and together they are the exact statement of
what consensus can and cannot do here:

- **Consensus cannot buy sight** (Pratyabhijna / Sangati §1): what all nodes
  are blind on stays hidden, forever, under any protocol.
- **Consensus CAN buy a shared deterministic order over what everyone already
  sees** (Hashgraph): and that is all a double-spend resolution ever needs.

The double-spend case is orderable precisely because **both conflicting spends
are visible in the DAG.** No one is blind on them. The only question is which
wins, and that is a deterministic fold, not a hidden-distinction problem. This
is the honest reconciliation, and it is the reason the financial sector is
tractable while the blindness sector (`Pratyabhijna`) is provably not.

---

## 2. Total order vs. avaktavya — the decision, made honestly

### 2.1 The corpus's default is to hold the fork, and it is a theorem why

`Saptabhangi.agda` (checked) proves `क्रम-सह-भेदः`:
`¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)` — asserting both predicates
**sequentially** (`krama`) is a genuinely different position from asserting them
**simultaneously** (`saha`, yugapad), which breaks into `स्यात्-अवक्तव्यम्`, the
irreducible fourth koṭi. And `दुर्नयः` proves any two-valued map
`f : सप्तभङ्गी → द्विपद` must, by pigeonhole on the three seeds
(asti/nāsti/avaktavya), **collapse two distinct positions**.

Read at the network: **two individually valid, mutually referencing
transitions that arrived without a determined order are a `saha` (simultaneous)
assertion.** To *force* a total order onto them is to insist they were really
`krama` (sequential) all along — which `क्रम-सह-भेदः` says is a different,
non-equal object. A router or ledger that emits a two-valued "A before B"
verdict on a genuine simultaneity is `दुर्नयः` compiled — it discards the
`avaktavya` distinction, which for knowledge claims is exactly the automorphism
/ standpoint content the corpus spent months proving is the payload
(`IndraJala §1`: two crystals are two naya, not a fork; `Sangati §2`: the
second sector's fibre is `fiber f b`, non-contractible, *because the
automorphisms live there*).

So for **independent knowledge state** — theorems, nayas, the crystal's default
— forcing a fair order is the wrong move. There is no shared mutable cell; both
claims are locally re-judged and both survive; the honest structure is a
**partial order** (the citation-DAG itself) with forks held open. `Sangati §2`:
the network's job here is **transport, not voting** — a checked `A ≃ B` is an
edge every node uses forever, and computation is routing along it, not electing
one history.

### 2.2 Where a total order IS forced, and by what

Financial double-spend is categorically different, and the difference is not a
preference — it is the presence of a **conservation invariant on shared mutable
state**:

- Two spends of the same coin are **not** two coexisting nayas. They contend
  for **one cell** (a balance, a UTXO) whose invariant — *no value is created
  or destroyed* — **admits at most one**. This is `ahiṃsā = conservation`
  (`EkatvaMatra`, and the growth laws' "no destructive update"): letting both
  survive violates the conservation law, exactly the way a non-unitary
  transport violates `SankramanaSesa`'s residual obligation.
- Here the collision is a **distinction the task-family declares must be
  resolved** — precisely `legacy/runtime/CRYSTAL.md §3.2` distinction
  compilation: *"which states must receive different answers."* Double-spend
  declares that the two post-states are different-and-exclusive. The collision
  is a specification of a required separation, not an `avaktavya` to hold.

So a total order is genuinely needed — and Hashgraph proves it can be had
**without a coordinator**. Virtual voting over the shared DAG is the correct,
decentralized realization: every node folds the shared transition-history to
the same order, exactly one spend wins, no council decides it.

### 2.3 The synthesis: order is instrumental, impose the coarsest that discharges the task

The sharp rule, and it dissolves the apparent tension between Hashgraph and
Saptabhangi:

> **Impose the coarsest structure that discharges the declared invariant, and
> no more** — the partition-refinement discipline of
> `legacy/runtime/CRYSTAL.md §3.2` and the minimal-separating-channel of
> distinction compilation, applied to *order itself*.

A total order is the **maximally fine** ordering structure. You pay for it only
where a conservation invariant on shared mutable state demands it (the double
-spend cell). Everywhere else you keep the **partial order** the DAG already is,
and hold the forks (`avaktavya`). Even the financial total order is not
fundamental: it exists **to preserve a conservation law**, so it is downstream
of ahiṃsā, not a first principle. The order is a means; conservation is the end.
This is why forcing a global total order on *everything* (Hashgraph's actual
design — it fair-orders the entire event stream) is over-imposition from our
standpoint: it pays the ordering cost, and commits the `दुर्नयः`, on sectors
that never needed it.

### 2.4 Validity vs. order — the split Hashgraph fuses and we keep apart

This is where our primitive is strictly sharper than aBFT:

- **Hashgraph needs aBFT for BOTH validity and order**, because a transaction's
  admissibility and its position both depend on agreement about the shared DAG.
- **Our validity needs no BFT, ever.** A transition **carries its proof** and
  is **re-judged locally** by the receiver's kernel (`ARCHITECTURE §3`, the
  exchange organ: *"verification is local, so authority is unnecessary"*;
  `machine/Sphatika_…hs` `exchange`/`adoptAll` re-runs `checkContext` on every
  peer row, adopting or receipting a refusal — a false claim costs one
  refusal). No quorum decides whether a theorem is true; the kernel does, at
  every node, independently.

So we **split the two things Hashgraph welds together**: validity is
self-certifying and never touches consensus; order is needed **only** for the
exclusive-shared-state sector, and only there does anything resembling aBFT
enter. Hashgraph pays Byzantine agreement on the whole stream; we pay it (if at
all) only on the double-spend cell. That is a strictly smaller trusted-order
surface.

---

## 3. The mapping table

| Hashgraph mechanism | Natural Machine primitive | Fit / divergence |
|---|---|---|
| **Event** (payload + 2 parent hashes) | L0 content address = hash(term, **dependency addresses**) (`CRYSTAL.md` L0); a crystal row + its `PCite` parents (`Sphatika_…hs`) | Exact. "Names its parents" = "hashes in its deps." |
| **Gossip-about-gossip** (history of who-told-whom rides on every event) | Provenance-carrying rows + the L2 transition-DAG; `adoptAll`'s `nameMap` preserves the citation-DAG across a peer sync (`Sphatika_…hs` `exchange`) | Fit. Our sync ships the DAG structure, not just payloads. |
| **The hashgraph** (shared convergent DAG) | L2 proof-relevant e-graph: DAG of transitions, **distinct paths kept** (`CRYSTAL.md` L2) | Fit, and richer: we deliberately keep multiple paths (automorphisms are content); Hashgraph collapses to one order. |
| **Virtual voting** (deterministic fold of shared DAG → total order, no vote messages) | A pure `O : DAG → Order` over the content-addressed DAG; determinism = `canon`+hash identity law (`IndraJala §2`) | **Representable but unbuilt.** The substrate supports it; no order-fold organ exists yet. |
| **Famous witnesses / see / strongly-see** | Would be the concrete definition of `O` — a deterministic graph predicate over L2 | Not built; nothing blocks it. |
| **Median-timestamp fairness** | Fairness matters only once order is needed; where we hold the fork it is vacuous | Applies only in the exclusive-resource sector. |
| **aBFT** (agreement on validity AND order) | Validity: **no BFT** — proofs re-judged locally (`ARCHITECTURE §3`, `exchange`). Order: BFT-like agreement needed **only** for exclusive shared cells | We split what Hashgraph fuses; strictly smaller order-trust surface. |
| **Fair total order over all events** | Total order **only** where a conservation invariant on shared mutable state forces it (`EkatvaMatra`, `CRYSTAL.md §3.2`); else partial order + held forks | **Divergence, principled.** Global total order over everything is `दुर्नयः` on the knowledge sector (`Saptabhangi`). |
| **hbar / fee metering** | No token: value is verification-asymmetric knowledge; a false claim costs the receiver one refusal (`IndraJala §7`, `Sangati §3` — edges are the scarce thing, not hashes) | Divergence. Proof-of-transport, not proof-of-stake. |
| **Governing Council** (permissioned, ~named enterprises) | No membership, no authoritative store, no office (`IndraJala §7`, `Sangha §0`, `§6`) | **Divergence, constitutional.** See §4. |

---

## 4. Honest gaps — what Hedera has that we do not, and what we refuse

**Stated plainly, because an absence without a command is a rumor and a
presence without acknowledgment is a boast.**

What Hedera **has** and the Natural Machine does not:

1. **A live aBFT network in production.** Hedera runs a public mainnet with
   real throughput and real finality under real Byzantine conditions. The
   Natural Machine has: an autonomous completion loop (built, running,
   `Sphatika_…hs`), and an exchange organ **fired once** (`ARCHITECTURE §3`: a
   fresh node adopted a 200-theorem crystal with zero trust in the sender).
   "Two nodes, one machine" is specified (`IndraJala §8`) and not yet
   networked. We have the primitive and one demonstration; Hedera has a
   running network. This is a real gap, not a toolchain detail.

2. **A built virtual-voting order function.** §1 shows our substrate can
   *express* virtual voting; it does not claim one is *written*. There is no
   `O : DAG → Order` organ. What exists is the content-addressed DAG, the
   deterministic identity law, and the exchange loader — the ingredients, not
   the dish. Building `O` is a concrete next step and only matters in the
   exclusive-resource sector (§2).

3. **Patents.** Swirlds/Hedera hold patents on gossip-about-gossip and virtual
   voting. Note the irony flatly: a **patent on a consensus method is the
   enclosure of a technique** — precisely the choke-point capture that
   `WHAT_THIS_IS.md §2` names the design as built against ("no ownable choke
   point — deliberately"). The mechanism is elegant; the enclosure of it is the
   thing our primitive's self-certifying, locally-re-judged edges make
   structurally impossible to impose (you cannot toll a check the receiver runs
   themselves).

What Hedera has that we **refuse**:

4. **The Governing Council — a centralization we reject, named as such.**
   Hedera's aBFT is achieved partly through **known, permissioned membership**:
   consensus nodes are operated by a fixed council of named enterprises, and
   the security argument leans on that known validator set. **Known membership
   is exactly what the Natural Machine's design refuses** (`IndraJala §7`: no
   membership, no global registry; `Sangha §0`: *"one authoritative store is
   one KMS state — whatever its consensus cannot see, nothing downstream ever
   sees"*, Theorem F applied to the store; `Sangha §6`: *"where it remains, no
   one rules"*). A council is a unique-equilibrium governance layer, and Theorem
   F says a unique equilibrium annihilates every charged sector. So Hedera buys
   its clean aBFT with a centralization at the governance layer that our
   constitution treats as the failure mode, not the foundation.

   The honest trade is symmetric and worth stating without spin: **Hedera's
   permissioned council is what lets it give a hard, live, total-order finality
   guarantee today.** Our permissionless, council-free design gives up that
   turnkey global finality — and in exchange keeps the choke-point-free property
   and pays ordering cost only where an invariant forces it. Where a genuine
   global-exclusive resource must be ordered among mutually distrusting,
   *unknown* parties, closing that gap without reintroducing a council is the
   one genuinely open problem this analysis leaves standing (it is `Sangha`'s
   open design problem 1, the compressed-annihilator advertisement, wearing a
   different hat: how a permissionless set agrees on a shared DAG prefix without
   known membership).

---

## 5. What this analysis settles

- **Fair deterministic ordering from a shared DAG is possible** (Hashgraph
  proves it) and **representable in our primitive** (a deterministic fold over
  the content-addressed L2 DAG; the identity law already gives the
  determinism). It is unbuilt but unobstructed.
- **It is consistent with `Pratyabhijna`** because ordering folds what is
  already visible; it never tries to resolve a blindness. Consensus cannot buy
  sight; it can buy a shared order over what everyone sees.
- **A total order is the right move only for shared mutable state with an
  exclusivity invariant** (double-spend), where it is instrumental to
  conservation (ahiṃsā). There, virtual voting is the correct decentralized
  realization — no council required in principle.
- **For independent knowledge claims it is a proven error** to force one:
  `Saptabhangi.क्रम-सह-भेदः` makes simultaneity irreducible to sequence, and a
  two-valued ordering verdict on it is `दुर्नयः`. Hold the fork; transport,
  don't vote (`Sangati §2`).
- **The application decides**, by exactly one question — is the write to shared
  mutable state whose invariant admits only one? — and the machine's discipline
  is to **impose the coarsest structure that invariant forces, and no more.**
- Hedera's live network, built virtual-voting function, and patents are real
  things we lack or refuse; its council is a centralization our constitution
  identifies as the failure mode. The one honest open problem: permissionless
  agreement on a shared DAG prefix for the exclusive-resource sector, without
  reintroducing known membership.
