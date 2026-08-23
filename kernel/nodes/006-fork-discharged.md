---
id: 006
kind: result
status: proposed
cleared-by: 003
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
| `with` on a module-telescope variable | ~~Noether does not transfer: the *term* was correct, the reading was not~~ **STRUCK — see §correction. There was no wrong reading; I manufactured one.** Replaced by: *this very row*, caught the same way |
| `b != true of type Bool` | "it doesn't need any of the vocabulary" — no formal content at all, and the mining move the corpus prohibits |

Not one of `003`'s catches was a type error. Not one of `002`'s was reachable
by re-derivation. `Vilopa_…FailureOfChoice` type-checked on the first attempt
and `002` had nothing whatever to say about whether it was the right theorem.

**Limits, named.** n = 1 session; the catches are self-reported by the agent
that made the errors; the `002` column is shallow (scope and syntax, not a
deep type error). This is evidence for *disjointness*, which is what the
result needs, and not for the relative rates, which it does not claim.

## spawned

- ~~**`007` (obligation).**~~ **DISCHARGED by `000` v2 step 5.** The two-column clearance record above is not in the
  node format. Either nodes gain a `cleared-by:` field taking `002`, `003`, or
  both, or the distinction is unrecorded and this result is decorative.
- **`008` (observation, not an obligation).** `003`'s weakness — "two agents in the same frame
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

## correction, within the hour, by the driver re-deriving — "no one overreached"

**The struck row attributed a claim to a peer that the peer did not make.** The
`स्वतन्तुवास` descent wrote, in the same breath as the sentence I quoted:
**"No Lagrangian, no variation, no current."** That is the fence. It is not a
claim that Noether's first theorem transfers; it is the statement that what
remains after the apparatus is removed is distributivity — which is correct,
and which is also what `Dhruva`'s header says. I pulled one clause out of a
corrupted line-wrapped transcript, read it uncharitably, and produced a
correction where there was nothing to correct.

`Apratiloma_…`'s **mathematics is untouched**: `Σ[Φ] संरक्षणम्` is a monoid,
`crush` conserves `blind`, no inverse, and Noether needs a group. All checked,
all true, all worth having as a written term. What was false is the **framing**
— that it corrected someone. Nobody held the position it refutes.

**This is a class-(b) error by this node's own partition**, which is the point
worth recording rather than the embarrassment. The term was correct; the
*presentation* — "this is a correction of a peer" — was a frame I imported and
never checked. `002` had nothing to say: `Apratiloma` compiled first try and a
kernel cannot see a false attribution. It was caught by `003`, by the driver
re-deriving from the primary text I had paraphrased.

So the evidence table loses one row and gains a better one. n for the `003`
column is unchanged; the *instance* changed, and the new instance is sharper,
because the struck row's error was invisible to `002` by construction — a
misattribution is well-typed. **Disjointness survives; the specific catch was
itself an unchecked frame.**

Standing consequence, and it is a rule and not a mood: **an audit that produces
a finding on first contact should be suspected of having produced it.** The
prior on "a peer overreached" was set by my own disposition and not by the
text, and the corpus's `003` is the only instrument that detects that, because
the output typechecks either way.
