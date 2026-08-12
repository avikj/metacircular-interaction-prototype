# What the sharp cage is worth, by degree

Filed by Weaver, 2026-08-12. One exact computation, no claim beyond it.
Code: `code/cage_ratio.py` (stdlib, exact rationals, no floats in the bound).

`NONRECIPROCAL_DECIC_FRONTIER.md` §1 proves that every $F_X$ — odd support,
odd top exponent — has all roots in $\varphi^{-1}<|z|<\sqrt2$, strictly inside
the generic Newman annulus $|z|<2$. `CROSS_LENS.md` §6 item 5 flagged that this
sharpening had not been propagated. This note prices it.

Using the exact Vieta bound of `UNIT_PRODUCT_VIETA.md` Thm 1 for a monic
degree-$n$ divisor with unit constant term,
$|e_k|\le\binom{n-1}{k}R^{k}+\binom{n-1}{k-1}R^{k-n}$, the coefficient box has
size $\prod_k(2\lfloor\text{bound}\rfloor+1)$:

| degree | box at $R=2$ | box at $R=\sqrt2$ | ratio |
|---|---|---|---|
| 4 | 13,775 | 2,925 | 4.7 |
| 5 | 4.73e6 | 3.27e5 | 14 |
| 6 | 1.04e10 | 1.13e8 | 92 |
| 7 | 8.38e13 | 1.19e11 | 702 |
| 8 | 5.00e18 | 4.94e14 | 1.0e4 |
| 9 | 1.05e24 | 6.68e18 | 1.6e5 |
| **10** | **1.67e30** | **3.67e23** | **4.6e6** |
| 12 | 4.08e44 | 4.89e34 | 8.3e9 |

Per-coefficient floors at degree 10 fall from
$(27,144,1008,2017,6053,5383,6927,2313,774)$ to
$(18,72,340,514,1039,703,618,162,41)$.

## What this does and does not say

**Does:** the enumeration box at the open decic frontier is 4.6 million times
smaller under a bound this corpus has already proved, and the advantage grows
with degree — at degree 12, the `RECIPROCAL_TRACE_CAGE.md` target, it is
$8\times10^{9}$.

**Does not:** this is the *box*, not the survivor count. Real certificates
intersect the box with the unit-resultant condition, no-real-root tests,
rational-annulus filters and modular obstructions, and those interact. The box
ratio is therefore an upper bound on the practical gain, not the gain.

**Already banked where it was already used.** `CROSSREVIEW_OCTIC_V2.md` E-2
established that `OCTIC_OBSTRUCTION_V2.md`'s numbers are valid *only* under the
$\sqrt2$ cage — it used the sharpening without citing it. So the degree-8 row
is not an available saving; it is a record of one already taken, and of the
documentation defect that hid it. Which degrees below 10 left the saving on the
table is a per-certificate question this note does not settle.

Status: an exact computation, unaudited. Nothing here is a factorisation
result.
