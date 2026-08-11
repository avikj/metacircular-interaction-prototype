# The emerging open machine-mathematics commons

**Reconnaissance date:** 2026-08-11.

The premise that no open project is attempting social, agentic mathematical
research is no longer true.  Several appeared or matured during 2026.  They
cover different layers of the desired system; none should be casually
reimplemented here.

## The systems to compose

| system | strongest existing layer | boundary relevant here |
|---|---|---|
| [TheoremDB](https://theoremdb.org/how-it-works/) | Public problem memory: statements, attempts, failures, artifacts, evidence grades, pinned Lean deposits, and an MCP interface. | It is an alpha hosted service, not a source-available local database, general discovery engine, or proof kernel.  Even read queries disclose their contents to an external service. |
| [Albilich](https://github.com/uw-math-ai/albilich) | Versioned SQLite proof graph, adversarial roles, literature adaptation, CAS passes, strict/integration verification, scheduler, dashboard, and extensive tests. | Its authority is still implemented by its own validators and natural-language verifiers unless a claim reaches an external formal kernel. |
| [QED](https://github.com/proofQED/QED) | Open-problem literature survey, decomposition, a single-prover construction path, multi-pass natural-language verification, and expert-reviewed case studies. | The usual result is an informal proof.  Its runner uses permission/sandbox bypass modes and belongs only in a disposable isolated environment; expert review is not a replayable formal certificate. |
| [OpenProver](https://github.com/Kripner/openprover) | Open planner/worker/verifier search whose terminal artifacts are checked by Lean 4. | It is principally a formal proof-search system, not a scientific conjecture generator or shared social research memory. |

Adjacent systems should also be watched rather than absorbed by name alone.
ProofAtlas is currently a read-only evidence atlas with downloadable pinned
continuation packages, not a public API or writable collaboration surface.
Agora/Stagira is a public theorem-market demonstration with no located public
source, license, API, or MCP.  Lean Forward was a 2019--2023 research project
whose durable output is upstream Lean/mathlib and verified-certificate
practice, not an installable service.  Goedel-Architect publishes readable
code but currently has no repository license, so its ideas may be studied but
its code must not be copied.  Numina-Lean-Agent and theorem-retrieval services
improve the formal worker layer.

## Adoption decision

The project should be a **federation**, not another monolith.

1. Keep this program private until the human owner explicitly selects a
   release.  Do not send private problem statements, plans, traces, novelty
   signals, or artifacts to TheoremDB or any other external service, including
   through nominally read-only search queries.  Public material may be studied
   through ordinary source research; external write connectors remain disabled.
2. Benchmark selected Albilich invariants and modules before extending
   `code/discovery_loop.py`: proof/debt graphs, validated patches, deterministic
   scheduling, CAS envelopes, and integration gates.  Do not import its entire
   76k-line control plane or create two competing authorities.
3. Treat QED as a future isolated benchmark and alternative research lineage. A
   claim surviving both our workflow and QED's independently configured
   decomposition/verifier stack would have stronger evidence than a same-stack
   rerun, but no private run is exported and the runner must be sandboxed.
4. Pilot only OpenProver's small Lean tool boundary (`lean_verify`,
   `lean_store`, `lean_search`) in an ephemeral pinned environment, rather than
   adopting its planner.  The Lean kernel checks the formal statement; a
   separate alignment audit must still check that it means the intended
   mathematics.
5. Keep CAS, Wolfram Language, SMT, SAT, and numerical search outside the truth
   boundary.  They generate representations, witnesses, reductions, and
   certificates.  Small independent checkers or proof kernels decide what may
   become load-bearing.

## The layer this repository can uniquely contribute

The orchestration pattern is no longer distinctive by itself.  The promising
specialization is the combination of:

- **Rosetta/defect search:** explicitly rotate languages, form commuting
  squares, and turn their defects or noncongruence witnesses into theorem
  seeds;
- **reasoning compilation:** extract repeated algebraic insight into exact,
  cheap C++/Python/FLINT/SAT kernels so CPU replaces model tokens on the stable
  part of a search;
- **finite-reduction theorem factories:** derive a proved finite domain, emit
  content-addressed candidates, and replay topology, irreducibility,
  resultant, and tail certificates independently;
- **cross-foundation experiments:** Lean for conventional certification and
  Cubical Agda only where quotient, descent, or higher coherence is genuinely
  present;
- **adversarial semantic alignment:** preserve the difference between a true
  formal statement, the intended English theorem, and a novelty claim.

The desired private flywheel is therefore

\[
\text{agents invent lenses}
\to \text{programs exhaust the induced search}
\to \text{kernels certify}
\to \text{local memory prevents repetition}
\to \text{agents receive a smaller, stranger frontier}.
\]

This preserves the center of gravity: frontier agents remain the source of
object choice, representation change, and synthesis.  Traditional computation
absorbs only the reasoning that has become explicit enough to compile.

## Near-term integration test

The integration is successful only if it improves mathematics rather than the
appearance of organization.  Use one live claim and require all of the
following:

1. A local literature audit against already-public sources finds or rules out
   reusable external work without transmitting the private claim.
2. Albilich or an equivalent proof graph exposes the decisive unresolved cut.
3. Our Rosetta pass generates at least two genuinely different representations.
4. A generated exact program settles a nontrivial finite obligation cheaper
   than an agent could repeatedly reason through it.
5. A fresh implementation or formal kernel replays the load-bearing result.

If a component does not reduce cost, eliminate duplicate work, find a new
route, or strengthen a certificate, it is infrastructure theater and should be
removed.
