# When deterministic formation is obstructed, randomization is canonical

Continue with finite formation data `d`, finite optimal sensor set `Opt(d)`, and a group action satisfying

```text
Opt(gd)=g Opt(d).
```

The deterministic stabilizer theorem says a lawful equivariant choice at `d` exists only if `Opt(d)` contains a `G_d`-fixed sensor.

## Canonical randomized formation

Define `μ_d` to be the uniform probability measure on `Opt(d)`. Then

```text
μ_{gd}=g_* μ_d.
```

**Proof.** The map `q↦gq` is a bijection from `Opt(d)` to `Opt(gd)`, and a bijection pushes the uniform measure to the uniform measure. ∎

Thus every finite equivariant optimal family admits an equivariant randomized selector even when no deterministic selector exists.

This randomizes **which admissible sensor is executed**. It is not the linear average of sensors. The latter may fail to be a sensor, change the output type, reveal more or less information, or require a physical convex-mixture realization. The randomized policy remains inside the declared admissible family on every trial.

## Orbitwise minimal randomness

At fixed datum `d`, decompose `Opt(d)` into stabilizer orbits. A `G_d`-invariant distribution is constant on each orbit. It can be supported on one orbit `O`, where the unique invariant distribution is uniform and has Shannon entropy

```text
H=log₂ |O|.
```

Therefore the least entropy among invariant randomized optimal policies is

```text
min { log₂ |O| : O is a G_d-orbit in Opt(d) }.
```

It is zero exactly when a fixed optimal sensor exists, recovering the deterministic criterion. If exact sampling is required, this entropy is an information lower bound, not automatically the expected number of unbiased coin flips; non-power-of-two orbit sizes require rejection/arithmetic coding or a nonbinary random source.

## Four-state witness

For the exchanged sensors

```text
q_c={{a,c},{b,d}},  q_d={{a,d},{b,c}},
```

the stabilizer orbit has size two. Deterministic equivariant formation is impossible; the unique invariant optimal policy chooses each sensor with probability `1/2`, requiring one unbiased random bit per independent choice.

The result clarifies the available actions after a failed distinction:

```text
fixed point exists     → deterministic autonomous repair;
no fixed point         → preserve plural orbit, request new data, or randomize;
randomness unavailable → no equivariant single-action realization.
```

## Relation to Peirce projection

If averaging over the stabilizer is permitted in a linear sensor space, the Reynolds/Peirce projection produces an invariant **average vector**. That is a different operation from sampling an admissible orbit member. The average becomes a valid repair only with an explicit convex realization map. In integral settings the required denominator may not exist. Randomized orbit selection needs probabilities operationally, but does not claim their barycenter is an existing deterministic sensor.

## Rigor boundary

The theorem is finite and exact. It assumes `Opt(d)` is already formed and stable under symmetry. It does not supply the admissible sensor language or objective. It converts a symmetry obstruction into a precise resource: the minimum orbit entropy needed to act without inventing asymmetry.

— Śilpin, 2026-08-12
