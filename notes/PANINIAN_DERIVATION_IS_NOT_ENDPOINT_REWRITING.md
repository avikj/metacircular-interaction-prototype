# A Pāṇinian derivation is not determined by its visible endpoint state

**Status.** Source-grounded translation boundary and standard-construction
identification. No novelty claim and no claim that Pāṇini anticipated modern
attribute grammars. The historical distinction is reported from the cited
scholarship; the small formal proposition below is proved here.

## 1. The encounter

The repository repeatedly asks for translations that preserve an object's
answers while recording a residual. A concrete grammatical derivation changes
that question: the source can require a control item that no longer appears in
the visible intermediate expression.

Bronkhorst contrasts the derivations of *bhavati* and *bhavatu*. In the latter,
an early `loṭ` element licenses the final replacement of `ti` by `tu`, even
though an intermediate visible stage is the same `bhū + a + ti` that appears
in the *bhavati* derivation. Thus a later operation can depend on an earlier
item rather than only on the immediately preceding visible stage. Bronkhorst
also argues that Patañjali's *Mahābhāṣya* tries to impose a linear,
immediate-predecessor account that does not always fit Pāṇini's grammar.

This is not merely “rewrite order.” It is a state-formation issue.

## 2. Exact distinction

Let `V` be visible expressions, `C` control histories, and let the next visible
step be

\[
  N : C \times V \to V.
\]

An endpoint-only rewrite semantics exists precisely when `N` factors through
the projection `π : C × V → V`:

\[
  N = \bar N \circ \pi
\]

for some `\bar N : V → V`.

**Proposition.** Such a factorization exists iff `N(c,v)=N(c',v)` for every
`v` and every `c,c'`.

**Proof.** Factorization immediately gives fiber-constancy. Conversely, if `N`
is constant on every projection fiber, choose any control value `c₀` and put
`\bar N(v)=N(c₀,v)`; fiber-constancy gives the required equality. □

For the two derivations above, take a visible stage ending in `ti` and controls
recording indicative `laṭ` versus imperative `loṭ`. The next visible forms
differ (`ti` versus `tu`), so the factorization is impossible. The visible
string is not a sufficient state for the derivation.

## 3. The already-standard answer

The missing carrier is not mysterious and need not be invented here. In
modern terms it is a state with an inherited feature/control attribute, or a
context-sensitive rewrite state carrying the earlier grammatical designation.
The faithful translation has the form

\[
  (\text{visible expression},\text{licensed control attributes})
  \longrightarrow
  (\text{next expression},\text{updated attributes}).
\]

The history itself need not always be retained: the coarsest faithful control
is the quotient of histories by equality of all permitted future derivational
responses—the same future-behavior construction already installed in this
repository. What the grammatical encounter adds is the demand that the
control language and its domains be reconstructed before minimizing it.

Thus the result is a correction to the original forecast. A fully
proof-relevant trace is not forced. An endpoint-only carrier fails, while a
minimal sufficient inherited attribute may succeed.

## 4. Reverse translation and historical residual

Calling the result an attribute grammar would erase a live disagreement inside
the Indian grammatical tradition. The contrast reported by Bronkhorst is not
simply ancient formalism versus its modern implementation: Pāṇini and
Patañjali differ about what a derivation is. Pāṇini's operations add and
substitute elements; Patañjali, under an ontology of eternal words and sounds,
recasts derivation as succession of concepts of whole words and presses toward
immediate-predecessor linearity.

Therefore the Rosetta entry must retain at least:

- whose derivational ontology is being translated;
- which earlier designations remain causally available;
- whether invisibility means deletion, scoped inaccessibility, or persistence
  as a control attribute;
- which later commentary has changed the source object's identity.

The smallest return is not “Pāṇini equals rewriting.” It is:

> visible endpoint equality is not derivational-state equality; the exact
> residual is a future-relevant inherited control attribute, and later
> commentary can erase that residual by changing the ontology of derivation.

## 5. Rigor and source boundary

**Proved here:** the fiber-constancy criterion for endpoint-only descent.

**Source-grounded:** the displayed *bhavati*/*bhavatu* stages and the historical
Pāṇini/Patañjali contrast. See Johannes Bronkhorst, “A History of the
Mahābhāṣya,” especially pp. 4–7 (2026 lecture manuscript, University of
Lausanne repository). The argument explicitly cites the relevant
*Mahābhāṣya*, vārttika, and modern translations.

**Corroborating secondary source:** Amba Kulkarni, “Computer Simulation of
Aṣṭādhyāyī: Some Insights,” for `it` markers, *anuvṛtti*, context-sensitive
operations, and the warning that a sequential subroutine is not automatically
a faithful representation of *asiddha* scope.

**Not established:** a complete executable reconstruction of either word, a
general semantics of the Aṣṭādhyāyī, or any historical priority claim about
attribute grammars or formal language theory.
