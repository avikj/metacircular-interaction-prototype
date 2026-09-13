/* The workbench: the kernel in the loop.
 *
 * Present only when the page is served by ide/bridge.py (the kernel
 * bridge probes true). Every answer shown here is the checker's own
 * words, verbatim — errors, goal types, contexts, inferred types,
 * normal forms. The workbench never paraphrases the kernel.
 */

let BRIDGE = null;   // {kernel} when present

export async function probeBridge() {
  try {
    const r = await fetch("/api", {
      method: "POST", body: JSON.stringify({ op: "ping" }),
    });
    if (r.ok) BRIDGE = await r.json();
  } catch (e) { BRIDGE = null; }
  return BRIDGE;
}

export function bridgePresent() { return !!BRIDGE; }

async function call(req) {
  const r = await fetch("/api", { method: "POST", body: JSON.stringify(req) });
  return r.json();
}

export function mountWorkbench(host, node, helpers) {
  const { el } = helpers;
  host.innerHTML = "";

  const status = el("div");
  status.style.cssText = "font:12px var(--mono);color:var(--ink-dim);margin:6px 0";
  status.textContent = BRIDGE ? `kernel: ${BRIDGE.kernel}` : "";

  const ed = document.createElement("textarea");
  ed.id = "wb-editor";
  ed.spellcheck = false;
  ed.style.cssText =
    "width:100%;height:420px;font:13px/1.5 var(--mono);color:var(--ink);" +
    "background:var(--card);border:1px solid var(--line);border-radius:8px;" +
    "padding:12px 14px;tab-size:2;resize:vertical;white-space:pre";

  const bar = el("div");
  bar.style.cssText = "display:flex;gap:8px;align-items:center;margin:8px 0;flex-wrap:wrap";
  const checkBtn = el("button", "", "check  (the kernel judges)");
  const revertBtn = el("button", "", "revert");
  const busy = el("span", "", "");
  busy.style.cssText = "font:12px var(--mono);color:var(--accent-ink)";
  bar.append(checkBtn, revertBtn, busy);

  const out = el("div");
  out.style.cssText = "display:flex;flex-direction:column;gap:6px";

  const ask = el("div");
  ask.style.cssText = "display:flex;gap:8px;margin-top:10px";
  const askIn = document.createElement("input");
  askIn.id = "wb-ask";
  askIn.placeholder = "ask the kernel about any expression in this module's scope";
  askIn.style.cssText = "flex:1;font:13px var(--mono);background:var(--card);" +
    "color:var(--ink);border:1px solid var(--line);border-radius:6px;padding:6px 10px";
  const inferBtn = el("button", "", "type");
  const normBtn = el("button", "", "normal form");
  ask.append(askIn, inferBtn, normBtn);

  host.append(status, ed, bar, out, ask);

  const file = node.p;
  let original = "";

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

  const working = async (label, fn) => {
    busy.textContent = label + "…";
    checkBtn.disabled = inferBtn.disabled = normBtn.disabled = true;
    try { return await fn(); }
    finally {
      busy.textContent = "";
      checkBtn.disabled = inferBtn.disabled = normBtn.disabled = false;
    }
  };

  (async () => {
    const src = await call({ op: "source", file });
    original = src.text || "";
    ed.value = original;
  })();

  checkBtn.onclick = () => working("the kernel is checking", async () => {
    await call({ op: "write", file, text: ed.value });
    const r = await call({ op: "check", file });
    out.innerHTML = "";
    if (r.errors && r.errors.length) {
      for (const e of r.errors) out.append(panel("the kernel refuses", e, "bad"));
      return;
    }
    if (!r.goals || !r.goals.length) {
      out.append(panel("checked", "no errors, no holes — the module is entire", "good"));
      return;
    }
    for (const g of r.goals) {
      const box = panel(`hole ?${g.id}` +
        (g.range && g.range[0] && g.range[0].start
          ? `  ·  line ${g.range[0].start.line}` : ""),
        g.type || "(ask for the goal)", "");
      box.style.cursor = "pointer";
      box.title = "click for the goal's context";
      box.onclick = () => working("asking the goal", async () => {
        const gi = await call({ op: "goal", file, id: g.id });
        if (gi.error) { box.append(panel("", gi.error, "bad")); return; }
        const ctx = (gi.context || [])
          .map((c) => `${c.originalName} : ${c.binding}`).join("\n");
        box.append(panel("context", ctx || "(empty)", ""));
        box.onclick = null;
      });
      out.append(box);
    }
  });

  revertBtn.onclick = async () => {
    if (ed.value !== original &&
        !confirm("Discard your edits and restore the file as it was?")) return;
    await call({ op: "write", file, text: original });
    ed.value = original;
    out.innerHTML = "";
  };

  const askKernel = (op) => () => working(op, async () => {
    const expr = askIn.value.trim();
    if (!expr) return;
    const r = await call({ op, file, expr });
    const first = out.firstChild;
    const box = r.error
      ? panel("the kernel refuses", r.error, "bad")
      : panel(op === "infer" ? `${expr}  :` : `${expr}  ⟶`,
              r.type || r.value || "", "good");
    out.insertBefore(box, first);
  });
  inferBtn.onclick = askKernel("infer");
  normBtn.onclick = askKernel("normalize");
  askIn.addEventListener("keydown", (e) => {
    if (e.key === "Enter") (e.shiftKey ? normBtn : inferBtn).click();
  });
}
