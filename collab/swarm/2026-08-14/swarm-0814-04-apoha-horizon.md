# The witness is the whole difference: Serre vs. Dignāga on `x ≁ y`, and the exact deficit at the horizon

`swarm-0814-04`, 2026-08-14. Object: `formal/cubical/Swarm/S04Apoha.agda`.
Checked: `cd formal/cubical && agda -i . Swarm/S04Apoha.agda` → **`EXIT=0`**
(`--cubical --guardedness --safe --no-import-sorts`; no postulates, no holes,
no imports outside the cubical library).

---

## 0. Where the two lenses disagreed

My draw assigned **Serre** ("state it in the shortest correct form and delete
the rest") and **Dignāga** ("define the term by what it excludes, never by what
it positively names"). On most of the drawn material they agree, because most of
the material is already short.

They part on exactly one word, and my draw supplied that word four times
independently:

| drawn file | the notion |
|---|---|
| `collab/upstream/raw/U0006.txt` | `x ∼_𝒪 y ⟺ O(x)=O(y) ∀O`; "does parity descend to the quotient?" |
| `collab/messages/shilpin/persistent_workers_emergent_object.md` | "distinction proofs: **shortest action words witnessing** `x ≁_𝒪 y`" |
| `runtime/kernel/check.py` | trust defined by an exhaustive **NOT TRUSTED** list, against a short positive T1–T4 |
| `code/exp36_toy.py` verdict | "**annihilated**, never **obstructed**" — a term fixed by what it excludes |

Serre's answer to "what is distinctness?" is: `¬ Ind x y`, where
`Ind x y = ∀ i, O i x ≡ O i y`. Four symbols; delete the rest.

Dignāga's answer (*anyāpoha*) is: distinctness **is** the exclusion, and an
exclusion you cannot exhibit excludes nothing. So
`Sep x y = Σ[ i ] ¬ (O i x ≡ O i y)` — the separating observation, in hand.

Classically these are the same. The whole content below is that constructively
they are the same **exactly up to one named principle**, and that the principle
is not a matter of taste.

---

## 1. The object

Three theorems and one equivalence, all in `Swarm/S04Apoha.agda`.

**(A) The negative forms never disagree.** For any type `X`, *any* index type
`I`, and Bool-valued observables `O : I → X → Bool`:

```
Arbitrary.¬sep→ind : ¬ Sep x y → Ind x y
Arbitrary.ind→¬sep : Ind x y → ¬ Sep x y
```

No finiteness, no omniscience: Bool paths are stable, so `¬Sep` hands back
`¬¬(O i x ≡ O i y)` at each single index and that is enough. Consequently
`¬ Ind x y → ¬¬ Sep x y` always. **The disagreement between the lenses is
therefore not about negation at all.** It is about the witness, and only the
witness. That is the first thing worth knowing, and it removes the obvious wrong
guess.

**(B) At every finite observation level the witness is free.** A finite family
is a list — which is not a coding convenience, it is the literal shape of the
repository's own chains (`exp36_toy.py`'s `S₁={2} ⊆ … ⊆ S₈={2,…,19}`; U0006's
"divisibility information below √X"):

```
Finite.sepSearch : (L : List (X → Bool)) (x y : X) → Dec (Sep L x y)
Finite.¬ind→sep  : ¬ Ind L x y → Sep L x y
```

`sepSearch` scans left to right, so the witness it returns is the leftmost
separating observation — Śilpin's "shortest distinguishing word", constructed
rather than described. Over a finite family the Serre vocabulary and the Dignāga
vocabulary are **the same theory, effectively**.

Two further finite lemmas discharge, as checked terms, two bullets that
`persistent_workers_emergent_object.md` states in prose:

```
Finite.sepMono  : Sep L x y → Sep (L ++ M) x y      -- its bullet 4
Finite.indAnti  : Ind (L ++ M) x y → Ind L x y      -- its bullet 1 (⊆)
Finite.indAntiR, Finite.indSplit                     -- its bullet 1 (⊇, =)
```

i.e. `∼_{𝒪∪𝒩} = ∼_𝒪 ∩ ∼_𝒩`, and *a stored witness is never invalidated by a new
observation*. These were the two load-bearing prose claims of the certificate
complex; they are now terms.

**(C) The horizon, exactly.** Let the family be indexed by `ℕ` — the colimit of
the finite levels, i.e. all primes rather than the primes below √X. Define

```
MP        = (f : ℕ → Bool) → ¬ (∀ n, f n ≡ true) → Σ[ n ] (f n ≡ false)
Witnessed = (X : Type) (O : ℕ → X → Bool) (x y : X)
          → ¬ (∀ n, O n x ≡ O n y) → Σ[ n ] ¬ (O n x ≡ O n y)
```

Then **both directions are proved**:

```
MP→Witnessed : MP → Witnessed
Witnessed→MP : Witnessed → MP
```

The reverse direction instantiates `X := Bool`, `O n b = if b then f n else true`,
`x := true`, `y := false`; the two hypotheses are then *definitionally* the same
type, so `Witnessed` is pinned from below by a two-point space. `Witnessed` is
stated at `Type₀` on purpose: the equivalence is tight at both ends.

**Statement of the object, in one line.** *Serre's `¬ Ind` and Dignāga's `Sep`
are interderivable over any finite observable family, and their difference over
an infinite one is precisely Markov's Principle — no more, no less.*

---

## 2. What this decides in the repository

The theorem it replaces (per `CLAUDE.md`: write down the theorem before
computing): it replaces nothing, because nothing was computed. It *supplies* the
theorem that two prose claims were standing in for.

- **U0006 (upstream, outranks CLAUDE.md).** Its boxed master problem is "does the
  arithmetic quotient map admit a section?", and its programme is the quotient
  `X/∼_𝒪` in Cubical Agda. §1(A) says the quotient's *equivalence relation* is
  vocabulary-independent: `∼_𝒪` and "nothing excludes them" define the same
  relation, always. So the quotient type is unambiguous and no HIT design choice
  is being smuggled in. §1(C) says the *fibers* are where the constructive content
  lives: knowing `q x ≠ q y` and being able to say **why** are separated by MP.
  A section of `q` is a stronger demand still; but the first honest obstruction
  on the way to it is this one, and it has a name.

- **`persistent_workers_emergent_object.md`.** Its third open boundary is "no cost
  theorem yet", and its bullet 6 says "state-block locality alone is unsound…
  the backward basin … can overreach arbitrarily". §1(B) explains why the finite
  machinery *can* be exact — bounded search — and §1(C) explains why no amount of
  forest engineering extends it: the incremental witness forest is complete at
  every finite stage and its completion along `S₁ ⊆ S₂ ⊆ ⋯` is complete **iff**
  MP. The forest is not buggy. The shared phrase "locality failure" that the note
  correctly refused to promote to a theorem is, at the horizon, this principle.

- **`exp36_toy.py`'s verdict.** "Annihilated, never obstructed" is exactly the
  §1(A) shape: all the *negative*/cohomological obstruction groups vanish, and the
  phenomenon lives in the vanishing of a witness (a bonding scalar), not in a
  nonzero class. The Agda file makes that distinction type-theoretic rather than
  rhetorical: `¬¬Sep` is always available, `Sep` is not.

- **`runtime/kernel/check.py`.** The kernel's own docstring is the same pair of
  lenses side by side: T1–T4 is the Serre form of trust, "EXPLICITLY NOT TRUSTED"
  is the Dignāga form. §1(A) is the reason this is not redundant documentation —
  for a *decidable* check the two coincide, which is why `check_path` can re-derive
  every step and ignore the e-graph entirely. The negative list is not extra
  safety; it is the same statement, and the file's honesty is that it writes both.

---

## 3. Method-lens list: the structural omission

I was asked to read `random_entry_seeder_so_agents_dont_cluster/method_lenses.txt`
as an object. Three findings, one of which I claim is structural.

**(i) Structural: the list has no null element.** All 147 entries are
*generative* — every one is an imperative that, applied, yields output. Even the
self-adversarial ones (Ibn al-Haytham 24/91, Milnor 77/112, Gowers 73/135) produce
an object; they only change which object. There is no lens whose correct
application is **to produce nothing**: no "decide this question is not worth
asking", no Grothendieck-1970 (leave the field), no Perelman (decline), no
Wittgenstein (pass over in silence). The omission is structural, not accidental,
because the file's schema is `person -- imperative verb`: refusal has no natural
person-attribution *as a borrowable method*, since what a person is famous for
is what they produced. The schema cannot represent its own null.

This matters mechanically, not aesthetically. The seeder gives every agent two
lenses and the protocol requires each to "produce one object and stop". A list
closed under "produces an object" composed with a protocol that requires an
object is a machine converting agent-hours into objects at a fixed rate
*independent of whether an object is warranted*. That is precisely the generator
of the ratio `CLAUDE.md` opens with — ~30 experiments, ~5 earned their keep. The
draw was built to break clustering in *subject*; it currently cannot break
clustering in *yield*.

**(ii) There is no referee lens.** Hypatia (19) is commentary, al-Bīrūnī (25) is
learning another tradition's terms, Euclid (16) is refusing an ungrounded step —
in *your own* argument. Nothing on the list is "read someone else's finished
claim adversarially and make them fix the one step". In a repository whose
canonical failure (`exp27`) propagated a fitted constant through two notes, a
paper section, **and a round of cross-review**, the missing lens is exactly the
one that would have caught it. This is a genuine gap and I have added it.

**(iii) Live contradiction inside the list.** The 2026-08-14 append duplicated
~25 names with *different* methods, so the same person can be drawn twice with
incompatible instructions. The sharpest case is in my own governing file: entry
29 "Gauss — do not publish the scaffolding, but do build it" vs. entry 115
"Gauss — compute a hundred cases by hand before conjecturing anything". Entry 115
directly instructs the measure-first behaviour that `CLAUDE.md` bans in its first
paragraph. Entry 133 ("Elkies — search hard enough with exact arithmetic that a
counterexample appears") is compatible with `CLAUDE.md` only under its
exact-symbolic carve-out, and should say so. I have not deleted anything — the
list belongs to no one agent — but I have appended entries that name the tension.

Appended to `method_lenses.txt`: 8 entries (block dated 2026-08-14,
`swarm-0814-04`), including the four null-element lenses, the referee lens, and
one lens for the finite/infinite boundary this note is about.

---

## 4. Contradictions found in my draw

Reported, not resolved, per `why_this_exists.md`.

1. **The repository's CI both requires and forbids Python.** My draw contained
   `.github/workflows/epistemic.yml`, which runs `python3` three times
   (`code/discovery_loop.py validate`, `machinery/validate.py`,
   `python3 -m unittest discover -s machinery`). It sits beside
   `.github/workflows/no-python.yml`, which blocks any added or modified `.py`
   and states the substrate is Agda. The two are consistent only under a reading
   nobody has written down: *the legacy corpus stays executable, forever, as
   frozen infrastructure*. If that is the intent it should be a line in
   `no-python.yml`; if it is not, `epistemic.yml` is the last live dependence on
   the banned substrate and the ban is not complete.

2. **A drawn note's reproduction instruction is a banned command.**
   `notes/RAMANUJAN_COMPOSED_CERTIFICATE.md` ends `Replay: python3
   machinery/ramanujan_composed_certificate.py`. Its mathematics is exact
   (Ramanujan multiplicativity composing certificates without rebuilding
   `ℚ(ζ_{qp})`) and its cost claim is honestly scoped ("not a wall-clock claim").
   But its *only* replay path is now unrunnable by protocol. Certificate
   composition is the one thing in that note that would transfer cleanly to
   Agda, and nobody has moved it.

3. **Upstream contradicts upstream, and no one has flagged it.** `U0003` (in my
   draw, and one of the twenty files that went unread for four days) asks: "we
   should probably be plugged into wolframalpha/mathematica right?" —
   an explicit request for external-service integration. `collab/upstream/README.md`
   states the archive is "not … permission to publish, **query an external
   service**, or export research", and `U0018` restricts export. The standing
   resolution treats query and push as the same act. Since upstream outranks
   every repository document, the honest statement is that a direct owner request
   is currently blocked by an archivist's framing sentence rather than by an owner
   directive. That should be surfaced to the owner, not settled by agents. (My own
   work respected the restriction: no external service was contacted.)

4. **The known one, confirmed present.** `U0013` treats the millennium problems as
   solvable; `notes/COGNITIVE_ORIENTATION.md` §8 says no named conjecture is the
   destination. Upstream wins, per my brief. Noted for the record that `U0014`
   from the same source is the counterweight — the owner is on record laughing at
   an earlier "resolution" of all of them. The two together read as *aim there,
   don't announce arrival*, which is not what either document says alone.

---

## 5. Honesty ledger

- Everything asserted in §1 is a checked term. `EXIT=0` quoted above.
- Nothing in this note is measured. No experiment was run, no number fitted, no
  `.py` created or executed, no git command issued.
- **Priority.** `Witnessed ↔ MP` is not new mathematics in constructive reverse
  mathematics — "¬∀ decidable ⇒ ∃¬" *is* Markov's Principle, and recognising an
  instance of it is recognition, not discovery. The claim here is a **translation
  and a localisation**: that this repository's certificate complexes, its
  sieve-horizon quotient programme, and its `annihilated vs. obstructed`
  distinction are all instances of it, that the finite/infinite boundary is where
  they change character, and that the deficit at the boundary is exactly one
  principle and can be checked. Prior art was considered before writing, per
  `CLAUDE.md`; the novelty claim is deliberately small and stated as such.
- **Scope.** Bool-valued observables. For observables valued in a type without
  decidable equality, §1(A) fails — the negative forms come apart too, and the
  whole analysis needs redoing. That is the first natural extension and I have not
  done it.
- **Not done.** Minimality of the leftmost witness is true by construction of
  `sepSearch` but is not stated as a separate theorem (the index bookkeeping cost
  more than it was worth); the finite levels are not glued to the ℕ-indexed family
  by a colimit lemma inside Agda; no HIT quotient `X/∼` is built, so U0006's
  section question is untouched beyond identifying its first obstruction.
