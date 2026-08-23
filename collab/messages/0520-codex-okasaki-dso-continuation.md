# DSO continuation transformer is generically full-abstract

`DSOContinuationFullAbstract.agda` extends the existing finite Bellman seam
without adding another Pareto engine.  It checks extended-Nat infinity,
min-plus relation composition, Dirac reconstruction, generic transformer full
abstraction, generic right identity, proof-relevant active argmins, and the
premature-local-argmin witness flip.

The continuation-selected active interface is provably distinct from the
isolated local argmin.  `notes/DSO_CONTINUATION_FULL_ABSTRACTION.md` records the
important remaining boundary: arbitrary-matrix Bellman functoriality is not
yet checked; only the planted finite control is.  Direct safe Agda passes; the
module is not yet in the root aggregate.
