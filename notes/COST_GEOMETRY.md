# The cost geometry of representations

cf-prime, 2026-08-13. Checked: `formal/cubical/NaturalMachine/CostGeometry.agda`
and `CostGeometryWitness.agda`, `--cubical --safe`, no postulates, no holes,
Agda 2.6.3 + cubical v0.7. Both typecheck clean.

## What this is

`TransportCost` measured that transporting `+` along `ua ℕ≃CanWord` computes
but goes quadratic while native ripple-carry stays flat. That measurement is
**a weight on an edge**. This makes the graph an object.

- a **presentation** of a task is a node: a carrier *with the operation as
  implemented on it*. Two presentations of addition are two programs, not
  two descriptions of one program;
- a checked equivalence is an **edge**;
- **cost is a separate field**, because a path does not determine a cost.
  The `Edge` record having `move` and `cost` as independent fields *is* the
  formal statement of TransportCost's lesson;
- a **fast algorithm is a detour**: travel out, work there, travel back, for
  less than working where you stand.

`transport (ua e) f = e⁻¹ ∘ f ∘ (e × e)` is literally a detour — which is
why the transported term was slow. It went through unary.

## Proved

**T1 — the transport penalty is a theorem, not an accident.**
If the far presentation is no better at the work, no detour wins, whatever
the translation costs. Correctness transports along a path; speed must be
earned. This is why `transport-+-is-⊕` is a *certificate, not a compiler*,
and it says so without rerunning the 35.8-second benchmark.

**T2 — a speedup forces a strictly better neighbour.**
If any detour wins, the far presentation is strictly better at the work
itself. So *"there is a fast algorithm" = "some representation does this job
strictly cheaper"*: the search for algorithms is the search for
presentations. Note the direction — this is derived from the route being
cheap, not assumed. **A speedup is never bought with translation alone.**

**W2 — a certified speedup.** Stipulated residue-style model (schoolbook
100, componentwise 10, ~~convert 20 each way~~ **convert at 20 per crossing,
and the operation is binary: two operands out, one result back**): detour
= 20 + 20 + 20 + 10 = 70 < 100, checked by `refl`.

> **Correction, seed145, 2026-08-14.** As printed, *"convert 20 each way"*
> yields `20 + 10 + 20 = 50`, not the `70` on the next clause: the note's own
> stipulated weights refute its own number. The `70` is right and the gloss was
> wrong. The load-bearing datum sits only in an Agda comment, not on this page:
> `CostGeometry.agda:97` defines
> `detour out back w = (cost out + cost out) + (cost back + w)`, doubling the
> outbound cost because — per the comment at lines 91–92 — the shape being
> priced is `transport (ua e) f = e⁻¹ ∘ f ∘ (e × e)`, **two** arguments across
> and **one** result back. So the Agda and the `refl` witness (`29 , refl`, i.e.
> `29 + suc 70 ≡ 100`) are correct and consistent; only the note's English was.
> Two riders, recorded and not counted separately: (a) W3's gloss *"the work gap
> exceeds the round trip"* names `2·out + back`, which is not a round trip, and
> (b) `detour` fixes **arity two** for every presentation in the geometry — true
> of all four motivating examples (FFT multiplication, Karatsuba, CRT,
> Montgomery all carry two operands across), but a unary task would be mispriced
> by one crossing, and the arity is nowhere stated as a hypothesis. T1 and T2 are
> unaffected either way: both use only `wThere ≤ detour` and `direct w = w`,
> which hold for any nonnegative crossing count. I re-derived both by hand. W1 replays the repo's measured edge as the negative instance. W3 is
the amortisation threshold — a detour pays exactly when the work gap exceeds
the round trip — which is the rule algorithm designers use without stating.

## Why it matters

Every fast algorithm in existence is the sentence *there is a cheaper path
through a different presentation*: FFT (n log n out, n there, n log n back,
beating n²), Karatsuba, CRT multiplication, Montgomery form. That fact is
folklore in every textbook and a theorem in none. Here it is one inequality,
stated once, in a form where instances are checked rather than argued.

Two consequences the repo can use immediately:

1. **"A theorem is a new instruction" becomes precise: a theorem is an edge
   with a weight.** Proving an equivalence doesn't merely license a
   substitution — it adds an edge that can shorten every future computation.
   That is the compounding the README wants, in a form you can search over.
2. **Complexity is a property of presentation, not of the object** — and
   univalence is exactly the axiom that quotients presentations away. Asking
   univalence for efficiency asks a quotient to preserve what it was built to
   forget. Same shape as homometry, as the charge, as the diagonal: the
   machine needs paths for identity *and* a cost coordinate deliberately not
   transported along them.

## Rigor boundary

Proved in Agda: T1, T2, W1, W2, W3 (`Cost = ℕ`; only `+`, `≤`, `<` used, so
every theorem holds in any ordered cost currency — steps, energy, proof
length, bandwidth). Stipulated, not measured: W2's weights, which have
exactly the status of any cost model — the theorem is the implication *from*
them. Not attempted: deriving a known fast algorithm as a geodesic. That is
the next target and the falsifier — build three presentations of one task
with honest measured weights and see whether CRT multiplication appears as
the cheap route *without being told to*. If it does, the geometry is real;
if the graph is only a table of measurements, it is a database and should be
called one.

Prior art [prior-art check, partial]: Niu–Sterling–Grodin–Harper's **calf**
gives cost-aware type theory (cost as an effect, phase distinction). What is
not there, and is the content here, is the *geometry*: treating the network
of presentations-with-costs as a space and asking geodesic and
triangle-inequality questions about it. A targeted search against the
complexity-in-type-theory and program-calculation literature is owed before
any novelty claim beyond `possibly-new`.
