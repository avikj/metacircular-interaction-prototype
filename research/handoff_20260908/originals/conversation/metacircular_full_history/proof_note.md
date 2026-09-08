# The full source-coherent nonlinear kernel: algebra, exact elimination, certified summation, and the RH instance

Date: 2026-09-08.
Repository read pin: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note gives the full recursive mechanism rather than another separately computed angular interaction. It distinguishes: (i) formal identities of generators; (ii) convergent local mild-solution identities; (iii) the repository's actual proof-installation language. No global Navier–Stokes regularity or RH proof is asserted, no repository files were changed, and no Agda/Lean build was run. The executed Python controls use exact symbolic arithmetic, not time-stepping simulations.

Repository sources read:

- `formal/cubical/kernel/TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`: the actual derivation-emitting arithmetic-term normalizer, `learn t = install (normalize t)`.
- `formal/cubical/kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda`: substitution and one-hole context transport of derivations, and `Operation.apply-checked`. Its literal source language is not a PDE language; no automatic PDE encoding is claimed.
- `formal/lean/Pairfield/DependentRootedHistoryFiber.lean`: endpoint-fixed rooted histories retain dependent payload over their compatible prefixes.
- Previously read `ExcursionReturn.agda`, `ObservabilityQuotient.agda`, and saved Prime-Pair Delta 19: the compression/memory algebra and its precise scope.
- Saved `/mnt/data/toroidal_first_return/proof_note.md`: the actual toroidal 2->4->2 coefficient, retained without rederivation.

Classical analytic context: Gouasmi–Parish–Duraisamy, arXiv:1611.06277, makes the distinction between true orthogonal dynamics and a substituted composition operator explicit. Infinite Carleman realizations have their own functional-analytic hypotheses; see Heinzelreiter–Pearson, arXiv:2510.00722. The proofs below do not rely on an unproved global Carleman convergence assertion.

## 1. Fix the common source and the exact quadratic interaction

On R^3, take sufficiently smooth divergence-free vorticity with finite-energy velocity

\[
 u_a=\operatorname{curl}(-\Delta)^{-1}a,
 \qquad
 \mathcal B(a,b)=\tfrac12\operatorname{curl}(u_a\times b+u_b\times a).
\]

Then

\[
 F(\omega)=\nu\Delta\omega+\mathcal B(\omega,\omega),
 \qquad
 DF(\omega)v=\nu\Delta v+2\mathcal B(\omega,v).
\]

The symmetric bilinear map is intrinsic to the quadratic diagonal. Every differentiation of a common source differentiates both of its occurrences.

For a periodic realization with nonzero wave vectors k and Fourier convention curl = i k cross, the primitive interaction is

\[
\widehat{\mathcal B(a,b)}_k
=\frac{ik\times}{2}
\sum_{p+q=k}
\left[
 \left(\frac{ip\times\widehat a_p}{|p|^2}\right)\times\widehat b_q
+
 \left(\frac{ip\times\widehat b_p}{|p|^2}\right)\times\widehat a_q
\right].
\]

Zero velocity modes, when present, must be retained separately. The checks use mean-zero periodic sources. The whole-space realization uses the convolution integral under the corresponding Fourier normalization; its angular projection is not replaced by a periodic one.

## 2. The source-coherent linear lift and its product law

For smooth polynomial/cylinder observables h, define

\[
 (\mathscr Lh)(\omega)=Dh(\omega)[F(\omega)].
\]

It is linear and is a derivation:

\[
 \mathscr L(hk)=(\mathscr Lh)k+h(\mathscr Lk).
\]

Induction gives the exact all-order law

\[
 \mathscr L^n(hk)
 =\sum_{j=0}^n\binom nj(\mathscr L^j h)(\mathscr L^{n-j}k).
\]

Consequently the formal exponential preserves products. Where the classical flow exists, its pullback satisfies

\[
 e^{t\mathscr L}h=h\circ\Phi_t,
 \qquad
 \operatorname{ev}_{\omega_0}(hk)
 =\operatorname{ev}_{\omega_0}(h)\operatorname{ev}_{\omega_0}(k).
\]

The formal exponential identity does not assert that the Taylor series of an arbitrary smooth PDE solution converges in t. Actual local analytic summation is supplied separately in Sections 5–6.

A coordinate/tensor version has X_n=omega^{odot n}. The linear lift obeys

\[
 \dot X_n=L_nX_n+N_nX_{n+1},
\]

with

\[
 L_n=\sum_{j=1}^nI^{\otimes(j-1)}\otimes\nu\Delta\otimes I^{\otimes(n-j)},
 \qquad
 N_n=n\,\operatorname{Sym}(\mathcal B\otimes I^{\otimes(n-1)}).
\]

On finite monomial coordinates X_alpha=omega^alpha, realizability imposes X_0=1 and X_alpha X_beta=X_(alpha+beta). These identities are preserved by the derivation. The lifted coordinates are not independent source slots; replacing their realized image by all possible tensors would change the problem.

## 3. Project observables without deleting the unresolved initial source

Let P be the full fixed-centre toroidal l=2 projection on vorticity; Q=I-P. Heat commutes with P. Write omega_0=p_0+q_0.

For each retained q_0, define a retraction on source space

\[
 r_{q_0}(\omega)=P\omega+q_0
\]

and the observable projection

\[
 (\mathscr Ph)(\omega)=h(r_{q_0}(\omega)),
 \qquad
 \mathscr Q=I-\mathscr P.
\]

Since Pq_0=0, r_(q_0)^2=r_(q_0), so mathscr P is an idempotent algebra homomorphism. Moreover

\[
 (\mathscr Ph)(\omega_0)=h(\omega_0).
\]

The unresolved initial source is therefore carried as an index, not averaged out or set to zero.

There is an exact warning about projected dynamics:

\[
\begin{split}
\mathscr Q\mathscr L(hk)
&-(\mathscr Q\mathscr Lh)k-h(\mathscr Q\mathscr Lk)\\
&=(\mathscr P\mathscr Lh)(\mathscr Qk)
 +(\mathscr Qh)(\mathscr P\mathscr Lk).
\end{split}
\]

Thus mathscr Q mathscr L is generally not a derivation. Its exponential must not be silently replaced by the pullback of a guessed autonomous source flow. The exact elimination below avoids that substitution.

## 4. One coefficient compiler generates every first-return word

Define observable blocks

\[
 A=\mathscr P\mathscr L\mathscr P,
 \quad B=\mathscr P\mathscr L\mathscr Q,
 \quad C=\mathscr Q\mathscr L\mathscr P,
 \quad D=\mathscr Q\mathscr L\mathscr Q.
\]

Set

\[
 K_n=\mathscr P\mathscr L^n\mathscr P,
 \qquad M_j=BD^jC,
\]

where K_0 is the identity on ran(mathscr P). In the formal power-series algebra, or analytically on any domain where the needed evolution exists,

\[
 K(t)=\mathscr P e^{t\mathscr L}\mathscr P,
 \qquad M(t)=Be^{tD}C
\]

satisfy

\[
 K'(t)=AK(t)+\int_0^tM(t-s)K(s)\,ds.
\]

Proof: set Z(t)=mathscr Q e^(t mathscr L) mathscr P. Then K'=AK+BZ, Z'=CK+DZ, Z(0)=0. Solve the second equation by variation of constants and insert it into the first.

With exponential-generating coefficients, the exact ordered recurrence is

\[
 \boxed{K_{n+1}=AK_n+\sum_{j=0}^{n-1}M_jK_{n-1-j}.}
\]

No binomial factor appears in the convolution term: the beta integral cancels both factorials. In particular

\[
 K_2=A^2+M_0,
 \quad K_3=A^3+AM_0+M_0A+M_1.
\]

The formal resolvent is

\[
 \mathscr P(\lambda I-\mathscr L)^{-1}\mathscr P
 =\big[\lambda-A-B(\lambda-D)^{-1}C\big]^{-1}.
\]

The all-order rule is a structural identity. It is not a claim that the analytic inverse exists on every desired Banach space.

For pure initial degree-two source a=Pa and ell(omega)=Pomega,

\[
 M_0\ell(a)=P D\mathcal N(a)[Q\mathcal N(a)]
 =2P\mathcal B(a,Q\mathcal B(a,a)).
\]

This is exactly the retained 2->4->2 term, including differentiation of both source factors. The factor t^2/2 in the difference of full and naively projected evolution follows from K_2-A^2=M_0.

## 5. Evaluate the orthogonal history as an actual nonlinear causal kernel

Define the symmetric mild bilinear operator

\[
 \mathcal V(a,b)(t)
 =\int_0^t e^{\nu(t-s)\Delta}\mathcal B(a(s),b(s))\,ds.
\]

For a prescribed resolved history p(t), the complementary history q(t) obeys exactly

\[
 q=b_p+\mathcal A_pq+\mathcal V_Q(q,q),
\]

where

\[
 b_p=e^{\nu t\Delta}q_0+Q\mathcal V(p,p),
 \quad \mathcal A_pq=2Q\mathcal V(p,q),
 \quad \mathcal V_Q=Q\mathcal V.
\]

Whenever I-mathcal A_p is invertible on the declared trajectory space, set

\[
 R_p=(I-\mathcal A_p)^{-1},
 \quad g_p=R_pb_p,
 \quad C_p(a,b)=R_p\mathcal V_Q(a,b).
\]

Then the entire hidden history is the same-source quadratic fixed point

\[
 \boxed{q=g_p+C_p(q,q).}
\]

Its recursive homogeneous components are

\[
 q^{[1]}=g_p,
 \qquad
 q^{[n]}=\sum_{j=1}^{n-1}C_p(q^{[j]},q^{[n-j]}),\ n\ge2.
\]

Every rooted planar binary tree is present, with all leaves evaluated from this one g_p and all vertices from this one C_p. The factor R_p additionally sums every chain of interactions linear in the complementary history. This is not an independent random source at each descendant.

Write Y[p;q_0]=sum_(n>=1)q^[n] on a convergence domain. The exact closed resolved equation is

\[
\begin{split}
 p={}&e^{\nu t\Delta}p_0+P\mathcal V(p,p)\\
 &+2P\mathcal V(p,Y[p;q_0])
 +P\mathcal V(Y[p;q_0],Y[p;q_0]).
\end{split}
\]

A solution p of this equation reconstructs the actual full mild solution omega=p+Y[p;q_0]. Conversely every full mild solution in the uniqueness domain gives such p. The correspondence retains the initial q_0 and the entire resolved history.

The q-q term is essential: omitting it discards interactions between two previously unresolved descendants, even after the linear self-energy is retained.

## 6. A local analytic certificate and an explicit all-orders remainder

Take the whole-space phase norm

\[
 \|a\|_X=\|a\|_{H^m}+\|u_a\|_2,\qquad m>5/2,
\]

and trajectory space C([0,T],X). The Sobolev product estimate, finite-energy low-frequency velocity reconstruction, and one-derivative heat estimate give

\[
 \|\mathcal V(a,b)\|\le\kappa_T\|a\|\|b\|,
 \qquad
 \kappa_T\le C_m\big(T+\sqrt{T/\nu}\big).
\]

Indeed ||u_a||_(H^(m+1)) <= C||a||_X. The vorticity component costs one derivative, supplied by (nu(t-s))^(-1/2); the reconstructed velocity of B(a,b) is one half the Leray projection of u_a cross b + u_b cross a and costs no derivative in L2. Time integration gives the two terms in kappa_T. P and Q are contractions for the Hilbert norms involved because they commute with the Laplacian; constants can absorb equivalent choices of the combined norm.

Put p_*=||p|| and r_*=||q_0||_X. Then

\[
 \|\mathcal A_p\|\le2\kappa_Tp_*,
 \quad
 \|g_p\|\le\frac{r_*+\kappa_Tp_*^2}{1-2\kappa_Tp_*},
 \quad
 \|C_p\|\le\frac{\kappa_T}{1-2\kappa_Tp_*}.
\]

For b=||g_p|| and c=||C_p||, if 4bc<1, the tree series converges absolutely and

\[
 \|q^{[n]}\|\le\operatorname{Cat}_{n-1}c^{n-1}b^n.
\]

Therefore

\[
 \|q\|\le\frac{1-\sqrt{1-4bc}}{2c},
 \quad
 \left\|q-\sum_{n=1}^Nq^{[n]}\right\|
 \le\frac{b(4bc)^N}{1-4bc}.
\]

The c=0 case is q=g_p. The contraction constant on the indicated ball is at most 1-sqrt(1-4bc)<1, which proves uniqueness of this branch.

There is no extra loss of the scalar local-existence majorant from performing the exact elimination. The sufficient test for the displayed bounds reduces to

\[
 \boxed{4\kappa_T(p_*+r_*)<1.}
\]

This follows from the identity

\[
 (1-2\kappa_Tp_*)^2-4\kappa_T(r_*+\kappa_Tp_*^2)
 =1-4\kappa_T(p_*+r_*).
\]

Thus every infinite hidden branch is either included or has a quantified tail on a certified interval. The certificate is local: it does not assert a uniform lower bound on step length along a possible singular history.

## 7. Renormalization acts on the whole generated kernel

Let S_r a(x)=r^2a(rx) for vorticity, and define trajectory rescaling a_r(t)=S_ra(r^2t). Then

\[
 \mathcal B(S_ra,S_rb)=r^2S_r\mathcal B(a,b),
 \qquad
 e^{\nu t\Delta}S_r=S_re^{\nu r^2t\Delta}.
\]

Changing the integration variable gives

\[
 \mathcal V(a_r,b_r)(t)=S_r\mathcal V(a,b)(r^2t).
\]

The fixed-centre angular P commutes with this dilation. Hence b_p, mathcal A_p, R_p, C_p, every q^[n], and their locally convergent sum transform by the same conjugation. This is proved once by structural induction; no separate proof is needed for each angular itinerary.

Translations use the correspondingly translated angular projection. A moving centre must remain a state variable with its actual evolution; it is not removed by a fixed-centre identity.

Initial data, viscosity, centres, forcing history, divergence constraints, and any proved energy/source identities remain attached under this exact reconstruction. The construction preserves proved properties; it does not create a new sign or global bound solely by re-encoding them.

## 8. RH is the explicitly solved two-sector instance of the same return calculus

Let actual shifted nontrivial zeros be z=sigma+i gamma with reflection theta z=-sigma+i gamma. On the actual completed coefficient space, U_t a(z)=exp(-zt)a(z), and J exchanges reflected coordinates.

In the J-eigenbasis of a nonfixed reflection orbit,

\[
 G=-i\gamma I-\sigma\begin{pmatrix}0&1\\1&0\end{pmatrix}.
\]

Choose the symmetric channel as P. Then

\[
 A=D=-i\gamma,\qquad B=C=-\sigma.
\]

The entire first-return kernel and its Laplace transform are

\[
 M_z(t)=\sigma^2e^{-i\gamma t},
 \qquad \Sigma_z(\lambda)=\frac{\sigma^2}{\lambda+i\gamma}.
\]

The resummed resolved response is

\[
 \widehat K_z(\lambda)
 =\frac1{\lambda+i\gamma-\sigma^2/(\lambda+i\gamma)}
 =\frac{\lambda+i\gamma}{(\lambda+i\gamma)^2-\sigma^2},
\]

hence

\[
 K_z(t)=e^{-i\gamma t}\cosh(\sigma t).
\]

All repeated returns have been summed. The coefficient sigma is from the actual Xi zero divisor, not a freely selected parameter of a substitute zeta model. The symbolic checks treat sigma as a variable only to verify the identity.

At critical fixed points the second channel is absent. Across the whole actual divisor,

\[
 \mathrm{RH}\iff\Sigma(\lambda)=0
\]

for any fixed lambda with positive real part where the diagonal expression is evaluated (for instance lambda=1). D is skew-adjoint and its resolvent exists there; for the full resolvent use Re(lambda)>delta. The direct sum is controlled because |sigma|<1/2. No exchange of an unbounded ordinate generator with an undefined inverse is required.

This same sigma gives the already-established reflection-scale holonomy exp(2t sigma) and positive packet defect. The kernel expression computes their common algebra; it does not determine sigma=0 from arithmetic by itself.

## 9. Proof reuse and what was actually executed

A proof-carrying installed schema has parameters, a left side, a right side, hypotheses, and a derivation. Substitution and context insertion transport the certificate, not merely the printed formula. This is the operation that the inspected kernel files actually implement for their declared grammar.

Here the reusable mathematical schemata are: symmetric polarization; the derivation product law; affine source-preserving observable retraction; block first-return recurrence; nonlinear Volterra elimination; Catalan all-orders summation with a remainder certificate; and dilation naturality. Their semantic assumptions are stated above. They have not been encoded into the repository's Agda syntax in this run.

The executable `checks.py` implements one polynomial derivation plus one retraction and generates K_n and M_n automatically. For the explicitly labeled synthetic flow

    x'=-2x+x^2+2xy-y^2,
    y'=-3y+3x^2-xy+2y^2,

it outputs

    M_0 x = 6x^3,
    M_1 x = -18x^4-30x^3,
    M_2 x = 162x^5+234x^4+150x^3,
    M_3 x = -1476x^6-3600x^5-2286x^4-750x^3.

It checks the ordered renewal rule through K_7 for two observables, source-product identities, nonzero unresolved-source retractions, tensor-row identities, and the Catalan recurrence. Separately it checks the actual periodic Fourier NS polarization, divergence constraint, nonlinear energy conservation, and nonlinear helicity conservation on 26 symmetry-closed modes, using exact Gaussian-rational amplitudes. These are finite controls, not a proof of continuum evolution or regularity.

An initial slower execution timed out; after replacing expensive unsimplified rational expressions by exact expanded Gaussian-rational forms, the revised script completed. Final result: see `check_results.txt` and `.json`.

The exact recursive mechanism is now explicit at both formal and locally analytic levels. The remaining global analytic and arithmetic conclusions cannot be asserted without the needed uniform continuation or positivity statement on the actual source. No such statement is inferred merely from the word “metacircular.”
