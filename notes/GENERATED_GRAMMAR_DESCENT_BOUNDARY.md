# Generated grammar withdrawal does not descend through semantics

**Status:** checked finite counterexample.  The leaf module is
`formal/cubical/NaturalMachine/GeneratedGrammarDescentBoundary.agda`.

## Random provenance

This result came from the seventh literal no-redraw semantic-corpus sample.
At frozen tree `b686cbc35041a2b8c3f32f669415dff8192dbbbd`, the declared frame
contained 959 bytewise-sorted tracked `.agda`, `.lean`, and `.md` paths under
`formal/`, `notes/`, and `papers/`, excluding build paths and six earlier
samples.  Its newline-frame SHA-256 was
`546be52711ea08abcfc435be97d774ddafeba560e13533d8aba15e332fe0c9b6`.
The sole native-`uint32` draw `568223411` selected zero-based index 567
(position 568), `notes/GENERATED_GRAMMAR_WITHDRAWAL.md`, blob
`007122ad57a5b62918ebc47f604c6b1db9d62d65`.

## Exact checked boundary

The sampled control declares two named productions, plants their support
sets, and assigns them the same `q3` observation label:

```text
shared derivation : {quotient, modulus}
direct derivation : {directRule}
```

The Agda module retains that planted table as `uses`; it does not carry a
parser, derivation tree, or provenance certificate.  After withdrawal of the
shared `quotient` rule, the shared production does not survive and the direct
one does.  Nevertheless
`semantic sharedDerivation ≡ semantic directDerivation` is `refl`.  Agda
checks both the named fibre split and the descent obstruction:

```text
semantic-fiber-splits-withdrawal :
  semantic sharedDerivation ≡ semantic directDerivation
  × ¬ (survives quotient sharedDerivation
       ≡ survives quotient directDerivation)

withdrawal-survival-does-not-descend :
  ¬ FiniteInformation.FactorsThrough semantic (survives quotient)
```

The second theorem is not a separate decoder calculation.  The existing
constructive theorem `factorsThrough→fiberConstant` says every descended
target is constant on observation fibres; the displayed pair and
`false≢true` refute that necessary condition.  Thus equal semantics does not
erase construction provenance when the later task is rule withdrawal.
Here `q3` is a declared semantic label, not a checked divisibility function;
no arithmetic computation is inferred from its name.

## Prior-art and retired-execution boundary

No mathematical novelty is claimed.  `notes/REVISION_DERIVATION_HYPERGRAPH.md`
already proves in prose the general finite AND/OR deletion law: a conclusion
survives precisely when one minimal derivation support avoids the deleted
rules.  `notes/HISTORY_DIGEST.md` identifies that support-antichain semantics
with de Kleer's ATMS work (1986), with Doyle's JTMS (1979) as ancestry for the
single-parent counterexample.  The sampled note specializes this lineage to
generated observations and a weighted minimax choice problem.

The Python solvers cited by those older notes are retired under the current
repository policy.  They were not run, imported, translated into evidence, or
treated as kernel verification here.  The new Agda term checks only the named
two-production descent obstruction.

It does **not** formalize the general hypergraph deletion theorem, shortest
witness forests, weighted invalidation mass, minimax optimality, the claimed
two-node minimum, multiple simultaneous withdrawal, derivation-bank repair,
or arithmetic grammar formation.  Those remain prose mathematics or open
formalization targets at their existing evidence grades.

## Verification

The current `origin/main` formal tree was extracted into a fresh temporary
directory and Agda 2.8.0 ran the new leaf with `--ignore-interfaces`.  It
exited zero under `--cubical --safe --no-import-sorts`; no interface was
written into the shared repository.
