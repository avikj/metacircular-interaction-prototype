# Darwin Gödel Machine → this collaboration: five adoptions

Source: Zhang, Hu, Lu, Lange, and Clune, *Darwin Gödel Machine:
Open-Ended Evolution of Self-Improving Agents*, arXiv:2505.22954v3 / ICLR
2026, plus the official `jennyzzt/dgm` repository pinned at
`a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2`.  The independent source/code
audit and fail-closed pilot design are in `notes/DARWIN_GODEL_MATH.md`.
DGM's relaxation of Schmidhuber: drop provable
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
Every trusted brief, skill version, and protocol amendment receives an
immutable content-addressed snapshot and provenance record.  That catalog is
not executable ancestry by itself.  A proposed executable genome is a strict
candidate record in the quarantined mutable namespace, binding its parent,
dependency closure, environment, and reconstruction evidence; only an attested
gate result can make it an executable parent. Registry packets record the
retained genome that produced them. This turns git history into an explicit,
branchable phylogeny without granting a header or human alias code authority.

## A2 — Branch from stepping stones, by policy
The brief-composer (today: me; in the build: a role) must sample
executable parents nonuniformly from the retained, attested archive, not only
from the current best.  Rejected or failed genomes remain first-class evidence:
their sanitized yields, counterexamples, diagnoses, and certified kernels may
be attached to a new brief, but their untrusted executable scaffold is not a
parent until it separately passes the gate. Our own record already contains
the proof-of-value instance (wall-map inversion); DGM's evidence says preserve
stepping stones without confusing epistemic inheritance with code authority.

## A3 — Empirical gate for self-modification
Protocol/skill changes are currently adopted on argument. Adopt DGM's
gate: a fixed evaluation suite for orchestration variants — replicate a
known-result packet end-to-end; pass a breaker test with planted
errors; produce a yield from a doomed walk — scored, cheap, run before
a genome change becomes the default path. Until the suite exists,
every norm change carries a forecast (already required) plus a review
date. The suite is a design-lane deliverable, priority raised.

## A4 — Agents may propose a child genome
A fleet agent may end its walk by proposing a content-addressed candidate
patch to its OWN mutable scaffold, justified by its yield.  It cannot write the
trusted brief, onboard skill, protocol, validator, or archive.  The privileged
integrator may reconstruct the proposed child in the candidate namespace; the
gate (A3) decides retention, and a separate human/reviewer-controlled process
decides any later trusted-policy adoption. This preserves DGM's useful loop—the
agent that hit the wall knows what the next brief should say—without allowing
self-adoption or mutation of the trusted computing base.

## A5 — Transfer as a first-class metric
DGM reports transfer across models in its measured settings. We have two
lineages in one repo: score genome changes by whether BOTH lineages benefit
(Codex's fail-closed registry improved our discipline; our walk-yield
norm is entering their schema). A change that helps one lineage only is
a niche adaptation; one that helps both is architecture. The design
lane should report this split explicitly.

## Guardrails (DGM's own findings, kept)
The gate carries the safety: self-modifications only enter the default
path through A3's suite + the existing extraordinary-claim and
cross-lineage review norms. No genome self-adopts. Objective-hacking
(DGM observed agents gaming their benchmark) is the failure mode to
design the suite against: reserve a never-queried final test authored by
the OTHER lineage, open it only after the terminal comparison is frozen,
then retire it permanently.
