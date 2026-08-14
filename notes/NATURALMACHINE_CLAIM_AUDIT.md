# Breaker audit: prose claims vs. checked content in `formal/cubical/`

**Auditor role**: hostile breaker, per collab tradition. Scope: every comment-level
claim in `formal/cubical/NaturalMachine/*.agda`, `NaturalMachine.agda`,
`ProjectionChargeAudit.agda`, checked against what the type-checker actually
certified. No Python, no numerics. Date: 2026-08-13.

**Sweep result**: all 19 modules type-check (`agda` 2.6.3, `LC_ALL=C.UTF-8`,
loop over `NaturalMachine/*.agda NaturalMachine.agda ProjectionChargeAudit.agda`):
**all green, zero failures**. Independently:
`NaturalMachine/Control/WrongEquivalence.agda` **fails** to check with exactly the
error quoted in `notes/NATURAL_MACHINE.md:524-526` (`Unit !=< (Canonical w)` at
37,63-65), re-verified today. The designed-annihilation control is live.

**Verdict key**
- **PROVED** — the prose claim names a checked theorem whose statement matches the prose.
- **DEFINED-ONLY** — the prose describes definitions/data; no theorem certifies the claim.
- **OVERSTATED** — the checked content is strictly weaker than the prose; missing obligation named.
- **VACUOUS** — `refl` on definitionally-equal terms or literals, presented as if it were content.

**Totals: 84 claims audited — 61 PROVED, 8 DEFINED-ONLY, 9 OVERSTATED, 6 VACUOUS.**

---

## 1. `NaturalMachine.agda` (umbrella)

| # | Claim (location) | Status | Evidence |
|---|---|---|---|
| 1 | "all checked, no postulates, no holes, --safe" (:13) | PROVED | grep: zero postulates/holes in corpus; every `NaturalMachine/` module carries `--safe`. Caveat below. |
| 2 | `pathIsSymmetry : (X ≡ X) ≃ (X ≃ X)` (:15) | PROVED | PathIsSymmetry.agda:54 — though it is literally `univalence` re-exported; the content is the library's, honestly framed. |
| 3 | `ΩGroup≃Symmetric` a group isomorphism (:16-18) | PROVED | PathIsSymmetry.agda:97-104; hom law from `pathToEquiv-∙` (real J-proof, :70-76). |
| 4 | `ℕ-algebra-Aut-trivial` / `swap01-≢-id` rigidity contrast (:20-23) | PROVED | PathIsSymmetry.agda:125-146. |
| 5 | "Three presentations... equivalences CONSTRUCTED" (:24-27) | PROVED | FreeMonoid.agda:61 (`ℕ≃Tally`), Digits.agda:309 (`ℕ≃CanWord`), both via real round trips. |
| 6 | `transport-+-is-⊕` / monoids EQUAL by SIP (:29-33) | PROVED | Transport.agda:260-265, 274-276. |
| 7 | `chartSymmetry`: "commuting involutions... (Klein four)" (:35-40) | OVERSTATED | See Endian row 3 — no Klein-four group object, pairwise distinctness not landed. Components all proved. |
| 8 | "ℕ is π₀ of FinSet" (:42-44) | OVERSTATED | What is checked is `card≡MereEq` (Decategorification.agda:78) — the fiberwise biimplication. The π₀ statement itself, `ℕ ≃ ∥ FinSet ℓ-zero ∥₀`, is **nowhere stated**. See gap G3. |
| 9 | Controls: canonicity load-bearing, big-endian refuted, wrong equivalence fails to check (:46-49) | PROVED | Controls.agda:54-65, 76-82; WrongEquivalence failure re-verified 2026-08-13. But see §7 row 3 for a false prose claim inside Controls itself. |
| 10 | `base2-is-2`, `base10-is-10` "the module parameter really is the base offset" (:94-99) | VACUOUS | Both are `refl` on literals (`suc (suc 0) ≡ 2`). Honestly labeled "Sanity"; zero content beyond the definition of `b`. |

*Row 7 RESOLVED 2026-08-13* — pairwise distinctness landed in Endian (see G5); headline 5 reworded to disclaim the group object. *Row 8 RESOLVED* — `ℕ≃π₀FinSet` landed (see G3); headline 6 now names it. *Row 10 DOWNGRADED comment* — the "Sanity" note now says explicitly: definitional only, `refl` on literals, nothing beyond the definition of `b`.

**Caveat on row 1**: the umbrella does **not** import `CapabilityGraph`,
`SymmetryEnumeration`, or `LawfulContinuationCore` (imports: NaturalMachine.agda:57-71).
Three corpus modules live outside the aggregated build; the sweep catches them, the
umbrella's "HEADLINE" framing silently excludes them. And `ProjectionChargeAudit.agda`
— cited by Endian.agda:13 as the descent-obstruction precedent — is the **only file in
the corpus without `--safe`** (line 1: `--cubical --guardedness` only).

## 2. `PathIsSymmetry.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "univalence supplies the equivalence... group isomorphism, checked" (:8-12) | PROVED | :54, :97-100. |
| 2 | "Proved by path induction on the second path, so nothing is asserted" (:66-68) | PROVED | :70-76, genuine `J`. |
| 3 | Universe-level honesty: Ω lives at `ℓ-suc ℓ`, "isomorphic but not literally equal" (:79-81) | PROVED | Accurate; `ΩGroup : Group (ℓ-suc ℓ)` at :82. Model prose. |
| 4 | swap01 nontrivial automorphism; algebra rigid (:18-21) | PROVED | :111-151. |

Clean module. No findings.

## 3. `FreeMonoid.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "equivalence is constructed (not asserted)" (:9-10) | PROVED | :45-62, real round trips. |
| 2 | "concatenation is literally the transport of addition" (:10-12) | PROVED | `transport-+-is-++` :86-91. |
| 3 | "the two monoids are EQUAL, not merely isomorphic" (:12-13) | PROVED | `ℕ-Monoid≡Tally-Monoid` :118-119 via `MonoidPath`. |
| 4 | "the underlying type path is the one we started from" (:121-123) | PROVED | `refl` at :123 — definitional, but it is a genuine computation fact about `MonoidPath`, presented as sanity. |

Clean module.

## 4. `Digits.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "Nothing is identified by fiat... the two round trips are proved" (:13-16) | PROVED | `value-digits` :197-199, `digits-value` :295-297. |
| 2 | "`value-sucw` is the statement that the odometer computes the successor" (:16-17) | PROVED | :143-146, real induction through the carry certificate. |
| 3 | "`value` is injective on canonical words... makes the second round trip free" (:202-205) | PROVED | `value-inj` :280-292 via `digit-split` (real uniqueness-of-division proof :209-258). |

Clean module. This is the load-bearing mathematics of the development and it is
actually there.

## 5. `Endian.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | D, E involutions; commute (:9-11) | PROVED | :95-96, :86-88, :103-107. |
| 2 | "NEITHER descends along the value map" (:11-13) | PROVED | `noRevDescent` :191-202, `noCompDescent` :209-220 — genuine obstruction witnesses. |
| 3 | "The four elements are pairwise distinct: the action is faithful" (:111) | OVERSTATED | Only `D≢id`, `E≢id`, `DE≢id` are landed (:131-138). Pairwise distinctness of {id, D, E, DE} needs D≠E, D≠DE, E≠DE — none stated. "Faithful" has no formal referent: no group hom K₄ → (Word → Word) is constructed, so there is no kernel to be trivial. The three missing inequalities follow in ~5 lines from checked lemmas (e.g. D=E would give DE = D∘D = id contra `DE≢id`), but that argument is in nobody's file. |
| 4 | Neither symmetry preserves canonicity (:141-143) | PROVED | :148-159. |
| 5 | "E commutes with π; D does not; D exchanges π with ς" — "DIGIT_CRYSTAL Thm 4.2's boxed intertwiner, proved here at word level" (:18-21, :244-246) | PROVED | `π-compw` :257-260, `noRevπEquivariance` :269-270, `π-rev` :246-248, `ς-rev` :250-253. |
| 6 | "The profinite statements of DIGIT_CRYSTAL §4.3 are NOT formalized here" (:23-25) | PROVED | Honest negative disclosure. Model prose. |
| 7 | `ChartSymmetry` "Summary object: the Klein four data, packaged" (:273-276) | DEFINED-ONLY | The record packages eleven proved fields (:290-303), but "Klein four" remains a label: no `Group` instance, no statement that the generated subgroup has order 4. |

*Row 3 RESOLVED 2026-08-13 via `D≢E`/`DE≢D`/`DE≢E`* (see G5); *row 7 partially addressed*: the record now carries all six inequalities (fourteen fields) and its header explicitly disclaims the missing `Group` instance.

## 6. `Transport.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "`_⊕_` ... defined NATIVELY (ripple carry) — emphatically not `digits(value _ + value _)`" (:8-11) | PROVED | By inspection: `addw` :111-118 recurses on digit columns with `addDigitΣ` certificates; `value` appears nowhere in its definition. |
| 2 | "transporting ℕ's addition along `ua` yields literally the schoolbook algorithm" (:12-14) | PROVED | `transport-+-is-⊕` :260-268. |
| 3 | "the two monoids are EQUAL, via SIP, not merely isomorphic" (:14-17) | PROVED | :274-276. |
| 4 | "monoid laws for ⊕ are not re-proved by hand: inherited from ℕ through injectivity of value" (:19-21) | PROVED | ⊕-assoc/idr/idl :231-243 all via `valueC-inj`. Claim matches proof method exactly. |

Clean module.

## 7. `Controls.agda` and `Control/WrongEquivalence.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | C1 "canonicity is LOAD-BEARING: without it value is not injective... Proved, not asserted" (:11-13) | PROVED | `value-not-injective-on-Word` :54-57, `no-raw-round-trip` :61-65. |
| 2 | C2 big-endian misreading fails round trip, "machine-checked" (:15-18) | PROVED | :76-82. |
| 3 | **"So `ℕ ≃ Word` is false"** (:51, Controls C1 header; repeated at WrongEquivalence.agda:9-13 "That statement is false — Controls.C1 proves it false"; and notes/NATURAL_MACHINE.md:508) | OVERSTATED — **and mathematically false** | C1 proves that `value` is not injective, i.e. that the *specific pair* `(digits, value)` is not an equivalence. But the bare statement `ℕ ≃ Word` is **true**: `Word = List (Fin b)` with `b ≥ 2` is a countable, constructively enumerable type, and an equivalence `ℕ ≃ List (Fin b)` is provable in cubical Agda (e.g. shifted-base bijective numeration). No theorem `¬ (ℕ ≃ Word)` exists in the corpus, and none can. What C1 supports: "the chart map `value` is not an equivalence, so `ℕ ≃ CanWord` is not a formality." The prose asserts the false statement `¬ (ℕ ≃ Word)` as *proved*. |
| 4 | C3 "It must FAIL to type-check... verbatim error quoted in the note" (:20-24, WrongEquivalence:6-17) | PROVED | Re-run 2026-08-13: fails at 37,63-65 with `Unit !=< (Canonical w)`, byte-identical to notes/NATURAL_MACHINE.md:524-526. |
| 5 | "every module carries --safe" (:26-27) | PROVED (scope caveat) | True of every `NaturalMachine/` module. `ProjectionChargeAudit.agda` in the same directory tree does not carry it (see §14). |

## 8. `CountedExecution.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "The successor equation computes by reduction" (:8-9) | VACUOUS | `run-suc = refl` (:16) restates the second defining clause of `run` (:12). It is honest about being definitional, but as a named theorem it certifies nothing the definition doesn't already say. |
| 2 | "A map... is valid exactly when it preserves the seed and commutes with one step. Then it commutes with every counted execution" (:18-19) | PROVED | `compile` :20-28, real induction. (Note: prose says "exactly when" — an iff — but only the ⇐ direction is a theorem; the ⇒ direction is trivially the instantiation at 0 and 1 and is not stated. Minor.) |

*Row 1 DOWNGRADED comment 2026-08-13* — `run-suc` now labeled "Definitional sanity only... not a theorem beyond the definition". *Row 2 DOWNGRADED comment* — "exactly when" weakened to "when", with an explicit note that the converse is not stated (it would hold only on reachable states). Exit 0.

## 9. `SmithPathCountedExecution.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "the already-verified matrices... exact certificates Up and Uq from notes/SMITH_PATH_HOLONOMY.md" (:12-14, :33-34) | DEFINED-ONLY | The entries match the note's LaTeX (SMITH_PATH_HOLONOMY.md:57-58) — a transcription. **Nothing in the formal corpus verifies they are Smith certificates**: the module's `Z`/`Mat3` (:15-27) have *no multiplication defined at all*, `diag(2,3,2)` is never written down as a matrix, and the right transforms Vp, Vq are not even stored. "Already-verified" means "verified outside Agda, in a note". |
| 2 | "In the coordinates coker(diag(1,2,6)), these are (0,0,1) and (0,1,4)" (:48-49); `transportedClass` (:78-84) | DEFINED-ONLY | `FiberClass` is a 2-constructor enum whose names *encode* the claim; `transportedClass` is a hand-coded 6-entry lookup table. No cokernel, no group action, no computation connects `c014` to `(0,1,4)`. |
| 3 | "CountedExecution computes both schedules to the same Smith endpoint" (:100) | VACUOUS | `same-endpoint-at-two = refl` (:102): a two-step closed computation over the hand-coded `endpoint` table. The "Smith" in the sentence is nominal — the checker verified that two lookup tables agree at index 2, which was arranged by construction. Same for `p-action-at-two`, `q-action-at-two` (:105-109). |
| 4 | "no endpoint-only observation can reproduce both transported classes... the precise boundary on compiling a Smith schedule to its normal diagonal" (:124-129) | OVERSTATED | `no-endpoint-only-readout` (:126-132) is genuinely proved — but about the toy: any `read : Diagonal → FiberClass` fails to match two *hand-assigned* labels on states with equal `endpoint`. As a statement about actual Smith normal form it inherits the full unverified transcription of rows 1-2. "The precise boundary" is proved for a 6-element automaton whose semantics is fiat. See gap G1. |
| 5 | `c001≠c014`, distinctness of enum constructors (:115-120) | PROVED | Standard encode-decode; fine. |

## 10. `SmithCapability.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "The native Cubical construction already is the proof-carrying executable package... Nothing needs to be reconstructed in Python" (:22-25) | PROVED | All eight exports (:26-64) are projections of the library's `smith`. Accurate — with the honest observation that this module *proves nothing itself*; it is a 100% re-export adapter, and its comments do say so. |
| 2 | "Replay is not a test: it is a path returned by the normalizer itself" (:38) | PROVED | `replaySmith` :39-42 projects `transEq`. |
| 3 | "Native consumer joint... no external certificate decoder or untyped tuple intervenes" (:56-58) | PROVED | `withSmith` :58-64 is a CPS wrapper; the sentence describes its type accurately. What it does *not* support is CapabilityGraph's stronger "prevents" claim — see §12 row 4. |

## 11. `CountedDigits.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "adds no second evaluator and no scheduler" (:6-9) | PROVED | By inspection: only `Counted.run` applied to existing `digitsC zero`/`sucC`. |
| 2 | "Counting once executes one native carry transition. This is definitional" (:26-27) | PROVED | `run-suc` :28 — definitional and *labeled* definitional; the real content is delegated to `run-is-digitsC` (:32-34, genuine induction) and `observe-run`/`observe-step` (:37-43, via `value-digits`, `value-sucw`). |
| 3 | "an instantiation theorem, not an alternative implementation" (:31-32) | PROVED | :32-34. |
| 4 | Cost boundary: "makes no constant-cost claim... a costed execution edge remains open" (:50-54) | PROVED | Honest negative disclosure. Model prose — this is what ResidueTransport's cost section should have been (see §13). |

## 12. `CapabilityGraph.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "Cardinality is a lossy projection of that carrier" (:14-15) | DEFINED-ONLY | "Lossy" is never a theorem. The 3-line witness — two `SymmetryCapability 2` values with distinct `symmetry` (swap vs id, distinctness available as `PathIsSymmetry.swap01-≢-id`-style lemma on `Fin 2`) and definitionally equal counts — is not landed. |
| 2 | "there is intentionally no count-to-action edge" (:15) | DEFINED-ONLY | An unenforced convention: the record merely *omits* a field. No theorem says such an edge cannot exist — and none could say it in this raw form, since `SymmetryEnumeration.unrank : Fin (n !) → (Fin n ≃ Fin n)` (SymmetryEnumeration.agda:59-60) **is** a count-indexed action edge, sitting one module away. The defensible statement (the mere number `n !` does not determine an element) is never formalized. |
| 3 | "The open joint is named only by its required interface... no installed quotient carrier satisfying this exact classification law" (:37-39) | DEFINED-ONLY | Honest: `ObservationalClassCompiler` is an empty interface, and the comment says so. This is how to write an open obligation. |
| 4 | "Smith is already a closed native producer/consumer joint: the dependent eliminator **prevents** a consumer from receiving a normal matrix without its replay, invertibility, and normality witnesses" (:48-50) | OVERSTATED | False as an enforcement claim. `SmithCapability` **publicly exports** `normalMatrix : Mat m n → Mat m n` (SmithCapability.agda:29-30), plus bare `leftTransform`/`rightTransform`. Any consumer takes the normal matrix witness-free with one function call. `withSmith` is an optional convenience, not a boundary; nothing is prevented. (`smithPipeline = withSmith` at :51 is a pure rename adding nothing.) The missing obligation is not a theorem but an abstraction boundary: make the unbundled projections `private`, or delete the word "prevents". |

*Row 4 RESOLVED 2026-08-13 via comment rewrite* (see G4).

## 13. `ResidueTransport.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "deliberately contains no second arithmetic engine" (:6-7) | PROVED | By inspection: only `valueC`/`digitsC` composition. |
| 2 | "replay reduces to the already-proved odometer round trip" (:9) | PROVED | `compile-generated` :39-41 is `cong observe (value-digits n)`; `value-digits` (Digits.agda:197-199) is proved by induction through `value-sucw`, the odometer correctness. Claim is exact. |
| 3 | "Compilation is injective: the atomic zero/successor chart loses no established capability" (:44-45) | PROVED | `compile-injective` :45-51, real proof. |
| 4 | "Transport preserves the declared complexity profile; atomic counted time does not collapse any component to one or zero" (:89-90) | VACUOUS | `complexity-preserved = refl , refl , refl , refl` (:96) — because `compileCosted` (:80-87) is *defined* to copy the four ℕ fields verbatim. The "theorem" certifies that a record copy is a copy. Moreover the cost fields are free-floating: **no law ties `stateSize`/`updateCost` to the function `observe`**, so "the declared complexity profile" is unconstrained decoration. A false declaration transports just as faithfully. |
| 5 | Cost boundary header: "Existing exact bounds enter as data and remain visible after transport; this module does not manufacture or erase them" (:57-59) | PROVED | Accurate description of rows 4's *definition* — the honest half of the same coin. The dishonest half is presenting :91-96 as a named theorem. |

*Row 4 RESOLVED 2026-08-13 via deletion of `complexity-preserved`* (see G6).

## 14. `ProjectionChargeAudit.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "The smallest positive example: local coordinate plus total charge" — `localChargeEquiv` (:14, :40-41) | PROVED | Finite exhaustive case check :28-38. |
| 2 | "Minimal negative descent example... charge is the original Boolean value" — `noChargeDescent` (:43-46, :55-62) | PROVED | Real quotient obstruction via `eq/`. |
| 3 | (implicit, via corpus headline "--safe") | OVERSTATED | Only file in the audited corpus **without `--safe`** (:1). It would almost certainly accept the flag; until it carries it, the corpus-wide "no postulates, --safe" hygiene claim has a hole exactly at the module the Endian header cites as its methodological precedent. |

*Row 3 RESOLVED (verified in-tree 2026-08-13)* — the file now carries `--safe` (see G8).

## 15. `Decategorification.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "What this module checks is that the collapse is **exactly** a π₀ statement" (:9-15) | OVERSTATED | Checked: `card-invariant` (:67-68, = `cong card`), `fibre-connected` (:70-74), `card-Fin` (:60-61), `card≡MereEq` (:78-82). Not checked: the π₀ statement itself, `ℕ ≃ ∥ FinSet ℓ-zero ∥₀`. The three bullets are the fiberwise ingredients; the set-truncation equivalence — the thing "ℕ is π₀ of FinSet" *means* — is never assembled. See gap G3. |
| 2 | `card-Fin : card (𝔽 n) ≡ n` "every n is hit" (:14) | VACUOUS | `refl` (:61): `card` on this witness computes to `n` by definition of `isFinSetFinℕ`. As surjectivity evidence it is legitimate but purely definitional. |
| 3 | "what the collapse throws away is exactly the loop space: FinSetLoop≃Sym" (:16-19) | PROVED | :93-94. |
| 4 | "only the Type-level version is packaged as a group here" (:96-98) | PROVED | Honest scope disclosure; `ΩFin≃Symₙ` :99-100. |
| 5 | "The first carries no information, the second carries n! of it" (:21-23) | DEFINED-ONLY | Rhetoric; the n! count is proved, but "carries no information" (contractibility/propositionality of the relevant identification data) is not a stated theorem. Harmless flourish. |

*Row 1 RESOLVED 2026-08-13 via `ℕ≃π₀FinSet`* (see G3). *Row 2 upgraded as a side effect*: `card-Fin` is now load-bearing — it is the retract half of `ℕ≃π₀FinSet`'s round trip, no longer mere definitional decoration.

## 16. `SymmetryCardinality.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "this adapter compiles its size to the **fast arithmetic certificate** n!" (:17-18) | OVERSTATED (adjective only) | `symmetryCount≡factorial` (:32-33) is a genuine propositional equality via library `cardAut` — PROVED. But "fast" is an unbacked performance adjective: `_!_` is the naive recursive factorial, and no cost theorem exists anywhere in the corpus (CountedDigits.agda:50-54 explicitly says so). Under this repo's CLAUDE.md, an underivable speed claim is exactly the class of assertion the protocol bans. Delete the adjective or derive a cost model. |
| 2 | "propositionally, not definitionally, equal for a variable argument" (:25-27) | PROVED | `factorial≡!` :28-30; the definitional/propositional distinction is stated correctly (base case is `refl`, step needs `cong`). |

*Row 1 RESOLVED 2026-08-13 — "fast" deleted, no-speed-claim disclosure added* (see G7).

## 17. `SymmetryEnumeration.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "upgrades the count to a checked enumeration... backward map generates the permutation at any index" (:9-19) | PROVED | `symmetryEnum` :49-52 (library composite + `subst` along `factorial≡!`); `unrank` :59-60. |
| 2 | "exhaustive... and irredundant... for free from the equivalence structure" (:62-64) | PROVED | :65-69. |
| 3 | "the loop space at the classifying point is enumerated" (:72-79) | PROVED | `loopEnum` :82-83. |
| 4 | "the subst in symmetryEnum blocks definitional computation, so they are proved propositionally" (:90-93) | PROVED | Honest; :95-105. |

Clean module. Note: not imported by the umbrella `NaturalMachine.agda`.

## 18. `SymmetryArithmeticAction.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "Composition of symmetries is executable composition on registers" (:20) | PROVED | :21-25 — `refl`, but definitional-by-mathematics (precomposition), not by arrangement; acceptable. |
| 2 | "Path composition is sent to the same executable composition law" (:31) | PROVED | :32-38, real proof through `pathToEquiv-∙`. |
| 3 | "The policy distinction is checked, not prose" (:44-45) | PROVED (with a nick) | The distinction is carried by `transportedPortRead-invariant` (:50-55, real) and the literal evaluations `swap-fixed-value ≡ 2` vs `swap-transported-value ≡ 1` (:106-112). Nick: `fixedPortRead` (:41-42) is *definitionally identical* to `permuteRegisters` — a rename presented as a second policy; the pair of names suggests two mechanisms where there is one plus an inverse-precomposition. |
| 4 | Stabilizer closure (id, comp, inv) and `swap-not-in-successor-stabilizer` (:114-154) | PROVED | All real; `stabilizes-inv` :130-134 is a genuine funExt argument. |
| 5 | `pointwiseProduct-covariant` "merely relabels" (:73-81) | PROVED | `refl`, definitional-by-mathematics. |
| 6 | `identity-fixed-value ≡ 1` (:103-104) | VACUOUS | `refl` on literals; a worked example, harmless but content-free. |

*Row 6 DOWNGRADED comment 2026-08-13* — now labeled "Worked example, definitional only (`refl` on literals)". Exit 0.

## 19. `LawfulContinuationCore.agda`

| # | Claim | Status | Evidence |
|---|---|---|---|
| 1 | "Fiber shapes are evidence, not an assumed global trichotomy" (:38) | PROVED | The three shapes are separate types (:41-48); `unique-not-branching` :50-53. |
| 2 | "every local fiber is inhabited (and has two points), but the loop transport flips them, so no coherent section exists" (:104-105) | PROVED | :112-121; `flip-has-no-coherent-section` via `not≢const` is a real holonomy obstruction. |
| 3 | "The displayed finite evidence at L = 6 uses only reduction of mod; no equality decision is assumed elsewhere" (:124-127) | PROVED | `four-at-six`/`five-at-six` :132-136 are `snotz` on reduced literals; accurate. |
| 4 | `modulusWorld`, `CountedPath`, `install-*` (:144-153) | DEFINED-ONLY | Data and two inhabitants; no theorem about the world (e.g. that the two installs at 6 are distinct *as counted paths* is not stated — only the moduli are distinguished, :138-142). |

Module not imported by the umbrella.

---

## Ranked worst gaps

**G1 — `SmithPathCountedExecution`: the "Smith" content is transcription, not
verification.** (§9 rows 1-4.) The module defines `Z` and `Mat3` with **no
multiplication**, so it *could not* verify anything about matrices even in
principle; `Up`, `Uq`, `endpoint`, `leftAction`, `transportedClass` are inert
lookup tables copied from a non-formal note, and the two `refl` "computation"
theorems check that tables agree with themselves. The honestly-proved
`no-endpoint-only-readout` is then advertised as "the precise boundary on
compiling a Smith schedule to its normal diagonal" — for a 6-state automaton
whose semantics is fiat. Closing theorems (all finite, all exact, no Python):
define `_⋆₃_ : Mat3 → Mat3 → Mat3` over `Z` (or reuse `SmithCapability`'s
library `Mat` and `⋆`), store `A₀ = diag(2,3,2)`, `Vp`, `Vq`, and prove
`Up ⋆₃ A₀ ⋆₃ Vp ≡ diag(1,2,6)` and `Uq ⋆₃ A₀ ⋆₃ Vq ≡ diag(1,2,6)` by `refl`
after reduction, plus derive `transportedClass q2 = c014` from the action of
`H = Uq·Up⁻¹` on `coker(diag(1,2,6))`: concretely `H ⋆₃ col(0,0,1) ≡ col(1,1,-2)`
and `(1,1,-2) ~ (0,1,4) mod (1,2,6)`. Until then every "Smith" noun in the
module's comments is borrowed collateral.

*RESOLVED 2026-08-13* via the certification section appended to
`SmithPathCountedExecution.agda` (all checked, `--safe`, exit 0): for every
state `s`, `stepCertificate s : SimRel matA0 (diagMat (endpoint s))` over the
library's `Coefficient ℤCommRing` with `transMatL` definitionally
`toMat (leftAction s)` (explicit right transforms + both-sided inverses, all
by `refl` after entrywise decomposition); `matD126-isSmithNormal :
isSmithNormal matD126` (1 ∣ 2 ∣ 6 exhibited); `pScheduleSmith qScheduleSmith :
Smith matA0` — the library producer's own type; `holonomy-factors : matH ⋆
Up ≡ Uq`, `holonomy-unimodular`, `holonomy-transports-classes` (H·(0,0,1) =
(0,1,4) + diag(1,2,6)·(1,0,-1)), and `classes-differ-in-coker` (parity
obstruction, so c001 ≢ c014 as actual cokernel classes, not enum fiat).
Remaining (blocked upstream, documented in the module): literal equality with
`smith matA0`'s output — `smith` on this concrete matrix does not reduce in
practical time and cubical v0.5 has no normal-form uniqueness theorem
(Smith/Normalization.agda:280 TODO), so the binding is to the full defining
specification (SimRel + isSmithNormal), not to the unnormalized term.

**G2 — `Controls.agda:51` / `WrongEquivalence.agda:9-13`: "`ℕ ≃ Word` is false"
is itself false.** (§7 row 3.) The corpus proves the pair `(digits, value)` is
not an equivalence; it asserts in prose that the *type* `ℕ ≃ Word` is empty and
that "Controls.C1 proves it false". `List (Fin b)` is countably infinite and
constructively enumerable, so `ℕ ≃ Word` is *provable*; `¬ (ℕ ≃ Word)` is
refutable. The single worst overstatement in the corpus: not merely unproved
but wrong, in the module whose entire purpose is epistemic hygiene, and
propagated to `notes/NATURAL_MACHINE.md:508`. Fix is one sentence: replace
"So `ℕ ≃ Word` is false" with "So `value` is not an equivalence — the *chart
map* fails, though an unrelated bijection ℕ ≃ Word of course exists." Optional
strengthening: actually construct `ℕ ≃ Word` (bijective base-b numeration) as
a control-of-the-control, making precise that canonicity rescues *this* map,
not injectivity-in-principle.

**G3 — "ℕ is π₀ of FinSet" without the π₀ theorem.** (§1 row 8, §15 row 1.)
Missing statement, closable from landed parts in ~15 lines:
`ℕ≃π₀FinSet : ℕ ≃ ∥ FinSet ℓ-zero ∥₀` — forward `∣ 𝔽 n ∣₀`, backward by
`Cubical.HITs.SetTruncation.rec isSetℕ card`, round trips from `card-Fin`
and `card≡MereEq` + `fibre-connected`. Until it exists, the headline names an
equivalence the corpus only holds fiberwise.

*RESOLVED 2026-08-13* via `ℕ≃π₀FinSet : ℕ ≃ ∥ FinSet ℓ-zero ∥₂` (Decategorification.agda, exactly the proposed assembly: forward `∣ 𝔽 n ∣₂`, backward `SetTrunc.rec isSetℕ card`, round trips `card-Fin` and `fibre-connected`); umbrella headline 6 now names it. Exit 0.

**G4 — `CapabilityGraph.agda:48-50`: "the dependent eliminator prevents a
consumer from receiving a normal matrix without... witnesses".** (§12 row 4.)
Contradicted by the same development's public export
`normalMatrix : Mat m n → Mat m n` (SmithCapability.agda:29). Nothing is
prevented. Close it structurally, not by theorem: make `normalMatrix`,
`leftTransform`, `rightTransform` `private` (or move them into a `module
Unsafe` clearly named), leaving `withSmith` as the sole exit — or rewrite the
comment to "offers a bundled consumer interface".

*RESOLVED 2026-08-13* via the second sanctioned fix: CapabilityGraph.agda:48-55 rewritten to "offers a bundled consumer interface", explicitly stating the unbundled projections remain exported and nothing is prevented ("an offered convention, not an enforced abstraction boundary"). `private` was not used because `replaySmith`'s public type mentions the projections. Exit 0.

**G5 — `Endian.agda:111`: "pairwise distinct... faithful" with 3 of 6
inequalities and no group.** (§5 row 3.) Closing statements:
`D≢E : ¬ ((w : Word) → rev w ≡ compw w)` (witness `w0`: `rev w0 ≡ w0` by
`refl`, `compw w0 ≢ w0` by `E≢id`); `DE≢D` and `DE≢E` from involutivity plus
`E≢id`/`D≢id`; or, better, build the K₄ `Group` and the hom into `Word → Word`
with a trivial-kernel proof, which is what "faithful" means.

*RESOLVED 2026-08-13* via `D≢E`, `DE≢D`, `DE≢E` landed in Endian.agda (witnesses w0, w0, w01 as proposed; DE≢E through `dcomp-involutive`), added to the `ChartSymmetry` record; the §3 header and the umbrella's headline 5 now say "pairwise distinct" (true, all six inequalities) and explicitly disclaim the K₄ group object/hom, so "faithful" no longer floats. Exit 0.

**G6 — `ResidueTransport.agda:89-96`: `complexity-preserved` is a theorem-shaped
copy of a copy.** (§13 row 4.) Either delete it (the honest header :57-59
already says everything true) or give the cost fields semantics: a cost-annotated
evaluation judgment `Eval : Observation A → ℕ → A → ℕ → Type` with
`observes-within : (s : CostedObservation A) → ∀ n → Σ a (Eval (observe s) n a (updateCost s))`
— at which point preservation under `compileCosted` becomes a statement *about
computation* rather than about record syntax. As it stands, the claim "atomic
counted time does not collapse any component" is certified only against
declarations that nothing constrains.

*RESOLVED 2026-08-13* via the first prescribed fix: `complexity-preserved` deleted from ResidueTransport.agda together with its overstating comment, replaced by an explicit negative disclosure naming the missing `Eval`/`observes-within` judgment as the open joint. Exit 0.

**G7 — `SymmetryCardinality.agda:18`: "fast".** (§16 row 1.) No cost model
exists in the corpus (CountedDigits.agda:50-54 admits it). One adjective, zero
backing. Delete "fast" or install the carry-cost/arithmetic-cost theorem the
corpus already knows it lacks.

*RESOLVED 2026-08-13* — "fast" deleted from SymmetryCardinality.agda:18 and replaced with an explicit no-speed-claim disclosure (naive recursive `_!_`, no cost model, pointer to CountedDigits' cost boundary). Exit 0.

**G8 — `ProjectionChargeAudit.agda:1` lacks `--safe`; umbrella excludes three
modules.** (§1 caveat, §14 row 3.) Mechanical fixes: add `--safe` (the file
uses nothing unsafe) and add `CapabilityGraph`, `SymmetryEnumeration`,
`LawfulContinuationCore` to `NaturalMachine.agda`'s import block so the
"HEADLINE... all checked" umbrella actually covers the corpus the directory
ships.

*RESOLVED (verified in-tree 2026-08-13)* — ProjectionChargeAudit.agda:1 now carries `--safe`, and NaturalMachine.agda imports `SymmetryEnumeration` (public), `CapabilityGraph`, and `LawfulContinuationCore` (lines 65, 69-70); both fixes landed with the first-fixes commit, re-verified today, exit 0. The "not imported by the umbrella" remarks in §17 and §19 are accordingly stale.

---

## Summary judgment

The core mathematical spine — Digits, Transport, FreeMonoid, PathIsSymmetry,
Endian's obstructions, the two genuine descent refutations, the enumeration —
is real, and unusually honestly documented (CountedDigits' and Endian's
negative disclosures are the best prose in the corpus). The rot is at the
edges, and it has a pattern: **wherever a module comment reaches for a noun
from outside the file (Smith, π₀, Klein four, "prevents", "fast"), the checked
content is one or more theorems short of the noun.** Two claims cross from
overstatement into error: "`ℕ ≃ Word` is false" (provably wrong) and "the
dependent eliminator prevents" (contradicted by the adjacent export). Both are
one-line fixes. G1 is the only gap that needs actual new mathematics in Agda —
and it is finite, exact, and `refl`-closable, i.e. precisely the kind of
certified symbolic computation this repository's protocol permits.
