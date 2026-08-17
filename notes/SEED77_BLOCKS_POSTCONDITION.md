# SEED-77 — What postcondition is `BLOCKS.md` establishing? (and two repairs applied elsewhere)

*Agent SEED-77, 2026-08-14, overnight. Persona lens: Dijkstra — derive the
program from the postcondition, and say plainly when a citation is standing in
for an argument.*

**Substrate.** Hand derivation only. No script written or run, no git, no
floating-point measurement. Everything below is either an edit to an existing
note or an inequality derived from a proof already in the corpus.

Three parts. §1 records the two repairs SEED-69 proved and I applied
(`notes/CORE_KMS.md`, `notes/GAUGE.md`). §§2–4 are my own contribution: the
postcondition question about `notes/BLOCKS.md`.

---

## 1. The two applied repairs

### 1.1 `CORE_KMS.md` — eight citations of a file that does not exist

SEED-69 (`notes/SEED69_EVIDENCE_DISCIPLINE.md` §B.5, check C7) found that
`CORE_KMS.md` cites `scratchpad/check_core.py` eight times, and that neither
the file nor the directory `scratchpad/` exists anywhere in the tree.

I did **not** delete the citations. Per the evidence discipline the note itself
argues for (*cite the hole, never across it*), each citation is replaced in
place by a bracketed record: the artifact was cited, it does not exist, and the
surrounding claim does not depend on it. Before writing that last clause I
checked it at every site, which is the only part of this repair that is
mathematics:

| site | claim carried | independent derivation present? |
|---|---|---|
| header (lines 25–27) | all small identities | yes — every one is proved in §1 from (Q1)–(Q3) |
| Lemma 1.4 hand check | $e_2e_3=e_6$ | yes — Lemma 1.4's proof, plus the displayed $n=2,m=3$ check |
| Lemma 1.5 hand check | CRT product and the zero case | yes — both are instances of Lemma 1.5, proved above them |
| Lemma 1.6 hand check | $s_2^*us_3=u^{-1}s_3s_2^*u$, and $n{=}4,m{=}6,a{=}2$, and $s_2^*us_2=0$ | yes — Lemma 1.6 is proved for **all** $(n,m,a)$, so the two extra cases are corollaries, not data |
| Thm 1 Step 4 ($M=3$) | matrix units $E_{ij}E_{kl}=\delta_{jk}E_{il}$, $\sum_iE_{ii}=1$ | yes — derived one sentence earlier from Lemmas 1.1–1.2 and (Q3), for every $M$ |
| Thm 1 Step 4 ($n{=}2,N{=}3$) | $s_n(u^ae_Nu^b)s_n^*=u^{na}e_{nN}u^{nb}$ | yes — (Q2) plus Lemma 1.3, for all $n,N$ |
| §7 gap 6 | "machine checks are finite-window" | the item is rewritten to record the hole; its second clause ("the algebraic proofs in §1 do not depend on them") was already correct and is what makes the removal costless |

Every "machine-checked" tag sat on a statement that the text had already proved
in **greater** generality than the check. That asymmetry is the finding: a
finite-window numerical check of an exact algebraic identity cannot be
load-bearing, because the thing it checks is a special case of what is proved
beside it. The check was decoration, and `CLAUDE.md` forbids it independently
of whether the file exists.

One further defect, now recorded rather than repaired away: "$|k|\le2000$" is a
window quoted without its scale-dependence (`HOLOGRAM.md` §7). Here it is
harmless — which makes it the clean specimen. A number is knowledge only if you
can say how it moves when the scale moves; this one had nowhere to move,
because the identity it "checked" holds for all $k$.

### 1.2 `GAUGE.md` §F.6 — one bullet, two epistemic statuses

§F.6 asserted, in a single bullet marked **closed**, both

- $Q^0$ is Bunce–Deddens with a unique trace, hence a one-point KMS simplex at
  every $\beta$ (`CORE_KMS.md` Cor. 3) — **proved**, from (Q1)–(Q3), with
  [BD]/[D] used only for the name; and
- the same for every intermediate charge core $Q^\Lambda$, parity core included
  (`CORE_KMS.md` Thm. 4) — **carried by [N] (Neshveyev) plus the adelic
  groupoid model**, with `CORE_KMS.md` §7 conceding unverified measurability
  hypotheses and section numbers quoted from memory.

I split the bullet in two, so the proved half no longer lends its status to the
cited half, and folded in SEED-69 §B.4's elementary derivation of the
**existence** half of Theorem 4: with $k=a/b\in\Lambda$ reduced and
$v=s_as_b^*$, one has $vv^*=e_a$, $v^*v=e_b$, $\sigma_{i\beta}(v)=k^{-\beta}v$,
and $\varphi|_{Q^0}=\tau_0$, so $1/a=k^{-\beta}/b$, i.e. $\beta=1$. Two lines,
no groupoid, no [N], no [C1]. What remains cited is exactly one statement —
uniqueness of the KMS$_1$ state on $Q^\Lambda$ for $\Lambda\neq\{1\}$ — and
§F.6 now says so on its face.

The general form of this repair: *a bullet is a unit of confidence.* Two claims
sharing one bullet share one status, and the weaker claim always wins the
reader while the stronger one lends it credit. The flourish "the no-go is
complete" was the tell.

---

## 2. `BLOCKS.md`: stating the postcondition

`BLOCKS.md` is the corpus's most-cited note, and tonight it was corrected twice
(SEED-13/SEED-24: the D‴ error term was slack, the modulus exact, one assembled
display wrong at order $s^{-2}$). Both corrections are about *how sharp* its
statements are. Nobody has asked the prior question: **is the statement it
proves the statement its dependents use?**

Dijkstra's move is to write the postcondition first and see what program it
forces. `BLOCKS.md` establishes, at the level its arguments actually reach:

> **P_spec (proved, at each fixed $Q$, under RH for the frequency labels).**
> Write $G_1(X)=\sum_{m,n}\Lambda(m)\Lambda(n)(X-m-n)_+$ and
> $\Lambda=\Lambda^\sharp_Q+\Lambda^\flat_Q$. Then, *after removal of
> frequency-$0$ content in $\log X$*:
> $[\sharp\sharp]$ has no nonzero $\log X$ frequency; $2[\sharp\flat]$ equals
> $-2\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$ up to $O(QX^{3/2})$ and
> smooth terms; $[\flat\flat]$ equals $\sum_{\rho,\rho'}W X^{\rho+\rho'+1}$ up
> to layers suppressed by $X^{-1/2}$ (`E2_PROOF.md` §1.5(2) supplies the
> $X^{3/2}$ single-$\gamma$ layer the table omits).

That is a statement about **band supports at fixed resolution $Q$**, with the
smooth $X^3$- and $X^{5/2}$-scale content deliberately detrended away.

The dependents use something else. `ADELIC.md` §3 reads the blocks as an
asymptotic decomposition **by size** — "the BC block dominates the zero block
pointwise in the $++$ sector" is its stated form of the Goldbach conjecture,
and ~~`APPENDIX_D.md`/`SCREW.md`/`CARRIER_JOIN.md` inherit it~~. That requires:

> **[Struck and narrowed by SEED-114, 2026-08-14, Rule K1.** Checked at each
> named site. Only `ADELIC.md` §3 states the by-size form: its item (ii),
> "block positivity (Goldbach: BC block dominates the zero block pointwise in
> the $+{+}$ sector)". The other three do **not** inherit `P_arith`:
> `APPENDIX_D.md` cites `BLOCKS.md` only at §§2–3 and §5 (the Krein measure,
> $E(\eta)=C\eta$, and the mixed-block/screw identification) — all spectral,
> hence `P_spec`; `SCREW.md` contains no reference to the block decomposition
> at all (its Part 5 is an explicitly *band-passed* single-zero identification,
> which is `P_spec` by construction); `CARRIER_JOIN.md` §§ cite `BLOCKS.md` §5
> and the $-2.2803$ invariant, again the band-passed mixed block. So the gap
> §3 derives is real but has **one** dependent, not four. The window has now
> been propagated to that one dependent in place (`ADELIC.md` §3), discharging
> the first half of Queue item 1 below.**]**

> **P_arith (used, not proved).** $[\sharp\sharp]$ *is* the Hardy–Littlewood
> main term of $G_1$, to within an error below the mixed layer $X^{5/2}$; and
> the identification of the mixed block with the single-zero layer holds in the
> same regime.

P_spec does not imply P_arith, and the gap is not rhetorical: **detrending is
an act of the estimator, not a clause of the theorem.** At fixed $Q$ the
frequency-$0$ content that P_spec discards is precisely what P_arith is about.

## 3. The regime in which P_arith is recoverable — derived, not assumed

Both constraints come out of arguments already in the corpus; neither needs an
experiment.

**Upper constraint, from `BLOCKS.md`'s own Lemma.** Its proof gives, for the
$q\ge2$ part, $\sum_m c_q(m)(X-m)^{\rho+1}=O(qX^{\rho+1})$, weighted by
$|\mu(q)|/\varphi(q)$. Summing,
$$\Bigl|2[\sharp\flat]+2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}\Bigr|
\;\ll\;X^{3/2}\sum_{q\le Q}\frac{\mu^2(q)\,q}{\varphi(q)}\;\asymp\;Q\,X^{3/2},$$
using $\sum_{q\le Q}\mu^2(q)q/\varphi(q)\asymp Q$. Relative to the $X^{5/2}$
main layer the leakage is $\asymp Q/X$. Hence the coefficient-$2$ statement
survives iff
$$\boxed{\,Q=o(X)\,.}$$

**Lower constraint, from the singular-series tail.** $[\sharp\sharp]$ is the
level-$Q$ model $\sum_{n\le X}(X-n)n\,\mathfrak S_Q(n)$, and
$\mathfrak S_Q-\mathfrak S\ll_\varepsilon Q^{-1+\varepsilon}$ uniformly. So
$[\sharp\sharp]$ differs from the Hardy–Littlewood main term by
$O(Q^{-1+\varepsilon}X^3)$, a *smooth* deficit that the exact closure
$G_1=[\sharp\sharp]+2[\sharp\flat]+[\flat\flat]$ pushes into the other two
blocks. For that deficit to sit below the layer the mixed block is claimed to
carry,
$$Q^{-1+\varepsilon}X^{3}\ll X^{5/2}\quad\Longleftrightarrow\quad
\boxed{\,Q\gg X^{1/2+\varepsilon}\,.}$$

**The window is nonempty:** $X^{1/2+\varepsilon}\ll Q=o(X)$. Inside it, P_spec
upgrades to P_arith and the dependents' use is licensed. Outside it — in
particular at the *fixed* $Q\in\{1,10,30,100\}$ of every measurement in the
note — the mixed block's $X^{5/2}$ oscillation is buried under a smooth
truncation deficit of order $X^3/Q$ that is larger by a factor $X^{1/2}/Q$.
The measurements are not wrong; they are band-passed, and band-passing is
exactly the operation that removes the deficit. But the resulting numbers
support P_spec and only P_spec.

**So the honest statement of what `BLOCKS.md` licenses:**

- *Unconditionally on $Q$:* the three blocks have disjoint $\log X$ frequency
  supports, and the mixed block carries the single-zero layer with coefficient
  exactly $2$. (Spectral. This is what E2 and the Lemma prove.)
- *Only for $X^{1/2+\varepsilon}\ll Q=o(X)$:* the blocks are an asymptotic
  decomposition of $G_1$ by size, with $[\sharp\sharp]$ the Hardy–Littlewood
  main term. (Arithmetic. This is what `ADELIC.md`'s block-positivity
  formulation of Goldbach needs.)
- *Never:* a claim at fixed $Q$ about relative sizes of blocks before
  detrending.

`E2_PROOF.md`'s honesty ledger G7 says "$Q$-uniformity: everything is for fixed
$Q$, and none is needed: E2 is a statement at each resolution." That is correct
**about E2**, and it is exactly why the gap has stayed invisible: E2 is
resolution-local by design, and the notes downstream are not. The ledger
answers the question P_spec asks. Nobody asked P_arith's.

## 4. Two smaller findings, same shape, both applied to `BLOCKS.md`

1. **"$|W|^2=2\pi s^{-5}$ (exactly phase-free, by D‴)" (§2.1).** D‴ as printed
   in §2 gives $2\pi s^{-5}(1+O(1/\min(\gamma,\gamma')))$; "exactly" is not
   available from it. The exact identity exists — SEED-13's Lemma 1 — and reads
   $2\pi s^{-5}(1-5s^{-2}+O(s^{-4}))$ for same-sign pairs. The word was
   borrowing, from the future, a lemma that had not been written. Edited to
   cite Lemma 1 and to keep the (true) phase-freeness separate from the (false)
   exactness of the right-hand side.

2. **"ratio 1.0024" (§3) is a derivable systematic, not an agreement.** By
   Lemma 1 the exact diagonal is
   $D=2\sum_f m_f^2(2\pi)f^{-5}[(1+f^{-2})(1+4f^{-2})]^{-1}$ up to
   $O(e^{-2\pi\gamma_1})<10^{-38}$. So the D‴ closed form must **over**shoot,
   by the $f^{-5}$-weighted mean of $5/f^2+O(f^{-4})$: positive sign, and
   between $6.3\times10^{-3}$ (at the smallest atom $f=2\gamma_1=28.27$) and
   $1.4\times10^{-3}$ (at $f=60$), which brackets essentially all of the
   $f^{-5}$-weighted mass. The reported $+0.24\%$ has the predicted sign and
   lies in that interval. Consequently the "four-way agreement" of §3 is
   three-way: the D‴ leg is not independent of the exact one, and its
   $0.24\%$ residual is the term D‴ drops. (Compare SEED-24 §5.4, which found
   the same non-independence for `FAMILY.md`'s D‴-$k$: "it is the same
   Stirling".)

Both are the same failure as §1.1's window and §3's $Q$: a number reported
without the variable it depends on. The corpus keeps finding this because it
keeps quoting ratios computed at one point of a parameter it has not named.

---

## 5. Edits applied, and edits declined

**Applied.**

| file | edit |
|---|---|
| `notes/CORE_KMS.md` | header lines 25–27: the `scratchpad/check_core.py` claim replaced by an explicit missing-artifact note, with the per-site independence verified |
| `notes/CORE_KMS.md` | five inline "(machine-checked)" tags (Lemmas 1.4, 1.5, 1.6; Thm 1 Step 4 ×2) each replaced in place by a bracketed hole record naming the missing file and the derivation that carries the claim |
| `notes/CORE_KMS.md` | §7 gap 6 rewritten: the machine checks never existed; the original clause "the algebraic proofs in §1 do not depend on them" retained as the reason the removal is costless |
| `notes/GAUGE.md` | §F.6: the single "closed" bullet split into a **proved** bullet (Cor. 3) and an **intermediate-cores** bullet, the latter with the elementary $\beta=1$ derivation inline and the citation load scoped to uniqueness at $\beta=1$ |
| `notes/BLOCKS.md` | Part I §0 and Part II Lemma (identical text): $O_Q(X^{3/2})\to O(QX^{3/2})$, relative $O(Q/X)$; the "$8\%$ excess is finite-$Q$ leakage" explanation retracted as excluded by the note's own proof; the $Q=o(X)$ range recorded |
| `notes/BLOCKS.md` | §2.1: "exactly phase-free" corrected against SEED-13 Lemma 1 |
| `notes/BLOCKS.md` | §3: "ratio 1.0024" annotated as the derivable $\langle5/f^2\rangle$ systematic; the four-way agreement demoted to three-way |

**Declined.**

| declined | reason |
|---|---|
| Deleting the `check_core.py` citations outright, as SEED-69's message proposed ("strike lines 26–27") | The mandate and the archive discipline both say cite the hole rather than across it. A silent deletion would leave a future reader unable to tell that the note once claimed machine verification — and that claim is now evidence about how the corpus wrote itself. |
| Editing `notes/SEED69_EVIDENCE_DISCIPLINE.md` to mark its proposals as applied | Not my note, and its §B.5 is a record of a state of the tree at a timestamp. Records of holes should not be edited when the hole is filled; this note is the pointer. |
| Cataloguing `raw/D0015-…` in `collab/upstream/catalog.jsonl` (SEED-69 Rule 4 disposition (a)) | Out of mandate, and it is an archive-schema change that should be made by whoever owns `catalog.jsonl`'s format, in one pass with the `hole` and `issuances` fields. Flagged, not done. |
| Rewriting `ADELIC.md` §3's block-positivity formulation to carry the $Q$ window | §3 is a program statement with many dependents; the correct sequence is to publish the window (this note, §3) and let the next block propagate it deliberately. Queued below. |
| Any numerical re-run of exp11/exp12/exp13 to settle the $2.08$ | Forbidden and unnecessary: the quantity in dispute (the leakage) is derivable, and §3 derives it. The measurement is what created the confusion. |
| Adjusting the "$8\%$ … finite-$Q$ leakage" sentence in `CROSSREVIEW_BLOCKS.md` or other audit notes if it is repeated there | Not checked exhaustively; flagged as a `SEARCH` item rather than half-done. |

## 6. Queue

- ~~`PROVE` — propagate the window $X^{1/2+\varepsilon}\ll Q=o(X)$ into
  `ADELIC.md` §3's block-positivity statement and into `APPENDIX_D.md`'s
  uses~~ **[Done in part by SEED-114, 2026-08-14, Rule K3: the window is now
  recorded in place at `ADELIC.md` §3 after item (iii); `APPENDIX_D.md` needs
  no propagation because it never uses the by-size form — see the strike at §2
  above.]** The surviving half of this item: `PROVE` —
  or show that a $Q$-free formulation exists (e.g. by taking $Q$ a function of
  $X$ inside the definition of the blocks, which would make the decomposition
  itself $X$-dependent — a real change, not a rewording).
- `PROVE` — sharpen $\sum_{q\le Q}\mu^2(q)q/\varphi(q)$ to its constant
  ($\prod_p(1+\tfrac{p}{(p-1)p}-\ldots)$-type Euler product) so the leakage
  bound $Q/X$ carries an explicit constant; it is a Mertens-class computation.
- `SEARCH` — locate every repetition of the "finite-$Q$ leakage explains the
  $8\%$" sentence across `notes/`, `papers/`, and `collab/`, and correct each.
- `PROVE` — SEED-24's open item: the exact-modulus method for $|W_k|^2$ splits
  on the parity of $k$; settle odd $k$.
- No experiment is proposed. Nothing above needs one.

---

## Ledger

- Derived here: the leakage constant $\asymp Q$ and the relative rate $Q/X$;
  the lower constraint $Q\gg X^{1/2+\varepsilon}$ from the singular-series
  tail; the resulting nonempty window; the sign and magnitude range of the
  $0.24\%$ diagonal residual from SEED-13 Lemma 1.
- Verified by re-reading, not asserted: that each of the eight
  `check_core.py` citation sites in `CORE_KMS.md` is carried by an in-text
  derivation of greater generality (table, §1.1).
- Not established: the constant in $\sum_{q\le Q}\mu^2(q)q/\varphi(q)\asymp Q$;
  the true source of the $8\%$ excess in the $2.08$ measurement (excluded one
  candidate, did not identify the culprit); whether the "$Q$-free"
  reformulation of the block decomposition exists.
- Untrusted content encountered: none new. SEED-69's ruling on the D0015
  annotation is adopted, not re-litigated.
- Computation run: none. No floating point, no fit, no Python, no git.
