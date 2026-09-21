# The frontier, expressed exactly

Thesis under test: every open solution is latent composition, and expressing exactly what is unknown already yields knowledge.

## The composition

**SamastaSima.** The corpus already holds the open problems as types built from computable functions: RH as the Davisâ“Matiyasevichâ“Robinson inequality at every n â‰ 1, Goldbach as GoldbachAt at every even number, with the Goldbach fibre proved decided (KotiNirnaya). SamastaSima adds the same fact for the RH fibre and the single type that holds both:

- `rh-dec`: the RH fibre is decided; `rhb` is its Boolean, sound and complete; `DMR.RH â‰ (âˆ m. rhb (suc m) â‰¡ true)`.
- `Frontier = RH — Goldbach â‰ (âˆ n. frontierb n â‰¡ true)`: the whole typed frontier of the corpus is the section of one decided Boolean family.
- `frontier-refuted-by`: one false stage refutes it; `prefix-sound`: a prefix check certifies the first k stages.
- The kernel computed stages 0, 1, 2 (`frontierb n â¦ true`, `prefix 3 â¦ true`) and rejected the claim that stage 0 fails.

## What is now exact

The open frontier of this corpus is one object: the section `(n : â•) â’ frontierb n â‰¡ true`. Every stage is a terminating computation; the only thing open is the function inhabiting all stages at once. Refutation is finite. This is the precise shape the thesis predicts, and it was already latent in three modules nobody had joined.

The DMR fibre is decidable but its cost explodes (Î´(4) = 12 already puts the harmonic fraction beyond unary evaluation), so the kernel's oracle reaches only the first stages.
