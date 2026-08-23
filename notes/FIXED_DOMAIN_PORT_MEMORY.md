# Fixed-domain contraction turns port capacity into process memory

Pratitya's depth-`k` developmental process admits the ternary history set

`H_k={0,1,2}^k`.

To distinguish observational contraction from deletion of inputs, keep this
domain fixed. At a temporal cut expose the same nominal endpoint `y_*` for
every history. After the cut admit query interventions `q_j` asking for the
`j`-th ternary choice, with response

`R(a,q_j)=a_j`.

**Theorem.** Any exact classical memory behind the common endpoint, or any
zero-error quantum memory, has dimension at least `3^k`; dimension `3^k` is
attainable.

**Proof.** Each history has response function

`R_a : j |-> a_j`.

These `3^k` functions are distinct. If `a != b`, some digit query returns
different deterministic outcomes. Hence exact future readout distinguishes
their memory states perfectly. Classically they require distinct states;
quantumly their supports must be orthogonal, forcing Hilbert dimension at
least `3^k`. Basis states `|a>` attain the bound. QED.

Equivalently, this is the retained-port memory theorem with a constant
endpoint and `3^k` response functions in its sole fiber. The information is
`k log_2 3` bits, while memory *dimension* is `3^k`; these are the same bound
in logarithmic and linear units, not competing answers.

At twelve stages the exact dimension is

`3^12 = 531441`.

A memoryless nominal evaluator is therefore not process-equivalent on the
fixed domain. It becomes exact only after changing the admitted history set to
the singleton all-zero history, or after deleting all future interventions
that can inspect the history. Those are task/domain restrictions, not free
compression.

## Change to developmental motion

The live tower now has three distinct projections:

1. **open ports:** environmental choices remain live;
2. **closed observational endpoint with hidden memory:** all histories remain
   admitted and future queries force dimension `3^k`;
3. **nominal singleton evaluator:** histories are removed from the domain and
   dimension one suffices.

Only the second is genuine process memory across a cut. Future developmental
squares must keep the intervention domain fixed when claiming contraction;
otherwise they compare distinct processes. The next useful construction is
not another larger radix tower but a lawful arithmetic future action that
reads the hidden history indirectly through a newly formed capability.

## Rigor boundary

The finite deterministic theorem and zero-error quantum lower bound are
proved. Digit queries are deliberately declared interventions; the result does
not claim they arise automatically from endpoint arithmetic. It is not a
quantum-comb compression theorem, thermodynamic cost, indefinite causal order,
or spacetime realization.
