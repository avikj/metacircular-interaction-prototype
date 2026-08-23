# When stagewise defect ledgers determine the composite defect

*seed181, 2026-08-15. Runs to ground the observation of `0779` (fourth
full-read draw, `collab/messages/0779-seed178-full-read-fourth-draw.md`),
which found `OBSERVER_REVISION_COMPOSITION.md`'s "the two stagewise Boolean
defect sets do not determine the composite defect set" false at two response
values. That note was corrected in place at `0779` (Thm 2′, Cor 2′.1); this
note supplies the general theorem the corollary is a special case of, the
refutation of the natural framing that goes with it, and the corpus-wide
application.*

The prompt that commissioned this note guessed that the dividing line is
$|R|\ge 3$ and that "the right statement is about the composite of the
triangle inequality for the discrete metric". **The cardinality half of the
guess is correct and is proved below. The triangle-inequality half is wrong**,
and saying why is the content of §2.

---

## 1. Setup and the pointwise reduction

A composable pair of observer revisions

\[
(X'',Q'')\xrightarrow{(t,\upsilon)}(X',Q')\xrightarrow{(s,\tau)}(X,Q)
\]

with responses valued in a set $R$ assigns to each $x''$ and each old probe
$q$ a **comparison span**

\[
(a,b,c)\;=\;\bigl(r_q(stx''),\;r'_{\tau q}(tx''),\;r''_{\upsilon\tau q}(x'')\bigr)\in R^3 .
\]

The three defect sets are the preimages of the three inequality relations:

\[
A=t^{-1}D_{R_1}(q)=\{a\neq b\},\quad
B=D_{R_2}(\tau q)=\{b\neq c\},\quad
D=D_{R_1R_2}(q)=\{a\neq c\}.
\]

Every set here is a pointwise condition on the span, so the whole question is
about one function of one triple. Write $\delta:R^3\to\mathbf 2^2$,
$\delta(a,b,c)=(1_{a\neq b},1_{b\neq c})$, and $\kappa:R^3\to\mathbf 2$,
$\kappa(a,b,c)=1_{a\neq c}$.

> **Definition.** *The stagewise family determines the composite over $R$* iff
> $\kappa$ factors through $\delta$: iff there is $f:\mathbf 2^2\to\mathbf 2$
> with $\kappa=f\circ\delta$ on all of $R^3$.

This is the decoder formulation, and it is the right one: "determines" is a
statement about a rule that works for every chain, not about one chain. (A
single chain always has *some* $D$; the question is whether $(A,B)$ computes
it.) `formal/cubical/NaturalMachine/ObserverRevisionComposition.agda` already
uses exactly this formulation, with $R$ fixed at three values.

## 2. The sandwich, and what the guess gets wrong

**Proposition 1 (holds over every $R$).**
$A\,\triangle\,B\;\subseteq\;D\;\subseteq\;A\cup B$.

*Proof.* If $a\neq b$ and $b=c$ then $a\neq c$; symmetrically. If $a=b$ and
$b=c$ then $a=c$. $\square$

In metric language: let $d$ be the discrete metric on $R$, $d(x,y)=1_{x\neq
y}$. The right inclusion is the triangle inequality $d(a,c)\le
d(a,b)+d(b,c)$; the left is the reverse triangle inequality $d(a,c)\ge
|d(a,b)-d(b,c)|$.

**Both inequalities hold for every $R$, and both are attained for every $R$
with $|R|\ge2$.** So *nothing about the triangle inequality fails at $|R|\ge
3$*, and the prompt's framing — that the failure is "the composite of the
triangle inequality" — is refuted. Proposition 1 already pins $\kappa$
uniquely on three of the four fibers of $\delta$:

| $(1_{a\neq b},1_{b\neq c})$ | forced value of $1_{a\neq c}$ |
|---|---|
| $(0,0)$ | $0$ (both bounds $=0$) |
| $(1,0)$ | $1$ (both bounds $=1$) |
| $(0,1)$ | $1$ (both bounds $=1$) |
| $(1,1)$ | lower bound $0$, upper bound $2\mapsto$ unconstrained |

The whole question lives in the single fiber $\delta^{-1}(1,1)=A\cap B$. What
distinguishes $|R|\le2$ is not that an inequality becomes available but that
the two bounds **coincide**: in $\{0,1\}$, $|u-v|=u+v$ unless $u=v=1$, and
$u=v=1$ is unreachable when $|R|\le 2$.

## 3. The theorem

**Theorem A.** For a set $R$, the stagewise family determines the composite
over $R$ **iff $|R|\le 2$**, and then the unique decoder is
$f=\mathrm{XOR}$, i.e. $D=A\,\triangle\,B$.

*Proof.* ($\Leftarrow$) $|R|\le1$: all triples are constant, $\kappa\equiv0$.
$|R|=2$: fix a bijection $R\cong\mathbb Z/2$. Then $1_{x\neq y}=x+y$, so

\[
1_{a\neq c}=a+c=(a+b)+(b+c)=1_{a\neq b}+1_{b\neq c}\quad\text{in }\mathbb Z/2,
\]

which is $f=\mathrm{XOR}$; uniqueness on the three reachable fibers is
Proposition 1, and $(1,1)$ is unreachable ($a\neq b$ and $b\neq c$ with only
two values force $a=c$).
($\Rightarrow$) Let $0,1,2\in R$ be distinct. The triples $(0,1,0)$ and
$(0,1,2)$ satisfy $\delta=(1,1)$ both, while $\kappa=0$ and $\kappa=1$
respectively. No $f$ can take two values at one argument. $\square$

**Refuted generalization (an algebraist's first guess, and it is wrong).** The
$\mathbb Z/2$ identity might look like a statement about *characteristic 2*
rather than about *cardinality 2* — i.e. one might hope determination survives
whenever $R$ carries an elementary abelian $2$-group structure. It does not.
In $R=(\mathbb Z/2)^2$ take $a=00$, $b=01$, $c=10$: all three pairs differ, so
$\delta=(1,1)$ and $\kappa=1$, while $a=00,b=01,c=00$ gives $\delta=(1,1)$,
$\kappa=0$. Theorem A already covers this ($|R|=4$); the point is that no
algebraic structure on $R$ rescues additivity. The indicator $1_{x\neq y}$ is a
group *norm* on $R=\mathbb Z/2$ by an accident of size — the only nonzero
element is the only nonzero value — and this accident does not survive rank
$\ge2$.

**Theorem B (the exact criterion, for a fixed realized family).** Let
$T\subseteq R^3$ be the set of spans actually realized (over the points and
probes one is quantifying over). The stagewise ledgers determine the composite
on $T$ iff $T$ does **not** meet both of

- the *cancellation* cell $\{a\neq b,\;b\neq c,\;a=c\}$, and
- the *persistence* cell $\{a\neq b,\;b\neq c,\;a\neq c\}$.

*Proof.* By Proposition 1, $\kappa$ is constant on $T\cap\delta^{-1}(u)$ for
$u\neq(1,1)$ automatically; ambiguity is exactly two spans in
$T\cap\delta^{-1}(1,1)$ with different $\kappa$, which is exactly a span in
each cell. $\square$

**Corollary B.1 (what $|R|\ge3$ does and does not buy).** $|R|\ge3$ is
necessary and sufficient for the *existence* of a composable pair over $R$
whose stagewise ledgers fail to determine the composite. It is **not**
sufficient for a *given* pair to fail: any pair whose realized spans avoid one
of the two cells — in particular any pair with $A\cap B=\varnothing$, or any
pair whose responses land in a two-element subset of $R$ — is determined,
however large $R$ is. Determination is a property of $T$, not of $R$.
This is the same discipline as `SEVEN_DEFECT_COMPONENTS.md` §10 (lossiness is
a property of the report) and `CLAUDE.md`'s standing warning about constants
quoted without their scaling: "$|R|\ge3\Rightarrow$ non-determination" is a
realizability statement wearing the clothes of a pointwise one.

**Corollary B.2 (why response-valued spans always work, for any $R$).** Suppose
$R$ is a torsor under an abelian group $G$ and one records the *$G$-valued*
defects $g_1=b-a$, $g_2=c-b$. Then $c-a=g_1+g_2$ for every $R$: the
response-valued ledger composes over any codomain, by telescoping. What fails
at $|R|\ge3$ is the passage to supports: $1_{g\neq0}$ determines $1_{g_1+g_2\neq
0}$ from $(1_{g_1\neq0},1_{g_2\neq0})$ for all $g_1,g_2\in G$ iff $|G|\le2$
(same proof: $g_1=g$, $g_2=-g$ versus $g_2=h\neq -g$, both nonzero, needs a
third element). **The dividing line is difference-versus-indicator-of-
difference, and the indicator survives composition only at $|R|=2$, where
indicator and difference coincide.**

## 4. The three-valued counterexample, explicitly

$R=\{0,1,2\}$; $X=X'=X''=\{\ast\}$; $Q=Q'=Q''=\{q\}$; all maps the unique ones.

| chain | $a$ | $b$ | $c$ | $A$ | $B$ | $D$ |
|---|---|---|---|---|---|---|
| I  (cancellation) | $0$ | $1$ | $0$ | $\{\ast\}$ | $\{\ast\}$ | $\varnothing$ |
| II (persistence)  | $0$ | $1$ | $2$ | $\{\ast\}$ | $\{\ast\}$ | $\{\ast\}$ |

Identical stagewise ledgers, different composites: non-determination at
$|R|=3$ is genuine, so both halves of Theorem A are witnessed. (This is the
pair already machine-checked as `recovery-*`/`persistent-*` and
`no-stage-defect-decoder` in
`formal/cubical/NaturalMachine/ObserverRevisionComposition.agda`.)

A single-composite version, for readers who object that two chains are two
objects: take $X''=\{p,p'\}$ with $t,s$ constant and three probes arranged so
that the span at $p$ is $(0,1,0)$ and at $p'$ is $(0,1,2)$. Then $A=B=X''$
while $D=\{p'\}$; the fiber $A\cap B$ of one composite is itself mixed, so no
amount of refining the *ledger* recovers $D$.

## 5. Corpus application (Rule K3′)

Located by grep-then-read over `notes/`, `collab/`, `formal/`, `paper/`:

1. `notes/OBSERVER_REVISION_COMPOSITION.md` — **already corrected** at `0779`
   (verified by reading, not by commit message). Cor 2′.1 there is Theorem A
   restricted to $|R|=2$. Cross-reference added here.
2. `notes/OBSERVER_REVISION_CUBICAL.md` — the no-go it reports is *true* (its
   $V$ is the explicit three-value type), but stated with $V$ suppressed and
   with no positive complement. Correction appended.
3. `collab/STATE.md` line 366 — the landing row restates the claim
   unconditionally. Correction appended, original text quoted.
4. `formal/cubical/NaturalMachine/ObserverRevisionComposition.agda` §3 header
   comment "Boolean stage ledgers do not determine composition" — the
   *theorem* is scoped to `Response₃` and is correct; only the comment is
   unquantified. Left as is; flagged here rather than editing checked source
   this note did not typecheck.
5. Append-only records carrying the unqualified claim, **not rewritten** by
   the same rule that keeps honesty ledgers immutable, and listed here so the
   qualifier is reachable from them:
   `collab/chronicle/MESSAGES.md:7787` ("Pass/fail defect sets therefore do
   not determine ..."), `collab/messages/0112-codex-observer-revision-composition.md`
   (the original transmission; its own witness moves the last value to `2`, so
   it too silently uses $|R|\ge3$), `collab/journals/codex.md:488`,
   `collab/journals/codex-atelier.md:42`. The live restatement that *was*
   corrected is item 3 above; these four are history.
6. Checked and **not** affected, despite lexical proximity:
   `BALANCE_NOT_TRANSITIVITY_QUANTUM.md` §4 (scalar *cost* non-composition —
   a max-of-sums statement, not an indicator statement),
   `CAUSAL_MEMORY_SPACETIME` row in `STATE.md` (rank pairs, likewise not an
   equality indicator), `SEVEN_DEFECT_COMPONENTS.md` (joint injectivity of a
   projection family — the general form of which Theorem B is an instance).

## 6. Scope limits

- Everything here is finite-free set theory about one function $R^3\to\mathbf
  2$; no analysis, no measurement, no Agda authored or typechecked by this
  note. The Agda cited in §4 was **read**, not run.
- Theorem A is about the *equality* defect. Nothing is claimed about defects
  defined by a nontrivial tolerance relation (e.g. $|a-b|>\varepsilon$), where
  even Proposition 1's left inclusion can fail; that is a separate question
  and is open here.
- "Determines" throughout means: a decoder exists on the realized image, no
  default values on unreachable summaries (the convention of
  `OBSERVER_REVISION_CUBICAL.md`'s `DeterminesComposite`).
- Corollary B.2 assumes an abelian $G$; the nonabelian case ($c-a$ replaced by
  a product of one-sided differences) composes just as well but was not
  written out.
- No claim that any of the affected notes' *other* content is correct; only
  the determination clause was audited.
