"""The runtime's central claim, at seed size.

`runtime/` spends ~45,000 lines to establish one thing: a proved fact enters,
and an *independent* problem thereafter costs strictly fewer checked steps,
while a true-but-irrelevant fact costs nothing.  This file does that, with the
check and the null control, in one readable page.

Run: python3 machinery/seed_criterion.py
Exact integers only; no floats, no dependencies, deterministic.

What survived compression and what did not is recorded in notes/TWO_SEEDS.md
and at the bottom of this file.
"""
from itertools import count

# --------------------------------------------------------------- terms
# A term is a tuple: ('+', a, b) | ('*', a, b) | ('x', name) | ('n', int).
# Hash-consing is free: tuples are already structural, and equality is `==`.

def V(n): return ('x', n)
def N(k): return ('n', k)
def add(*t): return t[0] if len(t) == 1 else ('+', t[0], add(*t[1:]))
def mul(*t): return t[0] if len(t) == 1 else ('*', t[0], mul(*t[1:]))

def show(t):
    k = t[0]
    if k == 'n': return str(t[1])
    if k == 'x': return t[1]
    if k == 'p': return "#%d" % t[1]
    return "(%s %s %s)" % (show(t[1]), k, show(t[2]))

# ------------------------------------------------------- evaluation oracle
# The independent decision procedure.  A polynomial identity in <=2 variables
# of degree <= D vanishes iff it vanishes on a (D+1)^2 integer grid, so this
# *decides* equality rather than sampling it.

def ev(t, env):
    k = t[0]
    if k == 'n': return t[1]
    if k == 'x': return env[t[1]]
    a, b = ev(t[1], env), ev(t[2], env)
    return a + b if k == '+' else a * b

def equal(s, t, D=8):
    return all(ev(s, {'x': i, 'y': j}) == ev(t, {'x': i, 'y': j})
               for i in range(-D, D + 1) for j in range(-D, D + 1))

# --------------------------------------------------------------- rewriting
# Axioms as (name, lhs, rhs) schemas over pattern variables #0,#1,#2.

P0, P1, P2 = ('p', 0), ('p', 1), ('p', 2)

AXIOMS = [
    ('distrib', mul(P0, add(P1, P2)), add(mul(P0, P1), mul(P0, P2))),
    ('distribR', mul(add(P0, P1), P2), add(mul(P0, P2), mul(P1, P2))),
]
# Deliberately oriented and terminating: both rules strictly reduce the number
# of sums appearing inside products, so normalize() reaches a fixed point.
# Commutativity and associativity are omitted for exactly that reason — an
# unoriented axiom set needs the e-graph this file is doing without.

def match(pat, t, s):
    if pat[0] == 'p':
        if pat[1] in s: return s if s[pat[1]] == t else None
        s = dict(s); s[pat[1]] = t; return s
    if pat[0] != t[0]: return None
    if pat[0] in ('n', 'x'): return s if pat == t else None
    s1 = match(pat[1], t[1], s)
    return None if s1 is None else match(pat[2], t[2], s1)

def subst(pat, s):
    if pat[0] == 'p': return s[pat[1]]
    if pat[0] in ('n', 'x'): return pat
    return (pat[0], subst(pat[1], s), subst(pat[2], s))

def positions(t, p=()):
    yield p, t
    if t[0] in ('+', '*'):
        yield from positions(t[1], p + (1,))
        yield from positions(t[2], p + (2,))

def replace(t, p, new):
    if not p: return new
    i = p[0]
    kids = [t[1], t[2]]
    kids[i - 1] = replace(kids[i - 1], p[1:], new)
    return (t[0], kids[0], kids[1])

def step(t, rules, ctr):
    """One leftmost rewrite.  Returns (name, new_term) or None."""
    for p, sub in positions(t):
        for name, lhs, rhs in rules:
            ctr[0] += 1                       # search work
            s = match(lhs, sub, {})
            if s is not None:
                new = replace(t, p, subst(rhs, s))
                if new != t: return name, new
    return None

def normalize(t, rules, budget=400):
    """Rewrite to a fixed point.  Returns (result, trace, steps, work)."""
    ctr = [0]; trace = []
    for _ in range(budget):
        r = step(t, rules, ctr)
        if r is None: break
        trace.append((r[0], t, r[1])); t = r[1]
    return t, trace, len(trace), ctr[0]

# ------------------------------------------------------- anti-unification
# Plotkin/Reynolds least general generalization, with the consistency map
# that makes it *least* general: the same mismatched pair always gets the
# same variable.

def lgg(a, b, table, fresh):
    if a == b: return a
    if a[0] == b[0] and a[0] in ('+', '*'):
        return (a[0], lgg(a[1], b[1], table, fresh),
                lgg(a[2], b[2], table, fresh))
    key = (a, b)
    if key not in table: table[key] = ('p', next(fresh))
    return table[key]

def generalize(pairs):
    """pairs: [(lhs_i, rhs_i)] -> one (lhs, rhs) schema, or None."""
    fresh = count()
    table = {}
    l = pairs[0][0]; r = pairs[0][1]
    for a, b in pairs[1:]:
        l = lgg(l, a, table, fresh)
        r = lgg(r, b, table, fresh)
    return l, r

# ------------------------------------------------------------- the check
# A candidate lemma is admitted only if (a) it is not an axiom instance,
# (b) both sides are *decided* equal by the oracle on fresh indeterminates,
# and (c) applying it changes no answer on a battery.

def admit(cand, battery):
    lhs, rhs = cand
    holes = sorted({v[1] for v in _vars(lhs) | _vars(rhs)})
    if not holes: return False, "ground"
    probe = {h: (V('x') if i == 0 else V('y')) for i, h in enumerate(holes)}
    if len(holes) > 2: return False, "too many holes for the oracle"
    L, R = _fill(lhs, probe), _fill(rhs, probe)
    if not equal(L, R): return False, "not an identity"
    for t in battery:
        a, _, _, _ = normalize(t, AXIOMS)
        b, _, _, _ = normalize(t, AXIOMS + [('lemma', lhs, rhs)])
        if not equal(a, b): return False, "changes an answer"
    return True, "ok"

def _vars(t):
    if t[0] == 'p': return {t}
    if t[0] in ('n', 'x'): return set()
    return _vars(t[1]) | _vars(t[2])

def _fill(t, m):
    if t[0] == 'p': return m[t[1]]
    if t[0] in ('n', 'x'): return t
    return (t[0], _fill(t[1], m), _fill(t[2], m))

# ------------------------------------------------------------- experiment
X, Y = V('x'), V('y')

# First attempt failed, and the failures were the point of the exercise:
#   (1) TRAIN was [(x+y)^2, (x+2)^2].  Both share the literal `x` in the same
#       slot, so the LGG *kept* it: the lemma came out ((x+#0)*(x+#0)) and did
#       not match the independent problem at all.  Over-specialisation from too
#       little variation in the training set — not a bug in the algorithm.
#   (2) The null control was associativity of `*`, which fires on the expanded
#       terms.  A null that rewrites is not null.
# Both are experiment design, not machinery.  Fixed below.
TRAIN = [mul(add(X, Y), add(X, Y)),
         mul(add(Y, N(2)), add(Y, N(2)))]      # varies BOTH slots
INDEP = mul(add(mul(X, X), Y), add(mul(X, X), Y))  # not an instance of either
NULLL = ('add0', add(P0, N(0)), P0)            # true, and cannot fire: no 0 here

def run():
    print(__doc__.strip().splitlines()[0], "\n")

    # 1. solve the training problems, keep the (start, end) pairs
    pairs = []
    for t in TRAIN:
        r, _, s, w = normalize(t, AXIOMS)
        pairs.append((t, r))
        print("  train  %-28s -> %-34s %3d steps" % (show(t), show(r), s))

    # 2. generalize, then check
    cand = generalize(pairs)
    ok, why = admit(cand, TRAIN + [INDEP])
    print("\n  lemma  %s  =  %s" % (show(cand[0]), show(cand[1])))
    print("  admitted: %s (%s)" % (ok, why))
    if not ok: return
    LEM = [('lemma', cand[0], cand[1])]

    # 3. the experiment: an independent problem, three books
    def measure(rules):
        r, _, s, w = normalize(INDEP, rules)
        return r, s, w
    # Rule ORDER is a choice, and it is the whole difference here.  With
    # AXIOMS first, distributivity fires at the root before the lemma is ever
    # tried, and the lemma is inert.  Preferring the lemma is the smallest
    # possible stand-in for route selection — which is what the runtime buys
    # with cost-vector extraction over an e-graph.  Named, not hidden.
    base, s0, w0 = measure(AXIOMS)
    lem,  s1, w1 = measure(LEM + AXIOMS)
    nul,  s2, w2 = measure([NULLL] + AXIOMS)

    print("\n  independent problem: %s" % show(INDEP))
    print("  %-22s %6s %10s" % ("book", "steps", "work"))
    print("  %-22s %6d %10d" % ("axioms only", s0, w0))
    print("  %-22s %6d %10d   <- the mined lemma" % ("axioms + lemma", s1, w1))
    print("  %-22s %6d %10d   <- null control" % ("axioms + null", s2, w2))

    print("\n  answers agree (decided, not sampled): %s" %
          (equal(base, lem) and equal(base, nul)))
    print("  strictly fewer steps with the lemma : %s (%d < %d)" %
          (s1 < s0, s1, s0))
    print("  null control leaves the cost alone  : %s (%d vs %d)" %
          (s2 == s0, s2, s0))
    verdict = s1 < s0 and s2 == s0 and equal(base, lem) and equal(base, nul)
    print("\n  SEED CRITERION: %s" % ("MET" if verdict else "NOT MET"))
    return verdict

# ------------------------------------------------- what did not compress
# Honest list, since the point of the exercise is the residue:
#
#   survives at this size : hash-consing (free in tuples), rewriting with a
#     step counter, Plotkin anti-unification with its consistency table, an
#     independent decision procedure, the null control, the independence of
#     the held-out problem.
#
#   needed adding back    : a preference for the mined rule over the axioms.
#     Without it the lemma is inert — distributivity fires at the root first
#     and the independent problem still costs 3 steps.  That preference is the
#     smallest possible stand-in for cost-based route selection, and it is the
#     one thing the compression could not simply drop.
#
#   two design defects the compression exposed, both mine, both real:
#     - training on [(x+y)^2, (x+2)^2] shares the literal `x` in one slot, so
#       the LGG keeps it and the lemma never matches.  Too little variation in
#       the training set over-specialises the generalisation.
#     - associativity of `*` is not a null control here: it fires on the
#       expanded terms.  A null that rewrites is not null.
#
#   does NOT survive      : the proof-relevant e-graph and its retraction
#     (needs the proof forest); typed non-conflated edges; the dependency-cone
#     invalidation of L4; the stated trust boundary; e-matching against
#     e-classes rather than terms — which is exactly where the runtime's
#     leverage came from, since 39 of 44 matches there had no stored
#     realisation.  None of that is apparatus: each buys a claim this file
#     cannot make.  What this file shows is that the *headline* needed none
#     of it.

if __name__ == "__main__":
    raise SystemExit(0 if run() else 1)
