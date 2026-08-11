# The barrier program: three presentations of the arithmetic, and who can see the bulk

Companion to `HOLOGRAM.md` (Theorem K), `FAMILY.md` §2.2/2.4, sibling
`LENS_CIRCUIT.md`. Status: definitions + one structure proposition
(proof-sketch grade) + a classification supported by this corpus's measured
results; honesty ledger in §5. This note *creates* the rigorous problem it
does not yet solve.

## 1. The windowed-linear class, defined

Fix a window $[X_0,X]$, span $L=\log(X/X_0)$, degree $d$, and arity $r$.

**Definition (WL$_d(L,r)$).** An observable of arithmetic data
$a\!\restriction\![1,X]$ of the form $O(a)=\Phi(Q_1,\dots,Q_r)$, where each
$$Q_i \;=\; \sum_{n_1,\dots,n_k\le X} a(n_1)\cdots a(n_k)\,K_i(n_1,\dots,n_k),
\qquad k\le d,$$
whose kernel factors through *log-scale windows of resolution $L$ on linear
forms*: $K_i(\vec n)=g_i\bigl(\log\ell_1(\vec n),\dots\bigr)$ with each $g_i$
having log-Fourier content confined to bandwidth-$O(1)$ windows measurable
at resolution $2\pi/L$, and $\Phi$ arbitrary (even non-computable)
post-processing of the $r$ numbers. **The class treats $a$ as a black-box
sequence: only its additive presentation (values against windowed kernels
of linear forms) is accessed.**

Everything this corpus computes is WL: smoothed counts ($d=2$, kernel in
$m+n$), blocks (Ramanujan-twisted kernels), all band-passed phases, the
Fresnel readings, the twisted fields, the $k$-body fields ($d=k$).
Classical major/minor-arc circle-method quantities are WL. 

**Structure Proposition (proof-sketch grade; RH-conditional bookkeeping).**
For $a$ in the residue-dressing family, every $Q\in$WL$_d(L,\cdot)$ is a
function of (i) scheme/smooth data and (ii) the *blurred spectral measure*
$\sigma_a^{(j)}\!*\!\widehat W_L$, $j\le d$ — the $j$-fold sum-spectrum atoms
convolved with a resolution-$2\pi/L$ kernel. *Sketch:* substitute the
explicit formula for each $a$-factor (trace formulas of `FAMILY.md`, verified
rows); the kernel's windowed linear forms turn each zero product into an
atom evaluated against $\widehat W_L$; absolute convergence after one
smoothing (Theorem D-family) justifies the exchange. $\square$(sketch)

**Barrier corollary (= Theorem K restated).** A WL observable determines
correlation-grade information at height $T$ only if the blur resolves the
pair atoms: $L\gtrsim\kappa\,2\pi\rho_2(2T)$, i.e. $X\sim\exp(cT\log^2T)$.
Within WL, the depth law is not an artifact of our methods — it is the
information geometry of the class.

## 2. The three presentations, and the measured visibility table

The corpus has now probed the arithmetic through three inequivalent
presentations, and the results align exactly:

| presentation | probe class | measured face | what it sees | blind spot |
|---|---|---|---|---|
| **finite-multiplicative** (divisibility) | SIEVE$_d$ (sibling), Ramanujan/BC blocks | exp21/24 fingerprints | singular series, character sectors (one literal deep) | **parity-protected**: $\lambda,\mu$ exactly invisible (gauge no-go) |
| **additive-windowed** | WL$_d(L,r)$ (this note) | the whole phase-side corpus | the blurred spectral measure: locations cheap, layer structure, amplitudes | **bulk-blind**: correlations cost $\exp(cT\log^2T)$ (Theorem K) |
| **global-multiplicative** | functional-equation access: $a(np)=a(n)a(p)$ used as a *constraint*, not a value | Tao's entropy decrement (log-Chowla) | the one known access to Chowla-grade (bulk) content | quantitatively weak so far (logarithmic averaging only) |

The alignment is the point: **the sieve parity barrier, the Theorem-K depth
barrier, and the sum-product philosophy (`REPORT.md` §7c) are the same
three-way classification seen from three corners.** Sieves fail on parity
because finite-multiplicative probes can't see the gauge charge (proved,
sibling). WL fails on correlations because additive-windowed probes see
only the blurred spectrum (this note). And the single case where a
bulk-grade conjecture yielded — logarithmic Chowla — used precisely the
presentation the other two classes never touch: the *global* multiplicative
functional equation as a constraint propagated across scales
(entropy decrement), a nonlinear, non-windowed operation.

**Position of entropy decrement (the probe of priority-question 1).** Its
correlator $\sum\lambda(n)\lambda(n+h)/n$ is WL as a *number*; the proof is not
a WL *derivation*: the decrement step compares the empirical distribution
of $(\lambda(n+1),\dots,\lambda(n+H))$ across scales using
$\lambda(pn)=-\lambda(n)$ — accessing $a$'s functional equation, outside the
black-box-sequence interface of WL by construction. So within this
taxonomy: entropy decrement $\notin$ WL, *by the interface it consumes*.
What is missing for a theorem: a proof that no WL post-processing $\Phi$
can simulate that interface — i.e., a separation, not just a
classification. That is the barrier program's Problem 1.

## 3. The program (problems this note creates)

1. **Separation:** prove no $O\in$WL$_d(L,\mathrm{poly})$ with
   $L=o(\rho_2(2T))$ determines gap-grade statistics at height $T$ (make
   the Structure Proposition a theorem; then an information bound on
   blurred measures — DPP-grade tooling; coordinate with the auditor
   branch's `DPP_ENERGY` lane).
2. **Interface formalization:** define "multiplicative-constraint access"
   (oracle model: queries to $a$'s functional equation vs value queries)
   and re-derive entropy decrement inside it; measure its "bulk bits per
   log-scale" — is logarithmic averaging *forced* by the interface?
3. **Completeness question (the mad one):** are the three presentations
   exhaustive for "natural" methods? A fourth presentation — e.g.
   automorphic summability (the $d(n)$ row's $GL_2$ access, unavailable to
   primes) — is what the divisor field has and $\Lambda$ lacks; classify
   Kuznetsov/Voronoi access as presentation #4 and ask what its
   $\Lambda$-shadow would need to be. The Langlands-functoriality reading:
   presentations = choices of group; the bulk is what no abelian ($GL_1$)
   presentation reaches at feasible depth.

## 4. Honesty ledger

The Definition is rigorous; the Structure Proposition is a sketch whose
convergence bookkeeping is the D-family's (verified numerically, proved
only conditionally); the visibility table's first two rows are backed by
proofs/measurements in this corpus, the third by reading Tao's published
argument through this lens (no new analysis of it here); §2's separation
claim is *definitional* (interface-level), and honest about what a real
separation theorem still requires. Nothing here proves any new bound on
any arithmetic sum.

## 5. Prediction inherited

`HOLOGRAM.md` §5's span-8.5 prediction stands; a confirmed reading at
$X\sim10^8$ of the predicted new lines would be the third dataset on the
capacity curve.
