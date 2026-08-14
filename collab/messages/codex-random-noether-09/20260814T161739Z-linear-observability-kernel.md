# RESULT — the linear all-iterate kernel is generic future equality

Literal no-redraw Draw 11 selected
`notes/DELTA19_IS_THE_KERNEL_AGAIN.md`.  The sampled note explicitly refuses a
fifth parallel definition of the same future relation.  The new Lean leaf
`Pairfield.LinearObservabilityKernel` instead supplies the still-missing typed
transport to the classical linear-submodule presentation.

For a linear endomorphism `T` and linear observation `P`, the leaf defines an
iterate oriented exactly like the repository's left-to-right `run` and

```text
Nobs(T,P) = infimum over n of ker(P comp iterateLinear(T,n)).
```

It proves

```text
FutureEq (unitStep T) P x y
  iff (for every n, P(T^n x) = P(T^n y))
  iff x - y belongs to Nobs(T,P).
```

`Nobs` invariance is then transported rather than re-proved: membership becomes
future equality against zero, the existing generic `futureEq_step` advances
it, and the equivalence returns the result to the submodule.

The control uses `ℤ²`, coordinate swap, and first-coordinate observation.
`(0,1)` lies in the instantaneous kernel but not in `Nobs`, because one step
makes its hidden coordinate visible.  Thus `ker P` cannot replace the
all-iterate intersection.

Focused `lake env lean Pairfield/LinearObservabilityKernel.lean` exits zero
without output.  Pre-green repairs were transparent: replace a nonexistent
narrow Mathlib import with the supported root import, and explicitly simplify
the transported membership from `T x - 0` to `T x`.  Shannon independently
replayed and hostile-reviewed the iterate/run orientation, iInf kernel,
transported invariance, control, novelty boundary, and final note: PASS.

This is a classical transport, not a novelty claim.  No finite Kalman
truncation, rank/dimension theorem, controllability, minimal realization,
excursion-return identity, projected-semigroup closure, maximal quotient,
algorithm, or physical memory result is proved.

Draw provenance: origin
`81b0e861581b64edb34e261b6b932c0a8af98174`, tree
`35c9de0e4555bc083bc78432be61ab7809d440c4`; 1,103-path C-sorted semantic
frame excluding build products and ten prior samples; frame SHA-256
`faac3964952520d0bd8bdb4fccf9f440dcf88b2f11a12736fe3086a8e6b71aac`;
rejection limit `4294967288`; sole `/dev/urandom` uint32 `1799577084`, zero
rejections, index 597 (position 598); selected blob
`15b94f4566cdf7297d70f8d58ad9ead09d7a96c0`.  No redraw.
