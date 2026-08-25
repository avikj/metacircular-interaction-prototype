"""Which edges in this runtime actually carry an index?

`edges.py` declares three limitor-bearing kinds -- Approx (an exact epsilon),
Dual (a pairing), Order (an ordering).  A limitor is the *avacchedaka*: the
mode under which a relation is taken, so that two edges between the same pair
under different limitors are different edges rather than one edge with a
label.

This file answers the question the type declaration cannot: does the runtime
ever BUILD one?  It parses every construction site with `ast` -- no import, no
execution, no measurement -- and separates

  originating : a limitor supplied at the call site (a literal or an
                expression that is not simply copied from another edge), so
                this code decides an index;
  propagating : `eps=e.eps` and friends -- the limitor is forwarded from an
                edge someone else built, so this code decides nothing;
  unlimited   : no limitor argument at all.

The distinction matters because of the singleton reading (`limitor_census`,
notes/POSITIVITY_HAS_A_PLACE.md SS9): an index whose value space is a
singleton cannot be observed to have been dropped.  A runtime with zero
originating sites is in a state one step before that -- it has never carried
an index at all, so its limitor-bearing kinds are declared and inert, and no
amount of running it can exercise them.

Run: python3 runtime/kernel/limitor_audit.py
"""
import ast
import os
import sys

LIMITOR_KW = {"eps": "Approx", "pairing": "Dual", "ordering": "Order"}
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def is_edge_call(node):
    """`Edge(...)`, `E.Edge(...)`, `edges.Edge(...)`."""
    if not isinstance(node, ast.Call):
        return False
    f = node.func
    if isinstance(f, ast.Name):
        return f.id == "Edge"
    if isinstance(f, ast.Attribute):
        return f.attr == "Edge"
    return False

def classify(call):
    """(kind_or_None, {kw: 'originating'|'propagating'}) for one call."""
    kind = None
    if call.args and isinstance(call.args[0], ast.Constant):
        kind = call.args[0].value
    found = {}
    for kw in call.keywords:
        if kw.arg == "kind" and isinstance(kw.value, ast.Constant):
            kind = kw.value.value
        if kw.arg in LIMITOR_KW:
            v = kw.value
            # `eps=e.eps` and `eps=eps` both forward an index someone else
            # decided; neither originates one.  Only a value that is not simply
            # the same name or field being passed through counts as a decision.
            propagating = ((isinstance(v, ast.Attribute) and v.attr == kw.arg)
                           or (isinstance(v, ast.Name) and v.id == kw.arg)
                           or (isinstance(v, ast.Subscript)
                               and isinstance(v.slice, ast.Constant)
                               and v.slice.value == kw.arg))
            if isinstance(v, ast.Constant) and v.value is None:
                continue
            found[kw.arg] = "propagating" if propagating else "originating"
    return kind, found

def scan(paths):
    origin, propagate, unlimited = [], [], 0
    for path in paths:
        try:
            tree = ast.parse(open(path).read(), filename=path)
        except (OSError, SyntaxError):
            continue
        rel = os.path.relpath(path, os.path.dirname(ROOT))
        for node in ast.walk(tree):
            if not is_edge_call(node):
                continue
            kind, found = classify(node)
            if not found:
                unlimited += 1
                continue
            for kw, how in found.items():
                row = (rel, node.lineno, kind or "?", LIMITOR_KW[kw], kw)
                (origin if how == "originating" else propagate).append(row)
    return origin, propagate, unlimited

def sources():
    out = []
    for base, _, files in os.walk(ROOT):
        if "__pycache__" in base or os.sep + "tests" in base:
            continue
        for f in files:
            if f.endswith(".py") and f != "limitor_audit.py":
                out.append(os.path.join(base, f))
    return sorted(out)

def main():
    files = sources()
    origin, propagate, unlimited = scan(files)
    print("Limitor audit of %d runtime source files (tests excluded).\n" % len(files))

    print("  ORIGINATING -- a limitor decided at the call site: %d" % len(origin))
    for rel, line, kind, lk, kw in origin:
        print("      %s:%d  %s(%s=...)" % (rel, line, kind, kw))
    print("\n  PROPAGATING -- a limitor forwarded from another edge: %d" % len(propagate))
    for rel, line, kind, lk, kw in propagate:
        print("      %s:%d  %s(%s=<copied>)" % (rel, line, kind, kw))
    print("\n  UNLIMITED  -- construction sites passing no limitor: %d" % unlimited)

    print("\n  Reading:")
    if not origin:
        print("    No site originates a limitor. The three limitor-bearing kinds")
        print("    are DECLARED AND INERT: every edge this runtime builds is an")
        print("    unlimited one, and the propagating sites forward an index that")
        print("    nothing ever creates. This is one step before the singleton")
        print("    regime -- not an index too small to be seen, but no index at")
        print("    all -- and running the system longer cannot reach it.")
    else:
        print("    %d originating site(s). Run limitor_census over the edges"
              % len(origin))
        print("    they build: cardinality 1 there is a latent erratum.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
