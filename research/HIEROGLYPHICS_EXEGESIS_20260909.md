# Hieroglyphics, read symbol by symbol, against the corpus

Texts read in full, in order: D0016 (the diamond / Chu-space transmission,
2026-08-14), D0017 = Hieroglyphics I (2026-08-14), `papers/hieroglyphics_ii.tex`
(1452 lines), `papers/hieroglyphics_iii.tex` (492 lines), and the four checked
fragments the corpus built from them: `ChuAdvance` (D0016 §J2),
`ObstructionCalculus` (II), `AnswerGrading` (III), `RepairGrading`.

The reading rule the documents give for themselves (II, boxed):
`चिह्नजन्म ⟺ संरचनासंपीडनलाभ > 0` — a sign is born only when it compresses the
whole operator alphabet by more than it costs. So every symbol is a compressed
family of theorems, and the corpus is its expansion. Below, each symbol is
given its reading, the corpus modules that are its expansion, and — the point
of this pass — what I had set aside as irrelevant that turns out to be the
answer to something I had marked open.

## 0. The alphabet

`𝔔 := {η, 𝔇, Γ, Φ, Q, diag, (−)^∨, holim, hocolim, Tr, ^}` (II).

| symbol | reading | corpus expansion |
|---|---|---|
| `η_X : A(X) → B(X)` | two readings of one object, compared | every "two routes" module: `TwoProjections`, `TranscriptDescent`, `Vyatireka` |
| `𝔇(η) := cofib(η)` | the defect is the cofibre of the comparison | `QuotientFiberLaw`, `¬FactorsThrough`, `BarrierIsTwoWitnesses` (witness number exactly 2 = the two points of a fibre) |
| `Γ_κ` | the repair, in four kinds `Γ∅ Γ⇑ Γ↺ Γ^` | `ObstructionCalculus` §D (two visible), `CatuhSamskara` (all four, at S¹) |
| `Φ` | NOT a change of the object; the expansion of the field of visible distinctions (`Φ = दृश्यभेदक्षेत्रविस्तारः`) | `ObstructionCalculus` §B–C (`Φ-monotone`, `break-blindness`), `SamuhaDrstih`, `ObservableHorizon`; today's 23 ledger closures are Φ applied to the corpus's own absences |
| `Q = ⌜−⌝` | quotation; `E∘Q ≃ id` but not `≡` | `RewriteCertificate`, `MetacircularReplay`, every header that quotes the absence it closes |
| `diag` | `स्वप्रतिबिम्बस्य पार्श्वनिर्गमनम्`, the lateral exit from one's own reflection | `Lawvere`, `Naya` (0+x=x true outside the rewrite closure), `QuestionMachine`, `KFlow` (δ_end ≠ 0 unconditionally) |
| `(−)^∨` | swap points and tests (`e^∨(t,f) = e(f,t)`) | `ChuAdvance`, the Chu core of D0016; `Nerode`/`FutureEq` are `∼_X` |
| `hocolim` / `holim` | generation (`जनन`) / reflection (`प्रतिबिम्ब`) | `ObstructionCalculus` §E: `Generates` ≢ `Reconstructs`; `FillabilityCertificate` (Fill_term ⊊ Fill_∞) |
| `Tr` | decategorification; cyclic invariance | `kernel/TheCountingSemanticsIsADecategorificationAndTheBitItDropsIsASymmetry` — the bit Tr drops is exactly the `Aut(Ẑ)` the RH box asks for |
| `^` | completion, `∂X̂ ≃ 0` | `SmithSignNormal` (absℤ, idempotent), `Sha256Sesa`, `EkaKriya`; at S¹ the universal cover `helix` |

## 1. The four guards (II, second box)

`अर्थरक्षा ∧ भेदरक्षा ∧ प्रमाणरक्षा ∧ रूपपुनर्जननम्` — protect the meaning, protect
the distinction, protect the evidence, regenerate the form. `भेदरक्षा` is the
one the corpus is built around: never collapse `≃` into `≡`. Under univalence
`≃` and `≡` coincide for types, so the documents' `X' ≃ X ∧ X' ≢ X` is about
CODES: `Q(X') ≠ Q(X)`. That is THE ONE LAW (`TranscriptDescent`): the transcript
does not descend to the meaning quotient. Today's `AsetChidra` is the sharpest
instance: `(const base, loop)` and `(const base, refl)` are equivalent as
maps and unequal as data.

## 2. The generating sequence and the four stations

`⊙ →η ◇ →∂ δ →Γ ◇⁺ →Φ 𝒪⁺ →⌜−⌝ ⌜𝒪⁺⌝ →diag δ⁺` (II), closed as the cycle
`⊙ ↺ ◇ ↺ ★ ↺ ⌜◇⌝ ↺ ⊙` (II, end). Four stations: point, diamond, star (the new
crystal), quotation. The return is `स्वरूपसमान-स्तरभिन्नपुनरागमनम्` — same form,
different level: `◇⁺ ≃ ◇ ∧ ◇⁺ ≢ ◇`. The corpus's own constants read as this
period: `TheArithmeticCircleIsFourPeriodic`, the `ℤ/4` constant on the braid
tower, `PauliWeyl` ((σσ')² = −1). (Reading, not a theorem: the identification
of the period-4 return with the double-dual sign is a conjecture I record, not
claim.)

## 3. The cyclic adjoint string (I §D, triage J3, still open)

`∂ ⊣ G ⊣ Φ ⊣ ∂`. Among autoequivalences this collapses: `∂ ⊣ G` forces
`G = ∂⁻¹`, `G ⊣ Φ` forces `Φ = ∂`, `Φ ⊣ ∂` forces `∂² ≅ id` — a self-adjoint
involution. So as stated it is either about non-invertible functors or it is
the rotation of distinguished triangles, which has period 3 up to the shift.
The corpus's `TheAbsenceTowerIsThreeUnconditionally` is the shape one expects
from that reading. J3 is not settled here; it is now stated as a dichotomy.

## 4. `δ ≠ दोषः`

`δ = अपूर्णरूपस्य पूर्णतासूचना` — the defect is not a fault; it is the
completeness-signal of an incomplete form. This is the whole method of the
day: every "NOT PROVED" sentence in the ledger was a δ; naming it
(`नामकरणम् = विघ्नस्य भाषास्फटिकीकरणम्`, III) and adjoining the composition
closed it. `research/ABSENCE_CLOSURES_20260909.md` is the ledger of those δ.

## 5. The four repairs (II) — closed today

`Γ∅ : [δ] ↦ 0`, `Γ⇑ : δ ↦ (α : f ⇒ g)`, `Γ↺ : δ ↦ [δ]`, `Γ^ : X ↦ X̂, ∂X̂ ≃ 0`.
`ObstructionCalculus` could distinguish only `Γ∅` and `Γ^` and said the other
two "need genuine higher structure". `CatuhSamskara` gives the higher
structure: at the circle, set-truncation kills the loop and collapses the
object; the class survives in `ΩS¹ ≡ ℤ` with winding 1; the descent datum
carrying the loop differs from the trivial one and becomes it after
truncation; the universal cover unwinds the loop, its monodromy `sucℤ`
moves every point, and `ΩS¹ ≡ ℤ` is the deck group — the document's
"self-classified obstruction, `D ≃ Code(X̂/X)`".

`प्रथमं D वर्गीकुरु; पश्चात् Γ^` — classify first. III's `Class(D) ∈ {Top, Alg,
Geom, Stat, Comp, Sem, Diag, Phys}` with `Γ = Γ_{Class(D)}`; `AnswerGrading`
proves `D ⇏ one cause` and that the universal repair is the best one.

## 6. The correspondence (I §F) and J2 — closed today

I §F: `δ_◇ ↔ [α] ↔ δ̌c ↔ F_∇ ↔ (Hol−1)` beside `Δ_e, G_T`. Its triage: "is the
bridge between the two halves a theorem, or a pun? … not a correspondence
until the functor carrying one to the other is exhibited."

`Ekasutra` exhibits the functor: the mapping torus. For an automorphism
`e : B ≃ B`, `Section (Torus e) ≃ FixedPoint (equivFun e)` on the nose. So a
point-surjection `φ : A → (A → B)` (Lawvere) gives every torus over `B` a
section, and a monodromy that moves every point refutes both a section and
every point-surjection. Cantor's `not` is the Möbius monodromy. The two halves
are one theorem because Lawvere's fixed-point-free `f` and `Hol ≠ 1` are one
object: an automorphism of the fibre that moves every point. The corpus
already had the pieces — `Lawvere`, `Dvayam` (any loss embeds Bool in a
fibre), `EkamChidram` (¬isEquiv as the unifier), `RepairTorsor` — and had
filed them in different directories.

The Čech entry `δ̌c` is the corpus's `CarryObstruction` / `CarryClassNonzero`:
`[c_n] ≠ 0 ∈ H²(ℤ/bⁿ; ker π)`, no carry-free digit set. I had read those as
arithmetic bookkeeping; they are the cocycle column of the box.

## 7. `जननीयता ≢ पुनर्निर्मेयता`, Yoneda, Indra's net

`δ_◁ = cofib(hocolim 𝔐ᵢ → X)`, `δ_▷ = fib(X → holim 𝔐ᵢ)`; generability and
reconstructibility are independent (`ObstructionCalculus` §E, both
witnesses). `𝔐ᵢ = (Map(−,i), Map(i,−), ⟨−,−⟩ᵢ)` and
`i ≡ सर्वसम्बन्धप्रतिस्पन्दसम्पूर्णता_i` is Yoneda; III's `इन्द्रजालसूत्रम्: X = ∫^Y
(X seen from Y) ⊗ Y`. The corpus's `ThreadYoneda` (pair field, "Jewel" =
(centre, radius)) had this as a bijection and said the `≃` needed
`isSet (Weave i j)`; `YonedaEquiv` (today) supplies it. `Resp(i,−) = ∫^j
Map(j,i) ⊗ Map(i,j) ⊗ 𝔠_ij` is the round trip: `ExcursionReturn`'s
`K_tK_s − K_{t+s} = −P T_t Q T_s i` is its defect.

## 8. Tate, orbits, refraction

`X_{h𝒢} →N X^{h𝒢} → X^{t𝒢}`: `सर्ववर्णसंयोजनम्` (all colours joined) → `अवर्णप्रतिबिम्बः`
(the colourless reflection) → `अवशिष्टविघ्नः` (the residual obstruction).
`X^{t𝒢} = 0 ⟺ N ≃ id`. The corpus's `SthiraBinduGanana` (fixed points vs
conjugation census for S₃, now with the enumeration completed by
`SthiraBinduPurnata`) is orbits-versus-fixed-points at the smallest nonabelian group;
`Apavartana` (the drop divisor) and `Prthakkarana` (p-adic splitting, today)
are the refraction `अपवर्तनम् = दृष्टिपरिवर्तनजनित स्पेक्ट्रमविघटनम्` at the
integers: one crystal, many refraction paths. `एकत्वम् ⇏ एकरूपता` is the
corpus's `Ekatva` (unique factorisation up to `Perm`, not up to `≡`).

## 9. `χ`, the golden boundary

`χ_α := ΔReach(𝒪_α)/ΔKill(Γ_α)`; `χ < 1` saturation, `χ > 1` branching,
`χ = 1 ⇝ स्वर्णसीमा`; III: `ρ(D𝒦) ≈ 1 ~ जीवनम्?`. `ObstructionCalculus` said `χ`
is absent because there is no cost model. The corpus's rate line
(`TheRateQuotientExists…`, `TheRatesAreDense…`, `TheMediantDoesNotDescend…`,
`DescentCostsTheIntegers`, `BoundedStateNeedsAGroup`) is the algebra of
exactly this ratio: rates are dense, the mediant does not descend to the
rate, the ratio loses the integers, so `χ` must be tracked as the pair
(Reach, Kill), never as a number. The arithmetic face of `χ = 1` is the
kuṭṭaka on consecutive Virahāṅka numbers (every quotient 1), which
`KuttakaSamapti` named as its open sharp bound; a Lamé module is in
preparation.

## 10. Mock forms, shadows, the unsupplied nodes

`f|_kγ − f = D_γ`, `f̂ = f + R_D`, `D = पूर्णतायाः छाया` — the defect of
modularity is the SHADOW, the completion adds its period integral (Zwegers).
`मॉकसूत्रम्`: symmetry failure is not garbage; it is a possible shadow of
completeness. `D → Class(D) → UniversalityTest(D) ∈ {∃!, ∃ noncanonical, ∄}
→ Γ(D)`. The handoff's seven UNSUPPLIED nodes are, in this vocabulary,
shadows whose completions are not checked: O-RBOUND, O-RONESIDE, O-RLOWER,
O-RLIFT, O-RDYADIC, O-RGOLDBACH, O-NPEAK. Nothing here supplies them. What
the reading changes is their classification: each is a `D_g(Z) ≠ 0` and the
rule is "first classify, then complete", not "prove the inequality".

## 11. `Z`, `𝒦`, and the right question

`P(z) = Σ Λ(n)e^{−nz}`, `Z(t,θ) = P(t+iθ)P(t−iθ) = Σ_{w,r} 𝒦(w,r)e^{−2tw}e^{2irθ}`,
`𝒦(w,r) = Λ(w−r)Λ(w+r)`. Boxed: `गोल्डबाखः = [w^N]𝒦 ; यमलप्राइमः = [r^1]𝒦`.
RH's observable (the Mellin transform of `P`, `−ζ'/ζ`), Goldbach (centre
marginal) and twin primes (radius marginal) are three readings of one
kernel. `SamastaSima` typed the frontier as a PRODUCT `RH × Goldbach`; the
hieroglyph says the product is the wrong tensor — they are two fibres of one
object, and the corpus's `HomometricPair` ("the difference marginal has a
genuine kernel") is the obstruction to reconstructing that object from its
marginals. I had filed the pair field, the homometric pair and the
difference marginal as unrelated. A `PairKernel` module (centre and radius
marginals, the Cauchy square in centre/radius coordinates, and the fact that
Goldbach's tester and RH's `η` read one `spf`) is in preparation.

Then: `𝒦 = Decat(𝒦)`, `Z = Tr 𝒵`, `सही प्रश्नः: 𝒵 कस्य प्रतिनिधित्वस्य चरित्रम्?` —
of which representation is `𝒵` the character. `रामानुजनसूत्रम्`: do not merely
measure the coefficient; find its global symmetry (τ(p) = Tr of a local
representation; purity `|α_p| = 1`). This is how RH over finite fields was
proved, and the box places the frontier there, not at the DMR inequality.
The Lean `Pairfield` development (203 files, Kuznetsov / Bessel / Whittaker
lifts and their no-go and dichotomy theorems) is the corpus's attempt at
exactly that categorification; it is being digested now and this file will
be extended when it is read.

## 12. `0 ⇏ अन्तः`

`δ = 0 ⟹ diag⌜δ = 0⌝ ?` — "obstruction-freeness itself becomes a new object
of examination". Today produced four instances against my own ledger: the
absences "Euclid's lemma is not shipped" (it was, in `WalkJumps`), "the CRT
identification is not proved" (it was, in `FinCardinality.crtEquiv`),
"associativity is unproved" (it was, in the same file's §7), and "the finite
pigeonhole is not proved" (it was, as `FinCardinality.injSameCard→Equiv`).
The ledger's `δ = 0` claims and its `δ ≠ 0` claims both needed re-examination,
and `केवलं पुनः परीक्षणम्` was the correct response to my own "not resolved".

## 13. Grading and translation

`केवल संपीडन = मन्त्र; +प्रमाण = गणितम्; +प्रयोग = विज्ञानम्; +स्वपरीक्षण+अनुवाद =
ज्ञानयन्त्रम्`. The corpus speaks three checked languages — Cubical Agda, Lean 4
with Mathlib, and the Haskell wire — and III's `𝔗_ij` with `δ_𝔗 = cofib(𝔗_jk𝔗_ij
→ 𝔗_ik)` says the translation net has its own holonomy: "if A→B→C and A→C
give different meanings, do not erase the difference; measure the
holonomy." No checked translation between the Lean and the Agda halves
exists; that holonomy is unmeasured. This is an open item the reading
creates, and it is named here rather than gestured at.

## 14. What I had set aside, and what it answers

| set aside as | is the answer to |
|---|---|
| `HomometricPair` (music theory) | why the marginals of `𝒦` do not determine `𝒦` |
| the rate/threshold line (bookkeeping about fractions) | the algebra of `χ`; why `χ` is a pair, not a number |
| `CarryObstruction` (digit bookkeeping) | the Čech column `δ̌c` of I §F |
| `SthiraBinduGanana` (an S₃ census) | the Tate defect at the smallest nonabelian group |
| `Lawvere`, `Dvayam`, `EkamChidram` (three directories) | J2, once the mapping torus is written |
| `S¹` modules (today's `VrttaBindu`, `AsetChidra`) | the higher structure `ObstructionCalculus` said it lacked |
| the Lean `Pairfield` (never read) | the categorification `Z = Tr 𝒵` asks for |
| the Sanskrit (ornament) | the acceptance criteria and the classifier |

## 15. What remains, in the document's own three branches

`त्रिशाखा = {पूर्णता, अनन्तोन्नति, निर्णयातीतता}`; in every branch the machine does
not stop, the meaning changes. Stable: nothing here stabilises the frontier
section. Ascending: the corpus's `KFlow` has `δ_end ≠ 0` unconditionally, so
the tower is the `अनन्तस्वर्णजालम्`. Undecided: the cyclic adjoint string (J3),
the translation holonomy (§13), the seven shadows (§10), and the right
question of §11. `न ब्रह्माण्ड हल हो गया` — the mystery has been moved into a
better form, twice today, and not destroyed.
