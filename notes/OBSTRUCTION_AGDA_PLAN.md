# Obstruction-indexed proposal: the Agda plan beyond the checked kernel

Status: `formal/cubical/NaturalMachine/Obstruction.agda` is CHECKED (Agda
2.6.3 + cubical v0.5, exit 0) and contains T1–T9 as listed in its header:
defining equation, elimination/conservativity, matcher conservativity (D3),
monotonicity, strict progress, obstruction consumption, the plateau theorem
for frequency chains (as a path of matchers), `frequency-cannot-reach`, and
completeness of obstruction chains. This note is the remainder — statements
to prove, not prose. Each item is a theorem with a target signature in the
kernel's vocabulary; nothing below is licensed to become a measurement.

## P1 — k-ary terms and multi-parameter bodies

Replace the unary substrate by

```agda
data Tm : Type₀ where
  var  : ℕ → Tm                      -- parameters #0..#k-1  (gate D5)
  node : Shape → List Tm → Tm
```

with simultaneous substitution `plug : Tm → (ℕ → Tm) → Tm`. Prove, by
mutual induction with `List Tm` (the `All` predicate replaces the kernel's
`_×_` chain):

```agda
defining-equationₖ : unfold d b (node d ts) ≡ plug b (lookup (map (unfold d b) ts))
unfold-elimₖ       : Over V b → Over (d ∷ V) t → Over V (unfold d b t)
Params⊆            : body uses exactly #0..#(arity−1)          -- D5, as a type
```

T5–T9 restate verbatim; only `unfold-elimₖ`'s induction changes.

## P2 — pattern-level residuals (the B3 mechanism itself)

The kernel's obstruction is a root-head miss. The corpus's obstruction
(`runtime/vocabulary/README.md` §7) is a *pattern* miss: L1's LHS is a
binary product, B3's root is a 3-ary product. Target:

```agda
data Pattern : Type₀                      -- linear patterns with pattern vars
match : Pattern → Tm → MatchResult
data MatchResult : Type₀ where
  hit  : Subst → MatchResult
  miss : Position → Shape{-expected-} → Shape⊎Arity{-found-} → MatchResult
```

with the residual = the `miss` triple. Statements:

```agda
match-sound    : match p t ≡ hit σ → instantiate p σ ≡ t
match-complete : instantiate p σ ≡ t → Σ σ' (match p t ≡ hit σ')
residual-propose : (m : miss …) → Extension V     -- names the regrouping
regroup-progress : match L1 (regroup B3root) ≡ hit σ  for the proposed regrouping
```

`regroup-progress` is the checked form of "54 → fires" vs "80 → never": the
proposal from the residual makes a previously impossible match possible.
The kernel's `frequency-cannot-reach` lifts to: no frequency chain changes
`match p` on any term (the plateau at pattern level).

## P3 — the D3 counterexample, formalized

Gate D3 refuses defining equations whose LHS is old-language. Prove the
refusal is necessary by exhibiting the non-conservativity witness:

```agda
bad-extension : Σ[ E ∈ RawExtension V ] (lhs-old E) ×
                (Provable (V + E) (2 * 3 ≡ 2 + 3)) × ¬ Provable V (2 * 3 ≡ 2 + 3)
```

i.e. `x*y := x+y` in the model, with `Provable` the equational closure. This
is the only planned theorem whose content is a refusal; it certifies the
gate rather than the proposer.

## P4 — telescopes: sequential definitional extensions (D4 at depth)

```agda
Telescope : Vocab → Type₀            -- list of Extensions, each over the prefix
unfold*   : Telescope V → Tm → Tm    -- eliminate newest-first
telescope-elim : Over (installs T) t → Over V (unfold* T t)
```

Induction over the telescope order; the kernel's `unfold-elim` is the step
case. This is the D4 "strictly earlier definitions" clause as a theorem
rather than a gate.

## P5 — plateau strengthening: full-coverage version

The kernel proves `Matches W ≡ Matches V` along frequency chains. Prove the
same for coverage:

```agda
plateau-Over : FreqChain V W → Over W ≡ Over V
```

(pointwise by `memb-absorb`, then `funExt` twice). Corollary: frequency
chains change no `Over`-judgement anywhere, not just no root match.

## P6 — hProp packaging and univalence

`Matches V t` and `Over V t` are props (`isSetBool`, `isProp×`,
`isPropUnit`). Restate the matcher as `Tm → hProp ℓ-zero` and the plateau
as a path in that type via `Σ≡Prop`; then `extend-absorbed` becomes an
equality of *propositionally truncated matchers* with no change of proof.
Value: downstream modules can transport along the plateau path without
tracking h-levels.

## P7 — bridge to the corpus substrate

The runtime substrate has flat n-ary `Sum`/`Prod` heads and one
abbreviation. Statement to prove (no run): the schema's shape space is
closed under the four hand-written families' constructors, and the
frequency proposer's reachable shape set equals that closure —
`FreqReach V ≡ SchemaClosure` — while `ObsChain` reaches any shape
(`obs-complete` restated over the bridged substrate). Gate P1 of the
runtime ("may not rename existing syntax") appears as the freshness field
being evidence of *failure*, exactly as in the kernel's `propose`.

## Non-goals, recorded

- No formalization of scores, budgets, or §5's cost tables: those are
  operational, and the plateau theorem shows the benefit column is zero for
  structural reasons — there is no constant to fit.
- No witness-policy theorem: which base body a residual analysis should
  propose is a design choice; the kernel proves every choice is
  conservative (`propose-eliminable`), which is the only mathematical claim
  available at this level.
