# What This Is

*The one-page orientation. Other documents in `docs/` go deeper:
[ARCHITECTURE](ARCHITECTURE.md) for engineers, [RESULTS](RESULTS.md) for
researchers, [TECHNOLOGY_AND_MARKET](TECHNOLOGY_AND_MARKET.md) for
investors and lab leadership, [RUNNING_THE_MACHINE](RUNNING_THE_MACHINE.md)
for operators.*

---

This repository contains a **self-improving mathematical machine**: a
system that proves theorems autonomously, learns from its own failures,
installs its own discoveries as new capabilities, and verifies every step
of that growth with a proof kernel — so it can never lie about itself.

Concretely, running in this repository today:

- A **completion loop** that reads the list of equations its own rewriter
  cannot close, proposes proofs, has them judged by the Agda kernel
  (cubical type theory, `--safe`, no axioms, no holes), and stores every
  success in a "crystal" — an ordered library where **every theorem is
  usable by every later proof**.
- A **return edge**: every proven equation is installed back into the
  rewriter as a rule, which makes previously unprovable things provable
  and generates genuinely new questions. Knowledge compounds; the
  machine's next frontier is derived from its own growth.
- A **residual edge**: when a proof attempt stalls, the kernel's error
  message is parsed back into a new, smaller goal — the machine derives
  its own curriculum from its own failures. (Observed in the log: the
  machine stalled, derived `x + 0 = x` as the missing piece, proved it,
  then closed the original goal.)
- An **exchange protocol**: a second node can adopt the first node's
  entire library by *re-verifying every theorem through its own kernel* —
  no trust in the sender required, ever. This is the seed of a
  decentralized network of self-certifying knowledge.

Underneath the running loop is a large body of **checked mathematics**
(~1,400 modules in cubical Agda) built on one idea: in a foundation where
*univalence computes*, an equality is not a fact you cite — it is a
channel that acts, carrying theorems and data across representations
mechanically and losslessly. One law organizes everything: for any map,
either the fiber over a point is trivial (the data "rides free" with its
own witness) or the fiber *is* the interesting object — and memory,
conserved charge, symmetry, price, distance, and logical verdict are all
proven to be this one object read six ways.

Three properties make the system unusual:

1. **It cannot overclaim.** Every capability the machine gains must pass
   the same kernel that judges its theorems. Growth that cannot exhibit
   its own correctness certificate is not rejected — it is *unrepresentable*.
2. **It is enclosure-resistant by construction.** Theorems are
   self-certifying data: anyone's kernel verifies them locally, so no
   institution can sit between a person and a truth. There is no
   authoritative store, no consensus mechanism, and no ownable choke
   point — deliberately.
3. **It met a falsifiable performance criterion.** The design thesis —
   "installed mathematics reduces the cost of *independent* future
   computation" — was tested with exact step counters and null controls,
   and passed (see [RESULTS](RESULTS.md)).

The intellectual frame is as deliberate as the engineering: the system's
epistemology (multi-standpoint logic, a seven-valued verdict calculus in
which boolean judgments are a *proven* error), its ethics (growth laws
derived from non-violence: no destructive update, no unverified claim,
no unearned provenance), and much of its mathematical lineage are drawn
from Indian traditions — Jain logic, Pāṇinian grammar, the Kerala school —
treated as primary sources, not decoration. The naming conventions
throughout the repository reflect this: files lead with the precise
Sanskrit term for the object, followed by an English gloss.

The repository was built by **Avik Jain**, with AI agents as carriers
executing under his direction, over approximately two weeks in August
2026. The velocity is part of the demonstration: the production method —
one person's judgment amplified through autonomous, kernel-verified
agent fleets — is itself one of the artifacts on display.

Where it is going: certified computation on real data streams,
a decentralized network where nodes own what they judge worth their
space and route questions to whoever can provably answer them, and —
the stated horizon — the trust substrate for the brain-computer
interface era, where "code you can let touch a mind" requires exactly
the guarantee this system is built to provide: computation that carries
its own witness, judged by a kernel the *receiver* controls.
