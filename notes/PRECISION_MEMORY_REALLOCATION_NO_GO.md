# Precision growth reallocates coherent memory; it does not erase it

## 1. Question

`REFINING_DILATION` proved that on the canonical world

\[
S_t=\{1,\ldots,t\},
\]

the least coherent-overwrite environment for the minimal sufficient
valuation chart has dimension at most (p). Its sawtooth drops from (p) to
(1) exactly when (t) reaches (p^{L+1}) and the chart earns one more
base-(p) digit. The proposed physical reading was that the garbage register
is cleared when precision increases.

That reading is false for the declared interface. The dimension drop is an
exact transfer of distinctions from the complementary register into the
visible output register.

## 2. Exact endpoint theorem

For a deterministic basis overwrite

\[
|x\rangle\longmapsto |q(x)\rangle|e_x\rangle,
\]

the least environment dimension is the maximum fiber size of (q).

> **Theorem.** Fix (L\geq 0). Immediately before the frontier,
> (t_-=p^{L+1}-1), the selected chart (q_L(x)=x\bmod p^L) has
> 
> \[
> |\operatorname{im}q_L|=p^L,\qquad d_E=p,
> \qquad |\operatorname{im}q_L|d_E=p^{L+1}.
> \]
> 
> At the frontier, (t_+=p^{L+1}), the selected chart becomes
> (q_{L+1}(x)=x\bmod p^{L+1}) and has
> 
> \[
> |\operatorname{im}q_{L+1}|=p^{L+1},\qquad d_E=1,
> \qquad |\operatorname{im}q_{L+1}|d_E=p^{L+1}.
> \]

**Proof.** On (S_{t_-}), every residue modulo (p^L) occurs, and the largest
fiber has (p) elements. Thus the output-by-environment rectangle has
(p^{L+1}) basis cells, exactly one more than the source uses. On (S_{t_+}),
reduction modulo (p^{L+1}) is injective, including the residue zero at the
last point, so the output itself has (p^{L+1}) values and no nontrivial
complement is needed. ∎

The one unused pre-frontier cell is the qualification anticipated in the
forecast: rectangular register allocation has one cell of slack, but its total
dimension is already exactly the post-frontier output dimension.

## 3. Decisive fixed-output control

Hold (q_L) fixed and merely add the point (p^{L+1}). Every residue modulo
(p^L) then has exactly (p) preimages, so (d_E=p) still. Inner-product
preservation forces those (p) input basis states to have orthogonal
environment labels.

Therefore no environment-only unitary, reset, or compression explains the
drop (p\to1). The drop occurs only because the output alphabet itself changes
from (p^L) to (p^{L+1}) values. This is a change of the declared
system--environment cut.

## 4. Process ruling

There is no thermodynamic clearing theorem here. No fixed physical register
has been evolved to a blank state, and no heat or work cost has been defined.
Two different minimal dilations of two different quotient interfaces have been
compared.

The exact correspondence is instead:

\[
\text{one new visible }p\text{-ary digit}
\quad\longleftrightarrow\quad
\text{a factor-}p\text{ transfer from hidden fiber label to visible output}.
\]

This changes the organism's next move. It should treat chart selection as part
of the quantum interface and track at least

\[
(|\operatorname{im}q|,\ \max_y|q^{-1}(y)|),
\]

not call the second coordinate alone a physical memory reset. A physical
reset claim would require one fixed subsystem decomposition and a specified
channel or instrument across the transition.

## 5. Replay and scope

```sh
cd machinery
python3 -m unittest test_precision_memory_reallocation.py -v
python3 precision_memory_reallocation.py
```

The theorem concerns exact deterministic basis overwrites on the canonical
successor worlds. It is not a gate-count, thermodynamic-erasure, noisy-memory,
process-tensor, causal-order, or spacetime result.

