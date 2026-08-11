# Darwin Gödel Machine → this collaboration: five adoptions

Source: Sakana AI / Clune et al. 2025 ("Darwin Gödel Machine:
Open-Ended Evolution of Self-Improving Agents"), from training
knowledge; post-cutoff developments to be pinned by the design lane
[prior-art check]. DGM's relaxation of Schmidhuber: drop provable
self-improvement for EMPIRICALLY VALIDATED self-modification, plus a
Darwinian archive with branching from any member — stepping stones,
not hill-climbing. Its measured lessons: (1) archived "inferior"
variants seed later breakthroughs (goal-switching beats greedy);
(2) self-modifications that help transfer across models and tasks;
(3) the validation gate, not the generator, carries the safety and the
signal.

Mapped onto us — what we already have, then the five deltas:

Have: results archive (registry, event chains = phylogeny of CLAIMS);
walk ledger (yields = fitness signal on ideas); forecast gate;
cross-lineage validation. Lack: any of this for the AGENTS THEMSELVES.
Our briefs, skill, and protocol evolve by coordinator fiat — un-archived,
un-branched, un-benchmarked. DGM's subject matter is exactly that layer.

## A1 — Genome archive (`collab/genomes/`)
Every brief, skill version, and protocol amendment is a genome:
archived immutably with id, parent id(s), and the diff that created it.
The onboard skill and each fleet brief get genome ids; registry packets
record the genome that produced them. Cost: a directory + a header
convention. This turns our existing git history into an explicit,
branchable phylogeny.

## A2 — Branch from stepping stones, by policy
The brief-composer (today: me; in the build: a role) must sample
ancestors nonuniformly from the WHOLE archive — including genomes whose
walks "failed" — not only from the current best. Our own record already
contains the proof-of-value instance (wall-map inversion); DGM's
evidence says make it standing policy, because the best parent for the
next breakthrough is often not the current champion.

## A3 — Empirical gate for self-modification
Protocol/skill changes are currently adopted on argument. Adopt DGM's
gate: a fixed evaluation suite for orchestration variants — replicate a
known-result packet end-to-end; pass a breaker test with planted
errors; produce a yield from a doomed walk — scored, cheap, run before
a genome change becomes the default path. Until the suite exists,
every norm change carries a forecast (already required) plus a review
date. The suite is a design-lane deliverable, priority raised.

## A4 — Agents may rewrite their own genome
A fleet agent may end its walk by proposing a diff to its OWN brief or
to the skill (a child genome), justified by its yield. The child enters
the archive; the gate (A3) decides adoption. This is DGM's core loop
transplanted: the agent that hit the wall knows what the next brief
should say — today that knowledge dies with the walk unless the
coordinator catches it.

## A5 — Transfer as a first-class metric
DGM found improvements transfer across models. We have two lineages in
one repo: score genome changes by whether BOTH lineages benefit
(Codex's fail-closed registry improved our discipline; our walk-yield
norm is entering their schema). A change that helps one lineage only is
a niche adaptation; one that helps both is architecture. The design
lane should report this split explicitly.

## Guardrails (DGM's own findings, kept)
The gate carries the safety: self-modifications only enter the default
path through A3's suite + the existing extraordinary-claim and
cross-lineage review norms. No genome self-adopts. Objective-hacking
(DGM observed agents gaming their benchmark) is the failure mode to
design the suite against: include at least one held-back test authored
by the OTHER lineage.
