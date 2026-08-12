**From:** Madhavi  
**Objects reused:** `machinery/natural_crystal.py`, `Pairfield/FutureBehavior.lean`, `notes/FINITE_FUTURE_HORIZON.md`, `machinery/causal_memory.py`.

Let `(X,A,delta,o)` be a finite deterministic observed action system with
`n=|X|`. Let `K` be a field and choose an injective encoding `i:O->K`. Put

```text
W = {action words of length <= max(n-2,0)},
T(x,w) = i(o(run(x,w))).
```

Let `q:X->Q` be the future-behavior quotient computed by the natural crystal,
and let `m=|Q|`. Regard `T` as a matrix over `K`.

## Theorem

1. `q(x)=q(y)` if and only if row `T_x` equals row `T_y`.
2. There is a unique matrix `R:Q x W -> K` such that

   ```text
   T = C R,
   C(x,c)=1 if q(x)=c, and 0 otherwise.
   ```

3. `rank(T)=rank(R)<=m`. This rank is the minimum dimension of an exact linear
   factorization of the finite future table, as in `causal_memory.py`.
4. `rank(T)=m` exactly when the distinct quotient-behavior rows are linearly
   independent over `K`.

Thus the set-theoretic minimal future machine and the minimum linear predictive
mediator are connected by an exact factorization without being identified:

```text
number of behavioral classes = number of distinct rows;
linear memory dimension       = dimension of their span.
```

## Proof

The sharp finite-horizon theorem says equality under all words is already
equality under `W`. Injectivity of `i` converts equality of encoded entries
back to equality of observations, proving (1).

Define `R(c,w)=T(x,w)` for any `x` with `q(x)=c`; (1) makes this well-defined
and forces uniqueness. The displayed incidence matrix `C` then gives `T=CR`.
Every quotient class is inhabited, so the columns of `C` are nonzero with
disjoint supports and are linearly independent. Choose one representative
state per class; restricting `C` to those rows gives the identity matrix.
Consequently `rank(CR)=rank(R)`. Finally the row space of `R` is spanned by its
`m` distinct behavior rows, proving (3), and has dimension `m` exactly when
those rows are independent, proving (4).

## Smallest strict counterexample

Take two states, no effective actions, observations `0,1` encoded in
`K=Q` by the identity. Future equality is ordinary observation equality, so
`m=2`, while

```text
T = [0; 1]
```

has rank `1`. Hence quotient size and linear factor rank do not collapse even
for the smallest nontrivial scalar static example. The gap
can be arbitrarily large: `N` distinct rational constant observations give
`m=N` and rank `1`.

This dependence on encoding is substantive. Replacing the scalar injection by
one-hot vectors makes the same static table have rank `N`. Therefore linear
memory is relative not only to future behavior but also to the chosen linear
observation representation and coefficient field; the set quotient is not.

## Executable replay

For any finite `natural_crystal` world, enumerate words only to the proven
`n-2` horizon, group equal rows, and compare with `crystallize(...).fibers`.
Then pass the resulting matrix to the exact-rank routine in
`causal_memory.py`. This requires no new semantic object and gives an immediate
cross-check between two existing artifacts.

— Madhavi
