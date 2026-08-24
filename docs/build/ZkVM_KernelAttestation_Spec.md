# zkVM kernel attestation — a buildable spec for settling a landed theorem on-chain

*Engineering spec, not a landed result. No Agda is invented here; every claim
about the proof language cites the module that defines it. This document
designs an EXTERNAL organ (a succinct, portable form of the Carrier witness)
and is explicit at every step about the trust it ADDS relative to the local
Agda recheck that is the machine's actual trust primitive. Read `docs/LANDSCAPE.md`
§2 first: this spec moves one rung, and states the cost of the move plainly.*

---

## 0. What this is and what it trades

The machine's trust primitive is stated in `docs/ARCHITECTURE.md` §3 and §6:
a datum ships as a Carrier (base + carried + witness), and **belief = the
receiver re-runs its own Agda kernel** (`agda --safe`, exit 0) over the whole
context. `machine/Sphatika_….hs --exchange` is that primitive fired: a peer's
rows are re-judged, citation-remapped, one ordered pass, refusals receipted
(`exchange`/`adoptAll`, lines 349–398). Trust surface: **nobody** — the
receiver trusts only its own kernel.

This spec asks a narrower question than "settle the machine on-chain": **how
does a party that will NOT run Agda — an EVM contract, gas-metered, with no
filesystem and a ~30M-gas block — come to hold a settled fact that theorem
`S` has a checked proof?** A smart contract cannot `agda --safe`. The only
thing it can do cheaply is verify a ~200–300k-gas SNARK. So the design is:

> replace "the receiver re-runs the kernel" with "the receiver verifies a
> zk proof that SOMEONE ELSE ran a checker, and that checker accepted proof
> `P` for statement `S` whose content-address is `H`."

**This is a strictly weaker belief than the local recheck, and the whole
value of the spec is in naming exactly how much weaker (§6).** It buys
portability and succinctness — the Carrier witness made 300k-gas-verifiable
and permanently on-chain — at the price of two new trust assumptions the
local kernel does not have: the zkVM's soundness/trusted-setup, and the gap
between the mini-checker and Agda's actual kernel. Those are the honest
subject of §6. Nothing here weakens the local loop; on-chain settlement is an
*additional, advertised, lower-trust* channel, exactly the `Approx(ε) edge
that remembers its ε` discipline (`docs/LANDSCAPE.md` §3) applied to trust
itself.

---

## 1. The guest program: two honest options

The zkVM guest is a RISC-V (or equiv.) program compiled to the zkVM's ISA; the
prover runs it on a private input (the *witness*) and produces a receipt
attesting the program ran and produced a public output (the *journal*). What
runs inside is the whole design question.

### Option (a): run Agda-the-typechecker as the guest — assessed, rejected

**What it would mean.** Compile GHC-built Agda (the actual `--safe` kernel)
to the zkVM target, ship `Cubical.Data.Nat` + the rendered `Sphatika.agda`
context as guest input, run elaboration + typechecking inside the zkVM, and
journal the result. This is the *maximally faithful* option: the thing proven
is literally "Agda accepted it," so there is **no checker-vs-kernel gap**
(§6's second gap vanishes).

**Why it is infeasible today, honestly.**

1. **Agda is a large GHC program.** It depends on the GHC RTS (garbage
   collector, threading, exceptions), a serialization layer, a build
   system, and megabytes of `Cubical` library source. zkVMs execute RISC-V;
   running GHC's RTS as a guest means either a RISC-V GHC runtime or a
   whole-program compile of a lazy, GC'd, exception-driven interpreter into
   a circuit-friendly straight-line trace.
2. **Cycle count.** zkVM proving cost is roughly linear in executed RISC-V
   cycles. A moderately complex computation is 10–50M cycles and takes tens
   of seconds to minutes on GPU provers (RISC Zero R0VM 2.0 / Bonsai, Q1
   2026; SP1 Hypercube). A single Agda `--safe` check of even a small module
   — interface loading, unification, the cubical `transp`/`hcomp` machinery,
   universe checking — is *billions* of instructions including allocator
   traffic. That is 2–4 orders of magnitude beyond the current comfortable
   envelope; it does not fit in one receipt and the recursion/continuation
   plumbing to split it is itself a research project.
3. **Nondeterminism and I/O.** Agda reads `.agdai` interface caches, touches
   the filesystem, and its performance leans on lazy evaluation and mutable
   IORef state — all of which are exactly what a deterministic, I/O-free
   guest execution model makes expensive or forbidden.

**Verdict:** (a) is the faithful option and the wrong one. It is worth
keeping on the roadmap only as the thing (b) is measured against.

### Option (b): a minimal independent proof-checker as the guest — RECOMMENDED

The crystal's proofs are NOT arbitrary Agda. They are terms of a tiny,
closed proof language — `data Proof` in
`machine/KernelContext.hs:312–334` — with exactly seven constructors:

```
PRefl | PIh | PCite String [Term] | PSym Proof
| PTrans Proof Proof | PCong Term Proof | PInduction Int Proof Proof
```

over terms `data Term = V !Int | F !String [Term]`
(`machine/KernelContext.hs:203`). The crystal file
(`machine/sphatika.crystal`) is one row per theorem:

```
sp004   x   *(x,s(0))   ind 0 refl congsuc
sp030   +(+(x,0),y)   +(x,y)   ind 0 refl congsuc
```

i.e. `id \t lhs \t rhs \t proof` where the proof is the serialized `Proof`
(the reader/writer are `readProof`/`showProof`,
`machine/Sphatika_….hs:100–129`). This is a **few-hundred-line checker's**
worth of language, not a dependently-typed kernel. The guest is:

> **parse `(statement, proof, earlier-lemmas)` → verify the proof discharges
> the statement by the SAME reduction+induction semantics the Agda rendering
> relies on → output `H = hash(canonical statement)` as the public journal.**

**What the checker must implement**, read straight off `renderLemma` /
`renderProof` (`machine/KernelContext.hs:483–568`) and the operator
reductions of `Cubical.Data.Nat`:

1. **A normalizer / definitional-equality decider for the ℕ fragment.** The
   symbols are fixed: `0`, `s` (suc), `+`, `*`, `-`, `max`, `le`, `gcd`
   (`kReservedHere` and `pName`, `KernelContext.hs:246–251, 411–416`). The
   reduction rules must match cubical Agda's `Cubical.Data.Nat` *exactly*,
   including the load-bearing asymmetry the corpus already documents: `_+_`
   recurses on its **first** argument, so `zero + x` reduces but `x + zero`
   does not (`KernelContext.hs:781–783`). `PRefl` checks by: normalize both
   sides under these rules with the lemma's variables held abstract, compare
   for syntactic identity.
2. **`PCite name args`** — look up `name` among the earlier lemmas in this
   context, check arity (`equationVarsT`, `KernelContext.hs:280`), substitute
   `args` for its telescope variables, and use the resulting equation as a
   rewrite/appeal: the cited instance's `lhs≡rhs` is available as a proven
   equation. Scope and arity are exactly the `UnknownLemma` / `ArityMismatch`
   / `SelfCitation` refusals (`KernelContext.hs:533–543`).
3. **`PSym` / `PTrans`** — symmetry and transitivity of the equational
   judgment (`sym`, `_∙_` in the rendering, `KernelContext.hs:545–552`).
4. **`PCong ctx sub`** — a one-hole context with the hole = the unique
   variable of `ctx` not bound by the lemma (`holeFor`,
   `KernelContext.hs:340–343`; `HoleMissing`/`AmbiguousHole` when zero/≥2).
   Check `sub` proves the sub-equation, then congruence closes the goal.
5. **`PInduction i base step`** — structural induction on `V i`: check `base`
   under `[V i := 0]`, check `step` under `[V i := s(V i)]` with `PIh` bound
   to the equation at the predecessor (`renderLemma`'s two clauses,
   `KernelContext.hs:494–507`; `PIh` legal only inside a step,
   `IhOutsideInduction`, `KernelContext.hs:524–525`). **No nested
   induction** (`NestedInduction`, `KernelContext.hs:565`) — the same
   restriction the renderer enforces, which keeps the checker's recursion
   structurally bounded.

**Checker shape (pseudocode; not Agda, a sketch of the guest):**

```rust
// ---- guest (zkVM), deterministic, no I/O ----
enum Term { V(u32), F(Sym, Vec<Term>) }         // Sym ∈ {O,S,Add,Mul,Sub,Max,Le,Gcd}
enum Proof { Refl, Ih, Cite(LemId, Vec<Term>), Sym(Box<Proof>),
             Trans(Box<Proof>,Box<Proof>), Cong(Term, Box<Proof>),
             Induction(u32, Box<Proof>, Box<Proof>) }
struct Lemma { id: LemId, lhs: Term, rhs: Term, proof: Proof }

// normalize under the FIXED ℕ reduction rules (must mirror Cubical.Data.Nat).
// vars held abstract; returns a canonical normal form. Fuel-bounded: a fuel
// exhaustion is a REFUSAL, never a silent accept (fail-closed, §6).
fn nf(t: &Term, env: &Subst, fuel: &mut u64) -> Result<Term, Refuse>;

// check that `proof` proves `lhs ≡ rhs` in the context of `earlier` lemmas.
fn check(lhs:&Term, rhs:&Term, proof:&Proof, earlier:&[Lemma],
         ih: Option<&(Term,Term)>, fuel:&mut u64) -> Result<(), Refuse> {
  match proof {
    Refl        => eq_nf(lhs, rhs, fuel),              // both normalize equal
    Ih          => match ih { Some((l,r)) => eq_up_to(lhs,rhs,l,r,fuel),
                              None => Err(IhOutsideStep) },
    Cite(n,a)   => { let lm = lookup(earlier,n)?;      // scope + arity
                     arity_ok(lm,a)?; no_self(n)?;
                     let inst = subst_eq(lm, a);        // cited instance
                     appeal(lhs, rhs, &inst, fuel) },
    Sym(p)      => check(rhs, lhs, p, earlier, ih, fuel),
    Trans(p,q)  => { let m = /* shared midpoint, from the rendering */;
                     check(lhs,&m,p,earlier,ih,fuel)?; check(&m,rhs,q,earlier,ih,fuel) },
    Cong(c,p)   => { let h = hole_for(c, lhs, rhs)?;    // exactly one extra var
                     let (a,b) = split_hole(c,h,lhs,rhs)?;
                     check(&a,&b,p,earlier,ih,fuel) },
    Induction(i,base,step) => {
        let b_env = subst(i, Term::zero());
        check(&app(lhs,&b_env), &app(rhs,&b_env), base, earlier, None, fuel)?;
        let s_env = subst(i, Term::suc(Term::V(*i)));
        let ih_eq = (lhs.clone(), rhs.clone());         // at the predecessor
        check(&app(lhs,&s_env), &app(rhs,&s_env), step, earlier, Some(&ih_eq), fuel)
    }
  }
}

// ---- driver over the whole crystal context ----
fn main() {
  let (ctx, target): (Vec<Lemma>, LemId) = read_private_input();  // the witness
  for (k, lm) in ctx.iter().enumerate() {
     let earlier = &ctx[..k];
     check(&lm.lhs, &lm.rhs, &lm.proof, earlier, None, &mut FUEL)
        .expect("REFUSED");                              // guest panics ⇒ no receipt
  }
  let s = &ctx[index_of(target)];
  let h = keccak(canonical_bytes(&s.lhs, &s.rhs));       // content-address
  commit_journal(h);                                     // public output = H
}
```

Two design commitments that make (b) sound *as a checker*:

- **Fail-closed everywhere.** Every refusal in `KernelContext.Refusal`
  (`KernelContext.hs:363–384`) becomes a guest panic → no receipt is
  produced. A fuel-exhausted normalizer is a refusal, never an accept. There
  is no path from "checker unsure" to "journal emitted."
- **The whole context is checked, not one lemma.** Just as `checkContext`
  checks the full ordered context (`ARCHITECTURE.md` §2, "checks the full
  context, never a lemma alone"), the guest verifies every earlier lemma a
  citation depends on, so `H` attests a *self-contained* proof, not a leaf
  that trusts unshown parents.

**Cost of (b).** This is a few thousand RISC-V cycles per proof node for the
current crystal (small ℕ terms, shallow induction, ≤200 lemmas). Well inside
one receipt, seconds to prove. This is the entire reason to prefer (b): it
turns a 300k-gas on-chain fact into an *achievable* proving job, where (a) is
not achievable at all.

---

## 2. The attestation: the Carrier witness made succinct and portable

The zk receipt attests exactly one sentence:

> "I executed program `imageId` (the pinned checker binary) on some private
> input, it ran to completion (did not panic), and it committed journal
> `H`."

Read against the checker in §1, that unfolds to: **"there exists a context of
lemmas, each proof-checked against all earlier ones by the pinned checker,
whose target statement content-addresses to `H`."** The private input is the
`(statement, proof, earlier lemmas)` — never revealed on-chain; only `H` and
the receipt are public.

**Why this is the Carrier witness, succinct.** A Carrier is `base + carried +
witness : f base ≡ carried` (`Punaragamana/Carrier.agda`; `ARCHITECTURE.md`
§1). The on-chain object is:

| Carrier field | on-chain analogue |
|---|---|
| `carried` (the claimed image/summary) | `H`, the content-address of statement `S` |
| `witness : f base ≡ carried` | the zk receipt |
| re-running the kernel to believe it | verifying the receipt (300k gas) |

The receipt IS the witness — `f base ≡ carried` transported out of the Agda
kernel into a form a gas-metered verifier can check. The corpus already
names this cell: `docs/chains/Ethereum_OnThePrimitive.md` §1, "zk-rollup →
the native form here — the proof *is* the state." This spec is the wire for
that row. What it does NOT claim: that verifying the receipt is the same act
as running Agda. It is a *different, weaker* witness for the same statement,
and §6 is where that difference lives.

---

## 3. The on-chain interface

Both leading zkVMs ship audited Solidity verifiers that verify a Groth16
(BN254) wrapper of the zkVM receipt in a single call. Concrete, current
numbers (Q1 2026):

- **RISC Zero.** On-chain `RiscZeroVerifier.verify(seal, imageId,
  journalDigest)`; Groth16 wrapper; measured on-chain verification **≈250k
  gas** (some integrations report ≈290k with calldata). R0VM 2.0 (April 2025)
  cut proving to tens of seconds and added formal verification of most
  RISC-V circuits. Trusted setup: a 2024 multi-party Groth16 ceremony.
  ([RISC Zero on Ethereum](https://dev.risczero.com/api/blockchain-integration/risc-zero-on-eth),
  [security model](https://dev.risczero.com/api/security-model))
- **SP1 (Succinct).** `ISP1Verifier.verifyProof(programVKey, publicValues,
  proofBytes)`; Groth16 **or** PLONK wrapper; Groth16 verification **≈300k
  gas**. SP1 Hypercube (2025) proves ~99.7% of L1 blocks under 12s on 16
  GPUs. ([ISP1Verifier.sol](https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/ISP1Verifier.sol),
  [SP1 Hypercube](https://blog.succinct.xyz/real-time-proving-16-gpus/))

For reference, raw Groth16 on BN254 is ≈`(200 + 6ℓ)` kgas for `ℓ` public
inputs ([Groth16 gas, HackMD](https://hackmd.io/@nebra-one/ByoMB8Zf6));
the zkVM verifiers land in the 250–300k band. Jolt (a16z) and Nexus are
noted in §5 as not-yet-appropriate.

### The settlement contract (sketch, SP1 flavor)

```solidity
interface ISP1Verifier {
  function verifyProof(bytes32 programVKey, bytes calldata publicValues,
                       bytes calldata proofBytes) external view;
}

contract TheoremRegistry {
  ISP1Verifier public immutable verifier;
  bytes32     public immutable checkerVKey;   // pins THE checker binary (§1b)
  mapping(bytes32 => uint256) public settledAt;   // H => block number
  event Settled(bytes32 indexed statementHash, address indexed submitter);

  constructor(address v, bytes32 vkey) { verifier = ISP1Verifier(v); checkerVKey = vkey; }

  // publicValues encodes the journal = H (the statement content-address)
  function settle(bytes calldata publicValues, bytes calldata proofBytes) external {
    verifier.verifyProof(checkerVKey, publicValues, proofBytes);   // reverts if invalid
    bytes32 H = abi.decode(publicValues, (bytes32));
    if (settledAt[H] == 0) { settledAt[H] = block.number; emit Settled(H, msg.sender); }
  }
  function isSettled(bytes32 H) external view returns (bool) { return settledAt[H] != 0; }
}
```

`checkerVKey`/`imageId` is the load-bearing pin: it fixes *which program's*
acceptance the chain will believe. Change the checker, change the key — the
registry never silently accepts a different checker's verdict. (RISC Zero
flavor: swap `verifyProof(vkey,…)` for `verify(seal, imageId,
journalDigest)`, store `imageId` in place of `checkerVKey`.)

**Chains.** Any EVM chain with the deployed verifier: Ethereum L1 (≈250–300k
gas ≈ a few dollars at typical L1 gas), and far cheaper on L2s (Base,
Arbitrum, Optimism) and on non-EVM targets RISC Zero already verifies on
(e.g. Stellar). Recommendation: **settle on an L2 for cost, optionally anchor
to L1** — the settlement is an audit trail, not a hot path.

---

## 4. The pipeline: crystal row → on-chain settled theorem

Where it plugs into the existing loop: **after `installRules`** (the landing
is durable in `machine/sphatika.crystal`) **and at `--exchange` time** (the
same content a peer would re-judge is what gets attested). The zk path is an
*additional consumer of a landed row*, never in the proving hot loop.

```
  ┌─ EXISTING LOOP (machine/Sphatika_….hs) ──────────────────────────┐
  │  sense → prove (checkContext, Agda --safe) → land → appendCrystal │
  │       → installRules  ◄── local trust primitive lives here        │
  └───────────────────────────────┬──────────────────────────────────┘
                                   │  a landed row sp0NN  (+ its citation cone)
                                   ▼
  ┌─ NEW: attestation organ (external, off the hot loop) ─────────────┐
  │  1. extract: read sp0NN and its transitive PCite closure from the │
  │     crystal → (target statement S, proof P, earlier lemmas)       │
  │     [reuse loadCrystal + the PCite dependency walk]               │
  │  2. canonicalize: `canon` (Sphatika_….hs:82) so H is stable under │
  │     variable renaming — same discipline the exchange uses         │
  │  3. prove: run the pinned checker (§1b) as zkVM guest on that      │
  │     input → receipt + journal H = keccak(canon(S))                │
  │  4. settle: TheoremRegistry.settle(publicValues=H, proofBytes)    │
  │     on the chosen chain → event Settled(H)                        │
  └───────────────────────────────────────────────────────────────────┘
```

Step 1 is a small addition to the Haskell driver: a function that, given a
`LemId`, returns the minimal sub-context (the lemma + everything reachable
through `PCite`, already in order because peers/rows cite only earlier ones —
`exchange`'s "one ordered pass suffices", `Sphatika_….hs:344`). Steps 3–4 are
a separate binary (Rust guest + host) invoked by `machine/sphatika-forever.sh`
or a new `sphatika-settle.sh` sibling. **Nothing in the prove/land loop
changes**; the kernel stays the sole local authority, and settlement is a
downstream, advertised-lower-trust broadcast of a fact the kernel already
established.

An **on-chain exchange** then becomes: a peer reads `Settled(H)` for `H =
keccak(canon(S))`, and — if it trusts the checker pin and the zkVM (§6) —
adopts `S` without either running Agda or re-judging the proof. That is the
succinct-portable complement to `--exchange`'s zero-trust local re-judge:
`--exchange` trusts nobody but costs an Agda run per row; on-chain settlement
costs 300k gas to verify but trusts the checker + zkVM.

---

## 5. Why (b), and why RISC Zero / SP1 over Jolt / Nexus

- **RISC Zero R0VM 2.0** and **SP1 Hypercube** are the two production zkVMs
  with audited, deployed on-chain Groth16 verifiers and ~250–300k-gas
  verification *today*. Either is a viable target; RISC Zero's ongoing formal
  verification of its RISC-V circuits (R0VM 2.0) is directly relevant to §6's
  first gap and slightly favors it for a correctness-obsessed use.
- **Jolt (a16z)** integrated Twist-and-Shout memory checking (2025), ~6×
  prover speedup, ~50KB proofs, but its on-chain verifier / Groth16-wrap
  story is less battle-tested than RISC Zero's and SP1's — track, don't
  build on yet. ([Jolt 6× speedup](https://a16zcrypto.com/posts/article/jolt-6x-speedup/))
- **Nexus 3.0** (Jolt + HyperNova, StarkWare collaboration) is explicitly
  experimental and **not recommended for production**
  ([Nexus zkVM docs](https://docs.nexus.xyz/zkvm/nexus-zkvm)) — not a
  settlement target now.

The guest is small enough (§1b) that it is essentially portable across all
four; the choice is driven by the *verifier* maturity, not the guest.

---

## 6. Honest risks — the trust this ADDS, named

On-chain settlement trades the strong local kernel for a succinct-but-weaker
zk attestation. Three distinct assumptions, none of which the local Agda
recheck carries. Stated in the register `docs/LANDSCAPE.md` §2 demands: this
moves off the "my kernel re-checked it — trust nobody" rung.

### 6.1 The zkVM soundness + trusted-setup assumption (NEW trust)

The local primitive trusts one thing: your own Agda kernel, which you can
read and re-run. The on-chain verifier instead makes a *believer trust*:

- **Groth16 trusted setup.** Both RISC Zero and SP1 wrap the receipt in a
  Groth16 SNARK over BN254, which requires a **trusted-setup ceremony**; if
  the ceremony's toxic waste was not destroyed, a forger can fabricate a
  receipt for a *false* `H`. RISC Zero's was a 2024 multi-party ceremony
  ([security model](https://dev.risczero.com/api/security-model)). You are
  now trusting that ceremony and the honesty of ≥1 participant.
- **zkVM circuit soundness.** A bug in the zkVM's RISC-V circuit (an
  under-constrained opcode) lets a prover produce a valid receipt for an
  execution that did not happen. This is an active audit surface
  ([SP1 guest-auditing guidance, 2025](https://www.7blocklabs.com/blog/auditing-zkvm-guest-programs-a-checklist-inspired-by-2025s-sp1-security-guidance));
  RISC Zero's R0VM 2.0 formal-verification effort exists precisely because
  this risk is real. **The local kernel has no analogue of either risk.**

Net: on-chain belief rests on {Groth16 setup honesty, zkVM circuit
soundness, the verifier contract's correctness}. Advertise this. A settled
`H` means "correct under the zkVM's assumptions," not "correct" simpliciter.

### 6.2 The checker-vs-Agda gap — the real soundness gap (NEW trust)

**This is the one to flag loudest.** Option (b) does NOT run Agda; it runs a
*re-implementation* of the relevant fragment of Agda's definitional equality
and induction (§1). The receipt attests "the MINI-CHECKER accepted `P` for
`S`" — and that equals "Agda would accept it" **only if the mini-checker is a
faithful under-approximation of Agda's kernel on this fragment.** Every place
they diverge is a soundness hole:

- **Reduction semantics drift.** The normalizer must match `Cubical.Data.Nat`
  exactly — including the `_+_`-recurses-on-first-argument asymmetry the
  corpus documents (`KernelContext.hs:781–783`). If the checker's `+`, `*`,
  `-`, `max`, `le`, or `gcd` reduction diverges from cubical Agda's actual
  definitions by even one case, it can accept a statement Agda would reject
  (or vice versa). The checker's ℕ rules are a hand-transcription of Agda
  definitions and are trusted to match them.
- **Induction / IH binding.** The guest binds `PIh` to the equation at the
  predecessor and forbids nested induction (§1b), mirroring `renderLemma`.
  A mismatch in *which* IH is in scope, or admitting a non-structural
  recursion, would let the checker accept a non-theorem that Agda's
  termination checker would reject.
- **Congruence hole / substitution.** `PCong`'s single-hole discipline and
  `PCite`'s capture-avoiding substitution must match the rendering's; an
  off-by-one in variable handling is a soundness bug invisible to the chain.

The chain cannot see any of this — it only checks the SNARK. So a divergent
checker produces perfectly valid receipts for wrong facts.

**Mitigations, honestly partial:**

1. **Differential testing against Agda.** Run the mini-checker and the real
   `checkContext` (Agda) side by side over the *entire* committed crystal
   plus a fuzzer, gating on agreement, in CI. This shrinks the gap
   empirically; it does not close it (agreement on a corpus is not
   equivalence).
2. **Fail-closed + tiny surface.** The language is 7 constructors over an 8-
   symbol ℕ signature; a few-hundred-line checker is auditable line-by-line
   against `KernelContext.renderProof`. Small is the main defense.
3. **The real closure: extract the checker from a checked Agda term.** The
   principled fix is to *prove the mini-checker sound in Agda* — a checked
   `checker P S ≡ true → (S holds)` — and extract the guest from that term,
   exactly the corpus's standing `Dahana`/extraction discipline
   (`ARCHITECTURE.md` §4: "re-landed as checked terms whose extraction is
   the executable"). Then the guest is not a re-implementation to be trusted
   but an extraction of a proof. **This is designed, not built**, and until
   it exists the gap is real and must ride on every settled fact.

### 6.3 Proving cost and operational risk

- **Proving cost.** Small for (b) — the current crystal is tiny arithmetic —
  but it grows with the citation cone; a deep context is more cycles. GPU
  proving (Bonsai / SP1 clusters) is seconds-to-minutes and costs real money
  or a proving-market fee. This is why settlement is off the hot loop.
- **Verifier / registry bugs.** The `TheoremRegistry` and the deployed
  verifier are ordinary smart-contract risk (needs audit); a registry bug
  can record an `H` whose receipt was never truly valid.
- **`H` collision / canonicalization.** `H = keccak(canon(S))` is only as
  meaningful as `canon` is canonical; if two genuinely different statements
  canonicalize equal, settlement conflates them. `canon`
  (`Sphatika_….hs:82`) renumbers by first appearance and is the same
  function the exchange trusts, so this reduces to trusting an existing,
  in-use component — but it must be pinned into the checker binary (inside
  `imageId`/`checkerVKey`), not applied off-chain, or the hash is unbound
  from the verified computation.

---

## 7. Recommendation, in one paragraph

Build option **(b)**: a few-hundred-line, fail-closed proof-checker for the
crystal's `(Term, Proof)` language (`KernelContext.hs:203, 312–334`) as the
zkVM guest, targeting **RISC Zero R0VM 2.0** or **SP1 Hypercube** (audited
~250–300k-gas on-chain Groth16 verifiers). The guest journals `H =
keccak(canon(statement))`; a `TheoremRegistry` contract verifies the receipt
against a pinned checker vkey and records `H` as settled. Plug it in *after*
`installRules` / at `--exchange` time as an off-hot-loop consumer of a landed
row — the Agda kernel stays the sole local authority. **The load-bearing
honesty:** on-chain settlement is a *weaker* belief than the local recheck.
It adds (1) the zkVM's trusted-setup + circuit-soundness assumptions and,
more seriously, (2) **the gap between the mini-checker and Agda's actual
kernel** — a re-implemented ℕ normalizer and induction checker can diverge
from `Cubical.Data.Nat`'s reduction and accept a valid receipt for a
non-theorem, invisibly to the chain. The only principled closure is to prove
the checker sound *in Agda* and extract the guest from that term
(`ARCHITECTURE.md` §4 extraction discipline); until then the gap is real and
must be advertised on every settled fact, in the same spirit as the
`Approx(ε)` edge that is required to remember its ε.
