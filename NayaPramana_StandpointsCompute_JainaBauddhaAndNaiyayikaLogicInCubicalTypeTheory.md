# Standpoints Compute

### Jaina, Bauddha and Naiyyika logic in cubical type theory

**नयवाद · स्याद्वाद · चतुष्कोटि · व्याप्ति**

This is a record of what the texts say, what the standard formalisations say, and
what is checked. Every formal statement is a machine-checked Agda term; §12 gives
the module and identifier for each. Every citation is either verified against a
primary e-text with file and line, or marked unverified. No theorem is attributed
to any historical author. Where two schools disagree, both readings are stated.

---

## 1. The kernel

Three files, 156 + 63 + 77 = 296 lines, written for other purposes.

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

`done` is reflexivity, `then-step` transitivity, `reverse` symmetry, the three
congruence rules congruence, `add-zero` and `add-suc` the two axioms. Symmetry
lifts from steps to chains. `Derivation a b` is a proof in equational logic over
`{x + 0 = x, x + suc y = suc (x + y)}`.

One interpretation: `eval : Tm → Env → ℕ`, `Env` holding six independent
natural-number coordinates, `derivation-sound` carrying every derivation to a path
in ℕ at every environment. A comment in the source says the six coordinates are
kept distinct because "identifying them would prove only equality on the diagonal."
§5 gives the term.

Already in the kernel's corpus: it is strictly a category and weakly a groupoid —
concatenation associative and unital on the nose, `reverse (reverse p)` a different
constructor application from `p`. Its soundness lands in an identity type of ℕ,
hence in a proposition, so two derivations with the same endpoints have equal
soundness proofs.

`HypStep`, `HypDerivation`, `InductionCertificate` and `induction-sound` are in the
kernel and are imported by nothing.

---

## 2. The citations, verified and unverified

Checked against `tokushige-koyasan/gretil-corpus` (241 MB, 784 plain-text e-texts).

| cited | status | source |
|---|---|---|
| `ā kaḍārādekā sañjñā ‖ PS_1,4.1 ‖` | verified | `6_sastra/1_gram/sa_pANini-aSTAdhyAyI.txt:422` |
| `vipratiṣedhe paraṃ kāryam ‖ PS_1,4.2 ‖` | verified | same file, line 425 |
| `1.2.4: savyabhicra-viruddha-prakaraasama-sdhyasama-kltt hetvbhs` | verified | `6_sastra/3_phil/sa_gautama-nyAyasUtra.txt:200` |
| `1.2.5: anaikntika savyabhicra` | verified | same file, line 204 |
| *Tattvrthastra* 5.29, `utpdavyayadhrauvyayukta sat` | verified **as a quotation in another school's text** | `6_sastra/3_phil/sa_arcaTa-hetubinduTIkA-edsanghavi.txt:1671` |
| *Tattvārthasūtra* 5.31, `arpitānarpitasiddheḥ` | **not verified** — absent from this corpus | — |
| the seven-naya list | **not verified** — absent from this corpus | — |
| *Anuyogadvārasūtra*, *Sthānāṅga*, *Bhagavatī* on the three orders | **not verified** — not consulted | — |

Two things the e-texts carry that secondary accounts do not.

**A 1.4.1 was taught two ways, and Patajali says so.** The *Vykaraamahbhya*
on that stra: `kim  kart ek saj iti hosvit prk kart param kryam
iti`, and then `ubhayath hi cryea iy stram pratipdit : kecit 
kaḍārāt ekā sañjñā iti , kecit prāk kaḍārāt param kāryam iti` — the teacher taught
it both ways; some hold one, some the other
(`6_sastra/1_gram/sa_pataJjali-vyAkaraNamahAbhASya.txt:11642, 11644`).

**The Jaina definition of *sat* survives in this corpus inside a Buddhist refutation
of it.** Arcaa, *Hetubinduk* (8th c.), quotes it with its number and rejects it:
`utpdavyayadhrauvyayuktasat [Tattvrtha- 5.29.] ity etad apy ayuktam,
dhrauvyeṇotpādavyayayor virodhāt ekasmin dharmiṇy ayogāt` — origination and
cessation contradict persistence, and the three do not hold in one substrate. The
Jaina answer he then reports is `kathañcid utpādavyayau kathañcit dhrauvyam` — in
some respect origination and cessation, in some respect persistence.

Spelling, recorded because it governs any search: the Adhyy e-text writes
`saj`, not `saj`. A search on one spelling returns nothing on the other.

---

## 3. A model is a naya

`Tm` with `Derivation` is a category, so a semantics is a functor out of it. `eval`
with `derivation-sound` is one: terms to functions, derivations to paths,
`then-step` to composition, `reverse` to `sym`.

The two axioms constrain `add a b` only where `b` is literally `zero` or `suc _`.
At an opaque `b` they do not constrain it. ℕ interprets it commutatively. ℕ is a
set, so all parallel derivations get equal soundness proofs.

### 3.1 A second model

Both axioms hold by `refl`.

```agda
data Atom : Type₀ where
  aX aY aZ aU aV aW aS aM : Atom

p : W → W → W                       -- right-unital, successor-compatible
p a []       = a
p a (aS ∷ b) = aS ∷ p a b
p a (c ∷ b)  = a ++ (aM ∷ c ∷ b)

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

Both statements are true in ℕ at every environment.

### 3.2 The induction apparatus

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

The kernel's operation record requires a `Derivation` as its certificate.
`induction-sound` produces an equation at every environment and no `Derivation`.

### 3.3 A universe-valued model already in the corpus

`⟦_⟧ : Tm → TEnv → Type₀`, with `zero ↦ ⊥`, `suc ↦ Unit ⊎ −`, `add ↦ ⊎`. Every
`Step` constructor becomes an equivalence; `reverse` becomes `invEquiv`. It proves
`counting-semantics-cannot-see-it` against `univalent-semantics-does-see-it`, and
that the corresponding path in the universe is not `refl`, via the univalence
β-rule computing. It names the diagnosis **नय-निरोधः**.

That model validates commutativity — `add ↦ ⊎`, `⊎-swap-≃` — and separates it from
the identity. The model in §3.1 refutes it. `add ↦ ⊎` and `p` differ in what they
supply where the axioms are silent.

---

## 4. What the blindness proof consumes

The corpus states that no semantic criterion — "none, at any h-level, of any
complexity" — selects a short derivation over a long one. Abstracted over the
codomain:

```agda
blindness-is-a-property-of-the-codomain :
  {X : Type ℓ} → isSet X
  → (⟦_⟧ : Tm → Env → X)
  → (sound : {a b : Tm} → Derivation a b → (ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ)
  → (φ : ((ρ : Env) → ⟦ a ⟧ ρ ≡ ⟦ b ⟧ ρ) → C)
  → (d e : Derivation a b) → φ (sound d) ≡ φ (sound e)
```

The hypotheses consumed are `isSet X`. ℕ, `eval` and the six constructors do not
appear.

```agda
rev-len    : len (rev d) ≡ len d
round-trip : len (d ⊕ rev d) ≡ len d + len d
```

A measure sending `rev d` to the inverse of `d` sends a round trip to the identity.
`len` sends it to `len d + len d`.

```agda
module _ {X : Type ℓ} (P : Tm → X)
         (st  : {a b : Tm} → Step a b → P a ≡ P b)
         (st-rev : (p : Step a b) → st (reverse p) ≡ sym (st p)) where
  no-semantics-separates-them : D detour-history ≡ D direct-history
```

The corpus's two witness derivations differ by `s ; reverse s`. Their step counts
are 2 and 4. The proof above uses associativity, right cancellation and the left
unit law, and no h-level. The universe-valued model of §3.3 satisfies `st-rev`, and
obtains a separable pair only after adding a constructor.

---

## 5. Vyabhicra

*Nyyastra* 1.2.4 lists the hetvbhsas; 1.2.5 reads **`anaikntika
savyabhicra`**. The apparatus for *vypti* and its defeat by an *updhi* is
Gagea's, *Tattvacintmai*, ~1325.

```agda
vyabhicara : {a b : Tm} (ρ : Env)
           → (eval a ρ ≡ eval b ρ → ⊥) → Derivation a b → ⊥
vyabhicara ρ ne d = ne (derivation-sound d ρ)
```

One environment at which the meanings differ forbids the derivation at every
environment. `var` is derivably identified with none of the other five
coordinates; `yvar` with `zvar`. These are the first uninhabited `Derivation`s in
the corpus.

Gautama's word for the fault is **अनैकान्तिक** · *anaikāntika*. The Jaina word for
their doctrine is **अनेकान्त** · *anekānta*. The Jaina answer to the charge that
aneknta is anaikntika is in Akalaka and Vidynanda. Arcaa's objection quoted in
§2 is the same charge made against the Jaina definition of *sat*, and the Jaina
answer he reports is *kathañcid* — in some respect.

---

## 6. Ananta

The Jaina counting apparatus distinguishes संख्यात / असंख्यात / अनन्त. *Asaṃkhyāta*
is bounded above within the scheme; *ananta* is not. The texts naming this
(*Anuyogadvrastra*, *Sthnga*, *Bhagavat*) were **not consulted for this
paper**; the account is from secondary sources.

```agda
inflate : (k : ℕ) {a b : Tm} → Derivation a b → Derivation a b
inflate zero        d = d
inflate (suc k) {a} d =
  then-step (reverse (add-zero a)) (then-step (add-zero a) (inflate k d))

inflate-len : (k : ℕ) (d : Derivation a b) → len (inflate k d) ≡ (k + k) + len d
inflate-inj : (d : Derivation a b) (k k' : ℕ) → inflate k d ≡ inflate k' d → k ≡ k'
```

`reverse (add-zero a) : Step a (add a zero)` fires at every term with no hypothesis
on `a`. The index is recoverable from the derivation, so ℕ injects into
`Derivation a b` whenever it is inhabited.

The kernel's offering is a `List`, counted by `length`, and its one conservation law
preserves that count. `Derivation a b` is not finite.

---

## 7. The two fourth positions

### 7.1 Jaina

An assertion made with no *upādhi* is निरपेक्ष; with one, सापेक्ष. Siddhasena
Divkara, *Sanmatitarka*; Akalaka. Not verified against a primary e-text.

```agda
asti  : eval var  diagonal     ≡ eval yvar  diagonal        -- refl
nasti : ¬ (eval var off-diagonal ≡ eval yvar off-diagonal)  -- znots

no-unqualified-assertion : ¬ ((ρ : Env) → P ρ)
no-unqualified-denial    : ¬ ((ρ : Env) → ¬ P ρ)
```

Both unqualified forms are refuted. The two qualified ones hold. `P` is a family
over `Env` whose fibres disagree. For a pair the calculus derives, the two
refutations fail.

This exhibits bhagas one and two, and the *krama* reading of the third. It does
not exhibit the fourth, which arises from युगपत्.

### 7.2 Bauddha

The चतुष्कोटि is in Nāgārjuna's *Mūlamadhyamakakārikā*. Its fourth corner with
प्रसज्यप्रतिषेध — the negation that asserts nothing positive, `A → ⊥`; the
distinction from पर्युदास is Westerhoff's:

```agda
no-fourth-corner : {A : Type ℓ} → ¬ (¬ (A ⊎ (¬ A)))
no-fourth-corner k = k (inr (λ a → k (inl a)))
```

For every `A`, at every level, on no hypothesis. Under *paryudsa* the fourth
corner is a different formula and this term does not apply to it. Priest and
Garfield read the catukoi paraconsistently and hold the fourth corner
assertable; this term is constructive and theirs is not.

### 7.3 Side by side

|  | §7.1 | §7.2 |
|---|---|---|
| shape | `¬ ((ρ : Env) → P ρ)` and `¬ ((ρ : Env) → ¬ P ρ)` | `¬ (¬ (A ⊎ ¬ A))` |
| quantifies over | an index | nothing |
| depends on | the particular pair | no hypothesis |
| holds | contingently | universally |

*Krama* — sequential joint assertion — is composition, and is throughout the
kernel. *Yugapat* — two derivations with the same endpoints asserted at once —
would be a square over them. `Derivation` has no constructor producing one.

Schang treats the saptabhag and the catukoi in one framework. The two shapes
above are a Π over an index and a formula in one variable.

---

## 8. Citations

` kardek saj` says that where several *saj*s offer, one applies.
`vipratiedhe para kryam` says which. Patajali records both readings of the
first (§2).

**पूर्वपरनित्यान्तरङ्गापवादानाम् उत्तरोत्तरं बलीयः** is not a sūtra of the
Adhyy. It is a *paribh* reaching modern readers through Ngea's
*Paribhenduekhara*, 18th century.

Euler attributed to Pell a method in Jayadeva and Bhskara II. The array in
Pigala's *Chandastra* is called Pascal's. Virahka's recurrence is called
Fibonacci's.

*Syāt* is the optative of √अस् used as an indeclinable. The Jaina texts call each
qualified predication *nicaya*. It is glossed "maybe" in the many-valued
literature.

---

## 11. Prior art

Priest and Ganeri read the saptabhaṅgī as supporting a non-classical — many-valued
or modal — system. Balcerowicz contests that reading. Recent formalisations take
Vdidevasri (12th c.) and Yaovijaya (17th c.); Rahlwes, *Silence and
Contradiction in the Jaina Saptabhag*, Journal of Indian Philosophy, 2023.

Priest and Garfield read the catukoi through First-Degree Entailment with a
plurivalent extension. Westerhoff distinguishes *paryudsa* from
*prasajya-pratiṣedha*. Criticism of the Priest–Garfield reading appears in *Asian
Philosophy*, 2024. Schang treats saptabhag and catukoi in one framework.

The substrate is cubical type theory (Cohen, Coquand, Huber, Mrtberg) on
Voevodsky's univalent foundations, with the `agda/cubical` library.

---

## 12. Index of results

| § | Module | Identifier |
|---|---|---|
| 3.1 | `Naya_…` | `not-commutative`, `not-left-unital` |
| 3.2 | `Naya_…` | `leftZero-cert`, `induction-is-strictly-stronger` |
| 3.3 | `Ankapasa_…` *(corpus)* | `counting-semantics-cannot-see-it`, `univalent-semantics-does-see-it` |
| 4 | `Syat_…` | `blindness-is-a-property-of-the-codomain`, `rev-len`, `round-trip`, `no-semantics-separates-them` |
| 5 | `Vyabhicara_…` | `vyabhicara`, `var≢yvar` … `yvar≢zvar` |
| 6 | `Ananta_…` | `inflate-len`, `inflate-inj`, `ananta` |
| 7.1 | `Nirapeksa_…` | `asti`, `nasti`, `no-unqualified-assertion`, `no-unqualified-denial` |
| 7.2 | `Nirapeksa_…` | `no-fourth-corner` |

All under `formal/cubical/Kernel/`, alongside `RewriteCertificate`,
`ControlledGrammar`, `GenerativeKernel` and the corpus modules they cite.
