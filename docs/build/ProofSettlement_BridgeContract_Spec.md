# Proof-of-Theorem Settlement — the bridge contract that connects the machine to every chain at once

*Buildable spec, not integration. No new Agda. Solidity is a sketch of an
interface, not audited code. Every economic claim is read off a checked term or
a named in-tree organ and cited; the genuinely hard parts are marked HONEST RISK
and not smoothed over. Design date 2026-08-24.*

The one-line thesis: **an escrow that settles against a proof needs no oracle,
because the checker is the oracle and it is deterministic and on-chain-verifiable.**
Every escrow, bounty, and cross-chain-intent contract in the wild pays a trusted
party to answer "did the thing happen?" — an oracle, a multisig, an optimistic
challenge window, a solver's honesty bond. A statement `S` proven in the Natural
Machine answers that question *in the object itself*: the zk-attestation from the
sibling spec (`docs/build/ZkVM_KernelAttestation_Spec.md`) is a succinct on-chain
proof that *the checker accepted proof `P` for statement `S` with content-address
`H`*. The settlement contract verifies that attestation and pays. There is
nothing left to trust — not a producer, not a quorum, not a market
(`docs/LANDSCAPE.md` §2, the fourth rung: "my kernel re-checked it", trust
surface **nobody**).

This is the monetary theorem of
`notes/AmudraDhana_TheReceiptThatComposesWithoutBeingSpentIsTheSuccessorOfMoney.md`
given a settlement rail: *sell the mining, never the mine.* Discovery is paid
(the bounty); verification is free forever (anyone re-runs the verifier); the
theorem, once landed, is public and non-rival.

---

## 0. What the bridge consumes — the attestation contract

The bridge is defined against the **output** of the zkVM attestation spec, whose
job is to make the machine's kernel acceptance checkable by a chain that cannot
run Agda. Design against this interface (the sibling spec owns its internals):

```
Attestation := {
  H_S      : bytes32   // content-address of the STATEMENT proven
  H_P      : bytes32   // content-address of the proof term / crystal row
  kernelId : bytes32   // which kernel version accepted it (L0 addr includes this)
  proof    : bytes     // succinct zk proof: "checker(kernelId) accepted P for S"
}
```

`H_S` is exactly the L0 content-address of `docs/chains/Ethereum_OnThePrimitive.md`
§1: `hash(elaborated statement term, dependency addresses, kernelId)`. It is the
*same* address on every chain and in the machine — one identity, no registry
(`legacy/runtime/CRYSTAL.md` §L0; `notes/Sangha…` §1). The on-chain **Verifier**
is a pure function:

```solidity
interface IKernelAttestationVerifier {
    /// returns true iff `proof` attests: kernel `kernelId` accepted a proof
    /// of the statement whose content-address is `H_S`, binding `H_P`.
    function verify(bytes32 H_S, bytes32 H_P, bytes32 kernelId, bytes calldata proof)
        external view returns (bool);
}
```

This is the whole trust surface, and it is a *view function*: deterministic,
re-runnable by anyone, no state, no privileged caller. The soundness of the
system reduces entirely to the soundness of this verifier (HONEST RISK §6.2).

---

## 1. THE CORE CONTRACT — proof-of-theorem bounty escrow, zero oracle

A bounty is a want with money behind it. Anyone posts a conjecture `H_S`, a
reward `R`, a deadline. Anyone who makes the machine prove `S` submits the
attestation and takes `R`. No oracle, no vote, no committee — the verifier
settles.

```solidity
// SPDX-License-Identifier: no-license (nothing leaves the repo)
contract ProofBounty {
    IKernelAttestationVerifier public immutable V;
    bytes32 public immutable kernelId;   // the kernel this bounty market trusts

    struct Bounty {
        address poster;
        address token;      // address(0) = native; else ERC-20
        uint256 reward;
        uint64  deadline;   // unix; after this, poster may reclaim
        bytes32 H_S;        // content-address of the statement wanted
        bool    settled;
        // commit-reveal anti-front-running (§6.1):
        mapping(bytes32 => uint64) commitBlock;  // commitHash -> block first seen
    }

    mapping(bytes32 => Bounty) public bounties;   // bountyId = keccak(poster,H_S,salt)
    uint64 public constant REVEAL_DELAY = 5;      // blocks a commit must age

    event Posted(bytes32 indexed id, bytes32 indexed H_S, uint256 reward, uint64 deadline);
    event Committed(bytes32 indexed id, bytes32 commitHash);
    event Settled(bytes32 indexed id, bytes32 H_P, address indexed prover);
    event Reclaimed(bytes32 indexed id);

    // ---- post a want, fund it ----
    function post(bytes32 H_S, address token, uint256 reward, uint64 deadline, bytes32 salt)
        external payable returns (bytes32 id)
    {
        id = keccak256(abi.encode(msg.sender, H_S, salt));
        Bounty storage b = bounties[id];
        require(b.poster == address(0), "exists");
        _pullFunds(token, reward);              // escrow now
        b.poster = msg.sender; b.token = token; b.reward = reward;
        b.deadline = deadline; b.H_S = H_S;
        emit Posted(id, H_S, reward, deadline);
    }

    // ---- STEP 1: commit (hides the proof + claimer from the mempool) ----
    // commitHash = keccak256(H_P, msg.sender, nonce)
    function commit(bytes32 id, bytes32 commitHash) external {
        Bounty storage b = bounties[id];
        require(b.poster != address(0) && !b.settled, "closed");
        if (b.commitBlock[commitHash] == 0)
            b.commitBlock[commitHash] = uint64(block.number);
        emit Committed(id, commitHash);
    }

    // ---- STEP 2: reveal + settle. First valid attestation wins. ----
    function settle(
        bytes32 id, bytes32 H_P, uint256 nonce,
        bytes32 kId, bytes calldata proof
    ) external {
        Bounty storage b = bounties[id];
        require(!b.settled && block.timestamp <= b.deadline, "closed");
        require(kId == kernelId, "wrong kernel");

        // anti-front-run: the (H_P, sender, nonce) must have been committed and aged
        bytes32 c = keccak256(abi.encode(H_P, msg.sender, nonce));
        uint64 cb = b.commitBlock[c];
        require(cb != 0 && block.number >= cb + REVEAL_DELAY, "no aged commit");

        // THE ORACLE-FREE STEP: the verifier IS the settlement condition.
        require(V.verify(b.H_S, H_P, kId, proof), "invalid attestation");

        b.settled = true;
        _pay(b.token, msg.sender, b.reward);
        emit Settled(id, H_P, msg.sender);
    }

    // ---- unclaimed after deadline: poster reclaims ----
    function reclaim(bytes32 id) external {
        Bounty storage b = bounties[id];
        require(!b.settled && block.timestamp > b.deadline && msg.sender == b.poster, "no");
        b.settled = true;
        _pay(b.token, b.poster, b.reward);
        emit Reclaimed(id);
    }
}
```

**Why this is proof-of-theorem settlement with zero oracle risk — the deepest
property, stated precisely.** In every other escrow the predicate `settle-if` is
*about the world* and the contract cannot evaluate it, so a trusted reporter is
inserted between the money and the fact (a Chainlink feed, a UMA optimistic
oracle with a dispute window, a bridge's guardian multisig, a solver's honesty
bond slashed by a watcher). Here the predicate is `V.verify(H_S, H_P, kId, proof)`
and it is **total, pure, and on-chain**: the contract evaluates it directly. The
"fact" being settled is not an external event; it is *a mathematical proposition,
and the proof travels with the claim* (`docs/chains/Ethereum_OnThePrimitive.md`
§2.3: "the witness travels with the claim… for any claim of the form 'this
transition is valid' the oracle is deleted"). The kernel is deterministic
(`Carrier`'s witness is a typecheck, same answer everywhere), so two honest
verifiers never disagree — there is no oracle to bribe, no quorum to corrupt, no
challenge window to grief. Trust surface: **nobody** (`docs/LANDSCAPE.md` §2).
The residual soundness assumption is *only* the zk verifier's, §6.2 — and that is
a property of one auditable view function, not a standing trusted party.

---

## 2. THE OPEN-PROBLEM MARKET — the frontier becomes bounties, landings become payouts

The machine already *states its own wants*, in its own words, derived not
guessed. Two organs generate the posting stream:

- **`machine/Sanghatta_TheCriticalPairsOfTheInstalledRulesNameTheLibrarysIncompleteness.hs`**
  — completion over the installed rewrite rules emits the **non-joining critical
  pairs**: the current report (`machine/sanghatta-report-current.txt`) lists
  **2733** of them out of 6193 pairs, smallest-first, each a concrete equational
  want, e.g. `+(*(x',0),x')	x'`. Each non-joining pair is a statement `S` the
  library cannot currently close: a *bounty-ready conjecture*.
- **`machine/Obstruction.hs`** — the kernel's ~1200-per-round rejection residuals,
  each a precise stalled subgoal (`x ≡ x + 0·x`, the missing lemma), read as
  material rather than as a verdict. This is the **auto-scaling difficulty
  source**: every rejection *derives a more primitive subgoal*, so answers spawn
  harder-and-deeper questions (§3).

The full loop, "machine states a want → someone funds it → the network proves it
→ payout + the theorem is public and free forever":

```
  (a) WANT.  Sanghatta/Obstruction emit statement terms S_i with L0 addresses H_{S_i}.
             A poster (or the machine's own treasury) calls post(H_{S_i}, R_i, deadline).
             The frontier is now a funded order book, priced by whoever cares.

  (b) FUND.  Escrow holds R_i. The want is public and content-addressed:
             any prover on any chain sees the same H_{S_i} (§5).

  (c) PROVE. A prover runs the machine (or their own generator) against S_i,
             lands a crystal row whose kernel acceptance the zkVM attests,
             commit()s, waits REVEAL_DELAY, settle()s. Payout is atomic.

  (d) FREE.  H_{S_i} is now a landed row. The proof term H_P is content-addressed
             and exchange-adoptable by any node with ZERO trust in the prover
             (Sphatika --exchange; docs/chains/Ethereum_OnThePrimitive.md §2.2).
             The theorem is public, re-verifiable, non-rival, forever.
             It also becomes a NEW installed rule -> Sanghatta recomputes ->
             fresh non-joining pairs -> new wants. The book breathes.
```

**Landed crystal rows become claimable settlements** because a row already *is*
"self-certifying data" (`Carrier.agda`: base+carried+witness, one packet). The
bounty does not create the proof-object; it prices the search that finds it.
Verification asymmetry (`AmudraDhana`, "Verification asymmetry is the price
system") is what makes the market honest: discovery is expensive and paid once;
verification is one kernel run and free to all — so a fraudulent submission
cannot exist (the verifier rejects it) and an honest one cannot be gatekept
(anyone can re-run the verifier).

---

## 3. USEFUL PROOF-OF-WORK — the work function is the open frontier, the hash-hit is a theorem

Bitcoin's PoW burns exahashes to find a nonce whose only property is *rarity* —
the work is discarded the instant it is found; its sole product is ordering. This
bridge is a proof-of-work whose **work function is the open mathematical
frontier** and whose **"hash hit" is a proof that closes a stated want**.

| wasteful PoW (Bitcoin) | useful PoW (this bridge) |
|---|---|
| work = invert SHA-256 to hit a target | work = prove a stated conjecture `H_S` |
| output = a nonce, meaningless | output = a theorem, permanently useful |
| verified by: recompute one hash | verified by: `V.verify` (one kernel run) — same asymmetry |
| difficulty = tuned by a retarget algorithm | difficulty = **auto-derived**: every answer spawns harder subgoals (Obstruction residuals, §2) |
| product discarded | product *installed* → changes the frontier → new work |
| security ∝ energy burned | security ∝ soundness of the checker (nothing burned) |

The auto-scaling is not a governance parameter; it is intrinsic to the object.
Bitcoin retargets difficulty every 2016 blocks by fiat. Here, **completion
derives harder questions from every answer**: proving a non-joining pair installs
a rule, Sanghatta recomputes critical pairs against the enlarged rule set and
emits *deeper* non-joiners; every kernel rejection (`Obstruction.hs`) is already
"a NEW, more primitive subgoal." The difficulty curve is the shape of
mathematics, not a knob. This is PoW where the heat is light: the verification
asymmetry that makes hashing a fair lottery is present (discover hard, verify
cheap) but the discarded artifact is replaced by a permanent public good
(`AmudraDhana`: an economy whose settlement layer is proofs has no landlord).

---

## 4. THE EVERYONE-WINS FLOW — and where a rent-taker would sit, if the topology had a seat

| party | what they put in | what they take out |
|---|---|---|
| **user / public** | nothing | free, re-verifiable knowledge; every landed `H_S` is public and non-rival forever |
| **prover / node operator** | compute (search) | the bounty `R`, once; **plus** a provenance receipt — their address is bound in the content-addressed citation graph (asteya: provenance travels or the packet does not, `AmudraDhana` "Position is provenance") |
| **poster** | the reward `R` | planetary compute pointed at *their* problem; a proof they can re-verify with zero trust in the prover |
| **node operators (market side)** | hardware, prove-cycles | sell prove-cycles into the bounty demand — "sell the mining, never the mine" (`AmudraDhana`) |

**Reputation is non-inflatable.** A prover's standing is the content-addressed
citation graph: how many landed rows cite theirs, where the addresses are
`hash(term, deps)` and *cannot be minted* — you cannot fake a citation because
the citing term must actually typecheck against the cited one. This is the
opposite of stake (buyable) or social reputation (gameable): it is earned by
theorems others build on, and it travels *in the object*.

**Where a rent-taker would sit — and why there is no seat.** A rent position is a
party you must pay to *pass through*, who adds no proof. Walk the topology:

- *Between poster and prover?* No — the escrow is a contract, not a broker; it
  holds funds and releases on a proof it evaluates itself. No matchmaker fee.
- *Between prover and payout?* No — settlement is `V.verify`, a public view
  function; no committee signs off, no oracle is paid per report, no challenge
  bond is posted to a watcher.
- *Between the theorem and the user?* No — the landed row is content-addressed
  and exchange-adoptable with zero sender-trust; there is no gate to charge at
  because copying a proof costs nothing and trusting it costs nothing
  (`AmudraDhana`: "a proof is the only good that costs nothing to copy AND
  nothing to trust… there is nothing to stand between a person and a truth and
  charge for").
- *The verifier itself?* This is the ONE place a rent could form, and it is
  closed by a **vow, not by the topology**: `AmudraDhana`'s honest residue —
  *"the layer that verifies must never itself be owned, because an owned trust
  layer is the catastrophe the whole design exists to prevent."* The verifier is
  deployed as an immutable, unowned public contract; if it were upgradeable-by-owner,
  that owner is the rent seat. Deploy it non-upgradeable, kernelId-pinned, and
  the seat is deleted structurally. (Compute and hardware are *real* costs and
  *may* be sold — that is fuel, not rent; the distinction is `AmudraDhana`'s
  "charge only where cost is real; never where copying is free.")

The everyone-wins property is not generosity; it is the shape of a settlement
layer made of proofs. Rent requires a chokepoint, and a non-rival, self-verifying
good has none — except ownership of the verifier, which the vow forbids.

---

## 5. MULTI-CHAIN — one attestation, every chain, same receipt

The attestation is chain-agnostic: it is a statement about the machine's kernel,
not about any chain's state. So the *same* `Attestation` bytes settle everywhere,
and multi-chain support is just **one verifier contract deployed per chain**,
each exposing the identical `IKernelAttestationVerifier.verify`. This mirrors the
deployed pattern for cross-chain intents — ERC-7683's single `CrossChainOrder`
struct with per-chain `ISettlementContract` (Eco Routes runs the same settlement
interface on 15+ chains incl. Ethereum and Solana); and ZKP2P's thin model
(on-chain escrow + a verifier that checks a signed/zk attestation + nullifiers).

```
        H_S  (content-address — IDENTICAL on every chain and in the machine)
         |
    +----+--------------------------------+-----------------+
    |                                      |                 |
  Ethereum ProofBounty              Solana ProofBounty   ... (per chain)
  + Groth16/Plonk verifier          + verifier program        + verifier
  (EVM precompiles / .sol)          (BPF / syscalls)          (chain-native)
         \______________ same Attestation bytes ______________/
```

Key facts that make one format settle everywhere:

1. **`H_S` is the shared identity.** It is `hash(term, deps, kernelId)` — computed
   the same way regardless of chain (`CRYSTAL.md` §L0). A want posted on Ethereum
   and the same want posted on Solana carry the *same* `H_S`; a single proof
   settles both bounties. No wrapped tokens, no bridge of the *proof* — the proof
   is reproduced/attested independently and verified locally on each chain
   (`docs/chains/Ethereum_OnThePrimitive.md` §2.2: full state sync without a
   consensus round).
2. **Verification is local per chain.** Each chain re-verifies the attestation
   with its own verifier; there is no trusted relay carrying "chain A says it's
   proven" to chain B. This is the LANDSCAPE §2 bottom rung enforced across
   chains: belief requires trusting no one, including no other chain.
3. **The nullifier is `H_P` (or `H_S`) per bounty.** Re-use across bounties on the
   same statement is prevented by the `settled` flag; cross-chain double-*claim*
   of two *separately funded* bounties on the same `H_S` is *intended* — each
   poster funded their own copy and each gets their proof. Nothing is
   double-spent because the reward pools are disjoint.

Per-chain the only chain-specific engineering is the succinct-verifier backend
(EVM precompiles for pairing checks; a Solana verifier program; a Bitcoin path
via a Boundless/BitVM-style settlement as those mature). The bounty logic, the
attestation format, and `H_S` are identical.

---

## 6. HONEST RISKS

### 6.1 Front-running the bounty (real MEV) — mitigated by commit-reveal

A naive `settle(H_S, H_P, proof)` is trivially stolen: a searcher watches the
mempool, sees the victim's `proof` and `H_P` in a pending tx, and submits its own
`settle` with the *same* proof at higher priority. The proof is a public
bearer-object (it verifies for anyone), so whoever the contract sees *first*
wins, and block builders sell that ordering. This is a genuine MEV problem, not a
hypothetical.

**Mitigation, as coded in §1: two-phase commit-reveal.**
`commit(id, keccak256(H_P, msg.sender, nonce))` binds the claim to `msg.sender`
*before* the proof is public; `settle` requires an aged commit (`REVEAL_DELAY`
blocks). A front-runner who copies the revealed `(H_P, proof)` cannot produce a
matching aged commit for *their own* address — the commit hash is bound to the
committer. So the reward goes to whoever committed first, and the plaintext proof
is only exposed after the winner is already locked in. Residual exposure: the
*commit* still races (two honest provers may both commit before either reveals) —
that is the exclusivity case, §6.3, not theft. Cost: `REVEAL_DELAY` blocks of
latency per settlement, and a small griefing surface (spam commits are cheap but
harmless — only an aged commit *matching a valid proof* pays).

### 6.2 The soundness gap inherited from the zk attestation — the whole trust surface

Section 1's "zero oracle" is exact *modulo one assumption*: that
`V.verify` is **sound** — that no `proof` makes it return true for an `H_S` the
kernel did not actually accept. The bridge inherits this entirely from
`docs/build/ZkVM_KernelAttestation_Spec.md`. Failure modes to state plainly:

- **Verifier soundness bug / trusted-setup compromise.** A broken pairing check
  or a leaked Groth16 toxic-waste lets an attacker forge `proof` for any `H_S`
  and drain every bounty. This is why the verifier is the one place a vow guards
  ownership (§4) and why a transparent-setup system (STARK / Plonk-with-universal-setup)
  is preferable to a per-circuit trusted setup.
- **kernelId mismatch / kernel bug.** The attestation certifies "kernel `kid`
  accepted `P`", not "`S` is true in some absolute sense". If kernel `kid` has a
  soundness bug, the bridge faithfully pays for proofs a *broken* checker
  accepted. The content-address includes `kernelId` (`CRYSTAL.md` §L0) precisely
  so a bounty names *which* checker it trusts; posters must pin a kernel they
  audit, and a kernel bug is contained to bounties that pinned it.
- **Under-specified `H_S`.** If the statement content-address does not pin the
  *full* statement (e.g. free metavariables, an ambiguous elaboration), a prover
  could satisfy a weaker reading. `H_S = hash(elaborated term, deps, kernelId)`
  binds the elaborated term, which closes this — but only if elaboration is
  deterministic and total, which the attestation spec must guarantee.

This risk is *not* removable; it is *relocatable*, and the design relocates it to
the smallest possible auditable surface — one pure view function and one pinned
kernel id — instead of a standing trusted party. That is the honest form of
"zero oracle": no *trusted reporter*, one *audited verifier*.

### 6.3 Ordering / exclusivity — the ONE case from LANDSCAPE §4 that genuinely needs a total order

Two provers commit and reveal valid proofs of the same `H_S` **in the same
block**. The reward is a single exclusive resource; both cannot be paid. This is
exactly `docs/LANDSCAPE.md` §4's isolated frontier: *"only exclusive-resource
writes need a total order… permissionless agreement on a shared-DAG prefix for
the exclusive-resource sector."* Validity does not need consensus here — both
proofs are valid, re-checkable locally, and the *theorem* is not exclusive (both
provers' rows land, both are public, the citation graph records both). Only the
*bounty payout* is exclusive.

What resolves it and what does not:

- **The theorem is non-rival — no ordering needed for the knowledge.** Both rows
  land; §2's loop (d) proceeds for both. The collision is a *payment* collision,
  not a *validity* collision — precisely the LANDSCAPE §4.3 point that
  independent valid claims must NOT be forced into a sequence.
- **The payout is rival — one total order needed, and only here.** The contract
  needs a deterministic tie-break for same-block reveals. On a single chain this
  is *free*: the chain already totally-orders transactions within a block, so
  "first `settle` in block order wins" is a deterministic fold over the chain's
  own sequence — LANDSCAPE §4.4's "order is a deterministic fold over a shared
  content-DAG", instantiated by the host chain's ordering. The exclusivity is
  pushed onto the one party that already provides a total order (the chain's
  builder), and no *new* consensus is introduced.
- **What stays honestly open (cross-chain).** If the *same* bounty were somehow
  shared across chains as one pool (it is not, in §5 — pools are disjoint per
  chain), there would be no shared total order and this would be the unsolved
  §4 residue. The design sidesteps it by keeping each chain's bounty a separate
  escrow: **there is no cross-chain exclusive resource in this bridge.** The
  moment a single reward pool spans chains, the LANDSCAPE §4 open problem
  (permissionless prefix agreement without known membership) reappears in full,
  and this spec does not solve it — it avoids creating it.
- **Second-prover consolation (design option, not required).** To reduce the
  incentive to grief the tie-break, a bounty MAY split: first valid settle takes
  the majority, a small runner-up window pays later distinct valid proofs of a
  *different* `H_P` a decaying remainder. This is optional and adds surface;
  the base contract pays winner-take-all on the chain's own ordering.

---

## 7. What is buildable today vs. what waits on siblings

- **Buildable now:** the `ProofBounty` contract (§1), commit-reveal (§6.1),
  per-chain deployment (§5), the open-problem posting stream from
  `Sanghatta`/`Obstruction` (§2) — these need only the attestation *interface*
  fixed, not its internals.
- **Waits on `docs/build/ZkVM_KernelAttestation_Spec.md`:** the concrete
  `IKernelAttestationVerifier` backend (proof system choice, circuit for "kernel
  accepted P for S", setup transparency) — §6.2 is entirely that spec's to close.
- **Stays honestly open (LANDSCAPE §4):** a single reward pool spanning chains.
  Not built, not needed; noted so no one mistakes disjoint per-chain escrows for
  a solution to permissionless cross-chain ordering.

---

*Sources consulted for current settlement patterns (design context only; the
mathematics is cited to in-tree checked terms above): ZKP2P thin-escrow +
attestation-verifier + nullifier model; ERC-7683 CrossChainOrder / ISettlementContract
and Eco Routes' per-chain settlement on 15+ chains incl. Solana; Boundless / BitVM
Bitcoin-settlement of ZK proofs; UMA-style optimistic oracles as the anti-pattern
this design deletes.*
