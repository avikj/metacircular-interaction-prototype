# Five faces of one obstruction? A classification with a registered forecast

**Question, as posed by the human collaborator.** Are FLT, RH, Goldbach, twin
primes and Collatz five faces of *one* obstruction?

**Answer, up front, so no reader has to hunt for it: no.** The verdict argued
in §7 is **(b) with a (c) boundary**: the five share a *shape* — every one of
them is a statement that cannot be written inside a single chart of
$\mathbb{N}$ — and that shape is a real observation with no technical content,
predicting nothing about method, difficulty, or barrier type. The membership
of the list is best explained by fame. One genuine sub-family of **two**
survives the tests (Goldbach and twin primes), and it survives as an
*identification*, not a unification, for reasons already in this corpus that
exclude the other three.

**The two decisive tests, and where to find them.** §5.7 runs the local-to-
global framing against the extended list of **seven** (adding Navier–Stokes,
P vs NP, quantum gravity): it scores **0 of 7** on its own predicted object
type, and it fails on a member of its own list, because it describes *ternary*
Goldbach — a theorem — in exactly the words it uses for binary Goldbach.
§7.5 applies the **mixed-term criterion** to this note's own verdict: the
five-fold and seven-fold joint objects have **zero** mixed term and are
dropped; the surviving pair has a *degenerate* mixed term, which is a third
outcome the criterion needs and did not have, supplied with the discipline that
keeps it from being a loophole.

---

## 0. Fences, scope, and status

**Status: PENDING HOSTILE AUDIT.**

**Hard fences, inherited and restated.**

1. `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §2: *aesthetic resonance without
   reconstruction becomes mythology.* Everything below is either a definition,
   a proof, a labelled quotation from this corpus, or a labelled literature
   citation.
2. `collab/messages/0073` §2: *construct so as to annihilate.* §9 is the
   annihilation apparatus and it is not optional reading.
3. **This note claims no progress on any of the five and proposes no proof
   strategy for any of them.** Several sections identify where a barrier sits.
   None of those identifications is a route, and none should be read as one.
   The classification's falsifiers in §6 are stated as *tests of the
   classification*, not as targets to attack; a falsifier of a classification
   is not a plan for a theorem.
4. `ATLAS_OF_N.md` Corollary 2.13.1's guardrail is inherited **verbatim** and
   is load-bearing throughout §2: the statement that additive conditions are
   inexpressible in the multiplicative chart *is a triviality about the
   weakness of a structure* and "is not an explanation of, and implies nothing
   whatsoever about, the difficulty of Goldbach, twin primes, $abc$, RH, or
   any other open problem." Every chart-location claim in §2 is subject to it.
5. No numerical experiments (this repo has permanently ended them); no floats;
   no code; this note creates only itself and edits nothing.

**Pramāṇa labels** (msg 0073 §1): **FETCHED** = source retrieved this session,
URL given; **UNVERIFIED-MEMORY** = recalled, not retrieved, not relied on;
**HERE** = argued in this note; **CLASSICAL** = standard mathematics
independent of which source is cited; **CORPUS** = quoted from a note in this
repository, cited and not re-derived.

**A concurrent lane, cited as reported, not used.** The coordinator reports a
lane (`runtime/nerve/`) computing Čech cohomology of the runtime's four views
to decide whether pairwise-consistent local certificates glue. **No such
directory existed in this working tree at the time of writing**; nothing is
imported from it, no result of it is assumed, and it is recorded here only as
a reported independent arrival at a local↔global framing. Convergence of two
framings is evidence about *what people find natural to say*, not evidence
about mathematics; §5.6 says why that distinction is exactly the one at issue.

---

## 1. The registered forecast (written before the analysis of §§2–6)

Per `PROTOCOL.md` §4 and the exp60 pattern in `FF_PAIRFIELD.md`, forecasts are
registered before the test, not after.

Let **H₁** ("shared mechanism") be the hypothesis that the five share a common
obstruction in the technical sense: one mechanism $M$ such that solving any of
the five *is* removing $M$ in that instance.

Let **H₂** ("local–global core", the sibling agent's sharpening, tested as
primary) be the hypothesis that all five ask *do locally admissible operations
generate a globally coherent form?*, with the obstruction living in the
assembly step.

Let **H₃** ("additive statements about multiplicative atoms", secondary) be the
shape hypothesis.

**Registered predictions.**

- **P1 (transfer).** If H₁ holds, a technique that removes $M$ in one instance
  must yield *nontrivial transferable content* — a theorem, a barrier, or at
  minimum a reformulation — in at least one other instance. Predicted: at
  least one documented cross-transfer of a **method** (not an analogy) among
  the five.
- **P2 (barrier isomorphism).** If H₁ holds, the barrier proved for one member
  should be statable, in recognizable form, for the others. Predicted: the
  parity barrier, or an isomorphic obstruction, appears in at least three of
  the five.
- **P3 (chart location).** If H₃ has content, the five should occupy the *same*
  position in `ATLAS_OF_N.md`'s transition diagram — the same transition, the
  same residual. Predicted: all five sit on $(f)\to(b)$ with residual
  = addition.
- **P4 (object test, from the coordinator's brief).** If H₂ has technical
  content, then for each of the five one can name a specific obstruction
  **object** — a cohomology class, a measure-theoretic defect, an explicit
  non-gluing witness — and not merely the word "obstruction". Predicted:
  5 of 5 objects nameable.
- **P5 (asymmetry).** If H₂ holds, it should *explain* why modularity closed
  FLT and did nothing for Goldbach. Predicted: yes.

**Results, forward-referenced:** P1 **fails between the classes and holds
inside one pair**; P2 **fails (2 of 5)**; P3 **fails (2 of 5, arguably 2.5)**;
P4 **fails (2 of 6 instances, and both of the wrong type)**; P5 **fails, and a
different criterion succeeds in its place** (§5.5). Registered before the fact,
these are five predictions of which none survives intact.

---

## 2. The five, stated precisely, with status

Precision here is not decoration: a comparative study on a misstatement is
worthless, and three of the five are routinely misstated in exactly the way
that would make a false family look real.

### 2.1 Fermat's Last Theorem — **PROVED**

> For every integer $n \ge 3$ there are no positive integers $x,y,z$ with
> $x^n + y^n = z^n$.

**Status: theorem.** Wiles, *Modular elliptic curves and Fermat's Last
Theorem*, Annals of Mathematics **141** (1995), no. 3, 443–551,
doi:10.2307/2118559 (**FETCHED**:
https://annals.math.princeton.edu/1995/141-3/p01 — title, author, volume,
issue, year and DOI confirmed; page range from the search record), together
with Taylor–Wiles, *Ring-theoretic properties of certain Hecke algebras*,
Annals of Mathematics **141** (1995), 553–572 (**FETCHED at search-summary
level**; the pairing of the two papers and their page ranges are confirmed by
multiple independent records including a bookseller's bibliographic entry, but
the Taylor–Wiles article page itself was not retrieved).

**The logical shape matters for everything below and is usually elided.**
Wiles proved that every semistable elliptic curve over $\mathbb{Q}$ is modular.
FLT follows only when that is combined with Frey's construction and Ribet's
level-lowering theorem (**CLASSICAL**, **UNVERIFIED-MEMORY** for exact
citations: Frey 1986; Serre's $\varepsilon$-conjecture; Ribet, Invent. Math.
1990). The composite argument is: a hypothetical solution $a^p+b^p=c^p$ with
$p\ge5$ prime produces a semistable elliptic curve whose mod-$p$ Galois
representation, *if modular*, must be modular of weight $2$ and level $2$; and
$S_2(\Gamma_0(2)) = 0$.

So the proof does not solve an equation. **It exhibits an object that would
have to lie in a space that is empty.** Retain the phrase *empty receptacle*;
§6 uses it as a lens-calculus verdict.

### 2.2 The Riemann Hypothesis — **OPEN**

$\zeta(s)=\sum_{n\ge1}n^{-s}$ for $\Re s>1$, continued meromorphically to
$\mathbb{C}$ with a single simple pole at $s=1$.

> Every zero of $\zeta$ in the strip $0<\Re s<1$ satisfies $\Re s = \tfrac12$.

**Status: open.** Clay Millennium Prize Problem (**FETCHED**:
https://www.claymath.org/millennium/riemann-hypothesis/ — the official page
states that "all the 'non-obvious' zeros of the zeta function are complex
numbers with real part 1/2" and that the assertion has been computationally
verified for the first 10 trillion zeros).

Note the two standard fences. (i) The zeros at $s=-2,-4,\dots$ are excluded by
the strip condition, not by an appeal to "non-obvious". (ii) RH is a statement
about a function on $\mathbb{C}$; it is *not* a statement inside $\mathbb{N}$
and no chart of $\mathbb{N}$ contains it (§3.3).

### 2.3 Goldbach (binary / strong) — **OPEN**

> Every even integer $N \ge 4$ is a sum of two primes.

**Status: open.** The nearest results: Chen's theorem (**FETCHED at
search-summary level**: J.-R. Chen, *On the representation of a large even
integer as the sum of a prime and the product of at most two primes*, Scientia
Sinica **16** (1973), 157–176) — every sufficiently large even integer is
$p + P_2$ with $P_2$ having at most two prime factors. And the **ternary**
statement, which must not be confused with the binary one:

> Every odd integer $\ge 7$ is a sum of three primes.

Vinogradov (1937) for sufficiently large odd integers (**CLASSICAL**,
**UNVERIFIED-MEMORY** for the citation); Helfgott, *The ternary Goldbach
conjecture is true*, arXiv:1312.7748 (**FETCHED**:
https://arxiv.org/abs/1312.7748) for all of them. **Status caveat, stated
because it is load-bearing in §4:** the sources retrieved this session record
that Helfgott's paper, while widely accepted, has not appeared in a
peer-reviewed journal. The ternary/binary distinction is the single most
important fact in this note's transfer analysis and is *not* a matter of
difficulty degree: it is a difference in the number of free variables
available to a minor-arc estimate.

### 2.4 Twin primes — **OPEN**

> There are infinitely many primes $p$ such that $p+2$ is prime.

**Status: open.** Known: Zhang, *Bounded gaps between primes*, Annals of
Mathematics **179** (2014), 1121–1174 —
$\liminf_n (p_{n+1}-p_n) < 7\times10^7$; Maynard, *Small gaps between primes*,
Annals of Mathematics **181** (2015), 383–413 — $\liminf \le 600$, with
Polymath8b reducing it to $246$ (**FETCHED at search-summary level** for Zhang
and Maynard's bibliographic data; Polymath8b's constant is
**UNVERIFIED-MEMORY**). Chen's method also gives infinitely many $p$ with
$p+2$ having at most two prime factors (**FETCHED at search-summary level**,
Wikipedia *Chen's theorem*).

**The crucial negative fact.** Bounded gaps do **not** approach twin primes by
degrees. The sieve-theoretic parity phenomenon (Selberg) is the statement that
sieve methods of the classical shape cannot distinguish integers with an odd
number of prime factors from those with an even number, and therefore cannot
produce primes; Friedlander–Iwaniec, *Asymptotic sieve for primes*, Annals of
Mathematics **148** (1998), 1041–1065 (**FETCHED at search-summary level**;
arXiv:math/9811186) is the standard reference for both the obstruction and the
extra bilinear axiom that circumvents it in favourable cases. `WIDTH.md` is
this corpus's own quantitative anatomy of that barrier and is used as primary
evidence in §4 and §6.

### 2.5 Collatz — **OPEN**

Define $\mathrm{Col}:\mathbb{N}_{\ge1}\to\mathbb{N}_{\ge1}$ by
$\mathrm{Col}(N)=3N+1$ for $N$ odd and $N/2$ for $N$ even.

> For every $N\ge1$ some iterate $\mathrm{Col}^k(N)$ equals $1$.

**Status: open.** The statements and the best result are quoted verbatim from
Tao, *Almost all orbits of the Collatz map attain almost bounded values*,
Forum of Mathematics Pi **10** (2022), Paper No. e12, 56 pp. (**FETCHED**:
https://arxiv.org/abs/1909.03562): "Previously, it was shown by Korec that for
any $\theta > \log 3/\log 4 \approx 0.7924$, one has
$\mathrm{Col}_{\min}(N) \le N^\theta$ for almost all $N$ (in the sense of
natural density). In this paper we show that for any function $f$ with
$\lim_{N\to\infty} f(N) = +\infty$, one has $\mathrm{Col}_{\min}(N) \le f(N)$
for almost all $N$ (in the sense of logarithmic density)."

Two further facts, both needed in §3 and §5:

- **Cycles.** Simons–de Weger, *Theoretical and computational bounds for
  $m$-cycles of the $3n+1$-problem*, Acta Arithmetica **117** (2005), 51–70,
  doi:10.4064/aa117-1-3 (**FETCHED at search-summary level**): no nontrivial
  $m$-cycles for $1 \le m \le 68$, by "transcendental number theory,
  computational diophantine approximation techniques", generalising Steiner
  and Simons for $1$- and $2$-cycles.
- **The generalised problem is undecidable.** Conway, *Unpredictable
  iterations*, Proc. 1972 Number Theory Conference, Univ. of Colorado,
  Boulder, 49–52 (**FETCHED at search-summary level**): generalised Collatz
  maps simulate arbitrary Turing machines, so the halting question for the
  family is undecidable. This is a statement about the *family*, not about the
  specific $3n+1$ map, and inflating it into a claim about Collatz itself
  would be exactly the error this note is built to avoid.
- **The $2$-adic presentation is completely understood.** Bernstein–Lagarias,
  *The $3x+1$ conjugacy map*, Canadian J. Math. **48** (1996), 1154–1169
  (**FETCHED at search-summary level**: https://cr.yp.to/papers/3x1conjmap-19960215-retypeset20220326.pdf):
  the conjugacy $\Phi$ on $\mathbb{Z}_2$ satisfies
  $\Phi\circ S\circ\Phi^{-1} = T$ where $T$ is the (accelerated) $3x+1$ map and
  $S$ is the shift. This is decisive for §3 and is the single most misused
  fact about Collatz.

---

## 3. The chart analysis

Charts are those of `ATLAS_OF_N.md` §1: **(a)** initial $(1+X)$-algebra
(Peano; induction = initiality), **(b)** free monoid on one generator
(additive), **(c)** finite cardinals (pre-truncation), **(d)** ordinals
$<\omega$, **(e)** base-$b$ digits (three residuals: base $\operatorname{rad}b$,
endian $\mathbb{Z}/2$, carry $[c_n]\ne0$), **(f)** free commutative monoid on
the primes (multiplicative), **(g)** Stern–Brocot. Residuals are those of the
table in §8 of that note.

### 3.1 FLT

**Hypothesis side.** "$m$ is an $n$-th power" is a statement in chart (f)
alone: under $e:\bigoplus_{p\in P}\mathbb{N}\xrightarrow{\ \sim\ }
(\mathbb{N}_{>0},\times)$, the $n$-th powers are exactly the image of the
sublattice $n\cdot\bigoplus_P\mathbb{N}$. The exponent $n$ itself is a
chart-(b) iteration count acting on chart (f); the inequality $n\ge3$ is
chart (d).

**Proposition 3.1 (HERE, one line).** *The set of $n$-th powers is invariant
under $\operatorname{Aut}(\mathbb{N}_{>0},\times)\cong\operatorname{Sym}(P)$.*
*Proof.* By `ATLAS_OF_N.md` Theorem 2.13(1) an automorphism permutes the free
generators, hence permutes exponent vectors; divisibility of every coordinate
by $n$ is permutation-invariant. $\square$

**Conclusion side.** $x^n+y^n=z^n$ is chart (b).

**Transition asked to commute:** $(f)\to(b)$. **Residual:** addition
(Residual 2.6: $\operatorname{Sym}(P)$ of cardinality $2^{\aleph_0}$ collapsing
to $\{\mathrm{id}\}$).

**But the fit is weak, and Proposition 3.1 is why.** By Corollary 2.13.1 the
diagnostic for "this statement genuinely straddles the transition" is whether
the multiplicatively-defined set is $\operatorname{Sym}(P)$-invariant. For twin
primes it is not (Cor. 2.13.1 exhibits the transposition moving
$\{p:p+2\in P\}$). For FLT it **is** (Prop. 3.1). FLT's multiplicative side is
completely blind to which primes are which — it is a statement about exponent
divisibility and nothing else. So FLT and twin primes are *not* in the same
chart position, and the first thing the atlas says about the proposed family
is that two of its members differ at the level where the family was supposed
to be defined.

**And the honest headline: FLT does not fit the atlas at all.** The proof of
§2.1 leaves $\mathbb{N}$ entirely — elliptic curves, Galois representations,
Hecke algebras, modular curves. None of these is a chart of $\mathbb{N}$;
none appears in the atlas; the atlas has no transition map to them. Recording
"FLT sits on $(f)\to(b)$" is true and useless: it describes the *statement*
and says nothing about the *object* that carries the proof. Forcing more than
that is the failure mode this note was commissioned to avoid.

### 3.2 Goldbach and twin primes

**Hypothesis side.** Primality is chart (f): $p$ prime iff $p$ is a free
generator, iff its exponent vector has total weight $1$ (Theorem 2.13(1)'s
proof). $P$ is manifestly $\operatorname{Sym}(P)$-invariant — it is the
generating set.

**Conclusion side.** $p+q=N$ and $p+2\in P$ are chart (b).

**Transition:** $(f)\to(b)$. **Residual:** addition. And here the residual does
real work, exactly and provably: by Corollary 2.13.1 the sets
$\{p : p+2\in P\}$ and $\{(p,q): p+q=N\}$ are **not** invariant under
$\operatorname{Aut}(\mathbb{N}_{>0},\times)$, so neither statement is
expressible in chart (f); and neither is expressible in chart (b) alone, since
$P$ is not definable from $(\mathbb{N},+)$ (Presburger arithmetic does not
define the primes — **CLASSICAL**, **UNVERIFIED-MEMORY** for the citation;
nothing below depends on it, the Cor. 2.13.1 half suffices).

**These two are in the same position, with the same residual, and are the only
two of the five for which this is true.** That is the first real finding, and
§4 confirms it from an entirely independent direction.

**Guardrail, repeated because it is exactly here that it must be.** This says
that Goldbach and twin primes are inexpressible in either chart alone. It says
**nothing** about why they are hard, and the atlas's own text forbids the
inflation. Two statements can share a chart position and have unrelated
difficulty; two statements in different positions can be equally hard.

### 3.3 RH

**Hypothesis side.** The Euler product $\zeta(s)=\prod_p(1-p^{-s})^{-1}$ is
chart (f) in the most literal possible sense: the universal property of the
free commutative monoid on $P$ *is* the statement that a completely
multiplicative function is freely determined by its values on the primes
(`ATLAS_OF_N.md` §1(f)).

**Conclusion side.** The location of zeros of a meromorphic function on
$\mathbb{C}$. This is not in any chart of $\mathbb{N}$. It lives in the
archimedean completion, reached by §5.2 ($\mathbb{Q}$) then §5.5
($\mathbb{R}$, hence $\mathbb{C}$).

**Transition:** $(f) \to$ archimedean completion — which is **not a chart
transition**; it exits the atlas. And the atlas states the exit price:
Theorem 5.3 — $\mathbb{N}\subset\mathbb{R}$ is closed and discrete,
$\mathbb{N}\subset\mathbb{Z}_b$ is dense, and there is **no continuous map in
either direction restricting to the identity on $\mathbb{N}$**; Ostrowski
(**CLASSICAL**, FETCHED in `ATLAS_OF_N.md` §9) says these are all the
completions of $\mathbb{Q}$ there are.

**Verdict: RH does not fit the framework.** What the atlas contributes is a
*location*, not a mechanism: RH is a statement about the archimedean
completion of an object presented in chart (f). That location is not empty of
consequence — `FF_PAIRFIELD.md` §4's de-centering table is the corpus's own
demonstration that a large majority of the visible structure around RH (sum
frequencies, the $s^{-5/2}$ modulus law, the entropy phase, Fresnel chirp,
opposite-sign suppression, the whole smoothing hierarchy) is archimedean
artifact, with exactly one row flagged "this is where RH lives"
(Krein/screw/Hermitian-square positivity). But a location is not an
obstruction, and RH's location is *different from* the location of Goldbach
and twin primes. Same starting chart, different destination, and the
destination is where each problem's difficulty is.

### 3.4 Collatz

**Hypothesis side (the map).** The branch test is $n \bmod 2$; by
Proposition 2.9 ($n\bmod d$ is a function of the last $k$ base-$b$ digits iff
$d\mid b^k$) this is a function of the last base-$2$ digit, and of the last
base-$b$ digit for any even $b$. The even branch $n\mapsto n/2$ is the
$\varsigma$-truncation of the base-$2$ chart (`DIGIT_CRYSTAL.md` §4.1: deleting
the least significant digit). The odd branch $n\mapsto 3n+1$ is multiplication
by a chart-(f) generator followed by the chart-(a) successor.

**Conclusion side.** "Some iterate equals $1$" is a **well-foundedness**
statement: the reachability relation generated by $\mathrm{Col}$ has a unique
terminal cycle and no infinite descending chain avoiding it. Well-foundedness
is chart (a) — by Proposition 1.2 of the atlas, induction *is* initiality —
and the natural proof-shape for it (a decreasing measure) additionally requires
chart (d), the order.

**Transition asked to commute:** local step data in charts (e)$_2$/(f) $\to$
global termination in chart (a). **Residual: induction**, and by
`ATLAS_OF_N.md` Theorem 5.1 induction is the residual that **dies in every
completion**, first at $\mathbb{Z}$.

That is the sharpest thing the atlas says about Collatz, and it is not the
thing everyone says. §3.5 is about the thing everyone says.

---

### 3.5 Does Collatz live in base-2/base-3 incompatibility? Both sides, then a verdict

This is the pattern-match the brief asked to be tested honestly, so both sides
are argued at full strength.

#### The case FOR (and it is not empty)

`ATLAS_OF_N.md` Proposition 2.9 is a genuine theorem and it applies. Within a
single positional chart base $b$:

- $n\bmod 2$ is a function of finitely many digits iff $2\mid b^k$, i.e. iff
  $2\mid b$;
- the multiplication $n\mapsto 3n$ is digit-local only in a chart where $3$ is
  visible, and $n \bmod 3$ is a function of finitely many base-$b$ digits iff
  $3\mid b$.

So in base $2$ the branch test is a single-digit read and the tripling is
global; in base $3$ the tripling is a shift and the parity test is global. The
Collatz map's two halves are never *simultaneously* one-digit-local in base $2$
or base $3$. Corollary 2.8.1 supplies the invariant: the chart invariant of the
base is $\operatorname{rad}(b)$, and $\operatorname{rad}(2)=2$,
$\operatorname{rad}(3)=3$ are incomparable under divisibility, so no continuous
identity-extending map $\mathbb{Z}_2\to\mathbb{Z}_3$ or
$\mathbb{Z}_3\to\mathbb{Z}_2$ exists. Two charts, no dictionary, and one map
requiring both. That is a clean story and it is why the pattern-match is
tempting.

#### The case AGAINST (and it wins)

**Objection 1: a common refinement exists, so there is no incompatibility of
the required kind.** Proposition 2.8's criterion is
$\operatorname{rad}(b')\mid\operatorname{rad}(b)$. Take $b=6$:
$\operatorname{rad}(6)=6$, and $\operatorname{rad}(2)=2\mid6$,
$\operatorname{rad}(3)=3\mid6$. So the identity extends *continuously* to
$\mathbb{Z}_6\to\mathbb{Z}_2$ and $\mathbb{Z}_6\to\mathbb{Z}_3$, both being the
CRT projections out of $\mathbb{Z}_6\cong\mathbb{Z}_2\times\mathbb{Z}_3$. Above
everything sits $\hat{\mathbb{Z}}=\varprojlim_b\mathbb{Z}_b$ (Proposition 5.4).
The radical-invariance theorem obstructs *direct* translation between
incomparable radicals; it does not obstruct a **common chart**, and Collatz
needs only a common chart. The two-charts-no-dictionary story is therefore
answering a question Collatz does not ask.

**Objection 2: the map is not merely definable but continuous on the common
chart, and on $\mathbb{Z}_2$ alone.** The branch condition is a clopen
condition (the parity of the last digit); $x\mapsto x/2$ is a homeomorphism
$2\mathbb{Z}_2\to\mathbb{Z}_2$; $x\mapsto(3x+1)/2$ is continuous on
$\mathbb{Z}_2$ ($2$ is invertible in $\mathbb{Z}_3$ and the odd branch is
applied only where division is legitimate). The accelerated map $T$ extends to
a continuous self-map of $\mathbb{Z}_2$, and Bernstein–Lagarias (§2.5,
FETCHED) prove far more: $T$ is **topologically conjugate to the shift** via a
homeomorphism $\Phi$ of $\mathbb{Z}_2$. The $2$-adic presentation of Collatz is
not obstructed. It is **solved**, and the solution is the full one-sided shift
— a system of maximal entropy carrying no information whatsoever about which
orbits of $\mathbb{N}\subset\mathbb{Z}_2$ terminate. A presentation that is
complete and uninformative is not an incompatibility; it is an annihilation,
and it happens *inside one base*, not between two.

**Objection 3 (decisive): the truth value is decided by an archimedean
inequality in which no radical appears.** The standard heuristic for why
Collatz should be true — and the reason the analogous $5n+1$ problem is
expected to have divergent orbits — is the sign of the multiplicative drift
per step, governed by $\log 3$ versus $\log 4$. Tao's theorem quotes Korec's
exponent as $\theta > \log3/\log4$ (**FETCHED**, §2.5) — the constant is a
ratio of archimedean logarithms. Nothing about $\operatorname{rad}(2)$ and
$\operatorname{rad}(3)$ distinguishes $3n+1$ from $5n+1$: they have the same
radical-divisibility relations to base $2$ and the same "no common positional
chart with the halving" story, and yet the two problems have opposite expected
answers. **A proposed obstruction that cannot distinguish $3n+1$ from $5n+1$ is
not the obstruction of $3n+1$.** That is the annihilation test applied to the
pattern-match, and the pattern-match fails it.

#### Verdict on Collatz and radical invariance

**Superficial pattern-match. Rejected.** The correct atlas location for
Collatz is the pair

> **Theorem 5.1** (induction dies in every completion) **and Theorem 5.3** (no
> continuous map either way between the archimedean and $b$-adic completions
> restricting to the identity on $\mathbb{N}$).

The Collatz map is transparent in exactly those completions — $\mathbb{Z}_2$,
$\mathbb{Z}_6$, $\hat{\mathbb{Z}}$ — in which its *conclusion* cannot even be
stated, because the order dies there (`ATLAS_OF_N.md` §5.6: "Dies: the order,
induction, integrality…") and well-foundedness dies with it; and the place
where the conclusion lives, the archimedean one, has no continuous relationship
to any of them. What is genuinely at stake is Proposition 2.9's *residual*
role, not Proposition 2.8's: the digit-locality of divisibility is real, the
incompatibility of radicals is a red herring, and the wall is the
archimedean/non-archimedean split that `CROSS_LENS.md` §4 already named as this
corpus's most-repeated finding.

**What would overturn this verdict.** A statement of the Collatz conjecture
whose hypothesis *and* conclusion are both expressible in a single
$\mathbb{Z}_b$, together with a proof that the corresponding statement in
$\mathbb{Z}_{b'}$ is inequivalent for some $b'$ with
$\operatorname{rad}(b')\nmid\operatorname{rad}(b)$. That would make the base
genuinely load-bearing. Absent it, the radical is not the invariant in play.

### 3.6 The rival framing, adjudicated — and it wins on the point that matters

A sibling agent proposes instead: *Collatz is a gap between **symbolic history**
and **metric drift**.* This is offered as a rival to the radical-invariance
framing of the brief. Adjudicated on the same three tests:

- **Test 1 (does it name the right split?).** "Symbolic history" is the
  $2$-adic itinerary — the parity vector, i.e. the point of the shift space to
  which Bernstein–Lagarias's $\Phi$ conjugates the orbit. "Metric drift" is the
  archimedean size, governed by $\log 3$ against $\log 4$. That is *exactly*
  the split identified in §3.5's verdict (Thm 5.3: no continuous comparison
  between the archimedean and $b$-adic completions), stated in dynamical rather
  than chart-theoretic language. **It names the right split.**
- **Test 2 (the $5n+1$ discriminator, which killed the radical framing).**
  Symbolic history is identical for $3n+1$ and $5n+1$ — the same shift space,
  the same clopen branch condition. The drift is not: $\log3$ vs $\log4$ against
  $\log5$ vs $\log4$, opposite signs, opposite expected answers. **It passes the
  test the radical framing failed.**
- **Test 3 (does it name an object?).** No. "Metric drift" is precisely the
  heuristic, unproven half; naming it does not produce a class, a defect, or a
  witness.

**Adjudication: the rival framing is strictly better than the one in the brief
and is adopted as the correct *description*.** It is a restatement of
`ATLAS_OF_N.md` Theorems 5.1 and 5.3 in dynamical vocabulary, not an addition
to them, and it changes no verdict: Collatz remains low rung (§6), remains
outside the family (§7), and still yields no obstruction object (§5.4). A
better description that leaves every verdict unchanged is exactly what a
description is; that is the finding, not a complaint.

---

## 4. The transfer test

Forecast registered in §1: **P1** (at least one documented cross-transfer of a
method among the five) and **P2** (the parity barrier or an isomorph appears in
at least three of the five).

### 4.1 The record, by pair

**FLT $\to$ anything.** Modularity of semistable elliptic curves closed FLT
and produced nothing for Goldbach, twin primes, RH or Collatz. This is not a
matter of degree — it is that the input to the method is a global
algebro-geometric object attached to a hypothetical solution, and four of the
five supply no such object (§5.5). **No transfer.**

**Circle method: ternary $\to$ binary Goldbach.** Vinogradov's ternary result
and Helfgott's completion of it (§2.3) do not degrade to a partial binary
result. The reason is exact and is not a shared obstruction: with three
variables the minor-arc contribution can be bounded by an $L^2\cdot L^\infty$
argument in which one factor is summed by Parseval and the other by a
Weyl-type bound; with two variables, both factors must be handled in
$L^\infty$ and the bound exceeds the main term. This is an **arity** deficit
of the probe class. **No transfer, for a reason that has nothing to do with a
shared mechanism.**

**Sieve: bounded gaps $\to$ twin primes.** Zhang and Maynard reach bounded
gaps; the parity phenomenon (Selberg; Friedlander–Iwaniec §2.4) is the
statement that the classical sieve framework provably cannot reach gap $2$
with primality on both sides. `WIDTH.md` is this corpus's quantitative anatomy
of that wall and its finding is stronger than "hard": **the barrier has
infinite width on the exponent scale $\theta=\log Q/\log X$.** Unconditional
individual uniformity is known only at $\theta=0$ (Siegel–Walfisz,
log-savings, ineffective); averaged uniformity at $\theta=1/2$ (Motohashi;
Granville–Shao's crossing to $20/39$); the framework's conjectural ceiling is
$\theta=1$ and its endpoint provably fails (Friedlander–Granville Maier-matrix
oscillation); and pointwise primality certification through the sampling
geometry needs $\theta_{\rm cert}\sim\sqrt X/\log X\to\infty$. **CORPUS**,
`WIDTH.md` §2 and its theorem-level summary. **No transfer, and the distance is
a change of scale rather than a gap to be narrowed.**

**Goldbach $\leftrightarrow$ twin primes: TRANSFER, documented, repeatedly.**

1. Chen's method (1973) yields, in one framework, both $N=p+P_2$ for large
   even $N$ and infinitely many $p$ with $p+2=P_2$ (§2.3, §2.4). One method,
   both problems, stopping at the same place for the same reason.
2. The parity barrier obstructs both at the same point, in the same form.
3. **CORPUS, and this is the sharpest form of it:** `CROSS_LENS.md` §4 records
   `ADELIC.md` Prop E1 + `FF.md` Thm 2 — *the singular series is
   sector-blind: Goldbach and gaps are isomorphic at every finite place; the
   $S/D$ distinction is the choice of positive cone, i.e. archimedean.*
4. **CORPUS:** in the function-field column where the parity barrier falls,
   it falls for both at once — Sawin–Shusterman's twin-prime theorem in
   $\mathbf{F}_q[t]$ and their Remark 1.2 Goldbach/linear-forms extension are
   the same theorem (`FF_PAIRFIELD.md` §5, quoting the fetched abstract).

**Collatz $\leftrightarrow$ anything.** No method from FLT, RH, Goldbach or
twin primes has transferred to Collatz. There *is* one methodological
adjacency, and it points the wrong way for H₁: Tao's Collatz theorem is a
**logarithmic-density** statement, and logarithmic averaging is the same
weakening that makes the logarithmic Chowla conjecture accessible where the
unweighted one is not (`BARRIER.md` §2, third row: "the one known access to
Chowla-grade (bulk) content… quantitatively weak so far (logarithmic averaging
only)"). So the one genuine technique-sharing in the neighbourhood connects
Collatz to *Chowla*, a problem not on the list, by sharing a **weakening
device** rather than an obstruction. **CORPUS + FETCHED abstracts; the
methodological lineage between the two Tao results is stated here as an
observation about their two abstracts and is graded weak.**

### 4.2 Verdict on the forecast

- **P1: FAILS across the classes, HOLDS inside one pair.** The only documented
  method-level transfer among the five is Goldbach $\leftrightarrow$ twin
  primes, four times over, from four independent directions (Chen; parity;
  in-repo sector-blindness; the function-field column). Between any other pair
  of the five: none.
- **P2: FAILS.** The parity barrier is a barrier for exactly two of the five.
  It is not a barrier for FLT (which is proved, and whose proof never touches
  a sieve). It is not the barrier for RH: `FF_PAIRFIELD.md` §4's table records
  that the parity barrier **FALLS** in the function-field column via
  Sawin–Shusterman while RH is *already a theorem* there — two facts which
  together show parity and RH are separate theaters, and the note says so in
  those words ("further evidence that the charge/parity layer and the zero
  layer are separate theaters"). And it is not the barrier for Collatz, where
  no sieve is in play.

**The shared-mechanism hypothesis H₁ does not survive the transfer test.** It
survives on a sub-family of two. Registered in advance, checked against the
record: the forecast is falsified as stated for the five, and the residue is
a pair.

---

## 5. The local–global core, tested as primary

The sibling agent's proposal: all five ask *do locally admissible operations
generate a globally coherent form?*, with the obstruction at the assembly step.
The coordinator's test for technical content: **name the obstruction object,
or downgrade.** Applied honestly.

### 5.1 The in-house anchor, which is a real instance

`RECIPROCAL_TRACE_CAGE.md` §3 records a genuine local-conditions-pass /
global-object-absent failure found by this repository. With
$F_X(x)=\sum_{p\le X}x^{p-2}$ and $H_+(T)=T^3+T^2-2T-1$:
$x^3H_+(x+x^{-1})=\Phi_7(x)$, which satisfies **every** condition the cage
imposes — trace roots in $(-2,2)$, the coefficient cage, unit constant term,
parity resultant $1$ — and **divides no $F_X$ whatsoever**. The witness is
explicit and finite: $F_X(\zeta)=0$ at a primitive seventh root would force the
seven counts of exponents $p-2 \bmod 7$ to be equal, and the note exhibits the
count inequality in each of three ranges of $X$. `RECIPROCAL_SEXTIC.md` §3
supplies the companion mod-$3$ and mod-$5$ unit-ideal obstructions
$\gcd(a^2+b^2-abc,\,b^2-a^2)=1$ and $\gcd(b,c,a^2-1)=1$.
`CROSS_LENS.md` §6 item 6 flags this as an unfiled Hasse-principle failure and
is correct to.

This is what an obstruction **object** looks like: a residue-count witness,
finite, checkable, and fatal. Hold it as the standard of evidence for the rest
of §5. It is also the note's positive control — a verifier that names no
objects anywhere is worthless, and this one names one.

### 5.2 FLT

**Local data:** real and $p$-adic points; the conductor and ramification data
of the Frey curve. **Assembly:** modularity. **Object: YES, two of them, and
neither is a gluing class.**

- Kummer's obstruction (historical): $p \mid h(\mathbb{Q}(\zeta_p))$ — the
  irregular primes. A real, computable object; a nonzero receptacle (the class
  group) that is charge-blind for irregular $p$. (**CLASSICAL**,
  **UNVERIFIED-MEMORY** for the citation.)
- The killing object: $S_2(\Gamma_0(2)) = 0$. An **empty receptacle**.

**But the Hasse-principle framing is not the mechanism, and saying so is
important.** The Fermat curve is not a counterexample to the Hasse principle in
any usable sense; local solvability is not what fails, and no Brauer–Manin-type
class is what Wiles computed. The mechanism is the sibling's own better phrase
— *the impossible concurrence of two presentations of one global object* — and
that is a **global-to-global rigidity**, not a local-to-global gluing failure.
The two descriptions (Galois representation of the Frey curve; modular form of
the forced level and weight) are both global. The corpus already has the
general name for this: `CROSS_LENS.md` §8, "both programs, and the foundational
cluster, are computing the same object: the automorphism group of a
presentation."

### 5.3 Goldbach and twin primes

**Local data:** the singular series — $\mathfrak{S}(N)>0$ for every even $N$;
the Hardy–Littlewood $\mathfrak{S}$ for the twin case. **Assembly:** the minor
arcs. **Object: YES, but of the wrong type.**

The named object is the $\mathbb{Z}/2$ parity charge, and this corpus states it
in its sharpest available form: `GAUGE.md` Theorem F — the unique KMS state of
the critical affine system vanishes identically on every nontrivial isotypic
sector of the gauge torus, so **every parity-odd observable has exactly zero
equilibrium expectation**, and (that note's own words) "the sieve parity
barrier is the statement that equilibrium expectations of gauge-charged
observables vanish identically… not a deficiency of technique but an exact
invariance."

That is an obstruction object. It is not a gluing obstruction. It says the
local data is **insufficient** to determine the global answer, not that the
local data is **incoherent**. Those are different failure modes and the
distinction is the whole content of the lens calculus's second and third
verdicts (§6). The minor arcs, meanwhile, are not an object at all: they are an
error term that is not known to be small. Calling an uncontrolled error term an
"obstruction" is naming a difficulty, not naming an object.

### 5.4 RH and Collatz

**RH.** Local data: the Euler factors. Assembly: analytic continuation and the
functional equation. **Object: NONE — and worse, the assembly step is a
theorem.** The functional equation is proved; the continuation is proved; the
"assembly" the framing points to is precisely the part of RH that is *not*
open. What is open is the location of the zeros of an assembled object that
exists. The framing points at the wrong step.

**Collatz.** Local data: every step is admissible. Assembly: the global orbit
structure. **Object: NONE.** One candidate exists and it undercuts rather than
supports the framing: the Bernstein–Lagarias conjugacy makes the $2$-adic
presentation a full shift, which is an **annihilation certificate for that one
probe class** (the presentation is complete and carries zero information about
$\mathbb{N}$), not a gluing class.

### 5.5 The asymmetry the framing was supposed to explain — and what does explain it

Prediction **P5**: H₂ should explain why modularity closed FLT and did nothing
for Goldbach. **It does not.** Under H₂ both are gluing questions and both
should be susceptible to a technique that produces global objects from local
data; the framing has no resource for distinguishing them.

**A different criterion does, and it is sharp.**

> **Criterion R (rigid-object criterion, HERE).** A method of the
> Frey–Ribet–Wiles type applies to a problem $\Pi$ only if a hypothetical
> counterexample to $\Pi$ **generates a finitely-presented global object in a
> category whose relevant moduli can be shown to be empty**.

Apply it:

| problem | does a counterexample generate a rigid global object? | outcome |
|---|---|---|
| FLT | **yes** — the Frey curve, semistable, with computable conductor | **closed** by exactly this route |
| Goldbach | no — a failing even $N$ generates $N$ and nothing more † | untouched |
| twin primes | no — a last twin pair generates nothing | untouched |
| RH | no — an off-line zero generates a zero; no rigid moduli | untouched |
| Collatz, divergent orbit | no | untouched |
| **Collatz, nontrivial cycle** | **yes** — an exponential Diophantine relation among powers of $2$ and $3$ | **partially closed by exactly this route** |

The last row is the positive control and it was not constructed to fit.
Simons–de Weger (§2.5, FETCHED) exclude nontrivial $m$-cycles for
$1\le m\le68$ using "transcendental number theory, computational diophantine
approximation techniques" — the FLT-adjacent toolkit, applied to the one
sub-problem of the five's open members where a counterexample *does* manufacture
a rigid object. **The criterion discriminates: it predicts exactly one place
where the FLT machinery should bite among the open problems, and that is
exactly where it has bitten.** The local–global framing predicts nothing of the
kind, because under it the cycle problem and the divergence problem look
identical.

Criterion R also, unprompted, explains the direction-of-existence asymmetry:
FLT and the $\Phi_7$ instance are **non-existence** statements proved by
exhibiting an empty receptacle; the four open problems are **existence or
regularity** assertions (RH: the assembly *is* coherent; Goldbach: a
representation *exists*; twin primes: infinitely many *exist*; Collatz: one
basin). A framework whose only two worked instances are non-existence proofs
via emptiness offers nothing to an existence proof. *FLT is not a model for
the other four; it is the opposite case.*

† See §5.5.1: a Frey curve *does* attach to Goldbach, on the opposite polarity.
The row stands as written; the footnote exists because it was written without
knowledge of the construction.

### 5.5.1 A Frey curve attached to Goldbach exists — on the other polarity (appended 2026-08-14, `cf-tessera`)

The table above was written without knowledge of the following construction,
handed back for adjudication by the SEARCH sweep of 2026-08-14
(§10 item 4's dated append; `collab/messages/0458` §5). It is recorded here
because a reader who meets it elsewhere must not have to wonder whether this
note missed it. **Verdict up front: F5 is not falsified, the Goldbach row
stands verbatim, and Criterion R gains one clarifying clause and its first
negative control.**

**The construction** (**FETCHED at search-summary level**; see the grade line
below). Dieulefait, Jiménez Urroz and Ribet, *Modular forms with large
coefficient fields via congruences*, **arXiv:1111.5592**, published *Research
in Number Theory* **1** (2015), art. 2. Writing $2^{\ell+4}=p+q$ with $p,q$
prime, the curve
$$F:\; y^2=x(x-p)(x+2^{\ell+4})$$
is semistable with minimal discriminant $\Delta=(2^{\ell}pq)^2$ and conductor
$2pq$; by Wiles's modularity of semistable curves there is a newform of weight
$2$ and level $2pq$ attached to it. The authors' own description of the family
is "Frey curves of **Fermat–Goldbach** type", and for their $t\ge 3$ case the
construction is (their words, as reported) "related to Chen's celebrated
results on (a partial answer to) Goldbach's conjecture and inspired by Frey
curves as in the proof of Fermat's Last Theorem".

**Why Criterion R is untouched, in three steps, none of which is the mere
observation that the polarities differ.**

1. **Quantifier.** R quantifies over *counterexamples*: it asks what a failing
   even $N$ generates. This curve is attached to a *representation* — an
   $N$ that Goldbach **satisfies**. A failing $N$ supplies no pair $(p,q)$, so
   the construction has no input and produces no curve. The row's content —
   *a failing even $N$ generates $N$ and nothing more* — is exactly what is
   still true.
2. **Direction of inference.** In the FLT use, the curve is a *consequence* of
   the hypothetical solution and the arithmetic statement is the *conclusion*.
   Here Goldbach (or, unconditionally, Chen 1973) is the *hypothesis* and the
   conclusion is a statement about **newforms** — coefficient fields of large
   degree at almost square-free level. The inference runs
   arithmetic $\to$ modular forms; R is a criterion about the return trip.
   Nothing in the paper is a theorem about Goldbach, and the paper does not
   claim otherwise.
3. **No emptiness to exploit, and no inverse.** R's operative half is not
   "an object exists" but "*whose relevant moduli can be shown to be empty*".
   Here $S_2(\Gamma_0(2pq))$ is nonempty and the newform's existence is
   guaranteed rather than contradictory: the receptacle is full, so nothing is
   excluded. Nor can the map be run backwards to *produce* a representation:
   the level $2pq$ is a function of the very decomposition sought, so choosing
   which space to search already requires knowing $p$ and $q$. The
   construction is therefore not even a search reduction.

**What R gains.** §5.5 offered a positive control (the Collatz-cycle row, where
R predicts the FLT toolkit should bite and it does). It now has a **negative
control it did not construct**: a genuine Frey-package construction that
touches Goldbach and that R declines, for a reason stated before the
construction was known. A criterion that says *no* to a real nearby object is
better tested than one that has only ever been applied to objects chosen for it.

**The one clause R should carry explicitly** — a clarification, not a retreat,
since both halves were already in the statement and are only now separately
load-bearing:

> **Criterion R, polarity clause (HERE).** The two conditions are separately
> necessary. (i) The object must be generated by the **counterexample**; an
> object generated by an *instance* of $\Pi$ carries the inference in the
> opposite direction and yields no contradiction. (ii) The relevant moduli
> must be shown **empty**; a construction landing in a nonempty space of
> newforms proves the space is inhabited, which is the negation of the
> mechanism, not a weak form of it.

**Where the note's other two uses of R stand.** R is invoked outside §5.5 in
exactly two places, and both survive **verbatim**, with one word now doing
real work: §4.1 ("the input to the method is a global algebro-geometric object
attached to a *hypothetical* solution") and §7.3 ("the *rigid global object
attached to a hypothetical solution* property of Criterion R"). Read
"hypothetical solution" as *a solution whose existence the argument intends to
refute* — which is how both sentences use it — and the Fermat–Goldbach curve,
attached to an actual decomposition, is correctly outside the FLT family in
§7.3 and correctly not a transfer in §4.1. **No verdict in §§3–7 changes.**
The note is clean on this point; it is recorded rather than merely asserted
because the phrase was decorative when written and is load-bearing now.

**A near miss on F2, recorded and not fired.** The paper does compose the two
toolkits: Chen's sieve theorem is an *input* to a modular-method argument. F2
asks for a documented **method-level transfer between two of the five classes**
— a method from one class making progress on a problem in another. The
conclusion here lies in neither class (it is a theorem about newforms), and
nothing returns from the modular lane to the additive one. F2 does not fire.
It is written down so that a later reader who locates the paper knows it was
seen and weighed.

**Searched specifically, and negative.** Queries run 2026-08-14: *Frey curve
Goldbach representation modular*; *elliptic curve $p+q=2^n$ conductor $2pq$*;
*Goldbach modularity newform level $2pq$*; *Frey curve attached to
counterexample Goldbach conjecture modular method level lowering*; *Goldbach
counterexample Galois representation rigid object*. **No located construction
attaches a rigid global object of any kind to a Goldbach or twin-prime
counterexample.** F5's discharge condition remains undischarged.

**Grade.** **arXiv:1111.5592 is CONFIRMED at search-summary level** — title,
the three authors, the November 2011 posting and the *Research in Number
Theory* 1 (2015) art. 2 publication all match, and the paper's abstract
mentions Frey curves of Fermat–Goldbach type; the sweep's tentative
attribution was correct. Everything above is nonetheless **śabda grade**: the
curve equation, discriminant, conductor and level are as reported by search
summaries of the paper's text, **no PDF was read** (`WebFetch` is
`EGRESS_BLOCKED` on every host in this container), and no claim in this note
rests on the arithmetic being exactly as quoted — the adjudication of F5 goes
through on the polarity alone, which no reading of the paper can change.
arXiv:0812.0930 remains located and unassessed; nothing here uses it.

### 5.6 The trap, addressed head-on

The coordinator's warning is correct and it is fatal to H₂ as a classification.

**Nearly every open problem in mathematics can be cast as local-versus-global.**
P vs NP (local gate structure vs global computational power); Navier–Stokes
regularity (local well-posedness vs global existence); the Hodge conjecture
(local Hodge-type data vs global algebraic cycles); BSD (local $L$-factors vs
global rank); the existence of odd perfect numbers (local congruence conditions
vs a global integer); the inverse Galois problem; Jacobian conjecture. A cast
that covers everything partitions nothing.

State it as an information bound. **A classification's content is the number of
bits it removes: $\log_2(1/\text{fraction of the universe assigned to the
class})$. A class containing essentially the entire universe of open problems
carries essentially zero bits.** H₂ assigns all five to one class and would
assign the rest of the open-problem universe there too. It carries no bits
about the five.

The object test makes this concrete: 2 nameable objects out of 6 instances
(FLT, $\Phi_7$), and both of those objects are of a *different kind* from each
other and from the parity charge — an empty space of modular forms, a residue
count, a gauge charge. Three different kinds of object across three problems is
not one mechanism; it is three mechanisms with one English sentence draped
across them.

**Verdict on H₂: real as a description, empty as a classification. Downgraded
per the coordinator's own instruction.** The sibling's sharper observation
about FLT — the impossible concurrence of two presentations — is genuinely
better than the Hasse framing and is retained; it is just not local–global, and
it applies to exactly one of the five.

### 5.7 The seven-problem vacuity test, adjudicated

The framing was subsequently extended to **seven** problems, adding
Navier–Stokes global regularity, P vs NP, and quantum gravity, each
characterised as a *translation obstruction*:

| | problem | framing's characterisation |
|---|---|---|
| 1 | RH | prime locality and the global spectrum not yet fully joined |
| 2 | Goldbach | residual between local possibility, average distribution, sharp sum bound |
| 3 | twin primes | the sieve sees many distinctions but not the decisive parity distinction |
| 4 | Collatz | gap between symbolic history and metric drift |
| 5 | Navier–Stokes | a local differential law does not yield global regularity |
| 6 | P vs NP | cheapness of verification does not yield cheapness of construction |
| 7 | quantum gravity | two successful representations, each true in its domain, not yet glued |

The stated fork: if it covers all seven, then either **(i)** it is a universal
structural insight, or **(ii)** it is so general that it distinguishes nothing.
Adjudicated below: **(ii)**, on four independent grounds, the first of which is
decisive on its own.

#### Ground 1 — the framing cannot distinguish a theorem from a conjecture

Apply it to **ternary Goldbach**, which is *proved* (Vinogradov; Helfgott,
§2.3). The framing's row 2 characterisation — "a residual between local
possibility, average distribution, and a sharp sum bound" — describes ternary
Goldbach **verbatim and without alteration**. The singular series is the local
possibility; the major arcs are the average distribution; the minor-arc bound
is the sharp sum bound. Same description, same three ingredients, same
assembly; one is a theorem and one is open. The difference between them is the
arity of the minor-arc estimate (§4.1), which the framing does not mention and
cannot see.

The same test kills row 6 from the other side. "Cheapness of verification does
not yield cheapness of construction" is also a correct description of every
*proved* separation of this type — and complexity theory has proved several
(e.g. time and space hierarchy theorems separate classes by exactly this kind
of construction/verification asymmetry; **UNVERIFIED-MEMORY** for citations,
and nothing here depends on the example).

> **A characterisation that assigns the same description to a proved theorem and
> to an open conjecture carries zero information about difficulty.** This is not
> a philosophical objection; it is a falsification, executed on a member of the
> framing's own list.

#### Ground 2 — the object test, run on all seven

The coordinator's discriminating question: name a specific obstruction
**object**, or concede only the word. Run twice, because the two readings give
different and equally informative answers.

| | problem | object of the type the framing predicts (a gluing / non-translation witness) | any named obstruction object at all |
|---|---|---|---|
| 1 | RH | **none** | **none.** The assembly (continuation, functional equation) is a *theorem*; what is open is a location, not a gluing |
| 2 | Goldbach | **none** | **yes** — the $\mathbb{Z}/2$ parity charge, `GAUGE.md` Thm F (exactly zero equilibrium expectation on every charged observable) |
| 3 | twin primes | **none** | **yes** — same charge, same theorem |
| 4 | Collatz | **none** | **none.** The one candidate (the $2$-adic conjugacy to the full shift) is an annihilation certificate for a single probe class, not a gluing class |
| 5 | Navier–Stokes | **none** | **yes** — Tao's averaged equation: a modification obeying *the same energy identity and the same cancellation condition* which blows up in finite time (**FETCHED at search-summary level**: T. Tao, *Finite time blowup for an averaged three-dimensional Navier–Stokes equation*, J. Amer. Math. Soc. **29** (2016), 601–674, arXiv:1402.0290). An explicit witness that energy plus scaling cannot decide regularity |
| 6 | P vs NP | **none** | **yes, three** — relativization (Baker–Gill–Solovay, *Relativizations of the P=?NP question*, SIAM J. Comput. **4** (1975), 431–442: oracles $A,B$ with $\mathrm{P}^A=\mathrm{NP}^A$ and $\mathrm{P}^B\ne\mathrm{NP}^B$); natural proofs (Razborov–Rudich, *Natural proofs*, JCSS **55** (1997), 24–35); algebrization (Aaronson–Wigderson, *Algebrization: a new barrier in complexity theory*, ACM TOCT **1** (2009), art. 2). All **FETCHED at search-summary level** |
| 7 | quantum gravity | **none** | **partial, and for a different question** — the nonvanishing two-loop counterterm of pure Einstein gravity (Goroff–Sagnotti; **UNVERIFIED-MEMORY**, cited as an example only) is an object, but it obstructs *perturbative renormalizability of pure gravity*, not "quantum gravity", which has no statement to obstruct |

**Score: 0 of 7 on the framing's own terms.** Not one of the seven yields a
gluing obstruction, a non-translation witness, or a class in a cohomology of
local data. Under the loose reading, 4½ of 7 yield *some* object — and every
single one of those objects is an **annihilation or low-rung** certificate in
the lens calculus's sense (§6), never a relocation-of-a-gluing-class and never
a Hasse-type obstruction. The framing predicts one type of object and the
record contains a different type, seven times out of seven.

**And the objects that exist are five different kinds of thing:** a gauge
charge on a C\*-algebraic equilibrium state; a modified PDE with matching
conservation laws; an oracle separation; a largeness-plus-constructivity
property conditional on pseudorandom generators; a two-loop counterterm
coefficient. Five kinds across four problems is not one mechanism. It is four
mechanisms with one English sentence draped across them — the same verdict as
§5.6, now with a larger sample and a worse ratio.

#### Ground 3 — the class is (nearly) the universe, stated as a criterion

> **Observation (HERE).** Any conjecture asserting a global property of an
> infinite structure that is *generated by finitary local data* can be phrased
> as "local data does not visibly yield the global property."

$\mathbb{N}$ is generated by the successor (chart (a)); a PDE is defined by a
local differential law; a computation is defined by local gate structure; a
field theory is defined by a local Lagrangian. The hypothesis of the
observation is satisfied by essentially every object mathematics studies, so
the framing's class is essentially the universe of conjectures about them. By
the information bound of §5.6 — a classification's content is
$\log_2(1/\text{fraction assigned to the class})$ — its content is
approximately zero bits. Adding two physics problems and one complexity problem
to the list does not test universality; it **measures** it, and the measurement
is the finding.

#### Ground 4 — one member of the list is not a mathematical statement

"Quantum gravity" is a research programme, not a conjecture: it has no
statement, hence no truth value, hence nothing that could be obstructed. A
classification that admits a non-statement alongside six statements is not
sorting by mathematical structure — it is sorting by *the feeling of an
unresolved juxtaposition*. That feeling is real and is worth having; it is not
a classification, and treating it as one is precisely the promotion chain
`MILLENNIUM_ROSETTA.md` catalogues (introduce a metaphorical invariant; omit a
typed map; assume preservation; promote to axiom).

#### Adjudication

**(ii). The local-to-global framing is so general that it distinguishes
nothing.** It fails on a member of its own list (Ground 1), scores 0/7 on its
own predicted object type (Ground 2), covers a class that is nearly the
universe (Ground 3), and admits a non-statement (Ground 4). Per the
coordinator's instruction — *if five of seven yield only the word, rule (b)* —
the count is worse than the threshold: **seven of seven yield only the word for
the type of object the framing predicts.**

**What survives, and it is worth keeping.** The framing is an excellent
*index*: it says where each problem's difficulty is *felt*, and that is
genuinely useful for orientation. What it does not do is say what kind of thing
the difficulty *is*, and the lens calculus (§6) does exactly that, gives
different answers for different members, and can be caught being wrong.
Retain the framing as an index; refuse it as a classification.

---

## 6. The distinction that survives: classifying each barrier

Techniques do not transfer (§4). The obstruction might still be shared. The
lens calculus (`CROSS_LENS.md` §5) supplies exactly three verdicts, each
instantiating the four-slot object *(probe class $\mathcal{C}$, twirl/quotient
$E$, charge group $\mathrm{Ch}$, receptacle $R$)*:

1. **low rung** — $\mathcal{C}$ is small enough that the charge is provably
   orthogonal to it (`LENS_CIRCUIT.md` Thms 1/1″/2);
2. **annihilation** — the charge dies inside $E$ before any receptacle can hold
   it (`TOY_OBSTRUCTION.md`, `KBOUNDARY.md`, `GAUGE.md`) — parity is the
   canonical case;
3. **relocation** — the receptacle is nonzero and faithful but charge-blind;
   the wall moves, with coordinates (`LENS_REGULARITY.md` Props 7–8).

| # | problem | verdict | probe class $\mathcal{C}$ | quotient $E$ | receptacle $R$ |
|---|---|---|---|---|---|
| 1 | **FLT** | **relocation, twice, then resolved by an empty receptacle** | cyclotomic ideal arithmetic → Galois representations | reduction mod $p$ / level lowering | class group $h(\mathbb{Q}(\zeta_p))$ (nonzero, charge-blind at irregular $p$) → $S_2(\Gamma_0(2)) = 0$ |
| 2 | **twin primes** | **annihilation** | classical sieve / finite-multiplicative probes | the neutral-sector projection; equivalently $E_Q$ at level $Q$ | none — `GAUGE.md` Thm F: charged sector has identically zero equilibrium expectation |
| 3 | **Goldbach** | **annihilation + a low rung** | as (2), plus the binary circle method | as (2) | as (2); *and separately*, the arity-$2$ minor arc admits no $L^2\cdot L^\infty$ split (low rung of the circle-method ladder, since arity $3$ suffices) |
| 4 | **RH** | **relocation** | windowed-linear WL$_d(L,r)$; sieve probes | blurring at resolution $2\pi/L$ (`BARRIER.md` Thm B1/Cor B2/Prop B3) | nonzero and faithful — Hermitian-square/Krein positivity, which `FF_PAIRFIELD.md` §3 identifies as "exactly where RH lives" and proves unconditionally in the function-field column |
| 5 | **Collatz** | **low rung** | density/measure arguments; $2$-adic dynamics; Diophantine approximation (cycles only) | logarithmic density; the $2$-adic conjugacy | the conclusion is a pointwise $\Pi_2$ well-foundedness statement, orthogonal to every density-graded probe deployed |

**Why RH is relocation and not annihilation.** An annihilation verdict requires
the information to be destroyed by a quotient. The information is not destroyed:
`FF_PAIRFIELD.md` §3 exhibits a column where the RH-carrying object (positive
definiteness of $c_m=s_m/q^{m/2}$, via Herglotz/Carathéodory–Toeplitz) is
faithful, unconditionally true, and instantly detects a fake Weil number that
passes the naive integrality/positivity sieve at every depth $d\le40$. A
faithful receptacle that discriminates is the definition of relocation.
`BARRIER.md` supplies the coordinates: within the WL class the depth law
$L\gtrsim\kappa\,2\pi\rho_2(2T)$ "is not an artifact of our methods — it is the
information geometry of the class." The wall has a position, and moving the
class moves it.

**Why Collatz is low rung and not annihilation.** The candidate annihilation —
the $2$-adic conjugacy to the full shift — is an annihilation *for one probe
class*, not for the problem: it says the $2$-adic presentation carries zero
information about $\mathbb{N}\subset\mathbb{Z}_2$. It does not say that every
presentation does, and §5.5's cycle row is a live counterexample to the strong
reading, since Diophantine approximation reaches genuine cycle exclusion. The
honest verdict is that the probe classes deployed are graded by density and
the conclusion is pointwise; that is a rung, not a wall. Conway's undecidability
of the *generalised* family (§2.5) is a low-rung certificate at the level of the
problem class and must not be read as one for $3n+1$.

### 6.1 What would falsify each classification

These falsify **the classification**, not the problems. They are stated so the
classification can be killed, per msg 0073 §2.

| row | falsified by |
|---|---|
| 1 (FLT: relocation→empty receptacle) | a proof of FLT that never leaves $(\mathbb{N},+,\times)$ or its algebraic extensions and computes no moduli — which would show the relocation was avoidable and the receptacle irrelevant |
| 2 (twin primes: annihilation) | any unconditional *individual* estimate $\max_a|D_\lambda(X;q,a)| = o(X/q)$ for an infinite sequence of moduli $q\sim X^{1/2+\varepsilon}$ (`WIDTH.md` §3's open question) — the charge would then be visible to a finite-place probe, downgrading the verdict to relocation |
| 3 (Goldbach: annihilation + low rung) | an unconditional binary minor-arc bound below the main term, which would kill the low-rung half while leaving the annihilation half; or the §2 falsifier, which kills the other half. **The two halves are independently falsifiable, which is what makes the split a claim rather than a hedge.** |
| 4 (RH: relocation) | exhibiting two admissible zero configurations — both satisfying $N(T)\sim\frac{T}{2\pi}\log\frac{T}{2\pi}$ and the functional-equation constraints — indistinguishable to all WL$_d(L,\mathrm{poly})$ observables but with different pair correlations (`BARRIER.md`'s stated open problem). That would upgrade RH's verdict from relocation to annihilation and would falsify this row. |
| 5 (Collatz: low rung) | a theorem of `GAUGE.md` Theorem F's exact shape for Collatz: a canonical quotient through which all deployed methods factor, on which the termination charge has identically zero expectation. That would make it annihilation. |
| the whole table | any *single* verdict shared by four or more of the five, which would restore H₁ |

**Positive control on the classification.** The scheme is not
verdict-monotone: it assigns three different verdicts across five problems, it
assigns *two* verdicts to one problem (row 3) with independent falsifiers, and
it refuses the annihilation verdict for RH and Collatz on evidence
(`FF_PAIRFIELD.md` §3 for RH; §5.5's cycle row for Collatz) rather than by
default. A scheme that returned "annihilation" for everything would be
worthless; this one discriminates and can be caught doing so.

---

## 7. The verdict

The options as posed: **(a)** genuine common obstruction, precisely stateable;
**(b)** shared shape only, real but with no technical content and no
predictions; **(c)** an artifact of fame.

### 7.1 (a) is refused, and here is what it would have had to say

For (a) to hold, one would have to write the shared statement. The best
candidate the analysis produced is:

> *Each of the five is a statement that is not expressible in any single chart
> of $\mathbb{N}$: each requires a transition whose residual is non-trivial.*

This is **true** for all five (§3), and it is **empty**. Every transition in
`ATLAS_OF_N.md`'s table except $(a)\leftrightarrow(b)$ has a non-trivial
residual; the statement therefore excludes only those assertions expressible in
one chart, which is nearly nothing of interest. It also fails to be a *common*
statement in the required sense, because the residuals are **different**:
addition for Goldbach/twin primes (Residual 2.6); addition-but-with a
$\operatorname{Sym}(P)$-invariant hypothesis, hence no straddle where it counts,
for FLT (Prop. 3.1); the archimedean absolute value for RH, which is not a
chart residual at all (Thm 5.3); induction for Collatz (Thm 5.1). Four
residuals, five problems, and the two that share one are the two that
everything else in this note also pairs.

**(a) is refused.**

### 7.2 (b) is the verdict for the residual resemblance

There is a real shared shape and it should be stated exactly, with its own
guardrail attached:

> **The shape (true, and carrying no technical content).** All five are
> statements about $\mathbb{N}$ whose hypothesis and conclusion sit on opposite
> sides of a chart transition, so that none is expressible in a single
> presentation of $\mathbb{N}$. In four of the five, one side is the
> multiplicative presentation (chart (f)).
>
> **Guardrail (inherited verbatim from `ATLAS_OF_N.md` Cor. 2.13.1).** This is
> a statement about the expressive weakness of charts. It is not an explanation
> of, and implies nothing whatsoever about, the difficulty of any of the five.

The shape predicts nothing, as §§4–6 establish empirically: it does not predict
which barrier each problem meets (three different verdicts, §6), it does not
predict transfer (one pair out of ten, §4), and it does not predict where an
obstruction object exists (two out of six, §5).

### 7.3 (c) is the verdict for the *boundary* of the list, and it should be said bluntly

The list of five is not a mathematically natural family, and the evidence is
that a natural family containing any of its members contains different things.

- A natural family containing **twin primes** contains: de Polignac's
  conjecture for every even gap, the Hardy–Littlewood $k$-tuple conjecture,
  Sophie Germain primes, Chowla's conjecture, Goldbach — all sharing the
  singular series, the parity barrier, and the sector-blindness of
  `ADELIC.md` Prop E1. That family has a defining property and the five do not
  intersect it beyond two members.
- A natural family containing **FLT** contains: the Beal, Fermat–Catalan and
  $abc$ circles, the modularity-lifting programme, Mordell/Faltings — all
  sharing the "rigid global object attached to a hypothetical solution"
  property of Criterion R. Goldbach, twin primes and RH are not in it.
- A natural family containing **Collatz** contains: $qn+1$ problems,
  generalised Collatz/FRACTRAN, arithmetic dynamics on $\hat{\mathbb{Z}}$ —
  and none of the other four.
- **RH** sits in the family of $L$-function zero-location problems (GRH,
  Chowla adjacency, Weil positivity), where the function-field column is a
  theorem and the parity barrier's fall (Sawin–Shusterman) is *independent* of
  the zero side — this corpus's own finding that they are "separate theaters"
  (`FF_PAIRFIELD.md` §5).

Four natural families, pairwise almost disjoint, and the proposed list of five
takes one or two representatives from each. **The property actually shared by
exactly these five, and by no sixth problem of comparable structure, is
celebrity.** That is verdict (c), and per the brief it is stated bluntly
because it is the most useful of the three outcomes: it tells a research
programme not to spend effort looking for the unifying mechanism, because the
set was not assembled by a mechanism.

### 7.4 What is rescued: a family of two, at (a)-grade

The one grouping that meets the standard of (a) is:

> **Goldbach and twin primes are the same problem at every finite place.**
> Their local data is the same singular series up to the sector choice
> (`ADELIC.md` Prop E1, `FF.md` Thm 2, as recorded in `CROSS_LENS.md` §4: the
> singular series is sector-blind and "the $S/D$ distinction is the choice of
> positive cone, i.e. archimedean"); they sit at the same position in the atlas
> with the same residual (§3.2); their barrier is the same annihilation, with
> the same $\mathbb{Z}/2$ charge and the same exact-invariance statement
> (`GAUGE.md` Thm F); a single sieve method reaches the same distance on both
> (Chen 1973); and in the column where the barrier falls, it falls for both in
> one theorem (Sawin–Shusterman, `FF_PAIRFIELD.md` §5).

Five independent lines of evidence, four of them already in this corpus and
none of them assembled for this purpose. That is what (a)-grade evidence looks
like, and its scope is two problems, not five.

### 7.5 The mixed-term criterion applied to this note's own verdict

The protocol of §9 requires that any proposed unification build a third object
containing both views and exhibit a **mixed term** invisible to either view
separately; a zero mixed term means the unification is an independent
juxtaposition and must be dropped. Applied to my own claims, hostilely, before
anyone else does it.

**Attempt 1 — the five (or seven) jointly.** The two strongest joint objects
available:

- *The semiring.* Take $(\mathbb{N},+,\times)$ presented simultaneously in
  charts (b) and (f), and let the mixed term be a quantity visible only in the
  joint presentation — the additive–multiplicative correlations
  $\sum_n \Lambda(n)\Lambda(N-n)$ and their relatives. **This mixed term is
  nonzero — but only for a subset.** It is the content of Goldbach and twin
  primes; it is *not* the content of FLT (Prop. 3.1: FLT's multiplicative side
  is $\operatorname{Sym}(P)$-invariant, so no prime-selection crosses the
  transition); it is not the content of Collatz (residual: induction, not
  addition); and for RH the corresponding object is the one-body sum
  $\sum_{n\le X}\lambda(n)$, not a pair term. A mixed term supported on a
  sub-family *is* the sub-family. Independent confirmation of §7.4 by a route
  that did not assume it.
- *The seven-fold version.* To have a nonzero mixed term one needs an ambient
  in which two members' local data actually interact — a product structure, a
  pairing, a common deformation. The local data of the prime problems lives in
  $\hat{\mathbb{Z}}$ and its representations; the local data of Navier–Stokes
  lives in jets of a vector field on $\mathbb{R}^3$; the local data of P vs NP
  lives in bounded-depth circuit structure. No ambient with a nonzero pairing
  between any two of these has been exhibited, and the only ambients that
  visibly contain all three — "the set of open problems", a proof-theoretic
  strength ordering — carry the *categorical product*, whose cross term is
  identically zero by construction. **Mixed term zero. Per the criterion, the
  seven-fold unification is an independent juxtaposition and is dropped.**

This is stated as a challenge, not as a theorem: nobody has exhibited a mixed
term, I attempted the two strongest constructions I could build and both give
zero, and the criterion places the burden on the unifier. §10 lists what would
discharge it.

**Attempt 2 — my own rescued pair, which does not escape scrutiny.** Does
Goldbach $\otimes$ twin primes carry a nonzero mixed term? Honestly: **no** —
and the reason is instructive rather than damning. `ADELIC.md` Prop E1 (via
`CROSS_LENS.md` §4) says the singular series is *sector-blind*: the two are
**isomorphic at every finite place**, differing only in the choice of positive
cone at the archimedean one. When two views coincide, there is no third object
to build and no cross term to compute — one does not unify $X$ with $X$.

This exposes a genuine gap in the criterion as stated, and I propose an
amendment rather than exploiting it silently:

> **Amendment (HERE): the mixed-term test has three outcomes, not two.**
> **(i) nonzero** — genuine unification, new content.
> **(ii) zero** — independent juxtaposition; drop it.
> **(iii) degenerate** — the two views are *identical*, so the joint object
> collapses to one factor. This is not a unification but an **identification**,
> and its content lies entirely in whatever distinguishes the two
> presentations of the one object.
>
> **The discipline that stops (iii) from being a loophole:** outcome (iii) may
> be claimed *only* on an **exhibited isomorphism**, never on a resemblance.
> Absent an exhibited isomorphism, the verdict defaults to (ii) and the
> unification is dropped.

Goldbach/twin primes qualifies for (iii) because the isomorphism is exhibited
and independently checked (`ADELIC.md` Prop E1; `FF.md` Thm 2; and
constructively in the function-field column, where one theorem gives both,
`FF_PAIRFIELD.md` §5). The residue — what the identification leaves over — is
exactly the archimedean cone choice, which is where §3.3, §6 and
`CROSS_LENS.md` §4 all independently locate the remaining difficulty.

`CROSS_LENS.md` §3's "reflection join" (one $\mathbb{Z}/2$ appearing in four
vocabularies with no cross-citation) is a second instance of outcome (iii), and
`ATLAS_OF_N.md` §6 is a worked instance of outcome (ii): the proposed
decategorification/chart-swap crystal was **refuted** — $D^2$ is undefined,
the four-corner square cannot be built — and that note dropped it. The corpus
was already running this protocol before it was written down.

**Consequence for the verdict.** My strongest positive claim (§7.4) survives
only under outcome (iii), i.e. as an *identification* rather than a
unification, and it is stated that way. The five-fold and seven-fold claims
produce a zero mixed term and are dropped. **That is (b), reached by the
criterion's own machinery rather than by family resemblance, and it is stated
plainly here so no reader has to infer it.**

---

## 8. The historical hypothesis, briefly and with the line drawn exactly

Could premodern mathematicians have held these results?

**What is impossible, and it is not a matter of genius.** *A proof cannot
precede its vocabulary.* The proof of FLT quantifies over elliptic curves,
Galois representations, modular forms, Hecke algebras and deformation rings —
objects constructed in the nineteenth and twentieth centuries, several of them
after 1950. There is no sense in which those objects were available earlier and
overlooked; they are not observations about numbers but constructed categories,
and the construction is the content. The same holds for RH, whose *statement*
requires the analytic continuation of a function of a complex variable, hence
requires complex analysis. A claim that a premodern mathematician "had" FLT is
not a historical claim about evidence; it is a category error about what a
proof is. This is `ATLAS_OF_N.md` Theorem 4.2's dependency argument in another
register: a construction cannot be written down until its parameters are fixed.

**What is genuinely documented, and is a different phenomenon entirely.**
Results *can* be found early, held within one tradition, and fail to reach
another — and that is transmission, not ignorance. The Kerala school founded by
Mādhava of Saṅgamagrāma (c. 1400) obtained infinite series for $\pi$, sine and
arctangent; these are recorded in the *Tantrasaṅgraha*, *Yuktibhāṣā*,
*Karaṇapaddhati* and *Sadratnamālā*. They entered Western scholarship only via
C. M. Whish, *On the Hindú quadrature of the circle, and the infinite series of
the proportion of the circumference to the diameter exhibited in the four
S'ástras, the Tantra Sangraham, Yucti Bháshá, Carana Padhati, and
Sadratnamála*, Transactions of the Royal Asiatic Society of Great Britain and
Ireland (1834), published posthumously (**FETCHED**:
https://www.cambridge.org/core/journals/transactions-of-the-royal-asiatic-society-of-great-britain-and-ireland/article/abs/xxxiii-on-the-hindu-quadrature-of-the-circle-and-the-infinite-series-of-the-proportion-of-the-circumference-to-the-diameter-exhibited-in-the-four-sastras-the-tantra-sangraham-yucti-bhasha-carana-padhati-and-sadratnamala/23BE82FE900C6496EADCA0FD8944CFBE
— title and journal confirmed; and https://mathshistory.st-andrews.ac.uk/Biographies/Whish/
for Whish's dates 1795–1833 and the posthumous publication).

**The line, drawn exactly, in both directions.**

- *Against romanticising the premodern side:* the documented achievement is
  the series and their derivations, in a specific corpus of texts, at a
  specific date. It is not calculus in the post-Newtonian sense and it is not
  any of the five. Extending "Mādhava had series" to "the five were available"
  is unsupported by anything in the record.
- *Against romanticising the modern side:* the stronger thesis that Kerala
  results were transmitted to Europe before Whish is **contested and
  unproven**. The sources retrieved this session state the position plainly:
  there is no direct documentary evidence of transmission by manuscript, only
  methodological similarity, communication routes and a compatible chronology,
  and "the case for the transmission of Kerala mathematics to Europe seems to
  require stronger evidence" (**FETCHED at search-summary level**: Almeida–
  Joseph, *Eurocentrism in the History of Mathematics: the Case of the Kerala
  School*, Race & Class 45 (2004), https://journals.sagepub.com/doi/10.1177/0306396804043866,
  and the MacTutor summary at
  https://mathshistory.st-andrews.ac.uk/Projects/Pearce/chapter-19/, which
  records the current theory as "Keralese calculus remained localised until its
  discovery by Charles Whish"). This note does not adopt the transmission
  thesis.

**The disciplined conclusion:** the documented phenomenon is *delayed
recognition of results that were correctly obtained and correctly recorded*.
That is a real, evidenced pattern, and it is not evidence about the five. The
five are not results awaiting recognition; four are open, and the fifth
required vocabulary that did not exist.

---

## 9. The unification protocol, adopted

Contributed by a sibling agent and **adopted here as a standing norm**, because
it is falsifiable, because it has a mathematical consumer in this corpus
already (msg 0073 §5 requires one), and because it caught a defect in this
note's own strongest claim (§7.5) before any auditor did.

### 9.1 The protocol

**Step 1 — see each object fully in its native form**, before any comparison.
No comparison may be made through a summary of either side.

**Step 2 — run the discriminating questions.** Same generators? Same action?
Same invariant? Same universal property? Is one a *representation* of the
other? Is one a *quotient* and the other a *refinement*? Are they boundary
values of one family? Duality? Adjunction? Deformation? Common obstruction?
Same spectral data? Shared physical realization?

**Step 3 — construct a third object containing both**, and require it to carry
a **mixed term not visible in either view separately.**

**Step 4 — read the outcome**, per the three-way amendment of §7.5:
**(i)** nonzero mixed term → new content, genuine unification;
**(ii)** zero → independent juxtaposition, drop it;
**(iii)** degenerate (the views coincide) → an *identification*, not a
unification, admissible **only on an exhibited isomorphism**; otherwise the
verdict defaults to (ii).

### 9.2 Why the mixed term is the right test, in this corpus's own terms

The criterion is not a metaphor here; the corpus contains a worked instance in
which the mixed term is computed exactly, and a second in which it vanishes and
the unification was correctly abandoned.

- **Nonzero, computed exactly.** `FF_PAIRFIELD.md` §2.2's three-layer identity
  for a genus-1 curve,
  $R^\Lambda_{A,n} = \underbrace{(n-1)q^n}_{\text{pole}\times\text{pole}}
  \underbrace{-\,2T_n}_{\text{pole}\times\text{zero}}
  + \underbrace{(n-1)s_n + 2qU_{n-2}}_{\text{zero}\times\text{zero}}$,
  is exactly a joint object of two views (pole side, zero side) whose **mixed
  block is the cross term**, with coefficient exactly $2$, verified as an
  integer identity with residual $0$ at every $2\le n\le40$ for three curves.
  §2.3 then resolves it: $T_n = \bigl((a-2)q^n + q(s_{n-1}-s_n)\bigr)/N_1$.
- **And it can vanish, on an identifiable locus** — the smooth part of the
  mixed block has an explicit zero at $a=2$, realised by the curve E3. So the
  criterion is not vacuously satisfied: a mixed term is a computable quantity
  that is generically nonzero and sometimes exactly zero, and knowing which is
  the content.
- **Zero, and correctly dropped.** `ATLAS_OF_N.md` §6: the proposed duality
  crystal pairing decategorification with the additive/multiplicative chart
  swap was **refuted** — $\pi_0$ has no canonical inverse (Baez–Dolan:
  categorification is a creative act), so $D^2$ is undefined and the square
  cannot be built. That note's verdict, "the crystal does not exist… it is
  dropped, per the charter's instruction not to force it", is Step 4(ii)
  executed before the protocol was written.

### 9.3 What adopting it costs, stated honestly

The protocol has a failure mode of its own: **outcome (iii) is a loophole**
unless policed, since any two things can be declared "the same" and thereby
excused from producing a cross term. The amendment's requirement of an
*exhibited* isomorphism is what closes it, and this note pays that price in
§7.5 — the Goldbach/twin identification is admitted only because
`ADELIC.md` Prop E1, `FF.md` Thm 2 and the function-field column supply the
isomorphism independently, and the note says explicitly that without them the
claim would default to (ii) and be dropped.

Second cost: the protocol is a filter, not a generator. It can refuse a bad
unification and cannot produce a good one. Nothing in §§5–8 was found *by* it;
it was used to kill things, which is what msg 0073 §2 asks of any apparatus.

---

## 10. Designed annihilation, and what this note did NOT establish

Per msg 0073 §2. Each row is a statement whose establishment would kill the
corresponding claim of this note.

| # | claim | falsified by |
|---|---|---|
| F1 | The five do not share one obstruction (§7.1) | a single obstruction object — one group, class, or measure-theoretic defect — with a proof that each of the five is the statement of its vanishing or non-vanishing |
| F2 | Transfer fails between the classes (§4) | one documented method-level transfer between any two of {FLT}, {Goldbach, twin primes}, {RH}, {Collatz}, other than the four pairings already recorded inside the Goldbach/twin pair |
| F3 | Collatz is not about radical invariance (§3.5) | a statement of Collatz with hypothesis and conclusion both in one $\mathbb{Z}_b$, plus a proof that the $\mathbb{Z}_{b'}$ version is inequivalent for some $\operatorname{rad}(b')\nmid\operatorname{rad}(b)$; *or* any argument distinguishing $3n+1$ from $5n+1$ using only radical-divisibility data |
| F4 | The local–global framing lacks technical content (§5.6) | naming, for each of the five, an obstruction object of a *single* kind — five instances of one construction, not three kinds across three problems |
| F5 | Criterion R explains the transfer asymmetry (§5.5) | either a Frey-type rigid global object attached to a Goldbach or twin-prime counterexample, or a demonstration that the Simons–de Weger cycle bounds do not in fact use Diophantine-approximation machinery |
| F6 | The lens-calculus verdicts of §6 | each row's own falsifier, tabulated in §6.1 |
| F7 | Goldbach and twin primes form a genuine pair (§7.4) | a proof that the singular series is *not* sector-blind, i.e. that the two differ at some finite place; or an unconditional result on one that provably cannot transfer to the other |
| F8 | FLT's mechanism is presentational rigidity, not gluing (§5.2) | a Brauer–Manin-style or descent-theoretic proof of FLT in which the obstruction is a genuine local-to-global class |
| F9 | The seven-problem framing scores 0/7 on its own object type (§5.7) | naming, for any one of the seven, a genuine gluing obstruction — a class in a cohomology of local data whose non-vanishing *is* the problem's difficulty. One instance downgrades the score; three would restore the framing |
| F10 | Ground 1 — the framing cannot separate a theorem from a conjecture (§5.7) | a formulation of the framing under which ternary and binary Goldbach receive *different* characterisations, derived from the framing rather than appended to it |
| F11 | The joint object has zero mixed term (§7.5) | exhibiting an ambient containing the local data of any two of the seven with a **nonzero** pairing between them — the criterion's own discharge condition, and the single most direct way to overturn this note |
| F12 | The three-outcome amendment is not a loophole (§7.5, §9.3) | any use of outcome (iii) in this note that rests on a resemblance rather than an exhibited isomorphism. Only one such use is made (Goldbach/twin, §7.4), and its isomorphism is cited to three independent in-corpus sources |

### What this note did NOT establish

1. **No progress on any of the five, and no proof strategy for any of them.**
   Nothing here is a route. §6.1's falsifiers are tests of a classification.
2. **No new mathematics.** Every theorem cited is classical, published, or
   already in this corpus. The only statements proved here are Proposition 3.1
   (one line) and the three objections of §3.5, all elementary.
3. **No claim that the lens calculus is complete.** `CROSS_LENS.md` §5 calls it
   the corpus's most obvious missing document; it is still missing. The
   three-verdict scheme is used as given and this note does not establish that
   the three verdicts are exhaustive, mutually exclusive, or well-defined
   outside the instances where the corpus computed them. Row 3's double verdict
   already shows they are not mutually exclusive per problem.
4. **No literature search for prior art on the comparative framing itself.**
   Comparisons of these five are a genre; no search was run for prior
   statements of Criterion R, of the (b)/(c) verdict, or of the Goldbach/twin
   pairing as "one problem at every finite place". **Absence of a located
   source is not evidence of novelty and is not treated as such.**

   **SEARCH resolved 2026-08-14 (`cf-tessera`) — mixed, search-summary grade;
   attribution status only, no verdict in §§3–7 altered.**
   *Criterion R as a named criterion:* **RESOLVED-NO-MATCH.** *Its content:*
   **RESOLVED-FOUND as an existing genre** — the modular-method literature
   states the same limitation in its own vocabulary: a counterexample must
   assemble into a "Frey package" (the term is used in Buzzard–Taylor's Lean
   FLT blueprint) yielding a Galois representation finite-flat at $\ell$ and
   unramified outside a fixed set, and the method closes only when the
   reduced level admits *no* candidate newform — for FLT the level is $2$ and
   the space is empty, which is precisely §5's "moduli can be shown to be
   empty"; elsewhere candidate newforms exist and the final contradiction
   fails. See Siksek, *The modular approach to Diophantine equations* (BIRS
   notes; Springer chapter), and the survey thesis *Applications of the
   modular method to Diophantine equations* (Manchester). Criterion R should
   therefore be presented as a *sharpening/renaming* of a known limitation,
   not as a new criterion, unless a reader locates it stated this way.
   *Two located items bearing directly on the table, flagged for
   adjudication and deliberately not resolved here:* (a) a **Frey curve
   attached to a Goldbach statement** exists in the literature — for
   $2^{\ell+4}=p+q$, the semistable $y^2=x(x-p)(x+2^{\ell+4})$ of conductor
   $2pq$, with a weight-2 level-$2pq$ newform by Wiles (reported by search at
   arXiv:1111.5592; the arXiv number is search-summary grade and unconfirmed,
   `WebFetch` being blocked). It attaches a curve to a Goldbach
   *representation*, i.e. to an existing decomposition, whereas the table's
   Goldbach row concerns what a *counterexample* (a failing even $N$)
   generates — so it is not on its face a refutation of that row, but the row
   was written without knowledge of it and the author should say which.
   **ADJUDICATED 2026-08-14 in §5.5.1: F5 is not falsified, the row stands
   verbatim, Criterion R gains a polarity clause and its first negative
   control, and the arXiv identifier is confirmed at search-summary level
   (Dieulefait–Jiménez Urroz–Ribet, *Res. Number Theory* 1 (2015) art. 2).**
   (b) arXiv:0812.0930, *The Goldbach conjecture resulting from global–local
   cuspidal representations and deformations of Galois representations*, is a
   located prior instance of the global–local framing §5.5 argues against;
   its quality is unassessed.
   *The Goldbach/twin pairing as "one problem at every finite place":*
   **RESOLVED-NO-MATCH.**
   Queries: *why Frey curve method does not apply to Goldbach twin primes*;
   *limits of the modularity method why FLT does not generalize rigid object*;
   *Frey curve associated to Goldbach representation semistable modularity*;
   *Goldbach twin prime local–global principle same problem every finite place
   adelic*.
   **Egress:** `WebSearch` worked; `WebFetch` was blocked on every host tried
   with `{"error_type":"EGRESS_BLOCKED", ... "blocked by the network egress
   proxy."}`, so this line is **śabda grade in the sense of item 5 below** —
   no PDF was read, and none of the located items has been verified against
   its source text.
5. **Several citations are search-summary grade (śabda, weakest).** Taylor–
   Wiles's article page, Chen 1973, Conway 1972, Simons–de Weger,
   Bernstein–Lagarias, Zhang, Maynard, Friedlander–Iwaniec and the
   Almeida–Joseph/MacTutor material were confirmed at search-summary level
   only; no PDFs were read. Ribet's level-lowering, Frey's construction,
   Kummer's regularity criterion, Vinogradov 1937, Polymath8b's constant $246$
   and the Presburger non-definability of the primes are **UNVERIFIED-MEMORY**.
   Nothing structural in §§3–7 depends on any of the unverified items: the
   verdicts rest on `ATLAS_OF_N.md`, `CROSS_LENS.md`, `WIDTH.md`,
   `BARRIER.md`, `GAUGE.md` and `FF_PAIRFIELD.md`, plus the four fetched
   primary records (Wiles's Annals page, Tao's arXiv abstract, Helfgott's
   arXiv abstract, the Clay RH page, Whish's Transactions record).
6. **The `runtime/nerve/` lane was not read** — the directory was absent from
   this working tree. Nothing is claimed from it or about it.
7. **No verdict on whether the five are individually hard for the reasons
   given.** §6 classifies *barriers that have been proved or measured*. It does
   not claim those are the only barriers, nor that removing them would resolve
   anything.
8. **The historical section establishes no historical thesis.** It records what
   the retrieved sources say and declines both the transmission thesis and its
   dismissal.
9. **No proof that a nonzero mixed term is impossible (§7.5).** Two
   constructions were attempted and both give zero. That is a failed search,
   not a no-go theorem, and it is recorded as F11 with its discharge
   condition. Anyone who exhibits the ambient overturns the note's central
   verdict, and should.
10. **The three new problems are treated at citation depth only.** Navier–
    Stokes, P vs NP and quantum gravity enter §5.7 solely to be run through the
    object test. No claim is made about their content, their difficulty, or
    their barriers beyond quoting named results; I did not read the
    Tao, Baker–Gill–Solovay, Razborov–Rudich or Aaronson–Wigderson papers, and
    the Goroff–Sagnotti two-loop result is **UNVERIFIED-MEMORY** used as an
    illustration only. The 0/7 score is a score against *the framing's own
    predicted object type*, which requires only knowing what type each named
    object is — the weakest thing one can know about them, deliberately.
11. **No claim that the lens-calculus verdicts extend to the three new
    problems.** §5.7 observes that every object it found is annihilation- or
    low-rung-shaped; it does not classify Navier–Stokes, P vs NP or quantum
    gravity, and §6's table deliberately still contains five rows.
12. **The unification protocol of §9 is adopted, not validated.** It has two
    in-corpus consumers (§9.2) and one live application (§7.5). Two instances
    and one self-application is not evidence that the criterion is correct in
    general, and §9.3 states its known failure mode rather than concealing it.

---

## 11. Attribution summary

| item | grade |
|---|---|
| The seven charts, transition maps, residual table, Props 2.8/2.9/2.10/2.11, Thms 2.12/2.13, Cor 2.13.1, Thms 4.2/5.1/5.3, Prop 5.4 | **CORPUS**, `ATLAS_OF_N.md`; quoted, not re-derived; that note grades its own sources |
| Three-verdict lens calculus; the reflection join; "the archimedean place is a chart"; sector-blindness of the singular series | **CORPUS**, `CROSS_LENS.md` §§2–5 |
| Parity barrier width; the two failure layers; the uniformity ladder; the one-modulus open question | **CORPUS**, `WIDTH.md` |
| WL class; Thm B1/Cor B2/Prop B3; the depth law; the three presentations | **CORPUS**, `BARRIER.md` |
| Theorem F (parity as a protected gauge sector; identically zero equilibrium expectation) | **CORPUS**, `GAUGE.md` |
| De-centering table; "where RH lives"; parity falls in FF via Sawin–Shusterman; separate theaters | **CORPUS**, `FF_PAIRFIELD.md` §§3–5 |
| $\Phi_7$ local-global failure; residue-count witness; mod-3/mod-5 unit-ideal obstructions | **CORPUS**, `RECIPROCAL_TRACE_CAGE.md` §3, `RECIPROCAL_SEXTIC.md` §3 |
| Endian $\mathbb{Z}/2$; $\varsigma$-truncation as least-significant-digit deletion | **CORPUS**, `DIGIT_CRYSTAL.md` §§0, 4 |
| Wiles 1995 (title, author, vol/issue/year, DOI 10.2307/2118559) | **FETCHED**, annals.math.princeton.edu/1995/141-3/p01 |
| Tao, Collatz, Forum Math. Pi 10 (2022) e12; abstract verbatim incl. Korec's exponent | **FETCHED**, arxiv.org/abs/1909.03562 |
| Helfgott, ternary Goldbach, arXiv:1312.7748; not journal-published per retrieved records | **FETCHED**, arxiv.org/abs/1312.7748 |
| Clay RH official page wording | **FETCHED**, claymath.org/millennium/riemann-hypothesis/ |
| Whish 1834 Transactions title and posthumous publication; Whish 1795–1833 | **FETCHED**, Cambridge Core record + MacTutor biography |
| Kerala transmission thesis contested; "remained localised until Whish" | **FETCHED at search-summary level**, Almeida–Joseph (Race & Class 45, 2004) + MacTutor |
| Taylor–Wiles; Zhang; Maynard; Friedlander–Iwaniec; Chen; Conway; Simons–de Weger; Bernstein–Lagarias | **FETCHED at search-summary level** — bibliographic data confirmed, full texts not read |
| Frey; Ribet; Serre $\varepsilon$; Kummer regularity; Vinogradov 1937; Polymath8b $246$; Presburger; Goroff–Sagnotti | **UNVERIFIED-MEMORY** — nothing structural depends on these |
| Tao, averaged Navier–Stokes, JAMS **29** (2016) 601–674, arXiv:1402.0290 | **FETCHED at search-summary level** — matching energy identity and cancellation condition, finite-time blowup |
| Baker–Gill–Solovay, SIAM J. Comput. **4** (1975) 431–442; Razborov–Rudich, JCSS **55** (1997) 24–35; Aaronson–Wigderson, ACM TOCT **1** (2009) art. 2 | **FETCHED at search-summary level** — bibliographic data and barrier statements only; none read |
| The three-layer identity and its mixed block with coefficient $2$; the $a=2$ vanishing locus | **CORPUS**, `FF_PAIRFIELD.md` §§2.2–2.3 — used in §9.2 as the protocol's worked consumer |
| The refuted duality crystal ($D^2$ undefined; dropped) | **CORPUS**, `ATLAS_OF_N.md` §6 — used in §9.2 as the protocol's outcome-(ii) precedent |
| The unification protocol (Steps 1–3) and the mixed-term criterion | **sibling agent**, adopted in §9; not originated here |
| Proposition 3.1; the three objections of §3.5; the §3.6 adjudication; Criterion R; the information-bound argument of §5.6; the four Grounds of §5.7; the four-family argument of §7.3; the three-outcome amendment of §7.5 with its exhibited-isomorphism discipline | **HERE** |

---

**Status: PENDING HOSTILE AUDIT.**
