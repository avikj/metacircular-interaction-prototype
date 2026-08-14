# The no-wrap boundary is a difference-set condition, not an interval condition

`swarm-0814-06`, 2026-08-14.
Object: an exact criterion + a machine-checked strictness witness, closing the
one unproved hypothesis in `notes/RATIONAL_PAIR_CHANNEL.md` §3.
Agda: `formal/cubical/Swarm/S06NoWrap.agda`, `--cubical --guardedness --safe`,
no postulates, no holes. `agda -i . Swarm/S06NoWrap.agda` → **`EXIT=0`**.

---

## 0. The draw, and where the two lenses split

Drawn: `notes/RATIONAL_PAIR_CHANNEL.md`, `code/exp9_crossover_L.py`,
`collab/messages/0354-cf-archivist-walk-forcing-law-to-euclid-core-atomic.md`,
`collab/upstream/raw/U0018.txt`, `notes/HIGHER_SPLIT_PROJECTIVE_NO_GO.md`,
`collab/messages/shilpin/wheel_radical_sector.py`,
`notes/LIMIT_ORBIT_COMPARISON.md`, `notes/RECIPROCAL_TRACE_CAGE.md`,
`collab/discovery/events/R0027/…-builder.json`,
`collab/discovery/events/R0011/…-proof-checker.json`,
`.claude/skills/onboard/SKILL.md`.
Frontier field: tropical and polyhedral geometry. Ancient field: Egyptian
unit-fraction decomposition / false position. Lenses: **Riemann** (move to the
complex plane, let the singularities tell you the arithmetic) and **Bhartṛhari**
(ask whether the unit you are analysing is the real bearer of meaning).

RATIONAL_PAIR_CHANNEL §3 states the finite Fourier projectors (3.1)–(3.2) and
then says they "become an equality projector only under an explicit no-wrap
hypothesis — for example, when the possible values of $m+n$ lie in an interval
of length $<q$." That *for example* is the entire load-bearing hypothesis of the
section and it is never made exact.

- **Riemann's lens on §3** looks at the modes $b/q$: the projector is a spectral
  device, the analysis lives on the arcs, and the only question the lens poses is
  *which $q$ do we sum over*. Under this lens the no-wrap clause reads as a
  technical side condition that a better choice of $q$ might satisfy — the lens
  never inspects the grade set at all, because grades are not singularities.
- **Bhartṛhari's lens** asks what the meaning-bearing unit is. It is not the mode
  $b/q$ and not the coefficient $x_n$: the projector's output is asserted to be a
  statement about the **grade** $N$ (the integer $m+n=N$, the utterance), and the
  characters are the phonemic analysis, an *upāya*. Then exactly one question
  survives: *does the grade survive the quotient?* That question is about the map
  $\pi:\mathbb Z\to\mathbb Z/q$ restricted to the set of grades, and it has an
  exact answer with no analysis in it.

The lenses disagree on where to look. Bhartṛhari's answer, below, is Theorem 1;
its Corollary 1.1 then closes off the possibility the Riemann lens leaves open
(that some small $q$ might work on the prime channel).

---

## 1. Theorem 1 — the exact criterion

Let $A,B\subset\mathbb Z$ be finite, $S=A+B$ the **grade set**, and let
$\pi:\mathbb Z\to\mathbb Z/q$ be reduction. For $x$ supported in $A$ and $y$
supported in $B$ write $c=x*y$, $c(N)=\sum_{m+n=N}x_my_n$, and
$F_b=\sum_m x_me_q(bm)$, $G_b=\sum_n y_ne_q(bn)$.

**(a) The projector is a pushforward.** Finite Fourier inversion (the note's
(3.1)) gives, for every $N$,

$$
\Pi_q(N):=\frac1q\sum_{b\bmod q}e_q(-bN)F_bG_b
=\sum_{m+n\equiv N\,(q)}x_my_n
=\sum_{N'\equiv N\,(q)}c(N')
=(\pi_*c)(\pi N).
$$

So (3.1)–(3.2) compute $\pi_*c$, nothing more and nothing less. Everything else
in §3 is a question about $\pi_*$.

**(b) Criterion.** The following are equivalent.

1. For every $x$ supported in $A$, every $y$ supported in $B$, and every
   $N\in S$: $\ \Pi_q(N)=c(N)$.
2. $\pi_*:\mathbb C^{S}\to\mathbb C^{\mathbb Z/q}$ is injective.
3. $\pi|_S$ is injective.
4. $q\nmid d$ for every $d\in(S-S)\setminus\{0\}$.

*Proof.* (3)⇔(4) is the definition of congruence. (3)⇔(2): $\pi_*$ acts on
$\mathbb C^S$ by summing along fibres, so it is injective iff every fibre meets
$S$ at most once. (3)⇒(1): if $N\in S$ then $\pi^{-1}(\pi N)\cap S=\{N\}$, so the
sum in (a) has the single term $c(N)$. (1)⇒(3): suppose $s\ne s'$ in $S$ with
$\pi s=\pi s'$. Choose $a\in A,b\in B$ with $a+b=s'$ and take $x=\delta_a$,
$y=\delta_b$; then $c=\delta_{s'}$, so $c(s)=0$ while $\Pi_q(s)=c(s')=1$, and
$s\in S$. $\square$

Note the restriction $N\in S$ in (1) is necessary and is *not* a weakening one
can drop: for $N\notin S$ the projector reads a residue class that may still
carry mass. The projector never certifies a grade outside the support.

**Corollary 1.1 (no small modulus rectifies an interval grade set).** If $S$
contains $q+1$ consecutive integers then $\pi|_S$ is not injective. Consequently,
for the Goldbach sum channel of §1–§2 with $u_n=\Lambda(n)\mathbf 1_{n\le X}$ we
have $S=[2,2X]$, and **no** modulus $q\le 2X-2$ is a no-wrap modulus. In
particular no major-arc modulus $q\le(\log X)^A$ ever is.

*Proof.* Pigeonhole among $q+1$ consecutive integers. $\square$

This is the sharp form of the note's warning: the failure of (3.1)–(3.2) to be
an equality projector on the prime-prefix channel is **unconditional**, not an
artefact of a careless choice of $q$. The note's fallback to the formal
coefficient (1.1) or the angular coefficient (1.2) is therefore not a stylistic
preference — it is forced. Any future argument on this channel that reaches an
integer statement through a residue projector at a major-arc modulus is wrong at
this step, independently of its analysis.

---

## 2. Theorem 2 — the interval condition, proved and generalised

**Theorem 2.** If $\operatorname{diam}(S)<q$ then $\pi|_S$ is injective.

Machine-checked as `narrow→Sep` in `Swarm/S06NoWrap.agda`, in a form stronger
than needed: for an arbitrary index type $A$ at any universe level and any
$S:A\to\mathbb N$, if $|S i-S j|<q$ for all $i,j$ then $q\mid|S i-S j|$ forces
$S i\equiv S j$. Separation itself is the type

```agda
Sep : {A : Type ℓ} (S : A → ℕ) (q : ℕ) → Type ℓ
Sep S q = (i j : A) → q ∣ gap (S i) (S j) → S i ≡ S j
```

with `gap a b = (a ∸ b) + (b ∸ a)`; this is literally condition (4) of Theorem 1.

---

## 3. Theorem 3 — the interval condition is strictly sufficient, with unbounded slack

Fix $B\ge1$ and $k\ge0$, put $Q=2B$, and take

$$
A=\{0,\;kQ+B\},\qquad B'=\{0,1,\dots,B-1\},\qquad
S=A+B'=\{0,\dots,B-1\}\;\cup\;\{kQ+B,\dots,kQ+2B-1\}.
$$

**Theorem 3.** $\pi|_S$ is injective modulo $Q$, while
$\operatorname{diam}(S)=kQ+2B-1=(k+1)Q-1$.

The low block occupies residues $\{0,\dots,B-1\}$ and the high block, since
$kQ\equiv0$, occupies $\{B,\dots,2B-1\}$: disjoint. Machine-checked as
`Family.sep` and `Family.diam` (the latter in the exact form
`suc (gap (S lo) (S hi)) ≡ suc k · Q`, i.e. the diameter is exactly
$(k+1)Q-1$), for **all** $b,k:\mathbb N$ with $B=\mathrm{suc}\,b$.

Hence Theorem 2's hypothesis overestimates the least admissible modulus by the
factor $k+1$, which is unbounded at fixed $Q$. Smallest instance ($B=2,k=1$):

$$
S=\{0,1,6,7\},\qquad q=4,\qquad S\bmod4=\{0,1,2,3\},\qquad
\operatorname{diam}(S)+1=8=2q .
$$

The §3 clause would demand $q>7$; $q=4$ suffices. **Separation is a property of
the difference set of the grade set, never of its diameter.**

---

## 4. Translation: this is `LIMIT_ORBIT_COMPARISON.md` in a second vocabulary

`notes/LIMIT_ORBIT_COMPARISON.md` studies $c:(\lim X)/G\to\lim(X/G)$ and isolates
injectivity as *global alignment of local phases* and surjectivity as *existence
of compatible representatives*. The pair channel is the same statement with the
diagram replaced by the single quotient $\pi$:

| pair channel (`RATIONAL_PAIR_CHANNEL` §3) | orbit comparison (`LIMIT_ORBIT_COMPARISON`) |
|---|---|
| grade $N\in S$ (the global object) | compatible family $x\in\lim X$ |
| residue $\pi N\in\mathbb Z/q$ (the local reading) | objectwise orbit $[x_i]\in X_i/G$ |
| projector $\Pi_q=\pi_*$ | comparison map $c$ |
| no-wrap: $\pi\vert_S$ injective | $c$ injective: local phases align globally |
| grade outside $S$ carrying projector mass | $c$ not surjective: no compatible representative |
| interval hypothesis (§3) | freeness + connectedness (sufficient, not necessary) |
| Theorem 3's two-block family | the span counterexample: sufficiency is strict |

Both notes were written independently and both stop at a *sufficient* condition
advertised as the working hypothesis. The exact criterion in each case is a
statement about a fibre meeting the object at most once. The transportable
lesson: **whenever a repo note says "under an explicit hypothesis — for example
…", the example is standing in for a fibre-cardinality condition, and the
fibre condition is one line shorter than the example.**

---

## 5. Prior art

The condition of Theorem 1 is classical and no novelty is claimed for it: a set
$S\subset\mathbb Z$ reduces faithfully into $\mathbb Z/q$ exactly when the
reduction is a Freiman isomorphism of order 1 on $S$, and "no wrap-around" is the
standard name. The standard *sufficient* device in that literature is the same
interval/diameter enlargement used in §3 — see Green–Ruzsa, *Sets with small
sumset and rectification* ([math/0403338](https://arxiv.org/pdf/math/0403338)),
and the explicit wrap-free modelling lemma (Lemma H.1) in
[arXiv:2512.04433](https://arxiv.org/pdf/2512.04433), which fixes a modulus
polynomially large in the diameter precisely so that "no wrap-around occurs".

What is new **here** is only local and corrective: §3 of RATIONAL_PAIR_CHANNEL
carried an unquantified hypothesis; Corollary 1.1 shows the hypothesis is
*unsatisfiable* on the channel that note is actually about, and Theorem 3 shows
the stated sufficient condition is arbitrarily far from necessary. Both are
machine-checked rather than asserted. Searched before writing (repo grep for
`no-wrap`, `Sidon`; one external search, cited above); the criterion was not in
the corpus, and `notes/RATIONAL_FIBER_SPECTRUM.md` merely forwards to §3.

---

## 6. Rigor boundary

- **Proved and machine-checked** (`EXIT=0`, `--safe`, no postulates/holes):
  Theorem 2 (`narrow→Sep`), Theorem 3 (`Family.sep`, `Family.diam`), and the
  supporting divisibility obstruction `q∤ : 0<r<q → ¬ (q ∣ c·q + r)`.
- **Proved on paper, not formalised**: Theorem 1 (a)–(b) and Corollary 1.1. Each
  is three lines; the Agda module formalises condition (4), which is the only
  part with arithmetic content. Formalising (a) needs a finite-sum/character
  library the cubical lane does not have, and the identity is Fourier inversion.
- **Not claimed**: any statement about the analytic content of §§1–4 of
  RATIONAL_PAIR_CHANNEL. Nothing here touches the explicit formula, the
  singular series, or the minor arcs. This note constrains one projector.
- **Not claimed**: novelty of the criterion (see §5).

---

## 7. One exact remark outside the main object

The frontier field (tropical/polyhedral) turned out to be load-bearing on a
different drawn file, so it is recorded rather than ornamented.
`notes/RECIPROCAL_TRACE_CAGE.md` (1.14) proves, via $u_i=\log r_i$, that
$e_k(r)<\binom{n-1}{k}R^k+\binom{n-1}{k-1}R^{k-n}$ when $\prod r_i=1$ and
$r_i<R$. That is exactly a **tropical vertex evaluation**: the feasible set
$P=\{\sum u_i=0,\;u_i\le\log R\}$ is a simplex with exactly $n$ vertices, the
permutations of $(\log R,\dots,\log R,-(n-1)\log R)$; $e_k\circ\exp$ is convex,
so its supremum is a vertex value, and evaluating at that vertex gives
$\binom{n-1}{k}R^k+\binom{n-1}{k-1}R^{k-n}$ term by term. I verified the vertex
computation; the bound is correct and its constant is the sharp (unattained)
supremum. The useful consequence for that note is that the cage constant needs
no numerical estimate at any $n$ — it is the value of $e_k$ at one explicit
lattice-free vertex, which is why (2.1) is exact.

The ancient field (Egyptian unit-fraction decomposition / false position) was
not load-bearing on this object and is not decorated in; per
`notes/ALREADY_ANSWERED.md`'s standing warning, saying so is the honest report.

---

## 8. Contradictions in my draw against the repo's conspicuous documents

Recorded because they are live, not archival.

1. **`.claude/skills/onboard/SKILL.md` still instructs new agents to run
   Python**, in five places (`python3 code/natural.py summary`,
   `python3 code/discovery_loop.py validate`, `python3 machinery/validate.py`,
   `python3 code/natural.py resume`, `python3 code/natural.py validate`), while
   `CLAUDE.md` bans Python repo-wide (owner, 2026-08-13) and the skill's own
   Step 0 repeats the ban. Every onboarding agent is told to violate the ban
   four steps after being told the ban exists. `notes/LIMIT_ORBIT_COMPARISON.md`
   ends with the same `Replay: python3 …` block.
2. **`collab/upstream/raw/U0018.txt` vs `onboard` Step 0/Step 5.** U0018:
   *"i dont want to push anything to any other public project/db rn, keep this
   work private until we have a notable result with insight compressed … i'll
   decide when anything leaves this repo."* The onboard skill mandates
   `git push … :main` on every landing and declares "an un-pushed session never
   happened". Upstream outranks; publishing *within* the private repo is
   compatible, publishing *outward* (arXiv, public DBs, external services — cf.
   U0003's WolframAlpha suggestion) is not, and no document currently says so at
   the point of action. I ran no git commands.
3. **`code/exp9_crossover_L.py` is a museum piece of the exact failure mode
   `CLAUDE.md` was written against.** Part (1) Richardson-extrapolates a ratio
   over one decade to match a limit whose closed form ($e^{(k-1)\cdot(-\mathrm{Ein}(\lambda))}$)
   is *printed in the same docstring* — the derivation was available and the run
   was made anyway. Part (3) prints a fitted residual against
   $-\tfrac12\log H$ with no error term, i.e. a constant measured at one scale.
   Part (2) is the only defensible one (a falsifier for an identity). Evidence,
   not a target.
4. **`collab/messages/0354` routes a proof through an unchecked runtime.** It
   cites `runtime/walk.py` at commit `a9ef107` as executing "the converse
   dynamics", with "29 certified jumps to $10^{30}$", and asks a formal lane to
   adopt the conclusion. Under CLAUDE.md a Python counter is not a certificate;
   the message's own proposed remedy (force the least non-divisor lemma in
   `Data.Nat`) is the correct move and is still open.

---

## 9. Appended to the seeder

Per `random_entry_seeder_so_agents_dont_cluster/why_this_exists.md`, one field
and one lens my draw met that the urn lacked have been appended:
`frontier_fields.txt` gains rectification/Freiman-isomorphism additive
combinatorics as a distinct entry from the two inverse-theorem entries already
present; `method_lenses.txt` gains the fibre-cardinality lens that Theorems 1–3
are an instance of.
