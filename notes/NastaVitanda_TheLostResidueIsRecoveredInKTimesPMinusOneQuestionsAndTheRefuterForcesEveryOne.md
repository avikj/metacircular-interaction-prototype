# नष्ट · वितण्डा — the lost residue, and the refuter who forces every question

**Terms, texts, dates.**

- **नष्ट · naṣṭa**, "the lost" — Piṅgala, *Chandaḥśāstra* 8.24–25 (~300 BCE);
  worked in Halāyudha, *Mṛtasañjīvanī* (10th c.). The procedure that recovers
  an unknown pattern **one place at a time**, by a rule applied to the index,
  with no table consulted. Its inverse is *uddiṣṭa*.
- **वितण्डा · vitaṇḍā** — Gautama, *Nyāyasūtra* 1.2.3 (~2nd c. CE). The third
  kind of debate: **bare refutation, holding no position of one's own.** The
  vaitaṇḍika answers, denies, and never commits to a thesis.

**What is and is NOT claimed of these sources.** Piṅgala does not state this
theorem and did not work over ℤ/p^kℤ; *naṣṭa* is named here because the
upper-bound protocol has exactly its shape — resolve one place, descend, never
consult a table. Gautama does not state this theorem either; *vitaṇḍā* is named
because the lower-bound argument is precisely a debater who answers every query
consistently while never naming a residue, and only names one when cornered at
the last place. Neither is a claim of priority. The mathematics below is this
repository's, proved between 2026-08-12 and 2026-08-14, four times.

---

## 0. Why this note exists

The cost law **k(p−1)** is the corpus's most-cited exact cost. It is proved
**four times in four files, three of them announcing it as new, none citing
another**, and until 2026-08-22 it was **formalized nowhere** — zero occurrences in
`formal/cubical/` or `formal/pairfield/`. Ten further notes depend on the
number and different ones cite different proofs.

**It is now checked, both halves:**
`formal/cubical/NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne.agda`,
`--cubical --safe`, no postulates, no holes, imported by `Everything.agda`.
See §6.

This note states it **once**, with the model made explicit, and records the
four derivations as history rather than as rivals.

**The model is the thing that was missing.** `notes/CARR_LEDGER.md` §C6 is a
declared cold replay that had to *reconstruct* the query model "from the two
numbers, since the statement does not give it". That reconstruction succeeded,
and the fact that it was necessary is the diagnosis: four write-ups of a
theorem and no canonical statement of what it quantifies over.

---

## 1. The model, stated in full

Fix a prime `p ≥ 2` and `k ≥ 1`. Write `R_k = ℤ/p^kℤ`.

**Oracle.** A *query* names a center `c ∈ R_k`. Against a hidden `r ∈ R_k` it
returns

```text
q_c(r) = min( v_p(r − c), k )   ∈ {0,1,…,k}.
```

**Sign convention — the only difference among the four write-ups.**
`ADAPTIVE_VALUATION_CENTERS.md` and `ADAPTIVE_VALUATION_IDENTIFICATION.md`
write the oracle as `τ_k(r + c) = min(v_p(r+c), k)`; `OPTIMAL_…` and
`CARR_LEDGER` write `q_c(r) = min(v_p(r−c), k)`. These are the same oracle
under `c ↦ −c`, which is a bijection of `R_k`, so the two families of
strategies are in cost-preserving correspondence. **Nothing else in the four
statements differs.** This note uses `q_c(r) = min(v_p(r−c), k)`.

**Strategies.** A strategy is a deterministic adaptive decision tree: an
internal node names a center, its `k+1` children are indexed by the response,
and a leaf names a residue. The tree *identifies* if for every `r ∈ R_k` the
walk driven by truthful responses reaches a leaf labelled `r`.

**Cost.** The number of queries on the walk. `D(p,k)` is the least, over
identifying trees, of the worst case over `r`.

**What is free.** Everything but oracle calls: arithmetic, memory, and the
construction of centers. Charging for those can only raise the cost, so the
lower bound survives any such refinement; it does **not** combine additively
with construction cost — see `notes/PROBE_COST_DESCENT_NO_GO.md`.

**What this is not.** It is not the nonadaptive count. A fixed center set whose
whole response vector identifies every `r` has size exactly `(p−1)p^{k−1}`
(`notes/MINIMUM_VALUATION_PROBE_BASIS.md`), which bounds a *static resource*,
not query cost on an input. It is not a memory bound either: after
identification the state alphabet is still `p^k`.

**The digit reading, which is the whole content.** Write `r = Σ_{i<k} x_i p^i`
and `c = Σ_{i<k} c_i p^i`, low digit first. Then

```text
q_c(r) = min { i : x_i ≠ c_i },   and = k if all digits agree.
```

So the oracle is exactly the **longest-common-prefix oracle** on strings of
length `k` over an alphabet of size `p`. Everything after this is an adversary
argument on strings.

## 2. The theorem

> **Theorem (naṣṭa–vitaṇḍā).** `D(p,k) = k(p−1)`.

### 2.1 Upper bound: `D(p,k) ≤ k(p−1)` — naṣṭa

Suppose the low `j` digits are known, so `r ≡ a (mod p^j)`. For
`d = 0,…,p−2` query `c_d = a + d·p^j`. If `q_{c_d}(r) ≥ j+1` the next digit is
`d`. If all `p−1` responses equal exactly `j`, the digit is the sole untested
value `p−1`. So `p−1` queries settle one place. A response deeper than `j+1` is
permitted and is simply used: it certifies further digits and can only skip
work. Repeating for `j = 0,…,k−1` gives `k(p−1)`.

The residue `−1 mod p^k` (all digits `p−1`) forces every one of these queries
for this strategy, so `k(p−1)` is attained, not merely bounded.

### 2.2 Lower bound: `D(p,k) ≥ k(p−1)` — vitaṇḍā

Fix any identifying tree `T`. The adversary holds no residue. Its state is

```text
(l, a_0,…,a_{l−1}, F),   0 ≤ l ≤ k,   F ⊆ {0,…,p−1},   F = ∅ when l = k,
```

with **consistent set**

```text
S(l,a,F) = { x ∈ R_k : x_i = a_i for i < l, and x_l ∉ F }
```

(read `S = {a}` when `l = k`). Initially `l = 0`, `F = ∅`, `S = R_k`. The
invariant: every `x ∈ S` is consistent with every answer given so far, hence
drives the identical walk. On a query `c`:

1. **`c_i ≠ a_i` for some `i < l`.** Answer the least such `m`. Correct for all
   of `S`. State unchanged.
2. **`c` agrees below `l` and `c_l ∈ F`.** Answer `l`. Correct for all of `S`.
   State unchanged.
3. **`c` agrees below `l`, `c_l ∉ F`, `|F| ≤ p−3`.** Answer `l` and set
   `F := F ∪ {c_l}`. At least `p − |F| − 1 ≥ 2` digits remain live, so the new
   `S` is nonempty and the answer is correct on it.
4. **As 3 but `|F| = p−2`.** Two values remain, `c_l` and one other `e`.
   Answer `l`, which forces `x_l = e`; set `a_l := e`, `l := l+1`, `F := ∅`.
5. **`l = k`.** `S` is a singleton; answer truthfully.

**Potential** `Φ = l·(p−1) + |F|`. Initially `0`. Cases 1, 2, 5 leave `Φ`
fixed; case 3 raises it by exactly `1`; case 4 replaces `l(p−1)+(p−2)` by
`(l+1)(p−1)`, again exactly `1`. So each query raises `Φ` by at most `1`, and
after `t` queries `Φ ≤ t`.

At a leaf, if `l < k` then `|F| ≤ p−2`, so at least two digit values are live
at place `l` and `|S| ≥ 2`; all of `S` reaches that one leaf, contradicting
identification. Hence `l = k` at every leaf, so `Φ = k(p−1)` and `t ≥ k(p−1)`.
`T` was arbitrary. ∎

**Why the extra informativeness of the oracle buys nothing.** The adversary
never once answers `≥ l+1`. A deep response is informative only when the
algorithm has guessed a prefix correctly, and the adversary never lets it.

**Why a counting bound cannot reach this.** A depth-`d` tree with `(k+1)`-ary
branching has `(k+1)^d` leaves, giving only `d ≥ k·log p / log(k+1)` — for
`p = 3, k = 8` that is `d ≥ 4` against the truth `16`.

---

## 3. The four derivations, as history

All four are correct. Ordered by commit time, not by rank.

| # | file | commit | date, time | what it proved |
|---|---|---|---|---|
| 1 | `notes/ADAPTIVE_VALUATION_CENTERS.md` §2 | `045ea1b1` | 2026-08-12 03:35 | Upper bound only. **Refuses optimality**: *"It must not be reported as `(p-1)k` without a lower bound."* |
| 2 | `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` | `96b3dc24` | 2026-08-12 03:37 | Both bounds. Ball-and-live-children adversary. |
| 3 | `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md` | `4017f526` | 2026-08-12 03:45 | Both bounds, **identical** to #2 — same digit protocol, same adversary — differing only in the sign of the center (`τ_k(r+c)` vs `q_c(r)`). |
| 4 | `notes/SEED30_LOWER_BOUND_AUDIT.md` §3.3, "Theorem W" | `219c358e` | 2026-08-14 | Lower bound, third time. Read #1 alone, recorded the bound as *"the honest open item"*, and claimed to close an item that had been closed 48 hours earlier, twice. |
| — | `notes/CARR_LEDGER.md` §C6 | — | 2026-08-14 | A **declared cold replay**, legitimate by construction, not a rival. It reconstructs the model from the two numbers *"since the statement does not give it"* — which is the evidence that no canonical statement existed. |

**#2 and #3 were written eight minutes apart.** Neither cites the other.

**#4 is the sharpest of the three lower-bound proofs and is still a re-proof.**
Its potential function `Φ = l(p−1) + |F|` is what §2.2 above uses; #2 and #3
argue by "`p−1` distinct live children must be hit", which is the same content
without the accounting made explicit. Nothing is withdrawn from #4 except its
claim to be first.

**No derivation is deprecated.** Four independent arrivals at the same constant
by the same two moves is evidence the theorem is right. What was wrong was the
absence of a single statement they could all point at, and the false claim of
novelty attached to three of them.

## 4. Downstream

`k(p−1)` is load-bearing in at least these, which cite different members of the
table above:

`notes/END_TO_END_VALUATION_PROGRAM.md` (24, 33) ·
`notes/EXPLICIT_COMPILER_LOWER_BOUND.md` (27, 47, 52) ·
`notes/OUTPUT_SENSITIVE_CLEAN_COST.md` (51) ·
`notes/CLEAN_REVERSIBLE_VALUATION_PROGRAM.md` (37, 76) ·
`notes/ADAPTIVE_CENTER_CHAIN.md` (32) · `notes/MINIMAL_BRANCH_STATE.md` (51) ·
`notes/EXPECTED_QUERY_ORDER.md` (65) · `notes/TERNARY_GROVER_VALUATION.md` (5).

A downstream note that needs the *optimality* (not just the protocol's cost)
should cite §2.2 of this file.

## 5. The reward gradient, running in the open

`CLAUDE.md`: *"An agent gets a green checkmark for a module and gets nothing at
all for a week of reading, so the pull toward treating formalization as 'the
real work' is structural."*

Here the same gradient ran the other way and produced its mirror image.
**Four prose write-ups, zero formalizations.** Grepping `formal/cubical/` and
`formal/pairfield/` for this theorem returns nothing. The corpus's most-cited
exact cost law is checked by no kernel anywhere, while three agents each
received the full local reward of announcing a theorem.

Two failures, one mechanism, and the second is the one this note cannot fix by
being written:

1. **Nobody grepped for the work before doing it.** `CLAUDE.md` already carries
   the check — *"before writing about a source, grep `notes/` for the text's
   name"* — and it is the same move here: grep the corpus for the *number*
   before proving the theorem that produces it. `k(p-1)` and `k(p−1)` are two
   distinct grep strings; both were already in `notes/` on 2026-08-12 03:37.
2. **The write-up was the terminal deliverable.** A fifth prose proof would
   have been accepted the same way the fourth was. The thing that would have
   made the redundancy visible at the moment of the act — a module named for
   the theorem, which a second author must either import or collide with —
   is exactly the artifact none of the four produced.

**Formalization status, dated 2026-08-22.** Done, both halves, in the same
pass that wrote this note:
`formal/cubical/NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne.agda`,
`--cubical --safe`, no postulates, no holes, `agda` exit 0, and imported by
`Everything.agda` — a module nothing reaches is verified by nothing. Shipping
the upper bound alone was available and was not taken: it would have reproduced
derivation 1's own honest refusal wearing a green checkmark.

## 6. What is checked, and how the model reaches Agda

The digit reading of §1 is what crosses into the module — `v_p` never appears
there. `Word n` is a length-`n` string over `Fin (suc q)`; writing `p = q+1`
keeps every count in ℕ with no truncated subtraction, so `k(p−1)` is `k · q`.
`resp` is the first-mismatch index, which §1 shows *is* `q_c(r)`.

```agda
data Tree : ℕ → Type₀ where
  leaf : {n : ℕ} → Word n → Tree n
  ask  : {n : ℕ} → Word n → (ℕ → Tree n) → Tree n

Identifies T = (x : Word n) → run T x ≡ x
```

The two halves, as they stand in the module:

```agda
upperBound : (n : ℕ) → Σ[ T ∈ Tree n ] (Identifies T × ((x : Word n) → cost T x ≤ n · q))
lowerBound : (n : ℕ) (T : Tree n) → Identifies T → Σ[ x ∈ Word n ] (n · q ≤ cost T x)
```

Three choices are worth recording, because each removed a large amount of work:

1. **The lower bound is stated as cost ON AN INPUT, not as tree depth.** It is
   the stronger reading — depth follows — and it avoids any maximum over the
   branching, which is infinite here because responses are typed by ℕ.
2. **The potential function `Φ` of §2.2 is not needed in the formal proof.**
   The induction is on the word length `n`; inside it, a list `Live` of digits
   still live at place `0` is carried and the induction is *structural on the
   tree*. `Live = [e]` restricts the tree to inputs with head `e` and recurses
   on `n`; `|Live| ≥ 2` with a leaf is impossible (two live heads reach one
   leaf); `|Live| ≥ 2` with `ask c f` answers `0`, strikes `head c` from `Live`
   if present, and recurses on `f 0`, a structural subterm. `Φ` is exactly the
   accounting that this recursion performs for free.
3. **No `with` in any recursive definition.** Each is written through a `decRec`
   eliminator, so the downstream lemmas reduce definitionally instead of
   fighting a generated auxiliary function.

The upper bound is built by the same recursion: a chain of `p−1` asks over the
digits, each failure moving to the next, the last digit inferred rather than
tested — which is `naṣṭa`, and which is why the two halves meet.

**One honest note on the green.** `agda` exits 0 with no errors, but emits
`UnsupportedIndexedMatch` warnings: pattern matching on the ℕ-indexed `Word`
and on `List` relies on constructor injectivity, which Cubical Agda does not
yet support, so those functions do not compute when applied to *transports*.
Nothing here is applied to a transport — every definition runs on concrete
data — and the warnings bear on computation, not on soundness or on the
statement proved. They are recorded because a green that is not stated in full
is how this corpus has gone wrong before.

Non-vacuity is not a matter of trust: `upperBound` exhibits an identifying tree,
so `Identifies` is satisfiable, and `lowerBound` exhibits a real input. The
definitions were additionally evaluated by the kernel at `p = 2, k = 2`, where
the constructed protocol costs exactly `2 = k(p−1)` on both extreme inputs.

## 7. Rigor boundary

Proved: `D(p,k) = k(p−1)` in the model of §1 — deterministic, exact responses,
arbitrary centers, oracle calls the only cost. Machine-checked: **both halves**,
as §6. What is *not* machine-checked is §1's reduction itself — that
`min(v_p(r−c), k)` on ℤ/p^kℤ is the first-mismatch oracle on base-`p` digit
strings. That step is proved in prose here and in `SEED30_LOWER_BOUND_AUDIT.md`
§3.2, and it is taken as the definition in Agda; a module that carries `v_p` and
`ℤ/p^kℤ` explicitly and derives the digit reading is the honest next piece, and
it is not written.

No claim is made about randomized or quantum query complexity, about the cost
of *constructing* centers, about memory, or about any Boolean-threshold
weakening of the oracle. `machinery/adaptive_valuation_probes.py` still exists
on disk (2511 bytes, last touched by `4017f526`, 2026-08-12) and is a replay of
the upper-bound protocol only; it is not evidence for §2.2, and under `CLAUDE.md`
it is legacy — not to be run, extended, or cited as a certificate for the
theorem. Note also that `OPTIMAL_ADAPTIVE_VALUATION_PROBES.md:92` cites it under
`machinery/`, which is not the `machine/` directory the rest of the corpus uses;
both directories exist and they are different things.
