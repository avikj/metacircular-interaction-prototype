# Prior art: decentralized / agent-centric / content-addressed systems

*A neighbor-survey, not a genealogy. This repository's network primitive is
not designed — it falls out of four checked things (see
`notes/IndraJala_TheMachineWithoutACenterWhereEveryNodeOwnsWhatItCanCarryAndTruthNeedsNoConsensus.md`
and `notes/Sangha_TheMachineWithoutAnAuthoritativeRepoIsAlreadyImplicitInTheCheckedTerms.md`).
Every system below independently discovered ONE facet of it from the
engineering side. None has the whole shape, and the reason is a single
distinction stated at the end: they verify **integrity** (a datum is
unchanged); the Carrier + local kernel verifies **validity** (a datum is
correct). Status current as of August 2026 where checked by web search.*

The facets of our primitive, so the table's column 3 has referents:

- **L0 content-addressing** — identity = hash of the elaborated term + its
  dependency addresses; names are gauge/mutable views
  (`legacy/runtime/CRYSTAL.md` §L0; `Sphatika` `canon` + content hash).
- **exchange / no-consensus validation** — a peer's rows are re-judged
  through the *receiver's* kernel; no trust in the sender, no global state
  (`--exchange` mode, `docs/ARCHITECTURE.md` §3).
- **agent-centric state / nayas** — two nodes with different crystals are not
  a fork but two standpoints; disagreement-at-overlap is the consistency
  model, typed by `formal/cubical/Saptabhangi.agda` (anekāntavāda).
- **capability / custody** — a node holds what it can carry and is licensed
  to; a self-modification must carry its own meaning-preservation + cost proof
  (`formal/cubical/NaturalMachine/Nirjara_…`, the `Anujna` licence record).
- **local-first / sovereignty** — verification is local, so there is no
  authoritative store and no ownable choke point
  (`docs/WHAT_THIS_IS.md` property 2).

---

## The table

| project | what it is | the facet it independently found | where THEY are ahead | where our primitive generalizes |
|---|---|---|---|---|
| **Holochain** | agent-centric app framework; each agent keeps a signed source-chain, validated to a sharded DHT, *no global consensus* | **exchange + agent-centric state**: local validation rules ("DNA physics"), per-agent chains, disagreement not a fork — the closest philosophical match | live network + hApps, real validation-DHT, membrane/warrant tooling, years of deployment | DHT validation checks *signatures and app-defined rules* (integrity + policy). It cannot express "this datum is a theorem and here is its machine-checked proof." Our witness is a kernel-checked term, not a validation callback. |
| **IPFS / IPLD / Filecoin** | content-addressed block store + typed linked-data (IPLD) + storage-incentive chain (Filecoin) | **L0 content-addressing** of arbitrary blobs; Merkle-DAG identity; names (IPNS) as mutable views | planetary deployment, CIDs are an industry standard, Filecoin gives a real storage-incentive layer we lack | a CID proves the bytes are unchanged. It says nothing about whether the bytes are *true*. We content-address an *elaborated term with its proof*, so the address certifies validity, not just integrity. |
| **Unison** | content-addressed *code*: definitions named by hash of their AST, names are metadata | **L0 exactly** — already cited in-tree (`IndraJala` §2) as the same fact found from engineering; no dependency hell, trivial code caching | shipping language + Unison Cloud; codebase manager, typed distributed abilities | Unison hashes *typed terms* (closest of all) but the hash certifies definitional identity, not a *theorem about* the term. Our Carrier is base+carried+**witness**; univalence makes the name-is-gauge fact a consequence, not a design choice. |
| **Ceramic / ComposeDB** | decentralized event-stream protocol; user accounts sign data events organized into content-addressed streams | **L0 + agent-centric**: signed append-only event logs, content-addressed, per-account authority | live mainnet, GraphQL data models, composable schemas, real dApp usage | streams verify signature + ordering (integrity/provenance). No notion of a stream event *carrying a correctness proof re-judged by the reader*. |
| **Secure Scuttlebutt (SSB)** | offline-first gossip social protocol; each identity an append-only signed feed | **local-first + agent-centric**: sovereign per-feed logs, gossip replication, no server | genuinely offline-first, human-scale deployed community, elegant feed model | verifies feed integrity (hash-chain + sig) only; content correctness is entirely out of scope. |
| **Bluesky / AT Protocol** | federated social; Personal Data Servers hold signed repos, content-addressed records, portable DIDs | **local-first + L0**: account-owned repos, content-addressed records, identity portability | ~41M users (2025), real federation, thousands of independent PDSs, live account portability | account portability is data-integrity + identity, not validity. No correctness re-judgment. |
| **DFINITY / Internet Computer** | "world computer" — canister smart contracts under chain-key crypto; Caffeine (2025) writes apps from prompts | **exchange-adjacent**: tamper-evident replicated compute, receiver-verifiable via chain-key sigs | live network, real replicated execution, chain-key signatures, AI app-gen (Caffeine) | replicated *consensus* is exactly what we don't need or want; chain-key proves a canister ran, not that its result is mathematically correct. We replace consensus with local re-judgment. |
| **Spritely Goblins / OCapN** | distributed object-capability programming (CapTP, promise pipelining) over Tor/libp2p/TCP | **capability / custody**: unforgeable references, authority = possession, no ambient authority — the sharpest capability model here | working impl, OCapN cross-vendor standardization (Agoric, MetaMask, Sandstorm), time-travel debugging | ocaps govern *who may invoke what* (authority). Our `Anujna` licence governs *whether a transformation is meaning-preserving and cost-non-increasing* — a correctness capability, carried inside the term, not an access grant. |
| **Agoric** | Hardened-JS smart-contract chain built on object-capabilities (SwingSet, ERTP) | **capability / custody** in an economic setting | live Cosmos chain, deployed ocap economic contracts | same ceiling as Goblins: ocaps + consensus. Value comes from a ledger; ours comes from verification-asymmetry (a false theorem costs the receiver one refusal). |
| **Ink & Switch (local-first) / Automerge / Keyhive** | the research program that named "local-first"; Automerge CRDT; Keyhive = local-first capabilities + e2e encryption | **local-first + capability**: sovereignty as a design principle; Keyhive delegates document control by public key | the canonical statement of local-first; shipping CRDT libs; Keyhive/Subduction access control; GAIOS (ARIA Safeguarded AI) | CRDT merges guarantee *convergence* (all replicas reach the same state), never *correctness* of that state. Our crystal-union is a CRDT-like merge whose elements are theorems — commutative *because* they're kernel-checked, not merged blindly. |
| **CRDT research (Yjs, Automerge)** | conflict-free replicated data types; commutative merges reach one state without coordination | **agent-centric merge**: our crystal union is a monotone join of self-certifying rows | mature, deployed in real editors; formal convergence proofs | convergence ≠ validity; see above. |
| **Dat / Hypercore (Holepunch/Pear, Keet)** | signed append-only logs (hypercores) + P2P swarm; now the Pear runtime | **L0 + local-first**: content-addressed append-only logs, sovereign keys | live P2P apps (Keet), holepunching stack, real swarm | log integrity only. |
| **Radicle** | P2P, censorship-resistant code collaboration on Git; "sovereign forge" | **local-first**: Git objects are already content-addressed; sovereignty over repo + workflow | actively shipping (1.2.0, 2025), real p2p code collaboration replacing GitHub dependence | Git hashes verify integrity of history, never correctness of code. Nearest analogy to what we do to *proofs* — but for source blobs. |
| **Urbit** | personal-server OS with content-addressed frozen kernel (Nock/Hoon), deterministic computation | **L0 + agent-centric**: deterministic, content-defined computation; personal sovereign node | running network (scaled down 2025, Tlon Messenger the live use) | determinism gives reproducibility, not verified correctness; no proof-carrying layer. |
| **Nym** | decentralized mixnet for metadata privacy (NymVPN, 2025) | **custody-adjacent**: privacy as a property of shipping the right thing (mixed packets) | real deployed mixnet + VPN, incentive layer | orthogonal — transport privacy. We get privacy as a *corollary* (ship witnesses/licences, not datasets — `IndraJala` §6) rather than as the mechanism. |
| **Bacalhau (Expanso) / compute-over-data** | run compute jobs where the data lives; verifiable-ish distributed jobs | **exchange-adjacent**: move computation to data, minimize movement | deployed, award-winning, real ops adoption | job results are trusted from the executor (or re-run for determinism); no proof carried. Our `eval`-over-environment landings are *certified transformations of any data plugged in*. |
| **EQTY Lab "Verifiable Compute" / VET / LOKA (2025 arXiv)** | silicon-rooted attestation of AI lineage; verifiable execution traces; DID/VC agent identity | **exchange-adjacent**: receiver-verifiable claims about a computation's provenance | closest of the *AI-agent* cohort to "carry your own evidence"; hardware trust roots, DID/VC standards momentum | attestation proves *what ran on what hardware/data* (provenance), not that the *output is correct*. Trust is rooted in silicon/issuer; ours is rooted in the receiver's kernel re-checking a proof term. |
| **Proof-carrying data / recursive SNARKs / zk (IVC, Nova, Brevis ProverNet)** | recursively-composable succinct proofs that a distributed computation was performed correctly | **validity itself** — the ONE cohort that verifies correctness in a decentralized setting | mature crypto, succinct/constant-size proofs, on-chain verifiability, a real prover market (ProverNet 2025) | **flagged for the other survey agents.** This is the true sibling on the correctness axis. Differences to draw there: zk proves *a fixed statement/circuit was satisfied* (and hides the witness); our kernel checks an *open-ended dependently-typed theorem* whose witness is the content and is meant to be *read and reused*, not hidden. zk optimizes succinct verification of a known claim; we optimize composable, self-extending, human-readable mathematical knowledge. |

---

## The ~10 you should know, ranked by structural relevance

1. **Holochain** — the closest *philosophy*: agent-centric, no global
   consensus, validity as local app-defined "physics." Treat as the sibling
   that got the topology right and the *what-is-validated* wrong (rules/sigs,
   not proofs). Everything in `IndraJala` §1 ("no consensus because no global
   state") is Holochain's thesis, arrived at here from the fibre law instead
   of from DHT engineering.
2. **Unison** — the closest *mechanism* on L0: content-addressed typed terms,
   names as metadata. Already our cited neighbor. The gap is witness-carrying.
3. **Proof-carrying data / recursive SNARKs (IVC, Nova, PCD)** — the closest
   on the *correctness axis*, and the only cohort that verifies validity in a
   decentralized setting. **Belongs to the zk/PCD survey**; named here so the
   axis is honest.
4. **Spritely Goblins / OCapN** — the closest *capability* model; the right
   frame for custody/`Anujna`, but authority-capabilities, not
   correctness-capabilities.
5. **Ink & Switch / Automerge / Keyhive** — the canonical *local-first*
   statement + the CRDT convergence result our crystal-union generalizes
   (convergence → validity).
6. **IPFS / IPLD** — the reference implementation of content-addressing at
   scale; the integrity-not-validity distinction is cleanest against a CID.
7. **AT Protocol / Bluesky** — the largest live proof that account-owned,
   content-addressed, portable data works at tens of millions of users;
   integrity + identity, no validity.
8. **DFINITY / Internet Computer** — the "world computer" foil: it buys
   tamper-evidence with *consensus*, the exact thing our primitive shows is
   unnecessary when verification is local and cheap.
9. **Ceramic / ComposeDB** — signed content-addressed *event streams*; the
   append-only-log-is-a-stream reading in `IndraJala` §3 is Ceramic's model,
   minus the proof.
10. **Radicle** — P2P Git; the sharpest everyday demonstration that
    content-addressed history + sovereignty replaces a central forge — for
    *source*, where we do it for *proofs*.

Runners-up worth a look: **Secure Scuttlebutt** (offline-first feeds),
**Dat/Hypercore/Pear** (signed append-only logs, live P2P apps), **Agoric**
(ocaps + economics), **Bacalhau** (compute-over-data — our `eval`-over-
environment landings are its certified cousin), **EQTY/VET/LOKA** (the
AI-agent provenance cohort, 2025 — attestation, not correctness), **Nym**
(mixnet; privacy as corollary), **Urbit** (deterministic sovereign node).

---

## The single deepest distinction: integrity vs. correctness

Nearly every system above verifies **integrity**: a hash (CID, Git object,
hypercore, source-chain entry, Unison AST hash, signed Ceramic event) proves a
datum is **byte-for-byte unchanged** since some producer signed it. That is a
proof about *history*, not about *content*. To trust the content you must
still trust the producer, or trust a consensus of producers, or re-run a
deterministic computation and trust the determinism.

Our primitive verifies **correctness**. `Punaragamana/Carrier.agda`: a packet
is **base + carried + witness** — a datum, a claim about it, and a term that
*is* the proof the claim holds of the datum, with the fibre contractible so
the claim rides free. The receiver's own Agda kernel re-elaborates the witness
(`--safe`, no postulates, no holes). A false packet does not need a majority to
reject it and does not depend on trusting the sender — it simply **fails to
typecheck locally** and costs the receiver one refusal
(`docs/ARCHITECTURE.md` §3; verification-asymmetry, `IndraJala` §1).

So the axis splits cleanly:

- **Integrity, trust the producer** — Holochain, IPFS, Unison, SSB, AT Proto,
  Ceramic, Dat, Radicle, Urbit. (Unison is the nearest: it hashes *typed*
  terms — but the hash is identity, not a theorem *about* the term.)
- **Correctness by consensus / replication** — DFINITY, Agoric, and every
  blockchain: correctness is whatever the majority executed.
- **Correctness by proof, decentralized** — **only** the PCD / recursive-SNARK
  / zk cohort, and us. The difference within this last box (flagged for the
  zk-survey agents): zk verifies that *a fixed circuit was satisfied* and
  *hides* the witness; we verify an *open-ended dependently-typed theorem*
  whose witness *is* the shared content and is meant to be re-read, cited, and
  extended — knowledge that composes and self-grows (the crystal), not a
  succinct receipt of a settled claim.

The one thing none of the mainstream decentralized systems have: a
transition or datum that **carries its own machine-checked validity proof,
re-judged by a kernel the receiver controls.** Content-addressing verifies the
datum did not change; the Carrier verifies the datum is true.

*Modules referenced: `punaragamana/src/Punaragamana/Carrier.agda` (base +
carried + witness); `formal/cubical/Saptabhangi.agda` (disagreement-at-overlap
is typed, not a fork); `formal/cubical/NaturalMachine/Nirjara_…` (`Anujna`
licence = correctness-capability); `Sphatika` `canon` + content hash (L0);
`docs/ARCHITECTURE.md` §3 (exchange); the two design notes `IndraJala` and
`Sangha`.*
