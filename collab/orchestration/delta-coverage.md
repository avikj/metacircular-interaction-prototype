# Delta coverage ledger — what is in the machine, and what is only on paper

**Maintained by whoever lands a Delta item. Last update: 2026-08-14, cf-sakshi.**

The four Delta documents supplied by the owner are now captured as primary
sources under `collab/upstream/raw/` with `catalog.jsonl` entries and sha256 —
they were previously only in a conversation, which meant they were not in the
machine at all. `collab/upstream/` outranks every document in this repository.

Status vocabulary, and the distinction is the point:

- **CHECKED** — a `--safe` Agda module, in the per-module gate, exit 0. It is in
  the machine and it runs.
- **NOTE** — proved or verified in prose/exact computation, not yet a checked
  term. It is *not* in the machine.
- **OPEN** — not done.
- **CITED** — deliberately not formalized; standard, and re-encoding it would be
  the gratuitous formalization Delta 22 direction 6 warns against.

| Delta | item | status | where |
|---|---|---|---|
| **15** | T15.1/T15.2 transport & inverse | CHECKED | `StructuredDefect.defect-id` |
| 15 | D15.5 structured equivalence | CHECKED | `StructuredDefect.StructuredEquiv` |
| 15 | P15.6/C15.7 bare ≠ structured | CHECKED | `witness-defect` + positive control |
| 15 | §15.3 symmetry breaking, stabilizer | OPEN | — |
| 15 | §15.4 polarization defect set | OPEN | — |
| 15 | §15.5 conditioning vs transport | OPEN | — |
| 15 | §15.6–15.7 charge grading, parity as truncation | CHECKED | `ChargeGrading` (T15.22/24, C15.23/25, T15.27, C15.28, P15.29) |
| 15 | §15.8 fixed-charge coefficient extraction | OPEN | — |
| 15 | §15.9 two projections, commutator | NOTE | `LEAKAGE_RANK_IS_INCIDENCE_RANK` |
| 15 | T15.40/C15.41 descent through quotient | CHECKED | `StructuredDefect.Descent` |
| 15 | §15.11–15.14 lifting, Čech, triples, holonomy | OPEN | — |
| 15 | T15.57 transport composes | CHECKED | `StructuredDefect.defect-comp` |
| 15 | §15.16–15.18 path dependence, truncation, proof relevance | OPEN | — |
| 15 | T15.68/T15.70 no-go as negative type | CHECKED | `refute-pullback`, `refute-transport` |
| 15 | §15.20–15.21 invariants dual to equivalences | OPEN | — |
| 15 | T15.81/C15.82 equivalence–defect dichotomy | CHECKED | `emptyFiber→¬isEquiv`, `twoPoints→¬isEquiv` |
| 15 | D15.83/T15.84/C15.85 structured defect | CHECKED | `StructuredDefect` |
| 15 | Program 15.90 finite witness | CHECKED | `witness-defect` |
| 15 | Programs 15.86–15.89 prime-pair instantiations | OPEN | — |
| **17** | T17.1/C17.2 split norm = product | CHECKED | `PairCoordinates.splitNorm` |
| 17 | §17.2–17.3 split torus, Weyl group | OPEN | — |
| 17 | C17.7 J₂ ≠ Weyl reflection | NOTE | `EXCURSION_RETURN…` §4, via T18.2 |
| 17 | §17.5–17.6 torsor, two symmetry breakings | OPEN | — |
| 17 | C17.12 cross-level self-similarity | CHECKED | `PairCoordinates` §3, as a consequence |
| 17 | T17.13 cone, parity constraint | PARTIAL | parity CHECKED (`sumIsDouble`); full cone equivalence OPEN |
| 17 | §17.9–17.12 charge sector, characters, G_m×Weyl | OPEN | — |
| 17 | Programs 17.20–17.23 SU(1,1), adelic | OPEN | — |
| 17 | T17.24/C17.25 A_{k−1} root lattice | NOTE | used by the singular-series note; T17.24 itself OPEN |
| 17 | §17.17–17.19 log bridge, formal groups, p-adic log | OPEN | — |
| 17 | Synthesis 17.32 contextual equivalence | OPEN | — |
| 17 | C17.34 humility boundary | CITED | quoted in the singular-series note |
| 17 | §17.23 item 3 (local factors from root data) | NOTE | `SINGULAR_SERIES_LOCAL_FACTOR…`, 108,596 instances |
| 17 | §17.23 items 1, 2, 4, 5 | OPEN | — |
| **18** | T18.1 tanh η identification | OPEN | — |
| 18 | T18.2 sum-gap reflection is x ↦ 1/x | NOTE | recorded as a correction |
| 18 | T18.3 gap is an exterior product | CHECKED | `PairCoordinates.Wedge` (+ shear invariance) |
| 18 | T18.4 excursion–return identity | CHECKED | `ExcursionReturn.excursion-return` |
| 18 | T18.5 dynamic sufficiency, both directions | CHECKED | `defect-zero→semigroup`, `semigroup→defect-zero` |
| 18 | T18.6 observability kernel = FutureEq | CHECKED | `ExcursionReturn` §2, both directions |
| 18 | T18.7 charge-one composition | CHECKED (structural half) | `ChargeGrading.no-cancellation` + `shift-comp`; the analytic half (off-sector contributions vanish) is OPEN |
| 18 | Feshbach/Schur, half-line, Buchstab targets | OPEN | Buchstab is the falsifiable one |
| **22** | T22.1 collision divisor, ν_p geometry | NOTE | `SINGULAR_SERIES_LOCAL_FACTOR…` |
| 22 | admissibility as a rank inequality | NOTE | same |
| 22 | T22.2 finite-observer impossibility | OPEN | needs infinitude of primes; schema only |
| 22 | T22.3 √X sufficiency | CITED | standard |
| 22 | T22.4 behavioural separator | CHECKED | `EndogenousHorizon` |
| 22 | T22.5 centre/product/gap = coefficients | CHECKED | `PairCoordinates` |
| 22 | direction 4 (finite separators) | CHECKED | `EndogenousHorizon` |
| 22 | directions 1, 2, 5 | OPEN | — |

## Count

**CHECKED 20 · NOTE 7 · CITED 2 · PARTIAL 2 · OPEN 25.**

(Delta 15 §15.6–15.7 and Delta 18 T18.7 landed 2026-08-14 in
`NaturalMachine/ChargeGrading.agda`; T18.7 counts as PARTIAL because only its
structural half — a composite of shifts δ, ε preserves the installed sector only
when δ + ε ≡ 0, and over ℕ that forces both to vanish — is a checked term.)

The honest reading: the *foundational* half of Delta 15 and 18 is in the machine
and running; Delta 17 and 22 are largely on paper. Everything in the OPEN column
is supplied material that is **not** in the machine, and the directive is that it
should be.

## The three that should go next, and why

1. **Delta 18's Buchstab target.** The only supplied item that can come back
   *negative*. Everything else on the list is a translation expected to succeed;
   this one asks whether the least-prime stopped kernel really is an
   excursion–return correction, and Delta 18 calls it falsifiable. A negative
   would be worth more than three successful translations.
2. ~~**Delta 15 §15.6–15.8, charge grading.**~~ Landed: `ChargeGrading.agda`, and
   it did unlock T18.7's structural half as predicted. What remains of §15.8 is
   fixed-charge *coefficient extraction*, which is analytic, not structural.
3. **Delta 17 T17.13's full cone equivalence.** The parity half is checked; the
   cone half is a small finite-flavoured equivalence and Delta 17 item 6
   explicitly asks for exact equivalences in Cubical Agda.

## Standing rule for this file

A Delta item moves to CHECKED only when a module carrying it passes the
per-module gate with exit 0. A note is not the machine. If you land a Delta item,
edit the row in the same commit — an unmaintained ledger becomes the next
attractor, which is the failure mode
`random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` already records
against itself.
