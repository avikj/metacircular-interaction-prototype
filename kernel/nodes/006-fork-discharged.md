---
id: 006
kind: result
status: proposed
parents: [004, 001, 002, 003]
discharges: 004
technique: integral-domain & unique-factorization arguments (005) — used in
  its structural sense: partition the failure set by irreducible cause
presentation: error-class over the gauge/invariant split of `001`
---
# the fork is not a fork, and not for the reason `003` predicted

## the invariant sought

`004` asks which of `002`/`003` survives self-application. Read as a choice
between two rules, that question has no gauge-independent answer: which rule
"wins" depends on what is being derived, and preference is a coordinate
reading. Per `000` step 3, change presentation before increasing resolution.

The invariant behind the question is not *which rule is better* but **what
class of error each rule can detect**. Detection class is presentation-free:
it does not depend on the workload.

## the derivation

`001` is already rule-active, and it partitions the ways a node can be wrong
into exactly two irreducible classes, because it distinguishes content from
gauge:

- **(a) derivation-internal error.** The node is wrong *within* its
  presentation: the step does not follow.
- **(b) frame error.** The node is correct within its presentation, and the
  presentation was a gauge. `001`'s own forcing instance: $\varepsilon\approx
  10^{-3}$ is a true statement in the $X=10^7$ frame and froze a variable.

These are irreducible and exhaustive under `001`. Now match the rules:

**`002` detects (a) and *structurally cannot* detect (b).** A checker accepts
any well-typed term. The frozen $\varepsilon$ was well-typed; a proof
assistant would have certified every downstream step and the corrupted
exponent with it. `002`'s reach is the technique library (its own stated
weakness), and a gauge is not outside the library — it is *inside* it,
wearing the right type.

**`003` detects (b) and is unreliable on (a).** Its status line names its
three catches and all three are frame errors: $c_2$, the fitted $0.362$, the
frozen $\varepsilon$. Independent re-derivation compares *across*
presentations, which is exactly the comparison that exposes a frozen
variable — and is also why its soundness is statistical: two agents in the
same frame agree wrongly.

## the result

**`002` is not the computable special case of `003`.** The two detect
disjoint, exhaustive error classes, and the partition is not chosen here — it
is forced by `001`, which was already active. So the fork dissolves, but the
dissolution is orthogonality, not subsumption.

**The prediction on record is refuted in its stated form.** `004` predicted
`003` survives and `002` reappears inside it. `002` does not reappear inside
`003`: a conservation law cannot detect a well-typed frame error, because
conservation is evaluated *in* a frame. Per `004`'s own clause, this does not
require revising `history/` — the iterates $P_0\to P_3$ did remove external
evaluators, and `002` is not one. A kernel is not an evaluator standing
outside the state; it is a decidable relation *on* the state, which is why
`002` satisfies metacircularity in the first place (its own strength clause).

**Both are rule-active, and the machine names which class a node was cleared
against.** A node cleared by `002` alone carries an open obligation to be
re-derived in another presentation. A node cleared by `003` alone carries an
open obligation to be checked. Neither clearance is a discharge of the other.

## evidence, with its grade

`शब्द`-grade for the historical catches (carried from `002`/`003`'s own status
lines). **`प्रत्यक्ष`-grade for one session, 2026-08-22, in which both rules ran
on the same work and their catches were measured to be disjoint:**

| caught by `002` (kernel, exit ≠ 0) | caught by `003` (re-derivation) |
|---|---|
| `lUnit` not in scope | the 47-seams claim: a ford is an *equivalence*, so components are not freely joinable — struck by its own author against `README:172` |
| `with` on a module-telescope variable | Noether does not transfer: `Σ[Φ] संरक्षणम्` is a monoid, `crush` conserves `blind` — the *term* was correct, the reading was not |
| `b != true of type Bool` | "it doesn't need any of the vocabulary" — no formal content at all, and the mining move the corpus prohibits |

Not one of `003`'s catches was a type error. Not one of `002`'s was reachable
by re-derivation. `Vilopa_…FailureOfChoice` type-checked on the first attempt
and `002` had nothing whatever to say about whether it was the right theorem.

**Limits, named.** n = 1 session; the catches are self-reported by the agent
that made the errors; the `002` column is shallow (scope and syntax, not a
deep type error). This is evidence for *disjointness*, which is what the
result needs, and not for the relative rates, which it does not claim.

## spawned

- **`007` (obligation).** The two-column clearance record above is not in the
  node format. Either nodes gain a `cleared-by:` field taking `002`, `003`, or
  both, or the distinction is unrecorded and this result is decorative.
- **`008` (obligation).** `003`'s weakness — "two agents in the same frame
  agree wrongly" — is now the *only* uncovered failure mode, since (a) and (b)
  are exhaustive. Is frame-diversity among agents measurable? The corpus has a
  measurement of exactly this shape already: sixteen genius personas returning
  a monoculture (`README`, Deconditioning). That is a frame-collapse
  measurement, and it says the uncovered mode is live rather than theoretical.

## self-application

Per `000` step 6 this node discharges `004` and spawns `007`, `008`. It does
not revise `000`; the fork was answered by `001`, which `000` step 4 already
requires be consulted. `status: proposed` because under the result itself a
node cleared by one rule is not cleared: this was derived, not checked, so it
carries the obligation to be broken by someone who did not write it.
