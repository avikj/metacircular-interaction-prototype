# Cross-review: Theorem F8 — the corrected octic obstruction (`OCTIC_OBSTRUCTION_V2.md`, `exp38`)

Hostile audit of the successor octic artifact, requested by its own closing
line ("requires a fresh hostile audit of this successor artifact") and by the
status flag in `RIGIDITY_FRONTIER.md` §6.  Target:
`notes/OCTIC_OBSTRUCTION_V2.md`, `code/exp38_octic_certificate.py`,
`code/exp38_octic_enumerator.cpp`, `code/exp38_octic_bounds.hpp`,
`machinery/specs/octic-graeffe-exp38.json`.

Method: independent re-derivation of every bound from scratch before reading
the note's justification; three mutually independent enumerations (production,
a differently-structured generated enumerator, and a complete no-narrowing
brute force); an independent downstream pipeline built on different primitives
(arb certified enclosures, FLINT factorisation and resultants) instead of the
certificate's Sturm/Cayley–Routh/Bareiss kernel; a cross-parametrisation check
against `exp34`; and the mandated planted-good / planted-false controls.
Audit tool: `code/audit_octic_v2.py` (stages `A B C D E X`).  Everything is
exact — integers, `fractions.Fraction`, sympy, FLINT `fmpz`.  No float appears
anywhere on a certificate path, in theirs or in mine.

The predecessor (`exp36_octic_*`, `OCTIC_OBSTRUCTION.md`) died of a reversed
coefficient index that shrank the enumeration box.  That is the failure mode
this audit was pointed at, so §2 below is the heart of the review.

## 0. Verdict

| claim | verdict |
|---|---|
| **Theorem F8**: for every real $X\ge2$, $F_X$ has no irreducible factor of degree eight | **CONFIRMED — with edits** (§8). I could not break it. Three independent enumerations and an independent downstream pipeline agree exactly; the enumeration box and the ascending Graeffe vector are proved supersets with 10–55 % headroom |
| the ascending Graeffe vector $(12,59,150,209,159,64,12)$ is *safe* (a superset of the true majorant) | **CONFIRMED** (§2.3). Sharp majorant re-derived exactly: $(10.888,47.600,107.777,137.601,102.685,44.430,10.333)$ |
| the coefficient box $(9,34,73,93,72,34,8)$ is safe | **CONFIRMED** (§2.2). Sharp maxima $(8.589,31.719,65.674,83.250,66.060,32.009,8.655)$. The $|h|\le8$ face is **tight** — $8.6548$ floors to $8$ with nothing to spare |
| the enumerator's four linear $d$-intervals lose no candidate | **CONFIRMED by exhaustion** (§3.3): a full no-narrowing scan of all $167{,}507{,}657{,}625$ $d$-values in the box reproduces the census byte-for-byte |
| the exact ledger $139{,}448\to37{,}284\to7{,}092\to2{,}473\to6{,}840\to6{,}838$ and the cutoff census | **CONFIRMED** (§4), reproduced verbatim by the artifact and independently by a disjoint implementation |
| §1's sourcing of the coefficient box ("unchanged from the derivation recorded in the historical note") | **BROKEN REFERENCE — must be fixed** (§8, E-1). The historical note is quarantined *and physically absent from the tree*. The only containment argument in the artifact points at a document that does not exist |
| the note's implicit cage (§1 "odd-support root annulus") | **UNDER-SPECIFIED and load-bearing** (§2.4, E-2). The bounds are valid **only** under the sharp cage $\varphi^{-1}<r<\sqrt2$ of `NONRECIPROCAL_DECIC_FRONTIER.md` §1, which `OCTIC_OBSTRUCTION_V2.md` never cites. Under the generic Newman cage $r<2$ every one of the seven Graeffe bounds and six of the seven box faces would be **undersized** |
| the quarantine premise of msg 0033 ("the $y^5$ and $y^6$ filters were too tight") | **NOT REPRODUCIBLE** (§5). On the proved cage *both* orientations are valid supersets; the two censuses are related by the exact reciprocal involution, which is why every stage count is identical. The quarantine was right to fire but its stated reason is wrong |
| "for every real $X\ge2$" | **CONFIRMED, with an unstated step** (§7, E-4): $2\le X<11$ is covered by $\deg F_X\le5<8$, which appears nowhere |
| `FACTOR_ARCHITECTURE.md`'s sector floors | **SURVIVE** (§7). No downstream silently strengthens F8 |

## 1. What was re-run verbatim

The artifact reproduces exactly, on this machine, from a clean build:

```text
$ python3 exp38_octic_certificate.py
corrected octic certificate: PASS
enumerator counts: (42025, 895762875, 206489067, 122320525, 139448, 95116)
Graeffe bounds y^1..y^7: (12, 59, 150, 209, 159, 64, 12)
no-real tuples: 37284
rational-annulus tuples: 7092
symmetry orbits: 2473
reducible orbits: 78
irreducible candidates: 6840
cyclotomic exclusions: 2
tail certificates by cutoff: {11: 5535, 13: 509, 17: 311, 19: 138, 23: 174, 29: 60,
 31: 39, 37: 31, 41: 9, 43: 9, 47: 9, 53: 5, 59: 2, 61: 3, 67: 0, 71: 2, 73: 0,
 79: 0, 83: 2}
minimum margin candidate: (-1, 0, 0, 0, 1, 1, -2) at 11
minimum margin decimal: 0.115638292823
binary sha256: 6b5311df468c70d644228a02c7f07b684073e91d23470acc052569d09c439413
compiler: c++ (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
flags: -std=c++17 -O3
elapsed seconds: 1136.383803
```

Every number in `OCTIC_OBSTRUCTION_V2.md` §2 and §3 is printed by this run.
An independent build of the enumerator from the same source gives the same
binary hash, and the standalone run costs 80 s:

```text
$ ./ref_enum   (stderr)
42025 895762875 206489067 122320525 139448 95116
real  1m20.683s
```

Trust-boundary claims of §4 were checked at source level and all hold: the
`__debug__` guard is present; the only import is `exact_polynomial`, with no
path to any `exp36` file; the Hadamard constants are right
($1+34^2+93^2+34^2+1=10963<105^2$, $9^2+73^2+72^2+8^2=10658<105^2$, and every
Bareiss numerator is a difference of products of two minors of order $\le6$,
so below $2\cdot105^{12}<2^{82}$, as the `static_assert` says); every Bareiss
division is checked; the shipped header is byte-identical to the contract
emission.  Grep for floating-point on the certificate path returns a single
`float(...)` call, inside a `print`; every arithmetic value is `int` or
`Fraction`.

## 2. The containment proof, re-derived from scratch (stage B)

This is the section the predecessor failed.  I derived the box and the
majorant before reading the note's account of them, and only then compared.

### 2.1 The cage

For $X\ge3$, $F_X(x)=1+\sum_{\ell}\varepsilon_{2\ell+1}x^{2\ell+1}$ with
$\varepsilon_N=1$, $N=2m+1$.  Re-proving `NONRECIPROCAL_DECIC_FRONTIER.md`
(1.1) independently:

* **inner.** If $F_X(z)=0$ and $r=|z|\le\varphi^{-1}$ then
  $1\le\sum_{\ell=0}^{m}r^{2\ell+1}<r/(1-r^2)\le1$, using that
  $r\mapsto r/(1-r^2)$ increases on $(0,1)$ and equals $1$ at $\varphi^{-1}$.
* **outer.** Dividing by $z^N$, the top term is $1$, so
  $1\le r^{-N}+\sum_{k=1}^{m}r^{-2k}$.  At $r\ge\sqrt2$ this is
  $\le2^{-m-1/2}+(1-2^{-m})=1-2^{-m}(1-2^{-1/2})<1$.

Both are exact and $m$-uniform, and the audit re-checks the two scalar facts
in $\mathbb Q$ with the conservative rational endpoints actually used:

```text
[ok ] 61/100 < 1/phi (i.e. B^2+B-1 < 0): B^2+B-1 = -179/10000
[ok ] B/(1-B^2) < 1 so no root has modulus <= 61/100: 6100/6279 = 0.971492
[ok ] 1415/1000 > sqrt(2) (i.e. A^2 > 2): A^2 = 80089/40000
```

So every root of every divisor of $F_X$ lies in $\varphi^{-1}<r<\sqrt2$, and
*a fortiori* in the enlarged rational annulus $[61/100,\;1415/1000]$.  Working
in the enlarged annulus only weakens the bounds, so any bound proved there is
safe.  Also, $g$ monic of degree $8$ dividing $F_X$ has $g(0)=\pm1$; $F_X$ has
exactly one real root (as $F_X(-t)$ is strictly decreasing), and $g$'s real
roots have even count, so $g$ has none, its roots pair into conjugates, the
root product is positive and $g(0)=+1$.  This is the same argument as
`PARITY_RESULTANT.md` Theorem 1b and it also licences the certificate's
`real_root_count(...) != 0 -> reject` filter.

### 2.2 The extreme-point lemma and the coefficient box

> **Lemma.** Let $0<m\le M$, $n\ge2$, and
> $K=\{t\in[m,M]^n:\prod t_i=1\}\ne\emptyset$.  For $1\le k\le n-1$, some
> maximiser of $e_k$ on $K$ has at most one coordinate in the open interval
> $(m,M)$.
>
> *Proof.* $K$ is compact, so a maximiser $t$ exists.  Suppose
> $t_i,t_j\in(m,M)$, $i\ne j$; let $t'$ be the other $n-2$ coordinates and
> $P=t_it_j$.  Then
> $e_k(t)=e_k(t')+(t_i+t_j)e_{k-1}(t')+P\,e_{k-2}(t')$ with every
> $e_l(t')\ge0$, so $e_k$ is nondecreasing in $t_i+t_j$.  Moving along
> $\{(u,P/u)\}$ keeps the product and stays in $K$ for
> $u\in[\max(m,P/M),\min(M,P/m)]$; $u+P/u$ is strictly convex, so its maximum
> on that interval is at an endpoint, where one of the two coordinates hits a
> bound.  The move cannot decrease $e_k$, so it produces another maximiser
> with strictly more coordinates at bounds.  Iterate. $\square$

Consequently every maximiser is $j$ copies of $M$, $l$ copies of $m$, and at
most one free $s$, with $j+l\in\{n-1,n\}$; the product constraint pins $s$.
Finitely many configurations, all enumerated exactly in $\mathbb Q$ by
`max_elementary_symmetric`.  For $n=8$, $[m,M]=[61/100,1415/1000]$ there is a
unique feasible configuration ($4$ at $M$, $3$ at $m$, one free), and
$|e_k(\text{roots})|\le\max e_k(\text{moduli})$ gives

```text
coefficient box, max e_k over r in [61/100, 1415/1000], prod=1:
[ok ] |a| <= 9 (true max e_1 = 8.588967, floor 8)
[ok ] |b| <= 34 (true max e_2 = 31.718714, floor 31)
[ok ] |c| <= 73 (true max e_3 = 65.674200, floor 65)
[ok ] |d| <= 93 (true max e_4 = 83.250086, floor 83)
[ok ] |e| <= 72 (true max e_5 = 66.059979, floor 66)
[ok ] |f| <= 34 (true max e_6 = 32.009005, floor 32)
[ok ] |h| <= 8 (true max e_7 = 8.654833, floor 8)
```

The shipped box is a strict superset in six faces.  **The $|h|\le8$ face is
tight**: the true supremum is $8.6548$, saved only by $h\in\mathbb Z$.  A
slightly weaker cage pushes it over $9$ and the box becomes undersized (see
§2.4).  This is the single most fragile number in the artifact.

### 2.3 The ascending Graeffe vector

Symbolically (stage A) — not from the note's formulas but from
$G(x^2)=g(x)g(-x)$:

```text
[ok ] G(x^2) == g(x)*g(-x)
[ok ] [y^(8-k)]G = (-1)^k e_k(squared root moduli)
[ok ] note formula for [y^1]G: 2*f - h**2
[ok ] note formula for [y^2]G: 2*d - 2*e*h + f**2
[ok ] note formula for [y^3]G: 2*b - 2*c*h + 2*d*f - e**2
[ok ] note formula for [y^4]G: -2*a*h + 2*b*f - 2*c*e + d**2 + 2
[ok ] note formula for [y^5]G: -2*a*e + 2*b*d - c**2 + 2*f
[ok ] note formula for [y^6]G: -2*a*c + b**2 + 2*d
[ok ] note formula for [y^7]G: -a**2 + 2*b
[ok ] certificate direct_graeffe == symbolic G (all 9 coefficients)
[ok ] certificate explicit_graeffe == symbolic G (all 9 coefficients)
```

The certificate's `check_coefficient_indices` only tests nine *probes*; the
audit checks the same two expansions as identities in
$\mathbb Z[a,b,c,d,e,f,h]$.  They are identities.

The orientation is therefore fixed: $|[y^{8-k}]G|=e_k(t)$ with $t_i=|r_i|^2$,
$\prod t_i=1$, $t_i\in[B^2,A^2]$.  The same lemma gives the sharp majorant,
exactly:

```text
sharp ascending majorant (exact):
  [y^1]  <= 8306645394208986772739520954102167758169/762908592640000000000000000000000000000  = 10.888127
  [y^2]  <= 1082220039251236861427626600602692200402340707/22735528153279119616000000000000000000000000  = 47.600391
  [y^3]  <= 73023688985511318061405365909172474730850465361259/677544132279112162005499110400000000000000000000  = 107.777022
  [y^4]  <= 149335217535978150875942337616598877166443632706197/1085276640202036278857168365056512000000000000000  = 137.601061
  [y^5]  <= 696511328389070369625340239464959187204033047/6782979001262726742857302281603200000000000  = 102.685167
  [y^6]  <= 75341783373920696447149709308528904201003/1695744750315681685714325570400800000000  = 44.429908
  [y^7]  <= 54756281236189557870251136546941813/5299202344736505267857267407502500  = 10.332929
[ok ] claimed ascending vector dominates the sharp majorant
```

$(12,59,150,209,159,64,12)$ dominates $(10.89,47.60,107.78,137.60,102.69,
44.43,10.33)$ coordinatewise, with 10–55 % headroom.  **The enumeration box
is a proved superset of every possible candidate.**  Note also that the
majorant is *not* palindromic and is smaller at low exponents — the same
qualitative orientation as the shipped vector, which is a weak independent
confirmation that the orientation was fixed correctly this time.

### 2.4 Where the artifact is one citation away from being wrong

The bounds are safe *only* because of the $\sqrt2$ sharpening.  Replacing it
by the generic $0$–$1$ (Newman/Odlyzko–Poonen-style) bound $r<2$ — which is
what "odd-support root annulus" reads like on its own, and which is the cage
one would reconstruct from the code's own `OUTER = 20001/10000` — gives

```text
under the generic Newman cage r<2 (no odd-support sharpening):
  sharp ascending majorant = (12.727, 65.694, 175.461, 256.311, 199.975, 77.685, 14.303)
  -> the claimed vector would be UNDERSIZED at exponents [1, 2, 3, 4, 5, 6, 7]
  required coefficient box = {'a': 9, 'b': 36, 'c': 77, 'd': 98, 'e': 76, 'f': 35, 'h': 9}
  -> the enumeration box would be UNDERSIZED in ['b', 'c', 'd', 'e', 'f', 'h']
```

Every one of the seven Graeffe bounds and six of the seven box faces would be
too small — an undersized census, i.e. exactly the predecessor's disease.
`OCTIC_OBSTRUCTION_V2.md` states these bounds without a proof and without a
citation, and defers to a note that has been deleted (§8, E-1/E-2).  The
theorem is true; the artifact does not currently contain the reason.

## 3. Three independent enumerations (stages C, X)

### 3.1 Production (`exp38_octic_enumerator.cpp`)

`42025 895762875 206489067 122320525 139448 95116`, 80 s.

### 3.2 Independent generated enumerator

`audit_octic_v2.py` stage C emits its own C++ that differs in the two places
where an error could hide: the $d$-range is narrowed by the **quadratic**
$[y^4]$ bound plus the two linear $[y^2],[y^6]$ bounds (the reference uses
four *linear* bounds $[y^2],[y^6],[y^3],[y^5]$), and $\operatorname{Res}_y(E,O)$
is evaluated from a 76-term closed form expanded by sympy instead of a
Bareiss elimination on the Sylvester matrix.

```text
STAGE C: independent enumerator (independent), bounds (12, 59, 150, 209, 159, 64, 12)
  stage counts: (42025, 895762875, 447409401, 122320525, 139448, 95116)
```

Stage 3 differs (it counts $d$-values *visited*, an implementation artifact:
447 M vs 206 M).  Stages 1, 2, 4, 5, 6 agree exactly, and the emitted census
is byte-identical in emission order.

### 3.3 Complete brute force — no narrowing at all

The decisive control.  Every $d\in[-93,93]$ is tested against the full
ascending vector by direct convolution, for every surviving
$(a,b,c,e,f,h)$:

```text
STAGE BRUTE: no-narrowing census over a in [-9,9]
  d scanned / graeffe / unit / emitted: 167507657625 122320525 139448 95116
  [ok ] no-narrowing census equals the production census on a in [-9,0]: 95116 vs 95116
```

$167{,}507{,}657{,}625=895{,}762{,}875\times187$ is the entire box.  All three
censuses hash identically:

```text
591f812cc2d404e31440402594f4061309226be2ab4da3beb2bd00ba0ed6ae98  ref_out.txt
591f812cc2d404e31440402594f4061309226be2ab4da3beb2bd00ba0ed6ae98  audit_enum_independent.txt
591f812cc2d404e31440402594f4061309226be2ab4da3beb2bd00ba0ed6ae98  audit_brute_-9_9.txt
```

The reference's four linear $d$-intervals discard **nothing**.  A randomised
control agrees: on 4 000 random $(a,b,c,e,f,h)$ states, the narrowed $d$-set
equals the brute-force $d$-set every time.

## 4. Independent downstream pipeline (stage E)

Rebuilt on primitives disjoint from the certificate's: arb ball arithmetic
with certified root isolation instead of Cayley + Routh; FLINT factorisation
instead of the hand-written quadratic/quartic divisor search; FLINT
resultants instead of `exact_polynomial.bareiss_determinant`; exact
`Fraction` margins.

```text
  certified-enclosure gates: no-real(a<=0) = 27235, annulus(a<=0) = 4903,
                             unresolved = 0, enclosure-undecided = 0
  annulus by a: {-9: 0, -8: 0, -7: 0, -6: 0, -5: 0, -4: 3, -3: 131, -2: 415,
                 -1: 1640, 0: 2714}
[ok ] annulus-by-a matches the certificate's table
[ok ] labelled no-real total = 37,284
[ok ] labelled rational-annulus total = 7,092
[ok ] symmetry orbits = 2,473
[ok ] reducible orbits = 78 (flint factorisation)
[ok ] irreducible orbits = 2,395
[ok ] labelled irreducible candidates = 6,840
[ok ] Phi_15 and Phi_30 are present
[ok ] noncyclotomic candidates = 6,838
[ok ] no prefix resultant vanishes before the chosen cutoff
[ok ] every noncyclotomic candidate is closed: 6838
```

The whole ledger of §3 of the note is independently reproduced.  Two structural
sub-checks that the certificate leaves implicit and that I verified separately:

* the $a\le0$ restriction is sound — the filters are invariant under
  $g(x)\mapsto g(-x)$ ($E$ fixed, $O\mapsto-O$, so $G$ is fixed and
  $\operatorname{Res}(E,O)\mapsto\pm\operatorname{Res}(E,O)$), and the tail
  stage is run on all $6{,}838$ labelled candidates, not on orbits;
* the certificate's `reducible_octic` search box is complete: a reducible
  octic with no real roots has a monic factor of degree $2$ or $4$ with
  constant term $+1$; no-real forces the quadratic middle coefficient into
  $\{-1,0,1\}$, and the quartic maxima are
  $|A|\le4.259$, $|B|\le6.545$, $|C|\le4.274$, inside the searched
  $(\pm4,\pm8,\pm4)$.

**One difference, benign.** The per-cutoff split moves with the radius
algorithm:

```text
tail certificates by cutoff (independent radii): {11: 5536, 13: 508, 17: 311,
  19: 139, 23: 173, 29: 62, 31: 37, 37: 31, 41: 9, ...}
the certificate's own table                    : {11: 5535, 13: 509, 17: 311,
  19: 138, 23: 174, 29: 60, 31: 39, 37: 31, 41: 9, ...}
```

Totals are identical ($6{,}838$) and every candidate closes in both.  The
split is a property of the 14-step Cayley–Routh bisection, not of the
theorem; the note presents it as if it were canonical (§8, E-6).

### 4.1 Exact tail spot-checks, no ball arithmetic

For the twenty smallest margins — including all of the artifact's smallest —
the radii were recomputed by a route with no root isolation at all: the
composed product $g\circledast g$, whose power sums are $p_n(g)^2$, built by
Newton's identities into a monic degree-64 polynomial in $\mathbb Z[y]$ whose
positive real roots are exactly the four squared pair-moduli, verified to have
exactly four distinct positive real roots, then bisected by exact Sturm
counting.  Margins recomputed as exact `Fraction`s:

```text
[ok ] (-1, 0, 0, 0, 1, 1, -2) @ 11: |Res|=413,   exact margin 0.326931 > 0
[ok ] (0, 0, 1, -1, -1, 0, 0) @ 11: |Res|=8435,  exact margin 1.6693 > 0
[ok ] (-1, 1, 0, 1, -1, 3, -2) @ 11: |Res|=211,  exact margin 1.9798 > 0
[ok ] (0, 0, 0, 1, 0, -1, -1) @ 11: |Res|=2133,  exact margin 2.12173 > 0
[ok ] (0, 0, 1, 3, 0, 0, 1)  @ 11: |Res|=2319,  exact margin 2.93815 > 0
   ... (all twenty positive)
[ok ] minimum-margin candidate is (-1,0,0,0,1,1,-2) at cutoff 11
```

The artifact's own minimum margin is $0.1156$; mine for the same candidate is
$0.3269$, larger because my radii are tighter — the correct direction, and a
useful sanity check that the margin is monotone in the radii as the derivation
requires.  I re-derived the tail inequality itself and it matches
`tail_margin` exactly:
$R_q(1-u_1^2)^2>u_1^{2(p^+-2)}B_q(u_2)^2B_q(u_3)^2B_q(u_4)^2$, with
$B_q(u)=\sum_{p\le q}u^{p-2}$, $|F_q(\alpha)|^2\ge R_q/\prod B_q(u_k)^2$ and
$|F_X(\alpha)-F_q(\alpha)|\le u_1^{p^+-2}/(1-u_1^2)$ (all added exponents are
odd and $\ge p^+-2$).

Three of the twenty in fact leave the proved cage — e.g.
$(-1,3,-1,2,0,2,0)$ has $\max|root|^2=2.1428>2$ — so they could have been
discarded before the tail stage.  Harmless (a looser gate is a superset) but
it shows the note's stated §1 justification and the code's actual
`INNER/OUTER` constants are different objects (§8, E-5).

## 5. The quarantine story does not reproduce (stage C, reversed vector)

Running the same pipeline with the quarantined orientation
$(12,64,159,209,150,59,12)$:

```text
STAGE C: independent enumerator (reversed), bounds (12, 64, 159, 209, 150, 59, 12)
  stage counts: (42025, 895762875, 447407865, 122320525, 139448, 95217)

full labelled corrected: 139448  reversed: 139448
leave (in corrected only): 1752   enter (in reversed only): 1752
reversed census == reciprocal(corrected census)? True
```

and, checking §3's finer claim,

```text
  leave: no-real=514, rational-annulus survivors=0
  enter: no-real=514, rational-annulus survivors=0
```

So §3's "$1{,}752$ leave and $1{,}752$ enter, the two sets are reciprocal,
each contains $514$ no-real tuples and no rational-annulus survivor" is
**exactly right**, and the audit explains it: reversing the bound vector is
*precisely* conjugation by the reciprocal involution
$(a,b,c,d,e,f,h)\mapsto(h,f,e,d,c,b,a)$, which reverses $G$.  Hence every
stage count is forced to be equal, and the reversed census is the reciprocal
image of the corrected one.

> **[SEED-73, 2026-08-14, edit E-9.]** ~~The reversed-vector rerun (`STAGE C
> (reversed)`) is the evidence for the sentence above.~~  Superseded step: it
> is a four-line identity, and needs no run.  Substituting
> $\rho:(a,b,c,d,e,f,h)\mapsto(h,f,e,d,c,b,a)$ into §2.3's own expansions gives
> $[y^7]G\circ\rho=-h^2+2f=[y^1]G$, $[y^6]G\circ\rho=-2he+f^2+2d=[y^2]G$,
> $[y^5]G\circ\rho=-2hc+2fd-e^2+2b=[y^3]G$, and
> $[y^4]G\circ\rho=-2ha+2fb-2ec+d^2+2=[y^4]G$; so $[y^k](G\circ\rho)=[y^{8-k}]G$
> identically in $\mathbb Z[a,\dots,h]$, whence $\rho(C(v))=C(\bar v)$ for any
> bound vector $v$ and its reversal $\bar v$.  E-7 is thereby strengthened from
> "the audit cannot reproduce msg 0033's reason" to "the reason is refutable on
> paper".  Further (new): the $1{,}752$ leaving and $1{,}752$ entering tuples
> contain **no reciprocal tuple** — $\rho(L)=E$ and $L\cap E=\varnothing$, so a
> $\rho$-fixed tuple in $L$ would lie in $E$ — and $\rho$ pairs them into $876$
> *free* orbits straddling the two censuses.  The orientation hazard never
> touched the reciprocal slice, which is why §6's `exp34` control cannot
> corroborate this section.  See
> `notes/SEED73_OCTIC_CROSSREVIEW_REDACTION.md` §§2–3, and
> `notes/SEED34_REVERSAL_INVOLUTION_SIGN_LAW.md` §1 for why $g(0)=+1$ (§2.1
> here) is the hypothesis that makes $\rho$ an involution at all.

But msg 0033's stated premise — that the reversed vector made "the $y^5$ and
$y^6$ filters too tight" — does **not** hold on the proved cage: stage B shows
$(12,64,159,209,150,59,12)$ also dominates the sharp majorant
$(10.89,47.60,107.78,137.60,102.69,44.43,10.33)$ at every exponent.  Under the
weaker $r<2$ cage *both* vectors are undersized.  Either way, the orientation
was never the real hazard; the cage was.  The quarantine was the right call
(an unverifiable bound is an unusable bound) but `MATH_OS.md` §3,
`EXP_LEDGER.md` and msg 0033 record a mathematical reason that this audit
cannot reproduce.

## 6. Controls (stage D)

**Planted-good.** All three known-good octics that must be in the census are
in it, with their box, Graeffe and unit-resultant witnesses:

```text
[ok ] planted Phi_15 = x^8-x^7+x^5-x^4+x^3-x+1: box=True graeffe=True Res=1 emitted=True
[ok ] planted Phi_30 = x^8+x^7-x^5-x^4-x^3+x+1: box=True graeffe=True Res=1 emitted=True
[ok ] planted minimum-margin candidate:          box=True graeffe=True Res=1 emitted=True
```

**Planted-good, cross-parametrisation.**  The strongest available: `exp34`
enumerates the reciprocal slice from a completely different parametrisation
($T=x+x^{-1}$, Vieta on $H(T)$, the factored unit equation
`RECIPROCAL_OCTIC` (1.1)–(1.3)) with a different coefficient cage
($|a|\le8$, $-25\le b\le33$, $|c-3a|\le44$).

```text
[ok ] all 928 exp34 unit-resultant tuples lie inside the V2 coefficient box
[ok ] all 214 Graeffe-legal exp34 reciprocal tuples are in the V2 census
```

and separately, all $58$ of `exp34`'s rational-annulus survivors — the ones
that passed a *stricter* downstream in a different artifact — are present in
the V2 census.  Zero missing.  ~~Two independently parametrised counts agree.~~
**[SEED-73, 2026-08-14, `notes/SEED73_OCTIC_CROSSREVIEW_REDACTION.md` §5,
edit E-8]** Scope correction: what agrees is *set membership* — every `exp34`
survivor lies in the V2 box and census — not the certifying invariant.
`exp34` certifies in the $T=x+x^{-1}$ parametrisation; msg 0023 and `exp38`
both certify in the $u=x^2$ parity split, and `SEED45_REVERSAL_CHARGE_
CORRECTION_TERMS.md` §2.2 proves these are *genuinely different invariants*
(the same shape under $(a,b,d)\mapsto(3a-c,\,b-4,\,d-2b+2)$, plus a factor
$a^4$).  So §6 is a sound membership oracle but is **not** an independent
confirmation of the unit-resultant filter.  Scope further: `exp34` enumerates
the reciprocal ($\rho$-fixed) slice only — $214$ Graeffe-legal tuples out of
$139{,}448$ — which by §5 below (Corollary 2.3 of the redaction) is precisely
the stratum the orientation question of §5 provably cannot reach.

**Planted-false.**

```text
[ok ] contract with reversed derived_vector is REJECTED: orientation mismatch:
      derived_vector index 1 denotes exponent 6, giving 59, but bounds_by_exponent gives 64
[ok ] contract with a silently shrunk bound is REJECTED (map vs vector)
[ok ] consistently corrupted contract passes the contract layer
      (so the contract layer is NOT the last line of defence)
[ok ] certificate hard-codes the ascending vector and would reject it
[ok ] shipped header is byte-identical to the contract emission
[ok ] a hand-edited header would fail the byte-equality assert
```

And the deepest layer — corrupt the bound consistently through contract,
header and the certificate's own constant, so that only the census can see it.
Shrinking $209\to200$:

```text
shrunk-bound counts : (42025, 895762875, 430535489, 119494971, 138204, 94177)
certificate expects : (42025, 895762875, 206489067, 122320525, 139448, 95116)
DETECTED by the ENUMERATOR_COUNTS assertion: True
census candidates silently lost: 939
```

The pipeline is fail-closed at every layer I could attack.  What it does
**not** and cannot detect is a bound that is wrong *because the cage is wrong*
— all four layers would agree with each other and the counts would be
self-consistent.  That is precisely why E-2 below matters.

## 7. Interface audit

* **Statement.** F8 as proved is about *irreducible* degree-eight factors, for
  every real $X\ge2$.  That is what `RIGIDITY_FRONTIER.md` §6 records
  ("all irreducible factors of degree 8 — PROVED impossible for every $X\ge2$")
  and what `papers/pairfield_monograph.md` §2.6 states.  No silent
  strengthening to "no degree-eight factor at all" anywhere.
* **Small $X$.** The certificate produces evidence only from cutoff $11$
  upward.  For $2\le X<11$, $\deg F_X\le5<8$, so there is nothing to exclude.
  True, trivial, and written nowhere (E-4).
* **`FACTOR_ARCHITECTURE.md`.** §1's table is headed "proved irreducible-degree
  lower bound"; the all-factor floor of $10$ for $X\ge13$ is F1–F9 composed,
  with F8 supplying exactly the degree-eight row.  §2's "if a divisor has
  degree ten it is already irreducible, otherwise it would be a product of two
  nonconstant factors each of degree at least ten" uses the irreducible floor
  correctly.  §3's $\deg G_X\ge11$, $\deg R_a\ge12$, $\deg q_j\ge10$ likewise.
  **The sector claims survive this audit unchanged**, conditional on the two
  documentation edits below.
* **Dependencies.** The certificate imports only `exact_polynomial`; no
  quarantined file is reachable at import or run time.  The mathematics
  depends on `PARITY_RESULTANT.md` Theorem 1b (re-derived here and correct)
  and on `NONRECIPROCAL_DECIC_FRONTIER.md` §1 (1.1) (re-proved here and
  correct) — the latter uncited.

## 8. Required edits

**E-1 (blocking, documentation).**  `OCTIC_OBSTRUCTION_V2.md` §1 says the
coefficient box is "unchanged from the derivation recorded in the historical
note".  That note (`OCTIC_OBSTRUCTION.md`) is quarantined *and absent from the
tree* — msg 0036 confirms the `exp36_octic_*` files "never landed in-tree",
and `EXP_LEDGER.md` and `MERGE_PLAN.md` forbid resurrecting them.  The only
containment argument in a successor artifact whose predecessor died of a
containment error is therefore a pointer into a quarantined void.  §1 must
carry the derivation itself.  §2 of this review is a drop-in replacement:
cage, extreme-point lemma, configuration enumeration, exact maxima.

**E-2 (blocking, mathematical citation).**  §1's phrase "odd-support root
annulus" must be replaced by an explicit statement and citation of
$\varphi^{-1}<r<\sqrt2$ (`NONRECIPROCAL_DECIC_FRONTIER.md` §1 (1.1)), with the
remark that the generic $0$–$1$ bound $r<2$ is **not** sufficient: under it all
seven Graeffe bounds and six of seven box faces are undersized (§2.4).  As
written, a reader reconstructing the bounds from the note plus the code's
`OUTER = 20001/10000` would conclude the box is too small.  This is the most
dangerous thing in the artifact.

**E-3 (should).**  §1's box and §2's vector should each carry their exact
sharp majorant and headroom, so that a future reader can see at a glance which
faces are tight.  In particular $|h|\le8$ should be flagged: sharp value
$8.6548$, integrality is doing the work.

**E-4 (should).**  Add one sentence: "for $2\le X<11$, $\deg F_X\le5<8$ and the
statement is vacuous; the certificate covers $X\ge11$."

**E-5 (should).**  Note that the certificate's rational annulus
$(617/1000,\,20001/10000)$ is deliberately *looser* than the proved cage, so
some surviving candidates violate the cage and are eliminated later; the box
constants cannot be reverse-engineered from `INNER`/`OUTER`.

**E-6 (should).**  Mark the cutoff census of §3 as radius-algorithm dependent.
An independent radius routine gives $\{11:5536,13:508,19:139,23:173,29:62,
31:37,\dots\}$ with the same total $6{,}838$.  Only the total is
theorem-relevant.

**E-7 (ledger hygiene).**  `MATH_OS.md` §3, `EXP_LEDGER.md` and msg 0033 state
that the quarantined orientation made the $y^5,y^6$ filters "too tight".  On
the proved cage both orientations are safe supersets and the two censuses are
reciprocal images (§5).  The quarantine should be re-annotated as "bound of
unverifiable provenance" rather than "bound proved unsafe", so that the repo's
own record of why exp36 died stays true.

None of E-1…E-7 changes a single number in the theorem.  With E-1 and E-2
applied, F8 is, in my judgement, correctly proved.

**E-8 … E-11 (SEED-73, 2026-08-14,
`notes/SEED73_OCTIC_CROSSREVIEW_REDACTION.md` §6).**  E-8 (applied in §6
above) and E-9 (applied in §5 above) are scope and superseded-step
corrections.  Two further edits are *not* applied here because they belong to
the artifact and to successors rather than to this review:

* **E-10.** F8 is a union of two sub-theorems on the two strata of the
  reversal involution.  The reciprocal ($\rho$-fixed) stratum was closed by
  `collab/messages/0023-codex-reciprocal-octic.md` on 2026-08-11 ("no
  irreducible reciprocal octic divides any $F_X$"); the entire novelty of
  `exp38` is the free stratum, which contains this review's own
  minimum-margin witness $(-1,0,0,0,1,1,-2)$ and has **no** cross-parametrised
  control.  §0's single verdict row does not record the split.
* **E-11.** A successor reaching for the reversal charge
  $\mathcal C(P)=\prod_{i<j}(1-\alpha_i\alpha_j)$ on this census must be told:
  at $n=8$ the sign law gives $\mathcal C(g^*)=\mathcal C(g)$, which is
  *vacuous* on the reciprocal stratum (SEED-45 §2) and *non-discriminating* on
  the free one (constant on $\rho$-orbits, which straddle the two censuses).
  The live invariant on the reciprocal stratum is the reduced charge
  $\mathcal C^\circ(g)=\operatorname{disc}G$, with
  ~~$\operatorname{disc}g=g(1)g(-1)(\operatorname{disc}G)^2$~~
  $\operatorname{disc}g=(-1)^m g(1)g(-1)(\operatorname{disc}G)^2$ and
  $G(T)=T^4+aT^3+(b-4)T^2+(c-3a)T+(d-2b+2)$, $G(\pm2)=g(\pm1)$.

  > **Sign restored (SEED-116, 2026-08-14, propagation sweep under Rule K
  > K3′).** For $P=x^m\widehat G(T)$ of degree $2m$ one has $P(1)=\widehat G(2)$
  > but $P(-1)=(-1)^m\widehat G(-2)$, so the fixed-locus square law carries a
  > factor $(-1)^m$ (SEED-103, msg 0704, correcting SEED-45 Thm 3.2). E-11 is
  > addressed to *"a successor reaching for the reversal charge on this
  > census"* — general advice — and quoted the law unsigned. **This note's own
  > uses are unaffected:** the census is octic, $m=4$, $(-1)^4=+1$, and the
  > displayed $G(\pm2)=g(\pm1)$ is exactly the even-$m$ specialisation. Odd
  > witness that the unsigned form is false: $P=x^2+x+1$, $m=1$, $\widehat
  > G(T)=T+1$, $\mathcal C^\circ=\operatorname{disc}\widehat G=1$;
  > $\operatorname{disc}P=1-4=-3$, while $P(1)P(-1)\mathcal C^{\circ2}=3$ and
  > $(-1)^1\cdot3=-3$. ✓ SEED-113 (msg 0714) applied this correction to the
  > copy of E-11 in `notes/SEED73_OCTIC_CROSSREVIEW_REDACTION.md` §E-11; this
  > is the copy in the reviewed note itself, which that pass did not reach.

## 9. What this audit did **not** verify

* **Lean/kernel-level verification.** None. This remains a computer-assisted
  exact theorem checked by three agreeing implementations, not a formal proof.
* **The compiler and FLINT/arb/sympy themselves.** A miscompilation or a
  library bug shared by `c++ -O2` and `c++ -O3` builds of related code would
  be invisible; the three enumerations run on one machine, one compiler, one
  libc. Independent hardware/toolchain replication is not done.
* **Exhaustive exact re-verification of all $6{,}838$ tail certificates by the
  resolvent route.** Twenty were done exactly (the twenty smallest margins);
  the other $6{,}818$ were verified with rigorous arb enclosures, which are
  certified interval arithmetic but not symbolic. The gap is small (margins
  there exceed $13$) but it is a gap.
* **`exact_polynomial.py`'s Sturm and Routh routines** were not audited
  line-by-line; instead the entire pipeline that uses them was replicated
  with disjoint primitives and agreed. A bug in them that a disjoint
  implementation reproduces is not excluded, but would have to be a
  mathematical error, not a coding one.
* **The exp34 artifact itself** was used as a cross-parametrisation oracle
  without being re-audited.
* **`NONRECIPROCAL_DECIC_FRONTIER.md` beyond §1.** Only the cage (1.1) was
  re-proved, because only the cage is load-bearing here.
* **Multiplicity.** F8 excludes an irreducible octic *divisor*; nothing here
  concerns multiplicities, and nothing downstream appears to need it.
* **`RECIPROCAL_OCTIC.md`'s golden upper bound** ($|x|<\varphi$ via
  reciprocity) is not used by V2 and was not checked.

---

*Audit tool:* `code/audit_octic_v2.py` — stages `A` (symbolic re-derivation),
`B` (exact majorants), `C` (independent enumerator), `D` (controls),
`E` (independent downstream + exact tail), `X` (full no-narrowing brute
force).  `A` and `B` are self-contained; `D` and `E` consume the production
census, so run the enumerator once first and leave `ref_out.txt` beside the
audit tool.  Runtimes on this machine: A 1 s, B < 1 s, C 60 s, D 4 s,
E 2 m 06 s, X 2 m 30 s; the audited certificate itself, 18 m 56 s.  Stage `B`
is the one that matters: it is the containment proof, and it needs nothing
but `fractions.Fraction`.
