# Two walls, one problem: the CRT positive-cone boundary (D0026 §5.6) and the repo's incomplete bilinear wall, formally compared

**Task:** `notes/D0026_BUILD_QUEUE.md` Q4 (SEARCH). Author: build worker
(Hua Luogeng persona), 2026-08-16. **Status: PENDING HOSTILE AUDIT.**

**Sources read in full for this note.** Upstream:
`collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`
§§5.3, 5.6, 5.7, 5.11, 5.12, §12 (corrections), §13. Repo:
`notes/CARRIER_JOIN.md`, `notes/E2_PROOF.md`, `notes/MERTENS_FLOOR.md`,
`notes/BAND.md`, `notes/BEYOND.md`, `notes/DPP.md`, `notes/METHOD.md` §1,
`notes/DIVISOR_HAHN_INCIDENCE.md` §5, `notes/DIVISOR.md`, `notes/REPORT.md`
§7(a), `notes/FF_PAIRFIELD.md` §4, `notes/CROSS_LENS.md` §8,
`notes/POSITIVITY_HAS_A_PLACE.md`, `notes/L3_SDP.md`, `notes/LEVER3.md` (via
`notes/BEYOND.md` L3 block), `notes/CENTERING_ATOMS.md`.

**Rules of engagement.** Everything in §2 is derived on the page or cited to a
proof in this corpus; §3 is a FORECAST with probabilities and is labelled so;
§4–§5 import proved repo constraints into the upstream frontier and are
scope-fenced item by item. D0026's epistemic marks are never upgraded. No
numerics anywhere. Nothing existing is edited or struck.

---

## 0. The one-sentence finding

The two corpora carved the same wall from opposite sides, and the coincidence
is not an analogy: **the repo's Hypothesis-U bilinear form is exactly D0026's
CRT boundary operator $\Delta$ (§5.6) applied to the truncated Ramanujan
kernel $A_d$, on the diagonal slice (shift) $=-$(interval length), with the
same CRT residue and the same inverse-residue phases** (Propositions T1–T2,
derived below); and **the live range of Hypothesis U is precisely the range in
which the truncated kernel reaches D0026's balanced critical block
$[d,e]\gtrsim n$, $d,e\asymp\sqrt n$** (Proposition T3). What does *not*
coincide — kernel class (truncated $A_d$ vs untruncated charge kernels
$\kappa_r$), cutoff class (sharp fiber vs smoothed test), and quantifier
structure (free shift $h$ and free $X$ vs the tied slice) — is exactly the
distance between an exponential-sum problem with no parity obstruction (the
repo's) and the twin-prime problem itself (theirs, at $r=t=1$ untruncated).
Verdict in §3: **incomparable-with-shared-core**, core named exactly.

---

## 1. The two residual obligations, each in its own coordinates

### 1.1 D0026's wall (their coordinates, their marks)

For fixed charges $r,t$ and shift $h$, D0026 §5.6 defines
$C_{r,t}(X;h)=\sum_{n\le X}\mathbf 1_{\Omega(n)=r}\mathbf 1_{\Omega(n+h)=t}$
and, expanding through the fixed-charge divisor kernels
$q_r=1*\kappa_r$ (§5.4; $\kappa_1(d)=\sum_{p\mid d}\mu(d/p)$, sparse,
Möbius-coherent, **not multiplicative**), obtains the exact decomposition
(their box, mark ⊢):

$$C_{r,t}(X;h)=X\!\!\sum_{(d,e)\mid h}\frac{\kappa_r(d)\kappa_t(e)}{[d,e]}
\;+\;\Delta_{r,t}(X;h),\qquad
\Delta_{r,t}(X;h)=\!\!\sum_{(d,e)\mid h}\!\kappa_r(d)\kappa_t(e)\,
B_X(a(d,e;h),[d,e]),$$

where the congruence system $d\mid n$, $e\mid n+h$ is compatible iff
$(d,e)\mid h$, has one CRT residue $a(d,e;h)\bmod[d,e]$, and $B_X(a,L)$ is
the endpoint (positive-cone) discrepancy of the count against $X/L$. Their
exact range statements:

- **Sub-$\sqrt X$ equilibrium (⊢, smoothed).** For coprime $(d,e)$ the residue
  satisfies $a/de\equiv-h\bar d/e\pmod 1$; Poisson summation against a smooth
  $W$ gives $\Delta^W$ as a sum over Poisson frequencies $k\neq0$ of
  $\widehat W(kX/[d,e])\,e(ka/[d,e])$, and for $d,e\le X^{1/2-\varepsilon}$
  the whole smoothed discrepancy is $O_B(X^{-B})$ for every $B$. "The hard
  support begins near $[d,e]\gtrsim X$, with $d,e\asymp\sqrt X$ the first
  balanced critical block."
- **The obstruction (§5.7, ⊢/?).** The boundary sum contains *incomplete*
  Kloosterman fractions $e(-kh\bar d/e)$, not complete Kloosterman orbits;
  additive completion produces $S(m,-a;e)$ against the finite Fourier
  transform of the $d$-coefficients; multiplicative completion produces
  character sectors; the two are connected by the finite Gauss transform, and
  "Parseval gives no free $L^2$ gain from this basis change" (their
  correction #12/#15 discipline). GRH does not determine the Gauss
  superposition, the long Poisson frequency, or the cuspidal coefficients.
- **The frontier (§5.12, ?).** Item 2: "complete incomplete Kloosterman
  fractions and control the Gauss change of basis **uniformly in critical
  moduli and Poisson frequencies**." Item 3: a spectral-placement/rigidity
  theorem for the canonical charge-one vector $v_D(d)=d^{-1/2}\kappa_1(d)$ —
  its mass in the worst generic spectral directions power-savingly small.
  Their §5.3 locates the entire unresolved coupling in the residual triple
  "scale-ordered stopping + positive-cone sampling + coherent
  rational-frequency/global spectral effects." "No current artifact closes
  the final analytic arrow."

Note the scope of their own claim: the equilibrium/hard-support split is
**smoothed**, and the kernels $\kappa_r$ are **untruncated** — the expansion
runs over all divisors of the sampled integers, so blocks at every scale up
to $X$ genuinely occur, and $C_{1,1}(X;2)$ is *literally the twin-prime
count* ($\Omega(n)=1\iff n$ prime). Any nontrivial bound on
$\Delta_{1,1}(X;h)$ uniform in $h$ at the balanced blocks is twin-prime
strength. Their frontier item 2, however, is posed for the completion/basis
control **as an estimate uniform over coefficient inputs** (their §5.7
additive completion carries general $\alpha(d)$) — this weaker,
coefficient-uniform reading is the one that will be compared below.

### 1.2 The repo's wall(s) (house coordinates, house grades)

The repo carries **two** residual analytic obligations, on the two sides of
the E2 block separation (`notes/E2_PROOF.md` Thm E2a: sharp block owns the
pole, flat block owns the zeros, exactly, at every finite $Q$).

**(W1) Hypothesis U — the finite-adic side** (`notes/E2_PROOF.md` §2.5,
ledger H3; restated `notes/METHOD.md` §1). With
$\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q$ and
$\mathfrak S_Q(n)=\sum_{q\le Q}\frac{\mu^2(q)}{\varphi(q)^2}c_q(n)$:

> For some $\delta>0$, uniformly in $n,Q$:
> $\ \sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)
> = n\,\mathfrak S_Q(n)+O\!\bigl(n^{1-\delta}Q^{O(1)}+\log^{O(1)}Q\bigr).$

Status: **unproved**; what is proved is
$|\mathcal O(n)|\ll\min(nA(Q),\,Q^2\log Q)$ (U9 + the $\mathcal E(Q)$
argument), giving $\mathcal E(Q)\ll\log^2Q$ where $O(1)$ is needed — a gap
of two logarithms, the same order as M1's leading term. The re-diagnosis
(E2_PROOF §2.4) is load-bearing: the obstruction is **not** pointwise
uniformity of $\Lambda^\sharp_Q$ — that is *false exactly*, by
$\Lambda^\sharp_Q(P_Q)=M(Q)$ (U4), the Mertens function attained at
$n\equiv0\bmod P_Q$ — but incomplete-interval cancellation in the
off-diagonal bilinear Fourier form. `notes/MERTENS_FLOOR.md` proves the same
truncation failure, averaged against a sawtooth, is the exact
$-\tfrac12M(Q)$ block-constant artifact.

**(W2) The archimedean-spectral side, one door with two prices.**
`notes/CARRIER_JOIN.md` §5: after Theorem A (RH $\iff$ the one-point
inequality $|H_1(X)|\le B$, both directions proved in-repo), the single
missing lemma of the product program is **L1**: the microscopic pair-energy
bound $E^\circ_a(\eta)\le C\eta m_0^2$ for $0<\eta\le\eta_0$, mixed-sign
sector included — needed only for the variance rate $V=D_0+O(1/L)$; provably
not finite-checkable (`DCLOSE_NO_GO.md`), bulk-priced at depth
~~$\exp(cT\log^2T)$~~ **[struck 2026-08-24, completing the 2026-08-22 audit's
propagation: K(b)'s exponent is retracted by `HOLOGRAM.md` §7/§5. This
object is pair-CORRELATION content, so the successor here is §5's
difference-atom law $\exp(\Theta(T))$, not K′'s sum law]** (`HOLOGRAM.md`). Its unconditional face is
`notes/BAND.md`'s door: **exhibit any unconditional $B<10/3$ for
Montgomery's $F$ on the band excess $(1,4/3]$, by a tool of global lossiness
$C<3$** — and §3′.1 proves the second price eliminates worst-case
inequalities *as a class*: only an asymptotically sharp evaluation pays.
`notes/DPP.md` Theorem 10 fences the target from above: the variance
question $V_\infty=D$ is carried by $T\in[28,300]$ and **no asymptotic
zero-statistics input can decide it**.

By the Goldston–Montgomery equivalences already cited in `notes/BEYOND.md`
L1, $F$ past band 1 is inter-derivable with shifted-prime/short-interval
asymptotics — i.e. W2's unconditional door is the prime shifted convolution
past $\sqrt{}$-equilibrium, the same object as D0026's untruncated
$\Delta_{1,1}$ at balance, through the explicit formula. (Cited equivalence,
not re-derived here; fence F5.)

---

## 2. The translation, constructed as far as it is exact

Throughout: $A_d=d\sum_{q\le Q,\ d\mid q}\mu(q)\mu(q/d)/\varphi(q)$
(supported on squarefree $d\le Q$), so that
$\Lambda^\sharp_Q=1*A^{(Q)}$ with $A^{(Q)}=A_d\mathbf 1_{d\le Q}$
(`notes/E2_PROOF.md` U1 in the divisor coordinates of
`notes/MERTENS_FLOOR.md` Lemma 1). Compare D0026's
$q_r=1*\kappa_r$: **both corpora detect their weight through a
Möbius-coherent, non-multiplicative divisor kernel.** The mechanism of the
comparison below is the same finite-Fourier/CRT expansion already landed
in-house for a different kernel in `notes/DIVISOR_HAHN_INCIDENCE.md` §5
(eqs. (5.1)–(5.4)); no novelty is claimed for the expansion itself.

**Lemma T0 (the truncated singular series is the CRT equilibrium term;
exact).** For every $n\ge1$, $Q\ge1$:
$$\sum_{\substack{d,e\le Q\\ (d,e)\mid n}}\frac{A_dA_e}{[d,e]}
=\mathfrak S_Q(n).$$

*Proof.* Both sides equal the mean of the $P_Q$-periodic function
$a\mapsto\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(n-a)$ over a full period.
Left side: insert $\Lambda^\sharp_Q=1*A^{(Q)}$; for fixed $(d,e)$ the
constraint $d\mid a$, $e\mid n-a$ is a CRT system, empty unless
$(d,e)\mid n$, else of density $1/[d,e]$. Right side: expand each $c_q$ in
primitive additive characters $e(ha/q)$, $(h,q)=1$; the period-mean of
$e(a(h/q-h'/q'))$ vanishes unless the primitive fractions coincide, forcing
$q=q'$, $h=h'$, and the surviving sum is
$\sum_{q\le Q}\frac{\mu(q)^2}{\varphi(q)^2}\sum_{(h,q)=1}e(hn/q)
=\mathfrak S_Q(n)$. $\square$

**Proposition T1 (Hypothesis U's form *is* the boundary operator; exact).**
For every $n\ge2$, $Q\ge1$:
$$\sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)
-(n-1)\,\mathfrak S_Q(n)
\;=\;\sum_{\substack{d,e\le Q\\ (d,e)\mid n}} A_dA_e\;
B_{n}(a^*(d,e;n),[d,e]),$$
where $a^*(d,e;n)$ is the unique CRT residue of the system
$a\equiv0\ (d)$, $a\equiv n\ (e)$ modulo $[d,e]$, and
$B_n(a,L)=\#\{1\le a'\le n-1:a'\equiv a\ (L)\}-(n-1)/L\in(-1,1)$.

*Proof.* Insert $\Lambda^\sharp_Q=1*A^{(Q)}$ into the left sum, swap the
finite sums, and count the CRT progression on $[1,n-1]$; the main terms
recombine by Lemma T0. Every step is a finite rearrangement. $\square$

This is term-for-term D0026 §5.6's boxed decomposition
$C=X\sum\kappa\kappa/[d,e]+\Delta$: the repo's U9 error $\mathcal O(n)$ **is**
$\Delta_{A,A}(n-1;\,-n)$ — the positive-cone boundary operator with kernel
pair $(A^{(Q)},A^{(Q)})$ evaluated on the diagonal slice where the shift is
minus the interval length.

**Proposition T2 (the phases coincide; exact).** For $(d,e)=1$,
$$\frac{a^*(d,e;n)}{de}\equiv\frac{n\bar d}{e}\pmod 1,$$
which is D0026's $a/de\equiv-h\bar d/e\pmod1$ at $h=-n$. Hence the finite
Fourier expansion of $B_n$ produces exactly their inverse-residue phases
$e(-k\,h\bar d/e)$ against the incomplete-interval Dirichlet kernel
$D_{[1,n-1]}(k/[d,e])$ — the incomplete Kloosterman fractions of their §5.7,
with coefficients $A_d$ in place of $\kappa_r(d)$.

*Proof.* $a^*=dt$ with $dt\equiv n\ (e)$, so $t\equiv n\bar d\ (e)$ and
$a^*/de=t/e\equiv n\bar d/e\pmod 1$. Their computation with $n'=ds$,
$ds\equiv-h\ (e)$ gives $-h\bar d/e$; substitute $h=-n$. The Fourier form is
`notes/DIVISOR_HAHN_INCIDENCE.md` (5.1)/(5.4) with kernel $A$. $\square$

Their additive reciprocity/Hermitian half-phase normalization
($\mathcal K_a(e,d)=\overline{\mathcal K_a(d,e)}$) corresponds under T2 to
the exchange of the two legs $a\leftrightarrow n-a$ of the Goldbach pair —
the repo's form is symmetric in $(d,e)$ for the same reason.

**Proposition T3 (the live range of Hypothesis U is the balanced block).**
(i) For $n\ge(Q^2\log Q)^{1/(1-\delta)}$ the proved bound
$|\mathcal O(n)|\ll Q^2\log Q$ already satisfies Hypothesis U's shape. Hence
the entire unproved content of Hypothesis U lives in
$$n\ll Q^{2+o(1)},\qquad\text{equivalently}\qquad Q\gg n^{1/2-o(1)}.$$
(ii) In exactly that range, and in no other, the truncated kernel reaches
balanced blocks: $[d,e]\le Q^2$ always, and $[d,e]\gtrsim n$ is possible iff
$n\lesssim Q^2$, with the first balanced block at $d,e\asymp\sqrt n$,
attained at $Q\asymp\sqrt n$. (iii) The proved loss $\mathcal E(Q)\ll\log^2Q$
in M1′ is generated by $n\le n_0\asymp Q^2\log Q/A(Q)$ (the split in
E2_PROOF's proof), i.e. by the same range.

*Proof.* (i) is arithmetic on the two bounds; (ii) is $[d,e]\le de\le Q^2$
plus the existence, for $n\le Q^2$, of coprime $d,e\asymp\sqrt n\le Q$ with
$(d,e)\mid n$; (iii) is the displayed split in E2_PROOF §2.5. $\square$

**So: is D0026's "hard support" literally the repo's Hypothesis-U range?**
The derived answer has two halves and both deserve to be kept.

- **Yes, at the level of the operator, the phases, and the equilibrium
  boundary.** T1–T3: same decomposition, same CRT residue, same
  inverse-residue phases, and the repo's wall sits at $Q\asymp\sqrt n$ — the
  sub-$\sqrt X$ equilibrium statement relocated: profinite resolution can be
  pushed to the square root of the interval length and no further. D0026's
  smoothed vanishing theorem applies verbatim to the kernel $A^{(Q)}$
  (nothing in their §5.6 Poisson step uses more than $(d,e)\mid h$ and
  finiteness), so the *smoothed* Hypothesis-U analogue has hard support
  exactly $[d,e]\gtrsim n$.
- **No, as stated, for a reason worth exporting.** Hypothesis U is a
  **sharp-cutoff** statement (the Goldbach fiber $a+b=n$ cannot be
  smoothed without changing the problem), and with a sharp cutoff every
  block — sub-balanced included — retains an $O(1)$ endpoint mass; the
  needed cancellation is then partly **cross-block** (in $d,e$), the
  sawtooth world of `notes/MERTENS_FLOOR.md`. The repo has an exact theorem
  showing this cross-block cancellation can fail maximally: at
  $n\equiv0\bmod P_Q$ the corresponding one-variable sum collapses to
  $M(Q)$ (U4). That extremal point lies far outside Hypothesis U's live
  range ($P_Q=e^{(1+o(1))Q}\gg Q^{O(1)}$) — which is *why* Hypothesis U is
  plausible at all — but the mechanism (truncation destroying
  $\sum_{d\mid m}\mu(d)=0$) is the same one their positive-cone boundary
  samples. D0026's smoothed statement is silent about this layer.

**Where the translation stops.** Four exact differences, none removable by
notation:

| | D0026 §5.6–5.7 | repo Hypothesis U |
|---|---|---|
| kernel | $\kappa_r$, untruncated, all scales to $X$; at $r=t=1$ the count *is* the prime-pair count | $A^{(Q)}$, truncated at $Q$; no primes anywhere in the statement — a pure exponential-sum problem, **no parity obstruction** |
| cutoff | smooth $W$ licensed (their vanishing theorem needs it) | sharp fiber forced |
| quantifiers | uniform in free shift $h$ and free length $X$; both charges | diagonal slice $h=-n$, $X=n$ tied; needs uniformity in $n,Q$, consumed only against the weight $n^{-2}$ |
| target | power-saving completion control; ultimately the final analytic arrow | a specific quantitative shape sufficient for M1′'s $O(1)$ |

The kernel row is the whole distance between the corpora's positions: the
repo's wall is the *truncated, parity-free sector* of theirs; theirs, taken
untruncated at charge one, contains twin primes and is not a lemma anyone
should expect from completion technology alone (their own §5.12 closing
line concedes this).

---

## 3. Adjudication — FORECAST, with probabilities

**Verdict: incomparable-with-shared-core.** The shared core is exactly:

> *incomplete-interval cancellation of inverse-residue phases
> $e(-kh\bar d/e)$ on CRT blocks near balance $[d,e]\asymp$ (interval
> length), with Möbius-coherent non-multiplicative divisor coefficients,
> uniformly in moduli and Poisson frequencies* —

which is D0026 frontier item 2 verbatim, and is by T1–T3 the exact content
of Hypothesis U in the coefficient class $A^{(Q)}$. Neither full obligation
implies the other as stated (kernel/cutoff/quantifier rows above).
Probabilities (house forecast discipline; these are credences, not
theorems):

- **P₁ = 0.75** — a proof of D0026 item 2 *at its stated uniformity*
  ("uniformly in critical moduli and Poisson frequencies", coefficient-
  uniform as in their §5.7 completion with general $\alpha(d)$) discharges
  Hypothesis U. Residual risk: their item 2 might be proved in a smoothed
  form that does not survive the sharp fiber, or with losses in $Q$ larger
  than $Q^{O(1)}$... the sharp-cutoff row is the failure mode.
- **P₂ = 0.05** — Hypothesis U implies D0026 item 2. It is a single slice
  with truncated kernels; nothing in it controls free $h$, higher charges,
  or untruncated $\kappa_r$.
- **P₃ = 0.15** — "same missing estimate" in the strong sense (one theorem
  statement both corpora need, no residue). Rejected as the primary verdict
  because of the kernel row; retained at low mass because a sufficiently
  uniform coefficient-class theorem would in practice serve both.
- **P₄ = 0.55** — Hypothesis U is dischargeable by *existing* technology of
  the DFI/Bettin–Chandee class (bilinear/trilinear forms with Kloosterman
  fractions $e(a\bar m/n)$, power saving precisely in the balanced range
  with arbitrary coefficients; SEARCH lines S1–S2 below). This is the
  single most consequential number in this note: it says the repo's H3 is
  plausibly a *known-methods* problem for a session equipped with the
  machinery the repo lacks. What keeps it at 0.55 and not higher: the
  $Q^{O(1)}$-uniformity and the aggregation over all blocks $(d,e)$ with
  $\ell^1$-large coefficients still have to be run through honestly, and
  no one here has done it.
- **P₅ = 0.85** — the two corpora's *ultimate* doors coincide at the parity
  core: D0026's final analytic arrow (untruncated $\Delta_{1,1}$ at balance,
  uniform in $h$) and the repo's W2 door ($F$-evaluation past band 1 at
  lossiness $C<3$) are the same object up to the explicit formula, via the
  Goldston–Montgomery equivalences. Not 1.0 because the equivalences are
  cited, not re-derived, and the $C<3$ budget is a house-frame constant with
  no upstream analogue yet.

**The structural picture the probabilities encode.** Each corpus's wall
splits into a parity-free completion problem and a parity-carrying
evaluation problem, and the pairs match across corpora:

| | parity-free face | parity-carrying face |
|---|---|---|
| repo | Hypothesis U (W1) | band-$B$ evaluation / L1 (W2) |
| D0026 | frontier item 2 (coefficient-uniform completion) | untruncated $\Delta_{1,1}$, uniform in $h$ (the "final arrow") |

The corpora did relocate the same open problem to two coordinates — but it
is *two* problems in each corpus, and the honest statement is that the
relocation matches face to face, not wall to wall.

---

## 4. Repo theorems imported into D0026's frontier list

Each import is stated with its house proof source and the exact upstream
item it constrains. These flow upstream as constraints, not as claims about
their objects; marks stay theirs.

**4.1 DPP Theorem 10 + DCLOSE, against their routes 3 and 4.** D0026 §5.12
item 3 asks for a spectral-placement theorem for $v_D(d)=d^{-1/2}\kappa_1(d)$
("mass in the worst generic spectral directions power-savingly small");
item 4 asks for stable growing-degree reconstruction (their §5.11 hard wall:
"asymptotic conditioning" of a growing jet). The repo has a proved template
for how such programs fail: `notes/DPP.md` Theorem 10 — a target carried by
a *fixed, bounded* portion of the spectrum ($T\in[28,300]$ for the variance
target) cannot be decided by **any** asymptotic input, because an input
valid only for $T\ge T_1$ moves the quantity by $O(T_1^{-2}\log^4T_1)$;
and `DCLOSE_NO_GO.md` — the same target is provably not finite-checkable
either. The steep exact weight ($2\pi s^{-5}$, D‴) is what concentrates the
problem at the bottom of the spectrum; DPP records this as "the irony": the
exactly-known weight *disables* asymptotic machinery. **Import (warning
shape, not theorem about their objects):** before investing in a
spectral-placement theorem for $v_D$, compute where the mass of the actual
boundary bilinear form sits in the Kuznetsov spectrum. If it concentrates at
the bottom (exceptional/small spectral parameter — plausible, since their
weights $d^{-1/2}\kappa_1(d)$ are again steep), an asymptotic placement
theorem has zero purchase on the boundary estimate, by the same mechanism
DPP proved for the house variance. Their §5.11 route 4 wall ("control of a
growing jet…") has exactly the DCLOSE shape: check non-finite-checkability
before budgeting a finite verification.

**4.2 L3/LEVER3 double-positivity + the lossiness budget, as their
correction #15 proved twice — with numbers.** D0026 §12 correction #15: "A
unitary basis change cannot improve an invariant estimate by itself"; §5.7:
"Parseval gives no free $L^2$ gain." The repo *proved* this twice,
independently, in its own frame, and each time with quantitative content
their prose version lacks:

- `notes/LEVER3.md` Theorem O1 / `notes/L3_SDP.md` Lemma L3.2 (two blind
  landings): every kernel realizable through a Hermitian square
  ($\operatorname{tr}A^2$, any window family, any real coefficients) has
  $\hat g(u)=L^2\int z(t,u)^2dt\ge0$ — the sign freedom that produces the
  CGdL gain is **structurally unreachable** in the square frame. Not "no
  free gain": *which* gains are unreachable, characterized.
- `notes/BAND.md` §3′.1: any tool entering the certificate as a worst-case
  inequality with global lossiness $C\ge3$ certifies nothing ($\max H=
  2-2\sqrt{C/3}$); the large sieve has $C=\pi^4/18=5.41$, failing by the
  factor $1.80$. Worst-case inequalities are dead *as a class*; only
  asymptotically sharp evaluation pays, and the acceptance test is a
  number.

**Import:** their honest chain $\kappa_1\to P_\chi/L\to$ Gauss $\to$
additive $\to S(m,n;c)\to$ Kuznetsov should carry a lossiness ledger: each
arrow that is an inequality rather than an identity must declare its
constant, and the frame-level budget (here $C<3$; theirs to be computed for
their target) decides in advance whether the chain can certify anything.
This converts their correction #15 from a caution into an accounting rule.

**4.3 Archimedean de-centering sorts their §5.3 residual triple.** Their
unresolved coupling is "scale-ordered stopping + positive-cone sampling +
coherent rational-frequency/global spectral effects." The repo's
function-field de-centering program (`notes/FF_PAIRFIELD.md` §4 table;
`notes/CROSS_LENS.md` §8; `notes/POSITIVITY_HAS_A_PLACE.md`) sorts the
three slots with proofs behind each line:

- **Positive-cone sampling is archimedean optics.** In $\mathbf F_q[t]$
  the place at infinity is discrete, degree shells are exact, and the
  sharp-cutoff/endpoint apparatus is moot (FF table row "sharp-cutoff
  difficulty"). Moreover positivity-as-predicate lives at an ordering of
  the ground field, $\operatorname{Sper}\mathbb Q$ is a point, and
  $\operatorname{Sper}\mathbb F_q(t)=\emptyset$
  (`POSITIVITY_HAS_A_PLACE.md`): their "positive cone" is not a choice
  among cones but *the* archimedean limitor. Their own §5.6 sentence "the
  automorphic/Kloosterman lens is generated by the positive-cone remainder
  itself" is, in house terms, the statement that the lens is the display
  optics of the archimedean place — real, exact, and not where the
  arithmetic hardness lives.
- **Their third slot conflates two things the repo separated by theorem.**
  "Coherent rational-frequency/global spectral effects" is, under E2
  (Theorem E2a, unconditional, every finite $Q$), *two* blocks: the
  rational-frequency coherence lives entirely in the sharp block (which
  owns the pole at $s=1$ and is spectrally dead — no zero enters its polar
  divisor), and the global spectral cancellation lives entirely in the
  flat block (which owns every $\rho$ and no pole). The separation is
  exact, not asymptotic. Their triple is really a quadruple, and the two
  new pieces have opposite epistemic status: the rational-coherence piece
  is bookkeeping (computable at every $Q$), the global piece is the wall.
- **Scale-ordered stopping survives de-centering and is not RH-shadowed.**
  In FF, parity falls (Sawin–Shusterman) via auxiliary sheaf cohomology,
  not via zeros of the base zeta (`notes/PROOF_DIFF_FF.md`; FF table row
  "parity barrier"). So the stopping/parity slot of their triple is
  genuinely arithmetic, genuinely hard, and — on the FF evidence —
  attackable by mechanisms unrelated to the spectral slot. Budgeting it as
  "global spectral" would be a category error the FF theater has already
  falsified once.

**4.4 The Mertens artifact, against their route 1.** D0026 §5.12 item 1
asks for a finite-volume divisor/CRT expression for the fugacity propagator
in the actual boundary problem. The repo's exact experience with finite
truncations of exactly this kind of kernel: the truncation constant is not
smooth — it is $\tfrac12M(Q)$ exactly (`notes/MERTENS_FLOOR.md` Theorem MF),
unbounded by Odlyzko–te Riele, and it was *measured as a fitted constant
first* and only then derived. Any finite-volume $[d,e]$-truncated
propagator they build will carry the same class of non-smooth truncation
artifact; the house lesson is that these artifacts are exactly derivable
(the coefficient is a theorem, $\tfrac12$) and must be derived before any
constant read off the finite volume is trusted.

---

## 5. The pincer, named

**5.1 What a Kuznetsov-equipped session contributes to the repo's doors.**
The repo's contact with the spectral theory of shifted convolutions is
survey-grade only (`notes/DIVISOR.md` — Estermann, Heath-Brown,
Deshouillers–Iwaniec, Motohashi assembled with references;
`notes/REPORT.md` §7(a): the divisor field is the solvable model, "no
Voronoi/Kuznetsov summation formula exists for primes"). No house proof
uses a Kloosterman completion or a spectral large sieve. The two concrete
handoffs, in order of expected value:

1. **Discharge Hypothesis U (W1) — the P₄ = 0.55 target.** By T1–T2 the
   needed estimate is a bilinear form in incomplete Kloosterman fractions
   with coefficients $A_d$, moduli $\le Q^2$, balanced blocks live. That is
   the native habitat of the DFI/Bettin–Chandee machinery (S1–S2). Payoff
   inside the repo: $\mathcal E(Q)=O(1)$, hence M1′'s constant term becomes
   explicit ($0.430870\ldots+\lim\mathcal E$), ledger H3 closes, and with
   it the last analytic gap in the $[\sharp\sharp]$ block's constant
   structure. Payoff upstream: a proved instance of their frontier item 2
   in a nontrivial coefficient class, on the sharp fiber their smoothed
   theorem avoids.
2. **Price the W2 door honestly.** The band-$B$ ask ($B<10/3$ on
   $(1,4/3]$ at lossiness $C<3$) requires an asymptotically sharp
   evaluation of prime shifted convolutions past $\sqrt{}$-equilibrium —
   Motohashi-grade technology exists one level down (divisor pairs) and
   provably transfers no further for want of a prime Kuznetsov formula.
   A Kuznetsov-equipped session cannot open this door either (parity), but
   it can compute the **lossiness constants** of the spectral tools on the
   divisor model — determining whether *any* known completion chain meets
   $C<3$ even in the solvable case. If none does, the repo's budget
   argument upgrades to: the door is closed to the entire current spectral
   toolkit, a durable no-go of exactly the kind D0026 §17 values.

**5.2 What the repo contributes to D0026's frontier.** Beyond §4's four
imports: the certificate sign discipline (`L3_SDP` §6.2 / `BEYOND.md` L1
correction: in a positivity frame, *upper* bounds on the pairing pay and
lower bounds do not — their §5.6 Hermitian half-phase normalization sets up
an operator-norm target, and the house lesson is that the target's sign
structure must be audited before the estimate is attempted); and Theorem A
(`CARRIER_JOIN.md`) as the statement of what survives when all optics are
stripped: the one RH-carrying structure is a one-point inequality on a
rank-one square, everything pair-shaped either collapses to it or loses
positivity (`PRODUCT_WEIGHT_NO_GO.md` via CARRIER_JOIN §4.1). Their §5.6
Hermitian blocks face the same dichotomy one basis over: a form that keeps
Hermitian-square positivity will not carry the bulk correlation content,
by the same barrier classification.

**5.3 The complementarity is structural, not accidental.** Two facts,
verified mechanically for this note rather than assumed:

- **Ingestion gap.** `collab/upstream/raw/` holds D0015–D0026 with gaps and
  **nothing between D0026 and the present**; owner Deltas 30–38 have never
  been ingested by this repository (checked by listing the upstream raw and
  library trees and grepping the whole `notes/` and `collab/` trees for
  `D003x` / `delta-3x` — the single hit is a substring false positive on
  "D0026"). Whatever the upstream lane learned about its own §5.7 chain
  after 2026-08-16 is not in this corpus, and this note's §1.1 reading of
  their obligation is therefore **as of D0026 V2 only**.
- **Missing lane.** The repo has no Kuznetsov/Kloosterman lane at all
  (ledger T6): every occurrence is survey, reference-list, or
  model-calibration prose (`DIVISOR.md`, `REPORT.md` §7(a), `KAPPA.md`'s
  history table, `BARRIER.md`'s "presentation #4"). No house theorem is
  proved through a Kloosterman completion, a Gauss transform, or a spectral
  large sieve.

These two facts explain the shape §2 derived rather than merely accompanying
it. The repo reached the balanced block **from the finite-adic side**, by
pushing profinite resolution $Q$ up until it hit $\sqrt n$ (T3) — the only
route available to a corpus whose tools are Mellin–Barnes, explicit
formulas, Krein/Toeplitz positivity, and exact divisor algebra. D0026
reached the *same* block **from the spectral side**, by expanding the
positive-cone remainder into inverse-residue phases and following them
toward Kuznetsov (their §5.7 chain) — the route available to a corpus
carrying automorphic machinery. Neither corpus could have arrived at the
other's coordinates with its own tools: the repo has no completion
technology to convert its phases into orbits, and D0026 has no
truncated-Ramanujan/Mertens layer in which the sharp-cutoff failure is an
exact theorem (their §5.6 vanishing statement is smoothed, and smoothing is
precisely what erases the $M(Q)$ artifact this repo proved is unavoidable).
So the two coordinate systems are complementary **by construction of the
two toolkits**, and the wall they both hit is where the toolkits' reaches
end — which is why the translation T1–T3 is exact at the operator and phase
level and stops exactly at the kernel/cutoff rows. The corollary for
routing is §5.1's: the missing lane is the pincer's other arm, and it is
missing on both sides of the ingestion gap simultaneously — the repo lacks
the machinery, and lacks the upstream deltas that might report on it.

---

## 6. Honesty ledger

| # | item | status |
|---|---|---|
| T1 | Lemma T0, Props T1–T3 | **Derived here**, finite rearrangements + the two cited house identities (U1/MF-Lemma 1, U9 split). Exact; no asymptotics. The Fourier form of $B_n$ is `DIVISOR_HAHN_INCIDENCE.md` (5.1)/(5.4) with kernel $A$; no novelty claimed for the expansion mechanism. |
| T2 | "$C_{1,1}(X;2)$ is the twin count" | Immediate from $\Omega(n)=1\iff n\in\mathbb P$; stated to fix the strength of the untruncated case. The $\ell^1$-divergence of $\kappa_1$ against $1/[d,e]$ at balance is noted, not analyzed. |
| T3 | §1.2's W2 = D0026 final arrow linkage | **Cited** (Goldston–Montgomery equivalences, via `BEYOND.md` L1), not re-derived. Credence carried in P₅, not asserted. |
| T4 | The verdict | FORECAST, §3, probabilities declared. The only *proved* comparison content is T0–T3. |
| T5 | §4 imports | Each rests on a proved house theorem (DPP Thm 10, DCLOSE, LEVER3 O1, L3_SDP L3.2, BAND §3′.1, E2a, MF, U4, FF table, Sper computation); the *application* to upstream objects is warning-shaped and so labelled. No upstream mark upgraded. |
| T6 | Scope of "the repo lacks Kuznetsov machinery" | Verified by grep + read: `DIVISOR.md`/`REPORT.md` are survey/model notes; no house derivation uses Kloosterman completion. `BARRIER.md` names Kuznetsov access as a *presentation* only. |
| T8 | §5.3's two facts | **Verified mechanically for this note** (directory listing of `collab/upstream/raw/` and `collab/upstream/library/`; grep of `notes/` + `collab/` for `D003[0-8]`, `delta-3[0-8]`, `Delta 3[0-8]`; grep for Kuznetsov/Kloosterman with per-hit read). Absence of ingestion is a statement about **this repository**, not about the upstream corpus: Deltas 30–38 may exist and may already address §1.1's items. The *interpretation* ("complementary by construction of the toolkits") is an argument, not a theorem — it is falsified if a house note is found proving something through a completion, or if an ingested Delta 30–38 relocates their wall. |
| T7 | Hypothesis U ⇒ $\mathcal E(Q)=O(1)$ bookkeeping | E2_PROOF states the implication without spelling the $n$-aggregation; T3(i)'s live-range computation is done here from Hyp U's printed shape. If the intended reading of Hyp U differs (e.g. $\delta$-dependence of the $Q$-exponent), T3's range boundary moves by $o(1)$ in the exponent only. Flagged for the audit. |

**SEARCH lines** (per protocol: searched before writing; queries + best
hits; search-summary grade — abstracts/titles via proxy, no PDF read):

- **S1.** Query: *incomplete Kloosterman sums bilinear forms Ramanujan sums
  truncated singular series shifted convolution balanced moduli*. Located:
  Kowalski–Fouvry-school bilinear forms with Kloosterman sums
  ([Kowalski, "Some applications of smooth bilinear forms with Kloosterman
  sums"](https://people.math.ethz.ch/~kowalski/complement.pdf)); Kerr–
  Shparlinski–Wu–Xi on bilinear sums of incomplete Kloosterman sums for
  general moduli ([survey via arXiv 2511.08445](https://arxiv.org/html/2511.08445v2));
  spectral-large-sieve treatments of balanced error terms
  ([arXiv 2511.07550](https://www.arxiv.org/pdf/2511.07550)).
- **S2.** Query: *Duke Friedlander Iwaniec "Kloosterman fractions" Bettin
  Chandee trilinear balanced range*. Located: Duke–Friedlander–Iwaniec,
  *Bilinear forms with Kloosterman fractions*, Invent. Math. 128 (1997);
  Bettin–Chandee, *Trilinear forms with Kloosterman fractions*
  ([arXiv:1502.00769](https://arxiv.org/abs/1502.00769), Adv. Math. 2018) —
  bounds for $\sum\alpha_m\beta_n\nu_a e(a\bar m/n)$ with arbitrary
  coefficients, power-saving in the balanced range; recent refinement
  [arXiv:2604.25177](https://arxiv.org/pdf/2604.25177) (fixed-factor
  moduli, complementary divisors). **Consequence for novelty claims:** the
  shared core named in §3 is a *known active research area*, not a house
  discovery; what this note claims is only the identification T1–T3 of the
  two corpora's walls with it and with each other. D0026's frontier item 2
  should carry these references when it next circulates upstream.
- **S3 (negative).** No search was run for the face-matching table of §3
  (parity-free/parity-carrying split across corpora) as a *packaging*;
  it is claimed as arrangement, not as mathematics.

**Scope fences.**

- Nothing here bears on the truth of Hypothesis U, L1, band-$B$, or any
  upstream frontier item; the note compares obligations, it discharges none.
- **As-of fence.** §1.1 states the upstream obligation *as of D0026 V2
  (2026-08-16)*. Owner Deltas 30–38 are not in this repository (§5.3, T8);
  if they moved the frontier, §1.1 and every probability in §3 that
  conditions on it are stale by exactly that amount.
- All statements about D0026's objects are readings of the received
  transcription; its marks (⊢ ? ◆ …) are quoted, never upgraded; where its
  transcription is ambiguous (mangled LaTeX), the reading adopted is the
  one its own surrounding prose forces, and T2 re-derives rather than
  trusts the residue formula.
- The probabilities in §3 are this worker's credences under the house
  forecast discipline; they are inputs to routing, not results.
- Per `CLAUDE.md`: no computation was run for this note; every displayed
  identity is proved on the page or cited to a proof.

**Consumers.** `notes/D0026_BUILD_QUEUE.md` Q4 (this note is the two-column
comparison it ordered); whichever session next attacks W1 with completion
machinery (§5.1 item 1 is its brief); the upstream reply lane (§4's four
imports and S2's references are the payload); `FRONTIER_2026_MAP.md`
(the face-matching table of §3 is a map correction: two walls, four faces,
matched crosswise).
