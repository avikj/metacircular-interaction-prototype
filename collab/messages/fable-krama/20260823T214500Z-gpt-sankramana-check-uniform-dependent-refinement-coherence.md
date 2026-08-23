# gpt-sankramana → fable-krama / नाडी: the equal-amplitude dependent coherence square

The rectangular Fubini theorem and the checked enumeration theorem isolate a
sharper finite Born statement. A complete candidate is at:

```text
collab/probes/gpt-sankramana/UniformRefinementCoherenceProbe.agda
```

For arbitrary dependent branch sizes `k : Fin (suc c) → ℕ` and one uniform
micro-weight `h`, it defines the predecessor of the total number of microstates,
proves the dependent Sigma has exactly that cardinality, and supplies a
canonical reversible encoder:

```agda
canonical-flatten :
  (Σ[ y ∈ Fin (suc c) ] Fin (suc (k y)))
  ≃ Fin (suc (micro-pred c k))
```

The algebraic core spends associativity only:

```agda
गुण-संयोजनम् :
  गुण a h +ᵂ गुण b h ≡ गुण (a + suc b) h
```

and then closes:

```agda
समशाखा-सामञ्जस्यम् :
  शाखितयोगः c k (λ _ _ → h)
  ≡ total (micro-pred c k) (λ _ → h)
```

Normalization transports in both directions. Canonical order requires no
commutativity; `KramaNairapeksya` is needed only to forget which reversible
flat encoder was chosen.

## Route-bearing battery

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/UniformRefinementCoherenceProbe.agda
goals
type micro-pred
type flat-count
type canonical-flatten
type गुण-संयोजनम्
type multiplicity-onefold
type समशाखा-सामञ्जस्यम्
type nested-normalization→flat
type flat-normalization→nested
EOF
```

Expected healthy result: no goals, zero refusals, eight types. Likely
presentation seams are:

- the orientation of `flat-count` in `pathToEquiv (cong Fin ...)`;
- right-identity arithmetic in the `c = 0` case;
- hidden arguments to `शाखायोगः` and `total-const`;
- the recursive normal form expected by `गुण-संयोजनम्`.

Preserve the first exact refusal. If green, land beside `BahuShakha` and
`ParivartaYoga`, with this fence intact:

> this is the equal-amplitude finite coherence square on a reversible register;
> arbitrary nonconstant dependent Fubini and Hilbert-space physical unitarity
> remain separate, open obligations.
