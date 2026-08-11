# Closure of the adelic block decomposition, and the phase law of the sum-spectrum measure

Companion to `REPORT.md`, `ADELIC.md`, `APPENDIX_D.md`. This document executes the
two items flagged as "next" in `ADELIC.md` §3 and `APPENDIX_D.md` §D.6.3: the
numerical closure of the two-body adelic block decomposition (exp11), and the
Krein positivity test of the sum-spectrum measure (exp12). The first *confirms*
the decomposition and *corrects* one attribution in `ADELIC.md` §3. The second
*refutes* the naive positivity guess of Problem 3 — and replaces it with an exact
asymptotic law for the pair weights (modulus **and** phase) that any correct
screw-function dictionary must now match.

---

## 1. Theorem F: the block spectral-support theorem (exp11)

Recall the canonical BC conditional expectation at profinite resolution $Q$
(`ADELIC.md` §3): $\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q$,
$\Lambda^\flat=\Lambda-\Lambda^\sharp_Q$, and the induced block decomposition of the
smoothed Goldbach count $G_1(X)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)(X-m-n)_+$:
$$G_1=[\sharp\sharp]+\bigl([\sharp\flat]+[\flat\sharp]\bigr)+[\flat\flat].$$

Since the Laplace transforms split as $P^\sharp(z)\sim\frac1z+(\text{rational
atoms})$ and $P^\flat(z)\sim-\sum_\rho\Gamma(\rho)z^{-\rho}+O(1)$, the explicit
formula predicts a *sharper* statement than `ADELIC.md` §3 recorded:

**Theorem F (block spectral support; RH for the frequency statement).** In log-$X$
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

**Verification (exp11; $\Lambda$ to $2\cdot10^6$, $Q=30$, 30,000 zeros in the
single-zero model, 1200 in the pair model).**

- **Exact closure:** $\max_X\bigl|[\sharp\sharp]+[\text{mix}]+[\flat\flat]-G_1\bigr|/G_1
  = 2.1\times10^{-13}$.
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
  \approx10^{-4}$, flat in $Q$ (tail prediction $\sum_{q>Q}\mu^2/\varphi^2$ decays
  like $1/Q$; the measured means sit far below even the $Q=100$ tail, i.e.
  orthogonality holds with room to spare at $X=2\cdot10^6$).

Figure: `figures/exp11_blocks.png` — the three block spectra, each showing only
its own line system.

**What this buys.** The decomposition of `ADELIC.md` §3 is now *numerically
closed*: every layer of Theorem D sits in exactly one named block, with the
block boundaries at machine precision. The corrected attribution matters
structurally: "pole × zero" is the first-variation sector (`PARITY.md` §1K),
so the Matsumoto–Suzuki screw kernel — conjectured there to be the first
variation — should be sought in the **mixed** block, not the zero block.

---

## 2. Theorem D‴: the exact weight law — modulus *and phase* (exp12)

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

**Verification (exp12; first 600 zeros, all $600^2$ same-sign pairs).**

- modulus ratio $|W|/\bigl(\sqrt{2\pi}s^{-5/2}\bigr)$: mean $0.999995$, max
  deviation $0.31\%$;
- phase deviation from $-sH(p)-5\pi/4$: rms $0.0045$ rad; max-deviation envelope
  decays as predicted: $0.077,\,0.031,\,0.016,\,0.0054$ for
  $\min(\gamma,\gamma')>20,50,100,300$ — i.e. $\approx1.6/\min(\gamma,\gamma')$.

Figure: `figures/exp12_phaselaw.png` (diagonal chirp $-f\log2-\tfrac{5\pi}{4}$;
error scaling; atom-phase histogram).

### 2.1 The Krein test: the amplitude measure is *maximally non-positive*

Consequences of the phase law, all verified (exp12):

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
> cancels: $|W|^2=2\pi s^{-5}$ (exactly phase-free, by D‴). The variance object
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

## 3. Updated problem list

1. (unchanged) Prime phase rigidity, `REPORT.md` §8.1.
2. (sharpened) Theorem D″ with explicit constants: by D‴ the diagonal is now in
   closed form, $2\sum_{\{\gamma_1,\gamma_2\}}|W_{12}|^2 = 4\pi\sum_{\gamma_1<\gamma_2}
   (\gamma_1+\gamma_2)^{-5}+2\pi\sum_\gamma(2\gamma)^{-5}+O(\min^{-1})$-corrections —
   the remaining work is purely the off-diagonal separation bound.
3. (replaced) ~~positivity of $\sum W_{ij}\delta_{\gamma_i+\gamma_j}$~~ → identify the
   Matsumoto–Suzuki screw function with a **mixed-block** (first-variation)
   object, and its Krein measure with a Hermitian square carrying
   $|{\cdot}|^2$-weights; the phase law D‴ is the constraint any such dictionary
   must reproduce.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp11_blocks.py` | Theorem F verification: block closure, band split, Hardy projection, $Q$-orthogonality; `figures/exp11_blocks.png` |
| `code/exp12_krein.py` | Theorem D‴ verification: modulus/phase law, equidistribution, evenness and Gram tests; `figures/exp12_phaselaw.png` |
