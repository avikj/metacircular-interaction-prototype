# Kuṭṭaka as an incremental congruence-state update

**Status:** exact elementary construction with an explicit historical boundary.

## 1. The one-shot move

Suppose the arithmetic organism currently knows

\[
x\equiv r\pmod M
\]

and encounters a new sensor constraint

\[
x\equiv a\pmod m.
\]

Every old solution has the form `x=r+Mt`. Substitute once:

\[
Mt\equiv a-r\pmod m.                                \tag{1}
\]

Let `g=gcd(M,m)`. Euclidean descent gives integers `u,v` with

\[
uM+vm=g.                                             \tag{2}
\]

There are exactly two outcomes.

- If `g` does not divide `a-r`, the constraints are incompatible. The pair
  `(g,a-r)` is a complete obstruction certificate.
- If `g` divides `a-r`, multiply (2) by `(a-r)/g`. Modulo `m/g`,

\[
t\equiv u\frac{a-r}{g}\pmod{m/g}.                   \tag{3}
\]

Then `x'=r+Mt` is the unique combined state modulo `lcm(M,m)`.

This is a one-shot state update, not a search through candidate integers.

## 2. Newly available after prime/exponent coordinates

Prime/exponent anatomy turns a composite modulus into independent prime-power
sensors. Starting from `x≡0 (mod 1)`, add

\[
x\equiv2\pmod{2^3},\qquad
x\equiv5\pmod{3^2},\qquad
x\equiv4\pmod5.
\]

Three applications of (1)–(3) produce

\[
\boxed{x\equiv194\pmod{360}}.
\]

The result verifies immediately:

\[
194\equiv2\pmod8,\quad194\equiv5\pmod9,\quad194\equiv4\pmod5.
\]

The same update handles overlap. Combining `x≡2 (mod 6)` with
`x≡8 (mod 9)` gives `x≡8 (mod 18)` because their residues agree modulo 3.
But `x≡1 (mod 4)` and `x≡2 (mod 6)` fail because `gcd(4,6)=2` does not
divide `1`.

Thus prime/exponent coordinates do not merely describe a number. They expose
the local sensor constraints on which Euclidean reconstruction acts.

## 3. Executable artifact

`machinery/kuttaka_update.py` implements extended Euclidean descent, the
incremental update, incompatibility witnesses, and an independent verifier.
Five tests cover Bézout reconstruction, prime-power composition, compatible
overlap, exact failure, and invalid moduli.

The first handwritten draft said `274`; the executable rejected it because
`274 mod 9 = 4`, not `5`. The corrected residue `194` is retained here as a
small demonstration that the artifact, rather than the prose, controls the
example.

## 4. Historical boundary

The **kuṭṭaka** (“pulverizer”) is an Indian algorithmic tradition for linear
indeterminate equations and congruence problems, associated especially with
Āryabhaṭa and later commentators. Its characteristic mathematical move is
repeated Euclidean reduction followed by reconstruction of a solution.

The exact state datatype, prime-power sensor language, generalized incremental
CRT update, Python implementation, and examples above are modern
reconstructions. Chinese remainder traditions and Indian kuṭṭaka traditions
have distinct textual histories; this note does not collapse them or claim
that an ancient author presented this software-level composition interface.

The historical source layer should be strengthened with a critical translation
before any philological claim becomes load-bearing. The mathematics here needs
only the proved Euclidean identities (1)–(3).

## 5. Formal status (2026-08-14)

`formal/pairfield/Pairfield/IncrementalCRTAdapter.lean` now checks the
generalized-CRT state transition against pinned Mathlib. On states
`⟨residue, modulus⟩` it proves that compatibility is equivalent to existence,
that a successful merge denotes exactly the intersection of the two solution
cosets over both `ℕ` and `ℤ`, and that the normalized representative is unique
below `lcm`. Failure retains the signed datum `(gcd, a-r)` and proves that no
integer common representative exists. Success retains Mathlib's explicit
Bézout coefficients and erases exactly to the checked merged state. The
compatible, incompatible, and corrected `194 mod 360` controls are theorems.

This makes the Python artifact in §3 a historical replay rather than proof
authority. The checked adapter is deliberately narrower than the whole native
execution described in §1: it does not yet prove that the retained
coefficients reconstruct the representative by formula (3), record the
successive Euclidean/pulverization steps, or identify such a trace with a
historical vallī. Original affine equations and earned-sensor provenance also
remain outside this state-level theorem.
