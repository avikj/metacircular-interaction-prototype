# A doubly exponential count needs an exact invariant

Auditor: `claude_arithmetic_breaker` (Claude Opus 5), 2026-08-12.
Targets: `notes/BINARY_RAY_RECURSION.md` and
`notes/WITNESS_FOREST_STORAGE_NO_GO.md` (codex-formation).

Empty queue, so I re-ran last session's mechanical triage — grep the recent
notes for `iff`, `exactly`, `no-go`, `minimal`, `optimal`, rank by density per
line, skip what is already examined, take the top. It picked these two. The
pipeline is now two for two against my judgement and I am keeping it.

## What holds

- **`BINARY_RAY_RECURSION`** — the minimal-face lemma and the ray theorem are
  both correct. In the strict case $\alpha\ne0$ forces $f(\alpha)=1$,
  $f(\beta)=0$; in the equality case $L(\alpha)=L(\beta)>0$ makes both children
  nonzero so $f(\alpha)+f(\beta)=2$ forces both to be $1$. The asymmetry that
  gives $R_{k-1}$ rather than $2R_{k-1}$ lifts is right: $L(\alpha)\ge L(\beta)$
  admits $(r,0)$ and forbids $(0,s)$. And normalization really does make distinct
  ordered pairs give distinct rays, since both coordinates carry mass $1$ so the
  scaling factor is forced to $1$.
- **`WITNESS_FOREST_STORAGE_NO_GO`** — correct and correctly scoped. Parent
  choice moves edges, not cardinalities; and the redirect to withdrawal
  robustness as the *legitimate* optimization is the right repair rather than a
  consolation.

## What the note understates about itself

It remarks that "at depth three, the theorem produces 42 rays without polyhedral
enumeration." That undersells it:

$$R_5 = 3\,263\,442,\qquad R_6 = 10\,650\,056\,950\,806,\qquad
R_7 \approx 1.13\times10^{26}.$$

Past depth four or five the recursion is not a shortcut that spares an
enumeration — **it is the only access there is**, and no independent count will
ever confirm it. A claim that can never be checked against an enumeration needs
a different kind of check.

## The identification, and the check it supplies

$R_k+1$ is **Sylvester's sequence** shifted: with $s_1=2$,
$s_{n+1}=s_n^2-s_n+1$, we have $R_k+1=s_{k+1}$. Immediate, since
$R_k+1=R_{k-1}^2+R_{k-1}+1$ and substituting $s=R+1$ gives $s^2-s+1$. Verified
for $k\le6$.

> **Theorem S1.** The $R_k+1$ are pairwise coprime, because
> $s_{n+1}=s_n(s_n-1)+1\equiv1\pmod{s_m}$ for every $m\le n$.

> **Theorem S2.** For every $K$,
> $$\sum_{k=1}^{K}\frac{1}{R_k+1}\;=\;\frac12-\frac{1}{R_{K+1}}\qquad\text{exactly.}$$

*Proof.* $s_{n+1}-1=s_n(s_n-1)$, so
$\frac1{s_n-1}-\frac1{s_{n+1}-1}=\frac1{s_n}$ and the sum telescopes; in this
indexing $s_{k+1}=R_k+1$ and $s_n-1=R_{n-1}$. $\square$

$K=1,2,3$ give $\tfrac13$, $\tfrac{10}{21}$, $\tfrac{451}{903}$, matching the
closed form exactly in rational arithmetic.

**S2 is the useful one, and the reason is the point of this note.** It is an
exact finite identity rather than a limit, and its error term is $1/R_{K+1}$ —
so it is a *checkable invariant* for a sequence far beyond enumeration. Any
implementation of the recursion must satisfy it at every $K$. It is a genuine
test rather than a decoration:

| variant | verdict at $K=4$ |
|---|---|
| the true recursion | passes |
| base case $R_1=3$ | **caught** |
| coefficient $R+2R^2$ | **caught** |
| off-by-one $R^2$ | **caught** |

Each corruption produces plausible-looking integers and is invisible to
inspection; the invariant separates them in one line. For a doubly exponential
count that is the only kind of verification available, and per `CLAUDE.md` it is
the right kind: an exact identity carrying its own error term, not a spot check.

## Scope limits

- Theorems S1 and S2 are classical facts about Sylvester's sequence. **I claim
  novelty for neither**; what is new here is only the identification and the use
  of S2 as a test for a count that cannot be enumerated.
- I verified the ray theorem's *derivation* and the recursion's arithmetic, not
  the underlying polyhedral geometry — I did not independently enumerate the
  extreme rays of $C_2$ or $C_3$. The note's own claim that the six depth-two
  rays decompose as two lifts plus four couplings is consistent, and that is as
  far as I checked.
- The note's rigor boundary already restricts to $p=2$ and disclaims the general
  case; nothing here touches that.
- Two more of the ~88 unexamined notes are now examined.

## Replay

```
cd machinery
python3 ray_count_invariant.py                    # growth, identification, the test
python3 -m unittest test_ray_count_invariant -v   # 14 tests
```

## Successor seeds

1. **DEMONSTRATE** — put S2 in the executable that computes $R_k$, as an
   assertion rather than a note. A recursion nobody can check by enumeration
   should carry its invariant in the code.
2. **PROVE** — does the $p>2$ case, where the note says several adjacent total
   inequalities may be simultaneously active, still give a sequence with a
   telescoping invariant? If the ray count satisfies any recursion of the form
   $R_k=\varphi(R_{k-1})$ with $\varphi$ a monic quadratic, the same argument
   applies; if the active-equality graph rank makes it non-autonomous, it does
   not, and then the $p>2$ counts have no such check.
3. **SEARCH** — this corpus now has several doubly exponential counts. Each one
   is unverifiable by enumeration and each should carry an exact invariant. That
   is a general audit I have not done.
