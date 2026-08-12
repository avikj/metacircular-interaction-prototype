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
   therefore enumerates primitive Pythagorean triples, up to exchanging legs.

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
