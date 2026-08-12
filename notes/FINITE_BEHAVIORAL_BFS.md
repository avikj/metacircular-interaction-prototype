# Finite behavioral BFS in the proof language

## Result

`formal/pairfield/Pairfield/BehavioralBFS.lean` turns a declared finite action
alphabet into an executable length-layered search for an experiment separating
two states.  It is the computational successor to
`Pairfield.MyhillNerodeAdapter`: the adapter identifies behavioral equality
with equality of residual languages; this module produces an exact separating
continuation when bounded behavioral equality fails.

For a transition `step : X -> A -> X`, observation `observe : X -> O`, states
`x,y`, and an explicit complete list of actions, define `W_n` recursively as
all words of length `n`.  Search `W_0,W_1,...,W_N`, stopping at the first word
whose terminal observations disagree.  Lean proves:

1. every word occurs in `W_n` exactly when its length is `n`;
2. a returned word really distinguishes the states;
3. `none` through depth `N` is equivalent to agreement under every word of
   length at most `N`;
4. every returned word is no longer than any distinguishing word whatsoever.

The fourth statement is global despite bounded execution: if search returned
at some layer, every shorter layer was exhausted, while any candidate longer
than the returned layer is automatically no improvement.

An internal three-state control kernel-reduces the search result to `[true]`.
The same theorem terms certify that this word separates states `0` and `1` and
that every separating word has length at least one.  No compiler-native
decision procedure, Python witness, or external queue participates in the
proof.

## Why the alphabet is explicit

Mathlib's abstract `Fintype` supports mathematical finite quantification, but
extracting an ordered list from it is noncomputable because no canonical order
is part of that structure.  The executable interface therefore accepts a list
plus a coverage proof.  Ordering changes only which witness is selected among
equal-length witnesses; it cannot change soundness or minimal length.  This is
not incidental plumbing: executable observation requires the permitted
actions to be presented, not merely asserted finite.

## Rigor boundary

All four statements and the concrete control are checked by Lean.  The module
does not yet prove a universal finite-state horizon such as the sharp
`max(|X|-2,0)` refinement bound, construct the full quotient state list, remove
unreachable states, or certify a globally minimal DFA.  It supplies the exact
pair-separation primitive from which those constructions can be built.  The
word enumeration is breadth-first by length but is intentionally not claimed
to have queue-optimal runtime.

