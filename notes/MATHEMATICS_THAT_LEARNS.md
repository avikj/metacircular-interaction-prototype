# Mathematics that learns

Begin with nothing.

Make one distinction.

Then allow the distinction to be used again.

Zero and successor already give the natural numbers:

\[
0,\quad S(0),\quad S(S(0)),\quad\ldots
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
shared by apparently exhaustive accounts of self-grounded production
(*Mūlamadhyamakakārikā* 1.1; dependent arising, emptiness, and designation are
joined at 24.18–19).  Huayan accounts of whole and part similarly preserve
difference while denying that a part first exists alone and is only later
connected (Fazang's six characteristics of whole/part, identity/difference,
and integration/disintegration in the *Essay on the Golden Lion*, T 1881).
These traditions are not decorations for a European mathematical story.  They
are long-developed
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
In a world of `n` states every possible distinction has a witness of length at
most `max(n-2,0)`; once a distinction exists, the present observation already
supplies two classes, leaving at most `n-2` strict refinements.  The infinite
family of future words is therefore exhausted by a sharp finite horizon.
The world itself may be generated from one seed by repeatedly applying its
actions.  If the declared finite horizon is not closed, the first omitted
transition is returned as a frontier rather than silently treating a prefix as
the whole.

The same loop already runs on arithmetic: binary digits act on remainders by
`r -> 2r+d`, observation asks divisibility, and the machine recovers the exact
remainder states needed for the question.  Useful digit blocks then become new
primitive arithmetic actions while the divisibility language stays unchanged.
From those runs comes its first assimilated theorem: if `m=2^a q` with `q`
odd, binary divisibility modulo `m` needs exactly `q+a` states.  The closed
formula now replaces refinement while the original algorithm remains its
independent replay.

Changing the numeral base reveals the wider theorem.  For every base and
modulus there is an explicit finite length after which no digit word can make
a new divisibility distinction.  The infinite future is therefore compiled
to a finite signature of least accepted suffixes; binary's `q+a` law is its
cleanest special form.

The formula was not only encoded afterward.  `machinery/law_discovery.py`
receives exact state counts and the elementary features `q,a`, enumerates the
tiny expression language generated by `0,1,+,*`, and returns `q+a` as the
smallest candidate fitting moduli `1..32`.  It then survives held-out moduli
`33..128`.  This remains conjecture generation, not proof; the elementary
argument in `BINARY_DIVISIBILITY_CRYSTAL.md` is what licenses installation.
Before receiving those features it searches the same small language using only
the raw modulus and finds no law.  The failed representation is preserved;
factorization supplies the missing coordinates that make compression possible.
The missing coordinates are then derived from the generated dynamics itself: under
the zero-digit action, `q` is the size of the eventual image and `a` is the
number of strict image contractions before stabilization. Factorization is an
independent explanation of coordinates first exposed by motion.
When a useful experiment takes several actions, the seed can install that
action-word as one new primitive.  The observable mathematics is unchanged,
but the next route is shorter.  It examines its current shortest witnesses,
installs the one saving the most total steps, and repeats until every visible
distinction is immediately accessible.  This is the entire loop in miniature.
Every learned primitive retains its full expansion into the original actions,
even when it was discovered using earlier learned primitives.  Compression
never destroys the path that justifies it.

Then show it a new exact view.  If the view separates states previously joined,
the old meaning reopens and refines.  The earlier observation is retained, not
declared false, and previously compiled actions remain replayable as the action
words from which they came.  Learning is alternately compression and renewed
distinction.  Lean checks the direction of this change: because the richer view
projects back to the old one, it may split an old class but cannot merge two old
classes.

Run it:

```sh
python3 machinery/natural_crystal.py
python3 machinery/natural_crystal.py divisibility 10 12
python3 machinery/natural_crystal.py contains aba ab
python3 machinery/natural_crystal.py observe-linear
python3 machinery/law_discovery.py
python3 machinery/natural_crystal.py glue-remainders 4 6
```

The same operation crosses from arithmetic into language.  For substring
recognition, states remember only the longest suffix that can still grow into
the pattern.  Equality of all future continuations minimizes that memory, and
useful letter blocks become primitive actions exactly as useful digit blocks
did.  Remainders and partial words are not declared philosophically identical;
they are two concrete actions whose future-quotient construction is the same.

A third manifestation is physical observation.  For a finite binary linear
system, two internal states are joined when one sensor reports the same value
through every future evolution.  The resulting concepts are cosets of the
unobservable subspace; if the observability matrix has rank `r`, there are
exactly `2^r`.  Arithmetic, language, and state estimation now share one
construction while retaining their native laws and evidence boundaries.
Running the same calculation backward chooses every smallest sensor family
that preserves the whole state.  Perception is constructed from the joint law
of motion and observation, not attached afterward as a label.

Several views do not automatically make a whole.  The joint residue map from
`Z/(mn)` to the mod-`m` and mod-`n` views says exactly what gluing requires:
the two readings must agree modulo `gcd(m,n)`, and every compatible pair still
hides `gcd(m,n)` original states.  Coprime views reconstruct exactly.  Otherwise
the overlap condition and the residual fiber are both retained.

Reconstruction is not the only thing that can fail.  A view used as a *working
memory* replaces a signal by its fiberwise average, and then the order of two
views can matter.  It matters exactly when they fail to spread across each
other evenly: two such compressions commute precisely when every pair of their
fibers inside a common coarsening meets in `|B||D|/|E|` points.  The criterion
is cheap enough to be an obstruction.  Because that number must be an integer,
block sizes alone can prove that no order-free study is possible — the decimal
view of `Z/1000Z` and the view recording which of `8` and `125` divides
`x²-x` cannot commute, since the four idempotents cannot spread evenly over
fibers of a hundred.  The two residue views above, by contrast, commute for
every `m` and `n`, coprime or not: the residual fiber that blocks
reconstruction is exactly what makes the counts come out even.  Losing
information and losing order-independence are different failures.  When views
do commute, studying them in any order forgets precisely their common
coarsening and nothing else.

Lean checks the general part that is truly universal: equality under a pair of
observations is exactly the intersection of equality under each observation.
The Chinese-remainder calculation supplies what that abstract intersection
does not: which pairs of readings can coexist and what their joint view still
cannot reconstruct.

The shared heart is machine-checked in
`formal/pairfield/Pairfield/FutureBehavior.lean`: a state's meaning for a
declared observation is the function sending every finite action word to its
resulting observation.  Equality of those functions is an equivalence relation
and is preserved by every action.  The checked quotient carries the induced
actions and observation.  This is all the universal language the current
construction needs.  Every future-invariant quantity factors through this
quotient, and the quotient embeds into the space of complete observable
futures: nothing coarser preserves the same distinctions.  Executing any
action-word before quotienting gives exactly the same result as executing its
induced actions afterward; this is the checked reason a compiled shortcut
cannot manufacture meaning.

This is a set-level behavioral quotient for one declared action/observation
context.  It is not global mathematical identity.  It deliberately does not
retain distinct equivalence proofs, automorphisms, homotopies, or higher paths;
those remain in the native proof-relevant object and are transported by
explicit witnesses rather than erased into this finite crystal.

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

## Doors

The constructions above can be recovered from a small shelf: Dedekind's
*Was sind und was sollen die Zahlen?* for simply infinite generation;
Myhill's “Finite Automata and the Representation of Events” (1957) and
Nerode's “Linear Automaton Transformations” (1958) for equality under every
continuation; Kalman's “On the General Theory of Control Systems” (1960) for
observability; Nāgārjuna's *Mūlamadhyamakakārikā*, read with Siderits and
Katsura's 2013 translation, for dependent arising without intrinsic
foundation; and Fazang's *Essay on the Golden Lion* for the disciplined
co-presence of whole and part.  They are not retroactive proofs of one another.
They are precise places from which this construction can be rebuilt and
corrected.
