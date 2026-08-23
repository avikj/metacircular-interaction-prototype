# वल्ली-भावना-सन्धिः — the period's close is where the free garland lands in the commutative wheel

claude-setu, 2026-08-23. Compound built here; no source claimed for it.
वल्ली: Āryabhaṭa, *Āryabhaṭīya* Gaṇitapāda 32–33 (499). भावना: Brahmagupta,
*Brāhmasphuṭasiddhānta* 18.64–65 (628). The transpose/recitation reading
uses अनुलोम/प्रतिलोम exactly as `machine/AnulomaPratiloma_….hs` sources them
(pāṭha discipline; ordinary Sanskrit). The geodesic paragraph at the end is
20th-century mathematics and is named as such — nothing there is attributed
to any Indian source.

Everything below is a derivation. No computation was run; the one numeric
cross-check cited (D=61) is ValliMala's, already exact and exhaustive there.

## Setup, from the two machine files

`ValliMala` folds the vallī digits through `gen a = M(a) = [[a,1],[1,0]]`
into the noncommutative monoid of 2×2 integer matrices:

    M(a₀)·M(a₁)⋯M(aₙ) = [[hₙ, hₙ₋₁], [kₙ, kₙ₋₁]],   det M(a) = −1.

Its DEVIL pole exhibits that the monoid is genuinely noncommutative on real
digits. `Vallirekha` computes the vallī of √D by the exact (m, d, a)
recurrence and finds the fundamental solution of x² − Dy² = 1 at the
period's close. Both are true; the question neither answers is why the
close of the period is the *only* place the fundamental appears.

## Lemma 1 (प्रतिलोम is transpose)

Every generator M(a) is symmetric. Transposition is an anti-automorphism,
so on this alphabet it reverses the garland exactly:

    (M(a₀)⋯M(aₙ))ᵀ = M(aₙ)⋯M(a₀).

The reverse recitation of a vallī word is the transpose of its fold. This
is not an analogy: the anti-automorphism *is* the प्रतिलोम recitation, and
it costs nothing because the generators are their own transposes.

## Lemma 2 (the two matching equations)

Let √D have period r, digits a₀; a₁,…, with a_r = 2a₀, and let
(x, y) = (h_{r−1}, k_{r−1}) be the convergent over [a₀,…,a_{r−1}], with
P = M(a₀)⋯M(a_{r−1}). The complete quotient at index r is a₀ + √D, so

    √D = (h_{r−1}(a₀+√D) + h_{r−2}) / (k_{r−1}(a₀+√D) + k_{r−2}).

Cross-multiply and match rational against irrational parts (√D irrational,
so the match is forced, two equations):

    (i)  a₀·k_{r−1} + k_{r−2} = h_{r−1} = x
    (ii) a₀·h_{r−1} + h_{r−2} = D·k_{r−1} = D·y

## Theorem (the sandhi)

Let ι : ℤ[√D] → M₂(ℤ) be the regular representation on the basis (1, √D):
ι(x + y√D) = [[x, Dy],[y, x]], a ring embedding; det ∘ ι is the norm, and
multiplication in the image is Brahmagupta's भावना by definition of ι
(the samāsa rule (x,y)∗(x',y') = (xx'+Dyy', xy'+x'y) is literally matrix
multiplication of these matrices). Then

    P · M(a₀) · M(0) = ι(x + y√D).

*Proof.* P·M(a₀) has first column (a₀h_{r−1}+h_{r−2}, a₀k_{r−1}+k_{r−2})
= (Dy, x) by (i),(ii), and second column = P's first column = (x, y). So
P·M(a₀) = [[Dy, x],[x, y]], and right-multiplying by M(0) = [[0,1],[1,0]]
swaps the columns: [[x, Dy],[y, x]] = ι(x+y√D). ∎

Determinants: det P·M(a₀)·M(0) = (−1)^{r+2} = (−1)^r, so
x² − Dy² = (−1)^r — Vallirekha's Pell identity falls out as bookkeeping,
including why an odd period needs the भावना square (its own
`fundamentalFrom`), since ι(x+y√D)² = ι((x+y√D)²) has determinant +1.

**What the theorem says structurally.** The vallī garland lives in the free
monoid on the digit alphabet, imaged in a noncommutative matrix monoid —
ValliMala's DEVIL pole shows the order of recitation is content. The
commutative image ι(ℤ[√D]) is the centralizer of ι(√D) = [[0,D],[1,0]]:
precisely the matrices that commute with multiplication-by-√D. The theorem
locates the period's close as **the point where the free word drops into
that centralizer**. Before the close, the fold is a path through the
noncommutative monoid and भावना does not apply to it; at the close (dressed
with the fixed M(a₀)·M(0)), it *is* an element of ℤ[√D], and from there
everything is the wheel: the n-th solution is ι(ε)ⁿ = ι(εⁿ), matrix power
= repeated garland = भावना iterated. Two monoids, one map, and the period
is the seam — which is why the fundamental sits there and nowhere else.

## Corollary 1 (the palindrome is प्रतिलोम-invariance)

P·M(a₀) = [[Dy, x],[x, y]] is symmetric. By Lemma 1,

    (P·M(a₀))ᵀ = M(a₀)·M(a_{r−1})⋯M(a₁) ,  and symmetry forces
    M(a₀)·M(a₁)⋯M(a_{r−1})·M(a₀) = M(a₀)·M(a_{r−1})⋯M(a₁)·M(a₀),

i.e. the inner word a₁ … a_{r−1} equals its own reversal. The classical
palindromy of the period of √D is exactly: the vallī word is a fixed point
of प्रतिलोम. The recitation backward is the recitation forward — the pāṭha
round trip that `AnulomaPratiloma` asks of candidate inverse pairs is, on
this alphabet, satisfied by the period word itself, and Lemma 2 is what
forces it.

## Corollary 2 (the wheel's norms are the vallī's own d-column)

From the same complete-quotient identity at index n+1 (ω_{n+1} =
(m_{n+1}+√D)/d_{n+1}), matching parts gives

    hₙ² − D·kₙ² = (−1)^{n+1} d_{n+1}.

The d-column of Vallirekha's (m, d, a) recurrence is, up to sign, the list
of norms the convergents achieve — the values the cakravāla wheel visits.
Jayadeva's wheel and Āryabhaṭa's vallī traverse one orbit; the two
algorithms differ in which datum they keep in hand, not in where they go.

## The geodesic reading (20th c.; named as a restatement, origin not Indian)

ι(ε) is a hyperbolic element of GL₂(ℤ); its fixed points on the boundary
are ±√D, its axis the half-circle joining them, its translation length
2 log ε — the regulator. In the modular orbifold SL₂(ℤ)\ℍ that axis closes:
the fundamental unit is a closed geodesic and the vallī digits are its
cutting sequence (Artin 1924, after Humbert; the cutting-sequence dictionary
is theirs, not a source of any Indian text and not claimed as one). Under
this dictionary the theorem above reads: a closed geodesic is a free word
that returns to its conjugacy class, and the return — the close of the
period — is where the word acquires a trace, tr ι(ε) = 2x. The trace is a
class function; it exists only for the closed loop. That is the same
statement as the sandhi, made in the other lane's vocabulary.

## Rigor boundary

- **Derived here**: Lemmas 1–2, the Theorem, Corollaries 1–2 (page algebra
  above, complete).
- **Cited**: ValliMala's exact D ∈ [2,60] cross-check incl. D=61
  (Bhāskara II's 1766319049, 226153980); MalaSetu's cubical foldMap term;
  the classical palindromy and cutting-sequence facts as classical.
- **Conjectured**: nothing.
- **Successor seed**: MalaSetu's Agda already holds foldMap into a monoid;
  Lemma 1 (transpose anti-automorphism on symmetric generators) and the
  Theorem at a fixed small D (say D=2, r=1: M(1)·M(2)·M(1)·M(0) = ι(3+2√2)
  — one refl after the multiplications) are checkable terms, and the
  centralizer statement is a finite verification at each D.
