# Charge is not the value/functional-equation axis: a refutation of TARGET.md §6(2)

**Seat: NOETHER. Assignment: `TARGET.md` §6 item 2** — read `BARRIER.md` §3
Problem 2 (the oracle model: value queries vs functional-equation queries)
against `ChargeCriterion.charge-criterion`, and decide whether they are the
same distinction stated twice.

**Verdict: they are not, and the difference is exact.** cf-sakshi's recorded
prediction ("They should be the same distinction stated twice") is **REFUTED**,
by a checked term. The two axes are orthogonal, and one entire side of
BARRIER's axis sits strictly inside the blind half of the charge criterion.

Artifact: `formal/cubical/NaturalMachine/OracleQueries.agda`, `--cubical
--safe`, no postulates, no holes, **exit 0 under `agda -W error`** (zero
warnings, including no `UnsupportedIndexedMatch`). Root aggregate
`NaturalMachine.agda` re-verified exit 0 in the same tree; the new module is
an orphan pending the integrator, so the root's green does **not** yet cover
it — see §7.

---

## 0. The prediction, registered before the proof

Per PROTOCOL §1. Space of outcomes considered: (a) same distinction;
(b) functional-equation (FE) access strictly stronger than value access but
not identical to "odd Ω"; (c) FE access strictly *weaker* — carrying no charge
at all; (d) incomparable. **I predicted (c) before writing any Agda**, on the
ground that the flip σ ↦ flip σ maps completely multiplicative functions to
completely multiplicative functions, so the functional equation is a
gauge-*invariant* relation and cannot be a gauge-*charged* probe. The proof
below is (c), sharpened: the FE answer is not merely gauge-invariant, it is
constant on the whole class.

## 1. The two statements, in one vocabulary

`ParitySeparator` models the object exactly: a completely multiplicative ±1
function is a sign assignment $\sigma$ on the primes, a number is its multiset
of prime factors ($\mathrm{Number} = \mathrm{List}\,\mathbb{N}$), $\Omega$ is
length, and `flip` is the gauge element $(-1,-1,\dots)$ of `GAUGE.md` §F.1's
torus. Write $\chi = \mathrm{sgn}\circ\Omega$ for the parity charge.

**A. `charge-criterion` (`ChargeCriterion.agda`, cf-sakshi).** A set of
*value* queries $\{n_1,\dots,n_k\}$ admits a decision procedure separating
$\sigma_+$ from $\mathrm{flip}\,\sigma_+$ **iff** some $n_i$ has $\chi(n_i)=-1$.

**B. `BARRIER.md` §3 Problem 2.** Formalize "multiplicative-constraint access"
as an oracle model: *queries to $a$'s functional equation* versus *value
queries*. §2's table spells out what an FE query is — "$a(np)=a(n)a(p)$ used
as a **constraint**, not a value" — and credits that row with being "the one
known access to Chowla-grade (bulk) content."

So B proposes a partition of the *query language*; A grades queries by a
*character*. The question is whether the partition is the grading.

## 2. It is not: one argument, two readings, opposite verdicts

Model the oracle with both query types (`OracleQueries.agda` §2):

```
data Query : Type where
  value : Number → Query            -- "what is a(n)?"
  fequ  : Number → Number → Query   -- "is a(mn) = a(m)·a(n)?"
```

The FE answer is encoded as $a(mn)\cdot a(m)\cdot a(n)$, which is $+1$ exactly
when the constraint holds — in the sign group "equal" and "product is the
unit" are the same predicate, so nothing is smuggled in by the encoding.

> **Theorem 1 (`fe-const`).** For every sign assignment $\sigma$ and every pair
> $m,n$ of arguments, $\mathrm{ans}_\sigma(\mathtt{fequ}\ m\ n) = +1$.

Proof: complete multiplicativity is `val-++`, $a(m{+}{+}n)=a(m)a(n)$, an
induction on the factor list; then $b\cdot b = +1$. $\square$

An FE query is therefore not merely parity-blind — it is blind to *everything*.
It distinguishes no two members of the class at all, its answer is a constant
of the model, and it is simulated exactly by post-processing that makes **no
query whatsoever** (`fe-simulated-by-constant`). It carries zero bits, hence a
fortiori zero charge, **with no hypothesis on $\Omega(m)$ or $\Omega(n)$**.

The finding in one pair of terms (`p-two-ways`), with $p$ a single prime, the
maximally charged argument there is:

| query set | reading of the same $p$ | verdict |
|---|---|---|
| `value p ∷ []` | as a value | **separates** (`read-p-separates`) |
| `fequ p p ∷ fequ p [] ∷ []` | through the functional equation | **cannot** (`fe-at-p-cannot`) |

Same argument, opposite verdicts. So charge is a property of the **reading**,
not of the argument — which sharpens `ChargeCriterion`'s own slogan ("charge
lives in what a method reads") into something with teeth, because it shows the
slogan is not about *where* a method looks.

Hence: the value/FE partition is **orthogonal** to the odd-Ω/even-Ω grading,
and the FE side is entirely contained in the blind half. `fe-blind`: a query
set consisting only of FE queries never separates, however charged its
arguments.

## 3. Why this had to be so: the conservation law

The counterexample would be a trick if the model of "using the functional
equation" were wrong. The objection is fair: one does not *ask* whether
$a(mn)=a(m)a(n)$, one *uses* it to deduce new values from old. So model that
instead (`OracleQueries.agda` §7). Let $S$ be a set of known arguments and let
$\mathrm{Gen}\,S$ be its deductive closure under everything the functional
equation licenses in the sign group:

$$\frac{n\in S}{n\in\mathrm{Gen}\,S}\qquad
\frac{m,n\in\mathrm{Gen}\,S}{mn\in\mathrm{Gen}\,S}\qquad
\frac{m,\,mn\in\mathrm{Gen}\,S}{n\in\mathrm{Gen}\,S}$$

— multiplication *and division*, the second because $a(n)=a(m)\,a(mn)$ in
$\{\pm1\}$.

> **Theorem 2 (`Gen-sound`).** Two sign assignments agreeing on $S$ agree on
> all of $\mathrm{Gen}\,S$.

So this really is the closure: every value in it is determined, nothing is
assumed. And then:

> **Theorem 3 — conservation (`Gen-neutral`).** If every element of $S$ is
> neutral ($\chi=+1$), so is every element of $\mathrm{Gen}\,S$.
>
> **Corollary (`closure-no-separator`).** A query set drawn from the
> functional-equation closure of a neutral basis admits no separator —
> directly from `ChargeCriterion.neutral⇒no-separator`, unchanged.

*Proof.* $\chi=\mathrm{sgn}\circ\Omega$ is a **monoid character**:
$\chi(mn)=\chi(m)\chi(n)$ (`charge-++`, from $\Omega(mn)=\Omega(m)+\Omega(n)$
and $(-1)^{a+b}=(-1)^a(-1)^b$). The multiplication rule is then closure of the
kernel under the product; the division rule is cancellation in $\mathbb{F}_2$
(`·-cancel`). $\square$

This is the whole content, and it is a Noether statement: **the symmetry is
the gauge flip; the conserved quantity is $\chi$; the functional equation is a
relation invariant under the symmetry, hence it conserves the charge
identically.** The kernel of a character is a subgroup, and the functional
equation is exactly the group law the character respects. Charge cannot be
manufactured by inference, only *read*. A page of algebra, and no computation
was run.

## 4. What this does to `BARRIER.md`

**Row 3 of the §2 visibility table is mis-attributed on the parity axis.**
It credits "functional-equation access" with being the one known access to
bulk content, and §4's honesty ledger says that row rests on "reading Tao's
published argument through this lens (no new analysis of it here)". Here is
the analysis, and it inverts the attribution.

The entropy-decrement step uses $\lambda(pn)=-\lambda(n)$. That is *not* the
functional equation. It is the functional equation $\lambda(pn)=\lambda(p)\lambda(n)$
— charge 0, by Theorem 1 — **specialized at a known value $\lambda(p)=-1$**,
which is a value query at $\Omega=1$: by `charge-criterion`, the single most
charged reading available. The equation contributes exactly none of the charge;
the value contributes all of it.

Consistency check (the falsifier for this note, and it passes): the gauge
partner of $\lambda$ is $\mathrm{flip}\,\lambda$, which is the *constant
function $1$*. Any theorem about $\sum\lambda(n)\lambda(n+h)$ must distinguish
$\lambda$ from $1$, so any proof of log-Chowla must be charged. It is — through
$\lambda(p)=-1$, and by Theorem 3 through nothing else it does with the
functional equation.

**So "global-multiplicative access" is not a third interface with more parity
power.** It is the neutral monoid law plus a charged value query, and only the
second half does work. The three-way classification of §2 stands as a
classification of *presentations*; it does not survive as a classification of
*parity power*, where rows 1 and 3 have the same charge content and differ only
in what they are allowed to assume.

## 5. Independent replication, and credit

While this was being written, the **TURING** seat (message `0474`) was proving
W3 / BARRIER Problem 1 in `formal/cubical/NaturalMachine/InterfaceSeparation.agda`
and reached the same core facts from a different assignment: their
`fe-promised-constant` = Theorem 1, `fe-simulated-by-nothing` =
`fe-simulated-by-constant`, `sgn-++` = `charge-++`, `fe-closure-cannot-separate`
= the multiplication half of Theorem 3. Two seats, two assignments, one answer.
That is an independent replication and the result belongs to them as much as to
this note; PROTOCOL §2 ranks replication above new theorems and it is right to.

Their W3 dichotomy — that FE access *is* nonconstant on arbitrary ±1 sequences,
so the content of the interface is the multiplicativity **promise** itself — is
theirs alone and is not re-derived here. It is also the better answer to "what
is the FE interface for", and this note defers to it.

What is only here, so the duplication is priced honestly:

1. **The division rule.** Turing's derivation calculus is `var`/`unit`/`mul`.
   Division is the rule a hostile reader reaches for — *divide a known argument
   by a known divisor and land on an odd one* — and it is the only rule whose
   neutrality needs cancellation in $\mathbb{F}_2$ rather than closure under the
   product. Closing it makes the conservation law a statement about the
   **group** the functional equation generates, not just the monoid.
2. **`Gen-sound`**, which is what licenses division as an inference rather than
   an added assumption.
3. **`p-two-ways`**, the orthogonality witness, which answers §6 item 2 — a
   different question from W3.

## 6. Prior art — and a correction to `TARGET.md`'s premise

Corpus grep first, by section number per TARGET.md §5: `BARRIER.md` §3(2) is
cited nowhere else; `GAUGE.md`, `PARITY.md`, `LIOUVILLE.md`, `CORE_KMS.md`
contain no oracle model; no module under `formal/cubical/` touches value-vs-FE
access. `notes/ORACLE_BITS_ARE_NOT_THE_MIN_CUT.md` is a different oracle
(obligation bits), not this one.

Then WebSearch. **`WebFetch` returned `EGRESS_BLOCKED` on
`terrytao.wordpress.com`; I read no full text, and the following is graded
CITED from search metadata only.**

- **Tao, "A general parity problem obstruction", *What's New*, 21 Nov 2014**,
  from an AIM workshop with **Zeb Brady**. Per search metadata: problems are
  framed as a collection of affine-linear forms; *forbidden sign patterns* are
  elements of a discrete cube; and the stated criterion is **"if the convex
  hull of the forbidden sign patterns contains the origin, the sieve-theoretic
  approach cannot establish existence."**

  **This is a correction to `TARGET.md` §1 and `BARRIER.md` §1**, both of which
  assert — quoting BARRIER's librarian audit — that "**no general formalization
  of the parity barrier exists**", citing only Tao (2007)'s semi-formal
  statement. A 2014 general obstruction with a convex-hull criterion over sign
  patterns is, on its face, exactly such a formalization, and `TARGET.md` names
  that absence as "the gap … which is exactly what a proof-checking machine is
  for". The target survives — a blog-level criterion is not a machine-checked
  theorem — but its stated premise does not, and a successor must not repeat
  "no general formalization exists" without reading that post.

  Two things a successor should check and I could not: (i) whether the
  convex-hull criterion is the same statement as `charge-criterion` in disguise
  — origin-in-convex-hull is a separating-hyperplane condition, i.e. "no linear
  functional detects the forbidden set", which has the *shape* of "no character
  detects the charge", and if those coincide then `ChargeCriterion` is a
  rediscovery and should be labelled one; (ii) whether Tao–Brady's model
  distinguishes value access from functional-equation access at all. **I claim
  neither. I have not read it.**
- Selberg's parity example (the standard textbook form: sieve axioms cannot
  distinguish $\Omega$ even from $\Omega$ odd) is the classical ancestor of
  `ParitySeparator`'s two-element orbit; `ParitySeparator` already says the
  obstruction is Bombieri's and Friedlander–Iwaniec's and claims no arithmetic
  novelty, which remains the right posture.
- Query-complexity searches ("parity problem oracle model", "parity decision
  trees") return the Boolean-complexity PARITY, a different object. A successor
  should not repeat that search.

## 7. Status, and what is deliberately not claimed

| statement | grade |
|---|---|
| An FE query is constant on the class (Thm 1) | **PROVED** (Agda, exit 0) |
| Value/FE axis ≠ charge axis; the FE side is inside the blind half (`p-two-ways`) | **PROVED** |
| cf-sakshi's "same distinction stated twice" | **REFUTED** |
| FE closure of a neutral basis is neutral, with division (Thms 2–3) | **PROVED** |
| Entropy decrement's parity charge enters through $\lambda(p)=-1$, not through the equation | **PROVED** *as a statement about the interface*; see below |
| Tao–Brady 2014 is a general formalization of the parity obstruction | **CITED** (search metadata only; no full text read) |
| Whether that criterion coincides with `charge-criterion` | **OPEN** |
| Whether value/FE is also empty for the windowed-linear class WL | **OPEN** |

**Not claimed.** (i) Nothing here bears on BARRIER's *other* axis, the
depth/correlation barrier of Theorem K; the model is the parity observable
class throughout, and every statement is about separating $\sigma_+$ from its
gauge flip. (ii) Entropy decrement is not thereby explained, weakened, or
re-derived: its content is quantitative (logarithmic averaging, the decrement
bound), and the claim here is only about *where its parity charge enters*,
which is a question about its interface, not its strength. (iii) No claim that
`Query` is the only reasonable formalization of BARRIER §3(2) — see §8.
(iv) The root aggregate does **not** import `OracleQueries`; it is an orphan
until the integrator adds the line, and per `formal/cubical/BUILD.md` an orphan
that checks is not covered by the root's green claim. What is verified is:
`agda -W error NaturalMachine/OracleQueries.agda` exits 0, and
`agda NaturalMachine.agda` exits 0 in the same tree.

## 8. My least-sure step, stated for a hostile reader

**The modelling of "functional-equation query", and it is attackable in exactly
one place.** I model it as a *decidable check* — "is $a(mn)=a(m)a(n)$?" — and
then observe the check is vacuous. A reader may say: nobody proposed asking
that; the interface means using the equation, so I have refuted a strawman.

§3 is my answer, and it is why the note has a §3 at all: the *inference*
reading is modelled too, with multiplication and division, and it is also
charge-free. Between them the two readings exhaust "constraint, not value" as I
can construe it. But here is the residue I cannot close, and a hostile reader
should push here:

**A finite-query oracle may be the wrong home for the interface.** Entropy
decrement's actual input is an averaged statement over all $n$ simultaneously
— $\lambda(pn)=\lambda(p)\lambda(n)$ as a *symmetry of the whole sequence*,
consumed to compare empirical distributions across scales, not as any finite
list of answers. My Theorems 1–3 are about finite transcripts. I believe the
conclusion survives, because the symmetry $n\mapsto pn$ commutes with the gauge
flip (both $\sigma$ and $\mathrm{flip}\,\sigma$ have it, with the *same*
orbit structure), so an argument using only that symmetry cannot separate them
— but **that sentence is prose here, not a checked term**, and it is the one
step of this note that is not mechanically verified. Turing's message `0474`
names the same gap independently, which makes it the right place for the next
block to work: formalize "the FE as a sequence symmetry" and prove or refute
the gauge-invariance of the symmetry itself.

A second, weaker attack: my `Number` is the free commutative monoid on the
primes, so "division" never leaves $\mathbb{N}$. A method working in
$\mathbb{Q}^\times_{>0}$ has the full free abelian group. That changes nothing
— $\chi$ extends to a character of the group and its kernel is still a subgroup
— but I did not type it, and a reader who wants the group case should ask for
it rather than assume it.
