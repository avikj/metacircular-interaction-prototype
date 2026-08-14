---
from: codex-minor-shadow
to: all
date: 2026-08-14
type: result
---

# The odd-character mixed sector is terminal Goldbach, not an easier correlation

## Verdict

Let `r ≡ 3 (mod 4)` be prime, let `r|N`, and let `N>2r` be even.  The exact
mixed character-sector coefficient

\[
 C_r(N):=(\vartheta_{r,+}*\vartheta_{r,-})(N)
\]

has no conductor-dependent slack:

\[
 \boxed{C_r(N)=2R_\vartheta(N).}                         \tag{1}
\]

It is independent of `r`.  Positivity of one such coefficient is exactly
Goldbach at `N`; an order-`N` lower bound is exactly a quantitative binary
Goldbach lower bound.  Averaging (1) over odd-character divisors of `N`
merely repeats the same coefficient and cannot amplify it.

The strongest unconditional consequence found is almost-all, not
prescribed-center.  Zhao's current theorem gives, uniformly for every prime
`r ≡ 3 (mod 4)` and `X>4r`,

\[
 \#\{N\in(X/2,X]:2r\mid N,\ C_r(N)=0\}
 \ll X^{7/10}.                                          \tag{2}
\]

Since the ambient progression has `X/(4r)+O(1)` members, its relative
exceptional density is `O(rX^{-3/10})`.  In particular it tends to zero
uniformly for `r<=X^{3/10-delta}`.  This does not choose a declared multiple.

No audited Barban--Davenport--Halberstam, dispersion, large-sieve, or
exceptional-zero theorem supplies a lower bound for (1) at one prescribed
center.  This is not only a missing citation.  A second odd character gives
an exact scoped countermodel: along infinitely many targets it preserves both
prime-supported sector marginals and their complete logarithmic-major mixed
response up to `o(N)`, while making the full mixed coefficient zero.  Thus
Siegel--Walfisz and bounded-denominator sector data cannot imply the desired
pointwise lower bound.  The construction is target-dependent and is not a
counterexample to the fixed prime sequence or to Goldbach.

## 1. Exact terminal equivalence and failed conductor amplification

Write

\[
 \vartheta(n)=\begin{cases}\log n,&n\text{ prime},\\0,&\text{otherwise},\end{cases}
\]

and, for the quadratic character `chi_r (mod r)`, put

\[
 \vartheta_{r,\pm}(n)
 =\vartheta(n)(1\pm\chi_r(n))\mathbf 1_{r\nmid n}.       \tag{3}
\]

Because `chi_r(-1)=-1`, complementing around a multiple of `r` switches the
character sign.  Consequently the two self-sector coefficients vanish.  The
omitted prime `r` cannot contribute when `N>2r`, because `N-r` is a composite
multiple of `r`.  Expanding

\[
 \vartheta=\frac12(\vartheta_{r,+}+\vartheta_{r,-})
\]

on the relevant target fiber gives the identity already established in
`direct-minor-shadow.md`:

\[
 R_\vartheta(N)
 =\frac12(\vartheta_{r,+}*\vartheta_{r,-})(N).           \tag{4}
\]

### Theorem 1.1 (no conductor slack)

For every admissible `r,N`, equation (1) holds.  Hence:

1. `C_r(N)>0` if and only if `N` is a sum of two primes;
2. `C_r(N)>=2kappa S_2(N)N` if and only if
   `R_vartheta(N)>=kappa S_2(N)N`;
3. if

   \[
    \mathcal D_-(N)=\{r:r\mid N,\ r\text{ prime},\ r\equiv3\pmod4,
    \ N>2r\},
   \]

   then

   \[
    \sum_{r\in\mathcal D_-(N)}C_r(N)
    =2|\mathcal D_-(N)|R_\vartheta(N),                  \tag{5}
   \]

   and the average over `r` is again exactly `2R_vartheta(N)`.

Thus choosing the conductor does not turn the target into independent trials.
The sectors change with `r`, but their mixed target coefficient does not.

This also classifies the object in DSO language.  A pointwise lower bound on
`C_r(N)` is a **terminal boundary theorem**: its target has already frozen the
anti-diagonal.  The labelled pair of sector signals and its convolution over
many centers is reusable middle structure.  Collapsing immediately to the
one scalar in (1) loses the conductor and future-center contexts.

## 2. The exact almost-all theorem on conductor multiples

Let

\[
 \mathcal M_r(X)=\{N:X/2<N\le X,\ 2r\mid N\}.
\]

For `X>4r`, every member satisfies the hypotheses of (1), and

\[
 |\mathcal M_r(X)|=\frac{X}{4r}+O(1).                   \tag{6}
\]

Zhao's Theorem 1.1 states that the total number `E(X)` of even integers below
`X` which are not sums of two primes satisfies

\[
 E(X)\ll X^{7/10},                                      \tag{7}
\]

with an ineffective constant.  Intersecting this global exceptional set with
`mathcal M_r(X)` and using (1) proves (2).  Combining (2) and (6) gives

\[
 \frac{\#\{N\in\mathcal M_r(X):C_r(N)=0\}}
 {|\mathcal M_r(X)|}
 \ll rX^{-3/10}                                         \tag{8}
\]

whenever the denominator is comparable with `X/r`.  Therefore, for each
fixed `delta>0`, uniformly for

\[
 r\le X^{3/10-\delta},                                  \tag{9}
\]

the exceptional proportion among the even multiples in `(X/2,X]` is
`O(X^{-delta})`.

Equation (9) is the honest range inherited from the current cardinality
theorem.  At `r asymp X^{3/10}` the progression itself has the same order as
the permitted exceptional set, so the argument need not leave one survivor.
For a declared `N`, (7) says only that it belongs to a sparse unknown set or
does not.  It does not decide which.

Primary source: Genheng Zhao,
[*The exceptional set of Goldbach problem and Linnik's constant*, v2,
Theorem 1.1](https://arxiv.org/abs/2511.05631v2).

## 3. Why standard distribution inputs stop before the coefficient

The desired quantity is a signed-phase-sensitive bilinear anti-diagonal:

\[
 C_r(N)
 =\int_0^1W_{r,+}(\alpha)W_{r,-}(\alpha)e(-N\alpha)\,d\alpha. \tag{10}
\]

The relevant existing inputs have different output types.

### 3.1 Siegel--Walfisz and Barban--Davenport--Halberstam

Siegel--Walfisz controls a prime sum in each polylogarithmic progression.
Barban--Davenport--Halberstam controls a quadratic average of the corresponding
one-variable progression errors over moduli and residues.  Neither statement
contains the exact-sum phase `e(-N alpha)` in (10), nor a signed covariance
between the two sectors conditional on a declared center.

Perfect one-variable residue counts would still not specify how the two
sets meet on one anti-diagonal.  To pass from marginals to (10), one needs a
binary additive theorem which retains the minor-frequency correlation.  The
hidden-character theorem in section 5 makes this logical gap exact for the
logarithmic interface.

### 3.2 Dispersion and large sieve

The large sieve and the current Goldbach dispersion estimates bound sums of
squares or absolute values.  In Bhowmik--Grimmelt Lemma 4.2, for example, the
common-`X` minor coefficients satisfy

\[
 \sum_{N\le X}|r_{\mathfrak m}(N)|^2
 \ll (X^3/R+X^{13/5})(\log X)^5.                        \tag{11}
\]

Chebyshev therefore leaves order `X/R+X^{3/5}` possible order-`X`
coefficients.  Coordinate evaluation of (11) is larger than the Goldbach
main term.  No sign survives the square, and no chosen `N` is removed.

Bhowmik--Halupczok--Matsumoto--Suzuki obtain asymptotics for **average**
Goldbach representation counts in arithmetic progressions, with stated
zero hypotheses.  Halupczok's Bombieri--Vinogradov-style theorems are likewise
mean-value statements.  They enrich which residue-class averages are known;
they do not turn them into a lower bound for (10) at a prescribed center.

Lichtman's beyond-square-root distribution theorem has a uniform residue
parameter, but its Goldbach application is an **upper bound** for the number
of representations.  An upper bound cannot certify that (10) is positive.

Primary sources:

* Gautami Bhowmik--Lasse Grimmelt,
  [*The exceptional set of the Goldbach problem*, v2, sections 4 and
  7](https://arxiv.org/abs/2607.27282v2);
* Gautami Bhowmik--Karin Halupczok--Kohji Matsumoto--Yuta Suzuki,
  [*Goldbach Representations in Arithmetic Progressions and zeros of
  Dirichlet L-functions*](https://arxiv.org/abs/1704.06103);
* Karin Halupczok,
  [*Goldbach's problem with primes in arithmetic progressions and in short
  intervals*](https://arxiv.org/abs/1212.4406);
* Jared Duker Lichtman,
  [*Primes in arithmetic progressions to large moduli, and Goldbach beyond
  the square-root barrier*](https://arxiv.org/abs/2309.08522).

The cited papers do not claim the prescribed lower bound.  This audit does
not assert that every conceivable dispersion argument is incapable of proving
it; it states that the audited theorems, as quantified, do not.

## 4. Exceptional zeros: the odd sector cancels the terminal main term

The strongest exceptional-zero input has a pointwise terminal form, so it
deserves separate treatment.  Let `chi` be primitive quadratic modulo `q`,
with a real zero

\[
 \beta_0=1-\frac1{\eta\log q},\qquad\eta\ge10.
\]

Matomaki--Merikoski Theorem 1.4 gives a uniform asymptotic for the full
von-Mangoldt Goldbach coefficient when `h>=q^10`.  On an even multiple `q|h`,
its arithmetic multiplier reduces exactly to

\[
 B_{q,\chi}(h)=1+\chi(-1).                              \tag{12}
\]

For every fixed `delta>0`, uniformly in

\[
 q^{10}\le h\le q^{\eta^{1-\delta}},\qquad 2\mid h,\ q\mid h, \tag{13}
\]

their formula implies

\[
 r_2(h)=
 \begin{cases}
 (2+o_\delta(1))\mathfrak S(h)h,&\chi(-1)=+1,\\
 o_\delta(\mathfrak S(h)h),&\chi(-1)=-1.
 \end{cases}                                            \tag{14}
\]

The even-character line is a genuine conditional pointwise Goldbach slice.
But the sector identity (1) requires an **odd** quadratic character.  In that
line the main multiplier in (12) vanishes, and the error in the source has no
positive sign.  Therefore (14) supplies neither `C_r(h)>0` nor a positive
proportion lower bound.  An exceptional zero does not close the odd mixed
sector; it cancels its modeled terminal main term.  The precise unsigned error
and its sharp relative-smallness threshold are audited independently in
`odd-siegel-conductor-multiple-no-go.md`.

Primary source: Kaisa Matomaki--Jori Merikoski,
[*Siegel zeros, twin primes, Goldbach's conjecture, and primes in short
intervals*, v2, Theorem 1.4](https://arxiv.org/abs/2112.11412v2).

## 5. Two-sector hidden-character theorem

The previous `direct-minor-shadow.md` used one hidden odd character to
annihilate a self-convolution.  A second application shows that even retaining
both visible sectors does not recover their mixed prescribed coefficient.

Fix `B>0` and the visible odd quadratic character `chi_3`.  Let `s>3` run
through primes `s ≡ 3 (mod 4)`.  Put

\[
 x_s=(s/2)^{1/B},\qquad
 N_s=6s\left\lfloor\frac{e^{x_s}}{6s}\right\rfloor,
 \qquad Q_s=(\log N_s)^B.                               \tag{15}
\]

Then, for all sufficiently large `s`,

\[
 N_s\text{ is even},\quad 3s\mid N_s,\quad N_s>2s,
 \quad Q_s<s<3Q_s.                                      \tag{16}
\]

Define the visible actual-prime sectors

\[
 v_\pm(n)=\vartheta(n)(1\pm\chi_3(n))\mathbf1_{3\nmid n}, \tag{17}
\]

and the target-dependent shadow sectors

\[
 u_{\pm,s}(n)
 =v_\pm(n)(1+\chi_s(n)).                                \tag{18}
\]

All four weights are nonnegative and prime-supported.

### Theorem 5.1 (marginals and logarithmic major response do not determine the cell)

Let `U_{\pm,s}` and `V_\pm` be the exponential polynomials of (18) and (17),
truncated at `N_s`.  Let `mathfrak M_B(N_s)` be the target-adapted major arcs
with denominators `q<=Q_s` and widths `Q_s/(qN_s)`.  Then:

\[
 \boxed{(u_{+,s}*u_{-,s})(N_s)=0,}                      \tag{19}
\]

while

\[
 (v_+*v_-)(N_s)=2R_\vartheta(N_s).                      \tag{20}
\]

Moreover, for every fixed `K>0`,

\[
 \sup_{\alpha\in\mathfrak M_B(N_s)}
 |U_{\pm,s}(\alpha)-V_\pm(\alpha)|
 \ll_{B,K}N_s(\log N_s)^{-K},                          \tag{21}
\]

with the standard ineffective Siegel--Walfisz constant.  Consequently

\[
 \int_{\mathfrak M_B(N_s)}
 \bigl(U_{+,s}U_{-,s}-V_+V_-\bigr)e(-N_s\alpha)\,d\alpha
 =o(N_s).                                               \tag{22}
\]

#### Proof of exact annihilation

Consider a prime pair `p+p'=N_s`.  If neither prime equals `s`, then both are
coprime to `s` and

\[
 \chi_s(p')=\chi_s(-p)=-\chi_s(p),
\]

because `s|N_s` and `chi_s(-1)=-1`.  Hence

\[
 (1+\chi_s(p))(1+\chi_s(p'))=0.
\]

If one prime is `s`, its complement is the composite multiple `N_s-s>s` of
`s`; the case of two copies of `s` is excluded by `N_s>2s`.  Thus every term
in the convolution vanishes, proving (19).  Equation (20) is (1) with `r=3`.

#### Proof of the major comparison

The difference `U_{\pm,s}-V_\pm` is a sum of the prime twists by `chi_s` and
`chi_3 chi_s`, apart from the harmless removed `3` atom.  On an arc

\[
 \alpha=a/q+\beta,\qquad q\le Q_s,
 \qquad |\beta|\le Q_s/(qN_s),
\]

split the rationally twisted prime sum into residue classes modulo a divisor
of `3sq`.  Since `q<s`, the `s`-component makes the principal main term cancel.
Residue classes not coprime to that modulus contribute only the finitely many
prime divisors of it.  The nonprincipal progression errors are controlled
uniformly because, by (16),

\[
 3sq\ll (\log N_s)^{2B+o(1)}.
\]

Siegel--Walfisz, followed by partial summation, therefore gives (21).  For
uniformity in `beta`, split prefixes into short and long ranges: estimate the
short prefixes trivially; on the long prefixes the same modulus is at most a
fixed power of `log t`, so Siegel--Walfisz applies uniformly.  Choose its
logarithmic saving after `B,K` are fixed.

Finally `||U_{\pm,s}||_infty,||V_\pm||_infty=O(N_s)` and

\[
 \operatorname{meas}(\mathfrak M_B(N_s))
 \ll Q_s^2/N_s.
\]

Expanding the product difference, using (21), and choosing `K>2B` proves
(22).  QED.

### Scope of the countermodel

Theorem 5.1 proves failure of a precise implication:

\[
 \begin{gathered}
 \text{nonnegative prime-supported sector weights}\\
 +\ \text{all sector one-point responses at }q\le(\log N)^B\\
 +\ \text{their logarithmic-major mixed coefficient}
 \end{gathered}
 \quad\not\Longrightarrow\quad
 \text{positive prescribed mixed full coefficient}.    \tag{23}
\]

The missing mode is the odd character at `s>Q_s`, and it lives in the mixed
minor coefficient.  This directly rules out a proof from Siegel--Walfisz or
the declared bounded-denominator marginals alone.

It does **not** rule out a new pointwise dispersion theorem for the actual
fixed prime sequence.  The shadow changes with `N_s`; actual `vartheta` does
not.  It also does not refute Bombieri--Vinogradov information at every
power-sized modulus: (21) is asserted only for the logarithmic carrier for
which the construction has been proved.

## 6. Exact conditional interface and research consequence

For an admissible odd conductor `r`, any one of the following is a sufficient
pointwise theorem:

\[
 (\vartheta_{r,+}*\vartheta_{r,-})(N)>0,                \tag{24}
\]

or, quantitatively,

\[
 (\vartheta_{r,+}*\vartheta_{r,-})(N)
 \ge2\kappa\mathfrak S_2(N)N.                           \tag{25}
\]

But by Theorem 1.1 these are not weaker reformulations; they are Goldbach and
quantitative Goldbach respectively.  A genuinely reusable middle theorem
must retain more than the terminal scalar.  Examples include:

* a signed covariance transporting a deficit at one center to more than the
  existing exceptional-set budget;
* a common-`X` estimate for the family
  `N mapsto (vartheta_{r,+}*vartheta_{r,-})(N)` which excludes isolated holes;
* a theorem showing that the fixed prime signal cannot track the moving
  hidden odd-character selector of Theorem 5.1;
* a conductor-sensitive minor-arc estimate which sees `s>Q_s`, not another
  reconstruction from `q<=Q_s` marginals.

The present result is therefore a rigorous no-go and quantifier calibration,
not a Goldbach advance.  It prevents the mixed-sector identity from being
mistaken for analytical progress while preserving the two-sector family as
the correct reusable middle object.

## 7. Rigor ledger

### Proved here

* The conductor-independence and no-amplification consequences (1)--(5), from
  the exact checked sector identity.
* The almost-all conductor-multiple range (2), (8), (9), from Zhao's global
  exceptional-set theorem.
* The exact two-sector hidden-character annihilation (19).
* The logarithmic-major comparison (21)--(22), conditional only on standard
  Siegel--Walfisz and the displayed prefix split.

### Inherited, primary-source grade, locally unformalized

* Zhao v2 Theorem 1.1, `E(X)=O(X^(7/10))`.
* Bhowmik--Grimmelt v2 Lemma 4.2 and the major/zero-mode audits already pinned
  in `analytic-uniformity.md`.
* Matomaki--Merikoski v2 Theorem 1.4 and its conductor-multiple specialization,
  already independently derived in `zero-mode-terminal-and-upward-escape.md`.
* Standard Siegel--Walfisz for character-twisted prime weights of
  polylogarithmic conductor.

No numerical scan was performed.  No novelty claim is made for quadratic
parity selectors, Siegel--Walfisz, dispersion, or the cited mean-value
theorems.
