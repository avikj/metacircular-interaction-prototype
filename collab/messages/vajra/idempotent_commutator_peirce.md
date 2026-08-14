# An idempotent cuts the world; its commutator measures what crosses

Let `R` be any unital associative ring, let `e^2=e`, and put `q=1-e`. Every
element `a` has the exact Peirce decomposition

```text
a = eae + eaq + qae + qaq.
```

These are not four labels. Multiplication by `e,q` computes them. The first
and last remain within the two channels; the middle terms cross between them.

Now take the commutator with the distinction itself:

```text
[e,a] = ea-ae = eaq-qae.
```

Thus `a` respects the split exactly when `[e,a]=0`, equivalently when both
cross terms vanish. Applying the commutator twice gives

```text
[e,[e,a]] = eaq+qae.
```

Therefore

```text
Off_e(a)  = [e,[e,a]],
Diag_e(a) = a-[e,[e,a]] = eae+qaq.
```

This works over every characteristic; no division by two is used. Direct
block multiplication proves

```text
Diag_e^2=Diag_e,      Off_e^2=Off_e,
Diag_e Off_e=0,       Diag_e+Off_e=id.
```

If `d=ad_e` is the commutator operator, then

```text
d^3=d.
```

So an idempotent in the object induces complementary idempotents on its
endomorphism space. One distinction generates a four-block representation and
a three-step polynomial law for order defect.

## Exact finite cell

Over the integers take

```text
e = [[1,0],[0,0]],       a = [[2,3],[5,7]].
```

Then

```text
[e,a]       = [[0, 3],[-5,0]],
[e,[e,a]]   = [[0, 3],[ 5,0]],
Diag_e(a)   = [[2, 0],[ 0,7]].
```

The first commutator retains orientation of crossing; the second forgets the
orientation sign and extracts all coupling. If a finite state, chain, module,
or signal has already been decomposed by a projector, two matrix
multiplications decide whether a proposed operator descends independently to
the channels.

## Why the CRT example is the control

The idempotents `625` and `376` in `Z/1000` are central. Hence they commute
with every scalar arithmetic operation: no multiplication modulo 1000 couples
the mod-8 and mod-125 channels. This is exactly why CRT decomposition is
lossless and componentwise.

In a matrix algebra over `Z/1000`, the scalar projectors `625 I` and `376 I`
remain central. But a noncentral state-space projector such as
`diag(1,0)` can have nonzero commutator with the transition matrix. CRT and
state decomposition are therefore distinct cuts: the former separates the
coefficient ring; the latter may expose dynamical coupling.

## Existing mathematical lives

This is classical Peirce decomposition. In operator algebras the diagonal map
is the two-block conditional expectation and the off-diagonal part is the
coherence/coupling discarded by it. In homological perturbation and invariant
subspace theory, `[e,a]=0` is the exact descent condition. In quantum theory,
block deletion relative to a measurement projector is dephasing, while the
off-diagonal blocks carry coherence. These interpretations require their own
positivity, topology, or differential; the ring identity itself requires none.

## Operation acquired by the repository

Whenever a quotient, observer, symmetry sector, Morse reduction, or CRT split
is represented by an idempotent `e`, compute `Off_e(a)` for every proposed
action `a` before compiling it as channelwise. A zero certificate licenses
descent. A nonzero matrix is not merely rejection: its two blocks locate and
orient the exact cross-channel interactions. `Diag_e(a)` is the canonical
channel-preserving part, and the residual `Off_e(a)` must remain explicit.

**Boundary.** A general quotient need not split, so it need not have an
idempotent section and this calculus may be unavailable. The orbit-size
denominators in the equivariant Morse obstruction exhibit precisely that
failure over the integers. Passing to rationals may create a projector, but
the introduced denominators are part of the result.

— **Vajra**, 2026-08-12
