# Draft 2 — Lean Zulip (Buzzard's five-minute check)

Register first with your real name; post a two-line introduction in
`#new members` ("PhD-adjacent? / Berkeley / working on cubical Agda and a
Lean lane for arithmetic results; here to get a small formalization
looked at"). Then, a day later, ONE topic. Buzzard's stated procedure is:
definitions come from mathlib, statement matches the claim, proof
compiles. Give him exactly those three things and nothing else.

Pick the statement first. Candidates from `formal/lean/Pairfield/` that are
self-contained and whose mathlib content is recognisable:
- `Composition_TheCompositionOfTwoNormsIsANormBrahmaguptasIdentity` — Brahmagupta's identity
- (not `Cakravala_…` — both Cakravāla modules use `native_decide`)
- one of the Smith normal form modules (`SmithPresentation`, `SmithCertificate`)
- one Goldbach-boundary module *only if* its statement is plainly readable without the repository's vocabulary

Do **not** pick anything that uses `native_decide` for this first post
(`grep -l native_decide formal/lean/Pairfield/*.lean` lists them).
The Composition module's theorems are `bhavana_samasa` and `bhavana_antara`.

Stream: `#general` (or `#Is there code for X?` if the point is "does mathlib
already have this"). Topic title: the theorem, in words.

---

> **[Topic: Brahmagupta's identity as a norm-multiplicativity statement, checked against mathlib v4.33.0]**
>
> Statement (Lean 4.33, mathlib `v4.33.0`, file
> `formal/lean/Pairfield/Composition_….lean`):
>
> ```lean
> theorem <name> : <exact statement, copied, with mathlib names visible>
> ```
>
> Build:
> ```
> cd formal/lean && lake build && lake exe yogyanupalabdhi
> ```
> The second command is an axiom gate: it fails if any declaration in the
> lane depends on an axiom outside `{propext, Classical.choice, Quot.sound}`
> except those listed in `axiom-allowlist.txt` with a written reason. Output
> for this module: `[paste]`. The lane currently has one allowlisted
> `ofReduceBool` site, not in this file.
>
> Two questions: (1) does mathlib already have this in a form I should be
> reusing instead (I looked at `Mathlib/NumberTheory/Zsqrtd` and the
> quadratic-form files, and found the pieces but not the composition
> statement in this shape); (2) is the statement the one you'd want, or is
> there a more canonical phrasing?
>
> Repo: [link]. The mathematics is mine; I used Claude to transcribe it
> into Lean, checked every step with `lake build` as above, and the log of
> its transcription errors and my corrections is public in the repo.

Notes for you: the last paragraph is the disclosure Buzzard and Tao both
ask for, in one sentence, before anyone asks, and it says the true thing:
the mathematics is yours and the tool typed. Say it first so nobody
guesses wrong from the file names. If he replies "mathlib has
this, see X", that is a good outcome: you now have a thread with him, and
the next post is the lemma mathlib does *not* have. If nobody replies in
three days, post the second candidate as a new topic; do not bump.
