# Optimal adaptive formation of a prime-power residue

> **FOUR PROOFS OF ONE THEOREM. You are reading number 2.** `D(p,k) = k(p−1)`
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
> Both halves are machine-checked as of 2026-08-22 in
> `formal/cubical/NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne.agda`
> (`--cubical --safe`, no postulates, no holes, in `Everything.agda`).
> Cross-reference added 2026-08-22; nothing in the body below is altered.

Fix (R_k=\mathbb Z/p^k\mathbb Z). A query chooses a center (c\in R_k) and
receives

\[
q_c(r)=\min(v_p(r-c),k).                                \tag{1}

Centers may depend on all earlier responses. `MINIMUM_VALUATION_PROBE_BASIS`
proved that a nonadaptive primitive basis needs ((p-1)p^{k-1}) centers. The
adaptive cost is exactly linear in depth.

## The theorem

**Theorem 1.** Every residue can be identified using at most

\[
\boxed{k(p-1)}                                          \tag{2}

adaptive probes, and no adaptive strategy has a smaller worst-case count.

### Upper bound

Suppose the first (j) base-(p) digits of (r) are known, so
(r\equiv a\pmod {p^j}). Its next digit is one of (0,\ldots,p-1). For
(d=0,\ldots,p-2), query the center

\[
c_d=a+d p^j.                                           \tag{3}

If (q_{c_d}(r)\ge j+1), the next digit is (d). If all (p-1) probes
return exactly (j), the digit is the sole untested value (p-1). Thus at
most (p-1) queries determine one digit. Repeating for (j=0,\ldots,k-1)
proves (2). A response larger than (j+1) is allowed; this strategy simply
uses the digit information it certifies and does not need to discard the
valid extra precision.

### Matching adversary

We describe an adversary against an arbitrary adaptive strategy. At level
(j), maintain one residue ball

\[
B=a+p^jR_k                                             \tag{4}

whose lower (j) digits have been fixed. It has (p) children modulo
(p^{j+1}), initially all live.

For any queried center (c):

- if (c\notin B), every state in (B) has the same response
  (v_p(a-c)<j), so answer that value and eliminate no child;
- if (c) lies in a child already eliminated, every live child again gives
  response (j);
- if (c) lies in a live child and at least two live children remain, answer
  (j), eliminating at most that one child.

Consequently the strategy must query centers in (p-1) distinct live
children before only one child remains. The adversary then replaces (B) by
that child and repeats at level (j+1). This forces (p-1) queries at each
of (k) levels, for (k(p-1)) total. The maintained answers are jointly
consistent with every residue in the current live union, and after the final
level with its unique leaf. Hence this is a lawful decision-tree adversary,
not merely an information-count estimate. ∎

## Formation event and comparison

The adaptive strategy forms the residue digit by digit. At each level the
frontier is a set of live children. A negative response removes one child; a
positive deeper response selects one. The final observable is the exact
residue, with a transcript replaying every earned digit.

Three exact costs now coexist:

\[
\begin{array}{c|c}
\text{currency}&\text{cost}\cr
\hline
\text{translation-group generators}&1\text{ unit generator}\cr
\text{nonadaptive primitive probes}&(p-1)p^{k-1}\cr
\text{adaptive primitive queries}&k(p-1).
\end{array}                                             \tag{5}
\]

The first count permits repeated composition of an action. The latter two
treat arbitrary centers as already available and count observations. Neither
prices construction of the centers; the swarm's witness-construction results
provide a separate trace/cost coordinate for that task.

## Executable certificate

`machinery/adaptive_valuation_probes.py` executes (3), returns the exact
transcript, and verifies it by replay. The all-((p-1))-digit residue attains
the bound for this strategy. A separate exact minimax solver checks small
charts against (2) as a falsifier only; the adversary proof establishes
optimality.

## Rigor boundary

Proved: Theorem 1 in the deterministic exact-query model with arbitrary
centers and unit query cost. No novelty is claimed; this is elementary
decision-tree/ultrametric mathematics.

Not proved: optimal total cost when centers must themselves be formed;
average-case cost under a distribution; noisy responses; parallel query
rounds; or joint sensing across several primes.
