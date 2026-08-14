# The future-behavior quotient is standard coalgebra, and we proved it again

**Verdict, first line, plainly: `NaturalMachine/FutureBehavior.agda` is the
minimal-realization theorem for coalgebras of the Moore functor
$F(Z) = O \times Z^{A}$, proved from scratch under private names. Eighteen of
its twenty statements have standard names and standard sources dating from
1958–2000. Nothing in it is new mathematics.**

Two qualifications, both of which matter and neither of which rescues the
theory:

1. The right correction is **not** "import the library's M-types." The local
   Cubical library's final-coalgebra machinery (`Cubical.Codata.M`) does supply
   the universal property, but in a form that is provably unusable for us —
   details in §4. The right correction is 25 lines *inside our own module*
   naming the final coalgebra we are already implicitly using, and deriving
   three of our theorems from it instead of re-running the same induction three
   times (§5).
2. The corpus's value here is the **instantiations**, not the theory — and on
   audit the Agda lane currently has **none**. `FutureQuotient` and
   `MachineFutureBehavior` are imported by exactly one file
   (`formal/cubical/NaturalMachine.agda`, the index module) and used by zero.
   The Lean lane did better: `Pairfield/MyhillNerodeAdapter.lean` already
   imports `Mathlib.Computability.MyhillNerode` and proves
   `futureEq_iff_stateLanguage_eq`, i.e. it already did the thing this note is
   recommending. §6 states the redirection.

---

## 1. What we actually proved

Inventory of `formal/cubical/NaturalMachine/FutureBehavior.agda` (445 lines,
`--cubical --guardedness --safe`, no holes, no postulates).

The data is a `Machine`: `State X`, `Action A`, `Obs O` with `isSet O`,
`step : X → A → X`, `observe : X → O`. That is exactly an $F$-coalgebra
$\gamma = \langle \mathrm{observe}, \mathrm{step}\rangle : X \to O \times X^{A}$
for the **Moore / language functor** $F = O \times (-)^{A}$, with the two
components curried apart.

| § | our name | statement |
|---|---|---|
| 1 | `run`, `behavior` | `behavior step observe x : List A → O` |
| 2 | `FutureEq` | `∀ w. behavior x w ≡ behavior y w` |
| 2 | `futureEq-refl/-sym/-trans` | equivalence relation |
| 2 | `futureEq-step` | closed under every action |
| 2 | `futureEq→behavior≡`, `behavior≡→futureEq` | `FutureEq = ker(behavior)` |
| 3 | `futureEq-of-finer` | a finer observation refines the relation |
| 3 | `futureEq-pair→`, `futureEq-pair←` | joint observation ⇒ intersection |
| 4 | `isBehavioralCongruence` | `respects-observe` + `respects-step` |
| 4 | `futureEq-isCongruence` | `FutureEq` is one |
| 4 | `congruence→futureEq` | **it is the greatest one** |
| 5 | `Meaning = X / FutureEq`, `isSetMeaning` | the quotient, a set |
| 5a | `quotStep`, `quotObserve` | machine structure descends |
| 5a | `quotRun-[]`, `quotient-preserves-behavior` | projection preserves behavior |
| 5b | `[]-effective`, `[]-effectiveIso` | **effectivity**: `Path Meaning [x] [y] ≅ FutureEq x y` |
| 5c | `quotBehavior`, `quotBehavior-injective` | meanings embed in `List A → O` |
| 5c | `crystal-minimal` | quotient separates its own behaviors |
| 5d | `factor`, `factor-unique` | universal property of the set quotient |
| 5e | `Terminal.stepQ/observeQ` | any congruence quotient is a machine |
| 5e | `Terminal.mediate`, `-step`, `-observe`, `-unique` | **unique machine morphism onto `Meaning`** |
| 6 | `crystal`, `crystal-sound`, `crystal-fullyAbstract` | packaging |

The prose treatment is `notes/MATHEMATICS_THAT_LEARNS.md` §"Forgetting and
remembering", which says of this construction: *"This single idea appears as
minimal automata, sufficient statistics, bisimulation, quotient dynamics, and
the identification of experimentally indistinguishable states. The names belong
to different mathematical traditions; the useful connection is the explicit
factorization they share."* — and its Doors section already cites Myhill 1957,
Nerode 1958, Kalman 1960. `notes/COGNITIVE_ORIENTATION.md` §4 already says
*"Final coalgebras and unfolds provide the corresponding language for processes
that continue"* and *"Myhill–Nerode quotients … become adjacent through explicit
constructions."*

**So the corpus already knew.** `collab/messages/madhavi/0003-simplest-mathematical-center.md`
states the answer outright: *"Moore machine, or, in coalgebraic language, the
image of the unique behavior map into the final `O x (-)^A`-coalgebra,"* and
cites Rutten 2000 by name. The failure was not ignorance of the literature; it
was that the Agda module was written anyway, without the citation, without the
universal property, and without importing anything.

---

## 2. Theorem-by-theorem correspondence

Śabda grading, per `PROTOCOL.md` §7 and `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`
(which withdraws "śabda is weakest" as a *Nyāya* claim while keeping the
practical instruction *check the actual source*):

- **Ś1 — verified by fetch of the primary text.** *None in this note.* WebFetch
  is EGRESS_BLOCKED in this environment, including ncatlab.org.
- **Ś2 — search-snippet testimony.** A search engine returned a summary of, or
  bibliographic record for, the named source. Enough to fix a name and a
  citation; **not** enough to quote a theorem number.
- **Ś3 — recalled.** From model memory, no source consulted this session.
  Treat as a conjecture about the literature.

| # | our name | standard name | standard source | grade |
|---|---|---|---|---|
| 1 | `Machine` | $F$-coalgebra for the **language functor** $F = O\times(-)^{A}$; Moore automaton | Rutten, *Automata and Coinduction (an exercise in coalgebra)*, CWI SEN-R9803 / CONCUR '98, LNCS 1466, 194–218 | Ś2 |
| 2 | `behavior step observe` | the unique $F$-coalgebra homomorphism into the **final coalgebra**, whose carrier is $O^{A^{*}}$ | Rutten, *Universal Coalgebra: a theory of systems*, TCS 249(1):3–80, 2000 | Ś2 |
| 3 | `run` | Kleene-star action / the free-monoid extension $\hat\delta$ | Nerode, *Linear Automaton Transformations*, PAMS 9 (1958) | Ś3 |
| 4 | `FutureEq` = `ker(behavior)` (`futureEq→behavior≡` + converse) | **behavioural equivalence** (= observational equivalence); "two states are behaviourally equivalent iff they are identified by the final map" | Rutten 2000; Jacobs, *Introduction to Coalgebra*, CUP Tracts 59, 2016, ch. on deterministic automata & final coalgebras | Ś2 |
| 5 | `FutureEq` in automata language | the **Myhill–Nerode / Nerode right congruence**; $x \sim y$ iff equal residuals | Myhill 1957; Nerode 1958; Kozen, *Automata and Computability* Lec. 15 "Myhill–Nerode Relations" | Ś2 |
| 6 | `futureEq-refl/-sym/-trans` | (that the kernel of a map is an equivalence) | folklore | Ś3 |
| 7 | `futureEq-step` + `respects-observe` = `isBehavioralCongruence` | **Aczel–Mendler bisimulation / $F$-congruence** for a polynomial $F$ | Rutten 2000 §§2–5: "coalgebra, homomorphism of coalgebras, and bisimulation" is dual to "algebra, homomorphism, congruence" | Ś2 |
| 8 | `futureEq-isCongruence` | bisimilarity is itself a bisimulation | Rutten 2000 | Ś2 |
| 9 | **`congruence→futureEq`** (greatest congruence) | **bisimilarity = greatest bisimulation = behavioural equivalence**, valid because $F$ preserves weak pullbacks (every polynomial functor does) | the coincidence theorem: "when a functor $F$ preserves weak pullbacks, behavioural equivalence and coalgebraic bisimilarity coincide"; separating counterexample $\mathcal{P}\mathcal{P}$ | Ś2 |
| 10 | `quotStep`, `quotObserve` (descent) | **quotient coalgebra**: a coalgebra structure descends along the projection by any congruence | Gumm, *Elements of the General Theory of Coalgebras*, LUATCS'99 lecture notes; "factoring by the largest congruence … $T := W/\nabla W$" | Ś2 |
| 11 | `quotRun-[]`, `quotient-preserves-behavior` | **coalgebra homomorphisms preserve behaviour** (immediate from uniqueness of the final map) | Rutten 2000 | Ś2 |
| 12 | `quotBehavior-injective`, `crystal-minimal` | the quotient is a **simple** (= extensional, = minimal, = observable) coalgebra: it embeds into the final coalgebra; equivalently it is the **image factorization** of the behaviour map | Gumm (simple coalgebra); Jacobs 2016 (image/behaviour–realisation adjunction) | Ś2 |
| 13 | `crystal` + `crystal-sound` + `crystal-fullyAbstract` | **minimal realisation** of a behaviour; in the linear case, Kalman's minimal realisation and observability reduction | Malcolm–Goguen (?), *Behavioural Equivalence, Bisimulation, and Minimal Realisation*, LNCS 1130 (COMPASS/ADT '95): "bisimulation is 'the same as' behavioural equivalence … a particular construction for minimal realisation of behaviour corresponds to a proof technique for proving behavioural equivalence"; Kalman, *On the General Theory of Control Systems*, IFAC 1960 | Ś2 (paper), Ś3 (authorship) |
| 14 | `Terminal.mediate*` (unique morphism $X/S \to X/{\sim}$) | **`Meaning` is the terminal object of the poset of quotient coalgebras of $X$**; the congruence lattice of a coalgebra has a largest element, namely $\ker(\text{final map})$ | Gumm, congruence-lattice section | Ś2 |
| 15 | `factor`, `factor-unique` | universal property of the coequalizer/quotient in **Set** — not coalgebraic at all | folklore | Ś3 |
| 16 | `futureEq-of-finer` | functoriality of behaviour along a natural transformation of functors ($O$-component of $F$) | Jacobs 2016, "changing the functor" | Ś3 |
| 17 | `futureEq-pair→`/`←` | $O \mapsto O^{A^{*}}$ preserves products, so the Nerode congruence of a product Moore machine is the intersection | no crisp standard name found | Ś3 |
| 18 | `[]-effective`, `[]-effectiveIso` | in **Set**, trivial (all equivalence relations are effective). In HoTT it is real content, and it is **already in the library**: `SQ.effective` / `SQ.isEquivRel→effectiveIso` from `Cubical.HITs.SetQuotients.Properties` — which we correctly import and use | Cubical library, local | Ś1 (read the source file) |

**Count: 18 rows. 15 have standard names and named sources (Ś2/Ś3); 1 (#18) is
library machinery we already correctly imported; 2 (#15, #17) are generic
set-theory / bookkeeping. Zero rows are novel mathematics.**

The sharpest single observation: rows 9, 11, and the definition of `behavior`
are **the same induction on `List A`, written out three times**. That induction
*is* the proof that $O^{A^{*}}$ is the final $F$-coalgebra. We proved finality
three times without ever stating it.

---

## 3. Correcting one thing the task brief said

The brief says "the 'future-behavior quotient' is the image factorisation into
the FINAL coalgebra" — correct — and that the library's M-types might supply
it. But note the final coalgebra here is not an M-type in any interesting
sense: for $F = O \times (-)^{A}$ with $A$ a *constant* type, the final
coalgebra has the **explicit closed carrier**

$$\nu F \;=\; O^{A^{*}} \;=\; \texttt{List A → O},$$

with structure $\mathrm{obs}(\beta) = \beta\,[\,]$ and
$\mathrm{step}(\beta)(a)(w) = \beta\,(a :: w)$. That type already appears in our
module — it is the type of `behavior step observe x` (line 113) and the target
of `quotBehavior` (line 301). **We have been carrying the final coalgebra's
carrier around since the first line of the module without naming it.** No
coinduction, no guardedness, no M-type is needed to get it; `List` induction
suffices.

---

## 4. Local-library verdict

`~/agda-libs/cubical/Cubical/Codata/` contains 20 modules. Our corpus imports
zero of them. Here is the honest audit of whether it should.

### 4.1 `Cubical.Codata.M` — has the universal property, cannot be used

This module (`{-# OPTIONS --safe --guardedness #-}`) defines indexed containers
and the coinductive-record M-type, and it **does** prove the final-coalgebra
universal property:

- `unfold : ∀ {A} (α : ∀ x → A x → F A x) → ∀ x → A x → M C x`  — existence;
- `unfold-η : ∀ {A} (α) (h) → (h is a coalgebra morphism) → ∀ x a → h x a ≡ unfold α x a`  — uniqueness.

And our functor **is** expressible: take `X := Unit* {ℓ}`,
`C := (λ _ → O) , (λ _ _ _ → A) : IxCont X`. Then
`⟦ C ⟧ Z tt = Σ[ o ∈ O ] (Unit* → A → Z tt) ≅ O × (A → Z tt)`. Exactly the Moore
functor. So on paper this is our theorem.

Three concrete blockers, in increasing order of severity:

1. **Universe rigidity (annoying).** `IxCont {ℓ} X = Σ (X → Type ℓ) λ S → ∀ x → S x → X → Type ℓ`
   forces `X`, `O` and `A` into a *single* level `ℓ`. Our module is polymorphic
   in three independent levels `ℓX ℓA ℓO`. Fixable with `Lift`, at the cost of
   `lower`/`lift` noise in every downstream statement.

2. **No h-level (fatal).** `M C x` is a coinductive record. The library proves
   **nothing** about its h-level — I grepped all of `Cubical/Codata/` for
   `isSet`, `isProp`, `isContr`: zero hits outside `M/Bisimilarity.agda`. Our
   entire development is set-level: `Meaning = X / ≈` needs `squash/`, and
   *every* map out of it goes through `SQ.rec (isSet target)`. To route
   `quotBehavior` through `M C tt` we would need `isSet (M C tt)`, which does
   not exist in the library and would have to be proved by us — from
   bisimilarity, which brings us to blocker 3.

3. **The bisimilarity module is not `--safe` (fatal).**
   `Cubical.Codata.M.Bisimilarity` proves exactly the theorem that would rescue
   blocker 2 — `bisimEquiv : isEquiv (misib a b)`, i.e. `(a ≡ b) ≃ (a ≈ b)`,
   the cubical form of "bisimilarity coincides with path equality on the final
   coalgebra." But its header is `{-# OPTIONS --postfix-projections --guardedness #-}`
   — **no `--safe`** — and it contains two `{-# TERMINATING #-}` pragmas
   (`contr-T-snd`, `contr-T-φ-snd`). Our library config
   `formal/cubical/natural-machine.agda-lib` sets
   `flags: --cubical --guardedness --safe --no-import-sorts`. **`--safe` cannot
   import a non-`--safe` module.** The library's own `Cubical.Codata.Everything`
   annotates it "Also uses `{-# TERMINATING #-}`" and
   `Cubical.Codata.EverythingSafe` is *empty*. It is additionally restricted to
   `X : Type₀`, so even without `--safe` it would not apply at our levels.

   Importing it would require deleting `--safe` from a repository whose entire
   epistemic claim (CLAUDE.md: "a checked term is the object itself") rests on
   that flag. **That trade is not available.**

### 4.2 `Cubical.Codata.M.AsLimit.*` — no finality theorem at all

The Ahrens–Capriotti–Spadotti limit construction (arXiv:1504.02949) is present
and *is* `--safe --guardedness`. `Coalg/Base.agda` defines `Coalg₀` (a
coalgebra) and `Cone₀`/`Cone₁`. `M/Base.agda` proves `shift-iso : Iso (P₀ S (M S)) (M S)`
and `M/Properties.agda` proves `in-fun`/`out-fun` are mutually inverse — i.e.
**Lambek's lemma**, that the structure map of the final coalgebra is an
isomorphism.

But grep for `final`, `Final`, `unique`, `isContr` across the whole `AsLimit`
tree returns **zero hits**. The universal property — that every coalgebra maps
uniquely into `M S` — is *not proved there*. It is the one thing we would want
and the one thing missing. (`itree.agda` and `stream.agda` are worked examples,
not theorems about finality.) Additionally `Container.agda` uses the deprecated
`Cubical.Data.Prod._×_`, which does not interoperate cleanly with the
`Cubical.Data.Sigma._×_` our module imports.

### 4.3 What the library *does* supply and we should be using

- `Cubical.HITs.SetQuotients.Properties.effective` / `.isEquivRel→effectiveIso` —
  **already imported and used** (lines 287, 293). Correct.
- `Cubical.Functions.Image` (`--safe`, universe-polymorphic) — provides
  `Image f`, `imageInclusion : Image ↪ B`, `restrictToImage`,
  `isSurjectionImageRestriction`, `imageFactorization`. This is the
  surjection/embedding factorization system that `quotBehavior-injective` and
  `crystal-minimal` are hand-rolling. **We do not import it. We should.**
- **A gap in the library, worth filling:** there is no set-level first
  isomorphism theorem. Grepping for `kernel` across all of `Cubical/` returns
  only algebra-specific instances (`Ring/Kernel`, `CommRing/Kernel`, …). The
  general statement

  ```agda
  setQuotKernelIso : {A : Type ℓ} {B : Type ℓ'} (f : A → B) → isSet B
                   → Iso (A / (λ x y → f x ≡ f y)) (Image f)
  ```

  is about ten lines from `SQ.elimProp2`, `effective`, and
  `isSurjectionImageRestriction`. It is exactly what our §5b+§5c prove for one
  particular `f`. Extracting it is a genuine, reusable contribution and would
  make `quotBehavior-injective` a corollary.

**Library verdict: no, the local library could not have supplied our theorems.**
It has the universal property in one module that is unusable under `--safe`, and
the safe module that could carry it stops at Lambek's lemma. Our bespoke version
is *justified as a construction*; it is not justified as an *un-cited,
un-factored* construction.

---

## 5. Plan (a): re-land as an instantiation of a *local* finality theorem

**Do not rewrite the module in terms of M-types.** Do the following instead.
Estimated net effect: +25 lines of new theorem, −20 lines of duplicated
induction, and the corpus's central construction acquires a universal property
and a citation.

### Step 1 — name the final coalgebra (new, ~15 lines, no new imports)

```agda
module Final {ℓA ℓO} {A : Type ℓA} {O : Type ℓO} where

  -- carrier of the final O × (−)^A-coalgebra
  Beh : Type (ℓ-max ℓA ℓO)
  Beh = List A → O

  behObserve : Beh → O
  behObserve β = β []

  behStep : Beh → A → Beh
  behStep β a w = β (a ∷ w)

  -- existence: `behavior` IS the anamorphism
  ana : {X : Type ℓX} (step : X → A → X) (observe : X → O) → X → Beh
  ana = behavior

  ana-observe : ∀ step observe x → behObserve (ana step observe x) ≡ observe x
  ana-observe _ _ _ = refl

  ana-step : ∀ step observe x a
           → ana step observe (step x a) ≡ behStep (ana step observe x) a
  ana-step _ _ _ _ = refl

  -- uniqueness: the ONE induction on List A, written once
  ana-unique : ∀ step observe (h : X → Beh)
             → (∀ x → behObserve (h x) ≡ observe x)
             → (∀ x a → h (step x a) ≡ behStep (h x) a)
             → ∀ x → h x ≡ ana step observe x
```

`ana-unique` is `funExt` plus induction on the word: `[]` case is the first
hypothesis, `a ∷ w` case rewrites by the second and recurses. Six lines.

Optionally add Lambek: `⟨behObserve , behStep⟩ : Beh ≅ O × (A → Beh)`, which is
the `List A ≅ Unit ⊎ (A × List A)` iso transported. Two lines, and it makes the
"final coalgebra" claim self-evident to a reader.

### Step 2 — derive, do not re-prove

- `congruence→futureEq` becomes a corollary: given `isBehavioralCongruence S`,
  the projection `X → X/S` is a coalgebra morphism (that is `Terminal.stepQ` /
  `.observeQ`, already there), so `ana` of `X/S` composed with `[_]` satisfies
  the two hypotheses of `ana-unique`, hence equals `ana` of `X`; therefore
  `S x y → [x] ≡ [y] → behavior x ≡ behavior y → FutureEq x y`. The current
  direct induction (lines 213–216) can stay as a fast path, but should be
  *labelled* as the inlined finality induction.
- `quotient-preserves-behavior` becomes the same corollary applied to
  `S = FutureEq`.
- `quotBehavior-injective` becomes `setQuotKernelIso` (§4.3) at `f = behavior`.

### Step 3 — import `Cubical.Functions.Image`

Replace the ad-hoc `crystal-minimal` with the standard factorization:
`Meaning ≅ Image (behavior step observe)`, `imageInclusion` giving the
embedding into `Beh`. This is *the* image factorization the standard theory
names, stated as such.

### Step 4 — header rewrite

The current header (lines 3–68) says "the corpus's one central construction
(Myhill–Nerode / sufficient statistic / observability)". It should say what it
is: *the minimal realization theorem for coalgebras of the Moore functor
$O \times (-)^A$; the quotient is the image of the unique map into the final
coalgebra $O^{A^*}$; see Rutten, TCS 249 (2000) and Rutten, CONCUR '98.* And it
should record the negative library result of §4 so nobody re-audits it.

### Step 5 — mirror the Lean lane's discipline

`Pairfield/MyhillNerodeAdapter.lean` already bridges to
`Mathlib.Computability.MyhillNerode`. The Agda lane has no such library to
bridge to (§4), so the adapter it owes is the *citation and the universal
property*, which is Steps 1–4.

**Do not do:** any instantiation of `Cubical.Codata.M`, `Cubical.Codata.M.AsLimit`,
or `Cubical.Codata.M.Bisimilarity`. §4 is the record of why, so that this
audit is not repeated.

---

## 6. The redirection: the value is in the instantiations, and we have none

If the theory is standard — and it is — then the corpus's contribution has to be
the *instances*: the places where a specific arithmetic, digital, or
matrix-theoretic system is exhibited as an observed machine and its
future-behavior quotient computed to a closed form. Those are the statements a
coalgebraist does not have.

Candidates named in `MATHEMATICS_THAT_LEARNS.md`:

- **binary divisibility:** digits act on remainders by $r \mapsto 2r + d$,
  observation is divisibility, and the minimal machine has exactly $q + a$
  states for $m = 2^{a}q$ with $q$ odd. *That* is a theorem about a specific
  final-coalgebra image and it is not in Rutten. (Note the note's own honesty
  ledger: the formula was found by `law_discovery.py` and licensed by the
  elementary argument in `BINARY_DIVISIBILITY_CRYSTAL.md`, not by the fit.)
- **general base $b$, modulus $m$:** an explicit finite horizon after which no
  digit word makes a new distinction.
- **binary linear systems:** the quotient is the coset space of the unobservable
  subspace, $2^{r}$ classes for observability rank $r$ — Kalman's theorem,
  correctly attributed in the Doors section.
- **substring recognition:** states are longest viable suffixes — the classical
  KMP/Aho–Corasick Nerode quotient.
- **Smith / resultant defect** (`SmithCapability.agda`, `AtlasResiduals.agda`,
  `notes/SMITH_DEFECT_FILTER.md`): the one place where the "machine" carries
  torsion data a Moore automaton does not.

**But the audit finding is blunt: `FutureQuotient` and `MachineFutureBehavior`
are used by nothing in `formal/cubical/`.** The only file naming them outside
`FutureBehavior.agda` is `NaturalMachine.agda`, which merely `import`s the
module. `CountedDigits.agda`, `DigitTowerFin*.agda`, `SmithCapability.agda`,
`FiniteInformation.agda` do not instantiate it. So the corpus currently has:

- a general theory that is 60 years old and re-proved, and
- instantiations that are separately formalized and never connected to it.

That is precisely the reverse of what would be valuable. The queue item this
note generates is therefore **`DEMONSTRATE`**, not `PROVE`:

> Instantiate `MachineFutureBehavior` at the binary-divisibility machine
> ($X = \mathrm{Fin}\,m$, $A = \mathrm{Fin}\,2$, $O = \mathrm{Bool}$,
> $\text{step}\,r\,d = 2r+d \bmod m$, $\text{observe}\,r = (r \equiv 0)$) and
> prove `Meaning ≅ Fin (q + a)`. That single instance is worth more than the
> general theory, because it is the statement the general theory cannot make.

---

## 7. Sources

All Ś2: search-snippet testimony only. WebFetch is EGRESS_BLOCKED in this
environment, including ncatlab.org, so **no primary text was read this session
and no theorem number in any of these is verified.** Anyone re-landing §5 should
fetch Rutten TCS 249 (open access at the Cornell CS6861 handout mirror below)
and pin the section numbers.

- J.J.M.M. Rutten, *Universal coalgebra: a theory of systems*, Theoretical
  Computer Science 249(1):3–80, 2000. [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0304397500000566) · [Cornell CS6861 handout mirror](https://www.cs.cornell.edu/courses/cs6861/2024sp/Handouts/Rutten.pdf)
- J.J.M.M. Rutten, *Automata and coinduction (an exercise in coalgebra)*,
  CWI SEN-R9803 / CONCUR '98, LNCS 1466, 194–218. [CWI](https://ir.cwi.nl/pub/2114) · [Springer](https://link.springer.com/chapter/10.1007/BFb0055624)
- J.J.M.M. Rutten, *The Method of Coalgebra: exercises in coinduction*, CWI,
  Feb. 2019. [CWI PDF](https://ir.cwi.nl/pub/28550/rutten.pdf)
- B. Jacobs, *Introduction to Coalgebra: Towards Mathematics of States and
  Observation*, Cambridge Tracts in TCS 59, 2016. Chapters on deterministic
  automata, final coalgebras, and relation lifting / bisimulations and
  congruences. [Author PDF](https://www.cs.ru.nl/B.Jacobs/CLG/JacobsCoalgebraIntro.pdf)
- H.P. Gumm, *Elements of the General Theory of Coalgebras*, LUATCS'99;
  see also *State based systems are coalgebras* and *Universal coalgebras and
  their logics*. [Marburg](https://www.mathematik.uni-marburg.de/~gumm/Papers/Cubo.pdf) · [logics](https://www.mathematik.uni-marburg.de/~gumm/Papers/UniversalCoalgebrasAndTheirLogics.pdf)
- G. Malcolm (attribution Ś3), *Behavioural Equivalence, Bisimulation, and
  Minimal Realisation*, LNCS 1130, 1996. [Springer](https://link.springer.com/chapter/10.1007/3-540-61629-2_53) · [Semantic Scholar](https://www.semanticscholar.org/paper/Behavioural-Equivalence,-Bisimulation,-and-Minimal-Malcolm/0ec08c2edbe2281f90d554d750aac4f8a382e532)
- D. Kozen, *Automata and Computability*, Lecture 15, "Myhill–Nerode Relations".
  [Cornell](https://www.cs.cornell.edu/courses/cs682/2008sp/Handouts/MN.pdf)
- Weak-pullback preservation ⇒ bisimilarity = behavioural equivalence; failure
  for $\mathcal{P}\mathcal{P}$: see the survey material in
  [LMCS 5(2:2) 2009](https://arxiv.org/pdf/0901.4430) and
  [Simulations and Bisimulations for Coalgebraic Modal Logics](https://arxiv.org/pdf/1303.2467).
- B. Ahrens, P. Capriotti, R. Spadotti, *Non-wellfounded trees in Homotopy Type
  Theory*, [arXiv:1504.02949](https://arxiv.org/pdf/1504.02949) — the
  construction behind `Cubical.Codata.M.AsLimit`.

Ś1 (read directly, this session, from `~/agda-libs/cubical/`):
`Cubical/Codata/M.agda`, `Cubical/Codata/M/Bisimilarity.agda`,
`Cubical/Codata/M/AsLimit/{Container,Coalg/Base,M/Base,M/Properties}.agda`,
`Cubical/Codata/Everything.agda`, `Cubical/Codata/EverythingSafe.agda`,
`Cubical/HITs/SetQuotients/Properties.agda`, `Cubical/Functions/Image.agda`.

Prior art inside the corpus, found at audit and not before (the failure mode
CLAUDE.md names — "prior art gets searched **before** the experiment"):
`collab/messages/madhavi/0003-simplest-mathematical-center.md` (states the final
coalgebra answer and cites Rutten 2000),
`collab/messages/vajra/full_history_foundations.md` §"least future-sufficient
distinction" (the same correspondence table, in prose),
`notes/COGNITIVE_ORIENTATION.md` §4.
