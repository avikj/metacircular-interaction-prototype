# The two-adic filtration signature

**Status:** cross-lineage correction and independent elementary proof of
`TWO_ADIC_CONFINEMENT`; exact strengthening of its relation to
`FORMED_UNIT_FILTRATION_DEPTH`.

## 1. The signature

Fix `k>=3`, let `G_k=(Z/2^k Z)^*`, and let `U<=G_k`. Put

```text
B_k = ker(G_k -> (Z/4Z)^*) = 1+4Z/2^kZ,
U cap B_k = 1+2^ell Z/2^kZ,
sigma(U) = 0 if U<=B_k, and 1 otherwise.
```

At finite precision the trivial intersection is represented by `ell=k`.
The pair `(ell,sigma)` is the **filtration signature**. Calling `ell` alone
the invariant loses one exact bit.

## 2. Independent confinement proof

Reduction modulo `4` gives an exact sequence

```text
1 -> B_k -> G_k -> (Z/4Z)^* -> 1.
```

The kernel has order `2^(k-2)`, and its subgroup
`1+2^ell Z/2^kZ` has order `2^(k-ell)`. Restrict the sequence to `U`.
Its kernel is `U cap B_k`; its image has order `2^sigma`. Therefore

```text
|U| = 2^(k-ell+sigma),
[G_k:U] = 2^(ell-1-sigma).                         (2.1)
```

This proves both branches of Theorem II without choosing generators for
`G_k`, invoking cyclic index calculus, or importing the earlier chart-depth
lemma. It also includes the finite-precision trivial-intersection case.

The original displayed formula is correct. The headline “the level is the
index” is not: `<5>` and `<3,5>` have the same level `ell=2`, while `sigma` is
respectively `0,1`, giving indices `2,1`.

## 3. Independent chart-depth proof

Let `u,w in U` and `delta=v_2(u+w)>=1`. At relative observation depth `d`,
the possible multiplicative perturbations form

```text
U[d] = {nu in U: nu=1 mod 2^d}.
```

For `d>=2`, this lies in `B_k`, hence

```text
U[d] = 1+2^max(ell,d) Z/2^kZ.                       (3.1)
```

The valuation of `u nu+w` is constantly `delta` on this set exactly when
`max(ell,d)>delta`: a deeper perturbation cannot alter the leading term;
otherwise an allowed leading coefficient exposes a lower term or cancels it.

Depth `d=1` is exceptional because every unit is odd, so `U[1]=U`. It is
sufficient exactly when `sigma=0`. If `U<=1 mod 4`, then `u,w=1 mod 4`, so
`delta=1`, and every `u nu+w=2 mod 4`. Conversely choose `nu=3 mod 4` when
`sigma=1`. If `delta=1`, it raises the valuation; if `delta>=2`, it lowers the
valuation to `1`. Thus

```text
d* = delta+1   if ell <= delta,
     1         if ell > delta and sigma=0,
     2         if ell > delta and sigma=1.          (3.2)
```

The same examples refute level-only chart prediction: `<5>` and `<3,5>` both
have `ell=2`; for `(u,w)=(1,1)`, their depths are `1` and `2`.

## 4. Reciprocal transformation

Both results are projections of the subgroup's placement in the same filtered
extension.

- **Reachability changes observation design.** `ell` tells when
  principal-unit perturbations can change cancellation; `sigma` tells whether
  the one-bit chart is already constant. The reachable subgroup compiles the
  optimal sensor depth by (3.2).
- **Observation changes the reachability question.** Every depth-`d>=2` fiber
  sees only `U cap B_k`; it reconstructs `ell` but erases `sigma`. Such charts
  determine confinement only up to a factor of two. Adjoining the mod-4 sign
  sensor supplies exactly the missing bit and makes (2.1) computable.

The untranslated residual between the views is exactly one sign bit. Forming
`5` is the special transition `(3,1)->(2,1)`, where chart cost rises and
confinement disappears. Other transitions separate the effects; the signature,
not a universal monotone slogan, is the reusable object.

## 5. Rigor boundary and controls

Proved above: (2.1), (3.2), and the one-bit residual. The independent test
module `test_two_adic_filtration_signature_review.py` exhausts generated
subgroups through modulus `2^9` and checks both formulas directly.

Known-false controls that fire: index from `ell` alone; depth from
`(ell,delta)` alone; recovery of `sigma` from depth-at-least-two fibers; and
precision-independent interpretation of a finite-precision `ell=k`.

No novelty claim is made; this is finite abelian-group and elementary
valuation structure applied to correct and strengthen the repository claim.
