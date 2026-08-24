# The Landscape: where this sits, and what it generalizes

*Synthesis of the eight analyses in `docs/chains/` and `docs/related/`.
Each claim there cites a checked module; this document is the map, not
the territory. The one-line thesis: **the systems people are building —
blockchains, DAG ledgers, AI markets, vector databases, proving networks
— are each a special case of one compositional primitive, distinguished
by what they accept in place of a proof.***

---

## 1. The primitive, restated once

- **Carrier** = base + carried + witness: self-certifying data
  (`Punaragamana/Carrier.agda`).
- **Typed edge** = a state transition that carries its own proof; 11
  kinds, each with its own composition law and preservation guarantee
  (`legacy/runtime/CRYSTAL.md` L1).
- **E-graph** = the state store: a DAG of edges, multiple paths kept
  (L2).
- **Exchange** = adopt a peer's transitions by re-judging each through
  your own kernel — no sender trust, no consensus
  (`machine/Sphatika_….hs --exchange`).
- **Content-addressing** = identity is the hash of the elaborated term
  plus its dependency addresses (L0).
- **Charge** = what an observer learns is exactly the coset of its
  annihilator; disjoint charge ⇒ commuting/parallel; this is the
  visibility, routing, AND concurrency model at once
  (`GaugeOrbitClasses.agda`).

## 2. The one axis that orders the whole field

Every system studied has to answer: **when a node receives a datum or a
state transition, why should it believe it?** There are exactly four
answers in the wild, and they form a ladder of decreasing trust:

| answer | who gives it | what it proves | trust surface |
|---|---|---|---|
| "the hash matches" | IPFS, Unison, Holochain, Ceramic, Git, SSB | the datum is **unchanged** (integrity) | the producer |
| "a quorum voted" | Ethereum, Solana, DFINITY, Hedera, most chains | the datum is **agreed** (consensus) | the validator set / council |
| "a market scored it" | Bittensor | the datum is **popular among stakers** | opinion aggregation (collusion, weight-copy) |
| "my kernel re-checked it" | **this primitive**, PCC, zk/PCD | the datum is **correct** (validity) | **nobody** |

The primitive lives on the bottom rung with proof-carrying code and the
zk/PCD cohort — the only place where belief requires trusting no one.
Within that rung it is distinguished again (§5).

## 3. Every system is a special case — the mapping in one table

| their thing | our thing | note |
|---|---|---|
| account/contract state (ETH/SOL) | Carrier point | state + witness, one object |
| transaction | typed edge + proof | validity is intrinsic, not voted |
| EVM execution | checked rewriting / transport | `transport (ua e)` |
| block | `checkContext` of a batch | the whole context judged at once |
| PoS / Tower BFT / aBFT consensus | **local re-verification** | consensus *dissolves* for validity |
| gas | cost **vector** + `Anujna` cost-non-increase | static obligation, not runtime meter |
| Merkle-Patricia trie | content-addressing (L0) | hash of term + deps |
| zk-rollup | **native** | the proof *is* the state |
| Proof of History (SOL) | sequenced transport-with-residual | order becomes a theorem (`SankramanaSesa`) |
| Sealevel parallelism (SOL) | disjoint-charge edges | provably commute (`GaugeOrbitClasses`) |
| HGTP DAG (Constellation) | the e-graph + exchange | nearly the same object |
| gossip-about-gossip (Hedera) | provenance rows + L2 DAG | citation-preserving |
| virtual voting (Hedera) | deterministic fold over shared DAG | representable, unbuilt, unobstructed |
| subnet (Bittensor) | per-node crystal / naya | self-derived frontier |
| Yuma subjective scoring | **the kernel** | stake is not an input to typechecking |
| TAO incentive | provenance + verification-asymmetry | sell the mining, not the mine |
| vector embedding | `Approx(ε)` edge **that forgot its ε** | net proposes, kernel bounds |
| cosine similarity | typed `Approx(ε)` edge | ε composes by adding |
| RAG retrieval | charge-routing | class membership, not proximity |

## 4. The one genuine frontier, resolved and narrowed

All five chain analyses independently hit the **same** hard problem:
ordering two individually-valid, non-commuting writes to shared mutable
state (double-spend) without global consensus. The synthesis across
Hedera + Saptabhaṅgī + Sangha resolves it into a decision rather than a
wall:

1. **Validity never needs consensus** — proofs are re-judged locally, so
   Byzantine actors can only donate compute. This eliminates the *large*
   part of what consensus was doing.
2. **Most state needs no order at all** — monotone / join-semilattice
   state converges by merge (CRDT-style; `Sangha` §0.2). The crystal
   union is exactly this.
3. **Independent claims must NOT be ordered** — forcing a sequence on
   genuinely simultaneous standpoints is a *proven* error
   (`Saptabhaṅgī`: simultaneity is irreducible; "which first" is a
   durnaya). They coexist as nayas; the collision is recorded, typed.
4. **Only exclusive-resource writes need a total order** — and Hedera's
   virtual voting shows that order is a deterministic fold over a shared
   content-DAG, representable in our primitive (canon + hash gives the
   same-answer-everywhere function). Order is instrumental to
   conservation there, not fundamental.

So the residue is one line, honestly open: **permissionless agreement on
a shared-DAG prefix for the exclusive-resource sector, without
reintroducing known membership.** Every studied system either solves
this by giving up permissionlessness (Hedera's council, PoS validator
sets) or by giving up nothing and having no exclusive-resource sector
(pure knowledge/CRDT systems). Whether the fibre law affords a
permissionless answer here is the open research question the whole
exercise isolates.

## 5. Novelty, verified honestly

Every *piece* is prior art, and it has a strong home community:
- Proof-carrying validity → PCC (Necula), zk/PCD.
- Content-addressed identity → Unison, IPFS.
- Agent-centric no-consensus → Holochain.
- Proof-relevant e-graph + library learning → egg, egglog, babble.
- Autonomous proving → AlphaProof.
- Bounded approximation → interval methods; vector AI is this *without*
  the bound.

Several pairwise unions exist. A targeted search for the **three-way**
cell — self-improvement + proof-carrying + decentralization — returned
**empty**. Two legs have essentially no precedent even in combination:
**computing univalence as the exchange medium** (needs a cubical kernel
no proving network uses — it makes identifications *act*, so knowledge
transported between nodes arrives usable, not merely verified) and
**kernel-gated self-modification via a licence that inhabits a type**
(the Gödel machine stated this as a goal; `Nirjara`'s `Anujna` is a
built type for it, under the absolute "no candidate rewrites its judging
kernel").

The contribution is the **join**, and the join is the thesis. Where each
leg is individually behind — AlphaProof-class generation, PCD
succinctness, mathlib scale, every deployed network's incentives and
speed — is stated in the per-system documents so the novelty of the
combination is never mistaken for superiority of the parts.

## 6. What the map is for

Two readers. For the **researcher**: this is the honest placement — what
is ancestral, what is genuinely new, and the single open problem the
combination isolates. For the **builder/investor**: the systems on the
top three rungs of §2 are collectively worth hundreds of billions and
each accepts something weaker than a proof; this primitive is the
bottom-rung generalization of all of them, running, with a resolved
account of the one frontier that stops it from being a drop-in
replacement for the exclusive-resource (money) sector — and a design for
that too. The place to point diligence is here, then the five open
problems in `docs/RESULTS.md` §4.
