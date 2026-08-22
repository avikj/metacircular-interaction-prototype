# Selection retains what value forgets: lenses, `Sel_K`, and the matching-pennies separator

**Task:** `notes/D0026_BUILD_QUEUE.md` §4b, **Q10** — ingest D0026 §2.9 (Chu
transforms, lenses, proof-relevant selection, strategic completion; owner
Delta 30), which the §4b sweep records at **zero files** in this repository.
**Author:** build worker (von Neumann persona), 2026-08-16.
**Status: PENDING HOSTILE AUDIT.** Nothing below is measured, fitted, or
floating-point; nothing existing is edited or struck.

**Sources read in full for this note.**
Upstream: `collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`
§2.8 (Bellman/factor-rank contrast) and §2.9 (the item being ingested), plus
§2.7 for the reflective chain the two sit inside.
Repo, read in full before writing a line:
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md`,
`notes/BOUNDARY_OPERATOR_TYPING.md`,
`notes/VERIFIER_BLIND_FIBER_REWARD.md`,
`notes/OBSERVABLE_DESCENT_COMMON_OBJECT.md`,
`notes/D0026_COMPARISON_MAPS.md` §3,
`notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` §§23–26, 33–35 and its
"checked footholds" ledger,
`notes/FLEET_BREAKER_PASS_2026_08_14.md` §1.2,
`notes/EGB_LIBRARY_INDEX_V3.md` §II.2 and entries 123/124/130/131,
`notes/D0020_CLASSICAL_SOURCES.md` row 4.13.
Formal lane, read: `formal/cubical/NaturalMachine/DSOMinPlusFinite.agda`
(the `Argmin` record), `.../DSOContinuationFullAbstract.agda`,
`.../DSOBellmanFinite.agda`, `.../ChuAdvance.agda`, `.../ChuDefect.agda`,
`.../Decategorification.agda`.
Mechanical sweep run before writing: `grep -ril` over `notes/` and `formal/`
for *Chu · Chu transform · lens · Dialectica · selection function · Nash ·
equilibrium · best response · matching pennies · Escardó · Hedges · backward
map · Bellman · proof-relevant · argmin · potential game · harmonic*.

**Rules of engagement.** §1 is the prior-art fence and it governs: everything
this repository already holds is named there with a path, and **is not
re-proved below**. §§2–5 contain only the genuinely absent material. Every
statement is derived on the page or cited to a proof in this corpus. The
Agda in §5.5 is a *shape*, not a checked term; no typechecking is claimed
anywhere in this note.

---

## 0. The finding, in one paragraph

Three things from §2.9 are absent here and all three are worth having; one
thing from §2.9 the repository already has, in a stronger form than §2.9
states it, and this note refuses to re-derive it. What is absent: **(a)** the
lens backward map `f♯ : X × U → T` and its composition law
`h♯(x,v) = f♯(x, g♯(fx,v))`, whose whole content is that the backward request
may depend on the *source* state — the repository has Chu transforms
(`e'(f_o x, t') = e(x, f_a t')`, state-*in*dependent) and nothing finer;
**(b)** the theorem that the Bellman value forgets the minimizing witness
while `Sel` retains it, with a finite minimal witness for the forgetting;
**(c)** the matching-pennies separator. What is held: the proof-relevant
optimizer fiber itself, as `Argmin` in `DEPENDENT_SYSTEM_OPTIMIZATION.md` §24
and as a checked Agda record in `DSOMinPlusFinite.agda` — `Sel_K` *is* that
object, instantiated at min-plus, and §2.9 adds no structure to it. And the
join the queue asked for holds, but one degree less spectacularly than it
looks: `notes/OBSERVABLE_DESCENT_COMMON_OBJECT.md` already proves the level-set
theorem **(T)** of which `VERIFIER_BLIND_FIBER_REWARD` Theorem A is the
degenerate instance, so the join is not a new theorem — it is the observation
that **`Sel` is the fourth costume of (T), and the only one in which the fiber
is *retained* rather than lamented.** That reading turns "process supervision"
from a slogan into a named map (§4), and the same theorem (T) then proves the
matching-pennies separator too (§5.4). One theorem, four costumes.

---

## 1. Prior-art fence: held versus absent, with paths

This section exists because the queue's own standing rule (`D0026_BUILD_QUEUE.md`
§4b consequence 1) is that Q2 was ~60% re-derivation for want of a formal-lane
sweep. The sweep was run. Here is its result.

### 1.1 HELD — do not re-derive

| §2.9 item | Held where | In what strength |
|---|---|---|
| The state–test object `(X,T,e)`, `e : X×T→Q` | `CHANGING_TESTS_VERSUS_SHRINKING.md` (H1); `ChuAdvance.agda`, `ChuDefect.agda` | Full, with a Galois adjunction `δ ⊣ δ*`, a redundancy closure `C`, a resolving-power preorder `⊑` and a **uniqueness** theorem (Thm E) D0026 does not have |
| Chu transform `e_Y(Fx,u) = e_X(x,Gu)` | `ORDINAL_LADDER_SMALLNESS.md` Thm 3 proof; `BOUNDARY_REPAIR_PRICED.md` Prop. 3; `BOUNDARY_OPERATOR_TYPING.md` §3.1 | Stated with the correct variance, and the contravariance of the test half proved |
| Biextensional identification of states by equal rows | `CHANGING_TESTS_VERSUS_SHRINKING.md` (H2), Rmk 1.1, Lemma 6.2 | Full; `∼_S` and the partition lattice are the note's whole apparatus |
| **The proof-relevant optimizer fiber** | `DEPENDENT_SYSTEM_OPTIMIZATION.md` §24: `Argmin(b) = Σ_{x:E(b)} Π_{y:E(b)} [J(b,x) ≤ J(b,y)]`; §§25–26 (the optimizer as a *section*, gluing defects) | **Full, and stronger than §2.9's `Sel_K`**: §24 is the general dependent form; §2.9's `Sel_K` is its min-plus instance |
| The same, machine-checked | `DSOMinPlusFinite.agda` `record Argmin (R) (V) (x)` with fields `witness : Ix n`, `realizes : bellman R V x ≡ R x witness ⊗ V witness`; `DSOContinuationFullAbstract.agda` `record Argmin` with `witness`, `realizes` | Checked Cubical Agda. This **is** `Sel_K(a,V)` written as a record instead of a Σ |
| "Same value hides distinct witnesses" as a *slogan* | D0026 §2.8 itself ("Equal optimal value can hide distinct witnesses"), landed in `DSO_CONTINUATION_FULL_ABSTRACTION.md`; `r(K) ≤ wrank(K)` | Slogan and rank inequality — **not** a theorem separating two kernels at one continuation. See §3.3 |
| The level-set theorem **(T)** | `OBSERVABLE_DESCENT_COMMON_OBJECT.md` §1: *`f` factors through `q` iff `f` is constant on every `q`-fiber*; the Galois connection observables ↔ partitions | Proved, with three instantiations named |
| `VERIFIER_BLIND_FIBER_REWARD` Thm A as an instance of (T) | `OBSERVABLE_DESCENT_COMMON_OBJECT.md` §2.2, verbatim: *"Theorem A is the degenerate instance (the verifier's partition has ONE fiber on each event set, so descent forces constancy)"* | Already identified. **The join in §4 must not be sold as new** |
| Format lattice = partition lattice between `q` and the identity | `OBSERVABLE_DESCENT_COMMON_OBJECT.md` §2.2 | Proved |
| "Fiber-separating reward must be imported, not derived" | `VERIFIER_BLIND_FIBER_REWARD.md` §3 (citing R0027 §4 by note-path — see its own provenance addendum) | Proved for the torsor case |
| von Neumann 1928 as the two-person zero-sum antecedent | `D0020_CLASSICAL_SOURCES.md` row 4.13, marked CLASSICAL-SOURCED | Cited, not read |
| A best-response counterexample refuting a coordination theorem | `FLEET_BREAKER_PASS_2026_08_14.md` §1.2 (Thm 431 false; `u₁(a₁,a₂)=a₁+a₂` non-factorable yet best-response-decoupled; Agda certificate, exit 0), with the correct replacement = the **dummy** component of the Candogan–Menache–Ozdaglar–Parrilo potential/harmonic/nonstrategic decomposition | Proved and machine-checked. **This is the nearest neighbour of §5 and it is a different statement**: it separates non-factorability from best-response coupling; §5 separates welfare/equilibrium summaries from best-response structure |

### 1.2 ABSENT — verified by the sweep

- **The lens.** Zero occurrences of a backward map `X × U → T` anywhere in
  `notes/` or `formal/`. The only hits for "lens" in this corpus are the
  *optical/metaphorical* sense (`LENS_REGULARITY.md` = cut-norm regularity,
  `LENS_CIRCUIT.md` = "the complexity-theory lens", `CROSS_LENS.md`, and
  `ETERNAL_GOLDEN_BRAID_DELTA24.md` §168 which explicitly *defers* optics:
  *"optics/lenses only where a genuine get/put decomposition is present"*).
  The only hits for "backward" in the optimization sense are
  `DEPENDENT_SYSTEM_OPTIMIZATION.md` §33's bullet *"Backprop as functor …
  backward requests, compositional update rules"* — a one-line entry in a
  list of *inherited mature mathematics*, with no definition, no composition
  law, and no theorem. **The composition law `h♯(x,v) = f♯(x,g♯(fx,v))` does
  not occur.** Nor does the fact that it makes a category, nor the relation
  to Chu transforms. `CHANGING_TESTS_VERSUS_SHRINKING.md` §9 names precisely
  this gap as *its own* scope limit: *"the genuinely fibred case … compared
  only through a Chu transform `(f_o,f_a)` — is **not** treated."*
- **Bellman-forgets, stated as a theorem.** The repo has `Argmin` (§1.1) and
  it has `active-witnesses-differ` in `DSOContinuationFullAbstract.agda` — but
  that refutation compares the argmin fibers of **two different
  continuations** (local vs global `V`), which is the premature-argmin
  obstruction, a different statement. **There is no statement anywhere that
  two kernels with the same Bellman value at the same continuation have
  inequivalent `Sel` types**, and no h-level analysis of `Argmin` (when is it
  a proposition? contractible?).
- **Nash / equilibrium / matching pennies.** `Nash` occurs in this repo in
  exactly two live places: `D0020_CLASSICAL_SOURCES.md` row 4.13 and
  `D0020_LEDGER.md` row 4.13, both *bibliography rows* marked "Not read", plus
  index rows in `EGB_LIBRARY_INDEX_V3.md`. **"matching pennies" occurs in no
  repo note and no formal file** — only in upstream raw text
  (`COORDINATION_THEOREMS_XLIII` Thms 1389/1407/1408, `D0026` §2.9,
  `EGB_SELF_CONTAINED_CORE_TRANSMISSION_V2`) and in the *index* rows of
  `EGB_LIBRARY_INDEX_V3.md` (entry 131, "matching-pennies scalarization
  no-go"). An index row is a promise, not a theorem.
- **Selection functions / open games as such.** `Escardó` occurs once, in
  `DESCENT_ALONG_ONE_MAP_IS_UNOBSTRUCTED.md` and
  `EffectiveDescent.agda` — in the *descent* sense (Escardó's work on
  injective types / compactness), not the selection monad. `Hedges` occurs
  four times, every one of them the English word *hedges*. No `J R X = (X→R)→X`.

**Verdict of §1.** The queue's Q10 diagnosis is confirmed with one amendment:
the queue lists "the proof-relevant selection functional `Sel_K`" as absent.
It is **not** absent — `DEPENDENT_SYSTEM_OPTIMIZATION.md` §24 and
`DSOMinPlusFinite.agda` hold it, and hold it more generally than §2.9 states
it. What is absent is the *theorem about* it (§3), the lens (§2), and the
separator (§5). The queue entry should be amended; this note is the amendment.

---

## 2. The lens, and exactly what state-dependence buys

### 2.1 Definition and the composition law

**Definition 2.1.** A **lens** `(f,f♯) : (X,T) → (Y,U)` is a pair
`f : X → Y`, `f♯ : X × U → T`. Composition is

$$(g,g^{\sharp})\circ(f,f^{\sharp}) \;=\; \bigl(g\circ f,\ h^{\sharp}\bigr),
\qquad \boxed{\,h^{\sharp}(x,v) \;=\; f^{\sharp}\bigl(x,\ g^{\sharp}(f x, v)\bigr)\,}$$

with `f : X→Y`, `f♯ : X×U→T`, `g : Y→Z`, `g♯ : Y×V→U`, so `h♯ : X×V→T`.

**Observation 2.2 (why the source state must be threaded, and it is a typing
fact, not a convention).** The composite backward map has type `X × V → T`
and the only producer of a `T` in the data is `f♯`, whose domain is `X × U`.
There is no map `Y → X`, so the `X` argument of `f♯` cannot be manufactured
from `f x : Y`; it must be the composite's own input `x`. The `U` argument
must come from `g♯`, whose `Y` argument *can* be manufactured, as `f x`.
Hence the displayed law is the unique composite built from the given data
without discarding an argument. *(I claim uniqueness only in this sense —
"without discarding an argument" — not a parametricity theorem; see §6.)*

**Theorem 2.3 (lenses form a category; both laws hold definitionally).**
With identity `(\mathrm{id}_X, \pi_2 : X\times T\to T)`, composition as in
Definition 2.1 is associative and unital.

*Proof.* **Associativity.** Take `(f,f♯):(X,T)→(Y,U)`, `(g,g♯):(Y,U)→(Z,V)`,
`(k,k♯):(Z,V)→(W,S)`. Forward parts compose associatively in **Set**. Backward:

- `((k∘g)∘f)♯(x,s) = f♯(x, (k∘g)♯(f x, s)) = f♯\bigl(x, g♯(f x, k♯(g(f x), s))\bigr)`;
- `(k∘(g∘f))♯(x,s) = (g∘f)♯\bigl(x, k♯((g∘f)x, s)\bigr) = f♯\bigl(x, g♯(f x, k♯(g(f x), s))\bigr)`.

The two right-hand sides are the same term. **Unitality.** Right:
`((f,f♯)∘(\mathrm{id},π_2))♯(x,u) = π_2(x, f♯(\mathrm{id}\,x, u)) = f♯(x,u)`.
Left: `((\mathrm{id},π_2)∘(f,f♯))♯(x,u) = f♯(x, π_2(f x, u)) = f♯(x,u)`. ∎

Both computations are *unfoldings*, so in Cubical Agda both laws are `refl`.
This is the cheapest possible formal-lane item and it is named as one in §7.

### 2.2 Chu transforms are exactly the state-independent lenses

**Definition 2.4 (held, quoted).** A Chu transform
`(F,G) : (X,T,e_X) → (Y,U,e_Y)` is `F : X→Y`, `G : U→T` with
`e_Y(Fx,u) = e_X(x,Gu)` (`ORDINAL_LADDER_SMALLNESS.md` Thm 3 proof, quoted
there from Barr/Pratt as standard).

**Theorem 2.5.** `ι(F,G) := (F,\ G\circ\pi_2)` is a lens, and `ι` is a
faithful functor from Chu transforms to lenses whose image is exactly the
lenses whose backward map is independent of its `X`-argument. Moreover
`ι(F',G') \circ ι(F,G) = ι(F'F,\ G\circ G')`.

*Proof.* Well-typedness is immediate. For the composite, Definition 2.1 gives
`h♯(x,v) = (G∘π_2)\bigl(x, (G'∘π_2)(Fx,v)\bigr) = G(G'v)`, independent of `x`;
so state-independent lenses are closed under composition and the backward
parts compose **contravariantly**, `G∘G'`. Faithfulness: `ι(F,G)=ι(F',G')`
forces `F=F'` and `G∘π_2 = G'∘π_2`, hence `G=G'` whenever `X` is inhabited.
Surjectivity onto the state-independent part: if `f♯(x,u)` does not depend on
`x`, set `G(u) := f♯(x_0,u)` for any `x_0`. ∎

This recovers, as a corollary, the held fact that the test half of a Chu
transform reverses direction — the contravariance proved in
`ORDINAL_LADDER_SMALLNESS.md` Thm 3 and used in `SURVIVING_LADDER_FRAGMENT.md`
§2.1. Nothing new is claimed there; what is new is that it is the *degenerate*
case of a strictly larger class, measured next.

### 2.3 The enlargement is strict, and its size is exact

**Theorem 2.6.** Fix finite `X,T,U` and a forward map `f`. The set of lens
backward maps over `f` is `T^{X\times U}`, of cardinality `|T|^{|X||U|}`;
the state-independent ones form the subset `\{G\circ\pi_2 : G\in T^{U}\}`, of
cardinality `|T|^{|U|}` (for `X` inhabited). The inclusion is **proper iff**
`|T|\ge2`, `|U|\ge1` and `|X|\ge2`, and its index is then
$$\bigl[\,T^{X\times U}:T^{U}\,\bigr] \;=\; |T|^{\,|U|\,(|X|-1)}.$$

*Proof.* Counting; `G\mapsto G\circ\pi_2` is injective for `X` inhabited, so
the two cardinalities are as displayed and their ratio is the index.
Properness needs a `f♯` not constant in `x`, which needs two distinct source
states and two distinct values, i.e. `|X|\ge2` and `|T|\ge2`, and needs at
least one target test to ask about, i.e. `|U|\ge1`. Conversely if `|X|=1`
every map is trivially state-independent; if `|T|=1` there is one map; if
`|U|=0` there is one map. ∎

**Minimal witness (three parameters, all minimal).**
`X=\{x_0,x_1\}`, `T=\{t_0,t_1\}`, `U=\{u\}`, `f♯(x_0,u)=t_0`,
`f♯(x_1,u)=t_1`. This is not `G\circ\pi_2` for any `G`, since `G(u)` would
have to equal both `t_0` and `t_1`. By Theorem 2.6 each of the three bounds
`|X|\ge2, |T|\ge2, |U|\ge1` is necessary, and this witness attains all three.
Four evaluations, all displayed — a finite exhaustive argument, hence proof
per `CLAUDE.md`.

### 2.4 What state-dependence means in this repository's vocabulary

A Chu transform pulls back a **fixed** test: given a target-side test `u`, it
names one source-side test `Gu`, whatever state is being probed. A lens pulls
back a **state-indexed family** of tests: `f♯(x,-) : U \to T` may name a
different source test at `x_0` than at `x_1`. In the language of
`CHANGING_TESTS_VERSUS_SHRINKING.md` this is the difference between a fixed
test set `S\subseteq\mathcal T` and an adaptive one; that note's entire
apparatus (the closure `C_\sigma`, the resolving-power preorder `\sqsubseteq`,
Theorem F's no-monotone-quantity result) is stated for fixed `S`, and its §9
declares the transform-compared case out of scope. **This note supplies the
finer morphism class and no theorem about it.** Whether `δ`, `C` and
`\sqsubseteq` have lens-indexed analogues, and whether Theorem F survives
adaptive replacement, is a `PROVE` seed (§7), not a claim.

---

## 3. Proof-relevant selection: what the value forgets, exactly

Throughout: `B` a set of intermediate choices, `Q` a linearly ordered set with
an operation `⊕`, `K : A\times B\to Q`, `V : B\to Q`, and the Bellman action
`\mathcal B_K(V)(a) = \min_{b}\bigl(K(a,b)\oplus V(b)\bigr)`, assumed attained.

**Definition 3.1 (D0026 §2.9, transcribed).**
$$\mathsf{Sel}_K(a,V)\;:=\;\sum_{b:B}\bigl[\,K(a,b)\oplus V(b) \;=\; \mathcal B_K(V)(a)\,\bigr].$$

**Identification 3.2 (held; this is not new).** `Sel_K(a,V)` is the record
`Argmin R V x` of `formal/cubical/NaturalMachine/DSOMinPlusFinite.agda`
(`witness : Ix n`, `realizes : bellman R V x ≡ R x witness ⊗ V witness`)
written as a Σ-type, and it is the min-plus instance of
`DEPENDENT_SYSTEM_OPTIMIZATION.md` §24's
`Argmin(b) = \sum_{x:E(b)}\prod_{y:E(b)}[J(b,x)\le J(b,y)]`. The corpus has
the object. What follows is what the corpus does not have about it.

### 3.1 The value is constant on the selection type

**Proposition 3.3.** The map
`\mathrm{val} : \mathsf{Sel}_K(a,V)\to Q`, `\mathrm{val}(b,p) := K(a,b)\oplus V(b)`,
is constant, with value `\mathcal B_K(V)(a)`.

*Proof.* `p`. ∎

One line, because it is a tautology about level sets — and that is the point:
Proposition 3.3 is **(T)** of `OBSERVABLE_DESCENT_COMMON_OBJECT.md` §1
instantiated at `X := B`, `q := \lambda b.\,K(a,b)\oplus V(b)`, fiber over
`\mathcal B_K(V)(a)`. No credit is claimed. Its use is §4.

### 3.2 h-level: when is selection propositional?

**Proposition 3.4.** Suppose `Q` is a set and `B` is a set. Then:
1. each fiber type `\bigl[K(a,b)\oplus V(b) = \mathcal B_K(V)(a)\bigr]` is a
   proposition, so `\mathsf{Sel}_K(a,V)` is a set;
2. `(b,p) = (b',p')` in `\mathsf{Sel}_K(a,V)` **iff** `b = b'`;
3. `\mathsf{Sel}_K(a,V)` is a proposition **iff** the minimizer is unique;
4. it is **contractible iff** the minimizer exists and is unique.

*Proof.* (1) Identity types of a set are props; a Σ of props over a set is a
set. (2) The second components are equal automatically by (1), so the total
paths are the paths in `B`. (3) By (2), any two inhabitants are equal iff
their witnesses are; that is uniqueness of the minimizer. (4) Prop +
inhabited. ∎

So *"multiple optimal paths remain multiple inhabitants"* (D0026 §2.9's
sentence) is exactly Proposition 3.4(2): the inhabitants of `Sel` are in
bijection with the minimizers, on the nose, not merely up to truncation.
This is the precise sense in which `Sel` is **not** a propositional
truncation of anything, and it is what `DEPENDENT_SYSTEM_OPTIMIZATION.md`
§24's own remark — *"stronger than merely knowing each argmin type is
inhabited after propositional truncation"* — asserts without proof. Here it
is proved.

### 3.3 The forgetting theorem, with a minimal witness

**Theorem 3.5 (Bellman value forgets the selection type).** There exist
kernels `K, K'` on the same `A,B,Q` and a common continuation `V` with
$$\mathcal B_K(V)(a) \;=\; \mathcal B_{K'}(V)(a)
\qquad\text{and}\qquad
\mathsf{Sel}_K(a,V)\;\not\simeq\;\mathsf{Sel}_{K'}(a,V).$$

*Witness.* `A=\{a\}`, `B=\{b_0,b_1\}`, `Q=\mathbb N`, `⊕ = +`, `V\equiv0`.

| | `K(a,-)` | `K'(a,-)` |
|---|---|---|
| `b_0` | `0` | `0` |
| `b_1` | `0` | `1` |

Then `\mathcal B_K(V)(a) = \min(0,0) = 0` and
`\mathcal B_{K'}(V)(a) = \min(0,1) = 0`: **equal**. But
`\mathsf{Sel}_K(a,V) = \{(b_0,\mathrm{refl}),(b_1,\mathrm{refl})\}\simeq\mathbf 2`
while `\mathsf{Sel}_{K'}(a,V) = \{(b_0,\mathrm{refl})\}\simeq\mathbf 1`
(the pair `(b_1,-)` would need `1=0`). Cardinalities `2\ne1`, so no
equivalence. Six evaluations, all displayed. ∎

**Proposition 3.6 (the witness is minimal in both parameters).** For
Theorem 3.5 one needs `|B|\ge2` and `|Q|\ge2`, and the witness attains both.

*Proof.* If `|B|\le1` then `\mathsf{Sel}` is `\mathbf 1` or `\mathbf 0`,
determined by whether the minimum is attained, which the value determines;
no separation. If `|Q|=1` all costs are equal, so
`\mathsf{Sel}_K(a,V)=B` for every `K`; again determined. The witness has
`|B|=2` and takes values in `\{0,1\}`, so `|Q|=2` suffices. ∎

**Corollary 3.7 (exactly what the value determines about `Sel`).** For finite
nonempty `B` with the minimum attained, `\|\mathsf{Sel}_K(a,V)\|_{-1}` is
always inhabited; and by Theorem 3.5 the value determines nothing further —
not the cardinality, hence not the identity type, hence not (by
Proposition 3.4) whether the optimum is unique. **The Bellman value's entire
content about the selection type is the inhabitedness it gets for free.**

*Remark 3.8 (typed analogy, not a theorem).* This is the same shape as
`formal/cubical/NaturalMachine/Decategorification.agda`, which checks that
`\mathrm{card} : \mathbf{FinSet}\to\mathbb N` is exactly a `π_0` statement and
that what the collapse discards is the loop space. `Sel \rightsquigarrow`
value is a collapse of the same *kind* — a set to a label. It is **not** the
same theorem (no groupoid, no univalence is used in §3), and I mark the
analogy as typed and stop, per this repository's practice on such remarks.

---

## 4. The join with `VERIFIER_BLIND_FIBER_REWARD` — stated at the strength it actually has

This is the section the queue flagged as the strongest available cross-corpus
result. It is a real join, and it is **one degree less new than it looks**,
because `OBSERVABLE_DESCENT_COMMON_OBJECT.md` got to the general lemma first.
Saying so is the whole point of the fence in §1.

### 4.1 What was already joined

`OBSERVABLE_DESCENT_COMMON_OBJECT.md` §1 proves **(T)**: for observables
`q,f` on a state set `X`, `f` factors through `q` iff `f` is constant on every
`q`-fiber; the closure operator is "all functions constant on the fibers".
Its §2 lists three instantiations, and item 2 says in as many words:
*"Theorem A is the degenerate instance (the verifier's partition has ONE fiber
on each event set, so descent forces constancy); the discrimination lattice of
formats is exactly the partition lattice between `q` and the identity."*
So: (T) ⊃ Theorem A ⊃ the format lattice of Theorem B. All held.

### 4.2 The fourth costume

**Statement J1.** `\mathsf{Sel}_K(a,V)` is a fourth instantiation of (T), with
`X := B` and `q := \lambda b.\,K(a,b)\oplus V(b)`. Under it:

1. the fiber `q^{-1}\bigl(\mathcal B_K(V)(a)\bigr)` **is** `\mathsf{Sel}_K(a,V)`
   as a type (Definition 3.1, Proposition 3.4);
2. every reward that is a function of the Bellman value alone is a function
   of `q`'s *value*, hence by Proposition 3.3 constant on `\mathsf{Sel}` —
   verifier-blind on the optimizer fiber, in the exact sense of
   `VERIFIER_BLIND_FIBER_REWARD` Theorem A;
3. the trace formats on this fiber form the partition lattice between the
   constant map and the identity (Theorem B's lattice, transported along (T)),
   whose **bottom** is the value — Theorem B(1), outcome supervision — and
   whose **top** is `\pi_1 : \mathsf{Sel}_K(a,V)\to B` — Theorem B(4),
   process supervision, which *replays*, since `\pi_1` recovers the witness
   and `p` is then forced;
4. therefore **process supervision = retaining `Sel`**, and this is now a
   sentence with a referent: the trace format is the map `\pi_1` rather than
   the terminal map `\mathsf{Sel}\to\mathbf 1`, and Theorem B says these are
   the two ends of one lattice.

**What is new in J1, precisely.** Not (T), not Theorem A, not the lattice.
What is new is the *direction of use*. In the three instantiations already
recorded, the fiber is a **defect**: in the verifier lane it is the reward's
blindness, to be repaired only by importing an execution ecology; in the
Nerode lane it is a policy that fails to descend; in the formation lane it is
a split to be absorbed into a new carrier. In the `Sel` lane the fiber is
**kept on purpose, as a type**. That is the constructive answer to the same
problem, and it had not been placed alongside the other three.

### 4.3 The reward-design consequence, at the right strength

**Statement J2 (the exact scope of the blindness).** Outcome reward is blind
*within* the fiber and fully sighted *across* it. A suboptimal `b` has
strictly larger cost and is separated by the value; two optimal `b,b'` are
not. So the training signal available from the Bellman value alone is exactly
the two-class partition of `B` into `\mathsf{Sel}`-members and non-members.
Anything finer — *which* optimal route, in what order, by which intermediate —
requires the format to retain `\pi_1`.

This is the useful correction to a slogan. "Outcome reward carries zero bits"
is true *on the fiber* and false on `B`; `VERIFIER_BLIND_FIBER_REWARD`
Theorem A is stated on `E(M)`, i.e. already restricted to the fiber, and it is
correct there. J2 states the unrestricted version so that the next reader does
not over-generalise it.

**Statement J3 (no natural tie-break; exact finite witness).** Let `G` be a
group of automorphisms `\sigma` of `B` with `K(a,\sigma b)=K(a,b)` and
`V(\sigma b)=V(b)`. Then `G` acts on `\mathsf{Sel}_K(a,V)` over the value, and
a *canonical* optimal witness — a `G`-invariant point of `\mathsf{Sel}` — exists
only if the action has a fixed point. In Theorem 3.5's witness `K` (the tied
kernel), `G=\mathbb Z/2` acting by `b_0\leftrightarrow b_1` acts **freely** on
the two-element `\mathsf{Sel}`, so no invariant witness exists: the tie-break
must be imported. ∎ (Two elements, exhaustive.)

J3 is `VERIFIER_BLIND_FIBER_REWARD` §3's import theorem (R0027 §4 by
note-path, per that note's provenance addendum) in the selection dialect, and
it is simultaneously `DEPENDENT_SYSTEM_OPTIMIZATION.md` §24–25's *"the global
optimizer is a section"* and *"local optimal sections may exist while no
coherent global optimizer section exists"*. **These are the same statement in
three dialects.** I add nothing to any of them; I name the identity, which is
the deliverable the anti-duplication organ (`NAME_TO_OBJECT_INDEX.md` N2)
exists to collect.

### 4.4 The fence: what does *not* transfer

The torsor structure does not transfer, and pretending it does would be the
error this note is written against.

- `E(M)` is a **regular `\Gamma_0^{\pm}(m)`-torsor** with a payload bijection
  `\pi`; `\mathsf{Sel}_K(a,V)` is a bare fiber with no group action in
  general. Everything in `VERIFIER_BLIND_FIBER_REWARD` that uses the group —
  Theorem B(2)'s *exactly two* det-classes, B(3)'s unipotent `\mathbb Z`,
  the corollary's "replay iff `q` is a relabeling of a payload chart", the
  successor seed's growth series — **has no analogue here** and none is claimed.
- The **infinitude** of the fiber is a fact about `\Gamma_0^{\pm}(m)`. `Sel`
  over a finite `B` is finite, of size = number of minimizers.
- Anything about **entropy or incompressible density** of the fiber transfers
  not at all; there is no measure here.

What transfers is exactly two things: the level-set lemma (T) — already
held — and the two ends of the format lattice. That is the honest size of
the join.

---

## 5. The matching-pennies separator

### 5.1 The game, exactly

Actions `\{H,T\}` for each of two players; payoff pairs `(u_1,u_2)`, rows =
player 1's action, columns = player 2's:

| | `H` | `T` |
|---|---|---|
| **`H`** | `(+1,\,-1)` | `(-1,\,+1)` |
| **`T`** | `(-1,\,+1)` | `(+1,\,-1)` |

### 5.2 Every pure profile has the same social sum

`W(a_1,a_2) := u_1(a_1,a_2)+u_2(a_1,a_2)`. Four evaluations:

`W(H,H)=(+1)+(-1)=0`; `W(H,T)=(-1)+(+1)=0`;
`W(T,H)=(-1)+(+1)=0`; `W(T,T)=(+1)+(-1)=0`.

So `W\equiv 0`. (This is the zero-sum condition; the point is that it makes
the welfare summary a *constant function on the profile set*.)

### 5.3 No pure profile is Nash — via the best-response maps

`\beta_1(a_2) := \arg\max_{a_1}u_1(a_1,a_2)`:
`u_1(H,H)=+1>u_1(T,H)=-1\Rightarrow\beta_1(H)=H`;
`u_1(T,T)=+1>u_1(H,T)=-1\Rightarrow\beta_1(T)=T`. So
$$\beta_1=\mathrm{id}.$$
`\beta_2(a_1):=\arg\max_{a_2}u_2(a_1,a_2)`:
`u_2(H,T)=+1>u_2(H,H)=-1\Rightarrow\beta_2(H)=T`;
`u_2(T,H)=+1>u_2(T,T)=-1\Rightarrow\beta_2(T)=H`. So
$$\beta_2=\mathrm{swap}.$$
Both are single-valued (all comparisons strict), so `(a_1,a_2)` is a pure
Nash equilibrium iff `a_1=\beta_1(a_2)` and `a_2=\beta_2(a_1)`, i.e. iff
`a_1=a_2` and `a_2=\mathrm{swap}(a_1)`, i.e. iff `a_1=\mathrm{swap}(a_1)`.
`\mathrm{swap}` is a fixed-point-free involution of a two-element set.
**Hence the pure-Nash set is empty.** ∎

**The best-response cycle** (each arrow is the deviation of the labelled
player, and it is the whole improvement graph):
$$(H,H)\ \xrightarrow{\ 2\ }\ (H,T)\ \xrightarrow{\ 1\ }\ (T,T)\
\xrightarrow{\ 2\ }\ (T,H)\ \xrightarrow{\ 1\ }\ (H,H).$$
A single 4-cycle covering all four profiles; no sink, hence no equilibrium,
which is the same fact read off the graph.

### 5.4 The separator, and it is theorem (T) again

Put `\mathcal A := \{H,T\}^2` (four profiles) and consider three summary maps
on `\mathcal A`:

| summary | value | fibers |
|---|---|---|
| social welfare `W` | constantly `0` | **one** |
| pure-equilibrium predicate `\mathrm{PNE}` | constantly `\mathrm{false}` (§5.3) | **one** |
| best-response structure `\beta_2\circ\pi_1` | `\mathrm{swap}\circ\pi_1`, non-constant | **two** |

**Theorem 5.1 (separator).** `\beta_2\circ\pi_1` does not factor through `W`,
and does not factor through `\mathrm{PNE}`.

*Proof.* By (T) (`OBSERVABLE_DESCENT_COMMON_OBJECT.md` §1), a map factors
through `q` iff it is constant on every `q`-fiber. `W` and `\mathrm{PNE}` each
have a single fiber, namely all of `\mathcal A`; a map constant on that fiber
is constant. `\beta_2\circ\pi_1` takes value `T` at `(H,\cdot)` and `H` at
`(T,\cdot)`, so it is not constant. ∎

**Corollary 5.2 (D0026 §2.9's warning, proved).** Scalar welfare and
equilibrium-only summaries erase semantically relevant off-equilibrium
structure: any reward, score, or report that is a function of `W` or of the
equilibrium set alone is constant on `\mathcal A` and therefore cannot
distinguish any two of the four profiles, while the best-response
correspondence distinguishes them. ∎

*Remark 5.3 (this is §4 again).* Corollary 5.2 is Statement J1(2) with `B`
replaced by `\mathcal A` and the cost observable replaced by `W`: a summary
whose fiber is the whole space carries zero bits about position within it.
The matching-pennies table is a **strategic** witness for the same theorem
`VERIFIER_BLIND_FIBER_REWARD` Theorem A is a *number-theoretic* witness for.
That the corpus's deepest reward statement and von Neumann's oldest game
example are one theorem is the finding of this note.

*Remark 5.4 (mixing does not repair discrimination).* The mixed extension has
value `0`, attained at the uniform pair (von Neumann 1928 minimax; cited from
`D0020_CLASSICAL_SOURCES.md` row 4.13, **not read here**). So passing to mixed
strategies restores *existence* of an equilibrium but not *discrimination*:
the value summary is still a constant, and the discriminating datum is still
`\beta_2`. I state this as a remark because the mixed argument is quoted, not
derived on this page.

*Remark 5.5 (nearest in-repo neighbour, and it is a different statement).*
`FLEET_BREAKER_PASS_2026_08_14.md` §1.2 refutes COORDINATION_THEOREMS_XVI
Thm 431 with `u_1(a_1,a_2)=a_1+a_2`: non-factorable payoff, yet
`\arg\max_{a_1}=\{1\}` for every `a_2`, so best response is
external-independent. That separates *non-factorability* from
*best-response coupling*. Theorem 5.1 separates *welfare/equilibrium
summaries* from *best-response structure*. Neither implies the other; they
are the two halves of the same caution and belong in one index cluster. That
note also records that matching pennies is the canonical **harmonic** game of
the Candogan–Menache–Ozdaglar–Parrilo decomposition and that "the repo has
potential games at 202–205 and never connects them" — this note does not
connect them either, and that remains open (§7).

### 5.5 Certificate-readiness, and the Agda shape

**Verdict: certificate-ready, with no obstruction of any kind.** Every
statement in §§5.2–5.4 is a finite check over `\mathbf{Bool}\times\mathbf{Bool}`
with decidable equality and payoffs in a two-element subset of `\mathbb N`.

Normalize to `\mathbb N` to keep everything in the `--safe` fragment without
`Int`: replace `u_i` by the positive affine image `u_1(a,b) := [a=b]`,
`u_2 := 1-u_1`. Best responses are invariant under a per-player positive
affine transformation, so `\beta_1,\beta_2` are unchanged, and `W\equiv1`
instead of `0`. The shape:

```agda
{-# OPTIONS --cubical --safe --no-import-sorts #-}
module NaturalMachine.MatchingPenniesSeparator where
-- H := true, T := false.

u₁ u₂ : Bool → Bool → ℕ
u₁ true  true  = 1  ;  u₁ true  false = 0
u₁ false true  = 0  ;  u₁ false false = 1
u₂ a b with u₁ a b   -- = 1 ∸ u₁ a b, four clauses

-- (1) welfare constant                                  4 clauses, all refl
welfare-const : (a b : Bool) → u₁ a b + u₂ a b ≡ 1

-- (2) best responses                                    β₁ = id, β₂ = not
β₁-best : (a b : Bool) → u₁ a b ≤ u₁ b b
β₂-best : (a b : Bool) → u₂ a b ≤ u₂ a (not a)

-- (3) no pure Nash                            4 clauses, each a 1 ≤ 0 refutation
IsNash : Bool → Bool → Type₀
IsNash a b = ((x : Bool) → u₁ x b ≤ u₁ a b) × ((y : Bool) → u₂ a y ≤ u₂ a b)
no-pure-nash : (a b : Bool) → IsNash a b → ⊥

-- (4) the separator                              one clause, false≢true
β₂-not-constant : ¬ (not true ≡ not false)
```

Thirteen clauses, no postulates, no holes, imports limited to
`Cubical.Data.Bool`, `.Nat`, `.Empty`, `.Sigma`. Each `no-pure-nash` clause is
discharged by the deviation named in §5.3's cycle, whose payoff comparison
reduces to `¬ (1 ≤ 0)` on `\mathbb N`. The lens category laws of Theorem 2.3
are likewise `refl` and belong in a sibling module. **Neither module was
authored or typechecked for this note**; both are named as `PROVE` items in
§7.

---

## 6. Scope fence

1. **§1 governs.** Where §1.1 says an item is held, this note does not
   re-prove it and any appearance of doing so is an error to be reported.
   In particular `Sel_K` is *not* claimed as new; §3.1 is a one-line instance
   of a held lemma; §4.1 explicitly disclaims the join's headline.
2. **Observation 2.2 is not a parametricity theorem.** It says the law of
   Definition 2.1 is the unique composite built from the given data without
   discarding an argument. A free theorem asserting uniqueness among *all*
   natural families is not proved here and is not used.
3. **No theorem about lenses acting on the defect theory.** §2.4 raises the
   question of lens-indexed analogues of `δ`, `C`, `\sqsubseteq` and of
   Theorem F of `CHANGING_TESTS_VERSUS_SHRINKING.md`. None is answered. In
   particular nothing here bears on whether that note's Theorem F (no monotone
   quantity under unrestricted replacement) survives adaptive replacement.
4. **§3 assumes the minimum is attained** and `Q` a set; over an infinite `B`
   with no attained minimum `\mathsf{Sel}` is empty and Corollary 3.7 is
   vacuous. `\mathcal B_K(V)` as an infimum is not treated.
5. **The torsor fence of §4.4 is binding.** No group-theoretic consequence of
   `VERIFIER_BLIND_FIBER_REWARD` transfers to `\mathsf{Sel}`, and none is used.
6. **Remark 3.8 is a typed analogy**, not a theorem about `\mathbf{FinSet}`.
7. **Remark 5.4's mixed-strategy statement is quoted**, from a row of
   `D0020_CLASSICAL_SOURCES.md` marked "Not read". No minimax theorem is
   proved or used in §5's proofs; §5.3 uses only the four-entry table.
8. **Nothing is machine-checked.** No Agda or Lean was authored; §5.5 is a
   shape. No PDF was decoded, no external text opened, no network call made.
9. **No Python. No numerics, no fitted constant, no floating-point number,
   no correlation.** Every argument above is finite and exhaustive or a
   one-line unfolding.
10. **D0026's epistemic marks are not upgraded.** §2.9's own header records
    that *"No equivalence between middle Isbell types and open-game strategic
    contexts has been proved"*; this note proves none and asserts none.

---

## 7. Prior art — named from memory, **all SEARCH-pending**

Per `CLAUDE.md` ("prior art gets searched **before** the experiment"), and
per this container's standing limits: **none of the following was fetched,
opened, or read for this note.** Every one is recalled from memory and is
marked `SEARCH` for a successor with egress. No numbered result is quoted
from any of them.

| # | Attribution (from memory) | What it covers here | Mark |
|---|---|---|---|
| P1 | M. Barr, *\*-Autonomous Categories*, LNM **752** (1979), appendix by P.-H. Chu | The Chu construction; `(X,T,e)` and Chu transforms. Already cited in-repo as "Barr; Pratt — standard" (`ORDINAL_LADDER_SMALLNESS.md` Thm 3) | `SEARCH` |
| P2 | V. de Paiva, *The Dialectica Categories* (Cambridge PhD, 1988; Contemp. Math. **92**, 1989); and "Dialectica and Chu constructions: cousins?", *TAC* (2007) | The Dialectica category, and its precise relation to Chu — which is exactly the state-dependence of §2 | `SEARCH` |
| P3 | Foster–Greenwald–Moore–Pierce–Schmitt, "Combinators for bidirectional tree transformations", *TOPLAS* **29** (2007); earlier F. J. Oles (1982) on store shapes | Lenses/`get`–`put`; **Theorem 2.3 is certainly folklore there** and no novelty is claimed for it | `SEARCH` |
| P4 | M. Escardó and P. Oliva, "Selection functions, bar recursion and backward induction", *MSCS* **20** (2010); "Sequential games and optimal strategies", *Proc. R. Soc. A* **467** (2011) | The selection monad `J_R X=(X\to R)\to X`; that Nash equilibria arise from products of selection functions. **This is the natural home of §3 and almost certainly contains Proposition 3.4 in some form** | `SEARCH` |
| P5 | N. Ghani, J. Hedges, V. Winschel, P. Zahn, "Compositional game theory", *LICS* (2018); J. Hedges, "Coherence for lenses and open games" (arXiv, ~2017) | Open games, built on exactly the lens composition of §2; the equilibrium-vs-behaviour distinction of §5 | `SEARCH` |
| P6 | M. Riley, "Categories of optics" (arXiv, 2018) | Lenses as optics; the general composition law | `SEARCH` |
| P7 | J. von Neumann, "Zur Theorie der Gesellschaftsspiele", *Math. Ann.* **100** (1928) 295–320 | Minimax; matching pennies as the standard zero-sum example. Held in-repo as a bibliography row (`D0020_CLASSICAL_SOURCES.md` 4.13), marked "Not read" there too | `SEARCH` |
| P8 | J. Nash, "Equilibrium points in n-person games", *PNAS* **36** (1950) 48–49 | Equilibrium existence in mixed strategies; Remark 5.4 only | `SEARCH` |
| P9 | O. Candogan, I. Menache, A. Ozdaglar, P. Parrilo, "Flows and decompositions of games: harmonic and potential games", *Math. OR* **36** (2011) | Matching pennies as the canonical **harmonic** game. Already named in-repo at `FLEET_BREAKER_PASS_2026_08_14.md` §1.2, which observes the repo never connects it to its own potential games | `SEARCH` |

**What, if anything, is new.** Stated deliberately small, because
over-claiming is the failure `CLAUDE.md` was written against:

1. **Theorem 2.6 and its minimal witness** — the exact index
   `|T|^{|U|(|X|-1)}` of Chu transforms inside lenses over a fixed forward
   map, with all three parameters proved minimal. Elementary; I did not find
   it stated, and it may well be folklore.
2. **Theorem 3.5 + Proposition 3.6** — the two-kernel, two-element minimal
   witness that the Bellman value at a fixed continuation does not determine
   the selection type. Trivial to check, and *absent from this corpus*, which
   held only the slogan and the rank inequality `r(K)\le\mathrm{wrank}(K)`.
3. **Statement J1's fourth costume** — placing `Sel` alongside the three
   instantiations of (T) already recorded, and noting that it is the one in
   which the fiber is retained by construction rather than lamented as a
   defect. This is an *identification*, not a theorem.
4. **Theorem 5.1** — matching pennies read as a descent failure through (T),
   which makes it literally the same theorem as
   `VERIFIER_BLIND_FIBER_REWARD` Theorem A.

Everything else above is a rediscovery or a transcription, labelled as one.

---

## 8. Declared consumers

- **`notes/VERIFIER_BLIND_FIBER_REWARD.md`** — the primary consumer. §4 gives
  its Theorem A/B a second, non-arithmetic witness (§5) and a constructive
  counterpart (§3), and J2 states the unrestricted scope of the blindness so
  the theorem is not over-generalised downstream. **No edit to that note is
  proposed**; this is an addition, per the standing rule to correct and extend
  by addition.
- **`notes/OBSERVABLE_DESCENT_COMMON_OBJECT.md`** — gains a fourth
  instantiation of (T) (`Sel`) and a fifth (matching pennies, §5.4). Its
  successor-seed list should record them.
- **`notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` §24–25** — §3.4 supplies the
  h-level analysis its own remark asserts without proof, and J3 identifies its
  optimizer-section problem with the import theorem of the verifier lane.
- **`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §9** — §2 supplies the finer
  morphism class its scope limit names, and no theorem about it. The
  successor question is whether Theorems C/E/F survive adaptive replacement.
- **`notes/D0026_BUILD_QUEUE.md` Q10** — **amend**: `Sel_K` is held (§1.1),
  not absent. The absent items are the lens, the forgetting theorem, and the
  separator. Q10 is discharged by this note modulo the two `PROVE` items below.
- **`notes/NAME_TO_OBJECT_INDEX.md`** — new cluster proposed:
  *(T) / level-set blindness*, with members `OBSERVABLE_DESCENT` §1,
  `VERIFIER_BLIND` Thm A, `Sel_K` (§4), matching pennies (§5.4),
  `FLEET_BREAKER` §1.2 (adjacent, different statement).
- **`notes/EGB_LIBRARY_INDEX_V3.md`** entries 123/130/131 — the index rows
  "matching-pennies scalarization no-go" and "proof-relevant argmin
  decomposition" now have a repo-side referent.

**Open items entering the queue from this note:**

- `PROVE` — `NaturalMachine.MatchingPenniesSeparator`, the §5.5 shape, `--safe`,
  no holes. Thirteen clauses; the cheapest certified game-theoretic statement
  available to this corpus.
- `PROVE` — `NaturalMachine.LensComposition`, Theorem 2.3 (associativity and
  both units, all `refl`) plus Theorem 2.5's functor `ι` and the §2.3 minimal
  witness of properness.
- `PROVE` — lens-indexed `δ`: does `CHANGING_TESTS_VERSUS_SHRINKING.md`
  Theorem F survive when replacement is adaptive (state-indexed test
  families) rather than fixed? §2.4.
- `SEARCH` — P1–P9 above, and specifically whether Escardó–Oliva already state
  Proposition 3.4 (h-level of the selection type) and whether
  Ghani–Hedges–Winschel–Zahn already state Theorem 5.1 as an open-games
  motivating example. Both are likely.
- `PROVE` (inherited, unresolved) — connect the repo's potential games
  (`FLEET_BREAKER` §1.2's "202–205") to the Candogan et al. harmonic component
  of which §5's game is the canonical instance.

---

*Question and framework: the repository owner, D0026 §2.9 (owner Delta 30),
2026-08-16. Prior-art fence (§1), Theorems 2.3/2.5/2.6, Propositions
3.3–3.6, Corollary 3.7, Statements J1–J3, Theorem 5.1 and Corollary 5.2: this
note. No experiment was run; no Python; no measurement; nothing typechecked.*
