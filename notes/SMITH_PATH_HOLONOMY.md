# Smith endpoint confluence leaves path holonomy

**Status.** Exact finite theorem and replay for the adjacent diagonal Smith
calculus. This is a consumer of the target-stabilizer torsor in
`INVARIANT_SCHEMA_COUPLING.md`, not a novelty claim about Smith normal form.

## 1. Local path cells

For positive adjacent diagonal entries `a,b`, put

\[
g=\gcd(a,b),\qquad A=a/g,\qquad B=b/g.
\]

Choose `x,y` with `xA+yB=1`. Then

\[
U=\begin{pmatrix}x&y\\-B&A\end{pmatrix},\qquad
V=\begin{pmatrix}1&-yB\\1&xA\end{pmatrix}
\tag{1}
\]

have determinant one and direct multiplication gives

\[
U\,\operatorname{diag}(a,b)\,V
=\operatorname{diag}(g,ab/g).
\tag{2}
\]

Embedding (1) at any adjacent position makes the rewrite
`(a,b) -> (gcd(a,b),lcm(a,b))` a unimodular path, not merely an endpoint
update. Composing cells accumulates left and right transports.

## 2. Two schedules, one endpoint

Start at

\[
A_0=\operatorname{diag}(2,3,2).
\]

Two legal schedules are

\[
\begin{aligned}
p &: (2,3,2)\to(1,6,2)\to(1,2,6),\\
q &: (2,3,2)\to(2,1,6)\to(1,2,6).
\end{aligned}
\tag{3}
\]

Using the deterministic extended-Euclid convention in the replay gives left
transports

\[
U_p=\begin{pmatrix}-1&1&0\\0&0&1\\3&-2&3\end{pmatrix},\qquad
U_q=\begin{pmatrix}0&1&-1\\-1&2&-2\\0&-2&3\end{pmatrix}.
\]

Both full certificates send `A_0` to
`D=diag(1,2,6)`. Their relative left transport is

\[
H=U_qU_p^{-1}
=\begin{pmatrix}3&-4&1\\4&-5&1\\-6&9&-2\end{pmatrix}.
\tag{4}
\]

It has determinant one. If `V_p,V_q` are the corresponding right transports,
then

\[
HD=D(V_q^{-1}V_p),
\tag{5}
\]

so `H` preserves the relation lattice `D Z^3` and acts on

\[
F=\operatorname{coker}(D)\cong \mathbb Z/2\oplus\mathbb Z/6.
\]

The action is nontrivial:

\[
[0,0,1]\longmapsto[0,1,4].
\tag{6}
\]

Thus endpoint confluence proves schedule independence of the invariant-factor
task, but does not prove schedule independence of transported cokernel data.

## 3. The descent theorem

Let `P(A,D)` be any family of certified paths from `A` to the common endpoint
`D`. Fix one path `p_0`. Every `p` determines an integral target holonomy

\[
H_p=U_pU_{p_0}^{-1}.
\]

The relation `H_pD=DK_p` makes this matrix *induce* an automorphism of
`coker(D)`; it is not literally an element of that automorphism group until
this passage is made. Let `G` be the subgroup of induced automorphisms. A task
`t : coker(D) -> Y` can be evaluated after erasing the chosen path exactly
when

\[
t(gz)=t(z)\quad\text{for every }g\in G,\ z\in\operatorname{coker}(D).
\tag{7}
\]

This is just the universal property of the orbit set: (7) is necessary
because two erased path presentations must give the same answer, and
sufficient because `t` is then constant on every `G`-orbit and factors
uniquely through the set of orbits `G\coker(D)`.

If `t` is required to be an additive homomorphism, the universal recipient is
instead the coinvariant group

\[
(\operatorname{coker}D)_G
=\operatorname{coker}(D)/\langle gz-z:g\in G,z\in\operatorname{coker}D\rangle.
\]

Automorphism orbits do not generally define a quotient abelian group. This
distinction was supplied by Shilpin's hostile return after the first landing.

For (3), the induced action has order three **— of $\langle H\rangle$ for the
single pair of schedules $p,q$ below, which is a *coordinate*, not the holonomy
group. The rewrite holonomy of $\mathrm{diag}(2,3,2)\rightsquigarrow
\mathrm{diag}(1,2,6)$ over all schedules, all idle cells and all Bézout
witnesses is $G_{\text{rewrite}}=GL_2(\mathbb F_2)\cong S_3$, of order exactly
**6** (SEED-55 §5), an index-2 subgroup of the certificate-torsor holonomy
$\mathrm{Aut}(\mathbb Z/2\oplus\mathbb Z/6)$ of order 12 (SEED-29 §5, SEED-31
Thm 6). The minimal datum that restores the scope is one symbol of
$GL_2(\mathbb F_2)$ per certified path in the declared basis $(e_2,f=3e_3)$,
against a declared reference path — $\le3$ bits (SEED-89 §5.2). Scope sentence
applied here per SEED-55 queue item 3; SEED-106, 2026-08-14. The arithmetic
below is unaffected and the fixed set is correct for the full group of order 6
as well, since a 3-cycle in $S_3$ already fixes only $0$ in $P$ (SEED-55 §6).**
Its fixed elements are exactly

\[
(0,0),\ (0,2),\ (0,4),
\]

while the other nine elements lie in three orbits of length three. If a
"global section" means a cokernel element unchanged after closing the two
schedule charts into a loop, only these three elements descend.

The organismal operation is therefore not "retain every trace" or "erase every
trace." It is task-relative descent: quotient the presentation torsor only by
the holonomies acting trivially on the declared future task, and retain a path
coordinate precisely when a finite witness such as (6) refuses descent.

## 4. Prasaṅga and scope

**Conditioning.** Confluence made the endpoint appear to contain the complete
result because the immediate consumer requested invariant factors only.

**Opposite witness.** Equation (6) shows the same endpoint does not determine
transported cokernel coordinates.

**Reconstruction.** Neither endpoint nor full history is intrinsically the
right state. The coarsest sufficient state depends on the action of path
holonomy on the admitted task family.

The theorem concerns this finite diagonal rewrite system. It does not assert
that every Smith implementation contains these schedules, that the displayed
example is minimal, or that arithmetic holonomy is physical spacetime.

## 5. Replay

```bash
python3 machinery/smith_path_holonomy.py
python3 -m unittest machinery/test_smith_path_holonomy.py -v
```

The replay checks (1)--(6), enumerates all twelve cokernel elements, verifies
the fixed set and order-three action **(of $\langle H\rangle$ only — its
assertions are true but strictly weaker than the $G_{\text{rewrite}}$-invariance
their prose suggests; SEED-55 §6, applied SEED-106)**, and includes a false-control matrix that
does not preserve the relation lattice.
