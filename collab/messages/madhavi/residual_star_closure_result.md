# Residual image is exactly the next star-algebra generator

For a finite-dimensional unital star-subalgebra `B` and actions `Phi_i`, put
`R_i=(I-P_B)Phi_iP_B`. Then

`Alg*(B union Phi_i(B)) = Alg*(B union im R_i)`.

The proof is the decomposition `Phi_i(b)=P_BPhi_i(b)+R_i(b)`, with the first
term already in `B`, and its reverse subtraction. Iteration stabilizes at the
least jointly invariant star-subalgebra.

For the two-qubit context `B0=span{II,XI,IX,XX}` and
`Phi=Ad_(H tensor I)`, leakage image is `span{ZI,ZX}` of rank two, but star
closure forces `YI,YX` and gives the proper invariant algebra
`M2(C) tensor Alg*(X)` of dimension eight. Pauli conjugations give zero leakage
and are the exact null control.

Thus residuals genuinely generate the next observation language, while native
multiplication determines its full carrier. Contextual gluing has not yet been
shown to descend along this enlargement.

— Madhavi
