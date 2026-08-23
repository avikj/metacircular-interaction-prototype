# Twelve causal compilations

## Exact object

Let (T_d:\mathbb Z\to\mathbb Z) be (T_d(x)=x+d).  Begin with the
successor (T_1).  At stage (k+1), select the widest already certified
translation (T_d), check

\[
T_d\circ T_d\circ T_d(x)=x+3d=T_{3d}(x),
\]

and install (T_{3d}) as a derived action of access cost one.  Crucially, the
new action is the input selected at the following stage.  Induction gives

\[
d_k=3^k.
\]

After twelve transitions, one derived-action access has the same extensional
effect as (3^{12}=531441) successor calls.  The proof cache is a chain of
thirteen nodes, and checking each derived node once costs 36 local composition
links.  The expansion is retained recursively, so no table of 531442 integer
outputs is stored.

This is a compact executable instance of the sought closure:

\[
\text{proved relation}\to\text{installed constructor}
\to\text{changed access metric}\to\text{next proposed relation}.
\]

It is stronger than twelve independent discoveries.  If each independent
discovery merely saves two base calls and none is constructed from its
predecessor, total coverage is (1+2k), hence 25 at (k=12), not (3^{12}).
Composition, not the number twelve, creates the exponential.

## What “twelve hours equal twelve years” can mean exactly

Twelve 365-day years contain 8760 twelve-hour intervals.  In this model the
least ternary compilation depth exceeding that ratio is nine:

\[
3^8=6561<8760\le 19683=3^9.
\]

Thus the statement is not an identity between durations.  It is a
cost-relative statement: after nine causally composing compilations, one unit
of *access time* can perform more of this declared operation than 8760 units
could perform in the original instruction set.  Twelve stages reach a factor
531441.  Wall time, proof-formation time, energy, and hardware parallelism have
not vanished; they occupy separate ledger coordinates.

## Relation to the current organism

The executable loop changes four pieces of state together.

1. The constructor grammar gains (T_{3d}).
2. The proof cache gains the checked composition edge back to (T_d).
3. The cost metric assigns the new semantic displacement access cost one.
4. The policy's next target changes because it selects the widest checked
   action, which is now the action just installed.

This is the smallest exact closure currently missing between
`THEOREM_AS_DERIVED_ACTION.md` and the observation/formation machinery.  It
does not yet form its own meta-rule, change arity, invent a new semantic
domain, or prove that the compiled action is useful under an external task
distribution.  It proves only the internal compounding mechanism.

## Rigor boundary

**Proved:** the induction (d_k=3^k); constant access cost under the declared
derived-action interface; linear DAG certificate size and cached replay work;
the 8760 threshold; the noncomposing linear control.

**Implemented:** `machinery/twelve_step_compiler.py` performs every transition,
checks each certificate, retains provenance, and exposes the causal trace.

**Not claimed:** calendar time literally changes; proof discovery is free;
arbitrary mathematical innovations compound at factor three; or twelve is
intrinsically privileged.  Historical acceleration needs a separate workload,
cost vector, and provenance audit.
