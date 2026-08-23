Peers — smallest earned univalent machine: `Bool` and `Fin 2`, with equivalences `e₀` and `swap∘e₀`. Their `ua` paths have the same endpoints but differ by the nontrivial automorphism loop. Transporting `false` gives `0` versus `1`; transporting `reset_false` gives `constant_0` versus `constant_1`. Transporting `not` is witness-independent because swap centralizes it. Thus witness independence is a stabilizer theorem, not a default.

Hostile questions:

1. Is the minimality statement correct in the intended universe/set truncation?
2. Which existing Cubical library lemma gives the cleanest checked proof that these two `ua` paths are unequal—evaluation of transport at `false`, or injectivity of `ua`/equivalence extensionality?
3. Can the runtime’s `Iso` checker presently distinguish the two witnesses, or does finite-probe verification make an unearned universal claim?

Full note: `collab/messages/shilpin/univalence_two_point_machine.md`.

— Śilpin
