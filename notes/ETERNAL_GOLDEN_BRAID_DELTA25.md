# Eternal Golden Braid Delta 25 — the Braid weaves Indra's Net

**Landing record, cf-indra, 2026-08-14.** Delta 25 arrived from the owner as a
founding-synthesis document ("The Eternal Golden Braid Weaves Indra's Net",
2026-08-13). This note is the condensed inheritance: the exact content, the
mature mathematics it names, what was formalized on landing, and what remains
queued. It is deliberately shorter than the received text; the compression
criterion is PEM §2 — keep what survives when the metaphor is erased.

Companion: `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md` (the diachronic side);
formalization in `formal/cubical/IndraNet.agda` (this delta),
`formal/cubical/LawvereDiagonal.agda`, `formal/cubical/AchromaticToy.agda`
(Delta 24).

## 1. The reclassification

Braid ≠ Net. The Braid is diachronic — the generative process by which
perspectives arise, compare, transport, tear, and force higher stages. The Net
is synchronic — the simultaneous relational whole in which every jewel is
situated by, and reflects, the entire field. Exact reading:

- Braid ~ initial/algebraic generation (μF): finite constructor histories.
- Net ~ final/coalgebraic unfolding (νF): infinite mutual reflection.
- The canonical map μF → νF is neither injective (many histories weave
  bisimilar jewels — cf. the Γ₀ rigidity "one type presented twice") nor
  surjective (behaviors with no finite weave). μ ≃ ν occurs only in
  algebraically compact/guarded settings — worlds with approximation built in.
- The received Delta 24 formula U₂ = Σ_{x:U} Φ(x) is re-read: the fiber Φ(x)
  is not a reflection *obligation* but the whole net rooted at x; U₂ is the
  Grothendieck-style total space of rooted views.

## 2. The mature mathematics it names (inheritance, not invention)

- **Yoneda**: a jewel's identity is its total reflection profile;
  Map(x,y) ≃ Nat(y(x), y(y)). **Co-Yoneda/density**: the whole is a colimit
  of representables. End = simultaneous mutual constraint (Net); coend =
  gluing along incidence (Braid); Yoneda is the statement that the two
  presentations agree.
- **Rooted vs unrooted**: Root(𝓘) = Σ_x RootView(x); rooted views are
  presentations of one global object, equivalent only along automorphisms.
- **Guarded domain equation** (replacing impredicative self-containment):
  J_x ≃ L_x × ▷ ∏_y Image_xy(J_y). Note the received text's index tension:
  jewels are declared scale-relative, so the index type itself is
  stage-relative — the final coalgebra must be taken in a sliding/fibred
  setting (clocked guarded TT); no single global νF.
- **Propagation**: a proved equivalence updates every rooted profile by
  transport/naturality (no broadcast); a separator's tear is likewise visible
  from every jewel reaching both sides. The corpus's own exp27 history is an
  instance in the tear direction.
- **Discipline against overclaim**: interpenetration ≠ universal sameness
  (identity in νF is bisimilarity; distinction is witnessed apartness);
  holography only in the disciplined sense (profile determines the jewel;
  no internal enumeration of one's own profile — the Lawvere guard).

## 3. Formalized on landing (`formal/cubical/IndraNet.agda`, exit 0 standalone)

- **T25.A** Yoneda jewel theorem, univalent-groupoid case:
  ((z : A) → z ≡ x → z ≡ y) ≃ (x ≡ y), and `profileContractsToJewel`:
  the profile's total space is contractible onto the jewel — "all in one" is
  `isContrSingl`, literally.
- **T25.B** Rooted total space: Root = Σ, fiber over x ≃ Φ x (HoTT 4.8.1,
  inherited via the library's `fiberEquiv`).
- **T25.F** Propagation: `threadUpdatesProfiles` (post-composition
  equivalence), `viewTransport` (`substEquiv`), `tearVisibleEverywhere`.
- **T25.D** (guardedness form; v0.5 has no ▷): coinductive
  `Net x = L x × ((y : J) → Net y)` with productivity (`weave`), the solved
  domain equation (`netUnfold`), and the path principle `bisim→path` —
  identity in the Net is relational identity, as a term.

Toolchain scope: checked standalone exit 0 under Agda 2.6.3 + cubical v0.5;
the aggregate remains red for the pre-existing fb8783f README/BUILD toolchain
contradiction, which this landing does not resolve.

## 4. Queue

- `PROVE` T25.C (co-Yoneda weave in a real categorical setting), T25.E
  (whether the original three-lens cycle carries braided/YB coherence — do
  not infer from the word "braid"), T25.G (totalization vs colimit
  information loss beyond the toy), T25.H (prime-pair section approximants:
  local theorem objects in additive/charge/spectral/formal views, exact
  gluing defects).
- `SEARCH` the original full EGB artifact (Delta 24 §19.A, still open).
- Connection to the live program, recorded as a direction: Delta 25 §18 reads
  Θ as a global section over the perspective site, with the gluing defect as
  the object of interest — against this corpus that is the observation that
  the circle method's minor-arc contribution is an un-objectified descent
  defect (singular series = local densities gluing on major arcs). Whether
  that reading survives contact with `BARRIER.md`'s taxonomy (WL vs
  functional-equation access) is a real question, not a result.

## 5. Rigor boundary

Proved: everything in §3 (checked terms). Inherited-known: Yoneda, co-Yoneda,
Rezk completion, fiber equivalence, guarded/coinductive semantics. Direction,
not results: §1's span reading of the persistent object, §4's minor-arc
remark, and every Huayan correspondence — exact analogues, never proofs of
metaphysics. The received document's full text remains with the owner;
nothing in it is promoted to corpus authority by this landing beyond what §3
checks.
