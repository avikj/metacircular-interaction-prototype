# The first composed arithmetic-life operation: overlap to join

**Status.** Exact elementary increment to `ARITHMETIC_LIFE_FIRST_EXECUTION`.
It composes two already installed capacities; it does not claim novelty for
the classical gcd/lcm identity.

## Formation event

The existing process can reconstruct a composite as remembered factor origins

\[
a=u v,qquad b=s t,
\]

and its compiled Euclidean action can determine their overlap

\[
g=\gcd(a,b).
\]

Neither operation alone answers the next relational question: what is the
smallest arithmetic object into which both encountered objects embed? Their
composition forms a new operation,

\[
a\vee b=\operatorname{lcm}(a,b)=\frac{a}{g}b.       \tag{1}
\]

The overlap is divided out before multiplication, so shared origin is not
counted twice. The output carries exact embedding witnesses

\[
\frac{a\vee b}{a}=\frac b g,
\qquad
\frac{a\vee b}{b}=\frac a g.                       \tag{2}
\]

If (m) is any common multiple of (a,b), write (a=ga'), (b=gb'),
where (gcd(a',b')=1). Since (a\mid m), write (m=ga'k). Then
(gb'\mid ga'k), so (b'\mid a'k); Euclid's lemma and coprimality give
(b'\mid k). Hence (gab'=(a/g)b\mid m). Thus (1) is the least common
multiple in the divisibility order.

## Smallest execution

Encountering 12 and 18 first leaves the causal records

\[
12=2\cdot6,qquad18=2\cdot9.
\]

Euclidean action then finds (g=6), and the newly installed join produces

\[
12\vee18=36,qquad36/12=3,qquad36/18=2.
\]

The frontier has changed. Before the composition, the machine could decompose
individual inputs and test overlap. Afterwards it can construct the join of
two remembered objects and ask elementary divisor-lattice questions:
associativity, absorption with gcd, and transport of divisibility through
meets and joins.

## Executable boundary

`ArithmeticLife.factor` now stores the exact factor pair when it emits a
`reconstruct-origin` event. `join_origins(a,b)` is unavailable unless both
origins were actually encountered; it then returns the remembered origins,
Euclidean overlap, lcm, and both embeddings, and records `form-operation`.

The requirement of remembered origins is causal provenance, not a mathematical
hypothesis for lcm. Formula (1) works without stored factorizations. The new
capacity is specifically the process-level composition requested here: a prior
reconstruction plus an installed Euclidean action becomes a reusable join.
