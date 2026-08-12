# The adelic duality crystal: a square whose holonomy is nontrivial at every place and trivial globally

**Status: PENDING HOSTILE AUDIT.**  Code: `code/exp63_adelic_crystal.py`
(27 s, mpmath at 40 digits); figure: `figures/exp63_adelic_crystal.png`.
Lane: Weaver fleet, adelic crystal.  Executes
`notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §8 (duality crystals), steps 1–6, in
Tate's category — the category where this crystal is native rather than
decorative.  Internal companions: `notes/ADELIC.md` (the Bost–Connes/critical
correlator layer — different object, same finite places), `notes/FF_PAIRFIELD.md`
§2.4 (the independent "the sum spectrum is archimedean" finding, cross-checked
in §6 below), `notes/WEIL.md`/`notes/BLOCKS.md` (where the positivity content of
the functional equation lives).

**Attribution up front, because most of this note is not ours.**  The
mathematics below is *entirely classical*: Tate's thesis (1950/1967) for the
local zeta integrals, the local functional equation, the gamma/epsilon factors
and the global product formula; Gel'fand–Graev for the local beta integrals;
Volovich (1987), Freund–Olson (1987) and Freund–Witten (1987) for the p-adic and
adelic string amplitudes.  Nothing in §§2–5 is a new theorem.  What this note
supplies is (i) an *independent re-derivation* of every formula from the
integrals (nothing quoted from memory), (ii) an exact numerical falsification
harness, (iii) a control ledger showing what breaks under wrong conventions, and
(iv) one framing — the local gamma factor read as the **holonomy of an explicit
infinite-dihedral duality crystal** — which is at most a repackaging of classical
facts and is probably folklore.  §7 states the classical/new split bluntly.

---

## 0. The thesis under test, stated before it is judged

> The archimedean place is the "GR side" (continuum, geometry, the place where
> analysis and curvature live); the finite places are the "QM side" (discrete
> spectra, p-adic ultrametric locality).  The adelic product formula is the exact
> statement that these are two halves of one object.  The physics instance is
> real, not metaphor: Freund–Witten adelic string amplitudes.

**Verdict, earned in §§2–6 and delivered in §6.3: the mathematical half is
earned in a stronger form than stated; the physics half is killed as stated and
survives only in a much weaker form.**  Precisely:

- EARNED, and sharpened: the archimedean/finite split *is* one object, and the
  exact statement of "two halves" is $\prod_v\gamma_v(\chi,s)=1$ — the local
  holonomy of a duality square is nontrivial at every place, and the *only*
  invariant statement is that all the local holonomies multiply to 1 (§2, §3).
  Freund–Witten is *literally* this statement applied three times (§4): the
  physics instance is not an analogy, it is the same theorem.
- EARNED: the discrete/continuous asymmetry is a computed fact, not a mood.
  $\zeta_p$ is a rational function of $p^{-s}$ with poles on the periodic lattice
  $\tfrac{2\pi i}{\log p}\mathbb Z$; $\zeta_\infty$ is transcendental with poles
  marching down the real axis, and is the *only* local factor not rational in
  $p^{-s}$ (figure panel b).
- KILLED: "GR side / QM side" as physics.  Freund–Witten is a tree-level open
  bosonic *string* amplitude identity with a Bruhat–Tits-tree worldsheet.  No
  object computed in this lane touches an Einstein equation, a metric, a Hilbert
  space of states, or a measurement.  Calling $v=\infty$ "GR" and $v=p$ "QM" adds
  no predicate that any computation here can check.  Per charter §2, that is
  mythology and is refused.
- KILLED: the naive reading of "the product over all places equals 1" as a
  convergent limit.  It converges nowhere (§5, C0) — proved here by a one-line
  multiset argument, and confirmed against fetched literature.

---

## 1. The crystal: two involutions, four corners, in their native category

Let $v$ be a place of $\mathbb Q$, $k_v$ the completion, $\psi_v$ the standard
additive character ($\psi_\infty(x)=e^{2\pi ix}$; $\psi_p(x)=e^{2\pi i\{x\}_p}$,
kernel exactly $\mathbb Z_p$), $dx$ the self-dual Haar measure (Lebesgue at
$\infty$; $\mathrm{vol}(\mathbb Z_p)=1$ at $p$), and
$d^\times x=\frac{dx}{|x|_v}$ up to the normalisation
$\mathrm{vol}^\times(\mathbb Z_p^\times)=1$ at finite $p$.  On the
Schwartz–Bruhat space $\mathcal S(k_v)$ define the **local zeta integral**

$$Z_v(f,\chi,s)\;=\;\int_{k_v^\times} f(x)\,\chi(x)\,|x|_v^{s}\,d^\times x .$$

The two dualities of the crystal, both acting on the *same* space $\mathcal S(k_v)$:

| | operator | action |
|---|---|---|
| **D** (Fourier duality at $v$) | $\mathcal F$ | $(\mathcal Ff)(y)=\int f(x)\psi_v(xy)\,dx$ |
| **E** (functional-equation involution) | $J$ | $(Jf)(x)=\dfrac{1}{|x|_v}f(1/x)$ |

$J$ is the operator form of "$s\mapsto1-s$ together with $\chi\mapsto\bar\chi$":
substituting $x\mapsto1/x$ (which preserves $d^\times x$),

$$Z_v(Jf,\chi,s)=\int |x|^{-1}f(1/x)\chi(x)|x|^{s}d^\times x
=\int f(x)\chi^{-1}(x)|x|^{1-s}d^\times x=Z_v(f,\chi^{-1},1-s).$$

So $E$ acts on quasicharacters by $\chi_s\mapsto\widehat{\chi_s}:=|\cdot|\chi_s^{-1}$
— exactly the "shifted dual" of Tate's thesis (FETCHED, DeJean Defs. 3.9, URL in
§8).  Putting **D** and **E** on the same space is what makes the square a crystal
rather than a bookkeeping diagram: if D acted on functions and E only on
characters they would commute trivially and there would be no holonomy to find.

### 1.1 The four corners

| corner | object | zeta integral of the corner |
|---|---|---|
| $X$ | $f$ | $Z_v(f,\chi,s)$ |
| $DX$ | $\mathcal Ff$ | $Z_v(\mathcal Ff,\chi,s)=\gamma_v(\chi^{-1},1-s)\,Z_v(f,\chi^{-1},1-s)$ |
| $EX$ | $Jf$ | $Z_v(f,\chi^{-1},1-s)$ |
| $DEX$ | $\mathcal FJf$ | $\gamma_v(\chi^{-1},1-s)\,Z_v(f,\chi,s)$ |
| $EDX$ | $J\mathcal Ff$ | $\gamma_v(\chi,s)\,Z_v(f,\chi,s)$ |

The last two rows are the crystal's content: **both routes around the square land
on the same corner of the base but on different scalar multiples of it.**

### 1.2 Involutivity (charter step 3), proved and measured

- $J^2=\mathrm{id}$ **exactly**: $J^2f(x)=|x|^{-1}\,|1/x|^{-1}f(x)=f(x)$.
- $\mathcal F^2=\sigma$ where $(\sigma f)(x)=f(-x)$, so $\mathcal F^4=\mathrm{id}$
  and $\mathcal F$ is an involution **only on the even subspace**.  This is not a
  technicality: it is precisely what produces the holonomy identity of §2.
  Measured: at $v=\infty$ the Gaussian is $\mathcal F$-fixed to $7.9\times10^{-18}$;
  at $v=3$, $\max_y|\mathcal F^2f(y)-f(-y)|=1.2\times10^{-15}$ for
  $f=\mathbf 1_{1+p\mathbb Z_p}$ (an *odd-placed* test function, so $f(-y)\ne f(y)$
  and the distinction is visible).
- $\sigma$ acts on the $(\chi,s)$ Mellin component by $\chi(-1)$:
  $Z_v(\sigma f,\chi,s)=\chi(-1)Z_v(f,\chi,s)$.

### 1.3 Fixed points (charter step 5)

- $\mathrm{Fix}(D)$ at $v=\infty$: the Gaussian $e^{-\pi x^2}$ (measured
  $7.9\times10^{-18}$); more generally the $+1$-eigenspace of $\mathcal F$,
  spanned by Hermite functions $h_{4k}$.  At $v=p$: $\mathbf 1_{\mathbb Z_p}$
  (measured $\max_y|\widehat{\mathbf 1_{\mathbb Z_p}}(y)-\mathbf 1_{\mathbb Z_p}(y)|
  =1.3\times10^{-16}$ on an exact $p^{-M}\mathbb Z_p/p^N\mathbb Z_p$ lattice model).
  **Both standard normalisations verified, as the brief demanded.**  Note the
  $\mathbf 1_{\mathbb Z_p}$ self-duality is exactly the statement that $\psi_p$ has
  conductor $\mathbb Z_p$ *and* $\mathrm{vol}(\mathbb Z_p)=1$; control C2 breaks
  the first, control C1 the second, and both are detected.
- $\mathrm{Fix}(E)$: $Jf=f$ means $f(x)=|x|^{-1}f(1/x)$; e.g.
  $f(x)=|x|^{1/2}/(1+x^2)$ at $\infty$ (measured $2.2\times10^{-17}$).  The fixed
  space is infinite-dimensional (any $g$ on the value group gives
  $|x|^{1/2}g(\log|x|)$ symmetric).
- **Lemma (empty core).** $\mathrm{Fix}(D)\cap\mathrm{Fix}(E)=\{0\}$.
  *Proof.* If $\mathcal Ff=f$ and $Jf=f$ then $J\mathcal Ff=f$, so
  $Z_v(f,\chi,s)=\gamma_v(\chi,s)Z_v(f,\chi,s)$ for all $s$.  Since
  $\gamma_v(\chi,\cdot)$ is a nonconstant meromorphic function, $Z_v(f,\chi,s)=0$
  identically, hence $f=0$ by Mellin inversion. $\square$
  So the crystal has two rich fixed loci and **no common fixed vector**: there is
  no "Klein-four corner" at any place.

---

## 2. THE LANE'S THEOREM (local holonomy nontrivial, global holonomy trivial)

> **Theorem (adelic crystal holonomy).** With the notation of §1, on
> $\mathcal S(k_v)$:
>
> **(1)** Both composites are *diagonal* in the Mellin decomposition:
> $$Z_v(J\mathcal Ff,\chi,s)=\gamma_v(\chi,s)\,Z_v(f,\chi,s),\qquad
>  Z_v(\mathcal FJf,\chi,s)=\gamma_v(\chi^{-1},1-s)\,Z_v(f,\chi,s),$$
> where $\gamma_v(\chi,s)$ is Tate's local gamma factor, independent of $f$.
>
> **(2)** The commutator/holonomy of the square is the scalar
> $$h_v(\chi,s)\;=\;\frac{\gamma_v(\chi^{-1},1-s)}{\gamma_v(\chi,s)}
> \;=\;\frac{\chi(-1)}{\gamma_v(\chi,s)^{2}},\qquad\text{since}\qquad
> \boxed{\;\gamma_v(\chi,s)\,\gamma_v(\chi^{-1},1-s)=\chi(-1)\;}$$
> and the boxed identity is *exactly* the statement $\mathcal F^2=\sigma$.
>
> **(3)** $h_v\not\equiv1$ at **every** place: the crystal does not commute
> locally anywhere.  On the even subspace with even $\chi$, $D$ and $E$ are
> honest involutions, $J(\mathcal FJ)J=(\mathcal FJ)^{-1}$, and $\mathcal FJ$ has
> infinite order (its multiplier $\gamma_v(\chi,1-s)$ is a nonconstant function
> of $s$).  Hence
> $$\langle D,E\rangle\;\cong\;D_\infty\quad\text{(infinite dihedral)}$$
> — the charter's "iteration may open a larger dihedral orbit", realised exactly.
>
> **(4)** **The global holonomy vanishes:**
> $$\prod_v\gamma_v(\chi,s)\;=\;1 ,$$
> for every Hecke character $\chi$ of the idele class group; equivalently
> $\Lambda(1-s,\bar\chi)=\varepsilon(\chi)\Lambda(s,\chi)$.

*Proof of (1).*  The first identity is Tate's local functional equation
(classical; see §8 for the fetched statement).  The second follows from it: put
$g=Jf$, apply the first at $(\chi^{-1},1-s)$, and use §1's
$Z_v(Jf,\chi^{-1},1-s)=Z_v(f,\chi,s)$:
$Z_v(\mathcal FJf,\chi,s)=\gamma_v(\chi^{-1},1-s)Z_v(Jf,\chi^{-1},1-s)
=\gamma_v(\chi^{-1},1-s)Z_v(f,\chi,s)$. $\square$

*Proof of (2).*  $(\mathcal FJ)(J\mathcal F)=\mathcal F J^2\mathcal F=\mathcal F^2=\sigma$.
Both factors are diagonal by (1), so their multipliers multiply; $\sigma$'s
multiplier is $\chi(-1)$ (§1.2). $\square$
*This is the crystal reading of a classical identity: the "commutator residual"
demanded by charter §8 is the product of the two local gamma factors, and it is
forced to be the parity character by the fact that Fourier is order 4, not 2.*

*Proof of (3).* Diagonal operators compose by multiplying multipliers, so
$(\mathcal FJ)^n$ has multiplier $\gamma_v(\chi^{-1},1-s)^n$; e.g. at $v=p$ with
$\chi$ trivial this is $\left(\frac{1-p^{s-1}}{1-p^{-s}}\right)^n$, not
identically $1$ for any $n\ge1$.  The relation
$J(\mathcal FJ)J=J\mathcal F=(\mathcal FJ)^{-1}\sigma$ becomes
$J(\mathcal FJ)J=(\mathcal FJ)^{-1}$ on the even sector, which with
$J^2=\mathcal F^2=1$ presents $D_\infty$. $\square$

*Proof of (4).*  Classical (Tate): global Poisson summation / Riemann–Roch on
$\mathbb A_\mathbb Q$ gives $z(\omega)=\hat z(\hat\omega)$ for the global zeta
integral, and comparing with the product of the local equations forces
$\prod_v\gamma_v=1$.  **Honest fence, and it is not decorative:** the product
$\prod_p\gamma_p(s)=\zeta(1-s)/\zeta(s)$ has *no* half-plane of convergence (it
needs $\mathrm{Re}\,s>1$ and $\mathrm{Re}\,s<0$ simultaneously).  The global
holonomy vanishes **only after analytic continuation**.  See §5 C0 for the
quantified divergence and §3.2 for the one instance that *is* a finite product.

### 2.1 What the theorem says as a slogan

*A duality square whose local holonomy is a nonconstant transcendental (at
$\infty$) or rational (at $p$) function at every single place, but whose global
holonomy is exactly 1.*  The residual is not noise to be removed: it is the
gamma/epsilon factor, i.e. the entire content of the functional equation.  The
crystal commutes **adelically and only adelically**.

---

## 3. Verification of §1–§2 (pratyakṣa: quoted script output)

### 3.1 Local, both places, four/three test functions each

Archimedean ($s=0.6$, $\gamma_\infty(s)=\zeta_\infty(1-s)/\zeta_\infty(s)$ with
$\zeta_\infty(s)=\pi^{-s/2}\Gamma(s/2)$):

```
  D-fixed point at infinity: max |F[e^{-pi x^2}] - e^{-pi y^2}| = 7.89e-18
  Z_inf(gauss,1,s=0.7) = 1.70561503   pi^-s/2 Gamma(s/2) = 1.70561503   rel.err 1.53e-31
  Z_inf(gauss,1,s=1.5) = 0.519303668959   pi^-s/2 Gamma(s/2) = 0.519303668959   rel.err 0.0
  Z_inf(gauss,1,s=(0.5 + 3.0j)) = (-0.160116635553 - 0.0237127364697j)   pi^-s/2 Gamma(s/2) = (-0.160116635553 - 0.0237127364697j)   rel.err 3.02e-22
  s = 0.6;   gamma_inf(s) = zeta_inf(1-s)/zeta_inf(s) = 1.7207131314357
    f = gaussian e^{-pi x^2}    |F f - fhat|<9.2e-18   Z(fhat,1-s)/Z(f,s) = 1.7207131314357   dev 4.46e-18
    f = x^2 e^{-pi x^2}         |F f - fhat|<4.0e-18   Z(fhat,1-s)/Z(f,s) = 1.7207131314357   dev 7.43e-18
    f = e^{-pi(x-1)^2}          |F f - fhat|<9.2e-18   Z(fhat,1-s)/Z(f,s) = (1.7207131314357 + 4.194158391688e-48j)   dev 8.75e-18
  odd sector: F[x e^{-pi x^2}] = i * (same);  measured eigenvalue/i = (1.0 + 0.0j)
  gamma_inf(sgn,s) predicted = i*zeta_inf^-(1-s)/zeta_inf^-(s) = (0.0 + 1.25017126849j)
                     measured = (0.0 + 1.25017126849j)    dev 0.0
```

The two non-self-dual test functions are the point: $\gamma_\infty$ is a property
of $(\chi,s)$, not of $f$.  The odd sector produces the archimedean root number
$i$ — the $\varepsilon_\infty=i$ that appears for odd Dirichlet characters.

Finite place $p=3$, on an exact lattice model of $\mathbb Q_3$
($3^{-2}\mathbb Z_3/3^{3}\mathbb Z_3$; all integrands are locally constant at that
level so the lattice sums are exact, with the omitted balls summed in closed form):

```
  D-fixed point at p: max_y |hat(1_Zp)(y) - 1_Zp(y)| = 1.334e-16
  Z_p(1_Zp, 1, s=0.8) shellsum = 1.7101139544367   (1-p^-s)^-1 = 1.7101139544367
  s = 0.6;   gamma_p(s) = (1-p^-s)/(1-p^{s-1}) = 1.357452243098
    f = 1_{Z_p}          Z(fhat,1-s)/Z(f,s) = 1.357452243098   dev 1.81e-16
    f = 1_{1+pZ_p}       Z(fhat,1-s)/Z(f,s) = 1.357452243098   dev 3.89e-16
    f = 1_{p^-1 Z_p}     Z(fhat,1-s)/Z(f,s) = 1.357452243098   dev 3.08e-16
    f = 1_{Z_p^*}        Z(fhat,1-s)/Z(f,s) = 1.357452243098   dev 2.62e-16
  D^2 = parity at p:  max |F^2 f (y) - f(-y)| = 1.196e-15   (NOT f(y): F is order 4, not 2)
```

Holonomy identity (2), at both places, real and complex $s$:

```
  s=               0.6   trivial: 1.0   sgn: (-1.0 + 0.0j)   (targets +1, -1)
  s=      (0.5 + 7.0j)   trivial: (1.0 + 0.0j)   sgn: (-1.0 + 0.0j)   (targets +1, -1)
  s=      (1.3 - 2.0j)   trivial: (1.0 + 8.3941762043626e-42j)   sgn: (-1.0 - 1.8938869800315e-42j)
  p=3:  s=0.6           gamma_p(s)*gamma_p(1-s) = 1.0
  p=3:  s=(0.5 + 7.0j)  gamma_p(s)*gamma_p(1-s) = (1.0 + 0.0j)
```

So: at $v=\infty$ with $\chi=\mathrm{sgn}$ the two routes around the square differ
by a factor of exact modulus $\gamma^{-2}\chi(-1)$ with $\chi(-1)=-1$ — the
crystal's commutator is genuinely $-1$ times a nonconstant function, not $1$.

### 3.2 Global holonomy

```
  s =                    0.6   prod_v gamma_v(s) = 1.0   |.-1| = 1.15e-41
  s =                    2.3   prod_v gamma_v(s) = 1.0   |.-1| = 0.0
  s =     (0.5 + 14.134725j)   prod_v gamma_v(s) = (1.0 - 1.251213655993151138608e-40j)   |.-1| = 3.03e-40
  s =           (0.3 - 5.0j)   prod_v gamma_v(s) = (1.0 + 6.319023663567718203905e-42j)   |.-1| = 6.32e-42
```

(computed as $\gamma_\infty(s)\cdot\zeta(1-s)/\zeta(s)$, i.e. with the
$p$-product continued; the third point is the first Riemann zero, included
deliberately to show the identity is blind to zeros.)

**A genuinely finite, convergent instance of (4).**  Split
$\gamma_v=\varepsilon_v\cdot L_v(1-s,\bar\chi)/L_v(s,\chi)$.  For a Dirichlet
character mod $m$, $\varepsilon_v=1$ at *every* unramified place, so
$\prod_v\varepsilon_v$ is a **finite** product = the global root number
$\varepsilon(\chi)=\tau(\chi)/(i^\delta\sqrt m)$.  This is the part of the global
holonomy that needs no regularisation at all.  Verified for all 23 primitive
characters of modulus $4,5,7,8,12,13$ at $s=0.63+2i$:

```
  m= 4 ord=2 delta=1  |tau|/sqrt(m)=1.0  eps=1.0 - 6.1e-17j   FE residual = 8.28e-19
  m= 5 ord=4 delta=1  |tau|/sqrt(m)=1.0  eps=0.85065081+0.52573111j  FE residual = 8.42e-17
  m= 7 ord=6 delta=1  |tau|/sqrt(m)=1.0  eps=0.38651357+0.92228372j  FE residual = 5.74e-16
  m=13 ord=12 delta=1 |tau|/sqrt(m)=1.0  eps=0.52216611+0.8528438j   FE residual = 2.33e-16
  ... (23 characters, all |eps| = 1.0, all FE residuals < 1e-14)
```

$|\varepsilon|=1$ in every row is the local-root-number version of "the holonomy
is a phase"; the FE residual is $|\Lambda(1-s,\bar\chi)-\varepsilon^{-1}\Lambda(s,\chi)|/|\cdot|$.

---

## 4. Freund–Witten is the holonomy theorem, cubed

### 4.1 $B_p$, derived from the integral (not from memory)

$B_v(a,b)=\int_{\mathbb Q_v}|x|_v^{a-1}|1-x|_v^{b-1}dx$.  Write $c=1-a-b$, so
$a+b+c=1$.  Partition $\mathbb Q_p$ into four *disjoint balls* — ultrametricity
makes this a partition with no shared boundary, unlike the archimedean case:

| region | integrand | measure/value |
|---|---|---|
| $\|x\|<1$ | $\|x\|^{a-1}$, $\|1-x\|=1$ | $(1-p^{-1})\sum_{n\ge1}p^{-na}=(1-p^{-1})\frac{p^{-a}}{1-p^{-a}}$ |
| $\|1-x\|<1$ | $\|1-x\|^{b-1}$, $\|x\|=1$ | $(1-p^{-1})\frac{p^{-b}}{1-p^{-b}}$ |
| $\|x\|=\|1-x\|=1$ | $1$ | $1-2p^{-1}$ |
| $\|x\|>1$ | $\|x\|^{a+b-2}$ (since $\|1-x\|=\|x\|$) | $(1-p^{-1})\frac{p^{-c}}{1-p^{-c}}$ |

Hence $B_p=(1-p^{-1})\left[\frac{1}{p^a-1}+\frac1{p^b-1}+\frac1{p^c-1}\right]+1-2p^{-1}$.
Setting $u=p^{-a},v=p^{-b},w=p^{-c}$ with the constraint $uvw=p^{-1}$, this
collapses (verified symbolically, `simplify(...) -> 0` in the script) to the
product form:

$$\boxed{\;B_p(a,b)=\frac{(1-p^{a-1})(1-p^{b-1})(1-p^{c-1})}{(1-p^{-a})(1-p^{-b})(1-p^{-c})}
=\prod_{x\in\{a,b,c\}}\frac{\zeta_p(x)}{\zeta_p(1-x)}
=\prod_{x\in\{a,b,c\}}\gamma_p(x)^{-1}.\;}$$

Independent falsifier — direct integration over the lattice model of
$\mathbb Q_p$ with all three omitted regions summed analytically, for real and
complex kinematics:

```
  p=2  (a,b)=(0.3,0.4)   direct=5.8912061536262   closed=5.8912061536262   rel=1.56e-40
  p=2  (a,b)=(0.25+0.3j, 0.35-0.1j)  direct=3.8095601451193-0.15326177838817j  rel=4.07e-41
  p=3  (a,b)=(0.3,0.4)   direct=4.9567960571457   closed=4.9567960571457   rel=1.1e-38
  p=5  (a,b)=(0.3,0.4)   direct=4.0632097326945   closed=4.0632097326945   rel=5.71e-38
```

### 4.2 $B_\infty$, derived the same way

Splitting $\mathbb R$ at $0$ and $1$ (three intervals **sharing endpoints** —
the archimedean loss of the disjoint-ball structure) and substituting
$t\mapsto u/(1-u)$ on the two unbounded pieces:

$$B_\infty(a,b)=\frac{\Gamma(a)\Gamma(b)}{\Gamma(1-c)}+\frac{\Gamma(b)\Gamma(c)}{\Gamma(1-a)}
+\frac{\Gamma(c)\Gamma(a)}{\Gamma(1-b)}
=\frac{\Gamma(a)\Gamma(b)\Gamma(c)}{\pi}\bigl[\sin\pi a+\sin\pi b+\sin\pi c\bigr].$$

Now apply $\sin A+\sin B+\sin C=4\cos\frac A2\cos\frac B2\cos\frac C2$ (valid since
$\pi a+\pi b+\pi c=\pi$) and, for each $x$, the Legendre duplication formula
together with $\cos\frac{\pi x}2=\pi/\bigl(\Gamma(\frac{1+x}2)\Gamma(\frac{1-x}2)\bigr)$:

$$\Gamma(x)\cos\tfrac{\pi x}{2}=\frac{2^{x-1}\sqrt\pi\,\Gamma(x/2)}{\Gamma(\frac{1-x}{2})}
\;\Longrightarrow\;
B_\infty(a,b)=\sqrt\pi\prod_{x\in\{a,b,c\}}\frac{\Gamma(x/2)}{\Gamma(\frac{1-x}2)}
=\prod_{x\in\{a,b,c\}}\gamma_\infty(x)^{-1}.$$

The three separate $\Gamma$-terms become a single product **only through the
reflection formula** — i.e. only through analytic continuation.  That is the
first place where the archimedean side pays a price the finite sides do not.

```
  (a,b)=(0.3,0.4)  quad=16.2338061726  3-Beta=16.2338061726  gamma_inf-form=16.2338061726
        rel(quad,3Beta)=3.99e-14   rel(3Beta,gamma-form)=0.0
  (a,b)=(0.25+0.2j, 0.3-0.15j)  quad=12.4982711083-0.751941302231j
        3-Beta=12.4982711083-0.751941302267j   rel(3Beta,gamma-form)=6.42e-42
```

### 4.3 The theorem

> **Corollary (Freund–Witten = Tate holonomy, three times).**  At **every** place,
> including $v=\infty$, $\;B_v(a,b)=\prod_{x\in\{a,b,c\}}\gamma_v(x)^{-1}$.  Hence
> $$B_\infty(a,b)\prod_p B_p(a,b)=\prod_{x\in\{a,b,c\}}\Bigl(\prod_v\gamma_v(x)\Bigr)^{-1}=1$$
> **is exactly the statement $\prod_v\gamma_v=1$ evaluated at the three Mandelstam
> variables $a,b,c$ with $a+b+c=1$.**  The adelic string product formula carries no
> content beyond the completed functional equation of $\zeta$.

Verified, in the continued (exact) form $\prod_pB_p=\prod_x\zeta(x)/\zeta(1-x)$:

```
  (a,b)=(0.3,0.4)      c=0.3     B_inf * prod_p B_p = 1.0   |.-1| = 3.44e-41
  (a,b)=(1/3,1/3)      c=1/3     B_inf * prod_p B_p = 1.0   |.-1| = 3.44e-41
  (a,b)=(0.15,0.7)     c=0.15    B_inf * prod_p B_p = 1.0   |.-1| = 2.3e-41
  (a,b)=(0.25+0.4j, 0.3-0.2j)  c=0.45-0.2j  ... = 1.0 + 5.0e-42j   |.-1| = 2.35e-41
  (a,b)=(-1.4,0.9)     c=1.5     B_inf * prod_p B_p = 1.0   |.-1| = 9.18e-41
```

The last row is outside the convergence triangle and holds by continuation only.

**Which zeta values appear, exactly.**  $\prod_pB_p(a,b)=\dfrac{\zeta(a)\zeta(b)\zeta(c)}
{\zeta(1-a)\zeta(1-b)\zeta(1-c)}$ — a ratio of six Riemann zeta values at the three
Mandelstam variables and their reflections, and nothing else.  Equivalently, in
string variables ($a=-1-s$ etc., $s+t+u=-4$),
$A_4^{(\infty)}=\zeta(2+s)\zeta(2+t)\zeta(2+u)/\bigl[\zeta(-1-s)\zeta(-1-t)\zeta(-1-u)\bigr]$.
Independently FETCHED and matching: Jepsen, arXiv:2211.01611 eqs. (4)–(9).

---

## 5. Control ledger (designed annihilation, per `collab/messages/0073`)

### C0 — the product formula is **nowhere** a convergent product (a correction)

> **Lemma.** For $a+b+c=1$ there is no $(a,b)$ for which $\prod_pB_p(a,b)$
> converges absolutely.  *Proof.* $\log B_p=\sum_x(p^{-x}-p^{x-1})+O(p^{-2\min})$,
> so absolute convergence needs $\mathrm{Re}\,x>1$ and $\mathrm{Re}(1-x)>1$ for each
> $x\in\{a,b,c\}$ — contradictory.  Cancellation between the two exponent multisets
> $\{a,b,c\}$ and $\{1-a,1-b,1-c\}$ is impossible because they sum to $1$ and $2$
> respectively and hence can never coincide. $\square$

Measured at $a=b=c=1/3$ ($B_\infty=15.8997487526$), against the leading Mertens
prediction $3\sum_{p\le P}(p^{-a}-p^{a-1})$:

```
  P=      10   log(B_inf prod_{p<=P} B_p) =    8.74224296   prediction =    2.605925557   ratio = 3.355
  P=     100                                  24.94712038                  15.42987405            1.617
  P=    1000                                  78.65458745                  64.76087727            1.215
  P=   10000                                 268.6279386                  248.1464061             1.083
  P=  100000                                 973.1740785                  941.8193227             1.033
  P= 1000000                                3684.207611                  3633.825191             1.014
```

The partial products blow up like $\exp\bigl(3P^{2/3}/(\tfrac23\log P)\bigr)$, and
the ratio to the first-order Mertens prediction converges to 1 (3.36 → 1.014),
confirming the divergence is *exactly* the predicted one and not a numerical
artefact.  **So the brief's requested "convergence rate in $P$" does not exist:
the honest answer is a divergence rate, and it is $\log R_P\sim3\sum_{p\le P}p^{-a}$.**
FETCHED confirmation (Jepsen, arXiv:2211.01611, §1, verbatim): *"there is no
kinematic regime for which the product in equation (12) converges; the criterion
Re[z] > 1 required for the convergence of (10) cannot be simultaneously satisfied
for all the local zeta functions in (4)."*  Our multiset argument is a sharper
form of the same obstruction (it also rules out conditional cancellation).

### C1 — wrong additive normalisation, invisible locally, fatal globally

Take $\mathrm{vol}(\mathbb Z_p)=(1-1/p)^{-1}$ (a realistic slip: using the
multiplicatively-normalised measure additively).  Each local factor is then wrong
by $1+1/p+O(p^{-2})\to1$ — undetectable place by place at any fixed tolerance.
The global holonomy:

```
  P=      10   broken global holonomy =  4.375          (correct 1;  e^gamma log P =  4.101)
  P=    1000                            12.35097567                              12.303
  P=  100000                            20.51159283                              20.505
  P= 1000000                            24.60738295                              24.606
```

Log-divergent, tracking $e^\gamma\log P$ (Mertens) to 4 digits.  **This is the
sharpest statement of what the product formula is for: it has infinite
discriminating power against errors that are $o(1)$ at each place.**

### C2 — wrong additive character

$\psi'_p(x)=\psi_p(x/p)$ (conductor $p^{-1}\mathbb Z_p$).  Self-duality of
$\mathbf 1_{\mathbb Z_p}$ dies immediately:

```
  hat(1_Z3)(y) for y = w/3, w = 0..8:  [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                                       (should be all 1.0 if self-dual)
  gamma'_p = p^{s-1} gamma_p:  prod_{p<=10} = 0.1178,  prod_{p<=100} = 2.85e-15,
                               prod_{p<=1000} = 7.64e-167  ->  0   (correct value 1)
```

### C3 — planted-false gamma factor, rejected two ways

Plant $\tilde\gamma_p(s)=\gamma_p(s)\,(1+p^{-2})$.  The perturbation is $o(1)$, so
any *asymptotic* or loosely-toleranced local check passes.  Two independent
rejections:
- **Local, exact:** the measured $Z(\hat f,1-s)/Z(f,s)$ of §3.1 matches the *true*
  $\gamma_p$ to $<4\times10^{-16}$ for all four test functions, so at the same place
  $p=3,s=0.6$ the plant is rejected at relative size $0.111$ ($1.357452$ true vs
  $1.508280$ planted), a $3\times10^{14}$-sigma rejection; at $p=7$ the plant size
  is $0.0204$ against the same $4\times10^{-16}$ noise floor.  Rejected.
- **Global:** $\prod_p(1+p^{-2})=\zeta(2)/\zeta(4)=1.519817754635067\ne1$.  A milder
  plant $(1+p^{-4})$, essentially invisible locally, still gives
  $\zeta(4)/\zeta(8)=1.077928136741855\ne1$.  Rejected.

### C4 — wrong modulus

Using $|x|:=2^{-v_p(x)}$ at every $p$ (base-2 instead of base-$p$; the four-ball
partition no longer telescopes): $B_3=8.1883$ vs correct $4.9568$; $B_5=10.0259$
vs $4.0632$; $B_7=10.8135$ vs $3.6043$.  Broken at every place.

### C5 — the exact test-function class where the verification holds

- **Tate local FE (§§1–3):** $f\in\mathcal S(\mathbb Q_v)$ (Schwartz at $\infty$;
  locally constant of compact support at $p$).  $Z_v(f,\chi,s)$ converges for
  $\mathrm{Re}\,s>0$ and continues meromorphically; the FE is an identity of
  continuations.  Verified for 3 archimedean and 4 p-adic test functions, of
  which 2 archimedean and 3 p-adic are *not* self-dual.
- **Freund–Witten (§4):** $|x|^{a-1}|1-x|^{b-1}$ is **not** Schwartz–Bruhat — it is
  in the Gel'fand–Graev class.  Absolute convergence of $B_v$ requires
  $\mathrm{Re}\,a>0,\ \mathrm{Re}\,b>0,\ \mathrm{Re}(a+b)<1$ (the open triangle);
  outside it, $B_v$ means the meromorphic continuation, i.e. the boxed closed
  forms.  The physical tachyon kinematics lie outside the triangle.
- **Not covered:** ramified $\chi$ at $\infty$ beyond $\mathrm{sgn}$; number fields
  other than $\mathbb Q$; $N$-point amplitudes with $N\ge5$ (where the literature
  says the adelic product is *not* a constant — see §8).

---

## 6. The GR/QM reading, disciplined (one page, every sentence anchored)

### 6.1 What is computed, and what it licenses

The archimedean local factor $\zeta_\infty(s)=\pi^{-s/2}\Gamma(s/2)$ is the **only**
factor in the whole adelic product that is not a rational function of $p^{-s}$:
its poles are $s=0,-2,-4,\dots$, a semi-infinite march down the real axis, while
every finite factor $\zeta_p(s)=(1-p^{-s})^{-1}$ has poles on the exactly periodic
imaginary lattice $\frac{2\pi i}{\log p}\mathbb Z$ (figure panel b).  "Discrete
spectrum at the finite places" is therefore not a metaphor here: it is the literal
pole lattice of the local factor, and the period $2\pi/\log p$ is the quantum of
the value group $p^{\mathbb Z}$.  The corresponding physical statement is a
computed one: the $p$-adic four-point amplitude $B_p$ is a ratio of six local
zeta factors and hence has *finitely many* poles, whereas $B_\infty$ inherits the
infinite pole towers of three $\Gamma$'s — the infinite higher-spin tower of the
real string is exactly the archimedean $\Gamma$ (FETCHED, Jepsen §1: p-adic
amplitudes "contain only a finite number of poles ... rather than semi-infinite
sequences of poles arising from an infinite tower of higher spin particles").

Ultrametric locality is likewise a computed fact and not a slogan: $B_p$ was
obtained by partitioning $\mathbb Q_p$ into **four disjoint balls** with no shared
boundary (§4.1), each contributing a closed geometric sum; the result was matched
by direct lattice integration to $10^{-38}$.  $B_\infty$ required **three intervals
sharing their endpoints**, produced three separate $\Gamma$-ratios, and became a
single product only after invoking reflection and duplication (§4.2).  The
finite places assemble by partition; the archimedean place assembles by analytic
continuation.

The "two halves of one object" claim is the one that is fully earned, and in a
stronger form than the thesis states: at *every* place, $\infty$ included, the
amplitude is $\prod_{x}\gamma_v(x)^{-1}$ — the *same formula* — and the product
over all places is 1 because the local holonomies of one duality square multiply
to 1 (§2(4), §4.3).  There is no privileged half.  The archimedean place is not
"the other side of" the finite places; it is one more place, distinguished only
by the transcendence of its local factor.

### 6.2 The honest tension, and the internal cross-check

The tension the brief demanded is real and is the load-bearing asymmetry: the
archimedean factor is the only non-rational one, and consequently (i) it is the
only place whose amplitude needs a continuation to be written as a product,
(ii) it is the only place carrying an infinite pole tower, and (iii) the whole
product formula is a statement about continued functions because the
$p$-side product diverges everywhere (§5 C0).  **The continuum is the odd place
out, and it is the odd place out in the direction of "needs analysis".**

This is independently what this repository found from the other side.
`notes/FF_PAIRFIELD.md` §2.4 ("the sum spectrum is archimedean") replaces the
archimedean place of $\mathbb Q$ by the discrete place at infinity of
$\mathbf F_q[t]$ and measures which structures survive.  Its verdict: the
sum-frequency line positions $\{\gamma_i+\gamma_j\}$, the $s^{-5/2}$ modulus law,
the entropy phase $-sH(p)$, the Fresnel chirp, and the $e^{-\pi\min}$ suppression
all **die**, because each is downstream of Mellin homogeneity of the continuous
dilation group $\mathbb R_+$ and of Stirling asymptotics of $\Gamma$-kernels;
whereas block decomposition, the coefficient-2 mixed block, pole/zero scale
separation, diagonal dominance and Hermitian-square positivity **survive**
verbatim in a world whose place at infinity has value group $q^{\mathbb Z}$.
That note's slogan — *"the pair field's physics was archimedean optics; its
accounting was the arithmetic"* — is the same finding as §6.1 arrived at from a
completely different computation (exact integer identities on elliptic curves over
$\mathbf F_q$, versus 40-digit local zeta integrals over $\mathbb Q_v$).  Two
independent lanes, one conclusion: **$\Gamma$ is where the continuum's extra
structure lives, and everything that looks like "physics" in these formulas is
$\Gamma$.**  Cross-check accepted; note that correlated agreement between two
lanes of the same fleet is weaker evidence than it looks (`AGENTS.md` norm), but
the two computations share no code, no objects and no method.

### 6.3 What must not be said

Freund–Witten is a real theorem about real amplitudes, and it is *not* about GR
and QM.  It concerns tree-level four-point tachyon scattering in open bosonic
string theory, with the $p$-adic worldsheet a Bruhat–Tits tree (FETCHED: Brekke–
Freund, Phys. Rep. 233 (1993); Zabrodin).  Nothing computed in this lane involves
a metric, a curvature, a state space, an observable, or a measurement.  The
mapping "archimedean = GR, finite = QM" adds no predicate that any object here can
verify or falsify, and per charter §2 it is therefore refused as mythology.  The
defensible residue is narrow and worth exactly its width: *every structure in this
family that resembles continuum geometry — continuous dilation, curvature-like
stationary phase, infinite towers, the need for continuation — is archimedean, and
every structure that resembles arithmetic bookkeeping is common to all places.*
That is a statement about $\Gamma$, not about gravity.

---

## 7. Classical vs. new: the blunt version

**Classical, and quoted rather than claimed:**
Tate's local zeta integrals, the local functional equation, the gamma and epsilon
factors, $\gamma_v=\varepsilon_v L_v(\hat\omega)/L_v(\omega)$, the shifted dual
$\hat\omega=|\cdot|\omega^{-1}$, the self-duality of the Gaussian and of
$\mathbf 1_{\mathbb Z_p}$, the global product formula, the derivation of
$\Lambda(s)=\Lambda(1-s)$ and of the Dirichlet root number
$\varepsilon=\tau(\chi)/(i^\delta\sqrt m)$ from it (Tate 1950/1967).  The
Gel'fand–Graev beta function and its closed form.  The $p$-adic Veneziano
amplitude (Volovich 1987; Freund–Olson 1987), the identity
$A_4^{(v)}=\Gamma_v(a)\Gamma_v(b)\Gamma_v(c)$ at every place, and the adelic
product formula (Freund–Witten 1987).  The non-convergence of the adelic product
(Freund–Witten; stated sharply by Jepsen 2022).

**Not new, but re-derived here from the integrals rather than recalled:**
every displayed formula in §§1–4.  Both boxed closed forms were derived by
partitioning the domain and were then falsified against independent numerics
(lattice integration over $\mathbb Q_p$; `mpmath.quad` over $\mathbb R$).  Two
memory-level statements were checked and would have been corrected if wrong:
the $B_p$ closed form, and the constraint $a+b+c=1$ (both confirmed against the
fetched Jepsen eqs. (4)–(9) *after* independent derivation, not before).

**Possibly new, and probably folklore — claimed only at this weight:**
1. The reading of $\gamma_v$ as the **holonomy of the explicit square
   $\langle\mathcal F,J\rangle$ acting on one space**, with the classical identity
   $\gamma_v(\chi,s)\gamma_v(\chi^{-1},1-s)=\chi(-1)$ derived as the crystal's
   commutator residual forced by $\mathcal F^2=\sigma$ (§2(2)).
2. The statement $\langle D,E\rangle\cong D_\infty$ on the even sector (§2(3)).
   The operators $\mathcal F$ and $J$ and their non-commutation are entirely
   standard (they are the backbone of the Connes/Burnol approach to the explicit
   formula); presenting the group they generate as the charter's "larger dihedral
   orbit" is the framing, not the mathematics.
3. The empty-core lemma $\mathrm{Fix}(D)\cap\mathrm{Fix}(E)=\{0\}$ (§1.3) — a
   two-line consequence of the local FE.
4. The multiset form of the non-convergence obstruction (§5 C0), which rules out
   conditional as well as absolute cancellation.

**Honest total:** the framing is new to this repository; the mathematics is not
new to mathematics.  Anyone auditing this note should treat every §§2–4 statement
as a citation with an attached verification, not as a discovery.

---

## 8. Literature (śabda; every claim labelled)

All items below were **FETCHED this session** unless marked otherwise.

- **FETCHED** P. G. O. Freund and E. Witten, *Adelic string amplitudes*,
  Phys. Lett. B **199** (1987) 191–194.
  <https://www.sciencedirect.com/science/article/abs/pii/0370269387913578> (record
  reached; publisher body 403 on direct fetch) and
  <https://ui.adsabs.harvard.edu/abs/1987PhLB..199..191F>.  Content confirmed via
  search-result summary and via two independent citing sources below: *"the
  Veneziano and Virasoro–Shapiro four-particle scattering amplitudes can be
  factored in terms of an infinite product of non-archimedean string amplitudes,
  and this factorization is equivalent to the functional equation for the Riemann
  zeta function."*  **Fence:** we did *not* obtain the paper's own text; the
  bibliographic data and the content statement are corroborated by the nLab entry
  and by Jepsen 2022, both fetched in full.
- **FETCHED** I. V. Volovich, *p-adic string*, Class. Quantum Grav. **4** (1987)
  L83.  <https://iopscience.iop.org/article/10.1088/0264-9381/4/4/003> (record).
  Originating observation that the Veneziano integral generalises from $\mathbb R$
  to $\mathbb Q_p$; also the Galois-field/Jacobi-sum analogue.
- **FETCHED** L. Brekke and P. G. O. Freund, *p-adic numbers in physics*,
  Phys. Rep. **233** (1993) 1–66.
  <https://www.sciencedirect.com/science/article/abs/pii/037015739390043D>;
  worldsheet = Bruhat–Tits tree of incidence number $p+1$; adelic string.
- **FETCHED, full text** C. B. Jepsen, *Adelic Amplitudes and Intricacies of
  Infinite Products*, Nucl. Phys. B (2023) 116094, arXiv:2211.01611.
  <https://arxiv.org/abs/2211.01611>, <https://arxiv.org/pdf/2211.01611>.
  Its eqs. (4)–(9) give $A_4^{(v)}=\Gamma_v(-1-s)\Gamma_v(-1-t)\Gamma_v(-1-u)$ with
  $\Gamma_v(x)=\zeta_v(x)/\zeta_v(1-x)$, $\zeta_p(x)=(1-p^{-x})^{-1}$,
  $\zeta_\infty(x)=\pi^{-x/2}\Gamma(x/2)$ — **matching our §4 derivation exactly**
  (their $\Gamma_v$ is our $\gamma_v^{-1}$, their $(-1-s,-1-t,-1-u)$ our $(a,b,c)$
  with $a+b+c=1$ from $s+t+u=-4$).  Its §1 states the non-convergence quoted in
  §5 C0, and its footnote 2 flags that even granting $\Gamma_\infty(z)\prod_p\Gamma_p(z)=1$
  in a regulated sense, an extra distributivity assumption is needed.  It further
  shows the **5-point** adelic product is *not* a constant, and is not a single
  analytic function — a fence on any "the adelic product is always 1" reading.
- **FETCHED, full text** B. DeJean, *Tate's Thesis* (Chicago REU 2017),
  <https://math.uchicago.edu/~may/REU2017/REUPapers/DeJean.pdf>.  Used for the
  precise statement of the local functional equation (Thm 3.10:
  $\gamma_v(\omega,\psi)\,z(\omega)=\widehat{z(\hat\omega)}$,
  $\gamma_v=\varepsilon_v L_v(\hat\omega)/L_v(\omega)$), the shifted dual
  $\hat\omega=|\cdot|_v\omega^{-1}$ (Defs. 3.9), the self-dual measure condition,
  the global FE via Poisson summation / Riemann–Roch (Thms 4.12–4.16), the
  worked $\zeta$ case ("every $\varepsilon_p$ is 1", §5.1) and the Dirichlet case
  ($\varepsilon_\infty=1$ or $i$ per $\chi(-1)$; $\prod_{p\mid m}\varepsilon_p=m^{-s}\tau(\chi)$, §5.2).
- **FETCHED** B. Dragovich, A. Yu. Khrennikov, S. V. Kozyrev, I. V. Volovich,
  *On p-Adic Mathematical Physics*, arXiv:0904.4205 — review; confirms the
  Gel'fand–Graev beta function as the crossing-symmetric $p$-adic amplitude
  (Freund–Olson) and the idele product $\prod_v|x|_v=1$ as the founding formula.
- **FETCHED** nLab, *p-adic string theory*,
  <https://ncatlab.org/nlab/show/p-adic+string+theory>: "the ordinary Veneziano
  amplitude equals the inverse of the product of its p-adic versions, for all
  primes p", "apparently a version of the idelic product formula".
- **UNVERIFIED-MEMORY, flagged and not used:** J. Tate's 1950 Princeton thesis as
  reprinted in Cassels–Fröhlich (1967) — we did not fetch the primary text; every
  Tate-attributed statement above is instead sourced to the fetched DeJean
  exposition, which cites Tate [9] and Ramakrishnan–Valenza [8].
- **UNVERIFIED-MEMORY, flagged and not used:** any claim that the convergence of
  partial Euler products for $\tfrac12<\mathrm{Re}\,s<1$ is RH-equivalent.  An
  earlier draft of this note contained such a remark; it was **removed** after the
  elementary check that $\sum_{p\le P}p^{-\sigma}\sim P^{1-\sigma}/((1-\sigma)\log P)
  \to\infty$ for $\sigma<1$ *unconditionally*, so the partial Euler product diverges
  regardless of RH and the remark was simply wrong.  Recorded here rather than
  deleted, per the corrections norm.

---

## 9. Residual fed back to the frontier (charter step 6)

1. **The holonomy is a gamma factor; gamma factors are where root numbers live;
   root numbers are where sign obstructions live.**  The lane's theorem says the
   only invariant of the crystal is $\prod_v\gamma_v=1$.  Question for the pair-field
   program: is there a *two-variable* crystal whose global holonomy is a nontrivial
   finite object (a root number of a rank-2 family) rather than 1?  That is where a
   Weil-positivity-style obstruction (`notes/WEIL.md`, `notes/BLOCKS.md` §2.1) would
   have to appear, since positivity is not visible to a single $\gamma_v$.
2. **The $D_\infty$ orbit is unexplored.**  §2(3) shows $(\mathcal FJ)^n$ has
   multiplier $\gamma_v^{\,n}$.  The operator $\mathcal FJ$ at $v=\infty$ is the one
   whose spectral analysis carries the explicit formula (Connes/Burnol); the finite
   places contribute the *same* crystal with a rational multiplier.  Concrete
   question: does the $D_\infty$ presentation give a uniform (place-independent)
   statement of the explicit formula in which the archimedean term is not special —
   i.e. can the $\Gamma$-artefacts catalogued in `FF_PAIRFIELD.md` §4 be attributed
   to a *single* property of $\gamma_\infty$ (transcendence / infinite pole tower)
   rather than to a list of separate mechanisms?
3. **The non-convergence is structural, not technical.**  §5 C0 shows the divergence
   comes from the impossibility of $\{a,b,c\}=\{1-a,1-b,1-c\}$.  Jepsen's 5-point
   result (product converges in some kinematic regimes but is *not* constant) says
   the higher-point adelic object is genuinely new mathematics, not a corollary of
   the functional equation.  If a lane wants a physics instance with content beyond
   Tate, it must go to $N\ge5$.  That is the honest frontier here, and this note
   does not touch it.
4. **Function-field cross-column.**  `FF_PAIRFIELD.md` asks (its §6.2) for the
   $q\to1$ degeneration of the node kernel into the $\Gamma$-kernel.  The present
   note gives the $\gamma$-factor version of the same question: $\gamma_p(s)=
   \frac{1-p^{-s}}{1-p^{s-1}}$ degenerates to $\gamma_\infty(s)$ in what limit, and
   at which step does transcendence appear?  This is a sharper and more tractable
   form of that request, since both sides are one-line closed forms.

---

## 10. Reproduction

`python3 code/exp63_adelic_crystal.py` (~7 min at `mp.dps = 40`).  Sections:
1 archimedean corners + test-function independence + fixed points; 2 exact
$\mathbb Q_p$ lattice model, $\widehat{\mathbf 1_{\mathbb Z_p}}$, four p-adic test
functions, $\mathcal F^2=\sigma$; 3 global holonomy at four $s$ including a zero of
$\zeta$, plus 23 primitive Dirichlet root numbers; 4 symbolic collapse of the
four-ball shell sum, $B_p$ direct-vs-closed at $p=2,3,5$, $B_\infty$ three ways,
the product formula at five kinematics; 5 controls C0–C5; 6 figure.
Figure: `figures/exp63_adelic_crystal.png` (crystal square; local pole sets;
divergence of the truncated product; control ledger).

**Pramāṇa labels.**  pratyakṣa — every number quoted above is printed by the
script.  anumāna — §1.2, §1.3, §2(1)(2)(3), §4.1, §4.2, §5 C0 are complete proofs;
§2(4) is quoted, not proved here, and its proof (Poisson summation on
$\mathbb A_\mathbb Q$) is named but not reproduced.  śabda — §8, every item
labelled FETCHED with a URL or UNVERIFIED-MEMORY and then not used.

**Status: PENDING HOSTILE AUDIT.**
