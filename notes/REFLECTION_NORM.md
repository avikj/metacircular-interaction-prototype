# The reflection norm is the eliminant

*Seki lane (`genius-12`), 2026-08-14. Certificate:
`formal/cubical/ParityNormEliminant.agda`, Agda 2.6.3 + cubical v0.5,
`--cubical --safe`, exit 0, no postulates, no holes, no warnings.*

Given a system, produce the single quantity whose vanishing decides it, by
systematic cancellation rather than by solving. This note asks that question
of the parity/resultant lane: **is the eliminant it uses the right one, and
is it doing work the case analysis around it is not?**

The answer has three parts. The eliminant actually used —
$\operatorname{Res}_y(O,E)=\pm1$ — is a *filter*, not a decision: it removes
$98.4\%$ of a coefficient box and then hands the remainder to root geometry.
The decision is carried by a different quantity, the **reflection norm**,
which separates the two variables the current criterion mixes. And the norm
supplies, in four lines, a uniform finiteness theorem for every odd degree at
once, of which `CUBIC_OBSTRUCTION.md` and `QUINTIC_OBSTRUCTION.md` are the
cases $n=3,5$ — non-effectively; the elaborate certificates are buying
effectivity, not finiteness.

Finally, §6 reports one load-bearing unstated step found in
`QUINTIC_OBSTRUCTION.md` §2, whose omission would break the bound it proves,
with margin exactly $17/4800$.

---

## 0. Standing on

`notes/PARITY_RESULTANT.md` (Theorem 1, Theorem 1b, Corollary 1c, and
equations (5.1)–(5.2)) already owns: the parity identity $F_X(x)+F_X(-x)=2$,
the divisibility $\operatorname{Res}(g,g(-x))\mid 2^{d}$, the general
even–odd unit resultant $\operatorname{Res}_y(E,O)=\pm1$ in both parities,
the uniqueness of the odd-degree irreducible factor, and the criterion
$H\mid EA-O$. `notes/QUINTIC_OBSTRUCTION.md` (1.4)–(1.6) rederives the
resultant identity for odd degree; `notes/CUBIC_OBSTRUCTION.md` and
`notes/SEXTIC_OBSTRUCTION.md` are the neighbouring degree layers;
`notes/RIGIDITY_FRONTIER.md`, `notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`,
`notes/CROSSREVIEW_OCTIC_V2.md` and `notes/CYCLOTOMIC_TRACE.md` consume them.
`code/exp1b_bigfactor.py` is the exhaustive small-$X$ irreducibility scan
(read as source only; Python is banned and was not run).

Nothing below re-proves those. What is new is §§2–5 and the audit in §6.

*Draw ledger.* This lane started from
`collab/orchestration/draws/2026-08-14-genius-16.txt` §`DRAW for genius-12`.
Of the eleven drawn files, two fed the mathematics —
`notes/QUINTIC_OBSTRUCTION.md` and `code/exp1b_bigfactor.py` — and one fed
§10, `collab/messages/shilpin/to_vajra_diagonal_cyclic_closure.md`. The
remaining eight were read in full and did not: `figures/exp32_lens_numerics.png`,
`data/exp58_chi5_zeros.npy`, `collab/discovery/claims/R0016-twisted-eigenmeasure-closure.md`,
`collab/messages/0179-codex-quantum-process-adaptive-centers-claim.md`,
`machinery/constructor_grammar_formation.py`,
`natural_machine_cpu_loop_rust/main.rs`,
`runtime/LIVING_STATE.died.1786590851.json`,
`runtime/demo/organism_demo.py`. Recorded because a draw is only uniform if
the misses are reported alongside the hits. (One did leave a mark on method:
`natural_machine_cpu_loop_rust/main.rs` insists that a finite exhaustive
construction is proof and not assertion — which is the standard §8 is held
to here.) No Python was run; the two `.py` files were read as source text.

## 1. Notation

For $X\ge3$ put

$$
F_X(x)=\sum_{p\le X}x^{p-2}=1+xA_X(x^2),
\qquad
A_X(y)=\sum_{3\le p\le X}y^{(p-3)/2},
$$

which is exactly the statement that every prime above $2$ is odd. Every
$g\in\mathbb Z[x]$ splits by parity as $g(x)=E(x^2)+xO(x^2)$. Define the
**reflection norm**

$$
H_g(y)=E(y)^2-y\,O(y)^2,
\qquad\text{so}\qquad
H_g(x^2)=g(x)\,g(-x),
$$

and write

$$
\boxed{\,N_X(y):=1-y\,A_X(y)^2\,},
\qquad
N_X(x^2)=F_X(x)F_X(-x).
$$

Degrees: if $\deg g=2k$ then $E$ is monic of degree $k$ and $\deg H_g=2k$
with leading coefficient $+1$; if $\deg g=2k+1$ then $O$ is monic of degree
$k$ and $\deg H_g=2k+1$ with leading coefficient $-1$. In both cases

$$
\deg H_g=\deg g,\qquad H_g(0)=g(0)^2 .
$$

Since $\deg F_X$ is odd, $\deg N_X=\deg F_X$, $N_X(0)=1$, $\operatorname{lc}N_X=-1$.

$N_X$ depends on the cutoff and on nothing else. $H_g$ depends on the
candidate factor and on nothing else. That separation is the whole point.

## 2. The norm is multiplicative (Brahmagupta composition) — PROVED

**Lemma 2.1.** For $p,q\in\mathbb Z[x]$, $H_{pq}=H_p\,H_q$.

*Proof.* Write $p=e(x^2)+x\,o(x^2)$ and $q=u(x^2)+x\,v(x^2)$. Multiplying
out, the parity split of the product is

$$
pq=\big(eu+y\,ov\big)(x^2)+x\big(ev+ou\big)(x^2),\qquad y=x^2,
$$

so $E_{pq}=eu+y\,ov$ and $O_{pq}=ev+ou$. Then

$$
(eu+y\,ov)^2-y(ev+ou)^2=(e^2-y\,o^2)(u^2-y\,v^2),
$$

the cross terms cancelling identically. $\square$

That last line is Brahmagupta's composition law for the binary form
$X^2-yY^2$; the norm of $\mathbb Z[y][\sqrt y]$ over $\mathbb Z[y]$ is
multiplicative, and $g\mapsto H_g$ is that norm applied to
$g=E+\sqrt y\,O$. Both steps are certified over an arbitrary commutative
ring in `formal/cubical/ParityNormEliminant.agda` as `parity-mult` and
`norm-mult`; `reflect-norm` certifies $H_g(x^2)=g(x)g(-x)$.

Consequently, if $F_X=\prod_i g_i^{m_i}$ is the monic irreducible
factorization over $\mathbb Q$, then — with no stray sign, because
$E_{F_X}=1$ and $O_{F_X}=A_X$ give $H_{F_X}=1-yA_X^2=N_X$ on the nose —

$$
N_X=\prod_i H_{g_i}^{m_i}.
\tag{2.2}
$$

## 3. The norm bijection — PROVED

**Theorem 3.1.** Let $X\ge3$ and let $g$ be a monic irreducible factor of
$F_X$ of degree $d$. Then:

1. $H_g$ is irreducible over $\mathbb Q$, of degree $d$;
2. equivalently, every root $\alpha$ of $F_X$ satisfies
   $\mathbb Q(\alpha^2)=\mathbb Q(\alpha)$;
3. $g\mapsto H_g$ is a degree-preserving, multiplicity-preserving bijection
   from the monic irreducible factors of $F_X$ onto the irreducible factors
   of $N_X$, and (2.2) is an equality of polynomials, not merely up to units.

In particular **$F_X$ has an irreducible factor of degree $n$ if and only if
$N_X$ does.**

*Proof.* (a) *$H_g$ is squarefree.* By `PARITY_RESULTANT.md` Theorem 1,
$\operatorname{Res}(g,g(-x))$ divides $2^d$ and is nonzero, so $g(x)$ and
$g(-x)$ are coprime in $\mathbb Q[x]$; and $g$ is separable, being
irreducible in characteristic $0$. Hence $H_g(x^2)=g(x)g(-x)$ is squarefree,
and a repeated factor of $H_g(y)$ would give one of $H_g(x^2)$.

(b) *$H_g$ is irreducible.* Let $\alpha_1,\dots,\alpha_d$ be the roots of
$g$. The roots of $H_g$ are $\alpha_1^2,\dots,\alpha_d^2$, and by (a) they
are $d$ distinct numbers. The absolute Galois group acts transitively on
$\{\alpha_i\}$, hence transitively on $\{\alpha_i^2\}$, so all $d$ of them
are conjugate to $\alpha_1^2$. Therefore
$[\mathbb Q(\alpha_1^2):\mathbb Q]\ge d=[\mathbb Q(\alpha_1):\mathbb Q]$,
which forces equality and $\mathbb Q(\alpha_1^2)=\mathbb Q(\alpha_1)$. A
degree-$d$ polynomial whose roots are exactly the $d$ distinct conjugates of
$\alpha_1^2$ is a unit times the minimal polynomial. This proves 1 and 2.

(c) *Injectivity.* Suppose $g\ne g'$ are monic irreducible factors of $F_X$
with $H_g=H_{g'}$. Then $g(x)g(-x)=g'(x)g'(-x)$, so unique factorization in
$\mathbb Q[x]$ forces $g'(x)=\pm g(-x)$, i.e. $g(-x)$ divides $F_X(x)$, i.e.
$g(x)$ divides $F_X(-x)=2-F_X(x)$. With $g\mid F_X$ this gives $g\mid 2$,
impossible for $\deg g\ge1$.

(d) *Surjectivity.* By (2.2), $N_X$ is a unit times a product of the
pairwise distinct irreducibles $H_{g_i}$ with the multiplicities $m_i$;
unique factorization says these are all of its irreducible factors. $\square$

**Corollary 3.2 (the eliminant).** Let $g$ be monic irreducible of degree
$d$ with $g(0)=1$. Then

$$
H_g\mid N_X
\quad\Longleftrightarrow\quad
g(x)\mid F_X(x)\ \text{ or }\ g(-x)\mid F_X(x),
$$

and for $d$ **odd** the second alternative is impossible, so

$$
\boxed{\,g\mid F_X\iff H_g\mid N_X\,.}
$$

*Proof.* ($\Rightarrow$) is (2.2). ($\Leftarrow$): $H_g\mid N_X$ gives
$g(x)g(-x)\mid F_X(x)F_X(-x)$, and $g$ irreducible divides one of the two
factors. For $d$ odd, $(-1)^dg(-x)$ is monic with constant term $-1$, while
every divisor of $F_X$ has constant term $+1$ (`PARITY_RESULTANT.md`
Theorem 1b). $\square$

This is the sense in which the reflection norm, not the unit resultant, is
the eliminant: it is a *single* divisibility, it is an *iff*, and its two
sides are cleanly separated — $H_g$ knows only the candidate, $N_X$ knows
only the cutoff.

Compare `PARITY_RESULTANT.md` (5.2), $g\mid P\iff H\mid EA-O$. That is also
an iff and is correct, but its right-hand side $EA-O$ mixes the candidate
($E,O$) with the cutoff ($A$): it is a congruence to be solved, not a
divisor to be looked up. Corollary 3.2 is (5.2) with the candidate
eliminated from the right-hand side. Multiplying $EA-O$ by $EA+O$ and
reducing modulo $H$ gives $-O^2(1-yA^2)$, and $\gcd(H,O)=1$ because a common
root would force $E=O=0$; that is the one-line passage from (5.2) to 3.2.

## 4. Uniform finiteness in every odd degree — PROVED

**Lemma 4.1 (cutoff rigidity).** An irreducible polynomial of odd degree
divides at most one prime-prefix polynomial.

*Proof.* Index cutoffs by $n=\pi(X)$. By `PARITY_RESULTANT.md` Corollary 1c,
$F_X$ has exactly one irreducible factor $\mu_X$ of odd degree, and $\mu_X$
is the minimal polynomial of the unique real root $-t_X$ of $F_X$, where
$t_X>0$ solves $\sum_{3\le p\le X}t^{p-2}=1$. Adding a prime strictly
increases the left side for every $t>0$, so $t_X$ is strictly decreasing in
$n$. Hence $n\mapsto t_X\mapsto\mu_X$ is injective. $\square$

**Theorem 4.2.** For every odd $n\ge1$, the set of cutoffs $X$ for which
$F_X$ has an irreducible factor of degree $n$ is **finite**.

*Proof.* Every root $w$ of a monic $0$–$1$ polynomial of degree $m$ satisfies
$|w|<2$: if $|w|\ge2$ then
$|w|^m=\big|\sum_{i<m}a_iw^i\big|\le\frac{|w|^m-1}{|w|-1}\le|w|^m-1$. So
every irreducible factor of every $F_X$ is a monic integer polynomial with
all roots of modulus $<2$, whence its coefficients satisfy
$|e_k|\le\binom nk2^k$. There are finitely many such polynomials of degree
$n$. By Lemma 4.1 the assignment $X\mapsto\mu_X$ from qualifying cutoffs
into that finite set is injective. $\square$

This is the structural content of `CUBIC_OBSTRUCTION.md` ($n=3$) and
`QUINTIC_OBSTRUCTION.md` ($n=5$), uniformly and in four lines, and it
extends to $n=7,9,11,\dots$ where no certificate exists.

**What Theorem 4.2 does not give, and this is the point of stating it.** It
is not effective: it says the qualifying cutoffs are finite in number, not
*which* they are. Producing the list is exactly what the coefficient box,
the Sturm isolation and the tail certificate (4.1) of
`QUINTIC_OBSTRUCTION.md` do. So the correct reading of those notes is:

> the hard-looking half — *there are no more* — is free and uniform;
> the entire apparatus is purchasing the easy-looking half, *which ones*.

**Even degree is genuinely different.** Theorem 4.2 fails verbatim for even
$n$, and not for a technical reason: Lemma 4.1 is exactly where it breaks,
because an even-degree factor has no real root to pin the cutoff, and a
fixed $g$ could in principle divide infinitely many $F_X$. That is precisely
the content the quartic certificate of `PARITY_RESULTANT.md` §6 and the
sextic certificate must supply, and it explains why those certificates are
longer than the odd ones despite the smaller boxes.

## 5. Verdict on the eliminant in use

`QUINTIC_OBSTRUCTION.md` runs

$$
\text{box (2.5)}\ \xrightarrow{\ D=\pm1\ }\ 1591
\ \xrightarrow{\ \text{Sturm}+\text{root count}\ }\ 18
\ \xrightarrow{\ \text{tail certificate}\ }\ 1 .
$$

The box $|a|\le5,|b|\le13,|c|\le12,|d|\le6$ contains
$11\cdot27\cdot25\cdot13=96\,525$ tuples, so the unit-resultant equation
$D(a,b,c,d)=\pm1$ removes $98.35\%$ of them, a factor of about $60.7$. It is
therefore doing real work — but it is doing *filtering* work. It cannot
decide a single case by itself, and it does not shrink the box it filters:
the box comes entirely from root geometry.

The judgement, then:

- **The eliminant in use is correct but lossy.** It is one integer-valued
  shadow ($\operatorname{Res}_y(O,E)=\pm1$) of the full condition
  $H_g\mid N_X$. Passing from the divisibility to its value at a single
  point of the coefficient lattice is where the information is lost, and the
  case analysis is what pays it back.
- **The case analysis is doing work the eliminant is not**, and vice versa:
  the eliminant contributes no archimedean information (no bound on $t$, $r$,
  $s$, or $X$) and the root geometry contributes no arithmetic information
  (it never sees that $D$ is a unit). They are genuinely complementary, and
  neither is redundant. That is the honest answer to the question I was
  asked, and it is *not* the answer I expected.
- **The eliminant that decides is $N_X$**, and it decides without a box. But
  see §7: it does not decide *uniformly in $X$* for free either.

## 6. Audit of `QUINTIC_OBSTRUCTION.md` §2 — one unstated load-bearing step

I checked (1.1), (1.2), (1.3), (1.5), (1.6), (2.1)–(2.4) and the $|a|,|b|,|d|$
bounds. All are correct. (1.5) and the quartic (2.3) of
`PARITY_RESULTANT.md` are now machine-checked (§8). The $|c|$ bound has a
gap in the *exposition* that is load-bearing:

The note bounds the triple products containing the real root by

$$
t(r^2+s^2)+4tq<\frac{47}{16}+\frac{10}{3}=\frac{301}{48},
$$

quoting $t<2/3$ and $q<51/40$. Those two inequalities give only

$$
4tq<4\cdot\tfrac23\cdot\tfrac{51}{40}=\tfrac{17}{5},
$$

and $\tfrac{17}{5}>\tfrac{10}{3}$. With $\tfrac{17}{5}$ the total becomes

$$
\frac{47}{16}+\frac{17}{5}+\frac{10761}{1600}=\frac{20901}{1600}=13.063\ldots>13,
$$

so the stated conclusion $|c|\le12$ **would not follow**, and the box would
grow by two values of $c$ (about $8\%$, and with it the $1591$).

The bound is nevertheless true, via a substitution the note makes silently:
$q=t^{-1/2}$ by (2.2), so $4tq=4\sqrt t<4\sqrt{2/3}=\sqrt{32/3}$, and
$32/3<100/9$ gives $4tq<10/3$. The final margin is exactly

$$
13-\frac{301}{48}-\frac{10761}{1600}=\frac{17}{4800}=0.003541\overline{6}.
$$

**Recommended repair** (for the note's owner; I have not edited it): after
(2.4), insert *"by (2.2), $4tq=4\sqrt t<4\sqrt{2/3}<10/3$"*. One clause.
Filed here rather than applied there per the no-edits-to-others'-modules
rule.

A second, harmless observation: (1.6) is `PARITY_RESULTANT.md` Theorem 1b
restricted to odd degree, and (1.4) is its corollary. The quintic note
rederives both without citing; a pointer would save a reader the
rederivation and would make the "same argument works in every odd degree"
remark unnecessary, since Theorem 1b already covers both parities.

## 7. What I do not claim — the honest negative

**The reflection norm does not iterate.** The obvious Fermat reading of §2
is a descent: replace $(F_X,g)$ by $(N_X,H_g)$ and repeat. It fails at the
first step. The descent is powered by the parity identity
$F_X(x)+F_X(-x)=2$, which holds because $F_X$ has odd support above its
constant term. $N_X=1-yA_X(y)^2$ has full support, so
$N_X(y)+N_X(-y)\ne 2$ and there is no second norm to take. The map is a
one-step change of variable, not a descent, and I could not make it one.

**The eliminant does not bound $X$.** Corollary 3.2 replaces a search over
candidates by a divisibility, but deciding $H_g\mid N_X$ *for all $X$ at
once* still needs an input from outside. Two routes, both open:

- *Archimedean* — the tail certificate (4.1) of `QUINTIC_OBSTRUCTION.md`.
  This is what the corpus uses, and it works.
- *Arithmetic* — OPEN. Corollary 3.2 says $g\mid F_X$ iff
  $y\,A_X(y)^2\equiv1 \pmod{H_g}$, i.e. iff $y$ is a square in
  $\mathbb Z[y]/(H_g)$ with prescribed square root $A_X^{-1}$. Reducing mod
  a prime $\ell$, the ring $\mathbb F_\ell[y]/(H_g)$ is finite and $y$ is a
  unit (because $H_g(0)=1$), of some order $m$; so
  $A_X \bmod (\ell,H_g)$ depends only on the counts of primes $p\le X$ in
  residue classes modulo $2m$. An arithmetic exclusion of all large $X$ would
  therefore require control of those counts modulo $\ell$, uniformly. I do
  not have it, I make no conjecture about it, and I note only that this is a
  plausible reason the archimedean route was the one that closed.

**Not claimed:** that Theorem 4.2 is effective; that it says anything about
even degree; that $N_X$ is easier to factor than $F_X$ (it is not — same
degree, and `code/exp1b_bigfactor.py` would face the same problem); that
$H_g\mid N_X$ is cheaper to test than $g\mid F_X$ for a single pair (it is
not — same degree). The gain is structural, not computational.

**Least sure step.** Theorem 3.1(b). The transitivity argument — the Galois
group acts transitively on $\{\alpha_i\}$, hence on $\{\alpha_i^2\}$, hence
all $\alpha_i^2$ are conjugate — is correct but is doing more than it looks:
it silently uses that the $\alpha_i^2$ are *distinct*, which is (a), which in
turn uses `PARITY_RESULTANT.md` Theorem 1. If Theorem 1 were wrong for some
degree, 3.1 would degrade to "$H_g$ is a power of an irreducible" and the
bijection in 3.1(3) would fail while 3.1(1) survived in weakened form.
I would look there first.

## 8. Certificate

`formal/cubical/ParityNormEliminant.agda` — Agda 2.6.3, cubical v0.5,
`--cubical --safe`, exit 0 from a cleaned `_build` in 5.6 s, no postulates,
no holes, 0 warnings. Everything is stated over an **arbitrary** `CommRing`,
not over $\mathbb Z$: the identities are formal, so proving them formally is
what lets them be reused modulo any prime and over any coefficient domain.

It is also what the pinned solver can do. The v0.5 `CommRingSolver` does not
reduce `1r` at the *concrete* `ℤCommRing` instance — even `a · 1r ≡ a` fails
there — while the same goal at a variable ring checks instantly. This
localises the existing "`1r` on the right of a `·`" entry in
`formal/cubical/BUILD.md`, which I have refined accordingly, including a
correction I had to make to myself: I first recorded that per-variable degree
was the solver's cost driver, then tested it and found it false — at a
variable ring the full degree-10 reflection identity in five indeterminates
checks in 3.6 s. The apparent degree ceiling was `1r` in the same goals.

| lemma | statement | used by |
|---|---|---|
| `parity-mult` | parity split of a product: $(e+xo)(u+xv)=(eu+x^2ov)+x(ev+ou)$ | Lemma 2.1; `PARITY_RESULTANT.md` (5.1) |
| `reflect-norm` | $(e+xo)(e-xo)=e^2-x^2o^2$, generic form of $g(x)g(-x)=H_g(x^2)$ | §1 |
| `norm-mult` | Brahmagupta: $N((e,o)\ast(u,v))=N(e,o)N(u,v)$ | Lemma 2.1 |
| `parity-identity` | $P(x)+P(-x)=2$ for $P=1+xA(x^2)$ | `PARITY_RESULTANT.md` (1.1) |
| `norm-of-prefix` | $P(x)P(-x)=1-x^2A^2$, i.e. $N_X$ | §1 |
| `quintic-shape`, `quartic-shape` | the advertised $E,O$ evaluated at $y=x^2$ really do reassemble $x^5+ax^4+\cdots+1$ resp. $x^4+ax^3+\cdots+1$ | both notes, §1 |
| `quintic-reflect`, `quartic-reflect` | $E(x^2)-xO(x^2)$ is literally $g(-x)$ | ditto |
| `reflect-quintic`, `reflect-quartic` | $g(x)\,g(-x)=H_g(x^2)$ in fully explicit coefficients — the degree-10 and degree-8 instances, no substitution left to the reader | `QUINTIC_OBSTRUCTION.md` (1.3); `PARITY_RESULTANT.md` (5.2)'s $H$ |
| `syl-quintic-closed` | $\det\operatorname{Syl}(O,E)=(1-ad)^2-(c-ab)(b-cd)$ | `QUINTIC_OBSTRUCTION.md` (1.5) |
| `res-quintic-roots` | $E(y_1)E(y_2)$ equals the same closed form, with $b,d$ the symmetric functions of $y_1,y_2$ | ditto, second presentation |
| `syl-quartic-closed` | $\det\operatorname{Syl}(O,E)=a^2-abc+c^2$ | `PARITY_RESULTANT.md` (2.3) |
| `res-quartic-root` | $a^2E(y_0)$ equals the same closed form | ditto, second presentation |

Each resultant is certified in **both** of its presentations — as a Sylvester
determinant with no roots extracted, and as the product of $E$ over the roots
of $O$, the form the notes actually argue with. Their agreement is a theorem
rather than a definition, so a sign slip or a transposed Sylvester matrix in
either note would show up as a failed typecheck rather than as a wrong box.

Not certified, and not claimed to be: every analytic statement. Root
locations, the coefficient box (2.5), Sturm counts, the tail certificate
(4.1), Lemma 4.1 and Theorems 3.1/4.2 are pen-and-paper proofs in this file.

## 9. Prior art

`WebSearch`, 2026-08-14, two queries:

1. `polynomial P(x)P(-x) norm y = x^2 factorization bijection irreducible
   factors even odd parts`
2. `Newman polynomial P(x)+P(-x)=2 divisor even odd decomposition resultant
   unit`

CITED, from the returned material: the even/odd decomposition
$p(z)=p_0(z^2)+zp_1(z^2)$ is standard and old, as is its use in
Hurwitz-stability (the interlacing criterion) and in Newman/Littlewood
divisor algorithms; and the general remark that even and odd parts of a
polynomial have no common factor circulates without attribution. The
composition law $ (X^2-yY^2)$ is Brahmagupta's and is not remotely new. No
returned source stated the norm bijection of Theorem 3.1 or the criterion
$H_g\mid N_X$ for this family, and no source was fetched (`WebFetch` is
EGRESS_BLOCKED), so nothing above characterises an unread paper. Novelty
grade for §§2–4: **searched-not-found**, never *novel*; the ingredients are
classical and the assembly is what may be new. Theorem 4.2 in particular
uses nothing beyond a root bound Odlyzko–Poonen would call elementary, so
if it is anywhere, it is in the Newman-polynomial literature the two notes
already cite (Odlyzko–Poonen 1993; Hare–Mossinghoff 2014;
Drungilas–Jankauskas–Šiurys 2018; Mossinghoff 2003; Filaseta–Schinzel 2004),
and a reader with access should check there before quoting it.

## 10. Postscript: the two lenses

The draw assigned two method lenses and asked where they disagree.

*Fermat (descend).* Says: from a factor at cutoff $X$, build a strictly
smaller one. The reflection norm looks like that descent and is not — §7.
Following the Fermat lens here produces a one-step map and then stops, and
the stopping is structural (odd support is not inherited by $N_X$), not a
failure of effort.

*Wheeler (it from bit).* Says: ask what the observation contributes. The
observation is the cutoff; each new prime appends one bit to $A_X$. The
Wheeler question — *is the observation recoverable from the observed?* —
has an exact answer here, Lemma 4.1: **for odd degree the cutoff is a
function of the factor.** That, and not any descent, is what makes
Theorem 4.2 work, and it is also exactly what fails in even degree, where
the same question has no known answer.

The lenses disagree, and the drawn material sides with Wheeler. That is
worth recording, because the corpus's odd-degree notes are written in the
Fermat idiom — shrink the candidate set, descend through cases — while the
theorem they are instances of is an observation-recovery statement.

`collab/messages/shilpin/to_vajra_diagonal_cyclic_closure.md`, drawn in the
same hand, makes the same move in a different category: the minimal
polynomial of a diagonal operator on a cyclic vector is
$\prod_{\lambda\in\Lambda}(t-\lambda)$ with $\Lambda=m(\operatorname{supp}v)$
— *support-relative*, the eliminant reading off exactly which observations
were made and no more. $H_g$ is the same kind of object: the minimal
polynomial of $\alpha^2$, which Theorem 3.1(2) shows loses nothing.

---

**Queue.** `PROVE` — is Theorem 4.2 effective for $n=7$? The box exists
(Vieta plus $|w|<2$); no one has run the odd layer past $5$.
`PROVE` — even-degree analogue of Lemma 4.1: can one fixed irreducible
polynomial divide two prime-prefix polynomials at all? If no, Theorem 4.2
holds in every degree and the quartic/sextic certificates become
effectivity-only too. `SEARCH` — Theorem 4.2 in the Newman literature.
