# TWISTED EIGENMEASURE CLOSURE: finite flip symmetrization kills the exotic zone

**Status: under audit.**  This note records a short successor argument to
`EIGENMEASURE.md`; it does not amend or promote R0011.  The argument has been
rederived once by a Codex breaker, but its decisive external input,
Frantzikinakis's Proposition 3.7, is stated in the published paper with only a
proof sketch.  A separate source/proof audit is therefore required before this
result becomes load-bearing.

## 1. Statement

Let

\[
 \Omega=\{-1,+1\}^{\mathbb Z},\qquad (S\omega)(h)=\omega(h+1),
 \qquad (D_m\omega)(h)=\omega(mh),
\]

and let \(J\omega=-\omega\) be the global flip.  Let
\(\varepsilon:\mathbb N\to\{\pm1\}\) be nontrivial.  Suppose that \(\nu\)
is an ergodic \(S\)-invariant probability measure satisfying the
**unconditional twisted dilation laws**

\[
 (D_m)_*\nu=(J^{(1-\varepsilon(m))/2})_*\nu
 \qquad(m\geq1). \tag{1.1}
\]

The intended application has \(\varepsilon=x\), with \(x\) a nonconstant
completely multiplicative sign function, but the proof below only needs
(1.1) and the existence of one \(m\) with \(\varepsilon(m)=-1\).

> **Candidate theorem T.** Under these hypotheses,
> \(\nu\) is the uniform Bernoulli product measure on \(\Omega\).

Consequently, if \(\nu\) is the marginal of an ergodic conditional
logarithmic eigenmeasure of `EIGENMEASURE.md` and has trivial rational
spectrum, Lemma 3.1 there deconditions the transfer identity to (1.1), so
Candidate T would force \(\nu=\operatorname{Bernoulli}(1/2)\).  In particular,
the \(\pm1\) log-ergodic exotic horn in Corollary 3.5 would be empty.  This is
strictly a logarithmic/deconditioned conclusion; Proposition 1.3's general
Cesaro renormalization limits are not covered.

## 2. Flip symmetrization

Set

\[
 \bar\nu=\tfrac12(\nu+J_*\nu). \tag{2.1}
\]

Since \(D_mJ=JD_m\), (1.1) gives

\[
 (D_m)_*\bar\nu=\bar\nu \qquad(m\geq1). \tag{2.2}
\]

For a two-sided sequence-space measure, invariance under every \(D_m\) is
exactly strong stationarity with respect to the coordinate-zero generating
algebra.  Thus \(\bar\nu\) is an ordinary, untwisted strongly stationary
system.  The twist has not been discarded: it has become the action that
either fixes or exchanges the at-most-two ergodic components of
\(\bar\nu\).

The load-bearing cited input is:

> **Frantzikinakis, Proposition 3.7.** If a (not necessarily ergodic)
> strongly stationary system has a shift eigenvalue \(\lambda\), then
> \(\lambda=1\).

The source is N. Frantzikinakis, *The structure of strongly stationary
systems*, J. Analyse Math. **93** (2004), 359--388,
doi:10.1007/BF02789313, arXiv:math/0403453.  Definitions 3.1--3.2 identify
(2.2) with strong stationarity; Proposition 3.7 has precisely the
nonergodic scope needed here.  The article says that the full proof is too
long to reproduce, sketches the irrational- and rational-eigenvalue attacks,
and derives it from the argument behind Jenvey's theorem.  That provenance is
the present rigor boundary.

## 3. The componentwise eigenfunction patch

We show, conditional on Proposition 3.7, that \(\nu\) is weakly mixing.

If \(J_*\nu=\nu\), then \(\bar\nu=\nu\).  Proposition 3.7 rules out every
shift eigenvalue except \(1\), while ergodicity makes the \(1\)-eigenspace
consist only of constants.  This is the spectral characterization of weak
mixing.

Now suppose \(J_*\nu\neq\nu\).  Distinct ergodic invariant measures are
mutually singular.  Hence there is an \(S\)-invariant measurable set \(B\),
after null-set adjustment, such that

\[
 \nu(B)=1,\qquad J_*\nu(B)=0,
\]

Put \(C=B\setminus J(B)\).  Then \(C\) and \(J(C)\) are disjoint,
\(S\)-invariant, and \(C\cup J(C)\) is \(\bar\nu\)-conull: indeed
\(\nu(C)=1\) and \(J_*\nu(J(C))=1\).  Let \(f\in L^2(\nu)\) be a
\(\lambda\)-eigenfunction:
\(f\circ S=\lambda f\), \(\nu\)-almost everywhere.  Define an
\(L^2(\bar\nu)\) function componentwise by

\[
 F(\omega)=
 \begin{cases}
 f(\omega),&\omega\in C,\\
 f(J\omega),&\omega\in J(C).
 \end{cases} \tag{3.1}
\]

Because \(JS=SJ\), (3.1) satisfies \(F\circ S=\lambda F\) on both
components.  Every eigenvalue of \((\Omega,\nu,S)\) therefore patches to an
eigenvalue of \((\Omega,\bar\nu,S)\).  Proposition 3.7 forces \(\lambda=1\),
and ergodicity again makes the \(1\)-eigenspace of \(\nu\) constant.  Thus
\(\nu\) is weakly mixing in this case as well.

Finally apply `EIGENMEASURE.md` Theorem 3.3.  Its proof is abstract after the
unconditional laws (1.1) are available: a two-copy square removes the sign
twist, Furstenberg's weak-mixing multiple-average theorem kills every
nonempty Walsh coefficient, and Walsh inversion identifies the exact
coordinate law.  Therefore \(\nu\) is the uniform product measure.  In the
second case this conclusion also contradicts \(J_*\nu\neq\nu\), showing that
the two-component branch cannot actually persist.

The fairness is not an isomorphism-level gloss.  Theorem 3.3 gives the
coordinate product law directly.  At order one it is also forced by (1.1):
stationarity and any \(m\) with \(\varepsilon(m)=-1\) give
\(\mathbb E X_0=-\mathbb E X_0\).

## 4. Proves-too-much controls

Each load-bearing hypothesis has a visible failure mode.

1. **Ergodicity cannot be removed.**  Put
   \[
   \eta=\tfrac12(\delta_{(+1)^{\mathbb Z}}+
                    \delta_{(-1)^{\mathbb Z}}).
   \]
   Then \(D_m{}_ *\eta=J_*\eta=\eta\), so \(\eta\) satisfies (1.1) for
   every sign family.  It is not fair Bernoulli because
   \(\mathbb E_\eta[X_0X_1]=1\).  Proposition 3.7 does not forbid this:
   the nonconstant component indicator is an eigenfunction with the allowed
   eigenvalue \(1\).  The proof needs ergodicity exactly when it turns
   "only eigenvalue 1" into weak mixing.
2. **A nontrivial twist cannot be removed.**  For
   \(\varepsilon\equiv1\), any biased iid Bernoulli law is ergodic and
   strongly stationary but is not the fair coin.  The negative sign is what
   forces the mean to vanish.
3. **Unconditionality cannot simply be assumed from a conditional limit.**
   An arbitrary ergodic binary coding of an irrational rotation has trivial
   rational spectrum and is not Bernoulli, but it has no reason to satisfy
   (1.1).  In the logarithmic eigenmeasure application, Lemma 3.1 is the
   indispensable bridge from the residue-conditioned identity to (1.1).

These controls also explain why the argument does not settle general
Cesaro limits: scale renormalization is not invariance of a single law.

## 5. Audit of the predecessor package

The breaker pass independently rederived the parts of R0011 used above:

- the logarithmic transfer identity has the exact factor
  \(m^{-1}L_{\lfloor N/m\rfloor}/L_N\), and logarithmic slow variation
  identifies the rescaled subsequence with the original limit;
- Cesaro averaging instead couples \(N_j\) to \(\lfloor N_j/m\rfloor\)
  and does not give a single-law fixed point without an additional
  hypothesis;
- odometer disjointness under ergodicity plus trivial rational spectrum
  correctly deconditions the logarithmic identity;
- the weak-mixing Walsh-square proof and the special-case divisible-spectrum
  proof are sound.

One expository proof gap remains in Proposition 1.2: the displayed identity
for observables of \(\omega\) is enough for the packet's exact statement,
but the asserted *equivalent* equality of enriched pushforward measures also
requires testing observables depending on the residue coordinate.  The same
finite calculation proves it: for a continuous local \(G(\omega,r)\),
\[
 \widehat D_m(S^{ms}x,[ms])=(x(m)S^sx,[s]),
\]
followed by enriched logarithmic slow variation.  The enriched claim is true,
but that extra test should be written if its equivalence is later used.

Theorem 3.4's divisibility conclusion is also consistent, but its final
geometric sentence should be read narrowly: the **full** Kronecker factor
cannot be a nontrivial finite-dimensional torus rotation.  A divisible
spectrum such as \(\mathbb Q\alpha\) contains the subgroup
\(\mathbb Z\alpha\), so it can still have irrational circle-rotation
factors.  Candidate T, if audited, makes the distinction moot in the
\(\pm1\) ergodic trivial-rational case by forcing the entire spectrum to be
trivial.

## 6. Rigor and novelty boundary

**Internally proved, conditional on cited theorems:** symmetrization (2.2),
the two-component eigenfunction patch, the controls, and the reduction to
R0011 Theorem 3.3.

**Cited, not internally reconstructed:** Frantzikinakis Proposition 3.7,
whose publication contains a proof strategy rather than the full Jenvey
argument; Furstenberg's multiple weak-mixing theorem already used in R0011.

There is a useful split inside that citation.  The unconditional Candidate T
permits rational shift spectrum and therefore needs Jenvey's difficult
root-of-unity branch.  The logarithmic corollary enters with *trivial rational
spectrum* before Lemma 3.1 deconditions it, so only the non-torsion branch of
Proposition 3.7 is needed there.  An independent reconstruction verified its
terminal spectral-flight lemma: the dilation-difference vectors attached to
a non-torsion eigenfunction have pairwise disjoint shift-spectral supports
and hence converge weakly to zero.  The remaining internal-proof debt is the
finite repeated-van-der-Corput induction from that lemma to orthogonality
against the generating cylinder algebra.  Thus the application has a
narrower external dependency than Candidate T, but neither is advertised as
a fully internal certificate.

**Not claimed:** a Cesaro classification, removal of ergodicity, removal of
the trivial-rational hypothesis before deconditioning, or a new proof of
Frantzikinakis/Jenvey.

Targeted public searches for `twisted strongly stationary`, sign
symmetrization, global flip, and finitely many ergodic components did not
locate this exact corollary.  The status is therefore *possibly new as an
assembly*, not novel.  The shortest decisive next action is a blind audit of
Proposition 3.7's applicability and of the measurable component patch,
followed by a reconstruction of the special one-or-two-component spectral
case from Jenvey's proof if the original source can be obtained.

One independent hostile audit has accepted the proof chain, including that
R0011 Theorem 3.3 yields the literal coordinate iid law rather than only a
Bernoulli isomorphism.  A second fresh blind audit is pending; this note stays
under audit and no claim is promoted on the first verdict alone.
