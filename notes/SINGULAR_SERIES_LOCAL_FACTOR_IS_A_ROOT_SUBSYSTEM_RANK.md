# The local singular series factor is a root-subsystem rank

**Author:** cf-sakshi, 2026-08-14. Delta 17 §17.23 item 3, executed:
*"compute local singular series factors directly from $A_{k-1}$ collision/root
data."* Exact; verified by two independent routes.
`natural_machine_cpu_loop_rust/root_singular_series.rs`.

Delta 17 §17.23 item 6 says to formalize in Cubical Agda *only after the
mathematics is clear*. This note is the mathematics; nothing is formalized here.

> **Amendment, 2026-08-14 (cf-sakshi).** This note leans on Delta 17 T17.24,
> which is **misstated as supplied**: $\mathbb{Z}^k/\mathbb{Z}\delta$ is the
> $A_{k-1}$ **weight** lattice $P$, not the root lattice $Q = \{x : \sum x_i =
> 0\}$; the two differ by $P/Q \cong \mathbb{Z}/k$. See
> `formal/cubical/NaturalMachine/RootWeightIndex.agda` (checked at $k=2$ over
> any commutative ring) and the ledger row in
> `collab/orchestration/delta-coverage.md`.
>
> **Nothing below changes.** Everything here uses **rank**, and rank is
> insensitive to the index: $Q \hookrightarrow P$ is injective with finite
> cokernel, so $\operatorname{rank} \Phi_p(H)$ is the same computed in either
> lattice. That is why the amendment is a note and not a retraction — but it had
> to be checked rather than assumed, since a load-bearing citation naming the
> wrong object is exactly how an off-by-an-index error propagates.

## 1. The two inputs

**From the corpus.** `ADELIC.md` §1 carries the $k$-tuple local density with
$\nu_p(H)$ forbidden classes, where $\nu_p(H)$ is the number of distinct residues
of $H=(h_1,\dots,h_k)$ mod $p$:

$$\sigma_p(H) \;=\; \Bigl(1-\frac{\nu_p(H)}{p}\Bigr)\Bigl(1-\frac1p\Bigr)^{-k}.$$

**From Delta 17 §17.16.** The additive relative coordinates of a $k$-tuple are
the $A_{k-1}$ roots $h_i-h_j$, with Weyl group $S_k$.

The two have never been put together. Doing so is one definition and one lemma.

## 2. The vanishing subsystem

> **Definition.** For $\Phi = \Phi(A_{k-1}) = \{e_i-e_j : i\ne j\}$ and a prime
> $p$, the **vanishing subsystem** is
> $$\Phi_p(H) \;=\; \{\alpha\in\Phi \;:\; \alpha(H)\equiv 0 \bmod p\}
> \;=\; \{e_i-e_j \;:\; h_i\equiv h_j \bmod p\}.$$

> **Theorem.** Let $H$ have distinct entries and let $p$ be prime. Then
>
> **(i)** $\Phi_p(H)$ is a closed subsystem of $\Phi$ — the Levi subsystem
> $\prod_t A_{m_t-1}$, where $m_1,\dots,m_r$ are the sizes of the fibres of
> $H \bmod p$; equivalently, the root system of the Young subgroup
> $S_{m_1}\times\cdots\times S_{m_r}$ stabilising those fibres.
>
> **(ii)** $\displaystyle \nu_p(H) \;=\; k - \operatorname{rank}\Phi_p(H).$
>
> **(iii)** $\displaystyle \sigma_p(H)
> = \Bigl(1-\frac{k-\operatorname{rank}\Phi_p(H)}{p}\Bigr)\Bigl(1-\frac1p\Bigr)^{-k}.$
>
> **(iv)** $H$ is admissible ($\mathfrak S(H)\ne 0$) **iff**
> $$\operatorname{rank}\Phi_p(H) \;>\; k-p \qquad\text{for every prime } p\le k.$$

*Proof.* Closedness is immediate and is the only place the root structure is
used: if $e_i-e_j$ and $e_j-e_l$ both vanish mod $p$ then so does their sum
$e_i-e_l$, because vanishing is a linear condition. So $\Phi_p(H)$ is the full
set of roots supported inside the fibres of $H \bmod p$, which is the standard
Levi subsystem of that Young subgroup — type $\prod_t A_{m_t-1}$, giving (i).

For (ii): the $\mathbb{Q}$-span of $\{e_i-e_j\}$ over a block of size $m$ is the
sum-zero subspace of that block's coordinates, of dimension $m-1$; distinct
blocks use disjoint coordinates, so the spans are independent and
$\operatorname{rank}\Phi_p(H) = \sum_t (m_t-1) = k - r$. Since $r$ is exactly the
number of distinct residues, $r=\nu_p(H)$ and (ii) follows.

(iii) is substitution. For (iv): $\sigma_p(H)=0$ iff $\nu_p(H)=p$, and
$\nu_p(H)\le\min(k,p)$, so this can only happen for $p\le k$; by (ii) it is
$k-\operatorname{rank}\Phi_p(H) = p$, i.e. $\operatorname{rank}\Phi_p(H)=k-p$.
Admissibility is the negation for all such $p$, and since
$\nu_p(H) \le p$ always gives $\operatorname{rank}\Phi_p(H)\ge k-p$, the negation
is the strict inequality. $\square$

## 3. Verification, by a route that does not know about blocks

The proof of (ii) goes through the block partition, so a check that also counts
blocks would be circular. `root_singular_series.rs` computes the two sides by
genuinely different means:

- $\nu_p(H)$ by direct residue counting;
- $\operatorname{rank}\Phi_p(H)$ by **fraction-free Gaussian elimination over
  $\mathbb{Q}$** on the explicit list of vanishing root vectors in $\mathbb{Z}^k$
  — no partition is formed, no block is counted.

> **108,596 instances** — all strictly increasing $k$-tuples in a window for
> $k=2,\dots,5$, against every prime $p\le 59$ — **0 disagreements.**

Worked instances, with the local factors as exact fractions:

| $H$ | $p$ | $\nu_p$ | $\operatorname{rank}\Phi_p$ | $\sigma_p$ |
|---|---|---|---|---|
| $\{0,2\}$ | 2 | 1 | 1 | $2$ |
| $\{0,2\}$ | 3 | 2 | 0 | $3/4$ |
| $\{0,2,6\}$ | 3 | 2 | 1 | $9/8$ |
| $\{0,2,4\}$ | 3 | 3 | 0 | $0$ |
| $\{0,2,6,8\}$ | 3 | 2 | 2 | $27/16$ |

The inadmissible tuple is caught exactly by the criterion: at $p=3$,
$\operatorname{rank}\Phi_3(\{0,2,4\}) = 0$ against $k-p = 0$, and $0 > 0$ fails.
The admissible $\{0,2,6\}$ has $\operatorname{rank}\Phi_3 = 1 > 0$.

## 4. What this buys, and what it does not

**Buys, precisely three things.**

1. **The local factor is a function of a root-subsystem rank**, so its
   $S_k$-invariance is now structural rather than a checkable coincidence: the
   Weyl group permutes the $h_i$, carries $\Phi_p(H)$ to a conjugate subsystem,
   and conjugate subsystems have equal rank. Delta 17 C17.25's "same Weyl
   combinatorics" is doing work here rather than being observed.
2. **Admissibility becomes a rank inequality on root subsystems**,
   $\operatorname{rank}\Phi_p(H) > k-p$ for $p\le k$. The classical statement
   ("$H$ does not cover all residues mod some $p\le k$") is a counting condition
   on a partition; this is a dimension condition on a subsystem, and dimension
   conditions are what transfer to other root systems.
3. **It is the first place the additive relative geometry $V_k$ of Delta 17
   §17.16 touches an arithmetic density in this corpus.** `ADELIC.md`'s
   $\nu_p(H)$ was a count; it is now the corank of the vanishing roots.

**Does not buy.** No new arithmetic. Delta 17 C17.34 states the boundary and it
is the right one: *geometry can unify the ambient spaces without solving the
arithmetic measure.* This note moves the singular series into the root frame; the
prime-supported measure on that frame is untouched, and every hard question about
it — parity, minor arcs, the $\theta$ ladder of `WIDTH.md` — is exactly as hard
as before.

**Novelty.** None claimed. That $\nu_p$ counts blocks of the mod-$p$ partition is
classical; that those blocks are the Levi subsystem of vanishing $A_{k-1}$ roots
is a translation, not a discovery. No prior-art search was run, and given that
the statement is a dictionary entry between two standard descriptions, one should
expect it to be known. Recorded as `SEARCH` owed before any novelty language.

## 5. The successor this makes well posed

The rank formulation has a hypothesis the counting formulation hides: it is
about $A_{k-1}$ specifically. Delta 17 §17.16 derives $A_{k-1}$ from the diagonal
torus on $(\mathbb G_m)^k$, so:

> **Open.** For which root systems $\Phi$ does the assignment
> $p \mapsto (1 - (\operatorname{rank}\Phi - \operatorname{rank}\Phi_p(H))/p)
> \cdot(\text{normalisation})$ define a convergent Euler product, and does any of
> them correspond to an arithmetic counting problem the way $A_{k-1}$ corresponds
> to prime $k$-tuples?

Type $B/C/D$ would bring the one-leg sign reflection $J_2$ of Delta 17 §17.4 into
the Weyl group as a genuine reflection rather than an extra involution — and
§17.4 warns explicitly that those two involutions must stay distinct. So the
question is not decorative: it asks whether the sign-reflection sector this corpus
keeps meeting is a Weyl reflection of a larger system, or is genuinely outside
any of them.
