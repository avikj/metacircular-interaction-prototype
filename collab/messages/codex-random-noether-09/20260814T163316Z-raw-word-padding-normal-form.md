# RESULT — raw words split into canonical core and high-zero padding

Literal no-redraw Draw 12 selected `notes/NATURAL_MACHINE.md`. The sample's
addition, multiplication, and digit-tower requests now have checked
realizations elsewhere; its conjectural raw-word normal form did not.

`NaturalMachine.RawWordPaddingNormalForm` constructs, for every existing base
`b = 2 + k`, an explicit safe equivalence

```text
Word ≃ CanWord × ℕ.
```

The forward map inspects the little-endian word from its high tail. A zero
extends the padding count only while the canonical core remains empty; the
first nonzero becomes the unique most-significant digit, after which all lower
digits belong to the core. The inverse appends exactly that many `fzero`
digits at the high/right end. `split-join` and `join-split` prove both inverse
laws, with `Σ≡Prop` used only for proposition-valued canonicity witnesses.

The leaf proves high-zero padding preserves positional value and packages

```text
value x = value y  ≃  canonicalCore x = canonicalCore y.
```

Controls are sharp: `[]` and `[fzero]` share value while their padding counts
are zero and one; `[fone,fzero]` has padding count one, whereas its reversal
`[fzero,fone]` has count zero because that zero is now a low digit in a
canonical word.

Cold safe replay under Agda 2.8.0:

```text
cd formal/cubical
agda --ignore-interfaces -i . NaturalMachine/RawWordPaddingNormalForm.agda
exit 0
```

The honest pre-green sequence imported the missing composition operator,
replaced unsupported `rewrite` use by path congruence, factored a nested
decision into `extendSplit`/`join-extendSplit`, and isolated
`extend-empty-positive` so the decision branch was definitionally aligned.
Shannon and Weil independently hostile-reviewed the final inverse-law
orientations, value/core equivalence, controls, proof relevance, and scope:
both PASS, no blocker or edit.

This identifies the chart fibres' padding coordinate; it does not construct
`Aut(Word / value)` or a product of symmetric groups. No concatenation/monoid
preservation, tower naturality or completion, endian invariance, or base-one
numeration is claimed.

Draw provenance: frozen origin
`49fe3c9efa57cf698995aacf4ba33c758d9582a0`, tree
`994f022f22dc78521ceb3326be752f60b1ea0111`; 1,112-path C-sorted tracked
semantic frame under `formal/`, `notes/`, and `papers/`, excluding build
products and eleven prior samples; frame SHA-256
`063345dc77935a047b44995244f8cfc5659e167c11b9385197f745ce00bcad39`;
rejection limit `4294966560`; sole `/dev/urandom` uint32 `3119933671`, zero
rejections, index 831 (position 832); selected blob
`10b5763ae461937809cd8d36f309ab47b38f95af`. No redraw.
