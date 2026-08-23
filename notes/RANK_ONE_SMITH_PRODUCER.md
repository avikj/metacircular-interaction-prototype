# Total producer of rank-one Smith witnesses

`notes/RANK_ONE_SMITH_PRESENTATION.md` closed with an explicit boundary: the
presentation arrow consumed an outer-product factorization and two Bezout
equations, and "does not yet compute those witnesses from a bare hypothesis
`det A = 0`; witness acquisition is the remaining total producer problem."

That problem is now closed, in
`formal/pairfield/Pairfield/RankOneWitness.lean`.

## Statement

For every `A : IntMat2` with `A.det = 0` there is a computable
`produce A hdet : Witness` with `(produce A hdet).source = A`, and the
resulting certificate passes the shared `SmithCertificate2` gate.

## The construction

Two normalizations, and a projection between them that costs no gcd.

1. **Row direction.** If a row `(u,v)` of `A` is nonzero, `e = gcd(u,v) > 0`
   and `(p,q) = (u/e, v/e)` is primitive, with `gcd(p,q)=1` supplying a Bezout
   pair `x p + y q = 1`.

2. **The other row is free.** Write `A = [[a,b],[c,d]]` with `(a,b) = e(p,q)`.
   Put `k = c x + d y`. Then

   ```
   k p - c = y (d p - c q),   d - k q = x (d p - c q),
   ```

   and `e (d p - c q) = d a - c b = -det A = 0`, so `d p - c q = 0` because
   `e ≠ 0`. Hence `(c,d) = k (p,q)` — the second row's multiplier is recovered
   by *projecting along the Bezout pair already computed*, and no second
   Euclid run is needed. This is where `det A = 0` is spent, and it is spent
   exactly once.

   The branch where the first row vanishes is the mirror image with `g = 0`;
   the zero matrix has no nonzero row and takes the identity witness.

3. **Column direction.** `(g,k)` normalizes the same way: `h = gcd(g,k) ≥ 0` is
   the Smith invariant and the normalized factors carry the column Bezout
   pair. `h = 0` exactly on the zero matrix.

Composing with the presentation arrow of the earlier note gives
`L A R = diag(h,0)` from `det A = 0` alone.

## The kernel-executability finding

The first version of this producer used Mathlib's `Int.gcdA` / `Int.gcdB`. It
type-checked, and every stated theorem held — but `decide` could not evaluate
a single control: `Int.gcdA 2 3 = -1` gets stuck, because `Nat.xgcdAux` is
defined by well-founded recursion through `Nat.strongRec`, which the kernel
does not unfold. `Int.gcd` itself reduces; only the *extended* coefficients do
not.

That is a real distinction and worth stating plainly, because it is invisible
from the proofs: such a producer is executable by the compiler and inert in
the kernel. Its outputs can only be checked by trusting compiled evaluation —
which is the same trust boundary as `native_decide`, arrived at sideways.

So the module carries its own extended Euclid, structurally recursive in an
explicit fuel argument:

```
xgcd 0        a b = (sign a, 0)
xgcd (n+1)    a b = if b = 0 then (sign a, 0)
                    else let (x,y) = xgcd n b (a % b) in (y, x - (a/b) * y)
```

with `xgcd_spec : b.natAbs ≤ fuel → x * a + y * b = gcd a b`, proved by
induction on the fuel from `gcd b (a % b) = gcd a b` and
`|a % b| < |b|`. Calling it at `fuel = |q| + 1` discharges the bound
unconditionally, so `bezoutPair` is total with no side condition.

The controls at the end of the module are then genuine kernel evaluations —
`(produce ⟨2,4,4,8⟩ _).h = 2`, `(produce ⟨0,0,3,6⟩ _).h = 3`,
`(produce ⟨6,9,10,15⟩ _).certificate.check = true` — each by `decide`.

## Rigor boundary

`#print axioms` gives `propext, Classical.choice, Quot.sound` for `produce`,
`produce_check`, `produce_source`, and `xgcd_spec`: no `sorry`, no
`native_decide`, no repository-local axiom.

What remains open is rank two: `produce` requires `det A = 0`, and the
determinant-`±1` stratum is handled separately in `DirectSmith2x2`. The
general `2×2` reducer — arbitrary determinant, hence a genuine two-step
elimination rather than a single outer product — is still assembled from
strata rather than derived uniformly.
