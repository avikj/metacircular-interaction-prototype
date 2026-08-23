# Triage: which experiments earned their keep, and the proof queue they generate

Companion to `CLAUDE.md` (the binding rule). This is the audit of the
branch's own method, plus the first proof it produced.

## 1. Proposition M1 — the running law, proved (correcting exp27)

`BLOCKS.md` §5.1 reported the $[\sharp\sharp]$ block constant of
$T(X)=\sum_{n\le X}(\Lambda*\Lambda)(n)/n^2$ as growing like
$0.362\log^2Q$ (LSQ) or $0.421\log^2Q$ (mean extraction), and the auditor
correctly called the sub-coefficients method-sensitive. Both numbers are
wrong. The coefficient is exactly $\tfrac14$.

**Proposition M1.** With $\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q$
and $A(Q):=\Lambda^\sharp_Q(1)=\sum_{q\le Q}\frac{\mu^2(q)}{\varphi(q)}$,
$$[\sharp\sharp](T)\text{-constant}
=\frac{A(Q)^2}{4}+2A(Q)\,S(Q)+O(1),
\qquad S(Q)=\sum_{m\ge2}\frac{\Lambda^\sharp_Q(m)}{(1+m)^2},$$
and consequently, since $A(Q)=\log Q+C+o(1)$ with
$C=\gamma+\sum_p\frac{\log p}{p(p-1)}=1.3326\ldots$ (Ward; Montgomery–Vaughan)
and ~~$S(Q)\to S_\infty=\sum_{m\ge2}\Lambda(m)/(1+m)^2$ (Hardy's Ramanujan
expansion of $\Lambda$, termwise for fixed $m$)~~
**[CORRECTED — see `notes/E2_PROOF.md` §2.2: the termwise limit of the
Ramanujan expansion is $\tfrac{\varphi(m)}{m}\Lambda(m)$, not $\Lambda(m)$;
the factor $\varphi(m)/m$ was dropped here]**
$$S(Q)\to S_\infty=\sum_{m\ge2}\frac{\varphi(m)}{m}\frac{\Lambda(m)}{(1+m)^2}=0.257780\ldots$$
$$\boxed{\ [\sharp\sharp]\text{-constant}=\tfrac14\log^2Q
+\bigl(\tfrac{C}{2}+2S_\infty\bigr)\log Q+O(1),\qquad
\tfrac{C}{2}+2S_\infty=1.181852\ldots\ }$$
**The printed linear coefficient was $1.388949$; the correct value is
$1.181852$.** The leading $\tfrac14$ is untouched — it comes from the single
term $n=2$, where $A(Q)^2/4$ is exact. The exact-rational computation
already in this section contained the refutation and was misread:
$S(Q)=0.2513,\,0.2560,\,0.2663,\,0.2587$ at $Q=10,30,60,120$ converges to
$0.2578$, nowhere near $0.3613$.

*Proof.* $T$'s block constant is $\sum_{n\ge2}(\Lambda^\sharp_Q*\Lambda^\sharp_Q)(n)/n^2$.
Split the convolution by whether each argument equals $1$. The $(1,1)$ term
sits at $n=2$ and contributes $A(Q)^2/4$. The terms $(1,m)$ and $(m,1)$,
$m\ge2$, contribute $2A(Q)\sum_{m\ge2}\Lambda^\sharp_Q(m)/(1+m)^2=2A(Q)S(Q)$.
The remaining terms have both arguments $\ge2$ and are $Q$-bounded, giving
$O(1)$. The stated asymptotics of $A$ and $S$ are classical. $\square$

*Numerical confirmation of the derivation* (a licensed use — checking a
proof, not fitting): $A(Q)$ against $\log Q+C$ agrees to four digits
($8.2400$ vs $8.2403$ at $Q=1000$), and the residual
$[\sharp\sharp]-\bigl(A^2/4+2AS\bigr)$ is flat across $Q\in[10,1000]$ — the
predicted $O(1)$. ~~flat at $\approx9.0$~~ **[CORRECTED: recomputing the
residual from the formula printed above against the $[\sharp\sharp]$ values
published in `BLOCKS.md` Part I §5.1 gives $\approx-3.1$
($-3.493,\,-2.881,\,-3.066$ at $Q=10,30,120$), not $+9.0$. The substantive
claim — flatness, hence $O(1)$ — is confirmed; the value was wrong. Either
exp27 normalises $T(X)$ differently from this formula or the number was
simply mis-transcribed; unresolved, `E2_PROOF.md` ledger H5.]**

**The $O(1)$ is now half-explicit, and the flagged gap below named the
wrong lemma.** `E2_PROOF.md` §2.5 resolves the constant into
$\gamma-\sum_p\frac{\log p}{(p-1)^2}=-0.649753\ldots$ plus a residual
$\mathcal E(Q)$ proved $\ll\log^2Q$ unconditionally and conjecturally
$O(1)$, giving constant term $\tfrac{C^2}{4}+2CS_\infty+\gamma-B
=0.430870\ldots+\lim\mathcal E(Q)$.

**Why the fits failed.** Over $\log Q\in[1.6,4.8]$ — one decade — a genuine
$\tfrac14L^2+1.18L+9$ is fitted by a pure quadratic as $\approx0.36L^2$,
because the linear term has nowhere else to go. Nine points cannot separate
$L^2$ from $L$ over one decade. This is the whole lesson in one number.

**Gap flagged honestly** ~~Making the $O(1)$ term itself explicit needs
uniform (in $m$ and $Q$) control of $\Lambda^\sharp_Q(m)$~~
**[RE-DIAGNOSED — `E2_PROOF.md` §2.3–2.4. Two things are now known that
this paragraph got backwards.**

*(i) The pointwise non-uniformity is exact, and it is the Mertens
function.* Not "partial sums are not uniformly bounded" as a folklore
gesture, but the identity $\Lambda^\sharp_Q(P_Q)=M(Q)=\sum_{d\le Q}\mu(d)$
holding exactly for every $Q$, attained at $n\equiv0\bmod P_Q$. With
Odlyzko–te Riele this gives $\sup_n|\Lambda^\sharp_Q(n)|\gg Q^{1/2}$
infinitely often, unconditionally.

*(ii) That failure is irrelevant here.* The bad $n$ all satisfy
$n\ge P_Q$, which the weight $n^{-2}$ annihilates: $S(Q)\to S_\infty$
regardless. The actual obstruction to an explicit constant is an
incomplete-interval **bilinear** cancellation bound on the off-diagonal
Fourier form (Hypothesis U), which is neither implied by nor equivalent to
pointwise uniformity. Naming the wrong lemma is itself the kind of
untracked obligation catalogued in `notes/OBLIGATION.md`.**]

The two leading coefficients are unconditional.

## 2. The triage

**Revised standard** (`CLAUDE.md`, second version): only *exact/certified
symbolic* computation counts as legitimate — it is proof. Floating-point
measurement never is. Under that standard the verdicts below tighten: the
score drops from 5/30 to **2/30**, and the two survivors (`exp1/1b`,
`exp7`) are certified symbolic computations, not numerics at all.
Re-verdicts: `exp5` (zero statistics) was rediscovery of
Montgomery–Odlyzko; `exp12`'s refutation follows from D‴ once derived;
`exp42`'s content is the noise floor, which Lemma N derives in one line
(`HOLOGRAM.md` §7).

| experiment | verdict | what should have happened |
|---|---|---|
| exp1/1b irreducibility to degree $2\cdot10^4$ | **certified symbolic — proof** | (nothing; this is the standard) |
| exp7 prime-race tie scan | **certified symbolic — proof** | (exhaustive finite verification) |
| exp5 GUE/Poisson zero statistics | — | rediscovery of Montgomery–Odlyzko; cite, don't measure |
| exp42 blind zero extraction | — | its content is the noise floor, which Lemma N derives in one line (`HOLOGRAM.md` §7); the demo illustrates a theorem rather than establishing one |
| exp12 (Krein positivity fails) | — | non-positivity is immediate from D‴ once derived (phases equidistribute); Stirling for the rest |
| exp11 block spectral support | — | two lines from the explicit formula (now Theorem E2's own proof) |
| exp13 D″ constants | — | the diagonal is closed-form once D‴ is known |
| exp15/16/18/20 trace formulas | — | direct explicit-formula substitutions; "corr 0.9999" added nothing |
| exp17/22/30 Cornu, $k$-body, coherence excess | — | all one stationary-phase computation (Theorem I2) |
| exp21/24 fingerprints, sieve advantage | — | $1-\varphi(L)/L$ is a one-line computation |
| exp23 screw join | — **and harmful** | the block attribution is derivable; the measurement introduced the false $c_2$ that had to be retracted |
| exp25 divisor null | — | $\zeta^2$ has double zeros, so residues vanish: that *is* the proof |
| exp27/28 scheme running | — **and wrong** | Proposition M1 above; the published coefficient was an artifact |
| exp29 L-tower statistics | — | the $\Gamma$-law is conductor-blind by I2; the statistics were underpowered anyway |
| exp31 capacity, exp41 superresolution | — | composition of laws / imported theorem; verification optional |

**Score: 2 of ~30 under the revised standard** (`exp1/1b`, `exp7` — both
certified symbolic, i.e. proof rather than measurement). Two experiments
produced errors that had to be retracted (`exp23`'s $c_2$, `exp27`'s
coefficient), and one (`exp6b`/`exp41`) supplied an empirical constant
that was hiding its own scaling law — the most expensive of the three,
since Lemma N shows deriving it changes the depth-law exponent
(`HOLOGRAM.md` §7). Measurement did not merely waste effort here; three
times it put wrong numbers into the record.

## 3. The proof queue this generates

Tagged `PROVE`, worked in order before any new computation:

1. **BARRIER Structure Proposition → theorem.** WL observables factor
   through the blurred spectral measure. This is the single statement that
   would convert the depth law from a measured scaling into a barrier
   theorem. Ingredients: explicit formula per factor + absolute convergence
   after one smoothing; the work is uniformity in the window.

   **[2026-08-22 — the item does NOT split into a formal half and an analytic
   half, and this is the session's finding. Tagged THEOREM (the formal
   statements) + REJECTED (the proposed split).]**

   The proposal was: the analytic half (WL observables *do* factor through the
   blur) stays open, and the second half (once they do, no refinement recovers
   the fibre) is already available from
   `formal/cubical/Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart.agda`,
   which removed `Bool` from `NaturalMachine.QuotientFiberLaw` and left the
   negative half over an arbitrary answer type with an arbitrary irreflexive
   separation.

   **It does not apply.** `Vaidharmya`'s `AllBlind` demands that blind queries
   return **equal** answers — its own header says "not close, equal" — because
   the entire proof is `cong decide` applied to an equality of transcripts.
   The analysis does not deliver equality. `BARRIER.md` Corollary B2 asks only
   that $\sigma_k-\sigma_k'$ be annihilated at resolution $2\pi/L$, mismatch
   $O((\delta L)^{2p-1})$; `BARRIER_ERROR_WINDOW.md` Theorem U1 leaves
   $E=k\,D_a(0)e^{-u/2}\mathcal Z_{k-1}+O(e^{-u})$, configuration-dependent
   through $\mathcal Z_{k-1}$; `BARRIER_SMOOTH_TERM.md` leaves
   $\mathrm{Smooth}$ larger still. Transcripts are **close, never equal**, and
   `cong` fires on nothing.

   **What was proved instead** (`formal/cubical/Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap.agda`,
   Agda 2.8.0, `--cubical --safe`, no postulates, no holes, EXIT=0, wired into
   `Everything.agda`):

   - **THEOREM (§२, the near-law).** With equality replaced by an arbitrary
     tolerance `_≈_`, the obstruction survives **iff** two hypotheses are
     paid: the decoder *respects* the tolerance, and the tolerance excludes
     the separation.
   - **THEOREM (§३).** At `_≈_ := _≡_` the first hypothesis is inhabited for
     *every* decoder, by `cong`. That is exactly the hypothesis `Vaidharmya`
     never had to state and the one the analytic setting must now pay for.
   - **REJECTED (§४, a checked counterexample).** Near-blindness *alone* —
     with the arbitrary, even non-computable $\Phi$ that `BARRIER.md`
     Proposition B3 insists on — obstructs **nothing**. Two states, one query,
     answers 1 and 0, tolerance "differ by at most one": the pair is
     near-blind and the head decoder separates it.

   **So the analytic barrier lemma must supply exactly one of two things, and
   there is no third:** (a) *exact* layerwise agreement — B2′ of
   `BARRIER_SMOOTH_TERM.md`, which is strictly stronger than B2 and is not
   implied by sub-resolution moment matching; or (b) a **modulus on $\Phi$**,
   a bound on how far a WL post-processing may amplify a sub-resolution
   difference. **B3 as written rules out (b) by construction — its generality
   is what kills the ε-version of its own corollary.** That collision is a
   missing distinction in the WL *definition*, not a failure to resolve, and
   naming it is what this item now hands the analytic lane.

   Item 1 therefore stays **open**, with its residual content sharpened to:
   prove B2′, or add a bandwidth-derived modulus to Definition WL and re-derive
   B3 with it.
2. ~~**Theorem I1 prior art.** Elementary Laplace/integral-domain argument;
   almost certainly known for measures. Search before claiming.~~ —
   **RESOLVED** (`notes/INVERSE.md` §1): known via Titchmarsh's convolution
   theorem (integral-domain factorization on a half-line), with full
   attribution (Titchmarsh 1926; Weiss 1968; Gerth–Hofmann et al. 2014;
   Gorenflo–Hofmann 1994; Lambek–Moser; Selfridge–Straus 1958). The neither-
   growth-nor-$c>0$ hypotheses were shown unnecessary. **Off-diagonal
   sub-item now also closed, negatively** (`notes/OFFDIAGONAL_NO_GO.md`,
   2026-08-18): the diagonal-free pair layer does *not* determine the
   configuration — Prouhet/Thue–Morse infinite counterexample.
3. ~~**Theorem E2 proof written out.** Currently justified by a correlation of
   1.0000; it is a two-line consequence of the block-wise explicit formula.
   Write the two lines and demote exp11 to illustration.~~ — **RESOLVED**
   (`notes/E2_PROOF.md` Part 1; two pole-lemmas, no numerics load-bearing).
4. ~~**The $O(1)$ in M1**, given uniform control of $\Lambda^\sharp_Q(m)$.~~ —
   **RESOLVED / RE-DIAGNOSED** (`notes/E2_PROOF.md` §§2.3–2.5): the two
   leading coefficients are unconditional; the remaining explicit $O(1)$ turns
   on a bilinear cancellation bound (Hypothesis U), *not* on pointwise
   uniformity of $\Lambda^\sharp_Q(m)$ (which fails — it is the Mertens
   function — but is annihilated by $n^{-2}$).
5. ~~**D″ off-diagonal bound** via Tao–Trudgian–Yang $N^*$~~ — **RESOLVED AND
   RETIRED AS POSED** (`notes/DPP.md`). The limit exists unconditionally, the
   Ω-result is unconditional, $V_\infty\asymp D$ is a theorem, and
   $V_\infty=D$ iff the sum spectrum is simple. The TTY route is a **category
   error** (their additive energy lives on zeros off the critical line — empty
   under RH) and, more fundamentally, **Theorem 10 proves no asymptotic
   zero-statistics input can decide it**: the exact weight $2\pi s^{-5}$
   concentrates the sum at the *bottom* of the spectrum. Replacement item: a
   certified finite separation check below $Y\approx5\times10^5$, or a
   quantitative separation exponent.
6. ~~**Name and bound the $\mathrm{Smooth}$ term of B1**~~ — **RESOLVED**
   (`notes/BARRIER_SMOOTH_TERM.md`, generated by `BARRIER_ERROR_WINDOW.md`
   ledger V7). $\mathrm{Smooth}$ is not a bucket of smooth functions: it is
   the $r\ge1$ slice of a ladder graded by level
   $\nu=r(2\theta_a-1)-m$, whose top is the main term and whose leading
   *oscillating* layer exceeds the $k$-fold wave layer by
   $X^{(k-1)(\theta_a-1/2)}$ — for $a=\Lambda$ the $k$-fold signal is buried
   $X^{(k-1)/2}$ deep, for $\lambda$ it is degenerate at the same scale, for
   $\mu$ the bucket is empty. Consequences: **Corollary B2 of `BARRIER.md` is
   false as stated** for $\Lambda$, $k\ge2$ (corrected form B2′ demands every
   lower-arity layer at precision $\epsilon X^{-r/2}$); **B1″ has no
   single-endpoint uniform closure** ($E$ is anchored at the window's bottom
   $X_0$, $\mathrm{Smooth}$ at its top $X$); and the $d$ row of Theorem U1 is
   wrong, $\alpha=\tfrac12$ failing for $a=d$, $k\ge2$. $\alpha=\tfrac12$
   survives for $E$ and for $\Lambda,\mu,\lambda$. Remaining sub-item: the $d$
   case needs the functional equation, not a contour shift — recommend
   striking $d$ from the scope of B1/B1′/B1″/U1 rather than repairing it.
