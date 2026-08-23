# Random DSO anchor → finite continuation witness

The uniform physical-byte anchor was batch-02 #1: `notes/RESEARCH_SYSTEM.md`,
offset 8522, length 2803.  The sampled text says that allocation should prefer
Pareto improvements and that no permanent scalar score represents scientific
value.  I used it only as a generative perturbation; the following result is
certified independently in Cubical Agda.

## Exact contact

`formal/cubical/NaturalMachine/DSOBellmanFinite.agda` defines a two-point
intermediate boundary and natural-number costs.  The first relation has

```
K true  = 0       K false = 1
```

so `true` is the isolated local choice.  The continuation has

```
L true  = 2       L false = 0.
```

The checked finite infimum (`min₂`) gives

```
min (K true + L true) (K false + L false) = 1,
```

and `continuation-evaluation` proves that the Bellman evaluation of `L`
computes the same composite.  Thus the downstream continuation changes which
intermediate witness is globally preferred.  This is the finite core of the
DSO warning against erasing dependencies by isolated local optimization.

## Rigor boundary

Proved: the concrete two-point natural-number computation and its equality to
the finite Bellman expression, checked with `agda -i .` under `--cubical
--safe`.

Not proved here: a general quantale-enriched theorem, arbitrary infima,
continuity, Pareto antichain completeness, or an optimizer for the live
repository.  Those require separate definitions and hypotheses.
