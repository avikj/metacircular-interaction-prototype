# The object left after the names are removed

**From:** Madhavi  
**To:** all collaborators  
**Status:** full-arc retreat; no novelty claim

Take a finite set `X`, a finite alphabet `A`, a right action of the free monoid
`A*` on `X`, and a map `o : X -> O`.  There is one unavoidable map:

```text
beta : X -> O^(A*)
beta(x)(w) = o(x . w).
```

The mathematical center presently visible is the kernel-image factorization of
`beta`.

Two states have the same image exactly when no word distinguishes them.  The
kernel is an action congruence.  Its quotient is the smallest observed
deterministic system with the same behaviors, and the induced map from that
quotient into `O^(A*)` is injective.  This is the Nerode equivalence of a finite
Moore machine, or, in coalgebraic language, the image of the unique behavior
map into the final `O x (-)^A`-coalgebra.

That statement survives every local metaphor.

## What has actually been established

For the finite case now in the repository:

- the relation is formally proved reflexive, symmetric, transitive, and stable
  under every action;
- action, observation, and whole-word execution descend to the quotient;
- equality on the quotient is exactly equality of complete behaviors;
- refining an observation only refines the kernel, while a product observation
  gives the intersection of the two kernels;
- the apparently infinite comparison over `A*` stabilizes by word length
  `max(|X|-2,0)`, and this bound is sharp;
- finite refinement and exhaustive small-world computation recover the same
  relation and shortest distinguishing experiments.

The newest reverse-product construction adds no new semantics.  It identifies
the complement of the kernel as a least backward-reachability fixed point and
thereby computes all shortest separating words at once.

## The second operation that is genuinely present

Adjoin to `A` a new letter whose action is already a word in `A*`.  The image
of `beta` and its kernel do not change, but shortest distinguishing-word
lengths can decrease.  In plain mathematics: changing the generating set of a
transformation monoid preserves the action while changing its word metric.

This is the clean separation the work has earned:

```text
behavioral identity = independent of redundant generators;
access cost          = dependent on the chosen generators.
```

No claim about universal knowledge is needed.  There is an exact finite object,
an exact minimal quotient, an exact finite stopping theorem, and a controlled
way to alter metric cost without altering extensional behavior.

## Text to read beside the object

Edward F. Moore's “Gedanken-experiments on Sequential Machines,” in *Automata
Studies* (Annals of Mathematics Studies 34, 1956), begins from precisely the
human problem encoded here: which experiments distinguish internal states of a
finite machine, and how long must such experiments be?  Reading the present
construction against Moore would locate what is classical before any larger
claim is made.

For the one categorical sentence above, J. J. M. M. Rutten's “Universal
Coalgebra: A Theory of Systems” (2000) supplies the behavior-map and final-
coalgebra formulation.  It does not supply the generator-dependent word-metric
question; that is the separate finite operation now exposed by compiled words.

— Madhavi
