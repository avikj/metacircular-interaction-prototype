# The kernel formalises sameness but not distinction — Delta 20 T20.4, machine-checked

**Status:** exact, `--safe`, exit 0, no postulates or holes, first compile.
**Code:** `formal/cubical/BehavioralApartness.agda`.
**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

## 1. Delta 20's T20.1 is this repository's kernel for the fifth time

`T20.1` (behavioural equivalence is a congruence, `x ~ y ⇒ δ_a x ~ δ_a y`) is
`futureEq_step` in `formal/pairfield/Pairfield/FutureBehavior.lean`. Delta 20
says so itself — "the discrete nonlinear analogue of Delta 19's linear
observable quotient" — and correctly names Myhill–Nerode, final coalgebras,
bisimulation, and computational mechanics as the mature homes. Counting from
`DELTA19_IS_THE_KERNEL_AGAIN.md` §1, that is **five derivations of one
congruence**. Nothing further is owed to T20.1.

`T20.2`/`T20.3` (Hankel rank bounds realisation dimension) are classical
Kronecker/Ho–Kalman realisation theory, and the same Hankel object already
arrived from the Poincaré direction in `FLEET_BREAKER_PASS_2026_08_14.md` §2.
`T20.5` (`Ker(R) ⊆ ~_Task`) is full abstraction. None of it is new.

## 2. The genuine gap, and it is in the README

`FutureBehavior.lean` contains `behavior`, `FutureEq`, the quotient, `lift`, and
`quotientBehavior_injective`. It contains **no notion of distinction** other
than the negation of `FutureEq`. Grep confirms: no `Apart`, no `separating`, no
witness.

But `README.md` describes the machine as keeping, *for every distinction, the
shortest experiment that reveals it*, and `machinery/natural_crystal.py`
computes exactly that. **The prose and the executable centre on the separating
experiment; the machine-checked kernel had only the equality half.**

Delta 20 T20.4 names the missing object:

```text
x #_beh y  :=  Σ[ w ∈ A* ] ( o(δ_w x) ≠ o(δ_w y) )
```

— a Σ-type whose inhabitant **is** the experiment, not a refutation of sameness.

## 3. What is now checked

Over an arbitrary system `(step, obs)` matching the Lean kernel's signature:

- `apart→¬futureEq` — apartness refutes sameness, constructively, no hypotheses.
- **The converse is not provable**, and that is the content: from `¬ FutureEq`
  one cannot extract a word without a search principle. Delta 20's *"the witness
  is not merely that x and y differ; it is a CONTEXT that distinguishes them"*
  is exactly this gap.
- `futureEq-step` — sameness **descends** along actions (the kernel's theorem,
  restated in Agda).
- `apart-step` — distinction **ascends**: a witness separating the successors,
  prefixed by the action, separates the predecessors. The witness is transported
  explicitly. This is the computational content a proposition-valued kernel
  cannot express.
- `apart-peel` — the converse peel.

**The asymmetry, which is the point:**

- `isPropFutureEq` — sameness **is a proposition** (given `isSet Obs`). Any two
  proofs are equal; it carries no data.
- `ApartNotProp` — distinction **is not a proposition**. In the minimal system
  (two states, one action, identity dynamics, state as observation) the words
  `[]` and `tt ∷ []` are both separating and are distinct inhabitants of
  `Apart false true`.

So `FutureEq` and `Apart` are not De Morgan duals of equal standing. One is a
truth value; the other is a **space of experiments**. That is the exact formal
content of Delta 20's `EqWitness`/`SepWitness` pairing, and of the corpus's own
founding distinction lens.

**Controls** (per `VACUITY_CERTIFICATES.md`, and following the Turing-method
finding that `CenterRelative.agda` is currently the only module in the tree
carrying its own): `falseApartTrue` inhabits the apartness type so §5 is not
vacuous, and `FutureEqIsProp` instantiates the contrast on the same system, so
the asymmetry is exhibited rather than asserted.

## 4. Delta 21, briefly and without formalisation

Almost everything is classical and the delta says so: PGL₂ on P¹, the Cayley
transform (T21.11), cross-ratio invariance (T21.10, labelled Known),
tropicalisation `v_p(x_j/x_i) = v_p(x_j) − v_p(x_i)` (T21.21), the product
formula (S21.23), and `div(q/p) = e_q − e_p` as an A-type root (C21.26 — exact,
elementary, standard divisor theory).

Two remarks worth recording:

1. **The fleet's Gauss finding already constrains this branch.**
   `FLEET_BREAKER_PASS_2026_08_14.md` §1.3 establishes that the split form
   `W²−R²` has square discriminant, class number 1, automorph group `{±I}`, and
   generating function `ζ(s)²` — *the divisor problem, no Dirichlet
   L-function*. Delta 21 §21.7's Cayley/Möbius reorganisation is a change of
   chart on that same P¹ and does not alter it. Any hope of arithmetic content
   still requires leaving `W²−R²`.
2. **C21.33 is the one genuinely sharpening idea** — that the irreducible object
   is the **evaluation morphism** `(n,h) ↦ n+h` coupling positional geometry to
   value geometry, rather than either A-type geometry alone. That reframes
   "addition and multiplication interact" into something with a subject. It is
   also, as §21.27 concedes, the doorway to arithmetic statistics of polynomial
   values / Bateman–Horn, and the delta's own instruction is "search before
   invention". No search performed; none claimed.

## 5. Rigor boundary

- **Checked:** every name in §3, Agda 2.6.3 + cubical v0.5, `--safe`, exit 0, no
  postulates, no holes.
- **Not claimed:** that `Apart` is decidable, or that minimal separating depth
  (`d_sep`) exists constructively — it needs decidable observation equality plus
  a search principle, and I did not formalise it. Delta 20's `d_sep` remains
  open here.
- **No novelty.** Apartness is standard constructive mathematics (Brouwer,
  Heyting; `#` in Bishop-style analysis); its coalgebraic reading is standard;
  that a Σ-type of witnesses is not a proposition is elementary HoTT. What is new
  **to this repository** is that its kernel now has the distinction half its own
  README describes.

## 6. Successor seeds

1. `PROVE`: `d_sep`, the shortest separating experiment, under decidable `Obs`.
   This is what `natural_crystal.py` actually computes, and the Lean lane already
   has `BehavioralBFS.lean` doing Hopcroft-style distinguishing-word search.
   Porting that to the apartness type would close the loop between the README's
   prose, the executable, and the kernel.
2. `PROVE`: cotransitivity (`x # z → (x # y) ⊎ (y # z)`) under decidable `Obs` —
   the property that makes `#` an apartness relation in the technical sense, and
   the one that would justify the name.
3. `SEARCH`: Delta 21 §21.27's list, before any claim about the evaluation
   morphism.
