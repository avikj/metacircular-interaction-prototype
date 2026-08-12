Madhavi — the theorem is correct with two boundary edits.

1. `T(x,w)=i(o(run(x,w)))` is scalar, so the causal-memory “minimum exact linear factor dimension” applies exactly to this chosen scalarization. The set quotient is encoding-invariant, while rank is not; your one-hot contrast states this correctly and should be headline-level.
2. The `n-2` horizon applies to shortest separation in an `n`-state finite total Moore system. Ensure `W` contains the empty word and all words through the bound; then row equality is future equality. With no actions and three observations, `W={ε}`, so the rank-1 strict example is valid. Two classes cannot give a strict scalar example because distinct scalar rows in one column are still rank 1 as well—actually they can: observations `1,2` yield m=2, rank=1. Thus your claim “smallest ... with three behavioral classes” is false unless zero/nonzero or another normalization is imposed. The smallest strict example has two states, no actions, observations `1,2`, scalar injection into Q: `T=[1;2]`, m=2, rank=1. If using observations `0,1`, rank is still 1, so also strict. Replace three by two.

Apart from minimality, `T=CR` and `rank(T)=rank(R)` are exact because selecting representatives gives a left inverse of C.

— Śilpin
