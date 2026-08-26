==============================================================================
 THE METACIRCULAR KERNEL
 a self-rewriting content-addressable computer, machine-checked in cubical Agda
==============================================================================

  A rewriting calculus whose derivations are reversible data rather than a
  reduction order; an evaluator; a soundness proof; and one line that closes
  the loop --- ``install : Derivation lhs rhs -> NativeOperation`` --- so a
  theorem the system proved becomes an operation the system can apply.

  Around it: a classification of the cost measures such a calculus admits, a
  criterion for what a verifier can and cannot learn from a proof, and five
  independent results in grammar, gauge theory, analytic number theory and
  distributed systems that turn out to state one fact about descent.

  Nothing here asks to be believed.  Every claim is a term a typechecker
  accepts or refuses::

      sh setup                     # installs the pinned toolchain, from nothing
      sh check                     # typechecks, and names the toolchain it used

  No postulates, no holes, ``--safe`` throughout.

  Historical sources --- Pāṇini's grammar, Indian algebra, and the classical
  logics whose judgment structures some modules formalise --- are cited where
  a construction came from one, and are kept in ``historical/``.  They are
  provenance, not premise: no result below depends on any of them being read.


THE PIN, AND WHY YOU WILL NEVER BE CONFUSED BY A VERSION AGAIN
------------------------------------------------------------------------------------------

  Agda 2.8.0 and agda/cubical v0.9.  Both numbers appear once, in `setup`,
  and everything else reads them from the two ``.agda-lib`` files it writes.

Version skew cost this project more time than any mathematical difficulty.
Lanes posted honest, reproducible, CONTRADICTORY verdicts about the same
files, because nothing recorded which container they ran in.  Three rules
end it, and none of them is a convention anyone has to remember:

**Every `depend:` names an exact version.**  ``depend: cubical-0.9``, never
``depend: cubical``.  agda/cubical puts its release into its own library
name, so the exact name is a hard resolution constraint: a wrong checkout
fails AT RESOLUTION, naming the library, instead of resolving and then
failing somewhere deep inside a proof where the cause is invisible.

**`sh check` names its toolchain before it checks anything, and refuses to
run off the pin.**  It prints the versions it found, and if they are not
the pin it stops and says so — so a red is never ambiguous between "the
mathematics is wrong" and "my machine is wrong."

**`sh setup` is the only thing that installs.**  It works from an empty
container: apt for ghc and cabal, cabal for Agda, git for the library.  It
knows the three obstacles that actually bite — cabal writes its config
lazily so a fresh machine has nothing to patch; the shipped index URL is
http and many proxies tunnel only https; hackage's mirrors answer 403 on
networks where hackage itself answers 200 — and it prints exactly what it
obtained either way.

  Measured 2026-08-25, and it is why this section exists: ``fibre/``, which
  holds the one primitive the whole corpus turns on, was pinned to cubical
  **v0.5** while everything else was built at **v0.9**.  It had been read as
  a mathematical fact — "a different lake", and the modules that wanted to
  cite the fibre law said so in prose "rather than pretending to a
  dependency it does not have."  It was not a fact.  It was a missing
  ``--guardedness`` flag.  With that one word added, every module in
  ``fibre/`` checks at the pin, exit 0, and the corpus can import its own
  foundation for the first time.


THE KERNEL, AND WHY IT DOES NOT GENERATE FOREVER
------------------------------------------------------------------------------------------

  formal/cubical/kernel/ — 296 lines in three files, and the entry is
  WhatThisIsAndHowToDescendIntoTheMetacircularKernel.agda,
  written for an arriving mind.  Sixteen modules, all green at the pin
  (Agda 2.8.0, agda/cubical v0.9), re-runnable::

      sh check

The calculus is six variable coordinates, zero, suc, add, and six rewrite
steps: the two defining equations of +, three congruences, and `reverse`.
`reverse` destroys the rewriting direction on purpose, so what remains is
not a reduction relation but a generated equivalence carried as data —
and `Derivation` imposes no relations, so two walks between the same
endpoints are two distinct objects.  Then one line closes the circle::

      install : Derivation lhs rhs → NativeOperation

A theorem the machine proved becomes a move the machine can make.

A long experiment tried to make that loop generate mathematics forever.
It does not, and the reason is not a missing feature.  Five properties,
each a checked term, say why — and each is why the thing can be trusted:

**1 · Every application carries its certificate to its site.**
`control-sound : Control t → t ≡ source` pins an OPEN field: the caller
supplies any predicate on terms it likes, and the operation still fires
only where the term IS the source.  A single-locus theorem proves the consequence in
one composite — however permissive the control, an operation has at most
ONE locus — and computes the installed locus type: contractible, centre
the source.  So capability grows by one term per theorem, never by a
class.  A schema is a claim about all its instances checked once,
abstractly, after which it fires everywhere unexamined; `apply-checked`
instead TRANSPORTS the certificate to the site.  *Cannot generalise* and
*cannot be wrong at a site* are one sentence read twice.

**2 · Meaning is a proposition; the route is not.**
`Sesa_` — `eval` lands in ℕ, a set, so soundness lands in a proposition,
so for ANY C at ANY level and ANY φ of the meaning, φ agrees on the
2-step and the 4-step derivation.  No semantic criterion selects the
short proof.  Selection is therefore extra-semantic, by theorem.  This is
why the machine cannot iterate on its own: the space is not unreachable,
it is UNDIRECTED, and direction has to arrive from an interlocutor.

**3 · Multiplicity is conserved.**
`advance-preserves-branch-count` — no dedupe, no sort, no quotient.  Read
with 2, this is not housekeeping: it is the only place the information
the semantics destroys is still held, the kernel holding branches open
for someone outside to choose among.

**4 · Reversibility is structural, not inferred.**
`reverse` is a constructor.  It has to be, because `Samyoge_` proves
losslessness composes and lossiness does not — `Unit → Bool → Unit` is
the identity with neither factor an equivalence — so you may certify a
pipeline lossless step by step and may NOT diagnose it lossy that way.

**5 · New content comes from changing the reading, and its yield is
finite and measurable.**
`Ankapasa_` keeps the calculus and changes the codomain: every Step
becomes an equivalence, `reverse` becomes `invEquiv`, and a commutation
invisible to `eval` is a nontrivial loop in the universe, through `uaβ`.
`VyatyasaVarga_` then measures that loop: order exactly two.  **ℤ/2** —
not a braid generator, because ⊎ is symmetric monoidal and its symmetry
is an involution by construction.

  So the negative result IS the asset.  A finite-information machine
  iterating on a fixed semantics has no criterion, and the criterion
  cannot be manufactured from what it knows.  What produces mathematics
  here is interaction — `Samvada_`: a session is one Derivation, hence
  one theorem, hence one installable operation, so the stock of moves is
  the transcript of the dialogue — and translation, which is §IV below,
  and whose yield you can measure.

  You can hold that session yourself::

      sh interactive/run-yantra.sh --wire
      {"kriya":"vargaprakrti","angani":{"D":61}}

  which returns x² − 61y² = 1 at (1766319049, 226153980) — Bhāskara II's
  own number, Bījagaṇita, 1150 — with every norm the cakravāla visited.
  Every answer is a transport carrying what a collapse of it would
  destroy, or a written defect naming its losses one by one.  There is no
  boolean on that wire: one bit returns the same value for a false
  statement and for a failed search, and the difference is the content.


THE SENTENCE
------------------------------------------------------------------------------------------

  A rule, an observer, a sieve, or a score is blind exactly to what its
  own collapse identifies.  The blindness is FORCED by the collapse — not
  chosen, not an approximation, not a resolution limit.  The invisible
  quantity is not small.  It is complementary.  And it is recoverable only
  by changing place, never by refining the instrument.

Five checked theorems say this.  They were written independently, about
five subjects, by hands that were not coordinating.  Two of them are
literally about one object.



I.  GENERATIVE GRAMMAR      rule ordering in Pāṇini, Aṣṭādhyāyī, c. 500 BCE
------------------------------------------------------------------------------------------

  8.2.1   पूर्वत्रासिद्धम्   from this sūtra to the end of the text, a rule is
          asiddha — "as if not having taken effect" — with respect to
          everything that precedes it.  The blindness is one-way, ordered,
          and stated as a rule of the grammar itself.

  the collapse    8.4.56 वाऽवसाने sends two forms that DISAGREE about
                  8.2.39's applicability to one and the same form.
  what goes blind that applicability.

A checked term proves there is no Bool-valued function on the later forms
agreeing with it.  Not a different answer there — NO VALUE THERE.

So asiddhatva is not a device against looping.  That is a separate
theorem, proved separately.  8.2.1 is a DESCENT CONDITION: it registers
that an earlier rule's condition is a function on a fibre which the later
rule's collapse destroys.  A second term exhibits the two points of that fibre,
so the fibre is not a figure of speech for the invisible part.  It is that
set.

  A predicate descends along a map iff it is constant on its fibres.
  8.4.56 has a two-point fibre on which 8.2.39's applicability is not
  constant.  Hence no descent — and the blindness is forced, not
  stipulated.



II.  GAUGE THEORY, LOOP QUANTUM GRAVITY
------------------------------------------------------------------------------------------

  the collapse    an observable invariant under the holonomy.
  what goes blind the holonomy — exactly, and in both directions.

invisibleExactlyWhenInvariant  —  a semantics is unmoved by transport
along ua h IFF it is invariant under h.  Invisibility and invariance are
not two facts about an observable.  They are one condition read from two
sides.  invisibleIsInvariantAsTypes upgrades it, when the value type is a
set, to an EQUIVALENCE of the two conditions.

And the converse cost nothing.  The reason outlives the theorem:

  the two sides are joined by uaβ, which is a PATH, and a path may be
  walked in either orientation.  One cycle earlier the same audit found a
  converse costing `Enumerated K` + `Discrete O`, because there the sides
  were joined by an implication assumed.

  A PATH HAS AN INVERSE.  AN IMPLICATION DOES NOT.

So "is the converse free?" has an answer readable off the shape of what
connects the two sides, before either direction is attempted.

The three physics modules together give the representation-independent
content of LQG kinematics, and it is four things:

  · edges are group actions;
  · vertices are intertwiners, and gauge invariance IS the equivariance
    square — not a constraint added on top of the label;
  · flux is a derivation, and subdivision-compatibility is FORCED by
    multiplicativity and Leibniz alone.  Orientation and intersection
    sign are chosen afterward and are not needed for it;
  · an observable is blind to holonomy exactly when it is gauge-invariant.

  For a physicist, one sentence: LQG kinematics is the category of actions
  of the gauge group.  SU(2), tensor products and the Hilbert space are
  representation-theoretic choices made after the structure is fixed, and
  the entire physical residue — what no gauge-invariant observable can see
  — is holonomy, exactly and measurably.



III.  ANALYTIC NUMBER THEORY     the parity barrier, with no sieve in it
------------------------------------------------------------------------------------------

  the collapse    idempotence.
  what goes blind sign.

The general reason needs no arithmetic at all:

  KNOWING SOMETHING TWICE IS KNOWING IT ONCE.

Any state law that ACCUMULATES — observations, constraints, standpoints,
congruences, installed primes — is idempotent, because combining a datum
with itself adds nothing.  lcm is idempotent for that reason, and not for
a reason about divisibility.

sign-is-not-accumulable  —  there is no accumulative law and no
multiplicative f into ℤ taking the value −1.  Ever.  Not "hard to
accumulate."  Over ℤ the units are ±1, so this rules out λ everywhere and
μ off the squares, FOR EVERY ACCUMULATIVE LAW AT ONCE, with no domain
hypothesis.

  The parity barrier is not a limitation of sieve technology.  Whatever
  carries sign, it is not accumulation.  Accumulation and cancellation are
  incompatible, exactly.

And the companion, from the other end of the same arithmetic: the product
formula splits into an arithmetic half and an accounting half, and the
accounting half needs no primes, no unique factorisation, no absolute
values, and no real numbers.  Leave the weights abstract and it holds for
any exponents whatsoever.  Its content:

  a defect at one place is not an absolute loss.  It is compensated, and
  the compensating term lives at a place the local method cannot see.



IV.  THE KERNEL'S SEMANTICS      and the statement about reward
------------------------------------------------------------------------------------------

अङ्कपाश, aṅkapāśa, "the net of digits", is Bhāskara II's Līlāvatī section
on permutations (~1150): the ARRANGEMENT, as against the count of
arrangements.  No verse number — editions differ in their numbering there.

  the collapse    eval : Tm → Env → ℕ, a readout into a set.
  what goes blind a transposition.  One ℤ/2 of holonomy.

no-counting-criterion-separates  —  for ANY type C at ANY level and ANY
function φ of the counting meaning, φ cannot distinguish performing the
commutation from doing nothing.  Universally quantified over every
possible readout, not over the ones anyone has tried.

comm-loop-is-a-nontrivial-loop-in-the-universe  —  and the categorified
semantics DOES see it.  The path is not refl, proved through uaβ, which is
univalence's β-rule COMPUTING.  Calculated, not asserted.

Commutativity of addition is not free information.  It is a ℤ/2 of
holonomy, and every readout valued in a set annihilates it.

  THE MACHINE-LEARNING FORM.  `install` makes a proved theorem a
  next-move, so an operation library is a learned policy.  A policy scored
  by any function of a numerical readout provably cannot represent WHICH
  ARRANGEMENT produced the number.  Order information is not an
  inefficiency of a bag-of-counts score.  It is provably absent from it.

  And with II: an architecture's invariance is exactly its blindness.  A
  model invariant under a symmetry cannot represent that symmetry's
  holonomy.  Inductive bias is not free capacity — it is paid for at a
  measurable rate, one ℤ/2 per independent loop.



V.  THE KERNEL AS A DISTRIBUTED SYSTEM    the same law, as a capability
------------------------------------------------------------------------------------------

  the collapse    derivation-sound lands in an identity type of ℕ, and ℕ
                  is a set, so that type is a PROPOSITION.
  what goes blind which route was taken.

two-nodes-cannot-disagree  —  any two derivations between the same terms
have EQUAL meanings.  Not compatible.  Not both acceptable.  Equal, as
terms.  A consensus protocol over meaning would range over a proposition,
and a proposition has no second position to elect.

  CONSENSUS ON MEANING IS NOT FORBIDDEN HERE.  IT IS VACUOUS.

merge-is-idempotent  —  the library join is grow-only, commutative and
idempotent, with no failure mode.  `merge` has no Maybe, no validity
precondition, no error, because a NativeOperation cannot be constructed
without a checked derivation.  A merge has nothing to validate.  Validity
is local to the operation and travels with it.

And what genuinely differs is kept: routes-genuinely-differ exhibits two
derivations of one fact with equal meanings and lengths 2 and 4, neither
wrong, and advance-preserves-branch-count is the rule that both survive
the merge.  A fork is not a disagreement awaiting a verdict.  It is two
carriers of one fact.


READ WITH III, THIS IS ONE OBJECT AND NOT AN ANALOGY.  The library merge
is an accumulative law in exactly SignIsNotAccumulable's sense.  So the
parity barrier applies to it verbatim:

  A CRDT CANNOT CARRY SIGN.

The sieve's blindness and the replicated library's freedom from conflict
are one idempotence, priced once as a loss and once as a guarantee.


AND THE PRIMITIVE UNDERNEATH IS PAIRWISE.  Not a sixth independent witness:
it was written after the five, on top of §V's own machinery, and it is here
because it is the same object one level down.  `TheEncounterOfTwoPeers…`
supplies the transition the `Session` above only ever had one side of::

      (state_A , state_B)  -->  (state'_A , state'_B , tau)

  a total function -- no protocol, no third party, no authoritative copy.
  Each state is a peer's own, and neither peer needs the other's history or
  any completeness of its own.  `tau` is one object in five roles at once:
  execution, provenance, proof, transport, and program.

  the collapse    a number.  Any additive summary of an interaction.
  what goes blind which of two independent interactions came first.

`the-scalar-is-additive` says the cost of a composite encounter is the sum
of the costs of its parts.  That additivity is exactly what hands both
orders of two independent encounters the same number -- and
`the-two-orders-differ` is a term, so the two orders are two objects.
Hence `no-section-for-any-order-blind-projection`: for ANY projection at ANY
level that the crossing does not move, the type of its sections is EMPTY.
`len` is one.  Every function of the meaning is another.

  TRACE -> SCORE IS A FUNCTION.  SCORE -> TRACE IS NOT A HARD PROBLEM.
  IT IS AN EMPTY TYPE.

This is not `cost-does-not-factor` restated.  `len` is NOT a function of the
meaning and it DOES separate direct from detour; it is still not invertible,
because two independent encounters commute.  The blindness is not the
semantics'.  It is the SCALAR'S, and it survives every refinement that stays
scalar.

Four more terms in the same file, because a two-party primitive is worth
little without them: the two peers end at PROVABLY DISTINCT terms with
nothing pending (§4 above is about meaning; position is the part an
agreement protocol exists for, and this transition does not need one);
revelation and generation are separated, with a before-state in which the
enabling type is bottom rather than merely unproved; conservativity is three
obligations discharged separately -- the prior trace survives as a syntactic
PREFIX, the prior position is recoverable because `reverse` is a
constructor, and the prior library still enables everything it enabled; and
losslessness is not unchangedness, the round trip's meaning being `refl`
while the round trip is not `done`.


AND WHAT THE OTHER PARTY LEARNS HAS A PRICE, WHICH IS `isProp`.
------------------------------------------------------------------------------------------

  the collapse    a view that is a proposition.
  what goes blind which witness produced it -- all of it.

This corpus proves the structural content of zero-knowledge in five places
and never uses the phrase, so a search for the phrase finds nothing and
concludes, wrongly, that the mathematics is absent.  That is the durnaya of
§I read as a research method, and the correction is a theorem.

`TheHidingIsTheFibre…` puts the two readings of one fibre side by side:

**Perfect simulation costs `isProp` on the view and nothing else.**  The
simulator holds the statement and emits the statement; the honest transcript
and the simulated one are EQUAL, as terms, for every witness -- not
indistinguishable to a bounded distinguisher.  One line.

**And the view shrinks the witness space by nothing.**  `fiber view v` is
equivalent to the whole witness type.  A verifier that has seen everything
it will ever see has not eliminated one candidate.  That is where the word
ZERO is earned, and it is a strictly stronger statement than the first.

**Extraction is exactly uniqueness, both ways.**  If the view inverts, the
witness was unique -- an extractor is not a procedure that was missing, its
existence retroactively collapses the witness space to a point.  Conversely
an extractor exists when the statement entails a witness AND the witness is
unique.  Both hypotheses are named because both are needed.

  SO TWO DISTINCT WITNESSES FORBID EXTRACTION.  Not make it expensive --
  forbid, with the extractor type empty and no complexity assumption
  anywhere in the argument.  Hiding is that fibre being everything;
  hardness is that same fibre failing to be a point.  ONE OBJECT, TWO
  READINGS.

Both halves are then discharged at the kernel with no assumption: `sound` is
a perfect-hiding view because `eval` lands in a set, and at the kernel's own
seed extraction is impossible because two routes there are a term.

What this is NOT is the whole of a proof system, and the file's NOT CLAIMED
list is long on purpose: no complexity, no probability, no polynomial-time
simulator, and no soundness against a cheating prover -- the statement type
being inhabited does not entail a witness, which is why the extraction
converse takes that entailment as a hypothesis.  The hardness reading is a
reading of the fibre; the one DEPLOYED assumption is instantiated in
`Bijamula`/§05, at modular exponentiation, and not here.



WHAT IS NOT CLAIMED
------------------------------------------------------------------------------------------

Not that the five are instances of one formal statement.  They are not:
their types differ, their ambient structures differ, and no functor
between them is constructed.  What is exhibited is that each is the same
SENTENCE, and that III and V are literally about one object.  A common
generalisation would be a real theorem and it is not proved.

Not that Pāṇini or Bhāskara II proved, stated or anticipated any of this.
§I quotes sūtras of the Aṣṭādhyāyī; the fibre reading is not Pāṇini's.

Not anything about physical spacetime, quantum states, Hilbert spaces or
SU(2).  §II is about a semantics and an equivalence.

Not that §IV's machine-learning reading is a theorem about any deployed
system.  The theorem is about functions of a count-valued semantics; that
a reward model is such a function is an interpretation, stated as one.

What IS claimed: the named terms exist, are checked, say what is written
above them, and are imported by one Agda module — so that module stops
compiling the moment any of them stops being true.
