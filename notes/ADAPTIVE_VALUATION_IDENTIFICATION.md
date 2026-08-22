# Adaptive valuation identification costs exactly one child search per digit

> **FOUR PROOFS OF ONE THEOREM. You are reading number 3.** `D(p,k) = k(p−1)`
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

Let an unknown state be `r in R_k=Z/p^kZ`. A query chooses a center `c` and
receives

\[
\tau_k(r+c)=\min(v_p(r+c),k).
\]

The nonadaptive resolving-center theorem requires
`(p-1)p^(k-1)` simultaneous coordinates. Adaptivity changes the scale.

## The exact minimax theorem

**Theorem.** The least worst-case number of adaptive valuation queries needed
to identify every `r in R_k` is

\[
\boxed{k(p-1)}.
\]

*Upper bound.* Suppose the first `j` base-`p` digits of `r` are known, so it
lies in one ball `B` modulo `p^j`. The ball has `p` children modulo
`p^(j+1)`. Query centers whose negatives lie in `p-1` of those children. A
query aimed at child `D` returns a value greater than `j` exactly when `r` is
in `D`; otherwise it returns exactly `j`. Hence at most `p-1` queries identify
the next child. A response deeper than `j+1` only reveals extra digits and may
skip later work. Repeating gives at most `k(p-1)` queries.

*Lower bound.* Use an adversary maintaining a current ball `B` modulo `p^j`.
A center with `-c` outside `B` has constant response on `B` and yields no
information. A center with `-c` inside `B` targets exactly one of its `p`
children. On every other child the response is exactly `j`. The adversary
answers `j`, discarding only the targeted child. For the first `p-1` distinct
targeted children these answers remain consistent; after them, retain the sole
untargeted child as the new ball modulo `p^(j+1)`. Thus every digit can be
forced to cost `p-1` queries. Iterating through `k` levels forces `k(p-1)`.
The adversary ends with one residue, so the entire transcript is consistent
with an actual state. ∎

The proof also explains why deep answers do not improve worst-case cost: the
adversary always chooses a sibling outside the queried center's child and
returns the shallow boundary depth.

## Separation from other costs

Claude History's subtractive construction forms a member of any prescribed
critical congruence class cheaply once the correction `a` is already held.
That is a construction theorem. The present theorem asks which unknown residue
`r` is present. Cheap formation of `-a mod p^E` does not supply the missing
digits of an unknown `r`; sensing and construction remain different edges.

For exact zero-error memory, after identification there remain `p^k` possible
states and hence Hilbert dimension `p^k` by the orthogonal-profile theorem.
Adaptivity reduces queries, not the final exact state alphabet.

## Rigor boundary

The minimax theorem is proved above. The executable solves bounded decision
trees exactly and replays a digit strategy; it is not evidence for the general
claim. Queries are noiseless, centers are freely selectable, and only query
count is priced. Center formation, bit operations, approximate identification,
and infinite `Z_p` are outside scope.

