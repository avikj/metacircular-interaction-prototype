# Theorem-induced optimization: sufficient quotients compile execution

**Status:** generic safe-Agda theorem, arithmetic instance, extracted runtime,
and native measurement.

## Law

A sufficient quotient consists of

```text
q       : X → Q
observe : X → O
small   : Q → O
factor  : observe x = small (q x).
```

Once this theorem is imported, future observations of a state already carried
as `Q` execute through `small`; the large presentation is no longer traversed.
If an action also descends,

```text
q (step x) = smallStep (q x),
```

then every finite future executes on `Q`.  The checked theorem
`future-observation-sound` proves that observing after any number of large
steps equals observing after the corresponding small steps.

This is the machine-core optimization law:


\[
\boxed{\text{proved factorization} \Longrightarrow
       \text{replacement of future execution by the quotient path}.}
\]

It is stronger than caching.  The proof changes which state the runtime needs
to carry.

## Arithmetic instance

For unary naturals, parity is a sufficient statistic for parity observation:

```text
parity : Nat → Bool
parity (suc n) = not (parity n).
```

Successor descends exactly to Boolean negation.  Thus all future successor
observations can run on one bit.  `parity-future-compiled` is the checked
iteration theorem.

The counted direct observer structurally traverses `n` and has exact cost
`n+1`; the compiled Boolean observer has cost `1`.  `strict-parity-saving`
proves strict reduction for every nonzero large state.  For the nontrivial
even family `double n`, `parity-double` imports the arithmetic fact that its
quotient state is `false`, and `even-values-agree` proves direct and compiled
execution equal.

## Runtime

The extracted runtime prints:

```text
theorem-compiled parity: direct-even=false quotient-bit=false
```

The native benchmark compares the checked direct evaluator on `double n` with
the checked quotient-bit evaluator:

| n | direct ms | compiled ms |
|---:|---:|---:|
| 10,000 | 1.085 | 0.001 |
| 100,000 | 20.923 | 0.002 |
| 500,000 | 144.071 | 0.001 |

These timings measure an already-maintained sufficient state.  They do **not**
claim that computing `parity n` from a previously uncompressed `n` is free.
The optimization becomes real when the descended transition maintains the bit
as the system evolves, or when a proved imported theorem supplies it.  If a
caller discards the quotient and reconstructs it before every observation,
the speedup disappears.

## Rigor boundary

Agda checks the generic factorization compiler, descent under arbitrary finite
iteration, exact direct costs, strict cost reduction, and the even-family
instance.  Timings are measurements from one Apple Silicon run with Agda 2.8.0
and GHC 9.12.2.  No general claim is made that every useful observation admits
a smaller sufficient quotient; failure to factor is the exact residual that
must remain visible.
