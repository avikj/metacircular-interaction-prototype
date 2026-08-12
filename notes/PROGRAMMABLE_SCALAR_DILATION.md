# Exact dilation cost of programmable modular scalar action

Let `P` be a finite set of scalar programs, acting on
`X=(Z/MZ)^D` by `x -> nx`. Put

\[
g_n=\gcd(n,M)^D.                                               \tag{1}
\]

## Retained versus erased program

**Theorem.** For overwritten exact action:

1. If the output retains `n`, so `(n,x)->(n,nx)`, the maximum fiber size and
   minimum exact environment dimension are
   \[
   E_{\rm keep}=\max_{n\in P}g_n.                              \tag{2}
   \]
2. If the program is erased, so `(n,x)->nx`, they are
   \[
   E_{\rm erase}=\sum_{n\in P}g_n.                            \tag{3}
   \]

*Proof.* With retained program, distinct `n` label disjoint output sectors;
inside sector `n`, every occupied fiber has size `g_n`. This gives (2).

After erasure, a fiber over `y` is the disjoint union, over programs for which
`y` lies in the image, of their `g_n` preimages. Hence its size is at most the
sum in (3). The zero output lies in every scalar image, and its program-`n`
sector contains exactly `g_n` inputs, attaining the sum. Exact reversible
dilation dimension equals maximum fiber size. ∎

Thus program and kernel costs neither universally multiply nor merely add as
logarithms. Retaining the program changes a sum of sector fibers into their
maximum. If every program has common kernel size `g`, then

\[
E_{\rm keep}=g,\qquad E_{\rm erase}=|P|g,                     \tag{4}
\]

which is the product special case. If kernel sizes differ, the erased cost is
the occupied-incidence sum, sharper than `|P| max g_n`.

Example: `M=6,D=1,P={1,2,3}` gives kernel sizes `(1,2,3)`, hence retained cost
`3` and erased cost `6`, rather than the crude product bound `9`.

## Rigor boundary

The theorem concerns classical basis maps and exact overwritten dilation; the
same fiber bound applies to coherent basis-state implementation by
orthogonality. It does not treat superpositions of different action families,
approximate recovery, input-preserving oracles, or gate complexity.

