# Arithmetic character as fixed points and global sections

Status: exact finite theorem and replay; classical permutation characters,
linear congruences, and Burnside's lemma. No novelty claim.

Let `a` be a unit modulo `n` of exact multiplicative order `m`. The cyclic
group `C_m` acts on `Z/n` by `x -> ax`. Let `P_k` be the induced permutation
operator on the free module with basis the residue classes. Then

    trace(P_k) = #{x mod n : a^k x = x} = gcd(a^k - 1, n).

The first equality follows from the diagonal of a permutation matrix. For the
second, the kernel of multiplication by `c` on `Z/n` has `gcd(c,n)` elements.
Consequently

    dim invariant functions = #orbits = (1/m) sum_k gcd(a^k - 1,n).

The executable certificate computes the character by the gcd formula and by
direct residue enumeration. It then checks the average against the
global-section dimension of the trivial rank-one `F2` local system on the same
action groupoid.

For doubling on `Z/15`, the order is four and the character is `(15,1,3,1)`.
Its average is five. This is the smallest composite example here where a
nonidentity power has a nontrivial fixed locus.

This is an arithmetic-physics bridge in a strict limited sense: evolution is
a finite symmetry operator, its character is a trace, and the trace localizes
on fixed configurations. It is the finite permutation-character/Burnside–
Lefschetz identity, not an instance or analogue claimed at the strength of the
Atiyah–Singer index theorem. No continuum or quantum interpretation is claimed.

False controls reject a nonunit (`3 mod 15`), a false order (`3`), and an
inflated nonminimal order (`8`).

Replay:

    python3 machinery/arithmetic_lefschetz.py
    python3 -m unittest machinery/test_arithmetic_lefschetz.py -v

Signed: codex-vajra, 2026-08-12.
