# The sieve fibre at the √X horizon: the section exists, and that is the finding

**Status: checked Agda + this note.** `formal/cubical/NaturalMachine/SieveFiber.agda`,
Agda 2.6.3 + cubical v0.5, `--cubical --guardedness --safe --no-import-sorts`,
**exit 0**, no postulates, no holes, no `TERMINATING` pragmas, 0 warnings,
≈3.3 s from a cold interface. Verify with

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8
cd formal/cubical && agda NaturalMachine/SieveFiber.agda
```

Author: `cf-tessera-00`. Not yet imported by `formal/cubical/NaturalMachine.agda`
— that is the parent session's call, per the block brief; the root aggregate
was re-verified at exit 0 alongside this file, so adding the import is safe but
has not been done here.

---

## 0. What this is

`collab/upstream/raw/U0006.txt` is the human owner's relayed proposal for
adopting Cubical Agda. Its penultimate section names, explicitly, **the first
Cubical Agda experiment this project should run**, and describes it in seven
steps. Nobody had run it. This is that experiment, as checked Agda.

The proposal's own words for the experiment:

> Take integers $n \le X$, represent each by its divisibility information
> below $\sqrt X$, quotient integers having identical visible state, and
> attach the residual bit $\varepsilon_X(n)\in\{0,1\}$. Then formally
> characterize the fiber $q^{-1}(q(n))$. Ask whether $(q(n),\varepsilon_X(n))$
> is an informationally complete representation of factorization charge. Then
> remove $\varepsilon$. The resulting failure of reconstruction is our finite
> parity obstruction, represented as an actual fiber rather than prose.

and its framing of the master question:

> the master problem I've been calling reconstruction under restricted
> observables becomes: **does the arithmetic quotient map admit a section?**

**The short answer to the master question is: yes, trivially, and that is why
the question has to be re-posed.** The rest of this note is that answer with
its reasons, plus four other things that checked and two that did not.

## 1. The model

$X = 30$. The primes at or below $\lfloor\sqrt{30}\rfloor = 5$ are $2,3,5$.

- **Visible state** $q(n) = (v_2 n, v_3 n, v_5 n) \in \mathrm{Vis} = \mathbb N^3$
  — the *exact valuations*, not indicator bits. In the Agda this is computed by
  actual repeated division (`stripF`, on top of a fuel-bounded `divF`/`modF`);
  there is no lookup table anywhere in the file, so every `refl` is the
  typechecker doing the arithmetic.
- **Rough part** `rough n` — what survives stripping $2,3,5$.
- **Residual bit** $\varepsilon(n) = [\,\mathrm{rough}(n) \ne 1\,]$.
- **Charge** $\Omega(n) \bmod 2$, with $\lambda(n) = (-1)^{\Omega(n)}$.
  $\Omega$ is defined *independently* by trial division (`omegaF`), which is
  what makes §4 below a theorem rather than a restatement of a definition.
- **Domain** $[1,30]$, as an explicit list; membership is a recursive `⊎`
  family, not an indexed datatype (cubical Agda declines constructor
  injectivity of `_∷_` for indexed unification, so `here`/`there` matching
  would not compute — this cost me one iteration).

Exhaustive verification uses the `PMNoSection.agda` idiom: a Boolean check
whose `refl` the typechecker must normalise, plus `allOf-sound` turning it into
a statement about every element of the domain. Nothing is trusted but Agda's
evaluator.

## 2. What checked

| Agda name | statement |
|---|---|
| `roughSplit` | for every $n\le 30$, $\mathrm{rough}(n)=1$ **or** $\mathrm{rough}(n)$ is a single prime $>5$ |
| `factorises` | $n = \mathrm{smooth}(n)\cdot\mathrm{rough}(n)$ |
| `fiberAt-1/2/3` | $q^{-1}(0,0,0)=\{1,7,11,13,17,19,23,29\}$, $q^{-1}(1,0,0)=\{2,14,22,26\}$, $q^{-1}(1,1,1)=\{30\}$ |
| `chargeFactors` | $\Omega(n)\bmod 2 = \mathrm{odd}(v_2{+}v_3{+}v_5)\oplus\varepsilon(n)$ |
| `noChargeDescent` | $\nexists\,\bar\lambda:\mathrm{Vis}\to\mathbf 2$ with $\bar\lambda\circ q=\lambda$ |
| `noChargeDescentQuot` | the same, out of the actual set quotient `Dom / ∼` |
| `hasSection` | $\sigma(a,b,c)=2^a3^b5^c$ is a section of $q$: it lands in the domain, $q\circ\sigma\circ q=q$, and $\varepsilon\circ\sigma\circ q=0$ |
| `noChargePreservingSection` | **no** $s:\mathrm{Vis}\to\mathbb N$ has $\lambda(s(q\,n))=\lambda(n)$ |
| `noReconstruction` | $q$ is not injective |
| `noReconstructionWithBit` | $(q,\varepsilon)$ is not injective either |
| `pairMapNotInjective` | the same, as two points of one fibre agreeing on $\varepsilon$ |
| `noFullPattern` | for $k=2$ with forms $(n,n{+}2)$, no joint fibre at $X=30$ realises all four residual patterns |
| `jointFibreAt1`, `patternsAt1` | the joint fibre through $1$ is $\{1,19\}$; it realises $(0,0)$ and $(1,1)$ and neither mixed pattern |

Three **planted-false controls** were run against the same definitions and all
three were rejected by the typechecker (they are not left in the tree; the
runs are reported here so the `refl`s are not taken on faith):

- **A.** Drop $29$ from the claimed fibre over $(0,0,0)$ → rejected.
- **B.** Claim the charge factors through $q$ alone (`chargeFromVis` with
  $\varepsilon$ deleted) → rejected.
- **C.** Keep the horizon at $\sqrt{30}$ but extend the domain to
  $\{31,35,49,77\}$, where the one-bit fact must fail ($49=7^2$ is rough for
  $\{2,3,5\}$ with $\Omega=2$) → rejected. This one matters: it shows §4 is a
  real $X$-dependent fact and not an artefact of how `rough` is defined.

Eighteen positive spot checks (`q 12 ≡ (2,1,0)`, `Ω 16 ≡ 4`, `rough 26 ≡ 13`,
…) also passed, confirming the arithmetic is the arithmetic claimed.

## 3. The three corrections to the proposal's framing

These are the content of the exercise. Each is a place where a natural English
sentence turns out to name two different mathematical statements, and the
formalization forced the choice.

### 3.1 Section is not retraction

The proposal asks: *does the arithmetic quotient map admit a section?* For
$q:X\to X/\!\sim$ a surjection of sets, a section $s$ with $q\circ s=\mathrm{id}$
is **cheap** — here it is exhibited explicitly and it is the obvious one
($\sigma$ picks the $\varepsilon=0$ point of each fibre, `hasSection`).
Reconstruction is the *other* composite: $s\circ q = \mathrm{id}$, i.e. $q$
injective, and that fails (`noReconstruction`).

So "does the quotient admit a section?" as stated has a boring affirmative
answer, and the interesting question is one of:

- is $q$ **injective**? (no — `noReconstruction`)
- does $\lambda$ **descend**? (no — `noChargeDescent`)
- is any section **charge-preserving**? (no — `noChargePreservingSection`)

The third is the sharpest of the three, because it names *both* the section
and the obstruction in one statement and quantifies over every candidate
section rather than exhibiting a bad one. **The obstruction is not to
sectioning $q$; it is to sectioning $q$ compatibly with charge.** That is the
sentence I would put in a paper.

### 3.2 "Informationally complete for the charge" is true; for the state, false

The proposal's step 5 asks whether $(q(n),\varepsilon_X(n))$ is "an
informationally complete representation of factorization charge". Both readings
were checked and they disagree:

- **complete for the charge** — TRUE, `chargeFactors`:
  $\lambda(n)$ is recovered exactly, by $\mathrm{odd}(v_2{+}v_3{+}v_5)\oplus\varepsilon$.
- **complete for the state** — FALSE, `noReconstructionWithBit`: $7$ and $11$
  agree in $q$ *and* in $\varepsilon$.

The step as written does not distinguish them, and the two are not close: the
fibres here have $8$, $4$ and $1$ elements.

### 3.3 The fibre is not a 2-element set, so "$+$ one bit" is not a splitting

`notes/CUBICAL_QUOTIENT_AUDIT.md` Proposition 2.1 (codex, prior art, see §5)
gives the exact criterion: $(q,c)$ is an equivalence iff every fibre has
exactly two elements and $c$ restricted to each is a bijection. `fiberAt-1/2/3`
show the fibres have sizes $8$, $4$, $1$; on the singleton $\varepsilon$ is
constantly $0$. So the pair map is not an equivalence, and its failure is not
a near miss. The general shape, stated but *not* proved here, is

$$q^{-1}(v)\;=\;\{s\}\;\cup\;\{s\cdot p \;:\; \sqrt X < p \le X/s\},\qquad s=\sigma(v),$$

so $\#q^{-1}(v) = 1 + \#\{p \text{ prime}: \sqrt X < p \le X/s\}$, which is $1$
whenever $s>\sqrt X$. Only its three instances are proved.

## 4. Where the two method lenses disagree — and the disagreement is the point

My block's two assigned lenses were **Boltzmann** (count the microstates) and
**Curry/Howard** (read the proof as a program, the proposition as its type).
They give different answers about the phrase "the residual bit", and
reconciling them is exactly §3.2.

- **Curry/Howard.** The question is which types are inhabited.
  $\mathrm{Vis}\to\mathbf 2\to\mathbf 2$ contains a program computing the
  charge (`chargeFromVis`); $\mathrm{Vis}\to\mathbf 2$ contains none agreeing
  with $\lambda$ (`noChargeDescent`). The missing datum is *exactly one bit*,
  because the **goal type is $\mathbf 2$**. One bit in, one bit out.
- **Boltzmann.** The fibre is the set of microstates compatible with the
  observation, and $\varepsilon$ is a coarse-graining of it into two cells of
  sizes $1$ and $\#\{p:\sqrt X<p\le X/s\}$. The missing information is
  $\log \#q^{-1}(v)$, which is $\approx\log(X/s)-\log\log(X/s)$ nats — three
  bits at $v=(0,0,0)$, $X=30$, and unbounded in $X$. And the coarse-graining
  is violently lopsided: one cell is a single point.

**The disagreement is real and it is resolved in favour of neither.** "One
bit" is a statement about the *target of the charge map*, not about the fibre.
The proposal's phrase "the residual bit $\varepsilon_X(n)$" silently identifies
the two, and `noReconstructionWithBit` is Boltzmann's revenge: the bit that
suffices for the charge does not come close to suffice for the state, because
the fibre has many more than two microstates. Curry/Howard is right about what
$\lambda$ needs; Boltzmann is right about what the sieve destroys; they are
not the same quantity, and the corpus's habit of calling both "the residual
bit" is the error this file makes impossible to keep making.

There is a corpus-internal consequence. The reason the Curry/Howard count is
$1$ is that $\Omega(\mathrm{rough}\,n)\in\{0,1\}$ — the $\sqrt X$ horizon fact,
`roughSplit`. That is a *fact about $X$*, not about types, and control C shows
it fails the moment the domain outruns the horizon. So the "one bit" framing
is horizon-relative in exactly the way `CLAUDE.md`'s `HOLOGRAM.md` §7 corollary
warns about: a constant quoted without its $X$-dependence looks like knowledge.
Here the $X$-dependence is $\varepsilon\in\mathbf 2$ **iff** the domain is
$[1,X]$ and the horizon is $\sqrt X$; at horizon $\sqrt X$ with domain $[1,X^{3/2}]$
the residual is a $\{0,1,2\}$-valued datum, not a bit.

## 5. Prior art, credited

**In this corpus, and it is close.**

- `notes/CUBICAL_QUOTIENT_AUDIT.md` (codex) is the direct predecessor and
  reaches the same *conclusions* by a shorter route: §1 the descent criterion,
  §2 Proposition 2.1 (the fibrewise criterion I use in §3.3), §3 the $\bmod 6$
  witness $1\sim7$ with opposite charge, §6 the kill criteria. **Its §3 also
  anticipates the negative half of this note in prose.** What it does *not*
  have is the arithmetic model: it treats two extremes — an indicator-only
  sieve state, and fully $F$-smooth numbers where "the local state already
  reconstructs $n$" — and the $\sqrt X$-horizon model is the middle case
  between them, which is the one the owner actually named. Whether that
  middle case is worth a file, given that the audit predicted the answer, is
  a fair question; my answer is that the *fibre sizes* $8,4,1$ and the
  section/retraction split of §3.1 are not in the audit and are not
  derivable from it without doing the arithmetic.
- `formal/cubical/ProjectionChargeAudit.agda` — `noChargeDescent` for the
  indiscrete relation on `Bool`. My §7 is that argument with a real sieve map
  in place of the toy relation.
- `formal/cubical/PMNoSection.agda` — the `allVec`/`sound` exhaustion idiom,
  which `allOf`/`allOf-sound` reproduces over a list. Also the closest
  structural sibling: PM is descent of *sections* with local sections existing
  and global assembly obstructed ($H^1$); this file is descent of a *charge*
  along one map ($H^0$). Nothing here is $H^1$.
- `notes/BARRIER.md` §(Selberg/Friedlander–Iwaniec) already carries the
  literature prior art for what this obstruction *is*: the sieve **parity
  problem**, and the note's own line — "no general formalization of the parity
  barrier exists; Tao (2007) states it semi-formally" — is the correct
  calibration for this file. **This file does not formalize the parity
  barrier.** It formalizes one finite shadow of it at $X=30$.
- `formal/cubical/NaturalMachine/SensorNerode.agda` — "a family of moduli
  observes $n$ only through $\mathrm{lcm}(S)$". Same shape as `fiberAt-*`: the
  observable is a single arithmetic function of the parameters and the fibre
  is its level set. Worth a successor's attention as the template for the
  $X$-uniform statement I did not prove.

**Outside.** `~/agda-libs/agda-unimath/src/elementary-number-theory/` has
`sieve-of-eratosthenes` but no rough/smooth decomposition, no $\Omega$, no
Liouville. A `WebSearch` for a formalization of the sieve parity obstruction
as a fibre/descent statement returned nothing on point (the parity problem
itself, category theory in Agda, set-quotient coherence, a Lean Nagata
factoriality formalization). **This is śabda-grade testimony: `WebFetch` is
`EGRESS_BLOCKED` on every host, so I opened none of those pages and quote none
of them.** Absence of a hit is not absence of prior art.

Proposed addition to `notes/PRIOR_ART_INDEX.md`'s translation table, for
whoever owns that file:

| our name | standard name to grep |
|---|---|
| residual bit / factorization charge at the $\sqrt X$ horizon | **parity problem / parity barrier** (Selberg), rough–smooth decomposition, Buchstab identity, $\Omega(n)\bmod 2$ = Liouville |
| reconstruction under restricted observables | descent along a quotient; **section vs retraction** — do not let one word carry both |

## 6. What I did not do, and where I am least sure

- **No $X$-uniform statement.** Everything is $X=30$. The one theorem worth
  proving next is `roughSplit` for general $X$: *if $n\le X$ and every prime
  factor of $n$ exceeds $\sqrt X$ then $n$ is $1$ or prime*. It is a two-line
  argument ($p_1p_2 > X$) and it is the load-bearing fact under the whole
  "one bit" story. It needs real order reasoning in Agda, which is why it is
  not here.
- **No higher structure, and no evidence any is warranted.** `Vis`, `Bool`,
  the fibres and the set quotient are all $0$-types; every obstruction here is
  $\pi_0$-level. This is precisely `CUBICAL_QUOTIENT_AUDIT.md` §6's kill
  criteria 1, 3 and 5 firing. The proposal's chain
  *fibre → torsor → cohomology class → K-theory* is **not begun**, and this
  file supplies no reason to begin it: a fibre of varying finite size with no
  group acting on it is not a torsor.
- **Step 7 is negative at this scale, not refuted.** `noFullPattern` says no
  joint fibre at $X=30$ sees all four residual patterns, because the joint
  fibres have at most two elements. That is a statement about $30$. It does
  say something useful, namely that the $2^k$ structure is a claim about the
  *joint distribution as $X\to\infty$*, with required $X$ growing in $k$ — so
  a successor should not expect to see it in a finite model small enough to
  typecheck.
- **The step I am least sure of** is §3.3's parenthetical general fibre shape.
  It is stated, it is not proved, and I have proved only three instances of it.
  It is elementary and I believe it, and that is exactly the kind of belief
  `CLAUDE.md` says to convert into a proof or label. It is labelled.
- Second-least sure: whether this file earns its keep at all given
  `CUBICAL_QUOTIENT_AUDIT.md`. I have argued in §5 that §3.1 and the fibre
  sizes are new; a reviewer who disagrees would be making a reasonable
  argument and I would not fight it hard.

## 7. An ancient-lane observation, offered as structure and not as ornament

My block's assigned ancient field was **kolam and sona drawing** — rule-generated
curve families and Eulerian-path traditions. The honest connection is narrow
and I state it narrowly.

A sona (Chokwe *lusona*) drawn on an $m\times n$ dot lattice by the standard
mirror-reflection rule decomposes into a number of distinct closed curves that
is $\gcd(m,n)$; the single-stroke drawings are exactly the coprime lattices.
The *observable* — how many strokes the drawing takes — therefore sees the
lattice $(m,n)$ only through $\gcd(m,n)$, and the fibre of that observable is
a full level set of the gcd. This is the exact dual of the corpus's own
`SensorNerode` theorem, where a family of moduli sees $n$ only through
$\mathrm{lcm}$. In both cases the fibre is a level set of one arithmetic
function of the parameters, and in both cases the interesting question is not
"is there a section" (there is: pick the smallest element) but "does the datum
you care about descend to the level set".

That is the same re-posing as §3.1, arrived at from a tradition that had the
construction long before it had the theorem. I am **not** claiming the sona
gcd law contributed to the proof — it did not; I found the section/retraction
distinction from the type checker refusing my first statement. I am recording
it because the parallel is exact and because a successor looking for the
$X$-uniform statement of §6 may find the gcd/lcm pair the right template.

**Citation grade: background knowledge, unopened.** The sona line-count law is
standard (Gerdes, *Geometry from Africa*; Ascher, *Ethnomathematics*), but
`WebFetch` is blocked here and I have opened no source for it in this session.
Treat it as testimony, and check it before it is quoted anywhere with a number
attached.

---

*Sources consulted for §5's outside search (titles only; none opened —
`WebFetch` is `EGRESS_BLOCKED`): "Parity problem" (Wikipedia); "Formalizing
category theory in Agda" (CPP 2021); "Coherence via Well-Foundedness: Taming
Set-Quotients in Homotopy Type Theory" (arXiv 2001.07655); "A Prime-Generated
Formalization of Nagata's Factoriality Theorem in Lean 4" (arXiv 2604.05238).*
