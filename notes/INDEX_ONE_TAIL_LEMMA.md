> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The two-pair finite Mellin interpolation lemma: surgical extraction

**Status: EXTRACTION, NOT A CLAIM.** This note extracts, as a standalone
statement with every hypothesis explicit and every constant named, the lemma
on which the converse half of `notes/WEIL_INDEX_ONE.md` Theorem 3.1 (claim
`collab/discovery/claims/R0006-weil-index-one-converse.md`) rests. It is the
successor seed R0006 lists first: *"a two-pair finite Mellin interpolation
lemma with explicit tail norm."* Nothing here is proved beyond what the corpus
has already proved by hand (`notes/AUDIT_WEIL_INDEX_ONE.md` §2); the
deliverable is the decomposition into numbered obligations, the classification
of each obligation (pure algebra / certified-computable per `notes/VV.md`
V2.5 / genuinely analytic), and the exact delta against Bombieri 2000
Theorem 8. The single genuinely analytic obligation (O7 below) is **assumed as
a hypothesis** of the lemma, because that is its honest status: it is cited
from Connes–Consani Appendix C, Proposition C.1 (following Yoshida), and — per
`AUDIT_WEIL_INDEX_ONE.md` §2.7 — **no line of that proof has been read from
this environment.**

Provenance chain: `notes/LP_CERT.md` §8 posed the converse and named the
missing step ("simultaneous tail control"); `notes/WEIL_INDEX_ONE.md` §2
folded that step into Lemma 2.1 as "the only analytic input";
`notes/AUDIT_WEIL_INDEX_ONE.md` §2.7 and §4.4 identified the unopened citation
inside it as "the corpus's most expensive blocked page". This note un-folds
Lemma 2.1 so the blocked page is a single named hypothesis and everything else
is attackable now.

---

## 0. Conventions (repo normalization, `WEIL.md` Prop W1, unchanged)

For $g \in C_c^\infty(\mathbb R, \mathbb C)$,

$$\Phi_g(s)=\int_{\mathbb R} g(u)\,e^{(s-1/2)u}\,du, \qquad J(s)=1-\bar s .$$

$Z_{\mathrm{set}}$ is the set of distinct nontrivial zeros of $\zeta$,
$m_\rho \ge 1$ the multiplicity of $\rho$, and $Z$ the multiset (each $\rho$
with weight $m_\rho$). $Z_{\mathrm{set}}$ is stable under $\rho \mapsto
1-\rho$ and $\rho \mapsto \bar\rho$, hence under $J$, with $m_{J\rho} =
m_\rho$. $N(T) = O(T \log T)$ (Riemann–von Mangoldt).

$$W(g,h)=\sum_{\rho \in Z_{\mathrm{set}}} m_\rho\,
  \Phi_h(\rho)\,\overline{\Phi_g(J\rho)}, \qquad
  \mathrm{pole}(g)=2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr],
  \qquad I = \mathrm{pole}-W,$$

$$P=\{g \in C_c^\infty : \Phi_g(0)=\Phi_g(1)=0\}, \qquad I|_P = -W|_P .$$

**The tail norm, named once and used throughout.** The weighted space is

$$\ell^2(Z,m) \;=\; \Bigl\{\,x : Z_{\mathrm{set}} \to \mathbb C \;:\;
 \|x\|_{\ell^2(Z,m)}^2 := \sum_{\rho \in Z_{\mathrm{set}}} m_\rho\,|x_\rho|^2
 < \infty \,\Bigr\}.$$

Every tail estimate in the lemma is an estimate in this norm (or in the
restricted norm $\ell^2(Z \setminus E, m)$, same weights, sum over
$\rho \notin E$). Two structural facts about it, used constantly:

- **(J-unitarity.)** $(J^\ast x)_\rho := x_{J\rho}$ is a unitary involution of
  $\ell^2(Z,m)$: it permutes coordinates and preserves weights because
  $m_{J\rho}=m_\rho$. It restricts to a unitary of
  $\ell^2(Z\setminus E, m)$ for any $J$-stable $E$.
- **(Evaluation lands in the space, unconditionally.)** For
  $g \in C_c^\infty$, $\mathrm{ev}(g) := (\Phi_g(\rho))_\rho \in \ell^2(Z,m)$
  with no RH assumed: Paley–Wiener gives $|\Phi_g(\sigma+i\tau)| \ll_N
  e^{A|\sigma-1/2|}(1+|\tau|)^{-N}$ uniformly on $0 \le \sigma \le 1$
  ($A$ = support radius of $g$), and $N(T)=O(T\log T)$ sums it. Consequently
  $W(g,h) = \langle \mathrm{ev}(h),\, J^\ast\,\mathrm{ev}(g)
  \rangle_{\ell^2(Z,m)}$ converges absolutely, is Hermitian, and satisfies
  $|W(g,h)| \le \|\mathrm{ev}(g)\|\,\|\mathrm{ev}(h)\|$ — again without RH.
  (`AUDIT_WEIL_INDEX_ONE.md` §2.1, items 1–2 and 4.)

---

## 1. The lemma, at full precision

> **Lemma TP (two-pair finite Mellin interpolation with summable polarized
> tails).**
>
> **Hypotheses.**
>
> **(A1) — quartet.** Let $\rho_0 = \beta + i\gamma$ be a zero of $\zeta$ with
> $0 < \beta < 1$, $\beta \ne \tfrac12$; then $\gamma \ne 0$ (no zeros on the
> real segment $(0,1)$), and
> $$E = \{a,b,c,d\} = \{\rho_0,\; J\rho_0,\; \overline{\rho_0},\;
>   J\overline{\rho_0}\}
>   = \{\beta+i\gamma,\; (1-\beta)+i\gamma,\; \beta-i\gamma,\;
>     (1-\beta)-i\gamma\}$$
> consists of **four distinct** zeros, of **common multiplicity** $m =
> m_{\rho_0} \ge 1$, and is **$J$-stable** ($J$ swaps $a \leftrightarrow b$
> and $c \leftrightarrow d$). Write the three pairwise gap scales
> $$\delta := |2\beta-1| \;(>0), \qquad 2|\gamma| \;(>0), \qquad
>   \sqrt{\delta^2 + 4\gamma^2},$$
> which are the distances $|a-b|=|c-d|=\delta$, $|a-c|=|b-d|=2|\gamma|$,
> $|a-d|=|b-c|=\sqrt{\delta^2+4\gamma^2}$.
>
> **(A2) — one-anchor localizers [the analytic input; obligation O7].**
> There exist $\varepsilon_0 = \varepsilon_0(E) > 0$ and a decay exponent
> $\kappa > \tfrac12$ such that for every $z \in E$ and every $\varepsilon \in
> (0, \varepsilon_0)$ there is $\varphi_{z,\varepsilon} \in P \cap
> C_c^\infty(\mathbb R)$ with
> $$\text{(a)}\;\; \Phi_{\varphi_{z,\varepsilon}}(z) = 1, \qquad
>   \text{(b)}\;\; |\Phi_{\varphi_{z,\varepsilon}}(\rho)| \;\le\;
>   \varepsilon\,(1+|\rho-z|)^{-\kappa}
>   \quad \text{for every } \rho \in Z_{\mathrm{set}} \setminus \{z\}.$$
> The construction reported by `WEIL_INDEX_ONE.md` §2 from Connes–Consani
> Appendix C Prop. C.1 / Yoshida gives $\kappa = 2$; the lemma needs only
> $\kappa > \tfrac12$, with all constants below then depending on $\kappa$.
> Note (b) covers *all* other zeros, the other three quartet members
> included; and membership in $P$ — the two Mellin vanishings
> $\Phi(0)=\Phi(1)=0$ — must be **exact**, not approximate.
>
> **(A3) — zero counting.** $N(T) = O(T\log T)$.
>
> **Named constants.** (All explicit; dependence ledger in §1.1.)
> $$C_E := \max_{w\in E} \sum_{z\in E,\, z\ne w} (1+|w-z|)^{-\kappa}
>   \;=\; (1+\delta)^{-\kappa} + (1+2|\gamma|)^{-\kappa}
>     + \bigl(1+\sqrt{\delta^2+4\gamma^2}\bigr)^{-\kappa} \;\;(<3),$$
> $$S_E(\rho) := \sum_{z\in E} (1+|\rho-z|)^{-\kappa}
>   \quad (\rho \notin E), \qquad
> K_E^2 := \sum_{\rho \in Z_{\mathrm{set}} \setminus E} m_\rho\, S_E(\rho)^2
>   \;<\; \infty ,$$
> the finiteness of $K_E$ holding by (A3) precisely because $2\kappa > 1$.
>
> **Conclusions.**
>
> **(i) — localizer tails are $\ell^2(Z,m)$-small.** For each $z, \varepsilon$
> the off-anchor evaluation vector $t_{z,\varepsilon} :=
> (\Phi_{\varphi_{z,\varepsilon}}(\rho))_{\rho \ne z}$ satisfies
> $\|t_{z,\varepsilon}\|_{\ell^2(Z\setminus\{z\},\,m)} \le \varepsilon\,
> K_{z}$ with $K_z^2 := \sum_{\rho\ne z} m_\rho (1+|\rho-z|)^{-2\kappa}
> < \infty$.
>
> **(ii) — the nearly diagonal evaluation matrix and its inverse.** The
> $4\times4$ matrix $A_\varepsilon := \bigl(\Phi_{\varphi_{z,\varepsilon}}(w)
> \bigr)_{w,z\in E}$ (rows = evaluation points $w$, columns = localizers $z$)
> satisfies $A_\varepsilon = \mathrm{Id}_4 + B_\varepsilon$ with
> $\|B_\varepsilon\|_{\infty\to\infty} \le \varepsilon\,C_E$. Hence for
> $\varepsilon < 1/C_E$, $A_\varepsilon$ is invertible with
> $\|A_\varepsilon^{-1}\|_{\infty\to\infty} \le (1-\varepsilon C_E)^{-1}$
> (Neumann series).
>
> **(iii) — interpolants with polarized-summable tails.** For every
> $v \in \mathbb C^E$ and $\varepsilon < 1/C_E$, the function
> $g_{v,\varepsilon} := \sum_{z\in E} c_z\,\varphi_{z,\varepsilon}$ with
> $c = A_\varepsilon^{-1} v$ lies in $P$, satisfies
> $\Phi_{g_{v,\varepsilon}}|_E = v$ exactly, and has off-$E$ tail
> $$\bigl\|(\Phi_{g_{v,\varepsilon}}(\rho))_{\rho\notin E}
>   \bigr\|_{\ell^2(Z\setminus E,\,m)}
>   \;\le\; \varepsilon\, \frac{\|v\|_\infty}{1-\varepsilon C_E}\; K_E .$$
>
> **(iv) — every polarized tail is summable and small.** For two such
> interpolants $g = g_{v,\varepsilon}$, $g' = g_{v',\varepsilon}$: because
> $E$ is $J$-stable, $\rho \notin E \Rightarrow J\rho \notin E$, so **no
> selected point is ever paired with an unselected one**; both factors of
> every off-$E$ term of $W(g,g')$ carry the $\varepsilon$-bound, and by
> Cauchy–Schwarz in $\ell^2(Z\setminus E, m)$ together with $J$-unitarity,
> $$\Bigl| W(g,g') \;-\; \underbrace{m \sum_{z\in E} v'_z\,
>   \overline{v_{Jz}}}_{\text{exact } E\text{-block}} \Bigr|
>   \;\le\; \varepsilon^2\,
>   \frac{\|v\|_\infty \|v'\|_\infty}{(1-\varepsilon C_E)^2}\; K_E^2 .$$
>
> **(v) — the two-pair conclusion.** Take, in the coordinate order
> $(a,b,c,d)$,
> $$v_1 = (1,-1,0,0), \qquad v_2 = (0,0,1,-1),$$
> and $g_1, g_2$ the corresponding interpolants. The exact $E$-blocks are
> $$W_E(g_1,g_1) = W_E(g_2,g_2) = -2m, \qquad W_E(g_1,g_2) = 0
>   \;\;(\text{exactly, not } o(1)),$$
> so the Gram matrix is $\bigl(W(g_i,g_j)\bigr) = -2m\,\mathrm{Id}_2 + R$
> with (crude but explicit) $\|R\| \le 2\varepsilon^2 K_E^2
> (1-\varepsilon C_E)^{-2}$. Hence for
> $$\varepsilon \;<\; \varepsilon_1(E) := \min\Bigl(\varepsilon_0,\;
>   \tfrac{1}{2C_E},\; \tfrac{\sqrt m}{2K_E}\Bigr)$$
> the matrix is negative definite, $g_1, g_2$ are linearly independent
> (their $E$-evaluations are), $V := \operatorname{span}_{\mathbb C}\{g_1,
> g_2\} \subset P$ is 2-dimensional, and
> $$I|_V = -W|_V \succ 0, \qquad n_+(I|_V) = 2 .$$

Combined with the forward direction (`LP_CERT.md` Prop LP2(H2): under RH,
$n_+(I|_V) \le 1$ for every finite-dimensional $V$ — pure algebra, the
pullback of the rank-two hyperbolic pole form), Lemma TP is exactly what makes
Theorem 3.1 of `WEIL_INDEX_ONE.md` an equivalence: $\neg$RH supplies a
quartet, the quartet plus (A2) supplies $n_+ = 2$.

### 1.1 Constant dependence ledger — what depends on what

| constant | depends on | does NOT depend on |
|---|---|---|
| $C_E$ | quartet geometry only: $\delta = \lvert 2\beta-1\rvert$, $\lvert\gamma\rvert$, and $\kappa$; always $< 3$; decreasing in both gaps | the rest of $Z$, RH, multiplicity, $\varepsilon$ |
| $K_z,\ K_E$ | location of $E$ inside the zero field and the RvM constants (explicit versions exist: Trudgian-type bounds on $N(T)$); $\kappa$ | RH, simplicity; finiteness needs only $2\kappa > 1$ |
| $\varepsilon_0(E)$ and the implicit uniformity of (A2) | **the un-extracted CC/Yoshida construction** — possibly the anchor height $\lvert\gamma\rvert$, the support length of $\varphi$, and the vanishing set $\{0,1\}$; unknown until O7a–O7c are discharged | — (unknown; this row IS the open problem) |
| $m$ | multiplicity of $\rho_0$; enters only favorably (threshold $\sqrt m / 2K_E$ grows with $m$) | — |
| $\varepsilon_1(E)$ | all of the above | any zero outside $E$ individually (only through $K_E$) |

Nowhere does RH, zero simplicity, or the position of any individual zero
outside $E$ enter. The $o(1)$ of `WEIL_INDEX_ONE.md` (3.4) is here the
explicit $\varepsilon^2 K_E^2 (1-\varepsilon C_E)^{-2}$, which is the "explicit
tail norm" R0006's successor seed asked for — *conditional on (A2), whose own
constants remain the one unquantified item.*

---

## 2. Proof obligations, numbered

**O1 (unconditional convergence).** $\mathrm{ev}(g) \in \ell^2(Z,m)$ for every
$g \in C_c^\infty$, without RH: Paley–Wiener strip bound + RvM. Needed so
$W$, hence conclusion (iv), makes sense in a world where RH is false.
*Checked by hand in `AUDIT_WEIL_INDEX_ONE.md` §2.1(4).*

**O2 ($J$-structure).** $Z$ is $J$-stable with multiplicity; $J^\ast$ is a
unitary involution of $\ell^2(Z,m)$ restricting to $\ell^2(Z\setminus E,m)$;
$W$ is Hermitian. *Checked: `AUDIT` §2.1(1)–(2).*

**O3 (quartet algebra).** Distinctness of $a,b,c,d$, the $J$-orbit structure,
common multiplicity $m$; $\gamma \ne 0$ from the classical fact
$\zeta \ne 0$ on $(0,1)$. *Checked: `AUDIT` §2.3.*

**O4 (Neumann inversion).** Conclusion (ii): $\|B_\varepsilon\| \le
\varepsilon C_E$, invertibility, inverse bound, and the $c$-bound
$\|c\|_\infty \le \|v\|_\infty(1-\varepsilon C_E)^{-1}$. Finite-dimensional
linear algebra over an ordered field.

**O5 (exact $E$-block).** Conclusion (v)'s exact part: the two diagonal
entries $-2m$ and the **exactly zero** cross term, for the data $v_1, v_2$.
*Checked entry-by-entry: `AUDIT` §2.3.*

**O6 (tail norm finiteness and value).** $K_z, K_E < \infty$ with an explicit
numeric upper bound: split at a height $H$; the finite part is a finite sum
over certified zeros (interval enclosures, Platt-style Turing verification);
the tail past $H$ is bounded analytically by an explicit RvM constant and
$\int^\infty \log t \cdot t^{-2\kappa}\,dt$. Also the assembly
$\|R\| \le 2\varepsilon^2 K_E^2(1-\varepsilon C_E)^{-2}$ and the threshold
$\varepsilon_1(E)$.

**O7 (the one-anchor localizer — THE gap).** Hypothesis (A2) itself.
Sub-obligations, in the order they unblock each other:

- **O7a.** Obtain and read Connes–Consani, arXiv:2006.13771, Appendix C,
  Proposition C.1 (and Yoshida 1992) *in full text*. Verify the exact
  statement: which test-function class, which vanishing sets are allowed,
  whether the conclusion is one anchor + prescribed finite vanishing + global
  decay at all remaining zeros. Per `AUDIT` §2.7 and §3.4 this page has never
  been opened from this environment, and the engine paraphrase of C.1
  ("equivalent to RH") is the least reliable line in the audit.
- **O7b.** Extract the true decay exponent $\kappa$ and the meaning of
  $\varepsilon$: what resource does $\varepsilon$ trade against (support
  length? a bandwidth parameter? — compare the Landau/Nyquist budget
  $N \gtrsim T\gamma_K/\pi$ of `PROLATE_BRIDGE.md` §3.4/§11, which is the
  numerically measured shape of exactly this trade). The lemma's slack:
  any $\kappa > \tfrac12$ suffices, so even a substantially weaker bound than
  the reported $|\rho - z|^{-2}$ survives.
- **O7c.** Uniformity: dependence of $\varepsilon_0$ and the implied constant
  on the anchor height $|\gamma|$ and on the imposed vanishing set $\{0,1\}$.
  (For Lemma TP, $E$ is a single fixed quartet, so *any* $E$-dependence is
  tolerable; uniformity in $E$ would only matter for quantitative or
  multi-quartet refinements.)
- **O7d.** Exactness of the constraints: $\varphi \in C_c^\infty$ and
  $\Phi_\varphi(0) = \Phi_\varphi(1) = 0$ exactly. If the construction gives
  only approximate vanishing, an extra (algebraic) correction step against a
  2-dimensional complement is needed, and the pole form no longer vanishes
  identically on $V$ — the lemma statement must then be re-derived with a
  pole-leak term.
- **O7e (optional, for the real-coefficient strengthening `AUDIT`
  Prop. B).** Conjugation-equivariance of the construction:
  $\varphi \mapsto \overline{\varphi}$ compatible with the bounds, so that
  real interpolants $\tfrac12(g+\bar g)$ inherit (iii)–(iv). This uses (A2)'s
  *internal symmetry*, not just its statement — flagged in `AUDIT` §5 as the
  audit's own weakest step.

**O8 (glue).** From (v): $n_+(I|_V) = 2$, contradiction with the index-one
bound; assembly of Lemma TP + LP2(H2) into the equivalence. Trivial given
O1–O7.

### 2.1 Classification (per `VV.md` V2.5: no floats load-bearing)

| obligation | class | formalizable now? | notes |
|---|---|---|---|
| O2 | pure algebra | **yes** — abstract $J$-stable weighted multiset; no zeta facts needed | Agda/Lean-ready as stated |
| O3 | pure algebra + one classical fact | **yes**, modulo $\zeta\ne0$ on $(0,1)$ taken as imported hypothesis (its alternating-series proof is elementary but analytic) | `AUDIT` §2.3 is the paper proof |
| O4 | pure algebra | **yes** — finite-dimensional Neumann series over $\mathbb Q$ or any ordered field | the "nearly diagonal ⟹ invertible" step in full |
| O5 | pure algebra | **yes** — a $4$-point exact computation | already done by hand twice (builder + blind lineage, R0006) |
| O6 | certified-computable + standard analytic tail | interval arithmetic for the finite part (certified zero enclosures); explicit RvM constant for the tail — V2.5-compliant, no floats load-bearing | the *finiteness* is analytic-but-classical; the *numeric value* of $K_E$ is certifiable |
| O1 | genuinely analytic, standard | not now (Paley–Wiener + contour bookkeeping) | classical; no research content |
| O7 | **genuinely analytic — the open core** | no | the successor seed; everything else in this note is scaffolding to isolate it |
| O8 | pure algebra | yes | — |

The point of the decomposition: **every obligation except O1 and O7 is
discharged or dischargeable today** (O2–O5, O8 are algebra; O6 is a certified
computation plus a textbook tail), O1 is standard, and O7 is a *single,
named, citable statement* whose verification is a reading task plus (possibly)
a re-derivation — not a diffuse "tail control" any more.

---

## 3. Exact relationship to Bombieri 2000, Theorem 8

Evidence grade: everything about Bombieri's paper below is at **CITED
search-summary grade** (`AUDIT_WEIL_INDEX_ONE.md` §3.1–§3.2, queries 1/4/6,
three-way corroborated inside the corpus); nobody in this environment has read
the theorem's exact hypotheses. That caveat is itself risk R3 below.

**What Bombieri's fixed-support result gives.** For a *finite* symmetric
multiset of zeros and a *fixed-support* test space with the truncation
"big enough", the number of negative eigenvalues of his Hermitian matrix
equals the number of distinct complex-conjugate off-line pairs. Applied to
one off-line quartet (= two conjugate pairs) this is exactly the count our
obligations **O3 + O5** produce: two negative directions of $W$, i.e. the
algebraic core of Lemma TP's conclusion (v). The quartet mechanism is his,
not this corpus's — `AUDIT` §3.2 established that L1's "the genuine content
is the quartet" misidentified the delta for precisely this reason.

**What the unrestricted statement additionally needs — and which obligation
carries each item.**

1. **Infinite zero multiset instead of a finite model.** Bombieri counts
   eigenvalues assuming finitely many off-line zeros; Lemma TP controls the
   *actual* $Z$ by making every unselected zero a summable
   $\ell^2(Z,m)$-tail. Carried by: hypothesis (A2)(b) [decay at every zero],
   O1, O6, and conclusion (iv).
2. **No "truncation big enough" / no fixed support.** Bombieri's own
   §§10–11 (as rendered in `WEIL_INDEX_ONE.md` §4) explain the fixed-support
   limiting obstruction — with support capped, the finite matrix picture need
   not survive the limit. Lemma TP escapes by letting the localizers live in
   unrestricted $C_c^\infty$ (support free; this is the resource
   $\varepsilon$ presumably trades against, cf. O7b and the
   `PROLATE_BRIDGE.md` §11 budget $N \gtrsim T e^{T/2}$, which is the
   measured *cost* of fixed windows). "Big enough" becomes the explicit
   threshold $\varepsilon_1(E)$.
3. **Living inside $P$.** The index-one criterion needs the two positive
   directions of $I$ on a subspace where the pole form vanishes
   *identically*, so that $I|_V = -W|_V$; Bombieri's matrix model has no
   pole-vanishing constraint. Carried by: (A2)'s exact membership
   $\varphi \in P$ (O7d).
4. **Two-pair simultaneity by polarization.** An eigenvalue count of one
   fixed matrix is not the same act as *constructing two functions
   simultaneously* whose polarized cross terms are controlled; the nearly
   diagonal matrix inversion (O4) plus the polarized Cauchy–Schwarz (iv) is
   the extra step. This is also the precise sense in which the lemma is not
   a formal corollary of CC Appendix C either: the classical converse yields
   *one* violating direction, and $n_+ \le 1$ on every $V$ is strictly weaker
   than $I \preceq 0$ on $P$ — so the doubling is genuinely required
   (`AUDIT` §3.2, query 5 discussion; R0006 preservation ledger).

**Decision question, restated from `AUDIT` §3.4 because it decides the
lemma's status:** does Bombieri's Theorem 8 count survive without the
"finitely many off-line zeros" hypothesis? If his §§10–11 machinery already
removes it, Lemma TP is a repackaging; if not, the lemma (equivalently its
one open obligation O7, plus the assembled tail control) is the new content.
Nobody here has read the paragraph that answers this. The same unopened door
hides the June 2026 Suzuki unification (arXiv:2606.09096), which advertises
exactly the Yoshida + Bombieri + Connes–Consani union and may contain the
whole statement.

---

## 4. What this note does NOT do

- It does **not** claim Lemma TP. The lemma is stated conditionally on (A2),
  and (A2) is unverified testimony about an unopened proof.
- It does **not** upgrade R0006's status: proof obligation 1 of R0006
  ("hostile-audit the finite-point consequence of Connes–Consani Appendix C")
  remains open and is now sharpened into O7a–O7d.
- It does **not** assert the constants are optimal; $\|R\|$ and
  $\varepsilon_1$ are crude-but-explicit by design, so that O4–O6 can be
  formalized or interval-certified without analytic finesse.

---

## FILES

- `notes/INDEX_ONE_TAIL_LEMMA.md` — this note (new).
- Sources read in full: `collab/discovery/claims/R0006-weil-index-one-converse.md`,
  `notes/WEIL_INDEX_ONE.md`, `notes/AUDIT_WEIL_INDEX_ONE.md`,
  `notes/LP_CERT.md`, `notes/PROLATE_BRIDGE.md`, `notes/VV.md`,
  `notes/WEIL.md` §1 (normalization).

## STATUS

Extraction complete. Lemma TP stated standalone with hypotheses (A1)–(A3),
five conclusions, and named constants $C_E, S_E, K_z, K_E, \varepsilon_0,
\varepsilon_1$ with a full dependence ledger; the tail norm is
$\ell^2(Z,m)$ with weights = multiplicities, decay exponent $\kappa$
($\kappa = 2$ reported, $\kappa > \tfrac12$ sufficient). Obligations O1–O8
numbered and classified: O2, O3, O4, O5, O8 pure algebra (formalizable now);
O6 certified-computable per V2.5 (interval finite part + explicit RvM tail);
O1 standard analytic; O7 (the one-anchor localizer, = CC Appendix C
Prop. C.1 / Yoshida) genuinely analytic and the sole open core. The lemma is
NOT claimed.

## RISKS

- **R1 (dominant).** (A2) may be false as stated, or true with different
  constants/exponent/class than the corpus's paraphrase: the CC Appendix C
  page has never been read here (three audits blocked at the same door).
  Everything downstream of O7 inherits this.
- **R2.** O7d exactness: if the cited construction gives only approximate
  Mellin vanishing at $\{0,1\}$, conclusion (v) needs a pole-leak correction
  and the clean $I|_V = -W|_V$ identity fails as stated.
- **R3.** All Bombieri content is search-summary testimony; §3's delta could
  shrink to zero if Theorem 8's actual hypotheses are weaker than reported,
  or if Suzuki arXiv:2606.09096 already contains the unrestricted statement.
- **R4.** The $\varepsilon$-vs-support trade (O7b) may make
  $\varepsilon_1(E)$ practically vacuous for high quartets (large
  $|\gamma|$ ⟹ large $K_E$ ⟹ tiny threshold), which would matter for any
  quantitative refinement even though the qualitative lemma is unaffected.
