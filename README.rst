==============================================================================
 THE METACIRCULAR KERNEL
 a self-rewriting computer, machine-checked in cubical Agda
==============================================================================

  A calculus where a proof is data, not a story about data. A theorem the
  system proves becomes an operation the system can run::

      install : Derivation lhs rhs -> NativeOperation

  Around that one line: a kernel that cannot forge a capability, cannot be
  taught a falsehood, and provably cannot generalise past what you show it
  next. And one fibre law -- stated once, checked once -- that kills a
  specific, named, informally-believed claim in seven different fields.

  Nothing here asks to be believed. Every sentence below is a term a
  typechecker accepts or refuses.

------------------------------------------------------------------------------

RUN THIS FIRST. DO NOT READ FURTHER UNTIL IT EXITS 0.
------------------------------------------------------------------------------

::

    sh setup      # installs Agda 2.8.0 + agda/cubical v0.9, from nothing
    sh check      # typechecks the kernel, names its toolchain, refuses to
                  # report green off the pin

If you have not run ``sh setup``, you do not have the toolchain this
repository is checked against, and nothing you read below is something you
can verify. Go run it.

------------------------------------------------------------------------------

THE ONE FACT
------------------------------------------------------------------------------

For any function ``f`` and any equation ``f a == b``, there are two things
you could hold fixed and ask about the other side.

Fix the output. The space of witnesses is a ``singl`` -- always
contractible, for every ``f``, no hypothesis needed. Publishing a result is
free.

Fix the input instead. The space is now ``fiber f b``, and it is
contractible **exactly when ``f`` is an equivalence**. Recovering an input
from an output is free if and only if the function is invertible.

That is the entire law. Two lines decide it, in ``fibre/Carrier.agda``::

    fibre a = singl (f a)
    fibre-isContr a = isContrSingl (f a)

Every
result below is that law, instantiated against a specific field's specific
folklore, checked, not argued.

------------------------------------------------------------------------------

WHAT IT KILLS
------------------------------------------------------------------------------

**Cryptography.** "Hardness assumption" is usually a name, not a
mathematical object. We make it one: a hardness assumption is a claim that
one named fibre is not contractible. For one explicit modular power map we
assume the fibre IS contractible, *construct* the resulting inverter,
*prove* it inverts, and show that inverter recovers a discrete log. The
assumption and the non-contractibility are now interderivable, not
analogous. Consequence, stated as a rule: a security claim that never names
its fibre has not stated an assumption.

**Distributed systems.** Byzantine safety, CRDT convergence, and consensus
are normally three expensive mechanisms. Here they are one type. An
operation cannot be constructed without the derivation that licenses it, so
an unauthorised operation is not rejected -- it does not exist. Merge is
concatenation: grow-only, idempotent, no vector clocks, no quorum, no
leader. And validity of a transition lands in a subsingleton, so two
replicas cannot hold different opinions about what happened -- a vote
ranges over nothing. Consensus is not achieved here. It is vacuous.

**Database provenance.** The standard hope is that lineage can be
reconstructed after the fact from an answer plus the rule set. We prove it
cannot be, for any rule set, any query, any amount of retained metadata: no
function of the answer recovers which derivation produced it. And the
field's cost model is backwards -- the full lineage chain costs no more to
transport than one link of it, while a boolean summary is provably
incapable of carrying the same information. The trail is cheap. The
summary is the expensive object.

**Concurrency theory.** Reversible process calculi normally bolt backward
motion onto a memory stack and then prove causal consistency as a theorem
about that bookkeeping. Here reversal is a constructor of the step relation
itself, so causal consistency is definitional. And branching structure --
the reason bisimulation has to be finer than trace equivalence, argued
about for forty years -- is computed rather than asserted: it is exactly
the fibre of the map from computations into a discrete observation, no
distinguishing formula required.

**Proof theory.** Two competing answers exist for "when are two proofs the
same": same normal form, or same natural transformation. Make reversal a
constructor and the first has no referent -- there is no normal form to
compare. The second turns out to be exactly propositional truncation of the
derivation type. A rule is general exactly to the extent that its
derivation has been thrown away; a universe level is the receipt.

**Machine learning / agent architectures.** "Memorisation" and
"generalisation" are treated as one dial, traded off by capacity. They are
not a dial. They are two different fields in a record. The form that
generalises carries no trace and costs nothing -- a substitution lemma
already discharges it. The form that can be installed into a library,
merged, or retired must carry its trace, because that is what makes it
unforgeable. The skill that fires everywhere cannot be shared. The skill
that can be shared fires at exactly one point.

**Compilers.** Phase ordering and e-graph extraction are treated as two
problems from two different eras of optimiser research. They are the same
quotient, read from opposite sides. The directedness that causes phase
ordering is exactly the structure whose removal makes extraction
unrecoverable from semantics alone. No engineering removes both at once,
and that is now a theorem, not a war story.

Each of the above is a separate checked module. No functor is constructed
between them, and none is claimed: what is exhibited is that the same
two-line fact answers all seven, not that they are secretly one
theorem. See ``abstracts/`` for the full statement of each, one file per
result, written for that field's reader.

------------------------------------------------------------------------------

THE KERNEL ITSELF
------------------------------------------------------------------------------

``formal/cubical/kernel/`` -- 296 lines across three files. Nine term
constructors: ``zero``, ``suc``, ``add``, and six variable coordinates held
deliberately distinct so a theorem cannot be secretly about the diagonal.
Six rewrite steps, and ``reverse`` as a constructor rather than a derived
fact --
which is what turns the derivation space into a groupoid instead of a
reduction order, and is why there is no normal form, no confluence
question, and no completion procedure to run.

Then the line that closes the loop::

    install : Derivation lhs rhs -> NativeOperation

A checked proof becomes an executable move. A long line of experiments
tried to make that loop generate mathematics on its own, forever. It
doesn't, and the reason is checked, not observed:

1. **An installed operation fires at exactly one term, no matter what
   evidence type its author invents for it.** Generalisation would require
   a different field entirely -- carrying a substitution witness instead
   of a fixed source -- and that field cannot also carry the unforgeability
   the first one buys you. You get one or the other. Never both from the
   same record.

2. **Meaning is a proposition; the route to it is not.** Soundness lands
   in an identity on natural numbers, a set, so it factors through
   propositional truncation of the derivation type. Two derivations of one
   fact -- one two steps, one four -- have equal meaning by *any* function
   of that meaning, at *any* type, at *any* universe level. No semantic
   criterion picks the short proof. Selection has to come from outside.

3. **Branch multiplicity is conserved.** The kernel's own advance step
   never deduplicates, sorts, or quotients its offered futures. That is
   not an omission -- it is the one place the information the semantics
   destroys is still held open for something outside the kernel to choose
   among.

4. **A commutation the counting semantics cannot see is a nontrivial loop
   in the universe.** Re-read the calculus into types instead of numbers
   -- every step becomes an equivalence, ``reverse`` becomes inversion --
   and the swap that was invisible to ``eval`` computes, through
   univalence's own beta rule, to order exactly two. Not a braid
   generator: disjoint union's symmetry is an involution by construction.
   Commutativity of addition is a ℤ/2 of holonomy, and every readout
   valued in a set annihilates it. If ``install`` is a learned policy,
   then a policy scored by a numerical readout provably cannot represent
   *which arrangement* produced the number -- and an architecture's
   invariance is exactly its blindness, paid at a measurable rate of one
   ℤ/2 per symmetry it is built not to see.

You can hold a session yourself::

    sh interactive/run-yantra.sh --wire
    {"kriya":"vargaprakrti","angani":{"D":61}}

which returns ``x^2 - 61*y^2 = 1`` at ``(1766319049, 226153980)`` --
Bhaskara II's own solution, Bijaganita, 1150 -- computed live through
Brahmagupta's composition law and the cakravala cycle, not looked up.

------------------------------------------------------------------------------

BEYOND THE KERNEL
------------------------------------------------------------------------------

**A second, independent lane in Lean 4 / Mathlib**, ``formal/lean/Pairfield/``.
Different prover, different library, same discipline: one theorem proved
four ways at increasing generality -- a sequence is determined by its
additive convolution square (``a*a = b*b => a = b``), over natural-number
polynomials, over the literal finitely-supported Goldbach-marginal
statement, over any ordered ring with nonnegative coefficients, and over
the reals. The axiom ledger is one line: a single ``native_decide`` use,
kept because two different tactics were independently measured to time out
or exhaust memory on the alternative, with the exact wall-clock numbers and
the exact fix that would remove it recorded next to the exception. Every
other declaration in the lane rests on nothing but ``propext``,
``Classical.choice``, and ``Quot.sound``.

**Historical mathematics, cited or not at all.** Panini's rule-conflict
principle, Aryabhata's pulveriser, Bhaskara II's cyclic method,
Pingala-Virahanka-Narayana's combinatorics -- formalised where a
construction is traceable to a primary source, and the source is checked
against the text, not against a secondary paraphrase. Where a claim about
provenance turned out to be wrong, it stays in the file, corrected in
place, because deleting it would be how a claim like that gets made again
by someone who didn't see the correction. Nothing mathematical below
depends on any of these sources being read.

------------------------------------------------------------------------------

WHAT IS NOT CLAIMED
------------------------------------------------------------------------------

Not that the seven field-results are instances of one formal theorem. They
are not: their types differ, and no functor between them is constructed.
What is exhibited is that one short fact answers all seven when read
correctly, not that they collapse into a single statement.

Not that any historical mathematician stated, anticipated, or would
recognise the modern reading given to their construction.

Not that a machine-learning reading, a physics reading, or a
distributed-systems reading is a theorem about any deployed system. Each
is a theorem about a specific type; that a real system is an instance of
that type is an interpretation, stated as one every time it is made.

What IS claimed: every named result above is a checked term, imported by a
module that stops compiling the moment the claim above it stops being
true.

------------------------------------------------------------------------------

MAP
------------------------------------------------------------------------------

============================  ================================================
``fibre/``                    the one primitive: the fibre law, two lines
``formal/cubical/kernel/``    the 296-line calculus, ``install``, and why it
                               does not generate forever
``formal/cubical/theorems/``  ~1100 modules across sixteen domains: number
                               theory, physics, logic, grammar, cost, and more
``formal/lean/Pairfield/``    the independent Lean/Mathlib lane
``interactive/``               a Haskell daemon: turn the kernel over a JSON
                               wire, live
``abstracts/``                 one field-targeted write-up per killed belief
============================  ================================================
