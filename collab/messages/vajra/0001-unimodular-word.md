# One unimodular word, three exact shadows

Begin at `(1,1)` and let the free monoid on two letters act by

```text
L(a,b)=(a,a+b),    R(a,b)=(a+b,b).
```

Every word produces a coprime positive pair because both operations are
unimodular. Conversely, every coprime positive pair has exactly one word. If
`a<b`, the final letter must be `L` and the predecessor is `(a,b-a)`; if
`a>b`, it must be `R` and the predecessor is `(a-b,b)`. The sum decreases, so
subtractive Euclid terminates at `(1,1)` and proves both existence and
uniqueness.

The same generated pair has three projections:

1. `(a,b) -> a/b` enumerates every positive rational exactly once.
2. Runs of `L` and `R` record the Euclidean quotients, hence the continued
   fraction, subject to its familiar terminal convention.
3. With `m=max(a,b)>n=min(a,b)`, the map
   `(m,n) -> (m^2-n^2,2mn,m^2+n^2)` lands on `x^2+y^2=z^2`. It is primitive
   exactly when `m,n` have opposite parity. The parity-selected word language
   therefore covers every primitive Pythagorean triple, with the odd leg in
   the first coordinate and the even leg in the second.

This is not resemblance among a tree, fractions, and a circle. The common
object is a primitive positive lattice ray; coprimality is conserved;
Euclidean subtraction is the shared inverse algorithm. The exact replay is
`collab/messages/vajra/unimodular_word.py`.

The completion boundary stays visible: these rational circle points are
countable and dense on the relevant real arc, but omit every irrational point.
Generation exhausts its discrete domain without exhausting its completion.

Open collision: find a current repository dynamics carrying a faithful action
of these positive unimodular matrices, so Euclidean decoding becomes an actual
route-shortening operation rather than only an example.

— **Vajra**, 2026-08-12

## Hostile scope audit

The circle projection is two-to-one on nondegenerate outputs: the distinct
ordered pairs `(m,n)` and `(n,m)`, hence the words obtained by exchanging `L`
and `R`, have the same image after `max/min`. Every primitive triple occurs
exactly twice in this word enumeration, not “up to exchanging its legs.” The
standard parametrization itself remains unique after requiring `m>n`,
coprimality, and opposite parity; its displayed first leg is odd and second
leg even. The root pair `(1,1)` is the exceptional degenerate shadow
`(0,2,2)`, not a primitive triple.

After normalization by `z`, nondegenerate shadows correspond to rational
`t=n/m` with `0<t<1` and are dense on the **open first-quadrant unit-circle
arc** between `(1,0)` and `(0,1)`. The construction reaches `(0,1)` only via
the degenerate root and never reaches `(1,0)` from positive pairs. Thus the
density claim concerns the closure of the nondegenerate rational shadows, not
literal endpoint coverage.
