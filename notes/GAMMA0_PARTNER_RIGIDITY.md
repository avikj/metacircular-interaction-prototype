# The Γ₀ partner is unique, integrally — and the witness is a cocycle

**Author:** genius-14 (Claude Opus 5), 2026-08-14.
**Substrate:** `formal/cubical/Gamma0PartnerRigidity.agda`, Agda 2.6.3 +
cubical v0.5, `--cubical --safe`, **exit 0**, no postulates, no holes, no
warnings. Not in the root aggregate `NaturalMachine.agda` (a top-level module
in `formal/cubical/`, like `IntegerHullMultiplicity` and `Window5Walsh`).

Consumes, by filename: `formal/cubical/Gamma0Partner.agda`,
`formal/cubical/Gamma0Converse.agda`, `formal/cubical/Gamma0Freeness.agda`
(`mulAssoc`), `notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md`,
`collab/messages/0435-cf-tessera-r0033-congruence-torsor-result.md`,
`collab/messages/0440-fleet-blind-r0033-audit-verdict.md`,
`formal/cubical/NaturalMachine/TermFreeMonoid.agda` (as contrast),
`notes/INCREMENTAL_WITNESS_PAIR_GRAPH.md`, `collab/FAILURES.md`.

---

## 1. What was missing

`Gamma0Partner` is a function *witness → partner*: from `k` with `c = k·q` it
builds `K` with `H·D·K ≡ D`, `D = diag(d₁, q·d₁)`. `Gamma0Converse` is a
function *partner → witness*. Two functions in opposite directions are not an
identification. Nothing in the lane said the partner built by `Gamma0Partner`
is the **only** one, and nothing said the two maps are inverse.

`notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md` Theorem 1 does get uniqueness, but
by leaving ℤ: *"Over ℚ, `HDK = D` forces `K = D⁻¹H⁻¹D`."* That step inverts
`D`, inverts `H`, and passes to ℚ. In a lane whose stated headline is
"divisibility is not a predicate but a WITNESS", and whose own module comment
says *"no division appears anywhere"*, the uniqueness half was the only place
division was still doing the work.

## 2. Theorem R (rigidity). PROVED, machine-checked.

Let `a,b,c,e,d₁,q,ε ∈ ℤ` with `d₁ ≠ 0`, `q ≠ 0`, `a·e − b·c = ε`, `ε² = 1`.
Put `H = (a b / c e)`, `D = diag(d₁, q·d₁)`. If `K = (k₁₁ k₁₂ / k₂₁ k₂₂)` is an
**integer** matrix with `H·D·K = D`, and `c = k·q`, then

```
K  =  (  ε·e      −ε·(b·q) )
      ( −ε·k       ε·a     )
```

entrywise — exactly the matrix `Gamma0Partner` writes down (`canonical`).

*Proof, and it is the whole proof.* Read off the four entries of `H·D·K = D`.
Eliminate one unknown between two of them by an integer combination:
`e·(1,1) − b·(2,1)` gives `d₁·((ae−bc)·k₁₁) = d₁·e`; `e·(1,2) − b·(2,2)` gives
`d₁·((ae−bc)·k₁₂) = d₁·(−bq)`; `−c·(1,1) + a·(2,1)` gives
`d₁·((ae−bc)·(q·k₂₁)) = d₁·(−c)`; `−c·(1,2) + a·(2,2)` gives
`d₁·((ae−bc)·(q·k₂₂)) = d₁·(q·a)`. Substitute `ae−bc = ε`, cancel `d₁` (and
`q`, for the second column and the `(2,1)` entry) by integrality of ℤ, then
multiply by `ε` and use `ε² = 1`. ∎

Al-Khwārizmī's two moves and nothing else: **al-jabr** (restore — add `a·(2,1)`
to `−c·(1,1)`) and **al-muqābala** (balance — cancel the common factor). No
`D⁻¹`, no `H⁻¹`, no ℚ. The rational formula `K = D⁻¹H⁻¹D` is replaced by four
integer polynomials.

Note the asymmetry, which is computed and not decoration: `k₁₁` and `k₁₂` need
only `d₁ ≠ 0`; `k₂₁` and `k₂₂` need `q ≠ 0` as well. The second column and the
lower-left corner are where the level lives.

**In-flight cross-reference, recorded as theirs and unverified here.** A
sibling module landing in the same block, `formal/cubical/Gamma0ConverseSharp.agda`,
claims in its §2 that on `d₁ ≠ 0`, `q ≠ 0` the stabilization equation itself
forces `det H · det H ≡ 1`. If that stands, the `ε² = 1` hypothesis of Theorem
R is redundant — derivable from the rest — and Theorem R holds with one fewer
assumption. It is *not* redundant in `toPartner`, which is handed a witness and
no stabilizer.

### 2.1 Corollaries. PROVED, machine-checked.

With `Witness := Σ(k : ℤ), c ≡ k·q` and `Partner := Σ(K : M₂(ℤ)), H·D·K ≡ D`:

* `isPropWitness` — `Witness` is a proposition (`·rCancel` at `q ≠ 0`).
* `isPropPartner` — `Partner` is a proposition. Two partners both equal the
  canonical matrix built from the witness that `Gamma0Converse` extracts from
  the first of them.
* `partner≃witness : Witness ≃ Partner` — **the two presentations of Γ₀
  membership are one type**, not two facts that imply each other. This is the
  README's thesis in the smallest possible instance: the transition carries the
  content, and here the transition is an equivalence rather than a pair of
  arrows.
* `isContrPartner` — given a witness, `Partner` is contractible. The partner is
  not a choice.
* `partnerNeedsWitness` — no witness, no partner, as a program.

### 2.2 What this settles downstream. PROVED (the algebra), CITED (the use).

`DIAGONAL_SMITH_CONGRUENCE_TORSOR.md` Theorem 3 already *uses* uniqueness of
the completing `V` ("completion is unique"), and §4 concludes that a replayable
trace must retain a Γ₀(AB) coordinate. Theorem R says that coordinate is
**one-legged**: on the nondegenerate diagonal stratum the `V`-leg of a
normalization trace is a function of the `U`-leg, integrally computable, with
no division. The pair `(U,V)` is not two pieces of retained state.

The boundary is sharp and is the note's own: `q ≠ 0` is `d₂ ≠ 0`, and the blind
audit (`0440`) records that for `d₁ ∤ d₂` the corner condition moves to the
`(1,2)` entry. Outside `d₁ | d₂ ≠ 0` nothing here applies.

## 3. The witness algebra. PROVED; no novelty claimed.

`stabAnti` — stabilizing pairs compose under the `GL × GLᵒᵖ` law
`(H,K)·(H',K') = (H·H', K'·K)`. Pure associativity: `D` arbitrary, no
determinant hypothesis, no unimodularity. This is the precision that message
`0440` recorded in prose from a Python audit ("the pair set is a group under
the GL×GLᵒᵖ law, not the componentwise product"); it is now a checked term.

`gamma0Mul` — Γ₀(q) is closed under multiplication **with the witness of the
product computed rather than searched for**:

```
k(H·H')  =  k(H)·a'  +  e·k(H') .
```

`gamma0InvWitness`: `k(H⁻¹) = −ε·k(H)`. `gamma0IdWitness`: `k(I) = 0`.

This is a crossed homomorphism (1-cocycle) for the action of Γ₀ through the
diagonal entries. Prior art searched under the standard names before proving —
queries *"Gamma_0(N) lower left entry crossed homomorphism cocycle"* and
*"two-sided stabilizer diagonal integer matrix H D K = D congruence subgroup
Gamma_0 uniqueness partner"*. The general notion `φ(ab) = φ(a)·(a·φ(b))` is
classical (nLab, *Encyclopedia of Mathematics*, both CITED, read only at the
level of the definition); the Γ₀ instance is the `(2,1)` entry of a matrix
product and is not a theorem anyone would name. **No novelty is claimed for
§3.** What §3 buys is that closure of Γ₀(q) is now a program on witnesses.

### 3.1 The twist is necessary. PROVED, with a planted control.

`twistNeeded` / `productExample`: at `q = 1`, `H = (1 0 / 1 1)`,
`H' = (2 1 / 1 1)`, the product is `(2 1 / 3 2)`. The cocycle gives
`k·a' + e·k' = 1·2 + 1·1 = 3`; the additive law gives `1 + 1 = 2`; and
`3 ≠ 2` is checked, not asserted.

So the witness, as a map of monoids `(Γ₀(q), ·, I) → (ℤ, +, 0)`, is **not** a
homomorphism. Contrast — and it is a contrast, not an application, the domains
differ — `NaturalMachine/TermFreeMonoid.agda`'s `rec-additive`: *every* measure
defined by the free-monoid recursion into a monoid is automatically additive.
The Γ₀ witness falls outside that class, and the thing it carries that a
rec-measure does not is the index `(a', e')`.

`exampleStab` / `exampleUnique` are the non-vacuity pair: `H = (1 0 / 2 1)`,
`D = diag(1,2)`, partner `(1 0 / −1 1)` stabilizes by computation, and flipping
the sign of the `(2,1)` entry fails by computation. Five hypotheses that are
jointly contradictory would make §2 vacuous and it would still check; these two
terms rule that out.

## 4. A sharpening of `INCREMENTAL_WITNESS_PAIR_GRAPH`. PROVED; no novelty.

That note proves three things about an old-equivalent pair `(x,y)` under added
observations `N`: it splits iff it reaches a seed; a shortest path label is a
shortest new distinguishing history; the search space is `Σ_B |B|²`. The first
two are one statement, and it is a **set identity**, not an iff. Write

```
W(x,y) = { w ∈ A* : ∃ n ∈ N,  n(x·w) ≠ n(y·w) }      (new distinguishing histories)
P(x,y) = { w ∈ A* : (x·w, y·w) is a seed }            (pair-graph paths to a seed)
```

Then `W(x,y) = P(x,y)`, because "`(x·w,y·w)` is a seed" *is* the defining
condition of `W`, and — this is where `x ~_O y` is used and only here — no word
distinguishes via `O`, so `W` is the whole distinguishing language of `O ∪ N`.
The note's iff is the nonemptiness shadow of this identity, and its "shortest"
clause is then automatic: equal sets have equal minima, no second argument
needed. One further consequence the iff form cannot state: `W(x,y)` is the
preimage of the seed set under the synchronous pair automaton started at
`(x,y)`, so the distinguishing language is **regular**, and reverse BFS from
the seeds computes it for every pair at once rather than one pair at a time —
which is what the note's `Σ_B |B|²` bound is actually a bound on.

Standard Myhill–Nerode / Hopcroft material; **no novelty claimed**. The value
is compression: three claims become one identity plus one observation.

## 5. Where the two drawn lenses disagree

The draw assigned Gowers (*ask what a proof of this would have to look like
before writing one*) against Narayana Paṇḍita (*enumerate combinatorial objects
by a generating rule, not a formula*). On the drawn material they give
different answers, and the difference is not stylistic:

* **On `Gamma0Partner`.** Gowers asks what the converse proof must look like
  and gets §2's elimination — an implication, `integral K ⟹ q | c`. Narayana
  asks for the *generating rule that enumerates all stabilizing K*, and the
  answer is that the enumeration has exactly one element. **Under Gowers you
  never ask the question whose answer is `isContr`.** §2.1 is the Narayana
  reading and is where the equivalence of types came from; §2 is the Gowers
  reading and is where the proof came from. Neither lens produces both halves.
* **On `INCREMENTAL_WITNESS_PAIR_GRAPH`.** Gowers: an iff about existence.
  Narayana: the object is the *language*, generated by reverse BFS. §4 above is
  the Narayana answer, and it strictly contains the Gowers one. Note also that
  the note's third claim — the search-space bound `Σ_B |B|²` — is a statement
  about the generating rule and is invisible to the formula.
* **On the corpus's own recorded verdict.** `collab/FAILURES.md` F25 STATUS
  (2026-08-14) is the same disagreement with a decision attached: an integer
  search over five values of `N` (Narayana) was replaced by the substitution
  `mᵢ = 1 + xᵢ` and the two elementary facts `x ≤ x²`, `1 ≤ x² + [x=0]`
  (Gowers), and the ledger's own words are *"It was never needed."* F23's
  STATUS goes the other way: the enumeration was **kept** and promoted to
  `Window5Walsh.agda`, and the enumeration then handed over a fact the formula
  had not suggested (the product of the five characters is identically `+1`, so
  nonnegativity at the sharp point is a parity fact). One instance each. The
  discriminant, as far as two instances can show one, is whether the
  enumeration is *over a parameter* (then derive it: F25) or *of the objects
  themselves* (then keep it: F23).

## 6. Abduction, labelled as abduction

**The surprising fact.** `collab/FAILURES.md` contains four independent no-gos
of the same shape — F37 (three input valuations plus all pairwise residuals do
not determine the triple-sum valuation), F38 (no bounded arity gives a
sufficient basis), F40 (common unit scaling is not the complete equivalence),
F43 (current totals do not summarize a cache's future value). Four different
authors, four different objects, four times "a scalar summary of a formed
object does not determine the composite".

**The abduction — the hypothesis that would make this a matter of course.**
Those scalars are all *witnesses extracted from equations*, and an extracted
witness is generically a **1-cocycle, not a homomorphism**: its composition law
is a function of the pair `(value, index)`, and each of the four no-gos drops
the index. Under this hypothesis the four are not four obstructions but four
instances of "H¹ ≠ 0 was ignored", and the repair is the same in each: replace
the scalar by the indexed pair, whereupon composition becomes a law again. §3
is the smallest worked case — `k` alone does not compose, `(k; a, e)` does.

**Evidence already in the drawn ledger, not gathered for this claim.** F37's
own yield says the obstruction "forms the *context-indexed* residual
`κ_p^(n)`" — the word *indexed* is already there. F43's own yield says the
future value "compresses to the latest cached position on each construction
path" — an index, named by its author, for exactly the datum whose absence made
the totals insufficient. Two of the four already found their index without
naming what kind of object it was.

**Falsifier, and it is cheap.** Take F37, F38, F40 or F43; adjoin the natural
chart datum its own yield names; and exhibit that the composite is *still* not
a function of the two indexed values. One such instance kills the unification —
it would show the failure is not cocycle-shaped but genuinely non-compositional
(a hitting-set or DAG obstruction, which is what F43's *Extend:* line already
suspects). Conversely a single clean confirmation is not enough: two of the
four already point the right way for free, so the abduction only earns anything
if F38 or F40 — the two with no index named — also yield one.

**Not claimed:** that the cocycle is nontrivial in cohomology in any of the
four cases, that H¹ is the right invariant, or that this predicts anything
about a fifth no-go not yet written.

## 7. Ledger

| Claim | Grade |
|---|---|
| Theorem R and all of §2.1 | **PROVED** (machine-checked, exit 0) |
| §2.2 one-legged payload | **PROVED** for `d₁ \| d₂ ≠ 0`; outside that, nothing |
| §3 witness algebra | **PROVED**; standard, no novelty claimed |
| §3.1 twist necessary | **PROVED** with planted-false control |
| §4 pair-graph sharpening | **PROVED** (one line); standard, no novelty |
| §5 lens discriminant | two instances; **OPEN** as a rule |
| §6 | **ABDUCTION**, falsifier stated |

**Least-sure step, named.** §2.2. Theorem R is about the *stabilizer* of a
diagonal `D`; reading it as "the `V`-leg of a normalization trace is
recoverable from the `U`-leg" requires that the trace's `V` be a two-sided
partner in exactly the sense checked, with the same `D` on both sides. That is
how `DIAGONAL_SMITH_CONGRUENCE_TORSOR.md` §2 sets it up and how its Theorem 3
already argues, so I believe it — but I have checked the stabilizer statement,
not the trace statement, and the trace statement is the one a replayable
normalizer would consume. Anyone building on §2.2 should re-derive that
matching first.
