# Minimal translation centers for exact residue reconstruction

Let `R=Z/p^kZ`, `k>=1`, and let

\[
\tau_k(x)=\min(v_p(x),k),\qquad \tau_k(0)=k.
\]

For a chosen set of translation centers `C subset R`, observe

\[
\Phi_C(r)=(\tau_k(r+c))_{c\in C}.
\]

Full translation closure uses `p^k` centers. The exact minimum needed merely
to reconstruct the residue is smaller, but only by one center per deepest
sibling cluster.

## Exact classification

Partition `R` into its `p^(k-1)` residue classes modulo `p^(k-1)`, each of
size `p`.

**Theorem.** The response map `Phi_C` is injective if and only if every residue
class modulo `p^(k-1)` contains at most one point outside `-C`. Equivalently,
each such class contains at least `p-1` negatives of chosen centers.

Consequently

\[
\min\{|C|:\Phi_C\text{ injective}\}
=(p-1)p^{k-1}=p^k-p^{k-1}.
\]

*Necessity.* Suppose distinct `r,s` in the same class modulo `p^(k-1)` both
have `-r,-s notin C`. For any center `c`, if `c` is outside their negative
sibling class, both `r+c` and `s+c` have the same valuation below `k-1` by
the unequal-depth ultrametric equality. If `c` is inside that sibling class,
then both sums are nonzero multiples of `p^(k-1)` and have valuation `k-1`;
the exclusions `c!=-r,-s` are load-bearing. Thus their response vectors agree,
contradicting injectivity.

*Sufficiency.* Let `r!=s`. If they share a class modulo `p^(k-1)`, at most one
of `-r,-s` is omitted, so one is a center; its coordinate gives responses `k`
and `k-1`.

If they lie in different deepest classes, choose a center `c` in the sibling
class of `-r` but distinct from `-r`; one exists because that class contains
at least `p-1` centers (when `p=2`, it is the unique other sibling). Then
`tau_k(r+c)=k-1`, whereas `v_p(s-r)<k-1` and adding the depth-`k-1`
displacement `r+c` leaves

\[
\tau_k(s+c)=v_p(s-r)<k-1.
\]

So every pair is separated. Counting `p-1` required centers in each of
`p^(k-1)` disjoint classes proves the minimum. ∎

## Meaning

The full action set and the least separating observation set are different
objects. Exact semantic future closure uses all translations because it asks
for every response. Exact state identification can omit one translation in
each deepest ball because the remaining siblings identify the omitted point by
exclusion. No further omission is possible: two absent siblings are p-adically
indistinguishable from every other center.

Under zero-error readout the final state alphabet still has `p^k` classes, so
the predictive quantum-memory dimension remains `p^k`. The theorem reduces the
number of valuation coordinates queried, not the number of states encoded.

## Rigor boundary

The iff classification and minimum are proved above. Enumeration only checks
bounded cases. Centers are nonadaptive and all chosen responses are retained;
adaptive query depth, noisy valuation, construction cost of centers, and
infinite `Z_p` are outside scope.

