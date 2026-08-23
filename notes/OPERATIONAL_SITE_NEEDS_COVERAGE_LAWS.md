# An operational precoverage is not yet a site

## Exact correction

`notes/OPERATIONAL_SITE_CRYSTAL.md` defines an “operational site” as a finite
category equipped with a declared collection of covering families.  That data
does not yet define a Grothendieck site or a pretopology.  The declaration must
at least satisfy identity/maximal coverage, stability under base change, and
transitivity of covers (with the chosen family/sieve presentation stated).

The omission is not terminological hair-splitting.  Consider the thin category
on the chain

```text
e0 → e1 → e2.
```

Declare all identity arrows to be singleton covers.  Also declare `e0 → e1`
and `e1 → e2` to be singleton covers, but do not declare the composite
`e0 → e2`.  This is a finite category with exactly the kind of “declared
collection” permitted by §2, and it satisfies identity coverage.  It is not a
pretopology: transitivity of the two adjacent singleton covers requires their
composite to cover.

`formal/cubical/NaturalMachine/OperationalCoverageCounterexample.agda` checks
this counterexample.  Its Boolean table `coverCode` contains all identities
and the two adjacent arrows; `declared-covers-not-transitive` proves that no
function implementing singleton-cover transitivity can inhabit the table.
The proof is safe Cubical Agda with no postulates or holes.

The neutral name for §2's current object is therefore a **finite experiment
category with a declared precoverage**.  It becomes an operational site only
after the closure laws are supplied and checked.

## What survives unchanged

The correction does not invalidate every mathematical component of the
sampled note.

- For any individual family whose relevant pullbacks exist, the displayed
  equalizer comparison still defines separation and effective descent for
  that family.
- The contextual crystal is still the image/kernel quotient of a named joint
  observation map.  This is a finite-set construction and does not require a
  site.
- Theorem 4.1 is a restricted-Yoneda statement about the inclusion of a full
  probe subcategory into a finite powerset poset.  Its singleton detection
  proof is independent of the undeclared coverage laws.

One phrase in Corollary 4.2 should be kept typed carefully.  Quotienting the
set of subsets by equality of profiles constructs the crystal on **objects**.
Under the singleton criterion, the restricted nerve separately reconstructs
the powerset category's inclusion arrows because it is fully faithful.  The
bare set quotient does not itself carry those arrows until a category
structure and its transport are defined.

## The exact site-to-crystal map

Once a genuine site datum is present, the common object is local and named.
For a presheaf `F`, an object `e`, and one cover `{eᵢ → e}`, restriction gives

```text
F(e) → ∏ᵢ F(eᵢ).
```

The contextual crystal of that cover is the image of this map.  Its fibers
measure failure of separatedness.  The complement of its image inside the
matching-family equalizer measures failure of existence in effective descent.
This joins the two vocabularies by an explicit map without identifying the
crystal quotient with sheafification.

## Executability boundary

The sampled note's executable certificates point to retired Python files.
Under the current repository constitution those files are not a load-bearing
verification substrate and were not run in this encounter.  Their reported
controls remain historical implementation evidence until corresponding
Agda/Lean objects are installed.  The new transitivity counterexample is the
checked replacement for the one claim needed here.

## Rigor boundary

- Checked: the finite declared coverage table contains every identity and the
  two adjacent covers but admits no transitivity operation.
- Prose-exact: a pretopology's singleton-cover transitivity would require the
  missing composite; this is the standard specialization of the axiom.
- Not checked here: pullback stability, a complete finite category record, a
  sheaf equalizer implementation, the powerset density theorem, or the
  sampled retired-Python controls.
- No novelty is claimed for Grothendieck pretopology axioms or the chain
  counterexample.  The result is a fail-closed correction of the sampled
  repository definition.
