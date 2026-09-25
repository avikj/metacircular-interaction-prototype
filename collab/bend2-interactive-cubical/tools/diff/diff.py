#!/usr/bin/env python3
# Differential check: Core evaluation (bend FILE) vs the full runtime
# (bend FILE --to-hvm4-full | hvm -s), value component of the typed point.
# usage: BEND=.. HVM=.. DIFF_OUT=dir python3 diff.py [--no-run] [files...]
"""Differential test: Core evaluator (`bend file.bend`) vs HVM4 full runtime
(`bend file.bend --to-hvm4-full` + `hvm out.hvm4 -s`).

Usage: diff.py [--no-run] [files...]
  With no files: all tracked *.bend in the repo + the two lab sanity files.
  --no-run: reuse raw outputs already in DIR/raw (skip executing binaries).
Writes DIR/report.tsv.
"""
import os, re, sys, subprocess, concurrent.futures as cf

DIR = os.environ.get("DIFF_OUT") or os.path.join(os.getcwd(), "diff-out")
RAW = os.path.join(DIR, "raw")
REPO = subprocess.run(["git", "-C", os.path.dirname(os.path.abspath(__file__)), "rev-parse", "--show-toplevel"], capture_output=True, text=True).stdout.strip()
EXTRA = []
TIMEOUT = "60"

def env():
    e = dict(os.environ)
    # BEND and HVM must be set (e.g. `source BUILD/env.sh`)
    e["BEND"], e["HVM"] = os.environ["BEND"], os.environ["HVM"]
    e["LC_ALL"] = e["LANG"] = "C.UTF-8"
    return e
ENV = env()

def rid(path):
    return path.lstrip("/").replace("/", "__")

def run(cmd, cwd, out, err):
    with open(out, "wb") as o, open(err, "wb") as e:
        return subprocess.run(["timeout", TIMEOUT] + cmd, cwd=cwd, stdout=o, stderr=e, env=ENV).returncode

def collect(path):
    b = os.path.join(RAW, rid(path))
    d, f = os.path.dirname(path), os.path.basename(path)
    rc = run([ENV["BEND"], f], d, b + ".core", b + ".core.err")
    open(b + ".core.rc", "w").write(f"{rc}\n")
    rc = run([ENV["BEND"], f, "--to-hvm4-full"], d, b + ".hvm4", b + ".hvm4.err")
    open(b + ".hvm4.rc", "w").write(f"{rc}\n")
    if rc == 0:
        rc = run([ENV["HVM"], b + ".hvm4", "-s"], d, b + ".run", b + ".run.err")
        open(b + ".run.rc", "w").write(f"{rc}\n")

def rd(p):
    try: return open(p, encoding="utf-8", errors="replace").read()
    except FileNotFoundError: return None

# ---------------------------------------------------------------- values
# Canonical value AST (tuples):
#  ("nat", k) ("word", n) ("unit",) ("nil",) ("cons", h, t) ("pair", a, b)
#  ("sym", s) ("ctor", name, [fields], is_hit_tag) ("sup", label, a, b)
#  ("nc", reason)   -- not comparable (lambda, neutral/stuck, erased, ...)

class PErr(Exception): pass

ANSI = re.compile(r"\x1b\[[0-9;]*m")

# ---- Core printed syntax (Core/Type.hs `instance Show Term`)
class CoreP:
    def __init__(s, t): s.t, s.i = t, 0
    def peek(s, k=1): return s.t[s.i:s.i + k]
    def eat(s, x):
        if s.t.startswith(x, s.i): s.i += len(x); return True
        return False
    def expect(s, x):
        if not s.eat(x): raise PErr(f"core: expected {x!r} at {s.i}: {s.t[s.i:s.i+30]!r}")
    def full(s):
        v = s.expr()
        if s.i != len(s.t): return ("nc", f"core: unparsed tail {s.t[s.i:s.i+40]!r}")
        return v
    def expr(s):  # list cons '<>' is right-assoc, lowest precedence
        h = s.unary()
        if s.eat("<>"):
            return ("cons", h, s.expr())
        return h
    def unary(s):
        if s.eat("1n+"):
            n = s.unary()
            return ("nat", n[1] + 1) if n[0] == "nat" else ("nc", "core: 1n+ over non-Nat (neutral) " + show(n))
        return s.atom()
    def atom(s):
        t, i = s.t, s.i
        if s.eat("0n"): return ("nat", 0)
        if s.eat("()"): return ("unit",)
        if s.eat("[]"): return ("nil",)
        if s.eat("True") and not s.identc(): return ("word", 1)
        s.i = i
        if s.eat("False") and not s.identc(): return ("word", 0)
        s.i = i
        if s.peek() in ("λ",): return s.opaque("core: lambda")
        if s.peek() == "<": return s.opaque("core: path lambda <i>")
        if s.peek() == "~": return s.opaque("core: stuck match ~")
        m = re.compile(r"\d+").match(t, i)
        if m:
            s.i = m.end(); return ("word", int(m.group()))
        if s.peek() == "'":
            m = re.compile(r"'(\\.|[^'\\])'").match(t, i)
            if not m: raise PErr("core: bad char")
            s.i = m.end(); c = m.group(1)
            c = {"\\n": "\n", "\\t": "\t", "\\r": "\r", "\\0": "\0", "\\\\": "\\", "\\'": "'"}.get(c, c)
            return ("word", ord(c))
        if s.peek() == '"':
            m = re.compile(r'"([^"]*)"').match(t, i)
            s.i = m.end(); v = ("nil",)
            for c in reversed(m.group(1)): v = ("cons", ("word", ord(c)), v)
            return v
        if s.peek() == "&":
            s.i += 1
            if s.peek() == "{": return s.opaque("core: enum type")
            n = s.ident()
            if s.peek() == "{":  # Sup printed inline (not collapsed)
                return s.opaque("core: superposition")
            return ("sym", n)
        if s.peek() == "@":
            s.i += 1; n = s.ident(); s.expect("{")
            fs = s.args("}")
            if s.peek(3) == " @ ": return s.opaque("core: HIT path constructor applied to interval")
            return ("ctor", n, fs, False)
        if s.peek() == "(":
            s.i += 1; fs = s.args(")")
            if len(fs) == 1: return fs[0]
            v = fs[-1]
            for x in reversed(fs[:-1]): v = ("pair", x, v)
            return v
        if s.peek() == "*": s.i += 1; return ("nc", "core: erased *")
        m = re.compile(r"[A-Za-z_][\w./'-]*").match(t, i)
        if m:
            s.i = m.end()
            if s.peek() == "(": return s.opaque(f"core: neutral application {m.group()}(..)")
            return s.opaque(f"core: neutral/type term {m.group()}")
        return s.opaque(f"core: unrecognised {t[i:i+20]!r}")
    def identc(s): return s.i < len(s.t) and (s.t[s.i].isalnum() or s.t[s.i] in "_")
    def ident(s):
        m = re.compile(r"[\w./'-]+").match(s.t, s.i)
        if not m: raise PErr("core: expected ident")
        s.i = m.end(); return m.group()
    def args(s, close):
        fs = []
        if s.eat(close): return fs
        while True:
            fs.append(s.expr())
            if s.eat(","): continue
            s.expect(close); return fs
    def opaque(s, reason):
        s.i = len(s.t)  # swallow the rest: the whole value becomes not comparable
        return ("nc", reason)

# ---- HVM4 printed syntax
class HvmP:
    def __init__(s, t): s.t, s.i = t, 0
    def peek(s, k=1): return s.t[s.i:s.i + k]
    def eat(s, x):
        if s.t.startswith(x, s.i): s.i += len(x); return True
        return False
    def expect(s, x):
        if not s.eat(x): raise PErr(f"hvm: expected {x!r} at {s.i}: {s.t[s.i:s.i+30]!r}")
    def term(s):
        """Parse one term; returns (value, start, end) with raw span."""
        st = s.i; v = s.t_(); return v, st, s.i
    def t_(s):
        t, i = s.t, s.i
        if s.peek() == "#":
            s.i += 1
            m = re.compile(r"[\w]+").match(t, s.i); s.i = m.end(); tag = m.group()
            fs = []
            if s.eat("{"):
                if not s.eat("}"):
                    while True:
                        fs.append(s.t_())
                        if s.eat(","): continue
                        s.expect("}"); break
            return s.post(s.ctor(tag, fs))
        if s.peek() == "&":
            s.i += 1
            m = re.compile(r"[\w]*").match(t, s.i); s.i = m.end(); lab = m.group()
            s.expect("{")
            if s.eat("}"): return s.post(("nc", "runtime: erased &{}"))
            a = s.t_(); s.expect(","); b = s.t_(); s.expect("}")
            return s.post(("sup", lab, a, b))
        m = re.compile(r"\d+").match(t, i)
        if m: s.i = m.end(); return s.post(("word", int(m.group())))
        if s.peek() == "λ":
            s.skip_any(); return ("nc", "runtime: lambda")
        if s.peek() == "@":
            s.skip_any(); return ("nc", "runtime: stuck call to @function")
        m = re.compile(r"[^\s{},()#&@;!λ]+").match(t, i)
        if m:
            s.i = m.end(); s.post(None); return ("nc", f"runtime: free/neutral variable {m.group()}")
        raise PErr(f"hvm: unrecognised at {i}: {t[i:i+30]!r}")
    def post(s, v):
        if s.peek() == "(":  # application of a value: neutral
            s.skip_group("(", ")"); return ("nc", "runtime: stuck application")
        return v
    def skip_any(s):
        # skip a term we do not interpret: consume until an unmatched , } ) or ;
        depth = 0
        while s.i < len(s.t):
            c = s.t[s.i]
            if c in "{(": depth += 1
            elif c in "})":
                if depth == 0: return
                depth -= 1
            elif c in ",;" and depth == 0: return
            s.i += 1
    def skip_group(s, o, c):
        d = 0
        while s.i < len(s.t):
            ch = s.t[s.i]; s.i += 1
            if ch == o: d += 1
            elif ch == c:
                d -= 1
                if d == 0: return
    def ctor(s, tag, fs):
        if tag == "Zer" and not fs: return ("nat", 0)
        if tag == "Suc" and len(fs) == 1:
            n = fs[0]
            if n[0] == "nat": return ("nat", n[1] + 1)
            if first(n, "sup"): return ("sucsup", n)
            if n[0] == "nc": return n
            return ("nc", "runtime: #Suc over non-Nat " + show(n))
        if tag == "One" and not fs: return ("unit",)
        if tag == "Nil" and not fs: return ("nil",)
        if tag == "Con" and len(fs) == 2: return ("cons", fs[0], fs[1])
        if tag == "Pair" and len(fs) == 2: return ("pair", fs[0], fs[1])
        if tag.startswith("C_"): return ("ctor", tag, fs, True)
        # enum symbols are their own cells: #s_<escaped name>
        if tag.startswith("s_") and not fs: return ("sym", unesc(tag[2:]))
        if not fs: return ("sym", tag)
        return ("nc", f"runtime: data #{tag}{{..}}")

def unesc(n):
    out, i = [], 0
    while i < len(n):
        if n[i] == "_" and i + 1 < len(n):
            out.append({"u": "_", "s": "/"}.get(n[i + 1], n[i + 1])); i += 2
        else:
            out.append(n[i]); i += 1
    return "".join(out)

# ---------------------------------------------------------------- canonicalisation
def canon(v):
    """Post-pass: (&name, f1, .., fn, ()) tuples -> ctor (Core's prettyCtr rule);
    #Suc over a superposition is pushed inside is not done (kept not comparable)."""
    k = v[0]
    if k == "sucsup": return ("nc", "runtime: #Suc over superposition")
    if k == "pair":
        a, b = canon(v[1]), canon(v[2])
        if a[0] == "sym":
            fs, r = [], b
            while r[0] == "pair": fs.append(r[1]); r = r[2]
            if r[0] == "unit": return ("ctor", a[1], fs, False)
        return ("pair", a, b)
    if k == "cons": return ("cons", canon(v[1]), canon(v[2]))
    if k == "ctor": return ("ctor", v[1], [canon(x) for x in v[2]], v[3])
    if k == "sup": return ("sup", v[1], canon(v[2]), canon(v[3]))
    return v

def show(v):
    k = v[0]
    if k == "nat": return f"Nat({v[1]})"
    if k == "word": return f"W({v[1]})"
    if k == "unit": return "Unit"
    if k == "sym": return f"Sym({v[1]})"
    if k in ("nil", "cons"):
        xs = []
        while v[0] == "cons": xs.append(show(v[1])); v = v[2]
        if v[0] == "nil": return "[" + ",".join(xs) + "]"
        return "[" + ",".join(xs) + "|" + show(v) + "]"
    if k == "pair": return f"({show(v[1])},{show(v[2])})"
    if k == "ctor": return f"Ctor({v[1]}{{{','.join(show(x) for x in v[2])}}})"
    if k == "sup": return f"&{v[1]}{{{show(v[2])},{show(v[3])}}}"
    if k == "nc": return f"<NC:{v[1]}>"
    if k == "sucsup": return "Suc(" + show(v[1]) + ")"
    return repr(v)

def first(v, kind):
    """First sub-value of the given kind (preorder), or None."""
    if v[0] == kind: return v
    kids = {"cons": v[1:3], "pair": v[1:3], "sup": v[2:4], "sucsup": v[1:2]}.get(v[0], v[2] if v[0] == "ctor" else [])
    for c in kids:
        r = first(c, kind)
        if r: return r
    return None

def resolve(v, env):
    k = v[0]
    if k == "sup":
        if v[1] in env: return resolve(v[2 + env[v[1]]], env)
        return ("sup", v[1], resolve(v[2], env), resolve(v[3], env))
    if k in ("cons", "pair"): return (k, resolve(v[1], env), resolve(v[2], env))
    if k == "ctor": return ("ctor", v[1], [resolve(x, env) for x in v[2]], v[3])
    if k == "sucsup": return ("sucsup", resolve(v[1], env))
    return v

def succfix(v):
    if v[0] == "sucsup":
        n = succfix(v[1]); return ("nat", n[1] + 1) if n[0] == "nat" else ("nc", "runtime: #Suc over non-Nat")
    if v[0] in ("cons", "pair"): return (v[0], succfix(v[1]), succfix(v[2]))
    if v[0] == "ctor": return ("ctor", v[1], [succfix(x) for x in v[2]], v[3])
    return v

def collapse(v, env=None, limit=4096):
    """Label-consistent collapse of superpositions: branch on the first
    (preorder) unresolved sup; same-label sups elsewhere take the same side."""
    env = env or {}
    v = resolve(v, env)
    s = first(v, "sup")
    if not s: return [canon(succfix(v))]
    out = []
    for side in (0, 1):
        out += collapse(v, {**env, s[1]: side}, limit)
        if len(out) > limit: break
    return out

def eq(c, h):
    """Compare canonical Core value c with canonical runtime value h.
    Returns (True, None), (False, note) or (None, reason-if-not-comparable).
    A definite mismatch anywhere wins over a not-comparable position."""
    for x, who in ((c, "core"), (h, "runtime")):
        if first(x, "sup"): return None, f"{who}: superposition"
    nc = []
    r = rec_eq(c, h, nc)
    if r is False: return False, "; ".join(n for n in nc if n.startswith("shape"))
    if nc: return None, nc[0]
    return True, None

DATA = ("nat", "word", "unit", "nil", "cons", "pair", "sym", "ctor")

def rec_eq(c, h, nc):
    """True / False (definite) / None (position not comparable; reason appended to nc)."""
    if c[0] == "nc" or h[0] == "nc":
        if c[0] == "nc" and h[0] == "nc":
            nc.append(c[1] if c[1] == h[1].replace("runtime", "core") else f"{c[1]} / {h[1]}"); return None
        n, other, side = (c, h, "core") if c[0] == "nc" else (h, c, "runtime")
        if n[1].endswith("lambda") and other[0] in DATA:
            nc.append(f"shape: {side} is a lambda where the other side is data {show(other)[:60]}"); return False
        nc.append(n[1]); return None
    if c[0] == "ctor" and h[0] == "ctor":
        cn, cf_ = c[1], c[2]
        hn, hf = h[1], h[2]
        if h[3]:  # HIT runtime tag C_<T>_<c>{params.., args..}; Core prints only args
            if not hn.endswith("_" + cn) or len(hf) < len(cf_): return False
            hf = hf[len(hf) - len(cf_):]
        elif hn != cn or len(hf) != len(cf_): return False
        return all3([rec_eq(a, b, nc) for a, b in zip(cf_, hf)])
    if c[0] != h[0]: return False
    if c[0] in ("cons", "pair"): return all3([rec_eq(c[1], h[1], nc), rec_eq(c[2], h[2], nc)])
    return c == h

def all3(rs):
    if any(r is False for r in rs): return False
    if any(r is None for r in rs): return None
    return True

# ---------------------------------------------------------------- per file
CHECK = re.compile(r"^(✓|✗) ")

def core_results(txt):
    """Core output = check lines (✓/✗ + error text) then, if main exists,
    one empty line followed by one line per collapsed result (CLI.hs runMain)."""
    lines = [ANSI.sub("", l) for l in txt.split("\n")]
    if lines and lines[-1] == "": lines.pop()
    last = max([i for i, l in enumerate(lines) if CHECK.match(l)], default=-1)
    rest = lines[last + 1:]
    if not rest: return None
    if rest[0] != "": return None
    return rest[1:]

def split_root(line):
    """Root line: #Pair{TYPE,VALUE}[;!dup-bindings...]. Returns (type_raw, value_raw, value_ast, trailer)."""
    p = HvmP(line)
    if not line.startswith("#Pair{"): raise PErr("root is not #Pair{TYPE,VALUE}")
    p.i = len("#Pair{")
    _, ts, te = p.term(); p.expect(",")
    v, vs, ve = p.term(); p.expect("}")
    return line[ts:te], line[vs:ve], v, line[p.i:]

def refusal(err):
    L = [l.strip() for l in err.split("\n") if l.strip()]
    for pat in ("HVM4 full:", "PARSE_ERROR", "import:", "Error:", "Mismatch", "CantInfer", "IncompleteMatch", "Uncaught"):
        for i, l in enumerate(L):
            if l.startswith(pat) or pat in l[:40]:
                if pat == "PARSE_ERROR" and i + 1 < len(L): return "PARSE_ERROR: " + L[i + 1][:150]
                if pat in ("Mismatch", "CantInfer", "IncompleteMatch"):
                    bad = [x[2:] for x in L if x.startswith("✗ ")]
                    return f"type error ({pat}) in: " + ",".join(bad)[:150]
                return l[:200]
    bad = [x[2:] for x in L if x.startswith("✗ ")]
    if bad: return "check failed: " + ",".join(bad)[:150]
    return (L[-1][:200] if L else "(no output)")

def classify(path):
    b = os.path.join(RAW, rid(path))
    row = dict(file=path, cls="", reason="", core_raw="", hvm_raw="", core_norm="", hvm_norm="", itrs="", collapsed="")
    crc = int(rd(b + ".core.rc") or -1); hrc = int(rd(b + ".hvm4.rc") or -1)
    core = rd(b + ".core") or ""
    res = core_results(core)
    if res is not None: row["core_raw"] = " | ".join(res)
    if hrc != 0:
        err = ANSI.sub("", (rd(b + ".hvm4") or "") + "\n" + (rd(b + ".hvm4.err") or ""))
        row.update(cls="REFUSED", reason=f"compile rc={hrc}; core rc={crc}; " + refusal(err))
        return row
    if crc == 124:
        row.update(cls="CORE-TIMEOUT", reason="core rc=124")
    elif crc != 0:
        row.update(cls="CORE-FAIL", reason=f"core rc={crc}")
    run_txt = rd(b + ".run") or ""; rrc = int(rd(b + ".run.rc") or -1)
    m = re.search(r"- Itrs: (\d+)", run_txt)
    if m: row["itrs"] = m.group(1)
    rline = run_txt.split("\n")[0] if run_txt else ""
    row["hvm_raw"] = rline[:3000]
    if row["cls"]: return row
    if res is None:
        row.update(cls="NO-MAIN", reason="core printed no result block; runtime: " + (rd(b + ".run.err") or "").strip()[:80])
        return row
    if rrc != 0:
        row.update(cls="HVM-TIMEOUT" if rrc == 124 else "HVM-CRASH", reason=f"hvm rc={rrc}" + (f" (killed by signal {-rrc})" if rrc < 0 else "") + "; " + (rd(b + ".run.err") or "").strip()[:150])
        return row
    try:
        ty, vraw, hv, trailer = split_root(rline)
    except PErr as e:
        row.update(cls="NOT-COMPARABLE", reason=f"runtime root unparsable: {e}"); return row
    row["hvm_raw"] = vraw[:3000] + (f"   [type {ty[:200]}]" if ty else "") + (f"   [trailer {trailer}]" if trailer else "")
    hv = canon(hv)
    try:
        cvals = [canon(CoreP(l).full()) for l in res]
    except PErr as e:
        row.update(cls="NOT-COMPARABLE", reason=str(e)); return row
    row["hvm_norm"] = show(hv)
    row["core_norm"] = " | ".join(show(c) for c in cvals)
    if len(cvals) != 1:
        # Core's collapse printed several results: main is a superposition
        hcol = collapse(hv)
        match = len(hcol) == len(cvals) and all(eq(c, h)[0] is True for c, h in zip(cvals, hcol))
        row["collapsed"] = ("yes" if match else "no") + f" (runtime collapsed: {' | '.join(show(h) for h in hcol)[:300]})"
        row.update(cls="NOT-COMPARABLE", reason=f"superposition: core printed {len(cvals)} collapsed results; runtime {'is &sup' if first(hv,'sup') else 'has no sup'}")
        return row
    ok, why = eq(cvals[0], hv)
    if ok is None:
        if why.endswith("superposition"):
            hcol = collapse(hv)
            match = len(hcol) == 1 and eq(cvals[0], hcol[0])[0] is True
            row["collapsed"] = ("yes" if match else "no") + f" (runtime collapsed: {' | '.join(show(h) for h in hcol)[:300]})"
        row.update(cls="NOT-COMPARABLE", reason=why)
    elif ok:
        row.update(cls="AGREE")
    else:
        row.update(cls="DISAGREE", reason=why or "values differ")
    return row

def main():
    args = sys.argv[1:]
    norun = "--no-run" in args
    files = [a for a in args if a != "--no-run"]
    if not files:
        ls = subprocess.run(["git", "-C", REPO, "ls-files", "*.bend"], capture_output=True, text=True).stdout.split()
        files = [os.path.join(REPO, f) for f in ls] + EXTRA
    os.makedirs(RAW, exist_ok=True)
    if not norun:
        with cf.ThreadPoolExecutor(4) as ex: list(ex.map(collect, files))
    rows = [classify(f) for f in files]
    cols = ["file", "cls", "reason", "core_raw", "hvm_raw", "core_norm", "hvm_norm", "itrs", "collapsed"]
    with open(os.path.join(DIR, "report.tsv"), "w") as o:
        o.write("\t".join(cols) + "\n")
        for r in rows:
            o.write("\t".join(str(r[c]).replace("\t", " ").replace("\n", " ") for c in cols) + "\n")
    from collections import Counter
    for k, n in sorted(Counter(r["cls"] for r in rows).items()): print(f"{k}\t{n}")

if __name__ == "__main__":
    main()
