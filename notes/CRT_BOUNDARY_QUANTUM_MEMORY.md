# CRT boundary quantum memory

**Status:** exact finite theorem. This is a correspondence between a declared
process cut and a coherent finite-dimensional realization, not a derivation of
spacetime or of physical quantum memory.

Let `m_1,...,m_n` be positive integers, put

\[
P=\prod_i m_i,\qquad L=\operatorname{lcm}_i(m_i),\qquad g=P/L,
\]

and observe `x in Z/P` only through

\[
B(x)=(x\bmod m_1,\ldots,x\bmod m_n).
\]

## Theorem (descent/reconstruction/memory trichotomy)

1. A local tuple is in the image of `B` iff its entries agree pairwise modulo
   `gcd(m_i,m_j)`.
2. There are exactly `L` compatible boundary records, and every record has
   exactly `g` source realizations.
3. Any reversible classical implementation, or isometry on the source basis,
   that exposes `B(x)` must retain a complementary register of dimension at
   least `g`. Dimension `g` is sufficient.
4. Compatible descent is exact reconstruction iff `g=1`, equivalently iff the
   moduli are pairwise coprime.

The first two statements are generalized CRT. For (3), fix one boundary
record. Its `g` source basis states are mutually orthogonal. An isometry that
gives them the same visible record must send them to `g` mutually orthogonal
states of the complementary system, proving the lower bound. Conversely,
write uniquely

\[
x=(x\bmod L)+tL,\qquad 0\le t<g.
\]

The boundary record determines `x mod L`; hence
`|x> -> |B(x)>|t>` is injective and extends to an isometry. The implementation
in `machinery/crt_boundary_quantum_memory.py` constructs this map and its exact
inverse.

Examples: `(4,6,9)` has `P=216`, `L=36`, and hidden dimension `6`, although
all 36 compatible local records glue. `(3,4,5)` has `P=L=60`, so its hidden
dimension is one and the boundary reconstructs the source.

## What changes next

The process-first spacetime lane must not identify compatibility of local
records with sufficiency of a boundary state. Every proposed finite cut should
first report both its image and its maximum fiber. In this CRT model the
fiber is a literal coherent memory register: the global coordinate discarded
by the local cover. Causal order, subsystem locality, Lorentzian geometry, and
a thermodynamic arrow remain absent; the theorem blocks promoting descent
alone into any of them.

The exact correspondence is therefore conditional on the declared source and
cut. Changing either changes the memory. It does not say that non-coprime
moduli physically store qudits.

