# Temporal acceleration by nested certified shortcuts

**Status.** Elementary exact model and executable replay.  This note does not
claim that twelve hours of unrestricted mathematical research equal twelve
years.  It proves the narrower statement that makes such acceleration real:
a sequence of discoveries can change a task-relative cost metric
multiplicatively when each discovered operation lawfully uses the preceding
one as a constituent.

## 1. The arithmetic picture

Start with a button `A` that performs one unit of work.  Prove that a new
button `B` performs three `A`s, then that `C` performs three `B`s, and continue.
The represented amounts are

```text
1, 3, 9, 27, ..., 3^12 = 531441.
```

Twelve Julian years contain

\[
12\cdot365.25\cdot24=105192
\]

hours.  Thus one invocation of the twelfth installed button represents more
than twelve years of one-per-hour primitive invocations.  A seventh-grade
student can check the inequality: `3^10=59049`, so
`3^12=9*59049=531441>105192`.

This is not a claim about clocks.  It is a statement about two descriptions of
the same composable operation and their costs.  Its hypotheses are the result.

## 2. Exact model

Let `a_0` be a primitive transformation.  At formation stage `i`, install a
transformation `a_i` together with a checked equation

\[
a_i=a_{i-1}^{\,r_i},\qquad r_i\geq1.                 \tag{1}
\]

The exponent means repeated composition, not multiplication of outputs.
Define the **primitive span** `R_i` of `a_i` to be the number of `a_0`
applications represented by one `a_i` application.

### Theorem 1 (product law)

For every `k`,

\[
R_k=\prod_{i=1}^k r_i.                               \tag{2}
\]

**Proof.** `R_0=1`.  Equation (1) gives `R_i=r_i R_{i-1}`.  Iterating this
recurrence proves (2).  In particular, if every `r_i>=r`, then `R_k>=r^k`.
\(\square\)

The theorem is elementary, but it locates exponential acceleration precisely:
linear formation depth becomes exponential primitive span because the
equalities are nested.

Take logarithms and define

\[
\tau(a_i)=\log R_i.
\]

Then `tau(a_i)-tau(a_{i-1})=log r_i`.  Multiplicative operational span is
additive along formation history.  This is a useful exact meaning of a changed
mathematical time coordinate; it is not a new physical time variable.

## 3. Compilation is a separate hypothesis

Let `c_i` be the cost of executing the installed `a_i`.  Equation (1) alone
does not imply that `c_i` is small.

- **Interpreted name.** If calling `a_i` recursively expands all its children,
  then `c_i=R_i`; the speedup is exactly one.
- **Installed primitive.** If formation supplies a device, table, circuit,
  algorithm, or theorem interface executing `a_i` for cost one in the declared
  metric, its per-use speedup over primitive replay is `R_i`.
- **Intermediate implementation.** In general the per-use ratio is `R_i/c_i`.

This distinction prevents a short formula, proof name, or pointer from being
miscounted as physical computation saved.  A theorem changes later motion only
when its conclusion becomes an admissible cheaper edge in the execution graph.

## 4. Formation, verification, and reuse

Let stage `i` cost `f_i` to form and `v_i` to verify.  Put

\[
F=\sum_{i=1}^k(f_i+v_i).
\]

If the terminal operation is used `M` times, primitive replay costs `MR_k`,
whereas installed execution costs

\[
F+Mc_k.                                               \tag{3}
\]

### Theorem 2 (exact amortization threshold)

If `R_k>c_k`, formation is strictly beneficial exactly when

\[
M>\frac{F}{R_k-c_k}.                                  \tag{4}
\]

If `R_k<=c_k`, no reuse count makes this tower beneficial in this cost metric.

**Proof.** Subtract (3) from `MR_k` and solve the strict inequality
`M(R_k-c_k)>F`. \(\square\)

Therefore a self-improving system must retain at least four numbers, not one
headline speedup: represented span, installed execution cost, one-time
formation/verification cost, and realized or forecast reuse.

## 5. The sequential lower bound

The product law accelerates later executions.  It does not retroactively
remove the time needed to discover its own dependent stages.

### Theorem 3 (critical-path bound)

Suppose the certificate for stage `i` requires the accepted certificate for
stage `i-1`, and stage `i` has irreducible formation-plus-validation latency
`ell_i`.  Then the wall-clock latency before `a_k` is admissible is at least

\[
\sum_{i=1}^k\ell_i.                                   \tag{5}

This remains true with arbitrarily many parallel workers.

**Proof.** The dependency forces the intervals witnessing the `k` stages to
occur in causal order.  Their lengths therefore add along that directed path.
Parallel work can shorten work off the path, not the path itself. \(\square\)

The useful loop has two motions: parallel exploration widens the candidate
frontier, while the accepted compiler tower has an irreducibly sequential
spine.

## 6. Three known-false controls

These controls are part of the statement, not afterthoughts.

1. **Nonnested discoveries.** Twelve separate shortcuts each spanning three
   primitive actions cover at most `12*3=36` actions per one use of each, not
   `3^12`.  Multiplication requires substitution of one shortcut into the
   next.
2. **Redundant discoveries.** A stage proving another name for the same macro
   has `r_i=1` and contributes no multiplicative gain.
3. **Uncompiled discoveries.** A symbolic macro interpreted by full recursive
   expansion still costs `prod r_i`; its concise address has not accelerated
   execution.

There are further boundaries.  A shortcut for one domain may not compose with
the next.  Verification can cost more than all future reuse saves.  Explicitly
printing `N` output symbols still costs at least `N` output operations.  And no
finite tower compresses twelve years of *arbitrary, adaptively chosen
discoveries*: the next discovery may depend on information absent from the
repeated task family.

## 7. The self-improving loop as mathematics

At time `t`, let a directed graph have mathematical states as vertices and
accepted transformations as edges.  Every edge carries:

- an exact semantic action;
- an execution cost;
- a derivation or proof certificate;
- its dependencies and domain;
- its formation and verification cost.

The current cost of a task is the shortest certified path in this graph.  One
formation step is:

1. find a repeated certified subpath or a new factorization;
2. propose an edge with the same endpoints and semantics;
3. verify the equality and its domain;
4. install the edge with an honestly measured cost;
5. rerun shortest paths and expose which tasks became cheaper;
6. allow later proposals to use the new edge as a constructor.

Steps 5 and 6 are the recursive core.  The product theorem appears when the
new edge at every round contains several copies of the last installed edge.
The amortization theorem decides whether the change is economically real.
The critical-path theorem prevents the system from calling coordination or
parallelism a collapse of dependent mathematical time.

This formulation connects directly to the repository's existing exact
machinery:

- shortest generated programs supply formation paths;
- proof certificates license semantic equality;
- prefix-cache submodularity prices future reuse;
- process memory preserves intermediates that change future capability;
- withdrawal support records which later shortcuts fail when an earlier one
  is revoked;
- the unitary-monoid boundary distinguishes reversible installed actions from
  actions requiring retained environment/history.

No additional metaphor is required.  A mathematical result improves the
system exactly when it changes the certified shortest-path metric of later
mathematics.

## 8. What “twelve hours = twelve years” may honestly mean

The equality is valid only after both sides are mapped into one declared unit.
For example:

> In the repeated-composition workload where baseline labor performs one
> primitive action per hour, twelve sequential ternary formations produce a
> terminal installed action with primitive span `3^12`, exceeding the number
> of baseline actions performed in twelve Julian years.

It does **not** say the twelve formations reproduce the contents of twelve
historical years, twelve researcher-years of arbitrary inquiry, or twelve
years of physical evolution.  Those equivalences require additional maps and
usually fail because history is path-dependent.

The deeper possibility is still real: an algorithm, classification, canonical
form, or impossibility theorem can delete an exponentially large future
search.  Its value is not that thought literally ran faster.  The theorem
changed which paths had to be run.

## 9. Replay

```bash
python3 machinery/twelve_step_compiler.py
cd machinery && python3 -m unittest test_twelve_step_compiler.py \
  test_innovation_acceleration.py -v
```

The tests verify the product and amortization laws, execute the false controls,
and check workload relativity. They replay the formulas; the proofs above are
the authority.

## Rigor boundary

**Proved here:** product span, exact reuse threshold, dependent critical-path
lower bound, and the three finite controls.

**Implemented here:** integer cost accounting and the twelve-stage ternary
example.

**Not claimed:** a universal law of innovation, equivalence of wall-clock and
historical time, automatic formation of the next shortcut, or empirical
self-improvement of the full repository.
