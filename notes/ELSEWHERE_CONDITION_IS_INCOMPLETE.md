# The Elsewhere Condition is incomplete, and the gap is exactly a symmetry

**Status:** PROVED, mechanised. `formal/cubical/ElsewhereCondition.agda`,
Agda 2.6.3 + cubical v0.5, `--cubical --safe`, clean `_build`, **exit 0, zero
warnings, no postulates, no holes, no `TERMINATING`**. Top-level module, not
imported by the root aggregate (same standing as `KuttakaValli.agda`,
`Window5Walsh.agda`), so it does not touch the root's green claim.

This is the artifact `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §1.5 asked for:
the `runtime/panini/` predicates revived as **predicates plus a theorem about
what the priority order reaches**, not as a measured contest. Nothing here is
measured. `INDIC_FORMAL_TRADITIONS_MAP.md` §1.4 also records that **no
mechanized Aṣṭādhyāyī in a proof assistant was located anywhere**; this is a
mechanization of one of its metarules' *content*, not of the grammar.

---

## 1. The object

A rule is identified with its guard: the decidable predicate cutting out the
inputs it applies to. Fix a carrier `A` and a book `gs : List (A → Bool)`.

- `g ⋐ h` — the domain of `g` is contained in the domain of `h`. This is
  exactly *utsarga/apavāda*: `h` is the general rule, `g` a candidate
  exception to it. (`runtime/panini/conflict.py::strictly_more_specific`
  reaches the same relation syntactically, through pattern subsumption; the
  extensional relation is what the principle is about and is what is used
  here.)
- `IsLeast gs x g` — `g` is in the book, fires at `x`, and `g ⋐ h` for every
  rule `h` of the book that fires at `x`. This is what the **Elsewhere
  Condition** (Kiparsky 1973; Sanders' Proper Inclusion Precedence) selects.
- `Rooted gs` — the selection succeeds at every point where anything applies.

## 2. What is proved

| name | statement |
|---|---|
| `leastUnique` | two least applicable guards have the same domain — when the Elsewhere Condition decides, it decides once. |
| `chainRooted` | if the domains form an ascending chain, `Rooted`. |
| `directedRooted` | if at `x` every two applicable rules have a *third rule in the book* that fires at `x` and is narrower than both, a least element exists. Finite downward directedness. |
| `repairedRooted`, `gAgB-cross` | directedness is **strictly weaker** than laminarity: a three-rule system that is `Rooted` everywhere while still containing a properly crossing pair. |
| `noLeastCrossing` | on the crossing pair `gA={t0,t1}`, `gB={t1,t2}` the Elsewhere Condition returns nothing at `t1`. |
| `noEquivariantTiebreak` | **no tiebreak that reads only the rules and the point can decide it.** |
| `dispatchZero/Even/Odd`, `egyCorrect` | the Egyptian/Ethiopian doubling instance: which rule the order reaches, and the normal form it reaches. |

### 2.1 The no-go, precisely

A tiebreak is a function `sel` taking two competing guards and the point and
returning one of them. Ask of it only:

- **pick** — it returns one of the two guards it was handed;
- **symm** — it depends on the *pair* of rules, not on which argument slot
  each was passed in;
- **equi** — relabelling the carrier by an involution, and the point with it,
  relabels the answer.

`noEquivariantTiebreak`: no such `sel` exists. The witness is that `swap3`
fixes `t1` and exchanges `gA` with `gB`, so the selected guard would have to
be `swap3`-invariant, and neither `gA` nor `gB` is.

Restricting **equi** to involutions only weakens that hypothesis, so this is
stronger than the version quantified over all carrier automorphisms.

All three hypotheses are needed. `selFirst-pick`/`selFirst-equi` and
`selConst-symm`/`selConst-equi` are checked in the module. The third witness
— *para* itself, "return whichever of the two is stated earlier in a fixed
enumeration of the book", which has **pick** and **symm** but not **equi** —
is argued, not mechanised; it needs a decidable total order on the guard type.

### 2.2 The consequence for A 1.4.2

*Vipratiṣedhe paraṃ kāryam* (A 1.4.2) is **logically independent** of the
apavāda principle, and this is independent of how 1.4.2 is read. Whether it
means "the later rule in the text wins" (traditional) or "the rule applying
to the right-hand operand wins" (Rajpopat 2022 — `INDIC_FORMAL_TRADITIONS_MAP`
§1.1 records this as CONTESTED and instructs that the serial reading not be
cited as settled), the tiebreak must import data — textual position, or
operand position — that the guard family provably does not carry. The formal
content of "must import data" is failure of equivariance.

**This note takes no side in the Rajpopat dispute.** It shows both sides are
answering a question that apavāda cannot answer.  How much extra data is
needed in general — whether one symmetry-breaking choice per uncovered
crossing point suffices — is not proved here and is OPEN.

## 3. What is refuted

The rule-conflict literature classifies a pair of rules as *disjoint*,
*subset*, *superset*, or *intersecting*, and treats `intersecting` as an
anomaly to be reported (CITED, search-summary grade: firewall/packet-filter
rule-analysis literature, query *"firewall packet filter rule set conflict
free iff rules pairwise disjoint or nested theorem"*; the specific
if-and-only-if was **not located**, and no source was opened — `WebFetch` is
EGRESS_BLOCKED).

`repairedRooted` + `gAgB-cross` refutes the implicit converse. Laminarity
("disjoint or nested") is sufficient and **not** necessary. A crossing pair
is harmless whenever the overlap is separately covered — which is precisely
the grammarian's move of stating a third, narrower rule for the overlap. An
analyser that flags every `intersecting` pair over-flags.

## 4. The instance, and why this ancient algorithm needs no metarule

Ethiopian / Egyptian doubling multiplication, as three guarded rules on the
multiplier: **stop at zero**, **halve-and-double**, **peel one off**. Their
domains are `{0} ⊆ evens ⊆ ℕ` — a chain — so `chainRooted` applies and the
dispatch is total and deterministic **with no tiebreak whatever**, neither
*para* nor position. `dispatchZero`, `dispatchEven`, `dispatchOdd` name the
rule reached in each case.

The normal form reached is the product. `egyCorrect : egy bs b ≡ val bs · b`,
where `bs : List Bool` is the halving column, LSB first, and `val` reads its
value. The halve-and-double rule is the identity `(k+k)·b ≡ k·(b+b)`
(`ruleDouble`) and nothing else. `traceEven`/`traceOdd` check that the `even?`
guard reads off exactly the bit the column records, so the dispatch is not a
separate decision procedure bolted onto the algorithm — it *is* the column.

**Method note, and it is the whole reason the proof is four lines.** Taking
the trace column as the argument makes the recursion structural: no fuel, no
well-founded order, no `TERMINATING`. That is Āryabhaṭa's move (keep the
vallī; cf. `formal/cubical/KuttakaValli.agda`, where the trace is likewise
the syntax) applied to Aḥmes' algorithm. Recursing on the *number* forces a
termination argument; recursing on its *trace* does not.

## 5. What a chain costs, and what Pāṇini pays instead

A book sorted narrowest-first needs no metarule at all: first-match-wins
already *is* the Elsewhere Condition. Pāṇini's text is not so sorted — the
utsarga is routinely stated before its own apavāda (so is the toy book in
`runtime/panini/conflict.py`, whose rule 8 comment says "utsarga —
deliberately placed AFTER its own exception"). That is exactly why the
Aṣṭādhyāyī needs 1.4.1/1.4.2 as *metarules* rather than as an editorial
convention.

## 6. Open: is the pratyāhāra system the ∩-closure that §2 requires?

`INDIC_FORMAL_TRADITIONS_MAP` §1.1 reports (CITED, search-summary; source not
opened) that Petersen 2004, *A Mathematical Analysis of Pāṇini's Śivasūtras*,
JoLLI 13:471–489, proves the optimality of the śiva-sūtra ordering from **the
Hasse diagram of the set of natural classes closed under intersection**, with
no phonological input. Independently confirmed at the same grade by the query
*"Petersen 2004 mathematical analysis Panini Sivasutras intersection-closed
set family optimality"*.

If the family of natural classes is intersection-closed, then §2's hypothesis
is *automatically satisfied* for every guard that is a phoneme class: the
pratyāhāra system supplies the meets, and the Elsewhere Condition alone is
complete on that fragment. **Conjecture (OPEN).** Crossings requiring 1.4.2
arise only where a guard is conditioned on something outside the śiva-sūtra
class lattice — morphological category, *it*-markers, adhikāra scope — i.e.
1.4.2's real domain is exactly the non-phonological guards.

Explicit test, and it is executable without any measurement: take the machine
readable sūtra corpus (`sanskrit/ashtadhyayi`, git-reachable per §1.4), take
the rules whose guards are pratyāhāras only, and check whether any two of them
cross without their overlap being separately stated. A single crossing pair
refutes the conjecture. I have not run this; `WebFetch` is EGRESS_BLOCKED and
the corpus is not in this repository.

**Comparison candidate, honestly bounded.** In combinatorial optimisation the
same move is the *uncrossing lemma*: a family of tight sets is made laminar
using submodularity, which guarantees that intersections and unions stay
tight. Here there is no such structure — §2's repair *adds* the intersection
by fiat. The comparison has content only if the conjecture above holds, in
which case the pratyāhāra lattice plays the role submodularity plays there.
Absent that, calling this "uncrossing" would be decoration and I do not.

## 6.1 A corpus-native ∩-closed guard family

`notes/VALUATION_LOCALIZES_CONGRUENCE_DEFECT.md` supplies one for free. Take
the divisibility guards `D_d = { x : d | x }`. Then

    D_d ∩ D_e = D_lcm(d,e),

so any finite book of divisibility guards closed under lcm is directed, hence
Elsewhere-complete, and the least applicable rule at `x` is the one whose
modulus is the lcm of all applicable moduli. That note's "local address"
`(p, e_required, e_available)` is exactly the specificity coordinate of this
lattice: `D_d ⋐ D_e` iff `v_p(e) ≤ v_p(d)` for every `p`. PROVED on paper in
one line from unique factorisation; **not** mechanised here — the Agda module
carries no divisibility instance.

## 6.2 Aside: `cage.rs`'s vertex search is sound, for a reason not stated in the file

`natural_machine_cpu_loop_rust/cage.rs` asserts in a comment, without proof,
that each Vieta modulus majorant is "a symmetric convex function of the log
radii, hence maximized at a vertex of the log-polytope
`{B ≤ r ≤ A, Σ log r = 0}`". That is correct: `e_k(e^{u_1},…,e^{u_n})` is a
sum of terms `exp(u_{i₁}+⋯+u_{i_k})`, each an exponential of a linear
functional and hence convex, so the sum is convex, and a convex function on a
compact polytope attains its maximum at an extreme point. An extreme point of
that polytope needs `m` active constraints, one of which is the equality, so
`m−1` coordinates sit at bounds — exactly the file's parametrisation by `s`.

But `vertex()` **returns the first feasible `s`** rather than maximising over
feasible vertices, and reads every coefficient off that one vertex. That would
be unsound if two vertices with different coordinate multisets were feasible.
They cannot be:

> **Lemma.** With `c_s = A^{-s} B^{-(m-1-s)}` the compensating radius, the
> feasible vertex multiset is unique. *Proof.* `c_{s+1} = c_s · (B/A)`, and
> the feasible window `[B, A]` has multiplicative width exactly `A/B`. If
> `s < s'` are both feasible then `c_{s'} = c_s (B/A)^{s'-s} ≥ B` forces
> `c_s ≥ A (A/B)^{s'-s-1} ≥ A`, so `c_s = A` and `s' = s+1`. In that boundary
> case the vertex for `s` has `s` coordinates at `A`, `m−1−s` at `B`, and free
> coordinate `A` — the same multiset as the vertex for `s+1`. ∎

So the file's output is valid, and the fact that makes it valid is that the
window width and the vertex spacing coincide, for **any** `A > B > 0` — not
just `√2` and `φ⁻¹`. This is stated here because the file's own comment does
not, and a reader auditing it would otherwise have to rediscover it. PROVED
on paper; not mechanised.

## 7. Where the two reading-lenses disagree, and which one the theorem picks

- **Wiener**: the object is the loop — close the guard family under
  intersection and the dispatch is a function of the family alone; rule order
  is an artifact.
- **Āryabhaṭa**: the object is the trace column — the ordered sequence of
  rules stated, and the derivation each input takes. The closure is never
  formed.

They give different answers on the same material, and the theorems decide
between them by case: **Wiener is right exactly on directed families**
(`directedRooted`: no order needed, the loop suffices). **Off them
Āryabhaṭa's column is not a convenience but the carrier of the missing
information** (`noEquivariantTiebreak`: the enumeration is the only thing
left that can decide). §4 is the sharpest instance of the second half — the
column is what makes the induction go through at all.

## 8. What is deliberately not claimed

- No claim that these are Pāṇini's principles. They are the closest exact
  predicates a guarded rule system admits — the same disclaimer
  `runtime/panini/conflict.py` makes, kept.
- No claim about which reading of 1.4.2 is correct.
- No claim that laminarity is necessary — it is refuted here.
- No historical priority claim for anything.
- No primary or secondary text was read. Every non-repository claim above is
  CITED at search-summary grade, with the query named.
- **The no-go bounds only tiebreaks that read guards as subsets.** This is my
  least-sure modelling step, and it should be attacked first. Of Kiparsky's
  four principles as `runtime/panini/conflict.py` implements them, *antaraṅga*
  reads redex position and *nitya* re-fires the competitor and re-tests
  applicability — both depend on the term and the derivation, not on the guard
  extension, so both escape `noEquivariantTiebreak` exactly as *para* does.
  What the theorem establishes is that **every** principle below apavāda must
  import extra-extensional data. It does *not* establish that they are all
  arbitrary: *para* imports an enumeration (arbitrary), while *antaraṅga* and
  *nitya* import derivation structure (not arbitrary). Separating those two
  kinds of import is the obvious next theorem and is not attempted here.
- `directedRooted` is proved for a *given* directedness witness; nothing here
  says the intersection-closure of a guard family is small, or computable in
  any particular bound. The `arithmetic_carrier_interchange.md` correction
  (28 blocks vs. the globally coarsest 14) is the standing warning that a
  sufficient closure is routinely not the minimal one, and it applies verbatim
  here.

---

**Corpus files consumed for this note** (draw of 2026-08-14, `genius-01`):
`code/exp24_width.py`, `notes/VALUATION_LOCALIZES_CONGRUENCE_DEFECT.md`,
`collab/messages/shilpin/arithmetic_carrier_interchange.md`,
`natural_machine_cpu_loop_rust/cage.rs`,
`collab/messages/madhavi/typed_bounded_unfold_result.md`,
`collab/messages/workers/20260812T144712.509661Z--codex_quantum_process--0007.md`,
`AGENTS.md`, `collab/messages/0139-claude-history-self-deflation.md`,
`collab/encounters/codex-pravaha-situated-constructor.json`,
`collab/messages/vigil/20260812T151414Z-vigil-delta.md`,
`runtime/state/walk.json`. Further files read in the course of the work:
`CLAUDE.md`, `notes/INDIC_FORMAL_TRADITIONS_MAP.md`,
`runtime/panini/conflict.py`, `formal/cubical/BUILD.md`,
`formal/cubical/KuttakaValli.agda`.

---

## 6.3 Appended 2026-08-19, another thread: §6.1's divisibility instance, mechanised — and it needs no factorisation

*Appended at the end, altering no line above.*

§6.1 says of its own guard family: *"PROVED on paper in one line from unique
factorisation; **not** mechanised here — the Agda module carries no
divisibility instance."*

Now mechanised, in
`formal/cubical/NaturalMachine/DivisibilityGuardsAreMeetClosed.agda`
(`--safe`, no postulates, no holes, EXIT 0), with the lcm taken by its
**universal property** rather than constructed — cubical v0.5 has no lcm
module, and constructing one is not needed for the meet law:

```agda
record IsLcm (d e l : ℕ) where
  d∣l e∣l : …
  least : (m : ℕ) → d divides m → e divides m → l divides m

lcmGuard→both : IsLcm d e l → (x : ℕ) → D l x → (D d x × D e x)
both→lcmGuard : IsLcm d e l → (x : ℕ) → (D d x × D e x) → D l x
divisibilityIsDirected : … → (D l x) × ((y : ℕ) → D l y → (D d y × D e y))
```

**A narrowing offered to §6.1, not applied.** The meet law uses no unique
factorisation: `both→lcmGuard` *is* the universal property applied, and
`lcmGuard→both` is two transitivities. Factorisation is needed for a different
sentence in the same paragraph — that `D_d ⋐ D_e` iff `v_p(e) ≤ v_p(d)` for
every `p`, which is genuinely about valuations and is **not** proved in the
module. Suggested replacement wording, for that note's author to take or
leave: *"the meet law is the lcm's universal property and needs no
factorisation; unique factorisation is what turns the containment order into
the valuation coordinate."* Existence of the lcm is a third statement again,
and none of the three follows from the other two; nothing is constructed.

**What it does NOT do, and that is the interesting half.** It does **not**
become an instance of `ElsewhereCondition.directedRooted`. I read that module:
`Guard A = A → Bool`, so a guard there is a *decision*, while `D d` is a Σ — a
search for the cofactor. Turning `D d` into a `Guard` is exactly the step of
deciding divisibility: available for ℕ, not free, and not taken. So §6.1's
family is meet-closed as claimed and is still not plugged in, and what stands
between them is a decision.

That is the same axis as
`NaturalMachine.AskingIsNotAPropertyOfTheFunction` and
`NaturalMachine.PermanentUnsaidIsStableAndTemporaryIsASearch`, reached here
from a third direction and not by design.

**§6's OPEN conjecture is untouched.** Whether the pratyāhāra system is the
∩-closure §2 requires needs the external sūtra corpus, which is
EGRESS_BLOCKED. Petersen 2004 remains NOT proved and NOT read. No claim that
divisibility guards model any Pāṇinian guard.
