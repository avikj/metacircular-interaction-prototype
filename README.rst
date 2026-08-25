====================================================================
 फलक · PHALAKA — the fibre law, and the machine you can turn
====================================================================

  Indian mathematics and philosophy, c. 1200 BCE to c. 1600 CE, read on its
  own terms and written as machine-checked terms rather than prose about
  them.  The substrate is cubical Agda, in which univalence computes.  One
  sentence runs through the whole thing, and you can either run it or check
  it.  Do that first; read second.


TALK TO THE MACHINE
------------------------------------------------------------------------------------------

  The machine is meant to be turned, not described.  One command::

      sh interactive/run-yantra.sh            # the scripted session, contract checked
      sh interactive/run-yantra.sh --wire     # JSON lines on stdin/stdout — for a person or an LLM

  On the wire you hand it a request and it hands back a transport::

      {"kriya":"vargaprakrti","angani":{"D":61}}

  returns x² − 61y² = 1 at (1766319049, 226153980) — Bhāskara II's own
  number, *Bījagaṇita*, 1150 — with every norm the cakravāla visited on the
  way.  There is no boolean on that wire.  One bit would return the same
  value for a false statement and for a failed search, and the difference
  between those is exactly the content, so the machine never collapses to
  one: every answer is either a **saṃkramaṇa** (a transport carrying what a
  collapse of it would destroy — an object, an exhibited identification, and
  a stated cost) or a **doṣa-lekha** (a written defect naming its losses one
  by one).  There is no third road.

  And the whole development, bootstrapping its own toolchain, checked end to
  end::

      sh fibre/check.sh            # installs its own Agda + cubical, checks, exit 0

  The checked front doors are terms, not pages, and they re-export the
  load-bearing theorems, so each typechecks only if every one of its imports
  still does — rename, weaken, or break a theorem and the door goes red:

  · ``theorems/residue/Ekavakyata_FiveCollapses…`` — the one sentence in its
    five founding lanes (grammar, gauge, the parity barrier, the kernel's
    counting, the distributed library).
  · ``theorems/Pravesa_…`` — the frontier reading: the cryptographic receipt,
    the optical-quantum device, the bridge into the holonomy lane.

  They are the authority; this page is the reading.


THE ONE SENTENCE
------------------------------------------------------------------------------------------

  A rule, an observer, a sieve, a score, a gate — anything that COLLAPSES —
  is blind exactly to the fibre its collapse identifies.  The blindness is
  FORCED by the collapse, not chosen, not a resolution limit.  The invisible
  quantity is not small; it is complementary, and it is recoverable only by
  changing place, never by refining the instrument.

  A predicate descends along a map iff it is constant on the map's fibres.
  Everything below is that fact, wearing the clothes of a different subject.
  The fibre is not a figure of speech for "the part left out": it is a set,
  and where a lane matters, the two points of it are exhibited.


IT IS IN EVERY LANE
------------------------------------------------------------------------------------------

  Not five lanes — the fibre-law signature runs through ~560 of the ~1150
  checked modules, in every domain but the deliberate falsehoods.  Each is
  the same sentence; none is reduced to the others, and no functor between
  them is claimed.

  · **grammar** — Pāṇini's *asiddhatva* (Aṣṭādhyāyī 8.2.1): a later rule's
    collapse has a two-point fibre on which an earlier rule's condition is
    not constant, so no Bool-valued verdict descends — no value there.
  · **physics** — LQG / gauge holonomy: an observable is blind to holonomy
    exactly when it is gauge-invariant, joined by ``uaβ`` (a path, so the
    converse is free).  And the optical reading of it — orbs, total internal
    reflection as losslessness, the whispering-gallery winding = the circuit
    holonomy, the net's braiding = the lane's own non-abelian holonomy, now a
    braid-group representation.
  · **number** — the parity barrier: sign is not accumulable, because
    accumulation is idempotent and cancellation is not, for EVERY accumulative
    law at once.  Discrete log is the fibre of Piṅgala's power map.
  · **residue** — the kernel as a distributed system: two derivations of one
    fact have equal meanings (ℕ is a set), so consensus on meaning is vacuous;
    the library merge is a CRDT, and by the same idempotence it cannot carry
    sign.  What differs is the route, and the route is kept.
  · **metre** — Piṅgala and Virahāṅka: the Fibonacci-anyon fusion dimension
    is Virahāṅka's mātrā-metre count, the mātrāmeru enumerated c. 700 CE.
  · **logic, walks, automata, cost, historical_proofs, lattices, primes,
    order, homotopy** — Galois connections as two mutually-adjoint nayas,
    walk/path counts, cost surfaces a scheduler is blind to, and the Sanskrit
    sources read directly as fibre statements.

  THE READING, MARKED AS READING.  The fibre law is the object classifier:
  in a univalent universe a *form over a base* — any family ``B : A → Type``
  — is a map ``A → 𝒰``, and ``Σ A B`` is its total space, so one object
  classifies every fibration there is.  The universe of physics is itself a
  fibration — base spacetime, a connection, matter as sections, the residue
  holonomy.  And iterating the one operation (suspension / pushout / the
  cell) climbs S⁰ → S¹ → S² → … and, in towers, reaches every shape:
  arbitrary form is iterated fibre construction, and univalence makes the
  iteration compute.  None of that last paragraph is a single checked
  theorem here; it is why the sentence recurs, offered for orientation.


WHAT IS NOT CLAIMED
------------------------------------------------------------------------------------------

  Not that the lanes are instances of one formal statement — their types and
  ambient structures differ and no functor between them is built.  What is
  exhibited is that each is the same SENTENCE.

  Not that Pāṇini, Bhāskara II, Piṅgala, Virahāṅka, Jaimini or any Mīmāṃsaka
  proved, stated, or anticipated the fibre reading.  Sūtras are quoted; the
  reading is not theirs, and no provenance is fabricated.

  Not anything about physical spacetime, quantum states, Hilbert spaces, or
  SU(2) as physics.  The physics lane is about a semantics and an
  equivalence; the optical-device reading is marked as reading throughout.

  What IS claimed: the named terms exist, are checked, say what is written
  above them, and are imported by ``Pravesa_…`` — so that file is false the
  moment any of them is.  Turn the machine, or check the terms.  Neither asks
  you to trust this page.
