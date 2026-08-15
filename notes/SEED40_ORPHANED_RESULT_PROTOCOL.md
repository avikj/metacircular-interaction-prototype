# The orphaned-result protocol: what may be attributed, what may only be dated

**SEED-40, 2026-08-14.** No computation was run. §4 is proof; §1–3 are
protocol; §5 is the verdict table.

---

## 0. The situation, stated as a philologist would state it

Jayadeva's *cakravāla* (c. 950–1000 CE) does not survive. What survives is
Udayadivākara's *Sundarī* (1073), a commentary on Bhāskara I's *Laghubhāskarīya*,
which quotes some twenty verses of Jayadeva while solving an indeterminate
equation. Everything said about Jayadeva's method is said on the authority of a
later author quoting him for his own purposes. The scholarly discipline that
grew up around such cases is not scepticism — it is *grading*. One separates:

- what the witness lets us **reconstruct** (the algorithm: its steps, its
  invariant, its termination condition — recoverable with near-certainty,
  because the verses state operations, and operations are redundant);
- what the witness only lets us **date** (that a particular numerical example
  was worked, and worked to this value, in a text of this period);
- what the witness lets us **prove** (nothing; a quotation is not a proof, and
  Jayadeva's correctness theorem, if he had one, is not in the citation).

This repository is in exactly that position with respect to its own past. Some
660 `.py` files are legacy; `CLAUDE.md` (human owner, 2026-08-13) forbids
running them. A large part of `notes/` records numbers those scripts printed.
The original mode of verification is gone. The scripts are the *Sundarī*: a
partial witness, legible as text, produced for the author's own purposes,
quoting a result whose derivation was never written down.

The protocol below is what the analogy demands, made mechanical. Its point is
not piety. It is that **the three grades license three different sentences**,
and the corpus's recurring failure (`exp27`, `exp23`'s $c_2$, `exp26`'s
$\gamma_4$) has in every case been a sentence of the wrong grade.

---

## 1. The three grades

Let a *record* be a claim in `notes/` or `papers/` whose only support is a
legacy script and its recorded output.

### D — DATED

> *"A run of `code/exp13_energy.py`, at repository state $H$, on date $T$, with
> parameters $\Pi$, printed the value $x$."*

This is the only sentence a record supports without further work. It is a
statement about the repository's history, not about mathematics. It is true (or
falsifiable) as a matter of record-keeping, and it survives the ban, because
nothing about it requires the script to run again.

Three conditions for a claim to be **datable at all**:

- **D1 (legible witness).** The script text exists and is readable. A number
  whose producing script is deleted or unidentifiable is not dated; it is
  hearsay, and must be struck.
- **D2 (parameters recorded).** The value must be quoted with the arguments it
  was computed at — $X$, $Q$, band top $S$, window $L$, number of zeros. A bare
  constant cannot be dated, because there is no proposition to attach the date
  to. This is `CLAUDE.md`'s "a number without its $X$-dependence is worse than
  no number", restated as a bibliographic requirement rather than a
  methodological one.
- **D3 (primary witness).** The record must cite the run, not another note
  citing the run. Second-hand records (call them *O2*, below) are struck.

### A — ATTRIBUTABLE (as a conjecture, with provenance)

> *"Conjecture (exp13, 2026-08-XX): $C/D=\langle\rho\rangle_{|c|^2}$."*

A *statement* may be attributed to a run when the statement can be **read off
the code path**, independently of the output. This is the philologist's real
lever and it is worth being precise about why it works. Udayadivākara's verses
recover Jayadeva's *algorithm* with far more confidence than they recover any
number he computed, because an algorithm is *redundant*: its steps constrain one
another, and a corrupt step is visible as an inconsistency. A printed number is
not redundant. A single transcription error in a numeral is invisible.

So: **the definitions in a script are strong evidence; the numbers a script
printed are weak evidence.** Attribution therefore attaches to the *definition
and the claimed relation*, never to the value. Conditions:

- **A1.** The quantity's definition is recoverable from the source text alone
  (which loop, which weight, which truncation), and is restated in the note in
  mathematical language, so that the claim is checkable against a future proof.
- **A2.** The claim is stated as a conjecture, with the run named as its
  provenance and its grade marked.
- **A3.** No numeral appears in the statement of the conjecture. Numerals may
  appear only in the dated line beneath it.

A3 is the rule that would have stopped `exp27`. "The block constant runs like
$c\log^2Q$" is attributable; "$c=0.362$" was never anything but dated, and
$c=\tfrac14$ (`METHOD.md` §1) is what a page of algebra says.

### P — PROVED

Nothing. Absent a derivation in the current substrate, no record is ever
promoted to P by any amount of agreement, replication, or correlation. The one
exception `CLAUDE.md` already grants — exact/certified symbolic computation —
does not apply here, because such a computation is a mathematical object and is
not an orphan: it can be re-presented as a finite certificate and checked by
reading. `exp1/1b` and `exp7` are of that kind and are not covered by this note.

---

## 2. Orphan grades of the witness itself

| grade | witness | disposition |
|---|---|---|
| **O0** | script text present, parameters recorded, output recorded in the note that owns the result | datable; attributable if A1–A3 met |
| **O1** | output recorded, script missing / unidentifiable / superseded in place | **not datable** (fails D1); statement may be retained only if independently derivable, else struck |
| **O2** | the note records a value quoted from another note, which quotes the run | **struck on sight.** This is the `exp27` transmission path: $0.362$ entered two notes, a paper section, and a review round without anyone re-reading the run |

| **O3** | the script text present, but what it records is a **comparison**, not a value: the run compared its own float against a numeral quoted from elsewhere and printed a pass | **not datable as a value** (fails D2 in substance); the numeral is O2 with respect to its true source, and the run dates only the *agreement* |

> **O3 added (SEED-101, 2026-08-14, K1 — from `notes/SEED43_KAPPA_RESOLVENT_POLES.md`,
> written after this protocol).** The three grades above are **not
> exhaustive**, and the missing case is not exotic: SEED-43 §0 exhibits
> `exp47`'s check block, whose entries read
> `check("C6: (3-1/c1*)/2 = 0.8362503...", …)` — seven quoted digits compared
> against a computed float, with a boolean as the only output. Every grade
> above presumes the record's support is *a number the run produced*. Here the
> run produced no number; it produced a **pass**. That breaks the scheme in
> three places:
>
> - **D2 is satisfied on its face and violated in substance.** The parameters
>   are recorded, so the row looks datable — but the proposition being dated is
>   "the run agreed with `0.8362503`", which attaches the date to the
>   *comparison*, not to the constant. Quoting the constant on this witness is
>   a category error the D-grade as written does not catch.
> - **D3 misroutes it.** The record does cite the run, so it passes "primary
>   witness" — yet the numeral's provenance is whatever text the seven digits
>   were copied from, and *with respect to that source the record is O2*. A
>   numeral match is the O2 transmission path wearing the costume of a primary
>   witness, which makes it more dangerous than O2, not less.
> - **It is the one shape that looks like independent confirmation and is
>   not.** As SEED-43 puts it: a computed float against seven quoted digits
>   "certifies nothing about either side; it is an agreement of two numerals",
>   and it conceals the only structural question — where the number comes from
>   and what the next term is. In the κ case the answer was a closed form
>   (`κ = 3/2 − (1/√2)cot(1/√2)`), and the digits contained no trace of the
>   whole $\zeta(2n)$, $n \ge 2$ tail that the truncation had deleted.
>
> **Disposition for O3.** The permitted sentence is *"a run of `X` reported
> that its computation of $q$ agreed with the quoted value $v$ to $k$
> digits"* — and the obligation it creates is to name where $v$ came from,
> after which the record is graded against **that** source. Agreement of
> numerals is never grounds for promotion to A, and never grounds for treating
> $v$ as dated. The promotion path is unchanged and is §3 rule 4: derive the
> closed form, at which point the digits become a shadow it casts on demand
> rather than the thing itself.

The asymmetry to internalise: O2 is *not* a weaker version of O0. It is a
different failure. A quotation of a quotation carries the *appearance* of two
independent supports while having one, and it launders a dated number into a
constant. Every corpus disaster on record travelled this route.

---

## 3. Four rules that follow

1. **A run refutes nothing and proves nothing.** It can only *date a
   discrepancy*. A disagreement between two dated runs is a real object — it is
   evidence about the scripts — and it is a `PROVE` item, not a result.
2. **Confrontation is post hoc only.** A dated number may be used to check a
   derivation *after* the derivation exists (`METHOD.md` §1's licensed use;
   `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3.6). It may never be used to
   choose which derivation to attempt to believe.
3. **Reconstruct the algorithm before judging the number.** Where the script text
   is legible, read it as a text. Half the "discrepancies" in this corpus are
   convention differences visible in the source (`BLOCKS.md`'s own merge note:
   the $2.08$-vs-$1.0000$ mixed-block ratio was a factor of $2$ sitting on the
   other side). §4.3 below turns up a fresh instance: an ordered-vs-unordered
   summation convention that the witness's notation does not determine, and
   which moves $C/D$ by exactly $2$.
4. **Rederivation is the only promotion path**, and it is cheap. Every promotion
   in this corpus took less space than the run it replaced. §4 does one.

---

## 4. Two rederivations

### 4.1 `exp24`'s $\Lambda$ row is a theorem (three lines)

`FAMILY.md` §2.4 records: over $L\in\{2,\dots,30\}$ at $X=2\cdot10^6$, the best
depth-2 sieve-circuit advantage for the $\Lambda$ dressing is
"$1-\varphi(L)/L$ to 4 decimals at all 11 moduli". By `LENS_CIRCUIT.md`'s CRT
normal form the circuit is a union of residue classes mod $L$ and
$\mathrm{adv}_a(L)=\sum_c\max(d_a(L,c),0)$, where $d_a(L,c)$ is the excess of
the $a$-density in class $c$ over the uniform density $1/L$.

**Proposition S.** $\mathrm{adv}_\Lambda(L)=1-\varphi(L)/L+O_L(X^{-1/2+\varepsilon})$
under RH, and $=1-\varphi(L)/L+o(1)$ unconditionally.

*Proof.* $\Lambda$ is supported, up to the $O(\sqrt X\log X)$ prime powers, on
integers coprime to $L$; by the prime number theorem in arithmetic progressions
its mass is asymptotically equidistributed over the $\varphi(L)$ reduced classes.
So $d_\Lambda(L,c)=\tfrac1{\varphi(L)}-\tfrac1L>0$ for the $\varphi(L)$ reduced
classes and $=-\tfrac1L<0$ for the others. Summing the positive part:
$\varphi(L)\bigl(\tfrac1{\varphi(L)}-\tfrac1L\bigr)=1-\tfrac{\varphi(L)}{L}$.
The error is the PNT-in-AP error, $O_L(X^{-1/2+\varepsilon})$ under RH. $\square$

**Verdict.** The statement is now **P**. The run is demoted to illustration; the
"4 decimals" line is **D** and may be quoted only as a check of Proposition S,
which it passes ($X^{-1/2}=7\times10^{-4}$ at $X=2\cdot10^6$, so four decimals
is the *predicted* agreement, not a surprise). Note that the dated line, read
correctly, contains its own error bar — and nobody wrote it down. That is
`CLAUDE.md`'s standing complaint in its mildest form.

### 4.2 `exp13_energy`'s $C/D$: the identity, and its true scaling

`BLOCKS.md` Part I §3 records $D=2\sum_f|c_f|^2=6.036\times10^{-6}$,
$E(\eta)=\sum_{f\ne f',|f-f'|\le\eta}|c_fc_{f'}|\approx C\eta$ with
$C=8.66\times10^{-6}$, hence $C/D=1.44$; and derives from it $L^*=14.5$, the
"off-diagonal $\le6.5\%$ at $L=100$", and a "$2.3\%$ truncation tail beyond
$s=300$". `SWEEP.md` §2 already observed that $C/D$ has units of inverse
frequency, asserted that it therefore "scales like $T\log^2T$", and queued
(§3 item 3) a restatement of $L^*$ and the $6.5\%$ "as band-dependent
functions". Both halves of that instruction are addressed below; the second is
wrong.

Write $F_S=\{\gamma_i+\gamma_j:\ i\le j,\ \le S\}$ for the atom set, $m_f$ for
multiplicity, and take from Theorem D‴ the exact weight
$|c_f|^2=m_f^2\,2\pi f^{-5}$. Let $\rho(s)$ be the density of $F_\infty$ near
$s$, which the corrected pair-density computation gives as
$$\rho^{\mathrm{ord}}(s)=\frac{s}{4\pi^2}\,P(\ell),\qquad
P(\ell)=(\ell-1)^2+1-\zeta(2),\qquad \ell=\log\frac{s}{2\pi},$$
this being $\tfrac1{4\pi^2}\int_0^s\log\tfrac t{2\pi}\log\tfrac{s-t}{2\pi}dt$
evaluated by $t=su$ using $\int_0^1\log u\,du=-1$ and
$\int_0^1\log u\log(1-u)\,du=2-\zeta(2)$. (Same function as
`ENERGY_CONSTANT_EXACT.md`; consistent with `SWEEP.md` §1.1's stray-$\pi$
correction.)

**Lemma 1 (the identity).** For $1/\rho\ll\eta\ll s_{\min}$,
$$E(\eta)=2\eta\sum_f|c_f|^2\rho(f)+O(\eta^2)=D\,\eta\,\langle\rho\rangle_{|c|^2}
+O(\eta^2),\qquad
\langle\rho\rangle_{|c|^2}:=\frac{\sum_f|c_f|^2\rho(f)}{\sum_f|c_f|^2}.$$
*Proof.* $E(\eta)=\sum_f|c_f|\sum_{f'\ne f,|f'-f|\le\eta}|c_{f'}|$; on a window
of length $2\eta$ short enough that $|c|$ is constant to first order, the inner
sum is $|c_f|\cdot2\eta\rho(f)+O(\eta^2)$. Sum, and use $D=2\sum_f|c_f|^2$.
$\square$

So $C/D=\langle\rho\rangle_{|c|^2}$ exactly, confirming `SWEEP.md` §2's
identification — *and it is a density, so it must be quoted with the band it was
computed on*, which is the correct half of that entry.

**Lemma 2 (staircase: the fitted slope is an artifact).** For any finite band
$S<\infty$ the atom set $F_S$ is finite, so $\delta_S:=\min\{|f-f'|:f\ne f'\in
F_S\}>0$ and $E\equiv0$ on $[0,\delta_S)$. $E$ is a nondecreasing right-continuous
step function with at most $\binom{|F_S|}{2}$ jumps, constant above
$\operatorname{diam}F_S$. $\square$

Consequently a log-log slope fitted on $\eta\in[10^{-3},0.3]$ is a statement
about the empirical gap distribution in that window, and *the small-$\eta$ end
is the unreliable end*: linearity is a statement for $\eta$ **large** compared
with the local spacing, not small. `BLOCKS.md` §3 half-noticed this ("below
$10^{-2}$ the ratio wobbles $\sim2\times$; the $\eta=10^{-4}$ point rests on 20
pairs") and then §4 item 2 nonetheless recorded "measured linear with
$C/D=1.44$ over five decades". **There are no five decades**; there is a
staircase, whose lower cut-off is a property of the truncation and not of
$\zeta$. The measured exponent $1.10\ne1$ is that staircase.

**Theorem O (band law).** $\langle\rho\rangle_{|c|^2}$ converges as $S\to\infty$;
it does **not** grow like $T\log^2T$. Writing $u=\log(s/2\pi)$,
$$\sum_f|c_f|^2\ \longleftrightarrow\ \frac{1}{4\pi(2\pi)^3}\int P(u)e^{-3u}du,
\qquad
\sum_f|c_f|^2\rho(f)\ \longleftrightarrow\ \frac{1}{32\pi^3(2\pi)^2}\int P(u)^2e^{-2u}du,$$
both absolutely convergent at $u=\infty$; hence
$$\boxed{\ \frac CD=\langle\rho\rangle_{|c|^2}
=\frac{1}{4\pi}\cdot\frac{\int_{u_0}^{\infty}P(u)^2e^{-2u}\,du}
{\int_{u_0}^{\infty}P(u)\,e^{-3u}\,du}\ +\ O\!\bigl(S^{-2}\log^4S\bigr).\ }$$
*Proof.* The weight density is $2\pi s^{-5}\rho(s)\asymp s^{-4}\log^2s$ and the
numerator density $2\pi s^{-5}\rho(s)^2\asymp s^{-3}\log^4 s$; both integrate at
$\infty$, with tails $\Theta(S^{-3}\log^2S)$ and $\Theta(S^{-2}\log^4S)$
respectively. Substituting $s=2\pi e^u$, $ds=s\,du$, gives the stated
integrals; the prefactor is
$\bigl(\tfrac1{32\pi^3}(2\pi)^{-2}\bigr)\big/\bigl(\tfrac1{4\pi}(2\pi)^{-3}\bigr)=\tfrac1{4\pi}$.
$\square$

Both integrals are elementary. With $a=2-\zeta(2)=0.355066\ldots$ and
$P=u^2-2u+a$,
$$\int_x^\infty P e^{-3u}du=e^{-3x}\Bigl[\tfrac{x^2}{3}-\tfrac{4x}{9}-\tfrac{4}{27}+\tfrac a3\Bigr],$$
$$\int_x^\infty P^2e^{-2u}du=e^{-2x}\bigl[\tfrac12x^4-x^3+0.855066\,x^2+0.144934\,x+0.135503\bigr],$$
the coefficients being those of $P^2=u^4-4u^3+(4+2a)u^2-4au+a^2$ pushed through
$\int_x^\infty u^ne^{-2u}du$.

**Corollary O1 (the three dependent numbers).** $L^*=10\,(C/D)$ and
"off-diagonal $=5(C/D)/L$" are identities, as `SWEEP.md` §2 says. But since
$C/D$ **converges** with the band, they are genuine constants of the field, not
"band-dependent functions": `SWEEP.md` §3 item 3's instruction to restate them
as band-dependent is **withdrawn**. What is band-dependent is only the
truncation error, at the derived rate $O(S^{-2}\log^4S)$ — the same rate
`ENERGY_CONSTANT_EXACT.md` proves for $c(S)/c_\infty$, and for the same reason.

**Corollary O2 (the $2.3\%$ tail is a loose bound, not a value).** The tail of
$D$ beyond $S$ is $\Theta(S^{-3}\log^2 S)$ *absolutely*, against a total that is
$\Theta(1)$ and dominated by the bottom of the band. At $S=300$ against
$s_{\min}=2\gamma_1=28.269\ldots$ the model gives a relative tail of order
$10^{-3}$, not $2.3\times10^{-2}$. The dated $2.3\%$ is therefore an upper bound
(as its own parenthesis, "density-weighted $s^{-5}$ integral", in fact admits),
and must not be quoted as the truncation error.

**Theorem O′ (what $C/D$ actually is).** The weight $2\pi s^{-5}$ makes both
sums in $\langle\rho\rangle_{|c|^2}$ dominated by the *smallest* atoms. Hence
$C/D$ is not a statistical constant of the zero field at all: it is a finite
arithmetic constant determined, to any fixed precision, by the lowest few dozen
zeros — the same concentration-at-the-bottom that `METHOD.md` §3.5's Theorem 10
records for this weight, and the reason the D″ chain cannot be closed by any
asymptotic zero-statistics input.

This has a sharp methodological consequence, and it is the one that matters
here: **$C/D$ was never a measurement of a law.** It is a finite sum over
explicitly known zeros, i.e. precisely the kind of object `CLAUDE.md` permits as
*certified symbolic computation* — provided it is presented as a certificate,
with $s_{\min}$, the atom list, and the convention of Lemma 1 fixed. It was
instead presented as a fitted slope over "five decades", which is the one
presentation that cannot be checked.

### 4.3 A convention the witness does not determine

Lemma 1 assumed $\sum_{f\ne f'}$ runs over *ordered* pairs. If the script's loop
is over unordered pairs, every conclusion above holds with $C/D=\tfrac12
\langle\rho\rangle_{|c|^2}$. The note's notation ($f\ne f'$ under a single sum)
does not decide it, and the resolution is a matter of reading `code/exp13_energy.py`
as a text, not of running it. Until read, $C/D$ is determined by the corpus only
up to a factor of $2$ — which is, exactly, `BLOCKS.md`'s own merge note about
the mixed-block ratio $2.08$ vs $1.0000$, recurring.

Evaluating the boxed formula at bottom cut-offs $s_0=40$ and $50$ (where the
asymptotic density is first non-negative) gives $\langle\rho\rangle\approx5.0$
and $5.8$: the continuum model does **not** reproduce the dated $1.44$, and it
cannot be expected to, since $P(\ell)<0$ for $s<2\pi e^{1+\sqrt{\zeta(2)-1}}
=38.13\ldots$ — i.e. the asymptotic pair density is meaningless exactly where all
the weight sits. **Conclusion: $1.44$ stays DATED.** The route to promoting it is
a certified finite sum over the low zeros with the convention of §4.3 fixed, not
a better fit.

---

## 5. Verdicts on real records

| record | location | witness grade | verdict | what may be said |
|---|---|---|---|---|
| $\mathrm{adv}_\Lambda(L)=1-\varphi(L)/L$ | `FAMILY.md` §2.4 (`exp24_sievecontrol`) | O0 | **PROVED** (§4.1) | Quote Proposition S. The "4 decimals" line is D, usable only as a post-hoc check, which it passes at the predicted $X^{-1/2}$. |
| $C/D=1.44$; $L^*=14.5$; "$\le6.5\%$"; "$2.3\%$ tail"; "linear over five decades" | `BLOCKS.md` Part I §3–4 (`exp13_energy`) | O0 | **split.** Identity $C/D=\langle\rho\rangle_{|c|^2}$: **P** (Lemma 1). Band-convergence and $O(S^{-2}\log^4S)$: **P** (Thm O). Bottom-domination: **P** (Thm O′). The numeral $1.44$: **D only**, and ambiguous by a factor $2$ (§4.3). "Five decades of linearity": **struck** — structurally impossible (Lemma 2). "$2.3\%$ tail": **struck as a value**, retained as a loose bound (Cor. O2). $L^*$, $6.5\%$: identities in $C/D$, hence P-relative-to-$C/D$; the *instruction* to restate them as band-dependent is withdrawn (Cor. O1). |
| $\gamma_4=30.4256$ "at $0.002\%$" | `phase_side` §11, README banner (`exp26_fresnel_deep`, un-audited) | O0 | **DATED, and the claim struck.** `SWEEP.md` §1.5 shows the $0.002\%$ is cancellation of two $-0.063/-0.064$ inputs; the honest bar is the line rms $\approx0.12$ absolute. Permitted sentence: "a run of `exp26` reported $30.4256$"; forbidden: any precision claim. The escape of this number into a README banner is the O2 transmission failure, again. |
| "closure $2\times10^{-13}$" | `BLOCKS.md` Part I §1 (`exp11_blocks`) | O0 | **not a record at all.** `CROSSREVIEW_BLOCKS.md` relabelled it a sanity check: it verifies an identity that holds by construction. Theorem E2 is P on its own (explicit formula). Dating it is harmless; citing it as support is circular. |
| κ constants $0.6725007$, $0.8362503$, $1.3274992$ | `KAPPA.md` §3 Thm D (`exp47` check block) | **O3** (added above) | **numerals struck as results.** SEED-43 §§2–3 derives them: $\kappa = \tfrac32-\tfrac1{\sqrt2}\cot\tfrac1{\sqrt2}$ and $\kappa_{\text{distinct}} = \tfrac54-\tfrac1{2\sqrt2}\cot\tfrac1{\sqrt2}$, with $1/c_1^\* = \tfrac12+\tfrac1{\sqrt2}\cot\tfrac1{\sqrt2}$ — identities, so grade **P**, and the exp47 check block is retired rather than dated. Listed here as the calibration case for grade O3, the way $0.362$ is for O2. (Row added by SEED-101, 2026-08-14.) |
| block constant $0.362$–$0.421$ | `BLOCKS.md` §5.1 (`exp27_running`) — historical control | O2 by the time it reached the paper | **struck, 2026-08-13**; true value $\tfrac14$ (`METHOD.md` §1). Retained here only as the calibration case for grade O2. |

---

## 6. Honesty ledger

| # | item | status |
|---|---|---|
| S1 | Proposition S (§4.1) | **Proved**; error term is PNT-in-AP, RH-conditional only for the rate. |
| S2 | Lemma 1, Lemma 2 (§4.2) | **Proved**, elementary and unconditional given the atom set and D‴'s weight. |
| S3 | Theorem O, Corollaries O1–O2, Theorem O′ | **Proved conditional on the density model** — the corrected asymptotic pair density $\rho$, which is the same hypothesis (P) that `ENERGY_CONSTANT_EXACT.md` runs on. Not implied by RH. |
| S4 | The numerical evaluations $\approx5.0$, $5.8$ at $s_0=40,50$ | Elementary evaluation of a closed-form integral (exact antiderivatives given in §4.2), not a measurement. They are offered as a *falsification* of the continuum model at the bottom, not as a value of $C/D$. |
| S5 | The ordered/unordered factor of $2$ (§4.3) | **Open**, and resolvable by reading `code/exp13_energy.py` as text. Filed `DEMONSTRATE`. No conclusion above depends on it except the numeral. |
| S6 | Prior art | Not searched for Theorem O; the object is internal to this corpus (D‴'s weight against this corpus's atom set). Proposition S is standard and no novelty is claimed. `SEARCH` filed for O′'s "bottom-of-spectrum concentration" as a phenomenon, likely folklore in the moment-of-$\zeta'$ literature. |
| S7 | The protocol (§1–3) | Normative, not mathematical. Its only empirical claim is the O2 diagnosis of `exp27`/`exp26`, which is documented in `METHOD.md` §1 and `SWEEP.md` §1.5. |
