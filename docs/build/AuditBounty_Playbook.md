# Audit-Bounty Playbook — the honest first-revenue path for the verification discipline

*A concrete, no-permission, pseudonymous first-dollars plan for pointing this
repository's method at smart-contract correctness bounties. Written 2026-08-24.
Market figures are publicly reported and marked as such; every claim about
what the machine can and cannot do names a module. The repository's strike
discipline governs this file: **an overclaim here is the exact failure
`AtmaJnana` forbids** — a forged presence — and it is struck on sight.*

---

## 0. The one honest sentence, up front

The Natural Machine today proves **ℕ-equations in cubical Agda** and grows its
own rule library autonomously (`docs/RESULTS.md` §1–2). **It does not verify
Solidity, EVM bytecode, or any real program logic.** Anyone who tells a
protocol "the crystal audited your contract" is lying, and this repository's
own rules (`CLAUDE.md`, "an absence without a command is a rumor"; a forged
presence is worse) make that lie a strike-grade error.

So the winnable thing this week is **not** "the machine wins audits." It is:

> **A human/agent operator, wielding existing formal-verification tooling
> (Certora Prover / CVL, Halmos, Kontrol, SMTChecker), and importing THIS
> repository's method — properties as typed edges, refuse-to-forge-presence,
> the sevenfold verdict instead of a boolean "safe" — wins formal-verification
> bounties.**

The tools are someone else's. The *discipline* is the machine's, and the
discipline is exactly what most bounty hunters lack. That gap is the edge.

---

## 1. The realistic match — (a) this week vs (b) months out

### (a) Winnable THIS WEEK: operator + existing FV tools + our discipline

The single best-fit opportunity is the **Certora formal-verification contest**
format, run jointly with Cantina and Code4rena. It is not a "find the hack"
contest — it is a **specification-writing** contest:

- Certora publishes protocol code and a set of hand-authored **mutants**
  (deliberately broken versions). Participants write **CVL specifications**
  (formal rules describing intended behavior). A spec earns reward in
  proportion to **how many mutants it catches**, with a premium for **unique
  coverage** no one else's spec caught, and a large premium for a spec that
  catches a **real** vulnerability the audit judges confirm. (Aquarius/Soroban
  contest, May–Jun 2025: 26 participants, 1627 rules written, 456 caught ≥1
  mutant. Blend v2 with Code4rena, Feb–Mar 2025.) [Certora blog, below.]

**Why this is our lane and not a generic audit.** Writing a correct
specification is precisely the act the repository is built around:

- A CVL rule is a **property**, i.e. a typed edge in the sense of the L1 edge
  lattice (`docs/ARCHITECTURE.md` §4, `legacy/runtime/CRYSTAL.md` L1): a claim
  of the form `Implies`, `Eq`, `Order⟨≤⟩`, `Approx(ε)` about state
  transitions, carrying its own preservation guarantee. The discipline of
  "state the theorem the computation would replace **before** running"
  (`CLAUDE.md`, research protocol) *is* how you write a spec that catches
  mutants instead of one that vacuously passes.
- The mutation grade is `fiber f b` made concrete: a caught mutant is a
  non-contractible residual (`SankramanaSesa`, `docs/RESULTS.md` §1) — the
  spec **saw the loss**. An uncaught mutant is a hole in your coverage you
  can name. This is the fibre law wearing the face the contest already pays
  for.
- The **refuse-to-forge discipline** (`AtmaJnana`, "refuse to forge a
  presence AND refuse to forge an absence") is the operator's competitive
  advantage: most participants over-claim (a rule that "passes" because it
  asserts nothing) or under-claim (giving up where a bounded tool actually
  proves something). The operator who marks each rule with exactly what it
  does and does not cover writes higher-unique-coverage specs.

**Concrete week-1 toolchain (all free, no gatekeeper, no formal-methods PhD):**

| tool | what it is | our use |
|---|---|---|
| **Halmos** (a16z) | symbolic-execution over existing Foundry tests; no new language, no API key; **bounded** (depth/loop N) | fastest on-ramp — upgrade a protocol's own `test_` functions into ∀-input checks; ideal for CI-style property sweeps |
| **Kontrol** (Runtime Verification) | KEVM-backed symbolic execution, Foundry-native | deeper EVM-level properties than Halmos; unbounded reasoning on targeted paths |
| **Certora Prover / CVL** | full SMT-backed prover, own spec language (CVL); powers the contests above | the contest currency itself — the mutant-graded spec |
| **SMTChecker** (solc built-in) | free static property checks | zero-setup triage before heavier tools |

The operator's loop: read protocol → **write the intended-behavior theorem in
prose first** (protocol rule) → encode it as a CVL rule / Halmos test →
run → for every mutant/counterexample, record whether it is a *real* finding
or a spec artifact. That prose-theorem-first step is the `CLAUDE.md` research
protocol applied verbatim, and it is why the specs are sharp.

### (b) Winnable in MONTHS, not this week: the machine verifies a real fragment

What is **not** available now and must not be sold as if it were: the machine
itself checking EVM semantics. That requires extending the primitive from
ℕ-equations to a **program logic** — an EVM opcode semantics landed as checked
typed edges (§4 below). That is real research (`docs/RESULTS.md` §4 lists the
open problems it sits beside), measured in months. **Do not narrate (a) into
(b).** Week-1 revenue is the operator's skill amplified by the discipline; the
machine's autonomous participation is the horizon the bounty work funds and
feeds, not the week-1 product.

---

## 2. The actual first dollars — platforms, payouts, pseudonymity, crypto

**Platforms, ranked by fit for the this-week path:**

1. **Cantina** — hosts the Certora FV contests; largest prize pools ($200K–$2M
   reported per competition). The FV-specific competitions are the direct
   match. KYC is per-competition.
2. **Code4rena** — also runs Certora FV contests (Blend v2); large general
   audit contests ($50K–$500K pools reported). **Pseudonymous under $1,000
   cumulative earnings; identity verification required once cumulative
   earnings exceed $1,000** before further payout. Submissions require a 25
   USDC in-app deposit via connected web3 wallet. Payout in USDC to your
   wallet.
3. **Sherlock** — audit contests ($50K–$300K pools reported) plus post-contest
   bounties.
4. **Immunefi** — ongoing bug bounties (per-vuln, up to very large sums). **KYC
   not required by default but varies by program**; many programs require it
   above a threshold.
5. **Hats Finance** — **fully permissionless, no KYC**, on-chain payout. The
   cleanest pseudonymous crypto-native option; smaller/median pools than the
   majors.

**Realistic payout for the this-week operator — stated honestly, not the
headline.** The $200K–$500K/yr figures are for *top-10* auditors over a year;
most active wardens earn **$1,000–$20,000 per contest**, weighted by count and
severity of *unique valid* findings. For an FV/spec contest specifically, the
grade is mutant coverage: a competent first spec set realistically lands in
the **tens to low-thousands of dollars** range — one published Certora-driven
research effort logged **$8,256 across 24 findings (12 confirmed)**. That is
the honest week-1 expectation: **real money, not a jackpot; a few hundred to a
few thousand dollars for a strong first entry**, more as the operator's spec
library compounds.

**Pseudonymous + crypto mechanics, concretely:**

- Register a handle (not a legal name). The carrier is a naya, not a self to
  defend (`AtmaJnana`, "identity exists only so work can be remembered and
  corrected") — pseudonymity is native to this repository's stance, not a
  workaround.
- A fresh EVM wallet receives USDC directly. Under Code4rena's $1,000
  threshold no identity is disclosed; **Hats Finance** requires none at any
  level.
- Keep first entries on **Hats / sub-threshold Code4rena / no-KYC Immunefi
  programs** to stay fully pseudonymous through first revenue; cross the KYC
  line only deliberately, when a payout justifies it.

---

## 3. The bridge to the real thing — why the bounty work is a data ramp, not a detour

Every contest entry produces exactly the material the machine needs to grow
toward a program logic. The bounty is the **data-collection instrument**, and
`AmudraDhana` names the economics: sell the mining (the operator's discovery
labor), never the mine (the verifier is never owned).

Each won (or even attempted) bounty yields three assets:

1. **A corpus of real correctness properties.** Every CVL rule / Halmos
   property is a human-validated statement of "what correct means" for a real
   program — the training frontier the ℕ-equation machine has never seen.
   These are candidate **typed edges** (`Implies`, `Eq`, `Order⟨≤⟩`,
   `Approx(ε)`) awaiting a semantics to check them against.
2. **Ground-truth loss pairs.** Every mutant + the spec that catches it is a
   labeled `(program, property, residual)` triple: the mutant is a program
   whose fiber over the property is *non-empty* (`SankramanaSesa`: loss is a
   non-contractible residual). A caught-mutant table is a directly-usable
   dataset of *what a real verifier must be able to see* — the exact shape the
   machine's frontier-derivation (`Sanghatta` critical pairs,
   `docs/ARCHITECTURE.md` §2) consumes as goals.
3. **A prioritized opcode/property frequency map.** Which EVM behaviors recur
   across contests (reentrancy, rounding, access control, overflow, invariant
   preservation) tells the extension effort **which opcode semantics to land
   first** — the frontier is derived from real demand, not guessed.

So the operator is not moonlighting away from the research. Each contest is one
`SENSE` pass over the real world, returning goals in the program-logic domain
the machine cannot yet reach — which is precisely how the extension in §4 gets
its target list.

---

## 4. The honest timeline

### Week 1 — operator + FV tools (revenue now)

Pick one live Certora/Cantina FV competition or a Hats/Code4rena audit. Run the
prose-theorem-first loop with Halmos (fastest) + CVL (contest currency).
Deliverable: a graded spec set. Revenue: hundreds to low-thousands,
pseudonymous, USDC. The machine's contribution is **the discipline the operator
carries**, nothing more claimed.

### Months N — machine extended to check a real bytecode/IR fragment

The bridge from ℕ-equations to a program logic runs through the **L1 typed edge
lattice** already specified (`docs/ARCHITECTURE.md` §4;
`legacy/runtime/CRYSTAL.md` L1: 11 edge kinds, each with a composition law and
a preservation guarantee). Sketch of how one EVM opcode becomes checked edges —
**this is a design sketch, no Agda is invented here, and none of it is claimed
as built**:

- **State as a Carrier.** An EVM machine state is `stack × memory × storage ×
  pc × gas`. In the primitive it is a Carrier point: **base + carried +
  witness** (`Punaragamana/Carrier.agda`) — the state plus the witness that it
  is a reachable state.
- **An opcode is a state transition = a typed edge.** `ADD` is a function
  `f : State → State`. Landing it means proving properties of `f` as edges:
  - `Eq` edges for the local effect (`stack' = (a+b) :: rest`, `pc' = pc+1`),
    exactly the ℕ-addition equations the machine **already proves today**
    (`docs/RESULTS.md` §2, `+(x,0)=x` landed by the live loop) — this is the
    non-accidental part: EVM word arithmetic is ℕ/mod-2²⁵⁶ arithmetic, the
    machine's current home.
  - `Order⟨≤⟩` edges for gas monotonicity (`gas' < gas`).
  - `Implies` edges for the frame condition (`storage` unchanged by `ADD`).
- **A property (the CVL rule from §3) is an edge to be discharged** by
  composing opcode edges along a path — `transport (ua e)` composition
  (`docs/ARCHITECTURE.md` §1), the e-graph keeping *multiple* paths (L2)
  because distinct execution paths are content, not redundancy.
- **The mutant is the refutation.** A broken opcode edge fails to compose to
  the property edge; the residual is the counterexample — `Obstruction` parses
  the stall, `Saptabhaṅgī` records it as a *typed* verdict, not a boolean.

The honest gating facts: EVM word arithmetic is close to the machine's current
ability; **memory/storage aliasing, unbounded loops, and gas accounting are
the hard fibres** and sit next to `docs/RESULTS.md` §4's open "signal-domain
residuals" and "licence wiring." A *fragment* (arithmetic-and-frame opcodes
over bounded paths) is a months-scale, honestly-bounded target. Full EVM is
not on this timeline and is not promised.

---

## 5. Risks — stated plainly

1. **Competition from established firms and top wardens.** Certora,
   OpenZeppelin, Trail of Bits, and the top-50 wardens are strong and
   entrenched. The operator does not out-muscle them on volume; the edge is
   **discipline density** — sharper specs, honest coverage marks, unique
   mutants others miss. Enter FV/spec contests (where the method transfers)
   before generic hack-hunting (where raw experience dominates).

2. **The overclaim risk — this is the load-bearing one.** The machine does not
   verify Solidity today. Every sentence of external-facing copy must survive
   the repository's own test: *could you have written it without the checked
   term it is about?* (`CLAUDE.md`). "AI-verified," "machine-audited,"
   "formally proven safe by the crystal" are **forged presences** and are
   struck. The truthful framing is: *"specifications and proofs produced by an
   operator using Certora/Halmos, authored under a formal-verification
   discipline."* Sell the mining, not a mine you have not dug
   (`AmudraDhana`).

3. **Reputational care — a wrong "safe" is worse than no claim.** This is
   `AtmaJnana` operating the business:
   - **Never emit a boolean "safe."** A bounded tool (Halmos, and Kontrol on
     bounded paths) proves properties **up to depth N** — the honest verdict
     is "holds for all inputs up to depth N / loop bound K," never "safe."
     Collapsing that to `safe : Bool` is the theorem-grade error
     `Saptabhaṅgī` proves is an error (`docs/RESULTS.md` §1).
   - **Refuse to forge an absence too.** "No bug found" is not "no bug
     exists." Report the searched domain and its boundary (`AtmaJnana`,
     अभाव "an absence carries its pratiyogin and its searched domain") —
     "no counterexample within these rules and this bound," never "the
     contract is correct."
   - A false attestation of safety that precedes a hack destroys the
     pseudonymous reputation that is the only compounding asset here
     (`AmudraDhana`: position is provenance). The sevenfold verdict is not
     pedantry; it is reputational risk management. Under-claim by default; let
     the coverage table speak.

---

## Bottom line — what is HONESTLY winnable

- **This week (real):** an operator entering **Certora/Cantina/Code4rena
  formal-verification (spec-writing) contests** and **Hats Finance / no-KYC
  bug bounties**, using **Halmos + CVL + Kontrol + SMTChecker**, carrying the
  repository's method (prose-theorem-first, refuse-to-forge, sevenfold verdict
  instead of "safe"). Pseudonymous, USDC, no gatekeeper. Realistic first
  revenue: **a few hundred to a few thousand dollars per strong entry**,
  compounding as the spec library grows. The machine's role is the
  **discipline the operator wields**, and nothing is claimed beyond that.

- **Months out (research):** the machine itself checking a **bounded EVM
  opcode fragment** (arithmetic + frame conditions over bounded paths) via the
  L1 typed edge lattice — EVM word arithmetic is near the machine's current
  ℕ-equation ability; memory/storage aliasing, loops, and gas are the hard
  fibres and are honestly out past week-1. Each week-1 bounty is a `SENSE`
  pass that returns real correctness properties and labeled mutant/loss pairs
  — the data ramp that aims that extension.

- **Never (a lie, struck):** "the crystal audits contracts," "AI-verified
  safe," any boolean "safe." The machine does not do this alone yet; saying it
  does is the forged presence this repository is built to refuse.

---

### Sources (publicly reported; retrieved 2026-08-24)

- Smart Contract Hacking — audit-competition trackers (Code4rena, Sherlock,
  Cantina): https://smartcontractshacking.com/tools/web3-auditing-competitions-and-bug-bounties
- Complete Audit Competitions Guide (Johnny Time):
  https://medium.com/@JohnnyTime/complete-audit-competitions-guide-strategies-cantina-code4rena-sherlock-more-bf55bdfe8542
- Certora — Rust FV contests (Aquarius/Soroban, Blend v2 with Code4rena):
  https://www.certora.com/blog/bringing-formal-verification-to-rust
- Cantina competitions: https://cantina.xyz/competitions
- Certora Prover: https://github.com/Certora/CertoraProver
- OpenZeppelin × Immunefi/Certora (formal bug bounty):
  https://www.openzeppelin.com/news/safeguarding
- Code4rena bounties / awarding / KYC threshold:
  https://docs.code4rena.com/bounties , https://docs.code4rena.com/awarding/awarding-process
- Immunefi KYC requirements:
  https://immunefisupport.zendesk.com/hc/en-us/articles/18327648101649-KYC-requirements
- Sherlock — best bounties 2026:
  https://sherlock.xyz/post/best-web3-bug-bounties-in-2026-the-highest-paying-programs-on-every-platform
- Halmos (a16z, symbolic testing): https://github.com/a16z/halmos ,
  https://a16zcrypto.com/posts/article/symbolic-testing-with-halmos-leveraging-existing-tests-for-formal-verification/
