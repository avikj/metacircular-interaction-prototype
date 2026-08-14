# Failed descent is the exact representation-relative formation event

## The current carrier and a newly executable observation

Let `q:X->Y` be a current carrier on a declared state set `X`, and let a new
action make `f:X->Z` executable.  Say that `f` **descends through** `q` if
there is `h:q(X)->Z` with `f=h after q`.

Define the joint refinement

`j=(q,f):X -> Y x Z`.

## Theorem (fiber-splitting formation)

The following are equivalent:

1. `f` descends through `q`;
2. `f` is constant on every fiber of `q`;
3. `j` has exactly the same fibers as `q`.

If these conditions fail, `f` is genuinely new relative to the current
carrier: at least one old fiber splits.  In all cases `j(X)` is the coarsest
carrier determining both `q` and `f`.  Precisely, if `T:X->A` determines both,
then the map `T(x) |-> (q(x),f(x))` is well-defined and uniquely factors `j`
through `T` on its image.

### Proof

If `f=h after q`, equal `q`-values force equal `f`-values.  Conversely, if `f`
is constant on each `q`-fiber, define `h(q(x))=f(x)`; fiber constancy makes
this well-defined.  The fibers of `(q,f)` equal those of `q` exactly when `f`
does not split any of them.  Finally, equal `T`-values force equality of both
observables, so the displayed factor map exists uniquely. ∎

The criterion is representation-relative and avoids a false use of one-hot
coordinates.  No postprocessing of `q`, linear or nonlinear, can split a
`q`-fiber.  Adding coordinates for terminal states would replace the current
carrier rather than explain formation from it.

## Exact arithmetic event: square then cube

On `X=Z`, take

`q(x)=x^2`, `f(x)=x^3`.

The current square carrier identifies every nonzero pair `{x,-x}`.  Cubing
splits it because `(-x)^3=-x^3`.  Thus the negation symmetry acts trivially on
the old observable and by sign on the new one: the erased orbit orientation
becomes visible in one action.

The joint carrier is faithful, with exact inverse on its image:

`x = f(x)/q(x)` for `x != 0`, and `(q,f)=(0,0)` gives `x=0`.

This is stronger than a finite-chart separation: it reconstructs every
integer.  It also connects directly to the transporter obstruction in
`INVARIANT_SCHEMA_COUPLING`.  The square invariant retains a two-point orbit;
the odd observable is additional presentation/orientation data that the
invariant envelope could not regenerate.

Replay:

```sh
cd machinery
python3 fiber_splitting_formation.py
python3 -m unittest test_fiber_splitting_formation -v
```

The chart computation visualizes the split and checks the implementation; the
proof and reconstruction formula are exact for all integers.

## What this does and does not solve

This theorem gives the exact test and universal carrier once `f` becomes an
admitted executable action.  It does not explain how an action language earns
`f`.  Merely presenting an oracle for a fiber-splitting function is not the
central step-5 achievement.  The stronger formation pattern from the earlier
cancellation work is:

1. an existing operation fails to descend through `q`;
2. the failed square has a canonical residual;
3. that residual obeys an equivariance law and compiles future proofs;
4. adjoining it changes the behavioral quotient.

Square/cube isolates steps 3--4 perfectly—negation invariance versus
anti-invariance, followed by faithful reconstruction—but cubing is stipulated
as newly executable here.  The next task is to derive an analogous
fiber-splitting residual from operations already present, rather than naming
one externally.

## Scope limits

Set-theoretic carriers and total functions on a declared locus.  No finiteness,
linearity, or probability is assumed.  Costs, partial observations, noisy
measurements, and causal acquisition of `f` are excluded.  “Coarsest” means
the behavioral quotient up to bijection of the image, not minimum encoding
length.
