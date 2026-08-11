# The emerging open machine-mathematics commons

**Reconnaissance date:** 2026-08-11.

The premise that no open project is attempting social, agentic mathematical
research is no longer true.  Several appeared or matured during 2026.  They
cover different layers of the desired system; none should be casually
reimplemented here.

## The systems to compose

| system | strongest existing layer | boundary relevant here |
|---|---|---|
| [TheoremDB](https://theoremdb.org/how-it-works/) | Public problem memory: statements, attempts, failures, artifacts, evidence grades, pinned Lean deposits, and an MCP interface with `orient`, `check_plan`, and `record_result`. | It is an alpha public memory and review service, not a general discovery engine or proof kernel.  Writing is account-approved; formal and prose states remain separate. |
| [Albilich](https://github.com/uw-math-ai/albilich) | Versioned SQLite proof graph, adversarial roles, literature adaptation, CAS passes, strict/integration verification, scheduler, dashboard, and extensive tests. | Its authority is still implemented by its own validators and natural-language verifiers unless a claim reaches an external formal kernel. |
| [QED](https://github.com/proofQED/QED) | Open-problem literature survey, decomposition, parallel proof construction, multi-pass natural-language verification, and expert-reviewed case studies. | The usual result is an informal proof.  Expert review is valuable but is not a replayable formal certificate. |
| [OpenProver](https://github.com/Kripner/openprover) | Open planner/worker/verifier search whose terminal artifacts are checked by Lean 4. | It is principally a formal proof-search system, not a scientific conjecture generator or shared social research memory. |

Adjacent systems should also be watched rather than absorbed by name alone:
ProofAtlas separates claims, Lean statements, machine checks, and editorial
status; Agora/Stagira explores a market for formal work; Lean Forward,
Numina-Lean-Agent, Goedel-style architect/prover systems, and theorem-retrieval
services improve the formal worker layer.  Their exact maturity, licenses, and
interfaces require source-level audits before adoption.

## Adoption decision

The project should be a **federation**, not another monolith.

1. Use TheoremDB as the public-memory lane for suitable named problems.  An
   agent should call `orient` before expensive work, `check_plan` before a
   large route, and preserve useful negative results through `record_result`
   when account approval and scope permit.
2. Evaluate Albilich as the default proof-state/orchestration substrate before
   adding substantial features to `code/discovery_loop.py`.  Reuse or adapt
   its proof graph, debt model, scheduler, and integration gate under its
   Apache-2.0 license rather than independently rediscovering them.
3. Treat QED as an external benchmark and alternative research lineage.  A
   claim surviving both our workflow and QED's independently configured
   decomposition/verifier stack has stronger evidence than a same-stack rerun.
4. Use OpenProver or another pinned Lean agent as a formal subworker.  The Lean
   kernel checks the formal statement; a separate alignment audit must still
   check that the statement means the intended mathematics.
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

The desired flywheel is therefore

\[
\text{agents invent lenses}
\to \text{programs exhaust the induced search}
\to \text{kernels certify}
\to \text{public memory prevents repetition}
\to \text{agents receive a smaller, stranger frontier}.
\]

This preserves the center of gravity: frontier agents remain the source of
object choice, representation change, and synthesis.  Traditional computation
absorbs only the reasoning that has become explicit enough to compile.

## Near-term integration test

The integration is successful only if it improves mathematics rather than the
appearance of organization.  Use one live claim and require all of the
following:

1. TheoremDB orientation finds or rules out reusable external work.
2. Albilich or an equivalent proof graph exposes the decisive unresolved cut.
3. Our Rosetta pass generates at least two genuinely different representations.
4. A generated exact program settles a nontrivial finite obligation cheaper
   than an agent could repeatedly reason through it.
5. A fresh implementation or formal kernel replays the load-bearing result.

If a component does not reduce cost, eliminate duplicate work, find a new
route, or strengthen a certificate, it is infrastructure theater and should be
removed.

