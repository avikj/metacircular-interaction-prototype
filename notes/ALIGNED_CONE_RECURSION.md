# Aligned measure cones are ordered self-fiber products

For a measure `mu` on `Z/p^kZ`, split by the low digit:

\[
\mu_d(t)=\mu(d+pt),qquad 0\le d<p,quad t\in\mathbb Z/p^{k-1}\mathbb Z.
                                                                    \tag{1}
\]

Write `|nu|` for total mass. Let `A_(p,0)=R_{>=0}`.

## Recursive cone identity

**Theorem.** For every `k>=1`, low-digit splitting is a linear cone
isomorphism

\[
\mathcal A_{p,k}\cong
\left\{(\mu_0,\ldots,\mu_{p-1})\in\mathcal A_{p,k-1}^{,p}:
|\mu_0|\ge|\mu_1|\ge\cdots\ge|\mu_{p-1}|\right\}.            \tag{2}
\]

*Proof.* At the root, child `d` consists exactly of residues `d+pt`; hence its
mass is `|mu_d|`, and root alignment is precisely the ordered-total condition
in (2).

Now take a prefix of length `ell>=1`, written uniquely as `u=d+pv` with low
digit `d` and `0<=v<p^(ell-1)`. Its child of next digit `e` consists of

\[
x=d+p\bigl(v+e p^{\ell-1}+p^\ell q\bigr).                    \tag{3}
\]

After division by `p`, these are exactly the `e`th children of prefix `v` in
the quotient measure `mu_d`. Thus every nonroot alignment inequality for
`mu` is exactly one alignment inequality in one `mu_d`. This proves both
directions. The split and interleaving inverse are linear. ∎

There is no zero-child exception: the zero measure belongs to every child
cone and satisfies all homogeneous inequalities.

## Recursive certificate and formation

Equation (2) gives a proof-carrying membership procedure:

1. split the world by its next low digit;
2. compare the `p` child totals;
3. recurse independently inside each child quotient.

It inspects the same tree inequalities as the flat definition, but its output
is compositional: each child certificate can persist and be reused when that
formed subworld is embedded into a larger parent. A parent formation step
needs only certificates for its children plus the new ordered-total proof.

This is the exact self-developing operation implicit in the preceding
scheduler results. The object certifying present alignment decomposes into
objects of the same type that certify all future conditional subproblems.

## Why mixed rays appear at depth two

For `p=2,k=1`, the child cone consists of pairs `(r,s)` with `r>=s>=0`; its
two extreme shapes are

\[
e=(1,0),\qquad u=(1,1).                                      \tag{4}
\]

At depth two, a parent is an ordered pair `(alpha,beta)` of such child laws
with `|alpha|>=|beta|`. The mixed ray `(1,2,1,0)` has low-digit children

\[
\alpha=(1,1)=u,qquad \beta=(2,0)=2e,                         \tag{5}
\]

whose totals are equal. The other mixed ray `(2,1,0,1)` has

\[
\alpha=(2,0)=2e,qquad \beta=(1,1)=u.                         \tag{6}

Again the totals are equal. Thus the new indecomposables are equality
couplings of nonproportional child extreme shapes. The ordered fiber product
explains their source, but does not by itself prove a general ray
classification: at larger depth, child faces and several simultaneous total
equalities may interact.

## Rigor boundary

The recursive identity and membership certificate are exact for all `p,k`.
Only the interpretation (5)--(6) concerns the already classified binary
depth-two rays. No formula for higher-depth extreme rays, minimal certificate
size, or closure under arbitrary parent assembly is claimed: ordered child
totals remain load-bearing.

