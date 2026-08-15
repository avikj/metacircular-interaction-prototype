---
id: 0756-seed155-prime-pair-kernel
from: seed155 (Hardy × the habit of checking whether a "new identity" is a change of variables before reading further)
date: 2026-08-15
kind: verification of an owner artifact — D0018 §G, the prime-pair kernel, as its own triage (§J6) requests
subject: "The central identity is CORRECT — summand and both exponents — but only once its index set is supplied: (w,r) run over the coupled half-integer lattice L = {2w,2r in Z, w-r in Z, w >= |r|+1}, NOT over Z^2. Read over Z^2 it is false and loses every odd shift (m=2,n=3 is a witness). No Jacobian, no factor 2, diagonal counted once. The two extraction claims carry NO information: the (sum, half-difference) map is a bijection and the transform is invertible, so K and the array Lambda(a)Lambda(b) determine each other (Thm 3.4) — a clean negative, as expected. Both are also stated too strongly: 'Goldbach = [w^N]K' is positivity of psi_2(N), equivalent to 'N is a sum of two prime POWERS', a one-way implication dressed as an equivalence (the D0017 §F pattern again); the grading is by 2w so the functional is w=N/2, not w=N. 'twin primes = [r^1]K' as non-vanishing already holds at w=4. The gamma factor IS missing: M[P](s) = Gamma(s)(-zeta'/zeta(s)), recorded as correction C1, and it is not cosmetic (wrong polar divisor, wrong vertical growth). Categorification: over Z it is (c), an analogy with no current content, with an obstruction at the first step — log p is transcendental, hence not a Frobenius trace; over F_q[T] it is (a), a named programme (Sawin-Shusterman, Keating-Rudnick, Keating-Roditty-Gershon). Corpus: notes/DSIDE.md §3 already owns this object with an exact decomposition and a convergence ledger; §G is strictly behind it and contradicts nothing."
predecessors:
  - D0018-owner-third-transmission-2026-08-14 (owner artifact, §G and §J6)
touches:
  - notes/PRIME_PAIR_KERNEL_VERIFIED.md (new)
  - collab/messages/0756-seed155-prime-pair-kernel.md (new)
---

# What was verified, and how

Hand derivation only. No script written or run, no numerical value computed, no
constant fitted, no Agda/Lean authored. Full statement/proof structure in
`notes/PRIME_PAIR_KERNEL_VERIFIED.md`.

Credit: $P$, $Z$, $\mathcal K$ and the four claims are the human owner's, from
`collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` §G. Its own
triage §J6 asked for exactly this: verify as elementary rearrangement rather
than cite as insight. It is one, and the note says so.

## 1. The identity: correct, index set missing

$$L:=\{(w,r)\in(\tfrac12\mathbb Z)^2:\ w-r\in\mathbb Z,\ w-r\ge1,\ w+r\ge1\}
=\{w,r\text{ both integral or both half-odd},\ w\ge|r|+1\}.$$

$(m,n)\mapsto((m+n)/2,(n-m)/2)$ is a **bijection** $\mathbb Z_{\ge1}^2\to L$.
Hence for $t>0$, absolutely convergently,
$Z(t,\theta)=\sum_{(w,r)\in L}\Lambda(w-r)\Lambda(w+r)e^{-2tw}e^{2\mathrm ir\theta}$.
No Jacobian (bijection of *discrete* sets — importing the determinant $\tfrac12$
would be the error), no factor of $2$, diagonal $r=0$ present exactly once with
$\mathcal K(w,0)=\Lambda(w)^2$. Read over $\mathbb Z^2$ the identity is **false**:
it drops every pair with $m+n$ odd, i.e. every odd shift; $m=2,n=3$ witnesses.

## 2. The extractions carry nothing, and are stated too strongly

Grading is by $2w$ and $2r$; §G's $[w^N]$, $[r^1]$ do not carry the $2$.

- $[w^N]$, corrected, is $\psi_2(N)=\sum_{a+b=N}\Lambda(a)\Lambda(b)$ at $w=N/2$.
  $\psi_2(N)>0\iff N=p^j+q^k$ — **weaker** than Goldbach; the equivalence with
  Goldbach is not available (an announced $\Rightarrow$ presented as $\Leftrightarrow$;
  same failure mode as D0017 §F).
- $[r^1]$ is the $\theta$-Fourier coefficient, returning
  $e^{-2t}\sum_n\Lambda(n)\Lambda(n+2)e^{-2tn}$. **Non-vanishing is not the
  conjecture** — it holds at $w=4$. The right functional is infinitude / blow-up
  as $t\to0^+$, and even then it is the prime-power statement.
- **Theorem.** $Z$ and $(\Lambda(a)\Lambda(b))_{a,b}$ determine each other
  (Fourier uniqueness + identity theorem for Laplace series). A bijection of
  index sets composed with an invertible transform creates and destroys nothing.
  **Verdict: change of variables, no information.**

The one thing it does make visible: $Z=|P|^2\ge0$, so the shift-indexed smoothed
autocorrelations are positive-definite in the shift. That is Wiener–Khinchin,
standard, already how the circle method sees it — recorded so the negative is
not overstated.

## 3. Correction C1 — the gamma factor is missing

$\mathcal M[P](s)=\Gamma(s)\bigl(-\zeta'/\zeta(s)\bigr)$ for $\operatorname{Re}s>1$.
Not cosmetic: $\Gamma$ carries poles at $s=0,-1,-2,\dots$ and $e^{-\pi|t|/2}$
decay in vertical strips, so any continuation or contour shift built on the
printed identity inherits the wrong polar divisor and growth. Separately,
$\xi(s)=\xi(1-s)$ is true but is about $\zeta$; there is no functional equation
of the shape $\mathcal M[P](s)\leftrightarrow\mathcal M[P](1-s)$, and the
antisymmetry belongs to $\xi'/\xi$, which differs from $-\zeta'/\zeta$ by the
archimedean terms.

## 4. Categorification — the honest verdict, not a forced (a)

Over $\mathbb Z$: **(c)**, and with a reason rather than an absence. Traces of
Frobenius on $\ell$-adic representations are algebraic; $\Lambda(p^k)=\log p$ is
transcendental. $\Lambda$ is trace-*derived* — one logarithmic derivative away
from the coefficients that are traces — and no construction categorifying that
derivative was found. Named neighbours that are real: Weil's explicit formula;
Connes (1999) for an operator trace reading of it; Bogomolny–Keating
(Nonlinearity 9, 1996) deriving $n$-point zero correlations from Hardy–Littlewood,
with the reverse direction in the Keating school. None answers §G's question.

Over $\mathbb F_q[T]$: **(a)**, a named programme — Sawin–Shusterman
(arXiv:1808.04001), Keating–Rudnick, Keating–Roditty-Gershon (arXiv:1505.01970),
Carmon–Rudnick — because there $\log p$ becomes $\deg(P)\log q$ and $\deg$ is a
cohomological grading. That is exactly the step unavailable over $\mathbb Z$.

Only rendered HTML and search abstracts were used. **No PDF was decoded and no
claim rests on one.**

## 5. Corpus

`notes/DSIDE.md` §3 already owns this object under a Cesàro rather than Laplace
weight, with an unconditional exact decomposition, the RH error term, the
zero-pair expansion, and an explicit theorem/conjecture ledger. §G duplicates
the object, contradicts nothing, and is strictly behind it.
`notes/CENTER_BOUNDED_PRIME_PAIR.md` already uses the centre coordinate
$w=(p+q)/2$ — §G's coordinates are the corpus's coordinates already.
`notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md` is the precedent for §4: a
pair weight that looked like a form factor and was not. Nothing in `notes/`
connects to §G's $D_g/J_g$ display, which specifies no group action and so has
nothing yet to verify.

$\chi_\alpha$ (§J5) is untouched; nothing here is measured or fitted.

## 6. Scope

$t>0$ throughout. The information theorem is about data, not difficulty — the
centre coordinate is a *good* change of variables, it is just not progress. The
obstruction in §4 rules out the Deligne-shaped categorification only. Absence of
prior art is my failure to find it, not a theorem.
