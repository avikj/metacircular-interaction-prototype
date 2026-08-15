# The natural machine: ℕ by generation, place value as a chart

**Status: PENDING HOSTILE AUDIT.**

> **Added 2026-08-15, no text below altered.** This note is the *mathematical*
> companion to `formal/cubical/NaturalMachine.agda`, at the scale of the
> original 8 modules (2026-08-12), and remains the source of truth for the
> theorems in §§2–8. It is **not** current about scale, toolchain, or coverage:
> the tree is now 276 modules under `NaturalMachine/` plus 53 top-level, and
> §1's Agda 2.6.3 / cubical v0.5 recipe is superseded by the pin (Agda 2.8.0 /
> cubical v0.9) in `formal/cubical/BUILD.md`.
>
> For an operator's runbook — how to obtain and run the pinned toolchain, what
> the green claim covers exactly, what the `Control/` directory is for, and the
> current honest list of gaps — see **`notes/NATURAL_MACHINE_GUIDE.md`**. That
> guide is downstream of this note by construction: where the two disagree
> about a theorem, this note wins.

### Installed adapter: loop symmetries compute by factorial

`NaturalMachine.SymmetryCardinality` turns the existing loop-space
identification into an executable count.  For the finite carrier

\[
\operatorname{Aut}(\operatorname{Fin} n)= (\operatorname{Fin} n \simeq
\operatorname{Fin} n),
\]

the checked theorem `symmetryCount≡factorial` is

\[
\operatorname{card}(\operatorname{Aut}(\operatorname{Fin} n))=n!.
\]

The adapter inherits `cardAut` from the installed Cubical library and connects
it to `FinSetLoop≃Sym`, so a later query for the size of the loop symmetry
space reduces to fast natural-number factorial computation while retaining a
kernel-checked certificate.  Its scope is deliberately narrow: cardinality
forgets permutation multiplication and every individual loop, so equal counts
must never be used as evidence of group equivalence.

**Code:** `formal/cubical/NaturalMachine.agda` and `formal/cubical/NaturalMachine/*.agda`
(8 modules, 1447 lines), plus one deliberately-failing control at
`formal/cubical/NaturalMachine/Control/WrongEquivalence.agda`.

**Everything claimed as checked in §7 below was type-checked by Agda 2.6.3 against
cubical library v0.5 with `--safe`, on 2026-08-12.** Nothing in this note is a
numerical measurement; the repo's numerical lane is closed and no script was run.

This note executes `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §7 layer 2 (*checked
equivalence paths, transports, and coherence between distinct presentations*) on
the smallest object where it costs something, and crosses it with §4 (chart vs.
completion) and `DIGIT_CRYSTAL.md`'s residual. It takes `DEPENDENT_ORIGINATION.md`
§4's claim — *place value is the odometer, and the group-first order is the
mathematics' own dependency order* — and turns the first half of it into a
machine-checked theorem: `digits` is **defined** as iterated increment-with-carry,
and positional evaluation is **proved** to invert it.

---

## 1. Toolchain outcome (ladder step (a)+(b): full success)

Reported in the style of `LEAN_STATUS.md`, and with the same discipline: what was
actually run, not what was intended.

- **Agda**: `2.6.3`, installed from Ubuntu noble universe via
  `apt-get update && apt-get install -y --no-install-recommends agda`.
  A first attempt (`apt-get install -y agda agda-stdlib`, no `update`) failed
  with a stale-index 404 on `libmysqlclient21`; `apt-get update` fixed it.
  The `agda-stdlib` package is installed as a dependency but **is not used** —
  this development imports only the cubical library.
- **cubical library**: `v0.5`, commit `132a2a3197b490c571356f0399a2a6fbfab40f2a`,
  from `git clone https://github.com/agda/cubical` followed by
  `git fetch --depth 1 origin tag v0.5 && git checkout v0.5`. v0.5 is the
  release the library's own README pairs with Agda 2.6.3; master (v0.9) requires
  Agda 2.8.0 and would not have worked with the packaged Agda.
- **Locale**: `LC_ALL=C.UTF-8` is required, otherwise Agda's *error printer*
  crashes on `∷` when reporting an error (`commitBuffer: invalid argument`).
  Only error reporting is affected, not checking.
- **Build**: full clean check of the transitive closure, exit code 0, no
  warnings, 8 modules.

Reproduce:

```
apt-get update && apt-get install -y --no-install-recommends agda
git clone https://github.com/agda/cubical /path/to/cubical
cd /path/to/cubical && git fetch --depth 1 origin tag v0.5 && git checkout v0.5
mkdir -p ~/.agda && echo /path/to/cubical/cubical.agda-lib > ~/.agda/libraries
cd formal/cubical
LC_ALL=C.UTF-8 agda --library-file=$HOME/.agda/libraries -i . NaturalMachine.agda
```

Agda writes `.agdai` interface files next to the sources. They are build
artifacts and were removed after checking; **if any `.agdai` file is tracked in
git it should be deleted and gitignored** (this run found six of them already
tracked, presumably swept up by an automatic commit).

---

## 2. The thesis

> A symbol is a point of π₀. The geometry lives in the identity type.
> Univalence is what makes them say the same thing.

Charter §7 names three things that must not be collapsed into each other:
presentation identity (Unison-style content addressing), checked mathematical
paths (Cubical Agda), and causal acceptance history. The middle one is the one
with mathematical content, and it has a sharp operational test:

> **An asserted isomorphism is not transport.**

The test this development submits to is: define a structure natively on *each*
side, transport the structure from one side along `ua` of a *constructed*
equivalence, and prove the transported structure **equals** the native one. If
the native definition on the far side were secretly `f ∘ (native on the near
side) ∘ f⁻¹`, the theorem would be vacuous. It is not: `_⊕_` on digit words is
ripple-carry, digit by digit, and `transport-+-is-⊕` says ℕ's `_+_` pushed
across the path *is that algorithm*.

### 2.1 Why this is the phenomenon univalence is for (and Voevodsky's own reason)

Two presentations of "the same" object are related by a *path*, not by a fact.
The path can carry data. Here the data is visible in two places:

- **Automorphisms.** `Aut(ℕ, 0, suc)` is trivial (checked: `ℕ-algebra-Aut-trivial`)
  while `Aut(ℕ as a bare type)` is not (checked witness: `swap01-≢-id`). Adding
  structure shrinks the automorphism group; the structure identity principle is
  exactly the statement that *identity for a structure* is *equivalence
  respecting that structure*.
- **Loop spaces.** For any type `X`, `(X ≡ X) ≃ (X ≃ X)` — and the correspondence
  is multiplicative, so it is a group isomorphism onto the symmetric group of `X`
  (checked: `ΩGroup≃Symmetric`). At `X = Fin n` this reads: *the identity type of
  the finite set with n elements is Sₙ*. The numeral `n` is the connected
  component; Sₙ is what the numeral forgets.

On Voevodsky's motivation, per the repo's pramāṇa discipline (`PROTOCOL.md` §7:
*śabda is weakest; check the actual source*), two sources were fetched during this
session rather than recalled:

- **Verified by fetch.** Quanta Magazine, "Will Computers Redefine the Roots of
  Math?" (2015-05-19): *"In 1999 he discovered an error in a paper he had written
  seven years earlier. Voevodsky eventually found a way to salvage the result,
  but in an article last summer in the IAS newsletter, he wrote that the
  experience scared him."* and *"He began to worry that unless he formalized his
  work on the computer, he wouldn't have complete confidence that it was
  correct."* and, quoting Voevodsky: *"The world of mathematics is becoming very
  large, the complexity of mathematics is becoming very high, and there is a
  danger of an accumulation of mistakes."*
  <https://www.quantamagazine.org/will-computers-redefine-the-roots-of-math-20150519/>
- **NOT verified — unverified-memory / search-summary only.** The frequently
  repeated story that the specific paper was Kapranov–Voevodsky, *"∞-Groupoids as
  a Model for a Homotopy Category"* (1989), that Carlos Simpson published a
  counterexample in 1998, and that Voevodsky located the faulty lemma only in
  2013, comes here from a *search-result summary* of the IAS essay "The Origins
  and Motivations of Univalent Foundations" (2014). The IAS page returned HTTP
  403 and the PDF of the 2014 ASC lecture could not be text-extracted. **Do not
  cite these details from this note.** They are recorded as a lead, not as
  testimony.

The load-bearing point survives on the verified source alone: the motivation for
machine-checked foundations was *drift between what a symbol asserted and what the
mathematics was*. This development is a small instance of refusing that drift —
it does not let "ℕ and base-b numerals are the same thing" stand as a sentence.

---

## 3. Three presentations, defined independently

Fix a base `b = 2 + k` with `k : ℕ` a module parameter, so `b ≥ 2` always and no
base is privileged.

| | presentation | definition | module |
|---|---|---|---|
| (i) | `ℕ` | the initial algebra of `X ↦ 1 + X` | `Cubical.Data.Nat` (imported) |
| (ii) | `Tally = List Unit` | the free monoid on one generator | `FreeMonoid` |
| (iii) | `CanWord = Σ[ w ∈ Word ] Canonical w` | base-`b` digit words in canonical form | `Digits` |

with `Word = List (Fin b)` **little-endian** (head = least significant digit), and

```
value : Word → ℕ
value []      = 0
value (d ∷ w) = toℕ d + b · value w

Canonical : Word → Type
Canonical []          = Unit
Canonical (d ∷ [])    = 0 < toℕ d
Canonical (d ∷ e ∷ w) = Canonical (e ∷ w)
```

`Canonical w` says "w is empty or its most significant digit is positive" — no
leading zeros. It is a proposition (`isPropCanonical`, using `isProp≤`), so
`CanWord` is a subtype and its equality is equality of words.

**Choice worth flagging for the auditor.** Canonicity is stated as `0 < toℕ d`
rather than `¬ (toℕ d ≡ 0)`. In cubical, `0 < n` unfolds to `Σ[ j ] j + 1 ≡ n`,
so a canonicity certificate *hands you the predecessor*. This is not cosmetic:
it is what makes `canonical-pos` (a canonical nonempty word has positive value) a
two-line proof instead of a case analysis through `⊥`.

---

## 4. The equivalence ℕ ≃ CanWord, and where carrying lives

`digits : ℕ → Word` is **not** defined by division. It is defined by iterating
the odometer:

```
digits zero    = []
digits (suc n) = sucw (digits n)
```

where `sucw` is schoolbook increment-with-carry on words. This is
`DEPENDENT_ORIGINATION.md` §4's "place value *is* the odometer" taken literally
as a definition, and it is why no well-founded recursion, no `_div_`, and no
`_mod_` appear anywhere in this development.

**The carry step.** `dsucΣ : (d : Digit) → Σ[ r ∈ Digit × Bool ] (suc (toℕ d) ≡
toℕ (fst r) + carryVal (snd r) · b)` returns the incremented digit *paired with
its own specification*. The certificate travels with the value. (This is a
deliberate device: Agda's `with`-abstraction cannot see inside a previously
`with`-defined function, so certified-return plus a top-level step lemma taking
the certificate as an argument is the pattern used throughout. It costs a little
boilerplate and buys the entire proof.)

Then, by induction, with a step lemma per case:

- **`value-sucw : value (sucw w) ≡ suc (value w)`** — the odometer computes the
  successor. The carry case is where `b · suc (value w) = b + b · value w` meets
  `suc (toℕ d) = toℕ d' + 1 · b`.
- **`canonical-sucw`** — the odometer preserves canonicity. Needs
  `sucw-nonempty` (increment never empties a word) plus `canonical-cons`
  (prepending a digit to a *nonempty* canonical word is canonical, because
  canonicity constrains only the far end).
- **`value-digits : value (digits n) ≡ n`** — round trip 1, immediate.

Round trip 2 is where the real content is, and it is obtained for free from
**injectivity of `value` on canonical words**:

- **`digit-split`** — uniqueness of Euclidean division, in exactly the form
  needed: for digits `d e` and naturals `x y`, `toℕ d + b · x ≡ toℕ e + b · y`
  implies `toℕ d ≡ toℕ e` and `x ≡ y`. Proved by double induction on `x, y`; the
  mixed cases are killed by `b ≤ toℕ d < b`.
- **`canonical-pos`** — a canonical nonempty word has value `suc m` for some `m`.
- **`value-inj`** — combining the two.
- **`digits-value w c : digits (value w) ≡ w`** — because both sides are
  canonical and have the same value.

Hence `ℕ≃CanWord : ℕ ≃ CanWord` (via `isoToEquiv`) and `ℕ≡CanWord = ua ℕ≃CanWord`.

The `Tally` equivalence (`ℕ≃Tally`, `len`/`unlen`) is the easy one and is done in
full for contrast.

---

## 5. Transport, and the structure identity principle

### 5.1 Successor

```
transport-suc-is-sucC : transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i) suc ≡ sucC
```

with `sucC (w , c) = (sucw w , canonical-sucw w c)` defined natively. Proved by
`funExt` + `transportUAop₁` + the round trip.

### 5.2 Addition: the schoolbook algorithm, natively

`_⊕_` is ripple carry. The digit column `addDigitΣ c d e` splits
`carryVal c + toℕ d + toℕ e` into a digit and a carry bit, again returning its own
certificate; the bound `sumOf c d e < b + b` is proved from `carryVal c + toℕ d ≤ b`
and `toℕ e < b`, and in the carry-out case the *witness of `b < s`* directly
supplies the output digit (no truncated subtraction anywhere).

`addw` ripples; `value-addw` proves
`value (addw c u v) ≡ carryVal c + value u + value v`. The two pure-ℕ semiring
rearrangements in the cons/cons case are discharged by the cubical library's
reflection-based `Cubical.Tactics.NatSolver` (`solve`), which is itself `--safe`.
`canonical-addw` proves the result canonical, splitting on the tails so that the
only case needing an argument is `u = v = []` with carry-out `false`, where the
output digit is positive because the input's most significant digit was.

Then the monoid laws for `⊕` are **not re-proved by hand**: `⊕-assoc`, `⊕-idr`,
`⊕-idl` all follow from the corresponding laws on ℕ by injectivity of `valueC`.
That is transport doing work rather than decorating.

### 5.3 The two punchlines

```
transport-+-is-⊕ :
  transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _+_ ≡ _⊕_

ℕ-Monoid≡CanWord-Monoid : ℕ-Monoid ≡ CanWord-Monoid
```

The second uses the full SIP machinery — `Cubical.Algebra.Monoid.Base`'s
`MonoidPath`, which is built from the library's `𝒮ᴰ-Record` displayed-univalent-
relation apparatus. The two monoids are **equal as elements of `Monoid ℓ-zero`**,
not merely isomorphic. And

```
carrier-of-monoid-path : cong ⟨_⟩ ℕ-Monoid≡CanWord-Monoid ≡ ℕ≡CanWord
carrier-of-monoid-path = refl
```

holds *definitionally*: the underlying type path of the SIP equality is exactly
the `ua` we started from. The same three statements are proved for `Tally` in
`FreeMonoid`.

---

## 6. The chart/residual theorem: place value is a chart, not the object

This is the deliverable's mathematical heart and the formal shadow of
`DIGIT_CRYSTAL.md`. Everything here is at the level of **finite words**.

**D = reversal** is `Cubical.Data.List.rev`. **E = complement** is `compw = map
dcomp`, where `dcomp d` is read off the `≤`-witness of `toℕ d < b`, so the
defining identity

```
dcomp-law : toℕ (dcomp d) + suc (toℕ d) ≡ b
```

comes for free rather than through `∸`.

**(a) Both are involutions of the chart and they commute.**
`rev-involutive`, `compw-involutive`, `rev-compw-comm : rev (compw w) ≡ compw (rev w)`.
This is `DIGIT_CRYSTAL` Thm 3.1's *the commutator is trivial*, checked.

**(b) All three nonidentity elements act nontrivially.** `D≢id`, `E≢id`, `DE≢id`,
with explicit witnesses (`0∷1` for D, `0` for E and DE).

**(c) Neither is even an endomorphism of the canonical presentation.**
`rev-breaks-canonicity`, `compw-breaks-canonicity`: reversal of a canonical word
can end in `0`, and so can the complement of one.

**(d) Neither descends along the value map.** In the idiom of
`ProjectionChargeAudit.noChargeDescent`:

```
noRevDescent  : ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (rev w)))
noCompDescent : ¬ (Σ[ f ∈ (ℕ → ℕ) ] ((w : Word) → f (value w) ≡ value (compw w)))
```

For D the witnesses are `1` and `1∷0` — same value `1`, reversals of value `1`
and `b`. For E they are `[]` and `0` — same value `0`, complements of value `0`
and `b-1`. **The digit chart carries symmetries that the object it charts does
not.**

**(e) The residual is endianness.** Define the two truncations

```
π (delete the most significant digit)   ς (delete the least significant digit)
```

Then, checked:

| statement | name |
|---|---|
| `π (compw w) ≡ compw (π w)` | `π-compw` |
| `ς (compw w) ≡ compw (ς w)` | `ς-compw` |
| `π (rev w) ≡ rev (ς w)` | `π-rev` |
| `ς (rev w) ≡ rev (π w)` | `ς-rev` |
| `¬ ((w : Word) → π (rev w) ≡ rev (π w))` | `noRevπEquivariance` |

`π-rev` and `ς-rev` are **exactly `DIGIT_CRYSTAL` Thm 4.2's boxed intertwiner**
`π∘R = R∘ς`, `ς∘R = R∘π`, at word level. E commutes with π; D does not — it
*exchanges* π with ς. Since only the π-system has a group-valued limit
(`DIGIT_CRYSTAL` Lemma 4.1), this is the precise sense in which reversal lives on
the chart and dies on the completion: **reversal exchanges the two ends of a word,
and the completion has only one end.**

The whole package is bundled as the record `chartSymmetry : ChartSymmetry` so an
auditor can read off eleven checked fields in one place.

---

## 7. Verbatim checked/unchecked ledger

**Checked** means: appears with the stated type in the named file, and that file
is in the transitive closure of `agda ... NaturalMachine.agda`, which returned
exit code 0 with no warnings.

### 7.1 Files checked (8)

| file | lines |
|---|---|
| `formal/cubical/NaturalMachine.agda` | 89 |
| `formal/cubical/NaturalMachine/PathIsSymmetry.agda` | 151 |
| `formal/cubical/NaturalMachine/FreeMonoid.agda` | 123 |
| `formal/cubical/NaturalMachine/Digits.agda` | 320 |
| `formal/cubical/NaturalMachine/Endian.agda` | 303 |
| `formal/cubical/NaturalMachine/Transport.agda` | 279 |
| `formal/cubical/NaturalMachine/Decategorification.agda` | 100 |
| `formal/cubical/NaturalMachine/Controls.agda` | 82 |

`NaturalMachine/Control/WrongEquivalence.agda` (43 lines) is **excluded by
design** and must fail; see §8.

### 7.2 Checked statements

**PathIsSymmetry**
- `pathIsSymmetry : (X : Type ℓ) → (X ≡ X) ≃ (X ≃ X)`
- `finPathIsSymmetry : (n : ℕ) → (Fin n ≡ Fin n) ≃ (Fin n ≃ Fin n)`
- `pathToEquiv-∙ : (p : A ≡ B) (q : B ≡ C) → pathToEquiv (p ∙ q) ≡ compEquiv (pathToEquiv p) (pathToEquiv q)`
- `ΩGroup : (X : Type ℓ) → isSet X → Group (ℓ-suc ℓ)`
- `ΩGroup≃Symmetric : (X : Type ℓ) (h : isSet X) → GroupEquiv (ΩGroup X h) (Symmetric-Group X h)`
- `ΩFin≃Sym : (n : ℕ) → GroupEquiv (ΩGroup (Fin n) isSetFin) (Sym n)`
- `swap01-Equiv : ℕ ≃ ℕ`, `swap01-≢-id : ¬ (swap01-Equiv ≡ idEquiv ℕ)`
- `ℕ-algebra-rigid`, `ℕ-algebra-Aut-trivial : (e : ℕ ≃ ℕ) → equivFun e zero ≡ zero → (∀ n → equivFun e (suc n) ≡ suc (equivFun e n)) → e ≡ idEquiv ℕ`

**FreeMonoid**
- `ℕ≃Tally`, `ℕ≡Tally`
- `transport-+-is-++`, `transport-suc-is-cons`
- `ℕ-Monoid≡Tally-Monoid : ℕ-Monoid ≡ Tally-Monoid`
- `carrier-of-monoid-path` (by `refl`)

**Digits** (for every `k : ℕ`, i.e. every base `b ≥ 2`)
- `isPropCanonical`, `isSetCanWord`
- `dsucΣ` (certified digit successor)
- `value-sucw : value (sucw w) ≡ suc (value w)`
- `canonical-sucw`, `sucw-nonempty`
- `value-digits : value (digits n) ≡ n`
- `digit-split` (uniqueness of Euclidean division)
- `canonical-pos`, `value-inj`
- `digits-value : (w : Word) → Canonical w → digits (value w) ≡ w`
- `ℕ≃CanWord : ℕ ≃ CanWord`, `ℕ≡CanWord : ℕ ≡ CanWord`

**Transport** (every base)
- `transport-suc-is-sucC`
- `addDigitΣ` (certified digit column), `sumBound`
- `value-addw : value (addw c u v) ≡ carryVal c + value u + value v`
- `canonical-addw`
- `⊕-assoc`, `⊕-idr`, `⊕-idl`, `CanWord-Monoid`
- `digitsC-+`, `transport-+-is-⊕`
- `ℕ-Monoid≡CanWord-Monoid`, `carrier-of-monoid-path` (by `refl`)

**Endian** (every base) — the eleven fields of `chartSymmetry`, plus
`dcomp-law`, `dcomp-involutive`, `rev-breaks-canonicity`,
`compw-breaks-canonicity`, `π-snoc`, `ς-rev`, `ς-compw`.

**Decategorification**
- `card-Fin : (n : ℕ) → card (𝔽 n) ≡ n` (by `refl`)
- `card-invariant`, `fibre-connected : card X ≡ card Y → ∥ X ≡ Y ∥₁`
- `card≡MereEq : (card X ≡ card Y) ≃ ∥ X ≡ Y ∥₁`
- `FinSetLoop≃Sym : (n : ℕ) → (𝔽 n ≡ 𝔽 n) ≃ (Fin n ≃ Fin n)`

**Controls** — see §8.

### 7.3 UNCHECKED — stated in this note, not in Agda

Each of these is a prose statement. **None of them may be cited as checked.**

1. **"⟨D, E⟩ ≅ Klein four."** Agda checks that D and E are commuting involutions
   and that all three nonidentity elements act nontrivially. The group-theoretic
   inference *(a quotient of (ℤ/2)² in which no nonidentity element dies is
   (ℤ/2)²)* is done here in prose. No group object is constructed for
   `⟨D, E⟩ ≤ Sym(Word)`, and the three remaining pairwise distinctions
   (D≠E, D≠DE, E≠DE) are not separately checked.
2. **`DIGIT_CRYSTAL` Thm 4.4 / Cor 4.5 (the completion).** The bare-type
   inverse-limit equivalence is now formalized in
   `NaturalMachine.DigitTowerLimit`: checked reversal gives
   `reversalLimitEquiv : MSDLimit ≃ LSDLimit` with explicit inverse laws.
   The same module checks `transportLawToLSD` and its conjugacy equation:
   any binary law on `MSDLimit` transports through reversal to `LSDLimit`.
   Separately, `dropLSD-not-additive-base2` is the least carry witness to
   Lemma 4.1 (`1 + 1 = 2`), while `dropLSD-xor-hom-base2` is the opposite
   control showing that end deletion alone is not the obstruction.
   The all-base Rosetta equation is now checked as
   `carry-defect-decomposition`: from the native digit-column certificate
   `d + e ≡ r + base · carry`, it derives
   `(d + base·x) + (e + base·y) ≡ r + base·(x + y + carry)`.
   Thus the quotient/drop-LSD defect is exactly the column carry, for arbitrary
   tails and hence every positional depth. `zero-carry-preserves-tail` is the
   exact preservation control. The nonsplit extension and nonzero cohomology
   class remain Proposition 2.11 of `ATLAS_OF_N`; they are not formalized here.
   The same module defines the canonical stream charts and checks
   `limit-reversal-chart-identity`, the equation `J ∘ R_∞ = L`; pointwise this
   is `head (reverse xs) = last xs`. The collapse of the Klein four to ℤ/2 on
   ℤ_b remains **not formalized**. The diagrams are equivalent in `Type`,
   not as canonical group diagrams: most-significant truncation is a group
   homomorphism under positional value, while least-significant truncation is
   not. Transporting a group law to `LSDLimit` does not make its native finite
   projections homomorphisms. Bare univalence must not erase this residual.
3. **"Aut of the digit chart over the value map."** Mission item 5 asked for this
   group to be computed. It is not. What is checked instead is the contrast at
   both ends: `Aut(ℕ, 0, suc)` is trivial, `Aut(ℕ as a type)` is not, and the
   raw chart carries a faithful pair of commuting involutions none of which
   descends. The full group of self-equivalences `φ` of `Word` with
   `value ∘ φ = value` (which is large — the fibres of `value` are the
   zero-padding classes) is neither constructed nor computed.
4. **"ℕ ≃ ∥FinSet∥₀."** Not proved. `card≡MereEq` + `card-Fin` say that `card`
   induces a bijection between ℕ and FinSet-modulo-mere-equality, which is the
   π₀ statement in propositional-truncation form. The set-truncation `∥ FinSet
   ∥₂` is never formed, and no equivalence with it is claimed.
5. **Universe levels in §2.1.** `ΩGroup X : Group (ℓ-suc ℓ)` while
   `Symmetric-Group X : Group ℓ`. So `ΩGroup≃Symmetric` is a `GroupEquiv`, not a
   path — `uaGroup` needs matching levels. This is a real universe fact, not a
   defect, but "the loop group *equals* Sₙ" is **not** what was checked; "is
   isomorphic to" is.
6. **The Kapranov–Voevodsky/Simpson historical details in §2.1**, as flagged
   there: search-summary only, source fetch failed.

### 7.4 Postulate / hole / safety audit

- `grep -rn "postulate\|TERMINATING\|primTrustMe\|trustMe\|{!\|REWRITE"` over all
  9 `.agda` files: **no matches in code** (two matches are in comments, one of
  them this audit's own description).
- Every module declares `{-# OPTIONS --cubical --safe --no-import-sorts #-}`.
  Agda enforces that a `--safe` module may only import `--safe` modules, so the
  successful check also certifies that **the entire imported closure of the
  cubical library used here is `--safe`** — no postulates, no `TERMINATING`
  pragmas, no unsafe primitives, and complete coverage in every pattern match,
  anywhere in the dependency cone.
- No `--rewriting`, no `--type-in-type`, no `--experimental-irrelevance`.
- Termination: every recursion is structural or a `mutual` block whose call
  matrix Agda accepted without a pragma.

---

## 8. Designed annihilation: the control ledger

Per `PROTOCOL.md` §7 and msg 0073 — a headline claim ships with the apparatus
that would destroy it, or it is not a claim.

**Control 0 — the type-checker.** The primary falsifier. Every statement above
is a proposition in a `--safe` cubical theory; if any is false the checker
rejects it. This is not rhetorical: three genuine errors were caught and fixed
during this session (a `subst` in the wrong direction in `canonical-sucw-step`;
an unsolvable metavariable in `digit-split` where `inj-m+`'s implicit could not
be inferred through `b + x`'s reduction; and a reversed path composition in
`no-raw-round-trip`).

**Control 1 — canonicity is load-bearing.** `Controls.value-not-injective-on-Word`
exhibits `[]` and `0` as distinct words of equal value, and
`Controls.no-raw-round-trip : ¬ ((w : Word) → digits (value w) ≡ w)` refutes the
raw round trip. So `ℕ ≃ Word` is **false**, and `ℕ ≃ CanWord` is not a formality.

**Control 2 — the wrong endianness is refuted, not merely avoided.**
`Controls.wrong-endian-round-trip-fails :
¬ ((w : Word) → Canonical w → digits (value (rev w)) ≡ w)`. Reading a
little-endian word big-endian is exactly `value ∘ rev`; the canonical word `0∷1`
refutes it (its reversal has value 1, whose digits are a one-digit word, while
`0∷1` has two digits).

**Control 3 — a deliberately wrong equivalence that MUST FAIL to type-check.**
`formal/cubical/NaturalMachine/Control/WrongEquivalence.agda` asserts
`ℕ≃Word : ℕ ≃ Word` by offering `tt` where a canonicity certificate is required.
It is not imported by `NaturalMachine.agda`. Checked on 2026-08-12, the error is
verbatim:

```
/home/user/math/formal/cubical/NaturalMachine/Control/WrongEquivalence.agda:37,63-65
Unit !=< (Canonical w)
when checking that the expression tt has type Canonical w
```

**If a future edit makes this file compile, the development's main claim is
broken and this note is wrong.**

**Control 4 — base independence.** Every base-dependent statement is proved for
the parameter `k : ℕ`, i.e. for all `b ≥ 2` simultaneously; `NaturalMachine.agda`
additionally instantiates the whole development at `b = 2` and `b = 10` and checks
`base2-is-2 : Base2.b ≡ 2` and `base10-is-10 : Base10.b ≡ 10` by `refl`. A proof
that accidentally depended on a particular base would not elaborate.

**What no control here covers.** Nothing here tests whether the *statements* are
the interesting ones. A vacuously-true formalization type-checks just as happily
as a substantial one; the guard against that is §7.3 and hostile review, not the
machine.

---

## 9. What this demonstrates about charter §7 layer 2 — and what it does not

**Demonstrates.**

- Layer 2 is *implementable at all* in this repo's actual toolchain: two distinct
  presentations of one object, an equivalence constructed rather than asserted, a
  path produced by `ua`, structure transported along that path, and the
  transported structure proved equal to the independently-defined native one —
  and then, above that, equality of the two structured objects via SIP.
- The transport does mathematical *work*: associativity and unitality of
  schoolbook addition-with-carry are never proved directly; they arrive from ℕ
  through the equivalence. This is the first instance in this repo of a theorem
  being obtained on one presentation *because* it holds on another, with the
  transfer machine-checked rather than argued.
- The residual is real and is mathematics, not bookkeeping: the digit chart
  carries commuting involutions that the object does not, and the exact
  obstruction (endianness, via the π/ς intertwiner) is checked.

**Does NOT demonstrate.**

- This is **one theorem transported, by hand, between two presentations chosen in
  advance.** There is no implemented system. Nothing here caches, routes,
  content-addresses, or reuses across presentations automatically. Charter §7's
  three-layer synthesis remains, in the charter's own words, *"designed but not
  implemented"*, and this note does not change that sentence.
- It does not test `RESEARCH_SYSTEM.md` §1's hypothesis (that proof-relevant
  equivalence and theorem transport can *outperform ordinary research
  organization*). Outperforming is a comparative claim about a process; this is a
  single artifact. **"No end-to-end demonstration exists yet"** remains true.
- It does not touch the prime-pair / RH program, and takes no input from it.
- Nothing here is evidence that a numeral system is "better" or "worse" than ℕ.
  The chart/object distinction is a statement about *which structure lives where*,
  not a ranking.

The honest one-line summary: **layer 2 now has an existence proof and a cost
estimate (≈1450 lines of Cubical Agda for one object and one structure), not an
implementation.**

---

## 10. Frontier feedback

Successor questions this opens. All stated as open; none claimed.

1. **Finish §7.3 item 2.** The two explicit inverse limits,
   `R∞ : lim(π) ≃ lim(ς)`, canonical stream charts, and
   `DIGIT_CRYSTAL` Thm 4.4 (`J ∘ R_∞ = L`) now exist in Cubical Agda. A
   generic transported binary law and the least base-two finite carry
   obstruction are now checked separately; the remaining joint is to
   specialize the transported law to b-adic addition and prove that the
   `LSDLimit` canonical projections do not preserve that very law.
2. **Compute `Aut(Word / value)`.** Conjecturally `Word ≃ CanWord × ℕ` (canonical
   core plus a zero-padding count), whence the group is `∏_{n} Sym(ℕ)`. The
   decomposition is a normalization lemma of the same difficulty as
   `digits-value`; it would make §7.3 item 3 a theorem.
3. **Transport a *harder* structure.** Multiplication (long multiplication vs.
   `_·_`) or the order (`<` on ℕ vs. lexicographic-from-the-top on canonical
   words) would test whether the pattern used here scales, and the order case is
   interesting because the natively-correct comparison on little-endian words is
   *not* structural in the obvious direction.
4. **`DIGIT_CRYSTAL` Q2, formally.** "For a profinite completion of a chart of
   finite words, is the subgroup of chart symmetries that survives exactly the
   stabilizer of the truncation direction?" — item 1 above is the base case.

---

## 11. Provenance and attribution

- Charter direction: `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §4, §7, §8;
  `DEPENDENT_ORIGINATION.md` §4; `RESEARCH_SYSTEM.md` §1.
- Mathematical antecedent: `DIGIT_CRYSTAL.md` (the D/E crystal, Thm 3.1, Thm 4.2,
  the endian residual). §6 here formalizes a proper subset of that note's finite
  content; nothing in §6 is new mathematics relative to it, and the classical
  facts it rests on (free monoid on a finite alphabet, positional evaluation,
  uniqueness of Euclidean division) are classical.
- Style precedent: `formal/cubical/ProjectionChargeAudit.agda` (descent
  obstructions as `¬ Σ`), `notes/CUBICAL_QUOTIENT_AUDIT.md` (label the
  verification level), `notes/LEAN_STATUS.md` (report the toolchain honestly).
- Seed 1 of `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §12 (Cubical finite-set loop
  groups) is *thematically* adjacent to §2.1 here, but nothing from it was copied
  or replayed; `ΩGroup≃Symmetric` is proved here from `univalence` and
  `pathToEquiv-∙` directly. Seed 2 (the affine digit action, Lean) supplies the
  object studied in §6 and nothing else.
- Everything in `formal/cubical/NaturalMachine*` was written in this session.

**Status: PENDING HOSTILE AUDIT.** The most productive attacks: (i) find a
statement in §7.2 that is true but vacuous; (ii) find a place where §7.3's
unchecked list is understated; (iii) break Control 3 by making the wrong
equivalence compile.
