# Carry reduction inside the canonical digit chart

**Status:** checked in safe Cubical Agda.  This is an operational adapter and
one killed naïve translation; it adds no group-cohomology claim.

## The obstruction

`NaturalMachine.Digits` represents a natural number by a little-endian
canonical word: the last, most-significant digit must be nonzero.
`NaturalMachine.Endian.π` deletes that last digit.  It is therefore a map on raw
words, but not a map on `CanWord`: in every base at least two,

\[
  [1,0,1]\quad\longmapsto\quad[1,0],
\]

and the result has a zero most-significant digit.  The checked term
`rawπ-does-not-restrict` records this counterexample.  Thus the proposed direct
restriction of `π` to canonical words is ill-typed, not merely unproved.

The least repair is normalization by the already-proved digit equivalence:

\[
  \operatorname{normalizeMSD}(w)
  = \operatorname{digitsC}(\operatorname{value}(π w)).
\]

It preserves the truncated value exactly while deleting any newly exposed
leading zeros.

## The exact adapter

Fix `b = 2 + k` and adjacent levels `n = 1 + n'`.  The module defines total
residue charts

\[
 \operatorname{chartM}:\mathrm{CanWord}\to\mathrm{Fin}(M),\qquad
 \operatorname{chartN}:\mathrm{CanWord}\to\mathrm{Fin}(N),
\]

where `CarryObstruction.BasePower` supplies checked paths
`M≡b : M ≡ b^(n+1)` and `N≡ : N ≡ b^n`.  If a canonical word is written
as `xs ++ [y]` with `length xs ≡ n`, then

\[
 \boxed{
 \operatorname{red}(\operatorname{chartM}(xs\mathbin{+\!+}[y]))
 =
 \operatorname{chartN}
   (\operatorname{normalizeMSD}(xs\mathbin{+\!+}[y])) .}
\]

This is `red-chart-truncates`.  Its arithmetic core is the positional identity

\[
 \operatorname{value}(xs\mathbin{+\!+}[y])
 = \operatorname{value}(xs)+b^{|xs|}y,
\]

followed by the fact that the second summand is zero modulo `N = b^n`.
`CarryObstruction.mod-mod` then identifies reduction modulo `M` followed by
reduction modulo `N` with direct reduction modulo `N`.

The square commutes propositionally, not by `refl`.  Three distinctions are
load-bearing: the modulus is connected to a literal power by a path; modular
reduction is a theorem rather than definitional computation at variable
width; and raw truncation must be normalized before it returns to `CanWord`.

## Iteration boundary: the canonical operation forgets the level

The repaired one-step operation is not itself a tower action.  The same checked
witness exposes the failure:

\[
 [1,0,1]\xmapsto{\operatorname{normalizeMSD}}[1]
 \xmapsto{\operatorname{normalizeMSD}}[],
 \qquad
 [1,0,1]\xmapsto{\pi^2}[1].
\]

The first normalization contracts the noncanonical lower word `[1,0]` by
removing its exposed zero.  A second actual-MSD deletion therefore removes a
different place than the second fixed-width tower map would remove.  Agda
checks the universal no-go `normalizeMSD-not-iterable`: there is no equality,
for every canonical word, between two normalized drops and normalization after
two raw place drops.

This identifies the lost coordinate exactly: `CanWord` retains the natural
number but not the ambient digit level.  A composable tower carrier must retain
the width (for example, a fixed-length word chart in which leading zeros remain
real places) and only normalize when leaving that carrier.  This conclusion is
forced by the counterexample, not proposed as a general architecture.

## Fixed-width repair: the level is part of the type

The required carrier was already present in
`NaturalMachine.DigitTowerFinLimit`:

\[
  W(A,n)=\operatorname{Fin}(n)\to A,
  \qquad
  \operatorname{dropMSD}_n(w)=w\circ\operatorname{injectSuc}.
\]

Here `injectSuc` preserves the underlying index and omits the top element.
`NaturalMachine.FixedCarryChart` specializes this tower to `Digits.Digit` and
installs the missing transition map into the live numeral/carry chart.  The
width is now an index, so two adjacent deletions compose strictly:

\[
 \operatorname{dropMSD}_n\bigl(\operatorname{dropMSD}_{n+1}(w)\bigr)
 =w\circ\operatorname{injectSuc}\circ\operatorname{injectSuc}.
\]

This is `dropMSD-compose`; unlike the normalized `CanWord` operation, its proof
is `refl`.

The adapter `toWord` enumerates `Fin n` from least to most significant and
lands in the existing raw `Digits.Word`.  The checked equations

```text
toWord w = toWord (dropMSD w) ++ [top w]
Endian.π (toWord w) = toWord (dropMSD w)
```

show that no second evaluator or reversed indexing convention has been
introduced.  The top-preserving inclusion supplied by `FinTopSplit` is the
only non-definitional bridge required.

At adjacent powers `M = b^(n+1)` and `N = b^n`, let `chartM` and `chartN`
evaluate these raw words and reduce modulo their displayed level.  Then Agda
checks the premise-free square

\[
 \boxed{
 \operatorname{red}(\operatorname{chartM}(w))
 =\operatorname{chartN}(\operatorname{dropMSD}_n(w)).}
\]

This is `red-chart-drops`.  The old explicit `length xs ≡ n` premise has moved
into the type `LevelWord (suc n)`.  The stagewise map
`canonicalize = digitsC ∘ levelValue` agrees with both residue charts
(`chartN-canonicalizes`, `chartM-canonicalizes`), but it is intentionally not
called a tower morphism.  Doing so would reinstate the already checked false
translation `normalizeMSD-not-iterable`.

The exact compatibility locus is now checked as well.  If the retained top
digit is nonzero, then `toWord w` is already canonical and

\[
 \operatorname{normalizeMSD}(\operatorname{canonicalize}(w))
 =\operatorname{canonicalize}(\operatorname{dropMSD}(w)).
\]

This is `canonicalize-drop-natural`; its premise is used to identify
`digitsC (value (toWord w))` with `toWord w`, after which
`toWord-dropMSD` closes the square.  The premise cannot simply be erased.
At binary width three, the fixed word `[1,0,0]` canonicalizes to `[1]` before
the transition; normalized deletion therefore produces `[]`, while deleting
the fixed top place first leaves `[1,0]`, whose canonicalization is `[1]`.
`canonicalize-not-a-tower-map` checks the resulting universal no-go.

The zero-top remainder is not left empirical.  `π-value-strict` proves that
deleting the MSD of every nonempty canonical word strictly lowers its value;
hence `normalizeMSD-fixed-zero` says that the only canonical fixed point of
normalized deletion represents zero.  It follows that, for every fixed-width
word `w`, the square commutes exactly on

\[
 \boxed{
  \bigl(0<\operatorname{top}(w)\bigr)
  \ \lor\
  \bigl(\operatorname{levelValue}(\operatorname{dropMSD}(w))=0\bigr).}
\]

The two directions are
`locus→canonicalize-drop-natural` and
`canonicalize-drop-natural→locus`.  In particular, on the zero-top stratum
the retained lower value must be zero and that condition is sufficient.  The
lower fixed-width word need not be literally empty: its leading zero places
remain real level data even though all of its digits evaluate to zero.  Binary
`[0,0,0]` is the checked exceptional positive control, while `[1,0,0]` lies
outside the locus.  Thus the theorem classifies stagewise compatibility
without reviving a global tower morphism.

## What changed

`CarryObstruction` previously proved nonsplitting only in cyclic quotient
coordinates.  `CarryChartBridge` made its `red` map executable on the
repository's canonical numeral presentation for one step.  `FixedCarryChart`
now gives that step its composable, level-retaining source.  A consumer can
move through the finite tower without inventing a second evaluator, then
project stagewise to canonical numerals.  Conversely, any future statement
equating raw `π` directly with a `CanWord → CanWord` operation must confront the
checked counterexample.  Any future statement iterating `normalizeMSD` as
though canonical words retained fixed-width zero places must also confront
`normalizeMSD-not-iterable`.

This does **not** construct
`H²(ℤ/b^n;ℤ/b)`, exhibit a carrying pair from the constructive negation of
universal carry-freeness, or identify least representatives with arbitrary
sections.  Those boundaries of `CarryObstruction` remain unchanged.

## Cubical v0.9 surface consumed

The root replay exposed two genuine library-boundary changes rather than
mathematical failures.  The v0.5 commutative-ring tactic accepted a quantified
function goal and introduced its binders; v0.9 exports `solve!`, which accepts
only the equality after those binders are introduced.  The natural-number
tactic has the analogous `solveℕ!` boundary.  All inherited solver lemmas are
now eta-expanded explicitly, so their propositions are unchanged while the
new tactic contract is visible in source.  The symmetric group constructor is
likewise the current `SymGroup`, not the former `Symmetric-Group`.

This migration matters operationally: without it the new adapter checks alone
but the aggregate cannot replay on the installed library, so it has not yet
become a capability of the live machine.

## Replay

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/CarryChartBridge.agda
agda -i formal/cubical formal/cubical/NaturalMachine/FixedCarryChart.agda
sh formal/check.sh
```

The sources are `formal/cubical/NaturalMachine/CarryChartBridge.agda` and
`formal/cubical/NaturalMachine/FixedCarryChart.agda`; the root aggregate imports
both, so the final command checks the adapters as part of the complete formal
gate.  The 2026-08-14 replay returned exit zero for the standalone modules, the
`Everything` aggregate, and `formal/check.sh`.  Existing
`UnsupportedIndexedMatch` warnings retain their narrower meaning: some named
functions need not compute on transported inputs.
