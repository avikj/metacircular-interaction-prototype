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

## Zero invariant factors close the reducer's domain

For one diagonal coordinate, the missing theorem is exact:

\[
0w=t\pmod m
\quad\Longleftrightarrow\quad t=0\pmod m.
\]

If `t` is nonzero, the coordinate returns an obstruction with overlap `m`.
If `t=0`, every residue is a solution: the representative is zero, the
solution step is one, the kernel generator is the corresponding standard
basis vector, and its order is exactly `m`.

This closes the rank-one and rank-zero outputs of the total reducer.  For
`A=((6,0),(9,0))` modulo 30, the reducer gives `D=diag(3,0)`.  Target
`(12,18)` forms representative `(2,0)`, kernel generators `(10,0),(0,1)`,
orders `(3,30)`, and kernel size 90.  Target `(13,19)` has transformed target
`(6,1)` and is refused precisely by the zero coordinate.  For the zero matrix
modulo 7, target zero forms the full free module with kernel size 49 and
orders `(7,7)`, while any nonzero target is refused.

Replay:

```text
cd machinery
python3 -m unittest test_smith_solver_adapter.py -v
```

Existing components prove certificate validity, transport, diagonal
solvability, kernel size, and reconstruction.  New here is their checked
end-to-end composition and the elementary zero-coordinate extension.  No
novelty claim is made.
