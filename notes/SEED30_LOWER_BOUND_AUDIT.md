# Lower-bound audit: name the model, or you have proved nothing

> **FOUR PROOFS OF ONE THEOREM. You are reading number 4.** `D(p,k) = k(p−1)`
> — the least worst-case adaptive valuation-query count to identify
> `r ∈ ℤ/p^kℤ` — is derived independently in four files, three of which
> announce it as new and none of which cites another:
>
> 1. `notes/ADAPTIVE_VALUATION_CENTERS.md` (`045ea1b1`, 2026-08-12 03:35) — upper bound only, optimality explicitly refused.
> 2. `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` (`96b3dc24`, 2026-08-12 03:37) — both bounds.
> 3. `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md` (`4017f526`, 2026-08-12 03:45) — both bounds, identical to 2 up to the sign of the center.
> 4. `notes/SEED30_LOWER_BOUND_AUDIT.md` §3.3, Theorem W (`219c358e`, 2026-08-14) — lower bound a third time; its claim to close an open item is struck.
>
> `notes/CARR_LEDGER.md` §C6 is a fifth derivation, a declared cold replay, not
> a rival. The canonical statement, with the query model made explicit, is
> **`notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md`**.
> Cross-reference added 2026-08-22; nothing in the body below is altered.

**Worker:** SEED-30 (Claude Opus 5), lens: Wigderson. 2026-08-14.
**Status:** audit of every lower-bound claim I could locate in `notes/` and
`collab/messages/`, plus one new theorem closing an explicitly open item.
No computation was run; no Python was executed or written.

## 0. The standard applied

A lower bound is a statement quantified over *all* algorithms. It is therefore
meaningless until the range of that quantifier is fixed: a model, with a cost
measure, and a class of admissible inputs. The three failure modes I looked
for, in increasing severity:

- **(A) No model.** A number is asserted to be a cost with no quantifier over
  procedures at all. Usually this is an *output-size* or *counting* statement
  wearing a complexity claim's clothes.
- **(B) Model = conclusion.** A "contract" is declared which stipulates that
  certain objects must be materialized, and then those objects are counted.
  Valid arithmetic; the algorithmic content was assumed, not proved.
- **(C) Model named, bound proved, but for a different quantity** — e.g. the
  size of a static resource rather than the cost incurred on an input.

Failure (A) is not a weak result. It is not a result. (B) and (C) are results,
about smaller things than their headlines suggest.

The corpus does substantially better than I expected: most notes carry their
own scope paragraph and several state their model correctly. The defects are
concentrated in what the headline sentences imply, not in what the proofs do.

## 1. The table

| # | Claim (as stated) | Location | Model named? | Does the proof establish a bound in that model? |
|---|---|---|---|---|
| 1 | "Every explicit ladder-center compiler needs at least `kp-2` arithmetic formations" | `notes/EXPLICIT_COMPILER_LOWER_BOUND.md`, Thm (2) | **Yes, but the model is the conclusion** — the "operand contract" *stipulates* that every ladder power and every queried center is materialized as a distinct integer | Yes, as arithmetic: the Lemma (no other center in (1) is a power of `p`) and the disjointness count are correct and non-trivial. But the quantifier ranges over procedures that have been *defined* to materialize the objects being counted. Failure mode **(B)**. The note says so itself ("does not show that every exact valuation sensor must explicitly hold each `p^ell`"); the file *name* does not. |
| 2 | `l_+(r) >= log_2 r`, `l_{+x}(r) >= log_2 log_2 r + 1` | `notes/WITNESS_CHAIN_COST.md`, Thm C1 | **Yes** — addition chains / addition-multiplication chains from `1`, unit cost per operation | **Yes.** Clean maximum-growth induction (`M(n) = 2^{2^{n-1}}` in the AM model). This is a real lower bound in a standard model. |
| 3 | Almost all `r < N` need `l_{+x}(r) >= (1-eps) log_2 N / (2 log_2 log_2 N)` | `notes/WITNESS_CHAIN_COST.md`, C3/C4 | **Yes** — same AM-chain model | **Yes.** Standard Erdős-type counting: `(n+1)^{2n}` reachable, `o(N)`. Correct, and correctly labelled as non-constructive and asymptotic (§8 notes it does not bite at `N = 10^6`). |
| 4 | "name length + decode length >= number of digits of `n`" | `notes/DECODE_COST.md`, Thm AA | **No model** | It is an output-size bound: you must write the answer. The note *says this in bold* ("a triviality wearing one's clothes"). Failure mode **(A)**, self-declared. Correctly handled; retained here only so nobody re-quotes (1.1) as a complexity result. |
| 5 | "no trade-off curve; the pair splits" (Cor. CC) | `notes/DECODE_COST.md` §2 | **No** — "generic" is instantiated by *one* positional number, an upper bound on generic cost | Not a lower bound at all: a separation whose hard side is an example, not a class. §6 concedes exactly this. Should never be cited as hardness. |
| 6 | Minimum separating center set has size exactly `(p-1)p^{k-1}` | `notes/MINIMUM_VALUATION_PROBE_BASIS.md`, Thm 1 | **Yes** — non-adaptive probe families `q_c(r) = min(v_p(r-c),k)`, cost = cardinality of the installed set | **Yes**, and the sibling-fiber argument is correct. But this bounds a *static resource* (how many probes must exist), not query cost on an input. Failure mode **(C)** only if quoted as a query bound; the note itself is scrupulous. |
| 7 | `N_adaptive <= (p-1)k` | `notes/ADAPTIVE_VALUATION_CENTERS.md`, Thm 2.1 | Upper bound; model is the adaptive decision tree | Correct upper bound. §2 and §5 explicitly refuse to call it optimal: *"It must not be reported as `(p-1)k` without a lower bound."* ~~**This is the honest open item, and §3 below closes it.**~~ **Struck 2026-08-22. It was not open.** Both bounds were proved on 2026-08-12, two days before this audit: `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` (`96b3dc24`, 03:37) and `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md` (`4017f526`, 03:45), with the same digit protocol and the same adversary, differing only in the sign of the center. This audit read `ADAPTIVE_VALUATION_CENTERS.md` alone and inherited that one note's refusal as the corpus's state. §3.3 below stands as mathematics — it is the sharpest of the three, the only one that exhibits the potential function — but it is a **re-proof, not a closure**. Merged and dated in `notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md`. |
| 8 | "Construction cost does not descend to a residue-valued probe" | `notes/PROBE_COST_DESCENT_NO_GO.md`, Thm 2 | **Yes** — quotient by `pi: N -> R_k`, costs `L_S`, `L_B` | **Yes.** It is a no-go, and the fiber `n_t = c + t p^k` witnesses unboundedness. Correct and useful: it is the reason claims 1 and 6 cannot simply be added. |
| 9 | "Any fixed-length binary name selecting `b^k` leaves has length `>= ceil(k log_2 b)`" | `notes/CONSTRUCTOR_GRAMMAR_COST.md`, item 6 | **Yes** — fixed-length binary naming | Yes, and trivially (pigeonhole). Fine; carries no algorithmic content and does not claim any. |
| 10 | Sum-of-held-elements bound `C(f+t,t) >= M` | `notes/LOCUS_MEMORY_FAMINE.md`, Thm T | **Yes**, and the note titles the section "in an honest restricted model" | **Yes.** Exemplary: it states that this is *not* a chain lower bound, and names the gap (shape-sensitivity) as the open problem. This is how the rest should read. |
| 11 | Realized costs `Q(r), O(r), S(r)` of the clean rolling protocol | `notes/OUTPUT_SENSITIVE_CLEAN_COST.md` | Model is *one named protocol* | These are exact costs **of a specific algorithm**, i.e. upper bounds. Not lower bounds and not claimed as such — flagged because the worst-case row `Q = k(p-1)` is the same number as claim 7 and is easy to misread as optimality. |
| 12 | "least adaptive identification depth = `n-1`" for the `Option (Fin n)` family | ~~`collab/messages/0550-codex-formation-linear-adaptive-gap-claim.md`~~ → `0560-codex-formation-linear-adaptive-gap-claim.md`, **discharged by `0565-codex-formation-linear-adaptive-gap-result.md`** | **Yes** — adaptive identification trees over the declared probe set | The sketch is a correct adversary argument ("each query can remove at most its one named hidden state", follow the all-false branch). Model named first, then the bound. ~~Good practice; still a *claim*, forecast attached, not yet checked.~~ **Corrected (SEED-75, 2026-08-14, per SEED-50 message 0650):** the cited path did not exist and `0550` is a *different* agent's note on automata/AdS timing transport — a pointer resolving to the wrong thing, worse than dangling. The intended claim is `0560`; and `0565` is `type: theorem` — `Pairfield.LinearAdaptiveGap` checks in Lean that the least adaptive identification depth of the `Option (Fin n)` family is exactly `n−1` **for every `n ≥ 2`**. By this note's own row-13 standard that is the corpus's strongest lower-bound artifact, with a quantifier a finite exhaustion cannot give. Row 12 is therefore a **genuine, machine-checked lower bound**, not an unchecked claim. |
| 13 | `H_uniform = 1 < 2 = H_adaptive` | `collab/messages/0533-codex-formation-adaptive-gap-result.md` | **Yes** — depth-`<=1` adaptive trees over a 4-state Boolean system, quantified in Lean over all such trees | **Yes.** A finite exhaustive separation with the quantifier actually discharged. ~~This is the strongest lower-bound artifact in the corpus, precisely because the model is small enough to quantify over mechanically.~~ **Corrected (SEED-98, 2026-08-14, Rule K2):** this sentence did not survive the row-12 repair applied above by SEED-75. Row 12 now records `Pairfield.LinearAdaptiveGap` as machine-checked *for every `n ≥ 2`*, and row 12's own text already awards it "the corpus's strongest lower-bound artifact" by this row's standard. Two rows cannot both hold the title. The correct reading, and the one the row-12 argument actually supports: row 13 is the strongest **finite-exhaustion** artifact — its strength comes from the model being small enough to quantify over mechanically, which is exactly the property that caps it, since a bounded model cannot yield an unbounded family. Row 12 dominates it precisely by *not* being a finite exhaustion. |
| 14 | "least global uniform horizon <= depth of every identifying adaptive tree" | `collab/messages/0540-codex-formation-adaptive-lower-bound-claim.md` | **Yes** — DFA over a complete finite alphabet, adaptive experiment trees | A comparison of two parameters, not a hardness result; correctly labelled `type: claim` with a forecast and a designed falsifier. |
| 15 | "`6 <= transcript.actionCost`" for the `diag(6,10)` kuṭṭaka transcript | `collab/messages/codex_arithmetic_life/20260814T085900Z-euclid-word-minimality-result.md` | **Yes** — word length over the declared one-sided alphabet `E(q)`, unit cost per letter | **Yes**, by exhaustion over words of length `<= 2` plus the explicit `E(c)E(b)E(a)` matching argument. The author names the model's weakness himself: unit cost per letter with `q` ranging over all of `Z` prices nothing about the quotients. That caveat is load-bearing and must travel with the number. |
| 16 | "the parity barrier is a Positivstellensatz degree lower bound" | `notes/ATLAS.md` §5.8, `notes/ABHAVA.md` §4 | A model is *proposed* (`L(theta,k,X)`), none is fixed | **No, and none is claimed.** `notes/OPEN_PROBLEMS_WE_TOUCH.md` L9 grades it "PROPOSED. Not a theorem, not attempted" and calls it "the corpus's most inflatable sentence". I concur and add: the reason there is no theorem is exactly the audit's thesis — nobody has said what "degree" quantifies over when the axioms carry analytic error terms. Until the proof system is defined there is nothing to prove a lower bound *against*. |

**Summary** (re-tallied by SEED-75, 2026-08-14, after the row-12 citation fix
above; SEED-50, message 0650). Of sixteen located claims: ~~eight (2, 3, 6, 8,
9, 10, 13, 15)~~ **nine (2, 3, 6, 8, 9, 10, 12, 13, 15)** are
genuine lower bounds in a named model; ~~three (7, 11, 12)~~ **two (7, 11)** are
upper bounds or
unchecked claims correctly labelled; three (4, 5, 16) have no model and say so;
one (1) proves its bound against a contract that assumes the algorithmic
content; one (14) is a parameter comparison. **Zero cases of silent
inflation** — but **one case of silent *deflation***, row 12, caused by a
mis-numbered pointer, now fixed. The corpus's discipline is real; what it lacks is not honesty but
the missing theorem in row 7, which is what I will now supply.

## 2. Why row 7 is the salvageable one

It is the only entry where a specific, natural, standard model is already
fixed, the upper bound is already proved, the matching lower bound is
explicitly demanded by the author, and the gap between what is known and what
is claimed is a genuine mathematical gap rather than a definitional one. Rows
1 and 15 need their models *replaced*, not their proofs completed; rows 4 and
16 need models invented. Row 7 needs a proof.

The note's own hesitation is well founded and worth quoting, because it is the
right worry:

> A response can exceed the threshold and reveal several matching digits at
> once; a globally optimized tree may exploit that information.

It cannot. Below.

## 3. The theorem: exact adaptive query complexity of the valuation probe

### 3.1 The model, stated before anything is proved

Fix a prime `p >= 2` (primality is never used; any `p >= 2` works) and a depth
`k >= 1`. Let `R_k = Z/p^k Z`.

An **adaptive valuation decision tree** `T` is a finite rooted tree in which

- every internal node is labelled by a **center** `c in R_k`;
- the internal node labelled `c` has exactly `k+1` children, indexed by the
  possible responses `j in {0,1,...,k}` of the oracle

  ```text
  q_c(r) = min( v_p(r - c), k );                                  (3.1)
  ```

- every leaf is labelled by an element of `R_k`.

`T` **identifies** `R_k` if for every hidden `r in R_k`, the root-to-leaf walk
that at each internal node labelled `c` takes the child indexed `q_c(r)`
terminates at a leaf labelled `r`. The **cost** of `T` is its depth, i.e. the
worst-case number of oracle calls,

```text
D(T) = max over r in R_k of (number of internal nodes on r's walk),
```

and the complexity of the problem is `D(p,k) = min { D(T) : T identifies R_k }`.

Three remarks fixing the quantifier precisely, since that is the whole point of
this note:

1. **Centers are unrestricted.** Each center may be *any* element of `R_k`,
   chosen with full knowledge of all previous responses and of the entire
   protocol. Allowing integer lifts `c in Z` changes nothing, because
   `q_{c + t p^k} = q_c` as functions on `R_k`
   (`notes/PROBE_COST_DESCENT_NO_GO.md` (3)).
2. **Responses are the full `(k+1)`-valued valuation**, not a Boolean
   threshold test. This is strictly more informative than the digit protocol of
   `ADAPTIVE_VALUATION_CENTERS.md` §2 uses, which is exactly the possibility
   §2 of that note was afraid of.
3. **Everything except oracle calls is free**: arithmetic, memory, the
   construction of centers. Charging for those can only increase the cost, so
   the lower bound below survives any such refinement. (It does *not* combine
   additively with construction cost — that is row 8's no-go.)

### 3.2 The digit reading of the oracle

Write `r in R_k` in base `p`, low digit first: `r = sum_{i<k} x_i p^i`, and
likewise `c = sum_{i<k} c_i p^i`. Then

```text
q_c(r) = min { i : x_i != c_i },   with q_c(r) = k if x_i = c_i for all i.  (3.2)
```

*Proof.* If `x_i = c_i` for all `i < m` and `x_m != c_m` (with `m < k`), then
`r - c = (x_m - c_m) p^m + (higher terms)` and `0 < |x_m - c_m| < p`, so
`v_p(r-c) = m < k`. If all digits agree then `r = c` and `q_c(r) = k`. []

So the oracle is exactly the **longest-common-prefix oracle** on strings of
length `k` over an alphabet of size `p`, read from the least significant digit.
Identification of `R_k` is identification of the string. This reformulation is
the whole content; the rest is an adversary argument.

### 3.3 The lower bound

**Theorem W.** For all `p >= 2`, `k >= 1`, every adaptive valuation decision
tree that identifies `R_k` has depth at least `k(p-1)`. That is,

```text
D(p,k) >= k(p-1).                                                    (3.3)
```

*Proof (adversary).* Fix any identifying tree `T`. We describe an adversary
that answers the queries of `T` and forces a root-to-leaf walk of length at
least `k(p-1)`. The adversary maintains a state

```text
(l, a_0,...,a_{l-1}, F),      0 <= l <= k,   F subset of {0,...,p-1},
```

with `F` empty whenever `l = k`, and the **consistent set**

```text
S(l, a, F) = { x in R_k : x_i = a_i for all i < l,  and  x_l not in F }   (3.4)
```

(for `l = k`, read `S = { a }`). Initially `l = 0` and `F` is empty, so
`S = R_k`. The invariant maintained is: *every* `x in S` is consistent with all
answers given so far, i.e. would produce exactly the same walk.

Suppose the tree, at the node reached so far, queries center `c`. The adversary
answers as follows.

- **Case 1: `c_i != a_i` for some `i < l`.** Let `m` be the least such `i`. The
  adversary answers `m`. Every `x in S` has `x_i = a_i = c_i` for `i < m` and
  `x_m = a_m != c_m`, so by (3.2) every `x in S` indeed gives response `m`. The
  state is unchanged.
- **Case 2: `c_i = a_i` for all `i < l`, and `c_l in F`** (only possible when
  `l < k`). The adversary answers `l`. Every `x in S` has `x_l not in F`, hence
  `x_l != c_l`, and agrees with `c` below `l`; so the response is `l` for all
  of `S`. The state is unchanged.
- **Case 3: `c_i = a_i` for all `i < l`, and `c_l not in F`**, with
  `|F| <= p-3`. The adversary answers `l` and replaces `F` by `F ∪ {c_l}`. Every
  `x` in the *new* `S` has `x_l != c_l` and agrees below `l`, so the answer is
  consistent with the new `S`, and the new `S` is nonempty since at least
  `p - |F| - 1 >= 2` digit values remain at position `l`.
- **Case 4: as Case 3 but `|F| = p-2`.** Exactly two values remain available at
  position `l`: `c_l` and one other, call it `e`. The adversary answers `l`,
  which forces `x_l = e`. It then sets `a_l := e`, `l := l+1`, `F := empty`.
  The new consistent set is `{ x : x_i = a_i for i <= l, x_{l+1} free }`, on
  which the given answer is again correct.
- **Case 5: `l = k`** (so `S` is a single residue): answer truthfully. This case
  is where the adversary has been beaten; the counting below shows when.

Note Case 3/4 are exhaustive for `l < k` together with Cases 1-2, and that
every case leaves `S` nonempty and every element of `S` consistent with the
entire transcript.

Now define the **potential**

```text
Phi = l * (p-1) + |F|.                                              (3.5)
```

Initially `Phi = 0`. Cases 1, 2 and 5 leave `Phi` unchanged. Case 3 increases
`|F|` by one, so `Phi` increases by exactly `1`. Case 4 replaces
`l*(p-1) + (p-2)` by `(l+1)*(p-1) + 0`, again an increase of exactly `1`.
Hence **each query increases `Phi` by at most `1`**, so after `t` queries

```text
Phi <= t.                                                           (3.6)
```

Suppose the walk reaches a leaf after `t` queries and `l < k` at that moment.
Then by (3.4) the consistent set contains at least
`(p - |F|) * p^{k-l-1} >= 1 * p^{k-l-1}` residues, and since `|F| <= p-2` in all
states with `l < k` (Case 4 fires the moment `|F|` would reach `p-1`), in fact
`p - |F| >= 2`, so `|S| >= 2`. All of these residues produce the identical walk
and therefore reach the same leaf, which carries a single label — contradicting
identification. Hence at any leaf, `l = k`, so `Phi = k(p-1)`, and (3.6) gives
`t >= k(p-1)`. As `T` was an arbitrary identifying tree, (3.3) follows. []

**Theorem W'** (matching, hence exact). `D(p,k) = k(p-1)` exactly.

*Proof.* `>=` is Theorem W. `<=` is Theorem 2.1 of
`notes/ADAPTIVE_VALUATION_CENTERS.md`: the digit protocol queries the `p-1`
centers `c_d = -(a + d p^l) mod p^k`, `d = 0,...,p-2`, at each of `k` levels,
using at most `k(p-1)` queries in total, and the residue `-1 mod p^k` forces
every one of them. []

~~This closes the open item stated in `ADAPTIVE_VALUATION_CENTERS.md` §2 and §5 and the first "Not proved" line of `MINIMUM_VALUATION_PROBE_BASIS.md`.~~

**Struck 2026-08-22.** The item was closed on 2026-08-12, twice, 48 hours
before this section was written: `notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md`
(`96b3dc24`, 03:37) and `notes/ADAPTIVE_VALUATION_IDENTIFICATION.md`
(`4017f526`, 03:45) each give the same upper bound and the same adversary. This
audit read `ADAPTIVE_VALUATION_CENTERS.md` (`045ea1b1`, 03:35) alone, took its
honest refusal to claim optimality for the state of the corpus, and re-proved
the bound. **Theorem W is correct and is the third proof, not the first.** It
is retained unaltered, and is the sharpest of the three: it is the only one
that writes the potential `Φ = l(p−1) + |F|` down, and the merged statement in
`notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md`
uses it. What is withdrawn is only the word "closes".

The
`0.21` forecast correction retained in §2 there is now discharged in the
direction of the protocol: **a globally optimized tree cannot exploit the
multi-valued response.** The reason is visible in the proof: the adversary
never once needs to answer "`>= l+1`". Deep responses are informative only when
the algorithm guesses a prefix correctly, and the adversary simply never lets it.

### 3.4 Why the counting bound could not have found this

A depth-`d` tree with `(k+1)`-ary branching has at most `(k+1)^d` leaves, so
identification of `p^k` residues needs only

```text
d >= k * log p / log(k+1),                                          (3.7)
```

which for `p = 3, k = 8` gives `d >= 4` against the truth `16`, and whose ratio
to the truth tends to `0` as `k` grows. Every lower bound in this corpus that
is a *cardinality* bound (rows 6, 9, 10, and `MEMORY_NOT_SUBTRACTION` Thm J) is
of type (3.7). Theorem W is stronger by an unbounded factor, and the extra
strength comes entirely from the adversary having a *state*, i.e. from
exploiting the shape of the oracle's partition rather than only its arity.

This is, I believe, the precise answer to the standing `PROVE` seed in
`LOCUS_MEMORY_FAMINE.md` §9.1 — *"a bound sensitive to the shape of the held
set, since all of this thread's lower bounds are cardinality bounds and
cardinality is shape-blind"* — at least as a method: the way out of
cardinality is a potential function on an adversary state, not a better count.
Theorem W is a worked instance of that method in the query model. Whether the
same potential can be run in the chain model of row 2 is left open; I do not
have it either, but I can now say what shape it would have.

### 3.5 Scope, stated plainly

- **Deterministic, worst case.** Theorem W says nothing about randomized
  identification, nor about average-case cost under any distribution. Under the
  uniform distribution the digit protocol's *expected* cost is far below
  `k(p-1)` (`OUTPUT_SENSITIVE_CLEAN_COST.md` (2) computes the exact
  distribution-free realized cost `Q(r) = sum_l q(d_l)`, whose uniform mean is
  `k(p+2)(p-1)/(2p)` per that formula's `q`), so a randomized lower bound
  cannot follow from Theorem W by Yao without a hard distribution, which I have
  not constructed. **Open, and I flag it rather than gesture at it.**
- **Query cost only.** Center construction is free here; by row 8 it does not
  descend to `R_k` at all, so the two costs cannot simply be added. Theorem W
  is a bound in the query model and only there.
- **No primality used.** `p >= 2` arbitrary; `v_p` means the `p`-adic
  valuation on `Z/p^k Z`, well defined by (3.2).
- **Prior art.** The reformulation (3.2) makes this the LCP-query
  identification problem on `[p]^k`, a folklore model (it is the analysis
  behind trie search and behind Mastermind-type static-target games). The
  `k(p-1)` value is the kind of thing that is certainly known in some form; I
  assert no novelty, only that the corpus needed it and did not have it. Tagged
  `SEARCH`: locate the LCP-oracle identification bound in the literature
  (likely under adaptive trie construction or "guessing games with prefix
  feedback").

## 4. What I recommend changing in the corpus

1. `notes/EXPLICIT_COMPILER_LOWER_BOUND.md`: the file name promises a lower
   bound on compilers; the theorem delivers a count under a contract. Rename in
   spirit (a header line suffices): *"Optimality of the formation count under
   the explicit operand contract."* The mathematics is fine; the title is the
   claim that will be misquoted.
2. `notes/ADAPTIVE_VALUATION_CENTERS.md` §2, §5 and
   `notes/MINIMUM_VALUATION_PROBE_BASIS.md` "Not proved": both should now cite
   Theorem W. The value `(p-1)k` may from now on be reported as **exact**, with
   the model of §3.1 attached and the scope of §3.5 attached.
3. Any future note asserting a cost should open, as §3.1 does, with the model
   *before* the theorem. A cost with no quantifier is the exact analogue of the
   `exp27` fitted constant this repository's `CLAUDE.md` was written about: it
   looks like knowledge.
