# Ramanujan sums are weighted fixed-sector traces

Let `C_q=<g>` act regularly on itself, and let `rho(g)` be the corresponding
permutation operator on `Q[C_q]`. Define the rational group-algebra element

```text
e_prim = (1/q) sum_(k=0)^(q-1) c_q(-k) rho(g^k).        (1)
```

Then `e_prim` is the projector onto the direct sum of the primitive complex
characters of `C_q`. It is defined over `Q`, has rank `phi(q)`, and

```text
Tr(rho(g^n) e_prim) = c_q(n).                           (2)
```

Thus the cyclotomic field trace in `RAMANUJAN_TRACE.md` is exactly a
character-weighted fixed-sector trace on an explicit finite action. It is not
an ordinary fixed-point count.

## Derivation

Over `C`, write the primitive characters as

```text
chi_a(g^k)=zeta_q^(ak),   gcd(a,q)=1.
```

The usual character idempotent for `chi_a` is

```text
e_a=(1/q) sum_k chi_a(g^-k) rho(g^k).
```

Summing over primitive `a` gives (1), because
`sum_a chi_a(g^-k)=c_q(-k)`. Orthogonality makes the `e_a` mutually
orthogonal idempotents, so `e_prim` is idempotent and has rank `phi(q)`.
On its image, `rho(g^n)` has the primitive eigenvalues
`zeta_q^(an)`; their trace is `c_q(n)`, proving (2).

There is also a direct fixed-sector form. Since the trace of a permutation is
its number of fixed basis elements,

```text
c_q(n)
 = (1/q) sum_k c_q(-k) Tr(rho(g^(n+k)))
 = (1/q) sum_k c_q(-k) #Fix(g^(n+k) on C_q).            (3)
```

For the regular action only `k=-n` contributes, but the formula identifies
the precise common operation: the primitive character idempotent weights the
twisted sectors before taking their trace.

More generally, for any finite `C_q`-set `X` and any equivariant permutation
`f`, the same matrix calculation gives

```text
Tr(f e_prim | Q[X])
 = (1/q) sum_k c_q(-k) #{x in X : f(g^k x)=x}.          (4)
```

This is the representation-ring refinement of
`TWISTED_FIXED_ORBIT_TRACE.md`. The unweighted average projects to the
trivial character and counts fixed quotient orbits. The Ramanujan-weighted
average projects to the primitive cyclotomic isotypic component.

## Why no honest set suffices

An endomap of a finite set has a nonnegative integer fixed-point count. But

```text
c_3(1)=-1.
```

Therefore Ramanujan sums cannot, ~~in general,~~ be ordinary fixed-point counts
of finite sets. ~~The smallest obstruction is already `q=3`.~~ Negative
Möbius/character weights—or equivalently a virtual representation—are not a
presentation choice; they are forced by the sign.

The full regular carrier without `e_prim` is the hostile control. Its trace
vector is `(q,0,...,0)`, not `c_q`. Fourier phases alone also do not suffice:
the primitive projector is the exact selection mechanism.

## Executable certificate

`machinery/primitive_character_projector.py` uses exact `Fraction` matrices.
It checks:

- `e_prim^2=e_prim`;
- `rank(e_prim)=trace(e_prim)=phi(q)`;
- projected matrix traces, weighted fixed-sector traces, and divisor-formula
  Ramanujan sums agree;
- at `q=12` the common trace vector is
  `(4,0,2,0,-2,0,-4,0,-2,0,2,0)`.

Replay:

```text
python3 machinery/primitive_character_projector.py
python3 -m unittest machinery.test_primitive_character_projector
```

This is standard finite-group character theory. The earned result is the
exact identification of the repo's two trace mechanisms and the sharp
set-versus-representation boundary.
