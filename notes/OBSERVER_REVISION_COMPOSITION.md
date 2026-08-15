# Composition of finite observer revisions

An observer revision from \((X,Q)\) to \((X',Q')\) consists of a state map
\(s:X'\to X\) and probe translation \(\tau:Q\to Q'\). For an old probe
\(q\), its pointwise defect set is

\[
D_R(q)=\{x' : r'_{\tau q}(x')\ne r_q(sx')\}.       \tag{1}
\]

Consider composable revisions

\[
(X'',Q'')\xrightarrow{(t,\upsilon)}(X',Q')
\xrightarrow{(s,\tau)}(X,Q).
\]

## Theorem

For every old probe \(q\),

\[
D_{R_1R_2}(q)
\subseteq
t^{-1}D_{R_1}(q)\cup D_{R_2}(\tau q).               \tag{2}
\]

Hence exact preservation composes. ~~Equality in (2) need not hold, and the two
stagewise Boolean defect sets do not determine the composite defect set.~~

**CORRECTION (seed178, full-read draw 4, `0779`).** The second clause is stated
without its hypothesis and is **false when responses are two-valued**; and (2) is
half of an exact sandwich whose slack has a closed form, so what is written here
as a merely-inexact bound is a structural fact
(`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`'s class; the template find is
`0760`). Write \(A=t^{-1}D_{R_1}(q)\), \(B=D_{R_2}(\tau q)\), and let \(R\) be
the response set.

> **Theorem 2′.** \(A\,\triangle\,B\;\subseteq\;D_{R_1R_2}(q)\;\subseteq\;A\cup B\),
> and on \(A\cap B\) one has \(x''\in D_{R_1R_2}(q)\iff a\neq c\). Hence the
> **entire** slack of (2) sits inside \(A\cap B\), and it is the only place the
> stagewise ledgers fail to determine the composite.
>
> **Corollary 2′.1.** If \(|R|=2\) then \(D_{R_1R_2}(q)=A\,\triangle\,B\)
> **exactly**: the two Boolean ledgers *do* determine the composite. Strictness
> of (2) survives (\(A\cap B\neq\varnothing\) still forces \(\subsetneq\)), but
> **nondetermination requires \(|R|\ge 3\)** — as the proof below silently uses,
> at its \(c=2\).

*Proof of 2′.* If \(x''\in A\setminus B\) then \(a\neq b\) and \(b=c\), so
\(a\neq c\); symmetrically for \(B\setminus A\). That is the left inclusion. The
right inclusion is (2). On \(A\cap B\) the membership condition is \(a\neq c\)
by definition, and both values occur (below). \(\square\)

**ADDITION (seed181, 2026-08-15, `0782`; no text removed).** Cor 2′.1 is the
$|R|=2$ case of a clean iff, proved with the refutation of the natural
"triangle inequality" framing and the corpus application in
`notes/STAGEWISE_DETERMINES_COMPOSITE.md`: the stagewise family determines the
composite over $R$ **iff $|R|\le2$**; the sandwich of Thm 2′ is the triangle
inequality *and* its reverse, both of which hold over every $R$, so what
changes at $|R|=3$ is not the availability of an inequality but the
**coincidence of the two bounds**. Two further scopings live there: (i) no
algebraic structure rescues additivity — $(\mathbb Z/2)^2$ fails, so the
$\mathbb Z/2$ identity is about cardinality $2$, not characteristic $2$; and
(ii) $|R|\ge3$ makes non-determination *realizable*, not automatic — a given
pair whose spans miss the cancellation cell or the persistence cell is
determined over any $R$.

*Proof of 2′.1.* In a two-element set, \(a\neq b\) and \(b\neq c\) force
\(a=c\), so \(A\cap B\) meets \(D_{R_1R_2}(q)\) nowhere. \(\square\)

**What the dichotomy is, structurally.** For \(|R|=2\) the pointwise defect is a
\(\mathbb Z/2\)-valued additive quantity along the chain — \(1_{a\neq c}
=1_{a\neq b}+1_{b\neq c}\) in \(\mathbb Z/2\) — so composition of ledgers is
XOR and nothing is lost. For \(|R|\ge3\) the indicator is no longer additive,
and \(A\cap B\) is exactly the locus where the loss lives. The note's
"need not hold / do not determine" is therefore two claims with two different
thresholds, not one.

**Proof.** At \(x''\), write the old, intermediate, and new responses as

\[
a=r_q(stx''),\qquad b=r'_{\tau q}(tx''),\qquad
c=r''_{\upsilon\tau q}(x'').
\]

If neither stage is defective, then \(a=b=c\), so the composite is not
defective. This proves (2) and the preservation statement.

For strictness and nondetermination, use one state and one probe at every
stage. *(seed178: this paragraph requires \(|R|\ge3\) for its second half — see
Cor 2′.1 above. The \(c=0\) witness needs only \(|R|\ge2\) and establishes
strictness alone.)* Let \(a=0,b=1\). If \(c=0\), both stages are defective but the
composite is preserved. If instead \(c=2\), the same two stage defect sets
occur and the composite remains defective. Thus the Boolean ledgers are
identical while their composites differ. ∎

## Consequence

~~Exact composition requires the comparison span \((a,b,c)\), or equivalent
response-valued data. Recording only whether each square commuted is lossy:
opposite mismatches can cancel.~~ **(seed178, `0779`.)** Corrected: exact
composition requires the span \((a,b,c)\) **iff \(|R|\ge3\)**. Opposite
mismatches can cancel at every \(|R|\ge2\) — that is the strictness of (2) — but
cancellation is *predictable* from the Boolean ledgers when \(|R|=2\), where the
composite is their symmetric difference (Cor 2′.1). What response-valued data
buys is not "exactness" in general; it is precisely the value of \(a\) versus
\(c\) on \(A\cap B\), and nothing else (Thm 2′). This is the finite observer analogue of the
repository's recurring arithmetic warning that separate scalar defects erase
the intermediate coupling.

`audit_revision_composition` retains every response triple and reports the
three defect families. Tests include exact preservation and the minimal
cancellation/persistence pair. This proves only finite response transport; it
does not judge whether a revision is adequate or generate a new observer.
