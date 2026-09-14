# SetQuotient HIT in Bend2-cubical

Adds the SetQuotient higher inductive type `A / R` to the cubical Bend fork,
closing the last capability gap for the census / NerodeCongruence quotient
(previously only expressible in Cubical Agda).

Apply `cubical-setquotient.patch` on top of the `cubical-paths.patch` fork
(`git apply` in the Bend2 checkout), rebuild with
`cabal-3.18.1.0 build -w ghc-9.12.2 exe:bend`, then
`bend setquotient_test.bend --total`.

## Term formers (Core/Type.hs)

    Quot A R          A / R                       : Set   (R : A -> A -> Set)
    QIn a             [ a ]                        : A / R
    QEq a b r         eq/ a b r                    : Path(A/R, [a], [b])
    QSq x y p q       squash/ x y p q              : set-truncation 2-cell
    QuotM x fp fe     qelim(x, fp, fe)             recursor into a set B

## Surface syntax (Core/Parse/Term.hs)

    Quotient(A, R)          qin(a)          qeq(a, b, r)
    qsquash(x, y, p, q)     qelim(x, fp, fe)

## Computation rules (Core/WHNF.hs, whnfQuotM + whnfPAp)

    qelim([a], fp, fe)        ≡ fp a                        (point β)
    qelim(eq/ a b r @ i,…)    ≡ (fe a b r) @ i              (path/cong β)
    eq/ a b r @ i0            ≡ [a]        eq/ a b r @ i1 ≡ [b]   (boundary)

Both β-rules hold **definitionally** — witnessed by `refl` in the test:
`rec_point_beta`, `rec_path_lam`, and `rec_path_beta` all check `[total]`
and are reported `definitional` by the checker.

`coe`/`transp` over a *constant* quotient line is the identity by the
existing regularity rule (the line does not mention its interval variable),
which is the case the census uses (the quotient is over a fixed A/R).

## Typing (Core/Check.hs)

* `Quotient(A,R)` : Set given `A : Set`, `R : A -> A -> Set`.
* `[a]` checked against `A / R` ⟶ `a : A`.
* `eq/ a b r` checked against `Path(A/R,[a],[b])` ⟶ `a,b : A`, `r : R a b`,
  boundary `[a]`, `[b]`; inferrable when `r`'s type is a spine `R a b`.
* `qelim(x, fp, fe) : B` where `fp : A -> B`,
  `fe : ∀a b. R a b -> Path B (fp a)(fp b)`; `x` is *checked* against `A / R`
  so point/2-cell scrutinees (which carry no type index) are accepted.

Test: `setquotient_test.bend` — 8/8 definitions `[total]`.
