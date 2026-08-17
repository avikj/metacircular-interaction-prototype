# Unbuilt mathematics in `collab/upstream/`, and what has been built

Left column: a construction stated somewhere in the corpus. Right column: where
it is checked, or **nothing**. No grades, no process, no ranking — a row is
worth building because the mathematics holds up, and a row moves to a filename
when a checker accepts it. Neither column is a claim about who wrote anything.

| construction | checked in |
|---|---|
| Coordination Kernel §7, K2 local serialization | `formal/cubical/Coordination/Serialization.agda` — semantic half checked; combinatorial half is an un-inhabited record |
| EGB Factory IV Thm 58 (parity projector on the Chen envelope) | `formal/cubical/NaturalMachine/ChenProjector.agda` |
| EGB Factory IV §XI (projectors commute, information does not) | `formal/cubical/NaturalMachine/CornerProjectors.agda` |
| EGB Factory IV §X Thm 70 (mixed-corner descent) | `formal/cubical/NaturalMachine/MixedCornerDescent.agda` |
| EGB Factories VIII/IX skeleton (three channels, μ²−π₁) | `formal/cubical/NaturalMachine/ThreeChannels.agda` |
| Coordination Theorems 534/680 (SafeMod) | **nothing** |
| Coordination Kernel §56 (CertifiedRel, composition) | **nothing** |
| Coordination Kernel §38 (coordination compiler) | **nothing** |
| DSO: Isbell nucleus, quantale residuation, min-plus rank | **nothing** |
| DSO item 130: Chu object, selection monad, proof-relevant Bellman | **nothing** |
| Knowledge geometry Δ08 Thm 1 (install law, cone, redundancy gate) | **nothing** (prose only, `notes/PROOF_METRIC_COMPILER.md`) |
| Sufficient interfaces Δ01 (Suff, κ₀, the nerve, the join failure) | `formal/cubical/NaturalMachine/SufficientInterfaces.agda` — T1, T4, T7, T12, T13, P6, T8 checked; T3's NP-hardness not formalized (it is a claim about computing with the relation, not about the relation) |
| Sufficient interfaces Δ02–03 (τ*, C∞) | **nothing** |
| Proof-carrying relations Δ04 (V_R, evidence grades) | **nothing** |
| Circulation claim graph + typed edges | **nothing** (repo's own registry is broken: 12 of 49 packets fail their invariants) |
| GTER Δ37/38 | source text not exported |
| DSO Δ26–30 full texts | source text not exported |
