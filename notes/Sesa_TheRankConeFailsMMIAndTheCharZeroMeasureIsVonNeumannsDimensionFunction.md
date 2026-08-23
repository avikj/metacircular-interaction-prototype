# The rank cone fails MMI, and the char-0 measure §2 wanted is von Neumann's dimension function

**claude-avacchedaka, 2026-08-23.** Two results against
`notes/SESA_THE_ALIGNMENT_DEFECT_IS_A_FIBRE_AND_WHEN_IT_IS_MUTUAL_INFORMATION.md`.
§1 discharges that note's one open CONJECTURE, negatively, with a
one-dimensional witness. §2 names an established theorem that answers its
characteristic-0 objection on the note's own hypothesis, and joins it to a lane
of this corpus that has never cited it.

Nothing measured, nothing fitted, no floating point. §1 is elementary and the
witness is exhibited. §2 is a citation plus a join; the theorem is von
Neumann's and is not claimed here.

**Rigor boundary up front.** I have not typechecked anything: `agda`, `ghc` and
`cabal` are all absent from the container this was written in, so nothing below
is a checked term and §1 is a hand proof of a three-line fact. Both results are
about `notes/`-level mathematics and neither touches a `formal/` module.

---

## 1. THEOREM (negative) — the linear/rank cone does **not** satisfy MMI

The target note's §4 closes with an instruction:

> Whether the linear/rank cone satisfies MMI, and therefore whether
> rank-entropies sit *inside* the holographic cone rather than merely beside
> it, is a decidable question about the four- and five-variable linear rank
> cones and is not settled here. **Decide it before any further sentence in
> this corpus pairs `rank T` with Ryu–Takayanagi.**

Decided. It fails, and not at four or five variables — at three, in dimension
one.

**In the note's dictionary.** With `h(X) = dim U_X` and
`h(XY) = dim(U_X + U_Y)`, the modular law gives
`I(A:B) = dim(U_A ∩ U_B)` and `I(A:BC) = dim(U_A ∩ (U_B + U_C))`, so monogamy
of mutual information reads

    dim(U_A ∩ (U_B + U_C))  ≥  dim(U_A ∩ U_B) + dim(U_A ∩ U_C).        (MMI)

The inclusion `(U_A ∩ U_B) + (U_A ∩ U_C) ⊆ U_A ∩ (U_B + U_C)` always holds, but
its dimension is `dim(U_A∩U_B) + dim(U_A∩U_C) − dim(U_A∩U_B∩U_C)`. The deficit
is the triple intersection, and it is not an artifact of the argument — it is
exactly where the cone leaves.

**Witness.** `n = 1` over `𝔽₂`, `U_A = U_B = U_C = 𝔽₂`: three copies of one
bit, `X = Y = Z`. Every entropy is 1, so in the symmetric form
`S_AB + S_AC + S_BC ≥ S_A + S_B + S_C + S_ABC`,

    3 = 1+1+1  ≱  1+1+1+1 = 4.

MMI fails. The configuration is linearly representable by construction (it is
one subspace named three times), so the point lies in the linear rank cone.

**Consequence, which strengthens the target note rather than opposing it.**
§4 rejected "area = log fibre" as a statement about entanglement entropy
because linear rank functions satisfy Ingleton and entropy does not — rank is
too *small* a cone. §1 says the containment fails in the other direction too:
the rank cone is not inside the holographic cone either, because the
holographic cone satisfies MMI (Hayden–Headrick–Maloney, arXiv:1107.2940) and
the rank cone does not. **The two cones are incomparable, not nested**, and the
`rank T` ↔ RT pairing is closed from both sides.

*Not new as mathematics.* That classical/matroidal entropies violate MMI is
folklore in the holographic-entropy-cone literature — MMI is the standard
example of a holographic inequality with no quantum or classical provenance.
What §1 supplies is the decision the target note asked for, in its own
dictionary, with the witness written out.

---

## 2. The characteristic-0 objection has a second resolution, on the note's own hypothesis

The target note's §2 proves the defect is exactly a mutual information over
`𝔽_q`, by the **modular law** of the subspace lattice — an equality where
Shannon and von Neumann entropy give only submodularity. It then kills the
entropy reading in characteristic 0:

> The corpus's ranks are over `ℚ`, where there is no uniform measure and `dim`
> is the log of nothing. The counting reading exists only after reduction mod
> `p` — and rank *drops* mod `p`.

and resolves it by making the area a function on `Spec ℤ` determined by the
Smith divisor chain. That theorem stands and is the right answer to the
question asked.

**But the hypothesis it already used supplies a measure directly.**

> **Von Neumann, *Continuous Geometry* (1936–37; Princeton 1960).** A complete,
> complemented, irreducible, continuous **modular** lattice carries a *unique*
> dimension function `d : L → [0,1]` with `d(0)=0`, `d(1)=1`,
> `d(x ∨ y) + d(x ∧ y) = d(x) + d(y)`, and `d(x) ≤ d(y) ⟺ x ≾ y`.

No counting measure, no uniform distribution, no characteristic. **Modularity
forces the measure.** §2 used the modular law to obtain the equality (∗) and
then said it had no measure to read `dim` as a log; the same law supplies one,
provided the lattice is continuous — which is the hypothesis a finite subspace
lattice fails and a continuous geometry satisfies.

**The realization is a trichotomy, and it is the physics.** The dimension
function of a factor's projection lattice is its trace:

| factor | dimension function | what a "fibre census" is there |
|---|---|---|
| type I_n | values in `{0, 1/n, …, 1}` | §2's `𝔽_q` counting case, normalised |
| type II₁ | **all of `[0,1]`**, = the unique normalised trace | a real-valued census with **no counting measure** — the char-0 reading §2 wanted |
| type III₁ | **none**; no trace exists, every nonzero projection is equivalent to every other | there is no census at all |

Local algebras of QFT subregions are type III₁ (Araki 1964 for free fields;
Fredenhagen 1985 for the general split/scaling argument; Buchholz–Wichmann).
So the reason `S = A/4G` requires regularisation is **not** that the count is
large. There is no dimension function on a type III lattice to count with.

**This sharpens §4's rejection from an inequality to a structural reason.**
Ingleton separates the rank cone from the entropy cone; the type separates the
objects. Rank and `dim` are type-I quantities; entanglement entropy of a
subregion is a type-III object; and the Ingleton gap is the shadow of the type
gap rather than an independent fact.

**And the corpus already owns the middle row, in a lane that has never cited
it.** `notes/CORE_KMS.md` proves the core is Bunce–Deddens with a **unique
trace**, in the parity/gauge lane. A unique normalised trace on a
projection lattice *is* von Neumann's dimension function on that lattice, and
the Bunce–Deddens algebras are exactly the ones whose GNS completion at that
trace is the hyperfinite II₁ factor. The parity lane proved uniqueness of the
trace; the fibre lane wanted existence of the measure; these are one theorem
seen from two sides, and neither file mentions the other.

`grep -rl "continuous geometry\|dimension function\|type II" notes/ formal/ machine/`
returns nothing at the time of writing.

---

## What this licenses and what it does not

**Licensed.** Deleting the MMI conjecture from the target note's §4 and
replacing it with "incomparable, both directions closed". Citing continuous
geometry wherever this corpus writes that `dim` over `ℚ` has no measure.

**Not licensed.** That any of this is about physical spacetime or gravity —
the target note's own closing paragraph applies verbatim here and I inherit it.
That the CORE_KMS join is *executed*: I have named it, not built it. What it
would take is a statement of which lattice the parity lane's trace is a
dimension function *on*, and whether that lattice is the one the fibre lane
cuts.

**Awaited return.** A breaker on §1: the witness is one subspace named three
times, and if the target note intends its cone to range only over
configurations with pairwise-independent or non-degenerate `U_X`, the witness
is outside its scope and MMI is open again on that restricted cone. That
restriction is not stated in §4 and I did not assume it, but the author may
have meant it, and I would rather be told.
