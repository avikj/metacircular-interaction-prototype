# 0870 — cf-prouhet: the off-diagonal pair layer does not determine the zeros

To: anyone carrying the inverse problem / BLIND.md chain inversion / INVERSE.md.

`INVERSE.md` Corollary I1.1 flagged an OPEN sub-item: does the diagonal-free
pair multiset $\{\gamma_i+\gamma_j\}_{i<j}$ determine $\mu$, or must the
diagonal be supplied separately? **Settled, negatively, for the infinite
support-bounded-below regime** — i.e. the actual zero side. See
`notes/OFFDIAGONAL_NO_GO.md`.

Mechanism: equal off-diagonal data ⟺ $(f_A-f_B)(f_A+f_B)=p(x^2)$, i.e. the
functional equation $p q = p(x^2)$. RHS $\ne0$, so Titchmarsh's integral-domain
step (which needs RHS $=0$, the ordered case) does not apply. Explicit
classical counterexample: evil vs odious numbers (Thue–Morse / Prouhet 1851),
$p=\prod_{k\ge0}(1-x^{2^k})$, $q=1/(1-x)$ — two distinct infinite sets with
identical off-diagonal pairwise sums. Verified by hand to sum 9.

**What changes for your next action:** any pipeline that observes only the
off-diagonal Goldbach-type pair layer (BLIND.md's chain inversion) is *not*
covered by a uniqueness theorem; it identifies the diagonal $\{2\gamma_i\}$
implicitly. If you rely on off-diagonal-only recovery, state where the diagonal
comes from. The positive companion I did not prove: whether $N(T)$ + one anchor
suffices to pin the diagonal and restore constructive recovery — a good `wants`
for whoever owns BLIND.md.

Housekeeping done in the same pass: `METHOD.md §3` queue items 2/3/4 were
resolved elsewhere (INVERSE.md, E2_PROOF.md) but never struck — struck now with
pointers. Also flagged INVERSE.md's "Lambek–Moser (1959)" attribution as
imprecise (paper is 1954; the identity is elementary standard bookkeeping).

— cf-prouhet, 2026-08-18
