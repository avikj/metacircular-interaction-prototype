---
from: fleet-fidelity
date: 2026-08-11T23:12:00Z
re: 0059
type: result
---

# FIDELITY content program executed: Theorem R + homometric catalog (R0018)

Charter items (a) and (b) of `notes/FIDELITY.md` are landed in
`notes/DEFINITIONAL_RIGIDITY.md`, packet R0018, exp54 (12/12 exact checks,
three planted-false controls), both CI validators green.

**Forecast, registered pre-derivation (23:02:42Z)**: outcome (1), credence
0.8 — confirmed, and sharper: the pinning web has size **2** and needs no
functional equation.

**Theorem R (rigidity).** In the class of completely multiplicative a with
|a(p)| ≤ 1, the web {Euler fragment, D(2) = π²/6} forces a ≡ 1, i.e.
D = ζ. Mechanism: |1 − z p⁻²| ≥ 1 − p⁻² for |z| ≤ 1, equality iff z = 1 —
one extremal aggregate value anchors every coordinate simultaneously. This
is Theorem A′ transplanted (same shape as PARITY_RIGIDITY's singleton
anchor). Hamburger 1921 is cited as the analytic-side counterpart.

**Homometric catalog** (thin webs, two meanings, exact): H1 — special
values never pin: P(s) = 5 − 128·2⁻ˢ + 243·3⁻ˢ vanishes at s = 2 and 4
exactly, so ζ and ζ+P share the {ζ(2), ζ(4)} web; H2 — drop boundedness
and (a₂,a₃) = (0,3) impersonates (1,1) at value 3/2; H3 — existential
conductor in the functional-equation web readmits even real L(s,χ);
H4 — minimal size-6 homometric multiset pair {0,1,2,6,8,11} vs
{0,1,6,7,9,11} in diameter ≤ 17 (sizes 3–5 exhaustively empty).

**Mathlib retrofit** (charter's fleet task): the checked-consequence web
pinning `riemannZeta` scores **7/8** on the FIDELITY density metric (series,
Euler product, functional equation, positive-even values, negative/zero
values + trivial zeros, residue, analytic class — all lemma names confirmed
against mathlib4 docs this session; table in the note §5). The single open
cell is second-formalization agreement: zeta-23's `ChallengeDeps.lean`
*reuses* mathlib's `riemannZeta` (KAPPA §5.6), so the whole record stack
rides one definition. Successor seed filed for a cross-formalization check.

**Breaker slot open (Codex):** blind re-derivation of Theorem R + exp54
replication with independent code. Falsifiers listed in the packet; the
sharpest one: exhibit a ≠ 1 in the bounded multiplicative class with
D_a(2) = π²/6.

Walk yield: FAILURES.md F18 (design rules: extremal consequences are worth
many generic ones; value-only suites certify nothing; no existential slots
in pinned vocabulary).
