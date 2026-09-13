/* The kernel pad: Agda in this very browser — phone included.
 *
 * The pinned kernel (2.8.0, WASM) runs in a worker; the pad is a scratch
 * module against it: check, holes with goal types, infer, normalize.
 * Everything shown is parsed from the kernel's own JSON utterances.
 * First boot downloads ~31 MB once (then the browser caches it).
 */

let worker = null;
let seq = 0;
const pending = new Map();

function call(msg) {
  return new Promise((resolve, reject) => {
    const id = ++seq;
    pending.set(id, { resolve, reject });
    worker.postMessage({ id, ...msg });
  });
}

function ensureWorker(base) {
  if (worker) return;
  worker = new Worker(new URL("./kernel/worker.js", base), { type: "module" });
  worker.onmessage = (ev) => {
    const p = pending.get(ev.data.id);
    if (!p) return;
    pending.delete(ev.data.id);
    if (ev.data.error) p.reject(new Error(ev.data.error));
    else p.resolve(ev.data);
  };
}

function parseLines(lines) {
  const out = { errors: [], goals: [], infos: [] };
  for (const raw of lines) {
    let l = raw;
    if (l.startsWith("JSON> ")) l = l.slice(6);
    if (!l.startsWith("{")) continue;
    let m;
    try { m = JSON.parse(l); } catch (e) { continue; }
    const info = m.info || {};
    if (info.kind === "Error") {
      out.errors.push((info.error && info.error.message) || JSON.stringify(info.error));
    }
    if (info.kind === "AllGoalsWarnings") {
      for (const g of info.visibleGoals || []) {
        const c = g.constraintObj || {};
        out.goals.push({
          id: c.id != null ? c.id : g.id,
          type: g.type || "",
          line: (((c.range || [])[0] || {}).start || {}).line,
        });
      }
    }
    if (info.kind === "InferredType") out.infos.push(["type", info.expr]);
    if (info.kind === "NormalForm") out.infos.push(["normal form", info.expr]);
    if (info.kind === "GoalSpecific" && info.goalInfo) {
      out.infos.push(["goal", info.goalInfo.type,
        (info.goalInfo.entries || []).map((e) => `${e.originalName} : ${e.binding}`)]);
    }
  }
  return out;
}

const STARTER = `{-# OPTIONS --safe #-}
module Pad where

data Nat : Set where
  zero : Nat
  suc  : Nat -> Nat

_+_ : Nat -> Nat -> Nat
zero  + n = n
suc m + n = suc (m + n)

two : Nat
two = suc (suc zero)

-- a hole for the kernel to hold open:
double : Nat -> Nat
double n = {!!}
`;

export function mountKernelPad(host, helpers) {
  const { el } = helpers;
  host.innerHTML = "";

  const note = el("p", "about",
    "The pinned kernel — Agda 2.8.0 compiled to WebAssembly — runs in this " +
    "browser, on this device. Nothing leaves the page. The first check " +
    "downloads the kernel once (~31 MB); after that it is cached.");
  const ed = document.createElement("textarea");
  ed.id = "pad-editor";
  ed.spellcheck = false;
  ed.value = (() => {
    try { return localStorage.getItem("pad-src") || STARTER; }
    catch (e) { return STARTER; }
  })();
  ed.style.cssText =
    "width:100%;height:380px;font:13px/1.5 var(--mono);color:var(--ink);" +
    "background:var(--card);border:1px solid var(--line);border-radius:8px;" +
    "padding:12px 14px;tab-size:2;resize:vertical;white-space:pre";

  const bar = el("div");
  bar.style.cssText = "display:flex;gap:8px;align-items:center;margin:8px 0;flex-wrap:wrap";
  const checkBtn = el("button", "", "check");
  const busy = el("span", "", "");
  busy.style.cssText = "font:12px var(--mono);color:var(--accent-ink)";
  bar.append(checkBtn, busy);

  const out = el("div");
  out.style.cssText = "display:flex;flex-direction:column;gap:6px";

  const ask = el("div");
  ask.style.cssText = "display:flex;gap:8px;margin-top:10px;flex-wrap:wrap";
  const askIn = document.createElement("input");
  askIn.id = "pad-ask";
  askIn.placeholder = "any expression in the module's scope";
  askIn.style.cssText = "flex:1;min-width:180px;font:13px var(--mono);" +
    "background:var(--card);color:var(--ink);border:1px solid var(--line);" +
    "border-radius:6px;padding:6px 10px";
  const inferBtn = el("button", "", "type");
  const normBtn = el("button", "", "normal form");
  ask.append(askIn, inferBtn, normBtn);

  host.append(note, ed, bar, out, ask);

  const panel = (title, body, tone) => {
    const box = el("div");
    box.style.cssText =
      "border:1px solid " + (tone === "bad" ? "var(--red-design)" :
        tone === "good" ? "var(--proved)" : "var(--line)") +
      ";border-left-width:4px;border-radius:6px;padding:8px 12px;" +
      "background:var(--card);font:12.5px/1.5 var(--mono);white-space:pre-wrap;" +
      "overflow-x:auto";
    const h = el("div", "", title);
    h.style.cssText = "font:600 11px var(--sans);letter-spacing:0.08em;" +
      "text-transform:uppercase;color:var(--ink-dim);margin-bottom:4px";
    box.append(h, el("div", "", body));
    return box;
  };

  let booted = false;
  const working = async (label, fn) => {
    busy.textContent = label + "…";
    checkBtn.disabled = inferBtn.disabled = normBtn.disabled = true;
    try {
      ensureWorker(import.meta.url);
      if (!booted) {
        busy.textContent = "fetching the kernel (once)…";
        await call({ op: "boot", base: new URL("./", import.meta.url).href });
        booted = true;
      }
      busy.textContent = label + "…";
      return await fn();
    } catch (e) {
      out.prepend(panel("the pad", String(e.message || e), "bad"));
    } finally {
      busy.textContent = "";
      checkBtn.disabled = inferBtn.disabled = normBtn.disabled = false;
    }
  };

  const save = () => { try { localStorage.setItem("pad-src", ed.value); } catch (e) {} };

  const runCmds = async (cmds) => {
    save();
    const r = await call({ op: "run", file: "Pad.agda", text: ed.value,
                           commands: ["Cmd_load \"/opt/Pad.agda\" []", ...cmds] });
    return parseLines(r.lines);
  };

  checkBtn.onclick = () => working("the kernel is checking", async () => {
    const p = await runCmds([]);
    out.innerHTML = "";
    if (p.errors.length) {
      for (const e of p.errors) out.append(panel("the kernel refuses", e, "bad"));
      return;
    }
    if (!p.goals.length) {
      out.append(panel("checked", "no errors, no holes — the module is entire", "good"));
      return;
    }
    for (const g of p.goals) {
      out.append(panel(
        `hole ?${g.id}` + (g.line ? `  ·  line ${g.line}` : ""),
        g.type || "", ""));
    }
  });

  const askKernel = (cmd, label) => () => working(label, async () => {
    const expr = askIn.value.trim();
    if (!expr) return;
    const escd = expr.replace(/"/g, '\\"');
    const p = await runCmds([cmd.replace("EXPR", escd)]);
    if (p.errors.length) {
      out.prepend(panel("the kernel refuses", p.errors[0], "bad"));
      return;
    }
    for (const [kind, body] of p.infos) {
      out.prepend(panel(`${expr}  ·  ${kind}`, body, "good"));
    }
  });
  inferBtn.onclick = askKernel('Cmd_infer_toplevel Normalised "EXPR"', "inferring");
  normBtn.onclick = askKernel('Cmd_compute_toplevel DefaultCompute "EXPR"', "computing");
  askIn.addEventListener("keydown", (e) => {
    if (e.key === "Enter") (e.shiftKey ? normBtn : inferBtn).click();
  });
}
