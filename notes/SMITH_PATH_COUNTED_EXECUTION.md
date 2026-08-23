# Smith path data under counted execution

The exact Smith witness in `SMITH_PATH_HOLONOMY.md` has two legal schedules

```text
p : (2,3,2) -> (1,6,2) -> (1,2,6)
q : (2,3,2) -> (2,1,6) -> (1,2,6).
```

The endpoint projection is confluent.  The presentation transport is not:

```text
Up = [-1  1  0]       Uq = [ 0  1 -1]
     [ 0  0  1]            [-1  2 -2]
     [ 3 -2  3]            [ 0 -2  3].
```

`formal/cubical/NaturalMachine/SmithPathCountedExecution.agda` compiles each
schedule as an autonomous two-step instance of `CountedExecution.run`.  Its
state retains three simultaneous observations:

1. the current diagonal;
2. the cumulative left unimodular certificate;
3. the transported class in `coker(diag(1,2,6))` needed by the existing
   holonomy witness.

Reduction computes both runs to the same endpoint.  It also computes their
retained actions to `Up` and `Uq`, and their witness classes to `(0,0,1)` and
`(0,1,4)`.  The module proves:

```text
endpoint(run p 2) = endpoint(run q 2),
transportedClass(run p 2) != transportedClass(run q 2),
```

and consequently proves that no readout from the endpoint diagonal alone can
recover both transported classes.

This is the exact compilation boundary.  `CountedExecution` is not deficient:
its state type is chosen by the caller.  If the caller chooses only the Smith
normal form, it has intentionally quotiented by schedule holonomy.  If later
tasks consume transported generators, solutions, or cokernel coordinates,
the state must retain the presentation arrow (or its action modulo the kernel
of those tasks).  Counting does not license endpoint erasure.

The Cubical module does **not** reimplement integer matrix multiplication.
The matrix identities, unimodularity, induced order-three action, and class
calculation remain certified by `machinery/smith_path_holonomy.py` and its
tests.  The new checked theorem is specifically the execution/factorization
statement: the path-sensitive observation cannot factor through the common
endpoint.

Verification:

```text
agda -i formal/cubical \
  formal/cubical/NaturalMachine/SmithPathCountedExecution.agda
```

passes under `--safe`, with no holes, postulates, or termination overrides.
