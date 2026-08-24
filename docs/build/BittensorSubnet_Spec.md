# A Bittensor subnet whose validator is the kernel — buildable spec

*Companion and sequel to `docs/chains/Bittensor_OnThePrimitive.md`, which
argues the primitive; this file specifies the deployable thing. Where that note
says "for any task expressible as *produce X + a checkable certificate*, our
model strictly dominates," this one commits to a single such X, plugs our
kernel into the concrete Bittensor validator role, and states the honest limit
of what the chain's architecture will actually let the kernel do.*

*Every checked claim names its module in tree. No Agda is invented here. The
Bittensor mechanics are as of August 2026 (dTAO live, first halving Dec 2025,
subnet registration burned, up to ~256 subnets, 64 validator permits/subnet);
sources are listed at the foot.*

---

## 0. The one-line recommendation, up front

**Ship the theorem subnet: miners submit `(statement, proof)` rows in the
crystal format the machine already emits, the validator is `checkContext` /
the Agda kernel re-judging every row, scoring is binary landed/refused.** It is
the most immediately shippable of the three candidate tasks because *the
validator already exists and has already been fired* — `--exchange` mode of
`machine/Sphatika_TheCrystalGrows….hs` is, verbatim, a validator that ingests a
peer's proof rows and re-judges each through its own kernel
(`ARCHITECTURE.md §3`: "a fresh node adopted a 200-theorem crystal with zero
trust in the sender"). The other two candidates (verified code-optimization,
verified inference) require building a certificate-checking harness we do not
yet run; the theorem lane requires *wrapping the one we do*.

**And the honest architectural finding, up front:** Bittensor does **not** let
a single objective validator unilaterally set emissions — Yuma still takes the
stake-weighted median across the validator set, and validator permits still go
to the 64 highest-stake hotkeys. So stake still intermediates. **But
determinism collapses the thing stake intermediates over.** When every honest
validator runs the same kernel on the same row, they emit *identical* weight
vectors, so the stake-weighted median is the objective verdict for any honest
majority, and the entire apparatus Yuma exists to run (vtrust, consensus
clipping, commit-reveal against weight-copying) becomes either trivially
satisfied or moot. We do not remove Yuma; we feed it a signal with no variance,
which is the regime Yuma was never under adversarial strain to handle and
handles for free. §2 and §5 develop this precisely — it is the crux and it is
not oversold.

---

## 1. THE TASK — what miners produce

### 1.1 The product: a crystal row = `(statement, proof)`

A miner produces one row in exactly the format the machine's own loop already
writes to `machine/sphatika.crystal`:

```
sp009   x   +(x,*(x,0))   ind 0 refl congsuc
        └base┘ └─carried─┘ └──── proof term ────┘
```

The row is a `Carrier` point in the sense of
`punaragamana/src/Punaragamana/Carrier.agda`: `base + carried + witness`, where
the witness is `f base ≡ carried` and the fourth field is the proof strategy
that discharges it (`refl`, `cite`, or a structural-induction skeleton
`ind <var> <base-case> <step>`). The statement is the pair `(base, carried)`;
the certificate is the proof term; the check is the kernel.

Concretely a miner submits, on-chain or via the subnet's axon protocol:

- `statement_hash` — the content address of the *elaborated* goal term
  (`ARCHITECTURE.md §4`, L0: address = hash of elaborated term + dependency
  addresses; names are gauge, so two miners who prove the same theorem under
  different local names land on the same hash);
- `proof_payload` — the row's proof term plus the addresses of any earlier rows
  it cites (`PCite` in the `KernelContext`, `ARCHITECTURE.md §2`);
- `frontier_id` — which open obstruction (§3) this row claims to close.

### 1.2 Why theorems, not code-opt or inference — the shippability argument

All three are inside the certificate boundary (`Bittensor_OnThePrimitive.md
§"the task-domain split"`). The tiebreak is *how much of the validator is
already built and fired*:

| candidate task | product | certificate | validator we'd run | build state |
|---|---|---|---|---|
| **theorems from the frontier** ✅ | proof row | the proof term | the Agda kernel via `checkContext`, already wrapped in `--exchange` | **BUILT, fired** (`ARCHITECTURE.md §3`) |
| verified code-optimization | optimized program | machine-checked equivalence-to-original witness | an equivalence checker per source language | DESIGNED only (`docs/TECHNOLOGY_AND_MARKET.md §2.1`, "the optimizer that cannot lie") — not running |
| verified inference/aggregation | a summary/model output | witness that it is the honest function of its input (`isEquiv`, no-loss as proof obligation) | a per-data-type residual checker | DESIGNED only (`SankramanaSesa`, `docs/RESULTS.md §1`) |

The theorem lane wins on one criterion that dominates all others for a *day-one
ship*: **its validator is not a thing to write, it is a thing to expose.** The
loop already senses a frontier (`Sanghaṭṭa` critical pairs), already proposes
rows, already re-judges foreign rows through the local kernel with citation
remapping, and already receipts refusals. A subnet is the same three organs
with (a) the proposer population moved off-box onto miners and (b) the accept/
refuse verdict wired to a weight instead of to `installRules`.

Code-opt and inference are the correct *second and third* subnets — each is a
new namespace with the same validator shape once its certificate checker is
built — but they are not the fastest path to a running network, and the task
brief asks for the most immediately shippable.

### 1.3 Scoring is binary, and that is the whole anti-collusion argument

The miner's row either typechecks against the receiving kernel or it does not:
exit 0 or exit nonzero (`Bittensor_OnThePrimitive.md`, the verdict table,
row "decision rule"). There is no rubric, no partial credit for "almost,"
no aesthetic score. A landing weight is `1` (scaled by novelty/difficulty,
§4); a refusal weight is `0`. `IndraJala §1`, quoted in the primitive note:
**a false theorem costs the receiver one refusal; Byzantine actors can only
donate compute.**

This eliminates the surface Yuma spends its whole design fighting, and it does
so *structurally* rather than by counter-incentive:

- **Collusion to inflate a score has nothing to inflate.** In a subjective
  subnet, a validator cartel agrees to rate a confederate miner highly and the
  stake-weighted median moves. Here the "rating" is a typecheck the confederate
  cannot make succeed on a false proof and cannot make fail on a true one. There
  is no free parameter for a cartel to set. The verdict is not a number a market
  agreed on; it is a computation each participant re-runs
  (`Bittensor_OnThePrimitive.md §"the centerpiece"`).
- **Weight-copying stops being an attack because copying the right answer *is*
  the right answer.** Bittensor's weight-copying problem
  (docs.learnbittensor.org, "The Weight Copying Problem"; commit-reveal exists
  solely to fight it) is that a validator can read others' weights and harvest
  vtrust without doing the evaluation work, diluting the honest signal. That
  attack presumes the evaluation is *expensive and private*. Here it is cheap
  and public: re-checking a proof is one kernel run and yields a bit that every
  honest validator computes identically. A "copier" who submits the kernel's
  verdict without running it submits *the same vector the honest validator
  submits*, because there is only one correct vector. There is no honest signal
  to dilute, so there is nothing for commit-reveal to protect and nothing for
  the copier to steal. (The residual attack — copying to avoid paying for
  compute — is addressed in §5.4; it is real but bounded and cheap to price
  out, because the compute being avoided is one typecheck, not a model
  inference.)

---

## 2. THE VALIDATOR — the kernel in the Bittensor validator role

### 2.1 What a Bittensor validator does, and where the kernel drops in

A permitted validator on a subnet, each epoch: receives miner submissions,
scores them by the subnet's incentive mechanism, and submits a weight vector
`w_v` (one weight per miner UID) to Subtensor; Yuma resolves the validator×miner
weight matrix into miner incentives and validator dividends
(docs.learnbittensor.org/yuma-consensus; docs.taostats.io/docs/consensus).

The subnet owner defines the incentive mechanism. **Our incentive mechanism is
the kernel.** The validator's per-miner score is:

```
score(miner m) = Σ over m's newly-landed rows this epoch  difficulty(frontier_id)
   where a row "lands" iff  checkContext(local_crystal, row) == Accept
                        and statement_hash ∉ local_crystal   (first-lander, §5.4)
```

`checkContext` is the existing re-judge path: the validator maintains its own
crystal (the canonical corpus + everything landed so far), and each miner row is
run through `machine/Sphatika_…hs`'s `--exchange` ingestion — parse the row,
remap its `PCite` addresses to the validator's local ordering, hand the proof
term to the Agda kernel (`--cubical --safe`, no postulates, no holes:
`ARCHITECTURE.md §1`), read exit 0/nonzero. Accepts are appended to the local
crystal (so later rows in the same epoch may cite them); refusals are receipted
and score 0. This is not new code; it is `ARCHITECTURE.md §3` with the input
arriving from a miner UID instead of a peer file.

The trust boundary is the one already stated (`ARCHITECTURE.md §6`): the kernel
is trusted; the driver, the store, the chain, the miner are all untrusted and
**no candidate may rewrite the kernel that judges it.** A miner cannot smuggle a
postulate or a `--safe`-violating flag because the validator elaborates the row
against a fixed, pinned checker the miner never supplies.

### 2.2 The novelty, stated exactly: objective validation inside a subjective network

Bittensor's validator role is built to carry a *subjective* signal — "my model
thinks this output is worth 0.7" — and Yuma exists to reconcile many such
signals that legitimately disagree. We put a **deterministic function** into
that role. Two consequences, and they are the entire contribution:

1. **The validator's output has zero variance across honest validators.** Give
   ten honest validators the same miner row and the same pinned kernel and they
   return the same bit. So the validator×miner weight matrix, restricted to
   honest validators, has identical rows. The stake-weighted median that Yuma
   computes is therefore exactly that row — the objective verdict — for **any
   honest-stake majority.** Yuma is not bypassed; it is fed a degenerate
   (variance-free) input on which its median is the identity, and its
   consensus-clipping penalizes exactly the dishonest validators (those
   reporting a verdict the kernel does not produce).

2. **Every mechanism Yuma runs against subjective-signal pathologies is either
   trivially satisfied or inert.** vtrust (reward for agreeing with consensus)
   is maximized for free by any validator that actually runs the kernel, because
   the kernel *is* the consensus. Commit-reveal (hide weights so copiers copy
   stale ones) protects nothing, because the "hidden" signal is publicly
   recomputable by anyone with the kernel — there is no private evaluation to
   protect. Consensus-clipping still does useful work: it clips a validator who
   reports Accept on a row the majority's kernel refuses (a lazy or lying
   validator), which is the *one* residual dishonesty and the one worth
   penalizing.

This is the sentence from `Bittensor_OnThePrimitive.md §"the centerpiece"`
made operational: *stake is not an input to typechecking.* Stake still selects
*who holds a permit* and still weights the median — that intermediation is real
and §5.2 does not pretend it away — but stake cannot move *what the kernel
returns*, so the only thing stake can buy is the right to be clipped for
disagreeing with a fact.

### 2.3 Validator implementation sketch (what actually gets deployed)

```
# per epoch, per permitted validator:
crystal = load_local_crystal()          # canonical corpus + prior landings
open    = load_frontier()               # §3: the epoch's posted obstructions
for uid, rows in collect_miner_submissions():   # via axon/dendrite
    for row in topological_by_citation(rows):   # peers cite only earlier rows
        remap_citations(row, crystal)            # PCite address → local index
        if statement_hash(row) in crystal:       # already landed: first-lander wins
            receipt(uid, row, verdict="STALE"); continue
        if kernel_check(crystal, row) == 0:      # the Agda kernel, pinned
            crystal.append(row)                  # later rows may cite it
            credit[uid] += difficulty(row.frontier_id)
        else:
            receipt(uid, row, verdict="REFUSED")
w = normalize(credit)                    # miner UID → weight
commit_reveal_or_set_weights(w)          # standard Subtensor call
```

Everything except the two Subtensor calls (`collect_miner_submissions`,
`set_weights`) already exists in `machine/Sphatika_…hs`. The port is: expose the
ingestion path over the subnet's request protocol, and emit a weight vector
instead of a commit.

---

## 3. THE FRONTIER FEED — where fresh, verifiable tasks come from

A subnet dies if miners run out of work or if the work becomes copy-pasteable.
Both are solved by the machine's *endogenous* frontier — the one Bittensor
subnets structurally lack (their tasks are exogenous, set by the owner:
`Bittensor_OnThePrimitive.md §"the task is not posted, it is derived"`).

### 3.1 The primary feed: Sanghaṭṭa critical pairs (self-generating, self-scaling)

The loop's SENSE organ (`ARCHITECTURE.md §2`) computes Knuth–Bendix critical
pairs of the currently-installed rewrite rules — the equations the rule set
*cannot yet close*. That set **is** the open-problem stream, and it has the
property a subnet needs: **it grows every time a row lands.** `installRules`
turns a landed equation into a rewrite rule, and the next SENSE pass derives
*new* critical pairs from it (`ARCHITECTURE.md §2`, the INSTALL→SENSE arrow).
So the frontier is not a fixed pool that miners exhaust; it is a moving boundary
that recedes as it is mined. Difficulty scales automatically: early pairs close
by `refl`, later ones need multi-step induction citing several prior landings.

The subnet posts, each epoch, a batch of open obstructions with content
addresses; a miner claims one by `frontier_id` and submits a row against it.

### 3.2 The residual feed: the kernel's own refusals as fresh subgoals

`machine/Obstruction.hs` is the second, sharper source. It reads the kernel's
~1200 refusals/round not as verdicts but as the machine *stating which lemma it
needs next* — the residual of a stalled proof (goal `x ≡ 1·x`, residual
`x ≡ x + 0·x`) is a new, more primitive, still-open subgoal, "derived rather
than guessed" (`Obstruction.hs` header; `ARCHITECTURE.md §2` RESIDUAL box). This
gives the subnet a *difficulty-graded curriculum for free*: `Obstruction.hs`
already exposes `curriculum`, `worthQueueing`, and a `triage` that refutes false
parents by exact evaluation before they are ever posted — so the frontier feed
never posts a goal that is actually false, and miners never waste work on an
unprovable target. (Refutation-by-exact-evaluation is itself certified compute,
not a measurement — `CLAUDE.md`, "exact/certified symbolic computation is
proof.")

### 3.3 The external feed (later subnets): posted open problems / optimization targets

The same posting mechanism accepts *exogenous* verifiable tasks when the machine
chooses to ingest them: a stream of formalized open conjectures, or (for the
code-opt subnet) a stream of `(program, spec)` optimization targets whose
certificate is a checked equivalence. This is how the subnet family generalizes
beyond the machine's own arithmetic frontier without changing the validator
shape — the task changes, the "produce X + machine-checkable certificate, kernel
re-judges" spine does not. Honest note: the external feed needs a formalization
front-end (natural-language conjecture → Agda goal) that is *not* built; the
Sanghaṭṭa and Obstruction feeds (§3.1–3.2) are, and are enough to launch.

---

## 4. ECONOMICS — how emissions reward verified work, and why it converts

### 4.1 The emission path

Post-dTAO, a subnet earns TAO emissions as a function of the market value of its
alpha token, split each epoch by Yuma into miner incentive, validator dividend,
and subnet-owner take (docs.learnbittensor.org; the Dec 2025 halving cut daily
emission ~7,200→3,600 TAO). Our incentive vector `w` (§2.3) directs the miner
share to whoever landed verified rows. So:

- **Miners are paid in alpha/TAO per verified landing**, weighted by
  `difficulty(frontier_id)`. A landing is a theorem the canonical crystal did
  not have, checked by the kernel — i.e. *discovery*, the thing
  `Bittensor_OnThePrimitive.md §"incentive"` says is genuinely scarce and worth
  funding. Verification (the recheck) is free and unpaid, exactly as the
  verification-asymmetry account requires (`notes/AmudraDhana_…`): charge where
  cost is real (search), never where copying is free (checking).
- **Validators earn dividends for running the kernel.** Because the honest
  verdict is unique, an honest validator maximizes vtrust automatically; the
  dividend is a fee for supplying recompute and liveness, not for a private
  opinion.

### 4.2 Why this is convertible revenue from day one

Two independent reasons, and neither depends on anyone believing our
metaphysics:

1. **The alpha token is liquid into TAO into fiat via the dTAO AMM the moment
   the subnet is registered.** Unlike the honest-but-slow funding paths the
   primitive note lists for the bare machine (public goods, patronage,
   priced-at-real-cost compute — `Bittensor_OnThePrimitive.md §"honest gap 3"`),
   a registered subnet has a *market price* on its emissions from block one.
   This is precisely the "incentive that funds discovery in fiat-convertible
   terms today" that the primitive note admits the standalone machine lacks. The
   subnet is the conversion layer.
2. **The product is trust-free and therefore resellable without us.** A landed
   crystal row is a proof-carrying object: any consumer re-checks it with the
   pinned kernel in one run and needs zero trust in the miner, the validator, or
   the network (`ARCHITECTURE.md §3`; the whole `--exchange` demonstration). A
   verified-theorem corpus, or later a corpus of certified compiler passes /
   certified query plans, is a saleable good whose value survives leaving the
   subnet — which a subjective subnet's output (a model inference nobody can
   independently certify) does not.

### 4.3 The honest limit — say it plainly

**This converts only inside the verifiable-task domain, and the domain is the
certificate.** (`Bittensor_OnThePrimitive.md §"the task-domain split"`, stated
as a wall, not a modesty.) The subnet cannot host chat quality, aesthetics,
taste, or any task with no checkable success criterion — for those Bittensor's
subjective validators are not overhead but *necessary*, and we have nothing to
offer. The revenue is real and bounded: it is exactly the revenue from selling
*verified* intelligence, which is a strictly smaller market than all
intelligence and a strictly higher-trust one. We do not claim the subjective
market. We claim the slice where a market of opinions about correctness is a
category error, and we claim it completely.

A second honest limit on *volume*: the arithmetic frontier (§3.1) is deep but it
is one machine's frontier. Sustained high-value emissions need the external feed
(§3.3) — real open problems, real optimization targets — which needs the
formalization front-end we have not built. Day one converts on the endogenous
frontier; scaling the *dollar* value past a demonstrator needs that front-end.

---

## 5. HONEST RISKS

### 5.1 Registration cost and competition

Registering a subnet is expensive and rising: the lock cost doubles per
registration and decays back toward a floor (NetworkMinLockCost, 1,000 TAO
default) over ~2 weeks; observed prints have been ~1,500 TAO (May 2026) up to
~3,420 TAO, and post-dTAO the registration TAO is **burned, not refundable**
(bitget/cryptobriefing; docs.learnbittensor.org/subnets/subnet-deregistration).
At current prices that is a six-to-seven-figure USD entry, unrecoverable, into a
field of 128→256 subnets competing for a halved (~3,600 TAO/day) emission pool.
A subnet that does not attract emissions-weighted alpha demand can be
deregistered out from under its owner. This is a genuine capital risk and the
spec does not minimize it: the mitigant is that the validator is already built
(near-zero engineering cost to launch) and the product is independently
resellable (§4.2), so the break-even does not depend on winning the alpha
beauty contest — but the entry ticket is real money at risk.

### 5.2 Does Bittensor actually permit a purely-objective validator? — investigated, answered

**No, not "purely" in the sense of a single validator whose verdict is the
emission — and this is the most important honest finding.** Two chain facts
intermediate:

- **Yuma always takes the stake-weighted median across the validator set**, not
  a single validator's vector (docs.learnbittensor.org/yuma-consensus;
  docs.taostats.io/docs/consensus). There is no "one authoritative validator"
  primitive.
- **Validator permits (≤64/subnet) go to the highest-stake hotkeys**
  (docs.learnbittensor.org/validators). So *who gets to run the kernel on-chain*
  is a stake auction, and a majority-stake coalition among permitted validators
  still controls the median.

**So stake still intermediates.** What the objective validator buys is not the
removal of Yuma but the **collapse of its variance**: because the kernel is
deterministic and public, every honest validator's vector is identical, so (a)
the stake-weighted median equals the objective verdict for any honest-stake
majority, and (b) a dishonest validator can only *disagree with a recomputable
fact*, which consensus-clipping penalizes and which anyone — including the
subnet owner and every consumer — can detect by re-running the kernel. The
residual trust assumption is therefore **honest majority of *permitted* stake**,
not "trust the kernel" (the kernel needs no trust) — and that assumption is
strictly weaker and more auditable than a subjective subnet's, where a dishonest
majority can move a verdict nobody can independently check. Stated as the
primitive note would: we do not delete Yuma, we feed it a signal it cannot
legitimately disagree about, so its only remaining job is to punish illegitimate
disagreement, which it already does. **The purely-objective validator is a
property of the honest population running identical code, not a chain feature —
and the chain permits it exactly to the strength of the honest-stake majority.**

### 5.3 Bootstrapping — attracting miners

A subnet with no miners emits to nobody and deregisters. The theorem lane has a
specific bootstrap advantage and a specific handicap:

- *Advantage:* the machine is itself a competent miner. The existing loop
  (`sphatika-forever.sh`) produces landings autonomously, so the subnet is never
  empty — the owner's own node seeds liveness and sets the difficulty bar,
  exactly as the `--exchange` demo already produced a 200-theorem crystal. This
  is a real edge over subnets that need third-party miners before they produce
  anything.
- *Handicap:* the miner population that can *beat* the machine's own node at
  producing novel checked rows is small — this is a niche skill (automated
  theorem proving / proof search), not the large GPU-inference labor pool other
  subnets recruit. Mitigant: the frontier feed posts machine-readable,
  difficulty-graded, pre-triaged goals (§3.2), lowering the barrier to "write a
  prover that closes posted goals," and the external feed (§3.3) eventually
  widens the task surface to code-opt where the miner pool is larger. Honest
  read: this is a *deep but narrow* labor market at launch, and depth of
  emissions will track how compelling the posted frontier is.

### 5.4 Gaming — can a miner submit someone else's proof? Provenance, shown

The obvious attack: miner B copies miner A's `(statement, proof)` and submits it
to farm the reward. Content-addressing + first-lander provenance closes it, and
the pieces are already in the architecture:

- **Content addressing (`ARCHITECTURE.md §4`, L0).** A row's identity is the
  hash of its *elaborated* term plus dependency addresses — names are gauge, so
  renaming variables or the theorem does not produce a new address. A copied
  proof has the *same* `statement_hash` as the original. It is therefore not a
  new landing: the validator's check `statement_hash ∉ local_crystal` (§2.3)
  returns STALE and scores it 0. Copying yields nothing because the crystal
  already contains that exact object.
- **First-lander via commit-reveal timestamp.** For a *simultaneous* race (two
  miners submit the same novel proof in the same window before either is in the
  crystal), the tiebreak is the on-chain commit order: commit-reveal already
  timestamps each submission cryptographically (docs.learnbittensor.org/concepts/
  commit-reveal, Drand time-lock). The earliest valid reveal of a given
  `statement_hash` lands; later identical reveals are STALE. A copier cannot
  front-run, because during the concealment window the proof is encrypted — the
  copier has nothing to copy until the original is already revealed and
  therefore already landed.
- **The residual attack the copy-defense does *not* kill, named honestly.** A
  validator (not a miner) could skip running the kernel and copy another
  validator's weight vector to save the recompute. §2.2 argues this is nearly
  harmless (the copied vector *is* the correct vector), but it does mean the
  network's total honest recompute could thin. The bound: the compute being
  dodged is one typecheck per row, not a model inference — cheap enough that a
  small vtrust penalty for any validator whose vector ever diverges from a spot
  re-check (which the owner's node performs continuously) prices it out. Unlike
  the subjective case, spot-checking is *free and conclusive* here, because the
  checker is deterministic.
- **Trivial/duplicate-spam gaming.** A miner could flood `refl`-closable trivial
  rows. Difficulty-weighting (§3.1: early pairs close by `refl` and are worth
  ~0; deep induction rows carry the weight) plus the frontier being a finite
  posted set per epoch (you can only land each open obstruction once, §5.4
  first-lander) caps this: trivial rows land once, for near-zero weight, and
  then are STALE forever.

### 5.5 The gap the whole spec inherits from the primitive note

`Bittensor_OnThePrimitive.md §"honest gaps"` #1 stands undiminished: Bittensor
is a *deployed* network with real TAO, real stake, years of adversarial
hardening; the Natural Machine is a checked substrate with a running single-node
loop and a two-node exchange fired once. This spec is a design for entering that
deployed network, not evidence that the entry has survived contact. "No
collusion surface in principle" (true, §1.3) and "survived real attackers for
years" (not us) remain different kinds of assurance. The spec's claim is only
the first: that where a certificate exists, the objective validator dominates —
and that the theorem lane is the cheapest place to demonstrate it live.

---

## Sources

Bittensor mechanics (August 2026):
- [Yuma Consensus — docs.learnbittensor.org](https://docs.learnbittensor.org/yuma-consensus/)
- [Validating in Bittensor — docs.learnbittensor.org](https://docs.learnbittensor.org/validators)
- [The Weight Copying Problem — docs.learnbittensor.org](https://docs.learnbittensor.org/concepts/weight-copying-in-bittensor)
- [Commit Reveal — docs.learnbittensor.org](https://docs.learnbittensor.org/concepts/commit-reveal)
- [Yuma Consensus — docs.taostats.io](https://docs.taostats.io/docs/consensus)
- [Subnet Deregistration — docs.learnbittensor.org](https://docs.learnbittensor.org/subnets/subnet-deregistration)
- [Subnet registration cost rises 6.5x to 1,500 TAO — cryptobriefing](https://cryptobriefing.com/bittensor-subnet-registration-cost-rises/)
- [AI hype pushes Bittensor subnet fees — DL News](https://www.dlnews.com/articles/defi/ai-hype-in-crypto-pushes-bittensor-subnet-tao-fees/)
- [Bittensor 2026 Guide — Crypto Times](https://www.cryptotimes.io/learn/bittensor-tao-guide/)

In-tree modules cited:
- `docs/chains/Bittensor_OnThePrimitive.md` — the primitive contrast this spec operationalizes
- `docs/ARCHITECTURE.md` §1–§6 — substrate, loop, exchange, runtime layers, trust boundary
- `punaragamana/src/Punaragamana/Carrier.agda` — `base + carried + witness`, the row format
- `machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheoremStrengthensTheNext.hs` — the loop and `--exchange` re-judge (the validator)
- `machine/Obstruction.hs` — refusals-as-curriculum, `triage`/`curriculum`/`worthQueueing` (the residual frontier feed)
- `machine/sphatika.crystal` — the on-wire row format
- `formal/cubical/NaturalMachine/SankramanaSesa_….agda`, `formal/cubical/Saptabhangi.agda` — the certificate/verdict discipline behind future code-opt & inference subnets
- `notes/AmudraDhana_…` — verification-asymmetry as the price system (the economics)
</content>
</invoke>
