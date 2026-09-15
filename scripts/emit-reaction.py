#!/usr/bin/env python3
"""emit-reaction.py — the front-end for the reaction-network presentation.

Reads an SBML (Level 3 core; also Level 2) model with xml.etree — species,
reactions with reactant/product stoichiometries, modifiers — and an
optional PEtab-shaped JSON (conditions = initial amounts, experiments =
words of reactions, observables = species read out), and emits a Bend file
in the shape of collab/bend2-cubical/port/Reaction.bend: species levels as a
record, reactions as a finite type, the generator action `fire` (a reaction
fires iff every reactant is present at its stoichiometry and every modifier
is present; otherwise the state is unchanged), histories as derivations over
`fire`, the receiver machinery (fold, uniqueness), readouts as folds (event
count, per-reaction flux, endpoint, word), and the PEtab shape: each
condition a state, each experiment a word, each observable a receiver,
with the emitter's own evaluation of every (condition, experiment,
observable) stated as a `refl` theorem — so the checker certifies that the
emitted generator and the emitter's model of it agree.

    python3 scripts/emit-reaction.py model.xml [--petab petab.json] -o Out.bend
    LC_ALL=C.utf8 bend Out.bend

Discrete amounts only (the stochastic / Petri-net reading of SBML); rate
laws are not read. Conservation, commutation and reduction theorems are
stated by hand per model (Reaction.bend shows the pattern); the emitter
states what it can decide by computation.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


def ident(x: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_]", "_", x).lower()
    if not s or s[0].isdigit():
        s = "s_" + s
    return s


def local(tag: str) -> str:
    return tag.split("}", 1)[1] if "}" in tag else tag


def parse_sbml(path: Path):
    root = ET.parse(path).getroot()
    model = next(el for el in root.iter() if local(el.tag) == "model")
    species = []
    init = {}
    for el in model.iter():
        if local(el.tag) == "species":
            sid = el.attrib["id"]
            species.append(sid)
            amt = el.attrib.get("initialAmount", el.attrib.get("initialConcentration", "0"))
            init[sid] = int(float(amt))
    reactions = []
    for el in model.iter():
        if local(el.tag) != "reaction":
            continue
        rid = el.attrib["id"]
        reac, prod, mods = {}, {}, []
        for child in el:
            t = local(child.tag)
            if t == "listOfReactants":
                for sr in child:
                    reac[sr.attrib["species"]] = int(float(sr.attrib.get("stoichiometry", "1")))
            elif t == "listOfProducts":
                for sr in child:
                    prod[sr.attrib["species"]] = int(float(sr.attrib.get("stoichiometry", "1")))
            elif t == "listOfModifiers":
                for sr in child:
                    mods.append(sr.attrib["species"])
        reactions.append((rid, reac, prod, mods))
        if el.attrib.get("reversible", "false").lower() == "true":
            reactions.append((rid + "_rev", dict(prod), dict(reac), list(mods)))
    return species, init, reactions


def fire_py(state: dict, rx) -> dict:
    rid, reac, prod, mods = rx
    if any(state[s] < n for s, n in reac.items()) or any(state[m] < 1 for m in mods):
        return dict(state)
    out = dict(state)
    for s, n in reac.items():
        out[s] -= n
    for s, n in prod.items():
        out[s] += n
    return out


def emit(species, init, reactions, petab):
    S = [ident(s) for s in species]
    R = [ident(r[0]) for r in reactions]
    vars_ = ", ".join(f"v_{s}" for s in S)
    out = []
    w = out.append
    w("# EMITTED by scripts/emit-reaction.py — do not edit; edit the SBML / PEtab.")
    w(f"# species {species}; reactions {[r[0] for r in reactions]}")
    w("import Prelude")
    w("")
    w("# §1 the finite presentation")
    w("type St:")
    w("  case @st:")
    for s in S:
        w(f"    {s}: Nat")
    for s in S:
        w(f"def {s}Of(x: St) -> Nat:")
        w(f"  match x: case @st{{{vars_}}}: v_{s}")
    w("type Rxn:")
    for r in R:
        w(f"  case @{r}:")
    # fire: for each reaction, nested matches peeling `stoich` successors off each reactant
    w("def fire(x: St, r: Rxn) -> St:")
    w("  match x:")
    w(f"    case @st{{{vars_}}}:")
    w("      match r:")
    for (rid, reac, prod, mods), r in zip(reactions, R):
        w(f"        case @{r}{{}}:")
        indent = "          "
        # peel: for each reactant s with stoichiometry n, match v_s as n successors
        peeled = {}  # species -> variable name holding the remainder
        depth = 0
        unchanged = "@st{" + vars_ + "}"
        for s, n in list(reac.items()) + [(m, 1) for m in mods if m not in reac]:
            si = ident(s)
            cur = f"v_{si}"
            for k in range(n):
                nxt = f"p_{si}_{k}"
                w(f"{indent}match {cur}:")
                w(f"{indent}  case 0n: {unchanged}")
                w(f"{indent}  case 1n + {nxt}:")
                indent += "    "
                cur = nxt
            peeled[s] = cur
        levels = []
        for sp, si in zip(species, S):
            if sp in reac and sp not in prod:
                base = peeled[sp]
            elif sp in reac and sp in prod:
                base = peeled[sp]
            elif sp in mods and sp not in reac:
                base = f"1n + {peeled[sp]}"  # a modifier is present and unchanged
            else:
                base = f"v_{si}"
            add_n = prod.get(sp, 0)
            levels.append(("1n + " * add_n) + base)
        w(f"{indent}@st{{{', '.join(levels)}}}")
    w("type Step(x: St, y: St):")
    w("  case @act:")
    w("    r: Rxn")
    w("    ey: St{y == fire(x, r)}")
    w("type Derivation(x: St, z: St):")
    w("  case @done:")
    w("    e: St{z == x}")
    w("  case @then:")
    w("    y: St")
    w("    s: Step(x, y)")
    w("    d: Derivation(y, z)")
    w("def stepRxn(x: St, y: St, s: Step(x, y)) -> Rxn:")
    w("  match s: case @act{r, ey}: r")
    w("")
    w("# §2 receiver, fold, uniqueness")
    w("""def foldM(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c), a: St, z: St, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))
def fold_unique(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c),
                g: all a: St. all z: St. Derivation(a, z) -> M(a, z),
                g_done: all t: St. Path(M(t, t), g(t, t, @done{{==}}), e(t)),
                g_step: all a: St. all y: St. all z: St. all s: Step(a, y). all d: Derivation(y, z). Path(M(a, z), g(a, z, @then{y, s, d}), k(a, y, z, s, g(y, z, d))),
                a: St, z: St, d: Derivation(a, z)) -> Path(M(a, z), g(a, z, d), foldM(M, e, k, a, z, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: g_done(a)
    case @then{y, s, d2}:
      compPath(M(a, z), g(a, z, @then{y, s, d2}), k(a, y, z, s, g(y, z, d2)), k(a, y, z, s, foldM(M, e, k, y, z, d2)),
        g_step(a, y, z, s, d2),
        <i> k(a, y, z, s, fold_unique(M, e, k, g, g_done, g_step, y, z, d2) @ i))""")
    w("")
    w("# §3 readouts as folds")
    w("def natM(a: St, b: St) -> Set:")
    w("  Nat")
    w("def events(a: St, z: St, d: Derivation(a, z)) -> Nat:")
    w("  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)")
    w("def sameRxn(r: Rxn, r2: Rxn) -> Bool:")
    w("  match r:")
    for r in R:
        w(f"    case @{r}{{}}:")
        w("      match r2:")
        for r2 in R:
            w(f"        case @{r2}{{}}: {'True' if r2 == r else 'False'}")
    w("""def tick(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
def flux(r: Rxn, a: St, z: St, d: Derivation(a, z)) -> Nat:
  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. tick(sameRxn(r, stepRxn(a2, b, s)), n), a, z, d)
def endM(a: St, b: St) -> Set:
  St
def endpoint(a: St, z: St, d: Derivation(a, z)) -> St:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def endpoint_is_endpoint(a: St, z: St, d: Derivation(a, z)) -> Path(St, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)
def wordM(a: St, b: St) -> Set:
  Rxn[]
def word(a: St, z: St, d: Derivation(a, z)) -> Rxn[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepRxn(a2, b, s) <> w, a, z, d)
def runR(x: St, w: Rxn[]) -> St:
  match w:
    case []: x
    case r <> rest: runR(fire(x, r), rest)
def word_replays(a: St, z: St, d: Derivation(a, z)) -> Path(St, runR(a, word(a, z, d)), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      match s:
        case @act{r, ey}:
          match ey: case {==}: word_replays(fire(a, r), z, d2)""")
    w("")
    w("# §4 the PEtab shape: conditions, experiments, observables — and the emitter's")
    w("# own evaluation of each, certified by refl against the emitted generator")
    conds = petab.get("conditions", {}) or {"initial": init}
    exps = petab.get("experiments", {}) or {}
    obs = petab.get("observables", species[:1])

    def st_of(d):
        return "@st{" + ", ".join(f"{int(d.get(sp, 0))}n" for sp in species) + "}"

    for cn, cd in conds.items():
        w(f"def cond_{ident(cn)}() -> St:")
        w(f"  {st_of(cd)}")
    for en, wd in exps.items():
        w(f"def exp_{ident(en)}() -> Rxn[]:")
        w("  [" + ", ".join(f"@{ident(r)}" for r in wd) + "]")
    rx_by_id = {r[0]: r for r in reactions}
    first = None
    for cn, cd in conds.items():
        for en, wd in exps.items():
            state = {sp: int(cd.get(sp, 0)) for sp in species}
            for rid in wd:
                state = fire_py(state, rx_by_id[rid])
            for o in obs:
                name = f"meas_{ident(cn)}_{ident(en)}_{ident(o)}"
                w(f"def {name}() -> Path(Nat, {ident(o)}Of(runR(cond_{ident(cn)}(), exp_{ident(en)}())), {state[o]}n):")
                w(f"  <_> {state[o]}n")
                first = first or (cn, en, o)
    w("")
    w("def main() -> Nat:")
    if first:
        cn, en, o = first
        w(f"  {ident(o)}Of(runR(cond_{ident(cn)}(), exp_{ident(en)}()))")
    else:
        w("  0n")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("sbml", type=Path)
    ap.add_argument("--petab", type=Path, default=None, help="JSON: conditions, experiments, observables")
    ap.add_argument("-o", "--out", type=Path, default=None)
    a = ap.parse_args()
    species, init, reactions = parse_sbml(a.sbml)
    petab = json.loads(a.petab.read_text()) if a.petab else {}
    text = emit(species, init, reactions, petab)
    if a.out:
        a.out.write_text(text)
        print(f"wrote {a.out} ({len(text.splitlines())} lines)", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()
