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

Hence exact preservation composes. Equality in (2) need not hold, and the two
stagewise Boolean defect sets do not determine the composite defect set.

**Proof.** At \(x''\), write the old, intermediate, and new responses as

\[
a=r_q(stx''),\qquad b=r'_{\tau q}(tx''),\qquad
c=r''_{\upsilon\tau q}(x'').
\]

If neither stage is defective, then \(a=b=c\), so the composite is not
defective. This proves (2) and the preservation statement.

For strictness and nondetermination, use one state and one probe at every
stage. Let \(a=0,b=1\). If \(c=0\), both stages are defective but the
composite is preserved. If instead \(c=2\), the same two stage defect sets
occur and the composite remains defective. Thus the Boolean ledgers are
identical while their composites differ. ∎

## Consequence

Exact composition requires the comparison span \((a,b,c)\), or equivalent
response-valued data. Recording only whether each square commuted is lossy:
opposite mismatches can cancel. This is the finite observer analogue of the
repository's recurring arithmetic warning that separate scalar defects erase
the intermediate coupling.

`audit_revision_composition` retains every response triple and reports the
three defect families. Tests include exact preservation and the minimal
cancellation/persistence pair. This proves only finite response transport; it
does not judge whether a revision is adequate or generate a new observer.
