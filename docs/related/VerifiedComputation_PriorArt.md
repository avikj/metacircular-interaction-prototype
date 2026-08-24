# Verified Computation — Prior Art and Novelty of Synthesis

*A prior-art survey of the verified-computation / proof-carrying /
proof-market / automated-reasoning research most related to the Natural
Machine. For each field: what it is, which piece of our system it
corresponds to, where they are ahead, and what our primitive adds. Then
the four closest ancestors with precise deltas, then an honest test of the
central claim — that each **piece** is individually known and strong, but
the **synthesis** appears to be novel.*

Our system, in one line, so the correspondences below are exact: a
**self-improving, proof-carrying, content-addressed, decentralized,
univalent** machine whose growth is itself kernel-gated. Its organs:

- **Carrier + kernel** — self-certifying data (base + carried + witness),
  `punaragamana/src/Punaragamana/Carrier.agda`; trusted heart is the Agda
  `--cubical --safe` kernel (`docs/ARCHITECTURE.md` §1, §6).
- **The compounding crystal** — an autonomous prove→install→sense loop
  where each landed theorem is in scope for all later proofs and the rule
  library feeds its own frontier
  (`machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheorem…​.hs`,
  `docs/RESULTS.md` §2).
- **L2 proof-relevant e-graph** — union-find + congruence closure +
  Nieuwenhuis–Oliveras proof forest, distinct paths kept
  (`legacy/runtime/CRYSTAL.md` §L2).
- **L1 typed edge lattice** — 11 edge kinds, each with its own composition
  law and preservation guarantee (`legacy/runtime/CRYSTAL.md` §L1).
- **The exchange** — re-judge a peer's crystal through your own kernel,
  zero sender trust (`docs/ARCHITECTURE.md` §3).
- **Computing univalence** — `ua`'s β-rule reduces, so an identification
  *acts* as an executable transport (`docs/ARCHITECTURE.md` §1).
- **The licence** — lawful self-modification carries its own
  meaning-preservation + cost-non-increase proof inside the change
  (`formal/cubical/NaturalMachine/Nirjara_SheddingAPrimitiveCostsLaghava.agda`).

---

## The survey table

| Project / field | What it is | Our corresponding piece | Where they are ahead | What our primitive adds |
|---|---|---|---|---|
| **Proof-Carrying Code** (Necula & Lee, 1996–98) | Code ships with a machine-checkable proof it obeys a safety policy; the host checks, does not trust the producer. | **Carrier + kernel, exactly** — data ships base + carried datum + witness; the receiver checks locally. Closest ancestor. | Deployed in real systems (Touchstone/SpecialJ, typed assembly); decades of engineering on proof size and VCGen. | Proofs are not about a *fixed policy* — they are the mathematics itself; and the proofs *compound* (each becomes a rewrite/transport that shortens the next), which PCC never did. |
| **Foundational PCC** (Appel, 2001) | PCC where the checker is a tiny logic kernel, not a trusted type system — shrinks the trusted base. | Our "trusted heart, small" (`CRYSTAL.md` §5): only encoding, typecheck, β/Eq/Iso, content addressing are trusted. | The FPCC program hardened the minimal-kernel discipline over years. | Same minimal-kernel philosophy, but the kernel is a *univalent* one where equivalences compute, so transport is a primitive rather than an axiom to be modeled. |
| **CompCert** (Leroy, 2005–) | A C compiler proved in Coq to preserve semantics end-to-end. | The **L1 preservation guarantees** — each edge kind states what it provably preserves (`CRYSTAL.md` §L1); and the licence's meaning-preservation obligation. | A complete, industrially-used verified compiler; enormous mechanized semantics; real deployment (Airbus, etc.). | CompCert's preservation is one fixed relation proved once by humans. Our lattice makes preservation *typed and compositional* (11 kinds, composition laws), and the machine *generates* preservation-carrying steps itself. |
| **CakeML** (Kumar, Myreen et al., 2014–) | A verified ML compiler + runtime with a verified bootstrapped implementation, in HOL4. | Our **self-modification gate** ambition: a system that produces its own verified implementation. | Actually bootstrapped and verified down to machine code; a real verified toolchain. | CakeML is verified-once by people. Our licence (`Nirjara`) is the *type of an admissible self-change* the machine carries at growth time — verification of change, not of a fixed artifact. |
| **Proof-Carrying Data / IVC** (Chiesa & Tromer 2010; Valiant 2008; Bitansky et al.) | Every step of a long distributed computation carries a succinct proof that the *entire history* satisfies an invariant; proofs are recursively composed. | The **compounding crystal** — each landing re-renders the whole store as one kernel-checked module; the invariant (kernel-checked) holds over the whole growing history. | Succinct (short proofs regardless of history length) via recursive SNARKs; formal cryptographic soundness; production folding schemes (Nova, etc.). | PCD carries *one fixed predicate* over a computation. Our crystal carries *open-ended mathematics* whose content grows, and each carried fact becomes executable (a rewrite/transport), reducing future cost — PCD proofs do not make later steps cheaper. |
| **zk verifiable computation / zkVMs** (RISC Zero, SP1) | Prove correct execution of a general program (RISC-V) in zero knowledge, verify cheaply on-chain. | **Local re-judgement** in the exchange: verification is cheap and local, authority unnecessary. | Production systems: SP1 Hypercube proves Ethereum blocks in ~12s; RISC Zero Boundless on mainnet (Sept 2025). Real succinctness + ZK. | zkVMs prove *a computation ran correctly*; they carry no *mathematics that compounds*, no typed-equivalence lattice, no self-improvement. We are proof-carrying *knowledge*, not proof-carrying *execution traces*. |
| **zkML** (EZKL, Modulus Labs) | Prove an ML inference was computed correctly under a committed model. | The "model at the uncompiled boundary" stance (`CRYSTAL.md` §0): models propose, kernel judges. | Working proofs of real neural-net inference; committed-weights infrastructure. | We keep the model strictly *outside* the trusted loop as an untrusted proposer in the carrier slot — the opposite architectural bet from putting the model's computation *inside* the proven statement. |
| **Decentralized proving networks** (Succinct Prover Network, RISC Zero Boundless, Gevulot, Nexus, =nil; Foundation) | Marketplaces matching proof *requests* to competing provers; proofs verified on-chain. | **The exchange / world-computer** primitive (`docs/ARCHITECTURE.md` §3): a peer's rows adopted by local re-judgement, zero trust. | Live economic networks, token incentives, GPU proving markets, real throughput (Boundless: 542T cycles, 399K orders). | Their unit of trade is a *proof of a computation for a fee*. Our unit is a *theorem that installs as an organ* and makes the receiver's future cheaper — a knowledge commons, not a compute spot-market. No incentive layer yet (honest gap). |
| **egg / egglog** (Willsey 2021; Zhang 2023) | Fast extensible **equality saturation**: an e-graph explores equivalent rewrites; egglog fuses it with Datalog + proof production. | **The L2 e-graph — the same data structure.** Union-find + congruence closure; egglog even produces proofs, as our proof forest does. | Mature, fast, widely deployed (compilers, query optimizers); relational e-matching; incremental; production engines. | egg/egglog merge equalities and extract *one cheapest* term by a scalar cost. We **keep distinct paths** (distinct automorphisms are content), route by a **cost vector** (no scalar fitness), and every edge is *kernel-checked and typed* (11 kinds), not a bare rewrite. |
| **babble / DreamCoder / library learning** (Bowers 2023; Ellis 2021) | Compress a corpus by mining reusable abstractions; babble does it with e-graphs + **anti-unification** modulo an equational theory. | **§3.1 crystallization, algorithmically the same** — mine repeated sub-derivations, anti-unify (Plotkin/Reynolds), install one edge where *k* steps were. | babble beats DreamCoder by orders of magnitude; a mature, benchmarked library-learning pipeline. | babble learns *program* abstractions for compression. We anti-unify *proof* sub-DAGs, **kernel-check the generalization**, and the installed lemma is simultaneously knowledge, code, rewrite, and transport — because in a univalent substrate those are one object. |
| **Superoptimization / STOKE** (Schkufza 2013) | Search the space of instruction sequences for a faster program equivalent to a target. | **L3 route selection** over a cost vector; the "one step where k were" payoff of crystallization. | Real, aggressive superoptimizers producing verified-equivalent faster code. | STOKE optimizes a fixed program against a scalar cost with stochastic search + a checker. We optimize *the library of mathematics itself*, keep nondominated routes, and the optimization is proof-preserving by construction. |
| **Gödel machine** (Schmidhuber, 2003) | A theoretical self-referential program that rewrites *any* part of itself — including its own proof search — once it proves the rewrite improves expected utility. | **The licence** (`Nirjara`): a self-modification is admissible iff it carries proofs of meaning-preservation + cost-non-increase; the inadmissible move *inhabits no licence*. | The most complete *theoretical* statement of provably-optimal self-improvement; fully general utility. | The Gödel machine is unimplemented and permits rewriting the prover itself. Our absolute is the opposite and is *built*: **no candidate may rewrite the kernel that judges it** — self-improvement is real but kernel-gated, so it actually runs (`docs/RESULTS.md` §2). |
| **AlphaProof / AlphaGeometry 2** (DeepMind, 2024) | RL-trained systems that generate **Lean**-checked proofs; IMO 2024 silver (4/6, 28 pts); AlphaProof solved P1/P2/P6. | Our **future learned proposer in the carrier slot** — a model emitting candidate strings the kernel judges. | State-of-the-art *generation*: olympiad-level, published in Nature (2025); vastly stronger proof search than our refl/cite/induction shapes. | AlphaProof generates proofs of *given* problems; it has no compounding library that shortens later proofs, no typed equivalence transport, no decentralized exchange. Its generator is exactly what we would drop into our untrusted proposer slot — it is a *component* of, not a rival to, our architecture. |
| **LeanDojo / ReProver, premise selection, hammers** (Yang 2023; Sledgehammer/MePo/Magnushammer) | Retrieval-augmented tactic generation; select relevant premises from huge libraries. | The **selection problem** our sense/propose stage will face at scale; premise = "which installed crystal row to cite". | Mature retrieval over 100k+ fact libraries; hammers integrated into Isabelle/HOL, Coq, Lean. | Premise selection retrieves from a *static* human-built library. Our library is *machine-grown and compounding*, and selection targets content-addressed rows whose citations remap on adoption (the exchange). |
| **Lean mathlib / Coq / Isabelle ecosystems** | Enormous human-built libraries of mechanized mathematics. | Our theorem inventory (`docs/RESULTS.md`), ~1,400 cubical modules + a Lean lane. | Scale and coverage vastly beyond ours — hundreds of thousands of lemmas, decades of community work. | mathlib is human-authored and does not self-extend or self-optimize; it has no content-addressed identity layer, no typed-equivalence transport that *acts*, no autonomous growth loop. |
| **Cubical Agda / redtt / cooltt / HoTT** (Cohen-Coquand-Huber-Mörtberg 2016–; RedPRL group) | Proof assistants in which **univalence computes** — `transport (ua e)` reduces. | **Our substrate itself** (`formal/cubical/`, `--cubical --safe`). | The foundational tooling — we *use* their kernel; they are ahead on the type theory by construction. | We are not ahead of them on type theory; we *build a machine on top*: the computing-univalence property is turned into the wire format (Carrier), the exchange (transport across representations), and the compounding loop. The tool is the substrate; the machine is the contribution. |
| **Unison** (content-addressed code) | Every definition is identified by the hash of its content; names are mutable views. | **L0 exact identity** (`CRYSTAL.md` §L0) — "independently required here by univalence: names are gauge". | A shipping language + codebase manager built entirely on content addressing. | Unison addresses *code*. We address *elaborated proof terms with dependency hashes*, and content-addressing is forced by univalence (different presentations are different addresses and stay so), not a language design choice. |
| **Decentralized proof generation via smart contracts** (AITP 2021, closest academic prior to our exchange) | Provers publish partial proofs correct up to named lemmas; a blockchain coordinates claims and distributes sub-goals. | The **exchange + world-computer bounty** idea most directly. | An actual proposed architecture for on-chain distributed *formal* proof (not just zk compute). | Their coordination is a blockchain scheduler over sub-goals. Ours is trust-free *adoption by local re-judgement* with citation remapping — and it is coupled to a self-improving loop, which theirs is not. |

---

## The four closest ancestors — precise deltas

### 1. Proof-Carrying Code = Carrier + kernel (the exact ancestor)

Necula & Lee's PCC is the closest thing in the literature to our primitive.
The shape is identical: **the producer ships a proof; the consumer checks
it with a small trusted checker and needs no trust in the producer.** Our
Carrier is the same object made univalent —
`punaragamana/src/Punaragamana/Carrier.agda`: for `f : A → B`, binding the
output makes the fiber `singl (f a)`, contractible, so data rides with its
image and the witness that it *is* the image at zero informational cost.
That is PCC's "code + safety proof" generalized from *one safety policy* to
*arbitrary mathematics*, with two deltas PCC never had:

- **The proof is the payload, not a side-condition.** PCC proves a program
  respects a fixed policy (memory safety). Our witness *is* the
  mathematical content; the theorem and its certificate are one term.
- **Proofs compound.** A PCC proof is consumed and discarded. A landed
  crystal row becomes a rewrite rule and (via computing univalence) a
  transport, so it *shortens the next proof* — the seed criterion,
  measured MET (`docs/RESULTS.md` §3: independent problem 29→12 steps with
  a null control staying bit-identical at 29). PCC has no compounding.

Delta in one sentence: **PCC is our Carrier with a fixed policy and no
memory; we are PCC where the policy is all of mathematics and every proof
installs as an organ.**

### 2. PCD / Incrementally Verifiable Computation = the compounding crystal

Valiant's IVC and Chiesa–Tromer's Proof-Carrying Data are the closest
ancestor to the *loop*, not the datum. PCD carries a proof that an entire
distributed computation history satisfied an invariant, composed
recursively so the proof stays succinct. Our crystal carries a
kernel-checked invariant over a growing history: every landing re-renders
the whole store as one `--safe` module (`docs/ARCHITECTURE.md` §2).

- **Where PCD is decisively ahead:** *succinctness*. A PCD/IVC proof is
  short regardless of history length (recursive SNARKs, folding schemes
  like Nova). Our "proof of the whole history" is the whole re-checked
  module — not succinct at all. This is a real gap; we have no recursive
  proof compression.
- **Where we add:** PCD's carried predicate is *fixed and closed*. Our
  carried content is *open-ended mathematics that grows*, and — the point
  PCD does not have — each carried fact becomes **executable** and
  **reduces the cost of future facts**. PCD verifies history cheaply; it
  does not make the future cheaper.

Delta: **PCD is a succinct proof that a fixed invariant held over a
history; the crystal is a non-succinct but *open-ended and
cost-reducing* proof-carrying history.** The honest research direction is
to borrow PCD's succinctness (recursive verification) for the crystal.

### 3. egg / egglog = the L2 e-graph (literally the same data structure)

This is not an analogy. L2 (`legacy/runtime/CRYSTAL.md` §L2) is a
union-find over hash-consed terms with congruence closure and a
Nieuwenhuis–Oliveras proof forest — which *is* egg's design, and egglog
even adds the proof production we require. Equality saturation is our
mechanism for exploring provable rewrites.

- **Where egg/egglog are ahead:** speed, maturity, relational e-matching,
  incrementality, real deployment in compilers and query optimizers.
- **Two precise deltas where we diverge on purpose:**
  1. **We keep distinct paths.** egg extracts *one cheapest* term; a merge
     is a merge. We retain multiple distinct paths between the same nodes
     because distinct automorphisms are *content*, not redundancy
     (`notes/CROSS_LENS.md` §2, cited in `CRYSTAL.md` §L2). Collapsing them
     destroys exactly the information the corpus proved is load-bearing.
  2. **Typed, kernel-checked edges + cost vector.** egg edges are untyped
     rewrites chosen by a scalar cost. Our edges are 11 typed kinds
     (`CRYSTAL.md` §L1), each with a composition law and a *preservation
     guarantee* the kernel checks — including two facts that are theorems
     about the lattice: `Iso` does not preserve `sign` (Galois
     conjugation), and no path through a `Quotient` delivers parity. And
     directed edges (`Quotient`, `Refine`, `Approx`) never merge classes.

Delta: **egg is our L2 with scalar extraction, untyped edges, and no
kernel; we are egg with distinction-preserving paths, a typed preservation
lattice, and every edge a checked term.** babble (e-graphs +
anti-unification for library learning) is the same statement one level up:
it is §3.1 crystallization for programs; we do it for proofs and
kernel-check the generalization.

### 4. AlphaProof / premise selection = the future learned proposer

AlphaProof (DeepMind, IMO 2024 silver, Nature 2025) generates Lean-checked
proofs by RL; LeanDojo/ReProver and the hammers retrieve premises. In our
architecture these are all *one component*: the untrusted proposer in the
carrier slot. `CRYSTAL.md` §0 states the stance — "models, when present at
all, sit strictly at the uncompiled boundary and propose candidates that
the kernel judges." Today our proposer is a hand-written trio (refl / cite
/ structural induction, judged 4-wide); an AlphaProof-class generator drops
straight into that slot.

- **Where they are overwhelmingly ahead:** *generation*. Olympiad-level
  search vs. our three proof shapes. This is the single largest capability
  gap in the whole survey and we should say so plainly.
- **Where we add:** AlphaProof has no compounding library (its proofs do
  not shorten its later proofs), no typed-equivalence transport, no
  content-addressed identity, no decentralized trust-free exchange. It is a
  brilliant *organ*, not a *machine*. Premise selection assumes a static
  human library; ours is machine-grown, compounding, and content-addressed
  with citations that remap on adoption.

Delta: **AlphaProof is the proposer we do not yet have; the machine is
everything around the proposer — the kernel gate, the compounding crystal,
the transport lattice, and the exchange — that AlphaProof does not attempt.**

---

## Novelty of the synthesis — tested honestly

The claim to verify: *each piece is individually known and strong in some
research community, but the union — a self-improving, proof-carrying,
content-addressed, decentralized, univalent machine whose growth is itself
kernel-gated — appears to be novel.*

**The pieces, and who owns each (all real, all strong):**

| Piece | Owned/led by |
|---|---|
| Proof-carrying data | PCC (Necula-Lee), FPCC (Appel) |
| Self-improvement (provable) | Gödel machine (Schmidhuber, theory); babble/DreamCoder (library learning) |
| Content addressing of code/terms | Unison |
| Decentralized proof/verification | Succinct, RISC Zero Boundless, Gevulot, Nexus; AITP-2021 smart-contract proving |
| Equality saturation e-graph | egg, egglog |
| Typed equivalence / computing univalence | cubical Agda, redtt/cooltt, HoTT |
| Strong learned proof generation | AlphaProof, ReProver/LeanDojo, hammers |

**The pairwise unions that already exist** (so the novelty is not claimed
naively):

- proof-carrying + compilation → CompCert, CakeML.
- proof-carrying + decentralized → zkVMs, Boundless, the AITP-2021
  smart-contract proof architecture.
- self-improvement + e-graphs → babble/DreamCoder library learning.
- e-graphs + proofs → egglog.
- univalence + tooling → cubical Agda.
- learned generation + kernel checking → AlphaProof, hammers.

**What the searches did *not* find:** any single system combining
**self-improvement + proof-carrying + decentralization** — let alone with
a **univalent** substrate where the transported identifications *act* and
the **growth itself is kernel-gated** by a licence carrying its own
preservation proof. The nearest three-way combinations each drop at least
one leg:

- **zk proving networks** (Boundless, Succinct) are proof-carrying +
  decentralized, but prove *executions*, not compounding *mathematics*, and
  do not self-improve their own library.
- **The AITP-2021 smart-contract prover** is decentralized + formal proof,
  but has no self-improvement loop and no univalent transport.
- **babble / DreamCoder** are self-improving + proof-adjacent (checked
  abstractions), but single-machine and not decentralized, not univalent.
- **The Gödel machine** is self-improving + proof-carrying in theory, but
  unimplemented, single-agent, permits rewriting its own prover (we
  forbid it), and is not content-addressed or univalent.

**The two legs that appear genuinely without precedent even in isolation,
in this combination:**

1. **Computing univalence as the wire format and the exchange medium.** No
   other verified-computation system uses `ua`-β reduction so that an
   equivalence between representations is an *executable channel* carrying
   theorems across for free (`docs/ARCHITECTURE.md` §1). zkVMs, PCC, egg —
   none have this; it requires a cubical kernel, which no proving network
   uses.
2. **Kernel-gated self-modification via a licence that inhabits a type.**
   `Nirjara`'s `Anujna` record makes an inadmissible self-change *inhabit
   no licence* — it cannot be constructed, rather than failing a runtime
   check (`formal/cubical/NaturalMachine/Nirjara_…​.agda`,
   `docs/RESULTS.md` §1). The Gödel machine states the goal; this is a
   built type for it, with the absolute constraint (no candidate rewrites
   its judging kernel) that keeps it runnable.

**Honest verdict.** Every individual piece is prior art, and several
*pairwise* and even a few *three-way* combinations exist. But the full
synthesis — proof-carrying **and** self-improving **and** decentralized
**and** content-addressed **and** univalent **and** growth-gated-by-its-own-
kernel — was not found in any single system in the literature searched. The
strongest near-miss is the family of zk proving networks (they have the
proof-carrying + decentralized legs at production scale) and babble (it has
the self-improving + e-graph legs), and the thesis is precisely that **no
one has joined those two families**, nor added the univalent transport and
the kernel-gated growth. If a counterexample exists it would most likely
surface under "self-improving formal library over a decentralized checker"
— the search returned nothing occupying that cell.

**Where we are behind, stated so the novelty is not mistaken for
superiority:** AlphaProof-class *generation*, PCD/SNARK *succinctness*,
mathlib *scale*, and every production zk network's *deployment,
incentives, and speed*. Our proposer is three proof shapes; our "proof of
the whole history" is not succinct; our exchange has no incentive layer;
our scale is ~1,400 modules. The synthesis is novel; each leg of it, taken
alone, is out-engineered by a dedicated field. The contribution is the
*join*, and the join is the thesis.

---

*Sources consulted (web, August 2026): DeepMind AlphaProof/AlphaGeometry 2
(Nature 2025; IMO 2024 silver); Succinct SP1 Hypercube + Prover Network;
RISC Zero Boundless (mainnet Sept 2025); egg (Willsey POPL 2021), egglog
(Zhang PLDI 2023); babble (Bowers/Nandi/Polikarpova POPL 2023); DreamCoder
(Ellis 2021); LeanDojo/ReProver (Yang NeurIPS 2023); Sledgehammer/MePo,
Magnushammer; "(Auto)Complete this Proof: Decentralized Proof Generation
via Smart Contracts" (AITP 2021). Foundational: Necula & Lee PCC (1996–98);
Appel FPCC (2001); Leroy CompCert; Kumar/Myreen CakeML; Valiant (2008) /
Chiesa–Tromer PCD (2010) / IVC; Schmidhuber Gödel machine (2003);
Schkufza STOKE (2013); Unison; Cohen–Coquand–Huber–Mörtberg cubical type
theory (2016).*
