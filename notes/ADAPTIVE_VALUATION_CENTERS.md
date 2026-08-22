# Adaptive valuation instruments reconstruct residues digit by digit

> **FOUR PROOFS OF ONE THEOREM. You are reading number 1.** `D(p,k) = k(p−1)`
> — the least worst-case adaptive valuation-query count to identify
> `r ∈ ℤ/p^kℤ` — is derived independently in four files, three of which
> announce it as new and none of which cites another:
>
> 1. `notes/ADAPTIVE_VALUATION_CENTERS.md` (`045ea1b1`, 2026-08-12 03:35) — upper bound only, optimality explicitly refused.
> 2. `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` (`96b3dc24`, 2026-08-12 03:37) — both bounds.
> 3. `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md` (`4017f526`, 2026-08-12 03:45) — both bounds, identical to 2 up to the sign of the center.
> 4. `notes/SEED30_LOWER_BOUND_AUDIT.md` §3.3, Theorem W (`219c358e`, 2026-08-14) — lower bound a third time; its claim to close an open item is struck.
>
> `notes/CARR_LEDGER.md` §C6 is a fifth derivation, a declared cold replay, not
> a rival. The canonical statement, with the query model made explicit, is
> **`notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md`**.
> Cross-reference added 2026-08-22; nothing in the body below is altered.

## 1. Fixed centers versus feedback

In `R=Z/p^kZ`, a valuation-center query chooses `c in R` and receives

\[
\tau_k(r+c)=\min(v_p(r+c),k).                                     \tag{1}
\]

`VALUATION_RESOLVING_CENTERS` proves that a fixed nonadaptive center set whose
whole response vector identifies every `r` needs exactly

\[
N_{\rm fixed}=(p-1)p^{k-1}.                                      \tag{2}
\]

If each next center may depend on earlier responses, the cost changes
exponentially.

## 2. Digit protocol

Suppose the residue prefix `a=r mod p^ell` is known. The next digit is the
unique `d in {0,...,p-1}` such that

\[
r\equiv a+d p^\ell\pmod {p^{\ell+1}}.                             \tag{3}

For `d=0,...,p-2`, query the center

\[
c_d=-(a+d p^\ell)\pmod {p^k}.                                    \tag{4}

The response is at least `ell+1` exactly when (3) holds for that `d`. Stop on
the first such response. If none occurs, the digit is the omitted value
`p-1`. Append the digit and continue.

**Theorem 2.1.** The protocol reconstructs every residue in `Z/p^kZ` exactly
using at most

\[
\boxed{N_{\rm adaptive}\le(p-1)k}                                \tag{5}
\]

queries. The all-`(p-1)` residue attains this protocol's bound.

**Proof.** At level `ell`, divisibility of `r+c_d` by `p^(ell+1)` is
equivalent to equality of the next digit. Exactly one of the `p` digits is
correct; testing `p-1` and assigning the omitted digit on all negative answers
therefore determines it. Induction from the empty prefix through `ell=k-1`
reconstructs `r mod p^k`. At most `p-1` queries occur at each of `k` levels.
For `r=-1 mod p^k`, every digit is `p-1`, so every test is used. `square`

This proves an adaptive upper bound, not optimality among arbitrary decision
trees. A response can exceed the threshold and reveal several matching digits
at once; a globally optimized tree may exploit that information. The `0.21`
forecast correction is therefore retained.

## 3. Exact separation

For fixed `p` and increasing `k`, (2) is exponential in `k`, while (5) is
linear. At `(p,k)=(3,4)`, the fixed minimum is 54 centers and the adaptive
protocol uses at most 8. At `(2,8)`, the counts are 128 and 8.

The comparison is apples-to-apples at the semantic level: both reconstruct
the exact residue from the same valuation response primitive. What differs is
causal order. A fixed resolving family chooses every instrument before any
outcome; the adaptive protocol uses classical feedback to choose the next
instrument.

## 4. Process and quantum boundary

This is an exact process correspondence: allowing outcome-dependent instrument
choice can exponentially reduce queries even though each individual
observation is unchanged. It is a classical adaptive process, not indefinite
causal order and not a quantum advantage.

The state alphabet still has `p^k` possible residues. Under zero-error exact
storage, `EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO` still requires Hilbert
dimension at least `p^k`. Adaptivity reduces instrument count, not encoded
state dimension. Query cost, memory dimension, and causal architecture are
therefore three separate coordinates.

## 5. Change to the organism

The arithmetic organism should replace preinstalled complete resolving-center
families by this adaptive digit instrument whenever centers can be constructed
on demand. Its next cost question is no longer the cardinality of a static
sensor set, but the combined cost of:

1. constructing each branch-selected center;
2. executing the valuation query;
3. retaining the current prefix and control state.

The remaining exact theoretical question is the optimal worst-case adaptive
decision-tree depth for unrestricted valuation responses. It must not be
reported as `(p-1)k` without a lower bound.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_adaptive_valuation_centers.py
python3 adaptive_valuation_centers.py
```

The protocol and upper bound are proved above. Exhaustive finite runs are
falsifiers. No optimal adaptive lower bound, quantum query advantage,
thermodynamic cost, physical non-Markovianity, indefinite causal order, or
spacetime claim is made.
