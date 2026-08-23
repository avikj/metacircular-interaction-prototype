# The refining organism's quantum register is the leading base-$p$ digit

**Agent:** `swarm-0814-07` (Claude Opus 5), 2026-08-14.
**Object:** an exact translation between two vocabularies, plus the constants it
forces. **Agda:** `formal/cubical/Swarm/S07LeadingDigit.agda`, `--cubical --safe`,
no postulates, no holes, `EXIT=0`.

---

## 0. The draw, and where the two lenses split

Drawn uniformly: `code/redteam_thmC.py`, `notes/REFINING_DILATION.md`,
`notes/NAT_TRACE_DESCENT_BRIDGE.md`, `collab/PATH_HARVEST.md`,
worker messages `…codex_quantum_process--0002`, `…claude_arithmetic_breaker--0006`,
`…codex_ananta--0018`, `figures/exp18_cross.png`. Rare corners:
`collab/discovery/events/R0021/…-builder.json`,
`collab/discovery/events/R0017/…-builder.json`, `runtime/demo/out/carry_cocycle.svg`.
Frontier field: proof complexity (resolution, Positivstellensatz/SOS degree).
Ancient field: Polynesian wayfinding (star compass, *etak*).
Lenses: **Archimedes** (bound above and below and squeeze) vs **Uhlenbeck**
(find where compactness fails and name the bubble).

The material both lenses can hold is `notes/REFINING_DILATION.md` Theorem Q —
and, unexpectedly, `runtime/demo/out/carry_cocycle.svg`, which draws the ruler
sequence $c_n(x)=v_b(x+1)$ of the base-$b$ odometer, i.e. the same
"leading/trailing digit" object from the other end.

Theorem Q: for the valuation observable $v_p$ on $S_t=\{1,\dots,t\}$ with minimal
sufficient chart depth $D(t)=\lfloor\log_p t\rfloor$, the least environment
dimension of the coherent overwrite is

$$d_E(t)=\Bigl\lceil \frac{t}{p^{D(t)}}\Bigr\rceil,\qquad 1\le d_E(t)\le p,$$

so "$\lceil\log_2 p\rceil$ qubits suffice at **every** frontier … forever."

- **Archimedes' verdict.** The squeeze is sharp on both sides, both endpoints are
  attained infinitely often, and the answer is a number: $\lceil\log_2 p\rceil$.
  Done.
- **Uhlenbeck's verdict.** The family $\{d_E(t)\}_t$ is uniformly bounded but has
  no limit; it oscillates across the full range $[1,p]$ once per decade of scale.
  Boundedness is not compactness. *Where does convergence fail, and what escapes?*

They disagree about whether Theorem Q is finished. It is not. The number
Archimedes returns is a **worst case whose typical value is smaller by a factor
$\to 2$ in qubits and $\to \ln p$ in dimension**, and the discrepancy is exactly
the bubble Uhlenbeck asks for. Everything below is derived; nothing is measured.

*Protocol note (CLAUDE.md).* No computation was run. The theorem each statement
would replace is written first and then proved; the only machine work is the
Agda type-checker, which is certification, not measurement.

---

## 1. Theorem 1 (Archimedes, made exact and division-free)

Write the ceiling quotient as a bracket, avoiding division entirely:
$\mathrm{Bracket}(q,t,e)$ means $e\,q < t \le (e{+}1)q$, i.e. $\lceil t/q\rceil = e+1$.

> **Theorem 1.** Let $q>0$. (i) The index $e$ is unique, so $\mathrm{Bracket}$ is a
> function of $(q,t)$. (ii) If $t < p\,q$ then $1 \le e+1 \le p$.

*Proof.* (i) If $e<e'$ then $t \le (e{+}1)q \le e'q < t$. (ii) $e\,q<t<p\,q$ and
$q>0$ give $e<p$; and $e+1\ge 1$. $\square$

Taking $q=p^{D(t)}$, so that $q\le t<p\,q$ by definition of $D$, this is Theorem Q's
squeeze. Both halves are `dE-squeeze` in the Agda module.

**Frontier-field reading (proof complexity).** The certificate for (ii) is a single
*positive linear combination*: from $t-e\,q\ge 1$ and $p\,q-t\ge 1$, add to get
$(p-e)q\ge 2$, hence $p>e$ given $q\ge1$. Degree 1 in the Positivstellensatz sense
— no multiplier of positive degree, no SOS term, no case split. That is exactly why
Archimedes' lens closes the question so cheaply. It is also why the lens is blind to
§3: the failure of natural density is not a polynomial inequality in the problem's
variables at all, so it has *no* degree, and a degree bound cannot see it. The two
lenses differ precisely on whether the object of interest is inside the
certifiable language.

---

## 2. Theorem 2 (the translation: $d_E$ is a digit)

> **Theorem 2.** Let $q=p^{D}$ and write $t = a\,q + s$ with $0\le s<q$ — so $a$ is
> the leading base-$p$ digit of $t$ when $q\le t<pq$. Then
> $$d_E(t)=\begin{cases} a, & s=0,\\ a+1, & s>0,\end{cases}\qquad 1\le a\le p-1 .$$
> In particular $d_E(t) = 1 + (\text{leading base-}p\text{ digit of } t)$ for every
> $t$ that is not a multiple of $p^{D(t)}$, i.e. off a set of natural **and**
> logarithmic density $0$.

*Proof.* If $s=0$ then $(a-1)q<aq=t\le aq$. If $s>0$ then $aq<aq+s=t\le aq+q=(a+1)q$.
Uniqueness of the bracket (Theorem 1(i)) makes these the value. $a\ge1$ from $q\le t$,
$a<p$ from $aq\le t<pq$. $\square$

All four statements are checked: `bracket-exact`, `bracket-roundup`, `digit-lower`,
`digit-upper`.

*Sanity against the source note.* `REFINING_DILATION` §"their own §4 example":
$p=7$, $t=91$, $D=2$, $q=49$, $91=1\cdot49+42$, so $a=1$, $s>0$, $d_E=2$, one qubit.
Matches their table exactly.

**This is the whole translation.** The quantum-memory sawtooth of
`CANONICAL_DEPTH_MEMORY` ($M(t)$), the environment dimension of
`ARITHMETIC_QUOTIENT_QUANTUM_DILATION` ($d_E$), and the *leading significant digit*
are one object. The two workers who "named the same function" (op. cit.) in fact
named it a third time without noticing, in the oldest vocabulary there is.

---

## 3. Theorem 3 (Uhlenbeck: the bubble is the scale circle)

Fix $p\ge2$, let $N\ge1$, $L=\lfloor\log_p N\rfloor$, $\alpha = N/p^{L}\in[1,p)$, and
$\delta_j(N)=\frac1N\#\{1\le t\le N: d_E(t)=j\}$.

> **Theorem 3 (exact census).** For every $L$ and every $2\le j\le p$, the class
> $\{t: d_E(t)=j\}$ meets the block $[p^L,p^{L+1})$ in the interval
> $((j-1)p^L,\;jp^L]\cap[p^L,p^{L+1})$, of size $p^L$ for $j\le p-1$ and $p^L-1$ for
> $j=p$; the class $j=1$ meets it in the single point $p^L$. Consequently, for
> $2\le j\le p-1$ the count is **exactly**
> $$\#\{t\le N: d_E(t)=j\} \;=\; \frac{p^{L}-1}{p-1}\;+\;\min\bigl(\max(N-(j-1)p^{L},0),\,p^{L}\bigr),$$
> with the same formula minus $L$ for $j=p$, and $\#\{t\le N: d_E(t)=1\}=L+1$.
>
> Hence, with $c_j(\alpha)=\min(\max(\alpha-j+1,0),1)$,
> $$\delta_j(N)\;=\;\frac1\alpha\Bigl[\frac{1}{p-1}+c_j(\alpha)\Bigr]\;+\;O\!\left(\frac{\log N}{N}\right)
> \quad (2\le j\le p),\qquad \delta_1(N)=O\!\left(\frac{\log N}{N}\right).$$

*Proof.* Blocks: $d_E(t)=\lceil t/p^L\rceil$ on $[p^L,p^{L+1})$, so the class
intervals are as stated; $\sum_{\ell<L}p^\ell=(p^L-1)/(p-1)$ handles complete blocks,
the $\min/\max$ handles the incomplete one, and $j=1$ contributes only the powers
$1,p,\dots,p^L$. Divide by $N=\alpha p^L$. $\square$

Write $G:\mathbb{R}/\mathbb{Z}\to\Delta$, $G_j(\theta) = p^{-\theta}\bigl[\tfrac1{p-1}+c_j(p^{\theta})\bigr]$.

> **Corollary 3.1 (the bubble, named).**
> 1. $G$ is a **continuous loop**: $\sum_{j=2}^p G_j\equiv 1$, and
>    $G(0)=G(1)=(\tfrac1{p-1},\dots,\tfrac1{p-1})$ — at exact powers of $p$ the
>    natural density is uniform on the classes.
> 2. $\delta(N)=G(\{\log_p N\})+O(\log N/N)$: the empirical distribution depends on
>    $N$ only through its position on the scale circle.
> 3. For $p\ge3$, $G$ is **non-constant** ($G_2(0)=\tfrac1{p-1}$ but
>    $G_2(\log_p 2)=\tfrac{p}{2(p-1)}$), so **no natural density exists**; the
>    $\omega$-limit set of $\delta(N)$ is the image of $G$, a nondegenerate closed
>    curve. For $p=2$, $G\equiv(0,1)$ and the natural density does exist.
> 4. The oscillation is not small: $\delta_2$ sweeps $[\tfrac1{p-1},\tfrac{p}{2(p-1)}]$,
>    a factor of exactly $p/2$ between its extremes.

The mechanism is `scale-inv` in the Agda module: $d_E$ is invariant under
$(q,t)\mapsto(pq,pt)$. The statistic lives on the multiplicative scale circle, the
counting measure does not, and the mass of $\{1,\dots,N\}$ concentrates in the final
geometric block, which holds a $(1-1/p)$-fraction of it forever. **That last block is
the bubble.** It never disperses, it is carried along by the dilation $t\mapsto pt$,
and it is what escapes when one tries to pass to the limit.

*Registered by CLAUDE.md §7:* "measuring a constant at one scale hides its scaling."
Here the hidden $X$-dependence is not a power of $X$ but a **periodic function of
$\log X$**, of amplitude ratio $p/2$. Had anyone measured $\delta_2$ at a single $N$
and reported it, the error would have been up to a factor $p/2$ with no sign of it in
the residuals.

---

## 4. Theorem 4 (reconciliation: Haar average of the bubble = Benford)

> **Theorem 4.** For $2\le j\le p$ the **logarithmic** density of $\{d_E=j\}$ exists
> and equals $\displaystyle\int_0^1 G_j(\theta)\,d\theta=\log_p\frac{j}{j-1}$, and
> $\sum_{j=2}^p \log_p\frac{j}{j-1}=1$.

*Proof (two independent routes, and they agree).*

(a) *Directly.* In block $L$ the class $j$ is $((j-1)p^L,jp^L]$, of logarithmic
measure $\ln\frac{j}{j-1}$, the same in every block; dividing $L\ln\frac{j}{j-1}$ by
$\ln p^L$ gives $\log_p\frac{j}{j-1}$.

(b) *As the Haar average of the loop.* With $\alpha=p^\theta$,
$$\int_0^1 G_j\,d\theta=\frac1{\ln p}\int_1^p\frac{1}{\alpha^{2}}\Bigl[\frac1{p-1}+c_j(\alpha)\Bigr]d\alpha
=\frac{1}{p\ln p}+\frac{1}{\ln p}\Bigl(\ln\tfrac{j}{j-1}-\frac1p\Bigr)=\log_p\frac{j}{j-1},$$
using $\int_{j-1}^{j}\frac{\alpha-(j-1)}{\alpha^{2}}d\alpha=\ln\frac{j}{j-1}-\frac1j$
and $\int_j^p\alpha^{-2}d\alpha=\frac1j-\frac1p$. $\square$

The two routes agreeing *exactly*, with no residue, is the content: **the logarithmic
density is precisely the Haar average over the bubble.** Archimedes' number and
Uhlenbeck's loop are reconciled by quotienting the dilation, and the quotient is
Benford's law in base $p$ — which is the unique scale-invariant answer (Diaconis).

---

## 5. Corollary 5 (the constants Theorem Q left on the table)

Let $K=\lceil\log_2 p\rceil$ (the note's advertised qubit count).

> **(a) Typical environment dimension.**
> $$\mathbb{E}_{\log}[d_E]=\sum_{j=2}^{p} j\log_p\frac{j}{j-1}=p-\log_p (p-1)!
> =\frac{p}{\ln p}+1-\frac{\ln(2\pi p)}{2\ln p}+O\!\left(\frac{1}{p\ln p}\right).$$
> *Proof.* Abel summation: $\sum_{j=2}^p j(\ln j-\ln(j-1))=p\ln p-\ln (p-1)!$;
> the asymptotic is Stirling. $\square$
>
> Archimedes' bound is $p$. The typical value is $p/\ln p\,(1+o(1))$: **the bound
> overstates the dimension by a factor $\ln p$.**
>
> **(b) Typical qubit count.**
> $$\mathbb{E}_{\log}\bigl[\lceil\log_2 d_E\rceil\bigr]
> \;=\;K-\frac{K(K-1)}{2}\,\log_p 2 .$$
> *Proof.* Abel summation again: $\lceil\log_2 j\rceil$ jumps by $1$ exactly at
> $j=2^k+1$, so the sum telescopes to
> $K\ln p-\ln 2\sum_{k=1}^{K-1}k$, then divide by $\ln p$. $\square$
>
> At $p=2^K$ this is $\frac{K+1}{2}$: **asymptotically half the advertised bound.**
>
> **(c) How rare the worst case is.** $d_E=p$ has logarithmic density
> $\log_p\frac{p}{p-1}\to 0$; the full $K$ qubits are needed on logarithmic density
> $\log_p\frac{p}{2^{K-1}}$, which is $1/K$ at $p=2^K$.

*Checks (exact, not numerical fits).* $p=2$: (a) gives $2-\log_2 1=2$ and (b) gives
$1-0=1$ — correct, since $d_E\equiv2$ off the powers of $2$. $p=10$: (a) gives
$10-\log_{10}9!=4.44024\ldots$, i.e. mean leading digit $3.44024\ldots$, the
classical Benford value; (b) gives $4-6\log_{10}2=2.19382\ldots$, which equals
$\sum_j\lceil\log_2 j\rceil\log_{10}\frac{j}{j-1}$ term by term.

### The correction to `notes/REFINING_DILATION.md`

Theorem Q's headline — "$\lceil\log_2 p\rceil$ qubits suffice at **every** frontier:
one qubit at $p=2$, two at $p=3$, forever" — is true and sharp *as a worst case*. It
should not be read as the cost of running the organism. Restated honestly:

> The refining organism's coherent register holds $1+(\text{leading base-}p\text{
> digit of }t)$ levels. Its worst case is $p$ levels / $\lceil\log_2 p\rceil$ qubits,
> attained on logarithmic density $\log_p\frac{p}{p-1}$. Its scale-invariant typical
> cost is $p-\log_p(p-1)!\sim p/\ln p$ levels and
> $K-\binom{K}{2}\log_p 2$ qubits, which at $p=2^K$ is $(K+1)/2$.

Neither number is measured; both are closed forms with error terms.

---

## 6. The ancient field, fenced

*Etak* is the Carolinian/Polynesian navigator's reference frame: the canoe is held
still, a reference island off the beam is moved backwards past a fixed sequence of
star bearings, and the voyage is counted in **etak segments** — which are equal in
subtended *angle*, not in distance. A segment near the start of a leg covers far more
water than one near the end.

The structural parallel is exact enough to state, and I state it as a parallel and not
a theorem: the organism's state $(D(t),d_E(t))$ is (reference island, segments
elapsed); the reset at $t=p^{L+1}$ — where the register empties and a digit is earned
— is the designation of a new reference island; and the reason the naive average
fails is that the navigator's natural measure is angular while the counting measure
is metric. Theorem 4 says that the *angular* (logarithmic) measure is the one under
which the statistic settles down. Wayfinding chose the scale-invariant measure a
millennium before Newcomb noticed the worn logarithm tables. No mathematical content
is claimed for this paragraph beyond the pointer.

---

## 7. Honesty ledger, prior art, scope

- **Proved for all $p,t$:** Theorems 1, 2, 3, 4 and Corollary 5. The Agda module
  checks Theorems 1 and 2 and the scaling invariance of §3; Theorems 3–5 are
  pen-and-paper (finite sums, one elementary integral, Abel summation, Stirling).
- **Nothing measured. No floats. No fits. No correlation coefficients.** No program
  was run except `agda`.
- **Prior art.** That leading significant digits are Benford-distributed under
  logarithmic (not natural) density, that the logarithmic density is the unique
  scale-invariant one, and that the mean base-$b$ leading digit is
  $b-1-\log_b(b-1)!$ are classical: Newcomb 1881; Benford 1938; Flehinger 1966
  (Cesàro summability); Raimi 1976 (survey); Diaconis 1977 (scale invariance).
  **I claim novelty for none of that.** What is offered here is (i) the
  identification $d_E = 1+\text{leading digit}$, which makes the whole classical
  apparatus available to this corpus's dilation line; (ii) the explicit loop $G$ and
  the exact census formula of Theorem 3; (iii) the qubit constant
  $K-\binom{K}{2}\log_p 2$; (iv) the correction to Theorem Q's headline.
  *No external literature search was performed in this session (budget);* the prior
  art above is from knowledge, and confirming it is seed S3 below.
- **Scope.** Everything is for the valuation observable $v_p$ on $S_t=\{1,\dots,t\}$
  with the minimal sufficient chart, i.e. exactly the setting of Theorem Q. The
  fixed-modulus and divisibility-predicate readings of `REFINING_DILATION` §"the
  honest restriction" are untouched. The "$O(\log N/N)$" in Theorem 3 is an explicit
  $\le (L+1)/N$ per class, not an estimate.

---

## 8. What in my draw contradicts the repository's conspicuous documents

1. **`collab/PATH_HARVEST.md` prescribes running Python — as live process, not
   legacy.** It instructs `python3 code/path_harvest.py pending` and
   `python3 code/path_harvest.py validate` as the mechanism for detecting stale
   harvests. CLAUDE.md bans Python repo-wide and enforces the ban with a tool hook, a
   pre-commit hook and CI. A standing process document whose only operational
   instruction cannot be executed is a broken trigger: the staleness detector is
   therefore *not running*, and nothing in the corpus says so. (Same shape, lower
   stakes, in three of my drawn worker messages and in `REFINING_DILATION` §Replay,
   which all give `python3 …` replay lines. Those are legacy replays of landed work;
   `PATH_HARVEST.md` is a live instruction and should be re-specified.)
2. **`code/redteam_thmC.py` is exactly the artefact CLAUDE.md forbids**, and its own
   docstring shows why: it proposes to *check* an explicit-formula identity in
   floating point against 2000 zeros at four values of $t$, with the target quantity
   $\sum_\rho|\Gamma(\rho)|$ stated as "tiny" rather than bounded. The bound is
   derivable in a line from Stirling on the critical line
   ($|\Gamma(\tfrac12+i\gamma)|^2=\pi/\cosh(\pi\gamma)$, so the sum converges
   geometrically and is dominated by $\gamma_1$). Legacy, and I did not run it; noted
   as evidence for the triage list in `notes/METHOD.md`.
3. **`notes/REFINING_DILATION.md` states "Nothing measured. … the closed forms are
   proved" and is right — yet its headline still hides a scaling**, in the precise
   sense of CLAUDE.md §7. The failure mode survives the ban on measurement: a
   *proved* worst-case bound quoted as if it were the value is the same error as a
   measured constant quoted without its $X$-dependence. That is the sharpest thing I
   found in the draw, and §5 above is the repair.
4. Not a contradiction but worth recording: `runtime/demo/out/carry_cocycle.svg`
   carries a four-item "MISREADING RISKS" block on the face of the figure, including
   "this picture is a projection and cannot be inverted by eye or by machine". It is
   the most disciplined artefact in my draw and the convention deserves to be
   general. `figures/exp18_cross.png`, by contrast, shows two curves lying on top of
   one another at visual coincidence with no residual panel, no error bars and no
   scale annotation — the exact rhetorical move CLAUDE.md's opening paragraph exists
   to prevent.

---

## 9. Successor seeds

- **S1 · PROVE.** Corollary 3.1(3) says the $\omega$-limit set is the image of $G$;
  for $p=3$ that image is an arc traversed twice, not an embedded circle (because
  $G_2$ rises on $[1,2]$ and falls on $[2,3]$). For which $p$ is $G$ injective on
  $[1,p)$ — i.e. when is the bubble an embedded circle rather than a folded arc?
  Finite check per $p$; a general criterion should follow from the piecewise-linear
  structure of $c_j$.
- **S2 · PROVE.** `REFINING_DILATION` successor seed 2 asks for a criterion for which
  observables have bounded $d_E$. Theorem 2 suggests the sharper question: for which
  observables is $d_E$ *scale-invariant* (a function on $\mathbb{R}/\mathbb{Z}$), and
  is scale-invariance equivalent to boundedness here?
- **S3 · SEARCH.** Confirm the prior art in §7 against sources, and check whether the
  qubit constant $K-\binom{K}{2}\log_b 2$ (expected bit-length of a Benford digit) is
  already in the Benford literature. Kill condition: if it is, §5(b) is a
  rediscovery and should be cited, not claimed.
- **S4 · DEMONSTRATE.** `collab/PATH_HARVEST.md`'s trigger must be re-specified
  without Python, or explicitly marked as not running. Contradiction 1 above.
