# Successor turns critical-witness existence into an exact time

`ARITHMETIC_LIFE_FIRST_EXECUTION` starts from zero and successor. Consider the
actual causal history

\[
S_t=\{1,2,\ldots,t\},
\]

not the completed assertion that every natural is eventually available.

## Valuation at one formed integer

Fix (x>0), let (E=v_p(x)), and let (D=E+1) be its ambient valuation
depth. A critical witness must satisfy

\[
y\equiv x\equiv0\pmod {p^E},\qquad v_p(y)\ne E.
\]

Congruence forces (v_p(y)\ge E), so a witness must actually have valuation
greater than (E). The least positive one is

\[
y_*=p^{E+1}.
\]

Therefore the exact first time at which both the judgment point and a critical
witness have been formed is

\[
\boxed{\tau_p(x)=\max\{x,p^{E+1}\}}.
\]

At every (t\ge\tau_p(x)), the relative least depth at (x) is ambient
(E+1). If (x\le t<\tau_p(x)), the critical depth-(E) fiber has no
different-valuation point, so the relative depth is smaller.

This is the registered correction branch: the witness can precede the object.
For (x=p^Eu) with (u>p), successor forms (p^{E+1}) first, and the
judgment is already stabilized at the instant (x) appears. Hitting time must
track availability of both the question and its adversary.

## Addition with one coordinate fixed

Fix positive (a,b), let (v=v_p(a+b)), and hold the first coordinate (a)
fixed while successor forms candidates for the second. A one-sided critical
witness is a positive (b_*) satisfying

\[
b_*\equiv-a\pmod {p^{v+1}}.
\]

Let (rin\{1,\ldots,p^{v+1}\}) be the least positive representative of this
class (using (p^{v+1}) for residue zero). Then (r) is the first positive
one-sided witness and

\[
\boxed{\tau_p(a,b)=\max\{a,b,r\}\le
\max\{a,b,p^{v+1}\}.}
\]

The congruence already gives (r\equiv b\pmod {p^v}), while
(p^{v+1}\mid a+r), so the witness lies in the critical fiber and raises the
valuation. Positivity rules out the zero-sum endpoint.

The bound is sharp in its p-adic term: if (a\equiv0\pmod {p^{v+1}}), the
least positive representative is (p^{v+1}).

## What the organism gains and pays

This is the first proved orbit-hitting bound for an operation explicitly
present in the arithmetic life. It costs exponentially many successor steps
in the requested digit depth. Algebraic closure would erase precisely this
cost; the causal statement retains it.

After arrival, `ADAPTIVE_TRACE_PROCESS_NO_GO` still applies: the nested sensing
trace compresses to its terminal record. Successor time prices acquisition of
the critical adversary, not irreversible storage of the route.

## Rigor boundary

The formulas are proved above. Tests exhaust primes, points, and pairs over
bounded ranges as falsifiers. They are not complexity lower bounds for a life
allowed faster formed operations such as addition, multiplication, or CRT.
