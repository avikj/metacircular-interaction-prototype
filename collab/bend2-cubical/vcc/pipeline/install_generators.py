#!/usr/bin/env python3
"""Install the perturbational generators from training knowledge.

For every knockdown target g seen in training, the generator is the shift
  delta_g = mean over training contexts of [ pseudobulk(g, ctx) - pseudobulk(non-targeting, ctx) ]
in log-expression space — the context-invariant part of the response, which is
exactly what transfers to an unseen context. Written in fixed point (scale 1000) as
(up, down) = (max(delta,0), max(-delta,0)): the @shift{up, down} generator of Perturb.bend.
Nothing latent: the generator is the public pseudobulk difference itself.
Works unchanged on the VCC training h5ad (obs target_gene / non-targeting) or Tahoe-style
files when reachable.
"""
import argparse, json, numpy as np, anndata as ad, scipy.sparse as sp

def dense(X): return X.toarray() if sp.issparse(X) else np.asarray(X)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--train", required=True)
    ap.add_argument("--out", default="data/generators.json")
    ap.add_argument("--pert-col", default="target_gene"); ap.add_argument("--ctx-col", default="context")
    ap.add_argument("--control", default="non-targeting"); ap.add_argument("--scale", type=int, default=1000)
    a = ap.parse_args()
    ad_ = ad.read_h5ad(a.train)
    X = dense(ad_.X).astype(np.float64); pert = ad_.obs[a.pert_col].astype(str).values
    ctx = ad_.obs[a.ctx_col].astype(str).values if a.ctx_col in ad_.obs else np.array(["all"] * ad_.n_obs)
    gens, n_ctx = {}, {}
    for c in np.unique(ctx):
        m = ctx == c; ctrl = X[m & (pert == a.control)].mean(0)
        for g in np.unique(pert[m]):
            if g == a.control: continue
            d = X[m & (pert == g)].mean(0) - ctrl
            gens[g] = gens.get(g, 0) + d; n_ctx[g] = n_ctx.get(g, 0) + 1
    out = {"genes": ad_.var_names.tolist(), "scale": a.scale, "generators": {}}
    for g, d in gens.items():
        d = d / n_ctx[g]; q = np.rint(d * a.scale).astype(np.int64)
        out["generators"][g] = {"up": np.maximum(q, 0).tolist(), "down": np.maximum(-q, 0).tolist(), "n_contexts": n_ctx[g]}
    json.dump(out, open(a.out, "w"))
    print(f"installed {len(out['generators'])} generators over {len(out['genes'])} genes -> {a.out}")

if __name__ == "__main__":
    main()
