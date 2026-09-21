# Draft 4 — Topos Institute (Berkeley Seminar first, colloquium later)

You are in Berkeley. The Berkeley Seminar is weekly, in person, open to the
public, "usually Topos researchers, occasional guest speakers". Subscribe
(`berkeley-seminar+subscribe@topos.institute`), attend two, talk to
whoever is running it, *then* send this. The colloquium
(`david+colloquium@topos.institute`, Thursdays 17:00 UTC, recorded) is the
second step, after a seminar has happened.

Lead with the Chu-space sentence. It is the one line in the repository
that is already in their language (Pratt, lenses, dependent lenses,
polynomial functors, "systems of systems").

---

**Subject:** Guest talk proposal for the Berkeley Seminar — "The value of an interaction is a fibre: Chu spaces, forced completion, and executable transport"

> Hi [name],
>
> I've been at the last two seminars and would like to propose a talk.
> I'm in Berkeley, working independently, on a cubical Agda development
> (Agda 2.8.0 / cubical v0.9, ~2,400 modules, `--safe` throughout) whose
> primitive is a fact Topos people will recognise immediately:
>
> For a Chu space `(A, X, e)` with `e : A × X → K`, the canonical
> decomposition `S ≃ Σ_{v} fib_f(v)` applied to `e` gives
> `A × X ≃ Σ_{k : K} fib_e(k)`: the ordinary Chu value `k` is the visible
> coordinate, and `fib_e(k)` — every `(a, x)` that would have produced
> `k` — is the forced, canonical remainder. Nothing is lost when the
> remainder is kept, and univalence turns the equivalence into a path
> that *executes*: transport along it is the machine step.
>
> The talk (45 min + questions) would be:
> 1. That decomposition, and its strengthening when `e` is a *step* of
>    a machine: the completion is unique — `isContr (Lossless uStep)` —
>    so "run and keep the witness" and "check the witness" are the two
>    projections of one equivalence.
> 2. The trace algebra this gives: objects are partial local states,
>    morphisms are witnessed transformations, paths between paths carry
>    the coherence between two histories of the same change. Composition,
>    inversion where available, and the double-categorical shape of
>    "independent commuting transformations vs dependent crossings"
>    (which is where I would most like your corrections).
> 3. The same object executed on an interaction-net runtime (a cubical
>    layer on the pre-launch Bend2/HVM lineage, with measured cost: a
>    transport is paid once under sharing, and superposition pays exactly
>    when branches share work).
>
> What I would be asking the room: what is the right categorical home for
> a "witnessed interaction" — is it a Chu-transform, a dependent lens, a
> span in a double category — and does anything in the CatColab
> vocabulary already draw it? The math is public and checkable:
> [repo link], `sh setup && sh check`; a browsable site with the Agda HTML
> exports is at [site link], and the Chu-space note is
> `CHU_LOSSLESS_INTERACTION.md`.
>
> I'd be glad to do a 15-minute version first if that's the better fit.
>
> [name]

Notes for you: the question in the last paragraph is genuine and is the
reason they'd host it. Do not include the Jain-ontology section in the
proposal; it is a fine slide for the talk's last five minutes if the room
has warmed up.
