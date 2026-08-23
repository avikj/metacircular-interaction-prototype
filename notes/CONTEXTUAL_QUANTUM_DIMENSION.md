# Contextual dimension is not quantum memory dimension

The compositional crystal defines `cdim_o(A)` as the minimum number of unary
contexts whose joint observation separates every contextual-equivalence class.
That is an experiment-setting count.  It is not the number of distinguishable
predictive states.

Let

- `Q=|A/equiv_o|` be the contextual quotient cardinality;
- `m=|Y|` be the observation-alphabet size;
- `k=cdim_o(A)`.

## Sharp theorem

Then

`Q <= m^k`.

Indeed, a separating family of `k` contexts maps every quotient class
injectively into `Y^k`, which has cardinality `m^k`.

Under the zero-error interface requiring a retained process state to answer
every later admitted context exactly, the minimum classical state dimension is
`Q`.  The minimum quantum Hilbert-space dimension is also `Q`: two inequivalent
classes have some context with different deterministic outputs, so their
encoding states must have orthogonal supports; a basis state per class attains
the bound.

Thus

`Q <= m^cdim`, while `dim(H_predictive)=Q`.

The two quantities can differ exponentially.

## Equality family

Fix a finite alphabet `Y` of size `m` and let `A=Y^k`. Observe coordinate
zero. Admit unary operations swapping coordinate zero with coordinate `i`.
Every unary polynomial context is a coordinate permutation followed by the
coordinate-zero observation, so it reads exactly one coordinate.

All `m^k` tuples are contextually inequivalent. The `k` contexts reading the
`k` coordinates separate them. Fewer than `k` cannot: an unread coordinate can
be changed without affecting any chosen response. Therefore

`cdim_o(A)=k`, `Q=m^k`, and `dim(H_predictive)=m^k`.

For binary observations this is `k` experimental settings versus quantum
dimension `2^k` (equivalently `k` qubits). The logarithmic equality should not
hide the type distinction: one number counts reusable measurement settings;
the other counts mutually orthogonal retained states.

## Quantum/process correspondence

The minimum context basis is a deterministic tomography design for a classical
predictive quotient. Its response word embeds quotient classes into `Y^k`.
Quantum memory dimension prices how many response laws must coexist before the
future context is selected. Contextual dimension prices how many settings are
needed to identify one already-present law.

This is exactly the difference between storage and interrogation. Neither can
replace the other:

- a small context basis can interrogate an exponentially large memory;
- a large Hilbert space does not supply the contexts that make its basis
  operationally distinguishable.

## Changed motion

The active-observer lane should report at least the pair

`(context-basis cost, current predictive quotient dimension)`.

Optimizing information gain per probe cost does not by itself compress process
memory. Conversely, quotient refinement can raise memory dimension without
increasing the minimum number of settings proportionally. Do not call `cdim`
a memory dimension or treat a duality/trinity/quaternity of contexts as the
cardinality of the state carried by the process.

## Scope

The quantum statement is zero-error and exact, with deterministic classical
responses and selectable contexts. It does not price noisy discrimination,
collective measurements, approximate encodings, circuit depth, or physical
implementation cost.
