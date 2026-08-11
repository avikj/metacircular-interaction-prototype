# Nonic obstruction: exact certificate

For

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

the integrated exact certificate `code/exp44_nonic_certificate.py` proves:

> **Theorem.** For every real $X\ge2$, the prime-prefix polynomial $F_X$
> has no irreducible factor of degree nine.

This is a computer-assisted exact theorem.  No claim of literature novelty is
made here.

## 1. Necessary root geometry

An irreducible nonic factor may be taken monic.  Its constant term divides
$F_X(0)=1$.  Constant term $-1$ would force a positive real root, whereas
$F_X(x)>0$ for $x>0$; hence its constant term is $+1$.  Write

$$
g=x^9+ax^8+bx^7+cx^6+dx^5+ex^4+fx^3+hx^2+jx+1.
$$

For $X\ge3$,

$$
F_X(-s)=1-\sum_{3\le p\le X}s^{p-2}
$$

is strictly decreasing for $s>0$.  Thus $F_X$, and therefore $g$, has one
negative real root $-t$ and no other real root.  Degree nine forces $X\ge11$.
The odd-support root lemma gives

$$
\lambda=\frac{\sqrt5-1}{2}<|z|<2
$$

for every root of a factor, and exact endpoint evaluation sharpens the real
root to

$$
\frac{309}{500}<t<\frac{79}{125}.
$$

The complete convex-root derivation in `notes/NONIC_DISCOVERY.md` gives

$$
|a|\le10,\ |b|\le46,\ |c|\le116,\ |d|\le181,
\quad |e|\le180,\ |f|\le115,\ |h|\le45,\ |j|\le10.
$$

## 2. Parity resultant and Graeffe bounds

Split

$$
g(x)=E(x^2)+xO(x^2),
$$

where

$$
E=1+hy+ey^2+cy^3+ay^4,
\qquad
O=j+fy+dy^2+by^3+y^4.
$$

Since $F_X(x)+F_X(-x)=2$, the parity-resultant theorem forces

$$
\operatorname{Res}(E,O)=\pm1.
$$

Direct expansion of $G=E^2-yO^2$ and the squared-root majorant give the
ascending coefficient bounds

$$
\bigl(|[y^1]G|,\ldots,|[y^8]G|\bigr)
\le(14,85,270,493,516,300,95,15).
$$

The reversal is essential: the leading-side elementary-symmetric vector is
$(15,95,300,516,493,270,85,14)$, while $[y^k]G$ corresponds to $e_{9-k}$.
The exponent-addressed contract prevents these orders from being conflated.

## 3. Complete finite census

`code/exp37_nonic_discovery.py` and its generated C++ enumerator exhaust the
proved box in 441 $(a,j)$ shards.  The exact ledger is

$$
\begin{aligned}
82{,}823& &&\text{endpoint states},\\
830{,}998{,}061& &&(c,d)\text{ states},\\
191{,}960{,}552{,}091& &&\text{raw }(c,d,f)\text{ states},\\
5{,}956{,}908{,}483& &&\text{elimination survivors},\\
835{,}048{,}914& &&\text{scalar survivors},\\
226{,}514{,}912& &&\text{full Graeffe survivors},\\
22{,}077& &&\text{unit-resultant candidates}.
\end{aligned}
$$

Their sorted tuple digest is

```text
ce9a01ba00db63b6a55b03348d68d4c1e7463c2a7a021077618b83f4bca415d9
```

A hostile audit reran all 441 shards without checkpoint reuse, reproduced
every per-shard and aggregate count, independently recomputed the early loop
counts, and verified every emitted resultant using rational Gaussian
elimination.  The signed-128-bit determinant is safe: Sylvester row norms are
below $220$, so each Bareiss numerator is below
$2\cdot220^{14}<2^{113}$; endpoint arithmetic is below $2^{92}$.

## 4. Exact root and irreducibility partition

Exact Sturm and Routh--Cayley filtering gives

$$
22{,}077\longrightarrow6{,}082\longrightarrow768
\longrightarrow767.
$$

The stages mean: exactly one real root; the relaxed rational annulus
$617/1000<|z|<20001/10000$; and finally all nine roots strictly inside
$|z|<2$.  No Routh table is degenerate.  The strict set digest is

```text
6a10b7a45616332efb7b51aee6ec51e65c7b6f412e0b2b3770f63f3264c68c2b
```

The 767 tuples partition exactly as follows:

- 754 have degree-nine Rabin irreducibility witnesses over finite fields;
- 12 have explicit integral factorization witnesses;
- one is $x^9+4x^3+1$.

For the singleton,

$$
6^9+4\cdot6^3+1=10{,}078{,}561
$$

is prime, and the coefficients are its base-six digits.  The arbitrary-base
Cohn theorem therefore proves irreducibility: Brillhart--Filaseta--Odlyzko,
*Canadian Journal of Mathematics* **33** (1981), Corollary 2,
DOI 10.4153/CJM-1981-080-0.

Independently, the strict bound $|z|<2$ makes the search over every possible
monic factor of degree at most four finite.  Integrality and

$$
|e_\ell|<\binom{k}{\ell}2^\ell
$$

give exactly 89,352 possible factors; exhaustive division finds precisely the
same 12 reducibles.  Both the Rabin assignments and this factor search were
independently reimplemented and replayed.

Hence 755 irreducible candidates reach the final stage, with digest

```text
96b2c779d6b9d020216e84c7dcbba904b4d8c9eb9851e72e3922a7062bd594af
```

## 5. Odd-degree resultant-tail inequality

Let $-t$ be the negative root and $r_1,\ldots,r_4$ the moduli of the complex
pairs.  Suppose $g$ divides a prefix later than prime cutoff $q$, and write
$F_X=F_q+T$.  At the negative root all tail exponents are odd, so if $N$ is
the first tail exponent,

$$
|T(-t)|\le\frac{t^N}{1-t^2}.
$$

At either root in complex pair $i$,

$$
|F_q(\alpha)|\le B_q(r_i),
\qquad B_q(r)=\sum_{p\le q}r^{p-2}.
$$

Since $F_q(\alpha)=-T(\alpha)$ and $g$ is monic, multiplication over all nine
roots gives the necessary inequality

$$
\boxed{
|\operatorname{Res}(g,F_q)|(1-t^2)
\le t^N\prod_{i=1}^4B_q(r_i)^2.
}
$$

The certificate isolates $t,r_i$ by exact rational bisection and proves the
strict reverse inequality for every candidate.  It checks 3,556 nonzero exact
prefix resultants and closes all 755 candidates by cutoff $41$:

$$
\begin{array}{c|rrrrrrrr}
q&13&17&19&23&29&31&37&41\\ \hline
\#&10&137&127&345&78&43&12&3.
\end{array}
$$

The minimum production margin exceeds $277$.  A separate hostile audit uses
finer root bounds and direct construction/division of every prefix; it checks
3,544 resultants, closes all candidates independently, and has minimum margin
above $10{,}422$.

For $X<11$, $\deg F_X<9$.  The checked nonzero resultants exclude every prefix
through each selected cutoff, and the strict tail inequality excludes every
later prefix.  This completes the proof.

## 6. Reproduction and trust boundary

Run from the repository root:

```text
python3 code/exp44_nonic_certificate.py --workers 8
```

The wrapper refuses optimized Python, creates fresh temporary shards, runs all
three certificate stages without checkpoint reuse, binds their ledgers by
counts and SHA-256 digests, and deletes the temporary state only after every
assertion passes.  The completed integrated replay took approximately 104
seconds on the development machine.

The machine-readable stage ledgers are
`data/exp37_nonic_workload.json`, `data/exp41_nonic_postcensus.json`, and
`data/exp42_nonic_tail.json`.  Independent hostile audits accepted the exp37,
exp41, and exp42 gates separately before this theorem was promoted.
