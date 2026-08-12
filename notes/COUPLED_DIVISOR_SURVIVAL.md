# Exact coupled-divisor survival under a remaining budget

Let `r` coordinates remain, each in `[0,C]`, with sum `S`. For squarefree
divisors `d,e`, ask whether every suffix coordinate is divisible by `d` and
every complement is divisible by `e`.

**Theorem.** Solve
\[
a\equiv0\pmod d,\qquad a\equiv C\pmod e.                     \tag{1}
\]
There is no suffix unless `gcd(d,e)|C`. When compatible, let `a_0` be the
least nonnegative solution modulo `l=lcm(d,e)` and
`K=floor((C-a_0)/l)`. A suffix exists exactly when
\[
S\equiv r a_0\pmod l,qquad
0\le (S-r a_0)/l\le rK.                                      \tag{2}
\]

*Proof.* Every allowed coordinate is uniquely `a_0+l z_i` with
`0<=z_i<=K`. Their sum is `r a_0+l sum z_i`. Every integer from `0` to `rK`
is a sum of `r` integers in `[0,K]`, proving (2). CRT proves compatibility. ∎

Thus the feasibility-sensitive state is naturally the downward-closed set of
surviving divisor pairs `(d,e)`, not two independent prime sets. Individual
prime pruning is its coordinate shadow. This pair profile is sufficient to
know which common factors can persist jointly; global Myhill--Nerode
minimality is not claimed.

