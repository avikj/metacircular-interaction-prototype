# Standpoints Compute

### Jaina, Bauddha and Naiyyika logic in cubical type theory

**‡®‡Ø‡µ‡æ‡¶ ¬ ‡‡‡Ø‡æ‡¶‡‡µ‡æ‡¶ ¬ ‡‡‡‡‡‡ï‡ã‡ü‡ø ¬ ‡µ‡‡Ø‡æ‡‡‡‡ø**

This is a record of what the texts say, what the standard formalisations say, and
what is checked. Every formal statement is a machine-checked Agda term; ¬ß12 gives
the module and identifier for each. Every citation is either verified against a
primary e-text with file and line, or marked unverified. No theorem is attributed
to any historical author. Where two schools disagree, both readings are stated.

---

## 1. The kernel

Three files, 156 + 63 + 77 = 296 lines, written for other purposes.

```agda
data Tm : Type‚ where
  var yvar zvar uvar vvar wvar : Tm
  zero : Tm
  suc  : Tm ‚í Tm
  add  : Tm ‚í Tm ‚í Tm

data Step : Tm ‚í Tm ‚í Type‚ where
  add-zero  : (x : Tm) ‚í Step (add x zero) x
  add-suc   : (x y : Tm) ‚í Step (add x (suc y)) (suc (add x y))
  suc-step  : {x y : Tm} ‚í Step x y ‚í Step (suc x) (suc y)
  add-left  : {x y : Tm} ‚í Step x y ‚í (z : Tm) ‚í Step (add x z) (add y z)
  add-right : (z : Tm) ‚í {x y : Tm} ‚í Step x y ‚í Step (add z x) (add z y)
  reverse   : {x y : Tm} ‚í Step x y ‚í Step y x

data Derivation : Tm ‚í Tm ‚í Type‚ where
  done      : (x : Tm) ‚í Derivation x x
  then-step : {x y z : Tm} ‚í Step x y ‚í Derivation y z ‚í Derivation x z
```

`done` is reflexivity, `then-step` transitivity, `reverse` symmetry, the three
congruence rules congruence, `add-zero` and `add-suc` the two axioms. Symmetry
lifts from steps to chains. `Derivation a b` is a proof in equational logic over
`{x + 0 = x, x + suc y = suc (x + y)}`.

One interpretation: `eval : Tm ‚í Env ‚í ‚ï`, `Env` holding six independent
natural-number coordinates, `derivation-sound` carrying every derivation to a path
in ‚ï at every environment. A comment in the source says the six coordinates are
kept distinct because "identifying them would prove only equality on the diagonal."
¬ß5 gives the term.

Already in the kernel's corpus: it is strictly a category and weakly a groupoid ‚î
concatenation associative and unital on the nose, `reverse (reverse p)` a different
constructor application from `p`. Its soundness lands in an identity type of ‚ï,
hence in a proposition, so two derivations with the same endpoints have equal
soundness proofs.

`HypStep`, `HypDerivation`, `InductionCertificate` and `induction-sound` are in the
kernel and are imported by nothing.

---

## 2. The citations, verified and unverified

Checked against `tokushige-koyasan/gretil-corpus` (241 MB, 784 plain-text e-texts).

| cited | status | source |
|---|---|---|
| ` kardek saj ‚ñ PS_1,4.1 ‚ñ` | verified | `6_sastra/1_gram/sa_pANini-aSTAdhyAyI.txt:422` |
| `vipratiedhe para kryam ‚ñ PS_1,4.2 ‚ñ` | verified | same file, line 425 |
| `1.2.4: savyabhicra-viruddha-prakaraasama-sdhyasama-kltt hetvbhs` | verified | `6_sastra/3_phil/sa_gautama-nyAyasUtra.txt:200` |
| `1.2.5: anaikntika savyabhicra` | verified | same file, line 204 |
| *Tattvrthastra* 5.29, `utpdavyayadhrauvyayukta sat` | verified **as a quotation in another school's text** | `6_sastra/3_phil/sa_arcaTa-hetubinduTIkA-edsanghavi.txt:1671` |
| *Tattvrthastra* 5.31, `arpitnarpitasiddhe` | **not verified** ‚î absent from this corpus | ‚î |
| the seven-naya list | **not verified** ‚î absent from this corpus | ‚î |
| *Anuyogadvrastra*, *Sthnga*, *Bhagavat* on the three orders | **not verified** ‚î not consulted | ‚î |

Two things the e-texts carry that secondary accounts do not.

**A 1.4.1 was taught two ways, and Patajali says so.** The *Vykaraamahbhya*
on that stra: `kim  kart ek saj iti hosvit prk kart param kryam
iti`, and then `ubhayath hi cryea iy stram pratipdit : kecit 
kart ek saj iti , kecit prk kart param kryam iti` ‚î the teacher taught
it both ways; some hold one, some the other
(`6_sastra/1_gram/sa_pataJjali-vyAkaraNamahAbhASya.txt:11642, 11644`).

**The Jaina definition of *sat* survives in this corpus inside a Buddhist refutation
of it.** Arcaa, *Hetubinduk* (8th c.), quotes it with its number and rejects it:
`utpdavyayadhrauvyayuktasat [Tattvrtha- 5.29.] ity etad apy ayuktam,
dhrauvyeotpdavyayayor virodht ekasmin dharmiy ayogt` ‚î origination and
cessation contradict persistence, and the three do not hold in one substrate. The
Jaina answer he then reports is `kathacid utpdavyayau kathacit dhrauvyam` ‚î in
some respect origination and cessation, in some respect persistence.

Spelling, recorded because it governs any search: the Adhyy e-text writes
`saj`, not `saj`. A search on one spelling returns nothing on the other.

---

## 3. A model is a naya

`Tm` with `Derivation` is a category, so a semantics is a functor out of it. `eval`
with `derivation-sound` is one: terms to functions, derivations to paths,
`then-step` to composition, `reverse` to `sym`.

The two axioms constrain `add a b` only where `b` is literally `zero` or `suc _`.
At an opaque `b` they do not constrain it. ‚ï interprets it commutatively. ‚ï is a
set, so all parallel derivations get equal soundness proofs.

### 3.1 A second model

Both axioms hold by `refl`.

```agda
data Atom : Type‚ where
  aX aY aZ aU aV aW aS aM : Atom

p : W ‚í W ‚í W                       -- right-unital, successor-compatible
p a []       = a
p a (aS ‚à b) = aS ‚à p a b
p a (c ‚à b)  = a ++ (aM ‚à c ‚à b)

‚ü¶_‚üß : Tm ‚í W
‚ü¶ zero ‚üß    = []
‚ü¶ suc t ‚üß   = aS ‚à ‚ü¶ t ‚üß
‚ü¶ add l r ‚üß = p ‚ü¶ l ‚üß ‚ü¶ r ‚üß
‚ü¶ var ‚üß     = aX ‚à []               -- and the other five coordinates

step-model : {a b : Tm} ‚í Step a b ‚í ‚ü¶ a ‚üß ‚â° ‚ü¶ b ‚üß
step-model (add-zero x)  = refl
step-model (add-suc x y) = refl
```

```agda
not-commutative : Derivation (add var yvar) (add yvar var) ‚í ‚ä
not-left-unital : Derivation (add zero var) var ‚í ‚ä
```

Both statements are true in ‚ï at every environment.

### 3.2 The induction apparatus

```agda
leftZero-cert : InductionCertificate (add zero var) var
InductionCertificate.base leftZero-cert = then-step (add-zero zero) (done zero)
InductionCertificate.step leftZero-cert =
  hyp-then (lift-step (add-suc zero var))
    (hyp-then (hyp-suc hypothesis) (hyp-done (suc var)))

induction-is-strictly-stronger :
  ((œ : Env) ‚í eval (add zero var) œ ‚â° eval var œ)
  ó (Derivation (add zero var) var ‚í ‚ä)
```

The kernel's operation record requires a `Derivation` as its certificate.
`induction-sound` produces an equation at every environment and no `Derivation`.

### 3.3 A universe-valued model already in the corpus

`‚ü¶_‚üß : Tm ‚í TEnv ‚í Type‚`, with `zero ‚¶ ‚ä`, `suc ‚¶ Unit ‚ä ‚àí`, `add ‚¶ ‚ä`. Every
`Step` constructor becomes an equivalence; `reverse` becomes `invEquiv`. It proves
`counting-semantics-cannot-see-it` against `univalent-semantics-does-see-it`, and
that the corresponding path in the universe is not `refl`, via the univalence
Œ≤-rule computing. It names the diagnosis **‡®‡Ø-‡®‡ø‡∞‡ã‡ß‡**.

That model validates commutativity ‚î `add ‚¶ ‚ä`, `‚ä-swap-‚â` ‚î and separates it from
the identity. The model in ¬ß3.1 refutes it. `add ‚¶ ‚ä` and `p` differ in what they
supply where the axioms are silent.

---

## 4. What the blindness proof consumes

The corpus states that no semantic criterion ‚î "none, at any h-level, of any
complexity" ‚î selects a short derivation over a long one. Abstracted over the
codomain:

```agda
blindness-is-a-property-of-the-codomain :
  {X : Type ‚ì} ‚í isSet X
  ‚í (‚ü¶_‚üß : Tm ‚í Env ‚í X)
  ‚í (sound : {a b : Tm} ‚í Derivation a b ‚í (œ : Env) ‚í ‚ü¶ a ‚üß œ ‚â° ‚ü¶ b ‚üß œ)
  ‚í (œ : ((œ : Env) ‚í ‚ü¶ a ‚üß œ ‚â° ‚ü¶ b ‚üß œ) ‚í C)
  ‚í (d e : Derivation a b) ‚í œ (sound d) ‚â° œ (sound e)
```

The hypotheses consumed are `isSet X`. ‚ï, `eval` and the six constructors do not
appear.

```agda
rev-len    : len (rev d) ‚â° len d
round-trip : len (d ‚äï rev d) ‚â° len d + len d
```

A measure sending `rev d` to the inverse of `d` sends a round trip to the identity.
`len` sends it to `len d + len d`.

```agda
module _ {X : Type ‚ì} (P : Tm ‚í X)
         (st  : {a b : Tm} ‚í Step a b ‚í P a ‚â° P b)
         (st-rev : (p : Step a b) ‚í st (reverse p) ‚â° sym (st p)) where
  no-semantics-separates-them : D detour-history ‚â° D direct-history
```

The corpus's two witness derivations differ by `s ; reverse s`. Their step counts
are 2 and 4. The proof above uses associativity, right cancellation and the left
unit law, and no h-level. The universe-valued model of ¬ß3.3 satisfies `st-rev`, and
obtains a separable pair only after adding a constructor.

---

## 5. Vyabhicra

*Nyyastra* 1.2.4 lists the hetvbhsas; 1.2.5 reads **`anaikntika
savyabhicra`**. The apparatus for *vypti* and its defeat by an *updhi* is
Gagea's, *Tattvacintmai*, ~1325.

```agda
vyabhicara : {a b : Tm} (œ : Env)
           ‚í (eval a œ ‚â° eval b œ ‚í ‚ä) ‚í Derivation a b ‚í ‚ä
vyabhicara œ ne d = ne (derivation-sound d œ)
```

One environment at which the meanings differ forbids the derivation at every
environment. `var` is derivably identified with none of the other five
coordinates; `yvar` with `zvar`. These are the first uninhabited `Derivation`s in
the corpus.

Gautama's word for the fault is **‡‡®‡à‡ï‡æ‡®‡‡‡ø‡ï** ¬ *anaikntika*. The Jaina word for
their doctrine is **‡‡®‡‡ï‡æ‡®‡‡** ¬ *aneknta*. The Jaina answer to the charge that
aneknta is anaikntika is in Akalaka and Vidynanda. Arcaa's objection quoted in
¬ß2 is the same charge made against the Jaina definition of *sat*, and the Jaina
answer he reports is *kathacid* ‚î in some respect.

---

## 6. Ananta

The Jaina counting apparatus distinguishes ‡‡‡ñ‡‡Ø‡æ‡ / ‡‡‡‡ñ‡‡Ø‡æ‡ / ‡‡®‡®‡‡. *Asakhyta*
is bounded above within the scheme; *ananta* is not. The texts naming this
(*Anuyogadvrastra*, *Sthnga*, *Bhagavat*) were **not consulted for this
paper**; the account is from secondary sources.

```agda
inflate : (k : ‚ï) {a b : Tm} ‚í Derivation a b ‚í Derivation a b
inflate zero        d = d
inflate (suc k) {a} d =
  then-step (reverse (add-zero a)) (then-step (add-zero a) (inflate k d))

inflate-len : (k : ‚ï) (d : Derivation a b) ‚í len (inflate k d) ‚â° (k + k) + len d
inflate-inj : (d : Derivation a b) (k k' : ‚ï) ‚í inflate k d ‚â° inflate k' d ‚í k ‚â° k'
```

`reverse (add-zero a) : Step a (add a zero)` fires at every term with no hypothesis
on `a`. The index is recoverable from the derivation, so ‚ï injects into
`Derivation a b` whenever it is inhabited.

The kernel's offering is a `List`, counted by `length`, and its one conservation law
preserves that count. `Derivation a b` is not finite.

---

## 7. The two fourth positions

### 7.1 Jaina

An assertion made with no *updhi* is ‡®‡ø‡∞‡‡‡ï‡‡; with one, ‡‡æ‡‡‡ï‡‡. Siddhasena
Divkara, *Sanmatitarka*; Akalaka. Not verified against a primary e-text.

```agda
asti  : eval var  diagonal     ‚â° eval yvar  diagonal        -- refl
nasti : ¬ (eval var off-diagonal ‚â° eval yvar off-diagonal)  -- znots

no-unqualified-assertion : ¬ ((œ : Env) ‚í P œ)
no-unqualified-denial    : ¬ ((œ : Env) ‚í ¬ P œ)
```

Both unqualified forms are refuted. The two qualified ones hold. `P` is a family
over `Env` whose fibres disagree. For a pair the calculus derives, the two
refutations fail.

This exhibits bhagas one and two, and the *krama* reading of the third. It does
not exhibit the fourth, which arises from ‡Ø‡‡ó‡‡‡.

### 7.2 Bauddha

The ‡‡‡‡‡‡ï‡ã‡ü‡ø is in Ngrjuna's *Mlamadhyamakakrik*. Its fourth corner with
‡‡‡∞‡‡‡‡Ø‡‡‡∞‡‡ø‡‡‡ß ‚î the negation that asserts nothing positive, `A ‚í ‚ä`; the
distinction from ‡‡∞‡‡Ø‡‡¶‡æ‡ is Westerhoff's:

```agda
no-fourth-corner : {A : Type ‚ì} ‚í ¬ (¬ (A ‚ä (¬ A)))
no-fourth-corner k = k (inr (Œª a ‚í k (inl a)))
```

For every `A`, at every level, on no hypothesis. Under *paryudsa* the fourth
corner is a different formula and this term does not apply to it. Priest and
Garfield read the catukoi paraconsistently and hold the fourth corner
assertable; this term is constructive and theirs is not.

### 7.3 Side by side

|  | ¬ß7.1 | ¬ß7.2 |
|---|---|---|
| shape | `¬ ((œ : Env) ‚í P œ)` and `¬ ((œ : Env) ‚í ¬ P œ)` | `¬ (¬ (A ‚ä ¬ A))` |
| quantifies over | an index | nothing |
| depends on | the particular pair | no hypothesis |
| holds | contingently | universally |

*Krama* ‚î sequential joint assertion ‚î is composition, and is throughout the
kernel. *Yugapat* ‚î two derivations with the same endpoints asserted at once ‚î
would be a square over them. `Derivation` has no constructor producing one.

Schang treats the saptabhag and the catukoi in one framework. The two shapes
above are a Œ† over an index and a formula in one variable.

---

## 8. Citations

` kardek saj` says that where several *saj*s offer, one applies.
`vipratiedhe para kryam` says which. Patajali records both readings of the
first (¬ß2).

**‡‡‡∞‡‡µ‡‡∞‡®‡ø‡‡‡Ø‡æ‡®‡‡‡∞‡ô‡‡ó‡æ‡‡µ‡æ‡¶‡æ‡®‡æ‡Æ‡ ‡â‡‡‡‡∞‡ã‡‡‡‡∞‡ ‡‡≤‡‡Ø‡** is not a stra of the
Adhyy. It is a *paribh* reaching modern readers through Ngea's
*Paribhenduekhara*, 18th century.

Euler attributed to Pell a method in Jayadeva and Bhskara II. The array in
Pigala's *Chandastra* is called Pascal's. Virahka's recurrence is called
Fibonacci's.

*Syt* is the optative of ‚à‡‡‡ used as an indeclinable. The Jaina texts call each
qualified predication *nicaya*. It is glossed "maybe" in the many-valued
literature.

---

## 11. Prior art

Priest and Ganeri read the saptabhag as supporting a non-classical ‚î many-valued
or modal ‚î system. Balcerowicz contests that reading. Recent formalisations take
Vdidevasri (12th c.) and Yaovijaya (17th c.); Rahlwes, *Silence and
Contradiction in the Jaina Saptabhag*, Journal of Indian Philosophy, 2023.

Priest and Garfield read the catukoi through First-Degree Entailment with a
plurivalent extension. Westerhoff distinguishes *paryudsa* from
*prasajya-pratiedha*. Criticism of the Priest‚ìGarfield reading appears in *Asian
Philosophy*, 2024. Schang treats saptabhag and catukoi in one framework.

The substrate is cubical type theory (Cohen, Coquand, Huber, Mrtberg) on
Voevodsky's univalent foundations, with the `agda/cubical` library.

---

## 12. Index of results

| ¬ß | Module | Identifier |
|---|---|---|
| 3.1 | `Naya_‚¶` | `not-commutative`, `not-left-unital` |
| 3.2 | `Naya_‚¶` | `leftZero-cert`, `induction-is-strictly-stronger` |
| 3.3 | `Ankapasa_‚¶` *(corpus)* | `counting-semantics-cannot-see-it`, `univalent-semantics-does-see-it` |
| 4 | `Syat_‚¶` | `blindness-is-a-property-of-the-codomain`, `rev-len`, `round-trip`, `no-semantics-separates-them` |
| 5 | `Vyabhicara_‚¶` | `vyabhicara`, `var‚âyvar` ‚¶ `yvar‚âzvar` |
| 6 | `Ananta_‚¶` | `inflate-len`, `inflate-inj`, `ananta` |
| 7.1 | `Nirapeksa_‚¶` | `asti`, `nasti`, `no-unqualified-assertion`, `no-unqualified-denial` |
| 7.2 | `Nirapeksa_‚¶` | `no-fourth-corner` |

All under `formal/cubical/Kernel/`, alongside `RewriteCertificate`,
`ControlledGrammar`, `GenerativeKernel` and the corpus modules they cite.
