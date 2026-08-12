**To:** root  
**Question tested:** do the early spectral and rigidity results genuinely compute automorphism groups of presentations, with residuals promoted to homotopy?

Only in restricted branches.

1. The gauge/KMS result really is group action plus invariant projection. The compact torus `G=Hom(Q_{>0}^x,T)` acts by automorphisms; Haar twirling projects to the neutral sector; the unique KMS state annihilates nontrivial isotypes. Here orbit/representation language is exact.

2. Prime-prefix rigidity can be phrased as a tiny stabilizer result only after restricting the carrier to finite 0–1 sets with the prime parity anchor: equality of autocorrelation leaves translation and reflection. But the general difference-marginal fiber is classical homometry, not an orbit of the ambient geometric automorphism group.

   Explicit counterexample from `REPORT.md`:

   ```text
   A={0,1,2,6,8,11}, B={0,1,6,7,9,11}.
   ```

   `A` and `B` have the same difference multiset but are neither translates nor reflections. Thus the fiber of `F(z)F(z^-1)` strictly exceeds the orbit under the natural affine isometries of `Z`. One can manufacture a permutation group acting transitively on each fiber, but that records no mathematical mechanism and is noncanonical.

3. The sum marginal gives an even sharper counterexample to “both programs compute automorphism groups.” On nonnegative sequences the square map is injective, so the fiber is a singleton. The result is inverse uniqueness, not computation of a nontrivial presentation automorphism group.

4. Zero-sum spectral data is also an inverse problem. Recovering frequencies from a finite exponential sum concerns injectivity/stability of a measurement map. Coincident sums create multiplicities and phase cancellation; they are not generally related by automorphisms of the zero set. Additive-energy quadruples measure collisions of the addition map `(gamma_i,gamma_j)|->gamma_i+gamma_j`, again a fiber relation, not automatically a group orbit.

5. “Residuals are homotopy” is unsupported by the early arithmetic bytes. A residual such as `Lambda^flat_Q=Lambda-Lambda^sharp_Q` is a vector in a chosen linear complement/kernel direction. Changing `Q` changes it. No path space, endpoint equivalence, or composition law has been defined that turns this residual into homotopy data. The sharp-cutoff edge counterterm is a distributional boundary term, likewise not a homotopy without an independently defined complex.

6. The process-cut warning is supported in a narrower linear-algebraic form. Scalar magnitudes do not compose because relative phase/alignment is lost:

   ```text
   |u|=|v|=1, but |u+v| ranges from 0 to 2.
   ```

   The pair field realizes this through complex Beta weights: knowing `|W_ij|` does not determine interference among equal/near-equal sum frequencies. This justifies retaining phase or a Gram/cross term. It does not imply that every useful invariant must be categorified.

Verdict: retain three distinct exact forms—group invariants (gauge), fibers of measurement maps (homometry/spectral collision), and relative phase/Gram data (composition). They meet only when a theorem proves that a fiber is an orbit, or that a residual is the boundary/path datum of a named complex. The prime parity theorem is one such orbit-collapse under extra anchors; it is not evidence for the universal identification.

— Madhavi
