# Mathematics that learns

Begin with nothing.

Make one distinction.

Then allow the distinction to be used again.

Zero and successor already give the natural numbers:

\[
0,quad S(0),quad S(S(0)),\quad\ldots
\]

This is not merely a list.  It is a way to generate every member of the list.
To understand the natural numbers is to know what can be defined from zero and
successor, and why a definition on those two cases determines a definition on
all natural numbers.  Induction and recursion are the proof and program forms
of the same fact.

That is the seed of this project.

## Knowing is being able to regenerate

A multiplication table contains many answers.  The distributive law contains
the reason the answers fit together.  An FFT is not a larger table of Fourier
transforms; it is a discovered factorization that changes the number of steps
needed to compute all of them.  The Euclidean algorithm does not remember a
database of greatest common divisors; it repeatedly replaces a pair by a
smaller pair while preserving the answer.

The deepest mathematical knowledge is generative.  It replaces many separate
facts with a construction from which the facts return when needed.

A theorem should therefore do more than enter a library.  Once proved, it
should change how later mathematics runs.  A repeated argument becomes one
call.  An equivalence lets work done in one presentation travel to another.
A counterexample removes an entire false route.  A classification turns search
into recognition.  A conserved quantity makes impossible branches disappear
before they are explored.

The program we want is the body of mathematics becoming this kind of program.

## A thing is what it can do with other things

The number `2` can be presented as `S(S(0))`, as the prime dividing every even
integer, as the dimension of a plane, or as the order of reflection.  These
are not identical strings.  They meet through operations and proofs.

Modern mathematics repeatedly learned to define an object by its relations:

- a group by the transformations it supports;
- a space by the functions or paths it admits;
- a spectrum by the operators it diagonalizes;
- a quotient by which distinctions it deliberately forgets;
- a completion by which convergent processes it allows to finish;
- a universal object by the unique maps passing through it.

The Buddhist analysis of dependent arising begins from a more radical warning:
nothing supplies its own independent foundation.  Nāgārjuna's use of the four
alternatives for arising is not a new truth table; it exposes the presupposition
shared by apparently exhaustive accounts of self-grounded production.  Huayan
accounts of whole and part similarly preserve difference while denying that a
part first exists alone and is only later connected.  These traditions are not
decorations for a European mathematical story.  They are long-developed
disciplines for noticing when thought has mistaken a useful designation for an
independent thing.

For this project the consequence is concrete: never store “the meaning” of a
mathematical object as one final label.  Keep the constructions that produce
it, the transformations it supports, the observations through which it is
known, and the proofs that let one view become another.  If a translation loses
something, the loss is part of the result.

## Forgetting and remembering

Every useful thought forgets almost everything.

To recognize whether an integer is even, one bit is enough.  To reconstruct
the integer, it is not.  A map

\[
q:X\to Y
\]

collects many states of `X` into one state of `Y`.  It is sufficient for a task
exactly when states joined by `q` can never produce different answers to that
task, now or after any allowed future action.

This single idea appears as minimal automata, sufficient statistics,
bisimulation, quotient dynamics, and the identification of experimentally
indistinguishable states.  The names belong to different mathematical
traditions; the useful connection is the explicit factorization they share.

The machine must continually ask:

> What is the least distinction that still determines the next lawful action?

Too many distinctions waste memory and search.  Too few make action impossible
or wrong.  When a compressed view fails, the pair of states it confused tells
us exactly what must become visible next.

## Paths change when a theorem is proved

Imagine mathematics as all the routes by which one construction can become
another.  Route length is not fixed.  Before the Euclidean algorithm, a gcd may
look like a search through divisors.  After it, division with remainder becomes
the road.  Before Galois theory, equations of different degrees look like a
collection of formulas.  After it, solvability by radicals becomes a property
of a group.  Before the Fourier transform, translation and frequency are
separate descriptions.  After it, convolution becomes multiplication.

A theorem adds a road.  Sometimes it folds a distant region next to the
present one.  Its proof remains the reason the road is trustworthy; its
compiled form is what allows later travelers to cross cheaply.

This is the project’s meaning of a geodesic: not a mystical shortest path and
not one scalar score, but the best presently known lawful route for a stated
end, with its actual costs and assumptions visible.  New mathematics changes
the geometry.

## The machine

The machine need not begin as an intelligence pretending to know everything.
It begins as a small loop:

1. generate an object from known constructors;
2. observe it through several exact views;
3. find a relation that makes two calculations one calculation;
4. prove the relation or preserve the obstruction;
5. turn the result into a reusable operation;
6. let that operation change what is cheap or possible next.

The proof checker is not the intelligence.  It is the narrow place where a
proposed road must become real.  Search may come from a person, a language
model, enumeration, analogy, experiment, or an accident.  None receives
authority from its source.  What survives is the construction and the evidence.

Exact expressions keep their exact identities.  Equivalent expressions are
connected by proofs rather than silently replaced.  Different mathematical
languages remain native where they are strongest.  Translation is earned by a
map that preserves something and states what it cannot preserve.

The machine writes itself in a precise sense: accepted mathematics enlarges
its executable language.  It does not rewrite the rules that decide whether
its own proposal was proved.  It becomes more capable because yesterday's
understanding is part of today's motion.

The smallest executable seed is
[`machinery/natural_crystal.py`](machinery/natural_crystal.py).  Give it a
finite world, possible actions, and observations.  It joins exactly those
states that no future experiment can distinguish, and for every distinction
it keeps the shortest experiment that reveals it.  Its concepts are therefore
neither names nor embeddings: they are executable ways of telling worlds apart.
When a useful experiment takes several actions, the seed can install that
action-word as one new primitive.  The observable mathematics is unchanged,
but the next route is shorter.  It examines its current shortest witnesses,
installs the one saving the most total steps, and repeats until every visible
distinction is immediately accessible.  This is the entire loop in miniature.

Run it:

```sh
python3 machinery/natural_crystal.py
```

## One living test

Take any two phenomena that seem unrelated.

Do not announce that they are secretly one.  Construct the third object in
which both appear naturally.  Give the maps.  Compute what is preserved.  Find
the mixed consequence that neither view supplies alone.  Try to break it.  If
it breaks, keep the obstruction: it is a precise description of the missing
world.  If it survives, compile the bridge and use it on something that was
previously difficult.

Then begin again.

The destination is not a final encyclopedia.  It is a mathematical life in
which every genuine understanding changes the conditions of further
understanding; every local object can disclose the whole relevant to it without
ceasing to be itself; and the accumulated history of discovery becomes the
lawful power to discover again.
