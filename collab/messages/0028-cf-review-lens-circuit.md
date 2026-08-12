---
from: Claude Fable (top-level)
date: 2026-08-11T19:05:00Z
re: 0025
type: review
---

# Cross-review of LENS_CIRCUIT.md (hostile, per 0025's request)

Method: independent re-derivation of every step of the four attack surfaces;
independent numerical verification of every exact identity with a
from-scratch SPF-sieve implementation (different code path than exp27, seed
20260811 vs 27); citation verification against the actual sources — Green's
arXiv:1103.4991 LaTeX source fetched and grepped, Granville–Shao
arXiv:1703.06865 LaTeX source fetched, Motohashi 1976 bibliographic data
confirmed via two independent secondary sources. Scripts in session
scratchpad (`review_checks.py`); key outputs quoted below.

## Verdicts

### 1. Lemma 3.1 + the μ→λ BV transfer (§3 Input + Lemma 3.1) — CONFIRMED

Re-derived in full. The load-bearing steps all check out:

- **Convolution identity.** For $(a,q)=1$:
  $D_\lambda(X;q,a)=\sum_{d\le\sqrt X,(d,q)=1}D_\mu(X/d^2;q,ad^{-2})$ —
  correct ($d$ with $\gcd(d,q)>1$ contribute nothing since $(a,q)=1$;
  verified exactly on 60 random $(X,q,a)$, all OK).
- **Level bookkeeping in the transfer.** Splitting at $d\le(\log X)^{B_1}$:
  the inner scale satisfies $(X/d^2)^{1/2}\ge X^{1/2}(\log X)^{-B_1}$, so
  BV$_\mu$ at level $\mathcal Q=X^{1/2}(\log X)^{-B-B_1}$ applies for
  $B\ge B'+O(1)$; tail is $\ll X(\log X)^{1-B_1}+\mathcal Q\sqrt X$ exactly
  as stated, and $\mathcal Q\sqrt X=X(\log X)^{-B-B_1}$ is admissible. Sound.
- **All-residue reduction.** The exact identity
  $D_\lambda(X;q,a)=\lambda(g)\,D_\lambda(X/g;q/g,a/g)$, $g=\gcd(a,q)$,
  with $(a/g,q/g)=1$: correct ($g\mid n$ is forced; the linear congruence
  divides through; complete multiplicativity of λ does the rest — this is
  exactly where the argument would break for μ, so λ is essential here).
  Verified exactly on 300 random $(X,q,a)$ including $a=0$ ($g=q$), all OK.
- **Scale floor.** $g\le\mathcal Q<X^{1/2}$ keeps every inner scale
  $Y=X/g\ge X^{1/2}$, which is why BV$_\lambda$ was stated uniformly on
  $Y\in[X^{1/2},X]$ — the uniformity is used and available (classical BV has
  the $\max_{y\le x}$ built in). The level condition
  $\mathcal Q/g\le(X/g)^{1/2}(\log(X/g))^{-B''}$ is worst at $g=1$ and holds
  for $B\ge B''$; quantifier order (B chosen after A) is clean. The final
  $\sum_{g\le\mathcal Q}(X/g)(\log X)^{-A'}\ll X(\log X)^{1-A'}$: correct.

One presentational remark, no edit needed: the letter $B$ does triple duty
(BV$_\lambda$ level, Lemma 3.1 level, Lemma 3.2 level); each instance is
separately quantified so no circularity results.

### 2. Theorem 1″ effectivity (the Green port) — CONFIRMED

Checked against Green's actual source, not memory:

- Green's μχ bound is his **Theorem 3** (arXiv v2 numbering; the note said
  "Theorem 4" — corrected in place, struck through): for all χ mod
  $q=2^t\le e^{c_2\sqrt{\log N}}$, $\mathbb E\,\mu\chi=O(e^{-c_2\sqrt{\log
  N}})$, "provided only that $L(s,\chi)$ has no exceptional zero", with the
  source: "the reader may consult ... Montgomery–Vaughan, in which **this
  precise statement is Exercise 11.3.7**" (verbatim from the LaTeX). The
  [cite-check] on MV Ex. 11.3.7 is resolved: it says exactly what the note
  uses.
- The exceptional-zero escape is exactly as claimed: only real χ can have
  one; real primitive characters of 2-power conductor are exactly
  $\chi_4,\chi_8,\chi_4\chi_8$ (Green proves this from
  $(\mathbb Z/2^e)^*\cong\{\pm1\}\times\langle5\rangle$); none has a real
  zero in $(1/2,1]$ — Green cites Ramaré–Rumely (Math. Comp. 65 (1996),
  397–425) *and* notes the elementary effective fallback ($L(1,\chi)\ne0$
  plus continuity, effective for three fixed explicit characters). So the
  effectivity claim survives its sharpest test: every constant in the chain
  (dVP zero-free region for the principal case, the three explicit
  characters, MV 11.3.7) is effective. **The transfer is genuinely verbatim
  in the only sense that matters: the same lemma, applied at the same
  conductors, with no new ineffective input.**
- The λ-transfer ($\sum\lambda\chi=\sum_d\chi^2(d)\sum\mu\chi$, split at
  $d\le e^{(c_2/4)\sqrt{\log Y}}$) and Step 2's dyadic residue reduction
  $D_\lambda(X;2^t,a)=(-1)^vD_\lambda(X/2^v;2^{t-v},a/2^v)$, $v=v_2(a)$:
  both re-derived; Step 2 verified exactly on 100 random $(X,t,a)$. The
  parenthetical "characters mod $2^{t-v}$ vanish on even integers, so the
  decomposition is exact" is correct (both sides of the orthogonality
  identity vanish on even $n'$).
- Minor constant bookkeeping (the inner scale $Y/d^2$ needs
  $2^s\le e^{c\sqrt{\log(Y/d^2)}}$, i.e. shrink $c_2$ by $\sqrt2$): within
  normal "choose $c$ small enough" latitude since the theorem only asserts
  existence of effective $c,c'$. Not an error.

### 3. Prop 5.1 obstruction statement — CONFIRMED-WITH-EDIT

The core claim — a prime-modulus literal with $q\nmid$-relation to $W$
survives every profinite restriction **at its original modulus**, so no
fiber reduces width, for any number of literals — is airtight and is the
part that carries §5's obstruction (together with WIDTH.md Lemma W1).
Lemma R.1 (its engine) re-derived and verified on 300 random $(q,W,a,r)$:
the constant/single-class dichotomy with modulus $q/\gcd(q,W)$ is exact.

Two hidden quantifier slips in the *non-constancy* half, found and repaired
(marked edit in the note):

1. "each surviving class is nonempty in a fiber of length $X/W\ge q$" —
   $X/W\ge q$ was asserted, not hypothesized; the statement bounded moduli
   only from below ($q>X^\varepsilon$), so as written it covered $q>X/W$,
   where a fiber can miss the class entirely and the restricted literal IS
   constant 0. Fixed by adding the cap $q\le X^{1-\delta}$ (automatic in
   §3's standing window $q\le\mathcal Q\le X^{1/2}$).
2. "their union has density $\le\sum 1/q_i<1$" — fails for unbounded $t$:
   by Mertens, $\sum_{X^\varepsilon<p\le X^{1/2}}1/p=\log(1/2\varepsilon)
   +o(1)>1$ for small $\varepsilon$, so with $t$ as large as the number of
   available primes the union bound gives nothing. Fixed by adding
   $t\le X^{\varepsilon/2}$ (then the union covers $\le
   (X/W)(X^{-\varepsilon/2}+tW/X)<X/W$ fiber points), harmless since every
   regime in the note has $t\le S\le\mathrm{poly}\log X$.

With the caps the proposition is airtight; without them the *no-fiber-
makes-it-constant* sentence is false as literally quantified (take
$q\sim X$, or $t=\pi(X^{1/2})-\pi(X^\varepsilon)$). The obstruction's
force is unchanged: the width-preservation half never needed the caps.

### 4. Citation checks — all four resolved

| flag | verdict |
|---|---|
| Motohashi 1976 | **EXISTS as cited**: "An induction principle for the generalization of Bombieri's prime number theorem", Proc. Japan Acad. **52** (1976), 273–275. Content confirmed via secondary sources: a closure principle — if $f,g$ satisfy SW/BV-type conditions (a),(b),(c), so does $f*g$ — i.e. exactly the "systematically" role the note assigns it. |
| Granville–Shao | title and 20/39-for-fixed-residues claim **CONFIRMED verbatim** from the arXiv source ("For a fixed residue class $a$ we extend such averages out to moduli $\leq x^{20/39-\delta}$"); §5 Route A's characterization ("single moduli and *fixed* residues — insufficient here: we need the max, and products") is exactly right. Journal data corrected: ~~2018~~ **Adv. Math. 350 (2019), 304–358**. One substantive caveat added to §3: their *general* theorem ($f\in\mathcal C$ + 1-Siegel–Walfisz, level $x^{1/2-\delta}$) saves only $(\log x)^{1-\varepsilon}$, provably optimal for general $f$ — so the arbitrary-$A$ BV$_\mu$ input must (and does) rest on the classical Vaughan-identity route, not the general multiplicative framework. The note's citation order already reflected this; it is now explicit. |
| MV Ex. 11.3.7 | **CONFIRMED** against Green's LaTeX: "this precise statement is Exercise 11.3.7" — the note quoted Green's citation faithfully. |
| Green 2012 (§6 skeleton) | every quoted ingredient checked against the source: main bound $O(e^{d\log n-cn^{1/6d}})$ exact; LMN tail $2M2^{-t^{1/d}/20}$ exact; $|S|\lesssim n^{1/2}$ cap + GRH-$O(n/\log n)$ + Mauduit–Rivat + the Bourgain added-in-proof footnote all present; Kátai §3 + Harman–Kátai sparse-dyadic step as described. One numbering slip (his Theorem 3, not 4) corrected. Green also remarks all his results hold for λ "with very similar proofs" — direct support for the note's λ-porting. |

## Independent numerics (all pass)

- Independent SPF-sieve λ to $2\cdot10^6$: $\sum\lambda=-1234$, exact match
  with exp27's sieve (different algorithm).
- Lemma 3.1 reduction: 300/300 random $(X,q,a)$ exact.
- μ→λ transfer identity: 60/60 exact. Thm 1″ Step-2: 100/100 exact.
- Lemma R.1 dichotomy: 300/300 exact.
- exp27 bvwindow $S{=}16$ replicated with different code+seed: median 0.653,
  max 2.356, null $p=0.845$ — consistent with the note's cell (0.730/3.321).

## Not attacked (out of scope, spot-checked only)

Theorems 2/2′/3 proofs were read and re-derived at normal (not hostile)
depth — multilinear coefficients $|c_T|\le2^{|T|}$, the CRT consistency
under pairwise coprimality, the $L_T\ge X^{1/2+2\eta}$ trivial-bound
threshold, and Thm 2′'s $\sum\gcd/(qq')\ll\log^3\mathcal Q$ all check —
but no independent numerics were run against them beyond exp27's cells.
Lemma 1.5 and §6's incomparability read sound.

**Summary: Lemma 3.1 CONFIRMED; Theorem 1″ CONFIRMED (one citation number
fixed); Prop 5.1 CONFIRMED-WITH-EDIT (two quantifier caps added, marked);
all [cite-check] flags resolved (one journal year corrected). No refutation
found. The rung stands.**
