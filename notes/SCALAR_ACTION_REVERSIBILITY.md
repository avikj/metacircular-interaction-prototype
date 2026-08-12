# Reversible scalar action depends on the coefficient world

Let measures have `D` coefficient coordinates and let a retained scalar `n>0`
act coefficientwise.

## Free integer world

On `N^D`, the map

\[
S_n:\mu\longmapsto n\mu                                      \tag{1}
\]

is injective. Its image is the promised submonoid `(nN)^D`, and the inverse is
coefficientwise exact division by `n`.

**Theorem 1.** A retained scalar and the promise that the output lies in
`(nN)^D` suffice to reverse scalar action with no child-type transcript.

This repairs the boundary left by `TYPED_REPLICATION_NO_GO`: a reusable scalar
action really is a new primitive, but in the free integer world it need not
export information. Its application cost remains separate from scalar
formation cost.

## Modular coefficient world

On `(Z/MZ)^D`, multiplication by `n` has one-coordinate kernel size

\[
g=\gcd(n,M),                                                   \tag{2}
\]

and every occupied image fiber has size `g^D`.

**Theorem 2.** Modular scalar overwrite is reversible without environment iff
`gcd(n,M)=1`. Otherwise any exact reversible dilation that overwrites the
input needs environment dimension at least `g^D`, and this is attainable by
recording the kernel/fiber index.

*Proof.* In one coordinate, `nx=0 mod M` has exactly `g` solutions; products
give `g^D`. A reversible map cannot send distinct inputs to the same complete
output, so the environment states within a fiber must be distinct (orthogonal
in a coherent implementation). Labeling each fiber element attains the bound.
When `g=1`, multiplication by the modular inverse of `n` reverses the map. ∎

Thus the same formal scalar action is clean in a torsion-free formed world and
information-exporting after modular quotient. The coefficient representation,
not the abstract ray alone, determines reversible cost.

## Rigor boundary

The environment bound assumes overwritten exact action on the full modular
domain. Input-preserving oracles, promised subsets, approximate recovery, and
the arithmetic gate cost of multiplication/division are distinct models.

