# Temporal acceleration is a change of metric

**Status.** Exact elementary accounting, historical calibration, and an
implementation protocol.  It does not predict discoveries and does not claim
that twelve is mathematically privileged.

## 1. What could make twelve hours equal twelve years?

Elapsed times are unequal.  The possible equality is between two executions
measured in the primitive work of an earlier machine.

Let `M_0` be a primitive operation.  During stage `i`, form and verify a macro
`M_i` whose execution invokes `M_(i-1)` exactly `r_i` times.  Expanding the
definitions gives

\[
 |M_n|_0=\prod_{i=1}^n r_i.                 \tag{1}
\]

This is induction, not an analogy.  If every newly formed macro is executed
once during the twelve-stage run, the primitive-equivalent executed work is

\[
 W_n=\sum_{i=0}^{n-1}\prod_{j=1}^{i}r_j.    \tag{2}
\]

For twelve ternary formations, the final denotation has span `3^12 = 531441`
primitive operations and (2) is `265720`.  Twelve years contain about `105120`
hours under the deliberately extravagant 24-hour baseline.  Thus either exact
quantity can exceed that baseline.  Twelve binary formations give only final
span `4096` and cumulative work `4095`; “exponential” alone is insufficient.

The equality is lawful only when the types compose.  Twelve independent
three-use shortcuts denote 36 primitive uses, not `3^12`.  The output of each
formation must be available as the repeated operation of the next.  This is
the structural meaning of *nested improvement*.

## 2. Capability is not accomplished work

Equation (1) prices what the final macro can regenerate.  Equation (2) prices
what was expanded during formation if each intermediate macro ran once.
Neither says that the physical machine secretly performed every expanded
primitive step.  A short program and its long trace are different resources.
The repository's constructor results already separate:

- schema length;
- address length;
- formation cost;
- execution cost;
- generated-world size;
- retained predictive state;
- verification cost.

A theorem resembles a macro because a short checked derivation may license an
unbounded family of later instances.  Its value is not its proof length but the
future paths it shortens.

## 3. The amortization law

Suppose an old route costs `c`, a compiled route costs `e`, formation costs
`F`, verification costs `V`, and the route is later used `N` times.  The exact
net saving is

\[
 \Delta=N(c-e)-F-V.                          \tag{3}
\]

Installation accelerates the declared future exactly when `Delta > 0`.
Precomputation without enough reuse is deceleration.  A proof that is never
called may still have option, explanatory, or cultural value, but that value
is not computational speed and must not be smuggled into (3).

For heterogeneous tasks `q`, there is generally no intrinsic scalar gain.
Given an explicit workload distribution `mu`, define

\[
 C_i(\mu)=\sum_q\mu(q)c_i(q),\qquad
 g_i(\mu)=C_{i-1}(\mu)/C_i(\mu).             \tag{4}
\]

The same capability can accelerate one workload and slow another.  Without a
declared `mu`, keep the whole cost vector and its Pareto order.  If the workload
changes because the new capability makes new questions reachable, (4) must be
recomputed; this endogenous appearance of tasks is the self-improving loop's
real frontier, not a defect in the accounting.

## 4. Six historically distinct transformations

These are mechanisms, not a triumphalist chronology.

1. **Place value changes description length.**  A base-`b` address of length
   `k` selects among `b^k` strings.  It compresses the name from unary scale to
   logarithmic scale; it does not generate all `b^k` values for free.  This is
   exactly the distinction proved in `CONSTRUCTOR_GRAMMAR_COST.md`.

2. **Iteration compiles repetition.**  Lovelace's 1843 Notes distinguish the
   fixed sequence of additions of the Difference Engine from independently
   composable Analytical Engine operations.  “Backing” a group of cards makes
   it reusable any number of times; she explicitly prices prior analytical
   labor as capital that can return a much larger family of particular cases.
   This is the macro law (1), including its formation cost.

3. **Factorization changes asymptotics.**  Cooley and Tukey factor a transform
   length into stages rather than treating all input/output pairs separately.
   The resulting FFT changes quadratic direct evaluation to order `N log N`
   on suitable composite lengths.  The gain grows with problem size; it is not
   a constant speedup or more processors.

4. **A new identity changes an exponent.**  Strassen's seven products for a
   `2 x 2` block multiplication give the recurrence
   `T(n)=7T(n/2)+O(n^2)`, hence `T(n)=O(n^(log_2 7))`, below cubic.  The seven
   bilinear identities are the reusable content.  Merely caching ordinary
   cubic products would not change the exponent.

5. **Parallelism shortens span, not work.**  Brent bounded evaluation time of
   an arithmetic expression using `p` processors by a logarithmic depth term
   plus a work-over-`p` term.  Amdahl separately identified the serial fraction
   as a ceiling on parallel speedup.  Neither mechanism can compress a chain
   of twelve logically dependent validations below its critical path.

6. **Improvement can act on improvement.**  Engelbart separates primary
   activity, improving primary activity, and improving that improvement
   process.  His crucial condition for compounded leverage is that a generic
   knowledge-work capability acts on all three.  The mathematical content is
   domain/codomain alignment: an update compounds only if it lowers the cost of
   producing or assimilating the next update, not merely the final task.

## 5. The twelve-step executable protocol

Twelve is used here as a finite experimental horizon, not installed as cosmic
law.  Each hour/stage must emit this tuple:

\[
(P_i,D_i,F_i,V_i,E_i,U_i),
\]

where `P_i` is the exact program/proof, `D_i` its dependencies, `F_i` formation
cost, `V_i` validation cost, `E_i` execution-cost vector, and `U_i` observed
reuse count or declared future-use measure.

At every stage:

1. choose a live collision under the current capabilities;
2. generate the least-cost candidate separator in the current constructor
   grammar;
3. break it and validate its claimed semantics;
4. install it only with its proof and dependency trace;
5. recompute which previously expensive operations it shortens;
6. use it in the very next formation attempt;
7. record whether the predicted reuse and gain occurred.

After twelve stages, report four quantities separately: wall time, physical
work, primitive-equivalent denotational span, and validated future saving.
Claim temporal acceleration only from the last quantity, or from (2) when its
execution premise was actually met.  This prevents a short formula for a huge
number from masquerading as years of completed mathematics.

The loop becomes self-improving when a formed operation changes the formation
transition itself:

\[
(K_i,G_i)\longmapsto(P_i,\text{proof}_i,K_{i+1},G_{i+1}),
\]

with `K` the retained capability cache and `G` the constructor grammar.  A
cache-only update changes starting points; a grammar update changes possible
edges.  Both can accelerate later work, but only the second changes which
constructions exist.  The repository has implemented the former and formation
within a declared grammar.  Autonomous formation of sound new constructors
remains open.

## 6. False controls and falsification

- **Independent shortcuts:** gains add; they do not multiply.
- **Redundant shortcuts:** a second name for the same route adds no extensional
  capability unless it measurably lowers access cost.
- **One-use shortcut:** fails (3) when formation and validation exceed saving.
- **Parallel theater:** more workers may reduce wall time but not total work or
  dependency depth.
- **Hidden library:** imported prior work must be charged as inherited capital,
  not credited to the twelve-hour run.
- **Unverified macro:** has zero installed mathematical gain until its semantic
  obligation is discharged.
- **Workload drift:** a scalar speedup is invalid after the task distribution
  changes unless it is recomputed.

Replay the elementary accounting with:

```sh
cd machinery
python3 -m unittest test_innovation_acceleration.py -v
```

## Historical sources and boundary

- A. A. Lovelace, notes to L. F. Menabrea, *Sketch of the Analytical Engine*,
  1843, especially Notes A, B, and C:
  <https://psychclassics.yorku.ca/Lovelace/lovelace.htm>.
- J. W. Cooley and J. W. Tukey, “An Algorithm for the Machine Calculation of
  Complex Fourier Series,” *Mathematics of Computation* 19 (1965), 297–301,
  DOI <https://doi.org/10.1090/S0025-5718-1965-0178586-1>.
- V. Strassen, “Gaussian Elimination is Not Optimal,” *Numerische Mathematik*
  13 (1969), 354–356, DOI <https://doi.org/10.1007/BF02165411>.
- G. M. Amdahl, “Validity of the Single Processor Approach to Achieving Large
  Scale Computing Capabilities,” AFIPS 1967,
  DOI <https://doi.org/10.1145/1465482.1465560>.
- R. P. Brent, “The Parallel Evaluation of General Arithmetic Expressions,”
  *JACM* 21 (1974), 201–206,
  DOI <https://doi.org/10.1145/321812.321815>.
- D. C. Engelbart, *Augmenting Human Intellect* (SRI, 1962),
  <https://www.dougengelbart.org/pubs/augment-3906.html>; and “Bootstrapping
  Organizations into the 21st Century” (1991),
  <https://dougengelbart.org/pubs/augment-132803-Bootstrapping.html>.

The cost identities (1)–(4) are proved directly here.  The historical sources
establish the stated inventions and their authors' distinctions; they do not
prove that the present repository has achieved compounded acceleration.
