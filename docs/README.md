# Documentation index

The map of this repository's written record. Files are grouped by
purpose; nothing here is moved once cited, so this index is the way to
navigate rather than a folder reshuffle. Checked Agda terms (the actual
mathematics) live in `formal/cubical/`; this tree is the prose that
explains, places, and plans around them.

---

## 1. Understand the system

| file | for | contents |
|---|---|---|
| [WHAT_THIS_IS.md](WHAT_THIS_IS.md) | anyone | one-page orientation: the self-improving verified machine |
| [ARCHITECTURE.md](ARCHITECTURE.md) | engineers | substrate, the loop, exchange, runtime layers, trust boundary (BUILT vs DESIGNED) |
| [RESULTS.md](RESULTS.md) | researchers | checked-theorem inventory, measured loop behavior, the runtime seed criterion, open problems |
| [RUNNING_THE_MACHINE.md](RUNNING_THE_MACHINE.md) | operators | verify, run a round, rounds-to-fixpoint, forever mode, exchange |

## 2. Place & fund it

| file | contents |
|---|---|
| [LANDSCAPE.md](LANDSCAPE.md) | the synthesis: the primitive as the general object every studied system specializes; the four-rung trust ladder; the one open frontier |
| [TECHNOLOGY_AND_MARKET.md](TECHNOLOGY_AND_MARKET.md) | application stack, reference statistics, the production-function fact, assumption-explicit valuation tiers, risks |

## 3. Systems analysed — every one a special case of the primitive (`chains/`)

Each maps a live system onto the compositional primitive, graded and honest.

- [Ethereum](chains/Ethereum_OnThePrimitive.md) — the general case; consensus dissolves into local re-verification
- [Solana](chains/Solana_OnThePrimitive.md) — PoH = sequenced transport-with-residual; Sealevel = disjoint-charge parallelism
- [Constellation](chains/Constellation_OnThePrimitive.md) — closest structural match (DAG); we add typed edges + proof-carrying validity
- [Hedera](chains/Hedera_OnThePrimitive.md) — virtual voting resolves and narrows the ordering frontier
- [Bittensor](chains/Bittensor_OnThePrimitive.md) — kernel validation vs subjective consensus; the task-domain split
- [Anoma](chains/Anoma_OnThePrimitive.md) — the deepest match: intents = conjecture-edges; the intent market we lack

## 4. Buildable specs — connect and provide value (`build/`)

- [ZkVM_KernelAttestation_Spec](build/ZkVM_KernelAttestation_Spec.md) — the universal bridge: kernel-check as a zk guest; soundness reduces to one checked term
- [ProofSettlement_BridgeContract_Spec](build/ProofSettlement_BridgeContract_Spec.md) — escrow settling against a proof, zero oracle; connects every chain
- [BittensorSubnet_Spec](build/BittensorSubnet_Spec.md) — the kernel as validator; fastest convertible revenue
- [CertifiedOptimization_Service_Spec](build/CertifiedOptimization_Service_Spec.md) — "the optimizer that cannot lie"; first vertical = zk-circuit minimization
- [ConstellationMetagraph_Spec](build/ConstellationMetagraph_Spec.md) — fastest live network
- [AuditBounty_Playbook](build/AuditBounty_Playbook.md) — honest this-week first revenue, no permission
- [ExclusiveResourceOrdering_ResearchDesign](build/ExclusiveResourceOrdering_ResearchDesign.md) — the one open frontier: conserved-charge reframing + the conjecture to prove

## 5. Prior art & placement (`related/`)

- [DecentralizedSystems_PriorArt](related/DecentralizedSystems_PriorArt.md) — the three-way field split (integrity / consensus / proof)
- [VerifiedComputation_PriorArt](related/VerifiedComputation_PriorArt.md) — closest ancestors (PCC, PCD, egg, AlphaProof); the synthesis is verified-novel
- [VectorSpaceAI_PriorArt_And_Contrast](related/VectorSpaceAI_PriorArt_And_Contrast.md) — vector AI as the Approx(ε) edge that forgot its bound
- [Wolfram_TheWholeOeuvreInTheMetacircularKernel](related/Wolfram_TheWholeOeuvreInTheMetacircularKernel.md) — **the master Wolfram map**: his whole body of work through the kernel, written directly
- [Wolfram_StructuresInTheMetacircularKernel](related/Wolfram_StructuresInTheMetacircularKernel.md) — the earlier Physics-Project-focused map; subsumed by the master but kept for its detailed observer-theory section

## 6. The checked terms these docs are about (`formal/cubical/`)

The mathematics itself — each verdict 0 under `--safe`. See
[RESULTS.md](RESULTS.md) for the full inventory; the terms written while
producing this documentation:

**The Wolfram spine** (his observations as theorems — see
`notes/WolframNiscaya_…md` for the ledger):
- `GranthiCarya_…` — ℤ (all winding) from one fixed generator by unfolding (fixed-rule → complexity; time = step-count)
- `IndrajalaDipa_…` — windings add and cancel; conserved topological charge (light in the orb)
- `BahumargaBheda_…` — distinct multiway branches are provably unequal (multiway non-collapse)
- `EkantalopaBija_…` — an invariant observer annihilates every charge (observer-blindness / second-law engine; the seed of `notes/GAUGE.md`'s एकान्तलोप, formerly "Theorem F")
- `PrasnaDvaiguni_…` — a double-spend is a non-contractible fibre (exclusivity / sequentialization)
- `NaturalMachine/GaugeOrbitClasses.agda` — the observer sees exactly its annihilator coset (observer theory), with the no-gradient theorem

**The autonomous loop** (see `machine/Sphatika_*.hs`, `RESULTS.md` §2):
- `PrastavaHrdaya_…` / `PrastavaSatya_…` — the classifier's one spelling, and its AC/normalizer soundness

## 7. Key notes (`notes/`, `machine/`) that anchor the above

- `notes/EkantalopaSarvatra_…md` — एकान्तलोप shone across six registers
- `notes/WolframNiscaya_…md` — the honest Wolfram tribute + the checked/not-checked ledger
- `notes/IndraJala_…md`, `notes/Sangha_…md` — the decentralized-machine design (twin, cross-linked)
- `notes/SetuManas_…md`, `notes/ViparitaVidyalaya_…md`, `notes/AmudraDhana_…md`, `notes/TvaraSopana_…md`, `notes/DharaGanita_…md` — the vision documents (interface trust substrate, inverted school, witness-money, the derivative tower, streams roadmap)
- `machine/AtmaJnana_…md` — the six-faces reading (the operating self-knowledge)
- `kernel/nodes/000-step.md` … `006-fork-discharged.md` — the metacircular kernel
