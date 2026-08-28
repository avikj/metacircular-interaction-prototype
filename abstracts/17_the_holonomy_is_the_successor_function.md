# THE HOLONOMY OF THE CIRCUIT IS THE SUCCESSOR FUNCTION, AS AN EQUALITY OF FUNCTIONS, AND IT IS INVISIBLE EXACTLY TO AN INVARIANT OBSERVABLE

*A computed holonomy, and a biconditional between invisibility and invariance with the converse costing nothing*

**Gauge structure / foundations of observability**

We give a discrete system with a loop at a base point, compute its holonomy exactly, and prove the general law relating what an observable sees to what it is invariant under - in both directions, with the second direction free for a reason that outlives the theorem.

The holonomy.  Traversing the circuit returns to the base point with the fibre shifted, so the loop acts on the fibre rather than trivially.  We do not merely prove the action nontrivial at a point.  We prove the action *is* the successor function on the integers, as an equality of functions, obtained by function extensionality from the pointwise shift.  The fibre is a torsor and the holonomy is the generator; the winding number is the integer it produces.

The law.  An observable is unmoved by transport along a symmetry if and only if it is invariant under that symmetry.  Invisibility and invariance are not two facts about an observable that happen to coincide - they are one condition read from two sides.  When the value type is a set the biconditional upgrades to an equivalence of the two conditions.  The converse direction cost nothing, and the reason is worth more than the statement: the two sides are joined by the computation rule for univalence, which is a path, and a path may be walked in either orientation.  An earlier form of the same audit, in which the sides were joined by an assumed implication, paid for its converse with enumerability and decidability hypotheses.  A path has an inverse; an implication does not.  So whether a converse is free is readable off the shape of what connects the two sides, before either direction is attempted.

Two witnesses keep the law from being vacuous.  The two-element symmetry is a genuine holonomy - we prove the transported value differs from the original by computing the transport, univalence's beta rule evaluating rather than being cited.  And one loop admits two verdicts: the raw interface is moved by it while an invariant observable is not, so both sides of the law are inhabited by the same loop and the biconditional has content on each.

The consequence for modelling.  An invariance imposed for physical reasons is exactly a blindness accepted, and the blind set is computable in advance from the invariance group.  A model that is invariant under a symmetry cannot represent that symmetry's holonomy - not approximately, not with more resolution.  The residue is recoverable only by changing the observable, never by refining it.

WHAT IS NOT CLAIMED.  There is no lattice, no gauge group, no connection form, no Wilson loop and no field in this development.  The system is a discrete circuit with an integer fibre; "holonomy" names the action of the loop on that fibre, and "observable" names a function out of the state. The physical reading is a reading and is not proved.

Machine-checked in cubical type theory, no postulates, no admitted goals.
