# Equal-depth cancellation requests its least finer residue sensor

Fix a prime `p`. Multiplicative exponent coordinates make multiplication
coordinatewise, but addition is not a function of the two valuations. The
missing information has an exact finite form for every nonzero sum.

## Minimal-precision theorem

Let `a,b` be integers and put `s=a+b != 0` and `v=v_p(s)`. Among the
prime-power residue charts

\[
(a \bmod p^k,b \bmod p^k),\qquad k=1,2,\ldots,
\]

the least depth that determines the exact value `v_p(a+b)` is

\[
\boxed{k=v+1.}                                                \tag{1}
\]

Here “determines” means that every integer pair in the **ambient domain** with
the same two residues has the same valuation of its sum. This quantifier is
load-bearing. After restricting to a formed subset, the same depth remains
sufficient but need not remain minimal; `FORMATION_SUFFICIENCY` gives the exact
witness criterion and proves that no finite formed subset preserves ambient
minimality everywhere.

**Proof.** At depth `v+1`, the sum residue is divisible by `p^v` and nonzero
modulo `p^(v+1)`. Every pair in the same residue fiber therefore has sum
congruent to `p^v u` modulo `p^(v+1)`, with `u` a unit, and hence has sum
valuation exactly `v`.

No depth `k<=v` suffices. The observed sum is zero modulo `p^k`. If `k<v`,
replace `b` by `b+p^k`; the input residues at depth `k` are unchanged while
the new sum has valuation exactly `k`, not `v`. If `k=v`, write `s=p^v u`
with `u` a unit and choose `c` in `{1,...,p-1}` with `c=-u (mod p)`.
Replacing `b` by `b+c p^v` preserves its residue modulo `p^v`, while the new
sum has valuation at least `v+1`. Thus every coarser chart has a same-
observation counterexample. These alternatives remain positive when the
original inputs are positive. `square`

The argument includes the unequal-input-depth case: if
`v_p(a) != v_p(b)`, the ultrametric equality fixes `v` immediately, and the
residue hierarchy first witnesses this at depth `v+1`. Equal input depths are
where unit cancellation can make the requested depth unexpectedly large.

## Adaptive operation

Query the residue pair at depths `1,2,...` and stop at the first nonzero sum
residue. If it stops at `k`, return `k-1` together with:

- the nonzero residue modulo `p^k`, certifying exactness;
- the zero sum residues at every smaller depth, certifying minimality.

Thus the obstruction in a coarse chart selects the next sensor: a zero sum
does not trigger a guessed value, but a strictly finer prime-power view. The
operation reads only `v_p(a+b)+1` base-`p` digits of each input, rather than
requiring their full reconstruction.

## Sharp zero boundary

If `a+b=0`, no finite residue depth can certify infinite valuation: for every
`k`, the pair `(a,-a+p^k)` has the same depth-`k` residues and a finite sum of
valuation `k`. Termination therefore requires either the external exact
equality certificate `a=-b` or an explicit nonzero promise. This is not an
implementation defect; it is the separation between the `p`-adic limit point
zero and every finite quotient.

## Rigor boundary

The theorem and zero obstruction are proved above and are standard local
arithmetic; no novelty is claimed. `machinery/adaptive_valuation_addition.py`
replays the finite operation and its certificates. The implementation receives
ordinary integers so it can discharge the zero boundary by exact equality;
the refinement trace itself uses only residue queries. No claim is made about
optimal bit complexity or about simultaneous refinement across all primes.

The zero residues in a returned trace certify insufficiency of coarser charts
against the ambient integer fiber. They are not, without an additional
formation-set witness, certificates that a coarser chart is insufficient among
only the states a particular process has already formed.
