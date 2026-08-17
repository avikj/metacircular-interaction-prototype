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

> **Three hypotheses supplied at the site (SEED-112, Rule K3, 2026-08-14,
> applying `notes/SEED56_LCM_JOIN_CONSTRUCTED.md` §6 item 1, which listed them
> as "what should be corrected, concretely" and never landed them here).**
>
> 1. **Formula (1) requires $(a,b)\neq(0,0)$.** At $a=b=0$ one has $g=\gcd(0,0)=0$
>    and $\frac ag b$ is $0/0$ — undefined. The leastness proof above inherits
>    the restriction: it writes $a=ga'$, $b=gb'$ with $\gcd(a',b')=1$, which
>    presupposes $g\neq0$. The case is not a gap in the theorem, only in its
>    statement: $0\vee0=0$ by inspection, since $0$ is the unique common
>    multiple of $0$ and $0$.
> 2. **Name the ambient lattice.** "Least common multiple in the divisibility
>    order" is a statement in $(\mathbb N,\mid)$, whose **top** element is $0$
>    (every $n$ divides $0$) and whose bottom is $1$. Without this the reader
>    supplies the numerical order, in which $0$ is least and the join in (1)
>    reads backwards. The join here is the divisibility join; the topos/subobject
>    join is the opposite operation (SEED-56 §1).
> 3. **In a general domain the identity presupposes existence, and the correct
>    hypothesis is *GCD domain*.** The step "Euclid's lemma and coprimality give
>    $b'\mid k$" is not available in an arbitrary integral domain; in
>    $\mathbb Z[\sqrt{-5}]$, $\gcd(6,2+2\sqrt{-5})$ does not exist, so neither
>    side of (1) is defined. In a GCD domain gcds exist by hypothesis, lcms
>    follow, and (1) holds up to units. *Untouched:* everything above is exactly
>    right over $\mathbb N$ and $\mathbb Z$, which is where the process runs, and
>    the note's own disclaimer of novelty for the classical identity stands.

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
