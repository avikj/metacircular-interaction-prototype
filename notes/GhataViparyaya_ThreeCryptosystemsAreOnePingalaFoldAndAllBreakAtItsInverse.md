# घात-विपर्यय — three cryptosystems are one Piṅgala fold, and all break at its inverse

**Terms.** घात (ghāta), power — Piṅgala's word for the doubling-and-squaring
count (*Chandaḥśāstra* 8.28–31). विपर्यय (viparyaya), inversion/reversal —
here the inverse map, the discrete logarithm. Compound built here from two
ordinary words; no sūtra claimed for it.

**Rigor boundary.** The five modules named below are checked Agda
(`--cubical --safe`, no postulates, no holes), landed on `main` 2026-08-23.
The dates and attributions are cited history, flagged from-memory where
egress is blocked. The security assumptions (discrete-log hardness) and the
quantum step (Shor's order-finding) are stated, not proved — and the notes
say so at each site.

---

## One map

घ ात g n = g raised to n, computed as a fold: g ⋆ (g ⋆ (… ⋆ ε)), n times.
Piṅgala computed it in log₂ n steps, not n, by mixing squaring and doubling;
Halāyudha (*Mṛtasañjīvanī*, 10th c.) named the two markers śūnya and dvi,
and those markers are the binary digits of n
(`PingalaGhata.agda`, checked). The map is a monoid homomorphism from the
free monoid to any monoid: `MalaSetu` proves the general law, and घात is its
one-letter-alphabet instance, the vallī trace of Āryabhaṭa and Brahmagupta
its digit-alphabet instance. One homomorphism, differing only in the
alphabet.

## Three protocols on that one map

- **RSA (1977).** Encryption is घ ात mod n; the private key d satisfies
  e·d ≡ 1 (mod φ), which is exactly Āryabhaṭa's kuṭṭaka witness
  a·x ≡ b·y + 1 with g = 1 (*Āryabhaṭīya*, gaṇitapāda 32–33, 499 CE). So
  the RSA keypair is the pulverizer's output, and decryption is Piṅgala's
  fold. `Bijamula` reduces correctness to the two power laws plus one
  hypothesis, घ ात x φ ≡ ε; `BijamulaKrida` runs a concrete keypair in the
  cyclic group where the fold computes.

- **Diffie–Hellman (1976).** The shared secret is घ ात g (a·b), reached by
  Alice as (gᵃ)ᵇ and by Bob as (gᵇ)ᵃ. They agree because g^(ab) = g^(ba) —
  Piṅgala's घ ात-गुणः closing on a·b = b·a (`Samvit`, checked). Correctness
  is that one exponent law and the commutativity of multiplication.

- **Bhāvanā (628).** Not a cryptosystem — the reason the trace is the same
  fold. Brahmagupta's composition law (*Brāhmasphuṭasiddhānta*) generates
  the orbit whose replay `KuttakaValli.replayHom` is `MalaSetu`'s
  homomorphism at the digit alphabet. The settlement algebra Europe filed
  as a lemma about Pell is the same map that carries RSA.

## One break

The security of all three rests on घ ात being one-way: given g and घ ात g a,
recover a — the discrete logarithm, विपर्यय, the inverse of the fold. RSA's
one hypothesis (घ ात x φ ≡ ε) is discharged for free by knowing the order of
x; DH's one secret (a) is the discrete log outright. `Bijamula` §4 and
`Samvit` §4 state the reduction: an oracle for the exponent lifts RSA and
breaks DH from public data alone. That oracle is order-finding — the one
step a classical machine is not known to do in polynomial time, and the one
Shor's quantum algorithm does. So the three cryptosystems are one Piṅgala
fold, and they fail at one point: its inverse.

## Provenance, in order

The mechanism is datable. The count that runs the exponentiation is
Piṅgala's, ~300 BCE. The witness that manufactures the key is Āryabhaṭa's,
499. The composition that runs the trace is Brahmagupta's, 628. The
protocols that assemble these into public-key cryptography are 1976–1977.
Writing "RSA exponentiation" or "square-and-multiply" for the first, "the
extended Euclidean algorithm" for the second, is naming the restatement and
dropping the source by a millennium and a half. The checked modules carry
the source in their headers; this note carries it in the reading order the
book keeps — earliest first, restatement named as restatement.

*What would change this: a term-level identity `replay ≡ foldMap L` across
the module boundary (stated at clause level in `MalaSetu`, not yet a checked
cross-module equality); a proof of Euler's घ ात x φ ≡ ε in general
(currently a hypothesis, deliberately isolated); a `_mod_` that computes at
scale (the library's exhausts the heap at n=33). Each is named owed in its
module.*
