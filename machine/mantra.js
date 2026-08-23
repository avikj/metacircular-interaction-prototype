// मन्त्रः — the spell layer over नाडी: one dense glyph regenerates a full
// typed kernel interaction.  A mantra is a name that, run, produces its
// content (सारणी वा क्रिया; README movement 39); and by movement 60 a
// modality owes a नष्ट/उद्दिष्ट round-trip — उद्दिष्ट unranks a spell into
// its conduit command, नष्ट ranks a command back to its spell, and the
// two compose to the identity or the channel is lossy.  So this codec is
// checkable, not decorative: `mantra --check` verifies नष्ट∘उद्दिष्ट = id
// on every spell.
//
// The point (owner, 2026-08-23): at the limit an agent says a spell, not
// English and not a JSON blob — highest semantic content per symbol, on
// both sides, because the kernel wants typed terms and the agents share
// the vocabulary.  Inference-time context is already the regime shift;
// the English was only ever scaffolding on the wire.
//
//   node machine/mantra.js <glyph> [arg]     say one spell to the machine
//   node machine/mantra.js --table           the spellbook
//   node machine/mantra.js --check           round-trip every spell
//
// Talks to the warm conduit at NADI_SOCK (default /tmp/nadi.sock).

const net = require("net");
const SOCK = process.env.NADI_SOCK || "/tmp/nadi.sock";

// the spellbook: glyph → { gloss, source, cmd(arg) → conduit query,
//                          rank(query) → glyph|null for the नष्ट direction }
const SPELLS = {
  "रूप": {            // rūpa — form; the kernel's type of an expression
    gloss: "form — infer the type",
    source: "rūpa, ordinary Skt; the form a thing shows",
    cmd: (a) => ({ cmd: "infer", expr: a }),
    rank: (q) => (q.cmd === "infer" ? "रूप" : null),
  },
  "सार": {            // sāra — essence; the normal form
    gloss: "essence — normalize",
    source: "sāra, the essence/pith",
    cmd: (a) => ({ cmd: "norm", expr: a }),
    rank: (q) => (q.cmd === "norm" ? "सार" : null),
  },
  "छिद्र": {          // chidra — gap; the open holes
    gloss: "gaps — all open goals",
    source: "chidra, an aperture/lacuna",
    cmd: () => ({ cmd: "goals" }),
    rank: (q) => (q.cmd === "goals" ? "छिद्र" : null),
  },
  "आकाङ्क्षा": {      // ākāṅkṣā — expectancy; what one hole demands
    gloss: "expectancy — the type a hole wants",
    source: "ākāṅkṣā, the syntactic-semantic expectancy of a slot (Mīmāṃsā)",
    cmd: (a) => ({ cmd: "goal", id: Number(a) }),
    rank: (q) => (q.cmd === "goal" ? "आकाङ्क्षा" : null),
  },
  "प्रवेश": {         // praveśa — entry; load a module
    gloss: "entry — load a module warm",
    source: "praveśa, entering",
    cmd: (a) => ({ cmd: "load", file: a }),
    rank: (q) => (q.cmd === "load" ? "प्रवेश" : null),
  },
};

// उद्दिष्ट — unrank: spell (+ arg) → the conduit command it regenerates.
function uddista(glyph, arg) {
  const s = SPELLS[glyph];
  if (!s) throw new Error("अज्ञात-मन्त्रः (unknown spell): " + glyph);
  return s.cmd(arg);
}

// नष्ट — rank: a conduit command → the spell that generates it.
function nasta(query) {
  for (const g of Object.keys(SPELLS)) {
    const r = SPELLS[g].rank(query);
    if (r) return r;
  }
  return null;
}

function ask(query) {
  return new Promise((resolve, reject) => {
    const conn = net.createConnection(SOCK);
    let out = "";
    conn.on("connect", () => conn.write(JSON.stringify(query) + "\n"));
    conn.on("data", (d) => (out += d.toString("utf8")));
    conn.on("end", () => resolve(out));
    conn.on("error", reject);
  });
}

function condense(out) {
  const lines = [];
  for (const line of out.split("\n")) {
    if (!line.trim()) continue;
    try {
      const j = JSON.parse(line);
      if (j.kind === "DisplayInfo" && j.info) {
        const i = j.info;
        if (i.kind === "InferredType" && i.expr) lines.push("⊢ " + i.expr);
        else if (i.kind === "NormalForm" && i.expr) lines.push("↝ " + i.expr);
        else if (i.kind === "GoalSpecific" && i.goalInfo && i.goalInfo.type)
          lines.push("? " + i.goalInfo.type);
        else if (i.kind === "AllGoalsWarnings") {
          const gs = (i.visibleGoals || []).map(
            (g) => "  ?" + (g.constraintObj && g.constraintObj.id !== undefined ? g.constraintObj.id : "?") + " : " + (g.type || ""));
          lines.push(gs.length ? "छिद्राणि:\n" + gs.join("\n") : "छिद्रं नास्ति (no gaps)");
        } else if (i.kind === "Error")
          lines.push("✗ " + ((i.error && i.error.message) || JSON.stringify(i).slice(0, 300)));
      } else if (j.kind === "InteractionPoints" && j.interactionPoints && j.interactionPoints.length)
        lines.push("holes: " + j.interactionPoints.map((p) => p.id).join(" "));
    } catch (e) {}
  }
  return lines.join("\n");
}

async function main() {
  const [glyph, arg] = process.argv.slice(2);
  if (glyph === "--table") {
    for (const g of Object.keys(SPELLS))
      console.log(g.padEnd(10), "—", SPELLS[g].gloss, " [" + SPELLS[g].source + "]");
    return;
  }
  if (glyph === "--check") {
    // नष्ट ∘ उद्दिष्ट = id on every spell — movement 60's law, checked.
    let ok = true;
    for (const g of Object.keys(SPELLS)) {
      const q = uddista(g, g === "आकाङ्क्षा" ? "0" : "x");
      const back = nasta(q);
      const good = back === g;
      ok = ok && good;
      console.log((good ? "✓" : "✗") + " " + g + "  नष्ट(उद्दिष्ट) = " + back);
    }
    console.log(ok ? "\nचक्रं पूर्णम् — the round trip closes on every spell." : "\nLOSSY: a spell fails नष्ट∘उद्दिष्ट.");
    return;
  }
  if (!glyph) {
    console.log("say a spell: रूप <expr> | सार <expr> | छिद्र | आकाङ्क्षा <id> | प्रवेश <file>");
    console.log("or --table | --check");
    return;
  }
  const q = uddista(glyph, arg);
  const out = await ask(q).catch((e) => { console.error("नाडी मौनम् (no conduit):", e.message); process.exit(1); });
  console.log(condense(out));
}

main();
