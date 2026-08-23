# The adelic block decomposition: two independent developments

*Part I is also titled, on the branch that wrote it: "Closure of the adelic
block decomposition, and the phase law of the sum-spectrum measure."*

**Merge note.** Two branches wrote a `notes/BLOCKS.md` independently against
the same target (`ADELIC.md` §3). They are different documents, not two
drafts of one: Part I (exp11/exp12/exp13/exp23/exp27/exp28) develops the
block *spectral support theorem*, the exact weight law D‴, the D″ constants,
and the $Q$-running of the block constants; Part II (exp13_blocks) develops
the block *variation calculus* and proves the mixed block carries the
first-variation coefficient exactly $2$. Both are kept verbatim below.
Where they overlap they agree on structure and differ in emphasis; the one
substantive numerical difference — Part II's measured mixed-block amplitude
ratio $2.08$ vs Part I's $1.0000$ against the *already-doubled* model
$-2\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$ — is a convention difference
in whether the factor $2$ sits in the model or in the ratio, not a
disagreement. Part II's Lemma is the proof of what Part I §1 asserts.

Standing caveat under `CLAUDE.md`: every "corr 0.9997"-style line below is
*illustration, not evidence*. The load-bearing content of Part I is
Theorem D‴ (Stirling — a proof) and Theorem E2 (explicit formula — a proof);
of Part II, the coefficient-2 Lemma (partial summation — a proof).

---

# Part I — Closure of the adelic block decomposition, and the phase law of the sum-spectrum measure

Companion to `REPORT.md`, `ADELIC.md`, `APPENDIX_D.md`. This document executes the
two items flagged as "next" in `ADELIC.md` §3 and `APPENDIX_D.md` §D.6.3: the
numerical closure of the two-body adelic block decomposition (exp11_blocks), and the
Krein positivity test of the sum-spectrum measure (exp12_krein). The first *confirms*
the decomposition and *corrects* one attribution in `ADELIC.md` §3. The second
*refutes* the naive positivity guess of Problem 3 — and replaces it with an exact
asymptotic law for the pair weights (modulus **and** phase) that any correct
screw-function dictionary must now match.

---

## 0. The first measurement (`exp13_blocks`): Theorem E made empirical, and the coefficient-2 lemma

*Editorial note (integration, 2026-08-11): the two research branches verified
the block decomposition independently and consistently. This §0 is the
certificate-frontier branch's document (`exp13_blocks.py`): it proved the
**coefficient-2 Lemma** (the mixed block carries the single-zero layer with
coefficient exactly 2) and measured 2.08→2 at Q=30. §1 below (Theorem E2,
`exp11_blocks.py`) is the catchup branch's sharpened attribution — mixed =
single-zero layer, corr/ratio 1.0000/1.0000 — with the coefficient folded into
the model. The Lemma keeps its name (`LENS_REGULARITY.md` depends on it); see
§1 for the sharpened form. exp numbers in this §0 refer to the cf series; see
`notes/EXP_LEDGER.md`.*


Companion to `ADELIC.md` §3 (which constructed the decomposition) and the
affine-field update §K (first/second variation). Code: `code/exp13_blocks.py`
plus the spectral-separation check reproduced below. Primes to $2\cdot10^6$,
zeros from the Odlyzko table.

### Setup

$\Lambda = \Lambda^\sharp_Q + \Lambda^\flat_Q$ with
$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)$ (the conditional
expectation onto the BC diagonal at profinite resolution $Q$). The smoothed
Goldbach count splits exactly:
$$G_1 = [\sharp\sharp] + 2[\sharp\flat] + [\flat\flat],$$
verified to machine precision ($3\times10^{-13}$ relative) — as it must, but the
content is the size, shape, and *spectral identity* of each block.

### Measurements

**BC block $[\sharp\sharp]$ = the local model, exactly.** Against the prediction
$\sum_{n\le X}(X-n)\,n\,\mathfrak S_Q(n)$ with $\mathfrak S_Q$ the level-$Q$
truncated singular series: ratio $=1.00000\pm3\times10^{-5}$ at every tested
$Q\in\{1,10,30,100\}$. The critical-BC correlator calculus and the
Ramanujan-coefficient calculus agree on the nose.

**Zero block $[\flat\flat]$ = the second variation, and nothing else.** Its rms
at scale $X^2$ is $0.0024$, *independent of $Q$* — numerically identical to the
Parseval-predicted pair-sum amplitude $0.0025$ of `APPENDIX_D.md` §D.5. Spectral
content in $\log X$: pair-band $[27,45]$ (containing $2\gamma_1, \gamma_1+\gamma_2,
2\gamma_2$) carries $360\times$ the power of the single-zero band $[12,23]$
(single/pair ratio $0.003$).

**Mixed block $2[\sharp\flat]$ = the first variation.** Spectral content:
single-$\gamma$ band carries $34\times$ the pair band; band-passed, it correlates
$+0.976$ with the single-zero sum $-\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$
at amplitude ratio $2.08$ — i.e. the mixed block carries the first-variation
coefficient $2$ predicted by expanding $(dx+dE)*(dx+dE)$, with the $8\%$
excess consistent with finite-$Q$ leakage. At scale $X^2$ the mixed block also
contains deterministic secondary terms (its $O(X^2)$ smooth layer, non-monotone
in $Q$ through Möbius sign cancellations); these are frequency-$0$ in $\log X$
and detrend away.

### Lemma (the mixed block carries the first variation with coefficient exactly 2)

The measured $2.08\approx2$ is a theorem. Write
$2[\sharp\flat]=2\sum_m\Lambda^\sharp_Q(m)\,\Psi_1^\flat(X-m)$ with
$\Psi_1^\flat(y)=\sum_n\Lambda^\flat_Q(n)(y-n)_+$. Since
$\Psi_1^\sharp(y)=\sum_{q\le Q}\tfrac{\mu(q)}{\varphi(q)}\sum_{n\le y}c_q(n)(y-n)$
contains no zeta zeros (periodic summands; the $q=1$ term is $y^2/2$, and for
$q\ge2$ partial summation against the mean-zero $c_q$ gives $O(qy)$), the whole
zero content of $\Psi_1$ sits in $\Psi_1^\flat$:
$$\Psi_1^\flat(y)=-\sum_\rho\frac{y^{\rho+1}}{\rho(\rho+1)}+(\text{smooth},\ O(Qy)).$$
Pairing against $\Lambda^\sharp_Q$: the $q=1$ (density) part of $\Lambda^\sharp$
integrates $\int_0^X(X-u)^{\rho+1}du=X^{\rho+2}/(\rho+2)$, while each $q\ge2$
part contributes $\sum_m c_q(m)(X-m)^{\rho+1}=O(qX^{\rho+1})$ by partial
summation. Hence
$$2[\sharp\flat] \;=\; -2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}
\;+\;O\!\bigl(Q\,X^{3/2}\bigr)\;+\;(\text{smooth in }X),$$
i.e. the mixed block carries the full single-zero layer with coefficient
exactly $2$, plus a finite-$Q$ leakage of **relative** size $O(Q/X)$.

> **Correction (SEED-77, 2026-08-14; full argument in
> `notes/SEED77_BLOCKS_POSTCONDITION.md` §2–§3).** This display previously read
> $O_Q(X^{3/2})$, with the relative size quoted as
> "$X^{3/2}/X^{5/2}=X^{-1}$" and the sentence "accounting for the measured
> $2.08$ at $Q=30$ and predicting the coefficient $\to2$ as $Q\to\infty$". The
> $Q$-dependence was dropped from a ratio — the `HOLOGRAM.md` §7 failure — and
> the proof one paragraph above supplies it: each $q\ge2$ term is
> $O(qX^{\rho+1})$ weighted by $|\mu(q)|/\varphi(q)$, so the total is
> $\ll X^{3/2}\sum_{q\le Q}\mu^2(q)\,q/\varphi(q)\asymp QX^{3/2}$, relative
> $\asymp Q/X$. Consequences:
> - *Good:* the coefficient is exactly $2$ throughout the joint range
>   $Q=o(X)$, so no interchange of $Q\to\infty$ with $X\to\infty$ is required
>   and the "$\to2$ as $Q\to\infty$" reading is earned on that range.
> - *Bad:* at $Q=30$ and $X$ between $10^{4}$ and $2\cdot10^{6}$ the leakage is
>   at most $3\times10^{-3}$ and typically $\sim10^{-5}$. **The claim that the
>   $8\%$ excess in the measured $2.08$ is "consistent with finite-$Q$ leakage"
>   is excluded by this note's own proof, by one to four orders of magnitude.**
>   The excess belongs to the estimator (zero-sum truncation, band-pass window,
>   detrending), not to the decomposition; Part I's independent $1.0000$
>   against the same model, with the $2$ folded in, is consistent with that.
>   The Lemma itself is untouched — it was always the theorem, and $2.08$ was
>   never evidence for it. Simultaneously this proves the zero block $[\flat\flat]$ contains
*no* single-zero layer at leading order: its single-band content is the square
of fluctuations, of relative order $X^{-1/2}$ — matching the measured
single/pair power ratio $0.003$.

### What this establishes

The canonical decomposition of `ADELIC.md` §3 is not just formally exact — its
blocks have *disjoint spectral supports* matching the variation calculus:

| block | identity | $\log X$ frequencies | measured |
|---|---|---|---|
| $[\sharp\sharp]$ | mean / local (BC) | $0$ | $=\mathfrak S_Q$-model, ratio 1.00000 |
| $2[\sharp\flat]$ | first variation | single $\gamma_i$ | corr 0.976, coeff 2.08 ≈ 2 |
| $[\flat\flat]$ | second variation | pair sums $\gamma_i+\gamma_j$ | rms 0.0024 = Parseval 0.0025 |

Consequences for the program:

1. The Matsumoto–Suzuki screw kernel (RH-equivalence) must live in the *mixed
   block* — first variation, single zeros — pinning the target of the
   screw-kernel join precisely.
2. "RH enters Goldbach at first order, pair correlation at second order"
   (update §K) is now a measured statement about two orthogonal frequency bands
   of one arithmetic signal.
3. The parity/charged sector (Theorem F, `GAUGE.md`) is invisible in *all
   three* blocks — it has no atoms, hence no lines in any band; its only
   possible residence is the broadband floor, which at our scales is at the
   $10^{-3}$ level of the pair lines. A quantitative version of "how flat is
   the floor" is exactly the Chowla-flatness of `PARITY.md`.

---

## 1. Theorem E2: the block spectral-support theorem (exp11_blocks)

Recall the canonical BC conditional expectation at profinite resolution $Q$
(`ADELIC.md` §3): $\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q$,
$\Lambda^\flat=\Lambda-\Lambda^\sharp_Q$, and the induced block decomposition of the
smoothed Goldbach count $G_1(X)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)(X-m-n)_+$:
$$G_1=[\sharp\sharp]+\bigl([\sharp\flat]+[\flat\sharp]\bigr)+[\flat\flat].$$

Since the Laplace transforms split as $P^\sharp(z)\sim\frac1z+(\text{rational
atoms})$ and $P^\flat(z)\sim-\sum_\rho\Gamma(\rho)z^{-\rho}+O(1)$, the explicit
formula predicts a *sharper* statement than `ADELIC.md` §3 recorded:

**Theorem E2 (block spectral support; RH for the frequency statement).** In log-$X$
frequency space, at scale $X^2$:

| block | analytic origin | content | scale | frequencies |
|---|---|---|---|---|
| $[\sharp\sharp]$ | pole × pole (+ atoms) | $X^3/6$ + smooth | $X^3$ | none |
| $[\sharp\flat]+[\flat\sharp]$ | **pole × zero** | $-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}$ | $X^{5/2}$ | $\{\gamma_i\}$ |
| $[\flat\flat]$ | **zero × zero** | $\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}$ | $X^2$ | $\{\gamma_i+\gamma_j\}$ |

**Correction to `ADELIC.md` §3.** The zero-block bullet there attributed "the
single- and double-zero sums of Theorem D" to $[\flat\flat]$. That is wrong for the
single-zero layer: the single-zero sums arise from the *pole × zero cross term*,
hence live in the **mixed** block. The mixed blocks vanish in Besicovitch mean
(orthogonality — verified below) but are *not* small pointwise: they carry the
entire $X^{5/2}$ layer, which dominates the $X^2$ pair layer. $[\flat\flat]$ is
purely the pair layer plus $O(X^{3/2})$ cross-constant terms.

**Verification (exp11_blocks; $\Lambda$ to $2\cdot10^6$, $Q=30$, 30,000 zeros in the
single-zero model, 1200 in the pair model).**

- **Closure (sanity check only, per `CROSSREVIEW_BLOCKS.md`):**
  $\max_X|[\sharp\sharp]+[\text{mix}]+[\flat\flat]-G_1|/G_1=2.1\times10^{-13}$ —
  tautological by bilinearity ($\Lambda\Lambda=(\Lambda^\sharp+\Lambda^\flat)^2$); it
  verifies FFT arithmetic. The substantive evidence for E2 is the
  parameter-free band attribution below.
- **Band power split** (RMS at $X^2$ scale, single band $[10,27.5]$ / pair band
  $[28.5,320]$ in log-$X$ frequency):

  | block | single band | pair band |
  |---|---|---|
  | $[\sharp\sharp]$ | 0.000001 | 0.000002 |
  | $[\text{mix}]$ | 0.6218 | 0.0915 |
  | $[\flat\flat]$ | 0.000233 | 0.002234 |

  The BC block is spectrally **dead** — six orders below the zero layers, in both
  bands. Zero content is carried entirely by the $\flat$-blocks.
- **Mixed block = single-zero layer:** correlation **1.0000**, amplitude ratio
  **1.0000** against $-2\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$ in the single
  band. Its pair-band power (0.0915) is *also* the single-zero model — the
  ordinates $\gamma_4,\gamma_5,\dots$ lie above $28.5$ (attribution check in exp11
  output); against the pair model it correlates at only $0.07$.
- **Zero block = pair layer:** correlation **0.9997**, amplitude ratio **0.9995**
  against the $\gamma_i+\gamma_j$ model of exp6b; single-$\gamma$ line amplitudes in
  $[\flat\flat]$ are $\sim4000\times$ smaller than in the mixed block
  (e.g. at $\gamma_1$: 0.32 vs 1313.7).
- **Hardy projection / conditional-expectation structure:**
  $\frac1X\sum_{n\le X}\Lambda(n)c_q(n)=\mu(q)$ to 4 decimals for all tested
  $q\le30$ (including the vanishing cases $q=4,12$).
- **Besicovitch orthogonality:** $\frac1X\sum_n\Lambda^\sharp_Q\Lambda^\flat_Q
  \approx10^{-4}$, flat in $Q$. [Corrected framing per audit: by Carmichael
  orthogonality of Ramanujan sums the mean is exactly $0$ at every $Q$ in the
  limit; the measured $10^{-4}$ is finite-$X$ noise, not a $\sum_{q>Q}\mu^2/\varphi^2$
  tail effect — the earlier "tail prediction" column was mislabeled.]

Figure: `figures/exp11_blocks.png` — the three block spectra, each showing only
its own line system.

**What this buys.** The decomposition of `ADELIC.md` §3 is now *numerically
closed*: every layer of Theorem D sits in exactly one named block, with the
block boundaries at machine precision. The corrected attribution matters
structurally: "pole × zero" is the first-variation sector (`PARITY.md` §1K),
so the Matsumoto–Suzuki screw kernel — conjectured there to be the first
variation — should be sought in the **mixed** block, not the zero block.

---

## 2. Theorem D‴: the exact weight law — modulus *and phase* (exp12_krein)

`APPENDIX_D.md` §D.6.3 proposed testing "positivity of the measure
$\sum_{i,j}W_{ij}\delta_{\gamma_i+\gamma_j}$" as the numerical face of the
Matsumoto–Suzuki join. The test was run; the answer is definitive, and more
interesting than a yes/no: the measure obeys an exact **chirp law**.

**Theorem D‴ (weight law, full form).** For same-sign ordinates, with
$s=\gamma+\gamma'$, $p=\gamma/s$, and $H(p)=-p\log p-(1-p)\log(1-p)$ the (natural-log)
binary entropy,
$$W(\gamma,\gamma')=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}
=\sqrt{2\pi}\;s^{-5/2}\;e^{-i\left(sH(p)+\frac{5\pi}{4}\right)}
\Bigl(1+O\bigl(\tfrac1{\min(\gamma,\gamma')}\bigr)\Bigr).$$

*Proof.* Stirling. $\arg\Gamma(\tfrac12+i\gamma)=\gamma\log\gamma-\gamma+O(1/\gamma)$
(note $\rho-\tfrac12=i\gamma$ exactly, so no $\pi/4$-type constant survives);
$\arg\Gamma(3+is)=s\log s-s+\tfrac{5\pi}{4}+O(1/s)$; and
$\gamma\log\gamma+\gamma'\log\gamma'-s\log s=-sH(p)$. For the modulus,
$|\Gamma(\tfrac12+i\gamma)|=\sqrt{2\pi}\,e^{-\pi\gamma/2}(1+O(1/\gamma))$ and
$|\Gamma(3+is)|=\sqrt{2\pi}\,s^{5/2}e^{-\pi s/2}(1+O(1/s))$: the exponentials cancel
*exactly* for same-sign pairs, leaving $\sqrt{2\pi}\,s^{-5/2}$. $\square$

Two structural facts, both new relative to Theorem D′:

1. **The modulus depends only on the sum $s$** — constant $\sqrt{2\pi}$, no
   dependence on the splitting $p$ at leading order. (D′ had only
   $|W|\asymp s^{-5/2}$.)
2. **The phase is the entropy of the splitting.** Interpretation: since
   $e^{-isH(p)}X^{is}=(pX)^{i\gamma}\bigl((1-p)X\bigr)^{i\gamma'}$, the atom's phase
   is the two zero waves evaluated at the *stationary point of the constraint
   simplex*: the Beta-weight integral $\iint u^{\rho-1}v^{\rho'-1}(X-u-v)\,du\,dv$
   localizes at $m^*=pX$, $n^*=(1-p)X$ — each zero claims a share of $X$
   proportional to its frequency. The pair term of Theorem D is thus, per atom,
   $$2\sqrt{2\pi}\,s^{-5/2}\cos\!\bigl(s\log X - sH(p)-\tfrac{5\pi}{4}\bigr)\cdot X^2 ,$$
   a line at frequency $s$ with an entropy phase delay.

**Verification (exp12_krein; first 600 zeros, all $600^2$ same-sign pairs).**

- modulus ratio $|W|/\bigl(\sqrt{2\pi}s^{-5/2}\bigr)$: mean $0.999995$, max
  deviation $0.31\%$;
- phase deviation from $-sH(p)-5\pi/4$: rms $0.0045$ rad; max-deviation envelope
  decays as predicted: $0.077,\,0.031,\,0.016,\,0.0054$ for
  $\min(\gamma,\gamma')>20,50,100,300$ — i.e. $\approx1.6/\min(\gamma,\gamma')$.
  [Audit note: the *bulk* regression of $|$dev$|$ vs $\min$ gives exponent
  $-0.41$, not $-1$ — the typical deviation mixes $1/\min$ and $1/s$ terms;
  the envelope is the correct statistic for the $O(1/\min)$ *upper bound*
  claimed by D‴, and it passes. Both numbers are in exp12_krein's output.]

Figure: `figures/exp12_phaselaw.png` (diagonal chirp $-f\log2-\tfrac{5\pi}{4}$;
error scaling; atom-phase histogram).

### 2.1 The Krein test: the amplitude measure is *maximally non-positive*

Consequences of the phase law, all verified (exp12_krein):

- **Atom phases equidistribute** on the circle: over the 180,300 atoms from 600
  zeros, the fraction with $\operatorname{Re}c_f>0$ is $0.499$; Weyl sums
  $|\text{mean}\,e^{ik\arg c_f}|=0.0007,\,0.0002$ ($k=1,2$) — at or below the
  random-walk scale $0.0024$. (This is forced: $sH(p)$ mod $2\pi$ equidistributes
  as $s$ grows.)
- **$A(u)=\sum W e^{i(\gamma+\gamma')u}$ is real but *not even*:**
  $\|A(u)-A(-u)\|_2/\|A\|_2=1.53$ on the band-complete atom set $f\le300$. A
  positive spectral measure forces $A$ even; this alone refutes positivity.
- **Gram/Bochner test:** the symmetrized kernel $A(u_a-u_b)$ (500 points,
  $\Delta u=0.01$) has $\lambda_{\min}/\lambda_{\max}=-1.39$ and negative spectral
  mass fraction $0.549$ — indistinguishable from the fully-chirped value $1/2$.

**Verdict on Problem 3 (`REPORT.md` §8).** The measure
$\sum_{i,j}W_{ij}\delta_{\gamma_i+\gamma_j}$ is **not** positive, and not close: it
is a chirped complex measure whose phases equidistribute. The naive form of the
screw-function join — "Matsumoto–Suzuki positivity $\equiv$ positivity of this
measure" — is dead. The corrected target, consistent with everything verified
here:

> positivity can only enter at the **Hermitian-square level**, where the chirp
> cancels: $|W|^2=2\pi s^{-5}$ (phase-free — and now *exactly* so, but not with
this right-hand side: by `notes/SEED13_D3PRIME_EXACT.md` Lemma 1 the exact
identity is $|W|^2=2\pi\sinh(\pi s)\bigl[s(1+s^2)(4+s^2)(\cosh\pi s+\cosh\pi
\delta)\bigr]^{-1}=2\pi s^{-5}\bigl(1-5s^{-2}+O(s^{-4})\bigr)$ for same-sign
pairs. D‴ as stated in this section gives only $2\pi s^{-5}(1+O(1/\min))$; the
word "exactly" was carrying Lemma 1's weight before Lemma 1 existed — SEED-77).
The variance object
> of Theorem D″ — the weighted additive energy with diagonal
> $\sum|W_{12}|^2$ — is the natural positive quantity, and the M–S screw
> function (a Krein object, i.e. a *conditionally* negative-definite structure)
> should pair with the first-variation (mixed-block) sector identified in §1,
> whose weights $1/|\rho(\rho+1)(\rho+2)|$ are also phase-chirped individually
> but Hermitian-squared in any variance statement.

Note the pleasing echo of the holomorphic/Hermitian dichotomy (`REPORT.md` §6)
one level up: the *amplitude* (holomorphic) layer of the sum spectrum is exactly
computable but carries a non-positive chirped measure; positivity — the
Krein/Weil side — lives in its *Hermitian square*. Even on the "easy" $S$-side,
positivity is a Hermitian-square phenomenon.

---

## 3. Numerical closure of Theorem D″ — explicit constants (exp13_energy)

`APPENDIX_D.md` proved $V(T,L)\asymp$ diagonal modulo one unproved ingredient:
near-diagonal separation of the sum spectrum (the weighted additive-energy
hypothesis, §D.4). Exp13 measures that ingredient on the *complete* atom set
below $s\le300$ (3108 atoms from 129 zeros) and closes the whole chain with
explicit constants:

- **Diagonal in closed form.** $D=2\sum_f|c_f|^2=6.036\times10^{-6}$ exactly;
  the D‴ closed form $2\sum_f m_f^2\,(2\pi)f^{-5}$ gives $6.050\times10^{-6}$
  (ratio 1.0024). **[SEED-77: that $0.24\%$ is not agreement-within-noise, it
  is a derivable systematic and should be quoted as such. By Lemma 1 the exact
  diagonal is $D=2\sum_f m_f^2(2\pi)f^{-5}\bigl[(1+f^{-2})(1+4f^{-2})\bigr]^{-1}$
  up to $O(e^{-2\pi\gamma_1})<10^{-38}$, so the D‴ form necessarily *over*shoots
  by the $f^{-5}$-weighted mean of $5/f^{2}+O(f^{-4})$ — positive sign, and of
  size $5/f^2\in[6.3\times10^{-3},\,1.4\times10^{-3}]$ for $f$ between the
  smallest atom $2\gamma_1=28.27$ and $f=60$, which is where the $f^{-5}$
  weighting puts essentially all the mass. The observed $+0.24\%$ sits inside
  that interval, with the correct sign. So this leg of the "four-way agreement"
  is not an independent check: replacing D‴ by Lemma 1 makes it an identity,
  and what was being measured was the term D‴ drops.]** And $\sqrt D=0.002457$ reproduces the measured arithmetic
  band RMS of `APPENDIX_D.md` §D.5 (0.0025): the Parseval chain is now
  **four**-way — zero-pair Parseval, D‴ closed form, synthesized time series,
  and the arithmetic data — agreeing to $\sim1.7\%$ ($0.002457$ vs $0.0025$;
  "three decimals" was over-rounded — audit).
- **The separation ingredient, measured.** The off-diagonal weighted energy
  $E(\eta)=\sum_{f\ne f',|f-f'|\le\eta}|c_fc_{f'}|$ is linear where statistics
  exist: log-log slope $1.10$ over the fit window $\eta\in[10^{-3},0.3]$
  ($\sim2.5$ decades; below $10^{-2}$ the ratio $E/C\eta$ wobbles $\sim2\times$
  and the $\eta=10^{-4}$ point rests on 20 pairs — audit-corrected phrasing),
  $E(\eta)\approx C\eta$ with $C=8.66\times10^{-6}$, $C/D=1.44$. This is the
  Poisson separation hypothesized in §D.4, with no gross clustering excess
  at any resolution where the count is meaningful.
- **Variance = diagonal, with rate.** The quadruple sum (D.1) — exact on the
  truncated same-sign atom set (cross-quadrant sinc² terms $\sim10^{-3}$,
  $s>300$ tail $2.3\%$, both bounded) — gives $V(T,L)/D\in[0.955,1.037]$ on a
  13-point $L$-grid at $u_0=\log10^6$, converging to $0.9998$ at $L=1000$.
  [Audit: the interval is $u_0$-dependent — $0.907$ at $u_0=\log10^5,L=3$; the
  $u_0$-independent statement is the limit $V/D\to1$, which is solid.] The
  dyadic bound (D.2) from the measured $E$-profile certifies off-diagonal
  $\le6.5\%$ of $D$ at $L=100$; threshold $E(1/L)=0.1D$ at $L^*=14.5$.
- **Poisson statistics, properly unfolded.** Raw spacing var/mean² is 6.39 —
  but this conflates the density gradient ($\rho_2(s)\sim s\log^2s$ across the
  band) with clustering. Unfolded by the local pair-sum density (computed as
  the self-convolution of the zero density, which also matches the measured
  atom counts to ~10% using only the main term of $N(T)$), the spacings are
  exponential with var/mean² $=0.997$. This sharpens the Experiment-5 "sums
  are Poisson" finding to the weighted, band-complete atom set that D″
  actually needs.
- **Truncation is controlled:** the tail of $D$ beyond $s=300$ is
  $\le2.3\%$ of $D$ (density-weighted $s^{-5}$ integral).

Figure: `figures/exp13_energy.png`. **Status of D″ after exp13_energy:** every
constant in $V\asymp E_W(1/L)\asymp\sum|W_{12}|^2$ is now measured, and the
lone hypothesis is verified numerically at all accessible resolutions with
$C/D=1.44$. What remains for a theorem is replacing the measured linearity of
$E(\eta)$ by an unconditional count bound on near-solutions of
$\gamma_1+\gamma_2\approx\gamma_3+\gamma_4$ — precisely the Tao–Trudgian–Yang
$N^*$ input, now with the exact weight $2\pi s^{-5}$ (D‴) to plug into their
machinery.

---

## 4. Updated problem list

1. (unchanged) Prime phase rigidity, `REPORT.md` §8.1.
2. (numerically closed — §3 above) Theorem D″ with explicit constants: the
   diagonal is in D‴ closed form (verified, ratio 1.0024), the separation
   ingredient is measured linear with $C/D=1.44$ ~~over five decades~~
   **over the $\sim2.5$ decades where statistics exist** (see the strike
   below), and
   $V/D\to1$ with certified dyadic bounds. Remaining for a *theorem*: an
   unconditional near-diagonal count bound — the Tao–Trudgian–Yang $N^*$
   input with the exact weight $2\pi s^{-5}$.
> **"Over five decades" struck (SEED-100, 2026-08-14, Rule K3; verdict issued
> by `notes/SEED40_ORPHANED_RESULT_PROTOCOL.md` §4.2 Lemma 2 and its §5 table,
> announced there and never applied here; re-flagged as still-standing by
> `notes/SEED37_FITTED_CONSTANT_SWEEP.md` row A).** There are no five decades,
> and this is structural rather than a matter of statistics. For any finite
> band $S$ the atom set $F_S$ is finite, so
> $\delta_S=\min\{|f-f'|:f\ne f'\in F_S\}>0$ and $E\equiv0$ on $[0,\delta_S)$;
> $E$ is a nondecreasing right-continuous **step function** with at most
> $\binom{|F_S|}{2}$ jumps, constant above $\operatorname{diam}F_S$. A log-log
> slope fitted on $\eta\in[10^{-3},0.3]$ is a statement about the empirical gap
> distribution in that window, and the small-$\eta$ end is the *unreliable*
> end: linearity holds for $\eta$ large against the local spacing, not small.
> §3 above already half-noticed this ("below $10^{-2}$ the ratio wobbles
> $\sim2\times$; the $\eta=10^{-4}$ point rests on 20 pairs") and corrected the
> span to $\sim2.5$ decades; this item did not inherit the correction. The
> measured exponent $1.10\ne1$ is that staircase.
>
> Two further amendments from the same source, recorded here because this item
> is where the numbers are quoted: (a) $C/D=\langle\rho\rangle_{|c|^2}$ is an
> **identity** (SEED-40 Lemma 1, independently `SEED37` Prop. A), it converges
> in the band top at rate $O(S^{-2}\log^4S)$ (Thm O), and it is dominated by
> the lowest few dozen zeros (Thm O′) — so it is a certifiable finite sum, not
> a measured law, and the honest presentation is a certificate with
> $s_{\min}$, the atom list and the summation convention fixed; (b) the numeral
> $1.44$ is determined by this corpus only **up to a factor of $2$**, since the
> ordered/unordered convention in the $\sum_{f\ne f'}$ loop is not recorded
> (SEED-40 §4.3, resolvable by reading `code/exp13_energy.py` as text).

3. (replaced) ~~positivity of $\sum W_{ij}\delta_{\gamma_i+\gamma_j}$~~ → identify the
   Matsumoto–Suzuki screw function with a **mixed-block** (first-variation)
   object, and its Krein measure with a Hermitian square carrying
   $|{\cdot}|^2$-weights; the phase law D‴ is the constraint any such dictionary
   must reproduce. *Blocker recorded:* the exact M–S definitions
   (arXiv:2409.00888, J. Number Theory 280 (2026) 918–946; also the companion
   arXiv:2209.04658 "The screw line of the Riemann zeta-function") could not
   be retrieved in this environment (network egress blocks arXiv); the join
   test needs their $g(t)$ verbatim — do not reconstruct it from memory.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp11_blocks.py` | Theorem E2 verification: block closure, band split, Hardy projection, $Q$-orthogonality; `figures/exp11_blocks.png` |
| `code/exp12_krein.py` | Theorem D‴ verification: modulus/phase law, equidistribution, evenness and Gram tests; `figures/exp12_phaselaw.png` |
| `code/exp13_energy.py` | D″ closure: $E(\eta)$ profile, $V(T,L)/D$, unfolded Poisson spacings, tail bound; `figures/exp13_energy.png` |

---

## 5. Theorem J: the screw join — corrected to a band-passed identification (exp23_screwjoin; audit `CROSSREVIEW_EXP22_25.md`)

The sibling branch's `SCREW.md` extracted Matsumoto–Suzuki verbatim: Krein
masses $1/(\gamma^2+\tfrac14)$ on the single zeros, attached to
$T(X)=\sum_{n\le X}(\Lambda*\Lambda)(n)/n^2=\log X+c_2+2\sum_\rho\frac{X^{\rho-1}}{\rho(1-\rho)}+E(X)$.
Splitting $T$ by the adelic blocks:

**What holds (band-passed, and it is the important part):** the mixed
block's *fluctuation* matches the screw kernel at corr **1.0000**, amplitude
ratio **0.9992** (a wrong prefactor would read $\approx2$ or $\approx\tfrac12$);
the $\log X$ main term sits in $[\sharp\sharp]$ at every $Q$ (slope $1.0000$ at
$Q=10/30/60$); the $[\flat\flat]$ fluctuation sits at pair frequencies. **The
zero-line (oscillatory) content of the MS screw kernel lives in the mixed
block.** (Sizing per the audits: Theorem J = MS (1.6) $\circ$ Theorem E2 —
both inputs known; the new content is the block *localization* plus its
numerical closure, now audited to per-mass level: `CROSSREVIEW_THMJ.md`
verified the Krein masses $1/(\gamma_j^2+\tfrac14)$ line-by-line to $\le1\%$
for $j\le8$, phases $0\pm0.03$ rad, with jitter/random-frequency nulls, and
proved the $n^{-2}$ reweighting is the *unique* Krein gauge (their Prop. R2:
$\alpha=2$ iff the denominator is functional-equation symmetric). Their
Prop. R3.1 shows the original exact identity was structurally impossible —
the block's smooth part is not computable from the zero layer. It
contributes no new RH criterion; the RH content is MS Theorem 1.3's. Their
pair-band measurements also close the last loose end: in $[28.5,60]$ the
mixed block matches the single-zero model at corr 1.0000, and $[\flat\flat]$
is positively identified at corr 0.990 — "the chirped pair sector never
enters" is now measured, not inferred.)

**What was wrong (corrected per the cross-audit, independently re-verified
here):** the per-block *constants* are artifacts of the profinite resolution
— the $[\sharp\sharp]$ intercept is $2.362/5.141/7.159$ at $Q=10/30/60$, and the
raw blocks carry large smooth offsets ($[\text{mix}]\to-12.10$,
$[\flat\flat]\to+4.68$ at $Q=30$) that cancel only in the total. The earlier
claims "$c_2=5.1407$ measured from the BC block" and
"$[\text{mix}](T)=2e^{-t/2}(g_{H_1}(t)+H_1(1))$ exactly" are **false**; the
true MS constant, from the total field with the zero oscillation removed, is
$$c_2=-2.2803$$
(stable over $X=10^5$–$1.9\times10^6$; agrees with the sibling `SCREW.md`
Part 5 fit of $-2.280$).

**Corrected interpretive statement.** MS Theorem 1.3's Krein positivity is a
property of the *full* $g_{H_1}$ including its smooth part; the mixed block
carries a $Q$-dependent non-screw smooth component that band-passing
discards. So the honest form of Theorem J is: *the fluctuation sector of the
mixed block is the fluctuation sector of the MS screw line* — an
identification of oscillatory content, not an exact block identity. A
corrected exact statement needs a canonical ($Q\to\infty$ or $Q$-covariant)
smooth subtraction; this is now the open item of the join (see
`CROSSREVIEW_THMJ.md` when filed).

### 5.1 The scheme runs: the anomaly flow of the block constants (exp27_running)

The audit's "Q-dependent artifact" is a *structure*, measured over
$Q\in\{5,\dots,120\}$:

| $Q$ | $[\sharp\sharp]$ | $[\text{mix}]$ | $[\flat\flat]$ | sum |
|---|---|---|---|---|
| 5 | 1.711 | −5.946 | 1.954 | **−2.2805** |
| 30 | 5.141 | −12.102 | 4.681 | **−2.2806** |
| 120 | 9.517 | −20.040 | 8.243 | **−2.2806** |

**The profinite resolution $Q$ behaves like a renormalization scheme**
(organizing language; no scheme-change functor is defined). The invariance
of the summed constants is a tautology of bilinearity + closure, so the
*running* is the content.

**[SUPERSEDED — the running law is now proved, not fitted. See
`notes/METHOD.md` Proposition M1.]** The earlier fitted leading coefficient
($0.362$ by LSQ, $0.421$ by mean extraction, flagged method-sensitive by the
audit) was **an artifact of fitting a quadratic over one decade of
$\log Q$**. The true statement is closed-form:
$$[\sharp\sharp]\text{-constant}=\tfrac14\log^2Q+\bigl(\tfrac{C}{2}+2S_\infty\bigr)\log Q+O(1),
\qquad C=\gamma+\sum_p\tfrac{\log p}{p(p-1)}=1.3326\ldots,$$
with the mechanism exact at its source: the $n=2$ term contributes
$\Lambda^\sharp_Q(1)^2/4$ and $\Lambda^\sharp_Q(1)=\sum_{q\le Q}\mu^2(q)/\varphi(q)
=\log Q+C+o(1)$. So the leading coefficient is exactly $\tfrac14$; the
fitted values were wrong by $45$–$68\%$. $[\flat\flat]$ runs at the
$[\sharp\sharp]$ rate only to first order, $[\text{mix}]$ at minus the sum,
and the $Q\to\infty$ subtraction is ruled out (divergence direction and rate
audit-confirmed).

### 5.2 The k=0 challenge: smoothing is what makes the constants constants (exp28_k0)

Repeating the scheme analysis on the **sharp-cutoff** field
$G_0(X)=\sum_{m+n\le X}\Lambda(m)\Lambda(n)$ (single-zero layer
$2\sum X^{\rho+1}/(\rho(\rho+1))$ subtracted with 30k zeros; smooth parts
fitted on $[1,\log X,\log^2X]$ at $X^1$ scale, $Q=10/30/60$):

- **invariance survives exactly**: the summed fit is
  $-3.507-0.029\log X+0.0013\log^2X$ at all three $Q$ — identical to the
  digit (bilinearity control);
- **the anomaly entangles with the $X$-flow**: per-block $\log X$
  coefficients are nonzero and $Q$-dependent ($[\sharp\sharp]$:
  $-0.053/-0.101/-0.112$; $[\flat\flat]$: $+0.024/+0.071/+0.080$) — at $k=1$
  these are zero and the running lives in constants alone (§5.1);
- **determinacy collapses**: the $[\sharp\sharp]$ smooth part is extractable to
  rms $2\times10^{-5}$ at $k=1$ but only $0.73$ at $k=0$ — same order as the
  coefficients themselves, a $\sim3\times10^4$-fold loss — because the sharp
  cutoff leaves $X$-scale oscillatory content (singular-series waves in
  $[\sharp\sharp]$, conditional pair convergence in $[\flat\flat]$) that one
  Cesàro smoothing kills. Only the mixed block stays clean at $k=0$
  (rms $0.003$–$0.016$).

This is the scheme-language form of `REPORT.md` §5's diagnosis: *one
smoothing is exactly what disentangles the $Q$-running from the $X$-running
and makes the block constants well-defined.* The $\log X$-coefficients'
$Q$-variation at $k=0$ is measured at only $O(1)$ confidence given the
residuals — the qualitative contrast, not the $k=0$ coefficients themselves,
is the result. Companion: the sibling's `SHARP_CUTOFF.md`.
---

# Part II — The two-body adelic block decomposition, computed (Theorem E made empirical)

Companion to `ADELIC.md` §3 (which constructed the decomposition) and the
affine-field update §K (first/second variation). Code: `code/exp13_blocks.py`
plus the spectral-separation check reproduced below. Primes to $2\cdot10^6$,
zeros from the Odlyzko table.

## Setup

$\Lambda = \Lambda^\sharp_Q + \Lambda^\flat_Q$ with
$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)$ (the conditional
expectation onto the BC diagonal at profinite resolution $Q$). The smoothed
Goldbach count splits exactly:
$$G_1 = [\sharp\sharp] + 2[\sharp\flat] + [\flat\flat],$$
verified to machine precision ($3\times10^{-13}$ relative) — as it must, but the
content is the size, shape, and *spectral identity* of each block.

## Measurements

**BC block $[\sharp\sharp]$ = the local model, exactly.** Against the prediction
$\sum_{n\le X}(X-n)\,n\,\mathfrak S_Q(n)$ with $\mathfrak S_Q$ the level-$Q$
truncated singular series: ratio $=1.00000\pm3\times10^{-5}$ at every tested
$Q\in\{1,10,30,100\}$. The critical-BC correlator calculus and the
Ramanujan-coefficient calculus agree on the nose.

**Zero block $[\flat\flat]$ = the second variation, and nothing else.** Its rms
at scale $X^2$ is $0.0024$, *independent of $Q$* — numerically identical to the
Parseval-predicted pair-sum amplitude $0.0025$ of `APPENDIX_D.md` §D.5. Spectral
content in $\log X$: pair-band $[27,45]$ (containing $2\gamma_1, \gamma_1+\gamma_2,
2\gamma_2$) carries $360\times$ the power of the single-zero band $[12,23]$
(single/pair ratio $0.003$).

**Mixed block $2[\sharp\flat]$ = the first variation.** Spectral content:
single-$\gamma$ band carries $34\times$ the pair band; band-passed, it correlates
$+0.976$ with the single-zero sum $-\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$
at amplitude ratio $2.08$ — i.e. the mixed block carries the first-variation
coefficient $2$ predicted by expanding $(dx+dE)*(dx+dE)$, with the $8\%$
excess consistent with finite-$Q$ leakage. At scale $X^2$ the mixed block also
contains deterministic secondary terms (its $O(X^2)$ smooth layer, non-monotone
in $Q$ through Möbius sign cancellations); these are frequency-$0$ in $\log X$
and detrend away.

## Lemma (the mixed block carries the first variation with coefficient exactly 2)

The measured $2.08\approx2$ is a theorem. Write
$2[\sharp\flat]=2\sum_m\Lambda^\sharp_Q(m)\,\Psi_1^\flat(X-m)$ with
$\Psi_1^\flat(y)=\sum_n\Lambda^\flat_Q(n)(y-n)_+$. Since
$\Psi_1^\sharp(y)=\sum_{q\le Q}\tfrac{\mu(q)}{\varphi(q)}\sum_{n\le y}c_q(n)(y-n)$
contains no zeta zeros (periodic summands; the $q=1$ term is $y^2/2$, and for
$q\ge2$ partial summation against the mean-zero $c_q$ gives $O(qy)$), the whole
zero content of $\Psi_1$ sits in $\Psi_1^\flat$:
$$\Psi_1^\flat(y)=-\sum_\rho\frac{y^{\rho+1}}{\rho(\rho+1)}+(\text{smooth},\ O(Qy)).$$
Pairing against $\Lambda^\sharp_Q$: the $q=1$ (density) part of $\Lambda^\sharp$
integrates $\int_0^X(X-u)^{\rho+1}du=X^{\rho+2}/(\rho+2)$, while each $q\ge2$
part contributes $\sum_m c_q(m)(X-m)^{\rho+1}=O(qX^{\rho+1})$ by partial
summation. Hence
$$2[\sharp\flat] \;=\; -2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}
\;+\;O\!\bigl(Q\,X^{3/2}\bigr)\;+\;(\text{smooth in }X),$$
i.e. the mixed block carries the full single-zero layer with coefficient
exactly $2$, plus a finite-$Q$ leakage of **relative** size $O(Q/X)$.

> **Correction (SEED-77, 2026-08-14; full argument in
> `notes/SEED77_BLOCKS_POSTCONDITION.md` §2–§3).** This display previously read
> $O_Q(X^{3/2})$, with the relative size quoted as
> "$X^{3/2}/X^{5/2}=X^{-1}$" and the sentence "accounting for the measured
> $2.08$ at $Q=30$ and predicting the coefficient $\to2$ as $Q\to\infty$". The
> $Q$-dependence was dropped from a ratio — the `HOLOGRAM.md` §7 failure — and
> the proof one paragraph above supplies it: each $q\ge2$ term is
> $O(qX^{\rho+1})$ weighted by $|\mu(q)|/\varphi(q)$, so the total is
> $\ll X^{3/2}\sum_{q\le Q}\mu^2(q)\,q/\varphi(q)\asymp QX^{3/2}$, relative
> $\asymp Q/X$. Consequences:
> - *Good:* the coefficient is exactly $2$ throughout the joint range
>   $Q=o(X)$, so no interchange of $Q\to\infty$ with $X\to\infty$ is required
>   and the "$\to2$ as $Q\to\infty$" reading is earned on that range.
> - *Bad:* at $Q=30$ and $X$ between $10^{4}$ and $2\cdot10^{6}$ the leakage is
>   at most $3\times10^{-3}$ and typically $\sim10^{-5}$. **The claim that the
>   $8\%$ excess in the measured $2.08$ is "consistent with finite-$Q$ leakage"
>   is excluded by this note's own proof, by one to four orders of magnitude.**
>   The excess belongs to the estimator (zero-sum truncation, band-pass window,
>   detrending), not to the decomposition; Part I's independent $1.0000$
>   against the same model, with the $2$ folded in, is consistent with that.
>   The Lemma itself is untouched — it was always the theorem, and $2.08$ was
>   never evidence for it. Simultaneously this proves the zero block $[\flat\flat]$ contains
*no* single-zero layer at leading order: its single-band content is the square
of fluctuations, of relative order $X^{-1/2}$ — matching the measured
single/pair power ratio $0.003$.

## What this establishes

The canonical decomposition of `ADELIC.md` §3 is not just formally exact — its
blocks have *disjoint spectral supports* matching the variation calculus:

| block | identity | $\log X$ frequencies | measured |
|---|---|---|---|
| $[\sharp\sharp]$ | mean / local (BC) | $0$ | $=\mathfrak S_Q$-model, ratio 1.00000 |
| $2[\sharp\flat]$ | first variation | single $\gamma_i$ | corr 0.976, coeff 2.08 ≈ 2 |
| $[\flat\flat]$ | second variation | pair sums $\gamma_i+\gamma_j$ | rms 0.0024 = Parseval 0.0025 |

Consequences for the program:

1. The Matsumoto–Suzuki screw kernel (RH-equivalence) must live in the *mixed
   block* — first variation, single zeros — pinning the target of the
   screw-kernel join precisely.
2. "RH enters Goldbach at first order, pair correlation at second order"
   (update §K) is now a measured statement about two orthogonal frequency bands
   of one arithmetic signal.
3. The parity/charged sector (Theorem F, `GAUGE.md`) is invisible in *all
   three* blocks — it has no atoms, hence no lines in any band; its only
   possible residence is the broadband floor, which at our scales is at the
   $10^{-3}$ level of the pair lines. A quantitative version of "how flat is
   the floor" is exactly the Chowla-flatness of `PARITY.md`.
