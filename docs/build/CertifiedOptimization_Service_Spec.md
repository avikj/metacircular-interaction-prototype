# Certified Optimization as a Service — "the optimizer that cannot lie"

*A concrete, buildable product spec. The differentiator is a
kernel-checked equivalence certificate shipped alongside every optimized
artifact. Every existing e-graph optimizer trusts its own rewrite rules;
this one ships a checkable proof that the optimization preserves
semantics — an `Eq`/`Iso` edge with its witness (`legacy/runtime/CRYSTAL.md`
§L1, `legacy/runtime/kernel/edges.py`).*

Status of the substrate is kept strictly honest throughout: what is BUILT
(the L0–L4 seed in `legacy/runtime/kernel/`, `execute/`, `crystallize/`,
Python) vs what is DESIGNED (a production engine). See §5 for the
build-vs-wrap decision, which is the load-bearing engineering call.

---

## 1. The product

**Input.** A program / query / circuit `P` in a supported source IR, plus a
**cost model** — not a scalar, a *cost vector* (`CRYSTAL.md` §L3): e.g. for a
circuit `(#constraints, #nonlinear-gates, multiplicative-depth,
witness-size)`.

**Output, two artifacts that travel together:**

1. **`P'`** — an optimized program in the same IR, semantically equivalent
   to `P`, non-dominated under the supplied cost vector.
2. **A certificate `C`** — a proof-forest path (`legacy/runtime/kernel/egraph.py`,
   genuine Nieuwenhuis–Oliveras explain) that `P ≡ P'`, expressed as a
   composition of typed edges from the L1 lattice, each carrying a witness
   the customer's own checker can re-run. The certificate is *content*, not
   metadata: it is exactly the sequence of `Eq`/`Iso` rewrites that took `P`
   to `P'`, so the customer never trusts our optimizer — they check `C`
   locally, the way a Proof-Carrying Code consumer checks a producer's proof
   (`docs/related/VerifiedComputation_PriorArt.md`, PCC row).

**The one-sentence pitch.** Every equality-saturation optimizer in
production today — Cranelift's e-graph mid-end
([cfallin.org/blog aegraph](https://cfallin.org/blog/2026/04/09/aegraph/)),
egglog ([egraphs-good.github.io](https://egraphs-good.github.io/)), Tensat
([uwplse/tensat](https://github.com/uwplse/tensat)), Cube's SQL rewriter —
**trusts its rewrite rule set**. If a rule is wrong, the output is silently
wrong, and nothing downstream can tell. Our optimizer emits a certificate
that a small independent checker verifies, so a bad rule produces a
*rejected certificate*, never a silently miscompiled artifact. That is the
whole moat in one line: **the optimization and its proof of correctness are
the same object.**

**Why "cannot lie" is precise, not marketing.** The trust boundary is real
and stated (`legacy/runtime/STATUS.md`, "trust boundary"): only `Eq` (proof
paths), `Iso` (round-trip normalization on fresh probes), and `β` are
*genuinely* machine-checked in the seed kernel. So the honest product claim
is scoped to optimizations expressible as `Eq`/`Iso` rewrites — which is
exactly the class equality saturation already lives in. Within that class,
the certificate is not "declared", it is *re-derived by the checker*. The
weaker edge kinds (`Quotient`, `Approx`, `Implies`, …) verify only that a
certificate was *declared*, so they are out of scope for the v1 guarantee
and must not be sold as checked.

---

## 2. The first vertical: zk arithmetic-circuit optimization

**Recommendation: ship zk-circuit constraint minimization first.** The
selection criterion is the overlap *"wants a proof AND already uses / wants
e-graphs"*, scored honestly across the four candidates:

| candidate | already uses e-graphs? | wants a proof of equivalence? | shippability | verdict |
|---|---|---|---|---|
| **SQL query plans** | yes, in production (Cube uses egg to rewrite SQL; [CACM egg](https://cacm.acm.org/research-highlights/egg-fast-and-extensible-equality-saturation/)) | weakly — planners are cost-driven, "wrong plan" is a perf bug not a safety bug; nobody audits plan equivalence | high (mature IR, egg precedent) | **strong distribution, weak proof-demand** |
| **WASM / Cranelift mid-end** | yes, the reference production e-graph ([aegraph blog](https://cfallin.org/blog/2026/04/09/aegraph/)) | yes in principle, but Cranelift already ships ISLE rules + fuzzing and owns the whole stack; low willingness to bolt on an external prover | medium | **incumbent owns it** |
| **Tensor / ML graphs** | yes (Tensat/TASO; [tensat](https://github.com/uwplse/tensat)) — and TASO already ships a *graph-transformation verifier* | partial — TASO's verifier already covers rule soundness; the marginal proof value is lower, and correctness tolerance is looser (approximate kernels are common) | medium | **proof partly already solved** |
| **zk arithmetic circuits** | emerging, not yet standard | **desperately** — a wrong constraint is a soundness bug or a completeness bug in a system whose entire value proposition is verifiability | high | **best overlap — recommended** |

**Why zk wins the overlap.**

- **Proof-demand is maximal and structural, not cultural.** A zk circuit's
  reason to exist is that someone will *verify* it. An optimizer that might
  change the relation the circuit encodes is unusable unless it proves it
  did not — a miscompiled constraint is not a slow path, it is a broken
  soundness or completeness guarantee. This is the one vertical where the
  customer's core product *is already* "trust the proof, not the prover", so
  the pitch needs no education.
- **The cost model is a genuine vector, and the field already knows it.**
  Constraint count is not the only axis, and the axes trade off against each
  other by arithmetization: in R1CS/Groth16 linear operations are free and
  aggressive linear elimination shrinks the circuit, but the *same*
  substitutions inflate gate count after translation to Plonkish, where
  additions cost explicit gates
  ([Plonkify, ePrint 2025/534](https://eprint.iacr.org/2025/534.pdf)). A
  scalar optimizer must pick one target and lose on the other; our L3 keeps
  **non-dominated routes under a cost vector** (`CRYSTAL.md` §L3,
  `legacy/runtime/execute/`), which is exactly the shape this problem has.
  This is a place where the vector-not-scalar design is a *feature buyers
  can name*, not an internal nicety.
- **The market is concrete and funded.** Plonkish is the production standard
  across Polygon zkEVM, Scroll, Taiko, Linea, zkSync Era; constraint count
  maps directly to proving time and cost. Circuit-optimization tooling
  already exists and is weak on proof (Plonkify converts 250,938 → 370,086
  Plonk constraints, a 2× win over naïve, with *no* equivalence certificate;
  Circom lifecycle tools like ZCLS optimize without shipping a checkable
  proof). We enter as the proof-carrying option in a market that already
  pays for the un-proven version.
- **Synergy with the rest of the corpus.** zk verifiable computation, zkVMs,
  and decentralized proving networks are already mapped as ancestors/targets
  (`docs/related/VerifiedComputation_PriorArt.md`, zkVM and proving-network
  rows). A certified circuit optimizer is the natural upstream organ for
  those integration specs: it produces the smaller circuit *and* the
  artifact a proving market can independently re-judge.

**Concrete v1 scope.** Source IR = R1CS (and a Circom front-end);
optimizations = the checked linear-algebra rewrites that are provably
`Eq`/`Iso` — constant folding, linear-combination elimination, common
sub-expression merging, dead-constraint elimination, and R1CS↔Plonkish
gate-packing choices exposed as distinct routes on the cost frontier.
Deliberately *out* of v1: any rewrite that is only an `Approx` or a
`Quotient` (e.g. probabilistic soundness arguments), because those inhabit
the declared-not-checked half of the trust boundary (§5).

---

## 3. The pipeline, mapped to L0–L3

```
  source P (R1CS / Circom / SQL / tensor IR)
        │  front-end: parse to hash-consed terms
        ▼
  L0  content-addressed term DAG        legacy/runtime/kernel/term.py
        │  address = hash(head ‖ sort ‖ child addresses); names are a view
        ▼
  L2  proof-relevant e-graph            legacy/runtime/kernel/egraph.py
        │  union-find + congruence closure + Nieuwenhuis–Oliveras proof forest
        │  distinct paths KEPT (distinct optimizations are distinct content)
        ▼
  SATURATE with CHECKED rewrites        legacy/runtime/execute/ (e-matching)
        │  only rules whose Eq/Iso witness the kernel re-runs are applied;
        │  each union stores its justification → certificate is emitted for free
        ▼
  L3  extract non-dominated route       legacy/runtime/execute/ Pareto extraction
        │  4-component cost vector, keep the frontier, no scalar collapse
        ▼
  EMIT  P'  +  certificate C
        │  C = proof-forest path P ≡ P', a composition of L1 typed edges
        ▼
  customer re-checks C with a small independent checker (kernel/check.py shape)
```

**The mapping is not aspirational — the seed already runs each stage.**
`legacy/runtime/STATUS.md`: L0 `term.py` BUILT (33/33 tests, address stable
under varied `PYTHONHASHSEED`); L2 `egraph.py` BUILT (genuine proof forest,
directed edges never merge classes, retraction rebuilds only the cone); L3
`execute/` BUILT (checked rewriting, e-matching against e-classes,
budget-honest saturation, Pareto extraction under a 4-component cost vector,
59/59 tests, 13/13 mutants killed). The seed criterion is MET at L3: a
theorem the runtime proved itself shortened geodesics and moved the route
frontier, with a null control bit-identical at 0 applications.

**The certificate falls out of L2 for free.** Because every union in the
proof forest stores its justification, the explain operation returns the
exact path `P ≡ P'` with no extra machinery — the same property egglog
advertises as proof production
([egglog, PLDI 2023/2025](https://pldi25.sigplan.org/details/pldi-2025-tutorials/4/Unlocking-Optimizations-with-egglog-Equality-Saturation-Meets-Datalog)).
The delta from egglog is §5's honest core: our edges are *typed and
kernel-checked* (`CRYSTAL.md` §L1), and we keep distinct paths rather than
extracting one cheapest term.

---

## 4. The compounding moat: crystallization mines the customer's domain

The optimizer gets **provably** better at each customer's specific circuits
over time. The mechanism is §3.1 derivation crystallization
(`CRYSTAL.md` §3.1, `legacy/runtime/crystallize/`), already BUILT (30/30
tests, seed criterion MET: an independent problem went 29→12 kernel steps
after a mined lemma installed, null control bit-identical at 29):

1. Record every successful optimization as a DAG of kernel rewrite steps
   (`crystallize/derivation.py`).
2. Mine repeated sub-DAGs *across different customer circuits*
   (`crystallize/mine.py`, contiguity-windowed).
3. **Anti-unify** them (Plotkin/Reynolds least-general-generalization,
   `crystallize/antiunify.py`) — abstract the differing positions into
   parameters, yielding a candidate *domain-specific rewrite rule*.
4. Rebuild a proof of the generalized rule from the original witnesses and
   **kernel-check it** (`crystallize/install.py`, 7-gate install).
5. Install it as a single `Eq`/`Iso` edge. Future optimizations of similar
   circuits take one step where they took *k*.

**Why this is a moat and not just a cache.** The learned rule is
simultaneously knowledge, a rewrite, and a *checkable* rewrite — because it
was kernel-checked at install, every future certificate that uses it is
still fully verifiable by the customer. So the optimizer specializes to a
customer's hash-function circuits, their Merkle-path gadgets, their field
choice — and the specialization *ships with proof*. A competitor with an
unchecked optimizer can also cache patterns, but they cannot offer "faster
*and* still provably correct", because their learned rules are exactly as
untrusted as their hand-written ones. Our learned rules enter the trusted
set only by passing the same kernel gate as everything else. This is the
distinction from babble/DreamCoder library learning
(`docs/related/VerifiedComputation_PriorArt.md`, babble row): they learn
program abstractions for compression; we anti-unify *proof* sub-DAGs and
kernel-check the generalization, so the learned library is
correctness-preserving by construction.

The compounding is measurable in the product's own terms: report, per
customer, the kernel-step reduction on a held-out circuit after each mined
rule installs, with a null control (an unrelated circuit that must *not*
speed up). That is the seed criterion (`CRYSTAL.md` §0) turned into a
customer-facing SLA.

---

## 5. Honest gaps and the build-vs-wrap decision

**The engine is a spec + Python seed, not a production Rust engine.** The
L0–L4 kernel lives in `legacy/runtime/kernel/` (Python), is small and
correct-by-tests (kernel 33/33, mutation-hardened 13/13) but explicitly
un-tuned: `merge`'s duplicate scan is O(n²), `recompute_addr` is
tree-recursive not DAG-memoized (deliberately, for a readable trusted file),
and retraction cone width degrades on shared atoms
(`legacy/runtime/STATUS.md`, "known failure modes"). egg and egglog are
fast, mature, incremental, and deployed
([egraphs-good](https://egraphs-good.github.io/)); a from-scratch Rust
re-land would be reimplementing years of their engineering.

**The trust boundary is smaller than an unchecked optimizer's rule set —
and this is a real limit, stated plainly.** Only `Eq`, `Iso`, and `β` are
genuinely machine-checked (`STATUS.md`, "trust boundary"). Optimizations we
can *certify* are exactly those expressible as compositions of checked
edges. An unchecked optimizer can apply any rewrite its authors believe;
we can only apply rewrites we have proven. So on day one our optimizable-
rewrite set is **strictly smaller** than egg's, and some wins an unchecked
tool gets, we will not — until the rule is proven. That is the price of the
certificate and it must be sold as the trade it is, not hidden.

**The build-vs-wrap decision — recommended: WRAP egglog, add a
proof-emitting typed-edge layer.** Two options, weighed:

- **Option A — re-land the runtime's L2/L3 from `legacy/` in Rust.** Full
  control of the typed-edge lattice and distinct-path retention, which are
  our genuine differentiators. But it re-implements mature engines and
  front-loads years of performance work before the first customer artifact.
  This is the wrong first move.
- **Option B (recommended) — wrap egglog as the saturation engine; add our
  layer on top.** egglog already gives fast equality saturation, congruence
  closure, and *proof production*
  ([Better Together, POPL/PLDI 2023](https://arxiv.org/abs/2304.04332)). We
  contribute the two things it does not have and that are our whole value:
  1. **A proof-emitting typed-edge translation layer** — take egglog's proof
     terms and re-express each step as an L1 edge (`kernel/edges.py`),
     re-checking `Eq` by proof-path replay and `Iso` by round-trip on fresh
     probes through our small checker (`kernel/check.py` shape). egglog's
     proof is the *draft*; our checker is what makes the certificate
     independently verifiable, so the customer trusts our 189-statement
     checker, not egglog.
  2. **Cost-vector Pareto extraction + distinct-path retention** on top of
     egglog's extraction, ported from `legacy/runtime/execute/`.

  The crystallization loop (§4) also wraps cleanly: mine over egglog
  derivations, anti-unify, kernel-check the generalization with our checker,
  and feed the rule back into egglog's rule set as a *checked* rule.

  **Honest caveat on Option B:** we must trust egglog's *search* (which
  rewrites it explores) but NOT its *soundness* — because we re-check every
  emitted step through our own kernel, an egglog bug can only cause a
  rejected certificate or a missed optimization, never a silently wrong
  `P'`. That is the correct trust split and it is exactly the "model at the
  uncompiled boundary" stance (`CRYSTAL.md` §0): the fast untrusted engine
  proposes, the small kernel judges.

**Build-effort estimate, stated as work not toolchain.** v1 =
egglog wrapper (front-end for R1CS/Circom + egglog rule set for the checked
linear rewrites) + the proof-emitting typed-edge checker (the genuinely new
code, ~the size of `kernel/check.py` + `kernel/edges.py` re-expressed against
egglog proof terms) + cost-vector extraction ported from `execute/`. The
crystallization moat (§4) is a fast-follow, not v1, because it needs a
corpus of customer derivations to mine. The largest real risk is the
front-end fidelity (parsing R1CS/Circom to hash-consed terms without losing
the semantics the certificate must preserve), not the e-graph.

---

## Recommendation, in one paragraph

**First vertical: zk arithmetic-circuit constraint minimization.** It has
the highest "wants a proof AND uses/wants e-graphs" overlap of the four
candidates: the customer's product *is* verifiability, so proof-demand is
structural; the cost model is a genuine vector (R1CS-free-linear vs
Plonkish-gate-cost, [Plonkify 2025](https://eprint.iacr.org/2025/534.pdf))
that our L3 handles natively; the market is funded and currently served only
by un-proven tools; and it composes with the corpus's zkVM / proving-network
integration targets. **Build-vs-wrap: wrap egglog** for saturation and proof
drafting, and build our differentiator on top — a proof-emitting typed-edge
layer that re-checks every step through a small independent kernel, plus
cost-vector Pareto extraction and the crystallization loop that mines each
customer's domain into new *checked* rewrite rules over time. Re-landing L2/L3
in Rust from `legacy/` is the wrong first move; it re-implements mature
engines before the first customer artifact and delays the only thing that
distinguishes us — the certificate.

---

*Sources.* e-graph literature: egg
([CACM](https://cacm.acm.org/research-highlights/egg-fast-and-extensible-equality-saturation/),
[POPL 2021](https://dl.acm.org/doi/10.1145/3434304)); egglog
([Better Together, arXiv 2304.04332](https://arxiv.org/abs/2304.04332),
[PLDI 2025 tutorial](https://pldi25.sigplan.org/details/pldi-2025-tutorials/4/Unlocking-Optimizations-with-egglog-Equality-Saturation-Meets-Datalog));
Cranelift acyclic e-graph mid-end
([cfallin.org](https://cfallin.org/blog/2026/04/09/aegraph/),
[EGRAPHS 2023](https://pldi23.sigplan.org/details/egraphs-2023-papers/2/-graphs-Acyclic-E-graphs-for-Efficient-Optimization-in-a-Production-Compiler));
Tensat/TASO tensor superoptimization
([tensat](https://github.com/uwplse/tensat),
[MLSys 2021](https://proceedings.mlsys.org/paper_files/paper/2021/file/cc427d934a7f6c0663e5923f49eba531-Paper.pdf));
zk arithmetization: Plonkify R1CS→Plonk
([ePrint 2025/534](https://eprint.iacr.org/2025/534.pdf)). Corpus modules:
`legacy/runtime/CRYSTAL.md` (§L1 edge lattice, §L2 e-graph, §L3 route
selection, §3.1 crystallization), `legacy/runtime/STATUS.md` (BUILT vs
DESIGNED, trust boundary), `legacy/runtime/kernel/{term,edges,egraph,check}.py`,
`legacy/runtime/{execute,crystallize}/`,
`docs/related/VerifiedComputation_PriorArt.md`, `docs/ARCHITECTURE.md`,
`docs/RESULTS.md`.
