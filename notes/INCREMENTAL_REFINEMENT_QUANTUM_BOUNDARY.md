# A predictive split is new information, not reversible unpacking

Let a finite deterministic action system have an old predictive quotient

\[
q:X\longrightarrow Q
\]

and, after adding an observation, a refined predictive quotient

\[
q':X\longrightarrow Q'.
\]

By incremental observation refinement there is a canonical surjection
`p:Q' -> Q` satisfying `q=p q'`.  The fibers of `p` are the old predictive
classes split into newly distinguishable classes.

## Theorem 1 (exact reversible price of forgetting a refinement)

An isometry of the overwritten coherent form

\[
V|u\rangle=|p(u)\rangle|e_u\rangle,\qquad u\in Q',             \tag{1}
\]

exists with minimum environment dimension

\[
\boxed{\max_{z\in Q}|p^{-1}(z)|}.                              \tag{2}
\]

*Proof.* If distinct `u,v` lie in one fiber of `p`, preservation of their zero
inner product in (1) forces `e_u` and `e_v` to be orthogonal.  Thus the largest
fiber supplies the lower bound.  Conversely, enumerate each fiber by
`0,...,|p^{-1}(z)|-1` and use that index as the environment label.  Labels may
be reused over different outputs because the first register is then
orthogonal. ∎

This is the earlier coherent quotient-dilation theorem applied to the
canonical map between predictive quotients.  Its new content here is the exact
interpretation of the fiber cardinality: it counts new predictive classes per
old class, not raw world states.

## Theorem 2 (refinement cannot be reconstructed from the old state)

There is a deterministic exact operation on `Q` that returns `q'(x)` for every
`x in X` if and only if `p` is injective.  The same no-go holds for an exact
quantum channel whose decoded output must be `|q'(x)><q'(x)|`.

*Proof.* If `p` is not injective, choose distinct `u,v in Q'` with
`p(u)=p(v)=z`, and representatives `x,y` with `q'(x)=u`, `q'(y)=v`.  The
operation receives the identical old state `z` on both inputs, so it has one
output, but correctness demands two different outputs.  For a quantum channel,
the input density operator is likewise identical in the two cases, and
linearity makes its output identical.  Conversely, if `p` is injective, its
inverse on the image reconstructs `Q'`. ∎

Hence a shortest witness forest proves that an old class must split, but it
does not contain the missing runtime state.  Following a witness requires
access to the underlying state and the new observation.  More quantitatively,
if representatives `u_1,...,u_r` over one old class have pairwise replayable
distinguishing certificates, then they are distinct elements of one `p`-fiber,
and Theorem 1 certifies at least `r` orthogonal environment levels when the
refinement is forgotten.

## Six-residue crystal

Take `X=Z/6Z`, action `a(x)=x+2`, and old observation parity.  Since `a`
preserves parity, the old predictive quotient has two classes:

\[
\{0,2,4\},\qquad \{1,3,5\}.
\]

Add the observation `3|x`.  Within either parity class, its values along the
three-step `+2` cycle distinguish all three residues.  For example, `0` is
immediately separated from `2,4`, while one `+2` step separates `2` from `4`;
similarly one step separates `1` from `5`.  Thus the refined predictive
quotient has all six residues, every shortest new witness has length at most
one, and

\[
|p^{-1}(\text{even})|=|p^{-1}(\text{odd})|=3.
\]

Coherently forgetting residue mod `6` down to parity therefore needs an
environment of dimension exactly `3`: a qutrit.  Starting with parity alone
cannot recover the residue, even though the witness forest gives a one-step
experiment for every missing distinction.  The experiment acquires new
information; it does not unpack information hidden inside the parity bit.

Replay:

```sh
cd machinery
python3 -m unittest test_incremental_refinement_quantum_boundary.py -v
python3 incremental_refinement_quantum_boundary.py
```

## Rigor boundary

The claims are exact for finite deterministic quotients and zero-error basis
readout.  They do not give a gate-count lower bound, an approximate quantum
memory bound, a thermodynamic erasure cost, or a quantum speedup.  The
environment formula is not novel relative to the repository's general
quotient-dilation theorem; the result is its precise transport to incremental
predictive refinement and witness certificates.
