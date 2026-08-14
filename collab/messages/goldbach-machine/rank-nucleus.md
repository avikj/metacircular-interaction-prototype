# Goldbach through Delta 27 — the first honest rank/nucleus matrix and its obstruction

**Status:** exact finite Boolean calculation; no Goldbach coverage claim; no core edit.

## Boundary consumed

I read `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` in full before choosing the matrix. The binding distinctions are:

- a subsystem is a continuation transformer;
- an architecture is an exact factorization of that transformer;
- Boolean factor rank is minimum true-rectangle cover size;
- the Boolean Isbell nucleus is the full formal-concept lattice;
- rank, behavioral quotient, nucleus, and proof-relevant witness rank are different;
- the Prime-Pair lane requires actual bounded witnesses, not undocumented heuristic costs.

I also inspected the concurrent formal work read-only:

- `Pairfield.BoundedPrimePair` supplies the finite actual-prime carrier, the common pair witness, `pairCenter`, `pairGap`, bound weakening, and centre/gap fibers. It asserts no center coverage.
- `Pairfield.PrimePairDecomposition` checks actual primes `(7,11)`, the center/gap views, and loss under a forced `+2` waypoint. It explicitly disclaims Goldbach coverage.
- `NaturalMachine.DSOFactorRankFinite` checks the rank-one additive-minor obstruction for one crossed `Bool × Bool` natural-cost matrix. It is not a general factor-rank development.
- `NaturalMachine.DSONucleusFinite` checks one exact saturated rank-one mode with row/column tightness. It is not a general Isbell construction.
- `NaturalMachine.BehavioralHankel` checks a two-state identity cost cut, Dirac separation, and continuation-dependent active modes. It is not an arithmetic Hankel matrix.
- `NaturalMachine.DSORankFinite` was named in Delta 27 as concurrent but was not present in this checkout.

The aggregate Lean file was concurrently dirty, so none of these files was edited, staged, or replayed here.

## 1. The natural proof-relevant past–future table

Fix `X : ℕ`. Use the existing carrier

\[
P_X=\operatorname{BoundedPrime}(X).
\]

Let the declared future set be

\[
F_X=\{N\in\mathbb N:4\le N\le X,\ N\text{ even}\}.
\]

A row is a certified first prime leg `p : P_X`. A column is a future Goldbach obligation `N : F_X`. Define the proof-relevant cell

\[
\mathbf H_X(p,N)
=\sum_{q:P_X}[p+q=N].
\]

Its Boolean truncation and min-plus feasibility matrix are

\[
H_X(p,N)=[\mathbf H_X(p,N)\text{ is inhabited}],
\]

\[
K_X(p,N)=
\begin{cases}
0&\mathbf H_X(p,N)\text{ is inhabited},\\
+\infty&\text{otherwise}.
\end{cases}
\]

There is no heuristic cost. A true cell contains an actual bounded prime `q` and equality `p+q=N`; `(p,q)` therefore maps directly to the existing `PrimeCenterFiber X N`.

Conversely, every point of `PrimeCenterFiber X N` supplies a true cell by taking its first leg as the row and its second leg as the cell witness. Thus

\[
\boxed{
\text{column }N\text{ of }H_X\text{ is nonempty}
\iff
\operatorname{PrimeCenterFiber}(X,N)\text{ is inhabited}.}
\]

Because `N≤X`, any ordinary natural-number representation `N=p+q` already has `p,q≤X`. Therefore the bounded Goldbach obligation is exactly

\[
\boxed{
\operatorname{GB}_X:
\prod_{N:F_X}\left\|\sum_{p:P_X}\mathbf H_X(p,N)\right\|.}
\]

The global strong Goldbach conjecture is the assertion of these column-coverage obligations for every even center, not a rank assertion.

## 2. Smallest non-rank-one actual-witness cut

Under the convention `N≤X`, `X=6` is the smallest bound with two Goldbach futures, `4` and `6`. Restrict rows to the certified primes `2` and `3`. The Boolean matrix is

\[
\begin{array}{c|cc}
H_6&N=4&N=6\\\hline
p=2&1&0\\
p=3&0&1
\end{array}
\]

Every entry has an exact arithmetic reason:

- `(2,4)` is inhabited by `q=2`, giving the actual pair `(2,2)`;
- `(3,6)` is inhabited by `q=3`, giving the actual pair `(3,3)`;
- `(2,6)` would require `q=4`, which is not prime;
- `(3,4)` would require `q=1`, which is not prime.

No one-row or one-column nonempty Boolean matrix can have factor rank greater than one: all its true cells form a rectangle. Hence this `2×2` cut is dimension-minimal for a nontrivial Boolean-rank lower bound.

### Exact fooling-set proof

Take the two true cells

\[
\mathcal F=\{(2,4),(3,6)\}.
\]

An all-true rectangle containing both would also contain the cross cells `(2,6)` and `(3,4)`, both false. Thus no true rectangle contains both chosen cells. `𝓕` is a fooling set of size two, so

\[
\operatorname{rank}_{\mathbb B}(H_6)\ge2.
\]

The two singleton rectangles cover the relation, so

\[
\boxed{\operatorname{rank}_{\mathbb B}(H_6)=2.}
\]

The `0/+∞` min-plus embedding has the same exact support factorization and therefore also needs two feasibility modes.

### Its Boolean nucleus

For this restricted identity relation, the formal concepts are exactly

\[
(\varnothing,\{4,6\}),\quad
(\{2\},\{4\}),\quad
(\{3\},\{6\}),\quad
(\{2,3\},\varnothing).
\]

The canonical nucleus has four concepts; the minimum true-cell cover uses the two singleton concepts. This is a literal finite illustration of Delta 27's distinction between canonical completion and a minimum generator family.

## 3. A three-cell separator already outruns ordinary parity

At `X=12`, restrict rows to `2,3,5` and futures to `4,6,12`. The selected matrix is again an identity:

\[
\begin{array}{c|ccc}
H_{12}&4&6&12\\\hline
2&1&0&0\\
3&0&1&0\\
5&0&0&1
\end{array}
\]

The true cells carry the actual pairs

\[
(2,2),\qquad(3,3),\qquad(5,7).
\]

The off-diagonal complements are respectively `4,10,1,9`, or negative/`1`; none is prime. The three diagonal cells are therefore a size-three fooling set. The selected submatrix has exact Boolean rank three, and the full `H₁₂` has Boolean rank at least three.

This is a genuine separator statement: future center `12` distinguishes the two odd-prime pasts `3` and `5` because

\[
12-3=9\text{ is composite},
\qquad
12-5=7\text{ is prime}.
\]

Consequently the row-parity quotient

\[
\pi:P_{12}\to\mathbb Z/2,
\qquad \pi(p)=p\bmod2,
\]

cannot support `H₁₂`: it identifies `3` and `5`, while continuation `N=12` separates their rows. This is an explicit fiber violation, not an invocation of “the parity problem” by name.

### Exact finite factor-count parity map

There is also a narrowly relevant sieve-parity calibration. For the two complements at future `12`, define

\[
c_{12}(p)=12-p,
\]

the smallest-prime visibility

\[
\sigma_2(q)=[2\mid q],
\]

and factor-count charge

\[
\chi(q)=\Omega(q)\bmod2.
\]

Then

\[
\sigma_2(c_{12}(3))=\sigma_2(9)=0
=\sigma_2(7)=\sigma_2(c_{12}(5)),
\]

while

\[
\chi(9)=0\quad(\Omega(9)=2),
\qquad
\chi(7)=1\quad(\Omega(7)=1).
\]

Thus the explicit map `χ∘c₁₂` supplies the distinction missing from `σ₂∘c₁₂` on this two-point carrier, and the saturated true rectangle `{5}×{12}` becomes available on the two-row, one-future restriction. This is the only warranted sense in which parity supplies a missing finite nucleus generator here.

It is **not** a theorem about the classical sieve parity barrier. Odd `Ω` does not imply primality (for example `8` has `Ω(8)=3`), and a `z=2` visibility map is not a full sieve state. A genuine parity-barrier theorem would require an explicit sieve-observation carrier, a charge map on its fibers, and separating continuations uniformly in scale. None is claimed.

## 4. Exact obstruction: rank is blind to a Goldbach-failing future

The natural matrix expresses Goldbach honestly, but factor rank alone cannot prove its required column coverage.

**Zero-future invariance theorem.** Let `R⊆A×C` be any Boolean relation and adjoin a new future `z` with

\[
R'(a,z)=\mathsf{false}\qquad\forall a:A,
\]

while retaining `R` on the old columns. Then

\[
\boxed{\operatorname{rank}_{\mathbb B}(R')
=\operatorname{rank}_{\mathbb B}(R).}
\]

**Proof.** Any true rectangle of `R'` with nonempty row side cannot contain `z`; an empty-row rectangle covers nothing and can be discarded. Restricting any cover of `R'` therefore gives a cover of `R` of no greater size. Conversely, every true-rectangle cover of `R` is already a cover of `R'`, since the new column has no true cells to cover. The two inequalities give equality. QED.

But if `R` had every future column inhabited, `R'` does not: `z` is empty. Therefore Boolean rank is invariant under exactly the defect that bounded Goldbach forbids.

The nucleus can retain the empty future in an empty-extent concept, so the full canonical concept lattice contains more semantic information than its minimum true-cell cover. Even then, Goldbach is the separate assertion that no declared future has empty extent. Neither a rank lower bound nor a list of generators implies that assertion.

There is a second scaling obstruction. A fooling-set certificate touching a center `N` must begin with a true cell `(p,N)`, which already contains an actual Goldbach witness `(p,N-p)`. To build a fooling set meeting every center up to `X`, one must first supply a witness for every such center, and then additionally prove the cross cells false. The rank certificate reorganizes bounded witnesses; it does not generate missing coverage.

Hence the finite rank calculations are useful only for an architecture question:

\[
\boxed{
\text{how many exact witness modes are required after coverage is known?}}
\]

They do not answer the number-theoretic question:

\[
\boxed{
\text{is every declared even-center future covered?}}
\]

## 5. Delta 27 verdict

- **Carrier:** existing `BoundedPrime X` first legs, even center futures, and proof-relevant complement-prime cells.
- **Past/future map:** partial witness `p` is evaluated by continuation `N` through `q=N-p`; a true result installs `(p,q)` in `PrimeCenterFiber X N`.
- **Rank:** the smallest actual-witness cut has exact Boolean/min-plus feasibility rank two; an actual `X=12` subcut has a size-three fooling set.
- **Nucleus:** the `2×2` identity cut has four formal concepts and two covering generators. The `X=12` separator proves that ordinary row parity is not an exact interface.
- **Parity:** only the explicit maps `π`, `c₁₂`, `σ₂`, and `Ω mod 2` are used. They give a two-point missing distinction, not a global parity-barrier result.
- **Goldbach obligation:** nonempty future columns. It is orthogonal to Boolean-rank lower bounds; appending an empty future preserves rank.
- **Merge decision:** no core edit. The bounded carrier and generic rank/nucleus/Hankel seams are concurrent work; the only new result is an arithmetic instance plus a no-scale theorem, and adding a parallel tiny formal module would duplicate or collide with that work rather than advance coverage.

## Verification/provenance

All prime/nonprime facts used are elementary exact facts: `2,3,5,7` are prime; `1` is not prime; `4=2·2`, `9=3·3`, and `10=2·5`. No numerical census, heuristic cost, Python execution, or unbounded inference was used. The rank and nucleus arguments are handwritten exact finite proofs in this report; they were not kernel-replayed here. The concurrent Agda/Lean files were read only.

## Post-commit concurrent update consumed

After the first shared-stream commit, two relevant untracked files appeared and were read in full without editing:

- `Pairfield/GoldbachBoundary.lean` now encodes the exact equivalence between `PrimeCenterFiber N N` inhabitation, the classical existential prime-pair statement, and positivity of the finite ordered representation count. It also states `StrongGoldbach` and `GoldbachUpTo` while proving no positivity estimate. This kernel-level boundary subsumes this report's carrier/column-coverage equivalence and further confirms that no parallel core file is warranted. Its concurrent owner had not yet integrated it into the aggregate when inspected.
- `collab/messages/goldbach-machine/analytic-uniformity.md` isolates a uniform signed binary minor-arc lower bound, conditional on the pinned major-arc asymptotic, as an analytic hypothesis sufficient for eventual Goldbach. That is orthogonal to the present result: it targets column positivity, while Boolean rank only measures covers of cells already true. The zero-future invariance theorem here explains categorically why rank alone cannot replace such a positivity input.
