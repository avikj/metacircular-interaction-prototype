# The twisted product carrier: exp31 lifted to the Dirichlet tower (χ₃)

**Task:** lift the product-carrier construction of `PRODUCT_CARRIER.md` (C1–C3) to the
non-principal character mod 3, joining it to the abelian-tower lane of the catchup branch
(`FAMILY.md` §2.1, `exp20_dirichlet.py`).
**Code:** `code/exp34_twisted_carrier.py` → `figures/exp34_twisted_carrier.png`;
L-zeros self-computed to `data/chi3_zeros_ext.npy` (205 ordinates to $t<320$, extending the
17-zero exp20 cache, which is reproduced to the double-precision floor).
**Status of claims:** graded per item. Standing hypotheses are stated per proposition; the
numerical parts assume nothing beyond what is printed (no fitted parameters anywhere —
fits appear only as *null tests* whose fitted coefficient is predicted to vanish).

Throughout, $\chi=\chi_3$ is the primitive odd quadratic character mod 3
($\chi(n)=+1,-1,0$ for $n\equiv1,2,0$), $\rho=\beta+i\gamma$ runs over nontrivial zeros of
$L(s,\chi_3)$ with **signed** ordinates (the zero set is $\gamma\mapsto-\gamma$ symmetric
because $\chi$ is real), and under GRH($\chi_3$)

$$a(\gamma)=\frac{1}{\gamma^2+\tfrac14}=\frac1{\rho(1-\rho)}\Big|_{\beta=1/2}>0,\qquad
h_\chi(u)=\sum_\gamma a(\gamma)e^{i\gamma u}=2\sum_{\gamma>0}a(\gamma)\cos\gamma u,$$

$$\mu_\chi=\sum_\gamma a(\gamma)\,\delta_\gamma,\qquad
\nu_\chi=\mu_\chi*\mu_\chi=\sum_{\gamma,\gamma'}a(\gamma)a(\gamma')\,\delta_{\gamma+\gamma'} .$$

---

## 1. Proposition T1: the twisted one-body carrier (proved, unconditional)

**Proposition T1.** For $X>1$ let
$S_\chi(X)=\sum_{n\le X}\Lambda(n)\chi_3(n)\,\frac{X-n}{n}$. Then, unconditionally, with the
zero sum absolutely convergent ($|\rho(1-\rho)|\ge\gamma^2$; first ordinate $8.04$, and
$L(s,\chi_3)$ has no real zeros in $(0,1)$),

$$S_\chi(X)=c_1X+c_0+\sum_\rho\frac{X^\rho}{\rho(1-\rho)}+\delta_\chi(X),$$

with **exact closed-form constants**

$$c_1=-\frac{L'}{L}(1,\chi_3)=\sum_{n\ge1}\frac{\Lambda(n)\chi_3(n)}{n}=-0.368281615970\ldots,$$
$$c_0=+\frac{L'}{L}(0,\chi_3)=3\log\frac{\Gamma(1/3)}{\Gamma(2/3)}-\log 3=0.948198826673\ldots,$$
$$\delta_\chi(X)=-\operatorname{artanh}(1/X)-\tfrac X2\log(1-X^{-2})=-\tfrac1{2X}+O(X^{-3})<0 .$$

**There is no $X\log X$ term and no other main term**: $-L'/L(s,\chi_3)$ has no pole at
$s=1$ (since $L(1,\chi_3)=\pi/(3\sqrt3)\ne0$), so the zero layer is the leading oscillatory
term over the linear/constant layer. Under GRH($\chi_3$),
$S_\chi(X)=c_1X+c_0+\sqrt X\,h_\chi(\log X)+\delta_\chi(X)$: the χ-twisted screw data with
**positive masses** $a(\gamma_\chi)$.

*Proof.* Mellin representation: $\sum_n \frac{a(n)}n(X-n)_+ =\frac1{2\pi i}\int_{(c)}
F(w)\frac{X^w}{w(w-1)}\,dw$ with $F=-L'/L(\cdot,\chi_3)$, $c>1$. Shift to
$\operatorname{Re}w\to-\infty$ (kernel decays like $|w|^{-2}$; $L'/L$ is bounded on the
standard zero-avoiding contours; the horizontal error terms are the same standard ones as
in C1). Residues: at $w=1$ the kernel has a simple pole with residue $1$ and $F$ is
*regular* — contribution $-L'/L(1,\chi)\,X=c_1X$; at $w=0$, kernel residue $-1$ and $F$
regular ($L(0,\chi_3)=1/3\ne0$ since $\chi$ is odd) — contribution $+L'/L(0,\chi)=c_0$; at
each nontrivial zero $\rho$ (order $m_\rho$), $F$ has residue $-m_\rho$ — contribution
$m_\rho X^\rho/(\rho(1-\rho))$; at the trivial zeros $w=1-2m$ ($m\ge1$; $\chi$ odd) —
contribution $-\sum_m X^{1-2m}/((2m-1)2m)=\delta_\chi(X)$, summed in closed form via
$\operatorname{artanh}$. The closed form for $c_0$ is Lerch:
$L'(0,\chi)=-\tfrac13\log3+\log(\Gamma(1/3)/\Gamma(2/3))$, $L(0,\chi)=\tfrac13$. $\square$

Grade: **proved** (imported: the standard contour machinery for $-L'/L$ of a primitive
Dirichlet character, exactly as C1 imported it for $\zeta$). Every constant verified in
Part 0: $c_0$ vs its $\Gamma$-closed form to $10^{-12}$ (printed diff $0.0$ at 30 dps);
$\delta_\chi$ residue series vs closed form to $5.6\cdot10^{-17}$; the sieve sum
$\sum_{n\le4\cdot10^6}\Lambda\chi/n=-0.368646$ vs $c_1$ (diff $-3.6\cdot10^{-4}$,
consistent with the $O(X^{-1/2})$ zero-layer fluctuation of the partial sum).

**Functional-equation ledger (proved, and the analogue of $B=2+\gamma_E-\log4\pi$).**
From $\Lambda(s,\chi)=(3/\pi)^{(s+1)/2}\Gamma(\tfrac{s+1}2)L(s,\chi)=\Lambda(1-s,\chi)$
(root number $+1$; the Gauss sum $\tau(\chi_3)=i\sqrt3$ gives $\epsilon=\tau/(i\sqrt3)=1$):

$$\frac{L'}{L}(0,\chi)+\frac{L'}{L}(1,\chi)=-\log\frac3\pi+\gamma_E+\log2
\qquad(\text{verified to }2\cdot10^{-31}),$$

$$B_\chi:=\sum_\rho\frac1{\rho(1-\rho)}=\log\frac3\pi-\gamma_E+2\frac{L'}{L}(1,\chi_3)
=0.113229969857\ldots$$

(Hadamard: $B_\chi=2\,\Lambda'/\Lambda(1,\chi)$, using $\Lambda'/\Lambda(0)=-\Lambda'/\Lambda(1)$.)
Zero-sum check: $205$ zeros give $0.107226$; adding the integrated zero-density tail
estimate $2(\log(3T/2\pi)+1)/(2\pi T)|_{T=320}=0.006$ lands on $0.113224$, i.e. $0.01\%$
from the exact value — same $1/T$ convergence rate as the $\zeta$ case (exp31 Part 0).
Note the curiosity $\log(3/\pi)=-0.04612\approx-B_{\zeta}$; numerically coincidental.

---

## 2. Proposition T2: the twisted pair carrier (proved, corollary)

**Proposition T2.** With independent cutoffs,
$T_\chi(X,Y)=\sum_{m\le X,n\le Y}\Lambda(m)\chi(m)\Lambda(n)\chi(n)\frac{(X-m)(Y-n)}{mn}
=S_\chi(X)S_\chi(Y)$ (separable kernel — per-variable reweighting *first*, diagonal
$X{=}Y$ *last*, exactly the order of operations forced by `PRODUCT_WEIGHT_NO_GO.md`), and

$$P_\chi(X):=\frac{(S_\chi(X)-c_1X-c_0)^2}{X}
\;\overset{\text{GRH}(\chi_3)}{=}\;h_\chi(\log X)^2+O(X^{-5/2})
=\int e^{i\omega\log X}\,d\nu_\chi(\omega)+O(X^{-5/2}).$$

Unconditionally $P_\chi=X^{-1}\big(\sum_\rho X^\rho/(\rho(1-\rho))+\delta_\chi\big)^2$.
Grade: **proved** (square T1; $|h_\chi|\le B_\chi$). The pair layer carries the product
measure $\nu_\chi$ on the sum spectrum of the **L-zeros**: positive masses
$a(\gamma)a(\gamma')$, DC mass $m_{0,\chi}=\sum_\gamma a(\gamma)^2=6.8659\cdot10^{-4}$.

**Contrast with exp20's pair object.** The twisted Goldbach field
$G_1^{\chi}(X)=\sum\Lambda\chi(m)\Lambda\chi(n)(X{-}m{-}n)_+$ carries the *same* jewel
string with **Beta weights** $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$
(complex-phased, Krein-indefinite, $e^{-\pi\gamma}$-graded); the present carrier replaces
them by the positive product masses — the χ-analogue of exp31's replacement of Theorem D's
metric, and the no-go argument transfers verbatim (nothing in
`PRODUCT_WEIGHT_NO_GO.md` Thm 2.1 uses the pole of $\zeta$; the Beta coupling comes from
the archimedean kernel of $m+n$ alone).

---

## 3. Proposition T3: "g_χ is a screw function ⟺ GRH for L(s,χ₃)"

Define unconditionally (absolutely convergent, real, even)

$$g_\chi(t)=H_1^\chi(e^t)-B_\chi,\qquad
H_1^\chi(x)=\sum_\rho\frac{x^{\rho-1/2}}{\rho(1-\rho)},\qquad
g_{2,\chi}(t)=H_1^\chi(e^t)^2-B_\chi^2,$$

both computable from prime data by T1/T2 ($H_1^\chi(e^t)$ is the $q$ of §5 below).

**Proposition T3.** $g_\chi$ is a screw function $\iff$ GRH($\chi_3$); the same holds for
$g_{2,\chi}$ (whose Krein measure is $\nu_\chi$), with the converse factoring through the
one-body bound.

*Proof structure* (mirrors C3 exactly). ($\Leftarrow$) Under GRH($\chi_3$) the masses are
$a(\gamma)>0$ outright, so $\mu_\chi\ge0$ is a finite positive measure ($\mu_\chi(\mathbb
R)=B_\chi$) and $G_{g_\chi}(t_i,t_j)\xi_i\bar\xi_j=\int|\sum_i(e^{i\omega
t_i}-1)\xi_i|^2d\mu_\chi\ge0$; likewise for $g_{2,\chi}$ with $\nu_\chi=\mu_\chi*\mu_\chi$.
($\Rightarrow$) One-point Krein positivity gives $-2g_\chi(t)\ge0$, i.e. the generalized
Dirichlet series $H_1^\chi(e^t)=\sum_\rho m_\rho\,e^{(\rho-1/2)t}/(\rho(1-\rho))$-type sum
(absolutely convergent coefficients) is **bounded on all of $\mathbb R$**; a
Matsumoto–Suzuki-style boundedness lemma [MS arXiv:2409.00888, Cor. 3.1 and proof of
Thm 1.3] then forces every exponent $\rho-\tfrac12$ to be purely imaginary, i.e.
$\beta=\tfrac12$. $\square$

**What we use from the MS framework, exactly.** Their §5 axiomatizes the screw-function
correspondence beyond $\zeta$ (functional equation + Euler product class). We import only:
(i) the Krein/screw formalism (definitions and the Hermitian-square direction — elementary
given positive masses); (ii) the boundedness-forces-real-exponents lemma, which is a
statement about generalized Dirichlet series $\sum m_\rho e^{(\rho-1/2)t}$ with
$\sum|m_\rho|\,|{\rho(1-\rho)}|^{-1}<\infty$ and is character-independent — nothing in it
refers to $\zeta$'s pole, so it applies to the $\chi_3$ exponent set verbatim, with the
zero-pairing $\rho\leftrightarrow1-\rho$ supplied by the functional equation of the *real*
character. The explicit-formula ingredient (their (1.6) analogue) is **not** imported: T1
is proved directly above.

Grades. ($\Leftarrow$): **proved** (elementary; positivity of the masses under GRH is
immediate). ($\Rightarrow$): **proved modulo the quoted MS boundedness lemma**, which this
repo has only in the `SCREW.md` arXiv-extraction form — same status as C3, inherited
caveat recorded below. **Hypotheses:** GRH($\chi_3$) for the screw direction; **simplicity
of zeros is NOT needed** anywhere in T1–T3 (multiplicities enter as $m_\rho\,a(\gamma)>0$,
which only reinforces positivity) — contrast the $1/\zeta'(\rho)$-weighted objects of
`FAMILY.md` where simplicity is structural. The numerical model does hard-code the
computed (simple, on-line) zero list.

---

## 4. Proposition T4: purity — no pole, no foreground, no mixed block

**Proposition T4** (structural, proved at identity level by T1; verified numerically in
Part 3). The layer algebra of `FAMILY.md` §2 applied to $S_\chi$: the singularity sources
of $-L'/L(s,\chi_3)$ against the kernel $1/(w(w-1))$ are {zeros} ∪ {$w{=}1$ kernel pole} ∪
{$w{=}0$ kernel pole}, and since $L$ itself has **no pole**, the pole×zero and pole×pole
foreground of the untwisted carrier ($X\log X$ from the double pole at $w=1$, and the
$-B X$ cross term) is **absent**. $S_\chi$ has exactly three layers: linear, constant,
zero-oscillation. Consequently $P_\chi$ has **no $[\sharp\sharp]$-type foreground and no
mixed block**: the twisted carrier is *pure screw* — the χ-analogue, at the
positive-measure level, of Möbius purity (`FAMILY.md` §1: $\mu$ is pure for the *Beta*
metric; $\Lambda\chi_3$ is pure for the *screw* metric while keeping $\Lambda$'s unit
residues).

**Verified (Part 3), two ways.**

1. *Null fit.* LSQ of $S=aX\log X+bX+c$ on the grid (the only place any fit appears):
   twisted $a=+5.2\cdot10^{-6}$ (predicted $0$), $b=-0.368355$ vs closed form
   $c_1=-0.368282$ ($7\cdot10^{-5}$ recovery of the L-value by raw prime data); untwisted
   control on the same grid: $a=+1.000001$ (predicted $1$), $b=-1.577231$ vs
   $-(1+\gamma_E)=-1.577216$.
2. *Extraction robustness.* Mean per-line mass error over the first 8 zeros of the
   respective string, under three subtraction protocols (identical grid/window):

   | protocol | twisted ($\chi_3$) | untwisted ($\zeta$) |
   |---|---|---|
   | full closed-form smooth part | $0.0013\%$ | $0.0001\%$ |
   | linear span $\{X,1\}$ only | $0.0013\%$ | $9249\%$ |
   | no subtraction | $356\%$ | $8316\%$ |

   With exact constants both towers sit at the window floor; the purity is the middle row:
   for $\chi_3$ the linear span **is** the whole smooth part, so mass extraction survives
   with a $7\times10^6$-fold error advantage over the untwisted carrier under the same
   impoverished subtraction. The pole is precisely the object whose removal requires the
   transcendental $X\log X$ term; the twisted tower never has it. (Reference point: exp30's
   per-zero masses on 8 zeta zeros, extracted with the trend present, were good to
   $\le1\%$; the twisted carrier reaches $0.001\%$ — three orders cleaner — and does so
   with only $\mathrm{span}\{X,1\}$ subtracted.)

**Finite-place fingerprint (measured).** The residue of $-L'/L$ at every zero is
$m_\rho=1$ — *character-independent*; the Gauss sum $\tau(\chi_3)=i\sqrt3$ enters the
functional equation but **cancels out of the line coefficients**. Prediction: the line
weights of $q$ are the real positive $a(\gamma)$, with no Gauss-sum phase (the twisted
analogue of exp20's unit weights, now phase-free rather than Beta-phased). Measured: the
data-vs-model phase at the first 8 lines is $\le0.0023^\circ$ (table §5). The character
shows up **only** in which string plays and in the constants $(c_1,c_0)$ — consistent with
exp21's classification ($\Lambda\chi_3$: Galois-twisted visibility at finite places, full
strength at the archimedean place).

---

## 5. Numerical verification (the headline numbers)

Protocol: $\Lambda$ sieved to $4\cdot10^6$; $\chi_3$ applied pointwise; exact longdouble
prefix sums; grid of $M=8192$ log-uniform $X\in[3\cdot10^3,3.9\cdot10^6]$;
$q:=(S_\chi-c_1X-c_0)/\sqrt X$, $P_\chi:=q^2$; model from all 205 self-computed zeros.
**Zero fitted parameters.**

**L-zeros (Part 1).** 205 ordinates in $(0,320)$ from sign changes of the normalized real
completed $\Lambda(\tfrac12+it,\chi_3)$ (mpmath, 25 dps; root tolerance $10^{-30}$).
Validation: $\max_\gamma|L(\tfrac12+i\gamma,\chi_3)|=2.1\cdot10^{-13}$ (criterion
$<10^{-10}$ passed for all 205); first 17 reproduce the exp20 cache to the float64 floor;
count matches Riemann–von Mangoldt $N^+(T)=(T/2\pi)\log(3T/2\pi e)=205.2$; max
gap/local-mean $=1.91$ (no missed-zero flag).

**One-body identity (T1).** corr$(q,h_\chi)=0.999986$ full-band (limited by the 205-zero
model tail, est. $\sim$0.5% truncated mass); in the resolved band $[5,45]$:
**corr $=1.00000000$, RMS ratio $1.000000$, relative residual $1.07\cdot10^{-5}$** — at
the truncation/window floor with zero free parameters, matching exp31's untwisted floor
($2.7\cdot10^{-5}$) despite a 146× smaller zero list. Per-line table (Hann DFT):

| $\gamma^\chi$ | data amp | model amp | ratio | $2a(\gamma)$ | ratio vs $2a$ | phase (deg) |
|---|---|---|---|---|---|---|
| 8.0397 | 3.0907e-02 | 3.0907e-02 | 1.0000 | 3.0823e-02 | 1.0027 | +0.0001 |
| 11.2492 | 1.5939e-02 | 1.5939e-02 | 1.0000 | 1.5774e-02 | 1.0105 | +0.0000 |
| 15.7046 | 8.1000e-03 | 8.1000e-03 | 1.0000 | 8.1009e-03 | 0.9999 | +0.0001 |
| 18.2620 | 5.8919e-03 | 5.8919e-03 | 1.0000 | 5.9925e-03 | 0.9832 | −0.0009 |
| 20.4558 | 4.6391e-03 | 4.6390e-03 | 1.0000 | 4.7768e-03 | 0.9712 | +0.0006 |
| 24.0594 | 3.4723e-03 | 3.4722e-03 | 1.0000 | 3.4536e-03 | 1.0054 | +0.0014 |
| 26.5779 | 2.9090e-03 | 2.9091e-03 | 1.0000 | 2.8303e-03 | 1.0278 | −0.0003 |
| 28.2182 | 2.5965e-03 | 2.5965e-03 | 1.0000 | 2.5109e-03 | 1.0341 | +0.0023 |

Identity quality vs model (same window): mean $0.001\%$, max $0.005\%$. Vs isolated $2a$:
mean $1.6\%$, max $3.4\%$ — this is **neighbor-line interference at the window resolution
$\sim0.9$** (the L-string is denser than $\zeta$'s at these heights), not extraction
error; the same-window model column absorbs it, exactly as exp31 §6 warned for the pair
metric. Phases $\le0.0023^\circ$: the no-Gauss-phase fingerprint (§4).

**ζ-string absence.** At $\gamma_1^\zeta=14.135$ the data amplitude is $4.332\cdot10^{-4}$
— and the pure-L model shows the *same* $4.332\cdot10^{-4}$ from its own line leakage: the
apparent power at the ζ frequency is 100% accounted for by the L-string, no ζ content.
(The probe at $\gamma_2^\zeta=21.022$ is confounded — $0.57$ from $\gamma_5^\chi=20.456$,
inside resolution — disclosed, same interleaving caveat as exp20.)

**Pair identity (T2) against ν_χ (Part 4).** DC: mean$(P)=6.5451\cdot10^{-4}$ vs
mean$(h_\chi^2)=6.5448\cdot10^{-4}$ (agree to $5\cdot10^{-5}$ relative), vs
$m_{0,\chi}=6.8659\cdot10^{-4}$ — the 4.7% gap to the exact diagonal mass is finite-window
cross-term leakage, *equal in data and model*. Band $[14,55]$: corr$(P,h_\chi^2)=
\mathbf{1.000000}$, ratio $1.000007$; corr$(P,$ binned-$\nu_\chi$ line model$)=
\mathbf{0.999918}$, ratio $1.001$ (6773 lines, all masses positive). Pair lines:

| line | $f$ | data amp | $\nu_\chi$-model | ratio | isolated $2c_f$ |
|---|---|---|---|---|---|
| $2\gamma_1$ | 16.079 | 5.488e-04 | 5.497e-04 | 0.9985 | 4.750e-04 |
| $\gamma_1{+}\gamma_2$ | 19.289 | 4.143e-04 | 4.140e-04 | 1.0008 | 4.862e-04 |
| $2\gamma_2$ | 22.498 | 1.326e-04 | 1.325e-04 | 1.0011 | 1.244e-04 |
| $\gamma_1{+}\gamma_3$ | 23.744 | 2.991e-04 | 2.990e-04 | 1.0003 | 2.497e-04 |
| $\gamma_2{+}\gamma_3$ | 26.954 | 2.587e-04 | 2.588e-04 | 0.9996 | 1.278e-04 |

Mean $|{\rm ratio}-1|=0.08\%$, max $0.15\%$ — cleaner than exp31's pair table (0.02–0.22%
deviations at 4 lines), again with the isolated-$2c_f$ column deviating by up to 2× where
$\nu_\chi$'s own difference lines sit unresolved nearby (the exp31 methodological caution
transfers: compare against the full line measure, never bare masses). Parseval in band:
line-sum $6.10\cdot10^{-4}$ vs model RMS $6.5653\cdot10^{-4}$ vs data RMS
$6.5654\cdot10^{-4}$ — data≡model to $10^{-5}$; the 7% line-sum deficit is the same
unresolved-cross-term effect, larger here because the L pair-line density in band is
higher.

**Single-zero absence in the pair layer.** $\gamma_4^\chi=18.262$: amp $5.89\cdot10^{-3}$
in $q$ vs $1.32\cdot10^{-4}$ in $P$ (×45 suppression), and $\nu_\chi$'s own
difference-line clusters predict $1.320\cdot10^{-4}$ — agreement to $0.2\%$;
$\gamma_5^\chi=20.456$: ×56 suppression, prediction good to $0.5\%$. As in exp31, even the
residue at single-zero frequencies is carried by $\nu_\chi$ (mixed-sign sector), not by a
single-zero layer — there is none, as T4 demands.

**Off-line injection (Part 5).** Replace the first zero pair by the quadruple
$\{\beta\pm i\gamma_1,1-\beta\pm i\gamma_1\}$ (204 zeros retained on the line); Krein
kernels on the uniform grid ($n=120$, $T=25$):

| $\beta$ | 0.50 | 0.55 | 0.60 | 0.65 | 0.70 |
|---|---|---|---|---|---|
| one-body $g_1^\chi$: $\lambda_{\min}/|\lambda|_{\max}$ | $+5.4\cdot10^{-5}$ | $-0.136$ | $-0.690$ | $-0.966$ | $-0.999$ |
| pair $g_2^\chi$ (kernel of $\nu_\chi$) | $+2.0\cdot10^{-3}$ | $-0.335$ | $-1.000$ | $-1.000$ | $-1.000$ |

Random-grid check at $\beta=0.60$ (pair): $-1.000$. Positive at $\beta=\tfrac12$,
strongly indefinite off the line, pair kernel $\approx2.5\times$ stronger at small
$\beta-\tfrac12$ — the doubled-exponent heuristic of exp31 Part 4 reproduced on a second
L-function. Grade: numerical; no rate proved.

---

## 6. What the tower buys

Each Dirichlet character now carries its **own screw function on an explicit arithmetic
carrier**: $g_\chi$ is computable from a finite sum over prime powers weighted by
$\Lambda\chi$, its Krein positivity is *equivalent* to GRH for that single $L(s,\chi)$
(T3), and its pair square carries the per-character product measure $\nu_\chi$. The
"jewel string" of `FAMILY.md` §2.1 — until now displayed only through the Beta-phased
Goldbach net of exp20 — is thus carried by an object with positive closed-form masses and
a per-character positivity criterion: the abelian tower converts "GRH for the family" into
a *family of screw axioms*, one finite-arithmetic object per character, with the
untwisted case (exp31) as the $\chi_0$ floor — and the twisted members are *cleaner* than
the floor (T4: no pole, no foreground, extraction robust to trivial subtraction). The
natural next rungs, not claimed here: summing the carriers over characters mod $q$ to get
progression-resolved screw functions $\big(\sum_{\chi}\bar\chi(a)S_\chi$ reads
$\Lambda$ on $n\equiv a\ (q)\big)$, cf. Bhowmik–Halupczok–Matsumoto–Suzuki
(arXiv:1704.06103) for the progression⇔double-L-sum dictionary; and a complex
(non-real) character, where the zero set loses $\gamma\mapsto-\gamma$ symmetry and
$h_\chi$ becomes genuinely complex — the first place a Gauss-sum phase could survive in
this metric.

## 7. Honest caveats

- **Zero truncation:** 205 zeros to $t<320$. Full-band one-body corr is $0.999986$ for
  this reason alone; all banded statements are tail-safe. $B_\chi$ from the zero list
  needs the (estimated, not proved) density-tail term to meet the exact value — displayed
  as such. Completeness of the list rests on the count formula ($205$ vs $205.2$) and the
  max-gap diagnostic, not on an argument-principle certificate; a missed close pair would
  perturb the model at the $a(\gamma)$ level of that height.
- **GRH($\chi_3$) is assumed** wherever $h_\chi$, positive masses, or $\nu_\chi\ge0$
  appear (T1's identity itself is unconditional). Zeros were searched on the critical
  line only; off-line zeros, if any, are exactly what the Part-5 kernel would detect.
- **Simplicity** is not needed for T1–T3 (multiplicity only reweights positively), but
  the numerical model hard-codes the computed simple-zero list.
- **MS full text unverified:** the T3 converse quotes the Matsumoto–Suzuki boundedness
  lemma in the `SCREW.md` HTML-extraction form; arXiv:2409.00888 remains egress-blocked
  from this environment (re-confirmed caveat of `CROSSREVIEW_THMJ.md` §7 — a shared
  single point of failure for every screw⟺RH converse in the repo). Verify against the
  published paper before any write-up.
- **Window-resolution interference:** isolated-mass columns (one-body vs $2a$, pair vs
  $2c_f$) deviate by up to 3.4% / 2× where neighboring lines of the same measure sit
  within resolution $\sim0.9$; all identity-level comparisons are made against
  same-window models, where the floor is $10^{-5}$–$10^{-3}$. The ζ-absence probe at
  $\gamma_2^\zeta$ is confounded by $\gamma_5^\chi$ (0.57 away) and is not evidence
  either way; the probe at $\gamma_1^\zeta$ is clean to its leakage floor.
- The purity table's "linear-only ≡ full" degeneracy for $\chi_3$ is a *structural*
  statement about which subtractions exist, not a claim that the untwisted carrier is
  wrong — with its own exact constants the untwisted floor is equally good ($0.0001\%$).

## 8. Relation to exp20 / exp31

Same zero string as exp20 (its 17 ordinates reproduced from scratch and extended 12×),
different metric: exp20's Beta-weighted pair field ⟶ positive product measure $\nu_\chi$
here, related exactly as `PRODUCT.md`/exp31 related Theorem D to $\nu$ for $\zeta$ — the
whole exp31 pipeline (interior carrier, no-fit protocol, line tables, difference-line
accounting, injection) transfers to the tower with **no structural modification**, only
$(c_1,c_0,B_\chi)$ and the string changing. New relative to both: the poleless explicit
formula T1 with its closed-form $\Gamma$-constants; the purity theorem/measurement T4
(including the $7\times10^6$ robustness factor and the $a\approx5\cdot10^{-6}$ null); the
no-Gauss-phase fingerprint; and the per-character screw⟺GRH statement T3 with the
simplicity hypothesis explicitly discharged.
