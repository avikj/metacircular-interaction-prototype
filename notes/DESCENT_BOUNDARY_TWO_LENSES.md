# Two lenses on descent: the space of identifications, and the view from inside

**Filed 2026-08-14, cf-oresme.** One checked Agda module, one exact
refutation, one exact closed-form gap, one inert falsifier found, and a
literature frame for each. No fitted constant, no correlation, no floating
point, no Python run — and one Python-backed claim retired by proving the
theorem it was standing in for.

Machine-checked companion: **`formal/cubical/SetTruncationDescentBoundary.agda`**,
`agda` exit **0** from a cold tree (no `_build`), `--safe`, no postulates, no
holes, no `TERMINATING`, zero warnings. It is **not** imported by the root
aggregate `NaturalMachine.agda` and is therefore **not covered by the root's
green claim** (PROTOCOL §1); it sits beside `DescentLaw.agda` and
`DynamicDescent.agda`, which are also outside the root. The integrator may add
the import line; I did not, because that file is not mine to edit.

---

## 0. The two lenses, and the promise that they disagree

- **Voevodsky's question.** If two things are equal, what is the *space of
  identifications* between them? Never "are they equal", always "what is
  `x ≡ y`".
- **Thurston's question.** What does the object look like to someone living
  inside it?

These are usually presented as complementary. §§1–3 exhibit a type on which
they give **opposite answers, both proved, in the same file**, and §4 exhibits
a numerical invariant in the corpus on which they give opposite answers about
whether a measurement is meaningful at all. §5 says where the disagreement is
a genuine theorem in the assigned frontier field (Berkovich spaces), and §6
says why the assigned ancient field ranked one of the two above the other,
2000 years ago, for reasons this repository rediscovered the hard way.

---

## 1. The theorem that replaces a Python replay — `PROVED`

`notes/HIGHER_COEQUALIZER_BOUNDARY.md` (not mine; untouched except for a
clearly-marked pointer appended at its foot) establishes what it calls "the
first exact boundary beyond set-level descent" by exhibiting the order-three
Smith automorphism: at a fixed point the action groupoid is `BC₃`, its orbit
set is a singleton, and `id_{BC₃}` cannot factor through that singleton
because a factorization would send the generator `H_z` to an identity. The
note's stated replay is

```
python3 machinery/higher_coequalizer_boundary.py
python3 -m unittest machinery/test_higher_coequalizer_boundary.py -v
```

`CLAUDE.md` (owner, 2026-08-13) is unambiguous that this is not evidence:
"A Python script that prints a number is exactly that 'everything else': the
reader must trust the script, its author, and the run." And its standing rule
is: *before running any computation, write down the theorem it would replace,
then prove it.*

**The theorem that replay is standing in for.** Write `∥A∥₂` for the set
truncation (the note's "orbit set", in the generality the note actually needs
— it is quotienting a groupoid, not a relation on a set) and

```
  Retracts₀ A  :=  Σ (f : ∥A∥₂ → A). (a : A) → f ∣a∣₂ ≡ a
```

for the datum "`id_A` descends through the collapse".

> **Theorem 1.** `Retracts₀ A ≃ isSet A`, for every type `A` at every
> universe level.

Not a biconditional — an equivalence of types. It has three parts, all
checked:

| part | statement | Agda name |
|---|---|---|
| (a) | a descent forces `A` to hlevel 2 | `retract→isSet` |
| (b) | a set descends, on the nose | `isSet→retract` |
| (c) | **the datum is a proposition** | `isPropRetracts₀` |

(a) is `isOfHLevelRetract 2` — a retract of a set is a set. (b) is
`setTruncIdempotent`. Both are library one-liners. **(c) is the part that
turns a logical equivalence into an equivalence of types**, and it is the
Voevodsky move performed on the note's own question: the note asks *whether*
the identity factors; the lens says ask *what the type of factorizations is*.
The answer is that it is `isSet A` — a proposition, contractible when
inhabited. There is not merely no canonical descent when `A` is not a set;
the type of descents is empty, and when `A` is a set the descent is unique
with no choice made anywhere.

**What this buys over the note.** Theorem 1 needs no group, no finiteness, no
Smith normal form, no fixed point and no computation. The `C₃` apparatus is
not the boundary. **Hlevel is the boundary**, and the Smith example is one
point of the empty side of an equivalence. The note's own smaller witness
(`FinSet₂`, with `(FinSet₂ = FinSet₂) ≃ S₂`) is likewise one point, and the
module uses a third — `S¹` — only because this repository already owns the
refutation `NaturalMachine.SetBaseNoMonodromy.S¹NotSet` and re-deriving it
would be exactly the failure `notes/HOTT_ECOSYSTEM_MAP.md` §2.4 documents.

Two corollaries, also checked, which is why the identity is the right test at
all:

- `idDescends→allDescend` — **the identity is universal**: if `id_A` descends,
  then every `A`-valued task from every domain descends. So the note's careful
  remark that "a numerical stabilizer order is not by itself a counterexample"
  is not a caveat, it is a corollary: set-valued invariants *always* descend,
  and the identity is the strongest possible demand.
- `descend-unique` — and the descent is unique, so nothing is chosen.

**Novelty: none claimed.** "A retract of an `n`-type is an `n`-type" is
standard HoTT; both implications are library one-liners. What is not present
verbatim in cubical v0.5, cubical master, agda-unimath, Coq-HoTT, UniMath,
1lab, or this repository (all grepped 2026-08-14, see §7) is the packaging as
an equivalence of types, i.e. part (c) — and that too is surely folklore. The
contribution is not the theorem; it is that a note in this corpus asserted
this boundary on the authority of a Python run and now does not have to.

---

## 2. The other lens, on the same type — `PROVED`

> **Theorem 2** (`insideView`). For **every** type `A` and **every** `a : A`,
> the type `Σ (x : A). a ≡ x` is contractible.

No hypothesis. This is `isContrSingl`, an old library one-liner, and the
reason to restate it is that it is Thurston's question answered literally:
standing at `a`, the space of everything you can reach *together with the
identification you travelled along* is a point. You are always at the centre
of a trivial world. Holonomy, monodromy, isotropy — none of it is visible to
an inhabitant who remembers her route.

**The disagreement, at one object, both halves checked in one file:**

| | question | answer for `S¹` | Agda name |
|---|---|---|---|
| Voevodsky | what is the type of descents of `id`? | **empty** | `noDescentS¹` |
| Thurston | what does it look like from inside? | **contractible, at every point** | `insideViewS¹` |

~~These are not in conflict; they are answers to different questions, and the~~
~~exact relation between them is the last line of the module: `Retracts₀` is a~~
~~**global section of a bundle whose fibres are contractible**. §2 says the~~
~~fibres are contractible. §1 says the section does not exist. That is what a~~
~~nontrivial bundle *is*, said in the one vocabulary in which "nontrivial" is~~
~~not a metaphor.~~

**Correction (2026-08-14).** The struck passage identifies two different
types.  The actual section space of the displayed family is
`(a : A) → Σ (x : A), a ≡ x`; it has the canonical section
`a ↦ (a,refl)` and is contractible for every `A`.  `Retracts₀ A` is instead
left-inverse data for the set-truncation unit `A → ∥ A ∥₂`.  The safe Agda
module `ContractibleFiberSectionBoundary.agda` checks the distinction and the
`S¹` control; see `notes/CONTRACTIBLE_FIBERS_HAVE_SECTIONS.md`.  The checked
theorems in §§1–2 above are unchanged.

**Where I take a side.** The note under audit asks only Voevodsky's question,
and is right to. But the reason the `C₃` example felt like it needed a
computation is Thurston's: from inside, nothing is wrong, so the obstruction
does not present itself as a fact you can look at — which is precisely why it
must be *proved* rather than *replayed*. The two lenses do not merely
disagree; the second explains why the first is hard to believe without a
proof, and therefore why a script was reached for.

---

## 3. The same disagreement, in the assigned frontier field — `CITED`

Berkovich analytic spaces are where these two lenses give textbook-opposite
answers about one object, and it is worth recording because it shows §§1–2 are
not an artifact of type theory.

Let `K` be a complete non-archimedean field.

- **Voevodsky's answer is: nothing is there.** The Berkovich projective line
  `P¹,an_K` is compact, Hausdorff and **uniquely arcwise connected** — an
  ℝ-tree. Between any two points there is exactly one arc. The space of
  identifications is as trivial as it can be without the space being a point.
- **Thurston's answer is: everything is there.** At a type-2 point the
  complement's components ("residue classes") are in bijection with `P¹` over
  the residue field — infinitely many branches at every type-2 point, and
  type-2 points are dense in every interval. An inhabitant sees an
  infinitely-branching tree. This is the whole local content of the space and
  the tree structure records none of it.

And the degeneration half, which is the exact analogue of §1's "the collapse
loses precisely the loops":

- A compact analytic domain with a strictly semistable formal model
  deformation-retracts onto the **dual complex of its special fibre**, hence
  has the homotopy type of a finite complex. The **essential skeleton is a
  birational invariant of the generic fibre, independent of the model**; the
  particular dual complex is not.

That last line is the shape of the whole note. **What survives the collapse
is a homotopy type; what does not survive is the chart you computed it in.**
Blowing up the special fibre changes the inhabitant's view — new components,
new local pictures — and does not change the invariant. In §4 the "blow-up"
is a change of encoding and the invariant is the behavioural quotient.

`CITED` throughout §3: these come from WebSearch result summaries only.
`WebFetch` is EGRESS_BLOCKED in this repository (`notes/HOTT_ECOSYSTEM_MAP.md`
§0 verified it again this week) and **I opened no paper**. Do not quote §3 as
if a source had been read. See §7 for exact search strings.

---

## 4. The rank-bridge audit: an exact refutation, and an exact gap

`collab/messages/shilpin/to_madhavi_rank_bridge_audit.md` corrects Mādhavī's
minimality claim (three behavioural classes → two; the correction is right and
its self-correction mid-sentence is the healthiest sentence in my draw) and
headlines:

> "The set quotient is encoding-invariant, while rank is not; your one-hot
> contrast states this correctly and should be headline-level."

That is Voevodsky's lens applied to a numerical invariant, and it is correct.
This section makes it exact, and in doing so **refutes the natural reading of
the one-hot contrast** — that one-hot repairs rank into a faithful proxy for
the quotient.

### 4.1 Setup

A finite total Moore system `M = (S, A, O, δ, o)`; `run(x,w)` the state reached
from `x` on the word `w`; behaviour `b(x)(w) = o(run(x,w))`; `m` the number of
behavioural (Nerode) classes. Fix a field `k`, a `d`, an **injection**
`i : O ↪ k^d`, and a set of test words `W ⊆ A*`. The audit's `T` is the matrix

```
  T[ [x], (w,j) ]  =  i( o( run(x,w) ) )_j ,     rows = classes, columns = W × {1..d}
```

and the audit's "minimum exact linear factor dimension" is `rank T`. (`T = CR`
with `rank T = rank R` is exact, as the audit says, because choosing
representatives left-inverts `C`.)

### 4.2 One-hot is rank-maximal — `PROVED`

> **Lemma R2.** For every field `k`, every `d`, every `i : O → k^d` and every
> `W`: `rank(T_i) ≤ rank(T_onehot)`, where `T_onehot` uses `O ↪ k^{|O|}`,
> `o ↦ e_o`.

*Proof.* Column `(w,j)` of `T_i` is the function
`[x] ↦ i(o(run(x,w)))_j = Σ_{o∈O} i(o)_j · [ o(run(x,w)) = o ]`, i.e. a
`k`-linear combination of the columns `(w,o)` of `T_onehot`. So the column
space of `T_i` is a subspace of that of `T_onehot`. ∎

Injectivity of `i` is not used. So the audit's instinct is exactly right and
now has a proof: **one-hot is not one good encoding, it is the supremum over
all encodings.** Every rank figure quoted for any other encoding is bounded by
the one-hot figure.

### 4.3 …and the supremum is still not the quotient — `REFUTED`

> **Theorem R3.** There is a Moore system with `n = 4` states, one action, two
> observations, all four states **pairwise behaviourally distinct** (`m = 4`),
> such that for `W = A*` — every word, not merely the audit's `n−2` horizon —
> and for **every** field `k` and **every** encoding `i`,
> `rank(T_i) ≤ rank(T_onehot) = 3 < 4 = m`.

*Witness.* `S = {1,2,3,4}`, `A = {α}`, `O = {a,b}`,

```
  o :  1↦a   2↦a   3↦b   4↦b
  δ :  1↦1   2↦3   3↦1   4↦3
```

*Behaviours* (reading `o(x), o(δx), o(δ²x), …`):

```
  1 : a a a a …        3 : b a a a …
  2 : a b a a …        4 : b b a a …
```

pairwise distinct, so `m = 4` and no two states collapse. `δ²` is the constant
map to `1`, so for every `w` with `|w| ≥ 2` the column block is **constant**.

*Rank.* Put `c = (1, −1, −1, 1)` on the four rows. Column blocks:

- `w = ε`: the partition is `{1,2} | {3,4}`; `c` sums to `0` on each block.
- `w = α`: the partition is `{1,3} | {2,4}`; `c` sums to `0` on each block.
- `|w| ≥ 2`: the block is constant; `c` sums to `0` over all four rows.

So `c` annihilates **every** column of `T_onehot`:
`r₁ − r₂ − r₃ + r₄ = 0`, giving `rank ≤ 3`. And `rank ≥ 3`, since
`r₁ = (1,0|1,0|…)`, `r₂ = (1,0|0,1|…)`, `r₃ = (0,1|1,0|…)` are independent
already in their first four coordinates. Hence `rank(T_onehot) = 3` exactly,
and Lemma R2 gives the claim for every `i`. ∎

**What is refuted.** Not Śilpin's sentence — that sentence is *confirmed*, in
the strongest available form. What is refuted is the reading that the audit
invites: that the `n−2` horizon plus a one-hot encoding makes `rank T` a
faithful stand-in for `m`. The horizon bound is calibrated to **row
distinctness** ("row equality is future equality" — true, and Śilpin states it
correctly). `rank T = m` requires **linear independence of the rows**, which
is strictly stronger, and no horizon supplies it. R3 is the witness: the
obstruction is a linear relation that survives *all* words.

The mechanism is worth naming, because it is not an accident of small numbers:
the rows are concatenations of one-hot blocks, so for each `w` they satisfy
the affine constraint `Σ_{o∈O} T[·,(w,o)] = 1`. Hence:

> **Corollary R4.** Let `W_nc ⊆ W` be the words `w` for which the map
> `[x] ↦ o(run(x,w))` is **non-constant**. Then
> `rank(T_onehot) ≤ |W_nc|·(|O| − 1) + 1`, for any `W`, finite or not.

*Proof (column space, which is cleaner than the affine hull).* The columns of
`T_onehot` are the functions `χ_{w,o}([x]) = [ o(run(x,w)) = o ]`. A `w ∉ W_nc`
contributes only `𝟙` or `0`. For each `w`, `Σ_{o∈O} χ_{w,o} = 𝟙`, so the `|O|`
columns of block `w` span at most `|O| − 1` dimensions *modulo* `𝟙`. Hence

```
  rank = dim span{columns} ≤ 1 + Σ_{w ∈ W_nc} (|O| − 1) = |W_nc|(|O| − 1) + 1 .  ∎
```

In R3: `W_nc = {ε, α}`, `|O| = 2`, bound `= 3`, **attained**. So R3 is not a
small-numbers accident; it is this bound being tight, and the bound involves
neither `n` nor `m`.

### 4.4 The gap is exponential, with an exact closed form — `PROVED` (and `CITED` as known)

> **Theorem R5.** Let `M_ℓ` be the `ℓ`-bit shift register with zero fill:
> `S = {0,1}^ℓ`, one action, `o(b₁…b_ℓ) = b₁`,
> `δ(b₁…b_ℓ) = (b₂,…,b_ℓ,0)`. Then all `2^ℓ` states are pairwise
> behaviourally distinct, so `m = 2^ℓ`, while for every field `k` and every
> encoding `i`,
>
> ```
>   rank(T_i)  ≤  rank(T_onehot)  =  ℓ + 1  =  log₂ m + 1 ,
> ```
>
> exactly. The gap `m − rank = 2^ℓ − ℓ − 1` is exact and unbounded.

*Proof.* `run(x, α^k)` reads bit `b_{k+1}` for `k < ℓ` and `0` afterwards, so
distinct states differ at some `α^k`, `k < ℓ`: `m = 2^ℓ`. For the rank, the
column `(α^k, o)` of `T_onehot` is the function `x ↦ [b_{k+1}(x) = o]`, and
`c_{k,0} + c_{k,1} = 𝟙` for each `k`, while all columns with `k ≥ ℓ` are
constant. So the column space is spanned by `{𝟙, b₁, …, b_ℓ}` — that is
`ℓ+1` vectors, and they are `k`-linearly independent (evaluate at `0` and at
each `e_j`). Hence `rank(T_onehot) = ℓ + 1` exactly, and Lemma R2 extends it
to every `i`. ∎

**This is a rediscovery and is cited as one.** `rank T` is the observability
rank of a linear realization, and "an automaton is minimal iff its Hankel
matrix has rank `n`" is **Fliess's theorem**, the weighted generalization of
Myhill–Nerode; the identification `rank(Hankel) = state-dimension of a minimal
linear realization` is classical Kalman/Ho–Kalman realization theory. That a
DFA-style state count can be exponential in the Hankel rank is folklore in
that literature. `CITED` — from search summaries only, no paper opened; see
§7. The corpus already holds the set-level half at
`NaturalMachine/FutureBehavior.agda` and `mathlib4`'s `MyhillNerode.lean`
(`notes/HOTT_ECOSYSTEM_MAP.md` §2.5).

**What is new here is only the correction it makes to the audit**, which is
in-corpus and load-bearing: the audit's `T` *is* an observability matrix, its
"minimum exact linear factor dimension" *is* the minimal linear realization
dimension, and those two facts turn "rank is not encoding-invariant" from a
caution into a theorem with an exact exponential separation. I did not find
this frame named anywhere in the corpus; searching it is what §7 records.

### 4.5 The lens disagreement here

- **Voevodsky.** "Rank is not invariant" is imprecise; the precise statement
  is that rank is a function on a *different* groupoid. Let `Sys` be finite
  Moore systems with isomorphisms, and `LinSys` the groupoid of pairs
  `(M, i)` with morphisms `(φ, g)`, `φ` a system isomorphism and
  `g ∈ GL_d(k)` with `i' = g∘i`. Then `m` descends to `π₀(Sys)`; `rank_W`
  descends to `π₀(LinSys)` (a system isomorphism permutes rows; `i ↦ g∘i`
  right-multiplies `T` by an invertible matrix); and `rank_W` does **not**
  descend along the forgetful `U : LinSys → Sys`, because the fibre of `U`
  over a fixed `M` is disconnected and `rank_W` is non-constant on it —
  witness `O = S = {o₁,o₂,o₃}`, `A = ∅`: `i₁(o_j) = e_j ∈ k³` gives
  `rank = 3`, `i₃(o_j) = (j,0,0) ∈ k³` gives `rank = 1` (char `k ∉ {2,3}`),
  and no `g ∈ GL₃` carries one to the other since `GL` preserves rank. So
  "rank is not an invariant" **is** the statement that `π₀` of the fibre is
  not a point, which is Theorem 1's shape one category down.
- **Thurston.** From inside a fixed encoding, rank is a perfectly good
  invariant and nothing is wrong. An engineer who has *chosen* `i` — and one
  always has — sees a number that is stable under everything she can do. She
  is right. The number is meaningless only under a change of frame she cannot
  perform from inside. This is exactly the `CLAUDE.md` §"Corollary" failure
  mode ("measuring a constant at one scale hides its scaling") in its
  categorical form: **a number without its group of frame changes is worse
  than no number, because it looks like knowledge.**

---

## 5. An inert falsifier — `REFUTED`

`runtime/vocabulary/conservativity.py` is legacy Python (read only; not run,
not modified, per PROTOCOL §5). Its docstring for `base_answers_unchanged`
calls it "conservativity stated in the strongest form the substrate allows",
and `runtime/vocabulary/README.md` repeats it. The function normalizes each
base term `t` twice and compares addresses:

```python
a, _ = normalize(t, ...)                    # "with"
b, _ = normalize(unfold(t, vocab), ...)     # "without"
```

Its own inline comment states the premise that kills it: *"the vocabulary is
not consulted by `normalize` at all — a defined head cannot occur in a base
term."* Therefore for a base term `unfold(t, vocab) = t`, and the two calls
are `normalize(t)` and `normalize(t)`. The comment then claims the check
"would fail loudly if a definition had leaked a rewrite rule into the base
engine". **It would not.** A leaked rule lives in `normalize`, which is the
same function on both sides; it would move `a` and `b` identically and the
address comparison would still pass.

> **Result.** `base_answers_unchanged` reports the outcome of a comparison
> that is `refl` by construction. It cannot fail, and in particular cannot
> detect the one failure mode its comment names. PROTOCOL §1 requires headline
> claims to ship with a falsifier that could kill them; this one is inert.

This is not a claim that the conservativity property is false — it is true,
and it is a textbook metatheorem (a definitional extension by
`∀x̄. f(x̄) = t(x̄)` with `f` fresh and `t` in the old signature is
conservative; unfolding terminates because `f ∉ t`, which is exactly gate D4).
The claim is that **the check reports nothing about it.** `NaturalMachine/
DefinitionalExtension.agda` already makes the constructive half of this point
("elimination IS the checker", `unfold-sqr = refl`) and
`notes/RUNTIME_TO_CUBICAL_MIGRATION.md` §A1 says the apparatus "has no residue"
in Agda. Neither says the Python check is vacuous *within Python*. That is the
addition, and it is a negative one.

The seven admission gates are a different matter and are not vacuous: D3 ("the
defining equation's left side is the new head applied to distinct parameters —
it constrains no old symbol") is a real syntactic criterion, and it is the one
§6 is about.

---

## 6. The assigned ancient field, used rather than decorated — `CITED`

Mīmāṃsā is a hermeneutics of *how a corpus of received statements is made to
speak with one voice under conflict*. Three of its doctrines are, without
strain, the three protocols this repository has had to invent.

**(i) `vidhi` vs `arthavāda` is gate D3.** A `vidhi` (injunction) carries
independent authority; an `arthavāda` (descriptive or laudatory passage) does
not — it has purport only when construed together with an injunction
(`ekavākyatā`). The test is whether the sentence introduces something or
merely qualifies what is already there. Gate D3 is that test made mechanical:
a sentence whose left side is a *fresh head applied to distinct parameters*
introduces (and is eliminable, hence carries no independent authority); a
sentence whose left side is a term of the *old* language constrains old
symbols and is an axiom. `x*y := x+y` is refused, as the module says, "not
because it is false (it is), but because its left-hand side is a term of the
old language". That is the `vidhi`/`arthavāda` boundary, drawn on the same
side, by the same criterion.

**(ii) `bādha` is PROTOCOL §2.** `bādha` is sublation: when a specific
injunction conflicts with a general one, the specific *sets aside* the general
**within its scope** — it does not delete it, and the general rule keeps its
force everywhere else. PROTOCOL §2 says: "Strike through in place with a
pointer to the refutation; never silently delete." That is `bādha`, including
the scope restriction. §4.3 above is written as a `bādha` and not as a
deletion: Śilpin's sentence stands, and is strengthened; what is set aside is
one reading of it, in one scope.

**(iii) The six-fold priority ordering is PROTOCOL §0, and this repository
learned it the expensive way.** When six means of determining application
conflict, Jaimini (MS 3.3.14) orders them by decreasing strength:

```
  śruti  >  liṅga  >  vākya  >  prakaraṇa  >  sthāna  >  samākhyā
  direct    word-    syntactic  context      position    NAME
  statement meaning  connection
```

The stated reason is increasing remoteness from the meaning. **`samākhyā` —
evidence from a name — is ranked last, weakest of the six.**

Now read `notes/HOTT_ECOSYSTEM_MAP.md`: 12 of 15 univalent claims in this
corpus already existed elsewhere, 9 of them in libraries on this disk, one of
them (`ℕ` homotopy-initial with a contractible type of algebra maps) inside
the very library the module imports — and PROTOCOL §0's diagnosis is
"**Coined names are exactly what hide standard objects**". That is
`samākhyā`-primacy: searching by the name we gave a thing rather than by what
the thing *is*. The Mīmāṃsakas ranked name-evidence dead last and said why,
and this corpus rediscovered the ranking by paying for it. §7 of this note is
written to obey the ordering: I searched by `liṅga` (what the object *means* —
"retract of a set truncation", "Hankel rank", "uniquely arcwise connected")
before ever searching by any name this repository coined.

`CITED`: the ordering and its stated rationale come from WebSearch summaries;
I opened no primary text and read no translation of MS 3.3.14. The
transliterations are as returned. Do not cite §6 as scholarship.

---

## 7. Ledger

### Grades

| # | statement | grade | where |
|---|---|---|---|
| T1 | `Retracts₀ A ≃ isSet A` | **PROVED** (Agda, exit 0) | `SetTruncationDescentBoundary.agda` §1 |
| T1a | identity descent is universal; descent unique | **PROVED** (Agda) | ibid. §2 |
| T2 | `Σ(x:A). a ≡ x` contractible, no hypothesis | **PROVED** (Agda; library `isContrSingl`) | ibid. §3 |
| T3 | `S¹`: no descent datum, contractible inside view | **PROVED** (Agda) | ibid. §4 |
| B | Berkovich line an ℝ-tree; type-2 branching; skeleton a model-independent invariant | **CITED** (search summaries only) | §3 |
| R2 | one-hot is rank-maximal over all encodings | **PROVED** (written) | §4.2 |
| R3 | 4-state witness: `rank = 3 < 4 = m` for **all** words and **all** encodings | **PROVED / REFUTES** a reading of the audit | §4.3 |
| R4 | `rank(T_onehot)` is at most `#W_nc · (#O − 1) + 1` | **PROVED** (written) | §4.3 |
| R5 | shift register: `m = 2^ℓ`, `rank = ℓ+1` exactly | **PROVED** (written), **CITED as known** (Fliess / Kalman) | §4.4 |
| R6 | rank descends to `π₀(LinSys)` but not along `LinSys → Sys`; explicit disconnected fibre | **PROVED** (written) | §4.5 |
| V | `base_answers_unchanged` is an inert falsifier | **REFUTED** (the check, not the property) | §5 |
| M | `vidhi`/`arthavāda` ↔ gate D3; `bādha` ↔ PROTOCOL §2; six-fold ordering ↔ PROTOCOL §0 | **CITED** | §6 |
| O1 | does `W` = all words of length `≤ n−2` with one-hot force `rank = m` when the tail is *not* eventually constant? | **OPEN** | §7 |

`O1` is stated precisely so it can be worked: R3's witness has a constant
tail, which is what lets one relation cover infinitely many columns. I did not
determine whether a system with a non-degenerate tail can also carry a
relation. I did *not* run anything to find out.

### Prior art searched, in this order, before writing (PROTOCOL §0)

**Local surfaces first.** `~/agda-libs/` — cubical v0.5 (the pin) and
cubical-master, agda-unimath, Coq-HoTT, UniMath, 1lab, mathlib4. Read:
`Cubical/Foundations/HLevels.agda:207` (`isOfHLevelRetract`), `:127`
(`isPropIsSet`), `Cubical/HITs/SetTruncation/Properties.agda:224`
(`setTruncIdempotentIso`), `Cubical/Foundations/Prelude.agda:456`
(`isContrSingl`), `:548` (`isProp→PathP`), `Cubical/Foundations/Equiv.agda:189`
(`propBiimpl→Equiv`), `agda-unimath/src/foundation/set-truncations.lagda.md`.
Both implications of T1 are there; **the equivalence packaging is not**, in
any of the six.

**This repository.** Grepped for `SetTrunc`, `isSet.*retract`,
`isOfHLevelRetract`, `factors through`, `≃ isSet`, `base_answers_unchanged`.
Found and read the neighbours so as not to re-prove them:
`formal/cubical/DescentLaw.agda` (set *quotients*, not truncation),
`DynamicDescent.agda`, `NaturalMachine/EffectiveDescent.agda`,
`NaturalMachine/HolonomyDescent.agda`, `NaturalMachine/SetBaseNoMonodromy.agda`
(whence `S¹NotSet`, imported not re-derived),
`NaturalMachine/ObservabilityQuotient.agda`,
`NaturalMachine/DefinitionalExtension.agda`, `notes/HOLONOMY_DESCENT.md`,
`notes/RUNTIME_TO_CUBICAL_MIGRATION.md`, `notes/HOTT_ECOSYSTEM_MAP.md`.

**Then WebSearch** (four queries, verbatim):
1. `homotopy type theory "is a set" iff "retract of" set truncation 0-truncation`
   — returned the general "a retract of an `n`-type is an `n`-type" and the
   universal property of `∥−∥₀`; the biconditional-as-equivalence did not
   surface.
2. `Berkovich analytic line uniquely arcwise connected R-tree type 2 point branches P^1 residue field`
   — §3's first two bullets.
3. `dual graph of special fiber homotopy type invariant under blowup semistable model skeleton Berkovich`
   — §3's third bullet (strictly semistable ⇒ retract onto the dual complex;
   essential skeleton a birational invariant independent of the model).
4. `Hankel matrix rank minimal linear realization versus Myhill-Nerode state count exponential separation weighted automata`
   and `shift register automaton exponential gap number of Nerode classes versus observability rank linear system over field`
   — Fliess's theorem and Ho–Kalman realization, for §4.4's citation.
5. `Mimamsa six means of interpretation ordering śruti liṅga vākya prakaraṇa sthāna samākhyā Jaimini 3.3.14`
   — §6(iii).

**`WebFetch` was not attempted; it is EGRESS_BLOCKED on every host in this
repository. No paper, page, or primary text was opened. Every `CITED` grade
above is search-summary testimony and nothing more.**

*What a successor should not repeat:* do not re-search for T1 in the univalent
libraries; both halves are there under `isOfHLevelRetract` /
`setTruncIdempotentIso` and the packaging is not, in any of the six. Do not
re-search the corpus for a set-*truncation* descent law; `DescentLaw.agda` is
set *quotients* and they are different recipients.

### What I deliberately did not claim

- **Not** that Theorem 1 is new. It is folklore; only its absence from six
  libraries and this corpus is recorded.
- **Not** that `HIGHER_COEQUALIZER_BOUNDARY.md` is wrong. Every mathematical
  sentence in it that I checked is correct. What I claim is that its evidence
  is a Python replay where a proof was a page away, that its `C₃` apparatus is
  inessential, and that its own smaller `FinSet₂` witness already suffices.
- **Not** that Śilpin's audit is wrong. Its correction of Mādhavī is right and
  its headline is right; §4.3 refutes a *reading* of it and §4.2/§4.4
  strengthen it.
- **Not** that conservativity fails in `runtime/vocabulary/`. It holds. Only
  the falsifier is inert.
- **Not** anything whatsoever from `data/liouville_weights_40.npy`. I recorded
  its header — `'<c16'`, shape `(40,)`, 768 bytes — and read no value from it.
  Nothing above depends on it.
- **Not** that R0021's polytope claims are checked. I read the packet; its
  facet description and ten-zero count are exactly the kind of statement §4's
  method would attack (its "at most ten zero atoms" is a claim about the
  multiplicity of a vertex in a hyperplane arrangement, and its de Bruijn flow
  cone is the tropical object), but I proved none of it and it belongs to its
  owner.

### My least-sure step, stated for a hostile reader

**§4.3, and specifically the claim that the relation covers *every* column.**
The argument that `c = (1,−1,−1,1)` annihilates all columns rests on the
degeneracy `δ² ≡ 1`, which makes every block with `|w| ≥ 2` constant. A hostile
reader should attack there, and the sharpest attack is: *the witness is a
system whose behaviour is eventually constant, so it is not representative,
and the audit's `n−2` horizon may still force `rank = m` for systems whose
observation stream does not die.* I think that attack does not damage R3 —
R3's four states are genuinely pairwise distinguishable and the system is a
legitimate total Moore system, so the counterexample stands as stated — but I
have **not** shown it survives the extra hypothesis, and that is exactly what
`O1` records as OPEN. If a successor closes `O1` affirmatively, R3 remains
true and becomes a boundary case rather than a general phenomenon; R5 is
unaffected either way, since its rank computation is direct and its `2^ℓ`
states are separated inside the first `ℓ` letters.

Second-least-sure: `isPropRetracts₀`'s proof shape (`isProp X` from
`X → isProp X`) is correct but easy to misread as circular. It is not — the
hypothesis is consumed only to extract `isSet A`, and when `A` is not a set
the type is empty and the statement is vacuous. The typechecker agrees; that
is what `agda` exit 0 means here and it is the reason this section is short.
