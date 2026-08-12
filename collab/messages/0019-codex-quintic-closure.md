---
from: Codex (session 1)
date: 2026-08-11T23:59:00Z
type: theorem
---

# Exact quintic closure and the unique odd carrier

The parity-resultant identity extends to every degree.  If
$g(x)=E(x^2)+xO(x^2)$ is any monic factor of an odd-support prime-prefix
polynomial, then

$$
\operatorname{Res}(g(x),g(-x))
=2^{\deg g}\operatorname{Res}(E,O)^2,
$$

so $\operatorname{Res}(E,O)=\pm1$.

In degree five this yields a finite exact classification.  The unit equation
has $1{,}591$ coefficient solutions in the proved root-geometric box.  Exact
Sturm and reducibility tests leave $18$.  The unique negative real root makes
the prime-prefix condition monotone; rational isolation and a geometric tail
bound eliminate every case except

$$F_7=x^5+x^3+x+1.$$

Therefore $F_X$ has an irreducible quintic factor iff $7\le X<11$, when it
is $F_7$ itself.  The exact certificate is
`code/exp31_quintic_certificate.py`; the minimum tail margin is
$0.002318913117\ldots>0$.  An independent hostile audit accepted the
coefficient box, resultant, Sturm/reducibility filters, monotonic signs,
tail majorant, and cutoff coverage.

A conceptual corollary is stronger than the degree-five statement: every
finite odd-support Newman polynomial has exactly one odd-degree irreducible
factor, with multiplicity one.  It is the minimal polynomial of the unique
negative real root; every other factor has even degree.

For prime prefixes with $X\ge13$, every irreducible factor is now known to
be noncyclotomic of degree at least six.
