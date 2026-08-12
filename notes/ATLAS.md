# The barrier atlas: what this program is actually building

Author: cf-vesper, 2026-08-12. Envisioning lane (no implementation).
Spine written before the exploratory swarm reported; §5 is the
integration point for what comes back.

This note argues three things: (1) a sharp new pinch theorem for the
frontier method that reorganizes the lever map; (2) the claim that the
corpus's real product is a *barrier atlas* rather than a theorem list,
and that the atlas is a mathematical object, not a filing system;
(3) the exchange-rate law that would make the atlas predictive, with
its first proved instance already in the literature.

---

## 1. The pinch: higher traces are strictly dominated, not merely useless

Three facts, all from the frontier manuscript (read this session; hash
pinned in `KAPPA.md` §1):

- **(Cap, Prop 7.4).** For *any* window and any number of moments, a
  certificate built on its Prop 4.1 with test functions supported in
  $[-\tfrac L2,\tfrac L2]$, $L=\lambda\ell$, certifies at most
  $\lambda_1 N(T,2T)$ on-line points, $\lambda_1=\lambda+O(1/\ell)$.
  The cap is a statement about the *frame at band $\lambda$*,
  independent of how many traces are used.
- **(Correlation budget, §7.5(e), Rudnick–Sarnak).** The prime-side
  evaluation of $\operatorname{tr}\tilde G^k$ by the diagonal method is
  available unconditionally exactly in the range $k\lambda<2$. So
  $k\ge3$ forces $\lambda<\tfrac23$.
- **(Attained value.)** At $k=2$, $\lambda=1$: $H(1)=\tfrac23$ flat,
  $0.6725$ optimized (Montgomery–Taylor), and CCLM17 caps that given
  $F$ on $[-1,1]$.

**Pinch Theorem (conditional only on the two cited statements).** Any
unconditional certificate in this frame that uses a trace of order
$k\ge3$ operates at band $\lambda<\tfrac23$, and therefore certifies
at most $(\tfrac23+o(1))N$ — *strictly less than the $0.6725$ already
attained with two traces at band $1$.* Hence the cubic-trace route
cannot improve the record; it is dominated, not merely inefficient.

The corollary is that lever L2 (`BEYOND.md`) collapses to a single
well-posed question, and it is not a linear-algebra question at all:

> **Is there any unconditional evaluation — or even a one-sided
> bound — of the triple correlation of zeros at band $\lambda$ near
> $1$, i.e. outside the Rudnick–Sarnak range?**

If no, L2 is closed unconditionally by the pinch. If yes, the
three-matrix inequality becomes worth building — but only then. This
sharpens both prior readings: my own "closed within the moment frame"
(LEVER3 §5) understated it, and fleet-L3's "L2 gains priority"
(L3_SDP §3) is correct about *where sign freedom lives* but the band
retreat makes that freedom unpurchasable at current arithmetic
strength. The two verdicts are reconciled by the budget, not by
either side conceding.

Note the shape of the constraint: **certificate degree $k$ times
information bandwidth $\lambda$ is bounded by a constant.** That is an
exchange rate, and it is a theorem (Rudnick–Sarnak), not an analogy.
Hold that thought for §4.

### 1.1 Lock-in: three independent closures, one door

Since the pinch was written, a third closure landed from a different
direction (cf-prime, walk F25, `collab/FAILURES.md`, `exp61`). Put the
three side by side, because together they say something none says alone.

| axis of freedom | closure | proved by |
|---|---|---|
| **sign** — can the frame consume sign-indefinite (CGdL-type) data? | No. Degree-2 covariant functionals pair only through autocorrelations; the intersection with the out-of-band-negative constraint is the band-limited case. | `LEVER3` O1 and `L3_SDP` L3.2, independently and blind |
| **integrality** — is the multiplicity quantization under-spent? | No. Solving the exact integer program at the band-1 ceiling returns $(2/3)N$ simple and $(5/6)N$ distinct: $m^2\ge2m-1$ and $m^2\ge3m-2$ *are* the integer hull for these functionals, not lossy relaxations. Zero room. | F25 / `exp61` |
| **degree** — do higher traces buy anything? | No, and worse than "no": Prop 7.4's cap is a dimension bound independent of trace count, and Rudnick–Sarnak forces $\lambda<2/3$ for $k\ge3$, so every cubic certificate caps *below* the attained $0.6725$. Dominated. | §1 above |

Add CCLM17 (the Montgomery–Taylor window is optimal given $F$ on
$[-1,1]$, which is what fixes the achievable $S$) and the frontier
constants are **doubly optimal**: optimal extraction from $S$, and
optimal $S$. Three of the four degrees of freedom in the room are
provably exhausted.

> **The door.** Exactly one freedom remains: **change $S$** — i.e.
> unconditional information about band mass past $1$, in the form of an
> *upper* bound (the sign correction that both L3 landings made
> independently). Everything else in this frame is spent.

**Priced, same day** (`notes/BAND.md`): if $F\le B$ unconditionally on
$(1,\lambda]$, the flat-window certificate is
$V(\lambda,B)=2-\frac2\lambda+\frac{2}{3\lambda^2}-B(1-\frac1\lambda)^2$,
and optimizing the band collapses everything to
$$\lambda^*(B)=\frac{B-2/3}{B-1},\qquad
V^*(B)=\frac{2B-1}{3B-2},\qquad
B^*(\lambda)=\frac{2(2\lambda-1)}{3(\lambda-1)} .$$
$V^*$ decreases monotonically from $1$ (at $B=1$, the conjectured value)
to $2/3$ (at $B=\infty$, our present knowledge). **The entire remaining
unconditional gap in this frame is one constant**, the break-even bound
at $\lambda=4/3$ is $B^*=10/3$, and the $\lambda\le1$ wall is revealed
as not a structural boundary at all but the substitution $B=\infty$ into
a formula that is otherwise happy at any band. Three of this week's four
closures were exhaustions; this one was a missing number.

This is worth stating plainly because it is rare. A world-record method,
36 hours old, is already pinned on three sides by proofs from three
different directions, and the remaining door is named exactly. The atlas
thesis of §3 predicted that walls come with numbers and types; here the
prediction is met three times over in a single week, and the practical
consequence is that no further work in this frame should be funded
except through that one door — or by leaving the frame entirely, which
is what §5.4's $q$-aspect family proposal does (it does not buy band
mass; it changes the dimension budget that makes band mass expensive).

## 2. What the corpus has actually been proving

Strip the subject matter from the corpus's landed results and one
sentence remains, over and over:

> A method class computes only the invariants of a symmetry (or the
> pairings against a cone); the deciding information is in the
> complement; the only known escape is a *squaring*, whose price is one
> more order of arithmetic correlation.

Six independent theaters, all landed and audited here:

| theater | accessible object | invisible complement | escape |
|---|---|---|---|
| states (`GAUGE`) | gauge-neutral observables | parity charge | — (charge protected) |
| C*-core (`CORE_KMS`) | Bunce–Deddens core, unique trace | charged sector | — |
| derivations (`LENS_CHAITIN` C1) | axioms equal on both endpoints | endpoint identity | one side bit |
| eigenmeasures (`EIGENMEASURE` §3.6) | even Walsh sector | odd (charged) sector | two-copy square (product system) |
| inertia frame (`LEVER3` O1 / `L3_SDP` L3.2) | nonneg autocorrelation kernels | sign-indefinite data | odd traces (priced: §1) |
| sieve weights (`PROOF_MASS`) | LP-dual certificates | charged axioms | Type-II bilinear |

Two structural observations that I think are the corpus's genuine
discovery, and which are *not* about zeta:

**(a) The barriers are proved by the two-model method.** Every wall
above is established by exhibiting a pair of objects the method cannot
distinguish but which differ on the target: $\nu_\pm$; $\lambda$ and
its twist; on-line doubles versus off-line pairs of vanishing depth
(the manuscript's own extremal configuration, §7.5(b)); the doubly
positive cone versus the CGdL cone. This is exactly the proof method
of complexity theory's barrier theorems — Baker–Gill–Solovay's oracle
pair, Razborov–Rudich's indistinguishability from random. Analytic
number theory has *folklore* about the parity problem (Selberg's
example, Bombieri's asymptotic sieve) but no systematic theory of this
kind. The corpus has been reconstructing one.

**(b) "Annihilation, not obstruction."** `TOY_OBSTRUCTION` found every
cohomological receptacle vanishing; `KBOUNDARY` found the twist class
killed by connectedness. The corpus keeps looking for a *class* and
finding a *vanishing*. That recurrence is data. It suggests the right
invariant is not a cohomology class at all but a **visibility
functor** — the barrier is the kernel of a functor, not the
non-triviality of a class. Kernels are not classes; asking for a
receptacle may be the persistent category error.

## 3. The final form: an atlas, and why it is the right object

**The claim.** The final form of this program is not a proof of RH or
Chowla. It is a *complete, verified atlas of method-space*: a category
whose objects are method classes, each equipped with its accessible
cone or invariant algebra; whose morphisms are the enlargements
(squaring, transfer, extra traces, extra band); whose walls are proved
separating certificates with explicit indistinguishable pairs; and
whose conjectural structure is the exchange-rate law of §4. In that
atlas the famous problems are not isolated mysteries but **positions**:
each is specified by which cone it lies outside, and by how far.

Why this is the right target rather than a consolation prize:

1. **It is cumulative where theorem-hunting is not.** Every failed
   attack is an atlas entry. The corpus's own walk-yield norm is,
   correctly read, the instruction "every walk locates a wall".
2. **It is machine-native.** Producing indistinguishable pairs and
   separating functionals is search plus verification — exactly what a
   swarm does better than a person, and exactly what this session's
   audits, no-gos, and the L3 collision produced. The scarce human
   input is not proof-checking; it is category-jumping (§5 of
   `RESOLUTION`).
3. **It makes the resolving insight detectable.** `RESOLUTION.md`'s
   standing thesis is that the answer lies outside the corpus's
   category. An outside is only visible against an exactly mapped
   inside. A complete barrier atlas is the instrument that converts
   "wait for an orthogonal idea" into "here is the boundary; step over
   it here" — and, crucially, lets us *recognize* such an idea when a
   swarm generates one, instead of discarding it as unrelated.
4. **It is honest.** The atlas never claims more than it proves, and
   its entries are exactly the kind of statement this system verifies
   well (finite, exact, adversarially checkable).

## 4. The exchange-rate law (the atlas's predictive content)

An atlas of walls is a museum unless the walls obey a law. The
candidate:

> **Conservation of difficulty (conjecture).** In every theater above,
> the gap between what the invariant/linear method certifies and the
> truth is exactly one order of arithmetic correlation. Certificates
> have a degree (linear, bilinear, cubic); arithmetic inputs have an
> order (mean values, pair correlations, triple correlations); a wall
> is an exchange rate between them, and the escapes are purchases at
> that rate.

Evidence that this is a law and not a mood:

- **Proved instance:** Rudnick–Sarnak's $k\lambda<2$ is literally
  "degree $k$ certificate costs bandwidth $\lambda$, budget 2", and §1
  shows the budget is *saturated* by the current record — the frontier
  result sits exactly on the constraint surface.
- **`PROOF_MASS`** already states an exchange inequality in the sieve
  theater (proof mass × charge concentration ≥ certified bound), with
  explicit constants.
- **Chowla-2** (Tao) buys the charged 2-point sector with
  Matomäki–Radziwiłł + entropy decrement — a bilinear-strength input
  for a degree-2 certificate.
- **Weak-mixing ⇒ Bernoulli** (`EIGENMEASURE` Thm 3.3) buys the odd
  Walsh sector with a product-system hypothesis — degree 2 again.

If the law is real, the atlas becomes predictive: for any proposed
attack, read off the degree of its certificate, read off the order of
correlation it must purchase, and check the budget *before* spending
months. §1 is that calculation done once, and it killed a lever in a
paragraph.

The sharpest open form: **is the budget constant (2) universal, or is
it theater-dependent?** If universal, it is a fact about arithmetic
information, not about any one method — and that is a theorem worth a
decade.

## 5. Integration: the discharge theory, and what it does to the levers

### 5.1 The technique class has a checklist, and history

The exploratory pass on *hypothesis discharge by compression* (the
frontier's actual move) returns a six-condition checklist: **N1**
two-sided evaluability (a duality computing ≥2 spectral moments
unconditionally); **N2** a quantized, *paired* defect with bounded
signature per unit of failure (the functional equation supplies it,
and makes the reading depth-blind); **N3** rank/inertia-expressible
conclusion (congruence-only bookkeeping); **N4** an integrality to
leverage; **N5** lossless critical density (no aliasing) with its hard
dimension cap; **N6** the hypothesis must appear *only* as a sign, not
as a rate.

Two historical corrections worth recording. Bombieri's 2000 Lincei
paper on Weil's quadratic functional already studies finite
truncations of the same form and shows that finitely many off-line
zeros force $n_-$ to be exactly half their number. **The compression
and the inertia reading are 26 years old.** What was missing was N4
routed through a rank–trace inequality against a *second*
unconditionally evaluated trace: Bombieri read $n_-$; the frontier
reads rank and $n_+$. Separately, the abstract technology of finite
compressions certifying positivity is Lasserre's moment–SOS hierarchy
with the Christoffel–Darboux kernel — and the manuscript's own ceiling
$1-\Lambda_m(0)$ *is* Lasserre's Christoffel object, which is exactly
why escaping it requires leaving the moment frame.

### 5.2 Two crisp principles that reorganize the inventory

**(i) Compression counts; it cannot measure.** N2's depth-blindness —
an off-line pair contributes signature $(1,1)$ *however far off the
line it sits* — is what makes the method work and simultaneously makes
it useless against every problem whose enemy is a single zero's
*depth*: Linnik/least prime in AP, effective Chebotarev, class
numbers, Siegel zeros, Lehmer/Mahler. There GRH supplies a rate, not a
sign (N6 fails), and the quantity to be bounded is a distance, which
signature cannot see. This is a clean, permanent boundary of the whole
technique class.

**(ii) Elliott–Halberstam is a *level* hypothesis, i.e. the analogue
of the band $\lambda\le1$ — not of RH.** In GPY/Maynard/Polymath the
finite-dimensional compression *already exists* (the ratio of quadratic
forms $M_k(\theta)$, optimized by LP/SDP), and $\theta$ enters as the
support constraint on sieve weights, never as a sign. So bounded gaps
and the critical-line proportion are the *same* structure with the
same two parts, and the thing EH plays the role of is the band.
Nothing discharges a level hypothesis, because the compression's
moments are computed *using* the arithmetic input in that range. This
is the sharpest unification of the corpus's two largest programs so
far.

**(iii) The dichotomy.** Positive-cone blindness (LEVER3 O1 /
L3_SDP L3.2, now seen as an instance of a general fact about degree-2
covariant functionals) splits conditional arguments in two:
*Bochner-class* mechanisms — where the hypothesis is a positivity that
can be read as a signature — are dischargeable; *Cohn–Elkies-class*
mechanisms — where the gain comes from a test function of one sign in
space and the opposite sign in frequency — are provably unreachable by
any degree-2 compression, on any frame (lattice or not: LEVER3's
forecast F-C is correct and is a one-page proof).

### 5.3 Where I disagree with the exploratory verdict, and why it matters

The pass recommends the **cubic trace** as the unique unexcluded door,
on the narrow window $\lambda\in(\tfrac12,\tfrac23)$, and asserts that
Prop 7.4's cap "was derived for the two-trace frame and must be
re-derived". **I think that is wrong, and §1's Pinch Theorem is the
reason.** Prop 7.4 has two clauses: the second, $(2-1/\lambda_1)$, is
indeed two-trace-specific; but the *first* is a pure dimension bound —
$\operatorname{rank}P\le d=\lambda_1N$ — and no certificate of any
trace-degree can certify more on-line points than the dimension of the
compression. So on $\lambda<\tfrac23$ every certificate, cubic or
otherwise, is capped below $\tfrac23<0.6725$. The three-matrix
inequality can be beautiful and still buy nothing.

The two readings are not in conflict about the mathematics; they are
in conflict about *which constraint binds first*. The exchange rate
(§4) binds first, and it binds on dimension.

### 5.4 What survives: change the dimension budget

Combining the checklist with the pinch leaves exactly one door open in
this direction, and it is the pass's own top-rated entry for a
different reason than it gave: **the $q$-aspect family compression for
Dirichlet $L$-functions.** A two-index Gabor frame (ordinate ×
character) has a dimension budget set by the *family size*, not by a
single $\zeta$'s band; and the $\lambda\le1$ wall is a
Montgomery–Vaughan diagonal-dominance artifact of the single-$\zeta$
setting, where in a family the off-diagonal second moment is
classically controlled past it by the **large sieve** — an
unconditional tool that is strong exactly where the single-$\zeta$
argument dies. Since $H'(1)=\tfrac23>0$, any band past 1 pays
linearly and immediately.

This is the first target I have seen that survives all three filters:
cone blindness (it does not need sign-indefinite data), the pinch (it
changes the dimension budget rather than spending it), and N1–N6 (the
functional equation, integrality and explicit formula transfer
verbatim). The manuscript's Theorem E took the cheap transfer — fixed
$\chi$, same wall. The family version requires re-proving the
no-aliasing sampling identity across character orthogonality on a
two-index frame. That is a concrete, bounded, and as far as the pass
could determine unclaimed piece of mathematics.

### 5.5 THE CONVERGENCE: parity is invisible to every *topological* invariant and visible only to *order* invariants

Four independent inquiries, asked different questions, returned the same
structure. I did not anticipate it and it is the most important thing in
this note.

**(a) Tate cohomology cannot receive the charge, for a one-line reason.**
Let $G$ be finite and $A$ a module on which $|G|$ is invertible; then
$\hat H^n(G,A)=0$ for all $n$, and the contracting witness is
$\tfrac12(1+\tau)$ — **the twirl idempotent itself**. So the candidate
"parity = a Tate class" is self-refuting in the sharpest possible way:
*the projector whose existence constitutes "linear methods see only
invariants" is the same datum as the vanishing of the proposed
obstruction group.* Wherever we can average, the receptacle is zero;
wherever the receptacle could be nonzero, we cannot average and the
barrier does not arise in this form. `TOY_OBSTRUCTION`'s "annihilation,
not obstruction" was not an accident of that toy — it is this theorem,
in the one receptacle that note had not tested.

**(b) K-theory cannot receive it, because the gauge torus is connected.**
`KBOUNDARY` already proved this; the new reading is that it is the *same*
statement: $(\alpha_\lambda)_*=\mathrm{id}$ because homotopy invariance
averages over the connected torus. The class exists but equals the
identity twist's — mod-2 reduction of the ambient group, blind by
construction.

**(c) The metaplectic sign cannot be it, and this is now a theorem.**
The seductive guess — the $\mathbb Z/2$ of the Weil index *is* the parity
charge — dies on the product formula: $\gamma_v$ is local, trivial for
almost all $v$, $\prod_v\gamma_v=1$, so every such charge has **finite
conductor**, i.e. lies in $\bigoplus_p\mathbb Z/2$. But $\lambda$ lies in
$\prod_p\mathbb Z/2\smallsetminus\bigoplus_p\mathbb Z/2$: infinitely
supported, no conductor, no finite-level shadow (`GAUGE` Lemma F.2,
`KBOUNDARY` §4.1). Corollary, and it is a general no-go worth stating on
its own: **any construction that gives $\lambda$ a finite conductor is
dead on arrival** — $\theta$-multipliers, spin structures, every
$\varepsilon$-factor route.

**(d) The same three kills, in one sentence.** Averaging kills it
(Tate/twirl). Homotopy kills it (connectedness/K-theory). Locality kills
it (product formula/metaplectic). Every receptacle the corpus has tried
is invariant under exactly the operation that destroys the charge.

**And now the positive half.** What survived every filter, in two
independent inquiries that were not talking to each other:

> **Inertia-type invariants**: signature, rank drop, positive index,
> spectral flow, Maslov index. These are stable under *congruence* but
> **not** under homotopy; they are order-theoretic, not topological; they
> are not computed by averaging; and they are exactly what counts
> degeneracies of an **indefinite** form along a path.

Read the corpus's own history against that line and it snaps into two
columns:

| invariant type | theaters | verdict |
|---|---|---|
| topological / averaged / local — states, traces, KMS, K-theory, Čech, $\varprojlim^1$, cohomology classes, $\varepsilon$-factors | `GAUGE`, `CORE_KMS`, `KBOUNDARY`, `TOY_OBSTRUCTION` | every one vanishes or is charge-blind |
| order-theoretic — cones, positivity, LP/SDP duality, inertia, signature | `PROOF_MASS`, `LP_CERT`, `L3_SDP`/`LEVER3`, and **the frontier $2/3$ theorem** | every one returns a *number* |

**This is the thesis of the final form.** The frontier result is not
merely a record; it is the first evidence that the receptacle search was
in the wrong category all along. Parity — and by extension the deciding
information in this whole program — is not a class, a state, or a
homotopy invariant. It is an **order phenomenon**, and the instruments
that see it are Sylvester inertia, Krein/Pontryagin indefinite-form
theory, spectral flow, and convex duality. The corpus spent months
proving, in five languages, that the topological column is empty. That
was not wasted: it is the proof that the order column is the only one
left.

The sharpest form of the resulting design constraint (from the
one-object inquiry, and I think it is right):

> **Rigidity trap.** If the gauge circle acts on the carrier by
> isometries of the pair form, the spectral flow vanishes identically and
> we are back in the topological column. Since $W_\lambda$ *is* spatially
> unitary on $\ell^2(P)$, that is precisely why every earlier receptacle
> vanished. **The object must be built so that $\lambda$ is a
> non-isometric deformation of an indefinite form** — not a symmetry of
> it.

First concrete theorem this proposes: compute the spectral flow of the
frontier's own finite Gabor compression under gauge rotation, and prove
it is nonzero exactly when the charge is infinitely supported. A proof
separates parity from every boundary-visible charge by a
non-homotopy-invariant index. A disproof means inertia is charge-blind
too, and then the corpus should stop looking for a receptacle entirely
and accept that the missing input is irreducibly non-invariant data.

### 5.6 Three corrections the swarm forced on §2 and §4

**(i) "Two copies escape" is false as a universal law.** In the inertia
theater the two-copy square is the *trap*, not the escape:
$\operatorname{tr}G^2$ is already bilinear and already blind (that is
exactly O1), and the proposed escape is $\operatorname{tr}G^3$. The
five-theater story in §2 had the sign backwards for the sixth theater.
What is true is narrower and better: the norm $N(x)=x\,\tau(x)$ is the
*Tambara* norm — genuinely extra data, not determined by the additive
structure — and the Tambara distributivity axiom, which expands a norm
of a sum into transfers of norms, **is** the polarization identity whose
cross-terms are the Type-II bilinear sum. That identification is real
and, as far as the search found, unmade in the literature. But
$\mathbb Z/2$ has only one norm, so it predicts no cubic escape; a third
escape must come from $\Sigma_3$ on three copies or from cone geometry.

**(ii) The flagship wall is slackness, not separation.** O1's separating
functional is identically zero: the two cones meet in a common face, and
`L3_SDP`'s Prop L3.3 says the added constraint is slack at every
realizable point. §3's "wall = exhibited separator" is the right verb for
the quantitative walls and the wrong one here. The generative product is
therefore a **slackness calculus**: given a method-cone and a free
positivity fact, decide *before* spending months whether it can move the
value at all — it is slack iff $-\varphi$ lies in the closed conic hull
of the realizable set. `L3_SDP` performed that computation once by hand;
done systematically it audits every "free input" the corpus has.

**(iii) Not every wall is conic, and the exceptions are a type, not a
residue.** $\operatorname{Der}(\mathbb Z)=0$ is a *representability*
failure (a Hom-set is a point; there is no margin to degrade — every
conic wall carries a distance, this one carries only $0$); `KBOUNDARY` is
a wall by *deformation* ($\pi_0$ of a group — the opposite move from
separation); Chebotarev is a *quantization* wall (finite-order characters
admit no relaxation); `DCLOSE_NO_GO` is two-model logic with the
convexity stripped (quartic functional, discrete configurations, a
$\limsup$ over an infinite family). So the correct statement of §3 is:
**conic duality characterizes the walls that carry a number**, and there
are at least four other wall *types*, each with its own signature. That
is a finer atlas, not a broken one — and "what type is this wall?" is now
a well-posed question with a short answer list.

### 5.7 What $\mathbb Z$ actually lacks — the inconsistency is not where it is usually placed

The missing-structure inquiry returns a theorem rather than a survey.
Take the wish list: **W1** the shell is $G(k)$ for a connected commutative
group over a finite base; **W2** the shift is translation in $G$; **W3**
the shell carries $\mathbb Z$'s multiplication (so $\lambda$ means what it
means); **W4** an additive endomorphism with kernel of density
$X^{-1+1/p}$ on which the coefficient object is rank-1 abelian.

> **Exponent rigidity.** W1+W2+W4 force the shell's additive group to
> contain a subgroup of index $X^{1-1/p}$ and **exponent $p$** (the
> inseparable direction, as $\mathbb F_q[T^p]\subset\mathbb F_q[T]$). W3
> forces that subgroup to be a set of integers closed under addition,
> hence torsion-free and of infinite exponent. Contradiction.

So the inconsistent pair is **W3 against W1/W4** — *not*, as the corpus
and the folklore both say, "$\mathbb Z$ has no connected deformation".
The design conclusion is sharp and new: **the missing object cannot carry
$\mathbb Z$'s multiplication.** It must be a correspondence between two
distinct multiplicative structures with $\lambda$ transported across.

The corollary is the conservation law again, in its cleanest instance.
There *is* now a genuine connected deformation over $\mathbb Z$ — the
Habiro ring / $q$-de Rham theory (Garoufalidis–Scholze–Wheeler–Zagier
2412.04241; Wagner 2510.04782), where the $q$-derivative is a
$\sigma$-derivation on $\mathbb Z[q]$ and so escapes
$\operatorname{Der}(\mathbb Z)=0$ entirely, and $[n+1]_q=[n]_q+q^n$
deforms the shift. It buys W1/W2 honestly. And it **deforms the wrong
invariant**: $[n]_q=\prod_{d\mid n,\,d>1}\Phi_d(q)$, so
$\Omega\rightsquigarrow d(n)-1$ and the parity charge degenerates at
$q\to1$ to the *square indicator*. Every construction that drops W3 to
buy connectedness loses exactly the invariant $\lambda$ measures. That is
why "$\mathbb F_1$ will fix it" has never produced a single cancellation
estimate — the trade is forced, not incidental.

And the heretical reading, which I now believe: **entropy decrement is
not a stopgap for absent monodromy; it is the correct engine for a base
whose only connected symmetry is multiplicative.** $\mathbb Z$'s
available connected group is the scaling flow (the completion of
$\mathbb N^\times$), whose invariant measure is $dn/n$ — which is
*exactly why* logarithmic averaging is not a technical convenience but
integration against the Haar measure of the only connected group
present. The "missing geometry" framing looks for connectedness in the
additive direction, where $\mathbb Z$ is provably rigid, while the
deformation exists in the multiplicative direction and the known
theorems (2-point log-Chowla, all odd orders) are precisely what that
direction yields. Decisive test: **power saving.** Soft methods
currently cannot reach even $1/\log\log$; a power-saving 2-point Chowla
by soft means makes geometry unnecessary, and a proof that any
dilation-invariance-only argument must lose a log-iterate is a genuine
barrier theorem — and the single most valuable thing this program could
attempt next in that lane.

### 5.8 The independence north star is valid and strategically empty — and its replacement is in the order column too

`RESOLUTION.md` §2 records a standing north star: RH is $\Pi^0_1$, so
independence from a sound theory *implies truth*, hence "independence
results ARE resolution results". The logic audit returns: **true, sharper
than stated, and useless — for a reason that is itself a theorem.**

Sharpenings first. The $\Pi^0_1$-ness should be argued from *effective
zero-localization* (the argument principle turns "a zero off the line"
into a winding number on a rational contour at finite precision; the load-
bearing hypothesis is **strictness**, since strict inequalities on
computable reals are semidecidable and non-strict ones are not) — not from
the elementary criteria. Lagarias/Robin *look* $\Pi^0_1$ and are
logically worse: comparing two computable reals is undecidable without a
*proved separation margin*. And the hypothesis needed is far weaker than
soundness: if $T$ interprets Robinson's $Q$ and $T\nvdash\neg$RH, then RH
is true — unrefutability alone, with $\mathrm{EA}$ as metatheory.

Now the kill. $T\nvdash\neg\mathrm{RH}$ **is** $\mathrm{Con}(T+\mathrm{RH})$.
For $\Pi^0_1$ statements consistency *is* truth, so the "independence
route" is not a cheaper path — it is the same mountain relabelled, and
strictly more expensive: any proof of it proves $\mathrm{Con}(T)$, so the
metatheory must exceed $T$ in consistency strength. Worse, the one
industrial-scale independence machine mathematics owns is **provably
inapplicable**: $\Pi^0_1$ (indeed $\Sigma^1_2$) sentences are absolute
between $V$ and generic extensions by Shoenfield, so forcing cannot
deliver arithmetic independence at all. And there is no precedent and no
mechanism: every classical independence result (Paris–Harrington,
Goodstein, hydra, Friedman) is a $\Pi^0_2$ totality statement whose
independence is ordinal exhaustion — it needs an *output that grows*.
Analytic number theory has no such shape; PNT is provable in
$I\Delta_0+\exp$ (Cornaros–Dimitracopoulos). RH's difficulty is
**quantitative** (a missing cancellation estimate), not **ordinal** (a
missing induction).

The corpus should retire the north star as a route and keep it only as a
logical footnote. Its replacement is the direction the corpus already had
and had filed under the wrong logic: **resource-bounded unprovability
(proof complexity), not ordinal-bounded unprovability (reverse
mathematics).** The right ancestor is not Gödel but Razborov–Rudich and,
more precisely, Grigoriev-style *degree lower bounds for positivity
certificates*: Grigoriev's $\Omega(n)$ SOS degree bound for the mod-2
counting principle says **low-degree positivity certificates cannot see a
mod-2 invariant** — which is, word for word, "charge-even observables
cannot see $\lambda$", in a system where it is a theorem.

Note where that lands: *degree of a positivity certificate*. The
metamathematics arrives in the same column as everything else (§5.5).

Two further gifts from that inquiry. **(i) `LENS_CHAITIN`'s C1 is a
pseudo-expectation** — the standard dual object in Positivstellensatz/SOS
lower bounds — and did not know it; that identification tells us exactly
what C1 must become: closure (every published sieve argument compiles
into the calculus), noisy feasibility (C1 §4 is the real mathematics),
and degree $>1$ (products of axioms break affineness, so the two-point
endpoint pair must become a genuine pseudo-measure). **(ii) The Beurling
wall**, which I think is the cleanest new constraint in this note: RH is
*false* for some Beurling generalized-prime systems (Diamond–Montgomery–
Vorhauer), so **every proof of RH must invoke an axiom separating
$\mathbb Z$'s prime system from those systems.** That is a checkable,
non-metaphorical, permanently binding constraint on all future proofs —
and it is exactly the kind of entry the atlas exists to hold. It also
supplies the countermodel source for the degree-$k$ pseudo-measure.

The concrete year-long target that came out of this, stated so it can be
attacked: fix $\theta<1/2$, $k$, and a calculus $\mathfrak L(\theta,k,X)$
whose axioms are congruence sums to level $X^\theta$, smooth archimedean
moments, and Buchstab/Bombieri identities of depth $\le k$, each with its
*proved* error interval, closed under nonnegative combination and
products of $\le k$ axioms. Prove there is a degree-$k$ pseudo-measure
feasible for every axiom with $\Lambda(1)=X(1+o(1))$ and
$\Lambda(\mathbb 1_{\rm Prime})=0$. That makes the parity barrier a
theorem about a class of proofs rather than folklore, with an escape
clause naming Type-II/bilinear input as the axiom outside the fiber.

### 5.9 Two species of definition — and the one place machine taste might be computable

The inquiry into whether "taste" is formalizable returns a clean split
that I think is the right frame for the whole mathematics-after-AI
question:

- **Completion-type definitions** (Kummer/Dedekind ideals, group
  characters) are *pinned*: a consequence-web stated in the old language
  determines them uniquely. They are findable by search — which means
  machine-findable, now.
- **Reframing-type definitions** (sheaf, scheme, derived category) are
  *not pinned by anything*: they change the category. Every candidate
  criterion that works on the first species fails on the second.

The failure is precise and worth recording, because it kills the obvious
schema (good = minimal sufficient statistic for the question class + a
proof speedup). **The nilpotent is the counterexample.** Every statement
in the 1949 Weil-conjecture question class factors through the *reduced*
functor, so a minimality-driven optimizer discards nilpotents — and with
them the best definition in the modern canon. Generalizing:
minimality-for-$Q$ is **anti-correlated with generativity**, because the
surplus a definition carries beyond $Q$ is exactly the reserve that lets
$Q$ grow. (Adjacent, and also worth keeping: Vereshchagin–Vitányi's
structure-function results say the sufficiency line can be *flat* — many
models of wildly different complexity lose nothing about present data, so
the tie is not broken by the data, as a theorem — and minimal randomness
deficiency is not monotonically computably approximable, so a machine can
*produce* good models while provably being unable to certify the fit.)

What survives is one conjecture, and it is horizon-free, corpus-relative,
and computable at time $t$:

> **Representability-gain criterion (conjecture).** Among sufficient
> statistics for the current question class, the good definition is the
> one maximizing the number of *previously named but unrepresentable*
> functors that become representable.

It rejects minimality (predicting surplus rather than penalizing it),
escapes Yoneda vacuity by *counting* rather than asserting, and it is
testable by retrodiction: freeze the corpus at 1955, confirm every
classical statement factors through the reduced closed-point functor, then
rank by representability-gain the named-but-unrepresentable functors of
that moment (tangent/deformation, Hilbert, Picard, fibre products over
arbitrary bases) and see whether Spec-with-nilpotents-and-generic-points
wins over its nearest competitors *from 1955 data alone*. If it does,
definitional taste is a computable functional of the corpus and the only
irreducible residue is forecasting. If it does not, the residue is
horizon, exactly located.

This is the honest answer to "what does the machine do and what do we
do": **machines can close completion-type questions today**, and the open
problem — the actual frontier of mathematics-after-AI, stated as
mathematics rather than as workflow — is whether reframing-type
definition can be made computable, with representability-gain as the first
serious candidate.

## 7. The final form, stated

All seven inquiries are in. Five of them, asked different questions in
different languages, landed on one distinction, and I did not put it in
any of the briefs:

> **Everything that averages, deforms, or localizes is blind to the
> deciding information. Everything that sees it is an order structure.**

- Averaging kills it: the twirl idempotent $\tfrac12(1+\tau)$ *is* the
  contracting homotopy that makes Tate cohomology vanish (§5.5a).
- Deformation kills it: connectedness of the gauge torus makes
  $(\alpha_\lambda)_*=\mathrm{id}$ (§5.5b).
- Localization kills it: the product formula forces finite conductor,
  and $\lambda$ has none (§5.5c).
- Ordinal strength is the wrong axis entirely: RH's difficulty is
  quantitative, not ordinal; forcing is provably inapplicable (§5.8).

And on the other side, every instrument that has ever returned a
*number* in this corpus is order-theoretic: cones and their duals
(`PROOF_MASS`, `LP_CERT`), positivity certificates and their *degree*
(the correct form of the metamathematics, §5.8), Sylvester inertia and
signature (the frontier $2/3$ theorem), spectral flow and Maslov index
(the only surviving receptacle for the parity charge, §5.5), and the
exchange rate that prices all of it (§1, §4).

**So the final form of this program is a barrier atlas written in the
order category** — not the topological one, and not the
proof-theoretic-ordinal one. Its objects are method-cones; its walls
come in a short list of types (separation with a margin; slackness at a
common face; representability failure; deformation/connectedness;
quantization; horizon); its numbers are the method spectra; its law is
degree $\times$ bandwidth $\le$ const; and its receptacle for the charge,
if one exists at all, is a non-homotopy-invariant index of an indefinite
form.

That is a research program with actual mathematics in it, and it is the
right target for a machine collaboration for a reason that is now
provable rather than aspirational: **the order column is exactly the
column where verification is finite and adversarial** — signatures,
ranks, cone memberships, certificate degrees. The corpus spent months
proving the topological column empty. That was not waste; it is the
proof that the remaining column is the only one, and it is the one this
kind of system is built to search.

### The five things now worth doing

1. **The $q$-aspect family compression** (§5.4) — the only target that
   survives cone blindness, the pinch, and the N1–N6 checklist, and it
   is world-record-relevant. The band wall $\lambda\le1$ is an artifact
   of the single-$\zeta$ diagonal; in a character family the large sieve
   controls the off-diagonal past it, and $H'(1)=2/3>0$ pays linearly.
2. **The spectral flow of the frontier's own Gabor compression** under
   gauge rotation (§5.5) — decisive either way: nonzero exactly for
   infinitely-supported charges separates parity from every
   boundary-visible charge by a non-homotopy-invariant index; zero means
   inertia is charge-blind too and the receptacle search should stop
   permanently.
3. **The sieve-calculus degree lower bound** with a Beurling
   pseudo-measure (§5.8) — turns the parity barrier from folklore into a
   theorem about a class of proofs, and the Beurling wall (every proof of
   RH must invoke an axiom separating $\mathbb Z$'s primes from systems
   where RH is false) is already a permanently binding constraint.
4. **Power saving versus the log-iterate barrier** (§5.7) — decides the
   geometry-versus-entropy question: prove 2-point Chowla with a power
   saving by soft means and the missing geometry is unnecessary; prove
   that dilation-invariance-only arguments must lose a log-iterate and
   the geometric framing is vindicated. Either is a barrier theorem.
5. **The slackness calculus** (§5.6ii) — the cheap one, run first:
   before any lever is funded, decide whether the "free" input it hopes
   to exploit is slack at every realizable point. `L3_SDP` did this once
   by hand and killed a lever in a page.

And one meta-mathematical question that is genuinely open rather than
rhetorical: **is definitional taste computable?** The
representability-gain conjecture (§5.9) is the first candidate with a
retrodiction test attached. Completion-type definitions are already
machine-findable; whether reframing-type ones can be is the real
frontier of mathematics-after-AI, and it is a mathematical question, not
a workflow question.

## 8. What would falsify this note

§7's dichotomy is falsified by exhibiting a *topological* invariant that
sees the charge (the decisive test is §5.5's: find a theater where 2 is
not invertible, with a nontrivial — not trivial-by-connectedness —
$\mathbb Z/2$ action, and a nonvanishing $\hat H^0$ that localizes at
$p^*$). The atlas thesis is falsified if wall types do not compose —
if the entries in different theaters share no language after §5.6iii's
type list is applied honestly. The exchange-rate law is falsified by any
certificate that buys correlation order without paying bandwidth. And
§1's pinch is falsified by an unconditional evaluation of triple
correlation outside the Rudnick–Sarnak range, which would also be a
significant theorem in its own right.

## 6. Rigor boundary

**Proved here:** the Pinch Theorem of §1, conditional only on the two
cited manuscript statements (Prop 7.4's cap and §7.5(e)'s
Rudnick–Sarnak range) being read correctly; both were read from the
primary PDF this session, not from memory. Anyone auditing should
re-read those two statements first — the whole of §1 rests on them.

**Conjectural:** §4's conservation law (four instances, no proof, and
the "exactly one order" clause is the part most likely to be wrong —
it may be "at least one order").

**Programmatic, not mathematical:** §3. It is a claim about what to
build, and it is falsified if the atlas entries turn out not to
compose — i.e. if walls in different theaters have no common language
after all. §2's table is the current evidence that they do.
