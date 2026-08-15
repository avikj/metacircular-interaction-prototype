# Octic obstruction, corrected certificate


> **Audit annotation (integration lane, 2026-08-12) — applies E-1 and E-2 of
> `CROSSREVIEW_OCTIC_V2.md`, which are blocking documentation edits. No number
> in this theorem changes.**
>
> **E-1 (broken reference).** §1's sourcing of the coefficient box "unchanged
> from the derivation recorded in the historical note" points at a document
> that is quarantined *and physically absent from the tree*. The containment
> argument is therefore not present in this artifact. The audit re-derived it
> from scratch (extreme-point lemma for maximizing $e_k$ on
> $\{t\in[m,M]^n:\prod t_i=1\}$, every extreme configuration enumerated
> exactly in ℚ) and confirms the shipped bounds are a valid superset with
> 10–55% headroom — but the *reason* now lives in the audit, not here.
>
> **E-2 (load-bearing uncited hypothesis).** The bounds are valid **only**
> under the sharp odd-support cage $\varphi^{-1}<r<\sqrt2$ proved in
> `NONRECIPROCAL_DECIC_FRONTIER.md` §1, which this note never cites. Under
> the generic Newman cage $r<2$ — which is what "odd-support root annulus"
> reads like, and what the code's own `OUTER = 2.0001` would suggest — all
> seven Graeffe bounds and six of the seven box faces would be **undersized**:
> the predecessor artifact's exact failure mode, one citation away. Read every
> bound below as conditional on the $\sqrt2$ cage.
>
> **Historical correction.** The quarantine's stated premise does not
> reproduce: on the proved cage *both* Graeffe orientations are safe
> supersets, and the reversed-vector census is exactly the reciprocal image of
> the corrected one. **Orientation was never the hazard; the cage was.**
>
> **E-10 of `CROSSREVIEW_OCTIC_V2.md`, applied here by seed126, 2026-08-14
> (Rule K3).** SEED-73 §6 raised this and declined it — *"not applied — for the
> artifact, not the review"* — a decline that named no successor, and the
> artifact has since been edited (the integration-lane block above, 2026-08-12)
> without it landing. The record it asks for, verified at the source rather than
> taken from the review: **the reciprocal octic stratum was already closed by
> message `collab/messages/0023-codex-reciprocal-octic.md`, dated 2026-08-11**,
> which factors the parity unit resultant as
> $\operatorname{Res}(E,O)=(d-2b+2)\bigl((a-c)^2+ab(a-c)+a^2(d-2)\bigr)^2$ and
> concludes *"no irreducible reciprocal octic divides any $F_X$"*. The single-row
> verdict below therefore covers two strata of different vintage: the reciprocal
> one settled three days earlier by a resultant identity, and the **free** one,
> which is what this artifact's census is new for. Read the verdict accordingly.
>
> Verdict: **CONFIRMED** — three independent enumerations (including a
> complete no-narrowing brute force over all 167,507,657,625 box points) emit
> byte-identical censuses; downstream reproduced on disjoint primitives.

For

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

the corrected exact certificate `code/exp38_octic_certificate.py`, together
with `code/exp38_octic_enumerator.cpp`, proves:

> **Theorem.** For every real $X\geq2$, the prime-prefix polynomial $F_X$
> has no irreducible factor of degree eight.

This is a fresh successor artifact.  The historical `exp36` certificate and
`OCTIC_OBSTRUCTION.md` are retained as quarantine history: they attached the
right Graeffe majorant numbers to the wrong coefficient order.  Their theorem
survivor set happened to remain unchanged, but that does not rehabilitate the
old proof artifact.

## 1. Unchanged mathematical reduction

An irreducible octic factor must have the form

$$
g=x^8+ax^7+bx^6+cx^5+dx^4+ex^3+fx^2+hx+1.
$$

Writing

$$
g(x)=E(x^2)+xO(x^2),
$$

gives

$$
E(y)=y^4+by^3+dy^2+fy+1,
\qquad
O(y)=ay^3+cy^2+ey+h.
$$

The parity identity $F_X(x)+F_X(-x)=2$ and the parity-resultant theorem give

$$
\operatorname{Res}_y(E,O)=\pm1.
$$

The odd-support root annulus, product-one constraint, and log-majorization
argument give the safe coefficient box

$$
|a|\le9,\ |b|\le34,\ |c|\le73,\ |d|\le93,
\ |e|\le72,\ |f|\le34,\ |h|\le8.
$$

These reductions and the subsequent Sturm, Routh, irreducibility, resultant,
and tail arguments are unchanged from the derivation recorded in the
historical note.  The corrected point is isolated below.

## 2. Correct Graeffe coefficient association

Set

$$
G(y)=E(y)^2-yO(y)^2.
$$

Direct convolution in **ascending powers of $y$** gives

$$
\begin{aligned}
[y^1]G&=2f-h^2,\\
[y^2]G&=f^2+2d-2he,\\
[y^3]G&=2b+2fd-e^2-2hc,\\
[y^4]G&=2+2fb+d^2-2ha-2ec,\\
[y^5]G&=2f+2db-c^2-2ea,\\
[y^6]G&=b^2+2d-2ca,\\
[y^7]G&=2b-a^2.
\end{aligned}
$$

The roots of $G$ are the squares of the roots of $g$.  The elementary
symmetric majorant indexed by $e_k$ bounds the coefficient of $y^{8-k}$,
not $y^k$.  Therefore the majorant vector must be reversed when attached to
ascending coefficients.  The correct inequalities are

$$
\boxed{
\begin{aligned}
|2f-h^2|&\le12,\\
|f^2+2d-2he|&\le59,\\
|2b+2fd-e^2-2hc|&\le150,\\
|2+2fb+d^2-2ha-2ec|&\le209,\\
|2f+2db-c^2-2ea|&\le159,\\
|b^2+2d-2ca|&\le64,\\
|2b-a^2|&\le12.
\end{aligned}}
$$

Thus the ascending bound vector is

$$
\boxed{(12,59,150,209,159,64,12).}
$$

The new C++ enumerator constructs $E^2-yO^2$ a second time by direct array
convolution and checks every candidate against this explicitly indexed
vector.  The Python driver independently compares direct convolution with the
displayed formulas before accepting the enumeration.

## 3. Corrected exact ledger

The corrected full-box enumeration has stage counts

$$
\boxed{
(42{,}025,
895{,}762{,}875,
206{,}489{,}067,
122{,}320{,}525,
139{,}448,
95{,}116).
}
$$

They record, in order:

1. endpoint pairs surviving the $y^1,y^7$ bounds;
2. $(c,e)$ states visited;
3. $d$ values in the four derived linear intervals;
4. tuples satisfying every corrected Graeffe inequality;
5. labeled tuples with parity resultant $\pm1$;
6. emitted tuples with $a\le0$.

Relative to the quarantined run, $1{,}752$ labeled unit-resultant tuples leave
and $1{,}752$ enter.  The two sets are reciprocal.  Each set contains $514$
no-real tuples and no rational-annulus survivor.  Consequently the downstream
certificate ledger is unchanged:

$$
139{,}448\longrightarrow37{,}284\longrightarrow7{,}092.
$$

The $7{,}092$ tuples form $2{,}473$ sign/reciprocal orbits, split into $78$
reducible and $2{,}395$ irreducible orbits.  Expanding gives $6{,}840$
irreducible labeled candidates.  Removing $\Phi_{15}$ and $\Phi_{30}$ leaves
$6{,}838$ noncyclotomic candidates.

The exact cutoff census remains

$$
\begin{array}{c|rrrrrrrrrrrrrrrr}
q&11&13&17&19&23&29&31&37&41&43&47&53&59&61&71&83\\ \hline
\#&5535&509&311&138&174&60&39&31&9&9&9&5&2&3&2&2.
\end{array}
$$

All prefix resultants before the chosen cutoff are nonzero and every infinite
tail is excluded by the strict reverse of the exact resultant-tail inequality
from the original derivation.  The minimum positive margin remains at

$$
(a,b,c,d,e,f,h)=(-1,0,0,0,1,1,-2)
$$

with cutoff $11$.

## 4. Hardened execution and trust boundary

The corrected artifact adds the following fail-closed checks:

- All generic Sturm, Routh--Cayley, and resultant routines are isolated in
  `code/exact_polynomial.py`, which contains no experiment constants or main
  routine.  The certificate has no import-time or run-time dependency on the
  quarantined `exp36` files.
- Python exits immediately under `python -O`, so load-bearing assertions
  cannot be stripped.
- The C++ Sylvester determinant uses signed 128-bit integers only after a
  checked Hadamard-minor bound: every Sylvester row has norm below $105$,
  every stored Bareiss entry is a minor, and every pre-division numerator is
  below $2\cdot105^{12}<2^{82}$.
- Every Bareiss division checks exact divisibility and aborts on failure.
- Direct convolution checks the Graeffe coefficient indexing independently of
  the interval formulas.
- Python replays the corrected bounds for every emitted tuple.
- The run prints the SHA-256 hashes of the Python certificate, its transitive
  exact-polynomial kernel, the exact C++ source, bounds header and contract,
  and compiled binary, together with compiler identity and flags.

Run from `code/` with

```text
python3 exp38_octic_certificate.py
```

The result remains a computer-assisted exact theorem and requires a fresh
hostile audit of this successor artifact.  No broader novelty claim is made.
