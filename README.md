# math

## Zero, and then another

Put down one mark.

```text
0
```

Now give yourself one operation: make the next mark.

```text
0
S 0
S (S 0)
S (S (S 0))
...
```

Nothing has been counted yet. No decimal digits have been chosen. We have only
a beginning and a repeatable act. But every finite natural number is already
reachable, and its construction is also its address: `S (S 0)` remembers the
two steps by which it came to be.

This elementary picture is exact. In the category of sets, the natural
numbers are an initial algebra for the operation `X -> 1 + X`. To define a
function from the naturals, say what it does at zero and how it responds to a
successor; the recursion theorem supplies the unique function. Induction is
the corresponding dependent principle. Addition is repeated successor.
Multiplication is repeated addition. Exponentiation is repeated
multiplication. A tiny grammar becomes arithmetic because generation and
interpretation meet.[^lawvere]

Writing `375` introduces another machine. Reading left to right, each digit
acts on the accumulated number by

```text
n |-> 10 n + d.
```

Composition of those affine actions is place value. Change ten to two and the
same free word becomes a path through a binary tree, an instruction stream, or
a circuit address. The symbol is not merely a label on a finished object. Its
form records a lawful way to generate the object.

Now turn the picture around. A finite object is built by folding its
constructors. A process that may continue forever is known by unfolding its
next observation and next state. Initial algebra and final coalgebra are
categorical dual patterns; induction and coinduction are their corresponding,
not interchangeable, principles. A hylomorphism unfolds a source and then
folds the result, and fusion laws can often eliminate the intermediate tree.
This is the first secret
of efficient thought: a structure can be a thing, a history, a program, and a
view of a process, depending on which map we are following.[^recursion]

The machine sought here begins with that traffic. It is not software wrapped
around mathematics. It is mathematics becoming executable wherever its proof
reveals an operation.

## A distinction is an action

Draw a line through a collection. Some objects fall on one side and some on
the other. The line may be a predicate, a measurement, a quotient, a basis
choice, a grammatical category, a sensor, or a question. It does not have to
be a wall in reality.

This matters because a description can forget exactly what a task needs. A
map `q : X -> Y` puts two states in the same fiber when it shows them as the
same. A task `t : X -> A` can be performed from the view `q` precisely when

```text
q(x) = q(x')  implies  t(x) = t(x').
```

Then `t` factors uniquely through the image of `q` (and through `Y` itself when
`q` is onto). If the implication fails, the pair `(x,x')` is
not an embarrassment; it is the exact missing distinction. Add a channel that
separates that pair, or admit that the task cannot descend. Myhill and Nerode
turn this observation into a theorem: the states of the smallest reachable
automaton for a language are the equivalence classes of prefixes having the
same possible futures; this automaton is finite exactly when the language is
regular.[^myhill]

So the minimal representation of a process is never “the fewest symbols” in
the abstract. It is the coarsest distinction that still preserves the declared
questions, actions, and futures. Change the questions and the geometry changes.
Two views that are individually lossy may be jointly faithful. A color added
as a deterministic rendering may carry no new extensional fact and still make
an old fact available to a nervous system sooner. Information, access, and
action are different measurements of a channel.

Read the Indian sciences of language and knowledge first through their own
problems, opponents, genres, and standards of warranted cognition; only then
construct partial translations to logic or computation. Pāṇini's
*Aṣṭādhyāyī* is a tightly compressed derivational rule system using technical
markers (*it*), headings and domains (*adhikāra*), recurrence (*anuvṛtti*) and
interpretive conventions to regulate well-formed Sanskrit expression. Modern
formal-language comparisons illuminate some operations but do not exhaust its
grammatical project. The Nyāya
tradition analyzed the means and conditions of warranted cognition. Dignāga's
*Hetucakra* tabulated nine distributions of a reason across similar and
dissimilar cases as part of the conditions for a sound inferential sign;
Dharmakīrti refined inference and the
relation between perception, particulars, concepts and words. The Buddhist
Buddhist *apoha* theories developed by Dignāga, Dharmakīrti and later
commentators explain conceptual and linguistic generality through exclusion;
their formulations differ. These are different disciplines and argumentative
traditions, developed against one another for centuries. Their disagreements
are part of the information.[^indianlogic]

Nāgārjuna's use of the *catuṣkoṭi* does not hand us a fashionable four-valued
database. In the *Mūlamadhyamakakārikā*, the four alternatives are repeatedly
used inside arguments against intrinsic nature: a phenomenon is not produced
from itself, from another, from both, or without cause; nirvāṇa is not simply
captured as existent, nonexistent, both, or neither. The point is not to stock
four boxes with entities. In these arguments they expose commitments involved
in reifying production or nirvāṇa; how the tetralemma's logic should be
formalized remains disputed.[^nagarjuna]

Jain *anekāntavāda* is a discipline of non-one-sidedness, *naya* articulates
partial standpoints, and *syādvāda* expresses conditioned assertion through a
sevenfold scheme (*saptabhaṅgī*). Apparently opposed assertions may therefore
be warranted under explicitly different respects. Dignāga, Dharmakīrti,
Nyāya, Madhyamaka and Jain philosophers do not collapse into one pluralist
slogan. Read together, they train a precise reflex: before declaring a
contradiction, identify the object, context, means of knowledge, standpoint,
and force of the assertion.[^jain]

This repository inherits that reflex. It seeks no accepted `P` and `not P`
under the same statement, theory and assumptions. It does not erase an
apparent conflict across different settings. It keeps the conflict open until
there is a translation, a counterexample, a proof, or a demonstrated failure
to glue.

## Reachable points and the circle beyond them

Take a positive pair `(p,q)`. Two operations are enough to generate every
positive coprime pair exactly once:

```text
L(p,q) = (p, p+q)
R(p,q) = (p+q, q).
```

To run backward, subtract the smaller coordinate from the larger. The sum
strictly decreases, so the Euclidean algorithm returns to `(1,1)`. Every
finite binary word therefore names one reduced positive rational. Add signs,
zero and the point at infinity to pass from this positive chart to the whole
projective rational line. Through the
classical parametrization

```text
t |-> ((1-t^2)/(1+t^2), 2t/(1+t^2)),
```

projective rational parameters `t in Q union {infinity}` name exactly the
rational points of the unit circle.[^stern]

They are countable. They are dense. They have arc-length measure zero. Their
metric completion is the whole circle, but almost every point in the completion
has no finite rational address. Three truths coexist:

```text
every generated address is exact;
generated addresses approach every point;
almost every point is never generated.
```

Confusing these truths ruins both mathematics and system design. An
enumeration is not a completion. Density is not coverage. A law on the
reachable points may fail to extend continuously to their boundary. Yet every
rational point tells us something exact about the ambient circle. Pythagorean
triples, Euclid's algorithm, projective geometry, topology and measure are not
five metaphors placed side by side: the displayed maps make them views of one
object.

This is the recurring motion of the project. Work completely inside a finite,
rational, computable, or formally generated world. Then ask for its image,
closure, completion and omitted locus. Ask what survives at the boundary.
The unknown is not an unstructured exterior. Its shape is already registered
by the ways our exact constructions fail to fill it.

## When two views interfere

Suppose two phenomena resemble one another. Their product always exists, so
juxtaposition proves nothing. A real connection requires maps.

Perhaps both are representations of the same group. Perhaps one is a quotient
of the other. Perhaps they satisfy the same universal property. Perhaps there
is an adjunction, a duality, a deformation, a completion, a Fourier transform,
a shared invariant, a correspondence, or an obstruction to every attempted
map. These words are not thirteen unrelated decorations. Most are answers to
one question:

> What third object, together with which arrows and laws, makes both original
> objects appear as necessary faces of one construction?

The third object may be a mediator, a span, a module, a family, a category of
models, or a common action. The connection earns its name when something
passes through it: a theorem transports, two proofs become one proof, a new
mixed invariant appears, an impossible translation is certified, or a
calculation becomes cheaper. The interference term is the value. A bridge that
does no work is still only resemblance.

Fourier analysis is the cleanest elementary teacher. A function and its
spectrum are not rival descriptions; the transform is invertible under named
hypotheses. Translation becomes phase, convolution becomes multiplication,
localization in one view opposes localization in the other. The uncertainty
principle is not a mystical statement that “everything is connected.” It is a
quantitative obstruction generated by the exact relation between two views.

Galois theory performs another such compression. For a polynomial over a
suitable field, solvability by radicals is equivalent to solvability of its
Galois group. Homology turns holes into algebra. Representation theory turns an
action into linear operators. Category theory turns the repeated phrase
“unique up to unique isomorphism” into a working method. Each great
construction makes previously distant arguments adjacent because it finds the
right carrier of their common motion.

Knowledge can therefore be pictured as a sphere whose metric is continually
rewritten. A new theorem does not merely add one point. If it factors twenty
old proofs through one lemma, or identifies two presentations by an explicit
equivalence, paths that were long become short. The points need not be erased
or quotient into literal identity; the new bridge changes the cost of travel
while preserving the path by which the bridge was learned. The sphere pulls
more boundary inward and becomes larger and more compact at once.

This is the Socratic force of the machine. A good question does not fill an
empty slot. It changes which distinctions are visible, brings distant claims
into collision, and may fold the current picture around a new center. The
answer then changes the next question.

## Identity that remembers how

Ordinary files are named by where somebody put them. Unison names a definition
by a hash of its syntax and dependencies. Rename it and its identity can
remain; change what it means and the address changes. This makes code into a
causal graph and turns refactoring into graph surgery rather than textual
search.[^unison]

But exact sameness of content is only one layer. Two groups, spaces, programs
or theories may be differently written and mathematically equivalent. A hash
cannot discover that. Homotopy type theory treats an equality as a path that
may itself have structure. In a univalent universe, the canonical map from an
equality of types to an equivalence of types is itself an equivalence;
transport along the resulting path is checked mathematics, not cache-key
optimism. Computational behavior for univalence is supplied by particular
cubical type theories rather than by the axiom alone. Different automorphisms need not
be crushed into one anonymous fact that the endpoints are “the same.”[^hott]

These mechanisms fit without becoming one mechanism:

```text
content address: exactly which presentation and dependencies?
proof term: why is this judgment valid in this theory?
equivalence/path: how may structure move between presentations?
event history: under which evidence and authority is that movement active?
```

Equality saturation supplies a fast, deliberately more forgetful layer. An
e-graph stores many equivalent expressions compactly under a chosen equational
theory and extracts a representative by a cost model. A proof-producing
version must retain an explanation for every merge. It is excellent machinery
for congruence; it is not by itself the full higher groupoid of all paths and
coherences.[^egg]

The result is not one universal symbolic language. Lean, Cubical Agda, a
computer algebra system, a finite-field kernel, a diagram, a spoken
explanation and a physical instrument are different native charts. A
polyglot machine learns each where its distinctions are natural, then links
charts by checked translations with explicit residuals. What refuses
translation is not garbage. It is often the next theorem.

## A theorem is a new instruction

A theorem can alter future execution.

Before the Euclidean algorithm, locating a rational pair in the binary tree
might mean searching outward. After the forced-parent theorem, the address is
recovered by subtraction. Before a spectral decomposition, applying a large
operator may mean repeated matrix multiplication. After diagonalization, the
dynamics reduce to independent scalar powers. Before an irreducibility
criterion, a search branches through possible factors. After the criterion,
whole branches disappear with a small certificate.

This is compilation in the literal sense: a general mathematical fact becomes
a deterministic capability for every instance matching its hypotheses. The
proof remains the reason the optimization is permitted. The matcher and the
side conditions say where it applies. The certificate lets a small checker
validate each result. The measured reduction in arithmetic work says whether
the compilation was useful.

The repository contains instances of this pattern in unfinished but concrete
form. [`exact_polynomial.py`](code/exact_polynomial.py) supplies exact
polynomial arithmetic, Sturm counts and Bareiss resultants; finite-field
factor tests, product constraints and tail inequalities replace broad searches
by short exclusion certificates. [`observer_channel.py`](machinery/observer_channel.py)
turns finite-view collisions into missing-state witnesses, while
[`cpu_ledger.py`](machinery/cpu_ledger.py) addresses and checks completed census
shards without proving that the mathematical shard domain was exhaustive.
Negative results—an impossible sign, a failed descent, an
insufficient invariant—compile too: they delete a route and expose the
distinction the next construction must carry.

The deeper machine appears when this repeats. A successful proof is stored as
a shared derivation, not dead prose. Repeated derivations suggest a common
lemma. Counterexamples delimit its hypotheses. Once checked, the lemma becomes
a rewrite, a solver, a transport, or a pruning rule. That new capability
changes the cost of later searches, so it changes which conjectures become
reachable. Mathematics and the machinery for doing mathematics then co-evolve
through mathematics itself.

No language model is required in the compiled path. Large models are valuable
where meaning is ambiguous, a new representation must be proposed, or distant
literatures must first be brought into contact. Once a relation has been made
exact, ordinary CPUs should replay it more cheaply, deterministically and with
stronger guarantees than regenerating the reasoning in tokens. The expanding
boundary between these two regimes is itself a measurable frontier.

Term rewriting gives a physical-looking form to this idea: expressions are
graphs and computation is local replacement. Church–Rosser and Newman's lemma
state precise conditions under which different reduction histories have a
common reduct or unique normal form; they do not make the histories identical.
Interaction nets make independent active pairs reducible in parallel; sharing
graphs prevent some repeated work. Wolfram's multiway systems place all
rewrite histories in one graph and propose further structures—causal,
branchial and rulial—built from their relations. The established rewriting
theorems and the Wolfram Physics Project's larger physical hypotheses must not
be given the same evidentiary status. But the question they share is exact and
alive: when do local rules produce a coherent global history independent of
the observer's path through the rewrites?[^rewriting]

## Many senses, one object

A proof assistant's term is authoritative for a formal judgment, but a human
does not perceive terms as a kernel does. We use spatial grouping before we
name it, hear prosody before parsing a sentence, and discriminate color with
different circuitry from letter shape. A representation can preserve all
mathematical information and still make the needed relation painfully slow to
recognize.

So one native object should admit synchronized symbolic, spatial, chromatic,
auditory, algebraic, historical and operational views. Color may encode a
letter, digit, root, prefix or semantic family; a word may decompose into
colored morphemes while an exceptional whole overrides the first-letter rule.
These mappings are part of a language, not claims that hue proves a theorem.
Their value is that they route already valid structure through a faster or
more associative human channel. Every cue should remain reversible to the
native object, or display exactly what it has forgotten.

This is also a human–machine interaction problem. In shared autonomy, the
machine does not receive a perfectly specified fixed reward and then replace
the person. It infers from partial actions, remains legible enough to be
corrected, and preserves the human's ability to steer. Legibility,
predictability and efficiency are distinct objectives; a motion that reveals
its goal may differ from the shortest motion. Cooperative inverse reinforcement
learning models uncertainty about a shared reward parameter; inverse reward
design treats a proxy reward as evidence about an intended reward. These do
not by themselves model purpose changing during interaction, but they show why
a literal instruction can be evidence about purpose rather than purpose
itself.[^hri]

The human is not outside the mathematical machine. Neither is the language
model, the library, the notation, the compiler, the proof kernel, the
instrument, or the physical computer. Each changes what the others can
distinguish and do. But their responsibilities remain different: intuition
proposes; language connects; experiment measures; proof compels within its
assumptions; hardware pays the physical cost.

Landauer's principle gives one sharp boundary between logic and physics. For
the canonical cyclic, equilibrium reset of an unbiased bit with no usable side
information, the minimum average work dissipated as heat is `k_B T ln 2`.
Bias, correlations, side information and nonequilibrium resources change the
accounting. It does not follow that every shorter proof saves a
fixed number of joules. Still, sharing a derivation instead of recomputing it,
retaining information instead of erasing it, and compiling a theorem instead
of repeatedly searching are physical as well as logical choices. A mature
mathematical engine must eventually account for CPU work, memory traffic,
verification, communication and heat—not call all of them “complexity.”[^landauer]

## Four friends walking

Galileo wrote the *Dialogue* as three rhetorically unequal interlocutors whose
different habits of thought make the argument move. We can read Galileo as an
absent fourth: the author arranging their speech, interpreted in turn by the
reader. A
tetrahedron gives the same count a stricter geometry: four vertices, six
pairwise edges, every face a triangle, no privileged central vertex.

This is useful as an operation, not numerology. Give one object to four minds:

```text
one generates a construction;
one changes the standpoint and questions the predicates;
one calculates, measures, and tries to break it;
one reconstructs the invariant that survives all three.
```

Then rotate the roles. Each mind must receive the others' actual returns; four
independent monologues are not a tetrahedral dance. The six relations matter
as much as the four vertices. The common object moves because each complete
view exerts a different force on it.

This does not make Galileo's dialogue, the Buddhist four-corner analysis, Jain
conditioned predication and a geometric simplex identical. Their interference
is a research question: which translations preserve their operations, and
where does the analogy fail? Correct numerology begins there. A repeated number
is an invitation to construct the maps, not permission to skip them.

Huayan treatments of Indra's net, developed across Dushun, Zhiyan and Fazang,
use recursive reflection to articulate interpenetration: each jewel reflects
every other jewel, and each reflection contains the others again. Huayan accounts of
mutual identity and interpenetration belong to a soteriological and
metaphysical project formed through Indian Buddhist and Chinese traditions;
they are not waiting to be redescribed as a Western network diagram.[^huayan]
Yet the image asks a mathematical question we can honor precisely: can local
views contain enough transition structure that movement in one reorganizes
the routes among all the rest, without reducing the many jewels to one?

That is the natural machine at full scale. Every theorem is a jewel and a
path. Every proof records how reflections compose. Every counterexample marks
a missing facet. Every new language exposes distinctions the current atlas
cannot express. Every checked bridge changes the metric of the whole. The
interior becomes smaller because duplicated labor is compressed; the world
becomes larger because the saved energy reaches farther.

## What is being built

Not a final ontology. Not an agent wrapper. Not a dashboard that calls itself
alive. Not a claim that one formal system contains mathematics, science,
cognition or nature.

The work is to let a small number of exact operations close into a continuing
circuit:

```text
generate an object;
observe it through several task-bearing channels;
find the collision or invariant revealed by their interference;
prove the relation or the obstruction;
compile that result into a new executable capability;
let the new capability change the next generation.
```

The circuit writes itself only in this disciplined sense: checked mathematics
changes the program that will do the next mathematics. It cannot certify its
own trust boundary by declaration. A new verifier, objective or privacy policy
may be proposed from inside, but it must be judged from a previously fixed
world and installed as a visible change of world. History is never rewritten
to make the present look inevitable.

Optimality is likewise internal to a question. A geodesic needs a state space,
allowed moves, a destination or predicate, and costs. Proof length, CPU work,
memory, human attention, experimental risk, axioms and loss of optionality do
not collapse honestly into one universal fitness number. Keep the
nondominated paths. A new equivalence may bend the metric tomorrow.

There is no reason to expect the decisive next object to bear the name of the
problem that led to it. A prime-pair obstruction may expose a finite harmonic
transform. A language-theoretic quotient may become the right state space for
a physical controller. A failed transport may reveal a missing representation.
Hard open problems are not only trophies; they are instruments that trace the
shape of the present frontier.

The destination is a CPU-native engine whose growing body of mathematics makes
it progressively cheaper to recognize, construct and verify more mathematics;
a polyglot atlas that lets humans and machines act through the best available
channel without mistaking the channel for the world; and a research process in
which exactness increases creative freedom because every closed loop releases
attention for the next unknown.

Begin anywhere. Follow the maps honestly. Preserve what does not translate.
When deep structures recur, treat the recurrence as a proposal until explicit
maps, transports or obstructions make it evidence. When the maps are real, a
path begun in arithmetic can pass through language, physics,
perception and back into arithmetic carrying something none of them possessed
alone.

That is philosophy as an action rather than a subject: knowledge loving,
testing, transforming and realizing knowledge through us.

---

## Foundations beneath the picture

[^lawvere]: Richard Dedekind, *Was sind und was sollen die Zahlen?* (1888);
    F. W. Lawvere, “An Elementary Theory of the Category of Sets” (1964), for
    the categorical characterization of the natural numbers; the Peano axioms
    for the familiar first-order presentation.

[^recursion]: Lambek's lemma for initial algebras; Meijer, Fokkinga and
    Paterson, “Functional Programming with Bananas, Lenses, Envelopes and
    Barbed Wire” (1991), for folds, unfolds and hylomorphisms; Rutten,
    “Universal Coalgebra” (2000), for coalgebraic behavior.

[^myhill]: J. Myhill, “Finite Automata and the Representation of Events”
    (1957); A. Nerode, “Linear Automaton Transformations” (1958). Brzozowski
    derivatives give an executable route from a regular expression to its
    residual languages.

[^indianlogic]: Pāṇini, *Aṣṭādhyāyī*, especially the technical use of
    *it*-markers, operational domains and rule inheritance; Dignāga,
    *Pramāṇasamuccaya* and *Hetucakra*; Dharmakīrti, *Pramāṇavārttika* and
    *Nyāyabindu*. See George Cardona, *Pāṇini: A Survey of Research* (1976),
    and the [Stanford Encyclopedia survey of classical Indian
    logic](https://plato.stanford.edu/entries/logic-india/) and its entry on
    [Dharmakīrti](https://plato.stanford.edu/entries/dharmakiirti/). The history
    of formal reasoning is not a relay beginning in Greece and ending in
    modern Europe; what survives in global curricula also reflects translation,
    colonial institutions and selective canon formation.

[^nagarjuna]: Nāgārjuna, *Mūlamadhyamakakārikā* 1.1 and chapter 25; Mark
    Siderits and Shōryū Katsura, trans., *Nāgārjuna's Middle Way* (2013); the
    distinct reconstruction in Jan Westerhoff, *Nāgārjuna's Madhyamaka* (2009);
    and the
    [Stanford Encyclopedia entry on Nāgārjuna](https://plato.stanford.edu/archives/spr2020/entries/nagarjuna/).

[^jain]: The Jain doctrines of *anekāntavāda* (many-sidedness), *naya*
    (standpoint) and *syādvāda* (conditioned predication), classically developed
    by figures including Kundakunda, Samantabhadra, Siddhasena and Malliṣeṇa.
    They should not be reduced to modern probabilistic uncertainty or a generic
    “many perspectives” slogan. See Samantabhadra's *Āptamīmāṃsā*, Malliṣeṇa's
    *Syādvādamañjarī*, and Piotr Balcerowicz, *Jainism and the Definition of
    Religion* (2009), for the wider doctrinal setting.

[^stern]: Euclid, *Elements*, Book VII, for the Euclidean algorithm;
    Stern's diatomic sequence (1858), the Stern–Brocot tree, and the
    Calkin–Wilf tree for canonical enumeration of positive rationals. The full
    rational circle uses the projective line `P^1(Q)`, not positive rationals
    alone.

[^unison]: The [Unison content-addressing
    design](https://www.unison-lang.org/docs/language-reference/hashes/)
    hashes syntax trees and their transitive dependencies rather than source
    file locations.

[^hott]: The Univalent Foundations Program, *Homotopy Type Theory: Univalent
    Foundations of Mathematics* (2013), especially chapters 2, 4, 9 and 10;
    Bezem, Coquand and Huber, “A Model of Type Theory in Cubical Sets” (2014);
    the [Cubical Agda documentation](https://agda.readthedocs.io/en/latest/language/cubical.html).

[^egg]: Willsey et al., [“egg: Fast and Extensible Equality
    Saturation”](https://arxiv.org/abs/2004.03082) (POPL 2021). Equality
    saturation and homotopy type theory solve different identity problems.

[^rewriting]: Church and Rosser (1936), Newman (1942), and critical-pair
    methods for exact rewriting results; Yves Lafont, “Interaction Nets”
    (1990). Stephen Wolfram's Physics Project should be read separately as a
    research program proposing causal invariance, branchial space and rulial
    space, not as a theorem established by the classical confluence results.

[^hri]: Anca Dragan, Kenton Lee and Siddhartha Srinivasa,
    [“Legibility and Predictability of Robot
    Motion”](https://personalrobotics.cs.washington.edu/publications/dragan2013legibility.pdf)
    (2013); Hadfield-Menell et al., [“Cooperative Inverse Reinforcement
    Learning”](https://arxiv.org/abs/1606.03137) (2016); Hadfield-Menell et al.,
    [“Inverse Reward Design”](https://arxiv.org/abs/1711.02827) (2017).

[^landauer]: Rolf Landauer, “Irreversibility and Heat Generation in the
    Computing Process” (1961); Wolpert et al., [“The Stochastic Thermodynamics
    of Computation”](https://doi.org/10.1038/s42254-021-00400-8) (2022), for the
    modern scope and qualifications.

[^huayan]: Fazang, *Essay on the Golden Lion*; the Huayan doctrines of mutual
    identity and interpenetration as surveyed in the [Stanford Encyclopedia
    entry on Huayan Buddhism](https://plato.stanford.edu/entries/buddhism-huayan/).
    The *Golden Lion* is a distinct demonstration, not the textual source of
    Indra's net. The familiar jeweled-net image has a complex textual history; its value
    here is not a claim of historical identity with graph theory.
