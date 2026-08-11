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
for Sherali–Adams). What we claim as new is the assembly: the *noisy-axiom*
formalization with per-axiom error budgets, the master transfer inequality
PM1 and its continuous feasibility/mass tradeoff (PM3–PM5), the
budget-vs-charge exchange-rate bookkeeping PM6 ("proof mass × oracle
sharpness ≥ polynomial"), and the fully unconditional finite-X
instantiation (§4: at X = 2·10⁶ every quantity is a computed integer
identity, no pseudorandomness conjecture). §6 records the search.

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

**Lemma 1.4 (completeness — the frame captures all positive linear
reasoning).** Conversely, if $T(\nu) \ge \beta$ holds for every $\nu \in
\Phi(\mathcal A)$ and $\Phi(\mathcal A) \neq \emptyset$, then some
derivation $D$ in the sense of 1.2 certifies $\beta(D) \ge \beta$.
*Proof.* $\Phi(\mathcal A)$ is a compact nonempty polytope ($\mathcal K$
is a box, the axioms are slabs), so LP strong duality applies to
$\min_{\nu \in \Phi} T(\nu)$; the optimal dual assigns multipliers to the
two slab faces of each axiom (their difference is $c_j$, and the sum of
their budget cost is $\ge |c_j| R_j$) and to the box faces (whose
aggregate is a functional nonnegative on $\mathcal K$, absorbed into $P$
and $\kappa$). $\square$

So "a sieve proof certifies $\beta$" and "$\beta(D) \ge \beta$ for some
dual certificate $D$" coincide. **Non-circularity:** the theorems below
never assume the exotic states are feasible; they evaluate the *identity*
of Definition 1.2 at explicit states of $\mathcal K$, using only (i)
$P \ge 0$ on $\mathcal K$, and (ii) soundness at one reference state.
Feasibility of the swap states is a *conclusion* (PM2/PM3), derived from
computed margins — never an assumption. The frame is moreover *generous*
to the prover: the target kernel (the actual twin set) is handed to the
derivation for free; any real sieve proof, which knows less, factors
through this frame, so lower bounds here apply a fortiori.

**Charges.** Fix a charge function $\chi: [1,N] \to \{\pm 1\}$ (below:
$\chi = \lambda$ for the prime frame, $\chi = c_2$, $c_2(n) =
\lambda(n)\lambda(n+2)$, for the twin frame) and the *swap family*
$$\nu_t := (1 + t\chi)\,dn \in \mathcal K, \qquad t \in [-1, 1].$$
Per-axiom data, all finite and computable:
$$\delta_j := |\langle \chi, a_j\rangle| \ \ (\text{charge}), \qquad
e_j := |A_j(\nu_0) - b_j| \ \ (\text{reference offset}), \qquad
m_j := R_j - e_j \ \ (\text{margin}).$$
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
Let $t^\ast := \min_{j\,:\,\delta_j > 0}\, m_j / \delta_j$ (the largest
$|t|$ for which $\nu_t$ satisfies every noisy axiom). Then
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
budgets, the LENS_CHAITIN §4.2 bookkeeping). Then, with margins $\ge 0$,
$$M(D) \;\ge\; \beta(D) \cdot \min_{j \in \mathrm{supp}(c)}
\frac{R_j}{\delta_j}
\;=\; \frac{\beta(D)}{\gamma(D)}, \qquad
\gamma(D) := \max_{j \in \mathrm{supp}(c)} \frac{\delta_j}{R_j},$$
i.e. **(proof mass) × (charge concentration) ≥ (certified bound)**:
$M(D)\,\gamma(D) \ge \beta(D)$. *Proof.* $M(D) \ge \min_j (R_j/\delta_j)
\cdot \sum_j |c_j|\delta_j \ge \min_j(R_j/\delta_j)\,\beta(D)$ by PM4.
$\square$

**Theorem PM6 (exchange rate: mass × oracle sharpness ≥ polynomial).**
Suppose each axiom kernel is an AP indicator $a_{q,a} = 1_{n \equiv a
(q)}$ with $3 \le q \le N^\theta$, $b_{q,a} = N/q$, and each budget is a
sharpening $R_j = F_j / \Gamma_j$, $\Gamma_j \ge 1$, of a *floor* $F_j$
(the best bound provable for that axiom by current theorems; see §3).
Let $\Gamma(D) := \max_{j\in\mathrm{supp}(c)} \Gamma_j$ (the oracle
factor; $\Gamma = 1$ for a fully unconditional derivation). Then
$$M(D)\cdot \Gamma(D) \;\ge\; \beta(D)\cdot \min_{j}\frac{F_j}{\delta_j}.$$
If moreover the charges are square-root flat, $\delta_{q,a} \le
\kappa\sqrt{N/q}$ (measured: $\kappa \le 4.9$ for $c_2$, $\kappa \le 5.8$
for $\lambda$, all $q \le \sqrt N$ at $N = 2\cdot 10^6$; hypothesis
CH$_\theta$ asymptotically, §5), and $F_{q,a} \ge (N/q)(\log N)^{-A_0}$,
then
$$M(D)\cdot \Gamma(D) \;\ge\; \beta(D)\cdot
\frac{N^{(1-\theta)/2}}{\kappa\,(\log N)^{A_0}} .$$
*Proof.* $M\Gamma \ge \sum_j |c_j| R_j \Gamma_j = \sum_j |c_j| F_j \ge
\min_j (F_j/\delta_j)\, N(D) \ge \min_j(F_j/\delta_j)\,\beta(D)$ (PM4);
then $F_j/\delta_j \ge (N/q)(\log N)^{-A_0} / (\kappa\sqrt{N/q}) =
\sqrt{N/q}\,(\log N)^{-A_0}/\kappa \ge N^{(1-\theta)/2}(\log
N)^{-A_0}/\kappa$. $\square$

**Reading.** At $\theta = 1/2 - \varepsilon$ the right side is
$\beta \cdot N^{1/4 + \varepsilon/2 - o(1)}$: *certifying even one twin
($\beta = 1$) costs proof-mass-times-sharpness polynomial in $N$; a
positive-proportion certification $\beta = \eta\pi_2(N)$ costs
$N^{5/4 + \varepsilon/2 - o(1)}$.* A derivation can be light only by
being sharp: to spend mass below $N^{(1-\theta)/2-o(1)}$ it must include
an axiom sharpened polynomially below anything provable — an adjoined
charged axiom in the sense of Corollary C2, i.e. exactly a
"reflection-axiom" purchase (Type-II information). This is the
Chaitin-quantitative statement promised in LENS_CHAITIN §4.2: short
(light) proofs cannot certify charged conclusions; the deficit is priced
in budget units. Note the two regimes are *both* theorems and coexist:
for fully unconditional families ($\Gamma = 1$, budgets at floors) PM2
already gives the endpoint $\beta \le 0$ — mass bounds are then vacuously
infinite; PM6's content is the *continuous pricing of the oracle regime*
between "provable today" and "the full charged truth", which the 0/1
dichotomy cannot see. (The back-of-envelope $M \gtrsim
2\pi_2/N^{1/2+\varepsilon}$ of LENS_CHAITIN §4.2 is superseded by this
bookkeeping: it conflated charge-weighted and budget-weighted mass; the
correct exchange rate is $\min_j F_j/\delta_j \asymp N^{(1-\theta)/2}$,
applied to whichever $\beta$-scale is being certified.)

---

## 3. What the floors are (the provability input)

PM6 needs, for each axiom, the best budget provable by current theorems.

- **Twin frame ($\chi = c_2$):** the axiom $|A_{q,a}(\nu) - N/q| \le R$
  must hold for the twin-charged truth $\nu_{+1} = (1+c_2)dn$, whose AP
  discrepancy *is* the pair-correlation discrepancy $\sum_{n \equiv a(q)}
  \lambda(n)\lambda(n+2)$. No unconditional bound below the trivial
  $F_{q,a} = N/q + O(1)$ is known for this quantity at general $q \le
  N^\theta$ (even the global $q = 1$ case is known only log-averaged:
  Tao's 2016 two-point Chowla; nothing individual at the
  $(N/q)(\log N)^{-A}$ scale, let alone square-root). So the honest floor
  is trivial, $A_0 = 0$, and PM6 reads $M\Gamma \ge \beta\,
  N^{(1-\theta)/2}/\kappa$ outright.
- **Prime frame ($\chi = \lambda$):** BV$_\lambda$ (LENS_CIRCUIT §3,
  Lemma 3.1) proves $F_{q,a} = (N/q)(\log N)^{-A}$ *on average over
  $q \le N^{1/2}(\log N)^{-B}$, individually off a circuit-independent
  bad set*; Siegel–Walfisz gives it for $q \le (\log N)^{A'}$
  individually. So $A_0 = A$ floors are available (with the bad-set and
  ineffectivity caveats exactly as in LENS_CIRCUIT), and PM6 loses only
  the stated polylog.

Both floors sit *polynomially above* the actual charges
$\delta_{q,a} \approx \kappa\sqrt{N/q}$ — that gap is the exchange rate,
and the reason proofs are heavy. A hypothetical theorem lowering a floor
to the charge scale would simultaneously (i) trivialize the mass bound
and (ii) be a parity-breaking equidistribution statement (it would pin
pair-correlations at square-root accuracy) — the two faces of C2's
threshold.

---

## 4. Instantiation at N = 2·10⁶ (exp42; all quantities computed exactly)

Pipeline: exp41's factor-count λ sieve re-run; asserted integer
cross-checks $\sum\lambda = -1234$, $2\pi = 297866$, $2\pi_2 = 29742$,
and the swap identities $\sum_{\text{twin}}(1 - c_2) = 0$,
$\sum_{\text{twin}}(1 + c_2) = 2\pi_2$. Family: all $(q, a)$ with $3 \le
q \le N^\theta$; budgets $R_q = (N/q)(\log N)^{-A}$.

| frame | θ | Q | A | $t^\ast$ | $\min_j R_j/\delta_j$ | κ | certifiable β (PM2/PM3) |
|---|---|---|---|---|---|---|---|
| twin | 0.45 | 685 | 0 | **12.32** | **12.33** | 4.62 | **≤ 0** |
| twin | 0.50 | 1414 | 0 | 8.04 | 8.04 | 4.91 | ≤ 0 |
| twin | 0.45 | 685 | 1 | 0.848 | 0.850 | 4.62 | ≤ 2267 = 0.152·π₂ |
| twin | 0.50 | 1414 | 1 | 0.554 | 0.554 | 4.91 | ≤ 6633 |
| twin | 0.45 | 685 | 2 | 0.057 | 0.059 | 4.62 | ≤ 14030 |
| prime | 0.45 | 685 | 0 | 11.84 | 11.84 | 4.68 | ≤ 0 |
| prime | 0.50 | 1414 | 1 | 0.481 | 0.483 | 5.73 | ≤ 77262 |

(Full 18-cell table in `data/exp42_out.txt`; $t^\ast$ is the max feasible
swap radius $\min_j m_j/\delta_j$, κ the measured flatness constant
$\max \delta_{q,a}/\sqrt{N/q}$.)

Headline numbers (twin frame, $\theta = 0.45 = 1/2 - \varepsilon$,
trivial floors — the only provable ones for pair-charged states):

- **Max feasible swap: $t^\ast = 12.32$** (worst axiom $q = 665$). Both
  $\nu_{\pm 1}$ satisfy every noisy axiom with **12× slack**: PM2 applies
  and $\beta \le 0$ — no positive derivation from the level-$N^{0.45}$
  AP family certifies even one twin pair at $N = 2\cdot 10^6$, at any
  dual mass.
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
  κ frozen at its measured value).
- Figure `figures/exp42_proofmass.png`: measured charge band
  $\delta_{q,a}/\sqrt{N/q} \in [\sim 1, 4.9]$ (square-root flat across
  three decades of $q$) against the three budget curves; threshold
  crossings visible exactly where the $A \ge 1$ curves dip into the band.

---

## 5. Rigor boundary

- **PM1–PM5 are exact finite theorems** — five inequalities on a finite
  box polytope; every step is displayed. No asymptotics, no conjecture.
  They hold for *any* affine axiom family (not only AP counts; kernels
  built from AP indicators — Selberg forms, smooth sums — inherit charge
  bounds by linearity).
- **PM6's first inequality is exact**; its second (the polynomial
  exchange rate) uses two inputs: the floor scale $F_{q,a}$ (§3 —
  trivial floor: unconditional; BV floor: LENS_CIRCUIT's provenance,
  ineffective, average/bad-set caveats) and the flatness hypothesis
  CH$_\theta$: $\delta_{q,a} \le \kappa(N)\sqrt{N/q}$ with $\kappa(N) =
  N^{o(1)}$. CH$_\theta$ is *measured* here (κ ≤ 4.9 across the full
  family at $N = 2\cdot 10^6$; exp41 concurs at seven spot moduli), is a
  strong Chowla-in-APs statement for $c_2$ (unproven; GRH does not imply
  it), and for $\lambda$ follows from GRH only in the weaker per-modulus
  form $\delta \le N^{1/2+\varepsilon}$, which still yields a polynomial
  rate $N^{1/2-\theta-\varepsilon}$ for fixed $\theta < 1/2$ — degrading
  to nothing as $\theta \to 1/2$. So: **at finite X the instantiation is
  unconditional and exact; the asymptotic exponent $(1-\theta)/2$ is
  conditional on CH$_\theta$, and an unconditional (weaker) exponent
  $1/2 - \theta - \varepsilon$ holds for the prime frame under GRH.**
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
- $t^\ast$, exchange rates, κ: exact integer/rational arithmetic up to
  float summation of ±1 arrays (error $\le 2^{-52} N$, irrelevant at
  these magnitudes).

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
- **Known:** the two-weight witness and the impossibility reading
  (Selberg 1949; Bombieri; FI Ch. 16). Known and closest: **Tao 2014,
  "A general parity problem obstruction"** — an abstract convex-duality
  formalization of "no sieve-theoretic proof", via Hahn–Banach on
  forbidden sign patterns, *conditional on a Liouville-pseudorandomness
  conjecture*, and purely a possible/impossible dichotomy (our PM2 is
  its noisy finite-X analog, made unconditional at each finite X by
  computing the charges). Known technique: dual-certificate-vs-fooling-
  distribution lower bounds in LP proof complexity (Sherali–Adams
  literature).
- **Not found:** per-axiom error budgets with margins; the master
  transfer inequality; the feasibility interpolation $t^\ast$ and the
  linear degradation $\beta \le (1 - t^\ast)\pi_2$; dual-mass lower
  bounds $M \gamma \ge \beta$, $M\Gamma \ge \beta \cdot N^{(1-\theta)/2
  - o(1)}$ for sieve derivations; any "proof mass × oracle sharpness"
  conservation statement; any finite-X unconditional instantiation.
  Novelty claim for these: **possibly-new** (searched-not-found;
  external expert review required — the sieve-LP literature is large and
  the SA-transport may exist in unpublished form).

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
  3.1, floors), GAUGE.md, exp41/exp42.
