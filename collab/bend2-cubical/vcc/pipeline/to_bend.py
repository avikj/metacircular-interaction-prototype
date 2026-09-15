#!/usr/bin/env python3
"""Export a finite slice of the data to a Bend program over Perturb.bend, run it on HVM4,
and check the runtime's elucidation against numpy on the same fixed-point integers.

The slice: one validation context, `--cells` control cells, a `--genes`-gene panel (the
genes the chosen target's generator moves most), one or more knockdowns applied in sequence
(a derivation of length len(--targets)). main returns the elucidation's readouts:
  [ terminal population ; pseudobulk ; up-delta ; down-delta ; DE gene indices (>= thr) ; length ; MAE vs truth pseudobulk ]
Also writes the same slice as a four-separate-folds program to measure sharing.
"""
import argparse, json, os, re, subprocess, tempfile, numpy as np, anndata as ad, scipy.sparse as sp

def dense(X): return X.toarray() if sp.issparse(X) else np.asarray(X)
def lit(xs): return "[" + ", ".join(str(int(x)) for x in xs) + "]"
def pop(P): return "[" + ", ".join(lit(c) for c in P) + "]"

def parse_hvm(s):
    """#Con{a, #Con{b, #Nil{}}} -> python lists; numbers -> int; #Suc/#Zer -> int."""
    s = s.strip(); pos = [0]
    def peek(): return s[pos[0]] if pos[0] < len(s) else ""
    def term():
        while peek() in " ,": pos[0] += 1
        if s.startswith("#Con{", pos[0]):
            pos[0] += 5; h = term(); t = term(); pos[0] += 1; return [h] + t
        if s.startswith("#Nil{}", pos[0]): pos[0] += 6; return []
        if s.startswith("#Zer{}", pos[0]): pos[0] += 6; return 0
        if s.startswith("#Suc{", pos[0]): pos[0] += 5; n = term(); pos[0] += 1; return n + 1
        if s.startswith("#Pair{", pos[0]):
            pos[0] += 6; a = term(); b = term(); pos[0] += 1; return (a, b)
        if s.startswith("#sv{", pos[0]):
            pos[0] += 4; a = term(); b = term(); pos[0] += 1; return ("sv", a, b)
        m = re.match(r"-?\d+", s[pos[0]:]);
        if m: pos[0] += m.end(); return int(m.group())
        raise ValueError("unparsed at %d: %r" % (pos[0], s[pos[0]:pos[0]+40]))
    return term()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--controls", required=True); ap.add_argument("--truth", required=True)
    ap.add_argument("--generators", required=True); ap.add_argument("--context", default="A")
    ap.add_argument("--targets", nargs="+", default=None, help="knockdowns applied in sequence (default: first installed)")
    ap.add_argument("--cells", type=int, default=8); ap.add_argument("--genes", type=int, default=12)
    ap.add_argument("--thr", type=int, default=300, help="DE threshold in fixed point (0.3 log units)")
    ap.add_argument("--out", default="data/bend"); ap.add_argument("--bend", default=None); ap.add_argument("--hvm", default="/tmp/HVM4/src/hvm")
    ap.add_argument("--port-dir", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "port"))
    a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
    bend = a.bend or open("/tmp/BENDBIN_F").read().strip()
    gens = json.load(open(a.generators)); scale = gens["scale"]; genes = np.array(gens["genes"])
    targets = a.targets or [next(iter(gens["generators"]))]
    for t in targets: assert t in gens["generators"], f"no generator installed for {t}"
    ctl = ad.read_h5ad(a.controls); tru = ad.read_h5ad(a.truth)
    Xc = dense(ctl[ctl.obs["context"].astype(str) == a.context].X); Xc = Xc[: a.cells]
    # gene panel: the genes the first target's generator moves most (plus the target itself)
    g0 = gens["generators"][targets[0]]; d0 = np.array(g0["up"]) - np.array(g0["down"])
    panel = list(np.argsort(-np.abs(d0))[: a.genes]); ti = int(np.flatnonzero(genes == targets[0])[0])
    if ti not in panel: panel[-1] = ti
    panel = sorted(panel)
    Pq = np.rint(Xc[:, panel] * scale).astype(np.int64)
    K = {t: (np.array(gens["generators"][t]["up"])[panel], np.array(gens["generators"][t]["down"])[panel]) for t in targets}
    # truth pseudobulk for the LAST target in this context, on the panel (the MAE reference)
    m = (tru.obs["context"].astype(str) == a.context) & (tru.obs["target_gene"].astype(str) == targets[-1])
    truth_pb = np.rint(dense(tru[m].X)[:, panel].mean(0) * scale).astype(np.int64)
    # numpy reference of the machine on the same integers
    P = Pq.copy(); ups = np.zeros(len(panel), np.int64); downs = np.zeros(len(panel), np.int64)
    for t in targets:
        pb0 = P.sum(0) // P.shape[0]; P = np.maximum(P + K[t][0][None, :] - K[t][1][None, :], 0); pb1 = P.sum(0) // P.shape[0]
        ups += np.maximum(pb1 - pb0, 0); downs += np.maximum(pb0 - pb1, 0)
    ref = {"pop": P.tolist(), "pb": (P.sum(0) // P.shape[0]).tolist(), "up": ups.tolist(), "down": downs.tolist(),
           "deg": [i for i in range(len(panel)) if ups[i] >= a.thr or downs[i] >= a.thr], "len": len(targets),
           "mae": int(np.abs((P.sum(0) // P.shape[0]) - truth_pb).sum() // len(panel))}
    # the knowledge table: target index -> generator; anything else is the identity
    tids = {t: int(np.flatnonzero(genes == t)[0]) for t in targets}
    kcases = "".join(f"      case @kd{{g}}: if g == {tids[t]}: @shift{{{lit(K[t][0])}, {lit(K[t][1])}}} else: " for t in targets)
    ktail = "@shift{[], []}"
    kbody = "match a:\n      case @ntc{}: @shift{[], []}\n" + "      case @kd{g}: " + " else: ".join(
        f"if g == {tids[t]}: @shift{{{lit(K[t][0])}, {lit(K[t][1])}}}" for t in targets) + " else: @shift{[], []}"
    # the derivation: P0 -kd t1-> P1 -kd t2-> ... ; endpoints written through stepK
    states = ["dataP"]
    for i, t in enumerate(targets): states.append(f"stepK(u64Num, dataK, {states[-1]}, @kd{{{tids[t]}}})")
    deriv = "@done{{==}}"
    for i in range(len(targets) - 1, -1, -1):
        deriv = f"@then{{{states[i+1]}, @act{{@kd{{{tids[targets[i]]}}}, {{==}}}}, {deriv}}}"
    end = states[-1]
    header = f"""# generated by vcc/pipeline/to_bend.py — context {a.context}, {len(panel)} genes {[str(genes[i]) for i in panel]}, {Pq.shape[0]} cells, knockdowns {targets}
import Perturb
def dataP() -> Pop(u64Num):
  {pop(Pq)}
def dataK() -> Knowledge(u64Num):
  lambda a.
    {kbody}
def truthPB() -> Vec(u64Num):
  {lit(truth_pb)}
def dataD() -> Deriv(u64Num, dataK, dataP, {end}):
  {deriv}
def restT() -> Set:
  Motion(u64Num, dataK, prodR(u64Num, dataK, deltaR(u64Num, dataK), prodR(u64Num, dataK, lenR(u64Num, dataK), traceR(u64Num, dataK))), dataP, {end})
"""
    one = header + f"""def readouts(e: any x: Pop(u64Num). restT) -> U64[][]:
  match e:
    case (pop, rest):
      match rest:
        case (dl, rest2):
          match rest2:
            case (n, tr):
              match dl:
                case @sv{{u, d}}:
                  [pseudobulk(u64Num, pop), u, d, degSetFrom(u64Num, 0, {a.thr}, u, d), [fromNat(u64Num, n)], [mae(u64Num, pseudobulk(u64Num, pop), truthPB)]]
def main() -> U64[][]:
  readouts(elucidate(u64Num, dataK, dataP, {end}, dataD))
"""
    four = header + f"""def main() -> U64[][]:
  match fold(u64Num, dataK, deltaR(u64Num, dataK), dataP, {end}, dataD):
    case @sv{{u, d}}:
      [pseudobulk(u64Num, fold(u64Num, dataK, popR(u64Num, dataK), dataP, {end}, dataD)), u, d, degSetFrom(u64Num, 0, {a.thr}, u, d),
       [fromNat(u64Num, fold(u64Num, dataK, lenR(u64Num, dataK), dataP, {end}, dataD))],
       [mae(u64Num, pseudobulk(u64Num, fold(u64Num, dataK, popR(u64Num, dataK), dataP, {end}, dataD)), truthPB)]]
"""
    results = {"context": a.context, "panel": [str(genes[i]) for i in panel], "cells": int(Pq.shape[0]), "targets": targets, "numpy": ref}
    for name, src in (("vcc_one_fold", one), ("vcc_four_folds", four)):
        path = os.path.join(a.out, name + ".bend"); open(path, "w").write(src)
        env = dict(os.environ, LC_ALL="C.utf8", LANG="C.utf8")
        chk = subprocess.run([bend, os.path.abspath(path)], cwd=a.port_dir, capture_output=True, text=True, env=env)
        ok, ko = chk.stdout.count("✓"), chk.stdout.count("✗")
        with tempfile.TemporaryDirectory() as td:
            hv = os.path.join(td, "m.hvm4")
            em = subprocess.run([bend, os.path.abspath(path), "--to-hvm4-full"], cwd=a.port_dir, capture_output=True, text=True, env=env)
            open(hv, "w").write(em.stdout)
            run = subprocess.run([a.hvm, hv, "-s"], capture_output=True, text=True, timeout=3600)
        first = run.stdout.strip().splitlines()[0] if run.stdout.strip() else ""
        itrs = re.search(r"Itrs:\s*(\d+)", run.stdout); tm = re.search(r"Time:\s*([\d.]+)", run.stdout)
        val = parse_hvm(first) if first.startswith("#") else None
        agree = None
        if val is not None:
            pb, u, d, deg, n, mae_ = val
            agree = {"pseudobulk": pb == ref["pb"], "up": u == ref["up"], "down": d == ref["down"], "deg": deg == ref["deg"], "len": n == [ref["len"]], "mae": mae_ == [ref["mae"]]}
        results[name] = {"check_ok": ok, "check_ko": ko, "interactions": int(itrs.group(1)) if itrs else None,
                         "seconds": float(tm.group(1)) if tm else None, "value": val, "agrees_with_numpy": agree, "stderr": (em.stderr + run.stderr)[-500:]}
        print(f"{name}: check ✓{ok} ✗{ko}; HVM4 {results[name]['interactions']} interactions; agrees with numpy: {agree}")
    json.dump(results, open(os.path.join(a.out, "results.json"), "w"), indent=1)

if __name__ == "__main__":
    main()
