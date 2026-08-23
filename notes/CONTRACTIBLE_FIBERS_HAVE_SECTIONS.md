# Contractible path fibres have a section

The checked correction is small but load-bearing: a section of the rooted
path-fibre bundle is not a retraction of the set-truncation unit.

The sampled note `DESCENT_BOUNDARY_TWO_LENSES.md` and its companion
`SetTruncationDescentBoundary.agda` correctly prove

```text
Retracts₀ A = Σ (f : ∥ A ∥₂ → A), ((a : A) → f ∣ a ∣₂ ≡ a)
Retracts₀ A ≃ isSet A.
```

They also correctly prove that every rooted path fibre

```text
InsideFiber A a = Σ (x : A), a ≡ x
```

is contractible.  The final interpretive sentence then identifies
`Retracts₀` with a global section of this contractible-fibre bundle and says
that such a section fails for `S¹`.  That identification is false: the actual
dependent section space is

```text
InsideSections A = (a : A) → InsideFiber A a.
```

It has the canonical section `a ↦ (a,refl)` for every type `A`.  Indeed the
new safe Agda leaf checks the stronger statement

```text
insideSectionsContr : isContr (InsideSections A).
```

This uses `isContrΠ` on the already checked `insideView`; it adds no choice,
sethood, truncation, or proof-irrelevance hypothesis.

The circle is the exact hostile control.  Agda checks simultaneously that
`InsideSections S¹` is inhabited and contractible, while the existing
`noDescentS¹` proves `Retracts₀ S¹` empty.  Therefore

```text
¬ (InsideSections S¹ ≃ Retracts₀ S¹).
```

The distinction is variance, not vocabulary.  `InsideSections A` is a
dependent choice in fibres indexed by the original points `a : A`.
`Retracts₀ A` is a left inverse for the different map
`A → ∥ A ∥₂`: it must reconstruct every original point after its higher path
information has been truncated.  Contractibility of the path fibre rooted at
each original point supplies no such reconstruction from a truncation class.

## Scope

This corrects only the sampled note's concluding bundle interpretation.  It
does not refute its checked equivalence `Retracts₀ A ≃ isSet A`, its
universality and uniqueness results for set-valued descent, or the theorem
that each `InsideFiber A a` is contractible.  It proves no general theorem
about arbitrary contractible-fibre maps beyond this explicit dependent
family, and it adds no claim about principal bundles, monodromy
classification, Berkovich spaces, automata rank, formed worlds, cyclotomic
transport, or physical realization.

The current realized-direction and native-witness results were consumed as
context but are not premises.  In particular, a supplied reverse exposure
map in `FormationDirectionIncidence` is positive data of another type; it is
not manufactured by fibre contractibility here.

The false paragraph is preserved under strike-through at its original
location in `DESCENT_BOUNDARY_TWO_LENSES.md`, followed immediately by this
typed correction.  The parallel comment in
`SetTruncationDescentBoundary.agda` is retained as a labeled retired claim and
points here; none of that module's checked theorem terms changed.

## Verification and provenance

The literal Draw 19 frame was pinned to origin commit
`073a222d99bbbca9a7975bb755378476630048ed`, tree
`d9c601175220bd068fd026203d7e2ba3232b6c51`.  The selected note had blob
`0284282b400946eddbbdbda3f7f9476625600d6e`.  The full frame and random draw
are recorded in the accompanying collaboration message.

The formal leaf is checked with Agda 2.8.0 and the installed Cubical library
under its in-file `--cubical --guardedness --safe --no-import-sorts` options.
Fresh isolated archive replays with `agda --ignore-interfaces -i .` check both
`SetTruncationDescentBoundary.agda` and
`ContractibleFiberSectionBoundary.agda` at exit 0.  The first pre-green cold
run of the new leaf exposed only a parser boundary in the product control:
Agda required `InsideSections S¹ × (¬ Retracts₀ S¹)` rather than the
unparenthesized form.  The fresh replays after that repair and the source
correction are the verification evidence.  The leaf is intentionally not
added to an aggregate in this commit.
