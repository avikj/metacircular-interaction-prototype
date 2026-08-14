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

#   ASSOC_COMP   (f ; g) ; h            =  f ; (g ; h)
#   ASSOC_TENS   (f (x) g) (x) h        =  f (x) (g (x) h)
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

AXIOMS = ("ASSOC_COMP", "ASSOC_TENS", "INTERCHANGE", "UNIT_L", "UNIT_R",
          "TENS_ID", "COMM")


def _rewrite_here(t: Term, axiom: str, forward: bool, sig: Signature,
                  param: int = 1) -> Term:
    """Apply one axiom at the root of `t`, in the stated direction."""
    if axiom == "COMM":
        if t[0] != "tens":
            raise DerivationError("COMM applies to a tensor")
        return tens(t[2], t[1])

    if axiom in ("ASSOC_COMP", "ASSOC_TENS"):
        head = "comp" if axiom == "ASSOC_COMP" else "tens"
        build = comp if head == "comp" else tens
        if forward:   # (a . b) . c  ->  a . (b . c)
            if t[0] != head or t[1][0] != head:
                raise DerivationError(f"{axiom}-> wants a left-nested {head}")
            a, b, c = t[1][1], t[1][2], t[2]
            return build(a, build(b, c))
        if t[0] != head or t[2][0] != head:
            raise DerivationError(f"{axiom}<- wants a right-nested {head}")
        a, b, c = t[1], t[2][1], t[2][2]
        return build(build(a, b), c)

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
        # id_w  ->  id_{w[:k]} (x) id_{w[k:]}, the split point given by `param`
        if t[0] != "id":
            raise DerivationError("TENS_ID<- wants an identity")
        w = t[1]
        if not 0 <= param <= len(w):
            raise DerivationError("TENS_ID<- split point out of range")
        return tens(idm(w[:param]), idm(w[param:]))

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
         sig: Signature, allowed: Sequence[str] = AXIOMS, param: int = 1) -> Term:
    """One checked rewrite of `t` at `path`.  Raises unless it is a typed
    instance of `axiom`, and `axiom` is in the permitted set."""
    if axiom not in allowed:
        raise DerivationError(f"axiom {axiom!r} is not permitted here")
    before, after = dom_cod(t, sig, collective=True)
    sub = _at(t, path)
    out = _replace(t, path, _rewrite_here(sub, axiom, forward, sig, param))
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


# ------------------------------------------------- the spectator model X
#
# Does the collective category retain anything beyond the multiset of
# occurrences?  Yes, and exactly where one would not look for it.  `X` is a
# commutative monoidal category in which a *single* strand remembers the order
# of what it did and two or more strands do not:
#
#     X(0, 0) = {*}          X(1, 1) = free monoid on the transition names
#     X(n, n) = N^names      for n >= 2        X(n, m) = empty for n != m
#
# Composition is concatenation on one strand and addition above; the tensor
# abelianises.  X satisfies every axiom of a commutative monoidal category
# (proof in notes/TOKEN_PHILOSOPHY.md §5), so by soundness it witnesses that
# the collective theory does NOT prove t ; t' = t' ; t.  But the theory does
# prove (t ; t') (x) id = (t' ; t) (x) id -- one idle spectator token erases
# the order.  Both facts are checked below.

Spectator = Tuple[int, object]  # (strand count, word if 1 else sorted multiset)


def x_id(n: int) -> Spectator:
    return (n, () if n != 1 else ())


def x_gen(name: str) -> Spectator:
    return (1, (name,))


def _x_ab(v: Spectator) -> Tuple[str, ...]:
    return tuple(sorted(v[1]))


def x_comp(a: Spectator, b: Spectator) -> Spectator:
    if a[0] != b[0]:
        raise TypeError_("spectator composite mismatch")
    n = a[0]
    if n == 1:
        return (1, tuple(a[1]) + tuple(b[1]))          # concatenation: order kept
    return (n, tuple(sorted(tuple(a[1]) + tuple(b[1]))))  # addition: order lost


def x_tens(a: Spectator, b: Spectator) -> Spectator:
    if a[0] == 0:
        return b
    if b[0] == 0:
        return a
    return (a[0] + b[0], tuple(sorted(_x_ab(a) + _x_ab(b))))


def interpret_spectator(t: Term, sig: Signature) -> Spectator:
    kind = t[0]
    if kind == "id":
        return x_id(len(t[1]))
    if kind == "gen":
        d, c = sig[t[1]]
        if len(d) != 1 or len(c) != 1:
            raise TypeError_("spectator model needs unary generators")
        return x_gen(t[1])
    if kind == "sym":
        return x_id(len(t[1]) + len(t[2]))          # the symmetry IS the identity
    if kind == "comp":
        return x_comp(interpret_spectator(t[1], sig), interpret_spectator(t[2], sig))
    if kind == "tens":
        return x_tens(interpret_spectator(t[1], sig), interpret_spectator(t[2], sig))
    raise TypeError_(f"unknown term head {kind!r}")


def collapse_derivation(path_prefix: Sequence[int] = ()) -> List[Tuple[Sequence[int], str, bool]]:
    """The six checked steps proving `(g1 ; g2) (x) id_s = g1 (x) g2` for any
    two unary generators -- so a single spectator token forgets their order."""
    p = tuple(path_prefix)
    return [
        (p + (1,), "UNIT_L", False),    # id -> id ; id
        (p, "INTERCHANGE", False),      # -> (g1 (x) id) ; (g2 (x) id)
        (p + (1,), "COMM", True),       # -> (g1 (x) id) ; (id (x) g2)
        (p, "INTERCHANGE", True),       # -> (g1 ; id) (x) (id ; g2)
        (p + (0,), "UNIT_R", True),     # -> g1 (x) (id ; g2)
        (p + (1,), "UNIT_L", True),     # -> g1 (x) g2
    ]


#   t1 ; t2  and  t2 ; t1  as executions of the single-token marking s.
SEQ_12 = comp(T1, T2)
SEQ_21 = comp(T2, T1)
#   the same two, each beside one idle token
SPECTATOR_12 = tens(SEQ_12, idm(("s",)))
SPECTATOR_21 = tens(SEQ_21, idm(("s",)))


# ------------------------------------------- the decision procedure, and why
#
# For the one-place net with unary transitions the free commutative monoidal
# category is *determined*, and it is X (notes/TOKEN_PHILOSOPHY.md §7):
#
#     C(0,0) = {*},   C(1,1) = free monoid on T,   C(n,n) = N[T] for n >= 2,
#
# with C(n,m) empty for n != m.  The mechanism is one line: for n >= 2 two
# adjacent padded steps commute,
#
#     (t (x) id_{n-1}) ; (t' (x) id_{n-1})  =  ((t ; t') (x) id) (x) id_{n-2}
#                                           =  (t (x) t') (x) id_{n-2}
#                                           =  (t' (x) t) (x) id_{n-2}
#                                           =  (t' (x) id_{n-1}) ; (t (x) id_{n-1}),
#
# because the padding leaves an idle strand for Theorem 9's trick to act on.
# At n = 1 there is no idle strand and no such move exists.  So `normal_form`
# below decides equality: a word when one token is present, a multiset when two
# or more are.

def arity(t: Term, sig: Signature) -> int:
    return len(dom_cod(t, sig, collective=True)[0])


def normal_form(t: Term, sig: Signature) -> Tuple[str, Tuple[str, ...]]:
    """The complete invariant for the one-place unary class.  Decides equality
    in the free commutative monoidal category."""
    n = arity(t, sig)
    v = interpret_spectator(t, sig)
    if n == 0:
        return ("unit", ())
    if n == 1:
        return ("word", tuple(v[1]))
    return ("multiset", tuple(sorted(v[1])))


def equal_collectively(t1: Term, t2: Term, sig: Signature) -> bool:
    if dom_cod(t1, sig, collective=True) != dom_cod(t2, sig, collective=True):
        return False
    return normal_form(t1, sig) == normal_form(t2, sig)


def _paths(t: Term) -> List[Tuple[int, ...]]:
    out: List[Tuple[int, ...]] = [()]
    if t[0] in ("comp", "tens"):
        for i in (0, 1):
            out.extend((i,) + p for p in _paths(t[i + 1]))
    return out


def _leaves(t: Term) -> int:
    if t[0] in ("comp", "tens"):
        return _leaves(t[1]) + _leaves(t[2])
    return 1


def rewrite_component(start: Term, sig: Signature, max_leaves: int = 6,
                      cap: int = 4000) -> set:
    """Every term reachable from `start` by axiom rewriting, in either
    direction, staying under `max_leaves`.  This is the falsifier: it is built
    without reference to `normal_form`, so if the normal form were incomplete
    the component would contain two different normal forms, and if it were
    unsound two terms in one component would disagree."""
    seen = {start}
    frontier = [start]
    while frontier and len(seen) < cap:
        t = frontier.pop()
        for path in _paths(t):
            for axiom in AXIOMS:
                for forward in (True, False):
                    for param in range(0, 4):
                        try:
                            out = step(t, path, axiom, forward, sig, param=param)
                        except (DerivationError, TypeError_, IndexError, KeyError):
                            continue
                        if _leaves(out) <= max_leaves and out not in seen:
                            seen.add(out)
                            frontier.append(out)
                        if axiom != "TENS_ID" or forward:
                            break
    return seen


#   The engine of the determination: for n >= 2, two adjacent padded steps
#   commute.  `STEP_12` and `STEP_21` are the two orders; each reduces to a
#   tensor, and the tensors are COMM-equal.
STEP_12 = comp(tens(T1, idm(("s",))), tens(T2, idm(("s",))))
STEP_21 = comp(tens(T2, idm(("s",))), tens(T1, idm(("s",))))
STEPS_TO_TENSOR: List[Tuple[Sequence[int], str, bool]] = (
    [((), "INTERCHANGE", True), ((1,), "UNIT_L", True)] + collapse_derivation()
)


def padding_is_injective(n: int) -> bool:
    """Answer to `notes/TOKEN_PHILOSOPHY.md` §6 for this class: the padding
    C(n,n) -> C(n+1,n+1) is injective except at n = 1."""
    return n != 1


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
    lines.append("spectator: X(t1;t2) = "
                 f"{interpret_spectator(SEQ_12, SIG_TWO)}, X(t2;t1) = "
                 f"{interpret_spectator(SEQ_21, SIG_TWO)}  -> order kept on one strand")
    a = interpret_spectator(SPECTATOR_12, SIG_TWO)
    b = interpret_spectator(SPECTATOR_21, SIG_TWO)
    lines.append(f"  beside one idle token: {a} vs {b}  -> order gone")
    chain = check_derivation(SPECTATOR_12, collapse_derivation(), tens(T1, T2), SIG_TWO)
    lines.append(f"  and derivably so, in {len(chain) - 1} checked steps")
    return "\n".join(lines)


if __name__ == "__main__":
    print(report())


# ----------------------------------------------------- arity and concurrency
#
# Theorem 11 used unarity twice.  Dropping it does not break the mechanism; it
# reveals what the mechanism was measuring.  For a one-place net whose
# transitions are arity-preserving, t : k_t -> k_t, two padded steps commute at
# n tokens exactly when n >= k_t + k_t', i.e. exactly when the marking can host
# both firings at once.  The collective category is therefore the free
# partially commutative monoid -- a Mazurkiewicz trace monoid -- with
# independence "the two firings fit side by side".
#
#     C(n,n) = M( {t : k_t <= n},  t <-> t'  iff  k_t + k_t' <= n ).
#
# Unary transitions are the case k = 1: free at n = 1, fully commutative from
# n = 2, which is Theorem 11.

def trace_commutes(a: str, b: str, n: int, arities: Dict[str, int]) -> bool:
    """The independence relation at `n` tokens: both firings fit."""
    return arities[a] + arities[b] <= n


def trace_normal_form(word: Sequence[str], n: int,
                      arities: Dict[str, int]) -> Tuple[Tuple[str, ...], ...]:
    """Complete invariant of a trace: the multiset of letters together with the
    projection onto every dependent pair (the classical projection lemma).
    Two words are trace-equivalent iff these agree."""
    letters = sorted(set(word))
    proj = []
    for i, a in enumerate(letters):
        for b in letters[i:]:
            if trace_commutes(a, b, n, arities):
                continue
            proj.append(tuple(x for x in word if x in (a, b)))
    return (tuple(sorted(word)),) + tuple(proj)


def trace_equivalent(w1: Sequence[str], w2: Sequence[str], n: int,
                     arities: Dict[str, int]) -> bool:
    return trace_normal_form(w1, n, arities) == trace_normal_form(w2, n, arities)


def trace_tensor(w1: Sequence[str], w2: Sequence[str]) -> Tuple[str, ...]:
    """The model's tensor: concatenate.  Well defined on traces, and symmetric
    on the nose in the target, because every letter of the first factor is
    independent of every letter of the second at the summed token count."""
    return tuple(w1) + tuple(w2)


def padded(name: str, n: int, arities: Dict[str, int]) -> Term:
    """The step `t (x) id_{n - k_t}`, with the pad on the right."""
    k = arities[name]
    if k > n:
        raise TypeError_("transition does not fit in the marking")
    return gen(name) if k == n else tens(gen(name), idm(("s",) * (n - k)))


def commutation_derivation(a: str, b: str, n: int,
                           arities: Dict[str, int]) -> List[Tuple[Sequence[int], str, bool]]:
    """`(a (x) id) ; (b (x) id) = a (x) b (x) id`, when both firings fit.

    One interchange, after the second step's pad has been re-split so the two
    tensor decompositions line up.  This is the whole content of the theorem:
    the split can be aligned exactly when n >= k_a + k_b.
    """
    ka, kb = arities[a], arities[b]
    if ka + kb > n:
        raise TypeError_("the two firings do not fit; no such derivation")
    return [((1,), "COMM", True),        # move the second pad to the left
            ((), "INTERCHANGE", True),   # now the two splits align: (ka, n-ka)
            ((0,), "UNIT_R", True),
            ((1,), "UNIT_L", True)]


SIG_BIN: Signature = {"b1": (("s", "s"), ("s", "s")),
                      "b2": (("s", "s"), ("s", "s"))}
ARITIES_BIN = {"b1": 2, "b2": 2}
ARITIES_UNARY = {"t1": 1, "t2": 1}


def two_steps(a: str, b: str, n: int, arities: Dict[str, int]) -> Term:
    return comp(padded(a, n, arities), padded(b, n, arities))


def concurrency_threshold(a: str, b: str, arities: Dict[str, int]) -> int:
    """The token count at which the order of `a` and `b` stops existing."""
    return arities[a] + arities[b]


# --------------------------------------------------- arbitrary nets: locality
#
# Nothing above needs one place, and nothing needs the transitions to preserve
# the marking.  For a general net, a firing sequence from a marking `a` is a
# word of transitions, each enabled where it stands; two adjacent letters may
# be transposed exactly when the marking *at that point* dominates both their
# inputs.  The condition is local, so the resulting equivalence is a
# context-dependent (local) trace equivalence, and it is the answer:
#
#     C(a,b) = firing sequences a -> b, modulo marking-relative transposition.
#
# Upper bound: each valid transposition is the Theorem 13 derivation applied at
# that point.  Lower bound: the quotient is a commutative monoidal category --
# concatenation is a congruence because a transposition's validity depends only
# on the marking where it happens, and tensoring only adds tokens, which can
# enable transpositions but never disable one.

Marking = Tuple[Tuple[str, int], ...]   # sorted (place, count) pairs
Net = Dict[str, Tuple[Marking, Marking]]


def marking(**counts: int) -> Marking:
    return tuple(sorted((p, c) for p, c in counts.items() if c))


def _add(a: Marking, b: Marking, sign: int = 1) -> Marking:
    d = dict(a)
    for p, c in b:
        d[p] = d.get(p, 0) + sign * c
    return tuple(sorted((p, c) for p, c in d.items() if c))


def _dominates(a: Marking, b: Marking) -> bool:
    d = dict(a)
    return all(d.get(p, 0) >= c for p, c in b)


def fire(a: Marking, t: str, net: Net) -> Marking:
    pre, post = net[t]
    if not _dominates(a, pre):
        raise TypeError_(f"{t} is not enabled at {a}")
    return _add(_add(a, pre, -1), post)


def run(a: Marking, word: Sequence[str], net: Net) -> List[Marking]:
    """The markings visited, including both ends.  Raises if not a firing
    sequence."""
    out = [a]
    for t in word:
        out.append(fire(out[-1], t, net))
    return out


def transposable(a: Marking, t: str, u: str, net: Net) -> bool:
    """May `t u` be exchanged when the marking on arrival is `a`?  Exactly when
    both firings fit side by side there -- Theorem 13, read locally."""
    return _dominates(a, _add(net[t][0], net[u][0]))


def local_trace_class(a: Marking, word: Sequence[str], net: Net) -> frozenset:
    """Every firing sequence equal to `word` in the collective category:
    the closure of `word` under marking-relative adjacent transposition."""
    start = tuple(word)
    run(a, start, net)                      # validity check
    seen = {start}
    frontier = [start]
    while frontier:
        w = frontier.pop()
        marks = run(a, w, net)
        for i in range(len(w) - 1):
            if not transposable(marks[i], w[i], w[i + 1], net):
                continue
            swapped = w[:i] + (w[i + 1], w[i]) + w[i + 2:]
            if swapped not in seen:
                seen.add(swapped)
                frontier.append(swapped)
    return frozenset(seen)


def collectively_equal(a: Marking, w1: Sequence[str], w2: Sequence[str],
                       net: Net) -> bool:
    return tuple(w2) in local_trace_class(a, w1, net)


# ------------------------------- the boundary relation, via the corpus's own
#
# Corollary 6 said the boundary-orbit relation is strictly finer than the
# collective one.  That is not a new construction: the boundary relation is the
# compositional crystal of the two symmetry operations, and this corpus already
# proves it exists, carries the operations, and comes with a minimum separating
# context basis (`notes/COMPOSITIONAL_CRYSTAL_THEOREM.md`,
# `machinery/compositional_crystal.py`).  So compute it there rather than argue
# it here.  The element set below is closed under both operations and finite by
# inspection -- pre- and post-composition with a single symmetry, on the two
# orbits in question -- so no truncation and no sink is involved.

from compositional_crystal import Operation, crystallize_algebra, factor_map

SIGMA = sym(("s",), ("s",))


def boundary_variant(seed: Term, pre: int, post: int) -> Term:
    """One of the four boundary relabellings of `seed`.  There are four and not
    infinitely many because the symmetry is an involution -- a law of the
    symmetric theory (`freeSymmetryIsInvolution` in anyone's presentation), and
    checked in the thread model -- so the index is (Z/2)^2, not a free monoid."""
    t = comp(SIGMA, seed) if pre else seed
    return comp(t, SIGMA) if post else t


def boundary_algebra(seeds: Sequence[Term]) -> Tuple[Tuple[int, int, int], ...]:
    """The (Z/2)^2 orbit index over the given seeds: finite and closed by
    construction, with both operations total."""
    return tuple((k, pre, post) for k in range(len(seeds))
                 for pre in (0, 1) for post in (0, 1))


def boundary_crystal(seeds: Sequence[Term], sig: Signature):
    """The greatest congruence inside the kernel of the thread invariant, under
    boundary relabelling.  Computed by `machinery/compositional_crystal.py`."""
    elements = boundary_algebra(seeds)
    pre_op = Operation("pre_sigma", 1,
                       {(e,): (e[0], 1 - e[1], e[2]) for e in elements})
    post_op = Operation("post_sigma", 1,
                        {(e,): (e[0], e[1], 1 - e[2]) for e in elements})
    observation = {e: thread_multiset(boundary_variant(seeds[e[0]], e[1], e[2]), sig)
                   for e in elements}
    return elements, crystallize_algebra(elements, [pre_op, post_op], observation)


def collective_factors_through_boundary(seeds: Sequence[Term], sig: Signature):
    """`factor_map` succeeds iff the collective normal form is constant on the
    boundary fibres, i.e. iff the collective relation is coarser.  It is, and it
    is not injective on fibres -- which is Corollary 6, computed rather than
    argued."""
    elements, crystal = boundary_crystal(seeds, sig)
    values = factor_map(
        crystal,
        {e: normal_form(boundary_variant(seeds[e[0]], e[1], e[2]), sig)
         for e in elements})
    return crystal, values, len(set(values)) == len(values)
