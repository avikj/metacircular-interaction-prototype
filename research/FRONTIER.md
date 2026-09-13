# The frontier, expressed exactly

Thesis under test: every open solution is latent composition, and expressing exactly what is unknown already yields knowledge.

## Two attempts, one kept

**Attempt 1 (Sima, kept only as a shape).** The six RH routes of the handoff were abstracted into propositions with the received conditional theorems as hypotheses, and cubical Agda proved them all equivalent to RH. That is a tautology in a costume: it composes names, not objects, and the "transport" moves nothing. It is left in the tree as the statement of the route structure, and nothing more.

**Attempt 2 (SamastaSima, the actual composition).** The corpus already holds the open problems as types built from computable functions: RH as the Davis–Matiyasevich–Robinson inequality at every n ≥ 1, Goldbach as GoldbachAt at every even number, with the Goldbach fibre proved decided (KotiNirnaya). What was missing was the same fact for the RH fibre and the single type that holds both. Now:

- `rh-dec`: the RH fibre is decided; `rhb` is its Boolean, sound and complete; `DMR.RH ≃ (∀ m. rhb (suc m) ≡ true)`.
- `Frontier = RH × Goldbach ≃ (∀ n. frontierb n ≡ true)`: the whole typed frontier of the corpus is the section of one decided Boolean family.
- `frontier-refuted-by`: one false stage refutes it; `prefix-sound`: a prefix check certifies the first k stages.
- The kernel computed stages 0, 1, 2 (`frontierb n ↦ true`, `prefix 3 ↦ true`) and rejected the claim that stage 0 fails.

## What is now exact

The open frontier of this corpus is one object: the section `(n : ℕ) → frontierb n ≡ true`. Every stage is a terminating computation; the only thing open is the function inhabiting all stages at once. Refutation is finite. This is the precise shape the thesis predicts, and it was already latent in three modules nobody had joined.

## What this does not do

It does not inhabit the section. The DMR fibre is decidable but its cost explodes (δ(4) = 12 already puts the harmonic fraction beyond unary evaluation), so the kernel's oracle reaches only the first stages. The equivalence of the DMR inequality with the zeta zeros is classical and cited, not formalized. NS has no computable-fibre form in the corpus; its frontier stays the abstract chain of Sima's second half. No endpoint status changes.
