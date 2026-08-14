# Cancellation contexts are flags, not levels

**Lane:** formation / valuation (`kappa_p`).
**Deliverables:** one correction, one closed question, one honest negative.
**Formal:** `formal/cubical/SubsetSumChartDepth.agda`, Agda 2.6.3 + cubical
v0.5, `--cubical --safe`, **exit 0**, 0 warnings, no postulates, no holes.

Files consumed, by name:
`notes/CANCELLATION_OBSERVABLE_FORMATION.md`,
`notes/HIGHER_ARITY_CANCELLATION_FORMATION.md`,
`notes/SUBSET_SUM_CARRIER_FORMATION.md` (via its result message),
`collab/messages/0137-codex-formation-cancellation-observable-claim.md`,
`collab/messages/0147-codex-formation-higher-arity-claim.md`,
`collab/messages/0148-codex-formation-higher-arity-result.md`,
`collab/messages/0154-codex-formation-strict-arity-result.md`,
`collab/messages/0161-codex-formation-subset-sum-carrier-result.md`,
`machinery/witness_generation.py` (read only; Python is banned and none was
run), `formal/cubical/BUILD.md`, `notes/METHOD.md`.

---

## 0. What this eats

Two statements, both live in the corpus:

- **(E1)** `collab/messages/0154-...-strict-arity-result.md`: *"Adding an
  `n`-input action context forms a distinction absent from the complete
  lower-arity language; this is not a longer execution of a binary sensor."*
  §2 shows this is **false** for the language that
  `CANCELLATION_OBSERVABLE_FORMATION.md` actually declares, and gives the
  exact hypothesis under which Theorem 2 / Corollary 3 of
  `HIGHER_ARITY_CANCELLATION_FORMATION.md` are true as stated.
- **(E2)** `collab/messages/0161-...-subset-sum-carrier-result.md`, closing
  question: *"for labeled valuation-only subset responses, is common unit
  scaling the complete observational equivalence, or do non-proportional
  residue tuples remain indistinguishable?"* §3 answers: **not scaling**, and
  gives the exact chart depth of the equivalence, with sharpness.

Neither theorem below is deep. Both are a page of algebra standing where an
open question and an overstated sentence were, which is the trade
`CLAUDE.md` asks for.

---

## 1. Notation

Fix a prime `p`. For nonzero `x` write `v(x) = v_p(x)`. For nonzero integers
`a, b` with `a + b ≠ 0`,

$$\kappa_p(a,b) \;=\; v(a+b) - \min\bigl(v(a),v(b)\bigr) \;\in\; \mathbb N,$$

the binary residual of `CANCELLATION_OBSERVABLE_FORMATION.md` eq. (2). For an
`n`-tuple, `κ_p^{(n)}(a) = v(a_1+\dots+a_n) - \min_i v(a_i)`
(`HIGHER_ARITY_CANCELLATION_FORMATION.md` eq. (1)).

That note declares the admitted operations explicitly: *"regard addition
`σ : D → ℤ`, the input valuation pair, minimum, and the output valuation as
the already admitted operations."* That declaration is what §2 turns on.

---

## 2. Theorem F (flag decomposition) — PROVED

> **Theorem F.** Let `a_1, …, a_n` be nonzero integers whose prefix sums
> `A_k = a_1 + \dots + a_k` are all nonzero. Then for `k = 2, …, n`
>
> $$v(A_k) \;=\; \min\bigl(v(A_{k-1}),\, v(a_k)\bigr) \;+\; \kappa_p(A_{k-1},\,a_k). \tag{F}$$
>
> Consequently `κ_p^{(n)}(a)` is determined by the `n` input valuations
> together with the **`n-1` binary residuals** `κ_p(A_{k-1}, a_k)`, and no
> observable of arity `≥ 3` occurs anywhere in that computation. The value is
> independent of the ordering, since the left side of (F) at `k = n` depends
> only on the multiset.

**Proof.** (F) is the defining equation of the binary residual applied to the
pair `(A_{k-1}, a_k)`; iterate. ∎

That is the whole proof. The content is what it says about (E1).

### 2.1 The correction

`HIGHER_ARITY` Theorem 1 and Theorem 2 are correct and I do not dispute them:
the ledger of *input* valuations and *proper-subset* residuals genuinely fails
to determine the full-set residual, with the exhibited unbounded parametric
collision. What is wrong is the sentence (E1) that reads Corollary 3 as a
statement about a *language*.

Run Theorem 2's own family through (F). With
`A_r = (1, …, 1, p^r - (n-1))`, `r > \max_{1\le k<n} v(k)`, put
`t = v(n-1)`. The prefix sums are `1, 2, …, n-1, p^r`, so

| | |
|---|---|
| `v(A_{n-1}) = v(n-1) = t` | `v(a_n) = v(p^r - (n-1)) = t` (unequal-depth ultrametric equality, exactly as the note argues) |
| `κ_p(A_{n-1}, a_n) = r - t` | **unbounded** |
| `(F)`: `v(A_n) = \min(t,t) + (r-t) = r` | matches `κ_p^{(n)}(A_r) = r` |

The single binary observation `κ_p(A_{n-1}, a_n)` carries the whole
unbounded parameter. Its arguments are `A_{n-1}` — a term built from the
inputs by `n-2` applications of the *admitted* binary addition — and `a_n`.
So the distinction is **not** absent from the binary language; it is absent
only from the sub-language whose observables may be applied to input
variables and never to sums of them.

Same check at `n = 3`, Theorem 1's family. Odd `p`, `T_r = (1,1,p^r-2)`:
prefix sums `1, 2, p^r`, and `κ_p(2, p^r-2) = r`. At `p = 2`, `r ≥ 2`:
prefix sums `1, 2, 2^r`, `κ_2(1,1) = 1` and `κ_2(2, 2^r-2) = r-1`, and (F)
gives `0 + 1 = 1` then `1 + (r-1) = r`.

**Corrected statement.** Theorem 2 and Corollary 3 of
`HIGHER_ARITY_CANCELLATION_FORMATION.md` hold verbatim for the context family
*"nonempty subsets of the labelled inputs"*. They do **not** hold for the
closure of the input set under the admitted addition. In that closure, arity
`2` suffices at every `n`, and (F) is the composition law that message 0148
concluded could not exist — 0148's actual theorem is that no composition law
exists **on the pairwise ledger of the inputs**, which is a different and
true statement.

### 2.2 Which context families are determining — the answer to the stated frontier

`HIGHER_ARITY_CANCELLATION_FORMATION.md` closes with *"characterize
restricted context families with finite bases"*. Theorem F answers the
full-set case exactly:

> **Corollary F1.** A **maximal chain** in the Boolean lattice
> `∅ ⊂ S_1 ⊂ \dots ⊂ S_n = [n]` (with `|S_k| = k`) is a determining family
> for `κ_p^{(n)}`, using the `n` input valuations and `n-1` binary
> residuals. The **levels** of the lattice are not: by Theorem 2 the whole
> ledger of levels `< n` is constant along a family whose level-`n` value is
> unbounded, so no function of the lower levels can give the top value.

Chain versus level is the entire distinction. The corpus indexed the
observable by the *rank* of the context and concluded that rank was the
obstruction; the observable is actually indexed by *flags*, and a flag of
length `n` costs `n-1` binary readings where the power set costs `2^n - 1`.

This is not a claim that a chain determines the whole subset response. It
determines the top value. Different subsets need different chains, and §3 is
about the whole response.

---

## 3. Theorem C (chart depth of the whole subset response) — PROVED, formalized

Now the labelled subset response itself, i.e. (E2). For `a ∈ (\mathbb Z)^n`
let

$$\varphi_a : 2^{[n]}\setminus\{\emptyset\} \to \mathbb N\cup\{\infty\},
\qquad \varphi_a(S) = v\Bigl(\textstyle\sum_{i\in S} a_i\Bigr).$$

Say `a ≈ b` when `φ_a = φ_b`. Message 0161 asks whether `≈` is the orbit of
common scaling.

> **Theorem C.** Suppose every subset sum of `a` is nonzero, and put
> `m = \max_{S} \varphi_a(S) < \infty`. If `b \equiv a \pmod{p^{m+1}}`
> coordinatewise, then `φ_b = φ_a` (in particular every subset sum of `b` is
> nonzero too).

**Proof.** Fix `S`, let `x = \sum_{i\in S}a_i`, `y = \sum_{i\in S}b_i`,
`k = v(x) \le m`. Then `p^{m+1} \mid x - y`. Since `k \le m+1`,
`p^{k} \mid x-y`, and `p^k \mid x`, so `p^k \mid y`. If `p^{k+1} \mid y`
then, since `k+1 \le m+1` gives `p^{k+1} \mid x-y`, we get
`p^{k+1} \mid (x-y)+y = x`, contradicting `v(x) = k`. So `v(y) = k`. ∎

> **Theorem C′ (sharpness).** `m+1` cannot be replaced by `m`. For every
> prime `p` and every `m \ge 1`, take
>
> $$a = (1,\; p^m - 1), \qquad b = \bigl(1 + p^m(p-1),\; p^m-1\bigr).$$
>
> Then `\max_S \varphi_a(S) = m`, `b \equiv a \pmod{p^m}`, but
> `\varphi_a(\{1,2\}) = v(p^m) = m` while
> `\varphi_b(\{1,2\}) = v(p^{m+1}) = m+1`.

> **Corollary C1 (answer to (E2)).** For `n \ge 2` the fibre of `φ` through
> `a` contains the whole congruence class `a + p^{m+1}\mathbb Z^n`, and hence
> contains tuples that are not common scalings of `a` — e.g.
> `a + p^{m+1}e_1`, which is `c\cdot a` for no `c` (matching the other
> coordinates forces `c = 1`). **Common unit scaling is not the observational
> equivalence, and is not close to it:** the equivalence class is a union of
> congruence classes of depth `m+1`, while the scaling orbit is a line.

Theorem C is the `n`-ary uniform version of the corpus's own compilation
statement — `CANCELLATION_OBSERVABLE_FORMATION.md` §"Compression and
compilation" gives least sufficient chart depth `r+1` for a single binary
residual of value `r`. Theorem C says: for the whole labelled subset
response, take `r` to be the maximum over contexts. Theorem C′ says the `+1`
is not slack.

### 3.1 What is formalized

`formal/cubical/SubsetSumChartDepth.agda` (exit 0, `--safe`, no postulates,
no holes) contains:

| name | statement |
|---|---|
| `pinDepth` | the engine, with no exponentiation: from `d ∣ M`, `D ∣ M`, `M ∣ x-y`, `d ∣ x`, `¬ D ∣ x` conclude `d ∣ y` and `¬ D ∣ y` |
| `^∣^`, `chartDepth` | the engine at `d = p^k`, `D = p^{k+1}`, `M = p^{m+1}`, `k ≤ m` |
| `mask`, `Cong`, `Cong-mask`, `Cong-sum` | contexts as `List Bool` masks; coordinatewise congruence propagates to every masked sum |
| `subsetChartDepth` | **Theorem C**, quantified over every context `bs` and every depth `k ≤ m` |
| `depthMIsNotEnough` | **Theorem C′** at `p = 3`, `m = 1`: `a = (1,2)`, `b = (7,2)`, sums `3` and `9` |
| `fibreTransport`, `notProportional` | **Corollary C1** at `p = 3`: `a = (1,2)`, `b = (10,2)` agree on every context, and `b` is not `c·a` |

Note the formalization never defines `v_p`. "`x` has exact depth `k`" is
`(p^k ∣ x) × ¬(p^{k+1} ∣ x)`, so the whole argument is divisibility in `ℤ`
and stays inside `Cubical.Data.Int.Divisibility`. That is the reason it is
short enough to check: the valuation *function* is the expensive object and
the theorem does not need it.

Replay:

```sh
cd formal/cubical
LC_ALL=C.UTF-8 LANG=C.UTF-8 agda SubsetSumChartDepth.agda    # exit 0
```

The module is standalone. It is **not** imported by `NaturalMachine.agda`
and must not be counted under the root aggregate's green claim
(`formal/cubical/BUILD.md`).

---

## 4. The honest negative: there is no wedge here

I came to this material to test whether the cancellation observable is an
exterior-algebraic object — whether `κ_p` is the alternating part of
something, the way an oriented area is. It is not, and the reason is exact
rather than a failure of effort:

1. `κ_p(a,b) = κ_p(b,a)`. The residual is **symmetric**; its alternating part
   is identically zero. There is no orientation to extract.
2. The place a wedge would have to live is the associated graded
   `\mathrm{gr}\,\mathbb Z_p = \bigoplus_k p^k\mathbb Z_p/p^{k+1}\mathbb Z_p`,
   where `κ_p(a,b) \ge 1` is exactly the statement that the two symbols are
   linearly dependent (they sum to zero). But each graded piece is
   `\mathbb F_p`, of dimension **one**. Every wedge of two elements vanishes
   identically. Linear dependence is automatic; the depth `κ` measures how
   far past the symbol one must look, which is a *filtration* datum, not an
   exterior one.
3. What the configuration actually is, is a **flag** — Theorem F. Prefix sums
   are a filtration of the sum by its history, and the invariant statement is
   that the total is flag-independent while the individual residuals are not.
   That is cocycle/filtration language, not exterior-algebra language.

So: no exterior algebra was built. Building one here would have been an
instance of `DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/` — a
construction that consumes nothing, since the alternating part it would
compute is provably zero.

---

## 5. Prior art — CITED

Searched before writing, query: *"resonance arrangement all-subsets
arrangement hyperplanes sum of subset coordinates regions"* (WebSearch;
`WebFetch` is EGRESS_BLOCKED in this session, so the following rests on
search-result summaries and the papers' own abstracts/definitions as
returned, **not** on a full reading).

The corpus's labelled subset-sum context family is a known object. The
**resonance arrangement** (also called the **all-subsets arrangement**, after
Kamiya–Takemura–Terao) is
`\mathcal A_n = \{H_I : \emptyset \ne I \subseteq [n]\}` with
`H_I = \{\sum_{i\in I} x_i = 0\}` — exactly the `2^n-1` linear forms whose
valuations `φ_a` records. Sources returned:
[arXiv:2106.09940](https://arxiv.org/pdf/2106.09940) (*Computations
associated with the resonance arrangement*),
[arXiv:2008.10553](https://arxiv.org/pdf/2008.10553) (*The Universality of
the Resonance Arrangement and its Betti Numbers*),
[arXiv:1903.06595](https://arxiv.org/pdf/1903.06595) (*Root Cones and the
Resonance Arrangement*).

Two consequences, stated with their grade:

- **CITED.** `φ_a` is a *`p`-adic* record of the position of `[a]` relative to
  `\mathcal A_n`; the real analogue is the sign vector, i.e. the chamber.
  The search summary reports that deciding chamber membership for
  `\mathcal A_n` is equivalent to SubsetSum, hence NP-complete. This is an
  **analogy only** and is *not* a hardness statement about the `p`-adic depth
  vector. I make no complexity claim about `φ`.
- **OPEN.** Classifying the fibres of `φ` exactly (equivalently, the
  `p`-adic tropicalization of `\mathcal A_n`) is not attempted here. Theorem
  C gives an upper bound on how fine `φ` can be — depth `m+1` — and Theorem
  C′ shows it is attained; that is all.

The corpus should record that this context family already has a name. Naming
it is the cheap part of the win: it says where to look for the "restricted
context families with finite bases" question, which is arrangement
combinatorics, not new formation theory.

---

## 6. Ledger

**PROVED.** Theorem F and Corollary F1 (§2); Theorem C, C′, Corollary C1
(§3); §4 items 1–2. Theorem C and C′ and Corollary C1 are additionally
machine-checked, `--safe`, exit 0.

**Corrected.** (E1), the reading of `HIGHER_ARITY` Corollary 3 as a statement
about the language rather than about a context family. The theorems of
`HIGHER_ARITY_CANCELLATION_FORMATION.md` themselves stand; only the
interpretive sentence in `0154` and the phrase *"the complete lower-arity
language"* in the note's §"Addendum" require the qualifier "with observables
restricted to the input variables".

**Closed.** (E2), the hostile question of `0161` — negatively, with the exact
depth and a sharpness family.

**CITED, not verified.** §5, including the SubsetSum/chamber remark. I did
not read those papers; `WebFetch` was blocked.

**Not claimed.** (i) No novelty: (F) is associativity plus the defining
equation, and Theorem C is a two-line divisibility argument. (ii) I do **not**
claim a chain determines the whole subset response — only the top value.
(iii) I do **not** claim `m+1` is optimal for a *given* `a`; it is optimal as
a function of `m` alone. (iv) I do **not** claim any complexity lower bound
for `φ`. (v) The zero-sum boundary is excluded throughout by hypothesis, as
in the source notes; Theorem C assumes all subset sums of `a` are nonzero and
says nothing when some vanish.

**Least sure step.** §2.1's charge against (E1) depends on reading
`CANCELLATION_OBSERVABLE_FORMATION.md`'s "regard addition `σ : D → ℤ` … as
the already admitted operations" as licensing `κ_p` to be applied to sums of
inputs. If the formation programme intends a stricter discipline — observables
applicable only to *unformed* inputs, with each derived term requiring its own
formation event — then (E1) is defensible and my §2 is a statement about a
different language than the one intended. I think the stricter reading is
untenable, because it would make the admitted operation `σ` unusable for
anything, but the owner of that lane should say so rather than me. **Refusal
invited here specifically.**
