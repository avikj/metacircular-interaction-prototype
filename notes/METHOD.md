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
and $S(Q)\to S_\infty=\sum_{m\ge2}\Lambda(m)/(1+m)^2$ (Hardy's Ramanujan
expansion of $\Lambda$, termwise for fixed $m$),
$$\boxed{\ [\sharp\sharp]\text{-constant}=\tfrac14\log^2Q
+\bigl(\tfrac{C}{2}+2S_\infty\bigr)\log Q+O(1).\ }$$

*Proof.* $T$'s block constant is $\sum_{n\ge2}(\Lambda^\sharp_Q*\Lambda^\sharp_Q)(n)/n^2$.
Split the convolution by whether each argument equals $1$. The $(1,1)$ term
sits at $n=2$ and contributes $A(Q)^2/4$. The terms $(1,m)$ and $(m,1)$,
$m\ge2$, contribute $2A(Q)\sum_{m\ge2}\Lambda^\sharp_Q(m)/(1+m)^2=2A(Q)S(Q)$.
The remaining terms have both arguments $\ge2$ and are $Q$-bounded, giving
$O(1)$. The stated asymptotics of $A$ and $S$ are classical. $\square$

*Numerical confirmation of the derivation* (a licensed use — checking a
proof, not fitting): $A(Q)$ against $\log Q+C$ agrees to four digits
($8.2400$ vs $8.2403$ at $Q=1000$), and the residual
$[\sharp\sharp]-\bigl(A^2/4+2AS\bigr)$ is flat at $\approx9.0$ across
$Q\in[10,1000]$ — the predicted $O(1)$.

**Why the fits failed.** Over $\log Q\in[1.6,4.8]$ — one decade — a genuine
$\tfrac14L^2+1.18L+9$ is fitted by a pure quadratic as $\approx0.36L^2$,
because the linear term has nowhere else to go. Nine points cannot separate
$L^2$ from $L$ over one decade. This is the whole lesson in one number.

**Gap flagged honestly.** Making the $O(1)$ term itself explicit needs
uniform (in $m$ and $Q$) control of $\Lambda^\sharp_Q(m)$; partial sums of
Ramanujan expansions are not uniformly bounded, so the constant term is
stated as $O(1)$ and not evaluated. The two leading coefficients are
unconditional.

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
| exp1/1b irreducibility to degree $2\cdot10^4$ | **S** — justified | (certificates have no closed form) |
| exp7 prime-race tie scan | **S** — justified | |
| exp5 GUE/Poisson zero statistics | **D** — justified | genuinely empirical |
| exp42 blind zero extraction | **E** — justified | cannot be proved; it is a demonstration |
| exp12 (Krein positivity fails) | **R** — half justified | the refutation is real; the *law verification* half was Stirling |
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
2. **Theorem I1 prior art.** Elementary Laplace/integral-domain argument;
   almost certainly known for measures. Search before claiming.
3. **Theorem E2 proof written out.** Currently justified by a correlation of
   1.0000; it is a two-line consequence of the block-wise explicit formula.
   Write the two lines and demote exp11 to illustration.
4. **The $O(1)$ in M1**, given uniform control of $\Lambda^\sharp_Q(m)$.
5. **D″ off-diagonal bound** — the one genuinely hard analytic item
   (Tao–Trudgian–Yang $N^*$ input with weight $2\pi s^{-5}$). This is where
   effort belongs.
