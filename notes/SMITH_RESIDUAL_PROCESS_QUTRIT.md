# An endogenous process qutrit in Smith descent

Consider the three integer matrices

`A_c=((2,0),(1,7))`, `A_r=((2,1),(0,7))`, `A_d=diag(2,3)`.

The exact Smith machine reports scalar Euclidean residual `1` first in every
case. Thus the scalar observation map `s(A)=1` places all three states in one
visible fiber. Yet the machine's next lawful constructor kinds are respectively

`column-residual`, `row-residual`, `divisibility-residual`.

These are not externally supplied digit queries. They are the three branches
of the already proved residual-directed Smith descent: lower-left reduction,
upper-right reduction, and diagonal nondivisibility injection.

**Theorem.** Any exact controller that crosses a cut exposing only scalar
residual `1` but must later continue the Smith machine on these three states
requires at least three internal states. Any zero-error quantum memory requires
Hilbert dimension at least three. The typed residual record attains the bound.

**Proof.** The next-action kind is a deterministic future observation. The
three histories give three different outcomes while sharing the same visible
scalar cut. Hence an exact controller's hidden records must be distinguishable;
classically they are distinct states, and quantumly their supports are
orthogonal. A basis qutrit labeled by the three kinds suffices for this witness
family. The full typed record `(kind,pivot,quotient,remainder,state)` used by
the Smith machine is sufficient for general continuation and in particular
attains the three-way separation here. QED.

The phrase “qutrit” prices dimension, not quantum advantage. The same memory
is a classical trit. What is specifically process-theoretic is the operational
criterion: identical present observation, different lawful future response.

## Decisive no-go and changed motion

There is no exact next-action policy `kind=f(remainder)` even on residual one.
Consequently scalar residual feedback cannot close the Smith organism. The
machine must retain the origin type across the observation cut or recompute it
from the full matrix state. This makes the correction in `TYPED_RESIDUAL`
quantitative: its smallest exhibited hidden controller is dimension three.

The organism should now treat a residual as dependent process data, not a
free-standing number. When proposing that an obstruction generates its repair,
compute the future-response classes inside each advertised scalar obstruction
fiber. Their maximum cardinality is the exact zero-error memory dimension
needed to make the generation lawful.

This also joins the developmental-port theorem without an artificial oracle:
the arithmetic machine itself supplies the future separator. The residual
fiber is noninjective, and the already generated constructor schema reads the
hidden state through its next action kind.

## Scope

Proved for the displayed three-state witness family and the deterministic
Smith controller. The theorem does not claim that three states suffice for all
matrices when only scalar remainder is retained; globally more typed data are
needed. It is not a stochastic/quantum process tensor, thermodynamic bound,
causal-order superposition, or spacetime realization.
