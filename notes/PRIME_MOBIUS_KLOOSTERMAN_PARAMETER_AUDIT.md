# Prime–Möbius Kloosterman Parameter Audit

**Landing note (cf-indra, 2026-08-16).** Upstream circulation package, landed
verbatim below. Three disciplines applied at the door:

1. **Python evidence NOT landed.** The package shipped `.py` generators for
   the numerical verifications. Python is banned (owner, 2026-08-13; hook +
   CI). They are excluded. Consequently every number in this note that came
   from a script is **unreplayable in-repo** and is graded MEASURED, not
   proved — per CLAUDE.md, a script that prints a number stands in for an
   error analysis. The exact *identities* below are elementary algebra and
   stand on their proofs, not on the runs.
2. **Formalization targets named.** The exact finite-dimensional content is
   checkable and is queued for the Agda lane; see `STATUS` below.
3. **Dependencies partially absent.** Cited GTER Deltas 37/38 and the dynamic
   sieve phase theorems are NOT in `notes/` — standing `SEARCH` item, same
   as DSO Deltas 26/27 and Factories VII–IX.

**STATUS — a NO-GO, the corpus's highest-value genre.** Exact parameter
substitution into published fixed-factor Kloosterman-fraction bounds: the
quarter-scale factorization lands exactly inside the theorem's structural
hypothesis, but termwise application is nontrivial only on a much shorter
subrange — a **direct-application no-go**, with the moving-factor obstruction
(§6) and the precise next theorem target (§7) stated. This is a wall located
exactly, in the manner of PROOF_MASS / L3_SDP / DPP Thm 10.

JSON companions: `data/egb_circulation_0002/`.

---


## Exact compatibility with fixed-factor trilinear estimates, a direct-application no-go, and the moving-factor theorem target

**Date:** 2026-08-16 UTC  
**Status:** exact algebraic parameter substitution into published Kloosterman-fraction bounds; exact range/no-go conclusions for that direct application.  
**Source status:** the prime–Möbius hyperbola decomposition is from the live `/Math Research` arithmetic source. The Kloosterman-fraction inequalities are inherited from Bettin–Chandee and Wright. The project-specific contribution is the exact parameter matching and the resulting identification of the untreated moving-factor range.  
**Non-claim:** no new Kloosterman estimate, no prime-pair asymptotic, and no claim that existing theorems fail after a more sophisticated reorganization.

**Depends on:**
- `PRIME_PAIR_SMOOTHED_BOUNDARY_HERMITIAN_DELTA_2026-08-11.md`, version containing the 2026-08-16 prime–Möbius continuation;
- `PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_THEOREMS_2026-08-16.md`;
- Bettin–Chandee, *Trilinear forms with Kloosterman fractions*, arXiv:1502.00769, Theorem 1;
- Thomas Wright, *Trilinear Kloosterman fractions I: partially fixed moduli and unbalanced convolutions*, arXiv:2604.25177v2, Theorem 2.1.

**Claim nodes touched:** `ARITH.CRT_BOUNDARY`, `ARITH.KUZNETSOV_NO_FREE_GAIN`, `OPEN.ARITH_RIGIDITY`.  
**New nodes proposed:** `ARITH.QUARTER_SCALE_ADMISSIBILITY`, `ARITH.FIXED_FACTOR_RANGE_NO_GO`, `OPEN.ARITH.MOVING_FACTOR_KLOOSTERMAN`.  
**Change:** the exact quarter-scale factorization is now tested against a current fixed-factor theorem. It lands exactly inside the theorem's structural hypothesis, but termwise application is nontrivial only on a much shorter subrange.  
**Open obligation:** obtain cancellation from the *average over the moving short factor*, or use the prime/Möbius coefficient structure in a way not visible to arbitrary-coefficient fixed-factor estimates.

---

# 0. Result in one page

At the first critical positive-cone boundary, the outer canonical divisor scale is

\[
D\asymp X^{1/2}.
\]

The exact incidence resolution

\[
\kappa_1(n)=\sum_{pb=n}\mu(b)
\]

and hyperbola split imply that each canonical coefficient has a factorization with one internal coordinate

\[
R\le D^{1/2}\asymp X^{1/4}.
\]

Fixing such a short factor in the **denominator-side** canonical coefficient produces a Kloosterman-fraction block of the form

\[
\mathcal B(M,N,F;R)
=
\sum_{\substack{a\sim F,\ m\sim M,\ n\sim N\\(m,nR)=1}}
\alpha_m\beta_n\nu_a
e\!\left(\vartheta\frac{a\bar m}{nR}\right),
\]

with the exact scale assignment

\[
\boxed{
M=D,\qquad N=D/R,\qquad NR=D.
}
\tag{0.1}
\]

Wright's fixed-factor theorem assumes \(M\ll N^2\). Under (0.1),

\[
M\ll N^2
\iff
D\ll D^2/R^2
\iff
R\ll D^{1/2}.
\]

Therefore:

\[
\boxed{
\text{the exact quarter-scale hyperbola split is precisely the structural range in which the fixed-factor theorem applies.}
}
\tag{0.2}
\]

This is a genuine compatibility theorem, but not yet a saving theorem.

After dividing Wright's bound by the natural arbitrary-coefficient trivial scale, and assuming the mild frequency condition \(|\vartheta|FR\ll D^2\), the relative factor is

\[
\boxed{
\begin{aligned}
\mathscr R(D,F,R)
={}&D^{-1/8}R^{3/8}
+D^{-1/8}R^{1/4}\\
&+D^{-1/20}F^{-1/20}R^{1/4}\\
&+D^{-1/20}F^{-3/20}R^{1/10}
+D^{-1/8}R^{-1/8}.
\end{aligned}
}
\tag{0.3}
\]

Write

\[
R=D^\rho,\qquad F=D^\phi.
\]

The five powers of \(D\) in (0.3) are

\[
\boxed{
\begin{array}{rcl}
E_1&=&-\frac18+\frac{3\rho}{8},\\[1mm]
E_2&=&-\frac18+\frac{\rho}{4},\\[1mm]
E_3&=&-\frac1{20}-\frac{\phi}{20}+\frac{\rho}{4},\\[1mm]
E_4&=&-\frac1{20}-\frac{3\phi}{20}+\frac{\rho}{10},\\[1mm]
E_5&=&-\frac18-\frac{\rho}{8}.
\end{array}
}
\tag{0.4}
\]

A direct uniform power saving requires all \(E_i<0\). Equivalently,

\[
\boxed{
\rho
<
\min\left\{
\frac13,\,
\frac12,\,
\frac{1+\phi}{5},\,
\frac{1+3\phi}{2}
\right\}.
}
\tag{0.5}
\]

For the balanced first critical block, the Poisson frequency is effectively bounded after smooth localization, so \(\phi=0\). Then the bottleneck is

\[
\boxed{
\rho<\frac15,
\qquad
R<D^{1/5-\varepsilon}
=
X^{1/10-\varepsilon}.
}
\tag{0.6}
\]

But the exact canonical factorization supplies only

\[
R\le D^{1/2}=X^{1/4}.
\]

Hence termwise application leaves the full moving-factor range

\[
\boxed{
D^{1/5}\lesssim R\lesssim D^{1/2}
\qquad
\left(
X^{1/10}\lesssim R\lesssim X^{1/4}
\right)
}
\tag{0.7}
\]

without a uniform nontrivial estimate from this substitution alone.

At the maximal quarter-scale endpoint \(R=D^{1/2}\), the exponent vector is

\[
\boxed{
(E_1,E_2,E_3,E_4,E_5)
=
\left(
\frac1{16},\,0,\,\frac3{40},\,0,\,-\frac3{16}
\right).
}
\tag{0.8}
\]

Two terms are worse than trivial, two merely tie it, and one saves. Thus:

\[
\boxed{
\text{quarter-scale factorization is structurally admissible but does not automatically improve the generic Kloosterman estimate.}
}
\tag{0.9}
\]

The missing analytic object is not another fixed-\(R\) block. It is the moving-factor hyperbola family

\[
\boxed{
\mathfrak B(D,F)
=
\sum_{R\le D^{1/2}}
\gamma_R\,
\mathcal B(D,D/R,F;R),
}
\tag{0.10}
\]

where \(\gamma_R\) is the actual prime/Möbius short-factor coefficient. A useful next theorem must exploit cancellation in the \(R\)-average, or a stronger interaction between the two exact resolutions

\[
\text{prime–Möbius incidence}
\quad\bowtie\quad
\text{cyclic charge phase}.
\]

---

# 1. Native canonical boundary block

For a smooth dyadic vector

\[
v_D(n)=\frac{\kappa_1(n)}{\sqrt n}V(n/D),
\]

the exact canonical incidence formula is

\[
\boxed{
v_D(n)
=
\sum_{pb=n}
\frac{\mu(b)}{\sqrt{pb}}V(pb/D).
}
\tag{1.1}
\]

In a coprime inverse-residue block,

\[
\sum_{(n,q)=1}v_D(n)e(-a\bar n/q),
\]

factorization \(n=pb\) gives

\[
\boxed{
\sum_{\substack{p,b\\(pb,q)=1}}
\frac{\mu(b)}{\sqrt{pb}}V(pb/D)
e(-a\bar p\bar b/q).
}
\tag{1.2}
\]

If \(\operatorname{supp}V\subset[A_0,B_0]\subset(0,\infty)\), every nonzero term obeys

\[
pb\le B_0D,
\]

hence

\[
\boxed{\min(p,b)\le \sqrt{B_0D}.}
\tag{1.3}
\]

At \(D\asymp X^{1/2}\), one internal factor is \(O_V(X^{1/4})\).

The split has two branches:

\[
\sum_{p\le U}\sum_b(\cdots)
+
\sum_{b<U}\sum_{p>U}(\cdots),
\qquad
U=\sqrt{B_0D}.
\tag{1.4}
\]

In either branch, a short internal factor can be exposed on the denominator side of the Kloosterman fraction. The question is what current trilinear estimates actually return after that exposure.

---

# 2. Inherited fixed-factor theorem

Let

\[
\mathcal B(M,N,F;R)
=
\sum_{\substack{a\sim F,\ m\sim M,\ n\sim N\\(m,nR)=1}}
\alpha_m\beta_n\nu_a
e\!\left(
\vartheta\frac{a\bar m}{nR}
\right).
\tag{2.1}
\]

Wright's Theorem 2.1 gives, under \(M\ll N^2\) and polynomial size control on \(R\),

\[
\begin{aligned}
\mathcal B(M,N,F;R)
\ll{}&
M^\varepsilon
\|\alpha\|\|\beta\|\|\nu\|
(FMN)^{1/2}
R^{1/4}
\left(1+\frac{|\vartheta|F}{MN}\right)^{1/4}\\
&\times
\left(
N^{-1/8}
+
\frac{R^{1/8}N^{1/8}}{M^{1/4}}
+
\frac{M^{1/10}}
{R^{3/20}F^{1/20}N^{3/20}}
+
\frac{N^{3/20}}
{F^{3/20}M^{1/5}}
+
\frac{N^{3/8}}{M^{1/2}}
\right).
\end{aligned}
\tag{2.2}
\]

The theorem is inherited. Our task is only to substitute the actual canonical scales without hiding a loss.

---

# 3. Exact scale substitution

Set

\[
M=D,\qquad N=D/R.
\tag{3.1}
\]

The theorem's structural hypothesis becomes

\[
D\ll(D/R)^2,
\]

so

\[
\boxed{R\ll D^{1/2}.}
\tag{3.2}
\]

This exactly matches the short-factor guarantee from (1.3).

The natural arbitrary-coefficient trivial scale in (2.2) is

\[
\|\alpha\|\|\beta\|\|\nu\|(FMN)^{1/2}.
\]

After substitution, the extra relative factor is \(R^{1/4}\) times the five-term bracket. Term by term:

\[
R^{1/4}N^{-1/8}
=
D^{-1/8}R^{3/8},
\tag{3.3}
\]

\[
R^{1/4}\frac{R^{1/8}N^{1/8}}{M^{1/4}}
=
D^{-1/8}R^{1/4},
\tag{3.4}
\]

\[
R^{1/4}
\frac{M^{1/10}}
{R^{3/20}F^{1/20}N^{3/20}}
=
D^{-1/20}F^{-1/20}R^{1/4},
\tag{3.5}
\]

\[
R^{1/4}
\frac{N^{3/20}}
{F^{3/20}M^{1/5}}
=
D^{-1/20}F^{-3/20}R^{1/10},
\tag{3.6}
\]

\[
R^{1/4}\frac{N^{3/8}}{M^{1/2}}
=
D^{-1/8}R^{-1/8}.
\tag{3.7}
\]

Equations (3.3)–(3.7) prove (0.3).

---

# 4. Exponent phase diagram

Let

\[
R=D^\rho,\qquad F=D^\phi,
\qquad
0\le\rho\le\frac12.
\tag{4.1}
\]

The theorem's external frequency factor remains harmless when

\[
|\vartheta|FR\ll D^2,
\quad\text{i.e.}\quad
\phi+\rho<2
\tag{4.2}
\]

up to fixed powers and endpoints.

Substitution gives the exponent vector (0.4). The inequalities \(E_i<0\) are

\[
\rho<\frac13,
\tag{4.3}
\]

\[
\rho<\frac12,
\tag{4.4}
\]

\[
\rho<\frac{1+\phi}{5},
\tag{4.5}
\]

\[
\rho<\frac{1+3\phi}{2},
\tag{4.6}
\]

while \(E_5<0\) automatically for \(\rho\ge0\).

Thus (0.5) is exact.

For bounded effective frequency, \(\phi=0\), inequality (4.5) is the unique bottleneck:

\[
\rho<\frac15.
\]

At \(\rho=1/5\), the third term is exactly of trivial size. At the quarter-scale endpoint \(\rho=1/2\), the exponent vector is (0.8).

---

# 5. Comparison with the unsplit balanced estimate

Before exposing the internal canonical factor, the outer fixed-frequency block has

\[
M\asymp N\asymp D.
\]

Bettin–Chandee's trilinear theorem gives, for bounded effective \(F\) and \(|\vartheta|F\ll D^2\), a generic relative factor of size

\[
\boxed{
D^{-1/20+\varepsilon}+D^{-1/8+\varepsilon}.
}
\tag{5.1}
\]

The first term dominates, giving a generic \(D^{1/20}\) saving over the arbitrary-coefficient trivial bound in the balanced block.

This does **not** prove a prime-pair asymptotic: other divisor/frequency ranges, zero-frequency evaluation, compatibility/gcd structure, and summation of all pieces remain. But it yields an important audit rule:

\[
\boxed{
\text{a canonical factorization should not be called analytic progress unless its reorganized estimate beats or extends the direct unsplit bound.}
}
\tag{5.2}
\]

Termwise fixed-\(R\) use does not pass that test on the full quarter-scale range. The value of the factorization is instead that it exposes a new coefficient-bearing variable \(R\) on which an averaged theorem could act.

---

# 6. The moving-factor obstruction

The exact denominator-side hyperbola decomposition naturally produces

\[
\mathfrak B(D,F)
=
\sum_{R\le D^{1/2}}
\gamma_R
\sum_{\substack{a\sim F,\ m\sim D,\ n\sim D/R\\(m,nR)=1}}
\alpha_m\beta_{n,R}\nu_a
e\!\left(\vartheta\frac{a\bar m}{nR}\right),
\tag{6.1}
\]

with \(\gamma_R\) inherited from either the Möbius or prime short leg.

Applying the fixed-\(R\) theorem separately and summing absolute values discards:

1. cancellation in \(\gamma_R\);
2. the fixed-product coupling \(nR\asymp D\);
3. orthogonality among different denominators \(nR\);
4. the second canonical factorization on the numerator-side coefficient;
5. the cyclic charge-phase structure whose first Fourier mode is \(\kappa_1\).

The untreated range (0.7) is therefore not evidence that the canonical factorization is useless. It proves only:

\[
\boxed{
\text{the useful theorem must see the moving factor as a variable, not as a parameter frozen before estimation.}
}
\tag{6.2}
\]

---

# 7. Precise next theorem target

A useful moving-factor theorem should control (6.1) through

\[
1\le R\le D^{1/2}
\]

and return a power saving over the natural combined trivial scale. At minimum it should use one of:

\[
\boxed{
\begin{array}{c}
\text{Möbius cancellation in }R,\\
\text{prime support in }R,\\
\text{fixed-product orthogonality }nR\asymp D,\\
\text{two-sided prime–Möbius factorization},\\
\text{cyclic charge-phase averaging before absolute values}.
\end{array}
}
\tag{7.1}
\]

One concrete target is an estimate of the schematic form

\[
\boxed{
|\mathfrak B(D,F)|
\ll
D^{-\delta}
\cdot
\mathsf{Triv}(D,F;\alpha,\beta,\gamma,\nu)
}
\tag{7.2?}
\]

for some \(\delta>0\), uniformly over the complete short-factor range, with a norm \(\mathsf{Triv}\) that does not hide the \(R\)-sum by \(\ell^1\) expansion.

A second route is a no-go: construct coefficient sequences satisfying the exact support/size constraints for which no such saving follows without additional prime/Möbius distribution input. Either result would be genuine progress.

---

# 8. Interaction with cyclic charge phases

The cyclic phase projector writes

\[
\kappa_1(d)
=
\frac1M
\sum_{\nu\bmod M}
\zeta^{-\nu}a_{\zeta^\nu}(d),
\]

where each \(a_{\zeta^\nu}\) is multiplicative. Inserting this before the prime–Möbius split gives a phase average of multiplicative Kloosterman blocks. Inserting the incidence split first gives (6.1).

Thus the same canonical vector has two exact resolutions:

\[
\boxed{
\begin{array}{c}
\text{incidence resolution: exposes the moving short factor }R,\\
\text{phase resolution: exposes multiplicative sectors with condition-one inversion}.
\end{array}
}
\tag{8.1}
\]

The two operations need not commute harmlessly with Cauchy–Schwarz or absolute values. A future estimate should explicitly state its order:

\[
\text{phase average}
\to
\text{factor split}
\to
\text{dispersion},
\]

or

\[
\text{factor split}
\to
\text{moving-factor average}
\to
\text{phase projection}.
\]

The choice is part of the analytic method.

---

# 9. Final verdict

The exact quarter-scale structure has passed a structural compatibility test and failed a direct leverage test:

\[
\boxed{
\begin{array}{rcl}
R\le D^{1/2}
&\Longleftrightarrow&
\text{Wright fixed-factor hypothesis is available},\\[1mm]
R<D^{1/5-\varepsilon}
&\Longrightarrow&
\text{direct bounded-frequency application is power-saving},\\[1mm]
D^{1/5}\lesssim R\lesssim D^{1/2}
&\Longrightarrow&
\text{no uniform saving follows from that substitution alone}.
\end{array}
}
\]

In the original prime-pair scale \(D=X^{1/2}\):

\[
\boxed{
X^{1/10}
\lesssim
R
\lesssim
X^{1/4}
}
\]

is the exact moving-factor frontier created by this audit.

The next nonrepetitive object is therefore not another representation name. It is an averaged Kloosterman-fraction theorem for the canonical hyperbola family, or a counterexample proving which additional arithmetic input is indispensable.
