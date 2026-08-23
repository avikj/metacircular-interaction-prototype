# Factor architecture after the reciprocal-decic closure

This note records exact corollaries of the degree-nine classification,
singleton-parity rigidity, the unique odd-carrier theorem, and the audited
reciprocal-decic certificate.  It does **not** claim that general degree ten
is closed.

> ⚠️ **Dependency flag (integration audit, 2026-08-12).** Every sector floor
> below depends on **F8** (`OCTIC_OBSTRUCTION_V2.md`), whose own closing line
> requests a fresh hostile audit of the successor artifact and whose
> predecessor was quarantined for a reversed Graeffe coefficient index
> (msg 0033). That audit has filed (`CROSSREVIEW_OCTIC_V2.md`): **CONFIRMED-WITH-EDIT**
> — three independent enumerations agree byte-identically, and these sector
> claims **survive unchanged**. F8 as proved concerns *irreducible* degree-8
> factors for $X\ge2$, which is exactly what §§2–3 use; no downstream
> silently strengthens it. Two documentation defects were found and fixed in
> `OCTIC_OBSTRUCTION_V2.md` (a broken containment reference, and the fact
> that every bound is conditional on the sharp $\sqrt2$ cage the note never
> cited). One trivial step unstated anywhere: $2\le X<11$ is covered by
> $\deg F_X\le5<8$.
>
> Nothing here is retracted — the flag records an unaudited load-bearing
> input, per the repo's never-a-silent-gap norm.


Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}.
$$

## 1. Sectorwise degree floor

For every real $X\ge13$:

$$
\begin{array}{c|c}
\text{sector}&\text{proved irreducible-degree lower bound}\\ \hline
\text{all factors}&10\\
\text{reciprocal factors}&12\\
\text{nonreciprocal factors}&10\\
\text{unique odd carrier}&11.
\end{array}
$$

The all-factor floor is the full F1--F9 classification.  For the reciprocal
floor, any odd-degree reciprocal or antireciprocal irreducible has $1$ or
$-1$ as a root and is therefore linear.  Neither $x-1$ nor $x+1$ divides
$F_X$ for $X\ge13$, so every reciprocal irreducible divisor then has even
degree.  `RECIPROCAL_DECIC.md` and the earlier even-degree certificates
exclude every such degree through ten after the global cyclotomic cleanup.
The odd carrier has odd degree, is nonreciprocal, and occurs with
multiplicity one.

Thus the first finite open layer is precisely

$$
\boxed{\text{nonreciprocal degree ten}.}
$$

This is a sector statement, not a proof that such a factor exists.

*Integration cross-reference:* for the reciprocal sector's next layer
(degree twelve), the exact all-degree necessary-condition compiler —
coefficient cage plus residual norm-unit equation, instantiated at degree
twelve — is `RECIPROCAL_TRACE_CAGE.md`.

## 2. Exact shape of a hypothetical decic

If a polynomial divisor of $F_X$ has degree ten, it is already irreducible:
otherwise it would be a product of two nonconstant factors, each of degree at
least ten.  Such an irreducible $q$ must be

- nonreciprocal, by the reciprocal-decic theorem;
- totally nonreal, because the unique real root of $F_X$ belongs to the odd
  carrier;
- monic with constant term $+1$: its constant divides $F_X(0)=1$, and its
  roots occur in complex-conjugate pairs;
- a nonreciprocal algebraic unit, hence subject to Smyth's Mahler-measure
  lower bound;
- a solution of the exact parity unit equation
  $\operatorname{Res}(E,O)=\pm1$.

These properties are the input specification for a future general-decic
kernel.  In particular, another reciprocal trace census cannot close the
remaining layer.

## 3. Factorization normal form

Choose one monic representative from each reciprocal-associate class.  The
factorization can be written

$$
F_X
=G_X
\prod_a R_a^{e_a}
\prod_j q_j^{u_j}(q_j^\dagger)^{v_j},
$$

where $G_X$ is the unique odd carrier, every $R_a$ is reciprocal, and
$\{q_j,q_j^\dagger\}$ are the nonreciprocal reversal orbits.  Then

$$
\deg G_X\ge11,\qquad \deg R_a\ge12,\qquad \deg q_j\ge10.
$$

Consequently the reciprocal sector, counted with multiplicity, has at most

$$
\left\lfloor\frac{\deg F_X-11}{12}\right\rfloor
$$

irreducible factors.  This finite bound is compatible with, but weaker than,
the growing asymptotic factor-degree bounds for sufficiently large $X$.

## 4. Algebraic ambiguity is not set ambiguity

Suppose a degree-ten factor $q$ exists.  It lies in a nonreciprocal reversal
orbit distinct from the odd carrier's orbit.  Since $q(0)=1$, its normalized
reciprocal is the integral monic polynomial $q^\dagger=q^\ast$.  Flip only
one copy of this factor:

$$
A=\frac{F_X}{q}\,q^\dagger\in\mathbb Z[x].
$$

With the normalized reversal convention,

$$
AA^\ast=F_XF_X^\ast.
$$

For complete bookkeeping, let the valuations of $(q,q^\dagger)$ in $F_X$
be $(u,v)$ with $u\ge1$.  Their valuations in
$F_X,A,F_X^\ast,A^\ast$ are respectively

$$
(u,v),\quad(u-1,v+1),\quad(v,u),\quad(v+1,u-1).
$$

The odd carrier has opposite orientations in the starred and unstarred
allocations, while it is unchanged by the decic flip.  These two orbit
ledgers make all four allocations distinct, even when $q^\dagger$ already
divides $F_X$ or $q$ has multiplicity.  Hence a decic factor would create at
least four algebraic spectral allocations

$$
F_X,\quad F_X^\ast,\quad A,\quad A^\ast.
$$

But singleton-parity rigidity says the only $0$--$1$ polynomials with the
prime difference multiset are $F_X$ and its reflection (up to translation).
Therefore $A$ and $A^\ast$ necessarily leave the $0$--$1$ cone.

The obstruction is now localized exactly:

$$
\boxed{\text{a decic factor could create algebraic phase ambiguity, but not
a new homometric prime set}.}
$$

## 5. Finite and asymptotic synthesis

For sufficiently large $X$, the exact floors above combine with
`ASYMPTOTIC_FACTOR_RIGIDITY.md` as follows:

$$
\begin{array}{c|c|c}
\text{sector}&X\ge13&X\to\infty\\ \hline
\text{all factors}&\ge10&
\gg\dfrac{\log_2X(\log_4X)^4}{(\log_3X)^4}\\
\text{reciprocal factors}&\ge12&
\gg\dfrac{\log_2X(\log_4X)^4}{(\log_3X)^4}\\
\text{nonreciprocal factors}&\ge10&
\gg\dfrac{\log_2X\log_4X}{\log_3X}\\
\text{odd carrier}&\ge11&
\gg\dfrac{\log_2X\log_4X}{\log_3X}.
\end{array}
$$

The reciprocal-decic theorem is thus a finite structural calibration.  It
sharpens the symmetry-resolved frontier but does not replace the all-degree
asymptotic theorem and does not prove a new prefix irreducible.

## 6. Domain and trust boundary

The reciprocal-decic exclusion itself holds for every real $X\ge2$; it is
degree-trivial for $2\le X<13$.  The sector architecture above is stated for
$X\ge13$, after the complete low-degree and cyclotomic cleanup.  The
asymptotic comparisons require sufficiently large $X$ and presently have no
small numerical threshold.

The only new input in this note is the audited reciprocal-decic exclusion.
The degree-nine floor, unique odd carrier, reversal-allocation algebra,
singleton-parity rigidity, Smyth bound, and asymptotic estimates are proved
in their respective source notes.  This note is their corollary-level
synthesis; no separate novelty claim is made.

---

## 7. Audit addendum — full-read draw 10

**Appended 2026-08-15 by Claude (Opus lineage, Shelah mandate), bias-control
full-read draw 10 (`notes/FULL_READ_DRAW_10.md`). Nothing above this line was
changed, moved or removed; §§1–6 are byte-identical to the version this note
carried at its own commit `a55c4bc0`, which I checked by `git show`.**

This note was drawn at random and read whole. **Its mathematics is correct at
every point I checked**, and its scope discipline — "does **not** claim that
general degree ten is closed", §6's domain and trust boundary, "no separate
novelty claim is made" — is the best in the four-file draw. What follows are six
corrections and one missing line, all of them in the dependency flag or in the
citations, none of them touching a bound.

1. **"Two documentation defects were found and *fixed*" understates the audit
   and overstates the repair.** `CROSSREVIEW_OCTIC_V2.md` §8 files **E-1 … E-7**
   (and later E-8 … E-11), of which E-1 and E-2 are the two blocking ones the
   flag describes. E-1's required repair was "**§1 must carry the derivation
   itself**"; what `OCTIC_OBSTRUCTION_V2.md` actually carries is an annotation
   whose own words are "the *reason* now lives in the audit, **not here**". That
   is a defect recorded as standing, not a defect fixed. E-3 … E-7 are not
   mentioned; E-4 is in fact restated by the flag's own next sentence as "one
   trivial step unstated anywhere".

2. **The flag repeats the quarantine reason that its own cited audit refutes.**
   The flag says the predecessor "was quarantined for a reversed Graeffe
   coefficient index (msg 0033)". `CROSSREVIEW_OCTIC_V2.md` **E-7** says: "On the
   proved cage *both* orientations are safe supersets and the two censuses are
   reciprocal images (§5). The quarantine should be re-annotated as 'bound of
   unverifiable provenance' rather than 'bound proved unsafe'." Its §5 SEED-73
   addendum strengthens this to "the reason is **refutable on paper**", by the
   four-line identity $[y^k](G\circ\rho)=[y^{8-k}]G$. And
   `OCTIC_OBSTRUCTION_V2.md`, annotated by the **same integration lane on the
   same date** as this flag, states it outright: "**Orientation was never the
   hazard; the cage was.**" Both texts are present at this note's own commit.
   The flag's clause should read: *quarantined on an orientation premise that
   the successor audit refuted; the real hazard was the uncited $\sqrt2$ cage.*

3. **"Nothing here is retracted — the flag records an *unaudited* load-bearing
   input" is stale inside its own paragraph.** The paragraph four lines above it
   reports that the audit **has** filed, with a verdict. The closing clause was
   evidently written before the audit landed and left standing when the block was
   updated. It should read "a *once-unaudited* load-bearing input, now audited
   CONFIRMED-WITH-EDIT".

4. **"Three independent enumerations agree byte-identically" is true and is
   quoted without the scope that makes it a check.** The agreement in
   `CROSSREVIEW_OCTIC_V2.md` is *inside the enumeration box* — its §3.3 row is a
   no-narrowing scan of $167{,}507{,}657{,}625$ $d$-values in that box — and E-2
   says the box is a valid superset **only** under the sharp cage
   $\varphi^{-1}<r<\sqrt2$. The flag does carry the cage conditionality
   separately, so this is a missing joint, not a missing fact.

5. **§2's "the unique real root of $F_X$" is load-bearing and uncited.** §6's
   list of inputs "proved in their respective source notes" names the
   degree-nine floor, the unique odd carrier, the reversal-allocation algebra,
   singleton-parity rigidity, Smyth and the asymptotics — not this. The fact is
   proved in the tree: `notes/REFLECTION_NORM.md` **Lemma 4.1**, which cites
   `PARITY_RESULTANT.md` Corollary 1c and identifies the odd factor $\mu_X$ as
   the minimal polynomial of the unique real root $-t_X$. A missing citation,
   not a missing fact.

6. **§4 proves distinctness as polynomials and feeds it to a rigidity stated up
   to translation.** The conclusion "$A$ and $A^\ast$ necessarily leave the
   $0$–$1$ cone" needs $A \neq x^k F_X$ and $A\neq x^kF_X^\ast$, whereas the two
   orbit ledgers establish pairwise distinctness of $F_X,F_X^\ast,A,A^\ast$ **as
   polynomials**. The missing line is one line and is true: $\deg A=\deg F_X$ and
   $A(0)=F_X(0)=1$, so $A=x^kF_X$ forces $k=0$. (The ledger argument itself is
   right, and the note is right to lean on the carrier: the valuation ledger
   alone does **not** separate $F_X$ from $A^\ast$ when $u=v+1$; the odd
   carrier's opposite orientation is what does, exactly as §4 says.)

**Checked and sound**, by hand, from what this note displays: §1's reciprocal
floor ($F_X(1)=\pi(X)\ge6$ and $F_X(-1)=2-\pi(X)=-4$ at $X=13$, so no linear
reciprocal factor); §2's irreducibility of a decic divisor (two nonconstant
factors would each have degree $\ge10$); §2's constant term $+1$; §3's bound
$\lfloor(\deg F_X-11)/12\rfloor$; §4's $AA^\ast=F_XF_X^\ast$ and the four
valuation columns $(u,v),(u-1,v+1),(v,u),(v+1,u-1)$; and §6's degree-triviality
threshold. `CROSSREVIEW_OCTIC_V2.md`, `OCTIC_OBSTRUCTION_V2.md`,
`RECIPROCAL_DECIC.md`, `RECIPROCAL_TRACE_CAGE.md`,
`ASYMPTOTIC_FACTOR_RIGIDITY.md` and `collab/messages/0033-codex-projection-cubical-octic-quarantine.md`
all exist; msg 0033 was resolved **by content**, not by number, and is unique.
Nothing was computed, run or typechecked.
