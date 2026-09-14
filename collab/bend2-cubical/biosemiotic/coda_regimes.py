#!/usr/bin/env python3
"""Regimes of the superposed pass on real codas, measured on HVM4.

Reads out/sample_codas.tsv (written by coda_elucidator.py) and emits:
  out/coda_lens10.hvm4     the same codas read through the coarse lens (10 bins
                           per unit of normalised duration): equal shapes are
                           printed as equal terms — the rhythm CLASS is a
                           quotient by this lens, not an identity at ms scale
  out/coda_spec.hvm4       spec-driven selection: keep the codas whose lens-10
                           shape is the class [3,3,2,2]; other branches erase
                           (&{}) — SupGen's mechanism on communication data
  out/coda_transport.hvm4  transport: coda A's shape re-expressed at coda B's
                           tempo (translation along the tempo fibre)
  out/sep_<k>.hvm4         each coda run separately, to measure the cost of the
                           superposed pass against the sum of separate passes
Then runs them all (HVM binary path in $HVM) and writes out/RESULTS_regimes.txt.
"""
import os, subprocess, sys, ast, re
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
HVM = os.environ.get("HVM", "hvm")
rows = [l.rstrip("\n").split("\t") for l in open(os.path.join(OUT, "sample_codas.tsv"))][1:]
codas = [(r[0], ast.literal_eval(r[1])) for r in rows]
def hl(xs): return "[" + ", ".join(str(x) for x in xs) + "]"
def sup(ts):
    if len(ts) == 1: return ts[0]
    h = len(ts)//2; return f"&L{{{sup(ts[:h])}, {sup(ts[h:])}}}"
PRE = ["@sum   = λ{[]: 0; <>: λh. λt. (h + @sum(t))}",
       "@scale = λ&T. λ&R. λ{[]: []; <>: λh. λt. (((h * R) + (T / 2)) / T) <> @scale(T, R, t)}",
       "// lens: the rhythm read at R bins per unit of normalised duration",
       "@lens  = λR. λ&c. @scale(@sum(c), R, c)"]
def write(name, lines): open(os.path.join(OUT, name), "w").write("\n".join(lines) + "\n")

write("coda_lens10.hvm4", ["// real codas through the coarse lens (R = 10): equal shape terms = one class"] + PRE +
      ["@codas = " + sup([hl(c) for _, c in codas]), "@main = @lens(10, @codas)"])
write("coda_spec.hvm4", ["// spec-driven selection over the superposition: survivors are the codas whose",
      "// lens-10 shape IS the class [3,3,2,2] (Sharma's 1+1+3 / 5R1 rhythm family);",
      "// every other branch erases. Search inside evaluation, shared work, certified survivors."] + PRE +
      ["@keep  = λ&c. λ{ 0: &{} ; _: λp. #OK{c} }(@lens(10, c) === [3, 3, 2, 2])",
       "@codas = " + sup([hl(c) for _, c in codas]), "@main = @keep(@codas)"])
A = codas[0][1]; B = codas[9][1]   # a 5R3 coda and a 5R1 coda
write("coda_transport.hvm4", [
      f"// transport along the tempo fibre: the rhythm of coda A {A} ({codas[0][0]}, tempo {sum(A)} ms)",
      f"// re-expressed at the tempo of coda B {B} ({codas[9][0]}, tempo {sum(B)} ms).",
      "// shape is what crosses; tempo is the fibre. Result: A's rhythm at B's tempo, in ms."] + PRE +
      ["@mulT  = λ&T. λ{[]: []; <>: λh. λt. (((h * T) + 500) / 1000) <> @mulT(T, t)}",
       "@fromShape = λT. λs. @mulT(T, s)",
       f"@main = @fromShape(@sum({hl(B)}), @lens(1000, {hl(A)}))"])
for k, (t, c) in enumerate(codas):
    write(f"sep_{k:02d}.hvm4", PRE + [f"@main = @lens(1000, {hl(c)})"])

def run(name, collapse=True):
    p = subprocess.run([HVM, os.path.join(OUT, name), "-s"] + (["-C40"] if collapse else []),
                       capture_output=True, text=True)
    out = re.sub(r"\x1b\[[0-9;]*m", "", p.stdout + p.stderr)
    m = re.search(r"Itrs:\s+(\d+)", out)
    return out, (int(m.group(1)) if m else None)
res = []
for name in ["coda_lens10.hvm4", "coda_spec.hvm4", "coda_transport.hvm4", "coda_shape_only.hvm4"]:
    out, it = run(name); res.append(f"### {name}\n{out}")
sep_total = 0; sep_lines = []
for k in range(len(codas)):
    out, it = run(f"sep_{k:02d}.hvm4"); sep_total += it; sep_lines.append(f"sep_{k:02d}: {it}")
_, sup_it = run("coda_shape_only.hvm4")
res.append("### cost: superposed pass vs separate passes (lens 1000, 18 real codas)\n" +
           "\n".join(sep_lines) + f"\nSUM of separate passes: {sep_total} interactions\n" +
           f"ONE superposed pass  : {sup_it} interactions\nratio superposed/separate: {sup_it/sep_total:.3f}\n" +
           "(18 different codas down 18 different lines: the regime SYNTHESIS.md §4 predicts costs ~1.4x;\n"
           " the sharing that pays is a shared LINE over many values, not many lines.)")

# the WINNING regime on real data: ornamentation. Sharma et al.'s ornament is an
# extra click appended to a coda; the ornamented and plain coda share every ICI
# but the last. Handed in as ONE list whose tail is superposed, the shared prefix
# is summed once. Measured against the two codas run separately.
orn = [(t, c) for t, c in codas if len(c) == 4][:6]
sup_orn = []; sep_orn = []
for k, (t, c) in enumerate(orn):
    extra = c[-1] * 2   # the ornament: a trailing click after a doubled interval
    write(f"orn_sup_{k}.hvm4", PRE + ["@main = @lens(1000, " + " <> ".join(str(x) for x in c) + f" <> &L{{[], [{extra}]}})"])
    write(f"orn_a_{k}.hvm4", PRE + [f"@main = @lens(1000, {hl(c)})"])
    write(f"orn_b_{k}.hvm4", PRE + [f"@main = @lens(1000, {hl(list(c) + [extra])})"])
lines = []; tot_sup = tot_sep = 0
for k, (t, c) in enumerate(orn):
    _, a = run(f"orn_sup_{k}.hvm4"); _, b = run(f"orn_a_{k}.hvm4", False); _, d = run(f"orn_b_{k}.hvm4", False)
    tot_sup += a; tot_sep += b + d
    lines.append(f"{t} {list(c)} + ornament: superposed-tail pass {a} itrs vs separate {b}+{d}={b+d}")
res.append("### the shared-prefix regime: plain coda vs ornamented coda (shared line, superposed tail)\n" +
           "\n".join(lines) + f"\nTOTAL superposed {tot_sup} vs separate {tot_sep}; ratio {tot_sup/tot_sep:.3f}")
open(os.path.join(OUT, "RESULTS_regimes.txt"), "w").write("\n".join(res))
print(res[-1])

