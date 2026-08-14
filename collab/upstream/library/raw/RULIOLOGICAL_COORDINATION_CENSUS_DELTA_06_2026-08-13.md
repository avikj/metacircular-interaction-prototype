# Ruliological Coordination Census — Delta 06
## Exhaustive Small Universes and the First Exceptional Rule

Date: 2026-08-13
Status: EXACT COMPUTATIONAL CENSUS + proved classification for enumerated sizes
Depends on Deltas 01–05.

## 0. Experiment

Enumerate every total relation R⊆A×B for:
    (|A|,|B|) ∈ {(2,2),(2,3),(3,2),(3,3)}.

Quotient exactly by independent permutations of A and B (row/column relabeling).
For every isomorphism class compute:
- witness hypergraph;
- κ0, integral witness-cover number;
- τ*, fractional witness-cover number by LP;
- log integrality gap;
- nerve face count.

The enumeration is exhaustive at these sizes.

## 1. Census

(|A|,|B|)   isomorphism classes   classes with κ0>τ*
(2,2)        4                     0
(2,3)        9                     0
(3,2)        6                     0
(3,3)        23                    1

There is exactly ONE isomorphism class among all total 3×3 relations with a nonzero integral/fractional coordination gap.

Its row masks are
    (011,101,110),
i.e.
    R(1)={a,b}
    R(2)={a,c}
    R(3)={b,c}.

This is exactly the triangle relation independently selected in Delta 02.

For it:
    κ0=2,
    τ*=3/2,
    C0=log 2,
    C∞=log(3/2),
    one-shot log gap=log(4/3).

The nerve contains all three vertices and all three edges but not the 2-simplex: it is the boundary of a triangle.

## 2. The first exceptional rule is topological-looking for a precise combinatorial reason

The nerve is
    N_R = ∂Δ² ≃ S¹.

Every pair of input states has a common valid witness, but all three do not.

Thus:
- local pair compatibility is complete;
- global triple compatibility fails;
- fractional coordination assigns weight 1/2 to each of the three witnesses;
- integral coordination must choose at least two.

This is the smallest possible "local compatibility without global witness" cycle.

Do NOT infer that nontrivial H1 generally equals an integrality gap. The census only establishes that the first gap example has this topology.

## 3. Minimality theorem

THEOREM 1.
No total relation with |A|≤2 or |B|≤2 can exhibit the triangle-type 3-cycle fractional cover gap found above.

For |A|≤2 this follows from the exhaustive classification and can also be proved directly: if no universal witness exists, covering two inputs needs two witnesses, and the fractional LP cannot have objective <2 unless some witness covers both.

For |B|≤2, if neither witness is universal and both are needed, there exist inputs seen only by opposite witnesses, forcing each fractional weight ≥1, so τ*=κ0=2.

Hence at least three inputs and three witnesses are necessary for κ0>τ*.

Together with the 3×3 triangle construction:
    (3,3) is the minimal dimension supporting a nonzero coordination integrality gap.

## 4. Uniqueness theorem at minimal dimension

THEOREM 2.
Up to input/output relabeling, the triangle relation is the unique total 3×3 relation with κ0>τ*.

Evidence: exhaustive enumeration of all 7^3=343 total row-labelled relations, canonicalized under S3×S3, yielding 23 isomorphism classes, exactly one with positive gap.

This is an exact finite computational classification. A short human structural proof should now be produced.

## 5. Structural proof sketch for uniqueness

Suppose a 3-vertex witness hypergraph H has τ(H)>τ*(H).

If H has a 3-edge (universal witness), τ=τ*=1.
If τ≥2.

For τ*=<2 to be strict against integral τ=2, fractional sharing must cover all three vertices with total weight <2.

Singleton witness edges cannot help create a fractional advantage: replacing mass on a singleton cannot jointly satisfy another vertex.
With three vertices, the only useful non-universal maximal edges are the three 2-subsets.

To make every vertex fractionally covered below total weight 2 without a universal edge, all three pair edges must be present; if one pair edge is absent, the vertex opposite the remaining pair structure forces an integral/fractional weight pattern totaling at least 2.

With all three pair edges, weights 1/2 each give τ*=3/2 while τ=2.

Additional duplicate/subset witness columns do not change the distinct maximal hypergraph; with exactly three output labels, this is the triangle relation up to relabeling.

This can be polished into a complete non-computational proof.

## 6. First ruliological law

At the smallest sizes, almost every coordination universe has no distinction between one-shot integral and asymptotic/fractional complexity.

The first exception occurs at the first cyclic compatibility structure:
    three states,
    three pairwise witnesses,
    no global witness.

This suggests studying gap onset through minimal non-Helly subcomplexes.

## 7. Helly obstruction direction

For a relation R, N_R is the complex of jointly witnessable state sets.

If N_R is a simplex, κ0=τ*=1.
The triangle example is a minimal non-face whose every proper subset is a face.

Call M⊆A a minimal obstruction if:
    M∉N_R
but every proper subset of M lies in N_R.

For the triangle, |M|=3.

TARGET:
Relate sizes/overlap patterns of minimal obstructions to:
- integrality gap;
- Helly number;
- fractional cover;
- join closure of Suff(R).

Important: a minimal obstruction alone does not imply an integrality gap. Need covering geometry.

## 8. General odd-cycle family

The triangle suggests graph edge-cover examples.

Let A be vertices of an odd cycle C_{2k+1}, and witnesses be its edges, valid for their two endpoints.

Then κ0 is the minimum edge cover:
    κ0=k+1.
Fractional cover assigns 1/2 to every edge:
    τ*=(2k+1)/2=k+1/2.

So gap ratio:
    κ0/τ* = (k+1)/(k+1/2)
which tends to 1.

Triangle k=1 maximizes this ratio within odd cycles:
    2/(3/2)=4/3.

This supplies an infinite family of cyclic coordination gaps.

## 9. Complete graph family

Let inputs be vertices of K_n and witnesses all 2-element edges.

Integral edge cover:
    κ0=ceil(n/2).
Fractional edge cover:
    τ*=n/2.

For odd n:
    ratio=(n+1)/n.
Again the triangle n=3 gives 4/3.

Thus pairwise-witness systems have modest gap. Larger hyperedges can support larger set-cover integrality gaps, potentially Θ(log |A|).

The ruliological question becomes: how rapidly do large gaps appear as relation size grows, and what structural motifs generate them?

## 10. Complexity landscape to enumerate next

For each isomorphism class compute:
- automorphism group size;
- Helly number of N_R;
- minimal nonfaces;
- κ0/τ*;
- join closure of Suff(R);
- homology/Betti numbers of N_R;
- number of sufficient partitions;
- tensor-square κ2;
- postprocessing orbit statistics.

Then search empirically for correlations and counterexamples:
A. nontrivial homology ↔ gap?
B. Helly number ↔ maximum gap?
C. join closure ↔ nerve structural class?
D. symmetry ↔ compressibility?
E. large automorphism group ↔ low/high C∞?
F. tensor compression onset ↔ fractional gap exactly? (asymptotically yes; finite n needs study.)

## 11. Prime-Pair experiment design sharpened

The triangle says what to look for in finite sieve observability:
not vague topology, but a family of local arithmetic states such that every small compatible subfamily admits a common charge/witness while a larger family does not.

Construct the finite sieve nerve:
vertices = arithmetic states indistinguishable under selected observables;
simplex = collection admitting one common valid reconstruction/charge assignment.

Then compute minimal nonfaces and fractional covers.

If parity manifests as a growing family of minimal nonfaces under scale refinement, that is concrete data.
If the nerve is contractible/simple despite parity difficulty, this particular topological route is falsified.

## 12. Machine-generated conjecture

CONJECTURE A (join closure versus union closure).
Suff(R) is join-closed iff N_R is closed under unions of intersecting simplices connected through a chain of overlaps induced by sufficient blocks.

This needs a cleaner intrinsic formulation. Theorem 5 of Delta 01 already gives the exact partition-level criterion. Search for a nerve property equivalent to it.

CONJECTURE B (minimal join failure).
Every minimal join failure π,σ determines a minimal nonface M of N_R contained in one join block and covered by simplices drawn from π and σ.

This appears immediate after minimalization and should be proved.

## 13. Methodological result

The ruliological method paid off immediately:
- Delta 02 guessed a triangle counterexample.
- Exhaustive universe enumeration shows it is not arbitrary.
- It is the unique minimal exceptional rule.

This is exactly the desired loop:
    mathematical definition
    → enumerate universe
    → discover exceptional morphology
    → formulate classification theorem
    → prove
    → feed theorem back into next enumeration.

Next census: all total 3×4 and 4×3 relations up to isomorphism, then selected 4×4 classes using bipartite-graph canonicalization rather than factorial brute force.
