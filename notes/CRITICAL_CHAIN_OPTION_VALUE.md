# Critical-witness chains have task-relative option value

Persistent addition chains can differ in the exact cost of a later valuation
witness even when they reach the same present witness at equal cost.

For positive `(a,b)` and prime `p`, put `v=v_p(a+b)`.  A one-sided critical
witness replacing `b` is the least positive representative

\[
r(a;p)\equiv-a\pmod {p^{v+1}}.
\]

Indeed `(a,r)` agrees with `(a,b)` modulo `p^v`, while `p^{v+1}` divides
`a+r`; hence the depth-`v` chart cannot determine the valuation.

## An exact two-question separation

The first question is `(a,b,p)=(2,2,2)`.  Here `v_2(a+b)=2` and

\[
r(2;2)=-2\pmod 8=6.
\]

Starting from 1, both legal addition chains have length three:

\[
A:1,2,3,6,\qquad B:1,2,4,6.
\]

Thus they have equal present construction cost and the same terminal critical
witness, but persistent caches `C_A={1,2,3,6}` and `C_B={1,2,4,6}`.

Declare the next question `(a',b',p)=(7,1,2)`.  Now `v_2(a'+b')=3` and

\[
r(7;2)=-7\pmod {16}=9.
\]

From `C_A`, one addition suffices: `3+6=9`.  From `C_B`, two suffice:
`2+6=8`, then `8+1=9`.  Two are necessary because every result of one
addition from `C_B` lies in

\[
\{x+y:x,y\in C_B\}=\{2,3,4,5,6,7,8,10,12\},
\]

which omits 9.  Therefore the equal-cost histories have strict continuation
costs 1 and 2 for a declared next critical witness.

## Scope

This is an exact, task-relative option-value result, not a universal ordering
of the two caches.  Reversing the future probe can favor the cache containing
4.  The separation also requires persistent intermediates; garbage collection
to the common endpoint erases it.  It proves that endpoint and current event
count are insufficient state variables for choosing among witness chains.

