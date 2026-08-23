# COORDINATION THEOREMS XXIX — CONSERVATION, DUALITY, AND FLOW ON NETWORKS
Date: 2026-08-13
Status: exact finite network-flow/linear-algebra lemmas; no novelty claims.

Let G=(V,E) be a finite directed graph with signed incidence matrix B∈R^{V×E}. A flow is f∈R^E; node divergence is Bf∈R^V.

## 801. Total divergence is zero
For every flow f,
\[
\mathbf 1^\top Bf=0.
\]

Proof. Every incidence column has one +1 and one -1, so 1^T B=0. QED.

## 802. Feasible source-sink demand must have zero total
The equation
\[
Bf=b
\]
can have a solution only if
\[
\mathbf 1^\top b=0.
\]

Proof. Apply 1^T to both sides and use Theorem 801. QED.

## 803. On a connected graph zero-sum demand is sufficient without capacity constraints
If G is connected, for every b with 1^Tb=0 there exists f with
\[
Bf=b.
\]

Proof. By Theorem 711, im B is exactly the zero-sum subspace. QED.

## 804. Flow solutions differ by cycle flows
If f,f' both satisfy
\[
Bf=Bf'=b,
\]
then
\[
f-f'\in\ker B.
\]

Proof. \(B(f-f')=0\). QED.

Thus source/sink behavior determines flow only modulo circulation.

## 805. Tree flow is unique for a fixed demand
If G is a tree and Bf=b is feasible, then f is unique.

Proof. A tree has \(\ker B=\{0\}\) by \(|E|=|V|-1\) and rank(B)=|V|-1. Apply Theorem 804. QED.

## 806. Cycles create routing freedom
For connected G,
\[
\dim\{f:Bf=b\}=|E|-|V|+1
\]
for every feasible b.

Proof. Any solution set is affine translate of ker B; dimension is cycle-space dimension. QED.

## 807. Minimum-energy flow
Given positive diagonal resistance matrix R, minimize
\[
\frac12 f^\top Rf
\]
subject to
\[
Bf=b.
\]
Any minimizer satisfies
\[
Rf=B^\top\lambda
\]
for some node potential λ.

Proof. Lagrangian
\[
L(f,\lambda)=\frac12f^\top Rf-\lambda^\top(Bf-b).
\]
Stationarity in f gives \(Rf-B^\top\lambda=0\). QED.

## 808. Weighted Laplacian equation for optimal potentials
Under Theorem 807,
\[
BR^{-1}B^\top\lambda=b.
\]

Proof. Substitute \(f=R^{-1}B^\top\lambda\) into Bf=b. QED.

## 809. Optimal flow is orthogonal to cycle perturbations in the R-inner product
If c∈ker B, then for minimum-energy flow f*,
\[
c^\top Rf^*=0.
\]

Proof. By Theorem 807, \(Rf^*=B^\top\lambda\), so
\[
c^\top Rf^*=c^\top B^\top\lambda=(Bc)^\top\lambda=0.
\]
QED.

## 810. Energy decomposes around the optimum
For any feasible f=f*+c with c∈ker B,
\[
f^\top Rf
=
f^{*\top}Rf^*+c^\top Rc.
\]

Proof. Expand quadratic and use Theorem 809 to kill cross term. QED.

## 811. Minimum-energy routing is unique
If R is positive definite, the feasible minimum-energy flow is unique.

Proof. If two minima differ by nonzero c∈ker B, Theorem 810 adds strictly positive \(c^\top Rc\), contradiction. QED.

## 812. Effective boundary behavior quotients internal circulation
Two flows with same divergence b have identical external source/sink behavior while differing only by cycle circulation.

Proof. Theorem 804. QED.

## 813. Circulation is internal implementation freedom
For fixed boundary demand b, admissible unconstrained flow implementations form affine fiber
\[
f_0+\ker B.
\]

Proof. General solution of linear equation Bf=b. QED.

## 814. Adding capacities intersects the affine fiber with a box/polytope
If edge capacities impose
\[
\ell_e\le f_e\le u_e,
\]
the feasible routing set is
\[
(f_0+\ker B)\cap[\ell,u].
\]

Proof. Combine equality solution set with coordinate inequalities. QED.

## 815. Max-flow cut upper bound
For source s, sink t, capacities c_e≥0, any feasible s-t flow of value F satisfies
\[
F\le \sum_{e\in\delta^+(S)}c_e
\]
for every cut S containing s but not t.

Proof. Net flow leaving S equals F by conservation at internal nodes. It is at most total capacity of forward cut edges after accounting that backward flow can only reduce net outward flow. QED.

## 816. Bottleneck cut is a global obstruction to throughput
If some s-t cut has capacity C, no routing algorithm can deliver flow value exceeding C.

Proof. Theorem 815. QED.

This is independent of computational power.

## 817. Edge-disjoint paths give integer unit flow
If there are k edge-disjoint directed s-t paths, sending one unit along each produces an integral s-t flow of value k under unit capacities.

Proof. Edge-disjointness ensures no edge exceeds capacity 1; internal path contributions conserve. QED.

## 818. Routing paths compose
If f carries demand a→b and g carries equal demand b→c on disjoint temporal stages, concatenating them realizes a→c transfer while intermediate b inventory cancels.

Proof. Divergence vectors add:
\[
(\delta_b-\delta_a)+(\delta_c-\delta_b)=\delta_c-\delta_a.
\]
QED.

## 819. Intermediate conservation cancels under composition
More generally, if
\[
Bf=b-a,\qquad Bg=c-b,
\]
then
\[
B(f+g)=c-a.
\]

Proof. Linearity:
\[
B(f+g)=(b-a)+(c-b)=c-a.
\]
QED.

## 820. Boundary-only observer cannot identify internal routing on cyclic graphs
If ker B≠0 and capacities admit both f and f+c for nonzero c∈ker B, then observing only b=Bf cannot distinguish the two routings.

Proof. B(f+c)=Bf. QED.

## 821. Public conservation semantics can coexist with private routing
A protocol that proves only Bf=b need not reveal which element of the feasible affine/capacity fiber was used.

Proof. Relation Bf=b constrains only divergence; multiple internal f may satisfy it. A zero-knowledge proof could in principle certify membership without revealing f, but the set-theoretic statement requires no cryptographic assumption. QED.

## 822. Cycle basis is a coordinate system for routing freedom
Choose basis \(c_1,\dots,c_\beta\) of ker B. Every flow with divergence b can be written uniquely as
\[
f=f_0+\sum_{j=1}^\beta \alpha_jc_j.
\]

Proof. Affine fiber plus basis expansion in ker B. QED.

## 823. Routing-freedom dimension is topological
For connected G,
\[
\beta=|E|-|V|+1.
\]

Proof. Cycle-space dimension theorem. QED.

## 824. Contract refinement by revealing internal edge flows collapses routing freedom
If boundary semantics Bf=b is refined by additionally fixing k independent linear functionals on the cycle-space coordinates, fiber dimension decreases by k until zero.

Proof. Each independent linear equation cuts affine dimension by one. QED.

## 825. Minimum disclosure to reconstruct routing equals cycle-space dimension in the uniform finite-field analogue
Over finite field F_q, for connected graph and fixed divergence b, flow fiber has \(q^\beta\) elements. Uniform hidden flow therefore has residual entropy β q-ary units; exact reconstruction needs β independent q-ary units.

Proof. Fiber is affine copy of ker B of dimension β. Apply linear reconstruction theorems. QED.

## 826. Boundary conservation and internal circulation mirror quotient/provenance separation
The quotient map
\[
f\mapsto Bf
\]
forgets cycle circulation. Retaining both \(Bf\) and cycle coordinates reconstructs f.

Proof. Decomposition of flow space into a chosen complement of ker B plus ker B. QED.

## 827. Divergence is the canonical linear boundary semantics for flow conservation tasks
For the task family of all linear queries depending only on net node injections, two flows are task-equivalent iff they have equal Bf.

Proof. Such tasks factor through Bf by definition; if Bf differs, some linear functional on node injections separates them. QED.

## 828. Internal circulation is invisible to every boundary injection query
If c∈ker B, then for every linear \(\ell\) on node injections,
\[
\ell(B(f+c))=\ell(Bf).
\]

Proof. Bc=0. QED.

## 829. Conserved global charge is a left-kernel invariant
For general transition/incidence matrix C, any row vector w with
\[
w^\top C=0
\]
defines conserved quantity \(w^\top x\).

Proof. State update \(x'=x+Cy\) gives
\[
w^\top x'=w^\top x+w^\top Cy=w^\top x.
\]
QED.

## 830. All linear conserved quantities form the left nullspace
A linear functional w^T x is conserved for every possible transition combination Cy iff
\[
w^\top C=0.
\]

Proof. Sufficiency is Theorem 829. Necessity: if conserved for every single transition column c_j, then w^Tc_j=0 for every j, hence w^TC=0. QED.

## 831. Number of independent linear conservation laws
For state dimension n and transition matrix C of rank r,
\[
\dim\ker C^\top=n-r.
\]

Proof. Rank-nullity for C^T. QED.

## 832. Number of independent transition-cycle freedoms
For m transitions,
\[
\dim\ker C=m-r.
\]

Proof. Rank-nullity. QED.

## 833. Conservation laws and cycle freedoms are dual rank defects
For C∈R^{n×m} rank r:
\[
\#\text{state conservation dimensions}=n-r,
\]
\[
\#\text{transition-neutral dimensions}=m-r.
\]

Proof. Theorems 831–832. QED.

## 834. Full-rank dynamics eliminate one side of freedom
If rank C=n≤m, there are no nontrivial linear conserved state quantities. If rank C=m≤n, there are no nontrivial transition combinations with net zero state change.

Proof. Corresponding nullity equals zero. QED.

## 835. Conservation and implementation freedom can coexist
If r<min(n,m), both left and right nullspaces are nontrivial.

Proof. Then n-r>0 and m-r>0. QED.

This gives an exact linear model in which global invariants and internal cyclic freedom coexist simultaneously.
