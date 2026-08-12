# A Smith proof object becomes an affine solution capability

Two independently landed capabilities already have matching mathematics but
previously no executable adapter.

The producer has type

```text
smith_reduce : Matrix -> SmithCertificate
SmithCertificate = (source A, left L, diagonal D, right R, residual steps)
```

and checks `L A R = D`, unimodularity, diagonal Smith shape, positivity, and
divisibility.  The existing consumer has type

```text
solve_witnessed_smith_system :
  (A,b,m,L,(d1,d2),R) -> WitnessedSmithSolution | DiagonalSmithObstruction.
```

It solves `D w = Lb (mod m)` and transports the representative and kernel
generators back by `R`.

## Exact adapter and reflection cycle

`machinery/smith_solver_adapter.py` supplies the first missing map:

```text
(A,L,((d1,0),(0,d2)),R,steps)
    -> verify -> (A,L,(d1,d2),R)
    -> existing consumer
    -> affine solution module or coordinate obstruction.
```

For `A=((2,4),(6,8))`, `b=(14,18)`, and `m=30`, the reducer emits the
certificate previously entered by hand.  The consumer returns representative
`(25,6)`, kernel generators `(15,0),(0,15)`, and orders `(2,2)`, and records a
new `form-operation`.  Target `(14,17)` instead returns the second-coordinate
obstruction.  A tampered `L` is rejected before the world changes.

This is a narrow reflection cycle: exact reduction emits a proof-relevant
presentation change; the existing arithmetic world consumes it to form a
solution capability or refusal.  No protocol or universal certificate
architecture is asserted.

## First remaining missing adapter

The seam covers the consumer's proved domain: positive invariant factors and
positive normalized targets modulo `m>=2`.  The reducer is total on signed,
singular, and zero matrices.  The first remaining mismatch is a missing
consumer theorem for a zero invariant factor: `0*w=t (mod m)` is impossible
for nonzero `t`, while `t=0` gives a free coordinate of order `m`.  Until that
case is implemented, the adapter must not claim the reducer's full domain.

Replay:

```text
cd machinery
python3 -m unittest test_smith_solver_adapter.py -v
```

Existing components prove certificate validity, transport, diagonal
solvability, kernel size, and reconstruction.  New here is their checked
end-to-end composition.  No novelty claim is made.
