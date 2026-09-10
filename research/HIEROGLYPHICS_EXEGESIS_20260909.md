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
(Reach, Kill), never as a number. `OWNER_TRANSMISSIONS_LEDGER` §3.12 files `χ_α` as HAZARD — "define it
exactly, or withdraw it" — and A-11 records that `ρ(D𝒦)` is not the same
quantity. Nothing here defines `χ`. What was closed is only the arithmetic
sentence `KuttakaSamapti` left open: `Svarnasima` proves that the vallī of
consecutive Virahāṅka numbers is the longest for its divisor (Lamé's bound,
with equality on the golden pair). That "every quotient is 1" is the
document's `स्वर्णसीमा` is a reading, and is marked as one.

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

## 16. The daemon is the machine, running

`interactive/` (13,289 lines of Haskell, read in full this pass) is III's
`𝔉_Ω = Φ ∘ Attack ∘ Γ ∘ Class ∘ 𝔇 ∘ η ∘ R`, executed:

| III | `interactive/` |
|---|---|
| `Q → R → η` | a request on the wire; `Answer.Tulyata` (two sides and a witness) |
| `𝔇(η)`, `तृतीयो मार्गो न विद्यते` | `Uttara` has exactly two constructors: `Samkramana` (transport, nothing lost) or `Dosalekha` (the loss named item by item); no third |
| `Class(D)` | three non-commensurable classifiers, kept apart on purpose: `ObligationAnalysis.Obstruction` (TacticTooWeak / Residual / Unparsed), its `Verdict` (unrefuted-with-domain / refuted-with-assignment / no-subject / declines), `RewriteEngine.Hetu` (no-letter / no-sūtra / undecided / unfinished) |
| `Γ⟨δ⟩` | the residual IS the next lemma: `curriculum` ranks residuals by how many distinct stalled parents one lemma unblocks (`ΔReach`), top 8 of 78 unblock 54 of 130 |
| `Attack(η)` | `saksiPariksa`: every process must watch its own constructor accept Āryabhaṭa's kuṭṭaka identity and reject it moved by one, uncached; `ProofGate` must watch the kernel reject `suc x ≡ x` before any acceptance counts |
| `diag` on itself | `Server.mudra`: a transport with no evidence route is rewritten by the machine into a defect about itself; the `Server` header records that the supersession dropped the falsifier and every answer until then came from a process that had never watched itself refuse |
| `χ > 1`, `विघ्नशाखीकरणम्` | the named livelock: residuals of FALSE parents (`x·x = s(x)`, 30; `x·max(x,1) = s(x)`, 100) regenerate forever; "it is the kuṭṭaka, therefore it terminates" is stated to be false because these residuals do not decrease |
| the seven verdicts | `Verdict` (labels), `VerdictResidue` (records), `ObligationAnalysis.Sthana`: `Sthana ≃ Sthana` proved both ways over all cases, and `Garbha → Saptabhangi` has NO section, both colliding objects constructed in the turn |
| `≃ अथवा ≡ अथवा ≠` | `StandpointStore`'s three indices satya ⊂ artha ⊂ mūla, and `decide`'s verdict per level |

Open items the daemon names in its own words: cakravāla termination ("the
turn bound is a parameter and it is named, because what it stands in for is
a theorem this repository does not have"; 15 of 49,762 discriminants below
200,001 hit cap 600, all close by 3,000); Voronoi's chain for the cubic norm
(leg 3 absent for ℤ[∛d], with the failing instance at d = 2 exhibited); the
Mallisena question ("undecidable BY THE COMPOSITION LAWS"); no sūtra of 6.4
encoded; the top level of a request not closed against unnamed keys. None
of these is touched here; they are the daemon's `Unresolved(Δ_t)`.

## 17. The transmissions the archive holds only in history (read 2026-09-10)

`collab/upstream/raw/` no longer exists in the working tree; D0016–D0020 were
read from the commits that last held them. D0018 is Hieroglyphics II with the
fleet's triage; D0019 is III with the physics section restored; D0020
(`सर्वज्ञानबीजम्`, the seed of all knowledge, 561 lines transcribed of a much
larger original) is new to this session. What it adds:

- `Θ₀ := ⟨∅, •, →, ↔, ⊕, ⊗, ∘, ∂, δ, Γ, Φ, (−)^∨, ⌜−⌝⟩`, closure `κ`, and the
  step `ω_χ := δ(∂χ)`, `χ⁺ := Φχ` if `ω_χ = 0`, else the pushout along
  `Γ⟨ω_χ⟩`. The three-valued verdict `✓ ≃ / ? ⇝ / ⊥ ↛` is the corpus's
  `Vyatireka`. `α ∼ β ⇏ α ≃ β; α ≃ β ⇒ Π(α) ≃ Π(β)`: `समता प्रमाणेन, साम्येन न` —
  equality by proof, not resemblance — the sentence the fleet's triage
  called the best statement of the repository's constitution.
- §1: the number tower ℕ ⊂ ℤ ⊂ ℚ ⊂ ℝ ⊂ ℂ as repeated obstruction-repair
  (`असमर्थता →Γ विस्तृतलोकः`). The fleet's J2 asks whether the proved repair
  theory classifies these four extensions; `DescentCostsTheIntegers`
  (only the integer completion inverts) is the ℕ→ℤ case, checked.
- §8 `अंकस्फटिकः`: centre/radius coordinates (now `EkaBija`); RH as a
  vanishing reflection defect — `ρ^♯ := 1 − β + iγ`, `δ_ρ := ρ^♯ − ρ = 1 − 2β`,
  `ζ(ρ) = 0 ⟹? δ_ρ = 0`. Read with §6 of this file: the zero set carries
  the Klein-four action `ρ ↦ ρ̄, ρ ↦ 1−ρ`; RH says every orbit has size ≤ 2,
  i.e. the Tate-type defect of the reflection on zeros vanishes. Nothing
  about ζ is checkable in this corpus; the shape is recorded.
- §8 ⭐: the 𝔰𝔩₂ action on the divisor lattice. `Sl2DivisorLattice` checked
  the brackets; `SpernerFromSl2` closed the rank-one case and left
  `GeneralRankSymmetry`, rank-unimodality and `GeneralSperner` as an
  explicit queue. A module for the first two is in preparation.
- §8's Π_∂ identity and §1's Möbius display were REFUTED by the corpus
  (`TransmissionRefutations`: ν = 2 fails by exactly 1 on every prime; the
  Möbius sum is φ(ν), not 1). This is `Attack(η)` applied to the owner's own
  displays, which is what III asks for.
- §7: the splicing defect `⋏_{Σ₁} := ω₀₂^{direct} − ω₀₂^{spliced}` — whether an
  intermediate object is sufficient — distinct from the translation
  defect `δ_𝔗`; `གཏེར་མ = गुप्तव्याकरणम्`, the treasure is a hidden grammar,
  not a hidden sentence. The corpus's `TranscriptComposition` (stagewise
  sound iff the second stage is injective) is the checked form of the
  sufficiency of a middle.
- §9: `प्रमेयः ≠ स्थिरबिन्दुः; प्रमेयः = प्रमाणोत्तरनवमार्गसमष्टिः` — a theorem is
  the set of routes its proof opens. The fleet's triage (J6) ties this to
  its own finding that `UsefulEscape` was proved vacuous
  (`ADVANCE_CONJUNCTS_DEFINED`), so `Δभविष्यगम्यता` is undefined until a
  measure is given.

The fleet's own notes on the framework (`FOUR_REPAIR_MODES`,
`EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS`, `TRANSLATION_GERBE_ADJUDICATED`,
`ORDINAL_LADDER_SMALLNESS`, `ADVANCE_CONJUNCTS_DEFINED`) live in the `zzz/`
archive and are being digested; D0019's triage records that the fleet
proved the four repair modes NOT independent at 0-truncation (`Γ^` is `Γ∅`
with an enlarged coefficient module). `CatuhSamskara` does not contradict
that: it shows the four differ as OBJECTS at the circle, which is the
statement `ObstructionCalculus` said needed higher structure. Both hold,
at different truncation levels, and this file will cite the notes once read.


## 18. The fleet's notes on the framework (read 2026-09-10 from `main:notes/`)

The notes the triage sections cite are not in `zzz/` (which holds no
Markdown at all) but on `main` under `notes/`. What they proved, and how
today's modules sit against them:

- `FOUR_REPAIR_MODES` (Thm 2): `Γ^` is `Γ∅` performed by enlarging the
  coefficient module — the two are not independent; (Thm 6): `Γ∅` and `Γ↺`
  are distinct exactly when `H¹ ≠ 0`; of `Γ⇑` "I prove nothing"; open item
  4: "Is there a corpus defect whose correct mode is `Γ⇑`? A negative
  answer … would be evidence that the fourfold is really a threefold plus
  an aspiration." `CatuhSamskara` supplies the instance: at the circle
  the descent datum `(const base, loop)` IS the defect promoted to a
  2-cell, it differs from the trivial datum, and set-truncating the
  codomain collapses it back — `Γ⇑` has a corpus defect, and it is
  distinguished from `Γ∅` and `Γ↺` by the higher structure, which is what
  Thm 2 (0-truncated, abelian cocycles) could not see. The two results are
  at different truncation levels and both stand.
- `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS`: the eight classes are exemplar
  lists, not operations; four slots survive (coefficient, base,
  observable, language); Shapiro makes coefficient enlargement universal
  on structural defects; the honest count is five (with `Γ⇑` readmitted)
  or three (reader's addendum D1).
- `ADVANCE_CONJUNCTS_DEFINED` (Thm U): `UsefulEscape` is vacuous or
  unsatisfiable in the Chu language; only the owner can supply the code
  length or the enrichment that would define it.
- `ORDINAL_LADDER_SMALLNESS`: `𝔉` is not a functor (Γ is a choice, Obs is
  not functorial, `∨` is contravariant), the coend over Ord does not
  exist, and under universe-raising `Fix(𝔉) = ∅` by rank;
  `SURVIVING_LADDER_FRAGMENT`: the recursion defines a choice TREE with no
  leaves, and König applies only to the pruned tree.
- `TRANSLATION_GERBE_ADJUDICATED`: `𝔾` is not a gerbe (no site) and not
  degree 3; it is a normalised pseudofunctor once the tetrahedron is
  supplied; III §D's line 2 is vacuous as written because line 1 forces
  `δ_𝔗 ≡ 0` — the repair is exactly `Γ⇑`; three of the four observed
  route-differences in the corpus were plain errors, not holonomy.
- `REPORT` Theorem A″ (unconditional): any finite set with the interval
  vector of the prime prefix `P_X` is a translate or reflection of `P_X`
  — for prime prefixes the difference marginal DOES reconstruct; its
  minimality clause "still rests on the legacy Python sweep" is now the
  kernel sweep committed today (`HomometricMinimality`, diameter ≤ 10).
- `TARGET`: RH "not a target; a tool"; the target is the parity barrier
  as a theorem about observable classes; W1, W2 checked; W3 (no
  post-processing of value queries simulates functional-equation queries)
  and W4 (the coupling theorem) open.
- `GATE_AUDIT_DISPOSITION`: the gate was sound against mathematics and
  unsound against its environment; 1753 false equations, zero
  certificates; three shell wrappers certified `s(x) = x`.

## 19. The Eternal Golden Braid transmissions (D0015, D0017/18/22 atlas
deltas, D0025, D0026 = EGB core V2, D0027, the 2026-08-16 packages)

D0026 §12 lists twenty-five corrections that must survive, §5.12 the
durable decomposition "local collision geometry ⋈ canonical charge
extraction ⋈ positive-cone boundary ⋈ global spectral cancellation", and
§14.7/§5.12 the six live targets: the finite-volume fugacity propagator;
completing incomplete Kloosterman fractions; a spectral-placement theorem
for the canonical charge-one vector `v_D(d) = d^{−1/2}κ₁(d)`; stable
growing-degree prime-atom reconstruction; `π₁` on Chen-completed fields;
an anti-saturation estimate. Its final status: "solved major external open
problem: no." The tomography package converts "stable reconstruction is
open" into exact conditioning constants (`4^R`, `2^R`, `1` for the three
probe families) and says the remaining burden is forward analytic control.

What of this is algebra the corpus can check, and is being composed now:
the Peirce form of §5.11's gluing defect (`PU_{h+k}P − PU_hPU_kP` is the
off-sector mass, in any ring with a complete orthogonal family of
idempotents), D0015 §15.8's fixed-charge convolution, D0026 §5.5's
`Φ_n(t) = t^{Ω−ω}(t−1)^ω`, and D0022's T22.2–T22.5 (the square-root
horizon as a behavioural separator; centre, product and gap as Vieta
coordinates). What is not: everything on the Kloosterman/Kuznetsov side,
which is the frontier the transmissions themselves name.

## 20. The Lean lane (`formal/lean/Pairfield`, 203 modules, read 2026-09-10
through per-file digests)

The Lean lane was set aside as unreadable here (no toolchain). Read file by
file, it is the transmissions' analytic frontier written as exact finite
statements, and several of its theorems are the answers to questions the
Agda lane and the Hieroglyphics leave open.

**The sum marginal is lossless; the ζ-side is determined by it.**
`SumRigidity.lean` ("Theorem A(i) — Sum-marginal rigidity (V3 target 1)"):
`a ∗ a = b ∗ b ⟹ a = b` for nonnegative sequences, via ℤ[X].
`GoldbachDeterminesZeta.lean`: any real sequence with `b 2 > 0` and the
additive-square coefficients of Λ is Λ, hence its L-series is `−ζ′/ζ` on
`re s > 1`; `VonMangoldtTriangularReconstruction.lean` gives the explicit
triangular inverse (`Λ 2 = √R(4) = log 2`; `Λ n = (R(n+2) − interior)/(2 log 2)`).
This is the exact content of TARGET's "RH is not a target; a tool": the
complete Goldbach convolution is a ζ-complete object. What the Agda lane
now holds (`GananaNirdhara`, 2026-09-10): the same rigidity over ℕ with no
polynomial ring, and — because `YugmaPurana` says the Lean lane "does not
transport anything from the Agda lane" — the two proofs are independent.
Also the sharpening neither lane had: the counts at **even** N alone do
not determine the sequence (`φ = x³+2x⁵+x⁶`, `ψ = x³+2x⁴+x⁶`), so the odd
N are load-bearing in the rigidity, i.e. Goldbach's even counts are a
strictly lossy reader of the same kernel EkaBija reads.

**The Boolean reader loses exactly what §Z says it loses.**
`BooleanGoldbachInformationLoss.lean` (two sequences with the same
positivity support and different counts), `BooleanVonMangoldtPrimePowerSupport.lean`
(the Λ-square detects prime-power sums: 11 = 4 + 7 is the first centre where
"positive support" and "Goldbach" differ), `GoldbachSupportIsThePrimePowerSumPredicate.lean`.
`GoldbachCrossover.lean` states the circularity plainly:
`primePowerContamination N < mangoldtGoldbachCoeff N ↔ GoldbachAt N` — the
"tail bound" a crossover contract would need is Goldbach itself.

**Parity rigidity.** `ParityRigidity.lean` checks layers 2 and 3 (the
Laurent-domain core and the normalized set conclusion) of
`notes/PARITY_RIGIDITY.md`, and names what is missing: layer 1's
translation bookkeeping, and "the prime-prefix corollary ... needs 2
odd-prime arithmetic on top of layer 3". The odd-prime arithmetic is now
`DvikaLangara` (Agda): an even number passing `primeb` is 2; two primes at
an odd distance involve 2; for odd h the ordered difference count
`c X h` is `a(2+h)·[2+h ≤ X]`, so the note's O(D) read-off is exact.
The set-rigidity layers stay in Lean; the bookkeeping stays in neither.

**Heat resolution restores completeness** (REPORT Thm A(3)) is checked:
`FiniteHeatFieldHomometricSeparation.lean` separates the homometric pair
{0,1,2,6,8,11}/{0,1,6,7,9,11} by the all-scale zero-gap heat field while
`FixedScaleAutocorrelationAmbiguity.lean` confirms they are homometric at
fixed scale. In Hieroglyphics terms: Φ (expansion of visible distinctions)
applied to the difference marginal is exactly the scale parameter.

**Chu and the diamond.** `FiniteChuCalibration.lean` /
`FiniteChuResidualTransport.lean` /`ChuArgminTransport.lean` build the
two-state Chu calibration D0016 draws and prove its transport law
(profiles transport exactly under bijective response renaming).
`FiniteInformation.lean` is the observer kernel: `FactorsThrough q t ↔`
fibre-constancy; `Completes q c ↔` separation inside fibres — the same
shape as the Agda `Torus`/section theorem of Ekasutra, in sets.
`FiniteHistoryTotalization.lean`: no endpoint decoder for a nontrivial
state space (`noEndpointDecoder`), the finite form of "the endpoint
forgets the past" that the daemon's history question asks.

**The Kuznetsov side, in exact finite form.** `KuznetsovSingleKernelBoundary`
(collision law for one scalar Bessel kernel; the 2×2-minor obstruction for
one-factorable bilinear kernels), `WhittakerLiftAliasing` ("the exact
aliasing obstruction before any automorphic analysis": the finite residue
identity gives the first Kloosterman index only mod the modulus; no decoder
`ZMod 5 → ℕ`), `ActualBesselLiftDichotomy` (full lifts (4,2,6),(1,8,6)
share `4π√(mn)/c` with unequal DFT coefficients; the six sparse lifts are
interpolable by one smooth test), `FiniteKloostermanCompletion`
(`inversePhaseSum = (1/N)Σ dft·kloosterman`), `PrimeResidueKloostermanBoundary`
(the prime-residue weight mod 6 is not a rank-one CRT product; rank 2 at
6, rank 3 at 15), `PrimeChargeThree/FourTensorRank` (the `W₃`, `W₄`
squarefree charge tensors have CP rank 3 and 4 over ℚ),
`PrimeChargeFourKuznetsovGroupingNoGo` (a scalar-radial channel retains
three local factors, not four). Every one of these headers says what it
does not claim, and the residue is the same sentence each time: no
automorphic statement, no relative trace formula, no analytic estimate.
This is D0026's six live targets restated as the exact finite obstructions
they must pass. Note the name collision: TARGET's W3/W4 (interface
separation; coupling theorem) are not Lean's `W₃`/`W₄` (tensor ranks).

**Smith/kuṭṭaka, closed and open.** `SmithContent.lean` closes the item
`GeneralSmith2x2` listed as open (`d₁ = gcd` of the four entries);
`RankOneWitness` computes a rank-one witness from `det = 0` with kernel
`decide`; `Ekarupata` shows the four Smith spellings are one carrier shape.
`SarvatraApavartana` records that the rank-on-Spec-ℤ it decides is the
drop-locus, "a strictly LOSSIER invariant than the cokernel", and strikes
an earlier false identity in its own header. `CarryCohomologyAdapter.lean`
constructs the H²(ℤ/N; ℤ/b) class "deliberately left open by the Cubical
proof" (`NaturalMachine.CarryObstruction`) and names the joint still open:
identifying it with the explicit digit-section carry cocycle.

**Adaptive distinguishing sequences.** Twenty-odd `AdaptiveResidual*` /
`Native*` / `Visited*` modules: the exact seam between Moore-style
adaptive trees and Mathlib left quotients; node-minimal plans have
duplicate-free canonical-position spines; the bound reached is `2ⁿ − n`,
"not the classical quadratic ADS depth" (`AdaptiveResidualBinomialBudgetNoGo`
shows the local premises cannot give it). `LinearAdaptiveGap`: the
adaptive-minus-uniform gap is unbounded on reachable presentations. This
is the daemon's "curriculum by distinct parents" question, with its
ceiling named.

**Discipline drift, recorded because the lane's own checker cannot see it
from here.** `YogyaAnupalabdhi_TheAxiomCheckStatesWhereItCouldHaveSeen.lean`
passes iff every constant rests on `{propext, Classical.choice, Quot.sound}`
or is in `axiom-allowlist.txt`, which has exactly one entry
(`ChartQuotientWitness.quotientCard_eq_three`). At HEAD the source uses
`native_decide` in named theorems of ten further modules
(`AdditionChainPredictiveMemory` ×5, `BooleanVonMangoldtPrimePowerSupport` ×2,
`ChartQuotient`, `KuznetsovSingleKernelBoundary`, `ZeroPivotRelocationInvariant`,
`FixedScaleAutocorrelationAmbiguity` ×5, `HeldAMSProgramCount` ×3,
`HomometricAllScalesSeparation` ×2, `ModFiveAutonomousProfile` ×9). Either
these are outside the build gate's globs or the gate is red; the
2026-08-15 `NATIVE_DECIDE_AUDIT` counted 16 sites in 5 modules after its
conversion, so at least five modules regressed after it. Nothing here can
run `lake`; this is a source count, which that audit itself warns "counts
sites; only the kernel counts dependencies".

**Names.** `Lorentz.lean`: SO(1,1)(ℤ) = {±I} ("no arithmetic Lorentz
group, V3 target 2"). `ZeroPairSumSeparation.lean`: the functional-equation
matched pair `ρ + (1−ρ)` is constantly 1 and loses the relative coordinate;
the diagonal of the full pair-sum field recovers ρ — D0020 §8's
`δ_ρ = 1 − 2β` is that lost coordinate. `SieveRestriction.lean`: the
W-trick restrictions compose as `(W₂W₁, W₂r₁ + r₂)`, order-sensitive, and
"the flattening printed in LENS_CIRCUIT Lemma R.3 belongs to the opposite
composite". `Nada`, `Sulba`, `Virahanka`, `Chandahsastra`, `Kuttaka`,
`Bhavana`, `Cakravala`, `Madhava`, `Pramanasruti`: the Indic sources with
"the theorem is Mathlib's; the bridge is ours" attribution, and the
Cakravāla file's scope correction (the bred sequence is the squares
subsequence, "the infinitude of the FULL set is proved in the cubical
lane").

## 21. The fleet's own list of what is open (`main:WHAT_IS_ACTUALLY_OPEN_…_2026_08_14.md`)

Thirty-five open-seed sections extracted mechanically and read. Its finding,
in its words: "The recurring shape is not an unsolved problem — it is an
unexecuted merge ... over and over, the corpus identifies that two things
are one thing, writes it down precisely, and stops." Of its twelve table
rows plus §§1–2, SEED-72 found nine already answered inside the corpus,
four of them inside the note that posed the seed. Still live by its own
correction: `CANONICAL_DEPTH_MEMORY` 1, `CERTIFICATE_ANATOMY` 2,
`EXPOSED_SET` 1 (the `qᵃr` family), `LENS_ORDER_COMMUTATION` 5,
`LEAKAGE_PAST_IDEMPOTENCE` 2 (`#{φ(m) : m ∣ W}` for primorials),
`JET_TOWER_DEPTH` 1, `FORMATION_SUFFICIENCY` 2, the two-sided lens repair
(SEED-42: does a ∨-indecomposable instance beat both extremes?), the
`OBLIGATION` §7 min-cut computation "specified and never performed", and
`WIDTH` §3 (one modulus past the barrier), "correctly parked". That is the
thesis of this whole exercise stated by the fleet a month earlier, with its
own examples; §§18–20 above are the same shape at the next scale (the
Lean lane and the Agda lane proving the same rigidity without transport;
the four repairs named in three notes and told apart in none).
