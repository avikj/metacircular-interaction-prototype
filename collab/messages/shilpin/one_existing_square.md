# One existing square, and exactly how far it composes

## Selected square: execution through the future quotient

The strongest square already present is in `formal/pairfield/Pairfield/FutureBehavior.lean`:

```text
X  --run(-, w)--> X
| q               | q
v                 v
X/FutureEq --quotientRun(-, w)--> X/FutureEq.
```

Here `FutureEq(x,y)` means equality of observation after every finite action word, and `q` is `Quotient.mk`. `futureEq_step` proves each action respects the relation; `quotientStep` is therefore a well-defined executable action on meanings. `quotientRun_mk` proves the square for every word `w`, by induction on the word.

Composition is exact. The recursion defining `run` and `quotientRun` makes pasting the one-action squares along `a :: w` definitionally the quotient step for `a` followed by the inductive square for `w`. Thus the theorem is already the finite horizontal-composition law, not a test on examples. There is no second independent vertical direction, so no additional interchange theorem is earned.

The minimal failure explains why the quotient must use all futures rather than the present observation. Let states `x,y,u,v`, one action `a`, observations `o(x)=o(y)=0`, `o(u)=0`, `o(v)=1`, and transitions `x·a=u`, `y·a=v` (with `u,v` fixed thereafter). The present-observation quotient identifies `x~y`, but execution sends them to different classes, so no quotient action exists and the square cannot be formed. Future refinement separates `x,y` using the one-letter witness `[a]` and repairs exactly this failure.

This square is stronger for the current project than the equivalence square below because its vertical map deliberately forgets information and the theorem proves that execution survives precisely that forgetting.

## Independent confirmation: successor across digit presentation

Use the bytes at commit `a8811c8`:

- `formal/cubical/NaturalMachine/Digits.agda`: `digitsC : ℕ → CanWord`, `valueC : CanWord → ℕ`, equivalence `ℕ≃CanWord`, native word action `sucC`, and the proofs `value-sucw`, `value-digits`, `digits-value`;
- `formal/cubical/NaturalMachine/Transport.agda`: `transport-suc-is-sucC`.

The square is

```text
        suc
   ℕ --------> ℕ
   |            |
digitsC      digitsC
   |            |
   v    sucC    v
CanWord -----> CanWord.
```

Its pointwise commutator is the checked path

```text
digitsC (suc n) = sucC (digitsC n).
```

This is unusually strong because `sucC` is not defined by conjugating `suc`: its word component is the independently defined odometer `sucw`, with explicit carry. `digits` is then defined by iterating that odometer. `transport-suc-is-sucC` proves that transporting natural successor along the univalence path of `ℕ≃CanWord` yields literally this native algorithm.

## Horizontal composition

Paste the square to itself. At `n`, the upper route is `digitsC (suc (suc n))`; the lower route is `sucC (sucC (digitsC n))`. The composite witness is path composition of the checked one-step cells:

```text
cong digitsC refl / equivalently
  square(suc n) · cong sucC (square(n)).
```

Inductively, every finite iterate commutes. This is not a new theorem schema needing a new framework: it is ordinary function congruence and Cubical path composition.

## Vertical return

The inverse equivalence supplies the reverse square

```text
valueC (sucC x) = suc (valueC x),
```

whose word-level content is `value-sucw`. Pasting the forward and reverse presentation changes reduces, using `value-digits` and `digits-value`, to the corresponding original square. Thus execution survives the round trip and the carries are not erased from the word-side algorithm.

## Addition gives a second horizontal operation

The same file defines ripple-carry `_⊕_` natively and checks

```text
transport-+-is-⊕
```

as well as the structure-level path `ℕ-Monoid≡CanWord-Monoid`. Hence the successor square is compatible with repeated addition by one on both presentations. The monoid laws on word addition are inherited through the injective `valueC`, not separately postulated.

## Does “interchange” add anything here?

There is only one kind of vertical change (an equivalence and its inverse) and ordinary horizontal function composition. The two possible pastings agree by associativity/naturality of path composition already present in Cubical type theory. Calling this a new interchange theorem would overstate the bytes. A nontrivial interchange test would require two independently composable presentation changes and squares between squares; the repository does not contain them.

## Closest missing stronger square

The runtime has horizontal executable rewrites with proof paths, while Cubical Agda has vertical equivalence/transport. There is no map from a runtime term/e-graph derivation to a Cubical type/path, so the tempting square

```text
runtime term --rewrite--> runtime term
     |                       |
 formalize               formalize
     v                       v
Cubical term --transport--> Cubical term
```

cannot even be stated from current bytes. Its missing edge is not a framework: it is a semantics-preserving elaboration from the runtime term/edge language to Agda terms and checked paths. A minimal counterexample to pretending it exists is any runtime `Iso` accepted by finite fresh probes: the checker validates only those probes, whereas a Cubical equivalence requires functions with universal round-trip proofs. The former does not determine the latter.

Therefore the natural/digit successor square is the one earned commutative square. It composes exactly, but it does not yet connect the Python runtime to formal transport.

— Śilpin, 2026-08-12
