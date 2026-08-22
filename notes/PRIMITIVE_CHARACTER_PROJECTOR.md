# Ramanujan sums are weighted fixed-sector traces

Let `C_q=<g>` act regularly on itself, and let `rho(g)` be the corresponding
permutation operator on `Q[C_q]`. Define the rational group-algebra element

```text
e_prim = (1/q) sum_(k=0)^(q-1) c_q(-k) rho(g^k).        (1)
```

Then `e_prim` is the projector onto the direct sum of the primitive complex
characters of `C_q`. It is defined over `Q`, has rank `phi(q)`, and

```text
Tr(rho(g^n) e_prim) = c_q(n).                           (2)
```

Thus the cyclotomic field trace in `RAMANUJAN_TRACE.md` is exactly a
character-weighted fixed-sector trace on an explicit finite action. It is not
an ordinary fixed-point count.

> **Convention, made explicit (seed125 audit, 2026-08-14) — no change to any
> statement.** "Primitive character of `C_q`" here means a **faithful**
> character `χ_a(g^k)=ζ_q^{ak}`, `gcd(a,q)=1` — a character of order exactly
> `q`, equivalently the `Φ_q`-isotypic component of `Q[C_q]`. It does **not**
> mean a primitive Dirichlet character mod `q`, and the two disagree: at `q=6`
> there are two faithful characters of `C_6` (so `e_prim` has rank
> `φ(6)=2`, as the text says) and **no** primitive Dirichlet characters mod 6.
> Everything below is correct under the stated definition; this note is the
> corpus's definition of record for the phrase, and `Φ_q`-isotypic is the
> unambiguous name (cf. `notes/LEAKAGE_COST_VECTOR.md`, `0722-seed121`).

## Derivation

Over `C`, write the primitive characters as

```text
chi_a(g^k)=zeta_q^(ak),   gcd(a,q)=1.
```

The usual character idempotent for `chi_a` is

```text
e_a=(1/q) sum_k chi_a(g^-k) rho(g^k).
```

Summing over primitive `a` gives (1), because
`sum_a chi_a(g^-k)=c_q(-k)`. Orthogonality makes the `e_a` mutually
orthogonal idempotents, so `e_prim` is idempotent and has rank `phi(q)`.
On its image, `rho(g^n)` has the primitive eigenvalues
`zeta_q^(an)`; their trace is `c_q(n)`, proving (2).

There is also a direct fixed-sector form. Since the trace of a permutation is
its number of fixed basis elements,

```text
c_q(n)
 = (1/q) sum_k c_q(-k) Tr(rho(g^(n+k)))
 = (1/q) sum_k c_q(-k) #Fix(g^(n+k) on C_q).            (3)
```

For the regular action only `k=-n` contributes, but the formula identifies
the precise common operation: the primitive character idempotent weights the
twisted sectors before taking their trace.

> **Delimitor supplied (SEED-112, Rule K3, 2026-08-14, applying
> `notes/SEED53_PRATIYOGIN_OF_THE_PRIMITIVE_PROJECTOR.md` §4.2, ledger row 9,
> which graded this "true but under-delimited" and, unlike §4.1 and §4.3, was
> not landed here by SEED-105.)** The sentence is **true**, and its reason is a
> fact about **stabilisers, not about the index `k`**: the regular action is
> free, so `#Fix(g^m on C_q) = q·[m ≡ 0 mod q]`, and every summand of (3) with
> `k ≠ −n` dies because the fixed-point count does, not because `k` is special.
> Stated that way the passage from (3) to (4) stops being a generalisation and
> becomes the same formula with the freeness hypothesis dropped: **(4) is
> nontrivial precisely to the extent that `X` has points with nontrivial
> stabiliser**, and (3) is its degenerate case. This is the same
> `Stab`-triviality dichotomy `PORT_IS_A_BASE_POINT.md` §1 runs on. Nothing in
> (3) or (4) changes; only the reason attached to the collapse.

More generally, for any finite `C_q`-set `X` and any equivariant permutation
`f`, the same matrix calculation gives

```text
Tr(f e_prim | Q[X])
 = (1/q) sum_k c_q(-k) #{x in X : f(g^k x)=x}.          (4)
```

This is the representation-ring refinement of
`TWISTED_FIXED_ORBIT_TRACE.md`. The unweighted average projects to the
trivial character and counts fixed quotient orbits. The Ramanujan-weighted
average projects to the primitive cyclotomic isotypic component.

## Why no honest set suffices

An endomap of a finite set has a nonnegative integer fixed-point count. But

```text
c_3(1)=-1.
```

Therefore Ramanujan sums cannot, ~~in general,~~ be ordinary fixed-point counts
of finite sets. ~~The smallest obstruction is already `q=3`.~~ Negative
Möbius/character weights—or equivalently a virtual representation—are not a
presentation choice; they are forced by the sign.

> **Struck (SEED-105, Rule K1/K3, 2026-08-14, applying
> `notes/SEED53_PRATIYOGIN_OF_THE_PRIMITIVE_PROJECTOR.md` §4.1, which produced
> this correction on 2026-08-14 and did not apply it here).** Two defects, one
> of minimality and one of hedging. SEED-53 Proposition N3′: for every `q > 1`
> and every prime `p | q`, Hölder's formula gives
> `c_q(q/p) = μ(p)·φ(q)/φ(p) = −φ(q)/(p−1) < 0`. Hence the obstruction holds at
> **every** `q > 1` and the smallest is **`q = 2`**, where `c_2(1) = −1`, not
> `q = 3`. The hedge "in general" is therefore also removable: there is no
> `q > 1` at which a nonnegative finite-set realisation exists. (Checked against
> this note's own `q = 12` vector: `p = 2, n = 6` gives `−4 = c_12(6)`;
> `p = 3, n = 4` gives `−2 = c_12(4)`.) The delimitor SEED-53 supplies and this
> sentence omits is the *index* `n = q/p` at which negativity occurs.

The full regular carrier without `e_prim` is the hostile control. Its trace
vector is `(q,0,...,0)`, not `c_q`. ~~Fourier phases alone also do not suffice:~~
the primitive projector is the exact selection mechanism.

> **Struck (SEED-105, Rule K1/K3, 2026-08-14, applying SEED-53 §4.3).** Under
> its natural reading ("no Fourier-side object reproduces `c_q`") the struck
> clause is **false**: definition (1) *is* a Fourier sum, and SEED-53 Theorem Ψ
> puts it in closed form, `R_q = Ψ_q·(xΦ_q' − φ(q)Φ_q)` in `ℤ[x]`. What is true
> is the sentence before it, with its delimitor made explicit — SEED-53's N5′:
> *the trace vector of `ρ(g^n)` on the full regular carrier with **no**
> idempotent inserted is `(q,0,…,0) ≠ c_q` for every `q > 1`; the absent object
> is a **carrier** (an honest finite `C_q`-set whose **unweighted** sector
> traces give `c_q`), not a Fourier expression, and by N3′ no reweighting by
> nonnegative integers repairs it.* The correct slogan is "the carrier, not the
> language, is what fails".

## Executable certificate

`machinery/primitive_character_projector.py` uses exact `Fraction` matrices.
It checks:

- `e_prim^2=e_prim`;
- `rank(e_prim)=trace(e_prim)=phi(q)`;
- projected matrix traces, weighted fixed-sector traces, and divisor-formula
  Ramanujan sums agree;
- at `q=12` the common trace vector is
  `(4,0,2,0,-2,0,-4,0,-2,0,2,0)`.

Replay:

```text
python3 machinery/primitive_character_projector.py
python3 -m unittest machinery.test_primitive_character_projector
```

This is standard finite-group character theory. The earned result is the
exact identification of the repo's two trace mechanisms and the sharp
set-versus-representation boundary.
