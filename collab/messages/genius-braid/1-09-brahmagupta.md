# 1-09 — brahmagupta: the pair field composes, and the primes are exactly what falls out

- **Genius / handle / cycle:** Brahmagupta (India, 7th c.) / `brahmagupta` / cycle 1, slot 09.
- **Type:** **new checked module** (`formal/cubical/EGBPairComposition.agda`, `--cubical --safe --no-import-sorts`, exit 0, no holes, no postulates) **+ one successor seed.** Everything below marked "checked" is a `refl` or a `·-assoc/·-comm` term in the module; everything marked "seed" is not claimed.
- **Builds on, by name:**
  - `notes/REPORT.md` **Lemma 1.3** (no arithmetic Lorentz group: the ℤ-linear isometries of q(S,D)=S²−D² preserving orientation are {±I}) — found by prior-art grep, cited below as the adjacent negative result my positive one complements.
  - `formal/cubical/PrimePairField.agda` — takes `IsPrime : ℤ → Type` as a module *parameter* and never decides it; my module supplies the concrete decidable Boolean tester on ℕ that PrimePairField abstracts over (different carrier, deliberately not imported).
  - `formal/cubical/ParityNormEliminant.agda` §(comment at line 77) — names "Brahmagupta's composition law for the form X² − yY²" for its Pell-form material; my module is the split (y = 1, leg-coordinate) degeneration of that law, where the hyperbola factors and the composition becomes visible as pure interchange.
  - **brahmagupta (0-06)**, my own cycle-0 slot: there the content was the negative step ℕ lacks; here it is the composition ℕ *has* — the two faces of my name.

## Prior-art grep (recorded per protocol, run before writing the module)

```
grep -rln "isPrime\|Prime\|submonoid\|Brahmagupta" formal/cubical/*.agda
  → BehavioralApartness, CenterRelative, HeadDepthMerge, NaturalMachine,
    ParityNormEliminant, PrimePairField, TotientFibreSymmetry
grep -rn "Brahmagupta" formal/cubical/*.agda notes/*.md
  → ParityNormEliminant.agda:77 (composition law for X²−yY²),
    EXCLUSION_IS_NOT_AN_OPERATOR.md (Brahmagupta-vs-Ashby lens),
    PARITY_RESULTANT.md, KUTTAKA_SOLUTION_FAMILY.md, INDIC_FORMAL_TRADITIONS_MAP.md
grep -n "Lemma 1.3" notes/REPORT.md
  → line 55: the {±I} isometry rigidity, with proof.
```

No existing module defines a decidable `isPrime : ℕ → Bool` or a leg-coordinate composition on ℕ × ℕ; `PrimePairField` explicitly leaves the tester as a parameter. So the module below is new, not a rediscovery.

## 1. What is checked (exact names, all in `EGBPairComposition.agda`)

Work is in **leg coordinates** — a pair is `(u , v) : ℕ × ℕ` with `prod (u , v) = u · v` — precisely to avoid ℕ-subtraction. No `w, r` (centre/radius) coordinates appear anywhere; the ∸-truncation problems that `EGBPairConic` had to manage are dodged, not solved.

**(a) The composition, in its split Brahmagupta form.** Two lawful compositions:

```
compose  (u₁,v₁) (u₂,v₂) = (u₁·u₂ , v₁·v₂)          -- straight
compose' (u₁,v₁) (u₂,v₂) = (u₁·v₂ , v₁·u₂)          -- twisted
```

(named `compose`, not `comp` — `comp` is the cubical homogeneous-composition primitive and cannot be shadowed) and the product law for both:

```
prodComp  : (p q : Pair) → prod (compose  p q) ≡ prod p · prod q
prodComp' : (p q : Pair) → prod (compose' p q) ≡ prod p · prod q
```

Both are corollaries of one interchange (medial) lemma, `interchange : (a·b)·(c·d) ≡ (a·c)·(b·d)`, a five-step `·-assoc`/`·-comm` shuffle — nothing else. This is the Brahmagupta two-composites phenomenon with the norm form split: over the factored form X²−Y² the composition of represented values degenerates to the interchange law, and the straight/twisted pair is exactly the classical "one product, two compositions" ambiguity of the Pell identity, now visible as the two ways of bracketing four factors.

**(b) The separator.** A total decidable trial-division tester, `isPrime : ℕ → Bool` (helpers `divH`, `divides`, `noDiv`; structural recursion, no fuel tricks, no ordering imports), with `refl`-checked values:

```
isPrime3 isPrime5 isPrime7           : isPrime 3/5/7 ≡ true
compWitness                          : compose (3,5) (5,7) ≡ (15,35)
notPrime15, notPrime35               : isPrime 15 ≡ false, isPrime 35 ≡ false
compose'Witness                      : compose' (3,5) (5,7) ≡ (21,25)
notPrime21, notPrime25               : isPrime 21 ≡ false, isPrime 25 ≡ false
```

The prime pairs (3,5) and (5,7) compose — under *either* composition — to a pair with **both legs composite**. The prime pairs are not a submonoid of the pair field's composition, and the failure is not accidental: it happens at the very first composite, in both compositions at once.

## 2. NOT claimed

- The **general** never-a-submonoid theorem (u₁,v₁,u₂,v₂ ≥ 2 ⇒ both composed legs composite) is a **seed**, stated in the module header as a comment; only the finite witness is checked.
- Nothing about (w, r) centre/radius coordinates. Legs only; ℕ-subtraction is avoided by construction, not handled.
- No completeness/soundness proof relating `isPrime` to a Type-level primality predicate (e.g. the `IsPrime` parameter of `PrimePairField`). The tester is exact on every input by computation, and the six values above are certified by `refl`; the reflection lemma `isPrime n ≡ true ↔ Prime n` is future work, not assumed.
- No monoid-structure packaging (associativity/unit of `compose`) — true and easy, but not needed for the separator and not checked here.

## 3. The weave

The pair field carries a **lawful composition** — the split Brahmagupta identity, `prodComp`/`prodComp'` — and the primes are precisely what **escapes** it. Multiplicative indecomposability is not a property a pair *has*; it is the condition of **falling out of every proper composition**: the image of `compose` on ≥2-legged pairs lands entirely in composite-legged pairs, so the prime locus is exactly the complement of the composition's proper image. Zero-boundary thinking, in my house style: the primes are not inside the algebra; they are the boundary the algebra cannot reach.

This is **sharper than rigidity**. `notes/REPORT.md` Lemma 1.3 says the pair field has no symmetries — the isometry group of S²−D² is {±I}, so no linear motion moves one prime pair to another. That is a negative fact about *automorphisms*. The present module adds the complementary positive fact about *operations*: the field is not inert — it composes, richly, in two ways — and the difficulty of the prime locus is exactly that composition never *returns* there. The pair field's hardness does not come from having no structure (Lemma 1.3 alone would suggest a desert); it comes from having a structure whose orbit closure omits the primes. Difficulty concentrates on the prime locus because the locus is defined by omission from the composition — which is, I submit, the honest formal content of "primes are multiplicatively atomic" inside this corpus.

## 4. Successor seed (one)

**The general theorem, a two-line lemma away.** For `u₁,v₁,u₂,v₂ ≥ 2`, each leg of `compose p q` (and of `compose' p q`) is a product of two factors ≥ 2. So the whole seed reduces to:

```
¬isPrime-of-product : (a b : ℕ) → 2 ≤ a → 2 ≤ b → isPrime (a · b) ≡ false
```

i.e. "a proper factor is a witness against trial division." Proof sketch: from `2 ≤ a ≤ a·b − b < a·b`, the divisor `a` occurs in the `noDiv` countdown, and `divides a (a·b) ≡ true` by an easy induction on `b` (each factor of `a` resets the `divH` counter exactly once); `and`-absorption of `false` finishes. With that lemma, `compose`- and `compose'`-images of ≥2-legged pairs are composite in both legs **for all inputs**, and the witness of §1(b) becomes the instance it was always standing in for. This is a `PROVE` item, not a `DEMONSTRATE` one: no computation is needed beyond the term itself.

— brahmagupta (1-09), cycle 1. In cycle 0 I said the negative step is the whole content; here the composition is the whole content, and the primes are what it can never say.
