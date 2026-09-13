/* The fibre law, drawn.
 *
 * This is a picture of the mathematics, not of the library: the drawn
 * objects are the checked examples' actual elements, and every visual
 * fact renders a named theorem.
 *
 *   bind the OUTPUT  —  Σ b (f a ≡ b) contracts onto (f a, refl):
 *                       watch the whole column slide to a point.
 *                       [isContrSingl; Carrier≃ : A ≃ Carrier f]
 *   bind the INPUT   —  fiber f b over each b, with the three-valued
 *                       census the corpus repaired its own law to:
 *                       empty / one / crowded.  Contractible everywhere
 *                       ⇔ equivalence.  [शेष; निःशेषः→समता; SakalaVikalaDesa]
 *
 * The examples are the corpus's own priced cases, finite and exact:
 *   collapse : Bool → Unit   the loss is exactly one bit  [Sesa §5]
 *   not      : Bool → Bool   an equivalence: every fibre a point
 *   emb      : Fin 3 → Fin 5 empty and one — never crowded
 *   fold     : Fin 4 → Fin 2 crowded fibres: the drop is real
 */

const EXAMPLES = [
  {
    id: "collapse", label: "collapse : Bool → Unit",
    cite: "Sesa §5 — शेष tt ≃ Bool: the loss is exactly one bit",
    dom: ["true", "false"], cod: ["tt"], f: () => 0,
  },
  {
    id: "not", label: "not : Bool → Bool",
    cite: "an equivalence — every fibre contractible [निःशेषः→समता]",
    dom: ["true", "false"], cod: ["true", "false"], f: (i) => 1 - i,
  },
  {
    id: "emb", label: "suc-embed : Fin 3 → Fin 5",
    cite: "empty and one — the two refusals fail apart [SamataDvidha]",
    dom: ["0", "1", "2"], cod: ["0", "1", "2", "3", "4"], f: (i) => i + 1,
  },
  {
    id: "fold", label: "half : Fin 4 → Fin 2",
    cite: "crowded fibres — the drop is real and priced [ForgetfulCompression]",
    dom: ["0", "1", "2", "3"], cod: ["0", "1"], f: (i) => i >> 1,
  },
];

export function mountFibreLaw(host, opts) {
  const { dark, tint } = opts;
  host.innerHTML = "";
  const bar = document.createElement("div");
  bar.style.cssText = "display:flex;gap:8px;flex-wrap:wrap;align-items:center;" +
    "font:12px sans-serif;margin-bottom:8px";
  const wrap = document.createElement("div");
  wrap.style.cssText = "position:relative;height:360px;background:var(--card);" +
    "border:1px solid var(--line);border-radius:8px;overflow:hidden";
  const cv = document.createElement("canvas");
  cv.style.cssText = "width:100%;height:100%;display:block";
  const cap = document.createElement("div");
  cap.style.cssText = "font:italic 12px var(--serif);color:var(--ink-dim);margin-top:6px";
  wrap.append(cv);
  host.append(bar, wrap, cap);

  let ex = EXAMPLES[0];
  let binding = "input";   // input | output
  let sel = 0;             // selected a : A (for the output binding)
  let anim = 0;            // 0..1 contraction phase
  let raf = null;

  const btn = (label, on, act) => {
    const b = document.createElement("button");
    b.textContent = label;
    b.style.cssText = "font:12px sans-serif;padding:2px 10px;border:1px solid " +
      (on ? "var(--accent)" : "var(--line)") + ";border-radius:10px;background:" +
      (on ? "var(--hl)" : "none") + ";color:var(--ink);cursor:pointer";
    b.onclick = act;
    return b;
  };

  function renderBar() {
    bar.innerHTML = "";
    for (const e of EXAMPLES) {
      bar.append(btn(e.label, ex.id === e.id, () => { ex = e; sel = 0; restart(); }));
    }
    const sp = document.createElement("span");
    sp.textContent = "bind:";
    sp.style.color = "var(--ink-dim)";
    bar.append(sp);
    bar.append(btn("output  Σb (f a ≡ b)", binding === "output",
      () => { binding = "output"; restart(); }));
    bar.append(btn("input  fiber f b", binding === "input",
      () => { binding = "input"; restart(); }));
  }

  function restart() {
    renderBar();
    anim = 0;
    if (raf) cancelAnimationFrame(raf);
    const tick = () => {
      anim = Math.min(1, anim + 0.02);
      draw();
      if (anim < 1) raf = requestAnimationFrame(tick);
    };
    if (matchMedia("(prefers-reduced-motion: reduce)").matches) { anim = 1; draw(); }
    else raf = requestAnimationFrame(tick);
  }

  function census(fib) {
    if (fib.length === 0) return ["empty", "#9e2b25"];
    if (fib.length === 1) return ["one", "#2e6e4e"];
    return ["crowded", "#8a6d1f"];
  }

  function draw() {
    const dpr = devicePixelRatio || 1;
    const W = cv.clientWidth, H = cv.clientHeight;
    cv.width = W * dpr; cv.height = H * dpr;
    const g = cv.getContext("2d");
    g.scale(dpr, dpr);
    g.clearRect(0, 0, W, H);
    const mono = getComputedStyle(document.body).getPropertyValue("--mono");
    const ink = dark() ? "#e8e3d8" : "#23212b";
    const dim = dark() ? "#9a92a8" : "#6b6478";

    const ax = W * 0.22, bx = W * 0.78;
    const ay = (i) => 60 + i * ((H - 110) / Math.max(ex.dom.length - 1, 1));
    const by = (j) => 60 + j * ((H - 110) / Math.max(ex.cod.length - 1, 1));

    g.font = "600 13px " + mono; g.fillStyle = dim; g.textAlign = "center";
    g.fillText("A", ax, 28); g.fillText("B", bx, 28);

    // arrows f
    ex.dom.forEach((_, i) => {
      const j = ex.f(i);
      g.globalAlpha = 0.45; g.strokeStyle = dim; g.lineWidth = 1;
      g.beginPath(); g.moveTo(ax + 10, ay(i));
      g.quadraticCurveTo(W / 2, (ay(i) + by(j)) / 2, bx - 12, by(j)); g.stroke();
      g.globalAlpha = 1;
    });

    if (binding === "input") {
      // fibres over each b, drawn AT b, with the three-valued census
      ex.cod.forEach((bl, j) => {
        const fib = ex.dom.map((_, i) => i).filter((i) => ex.f(i) === j);
        const [word, color] = census(fib);
        // halo sized by fibre, colored by census
        g.beginPath(); g.arc(bx, by(j), 10 + fib.length * 7 * anim, 0, Math.PI * 2);
        g.strokeStyle = color; g.setLineDash(word === "empty" ? [3, 3] : []);
        g.lineWidth = 1.5; g.stroke(); g.setLineDash([]);
        // the fibre's members, pulled next to b
        fib.forEach((i, k) => {
          const fx = bx + (k - (fib.length - 1) / 2) * 16 * anim;
          const fy = by(j) - (18 + 8 * anim);
          g.beginPath(); g.arc(fx, fy, 4, 0, Math.PI * 2);
          g.fillStyle = tint(ex.dom[i]); g.fill();
          g.font = "10px " + mono; g.fillStyle = dim; g.textAlign = "center";
          g.fillText(ex.dom[i], fx, fy - 7);
        });
        g.beginPath(); g.arc(bx, by(j), 5, 0, Math.PI * 2);
        g.fillStyle = tint(bl); g.fill();
        g.font = "11px " + mono; g.fillStyle = ink; g.textAlign = "left";
        g.fillText(bl, bx + 14, by(j) + 4);
        g.font = "italic 10.5px " + mono; g.fillStyle = color;
        g.fillText(word, bx + 14, by(j) + 17);
      });
      // domain
      ex.dom.forEach((al, i) => {
        g.beginPath(); g.arc(ax, ay(i), 5, 0, Math.PI * 2);
        g.fillStyle = tint(al); g.fill();
        g.font = "11px " + mono; g.fillStyle = ink; g.textAlign = "right";
        g.fillText(al, ax - 12, ay(i) + 4);
      });
      const allOne = ex.cod.every((_, j) =>
        ex.dom.filter((_, i) => ex.f(i) === j).length === 1);
      cap.textContent = allOne
        ? "every fibre contractible — f is an equivalence, and the input binding is as free as the output one [निःशेषः→समता]"
        : "the non-singleton fibres ARE the residual: what the collapse owes, drawn where it lives [शेष] · " + ex.cite;
    } else {
      // output binding: for the selected a, the whole column Σb (f a ≡ b)
      // starts spread over B and contracts onto (f a, refl).
      ex.dom.forEach((al, i) => {
        g.beginPath(); g.arc(ax, ay(i), i === sel ? 7 : 5, 0, Math.PI * 2);
        g.fillStyle = tint(al); g.fill();
        if (i === sel) { g.strokeStyle = ink; g.lineWidth = 1.5; g.stroke(); }
        g.font = "11px " + mono; g.fillStyle = ink; g.textAlign = "right";
        g.fillText(al, ax - 12, ay(i) + 4);
      });
      const target = ex.f(sel);
      ex.cod.forEach((bl, j) => {
        // each candidate pair (b, path?) slides toward f a
        const yStart = by(j), yEnd = by(target);
        const y = yStart + (yEnd - yStart) * anim;
        const alpha = j === target ? 1 : Math.max(0, 1 - anim * 1.3);
        if (alpha <= 0) return;
        g.globalAlpha = alpha;
        g.beginPath(); g.arc(bx, y, 5, 0, Math.PI * 2);
        g.fillStyle = tint(bl); g.fill();
        g.font = "11px " + mono; g.fillStyle = ink; g.textAlign = "left";
        g.fillText(j === target && anim > 0.9 ? `(${bl}, refl)` : bl, bx + 12, y + 4);
        g.globalAlpha = 1;
      });
      g.font = "italic 12px " + mono; g.fillStyle = dim; g.textAlign = "center";
      g.fillText(`Σ b (f ${ex.dom[sel]} ≡ b)`, W / 2, H - 22);
      cap.textContent =
        "the output binding is contractible for EVERY map — carrying the value " +
        "and its witness is free, no hypothesis [isContrSingl; Carrier≃ : A ≃ Carrier f]. " +
        "Click another element of A to re-run the contraction.";
    }
  }

  cv.onclick = (e) => {
    if (binding !== "output") return;
    const rect = cv.getBoundingClientRect();
    const my = e.clientY - rect.top;
    const ay = (i) => 60 + i * ((cv.clientHeight - 110) / Math.max(ex.dom.length - 1, 1));
    let best = 0, bd = 1e9;
    ex.dom.forEach((_, i) => {
      const d = Math.abs(ay(i) - my);
      if (d < bd) { bd = d; best = i; }
    });
    sel = best; restart();
  };

  restart();
}
