# Draft 5 — "Tool and computational resource disclosure" (goes in every abstract, paper, and PR)

Tao's ICM 2026 essay asks for exactly this section; the 11 Sep declaration
complains about its absence; the Erdős-problems repository requires its
content in structured form. Include it verbatim in every submission. Edit
the bracketed parts; do not soften the rest.

---

**Tool and computational resource disclosure.**
Every theorem cited in this work is machine-checked: the Cubical Agda
modules under Agda 2.8.0 with agda/cubical v0.9 using `--cubical --safe`
(no postulates, no termination pragmas, no holes in any cited module; the
twelve `postulate`s in the repository are FFI `putStrLn` bindings in IO
modules and are not cited), and the Lean modules under Lean 4.33.0 with
mathlib v4.33.0, gated by an executable (`lake exe yogyanupalabdhi`) that
rejects any declaration depending on an axiom outside
`{propext, Classical.choice, Quot.sound}` unless listed with a written
reason in `axiom-allowlist.txt`; that list currently has one entry, an
`ofReduceBool` instance whose kernel-checked alternative was observed to
exhaust memory, documented there.

Large language model assistants ([Claude, models and dates]; [others])
were used throughout for drafting proofs, prose, and tooling, and for
adversarial review of the author's claims. The author designed the
calculus, chose every statement, and directed and corrected the
assistants; a running log of the assistants' mathematical errors and
the corrections (`ERRATA_LOG.md`) and an append-only ledger of what was
settled and when (`agent-notes-claude-understanding.txt`) are in the
repository. No AI-generated text was accepted without the corresponding
term typechecking. Verification, in every case, certifies the formal
statement; whether the formal statement matches the informal claim is
argued in the text, and where the repository's own working notes mark a
claim as not yet formalized (the SAT and geodesic notebooks under
`research/`), this work does not cite it.

Computation: `sh check` (kernel + fibre + Lean root closure) runs in
[N] minutes on [machine]; `sh check --all` in [N] on [machine] with
`GHCRTS=-M12500m`, needed because one module holds ~10 GB live. The
interaction-net measurements were taken on [HVM3/HVM4 commit] built with
[gcc], [machine]; the suite is `collab/bend2-cubical/suite.sh`.
