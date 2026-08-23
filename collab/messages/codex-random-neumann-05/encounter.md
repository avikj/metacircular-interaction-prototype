# Byte-mass encounter: reflection before prediction

**Handle:** `codex-random-neumann-05`  
**Opened:** 2026-08-14T06:32:38Z  
**Entropy seed:** `bac1e5d74f66f8bf331e1521c9f5e532`  
**First and only initial anchor:** bytes `[40350,44446)` of
`figures/exp4_singular.png`  
**Raw-window SHA-256:**
`e2856aea16a2eac79e8b1e537ec7e36eb2fa0db9fcd7020f22544429c5e39a88`

## 06:32Z — compressed matter first

I first read exactly the fixed 4,096 bytes with `dd` and `xxd`, before opening
the image or retrieving its mathematical context.  The interval is compressed
PNG payload.  Runs such as `22 22 ...` and `44 44 ...` were conspicuous, but I
assign them no image semantics: they are properties of this encoding window,
not licensed visual regions or mathematical invariants.

After that refusal I decoded the whole PNG.  It shows the normalized Goldbach
sum marginal and prime-gap difference marginal lying near the same
Hardy--Littlewood singular-series graph; the second panel gives finite
histograms of observed/predicted ratios with displayed means `1.0000` and
`0.9992`.

The first operator-shaped question is exact and local.  For a prime `p`, let

\[
 L_k(x)=(x,k-x),\qquad M_k(x)=(x,x-k)
\]

on `F_p`.  Reflection of the second coordinate,
`J(u,v)=(u,-v)`, sends `L_k(x)` to `M_k(x)`.  Since the local prime condition
is just that neither coordinate vanish, and multiplication by `-1` preserves
nonvanishing, the two fibers have exactly the same normalized local density.
Equivalently, both have one forbidden residue when `p|k` and two otherwise.
This yields the same Euler factor and hence the same singular-series function.

Evidence grade: the finite-field reflection and local-density equality are an
elementary exact calculation.  The two global asymptotics plotted are
Hardy--Littlewood predictions sampled numerically, not consequences of the
image and not proved by closeness of the histograms.  The positive-integer
cone is precisely where the coordinate reflection ceases to be a literal
global symmetry of the von Mangoldt sequence.

## 06:36Z — exact factors, then a prior-art correction

The common finite-place object can be written without the picture.  If
`nu_p(k)` is the number of forbidden residues, then

\[
 \nu_p(k)=\begin{cases}1,&p\mid k,\\2,&p\nmid k,\end{cases}
 \qquad
 \beta_p(k)=\frac{1-\nu_p(k)/p}{(1-1/p)^2}.
\]

For `p>2`, the generic factor is
`p(p-2)/(p-1)^2=1-1/(p-1)^2`; when `p|k`, division by the generic factor
contributes `(p-1)/(p-2)`.  At `p=2`, the factor is `2` for even `k` and `0`
for odd `k`.  Multiplying yields exactly the displayed singular series

\[
  \mathfrak S(k)=2C_2\prod_{p\mid k,\ p>2}\frac{p-1}{p-2}
\]

for even `k`, and zero for odd `k`.

I then found that this structural result is already stated more strongly in
`notes/ADELIC.md` section 2: a unitary reflection on the signed pair space
interchanges sum and difference, finite places are literally isomorphic, and
the positive cone is the archimedean symmetry break.  So this encounter did
**not** discover a new operator theorem.  It independently reconstructed an
existing one from the randomly encountered plot.

The surviving correction is evidentiary.  `code/exp4_singular.py` says “We
verify both,” and `notes/EXP_LEDGER.md` labels the experiment “verified.”  The
finite computation verifies that the sampled values approximate the
Hardy--Littlewood predictions; it does not verify either prime-pair
asymptotic.  `notes/DIVISOR.md` already uses the safer phrase “verified
conjecturally” and identifies the divisor model as the genuinely proved
analogue.  I leave the old wording untouched rather than turning a bounded
encounter into a corpus-wide edit.

## 06:37Z — bounded close

Attack on my own reconstruction: equality of local densities supplies only
the singular series.  It has no control over the global minor-arc/parity
obstruction, so it cannot transfer a proof between Goldbach and twin-prime
asymptotics.  The plotted means also average away dependence on the sampled
parameter and cutoff; a mean near one is weaker than the pointwise asymptotic
claimed by Hardy--Littlewood.

What changed my mind: I began by asking whether the plot concealed a common
operator.  The exact local reflection answered yes, but the repository showed
that answer was already known and forced me to demote the result to an
independent reconstruction plus an evidence-label warning.  No code was run,
no numerical claim was promoted, and no novelty claim is made.

## 06:50Z — returned to the checked Natural Machine core

Human direction required every return to act on the core rather than end as a
detached observation.  After rereading the current `README.md` and the
`NaturalMachine.agda` aggregate, the precise seam was already named:
`PerspectiveCore.restricts-suff` for an invariant sector and
`PerspectiveCore.SectorBreak` for a sector that the ambient equivalence leaves.

The new checked module
`formal/cubical/NaturalMachine/PairReflectionSector.agda` makes the encounter
an instance of that API:

- `JEquiv` is the ambient equivalence induced by
  `reflect(u,v)=(u,-v)`;
- for any predicate `U` equipped with `U(x) ≃ U(-x)`, the term
  `admissible-reflection` uses `restricts-suff` to restrict `JEquiv` to
  `U(u) × U(v)`;
- pulling that restriction back along `(x,k-x)` gives
  `local-fibre-equiv : LocalSum k ≃ LocalDiff k`, where the other leg is
  `(x,x-k)`;
- `local-count-equal` turns the equivalence into equality of finite
  cardinalities, the exact local-density equality behind the common Euler
  product;
- with a predicate `P` containing `1` but not `-1`, `positive-break` is the
  literal `SectorBreak` witness `(1,1)`, whose reflected image is `(1,-1)`;
  `positive-not-invariant` applies `sector-not-inv` to rule out any fibrewise
  restriction.

Verification executed without Python:

```text
LC_ALL=C.UTF-8 LANG=C.UTF-8 agda NaturalMachine/PairReflectionSector.agda
Checking NaturalMachine.PairReflectionSector (.../PairReflectionSector.agda).
exit 0
```

This changes machine capability in one narrow way: the prose claim in
`notes/ADELIC.md` can now be consumed as a reusable restriction/break object.
It does **not** install a finite field instance or prove a Hardy--Littlewood
asymptotic.  Negation invariance of the selected local predicate is explicit
input; positivity failure is explicit data; the global parity/minor-arc
residual remains outside the transport.
