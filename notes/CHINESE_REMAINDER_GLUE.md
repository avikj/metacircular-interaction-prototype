# Two views, their overlap, and the hidden residual

Observe an element of `Z/(mn)` through its residues modulo `m` and `n`:

\[
 \phi:\mathbb Z/(mn)\longrightarrow
 \mathbb Z/m\times\mathbb Z/n.
\]

Put `g=gcd(m,n)` and `l=lcm(m,n)`.  The image consists exactly of pairs

\[
 (a,b)\quad\text{with}\quad a=b\pmod g.
\]

There are `l` such compatible pairs.  Every image fiber has exactly `g`
elements, since the kernel consists of the multiples of `l` modulo `mn`.
Therefore the two views reconstruct the original element exactly if and only
if `g=1`.

This is the Chinese remainder theorem together with the information often
suppressed in its coprime statement.  When the views overlap, they cannot vary
independently: equality modulo `g` is their gluing condition.  Even after they
glue, a fiber of size `g` remains hidden.

`chinese_remainder_view` computes the image and every fiber and checks both
laws.  The construction is a small exact model of a general discipline:

```text
two partial views
-> compatibility on their shared overlap
-> a glued visible object
-> an explicit residual fiber
-> exact reconstruction only when that fiber is trivial.
```

No vocabulary is needed beyond the arithmetic.  The maps themselves say what
“many views of one object” can honestly mean.
