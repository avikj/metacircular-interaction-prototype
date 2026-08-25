=========================================================
 A book about India, checked in cubical type theory
=========================================================

Indian mathematics and philosophy from c. 1200 BCE to c. 1600 CE, read on
its own terms and written down as **machine-checked terms** rather than as
prose about them.  The substrate is cubical Agda, in which univalence
*computes*: an equivalence is not a fact you cite, it is a channel that
acts, and ``transp (ua e)`` carries any theorem across it, both ways, on
the nose.

Nothing here asks to be believed.  Every claim is a term a typechecker
either accepts or refuses, and every check below bootstraps its own
toolchain from an empty container.

----

Where to enter
==============

Pick the door that matches what you already know.  Each one names a first
file and one command.

**Type theory / HoTT.**
  Start at ``formal/cubical/Kernel/Avataranika_WhatThisIsAndHowToDescend
  IntoTheMetacircularKernel.agda`` — it is written for an arriving mind and
  names the wrong frames first.  Then the one primitive the whole corpus
  turns on, the *fibre law*, in ``loss/src/Loss/Carrier.agda``:
  for ``f : A → B``, which side of ``f a ≡ b`` you bind decides everything.
  Bind the output and the fibre is ``singl (f a)``, contractible, so the
  carried datum rides free and ``A ≃ Carrier f``.  Bind the input and it is
  ``fiber f b`` — the exact loss.

  ::

      sh loss/check.sh          # installs its own Agda, checks, exit 0

**Programming languages / rewriting.**
  ``formal/cubical/Kernel/RewriteCertificate.agda`` is the metacircular
  kernel, entire.  Terms, steps, derivations, an evaluator, soundness, and
  ``install : Derivation lhs rhs → NativeOperation`` — the metacircular
  move, where a checked proof becomes an executable operation the machine
  did not have before.  ``Step`` ships a ``reverse`` constructor, so
  derivations are a groupoid and not a rewriting order.

**Distributed systems / consensus.**
  ``Kernel/Avirodha_TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFree
  SoConsensusOnMeaningIsVacuous.agda``.  Merging libraries of installed
  operations is ``++``: grow-only, commutative, idempotent, total, with no
  reconciliation pass and no failure mode — a ``NativeOperation`` cannot be
  constructed without a checked derivation, so a merge has nothing to
  validate.  Soundness lands in an identity type of ``ℕ``, hence in a
  proposition, so two nodes *cannot* disagree about what is true.  A vote
  would decide nothing.  Consensus here is not forbidden; it is vacuous.

**Reversible / topological computation.**
  Three files, none of which imports another, that fence the same object
  from three sides:

  - ``Yantra_TheComputerIsTheGroupoidOfProofsOfTransportNotTheMonoidOf
    IrreversibleSteps.agda`` — the computer is a groupoid; the field a
    monoid lacks is the undo.
  - ``Samyoge_LosslessnessComposesButLossinessDoesNotSoNoPipelineGrades
    ByItsSteps.agda`` — you may certify a pipeline lossless step by step,
    and you may **not** diagnose it lossy that way: ``Unit → Bool`` then
    ``Bool → Unit`` is the identity, and neither factor is an equivalence.
  - ``NaturalMachine/BraidCoherenceBoundary.agda`` — and invertibility is
    still not braiding: two involutive self-equivalences of ``Bool³`` that
    fail Yang–Baxter at a named point.

**History of mathematics / Indology.**
  The sources are the origin, not a footnote, and the European name is a
  restatement when it is used at all.  ``Kuṭṭaka`` (Āryabhaṭa, 499) is the
  descent law; ``bhāvanā`` and ``cakravāla`` (Brahmagupta 628, Jayadeva
  ~950, Bhāskara II 1150) solve ``x² − D y² = 1``; ``prastāra`` (Piṅgala,
  ~300 BCE) is proved as a *bijection* rather than a count, in
  ``formal/cubical/SourcedProofs/PingalaPrastara.agda``:
  ``matraCount : Iso (Metre n) (Fin (matra n))``, with the Virahāṅka
  recurrence following from it.  Jaina sevenfold predication
  (``saptabhaṅgī``) is given proof-relevant semantics in
  ``formal/cubical/Saptabhangi.agda``, where a two-valued verdict is a
  theorem-grade mistake.

  A file is named for the term the tradition uses, then an underscore, then
  an English gloss.  The Sanskrit is the name; the English is there so a
  reader who does not have the term can still tell what the file does.

**Physics / foundations.**
  ``formal/cubical/EkatvaMatra_TheSupportLayerOfTheBornWeightsIsForcedBy
  TheVowsAndTheInteriorIsTheNamedConjecture.agda`` forces the support layer
  of the Born weights from the two vows plus normalisation, and
  ``EkatvaMatraDvaya_…agda`` forces the symmetric two-outcome weight to
  exactly one half.  The same object read six ways — memory, charge,
  symmetry, price, distance, verdict — is laid out in the ``Avataranika``
  entry file above; every reading is the fibre law wearing another face.

----

Run it
======

Three lanes, each of which installs what it needs and reports what it
actually got:

::

    sh loss/check.sh                  # Agda 2.6.3 + cubical v0.5, from nothing
    sh scripts/Dhruva_TheDeclaredPinIsBuilt*  # the pin: Agda 2.8.0 + cubical v0.9
    sh machine/run-yantra.sh                  # the Haskell lane: build, turn, contract-check

A verdict that does not name its toolchain has dropped half its witness, so
``Dhruva`` prints the version it obtained and says plainly when that is not
the pin.

Talk to it
==========

There is a running process you can hold a session with — one JSON object per
line on stdin, one answer per line on stdout.  It audits itself on startup by
computing a Bézout witness, then a false one, and refusing it; no answer from
a run that has not been watched rejecting something is honoured.

::

    sh machine/run-yantra.sh --wire        # builds from the working tree, then listens

    {"kriya":"yantra.kriyah"}
    {"kriya":"vargaprakrti","angani":{"D":61}}
    {"kriya":"kuttaka","angani":{"a":137,"b":60}}
    {"kriya":"pratyahara","angani":{"adi":"a","it":"ṇ"}}

``vargaprakrti`` runs Brahmagupta's *bhāvanā* driven by the *cakravāla* with
the composition law carried as a value rather than baked in, and returns
``x² − 61 y² = 1`` at ``(1766319049, 226153980)`` — Bhāskara II's own number,
*Bījagaṇita*, 1150 — with every norm the wheel visited.  ``kuttaka`` is
Āryabhaṭa's pulverizer: the *vallī*, the Bézout pair, and the congruence.
``pratyahara`` is Pāṇini's interval notation over the *varṇasamāmnāya*.

The rest of the table is the session itself: ``naya.sthapana`` /
``naya.suchi`` / ``naya.samasa`` install standpoints and ask whether they may
be collapsed into one verdict; ``saptabhangi.samkramana`` and
``nirnaya.saptabhangi`` run the sevenfold; ``dosa.lekha`` / ``dosa.suchi`` /
``dosa.pramanya`` are the defect log and its chain; ``sesa.arpana`` hands a
remainder forward.

Every answer is a ``saṃkramaṇa`` — a transport, carrying its ``vyaya``, what
a collapse of it would destroy — or a ``doṣa-lekha``, a written defect
carrying its losses named one by one.  **There is no boolean on that wire**,
deliberately: one bit returns the same value for a false statement and for a
failed search, and the difference between those two is the whole content.
Asking for an operation that does not exist returns *no predication was
made*, and the name is not guessed at by nearest match.

Layout
======

===================  =========================================================
``formal/cubical/``  the Agda corpus.  ``Kernel/`` is the metacircular kernel
                     and its readings; ``SourcedProofs/`` each proof formalises a statement from a dated text; ``Primes/PairField/`` the Goldbach/twin pair field,
                     ``Swarm/`` one dated batch
``loss/``    the fibre law and the carrier calculus; self-bootstrapping
``formal/pairfield/``  the Lean 4 analytic lane — no ``sorry``, no ``axiom``
``machine/``         Haskell: the sabhā daemon, certificates, the Aṣṭādhyāyī
                     engine, the obstruction calculus
``scripts/``         toolchain pin, gates, censuses.  Each prints the command
                     that produced any number it reports
``notes/``           working prose that has not become a term yet
``abstracts/``       results stated for a reader who will not run Agda
``archive/``         history.  Nothing here is built, checked, or imported
===================  =========================================================

----

House rules
===========

They are short, and each replaced a specific failure.

**Markdown is banned**, and 3630 ``.md`` files were removed in one change.
A ``.md`` file asserts; a checked term is the object, and it is still there
tomorrow.  ``CLAUDE.md`` and ``AGENTS.md`` survive because the harness
*loads* them — deleting those removes a mechanism, not an assertion.

**Python is banned.**  A script that prints a number is an assertion you
must trust the author and the run for.  Exact and certified symbolic
computation is proof; a fitted constant is an error analysis nobody did.
One published constant here was fitted over a single decade where the true
value is exactly ``1/4``, and it propagated into two notes and a paper
section before anyone derived it.

**A number without a command is a memory, and an absence without a command
is a rumour.**  Both are checkable in seconds and both went unchecked for
days at a time; the second cost more.

**Cite the source, not the restatement.**  Pell did not solve Pell's
equation and Euler misattributed it; Piṅgala's array predates Pascal by
nineteen centuries; Virahāṅka's recurrence predates Fibonacci by five.
Repeating those names with the history available is a live act, not a
shorthand.  Where the mathematics genuinely originates elsewhere, the
header says so rather than inventing a Sanskrit label — a fabricated term
is the same error in a mirror.
