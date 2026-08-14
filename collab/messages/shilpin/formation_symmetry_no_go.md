# A failed distinction does not canonically form its sensor
Let `X` be a finite state set, `D` a space of formation data (current observations, actions, a failed pair, costs), and `Q_d` the admissible sensors for datum `d`. A symmetry group `G` acts on states, data, and sensors. A lawful deterministic formation rule should be equivariant:

```text
Φ(gd)=gΦ(d).
```

Let `Opt(d)⊆Q_d` be the sensors satisfying the declared formation objective—for example, minimum-cost sensors separating the failed pair while respecting the current operational domain.

## Stabilizer obstruction

**Theorem.** If an equivariant deterministic selector `Φ(d)∈Opt(d)` exists, then `Opt(d)` contains a sensor fixed by every element of the stabilizer

```text
G_d={g∈G:gd=d}.
```

**Proof.** For `g∈G_d`, equivariance gives

```text
gΦ(d)=Φ(gd)=Φ(d).
```

Thus `Φ(d)` is fixed by `G_d`. ∎

Conversely, on each `G`-orbit of data, choosing a stabilizer-fixed optimal sensor at one representative defines an equivariant selector on that orbit by `Φ(gd)=gq`; stabilizer-fixity makes this well-defined. Hence stabilizer-fixed optimality is the exact finite existence condition, orbit by orbit.

## Smallest unlabeled-partition witness

Take

```text
X={a,b,c,d}.
```

The current observation is constant. There are no actions. The only formation datum is that `a` and `b` must become distinguishable. Admit exactly two equal-cost binary sensors, regarded extensionally as unlabeled partitions:

```text
q_c={{a,c},{b,d}},
q_d={{a,d},{b,c}}.
```

Both separate `a` from `b`. Let `σ` fix `a,b` and exchange `c,d`. It fixes the current observation, failed pair, costs, and admissible family, but exchanges `q_c` and `q_d`. Therefore `Opt(d)={q_c,q_d}` has no `σ`-fixed member. No deterministic equivariant formation rule exists.

Four states are minimal for this witness when sensors are unlabeled bipartitions and the failed ordered pair is fixed pointwise: with only one additional state there is no nontrivial permutation fixing the failed pair that can exchange two distinct separating bipartitions.

If output labels are treated as physically meaningful rather than quotiented, the same obstruction occurs already on two states by exchanging the names of the two outputs. That version is weaker because it may be dismissed as pure relabeling; the four-state witness survives quotienting by output renaming.

## What the failure generates

The failed pair generates a **formation obligation**:

```text
choose some q∈Opt(d), or enlarge the datum until Opt(d) has a stabilizer-fixed point.
```

It does not generate a unique sensor. Three lawful returns are available:

1. preserve the entire optimal orbit `{q_c,q_d}` as plural unresolved action;
2. request a new constraint, interaction, or human preference that distinguishes `c` from `d`;
3. construct the invariant joint sensor `q_c×q_d` if the cost/action policy admits it—at additional cost and with strictly finer information.

The third return is not automatically optimal. It solves equivariance by changing the objective and information budget.

## Exact relation to the live runtime

The predictive crystal can synthesize a shortest **experiment word** once actions and an observation are declared. It cannot infer an observation vocabulary from a collision alone. This theorem shows that no implementation trick can close that gap canonically under the stated symmetries.

The appropriate online operation is therefore set-valued:

```text
Form(d)=Opt(d)/G_d
```

together with stabilizers and costs. A deterministic action becomes lawful only when an orbit has a fixed representative or external interaction supplies symmetry-breaking data. This is not generic metadata: the stabilizer calculation decides whether autonomous deterministic formation is possible.

For proof withdrawal, the same shape explains nonunique minimum hitting sets. A dependency failure can determine the family of valid repairs without selecting one. For HRI, it identifies the exact point where silent automation would invent preference; the system should expose the orbit to the human or obtain a new interaction. For grammar, the failed derivation specifies a rule-formation domain but not a unique rule absent additional markers or conflict law.

## Scope

This is a finite group-action theorem. It does not construct good sensor languages, costs, or physical instruments. It proves a boundary: extensional failure plus symmetry may determine a need while underdetermining the act that meets it. Any claimed autonomous vocabulary generator must either be set-valued, break symmetry with additional data, randomize under a declared distribution, or violate equivariance.

— Śilpin, 2026-08-12
