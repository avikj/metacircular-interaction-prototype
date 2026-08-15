# Theorem B, Cor B.1, Cor B.2 formalized: determination is a property of the span set

*Claude, 2026-08-15. Sibling term to `StagewiseComposite.agda` (Theorem A).
Note: `notes/STAGEWISE_DETERMINES_COMPOSITE.md`. New file:
`formal/cubical/StagewiseCompositeB.agda`, `--cubical --safe`, no postulates,
no holes, `LC_ALL=C.UTF-8 agda StagewiseCompositeB.agda` → **EXIT=0**.*

## What was formalized, and the definition that carries the content

The relativisation comes first, because it *is* the theorem. A **span set**
is an arbitrary predicate `T : R → R → R → Type ℓ'` — the spans a given
composable pair actually realizes — and

```agda
DeterminesOn R d T =
  Σ[ f ∈ (Bool → Bool → Bool) ]
    ((a b c : R) → T a b c → f (ind d a b) (ind d b c) ≡ ind d a c)
```

The decoder is required to be correct *only where the span is realized*; no
default is imposed on unreachable summaries (the note's §6 convention).
`Determines` of the existing module is exactly the case `T = Total`, and both
translations are proved (`determinesOnTotal→Determines`,
`determines→DeterminesOnTotal`), together with monotonicity in `T`
(`restrictDeterminesOn`). The two cells are `Cancellation` (`a≢b, b≢c, a≡c`)
and `Persistence` (`a≢b, b≢c, a≢c`), as Σ-types of a realized witness.

**Theorem B.**
- `both→¬DeterminesOn` — both cells realized ⇒ no decoder. The two witnesses
  collide at the single argument `f true true`; nothing else in `T` is read.
- `¬Cancellation→DeterminesOn` — decoder is **∨**.
- `¬Persistence→DeterminesOn` — decoder is **⊕** (Theorem A's decoder, now
  available over an arbitrary codomain because only realized spans are asked).
- `theoremB-iff` — packaged, with the hypothesis it genuinely needs written
  into the type: `Dec (Cancellation R T)`. Constructively `¬(P × Q)` does not
  split, and realizability of a cell by an arbitrary predicate is not
  decidable. The two one-sided implications are hypothesis-free and are the
  working form.

**Corollary B.1.** `Defeating R ℓ' = Σ T, Cancellation × Persistence`;
`ThreeValued R = Σ a b c, pairwise distinct` (constructive |R| ≥ 3).
- sufficiency `threeValued→Defeating`: an **explicit two-span set**
  `twoSpan a b c = {(a,b,a), (a,b,c)}` — the note's §4 table, rows I and II;
- necessity `Defeating→threeValued`: projection from the persistence cell;
- `corB1` packages them.

The pointwise half — *|R| ≥ 3 does not defeat a given pair* — is proved in
three forms: `spanwiseTwoValued→DeterminesOn` (every realized span contains a
repeat, i.e. responses land in a two-element subset), `emptyMeet→DeterminesOn`
(A ∩ B = ∅), and concretely `determinesOnOneSpan` over `Three`, whose *total*
span set is `threeIsDefeating` and for which the existing
`¬DeterminesThree` holds. Same `R`, different `T`, opposite verdicts.

## A correction to my own first draft, and to the prompt's framing

I first wrote a lemma "over a two-valued `R` neither cell is realized". The
cancellation half is **false**: over `Bool` the span `(true, false, true)`
lies in the cancellation cell. Witness `cancellationOverBool` is in the file.
So the two cells are *not* symmetric — only the **persistence** cell carries
the cardinality (`twoValued→¬Persistence`), and it alone yields
`twoValued→allDetermined`: every span set over a two-valued codomain is
determined, decoder ⊕. The note does not claim otherwise, but a reader
skimming "both cells" for a symmetry will guess wrong.

## Corollary B.2, with the abelian hypothesis carried explicitly

The note assumes `G` abelian; that is a record `AbGroupStr` in the file
(`+`, `zero`, `neg`, `assoc+`, `rid`, `rinv`, `comm+`), not an import and not
an implicit convention. Then `telescope : (b − a) + (c − b) ≡ c − a` holds
over **any** `G` — the G-valued ledger never costs anything — and
`corB2 : TwoValued G ↔ SupportDetermines G d A` shows the passage to
**supports** `1_{g≠0}` composes iff |G| ≤ 2. The defeating pair is
`(g₁, −g₁)` against `(g₁, g₂)`, exactly the note's argument.

## Scope limits

- `theoremB-iff` carries `Dec (Cancellation …)`; see above.
- B.2 is proved for `G` itself as codomain (the torsor acting on itself); the
  general torsor and the nonabelian variant the note mentions are **not**
  formalized.
- Equality defect only; tolerance relations (note §6) untouched.
- `TwoValued`/`ThreeValued` are the constructive renderings; no finiteness,
  no cardinal arithmetic anywhere.

## Verification claims, each backed by a run

- `StagewiseCompositeB.agda` → EXIT=0 (`LC_ALL=C.UTF-8`, Agda 2.6.3 + cubical
  v0.5). Container, not the BUILD.md pin.
- `StagewiseComposite.agda` re-run → EXIT=0. It was **not modified** (git
  status confirms a single modified `.agda`), so every theorem it already
  proves still checks.
- Import added to `Everything.agda` and an entry to `formal/cubical/BUILD.md`'s
  2026-08-15 OUTSTANDING list. The root aggregate's pre-existing exit 42
  (`PathIsSymmetry.agda:98`, SymGroup) is untouched and unrelated.
