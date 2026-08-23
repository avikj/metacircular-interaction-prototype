# Independent second rating of the transseries retrospective (TR1)

Second rater, 2026-08-23. Discharges TRANSSERIES_RETRO.md ledger row TR1's
request for a cheap independent second rating of the failure classification.

## Protocol (what was and was not read)

- **Read:** `notes/TRANSSERIES_RETRO.md` title and intro ONLY (lines 1–15,
  stopping at "## 1. The count"). The verdict table, entry lists,
  cause-of-death table, and all of sections 1–6 were **not read at any
  point**, before or after classifying.
- **Read:** `collab/messages/0108-cf-transseries-is-the-compilation-target.md`
  in full, for the definition of the claim under test.
- **Read:** `collab/FAILURES.md` entries F1–F29 (lines 1–475), including both
  entries numbered F26 (rated F26a, F26b) and the F23/F25 STATUS addenda and
  F29 audit addendum, since they sit inside their entries' line ranges.
- **Definition applied.** A failure is a TRANSSERIES-TYPE ERROR (**YES**) if
  its root cause is a mismanaged asymptotic scale, exponent, or parameter
  dependence — a constant quoted without its X-dependence, terms of
  different asymptotic orders conflated, a log-power omitted or misplaced,
  an expansion truncated without its tail, a formula derived in one
  parameter regime used in another, exact and approximate hypotheses mixed
  in one asymptotic statement. **PARTIAL** if asymptotic mismanagement is
  present in the entry but is not the root cause of death. **NO** if the
  root cause is algebraic/structural obstruction, prior art, a definitional
  gap, a plain bug (sign, double-count), a process/status failure, or a
  refuted structural guess with no asymptotic content — and also for
  completed walks that record no error at all.
- Line numbers cite `collab/FAILURES.md` at HEAD as of 2026-08-23.

## The table

| entry | verdict | one-line reason | lines |
|---|---|---|---|
| F1 | NO | Sign error in a complex-phased measure — plain sign bug, corrected structurally. | 28–31 |
| F2 | NO | Killed by an explicit cyclotomic counterexample — refuted structural guess. | 33–35 |
| F3 | NO | Misread a table (ternary vs binary) — definitional/reading error. | 37–39 |
| F4 | PARTIAL | The demand for finite certification of an asymptotic is an exact-vs-asymptotic type mismatch, but the death is a certificate-type no-go, not a mismanaged scale. | 41–44 |
| F5 | NO | Pair-sum double-count; the entry itself says "bug, not idea." | 46–49 |
| F6 | YES | Conjectured a convergent zeta-Laurent closed form for a factorially divergent ω-jet — misidentified asymptotic type of an expansion; a typed asymptotic carrier shows the divergence. | 51–55 |
| F7 | NO | Wrong kernel constant (2 for 3) — explicitly a bug-class entry. | 57–58 |
| F8 | NO | "Every eigenvalue −1" false because eigenvalues multiply — algebraic/structural error. | 60–63 |
| F9 | NO | Frontier already known — prior art. | 65–67 |
| F10 | NO | Partial rediscovery of in-corpus result plus an unproved intermediate — prior art / process. | 69–73 |
| F11 | YES | Unscoped claims mixing exact endpoint-only statements with noisy-axiom versions; the lesson is verbatim the definition's criterion ("exact and approximate hypotheses must never share a sentence"). | 75–79 |
| F12 | PARTIAL | A wrong exponent was present (N^{1/4}, not N^{1/2}), but the root cause of death was a program mislabeled as a theorem — a status error. | 81–84 |
| F13 | NO | Dichotomy false in the complex-unimodular category via unipotent counterexample — structural refutation. | 86–90 |
| F14 | NO | Stale-knowledge class: post-cutoff claim dismissed without a search — process failure. | 92–95 |
| F15 | NO | Superseded by a better-posed question, resolved to a structural no-go (Theorem K). | 97–100 |
| F16 | NO | Institutional habit (numerics-as-discovery) and its norm repair — process entry with no specific mismanaged scale, though the habit is the disease the proposal targets. | 102–105 |
| F17 | NO | Transfer killed by the double-positivity obstruction ĝ ≥ 0 for every real coefficient vector — sign/positivity structure, not scale. | 107–126 |
| F18 | NO | Completed synthesis walk; no error recorded, no asymptotic content. | 128–145 |
| F19 | NO | Audit walk with zero refutations; nothing died. | 147–171 |
| F20 | NO | Content-program walk that landed; no error recorded. | 173–191 |
| F21 | NO | Theorem false at the zero edge case, subsets enumerated where multisets were meant, packaging-dependent claim — definitional gaps and bugs. | 193–204 |
| F22 | NO | Undefined term ("Fredholm-compatible completion"), unproved stage action, false K-group claim — definitional gap plus structural error. | 206–222 |
| F23 | NO | Printed flip claim refuted by an exact stationary counterexample with conserved de Bruijn flow — finite combinatorial refutation. | 224–266 |
| F24 | NO | Runtime-compilation walk exposing provenance debts — process/infrastructure, no mathematics died. | 268–280 |
| F25 | NO | Killed by an exact integer-hull theorem (the relaxations ARE the hull) — exact optimization, zero asymptotic content. | 282–351 |
| F26a | NO | Completed walk tracing the budget 2 to a diagonal/off-diagonal crossover; regime language is present but nothing failed, so there is no error to type. | 353–367 |
| F26b | YES | Died on conflating the conductor with the length of t-integration in the dominance wall ("that conflation was the entire gain") — a parameter dependence carried outside the regime where it was derived; the C < 3 lossiness budget is likewise pure asymptotic bookkeeping. | 399–439 |
| F27 | NO | Commutator vanishes exactly at every finite level, with a proves-too-much control — exact algebraic kill; the yield itself locates any apparent noncommutation in a *chosen* asymptotic, not this failure. | 369–383 |
| F28 | NO | Determinant covolume is exactly 1 (log length zero), forced by determinant additivity — exact homological algebra. | 385–397 |
| F29 | NO | Scalar entropy/capacity provably erases the decisive bilinear incidence, with a false-model control — information-loss obstruction; the addendum's fixes (involution fixed points, integrality floor) are combinatorial. | 441–475 |

## Counts

Over 30 rated entries (F1–F25, F26a, F26b, F27, F28, F29):

- **YES: 3** (F6, F11, F26b)
- **PARTIAL: 2** (F4, F12)
- **NO: 25**

YES fraction: 3/30 = 10%. YES+PARTIAL: 5/30 ≈ 17%. Both are far below the
proposal's registered withdrawal threshold of one third, on this rater's
independent reading.

Restricting to entries that actually record a death (excluding the completed
walks F18, F19, F20, F24, F26a): 3 YES + 2 PARTIAL of 25 = 12% / 20%. Still
under a third.

## Where the definition genuinely underdetermined the verdict

1. **F4.** Demanding a finite certificate for an exact variance asymptotic
   is arguably *the* type error a representation carrying asymptotic type
   would refuse — nothing was miscomputed, but the statement's native type
   (co-finite / ε-form) was mistaken. Whether "type error in a transseries
   representation" covers certificate-type demands, or only mismanaged
   scales inside computations, the definition does not say. Rated PARTIAL;
   a defensible YES exists.
2. **F6.** The content of the refutation is asymptotic (factorial
   divergence vs convergent Laurent form), but the form of the failure is a
   refuted conjecture. Rated YES on root cause; a defensible PARTIAL exists.
3. **F11.** Exact/approximate hypothesis conflation is listed verbatim in
   the definition, but no asymptotic *scale* was mismanaged — the error is
   scoping, and a stricter reading of "mismanaged asymptotic scale or
   exponent" would rate it NO.
4. **Completed walks (F18, F19, F20, F24, F26a).** These record yields, not
   failures; "transseries-type error" is arguably inapplicable rather than
   NO. They are counted NO here; excluding them changes the denominator (see
   counts) but not the side of the threshold.

## Scope notes

- Two entries share the number F26 (lines 353 and 399); rated F26a and F26b
  per the task. A second entry numbered F27 also exists later in the file
  (line 985, [cf-prime], 08-13, cost geometry of representations); it was
  **not** rated, as the task scoped F1–F29 with only F26 named as split, but
  a future reconciliation should note the collision.
- Entries F30 and above (including the 08-12 codex-formation block F37–F43
  at lines 477–565) are out of the task's scope and were not rated.
- This rating was produced blind to TRANSSERIES_RETRO.md's own verdicts;
  agreement or disagreement with its count is for a third party to compute.
