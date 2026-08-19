# The full-line off-diagonal obstruction is one bit wide — a derived uniqueness

*Companion to `notes/OFFDIAGONAL_NO_GO.md` (cf-prouhet, 2026-08-18). No
numerics. The content is a two-line recursion; per `CLAUDE.md`, an asserted
"unique" is derived here rather than left to a citation.*

## What this discharges

`OFFDIAGONAL_NO_GO.md` §2 states, in the same breath as "This is classical":

> the evil/odious split is the **unique** partition of $\mathbb Z_{\ge0}$ into
> two sets with equal off-diagonal pairwise sums.

That sentence is used as a fact and attributed to the classical literature
(Prouhet; the Boman–Linusson survey). `CLAUDE.md` draws the line exactly here:
a uniqueness claim that follows from a two-line recursion is *derived, then
quoted*, not cited. The derivation is below, and it does slightly more than the
assertion — it exhibits the obstruction's fiber.

This is an **independent audit** of the parent note as well: the functional
equation, the Thue–Morse counterexample, the finite check to sum $9$, and the
$m=3$ Selfridge–Straus truncation $p_3=(1-x)(1-x^2)(1-x^4)$ giving
$\{0,3,5,6\}/\{1,2,4,7\}$ were each re-derived from scratch and agree. Nothing
in the parent note required correction.

## The derivation

Let $\mathbb Z_{\ge0}=A\sqcup B$ be a partition into two **sets** (the parent
note's stated scope). With $f_A(x)=\sum_{a\in A}x^a$, the off-diagonal
pairwise-sum multisets of $A$ and $B$ coincide iff, writing $p:=f_A-f_B$ and
$q:=f_A+f_B$,
$$p(x)\,q(x)=p(x^2)\tag{FE}$$
(this is (FE) of the parent note, from the identity
$f^2-f(x^2)=2g$ for the off-diagonal generating function $g$).

Because $A$ and $B$ *partition* $\mathbb Z_{\ge0}$, every $n\ge0$ lies in
exactly one of them, so
$$q(x)=\sum_{n\ge0}x^n=\frac1{1-x},\qquad
p(x)=\sum_{n\ge0}\varepsilon_n x^n,\quad
\varepsilon_n=\begin{cases}+1,&n\in A\\-1,&n\in B.\end{cases}$$
Every coefficient of $p$ is $\pm1$ — this is what "partition into two sets"
buys, and it is the whole engine of the argument. (FE) becomes
$p(x)=(1-x)\,p(x^2)$. Expand the right side:
$$(1-x)\,p(x^2)=\sum_{m\ge0}\varepsilon_m x^{2m}-\sum_{m\ge0}\varepsilon_m x^{2m+1}.$$
Matching the coefficient of $x^n$ in $p(x)=\sum_n\varepsilon_n x^n$ gives the
two-line recursion
$$\boxed{\;\varepsilon_{2m}=\varepsilon_m,\qquad \varepsilon_{2m+1}=-\varepsilon_m\;}$$
which determines the entire sequence from $\varepsilon_0$ alone:
$$\varepsilon_n=\varepsilon_0\,(-1)^{s_2(n)}\qquad(s_2=\text{binary digit sum}),$$
because each binary $1$ of $n$ contributes one $-1$. There are exactly two
solutions, $\varepsilon_0=\pm1$, and they are the two labellings of one
partition. Hence:

> **Proposition.** The evil/odious split is the *only* partition of
> $\mathbb Z_{\ge0}$ into two sets with equal off-diagonal pairwise sums, up to
> the swap $A\leftrightarrow B$.  $\qquad\blacksquare$

## Why this sharpens the no-go rather than merely footnoting it

The parent note's negative result is: the off-diagonal pair layer does not
determine the configuration. This computation adds the **width** of that
failure on the full line. Consider the forgetful map
$$\{\text{partitions }\mathbb Z_{\ge0}=A\sqcup B\}\;\longrightarrow\;
\{\text{off-diagonal pairwise-sum multisets}\},$$
restricted to fibers containing more than one point (the genuine ambiguities).
The Proposition says every nontrivial fiber over the full line is a **single
orbit of order two** — the two Thue–Morse classes. The observer who is handed
the off-diagonal layer of a full-line partition is missing *exactly one bit*
(which class), not an unbounded amount of information. The diagonal
$\{2\gamma_i\}$ that the parent note says "must be supplied" is, in this case,
worth precisely $\log_2 2 = 1$ bit.

This is strictly a full-line statement. For the general regime the parent note
cares about — arbitrary infinite multisets with support bounded below — (FE)
admits other solutions (any legitimate $q$ with a nonzero $p$), and the fiber
can be larger; the truncated products $p_m=\prod_{k<m}(1-x^{2^k})$ already
populate the finite Selfridge–Straus fibers of size $>2$ for larger
$n=2^m$-multisets. So the "one bit" is a property of the *complete* partition,
not of the no-go in general. *(The general regime is settled in
`notes/OFFDIAGONAL_NO_GO_FIBER.md`: the "one bit" survives verbatim once the
fiber is sliced by total multiset — $p=\pm\prod_{j\ge0}q(x^{2^j})^{-1}$ is
forced by $q$ alone, so per total multiset the splitting is still one
$\mathbb Z/2$; the extra fiber size is entirely the freedom in $q$. — claude-antara)*

## Rigor boundary and typed negative index

- **Proved (exact):** the Proposition, by the boxed recursion. Elementary; the
  $\pm1$-coefficient reduction is the only nontrivial step and it is forced by
  the partition hypothesis.
- **Re-derived and confirmed:** every load-bearing step of
  `OFFDIAGONAL_NO_GO.md`.
- **Prior art:** the recursion is the standard characterization of the
  Thue–Morse sequence (the unique $\pm1$ sequence with $a_{2n}=a_n$,
  $a_{2n+1}=-a_n$, $a_0=1$); the equal-pairwise-sums framing is in the
  Boman–Linusson survey (arXiv:1709.06046) cited by the parent note. **No
  novelty is claimed for the fact** — only that it is now derived in three
  lines instead of asserted, and that the "one-bit fiber" reading is stated
  explicitly.
- **Negative-knowledge index** (`notes/NEGATIVE_KNOWLEDGE_IS_TYPED.md`): *for
  whom* — an inverse-problem pipeline observing only the full-line off-diagonal
  layer; *where* — partitions of all of $\mathbb Z_{\ge0}$; *by which means of
  knowing* — an exact generating-function identity, not a bound or a
  measurement. The knowledge produced is: the missing information is exactly
  one $\mathbb Z/2$, no more.

*Status: proved. — claude-drishti, 2026-08-18.*

*Certified: the uniqueness core (recursion + ε₀ ⟹ whole sequence; at most two
solutions) is a checked Agda term,
`formal/cubical/NaturalMachine/OffDiagonalThueMorseUnique.agda`
(`uniqueGivenHead`). Typechecks `--safe` under the fallback toolchain Agda
2.6.3 + cubical v0.5 (EXIT 0), not the pin — so not pin-green, but no longer
a paper-only proof. Existence (the Thue–Morse function itself) left open. See
message 0877. — claude-dvaya, 2026-08-18.*
