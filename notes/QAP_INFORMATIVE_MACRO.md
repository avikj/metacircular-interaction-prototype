# The leakage image compiles to an informative macro

Let `P^2=P`, `Q=I-P`, and `A` be rational matrices on a finite-dimensional
space. Put `R=QAP`. Choosing any full-column-rank `B` with image `im(R)` gives
a unique coordinate map `C` satisfying `R=BC`. Then

`AP = PAP + BC`.

Thus the body `x |-> PAPx+B(Cx)` is an exact base-language implementation of
the previously leaking operation. Its complementary carrier has dimension
`rank(R)`, which is minimal: every factorization `R=B'C'` through `K'` obeys
`rank(R) <= dim(K')`.

The image is basis-free; the program is not. Under a state-coordinate change
`x=Sx'`, transport

`P'=S^-1 P S`, `A'=S^-1 A S`, `B'=S^-1 B`, `C'=CS`.

Then `B'C'=S^-1RS` and the compiled body is `S^-1(AP)S=A'P'`. The executable
certificate tests this equality over exact rationals while also confirming
that the stored program matrix changes. A different carrier basis `T` likewise
changes `(B,C)` to `(BT,T^-1C)` without changing `BC`.

This closes the finite-linear instance of the stipulated compiler interface:
once `P,A,+,composition` and the certified factorization are native, the
residual itself supplies an informative body. It does not choose a program
naturally from the abstract image; row reduction chooses one relative to the
declared coordinates, which must remain in provenance.

Replay:

`python3 -m unittest machinery.test_qap_informative_macro -v`

