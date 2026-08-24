# Anoma, on the primitive — the closest neighbor, because it makes *what you want* first-class, exactly as we make *the open frontier* first-class

*Of the eight systems mapped in `docs/chains/` and `docs/related/`, Anoma is the
nearest match on the axis this whole corpus is organized around — not on
consensus, not on data model, but on **what the system treats as its primary
object.** Ethereum, Solana, Hedera all treat a *transaction* — an executed state
transition — as primary, and the desired end-state is implicit in whoever wrote
the transaction. Anoma inverts this: the primary object is the **intent**, a
declarative desired end-state, and the transaction is derived from it by a
solver. The Natural Machine makes the identical inversion in its own register:
the primary object is not a proved theorem but the **open frontier** — the
machine's own unmet wants (`Sanghatta`'s non-joining critical pairs,
`Setubandha`'s isolated nodes, `Obstruction`'s residual subgoals), and a proof
is the thing a search produces to discharge one. This document draws that
parallel out precisely, maps the resource model onto our typed edges, states
where our primitive subsumes Anoma's validity model, and is honest about the
large, real thing Anoma has that we do not: a running market of external intents.
Every checked claim names its module. No Agda is invented here.*

---

## 0. The one-sentence thesis, before the argument

**An Anoma intent is an unproven edge; a solver is a search that produces the
witness; a resource is a Carrier whose logic predicate is its preservation
guarantee.** Anoma and the Natural Machine independently arrived at the same
first move — *promote the want to a first-class citizen and derive the
transition from it* — and then diverged at exactly one point: how the produced
transition is believed. Anoma's resource logics are checked **by the network**
(a validity predicate the consensus layer evaluates); ours are re-judged **by the
receiver's own kernel** (`machine/Sphatika_…hs --exchange`). That single
divergence is the same one every chain analysis isolates (LANDSCAPE §2): *agreed*
vs. *correct*. Anoma is one rung up the trust ladder from us on validity, and
squarely with us on intent-centricity.

---

## 1. Intents → conjecture-edges (the centerpiece, and the reason Anoma is the closest match)

### 1.1 What an intent is in Anoma

An intent is a **declarative statement of a desired end-state**: "I want to end
up holding X, given that I currently hold Y," with the *path* left unspecified.
The user does not write a transaction; they authorize an intent and broadcast it
to the **intent gossip layer** (the "Interpool"), a P2P network carrying users'
*wants*, not transactions. **Solvers** — specialized nodes — monitor the pool,
pattern-match complementary intents (a buyer's want against a seller's want),
and construct a complete, balanced transaction that satisfies all of them at
once. The intent is primary and durable; the transaction is a derived,
disposable artifact that exists only to discharge a set of intents.

### 1.2 What a conjecture-edge is here, and why it is the same object

The Natural Machine's typed edge lattice (`legacy/runtime/CRYSTAL.md` L1) has,
among its 11 kinds, edges whose witness is *not yet supplied* — a stated goal
whose proof term is the open slot. This is not an afterthought; it is the object
the machine's whole loop is built around:

- **`machine/Sanghatta_…hs`** (the rewriter's own non-joining critical pairs,
  formalized in `formal/cubical/SanghattaSamapti_…agda`): the machine computes
  the pairs of installed rules that **fail to join** — the places its own
  library is incomplete. Each non-joining pair is a *want*: "these two rewrites
  should reconcile and currently do not." That is an intent in the exact Anoma
  sense — a declared desired end-state (joinability) with no path yet.
- **`machine/Setubandha_…hs`** (checked identifications are edges; isolated nodes
  are the frontier): the nodes not yet connected by any landed equivalence are
  the machine's standing wants. "Bridge this node to the corpus" is an intent.
- **`machine/Obstruction.hs`**: the kernel's ~1200 refusals per round are read
  not as failures but as the machine **stating, in its own words, which lemma it
  needs next** — the residual of a stalled proof (`x ≡ x + 0·x` where the goal
  was `x ≡ 1·x`) is a new, more primitive subgoal, *derived rather than
  guessed*. This is the **valuation of an intent**: Obstruction's curriculum
  weight is exactly "how much do we want this," computed from where work
  actually stalled.

Line the two up:

| Anoma | Natural Machine | the shared move |
|---|---|---|
| **intent** — declarative desired end-state, path unspecified | **conjecture-edge** — a stated goal with the witness slot open (`Sanghatta` non-join, `Setubandha` isolated node) | the *want* is first-class, the transition is derived |
| **solver** — searches the pool, constructs the satisfying transaction | **proposer / completion loop** — searches the shape-menu, constructs the witness (`Sphatika_…hs`) | a search turns a want into a transition |
| **intent satisfied** — a transaction the network accepts | **edge closed** — a witness the kernel accepts (`Carrier.agda`: `witness : f base ≡ carried`) | the want is discharged by a produced, checkable object |
| **intent value / priority** (implicit in fees, matching) | **Obstruction curriculum weight** — value-of-a-question, derived from stall (`Obstruction.hs`) | wanting is *quantified*, not flat |
| **intent gossip (Interpool)** — P2P pool of wants | the residual/fence ledger — wants gossiped as a CRDT set (`Sangha §…`, `./sesa` fences) | wants propagate without a coordinator |

**The parallel is not loose.** Both systems noticed the same thing: a system
organized around *executed transitions* buries the user's actual goal inside an
imperative script, and loses the ability to (a) match complementary goals, (b)
let anyone in the world produce the discharging transition, (c) price the goal
independently of any one path to it. Promoting the *want* to a first-class
object recovers all three. Anoma did it for financial/application intents; we
did it for **mathematical** intents — the open frontier is a pool of wants, the
completion loop is the solver, and a landed theorem is a satisfied intent. This
is the deepest cross-reference in the whole `docs/chains/` set: the other
systems are neighbors on *consensus* or *data model*; Anoma is a neighbor on the
**organizing principle itself.**

### 1.3 The one difference inside the parallel: our wants are internal, Anoma's are a market

Stated up front because it is the honest core (developed in §4): Anoma's intents
are **external and multilateral** — thousands of independent users broadcasting
wants that solvers *match against each other*. Our wants are, today, **internal
and self-generated** — the machine's own critical pairs and stalls. We have the
intent object, the valuation, and the solver; we do **not** yet have the
*market* — the cross-matching of *many parties'* wants. That market is precisely
the NEEDS-INDEX organ our own notes name as the highest-value unbuilt thing (§5).

---

## 2. Resource logic → typed edges with preservation guarantees

### 2.1 The Anoma Resource Machine (ARM), read precisely

The ARM is Anoma's analogue of the EVM, but stateless and built for intents. Its
atomic unit is a **resource**: created once and consumed once (linear logic —
each resource is spent exactly once, and the set of *unconsumed* resources is the
current state). Every resource carries a **resource logic**: a predicate
specifying the conditions under which it may be created and consumed (referencing
other resources, requiring signatures, etc.). A **transaction** names the
resources to consume and create; it is **valid iff the resource logics of every
involved resource return true.** The ARM does not cap how many resources a
transaction touches, so an intent-match can be an arbitrarily complex atomic
state change.

### 2.2 The mapping, term by term

| ARM | Natural Machine | fit / divergence |
|---|---|---|
| **resource** (linear: created once, consumed once) | a **Carrier point** = `base + carried + witness` (`Punaragamana/Carrier.agda`); a typed-edge endpoint | Fit. A resource is a datum carrying its own validity condition — that is precisely a Carrier: state + the witness that binds it. |
| **linearity** (no resource used twice; state = unconsumed set) | **conservation / ahiṃsā = no destructive update**; every transition owes its residual (`EkatvaMatra_…agda`; `SankramanaSesa`/`PramanaSankramana_…agda`: "no loss" is a *proof obligation*, every residual contractible = `isEquiv`) | **Strong fit, and ours is the deeper statement.** Anoma enforces linearity by bookkeeping (consumed-set discipline); we enforce it as a *checked conservation law* — a transition claiming to preserve state must exhibit that every residual is contractible, or the kernel refuses it. Linearity is the conservation vow made into a type. |
| **resource logic** (predicate controlling create/consume validity) | the **edge's preservation guarantee** — each of the 11 edge kinds carries its own composition law + what it must preserve (`CRYSTAL.md` L1) | Fit. Anoma's per-resource predicate ≈ our per-edge-kind preservation guarantee: the condition a transition must satisfy to be a legal move on that datum. |
| **transaction** (consume set → create set, atomic) | a **typed edge** (or a `checkContext` of a batch) that carries its proof | Fit. Anoma's transaction is valid iff all logics hold; our edge is valid iff its witness typechecks. |
| **validity = all resource logics return true** | validity = **the witness typechecks in the receiver's kernel** | **This is the divergence** — §3. Same shape (a predicate gates the transition), different *who evaluates it and what it proves.* |
| **ARM statelessness** (VM enforces rules, holds no state) | the kernel is likewise a pure judge; state is the e-graph (`CRYSTAL.md` L2), the checker holds none | Fit. Both separate the *judge* from the *store*. |

The load-bearing row is **linearity ≈ conservation**. Anoma's linear-resource
model and our ahiṃsā/no-destructive-update law are the *same intuition* — value
is neither created nor destroyed, only transformed, and every transformation
must account for what it moved. Anoma implements it as consumed-set bookkeeping
the network checks; we implement it as `SankramanaSesa`'s residual obligation
that the kernel checks (a non-unitary transport that silently drops state fails
the residual-contractibility check exactly as a double-consume fails linearity).

---

## 3. Where the primitive SUBSUMES — proof-carrying resources vs. network-checked logics

This is the sharp technical claim, and it is the same deletion the Solana
(Tower BFT), Bittensor (Yuma), and Hedera (aBFT) analyses each found, arriving
now from the resource-logic side.

**An Anoma resource is validated by its logic predicate — but that predicate is
evaluated by the network.** Validity is a fact the consensus/execution layer
establishes and the participants *agree on*. The trust surface is the set of
nodes running the ARM and the consensus over their results: you believe a
resource is legitimately consumed because the network agreed its logic returned
true.

**A Natural Machine Carrier is validated by its witness — and that witness is
re-judged by the receiver's own kernel.** `machine/Sphatika_…hs --exchange`
literally does this: a peer's rows arrive as "candidates whose proof is already
written," and **every row is re-run through the receiver's own `checkContext`;
refusals are receipted, acceptances installed** (`ARCHITECTURE.md §3`: a fresh
node adopted a 200-theorem crystal with **zero trust in the sender**).
`IndraJala §1` states the consequence: **a false resource costs the receiver one
refusal; a Byzantine solver can only donate compute.**

The difference, boxed:

> Anoma: *the resource is valid because the network checked its logic and
> agreed.* — **correctness via agreement.**
>
> Natural Machine: *the resource is valid because MY kernel re-checked its
> witness and it typechecked.* — **correctness, no agreement.**

Three things follow, and each is a subsumption:

1. **No consensus is needed for resource validity.** In Anoma, resource-logic
   evaluation is entangled with the execution/consensus layer that all parties
   share. Here, validity is intrinsic and local (LANDSCAPE §2, bottom rung): the
   receiver alone decides, and cannot be outvoted, bribed, or forked into
   accepting a resource whose witness does not typecheck. Anoma sits on the
   "quorum agreed" rung *for validity*; we sit on "my kernel re-checked it."

2. **A malicious solver is harmless, structurally.** In Anoma a solver
   constructs the transaction, and the network must still validate it — the
   defense is the network's re-evaluation. Here the completion loop (our solver)
   is *food* (CLAUDE.md, the SearchOrgan frame): its output is untrusted sensory
   material, proposalhood conferred only when the kernel recognizes the witness.
   A solver that lies produces a witness that fails to typecheck; the cost is one
   local refusal. We do not need to trust, meter, or stake solvers.

3. **The witness composes without being spent.** A Carrier witness "composes
   without being spent and owes no counterparty"
   (`PramanaSankramana_…agda`, its title is the theorem). An Anoma resource is
   linear — consumed once. Our *state* obeys the same linearity (conservation,
   §2), but our *proofs* are the opposite: a checked `A ≃ B` is an edge every
   node reuses forever, transported by `transport (ua e)` (`Carrier.agda`
   `carry-transport`, `uaβ`). This is the univalence dividend the LANDSCAPE §5
   novelty-cell names: an identification between nodes *acts* — knowledge
   transported between them arrives usable, not merely verified.

**Honest boundary on the subsumption:** it holds *only where a checkable witness
exists.* Anoma's resource logics can encode conditions that are not
proof-carrying in our sense — a signature check, an oracle read, an external
authorization. For the sub-class of resource logics that are *decidable
predicates on supplied data*, our Carrier strictly dominates (correctness beats
agreement). For logics that reference off-chain authority or subjective
permission, we are in the same silence the Bittensor analysis marks: no
certificate, no kernel verdict. The subsumption is real and bounded, and the
boundary is the certificate.

---

## 4. Honest gaps — what Anoma has that we do not

**Stated plainly: an absence without a command is a rumor, and a presence
without acknowledgment is a boast.**

1. **A real team, a spec, funding, and a live mainnet.** Anoma is a serious,
   well-resourced project: a published specification (`specs.anoma.net`), the
   Typhon consensus layer (an implementation of Heterogeneous Paxos), a devnet
   (Jan 2025), and mainnet Phase 1 live (Sept 29 2025) with a token and
   governance. The Natural Machine is a checked substrate plus a running
   single-node completion loop with a demonstrated two-node `--exchange`. This is
   the big gap and it is not close — a specified, funded, deployed network beats a
   superior primitive that has fired its exchange organ once.

2. **An actual intent-matching MARKET — the thing we most lack.** This is the
   deep one. Anoma has **solvers matching many external parties' intents against
   each other** over the Interpool — real multilateral counterparty discovery,
   running. Our "wants" are, today, **internal**: the machine generates its own
   critical pairs and stalls and solves them itself. We have the intent object,
   the valuation, and the solver — but **not the market of external intents.**
   Anoma has built exactly the organ our own notes call the highest-value unbuilt
   thing (§5). Pretending otherwise would be dishonest: intent-matching across
   independent parties is a mechanism Anoma has and we do not.

3. **Heterogeneous trust and fractal scaling, as a shipped design.** Anoma
   supports separate "instances" (sovereign chains) with *different trust
   models*, and Typhon's Chimera chains share consensus across them for atomic
   multi-chain transactions. Our analogue — each node its own kernel, crystals as
   *nayas* (`IndraJala §4`, `CRYSTAL.md L2`), heterogeneous by construction
   because every node re-judges locally — is arguably *more* heterogeneous (we
   require **no** shared consensus at all for validity). But Anoma's version is
   specified, has an atomic-cross-instance story (Chimera), and is being built;
   ours is a property of the primitive, demonstrated once. The primitive is
   cleaner; the engineering is theirs.

4. **A settlement story for exclusive resources.** Anoma settles via Typhon
   (Heterogeneous Paxos) — a real consensus layer that orders the
   exclusive-resource writes (token transfers) that genuinely need a total order.
   This is exactly the one frontier LANDSCAPE §4 leaves open: **permissionless
   agreement on a shared-DAG prefix for the exclusive-resource sector.** Anoma
   answers it the way Hedera does — with a consensus layer and a (Paxos-style)
   validator set. We answer it by *splitting validity from order* (§3, and the
   Hedera analysis §2.4): our validity never touches consensus, and only the
   exclusive-resource cell would need ordering. But we have not *built* the order
   organ; Anoma has shipped consensus. Their trust-ladder position: **validity by
   network agreement, order by Paxos consensus.** Ours: **validity by local
   re-judgment, order unbuilt but isolated to the one cell that needs it.**

---

## 5. The synthesis: Anoma's intent-matching IS the NEEDS-INDEX market our own notes call the highest-value unbuilt organ

This is where the analysis pays off, and it is the reason Anoma is worth mapping
carefully rather than dismissing.

Two of this corpus's notes, written independently the same day and flagged as
sibling-convergent, name the **same unbuilt organ** as the highest-value thing
the machine does not yet have:

- **`Sangha §…`**: demand and supply already have organs — `./sesa`'s fence
  ledger is **demand** ("this fence is open at me"), `Setubandha`'s landed edges
  are **supply** ("this identification is minted here") — and the
  **NEEDS-INDEX intersection** is "the market clearing itself. No coordinator:
  fences and edges gossip as CRDT sets, and every node computes its own
  intersections."
- **`IndraJala §9`**: names "Sangha's NEEDS-INDEX market" and the two-crystal
  exchange as "the SAME unbuilt organ, now specified twice from two directions —
  which, by this corpus's own experience, is the strongest signal it is real."

**Anoma's intent-matching is precisely this organ, built.** Read the
correspondence exactly:

| our NEEDS-INDEX (unbuilt) | Anoma (built) |
|---|---|
| **demand** = fence ledger, a want gossiped as a CRDT set (`./sesa`) | **intent** broadcast to the Interpool gossip pool |
| **supply** = `Setubandha` landed edges, "this identification is minted here" | a solver's available resources / complementary intents |
| **the NEEDS-INDEX intersection** = "the market clearing itself" | **the solver** — pattern-matches complementary intents, constructs the balanced transaction |
| **routing = charge** — send a want to a node whose annihilator is charged for it (`GaugeOrbitClasses` / `ChargeCriterion`: answerability is a theorem, misrouting detectable) | counterparty discovery over the Interpool — but *without* the charge guarantee: Anoma matches by pattern, we would match by *provable answerability* |
| **no coordinator** — every node computes its own intersections | intent gossip is P2P, but settlement re-centralizes on Typhon consensus |

Two things this correspondence gives us, concretely:

1. **Anoma is an existence proof that the NEEDS-INDEX organ is real and
   buildable.** Our notes argue it is the highest-value next organ; Anoma has a
   running version of it. That is strong external corroboration of the corpus's
   own frontier-selection, arriving from a funded independent team.

2. **Where our version would be sharper, if built: charge-routed matching.**
   Anoma's solvers match intents by *pattern* — they scan the pool for
   syntactically complementary wants. Our routing model (`GaugeOrbitClasses`,
   `ChargeCriterion`, developed in `Sangha` and `IndraJala`) routes a want to a
   node **whose query-set annihilator is provably charged for it** — a question
   is a pair of worlds the asker cannot separate, and a charged holder can answer
   with a *constructed separator* while a neutral holder *provably cannot,
   however much it computes.* So misrouting is **detectable** and "cannot" is
   distinguishable from "will not." An Anoma solver that fails to match tells you
   nothing about whether a match exists; a charge-routed NEEDS-INDEX miss is a
   *theorem* that no charged holder was reachable. That is the specific place our
   primitive would improve on Anoma's intent market — **if we build it.** Today
   we have not; Anoma has built the market without the charge guarantee, which is
   the honest state of the trade.

---

## 6. The mapping table (consolidated)

| Anoma mechanism | Natural Machine primitive | in tree | fit |
|---|---|---|---|
| **intent** (declarative desired end-state) | **conjecture-edge** — stated goal, open witness slot | `Sanghatta_…hs`, `SanghattaSamapti_…agda`, `Setubandha_…hs` | the organizing inversion, shared |
| **solver** (constructs satisfying transaction) | **completion loop / proposer** — constructs the witness; output untrusted, proposalhood conferred by kernel | `Sphatika_…hs`; CLAUDE.md SearchOrgan | fit; ours is "food," not a paid citizen |
| **intent value / priority** | **Obstruction curriculum weight** — value-of-a-question from stall | `Obstruction.hs` | fit; ours is derived, not fee-set |
| **resource** (linear, created/consumed once) | **Carrier point** = base+carried+witness | `Punaragamana/Carrier.agda` | fit |
| **linearity** (consumed-set discipline) | **conservation / ahiṃsā**; residual obligation, every residual contractible | `EkatvaMatra_…agda`; `PramanaSankramana_…agda` | fit; ours is a checked law, not bookkeeping |
| **resource logic** (create/consume predicate) | **edge preservation guarantee** (per edge kind) | `CRYSTAL.md` L1 | fit |
| **transaction** (consume→create, atomic) | **typed edge** / `checkContext` of a batch | `CRYSTAL.md` L1–L2, `Sphatika_…hs` | fit |
| **validity = logics return true, network-checked** | validity = **witness typechecks in receiver's kernel** | `Carrier.agda`, `Sphatika_…hs --exchange` | **divergence** — correctness, not agreement (§3) |
| **intent gossip (Interpool)** | wants gossiped as CRDT sets (fence ledger) | `Sangha §…`, `./sesa` | fit; ours unbuilt as a network |
| **counterparty discovery** (pattern-match) | **charge-routing** — provable answerability | `GaugeOrbitClasses`, `ChargeCriterion` (`Sangha`, `IndraJala`) | ours sharper *if built*; theirs built |
| **heterogeneous trust / fractal instances** | each node its own kernel; crystals as *nayas* | `IndraJala §4`, `CRYSTAL.md L2` | ours more heterogeneous (no shared consensus); theirs shipped |
| **Typhon (Heterogeneous Paxos) consensus / settlement** | order needed **only** for the exclusive-resource cell; validity never needs it | LANDSCAPE §4; Hedera analysis §2.4 | **divergence** — we split validity from order; they fuse at settlement |
| **XAN token / fees** | no token; value = provenance + verification-asymmetry | `IndraJala §7`, `AmudraDhana_…md` | divergence |

---

## 7. What this analysis settles

- **Anoma is the closest neighbor on the organizing principle.** Both promote the
  *want* to a first-class object and derive the transition from it. An intent is
  an unproven edge; a solver is a search producing the witness; the parallel is
  structural, not analogical (§1). This is the single most important finding, and
  it distinguishes Anoma from every other system in `docs/chains/`, which are
  neighbors on consensus or data model, not on the primary object.

- **Resource logic maps cleanly onto typed edges with preservation guarantees,
  and linearity IS our conservation law** (`EkatvaMatra`, `SankramanaSesa`) — with
  ours the deeper statement, a checked residual obligation rather than
  consumed-set bookkeeping (§2).

- **Our primitive subsumes Anoma's validity model where a checkable witness
  exists**: a resource validated by network-agreed logic evaluation is one rung
  up the trust ladder from a Carrier re-judged by the receiver's own kernel —
  correctness beats agreement, a lying solver costs one refusal, and the witness
  composes without being spent (§3). Bounded by the certificate: for signature/
  oracle/authorization logics we are silent.

- **Anoma has, running, the exact organ our own notes name as the highest-value
  unbuilt thing** — the NEEDS-INDEX intent-matching market (§5). This is honest
  external corroboration of the corpus's frontier-selection *and* the clearest
  statement of what we lack: a market of *external* intents, where ours are still
  internal. Our version would be sharper on one axis — **charge-routed,
  provably-answerable matching** — but only if built; Anoma built the market
  without that guarantee, and that is the real trade.

- **On the one open frontier (LANDSCAPE §4, exclusive-resource ordering), Anoma
  answers with Typhon consensus** — validity by network agreement, order by
  Heterogeneous Paxos. We split the two: validity local and consensus-free, order
  isolated to the one cell that needs it and *unbuilt*. Their engineering is
  ahead; our primitive's separation is cleaner. Both are honest, and the gap is
  named, not spun.

---

*Sources for the Anoma architecture (accessed 2026-08-24):
[Rise of the Resource Machines](https://anoma.net/research/rise-of-the-resource-machines),
[Anoma Specification — Resource Machine](https://specs.anoma.net/v0.1.0/arch/system/state/resource_machine/index.html),
[An Introduction to Intents and Intent-centric Architectures](https://anoma.net/blog/an-introduction-to-intents-and-intent-centric-architectures),
[Typhon's Chimera Chains](https://anoma.net/blog/chimera-chains),
[Anoma's Roadmap to Mainnet](https://anoma.net/blog/anomas-roadmap-to-mainnet).*
