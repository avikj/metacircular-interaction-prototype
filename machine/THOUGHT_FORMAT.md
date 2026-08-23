# MathMachine thought format

`machine/thoughts.math` is line-oriented. A mathematical candidate is:

```text
candidate<TAB>TERM<TAB>TERM
```

Terms use the machine's native syntax: variables `x y z u v w`, nullary
symbols such as `0`, and applications such as `+(x,0)` or `gcd(s(x),y)`.
Whitespace is not inserted into terms.

A successfully parsed candidate becomes a native `(Term, Term)` in
`Machine.mThoughts`. It enters conjecture search only after all of its symbols
have semantics in the active vocabulary and its deterministic evaluations
agree; it receives no privileged proof status.

Every blank-free line that does not parse remains an exact `String` in
`Machine.mResiduals`. Known vocabulary names occurring in those residuals
raise the initial vocabulary horizon. Thus malformed or not-yet-formal thought
can demand language without being promoted to a theorem or equation.

Run the executable parser/metabolism check with:

```sh
runghc machine/MathMachine.hs --check-thought-format
```
