# Publishing a fitted constant where the true value was exactly ¼

**The founding instance. `CLAUDE.md` exists because of it. Canonical record:
`notes/METHOD.md` §1, which contains the corrected proof.**

## WHAT WAS DONE

`exp27` measured the block constant of a sum and published it as growing like
`0.362 log²Q` (least squares) or `0.421 log²Q` (mean extraction). The
coefficient is exactly **¼**. It comes from a single term, where the expression
`A(Q)²/4` is exact.

Two numbers, two methods, and an auditor who correctly flagged that the
sub-coefficients were method-sensitive. All three were downstream of the same
thing: nobody wrote the page of algebra.

## WHY IT FELT RIGHT AT THE TIME

The fit was good over the range examined. `log Q ∈ [1.6, 4.8]` — one decade,
nine points. A genuine `¼L² + 1.18L + 9` is fitted by a pure quadratic as
≈`0.36L²`, because over one decade the linear term has nowhere else to go.
Nine points cannot separate `L²` from `L`. `METHOD.md` puts it exactly: *this
is the whole lesson in one number.*

Note what was *not* wrong. The computation ran. The fit was real. The
disagreement between methods was reported honestly. The failure is entirely in
what was never attempted.

## WHAT IT COST

The error propagated into **two notes, a paper section, and a round of
cross-review** before it was caught. Correcting it also exposed a second error
riding along — a dropped factor `φ(m)/m`, which moved the linear coefficient
from `1.388949` to `1.181852`, and *the exact-rational computation already
printed in that same section contained the refutation and had been misread.*

The corrected derivation is under a page. It was always under a page.

## THE TELL

**You are fitting a coefficient rather than deriving it.** A fitted constant
over one decade is not a result; it is an error analysis you have not done,
with the error bars omitted.

The general form, which is worse and easier to miss (`HOLOGRAM.md` §7): **a
measured constant hides its own scaling.** A noise floor measured at
`ε ≈ 10⁻³` was really `X^{-1/2}`; deriving it changed a depth-law exponent
from `T log²T` to `T^{1/2} log^{3/2}T`. A number without its parameter
dependence is worse than no number, because it looks like knowledge.

Operative test, from `CLAUDE.md`: *a correlation coefficient has no content;
the content is the error term.* If you cannot derive the error term you do not
understand the object — and if you can, you did not need the run.
