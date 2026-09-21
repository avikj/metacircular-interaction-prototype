# Draft 3 — HoTT Zulip (Riehl's community; leads to the HoTT/UF abstract)

Open sign-up, no invitation. Post in a general or "formalization" stream,
one topic. The community's first reflex will be "that's HoTT book §4.8";
say it before they do. The second reflex will be "is this a P/NP claim";
quote the header before they ask.

---

> **[Topic: losslessness as a property — the completions of a machine step form a contractible type (Cubical Agda)]**
>
> For any `f : A → B`, `A ≃ Σ (b : B), fib f b` (HoTT book §4.8; in
> cubical this is a few lines with `singl`). I've been using this as the
> primitive of a small machine calculus, and the statement I'd like a
> second pair of eyes on is what happens when `f` is a *step* of the
> machine rather than an arbitrary map:
>
> ```agda
> Lossless : {A B : Type ℓ} (f : A → B) → Type (ℓ-suc ℓ)   -- a completion of f
> machine-lossless-unique : isContr (Lossless uStep)
> complete≃ : Machine ≃ Σ Machine (fiber uStep)
> verify-inverts-decide : (mc : Machine) → verify (fst (decide mc)) (snd (decide mc)) ≡ mc
> ```
>
> i.e. the completion of the universal step is unique (a property, not
> structure), and "decide" (run the step and keep the witness) and
> "verify" (project the witness back) are the two directions of one
> equivalence. Files: `Ekatva_…agda` (257 lines) and
> `VerifyIsDecide_…agda` (113 lines), both `--cubical --safe --guardedness`,
> imports `Cubical.Foundations.*` only. Agda 2.8.0 / cubical v0.9;
> `sh setup && sh check` from the repo root.
>
> What this does *not* claim, from the file header: "a step-count
> separation theorem in some external succinct measure. It claims exactly
> what its types say — over the lossless universal machine, verify and
> decide are one equivalence." I'd rather say that up front than have it
> read into the file name.
>
> Two things I'd value opinions on:
> 1. Is `isContr (Lossless uStep)` a known corollary of something in the
>    book or in agda-unimath that I should be citing instead of proving?
> 2. The coinductive continuation of this (an interactive coalgebra whose
>    answer stream is the run, with `silence-is-determinism` as a
>    sufficient condition — `Prasna_…agda`) — is there prior work on
>    "the fibre law applied to a coalgebra step" that I'm missing?
>
> Site with HTML exports: [link]. Thanks.

Notes for you: question 1 invites the correction you want (if it *is*
known, you learn the citation; if not, you have the HoTT/UF abstract).
Question 2 is the part nobody will say is textbook. Riehl herself is
unlikely to reply; her students and Shulman's circle will, and their
questions are the abstract for `drafts/08`.
