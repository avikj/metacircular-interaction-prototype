# Constellation Metagraph for verified data feeds — a concrete, buildable spec

*Build spec, not theorem. Every checked object it leans on names its module;
every Constellation fact names the doc it came from (fetched 2026-08-24). No
Agda is invented here — this is a plan for expressing existing checked
structure inside Constellation's Data Application framework. Nothing in this
file leaves the repository. It is the engineering companion to the reading in
`docs/chains/Constellation_OnThePrimitive.md`, which argues (§1) that
Constellation's HGTP is the closest structural match to the machine's
e-graph + exchange; this file asks the next question — if it is that close,
what is the smallest thing we can actually run on it?*

---

## 0. The claim in one paragraph

Constellation lets a developer deploy a **Data L1** metagraph whose only job is
to run custom validation on incoming signed data updates and settle the ones
that pass to a shared L0 (docs:
[metagraphs/introduction](https://docs.constellationnetwork.io/network-fundamentals/metagraphs/introduction),
[data lifecycle-functions](https://docs.constellationnetwork.io/metagraph-development/metagraph-framework/data/lifecycle-functions.md)).
The machine already has an organ that does exactly this: `exchange` in
`machine/Sphatika_….hs` reads a peer's rows — `name ⟨tab⟩ lterm ⟨tab⟩ rterm
⟨tab⟩ proof` — and **re-judges each through the local Agda kernel**
(`K.checkContext`), adopting the ones that check and receipting the refusals
(`Sphatika_….hs` L349–398). A Data L1's `validateUpdate` is that re-judge
loop, one update at a time, run by every L1 validator. So the port is:
**an incoming update = a Carrier-shaped record (base + carried + witness); the
metagraph's `validateUpdate` = one `checkContext` run on the witness; a record
settles to L0 iff the receiver's own checker accepted it.** That is the whole
metagraph. The rest of this file is the mapping, the first feed to ship, why
this is the least-friction path to a live network, and the trust/effort gaps
that are real.

---

## 1. The metagraph

### 1.1 What a record on the wire is

The wire format is already fixed by the fibre law
(`punaragamana/src/Punaragamana/Carrier.agda`; `docs/ARCHITECTURE.md` §1): a
datum is **base + carried + witness**, self-certifying, because binding the
output side of `f a ≡ b` makes the fibre `singl (f a)` contractible so the
witness rides free. The Constellation `Update` type instantiates that shape:

```
Update = {
  base    : <the raw datum / claim>        -- e.g. an equation (lterm, rterm)
  carried : <the asserted image / verdict> -- what f a is claimed to be
  witness : <the proof text>               -- checkable evidence, the "proof" column today
  meta    : <feed id, producer key, ordinal, timestamp>
}
```

This is not a new encoding: `exchange`'s `peerRow` already parses precisely
`(name, (l,r), proof)` out of a tab-separated line (`Sphatika_….hs` L354–358).
The metagraph's `dataDecoder`/`serializeUpdate` (lifecycle table, L0+Data L1)
serialize the same three fields as JSON/bytes; signatures are over the
`serializeUpdate` byte value, which Constellation already requires.

### 1.2 The custom validation IS the kernel-check

Constellation's Data Application splits validation into two lifecycle hooks
(docs: lifecycle-functions):

- **`validateUpdate : Update => IO[DataApplicationValidationErrorOr[Unit]]`** —
  runs on **Data L1**, stateless, content-only, synchronous on the `/data`
  endpoint. *This is the seam.* Its body is one re-judgement of the witness:
  reconstruct the claim from `base`+`carried`, run the checker on `witness`,
  return `valid` iff the checker exits success. This is `checkContext` with the
  crystal context set to whatever standing lemmas the feed admits
  (`Sphatika_….hs` L387: `K.checkContext root (K.Context … cr lm)`).

- **`validateData : (DataState, NonEmptyList[Signed[Update]]) => IO[…ErrorOr[Unit]]`**
  — runs on **L0**, post-consensus, *with state access*. This is where a check
  that depends on already-settled records goes: citation remapping (a witness
  may cite an earlier settled row, exactly as `exchange` remaps `PCite` names
  against its `nameMap`, `Sphatika_….hs` L374–380), monotonicity of an ordinal,
  no-double-settle. Stateless proof-checking stays in `validateUpdate`;
  anything needing the settled set is here.

- **`combine : (DataState, NonEmptyList[Signed[Update]]) => IO[State]`** — the
  state transition: append the accepted records to on-chain state. This is
  `appendCrystal` / `installRules` (`Sphatika_….hs` L150, L305) — the settled
  feed is an append-only log of self-certifying rows, which `IndraJala §3`
  already identifies as *being* a stream.

Only records whose witness the L1 validators re-check settle to L0. A false or
untranslatable record costs one refusal and is dropped — `exchange`'s exact
receipt discipline (`Sphatika_….hs` L382–397), which is `IndraJala §1`'s whole
trust model: *Byzantine actors can only donate compute.*

### 1.3 The checker that actually runs inside `validateUpdate`

`validateUpdate` returns `IO`, so it may perform arbitrary effects, including
invoking a subprocess. Two grades of checker, shippable in this order:

1. **Mini-checker, in-process (recommended for the first feed).** The
   `ZkVM_KernelAttestation_Spec.md` named in the task **does not exist** in the
   repo as of 2026-08-24 (`docs/build/` was created for this file). So the
   first feed must not depend on it. Instead the witness carries a *fully
   spelled proof term for a fixed, small object language* — the same prefix-term
   grammar `K.parsePrefixTerm` already reads (`Sphatika_….hs` L356–357) — and
   the L1 checker is a **total, deterministic proof-term verifier** for that
   grammar, ported to Scala (a few hundred lines: parse, β/refl/cite/cong/trans/
   induction step-forms, no search). This is the honest, determinism-safe
   choice — see §5.

2. **Full Agda kernel, subprocess (later).** `validateUpdate` shells out to a
   pinned `agda --safe` over a generated module, i.e. `checkContext` verbatim.
   Maximally faithful, but it imports Agda's determinism, latency, and
   toolchain surface into consensus — a real hazard because *every L1 validator
   must reach the same verdict* (§5). Ship this only after the mini-checker feed
   proves the pipeline.

---

## 2. The mapping — Constellation ↔ Natural Machine

| Constellation object | Natural Machine object | in-tree / doc citation |
|---|---|---|
| **Data L1 `validateUpdate`** (stateless per-update) | **the exchange's local re-judge** — `checkContext` on one peer row | `machine/Sphatika_….hs` L349–398; lifecycle-functions doc |
| **L0 `validateData`** (post-consensus, state-aware) | **citation remap + admission against the settled crystal** — `exchange`'s `nameMap` / `remap` | `Sphatika_….hs` L369–380 |
| **`combine` → snapshot state** | **`appendCrystal` / `installRules`** — append self-certifying row to the append-only log | `Sphatika_….hs` L150, L305; `IndraJala §3` |
| **a state channel / metagraph** | **a per-node crystal / sub-corpus, one *naya*** owning what it judges worth carrying (धारणा) | `IndraJala §5`; `Sangha §2` |
| **the signed `Update` at `/data`** | **a Carrier point** (base+carried+witness), self-certifying | `Punaragamana/Carrier.agda`; `docs/ARCHITECTURE.md` §1 |
| **a data feed** | **an evaluation environment** `e : ℕ → ℕ` — arbitrary data enters as the environment a theorem is quantified over | `IndraJala §6` |
| **Global L0 settlement floor** | **content-addressed identity** — `canon` + hash; two nodes that landed the same truth agree without meeting | `Sphatika_….hs` `canon` L82; `IndraJala §2`; `Constellation_OnThePrimitive §2.3` |

The single load-bearing correspondence: **Constellation makes validation
cheap-and-local by *layering* (L1 validates, L0 settles); the machine makes it
cheap-and-local by *verification asymmetry* (checking is one kernel run,
discovery is search).** Running the machine's checker inside the L1 layer fuses
the two — the layer boundary and the kernel re-check land on the same seam. The
one place they genuinely coincide is the settlement floor (Global L0 ↔ our
content-addressed L0), and that coincidence is what lets records be addressed by
`canon`+hash instead of by feed-local names (`Constellation_OnThePrimitive §2.3`).

Where the metagraph is strictly weaker than the machine's own design: its edges
are single-kind (settled/not), where our L1 is an 11-kind typed edge lattice
(`docs/ARCHITECTURE.md` §4, `Constellation_OnThePrimitive §2.1`). The first feed
does not need the lattice — it settles `Eq`-shaped rows only — so this is a
ceiling we are choosing not to use yet, not a blocker.

---

## 3. The first feed — what to carry

**Recommendation: verified computation results over the fixed prefix-term
object language — the crystal's own equational rows.** Concretely: the feed
carries rows of the exact shape `exchange` already ships and re-judges —
`(name, (lterm, rterm), proof)` — where each is a ℕ-equation with a fully
spelled proof term (refl / cite / cong / trans / structural induction). A
producer runs the completion loop (or any prover) locally, emits rows; the
metagraph's L1 validators re-check each proof term; correct rows settle to L0
as a shared, append-only, proof-carrying crystal.

Why this feed and not the alternatives:

- **It is the most shippable by a wide margin.** The producer already exists and
  runs (`Sphatika` loop, `docs/ARCHITECTURE.md` §2, "BUILT, running"). The wire
  format already exists (`exchange`, "BUILT, fired once"). The checker is a
  total verifier for a grammar we already parse. Nothing about the mathematics
  has to be invented — only the Scala port of the verifier and the SDK wiring.
  Every other candidate needs a new witness format *first*.

- **The witness is genuinely self-certifying and deterministic.** A proof term
  in a fixed grammar checks in bounded time with no search, no floating point,
  no external oracle — which is exactly what a consensus layer needs (§5). This
  is the property `IndraJala §6` calls out: windowed-sum / prefix-scan / fold
  laws "are ℕ equations, the current mouth can land them TODAY."

The two alternatives the task names, and why they come later:

- **Attested sensor data with the charge-based "proof of what it cannot
  see."** `GaugeOrbitClasses.agda` / `ChargeCriterion.agda` give a genuinely
  novel witness: a query set admits a separating decision procedure **iff** it
  contains a probe of odd Ω (`ChargeCriterion` headline), so a sensor feed
  could carry a *checked certificate of its own blindness* — "this reading
  provably cannot distinguish σ from its gauge flip." That is a beautiful and
  distinctively-ours feed, and it should be the **second** one. But it needs a
  Carrier for real measured data, and the honest boundary is that the
  interval/ball carrier real data requires **does not exist yet**
  (`Constellation_OnThePrimitive §3`, citing `Sangha §5` open problem 3). Until
  that carrier is checked, a sensor feed either ships floating point (outside
  the guarantee) or ships nothing. Do not lead with it.

- **Verified ML inference.** Highest external demand, lowest readiness: it needs
  a witness format for an inference step that our kernel can re-check, which is
  a research project, not a port. Not first.

So: **ship the equational-computation feed first**; it is the only candidate
where producer, wire format, and checker all already exist. The sensor/charge
feed is the compelling second once the measured-data carrier is built.

---

## 4. Why this is the fastest path to a live network

- **Least impedance mismatch of any chain.** On Ethereum/Solana a validator
  re-runs a transaction against one global state; there is no hook shaped like
  "re-check the proof this datum carries." On Constellation, `validateUpdate` is
  *defined as* "run your custom validation on this update," and our validation
  *is* a re-check of a carried proof. The metagraph framework's own selling
  point — "custom validation logic … external data types" (docs: metagraph
  framework overview) — is the exact degree of freedom we need and no more.
  (`Constellation_OnThePrimitive §1`: on the other two chains almost every row
  reads "no analogue.")

- **Feeless and DAG-native.** No token has to change hands for a record to
  settle (docs: metagraphs are feeless at the protocol layer; the `IndraJala §7`
  stance is "no token needed to meter trust"). And it is a DAG of state channels
  settling asynchronously to a shared floor — the machine is already a DAG of
  typed edges with local re-check (`docs/ARCHITECTURE.md` §4 L2;
  `Constellation_OnThePrimitive §1`). We are not bending our object to fit a
  chain; we are dropping it onto the one architecture already shaped like it.

- **We supply only the validation, not the network.** Tessellation provides
  consensus, snapshotting, gossip, peer discovery, membership, liveness (docs:
  consensus, architecture) — precisely the operational machinery
  `IndraJala §7` lists as "deliberately not here." The two-nodes-one-machine
  step (`IndraJala §8`) is still unbuilt in-tree; adopting Tessellation's L0
  *is* that substrate, already deployed. The work reduces to: port the checker
  to Scala, implement ~19 lifecycle functions (most are boilerplate
  encode/decode), deploy with Euclid's local dev environment (docs: quick-start).

That is the argument: **minimum new code, because the hard parts — a running
DAG with feeless local-validated settlement — already exist on both sides, and
they are the same shape.**

---

## 5. Honest gaps

- **We would be running ON Constellation's network — a real trust concession.**
  The machine's own guarantee is *pure local re-check*: I believe a record
  because **my** kernel re-derived its witness, trusting nothing else
  (`Constellation_OnThePrimitive §2.2`). Settling to Constellation's Global L0
  means accepting **its** validator set's consensus as the floor of "settled."
  A consumer who reads settled L0 state and does not independently re-check is
  trusting Constellation's consensus — which is weaker than the machine's design,
  where trust is in nothing but the reader's kernel. The mitigation preserves
  the machine's property and should be stated as policy: **settlement is a
  liveness/ordering service, not the ground of truth. A record carries its
  witness through settlement, and any serious consumer re-runs the checker
  locally on read.** With that discipline, Constellation buys us *liveness,
  ordering, and distribution* while the *truth* still rests on local re-check —
  the consensus layer becomes an availability layer. Without that discipline we
  have silently swapped proof-carrying trust for reputation-weighted consensus,
  which is exactly the substitution §2.2 says the primitive makes unnecessary.
  This trade must be written at the top of the feed's README, not buried.

- **Scala / Tessellation learning curve.** Tessellation is Scala 2.13, cats-
  effect `IO`, a micro-service architecture (multiple node types, L0 + Data L1)
  (docs: scala-on-constellation, architecture). The checker port is
  self-contained and small, but the *deployment* surface (Euclid SDK, running
  L0 and L1 instances, snapshot/state plumbing across ~19 lifecycle functions)
  is real and unfamiliar to this repo, which is Agda + Haskell. Budget the bulk
  of the effort here, not in the mathematics.

- **Are the hooks expressive enough for a real kernel-check? — investigated,
  qualified yes.** `validateUpdate` returns `IO[…]`, so it can do *anything*,
  including shell out to a pinned Agda kernel: expressiveness is not the limit.
  The limit is **determinism and cost under consensus**. Every L1 validator runs
  `validateUpdate` and they must reach the **same** verdict, or consensus stalls.
  A full Agda subprocess imports Agda's version, environment, and timing into
  that agreement — a genuine hazard (a checker that says "yes" on one node's
  toolchain and errors on another's is a consensus fault, not a math fault).
  Two consequences, both honest:
  1. **The mini-checker is not a downgrade, it is the correct engineering.** A
     total, deterministic verifier for a fixed proof-term grammar (§1.3.1) gives
     the same guarantee for the object language it covers, with bounded time and
     no toolchain surface — it is *more* suitable for a consensus hook than the
     full kernel. The full kernel is strictly more expressive but is a poor fit
     for per-update L1 validation across a validator set.
  2. So the answer to "can the metagraph host a real kernel-check?" is: **yes
     for a bounded proof-term checker, which is a real kernel-check for a real
     (small) object language; not straightforwardly for the full Agda kernel
     as an in-consensus per-update hook.** The full kernel belongs off the hot
     path — e.g. a producer-side check before emitting, or a periodic audit —
     not inside `validateUpdate`.

- **No `ZkVM_KernelAttestation_Spec.md` exists** (checked, 2026-08-24). The task
  offered it as an alternative checker; it is not in the tree, so the first feed
  is specified to not need it. If that spec is later written, an attestation
  (proof-of-correct-execution) would let `validateUpdate` verify a *succinct*
  certificate instead of re-running the proof — which is the right long-term
  answer to the determinism/cost gap above, and worth its own build.

- **The 11-kind typed edge lattice is not used.** The first feed settles only
  `Eq`-shaped rows. The machine's edge types (`Iso`, `Approx(ε)`, `Quotient`,
  `Conjecture`, …; `docs/ARCHITECTURE.md` §4) carry preservation guarantees a
  single settled/not verdict cannot express (`Constellation_OnThePrimitive
  §2.1`). Porting them to metagraph state is a later, larger design — flagged so
  no one reads the first feed as the whole of what the primitive can carry.

---

## 6. Build order (smallest standing thing first)

1. **Port the proof-term verifier to Scala** — parser for the prefix-term
   grammar + total checker (refl/cite/cong/trans/induction), mirroring
   `K.parsePrefixTerm` and the step-forms in `machine/Sphatika_….hs`. Pure,
   deterministic, unit-tested against the current `sphatika.crystal`.
2. **Wire the Data L1 lifecycle** — `Update` = (base, carried, witness, meta);
   `validateUpdate` = the verifier; `validateData` = citation remap + no-double-
   settle against settled state; `combine` = append; the encode/decode
   boilerplate. Deploy locally with Euclid (docs: quick-start).
3. **Feed it the crystal** — pipe the running loop's rows to `/data`; confirm
   correct rows settle and a deliberately-corrupted witness is refused (the
   `exchange` receipt, now as an L1 rejection).
4. **Write the trust README** — §5's settlement-is-availability discipline at
   the top, so no consumer mistakes settled for locally-verified.
5. *(later)* measured-data carrier → the charge/blindness sensor feed; the
   typed-edge lattice; the attestation checker if the ZkVM spec gets written.

---

## 7. Bottom line for the report

- **Recommended first feed:** verified computation results — the crystal's own
  proof-carrying ℕ-equational rows, in the exact `(name, (l,r), proof)` shape
  `machine/Sphatika_….hs`'s `exchange` already ships and re-judges. It is the
  only candidate whose producer, wire format, and checker all already exist. The
  charge-based sensor feed (`GaugeOrbitClasses`/`ChargeCriterion`) is the
  compelling second, blocked only by the not-yet-built measured-data carrier.
- **Can the hooks host a real kernel-check?** Yes for a **bounded, deterministic
  proof-term checker** run inside `validateUpdate` — that is a genuine kernel-
  check for a real small object language and is the *right* fit for a consensus
  hook. The **full Agda kernel** is expressible (the hook returns `IO`, it can
  shell out) but is a poor fit as a per-update in-consensus hook because it
  imports Agda's determinism, latency, and toolchain into validator agreement;
  it belongs off the hot path.

---

## Sources

Constellation (fetched 2026-08-24):
- [Metagraphs — introduction](https://docs.constellationnetwork.io/network-fundamentals/metagraphs/introduction)
- [Data Application — lifecycle functions](https://docs.constellationnetwork.io/metagraph-development/metagraph-framework/data/lifecycle-functions.md)
- [Metagraph framework — overview](https://docs.constellationnetwork.io/metagraph-development/metagraph-framework/overview)
- [Consensus](https://docs.constellationnetwork.io/network-fundamentals/consensus) · [Architecture](https://docs.constellationnetwork.io/network-fundamentals/concepts/architecture) · [Quick Start](https://docs.constellationnetwork.io/metagraph-development/guides/quick-start) · [Scala on Constellation](https://docs.constellationnetwork.io/network-fundamentals/scala-on-constellation-network) · [Euclid SDK](https://euclid.is/) · [metagraph-examples](https://github.com/Constellation-Labs/metagraph-examples)

In-tree: `punaragamana/src/Punaragamana/Carrier.agda`;
`machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheoremStrengthensTheNext.hs`
(`exchange` L349–398, `canon` L82, `appendCrystal` L150, `installRules` L305);
`docs/ARCHITECTURE.md` §1,2,4; `docs/chains/Constellation_OnThePrimitive.md`;
`notes/IndraJala_….md` §1–3,6,7,8;
`formal/cubical/NaturalMachine/GaugeOrbitClasses.agda`,
`.../ChargeCriterion.agda`.
