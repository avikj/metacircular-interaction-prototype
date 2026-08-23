# PRIME-PAIR RESEARCH DELTA — smoothed boundary localization and Hermitian Kloosterman operator

## VERIFIED EXACT — smoothed Poisson form
Let \(W\in C_c^\infty((0,\infty))\), with Fourier transform
\[
\widehat W(\xi)=\int_{\mathbb R}W(x)e(-\xi x)\,dx.
\]
For fixed charges \(r,t\), use canonical divisor kernels
\[
1_{\{\Omega=r\}}=1*\kappa_r,\qquad
1_{\{\Omega=t\}}=1*\kappa_t.
\]
Then the smoothed shifted correlation
\[
C_{r,t}^W(X;h)
=
\sum_{n\in\mathbb Z}
1_{\Omega(n)=r}1_{\Omega(n+h)=t}W(n/X)
\]
has the exact expansion
\[
C_{r,t}^W
=
\sum_{d,e}\kappa_r(d)\kappa_t(e)
\sum_{\substack{n\equiv0\ (d)\\n\equiv-h\ (e)}}W(n/X).
\]

If \(g=(d,e)\nmid h\), the inner sum is zero. If \(g|h\), let \(L=[d,e]\) and \(a=a(d,e;h)\bmod L\) be the CRT residue. Poisson summation gives
\[
\boxed{
\sum_{n\equiv a\ (L)}W(n/X)
=
\frac X L
\sum_{k\in\mathbb Z}
\widehat W(kX/L)e(ka/L).
}
\]

Thus
\[
C_{r,t}^W
=
X\widehat W(0)
\sum_{(d,e)|h}\frac{\kappa_r(d)\kappa_t(e)}{[d,e]}
+
\Delta_{r,t}^W,
\]
where
\[
\boxed{
\Delta_{r,t}^W
=
X
\sum_{(d,e)|h}
\frac{\kappa_r(d)\kappa_t(e)}{[d,e]}
\sum_{k\ne0}
\widehat W(kX/[d,e])e(k a/[d,e]).
}
\]

For exact prime pairs take \(r=t=1\).

## VERIFIED EXACT — sub-square-root divisor levels are pure equilibrium after smoothing
Let both divisor variables be truncated to \(d,e\le D\), with
\[
D\le X^{1/2-\varepsilon}.
\]
Since \(\widehat W\) decays faster than any power and \([d,e]\le D^2\),
\[
\widehat W(kX/[d,e])
\ll_A
\left(\frac{[d,e]}{|k|X}\right)^A.
\]
For fixed charges, \(|\kappa_r(n)|\le\tau(n)\ll_\eta n^\eta\). Summing gives, for every \(B>0\) after choosing \(A\) sufficiently large,
\[
\boxed{
\Delta_{r,t}^{W,\le D}(X;h)=O_{W,r,t,\varepsilon,B}(X^{-B}).
}
\]

Therefore every divisor block strictly below the square-root hyperbola is asymptotically indistinguishable from CRT/profinite equilibrium. The positive-cone boundary is spectrally supported on
\[
[d,e]\gtrsim X,
\]
with the balanced Type-II locus \(d,e\asymp\sqrt X\) as the first critical block.

This is an exact analytic localization of the square-root/level-of-distribution boundary.

## VERIFIED EXACT — additive reciprocity and Hermitian normalization
For coprime \(d,e\),
\[
\boxed{
\frac{\bar d}{e}+\frac{\bar e}{d}
\equiv\frac1{de}\pmod1.
}
\]
Consequently, for real \(a\), define
\[
\mathcal K_a(d,e)
=
e\left(
-a\frac{\bar d}{e}
+\frac{a}{2de}
\right).
\]
Then
\[
\boxed{
\mathcal K_a(e,d)=\overline{\mathcal K_a(d,e)}.
}
\]

Thus the Kloosterman-fraction phase in the positive-cone boundary can be made exactly Hermitian by absorbing the smooth half-phase \(e(a/(2de))\) into the archimedean weight.

For real equal-charge coefficients, each dyadic fixed-frequency boundary block is therefore a Hermitian bilinear form. The natural hard quantity is its spectral/operator norm.

## KNOWN TOOL CONNECTION
Bettin–Chandee's trilinear Kloosterman-fraction theorem treats arbitrary coefficient sequences and permits smooth perturbations of the phase of exactly the derivative size required by the half-phase above. In the balanced block \(d,e\asymp\sqrt X\) with bounded Fourier frequency, their bound gives a genuine power saving over the trivial bilinear estimate.

This does NOT by itself prove prime pairs:
- divisor ranges with \([d,e]\gg X\) introduce a long Fourier-frequency variable;
- very long divisor blocks are not controlled by the balanced estimate;
- evaluating the zero-frequency canonical main term with \(\kappa_1\) is itself nontrivial;
- exact prime kernels contain the prime-zeta numerator \(P_\chi\), not arbitrary harmless coefficients.

## LIVE FRONTIER
Build a Vaughan/Heath-Brown-style decomposition of the exact canonical kernel \(\kappa_1=1_{\mathbb P}*\mu\), adapted to the smoothed CRT boundary formula, so that all remaining inverse-residue blocks fall into ranges where Kloosterman-fraction/dispersion estimates are nontrivial. The target is not an arbitrary-coefficient bound; it is to exploit the special divisor-lattice formula for \(\kappa_1\) and its character symbol \(P_\chi/L\).
