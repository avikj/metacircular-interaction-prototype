# The smallest formal-ingestion feedback loop

**Status:** exact interface classification; action adapter pending in the
owning claim `SYMMETRY_ACTION_ARITHMETIC_ADAPTER`.

## 1. Imported theorem and compiled capability

`NaturalMachine.SymmetryCardinality` imports Cubical's `cardAut` and checks

\[
|\operatorname{Aut}(\operatorname{Fin} n)|=n!.
\]

This is a genuine executable capability: a loop-symmetry **count** query reduces
to factorial while retaining the inherited proof certificate.

## 2. The caller that the scalar cannot answer

At `n=2`, let the two registers be `r=(1,2)` in `Z/5Z`, and keep the evaluator
port fixed:

\[
E(r)=r_0+2r_1\pmod 5.
\]

The identity loop gives

\[
E(1,2)=1+2\cdot2=0\pmod5,
\]

whereas swap precomposition gives

\[
E(2,1)=2+2\cdot1=4\pmod5.
\]

Both transformations live in the same two-element automorphism carrier whose
compiled count is `2!`.  The count answers how many transformations exist; it
cannot answer which fixed-port response an individual transformation induces.

## 3. Prasaṅga: the opposite under covariant transport

The behavior difference is not intrinsic to relabeling alone.  If the
evaluator weights are transported covariantly with the registers, then the
pairing is invariant.  For a permutation `pi`,

\[
\langle \pi w,\pi r\rangle=\langle w,r\rangle.
\]

Thus the opposite statement holds under a moving port: identity and swap are
observationally equal after simultaneous transport.  The richer carrier is

\[
(\text{loop},\text{register action},\text{port transport policy}).
\]

The fixed-port calculation is a genuine intervention; the covariant-port
calculation is a change of coordinates.

## 4. What changes next

The residual changes the next adapter from carrier cardinality to evaluation:
a path `p` should act by precomposition through `pathToEquiv(p)`, and the
adapter should state whether ports remain fixed or transport covariantly.

It does **not** justify importing another Cubical library family.  The current
library already supplies `pathToEquiv` and composition.  The next action is a
local checked adapter plus the covariant annihilation control.  More theorem
retrieval would enlarge vocabulary without answering the live caller.

This closes the smallest exact loop presently visible:

```text
cardAut import
-> certified factorial count
-> fixed-port action query returns 0 versus 4
-> residual: count forgot evaluation and port policy
-> next adapter: pathToEquiv action, with fixed/covariant control.
```

## Rigor boundary

The two modular evaluations and covariance identity are direct exact
calculations.  `symmetryCount≡factorial` is checked in Cubical Agda.  The new
path-to-evaluation adapter is owned by `SYMMETRY_ACTION_ARITHMETIC_ADAPTER` and
is not claimed checked here until that artifact lands.
