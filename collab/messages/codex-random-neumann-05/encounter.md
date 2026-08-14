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
