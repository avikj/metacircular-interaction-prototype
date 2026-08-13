"""What the collective-token view of a Petri net forgets, exactly.

`notes/STATEBOX.md` §7 posed a `PROVE` item and guessed an answer: that the
fibre of the map

    individual-token executions  --q-->  collective-token executions

is the orbit of a *boundary* permutation group, so that the only thing lost
when tokens stop having identities is the labelling of the tokens present at
the start and the end.  This module contains the exact objects that decide
that guess.  It is refuted: the collective quotient identifies executions with
different causal structure, not merely different boundary labels.

Two exact instruments, no measurement anywhere:

1. **A derivation checker for the equational theory of strict commutative
   monoidal categories** (`check_derivation`).  A commutative monoidal
   category is a symmetric strict monoidal category whose symmetry *is* the
   identity; that is the collective-token semantics of a net (Meseguer and
   Montanari's `T[N]`; Master's left adjoint).  Naturality of an identity
   symmetry forces `f (x) g = g (x) f` on *morphisms* -- axiom `COMM` below --
   and that axiom is what does all the damage.  Each step of a derivation is
   checked to be a typed instance of a named axiom applied at a named
   position; nothing is searched for and nothing is assumed.

2. **The thread model `W`** (`interpret_threads`), a strict symmetric monoidal
   category in which a morphism records, for each incoming token, the word of
   transitions that token traverses and the outgoing position it lands on.
   Any assignment of generators extends to a strict symmetric monoidal functor
   `Phi` from the free symmetric strict monoidal category, so two executions
   with different `Phi`-images are different individual-token executions.  `W`
   is the *individual* token philosophy made computable: it is exactly the
   information that a token keeps its identity.

The headline pair, for the net with one place `s` and two transitions
`t1, t2 : s -> s`, both executions running from the marking `2s` to `2s`:

    f = (t1 ; t1) (x) (t2 ; t2)      one token fires t1 twice, the other t2 twice
    g = (t1 ; t2) (x) (t2 ; t1)      each token fires t1 then t2, in opposite order

`Phi` separates them, and separates `g` from all four boundary-permutation
variants of `f`, so they are distinct individual-token executions lying in
distinct boundary orbits.  `COLLECTIVE_IDENTIFICATION` is a three-step checked
derivation of `f = g` in the commutative theory.  Hence the fibre is strictly
larger than a boundary orbit, and the guess is dead.

`CAUSAL_COLLAPSE` is the same phenomenon in its starkest form: for `u : s -> s`,

    (u ; u) (x) id_s  =  u (x) u

collectively -- "one token fires twice" and "two tokens fire once each" are the
same collective execution.  What survives the quotient is the multiset of
transition occurrences; what dies is which token did what.

Everything here is exact: terms, typed rewriting, and finite words.
"""

from __future__ import annotations

from typing import Dict, List, Sequence, Tuple

# ------------------------------------------------------------------ signature

Word = Tuple[str, ...]
Term = tuple  # ('id', w) | ('gen', name) | ('sym', w1, w2) | ('comp', f, g) | ('tens', f, g)
Signature = Dict[str, Tuple[Word, Word]]


class TypeError_(Exception):
    """A term is not well typed over the declared signature."""


class DerivationError(Exception):
    """A derivation step is not a typed instance of the axiom it claims."""


def idm(w: Word) -> Term:
    return ("id", tuple(w))


def gen(name: str) -> Term:
    return ("gen", name)


def sym(w1: Word, w2: Word) -> Term:
    return ("sym", tuple(w1), tuple(w2))


def comp(f: Term, g: Term) -> Term:
    """`f` then `g` (diagrammatic order)."""
    return ("comp", f, g)


def tens(f: Term, g: Term) -> Term:
    return ("tens", f, g)


# ---------------------------------------------------------------- typing

def _key(w: Word, collective: bool) -> Word:
    """Objects of the free symmetric category are words; of the commutative
    one, multisets.  Sorting is the projection between them."""
    return tuple(sorted(w)) if collective else tuple(w)


def dom_cod(t: Term, sig: Signature, collective: bool = False) -> Tuple[Word, Word]:
    """Domain and codomain of a term, or raise `TypeError_`."""
    kind = t[0]
    if kind == "id":
        w = _key(t[1], collective)
        return w, w
    if kind == "gen":
        if t[1] not in sig:
            raise TypeError_(f"undeclared generator {t[1]!r}")
        d, c = sig[t[1]]
        return _key(d, collective), _key(c, collective)
    if kind == "sym":
        w1, w2 = t[1], t[2]
        return _key(w1 + w2, collective), _key(w2 + w1, collective)
    if kind == "comp":
        d1, c1 = dom_cod(t[1], sig, collective)
        d2, c2 = dom_cod(t[2], sig, collective)
        if c1 != d2:
            raise TypeError_(f"composite mismatch: {c1} vs {d2}")
        return d1, c2
    if kind == "tens":
        d1, c1 = dom_cod(t[1], sig, collective)
        d2, c2 = dom_cod(t[2], sig, collective)
        return _key(d1 + d2, collective), _key(c1 + c2, collective)
    raise TypeError_(f"unknown term head {kind!r}")


def is_typed(t: Term, sig: Signature, collective: bool = False) -> bool:
    try:
        dom_cod(t, sig, collective)
        return True
    except TypeError_:
        return False


# --------------------------------------------------- the commutative theory

#   INTERCHANGE  (f (x) g) ; (h (x) k)  =  (f ; h) (x) (g ; k)
#   UNIT_L       id ; f                 =  f
#   UNIT_R       f ; id                 =  f
#   TENS_ID      id_a (x) id_b          =  id_{a+b}
#   COMM         f (x) g                =  g (x) f
#
# COMM is not an extra assumption: in a commutative monoidal category the
# symmetry is the identity, and naturality of the symmetry reads
# sigma ; (g (x) f) = (f (x) g) ; sigma, which with sigma = id is COMM.
# It is the only axiom below that fails in the symmetric (individual-token)
# theory, which is why withholding it is the control in the tests.

AXIOMS = ("INTERCHANGE", "UNIT_L", "UNIT_R", "TENS_ID", "COMM")


def _rewrite_here(t: Term, axiom: str, forward: bool, sig: Signature) -> Term:
    """Apply one axiom at the root of `t`, in the stated direction."""
    if axiom == "COMM":
        if t[0] != "tens":
            raise DerivationError("COMM applies to a tensor")
        return tens(t[2], t[1])

    if axiom == "INTERCHANGE":
        if forward:
            # (f (x) g) ; (h (x) k)  ->  (f ; h) (x) (g ; k)
            if t[0] != "comp" or t[1][0] != "tens" or t[2][0] != "tens":
                raise DerivationError("INTERCHANGE-> wants (a (x) b) ; (c (x) d)")
            f, g = t[1][1], t[1][2]
            h, k = t[2][1], t[2][2]
            out = tens(comp(f, h), comp(g, k))
        else:
            # (f ; h) (x) (g ; k)  ->  (f (x) g) ; (h (x) k)
            if t[0] != "tens" or t[1][0] != "comp" or t[2][0] != "comp":
                raise DerivationError("INTERCHANGE<- wants (a ; b) (x) (c ; d)")
            f, h = t[1][1], t[1][2]
            g, k = t[2][1], t[2][2]
            out = comp(tens(f, g), tens(h, k))
        if not is_typed(out, sig, collective=True):
            raise DerivationError("INTERCHANGE instance is ill-typed")
        return out

    if axiom in ("UNIT_L", "UNIT_R"):
        want_left = axiom == "UNIT_L"
        if forward:
            if t[0] != "comp":
                raise DerivationError(f"{axiom}-> wants a composite")
            side, other = (t[1], t[2]) if want_left else (t[2], t[1])
            if side[0] != "id":
                raise DerivationError(f"{axiom}-> wants an identity on that side")
            d, c = dom_cod(other, sig, collective=True)
            if side[1] != (d if want_left else c):
                raise DerivationError(f"{axiom}-> identity has the wrong object")
            return other
        d, c = dom_cod(t, sig, collective=True)
        return comp(idm(d), t) if want_left else comp(t, idm(c))

    if axiom == "TENS_ID":
        if forward:
            if t[0] != "tens" or t[1][0] != "id" or t[2][0] != "id":
                raise DerivationError("TENS_ID-> wants id (x) id")
            return idm(_key(t[1][1] + t[2][1], True))
        raise DerivationError("TENS_ID<- needs a split point; not supported")

    raise DerivationError(f"unknown axiom {axiom!r}")


def _at(t: Term, path: Sequence[int]) -> Term:
    for i in path:
        t = t[i + 1]
    return t


def _replace(t: Term, path: Sequence[int], new: Term) -> Term:
    if not path:
        return new
    i = path[0]
    parts = list(t)
    parts[i + 1] = _replace(t[i + 1], path[1:], new)
    return tuple(parts)


def step(t: Term, path: Sequence[int], axiom: str, forward: bool,
         sig: Signature, allowed: Sequence[str] = AXIOMS) -> Term:
    """One checked rewrite of `t` at `path`.  Raises unless it is a typed
    instance of `axiom`, and `axiom` is in the permitted set."""
    if axiom not in allowed:
        raise DerivationError(f"axiom {axiom!r} is not permitted here")
    before, after = dom_cod(t, sig, collective=True)
    sub = _at(t, path)
    out = _replace(t, path, _rewrite_here(sub, axiom, forward, sig))
    if dom_cod(out, sig, collective=True) != (before, after):
        raise DerivationError("rewrite changed the boundary")
    return out


def check_derivation(start: Term, steps: Sequence[Tuple[Sequence[int], str, bool]],
                     target: Term, sig: Signature,
                     allowed: Sequence[str] = AXIOMS) -> List[Term]:
    """Replay a derivation `start = ... = target`, checking every step.

    Returns the full chain of terms.  Raises `DerivationError` on the first
    illegitimate step, and if the chain does not end at `target`.
    """
    chain = [start]
    t = start
    for path, axiom, forward in steps:
        t = step(t, path, axiom, forward, sig, allowed)
        chain.append(t)
    if t != target:
        raise DerivationError(f"derivation ended at {t!r}, not {target!r}")
    return chain


# ------------------------------------------------------- the thread model W

# A morphism of W on n strands is (perm, labels): strand i enters at position
# i, leaves at position perm[i], and traverses the word labels[i].  This is a
# strict symmetric monoidal category (proof in notes/TOKEN_PHILOSOPHY.md);
# interpreting a term in it is the strict symmetric monoidal functor Phi.

Thread = Tuple[Tuple[int, ...], Tuple[str, ...]]


def w_id(n: int) -> Thread:
    return tuple(range(n)), ("",) * n


def w_sym(n: int, m: int) -> Thread:
    return tuple(list(range(m, m + n)) + list(range(m))), ("",) * (n + m)


def w_tens(a: Thread, b: Thread) -> Thread:
    pa, la = a
    pb, lb = b
    return tuple(list(pa) + [len(pa) + j for j in pb]), tuple(list(la) + list(lb))


def w_comp(a: Thread, b: Thread) -> Thread:
    """`a` then `b`."""
    pa, la = a
    pb, lb = b
    if len(pa) != len(pb):
        raise TypeError_("thread composite mismatch")
    return (tuple(pb[pa[i]] for i in range(len(pa))),
            tuple(la[i] + lb[pa[i]] for i in range(len(pa))))


def interpret_threads(t: Term, sig: Signature) -> Thread:
    """`Phi(t)`.  Requires every place to be the same single place and every
    generator to be unary, which is where the thread picture is exact."""
    kind = t[0]
    if kind == "id":
        return w_id(len(t[1]))
    if kind == "gen":
        d, c = sig[t[1]]
        if len(d) != 1 or len(c) != 1:
            raise TypeError_("thread model needs unary generators")
        return ((0,), (t[1],))
    if kind == "sym":
        return w_sym(len(t[1]), len(t[2]))
    if kind == "comp":
        return w_comp(interpret_threads(t[1], sig), interpret_threads(t[2], sig))
    if kind == "tens":
        return w_tens(interpret_threads(t[1], sig), interpret_threads(t[2], sig))
    raise TypeError_(f"unknown term head {kind!r}")


def thread_multiset(t: Term, sig: Signature) -> Tuple[str, ...]:
    """The boundary-blind part of `Phi`: which words are traversed, by whom
    unrecorded.  Invariant under the boundary permutation action, so it is the
    sharp instrument for asking whether two executions lie in one orbit."""
    return tuple(sorted(interpret_threads(t, sig)[1]))


def occurrences(t: Term, sig: Signature) -> Tuple[str, ...]:
    """The multiset of transition occurrences: what the collective view keeps."""
    kind = t[0]
    if kind == "gen":
        return (t[1],)
    if kind in ("comp", "tens"):
        return tuple(sorted(occurrences(t[1], sig) + occurrences(t[2], sig)))
    return ()


def boundary_orbit(t: Term, sig: Signature, w: Word) -> List[Term]:
    """The four executions obtained from `t` by relabelling the two boundary
    tokens of a two-token marking: id/swap before, id/swap after."""
    s = sym(w[:1], w[1:])
    return [t, comp(s, t), comp(t, s), comp(s, comp(t, s))]


# ------------------------------------------------------ the decided instance

SIG_TWO: Signature = {"t1": (("s",), ("s",)), "t2": (("s",), ("s",))}
SIG_ONE: Signature = {"u": (("s",), ("s",))}

T1, T2, U = gen("t1"), gen("t2"), gen("u")
SS: Word = ("s", "s")

#   f = (t1 ; t1) (x) (t2 ; t2)   and   g = (t1 ; t2) (x) (t2 ; t1)
F_EXEC = tens(comp(T1, T1), comp(T2, T2))
G_EXEC = tens(comp(T1, T2), comp(T2, T1))

# f = g collectively, in three checked steps.
COLLECTIVE_IDENTIFICATION: List[Tuple[Sequence[int], str, bool]] = [
    ((), "INTERCHANGE", False),   # (t1;t1) (x) (t2;t2)  ->  (t1 (x) t2) ; (t1 (x) t2)
    ((1,), "COMM", True),         #                      ->  (t1 (x) t2) ; (t2 (x) t1)
    ((), "INTERCHANGE", True),    #                      ->  (t1;t2) (x) (t2;t1)
]

#   (u ; u) (x) id_s  =  u (x) u  collectively, in six checked steps.
CAUSAL_COLLAPSE_START = tens(comp(U, U), idm(("s",)))
CAUSAL_COLLAPSE_TARGET = tens(U, U)
CAUSAL_COLLAPSE: List[Tuple[Sequence[int], str, bool]] = [
    ((1,), "UNIT_L", False),      # id -> id ; id
    ((), "INTERCHANGE", False),   # -> (u (x) id) ; (u (x) id)
    ((1,), "COMM", True),         # -> (u (x) id) ; (id (x) u)
    ((), "INTERCHANGE", True),    # -> (u ; id) (x) (id ; u)
    ((0,), "UNIT_R", True),       # -> u (x) (id ; u)
    ((1,), "UNIT_L", True),       # -> u (x) u
]


def report() -> str:
    lines = []
    chain = check_derivation(F_EXEC, COLLECTIVE_IDENTIFICATION, G_EXEC, SIG_TWO)
    lines.append(f"collective: f = g in {len(chain) - 1} checked steps")
    lines.append(f"  threads(f) = {thread_multiset(F_EXEC, SIG_TWO)}")
    lines.append(f"  threads(g) = {thread_multiset(G_EXEC, SIG_TWO)}")
    orbit = boundary_orbit(F_EXEC, SIG_TWO, SS)
    lines.append("  g in boundary orbit of f: "
                 f"{thread_multiset(G_EXEC, SIG_TWO) in [thread_multiset(x, SIG_TWO) for x in orbit]}")
    chain = check_derivation(CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE,
                             CAUSAL_COLLAPSE_TARGET, SIG_ONE)
    lines.append(f"collapse: (u;u)(x)id = u(x)u in {len(chain) - 1} checked steps")
    lines.append(f"  threads((u;u)(x)id) = {thread_multiset(CAUSAL_COLLAPSE_START, SIG_ONE)}")
    lines.append(f"  threads(u(x)u)      = {thread_multiset(CAUSAL_COLLAPSE_TARGET, SIG_ONE)}")
    lines.append(f"  occurrences agree:   {occurrences(CAUSAL_COLLAPSE_START, SIG_ONE) == occurrences(CAUSAL_COLLAPSE_TARGET, SIG_ONE)}")
    return "\n".join(lines)


if __name__ == "__main__":
    print(report())
