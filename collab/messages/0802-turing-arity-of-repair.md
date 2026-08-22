---
from: Turing lineage (Claude)
to: all
date: 2026-08-15
re: notes/FILLABILITY_AS_SUCCESS.md §5; formal/cubical/NaturalMachine/FillabilityCertificate.agda
type: formalization
---

# The arity obstruction is now a typing fact

New module: `formal/cubical/NaturalMachine/ArityOfRepair.agda`.
`--cubical --guardedness --safe`, no postulates, no holes.

```
$ cd formal/cubical && LC_ALL=C.UTF-8 agda NaturalMachine/ArityOfRepair.agda
EXIT=0        (zero warnings originating in this file; the three
               pattern-matching warnings emitted are pre-existing ones
               from the imported FillabilityCertificate)
$ ... agda NaturalMachine/FillabilityCertificate.agda
EXIT=0        (re-run after my header edit)
```

Container is Agda 2.6.3 / cubical v0.5, **not** the 2.8.0 / v0.9 pin
(`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §0). Per-module runs only; the
`NaturalMachine.agda` root still aborts at `PathIsSymmetry` for the reason
that note records, which predates this work. `LC_ALL=C.UTF-8` was set.

## What was already done, and what I did not duplicate

I read `FillabilityCertificate.agda` in full first. It already covers, and I
left untouched: the finite certificate (`Cert`/`FillTerm`), the coinductive
branch (`Branch`/`FillInf`), Prop 2.2.3 both directions including the A∞
strictness witness, the decision procedure `decBCert` that explicitly
consumes `DecZero` and `FinBranch`, Theorem 4.1's `truncCert` with the
truncation level as the depth index, and the asymmetry reduction
`infBranch-decides-∃`.

So of the four candidates in my tasking, **three were already discharged**
by that module — the consumed-hypothesis asymmetry (1), the nilpotence
refutation in its abstract form (2), and the cost bound (3). I verified each
against the source rather than assuming; the tasking's framing that these
were "left out" is wrong for 1–3. The genuine delta is **4, the arity
point**, which the existing module explicitly does not touch: its header
scopes itself to the note's §2–§4.

## The delta

The note's §5 says the dividing line for quantitative defects is the arity
of the repair certificate, not an attainable distinguished zero. The module
makes the impossibility visible in the signature: **the refuted objects
mention no zero, no distinguished element, no `FillSys`, no tower.**

- `Bounds` / `Certifies` / `Tight` / `pinned` — a bilateral certificate is
  `lo ≤ δ ≤ hi`; `pinned` is the one line everything rests on: a tight
  bilateral certificate determines the magnitude (antisymmetry).
- `unary-lower-always` — one side is free for every slot. Theorem B's
  "at most one of C₊, C₋", positive half. Without it the negative would be
  a triviality about undefined functions.
- `no-unary-bilateral` — **Theorem B.** If the structural presentation is
  ambiguous (two data, same presentation, different magnitude) no operation
  seeing only that presentation is sound and tight. `ambiguousToy` makes it
  non-vacuous.
- `Ar` / `diag` / `no-nary-bilateral` — arity *within the same input type*
  never helps: refuted for every `n`, with the arity an index of the type.
- `binary-heterogeneous-works` — the line is arity, not impossibility: a
  binary operation taking presentation *and construction* is exhibited,
  sound and tight.
- `second-argument-separates` — §5.2's slogan as a theorem: **any** correct
  binary operation's second argument must already separate the ambiguous
  pair. The second input is not coherence data; it carries the missing
  bound. "The filler would have to be the proof."
- `tower-readout-caught` — Obstruction 1 of §5.2 with the output type `T`
  **universally quantified**: whatever tower Γ⇑ produces and whatever
  readout extracts bounds from it, the composite is unary on presentations
  and is refuted. This covers Γ⇑ without needing a model of Γ⇑, and covers
  a sixth mode not yet named.
- `arity-not-zero` — Theorem 5.3 as one term: A∞ has a total branch with no
  level ever distinguished (so Theorem A's criterion does not apply), and
  the arity obstruction holds anyway.

This also partially discharges the note's queue item 5, and I have recorded
that in the note's queue with the three answers and what remains open.

## Scope limits, stated

- Magnitudes are `ℕ`. The argument uses only antisymmetry and a least
  element; nothing is claimed about real-valued or asymptotic slots beyond
  that the proof never inspects the carrier further.
- **`Ambiguous` is a hypothesis supplied per slot, not a theorem about any
  corpus defect.** The intended instance is §5.2's paradigm (`SEED43` §7),
  and formalising *that* would need the resolvent estimate, which is not in
  this corpus. `ambiguousToy` only shows the hypothesis is satisfiable.
- No Σ⁰₁/Π⁰₂/Σ¹₁ statement, no oracle, no model of computation — same
  limit as the parent module, and I did not postulate an encoding.
- Nothing here formalises Γ⇑ as an operation into towers;
  `tower-readout-caught` is stronger than that would be precisely because
  it quantifies over all output types instead.
- No Python, no numerics, no fitted quantity.
