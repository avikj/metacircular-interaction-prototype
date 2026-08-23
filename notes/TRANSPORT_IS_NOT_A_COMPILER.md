# The transport is a certificate, not a compiler — measured

**Status: checked witness plus a measured complexity separation.** Author
`opus-samhita`, 2026-08-13. Artifact:
`formal/cubical/NaturalMachine/TransportCost.agda`, `--cubical --safe`, no
postulates, no holes.

## 0. The question, which is a programming question

`NaturalMachine.Transport` proves

```agda
transport-+-is-⊕ : transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _+_ ≡ _⊕_
```

— transporting ℕ's addition along `ua ℕ≃CanWord` yields *literally* the
schoolbook ripple-carry algorithm on digit words. Its own header says
"transport does work here, it does not decorate."

That is a **path between two functions**. A path says nothing about how the two
**terms reduce**. So two questions survive the proof, and neither is settled by
it:

1. does the transported term compute at all?
2. if so, does it compute at the native algorithm's complexity?

The second is the one the repository's own programme turns on.
`RESEARCH_SYSTEM.md` §9 step 3 wants "one checked theorem transport end to
end"; `README`/`RUNTIME` want a theorem to become *an executable shortcut*.
Whether transport is that shortcut is an empirical question about reduction,
not a theorem.

## 1. It computes

Every line of `TransportCost.agda` is `refl`, which forces evaluation.

```agda
transported-computes  : valueC (transported (digitsC 1) (digitsC 1)) ≡ 2
transported-cascade   : valueC (transported (digitsC 7) (digitsC 1)) ≡ 8   -- 111₂ + 1
agree-definitionally  : transported (digitsC 7) (digitsC 1) ≡ digitsC 7 ⊕ digitsC 1
```

The last is **strictly stronger than `transport-+-is-⊕`** and separately
falsifiable: it says the two terms reduce to the same canonical word, not
merely that a path connects the functions. It typechecks.

So the `DigitTowerLimit` transport warning does not infect this: the machine
runs.

## 2. It does not compute at the native complexity

Chain the operation `N` times, `iterOp op N = op (… op (op zero 1) 1 …) 1`, and
typecheck `valueC (iterOp op N) ≡ N` for the native `_⊕_` and for the
transported term. Base two, worst case for ripple carry. Times are whole-file
typechecks; the fixed cost of loading the `NaturalMachine` interface was
measured separately at **6185 ms** and is subtracted.

| N | native, net | transported, net |
|---|---|---|
| 20 | ~0 | ~0 |
| 40 | ~0 | ~0 |
| 80 | ~0 | ~0 |
| 400 | ~0.3 s | **3.5 s** |
| 800 | — | **12.2 s** |
| 1200 | ~0 | **35.8 s** |

Native is flat — under the noise floor at every `N` tested. Transported is
**quadratic**, and this was predicted before it was measured: from the `N=400`
point, a quadratic law predicts `3.46 × 4 = 13.8 s` at `N=800` (measured
**12.2 s**, 12% low) and `3.46 × 9 = 31.1 s` at `N=1200` (measured **35.8 s**,
15% high).

## 3. Why, and it is not an implementation wart

Transport along `ua e` computes as `e⁻¹ ∘ f ∘ (e × e)`. So the transported
addition **is**, operationally, *decode to ℕ, add in ℕ, re-encode* — and
`valueC` and `digitsC` are unary (`value (d ∷ w) = toℕ d + b · value w`).
Operation `k` in the chain therefore costs `Θ(k)`, and `N` chained operations
cost `Θ(N²)`. The measurement is the mechanism.

This is not a defect of Cubical Agda, of `ua`, or of the module. It is what
transport across an equivalence *means*: it carries the operation's
**extension**, and its computational content is the round trip, not the
algorithm the path is proved equal to.

## 4. What this settles for the programme

> **`transport-+-is-⊕` is a correctness certificate for `_⊕_`. It is not a
> compiler that produces `_⊕_`.** The native ripple carry is the shortcut; the
> transport certifies that the shortcut is right, at zero cost to the shortcut.

That is a *better* reading of the substrate ruling than "a checked term is the
object itself", because it separates two things that ruling merges. A checked
term is the object; but a checked *path between* objects is not itself an
efficient object, and the corpus's own §9 step 3 ambition should be stated with
that split visible. Concretely:

- **Transport buys correctness transfer, cheaply.** `Transport.agda`'s monoid
  laws for `⊕` are inherited from ℕ rather than re-proved by hand — that is
  real and it costs nothing at runtime.
- **Transport does not buy an implementation.** Anyone hoping "prove the
  equivalence, get the fast algorithm" gets the slow one and a proof that the
  fast one they already wrote is equal to it.
- **Which is the right division of labour**, and worth saying plainly: write
  the algorithm as an engineer, certify it by transport as a mathematician.
  The measured statement is that this costs `O(1)` and the alternative costs
  `Θ(N²)`.

## 5. Rigor boundary

- **Checked:** everything in `TransportCost.agda`, `--safe`, 0 postulates,
  0 holes, including the definitional agreement of the two terms.
- **Measured, not proved:** the timings. Single machine, single run per cell,
  whole-file typecheck wall time minus a separately measured baseline. The
  quadratic law is supported by a pre-registered prediction hitting within 15%
  at two points; it is not a complexity proof. A complexity proof would be a
  statement about Agda's evaluator and is not attempted.
- **Not claimed:** that all transports are quadratic; that `ua` is slow in
  general; that any other module's transports behave this way. One operation,
  one equivalence, one representation, base two.
- **Confounder checked and rejected:** my first attempt used `digitsC 4821`
  and I nearly concluded "transport is slow" from it. That benchmark was
  measuring **unary numeral construction**, which both variants pay equally.
  The experiment above holds the inputs fixed and varies only the number of
  operations, so the native column is the control. It is flat, which is what
  makes the transported column mean anything.
- **No prior art searched.** That `transport` along `ua` computes as a round
  trip is standard and known to every cubical user; the contribution here is
  the measurement against this repository's own claim, not the fact.

## 6. Replay

```sh
cd formal/cubical
agda -i . NaturalMachine/TransportCost.agda     # ~7 s, all refl
```

The `N ∈ {400, 800, 1200}` scaling modules are deliberately **not** left in the
tree — a 40-second typecheck in the root path would be hostile. They are four
lines each and the note above states them exactly.
