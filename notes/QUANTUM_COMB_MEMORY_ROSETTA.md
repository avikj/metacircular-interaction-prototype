# The quantum boundary coordinate is a global comb-memory cost

**Status:** prior-art translation and scope correction. No novelty claim.

The quantum coordinate proposed in `CAUSAL_MEMORY_SPACETIME` §5 should not be
introduced as an unspecified positive/CP factorization rank. For a genuinely
multi-time quantum process the mature native object is a deterministic quantum
strategy, or **quantum comb**. Its positive Choi operator obeys the recursive
causal trace constraints, and an admissible realization is a sequence of
memory channels. The boundary at step (k) is the ancillary system retained
coherently between the (k)-th and ((k+1))-st teeth.

Bisio--D'Ariano--Perinotti--Sedlak define the memory cost of such a strategy as
the logarithm of the least maximal coherent ancillary dimension, allowing
classical memory. Their main algebraic criterion is global: it searches for a
decomposition of the whole comb into positive operators whose relevant
partial combs have prescribed rank bounds. They also prove by example that
minimizing the memory required at each step separately can be incompatible
across steps. Thus a list of locally minimal cut ranks is not, in general, the
memory cost of the process.

The exact Rosetta entry is therefore

```text
repository phrase                 native quantum-information object
multi-time intervention table  -> deterministic quantum comb / strategy
physical admissibility         -> positivity + recursive causal normalization
memory across cut k            -> coherent ancilla between teeth k and k+1
free classical side channel    -> positive-operator decomposition of the comb
quantum boundary cost          -> global comb memory-cost optimization
composition                    -> link product, not ordinary matrix product
```

This makes one present boundary sharper. The rational rank


\[
\operatorname{rank} T
\]

in `CAUSAL_MEMORY_SPACETIME` is exactly the unrestricted linear
factorization cost of a declared table. It is not automatically a quantum
memory lower bound, because an arbitrary table need not be the Choi operator
of a causally normalized positive process, and ordinary rank does not encode
the allowed positive decomposition with free classical branches. Conversely,
the comb memory cost cannot be reconstructed by replacing each cut with an
independently minimized scalar.

## What remains untranslated

The repository's deterministic action/observation tables do not yet specify
quantum input and output spaces at each time, a positive comb operator, or its
causal trace equations. Until those are supplied, “the quantum coordinate” is
not a number waiting to be computed; the quantum process itself has not been
formed. Once it is formed, the first exact task is to instantiate the existing
global criterion on that comb, not invent a generic `r_CP`.

This does not identify classical nonnegative rank, positive-semidefinite rank,
Choi rank, operator-Schmidt rank, and comb memory cost. They answer different
realization problems. The admissible morphisms and free resources decide which
one types.

## Source boundary

- Alessandro Bisio, Giacomo Mauro D'Ariano, Paolo Perinotti, and Michal
  Sedlak, “Memory cost of quantum protocols,” *Physical Review A* 85, 032333
  (2012), [arXiv:1112.3853](https://arxiv.org/abs/1112.3853). Audited at the
  abstract, introduction, memory-cost section, and conclusion. The paper
  explicitly states the global criterion and the failure of independent
  per-step optimization.
- Giulio Chiribella, Giacomo Mauro D'Ariano, and Paolo Perinotti,
  “Theoretical framework for quantum networks,” *Physical Review A* 80,
  022339 (2009), [arXiv:0904.4483](https://arxiv.org/abs/0904.4483), for combs,
  link products, and realization by memory channels.

Rigor boundary: the translation and no-local-optimization statement are cited
prior art. No repository comb has been constructed, no new quantum theorem is
claimed, and no empirical physics claim is made.
