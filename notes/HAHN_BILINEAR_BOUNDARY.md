# Hahn reflection is bilinear before it is Hermitian

## Outcome

[`HahnBilinearBoundary.lean`](../formal/pairfield/Pairfield/HahnBilinearBoundary.lean)
checks the smallest hostile control requested by
[`DIVISOR_HAHN_INCIDENCE.md`](DIVISOR_HAHN_INCIDENCE.md) §7.3:
for a nonreal signal, the bilinear Hahn parity contrast need not equal the
corresponding absolute-square contrast.

Take a signal on two sites exchanged by reflection,

\[
f=(1,i).
\]

Use the unnormalised reflection-even and reflection-odd coefficients

\[
E=1+i,\qquad O=1-i.
\]

Lean checks

\[
E^2-O^2=4i,
\qquad
|E|^2-|O|^2=0,
\]

and therefore these expressions are unequal.  With the orthonormal
coefficients \(E/\sqrt2,O/\sqrt2\), both expressions are multiplied by
\(1/2\); the separation remains \(2i\ne0\).  The absence of square roots in
the checked surface is only a normalization convenience.

## Exact theorem surface

```lean
structure TwoSiteSignal where
  left : ℂ
  right : ℂ

def evenCoeff (signal : TwoSiteSignal) : ℂ :=
  signal.left + signal.right

def oddCoeff (signal : TwoSiteSignal) : ℂ :=
  signal.left - signal.right

def bilinearParity (signal : TwoSiteSignal) : ℂ :=
  evenCoeff signal ^ 2 - oddCoeff signal ^ 2

def absoluteSquareParity (signal : TwoSiteSignal) : ℂ :=
  ((Complex.normSq (evenCoeff signal) -
    Complex.normSq (oddCoeff signal) : ℝ) : ℂ)

theorem bilinear_ne_absoluteSquare :
  bilinearParity imaginaryControl ≠
    absoluteSquareParity imaginaryControl
```

The algebraic orientation is the one in the source warning.  In the
orthonormal two-site parity basis,

\[
\frac{E^2-O^2}{2}=f(0)f(1)+f(1)f(0),
\]

the bilinear reflection pairing.  Replacing the two coefficient products by
absolute squares inserts complex conjugation and changes the expression.  For
a real diagonal signal the conjugation is invisible, which is exactly the
scope in which the source note permits the spectral-energy wording.

## Random provenance

This arose from the tenth literal no-redraw semantic-corpus encounter:

- frozen commit and current `origin/main`:
  `c71e1d655a6cd5a1bdfc74ff500aada50ec6bfd6`;
- frozen tree: `9dc6516ed6b8ebd4767c7d36e23269d61c33ba41`;
- frame: 1015 tracked `.agda`, `.lean`, and `.md` paths under `formal/`,
  `notes/`, and `papers/`, C-sorted, build paths and nine earlier samples
  excluded;
- frame SHA-256:
  `34d5e10a96522e37312691be9cfbd7f20f674002c60c564f13fbd0ea0558f3ab`;
- unbiased rule: accept a native uint32 below `4294966410` (tail 886);
- sole raw word: `1315718911`, accepted at index0 801 (position 802);
- sample: `notes/PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX.md`, blob
  `d41632e435ccba0f95d71917f3a9a7b31a25112d`, 13210 bytes, provenance commit
  `409f8edd2df3c44cd6ce6e99721c0478313cadf3`.

The sampled index records the external through-Delta12 program and says that
its presence does not upgrade verification grades.  Its Delta08 summary calls
Goldbach an alternating Hahn spectral-energy sum.  The later live note
`DIVISOR_HAHN_INCIDENCE.md` already supplies the essential correction: its
equation (4.3) is bilinear for complex signals, its Hermitian formula has a
conjugate, and absolute squares are valid only in the real diagonal case.
This leaf is a kernel certificate for that existing correction, not a new
Hahn theorem or a criticism of the real Goldbach identity.

## Scope fence

Checked:

- exact complex arithmetic for the two-site reflection control;
- the non-equality of bilinear and absolute-square parity contrasts;
- integration into the Lean `Pairfield` aggregate.

Not checked or claimed:

- construction or orthogonality of Hahn polynomials;
- the full divisor--Hahn incidence transform;
- the Delta08 Hahn heat semigroup or its positive-time positivity theorem;
- any statement about a prime or von Mangoldt signal, Goldbach, a microlocal
  inverse theorem, or an arithmetic estimate;
- novelty for the bilinear/Hermitian distinction, which is elementary and
  already stated in the live note.

Verification: `lake env lean Pairfield/HahnBilinearBoundary.lean` and
`lake build Pairfield` both exit 0 under Lean 4.33.0 / mathlib v4.33.0.  The
aggregate emits only pre-existing linter warnings in other modules.
