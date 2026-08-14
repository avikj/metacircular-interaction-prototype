# A declared root may carry a mode, not merely membership

`NaturalMachine.DeclaredRootedProfiles` correctly makes the propagation
boundary explicit:

```text
SeparatorFamily Declared profile =
  (root : Root) → Declared root → SeparatorAt profile root.
```

There is a small but load-bearing type-theoretic distinction in this
interface.  `Declared : Root → Type` is not automatically
proposition-valued.  A family can therefore inspect which declaration
witness it receives and select different separator data at the same root.

`NaturalMachine.DeclaredRootProofRelevance` checks both sides of this
boundary.  It supplements the sampled propagation theorem; none of the
existing reindexing or separator-transport results is changed.

## 1. Root-determined separator families

For a supplied separator family, define

```text
RootDetermined family =
  (root : Root) (left right : Declared root) →
  family root left ≡ family root right.
```

This is deliberately a statement about the output of this particular family.
It is not an assertion that two declarations at different roots agree, nor
an equivalence between arbitrary Type-valued families and a powerset.

If every declaration fibre is a proposition, any separator family is
root-determined:

```text
propositional-declarations-are-root-determined :
  ((root : Root) → isProp (Declared root)) →
  (family : SeparatorFamily Declared profile) →
  RootDetermined family.
```

The proof is one exact use of propositionhood followed by
`cong (family root)`.  Thus, for this output, the declaration witness can be
erased uniformly from every separator family whenever its fibre is
proof-irrelevant.  A particular constant family may already be
root-determined without that hypothesis; necessity is not claimed.

## 2. The sampled north declaration satisfies the condition

The sampled module defines

```text
northDeclared root = root ≡ false.
```

Since `Bool` is a set, each equality fibre `root ≡ false` is a proposition.
The new module therefore checks that the existing
`northDeclaredSeparators` family is root-determined.  Its positive singleton
example already behaves like root membership; no repair to that example is
needed.

## 3. Proof-relevant hostile control

Take one root, Boolean states, and the identity observation.  Let the
declaration type at the sole root itself be `Bool`.  The two declaration
witnesses select opposite oriented separators:

```text
false ↦ (false , true  , false≠true)
true  ↦ (true  , false , true≠false).
```

The first state stored in these separator witnesses is different.  If the
family were root-determined, applying `cong fst` to its equality would give
`false ≡ true`.  Hence both facts are checked:

```text
modeDeclaration-not-propositional : ¬ DeclarationIsProp ModeDeclared
mode-family-not-root-determined   : ¬ RootDetermined modeSeparatorFamily.
```

The declaration parameter can therefore encode a comparison mode, provenance
witness, capability, or other proof-relevant input.  Calling it a
“predicate” does not by itself license erasing that input.

## 4. Exact scope

The checked result establishes only:

- proposition-valued declaration fibres make a supplied separator family's
  output independent of the declaration proof;
- the sampled Bool equality declaration has that property; and
- a Type-valued declaration can fail it at a single fixed root.

It does not construct a subobject or powerset classifier, quotient declaration
witnesses, prove every proposition-valued family is a decidable root subset,
add a Braid event, mutate a theory stage, or broadcast a separator.  It also
does not say proof relevance is unwanted: sometimes declaration modes are the
data the interface should preserve.  The theorem only prevents those modes
from being silently read as mere membership.

## 5. Literal encounter provenance and verification

The second primary encounter froze `origin/main` at
`d97bd1a3b20cc5141f0ab569d9084347b17022e6`, tree
`ad44c1e870b0abcfe17467c1a129b95b0eccc03e`.  After excluding the first primary
sample, the C-sorted tracked semantic frame contained 1,156 `.agda`, `.lean`,
and `.md` paths under `formal/`, `notes/`, and `papers/`, excluding build
products.  Its newline-frame SHA-256 was
`710723fbcaf33b260c912db7df85ef8dcabfcb679012d5f442b381d8a0f3b25a`.
The sole accepted native uint32 was `3418882190`, below rejection limit
`4294966564`; index 630 (position 631) selected
`notes/DECLARED_ROOTED_PROFILE_PROPAGATION.md`, blob
`a06e1d8ca6bce50ba11531709724cc4dafc9a7a9`.  There was no rejection or
content redraw.

The new leaf passed its first focused Agda 2.8.0 replay and a full
ignored-interface replay under `--safe`.  An independent cold hostile replay
also exits zero and confirms the universe levels, proof-equality variance,
sampled north specialization, Boolean counterexample, and the narrow
root-determined-output scope.
