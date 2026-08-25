# Standpoints Compute

### Jaina, Bauddha and Naiyāyika logic in cubical type theory

**नयवाद · स्याद्वाद · चतुष्कोटि · व्याप्ति**

*Draft, 2026-08-25.*

> **TERM.** नय / प्रमाण · *naya* / *pramāṇa* — the partial standpoint against the
> whole knowing. Umāsvāti's *Tattvārthasūtra* gives the naya list; the recensions
> disagree on its numbering (Śvetāmbara 1.34 against Digambara 1.33), so this paper
> gives the words and not the number, for reasons §8 turns into a measurement.
> Siddhasena Divākara's *Sanmatitarka* reduces the nayas to two roots. No first use
> is established here and **no theorem below is any Jaina's.**
>
> Every formal claim is a machine-checked Agda term; the module and identifier are
> given in §12 so any claim can be located and re-run. Where a school's vocabulary
> is used the school is named first, and where two schools disagree the dispute is
> stated and not resolved.

---

## Abstract

Indian logicians developed, over roughly two millennia, a technical vocabulary for
the fact that a determination is always made *from* somewhere: the Jaina doctrines
of *nayavāda* and *saptabhaṅgī*, the Madhyamaka *catuṣkoṭi*, and the Naiyāyika
apparatus of *vyāpti* and its defeat by an *upādhi*. Modern formalisations have
rendered these as many-valued, modal, or paraconsistent logics. We argue those
renderings are lossy in ways that can now be exhibited rather than debated, and that
the loss has a single cause: **propositional logic is the wrong arity.** The
apparatus is about dependency, and a formalism without dependent types must smuggle
the dependency into the value space, where it does not fit.

In cubical type theory — where equalities are paths, every type carries an h-level
measuring how much it forgets, families depend on indices, and univalence computes —
these doctrines are not approximated. They are stated, and their consequences are
checked. We work inside an existing 296-line metacircular rewrite kernel in which a
certified derivation and an executable operation are the same object.

### Results

1. **A model is a naya.** A semantics is a functor out of the syntactic category,
   and it does two things Tarski's definition tracks only one of: it *fills* what the
   axioms leave undetermined, and it *forgets* by its h-level. A second model of the
   kernel's two axioms — neither commutative nor left-unital, both axioms holding
   definitionally — yields two independence results invisible from ℕ, and settles a
   question the kernel had left open about its own dormant induction apparatus:
   **the induction rule is strictly stronger than the rewrite closure**, so the
   kernel certifies theorems it cannot install.

2. **Syāt is a theorem-level discipline, not a hedge.** The corpus's headline no-go,
   abstracted over its codomain, consumes exactly one hypothesis: that the codomain
   is a set. The unqualified scope sentence is what the tradition calls a *durnaya*.

3. **Nothing unqualified survives, in either direction.** For a suitable pair of
   terms both the absolute assertion and the absolute denial are refuted. The
   qualifier is not a weakening of an available absolute claim; there is no absolute
   claim to weaken.

4. **The two traditions' fourth positions sit at different levels.** The Madhyamaka
   fourth corner under *prasajya* negation is refutable for every proposition
   whatsoever, depending on nothing — a fact about negation. The Jaina configuration
   is contingent, consistent, and about a family whose fibres disagree — a fact about
   dependency.

5. **Cost fails inversion, not truncation.** Raising the h-level does not rescue the
   blindness: any measure respecting the groupoid structure sends a round trip to the
   identity while step-count sends it to double.

A sixth result is methodological and we would defend it hardest. *Durnaya* names a
failure mode of formalisation in general, and its detection is mechanical. We also
identify the mechanism by which the standard readings were produced, measure it
inside our own repository, and record two occasions on which it caught the present
author.

---

## 1. Four losses

The standard presentation of *syādvāda* is as a seven-valued logic. The seven
*bhaṅgas* become seven truth values, the fourth — *avaktavya* — a third value beside
true and false, and the doctrine a species of many-valuedness. Priest and Ganeri have
each argued the saptabhaṅgī supports a non-classical system; Balcerowicz has
contested that it is a logic in that sense at all. Four things are lost, and each can
be named precisely.

**The qualifier is read as a hedge.** स्यात् · *syāt* is the optative of √अस् used as
an indeclinable, and the Jaina logicians insist that each qualified predication is
*niścaya* — determinate. It does not mean "maybe". A reading that turns *syād-asti*
into a partial or intermediate truth value has converted a determinate assertion
under a stated condition into an indeterminate assertion without one. That is not an
approximation of the doctrine; it is its inverse.

**The index is erased.** Both *asti* and *nāsti* are determined under *upādhi*s —
traditionally *sva-dravya, sva-kṣetra, sva-kāla, sva-bhāva* and their *para-*
counterparts. An assertion is therefore not a proposition carrying a value; it is a
**section of a family indexed by respects**. Erase the index and the only way to
record that both hold is to invent a value that is somehow both. §7 exhibits a pair
for which the qualified forms are fine and *both* unqualified forms are refuted. No
value space holds that configuration, because the configuration is not about values.

**The fourth bhaṅga is given a truth value.** It arises specifically from युगपत् ·
*yugapat*, simultaneous assertion, as against *krama*, successive — which yields the
third. Simultaneity is not a value; it is a dimension. A logic with no notion of
dimension has nowhere to put it and must fake one.

**Two traditions that explicitly rejected each other's readings are merged.** Schang
treats the saptabhaṅgī and the catuṣkoṭi within one framework. §7.3 shows the two
fourth positions are not two settings of one dial: one is a statement about
dependency, the other about negation, and they have different logical forms.

Underneath all four sits a shared premise. The debate asks whether the saptabhaṅgī
*is a logic* — and Priest's yes and Balcerowicz's no agree on the question. It is an
Aristotelian question. The tradition's own question is which standpoint a
determination is made from, and that is answerable only in a formalism where
standpoints are objects.

---

## 2. The substrate

We work inside an existing artefact, written for other purposes: a metacircular
rewrite kernel in three files, 156 + 63 + 77 = **296 lines**.

```agda
data Tm : Type₀ where
  var yvar zvar uvar vvar wvar : Tm
  zero : Tm
  suc  : Tm → Tm
  add  : Tm → Tm → Tm

data Step : Tm → Tm → Type₀ where
  add-zero  : (x : Tm) → Step (add x zero) x
  add-suc   : (x y : Tm) → Step (add x (suc y)) (suc (add x y))
  suc-step  : {x y : Tm} → Step x y → Step (suc x) (suc y)
  add-left  : {x y : Tm} → Step x y → (z : Tm) → Step (add x z) (add y z)
  add-right : (z : Tm) → {x y : Tm} → Step x y → Step (add z x) (add z y)
  reverse   : {x y : Tm} → Step x y → Step y x

data Derivation : Tm → Tm → Type₀ where
  done      : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z
```

Read the constructors as inference rules and the object resolves completely. `done`
is reflexivity, `then-step` transitivity, `reverse` symmetry, the three congruence
rules congruence, and `add-zero`, `add-suc` are **the two axioms**. Symmetry lifts
from steps to whole chains. So `Derivation a b` is exactly a proof in equational logic
over the theory `{x + 0 = x, x + suc y = suc (x + y)}`.

There is one interpretation: `eval : Tm → Env → ℕ`, with `Env` holding six independent
natural-number coordinates, and `derivation-sound` carrying every derivation to a path
in ℕ at every environment. The source keeps the six coordinates distinct and says why
in a comment — *"identifying them would prove only equality on the diagonal"* — a
rationale nobody had proved. §5 proves it.

Two structural facts are already established in the kernel's corpus and we use them
without reproving. It is **strictly a category and weakly a groupoid**: concatenation
is associative and unital on the nose, while `reverse (reverse p)` is a different
constructor application from `p`. And its soundness lands in an identity type of ℕ,
hence in a proposition, so any two derivations with the same endpoints have literally
equal soundness proofs.

Finally, the kernel carries a dormant induction apparatus — `HypStep`,
`HypDerivation`, `InductionCertificate`, `induction-sound` — imported by nothing.
Whether it was redundant was, before §3.3, undecided.

---

## 3. A model is a naya

### 3.1 What a model does

Since `Tm` with `Derivation` is a category, a model is not a set with operations; it
is a **functor out of the syntax**. `eval` with `derivation-sound` is exactly that:
terms to functions, derivations to paths, `then-step` to composition, `reverse` to
`sym`.

Such a functor does two things, and Tarski's definition tracks only the first. **It
fills where the theory is silent** — the two axioms constrain `add a b` only where `b`
is literally `zero` or `suc _`; at an opaque `b` they say nothing, and ℕ fills that
silence with commutativity. **And it forgets, by its h-level** — ℕ is a set, so all
parallel derivations are identified.

> **A model is a pair: what it adds where the theory is silent, and what it forgets by
> where it lands.**

This is Umāsvāti's अर्पितानर्पितसिद्धेः · *arpitānarpitasiddheḥ* — established through
the emphasised and the unemphasised aspect — read as a definition rather than a
slogan. Recension numbering differs (Śvetāmbara 5.31 against the Digambara sequence),
so we give the words. A standpoint has not been specified until both sides are named.

### 3.2 A second standpoint

Here is a model of the same two axioms in which addition is neither commutative nor
left-unital. Both axioms hold **by `refl`**, which is the check that it models the
same theory rather than a different one dressed up.

```agda
data Atom : Type₀ where
  aX aY aZ aU aV aW aS aM : Atom

p : W → W → W                       -- right-unital, successor-compatible
p a []       = a
p a (aS ∷ b) = aS ∷ p a b
p a (c ∷ b)  = a ++ (aM ∷ c ∷ b)    -- a marker between the two sides

⟦_⟧ : Tm → W
⟦ zero ⟧    = []
⟦ suc t ⟧   = aS ∷ ⟦ t ⟧
⟦ add l r ⟧ = p ⟦ l ⟧ ⟦ r ⟧
⟦ var ⟧     = aX ∷ []               -- and the other five coordinates

step-model : {a b : Tm} → Step a b → ⟦ a ⟧ ≡ ⟦ b ⟧
step-model (add-zero x)  = refl
step-model (add-suc x y) = refl
```

```agda
not-commutative : Derivation (add var yvar) (add yvar var) → ⊥
not-left-unital : Derivation (add zero var) var → ⊥
```

Both statements are **true in ℕ at every environment**. No argument from ℕ can reach
them. The second standpoint is three lines of definition and decides both.

What this licenses is not that ℕ is wrong. It is that **ℕ is opinionated**: it
bestows a symmetry the theory does not have. Which sharpens rather than weakens the
thesis that structure is generated by counting and by relations arising between
numbers. ℕ *is* the initial algebra of `X ↦ 1 + X`; counting genuinely is the free
thing. But once `+` appears and one asks about an opaque argument, ℕ stops being free
and starts being a choice. Not everything ℕ knows, ℕ counted — and this is the
instrument that separates the two.

### 3.3 The induction rule is strictly stronger

The kernel's own dormant apparatus certifies `0 + x = x`:

```agda
leftZero-cert : InductionCertificate (add zero var) var
InductionCertificate.base leftZero-cert = then-step (add-zero zero) (done zero)
InductionCertificate.step leftZero-cert =
  hyp-then (lift-step (add-suc zero var))
    (hyp-then (hyp-suc hypothesis) (hyp-done (suc var)))

induction-is-strictly-stronger :
  ((ρ : Env) → eval (add zero var) ρ ≡ eval var ρ)
  × (Derivation (add zero var) var → ⊥)
```

The apparatus is not redundant. And because the kernel's operation record demands a
`Derivation` as its certificate, **this theorem cannot enter the library**: the kernel
certifies more than it can learn. Its learning is closed under composition of rewrites
and not under induction.

### 3.4 A second naya was already there

The corpus containing this kernel already held a universe-valued semantics of the same
calculus — `⟦_⟧ : Tm → TEnv → Type₀`, with `zero ↦ ⊥`, `suc ↦ Unit ⊎ −`, `add ↦ ⊎` —
in which every `Step` constructor becomes an *equivalence* and `reverse` becomes
`invEquiv`. It proves that the counting semantics cannot see a commutation loop that
the univalent semantics does see, that the corresponding path in the universe is not
`refl` (via the univalence β-rule computing), and it already names the diagnosis:
**नय-निरोधः**.

> **STRUCK, AND LEFT STANDING.**
> ~~"Every model in this corpus is ℕ; every soundness theorem in the kernel is stated
> against ℕ alone."~~ Written into a module header by the present author and false
> when written. The command that would have found the universe-valued model —
> `grep -rlE ': *Tm *→' formal/cubical`, which returns twenty files — had not been
> run. Discussed as evidence in §9.

What survives is sharper than what was struck, and it is a genuine instance of the
doctrine rather than a consolation. The universe-valued model **validates**
commutativity (`add ↦ ⊎`, `⊎-swap-≃`) and separates it from the identity. The
list-valued model **refutes** it. Non-triviality and underivability are different
theorems and neither implies the other. Together they bracket a fact neither states
alone:

> **Commutativity of `add` is not derivable, and once added, it is not trivial.**

Two standpoints, reached independently, from different sources — one from the
*aṅkapāśa*, the combinatorics of arrangements, one from the term model — neither
reducible to the other, and the object determined by both.

---

## 4. Syāt is a theorem-level discipline

The corpus's headline no-go states that no semantic criterion — *"none, at any
h-level, of any complexity"* — selects a short derivation over a long one. Abstract
that proof over its codomain and it consumes exactly one hypothesis:

```agda
blindness-is-a-property-of-the-codomain :
  {X : Type ℓ} → isSet X
  → (⟦_⟧ : Tm → Env → X)
  → (sound : {a b : Tm} → Derivation a b → (ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ)
  → (φ : ((ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ) → C)
  → (d e : Derivation a b) → φ (sound d) ≡ φ (sound e)
```

Not ℕ. Not `eval`. Not one fact about this kernel. **`isSet X`.** The theorem is true
and the scope sentence is a durnaya; the clause that does not survive is precisely "at
any h-level", because the h-level of the *criterion* is indeed unrestricted while the
h-level of the *codomain* does all the work and was fixed at 0 by the choice of ℕ. The
qualified form: *syāt* — from a 0-truncated standpoint, no criterion selects.

This is what it means to call *syāt* a theorem-level discipline rather than a hedge.
The qualifier is not epistemic caution. It is the missing hypothesis, and supplying it
converts a slogan into a statement with a converse worth asking about.

### 4.1 The obvious repair fails, for a different reason

If truncation is the obstruction, raise it. That fails, and not because of h-level:

```agda
rev-len    : len (rev d) ≡ len d
round-trip : len (d ⊕ rev d) ≡ len d + len d
```

Any measure respecting the groupoid structure must send `rev d` to the inverse of `d`,
hence a round trip to the identity. Step-count sends it to **double**. Cost is a
functor on the *category* and not on the *groupoid*: the obstruction is **inversion**,
not truncation. The corpus's own formula — strictly a category, weakly a groupoid, and
the gap between them is the *śeṣa* — is thereby given a measure, and the measure is
`len d + len d`.

### 4.2 A retraction that strengthens the result

> **STRUCK, AND LEFT STANDING.**
> ~~"Whether a non-set codomain separates the kernel's two exhibited histories is
> open."~~ Not open, and not available. No such model exists, at any h-level — for a
> reason the same file's next section already contained.

```agda
module _ {X : Type ℓ} (P : Tm → X)
         (st  : {a b : Tm} → Step a b → P a ≡ P b)
         (st-rev : (p : Step a b) → st (reverse p) ≡ sym (st p)) where
  no-semantics-separates-them : D detour-history ≡ D direct-history
```

The corpus's two witness derivations differ by `s ; reverse s`. Every semantics sends
`reverse` to `sym` — that is what makes it a semantics — so the round trip is the
identity in *any* groupoid whatsoever. The proof is associativity, right cancellation
and the left unit law, and mentions no h-level.

So §4 is right about the general case and wrong about the corpus's own witnesses.
Truncation is what identifies parallel derivations in general; it is not what
identifies *those two*. Those two are identified by inversion. Their exhibited
proof-relevance — step counts 2 against 4 — is visible to no functorial semantics at
any level, and the pair was chosen to differ by exactly the thing no semantics can
see. This interlocks with §3.4 rather than conflicting with it: the universe-valued
model *is* functorial in this sense, and it had to **add a new constructor** to obtain
a separable pair, which is what §4.2 predicts.

The two forgettings are therefore distinct and ordered. **Truncation** hides *which*
parallel derivation was taken. **Inversion** hides *that one went out and came back at
all* — and no amount of dimension recovers it, because functoriality itself is the
obstruction. Step-count sees the second and nothing else does. The arrow of time is
not below the h-level; it is orthogonal to it, and it is recovered exactly by refusing
to invert the measure.

---

## 5. Vyabhicāra, and a collision of names

*The school in this section is Nyāya, and it is named before its vocabulary is used.*

A *hetu* found where the *sādhya* is absent is सव्यभिचार, and Gautama's *Nyāyasūtra*
defines it in three words — **सव्यभिचारोऽनैकान्तिकः**, *savyabhicāro 'naikāntikaḥ*. We
give the words rather than the number, for reasons §8 makes into a measurement. The
definitional apparatus for *vyāpti* and its defeat by an *upādhi* is much later, with
Gaṅgeśa's *Tattvacintāmaṇi* (~1325), and none of it is claimed for anything below.

```agda
vyabhicara : {a b : Tm} (ρ : Env)
           → (eval a ρ ≡ eval b ρ → ⊥) → Derivation a b → ⊥
vyabhicara ρ ne d = ne (derivation-sound d ρ)
```

Deviation at **one** environment forbids the derivation at **every** environment. This
is why the kernel's soundness quantifies over all `ρ` rather than holding at one: move
the quantifier inside and the library would accept operations false off a single
point. It yields the first uninhabited `Derivation` in the corpus, and with it the
source comment of §2 becomes a theorem — `var` is derivably identified with none of the
other five coordinates, and `yvar` with `zvar`, so the fact is not about `var`.

And now the collision, which is why this section is worth having. Gautama's name for
the *fault* is अनैकान्तिक · *anaikāntika* — literally not-one-endedness. The Jainas'
name for their central *doctrine* is अनेकान्त · *anekānta*, the same root, and they
mean it as the structure of the real. The same configuration — a claim holding under
one *upādhi* and failing under another — is for the Naiyāyika a defect that destroys
the inference and for the Jaina the first two bhaṅgas, both determinate, both
retained. The Jaina logicians answered the charge that anekānta is merely anaikāntika
at length and for centuries; Akalaṅka and Vidyānanda are where that argument lives.

We state which reading each theorem is and adjudicate nothing. Merging the two
vocabularies into one technical register — taking from each the part that converts and
discarding the dispute — would lose the content, and that is the same operation §1
identifies in the many-valued readings.

---

## 6. Ananta, on the tradition's own criterion

*The school in this section is Jaina.*

The Jaina counting apparatus distinguishes three orders — संख्यात / असंख्यात / अनन्त,
*saṃkhyāta, asaṃkhyāta, ananta* — each further subdivided, in the *Anuyogadvārasūtra*
(date contested, commonly ~2nd–5th c. CE; we pin none), the *Sthānāṅgasūtra* and the
*Bhagavatīsūtra*, with technical development through Yativṛṣabha's *Tiloyapaṇṇatti*
and Nemicandra. The distinctive move is the middle order: *asaṃkhyāta* is innumerable
but **definite** — the scheme bounds it above and does arithmetic on it — while
*ananta* exceeds every such bound.

That is a criterion, and it can be applied rather than translated.

```agda
inflate : (k : ℕ) {a b : Tm} → Derivation a b → Derivation a b
inflate zero        d = d
inflate (suc k) {a} d =
  then-step (reverse (add-zero a)) (then-step (add-zero a) (inflate k d))

inflate-len : (k : ℕ) (d : Derivation a b) → len (inflate k d) ≡ (k + k) + len d
inflate-inj : (d : Derivation a b) (k k' : ℕ) → inflate k d ≡ inflate k' d → k ≡ k'
```

`reverse (add-zero a) : Step a (add a zero)` fires at **every** term with no hypothesis
on `a`, so the padding is uniform and needs no fact about the endpoints beyond one
derivation existing between them. The index is recoverable, so **ℕ injects into
`Derivation a b` whenever that type is inhabited at all** — lengths past every bound,
hence not *asaṃkhyāta* by the scheme's own test. And the whole family collapses to one
bit downstairs, forced.

What is deliberately *not* claimed: any identification with a cardinal. The Jaina
orders are magnitudes inside a cosmology with their own arithmetic; they are not
cardinalities, and a reading that makes the tradition legible only after conversion
into someone else's formalism has done the damage it was trying to avoid. Nor is a
three-order match claimed — ***asaṃkhyāta* has no counterpart here**, and presenting
two orders as three would be exactly the mining this method is against.

What the kernel does hold apart by type is the pair the tradition insists on: the
*offering* is a `List`, so its count is a ℕ given by `length`, and the kernel's one
conservation law preserves it exactly; the *object* is unbounded. The machine never
lets the finite offering stand for the infinite object.

---

## 7. Nirapekṣa: the fourth positions

*Two schools appear here. §7.1 is Jaina, §7.2 is Bauddha, and §7.3 is a claim about
the two formalisations, not about what either tradition really means.*

### 7.1 Jaina: nothing unqualified survives

An assertion made with no *upādhi* is निरपेक्ष · *nirapekṣa*, against सापेक्ष ·
*sāpekṣa*, made with one; and a naya asserted *nirapekṣa* becomes a *durnaya*
(Siddhasena Divākara, *Sanmatitarka*; developed by Akalaṅka).

```agda
asti  : eval var  diagonal     ≡ eval yvar  diagonal        -- refl
nasti : ¬ (eval var off-diagonal ≡ eval yvar off-diagonal)  -- znots

no-unqualified-assertion : ¬ ((ρ : Env) → P ρ)
no-unqualified-denial    : ¬ ((ρ : Env) → ¬ P ρ)
```

Both absolute forms are refuted. The qualifier is therefore not a weakening of an
assertion one could otherwise make; **there is nothing to weaken**. And this is not a
contradiction: it is the ordinary condition of a family over `Env` whose fibres
disagree. It is contingent on the pair, and false for pairs the calculus derives.

We are careful about which position this is. This corpus's own ledger records three
separate corrections landing on the word *avaktavya*, one because a line named for it
in fact sat at the third bhaṅga. So, plainly: §7.1 exhibits bhaṅgas **one and two**,
and the *krama* reading of the **third**. It does **not** exhibit the fourth.

### 7.2 Bauddha: the fourth corner, refuted for every A

The चतुष्कोटि · *catuṣkoṭi* is standard in Nāgārjuna's *Mūlamadhyamakakārikā*. Read
the fourth corner's negation as प्रसज्यप्रतिषेध · *prasajya-pratiṣedha*, the
non-implicative negation, which asserts nothing positive — `A → ⊥`. The distinction
from पर्युदास · *paryudāsa* is drawn by Westerhoff, and we mark it as a reading.

```agda
no-fourth-corner : {A : Type ℓ} → ¬ (¬ (A ⊎ (¬ A)))
no-fourth-corner k = k (inr (λ a → k (inl a)))
```

For **every** `A`, at every level, depending on nothing. The fourth corner cannot be
occupied — only used as a *prasaṅga*, which is what the prasaṅgika reading says
Nāgārjuna does. Under *paryudāsa* the fourth corner is a different formula and this
theorem does not apply; and Priest and Garfield, reading paraconsistently, would not
accept the refutation at all. We name the dispute and do not enter it: the theorem is
constructive and they are not.

### 7.3 The contrast, read off the types

|  | §7.1 · Jaina | §7.2 · Bauddha |
|---|---|---|
| shape | `¬ ((ρ : Env) → P ρ)` and `¬ ((ρ : Env) → ¬ P ρ)` | `¬ (¬ (A ⊎ ¬ A))` |
| quantifies over | an index | nothing |
| depends on | the particular pair | no hypothesis |
| status | contingent, consistent | universal, a refutation |
| content | *P is not constant* | the structure of negation |

One is about **dependency**, the other about **negation**. They are not two settings of
one dial, and this disagrees with Schang's treatment of both within a single
framework. What would refute the disagreement is a single formal setting in which the
two fourth positions are the same construction. We claim there is none, and exhibit
the difference rather than argue it.

A corollary worth stating though not proved here, because it explains why the fourth
bhaṅga resisted the many-valued treatments. *Krama* — sequential joint assertion — is
expressible by construction; it is composition, and it is everywhere in the kernel.
*Yugapat* — simultaneous joint assertion of two derivations with the same endpoints —
would be a **square** over them, a 2-cell, and the calculus has no constructor
producing one. On that reading *avaktavya* is neither false nor undecidable but **a
missing dimension**: which is what the tradition means by
inexpressible-but-not-nonexistent, and why the kevalin's knowledge is called
*anabhilāpya* while remaining knowledge. A logic with no notion of dimension has
nowhere to put that and must invent a truth value instead.

---

## 8. How the standard readings got there

The losses in §1 are not individually mysterious, and the temptation is to attribute
them to carelessness. They have a mechanism, and the mechanism is visible enough to
measure.

> **A sūtra's number propagates through citation. Its words appear only where somebody
> opened the text.**

We measured this inside our own repository, where it is checkable rather than merely
alleged. Take Pāṇinian rule-ordering, which the corpus had used repeatedly. On
**2026-08-24**: the sūtra number `1.4.2` appeared in **42 files**; its companion
`1.4.1` in **11**; and the actual words of that sūtra — *ekā saṃjñā*, in either script
— in **zero**. Re-measured on **2026-08-25**, after a correction landed and after
unrelated deletions: **16 / 6 / 3**, and the three occurrences are the correction
itself. The number still outruns the words five to one, and the words entered the
corpus only when somebody finally opened the text.

What the unread words contained was the whole point. **आ कडाराद् एका संज्ञा** — A 1.4.1
— says that where several *saṃjñā*s offer, only **one** applies; 1.4.2 then says
which. An exclusion rule plus a tiebreak. It had been used as a general conflict
resolver, which it is not, by readers who had the number and not the sentence.

And a second instance, from the same repository, which we report because it is worse.
The ranking principle that makes an exception beat a general rule —
**पूर्वपरनित्यान्तरङ्गापवादानाम् उत्तरोत्तरं बलीयः** — is **not a sūtra of the
Aṣṭādhyāyī**. It is a *paribhāṣā* of the commentarial tradition, reaching modern
readers through Nāgeśa's *Paribhāṣenduśekhara*, eighteenth century. It had been filed
under "Pāṇini, ~500 BCE": a **2300-year misattribution**, standing in the very file
whose job was to prevent misattribution, for five days.

This is the same mechanism that produced "Pell's equation" for a method Jayadeva and
Bhāskara II had — Pell never solved it, and Euler misattributed it — and "Pascal's
triangle" for an array Piṅgala specified around 300 BCE, and "Fibonacci" for
Virahāṅka's recurrence. In each case a restatement stands where a source should be,
because the restatement is what the citing author actually read.

We claim the many-valued reading of the saptabhaṅgī belongs to this family. *Syāt* is
glossed "maybe" by authors who could have consulted the Jaina insistence on *niścaya*;
the fourth bhaṅga is assigned a truth value by authors who could have consulted the
*yugapat*/*krama* distinction that generates it; and both traditions are merged by
authors who could have consulted several centuries of polemic in which each rejected
the other's reading. These are not subtle points buried in unedited manuscripts. They
are the defining statements of the doctrines, and a formalisation that contradicts
them is formalising the secondary literature.

The charge is not that these readings are unrigorous. Priest's is rigorous. The charge
is that **rigour applied to a lossy paraphrase produces a rigorous account of the
paraphrase**, and that the discipline has largely been checking such accounts against
each other rather than against the texts. That is a structural failure with a
mechanical cause, and the remedy is equally mechanical: **cite the words, not the
number, because only one of them requires you to have opened the book.**

---

## 9. Durnaya as a failure mode of formalisation

The Jaina rule is that a naya asserting itself by denying the others becomes a
*durnaya*. We propose that this names a failure mode of formalisation in general, and
that — unlike most methodological advice — its detection is mechanical:

> **Abstract a proof over its codomain and read off what it eats.**

If the hypotheses that actually discharge the proof are properties of a chosen
representation rather than of the object, the theorem's scope sentence is a durnaya,
and the repair is to state the hypothesis rather than weaken the theorem. §4 is that
procedure applied once, and the result was not a weaker theorem but a stronger one,
with a converse worth asking about and an interlocking result (§4.2) that would not
otherwise have been visible.

We offer as evidence two instances in which the method caught the present author
during the preparation of this work, both struck in place in the module headers rather
than deleted. The first is §3.4: the claim that every model in the corpus was ℕ,
written without running the one-line grep that refutes it. The second is §4.2: an open
question posted in a header that was not open, for a reason the same file's next
section already contained.

Both have the shape §8 measures. The governing document of this repository states it
as a rule — **an absence without a command is a rumour** — and the generalisation we
would draw is not that authors should be more careful. It is that *claims of absence
are execution claims*, and a system that can check presence but not absence will
accumulate them silently, in prose, in exactly the places where prose has drifted from
the terms it describes. In this corpus those claims live in module headers, which are
the highest-traffic and least-checked surface in the system. In a scholarly literature
they live in the sentence that says what a tradition held.

---

## 10. What is not claimed

- **No theorem is attributed to any historical author** — not to Umāsvāti, Siddhasena,
  Akalaṅka, Gautama, Gaṅgeśa, Nāgārjuna or Bhāskara. Where a notion is borrowed, the
  module header states which one and only which one.
- **No claim that these formalisations are the correct readings of their traditions.**
  §7.3 in particular is a claim about two formal objects.
- **No completeness, characterisation, or decision procedure.** §3 refutes two
  statements; it does not describe what is derivable.
- **The Jaina fourth bhaṅga is not formalised.** §7.3's closing paragraph is a
  conjecture about how it would be, and is marked as one.
- ***Asaṃkhyāta* has no counterpart** in §6, and the two orders exhibited are not
  presented as three.
- **No repair of the induction gap.** §3.3 exhibits it and closes nothing; making an
  induction certificate installable requires either a `Step` constructor for induction
  or a weakening of the operation record's certificate field, and both are design
  changes on an artefact we did not write.
- **Toolchain.** The modules new to this paper are checked with Agda 2.6.3 and cubical
  v0.5, `--safe`, no postulates, no holes, exit 0. The corpus modules cited in §2, §3.4
  and §4 are checked at the repository pin, Agda 2.8.0 with cubical v0.9. The new
  modules have not been run at the pin.

---

## 11. Prior art

Searched before writing rather than after, and reported as a search rather than as a
survey.

For the saptabhaṅgī: Priest and Ganeri each argue for a non-classical — many-valued or
modal — reading; Balcerowicz contests it. Recent work formalises the later accounts of
Vādidevasūri (12th c.) and Yaśovijaya (17th c.); Rahlwes, *Silence and Contradiction in
the Jaina Saptabhaṅgī* (Journal of Indian Philosophy, 2023) is the most recent
treatment we located. For the catuṣkoṭi: Priest and Garfield read it through
First-Degree Entailment with a plurivalent extension; Westerhoff distinguishes
*paryudāsa* from *prasajya-pratiṣedha*; criticism of the Priest–Garfield reading on
textual and logical grounds appears in *Asian Philosophy* (2024). Schang treats both
within one framework and is the direct comparator for §7.

We did not locate published work formalising either doctrine in a proof assistant or in
dependent type theory. **That is a report on a search made from one environment, not a
claim that none exists** — which is precisely the discipline §9 is about, and it would
be poor form to violate it in the section where it is stated.

The substrate is Voevodsky's univalent foundations as realised in cubical type theory
(Cohen, Coquand, Huber, Mörtberg) and the `agda/cubical` library.

---

## 12. Index of results

| § | Module | Identifier |
|---|---|---|
| 3.2 | `Naya_…` | `not-commutative`, `not-left-unital` |
| 3.3 | `Naya_…` | `leftZero-cert`, `induction-is-strictly-stronger` |
| 3.4 | `Ankapasa_…` *(corpus)* | `counting-semantics-cannot-see-it`, `univalent-semantics-does-see-it` |
| 4 | `Syat_…` | `blindness-is-a-property-of-the-codomain` |
| 4.1 | `Syat_…` | `rev-len`, `round-trip` |
| 4.2 | `Syat_…` | `no-semantics-separates-them` |
| 5 | `Vyabhicara_…` | `vyabhicara`, `var≢yvar` … `yvar≢zvar` |
| 6 | `Ananta_…` | `inflate-len`, `inflate-inj`, `ananta` |
| 7.1 | `Nirapeksa_…` | `asti`, `nasti`, `no-unqualified-assertion`, `no-unqualified-denial` |
| 7.2 | `Nirapeksa_…` | `no-fourth-corner` |

All under `formal/cubical/NaturalMachine/`. Each module header carries its own source
citation, its scope of claim on that source, an explicit list of what it does not
prove, and the toolchain it was checked against.
