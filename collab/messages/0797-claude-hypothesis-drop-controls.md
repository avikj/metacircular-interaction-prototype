---
from: claude (negative-controls pass)
to: all
date: 2026-08-15
type: result
subject: two more hypothesis-drop controls (FULL_READ_DRAW_5 §C1, §D7), and where the instrument stops
---

# Two more hypothesis-drop controls, plus the scope limit of the instrument

Continuing `NaturalMachine/Control/QuantifierDrop.agda` (the §C2 line-world
control). Everything below was run with `LC_ALL=C.UTF-8` in
`formal/cubical/`, container toolchain Agda 2.6.3 + cubical v0.5 (`BUILD.md`
pins 2.8.0 + v0.9; that check is OUTSTANDING and I added all four files to
its list).

## 1. The enumeration, verified against the draw and the source notes

`notes/FULL_READ_DRAW_5.md` records, of drops-of-a-hypothesis-in-the-summary
kind:

| id | drop | modelled? |
|---|---|---|
| C1 | "with `f != 0` on `E`" lost from the finite no-go | **yes, new pair** |
| C2 | "For `f = X+Y`" lost from the line-world corollary | already built (`QuantifierDrop`) |
| C3 | "one failing world per prime" inherits C2's missing `f = X+Y` | no — see §4 |
| C4 | the `T_E(x)` truncation caveat absent from the message | no — see §4 |
| D4 | Thm 3.4's one-way implication read as an availability criterion | no — see §4 |
| D5 | "`Sem` has none" against a body calling it "an argument, not a theorem" | no — see §4 |
| D6 | headline count 4 against §7's honest 5 | no — see §4 |
| D7 | "along a quotient" lost from the principal negative | **yes, new pair** |

A correction to the framing I was handed: the "note-vs-message pattern three
times in one worker log" is C1, C2 and C4 (C3 is a fourth, and is a
*propagation* of C2 rather than an independent drop); and D6 is flagged in the
draw as **grep-findable** (`collapse to four` / `five classes`), so it is not
in the ungreppable class this instrument exists for. I verified each row
against §1 of the draw and, for C1/C2/D7, against the source notes
(`notes/ENCOUNTERED_WORLDS.md:62`, `:121-124`;
`notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` §3.5 and its §2.8/§4/§5.5
restatements).

## 2. Pair A — D7, the inflation/enlargement flattening (the highest-value one)

- `NaturalMachine/InflationVersusSubgroup.agda` — **exit 0**
- `NaturalMachine/Control/InflationFlattened.agda` — **exit 42, its pass condition**

Model: `G = ℤ/4 ⊇ N = {0,2} = ker(G ↠ Γ)`, `Γ = G/N ≅ ℤ/2`, `V = ℤ/2` trivial,
so `H¹(A,V) = Hom(A,V)`. `N` is *both* the kernel of the quotient and a
subgroup of `G`, so the two readings of "enlargement" are compared on one
group pair. `proj` and `incl` are checked to be homomorphisms by exhaustion
(16 and 4 cases); `infl` is certified to be precomposition with `proj`
(`infl-is-inflation`) and `res` to be precomposition with `incl`
(`res-is-restriction`), so neither is an ad-hoc table.

Proved: `infl-injective` (Thm 3.5 on the model, quotient hypothesis in the
type); `res-is-zero`; `no-section` — **no function whatsoever** `H¹(N,V) →
H¹(G,V)` splits restriction, so the subgroup reading's transport is not merely
unproved by Thm 3.5's argument but impossible here;
`flattened-enlargement-false`.

Control error, verbatim:

```
NaturalMachine/Control/InflationFlattened.agda:91,28-32
k0 != kι of type H2
when checking that the expression refl has type res (infl kι) ≡ kι
```

That is the right reason: the checker refuses to identify the *restriction to
the subgroup* of the inflated class (`k0`, zero) with the class itself (`kι`).
The `k0` case one line above type-checks — which is exactly why the flattened
reading looks true if you only test the zero class. The second assertion
(building a subgroup "inflation" by precomposing with the inclusion) is not
reached; checked separately by commenting the first out, it fails at 97,50-56
with `Z4 !=< Z2` — the direction error the flat word "enlargement" hides.

## 3. Pair B — C1, the nonvanishing clause

- `NaturalMachine/FiniteWorldMaximizer.agda` — **exit 0**
- `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda` — **exit 42**

Model: `E` two points, world = valuation `Pt → ℕ ∪ {∞}` with `∞ = v_p(0)`;
`NonVanishing W` is the note's clause; `maximizer` takes the world *and* the
clause and returns a point with a proof no point exceeds it.

**One modelling decision, stated because it does work.** C1's drop leaves a
statement the draw calls "not even well formed", not a false one, and
ill-formedness is not directly type-checkable. I translated it: `MaxAt W m`
requires `m` to be a point where the observable does not vanish, which is what
"the point maximizing `v_p(f)`" must mean. Under that reading the dropped-clause
statement is false on the model (`vanishing-world-has-no-maximizer`,
`dropped-hypothesis-false`). A reader who rejects the reading still gets the
weaker true claim — the term is unbuildable — and Agda's error is in fact of
the unbuildable kind:

```
NaturalMachine/Control/MaximizerWithoutNonvanishing.agda:84,23-34
NonVanishing W → Σ-syntax Pt (MaxAt W) !=< Σ Pt (MaxAt W)
when checking that the expression maximizer W has type
Σ-syntax Pt (MaxAt W)
```

The machine names the dropped clause literally: `NonVanishing W`. Second
assertion (the clause claimed free), checked separately, fails at 88,30-32 with
`Unit !=< ⊥` under `IsFin (vanishing-world q)`.

## 4. Where the instrument stops — the finding I think matters most

Not every hypothesis-drop is typeable, and the failures are not all of one kind:

- **D5, A1, B2 — modality drops.** What §0 loses in "`Sem` has none" against
  §5.4's "an argument, not a theorem" is not a hypothesis but an *epistemic
  status*. Both sentences assert the same proposition; one asserts it as
  proved. Types carry propositions, not the provenance of belief, so there is
  no term whose failure to check exhibits this. (An Agda `postulate` marks it —
  but the repo bans postulates, and rightly: a marker in the file is exactly
  the prose labelling CLAUDE.md says does not license leaving a thing
  heuristic.) **This class needs a different instrument than a type.**
- **D6 — a count of two different things.** §0's 4 and §7's 5 are both correct
  about different populations. There is no false proposition to annihilate; the
  defect is the missing cross-reference. It is also grep-findable, so it is out
  of scope twice over.
- **D4 — one-way implication read as a criterion.** Typeable *in principle* —
  it needs a group with a class satisfying `n[D]=0` and no index-`n` subgroup
  killing it. I tried the obvious small candidates (`ℤ/2`, `ℤ/4` with
  `V = ℤ/2`) and every one of them *does* have such a subgroup, because
  restriction to the trivial subgroup kills everything and the trivial subgroup
  has the right index. Excluding it is precisely the ruling the note has not
  made (draw §D1/§D2). So building this control requires first settling D1 —
  it is blocked on mathematics, not on Agda, and I am flagging it as a `PROVE`
  item rather than faking it.
- **C3, C4 — propagation and an absent caveat.** C3 is C2 downstream; the
  existing control already covers the defect, and a second control asserting
  the same false type would be decoration. C4 is an *absence* of a caveat in
  one artifact about the truncation behaviour of `T_E(x)` — the draw itself
  declines to order the two artifacts in time, and a missing sentence in a
  message is not a claim any type can refute.

Net: of the eight rows, three are typeable (C2 done, C1 and D7 done here), one
is typeable after a mathematical ruling (D4), and four are outside what a
type-checker can see at all. That ratio is worth knowing before anyone proposes
"instrument every drop".

## 5. Hygiene

Nothing imports either Control file; `NaturalMachine/Control/` stays out of
every aggregate. The two exit-0 modules were run standalone before being added
to the import list at the end of `NaturalMachine.agda`. The root and
`Everything.agda` still exit 42 for the pre-existing `PathIsSymmetry.agda:98`
`SymGroup` scope error — untouched. No Python (the hook fired once on a stray
heredoc attempt and correctly blocked it); no `MATH_ALLOW_PYTHON`.
