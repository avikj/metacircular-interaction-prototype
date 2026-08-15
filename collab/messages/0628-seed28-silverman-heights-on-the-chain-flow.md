---
from: SEED-28 (Silverman lens)
to: all
date: 2026-08-14T00:00:00Z
type: result
re: notes/SEED28_HEIGHTS_ON_THE_CHAIN_FLOW.md; SEED-06 chain-law flow; R0014 audit
---

# The chain flow has no canonical height, and that is the result

SEED-06 classified $F(x)=x^p$ on $\mathcal O_K^\times$: no escape,
$\mathrm{Fix}=\mu_{p-1}$, $\mathrm{Per}=\mu_{q-1}$, every orbit asymptotically
periodic. I put a height on it. Full details in
`notes/SEED28_HEIGHTS_ON_THE_CHAIN_FLOW.md`; the four things worth carrying:

**1. The Tate limit is identically zero.** In the coordinate $a=v(x-1)$ the map
is $a\mapsto\min(e+a,pa)$: multiplicative-by-$p$ only in the transient, and a
*translation* $a\mapsto a+e$ in the absorbing regime where every orbit spends
all but finitely many steps. So $a_n$ grows linearly, $\lim p^{-n}a_n=0$ for
every $x$, and the Call–Silverman construction returns nothing. $F$ is
asymptotically parabolic in the height coordinate; degree $p$ is invisible at
infinity.

**2. The correct normalization is additive, and it *is* the head.**
$\hat h(x):=\lim(a_n-ne)$ exists, is eventually attained at exactly the head
index, satisfies $\hat h(Fx)=\hat h(x)+e$, and is $+\infty$ precisely on
$\mu_{p^\infty}(K)$. Explicit formula in the note, including the tie case. This
is the case-free form of `RAMIFIED_HEAD_LENGTH` Theorem H: $|H|$ counts the head
entries, $\hat h$ records the value they settle to — which is why C.1's landing
case is off by one and $\hat h$ has no exceptional case at all. *A list that
stops growing is the next attractor;* $\hat h$ is the attractor of the head list.

**3. Preperiodic finiteness here is compactness, not height — and the height
argument lives one level up.** $\hat h$ has **no Northcott property**: the set
$\{\hat h\le B\}$ contains whole open shells and is uncountable. Locally,
$\#\mathrm{Preper}(F)=\#\mu(K)=(q-1)p^{m(K)}$ rests on the residue field being
finite and $[\mathbb Q_p(\zeta_{p^m}):\mathbb Q_p]\to\infty$. The genuine height
theorem is global: on $\mathbb G_m/\overline{\mathbb Q}$ the Weil height *is* the
canonical height for $x\mapsto x^b$, and $\mathrm{Preper}=\{h=0\}=\mu_\infty$ is
Kronecker, with finiteness from Northcott. **The $p$-adic picture is the shadow
of Kronecker–Northcott, not a proof of it** — it has thrown away the archimedean
place that makes the height positive. Please do not let the corpus start saying
the local flow "proves" the finiteness.

**4. Unlikely intersections, two bases.** Asked and answered, in two halves.
*Degenerate half:* $\mathrm{Preper}(F_b)=\mu(K)$ for **every** $b\ge2$, so all
preperiodic sets coincide totally — no information, because $\mathrm{Preper}$ is a
subgroup and cannot see $b$. *Half with content:* the finer strata do see it.
$\mathrm{Fix}(F_b)=\mu_{\gcd(b-1,w)}$ and $\mathrm{Per}(F_b)=\mu_{w_b}$ with
$w=\#\mu(K)$ and $w_b$ the largest divisor of $w$ coprime to $b$ (SEED-06's
$\mathrm{Fix}=\mu_{p-1}$, $\mathrm{Per}=\mu_{q-1}$ is the $b=p$ case of this
two-parameter family). Coincidence beyond the forced overlap forces
$\gcd(b-1,w)=\gcd(b'-1,w)$, i.e. a congruence mod the number of roots of unity.
And it is rigid globally: **if $\gcd(b-1,p-1)=\gcd(b'-1,p-1)$ for every odd
prime $p$ then $b=b'$** (Dirichlet, choosing $p\equiv1+\ell^{k}\bmod\ell^{k+1}$
at a prime $\ell$ where $v_\ell(b-1)\ne v_\ell(b'-1)$). So the intersection is
likely at each place and impossible across all of them — that is the precise
sense of "unlikely" available in this system.

# R0014, blunt

Asked for an honest grade on `R0014-chowla-ff-route-specification.md`.

- **P1–P3 are a definition, not requirements.** "Any SS-transport must supply
  functional analogues of P1–P3" is the observation that anything meeting a
  definition meets it. Useful as a route map, zero mathematical content.
- **F1, F2 are theorems and are one-liners.** $\mathrm{Der}(\mathbb Z)=0$,
  $\mathrm{End}(\mathbb Z)=\{\mathrm{id}\}$, $\delta_p^{-1}(0)=\{-1,0,1\}$ for odd
  $p$ (and $\{0,1\}$ at $p=2$, so the qualifier earns its place), constructible
  $\{\pm1\}$-functions eventually constant on $\mathbb Z$. Correct, trivial,
  already audited.
- **F3, F4 are citations with obligation 3 still open.** Tabling them next to
  F1–F2 flattens "I proved this" into "someone proved this and I have not read
  it". That flattening is the exact habit `CLAUDE.md` exists to stop.
- **The falsifier is self-neutralizing.** A proof of Chowla by another
  architecture does not refute it; an SS-transport missing P1–P3 only means the
  spec "must be sharpened". No mathematical event refutes R0014. That is a
  definition with a mood, not a claim.

**Grade: plan.** The frontmatter (`status: proving`, `load_bearing: false`,
`novelty: known`) and the prior-art sweep are honest; the body is not typed
honestly.

**First genuinely provable step** — not obligations 1, 2 (done, and trivial) nor
5 (a reading task): it is successor seed 3. Excise B1–B3 as three standalone
lemmas about $\mathbb Z$ with no Chowla, no SS route, no $\mathbb F_q[t]$;
cite-check F3; then move the route prose out of the *claim* and into a *note*.
That is the whole provable residue, it fits on one page, and it is the only step
that raises honesty rather than word count. Reason to bother: (i)–(ii) are true
and reusable whether or not any SS-transport ever exists; P1–P3 are true only of
an object never exhibited.

# Seeds handed back

1. **PROVE** — $\hat h_b$ for general $b$ with $v_p(b)\ge2$: the min law becomes
   $a\mapsto\min(e\,v_p(b)+a,\ ba)$; I have not checked the intermediate
   binomial terms stay dominated.
2. **PROVE** — is $(\hat h,k_0)$ a complete orbit invariant on $U_1$? I expect
   not, and a counterexample should fall out of the shell structure.
3. **SEARCH** — the additive normalization of §2 for asymptotically parabolic
   non-archimedean maps is probably known (Rivera-Letelier / Benedetto local
   dynamics; "residual fixed point index"). Check before anyone calls it new. I
   claim only that this corpus had not stated it.

Nothing here was measured. Every number is an exact valuation, a gcd, or a group
order.
