# Prime-exponent coordinates localize a congruence defect

**Status:** exact elementary composition of the exponent world with the
incremental kuṭṭaka update.

## 1. From one obstruction to its local addresses

The incremental congruence state

\[
x\equiv r\pmod M
\]

can absorb `x≡a (mod m)` exactly when

\[
\gcd(M,m)\mid a-r.                                  \tag{1}
\]

Prime-exponent coordinates refine (1). Since

\[
v_p(\gcd(M,m))=\min(v_p(M),v_p(m)),
\]

condition (1) is equivalent to the family

\[
\boxed{
v_p(a-r)\geq\min(v_p(M),v_p(m))\quad\text{for every prime }p.
}                                                     \tag{2}
\]

Here `v_p(0)=∞`, so equal residues satisfy every local condition.

Every failure has an exact local address

\[
(p,e_{\rm required},e_{\rm available}),
\]

and exponent deficit `e_required-e_available`.

## 2. AIME-level instance

Can the congruences

\[
x\equiv17\pmod{72},\qquad x\equiv23\pmod{90}
\]

hold simultaneously?

The shared modulus is

\[
\gcd(72,90)=18=2\cdot3^2.
\]

But the residue difference is

\[
23-17=6=2\cdot3.
\]

The `2`-coordinate passes. The `3`-coordinate requires exponent 2 and has
only exponent 1. Thus the constraints fail specifically at `3²`, with deficit
one. This says more than “18 does not divide 6”: it identifies the sensor level
that must change.

Replacing 23 by 35 gives difference `18`, so every coordinate passes. The
kuṭṭaka update then returns

\[
x\equiv305\pmod{360}.
\]

## 3. New executable capacity

`machinery/congruence_defect_localization.py` consumes cached `ExponentWorld`
coordinates and emits all local deficits. It cross-checks the resulting Boolean
compatibility against the scalar kuṭṭaka obstruction. Repeated encounters reuse
formed exponent coordinates rather than refactor the moduli and difference.

Five tests cover a one-prime defect, compatibility, zero difference, simultaneous
defects, and cache reuse.

The zero-difference test is load-bearing: its exponent vector is stored as
empty, but semantically `v_p(0)=infinity`, not zero. The implementation handles
that case before comparing finite coordinates.

## 4. Rigor and historical boundary

Equation (2) is a direct consequence of unique factorization and the valuation
formula for gcd. No novelty is claimed.

The historical kuṭṭaka lineage motivates Euclidean reduction and reconstruction.
Prime-adic valuation language and this defect-reporting API are modern. This note
does not attribute local exponent diagnostics to an ancient text; it composes two
exact capacities already present in the repository.
