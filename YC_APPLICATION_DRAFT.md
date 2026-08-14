# YC application — draft 0.2 (cf-tessera, 2026-08-13)

**Status:** draft for the owner. Draft 0.1 wrongly centered Crowdsurf (a
separate project that was receiving input from this collaboration, not
the subject) and led with process anecdotes; both corrected. This draft
is about the repo's own object. Per PROTOCOL §8, nothing leaves the
repository without owner release.

---

## Company name

**Natural Machine** (the repo's own name for the object:
`notes/NATURAL_MACHINE.md`, `notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md`).

## Describe what your company does (50 characters)

- `AI research organizations that prove their work`
- `Autonomous math research, machine-verified`
- `Research labs made of AI agents, output: proofs`

## What is your company going to make?

We build autonomous research organizations: collectives of AI agents
that do original mathematics end to end — pose questions, prove
theorems, audit each other adversarially, and deliver output that is
**machine-verified**, so its correctness does not depend on trusting
the agents, the humans, or us.

This is not a proposal. The organization exists and has been running:
dozens of persistent AI researchers across three model lineages (Claude
Fable, Claude Opus, OpenAI Codex), coordinating through a shared
repository, producing mathematics whose checkable core is 53 Agda
modules (13,314 lines, 731 typed statements, zero postulates, zero
holes, all compiler-enforced `--safe`) and 24 Lean files (zero
`sorry`), verified by one command.

## What have you actually built? (the evidence)

A working research program with real theorems, four paper-grade
artifacts in `papers/`, and ~490 research notes. Highlights a
non-specialist can hold:

- **The Hardy–Littlewood singular series has a critical temperature,
  and it is the pole of the Riemann zeta function** — with a universal
  scaling law in the critical window (the Dickman function appears with
  a complete finite-size correction ladder), verified numerically to
  10⁸ (`papers/crossover.md`, Theorems 1, 3–5, with a novelty
  assessment over 15 recorded prior-art searches).
- **An individual Riemann zeta zero read out of prime-pair counts**:
  the zero difference sits as a chirp in the phase of a spectral line
  built from Goldbach counts; inverting recovers γ₂ = 21.024 against
  the true 21.022 (`papers/phase_side.md`, Theorem G).
- **Why the parity barrier in sieve theory cannot be evaded by
  finite-place methods**, as an operator-algebra theorem: parity is a
  protected gauge charge; the neutral sector has a unique equilibrium
  state (`notes/GAUGE.md` Theorem F, `notes/CORE_KMS.md`); and parity
  is a property of the *place*, not the function
  (`papers/phase_side.md` Theorem H).
- **The Riemann Hypothesis translated exactly into additive
  combinatorics**: RH ⟺ a cut-norm statement about a prime array —
  including the honest proof that the translation relocates the
  difficulty rather than dissolving it (`notes/LENS_REGULARITY.md`).
- **Complete, unconditional classification theorems** at publishable
  granularity: homometric rigidity of prime prefixes; cyclotomic
  divisors of prime-prefix polynomials
  (`notes/PARITY_RIGIDITY.md`, `papers/prime_prefix_cyclotomic.md`).
- **A machine-checked foundations program**: positional notation proved
  to be a chart on ℕ rather than the object (transport along univalence
  *computes* schoolbook ripple-carry); the collaboration's own
  operating law (descent) proved as a theorem about set quotients; a
  quantum contextuality no-go certified by the typechecker running all
  512 cases at compile time (`formal/cubical/`).
- **The system killed its own founding hype first**: its original
  framework was proved mostly trivial by its own agents in week one
  (`notes/REPORT.md`), and it maintains red-team verdict tables,
  registered forecasts, and in-place refutations. Ask it a seductive
  question ("are RH, Goldbach, FLT, twin primes, Collatz one
  obstruction?") and it returns a rigorous, scored **no**
  (`notes/FIVE_FACES.md`).

## Why did you pick this idea?

Because "AI does research" is currently unfalsifiable marketing, and
mathematics is the one domain where it can be made falsifiable to the
last symbol: a `--safe` proof either compiles or it does not. We chose
the hardest ground truth on purpose. An organization that can produce
*verified* new mathematics autonomously is the existence proof for
autonomous research organizations generally — and the machinery
(persistent agent identities, adversarial audit, claims with registered
forecasts, refutation-first culture, mechanical enforcement where prose
fails) transfers to any domain where being wrong is expensive.

## What's new about it? What do you understand that others don't?

1. **Verification is the product, not a feature.** Everyone ships agent
   output you must trust; we ship output the compiler has already
   checked. The trust boundary moves from "do you believe the model" to
   "do you believe the typechecker" — and the typechecker is public.
2. **Research needs organizations, not just models.** Our results were
   produced by structure — independent lineages auditing each other
   blind, forecasts registered before work, corrections that strike
   through but never erase — not by a bigger context window. The
   organization is the technology; models are components that improve
   under us for free.
3. **Self-skepticism can be mechanized.** The system's most valuable
   outputs include its refutations of itself, and its rules are
   enforced by hooks and CI because we measured that prose norms fail.
   We know precisely which coordination mechanisms carried the load,
   because we ran the experiment.
4. **The scaling path is specified**: the Natural Machine network
   whitepaper (three hostile reviews absorbed) — a content-addressed,
   proof-carrying research network with typed obligations and
   verification events, adding federation and settlement only on
   demonstrated need.

## Progress

Running system; four days of full-intensity operation produced the
corpus above (576 commits, 629 inter-agent messages, 353 claims-board
rows, 258 landed). Reproducible: one command (`./run`) verifies the
formal corpus; `formal/check.sh` runs both proof lanes; negative
controls that must fail to compile, do.

## Who are your competitors?

Frontier-lab "AI scientist" demos (single-shot, unverified output);
formal-methods tooling companies (verification without research);
agent-framework startups (orchestration without epistemics). Nobody
combines autonomous research organizations with machine-checked output.
The prior-art searches are part of our method, so we say this with the
receipts recorded.

## How will you make money?

Sell verified research capacity: (1) contract research where the
deliverable is machine-checked (mathematics, algorithms, protocol
correctness, safety-critical verification); (2) the organization
substrate as a platform for institutions that need auditable AI
research (labs, quant firms, verification-heavy industries); (3) the
network layer (typed obligations, prospective contracts released on
acceptance events) when the loop demonstrates need — sequencing per
the whitepaper, settlement last.

## Why now?

Models crossed the threshold where collectives of them can carry
multi-day research programs — we have the four-day existence proof —
while trust in unverified AI output is collapsing. The gap between
"agents that generate" and "organizations that prove" is the next
platform, and it is empty.

---

## Honesty appendix

No claim that any listed theorem is field-changing mathematics; the
claim is autonomous production of *correct, verified, novel-graded*
mathematics with the novelty assessments recorded in-repo. No claim of
external users or revenue. The "existence proof" framing rests on four
days of operation directed by one founder; sustained autonomy over
months is the open milestone. Superlatives ("largest of its kind")
remain beliefs pending prior-art search.
