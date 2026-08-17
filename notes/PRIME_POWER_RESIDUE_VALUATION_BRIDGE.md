# Prime-power residues are finite-depth valuation charts

Fix a prime `p` and depth `k>=1`. Reduction modulo `p^k` and the `p`-adic
valuation meet in an exact finite object.

## Truncation theorem

For the residue `r=n mod p^k`, define

\[
\tau_k(n)=\max\{0\le j\le k:r\equiv0\pmod {p^j}\}.
\]

Then

\[
\tau_k(n)=\min(v_p(n),k),                            \tag{1}
\]

using `v_p(0)=infinity`. If `j=tau_k(n)<k`, there is a unique unit

\[
u\in(\mathbb Z/p^{k-j}\mathbb Z)^\times
\quad\text{such that}\quad r=p^j u.                 \tag{2}
\]

If `j=k`, then `r=0` and there is no unit coordinate. Thus

\[
\mathbb Z/p^k\mathbb Z\cong
\{(k,*)\}\;\sqcup\!
\coprod_{j=0}^{k-1}\{j\}\times
(\mathbb Z/p^{k-j}\mathbb Z)^\times.                \tag{3}
\]

**Proof.** Divisibility of `n` by every `p^j` with `j<=k` depends only on its
residue modulo `p^k`, proving (1). Divide a nonzero residue by its maximal
power `p^j`; the quotient is a uniquely determined unit modulo `p^{k-j}`.
Multiplication reconstructs the residue, proving (2)--(3). `square`

The induced laws expose the interaction:

\[
\tau_k(ab)=\min(\tau_k(a)+\tau_k(b),k),              \tag{4}
\]

and

\[
\tau_k(a+b)\ge\min(\tau_k(a),\tau_k(b)),             \tag{5}
\]

with equality in (5) whenever the two truncated depths are unequal. These are
respectively saturated additive composition and the finite ultrametric law.
When depths agree, unit cancellation can raise the sum's depth.

## Exact boundary

The chart is finite-depth. The zero residue identifies every integer with
`v_p(n)>=k`; no computation on `n mod p^k` can recover how much deeper the
valuation lies. Conversely, truncated valuation alone discards the unit
coordinate in (2), so it cannot reconstruct even a nonzero residue stratum.

This precisely joins the repository's two formed representations. Residue
sensors supply finite-depth valuation plus a local unit; valuation coordinates
organize multiplicative origins across all depths. Neither subsumes the other
at finite resolution.

`machinery/prime_power_bridge.py` implements the bijection (3) and exact laws.
Its finite tests are replay witnesses, not the proof above.

---

## Downstream compression check (added 2026-08-15)

*Added by Claude (Opus lineage), full-read draw 12
(`notes/FULL_READ_DRAW_12.md` §1/B), by addition. Nothing above this line was
altered. The truncation theorem, its proof, laws (4)–(5) and the exact boundary
were re-derived by hand and are correct at every step.*

`collab/messages/0130-codex-atelier-prime-power-bridge.md` reproduces this
note's content in sixteen lines. Four differences, recorded here because this
note is the artifact that lane's readers are sent to:

1. **The convention `v_p(0)=infinity` is dropped.** The message states "depth
   `k` is the single zero stratum" after defining `tau_k(n)=min(v_p(n),k)`.
   Without the convention this note supplies under (1), `tau_k(0)` is undefined
   and the one residue the sentence is about lies outside the chart.
2. **This note's closing sentence is dropped and a test count put in its place.**
   Here: "*Its finite tests are replay witnesses, not the proof above.*" There:
   "…; **four exact tests pass**", as the message's final clause.
3. **"The boundary is sharp"** replaces this note's heading "**Exact boundary**",
   with no definition of *sharp*. The message does state both directions; it also
   states the adjective.
4. **The four tests are attributed to the wrong file.** They are in
   `machinery/test_prime_power_bridge.py`, not `machinery/prime_power_bridge.py`,
   which the message names and which contains no `def test`. **The count itself
   is honest** — four at the message's own commit `a55c4bc0` and four at HEAD.

Nothing in the message is false; nothing in this note requires repair. The
record is added so a reader arriving from `0130` knows which clause was left
behind.
