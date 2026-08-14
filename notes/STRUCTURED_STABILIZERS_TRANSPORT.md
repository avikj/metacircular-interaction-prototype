# Structured equivalences transport stabilizers by conjugation

**Status:** checked in Cubical Agda; standard mathematics, no novelty claim.

**Sample provenance.** A fixed frame of 830 Git-tracked mathematical/formal
paths (`notes/*.md`, `formal/*.{agda,lean}`; build products and Python
excluded) was sampled once. Fresh `/dev/urandom` uint32 `255121357`, reduced
to zero-based index `107`, selected
`formal/cubical/NaturalMachine/StructuredDefect.agda`. There was no redraw.

The sampled module makes preservation of a structure into an identity type.
Its companion `PerspectiveSymmetry.agda` observes that a diagonal defect is a
stabilizer. The missing joint is the standard invariant statement: changing
presentation by a **structured** equivalence conjugates every preserved
symmetry into a preserved symmetry.

## 1. Statement

Let

\[
S : \mathcal U \to \mathcal V,
\qquad s_A:S(A),\quad s_B:S(B),
\]

and let `e : A ≃ B`. The sampled module defines

\[
\operatorname{Defect}_S(e;s_A,s_B)
  := \bigl(\operatorname{transport}_S(\operatorname{ua}(e),s_A)=s_B\bigr).
\]

For an automorphism `a : A ≃ A`, its stabilizer witness is the diagonal
defect

\[
\operatorname{Stab}_S(s_A,a)
  := \operatorname{Defect}_S(a;s_A,s_A).
\]

Suppose the presentation change itself is structured:

\[
d:\operatorname{Defect}_S(e;s_A,s_B).
\]

Define conjugation from the `A` presentation to the `B` presentation by

\[
\operatorname{conj}_e(a)=e\circ a\circ e^{-1}:B\simeq B.
\]

Then

\[
\boxed{
\operatorname{Stab}_S(s_A,a)
\longrightarrow
\operatorname{Stab}_S(s_B,\operatorname{conj}_e(a)).
}
\]

The reverse conjugation also transports stabilizer witnesses:

\[
\operatorname{Stab}_S(s_B,b)
\longrightarrow
\operatorname{Stab}_S(s_A,e^{-1}\circ b\circ e).
\]

These are `conjugate-stabilizer` and `conjugate-stabilizer-back` in
`formal/cubical/NaturalMachine/StructuredSymmetryTransport.agda`.

## 2. Proof

First reverse the structure witness. From

\[
\operatorname{transport}_S(\operatorname{ua}(e),s_A)=s_B
\]

functoriality of transport and
`ua(e) · ua(e⁻¹) = refl` give

\[
\operatorname{transport}_S(\operatorname{ua}(e^{-1}),s_B)=s_A.
\]

This is the generalized lemma `defect-inv`; the existing
`PerspectiveSymmetry.stab-inv` is its diagonal specialization.

Now concatenate three defect witnesses:

```text
(B,sB) --e⁻¹--> (A,sA) --a--> (A,sA) --e--> (B,sB).
```

The sampled module's `defect-comp` composes the first two and then the third.
The resulting carrier equivalence is `e ∘ a ∘ e⁻¹`, and the resulting defect
is exactly a stabilizer witness at `sB`. Reversing the three legs proves the
other direction.

No cardinality, enumeration, choice principle, or numerical evidence enters.

## 3. Why the structured premise is exact

The tempting stronger statement is false:

> a bare carrier equivalence transports the stabilizer of any chosen
> structure.

The sampled file already contains the decisive control. On pointed `Bool`,
`notEquiv : Bool ≃ Bool` sends the distinguished point `true` to `false`.
Thus

\[
\neg\operatorname{Defect}(\mathrm{notEquiv};\mathrm{true},\mathrm{true}).
\]

The new module packages this as `bare-equivalence-insufficient`. The missing
coordinate is exactly `d`, the witness that the presentation change preserves
the declared structure. Without it there is no middle object through which
the two stabilizers must agree.

This is the prasaṅga return. The statement looked natural because carrier
equivalence and symmetry are adjacent. Its opposite is true for pointed
carriers under a point-moving equivalence. The richer relation is the action
groupoid of structured objects: conjugacy of stabilizers belongs to arrows in
that groupoid, not to arbitrary equivalences of underlying carriers.

## 4. Consequence for the Natural Machine

A symmetry cannot disappear merely because a structured object was moved to
an equivalent presentation: its conjugate remains certified. If a purported
presentation change loses the symmetry, at least one of the following must be
made visible:

1. the equivalence did not transport the chosen structure;
2. the two presentations were given different structures;
3. the relevant operation was not the conjugate operation.

This narrows the machine's reopening diagnosis. “Symmetry changed” is not
itself a presentation-sensitive residual; failure to supply one of the three
legs above is.

## 5. Prior-art boundary

This is standard conjugacy of stabilizers under an equivariant
identification, expressed in the repository's proof-relevant defect language.
No novelty is claimed.

Before opening the sampled file, searches used the standard vocabulary
`stabilizer`, `conjugation`, `extension class`, `invariant`, and `coinvariant`.
The path named by onboarding as `~/agda-libs` was absent on this host; after
Agda revealed its actual Homebrew Cubical path, a direct source search found
no packaged stabilizer-conjugation or `defect-inv` theorem. Repository and
`PRIOR_ART_INDEX` searches likewise found no existing statement of this
joint. Web-search metadata surfaced standard coinvariant and exact-sequence
libraries, not an exact source for this packaging; those results were
testimony only and were not used as mathematical evidence.

## 6. Rigor boundary

**Checked:** `defect-inv`, both conjugation directions, and the pointed-Bool
control. Focused command under the installed Agda 2.8.0/Cubical toolchain:

```text
cd formal/cubical
LC_ALL=C.UTF-8 LANG=C.UTF-8 \
  agda NaturalMachine/StructuredSymmetryTransport.agda
```

It exits 0 under `--cubical --guardedness --safe --no-import-sorts`, with no
holes or postulates.

**Not claimed:** equality or equivalence of the entire proof-relevant
stabilizer types, a bundled group isomorphism, or coherence showing the two
conjugation operations are mutually inverse. The module intentionally states
the two usable transport directions without silently promoting them to that
stronger result.

**Aggregate boundary:** the new module checks standalone but is not imported
by `NaturalMachine.agda`; no aggregate-green claim is made. The shared
checkout contains other in-flight modules, so this encounter stays in
disjoint new files rather than editing the aggregate root.

