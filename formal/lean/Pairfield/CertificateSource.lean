import Pairfield.SmithContent

/-!
# A valid certificate recovers its source, so no deterministic reducer has an
irreducible quotient trace

question:

> does the full pair `(L,R)` determine the installed reducer's entire quotient
> trace on arbitrary two-by-two inputs, or can two distinct traces yield the
> same final `(L,D,R)`?  A collision would identify genuine irreducible
> operational history; absence would make the accumulators a complete
> extensional replay carrier.

The answer is *absence*, for every input, and the proof is one line once
`IntMat2.inv` is available: a unimodular matrix over `ℤ` has an **integral**
inverse, so `D = LAR` can be solved for `A`.

That the note verified injectivity only on the family `A_q = ((2,0),(2q+1,7))`
is not a shortcoming of its method; it is that the general statement does not
need the family at all, and does not need `A` to be invertible either — `L` and
`R` are what get inverted, and they always are.
-/

namespace Pairfield

/-- **Source recovery.**  A replay identity with unimodular transformations can
be solved backwards over `ℤ`. -/
theorem source_of_replay {A L D R : IntMat2}
    (hrep : D = L * A * R) (hL : L.unimodular) (hR : R.unimodular) :
    A = L.inv * D * R.inv := by
  rw [hrep]
  calc A = IntMat2.one * A * IntMat2.one := by
          rw [IntMat2.one_mul, IntMat2.mul_one]
    _ = (L.inv * L) * A * (R * R.inv) := by
          rw [IntMat2.inv_mul L hL, IntMat2.mul_inv R hR]
    _ = L.inv * (L * A * R) * R.inv := by
          simp only [IntMat2.mul_assoc]

/-- Every valid certificate determines its own source. -/
theorem SmithCertificate2.source_recovered (c : SmithCertificate2) (h : c.Valid) :
    c.source = c.left.inv * (IntMat2.diagonal c.d₁ c.d₂) * c.right.inv :=
  source_of_replay h.1 h.2.1 h.2.2.1

/-- **Maximum fiber one, on all inputs.**  Two valid certificates agreeing on
`(L, d₁, d₂, R)` have the same source; hence the certificate map of *any*
producer whose outputs are valid is injective on sources, and a deterministic
reducer's quotient trace — being a function of its input — is a function of its
own certificate.  There is no irreducible operational history to retain. -/
theorem SmithCertificate2.source_injective
    {c c' : SmithCertificate2} (h : c.Valid) (h' : c'.Valid)
    (hL : c.left = c'.left) (hR : c.right = c'.right)
    (h₁ : c.d₁ = c'.d₁) (h₂ : c.d₂ = c'.d₂) :
    c.source = c'.source := by
  rw [c.source_recovered h, c'.source_recovered h', hL, hR, h₁, h₂]

/-- Specialized to this producer: the emitted certificate replays its input
exactly, with no auxiliary record. -/
theorem smithCertificate_recovers (A : IntMat2) :
    A = (smith A).red.left.inv
        * (IntMat2.diagonal (smith A).d₁ (smith A).d₂)
        * (smith A).red.right.inv :=
  (smithCertificate A).source_recovered (smithCertificate_valid A)

/-- The stated witness family of `SMITH_ACCUMULATOR_TRANSCRIPT_NO_GO.md`, now a
special case rather than the evidence.  (`decide` on each instance; the general
statement above is what carries the claim.) -/
example : (smithCertificate ⟨2, 0, 1, 7⟩).check = true := smithCertificate_check _
example : (smithCertificate ⟨2, 0, 41, 7⟩).check = true := smithCertificate_check _

end Pairfield
