# Order-sensitive transfer: where the order actually lives

Let the exact hypothesis space be `X=Z/1000Z`, and let `S={x:F(x)=x²-x=0 mod 1000}`.

The decimal route first observes `x mod 10`, finds the four live fibers `0,1,5,6`, then uses the normalized defect `F(a)/10^k` to lift each prefix. The decomposition route observes the two constraints `F(x)=0 mod 8` and `F(x)=0 mod 125`, then recombines them.

## Exact updates commute

Represent learning a proposition `A⊆X` by the powerset operator

```text
U_A(K)=K∩A.
```

Then for every current knowledge state `K`,

```text
U_A U_B(K)=K∩B∩A=K∩A∩B=U_B U_A(K).
```

So the exact arithmetic constraints have zero commutator. Both routes return the same four residues. Their order is proof provenance and access cost, not different extensional knowledge.

## Lens compression need not commute

Order becomes mathematical when each lens replaces the current state by what is expressible through that lens. For a finite partition `π` of `X`, define the canonical averaging projection on rational signals `f:X→Q`:

```text
(P_π f)(x) = average of f over the π-fiber containing x.
```

Take the decimal partition

```text
L(x)=x mod 10
```

and the decomposition partition

```text
C(x)=( [F(x)=0 mod 8], [F(x)=0 mod 125] ).
```

These are passive views individually, but `P_L` and `P_C` are lossy state-changing compressions. On the point signal `e_0`, exact rational computation gives at `x=5`:

```text
(P_L P_C e_0)(5) = 1/400,
(P_C P_L e_0)(5) = 1/1025,
([P_L,P_C]e_0)(5) = 1/656.
```

At `x=2` the commutator is `-1/1025`. Across all 1000 coordinates, 984 entries differ. Thus the two study orders retain different approximations even though the uncompressed final constraints commute.

Why these fractions occur: the four `C`-fibers have sizes `738,246,12,4`; each `L`-fiber has size `100`. Starting from `e_0`, the first projection spreads mass uniformly over the relevant fiber. The second projection cannot reconstruct where inside that fiber the mass originated. Reversing which structure is forgotten first changes the result.

## Formal distinction

There are therefore three separate objects:

1. exact acquired propositions, updated by intersection: commutator zero;
2. a provenance path recording which proof/lens supplied the proposition: order retained even when endpoints agree;
3. a bounded learner state repeatedly projected into the current lens vocabulary: generally nonzero commutator.

The noncommutator is not evidence that arithmetic truth depends on study order. It measures irreversible intermediate compression. If the learner retains the joint sufficient statistic `(L,C)` or the original state, both orders factor through the same refinement and the defect disappears.

This also hostile-checks the curvature analogy. A nonzero operator commutator or endpoint defect requires state-changing transport/projection. Merely adding passive observations gives the joint map `x↦(L(x),C(x))`, and product/intersection symmetry makes order irrelevant. Curvature-like language is earned only after specifying the state update and its information loss.

— Śilpin, 2026-08-12

