# Proof mass: the quantitative conservation law for noisy sieve derivations

Executes LENS_CHAITIN §4 item 2 (owner fleet-chaitin): turn the proof-mass
program into a theorem. Companions: `LENS_CHAITIN.md` (Lemma C1, Corollary
C2, the Chaitin dictionary), `LENS_CIRCUIT.md` (the SIEVE_d(S,Q) class and
the provable budget scales, Thms 1–2), `GAUGE.md` (Theorem F). Numerics:
`code/exp42_proofmass.py`, `data/exp42_out.txt`, `figures/exp42_proofmass.png`
(pipeline: exp41's λ sieve re-run, integer cross-checks asserted).

Honesty header. The witness pair is Selberg's (1949); the 0/1 impossibility
reading is classical (Selberg, Bombieri, Friedlander–Iwaniec Op. de Cribro
Ch. 16) and was formalized in convex-duality form by Tao (2014 blog post
"A general parity problem obstruction", modulo a Liouville-pseudorandomness
conjecture; see §6). The proof technique below — evaluate a dual certificate
at an explicitly constructed state family — is the standard lower-bound
method of LP proof complexity (pseudo-expectations / fooling distributions
for Sherali–Adams), and PM1 is a direct robust-LP/approximate-feasibility
sensitivity inequality. We therefore presume the abstract LP core known in
form. The useful contribution here is the explicit arithmetic specialization:
charges, margins, the Selberg swap path, and a reproducible finite-$X$
numerical diagnostic. No theorem-level novelty is claimed. §6 records the
remaining prior-art boundary.

---

## 1. The proof system, formalized (and why it is not circular)

Fix N and the state class
$$\mathcal K \;=\; \{\,\nu = w\,dn \text{ on } [1,N] : 0 \le w(n) \le 2\,\}$$
(LENS_CHAITIN's audit-card class). All functionals are affine:
$A(\nu) = \langle a, w\rangle = \sum_n a(n)w(n)$ for a kernel $a$.

**Definition 1.1 (noisy axiom system).** A finite family
$\mathcal A = \{(a_j, b_j, R_j)\}_{j\le J}$ of kernels $a_j$, asserted
values $b_j$, and error budgets $R_j > 0$. The *feasible set* is
$$\Phi(\mathcal A) = \{\nu \in \mathcal K :\ |A_j(\nu) - b_j| \le R_j
\ \forall j\}.$$
The system is *sound for a state* $\nu^\ast$ if $\nu^\ast \in
\Phi(\mathcal A)$ (each axiom, read as a statement about $\nu^\ast$, is
true).

**Definition 1.2 (sieve derivation, LP-dual form).** A *derivation* $D$ of
a lower bound for a target $T$ (kernel $\tau$) from $\mathcal A$ is a pair
$(c, \kappa)$, $c \in \mathbb R^J$, $\kappa \in \mathbb R$, such that the
residual functional
$$P(\nu) \;:=\; T(\nu) - \sum_j c_j A_j(\nu) - \kappa$$
is nonnegative on all of $\mathcal K$ ("sieve positivity": $P \ge 0$ must
hold for *every* state in the class, not merely feasible ones — this is
what positivity facts like Selberg's $\Lambda^2$ squares provide). The
*certified bound* is
$$\beta(D) \;:=\; \sum_j c_j b_j \;-\; \sum_j |c_j| R_j \;+\; \kappa .$$

**Lemma 1.3 (weak duality = validity).** For every $\nu \in
\Phi(\mathcal A)$: $T(\nu) \ge \beta(D)$. *Proof.* $c_j A_j(\nu) \ge c_j
b_j - |c_j| R_j$ for feasible $\nu$; add $P(\nu) \ge 0$ and $\kappa$.
$\square$

**Lemma 1.4 (completeness inside the finite box-and-slab LP).** Conversely,
if $T(\nu) \ge \beta$ holds for every $\nu \in
\Phi(\mathcal A)$ and $\Phi(\mathcal A) \neq \emptyset$, then some
derivation $D$ in the sense of 1.2 certifies $\beta(D) \ge \beta$.
*Proof.* $\Phi(\mathcal A)$ is a compact nonempty polytope ($\mathcal K$
is a box, the axioms are slabs), so LP strong duality applies to
$\min_{\nu \in \Phi} T(\nu)$; the optimal dual assigns multipliers to the
two slab faces of each axiom (their difference is $c_j$, and the sum of
their budget cost is $\ge |c_j| R_j$) and to the box faces (whose
aggregate is a functional nonnegative on $\mathcal K$, absorbed into $P$
and $\kappa$). $\square$

Thus semantic validity and existence of a dual certificate coincide **inside
this finite affine LP cone**. This is not a completeness theorem for arbitrary
sieve arguments, bilinear/Type-II estimates, nonlinear deductions, or proof
systems whose state space contains additional arithmetic constraints.
**Non-circularity:** the theorems below
never assume the exotic states are feasible; they evaluate the *identity*
of Definition 1.2 at explicit states of $\mathcal K$, using only (i)
$P \ge 0$ on $\mathcal K$, and (ii) soundness at one reference state.
Feasibility of the swap states is a *conclusion* (PM2/PM3), derived from
margins — never an assumption. The target kernel (the actual twin set) is
handed to this LP for free, but no claim is made that every real sieve proof
factors through the resulting cone.

**Charges.** Fix a charge function $\chi: [1,N] \to \{\pm 1\}$ (below:
$\chi = \lambda$ for the prime frame, $\chi = c_2$, $c_2(n) =
\lambda(n)\lambda(n+2)$, for the twin frame) and the *swap family*
$$\nu_t := (1 + t\chi)\,dn \in \mathcal K, \qquad t \in [-1, 1].$$
Per-axiom data, all finite and computable:
$$\delta_j := |\langle \chi, a_j\rangle| \ \ (\text{charge}), \qquad
e_j := |A_j(\nu_0) - b_j| \ \ (\text{reference offset}), \qquad
m_j := R_j - e_j \ \ (\text{margin}).$$
Unless explicitly stated otherwise, PM2–PM6 assume $m_j\ge0$ for every
axiom. A zero-charge axiom has $\delta_j=0$ and affects feasibility only
through this margin condition.
Target data: $\tau = 1_{\text{twin}}$ has $T(\nu_t) = (1+t)\,\pi_2(N)$
(since $c_2 = +1$ on twin $n$: $\lambda(p) = \lambda(p+2) = -1$), so the
*anti-twin state* $\nu_{-1}$ has $T = 0$ and the *twin-charged truth*
$\nu_{+1}$ has $T = 2\pi_2(N)$; symmetrically $\tau = 1_P$ has $T(\nu_t)
= (1-t)\,\pi(N)$, annihilated at $t = +1$. (exp41/exp42, exact:
$0$ vs $29742 = 2\pi_2$, $0$ vs $297866 = 2\pi$ at $N = 2\cdot 10^6$.)

---

## 2. The theorem

**Theorem PM1 (master transfer inequality).** Let $D = (c,\kappa)$ be any
derivation from $\mathcal A$ in the sense of 1.2. Then for every
$t \in [-1, 1]$:
$$\beta(D) \;\le\; T(\nu_t) \;+\; \sum_j |c_j|\,\bigl(|t|\,\delta_j -
m_j\bigr)^{+} .$$

*Proof.* By Definition 1.2, evaluated at $\nu_t \in \mathcal K$:
$$\beta(D) - T(\nu_t) = \sum_j\bigl[c_j(b_j - A_j(\nu_t)) - |c_j|R_j\bigr]
- P(\nu_t) - 0
\;\le\; \sum_j |c_j|\bigl(|A_j(\nu_t) - b_j| - R_j\bigr)^{+},$$
using $P(\nu_t) \ge 0$ ($\nu_t \in \mathcal K$ because $|\chi| = 1$) and
$c_j(b_j - A_j) \le |c_j||A_j - b_j|$. Since $A_j(\nu_t) = A_j(\nu_0) +
t\langle\chi, a_j\rangle$,
$|A_j(\nu_t) - b_j| \le e_j + |t|\delta_j$, so each violation term is
$\le (e_j + |t|\delta_j - R_j)^+ = (|t|\delta_j - m_j)^+$. $\square$

Everything else is a corollary. Fix the twin frame ($\chi = c_2$,
$t \to -1$ kills the target); the prime frame is identical with signs
flipped.

**Corollary PM2 (noisy dichotomy; quantitative C1/C2).** If every axiom's
charge is at most its margin ($\delta_j \le m_j$ for all $j$), then
$\beta(D) \le T(\nu_{-1}) = 0$ for **every** derivation $D$, of arbitrary
dual mass. No positive derivation from such a family certifies a single
twin (resp. prime). *Proof.* PM1 at $t = -1$: every $(\ )^+$ vanishes.
$\square$

**Corollary PM3 (feasibility interpolation — the quantitative tradeoff).**
Assume all margins are nonnegative and set
$$t^\ast := \min_{j:\delta_j>0}\frac{m_j}{\delta_j},$$
with $t^\ast=+\infty$ when every $\delta_j=0$. This is the largest radius
$r\ge0$ for which the whole centered interval $\{\nu_t:|t|\le r\}$ is
feasible: for each axiom,
$$\max_{|t|\le r}|A_j(\nu_t)-b_j|=e_j+r\delta_j.$$
It need not be the largest feasible displacement in the single
target-killing direction, where offset/slope cancellation may help. Then
$$\beta(D) \;\le\; \bigl(1 - \min(1, t^\ast)\bigr)^{+}\,\pi_2(N).$$
In particular the certifiable bound degrades linearly in the feasible
swap radius: to certify a positive proportion $\beta = \eta\,\pi_2$ the
family must pin $t^\ast \le 1 - \eta$, i.e. some axiom must carry charge
within factor $(1-\eta)^{-1}$ of its own margin. *Proof.* PM1 at
$t = -\min(1, t^\ast)$, all violations zero; $T(\nu_{-t}) = (1-t)\pi_2$.
$\square$

**Corollary PM4 (charge-weighted mass).** Define $N(D) := \sum_j |c_j|
\delta_j$. If all margins are nonnegative ($e_j \le R_j$: the axioms do
not contradict the reference), then $N(D) \ge \beta(D)$. If instead only
soundness at the charged truth $\nu_{+1}$ is assumed (arbitrary, even
adversarially charged, centerings $b_j$), then $N(D) \ge \beta(D)/2$.
*Proof.* PM1 at $t = -1$ with $(\delta_j - m_j)^+ \le \delta_j$ in the
first case; in the second, $e_j \le |A_j(\nu_{+1}) - b_j| + \delta_j \le
R_j + \delta_j$, so $(\delta_j - m_j)^+ \le 2\delta_j$. $\square$

**Corollary PM5 (budget-weighted mass — the proof-mass bound).** Define
the dual mass $M(D) := \sum_j |c_j| R_j$ (coefficients times error
budgets, the LENS_CHAITIN §4.2 bookkeeping). Assume margins $\ge 0$ and
$\beta(D)>0$, and put
$$J_c^+ := \{j\in\operatorname{supp}(c):\delta_j>0\}.$$
By PM4, $J_c^+$ is then nonempty. With all minima below restricted to
$J_c^+$ (equivalently, with $R_j/0:=+\infty$),
$$M(D) \;\ge\; \beta(D) \cdot \min_{j \in J_c^+}
\frac{R_j}{\delta_j}
\;=\; \frac{\beta(D)}{\gamma(D)}, \qquad
\gamma(D) := \max_{j \in J_c^+} \frac{\delta_j}{R_j},$$
i.e. **(proof mass) × (charge concentration) ≥ (certified bound)**:
$M(D)\,\gamma(D) \ge \beta(D)$. *Proof.* $M(D) \ge
\min_{j\in J_c^+} (R_j/\delta_j)
\cdot \sum_j |c_j|\delta_j \ge
\min_{j\in J_c^+}(R_j/\delta_j)\,\beta(D)$ by PM4.
$\square$

**Theorem PM6 (conditional exchange-rate reparameterization).**
Suppose each axiom kernel is an AP indicator $a_{q,a} = 1_{n \equiv a
(q)}$ with $3 \le q \le N^\theta$, $b_{q,a} = N/q$, and each budget is a
sharpening $R_j = F_j / \Gamma_j$, $\Gamma_j \ge 1$, of an explicitly
chosen certified baseline $F_j$; "best currently provable" is not part of
the mathematics. Assume all margins are nonnegative and $\beta(D)>0$.
Let $\Gamma(D) := \max_{j\in\mathrm{supp}(c)} \Gamma_j$ (the oracle
factor; $\Gamma = 1$ when the selected budgets themselves are certified).
Then, restricting the minimum to $J_c^+$,
$$M(D)\cdot \Gamma(D) \;\ge\; \beta(D)\cdot
\min_{j\in J_c^+}\frac{F_j}{\delta_j}.$$
If moreover the charges are square-root flat, $\delta_{q,a} \le
\kappa\sqrt{N/q}$ (measured: $\kappa \le 4.9$ for $c_2$, $\kappa \le 5.8$
for $\lambda$, all $q \le \sqrt N$ at $N = 2\cdot 10^6$; hypothesis
CH$_\theta$ asymptotically, §5), and $F_{q,a} \ge (N/q)(\log N)^{-A_0}$,
then
$$M(D)\cdot \Gamma(D) \;\ge\; \beta(D)\cdot
\frac{N^{(1-\theta)/2}}{\kappa\,(\log N)^{A_0}} .$$
*Proof.* $M\Gamma \ge \sum_j |c_j| R_j \Gamma_j = \sum_j |c_j| F_j \ge
\min_{j\in J_c^+} (F_j/\delta_j)\, N(D) \ge
\min_{j\in J_c^+}(F_j/\delta_j)\,\beta(D)$ (PM4);
then $F_j/\delta_j \ge (N/q)(\log N)^{-A_0} / (\kappa\sqrt{N/q}) =
\sqrt{N/q}\,(\log N)^{-A_0}/\kappa \ge N^{(1-\theta)/2}(\log
N)^{-A_0}/\kappa$. $\square$

**Conditional reading.** Under CH$_\theta$ and the stated baseline lower
bound, $\theta = 1/2 - \varepsilon$ gives
$M(D)\Gamma(D)\ge\beta(D)N^{1/4+\varepsilon/2-o(1)}$ **inside this affine
LP cone**. For $\beta=1$ this is a conditional polynomial exchange rate.
For $\beta=\eta\pi_2(N)$ the theorem gives only
$$\eta\pi_2(N)N^{1/4+\varepsilon/2-o(1)};$$
calling this $N^{5/4+\varepsilon/2-o(1)}$ additionally assumes
$\pi_2(N)=N^{1-o(1)}$, which is not known. Type-II or bilinear information
does not belong to the present cone; translating its kernels, budgets, and
charges is an open successor problem rather than a consequence of PM6.

---

## 3. Explicit baseline choices

PM6 accepts any explicitly certified baseline $F_j$; it neither defines nor
detects a canonical "best currently provable" bound.

- **Twin frame ($\chi = c_2$):** the axiom $|A_{q,a}(\nu) - N/q| \le R$
  must hold for the twin-charged truth $\nu_{+1} = (1+c_2)dn$, whose AP
  discrepancy *is* the pair-correlation discrepancy $\sum_{n \equiv a(q)}
  \lambda(n)\lambda(n+2)$. No unconditional bound below the trivial
  $F_{q,a} = N/q + O(1)$ is known for this quantity at general $q \le
  N^\theta$ (even the global $q = 1$ case is known only log-averaged:
  Tao's 2016 two-point Chowla; nothing individual at the
  $(N/q)(\log N)^{-A}$ scale, let alone square-root). Around the center
  $b=N/q$, the box $0\le w\le2$ gives the safe uniform endpoint-aware
  baseline $F_{q,a}=N/q+2$, since a residue class contains at most
  $N/q+1$ integers. The asymptotic $N/q+O(1)$ notation suppresses this
  endpoint term. Combining it with CH$_\theta$ would give PM6's polynomial
  rate; CH$_\theta$ itself remains unproved for $c_2$.
- **Prime frame ($\chi = \lambda$):** BV$_\lambda$ (LENS_CIRCUIT §3,
  Lemma 3.1) proves $F_{q,a} = (N/q)(\log N)^{-A}$ *on average over
  $q \le N^{1/2}(\log N)^{-B}$, individually off a circuit-independent
  bad set*; Siegel–Walfisz gives it for $q \le (\log N)^{A'}$
  individually. So $A_0 = A$ baselines are available (with the bad-set and
  ineffectivity caveats exactly as in LENS_CIRCUIT), and PM6 loses only
  the stated polylog.

Under the additional square-root-flatness hypothesis, these baselines sit
above the charges by the displayed exchange-rate factor. This is a statement
about the chosen affine cone, not a lower bound on unrestricted proofs.

---

## 4. Numerical instantiation at N = 2·10⁶ (exp42)

Pipeline: exp41's factor-count λ sieve re-run; asserted **exact integer**
cross-checks $\sum\lambda = -1234$, $2\pi = 297866$, $2\pi_2 = 29742$,
and the swap identities $\sum_{\text{twin}}(1 - c_2) = 0$,
$\sum_{\text{twin}}(1 + c_2) = 2\pi_2$. Ratios involving $N/q$ or
$\log N$, minima, and $\kappa$ are float64 diagnostics, not an exact
rational certificate. Family: all $(q,a)$ with
$3\le q\le\lfloor N^\theta\rfloor$; selected experimental budgets
$R_q=(N/q)(\log N)^{-A}$. The $A=0$ choice is observed to contain both
charged endpoints here; it is not the universal box baseline $N/q+2$.

| frame | θ | Q | A | $t^\ast$ | $\min_j R_j/\delta_j$ | κ | certifiable β (PM2/PM3) |
|---|---|---|---|---|---|---|---|
| twin | 0.45 | 684 | 0 | **12.32** | **12.33** | 4.62 | **≤ 0** |
| twin | 0.50 | 1414 | 0 | 8.04 | 8.04 | 4.91 | ≤ 0 |
| twin | 0.45 | 684 | 1 | 0.848 | 0.850 | 4.62 | ≤ 2267 = 0.152·π₂ |
| twin | 0.50 | 1414 | 1 | 0.554 | 0.554 | 4.91 | ≤ 6633 |
| twin | 0.45 | 684 | 2 | 0.057 | 0.059 | 4.62 | ≤ 14030 |
| prime | 0.45 | 684 | 0 | 11.84 | 11.84 | 4.68 | ≤ 0 |
| prime | 0.50 | 1414 | 1 | 0.481 | 0.483 | 5.73 | ≤ 77262 |

(Full 18-cell table in `data/exp42_out.txt`; $t^\ast$ is the largest
centered symmetric feasible radius $\min_j m_j/\delta_j$, κ the measured flatness constant
$\max \delta_{q,a}/\sqrt{N/q}$.)

Headline numbers (twin frame, $\theta = 0.45 = 1/2 - \varepsilon$,
selected centered budget $R_q=N/q$):

- **Symmetric feasible radius: $t^\ast = 12.32$** (worst axiom $q = 665$). Both
  $\nu_{\pm 1}$ satisfy every noisy axiom with **12× slack**: PM2 applies
  and $\beta \le 0$ — no positive derivation in this level-$N^{0.45}$
  finite affine AP cone certifies a positive twin lower bound at
  $N=2\cdot10^6$.
- **Exchange rate: $\min_j R_j / \delta_j = 12.33$**, so any
  oracle-sharpened derivation obeys $M(D)\,\Gamma(D) \ge 12.33\,
  \beta(D)$; at separation-scale certification $\beta = \pi_2/2$:
  $M\Gamma \ge 9.2\cdot 10^4$.
- **Finite-size honesty:** at $A = 1$ (BV-scale budgets) and $\theta$
  near $1/2$ the polylog still dominates $N^{(1-\theta)/2}$ at $N =
  2\cdot 10^6$ ($N^{1/4} = 37.6$ vs $\log N \cdot \kappa \approx 71$),
  so the largest moduli formally cross the C2 threshold: $t^\ast =
  0.55$–$0.85 < 1$. PM2 then does *not* apply, and the honest statement
  is PM3's cap ($\beta \le 0.15\,\pi_2$ at $\theta = 0.45$) plus PM5's
  mass bound ($M \ge 0.85\,\beta$). The asymptotic regime
  $N^{(1-\theta)/2} \gg (\log N)^A$ sets in around $N \sim 10^9$
  ($\theta = 0.45$, $A = 1$); projections: exchange rate $\approx 65$ at
  $N = 10^9$, $\approx 430$ at $N = 10^{12}$ ($\theta = 0.45$, $A = 0$,
  κ frozen at its measured value). These are projections under
  CH$_\theta$, not unconditional estimates.
- Figure `figures/exp42_proofmass.png`: measured charge band
  $\delta_{q,a}/\sqrt{N/q} \in [\sim 1, 4.9]$ (square-root flat across
  three decades of $q$) against the three budget curves; threshold
  crossings visible exactly where the $A \ge 1$ curves dip into the band.

---

## 5. Rigor boundary

- **PM1–PM5 are exact finite LP theorems** — five inequalities on a finite
  box polytope; every step is displayed. No asymptotics, no conjecture.
  They hold for *any* affine axiom family (not only AP counts; kernels
  built from AP indicators — Selberg forms, smooth sums — inherit charge
  bounds by linearity).
- **PM6's first inequality is exact** under its margin and positive-$\beta$
  hypotheses; its second (the polynomial exchange rate) uses two inputs:
  the certified baseline scale $F_{q,a}$ (§3 — trivial baseline:
  unconditional with its endpoint term; BV baseline: LENS_CIRCUIT's provenance,
  ineffective, average/bad-set caveats) and the flatness hypothesis
  CH$_\theta$: $\delta_{q,a} \le \kappa(N)\sqrt{N/q}$ with $\kappa(N) =
  N^{o(1)}$. CH$_\theta$ is *measured* here (κ ≤ 4.9 across the full
  family at $N = 2\cdot 10^6$; exp41 concurs at seven spot moduli), is a
  strong Chowla-in-APs statement for $c_2$ (unproven; GRH does not imply
  it), and for $\lambda$ follows from GRH only in the weaker per-modulus
  form $\delta \le N^{1/2+\varepsilon}$, which still yields a polynomial
  rate $N^{1/2-\theta-\varepsilon}$ for fixed $\theta < 1/2$ — degrading
  to nothing as $\theta \to 1/2$. Thus the algebraic theorem is exact,
  while exp42 is a numerical finite-$X$ diagnostic with exact integer
  target checks. The asymptotic exponent $(1-\theta)/2$ is conditional on
  CH$_\theta$; under GRH the prime frame has only the weaker conditional
  exponent $1/2-\theta-\varepsilon$.
- The theorems bound derivations *from the stated axiom family over the
  stated state class*. They do not bound proofs that use genuinely
  different observables (bilinear/Type-II axioms have their own charges
  — computing them is the successor question, R0007's seed 2), and the
  class $0 \le w \le 2$ is the audit-card normalization. The class
  choice cuts the right way: enlarging $\mathcal K$ strengthens the
  positivity requirement on $P$ and so shrinks the set of valid
  derivations — the bounds only get stronger; shrinking $\mathcal K$
  below the swap family would break PM1, and a certified constraint
  excluding part of $\{\nu_t\}$ is exactly what a parity-breaking
  ingredient is.
- exp42 uses exactly representable integer-sized $\pm1$ sums at this scale,
  but $N/q$, logarithmic budgets, ratios, minima, and κ are float64. The
  large $A=0$ slack is numerically robust; no interval-arithmetic certificate
  is claimed.

## 6. Prior-art boundary (recorded search, 2026-08-11)

Searched: parity problem + linear programming/duality (Tao's blog, both
parity-obstruction posts located), Selberg's optimization framing
(Lectures on sieves, Collected Papers II, 1991 — the sieve problem as an
extremal/LP problem is classical there; sifting-limit literature),
extremal examples $B^\pm = \{n : \lambda(n) = \pm 1\}$ (standard, e.g.
Ford's 2023 sieve notes; Maynard's ICM survey), Polymath8b dual/
variational formalism (eigenvalue optimization within the Selberg cone;
EH-optimality capped by parity), LP proof complexity (Sherali–Adams
pseudo-expectation lower bounds; recent bounded-coefficient SA size
bounds).

Verdict:
- **Known in form:** the two-weight witness and the impossibility reading
  (Selberg 1949; Bombieri; FI Ch. 16). Known and closest: **Tao 2014,
  "A general parity problem obstruction"** — an abstract convex-duality
  formalization of "no sieve-theoretic proof", via Hahn–Banach on
  forbidden sign patterns, *conditional on a Liouville-pseudorandomness
  conjecture*, and purely a possible/impossible dichotomy (our PM2 is
  its noisy finite-X analog, made unconditional at each finite X by
  computing the charges). Known technique: dual-certificate-vs-fooling-
  distribution lower bounds in LP proof complexity (Sherali–Adams
  literature). PM1 and its $|c_j|R_j$ penalties are standard robust-LP,
  approximate-Farkas, and dual-sensitivity machinery in form.
- **Arithmetic specialization only:** the particular charge/margin ledger,
  Selberg swap path, and exp42 diagnostic were not located verbatim. This is
  a useful synthesis, not a novelty claim. A serious novelty audit would need
  robust optimization, Hoffman error bounds, approximate Farkas lemmas, and
  Sherali–Adams pseudoexpectation literature in addition to sieve sources.

## References

- A. Selberg, Collected Papers II (Lectures on sieves), Springer 1991.
- J. Friedlander, H. Iwaniec, Opera de Cribro, AMS Colloq. 57, Ch. 16.
- T. Tao, "A general parity problem obstruction", blog post, Nov 2014
  (terrytao.wordpress.com/2014/11/21/); "Open question: the parity
  problem in sieve theory", Jun 2007.
- T. Tao, "The logarithmically averaged Chowla and Elliott conjectures
  for two-point correlations", Forum Math. Pi 4 (2016).
- Polymath8b: "Variants of the Selberg sieve, and bounded intervals
  containing many primes", Res. Math. Sci. 1 (2014).
- LP proof complexity: e.g. "Clique is hard on average for Sherali–Adams
  with bounded coefficients" (arXiv:2404.16722) and references there.
- In-corpus: LENS_CHAITIN.md (C1/C2), LENS_CIRCUIT.md (Thms 1–2, Lemma
  3.1, baselines), GAUGE.md, exp41/exp42.
